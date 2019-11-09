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


module PC(
    input reset_n,
    input clk,
    input wren,
    input [31:0] jmp_to,
    output reg [31:0] pc_data
);
always @(posedge clk) begin
    if(!reset_n) begin
        pc_data <= 0;
    end
    else if(wren) begin
        pc_data <= jmp_to;
    end
end


endmodule
