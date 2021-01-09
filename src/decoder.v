`include "include/define.v"

module DECODER(
    input [5:0] ins_op,
    input [5:0] func_code,
    output reg reg_dst,
    output reg alu_src_a,
    output reg alu_src_b,
    output reg reg_write,
    output reg mem_read,
    output reg mem_write,
    output reg [2:0] mem_acc_mode,
    output reg branch,
    output reg jmp,
    output reg [4:0] alu_op,
    output reg [2:0] reg_write_data_src,
    output reg alu_result_to_pc,
    output reg reg_hi_write,
    output reg reg_lo_write,
    output reg imm_upper,
    output reg imm_sign_extend
);

always @* begin
    reg_dst = 1'b0;
    alu_src_a = `ALU_SRC_A_RS;
    alu_src_b = `ALU_SRC_B_RT;
    reg_write = 1'b0;
    mem_read = 1'b0;
    mem_write = 1'b0;
    mem_acc_mode = `MEM_MODE_WORD;
    branch = 1'b0;
    jmp = 1'b0;
    alu_op = 4'b000;
    reg_write_data_src = `REG_WRITE_DATA_SRC_ALU;
    alu_result_to_pc = 1'b0;
    reg_hi_write = 1'b0;
    reg_lo_write = 1'b0;
    imm_upper = 1'b0;
    imm_sign_extend = 1'b0;
    
    case(ins_op)
        6'b000000: begin
            case(func_code)
                //add
                6'b100000: begin
                    reg_dst = 1'b1;
                    reg_write = 1'b1;
                    alu_op = `ALU_OP_ADD;
                end
                //sub
                6'b100010: begin
                    reg_dst = 1'b1;
                    reg_write = 1'b1;
                    alu_op = `ALU_OP_SUB;
                end
                //subu
                6'b100011: begin
                    reg_dst = 1'b1;
                    reg_write = 1'b1;
                    alu_op = `ALU_OP_SUB;
                end
                //jr rs
                6'b001000: begin
                    branch = 1'b1;
                    jmp = 1'b1;
                    alu_op = `ALU_OP_OR;
                    alu_result_to_pc = 1'b1;
                end
                //addu
                6'b100001: begin
                    reg_dst = 1'b1;
                    reg_write = 1'b1;
                    alu_op = `ALU_OP_ADD;
                end
                //and
                6'b100100: begin
                    reg_dst = 1'b1;
                    reg_write = 1'b1;
                    alu_op = `ALU_OP_AND;
                end
                //nor
                6'b100111: begin
                    reg_dst = 1'b1;
                    reg_write = 1'b1;
                    alu_op = `ALU_OP_NOR;
                end
                //or
                6'b100101: begin
                    reg_dst = 1'b1;
                    reg_write = 1'b1;
                    alu_op = `ALU_OP_OR;
                end
                //slt
                6'b101010: begin
                    reg_dst = 1'b1;
                    reg_write = 1'b1;
                    alu_op = `ALU_OP_SLT_S;
                end
                //sltu
                6'b101011: begin
                    reg_dst = 1'b1;
                    reg_write = 1'b1;
                    alu_op = `ALU_OP_SLT;
                end
                //xor
                6'b100110: begin
                    reg_dst = 1'b1;
                    reg_write = 1'b1;
                    alu_op = `ALU_OP_XOR;
                end
                //mult
                6'b011000: begin
                    reg_dst = 1'b0;
                    reg_write = 1'b0;
                    alu_op = `ALU_OP_MULT;
                    reg_hi_write = 1'b1;
                    reg_lo_write = 1'b1;
                end
                //multu
                6'b011001: begin
                    reg_dst = 1'b0;
                    reg_write = 1'b0;
                    alu_op = `ALU_OP_MULTU;
                    reg_hi_write = 1'b1;
                    reg_lo_write = 1'b1;
                end
                //div
                6'b011010: begin
                    reg_dst = 1'b0;
                    reg_write = 1'b0;
                    alu_op = `ALU_OP_DIV;
                    reg_hi_write = 1'b1;
                    reg_lo_write = 1'b1;
                end
                //divu
                6'b011011: begin
                    reg_dst = 1'b0;
                    reg_write = 1'b0;
                    alu_op = `ALU_OP_DIVU;
                    reg_hi_write = 1'b1;
                    reg_lo_write = 1'b1;
                end
                //mflo
                6'b010010: begin
                    reg_dst = 1'b1; //転送先はrd
                    reg_write = 1'b1;
                    alu_op = `ALU_OP_ADD;
                    reg_write_data_src = `REG_WRITE_DATA_SRC_RLO;
                end
                //mfhi
                6'b010000: begin
                    reg_dst = 1'b1; //転送先はrd
                    reg_write = 1'b1;
                    alu_op = `ALU_OP_ADD;
                    reg_write_data_src = `REG_WRITE_DATA_SRC_RHI;
                end
                
                //sll
                6'b000000: begin
                    alu_src_a = `ALU_SRC_A_RT;
                    alu_src_b = `ALU_SRC_B_IMM;
                    reg_dst = 1'b1;
                    reg_write = 1'b1;
                    alu_op = `ALU_OP_SLL_IMM;
                end
                //srl
                6'b000010: begin
                    alu_src_a = `ALU_SRC_A_RT;
                    alu_src_b = `ALU_SRC_B_IMM;
                    reg_dst = 1'b1;
                    reg_write = 1'b1;
                    alu_op = `ALU_OP_SRL_IMM;
                end
                //sllv
                6'b000100: begin
                    alu_src_a = `ALU_SRC_A_RS;
                    alu_src_b = `ALU_SRC_B_RT;
                    reg_dst = 1'b1;
                    reg_write = 1'b1;
                    alu_op = `ALU_OP_SLL;
                end
                //srlv
                6'b000110: begin
                    alu_src_a = `ALU_SRC_A_RS;
                    alu_src_b = `ALU_SRC_B_RT;
                    reg_dst = 1'b1;
                    reg_write = 1'b1;
                    alu_op = `ALU_OP_SRL;
                end
                //sra
                6'b000011: begin
                    alu_src_a = `ALU_SRC_A_RT;
                    alu_src_b = `ALU_SRC_B_IMM;
                    reg_dst = 1'b1;
                    reg_write = 1'b1;
                    alu_op = `ALU_OP_SRA_IMM;
                end
                //srav
                6'b000111: begin
                    alu_src_a = `ALU_SRC_A_RS;
                    alu_src_b = `ALU_SRC_B_RT;
                    reg_dst = 1'b1;
                    reg_write = 1'b1;
                    alu_op = `ALU_OP_SRA;
                end
            endcase
        end
        //blt
        6'b000001: begin
            branch = 1'b1;
            alu_op = `ALU_OP_SLT_S;
        end
        //j
        6'b000010: begin
            branch = 1'b1;
            jmp = 1'b1;
            alu_op = `ALU_OP_OR;
        end
        //jal
        6'b000011: begin
            branch = 1'b1;
            jmp = 1'b1;
            reg_write = 1'b1;
            alu_op = `ALU_OP_OR;
            //pc_to_ra = 1'b1;
            reg_write_data_src = `REG_WRITE_DATA_SRC_PC;
        end
        //beq
        6'b000100: begin
            branch = 1'b1;
            alu_op = `ALU_OP_SUB;
        end
        //bne
        6'b000101: begin
            branch = 1'b1;
            alu_op = `ALU_OP_SUB_NOT;
        end
        //blez
        6'b000110: begin
            branch = 1'b1;
            alu_op = `ALU_OP_SLE_S;
        end
        //addi
        6'b001000: begin
            alu_src_b = `ALU_SRC_B_IMM;
            reg_write = 1'b1;
            alu_op = `ALU_OP_ADD;
            imm_sign_extend = 1'b1;
        end
        //addiu(li)
        6'b001001: begin
            alu_src_b = `ALU_SRC_B_IMM;
            reg_write = 1'b1;
            alu_op = `ALU_OP_ADD;
            imm_sign_extend = 1'b1;
        end
        //andi
        6'b001100: begin
            alu_src_b = `ALU_SRC_B_IMM;
            reg_write = 1'b1;
            alu_op = `ALU_OP_AND;
        end
        //ori
        6'b001101: begin
            alu_src_b = `ALU_SRC_B_IMM;
            reg_write = 1'b1;
            alu_op = `ALU_OP_OR;
        end
        //slti
        6'b001010: begin
            alu_src_b = `ALU_SRC_B_IMM;
            reg_write = 1'b1;
            alu_op = `ALU_OP_SLT_S;
        end
        //sltiu
        6'b001011: begin
            alu_src_b = `ALU_SRC_B_IMM;
            reg_write = 1'b1;
            alu_op = `ALU_OP_SLT;
        end
        //xori
        6'b001110: begin
            alu_src_b = `ALU_SRC_B_IMM;
            reg_write = 1'b1;
            alu_op = `ALU_OP_XOR;
        end

        //lw
        6'b100011: begin
            alu_src_b = `ALU_SRC_B_IMM;
            reg_write_data_src = `REG_WRITE_DATA_SRC_MEM;
            reg_write = 1'b1;
            mem_read = 1'b1;
            alu_op = `ALU_OP_ADD;
        end
        //lbu
        6'b100100: begin
            alu_src_b = `ALU_SRC_B_IMM;
            reg_write_data_src = `REG_WRITE_DATA_SRC_MEM;
            reg_write = 1'b1;
            mem_read = 1'b1;
            alu_op = `ALU_OP_ADD;
            mem_acc_mode = `MEM_MODE_BYTE;
        end
        //lb
        6'b100000: begin
            alu_src_b = `ALU_SRC_B_IMM;
            reg_write_data_src = `REG_WRITE_DATA_SRC_MEM;
            reg_write = 1'b1;
            mem_read = 1'b1;
            alu_op = `ALU_OP_ADD;
            mem_acc_mode = `MEM_MODE_BYTE_SIGN;
        end
        //lhu
        6'b100101: begin
            alu_src_b = `ALU_SRC_B_IMM;
            reg_write_data_src = `REG_WRITE_DATA_SRC_MEM;
            reg_write = 1'b1;
            mem_read = 1'b1;
            alu_op = `ALU_OP_ADD;
            mem_acc_mode = `MEM_MODE_HWORD;
        end
        //lh
        6'b100001: begin
            alu_src_b = `ALU_SRC_B_IMM;
            reg_write_data_src = `REG_WRITE_DATA_SRC_MEM;
            reg_write = 1'b1;
            mem_read = 1'b1;
            alu_op = `ALU_OP_ADD;
            mem_acc_mode = `MEM_MODE_HWORD_SIGN;
        end

        //sw
        6'b101011: begin
            alu_src_b = `ALU_SRC_B_IMM;
            mem_write = 1'b1;
            alu_op = `ALU_OP_ADD;
            mem_acc_mode = `MEM_MODE_WORD;
        end
        //sb
        6'b101000: begin
            alu_src_b =`ALU_SRC_B_IMM;
            mem_write = 1'b1;
            alu_op = `ALU_OP_ADD;
            mem_acc_mode = `MEM_MODE_BYTE;
        end
        //sh
        6'b101001: begin
            alu_src_b = `ALU_SRC_B_IMM;
            mem_write = 1'b1;
            alu_op = `ALU_OP_ADD;
            mem_acc_mode = `MEM_MODE_HWORD;
        end
        //lui
        6'b001111: begin
            alu_src_b = `ALU_SRC_B_IMM;
            reg_write = 1'b1;
            alu_op = `ALU_OP_ADD;
            imm_upper = 1'b1;
        end
    endcase
end

endmodule
