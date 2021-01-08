// Code by Chen Geng on 08 Jan 2021
module objectMotion2(
    input clk,
    input rstn,
    input moveen1,
    input moveen2,
    input moveclk,
    input accclk,
    input [9:0] width,
    input [9:0] height,
    input [9:0] initposx1,
    input [9:0] initposx2,
    input [9:0] initposy1,
    input [9:0] initposy2,
    input [9:0] initvx1,
    input [9:0] initvx2,
    input [9:0] initvy1,
    input [9:0] initvy2,
    input initdx1,
    input initdx2,
    input initdy1,
    input initdy2,
    input [9:0] ax1,
    input [9:0] ax2,
    input [9:0] ay1,
    input [9:0] ay2,
    input [1:0] adx1,
    input [1:0] adx2,
    input [1:0] ady1,
    input [1:0] ady2,
    
    output [9:0] posx1,
    output [9:0] posx2,
    output [9:0] posy1,
    output [9:0] posy2,
    output wire oob1,
    output wire oob2
    );

    wire flagx;
    wire flagy;
    reg tdx;
    reg tdy;

    wire [1:0] ndx;
    wire [1:0] ndy;

    wire [9:0] vx;
    wire [9:0] vy;
    
    objectTransition OBJT(
        .clk(clk),
        .en(moveen),
        .rst(~rstn),
        .moveclk(moveclk),
        .vx(vx),
        .vy(vy),
        .dx(ndx),
        .dy(ndy),
        .initPosX(initposx),
        .initPosY(initposy),
        
        .posx(posx),
        .posy(posy)
    );    

    objectAccelerate OBJV(
        .clk(clk),
        .rst(~rstn),
        .accclk(accclk),
        .initvx(initvx),
        .initvy(initvy),
        .initvdx({1'b1, initdx}),
        .initvdy({1'b1, initdy}),
        .ax(ax),
        .ay(ay),
        .adx(adx),
        .ady(ady),

        .vx(vx),
        .vy(vy),
        .vdx(ndx),
        .vdy(ndy)
    );    


    reg [1:0] oob_sample;
    reg [1:0] key_sample;

    always @ (posedge clk) begin
        oob_sample <= {oob_sample[0], oob};
    end

    always @ (posedge clk) begin
        if(oob_sample == 2'b01) begin
            if(flagx) 
                tdx <= ~tdx;
            else 
                tdy <= ~tdy;
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
