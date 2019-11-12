# Support Instructions
kanade32 supports some MIPS I instructions.

## Kanade32 Instructions

### Arithmetic
- addi rd, rs, rt
- sub rd, rs, rt
- add rd, rs, rt

### Jump
- j imm
    - pc = (pc[uppert:4bit] | (imm[26bit] * 4))

### branch
- beq rs, rt, offset
    - pc += (offset * 4)

### Memory Access
- lw rt, offset(rs)
- sw rt, offset(rs)


## Reference of MIPS instructions
[MIPS Reference Sheet](http://www2.engr.arizona.edu/~ece369/Resources/spim/MIPSReference.pdf)
