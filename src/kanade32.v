module KANADE32(
    input reset_n,
    input clk,
    input clk_video,
    output [1023:0] reg_debug,
    output vga_sync_h,
    output vga_sync_v,
    output [3:0] vga_r,
    output [3:0] vga_g,
    output [3:0] vga_b
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
    if(fd_dec_reg_write_data_src == `REG_WRITE_DATA_SRC_PC) begin
        fd_dst_reg = 5'd31; //ra register(for jal instrution)
    end
    else begin
        fd_dst_reg = (fd_dec_reg_dst == 0) ? (fd_ins_data[20:16]) : (fd_ins_data[15:11]);
    end
end

//contorl decode
wire de_wren;
wire fd_dec_reg_dst; //0 = rt, 1 = rd

//control decode -> execute
wire fd_dec_alu_src_a;
wire fd_dec_alu_src_b;
wire fd_dec_reg_write;
wire fd_dec_mem_read;
wire fd_dec_mem_write;
wire [2:0] fd_dec_mem_acc_mode;
wire fd_dec_branch;
wire fd_dec_jmp;
wire fd_dec_alu_result_to_pc;
wire [4:0] fd_dec_alu_op;
wire fd_dec_reg_hi_write;
wire fd_dec_reg_lo_write;
wire [2:0] fd_dec_reg_write_data_src;
wire fd_dec_imm_upper;
wire fd_imm_sign_extend;

//datapath decode -> execute
wire [31:0] reg0;
wire [31:0] reg1;
wire [31:0] de_ins_data;


//contorl execute
wire em_wren;
wire em_dec_alu_src_a;
wire em_dec_alu_src_b;
wire [4:0] em_alu_op;

//control execute -> memory access
wire em_alu_result_zero;
wire em_dec_reg_write;
wire em_dec_mem_read;
wire em_dec_mem_write;
wire [2:0] em_dec_mem_acc_mode;
wire em_dec_branch;
wire em_dec_jmp;
wire em_dec_alu_result_to_pc;
wire em_dec_reg_hi_write;
wire em_dec_reg_lo_write;
wire [2:0] em_dec_reg_write_data_src;
wire em_dec_imm_upper;
wire em_dec_imm_sign_extend;


//datapath execute
wire [31:0] em_reg0;
wire [31:0] em_reg1;
reg [31:0] em_data0;
reg [31:0] em_data1;
reg [31:0] em_imm;
wire [31:0] em_imm_sign_extend;

//assign em_imm =  { {16{em_ins_data[15]}}, em_ins_data[15:0]}; //immediate sign extend
//assign em_data0 = em_reg0;
//assign em_data1 = (em_alu_src_b == 0) ? (em_reg1) : (em_imm);
always @* begin
    case(em_alu_src_a)
        `ALU_SRC_A_RS: begin
            em_data0 = em_reg0; //rs
        end
        `ALU_SRC_A_RT: begin
            em_data0 = em_reg1;
        end
    endcase
end
always @* begin
    case(em_alu_src_b)
        `ALU_SRC_B_RT: begin
            em_data1 = em_reg1; //rt
        end
        `ALU_SRC_B_IMM: begin
            em_data1 = em_imm;
        end
    endcase
end
wire [4:0] em_dst_reg;

always @* begin
    if(em_dec_branch) begin
        em_imm = {{16{em_ins_data[15]}}, em_ins_data[15:0]};
    end
    else begin
        case(em_dec_imm_upper)
            1'b0:begin
                case(em_dec_imm_sign_extend)
                    1'b0:begin
                        em_imm = {16'b0, em_ins_data[15:0]};
                    end
                    1'b1:begin
                        em_imm = {{16{em_ins_data[15]}}, em_ins_data[15:0]};
                    end
                endcase
                
                //em_imm = {{16{em_ins_data[15]}}, em_ins_data[15:0]};
            end
            1'b1:begin
                em_imm = {em_ins_data[15:0], 16'b0};
            end
        endcase
    end
end


//datapath execute -> memory access
wire [31:0] em_next_pc;
wire [31:0] em_branch_pc;
wire [31:0] em_alu_result;
wire [31:0] em_ins_data;
wire [63:0] em_alu_result_x64;

//control memory access
wire mw_wren;
wire mw_alu_result_zero;
wire mw_dec_mem_read;
wire mw_dec_mem_write;
wire [2:0] mw_dec_mem_acc_mode;
wire mw_dec_branch;
wire mw_dec_jmp;
wire mw_dec_alu_result_to_pc;
wire mw_mem_wren;
wire mw_dec_reg_hi_write;
wire mw_dec_reg_lo_write;
wire [2:0] mw_dec_reg_write_data_src;

wire mem_wren;
assign mem_wren = (mw_mem_wren & mw_dec_mem_write);

wire mw_pc_src;
assign mw_pc_src = (mw_dec_branch & mw_alu_result_zero);

//control memory access -> write back
wire mw_dec_reg_write;

//datapath memory access
wire [31:0] _mw_next_pc;
wire [31:0] mw_branch_pc;
wire [31:0] mw_alu_result;
wire [63:0] mw_alu_result_x64;
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
            if(mw_dec_reg_write_data_src == `REG_WRITE_DATA_SRC_PC) begin
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
wire [2:0] w_dec_mem_acc_mode; //memory access mode
wire reg_wren; //control
wire w_dec_reg_write; //stage register mw

wire _reg_wren;
assign _reg_wren = (reg_wren & w_dec_reg_write);

//datapath write back
wire [31:0] w_alu_result;
wire [31:0] w_mem_data;
wire [4:0] w_dst_reg;
wire w_dec_reg_hi_write;
wire w_dec_reg_lo_write;
wire [2:0] w_dec_reg_write_data_src;

wire [31:0] w_return_pc;
reg [31:0] w_reg_write_data;
wire [63:0] w_hilo_data;

//メモリからレジスタにデータを読み出すとき(load命令)のデータの計算
wire [31:0] w_reg_write_data_from_mem_byte;
wire [31:0] w_reg_write_data_from_mem_hword;
//alu_resultがメモリアドレス、メモリからのデータは32bit固定なので、下位2bit指定されるバイト単位でデータを取り出す
assign w_reg_write_data_from_mem_byte = (w_mem_data & (32'hFF000000 >> (w_alu_result[1:0] * 8))) >> (3 - w_alu_result[1:0]) * 8;
assign w_reg_write_data_from_mem_hword = (w_mem_data & (32'hFFFF0000 >> (w_alu_result[1] * 16))) >> (1 - w_alu_result[1]) * 16;

//レジスタに書き込むデータの生成
always @* begin
    case(w_dec_reg_write_data_src)
        `REG_WRITE_DATA_SRC_PC: begin
            w_reg_write_data = w_return_pc;
        end
        `REG_WRITE_DATA_SRC_MEM: begin
            case(w_dec_mem_acc_mode)
                `MEM_MODE_BYTE: begin //byte access(unsigned)
                    w_reg_write_data = w_reg_write_data_from_mem_byte;
                end
                `MEM_MODE_BYTE_SIGN: begin //byte access(signed)
                    w_reg_write_data = {{24{w_reg_write_data_from_mem_byte[7]}}, w_reg_write_data_from_mem_byte[7:0]};
                end
                `MEM_MODE_HWORD: begin //half word access(unsigned)
                    w_reg_write_data = w_reg_write_data_from_mem_hword;
                end
                `MEM_MODE_HWORD_SIGN: begin //half word access(signed)
                    w_reg_write_data = {{16{w_reg_write_data_from_mem_hword[15]}}, w_reg_write_data_from_mem_hword[15:0]};
                end
                default: begin
                    w_reg_write_data = w_mem_data;
                end
            endcase
        end
        `REG_WRITE_DATA_SRC_RHI: begin
            w_reg_write_data = w_hilo_data[63:32];
        end
        `REG_WRITE_DATA_SRC_RLO: begin
            w_reg_write_data = w_hilo_data[31:0];
        end
        `REG_WRITE_DATA_SRC_ALU: begin
            w_reg_write_data = w_alu_result;
        end
        default: begin
            w_reg_write_data = 32'bx;
        end
    endcase
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
    .in_dec_alu_src_a(fd_dec_alu_src_a),
    .in_dec_alu_src_b(fd_dec_alu_src_b),
    .in_dec_reg_write(fd_dec_reg_write),
    .in_dec_mem_read(fd_dec_mem_read),
    .in_dec_mem_write(fd_dec_mem_write),
    .in_dec_mem_acc_mode(fd_dec_mem_acc_mode),
    .in_dec_branch(fd_dec_branch),
    .in_dec_jmp(fd_dec_jmp),
    .in_dec_alu_op(fd_dec_alu_op),
    .in_ins(fd_ins_data),
    .in_dec_alu_result_to_pc(fd_dec_alu_result_to_pc),
    .in_dec_reg_hi_write(fd_dec_reg_hi_write),
    .in_dec_reg_lo_write(fd_dec_reg_lo_write),
    .in_dec_reg_write_data_src(fd_dec_reg_write_data_src),
    .in_dec_imm_upper(fd_dec_imm_upper),
    .in_dec_imm_sign_extend(fd_dec_imm_sign_extend),
    .next_pc(em_next_pc),
    .data0(em_reg0),
    .data1(em_reg1),
    .dst_reg(em_dst_reg),
    .ins(em_ins_data),
    .dec_alu_src_a(em_alu_src_a),
    .dec_alu_src_b(em_alu_src_b),
    .dec_alu_op(em_alu_op),
    .dec_reg_write(em_dec_reg_write),
    .dec_mem_read(em_dec_mem_read),
    .dec_mem_write(em_dec_mem_write),
    .dec_mem_acc_mode(em_dec_mem_acc_mode),
    .dec_branch(em_dec_branch),
    .dec_jmp(em_dec_jmp),
    .dec_alu_result_to_pc(em_dec_alu_result_to_pc),
    .dec_reg_hi_write(em_dec_reg_hi_write),
    .dec_reg_lo_write(em_dec_reg_lo_write),
    .dec_reg_write_data_src(em_dec_reg_write_data_src),
    .dec_imm_upper(em_dec_imm_upper),
    .dec_imm_sign_extend(em_dec_imm_sign_extend)
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
    .in_dec_reg_write(em_dec_reg_write),
    .in_dec_mem_read(em_dec_mem_read),
    .in_dec_mem_write(em_dec_mem_write),
    .in_dec_mem_acc_mode(em_dec_mem_acc_mode),
    .in_dec_branch(em_dec_branch),
    .in_dec_jmp(em_dec_jmp),
    .in_alu_result_zero(em_alu_result_zero),
    .in_dec_alu_result_to_pc(em_dec_alu_result_to_pc),
    .in_dec_reg_hi_write(em_dec_reg_hi_write),
    .in_dec_reg_lo_write(em_dec_reg_lo_write),
    .in_alu_result_x64(em_alu_result_x64),
    .in_dec_reg_write_data_src(em_dec_reg_write_data_src),
    .next_pc(_mw_next_pc),
    .branch_pc(mw_branch_pc),
    .alu_result(mw_alu_result),
    .mem_write_data(mw_mem_write_data),
    .dst_reg(mw_dst_reg),
    .ins(mw_ins_data),
    .dec_reg_write(mw_dec_reg_write),
    .dec_mem_read(mw_dec_mem_read),
    .dec_mem_write(mw_dec_mem_write),
    .dec_mem_acc_mode(mw_dec_mem_acc_mode),
    .dec_branch(mw_dec_branch),
    .dec_jmp(mw_dec_jmp),
    .alu_result_zero(mw_alu_result_zero),
    .dec_alu_result_to_pc(mw_dec_alu_result_to_pc),
    .dec_reg_hi_write(mw_dec_reg_hi_write),
    .dec_reg_lo_write(mw_dec_reg_lo_write),
    .alu_result_x64(mw_alu_result_x64),
    .dec_reg_write_data_src(mw_dec_reg_write_data_src)
);

STAGE_REG_MW mw(
    .reset_n(stage_refresh_n),
    .clk(clk),
    .wren(mw_wren),
    .in_mem_data(ram_data),
    .in_alu_result(mw_alu_result),
    .in_dst_reg(mw_dst_reg),
    .in_return_pc(mw_return_pc),
    .in_dec_mem_acc_mode(mw_dec_mem_acc_mode),
    .in_dec_reg_write(mw_dec_reg_write),
    .in_dec_reg_write_data_src(mw_dec_reg_write_data_src),
    .mem_data(w_mem_data),
    .alu_result(w_alu_result),
    .dst_reg(w_dst_reg),
    .dec_mem_acc_mode(w_dec_mem_acc_mode),
    .dec_reg_write(w_dec_reg_write),
    .return_pc(w_return_pc),
    .dec_reg_write_data_src(w_dec_reg_write_data_src)
);

HILO_REGISTER hilo_reg(
    .reset_n(reset_n),
    .clk(clk),
    .write_hi(mw_dec_reg_hi_write),
    .write_lo(mw_dec_reg_hi_write),
    .in_data_hi(mw_alu_result_x64[63:32]),
    .in_data_lo(mw_alu_result_x64[31:0]),
    .data_hi(w_hilo_data[63:32]),
    .data_lo(w_hilo_data[31:0])
    //data_hi,
    //data_lo
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
    .reg1(reg1),
    .regs(reg_debug)
);

DECODER dec(
    .ins_op(fd_ins_data[31:26]),
    .func_code(fd_ins_data[5:0]),
    .alu_src_a(fd_dec_alu_src_a),
    .alu_src_b(fd_dec_alu_src_b),
    .reg_dst(fd_dec_reg_dst),
    .reg_write(fd_dec_reg_write),
    .mem_read(fd_dec_mem_read),
    .mem_write(fd_dec_mem_write),
    .mem_acc_mode(fd_dec_mem_acc_mode),
    .branch(fd_dec_branch),
    .jmp(fd_dec_jmp),
    .alu_op(fd_dec_alu_op),
    .alu_result_to_pc(fd_dec_alu_result_to_pc),
    .reg_hi_write(fd_dec_reg_hi_write),
    .reg_lo_write(fd_dec_reg_lo_write),
    .reg_write_data_src(fd_dec_reg_write_data_src),
    .imm_upper(fd_dec_imm_upper),
    .imm_sign_extend(fd_dec_imm_sign_extend)
);

ALU alu(
    .op(em_alu_op),
    .a(em_data0),
    .b(em_data1),
    .x(em_alu_result),
    .zero(em_alu_result_zero),
    .x64(em_alu_result_x64)
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


wire [31:0] vram_data;
reg [7:0] vram_data_px;
wire [9:0] v_x;
wire [9:0] v_y;
wire [19:0] vram_addr;
wire [31:0] vram_addr_byte;
wire [29:0] vram_addr_word;
//vramのアドレス(0始まり)
assign vram_addr = (v_y[9:1] * 320) + (v_x[9:1]);
//メモリアクセス時のアドレス 1 + vram_addr(16bit) = 0x0001****
//メモリへのアクセスは32bit(4byte)単位でアクセスするので、下42bitは切り捨てる
//VRAMは0x00010000から
assign vram_addr_byte = {{16'h1, vram_addr[15:0]}};
assign vram_addr_word = vram_addr_byte[31:2];


//1pxは16色 4bitで表現する
//VRAMのデータは4byte単位のアクセスなので、下4bitによって取り出す4bitを決める。
always @(vram_addr_byte[1:0]) begin
    case(vram_addr_byte[1:0])
        2'b00: vram_data_px = vram_data[31:24];
        2'b01: vram_data_px = vram_data[23:16];
        2'b10: vram_data_px = vram_data[15:8];
        2'b11: vram_data_px = vram_data[7:0];
    endcase
end

VGA vga(
    .reset_n(reset_n),
    .clk(clk_video),
    .col(vram_data_px),
    .sync_h(vga_sync_h),
    .sync_v(vga_sync_v),
    .v_x(v_x),
    .v_y(v_y),
    .r(vga_r),
    .g(vga_g),
    .b(vga_b)
);

reg [31:0] ram_write_data;
reg [3:0] ram_byteen;
always @* begin
    if(mem_wren == 1'b1) begin //store
        if(mw_dec_mem_acc_mode == `MEM_MODE_BYTE) begin //byte
            ram_write_data = mw_mem_write_data << ((3 - ram_addr[1:0]) * 8);
            ram_byteen = 4'b1000 >> ram_addr[1:0];
        end
        else if(mw_dec_mem_acc_mode == `MEM_MODE_HWORD) begin //short
            ram_write_data = mw_mem_write_data << ((1 - ram_addr[1]) * 16);
            ram_byteen = 4'b1100 >> ram_addr[1:0];
        end
        else begin//word
            ram_write_data = mw_mem_write_data;
            ram_byteen = 4'b1111;
        end
    end
    else begin //load
        ram_byteen = 4'b1111;
        /*
        if(mw_dec_mem_acc_mode == `MEM_MODE_BYTE) begin
            ram_data =  _ram_data & (32'hFF << (ram_addr[1:0] * 8));
        end
        else begin
            ram_data = _ram_data;
        end
        */
    end
end

wire [31:0] _ram_data;

RAM ram(
    .clock_a(clk),
    .address_a(ram_addr[31:2]),
    .q_a(ram_data),
    .byteena_a(ram_byteen),
    .data_a(ram_write_data),
    .wren_a(mem_wren),
    .wren_b(1'b0),
    .clock_b(clk_video),
    .address_b(vram_addr_word),
    .q_b(vram_data)
);


endmodule
