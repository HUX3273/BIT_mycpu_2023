`timescale 1ns / 1ps


module fetch_instr(
    input wire clk,
    input wire rst,
    output wire [31:0] instr
    );
    
    wire [5:0] instr_address;
    wire instr_rom_enable;
    
    pc pc0( .clk(clk), .rst(rst),  //input
            .instr_address(instr_address), .instr_rom_enable(instr_rom_enable) //output
    );
    
    instr_rom instr_rom0( .instr_address(instr_address), .instr_rom_enable(instr_rom_enable), //input
                .instr(instr)
    );
    
    
endmodule
