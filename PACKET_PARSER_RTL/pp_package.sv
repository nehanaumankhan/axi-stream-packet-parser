// package.sv
package pp_package;
	parameter TDATA_WIDTH 			= 8; 		// 592 bits = 74 Bytes
	parameter HEADER_SLICE_WIDTH 	= 128; 		// 592 bits = 74 Bytes
	parameter TUSER_WIDTH 			= 128; 		// side band info 592 bits = 74 Bytes
	parameter METADATA_WIDTH 	    = 368; 		// side band info 592 bits = 74 Bytes
	parameter MAX_PKT_LENGTH		= 65535;	// Maximum data packet that can be recieved 

endpackage : pp_package;
  