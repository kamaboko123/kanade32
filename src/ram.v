module RAM(
    input clk,
    input wren,
    input [29:0] address,
    input [31:0] data,
    output [31:0] q
);

reg [29:0] _address;
reg [31:0] _ram [255:0];

//initial $readmemh("test_c/memdata/fibonacci.mem", _ram);

initial begin
    _ram[0] = 32'h20080020;
    _ram[1] = 32'h21080020;
    //_ram[0] = 32'hafbf001c;
    //_ram[1] = 32'h00000000;
    _ram[8] = 32'h11111111;
end

always @(posedge clk) begin
    _address <= address;
    if(wren) begin
        _ram[address] <= data;
    end
end

wire [31:0] debug;
assign debug = _ram[1];
assign q = _ram[_address];

endmodule

