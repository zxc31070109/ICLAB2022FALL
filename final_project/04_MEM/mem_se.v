//
//      CONFIDENTIAL AND PROPRIETARY SOFTWARE/DATA OF ARTISAN COMPONENTS, INC.
//      
//      Copyright (c) 2022 Artisan Components, Inc.  All Rights Reserved.
//      
//      Use of this Software/Data is subject to the terms and conditions of
//      the applicable license agreement between Artisan Components, Inc. and
//      UMC.  In addition, this Software/Data
//      is protected by copyright law and international treaties.
//      
//      The copyright notice(s) in this Software/Data does not indicate actual
//      or intended publication of this Software/Data.
//
//      Verilog model for Synchronous Single-Port Ram
//
//      Instance Name:  mem_se
//      Words:          64
//      Word Width:     128
//      Pipeline:       No
//
//      Creation Date:  2022-11-07 07:39:15Z
//      Version: 	2001Q4V0
//
//      Verified With: Cadence Verilog-XL
//
//      Modeling Assumptions: This model supports full gate level simulation
//          including proper x-handling and timing check behavior.  Unit
//          delay timing is included in the model. Back-annotation of SDF
//          (v2.1) is supported.  SDF can be created utilyzing the delay
//          calculation views provided with this generator and supported
//          delay calculators.  All buses are modeled [MSB:LSB].  All 
//          ports are padded with Verilog primitives.
//
//      Modeling Limitations: The output hold function has been deleted
//          completely from this model.  Most Verilog simulators are 
//          incapable of scheduling more than 1 event on the rising 
//          edge of clock.  Therefore, it is impossible to model
//          the output hold (to x) action correctly.  It is necessary
//          to run static path timing tools using Artisan supplied
//          timing models to insure that the output hold time is
//          sufficient enough to not violate hold time constraints
//          of downstream flip-flops.
//
//      Known Bugs: None.
//
//      Known Work Arounds: N/A
//
`timescale 1 ns/10 ps
`celldefine
module mem_se (
   Q,
   CLK,
   CEN,
   WEN,
   A,
   D,
   OEN
);
   parameter		   BITS = 128;
   parameter		   word_depth = 64;
   parameter		   addr_width = 6;
   parameter		   wordx = {BITS{1'bx}};
   parameter		   addrx = {addr_width{1'bx}};
	
   output [127:0] Q;
   input CLK;
   input CEN;
   input WEN;
   input [5:0] A;
   input [127:0] D;
   input OEN;

   reg [BITS-1:0]	   mem [word_depth-1:0];

   reg			   NOT_CEN;
   reg			   NOT_WEN;

   reg			   NOT_A0;
   reg			   NOT_A1;
   reg			   NOT_A2;
   reg			   NOT_A3;
   reg			   NOT_A4;
   reg			   NOT_A5;
   reg [addr_width-1:0]	   NOT_A;
   reg			   NOT_D0;
   reg			   NOT_D1;
   reg			   NOT_D2;
   reg			   NOT_D3;
   reg			   NOT_D4;
   reg			   NOT_D5;
   reg			   NOT_D6;
   reg			   NOT_D7;
   reg			   NOT_D8;
   reg			   NOT_D9;
   reg			   NOT_D10;
   reg			   NOT_D11;
   reg			   NOT_D12;
   reg			   NOT_D13;
   reg			   NOT_D14;
   reg			   NOT_D15;
   reg			   NOT_D16;
   reg			   NOT_D17;
   reg			   NOT_D18;
   reg			   NOT_D19;
   reg			   NOT_D20;
   reg			   NOT_D21;
   reg			   NOT_D22;
   reg			   NOT_D23;
   reg			   NOT_D24;
   reg			   NOT_D25;
   reg			   NOT_D26;
   reg			   NOT_D27;
   reg			   NOT_D28;
   reg			   NOT_D29;
   reg			   NOT_D30;
   reg			   NOT_D31;
   reg			   NOT_D32;
   reg			   NOT_D33;
   reg			   NOT_D34;
   reg			   NOT_D35;
   reg			   NOT_D36;
   reg			   NOT_D37;
   reg			   NOT_D38;
   reg			   NOT_D39;
   reg			   NOT_D40;
   reg			   NOT_D41;
   reg			   NOT_D42;
   reg			   NOT_D43;
   reg			   NOT_D44;
   reg			   NOT_D45;
   reg			   NOT_D46;
   reg			   NOT_D47;
   reg			   NOT_D48;
   reg			   NOT_D49;
   reg			   NOT_D50;
   reg			   NOT_D51;
   reg			   NOT_D52;
   reg			   NOT_D53;
   reg			   NOT_D54;
   reg			   NOT_D55;
   reg			   NOT_D56;
   reg			   NOT_D57;
   reg			   NOT_D58;
   reg			   NOT_D59;
   reg			   NOT_D60;
   reg			   NOT_D61;
   reg			   NOT_D62;
   reg			   NOT_D63;
   reg			   NOT_D64;
   reg			   NOT_D65;
   reg			   NOT_D66;
   reg			   NOT_D67;
   reg			   NOT_D68;
   reg			   NOT_D69;
   reg			   NOT_D70;
   reg			   NOT_D71;
   reg			   NOT_D72;
   reg			   NOT_D73;
   reg			   NOT_D74;
   reg			   NOT_D75;
   reg			   NOT_D76;
   reg			   NOT_D77;
   reg			   NOT_D78;
   reg			   NOT_D79;
   reg			   NOT_D80;
   reg			   NOT_D81;
   reg			   NOT_D82;
   reg			   NOT_D83;
   reg			   NOT_D84;
   reg			   NOT_D85;
   reg			   NOT_D86;
   reg			   NOT_D87;
   reg			   NOT_D88;
   reg			   NOT_D89;
   reg			   NOT_D90;
   reg			   NOT_D91;
   reg			   NOT_D92;
   reg			   NOT_D93;
   reg			   NOT_D94;
   reg			   NOT_D95;
   reg			   NOT_D96;
   reg			   NOT_D97;
   reg			   NOT_D98;
   reg			   NOT_D99;
   reg			   NOT_D100;
   reg			   NOT_D101;
   reg			   NOT_D102;
   reg			   NOT_D103;
   reg			   NOT_D104;
   reg			   NOT_D105;
   reg			   NOT_D106;
   reg			   NOT_D107;
   reg			   NOT_D108;
   reg			   NOT_D109;
   reg			   NOT_D110;
   reg			   NOT_D111;
   reg			   NOT_D112;
   reg			   NOT_D113;
   reg			   NOT_D114;
   reg			   NOT_D115;
   reg			   NOT_D116;
   reg			   NOT_D117;
   reg			   NOT_D118;
   reg			   NOT_D119;
   reg			   NOT_D120;
   reg			   NOT_D121;
   reg			   NOT_D122;
   reg			   NOT_D123;
   reg			   NOT_D124;
   reg			   NOT_D125;
   reg			   NOT_D126;
   reg			   NOT_D127;
   reg [BITS-1:0]	   NOT_D;
   reg			   NOT_CLK_PER;
   reg			   NOT_CLK_MINH;
   reg			   NOT_CLK_MINL;

   reg			   LAST_NOT_CEN;
   reg			   LAST_NOT_WEN;
   reg [addr_width-1:0]	   LAST_NOT_A;
   reg [BITS-1:0]	   LAST_NOT_D;
   reg			   LAST_NOT_CLK_PER;
   reg			   LAST_NOT_CLK_MINH;
   reg			   LAST_NOT_CLK_MINL;


   wire [BITS-1:0]   _Q;
   wire			   _OENi;
   wire [addr_width-1:0]   _A;
   wire			   _CLK;
   wire			   _CEN;
   wire			   _OEN;
   wire                    _WEN;

   wire [BITS-1:0]   _D;
   wire                    re_flag;
   wire                    re_data_flag;


   reg			   LATCHED_CEN;
   reg	                  LATCHED_WEN;
   reg [addr_width-1:0]	   LATCHED_A;
   reg [BITS-1:0]	   LATCHED_D;

   reg			   CENi;
   reg           	   WENi;
   reg [addr_width-1:0]	   Ai;
   reg [BITS-1:0]	   Di;
   reg [BITS-1:0]	   Qi;
   reg [BITS-1:0]	   LAST_Qi;



   reg			   LAST_CLK;





   task update_notifier_buses;
   begin
      NOT_A = {
               NOT_A5,
               NOT_A4,
               NOT_A3,
               NOT_A2,
               NOT_A1,
               NOT_A0};
      NOT_D = {
               NOT_D127,
               NOT_D126,
               NOT_D125,
               NOT_D124,
               NOT_D123,
               NOT_D122,
               NOT_D121,
               NOT_D120,
               NOT_D119,
               NOT_D118,
               NOT_D117,
               NOT_D116,
               NOT_D115,
               NOT_D114,
               NOT_D113,
               NOT_D112,
               NOT_D111,
               NOT_D110,
               NOT_D109,
               NOT_D108,
               NOT_D107,
               NOT_D106,
               NOT_D105,
               NOT_D104,
               NOT_D103,
               NOT_D102,
               NOT_D101,
               NOT_D100,
               NOT_D99,
               NOT_D98,
               NOT_D97,
               NOT_D96,
               NOT_D95,
               NOT_D94,
               NOT_D93,
               NOT_D92,
               NOT_D91,
               NOT_D90,
               NOT_D89,
               NOT_D88,
               NOT_D87,
               NOT_D86,
               NOT_D85,
               NOT_D84,
               NOT_D83,
               NOT_D82,
               NOT_D81,
               NOT_D80,
               NOT_D79,
               NOT_D78,
               NOT_D77,
               NOT_D76,
               NOT_D75,
               NOT_D74,
               NOT_D73,
               NOT_D72,
               NOT_D71,
               NOT_D70,
               NOT_D69,
               NOT_D68,
               NOT_D67,
               NOT_D66,
               NOT_D65,
               NOT_D64,
               NOT_D63,
               NOT_D62,
               NOT_D61,
               NOT_D60,
               NOT_D59,
               NOT_D58,
               NOT_D57,
               NOT_D56,
               NOT_D55,
               NOT_D54,
               NOT_D53,
               NOT_D52,
               NOT_D51,
               NOT_D50,
               NOT_D49,
               NOT_D48,
               NOT_D47,
               NOT_D46,
               NOT_D45,
               NOT_D44,
               NOT_D43,
               NOT_D42,
               NOT_D41,
               NOT_D40,
               NOT_D39,
               NOT_D38,
               NOT_D37,
               NOT_D36,
               NOT_D35,
               NOT_D34,
               NOT_D33,
               NOT_D32,
               NOT_D31,
               NOT_D30,
               NOT_D29,
               NOT_D28,
               NOT_D27,
               NOT_D26,
               NOT_D25,
               NOT_D24,
               NOT_D23,
               NOT_D22,
               NOT_D21,
               NOT_D20,
               NOT_D19,
               NOT_D18,
               NOT_D17,
               NOT_D16,
               NOT_D15,
               NOT_D14,
               NOT_D13,
               NOT_D12,
               NOT_D11,
               NOT_D10,
               NOT_D9,
               NOT_D8,
               NOT_D7,
               NOT_D6,
               NOT_D5,
               NOT_D4,
               NOT_D3,
               NOT_D2,
               NOT_D1,
               NOT_D0};
   end
   endtask

   task mem_cycle;
   begin
      casez({WENi,CENi})

	2'b10: begin
	   read_mem(1,0);
	end
	2'b00: begin
	   write_mem(Ai,Di);
	   read_mem(0,0);
	end
	2'b?1: ;
	2'b1x: begin
	   read_mem(0,1);
	end
	2'bx0: begin
	   write_mem_x(Ai);
	   read_mem(0,1);
	end
	2'b0x,
	2'bxx: begin
	   write_mem_x(Ai);
	   read_mem(0,1);
	end
      endcase
   end
   endtask
      

   task update_last_notifiers;
   begin
      LAST_NOT_A = NOT_A;
      LAST_NOT_D = NOT_D;
      LAST_NOT_WEN = NOT_WEN;
      LAST_NOT_CEN = NOT_CEN;
      LAST_NOT_CLK_PER = NOT_CLK_PER;
      LAST_NOT_CLK_MINH = NOT_CLK_MINH;
      LAST_NOT_CLK_MINL = NOT_CLK_MINL;
   end
   endtask

   task latch_inputs;
   begin
      LATCHED_A = _A ;
      LATCHED_D = _D ;
      LATCHED_WEN = _WEN ;
      LATCHED_CEN = _CEN ;
      LAST_Qi = Qi;
   end
   endtask


   task update_logic;
   begin
      CENi = LATCHED_CEN;
      WENi = LATCHED_WEN;
      Ai = LATCHED_A;
      Di = LATCHED_D;
   end
   endtask



   task x_inputs;
      integer n;
   begin
      for (n=0; n<addr_width; n=n+1)
	 begin
	    LATCHED_A[n] = (NOT_A[n]!==LAST_NOT_A[n]) ? 1'bx : LATCHED_A[n] ;
	 end
      for (n=0; n<BITS; n=n+1)
	 begin
	    LATCHED_D[n] = (NOT_D[n]!==LAST_NOT_D[n]) ? 1'bx : LATCHED_D[n] ;
	 end
      LATCHED_WEN = (NOT_WEN!==LAST_NOT_WEN) ? 1'bx : LATCHED_WEN ;

      LATCHED_CEN = (NOT_CEN!==LAST_NOT_CEN) ? 1'bx : LATCHED_CEN ;
   end
   endtask

   task read_mem;
      input r_wb;
      input xflag;
   begin
      if (r_wb)
	 begin
	    if (valid_address(Ai))
	       begin
                     Qi=mem[Ai];
	       end
	    else
	       begin
		  Qi=wordx;
	       end
	 end
      else
	 begin
	    if (xflag)
	       begin
		  Qi=wordx;
	       end
	    else
	       begin
	          Qi=Di;
	       end
	 end
   end
   endtask

   task write_mem;
      input [addr_width-1:0] a;
      input [BITS-1:0] d;
 
   begin
      casez({valid_address(a)})
	1'b0: 
		x_mem;
	1'b1: mem[a]=d;
      endcase
   end
   endtask

   task write_mem_x;
      input [addr_width-1:0] a;
   begin
      casez({valid_address(a)})
	1'b0: 
		x_mem;
	1'b1: mem[a]=wordx;
      endcase
   end
   endtask

   task x_mem;
      integer n;
   begin
      for (n=0; n<word_depth; n=n+1)
	 mem[n]=wordx;
   end
   endtask

   task process_violations;
   begin
      if ((NOT_CLK_PER!==LAST_NOT_CLK_PER) ||
	  (NOT_CLK_MINH!==LAST_NOT_CLK_MINH) ||
	  (NOT_CLK_MINL!==LAST_NOT_CLK_MINL))
	 begin
	    if (CENi !== 1'b1)
               begin
		  x_mem;
		  read_mem(0,1);
	       end
	 end
      else
	 begin
	    update_notifier_buses;
	    x_inputs;
	    update_logic;
	    mem_cycle;
	 end
      update_last_notifiers;
   end
   endtask

   function valid_address;
      input [addr_width-1:0] a;
   begin
      valid_address = (^(a) !== 1'bx);
   end
   endfunction


   bufif0 (Q[0], _Q[0], _OENi);
   bufif0 (Q[1], _Q[1], _OENi);
   bufif0 (Q[2], _Q[2], _OENi);
   bufif0 (Q[3], _Q[3], _OENi);
   bufif0 (Q[4], _Q[4], _OENi);
   bufif0 (Q[5], _Q[5], _OENi);
   bufif0 (Q[6], _Q[6], _OENi);
   bufif0 (Q[7], _Q[7], _OENi);
   bufif0 (Q[8], _Q[8], _OENi);
   bufif0 (Q[9], _Q[9], _OENi);
   bufif0 (Q[10], _Q[10], _OENi);
   bufif0 (Q[11], _Q[11], _OENi);
   bufif0 (Q[12], _Q[12], _OENi);
   bufif0 (Q[13], _Q[13], _OENi);
   bufif0 (Q[14], _Q[14], _OENi);
   bufif0 (Q[15], _Q[15], _OENi);
   bufif0 (Q[16], _Q[16], _OENi);
   bufif0 (Q[17], _Q[17], _OENi);
   bufif0 (Q[18], _Q[18], _OENi);
   bufif0 (Q[19], _Q[19], _OENi);
   bufif0 (Q[20], _Q[20], _OENi);
   bufif0 (Q[21], _Q[21], _OENi);
   bufif0 (Q[22], _Q[22], _OENi);
   bufif0 (Q[23], _Q[23], _OENi);
   bufif0 (Q[24], _Q[24], _OENi);
   bufif0 (Q[25], _Q[25], _OENi);
   bufif0 (Q[26], _Q[26], _OENi);
   bufif0 (Q[27], _Q[27], _OENi);
   bufif0 (Q[28], _Q[28], _OENi);
   bufif0 (Q[29], _Q[29], _OENi);
   bufif0 (Q[30], _Q[30], _OENi);
   bufif0 (Q[31], _Q[31], _OENi);
   bufif0 (Q[32], _Q[32], _OENi);
   bufif0 (Q[33], _Q[33], _OENi);
   bufif0 (Q[34], _Q[34], _OENi);
   bufif0 (Q[35], _Q[35], _OENi);
   bufif0 (Q[36], _Q[36], _OENi);
   bufif0 (Q[37], _Q[37], _OENi);
   bufif0 (Q[38], _Q[38], _OENi);
   bufif0 (Q[39], _Q[39], _OENi);
   bufif0 (Q[40], _Q[40], _OENi);
   bufif0 (Q[41], _Q[41], _OENi);
   bufif0 (Q[42], _Q[42], _OENi);
   bufif0 (Q[43], _Q[43], _OENi);
   bufif0 (Q[44], _Q[44], _OENi);
   bufif0 (Q[45], _Q[45], _OENi);
   bufif0 (Q[46], _Q[46], _OENi);
   bufif0 (Q[47], _Q[47], _OENi);
   bufif0 (Q[48], _Q[48], _OENi);
   bufif0 (Q[49], _Q[49], _OENi);
   bufif0 (Q[50], _Q[50], _OENi);
   bufif0 (Q[51], _Q[51], _OENi);
   bufif0 (Q[52], _Q[52], _OENi);
   bufif0 (Q[53], _Q[53], _OENi);
   bufif0 (Q[54], _Q[54], _OENi);
   bufif0 (Q[55], _Q[55], _OENi);
   bufif0 (Q[56], _Q[56], _OENi);
   bufif0 (Q[57], _Q[57], _OENi);
   bufif0 (Q[58], _Q[58], _OENi);
   bufif0 (Q[59], _Q[59], _OENi);
   bufif0 (Q[60], _Q[60], _OENi);
   bufif0 (Q[61], _Q[61], _OENi);
   bufif0 (Q[62], _Q[62], _OENi);
   bufif0 (Q[63], _Q[63], _OENi);
   bufif0 (Q[64], _Q[64], _OENi);
   bufif0 (Q[65], _Q[65], _OENi);
   bufif0 (Q[66], _Q[66], _OENi);
   bufif0 (Q[67], _Q[67], _OENi);
   bufif0 (Q[68], _Q[68], _OENi);
   bufif0 (Q[69], _Q[69], _OENi);
   bufif0 (Q[70], _Q[70], _OENi);
   bufif0 (Q[71], _Q[71], _OENi);
   bufif0 (Q[72], _Q[72], _OENi);
   bufif0 (Q[73], _Q[73], _OENi);
   bufif0 (Q[74], _Q[74], _OENi);
   bufif0 (Q[75], _Q[75], _OENi);
   bufif0 (Q[76], _Q[76], _OENi);
   bufif0 (Q[77], _Q[77], _OENi);
   bufif0 (Q[78], _Q[78], _OENi);
   bufif0 (Q[79], _Q[79], _OENi);
   bufif0 (Q[80], _Q[80], _OENi);
   bufif0 (Q[81], _Q[81], _OENi);
   bufif0 (Q[82], _Q[82], _OENi);
   bufif0 (Q[83], _Q[83], _OENi);
   bufif0 (Q[84], _Q[84], _OENi);
   bufif0 (Q[85], _Q[85], _OENi);
   bufif0 (Q[86], _Q[86], _OENi);
   bufif0 (Q[87], _Q[87], _OENi);
   bufif0 (Q[88], _Q[88], _OENi);
   bufif0 (Q[89], _Q[89], _OENi);
   bufif0 (Q[90], _Q[90], _OENi);
   bufif0 (Q[91], _Q[91], _OENi);
   bufif0 (Q[92], _Q[92], _OENi);
   bufif0 (Q[93], _Q[93], _OENi);
   bufif0 (Q[94], _Q[94], _OENi);
   bufif0 (Q[95], _Q[95], _OENi);
   bufif0 (Q[96], _Q[96], _OENi);
   bufif0 (Q[97], _Q[97], _OENi);
   bufif0 (Q[98], _Q[98], _OENi);
   bufif0 (Q[99], _Q[99], _OENi);
   bufif0 (Q[100], _Q[100], _OENi);
   bufif0 (Q[101], _Q[101], _OENi);
   bufif0 (Q[102], _Q[102], _OENi);
   bufif0 (Q[103], _Q[103], _OENi);
   bufif0 (Q[104], _Q[104], _OENi);
   bufif0 (Q[105], _Q[105], _OENi);
   bufif0 (Q[106], _Q[106], _OENi);
   bufif0 (Q[107], _Q[107], _OENi);
   bufif0 (Q[108], _Q[108], _OENi);
   bufif0 (Q[109], _Q[109], _OENi);
   bufif0 (Q[110], _Q[110], _OENi);
   bufif0 (Q[111], _Q[111], _OENi);
   bufif0 (Q[112], _Q[112], _OENi);
   bufif0 (Q[113], _Q[113], _OENi);
   bufif0 (Q[114], _Q[114], _OENi);
   bufif0 (Q[115], _Q[115], _OENi);
   bufif0 (Q[116], _Q[116], _OENi);
   bufif0 (Q[117], _Q[117], _OENi);
   bufif0 (Q[118], _Q[118], _OENi);
   bufif0 (Q[119], _Q[119], _OENi);
   bufif0 (Q[120], _Q[120], _OENi);
   bufif0 (Q[121], _Q[121], _OENi);
   bufif0 (Q[122], _Q[122], _OENi);
   bufif0 (Q[123], _Q[123], _OENi);
   bufif0 (Q[124], _Q[124], _OENi);
   bufif0 (Q[125], _Q[125], _OENi);
   bufif0 (Q[126], _Q[126], _OENi);
   bufif0 (Q[127], _Q[127], _OENi);
   buf (_D[0], D[0]);
   buf (_D[1], D[1]);
   buf (_D[2], D[2]);
   buf (_D[3], D[3]);
   buf (_D[4], D[4]);
   buf (_D[5], D[5]);
   buf (_D[6], D[6]);
   buf (_D[7], D[7]);
   buf (_D[8], D[8]);
   buf (_D[9], D[9]);
   buf (_D[10], D[10]);
   buf (_D[11], D[11]);
   buf (_D[12], D[12]);
   buf (_D[13], D[13]);
   buf (_D[14], D[14]);
   buf (_D[15], D[15]);
   buf (_D[16], D[16]);
   buf (_D[17], D[17]);
   buf (_D[18], D[18]);
   buf (_D[19], D[19]);
   buf (_D[20], D[20]);
   buf (_D[21], D[21]);
   buf (_D[22], D[22]);
   buf (_D[23], D[23]);
   buf (_D[24], D[24]);
   buf (_D[25], D[25]);
   buf (_D[26], D[26]);
   buf (_D[27], D[27]);
   buf (_D[28], D[28]);
   buf (_D[29], D[29]);
   buf (_D[30], D[30]);
   buf (_D[31], D[31]);
   buf (_D[32], D[32]);
   buf (_D[33], D[33]);
   buf (_D[34], D[34]);
   buf (_D[35], D[35]);
   buf (_D[36], D[36]);
   buf (_D[37], D[37]);
   buf (_D[38], D[38]);
   buf (_D[39], D[39]);
   buf (_D[40], D[40]);
   buf (_D[41], D[41]);
   buf (_D[42], D[42]);
   buf (_D[43], D[43]);
   buf (_D[44], D[44]);
   buf (_D[45], D[45]);
   buf (_D[46], D[46]);
   buf (_D[47], D[47]);
   buf (_D[48], D[48]);
   buf (_D[49], D[49]);
   buf (_D[50], D[50]);
   buf (_D[51], D[51]);
   buf (_D[52], D[52]);
   buf (_D[53], D[53]);
   buf (_D[54], D[54]);
   buf (_D[55], D[55]);
   buf (_D[56], D[56]);
   buf (_D[57], D[57]);
   buf (_D[58], D[58]);
   buf (_D[59], D[59]);
   buf (_D[60], D[60]);
   buf (_D[61], D[61]);
   buf (_D[62], D[62]);
   buf (_D[63], D[63]);
   buf (_D[64], D[64]);
   buf (_D[65], D[65]);
   buf (_D[66], D[66]);
   buf (_D[67], D[67]);
   buf (_D[68], D[68]);
   buf (_D[69], D[69]);
   buf (_D[70], D[70]);
   buf (_D[71], D[71]);
   buf (_D[72], D[72]);
   buf (_D[73], D[73]);
   buf (_D[74], D[74]);
   buf (_D[75], D[75]);
   buf (_D[76], D[76]);
   buf (_D[77], D[77]);
   buf (_D[78], D[78]);
   buf (_D[79], D[79]);
   buf (_D[80], D[80]);
   buf (_D[81], D[81]);
   buf (_D[82], D[82]);
   buf (_D[83], D[83]);
   buf (_D[84], D[84]);
   buf (_D[85], D[85]);
   buf (_D[86], D[86]);
   buf (_D[87], D[87]);
   buf (_D[88], D[88]);
   buf (_D[89], D[89]);
   buf (_D[90], D[90]);
   buf (_D[91], D[91]);
   buf (_D[92], D[92]);
   buf (_D[93], D[93]);
   buf (_D[94], D[94]);
   buf (_D[95], D[95]);
   buf (_D[96], D[96]);
   buf (_D[97], D[97]);
   buf (_D[98], D[98]);
   buf (_D[99], D[99]);
   buf (_D[100], D[100]);
   buf (_D[101], D[101]);
   buf (_D[102], D[102]);
   buf (_D[103], D[103]);
   buf (_D[104], D[104]);
   buf (_D[105], D[105]);
   buf (_D[106], D[106]);
   buf (_D[107], D[107]);
   buf (_D[108], D[108]);
   buf (_D[109], D[109]);
   buf (_D[110], D[110]);
   buf (_D[111], D[111]);
   buf (_D[112], D[112]);
   buf (_D[113], D[113]);
   buf (_D[114], D[114]);
   buf (_D[115], D[115]);
   buf (_D[116], D[116]);
   buf (_D[117], D[117]);
   buf (_D[118], D[118]);
   buf (_D[119], D[119]);
   buf (_D[120], D[120]);
   buf (_D[121], D[121]);
   buf (_D[122], D[122]);
   buf (_D[123], D[123]);
   buf (_D[124], D[124]);
   buf (_D[125], D[125]);
   buf (_D[126], D[126]);
   buf (_D[127], D[127]);
   buf (_A[0], A[0]);
   buf (_A[1], A[1]);
   buf (_A[2], A[2]);
   buf (_A[3], A[3]);
   buf (_A[4], A[4]);
   buf (_A[5], A[5]);
   buf (_CLK, CLK);
   buf (_WEN, WEN);
   buf (_OEN, OEN);
   buf (_CEN, CEN);


   assign _OENi = _OEN;
   assign _Q = Qi;
   assign re_flag = !(_CEN);
   assign re_data_flag = !(_CEN || _WEN);


   always @(
	    NOT_A0 or
	    NOT_A1 or
	    NOT_A2 or
	    NOT_A3 or
	    NOT_A4 or
	    NOT_A5 or
	    NOT_D0 or
	    NOT_D1 or
	    NOT_D2 or
	    NOT_D3 or
	    NOT_D4 or
	    NOT_D5 or
	    NOT_D6 or
	    NOT_D7 or
	    NOT_D8 or
	    NOT_D9 or
	    NOT_D10 or
	    NOT_D11 or
	    NOT_D12 or
	    NOT_D13 or
	    NOT_D14 or
	    NOT_D15 or
	    NOT_D16 or
	    NOT_D17 or
	    NOT_D18 or
	    NOT_D19 or
	    NOT_D20 or
	    NOT_D21 or
	    NOT_D22 or
	    NOT_D23 or
	    NOT_D24 or
	    NOT_D25 or
	    NOT_D26 or
	    NOT_D27 or
	    NOT_D28 or
	    NOT_D29 or
	    NOT_D30 or
	    NOT_D31 or
	    NOT_D32 or
	    NOT_D33 or
	    NOT_D34 or
	    NOT_D35 or
	    NOT_D36 or
	    NOT_D37 or
	    NOT_D38 or
	    NOT_D39 or
	    NOT_D40 or
	    NOT_D41 or
	    NOT_D42 or
	    NOT_D43 or
	    NOT_D44 or
	    NOT_D45 or
	    NOT_D46 or
	    NOT_D47 or
	    NOT_D48 or
	    NOT_D49 or
	    NOT_D50 or
	    NOT_D51 or
	    NOT_D52 or
	    NOT_D53 or
	    NOT_D54 or
	    NOT_D55 or
	    NOT_D56 or
	    NOT_D57 or
	    NOT_D58 or
	    NOT_D59 or
	    NOT_D60 or
	    NOT_D61 or
	    NOT_D62 or
	    NOT_D63 or
	    NOT_D64 or
	    NOT_D65 or
	    NOT_D66 or
	    NOT_D67 or
	    NOT_D68 or
	    NOT_D69 or
	    NOT_D70 or
	    NOT_D71 or
	    NOT_D72 or
	    NOT_D73 or
	    NOT_D74 or
	    NOT_D75 or
	    NOT_D76 or
	    NOT_D77 or
	    NOT_D78 or
	    NOT_D79 or
	    NOT_D80 or
	    NOT_D81 or
	    NOT_D82 or
	    NOT_D83 or
	    NOT_D84 or
	    NOT_D85 or
	    NOT_D86 or
	    NOT_D87 or
	    NOT_D88 or
	    NOT_D89 or
	    NOT_D90 or
	    NOT_D91 or
	    NOT_D92 or
	    NOT_D93 or
	    NOT_D94 or
	    NOT_D95 or
	    NOT_D96 or
	    NOT_D97 or
	    NOT_D98 or
	    NOT_D99 or
	    NOT_D100 or
	    NOT_D101 or
	    NOT_D102 or
	    NOT_D103 or
	    NOT_D104 or
	    NOT_D105 or
	    NOT_D106 or
	    NOT_D107 or
	    NOT_D108 or
	    NOT_D109 or
	    NOT_D110 or
	    NOT_D111 or
	    NOT_D112 or
	    NOT_D113 or
	    NOT_D114 or
	    NOT_D115 or
	    NOT_D116 or
	    NOT_D117 or
	    NOT_D118 or
	    NOT_D119 or
	    NOT_D120 or
	    NOT_D121 or
	    NOT_D122 or
	    NOT_D123 or
	    NOT_D124 or
	    NOT_D125 or
	    NOT_D126 or
	    NOT_D127 or
	    NOT_WEN or
	    NOT_CEN or
	    NOT_CLK_PER or
	    NOT_CLK_MINH or
	    NOT_CLK_MINL
	    )
      begin
         process_violations;
      end

   always @( _CLK )
      begin
         casez({LAST_CLK,_CLK})
	   2'b01: begin
	      latch_inputs;
	      update_logic;
	      mem_cycle;
	   end

	   2'b10,
	   2'bx?,
	   2'b00,
	   2'b11: ;

	   2'b?x: begin
	      x_mem;
              read_mem(0,1);
	   end
	   
	 endcase
	 LAST_CLK = _CLK;
      end

   specify
      $setuphold(posedge CLK,posedge CEN, 1.000, 0.500, NOT_CEN);
      $setuphold(posedge CLK,negedge CEN, 1.000, 0.500, NOT_CEN);
      $setuphold(posedge CLK &&& re_flag,posedge WEN, 1.000, 0.500, NOT_WEN);
      $setuphold(posedge CLK &&& re_flag,negedge WEN, 1.000, 0.500, NOT_WEN);
      $setuphold(posedge CLK &&& re_flag,posedge A[0], 1.000, 0.500, NOT_A0);
      $setuphold(posedge CLK &&& re_flag,negedge A[0], 1.000, 0.500, NOT_A0);
      $setuphold(posedge CLK &&& re_flag,posedge A[1], 1.000, 0.500, NOT_A1);
      $setuphold(posedge CLK &&& re_flag,negedge A[1], 1.000, 0.500, NOT_A1);
      $setuphold(posedge CLK &&& re_flag,posedge A[2], 1.000, 0.500, NOT_A2);
      $setuphold(posedge CLK &&& re_flag,negedge A[2], 1.000, 0.500, NOT_A2);
      $setuphold(posedge CLK &&& re_flag,posedge A[3], 1.000, 0.500, NOT_A3);
      $setuphold(posedge CLK &&& re_flag,negedge A[3], 1.000, 0.500, NOT_A3);
      $setuphold(posedge CLK &&& re_flag,posedge A[4], 1.000, 0.500, NOT_A4);
      $setuphold(posedge CLK &&& re_flag,negedge A[4], 1.000, 0.500, NOT_A4);
      $setuphold(posedge CLK &&& re_flag,posedge A[5], 1.000, 0.500, NOT_A5);
      $setuphold(posedge CLK &&& re_flag,negedge A[5], 1.000, 0.500, NOT_A5);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[0], 1.000, 0.500, NOT_D0);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[0], 1.000, 0.500, NOT_D0);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[1], 1.000, 0.500, NOT_D1);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[1], 1.000, 0.500, NOT_D1);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[2], 1.000, 0.500, NOT_D2);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[2], 1.000, 0.500, NOT_D2);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[3], 1.000, 0.500, NOT_D3);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[3], 1.000, 0.500, NOT_D3);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[4], 1.000, 0.500, NOT_D4);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[4], 1.000, 0.500, NOT_D4);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[5], 1.000, 0.500, NOT_D5);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[5], 1.000, 0.500, NOT_D5);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[6], 1.000, 0.500, NOT_D6);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[6], 1.000, 0.500, NOT_D6);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[7], 1.000, 0.500, NOT_D7);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[7], 1.000, 0.500, NOT_D7);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[8], 1.000, 0.500, NOT_D8);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[8], 1.000, 0.500, NOT_D8);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[9], 1.000, 0.500, NOT_D9);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[9], 1.000, 0.500, NOT_D9);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[10], 1.000, 0.500, NOT_D10);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[10], 1.000, 0.500, NOT_D10);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[11], 1.000, 0.500, NOT_D11);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[11], 1.000, 0.500, NOT_D11);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[12], 1.000, 0.500, NOT_D12);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[12], 1.000, 0.500, NOT_D12);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[13], 1.000, 0.500, NOT_D13);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[13], 1.000, 0.500, NOT_D13);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[14], 1.000, 0.500, NOT_D14);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[14], 1.000, 0.500, NOT_D14);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[15], 1.000, 0.500, NOT_D15);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[15], 1.000, 0.500, NOT_D15);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[16], 1.000, 0.500, NOT_D16);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[16], 1.000, 0.500, NOT_D16);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[17], 1.000, 0.500, NOT_D17);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[17], 1.000, 0.500, NOT_D17);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[18], 1.000, 0.500, NOT_D18);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[18], 1.000, 0.500, NOT_D18);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[19], 1.000, 0.500, NOT_D19);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[19], 1.000, 0.500, NOT_D19);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[20], 1.000, 0.500, NOT_D20);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[20], 1.000, 0.500, NOT_D20);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[21], 1.000, 0.500, NOT_D21);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[21], 1.000, 0.500, NOT_D21);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[22], 1.000, 0.500, NOT_D22);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[22], 1.000, 0.500, NOT_D22);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[23], 1.000, 0.500, NOT_D23);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[23], 1.000, 0.500, NOT_D23);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[24], 1.000, 0.500, NOT_D24);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[24], 1.000, 0.500, NOT_D24);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[25], 1.000, 0.500, NOT_D25);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[25], 1.000, 0.500, NOT_D25);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[26], 1.000, 0.500, NOT_D26);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[26], 1.000, 0.500, NOT_D26);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[27], 1.000, 0.500, NOT_D27);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[27], 1.000, 0.500, NOT_D27);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[28], 1.000, 0.500, NOT_D28);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[28], 1.000, 0.500, NOT_D28);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[29], 1.000, 0.500, NOT_D29);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[29], 1.000, 0.500, NOT_D29);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[30], 1.000, 0.500, NOT_D30);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[30], 1.000, 0.500, NOT_D30);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[31], 1.000, 0.500, NOT_D31);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[31], 1.000, 0.500, NOT_D31);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[32], 1.000, 0.500, NOT_D32);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[32], 1.000, 0.500, NOT_D32);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[33], 1.000, 0.500, NOT_D33);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[33], 1.000, 0.500, NOT_D33);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[34], 1.000, 0.500, NOT_D34);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[34], 1.000, 0.500, NOT_D34);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[35], 1.000, 0.500, NOT_D35);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[35], 1.000, 0.500, NOT_D35);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[36], 1.000, 0.500, NOT_D36);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[36], 1.000, 0.500, NOT_D36);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[37], 1.000, 0.500, NOT_D37);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[37], 1.000, 0.500, NOT_D37);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[38], 1.000, 0.500, NOT_D38);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[38], 1.000, 0.500, NOT_D38);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[39], 1.000, 0.500, NOT_D39);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[39], 1.000, 0.500, NOT_D39);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[40], 1.000, 0.500, NOT_D40);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[40], 1.000, 0.500, NOT_D40);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[41], 1.000, 0.500, NOT_D41);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[41], 1.000, 0.500, NOT_D41);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[42], 1.000, 0.500, NOT_D42);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[42], 1.000, 0.500, NOT_D42);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[43], 1.000, 0.500, NOT_D43);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[43], 1.000, 0.500, NOT_D43);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[44], 1.000, 0.500, NOT_D44);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[44], 1.000, 0.500, NOT_D44);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[45], 1.000, 0.500, NOT_D45);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[45], 1.000, 0.500, NOT_D45);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[46], 1.000, 0.500, NOT_D46);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[46], 1.000, 0.500, NOT_D46);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[47], 1.000, 0.500, NOT_D47);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[47], 1.000, 0.500, NOT_D47);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[48], 1.000, 0.500, NOT_D48);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[48], 1.000, 0.500, NOT_D48);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[49], 1.000, 0.500, NOT_D49);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[49], 1.000, 0.500, NOT_D49);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[50], 1.000, 0.500, NOT_D50);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[50], 1.000, 0.500, NOT_D50);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[51], 1.000, 0.500, NOT_D51);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[51], 1.000, 0.500, NOT_D51);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[52], 1.000, 0.500, NOT_D52);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[52], 1.000, 0.500, NOT_D52);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[53], 1.000, 0.500, NOT_D53);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[53], 1.000, 0.500, NOT_D53);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[54], 1.000, 0.500, NOT_D54);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[54], 1.000, 0.500, NOT_D54);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[55], 1.000, 0.500, NOT_D55);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[55], 1.000, 0.500, NOT_D55);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[56], 1.000, 0.500, NOT_D56);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[56], 1.000, 0.500, NOT_D56);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[57], 1.000, 0.500, NOT_D57);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[57], 1.000, 0.500, NOT_D57);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[58], 1.000, 0.500, NOT_D58);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[58], 1.000, 0.500, NOT_D58);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[59], 1.000, 0.500, NOT_D59);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[59], 1.000, 0.500, NOT_D59);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[60], 1.000, 0.500, NOT_D60);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[60], 1.000, 0.500, NOT_D60);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[61], 1.000, 0.500, NOT_D61);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[61], 1.000, 0.500, NOT_D61);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[62], 1.000, 0.500, NOT_D62);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[62], 1.000, 0.500, NOT_D62);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[63], 1.000, 0.500, NOT_D63);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[63], 1.000, 0.500, NOT_D63);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[64], 1.000, 0.500, NOT_D64);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[64], 1.000, 0.500, NOT_D64);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[65], 1.000, 0.500, NOT_D65);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[65], 1.000, 0.500, NOT_D65);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[66], 1.000, 0.500, NOT_D66);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[66], 1.000, 0.500, NOT_D66);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[67], 1.000, 0.500, NOT_D67);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[67], 1.000, 0.500, NOT_D67);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[68], 1.000, 0.500, NOT_D68);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[68], 1.000, 0.500, NOT_D68);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[69], 1.000, 0.500, NOT_D69);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[69], 1.000, 0.500, NOT_D69);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[70], 1.000, 0.500, NOT_D70);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[70], 1.000, 0.500, NOT_D70);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[71], 1.000, 0.500, NOT_D71);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[71], 1.000, 0.500, NOT_D71);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[72], 1.000, 0.500, NOT_D72);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[72], 1.000, 0.500, NOT_D72);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[73], 1.000, 0.500, NOT_D73);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[73], 1.000, 0.500, NOT_D73);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[74], 1.000, 0.500, NOT_D74);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[74], 1.000, 0.500, NOT_D74);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[75], 1.000, 0.500, NOT_D75);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[75], 1.000, 0.500, NOT_D75);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[76], 1.000, 0.500, NOT_D76);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[76], 1.000, 0.500, NOT_D76);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[77], 1.000, 0.500, NOT_D77);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[77], 1.000, 0.500, NOT_D77);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[78], 1.000, 0.500, NOT_D78);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[78], 1.000, 0.500, NOT_D78);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[79], 1.000, 0.500, NOT_D79);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[79], 1.000, 0.500, NOT_D79);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[80], 1.000, 0.500, NOT_D80);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[80], 1.000, 0.500, NOT_D80);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[81], 1.000, 0.500, NOT_D81);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[81], 1.000, 0.500, NOT_D81);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[82], 1.000, 0.500, NOT_D82);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[82], 1.000, 0.500, NOT_D82);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[83], 1.000, 0.500, NOT_D83);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[83], 1.000, 0.500, NOT_D83);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[84], 1.000, 0.500, NOT_D84);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[84], 1.000, 0.500, NOT_D84);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[85], 1.000, 0.500, NOT_D85);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[85], 1.000, 0.500, NOT_D85);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[86], 1.000, 0.500, NOT_D86);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[86], 1.000, 0.500, NOT_D86);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[87], 1.000, 0.500, NOT_D87);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[87], 1.000, 0.500, NOT_D87);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[88], 1.000, 0.500, NOT_D88);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[88], 1.000, 0.500, NOT_D88);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[89], 1.000, 0.500, NOT_D89);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[89], 1.000, 0.500, NOT_D89);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[90], 1.000, 0.500, NOT_D90);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[90], 1.000, 0.500, NOT_D90);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[91], 1.000, 0.500, NOT_D91);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[91], 1.000, 0.500, NOT_D91);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[92], 1.000, 0.500, NOT_D92);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[92], 1.000, 0.500, NOT_D92);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[93], 1.000, 0.500, NOT_D93);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[93], 1.000, 0.500, NOT_D93);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[94], 1.000, 0.500, NOT_D94);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[94], 1.000, 0.500, NOT_D94);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[95], 1.000, 0.500, NOT_D95);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[95], 1.000, 0.500, NOT_D95);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[96], 1.000, 0.500, NOT_D96);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[96], 1.000, 0.500, NOT_D96);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[97], 1.000, 0.500, NOT_D97);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[97], 1.000, 0.500, NOT_D97);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[98], 1.000, 0.500, NOT_D98);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[98], 1.000, 0.500, NOT_D98);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[99], 1.000, 0.500, NOT_D99);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[99], 1.000, 0.500, NOT_D99);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[100], 1.000, 0.500, NOT_D100);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[100], 1.000, 0.500, NOT_D100);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[101], 1.000, 0.500, NOT_D101);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[101], 1.000, 0.500, NOT_D101);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[102], 1.000, 0.500, NOT_D102);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[102], 1.000, 0.500, NOT_D102);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[103], 1.000, 0.500, NOT_D103);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[103], 1.000, 0.500, NOT_D103);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[104], 1.000, 0.500, NOT_D104);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[104], 1.000, 0.500, NOT_D104);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[105], 1.000, 0.500, NOT_D105);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[105], 1.000, 0.500, NOT_D105);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[106], 1.000, 0.500, NOT_D106);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[106], 1.000, 0.500, NOT_D106);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[107], 1.000, 0.500, NOT_D107);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[107], 1.000, 0.500, NOT_D107);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[108], 1.000, 0.500, NOT_D108);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[108], 1.000, 0.500, NOT_D108);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[109], 1.000, 0.500, NOT_D109);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[109], 1.000, 0.500, NOT_D109);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[110], 1.000, 0.500, NOT_D110);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[110], 1.000, 0.500, NOT_D110);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[111], 1.000, 0.500, NOT_D111);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[111], 1.000, 0.500, NOT_D111);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[112], 1.000, 0.500, NOT_D112);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[112], 1.000, 0.500, NOT_D112);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[113], 1.000, 0.500, NOT_D113);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[113], 1.000, 0.500, NOT_D113);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[114], 1.000, 0.500, NOT_D114);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[114], 1.000, 0.500, NOT_D114);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[115], 1.000, 0.500, NOT_D115);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[115], 1.000, 0.500, NOT_D115);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[116], 1.000, 0.500, NOT_D116);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[116], 1.000, 0.500, NOT_D116);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[117], 1.000, 0.500, NOT_D117);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[117], 1.000, 0.500, NOT_D117);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[118], 1.000, 0.500, NOT_D118);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[118], 1.000, 0.500, NOT_D118);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[119], 1.000, 0.500, NOT_D119);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[119], 1.000, 0.500, NOT_D119);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[120], 1.000, 0.500, NOT_D120);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[120], 1.000, 0.500, NOT_D120);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[121], 1.000, 0.500, NOT_D121);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[121], 1.000, 0.500, NOT_D121);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[122], 1.000, 0.500, NOT_D122);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[122], 1.000, 0.500, NOT_D122);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[123], 1.000, 0.500, NOT_D123);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[123], 1.000, 0.500, NOT_D123);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[124], 1.000, 0.500, NOT_D124);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[124], 1.000, 0.500, NOT_D124);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[125], 1.000, 0.500, NOT_D125);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[125], 1.000, 0.500, NOT_D125);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[126], 1.000, 0.500, NOT_D126);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[126], 1.000, 0.500, NOT_D126);
      $setuphold(posedge CLK &&& re_data_flag,posedge D[127], 1.000, 0.500, NOT_D127);
      $setuphold(posedge CLK &&& re_data_flag,negedge D[127], 1.000, 0.500, NOT_D127);

      $period(posedge CLK, 3.000, NOT_CLK_PER);
      $width(posedge CLK, 1.000, 0, NOT_CLK_MINH);
      $width(negedge CLK, 1.000, 0, NOT_CLK_MINL);

      (posedge CLK => (Q[0]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[1]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[2]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[3]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[4]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[5]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[6]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[7]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[8]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[9]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[10]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[11]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[12]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[13]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[14]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[15]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[16]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[17]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[18]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[19]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[20]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[21]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[22]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[23]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[24]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[25]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[26]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[27]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[28]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[29]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[30]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[31]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[32]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[33]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[34]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[35]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[36]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[37]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[38]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[39]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[40]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[41]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[42]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[43]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[44]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[45]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[46]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[47]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[48]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[49]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[50]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[51]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[52]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[53]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[54]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[55]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[56]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[57]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[58]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[59]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[60]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[61]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[62]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[63]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[64]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[65]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[66]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[67]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[68]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[69]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[70]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[71]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[72]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[73]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[74]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[75]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[76]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[77]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[78]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[79]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[80]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[81]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[82]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[83]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[84]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[85]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[86]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[87]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[88]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[89]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[90]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[91]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[92]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[93]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[94]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[95]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[96]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[97]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[98]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[99]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[100]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[101]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[102]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[103]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[104]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[105]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[106]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[107]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[108]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[109]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[110]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[111]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[112]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[113]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[114]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[115]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[116]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[117]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[118]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[119]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[120]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[121]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[122]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[123]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[124]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[125]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[126]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLK => (Q[127]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge OEN => (Q[0]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[1]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[2]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[3]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[4]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[5]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[6]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[7]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[8]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[9]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[10]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[11]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[12]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[13]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[14]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[15]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[16]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[17]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[18]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[19]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[20]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[21]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[22]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[23]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[24]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[25]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[26]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[27]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[28]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[29]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[30]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[31]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[32]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[33]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[34]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[35]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[36]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[37]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[38]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[39]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[40]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[41]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[42]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[43]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[44]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[45]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[46]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[47]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[48]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[49]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[50]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[51]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[52]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[53]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[54]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[55]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[56]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[57]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[58]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[59]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[60]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[61]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[62]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[63]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[64]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[65]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[66]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[67]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[68]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[69]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[70]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[71]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[72]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[73]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[74]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[75]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[76]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[77]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[78]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[79]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[80]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[81]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[82]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[83]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[84]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[85]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[86]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[87]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[88]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[89]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[90]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[91]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[92]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[93]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[94]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[95]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[96]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[97]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[98]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[99]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[100]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[101]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[102]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[103]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[104]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[105]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[106]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[107]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[108]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[109]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[110]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[111]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[112]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[113]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[114]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[115]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[116]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[117]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[118]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[119]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[120]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[121]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[122]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[123]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[124]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[125]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[126]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OEN => (Q[127]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
   endspecify

endmodule
`endcelldefine
