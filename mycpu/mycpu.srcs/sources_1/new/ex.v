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
    output  reg[31:0]           wdata_o       //ִ�н׶μ����д��Ĵ���������
    );
    
    //ר�����ڱ����߼�������
    reg[`RegBus]    logicout;
    
// ************************************ һ.����aluop���ж�Ӧ��������� ************************************
    always @ (*) begin
        if(rst == `RstEnable) begin
            logicout <= 32'h0;
        end else begin
            case (aluop_i)
                `EXE_OR_OP: begin
                    logicout <= src1_i | src2_i;
                end
                
                default:    begin
                    logicout <= 32'h0;
                end
            endcase
        end//if
    end//always

// ************************************ ��.����aluselѡ�������� ************************************
    always @ (*) begin
        wDestRegAddr_o <= wDestRegAddr_i;
        wreg_o <= wreg_i;
        case (alusel_i)
            `EXE_RES_LOGIC: begin
                wdata_o <= logicout;
            end
        
            default:        begin
                wdata_o <= 32'h0;
            end
        endcase
    end
    
endmodule
