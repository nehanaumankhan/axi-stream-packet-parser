import pp_package::*;

module packet_parser(
	axi_intf.slave pp_slave,
	axi_intf.slave pp_master,
	input logic clk, 
	input logic rst,
	input logic stage1_valid,
	input logic stage2_valid,
	input logic stage3_valid,
	input logic stall,
	input [HEADER_SLICE_WIDTH-1:0]header_slice, // input received from tdata
	output logic [METADATA_WIDTH-1:0] metadata
);


//========================================== STAGE 1 ===============================================//
// 


always_ff @(posedge clk or negedge rst) begin 
	if(~rst) begin
		metadata <= 0;
	end else if (stage_ready) 
	begin
		header_slice <= pp_slave.data;
	end
end
pkt_fifo fifo 
(
    .clk(clk),
    .rst_n(rst),
    .pop(pop),
    .push(push),
    .write_data(write_data),
    .read_data(read_data),
    .fifo_full(fifo_full),
    .fifo_empty(fifo_empty)
);
//========================================== STAGE 2 ===============================================//
// Extract Ethernet Header from header slice
 

