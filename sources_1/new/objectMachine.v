`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/04 16:56:20
// Design Name: 
// Module Name: objectMachine
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


module objectMachine(
        input clk,
        input rstn,
        input [9:0] col,
        input [9:0] row,
        input moveclk,
        input accclk,
        output wire [11:0] outputdata
    );

    parameter depth_bit = 18;

    wire [9 :0]          gen_initposx = 100;
    wire [9 :0]          gen_initposy = 375;
    wire [depth_bit-1:0] gen_addr     = 26000;
    wire [9 :0]          gen_initvx   = 4;
    wire [9 :0]          gen_initvy   = 5;
    wire                 gen_initdx   = 1;

    wire [9 :0]          posx;
    wire [9 :0]          posy;
    wire                 oob;
    wire [9 :0]          width  = 100;
    wire [9 :0]          height = 80;
    reg  [9 :0]          initposx;
    reg  [9 :0]          initposy;
    reg  [depth_bit-1:0] addr;
    reg  [9 :0]          initvx;
    reg  [9 :0]          initvy;
    reg                  initdx;
    reg                  move;



    reg [3:0] state;

    reg      local_rstn;

    always @ (posedge clk) begin
        if(~rstn) begin
            state <= 0;
            move  <= 1;
        end
        else begin
            case(state)
                0: begin
                    initposx <= gen_initposx;
                    initposy <= gen_initposy;
                    addr     <= gen_addr;
                    initvx   <= gen_initvx;
                    initvy   <= gen_initvy;
                    initdx   <= gen_initdx;
                    local_rstn <= 0;
                    state <= 1;
                end 
                1: begin
                    local_rstn <= 1;
                    state <= 2;
                end
                2: begin
                    if(oob) begin
                        state <= 3;
                    end
                    else begin
                        state <= 2;
                    end
                end
                3: begin //TODO: 随机经过一段时间后初始化
                    state <= 0;
                end
                default: begin
                    state <= 0;
                end
            endcase
        end
    end

    objectMotion OBJM(
        .clk      (clk),
        .rstn     (rstn & local_rstn),
        .moveen   (move),
        .moveclk  (moveclk),
        .accclk   (accclk),
        .width    (width),
        .height   (height),
        .initposx (initposx),
        .initposy (initposy),
        .initvx   (initvx),
        .initvy   (initvy),
        .initdx   (1),
        .initdy   (0),
        .ax       (0),
        .ay       (1),
        .adx      (2'b00),
        .ady      (2'b11),
        .posx     (posx),
        .posy     (posy),
        .oob      (oob)
    );

    displayObj #(.memory_depth_base(depth_bit)) DISP(
        .clk                (clk),
        .en                 (1),
        .col                (col),
        .row                (row),
        .posx               (posx),
        .posy               (posy),
        .width              (width),
        .height             (height),
        .memory_start_addr  (addr),
        .scaleX             (1),
        .scaleY             (1),
        .vga_data           (outputdata)
    );

endmodule
