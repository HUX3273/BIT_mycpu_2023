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
    output  reg[`RegAddrBus]    wDestRegAddr_o,  //���д�Ĵ�����ַ
    
    
//Ϊ�˽��������أ�ֻ�����д���������أ�������������·����ex�κ�mem�εĴ�д������ֱ�Ӵ���id��
    //1.ex�δ������ݿ��Խ������ָ���������أ�
    input   wire                ex_wreg_i,
    input   wire[`RegAddrBus]   ex_wDestRegAddr_i,
    input   wire[`RegBus]       ex_wdata_i,
    //2.mem�δ������ݿ��Խ�����һ��ָ����������
    input   wire                mem_wreg_i,
    input   wire[`RegAddrBus]   mem_wDestRegAddr_i,
    input   wire[`RegBus]       mem_wdata_i,
    
    //ָ����ת
    output  reg                     branch_flag_o,
    output  reg[`InstAddrBus]       branch_target_addr_o,
    output  reg                     in_delayslot_o,
    output  reg                     next_inst_in_delayslot_o,
    input   wire                    in_delayslot_i
    
    );
    
     //ȡָ���ָ����͹�����
    wire[5:0]   op = inst_i[31:26];     //ָ����
    wire[4:0]   op2 = inst_i[10:6];     //��λλ��
    wire[5:0]   op3 = inst_i[5:0];      //������
    wire[4:0]   op4 = inst_i[20:16];
    
    //�����Iָ���Ҫ��ָ���е�������
    reg[`RegBus]    imm;
    
    //
    wire[`RegBus] pc_plus_4;
    assign pc_plus_4 = pc_i + 4;//�����pc��һ��ָ��ĵ�ַ
    
    reg instValid;  //ָ���Ƿ���Ч    
    
// ************************************ һ.ָ������ ************************************************************************
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
            
            branch_flag_o <= 0;
            branch_target_addr_o <= 0;
            next_inst_in_delayslot_o <= 0;
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
            
            branch_flag_o <= 0;
            branch_target_addr_o <= 0;
            next_inst_in_delayslot_o <= 0;
            case (op)
                `EXE_J:   begin
                    wreg_o <= `WriteDisable;         //����Ҫд�Ĵ���
                    aluop_o <= `EXE_J_OP;         //����
                    alusel_o <= `EXE_RES_JUMP;     //��������
                    reg1_read_o <= 1'b0;            //����Ҫ���˿�1
                    reg2_read_o <= 1'b0;            //����Ҫ���˿�2
                    instValid <= `InstValid;
                    if (in_delayslot_i == 0) begin  //����������������תָ��
                        branch_flag_o <= 1;
                    end
                    branch_target_addr_o <= { pc_plus_4[31:20] , inst_i[19:0]  };
                    next_inst_in_delayslot_o <= 1;
                         
                end
                `EXE_ANDI:   begin
                    wreg_o <= `WriteEnable;         //��Ҫд�Ĵ���
                    aluop_o <= `EXE_AND_OP;         //�߼�������
                    alusel_o <= `EXE_RES_LOGIC;     //�߼���������
                    reg1_read_o <= 1'b1;            //��Ҫ���˿�1
                    reg2_read_o <= 1'b0;            //����Ҫ���˿�2
                    imm <= {16'h0,inst_i[15:0]};    //iָ�ȡ��������������������չ��32λ
                    wDestRegAddr_o <= inst_i[20:16];    //�õ�д�Ĵ�����ַ
                    instValid <= `InstValid;
                end
                `EXE_ORI:   begin
                    wreg_o <= `WriteEnable;         //��Ҫд�Ĵ���
                    aluop_o <= `EXE_OR_OP;          //�߼�������
                    alusel_o <= `EXE_RES_LOGIC;     //�߼���������
                    reg1_read_o <= 1'b1;            //��Ҫ���˿�1
                    reg2_read_o <= 1'b0;            //����Ҫ���˿�2
                    imm <= {16'h0,inst_i[15:0]};    //iָ�ȡ��������������������չ��32λ
                    wDestRegAddr_o <= inst_i[20:16];    //�õ�д�Ĵ�����ַ
                    instValid <= `InstValid;
                end
                `EXE_ANDI:   begin
                    wreg_o <= `WriteEnable;         //��Ҫд�Ĵ���
                    aluop_o <= `EXE_AND_OP;         //�߼�������
                    alusel_o <= `EXE_RES_LOGIC;     //�߼���������
                    reg1_read_o <= 1'b1;            //��Ҫ���˿�1
                    reg2_read_o <= 1'b0;            //����Ҫ���˿�2
                    imm <= {16'h0,inst_i[15:0]};    //iָ�ȡ��������������������չ��32λ
                    wDestRegAddr_o <= inst_i[20:16];    //�õ�д�Ĵ�����ַ
                    instValid <= `InstValid;
                end
                `EXE_XORI:   begin
                    wreg_o <= `WriteEnable;         //��Ҫд�Ĵ���
                    aluop_o <= `EXE_XOR_OP;         //�߼��������
                    alusel_o <= `EXE_RES_LOGIC;     //�߼���������
                    reg1_read_o <= 1'b1;            //��Ҫ���˿�1
                    reg2_read_o <= 1'b0;            //����Ҫ���˿�2
                    imm <= {16'h0,inst_i[15:0]};    //iָ�ȡ��������������������չ��32λ
                    wDestRegAddr_o <= inst_i[20:16];    //�õ�д�Ĵ�����ַ
                    instValid <= `InstValid;
                end
               `EXE_LUI:   begin
                    wreg_o <= `WriteEnable;         //��Ҫд�Ĵ���
                    aluop_o <= `EXE_OR_OP;          //�߼������㣨��Ҫ��ֵ֤���䣬�ʽ�ȡ������չ��������0���л����㣩
                    alusel_o <= `EXE_RES_LOGIC;     //�߼���������
                    reg1_read_o <= 1'b1;            //��Ҫ���˿�1����Ϊ$0)
                    reg2_read_o <= 1'b0;            //����Ҫ���˿�2
                    imm <= {inst_i[15:0],16'h0};    //ȡ����������16λΪimm����16λ��0����������д�ؼĴ�������
                    wDestRegAddr_o <= inst_i[20:16];    //�õ�д�Ĵ�����ַ
                    instValid <= `InstValid;
                end
                `EXE_SPECIAL_INST:   begin  //special��ָ��
                    case (op2)      //����sa�ж�ָ������
                        5'b00000:   begin    
                            case(op3)       //����func�ж�ָ������
                                `EXE_OR:    begin
                                    wreg_o <= `WriteEnable;         //��Ҫд�Ĵ���
                                    aluop_o <= `EXE_OR_OP;          //�߼�������
                                    alusel_o <= `EXE_RES_LOGIC;     //�߼���������
                                    reg1_read_o <= 1'b1;            //��Ҫ���˿�1
                                    reg2_read_o <= 1'b1;            //��Ҫ���˿�2
                                    wDestRegAddr_o <= inst_i[15:11];    //�õ�д�Ĵ�����ַ
                                    instValid <= `InstValid;
                                end
                                `EXE_AND:    begin
                                    wreg_o <= `WriteEnable;         //��Ҫд�Ĵ���
                                    aluop_o <= `EXE_AND_OP;          //�߼�������
                                    alusel_o <= `EXE_RES_LOGIC;     //�߼���������
                                    reg1_read_o <= 1'b1;            //��Ҫ���˿�1
                                    reg2_read_o <= 1'b1;            //��Ҫ���˿�2
                                    wDestRegAddr_o <= inst_i[15:11];    //�õ�д�Ĵ�����ַ
                                    instValid <= `InstValid;
                                end
                                `EXE_XOR:    begin
                                    wreg_o <= `WriteEnable;         //��Ҫд�Ĵ���
                                    aluop_o <= `EXE_XOR_OP;          //�߼�������
                                    alusel_o <= `EXE_RES_LOGIC;     //�߼���������
                                    reg1_read_o <= 1'b1;            //��Ҫ���˿�1
                                    reg2_read_o <= 1'b1;            //��Ҫ���˿�2
                                    wDestRegAddr_o <= inst_i[15:11];    //�õ�д�Ĵ�����ַ
                                    instValid <= `InstValid;
                                end
                                `EXE_NOR:    begin
                                    wreg_o <= `WriteEnable;         //��Ҫд�Ĵ���
                                    aluop_o <= `EXE_NOR_OP;          //�߼�������
                                    alusel_o <= `EXE_RES_LOGIC;     //�߼���������
                                    reg1_read_o <= 1'b1;            //��Ҫ���˿�1
                                    reg2_read_o <= 1'b1;            //��Ҫ���˿�2
                                    wDestRegAddr_o <= inst_i[15:11];    //�õ�д�Ĵ�����ַ
                                    instValid <= `InstValid;
                                end
                                `EXE_SLLV:    begin
                                    wreg_o <= `WriteEnable;         //��Ҫд�Ĵ���
                                    aluop_o <= `EXE_SLL_OP;          //��������
                                    alusel_o <= `EXE_RES_SHIFT;     //��λ����
                                    reg1_read_o <= 1'b1;            //��Ҫ���˿�1
                                    reg2_read_o <= 1'b1;            //��Ҫ���˿�2
                                    wDestRegAddr_o <= inst_i[15:11];    //�õ�д�Ĵ�����ַ
                                    instValid <= `InstValid;
                                end
                                `EXE_SRLV:    begin
                                    wreg_o <= `WriteEnable;         //��Ҫд�Ĵ���
                                    aluop_o <= `EXE_SRL_OP;          //�߼���������
                                    alusel_o <= `EXE_RES_SHIFT;     //��λ����
                                    reg1_read_o <= 1'b1;            //��Ҫ���˿�1
                                    reg2_read_o <= 1'b1;            //��Ҫ���˿�2
                                    wDestRegAddr_o <= inst_i[15:11];    //�õ�д�Ĵ�����ַ
                                    instValid <= `InstValid;
                                end
                                `EXE_SRAV:    begin
                                    wreg_o <= `WriteEnable;         //��Ҫд�Ĵ���
                                    aluop_o <= `EXE_SRA_OP;          //������������
                                    alusel_o <= `EXE_RES_SHIFT;     //��λ����
                                    reg1_read_o <= 1'b1;            //��Ҫ���˿�1
                                    reg2_read_o <= 1'b1;            //��Ҫ���˿�2
                                    wDestRegAddr_o <= inst_i[15:11];    //�õ�д�Ĵ�����ַ
                                    instValid <= `InstValid;
                                end
                                `EXE_ADD:    begin
                                    wreg_o <= `WriteEnable;         //��Ҫд�Ĵ���
                                    aluop_o <= `EXE_ADD_OP;          //�з��ż�����
                                    alusel_o <= `EXE_RES_ARITHMETIC;     //��������
                                    reg1_read_o <= 1'b1;            //��Ҫ���˿�1
                                    reg2_read_o <= 1'b1;            //��Ҫ���˿�2
                                    wDestRegAddr_o <= inst_i[15:11];    //�õ�д�Ĵ�����ַ
                                    instValid <= `InstValid;
                                end
                                `EXE_ADDU:    begin
                                    wreg_o <= `WriteEnable;         //��Ҫд�Ĵ���
                                    aluop_o <= `EXE_ADDU_OP;          //�޷��ż�����
                                    alusel_o <= `EXE_RES_ARITHMETIC;     //��������
                                    reg1_read_o <= 1'b1;            //��Ҫ���˿�1
                                    reg2_read_o <= 1'b1;            //��Ҫ���˿�2
                                    wDestRegAddr_o <= inst_i[15:11];    //�õ�д�Ĵ�����ַ
                                    instValid <= `InstValid;
                                end
                                `EXE_SUB:    begin
                                    wreg_o <= `WriteEnable;         //��Ҫд�Ĵ���
                                    aluop_o <= `EXE_SUB_OP;          //�з��ż�����
                                    alusel_o <= `EXE_RES_ARITHMETIC;     //��������
                                    reg1_read_o <= 1'b1;            //��Ҫ���˿�1
                                    reg2_read_o <= 1'b1;            //��Ҫ���˿�2
                                    wDestRegAddr_o <= inst_i[15:11];    //�õ�д�Ĵ�����ַ
                                    instValid <= `InstValid;
                                end
                                `EXE_SUBU:    begin
                                    wreg_o <= `WriteEnable;         //��Ҫд�Ĵ���
                                    aluop_o <= `EXE_SUBU_OP;          //�޷��ż�����
                                    alusel_o <= `EXE_RES_ARITHMETIC;     //��������
                                    reg1_read_o <= 1'b1;            //��Ҫ���˿�1
                                    reg2_read_o <= 1'b1;            //��Ҫ���˿�2
                                    wDestRegAddr_o <= inst_i[15:11];    //�õ�д�Ĵ�����ַ
                                    instValid <= `InstValid;
                                end
                                `EXE_SLT:    begin
                                    wreg_o <= `WriteEnable;         //��Ҫд�Ĵ���
                                    aluop_o <= `EXE_SLT_OP;          //�з��űȽ�����
                                    alusel_o <= `EXE_RES_ARITHMETIC;     //��������
                                    reg1_read_o <= 1'b1;            //��Ҫ���˿�1
                                    reg2_read_o <= 1'b1;            //��Ҫ���˿�2
                                    wDestRegAddr_o <= inst_i[15:11];    //�õ�д�Ĵ�����ַ
                                    instValid <= `InstValid;
                                end
                                `EXE_SLTU:    begin
                                    wreg_o <= `WriteEnable;         //��Ҫд�Ĵ���
                                    aluop_o <= `EXE_SLTU_OP;          //�޷��űȽ�����
                                    alusel_o <= `EXE_RES_ARITHMETIC;     //��������
                                    reg1_read_o <= 1'b1;            //��Ҫ���˿�1
                                    reg2_read_o <= 1'b1;            //��Ҫ���˿�2
                                    wDestRegAddr_o <= inst_i[15:11];    //�õ�д�Ĵ�����ַ
                                    instValid <= `InstValid;
                                end
                                
                                
                                default:    begin
                                end
                            endcase // case func
                        end
                        default:    begin
                        end
                   endcase  // case sa
                end // op = special
                default:    begin
                end
            endcase // case op
            
            if(inst_i[31:21] == 11'b000000_00000)   begin
                if(op3 == `EXE_SLL) begin
                    wreg_o <= `WriteEnable;         //��Ҫд�Ĵ���
                    aluop_o <= `EXE_SLL_OP;          //��������
                    alusel_o <= `EXE_RES_SHIFT;     //��λ����
                    reg1_read_o <= 1'b0;            //����Ҫ���˿�1
                    reg2_read_o <= 1'b1;            //��Ҫ���˿�2
                    imm <= { 27'b0 , inst_i[10:6] };    //ȡsa�浽����������λ��
                    wDestRegAddr_o <= inst_i[15:11];    //�õ�д�Ĵ�����ַ
                    instValid <= `InstValid;
                end else if (op3 == `EXE_SRL)   begin
                    wreg_o <= `WriteEnable;         //��Ҫд�Ĵ���
                    aluop_o <= `EXE_SRL_OP;          //�߼���������
                    alusel_o <= `EXE_RES_SHIFT;     //��λ����
                    reg1_read_o <= 1'b0;            //����Ҫ���˿�1
                    reg2_read_o <= 1'b1;            //��Ҫ���˿�2
                    imm <= { 27'b0 , inst_i[10:6] };    //ȡsa�浽����������λ��
                    wDestRegAddr_o <= inst_i[15:11];    //�õ�д�Ĵ�����ַ
                    instValid <= `InstValid;
                end else if (op3 == `EXE_SRA)   begin
                    wreg_o <= `WriteEnable;         //��Ҫд�Ĵ���
                    aluop_o <= `EXE_SRA_OP;          //������������
                    alusel_o <= `EXE_RES_SHIFT;     //
                    reg1_read_o <= 1'b0;            //����Ҫ���˿�1
                    reg2_read_o <= 1'b1;            //��Ҫ���˿�2
                    imm <= { 27'b0 , inst_i[10:6] };    //ȡsa�浽����������λ��
                    wDestRegAddr_o <= inst_i[15:11];    //�õ�д�Ĵ�����ַ
                    instValid <= `InstValid;
                end
            end 
            
        end //if
    end //always 
    
    
// ************************************ ��.ȷ��Դ������1 ************************************************************************
    always @ (*) begin 
        if(rst == `RstEnable) begin
            reg1_o <= 32'h0;
        //����ð���ж����£�ע���ж�˳����Ҫ�ж���id�������ex�Σ����ж�mem�Σ����˳�������ܵ���ȡ��������
        end else if((reg1_read_o == 1'b1) && (ex_wreg_i == 1'b1) && (ex_wDestRegAddr_i == reg1_addr_o)) begin//�������ָ���޸��˱���ָ��Ҫ���ļĴ���
            reg1_o <= ex_wdata_i;
        end else if((reg1_read_o == 1'b1) && (mem_wreg_i == 1'b1) && (mem_wDestRegAddr_i == reg1_addr_o)) begin//���������ָ���޸��˱���ָ��Ҫ���ļĴ���
            reg1_o <= mem_wdata_i;
        /////////////////////////////////////////////////////////////////////////////////////
        end else if(reg1_read_o == 1'b1) begin
            reg1_o <= reg1_data_i;
        end else if(reg1_read_o == 1'b0) begin
            reg1_o <= imm;
        end else begin
            reg1_o <= 32'h0;
        end
    end
    
// ************************************ ��.ȷ��Դ������2 ************************************************************************
    always @ (*) begin 
        if(rst == `RstEnable) begin
            reg2_o <= 32'h0;
        //����ð���ж����£�ע���ж�˳����Ҫ�ж���id�������ex�Σ����ж�mem�Σ����˳�������ܵ���ȡ��������
        end else if((reg2_read_o == 1'b1) && (ex_wreg_i == 1'b1) && (ex_wDestRegAddr_i == reg2_addr_o)) begin//�������ָ���޸��˱���ָ��Ҫ���ļĴ���
            reg2_o <= ex_wdata_i;
        end else if((reg2_read_o == 1'b1) && (mem_wreg_i == 1'b1) && (mem_wDestRegAddr_i == reg2_addr_o)) begin//���������ָ���޸��˱���ָ��Ҫ���ļĴ���
            reg2_o <= mem_wdata_i;
        /////////////////////////////////////////////////////////////////////////////////////
        end else if(reg2_read_o == 1'b1) begin
            reg2_o <= reg2_data_i;
        end else if(reg2_read_o == 1'b0) begin
            reg2_o <= imm;
        end else begin
            reg2_o <= 32'h0;
        end
    end 
    
// ************************************ ��.���ߺ�����ˮ�δ�ָ���Ƿ�Ϊ�ӳٲ�ָ�� ************************************************************************
    always @ (*) begin 
        if(rst == `RstEnable) begin
            in_delayslot_o <= 0;
        end else begin
            in_delayslot_o <= in_delayslot_i;
        end
    end
         
endmodule
