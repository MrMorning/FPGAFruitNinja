`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/30 17:19:02
// Design Name: 
// Module Name: clock_100ms
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


module clock_100ms(
    input clk,

    output reg clk_100ms
    );

    reg [31:0] count;
    
    initial begin
        count = 0;
    end

    always @ (posedge clk) begin
        if(count == 32'd499999) begin
            count <= 0;
            clk_100ms <= 1;
        end
        else begin
            count <= count + 32'b1;
            clk_100ms <= 0;
        end
    end
endmodule
