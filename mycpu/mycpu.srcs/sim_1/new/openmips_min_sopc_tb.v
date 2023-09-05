`timescale 1ns / 1ps

module openmips_min_sopc_tb();
    
    reg CLOCK_50;
    reg rst;
    
    initial begin
        CLOCK_50 = 1'b0;
        forever #10 CLOCK_50 = ~CLOCK_50;   //50MHz,一个周期20ns
    end
    
    //复位信号初始时有效，在195ns时无效，sopc开始运行
    //运行1000ns后暂停仿真
    initial begin
        rst = `RstEnable;
        #195 rst = `RstDisable;
        #1000 $stop;
    end
    
    //实例化sopc
    openmips_min_sopc openmips_min_sopc0(
        .clk(CLOCK_50),
        .rst(~rst)
    );
    
endmodule
