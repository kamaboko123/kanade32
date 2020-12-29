`timescale 1 ns/ 100 ps

module TEST_KANADE32();

reg reset_n;
reg clk_cpu;
reg clk_video;

wire [1023:0] reg_debug;

wire [31:0] zero, at, v0, v1, a0, a1, a2, a3, t0, t1, t2, t3, t4, t5, t6, t7, s0, s1, s2, s3, s4, s5, s6, s7, t8, t9, k0, k1, gp, sp, fp, ra;
assign zero = reg_debug[(32*1)-1:(32*0)];
assign at = reg_debug[(32*2)-1:(32*1)];
assign v0 = reg_debug[(32*3)-1:(32*2)];
assign v1 = reg_debug[(32*4)-1:(32*3)];
assign a0 = reg_debug[(32*5)-1:(32*4)];
assign a1 = reg_debug[(32*6)-1:(32*5)];
assign a2 = reg_debug[(32*7)-1:(32*6)];
assign a3 = reg_debug[(32*8)-1:(32*7)];
assign t0 = reg_debug[(32*9)-1:(32*8)];
assign t1 = reg_debug[(32*10)-1:(32*9)];
assign t2 = reg_debug[(32*11)-1:(32*10)];
assign t3 = reg_debug[(32*12)-1:(32*11)];
assign t4 = reg_debug[(32*13)-1:(32*12)];
assign t5 = reg_debug[(32*14)-1:(32*13)];
assign t6 = reg_debug[(32*15)-1:(32*14)];
assign t7 = reg_debug[(32*16)-1:(32*15)];
assign s0 = reg_debug[(32*17)-1:(32*16)];
assign s1 = reg_debug[(32*18)-1:(32*17)];
assign s2 = reg_debug[(32*19)-1:(32*18)];
assign s3 = reg_debug[(32*20)-1:(32*19)];
assign s4 = reg_debug[(32*21)-1:(32*20)];
assign s5 = reg_debug[(32*22)-1:(32*21)];
assign s6 = reg_debug[(32*23)-1:(32*22)];
assign s7 = reg_debug[(32*24)-1:(32*23)];
assign t8 = reg_debug[(32*25)-1:(32*24)];
assign t9 = reg_debug[(32*26)-1:(32*25)];
assign k0 = reg_debug[(32*27)-1:(32*26)];
assign k1 = reg_debug[(32*28)-1:(32*27)];
assign gp = reg_debug[(32*29)-1:(32*28)];
assign sp = reg_debug[(32*30)-1:(32*29)];
assign fp = reg_debug[(32*31)-1:(32*30)];
assign ra = reg_debug[(32*32)-1:(32*31)];

//Clock generate(50MHz)
parameter CLK_PERIOD = 10 * 2;
always begin
    #(CLK_PERIOD);
    clk_video <= ~clk_video;
    clk_cpu <= ~clk_cpu;
end

initial begin
    $dumpvars(0, TEST_KANADE32);
    
    #0;
    reset_n <= 1;
    clk_cpu <= 0;
    clk_video <= 0;
    
    #1 reset_n <= 0;
    #(CLK_PERIOD * 5) reset_n <= 1;
    
    #`SIM_CLK;
    $display("zero: 0x%x\nat: 0x%x\nv0: 0x%x\nv1: 0x%x\na0: 0x%x\na1: 0x%x\na2: 0x%x\na3: 0x%x\nt0: 0x%x\nt1: 0x%x\nt2: 0x%x\nt3: 0x%x\nt4: 0x%x\nt5: 0x%x\nt6: 0x%x\nt7: 0x%x\ns0: 0x%x\ns1: 0x%x\ns2: 0x%x\ns3: 0x%x\ns4: 0x%x\ns5: 0x%x\ns6: 0x%x\ns7: 0x%x\nt8: 0x%x\nt9: 0x%x\nk0: 0x%x\nk1: 0x%x\ngp: 0x%x\nsp: 0x%x\nfp: 0x%x\nra: 0x%x\n", zero, at, v0, v1, a0, a1, a2, a3, t0, t1, t2, t3, t4, t5, t6, t7, s0, s1, s2, s3, s4, s5, s6, s7, t8, t9, k0, k1, gp, sp, fp, ra);
    $finish;
end

KANADE32 kanade(
    .reset_n(reset_n),
    .clk(clk_cpu),
    .clk_video(clk_video),
    .reg_debug(reg_debug)
);

endmodule
