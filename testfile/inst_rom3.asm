.org 0x0
.set noat
.global _start
_start:
ori $1,$0,0x8000	#$1=0x00008000
sll $1,$1,16		#$1=0x80000000
ori $1,$1,0x0010	#$1=0×80000010	给$1赋初值
ori $2,$0,0x8000	#$2=0x00008000
sll $2,$2,16		#$2=0x80000000
ori $2,$2,0x0001	#$2=0x80000001	给$2赋初值
ori $3,$0,0x0000	#$3=0x00000000
addu $3,$2,$1		#$3=0x00000011	$1加$2，无符号加法
ori $3,$0,0x0000	#$3=0x00000000
add $3,$2,$1		#$2加$1，有符号加法，结果溢出，所以$3应保持不变,$3保持为0x00000000
sub $3,$1,$3		#$3=0x80000010	$1减去$3，有符号减法
subu $3,$3,$2		#$3=0xF		$3减去$2，无符号减法

or $1,$0,0xffff		#$1=0x0000ffff
sll $1,$1,16		#$1=0xffff0000	给$1赋初值
slt $2,$1,$0		#$2=1	比较$1与0x0,有符号比较
sltu $2,$1,$0		#$2=0	比较$1与0x0,无符号比较