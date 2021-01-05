
.text
start:
  addiu $t0, $zero, 0x10
  addiu $t1, $zero, 0x10
  jal sum_t0_t1
  addu $v1, $zero, $v0
  j end

sum_t0_t1:
  addu $v0, $t0, $t1
  jr $ra

sum_t0_0x20:
  addiu $v0, $t0, 0x20
  jr $ra

end:
  j end
