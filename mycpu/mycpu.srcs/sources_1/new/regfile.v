`timescale 1ns / 1ps
//�Ĵ�����ģ�飬����һд��������MIPSָ��ĸ�ʽ�����ģ�һ��ָ�����ͬʱ��ȡ�����Ĵ��������ͬʱдһ���Ĵ���������ģ����
//����������д�˿ڡ�
module regfile(
    input   wire    clk,
    input   wire    rst,
    
    //д�ضΣ�write port
    input   wire                we,         //дʹ��
    input   wire[`RegAddrBus]   wRegAddr,   //$0~$31
    input   wire[`RegBus]       wdata,      //Ҫд�������
    
    //����Σ�read port1
    input   wire                re1,        //��ʹ��1
    input   wire[`RegAddrBus]   rRegAddr1,  //$0~$31
    output  reg[`RegBus]        rdata1,     //Ҫ����������
    
    //����Σ�read port2
    input   wire                re2,        //��ʹ��2
    input   wire[`RegAddrBus]   rRegAddr2,  //$0~$31
    output  reg[`RegBus]        rdata2      //Ҫ����������
    );
    
    reg[`RegBus]   regs[0:`RegNum-1];   //32���Ĵ���$0~$31��ÿ���Ĵ�����32λ����

// ************************************ д�Ĵ��� ************************************
    always @ (posedge clk) begin    //д����ֻ������ʱ��������
        if (rst == `RstDisable) begin
            if((we == `WriteEnable) && (wRegAddr != 5'h0)) begin //$0�Ĵ���ֻ�ܴ�0����˲�����д�Ĵ���
                regs[wRegAddr] <= wdata;
            end
        end
    end
    
// ************************************ ���Ĵ������˿�1�� ************************************
    always @ (*) begin  //һ������Ķ�ȡ��ַ�仯������������ִ�У�����д*��Ϊ�˱�ʾ��������߼�����ʱ���߼���Ҳ���Ի���rRegAddr1
        if (rst == `RstEnable) begin
            rdata1 <= `ZeroWord;
        end else if(rRegAddr1 == 5'h0) begin
            rdata1 <= `ZeroWord;
        end else if((rRegAddr1 == wRegAddr) && (we == `WriteEnable) && (re1 == `ReadEnable)) begin  //д���
            rdata1 <= wdata;
        end else if(re1 == `ReadEnable) begin
            rdata1 <= regs[rRegAddr1];
        end else begin
            rdata1 <= `ZeroWord;
        end
    end
    
    
// ************************************ ���Ĵ������˿�2�� ************************************
    always @ (*) begin  //һ������Ķ�ȡ��ַ�仯������������ִ�У�����д*��Ϊ�˱�ʾ��������߼�����ʱ���߼���Ҳ���Ի���rRegAddr2
        if (rst == `RstEnable) begin
            rdata2 <= `ZeroWord;
        end else if(rRegAddr2 == 5'h0) begin
            rdata2 <= `ZeroWord;
        end else if((rRegAddr2 == wRegAddr) && (we == `WriteEnable) && (re2 == `ReadEnable)) begin  //д���
            rdata2 <= wdata;
        end else if(re2 == `ReadEnable) begin
            rdata2 <= regs[rRegAddr1];
        end else begin
            rdata2 <= `ZeroWord;
        end
    end
        
endmodule
