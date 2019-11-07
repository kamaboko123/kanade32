module RAM(
    input clk,
    input wren,
    input [29:0] address,
    input [31:0] data,
    output [31:0] q
);

reg [31:0] _data;
reg [29:0] _address;
reg [31:0] _rom [255:0];
reg _wren;

initial $readmemh("test_c/memdata/fibonacci.mem", _rom);

always @(posedge clk) begin
    _wren <= wren;
    _address <= address;
    _data <= data;
    
    if(wren) begin
        _rom[_address] <= data;
    end
end

wire [31:0] debug;
assign debug = _rom[1];
assign q = _rom[_address];

endmodule

