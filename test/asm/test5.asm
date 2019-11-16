.text

start:
    addi $t0, $zero, 0x33
    xori $t1, $t0, 0x3
    #addi $t1, $zero, 0x3
    #xor $t2, $t0, $t1
end:
    nop
    j end
    nop
