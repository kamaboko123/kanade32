
.text
lui $t0, 0x55
addiu $t1, $zero, 0x400
mult $t0, $t1 # hi : lo = 0x00000001 : 0x54000000
mfhi $t2 # 0x00000001
mflo $t3 # 0x54000000

end:
  j end