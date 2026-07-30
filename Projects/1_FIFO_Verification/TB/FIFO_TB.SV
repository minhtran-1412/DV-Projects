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

integer i;

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

// Clock Generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Waveform Dump
initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, fifo_tb);
end

// Main Test
initial begin

    rst_n = 0;
    wr_en = 0;
    rd_en = 0;
    din   = 0;

    #20;
    rst_n = 1;

    // Random Write
    for(i=0;i<8;i++) begin
        @(posedge clk);
        wr_en = 1;
        rd_en = 0;
        din = $urandom_range(0,255);

        $display("[%0t] WRITE : %0d",$time,din);
    end

    @(posedge clk);
    wr_en = 0;

    // Read
    for(i=0;i<8;i++) begin
        @(posedge clk);
        rd_en = 1;

        $display("[%0t] READ : %0d",$time,dout);
    end

    @(posedge clk);
    rd_en = 0;

    #20;

    $display("-----------------------------");
    $display("Simulation Finished");
    $display("-----------------------------");

    $finish;

end

endmodule