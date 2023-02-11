`define CYCLE_TIME 7 //cycle
`define PAT_NUM 500

module PATTERN(
    //Input Port
    clk,
    rst_n,
	in_valid,
    source,
    destination,

    //Output Port
    out_valid,
    cost,
    );


/* Input to design */
output reg   clk, rst_n, in_valid;
output reg   [3:0]   source;
output reg   [3:0]   destination;

/* Output to pattern */
input         out_valid;
input [3:0]   cost;

/* define clock cycle */
real CYCLE = `CYCLE_TIME;
always #(CYCLE/2.0) clk = ~clk;

/* parameter and integer*/
integer patnum = `PAT_NUM;
integer i_pat, i, j, a, t;
integer f_in, f_ans;
integer s_station, d_station;
integer golden_cost;
integer latency;
integer total_latency;

/* reg declaration */


initial begin
  f_in  = $fopen("../00_TESTBED/demo_input.txt", "r");
  f_ans = $fopen("../00_TESTBED/demo_ans.txt", "r");
  reset_task;
  a = $fscanf(f_in, "%d", patnum);

  for (i_pat = 0; i_pat < patnum; i_pat = i_pat+1)
	begin
		input_task;
		compute_ans_task;
        wait_out_valid_task;
        check_ans_task;
        check_out_valid_task;
        $display("\033[0;34mPASS PATTERN NO.%4d,\033[m \033[0;32mexecution cycle : %3d\033[m",i_pat ,latency);
    end
  YOU_PASS_task;
  
end

task reset_task; begin 
    rst_n = 'b1;
    in_valid = 'b0;
    source = 'bx;
    destination = 'bx;
    total_latency = 0;

    force clk = 0;

    #CYCLE; rst_n = 0; 
    #CYCLE; rst_n = 1;
    
    if(out_valid !== 1'b0 || cost !=='b0) begin //out!==0
        $display("************************************************************");  
        $display("                          FAIL!                              ");    
        $display("*  Output signal should be 0 after initial RESET  at %8t   *",$time);
        $display("************************************************************");
        repeat(2) #CYCLE;
        $finish;
    end
	#CYCLE; release clk;
end endtask


task input_task; begin
    a = $fscanf(f_in, "%d %d", s_station, d_station);
    t = $urandom_range(1, 4);
	repeat(t) @(negedge clk);
	in_valid = 1'b1;
    a = $fscanf(f_in, "%d %d", s_station, d_station);
    while (s_station != 16 && d_station != 16) begin
        source = s_station;
        destination = d_station;
        a = $fscanf(f_in, "%d %d", s_station, d_station);
        @(negedge clk);
    end

    in_valid = 1'b0;
	source = 'bx;
    destination = 'bx;
    
end endtask 

task compute_ans_task; begin
    a = $fscanf(f_ans, "%d", golden_cost);
end endtask


task wait_out_valid_task; begin
    latency = 0;
    while(out_valid !== 1'b1) begin
	latency = latency + 1;
      if( latency == 30000) begin
          $display("********************************************************");     
          $display("                          FAIL!                              ");
          $display("*  The execution latency are over 30000 cycles  at %8t   *",$time);//over max
          $display("********************************************************");
	    repeat(2)@(negedge clk);
	    $finish;
      end
     @(negedge clk);
   end
   total_latency = total_latency + latency;
end endtask





task check_ans_task; begin
    if(cost !== golden_cost) begin
        $display ("------------------------------------------------------------------------------------------------------------------------------------------");
        $display ("                                                                      FAIL!                                                               ");
        $display ("                                                                 Golden Cost :          %d                                                   ",golden_cost); //show ans
        $display ("                                                                 Your Cost :            %d                              ", cost); //show output
        $display ("------------------------------------------------------------------------------------------------------------------------------------------");
        repeat(9) @(negedge clk);
        $finish;
    end
	@(negedge clk);
end endtask

task check_out_valid_task; begin
    if(out_valid === 'b1) begin
        $display ("------------------------------------------------------------------------------------------------------------------------------------------");
        $display ("                                                                      FAIL!                                                               ");
        $display ("                                                     out_valid should only be high for one cycle                                          "); 
        $display ("------------------------------------------------------------------------------------------------------------------------------------------");
        repeat(9) @(negedge clk);
        $finish;
    end
end endtask


task YOU_PASS_task; begin
    $display ("--------------------------------------------------------------------");
    $display ("                         Congratulations!                           ");
    $display ("                  You have passed all patterns!                     ");
    $display ("                  Total latency : %d cycles                     ", total_latency);
    $display ("--------------------------------------------------------------------");        
    repeat(2)@(negedge clk);
    $finish;
end endtask


endmodule
