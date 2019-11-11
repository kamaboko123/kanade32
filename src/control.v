`include "include/define.v"

module CONTROL(
    input reset_n,
    input clk,
    output reg pc_wren,
    output reg ram_addr_src, //0=pc, 1=alu_result
    output reg fd_wren,
    output reg de_wren,
    output reg em_wren,
    output reg mw_wren,
    output reg mw_mem_wren,
    output reg reg_wren,
    output reg refresh_n
);

reg [4:0] state;

always @(posedge clk) begin
    if(!reset_n) begin
        state <= `STATE_INIT;
    end
    else begin
        case (state)
            `STATE_INIT:begin
                state <= `STATE_FETCH;
            end
            `STATE_FETCH:begin
                state <= `STATE_FETCH_WAIT;
            end
            `STATE_FETCH_WAIT:begin
                //state <= `STATE_NEXT_INS;
                state <= `STATE_DECODE;
            end
            `STATE_DECODE: begin
                state <= `STATE_EXECUTE;
            end
            `STATE_EXECUTE: begin
                state <= `STATE_MEM;
            end
            `STATE_MEM: begin
                state <= `STATE_MEM_WAIT;
            end
            `STATE_MEM_WAIT: begin
                state <= `STATE_WB;
            end
            `STATE_WB: begin
                state <= `STATE_FETCH;
            end
        endcase
    end
end

always @(state) begin
    pc_wren = 0;
    ram_addr_src = 0;
    
    fd_wren = 0;
    de_wren = 0;
    em_wren = 0;
    mw_wren = 0;
    mw_mem_wren = 0;
    reg_wren = 0;
    refresh_n = 1;
    
    case(state)
        `STATE_INIT:begin
            refresh_n = 0;
        end
        `STATE_FETCH:begin
        end
        `STATE_FETCH_WAIT:begin
            fd_wren = 1;
        end
        `STATE_DECODE:begin
            de_wren = 1;
        end
        `STATE_EXECUTE:begin
            em_wren = 1;
        end
        `STATE_MEM:begin
            ram_addr_src = 1;
            pc_wren = 1;
            mw_mem_wren = 1;
        end
        `STATE_MEM_WAIT:begin
            mw_wren = 1;
        end
        `STATE_WB:begin
            reg_wren = 1;
            refresh_n = 0;
        end
        default:begin
        end
    endcase
end


endmodule
