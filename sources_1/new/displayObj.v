`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chen Geng
// 
// Create Date: 2020/12/28 12:19:44
// Design Name: 
// Module Name: displayObj
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


module displayObj(
    input clk,
    input [9:0] col,
    input [8:0] row, //current displayed position
    input [9:0] posx,
    input [8:0] posy, //object position left top
    input [9:0] width,
    input [8:0] height, //object size
    input [memory_depth_base - 1: 0] memory_start_addr,
    input [3:0] scaleX,
    input [3:0] scaleY, //support the scaling of object

    output reg [11:0] vga_data
    );

parameter 
    memory_depth = 1024,
    memory_depth_base = 10;

    reg [9:0] relx = 0;
    reg [8:0] rely = 0;
    reg [memory_depth_base - 1 : 0] reladdr;
    
    wire [11:0] wire_data;
    

    always @ (posedge clk) begin
        if(col < posx || col >= posx + width || row < posy || row >= posy + height) begin
            vga_data <= 12'h000;
        end
        else begin
            relx <= col - posx;
            rely <= row - posy;
            reladdr <= rely * width + relx;
            vga_data <= wire_data;
            //TODO: add scaling       
        end
    end

    memoryRead M1(.clk(clk),
                  .addr(memory_start_addr + reladdr),
                  .data(wire_data)); 

    
endmodule
