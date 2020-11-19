#include "headers/scan/types.h"

Scan::Scan(const NetworkInterface &interface, const IPv4Address &address, int port)
    /* Setup the values */
    : host_to_scan(address), iface(interface), currentPort(port) {
}

void Scan::__send_packet(const NetworkInterface &interface, const IPv4Address &dest_ip, int currentPort) {
	/* Retrieve the addresses */
	NetworkInterface::Info info = iface.addresses();

    /* Create the sender  */
    PacketSender sender(iface, 1, 0); /* interface, timeout, usec */
    /* Allocate the IP pdu */
    IP ip_send = IP(dest_ip, info.ip_addr) / TCP();
    /* Get the TCP pdu */
    TCP& tcp_send = ip_send.rfind_pdu<TCP>();
    /* Set the SYN flag */
    tcp_send.set_flag(TCP::SYN, 1);
    /* Use a random source port */
    tcp_send.sport(44583);

    /* Set the new port and send the packet */
    tcp_send.dport(currentPort);
    pdu_recv = sender.send_recv(ip_send);
}

int Scan::__analyze_packet(void) {
	/* Grab the server PDU */
	__send_packet(iface, host_to_scan, currentPort);
	
	/* Find the layers we want */
	const IP& ip = pdu_recv->rfind_pdu<IP>();
	const TCP& tcp = pdu_recv->rfind_pdu<TCP>();

	/* Check if the host that we're scanning sent */
	if(ip.src_addr() == host_to_scan) {
		/* If RST is on the port is closed */
		if(tcp.get_flag(TCP::RST)) {
			/* This value is grabbed by Ruby-QML */
			return -1;
		}

		/* If SYN/ACK flag is sent then the port is open */
		else if(tcp.flags() == (TCP::SYN | TCP::ACK)) {
			/* This value is grabbed by Ruby-QML */
			return tcp.sport();
		}
	}
	/* 35 milliseconds timeout */
	/** TODO Get the timeout from the QML window TODO **/
	std::this_thread::sleep_for(std::chrono::milliseconds(35));
}

void Scan::__print(void) {
    std::cout << "FIN: " << SCAN::FIN << std::endl;
    std::cout << "ACK: " << SCAN::ACK << std::endl;
}

Scan::~Scan() {
}

/* Functions grabbed from swig */
Scan initialize(char *ip_addr, char *port) {
	IPv4Address ip(ip_addr);

    /* Resolve the interface which will be our gateway */
    NetworkInterface iface(ip);

    /* Convert to integer */
    int currentPort = atoi(port);
	return Scan(iface, ip_addr, currentPort);
}

void print(char *ip_addr, char *port) {
	Scan dummy = initialize(ip_addr, port);
	dummy.__print();
}

int analyze_packet(char *ip_addr, char *port) {
	Scan dummy = initialize(ip_addr, port);
	dummy.__analyze_packet();
}
