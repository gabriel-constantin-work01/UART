`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2026 04:25:49 PM
// Design Name: 
// Module Name: UART_tb
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


module UART_tb();
    reg clk = 0;
    reg reset;
    reg [7:0] parallel_in;
    wire [7:0] parallel_out;
    reg send;
    wire usb_in;        // ← wire not reg
    wire usb_out;
    
    assign usb_in = usb_out;
    
    always #5 clk = ~clk;
    
    UART uut(
        .clk(clk),
        .reset(reset),
        .parallel_in(parallel_in),
        .parallel_out(parallel_out),
        .send(send),
        .usb_in(usb_in),
        .usb_out(usb_out)
    );
    
    task send_byte(input [7:0] data);
        begin
            parallel_in = data;
            send = 1; 
            #30000000;
            send = 0;
            #15000000;
        end
    endtask
    
    initial begin
        reset = 1;
        send = 0;
        parallel_in = 0;
        #30000000;
        reset = 0;
        #30000000;
        send_byte(8'hAA);
        send_byte(8'h55);
        send_byte(8'hFF);
        #1000000;
        $finish;
    end
endmodule
