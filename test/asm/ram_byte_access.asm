.text

start:
    addi $t0, $zero, 0x0000
    sh $t0, 252($zero)
    addi $t0, $zero, 0xffff
    sh $t0, 254($zero)
    lw $t1, 252($zero)

    addi $t0, $zero, 0xf0
    sb $t0, 252($zero)
    addi $t0, $zero, 0xf1
    sb $t0, 253($zero)
    addi $t0, $zero, 0xf2
    sb $t0, 254($zero)
    addi $t0, $zero, 0xf3
    sb $t0, 255($zero)
    lw $t1, 252($zero)

    lbu $t1, 252($zero)
    lbu $t1, 253($zero)
    lbu $t1, 254($zero)
    lbu $t1, 255($zero)
    lhu $t1, 252($zero)
end:
    nop
    j end
    nop
