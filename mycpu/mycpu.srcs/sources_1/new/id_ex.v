`timescale 1ns / 1ps


module id_ex(
    input   wire    clk,
    input   wire    rst,
    
    input   wire[`AluOpBus]     id_aluop,   //id��������aluop
    input   wire[`AluSelBus]    id_alusel,  //id��������alusel
    input   wire[`RegBus]       id_reg1,    //id��������ALU������1
    input   wire[`RegBus]       id_reg2,    //id��������ALU������2
    input   wire[`RegAddrBus]   id_wDestRegAddr,    //д�Ĵ�����ַ��дʹ���źŻ�һֱ����ˮ�Ĵ����д��ݵ�д�ض�wb
    input   wire                id_wreg,
    
    output   reg[`AluOpBus]     ex_aluop,   //����ex��aluop
    output   reg[`AluSelBus]    ex_alusel,  //����ex��alusel
    output   reg[`RegBus]       ex_reg1,    //����ex��ALU������1
    output   reg[`RegBus]       ex_reg2,    //����ex��ALU������2
    output   reg[`RegAddrBus]   ex_wDestRegAddr,    //д�Ĵ�����ַ��дʹ���źŻ�һֱ����ˮ�Ĵ����д��ݵ�д�ض�wb
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
