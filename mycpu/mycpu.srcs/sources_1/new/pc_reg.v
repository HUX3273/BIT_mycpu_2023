`timescale 1ns / 1ps

module pc_reg(
    input   wire                clk,
    input   wire                rst,
    output  reg[`InstAddrBus]   pc,  //pc��ָ���ַ��ָ���ַ����Ϊ32���أ�4�ֽڣ�
                                    //pc�ᴫ�͸�ָ��ROM��ȡ��ָ�
    output  reg                 ce  //ceȫ��chip_enableоƬʹ�ܣ�������ָ��ROM�ܷ񱻷��ʡ�
    );
    
    always @ (posedge clk) begin
        if (rst == `RstEnable) begin
            ce <=  `ChipDisable;    //��λʱָ��ROMоƬ����
        end else begin 
            ce <= `ChipEnable;      
        end
    end
    
    always @ (posedge clk) begin
        if (ce ==  `ChipDisable) begin
            pc <=  32'h0000_0000;   //ָ��ROMоƬ����ʱpc��Ϊ0
        end else begin 
            pc <= pc + 32'h4;   //ÿ��MIPSָ��ǵȳ���32λ��4�ֽڣ���pc + 4
        end
    end
endmodule