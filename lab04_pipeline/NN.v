module NN(
	// Input signals
	clk,
	rst_n,
	in_valid_u,
	in_valid_w,
	in_valid_v,
	in_valid_x,
	weight_u,
	weight_w,
	weight_v,
	data_x,
	// Output signals
	out_valid,
	out
);

//---------------------------------------------------------------------
//   PARAMETER
//---------------------------------------------------------------------

// IEEE floating point paramenters
parameter inst_sig_width = 23;
parameter inst_exp_width = 8;
parameter inst_ieee_compliance = 0;
parameter inst_arch = 2;
parameter one =32'b00111111100000000000000000000000;
//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION
//---------------------------------------------------------------------
input  clk, rst_n, in_valid_u, in_valid_w, in_valid_v, in_valid_x;
input [inst_sig_width+inst_exp_width:0] weight_u, weight_w, weight_v;
input [inst_sig_width+inst_exp_width:0] data_x;
output reg	out_valid;
output reg [inst_sig_width+inst_exp_width:0] out;

//---------------------------------------------------------------------
//   WIRE AND REG DECLARATION
//---------------------------------------------------------------------

reg [31:0]x1[0:2];
reg [31:0]x2[0:2];
reg [31:0]x3[0:2];
reg [31:0]u1[0:2];
reg [31:0]u2[0:2];
reg [31:0]u3[0:2];
reg [31:0]w1[0:2];
reg [31:0]w2[0:2];
reg [31:0]w3[0:2];
reg [31:0]v1[0:2];
reg [31:0]v2[0:2];
reg [31:0]v3[0:2];
reg [31:0]h[0:2];
reg [31:0]h2[0:2];
reg [31:0]h3[0:2];
reg [31:0]u_1,u_2,u_3,x_1,x_2,x_3,w_1,w_2,w_3,h_1,h_2,h_3,v_1,v_2,v_3,h_1_reg,h_2_reg,h_3_reg;
wire[31:0]y,y_h,sigmoid,wh_ux_add,y_ans;
reg[31:0]UX_product,WH_product,wh_ux_add_reg,UX_product_wire;
reg[31:0]sigmoid_out,UX_product_delay,WH_product_add_wire,UX_product_add_wire;
reg [31:0] yout,yout_delay;
reg[31:0]x3_temp[0:2];
reg[6:0]i,j,k;
//***********************************			  
// parameter	  
//***********************************	  
parameter IDLE       =  2'd0;
parameter INPUT      =  2'd1;
parameter CAL  	     =  2'd2;
parameter OUTPUT_1   =  2'd3;
	


//****************************************
//Reg Daclaration		  
//****************************************
reg [1:0]cstate;
reg [1:0]nstate;			  			  
	    

//************************************
//		  FSM_sample code
//************************************
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) 
		cstate <= IDLE;
	else
		cstate <= nstate;
end

always@(*)
begin
	case(cstate)
	IDLE:
		nstate = (in_valid_x)? INPUT:IDLE; 
		
	INPUT:
		nstate = (!in_valid_x) ? CAL:INPUT;	  
		
	CAL:
		nstate = (j==3)?OUTPUT_1:CAL;
	
	OUTPUT_1:
		nstate =  (i==8) ? IDLE:OUTPUT_1;
	
	default nstate = IDLE;		 
	endcase

end

//---------------------------------------------------------------------
//   Input
//---------------------------------------------------------------------
//x
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		// reset
		x1[0] <= 0 ;
		x1[1] <= 0 ;
		x1[2] <= 0 ;
		x2[0] <= 0 ;
		x2[1] <= 0 ;
		x2[2] <= 0 ;
		x3[0] <= 0 ;
		x3[1] <= 0 ;
		x3[2] <= 0 ;
	end
	else if (in_valid_x) begin
			if(i==0)
				x1[0]<=data_x;
			else if(i==1)
				x1[1]<=data_x;
			else if(i==2)
				x1[2]<=data_x;
			else if(i==3)
				x2[0]<=data_x;
			else if(i==4)
				x2[1]<=data_x;
			else if(i==5)
				x2[2]<=data_x;
			else if(i==6)
				x3[0]<=data_x;
			else if(i==7)
				x3[1]<=data_x;
			else if(i==8)
				x3[2]<=data_x;
	end
	
end
//u
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		// reset
		u1[0] <= 0 ;
		u1[1] <= 0 ;
		u1[2] <= 0 ;
		u2[0] <= 0 ;
		u2[1] <= 0 ;
		u2[2] <= 0 ;
		u3[0] <= 0 ;
		u3[1] <= 0 ;
		u3[2] <= 0 ;
	end
	else if (in_valid_x) begin
			if(i==0)
				u1[0]<=weight_u;
			else if(i==1)
				u1[1]<=weight_u;
			else if(i==2)
				u1[2]<=weight_u;
			else if(i==3)
				u2[0]<=weight_u;
			else if(i==4)
				u2[1]<=weight_u;
			else if(i==5)
				u2[2]<=weight_u;
			else if(i==6)
				u3[0]<=weight_u;
			else if(i==7)
				u3[1]<=weight_u;
			else if(i==8)
				u3[2]<=weight_u;
	end
end
//w
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		// reset
		w1[0] <= 0 ;
		w1[1] <= 0 ;
		w1[2] <= 0 ;
		w2[0] <= 0 ;
		w2[1] <= 0 ;
		w2[2] <= 0 ;
		w3[0] <= 0 ;
		w3[1] <= 0 ;
		w3[2] <= 0 ;
	end
	else if (in_valid_x) begin
			if(i==0)
				w1[0]<=weight_w;
			else if(i==1)
				w1[1]<=weight_w;
			else if(i==2)
				w1[2]<=weight_w;
			else if(i==3)
				w2[0]<=weight_w;
			else if(i==4)
				w2[1]<=weight_w;
			else if(i==5)
				w2[2]<=weight_w;
			else if(i==6)
				w3[0]<=weight_w;
			else if(i==7)
				w3[1]<=weight_w;
			else if(i==8)
				w3[2]<=weight_w;
	end
end
//w
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		// reset
		v1[0] <= 0 ;
		v1[1] <= 0 ;
		v1[2] <= 0 ;
		v2[0] <= 0 ;
		v2[1] <= 0 ;
		v2[2] <= 0 ;
		v3[0] <= 0 ;
		v3[1] <= 0 ;
		v3[2] <= 0 ;
	end
	else if (in_valid_x) begin
			if(i==0)
				v1[0]<=weight_v;
			else if(i==1)
				v1[1]<=weight_v;
			else if(i==2)
				v1[2]<=weight_v;
			else if(i==3)
				v2[0]<=weight_v;
			else if(i==4)
				v2[1]<=weight_v;
			else if(i==5)
				v2[2]<=weight_v;
			else if(i==6)
				v3[0]<=weight_v;
			else if(i==7)
				v3[1]<=weight_v;
			else if(i==8)
				v3[2]<=weight_v;
	end
end
//---------------------------------------------------------------------
//   UX & WH
//---------------------------------------------------------------------
always @(*) begin
	if(i==7)begin
		u_1 = u1[0];
		u_2 = u1[1];
		u_3 = u1[2];
		x_1 = x1[0];
		x_2 = x1[1];
		x_3 = x1[2];
	end
	else if(i==8)begin
		u_1 = u2[0];
		u_2 = u2[1];
		u_3 = u2[2];
		x_1 = x1[0];
		x_2 = x1[1];
		x_3 = x1[2];
	end
	else if(i==9)begin
		u_1 = u3[0];
		u_2 = u3[1];
		u_3 = u3[2];
		x_1 = x1[0];
		x_2 = x1[1];
		x_3 = x1[2];
	end
	else if(j==1)begin
		u_1 = u1[0];
		u_2 = u1[1];
		u_3 = u1[2];
		x_1 = x2[0];
		x_2 = x2[1];
		x_3 = x2[2];
	end
	else if(j==2)begin
		u_1 = u2[0];
		u_2 = u2[1];
		u_3 = u2[2];
		x_1 = x2[0];
		x_2 = x2[1];
		x_3 = x2[2];
	end
	else if(j==3)begin
		u_1 = u3[0];
		u_2 = u3[1];
		u_3 = u3[2];
		x_1 = x2[0];
		x_2 = x2[1];
		x_3 = x2[2];
	end
	else if(j==4)begin
		u_1 = u1[0];
		u_2 = u1[1];
		u_3 = u1[2];
		x_1 = x3[0];
		x_2 = x3[1];
		x_3 = x3[2];
	end
	else if(j==5)begin
		u_1 = u2[0];
		u_2 = u2[1];
		u_3 = u2[2];
		x_1 = x3[0];
		x_2 = x3[1];
		x_3 = x3[2];
	end
	else if(j==6)begin
		u_1 = u3[0];
		u_2 = u3[1];
		u_3 = u3[2];
		x_1 = x3[0];
		x_2 = x3[1];
		x_3 = x3[2];
	end
	else begin
		u_1 = 0;
		u_2 = 0;
		u_3 = 0;
		x_1 = 0;
		x_2 = 0;
		x_3 = 0;
	end
end
dp_3 dot_pro_UX(.a11(u_1),.a12(u_2),.a13(u_3),.x1(x_1),.x2(x_2),.x3(x_3),.out(y));



always @(*) begin
	if(i==7)begin
		w_1 = w1[0];
		w_2 = w1[1];
		w_3 = w1[2];
		h_1 = 0;
		h_2 = 0;
		h_3 = 0;
	end
	else if(i==8)begin
		w_1 = w2[0];
		w_2 = w2[1];
		w_3 = w2[2];
		h_1 = 0;
		h_2 = 0;
		h_3 = 0;
	end
	else if(i==9)begin
		w_1 = w3[0];
		w_2 = w3[1];
		w_3 = w3[2];
		h_1 = 0;
		h_2 = 0;
		h_3 = 0;
	end
	else if(j==2)begin
		w_1 = w1[0];
		w_2 = w1[1];
		w_3 = w1[2];
		h_1 = h[0];
		h_2 = h[1];
		h_3 = h[2];
	end
	else if(j==3)begin
		w_1 = w2[0];
		w_2 = w2[1];
		w_3 = w2[2];

		h_1 = h[0];
		h_2 = h[1];
		h_3 = h[2];
	end
	else if(j==4)begin
		w_1 = w3[0];
		w_2 = w3[1];
		w_3 = w3[2];
		h_1 = h[0];
		h_2 = h[1];
		h_3 = h[2];
	end
	else if(j==6)begin
		w_1 = w1[0];
		w_2 = w1[1];
		w_3 = w1[2];
		h_1 = h2[0];
		h_2 = h2[1];
		h_3 = h2[2];
	end
	else if(j==7)begin
		w_1 = w2[0];
		w_2 = w2[1];
		w_3 = w2[2];
		h_1 = h2[0];
		h_2 = h2[1];
		h_3 = h2[2];
	end
	else if(j==8)begin
		w_1 = w3[0];
		w_2 = w3[1];
		w_3 = w3[2];
		h_1 = h2[0];
		h_2 = h2[1];
		h_3 = h2[2];
	end
	else begin
		w_1 = 0;
		w_2 = 0;
		w_3 = 0;
		h_1 = 0;
		h_2 = 0;
		h_3 = 0;
	end
end
dp_3 dot_pro_Wh(.a11(w_1),.a12(w_2),.a13(w_3),.x1(h_1),.x2(h_2),.x3(h_3),.out(y_h));
// V dot H
always @(*) begin
	if(j==2)begin
		v_1 = v1[0];
		v_2 = v1[1];
		v_3 = v1[2];
		h_1_reg = h[0];
		h_2_reg = h[1];
		h_3_reg = h[2];
	end
	else if(j==3)begin
		v_1 = v2[0];
		v_2 = v2[1];
		v_3 = v2[2];
		h_1_reg = h[0];
		h_2_reg = h[1];
		h_3_reg = h[2];
	end
	else if(j==4)begin
		v_1 = v3[0];
		v_2 = v3[1];
		v_3 = v3[2];
		h_1_reg = h[0];
		h_2_reg = h[1];
		h_3_reg = h[2];
	end
	else if(j==6)begin
		v_1 = v1[0];
		v_2 = v1[1];
		v_3 = v1[2];
		h_1_reg = h2[0];
		h_2_reg = h2[1];
		h_3_reg = h2[2];
	end
	else if(j==7)begin
		v_1 = v2[0];
		v_2 = v2[1];
		v_3 = v2[2];

		h_1_reg = h2[0];
		h_2_reg = h2[1];
		h_3_reg = h2[2];
	end
	else if(j==8)begin
		v_1 = v3[0];
		v_2 = v3[1];
		v_3 = v3[2];
		h_1_reg = h2[0];
		h_2_reg = h2[1];
		h_3_reg = h2[2];
	end
	else if(j==10)begin
		v_1 = v1[0];
		v_2 = v1[1];
		v_3 = v1[2];
		h_1_reg = h3[0];
		h_2_reg = h3[1];
		h_3_reg = h3[2];
	end
	else if(j==11)begin
		v_1 = v2[0];
		v_2 = v2[1];
		v_3 = v2[2];
		h_1_reg = h3[0];
		h_2_reg = h3[1];
		h_3_reg = h3[2];
	end
	else if(j==12)begin
		v_1 = v3[0];
		v_2 = v3[1];
		v_3 = v3[2];
		h_1_reg = h3[0];
		h_2_reg = h3[1];
		h_3_reg = h3[2];
	end
	else begin
		v_1 = 0;
		v_2 = 0;
		v_3 = 0;
		h_1_reg = 0;
		h_2_reg = 0;
		h_3_reg = 0;
		
		
	end
end
dp_3 dot_pro_VH(.a11(v_1),.a12(v_2),.a13(v_3),.x1(h_1_reg),.x2(h_2_reg),.x3(h_3_reg),.out(y_ans));
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		// reset
		WH_product <= 0 ;

	end
	else begin
		WH_product <= y_h ;
	end
end
always @(*) begin
	if (i==8) begin 
		UX_product_add_wire = UX_product; //u1*x1
	end
	else if(i==9)begin
		UX_product_add_wire = UX_product;
	end
	else if(j==1)begin
		UX_product_add_wire = UX_product;
	end
	
	else if(j==3)begin
		UX_product_add_wire = UX_product_delay;
	end
	else if(j==4)begin
		UX_product_add_wire = UX_product_delay;
	end
	else if(j==5)begin
		UX_product_add_wire = UX_product_delay;
	end
	else if(j==7)begin
		UX_product_add_wire = x3_temp[0];
	end
	else if(j==8)begin
		UX_product_add_wire = x3_temp[1];
	end
	else if(j==9)begin
		UX_product_add_wire = x3_temp[2];
	end
	else begin
		UX_product_add_wire = 0;
	end
end

add_fp_WH_UX wh_add_ux(WH_product,UX_product_add_wire,wh_ux_add);
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		// reset
		wh_ux_add_reg <= 0 ;

	end
	else begin
		wh_ux_add_reg <= wh_ux_add ;
	end
end
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		// reset
		UX_product <= 0 ;

	end
	else begin
		UX_product <= y ;
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		// reset
		UX_product_delay <= 0 ;

	end
	else begin
		UX_product_delay <= UX_product ;
	end
end
always @(posedge clk) begin 
	if(cstate == IDLE)begin
		x3_temp[0] <= 0;
		x3_temp[1] <= 0;
		x3_temp[2] <= 0;
	end
	else if(j==5)begin
		x3_temp[0] <= UX_product;
	end
	else if(j==6)begin
		x3_temp[1] <= UX_product;
	end
	else if(j==7)begin
		x3_temp[2] <= UX_product;
	end

end
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		// reset
		yout_delay <= 0 ;

	end
	else begin
		yout_delay <= y_ans ;
	end
end
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		// reset
		yout <= 0 ;

	end
	else begin
		yout <= yout_delay;
	end
end
always @(*) begin
	if (i==8) begin 
		UX_product_wire = UX_product; //u1*x1
	end
	else if(i==9)begin
		UX_product_wire = UX_product;
	end
	else if(j==1)begin
		UX_product_wire = UX_product;
	end
	else if(j==2)begin
		UX_product_wire = wh_ux_add;
	end
	else if(j==3)begin
		UX_product_wire = wh_ux_add;
	end
	else if(j==4)begin
		UX_product_wire = wh_ux_add;
	end
	else if(j==5)begin
		UX_product_wire = wh_ux_add;
	end
	else if(j==7)begin
		UX_product_wire = wh_ux_add;
	end
	else if(j==8)begin
		UX_product_wire = wh_ux_add;
	end
	else if(j==9)begin
		UX_product_wire = wh_ux_add;
	end
	else begin
		UX_product_wire = 0;
	end
end

sigm signmod(UX_product_wire,sigmoid);
always @(posedge clk) begin
	if(cstate == IDLE)begin
		h[0] <= 0 ;
		h[1] <= 0 ;
		h[2] <= 0 ;
	end
	else if(i==8)begin
		h[0] <= sigmoid ;
	end
	else if(i==9)begin
		h[1] <= sigmoid ;
	end
	else if(j==1)begin
		h[2] <= sigmoid ;
	end
end
always @(posedge clk) begin
	if(cstate == IDLE)begin
		h2[0] <= 0 ;
		h2[1] <= 0 ;
		h2[2] <= 0 ;
	end
	else if(j==3)begin
		h2[0] <= sigmoid ;
	end
	else if(j==4)begin
		h2[1] <= sigmoid ;
	end
	else if(j==5)begin
		h2[2] <= sigmoid ;
	end
end
always @(posedge clk) begin
	if(cstate == IDLE)begin
		h3[0] <= 0 ;
		h3[1] <= 0 ;
		h3[2] <= 0 ;
	end
	else if(j==7)begin
		h3[0] <= sigmoid ;
	end
	else if(j==8)begin
		h3[1] <= sigmoid ;
	end
	else if(j==9)begin
		h3[2] <= sigmoid ;
	end
end
always @(posedge clk) begin
	if (nstate == IDLE) begin
		j <= 0 ;
	end
	else if (nstate == CAL) begin
		j <= j+1 ;
	end
	else if(nstate == OUTPUT_1)
		j<=j+1;
	
end
always @(posedge clk) begin
	if(in_valid_u) begin
		i <= i+1 ;
	end
	else if(cstate == OUTPUT_1)begin
		i <= i+1 ;
	end
	else begin
		i<=0;
	end
	
end


always@(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        out_valid <= 0; /* remember to reset */
        end
    
    else if(cstate == OUTPUT_1)begin
        out_valid<=1;
    end
    else
    	out_valid<=0;
    
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
        out <= 0; /* remember to reset */

    
    else if(cstate == OUTPUT_1) begin
    	case (j)
			4: out <=  (yout[31])?0:yout;
			5: out <=  (yout[31])?0:yout;
			6: out <=  (yout[31])?0:yout;
			7: out <=  (yout_delay[31])?0:yout_delay;
			8: out <=  (yout_delay[31])?0:yout_delay;
			9: out <=  (yout_delay[31])?0:yout_delay;
			10: out <= (y_ans[31])?0:y_ans;
			11: out <= (y_ans[31])?0:y_ans;
			12: out <= (y_ans[31])?0:y_ans;
			default: out <= 0;
    	endcase
    end
    else
    	out<=0;
end 
endmodule
module dp_3(a11,a12,a13,x1,x2,x3,out);
// IEEE floating point paramenters
parameter inst_sig_width = 23;
parameter inst_exp_width = 8;
parameter inst_ieee_compliance = 0;
parameter inst_arch = 2;
input [inst_sig_width+inst_exp_width:0]a11,a12,a13,x1,x2,x3;
output [inst_sig_width+inst_exp_width:0]out;

//wire[31:0]ot0,ot1,ot2,ot12;
// a*b + c*d + e*d
DW_fp_dp3  #(inst_sig_width, inst_exp_width, inst_ieee_compliance) U01 ( .a(a11), .b(x1),  .c(a12), .d(x2), .e(a13), .f(x3), .rnd(3'b000), .z(out) );  //59050
//DW_fp_dp3  #(inst_sig_width, inst_exp_width, inst_ieee_compliance) U02 ( .a(a21), .b(x1),  .c(a22), .d(x2), .e(a23), .f(x3), .rnd(3'b000), .z(h1) );  //59050
//DW_fp_dp3  #(inst_sig_width, inst_exp_width, inst_ieee_compliance) U03 ( .a(a31), .b(x1),  .c(a32), .d(x2), .e(a33), .f(x3), .rnd(3'b000), .z(h2) );  //59050
//DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) mul1    ( .a(a11), .b(x1), .rnd(3'b000), .z(ot0) ); 
//DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) mul2    ( .a(a12), .b(x2), .rnd(3'b000), .z(ot1) ); 
//DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) mul3    ( .a(a13), .b(x3), .rnd(3'b000), .z(ot2) ); 
////DW_fp_sum3 #(inst_sig_width, inst_exp_width, inst_ieee_compliance) U04 ( .a(ot0), .b(ot2),  .c(ot3), .rnd(3'b000), .z(ot1) );   // 35070
//DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance)  add1    ( .a(ot0),  .b(ot1),  .rnd(3'b000),  .z(ot12) );
//DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance)  add2    ( .a(ot12),  .b(ot2),  .rnd(3'b000),  .z(out) ); //19645
////assign ot1 = ot0+ot2+ot3; // 7291


endmodule


module sigm(x1,h1);

parameter inst_sig_width = 23;
parameter inst_exp_width = 8;
parameter inst_ieee_compliance = 0;
parameter inst_arch = 2;
parameter one =32'b00111111100000000000000000000000;
wire [31:0]exp_h10_x,sigmod0,sigmod_0,x1_x;
input [inst_sig_width+inst_exp_width:0]x1;
output [inst_sig_width+inst_exp_width:0]h1;

assign x1_x = {!x1[31],x1[30:0]};
DW_fp_exp #(inst_sig_width, inst_exp_width, inst_ieee_compliance,0)  exp1    ( .a(x1_x), .z(exp_h10_x));
DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance)  add1    ( .a(one),  .b(exp_h10_x),  .rnd(3'b000),  .z(sigmod_0) );
// 1 / 1 + e^-x
DW_fp_recip #(inst_sig_width, inst_exp_width, inst_ieee_compliance) recip1 ( .a(sigmod_0),  .rnd(3'b000),  .z(h1) ); //h11


endmodule

module add_fp_WH_UX(w,u,h);
parameter inst_sig_width = 23;
parameter inst_exp_width = 8;
parameter inst_ieee_compliance = 0;
parameter inst_arch = 2;
input [inst_sig_width+inst_exp_width:0]w,u;
output [inst_sig_width+inst_exp_width:0]h;


DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance)  addw1    ( .a(w),  .b(u),  .rnd(3'b000),  .z(h) );
endmodule