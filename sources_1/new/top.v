`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/23 20:18:36
// Design Name: 
// Module Name: top
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


module top(
    input clk,
    output [3:0] VGA_R,
    output [3:0] VGA_G,
    output [3:0] VGA_B,
    output HS,
    output VS
    );
    
    wire [11:0] data;
    wire [8:0] row;
    wire [9:0] col;
    wire rdn;
    wire [31:0] Div;
    
    wire rst;
    
    assign rst = 0;
    
    clkdiv M3(
        .clk(clk),
        .rst(0),
        .clkdiv(Div)); 
    
    VGA M1(.clk(Div[1]),
           .Din(data),
           .row(row), 
           .col(col), 
           .rdn(rdn), 
           .R(VGA_R), 
           .G(VGA_G), 
           .B(VGA_B),
           .HS(HS), 
           .VS(VS));
     
//     VGADEMO M2(.clk(Div[0]),
//            .row(row),
//            .col(col),
//            .vga_data(data));

    wire [9:0] initposx = 0;
    wire [8:0] initposy = 0;
//    wire [9:0] posx = 0;
//    wire [8:0] posy = 0;
    wire [9:0] width = 100;
    wire [8:0] height = 80;
    wire [12:0] addr = 0;
    wire [3:0] scaleX = 1;
    wire [3:0] scaleY = 1;
    wire [31:0] T0 = 50000000;
    wire [31:0] Tx = T0 >> 5;
    wire [31:0] Ty = T0 >> 6;
    wire dx = 1;
    wire dy = 1;
    wire oob;
    
    wire [9:0] posx;
    wire [8:0] posy;

    displayObj DISP(
        .clk(Div[0]),
        .en(1),  
        .col(col),
        .row(row),
        .posx(posx),
        .posy(posy),
        .width(width),
        .height(height),
        .memory_start_addr(addr),
        .scaleX(scaleX),
        .scaleY(scaleY),
        .vga_data(data));
                  
              
    objectTransition OBJT(
        .clk(Div[0]),
        .rst(oob),
        .Tx(Tx),
        .Ty(Ty),
        .dx(dx),
        .dy(dy),
        .initPosX(initposx),
        .initPosY(initposy),
        
        .posx(posx),
        .posy(posy));    

    objectOutOfBound OOOB(
        .clk(Div[0]),
        .posx(posx),
        .posy(posy),
        .width(width),
        .height(height),

        .flag_out(oob)
    );
              
              
                      
           
      
        
     
    
endmodule
