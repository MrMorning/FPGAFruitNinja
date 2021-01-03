`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/31 10:51:49
// Design Name: 
// Module Name: mouseDecoder
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


module mouseDecoder(
    input clk,
    input       mouseReady,
    input [7:0] mouseData,
    input [3:0] mouseState,
    input moveclk,

    output decodeReady,
    output reg [9:0] mousevx,
    output reg [8:0] mousevy,
    output mousedx,
    output mousedy,
    output [7:0] mouseX,
    output [7:0] mouseY,
    output wire mousepush
);

reg [3:0] state;

reg [1:0] mouse_sample;

always @ (posedge clk) begin
    mouse_sample <= {mouse_sample[0], mouseReady};
end

reg [8:0] X;
reg [8:0] Y;
reg [7:0] Z;
reg overflowX;
reg overflowY;
reg middle;
reg right;
reg left;


always @ (posedge clk) begin
    if(mouse_sample == 2'b01) begin
        case(state)
            4'd0: begin
                if(mouseData[3] != 1) begin
                    state <= 4'd0;
                end
                else begin
                    left       <= mouseData[0];
                    right      <= mouseData[1];
                    middle     <= mouseData[2];
                    X[8]       <= mouseData[4];
                    Y[8]       <= mouseData[5];
                    overflowX  <= mouseData[6];
                    overflowY  <= mouseData[7];
                    state <= 4'd1;
                end
            end
            4'd1: begin
                X[7:0] <= mouseData;
                state <= 4'd2;
            end
            4'd2: begin
                Y[7:0] <= mouseData;
                state <= 4'd3;
            end
            4'd3: begin
                Z[7:0] <= mouseData;
                state <= 4'd4;
            end
            4'd4: begin
                if(mouseData[3] != 1) begin
                    state <= 4'd0;
                end
                else begin
                    left       <= mouseData[0];
                    right      <= mouseData[1];
                    middle     <= mouseData[2];
                    X[8]       <= mouseData[4];
                    Y[8]       <= mouseData[5];
                    overflowX  <= mouseData[6];
                    overflowY  <= mouseData[7];
                    state <= 4'd1;
                end
            end
            default: begin
                state <= 4'd0;
            end
        endcase
    end
    else begin
        // if(state == 4'd3) begin
        //     if(holdstate == 2'b11) state <= 4'd0;
        //     else state <= state;
        // end
        // else begin
            state <= state;
        // end
    end
end

wire [8:0] Xn = {1'b0,~X[7:0]}+1;
wire [8:0] Yn = {1'b0,~Y[7:0]}+1;

wire [7:0] tmpvx;
wire [7:0] tmpvy;

assign decodeReady = (state == 4'd3);
assign mousedx = X[8];
assign tmpvx = X[8] ? Xn[7:0] : X[7:0];
assign mousedy = ~Y[8];
assign tmpvy = Y[8] ? Yn[7:0] : Y[7:0];

assign mousepush = left;

reg [1:0] holdstate;

reg [1:0] moveclk_sample;

assign mouseX = X[7:0];
assign mouseY = Y[7:0];

always @ (posedge clk) begin
    moveclk_sample <= {moveclk_sample[0], moveclk};
end

always @ (posedge clk) begin
    if(state == 4'd4) begin
        mousevx <= {9'b0, |tmpvx};
        mousevy <= {8'b0, |tmpvy};
    end
    else begin
        mousevx <= 0;
        mousevy <= 0;
    end
    // case(holdstate)
    //     2'b00: begin
    //         if(state == 4'd3) begin
    //             holdstate <= 2'b01;
    //             mousevx <= {9'b0, 1'b1};
    //             mousevy <= {8'b0, 1'b1};
    //         end
    //         else begin
    //             holdstate <= holdstate;
    //         end
    //     end
    //     2'b01: begin
    //         if(moveclk_sample == 2'b01) begin
    //             holdstate <= 2'b10;
    //         end
    //         else begin
    //             holdstate <= holdstate;
    //         end
    //     end
    //     2'b10: begin
    //         if(moveclk_sample == 2'b10) begin
    //             holdstate <= 2'b11;
    //             mousevx <= 0;
    //             mousevy <= 0;
    //         end
    //         else begin
    //             holdstate <= holdstate;
    //         end
    //     end
    //     2'b11: begin
    //         if(state == 4'd3) holdstate <= 2'b11;
    //         else holdstate <= 2'b00;
    //     end
    //     default: begin
            
    //     end
    // endcase
end


endmodule
