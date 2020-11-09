`include "include/define.v"

module DECODER(
    input [5:0] ins_op,
    input [5:0] func_code,
    output reg reg_dst,
    output reg alu_src,
    output reg mem_to_reg,
    output reg reg_write,
    output reg mem_read,
    output reg mem_write,
    output reg [1:0] mem_acc_mode,
    output reg branch,
    output reg jmp,
    output reg [3:0] alu_op,
    output reg pc_to_ra,
    output reg alu_result_to_pc
);

always @* begin
    reg_dst = 1'b0;
    alu_src = 1'b0;
    mem_to_reg = 1'b0;
    reg_write = 1'b0;
    mem_read = 1'b0;
    mem_write = 1'b0;
    mem_acc_mode = `MEM_MODE_WORD;
    branch = 1'b0;
    jmp = 1'b0;
    alu_op = 4'b000;
    pc_to_ra = 1'b0;
    alu_result_to_pc = 1'b0;
    
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
            pc_to_ra = 1'b1;
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
        //ble
        6'b000110: begin
            branch = 1'b1;
            alu_op = `ALU_OP_SLE_S;
        end
        //addi
        6'b001000: begin
            alu_src = 1'b1;
            reg_write = 1'b1;
            alu_op = `ALU_OP_ADD;
        end
        //addiu(li)
        6'b001001: begin
            alu_src = 1'b1;
            reg_write = 1'b1;
            alu_op = `ALU_OP_ADD;
        end
        //andi
        6'b001100: begin
            alu_src = 1'b1;
            reg_write = 1'b1;
            alu_op = `ALU_OP_AND;
        end
        //ori
        6'b001101: begin
            alu_src = 1'b1;
            reg_write = 1'b1;
            alu_op = `ALU_OP_OR;
        end
        //slti
        6'b001010: begin
            alu_src = 1'b1;
            reg_write = 1'b1;
            alu_op = `ALU_OP_SLT_S;
        end
        //sltiu
        6'b001011: begin
            alu_src = 1'b1;
            reg_write = 1'b1;
            alu_op = `ALU_OP_SLT;
        end
        //xori
        6'b001110: begin
            alu_src = 1'b1;
            reg_write = 1'b1;
            alu_op = `ALU_OP_XOR;
        end
        //lw
        6'b100011: begin
            alu_src = 1'b1;
            mem_to_reg = 1'b1;
            reg_write = 1'b1;
            mem_read = 1'b1;
            alu_op = `ALU_OP_ADD;
        end
        //lbu
        6'b100100: begin
            alu_src = 1'b1;
            mem_to_reg = 1'b1;
            reg_write = 1'b1;
            mem_read = 1'b1;
            alu_op = `ALU_OP_ADD;
            mem_acc_mode = `MEM_MODE_BYTE;
        end
        //lhu
        6'b100101: begin
            alu_src = 1'b1;
            mem_to_reg = 1'b1;
            reg_write = 1'b1;
            mem_read = 1'b1;
            alu_op = `ALU_OP_ADD;
            mem_acc_mode = `MEM_MODE_HWORD;
        end

        //sw
        6'b101011: begin
            alu_src = 1'b1;
            mem_write = 1'b1;
            alu_op = `ALU_OP_ADD;
            mem_acc_mode = `MEM_MODE_WORD;
        end
        //sb
        6'b101000: begin
            alu_src = 1'b1;
            mem_write = 1'b1;
            alu_op = `ALU_OP_ADD;
            mem_acc_mode = `MEM_MODE_BYTE;
        end
        //sh
        6'b101001: begin
            alu_src = 1'b1;
            mem_write = 1'b1;
            alu_op = `ALU_OP_ADD;
            mem_acc_mode = `MEM_MODE_HWORD;
        end
    endcase
end

endmodule
