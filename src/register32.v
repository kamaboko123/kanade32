module REGISTER_32(
    input reset_n,
    input clk,
    input write,
    input [31:0] in_data,
    output reg [31:0] data
);

always @(posedge clk) begin
    if(!reset_n) begin
        data <= 32'b0;
    end
    else begin
        if(write) begin
            data <= in_data;
        end
    end
end

endmodule
