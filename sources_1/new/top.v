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
    input PS2_clk,
    input PS2_data,
    output [3:0] VGA_R,
    output [3:0] VGA_G,
    output [3:0] VGA_B,
    output HS,
    output VS
    );

parameter
    depth_bit = 19;

    wire [31:0] T0 = 50000000;

    wire [11:0] data;
    wire [11:0] databg;
    wire [11:0] datao1;
    wire [11:0] datao2;
    wire [11:0] datao;

    wire [7:0] keyData;
    wire keyReady;
    wire keyOverflow;
    wire [3:0] keyCount;

    wire [8:0] row;
    wire [9:0] col;
    wire rdn;
    wire [31:0] Div;
    
    wire rst;
    
    assign rst = 0;
    
    clkdiv M3(
        .clk(clk),
        .rst(0),
        .clkdiv(Div)
    ); 

    wire moveclk;
    clock_100ms C100(
        .clk(Div[0]),
        .clk_100ms(moveclk)
    );
    
    VGA M1(
        .clk(Div[1]),
        .Din(data),
        .row(row), 
        .col(col), 
        .rdn(rdn), 
        .R(VGA_R), 
        .G(VGA_G), 
        .B(VGA_B),
        .HS(HS), 
        .VS(VS)
    );

    wire [9:0] bgwidth = 100;
    wire [8:0] bgheight = 100;
    wire [depth_bit - 1:0] addr = 0;

    wire dx = 1;
    wire dy = 1;
    wire oob;
    
    

    wire [9:0] o1_posx;
    wire [8:0] o1_posy;
    wire [9:0] o1_width = 100;
    wire [8:0] o1_height = 80;
    wire [depth_bit - 1 : 0] o1_addr = 18000;

    objectMotion OBJ1(
        .clk(Div[0]),
        .moveclk(moveclk),
        .keyReady(keyReady),
        .keyData(keyData),
        .width(o1_width),
        .height(o1_height),
        .initposx(0),
        .initposy(0),
        .Tx(T0 >> 5),
        .Ty(T0 >> 6),
        .dx(1),
        .dy(1),

        .posx(o1_posx),
        .posy(o1_posy)
    );

    displayObj #(.memory_depth_base(depth_bit)) DISP(
        .clk(Div[0]),
        .en(1),  
        .col(col),
        .row(row),
        .posx(o1_posx),
        .posy(o1_posy),
        .width(o1_width),
        .height(o1_height),
        .memory_start_addr(o1_addr),
        .scaleX(1),
        .scaleY(1),
        .vga_data(datao1)
    );

    wire [9:0]               o2_posx;
    wire [8:0]               o2_posy;
    wire [9:0]               o2_width = 100;
    wire [8:0]               o2_height = 80;
    wire [depth_bit - 1 : 0] o2_addr = 26000;


    objectEngine OBJ2(
        .clk(Div[0]),
        .keyReady(keyReady),
        .moveclk(moveclk),
        .keyData(keyData),
        .width(o2_width),
        .height(o2_height),
        .initposx(320),
        .initposy(240),
        .vx(1),
        .vy(1),

        .posx(o2_posx),
        .posy(o2_posy)
    );

    displayObj #(.memory_depth_base(depth_bit)) DISO2(
        .clk(Div[0]),
        .en(1),  
        .col(col),
        .row(row),
        .posx             (o2_posx),
        .posy             (o2_posy),
        .width            (o2_width),
        .height           (o2_height),
        .memory_start_addr(o2_addr),
        .scaleX(1),
        .scaleY(1),
        .vga_data(datao2)
    );
    
    
    
       
    displayBg #(.memory_depth_base(depth_bit)) DISB(
        .clk(Div[0]),
        .en(1),
        .col(col),
        .row(row),
        .width(bgwidth),
        .height(bgheight),
        .memory_start_addr(addr),

        .vga_data(databg)
    );

    mixTwoFrame MIXER(
        datao1,
        datao2,
        datao
    );

    mixObjectBg MIXER2(
        .databg(databg),
        .datao(datao),
        .data(data)
    );

    

    ps2_keyboard PS2(
        .clk(Div[0]),
        .clrn(1),
        .ps2_clk(PS2_clk),
        .ps2_data(PS2_data),
        .rdn(0),

        .data(keyData),
        .ready(keyReady),
        .overflow(keyOverflow),
        .count(keyCount)
    );
    


    
endmodule
