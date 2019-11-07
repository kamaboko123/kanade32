module ROM(
    input clk,
    input reset_n,
    input [29:0] address,
    output [31:0] rom_data
);

reg [29:0] _address;
reg [31:0] _rom [255:0];

initial $readmemh("test_c/memdata/fibonacci.mem", _rom);

always @(posedge clk) begin
    if(!reset_n) begin
        _address <= 30'h0;
    end
    else begin
        _address <= address;
    end
end

assign rom_data = _rom[_address];

endmodule

