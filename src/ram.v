module RAM(
    input clk,
    input wren,
    input [29:0] address,
    input [31:0] data,
    output [31:0] q
);

reg [29:0] _address;
reg [31:0] _ram [2047:0];

//initial $readmemh("test_c/memdata/fibonacci.mem", _ram);
initial $readmemh("test/memdata/test5.mem", _ram);

always @(posedge clk) begin
    _address <= address;
    if(wren) begin
        _ram[address] <= data;
    end
end

assign q = _ram[_address];

endmodule

