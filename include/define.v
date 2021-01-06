`define STATE_INIT 5'h0
`define STATE_FETCH 5'h1
`define STATE_FETCH_WAIT 5'h2
`define STATE_DECODE 5'h3
`define STATE_EXECUTE 5'h4
`define STATE_MEM 5'h5
`define STATE_MEM_WAIT 5'h6
`define STATE_WB 5'h7
`define STATE_NEXT_INS 5'h9

`define ALU_OP_AND 4'b0000
`define ALU_OP_OR 4'b0001
`define ALU_OP_ADD 4'b0010
`define ALU_OP_SUB_NOT 4'b0011
`define ALU_OP_NOR 4'b0100
`define ALU_OP_XOR 4'b0101
`define ALU_OP_SUB 4'b0110
`define ALU_OP_SLT 4'b0111
`define ALU_OP_SLE_S 4'b1000
`define ALU_OP_SLT_S 4'b1001
`define ALU_OP_MULT 4'b1010
`define ALU_OP_MULTU 4'b1011
`define ALU_OP_DIV 4'b1100
`define ALU_OP_DIVU 4'b1101
`define ALU_OP_SLL_IMM 4'b1110

`define ALU_SRC_A_RS 1'b0
`define ALU_SRC_A_RT 1'b1

`define ALU_SRC_B_RT 1'b0
`define ALU_SRC_B_IMM 1'b1

`define MEM_MODE_WORD 3'b000
`define MEM_MODE_HWORD 3'b001
`define MEM_MODE_BYTE 3'b010
 //以下load命令のみ
`define MEM_MODE_HWORD_SIGN 3'b101
`define MEM_MODE_BYTE_SIGN 3'b110

`define REG_WRITE_DATA_SRC_ALU 3'b001
`define REG_WRITE_DATA_SRC_PC 3'b010
`define REG_WRITE_DATA_SRC_MEM 3'b011
`define REG_WRITE_DATA_SRC_RHI 3'b100
`define REG_WRITE_DATA_SRC_RLO 3'b101
