
.text
addi $t0, $zero, 0x90
addi $t1, $zero, 0x33
nor $t2, $t0, $t1 #10010000 ~| 00110011 = 11111111111111111111111101001100 (32bit)
# $t2 = 0x4c