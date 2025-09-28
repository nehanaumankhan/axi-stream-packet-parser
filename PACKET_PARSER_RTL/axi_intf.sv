//Synchronous Non-Coherent Interconnect protocol 
//Follws valid-ready handshaking 
// Maximum transmission speed = DATA_WIDTH(128) bits × CLOCK (250M) = 32 Gbps = 4 GB/s (theoretical maximum)

import pp_package::*;
interface axi_intf(
	logic                        clk,       // Global clock for all transfers
	logic                        rst,       // Active-low reset for synchronous reset of interface signals

	logic   [TDATA_WIDTH-1 : 0] tdata,       // DATA BEADS: main payload data bus
	logic 	                    tlast,       // INDICATES LAST BEAD OF THE DATA PACKET
	logic [(TDATA_WIDTH/8)-1:0] tstrb,       // SIGNIFIES THE NUMBER OF ACTIVE DATA LINES (byte qualifiers)
	logic   [TUSER_WIDTH-1 : 0] tuser,       // USER DEFINED SIDEBAND BUS - CARRIES EXTRA INFO OTHER THAN TDATA
	logic 	                   tvalid,       // ASSALAM O ALAIKUM : Master says "data is valid and ready to send"
	logic 	                   tready       // WALAIKUM ASSALAM : Slave replies "ready to accept data"
);
	// Slave perspective of the bus
	modport slave(
		input    tvalid,  // Slave observes valid from master
		input    tdata,   // Slave receives the data
		input    tlast,   // Slave sees end-of-packet indicator
		input    tstrb,   // Slave uses byte-enable info
	    input    tuser,   // Slave interprets sideband info
		output   tready   // Slave asserts ready when it can accept data
	);

	// Master perspective of the bus
	modport master(
		output   tvalid,  // Master asserts valid when data is present
		output   tdata,   // Master drives the data onto the bus
		output   tlast,   // Master signals the last transfer of a packet
		output   tstrb,   // Master specifies which bytes of tdata are active
		output   tuser,   // Master drives any extra sideband information
		input    tready   // Master waits until slave asserts ready
	);

endinterface : axi_intf