module ps2_keyboard(
    input clk,
    input clrn,
    input ps2_clk,
    input ps2_data,
    input rdn,

    output [7:0] data,
    output ready,
    output overflow,
    output [3:0] count
);

reg overflow_reg;
reg [3:0] count_reg;
reg [9:0] buffer;
reg [7:0] fifo[7:0];
reg [2:0] w_ptr, r_ptr;

reg [2:0] ps2_clk_sync;
always @ (posedge clk) begin
    ps2_clk_sync <= {ps2_clk_sync[1:0], ps2_clk};
end

wire sampling = ps2_clk_sync[2] & ~ps2_clk_sync[1];

always @ (posedge clk) begin
    if(clrn == 0) begin
        count <= 0;
        w_ptr <= 0;
        r_ptr <= 0;
        overflow <= 0;
    end
    else if(sampling) begin
        if()
    end
end

endmodule
