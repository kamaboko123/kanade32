`timescale 1 ns/ 100 ps

module TEST_KANADE32();

parameter CLK = 10;

reg reset_n;
reg clk;

always begin
    #(CLK) clk <= ~clk;
end

initial begin
    $dumpvars(0, TEST_KANADE32);
    
    #0;
    reset_n <= 1;
    clk <= 0;
    
    #1 reset_n <= 0;
    #(CLK * 2) reset_n <= 1;
    
    #1000 $finish;
end

KANADE32 kanade(
    .reset_n(reset_n),
    .clk(clk)
);

endmodule
