.text

start:
    sw $zero, 252($zero)

    addi $t0, $zero, 0xf0
    sb $t0, 252($zero)
    addi $t0, $zero, 0xf1
    sb $t0, 253($zero)
    addi $t0, $zero, 0xf2
    sb $t0, 254($zero)
    addi $t0, $zero, 0xf3
    sb $t0, 255($zero)
    
    lw $t1, 252($zero)

    addi $t0, $zero, 0x0000
    sh $t0, 252($zero)
    addi $t0, $zero, 0xffff
    sh $t0, 254($zero)
    
    lw $t1, 252($zero)

end:
    nop
    j end
    nop
