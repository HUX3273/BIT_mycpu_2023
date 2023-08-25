`timescale 1ns / 1ps

//��ˮ�Ĵ���ģ�飬λ��ȡָ�Σ�instruction fetch��������Σ�instruction decode���䣬�洢pc��inst��ʵ��id��if�ε�������ˮ��
//��ˮ�Ĵ������ܣ�  1.��resetʱ���沢������Ϣ����һ��
//                 2.resetʱ�����д洢����Ϣ��λ��ֹͣ������Ϣ
module if_id(
    input   wire                clk,
    input   wire                rst,
    input   wire[`InstAddrBus]  if_pc,      //ȡֵ��ȡ����ָ��ĵ�ַ
    input   wire[`InstBus]      if_inst,    //ȡֵ��ȡ����ָ��
    
    output  reg[`InstAddrBus]   id_pc,      //����ָ��ĵ�ַ
    output  reg[`InstBus]       id_inst     //����ָ��
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
