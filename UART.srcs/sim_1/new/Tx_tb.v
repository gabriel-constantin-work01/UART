`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2026 07:53:17 PM
// Design Name: 
// Module Name: Tx_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Tx_tb();

reg clk = 0;
reg reset;
reg start;
reg [7:0] tx_parallel_in;

wire tx_serial_out;
wire busy;

always #5 clk = ~clk;

Tx uut(
    .clk(clk),
    .reset(reset),
    .start(start),
    .tx_parallel_in(tx_parallel_in),
    .busy(busy),
    .tx_serial_out(tx_serial_out)
    );

    // TODO: Tesbench Logic
endmodule
