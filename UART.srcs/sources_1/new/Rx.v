`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2026 02:58:00 PM
// Design Name: 
// Module Name: Rx
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


module Rx(
    input rx_serial_in,
    output reg [7:0] rx_parallel_out,
    output reg done,
    input clk,
    input reset
    );
    
    reg [7:0] shift_reg; // Parallel output data bits
    reg [13:0] baud_counter; // Basys3 Freq = 100MHz, Baud Rate = 9600
    reg [2:0] bit_counter; // Counter for 8 bits
    reg [1:0] state; // FSM with 4 states
    
    parameter counter_max = 10417; // 100MHz / 9600 ≈ 10417 increments for one data bit
    parameter data_bits = 8;
    
    parameter IDLE  = 2'b00;
    parameter START = 2'b01;
    parameter DATA  = 2'b10;
    parameter STOP  = 2'b11;
    
    always @(posedge clk)begin
        if(reset)begin
            rx_parallel_out <= 8'b0;
            done <= 0;
            shift_reg <= 8'b0;
            baud_counter <= 14'b0;
            bit_counter <= 3'b0;
            state <= IDLE;
        end else begin
            case(state)
                IDLE:begin // Clears regs
                    done <= 0;
                    shift_reg <= 8'b0;
                    baud_counter <= 14'b0;
                    bit_counter <= 3'b0;
                    
                    if(rx_serial_in == 1'b0) // If it receives a '0' bit, data processing starts
                        state <= START;
                end
                
                START:begin
                    if(baud_counter < counter_max/2) // Samples at half the bit counter incrementations for signal fidelity
                        baud_counter <= baud_counter + 1;
                    else begin
                        baud_counter <= 0;
                        if(rx_serial_in == 0)
                            state <= DATA;
                        else
                            state <= IDLE;
                    end
                end
                
                DATA:begin // Data parallel output
                    if(baud_counter < counter_max)
                        baud_counter <= baud_counter + 1;
                    else begin
                        baud_counter <= 0;
                        shift_reg <= {rx_serial_in, shift_reg[7:1]};
                        if(bit_counter < data_bits - 1)
                            bit_counter <= bit_counter + 1;
                        else
                            state <= STOP;
                    end
                    
                end
                
                STOP:begin // Stops receiving data after 8 bits
                    if(baud_counter < counter_max)
                        baud_counter <= baud_counter + 1;
                    else begin // resets counters and outputs parallel data
                        baud_counter <= 0;
                        bit_counter <= 0;
                        done <= 1'b1;
                        rx_parallel_out <= shift_reg;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule
