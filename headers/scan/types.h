#ifndef TYPES_H_
#define TYPES_H_

#include <iostream>
#include <vector>
#include <chrono>
#include <thread>
#include <tins/tins.h>

using namespace Tins;

/* The value returning the port scanned */
/* If 'ret' is -1 the port is closed */
// int ret;

enum SCAN {
    SYN      = 0, /* syn */
    FIN      = 1, /* fin */
    XMAS     = 2, /* xmas */
    NIL      = 3, /* null */
    CONN     = 4, /* tcp connect */
    UDPSCAN  = 5, /* udp */
    ACK      = 6, /* ack */
    WIN      = 7, /* window */
    HOST     = 8, /* host */
    MAI      = 9  /* maimon */
};

class Scan {
public:
    /**
        @Constructor
        @desc: Sets up options
        @param: interface -> The interface to scan from
        @param: address -> The ip address to scan
        @param: port -> The port to scan
    **/
    Scan(const NetworkInterface &interface, const IPv4Address &address, int port);

    /**
        @Destructor
        @desc: Deletes all public and private variables
    **/
    ~Scan();
    
    void __print(void);

    /**
        @func: analyze_packet
        @desc: Retrieves the desired data from the server PDU
    **/
    int __analyze_packet(void);
private:
    /**
        @func: send_packet
        @desc: Sets up the host and packet sender configurations
        @param: interface -> The interface to scan from
        @param: dest_ip -> The ip address to scan
    **/
    void __send_packet(const NetworkInterface &interface, const IPv4Address &dest_ip, int currentPort);

    /* Internal private variables */
    NetworkInterface iface; /* Interface to scan from */
    IPv4Address host_to_scan; /* Host to scan */
    int currentPort; /* Port to scan */
    PDU *pdu_recv; /* PDU received from the server */
};

#endif // TYPES_H_