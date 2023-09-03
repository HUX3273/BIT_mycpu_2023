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
    parameter  _0 = 8'h3f, _1 = 8'h06, _2 = 8'h5b, _3 = 8'h4f, _4 = 8'h66, 
                _5 = 8'h6d, _6 = 8'h7d, _7 = 8'h07, _8 = 8'h7f, _9 = 8'h6f;
                
    parameter  IDLE = 3'b00,
                STEP1 = 3'b01,  
                STEP2 = 3'b11,
                STEP3 = 3'b100,
                STEP4 = 3'b101;
/*        
    always @ ( data_i ) begin
        data <= data_i;
    end
*/

    always @ ( posedge clk ) begin
        dig_1 <= data_i[31:28];
        dig_2 <= 0;
    end
    
/*
    always @ ( posedge clk or negedge rst )      //1s 计数  得到个位计数和十位计数
    begin
        if (~rst)
        begin
            div_counter <= 0;
            dig_1 <= 0;
            dig_2 <= 0;           
        end
        else
        begin
            if(dig_2 == 10)  
            begin
                dig_2 <= 0;  
            end
            else if(dig_1 == 10)
            begin 
                dig_1 <= 0; 
                dig_2 <= dig_2 + 1; 
            end
            else if(div_counter >= 80000000)           
            begin
                dig_1 <= dig_1+1;
                div_counter <= 0;
            end
            else  div_counter<=div_counter+1; 
        end 
    end   
*/


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
