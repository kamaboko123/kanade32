module KANADE32(
    input reset_n,
    input clk
);

wire fd_wren;
wire pc_wren;
wire [31:0] pc_data;
wire [31:0] pc_data_inc;
wire [31:0] ins_data;

CONTROL ctrl(
    .reset_n(reset_n),
    .clk(clk),
    .pc_wren(pc_wren),
    .fd_wren(fd_wren)
);

STAGE_REG_FD fd(
    .reset_n(reset_n),
    .clk(clk),
    .wren(fd_wren),
    .in_ins(ins_data),
    .in_next_pc(pc_data_inc)
);

PC pc(
    .reset_n(reset_n),
    .clk(clk),
    .wren(pc_wren),
    .jmp_to(pc_data_inc),
    .pc_data(pc_data)
);
assign pc_data_inc = pc_data + 4;

RAM ram(
    .clk(clk),
    .address(pc_data_inc[31:2]),
    .q(ins_data)
);

endmodule
