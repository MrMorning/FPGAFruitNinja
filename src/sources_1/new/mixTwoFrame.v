`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/29 18:18:04
// Design Name: 
// Module Name: mixTwoFrame
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


module mixTwoFrame(
    input [11:0] data1,
    input [11:0] data2,

    output reg [11:0] data
    );

    always @ (*) begin
        if(data2[3:0] > 4'hf - data1[3:0]) begin
            data[3:0] = 4'hf;
        end
        else begin
            data[3:0] = data1[3:0] + data2[3:0];
        end
    end

    always @ (*) begin
        if(data2[7:4] > 4'hf - data1[7:4]) begin
            data[7:4] = 4'hf;
        end
        else begin
            data[7:4] = data1[7:4] + data2[7:4];
        end
    end

    always @ (*) begin
        if(data2[11:8] > 4'hf - data1[11:8]) begin
            data[11:8] = 4'hf;
        end
        else begin
            data[11:8] = data1[11:8] + data2[11:8];
        end
    end
endmodule
