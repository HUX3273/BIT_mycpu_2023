`timescale 1ns / 1ps

module pc(
    input wire clk,
    input wire rst,
    output reg instr_rom_enable,
    output reg [5:0] instr_address
    );
    
    always @ (posedge clk) begin
        if(rst == 1'b1) begin
            instr_rom_enable <= 1'b0;
        end else begin
            instr_rom_enable <= 1'b1;
        end
    end
    
    
    always @ (posedge clk) begin
        if(instr_rom_enable == 1'b0) begin
            instr_address <= 6'b000_000;
        end else begin 
            instr_address <= instr_address + 1'b1;
        end
    end
    
    
endmodule
