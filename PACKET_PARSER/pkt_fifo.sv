module fifo #(parameter WIDTH = 592, DEPTH = 4) (
    input  logic                 clk,
    input  logic                 rst_n,
    input  logic                 pop,
    input  logic                 push,
    input  logic [WIDTH-1:0]     write_data,
    output logic [WIDTH-1:0]     read_data,
    output logic                 fifo_full,
    output logic                 fifo_empty
);

//first word fall through

    logic [WIDTH-1:0] buffer [0:DEPTH-1];
    logic [$clog2(DEPTH)-1:0] read_pointer, write_pointer;
    logic [$clog2(DEPTH):0]   count;

    // FIFO empty/full flags
    assign fifo_empty = (count == 0);
    assign fifo_full  = (count == DEPTH);
    assign read_data = buffer[read_pointer];

    // Count update
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 0;
        else if (push && !fifo_full && !(pop && !fifo_empty))
            count <= count + 1;
        else if (pop && !fifo_empty && !(push && !fifo_full))
            count <= count - 1;
        // if push && pop -> count stays same
    end

    // Write logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            write_pointer <= 0;
            for (int k = 0; k < DEPTH; k++)
                buffer[k] <= 0;
        end 
        else if (push && !fifo_full) begin
            buffer[write_pointer] <= write_data;
            if (write_pointer == DEPTH-1)
                write_pointer <= 0;         // wrap-around
            else
                write_pointer <= write_pointer + 1;
        end
    end

    // Read logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_pointer <= 0;
        end
        else if (pop && !fifo_empty) begin
            if (read_pointer == DEPTH-1)
                read_pointer <= 0;          // wrap-around
            else
                read_pointer <= read_pointer + 1;
        end
    end

endmodule
