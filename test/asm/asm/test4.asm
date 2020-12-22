.text

start:
    addi $t1, $zero, 1
    addi $ra, $zero, 0xff
    add $ra, $ra, $t1
end:
    nop
    j end
    nop
