module REGFILE(
    input reset_n,
    input clk,
    input reg_wren, //write flg
    input [4:0] r_reg0, //read select
    input [4:0] r_reg1,
    input [4:0] w_reg0, //write select
    input [31:0] w_data, //write data
    output [31:0] reg0, //selected register data
    output [31:0] reg1
);

wire [31:0] _write_sel;

wire [31:0] _r_data[31:0];

wire [31:0] debug_zero, debug_v0, debug_v1, debug_a0, debug_a1, debug_a2, debug_a3, debug_t0, debug_t1, debug_t2, debug_t3, debug_t4, debug_t5, debug_t6, debug_t7, debug_s0, debug_s1, debug_s2, debug_s3, debug_s4, debug_s5, debug_s6, debug_s7, debug_t8, debug_t9, debug_gp, debug_sp, debug_fp, debug_ra;
assign debug_zero = _r0_data;
assign debug_v0 = _r2_data;
assign debug_v1 = _r3_data;
assign debug_a0 = _r4_data;
assign debug_a1 = _r5_data;
assign debug_a2 = _r6_data;
assign debug_a3 = _r7_data;
assign debug_t0 = _r8_data;
assign debug_t1 = _r9_data;
assign debug_t2 = _r10_data;
assign debug_t3 = _r11_data;
assign debug_t4 = _r12_data;
assign debug_t5 = _r13_data;
assign debug_t6 = _r14_data;
assign debug_t7 = _r15_data;
assign debug_s0 = _r16_data;
assign debug_s1 = _r17_data;
assign debug_s2 = _r18_data;
assign debug_s3 = _r19_data;
assign debug_s4 = _r20_data;
assign debug_s5 = _r21_data;
assign debug_s6 = _r22_data;
assign debug_s7 = _r23_data;
assign debug_t8 = _r24_data;
assign debug_t9 = _r25_data;
assign debug_gp = _r28_data;
assign debug_sp = _r29_data;
assign debug_fp = _r30_data;
assign debug_ra = _r31_data;

wire [31:0] _r0_data;
wire [31:0] _r1_data;
wire [31:0] _r2_data;
wire [31:0] _r3_data;
wire [31:0] _r4_data;
wire [31:0] _r5_data;
wire [31:0] _r6_data;
wire [31:0] _r7_data;
wire [31:0] _r8_data;
wire [31:0] _r9_data;
wire [31:0] _r10_data;
wire [31:0] _r11_data;
wire [31:0] _r12_data;
wire [31:0] _r13_data;
wire [31:0] _r14_data;
wire [31:0] _r15_data;
wire [31:0] _r16_data;
wire [31:0] _r17_data;
wire [31:0] _r18_data;
wire [31:0] _r19_data;
wire [31:0] _r20_data;
wire [31:0] _r21_data;
wire [31:0] _r22_data;
wire [31:0] _r23_data;
wire [31:0] _r24_data;
wire [31:0] _r25_data;
wire [31:0] _r26_data;
wire [31:0] _r27_data;
wire [31:0] _r28_data;
wire [31:0] _r29_data;
wire [31:0] _r30_data;
wire [31:0] _r31_data;
wire [1023:0] regs;

assign regs = {
    _r31_data,
    _r30_data,
    _r29_data,
    _r28_data,
    _r27_data,
    _r26_data,
    _r25_data,
    _r24_data,
    _r23_data,
    _r22_data,
    _r21_data,
    _r20_data,
    _r19_data,
    _r18_data,
    _r17_data,
    _r16_data,
    _r15_data,
    _r14_data,
    _r13_data,
    _r12_data,
    _r11_data,
    _r10_data,
    _r9_data,
    _r8_data,
    _r7_data,
    _r6_data,
    _r5_data,
    _r4_data,
    _r3_data,
    _r2_data,
    _r1_data,
    _r0_data
};

assign _write_sel = (reg_wren == 1) ? (32'b1 << w_reg0) : (32'b0);
assign reg0 = mux_reg(r_reg0, regs);
assign reg1 = mux_reg(r_reg1, regs);


REGISTER_32 r0(reset_n, clk, _write_sel[0], 32'h0, _r0_data); //zero
REGISTER_32 r1(reset_n, clk, _write_sel[1], w_data, _r1_data); //at
REGISTER_32 r2(reset_n, clk, _write_sel[2], w_data, _r2_data); //v0
REGISTER_32 r3(reset_n, clk, _write_sel[3], w_data, _r3_data); //v1
REGISTER_32 r4(reset_n, clk, _write_sel[4], w_data, _r4_data); //a0
REGISTER_32 r5(reset_n, clk, _write_sel[5], w_data, _r5_data); //a1
REGISTER_32 r6(reset_n, clk, _write_sel[6], w_data, _r6_data); //a2
REGISTER_32 r7(reset_n, clk, _write_sel[7], w_data, _r7_data); //a3
REGISTER_32 r8(reset_n, clk, _write_sel[8], w_data, _r8_data); //t0
REGISTER_32 r9(reset_n, clk, _write_sel[9], w_data, _r9_data); //t1
REGISTER_32 r10(reset_n, clk, _write_sel[10], w_data, _r10_data); //t2
REGISTER_32 r11(reset_n, clk, _write_sel[11], w_data, _r11_data); //t3
REGISTER_32 r12(reset_n, clk, _write_sel[12], w_data, _r12_data); //t4
REGISTER_32 r13(reset_n, clk, _write_sel[13], w_data, _r13_data); //t5
REGISTER_32 r14(reset_n, clk, _write_sel[14], w_data, _r14_data); //t6
REGISTER_32 r15(reset_n, clk, _write_sel[15], w_data, _r15_data); //t7
REGISTER_32 r16(reset_n, clk, _write_sel[16], w_data, _r16_data); //s0
REGISTER_32 r17(reset_n, clk, _write_sel[17], w_data, _r17_data); //s1
REGISTER_32 r18(reset_n, clk, _write_sel[18], w_data, _r18_data); //s2
REGISTER_32 r19(reset_n, clk, _write_sel[19], w_data, _r19_data); //s3
REGISTER_32 r20(reset_n, clk, _write_sel[20], w_data, _r20_data); //s4
REGISTER_32 r21(reset_n, clk, _write_sel[21], w_data, _r21_data); //s5
REGISTER_32 r22(reset_n, clk, _write_sel[22], w_data, _r22_data); //s6
REGISTER_32 r23(reset_n, clk, _write_sel[23], w_data, _r23_data); //s7
REGISTER_32 r24(reset_n, clk, _write_sel[24], w_data, _r24_data); //t8
REGISTER_32 r25(reset_n, clk, _write_sel[25], w_data, _r25_data); //t9
REGISTER_32 r26(reset_n, clk, _write_sel[26], w_data, _r26_data); //k0
REGISTER_32 r27(reset_n, clk, _write_sel[27], w_data, _r27_data); //k1
REGISTER_32 r28(reset_n, clk, _write_sel[28], w_data, _r28_data); //gp
REGISTER_32 r29(reset_n, clk, _write_sel[29], w_data, _r29_data); //sp
REGISTER_32 r30(reset_n, clk, _write_sel[30], w_data, _r30_data); //fp
REGISTER_32 r31(reset_n, clk, _write_sel[31], w_data, _r31_data); //ra

function [31:0] mux_reg;
    input [4:0] sel;
    input [1023:0] regs;
    
    begin
        case(sel)
            0: mux_reg = regs[(32*1)-1:32*0];
            1: mux_reg = regs[(32*2)-1:32*1];
            2: mux_reg = regs[(32*3)-1:32*2];
            3: mux_reg = regs[(32*4)-1:32*3];
            4: mux_reg = regs[(32*5)-1:32*4];
            5: mux_reg = regs[(32*6)-1:32*5];
            6: mux_reg = regs[(32*7)-1:32*6];
            7: mux_reg = regs[(32*8)-1:32*7];
            8: mux_reg = regs[(32*9)-1:32*8];
            9: mux_reg = regs[(32*10)-1:32*9];
            10: mux_reg = regs[(32*11)-1:32*10];
            11: mux_reg = regs[(32*12)-1:32*11];
            12: mux_reg = regs[(32*13)-1:32*12];
            13: mux_reg = regs[(32*14)-1:32*13];
            14: mux_reg = regs[(32*15)-1:32*14];
            15: mux_reg = regs[(32*16)-1:32*15];
            16: mux_reg = regs[(32*17)-1:32*16];
            17: mux_reg = regs[(32*18)-1:32*17];
            18: mux_reg = regs[(32*19)-1:32*18];
            19: mux_reg = regs[(32*20)-1:32*19];
            20: mux_reg = regs[(32*21)-1:32*20];
            21: mux_reg = regs[(32*22)-1:32*21];
            22: mux_reg = regs[(32*23)-1:32*22];
            23: mux_reg = regs[(32*24)-1:32*23];
            24: mux_reg = regs[(32*25)-1:32*24];
            25: mux_reg = regs[(32*26)-1:32*25];
            26: mux_reg = regs[(32*27)-1:32*26];
            27: mux_reg = regs[(32*28)-1:32*27];
            28: mux_reg = regs[(32*29)-1:32*28];
            29: mux_reg = regs[(32*30)-1:32*29];
            30: mux_reg = regs[(32*31)-1:32*30];
            31: mux_reg = regs[(32*32)-1:32*31];
        endcase
    end
endfunction

endmodule

