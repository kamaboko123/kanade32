# Kanade32

Self made 32 bit CPU.  
The CPU instruction set is a subset of MIPS CPU.

## Goal

- Make MIPS core which can run MIPS binary compiled by GCC.
- Multi-cycle (not include pipeline)

## Tets

### simulate single mem file

```
MEM_FILE='test/c/memdata/fibonacci.mem' make
```

## Others

Single-cycle MIPS subset implementation is here.  
[kamaboko123/verilog-training/mips](https://github.com/kamaboko123/verilog-training/tree/develop/mips)
