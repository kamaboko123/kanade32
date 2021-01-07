.text

start:
j main

a:
addi $v0, $zero, 0x20
j b
nop

b:
addi $t2, $zero, 0xf1
bgt	$t0, $t2, c #$t0 = 0xf1
addi $v1, $zero, 0x20
j end

c:
addi $v1, $zero, 0x10
j end
nop

main:
addi $t0, $zero, 0xf1
addi $t1, $zero, 0xf0
bgt	$t0, $t1, a
addi $v0, $zero, 0x10
j end


end:
nop
j end
nop
