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
    
    reg [15:0] SW;
    
    wire SEGCLK, SEGDT, SEGEN, SEGCLR;
    
    top U1(
        .clk(clk),
        .PS2_clk(0),
        .PS2_data(0),
        .SW(SW),
        .VGA_R(VGA_R),
        .VGA_G(VGA_G),
        .VGA_B(VGA_B),
        .HS(HS),
        .VS(VS), 
        .SEGCLK(SEGCLK),
        .SEGDT(SEGDT),
        .SEGEN(SEGEN),
        .SEGCLR(SEGCLR)
    );
    
    initial begin
        #10;
        SW[15] = 0;
        #200;
        SW[15] = 1;
        
    end
                      
           
endmodule
