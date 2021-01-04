`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/04 14:14:48
// Design Name: 
// Module Name: objectAccelerate
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


module objectAccelerate(
    input clk,
    input rst,
    input moveclk,
    input [9:0] initvx,
    input [8:0] initvy,
    input [1:0] initvdx,
    input [1:0] initvdy,
    input [9:0] ax,
    input [8:0] ay,
    input [1:0] adx,
    input [1:0] ady,   // dx = 1, inc, dx = 0, dec
    
    output reg [9:0] vx,
    output reg [8:0] vy,
    output reg [1:0] vdx,
    output reg [1:0] vdy
    );

    always @ (posedge clk) begin
        if(rst) begin
            vx  <= initvx;
            vy  <= initvy;
            vdx <= initvdx;
            vdy <= initvdy;
        end
        else begin 
            if(moveclk) begin
                case(adx)
                    2'b00: vx <= vx;
                    2'b01: vx <= vx;
                    2'b10: begin
                        vdx[1] <= 1;
                        if(vdx[0] == adx[0]) begin
                            vx <= vx + ax;
                        end
                        else begin
                            if(vx > ax) begin
                                vx <= vx - ax;                            
                            end
                            else begin
                                vdx[0] <= ~vdx[0];
                            end
                        end
                    end
                    2'b11: begin
                        vdx[1] <= 1;
                        if(vdx[0] == adx[0]) begin
                            vx <= vx + ax;
                        end
                        else begin
                            if(vx > ax) begin
                                vx <= vx - ax;
                            end
                            else begin
                                vdx[0] <= ~vdx[0];
                            end
                        end
                    end
                endcase
                case(ady)
                    2'b00: vy <= vy;
                    2'b01: vy <= vy;
                    2'b10: begin
                        vdy[1] <= 1;
                        if(vdy[0] == ady[0]) begin
                            vy <= vy + ay;
                        end
                        else begin
                            if(vy > ay) begin
                                vy <= vy - ay;
                            end
                            else begin
                                vdy[0] <= ~vdy[0];
                            end
                        end
                    end
                    2'b11: begin
                        vdy[1] <= 1;
                        if(vdy[0] == ady[0]) begin
                            vy <= vy + ay;
                        end
                        else begin
                            if(vy > ay) begin
                                vy <= vy - ay;
                            end
                            else begin
                                vdy[0] <= ~vdy[0];
                            end
                        end
                    end
                endcase
            end
        end
    end
endmodule

