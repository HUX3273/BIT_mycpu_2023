`timescale 1ns / 1ps


module id_ex(
    input   wire    clk,
    input   wire    rst,
    
    input   wire[`AluOpBus]     id_aluop,   //id传过来的aluop
    input   wire[`AluSelBus]    id_alusel,  //id传过来的alusel
    input   wire[`RegBus]       id_reg1,    //id传过来的ALU操作数1
    input   wire[`RegBus]       id_reg2,    //id传过来的ALU操作数2
    input   wire[`RegAddrBus]   id_wDestRegAddr,    //写寄存器地址和写使能信号会一直在流水寄存器中传递到写回段wb
    input   wire                id_wreg,
    
    output   reg[`AluOpBus]     ex_aluop,   //传给ex的aluop
    output   reg[`AluSelBus]    ex_alusel,  //传给ex的alusel
    output   reg[`RegBus]       ex_reg1,    //传给ex的ALU操作数1
    output   reg[`RegBus]       ex_reg2,    //传给ex的ALU操作数2
    output   reg[`RegAddrBus]   ex_wDestRegAddr,    //写寄存器地址和写使能信号会一直在流水寄存器中传递到写回段wb
    output   reg                ex_wreg
    );
    
    always @ (posedge clk) begin
        if(rst == `RstEnable) begin
            ex_aluop <= `EXE_NOP_OP;
            ex_alusel <= `EXE_RES_NOP;
            ex_reg1 <= 32'h0;
            ex_reg2 <= 32'h0;
            ex_wDestRegAddr <= `NOPRegAddr;
            ex_wreg <= `WriteDisable;
        end else begin
            ex_aluop <= id_aluop;
            ex_alusel <= id_alusel;
            ex_reg1 <= id_reg1;
            ex_reg2 <= id_reg2;
            ex_wDestRegAddr <= id_wDestRegAddr;
            ex_wreg <= id_wreg;
        end
    end
    
endmodule
