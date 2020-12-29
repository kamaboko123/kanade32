
.text
addi $t0, $zero, 0x90
addi $t1, $zero, 0x33
or $t2, $t0, $t1 #10010000 | 00110011 = 10110011
# $t2 = 0xb3
