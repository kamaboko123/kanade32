
.text
addi $t0, $zero, 0
lui $t0, 0xFFFF #1111 1111 1111 1111 0000 0000 0000 0000
addi $t1, $zero, 0x06
srav $t2, $t0, $t1 #0xFFFF0000 >>> 6 = 1111 1111 1111 11111 11111 1100 0000 0000
# $t2 = 0xFFFFFC00
