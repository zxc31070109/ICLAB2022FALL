`include "synchronizer.v"
`include "syn_XOR.v"
module CDC(
	//Input Port
	clk1,
    clk2,
    clk3,
	rst_n,
	in_valid1,
	in_valid2,
	user1,
	user2,

    //Output Port
    out_valid1,
    out_valid2,
	equal,
	exceed,
	winner
); 
//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION
//---------------------------------------------------------------------
input 		clk1, clk2, clk3, rst_n;
input 		in_valid1, in_valid2;
input [3:0]	user1, user2;

output reg	out_valid1, out_valid2;
output reg	equal, exceed, winner;
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//   WIRE AND REG DECLARATION
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//----clk1----
wire out,out_win;
reg [2:0]cdf10;  //0~4 3'b
reg [3:0]cdf9 ;  //0~8 4'b
reg [3:0]cdf8 ;  //12
reg [4:0]cdf7 ;  //16
reg [4:0]cdf6 ;  //20
reg [4:0]cdf5 ;  //24
reg [4:0]cdf4 ;  //28
reg [5:0]cdf3 ;  //32
reg [5:0]cdf2 ;  //36
reg [5:0]cdf1 ;  //52
wire cdf_w_10;
wire cdf_w_9 ;
wire cdf_w_8 ;
wire cdf_w_7 ;
wire cdf_w_6 ;
wire cdf_w_5 ;
wire cdf_w_4 ;
wire cdf_w_3 ;
wire cdf_w_2 ;
wire cdf_w_1 ;
wire cdf_w_0 ;
reg in_valid_flag;
reg [5:0]cnt;  // 49
reg [2:0]cnt5;
reg [5:0]rem_r;
reg [3:0]user_point;
reg [5:0]win;
reg [1:0]winner_r;
reg [6:0]equal_r,equal_r_clk3,eq_r,ex_r,exceed_r_clk3;
//----clk2----

//----clk3----
reg [2:0]cnt_clk3;
reg out_flag,out_flag_w;
reg [1:0] win_r_clk3;
reg[1:0]cnt_12;
//---------------------------------------------------------------------
//   PARAMETER
//---------------------------------------------------------------------
//----clk1----

//----clk2----

//----clk3----

//---------------------------------------------------------------------
//   DESIGN
//---------------------------------------------------------------------
//============================================
//   clk1 domain
//============================================
wire [3:0]user;
assign user = (in_valid1 || in_valid2)? ((in_valid1)?user1:(in_valid2)?user2:4'd0) : 4'd0;
assign cdf_w_1 = (user==1 || 
				  user==2 || 
				  user==3 || 
				  user==4 || 
				  user==5 || 
				  user==6 || 
				  user==7 || 
				  user==8 || 
				  user==9 || 
				  user==10 ||
				  user==11 ||
				  user==12 ||
				  user==13 )?1'd1:1'd0;
assign cdf_w_2 = (user==2 || 
				  user==3 || 
				  user==4 || 
				  user==5 || 
				  user==6 || 
				  user==7 || 
				  user==8 || 
				  user==9 || 
				  user==10 )?1:0;
assign cdf_w_3 = (
				  user==3 || 
				  user==4 || 
				  user==5 || 
				  user==6 || 
				  user==7 || 
				  user==8 || 
				  user==9 || 
				  user==10 )?1:0;
assign cdf_w_4 = (
				  user==4 || 
				  user==5 || 
				  user==6 || 
				  user==7 || 
				  user==8 || 
				  user==9 || 
				  user==10 )?1:0;
assign cdf_w_5 = (
				  user==5 || 
				  user==6 || 
				  user==7 || 
				  user==8 || 
				  user==9 || 
				  user==10)?1:0;
assign cdf_w_6= (
				  user==6 || 
				  user==7 || 
				  user==8 || 
				  user==9 || 
				  user==10 )?1:0;
assign cdf_w_7 = (
				  user==7||
				  user==8||
				  user==9||
				  user==10 )?1:0;
assign cdf_w_8 = (
				  user==8 || 
				  user==9 || 
				  user==10)?1:0;
assign cdf_w_9 = (
				  user==9 ||
				  user==10 )?1:0;
assign cdf_w_10 = (user==10)?1:0;




always@(posedge clk1 or negedge rst_n) begin
	if(!rst_n) begin
		cdf10 <= 4;
		cdf9 <= 8;
		cdf8 <= 12;
		cdf7 <= 16;
		cdf6 <= 20;
		cdf5 <= 24;
		cdf4 <= 28;
		cdf3 <= 32;
		cdf2 <= 36;
		cdf1 <= 52;
	end else begin
		if(cnt == 49)begin
			cdf10 <= 4;
			cdf9 <= 8;
			cdf8 <= 12;
			cdf7 <= 16;
			cdf6 <= 20;
			cdf5 <= 24;
			cdf4 <= 28;
			cdf3 <= 32;
			cdf2 <= 36;
			cdf1 <= 52;
		end
		else begin
			cdf10 <= cdf10 - cdf_w_10;
			cdf9  <= cdf9  - cdf_w_9 ;
			cdf8  <= cdf8  - cdf_w_8 ;
			cdf7  <= cdf7  - cdf_w_7 ;
			cdf6  <= cdf6  - cdf_w_6 ;
			cdf5  <= cdf5  - cdf_w_5 ;
			cdf4  <= cdf4  - cdf_w_4 ;
			cdf3  <= cdf3  - cdf_w_3 ;
			cdf2  <= cdf2  - cdf_w_2 ;
			cdf1  <= cdf1  - cdf_w_1 ;
		end
	end
end
always @(posedge clk1 or negedge rst_n) begin
	if(~rst_n) begin
		in_valid_flag <= 0;
	end else begin
		if(in_valid1 || in_valid2)
			in_valid_flag <= 1;
		else 
			in_valid_flag <= 0;
	end
end
always @(posedge clk1 or negedge rst_n) begin
	if(~rst_n) begin
		cnt <= 0;
	end else begin
		if(in_valid1 || in_valid2)begin
			if(cnt == 49)
				cnt <= 0;
			else 
				cnt <= cnt+1;
		end
			
	end
end
always @(posedge clk1 or negedge rst_n) begin
	if(~rst_n) begin
		cnt5 <= 0;
	end else begin
		if(in_valid1 || in_valid2)begin
			if(cnt5 == 4)
				cnt5 <= 0;
			else 
				cnt5 <= cnt5+1;
		end		
	end
end
always @(*) begin 
	if(user > 4'd10) begin
		user_point = 1;
	end
	else 
		user_point = user;

end
always @(posedge clk1 or negedge rst_n) begin 
	if(~rst_n) begin
		rem_r <= 0;
	end else begin
		if(cnt5 == 0)
			rem_r <= 6'd21-user_point;
		else
			rem_r <= (rem_r[5])?rem_r:rem_r - user_point ;
	end
end
reg[5:0]a,b,c;
always @(*) begin 
	if(rem_r[5])begin
		a=0;
	end
	else begin
		case (rem_r)
		1:a=cdf1;
		2:a=cdf2;
		3:a=cdf3;
		4:a=cdf4;
		5:a=cdf5;
		6:a=cdf6;
		7:a=cdf7;
		8:a=cdf8;
		9:a=cdf9;
		10:a=cdf10;
		default : a=0;
		endcase
	end

end

always @(*) begin 
	if(rem_r[5])begin
		b=0;
	end
	else begin
		case (rem_r)
		1:b=cdf2;
		2:b=cdf3;
		3:b=cdf4;
		4:b=cdf5;
		5:b=cdf6;
		6:b=cdf7;
		7:b=cdf8;
		8:b=cdf9;
		9:b=cdf10;
		default : b=0;
		endcase
	end

end
always @(*) begin 
	c = a - b;
end

always @(*) begin 
	if(rem_r == 0 || rem_r > 10)
		equal_r = 0;
	else
		equal_r = ((c*25)<<2) / cdf1;
end
reg [6:0]exceed_r;
always @(*) begin
	if(rem_r[5] || rem_r == 0)
		exceed_r = 100;
	else if(rem_r > 10)
		exceed_r = 0;
	else
		exceed_r = ((b*25)<<2) / cdf1;
end
always @(posedge clk1 or negedge rst_n) begin
	if(~rst_n) begin
		eq_r <= 0;
	end else begin
		if(cnt5==3 || cnt5 ==4)
			eq_r <= equal_r;
	end
end
always @(posedge clk1 or negedge rst_n) begin
	if(~rst_n) begin
		ex_r <= 0;
	end else begin
		if(cnt5==3 || cnt5 ==4)
			ex_r <= exceed_r;
	end
end
always @(posedge clk1 or negedge rst_n) begin
	if(~rst_n) begin
		win <= 0;
	end else begin
		if(cnt5 == 0 && in_valid2)
			win <= rem_r;
	end
end
always @(*) begin 
	if(win[5] && rem_r[5])begin
		winner_r = 0;
	end
	else if(win ==  rem_r)
		winner_r =0;
	else if(rem_r[5])  //user 2
		winner_r = 2;
	else if(win[5])   //user 1
		winner_r = 3;
	else if(win < rem_r)
		winner_r = 2;

	else 
		winner_r = 3;

end
reg [1:0]win_r;
always @(posedge clk1 or negedge rst_n) begin
	if(~rst_n) begin
		win_r <= 0;
	end else begin
		win_r <= winner_r;
	end
end

//assign rem = (rem_r[5])?rem_r:rem_r - user;
//============================================
//   clk2 domain
//============================================
//always@(posedge clk2 or negedge rst_n) begin
//	if(!rst_n) begin
//		
//	end else begin
//		
//	end
//end
//============================================
//   clk3 domain
//============================================
always@(posedge clk3 or negedge rst_n) begin
	if(!rst_n) begin
		out_valid1 <=0;
	end else begin
		out_valid1 <= out_flag;
	end
end
always@(posedge clk3 or negedge rst_n) begin
	if(!rst_n) begin
		out_valid2 <=0;
	end else begin
		out_valid2 <=out_flag_w;
	end
end

always @(posedge clk3 or negedge rst_n) begin 
	if(~rst_n) begin
		equal_r_clk3 <= 0;
	end else begin
		if(out)
			equal_r_clk3 <= eq_r;
	end
end
always @(posedge clk3 or negedge rst_n) begin 
	if(~rst_n) begin
		exceed_r_clk3 <= 0;
	end else begin
		if(out)
			exceed_r_clk3 <= ex_r;
	end
end
always @(posedge clk3 or negedge rst_n) begin 
	if(~rst_n) begin
		win_r_clk3 <= 0;
	end else begin
		if(out_win)
			win_r_clk3 <= win_r;
	end
end
always @(posedge clk3 or negedge rst_n) begin 
	if(~rst_n) begin
		cnt_clk3 <= 0;
	end else begin
		if(out)
			cnt_clk3 <= 0;
		else
			cnt_clk3 <= cnt_clk3 + 1 ;
	end
end

always @(posedge clk3 or negedge rst_n) begin 
	if(~rst_n) begin
		out_flag <= 0;
	end else begin
		if(out)
			out_flag <= 1;
		else if(cnt_clk3 == 6)
			out_flag <= 0;

	end
end



always @(posedge clk3 or negedge rst_n) begin 
	if(~rst_n) begin
		out_flag_w <= 0;
	end else begin
		if(out_win)
			out_flag_w<=1;
		else if(win_r_clk3 == 0)
			out_flag_w <=0;
		else if(cnt_12==2)
			out_flag_w <=0;
	end
end
always @(posedge clk3 or negedge rst_n) begin
	if(~rst_n) begin
		cnt_12 <= 1;
	end else begin
		if(win_r_clk3==0)
			cnt_12 <= 1;
		else if(out_flag_w)begin
			cnt_12 <= cnt_12 + 1;
		end
		else
			cnt_12 <= 1;
	end
end
always @(*) begin 
	if(out_valid1)begin
		case(cnt_clk3)
			1: begin
				equal = equal_r_clk3[6];
				exceed = exceed_r_clk3[6];
			end
			2: begin
				equal = equal_r_clk3[5];
				exceed = exceed_r_clk3[5];
			end
			3: begin
				equal = equal_r_clk3[4];
				exceed = exceed_r_clk3[4];
			end
			4: begin
				equal = equal_r_clk3[3];
				exceed = exceed_r_clk3[3];	
			end
			5: begin
				equal = equal_r_clk3[2];
				exceed = exceed_r_clk3[2];
			end
			6: begin
				equal = equal_r_clk3[1];
				exceed = exceed_r_clk3[1];
			end
			7: begin
				equal = equal_r_clk3[0];
				exceed = exceed_r_clk3[0];
			end
			default:begin equal = 0;
						  exceed = 0;
			end
		endcase
	end
	else begin
		equal = 0;
		exceed = 0;
	end
end
always @(*) begin 
	if(out_valid2 && win_r_clk3 == 0 )begin
		winner = 0;
	end
	else if(out_valid2) begin
		if(cnt_12 ==2)
			winner = win_r_clk3[1];
		else if(cnt_12 ==3)
			winner = win_r_clk3[0];
		else 
			winner = 0;
	end
	else
		winner =0;
end
//---------------------------------------------------------------------
//   syn_XOR
//---------------------------------------------------------------------

syn_XOR u_syn_XOR(.IN(cnt5 == 3 || cnt5 ==4),.OUT(out),.TX_CLK(clk1),.RX_CLK(clk3),.RST_N(rst_n));
syn_XOR u_syn_XOR_winner(.IN(cnt == 10 || cnt ==20 ||cnt ==30 ||cnt ==40 ||cnt == 0 && in_valid_flag),.OUT(out_win),.TX_CLK(clk1),.RX_CLK(clk3),.RST_N(rst_n));

endmodule