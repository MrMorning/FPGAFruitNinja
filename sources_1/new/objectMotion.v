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
    input key,
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
    wire flagx;
    wire flagy;
    reg tdx;
    reg tdy;
    
    objectTransition OBJT(
        .clk(clk),
        .rst(0),
        .Tx(Tx),
        .Ty(Ty),
        .dx(tdx),
        .dy(tdy),
        .initPosX(initposx),
        .initPosY(initposy),
        
        .posx(posx),
        .posy(posy));    

    
    initial begin
        tdx = dx;
        tdy = dy;
    end

    reg [1:0] oob_sample;

    always @ (posedge clk) begin
        oob_sample <= {oob_sample[0], oob|key};
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
