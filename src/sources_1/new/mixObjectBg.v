`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/29 19:16:01
// Design Name: 
// Module Name: mixObjectBg
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


module mixObjectBg(
        input [11:0] databg,
        input [11:0] datao,

        output reg [11:0] data
    );

    always @ (*) begin
        if(datao[3:0] > 4'h0) begin
            data[3:0] = datao[3:0];
        end
        else begin
            data[3:0] = databg[3:0];
        end
    end

    always @ (*) begin
        if(datao[7:4] > 4'h0) begin
            data[7:4] = datao[7:4];
        end
        else begin
            data[7:4] = databg[7:4];
        end
    end

    always @ (*) begin
        if(datao[11:8] > 4'h0) begin
            data[11:8] = datao[11:8];
        end
        else begin
            data[11:8] = databg[11:8];
        end
    end

endmodule
