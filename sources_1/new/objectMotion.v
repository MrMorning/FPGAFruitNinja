`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/29 18:29:29
// Design Name: 
// Module Name: objectMotion
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


module objectMotion(
    input clk,
    input rstn,
    input keyReady,
    input [7:0] keyData, 
    input moveclk,
    input [9:0] width,
    input [8:0] height,
    input [9:0] initposx,
    input [8:0] initposy,
    input [31:0] Tx,
    input [31:0] Ty,
    input dx,
    input dy,
    
    output [9:0] posx,
    output [8:0] posy
    );

    wire oob;
    wire flagx;
    wire flagy;
    reg tdx;
    reg tdy;

    wire [1:0] ndx;
    wire [1:0] ndy;

    assign ndx[1] = 1;
    assign ndy[1] = 1;
    assign ndx[0] = tdx;
    assign ndy[0] = tdy;
    
    objectTransition OBJT(
        .clk(clk),
        .rst(~rstn),
        .moveclk(moveclk),
        .vx(1),
        .vy(1),
        .dx(ndx),
        .dy(ndy),
        .initPosX(initposx),
        .initPosY(initposy),
        
        .posx(posx),
        .posy(posy)
    );    

    
    initial begin
        tdx = dx;
        tdy = dy;
    end

    reg [1:0] oob_sample;
    reg [1:0] key_sample;

    always @ (posedge clk) begin
        oob_sample <= {oob_sample[0], oob};
        key_sample <= {key_sample[0], keyReady};
    end

    always @ (posedge clk) begin
        if(oob_sample == 2'b01) begin
            if(flagx) 
                tdx <= ~tdx;
            else 
                tdy <= ~tdy;
        end
        if(key_sample == 2'b01) begin
            case (keyData)
                8'h1D: tdy <= 0; 
                8'h1B: tdy <= 1;
                8'h1C: tdx <= 0;
                8'h23: tdx <= 1;
                default: ;
            endcase
        end
    end

    objectOutOfBound OOOB(
        .clk(clk),
        .posx(posx),
        .posy(posy),
        .width(width),
        .height(height),

        .flag_out(oob),
        .flagx_out(flagx),
        .flagy_out(flagy)
    );
         
endmodule
