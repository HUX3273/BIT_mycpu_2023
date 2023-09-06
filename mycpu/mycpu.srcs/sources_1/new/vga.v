`timescale 1ns / 1ps


module vga (
        input           clk,
        input           rst,
        input [3:0]     num,
        
        output          hs,
        output          vs,
        output [3:0]    r,
        output [3:0]    g,
        output [3:0]    b
        
    );
    
    
    wire clk_vga;
    
    clk_wiz_0 clk_wiz_0 (
        .clk_in1(clk),
        .reset(~rst),
        .clk_out1(clk_vga)
    );
    
    reg [10:0]  h_cur;
    reg [10:0]  v_cur;
    
    always @ (posedge clk_vga) begin
        if (!rst) begin
            h_cur <= 11'b0;
            v_cur <= 11'b0;
        end
        else begin
            if (h_cur == `H_TOTAL - 1) begin
                h_cur <= 11'b0;
                if (v_cur == `V_TOTAL - 1) begin
                    v_cur <= 11'b0;
                end
                else begin
                    v_cur <= v_cur + 1;
                end
            end
            else begin
                h_cur <= h_cur + 1;
                v_cur <= v_cur;
            end
        end
    end
        
        
    reg reg_hs;
    reg reg_vs;
    
    always @ (posedge clk_vga) begin
        if (h_cur < `H_SYNC_PULSE) begin
            reg_hs <= 1'b0;
        end
        else begin
            reg_hs <= 1'b1;
        end  
    end  
    
    always @ (posedge clk_vga) begin
        if (v_cur < `V_SYNC_PULSE) begin
            reg_vs <= 1'b0;
        end
        else begin
            reg_vs <= 1'b1;
        end  
    end
          
    assign hs = reg_hs;
    assign vs = reg_vs;
    
    
    reg [3:0]   reg_r;
    reg [3:0]   reg_g;
    reg [3:0]   reg_b;
    
    wire [6:0]  light;
    
    assign light = (num == 0) ? 7'b1110111 :
                   (num == 1) ? 7'b0100100 :
                   (num == 2) ? 7'b1011101 :
                   (num == 3) ? 7'b1101101 :
                   (num == 4) ? 7'b0101110 :
                   (num == 5) ? 7'b1101011 :
                   (num == 6) ? 7'b1111011 :
                   (num == 7) ? 7'b0100101 :
                   (num == 8) ? 7'b1111111 :
                   (num == 9) ? 7'b1101111 :
                   (num == 10) ? 7'b0111111 :
                   (num == 11) ? 7'b1111010 :
                   (num == 12) ? 7'b1010011 :
                   (num == 13) ? 7'b1111100 :
                   (num == 14) ? 7'b1011011 :
                   (num == 15) ? 7'b0011011 :
                   7'b0000000;
              
    always @ (posedge clk_vga) begin
        if (h_cur >  437 && h_cur <  562 && v_cur >  31 && v_cur <  94 ) begin
            if (light[0]) begin
                reg_r <= `RED_R;
                reg_g <= `RED_G;
                reg_b <= `RED_B;
            end
            else begin
                reg_r <= `WHITE_R;
                reg_g <= `WHITE_G;
                reg_b <= `WHITE_B;
            end
        end
        else if (h_cur >  375 && h_cur <  437 && v_cur >  94 && v_cur <  219 ) begin
            if (light[1]) begin
                reg_r <= `RED_R;
                reg_g <= `RED_G;
                reg_b <= `RED_B;
            end
            else begin
                reg_r <= `WHITE_R;
                reg_g <= `WHITE_G;
                reg_b <= `WHITE_B;
            end
        end
        else if (h_cur >  562 && h_cur <  625 && v_cur >  94 && v_cur <  219 ) begin
            if (light[2]) begin
                reg_r <= `RED_R;
                reg_g <= `RED_G;
                reg_b <= `RED_B;
            end
            else begin
                reg_r <= `WHITE_R;
                reg_g <= `WHITE_G;
                reg_b <= `WHITE_B;
            end
        end
        else if (h_cur >  437 && h_cur <  562 && v_cur >  219 && v_cur <  281 ) begin
            if (light[3]) begin
                reg_r <= `RED_R;
                reg_g <= `RED_G;
                reg_b <= `RED_B;
            end
            else begin
                reg_r <= `WHITE_R;
                reg_g <= `WHITE_G;
                reg_b <= `WHITE_B;
            end
        end
        else if (h_cur >  375 && h_cur <  437 && v_cur >  281 && v_cur <  406 ) begin
            if (light[4]) begin
                reg_r <= `RED_R;
                reg_g <= `RED_G;
                reg_b <= `RED_B;
            end
            else begin
                reg_r <= `WHITE_R;
                reg_g <= `WHITE_G;
                reg_b <= `WHITE_B;
            end
        end
        else if (h_cur > 562 && h_cur < 625 && v_cur > 281 && v_cur < 406 ) begin
            if (light[5]) begin
                reg_r <= `RED_R;
                reg_g <= `RED_G;
                reg_b <= `RED_B;
            end
            else begin
                reg_r <= `WHITE_R;
                reg_g <= `WHITE_G;
                reg_b <= `WHITE_B;
            end
        end
        else if (h_cur > 437 && h_cur < 562 && v_cur > 406 && v_cur < 469 ) begin
            if (light[6]) begin
                reg_r <= `RED_R;
                reg_g <= `RED_G;
                reg_b <= `RED_B;
            end
            else begin
                reg_r <= `WHITE_R;
                reg_g <= `WHITE_G;
                reg_b <= `WHITE_B;
            end
        end
        ///////////////////////////////////////////////////////////////////////////
        else if (h_cur >  375 && h_cur <  437 && v_cur > 31 && v_cur < 94 ) begin
            if (light[0] || light[1]) begin
                reg_r <= `RED_R;
                reg_g <= `RED_G;
                reg_b <= `RED_B;
            end
            else begin
                reg_r <= `WHITE_R;
                reg_g <= `WHITE_G;
                reg_b <= `WHITE_B;
            end
        end
        else if (h_cur > 562 && h_cur < 625 && v_cur > 31 && v_cur < 94 ) begin
            if (light[0] || light[2]) begin
                reg_r <= `RED_R;
                reg_g <= `RED_G;
                reg_b <= `RED_B;
            end
            else begin
                reg_r <= `WHITE_R;
                reg_g <= `WHITE_G;
                reg_b <= `WHITE_B;
            end
        end
        else if ( h_cur > 375 && h_cur < 437 && v_cur > 219 && v_cur < 281 ) begin
            if (light[1] || light[3] || light[4]) begin
                reg_r <= `RED_R;
                reg_g <= `RED_G;
                reg_b <= `RED_B;
            end
            else begin
                reg_r <= `WHITE_R;
                reg_g <= `WHITE_G;
                reg_b <= `WHITE_B;
            end
        end
        else if ( h_cur > 562 && h_cur < 625 && v_cur > 219 && v_cur < 281 ) begin
            if (light[2] || light[3] || light[5]) begin
                reg_r <= `RED_R;
                reg_g <= `RED_G;
                reg_b <= `RED_B;
            end
            else begin
                reg_r <= `WHITE_R;
                reg_g <= `WHITE_G;
                reg_b <= `WHITE_B;
            end
        end
        else if (h_cur > 375 && h_cur < 437 && v_cur > 406 && v_cur < 469 ) begin
            if (light[4] || light[6]) begin
                reg_r <= `RED_R;
                reg_g <= `RED_G;
                reg_b <= `RED_B;
            end
            else begin
                reg_r <= `WHITE_R;
                reg_g <= `WHITE_G;
                reg_b <= `WHITE_B;
            end
        end
        else if (h_cur > 562 && h_cur < 625 && v_cur > 406 && v_cur < 469 ) begin
            if (light[5] || light[6]) begin
                reg_r <= `RED_R;
                reg_g <= `RED_G;
                reg_b <= `RED_B;
            end
            else begin
                reg_r <= `WHITE_R;
                reg_g <= `WHITE_G;
                reg_b <= `WHITE_B;
            end
        end
        else begin
            reg_r <= `WHITE_R;
            reg_g <= `WHITE_G;
            reg_b <= `WHITE_B;
        end
    end
    
    assign r = reg_r;
    assign g = reg_g;
    assign b = reg_b;

endmodule
