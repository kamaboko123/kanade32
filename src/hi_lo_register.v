module HILO_REGISTER(
    input reset_n,
    input clk,
    input write_hi,
    input write_lo,
    input [31:0] in_data_hi,
    input [31:0] in_data_lo,
    output reg [31:0] data_hi,
    output reg [31:0] data_lo
);

wire [31:0] debug_hi, debug_lo;
assign debug_hi = data_hi;
assign debug_lo = data_lo;

always @(posedge clk) begin
    if(!reset_n) begin
        data_hi <= 32'b0;
        data_lo <= 32'b0;
    end
    else begin
        if(write_hi) begin
            data_hi <= in_data_hi;
        end
        if(write_lo) begin
            data_lo <= in_data_lo;
        end
    end
end

endmodule
