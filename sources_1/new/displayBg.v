`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/29 16:09:16
// Design Name: 
// Module Name: displayBg
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


module displayBg(
    input clk,
    input en,
    input [9:0] col,
    input [9:0] row, //current displayed position
    input [9:0] width,
    input [9:0] height, //background size
    input [memory_depth_base - 1: 0] memory_start_addr,

    output reg [11:0] vga_data
    );

parameter 
    memory_depth = 1024,
    memory_depth_base = 19;

    reg [9:0] relx = 0;
    reg [9:0] rely = 0;
    reg [memory_depth_base - 1 : 0] reladdr;
    
    wire [11:0] wire_data;
    

    always @ (posedge clk) begin
        relx <= col % width;
        rely <= row % height;
        reladdr <= rely * width + relx;
        if(en)
            vga_data <= wire_data;
        else
            vga_data <= 12'h000;
    end

    memoryRead M1(.clk(clk),
                  .addr(memory_start_addr + reladdr),
                  .data(wire_data)); 

    
endmodule
