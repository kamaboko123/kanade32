.text

start:
j main

a:
addi $v0, $zero, 0x20
j b
nop

b:
addi $t1, $zero, 0x01
blez $t1, c
addi $v1, $zero, 0x20
j end

c:
addi $v1, $zero, 0x10
j end
nop

main:
addi $t0, $zero, 0x8000
blez $t0, a
addi $v0, $zero, 0x10
j end


end:
nop
j end
nop
