`timescale 1ns / 1ps

`define H_SYNC_PULSE    11'd136
`define H_FRONT_PORCH   11'd24
`define H_ACTIVE        11'd1024
`define H_BACK_PORCH    11'd160
`define H_TOTAL         11'd1344
        
`define V_SYNC_PULSE    11'd6
`define V_FRONT_PORCH   11'd3
`define V_ACTIVE        11'd768
`define V_BACK_PORCH    11'd29
`define V_TOTAL         11'd806

`define WHITE_R 4'b1111
`define WHITE_G 4'b1111
`define WHITE_B 4'b1111

`define BLACK_R 4'b0000
`define BLACK_G 4'b0000
`define BLACK_B 4'b0000

`define RED_R 4'b1111
`define RED_G 4'b0000
`define RED_B 4'b0000

`define GREEN_R  4'b0010
`define GREEN_G  4'b0100
`define GREEN_B  4'b1000

module vga (
        input           clk,
        input           rst,
        input [3:0]     num,
        
        output          hs,
        output          vs,
        output [3:0]    r,
        output [3:0]    g,
        output [3:0]    b
        
    );
    
    assign hs = 1'b1;
    assign vs = 1'b1;
    assign r = 4'b1111;
    assign g = 4'b1111;
    assign b = 4'b1111;

endmodule
