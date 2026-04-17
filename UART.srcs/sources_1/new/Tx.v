`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2026 06:21:51 PM
// Design Name: 
// Module Name: Tx
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


module Tx(
    input [7:0] tx_parallel_in,
    input reset,
    input clk,
    input start,
    output reg busy,
    output reg tx_serial_out
    );
    
    reg [7:0] shift_reg;
    reg [13:0] baud_counter; // Basys3 Freq = 100MHz, Baud Rate = 9600
    reg [2:0] bit_counter;
    reg [1:0] state;
    
    parameter counter_max = 10417; // 100MHz / 9600 ≈ 10417
    parameter data_bits = 7;
    
    parameter IDLE  = 2'b00;
    parameter START = 2'b01;
    parameter DATA  = 2'b10;
    parameter STOP  = 2'b11;
    
    always @(posedge clk) begin
        if(reset) begin
            shift_reg <= 8'b0;
            baud_counter <= 14'b0;
            bit_counter <= 3'b0;
            state <= IDLE;
            busy <= 1'b0;
            tx_serial_out <= 1'b1;
        end
        
        else begin
            case(state)
                IDLE:begin
                    busy <= 1'b0;
                    tx_serial_out <= 1'b1;
                    baud_counter <= 14'b0;
                    bit_counter <= 3'b0;
                    
                    if(start) begin
                        busy <= 1'b1;
                        shift_reg <= tx_parallel_in;
                        state <= START;
                    end
                    
                end
                
                START:begin
                    tx_serial_out <= 1'b0;
                    if(baud_counter < counter_max)
                        baud_counter <= baud_counter + 1;
                    else begin
                        baud_counter <= 0;
                        state <= DATA;
                    end
                end
                
                DATA: begin
                    tx_serial_out <= shift_reg[0];
                    if (baud_counter < counter_max)
                        baud_counter <= baud_counter + 1;
                    else begin
                        baud_counter <= 0;
                        if (bit_counter < data_bits)begin
                            shift_reg <= shift_reg >> 1;
                            bit_counter <= bit_counter + 1;
                        end else
                            state <= STOP;
                    end
                end
                
                STOP:begin
                    tx_serial_out <= 1'b1;
                     if(baud_counter < counter_max)
                        baud_counter <= baud_counter + 1;
                     else begin
                        baud_counter <= 0;
                        busy <= 1'b0;
                        state <= IDLE;
                    end
                end
                
                default: state <= IDLE;
            endcase
        end
    end
    
endmodule
