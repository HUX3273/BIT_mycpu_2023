//***************************     全局宏定义   *************************** 

`define RstEnable       1'b1        //复位信号有效
`define RstDisable      1'b0        //复位信号无效
`define ZeroWord        32'h0000_0000       //32位的0
`define WriteEnable     1'b1    //写使能
`define WriteDisable    1'b0    // 禁止写
`define ReadEnable      1'b1    //读使能
`define ReadDisable     1'b0    // 禁止读
`define AluOpBus        7:0     //ID阶段的输出aluop_o的宽度（_o表示输出，_i表示输入）
`define AluSelBus       2:0     //ID阶段的输出alusel_o的宽度
`define InstValid       1'b0    //指令有效
`define InstInvalid     1'b1    //指令无效
`define True_v          1'b1    //逻辑真
`define False_v         1'b0    //逻辑假
`define ChipEnable      1'b1    //芯片使能
`define ChipDisable     1'b0    //芯片禁止


//***************************     指令相关的宏定义  *************************** 

//special类指令的指令码，26~31bit：
`define EXE_SPECIAL_INST    6'b000_000      //所有special类指令的共同指令码

//special类指令的功能码，0~5bit：
`define EXE_AND     6'b100_100      //AND的功能码
`define EXE_OR      6'b100_101      //OR的功能码
`define EXE_XOR     6'b100_110      //XOR的功能码
`define EXE_NOR     6'b100_111      //NOR的功能码
`define EXE_SLL     6'b000_000      //SLL的功能码
`define EXE_SRL     6'b000_010      //SRL的功能码
`define EXE_SRA     6'b000_011      //SRA的功能码
`define EXE_SLLV    6'b000_100      //SLLV的功能码
`define EXE_SRLV    6'b000_110      //SRLV的功能码
`define EXE_SRAV    6'b000_111      //SRAV的功能码

`define EXE_ADD     6'b100_000      //ADD的功能码（检测溢出，发生溢出时不保存结果）
`define EXE_ADDU    6'b100_001      //ADDU的功能码（无符号数运算不检测溢出）
`define EXE_SUB     6'b100_010      //SUB的功能码
`define EXE_SUBU    6'b100_011      //SUBU的功能码
`define EXE_SLT     6'b101_010      //SLT的功能码
`define EXE_SLTU    6'b101_011      //SLTU的功能码

//非special类指令的指令码，26~31bit：
`define EXE_ANDI    6'b001_100      //ANDI的指令码
`define EXE_ORI     6'b001_101      //ori的指令码
`define EXE_XORI    6'b001_110      //xori的指令码
`define EXE_LUI     6'b001_111      //lui的指令码
`define EXE_NOP     6'b000_000      //nop


//Alu执行的运算类型op
`define EXE_AND_OP      8'b0010_0100
`define EXE_OR_OP       8'b0010_0101
`define EXE_XOR_OP       8'b0010_0110 
`define EXE_NOR_OP       8'b0010_0111
`define EXE_SLL_OP       8'b0000_0000
`define EXE_SRL_OP       8'b0000_0010
`define EXE_SRA_OP       8'b0000_0011

`define EXE_ADD_OP      8'b0010_0000
`define EXE_ADDU_OP     8'b0010_0001
`define EXE_SUB_OP      8'b0010_0010
`define EXE_SUBU_OP      8'b0010_0011
`define EXE_SLT_OP      8'b0010_1010
`define EXE_SLTU_OP     8'b0010_1011

`define EXE_NOP_OP      8'b0000_0000


//Alu执行的结果类型sel
`define EXE_RES_LOGIC       3'b001//逻辑
`define EXE_RES_SHIFT       3'b010//移位
`define EXE_RES_ARITHMETIC  3'b011//算术
`define EXE_RES_NOP         3'b000


//***************************     指令寄存器ROM相关的宏定义   *************************** 

`define InstAddrBus         31:0        // ROM的地址总线宽度
`define InstBus             31:0        //ROM的数据总线宽度
`define InstMemNum          4096        //ROM的实际大小为4096B
`define InstMemNumLog2      10          //ROM实际的地址宽度,2^10=1K,1K*4B=4KB


//***************************     通用寄存器Regfile相关的宏定义   *************************** 

`define RegAddrBus      4:0     //Regfile模块的地址线宽度，因为只有32个通用寄存器，故只需要5位
`define RegBus          31:0    //Regfile模块的数据线宽度
`define RegWidth        32      //通用寄存器的宽度
`define DoubleRegWidth  64      //两倍通用寄存器的宽度
`define DoubleRegBus    63:0    //两倍通用寄存器的数据线宽度
`define RegNum          32      //通用寄存器的数量
`define RegNumLog2      5       //寻址通用寄存器使用的地址位数，因为只有32个通用寄存器，故只需要5位
`define NOPRegAddr      5'b00000
