.text

start:
j b
addi $t0, $zero, 0x01

a:
addi $v0, $zero, 0x10
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
