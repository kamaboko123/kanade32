
.text
addi $t0, $zero, 0x90
addi $t1, $zero, 0x33
and $t2, $t0, $t1 #10010000 & 00110011 = 00010000
# $t2 = 0x10
