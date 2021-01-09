module ALU(
    input [4:0] op,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] x, //result
    output reg zero, //flg for conditional branch
    output reg [63:0] x64
);

reg signed [31:0] signed_a;
reg signed [31:0] signed_b;

//wire _zero;
//assign _zero = (x == 32'h0) ? 1 : 0;
//assign zero = (op == `ALU_OP_SUB_NOT) ? ~_zero : _zero;
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
            zero = (x == 32'h0) ? 1 : 0;
        end
        `ALU_OP_SUB_NOT: begin
            x = a - b;
            zero = (x == 32'h0) ? 0 : 1;
        end
        `ALU_OP_SLT: begin
            if(a < b) begin
                x = 32'b1;
            end
            else begin
                x = 32'b0;
            end
            zero = (x == 32'h0) ? 1 : 0;
        end
        `ALU_OP_SLT_S: begin
            if(a[31] != b[31]) begin
                if(a[30:0] > b[30:0]) begin
                    x = 32'b1;
                end
                else begin
                    x = 32'b0;
                end
            end
            else begin
                if(a[30:0] < b[30:0]) begin
                    x = 32'b1;
                end
                else begin
                    x = 32'b0;
                end
            end
            zero = x;
        end
        `ALU_OP_SLE_S: begin
            if(a[31] != b[31]) begin
                if(a[30:0] >= b[30:0]) begin
                    x = 32'b1;
                end
                else begin
                    x = 32'b0;
                end
            end
            else begin
                if(a[30:0] <= b[30:0]) begin
                    x = 32'b1;
                end
                else begin
                    x = 32'b0;
                end
            end
            zero = x;
        end
        `ALU_OP_MULT: begin
            x64 = a * b;
        end
        `ALU_OP_MULTU: begin
            x64 = a * b;
        end
        `ALU_OP_DIV: begin
            x64[63:32] = a % b;
            x64[31:0] = a / b;
        end
        `ALU_OP_DIVU: begin
            x64[63:32] = a % b;
            x64[31:0] = a / b;
        end
        `ALU_OP_SLL_IMM: begin
            x = a << b[10:6];
        end
        `ALU_OP_SRL_IMM: begin
            x = a >> b[10:6];
        end
        `ALU_OP_SLL: begin
            x = b << a;
        end
        `ALU_OP_SRL: begin
            x = b >> a;
        end
        `ALU_OP_SRA: begin
            signed_b = b;
            x = signed_b >>> a;
        end
        `ALU_OP_SRA_IMM: begin
            signed_a = a;
            x = signed_a >>> b[10:6];
        end
        default: begin
            x64 = 64'b0;
        end
    endcase
end

endmodule
