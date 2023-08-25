`timescale 1ns / 1ps

module mem(
    input   wire  rst,
    
    input   wire[`RegAddrBus]   wDestRegAddr_i,
    input   wire                wreg_i,
    input   wire[`RegBus]       wdata_i,
    
    //Êä³ö
    output  reg[`RegAddrBus]    wDestRegAddr_o,
    output  reg                 wreg_o,
    output  reg[`RegBus]        wdata_o
    );
    
    always @ (*) begin
        if(rst == `RstEnable) begin
            wDestRegAddr_o <= `NOPRegAddr;
            wreg_o <= `WriteDisable;
            wdata_o <= 32'h0;
        end else begin
            wDestRegAddr_o <= wDestRegAddr_i;
            wreg_o <= wreg_i;
            wdata_o <= wdata_i;
        end
    end
    
endmodule
