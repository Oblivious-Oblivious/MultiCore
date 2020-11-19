#include <iostream>
#include <vector>
#include <chrono>
#include <thread>
#include <tins/tins.h>

using namespace Tins;

/**
    @class: Scanner
    @desc: The main class executing the SYN scanner
**/
class TestScanner {
private:
    NetworkInterface iface; /* Interface to scan from */
    IPv4Address host_to_scan; /* Host to scan */
    int currentPort; /* Port to scan */
    int timeout; /* Timeout for the scanner(in milliseconds) */
    std::string type; /* Type of scan */

public:
    /**
        @Constructor
        @desc: Sets up host and ports
        @param: interface -> The interface to scan from
        @param: address -> The ip address to scan
        @param: port -> The port to scan
        @param: timeout -> The timeout between port scans
        @param: type -> The type of scan to perform
    **/
    TestScanner(const NetworkInterface &interface, const IPv4Address &address, int port, int timeout, std::string type);

    /**
        @func: send_syns
        @desc: Constructs the packet and sends it to the port
        @returns: A boolean signaling the port state
    **/
    int send_syns(void);

    /**
        @func: syn_scan
        @desc: Completes a tcp SYN scan
        @returns: A boolean signaling the port state
    **/
    int syn_scan(void);

    /**
        @func: run
        @desc: Executes the scanner
    **/
    int run(void);
};
