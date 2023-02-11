module bridge(input clk, INF.bridge_inf inf);
//
//
//
//
//DRAM
//
//output  AR_VALID, AR_ADDR, R_READY, AW_VALID, AW_ADDR, W_VALID, W_DATA, B_READY,
//input AR_READY, R_VALID, R_RESP, R_DATA, AW_READY, W_READY, B_VALID, B_RESP
//================================================================
// logic 
//================================================================
logic [63:0] data;
logic c_out_valid_r;
logic [7:0]address;
typedef	enum	logic	[2:0]	{IDLE, AR, R, AW, W, OUT}	STATE;
STATE cstate;
STATE nstate;
//================================================================
// Design 
//================================================================

always_comb begin
	if(inf.AR_VALID)
		inf.AR_ADDR = 'h10000 +(address*8);
	else
		inf.AR_ADDR = 0;
end
always_comb begin
	if(inf.AW_VALID)
		inf.AW_ADDR = 'h10000 +(address*8);
	else
		inf.AW_ADDR = 0;
end
always_comb begin
	if(cstate==IDLE)
		inf.W_DATA = 0;
	else
		inf.W_DATA = data;
end
always_comb begin
	if(inf.R_VALID || inf.B_VALID)
		c_out_valid_r = 1;
	else
		c_out_valid_r = 0;
end

always_comb begin
	if(cstate == AW)
		inf.AW_VALID = 1;
	else 
		inf.AW_VALID = 0;
end
always_comb begin
	if(cstate == AR)
		inf.AR_VALID = 1;
	else 
		inf.AR_VALID = 0;
end


always_comb begin
	if(cstate == W)
		inf.B_READY = 1;
	else
		inf.B_READY = 0;
end
always_comb begin
	if(inf.C_out_valid)
		inf.C_data_r = data;
	else 
		inf.C_data_r =0;
end
//================================================================
//   FSM
//================================================================
	
always_comb begin 
	case (cstate)
		IDLE:begin
			if(inf.C_in_valid)begin
				if(inf.C_r_wb)
					nstate = AR;
				else
					nstate = AW;
			end
			else
				nstate = IDLE;
		end
		AR:nstate = (inf.AR_READY)?R:AR;
		R: nstate = (inf.R_VALID)?OUT:R;

		AW:nstate =(inf.AW_READY)?W:AW;
		W: nstate =(inf.B_VALID)?OUT:W;
		OUT: nstate = IDLE;
		default : nstate = IDLE;
	endcase
end

		  			  
	    

//************************************
//		  FSM_sample code
//************************************
always_ff@(posedge clk or negedge inf.rst_n)
begin
	if(!inf.rst_n) 
		cstate <= IDLE;
	else
		cstate <= nstate;
end

always_ff@(posedge clk or negedge inf.rst_n)
begin
	if(!inf.rst_n) 
		address <= 0;
	else
		address <= inf.C_addr;
end
always_ff@(posedge clk or negedge inf.rst_n)
begin
	if(!inf.rst_n) 
		data <= 0;
	else begin
		if(inf.R_VALID)
			data <= inf.R_DATA;
		else if(inf.C_r_wb == 0)
			data <= inf.C_data_w;
	end
end
always_ff@(posedge clk or negedge inf.rst_n)
begin
	if(!inf.rst_n) 
		inf.C_out_valid <= 0;
	else
		inf.C_out_valid <= c_out_valid_r;
end
//R_READY
always_ff @(posedge clk or negedge inf.rst_n) begin
    if(!inf.rst_n) begin
        inf.R_READY <= 0;
    end
    else begin
    	if(cstate == R)
        	inf.R_READY <= 1;
        else 
        	inf.R_READY <= 0;
    end
end
//W_VALID
always_ff @(posedge clk or negedge inf.rst_n) begin
    if(!inf.rst_n) begin
        inf.W_VALID <= 0;
    end
    else if(cstate == W) begin
        inf.W_VALID <= 1;
    end
    else begin
        inf.W_VALID <= 0;
    end
end
endmodule