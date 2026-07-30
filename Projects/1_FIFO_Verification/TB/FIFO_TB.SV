`timescale 1ns/1ps

module fifo_tb;

logic clk;
logic rst_n;

logic wr_en;
logic rd_en;

logic [7:0] din;
logic [7:0] dout;

logic full;
logic empty;

fifo dut(
    .clk(clk),
    .rst_n(rst_n),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .din(din),
    .dout(dout),
    .full(full),
    .empty(empty)
);

// Clock
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Dump waveform
initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0,fifo_tb);
end

// Test
initial begin

    rst_n = 0;
    wr_en = 0;
    rd_en = 0;
    din   = 0;

    #20;
    rst_n = 1;

    // Write 11
    @(posedge clk);
    wr_en = 1;
    din = 8'h11;

    // Write 22
    @(posedge clk);
    din = 8'h22;

    // Write 33
    @(posedge clk);
    din = 8'h33;

    @(posedge clk);
    wr_en = 0;

    // Read
    @(posedge clk);
    rd_en = 1;

    repeat(3)
        @(posedge clk);

    rd_en = 0;

    #20;

    $finish;

end

endmodule