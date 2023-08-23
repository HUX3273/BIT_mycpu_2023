`timescale 1ns / 1ps


module fetch_instr_tb(

    );
    
    reg clock;
    reg rst;
    wire [31:0] instr;
    
    initial begin 
        clock = 1'b0;
        forever #10 clock = ~clock;
    end
    
    initial begin 
        rst = 1'b1;
        #195 rst = 1'b0;
        #1000 $stop;
    end
    
    
    fetch_instr fetch_instr0( .clk(clock), .rst(rst),
                              .instr(instr)
    );
    
    
endmodule
