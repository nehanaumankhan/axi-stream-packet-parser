import pp_package::*;

module beat_shift_register
	#(parameter DEPTH = 4)
	(
	input 	logic 							clk,
	input 	logic 							rst,
	input 	logic 							write_en,
	input 	logic [TDATA_WIDTH-1:0]  		data_in,
	output 	logic [TDATA_WIDTH*DEPTH-1:0] 	data_out 
	);


// BSR memory buffer
logic [TDATA_WIDTH-1:0] 	buffer [0:DEPTH-1];         // Storage array for BSR data
logic [$clog2(DEPTH)-1:0] 	write_pointer;	 			// Pointers for reading and writing

// -------------------------------
// BSR Write Logic
// -------------------------------
always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
        write_pointer <= 0; // Reset write pointer
        // Initialize buffer contents to zero
        for (int k = 0; k < DEPTH; k++)
            buffer[k] <= 0;
    end 
    else if (write_en) begin
        buffer[write_pointer] = data_in; // Store input data at write pointer
        // Increment and wrap-around write pointer
        if (write_pointer == DEPTH-1) 
        	write_pointer <= 0;
        else
            write_pointer <= write_pointer + 1;
    end
end

// -------------------------------
// BSR Read Logic
// -------------------------------

genvar i;
generate
    for (i = 0; i < DEPTH; i++) begin : BYPASS
        assign data_out[(i+1)*TDATA_WIDTH-1 : i*TDATA_WIDTH] =
            (write_en && (write_pointer == i)) ? data_in : buffer[i];
    end
endgenerate

endmodule