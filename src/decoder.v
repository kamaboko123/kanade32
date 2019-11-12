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
    output reg branch,
    output reg jmp,
    output reg [2:0] alu_op
);

always @* begin
    reg_dst = 1'b0;
    alu_src = 1'b0;
    mem_to_reg = 1'b0;
    reg_write = 1'b0;
    mem_read = 1'b0;
    mem_write = 1'b0;
    branch = 1'b0;
    jmp = 1'b0;
    alu_op = 4'b000;
    
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
            endcase
        end
        //j
        6'b000010: begin
            branch = 1'b1;
            jmp = 1'b1;
            alu_op = `ALU_OP_OR;
        end
        //addi
        6'b001000: begin
            alu_src = 1'b1;
            reg_write = 1'b1;
            alu_op = `ALU_OP_ADD;
        end
        //lw
        6'b100011:begin
            alu_src = 1'b1;
            mem_to_reg = 1'b1;
            reg_write = 1'b1;
            mem_read = 1'b1;
            alu_op = `ALU_OP_ADD;
        end
        //sw
        6'b101011: begin
            alu_src = 1'b1;
            mem_write = 1'b1;
            alu_op = `ALU_OP_ADD;
        end
    endcase
end

endmodule
