.text

main:
    addi $t0, $zero, 1
    addi $t1, $zero, 0x10
    addi $t2, $zero, 0x20
    nop
    j b

a:
    add $t3, $t0, $t1

b:
    add $t3, $t0, $t2

end:
    nop
    j end
    nop
