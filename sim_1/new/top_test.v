`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/28 21:30:56
// Design Name: 
// Module Name: top_test
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


module top_test(
    );
    reg clk = 0;
    wire [3:0] VGA_R, VGA_G, VGA_B;
    wire HS, VS;
    always @ (*) begin
        #10;
        clk <= ~clk;
    end
    
    top U1(
        clk,
        VGA_R,
        VGA_G,
        VGA_B,
        HS,
        VS 
    );
              
                      
           
endmodule
