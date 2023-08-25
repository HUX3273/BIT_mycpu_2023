    .org 0x0
    .set noat
    .set noreorder
    .set nomacro
    .global _start
_start:
	li $t1,16
	li $t2,1
loop:
	ori $t2,$t1,0
	
	j loop
    
    
