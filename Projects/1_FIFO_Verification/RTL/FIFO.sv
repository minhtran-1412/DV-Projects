`timescale 1ns/1ps

module fifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH      = 8
)(
    input  logic                  clk,
    input  logic                  rst_n,
    input  logic                  wr_en,
    input  logic                  rd_en,
    input  logic [DATA_WIDTH-1:0] din,

    output logic [DATA_WIDTH-1:0] dout,
    output logic                  full,
    output logic                  empty
);

localparam ADDR_WIDTH = $clog2(DEPTH);

logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];

logic [ADDR_WIDTH-1:0] wr_ptr;
logic [ADDR_WIDTH-1:0] rd_ptr;

logic [ADDR_WIDTH:0] count;

assign full  = (count == DEPTH);
assign empty = (count == 0);

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        wr_ptr <= 0;
        rd_ptr <= 0;
        count  <= 0;
        dout   <= 0;
    end
    else begin

        // Write only
        if(wr_en && !rd_en && !full) begin
            mem[wr_ptr] <= din;
            wr_ptr <= wr_ptr + 1;
            count <= count + 1;
        end

        // Read only
        else if(rd_en && !wr_en && !empty) begin
            dout <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
            count <= count - 1;
        end

        // Read + Write
        else if(rd_en && wr_en && !full && !empty) begin
            mem[wr_ptr] <= din;
            dout <= mem[rd_ptr];
            wr_ptr <= wr_ptr + 1;
            rd_ptr <= rd_ptr + 1;
        end

    end
end

endmodule