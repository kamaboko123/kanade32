module RAM(
    input clk,
    input wren,
    input [29:0] address,
    input [31:0] data,
    output [31:0] q
);

reg [29:0] _address;
reg [31:0] _ram [255:0];

initial $readmemh("test/memdata/test2.mem", _ram);

/*
initial begin
    _ram[0] = 32'h20080005;
    _ram[1] = 32'h21080005;
    _ram[2] = 32'hac080040;
    _ram[3] = 32'h8c0a0040;
    //_ram[0] = 32'hafbf001c;
    //_ram[1] = 32'h00000000;
    //_ram[8] = 32'h11111111;
end
*/

always @(posedge clk) begin
    _address <= address;
    if(wren) begin
        _ram[address] <= data;
    end
end

wire [31:0] debug;
assign debug = _ram[16];
assign q = _ram[_address];

endmodule

