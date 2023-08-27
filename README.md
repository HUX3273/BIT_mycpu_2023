# BIT_mycpu_2023

目前是标量处理器

支持的指令：

I型：
| 指令 | 指令格式 | 示例 | 操作 | 备注 |
| ------ | ------ | ------ | ------ | ------ |
| andi | 001100 rs(5) rt(5) imm(16) | andi rt,rs,imm | rt <- rs AND (zero-extend)imm | 注意顺序，指令格式中rs在前，rt在后，但是汇编代码中前项rt在前，rs在后 |
| ori | 001101 rs(5) rt(5) imm(16) | ori rt,rs,imm | rt <- rs OR (zero-extend)imm | 注意顺序，指令格式中rs在前，rt在后，但是汇编代码中前项rt在前，rs在后 |
| xori | 001110 rs(5) rt(5) imm(16) | xori rt,rs,imm | rt <- rs XOR (zero-extend)imm | 注意顺序，指令格式中rs在前，rt在后，但是汇编代码中前项rt在前，rs在后 |
|  |  |  |  |  |
| lui | 001111 00000 rt(5) imm(16) | lui rt,imm | rt <- {imm , 16'b0} | {}是verilog的拼接运算符 |

J型：

R型：
| 指令 | 指令格式 | 示例 | 操作 | 备注 |
| ------ | ------ | ------ | ------ | ------ |
| and | 000000 rs(5) rt(5) rd(5) 00000 100100 | and rd,rs,rt | rd <- rs AND rt | 逻辑与 |
| or | 000000 rs(5) rt(5) rd(5) 00000 100101 | or rd,rs,rt | rd <- rs OR rt | 逻辑或 |
| xor | 000000 rs(5) rt(5) rd(5) 00000 100110 | xor rd,rs,rt | rd <- rs XOR rt | 逻辑异或 |
| nor | 000000 rs(5) rt(5) rd(5) 00000 100111 | nor rd,rs,rt | rd <- rs NOR rt | 逻辑或非 |
|  |  |  |  |  |
| sll | 000000 00000 rt(5) rd(5) sa(5) 000000 | sll rd,rt,sa | rd <- rt<<sa(logic) | 逻辑左移（注意rt、rd顺序）= 算数左移 |
| srl | 000000 00000 rt(5) rd(5) sa(5) 000010 | srl rd,rt,sa | rd <- rt>>sa(logic) | 逻辑右移（注意rt、rd顺序） |
| sra | 000000 00000 rt(5) rd(5) sa(5) 000011 | sra rd,rt,sa | rd <- rs>>sa(arithmetic) | 算术右移（用符号位补空位） |
| sllv | 000000 rs(5) rt(5) rd(5) 00000 000100 | sllv rd,rt,rs | rd <- rt<<rs【4:0】(logic) | 逻辑左移（注意rt、rd、rs顺序）= 算数左移 |
| srlv | 000000 rs(5) rt(5) rd(5) 00000 000110 | srlv rd,rt,rs | rd <- rt>>rs【4:0】(logic) | 逻辑右移（注意rt、rd、rs顺序） |
| srav | 000000 rs(5) rt(5) rd(5) 00000 000111 | srav rd,rt,rs | rd <- rt>>rs【4:0】(arithmetic) | 逻辑右移（注意rt、rd、rs顺序） |
|  |  |  |  |  |
| nop | 000000 00000 00000 00000 00000 000000 | nop |  | 不难发现nop指令和sll $0,$0,0 的机器码完全相同 |


心得：
1.$0寄存器不让写是因为很多指令的机器码在寄存器字段都包含00000，但是其并不指代$0寄存器，为了避免混淆而规定$0寄存器不让写。

