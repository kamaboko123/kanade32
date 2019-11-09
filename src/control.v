`include "include/define.v"

module CONTROL(
    input reset_n,
    input clk,
    output reg pc_wren,
    output reg fd_wren
);

reg [4:0] state;

always @(posedge clk) begin
    if(!reset_n) begin
        state <= `STATE_INIT;
    end
    case (state)
        `STATE_INIT:begin
            state <= `STATE_FETCH;
        end
        `STATE_FETCH:begin
            //state <= `STATE_DECODE;
            state <= `STATE_FETCH_WAIT;
        end
        `STATE_FETCH_WAIT:begin
            state <= `STATE_NEXT_INS;
        end
        `STATE_NEXT_INS: begin
            state <= `STATE_FETCH;
        end
    endcase
end

always @(state) begin
    fd_wren = 0;
    pc_wren = 0;
    case(state)
        `STATE_INIT:begin
        end
        `STATE_FETCH:begin
        end
        `STATE_FETCH_WAIT:begin
            fd_wren = 1;
        end
        `STATE_NEXT_INS:begin
            pc_wren = 1;
        end
    endcase
end


endmodule
