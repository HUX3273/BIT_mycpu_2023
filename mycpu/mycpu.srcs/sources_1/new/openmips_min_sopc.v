`timescale 1ns / 1ps

module openmips_min_sopc(
    input   wire    clk,
    input   wire    rst,
    
    output wire[7:0] sel,
    output wire[7:0] seg_code
    );
    
    //����ָ��rom��cpu
    wire[`InstAddrBus]  inst_addr;
    wire[`InstBus]      inst;
    wire                rom_ce;
    
    //����cpu��seg
    wire[`RegBus]       data;
    
    always @ (*) begin 
        
    end
    
    //ʵ����cpu
    openmips openmips0(
        .clk(clk),  .rst(~rst),
        .rom_addr_o(inst_addr), .rom_ce_o(rom_ce),    //output
        .rom_data_i(inst),                           //input
        
        .data_o(data)
    );
    
    //ʵ����ָ��ROM
    inst_rom inst_rom0(
        .a(inst_addr[11:2]),              //input address
        .spo(inst)                  //output instruction
    );
    
    //ʵ����seg
    seg_cnt seg_cnt0(
        .clk(clk),  .rst(rst),
        .data_i(data),
        .sel(sel),  .seg_code(seg_code)
    );
    
    
endmodule
