
.text
lui $t0, 0x55
addiu $t1, $zero, 0x33
div $zero, $t0, $t1 # hi : lo = 0x00000022 : 0x0001aaaa
mfhi $t2 # 0x00000022
mflo $t3 # 0x0001aaaa

end:
  j end
