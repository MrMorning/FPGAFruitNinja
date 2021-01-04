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
    input rst,
    input       mouseReady,
    input [7:0] mouseData,
    input [3:0] mouseState,
    input moveclk,

    output decodeReady,
    output reg [9:0] mousevx,
    output reg [8:0] mousevy,
    output mousedx,
    output mousedy,
    output [7:0] debugX,
    output [7:0] debugY,
    output debugLeft,
    output debugRight,
    output debugMiddle,
    output debugX8,
    output debugY8,
    output debugOX,
    output debugOY,
    output reg [31:0] debugCount,
    output [3:0] debugState,
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
    if(rst) begin
        left <= 0;
        right <= 0;
        middle <= 0;
        X <= 0;
        Y <= 0;
        overflowX <= 1;
        overflowY <= 1;
        state <= 0;
        mouse_sample <= 0;
        debugCount <= 0;
    end
    else begin
        
        case(state)
            0: begin
                if(mouse_sample == 2'b01) begin
                    left       <= mouseData[0];
                    right      <= mouseData[1];
                    middle     <= mouseData[2];
                    X[8]       <= mouseData[4];
                    Y[8]       <= mouseData[5];
                    overflowX  <= mouseData[6];
                    overflowY  <= mouseData[7];
                    state <= 1;                
                    debugCount <= debugCount + 1;     
                end
                else begin
                    state <= state;
                end
            end
            1: begin
                if(mouse_sample == 2'b01) begin
                    X[7:0] <= mouseData;
                    state <= 2;    
                    debugCount <= debugCount + 1;
                end
                else begin
                    state <= state;
                end
            end
            2: begin
                if(mouse_sample == 2'b01) begin
                    Y[7:0] <= mouseData;
                    state <= 3;
                    debugCount <= debugCount + 1;
                end
                else begin
                    state <= state;
                end
            end
            3: begin
                if(mouse_sample == 2'b01) begin
                    left       <= mouseData[0];
                    right      <= mouseData[1];
                    middle     <= mouseData[2];
                    X[8]       <= mouseData[4];
                    Y[8]       <= mouseData[5];
                    overflowX  <= mouseData[6];
                    overflowY  <= mouseData[7]; 
                    state <= 1;    
                    debugCount <= debugCount + 1;
                end
                else begin
                    state <= state;
                end
            end
            default: begin
                if(mouse_sample == 2'b01) begin
                    debugCount <= debugCount + 1;
                end
                state <= 0;
            end
        endcase
    end
end

wire [7:0] Xn = {1'b0,~X[6:0]}+1;
wire [7:0] Yn = {1'b0,~Y[6:0]}+1;

wire [6:0] tmpvx;
wire [6:0] tmpvy;

assign decodeReady = (state == 4'd3);
assign mousedx = X[7];
assign tmpvx = X[7] ? Xn[6:0] : X[6:0];
assign mousedy = ~Y[7];
assign tmpvy = Y[7] ? Yn[6:0] : Y[6:0];

assign mousepush = left;

reg [1:0] holdstate;

reg [1:0] moveclk_sample;

assign debugX = X[7:0];
assign debugY = Y[7:0];
assign debugLeft = left;
assign debugRight = right;
assign debugMiddle = middle;
assign debugOX = overflowX;
assign debugOY = overflowY;
assign debugX8 = X[8];
assign debugY8 = Y[8];
assign debugState = state;

always @ (posedge clk) begin
    moveclk_sample <= {moveclk_sample[0], moveclk};
end

always @ (posedge clk) begin
    if(state == 4'd3) begin
        mousevx <= {9'b0, |tmpvx};
        mousevy <= {8'b0, |tmpvy};
    end
    else begin
        mousevx <= 0;
        mousevy <= 0;
    end
    ////////////////
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
