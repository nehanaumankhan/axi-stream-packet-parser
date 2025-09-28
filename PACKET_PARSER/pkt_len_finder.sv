// From beat 1, which is the header, we can extract packet length
// This is required to keep track of incoming packets
// This will help keep track of data losses
// Furthermore, till the time we are receiving payload (beats)
// Our Packet parser pipeline will remain stalled,
// Until new packet's header arrives after the tlast bit.
// Using a counter (pkt_len/TDATA_WIDTH), 
// we can activate the stalled pipeline stages

module pkt_len_finder (
input  logic [TDATA_WIDTH:0] header_slice,	  // Beat 1 = Header 
output logic [MAX_PKT_LENGTH:0] pkt_length    // Maximum Packet Length
);