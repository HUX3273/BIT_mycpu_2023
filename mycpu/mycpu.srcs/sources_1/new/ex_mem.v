`timescale 1ns / 1ps

module ex_mem(
    input   wire  clk,
    input   wire  rst,
    
    input   wire[`RegAddrBus]   ex_wDestRegAddr,
    input   wire                ex_wreg,
    input   wire[`RegBus]       ex_wdata,
    
    //Êä³ö
    output  reg[`RegAddrBus]    mem_wDestRegAddr,
    output  reg                 mem_wreg,
    output  reg[`RegBus]        mem_wdata
    );
    
    always @ (posedge clk) begin
        if(rst == `RstEnable) begin
            mem_wDestRegAddr <= `NOPRegAddr;
            mem_wreg <= `WriteDisable;
            mem_wdata <= 32'h0;
        end else begin
            mem_wDestRegAddr <= ex_wDestRegAddr;
            mem_wreg <= ex_wreg;
            mem_wdata <= ex_wdata;
        end
    end
    
endmodule
