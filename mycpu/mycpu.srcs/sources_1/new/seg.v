`timescale 1ns / 1ps
module seg_cnt(
    input clk,
    input rst,
    
    input  wire[`RegBus] data_i,
    output reg[7:0] sel,
    output reg[7:0] seg_code
    
    );
    //reg [31:0] data;
    
    reg [23:0]cnt;
    reg clk_100;
    reg [31:0]div_counter = 0;  
    reg [3:0]dig_1; 
    reg [3:0]dig_2;
    reg [2:0]step;
    parameter  _0 = 8'b0011_1111, _1 = 8'h06, _2 = 8'h5b, _3 = 8'h4f, _4 = 8'b0110_0110, 
                _5 = 8'b0110_1101, _6 = 8'h7d, _7 = 8'h07, _8 = 8'b0111_1111, _9 = 8'h6f,
                _10 = 8'h77, _11 = 8'b0111_1100, _12 = 8'b0101_1000, _13 = 8'b0101_1110, _14 = 8'b0111_1001, _15=8'b0111_0001;
                //  7位flag分别记为：ABCDEFG
                //      G
                //  B       F
                //      A
                //  C       E
                //      D
                //
                
    parameter  IDLE = 3'b00,
                STEP1 = 3'b01,  
                STEP2 = 3'b11,
                STEP3 = 3'b100,
                STEP4 = 3'b101;
                

    always @ ( posedge clk ) begin
        dig_2 <= data_i[31:28];
        dig_1 <= data_i[27:24];
    end
    


    always @ ( posedge clk or negedge rst )
    begin
        if (~rst)
        begin
            step <= IDLE;
            sel <= 8'b00000000;
            seg_code<= 8'hff;
            cnt <= 0;
        end
        else 
        begin
            case(step)
            IDLE:                           
                begin
                    sel<=8'b00000000; 
                    if(cnt == 500000)         
                    begin
                        step<=STEP1;
                        cnt <= 0;
                    end
                    else
                    cnt <= cnt+1;
                end        
            STEP1:
                begin
                    sel<=8'b00000001;                   
                    step<=STEP2;
                    case(dig_1)
                        4'd0:seg_code <= _0;         
                        4'd1:seg_code <= _1;
                        4'd2:seg_code <= _2;
                        4'd3:seg_code <= _3;
                        4'd4:seg_code <= _4;
                        4'd5:seg_code <= _5;
                        4'd6:seg_code <= _6;
                        4'd7:seg_code <= _7;
                        4'd8:seg_code <= _8;
                        4'd9:seg_code <= _9;
                        4'd10:seg_code <= _10;
                        4'd11:seg_code <= _11;
                        4'd12:seg_code <= _12;
                        4'd13:seg_code <= _13;
                        4'd14:seg_code <= _14;
                        4'd15:seg_code <= _15;
                    endcase
                end
            STEP2:
                begin
                    if(cnt == 100000)
                    begin
                        step<=STEP3;
                        cnt <= 0;
                    end
                    else
                    cnt <= cnt+1;
                end
            STEP3:
                begin
                    sel<=8'b00000010;                
                    step<=STEP4;
                    case(dig_2)
                        4'd0:seg_code <= _0;        
                        4'd1:seg_code <= _1;
                        4'd2:seg_code <= _2;
                        4'd3:seg_code <= _3;
                        4'd4:seg_code <= _4;
                        4'd5:seg_code <= _5;
                        4'd6:seg_code <= _6;
                        4'd7:seg_code <= _7;
                        4'd8:seg_code <= _8;
                        4'd9:seg_code <= _9;
                        4'd10:seg_code <= _10;
                        4'd11:seg_code <= _11;
                        4'd12:seg_code <= _12;
                        4'd13:seg_code <= _13;
                        4'd14:seg_code <= _14;
                        4'd15:seg_code <= _15;
                        endcase
                end
            STEP4:
                begin
                    if(cnt == 100000)           
                    begin
                        step<=IDLE;
                        cnt <= 0;
                    end
                    else
                        cnt <= cnt+1;
                    end 
                    
            endcase
        end 
       
    end    
endmodule
