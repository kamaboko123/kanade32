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
- slti rt, rs, imm
    - rt = rs < imm

### Jump
- j target
    - pc = (pc[uppert:4bit] | (target immediate[26bit] * 4))
- jal target
    - ra = pc + 4
    - pc = target immediate[26bit] * 4
- jr rs
    - pc = rs

### branch
- beq rs, rt, offset
    - if(rs == rt) pc += (offset * 4)
- bne rs, rt, offset
    - if(rs != rt) pc += (offset * 4)

### Memory Access
- lw rt, offset(rs)
- sw rt, offset(rs)


## Reference of MIPS instructions
[MIPS Reference Sheet](http://www2.engr.arizona.edu/~ece369/Resources/spim/MIPSReference.pdf)
