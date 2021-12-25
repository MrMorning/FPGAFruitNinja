`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:05:45 12/15/2020 
// Design Name: 
// Module Name:    SHIFT64 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module SHIFT64(
    input clk,
    input SR,
    input SL,
    input S1,
    input S0, 
    input [DATA_BITS:0] D,
    output reg [DATA_BITS:0] Q
    );
    parameter 
        DATA_BITS = 16;
    always @(posedge clk) begin
      if({S1, S0} == 2'b11) Q <= D;
      else if({S1, S0} == 2'b10) begin
          Q <= {Q[DATA_BITS-1:0], SL};
      end
      else if({S1, S0} == 2'b01) begin
          Q <= {SR, Q[DATA_BITS:1]};
      end
      else Q <= Q;
    end

    



endmodule
