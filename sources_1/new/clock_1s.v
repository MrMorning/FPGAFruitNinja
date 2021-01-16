`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/15 19:08:49
// Design Name: 
// Module Name: clock_1s
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


module clock_1s(
        input clk,
        input rstn,

        output reg clk_1s
    );
    reg [31:0] count;
    always @ (posedge clk) begin
        if(!rstn) begin
            count <= 0;
            clk_1s <= 1;
        end
        else begin
            if(count == 32'd99999999) begin
                count <= 0;
                clk_1s <= 1;
            end
            else begin
                count <= count + 1;
                clk_1s <= 0;
            end
        end
    end
endmodule
