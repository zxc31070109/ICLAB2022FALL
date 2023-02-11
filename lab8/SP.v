// synopsys translate_off 
`ifdef RTL
`include "GATED_OR.v"
`else
`include "Netlist/GATED_OR_SYN.v"
`endif
// synopsys translate_on

module SP(
	// Input signals
	clk,
	rst_n,
	cg_en,
	in_valid,
	in_data,
	in_mode,
	// Output signals
	out_valid,
	out_data
);

// INPUT AND OUTPUT DECLARATION  
input		clk;
input		rst_n;
input		in_valid;
input		cg_en;
input [8:0] in_data;
input [2:0] in_mode;

output reg 		  out_valid;
output reg signed[9:0] out_data;





//---------------------------------------------------------------------
//   Reg & Wire
//---------------------------------------------------------------------
reg [9:0]data0;
reg signed[9:0]data[0:8];
reg [2:0]mode;
reg signed[9:0] max,min,max_1;
wire signed[9:0]sort_data[0:8];
reg signed[9:0]ans_max,ans_mid,ans_min;
reg signed[9:0]data_addsub[0:8];
reg signed[9:0]data_sma[0:8];

genvar j;
wire signed [9:0]half_diff, mid_point,temp_add;

reg signed[9:0]A;
reg signed[9:0]B;
reg signed[9:0]C;
reg signed[9:0]D;
reg signed[9:0]E;
reg signed[9:0]F;
reg signed[9:0]G;
reg signed[9:0]H;
reg signed[9:0]I;
reg [3:0]i;
//***********************************			  
// parameter	  
//***********************************	  
parameter IDLE         =  4'd0;
parameter INPUT        =  4'd1;
parameter INPUT_NUM    =  4'd2; // gray code
parameter MODE1        =  4'd3; // add sub
parameter MODE2        =  4'd4; // sma
parameter MODE3        =  4'd5; // find max mid min
parameter OUT_MAX      =  4'd6;
parameter OUT_MID      =  4'd7;
parameter OUT_MIN      =  4'd8;
parameter DELAY      =  4'd9;
//****************************************
//Reg Daclaration		  
//****************************************
reg [3:0]cstate;
reg [3:0]nstate;			  			  
	    

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
		nstate = (in_valid)? INPUT:IDLE; 
		
	INPUT:
		nstate = INPUT_NUM;	  
		
	INPUT_NUM:
		nstate = (!in_valid)?(mode==0)?MODE3:MODE1:INPUT_NUM;
	
	MODE1:
		nstate = (mode[1])?MODE2:MODE3;
	MODE2:
		nstate = (mode[2])?MODE3:DELAY;
	MODE3:
		nstate = DELAY;
	DELAY:
		nstate = OUT_MAX;
	OUT_MAX:
		nstate = OUT_MID;
	OUT_MID	:
		nstate = OUT_MIN;
	OUT_MIN	:
		nstate = IDLE;
	default: nstate = IDLE;		 
	endcase

end
//---------------------------------------------------------------------
//   Clock gating logic
//---------------------------------------------------------------------
wire G_clock,G_clock_sma;
wire G_sleep_addsub = (cg_en)?!(cstate == MODE1 || cstate == MODE2 || cstate == MODE3 || cstate == DELAY || i==7 || i==8):0;  //addsub

reg G_sleep_r;
GATED_OR GATED_addsub (
	.CLOCK( clk ),
	.SLEEP_CTRL( G_sleep_addsub ),	// gated clock
	.RST_N( rst_n ),
	.CLOCK_GATED( G_clock )
);




//---------------------------------------------------------------------
//   Design
//---------------------------------------------------------------------
wire [8:0]gray;
wire [7:0]gray_trans;
assign gray = ((nstate==INPUT_NUM && mode[0]==1) || (nstate == INPUT && in_mode[0]==1))?((in_data[8])?{in_data[8],~(gray_trans)+1}:{in_data[8],(gray_trans)}): in_data;

assign gray_trans = {
in_data[7],
in_data[6]^in_data[7],
in_data[5]^in_data[6]^in_data[7],
in_data[4]^in_data[5]^in_data[6]^in_data[7],
in_data[3]^in_data[4]^in_data[5]^in_data[6]^in_data[7],
in_data[2]^in_data[3]^in_data[4]^in_data[5]^in_data[6]^in_data[7],
in_data[1]^in_data[2]^in_data[3]^in_data[4]^in_data[5]^in_data[6]^in_data[7],
in_data[0]^in_data[1]^in_data[2]^in_data[3]^in_data[4]^in_data[5]^in_data[6]^in_data[7]};
//---------------------------------------------------------------------
//   Mode [1]
//---------------------------------------------------------------------
always @(posedge G_clock or negedge rst_n) begin : proc_max
	if(~rst_n) begin
		max <= 0;
	end else begin
		//if(nstate == IDLE)
		//	max <= 0;
		//else if(nstate == MODE1)
			max <= sort_data[0];
	end
end
always @(posedge G_clock or negedge rst_n) begin 
	if(~rst_n) begin
		min <= 0;
	end else begin
		//if(nstate == IDLE)
		//	min <= 0;
		//else if(nstate == MODE1)
			min <= sort_data[8];
	end
end
assign temp_add = max + min;
assign half_diff = (max - min) >>> 1;
assign mid_point = (temp_add[9] && temp_add[0])? (temp_add>>>1)+1 :temp_add>>>1;
//assign mid_point = (mid_point_temp<0)?mid_point_temp+1 :mid_point_temp;
generate
	for(j=0;j<9;j=j+1)begin
		always @(posedge G_clock or negedge rst_n) begin
		if(~rst_n) begin
			data_addsub[j] <= 0;
		end else begin
			data_addsub[j] <= (data[j] > mid_point)? data[j]-half_diff:(data[j] == mid_point)?data[j]:data[j]+half_diff;
		end
	end
end
endgenerate
always @(*) begin 
	if(cstate == INPUT_NUM && i==7)begin
		A= data[8];
		B= data[7];
		C= data[6];
		D= data[5];
		E= data[4];
		F= data[3];
		G= data[2];
		H= data[1];
		I= data[0];
	end
	else if(cstate == MODE2 && mode[1])begin
		A= data_addsub[8];
		B= data_addsub[7];
		C= data_addsub[6];
		D= data_addsub[5];
		E= data_addsub[4];
		F= data_addsub[3];
		G= data_addsub[2];
		H= data_addsub[1];
		I= data_addsub[0];
	end
	else if(cstate == MODE2 && !mode[2])begin
		A= data[8];
		B= data[7];
		C= data[6];
		D= data[5];
		E= data[4];
		F= data[3];
		G= data[2];
		H= data[1];
		I= data[0];
	end
	else if(cstate == MODE3 && mode[2])begin //100
		A= data_sma[8];
		B= data_sma[7];
		C= data_sma[6];
		D= data_sma[5];
		E= data_sma[4];
		F= data_sma[3];
		G= data_sma[2];
		H= data_sma[1];
		I= data_sma[0];
	end
	else if(cstate == MODE3 && mode[1])begin
		A= data_addsub[8];
		B= data_addsub[7];
		C= data_addsub[6];
		D= data_addsub[5];
		E= data_addsub[4];
		F= data_addsub[3];
		G= data_addsub[2];
		H= data_addsub[1];
		I= data_addsub[0];
	end
	else if(cstate == MODE3 && !mode[2])begin
		A= data[8];
		B= data[7];
		C= data[6];
		D= data[5];
		E= data[4];
		F= data[3];
		G= data[2];
		H= data[1];
		I= data[0];
	end
	
	else begin
		A= 0;
		B= 0;
		C= 0;
		D= 0;
		E= 0;
		F= 0;
		G= 0;
		H= 0;
		I= 0;
	end
end
median_filter findmid(.A(A),.B(B),.C(C),.D(D),.E(E),.F(F),.G(G),.H(H),.I(I), .max(sort_data[0]),.mid(sort_data[4]),.min(sort_data[8]));


//---------------------------------------------------------------------
//   Mode [2]
//---------------------------------------------------------------------
generate
	for(j=0;j<9;j=j+1)begin
		always @(posedge G_clock or negedge rst_n) begin
		if(~rst_n) begin
			data_sma[j] <= 0;
		end else begin
			
			
			if(mode[1] && mode[2])begin
					
						if(j==0)
							data_sma[j]  <=  (data_addsub[8] + data_addsub[0] + data_addsub[1]) / 3;
						else if(j==8)
							data_sma[j]  <=  (data_addsub[8] + data_addsub[7] + data_addsub[0]) / 3;
						else 
							data_sma[j]  <=  (data_addsub[j-1] + data_addsub[j] + data_addsub[j+1]) / 3;
					
					
			end
			else if( mode[2])begin
					
						if(j==0)
							data_sma[j]  <=  (data[8] + data[0] + data[1]) / 3;
						else if(j==8)
							data_sma[j]  <=  (data[8] + data[7] + data[0]) / 3;
						else 
							data_sma[j]  <=  (data[j-1] + data[j] + data[j+1]) / 3;
					
				end

			
			
		end
	end
end
endgenerate
//---------------------------------------------------------------------
//   MAX MID MIN
//---------------------------------------------------------------------
always @(posedge G_clock or negedge rst_n) begin 
	if(~rst_n) begin
		ans_mid <= 0;
		ans_min <= 0;
	end else begin
		if(nstate ==  DELAY) begin
			ans_mid <= sort_data[4];
			ans_min <= sort_data[8];
		end
			
	end
end
//---------------------------------------------------------------------
//   Input Logic
//---------------------------------------------------------------------
always @(posedge clk or negedge rst_n) begin : proc_mode
	if(~rst_n) begin
		mode <= 0;
	end else begin
		if(nstate ==  INPUT)
			mode <= in_mode;
	end
end


generate
	for(j=0;j<9;j=j+1)begin
		always @(posedge clk or negedge rst_n) begin 
			if(~rst_n) begin
				data[j] <= 0;
			end else if(nstate ==  INPUT || nstate == INPUT_NUM)begin
				if(j==0)
					data[j] <= {gray[8],gray};
				else 
					data[j] <= data[j-1];
			end
			else if(cstate == IDLE)begin
				data[j] <= 0;
			end
		end
	end
endgenerate
always @(posedge clk or negedge rst_n) begin : proc_i
	if(~rst_n) begin
		i <= 0;
	end else begin
		if(cstate == INPUT_NUM)
			i <= i+1;
		else 
			i <= 0;
	end
end
//---------------------------------------------------------------------
//   Output Logic
//---------------------------------------------------------------------
always @(posedge clk or negedge rst_n) begin : proc_out_valid
	if(~rst_n) begin
		out_valid <= 0;
	end else begin
		if(nstate == OUT_MAX)
			out_valid <=1;
		else if(nstate == OUT_MID )
			out_valid <=1;
		else if(nstate == OUT_MIN)
			out_valid <=1;
		else 
			out_valid <= 0;
	end
end
always @(posedge clk or negedge rst_n) begin : proc_ans_max
	if(~rst_n) begin
		ans_max <= 0;
	end else begin
		if(cstate == MODE1 || cstate == MODE2 || cstate == MODE3 || i ==7)
		ans_max <= sort_data[0];
	end
end
always @(*) begin 
	if(~rst_n) begin
		out_data = 0;
	end else begin
		if(cstate == OUT_MAX)
			out_data = ans_max;
		else if(cstate == OUT_MID )
			out_data = ans_mid;
		else if(cstate == OUT_MIN)
			out_data = ans_min;
		else 
			out_data = 0;
	end
end
endmodule
/*
module sort_9 (
	input signed[9:0]A,
	input signed[9:0]B,
	input signed[9:0]C,
	input signed[9:0]D,
	input signed[9:0]E,
	input signed[9:0]F,
	input signed[9:0]G,
	input signed[9:0]H,
	input signed[9:0]I,    // Clock
	//input en,
	output signed[9:0]Ao,
	output signed[9:0]Bo,
	output signed[9:0]Co,
	output signed[9:0]Do,
	output signed[9:0]Eo,
	output signed[9:0]Fo,
	output signed[9:0]Go,
	output signed[9:0]Ho,
	output signed[9:0]Io  
);
wire signed[9:0]line[0:7][0:8];

assign line[0][0] =  (A>=B)?A:B ;
assign line[0][1] =  (A>=B)?B:A ;
assign line[0][2] =  (C>=D)?C:D ;
assign line[0][3] =  (C>=D)?D:C ;
assign line[0][4] =  (E>=F)?E:F ;
assign line[0][5] =  (E>=F)?F:E ;
assign line[0][6] =  (G>=H)?G:H ;
assign line[0][7] =  (G>=H)?H:G ;
assign line[0][8] =  I ;
assign line[1][0] =  line[0][0] ;
assign line[1][1] =  (line[0][1]>=line[0][2])?line[0][1]:line[0][2] ;
assign line[1][2] =  (line[0][1]>=line[0][2])?line[0][2]:line[0][1] ;
assign line[1][3] =  (line[0][3]>=line[0][4])?line[0][3]:line[0][4] ;
assign line[1][4] =  (line[0][3]>=line[0][4])?line[0][4]:line[0][3] ;
assign line[1][5] =  (line[0][5]>=line[0][6])?line[0][5]:line[0][6] ;
assign line[1][6] =  (line[0][5]>=line[0][6])?line[0][6]:line[0][5] ;
assign line[1][7] =  (line[0][7]>=line[0][8])?line[0][7]:line[0][8] ;
assign line[1][8] =  (line[0][7]>=line[0][8])?line[0][8]:line[0][7] ;
assign line[2][0] =  (line[1][0]>=line[1][1])?line[1][0]:line[1][1] ;
assign line[2][1] =  (line[1][0]>=line[1][1])?line[1][1]:line[1][0] ;
assign line[2][2] =  (line[1][2]>=line[1][3])?line[1][2]:line[1][3] ;
assign line[2][3] =  (line[1][2]>=line[1][3])?line[1][3]:line[1][2] ;
assign line[2][4] =  (line[1][4]>=line[1][5])?line[1][4]:line[1][5] ;
assign line[2][5] =  (line[1][4]>=line[1][5])?line[1][5]:line[1][4] ;
assign line[2][6] =  (line[1][6]>=line[1][7])?line[1][6]:line[1][7] ;
assign line[2][7] =  (line[1][6]>=line[1][7])?line[1][7]:line[1][6] ;
assign line[2][8] =  line[1][8] ;
assign line[3][0] =  line[2][0] ;
assign line[3][1] =  (line[2][1]>=line[2][2])?line[2][1]:line[2][2] ;
assign line[3][2] =  (line[2][1]>=line[2][2])?line[2][2]:line[2][1] ;
assign line[3][3] =  (line[2][3]>=line[2][4])?line[2][3]:line[2][4] ;
assign line[3][4] =  (line[2][3]>=line[2][4])?line[2][4]:line[2][3] ;
assign line[3][5] =  (line[2][5]>=line[2][6])?line[2][5]:line[2][6] ;
assign line[3][6] =  (line[2][5]>=line[2][6])?line[2][6]:line[2][5] ;
assign line[3][7] =  (line[2][7]>=line[2][8])?line[2][7]:line[2][8] ;
assign line[3][8] =  (line[2][7]>=line[2][8])?line[2][8]:line[2][7] ;
assign line[4][0] =  (line[3][0]>=line[3][1])?line[3][0]:line[3][1] ;
assign line[4][1] =  (line[3][0]>=line[3][1])?line[3][1]:line[3][0] ;
assign line[4][2] =  (line[3][2]>=line[3][3])?line[3][2]:line[3][3] ;
assign line[4][3] =  (line[3][2]>=line[3][3])?line[3][3]:line[3][2] ;
assign line[4][4] =  (line[3][4]>=line[3][5])?line[3][4]:line[3][5] ;
assign line[4][5] =  (line[3][4]>=line[3][5])?line[3][5]:line[3][4] ;
assign line[4][6] =  (line[3][6]>=line[3][7])?line[3][6]:line[3][7] ;
assign line[4][7] =  (line[3][6]>=line[3][7])?line[3][7]:line[3][6] ;
assign line[4][8] =  line[3][8] ;
assign line[5][0] =  line[4][0] ;
assign line[5][1] =  (line[4][1]>=line[4][2])?line[4][1]:line[4][2] ;
assign line[5][2] =  (line[4][1]>=line[4][2])?line[4][2]:line[4][1] ;
assign line[5][3] =  (line[4][3]>=line[4][4])?line[4][3]:line[4][4] ;
assign line[5][4] =  (line[4][3]>=line[4][4])?line[4][4]:line[4][3] ;
assign line[5][5] =  (line[4][5]>=line[4][6])?line[4][5]:line[4][6] ;
assign line[5][6] =  (line[4][5]>=line[4][6])?line[4][6]:line[4][5] ;
assign line[5][7] =  (line[4][7]>=line[4][8])?line[4][7]:line[4][8] ;
assign line[5][8] =  (line[4][7]>=line[4][8])?line[4][8]:line[4][7] ;
assign line[6][0] =  (line[5][0]>=line[5][1])?line[5][0]:line[5][1] ;
assign line[6][1] =  (line[5][0]>=line[5][1])?line[5][1]:line[5][0] ;
assign line[6][2] =  (line[5][2]>=line[5][3])?line[5][2]:line[5][3] ;
assign line[6][3] =  (line[5][2]>=line[5][3])?line[5][3]:line[5][2] ;
assign line[6][4] =  (line[5][4]>=line[5][5])?line[5][4]:line[5][5] ;
assign line[6][5] =  (line[5][4]>=line[5][5])?line[5][5]:line[5][4] ;
assign line[6][6] =  (line[5][6]>=line[5][7])?line[5][6]:line[5][7] ;
assign line[6][7] =  (line[5][6]>=line[5][7])?line[5][7]:line[5][6] ;
assign line[6][8] =  line[5][8] ;
assign line[7][0] =  line[6][0] ;
assign line[7][1] =  (line[6][1]>=line[6][2])?line[6][1]:line[6][2] ;
assign line[7][2] =  (line[6][1]>=line[6][2])?line[6][2]:line[6][1] ;
assign line[7][3] =  (line[6][3]>=line[6][4])?line[6][3]:line[6][4] ;
assign line[7][4] =  (line[6][3]>=line[6][4])?line[6][4]:line[6][3] ;
assign line[7][5] =  (line[6][5]>=line[6][6])?line[6][5]:line[6][6] ;
assign line[7][6] =  (line[6][5]>=line[6][6])?line[6][6]:line[6][5] ;
assign line[7][7] =  (line[6][7]>=line[6][8])?line[6][7]:line[6][8] ;
assign line[7][8] =  (line[6][7]>=line[6][8])?line[6][8]:line[6][7] ;

assign Ao = (line[7][0]>=line[7][1])?line[7][0]:line[7][1] ;
assign Bo = (line[7][0]>=line[7][1])?line[7][1]:line[7][0] ;
assign Co = (line[7][2]>=line[7][3])?line[7][2]:line[7][3] ;
assign Do = (line[7][2]>=line[7][3])?line[7][3]:line[7][2] ;
assign Eo = (line[7][4]>=line[7][5])?line[7][4]:line[7][5] ;
assign Fo = (line[7][4]>=line[7][5])?line[7][5]:line[7][4] ;
assign Go = (line[7][6]>=line[7][7])?line[7][6]:line[7][7] ;
assign Ho = (line[7][6]>=line[7][7])?line[7][7]:line[7][6] ;
assign Io =  line[7][8];
endmodule 
*/
module CS_module (
	input signed[9:0]A,    // Clock
	input signed[9:0]B, // Clock Enable
	input signed[9:0]C,  // Asynchronous reset active low
	output reg signed[9:0]max,
	output reg signed[9:0]mid,
	output reg signed[9:0]min
	
);
assign CO1 = A>=B;
assign CO2 = A>=C;
assign CO3 = B>=C;

always @(*) begin 
	case({CO1,CO2,CO3})
		0: max = C;
		1: max = B;
		2: max = 0;
		3: max = B;
		4: max = C;
		5: max = 0;
		6: max = A;
		7: max = A;
	endcase
end

always @(*) begin 
	case({CO1,CO2,CO3})
		0: mid = B;
		1: mid = C;
		2: mid = 0;
		3: mid = A;
		4: mid = A;
		5: mid = 0;
		6: mid = C;
		7: mid = B;
	endcase
end

always @(*) begin 
	case({CO1,CO2,CO3})
		0: min = A;
		1: min = A;
		2: min = 0;
		3: min = C;
		4: min = B;
		5: min = 0;
		6: min = B;
		7: min = C;
	endcase
end
endmodule 

module median_filter (
	input signed[9:0]A,
	input signed[9:0]B,
	input signed[9:0]C,
	input signed[9:0]D,
	input signed[9:0]E,
	input signed[9:0]F,
	input signed[9:0]G,
	input signed[9:0]H,
	input signed[9:0]I, 
	output signed[9:0]max,
	output signed[9:0]mid,
	output signed[9:0]min
);
wire signed[9:0]w1_1,w1_2,w1_3;
wire signed[9:0]w2_1,w2_2,w2_3;
wire signed[9:0]w3_1,w3_2,w3_3;
wire signed[9:0]a,b,c;
CS_module CS1(.A(A),.B(B),.C(C),                  .max(w1_1),.mid(w1_2),.min(w1_3));
CS_module CS2(.A(D),.B(E),.C(F),                  .max(w2_1),.mid(w2_2),.min(w2_3));
CS_module CS3(.A(G),.B(H),.C(I),                  .max(w3_1),.mid(w3_2),.min(w3_3));
CS_module CS4(.A(w1_1),.B(w2_1),.C(w3_1),                  .max(max),.mid(),.min(a));
CS_module CS5(.A(w1_2),.B(w2_2),.C(w3_2),                  .max(),.mid(b),.min());
CS_module CS6(.A(w1_3),.B(w2_3),.C(w3_3),                  .max(c),.mid(),.min(min));
CS_module CS7(.A(a),.B(b),.C(c),                  .max(),.mid(mid),.min());
endmodule 