#include "headers/scan/test_scanner.h"

TestScanner::TestScanner(const NetworkInterface &interface, const IPv4Address &address, int port, int timeout, std::string type)
    /* Setup the values */
    : iface(interface), host_to_scan(address), currentPort(port), timeout(timeout), type(type) {
}

int TestScanner::run(void) {
    /* Craft and send the probe */
    return send_syns();
}

/* Send syns to the given ip address using the destination ports provided */
int TestScanner::send_syns(void) {
    /* Gets the timeout from the QML window */
    std::this_thread::sleep_for(std::chrono::milliseconds(timeout));
    
    if(!type.compare("SYN")) {
        /* TCP::SYN */
        return syn_scan();
    }
    else if(!type.compare("FIN")) {
        /* TCP::FIN */
    }
    else if(!type.compare("XMAS")) {
        /* TCP::URG, TCP::PSH, TCP::FIN */
    }
    else if(!type.compare("NIL")) {
        /* Craft a null data package */
    }
    else if(!type.compare("IP")) {
        /* IP Protocol Scan */
    }
    else if(!type.compare("MAI")) {
        /* Maimon scanning: TCP::ACK, TCP::FIN */
    }
    else {
    }
    return -1;
}

int TestScanner::syn_scan(void) {
    /* Create the sender  */
    /** HARD TODO --> Check out how to reduce timeout of the sender <-- HARD TODO **/
    PacketSender sender(iface, 1, 0); /* interface, timeout(sec), timeout(usec) */
    
    /* Retrieve the addresses */
    NetworkInterface::Info info = iface.addresses();
    /* Allocate the IP pdu */
    IP ip_send = IP(host_to_scan, info.ip_addr) / TCP();
    /* Get the TCP pdu */
    TCP& tcp_send = ip_send.rfind_pdu<TCP>();
    
    /* Set the flags according to scan type */
    tcp_send.set_flag(TCP::URG, 0);
    tcp_send.set_flag(TCP::ACK, 0);
    tcp_send.set_flag(TCP::PSH, 0);
    tcp_send.set_flag(TCP::RST, 0); /* Overkill */
    tcp_send.set_flag(TCP::FIN, 0);
    tcp_send.set_flag(TCP::SYN, 1);

    /* TODO TODO TODO TODO TODO TODO */

    /* Use a random source port */
    tcp_send.sport(44583); /* TODO -> MAKE RANDOM */

    /* Set the new port and send the packet */
    tcp_send.dport(currentPort);
    PDU *pdu_recv = sender.send_recv(ip_send);
    // TODO --> Put to a function <-- TODO //
    /*************************************************/

    /* Checks for a SYN connection */
    try {
        /* Find the layers we want */
        const IP& ip = pdu_recv->rfind_pdu<IP>();
        const TCP& tcp = pdu_recv->rfind_pdu<TCP>();
        
        /* Check if the host that we're scanning sent */
        if(ip.src_addr() == host_to_scan) {
            /* If RST is on the port is closed */
            if(tcp.get_flag(TCP::RST)) {
                /* This value is grabbed by Ruby-QML */
                return(0);
            }
            /* If SYN/ACK flag is sent then the port is open */
            else if(tcp.flags() == (TCP::SYN | TCP::ACK)) {
                /* This value is grabbed by Ruby-QML */
                return(1);
            }
        }
    }
    /* For PDU related errors */
    catch(...) {
        return(0);
    }
    return(0);
}

/**
    @func: scan
    @desc: The main executor --> The ONLY function that accessed by outside files
    @param: ip_addr -> The ip address to scan
    @param: port -> The port to scan
    @param: timeout -> The timeout between scans
    @param: type -> The type of scan (SYN, FIN, NULL..)
**/
int scan(char *ip_addr, char *port, char *timeout, char *type) {
    IPv4Address address(ip_addr);

    /* Resolve the interface which will be our gateway */
    NetworkInterface iface(address);

    /* Convert to std::string */
    std::string stype(type);

    /* Convert to integer */
    int currentPort = atoi(port);
    int mtimeout = atoi(timeout);

    /* Start the scanner */
    TestScanner scanner(iface, address, currentPort, mtimeout, stype);
    int ret = scanner.run();

    /* This value gets grabbed */
    return ret;
}
