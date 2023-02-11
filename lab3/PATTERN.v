
`ifdef RTL
    `define CYCLE_TIME 10.0
`endif
`ifdef GATE
    `define CYCLE_TIME 10.0
`endif

module PATTERN(
  clk,
  rst_n,
  in_valid,
  guy,
  in0,
  in1,
  in2,
  in3,
  in4,
  in5,
  in6,
  in7,
  
  out_valid,
  out
);

output reg       clk, rst_n;
output reg       in_valid;
output reg [2:0] guy;
output reg [1:0] in0, in1, in2, in3, in4, in5, in6, in7;
input            out_valid;
input      [1:0] out;

//================================================================
// wires & registers
//================================================================

reg       array[63:0];
reg [5:0] random[0:12];
reg [1:0]map[0:7][0:63];
reg [2:0] diff;
reg signed[3:0] guy_temp,guy_n;
reg [2:0]guy_reg;
reg [3:0] cur_x;
reg [2:0]obstacles2,obstacles;
reg [2:0]last[0:7];
reg[1:0]obs12;
reg flag,flag2,flag3,flag4;
//================================================================
// parameters & integer
//================================================================
integer last_jump;
integer total_cycles,ram;
integer patcount;
integer cycles,cycle_count,cc,obs_count;
integer a, b, c, i, j, k, input_file;
integer gap;
integer max_low,max_high,min_low,min_high,max,min;
integer golden_step;
integer place1,obstacles1_low,obstacles1_high;
integer place2,last_obs_low,last_obs_high,last_obs;
integer min_high_2,min_low_2;
integer max_high_2,max_low_2;
integer obstacles2_high,obstacles2_low;
integer in0_last,in1_last,in2_last,in3_last,in4_last,in5_last,in6_last,in7_last,flagger_8_2,flagger_8_1;
parameter PATNUM=300;//104;
//================================================================
// clock
//================================================================
always  #(`CYCLE_TIME/2.0) clk = ~clk;
initial clk = 0;
//================================================================
// initial
//================================================================
initial begin
    rst_n    = 1'b1;
    in_valid = 1'b0;
    flag = 0;
    flag2 =0;
    flag3 =0;
    flag4=0;
    cycles = 0;
    ram = 0;
    cc=0;
    force clk = 0;
    total_cycles = 0;
    reset_task;
    for (patcount=0;patcount<PATNUM;patcount=patcount+1) begin
        input_data;
        cycles = 0;
        wait_out_valid;
        cycles = 1;
        check_ans;
        $display("PASS PATTERN NO.%4d ", patcount);
        cycles = 0;
        for(k=0;k<64;k=k+1)begin
            for(j=0;j<8;j=j+1)begin
                map[j][k]=0;
                end
            end
    end

    #(1000);
   YOU_PASS_task;
    $finish;
end
always @(posedge clk) begin
    if(!out_valid)begin
        if(out !== 0)begin
            //$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
            $display("SPEC 4 IS FAIL!");
            //$display ("out should be set to 0");
            //$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
        //#(100);
        $finish ;
        end
    end
end

//================================================================
//          task
//================================================================
task reset_task ; begin
    #(10); rst_n = 0;

    #(10);
    if((out !== 0) || (out_valid !== 0)) begin
            //$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
            $display("SPEC 3 IS FAIL!");
            //$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
        $finish ;
    end
    
    #(10); rst_n = 1 ;
    #(3.0); release clk;
    
end endtask

task input_data ; 
    begin 
        gap = $urandom_range(3,5);
        repeat(gap)@(negedge clk);
        
        in_valid = 1;
        cycle_count = 0;
        j=0;
        
        for(cycles=0;cycles<64;cycles=cycles+1)begin
            if(cycles == 0)begin
                guy = $urandom_range(0,7);
                guy_reg = guy;
                cur_x =guy_reg;
                guy_temp = guy;
                in0 = 2'b0;
                in1 = 2'b0;
                in2 = 2'b0;
                in3 = 2'b0;
                in4 = 2'b0;
                in5 = 2'b0;
                in6 = 2'b0;
                in7 = 2'b0;
                last[0]=in0;
                last[1]=in1;
                last[2]=in2;
                last[3]=in3;
                last[4]=in4;
                last[5]=in5;
                last[6]=in6;
                last[7]=in7;
                cycle_count = cycle_count + 1;
            end
            else begin

                if (guy_n == 7) begin
                    guy_n = $urandom_range(6,7);
                end
                else if(guy_n ==0)begin
                    guy_n = $urandom_range(0,1);
                end
                else begin
                    guy_n = $urandom_range(guy_n-1,guy_n+1);
                end

                diff = ((guy_n - guy_temp)>0)? guy_n-guy_temp:guy_temp-guy_n;

                if(last[0]!=0)begin
                    in0 = 2'd0;
                    in1 = 2'b0;
                    in2 = 2'b0;
                    in3 = 2'b0;
                    in4 = 2'b0;
                    in5 = 2'b0;
                    in6 = 2'b0;
                    in7 = 2'b0;
                    guy_temp = guy_n;
                    cycle_count = cycle_count + 1;
                end
                else begin
                    if(diff >= cycle_count)begin
                        in0 = 2'd0;
                        in1 = 2'b0;
                        in2 = 2'b0;
                        in3 = 2'b0;
                        in4 = 2'b0;
                        in5 = 2'b0;
                        in6 = 2'b0;
                        in7 = 2'b0;
                       
                        cycle_count = cycle_count + 1;
                    end
                    else begin
                        in0 = 2'd3;
                        in1 = 2'd3;
                        in2 = 2'd3;
                        in3 = 2'd3;
                        in4 = 2'd3;
                        in5 = 2'd3;
                        in6 = 2'd3;
                        in7 = 2'd3;
                        obs12 = $urandom_range(1,2);
                        case (guy_n)
                            0: in0 = obs12; 
                            1: in1 = obs12; 
                            2: in2 = obs12; 
                            3: in3 = obs12; 
                            4: in4 = obs12; 
                            5: in5 = obs12; 
                            6: in6 = obs12; 
                            7: in7 = obs12;    
                        endcase
                        cycle_count = 0;
                    end

                end



                last[0]=in0;
                last[1]=in1;
                last[2]=in2;
                last[3]=in3;
                last[4]=in4;
                last[5]=in5;
                last[6]=in6;
                last[7]=in7;
            end
            @(negedge clk);
            if (out_valid === 1)
            begin
                $display("SPEC 5 IS FAIL!");
                //$display("out_valid should not be hight when in_valid is high");
                
                $finish;
            end
        
            map[0][cycles] = in0;
            map[1][cycles] = in1;
            map[2][cycles] = in2;
            map[3][cycles] = in3;
            map[4][cycles] = in4;
            map[5][cycles] = in5;
            map[6][cycles] = in6;
            map[7][cycles] = in7;

            
        end
        in_valid     = 'b0;
        if(!in_valid)begin
                guy = 3'bx;
                in0 = 2'bx;
                in1 = 2'bx;
                in2 = 2'bx;
                in3 = 2'bx;
                in4 = 2'bx;
                in5 = 2'bx;
                in6 = 2'bx;
                in7 = 2'bx;
        end 
    end 
endtask
task wait_out_valid ; 
begin
    cycles = 0;
    while(out_valid === 0)begin
        cycles = cycles + 1;
        if(cycles == 3000) begin
            $display ("SPEC 6 IS FAIL!");
            $finish;
        end
    @(negedge clk);
    end
   

end 
endtask

task check_ans ; 
begin
    golden_step = 0;
    

    while(out_valid === 1) begin
        if(out !== 0)begin
            if(flagger_8_2==2)begin
                flagger_8_2 =flagger_8_2-1;

            end
            else if(flagger_8_2 == 1)begin
                $display("SPEC 8-2 IS FAIL!"); 
                $finish;
            end
        end
        if(out !== 0)begin
            if(flagger_8_1==1)begin
                $display("SPEC 8-3 IS FAIL!"); 
                $finish;
            end
        end
        
        
        if (out == 2'd0)
            cur_x = cur_x;
        if (out == 2'd1)
            cur_x = cur_x+1;
        if (out == 2'd2)
            cur_x = cur_x-1;
        if (out == 2'd3)
            cur_x = cur_x;

        if((out ===2'd3)&&(map[cur_x][cycles-1]===map[cur_x][cycles]))    //8-3 001 002 003
            flag =1;
        if((out ===2'd3)&&((map[cur_x][cycles-1]===2)&&map[cur_x][cycles]===0)) // 8-3 200 201 202 203
            flag =1;
        if(flag2&&(out===0))
            flag3 =1;
        
        if(out===3)begin
            if((map[cur_x][cycles-1]===1)&&(map[cur_x][cycles+1]===0))begin
                flagger_8_2=2; //8-2

            end
            else if(map[cur_x][cycles]===0)begin
                flagger_8_1=1; //8-3
            end
        end
       
        
        
        if(cur_x > 7) begin
                $display("SPEC 8-1 IS FAIL!"); 
                $finish;  
        end
        if( map[cur_x][cycles] == 3  || map[cur_x][cycles] == 1) begin
            if(out === 0)begin
                $display("SPEC 8-1 IS FAIL!"); 
                $finish;
            end
        end
        if(map[cur_x][cycles]===2)begin
            if(last_jump ===3 )begin
                $display("SPEC 8-1 IS FAIL!"); 
                $finish;
            end
        end
        
        if((out === 3)&&map[cur_x][cycles]==2)begin
                $display("SPEC 8-1 IS FAIL!"); 
                $finish;
            end
        if (cycles>64) begin
            $display("SPEC 7 IS FAIL!");
            $finish;
        end
        @(negedge clk);
        flag4 =flag3;
        golden_step=golden_step+1;
        cycles = cycles +1;
        cc= cycles;
        last_jump = out;
    end
    
    
    if (cc<64) begin
        
        if(out !== 0)begin
            $display("SPEC 4 IS FAIL!");
            $finish ;
        end
        else begin
            $display("SPEC 7 IS FAIL!");
            $finish;
        end
    end
    @(negedge clk);
    


end 
endtask

task YOU_PASS_task;
    begin
    $display ("----------------------------------------------------------------------------------------------------------------------");
    $display ("                                                  Congratulations!                                                   ");
    $display ("                                           You have passed all patterns!                                             ");
    $display ("----------------------------------------------------------------------------------------------------------------------");
    $finish;

    end
endtask
endmodule