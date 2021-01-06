# Support Instructions

kanade32 supports some MIPS I instructions.

## Kanade32 Instructions

### Arithmetic

- addi[u] rt, rs, imm
  - rt = rs + imm
- add[u] rd, rs, rt
  - rd = rs + rt
- sub[u] rd, rs, rt
  - rd = rs - rt
- or rd, rs, rt
  - rd = rs | rt
- ori rd, rs, rt
  - rd = rs | rt
- and rd, rs, rt
  - rd = rs & rt
- andi rt, rs, imm
  - rt = rs & imm
- nor rd, rs, rt
  - rd = ~(rs | rt)
- slt rd, rs, rt
  - rd = rs < rt
- slti rt, rs, imm
  - rt = rs < imm
- xor rd, rs, rt
  - rd = rs ^ rt
- xor rt, rs, imm
  - rt = rs ^ imm
- lui rt, imm
  - Rt[31:16] = imm
- sll rd, rt, imm
  - rd = rt << imm
- sllv rd, rt, rs
  - rd = rt << rs
- srl rd, rt, imm
  - rd = rt << imm
- srlv rd, rt, rs
  - rd = rt << rs

### Multiply

- mult[u] rs, rt
  - hi:lo = rs \* rt
- div[u] $zero, rs, rt
  - lo = rs / rt;
  - hi = rs % rt
- mfhi rd
  - rd = hi
- mflo rd
  - rd = lo

### Jump

- j target
  - pc = (pc[uppert:4bit] | (target immediate[26bit] \* 4))
- jal target
  - ra = pc + 4
  - pc = target immediate[26bit] \* 4
- jr rs
  - pc = rs

### branch

- beq rs, rt, offset
  - if(rs == rt) pc += (offset \* 4)
- bne rs, rt, offset
  - if(rs != rt) pc += (offset \* 4)
- ble rs, rt, offset
  - if(rs <= rt) pc += (offset \* 4)
- blez rs, offset
  - if(rs <= 0) pc += (offset \* 4)
- blt rs, rt, offset
  - if(rs < rt) pc += (offset \* 4)
- bltz rs, offset
  - if(rs < 0) pc += (offset \* 4)

### Memory Access

- lw rt, offset(rs)
- lh rt, offset(rs)
- lb rt, offset(rs)
- lhu rt, offset(rs)
- lbu rt, offset(rs)
- sw rt, offset(rs)
- sh rt, offset(rs)
- sb rt, offset(rs)

## Reference of MIPS instructions

[MIPS Reference Sheet](http://www2.engr.arizona.edu/~ece369/Resources/spim/MIPSReference.pdf)

## WIP

- mthi, htlo
- bltzal
  - need to implement full instructions input for DECODER module to identify bltz and bltzal
- bge, bgez, bgezal, bgtz
  - need to enhance comparator in ALU
