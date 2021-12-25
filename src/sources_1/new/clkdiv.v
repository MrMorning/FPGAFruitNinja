`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:12:47 10/27/2020 
// Design Name: 
// Module Name:    clkdiv 
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
module clkdiv(
		input clk,
		input rst,
		output reg[31:0] clkdiv
    );
    
    initial begin
        clkdiv <= 0;
    end
	
	always @ (posedge clk) begin
		// if(rst) clkdiv <= 0;
		// else clkdiv <= clkdiv + 1'b1;

		clkdiv <= clkdiv + 1'b1;
	end

endmodule
