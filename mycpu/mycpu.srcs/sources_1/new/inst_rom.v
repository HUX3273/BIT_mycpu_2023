`timescale 1ns / 1ps

module inst_rom(
    input   wire                ce,
    input   wire[`InstAddrBus]  addr,
    output  reg[`InstBus]       inst
    );
    
    //定义一个数组作为指令rom，数组大小为InstMemNum，数组元素宽度为InstBus（4字节）
    reg[`InstBus]   inst_mem[0:`InstMemNum-1];
    
    //读文件"inst_rom.data"到指令rom中，仅仿真，综合无效
    initial $readmemh ("inst_rom.data",inst_mem);
    
    //
    always @ (*) begin
        if(ce == `ChipDisable) begin
            inst <= 32'h0;
        end else begin
            inst <= inst_mem[addr[`InstMemNumLog2 + 1:2]];  //因为cpu给出的指令地址是按字节寻址的，但是inst_mem是4字节
                               //一个元素的数组（即一个数组元素存一条完整的4字节指令），故需要取addr的18~2位作为数组下标,
                               //18是根据定义的inst_mem的最大容量决定的。
                               //如cpu给出的地址为0x0，对应指令在inst_mem数组中下标为0，表示这是第0条指令;
                               //如cpu给出的地址为0x4，对应指令在inst_mem数组中下标为1，表示这是第1条指令;
                               //如cpu给出的地址为0xc，对应指令在inst_mem数组中下标为3，表示这是第3条指令;
        end
    end
    
endmodule
