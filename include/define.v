`define STATE_INIT 5'h0
`define STATE_FETCH 5'h1
`define STATE_FETCH_WAIT 5'h2
`define STATE_DECODE 5'h3
`define STATE_EXECUTE 5'h4
`define STATE_MEM 5'h5
`define STATE_MEM_WAIT 5'h6
`define STATE_WB 5'h7
`define STATE_NEXT_INS 5'h9

`define ALU_OP_AND 3'b000
`define ALU_OP_OR 3'b001
`define ALU_OP_ADD 3'b010
`define ALU_OP_SUB_NOT 3'b011
`define ALU_OP_NOR 3'b100
`define ALU_OP_XOR 3'b101
`define ALU_OP_SUB 3'b110
`define ALU_OP_SLT 3'b111

