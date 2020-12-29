.text
addi $t0, $zero, data
lw $t1, 0($t0)
lw $t2, 4($t0)

lh $t3, 0($t0)
lh $t4, 2($t0)

lb $t5, 0($t0)
lb $t6, 1($t0)
lb $t7, 2($t0)
lb $t8, 3($t0)
j end

end:
 j end

data:
.word 0x11223344
.word 0x55667788
