`timescale 1ns / 1ps

module ex(
    input   wire                rst,
    input   wire[`AluSelBus]    alusel_i,
    input   wire[`AluOpBus]     aluop_i,
    input   wire[`RegBus]       src1_i,
    input   wire[`RegBus]       src2_i,
    input   wire                wreg_i, 
    input   wire[`RegAddrBus]   wDestRegAddr_i,
    
    //ִ�жε�������
    output  reg                 wreg_o, 
    output  reg[`RegAddrBus]    wDestRegAddr_o,
    output  reg[31:0]           wdata_o,       //ִ�н׶μ����д��Ĵ���������
    
    //
    input   wire                in_delayslot_i
    
    );
    

    reg[`RegBus]    logicout;       //ר�����ڱ����߼�������
    reg[`RegBus]    shiftres;       //ר�����ڱ�����λ������
    reg[`RegBus]    arithmeticres;  //ר�����ڱ�������������
    
    wire overflow;//�Ƿ����
    wire[`RegBus] src2_i_mux; //�����з��űȽ�ʱΪsrc2�Ĳ��룬����Ϊsrc2
    wire[`RegBus] result_sum;
    
    
    assign src2_i_mux = ((aluop_i==`EXE_SUB_OP)||(aluop_i==`EXE_SUBU_OP)||(aluop_i==`EXE_SLT_OP))?(~src2_i) + 1:src2_i;
    assign result_sum = src1_i + src2_i_mux;
    //�з��żӣ����Ӹ�Ϊ������������λ���������
    assign overflow = ((!src1_i[31] && !src2_i_mux[31]) && result_sum[31]) || ((src1_i[31] && src2_i_mux[31]) && (!result_sum[31]));
    
    
    
// ************************************ һ.����aluop���ж�Ӧ��������� ************************************************************************
    always @ (*) begin
        if(rst == `RstEnable) begin
            logicout <= 32'h0;
            shiftres <= 32'h0;
            arithmeticres <= 32'h0;
        end else if(in_delayslot_i == 1) begin
            //��ִ���ӳٲ�ָ��
        end else begin
            case (aluop_i)
                //�߼�
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
                
                //��λ
                `EXE_SLL_OP: begin
                    shiftres <= src2_i << src1_i[4:0];
                end
                `EXE_SRL_OP: begin
                    shiftres <= src2_i >> src1_i[4:0];
                end
                `EXE_SRA_OP: begin  //����1100��������һλ�����1110�������Ƚ�1100�߼�����һλ�õ�0110���ٽ�1111
                                    //������λ�õ�1000,�ڽ��л�����0110|1000 = 1110�õ����
                                    //{32{src2_i[31]}}Ϊÿλ�����ڷ���λ����
                    shiftres <= (src2_i >> src1_i[4:0]) | ({32{src2_i[31]}}<<(32 - src1_i[4:0]));
                end
                
                //����
                `EXE_ADD_OP:    begin
                    arithmeticres <= src1_i + src2_i;
                end
                `EXE_ADDU_OP:   begin
                    arithmeticres <= src1_i + src2_i;
                end
                `EXE_SUB_OP:    begin
                    arithmeticres <= result_sum;
                end
                `EXE_SUBU_OP:   begin
                    arithmeticres <= result_sum;
                end
                `EXE_SLT_OP:    begin
                    arithmeticres <= ((src1_i[31] && !src2_i[31])||(!src1_i[31] && src2_i[31] && result_sum[31])||
                                        (src1_i[31] && src2_i[31] && result_sum[31]));
                end
                `EXE_SLTU_OP:   begin
                    arithmeticres <= src1_i < src2_i ? 1 : 0;
                end
                
                //��ת
                `EXE_J_OP: begin
                    
                end
                
                default:    begin
                    logicout <= 32'h0;
                    shiftres <= 32'h0;
                    arithmeticres <= 32'h0;
                end
            endcase
        end//if
    end//always

// ************************************ ��.����aluselѡ�������� ************************************************************************
    always @ (*) begin
        wDestRegAddr_o <= wDestRegAddr_i;
        if ( ((aluop_i ==`EXE_ADD_OP)||(aluop_i ==`EXE_SUB_OP))&& (overflow == 1) ) begin
            wreg_o <= `WriteDisable;
        end else if (in_delayslot_i == 1) begin
            wreg_o <= `WriteDisable;
        end else begin
            wreg_o <= wreg_i;
        end
        
        case (alusel_i)
            `EXE_RES_LOGIC: begin
                wdata_o <= logicout;
            end
            `EXE_RES_SHIFT: begin
                wdata_o <= shiftres;
            end
            `EXE_RES_ARITHMETIC: begin
                wdata_o <= arithmeticres;
            end
            
            default: begin
                wdata_o <= 32'h0;
            end
        endcase
    end
    
endmodule
