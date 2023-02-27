`ifdef RTL
`define CYCLE_TIME 20.0
`endif
`ifdef GATE
`define CYCLE_TIME 20.0
`endif

`include "../00_TESTBED/MEM_MAP_define.v"
`include "../00_TESTBED/pseudo_DRAM.v"

module PATTERN #(parameter ID_WIDTH=4, DATA_WIDTH=128, ADDR_WIDTH=32)(
        
	clk              ,	
	rst_n            ,	
	in_valid         ,	
	op               ,	
	pic_no           ,	  
	se_no            ,	  
  busy             ,

         awid_s_inf,
       awaddr_s_inf,
       awsize_s_inf,
      awburst_s_inf,
        awlen_s_inf,
      awvalid_s_inf,
      awready_s_inf,
                    
        wdata_s_inf,
        wlast_s_inf,
       wvalid_s_inf,
       wready_s_inf,
                    
          bid_s_inf,
        bresp_s_inf,
       bvalid_s_inf,
       bready_s_inf,
                    
         arid_s_inf,
       araddr_s_inf,
        arlen_s_inf,
       arsize_s_inf,
      arburst_s_inf,
      arvalid_s_inf,
                    
      arready_s_inf, 
          rid_s_inf,
        rdata_s_inf,
        rresp_s_inf,
        rlast_s_inf,
       rvalid_s_inf,
       rready_s_inf 
);

// ===============================================================
//  					Parameters Declaration
// ===============================================================
parameter SE_START  = 196608; // (Address)
parameter PIC_START = 262144; // (Address)
parameter CYCLE = `CYCLE_TIME;
parameter PAT_NUM = 20;
// ===============================================================
//  					Input / Output 
// ===============================================================

// << CHIP io port with system >>
input               busy; 

output reg			  	clk;
output reg			  	rst_n;
output reg			   	in_valid;
output reg [1:0]    op;
output reg [3:0]    pic_no;
output reg [5:0]    se_no;
 
// << AXI Interface wire connecttion for pseudo DRAM read/write >>
// (1) 	axi write address channel 
// 		src master
input wire [ID_WIDTH-1:0]      awid_s_inf;
input wire [ADDR_WIDTH-1:0]  awaddr_s_inf;
input wire [2:0]             awsize_s_inf;
input wire [1:0]            awburst_s_inf;
input wire [7:0]              awlen_s_inf;
input wire                  awvalid_s_inf;
// 		src slave
output wire                 awready_s_inf;
// -----------------------------

// (2)	axi write data channel 
// 		src master
input wire [DATA_WIDTH-1:0]   wdata_s_inf;
input wire                    wlast_s_inf;
input wire                   wvalid_s_inf;
// 		src slave
output wire                  wready_s_inf;

// (3)	axi write response channel 
// 		src slave
output wire  [ID_WIDTH-1:0]     bid_s_inf;
output wire  [1:0]            bresp_s_inf;
output wire                  bvalid_s_inf;
// 		src master 
input wire                   bready_s_inf;
// -----------------------------

// (4)	axi read address channel 
// 		src master
input wire [ID_WIDTH-1:0]      arid_s_inf;
input wire [ADDR_WIDTH-1:0]  araddr_s_inf;
input wire [7:0]              arlen_s_inf;
input wire [2:0]             arsize_s_inf;
input wire [1:0]            arburst_s_inf;
input wire                  arvalid_s_inf;
// 		src slave
output wire                 arready_s_inf;
// -----------------------------

// (5)	axi read data channel 
// 		src slave
output wire [ID_WIDTH-1:0]      rid_s_inf;
output wire [DATA_WIDTH-1:0]  rdata_s_inf;
output wire [1:0]             rresp_s_inf;
output wire                   rlast_s_inf;
output wire                  rvalid_s_inf;
// 		src master
input wire                   rready_s_inf;

// ==========================================================================
//  Reg  Declaration
// ==========================================================================

// ==========================================================================
//  integer  Declaration
// ==========================================================================
integer a;
integer pat_i;
integer pat_j;
integer total_latency;
integer latency;
integer f_in;
integer f_ans;
integer pic_number;
integer op_number;
integer i;
integer dram_address;


initial clk = 0;
always #(`CYCLE_TIME/2.0) clk = ~clk;


initial begin
  total_latency = 0;
  in_valid = 0;
  rst_n = 1;
  reset_task;
  @(negedge clk);
  for(pat_i=0;pat_i<PAT_NUM;pat_i=pat_i+1) begin
    f_in  = $fopen($sformatf("../00_TESTBED/INPUT/input_%0d.txt", pat_i) ,"r");
    f_ans = $fopen($sformatf("../00_TESTBED/ANS/ans_%0d.txt", pat_i)   ,"r");
    $readmemh($sformatf("../00_TESTBED/DRAM/dram_%0d.dat", pat_i), u_DRAM.DRAM_r);
    $display("\n\n\033[0;35mDRAM %1d\033[m -----------------------------------------------------------------------------\n", pat_i);
    for(pat_j=0;pat_j<16;pat_j=pat_j+1) begin
      input_task;
      weight_busy;
      check_ans_task;
      @(negedge clk);
    end
  end
  U_PASS_TASK;
  $finish;
end

// ==========================================================================
//  Task
// ==========================================================================

task reset_task;
  begin
    force clk = 0;
    #CYCLE; rst_n = 0;
    #CYCLE; rst_n = 1;
    if(busy!==0) begin
      $display("=====================");  
      $display("     RESET FAIL!     ");  
      $display("=====================");  
      $finish;
    end
    #CYCLE; release clk;
  end
endtask

task input_task;
  begin
    in_valid = 1;
    a = $fscanf(f_in, "%d %d %d", op, se_no, pic_no);
    pic_number = pic_no;
    op_number = op;
    @(negedge clk);
    in_valid = 0;
    op     = 'bx;
    se_no  = 'bx;
    pic_no = 'bx;
  end
endtask

task weight_busy;
  begin
    latency = 0;
    latency = latency + 1;
    @(negedge clk);
    while(busy!==0) begin
      latency = latency + 1;
      if(latency > 100000) begin
        $display("==========================================");  
        $display("                   FAIL!                  ");  
        $display("         Latency OVER 100000 cycles       ");  
        $display("=========================================="); 
        $display("");
        $display("\033[0;33m>>>> PATTERN %2d :\033[m   , OP = %1d", pat_j, op_number); 
        $finish;
      end
      @(negedge clk);
    end
    total_latency = total_latency + latency;
  end
endtask

task debug_task;
  integer cdf_table[0:255];
  begin
    for(i=0;i<256;i=i+1) begin
      cdf_table[i] = 0;
    end
    dram_address = PIC_START + 4096*pic_number;
    for(i=dram_address;i<4096 + dram_address;i=i+1) begin
      cdf_table[u_DRAM.DRAM_r[i]] = cdf_table[u_DRAM.DRAM_r[i]] + 1;
    end
    for(i=0;i<256;i=i+1) begin
      if(i==0)
        cdf_table[i] = cdf_table[i];
      else
        cdf_table[i] = cdf_table[i-1] + cdf_table[i];
    end
    if(pat_j==4) begin
      for(i=0;i<256;i=i+1) begin
        $display("%3d:  %4d", i, cdf_table[i]);
      end
    end
  end
endtask

task check_ans_task;
  reg [7:0] golden_ans;
  reg [5:0] col, row;
  begin
    dram_address = PIC_START + 4096*pic_number;
    for(i=dram_address;i<4096 + dram_address;i=i+1) begin
      a = $fscanf(f_ans, "%d", golden_ans);
      //$write("%3d ", u_DRAM.DRAM_r[i]);
      //if()
      //$display("---- YOUR OUTPUT   : %3d              ", u_DRAM.DRAM_r[i]);
      //$display("---- GOLDEN ANSWER : %3d              ", golden_ans);
      if(u_DRAM.DRAM_r[i] !== golden_ans) begin
        col = (i - dram_address)%64;
        row = (i - dram_address)/64;
        $display("");
        $display("\033[0;31m=========================================\033[m");
        $display("\033[0;31m             WRONG ANSWER !              \033[m");
        $display("\033[0;31m=========================================\033[m");
        $display("");
        $display("\033[0;33m>>>> PATTERN %2d :\033[m   , OP = %1d", pat_j, op_number);
        $display("\033[0;33m---- row = %2d\033[m", row);
        $display("\033[0;33m---- col = %2d\033[m", col);
        $display("");
        $display("---- YOUR OUTPUT   : %3d              ", u_DRAM.DRAM_r[i]);
        $display("---- GOLDEN ANSWER : %3d              ", golden_ans);
        $display("");
        $finish;
      end
    end
    $display("\033[0;36m PATTERN %2d\033[m \033[0;32mIS CORRECT !\033[m , \033[0;33mLatency = %2d\033[m , OP = %1d", pat_j, latency, op_number);		
  end
endtask

task U_PASS_TASK;
  begin
    $display("");
    $display("");
    $display("\033[1;32m======================================================\033[m");
    $display("\033[0;32m                                                      \033[m");
    $display("\033[1;32m                  Simulation SUCCESS                  \033[m");
    $display("\033[0;32m                                                      \033[m");
    $display("\033[1;32m                YOU PASS ALL PATTERNS !               \033[m");
    $display("\033[0;32m                                                      \033[m");
    $display("\033[0;33m           Total Latency =  %d cycles                 \033[m", total_latency);
    $display("\033[0;32m                                                      \033[m");
    $display("\033[1;32m======================================================\033[m");
    $finish;
  end
endtask



// =========================================================
//                 #########################
//                 #    DRAM Connection    # 
//                 #########################
// =========================================================
pseudo_DRAM u_DRAM(

  	  .clk(clk),
  	  .rst_n(rst_n),

   .   awid_s_inf(   awid_s_inf),
   . awaddr_s_inf( awaddr_s_inf),
   . awsize_s_inf( awsize_s_inf),
   .awburst_s_inf(awburst_s_inf),
   .  awlen_s_inf(  awlen_s_inf),
   .awvalid_s_inf(awvalid_s_inf),
   .awready_s_inf(awready_s_inf),

   .  wdata_s_inf(  wdata_s_inf),
   .  wlast_s_inf(  wlast_s_inf),
   . wvalid_s_inf( wvalid_s_inf),
   . wready_s_inf( wready_s_inf),

   .    bid_s_inf(    bid_s_inf),
   .  bresp_s_inf(  bresp_s_inf),
   . bvalid_s_inf( bvalid_s_inf),
   . bready_s_inf( bready_s_inf),

   .   arid_s_inf(   arid_s_inf),
   . araddr_s_inf( araddr_s_inf),
   .  arlen_s_inf(  arlen_s_inf),
   . arsize_s_inf( arsize_s_inf),
   .arburst_s_inf(arburst_s_inf),
   .arvalid_s_inf(arvalid_s_inf),
   .arready_s_inf(arready_s_inf), 

   .    rid_s_inf(    rid_s_inf),
   .  rdata_s_inf(  rdata_s_inf),
   .  rresp_s_inf(  rresp_s_inf),
   .  rlast_s_inf(  rlast_s_inf),
   . rvalid_s_inf( rvalid_s_inf),
   . rready_s_inf( rready_s_inf) 
);


endmodule

