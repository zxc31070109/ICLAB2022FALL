
`timescale 1ns/10ps

`include "PATTERN.v"
`ifdef RTL
    `include "BP.v"
`endif
`ifdef GATE
    `include "BP_SYN.v"
`endif

module TESTBED;

wire         clk, rst_n, in_valid;
wire  [2:0]  guy;
wire  [1:0]  in0, in1, in2, in3, in4, in5, in6, in7;
wire         out_valid;
wire  [1:0]  out;


initial begin
    `ifdef RTL
        $fsdbDumpfile("BP.fsdb");
        $fsdbDumpvars(0,"+mda");
    `endif
    `ifdef GATE
        $sdf_annotate("BP_SYN.sdf", u_BP);
        $fsdbDumpfile("BP_SYN.fsdb");
    $fsdbDumpvars(0,"+mda"); 
    `endif
end

BP u_BP(
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(in_valid),
	.guy(guy),
    .in0(in0),
    .in1(in1),
    .in2(in2),
    .in3(in3),
    .in4(in4),
    .in5(in5),
    .in6(in6),
    .in7(in7),
    .out_valid(out_valid),
    .out(out)
);
    
PATTERN u_PATTERN(
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(in_valid),
	.guy(guy),
    .in0(in0),
    .in1(in1),
    .in2(in2),
    .in3(in3),
    .in4(in4),
    .in5(in5),
    .in6(in6),
    .in7(in7),
    .out_valid(out_valid),
    .out(out)
);

endmodule
