module FD(input clk, INF.FD_inf inf);
import usertype::*;
//		  input  rst_n,
//			   D, id_valid, act_valid, res_valid, cus_valid, food_valid,
//			   C_out_valid, C_data_r,
//        output out_valid, err_msg,  complete, out_info, 
//			   C_addr, C_data_w, C_in_valid, C_r_wb
//
//===========================================================================
// parameter 
//===========================================================================
typedef	enum	logic	[5:0]	{IDLE,INPUT,ACT,
								DEL,DEL_ID,DEL_ID_V,TAKE,TAKE_NEED,CUS,CAL,RES_INFO,CAL_FOOD,WRITE,WRITE_VALID,WRITE_RES,WRITE_RES_VALID,
								 OUT,OUTPUT
				                 ,ORDER,FOOD_INFO,RES_INFO_V,
				                 CANCEL,CANCEL_DEL,CANCEL_VALID,CANCEL_DEL_ID}	STATE;
STATE cstate;
STATE nstate;
//===========================================================================
// logic 
//===========================================================================
Action action;
Delivery_man_id id,id_ns;
DATA act,act_ns;
DATA ctm,ctm_ns;
DATA res,res_ns;
DATA food_ser,food_ser_ns;
logic Deliver_busy_flag,d_man_b;
logic no_food_flag,no_custom;
logic [63:0]write,write_res,data;
logic [15:0] cus1_ans,cus2_ans;
logic [7:0]addr;
logic no_custom_r;
logic res_busy,res_busy_r,C_out;
logic w_cancel,w_res_id,w_food_id;
logic id_valid_flag;
logic [15:0]cus1_cancel,cus2_cancel;
//===========================================================================
// FSM
//===========================================================================
always_comb begin 
	case (cstate)
		IDLE:nstate =(inf.act_valid)? ACT:IDLE;
		INPUT: nstate = INPUT;
		ACT:begin
			if(act.d_act[0] == Deliver	)
				nstate = DEL;
			else if(act.d_act[0] == Take)
				nstate = TAKE;
			else if(act.d_act[0] == Order)
				nstate = ORDER;
			else if(act.d_act[0] == Cancel)
				nstate = CANCEL;
			else if(act.d_act[0] == No_action)
				nstate = IDLE;
			else 
				nstate = IDLE;
				
		end
		//delivery
		DEL: begin
			if(inf.id_valid)
				nstate = DEL_ID;
			else
				nstate = DEL;
		end
		DEL_ID: nstate = (C_out)?CAL:DEL_ID;
		//Take
		TAKE:begin
			if(inf.id_valid)
				nstate = DEL_ID;
			else if(inf.cus_valid)
				nstate = DEL_ID_V;
			else 
				nstate = TAKE;
			//TAKE CUS
		end
		DEL_ID_V:nstate = DEL_ID;
		CUS: nstate =  (C_out)?CAL:CUS;
		CAL: nstate = ((d_man_b &&act.d_act[0] == Take) || (no_custom_r&&act.d_act[0] ==Deliver))?OUT:(act.d_act[0] == Take)?RES_INFO:WRITE_VALID;
		RES_INFO: nstate =(no_food_flag&&(act.d_act[0] == Take))?OUT:((C_out)?((act.d_act[0]==Order)?FOOD_INFO:(act.d_act[0]==Cancel)?CANCEL_DEL:CAL_FOOD):RES_INFO);
		CAL_FOOD: nstate=WRITE_VALID;
		WRITE_VALID:nstate=WRITE;
		WRITE:nstate=(C_out)?(act.d_act[0] == Take)?WRITE_RES_VALID:OUTPUT:WRITE;
		WRITE_RES_VALID:nstate=WRITE_RES;
		WRITE_RES:nstate=(C_out)?OUTPUT:WRITE_RES;
		OUT: nstate = IDLE;
		OUTPUT: nstate = IDLE;

		//Order
		ORDER: begin
			if(inf.res_valid)
				nstate = RES_INFO;
			else if(inf.food_valid)
				nstate = RES_INFO_V;
			else 
				nstate = ORDER;
			//TAKE CUS
		end
		RES_INFO_V: nstate = RES_INFO;
		FOOD_INFO: nstate =(res_busy_r&&(act.d_act[0] == Order))?OUT:WRITE_VALID;

		//Cancel
		CANCEL:nstate = (inf.res_valid)?RES_INFO_V:CANCEL;
		CANCEL_DEL: nstate = (id_valid_flag)?CANCEL_VALID:CANCEL_DEL;
		CANCEL_VALID: nstate = CANCEL_DEL_ID;
		CANCEL_DEL_ID: nstate =(act.d_act[0] == Cancel && (w_cancel || w_res_id || w_food_id))?OUT:(C_out)?WRITE_VALID:CANCEL_DEL_ID;
		default : nstate = IDLE;
		
	endcase
end
always_ff@(posedge clk or negedge inf.rst_n)
begin
	if(!inf.rst_n) 
		cstate <= IDLE;
	else
		cstate <= nstate;
end
//===========================================================================
// Comb.
//===========================================================================
always_comb begin
	id_ns = (inf.id_valid)? inf.D.d_id[0]:0;
	act_ns = (inf.act_valid)? inf.D.d_act[0]:0;
	ctm_ns= (inf.cus_valid)? inf.D.d_ctm_info[0]:0;
	res_ns= (inf.res_valid)? inf.D.d_res_id[0]:0;
	food_ser_ns= (inf.food_valid)? inf.D.d_food_ID_ser[0]:0;
end
//===========================================================================
// FF
//===========================================================================
always_ff@(posedge clk or negedge inf.rst_n)
begin
 	if(~inf.rst_n)begin
 		id <= 0;
 	end
 	else begin
 		if(inf.id_valid)
 			id <= id_ns;
 	end
 end 
 always_ff@(posedge clk or negedge inf.rst_n)
begin
 	if(~inf.rst_n)begin
 		act <= 0;
 	end
 	else begin
 		if(inf.act_valid)
 			act <= act_ns;
 	end
 end
 always_ff@(posedge clk or negedge inf.rst_n)
begin
 	if(~inf.rst_n)begin
 		ctm <= 0;
 	end
 	else begin
 		if(inf.cus_valid)
 			ctm <= ctm_ns;
 	end
 end
 always_ff@(posedge clk or negedge inf.rst_n)
begin
 	if(~inf.rst_n)begin
 		food_ser <= 0;
 	end
 	else begin
 		if(inf.food_valid)
 			food_ser <= food_ser_ns;
 	end
 end
 always_ff@(posedge clk or negedge inf.rst_n)
begin
 	if(~inf.rst_n)begin
 		res <= 0;
 	end
 	else begin
 		if(inf.res_valid)
 			res <= res_ns;
 	end
 end

//===========================================================================
// AXI4-lite
//===========================================================================
always_ff@(posedge clk or negedge inf.rst_n) begin 
	if(~inf.rst_n)
		inf.C_in_valid <= 0;
	else if(nstate == DEL_ID)begin
		inf.C_in_valid <= inf.id_valid;	
	end
	else if(nstate == DEL_ID_V)
		inf.C_in_valid <= 1;	
	else if(nstate == RES_INFO_V)
		inf.C_in_valid <= 1;
	else if(nstate == RES_INFO && act.d_act[0] == Order)
		inf.C_in_valid <= inf.res_valid;
	else if(cstate == CAL&& act.d_act[0] == Take&& !no_food_flag && !d_man_b)
		inf.C_in_valid <= 1;

	else if (nstate == WRITE_VALID)
		inf.C_in_valid <= 1;
	else if(nstate == WRITE_RES_VALID)
		inf.C_in_valid <= 1;
	else if(nstate == CANCEL_VALID)
		inf.C_in_valid <= 1;
	else 
		inf.C_in_valid <= 0;
end
always_comb begin
	inf.C_r_wb = (nstate == WRITE_VALID || nstate == WRITE || nstate == WRITE_RES)?0:1;
	//inf.C_addr = (nstate == DEL_ID || nstate == WRITE)? (act.d_act[0]!=Order)?id.d_id[0]:res.d_res_id[0]:
	//(nstate == RES_INFO || nstate == WRITE_RES)?(act.d_act[0]!=Order)?ctm.d_ctm_info[0].res_ID:res.d_res_id[0]:0;
end
always_ff @(posedge clk or negedge inf.rst_n) begin 
	if(~inf.rst_n) begin
		inf.C_addr <= 0;
	end else begin
		inf.C_addr <= (nstate == DEL_ID || nstate == WRITE|| nstate == CANCEL_DEL_ID)? (act.d_act[0]!=Order)?id:res.d_res_id[0]:
					(nstate == RES_INFO || nstate == WRITE_RES )?(act.d_act[0]!=Order)?(act.d_act[0]==Cancel)?res.d_res_id[0]:ctm.d_ctm_info[0].res_ID:res.d_res_id[0]:0;
	end
end
//dram read data
logic [15:0]cus1,cus2;
logic [7:0]food_servings,food1,food2,food3;
logic [1:0]cus1_status,cus2_status;
logic [7:0]cus1_rest_id,cus2_rest_id;
logic [1:0]cus1_food_id,cus2_food_id;
logic [3:0]cus1_servings,cus2_servings;
//FF
//logic [15:0]cus1_r,cus2_r;
//logic [7:0]food_servings_r,food1_r,food2_r,food3_r;
//logic [1:0]cus1_status_r,cus2_status_r;
//logic [7:0]cus1_rest_id_r,cus2_rest_id_r;
//logic [1:0]cus1_food_id_r,cus2_food_id_r;
//logic [3:0]cus1_servings_r,cus2_servings_r;
assign cus1 = {data[39:32],data[47:40]};
assign cus2 = {data[55:48],data[63:56]};
assign food_servings = data[7:0];
assign food1 = data[15:8];
assign food2 = data[23:16];
assign food3 = data[31:24];

assign cus1_status   = cus1[15:14];
assign cus1_rest_id	 = cus1[13:6];
assign cus1_food_id  = cus1[5:4];
assign cus1_servings = cus1[3:0];

assign cus2_status   = cus2[15:14];
assign cus2_rest_id	 = cus2[13:6];
assign cus2_food_id  = cus2[5:4];
assign cus2_servings = cus2[3:0];
logic [15:0]cus1_ans_ns,cus2_ans_ns;
assign Deliver_busy_flag = (nstate == CAL)?((cus2_status!=0)?1:0):0;
always_ff @(posedge clk or negedge inf.rst_n) begin 
	if(~inf.rst_n) begin
		d_man_b <= 0;
	end else begin
		d_man_b <= Deliver_busy_flag;
	end
end

//Delivery
logic[15:0]cus1_del_ns,cus2_del_ns;
always_comb begin
	if(cus1 != 0)begin
		if(cus2 != 0)begin
			cus1_del_ns = cus2;
			cus2_del_ns = 0;
		end
		else begin
			cus1_del_ns = 0;
			cus2_del_ns = 0;
		end
	end
	else begin
		cus1_del_ns = 0;
		cus2_del_ns = 0;
	end
end
//Deliver but no customer
assign no_custom = (nstate == CAL && (!cus1) && (!cus2));

always_ff @(posedge clk or negedge inf.rst_n) begin : proc_no_custom_r
	if(~inf.rst_n) begin
		no_custom_r <= 0;
	end else begin
		if(cstate == IDLE)
			no_custom_r <= 0;
		else
			no_custom_r <= no_custom;
	end
end
//TAKE
always_comb begin
	if(cus1_status == 2'b01)begin
		if(ctm.d_ctm_info[0][15:14] == 2'b11)begin
			cus1_ans_ns = ctm.d_ctm_info[0];
			cus2_ans_ns = cus1;
		end
		else begin
			cus1_ans_ns = cus1;
			cus2_ans_ns = ctm.d_ctm_info[0];
		end
	end
	else if(cus1_status == 2'b00)begin
			cus1_ans_ns = ctm.d_ctm_info[0];
			cus2_ans_ns = cus2;
	end
	else begin
			cus1_ans_ns = cus1;
			cus2_ans_ns = ctm.d_ctm_info[0];
	end
end

always_ff @(posedge clk or negedge inf.rst_n) begin : proc_cus1_ans
	if(~inf.rst_n) begin
		cus1_ans <= 0;
		cus2_ans <= 0;
	end else begin
		if(nstate == CAL) begin
			if((act.d_act[0] == Take)) begin
				cus1_ans <= cus1_ans_ns;
				cus2_ans <= cus2_ans_ns;	
			end
			else if(act.d_act[0] == Deliver)begin
				cus1_ans <= cus1_del_ns;
				cus2_ans <= cus2_del_ns;
			end
		end
	end
end
//take no food
logic [31:0]res_ans;
logic [16:0]ser_food_ans;
logic [8:0]food1_ans,food2_ans,food3_ans;
logic [9:0]sum;
always_comb begin
	if(cstate == RES_INFO && C_out)begin
		if(act.d_act[0] ==Take) begin
			if(ctm.d_ctm_info[0].food_ID == FOOD1)begin
				food1_ans = food1 -ctm.d_ctm_info[0].ser_food;
				food2_ans = food2;
				food3_ans = food3;
			end
			else if(ctm.d_ctm_info[0].food_ID == FOOD2)begin
				food1_ans = food1;
				food2_ans = food2 -ctm.d_ctm_info[0].ser_food;
				food3_ans = food3;
			end
			else if(ctm.d_ctm_info[0].food_ID == FOOD3)begin
				food1_ans = food1;
				food2_ans = food2;
				food3_ans = food3-ctm.d_ctm_info[0].ser_food;
			end
			else begin
				food1_ans = food1;
				food2_ans = food2;
				food3_ans = food3;
			end
		end
		else begin
			if(food_ser.d_food_ID_ser[0].d_food_ID == FOOD1)begin
					food1_ans = food1 + food_ser.d_food_ID_ser[0].d_ser_food;
					food2_ans = food2;
					food3_ans = food3;
			end
			else if(food_ser.d_food_ID_ser[0].d_food_ID == FOOD2)begin
					food1_ans = food1;
					food2_ans = food2 + food_ser.d_food_ID_ser[0].d_ser_food;
					food3_ans = food3;
			end
			else if(food_ser.d_food_ID_ser[0].d_food_ID == FOOD3)begin
					food1_ans = food1;
					food2_ans = food2;
					food3_ans = food3 + food_ser.d_food_ID_ser[0].d_ser_food;
			end
			else begin
				food1_ans = food1;
				food2_ans = food2;
				food3_ans = food3;
			end
		end
	end
	else begin
		//ser_food_ans = food_servings;
		food1_ans = food1;
		food2_ans = food2;
		food3_ans = food3;
	end
end
assign no_food_flag = (cstate == RES_INFO  && food1_ans[8]  || food2_ans[8] || food3_ans[8])?1:0;
always_ff @(posedge clk or negedge inf.rst_n) begin : proc_write
	if(~inf.rst_n) begin
		write <= 0;
	end else begin
		if(nstate == CAL)begin
			if(act.d_act[0] ==Deliver)
				write <= {16'd0,cus1_del_ns[7:0],cus1_del_ns[15:8],food3[7:0],food2[7:0],food1[7:0],food_servings[7:0]};
			else if(act.d_act[0] == Take)
				write <= {cus2_ans_ns[7:0],cus2_ans_ns[15:8],cus1_ans_ns[7:0],cus1_ans_ns[15:8],food3[7:0],food2[7:0],food1[7:0],food_servings[7:0]}; //del,res
		end
		else if(nstate == FOOD_INFO)begin
				write <= {cus2[7:0],cus2[15:8],cus1[7:0],cus1[15:8],
				food3_ans[7:0],food2_ans[7:0],food1_ans[7:0],food_servings[7:0]};
		end
		else if(nstate == WRITE_VALID && act.d_act[0] == Cancel)begin
			write <= {cus2_cancel[7:0],cus2_cancel[15:8],cus1_cancel[7:0],cus1_cancel[15:8],food3_ans[7:0],food2_ans[7:0],food1_ans[7:0],food_servings[7:0]};
		end	
	end
end
always_ff @(posedge clk or negedge inf.rst_n) begin 
	if(~inf.rst_n) begin
		write_res <= 0;
	end else begin
		//if(nstate == CAL_FOOD && ctm.d_ctm_info[0].res_ID == id.d_id[0]) 
		//	write_res <= write;
		if(nstate == CAL_FOOD)
			if(ctm.d_ctm_info[0].res_ID == id)
				write_res <= {write[63:32],food3_ans[7:0],food2_ans[7:0],food1_ans[7:0],food_servings[7:0]};
			else
				write_res <= {cus2[7:0],cus2[15:8],cus1[7:0],cus1[15:8],food3_ans[7:0],food2_ans[7:0],food1_ans[7:0],food_servings[7:0]}; //del,res
	end
end
//assign inf.C_data_w = (nstate == WRITE)?write:write_res;
always_ff @(posedge clk or negedge inf.rst_n) begin
	if(~inf.rst_n) begin
		inf.C_data_w  <= 0;
	end else begin
		inf.C_data_w  <= (nstate == WRITE)?write:write_res;
	end
end
//order res busy
assign sum = food1_ans + food2_ans + food3_ans;
assign res_busy =(nstate == FOOD_INFO) && (sum > 256) || (sum > food_servings);
always_ff @(posedge clk or negedge inf.rst_n) begin
	if(~inf.rst_n) begin
		res_busy_r <= 0;
	end else begin
		if(cstate == IDLE)
			res_busy_r <= 0;
		else
			res_busy_r <= res_busy;
	end
end
always_ff @(posedge clk or negedge inf.rst_n) begin 
	if(~inf.rst_n) begin
		data <= 0;
	end else begin
		data <= (inf.C_out_valid)?inf.C_data_r:0;
	end
end
always_ff @(posedge clk or negedge inf.rst_n) begin 
	if(~inf.rst_n) begin
		C_out <= 0;
	end else begin
		C_out <= (inf.C_out_valid);
	end
end
//Cancel wrong cancel
assign w_cancel = ((cstate==CANCEL_DEL_ID) && (act.d_act[0]==Cancel)&& C_out && ((cus1_status==0)&&(cus2_status==0)));
assign w_res_id = ((cstate==CANCEL_DEL_ID) && (act.d_act[0]==Cancel)&& C_out && (!w_cancel) && ((cus1_rest_id != res.d_res_id[0])&&(cus2_rest_id != res.d_res_id[0] || cus2 == 0)));
assign w_food_id = ((cstate == CANCEL_DEL_ID) &&
 C_out && (!w_cancel) &&(!w_res_id)&&
  !(((cus1_rest_id == res.d_res_id[0]) &&(cus1_food_id == food_ser.d_food_ID_ser[0].d_food_ID)))&&
  !(((cus2_rest_id == res.d_res_id[0]) &&(cus2_food_id == food_ser.d_food_ID_ser[0].d_food_ID)))&&
  (((cus1_rest_id == res.d_res_id[0]) && (cus1_food_id != food_ser.d_food_ID_ser[0].d_food_ID)) || ((cus2!=0)&&(cus2_rest_id == res.d_res_id[0]) && (cus2_food_id != food_ser.d_food_ID_ser[0].d_food_ID)) ) 
  );
always_ff @(posedge clk or negedge inf.rst_n) begin 
	if(~inf.rst_n) begin
		id_valid_flag <= 0;
	end else begin
		if(cstate ==IDLE)
			id_valid_flag <= 0;
		else if(inf.id_valid)
			id_valid_flag <= 1;
	end
end

always_comb begin
	if(cstate == CANCEL_DEL_ID && C_out)begin
		if(res.d_res_id == cus1_rest_id && res.d_res_id == cus2_rest_id && cus1_food_id ==food_ser.d_food_ID_ser[0].d_food_ID && cus2_food_id == food_ser.d_food_ID_ser[0].d_food_ID)begin
			cus1_cancel = 0;
			cus2_cancel = 0;
		end

		else if(res.d_res_id == cus1_rest_id && cus1_food_id ==food_ser.d_food_ID_ser[0].d_food_ID)begin
			cus1_cancel = cus2;
			cus2_cancel = 0;
		end
		else if(res.d_res_id == cus2_rest_id && cus2_food_id == food_ser.d_food_ID_ser[0].d_food_ID)begin
			cus1_cancel = cus1;
			cus2_cancel = 0;
		end
		else begin
			cus1_cancel = cus1;
			cus2_cancel = cus2;
		end
	end
	else begin
		cus1_cancel = cus1;
		cus2_cancel = cus2;
	end
end
//===========================================================================
// Output
//===========================================================================
logic[3:0]err_msg_ns;
always_comb begin
	case (cstate)
		CAL: err_msg_ns = (d_man_b&&(act.d_act[0] == Take))? D_man_busy : (no_custom_r&&act.d_act[0] == Deliver)?No_customers: No_Err;
		RES_INFO: err_msg_ns = (no_food_flag)? No_Food: /*(w_cancel &&(act.d_act[0]==Cancel))?Wrong_cancel:*/No_Err;
		CANCEL_DEL_ID: err_msg_ns = (w_cancel &&(act.d_act[0]==Cancel))?Wrong_cancel:
							(w_res_id &&(act.d_act[0]==Cancel))?Wrong_res_ID:
							(w_food_id)?Wrong_food_ID:No_Err;
		FOOD_INFO: err_msg_ns = (res_busy_r)?Res_busy:No_Err;
		default : err_msg_ns = No_Err;
	endcase
end
always_ff@(posedge clk or negedge inf.rst_n) begin 
	if(~inf.rst_n) begin
		inf.err_msg   <= 0;
	end else begin
		inf.err_msg   <= err_msg_ns;
	end
end
always_ff@(posedge clk or negedge inf.rst_n) begin 
	if(~inf.rst_n) begin
		inf.out_valid <= 0;
	end else begin
		if(nstate == OUT || nstate == OUTPUT)
			inf.out_valid <= 1;
		else
			inf.out_valid <= 0;
	end
end
always_ff@(posedge clk or negedge inf.rst_n) begin 
	if(~inf.rst_n) begin
		inf.complete  <= 0;
	end else begin
		if(nstate == OUT)
			inf.complete <= 0 ;
		else if(nstate == OUTPUT && err_msg_ns == No_Err)
			inf.complete <= 1;
		else 
			inf.complete <= 0 ;
	end
end
always_ff@(posedge clk or negedge inf.rst_n) begin 
	if(~inf.rst_n) begin
		inf.out_info  <= 0;
	end else begin
		if(nstate == OUTPUT )begin
			if(act.d_act[0] == Take)
				inf.out_info  <= {cus1_ans[15:0],cus2_ans[15:0],write_res[7:0],food1_ans[7:0],food2_ans[7:0],food3_ans[7:0]};
			else if(act.d_act[0] == Deliver)
				inf.out_info <= {cus1_ans,16'd0,32'd0};
			else if(act.d_act[0] == Order)
				inf.out_info <= {32'd0,write[7:0],write[15:8],write[23:16],write[31:24]};
			else if(act.d_act[0] == Cancel)
				inf.out_info <= {write[39:32],write[47:40],write[55:48],write[63:56],32'd0};
		end
		else 
			inf.out_info  <= 0;
	end
end

//out_valid, err_msg,  complete, out_info, 
//		   C_addr, C_data_w, C_in_valid, C_r_wb
endmodule