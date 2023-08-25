`timescale 1ns / 1ps

module mem_wb(
    input   wire  clk,
    input   wire  rst,
    
    input   wire[`RegAddrBus]   mem_wDestRegAddr,
    input   wire                mem_wreg,
    input   wire[`RegBus]       mem_wdata,
    
    //Êä³ö
    output  reg[`RegAddrBus]    wb_wDestRegAddr,
    output  reg                 wb_wreg,
    output  reg[`RegBus]        wb_wdata
    );
    
    always @ (posedge clk) begin
        if(rst == `RstEnable) begin
            wb_wDestRegAddr <= `NOPRegAddr;
            wb_wreg <= `WriteDisable;
            wb_wdata <= 32'h0;
        end else begin
            wb_wDestRegAddr <= mem_wDestRegAddr;
            wb_wreg <= mem_wreg;
            wb_wdata <= mem_wdata;
        end
    end
    
endmodule
