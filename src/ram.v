module RAM(
    input clock_a,
    input wren_a,
    input wren_b,
    input [29:0] address_a,
    input [31:0] data_a,
    input [3:0] byteena_a,
    output [31:0] q_a,
    input clock_b,
    input [29:0] address_b,
    output [31:0] q_b
);

reg [29:0] _address_a;
reg [31:0] _ram [131072:0];
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

always @(posedge clock_a) begin
    _address_a <= address_a;
    if(wren_a) begin
        _ram[address_a] <= (_ram[address_a] & ~mask_a) | (data_a & mask_a);
    end
end

always @(posedge clock_b) begin
    _address_b <= address_b;
end

assign q_a = _ram[_address_a];
assign q_b = _ram[_address_b];

endmodule

