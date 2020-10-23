/*
    VGA出力モジュール
    640 * 480 * 60Hz (16色) で設計
    
*/

module VGA(
    input reset_n,        //リセット(負論理)
    input clk,            //クロック(50MHz)
    input [3:0] col,      //表示色
    output sync_h,        //水平同期信号
    output sync_v,        //垂直同期信号
    output reg[9:0] v_x,  //水平座標 (メモリアクセス用)
    output reg[9:0] v_y,  //垂直座標 (メモリアクセス用)
    output reg [3:0] r,       //R出力
    output reg [3:0] g,       //G出力 
    output reg [3:0] b        //B出力  
);
/*
    実際はメモリアクセスに1クロックかかるので、次に表示したい座標を入れておくべきかも。
*/

parameter SIZE_H = 640;
parameter SIZE_V = 480;
parameter BACK_PORCH_H = 48;
parameter FRONT_PORCH_H = 16;
parameter BACK_PORCH_V = 33;
parameter FRONT_PORCH_V = 10;
parameter SYNC_H_PX = 96; //水平同期信号をLにする時間(96 px分、画素周波数25MHzで 40ns * 96px = 3840ns [3.84us])
parameter SYNC_V_LINE = 2; //垂直同期信号をLにする時間(2 line分、画素周波数25MHzで 40ns * 800px * 2line = 64000ns [64us])

parameter STATE_INIT = 0;
parameter STATE_RESET = 1;
parameter STATE_START = 2;
parameter STATE_DRAW_LINE = 3;

parameter SYNC_H_START = BACK_PORCH_H + SIZE_H + FRONT_PORCH_H;
parameter SYNC_H_END = BACK_PORCH_H + SIZE_H + FRONT_PORCH_H + SYNC_H_PX;
parameter H_MAX = BACK_PORCH_H + SIZE_H + FRONT_PORCH_H + SYNC_H_PX;

parameter SYNC_V_START = BACK_PORCH_V + SIZE_V + FRONT_PORCH_V;
parameter SYNC_V_END = BACK_PORCH_V + SIZE_V + FRONT_PORCH_V + SYNC_V_LINE;
parameter V_MAX = BACK_PORCH_V + SIZE_V + FRONT_PORCH_V + SYNC_V_LINE;

reg [3:0] state;
reg [9:0] h_pos;
reg [9:0] v_pos;

wire next_fetch_h;
wire next_fetch_v;
wire mem_fetch;

assign sync_h = !(h_pos >= SYNC_H_START && h_pos < SYNC_H_END);
assign sync_v = !(v_pos >= SYNC_V_START && v_pos < SYNC_V_END);
assign next_fetch_h = (h_pos + 1 >= BACK_PORCH_H && h_pos + 1 < BACK_PORCH_H + SIZE_H);
assign next_fetch_v = (v_pos >= BACK_PORCH_V && v_pos < BACK_PORCH_V + SIZE_V);
assign mem_fetch = (next_fetch_h && next_fetch_v);

wire H_END;
assign H_END = (h_pos == H_MAX - 1);
wire V_END;
assign V_END = (v_pos == V_MAX - 1);


always @(mem_fetch or h_pos or v_pos or col) begin
	if(mem_fetch) begin
		v_x = h_pos - BACK_PORCH_H + 1;
		v_y = v_pos - BACK_PORCH_V;
		if(col == 0) begin
			r = 0;
			g = 0;
			b = 0;
		end
		else begin
			r = 15;
			g = 15;
			b = 15;
		end
    end
    else begin
        v_x = 0;
        v_y = 0;
		  r = 0;
		  g = 0;
		  b = 0;
    end
end

//horizontal pos
always @(posedge clk) begin
	if(!reset_n) begin
        h_pos <= 0;
        v_pos <= 0;
    end
	 else begin
		 if(H_END) begin
			if(V_END) begin
					v_pos <= 0;
			  end
			  else begin
					v_pos <= v_pos + 1;
			  end
			  h_pos <= 0;
		 end
		 else begin
			  h_pos <= h_pos + 1;
		 end
	end
end



endmodule