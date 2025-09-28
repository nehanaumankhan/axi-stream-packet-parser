#include <stdio.h>
#include <stdint.h>

typedef struct parsed_packet
{
    uint8_t version, ihl;
    uint8_t protocol;
    uint16_t total_length;
    uint32_t src_ip_addr;
    uint32_t dest_ip_addr;
    uint8_t src_mac[6];
    uint8_t dest_mac[6];
    uint16_t eth_type;
    uint8_t payload[14];
} data;

void print_parsed_packet(data *pkt) {
    printf("Ethernet Header:\n");
    printf("Destination MAC: %02x:%02x:%02x:%02x:%02x:%02x\n", pkt->dest_mac[0], pkt->dest_mac[1], pkt->dest_mac[2], pkt->dest_mac[3], pkt->dest_mac[4], pkt->dest_mac[5]);
    printf("Source MAC: %02x:%02x:%02x:%02x:%02x:%02x\n", pkt->src_mac[0], pkt->src_mac[1], pkt->src_mac[2], pkt->src_mac[3], pkt->src_mac[4], pkt->src_mac[5]);
    printf("EtherType: %04x\n", pkt->eth_type);
    printf("\nIP Header:\n");
    printf("Version: %d\n", pkt->version);
    printf("IHL: %d\n", pkt->ihl);
    printf("Total Length: %d\n", pkt->total_length);
    printf("Protocol: %d\n", pkt->protocol);
    printf("Source IP: %d.%d.%d.%d\n", (pkt->src_ip_addr >> 24) & 0xFF, (pkt->src_ip_addr >> 16) & 0xFF, (pkt->src_ip_addr >> 8) & 0xFF, pkt->src_ip_addr & 0xFF);
    printf("Destination IP: %d.%d.%d.%d\n", (pkt->dest_ip_addr >> 24) & 0xFF, (pkt->dest_ip_addr >> 16) & 0xFF, (pkt->dest_ip_addr >> 8) & 0xFF, pkt->dest_ip_addr & 0xFF);
    printf("\nPayload (first 14 bytes):\n");
    for(int i=0; i<14; i++) {
        printf("%02x ", pkt->payload[i]);
    }
    printf("\n");
}

void packet_parser(uint8_t *inp_packet) {
    data pkt;
    data *pkt_ptr = &pkt;
    // Parse Ethernet Header
    for(int i=0; i<6; i++) {
        pkt.dest_mac[i] = inp_packet[i];
        pkt.src_mac[i] = inp_packet[i+6];
    }
    pkt.eth_type = (inp_packet[12] << 8) | inp_packet[13];
    // Parse IP Header
    pkt.version = (inp_packet[14] >> 4) & 0x0F;
    pkt.ihl = inp_packet[14] & 0x0F;
    pkt.total_length = (inp_packet[16] << 8) | inp_packet[17];
    pkt.protocol = inp_packet[23];
    pkt.src_ip_addr = (inp_packet[26] << 24) | (inp_packet[27] << 16) | (inp_packet[28] << 8) | inp_packet[29];
    pkt.dest_ip_addr = (inp_packet[30] << 24) | (inp_packet[31] << 16) | (inp_packet[32] << 8) | inp_packet[33];
    // Parse Payload (14 bytes)
    for(int i=0; i<14; i++) {
        pkt.payload[i] = inp_packet[i+34];
    }
    print_parsed_packet(pkt_ptr);
    return;
}

int main() {
    printf("Packet Parser Application\n");
    uint8_t packet[48] = {
                        //Ethernet Header
                     0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77,
                     0x88, 0x99, 0xaa, 0xbb, 0x08, 0x00,
                        //IP Header
                     0x45, 0x00, 0x00, 0x3c, 0x1c, 0x46, 0x40, 0x00,
                     0x40, 0x06, 0xb1, 0xe6, 0xc0, 0xa8, 0x00, 0x68,
                     0xc0, 0xa8, 0x00, 0x01, 
                        //Payload (14 bytes)
                     0x00, 0x50, 0xd4, 0x31, 0x5e, 0x6b, 0xc2, 0x3a, 
                     0x00, 0x00, 0x00, 0x00, 0xa0, 0x02}; 
    packet_parser(&packet[0]);
    return 0;
}