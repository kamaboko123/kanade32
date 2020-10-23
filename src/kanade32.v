module KANADE32(
    input reset_n,
    input clk,
    input clk_video
);

wire pc_wren;

//control fetch
wire fd_wren;
wire ram_addr_src;

//datapath ram access
reg [31:0] ram_addr;

//フェッチならプログラムカウンタを参照する
always @* begin
    if(ram_addr_src == 0) begin
        ram_addr = pc_data;
    end
    else begin
        if(mw_dec_mem_read | mw_dec_mem_write) begin
            ram_addr = mw_alu_result;
        end
    end
end

//datatpath fetch -> decode
wire [31:0] pc_data;
wire [31:0] pc_data_inc;
wire [31:0] ram_data;
wire [31:0] fd_ins_data;
wire [31:0] fd_next_pc;

reg [4:0] fd_dst_reg;
always @* begin
    if(fd_dec_pc_to_ra == 1) begin
        fd_dst_reg = 5'd31; //ra register(for jal instrution)
    end
    else begin
        fd_dst_reg = (fd_dec_reg_dst == 0) ? (fd_ins_data[20:16]) : (fd_ins_data[15:11]);
    end
end

//contorl decode
wire de_wren;
wire fd_dec_reg_dst;

//control decode -> execute
wire fd_dec_alu_src;
wire fd_dec_mem_to_reg;
wire fd_dec_reg_write;
wire fd_dec_mem_read;
wire fd_dec_mem_write;
wire [3:0] fd_dec_mem_mask;
wire fd_dec_branch;
wire fd_dec_jmp;
wire fd_dec_pc_to_ra;
wire fd_dec_alu_result_to_pc;
wire [3:0] fd_dec_alu_op;

//datapath decode -> execute
wire [31:0] reg0;
wire [31:0] reg1;
wire [31:0] de_ins_data;


//contorl execute
wire em_wren;
wire em_dec_alu_src;
wire [3:0] em_alu_op;

//control execute -> memory access
wire em_alu_result_zero;
wire em_dec_mem_to_reg;
wire em_dec_reg_write;
wire em_dec_mem_read;
wire em_dec_mem_write;
wire [3:0] em_dec_mem_mask;
wire em_dec_branch;
wire em_dec_jmp;
wire em_dec_alu_result_to_pc;
wire em_dec_pc_to_ra;


//datapath execute
wire [31:0] em_reg0;
wire [31:0] em_reg1;
wire [31:0] em_data0;
wire [31:0] em_data1;
wire [31:0] em_imm;
assign em_imm =  { {16{em_ins_data[15]}}, em_ins_data[15:0]}; //immediate sign extend
assign em_data0 = em_reg0;
assign em_data1 = (em_alu_src == 0) ? (em_reg1) : (em_imm);
wire [4:0] em_dst_reg;

//datapath execute -> memory access
wire [31:0] em_next_pc;
wire [31:0] em_branch_pc;
wire [31:0] em_alu_result;
wire [31:0] em_ins_data;


//control memory access
wire mw_wren;
wire mw_alu_result_zero;
wire mw_dec_mem_read;
wire mw_dec_mem_write;
wire [3:0] mw_dec_mem_mask;
wire mw_dec_branch;
wire mw_dec_jmp;
wire mw_dec_alu_result_to_pc;
wire mw_mem_wren;
wire mw_dec_pc_to_ra;

wire mem_wren;
assign mem_wren = (mw_mem_wren & mw_dec_mem_write);

wire mw_pc_src;
assign mw_pc_src = (mw_dec_branch & mw_alu_result_zero);

//control memory access -> write back
wire mw_dec_mem_to_reg;
wire mw_dec_reg_write;

//datapath memory access
wire [31:0] _mw_next_pc;
wire [31:0] mw_branch_pc;
wire [31:0] mw_alu_result;
wire [31:0] mw_mem_write_data;
wire [31:0] mw_ins_data;
reg [31:0] mw_next_pc;
always @* begin
    if(mw_dec_jmp == 1) begin
        //jmp instructions flg
        if(mw_dec_alu_result_to_pc) begin
            //transfar alu_result to pc
            //jr rs
            mw_next_pc = mw_alu_result;
        end
        else begin
            if(mw_dec_pc_to_ra == 1'b1) begin
                //jal, dst_reg == 31
                mw_next_pc = {4'b0, mw_ins_data[25:0], 2'b0};
            end
            else begin
                //jump next_pc(upper 4bit) | immediate(lower 26bit << 2)
                mw_next_pc = ({mw_next_pc[31:28], 28'b0} | {4'b0, mw_ins_data[25:0], 2'b0});
            end
        end
    end
    else begin
        mw_next_pc = (mw_pc_src == 0) ? (_mw_next_pc) : (mw_branch_pc);
    end
end
wire [31:0] mw_return_pc;
assign mw_return_pc = _mw_next_pc;

wire [4:0] mw_dst_reg;


//control write back
wire reg_wren; //control
wire w_dec_reg_write; //stage register mw
wire w_dec_mem_to_reg; //stage register mw

wire _reg_wren;
assign _reg_wren = (reg_wren & w_dec_reg_write);

//datapath write back
wire [31:0] w_alu_result;
wire [31:0] w_mem_data;
wire [4:0] w_dst_reg;
wire w_dec_pc_to_ra;

wire [31:0] w_return_pc;
reg [31:0] w_reg_write_data;
always @* begin
    if(w_dec_pc_to_ra) begin
        w_reg_write_data = w_return_pc;
    end
    else begin
        w_reg_write_data = (w_dec_mem_to_reg == 0) ? (w_alu_result) : (w_mem_data);
    end
end

wire stage_refresh_n;

CONTROL ctrl(
    .reset_n(reset_n),
    .clk(clk),
    .pc_wren(pc_wren),
    .ram_addr_src(ram_addr_src),
    .fd_wren(fd_wren),
    .de_wren(de_wren),
    .em_wren(em_wren),
    .mw_wren(mw_wren),
    .mw_mem_wren(mw_mem_wren),
    .reg_wren(reg_wren),
    .refresh_n(stage_refresh_n)
);

STAGE_REG_FD fd(
    .reset_n(stage_refresh_n),
    .clk(clk),
    .wren(fd_wren),
    .in_ins(ram_data),
    .in_next_pc(pc_data + 4),
    .ins(fd_ins_data),
    .next_pc(fd_next_pc)
);

STAGE_REG_DE de(
    .reset_n(stage_refresh_n),
    .clk(clk),
    .wren(de_wren),
    .in_next_pc(fd_next_pc),
    .in_data0(reg0),
    .in_data1(reg1),
    .in_dst_reg(fd_dst_reg),
    .in_dec_alu_src(fd_dec_alu_src),
    .in_dec_mem_to_reg(fd_dec_mem_to_reg),
    .in_dec_reg_write(fd_dec_reg_write),
    .in_dec_mem_read(fd_dec_mem_read),
    .in_dec_mem_write(fd_dec_mem_write),
    .in_dec_mem_mask(fd_dec_mem_mask),
    .in_dec_branch(fd_dec_branch),
    .in_dec_jmp(fd_dec_jmp),
    .in_dec_alu_op(fd_dec_alu_op),
    .in_ins(fd_ins_data),
    .in_dec_alu_result_to_pc(fd_dec_alu_result_to_pc),
    .in_dec_pc_to_ra(fd_dec_pc_to_ra),
    .next_pc(em_next_pc),
    .data0(em_reg0),
    .data1(em_reg1),
    .dst_reg(em_dst_reg),
    .ins(em_ins_data),
    .dec_alu_src(em_alu_src),
    .dec_alu_op(em_alu_op),
    .dec_mem_to_reg(em_dec_mem_to_reg),
    .dec_reg_write(em_dec_reg_write),
    .dec_mem_read(em_dec_mem_read),
    .dec_mem_write(em_dec_mem_write),
    .dec_mem_mask(em_dec_mem_mask),
    .dec_branch(em_dec_branch),
    .dec_jmp(em_dec_jmp),
    .dec_alu_result_to_pc(em_dec_alu_result_to_pc),
    .dec_pc_to_ra(em_dec_pc_to_ra)
);

STAGE_REG_EM em(
    .reset_n(stage_refresh_n),
    .clk(clk),
    .wren(em_wren),
    .in_next_pc(em_next_pc),
    .in_branch_pc(em_branch_pc),
    .in_alu_result(em_alu_result),
    .in_mem_write_data(em_reg1),
    .in_dst_reg(em_dst_reg),
    .in_ins(em_ins_data),
    .in_dec_mem_to_reg(em_dec_mem_to_reg),
    .in_dec_reg_write(em_dec_reg_write),
    .in_dec_mem_read(em_dec_mem_read),
    .in_dec_mem_write(em_dec_mem_write),
    .in_dec_mem_mask(em_dec_mem_mask),
    .in_dec_branch(em_dec_branch),
    .in_dec_jmp(em_dec_jmp),
    .in_alu_result_zero(em_alu_result_zero),
    .in_dec_alu_result_to_pc(em_dec_alu_result_to_pc),
    .in_dec_pc_to_ra(em_dec_pc_to_ra),
    .next_pc(_mw_next_pc),
    .branch_pc(mw_branch_pc),
    .alu_result(mw_alu_result),
    .mem_write_data(mw_mem_write_data),
    .dst_reg(mw_dst_reg),
    .ins(mw_ins_data),
    .dec_mem_to_reg(mw_dec_mem_to_reg),
    .dec_reg_write(mw_dec_reg_write),
    .dec_mem_read(mw_dec_mem_read),
    .dec_mem_write(mw_dec_mem_write),
    .dec_mem_mask(mw_dec_mem_mask),
    .dec_branch(mw_dec_branch),
    .dec_jmp(mw_dec_jmp),
    .alu_result_zero(mw_alu_result_zero),
    .dec_alu_result_to_pc(mw_dec_alu_result_to_pc),
    .dec_pc_to_ra(mw_dec_pc_to_ra)
);

STAGE_REG_MW mw(
    .reset_n(stage_refresh_n),
    .clk(clk),
    .wren(mw_wren),
    .in_mem_data(ram_data),
    .in_alu_result(mw_alu_result),
    .in_dst_reg(mw_dst_reg),
    .in_return_pc(mw_return_pc),
    .in_dec_mem_to_reg(mw_dec_mem_to_reg),
    .in_dec_reg_write(mw_dec_reg_write),
    .in_dec_pc_to_ra(mw_dec_pc_to_ra),
    .mem_data(w_mem_data),
    .alu_result(w_alu_result),
    .dst_reg(w_dst_reg),
    .dec_mem_to_reg(w_dec_mem_to_reg),
    .dec_reg_write(w_dec_reg_write),
    .return_pc(w_return_pc),
    .dec_pc_to_ra(w_dec_pc_to_ra)
);


REGFILE regfile(
    .reset_n(reset_n),
    .clk(clk),
    .reg_wren(_reg_wren),
    .r_reg0(fd_ins_data[25:21]),
    .r_reg1(fd_ins_data[20:16]),
    .w_reg0(w_dst_reg), //write selector
    .w_data(w_reg_write_data), //write data
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
    .mem_mask(fd_dec_mem_mask),
    .branch(fd_dec_branch),
    .jmp(fd_dec_jmp),
    .alu_op(fd_dec_alu_op),
    .pc_to_ra(fd_dec_pc_to_ra),
    .alu_result_to_pc(fd_dec_alu_result_to_pc)
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
    .jmp_to(mw_next_pc),
    .pc_data(pc_data)
);

wire sync_h;
wire sync_v;
wire [31:0] vram_data;
reg [3:0] vram_data_px;
wire [9:0] v_x;
wire [9:0] v_y;
wire [19:0] vram_addr;
wire [29:0] vram_addr_mem;
assign vram_addr = (v_y[8:0] * 320) + (v_x[8:0]);
assign vram_addr_mem = ({14'h1, vram_addr[17:2]});

always @(vram_addr[1:0]) begin
    case(vram_addr[1:0])
        0: vram_data_px = vram_data[3:0];
        1: vram_data_px = vram_data[7:4];
        2: vram_data_px = vram_data[11:8];
        3: vram_data_px = vram_data[15:12];
    endcase
end

VGA vga(
    .reset_n(reset_n),
    .clk(clk_video),
    .col(vram_data_px),
    .sync_h(sync_h),
    .sync_v(sync_v),
    .v_x(v_x),
    .v_y(v_y)
);

reg [31:0] ram_write_data;
reg [3:0] ram_byteen;
always @* begin
    if(mw_dec_mem_mask == 4'b0001) begin //byte
        ram_write_data = mw_mem_write_data << (ram_addr[1:0] * 8);
        ram_byteen = 4'b1 << ram_addr[1:0];
    end
    else if(mw_dec_mem_mask == 4'b0011) begin //short
        ram_write_data = mw_mem_write_data << (ram_addr[1:0] * 8);
        ram_byteen = 4'b11 << ram_addr[1:0];
    end
    else begin//word
        ram_write_data = mw_mem_write_data;
        ram_byteen = 4'b1111;
    end
end

RAM ram(
    .clk(clk),
    .address(ram_addr[31:2]),
    .q(ram_data),
    .byteena_a(ram_byteen),
    .data(ram_write_data),
    .wren(mem_wren),
    .clk_b(clk_video),
    .address_b(vram_addr_mem),
    .q_b(vram_data)
);


endmodule
