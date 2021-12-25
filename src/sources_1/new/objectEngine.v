`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/30 17:00:44
// Design Name: 
// Module Name: objectEngine
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


module objectEngine(
    input clk,
    input keyReady,
    input moveclk,
    input [7:0] keyData, 
    input [9:0] width,
    input [8:0] height,
    input [9:0] initposx,
    input [8:0] initposy,
    input [9:0] vx,
    input [8:0] vy,
    
    output [9:0] posx,
    output [8:0] posy
    );

    reg [1:0] tdx;
    reg [1:0] tdy;

    initial begin
        tdx = 2'b00;
        tdy = 2'b00;
    end

    reg [1:0] key_sample;

    always @ (posedge clk) begin
        key_sample <= {key_sample[0], keyReady};
    end

    reg [1:0] state;
    initial state = 0;

    always @ (posedge clk) begin
        if(keyReady) begin
            case (keyData)
                8'h1D: begin  //W
                    case(state)
                        0: begin
                            state <= 1;
                            tdx <= 2'b00;
                            tdy <= 2'b10;
                        end
                        1: begin
                            state <= 1;
                            tdx <= tdx;
                            tdy <= tdy;
                        end
                        2: begin
                            state <= 0;
                            tdx <= 2'b00;
                            tdy <= 2'b00;
                        end
                    endcase
                end 
                8'h1B: begin  //S
                    case(state)
                        0: begin
                            state <= 1;
                            tdx <= 2'b00;
                            tdy <= 2'b11;
                        end
                        1: begin
                            state <= 1;
                            tdx <= tdx;
                            tdy <= tdy;
                        end
                        2: begin
                            state <= 0;
                            tdx <= 2'b00;
                            tdy <= 2'b00;
                        end
                    endcase
                end
                8'h1C: begin  //A
                    case(state)
                        0: begin
                            state <= 1;
                            tdx <= 2'b10;
                            tdy <= 2'b00;
                        end
                        1: begin
                            state <= 1;
                            tdx <= tdx;
                            tdy <= tdy;
                        end
                        2: begin
                            state <= 0;
                            tdx <= 2'b00;
                            tdy <= 2'b00;
                        end
                    endcase
                end
                8'h23: begin  //D
                    case(state)
                        0: begin
                            state <= 1;
                            tdx <= 2'b11;
                            tdy <= 2'b00;
                        end
                        1: begin
                            state <= 1;
                            tdx <= tdx;
                            tdy <= tdy;
                        end
                        2: begin
                            state <= 0;
                            tdx <= 2'b00;
                            tdy <= 2'b00;
                        end
                    endcase
                end
                8'hF0:begin
                    state <= 2;
                    tdx <= 2'b00;
                    tdy <= 2'b00;
                end
                default: begin
                    state <= 0;
                    tdx <= 2'b00;
                    tdy <= 2'b00;
                end
            endcase
        end
    end

    objectTransition OBJT(
        .clk(clk),
        .rst(0),
        .moveclk(moveclk),
        .initPosX(initposx),
        .initPosY(initposy),
        .vx(vx),
        .vy(vy),
        .dx(tdx),
        .dy(tdy),

        .posx(posx),
        .posy(posy)
    );
         
endmodule
