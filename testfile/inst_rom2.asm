.org 0x0
.set noat
.global _start
_start:
	lui	$2,0x0404	#$2=0x04040000
	ori	$2,$2,0x0404	#$2=0x04040000|0x0404=	0x04040404
	ori	$7,$0,0x7
	ori	$5,$0,0x5
	ori	$8,$0,0x8
	nop
	sll	$2,$2,8		#$2=0x40404040 sll 8=	0x04040400
	sllv	$2,$2,$7	#$2=0x04040400 s11 7=	0x02020000
	srl	$2,$2,8		#$2=0x02020000 sr1 8=	0x00020200
	srlv	$2,$2,$5	#$2=0x00020200 srl 5=	0x00001010
	nop
	nop
	sll	$2,$2,19	#$2=0×00001010 sll 19=	0x80800000
	nop
	sra	$2,$2,16	#$2=0x80800000 sra 16=	0xffff8080
	srav	$2,$2,$8	#$2 0xffff8080 sra 8= 	0xffffff80