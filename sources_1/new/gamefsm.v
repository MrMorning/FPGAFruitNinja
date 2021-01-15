`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/15 19:00:18
// Design Name: 
// Module Name: gamefsm
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


module gamefsm(
        input clk,
        input rstn,
        input leftpush,
        input middlepush,
        input rightpush,
        
        output reg [2:0] state,
        output wire [7:0] timer
    );

    wire clk_1s;
    clock_1s CLK1S(
        .clk(clk),
        .rstn(rstn),
        .clk_1s(clk_1s)
    );

    reg [7:0] count;
    
    assign timer = count;

    always @ (posedge clk) begin
        if(!rstn) begin
            state <= 0;
            count <= 0;
        end
        else begin
            case(state)
                0: begin
                    if(leftpush) begin
                        state <= 1;
                    end
                    else begin
                        state <= state;
                    end
                end
                1: begin
                    if(!middlepush && !rightpush) begin
                        if(count == 8'd59) begin
                            state <= 2;
                            count <= 0;
                        end else begin
                            state <= state;
                            if(clk_1s) count <= count + 1;
                            else    count <= count;
                        end
                    end
                    else if(middlepush) begin
                        count <= 0;
                        state <= 4;
                    end
                    else begin
                        count <= 0;
                        state <= 2;
                    end
                end
                2: begin
                    if(count == 8'd5) begin
                        state <= 0; 
                    end
                    else begin
                        state <= state;
                        if(clk_1s) count <= count + 1;
                        else    count <= count;
                    end
                end
                4: begin
                    if(leftpush) begin
                        state <= 1;
                    end
                    else begin
                        state <= state;
                    end
                end
            endcase
        end
    end    
endmodule
