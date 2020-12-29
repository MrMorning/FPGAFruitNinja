`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/29 18:29:29
// Design Name: 
// Module Name: objectMotion
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


module objectMotion(
    input clk,
    input [9:0] width,
    input [8:0] height,
    input [9:0] initposx,
    input [8:0] initposy,
    input [31:0] Tx,
    input [31:0] Ty,
    input dx,
    input dy,
    
    output [9:0] posx,
    output [8:0] posy
    );

    wire oob;
    objectTransition OBJT(
        .clk(clk),
        .rst(oob),
        .Tx(Tx),
        .Ty(Ty),
        .dx(dx),
        .dy(dy),
        .initPosX(initposx),
        .initPosY(initposy),
        
        .posx(posx),
        .posy(posy));    

    objectOutOfBound OOOB(
        .clk(clk),
        .posx(posx),
        .posy(posy),
        .width(width),
        .height(height),

        .flag_out(oob)
    );
         
endmodule
