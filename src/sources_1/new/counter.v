`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/15 19:01:21
// Design Name: 
// Module Name: counter
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


module counter(
        input clk,
        input inc,
        input rstn,

        output reg [11:0] count
    );


    always @ (posedge clk) begin
        if(!rstn) begin
            count <= 0;
        end
        else begin
            if(inc) begin
                if(count == 12'h999) begin
                    count <= 0;
                end
                else if(count[7:0] == 8'h99) begin
                    count <= {count[11:8] + 4'h1, 8'h00};
                end
                else if(count[3:0] == 4'h9) begin
                    count <= {count[11:4] + 8'h1, 4'h0};
                end
                else begin
                    count <= count + 1;
                end
            end
            else begin
                count <= count;
            end
        end
    end
    
endmodule
