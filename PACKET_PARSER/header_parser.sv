module header_parser(
	input logic clk, 
	input logic rst,
	input logic stage1_valid,	//from counter ; stage_ready[0]
	input logic stage2_valid,	//from counter ; stage_ready[1]
	input logic stage3_valid,	//from counter ; stage_ready[2]
	input logic stall,			//from counter ; stage_ready[4]
	input [HEADER_SLICE_WIDTH-1:0]header_slice, // from fifo tdata
	output logic [METADATA_WIDTH-1:0] metadata 	//to tuser
	);


endmodule