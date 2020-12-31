module ps2_host_to_mouse(
    input clk,
    input en,
    input [7:0] din,

    output wire finish
);
//Variable declaration and sampling
wire clk_100ms;
reg [1:0] clk_100ms_sample;

clock_100ms C100(
    .clk(clk),
    .clk_100ms(clk_100ms)
);

reg [1:0] en_sample;

always @ (posedge clk) begin
    en_sample        <= {       en_sample[0], en};
    clk_100ms_sample <= {clk_100ms_sample[0], clk_100ms};
end
////////////////////////////////////

reg [3:0] state;
/*
state description:
0: not started.
1: received en signal, start transmission
*/

always @ (posedge clk)
    case (state)
        0 : begin
            if(en_sample == 2'b01) begin
                state <= 1;
            end
            else begin
                state <= 0;
            end
        end 
        1: begin
            if(clk_100ms_sample == 2'b01) begin //check rising edge of 100ms clock
                
            end
        end
        default: begin
            
        end
    endcase
endmodule