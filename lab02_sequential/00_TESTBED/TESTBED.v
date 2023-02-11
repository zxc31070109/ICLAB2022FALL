`timescale 1ns/1ps

`include "PATTERN.v"
`ifdef RTL
  `include "TT.v"
`endif
`ifdef GATE
  `include "TT_SYN.v"
`endif
	  		  	
module TESTBED;

wire         clk, rst_n, in_valid;
wire  [3:0]  source;
wire  [3:0]  destination;

wire         out_valid;
wire  [3:0]  cost;


initial begin
  `ifdef RTL
    //$fsdbDumpfile("TT.fsdb");
	  //$fsdbDumpvars(0,"+mda");
    //$fsdbDumpvars();
  `endif
  `ifdef GATE
    $sdf_annotate("TT_SYN.sdf", u_TT);
    //$fsdbDumpfile("TT_SYN.fsdb");
	  //$fsdbDumpvars(0,"+mda");
    //$fsdbDumpvars();    
  `endif
end

TT u_TT(
    .clk            (   clk          ),
    .rst_n          (   rst_n        ),
    .in_valid       (   in_valid     ),
    .source         (   source       ),
    .destination    (   destination  ),

    .out_valid      (   out_valid    ),
    .cost           (   cost         )
   );
	
PATTERN u_PATTERN(
    .clk            (   clk          ),
    .rst_n          (   rst_n        ),
    .in_valid       (   in_valid     ),
    .source         (   source       ),
    .destination    (   destination  ),

    .out_valid      (   out_valid    ),
    .cost           (   cost         )
   );
  
 
endmodule
