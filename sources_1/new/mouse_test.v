`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/04 00:10:23
// Design Name: 
// Module Name: mouse_test
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


module mouse_test(

    );

    reg clk;
    reg rst;

    always @ (*) begin
        #10;
        clk <= ~clk;
    end

    reg mouseReady;

    reg [7:0] mouseData;

    wire [9:0] mousevx;
    wire [8:0] mousevy;
    wire mousedx;
    wire mousedy;
    wire mousepush;
    wire decodeReady;
    wire [7:0] mouseX, mouseY;


    mouseDecoder MOUD(
        .clk(clk),
        .rst(rst),
        .mouseReady(mouseReady),
        .mouseData(mouseData),
        .mouseState(0),
        .moveclk(0),

        .decodeReady(decodeReady),
        .mousevx(mousevx),
        .mousevy(mousevy),
        .mousedx(mousedx),
        .mousedy(mousedy),
        .mouseX(mouseX),
        .mouseY(mouseY),
        .mousepush(mousepush)
    );

    initial begin
        clk = 0;
        rst = 1;
        mouseReady = 0;
        #20;
        rst = 0;
        #50;
        mouseData = 8'h00;
        mouseReady = 1;
        #10;
        mouseReady = 0;

        #50;
        mouseData = 8'h02;
        mouseReady = 1;
        #10;
        mouseReady = 0;

        #50;
        mouseData = 8'h03;
        mouseReady = 1;
        #10;
        mouseReady = 0;

        #50;
        mouseData = 8'h00;
        mouseReady = 1;
        #10;
        mouseReady = 0;
        #50;
        mouseData = 8'h05;
        mouseReady = 1;
        #10;
        mouseReady = 0;
        #50;
        mouseData = 8'h0a;
        mouseReady = 1;
        #10;
        mouseReady = 0;
        
    end
endmodule
