module KANADE32(
    input reset_n,
    input clk
);

wire pc_wren;
wire pc_rden;

//control fetch
wire fd_wren;

//datatpath fetch -> decode
wire [31:0] pc_data;
wire [31:0] pc_data_inc;
wire [31:0] ins_data;
wire [31:0] fd_ins_data;
wire [31:0] fd_next_pc;

//contorl decode
wire de_wren;
wire fd_dec_reg_dst;

//control decode -> execute
wire fd_dec_alu_src;
wire fd_dec_mem_to_reg;
wire fd_dec_reg_write;
wire fd_dec_mem_read;
wire fd_dec_mem_write;
wire fd_dec_branch;
wire fd_dec_jmp;
wire [2:0] fd_dec_alu_op;

//datapath decode -> execute
wire [31:0] reg0;
wire [31:0] reg1;
wire [31:0] em_imm;


//contorl execute
wire em_wren;
wire em_dec_alu_src;
wire [2:0] em_alu_op;

//control execute -> memory access
wire em_alu_result_zero;
wire em_dec_mem_to_reg;
wire em_dec_reg_write;
wire em_dec_mem_read;
wire em_dec_mem_write;
wire em_dec_branch;
wire em_dec_jmp;


//datapath execute
wire [31:0] em_reg0;
wire [31:0] em_reg1;
wire [31:0] em_data0;
wire [31:0] em_data1;
assign em_data0 = em_reg0;
assign em_data1 = (em_alu_src == 0) ? (em_reg1) : (em_imm);

//datapath execute -> memory access
wire [31:0] em_next_pc;
wire [31:0] em_branch_pc;
wire [31:0] em_alu_result;


CONTROL ctrl(
    .reset_n(reset_n),
    .clk(clk),
    .pc_wren(pc_wren),
    .pc_rden(pc_rden),
    .fd_wren(fd_wren),
    .de_wren(de_wren),
    .em_wren(em_wren)
);

STAGE_REG_FD fd(
    .reset_n(reset_n),
    .clk(clk),
    .wren(fd_wren),
    .in_ins(ins_data),
    .in_next_pc(pc_data_inc),
    .ins(fd_ins_data),
    .next_pc(fd_next_pc)
);

STAGE_REG_DE de(
    .reset_n(reset_n),
    .clk(clk),
    .wren(de_wren),
    .in_next_pc(fd_next_pc),
    .in_data0(reg0),
    .in_data1(reg1),
    .in_dec_alu_src(fd_dec_alu_src),
    .in_dec_mem_to_reg(fd_dec_mem_to_reg),
    .in_dec_reg_write(fd_dec_reg_write),
    .in_dec_mem_read(fd_dec_mem_read),
    .in_dec_mem_write(fd_dec_mem_write),
    .in_dec_branch(fd_dec_branch),
    .in_dec_jmp(fd_dec_jmp),
    .in_dec_alu_op(fd_dec_alu_op),
    .in_imm({ // immideate sign extend
        {16{fd_ins_data[15]}},
        fd_ins_data[15:0]
    }),
    .next_pc(em_next_pc),
    .data0(em_reg0),
    .data1(em_reg1),
    .imm(em_imm),
    .dec_alu_src(em_alu_src),
    .dec_alu_op(em_alu_op),
    .dec_mem_to_reg(em_dec_mem_to_reg),
    .dec_reg_write(em_dec_reg_write),
    .dec_mem_read(em_dec_mem_read),
    .dec_mem_write(em_dec_mem_write),
    .dec_branch(em_dec_branch),
    .dec_jmp(em_dec_jmp)
);

STAGE_REG_EM em(
    .reset_n(reset_n),
    .clk(clk),
    .wren(em_wren),
    .in_next_pc(em_next_pc),
    .in_branch_pc(em_branch_pc),
    .in_alu_result(em_alu_result),
    .in_dec_mem_to_reg(em_dec_mem_to_reg),
    .in_dec_reg_write(em_dec_reg_write),
    .in_dec_mem_read(em_dec_mem_read),
    .in_dec_mem_write(em_dec_mem_write),
    .in_dec_branch(em_dec_branch),
    .in_dec_jmp(em_dec_jmp),
    .in_alu_result_zero(em_alu_result_zero)
);


REGFILE regfile(
    .reset_n(reset_n),
    .clk(clk),
    .reg_wren(0),
    .r_reg0(fd_ins_data[25:21]),
    .r_reg1((fd_dec_reg_dst == 0) ? (fd_ins_data[20:16]) : (fd_ins_data[15:11])),
    .reg0(reg0),
    .reg1(reg1)
);

DECODER dec(
    .ins_op(fd_ins_data[31:26]),
    .func_code(fd_ins_data[5:0]),
    .alu_src(fd_dec_alu_src),
    .reg_dst(fd_dec_reg_dst),
    .mem_to_reg(fd_dec_mem_to_reg),
    .reg_write(fd_dec_reg_write),
    .mem_read(fd_dec_mem_read),
    .mem_write(fd_dec_mem_write),
    .branch(fd_dec_branch),
    .jmp(fd_dec_jmp),
    .alu_op(fd_dec_alu_op)
);

ALU alu(
    .op(em_alu_op),
    .a(em_data0),
    .b(em_data1),
    .x(em_alu_result),
    .zero(em_alu_result_zero)
);

ALU pc_alu_branch(
    .op(`ALU_OP_ADD),
    .a(em_next_pc),
    .b({em_imm[29:0], 2'b00}),
    .x(em_branch_pc)
);


PC pc(
    .reset_n(reset_n),
    .clk(clk),
    .wren(pc_wren),
    .rden(pc_rden),
    .jmp_to(pc_data_inc),
    .pc_data(pc_data)
);
assign pc_data_inc = pc_data + 4;

RAM ram(
    .clk(clk),
    .address(pc_data[31:2]),
    .q(ins_data)
);

endmodule
