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
    input [4:0] in_rd_reg,
    input [31:0] in_imm,
    input in_dec_alu_src,
    input in_dec_mem_to_reg,
    input in_dec_reg_write,
    input in_dec_mem_read,
    input in_dec_mem_write,
    input in_dec_branch,
    input in_dec_jmp,
    input [2:0] in_dec_alu_op,
    output reg [31:0] next_pc,
    output reg [31:0] data0,
    output reg [31:0] data1,
    output reg [4:0] rd_reg,
    output reg [31:0] imm,
    output reg dec_alu_src,
    output reg dec_mem_to_reg,
    output reg dec_reg_write,
    output reg dec_mem_read,
    output reg dec_mem_write,
    output reg dec_branch,
    output reg dec_jmp,
    output reg [2:0] dec_alu_op
);

always @(posedge clk) begin
    if(!reset_n) begin
        next_pc <= 0;
        data0 <= 0;
        data1 <= 0;
        rd_reg <= 0;
        imm <= 0;
        
        dec_alu_src <= 0;
        dec_mem_to_reg <= 0;
        dec_reg_write <= 0;
        dec_mem_read <= 0;
        dec_mem_write <= 0;
        dec_branch <= 0;
        dec_jmp <= 0;
        dec_alu_op <= 0;
    end
    else if(wren) begin
        next_pc <= in_next_pc;
        data0 <= in_data0;
        data1 <= in_data1;
        rd_reg <= in_rd_reg;
        imm <= in_imm;
        
        dec_alu_src <= in_dec_alu_src;
        dec_mem_to_reg <= in_dec_mem_to_reg;
        dec_reg_write <= in_dec_reg_write;
        dec_mem_read <= in_dec_mem_read;
        dec_mem_write <= in_dec_mem_write;
        dec_branch <= in_dec_branch;
        dec_jmp <= in_dec_jmp;
        dec_alu_op <= in_dec_alu_op;
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
    input [4:0] in_rd_reg,
    input in_dec_mem_to_reg,
    input in_dec_reg_write,
    input in_dec_mem_read,
    input in_dec_mem_write,
    input in_dec_branch,
    input in_dec_jmp,
    input in_alu_result_zero,
    output reg [31:0] next_pc,
    output reg [31:0] branch_pc,
    output reg [31:0] alu_result,
    output reg [31:0] mem_write_data,
    output reg [4:0] rd_reg,
    output reg dec_mem_to_reg,
    output reg dec_reg_write,
    output reg dec_mem_read,
    output reg dec_mem_write,
    output reg dec_branch,
    output reg dec_jmp,
    output reg alu_result_zero
);

always @(posedge clk) begin
    if(!reset_n) begin
        next_pc <= 0;
        branch_pc <= 0;
        dec_mem_to_reg <= 0;
        dec_reg_write <= 0;
        dec_mem_read <= 0;
        dec_mem_write <= 0;
        dec_branch <= 0;
        dec_jmp <= 0;
        alu_result_zero <= 0;
        alu_result <= 0;
        rd_reg <= 0;
        mem_write_data <= 0;
    end
    else if(wren) begin
        next_pc <= in_next_pc;
        branch_pc <= in_branch_pc;
        dec_mem_to_reg <= in_dec_mem_to_reg;
        dec_reg_write <= in_dec_reg_write;
        dec_mem_read <= in_dec_mem_read;
        dec_mem_write <= in_dec_mem_write;
        dec_branch <= in_dec_branch;
        dec_jmp <= in_dec_jmp;
        alu_result_zero <= in_alu_result_zero;
        alu_result <= in_alu_result;
        rd_reg <= in_rd_reg;
        mem_write_data <= in_mem_write_data;
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
    input [4:0] in_rd_reg,
    input in_dec_mem_to_reg,
    input in_dec_reg_write,
    output reg [31:0] mem_data,
    output reg [31:0] alu_result,
    output reg [4:0] rd_reg,
    output reg dec_mem_to_reg,
    output reg dec_reg_write
);

always @(posedge clk) begin
    if(!reset_n) begin
        mem_data <= 0;
        alu_result <= 0;
        rd_reg <= 0;
        dec_mem_to_reg <= 0;
        dec_reg_write <= 0;
    end
    else if(wren) begin
        mem_data <= in_mem_data;
        alu_result <= in_alu_result;
        rd_reg <= in_rd_reg;
        dec_mem_to_reg <= in_dec_mem_to_reg;
        dec_reg_write <= in_dec_reg_write;
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
