`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/08/2026 08:52:27 PM
// Design Name: 
// Module Name: sync_3ff
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

// Removes metastability

module sync_3ff(
    input clk,
    input reset,
    input async_in,
    output reg sync_out
    );
    
    reg delayed1, delayed2;
    
    always @(posedge clk)begin
        if(reset) begin
            sync_out <= 0;
            delayed1 <= 0;
            delayed2 <= 0;
        end else begin
            delayed1 <= async_in;
            delayed2 <= delayed1;
            sync_out <= delayed2;
        end
        
    end
endmodule
