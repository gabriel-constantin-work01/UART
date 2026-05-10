`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2026 07:24:42 PM
// Design Name: 
// Module Name: Rx_tb
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


module Rx_tb();

    reg rx_serial_in;
    wire [7:0] rx_parallel_out;
    wire done;
    reg clk = 0;
    reg reset;
    
   wire deB_reset; // Clean reset signal
   wire deB_send; // Clean send signal
   wire busy; // Tx cannot load new data
   wire done; // Rx is done sending data
   wire serial; // Serial data communication from Tx to Rx
   
Rx uut(
    .rx_serial_in(rx_serial_in),
    .rx_parallel_out(rx_parallel_out),
    .done(done),
    .reset(reset),
    .clk(clk)
);

always #5 clk = ~clk;


initial begin
    clk = 0;
    reset = 1;
    rx_serial_in = 1'b1;
    
    #100;
    reset = 0;
    
    repeat (10) begin
        rx_serial_in = ~rx_serial_in;
        #104170;
    end

end
endmodule
