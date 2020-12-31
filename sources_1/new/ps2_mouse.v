`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/30 16:49:55
// Design Name: 
// Module Name: ps2_mouse
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


module ps2_mouse(
    input clk,
    input clrn,
    inout ps2_clk,
    inout ps2_data,

    output [7:0] data,
    output wire ready,
    output reg [3:0] state
);

//Variable declaration and sampling
    wire [7:0] signal_send = 8'hF4;

    reg ps2_host_clock;
    reg ps2_host_clock_en;

    reg ps2_host_data;
    reg ps2_host_data_en;

    assign ps2_clk  = ps2_host_clock_en ? ps2_host_clock : 1'bz;
    assign ps2_data = ps2_host_data_en  ? ps2_host_data  : 1'bz;

    reg [1:0] ps2_sample;

    wire clk_100ms;
    reg [1:0] clk_100ms_sample;

    clock_100ms C100(
        .clk(clk),
        .clk_100ms(clk_100ms)
    );

    always @ (posedge clk) begin
        ps2_sample <= {ps2_sample[0], ps2_clk};
        clk_100ms_sample <= {clk_100ms_sample[0], clk_100ms};
    end

/////////////////////


//state handling
    // reg [3:0] state;

    /* state description
    0: not started.
    1: pulling down edge
    2: pulling down data(start) and release clock
    3: finish sending data to mouse and start to receive data from mouse.
    */
    initial state = 0;

    reg [3:0] send_count; // how many bits have been sent

    reg [10:0] receive_buffer;
    reg [3:0] receive_count;

    always @ (posedge clk) begin
        case(state)
            4'd0: begin
                if(clk_100ms_sample == 2'b01) begin //rising edge
                    ps2_host_clock_en <= 1;
                    ps2_host_clock    <= 0;  //pull down the clock
                    state <= 1;
                end
                else begin
                    state <= state;
                end
            end
            4'd1: begin
                if(clk_100ms_sample == 2'b10) begin
                    ps2_host_clock_en <= 0; //release the clock
                    ps2_host_data     <= 0;
                    ps2_host_data_en  <= 1;
                    state <= 2;
                    send_count <= 0;
                end
                else begin
                    state <= state;
                end
            end
            4'd2: begin
                if(ps2_sample == 2'b10) begin //wait until falling edge
                    if(send_count <= 4'd7) begin //send data bit
                        ps2_host_data <= signal_send[send_count[2:0]];
                        send_count <= send_count + 1;
                    end
                    else if(send_count == 4'd8) begin
                        ps2_host_data <= (^signal_send) ^ 1; //odd parity
                        send_count <= send_count + 1;
                    end
                    else if(send_count == 4'd9) begin
                        ps2_host_data <= 1;
                        send_count <= send_count + 1;
                    end
                    else begin
                        ps2_host_data_en <= 0;
                        state <= 3;
                    end
                end
                else begin
                    state <= state;
                    send_count <= send_count;
                end
            end
            4'd3: begin
                if(ps2_sample == 2'b10) begin
                    if(receive_count == 4'd0 || receive_count == 4'd11) begin
                        if(ps2_data != 1'b0) begin //not start signal
                            receive_count <= 0;
                        end
                        else begin
                            receive_buffer[0] = ps2_data;
                            receive_count <= 1;
                        end
                    end
                    else if(receive_count >= 4'd1 && receive_count <= 4'd8) begin
                        receive_buffer[receive_count] = ps2_data;
                        receive_count <= receive_count + 1;
                    end
                    else if(receive_count == 4'd9) begin
                        if((^receive_buffer[8:1]) ^ ps2_data) begin // odd parity
                            receive_buffer[receive_count] = ps2_data;
                            receive_count <= receive_count + 1;
                        end
                        else begin
                            receive_count <= 4'd0;
                        end
                    end
                    else if(receive_count == 4'd10) begin
                        if(ps2_data != 1'b1) begin
                            receive_count <= 0;
                        end
                        else begin
                            receive_count <= receive_count + 1;
                        end
                    end
                    else begin
                        receive_count <= 0;
                    end
                end
                else begin
                    state <= state;
                    receive_count <= receive_count;
                end
            end
            default: begin
                state <= state;
            end
        endcase
    end

    assign ready = (state == 3) & (receive_count == 11);
    assign data = ready ? receive_buffer[8:1] : 8'h00;

////////////////////////////////////

endmodule
