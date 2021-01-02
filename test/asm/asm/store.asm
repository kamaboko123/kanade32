.text
addi $t0, $zero, data1

addi $t1, $zero, 0x11
addi $t2, $zero, 0x22
addi $t3, $zero, 0x33
addi $t4, $zero, 0x44
addi $t5, $zero, 0x5566
addi $t6, $zero, 0x7788

sb $t1, 0($t0)
sb $t2, 1($t0)
sb $t3, 2($t0)
sb $t4, 3($t0)

sh $t5, 4($t0)
sh $t6, 6($t0)

lw $k0, 0($t0)
lw $k1, 4($t0)

j end

end:
 j end

data1:

