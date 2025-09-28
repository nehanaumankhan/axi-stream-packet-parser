`timescale 1ns/1ns

module counter_tb;

logic 				clk;
logic 				rst;
logic 			  tuser;   // pulse = 1 when packet header comes
logic [3:0] stage_ready;   // one-hot signals for 4 pipeline stages

// DUT Instantiation
counter dut(
.clk(clk),
.rst(rst),
.tuser(tuser),
.stage_ready(stage_ready)
);

always begin
	clk = ~clk;
	#5;
end

initial begin
	
clk = 1; tuser = 0; rst = 0; #10;// reset asserted
rst = 1; # 10; // reset released
tuser = 1; #10;
tuser = 0; #50;

end

endmodule