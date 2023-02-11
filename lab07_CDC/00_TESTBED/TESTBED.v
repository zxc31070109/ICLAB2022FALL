`timescale 1ns/1ps
`include "PATTERN.v"

`ifdef RTL
	`include "CDC.v"
`elsif GATE
	`include "CDC_SYN.v"
`endif

module TESTBED();

wire		clk1, clk2, clk3, rst_n;
wire		in_valid1, in_valid2;
wire [3:0]	user1, user2;
wire 		out_valid1, out_valid2;
wire		equal, exceed, winner;


initial begin
  `ifdef RTL
    $fsdbDumpfile("CDC.fsdb");
	$fsdbDumpvars(0,"+mda");
  `endif
  `ifdef GATE
    $sdf_annotate("CDC_SYN_pt.sdf", u_CDC,,,"maximum");
    //$fsdbDumpfile("CDC_SYN.fsdb");
	//$fsdbDumpvars(0,"+mda"); 
  `endif
end

CDC u_CDC(
    .clk1(clk1),
    .clk2(clk2),
    .clk3(clk3),
	.rst_n(rst_n),
    .in_valid1(in_valid1),
    .in_valid2(in_valid2),
	.user1(user1),
	.user2(user2),

    .out_valid1(out_valid1),
    .out_valid2(out_valid2),
	.equal(equal),
	.exceed(exceed),
	.winner(winner)
    );
	
PATTERN u_PATTERN(
    .clk1(clk1),
    .clk2(clk2),
    .clk3(clk3),
	.rst_n(rst_n),
    .in_valid1(in_valid1),
    .in_valid2(in_valid2),
	.user1(user1),
	.user2(user2),

    .out_valid1(out_valid1),
    .out_valid2(out_valid2),
	.equal(equal),
	.exceed(exceed),
	.winner(winner)
    );
  
endmodule
