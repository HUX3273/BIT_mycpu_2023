    .org 0x0
    .set noat
    .set noreorder
    .set nomacro
    .global _start
_start:
    ori	$1,$0,1		#$1 = 1
    ori	$2,$0,0		#$2 = 0
    ori	$3,$0,0		#$3 = 0
    ori	$4,$0,0		#$4 = 0
    ori	$5,$0,0		#$5 = 0
loop:
    add $2, $2, $1
    add $3, $3, $2
    add $4, $4, $3
    add $5, $5, $4
    j loop
    sub $1, $1, $1