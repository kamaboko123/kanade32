// STAGE REGISTER
// Betwenn IF(instruction fetch) and ID(instruction decode)
module STAGE_REG_FD(
    input reset_n,
    input clk,
    input wren,
    input [31:0] in_ins,
    input [31:0] in_next_pc,
    output reg [31:0] ins,
    output reg [31:0] next_pc
);

always @(posedge clk) begin
    if(!reset_n) begin
        ins <= 0;
        next_pc <= 0;
    end
    else if(wren) begin
        ins <= in_ins;
        next_pc <= in_next_pc;
    end
end

endmodule


// STAGE REGISTER
// Betwenn ID(instruction decode) and EX(instruction execute)
module STAGE_REG_DE(
    input reset_n,
    input clk,
    input wren,
    input [31:0] in_next_pc,
    input [31:0] in_data0,
    input [31:0] in_data1,
    input [4:0] in_dst_reg,
    input [31:0] in_ins,
    input in_dec_alu_src_a,
    input in_dec_alu_src_b,
    input in_dec_reg_write,
    input in_dec_mem_read,
    input in_dec_mem_write,
    input [2:0] in_dec_mem_acc_mode,
    input in_dec_branch,
    input in_dec_jmp,
    input [4:0] in_dec_alu_op,
    input in_dec_alu_result_to_pc,
    input in_dec_reg_hi_write,
    input in_dec_reg_lo_write,
    input [2:0] in_dec_reg_write_data_src,
    input in_dec_imm_upper,
    input in_dec_imm_sign_extend,
    output reg [31:0] next_pc,
    output reg [31:0] data0,
    output reg [31:0] data1,
    output reg [4:0] dst_reg,
    output reg [31:0] ins,
    output reg dec_alu_src_a,
    output reg dec_alu_src_b,
    output reg dec_reg_write,
    output reg dec_mem_read,
    output reg dec_mem_write,
    output reg [2:0] dec_mem_acc_mode,
    output reg dec_branch,
    output reg dec_jmp,
    output reg [4:0] dec_alu_op,
    output reg dec_alu_result_to_pc,
    output reg dec_reg_hi_write,
    output reg dec_reg_lo_write,
    output reg [2:0] dec_reg_write_data_src,
    output reg dec_imm_upper,
    output reg dec_imm_sign_extend
);

always @(posedge clk) begin
    if(!reset_n) begin
        next_pc <= 0;
        data0 <= 0;
        data1 <= 0;
        dst_reg <= 0;
        ins <= 0;
        dec_alu_src_a <= 0;
        dec_alu_src_b <= 0;
        dec_reg_write <= 0;
        dec_mem_read <= 0;
        dec_mem_write <= 0;
        dec_mem_acc_mode <= 0;
        dec_branch <= 0;
        dec_jmp <= 0;
        dec_alu_op <= 0;
        dec_alu_result_to_pc <= 0;
        dec_reg_hi_write <= 0;
        dec_reg_lo_write <= 0;
        dec_reg_write_data_src <= 0;
        dec_imm_upper <= 0;
        dec_imm_sign_extend <= 0;
    end
    else if(wren) begin
        next_pc <= in_next_pc;
        data0 <= in_data0;
        data1 <= in_data1;
        dst_reg <= in_dst_reg;
        ins <= in_ins;
        
        dec_alu_src_a <= in_dec_alu_src_a;
        dec_alu_src_b <= in_dec_alu_src_b;
        dec_reg_write <= in_dec_reg_write;
        dec_mem_read <= in_dec_mem_read;
        dec_mem_write <= in_dec_mem_write;
        dec_mem_acc_mode <= in_dec_mem_acc_mode;
        dec_branch <= in_dec_branch;
        dec_jmp <= in_dec_jmp;
        dec_alu_op <= in_dec_alu_op;
        dec_alu_result_to_pc <= in_dec_alu_result_to_pc;
        dec_reg_hi_write <= in_dec_reg_hi_write;
        dec_reg_lo_write <= in_dec_reg_lo_write;
        dec_reg_write_data_src <= in_dec_reg_write_data_src;
        dec_imm_upper <= in_dec_imm_upper;
        dec_imm_sign_extend <= in_dec_imm_sign_extend;
    end
end

endmodule


// STAGE REGISTER
// Betwenn EX(instruction execute) and MEM(memory access)
module STAGE_REG_EM(
    input reset_n,
    input clk,
    input wren,
    input [31:0] in_next_pc,
    input [31:0] in_branch_pc,
    input [31:0] in_alu_result,
    input [31:0] in_mem_write_data,
    input [4:0] in_dst_reg,
    input [31:0] in_ins,
    input in_dec_reg_write,
    input in_dec_mem_read,
    input in_dec_mem_write,
    input [2:0] in_dec_mem_acc_mode,
    input in_dec_branch,
    input in_dec_jmp,
    input in_alu_result_zero,
    input in_dec_alu_result_to_pc,
    input in_dec_reg_hi_write,
    input in_dec_reg_lo_write,
    input [63:0] in_alu_result_x64,
    input [2:0] in_dec_reg_write_data_src,
    output reg [31:0] next_pc,
    output reg [31:0] branch_pc,
    output reg [31:0] alu_result,
    output reg [31:0] mem_write_data,
    output reg [4:0] dst_reg,
    output reg [31:0] ins,
    output reg dec_reg_write,
    output reg dec_mem_read,
    output reg dec_mem_write,
    output reg [2:0] dec_mem_acc_mode,
    output reg dec_branch,
    output reg dec_jmp,
    output reg alu_result_zero,
    output reg dec_alu_result_to_pc,
    output reg dec_reg_hi_write,
    output reg dec_reg_lo_write,
    output reg [63:0] alu_result_x64,
    output reg [2:0] dec_reg_write_data_src
);

always @(posedge clk) begin
    if(!reset_n) begin
        next_pc <= 0;
        branch_pc <= 0;
        ins <= 0;
        dec_reg_write <= 0;
        dec_mem_read <= 0;
        dec_mem_write <= 0;
        dec_mem_acc_mode <= 0;
        dec_branch <= 0;
        dec_jmp <= 0;
        alu_result_zero <= 0;
        alu_result <= 0;
        dst_reg <= 0;
        mem_write_data <= 0;
        dec_alu_result_to_pc <= in_dec_alu_result_to_pc;
        dec_reg_hi_write <= 0;
        dec_reg_lo_write <= 0;
        alu_result_x64 <= 0;
        dec_reg_write_data_src <= 0;
    end
    else if(wren) begin
        next_pc <= in_next_pc;
        branch_pc <= in_branch_pc;
        ins <= in_ins;
        dec_reg_write <= in_dec_reg_write;
        dec_mem_read <= in_dec_mem_read;
        dec_mem_write <= in_dec_mem_write;
        dec_mem_acc_mode <= in_dec_mem_acc_mode;
        dec_branch <= in_dec_branch;
        dec_jmp <= in_dec_jmp;
        alu_result_zero <= in_alu_result_zero;
        alu_result <= in_alu_result;
        dst_reg <= in_dst_reg;
        mem_write_data <= in_mem_write_data;
        dec_alu_result_to_pc <= in_dec_alu_result_to_pc;
        dec_reg_hi_write <= in_dec_reg_hi_write;
        dec_reg_lo_write <= in_dec_reg_lo_write;
        alu_result_x64 <= in_alu_result_x64;
        dec_reg_write_data_src <= in_dec_reg_write_data_src;
    end
end

endmodule

// STAGE REGISTER
// Betwenn MEM(memory access) and WB(write back)
module STAGE_REG_MW(
    input reset_n,
    input clk,
    input wren,
    input [31:0] in_mem_data,
    input [31:0] in_alu_result,
    input [4:0] in_dst_reg,
    input [31:0] in_return_pc,
    input [2:0] in_dec_mem_acc_mode,
    input in_dec_reg_write,
    input [2:0] in_dec_reg_write_data_src,
    output reg [31:0] mem_data,
    output reg [31:0] alu_result,
    output reg [4:0] dst_reg,
    output reg [31:0] return_pc,
    output reg [2:0] dec_mem_acc_mode,
    output reg dec_reg_write,
    output reg [2:0] dec_reg_write_data_src
);

always @(posedge clk) begin
    if(!reset_n) begin
        mem_data <= 0;
        alu_result <= 0;
        dst_reg <= 0;
        return_pc <= 0;
        dec_reg_write <= 0;
        dec_mem_acc_mode <= 0;
        dec_reg_write_data_src <= 0;
    end
    else if(wren) begin
        mem_data <= in_mem_data;
        alu_result <= in_alu_result;
        dst_reg <= in_dst_reg;
        return_pc <= in_return_pc;
        dec_reg_write <= in_dec_reg_write;
        dec_mem_acc_mode <= in_dec_mem_acc_mode;
        dec_reg_write_data_src <= in_dec_reg_write_data_src;
    end
end
endmodule



module PC(
    input reset_n,
    input clk,
    input wren,
    input [31:0] jmp_to,
    output [31:0] pc_data
);

reg [31:0] _pc_data;

assign pc_data = _pc_data;

always @(posedge clk) begin
    if(!reset_n) begin
        _pc_data <= 0;
    end
    else if(wren) begin
        _pc_data <= jmp_to;
    end
end


endmodule
