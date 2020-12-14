# Support Instructions

kanade32 supports some MIPS I instructions.

## Kanade32 Instructions

### Arithmetic

- addi rt, rs, imm
  - rt = rs + imm
- addiu rt, rs, imm
  - rt = rs + imm
- add rd, rs, rt
  - rd = rs + rt
- addu rd, rs, rt
  - rd = rs + rt
- sub rd, rs, rt
  - rd = rs - rt
- or rd, rs, rt
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

- lui
  - need to implement immediate shifter
- (Multiply)
  - need to implement multiply and divide unit
  - need to implement HI/LO registers
- bltzal
  - need to implement full instructions input for DECODER module to identify bltz and bltzal
- bge, bgez, bgezal, bgtz
  - need to enhance comparator in ALU
