`timescale 1ns / 1ps


module instr_rom(
    input wire [5:0] instr_address,
    input wire instr_rom_enable,
    output reg [31:0] instr
    );
    
    reg [31:0] instr_rom [63:0];
    
    initial $readmemh ("rom.data",instr_rom);
    /*initial begin    
        instr_rom[0] = 32'h0000_0000;
        instr_rom[1] = 32'h0101_0101;
        instr_rom[2] = 32'h0202_0203;
        instr_rom[3] = 32'h0303_0303;
    end
    */
    
    
    always @ (*) begin 
        if (instr_rom_enable == 0) begin
            instr <= 32'h0;
        end else begin
            instr <= instr_rom[instr_address];
        end
    end
    
    
endmodule
