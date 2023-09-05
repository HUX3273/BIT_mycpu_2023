`timescale 1ns / 1ps

module openmips_min_sopc(
    input   wire    clk,
    input   wire    rst,
    
    //seg
    output wire[7:0] sel,
    output wire[7:0] seg_code,
    
    //vga
    output hs,
    output vs,
    output[3:0] r,
    output[3:0] g,
    output[3:0] b
    
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


    //ʵ����vga
    vga vga0(
        .clk(clk),
        .rst(~rst),
        .num(data[27:24]),
        
        .hs(hs),
        .vs(vs),
        .r(r),
        .g(g),
        .b(b)
    );


endmodule
