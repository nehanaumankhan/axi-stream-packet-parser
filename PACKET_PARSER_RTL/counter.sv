// -----------------------------------------------------------------------------
// Counter to generate per-stage ready signals for a 4-stage pipeline.
// When `tuser` goes high (header received), the counter starts.
// Each clock, one pipeline stage is enabled via `stage_ready` (1-hot).
// After 4 cycles, counter stops until the next `tuser` pulse.
// -----------------------------------------------------------------------------
module counter(
    input  logic clk,
    input  logic rst,
    input  logic tuser,              // pulse = 1 when packet header comes
    output logic [3:0] stage_ready   // one-hot signals for 4 pipeline stages
);

    logic enable;
    logic [1:0] count;

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            count       <= 2'b00;
            enable      <= 0;
            stage_ready <= 4'b0000;
        end 
        else begin
            if (tuser) begin
                enable      <= 1;
                count       <= 2'b00;
                stage_ready <= 4'b0000;  // first stage ready immediately
            end 
            else if (enable) begin
                case (count)
                    2'b00: stage_ready <= 4'b1000; // stage 1 ready
                    2'b01: stage_ready <= 4'b0100; // satge 2 ready
                    2'b10: stage_ready <= 4'b0010; // stage 3 ready
                    2'b11: begin
                        stage_ready <= 4'b0001;    // stage 4 (pipeline stalled) 
// pipeline will remain stalled till next tuser is received
                        enable      <= 0;       // stop counting
                    end
                endcase
                count <= count + 1;
            end
        end
    end
endmodule
