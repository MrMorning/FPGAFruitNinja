`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/28 12:35:14
// Design Name: 
// Module Name: memoryRead
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


module memoryRead(
    input clk,
    input [depth_base-1 : 0] addr,

    output [width_base-1 : 0] data
    );
parameter 
    width_base = 12,
    depth_base = 13;
    

    blk_mem_gen_0 M1 (
      .clka(clk),    // input wire clka
      .addra(addr),  // input wire [9 : 0] addra
      .douta(data)  // output wire [11 : 0] douta
    );
    

endmodule
