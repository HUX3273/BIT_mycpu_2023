`timescale 1ns / 1ps

module inst_rom(
    input   wire                ce,
    input   wire[`InstAddrBus]  addr,
    output  reg[`InstBus]       inst
    );
    
    //����һ��������Ϊָ��rom�������СΪInstMemNum������Ԫ�ؿ��ΪInstBus��4�ֽڣ�
    reg[`InstBus]   inst_mem[0:`InstMemNum-1];
    
    //���ļ�"inst_rom.data"��ָ��rom�У������棬�ۺ���Ч
    initial $readmemh ("inst_rom.data",inst_mem);
    
    //
    always @ (*) begin
        if(ce == `ChipDisable) begin
            inst <= 32'h0;
        end else begin
            inst <= inst_mem[addr[`InstMemNumLog2 + 1:2]];  //��Ϊcpu������ָ���ַ�ǰ��ֽ�Ѱַ�ģ�����inst_mem��4�ֽ�
                               //һ��Ԫ�ص����飨��һ������Ԫ�ش�һ��������4�ֽ�ָ�������Ҫȡaddr��18~2λ��Ϊ�����±�,
                               //18�Ǹ��ݶ����inst_mem��������������ġ�
                               //��cpu�����ĵ�ַΪ0x0����Ӧָ����inst_mem�������±�Ϊ0����ʾ���ǵ�0��ָ��;
                               //��cpu�����ĵ�ַΪ0x4����Ӧָ����inst_mem�������±�Ϊ1����ʾ���ǵ�1��ָ��;
                               //��cpu�����ĵ�ַΪ0xc����Ӧָ����inst_mem�������±�Ϊ3����ʾ���ǵ�3��ָ��;
        end
    end
    
endmodule
