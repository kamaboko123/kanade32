module RAM(
    input clk,
    input wren,
    input [29:0] address,
    input [31:0] data,
    input [3:0] byteena_a,
    output [31:0] q,
    input clk_b,
    input [29:0] address_b,
    output [31:0] q_b
);

reg [29:0] _address;
reg [31:0] _ram [32767:0];
reg [29:0] _address_b;

wire [31:0] mask_a;
wire [7:0] mask_a0;
wire [7:0] mask_a1;
wire [7:0] mask_a2;
wire [7:0] mask_a3;

assign mask_a0 = {8{byteena_a[0]}};
assign mask_a1 = {8{byteena_a[1]}};
assign mask_a2 = {8{byteena_a[2]}};
assign mask_a3 = {8{byteena_a[3]}};
assign mask_a = {mask_a3, mask_a2, mask_a1, mask_a0};

//initial $readmemh("test/c/memdata/fibonacci.mem", _ram);
//initial $readmemh("test/memdata/multi.mem", _ram);
initial $readmemh(`TEST_MEM_FILE, _ram);

always @(posedge clk) begin
    _address <= address;
    if(wren) begin
        _ram[address] <= (_ram[address] & ~mask_a) | (data & mask_a);
    end
end

always @(posedge clk_b) begin
    _address_b <= address_b;
end

assign q = _ram[_address];
assign q_b = _ram[_address_b];

endmodule

