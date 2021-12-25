`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/30 16:50:56
// Design Name: 
// Module Name: objectMove
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


module objectMove(
        input clk,
        input [1:0] dx, //10 move decrease, 11 move increase, 0x stay.
        input [1:0] dy,
        input [9:0] initx,
        input [8:0] inity,
        input [9:0] vx,
        input [8:0] vy,

        output reg [9:0] posx,
        output reg [8:0] posy
    );

    initial begin
        posx = initx;
        posy = inity;
    end

    reg [1:0] x_sample;
    
    always @ (posedge clk) begin
        x_sample <= {x_sample[0], dx[1]};
    end

    always @ (posedge clk) begin
        if(x_sample == 2'b01) begin
            if(dx[0] == 0) begin
                posx <= posx - vx;
            end else begin
                posx <= posx + vx;
            end
        end
    end

    reg [1:0] y_sample;
    
    always @ (posedge clk) begin
        y_sample <= {y_sample[0], dy[1]};
    end

    always @ (posedge clk) begin
        if(y_sample == 2'b01) begin
            if(dy[0] == 0) begin
                posy <= posy - vy;
            end else begin
                posy <= posy + vy;
            end
        end
    end
endmodule
