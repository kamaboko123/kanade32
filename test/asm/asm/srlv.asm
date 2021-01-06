
.text
addi $t0, $zero, 0x0d #1101
addi $t1, $zero, 0x02
srl $t2, $t0, $t1 #1101 >> 2 = 0011
# $t2 = 0x03
