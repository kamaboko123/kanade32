module ALU(
    input [2:0] op,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] x, //result
    output zero //flg for conditional branch
);

wire _zero;
assign _zero = (x == 32'h0) ? 1 : 0;
assign zero = (op == `ALU_OP_SUB_NOT) ? ~_zero : _zero;
always @* begin
    case(op)
        `ALU_OP_AND: begin
            x = a & b;
        end
        `ALU_OP_OR: begin
            x = a | b;
        end
        `ALU_OP_NOR: begin
            x = ~(a | b);
        end
        `ALU_OP_XOR: begin
            x = a ^ b;
        end
        `ALU_OP_ADD: begin
            x = a + b;
        end
        `ALU_OP_SUB: begin
            x = a - b;
        end
        `ALU_OP_SUB_NOT: begin
            x = a - b;
        end
        `ALU_OP_SLT: begin
            if(a < b) begin
                x = 32'b1;
            end
            else begin
                x = 32'b0;
            end
        end
        default: begin
            x = 3'bx;
        end
    endcase
end

endmodule
