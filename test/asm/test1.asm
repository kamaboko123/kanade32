
.text
addi $t0, $zero, 32
addi $t0, $t0, 32
add $t1, $zero, 32
sub $t0, $t0, $t1

sw $t0, 64($zero)
lw $t2, 64($zero)


