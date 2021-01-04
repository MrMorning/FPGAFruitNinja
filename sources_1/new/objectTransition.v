`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/28 21:11:16
// Design Name: 
// Module Name: objectTransition
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


module objectTransition(
    input clk,
    input en,
    input rst,
    input moveclk,
    input [9:0] initPosX,
    input [9:0] initPosY,
    input [9:0] vx,
    input [9:0] vy,
    input [1:0] dx,
    input [1:0] dy,   // dx = 1, inc, dx = 0, dec
    
    output reg [9:0] posx,
    output reg [9:0] posy
    );

    initial begin
        posx = initPosX;
        posy = initPosY;
    end
    
    always @ (posedge clk) begin
        if(rst) begin
            posx <= initPosX;
            posy <= initPosY;
        end
        else if(!en) begin
            posx <= posx;
            posy <= posy;
        end
        else begin 
            if(moveclk) begin
                case(dx)
                    2'b00: posx <= posx;
                    2'b01: posx <= posx;
                    2'b10: posx <= posx - vx;
                    2'b11: posx <= posx + vx; 
                endcase
                case(dy)
                    2'b00: posy <= posy;
                    2'b01: posy <= posy;
                    2'b10: posy <= posy - vy;
                    2'b11: posy <= posy + vy;
                endcase
            end
        end
    end



endmodule
