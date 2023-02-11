module Checker(input clk, INF.CHECKER inf);
import usertype::*;



Action [3:0]act1;
logic [3:0]act1111;
//declare other cover group


covergroup Spec1 @(posedge clk iff inf.id_valid);
	option.at_least = 1;
	option.per_instance = 1;
	coverpoint inf.D.d_id[0]
	{
		option.auto_bin_max = 256;
	}
endgroup 

covergroup Spec2 @(posedge clk iff inf.act_valid);
	option.at_least = 10;
	option.per_instance = 1;
	coverpoint inf.D.d_act[0]
	{
		bins act1[] = (Take, Deliver, Order, Cancel =>Take, Deliver, Order, Cancel );
	}
endgroup

covergroup Spec3 @(posedge clk iff inf.out_valid === 1);
	option.at_least = 200;
	option.per_instance = 1;
	coverpoint inf.complete
	{
		bins comp[] = {1,0};
	}
endgroup 

covergroup Spec4 @(negedge clk iff inf.out_valid);
	option.at_least = 20;
	option.per_instance = 1;
	coverpoint inf.err_msg
	{
		bins no_food = {No_Food};
		bins D_man_busy={D_man_busy};
		bins No_customers={No_customers};
		bins Res_busy={Res_busy};
		bins Wrong_cancel={Wrong_cancel};
		bins Wrong_res_ID={Wrong_res_ID};
		bins Wrong_food_ID={Wrong_food_ID};
		ignore_bins err_ig = {No_Err};
	}
endgroup

//
Spec1 cov_spec1 = new();
Spec2 cov_spec2 = new();
Spec3 cov_spec3 = new();
Spec4 cov_spec4 = new();

//************************************ below assertion is to check your pattern ***************************************** 
//                                          Please finish and hand in it
// This is an example assertion given by TA, please write the required assertions below
//  assert_interval : assert property ( @(posedge clk)  inf.out_valid |=> inf.id_valid == 0 [*2])
//  else
//  begin
//  	$display("Assertion X is violated");
//  	$fatal; 
//  end
wire #(0.5) rst_reg = inf.rst_n;
//write other assertions
//========================================================================================================================================================
// Assertion 1 ( All outputs signals (including FD.sv and bridge.sv) should be zero after reset.)
//========================================================================================================================================================
//FD output
always @(negedge  rst_reg) begin
	//#1
 	assert  ((inf.C_data_w ===0)&&(inf.C_in_valid===0) && (inf.out_valid === 0) && (inf.err_msg === 0) && (inf.complete === 0) && (inf.out_info === 0) && (inf.C_addr === 0) && (inf.C_r_wb === 0) && (inf.C_in_valid === 0) && (inf.C_data_w === 0))
 	else
 	begin
 		$display("Assertion 1 is violated");
 		$fatal; 
 	end
 	
end
//bridge output
always @(negedge  rst_reg) begin
	//#1
 	assert  ( (inf.AW_VALID === 0) && (inf.AR_ADDR === 0) && (inf.R_READY === 0) && (inf.AW_VALID === 0) && (inf.AW_ADDR === 0) && (inf.W_VALID === 0) && (inf.W_DATA === 0) && (inf.B_READY === 0))
 	else
 	begin
 		$display("Assertion 1 is violated");
 		$fatal; 
 	end
 	
end
always @(negedge clk) begin
	
 	assert property( (inf.complete===1 && inf.out_valid === 1) |-> (inf.err_msg == No_Err))
 	else
 	begin
 		$display("Assertion 2 is violated");
 		$fatal; 
 	end
 	
end
always @(negedge clk) begin
	
 	assert property( (inf.complete===0 && inf.out_valid === 1) |-> (inf.out_info == 0))
 	else
 	begin
 		$display("Assertion 3 is violated");
 		$fatal; 
 	end
 	
end
assign act1 = (inf.act_valid)? inf.D.d_act[0]:0;

always_ff @(posedge clk or negedge  inf.rst_n) begin 
	if(!inf.rst_n) begin
		act1111 <= 0;
	end else begin
		if(inf.act_valid)
			act1111 <= act1;

	end
end
// spec4
//===================================================================================================
always @(posedge clk) begin
	
 	actvalid_asser:assert property( inf.act_valid |=> ##[1:5](inf.id_valid || inf.res_valid || inf.food_valid || inf.cus_valid))
 	else
 	begin
 		$display("Assertion 4 is violated");
 		$fatal; 
 	end
 	
end
// 0 cycle 
always @(posedge clk) begin
	
 	actvalid2222A:assert property( inf.act_valid |-> ##1 !(inf.id_valid || inf.res_valid || inf.food_valid || inf.cus_valid))
 	else 
 		begin
 		$display("Assertion 4 is violated");
 		$fatal; 
 	end
 	
end
//===================================================================================================
always @(posedge clk) begin
	
 	idvalid:assert property( (inf.id_valid && act1111 === Take)  |=> ##[1:5](inf.cus_valid ))
 	else
 	begin
 		$display("Assertion 4 is violated");
 		$fatal; 
 	end
 	
end
// 0 cycle 
always @(posedge clk) begin
	
 	idvalid2222A:assert property( (inf.id_valid && act1111 === Take)  |-> ##1 !inf.cus_valid )
 	else 
 		begin
 		$display("Assertion 4 is violated");
 		$fatal; 
 	end
 	
 	
end
//===================================================================================================
always @(posedge clk) begin
	
 	resvalid:assert property( (inf.res_valid )  |=> ##[1:5](inf.food_valid ))
 	else
 	begin
 		$display("Assertion 4 is violated");
 		$fatal; 
 	end
 	
end
// 0 cycle 
always @(posedge clk) begin
	
 	resvalid2222A:assert property( (inf.res_valid ) |-> ##1 !(inf.food_valid ) )
 	else 
 		begin
 		$display("Assertion 4 is violated");
 		$fatal; 
 	end
 	
 	
end
//===================================================================================================
always @(posedge clk) begin
	
 	foodvalid:assert property( (inf.food_valid && act1111 === Cancel)  |=> ##[1:5] (inf.id_valid ))
 	else
 	begin
 		$display("Assertion 4 is violated");
 		$fatal; 
 	end
 	
end
// 0 cycle 
always @(posedge clk) begin
	
 	foodvalid2222A:assert property( (inf.food_valid && act1111 === Cancel) |-> ##1 !(inf.id_valid ))
 	else 
 		begin
 		$display("Assertion 4 is violated");
 		$fatal; 
 	end
 	
 	
end
//spec 5 input doesn't overlap each other
always @(posedge clk) begin
	
 	spec5_id:assert property( (inf.id_valid ===1 )  |-> (  (inf.act_valid===0) && (inf.food_valid===0) && (inf.cus_valid===0) && (inf.res_valid===0)   )    )
 	else
 	begin
 		$display("Assertion 5 is violated");
 		$fatal; 
 	end
 	
end
always @(posedge clk) begin
	
 	spec5_act:assert property( ( inf.act_valid===1  )  |-> ( (inf.id_valid ===0) &&  (inf.food_valid===0) && (inf.cus_valid===0) && (inf.res_valid===0) ) )
 	else
 	begin
 		$display("Assertion 5 is violated");
 		$fatal; 
 	end
 	
end
always @(posedge clk) begin
	
 	spec5_food:assert property( ( inf.food_valid ===1  )  |-> ( (inf.id_valid ===0)&& (inf.act_valid===0) &&  (inf.cus_valid===0) && (inf.res_valid===0)))
 	else
 	begin
 		$display("Assertion 5 is violated");
 		$fatal; 
 	end
 	
end
always @(posedge clk) begin
	
 	spec5_cus:assert property( ( inf.cus_valid ===1 )  |-> ( (inf.id_valid ===0)&& (inf.act_valid===0) && (inf.food_valid===0) &&  (inf.res_valid===0)))
 	else
 	begin
 		$display("Assertion 5 is violated");
 		$fatal; 
 	end
 	
end
always @(posedge clk) begin
	
 	spec5_res:assert property( ( inf.res_valid ===1  )  |-> ( (inf.id_valid ===0)&& (inf.act_valid===0) && (inf.food_valid===0) && (inf.cus_valid===0)))
 	else
 	begin
 		$display("Assertion 5 is violated");
 		$fatal; 
 	end
 	
end



//spec 6 output valid is only one cycle
always @(negedge clk) begin
	
 	assert property( (inf.out_valid)  |=> (inf.out_valid == 0))
 	else
 	begin
 		$display("Assertion 6 is violated");
 		$fatal; 
 	end
 	
end
//spec 7
always @(posedge clk) begin
	
 	assert property( (inf.out_valid)  |=> ##[1:9](inf.act_valid === 1))
 	else
 	begin
 		$display("Assertion 7 is violated");
 		
 		$fatal; 
 	end
 	
end
// 0 cycle 
always @(posedge clk) begin
	
 	ASSERTION7_DELAY0CYCLE:assert property((inf.out_valid)  |->(inf.act_valid===0))
 	else 
 		begin
 		$display("Assertion 7 is violated");
 		$fatal; 
 	end
 	
end
// 1 cycle
always @(posedge clk) begin
	
 	ASSERTION7_DELAY1CYCLE:assert property((inf.out_valid)  |-> ##1 (inf.act_valid===0))
 	else 
 		begin
 		$display("Assertion 7 is violated");
 		$fatal; 
 	end
 	
end
//spec 8 latency doesn't exceed 1200cycles
always @(posedge clk) begin
	
 	assert property( ((inf.cus_valid && act1111 == Take)   ||
 	                 (inf.id_valid   && act1111 == Deliver)||
 	                 (inf.id_valid   && act1111 == Cancel) ||
 		             (inf.food_valid && act1111 == Order)  )    |=> ##[0:1199](inf.out_valid === 1))
 	else
 	begin
 		$display("Assertion 8 is violated");
 		$fatal; 
 	end
 	
end


endmodule