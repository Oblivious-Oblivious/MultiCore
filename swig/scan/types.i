%module types

%{
#include "types.h"
%}

class Scan {
public:
    Scan(const NetworkInterface&, const IPv4Address&, int);
    ~Scan();
    void __print(void);
    int __analyze_packet(void);
private:
    void __send_packet(const NetworkInterface&, const IPv4Address&, int);

    /* Internal private variables */
    NetworkInterface iface; /* Interface to scan from */
    IPv4Address host_to_scan; /* Host to scan */
    int currentPort; /* Port to scan */
    PDU *pdu_recv; /* PDU received from the server */
};
