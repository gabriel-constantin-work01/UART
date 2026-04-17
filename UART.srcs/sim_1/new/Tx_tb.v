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

Tx uut(
    .clk(clk),
    .reset(reset),
    .start(start),
    .tx_parallel_in(tx_parallel_in),
    .busy(busy),
    .tx_serial_out(tx_serial_out)
    );

    // TODO: Tesbench Logic
    
    always #5 clk = ~clk;
    
    initial begin
    
        reset = 1;
        start = 0;
        tx_parallel_in = 8'b0;
        
        #100;
        
        reset = 0;
        tx_parallel_in = 8'h55;
        start = 1;
        
        #10;
        
        start = 0;
        #1041700; // 10bits x 10ns x 10417 counts
        $finish;
    end
endmodule
