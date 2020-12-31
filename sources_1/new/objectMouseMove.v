`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/31 11:40:30
// Design Name: 
// Module Name: objectMouseMove
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


module objectMouseMove(
    input clk,
    input mouseReady,
    input [9:0] vx,
    input [8:0] vy,
    input dx,
    input dy,
    input mousepush,
    input moveclk,
    input [9:0] width,
    input [8:0] height,
    input [9:0] initposx,
    input [8:0] initposy,
    
    output [9:0] posx,
    output [8:0] posy
    );

    reg [1:0] tdx;
    reg [1:0] tdy;

    initial begin
        tdx = 2'b00;
        tdy = 2'b00;
    end

    always @ (posedge clk) begin
        tdx <= {vx[0], dx};
        tdy <= {vy[0], dy};
    end

    objectTransition OBJT(
        .clk(clk),
        .rst(0),
        .moveclk(moveclk),
        .initPosX(initposx),
        .initPosY(initposy),
        .vx(vx),
        .vy(vy),
        .dx(tdx),
        .dy(tdy),

        .posx(posx),
        .posy(posy)
    );
         
endmodule
