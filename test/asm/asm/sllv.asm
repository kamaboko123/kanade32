
.text
addi $t0, $zero, 0x0d #1101
addi $t1, $zero, 0x02
sllv $t2, $t0, $t1 #1101 << 2 = 00110100
# $t2 = 0x34
