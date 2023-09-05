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
    
    //连接指令rom与cpu
    wire[`InstAddrBus]  inst_addr;
    wire[`InstBus]      inst;
    wire                rom_ce;
    
    //连接cpu和seg
    wire[`RegBus]       data;
    
    always @ (*) begin 
        
    end
    
    //实例化cpu
    openmips openmips0(
        .clk(clk),  .rst(~rst),
        .rom_addr_o(inst_addr), .rom_ce_o(rom_ce),    //output
        .rom_data_i(inst),                           //input
        
        .data_o(data)
    );
    
    //实例化指令ROM
    inst_rom inst_rom0(
        .a(inst_addr[11:2]),              //input address
        .spo(inst)                  //output instruction
    );
    
    //实例化seg
    seg_cnt seg_cnt0(
        .clk(clk),  .rst(rst),
        .data_i(data),
        .sel(sel),  .seg_code(seg_code)
    );


    //实例化vga
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
