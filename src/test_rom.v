`timescale 1 ns/ 100 ps

module TEST_RAM();

parameter CLK = 10;

reg reset;
reg clk;
reg [29:0] address;
reg wren;
reg [31:0] data;

always begin
    #(CLK) clk <= ~clk;
end

initial begin
    $dumpvars(0, TEST_RAM);
    #0
        clk <= 0;
        wren <= 0;
    #0;
    
    #(CLK / 2);
    #(CLK * 2) address <= 0;
    #(CLK);
    
    #(CLK / 2) address <= (30'h1);
    #(CLK * 2) address <= (30'h2);
    #(CLK * 2) address <= (30'h3);
    
    #(CLK * 3);
    #1;
    
    #(CLK);
    wren <= 1;
    address <= 1;
    data = 32'hff;
    
    #(CLK * 2);
    
    
    #50 $finish;
end

RAM ram(
    .clk(clk),
    .address(address),
    .wren(wren),
    .data(data)
);

endmodule
