`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/29 10:03:21
// Design Name: 
// Module Name: objectOutOfBound
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


module objectOutOfBound(
    input clk,
    input [9:0] posx,
    input [8:0] posy,
    input [9:0] width,
    input [8:0] height,

    output flag_out
    );
    parameter 
        window_width = 640,
        window_height = 480,
        col_neg_det = 900,
        row_neg_det = 500;

    reg flagx, flagy;

    always @ (posedge clk) begin
        if(posx + width - 1 > col_neg_det || posx > window_width) begin
            flagx <= 1;
        end
        else begin
            flagx <= 0;
        end
    end

    always @ (posedge clk) begin
        if(posy + height - 1 > row_neg_det || posy > window_height) begin
            flagy <= 1;
        end
        else begin
            flagy <= 0; 
        end
    end
    
    assign flag_out = flagx & flagy;

endmodule
