`timescale 1 ns/ 100 ps

module TEST_KANADE32();

reg reset_n;
reg clk_cpu;
reg clk_video;

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
    
    #10000000 $finish;
end

KANADE32 kanade(
    .reset_n(reset_n),
    .clk(clk_cpu),
    .clk_video(clk_video)
);

endmodule
