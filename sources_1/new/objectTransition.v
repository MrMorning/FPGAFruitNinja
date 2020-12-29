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
    input rst,
    input [31:0] Tx,
    input [31:0] Ty,
    input [9:0] initPosX,
    input [8:0] initPosY,
    input dx,
    input dy,   // dx = 1, inc, dx = 0, dec
    
    output reg [9:0] posx,
    output reg [8:0] posy
    );

    initial begin
        posx = initPosX;
        posy = initPosY;
    end
    
    reg [31:0] counterX = 0;
    reg [31:0] counterY = 0;
    reg signalX = 0;
    reg signalY = 0;


    
    
    always @ (posedge clk) begin
        if(rst) begin
            counterX <= 0;
            signalX <= 0;
            posx <= initPosX;
        end
        else begin 
            if(counterX == Tx - 1) begin
                counterX <= 0;
                signalX <= 1;
            end
            else begin
                counterX <= counterX + 1;
                signalX <= 0;
            end
            if(signalX) begin
                case (dx)
                    1'b1 : posx <= posx + 1; 
                    1'b0 : posx <= posx - 1;
                endcase
            end
        end
    end

    always @ (posedge clk) begin
        if(rst) begin
            counterY <= 0;
            signalY <= 0;
            posy <= initPosY;
        end
        else begin 
            if(counterY == Ty - 1) begin
                counterY <= 0;
                signalY <= 1;
            end
            else begin
                counterY <= counterY + 1;
                signalY <= 0;
            end 
            if(signalY) begin
                case (dy)
                    1'b1: posy <= posy + 1;
                    1'b0: posy <= posy - 1;
                endcase
            end
        end  
    end

    // always @ (posedge signalX) begin
    //     case (dx)
    //         1'b1 : posx <= posx + 1; 
    //         1'b0 : posx <= posx - 1;
    //     endcase
    // end

    // always @ (posedge signalY) begin
    //     case (dy)
    //         1'b1: posy <= posy + 1;
    //         1'b0: posy <= posy - 1;
    //     endcase
    // end


endmodule
