module KANADE32(
    input reset_n,
    input clk
);

wire pc_wren;

//control fetch
wire fd_wren;
wire ram_addr_src;

//datapath ram access
wire [31:0] ram_addr;
assign ram_addr = (ram_addr_src == 0) ? (pc_data) : (mw_alu_result);

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


//control memory access
wire mw_wren;
wire mw_alu_result_zero;
wire mw_dec_mem_read;
wire mw_dec_mem_write;
wire mw_dec_branch;
wire mw_dec_jmp;

wire mw_pc_src;
assign mw_pc_src = (mw_dec_brnach & mw_alu_result_zero);

//control memory access -> write back
wire mw_dec_mem_to_reg;
wire mw_dec_reg_write;

//datapath memory access
wire [31:0] mw_next_pc;
wire [31:0] mw_branch_pc;
wire [31:0] mw_alu_result;
wire [31:0] mw_pc;

assign mw_pc = (mw_pc_src == 0) ? (mw_next_pc) : (mw_branch_pc);


CONTROL ctrl(
    .reset_n(reset_n),
    .clk(clk),
    .pc_wren(pc_wren),
    .ram_addr_src(ram_addr_src),
    .fd_wren(fd_wren),
    .de_wren(de_wren),
    .em_wren(em_wren),
    .mw_wren(mw_wren)
);

STAGE_REG_FD fd(
    .reset_n(reset_n),
    .clk(clk),
    .wren(fd_wren),
    .in_ins(ins_data),
    .in_next_pc(pc_data + 4),
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
    .in_alu_result_zero(em_alu_result_zero),
    .next_pc(mw_next_pc),
    .branch_pc(mw_branch_pc),
    .alu_result(mw_alu_result),
    .dec_mem_to_reg(mw_dec_mem_to_reg),
    .dec_reg_write(mw_dec_reg_write),
    .dec_mem_read(mw_dec_mem_read),
    .dec_mem_write(mw_dec_mem_write),
    .dec_branch(mw_dec_branch),
    .dec_jmp(mw_dec_jmp),
    .alu_result_zero(mw_alu_result_zero)
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
    .jmp_to(mw_pc),
    .pc_data(pc_data)
);


RAM ram(
    .clk(clk),
    .address(ram_addr[31:2]),
    .q(ins_data)
);

endmodule
