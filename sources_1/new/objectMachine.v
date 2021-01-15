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
        input [31:0] seed,
        input [9:0] col,
        input [9:0] row,
        input [9:0] mousex,
        input [9:0] mousey,
        input mousepush,
        input moveclk,
        input accclk,
        output wire [11:0] outputdata,
        output reg [31:0] score
    );

    parameter depth_bit = 18;

    reg [31:0] new_seed;
    wire [31:0] randn;
    reg random_rstn;
    randomNumberGenerator RANDG(
        .i_Clk(clk),
        .i_Enable(1),

        .i_Seed_DV(~(rstn & random_rstn)),
        .i_Seed_Data(new_seed),

        .o_LFSR_Data(randn)
    );

    reg explode;
    wire [2:0] selectfruit = randn[2:0];
    wire [depth_bit - 1:0] fruit_addr [0:7];
    // assign fruit_addr[0] = 26000;
    // assign fruit_addr[1] = 18000;
    // assign fruit_addr[2] = 36500;
    // assign fruit_addr[3] = 44500;
    // assign fruit_addr[4] = 52500;
    // assign fruit_addr[5] = 60500;
    // assign fruit_addr[6] = 68500;
    // assign fruit_addr[7] = 76500;
    assign fruit_addr[0] = 26000;
    assign fruit_addr[1] = 18000;
    assign fruit_addr[2] = 90900;
    assign fruit_addr[3] = 18000;
    assign fruit_addr[4] = 26000;
    assign fruit_addr[5] = 18000;
    assign fruit_addr[6] = 26000;
    assign fruit_addr[7] = 18000;

    wire [9 :0]          gen_initposx = (randn[9:0]) % 640;
    wire [9 :0]          gen_initposy = 375;
    wire [depth_bit-1:0] gen_addr     = fruit_addr[selectfruit];
    wire [9 :0]          gen_initvx   = 0 + randn[1:0];
    wire [9 :0]          gen_initvy   = 7 + randn[1:0];
    wire                 gen_initdx   = randn[0];

    wire                 random_restart = randn;

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

    wire [9 :0]          posx2;
    wire [9 :0]          posy2;
    wire                 oob2;
    reg  [9 :0]          initposx2;
    reg  [9 :0]          initposy2;
    reg  [9 :0]          initvx2;
    reg  [9 :0]          initvy2;
    reg                  initdx2;
    reg                  move2;
   
    wire [9:0] width1 = width >> 1;
    wire [9:0] width2 = width - width1;


    reg [3:0] state;

    reg      local_rstn;

    always @ (posedge clk) begin
        if(~rstn) begin
            state <= 0;
            move  <= 1;
            move2 <= 1;
            score <= 0;
            new_seed <= seed;
        end
        else begin
            case(state)
                0: begin
                    move      <= 1;
                    move2     <= 1;
                    initposx  <= gen_initposx;
                    initposx2 <= gen_initposx + width1;
                    initposy  <= gen_initposy;
                    initposy2 <= gen_initposy;
                    addr      <= gen_addr;
                    initvx    <= gen_initvx;
                    initvx2   <= gen_initvx;
                    initvy    <= gen_initvy;
                    initvy2   <= gen_initvy;
                    initdx    <= gen_initdx;
                    initdx2   <= gen_initdx;
                    local_rstn <= 0;
                    state <= 1;
                end 
                1: begin
                    state <= 6;
                    
                end
                2: begin
                    if(oob && oob2) begin
                        move  <= 0;
                        move2 <= 0; 
                        state <= 5;
                    end
                    else if(explode) begin
                        if(addr != 90900) begin
                            score       <= score + 1;    
                        end
                        else begin
                            if(score > 10) begin
                                score   <= score - 10;
                            end
                            else begin
                                score   <= 0;
                            end
                        end
                        new_seed    <= new_seed + 1;
                        random_rstn <= 0;
                        initposx    <= posx;
                        initposx2   <= posx2;
                        initposy    <= posy;
                        initposy2   <= posy2;
                        addr        <= addr;
                        initvx      <= 1;
                        initvx2     <= 1;
                        initvy      <= 0;
                        initvy2     <= 0;
                        initdx      <= 0;
                        initdx2     <= 1;
                        local_rstn  <= 0;   
                        state <= 3;
                    end
                    else begin
                        state <= 2;
                    end
                end
                3: begin
                   local_rstn  <= 1;
                   random_rstn <= 1;
                   state       <= 4; 
                end
                4: begin
                    if(oob || oob2) begin
                        if(oob && oob2) begin
                            move <= 0;
                            move2<= 0;
                        end
                        else if(oob) begin
                            move  <= 0;
                        end
                        else begin
                            move2 <= 0;
                        end
                        state <= 5;
                    end
                    else begin
                        state <= state;      
                    end
                end
                5: begin //TODO: 随机经过一段时间后初始化
                    case({oob, oob2})
                        2'b11: begin
                            if(random_restart) state <= 0;
                            else state <= state;
                        end
                        2'b10: begin
                            move <= 0;
                            state <= state;
                        end
                        2'b01: begin
                            move2 <= 0;
                            state <= state;
                        end
                        2'b00: begin
                            move <= 0;
                            move2 <= 0;
                            state <= 0;
                        end
                    endcase
                end
                6: begin
                    local_rstn <= 1;
                    state <= 2;
                end
                default: begin
                    state <= 0;
                end
            endcase
        end
    end

    always @ (posedge clk) begin
        if(mousex >= posx && mousex <= posx + width &&
           mousey >= posy && mousey <= posy + height &&
           mousepush) begin
               explode <= 1;
           end
        else begin
            explode <= 0;
        end
    end

    objectMotion OBJM(
        .clk      (clk),
        .rstn     (rstn & local_rstn),
        .moveen   (move),
        .moveclk  (moveclk),
        .accclk   (accclk),
        .width    (width1),
        .height   (height),
        .initposx (initposx),
        .initposy (initposy),
        .initvx   (initvx),
        .initvy   (initvy),
        .initdx   (initdx),
        .initdy   (0),
        .ax       (0),
        .ay       (1),
        .adx      (2'b00),
        .ady      (2'b11),
        .posx     (posx),
        .posy     (posy),
        .oob      (oob)
    );

    objectMotion OBJM2(
        .clk      (clk),
        .rstn     (rstn & local_rstn),
        .moveen   (move2),
        .moveclk  (moveclk),
        .accclk   (accclk),
        .width    (width2), //NOTE THAT HERE MAY INDUCE BUG IN OOB!
        .height   (height),
        .initposx (initposx2),
        .initposy (initposy2),
        .initvx   (initvx2),
        .initvy   (initvy2),
        .initdx   (initdx2),
        .initdy   (0),
        .ax       (0),
        .ay       (1),
        .adx      (2'b00),
        .ady      (2'b11),
        .posx     (posx2),
        .posy     (posy2),
        .oob      (oob2)
    );

    displayObj2 #(.memory_depth_base(depth_bit)) DISP(
        .clk                (clk),
        .en1                (1),
        .en2                (1),
        .col                (col),
        .row                (row),
        .posx1              (posx ),
        .posx2              (posx2),
        .posy1              (posy ),
        .posy2              (posy2),
        .width              (width),
        .height             (height),
        .memory_start_addr  (addr),
        .scaleX             (1),
        .scaleY             (1),
        .vga_data           (outputdata)
    );

endmodule
