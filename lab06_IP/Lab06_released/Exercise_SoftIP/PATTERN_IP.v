//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   File Name   : PATTERN_IP.v
//   Module Name : PATTERN_IP
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

`ifdef RTL
    `define CYCLE_TIME 6.0
`endif

`ifdef GATE
    `define CYCLE_TIME 6.0
`endif

module PATTERN_IP #(parameter WIDTH = 4, parameter DIGIT = 2) (
    // Input signals
    Binary_code,
    // Output signals
    BCD_code
);

// ===============================================================
// Input & Output Declaration
// ===============================================================
output reg [WIDTH-1:0]   Binary_code;
input      [DIGIT*4-1:0] BCD_code;

// ===============================================================
// Parameter & Integer Declaration
// ===============================================================
real CYCLE = `CYCLE_TIME;
integer PATNUM, patcount;
integer input_file, output_file;
integer a, b, c;
integer i, j, k;

//================================================================
// Wire & Reg Declaration
//================================================================
reg clk;
reg [WIDTH-1:0]   in_data;
reg [DIGIT*4-1:0] golden_ans;
reg [3:0]         golden_value;

//================================================================
// Clock
//================================================================
initial clk = 0;
always #(CYCLE/2.0) clk = ~clk;

//================================================================
// Initial
//================================================================
initial begin
    // select file
    case (WIDTH)
        4: begin
            input_file = $fopen("../00_TESTBED/input_ip_4.txt","r");
            output_file = $fopen("../00_TESTBED/output_ip_4.txt","r");
        end
        8: begin
            input_file = $fopen("../00_TESTBED/input_ip_8.txt","r");
            output_file = $fopen("../00_TESTBED/output_ip_8.txt","r");
        end
        12: begin
            input_file = $fopen("../00_TESTBED/input_ip_12.txt","r");
            output_file = $fopen("../00_TESTBED/output_ip_12.txt","r");
        end
        16: begin
            input_file = $fopen("../00_TESTBED/input_ip_16.txt","r");
            output_file = $fopen("../00_TESTBED/output_ip_16.txt","r");
        end
        20: begin
            input_file = $fopen("../00_TESTBED/input_ip_20.txt","r");
            output_file = $fopen("../00_TESTBED/output_ip_20.txt","r");
        end
        default: begin
            input_file = 0;
            output_file = 0;
            $display ("-------------------------------------------------------------------");
            $display ("                          Test case Error                          ");
            $display ("-------------------------------------------------------------------");
            $finish;
        end
    endcase
    // verify
    repeat(2) @(negedge clk);
    a = $fscanf(input_file, "%d", PATNUM);
    for (patcount=0; patcount<PATNUM; patcount=patcount+1) begin
        input_task;
        @(negedge clk);
        check_ans_task;
    end
    @(negedge clk);
    YOU_PASS_task;
end

//================================================================
// TASK
//================================================================
task input_task; begin
    b = $fscanf(input_file, "%d", in_data);
    Binary_code = in_data;
end endtask

task check_ans_task; begin
    golden_ans = 0;
    for (i=0; i<DIGIT; i=i+1) begin
        j = DIGIT - i;
        c = $fscanf(output_file, "%d", golden_value);
        golden_ans = golden_ans << 4;
        golden_ans[3:0] = golden_value;
    end
    if (golden_ans !== BCD_code) begin
		$display ("-------------------------------------------------------------------");
		$display ("                      PATTERN  %5d  FAILED!!!                      ", patcount);
		$display ("                         Correct: %h                               ", golden_ans);
        $display ("                         Yours: %h                                 ", BCD_code);
		$display ("-------------------------------------------------------------------");
		repeat(7) @(negedge clk);
		$finish;
    end
    $display("\033[0;32mPASS PATTERN NO.%4d\033[m \033[0;32\033[m", patcount);
end endtask

task YOU_PASS_task; begin
	$display ("-------------------------------------------------------------------");
	$display ("            ~(￣▽￣)~(＿△＿)~(￣▽￣)~(＿△＿)~(￣▽￣)~            ");
	$display ("                          Congratulations!                         ");
	$display ("                   You have passed all patterns!                   ");
	$display ("-------------------------------------------------------------------");
	repeat(7) @(negedge clk);
	$finish;
end endtask


endmodule