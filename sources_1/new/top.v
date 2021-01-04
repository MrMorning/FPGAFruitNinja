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
    // input rstn,
    input PS2_clk,
    input PS2_data,
    input [15:0] SW,
    output [3:0] VGA_R,
    output [3:0] VGA_G,
    output [3:0] VGA_B,
    output HS,
    output VS,
    
    output wire SEGCLK,
    output wire SEGDT,
    output wire SEGEN,
    output wire SEGCLR
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

    wire [9:0] mousevx;
    wire [8:0] mousevy;
    wire mousedx;
    wire mousedy;
    wire mousepush;
    wire decodeReady;
    
    wire rst;
    
    assign rst = 0;
    
    clkdiv M3(
        .clk(clk),
        .rst(~rstn),
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
    wire rstn = SW[15];

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
        .rstn(rstn),
        .moveclk(moveclk),
        .keyReady(keyReady),
        .keyData(keyData),
        .width(o1_width),
        .height(o1_height),
        .initposx(100),
        .initposy(300),
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


    // objectEngine OBJ2(
    //     .clk(Div[0]),
    //     .keyReady(keyReady),
    //     .moveclk(moveclk),
    //     .keyData(keyData),
    //     .width(o2_width),
    //     .height(o2_height),
    //     .initposx(320),
    //     .initposy(240),
    //     .vx(1),
    //     .vy(1),

    //     .posx(o2_posx),
    //     .posy(o2_posy)
    // );

    objectMouseMove OBJ2(
        .clk(Div[0]),
        .rstn(rstn),
        .mouseReady(mouseReady),
        .vx(mousevx),
        .vy(mousevy),
        .dx(mousedx),
        .dy(mousedy),
        .mousepush(mousepush),
        .moveclk(moveclk),
        .width(o2_width),
        .height(o2_height),
        .initposx(320),
        .initposy(240),

        .posx(o2_posx),
        .posy(o2_posy)
    );

    // wire [11:0] o2_12_posx;
    // wire [11:0] o2_12_posy;
    // wire [2:0] mouse_btn_click;

    // ps2_mouse_xy OBJ2(
    //     .clk(Div[0]),
    //     .reset(0),
    //     .ps2_clk(PS2_clk),
    //     .ps2_data(PS2_data),
    //     .mx(o2_12_posx),
    //     .my(o2_12_posy),
    //     .btn_click(mouse_btn_click)
    // );

    // assign o2_posx = o2_12_posx[9:0];
    // assign o2_posy = o2_12_posy[8:0];

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
    
       
    reg bgen = 0;
    displayBg #(.memory_depth_base(depth_bit)) DISB(
        .clk(Div[0]),
        .en(bgen),
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

    assign keyData = 0;
    assign keyReady = 0;

    // ps2_keyboard PS2K(
    //     .clk(Div[0]),
    //     .clrn(1),
    //     .ps2_clk(PS2_clk),
    //     .ps2_data(PS2_data),
    //     .rdn(0),

    //     .data(keyData),
    //     .ready(keyReady),
    //     .overflow(keyOverflow),
    //     .count(keyCount)
    // );

    wire [7:0] mouseData;
    wire       mouseReady;
    wire [3:0] mouseState;
    wire       mouseOverflow;
    wire [3:0] mouseCount;
    

    // ps2_mouse PS2M(
    //     .clk(Div[0]),
    //     .clrn(1),
    //     .ps2_clk(PS2_clk),
    //     .ps2_data(PS2_data),

    //     .data(mouseData),
    //     .ready(mouseReady),
    //     .state(mouseState)
    // );

    ps2_keyboard PS2M(
        .clk(Div[1]),
        .clrn(rstn),
        .ps2_clk(PS2_clk),
        .ps2_data(PS2_data),
        .rdn(0),

        .data(mouseData),
        .ready(mouseReady),
        .overflow(mouseOverflow),
        .count(mouseCount)
    );

    wire [7:0] mouseX, mouseY;

    wire [7:0] debugX;
    wire [7:0] debugY;
    wire debugLeft;
    wire debugRight;
    wire debugMiddle;
    wire debugX8;
    wire debugY8;
    wire debugOX;
    wire debugOY;
    wire [3:0] debugState;
    wire [31:0] debugCount;

    mouseDecoder MOUD(
        .clk(clk),
        .rst(~rstn),
        .mouseReady(mouseReady),
        .mouseData(mouseData),
        .mouseState(mouseState),
        .moveclk(moveclk),

        .decodeReady(decodeReady),
        .mousevx(mousevx),
        .mousevy(mousevy),
        .mousedx(mousedx),
        .mousedy(mousedy),
        .debugX(debugX),
        .debugY(debugY),
        .debugLeft(debugLeft),
        .debugRight(debugRight),
        .debugMiddle(debugMiddle),
        .debugX8(debugX8),
        .debugY8(debugY8),
        .debugOX(debugOX),
        .debugOY(debugOY),
        .debugState(debugState),
        .debugCount(debugCount),
        .mousepush(mousepush)
    );

    // wire left_button;
    // wire right_button;
    // wire [8:0] x_increment;
    // wire [8:0] y_increment;
    // wire data_ready;
    // wire error_no_ack;

    // ps2_mouse_interface PS2MMIT(
    //     .clk(Div[0]),
    //     .reset(0),
    //     .ps2_clk(PS2_clk),
    //     .ps2_data(PS2_data),
    //     .left_button(mousepush),
    //     .right_button(right_button),
    //     .x_increment(x_increment),
    //     .y_increment(y_increment),
    //     .data_ready(data_ready),
    //     .read(1),
    //     .error_no_ack(error_no_ack)
    // );
    
    // wire        sx = x_increment[8];		// signs
    // wire        sy = y_increment[8];		
    // wire [8:0]  ndx = sx ? {1'b0,~x_increment[7:0]}+1 : {1'b0,x_increment[7:0]};	// magnitudes
    // wire [8:0]  ndy = sy ? {1'b0,~y_increment[7:0]}+1 : {1'b0,y_increment[7:0]};
    
    reg [1:0] mousepush_sample;
    reg [1:0] mouseready_sample;
    // assign mousevx = {9'b0, |(ndx[7:0])};
    // assign mousevy = {8'b0, |(ndy[7:0])};
    // assign mousedx = sx;
    // assign mousedy = sy;
    always @ (posedge clk) begin
        mousepush_sample <= {mousepush_sample[0], mousepush};
        mouseready_sample <= {mouseready_sample[0], mouseReady};
    end

    always @ (posedge clk) begin
        if(mousepush_sample == 2'b01) begin
            bgen <= ~bgen;     
        end
    end

    wire [31:0] hexdata_test = 32'hA5A5A5A5;

    // wire [31:0] hexdata = {
    //     8'hA5 + {7'd0, Div[26]},
    //     mouseY[7:0],
    //     Div[10], mouseReady, mouseState[1:0], 
    //     mousedy, mousedx, 1'b0, mousepush, 
    //     mouseData
    // };

    reg [7:0] data0, data1, data2, data3, data4, data5, data6, data7;

    reg [3:0] hexstate;

    always @ (posedge clk) begin
        case(hexstate)
            0: begin
                if(mouseready_sample == 2'b01) begin
                    hexstate <= 1;
                    data0 <= mouseData;
                end
                else hexstate <= hexstate;
            end
            1: begin
                if(mouseready_sample == 2'b01) begin
                    hexstate <= 2;
                    data1 <= mouseData;
                end
                else hexstate <= hexstate;
            end 
            2: begin
                if(mouseready_sample == 2'b01) begin
                    hexstate <= 3;
                    data2 <= mouseData;
                end
                else hexstate <= hexstate;
            end
            3: begin
                if(mouseready_sample == 2'b01) begin
                    hexstate <= 4;
                    data3 <= mouseData;
                end
                else hexstate <= hexstate;
            end
            4: begin
                if(mouseready_sample == 2'b01) begin
                    hexstate <= 5;
                    data4 <= mouseData;
                end
                else hexstate <= hexstate;
            end
            5: begin
                if(mouseready_sample == 2'b01) begin
                    hexstate <= 6;
                    data5 <= mouseData;
                end
                else hexstate <= hexstate;
            end
            6: begin
                if(mouseready_sample == 2'b01) begin
                    hexstate <= 7;
                    data6 <= mouseData;
                end
                else hexstate <= hexstate;
            end
            7: begin
                if(mouseready_sample == 2'b01) begin
                    hexstate <= 8;
                    data7 <= mouseData;
                end
                else hexstate <= hexstate;
            end
            8: begin
                if(~rstn) begin
                    hexstate <= 0;
                    data0    <= 0;
                    data1    <= 0;
                    data2    <= 0;
                    data3    <= 0;
                    data4    <= 0;
                    data5    <= 0;
                    data6    <= 0;
                    data7    <= 0;
                end
                else begin
                    hexstate <= hexstate;
                end
            end
        endcase
    end

    wire [31:0] hexdata0 = {data0, data1, data2, data3};
    wire [31:0] hexdata1 = {data4, data5, data6, data7};
    wire [31:0] hexdata2 = {3'b0, mousepush, debugState,debugY, debugX, debugOY, debugOX, debugY8, debugX8, 1'b0, debugMiddle, debugRight, debugLeft};
    wire [31:0] hexdata3 = {debugCount};

    reg [31:0] HEXDATA;
    always @ (posedge clk) begin
        case({SW[2], SW[1], SW[0]}) 
            0:       HEXDATA <= hexdata0;
            1:       HEXDATA <= hexdata1;
            2:       HEXDATA <= hexdata2;
            3:       HEXDATA <= hexdata3;
            default: HEXDATA <= hexdata_test;
        endcase
    end

    Display HEXS(
        .clk(Div[0]),
        .flash(0),
        .Hexs(HEXDATA),
        .LES(8'hFF),
        .point(8'h00),
        .rst(0),
        .Start(Div[20]),
        
        .seg_clk(SEGCLK),
        .seg_clrn(SEGCLR),
        .SEG_PEN(SEGEN),
        .seg_sout(SEGDT)
    );

    
endmodule
