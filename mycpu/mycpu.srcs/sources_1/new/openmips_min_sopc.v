`timescale 1ns / 1ps

module openmips_min_sopc(
    input   wire    clk,
    input   wire    rst
    );
    
    //连接指令rom与cpu
    wire[`InstAddrBus]  inst_addr;
    wire[`InstBus]      inst;
    wire                rom_ce;
    

    //实例化cpu
    openmips openmips0(
        .clk(clk),  .rst(rst),
        .rom_addr_o(inst_addr), .rom_ce_o(rom_ce),    //output
        .rom_data_i(inst)                           //input
    );
    
    //实例化指令ROM
    inst_rom inst_rom0(
        .a(inst_addr),              //input address
        .spo(inst)                  //output instruction
    );
    
    
endmodule
