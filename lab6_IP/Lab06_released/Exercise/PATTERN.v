//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   File Name   : PATTERN.v
//   Module Name : PATTERN
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

`ifdef RTL_TOP
    `define CYCLE_TIME 6.0
`endif

`ifdef GATE_TOP
    `define CYCLE_TIME 6.0
`endif

module PATTERN (
    // Output signals
    clk, rst_n, in_valid, in_time,
    // Input signals
    out_valid, out_display, out_day
);

// ===============================================================
// Input & Output Declaration
// ===============================================================
output reg clk, rst_n, in_valid;
output reg [30:0] in_time;
input out_valid;
input [3:0] out_display;
input [2:0] out_day;

// ===============================================================
// Parameter & Integer Declaration
// ===============================================================
real CYCLE = `CYCLE_TIME;
integer input_file, output_file;
integer total_cycles, cycles;
integer PATNUM, patcount;
integer gap;
integer a, b, c, d;
integer i, j, k;
integer golden_step;
integer out_day_fail;

//================================================================
// Wire & Reg Declaration
//================================================================
reg [3:0] golden_display [0:13];
reg [2:0] golden_day;

//================================================================
// Clock
//================================================================
initial clk = 0;
always #(CYCLE/2.0) clk = ~clk;

//================================================================
// Initial
//================================================================
initial begin
    rst_n    = 1'b1;
    in_valid = 1'b0;
    in_time  = 'dx;
	total_cycles = 0;

    force clk = 0;
    reset_task;

    input_file  = $fopen("../00_TESTBED/input_top.txt","r");
	output_file = $fopen("../00_TESTBED/output_top.txt","r");
    @(negedge clk);

    a = $fscanf(input_file, "%d", PATNUM);
	for (patcount=0; patcount<PATNUM; patcount=patcount+1) begin
		input_data;
		wait_out_valid;
		check_ans;
		$display("\033[0;34mPASS PATTERN NO.%4d,\033[m \033[0;32m Cycles: %3d\033[m", patcount ,cycles);
	end
	#(50);
	YOU_PASS_task;
	$finish;
end

//================================================================
// TASK
//================================================================
task reset_task ; begin
	#(10); rst_n = 1'b0;
	#(10);
	if((out_valid !== 0) || (out_display !== 0) || (out_day !== 0)) begin
		$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
		$display ("                                                                        FAIL!                                                               ");
		$display ("                                                  Output signal should be 0 after initial RESET at %8t                                      ",$time);
		$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
		#(100);
		$finish ;
	end
	#(10); rst_n = 1'b1;
	#(3.0); release clk;
end endtask

task input_data; begin
	gap = $urandom_range(2,4);
	repeat(gap) @(negedge clk);
	in_valid = 1'b1;
	// Given Timestamp
	b = $fscanf (input_file, "%d", in_time);
    @(negedge clk);
	in_valid = 1'b0;
    in_time = 'dx;
end endtask

task wait_out_valid; begin
	cycles = 0;
	while(out_valid === 0)begin
		cycles = cycles + 1;
        if(cycles == 10000) begin
			$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
			$display ("                                                                        FAIL!                                                               ");
			$display ("                                                                   Pattern NO.%03d                                                          ", patcount);
			$display ("                                                     The execution latency are over 10000 cycles                                             ");
			$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
			repeat(2)@(negedge clk);
			$finish;
		end
	@(negedge clk);
	end
	total_cycles = total_cycles + cycles;
end endtask

task check_ans; begin
	// Golden Answer
	for (i=0; i<14; i=i+1) c = $fscanf(output_file, "%d", golden_display[i]);
	d = $fscanf(output_file, "%d", golden_day); // Sunday(0) ~ Saturday(6)
	// Check Answer
	out_day_fail = 0;
	golden_step = 1;
	while (out_valid === 1) begin
		if ( golden_display[ golden_step-1 ] !== out_display ) begin
			$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
			$display ("                                                                        FAIL!                                                               ");
			$display ("                                                                   Pattern NO.%03d                                                          ", patcount);
			$display ("                                                 The out_display should be correct when out_valid is high                                   ");
			$display ("                                                              Your output -> result: %d                                                     ", out_display);
			$display ("                                                            Golden output -> result: %d, step: %d                                           ", golden_display[golden_step-1], golden_step);
			$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
			@(negedge clk);
			$finish;
		end
		if ( golden_day !== out_day ) out_day_fail = 1;
		if ( (golden_step==14) && (out_day_fail) ) begin
			$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
			$display ("                                                                        FAIL!                                                               ");
			$display ("                                                                   Pattern NO.%03d                                                          ", patcount);
			$display ("                                                  The out_day should be correct when out_valid is high                                      ");
			$display ("                                                            Golden output -> result: %d                                                     ", golden_day);
			$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
			@(negedge clk);
			$finish;
		end
		@(negedge clk);
		golden_step = golden_step + 1;
	end
	if(golden_step !== 15) begin
		$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
		$display ("                                                                        FAIL!                                                               ");
		$display ("                                                                   Pattern NO.%03d                                                          ", patcount);
		$display ("	                                                          Output cycle should be 14 cycles                                                 ");
		$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
		@(negedge clk);
		$finish;
	end
end endtask

task YOU_PASS_task; begin
	$display ("----------------------------------------------------------------------------------------------------------------------");
	$display ("                                                  Congratulations!                						             ");
	$display ("                                           You have passed all patterns!          						             ");
	$display ("                                           Your execution cycles = %5d cycles   						                 ", total_cycles);
	$display ("                                           Your clock period = %.1f ns        					                     ", `CYCLE_TIME);
	$display ("                                           Your total latency = %.1f ns         						                 ", total_cycles*`CYCLE_TIME);
	$display ("----------------------------------------------------------------------------------------------------------------------");
	$finish;
end endtask

endmodule