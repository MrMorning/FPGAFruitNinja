`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chen Geng
// 
// Create Date: 2020/12/28 12:19:44
// Design Name: 
// Module Name: displayObj2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//   This module is designed to get a object from memory and display it on vga
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module displayObj2(
    input clk,
    input en1,
    input en2,
    input [9:0] col,
    input [9:0] row, //current displayed position
    input [9:0] posx1,
    input [9:0] posx2,
    input [9:0] posy1, //object position left top
    input [9:0] posy2, //object position left top
    input [9:0] width,
    input [9:0] height, //object size
    input [memory_depth_base - 1: 0] memory_start_addr,
    input [3:0] scaleX,
    input [3:0] scaleY, //support the scaling of object

    output reg [11:0] vga_data
    );

parameter 
    memory_depth = 1024,
    memory_depth_base = 18;

    reg [9:0] relx = 0;
    reg [9:0] rely = 0;
    reg [memory_depth_base - 1 : 0] reladdr1;
    reg [memory_depth_base - 1 : 0] reladdr2;
    
    wire [11:0] wire_data1;
    wire [11:0] wire_data2;
    
    wire [9:0] width1 = width >> 1;
    wire [9:0] width2 = width - width1;
    
    always @ (posedge clk) begin
        if(!en1 && !en2) begin
            vga_data <= 12'h000;
        end
        else if(en1 && col >= posx1 && col < posx1 + width1 && row >= posy1 && row < posy1 + height) begin
            reladdr1 <= (row - posy1) * width + (col - posx1);
            vga_data <= wire_data1; 
        end
        else if(en2 && col >= posx2 && col < posx2 + width2 && row >= posy2 && row < posy2 + height) begin
            reladdr2 <= (row - posy2) * width + (col - posx2 + width1);
            vga_data <= wire_data2;
        end
        else begin
            vga_data <= 12'h000;
        end
    end

    memoryRead M1(.clk(clk),
                  .addr(memory_start_addr + reladdr1),
                  .data(wire_data1)); 

    memoryRead M2(.clk(clk),
                  .addr(memory_start_addr + reladdr2),
                  .data(wire_data2)); 
    
endmodule
