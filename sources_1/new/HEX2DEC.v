`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/15 19:26:00
// Design Name: 
// Module Name: HEX2DEC
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


module HEX2DEC(
        input [31:0] inputhex,

        output [7:0] outputdec
    );

    assign outputdec[3:0] = inputhex % 10;
    assign outputdec[7:4] = inputhex / 10;
endmodule
