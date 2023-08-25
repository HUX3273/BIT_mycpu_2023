`timescale 1ns / 1ps
//id�θ������ָ�����ָ�������ֶ�����ָ�ȷ��Ҫ��ȡ�ļĴ��������Ҫִ�е����㡢Ҫд���Ŀ�ļĴ���
//suffix�У�_i��ʾ���룬_o��ʾ���
module id(
    input   wire    rst,
    input   wire[`InstAddrBus]  pc_i,       //���뱻�����ָ����ָ��ROM�еĵ�ַ
    input   wire[`InstBus]      inst_i,     //���뱻�����ָ��
    
    //��ȡ��Regfile��ֵ
    input   wire[`RegBus]       reg1_data_i,    //����Ĵ����Ѷ��˿�1������
    input   wire[`RegBus]       reg2_data_i,    //����Ĵ����Ѷ��˿�2������
    
    //�����Regfile��ֵ
    output  reg                 reg1_read_o,    //����Ĵ����Ѷ��˿�1��ʹ���ź�
    output  reg                 reg2_read_o,    //����Ĵ����Ѷ��˿�2��ʹ���ź�
    output  reg[`RegAddrBus]    reg1_addr_o,    //����Ĵ����Ѷ��˿�1�Ķ���ַ
    output  reg[`RegAddrBus]    reg2_addr_o,    //����Ĵ����Ѷ��˿�2�Ķ���ַ
    
    //�͵�EX�ε���Ϣ
    output  reg[`AluOpBus]      aluop_o,    //�������������
    output  reg[`AluSelBus]     alusel_o,   //�����������
    output  reg[`RegBus]        reg1_o,     //���Դ������1��ALU����������֮һ
    output  reg[`RegBus]        reg2_o,     //���Դ������2��ALU����������֮һ
    output  reg                 wreg_o,     //���д�Ĵ���ʹ���ź�
    output  reg[`RegAddrBus]    wDestRegAddr_o  //���д�Ĵ�����ַ
    
    );
    
     //ȡָ���ָ����͹�����
    wire[5:0]   op = inst_i[31:26]; 
    wire[4:0]   op2 = inst_i[10:6];     //sa
    wire[5:0]   op3 = inst_i[5:0];      //func
    wire[4:0]   op4 = inst_i[20:16];
    
    //�����Iָ���Ҫ��ָ���е�������
    reg[`RegBus]    imm;
    
    reg instValid;  //ָ���Ƿ���Ч    
    
// ************************************ һ.ָ������ ************************************
    always @ (*) begin
        if (rst == `RstEnable) begin
            aluop_o <= `EXE_NOP_OP;
            alusel_o <= `EXE_RES_NOP;
            wDestRegAddr_o <= `NOPRegAddr;
            wreg_o  <= `WriteDisable;
            instValid <= `InstValid;
            reg1_read_o <= 1'b0;
            reg2_read_o <= 1'b0;
            reg1_addr_o <= `NOPRegAddr;
            reg2_addr_o <= `NOPRegAddr;
            imm <= 32'h0;
        end else begin
            aluop_o <= `EXE_NOP_OP;
            alusel_o <= `EXE_RES_NOP;
            wDestRegAddr_o <= inst_i[15:11];//д��ַ
            wreg_o  <= `WriteDisable;   //�Ƿ�д�Ĵ�������Ҫ�������ָ������
            instValid <= `InstInvalid;
            reg1_read_o <= 1'b0;
            reg2_read_o <= 1'b0;
            reg1_addr_o <= inst_i[25:21];
            reg2_addr_o <= inst_i[20:16];
            imm <= 32'h0;
            
            case (op)
                `EXE_ORI:   begin
                    wreg_o <= `WriteEnable;         //��Ҫд�Ĵ���
                    aluop_o <= `EXE_OR_OP;          //�߼�������
                    alusel_o <= `EXE_RES_LOGIC;     //�߼���������
                    reg1_read_o <= 1'b1;        //��Ҫ���˿�1
                    reg2_read_o <= 1'b0;        //����Ҫ���˿�2
                    imm <= {16'h0,inst_i[15:0]};    //iָ�ȡ��������������������չ��32λ
                    wDestRegAddr_o <= inst_i[20:16];    //д�Ĵ�����ַ
                    instValid <= `InstValid;
                end
                default:    begin
                end
            endcase
        end//if
    end//always 
    
// ************************************ ��.ȷ��Դ������1 ************************************
    always @ (*) begin 
        if(rst == `RstEnable) begin
            reg1_o <= 32'h0;
        end else if(reg1_read_o == 1'b1) begin
            reg1_o <= reg1_data_i;
        end else if(reg1_read_o == 1'b0) begin
            reg1_o <= imm;
        end else begin
            reg1_o <= 32'h0;
        end
    end
    
// ************************************ ��.ȷ��Դ������2 ************************************
    always @ (*) begin 
        if(rst == `RstEnable) begin
            reg2_o <= 32'h0;
        end else if(reg2_read_o == 1'b1) begin
            reg2_o <= reg2_data_i;
        end else if(reg2_read_o == 1'b0) begin
            reg2_o <= imm;
        end else begin
            reg2_o <= 32'h0;
        end
    end 
    
    
endmodule
