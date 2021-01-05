.text

start:
addi $t0, $zero, b
jr $t0
j a

a:
addi $v0, $zero, 0x10
addi $v1, $zero, 0x10
j end
nop

b:
addi $v0, $zero, 0x20
j end
nop

end:
nop
j end
nop
