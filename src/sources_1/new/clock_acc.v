`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/04 19:22:24
// Design Name: 
// Module Name: clock_acc
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


module clock_acc(
    input clk,

    output reg clk_acc
    );

    reg [31:0] count;
    
    initial begin
        count = 0;
    end

    always @ (posedge clk) begin
        if(count == 32'd2_499_499) begin
            count <= 0;
            clk_acc <= 1;
        end
        else begin
            count <= count + 32'b1;
            clk_acc <= 0;
        end
    end
endmodule