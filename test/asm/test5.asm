.text

start:
    addi $t0, $zero, -10
    addi $t1, $zero, -1
    slt $t2, $t0, $t1
end:
    nop
    j end
    nop
