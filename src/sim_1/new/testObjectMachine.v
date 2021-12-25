`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/08 14:01:49
// Design Name: 
// Module Name: testObjectMachine
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


module testObjectMachine(
    );
    reg clk = 0;
    always @ (*) begin
        #10;
        clk <= ~clk;
    end
    reg rstn;
    wire [31:0] Div;
    clkdiv M3(
        .clk(clk),
        .rst(0),
        .clkdiv(Div)
    ); 
    wire moveclk, accclk, data;
    clock_100ms C100(
        .clk(Div[0]),
        .clk_100ms(moveclk)
    );
    clock_acc CACC(
        .clk(Div[0]),
        .clk_acc(accclk)
    );
    objectMachine OBJM(
        .clk(clk),
        .rstn(rstn),
        .explode(1),
        .seed(5'b10111),
        .col(10'd0),
        .row(10'd0),
        .moveclk(moveclk),
        .accclk(accclk),
        .outputdata(data)
    );         
    initial begin
        rstn = 1;
        #50;
        rstn = 0;
        #50;
        rstn = 1;
    end      
           
endmodule
