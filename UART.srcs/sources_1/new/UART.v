`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2026 08:12:27 PM
// Design Name: 
// Module Name: UART
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


module UART(
    input clk,
    input reset, // btnC
    input [7:0] parallel_in, // switch
    output [7:0] parallel_out, // leds
    input send, // btnD
    input usb_in, // PC
    output usb_out // PC
    );
    
   wire deB_reset; // Clean reset signal
   wire deB_send; // Clean send signal
   wire sync_send; // Synchronized send signal
   wire sync_reset; // Synchronized reset signal
   wire sync_usb_in; // Synchronized USB signal to FPGA
   wire busy; // Tx cannot load new data
   wire done; // Rx is done sending data
   wire serial; // Serial data communication from Tx to Rx
   
`ifndef SYNTHESIS // For easier testbench
   assign sync_reset = reset;
   assign sync_send = send;
   
`else 
// Debouncer for send button instantiation 
deBouncer send_btn(
    .clk(clk),
    .reset(deB_reset),
    .pulse_in(sync_send),
    .pulse_out(deB_send)
    
);

// Debouncer for reset button instantiation 
deBouncer reset_btn(
    .clk(clk),
    .reset(1'b0),
    .pulse_in(sync_reset),
    .pulse_out(deB_reset)
    
);
`endif

// Transmitter module instantiation
Tx tx_inst(
    .clk(clk),
    .reset(deB_reset),
    .tx_parallel_in(parallel_in),
    .start(deB_send),
    .busy(busy),
    .tx_serial_out(serial)
);

// Receiver module instantiation
Rx rx_inst(
    .clk(clk),
    .reset(deB_reset),
    .rx_serial_in(sync_usb_in),
    .rx_parallel_out(parallel_out),
    .done(done)
);

// Sync for the send signal
sync_3ff send_sync(
    .clk(clk),
    .reset(deB_reset),
    .async_in(send),
    .sync_out(sync_send)
);

// Sync for the reset signal
sync_3ff reset_sync(
    .clk(clk),
    .reset(1'b0),
    .async_in(reset),
    .sync_out(sync_reset)
);

// Sync for the usb_in signal
sync_3ff usb_in_sync(
    .clk(clk),
    .reset(deB_reset),
    .async_in(usb_in),
    .sync_out(sync_usb_in)
);

assign usb_out = serial;
endmodule
