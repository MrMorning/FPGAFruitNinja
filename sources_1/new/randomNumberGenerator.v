`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/04 20:44:42
// Design Name: 
// Module Name: randomNumberGenerator
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

//This code is adapted from StackOverflow: https://stackoverflow.com/questions/14497877/how-to-implement-a-pseudo-hardware-random-number-generator
module randomNumberGenerator(
  input clk,
  input rstn,
  input [4:0] seed,

  output reg [4:0] data
);

reg [4:0] data_next;

always @* begin
  data_next[4] = data[4]^data[1];
  data_next[3] = data[3]^data[0];
  data_next[2] = data[2]^data_next[4];
  data_next[1] = data[1]^data_next[3];
  data_next[0] = data[0]^data_next[2];
end

always @(posedge clk or negedge rstn)
  if(!rstn)
    data <= seed;
  else
    data <= data_next;

endmodule