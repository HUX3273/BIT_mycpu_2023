.org 0x0
.global _start
.set noat
_start:
ori $1,$0,0x1100	# $1 = $0 | 0x1100 = 0x1100
ori $1,$1,0x0020	# $1 = $1 | 0x0020 = 0×1120
ori $1,$1,0x4400	# $1 = $1 | 0x4400 = 0×5520
ori $1,$1,0x0044	# $1 = $1 | 0x0044 = 0x5564