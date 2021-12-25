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
    input rstn,
    input moveen,
    input moveclk,
    input accclk,
    input [9:0] width,
    input [9:0] height,
    input [9:0] initposx,
    input [9:0] initposy,
    input [9:0] initvx,
    input [9:0] initvy,
    input initdx,
    input initdy,
    input [9:0] ax,
    input [9:0] ay,
    input [1:0] adx,
    input [1:0] ady,
    
    output [9:0] posx,
    output [9:0] posy,
    output wire oob
    );

    wire flagx;
    wire flagy;
    reg tdx;
    reg tdy;

    wire [1:0] ndx;
    wire [1:0] ndy;

    wire [9:0] vx;
    wire [9:0] vy;
    
    objectTransition OBJT(
        .clk(clk),
        .en(moveen),
        .rst(~rstn),
        .moveclk(moveclk),
        .vx(vx),
        .vy(vy),
        .dx(ndx),
        .dy(ndy),
        .initPosX(initposx),
        .initPosY(initposy),
        
        .posx(posx),
        .posy(posy)
    );    

    objectAccelerate OBJV(
        .clk(clk),
        .rst(~rstn),
        .accclk(accclk),
        .initvx(initvx),
        .initvy(initvy),
        .initvdx({1'b1, initdx}),
        .initvdy({1'b1, initdy}),
        .ax(ax),
        .ay(ay),
        .adx(adx),
        .ady(ady),

        .vx(vx),
        .vy(vy),
        .vdx(ndx),
        .vdy(ndy)
    );    


    reg [1:0] oob_sample;
    reg [1:0] key_sample;

    always @ (posedge clk) begin
        oob_sample <= {oob_sample[0], oob};
    end

    always @ (posedge clk) begin
        if(oob_sample == 2'b01) begin
            if(flagx) 
                tdx <= ~tdx;
            else 
                tdy <= ~tdy;
        end
    end

    objectOutOfBound OOOB(
        .clk(clk),
        .posx(posx),
        .posy(posy),
        .width(width),
        .height(height),

        .flag_out(oob),
        .flagx_out(flagx),
        .flagy_out(flagy)
    );
         
endmodule
