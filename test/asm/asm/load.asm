.text
addi $t0, $zero, data1
lw $t1, 0($t0)
lw $t2, 4($t0)

lh $t3, 0($t0)
lh $t4, 2($t0)

lb $t5, 0($t0)
lb $t6, 1($t0)
lb $t7, 2($t0)
lb $t8, 3($t0)

lb $k0, 11($t0)
lh $k1, 8($t0)

j end

end:
 j end

data1:
.word 0x11223344
.word 0x55667788
.word 0x88998899
