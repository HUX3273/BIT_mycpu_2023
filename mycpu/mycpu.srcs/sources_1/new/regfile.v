`timescale 1ns / 1ps
//寄存器堆模块，二读一写的特性是MIPS指令集的格式决定的，一个指令最多同时读取两个寄存器，最多同时写一个寄存器，故在模块中
//共有三个读写端口。
module regfile(
    input   wire    clk,
    input   wire    rst,
    
    //写回段：write port
    input   wire                we,         //写使能
    input   wire[`RegAddrBus]   wRegAddr,   //$0~$31
    input   wire[`RegBus]       wdata,      //要写入的数据
    
    //译码段：read port1
    input   wire                re1,        //读使能1
    input   wire[`RegAddrBus]   rRegAddr1,  //$0~$31
    output  reg[`RegBus]        rdata1,     //要读出的数据
    
    //译码段：read port2
    input   wire                re2,        //读使能2
    input   wire[`RegAddrBus]   rRegAddr2,  //$0~$31
    output  reg[`RegBus]        rdata2      //要读出的数据
    );
    
    reg[`RegBus]   regs[0:`RegNum-1];   //32个寄存器$0~$31，每个寄存器存32位数据

// ************************************ 写寄存器 ************************************
    always @ (posedge clk) begin    //写操作只发生在时钟上升沿
        if (rst == `RstDisable) begin
            if((we == `WriteEnable) && (wRegAddr != 5'h0)) begin //$0寄存器只能存0，因此不能是写寄存器
                regs[wRegAddr] <= wdata;
            end
        end
    end
    
// ************************************ 读寄存器（端口1） ************************************
    always @ (*) begin  //一旦输入的读取地址变化，读操作立即执行，这里写*是为了表示这是组合逻辑而非时序逻辑，也可以换成rRegAddr1
        if (rst == `RstEnable) begin
            rdata1 <= `ZeroWord;
        end else if(rRegAddr1 == 5'h0) begin
            rdata1 <= `ZeroWord;
        end else if((rRegAddr1 == wRegAddr) && (we == `WriteEnable) && (re1 == `ReadEnable)) begin  //写后读
            rdata1 <= wdata;
        end else if(re1 == `ReadEnable) begin
            rdata1 <= regs[rRegAddr1];
        end else begin
            rdata1 <= `ZeroWord;
        end
    end
    
    
// ************************************ 读寄存器（端口2） ************************************
    always @ (*) begin  //一旦输入的读取地址变化，读操作立即执行，这里写*是为了表示这是组合逻辑而非时序逻辑，也可以换成rRegAddr2
        if (rst == `RstEnable) begin
            rdata2 <= `ZeroWord;
        end else if(rRegAddr2 == 5'h0) begin
            rdata2 <= `ZeroWord;
        end else if((rRegAddr2 == wRegAddr) && (we == `WriteEnable) && (re2 == `ReadEnable)) begin  //写后读
            rdata2 <= wdata;
        end else if(re2 == `ReadEnable) begin
            rdata2 <= regs[rRegAddr1];
        end else begin
            rdata2 <= `ZeroWord;
        end
    end
        
endmodule
