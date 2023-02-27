//===========================================================================
//
//  NYCU MSEDA Lab       
//
//  File Name   : PATTERN.v
//  Function    : PATTERN of Serial I/O Matrix Multiplication Using SRAM ( 2022 Fall IClab Lab11 )
//  Author      : Someone in Lab05 
//  Modified By : Tracelementx ( Wei-Liang Chen )
//  Version     : v221216.20
//
//===========================================================================

`ifdef RTL
	`define CYCLE_TIME 20.0
	`define RESET_DELAY 20.0
`endif
`ifdef GATE
	`define CYCLE_TIME 20.0
	`define RESET_DELAY 20.0
`endif
`ifdef APR
	`define CYCLE_TIME 18.0
	`define RESET_DELAY 20.0
`endif
`ifdef POST
	`define CYCLE_TIME 20.0
	`define RESET_DELAY 100.0
`endif


module PATTERN(
    // output
    clk,
    rst_n,
    in_valid,
	  in_valid2,
    matrix,
    matrix_size,
    i_mat_idx, 
    w_mat_idx,

    // input
    out_valid,
    out_value
);
//////////////////////////////////////////////////
// Input and Output Declaration
output reg clk, rst_n, in_valid, in_valid2;
output reg matrix;
output reg [1:0] matrix_size;
output reg i_mat_idx, w_mat_idx;

input out_valid;
input signed out_value;

//////////////////////////////////////////////////
// Parameter and Interger Declaration

//////////////////////////////////////////////////
// Wire and Register Declaration
integer PAT_NUM = 80;
integer a, i, j, k, t, i_pat, j_pat, q;
integer f_input, f_idx, f_ans;
integer out_cnt;
integer ans_cnt;
integer ans_num;
integer wait_val_time;
integer total_latency;

reg signed [15:0] mtx_input;
integer mtx_size;

reg [3:0] i_idx_input, w_idx_input;

reg [5:0] golden_out_cycle;
reg [5:0] your_out_cycle;
integer total_golden_out_cycle;

reg signed [39:0] golden_out_value;
reg [39:0] your_out_value;

//////////////////////////////////////////////////
// Pattern

// define Clk
real CYCLE = `CYCLE_TIME;
initial clk = 0;
always #(CYCLE/2.0) clk = ~clk;

// verify Design
initial begin
	f_input = $fopen("../00_TESTBED/input.txt", "r");
	f_idx = $fopen("../00_TESTBED/idx.txt", "r");
	f_ans = $fopen("../00_TESTBED/ans.txt", "r");

    reset_tsk;

    for (i_pat = 0; i_pat < PAT_NUM; i_pat = i_pat+1) begin
        input_tsk;

        for (j_pat = 0; j_pat < 16; j_pat = j_pat+1) begin
            input2_tsk;
            wait_out_tsk;
            check_ans_tsk;
            $display("\033[0;34m--------------------------------------------------\033[m");
            $display("\033[0;34mPASS PATTERN NO.%3d-%2d\033[m",i_pat, j_pat);
		end
		$display("\033[0;34m==============================================================\033[m");
        $display("\033[0;34mPASS PATTERN NO.%3d,\033[m \033[0;32mexecution cycle : %3d\033[m",i_pat ,total_latency);
		$display("\033[0;34m==============================================================\033[m");
    end

    verify_pass_tsk;
end

//////////////////////////////////////////////////
task reset_tsk; begin 
    rst_n = 'b1;
    in_valid = 'b0;
	in_valid2 = 'b0;
    matrix = 'bx;
    matrix_size = 'bx;
    i_mat_idx = 'bx;
    w_mat_idx = 'bx;

    force clk = 0;
    total_latency = 0;

    #CYCLE; rst_n = 0; 
    #CYCLE; rst_n = 1;
    
    if (out_valid !== 1'b0 || out_value !== 1'b0) begin
        $display(" ");
        $display("==============================================================");
        $display(">>>>> \033[91mOutput Should Be 0 After Reset!\033[m" );
        $display("==============================================================");
        $display(" ");
        $finish;
    end
    
    #CYCLE; release clk;
end 
endtask

//////////////////////////////////////////////////
task input_tsk; begin
	a = $fscanf(f_input, "%d", i);
	a = $fscanf(f_idx, "%d", i);
	a = $fscanf(f_ans, "%d", i);

	t = $urandom_range(1, 5);
	repeat(t) @( negedge clk );

	in_valid = 1'b1;
	a = $fscanf(f_input, "%d", mtx_size);
	case (mtx_size)
        2 : matrix_size = 2'd0;
        4 : matrix_size = 2'd1;
        8 : matrix_size = 2'd2;
	endcase

    ans_num = mtx_size * 2 - 1;

    // matrix X
	for (k = 0; k < 16; k = k+1) begin
		for (i = 0; i < mtx_size; i = i+1) begin
			for (j = 0; j < mtx_size; j = j+1) begin
                a = $fscanf(f_input, "%b", mtx_input); 
                for (q = 15; q >= 0; q = q-1) begin
                    matrix = mtx_input[q];
                    @(negedge clk);

                    if(q == 15)
                        matrix_size = 'dx;
                end
            end
        end
	end

    // matrix W
	for (k = 0; k < 16; k = k+1) begin
		for (i = 0; i < mtx_size; i = i+1) begin
			for (j = 0; j < mtx_size; j = j+1) begin
				a = $fscanf(f_input, "%b", mtx_input);
                for (q = 15; q >= 0; q = q-1) begin
                    matrix = mtx_input[q];
                    @(negedge clk);
                end
			end
        end
	end

	in_valid = 'b0;
	matrix = 'bx;
    @(negedge clk);
end 
endtask

//////////////////////////////////////////////////
task input2_tsk; begin
	in_valid2 = 1'b1;
	a = $fscanf(f_idx, "%b", i_idx_input);
	a = $fscanf(f_idx, "%b", w_idx_input);

    for (q = 3; q >= 0; q = q-1) begin
        i_mat_idx = i_idx_input[q];
        w_mat_idx = w_idx_input[q];
        @(negedge clk);
    end

	in_valid2 = 'b0;
	i_mat_idx = 'dx;
	w_mat_idx = 'dx;
    @(negedge clk);
end 
endtask

//////////////////////////////////////////////////
task wait_out_tsk; begin
    wait_val_time = 0;
    while (out_valid !== 1'b1) begin
        if (wait_val_time == 2000) begin
            $display(" ");
            $display("==============================================================");
            $display(">>>>> \033[91mExecute Over 2000 Cycle!\033[m");
            $display("==============================================================");
            $display(" ");
            $finish;
        end
        wait_val_time = wait_val_time + 1;
        @(negedge clk);
    end

	total_latency = total_latency + wait_val_time;
end 
endtask

//////////////////////////////////////////////////
task check_ans_tsk; begin
    ans_cnt = 0;
    out_cnt = 0;
    total_golden_out_cycle = 0;

	while (out_valid === 1'b1) begin
        if (ans_cnt == ans_num)begin
            $display(" ");
			$display("==============================================================");
			$display(">>>>> \033[91mOnly %2d answer for matrix size %1dX%1d!\033[m", ans_num, mtx_size, mtx_size);
			$display("==============================================================");
			$display(" ");
			$finish;
		end

        a = $fscanf(f_ans, "%d", golden_out_cycle);
		a = $fscanf(f_ans, "%b", golden_out_value);

        total_golden_out_cycle = total_golden_out_cycle + golden_out_cycle + 6;
        
        your_out_cycle = 39'd0;
        your_out_value = 39'd0;

		if (out_cnt > total_golden_out_cycle) begin
            $display(" ");
			$display("==============================================================");
			$display(">>>>> \033[91mout_valid should not be high more than %3d Cycle!\033[m", total_golden_out_cycle);
			$display("==============================================================");
			$display(" ");
			$finish;
		end
		
        for (k = 0; k < 6; k = k+1) begin
            your_out_cycle = {your_out_cycle[4:0], out_value};
            out_cnt = out_cnt + 1;
            @(negedge clk);
        end

        if (your_out_cycle !== golden_out_cycle) begin
            $display(" ");
            $display("==============================================================");
            $display(">>>>> \033[91mFAIL Out Cycle!\033[m" );
            $display(">>>>> Golden_out_cycle : %2d", golden_out_cycle );
            $display(">>>>> Your_out_cycle   : %2d", your_out_cycle );
            $display("==============================================================");
            $display(" ");
            $finish;
        end

        $display("--------------------------------------------------");
        $display(">>>>> Golden_out_cycle : %b", golden_out_cycle);
        $display(">>>>> Your_out_cycle   : %b", your_out_cycle);
        $display(" ");

        for (k = 0; k < golden_out_cycle; k = k+1) begin
            your_out_value = {your_out_value[38:0], out_value};
            out_cnt = out_cnt + 1;
            @(negedge clk);
        end
		
        if (your_out_value !== golden_out_value) begin
            $display(" ");
            $display("==============================================================");
            $display(">>>>> \033[91mFAIL Out Value!\033[m");
            $display(">>>>> Golden_out_value : %b", golden_out_value);
            $display(">>>>> Your_out_value   : %b", your_out_value);
            $display("==============================================================");
            $display(" ");
            $finish;
        end

        $display(">>>>> Golden_out_value : %b", golden_out_value);
        $display(">>>>> Your_out_value   : %b", your_out_value);
        $display(" ");

        ans_cnt = ans_cnt + 1;
	end

    if (out_cnt < total_golden_out_cycle) begin
        $display(" ");
        $display("==============================================================");
        $display(">>>>> \033[91mout_valid should be high for %3d Cycle!\033[m", total_golden_out_cycle);
        $display("==============================================================");
        $display(" ");
        $finish;
    end
end 
endtask

//////////////////////////////////////////////////
task verify_pass_tsk; begin
    $display(" ");
    $display( "==============================================================" );
    $display( ">>>>> \033[92mCongratulations!\033[m" );
    $display( ">>>>> \033[91mAPRRRRRRRRRRRRRRRRRRR!!!!!!!!!!!!!!\033[m" );
	//$display( ">>>>> \033[92mTotal Execution Cycle is %d\033[m", total_latency );
    $display( "==============================================================" );
    $display(" ");
    repeat(2) @(negedge clk);        
    $finish;
end endtask

//////////////////////////////////////////////////
always @(posedge clk) begin
    if (out_valid === 0 && out_value !== 0) begin
        $display(" ");
        $display("==============================================================");
        $display(">>>>> \033[91mout_value should be reset when out_valid is low\033[m");
        $display("==============================================================");
        $display(" ");
        $finish;
    end
end

always @(posedge clk) begin
    if (out_valid === 1 && (in_valid === 1 || in_valid2 === 1)) begin
        $display(" ");
        $display("==============================================================");
        $display(">>>>> \033[91mCannot Output While in_valid is High!\033[m" );
        $display("==============================================================");
        $display(" ");
        $finish;
    end
end

endmodule