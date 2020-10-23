module RAM(
    input clk,
    input wren,
    input [29:0] address,
    input [31:0] data,
    output [31:0] q,
    input clk_b,
    input [29:0] address_b,
    output [31:0] q_b
);

reg [29:0] _address;
reg [31:0] _ram [32767:0];
reg [29:0] _address_b;

initial $readmemh("test_c/memdata/fibonacci.mem", _ram);
//initial $readmemh("test/memdata/test5.mem", _ram);

always @(posedge clk) begin
    _address <= address;
    if(wren) begin
        _ram[address] <= data;
    end
end

always @(posedge clk_b) begin
    _address_b <= address_b;
end

assign q = _ram[_address];
assign q_b = _ram[_address_b];

endmodule

