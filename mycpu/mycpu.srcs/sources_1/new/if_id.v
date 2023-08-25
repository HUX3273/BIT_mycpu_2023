`timescale 1ns / 1ps

//流水寄存器模块，位于取指段（instruction fetch）和译码段（instruction decode）间，存储pc和inst以实现id和if段的数据流水；
//流水寄存器功能：  1.不reset时保存并传递信息到下一段
//                 2.reset时将所有存储的信息复位并停止传递信息
module if_id(
    input   wire                clk,
    input   wire                rst,
    input   wire[`InstAddrBus]  if_pc,      //取值段取出的指令的地址
    input   wire[`InstBus]      if_inst,    //取值段取出的指令
    
    output  reg[`InstAddrBus]   id_pc,      //传递指令的地址
    output  reg[`InstBus]       id_inst     //传递指令
    );
    
    always @ (posedge clk) begin
        if(rst == `RstEnable) begin
            id_pc <= `ZeroWord;
            id_inst <= `ZeroWord;
        end else begin
            id_pc <= if_pc;
            id_inst <= if_inst;
        end
    end
    
endmodule
