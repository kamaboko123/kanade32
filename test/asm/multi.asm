
.text
addi $t0, $zero, 15
addi $t1, $zero, 2
mult $t0, $t1
nop
nop
#div $zero, $t0, $t1
mflo $v0
nop
nop
addi $t0, $zero, 0xff
addi $t1, $zero, 256
mult $t0, $t1
mflo $t0
mult $t0, $t1
mflo $t0
mult $t0, $t1
mflo $t0
mult $t0, $t1
mfhi $v0
