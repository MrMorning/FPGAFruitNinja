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

    initial begin
        count_reg = 0;
        w_ptr = 0;
        r_ptr = 0;
        overflow_reg = 0;
    end
    reg overflow_reg;
    reg [3:0] count_reg;
    reg [9:0] buffer;
    reg [7:0] fifo[7:0];
    reg [2:0] w_ptr, r_ptr;

    reg [2:0] ps2_clk_sync;
    always @ (posedge clk) begin
        ps2_clk_sync <= {ps2_clk_sync[1:0], ps2_clk};
    end

    assign count = count_reg;
    assign overflow = overflow_reg;

    wire sampling = ps2_clk_sync[2] & ~ps2_clk_sync[1];

    always @ (posedge clk) begin
        if(clrn == 0) begin
            count_reg <= 0;
            w_ptr <= 0;
            r_ptr <= 0;
            overflow_reg <= 0;
        end
        else if(sampling) begin
            if(count_reg == 4'd10) begin
                if((buffer[0] == 0) && 
                (ps2_data)       &&
                (^buffer[9:1])) begin
                    fifo[w_ptr] <= buffer[8:1];
                    w_ptr <= w_ptr + 3'b1;
                    overflow_reg <= overflow_reg | (r_ptr == (w_ptr + 3'b1));
                end
                count_reg <= 0;
            end
            else begin
                buffer[count_reg] <= ps2_data;
                count_reg <= count_reg + 3'b1;
            end
        end
        if(!rdn && ready) begin
            r_ptr <= r_ptr + 3'b1;
            overflow_reg <= 0;
        end
    end

    assign ready = (w_ptr != r_ptr);
    assign data = fifo[r_ptr];

endmodule
