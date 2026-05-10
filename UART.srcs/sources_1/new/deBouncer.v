`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2026 12:23:56 PM
// Design Name: 
// Module Name: deBouncer
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


module deBouncer(
    input clk,
    input reset,
    input pulse_in,
    output reg pulse_out
    );
    
    // 100MHz x 10ms debounce time = 10^6 cycles => 20bits reg
    parameter counter_max = 1000000; 

    reg [19:0] debounce_counter;
    
    reg clean_state;
    reg clean_state_delayed; 
    
    always @(posedge clk) begin
        if(reset) begin
            debounce_counter <= 20'b0;
            clean_state <= 1'b0;
            clean_state_delayed <= 1'b0;
            pulse_out <= 1'b0;
        end else begin
            
            // --- 1. DEBOUNCE LOGIC ---
            // If the raw input matches our clean state, reset the timer.
            if (pulse_in == clean_state) begin
                debounce_counter <= 20'b0;
            end 
            // If it's different, start counting!
            else begin
                if (debounce_counter < counter_max) begin
                    debounce_counter <= debounce_counter + 1;
                end else begin
                    // Once we hit the max count, update the clean state
                    clean_state <= pulse_in;
                    debounce_counter <= 20'b0;
                end
            end
            
            // --- 2. EDGE DETECTOR LOGIC ---
            // Keep a 1-clock-cycle delay of the clean state
            clean_state_delayed <= clean_state;
            
            // Output a pulse ONLY when the clean state transitions from 0 to 1
            pulse_out <= clean_state & ~clean_state_delayed;
            
        end
    end

endmodule

