`timescale 1ns / 1ps

module ex(
    input   wire                rst,
    input   wire[`AluSelBus]    alusel_i,
    input   wire[`AluOpBus]     aluop_i,
    input   wire[`RegBus]       src1_i,
    input   wire[`RegBus]       src2_i,
    input   wire                wreg_i, 
    input   wire[`RegAddrBus]   wDestRegAddr_i,
    
    //执行段的输出结果
    output  reg                 wreg_o, 
    output  reg[`RegAddrBus]    wDestRegAddr_o,
    output  reg[31:0]           wdata_o       //执行阶段计算出写入寄存器的数据
    );
    

    reg[`RegBus]    logicout;   //专门用于保存逻辑运算结果
    reg[`RegBus]    shiftres;   //专门用于保存移位运算结果
    
// ************************************ 一.根据aluop进行对应的运算操作 ************************************************************************
    always @ (*) begin
        if(rst == `RstEnable) begin
            logicout <= 32'h0;
            shiftres <= 32'h0;
        end else begin
            case (aluop_i)
                //逻辑
                `EXE_OR_OP: begin
                    logicout <= src1_i | src2_i;
                end
                `EXE_AND_OP: begin
                    logicout <= src1_i & src2_i;
                end
                `EXE_NOR_OP: begin
                    logicout <= ~(src1_i | src2_i);
                end
                `EXE_XOR_OP: begin
                    logicout <= src1_i ^ src2_i;
                end
                
                //移位
                `EXE_SLL_OP: begin
                    shiftres <= src2_i << src1_i[4:0];
                end
                `EXE_SRL_OP: begin
                    shiftres <= src2_i >> src1_i[4:0];
                end
                `EXE_SRA_OP: begin  //例：1100算术右移一位，结果1110；我们先将1100逻辑右移一位得到0110，再将1111
                                    //左移三位得到1000,在进行或运算0110|1000 = 1110得到结果
                                    //{32{src2_i[31]}}为每位都等于符号位的数
                    shiftres <= (src2_i >> src1_i[4:0]) | ({32{src2_i[31]}}<<(32 - src1_i[4:0]));
                end
                
                
                default:    begin
                    logicout <= 32'h0;
                    shiftres <= 32'h0;
                end
            endcase
        end//if
    end//always

// ************************************ 二.根据alusel选择运算结果 ************************************************************************
    always @ (*) begin
        wDestRegAddr_o <= wDestRegAddr_i;
        wreg_o <= wreg_i;
        case (alusel_i)
            `EXE_RES_LOGIC: begin
                wdata_o <= logicout;
            end
            `EXE_RES_SHIFT: begin
                wdata_o <= shiftres;
            end
        
            default:        begin
                wdata_o <= 32'h0;
            end
        endcase
    end
    
endmodule
