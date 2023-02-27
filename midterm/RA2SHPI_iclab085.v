//
//      CONFIDENTIAL AND PROPRIETARY SOFTWARE/DATA OF ARTISAN COMPONENTS, INC.
//      
//      Copyright (c) 2022 Artisan Components, Inc.  All Rights Reserved.
//      
//      Use of this Software/Data is subject to the terms and conditions of
//      the applicable license agreement between Artisan Components, Inc. and
//      Taiwan Semiconductor Manufacturing Ltd..  In addition, this Software/Data
//      is protected by copyright law and international treaties.
//      
//      The copyright notice(s) in this Software/Data does not indicate actual
//      or intended publication of this Software/Data.
//
//      Verilog model for Synchronous Dual-Port Ram
//
//      Instance Name:  RA2SHPI
//      Words:          256
//      Word Width:     128
//      Pipeline:       No
//
//      Creation Date:  2022-11-08 17:54:31Z
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
module RA2SHPI (
   QA,
   CLKA,
   CENA,
   WENA,
   AA,
   DA,
   OENA,
   QB,
   CLKB,
   CENB,
   WENB,
   AB,
   DB,
   OENB
);
   parameter		   BITS = 128;
   parameter		   word_depth = 256;
   parameter		   addr_width = 8;
   parameter		   wordx = {BITS{1'bx}};
   parameter		   addrx = {addr_width{1'bx}};
	
   output [127:0] QA;
   input CLKA;
   input CENA;
   input WENA;
   input [7:0] AA;
   input [127:0] DA;
   input OENA;
   output [127:0] QB;
   input CLKB;
   input CENB;
   input WENB;
   input [7:0] AB;
   input [127:0] DB;
   input OENB;

   reg [BITS-1:0]	   mem [word_depth-1:0];
   reg                     NOT_CONTA;
   reg                     NOT_CONTB;

   reg			   NOT_CENA;
   reg			   NOT_WENA;

   reg			   NOT_AA0;
   reg			   NOT_AA1;
   reg			   NOT_AA2;
   reg			   NOT_AA3;
   reg			   NOT_AA4;
   reg			   NOT_AA5;
   reg			   NOT_AA6;
   reg			   NOT_AA7;
   reg [addr_width-1:0]	   NOT_AA;
   reg			   NOT_DA0;
   reg			   NOT_DA1;
   reg			   NOT_DA2;
   reg			   NOT_DA3;
   reg			   NOT_DA4;
   reg			   NOT_DA5;
   reg			   NOT_DA6;
   reg			   NOT_DA7;
   reg			   NOT_DA8;
   reg			   NOT_DA9;
   reg			   NOT_DA10;
   reg			   NOT_DA11;
   reg			   NOT_DA12;
   reg			   NOT_DA13;
   reg			   NOT_DA14;
   reg			   NOT_DA15;
   reg			   NOT_DA16;
   reg			   NOT_DA17;
   reg			   NOT_DA18;
   reg			   NOT_DA19;
   reg			   NOT_DA20;
   reg			   NOT_DA21;
   reg			   NOT_DA22;
   reg			   NOT_DA23;
   reg			   NOT_DA24;
   reg			   NOT_DA25;
   reg			   NOT_DA26;
   reg			   NOT_DA27;
   reg			   NOT_DA28;
   reg			   NOT_DA29;
   reg			   NOT_DA30;
   reg			   NOT_DA31;
   reg			   NOT_DA32;
   reg			   NOT_DA33;
   reg			   NOT_DA34;
   reg			   NOT_DA35;
   reg			   NOT_DA36;
   reg			   NOT_DA37;
   reg			   NOT_DA38;
   reg			   NOT_DA39;
   reg			   NOT_DA40;
   reg			   NOT_DA41;
   reg			   NOT_DA42;
   reg			   NOT_DA43;
   reg			   NOT_DA44;
   reg			   NOT_DA45;
   reg			   NOT_DA46;
   reg			   NOT_DA47;
   reg			   NOT_DA48;
   reg			   NOT_DA49;
   reg			   NOT_DA50;
   reg			   NOT_DA51;
   reg			   NOT_DA52;
   reg			   NOT_DA53;
   reg			   NOT_DA54;
   reg			   NOT_DA55;
   reg			   NOT_DA56;
   reg			   NOT_DA57;
   reg			   NOT_DA58;
   reg			   NOT_DA59;
   reg			   NOT_DA60;
   reg			   NOT_DA61;
   reg			   NOT_DA62;
   reg			   NOT_DA63;
   reg			   NOT_DA64;
   reg			   NOT_DA65;
   reg			   NOT_DA66;
   reg			   NOT_DA67;
   reg			   NOT_DA68;
   reg			   NOT_DA69;
   reg			   NOT_DA70;
   reg			   NOT_DA71;
   reg			   NOT_DA72;
   reg			   NOT_DA73;
   reg			   NOT_DA74;
   reg			   NOT_DA75;
   reg			   NOT_DA76;
   reg			   NOT_DA77;
   reg			   NOT_DA78;
   reg			   NOT_DA79;
   reg			   NOT_DA80;
   reg			   NOT_DA81;
   reg			   NOT_DA82;
   reg			   NOT_DA83;
   reg			   NOT_DA84;
   reg			   NOT_DA85;
   reg			   NOT_DA86;
   reg			   NOT_DA87;
   reg			   NOT_DA88;
   reg			   NOT_DA89;
   reg			   NOT_DA90;
   reg			   NOT_DA91;
   reg			   NOT_DA92;
   reg			   NOT_DA93;
   reg			   NOT_DA94;
   reg			   NOT_DA95;
   reg			   NOT_DA96;
   reg			   NOT_DA97;
   reg			   NOT_DA98;
   reg			   NOT_DA99;
   reg			   NOT_DA100;
   reg			   NOT_DA101;
   reg			   NOT_DA102;
   reg			   NOT_DA103;
   reg			   NOT_DA104;
   reg			   NOT_DA105;
   reg			   NOT_DA106;
   reg			   NOT_DA107;
   reg			   NOT_DA108;
   reg			   NOT_DA109;
   reg			   NOT_DA110;
   reg			   NOT_DA111;
   reg			   NOT_DA112;
   reg			   NOT_DA113;
   reg			   NOT_DA114;
   reg			   NOT_DA115;
   reg			   NOT_DA116;
   reg			   NOT_DA117;
   reg			   NOT_DA118;
   reg			   NOT_DA119;
   reg			   NOT_DA120;
   reg			   NOT_DA121;
   reg			   NOT_DA122;
   reg			   NOT_DA123;
   reg			   NOT_DA124;
   reg			   NOT_DA125;
   reg			   NOT_DA126;
   reg			   NOT_DA127;
   reg [BITS-1:0]	   NOT_DA;
   reg			   NOT_CLKA_PER;
   reg			   NOT_CLKA_MINH;
   reg			   NOT_CLKA_MINL;
   reg			   NOT_CENB;
   reg			   NOT_WENB;

   reg			   NOT_AB0;
   reg			   NOT_AB1;
   reg			   NOT_AB2;
   reg			   NOT_AB3;
   reg			   NOT_AB4;
   reg			   NOT_AB5;
   reg			   NOT_AB6;
   reg			   NOT_AB7;
   reg [addr_width-1:0]	   NOT_AB;
   reg			   NOT_DB0;
   reg			   NOT_DB1;
   reg			   NOT_DB2;
   reg			   NOT_DB3;
   reg			   NOT_DB4;
   reg			   NOT_DB5;
   reg			   NOT_DB6;
   reg			   NOT_DB7;
   reg			   NOT_DB8;
   reg			   NOT_DB9;
   reg			   NOT_DB10;
   reg			   NOT_DB11;
   reg			   NOT_DB12;
   reg			   NOT_DB13;
   reg			   NOT_DB14;
   reg			   NOT_DB15;
   reg			   NOT_DB16;
   reg			   NOT_DB17;
   reg			   NOT_DB18;
   reg			   NOT_DB19;
   reg			   NOT_DB20;
   reg			   NOT_DB21;
   reg			   NOT_DB22;
   reg			   NOT_DB23;
   reg			   NOT_DB24;
   reg			   NOT_DB25;
   reg			   NOT_DB26;
   reg			   NOT_DB27;
   reg			   NOT_DB28;
   reg			   NOT_DB29;
   reg			   NOT_DB30;
   reg			   NOT_DB31;
   reg			   NOT_DB32;
   reg			   NOT_DB33;
   reg			   NOT_DB34;
   reg			   NOT_DB35;
   reg			   NOT_DB36;
   reg			   NOT_DB37;
   reg			   NOT_DB38;
   reg			   NOT_DB39;
   reg			   NOT_DB40;
   reg			   NOT_DB41;
   reg			   NOT_DB42;
   reg			   NOT_DB43;
   reg			   NOT_DB44;
   reg			   NOT_DB45;
   reg			   NOT_DB46;
   reg			   NOT_DB47;
   reg			   NOT_DB48;
   reg			   NOT_DB49;
   reg			   NOT_DB50;
   reg			   NOT_DB51;
   reg			   NOT_DB52;
   reg			   NOT_DB53;
   reg			   NOT_DB54;
   reg			   NOT_DB55;
   reg			   NOT_DB56;
   reg			   NOT_DB57;
   reg			   NOT_DB58;
   reg			   NOT_DB59;
   reg			   NOT_DB60;
   reg			   NOT_DB61;
   reg			   NOT_DB62;
   reg			   NOT_DB63;
   reg			   NOT_DB64;
   reg			   NOT_DB65;
   reg			   NOT_DB66;
   reg			   NOT_DB67;
   reg			   NOT_DB68;
   reg			   NOT_DB69;
   reg			   NOT_DB70;
   reg			   NOT_DB71;
   reg			   NOT_DB72;
   reg			   NOT_DB73;
   reg			   NOT_DB74;
   reg			   NOT_DB75;
   reg			   NOT_DB76;
   reg			   NOT_DB77;
   reg			   NOT_DB78;
   reg			   NOT_DB79;
   reg			   NOT_DB80;
   reg			   NOT_DB81;
   reg			   NOT_DB82;
   reg			   NOT_DB83;
   reg			   NOT_DB84;
   reg			   NOT_DB85;
   reg			   NOT_DB86;
   reg			   NOT_DB87;
   reg			   NOT_DB88;
   reg			   NOT_DB89;
   reg			   NOT_DB90;
   reg			   NOT_DB91;
   reg			   NOT_DB92;
   reg			   NOT_DB93;
   reg			   NOT_DB94;
   reg			   NOT_DB95;
   reg			   NOT_DB96;
   reg			   NOT_DB97;
   reg			   NOT_DB98;
   reg			   NOT_DB99;
   reg			   NOT_DB100;
   reg			   NOT_DB101;
   reg			   NOT_DB102;
   reg			   NOT_DB103;
   reg			   NOT_DB104;
   reg			   NOT_DB105;
   reg			   NOT_DB106;
   reg			   NOT_DB107;
   reg			   NOT_DB108;
   reg			   NOT_DB109;
   reg			   NOT_DB110;
   reg			   NOT_DB111;
   reg			   NOT_DB112;
   reg			   NOT_DB113;
   reg			   NOT_DB114;
   reg			   NOT_DB115;
   reg			   NOT_DB116;
   reg			   NOT_DB117;
   reg			   NOT_DB118;
   reg			   NOT_DB119;
   reg			   NOT_DB120;
   reg			   NOT_DB121;
   reg			   NOT_DB122;
   reg			   NOT_DB123;
   reg			   NOT_DB124;
   reg			   NOT_DB125;
   reg			   NOT_DB126;
   reg			   NOT_DB127;
   reg [BITS-1:0]	   NOT_DB;
   reg			   NOT_CLKB_PER;
   reg			   NOT_CLKB_MINH;
   reg			   NOT_CLKB_MINL;

   reg			   LAST_NOT_CENA;
   reg			   LAST_NOT_WENA;
   reg [addr_width-1:0]	   LAST_NOT_AA;
   reg [BITS-1:0]	   LAST_NOT_DA;
   reg			   LAST_NOT_CLKA_PER;
   reg			   LAST_NOT_CLKA_MINH;
   reg			   LAST_NOT_CLKA_MINL;
   reg			   LAST_NOT_CENB;
   reg			   LAST_NOT_WENB;
   reg [addr_width-1:0]	   LAST_NOT_AB;
   reg [BITS-1:0]	   LAST_NOT_DB;
   reg			   LAST_NOT_CLKB_PER;
   reg			   LAST_NOT_CLKB_MINH;
   reg			   LAST_NOT_CLKB_MINL;

   reg                     LAST_NOT_CONTA;
   reg                     LAST_NOT_CONTB;
   wire                    contA_flag;
   wire                    contB_flag;
   wire                    cont_flag;

   wire [BITS-1:0]   _QA;
   wire			   _OENAi;
   wire [addr_width-1:0]   _AA;
   wire			   _CLKA;
   wire			   _CENA;
   wire			   _OENA;
   wire                    _WENA;

   wire [BITS-1:0]   _DA;
   wire                    re_flagA;
   wire                    re_data_flagA;

   wire [BITS-1:0]   _QB;
   wire			   _OENBi;
   wire [addr_width-1:0]   _AB;
   wire			   _CLKB;
   wire			   _CENB;
   wire			   _OENB;
   wire                    _WENB;

   wire [BITS-1:0]   _DB;
   wire                    re_flagB;
   wire                    re_data_flagB;


   reg			   LATCHED_CENA;
   reg	                  LATCHED_WENA;
   reg [addr_width-1:0]	   LATCHED_AA;
   reg [BITS-1:0]	   LATCHED_DA;
   reg			   LATCHED_CENB;
   reg	                  LATCHED_WENB;
   reg [addr_width-1:0]	   LATCHED_AB;
   reg [BITS-1:0]	   LATCHED_DB;

   reg			   CENAi;
   reg           	   WENAi;
   reg [addr_width-1:0]	   AAi;
   reg [BITS-1:0]	   DAi;
   reg [BITS-1:0]	   QAi;
   reg [BITS-1:0]	   LAST_QAi;
   reg			   CENBi;
   reg           	   WENBi;
   reg [addr_width-1:0]	   ABi;
   reg [BITS-1:0]	   DBi;
   reg [BITS-1:0]	   QBi;
   reg [BITS-1:0]	   LAST_QBi;



   reg			   LAST_CLKA;
   reg			   LAST_CLKB;



   reg                     valid_cycleA;
   reg                     valid_cycleB;


   task update_Anotifier_buses;
   begin
      NOT_AA = {
               NOT_AA7,
               NOT_AA6,
               NOT_AA5,
               NOT_AA4,
               NOT_AA3,
               NOT_AA2,
               NOT_AA1,
               NOT_AA0};
      NOT_DA = {
               NOT_DA127,
               NOT_DA126,
               NOT_DA125,
               NOT_DA124,
               NOT_DA123,
               NOT_DA122,
               NOT_DA121,
               NOT_DA120,
               NOT_DA119,
               NOT_DA118,
               NOT_DA117,
               NOT_DA116,
               NOT_DA115,
               NOT_DA114,
               NOT_DA113,
               NOT_DA112,
               NOT_DA111,
               NOT_DA110,
               NOT_DA109,
               NOT_DA108,
               NOT_DA107,
               NOT_DA106,
               NOT_DA105,
               NOT_DA104,
               NOT_DA103,
               NOT_DA102,
               NOT_DA101,
               NOT_DA100,
               NOT_DA99,
               NOT_DA98,
               NOT_DA97,
               NOT_DA96,
               NOT_DA95,
               NOT_DA94,
               NOT_DA93,
               NOT_DA92,
               NOT_DA91,
               NOT_DA90,
               NOT_DA89,
               NOT_DA88,
               NOT_DA87,
               NOT_DA86,
               NOT_DA85,
               NOT_DA84,
               NOT_DA83,
               NOT_DA82,
               NOT_DA81,
               NOT_DA80,
               NOT_DA79,
               NOT_DA78,
               NOT_DA77,
               NOT_DA76,
               NOT_DA75,
               NOT_DA74,
               NOT_DA73,
               NOT_DA72,
               NOT_DA71,
               NOT_DA70,
               NOT_DA69,
               NOT_DA68,
               NOT_DA67,
               NOT_DA66,
               NOT_DA65,
               NOT_DA64,
               NOT_DA63,
               NOT_DA62,
               NOT_DA61,
               NOT_DA60,
               NOT_DA59,
               NOT_DA58,
               NOT_DA57,
               NOT_DA56,
               NOT_DA55,
               NOT_DA54,
               NOT_DA53,
               NOT_DA52,
               NOT_DA51,
               NOT_DA50,
               NOT_DA49,
               NOT_DA48,
               NOT_DA47,
               NOT_DA46,
               NOT_DA45,
               NOT_DA44,
               NOT_DA43,
               NOT_DA42,
               NOT_DA41,
               NOT_DA40,
               NOT_DA39,
               NOT_DA38,
               NOT_DA37,
               NOT_DA36,
               NOT_DA35,
               NOT_DA34,
               NOT_DA33,
               NOT_DA32,
               NOT_DA31,
               NOT_DA30,
               NOT_DA29,
               NOT_DA28,
               NOT_DA27,
               NOT_DA26,
               NOT_DA25,
               NOT_DA24,
               NOT_DA23,
               NOT_DA22,
               NOT_DA21,
               NOT_DA20,
               NOT_DA19,
               NOT_DA18,
               NOT_DA17,
               NOT_DA16,
               NOT_DA15,
               NOT_DA14,
               NOT_DA13,
               NOT_DA12,
               NOT_DA11,
               NOT_DA10,
               NOT_DA9,
               NOT_DA8,
               NOT_DA7,
               NOT_DA6,
               NOT_DA5,
               NOT_DA4,
               NOT_DA3,
               NOT_DA2,
               NOT_DA1,
               NOT_DA0};
   end
   endtask
   task update_Bnotifier_buses;
   begin
      NOT_AB = {
               NOT_AB7,
               NOT_AB6,
               NOT_AB5,
               NOT_AB4,
               NOT_AB3,
               NOT_AB2,
               NOT_AB1,
               NOT_AB0};
      NOT_DB = {
               NOT_DB127,
               NOT_DB126,
               NOT_DB125,
               NOT_DB124,
               NOT_DB123,
               NOT_DB122,
               NOT_DB121,
               NOT_DB120,
               NOT_DB119,
               NOT_DB118,
               NOT_DB117,
               NOT_DB116,
               NOT_DB115,
               NOT_DB114,
               NOT_DB113,
               NOT_DB112,
               NOT_DB111,
               NOT_DB110,
               NOT_DB109,
               NOT_DB108,
               NOT_DB107,
               NOT_DB106,
               NOT_DB105,
               NOT_DB104,
               NOT_DB103,
               NOT_DB102,
               NOT_DB101,
               NOT_DB100,
               NOT_DB99,
               NOT_DB98,
               NOT_DB97,
               NOT_DB96,
               NOT_DB95,
               NOT_DB94,
               NOT_DB93,
               NOT_DB92,
               NOT_DB91,
               NOT_DB90,
               NOT_DB89,
               NOT_DB88,
               NOT_DB87,
               NOT_DB86,
               NOT_DB85,
               NOT_DB84,
               NOT_DB83,
               NOT_DB82,
               NOT_DB81,
               NOT_DB80,
               NOT_DB79,
               NOT_DB78,
               NOT_DB77,
               NOT_DB76,
               NOT_DB75,
               NOT_DB74,
               NOT_DB73,
               NOT_DB72,
               NOT_DB71,
               NOT_DB70,
               NOT_DB69,
               NOT_DB68,
               NOT_DB67,
               NOT_DB66,
               NOT_DB65,
               NOT_DB64,
               NOT_DB63,
               NOT_DB62,
               NOT_DB61,
               NOT_DB60,
               NOT_DB59,
               NOT_DB58,
               NOT_DB57,
               NOT_DB56,
               NOT_DB55,
               NOT_DB54,
               NOT_DB53,
               NOT_DB52,
               NOT_DB51,
               NOT_DB50,
               NOT_DB49,
               NOT_DB48,
               NOT_DB47,
               NOT_DB46,
               NOT_DB45,
               NOT_DB44,
               NOT_DB43,
               NOT_DB42,
               NOT_DB41,
               NOT_DB40,
               NOT_DB39,
               NOT_DB38,
               NOT_DB37,
               NOT_DB36,
               NOT_DB35,
               NOT_DB34,
               NOT_DB33,
               NOT_DB32,
               NOT_DB31,
               NOT_DB30,
               NOT_DB29,
               NOT_DB28,
               NOT_DB27,
               NOT_DB26,
               NOT_DB25,
               NOT_DB24,
               NOT_DB23,
               NOT_DB22,
               NOT_DB21,
               NOT_DB20,
               NOT_DB19,
               NOT_DB18,
               NOT_DB17,
               NOT_DB16,
               NOT_DB15,
               NOT_DB14,
               NOT_DB13,
               NOT_DB12,
               NOT_DB11,
               NOT_DB10,
               NOT_DB9,
               NOT_DB8,
               NOT_DB7,
               NOT_DB6,
               NOT_DB5,
               NOT_DB4,
               NOT_DB3,
               NOT_DB2,
               NOT_DB1,
               NOT_DB0};
   end
   endtask

   task mem_cycleA;
   begin
      valid_cycleA = 1'bx;
      casez({WENAi,CENAi})

	2'b10: begin
	   valid_cycleA = 1;
	   read_memA(1,0);
	end
	2'b00: begin
	   valid_cycleA = 0;
	   write_mem(AAi,DAi);
	   read_memA(0,0);
	end
	2'b?1: ;
	2'b1x: begin
	   valid_cycleA = 1;
	   read_memA(0,1);
	end
	2'bx0: begin
	   valid_cycleA = 0;
	   write_mem_x(AAi);
	   read_memA(0,1);
	end
	2'b0x,
	2'bxx: begin
	   valid_cycleA = 0;
	   write_mem_x(AAi);
	   read_memA(0,1);
	end
      endcase
   end
   endtask
   task mem_cycleB;
   begin
      valid_cycleB = 1'bx;
      casez({WENBi,CENBi})

	2'b10: begin
	   valid_cycleB = 1;
	   read_memB(1,0);
	end
	2'b00: begin
	   valid_cycleB = 0;
	   write_mem(ABi,DBi);
	   read_memB(0,0);
	end
	2'b?1: ;
	2'b1x: begin
	   valid_cycleB = 1;
	   read_memB(0,1);
	end
	2'bx0: begin
	   valid_cycleB = 0;
	   write_mem_x(ABi);
	   read_memB(0,1);
	end
	2'b0x,
	2'bxx: begin
	   valid_cycleB = 0;
	   write_mem_x(ABi);
	   read_memB(0,1);
	end
      endcase
   end
   endtask
      
   task contentionA;
   begin
      casez({valid_cycleB,WENAi})
	2'bx?: ;
	2'b00,
	2'b0x:begin
           write_mem_x(AAi);
	end
	2'b10,
	2'b1x:begin
	   read_memB(0,1);
	end
	2'b01:begin
	   read_memA(0,1);
	end
	2'b11: ;
      endcase
   end
   endtask

   task contentionB;
   begin
      casez({valid_cycleA,WENBi})
	2'bx?: ;
	2'b00,
	2'b0x:begin
	   write_mem_x(ABi);
	end
	2'b10,
	2'b1x:begin
	   read_memA(0,1);
	end
	2'b01:begin
	   read_memB(0,1);
	end
	2'b11: ;
      endcase
   end
   endtask

   task update_Alast_notifiers;
   begin
      LAST_NOT_AA = NOT_AA;
      LAST_NOT_DA = NOT_DA;
      LAST_NOT_WENA = NOT_WENA;
      LAST_NOT_CENA = NOT_CENA;
      LAST_NOT_CLKA_PER = NOT_CLKA_PER;
      LAST_NOT_CLKA_MINH = NOT_CLKA_MINH;
      LAST_NOT_CLKA_MINL = NOT_CLKA_MINL;
      LAST_NOT_CONTA = NOT_CONTA;
   end
   endtask
   task update_Blast_notifiers;
   begin
      LAST_NOT_AB = NOT_AB;
      LAST_NOT_DB = NOT_DB;
      LAST_NOT_WENB = NOT_WENB;
      LAST_NOT_CENB = NOT_CENB;
      LAST_NOT_CLKB_PER = NOT_CLKB_PER;
      LAST_NOT_CLKB_MINH = NOT_CLKB_MINH;
      LAST_NOT_CLKB_MINL = NOT_CLKB_MINL;
      LAST_NOT_CONTB = NOT_CONTB;
   end
   endtask

   task latch_Ainputs;
   begin
      LATCHED_AA = _AA ;
      LATCHED_DA = _DA ;
      LATCHED_WENA = _WENA ;
      LATCHED_CENA = _CENA ;
      LAST_QAi = QAi;
   end
   endtask
   task latch_Binputs;
   begin
      LATCHED_AB = _AB ;
      LATCHED_DB = _DB ;
      LATCHED_WENB = _WENB ;
      LATCHED_CENB = _CENB ;
      LAST_QBi = QBi;
   end
   endtask


   task update_Alogic;
   begin
      CENAi = LATCHED_CENA;
      WENAi = LATCHED_WENA;
      AAi = LATCHED_AA;
      DAi = LATCHED_DA;
   end
   endtask
   task update_Blogic;
   begin
      CENBi = LATCHED_CENB;
      WENBi = LATCHED_WENB;
      ABi = LATCHED_AB;
      DBi = LATCHED_DB;
   end
   endtask



   task x_Ainputs;
      integer n;
   begin
      for (n=0; n<addr_width; n=n+1)
	 begin
	    LATCHED_AA[n] = (NOT_AA[n]!==LAST_NOT_AA[n]) ? 1'bx : LATCHED_AA[n] ;
	 end
      for (n=0; n<BITS; n=n+1)
	 begin
	    LATCHED_DA[n] = (NOT_DA[n]!==LAST_NOT_DA[n]) ? 1'bx : LATCHED_DA[n] ;
	 end
      LATCHED_WENA = (NOT_WENA!==LAST_NOT_WENA) ? 1'bx : LATCHED_WENA ;

      LATCHED_CENA = (NOT_CENA!==LAST_NOT_CENA) ? 1'bx : LATCHED_CENA ;
   end
   endtask
   task x_Binputs;
      integer n;
   begin
      for (n=0; n<addr_width; n=n+1)
	 begin
	    LATCHED_AB[n] = (NOT_AB[n]!==LAST_NOT_AB[n]) ? 1'bx : LATCHED_AB[n] ;
	 end
      for (n=0; n<BITS; n=n+1)
	 begin
	    LATCHED_DB[n] = (NOT_DB[n]!==LAST_NOT_DB[n]) ? 1'bx : LATCHED_DB[n] ;
	 end
      LATCHED_WENB = (NOT_WENB!==LAST_NOT_WENB) ? 1'bx : LATCHED_WENB ;

      LATCHED_CENB = (NOT_CENB!==LAST_NOT_CENB) ? 1'bx : LATCHED_CENB ;
   end
   endtask

   task read_memA;
      input r_wb;
      input xflag;
   begin
      if (r_wb)
	 begin
	    if (valid_address(AAi))
	       begin
                     QAi=mem[AAi];
	       end
	    else
	       begin
		  QAi=wordx;
	       end
	 end
      else
	 begin
	    if (xflag)
	       begin
		  QAi=wordx;
	       end
	    else
	       begin
	          QAi=DAi;
	       end
	 end
   end
   endtask
   task read_memB;
      input r_wb;
      input xflag;
   begin
      if (r_wb)
	 begin
	    if (valid_address(ABi))
	       begin
                     QBi=mem[ABi];
	       end
	    else
	       begin
		  QBi=wordx;
	       end
	 end
      else
	 begin
	    if (xflag)
	       begin
		  QBi=wordx;
	       end
	    else
	       begin
	          QBi=DBi;
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

   task process_violationsA;
   begin
      if ((NOT_CLKA_PER!==LAST_NOT_CLKA_PER) ||
	  (NOT_CLKA_MINH!==LAST_NOT_CLKA_MINH) ||
	  (NOT_CLKA_MINL!==LAST_NOT_CLKA_MINL))
	 begin
	    if (CENAi !== 1'b1)
               begin
		  x_mem;
		  read_memA(0,1);
	       end
	 end
      else
	 begin
	    update_Anotifier_buses;
	    x_Ainputs;
	    update_Alogic;
            if (NOT_CONTA!==LAST_NOT_CONTA)
               begin
		  contentionA;
               end
            else
               begin
                  mem_cycleA;
               end
	 end
      update_Alast_notifiers;
   end
   endtask

   task process_violationsB;
   begin
      if ((NOT_CLKB_PER!==LAST_NOT_CLKB_PER) ||
	  (NOT_CLKB_MINH!==LAST_NOT_CLKB_MINH) ||
	  (NOT_CLKB_MINL!==LAST_NOT_CLKB_MINL))
	 begin
	    if (CENBi !== 1'b1)
               begin
		  x_mem;
		  read_memB(0,1);
	       end
	 end
      else
	 begin
	    update_Bnotifier_buses;
	    x_Binputs;
	    update_Blogic;
            if (NOT_CONTB!==LAST_NOT_CONTB)
               begin
		  contentionB;
               end
            else
               begin
                  mem_cycleB;
               end
	 end
      update_Blast_notifiers;
   end
   endtask

   function valid_address;
      input [addr_width-1:0] a;
   begin
      valid_address = (^(a) !== 1'bx);
   end
   endfunction


   bufif0 (QA[0], _QA[0], _OENAi);
   bufif0 (QA[1], _QA[1], _OENAi);
   bufif0 (QA[2], _QA[2], _OENAi);
   bufif0 (QA[3], _QA[3], _OENAi);
   bufif0 (QA[4], _QA[4], _OENAi);
   bufif0 (QA[5], _QA[5], _OENAi);
   bufif0 (QA[6], _QA[6], _OENAi);
   bufif0 (QA[7], _QA[7], _OENAi);
   bufif0 (QA[8], _QA[8], _OENAi);
   bufif0 (QA[9], _QA[9], _OENAi);
   bufif0 (QA[10], _QA[10], _OENAi);
   bufif0 (QA[11], _QA[11], _OENAi);
   bufif0 (QA[12], _QA[12], _OENAi);
   bufif0 (QA[13], _QA[13], _OENAi);
   bufif0 (QA[14], _QA[14], _OENAi);
   bufif0 (QA[15], _QA[15], _OENAi);
   bufif0 (QA[16], _QA[16], _OENAi);
   bufif0 (QA[17], _QA[17], _OENAi);
   bufif0 (QA[18], _QA[18], _OENAi);
   bufif0 (QA[19], _QA[19], _OENAi);
   bufif0 (QA[20], _QA[20], _OENAi);
   bufif0 (QA[21], _QA[21], _OENAi);
   bufif0 (QA[22], _QA[22], _OENAi);
   bufif0 (QA[23], _QA[23], _OENAi);
   bufif0 (QA[24], _QA[24], _OENAi);
   bufif0 (QA[25], _QA[25], _OENAi);
   bufif0 (QA[26], _QA[26], _OENAi);
   bufif0 (QA[27], _QA[27], _OENAi);
   bufif0 (QA[28], _QA[28], _OENAi);
   bufif0 (QA[29], _QA[29], _OENAi);
   bufif0 (QA[30], _QA[30], _OENAi);
   bufif0 (QA[31], _QA[31], _OENAi);
   bufif0 (QA[32], _QA[32], _OENAi);
   bufif0 (QA[33], _QA[33], _OENAi);
   bufif0 (QA[34], _QA[34], _OENAi);
   bufif0 (QA[35], _QA[35], _OENAi);
   bufif0 (QA[36], _QA[36], _OENAi);
   bufif0 (QA[37], _QA[37], _OENAi);
   bufif0 (QA[38], _QA[38], _OENAi);
   bufif0 (QA[39], _QA[39], _OENAi);
   bufif0 (QA[40], _QA[40], _OENAi);
   bufif0 (QA[41], _QA[41], _OENAi);
   bufif0 (QA[42], _QA[42], _OENAi);
   bufif0 (QA[43], _QA[43], _OENAi);
   bufif0 (QA[44], _QA[44], _OENAi);
   bufif0 (QA[45], _QA[45], _OENAi);
   bufif0 (QA[46], _QA[46], _OENAi);
   bufif0 (QA[47], _QA[47], _OENAi);
   bufif0 (QA[48], _QA[48], _OENAi);
   bufif0 (QA[49], _QA[49], _OENAi);
   bufif0 (QA[50], _QA[50], _OENAi);
   bufif0 (QA[51], _QA[51], _OENAi);
   bufif0 (QA[52], _QA[52], _OENAi);
   bufif0 (QA[53], _QA[53], _OENAi);
   bufif0 (QA[54], _QA[54], _OENAi);
   bufif0 (QA[55], _QA[55], _OENAi);
   bufif0 (QA[56], _QA[56], _OENAi);
   bufif0 (QA[57], _QA[57], _OENAi);
   bufif0 (QA[58], _QA[58], _OENAi);
   bufif0 (QA[59], _QA[59], _OENAi);
   bufif0 (QA[60], _QA[60], _OENAi);
   bufif0 (QA[61], _QA[61], _OENAi);
   bufif0 (QA[62], _QA[62], _OENAi);
   bufif0 (QA[63], _QA[63], _OENAi);
   bufif0 (QA[64], _QA[64], _OENAi);
   bufif0 (QA[65], _QA[65], _OENAi);
   bufif0 (QA[66], _QA[66], _OENAi);
   bufif0 (QA[67], _QA[67], _OENAi);
   bufif0 (QA[68], _QA[68], _OENAi);
   bufif0 (QA[69], _QA[69], _OENAi);
   bufif0 (QA[70], _QA[70], _OENAi);
   bufif0 (QA[71], _QA[71], _OENAi);
   bufif0 (QA[72], _QA[72], _OENAi);
   bufif0 (QA[73], _QA[73], _OENAi);
   bufif0 (QA[74], _QA[74], _OENAi);
   bufif0 (QA[75], _QA[75], _OENAi);
   bufif0 (QA[76], _QA[76], _OENAi);
   bufif0 (QA[77], _QA[77], _OENAi);
   bufif0 (QA[78], _QA[78], _OENAi);
   bufif0 (QA[79], _QA[79], _OENAi);
   bufif0 (QA[80], _QA[80], _OENAi);
   bufif0 (QA[81], _QA[81], _OENAi);
   bufif0 (QA[82], _QA[82], _OENAi);
   bufif0 (QA[83], _QA[83], _OENAi);
   bufif0 (QA[84], _QA[84], _OENAi);
   bufif0 (QA[85], _QA[85], _OENAi);
   bufif0 (QA[86], _QA[86], _OENAi);
   bufif0 (QA[87], _QA[87], _OENAi);
   bufif0 (QA[88], _QA[88], _OENAi);
   bufif0 (QA[89], _QA[89], _OENAi);
   bufif0 (QA[90], _QA[90], _OENAi);
   bufif0 (QA[91], _QA[91], _OENAi);
   bufif0 (QA[92], _QA[92], _OENAi);
   bufif0 (QA[93], _QA[93], _OENAi);
   bufif0 (QA[94], _QA[94], _OENAi);
   bufif0 (QA[95], _QA[95], _OENAi);
   bufif0 (QA[96], _QA[96], _OENAi);
   bufif0 (QA[97], _QA[97], _OENAi);
   bufif0 (QA[98], _QA[98], _OENAi);
   bufif0 (QA[99], _QA[99], _OENAi);
   bufif0 (QA[100], _QA[100], _OENAi);
   bufif0 (QA[101], _QA[101], _OENAi);
   bufif0 (QA[102], _QA[102], _OENAi);
   bufif0 (QA[103], _QA[103], _OENAi);
   bufif0 (QA[104], _QA[104], _OENAi);
   bufif0 (QA[105], _QA[105], _OENAi);
   bufif0 (QA[106], _QA[106], _OENAi);
   bufif0 (QA[107], _QA[107], _OENAi);
   bufif0 (QA[108], _QA[108], _OENAi);
   bufif0 (QA[109], _QA[109], _OENAi);
   bufif0 (QA[110], _QA[110], _OENAi);
   bufif0 (QA[111], _QA[111], _OENAi);
   bufif0 (QA[112], _QA[112], _OENAi);
   bufif0 (QA[113], _QA[113], _OENAi);
   bufif0 (QA[114], _QA[114], _OENAi);
   bufif0 (QA[115], _QA[115], _OENAi);
   bufif0 (QA[116], _QA[116], _OENAi);
   bufif0 (QA[117], _QA[117], _OENAi);
   bufif0 (QA[118], _QA[118], _OENAi);
   bufif0 (QA[119], _QA[119], _OENAi);
   bufif0 (QA[120], _QA[120], _OENAi);
   bufif0 (QA[121], _QA[121], _OENAi);
   bufif0 (QA[122], _QA[122], _OENAi);
   bufif0 (QA[123], _QA[123], _OENAi);
   bufif0 (QA[124], _QA[124], _OENAi);
   bufif0 (QA[125], _QA[125], _OENAi);
   bufif0 (QA[126], _QA[126], _OENAi);
   bufif0 (QA[127], _QA[127], _OENAi);
   buf (_DA[0], DA[0]);
   buf (_DA[1], DA[1]);
   buf (_DA[2], DA[2]);
   buf (_DA[3], DA[3]);
   buf (_DA[4], DA[4]);
   buf (_DA[5], DA[5]);
   buf (_DA[6], DA[6]);
   buf (_DA[7], DA[7]);
   buf (_DA[8], DA[8]);
   buf (_DA[9], DA[9]);
   buf (_DA[10], DA[10]);
   buf (_DA[11], DA[11]);
   buf (_DA[12], DA[12]);
   buf (_DA[13], DA[13]);
   buf (_DA[14], DA[14]);
   buf (_DA[15], DA[15]);
   buf (_DA[16], DA[16]);
   buf (_DA[17], DA[17]);
   buf (_DA[18], DA[18]);
   buf (_DA[19], DA[19]);
   buf (_DA[20], DA[20]);
   buf (_DA[21], DA[21]);
   buf (_DA[22], DA[22]);
   buf (_DA[23], DA[23]);
   buf (_DA[24], DA[24]);
   buf (_DA[25], DA[25]);
   buf (_DA[26], DA[26]);
   buf (_DA[27], DA[27]);
   buf (_DA[28], DA[28]);
   buf (_DA[29], DA[29]);
   buf (_DA[30], DA[30]);
   buf (_DA[31], DA[31]);
   buf (_DA[32], DA[32]);
   buf (_DA[33], DA[33]);
   buf (_DA[34], DA[34]);
   buf (_DA[35], DA[35]);
   buf (_DA[36], DA[36]);
   buf (_DA[37], DA[37]);
   buf (_DA[38], DA[38]);
   buf (_DA[39], DA[39]);
   buf (_DA[40], DA[40]);
   buf (_DA[41], DA[41]);
   buf (_DA[42], DA[42]);
   buf (_DA[43], DA[43]);
   buf (_DA[44], DA[44]);
   buf (_DA[45], DA[45]);
   buf (_DA[46], DA[46]);
   buf (_DA[47], DA[47]);
   buf (_DA[48], DA[48]);
   buf (_DA[49], DA[49]);
   buf (_DA[50], DA[50]);
   buf (_DA[51], DA[51]);
   buf (_DA[52], DA[52]);
   buf (_DA[53], DA[53]);
   buf (_DA[54], DA[54]);
   buf (_DA[55], DA[55]);
   buf (_DA[56], DA[56]);
   buf (_DA[57], DA[57]);
   buf (_DA[58], DA[58]);
   buf (_DA[59], DA[59]);
   buf (_DA[60], DA[60]);
   buf (_DA[61], DA[61]);
   buf (_DA[62], DA[62]);
   buf (_DA[63], DA[63]);
   buf (_DA[64], DA[64]);
   buf (_DA[65], DA[65]);
   buf (_DA[66], DA[66]);
   buf (_DA[67], DA[67]);
   buf (_DA[68], DA[68]);
   buf (_DA[69], DA[69]);
   buf (_DA[70], DA[70]);
   buf (_DA[71], DA[71]);
   buf (_DA[72], DA[72]);
   buf (_DA[73], DA[73]);
   buf (_DA[74], DA[74]);
   buf (_DA[75], DA[75]);
   buf (_DA[76], DA[76]);
   buf (_DA[77], DA[77]);
   buf (_DA[78], DA[78]);
   buf (_DA[79], DA[79]);
   buf (_DA[80], DA[80]);
   buf (_DA[81], DA[81]);
   buf (_DA[82], DA[82]);
   buf (_DA[83], DA[83]);
   buf (_DA[84], DA[84]);
   buf (_DA[85], DA[85]);
   buf (_DA[86], DA[86]);
   buf (_DA[87], DA[87]);
   buf (_DA[88], DA[88]);
   buf (_DA[89], DA[89]);
   buf (_DA[90], DA[90]);
   buf (_DA[91], DA[91]);
   buf (_DA[92], DA[92]);
   buf (_DA[93], DA[93]);
   buf (_DA[94], DA[94]);
   buf (_DA[95], DA[95]);
   buf (_DA[96], DA[96]);
   buf (_DA[97], DA[97]);
   buf (_DA[98], DA[98]);
   buf (_DA[99], DA[99]);
   buf (_DA[100], DA[100]);
   buf (_DA[101], DA[101]);
   buf (_DA[102], DA[102]);
   buf (_DA[103], DA[103]);
   buf (_DA[104], DA[104]);
   buf (_DA[105], DA[105]);
   buf (_DA[106], DA[106]);
   buf (_DA[107], DA[107]);
   buf (_DA[108], DA[108]);
   buf (_DA[109], DA[109]);
   buf (_DA[110], DA[110]);
   buf (_DA[111], DA[111]);
   buf (_DA[112], DA[112]);
   buf (_DA[113], DA[113]);
   buf (_DA[114], DA[114]);
   buf (_DA[115], DA[115]);
   buf (_DA[116], DA[116]);
   buf (_DA[117], DA[117]);
   buf (_DA[118], DA[118]);
   buf (_DA[119], DA[119]);
   buf (_DA[120], DA[120]);
   buf (_DA[121], DA[121]);
   buf (_DA[122], DA[122]);
   buf (_DA[123], DA[123]);
   buf (_DA[124], DA[124]);
   buf (_DA[125], DA[125]);
   buf (_DA[126], DA[126]);
   buf (_DA[127], DA[127]);
   buf (_AA[0], AA[0]);
   buf (_AA[1], AA[1]);
   buf (_AA[2], AA[2]);
   buf (_AA[3], AA[3]);
   buf (_AA[4], AA[4]);
   buf (_AA[5], AA[5]);
   buf (_AA[6], AA[6]);
   buf (_AA[7], AA[7]);
   buf (_CLKA, CLKA);
   buf (_WENA, WENA);
   buf (_OENA, OENA);
   buf (_CENA, CENA);
   bufif0 (QB[0], _QB[0], _OENBi);
   bufif0 (QB[1], _QB[1], _OENBi);
   bufif0 (QB[2], _QB[2], _OENBi);
   bufif0 (QB[3], _QB[3], _OENBi);
   bufif0 (QB[4], _QB[4], _OENBi);
   bufif0 (QB[5], _QB[5], _OENBi);
   bufif0 (QB[6], _QB[6], _OENBi);
   bufif0 (QB[7], _QB[7], _OENBi);
   bufif0 (QB[8], _QB[8], _OENBi);
   bufif0 (QB[9], _QB[9], _OENBi);
   bufif0 (QB[10], _QB[10], _OENBi);
   bufif0 (QB[11], _QB[11], _OENBi);
   bufif0 (QB[12], _QB[12], _OENBi);
   bufif0 (QB[13], _QB[13], _OENBi);
   bufif0 (QB[14], _QB[14], _OENBi);
   bufif0 (QB[15], _QB[15], _OENBi);
   bufif0 (QB[16], _QB[16], _OENBi);
   bufif0 (QB[17], _QB[17], _OENBi);
   bufif0 (QB[18], _QB[18], _OENBi);
   bufif0 (QB[19], _QB[19], _OENBi);
   bufif0 (QB[20], _QB[20], _OENBi);
   bufif0 (QB[21], _QB[21], _OENBi);
   bufif0 (QB[22], _QB[22], _OENBi);
   bufif0 (QB[23], _QB[23], _OENBi);
   bufif0 (QB[24], _QB[24], _OENBi);
   bufif0 (QB[25], _QB[25], _OENBi);
   bufif0 (QB[26], _QB[26], _OENBi);
   bufif0 (QB[27], _QB[27], _OENBi);
   bufif0 (QB[28], _QB[28], _OENBi);
   bufif0 (QB[29], _QB[29], _OENBi);
   bufif0 (QB[30], _QB[30], _OENBi);
   bufif0 (QB[31], _QB[31], _OENBi);
   bufif0 (QB[32], _QB[32], _OENBi);
   bufif0 (QB[33], _QB[33], _OENBi);
   bufif0 (QB[34], _QB[34], _OENBi);
   bufif0 (QB[35], _QB[35], _OENBi);
   bufif0 (QB[36], _QB[36], _OENBi);
   bufif0 (QB[37], _QB[37], _OENBi);
   bufif0 (QB[38], _QB[38], _OENBi);
   bufif0 (QB[39], _QB[39], _OENBi);
   bufif0 (QB[40], _QB[40], _OENBi);
   bufif0 (QB[41], _QB[41], _OENBi);
   bufif0 (QB[42], _QB[42], _OENBi);
   bufif0 (QB[43], _QB[43], _OENBi);
   bufif0 (QB[44], _QB[44], _OENBi);
   bufif0 (QB[45], _QB[45], _OENBi);
   bufif0 (QB[46], _QB[46], _OENBi);
   bufif0 (QB[47], _QB[47], _OENBi);
   bufif0 (QB[48], _QB[48], _OENBi);
   bufif0 (QB[49], _QB[49], _OENBi);
   bufif0 (QB[50], _QB[50], _OENBi);
   bufif0 (QB[51], _QB[51], _OENBi);
   bufif0 (QB[52], _QB[52], _OENBi);
   bufif0 (QB[53], _QB[53], _OENBi);
   bufif0 (QB[54], _QB[54], _OENBi);
   bufif0 (QB[55], _QB[55], _OENBi);
   bufif0 (QB[56], _QB[56], _OENBi);
   bufif0 (QB[57], _QB[57], _OENBi);
   bufif0 (QB[58], _QB[58], _OENBi);
   bufif0 (QB[59], _QB[59], _OENBi);
   bufif0 (QB[60], _QB[60], _OENBi);
   bufif0 (QB[61], _QB[61], _OENBi);
   bufif0 (QB[62], _QB[62], _OENBi);
   bufif0 (QB[63], _QB[63], _OENBi);
   bufif0 (QB[64], _QB[64], _OENBi);
   bufif0 (QB[65], _QB[65], _OENBi);
   bufif0 (QB[66], _QB[66], _OENBi);
   bufif0 (QB[67], _QB[67], _OENBi);
   bufif0 (QB[68], _QB[68], _OENBi);
   bufif0 (QB[69], _QB[69], _OENBi);
   bufif0 (QB[70], _QB[70], _OENBi);
   bufif0 (QB[71], _QB[71], _OENBi);
   bufif0 (QB[72], _QB[72], _OENBi);
   bufif0 (QB[73], _QB[73], _OENBi);
   bufif0 (QB[74], _QB[74], _OENBi);
   bufif0 (QB[75], _QB[75], _OENBi);
   bufif0 (QB[76], _QB[76], _OENBi);
   bufif0 (QB[77], _QB[77], _OENBi);
   bufif0 (QB[78], _QB[78], _OENBi);
   bufif0 (QB[79], _QB[79], _OENBi);
   bufif0 (QB[80], _QB[80], _OENBi);
   bufif0 (QB[81], _QB[81], _OENBi);
   bufif0 (QB[82], _QB[82], _OENBi);
   bufif0 (QB[83], _QB[83], _OENBi);
   bufif0 (QB[84], _QB[84], _OENBi);
   bufif0 (QB[85], _QB[85], _OENBi);
   bufif0 (QB[86], _QB[86], _OENBi);
   bufif0 (QB[87], _QB[87], _OENBi);
   bufif0 (QB[88], _QB[88], _OENBi);
   bufif0 (QB[89], _QB[89], _OENBi);
   bufif0 (QB[90], _QB[90], _OENBi);
   bufif0 (QB[91], _QB[91], _OENBi);
   bufif0 (QB[92], _QB[92], _OENBi);
   bufif0 (QB[93], _QB[93], _OENBi);
   bufif0 (QB[94], _QB[94], _OENBi);
   bufif0 (QB[95], _QB[95], _OENBi);
   bufif0 (QB[96], _QB[96], _OENBi);
   bufif0 (QB[97], _QB[97], _OENBi);
   bufif0 (QB[98], _QB[98], _OENBi);
   bufif0 (QB[99], _QB[99], _OENBi);
   bufif0 (QB[100], _QB[100], _OENBi);
   bufif0 (QB[101], _QB[101], _OENBi);
   bufif0 (QB[102], _QB[102], _OENBi);
   bufif0 (QB[103], _QB[103], _OENBi);
   bufif0 (QB[104], _QB[104], _OENBi);
   bufif0 (QB[105], _QB[105], _OENBi);
   bufif0 (QB[106], _QB[106], _OENBi);
   bufif0 (QB[107], _QB[107], _OENBi);
   bufif0 (QB[108], _QB[108], _OENBi);
   bufif0 (QB[109], _QB[109], _OENBi);
   bufif0 (QB[110], _QB[110], _OENBi);
   bufif0 (QB[111], _QB[111], _OENBi);
   bufif0 (QB[112], _QB[112], _OENBi);
   bufif0 (QB[113], _QB[113], _OENBi);
   bufif0 (QB[114], _QB[114], _OENBi);
   bufif0 (QB[115], _QB[115], _OENBi);
   bufif0 (QB[116], _QB[116], _OENBi);
   bufif0 (QB[117], _QB[117], _OENBi);
   bufif0 (QB[118], _QB[118], _OENBi);
   bufif0 (QB[119], _QB[119], _OENBi);
   bufif0 (QB[120], _QB[120], _OENBi);
   bufif0 (QB[121], _QB[121], _OENBi);
   bufif0 (QB[122], _QB[122], _OENBi);
   bufif0 (QB[123], _QB[123], _OENBi);
   bufif0 (QB[124], _QB[124], _OENBi);
   bufif0 (QB[125], _QB[125], _OENBi);
   bufif0 (QB[126], _QB[126], _OENBi);
   bufif0 (QB[127], _QB[127], _OENBi);
   buf (_DB[0], DB[0]);
   buf (_DB[1], DB[1]);
   buf (_DB[2], DB[2]);
   buf (_DB[3], DB[3]);
   buf (_DB[4], DB[4]);
   buf (_DB[5], DB[5]);
   buf (_DB[6], DB[6]);
   buf (_DB[7], DB[7]);
   buf (_DB[8], DB[8]);
   buf (_DB[9], DB[9]);
   buf (_DB[10], DB[10]);
   buf (_DB[11], DB[11]);
   buf (_DB[12], DB[12]);
   buf (_DB[13], DB[13]);
   buf (_DB[14], DB[14]);
   buf (_DB[15], DB[15]);
   buf (_DB[16], DB[16]);
   buf (_DB[17], DB[17]);
   buf (_DB[18], DB[18]);
   buf (_DB[19], DB[19]);
   buf (_DB[20], DB[20]);
   buf (_DB[21], DB[21]);
   buf (_DB[22], DB[22]);
   buf (_DB[23], DB[23]);
   buf (_DB[24], DB[24]);
   buf (_DB[25], DB[25]);
   buf (_DB[26], DB[26]);
   buf (_DB[27], DB[27]);
   buf (_DB[28], DB[28]);
   buf (_DB[29], DB[29]);
   buf (_DB[30], DB[30]);
   buf (_DB[31], DB[31]);
   buf (_DB[32], DB[32]);
   buf (_DB[33], DB[33]);
   buf (_DB[34], DB[34]);
   buf (_DB[35], DB[35]);
   buf (_DB[36], DB[36]);
   buf (_DB[37], DB[37]);
   buf (_DB[38], DB[38]);
   buf (_DB[39], DB[39]);
   buf (_DB[40], DB[40]);
   buf (_DB[41], DB[41]);
   buf (_DB[42], DB[42]);
   buf (_DB[43], DB[43]);
   buf (_DB[44], DB[44]);
   buf (_DB[45], DB[45]);
   buf (_DB[46], DB[46]);
   buf (_DB[47], DB[47]);
   buf (_DB[48], DB[48]);
   buf (_DB[49], DB[49]);
   buf (_DB[50], DB[50]);
   buf (_DB[51], DB[51]);
   buf (_DB[52], DB[52]);
   buf (_DB[53], DB[53]);
   buf (_DB[54], DB[54]);
   buf (_DB[55], DB[55]);
   buf (_DB[56], DB[56]);
   buf (_DB[57], DB[57]);
   buf (_DB[58], DB[58]);
   buf (_DB[59], DB[59]);
   buf (_DB[60], DB[60]);
   buf (_DB[61], DB[61]);
   buf (_DB[62], DB[62]);
   buf (_DB[63], DB[63]);
   buf (_DB[64], DB[64]);
   buf (_DB[65], DB[65]);
   buf (_DB[66], DB[66]);
   buf (_DB[67], DB[67]);
   buf (_DB[68], DB[68]);
   buf (_DB[69], DB[69]);
   buf (_DB[70], DB[70]);
   buf (_DB[71], DB[71]);
   buf (_DB[72], DB[72]);
   buf (_DB[73], DB[73]);
   buf (_DB[74], DB[74]);
   buf (_DB[75], DB[75]);
   buf (_DB[76], DB[76]);
   buf (_DB[77], DB[77]);
   buf (_DB[78], DB[78]);
   buf (_DB[79], DB[79]);
   buf (_DB[80], DB[80]);
   buf (_DB[81], DB[81]);
   buf (_DB[82], DB[82]);
   buf (_DB[83], DB[83]);
   buf (_DB[84], DB[84]);
   buf (_DB[85], DB[85]);
   buf (_DB[86], DB[86]);
   buf (_DB[87], DB[87]);
   buf (_DB[88], DB[88]);
   buf (_DB[89], DB[89]);
   buf (_DB[90], DB[90]);
   buf (_DB[91], DB[91]);
   buf (_DB[92], DB[92]);
   buf (_DB[93], DB[93]);
   buf (_DB[94], DB[94]);
   buf (_DB[95], DB[95]);
   buf (_DB[96], DB[96]);
   buf (_DB[97], DB[97]);
   buf (_DB[98], DB[98]);
   buf (_DB[99], DB[99]);
   buf (_DB[100], DB[100]);
   buf (_DB[101], DB[101]);
   buf (_DB[102], DB[102]);
   buf (_DB[103], DB[103]);
   buf (_DB[104], DB[104]);
   buf (_DB[105], DB[105]);
   buf (_DB[106], DB[106]);
   buf (_DB[107], DB[107]);
   buf (_DB[108], DB[108]);
   buf (_DB[109], DB[109]);
   buf (_DB[110], DB[110]);
   buf (_DB[111], DB[111]);
   buf (_DB[112], DB[112]);
   buf (_DB[113], DB[113]);
   buf (_DB[114], DB[114]);
   buf (_DB[115], DB[115]);
   buf (_DB[116], DB[116]);
   buf (_DB[117], DB[117]);
   buf (_DB[118], DB[118]);
   buf (_DB[119], DB[119]);
   buf (_DB[120], DB[120]);
   buf (_DB[121], DB[121]);
   buf (_DB[122], DB[122]);
   buf (_DB[123], DB[123]);
   buf (_DB[124], DB[124]);
   buf (_DB[125], DB[125]);
   buf (_DB[126], DB[126]);
   buf (_DB[127], DB[127]);
   buf (_AB[0], AB[0]);
   buf (_AB[1], AB[1]);
   buf (_AB[2], AB[2]);
   buf (_AB[3], AB[3]);
   buf (_AB[4], AB[4]);
   buf (_AB[5], AB[5]);
   buf (_AB[6], AB[6]);
   buf (_AB[7], AB[7]);
   buf (_CLKB, CLKB);
   buf (_WENB, WENB);
   buf (_OENB, OENB);
   buf (_CENB, CENB);


   assign _OENAi = _OENA;
   assign _QA = QAi;
   assign re_flagA = !(_CENA);
   assign re_data_flagA = !(_CENA || _WENA);
   assign _OENBi = _OENB;
   assign _QB = QBi;
   assign re_flagB = !(_CENB);
   assign re_data_flagB = !(_CENB || _WENB);

   assign contA_flag = 
      (_AA === ABi) && 
      !((_WENA === 1'b1) && (WENBi === 1'b1)) &&
      (_CENA !== 1'b1) &&
      (CENBi !== 1'b1);
   
   assign contB_flag = 
      (_AB === AAi) && 
      !((_WENB === 1'b1) && (WENAi === 1'b1)) &&
      (_CENB !== 1'b1) &&
      (CENAi !== 1'b1);

   assign cont_flag = 
      (_AB === _AA) && 
      !((_WENB === 1'b1) && (_WENA === 1'b1)) &&
      (_CENB !== 1'b1) &&
      (_CENA !== 1'b1);

   always @(
	    NOT_AA0 or
	    NOT_AA1 or
	    NOT_AA2 or
	    NOT_AA3 or
	    NOT_AA4 or
	    NOT_AA5 or
	    NOT_AA6 or
	    NOT_AA7 or
	    NOT_DA0 or
	    NOT_DA1 or
	    NOT_DA2 or
	    NOT_DA3 or
	    NOT_DA4 or
	    NOT_DA5 or
	    NOT_DA6 or
	    NOT_DA7 or
	    NOT_DA8 or
	    NOT_DA9 or
	    NOT_DA10 or
	    NOT_DA11 or
	    NOT_DA12 or
	    NOT_DA13 or
	    NOT_DA14 or
	    NOT_DA15 or
	    NOT_DA16 or
	    NOT_DA17 or
	    NOT_DA18 or
	    NOT_DA19 or
	    NOT_DA20 or
	    NOT_DA21 or
	    NOT_DA22 or
	    NOT_DA23 or
	    NOT_DA24 or
	    NOT_DA25 or
	    NOT_DA26 or
	    NOT_DA27 or
	    NOT_DA28 or
	    NOT_DA29 or
	    NOT_DA30 or
	    NOT_DA31 or
	    NOT_DA32 or
	    NOT_DA33 or
	    NOT_DA34 or
	    NOT_DA35 or
	    NOT_DA36 or
	    NOT_DA37 or
	    NOT_DA38 or
	    NOT_DA39 or
	    NOT_DA40 or
	    NOT_DA41 or
	    NOT_DA42 or
	    NOT_DA43 or
	    NOT_DA44 or
	    NOT_DA45 or
	    NOT_DA46 or
	    NOT_DA47 or
	    NOT_DA48 or
	    NOT_DA49 or
	    NOT_DA50 or
	    NOT_DA51 or
	    NOT_DA52 or
	    NOT_DA53 or
	    NOT_DA54 or
	    NOT_DA55 or
	    NOT_DA56 or
	    NOT_DA57 or
	    NOT_DA58 or
	    NOT_DA59 or
	    NOT_DA60 or
	    NOT_DA61 or
	    NOT_DA62 or
	    NOT_DA63 or
	    NOT_DA64 or
	    NOT_DA65 or
	    NOT_DA66 or
	    NOT_DA67 or
	    NOT_DA68 or
	    NOT_DA69 or
	    NOT_DA70 or
	    NOT_DA71 or
	    NOT_DA72 or
	    NOT_DA73 or
	    NOT_DA74 or
	    NOT_DA75 or
	    NOT_DA76 or
	    NOT_DA77 or
	    NOT_DA78 or
	    NOT_DA79 or
	    NOT_DA80 or
	    NOT_DA81 or
	    NOT_DA82 or
	    NOT_DA83 or
	    NOT_DA84 or
	    NOT_DA85 or
	    NOT_DA86 or
	    NOT_DA87 or
	    NOT_DA88 or
	    NOT_DA89 or
	    NOT_DA90 or
	    NOT_DA91 or
	    NOT_DA92 or
	    NOT_DA93 or
	    NOT_DA94 or
	    NOT_DA95 or
	    NOT_DA96 or
	    NOT_DA97 or
	    NOT_DA98 or
	    NOT_DA99 or
	    NOT_DA100 or
	    NOT_DA101 or
	    NOT_DA102 or
	    NOT_DA103 or
	    NOT_DA104 or
	    NOT_DA105 or
	    NOT_DA106 or
	    NOT_DA107 or
	    NOT_DA108 or
	    NOT_DA109 or
	    NOT_DA110 or
	    NOT_DA111 or
	    NOT_DA112 or
	    NOT_DA113 or
	    NOT_DA114 or
	    NOT_DA115 or
	    NOT_DA116 or
	    NOT_DA117 or
	    NOT_DA118 or
	    NOT_DA119 or
	    NOT_DA120 or
	    NOT_DA121 or
	    NOT_DA122 or
	    NOT_DA123 or
	    NOT_DA124 or
	    NOT_DA125 or
	    NOT_DA126 or
	    NOT_DA127 or
	    NOT_WENA or
	    NOT_CENA or
            NOT_CONTA or
	    NOT_CLKA_PER or
	    NOT_CLKA_MINH or
	    NOT_CLKA_MINL
	    )
      begin
         process_violationsA;
      end
   always @(
	    NOT_AB0 or
	    NOT_AB1 or
	    NOT_AB2 or
	    NOT_AB3 or
	    NOT_AB4 or
	    NOT_AB5 or
	    NOT_AB6 or
	    NOT_AB7 or
	    NOT_DB0 or
	    NOT_DB1 or
	    NOT_DB2 or
	    NOT_DB3 or
	    NOT_DB4 or
	    NOT_DB5 or
	    NOT_DB6 or
	    NOT_DB7 or
	    NOT_DB8 or
	    NOT_DB9 or
	    NOT_DB10 or
	    NOT_DB11 or
	    NOT_DB12 or
	    NOT_DB13 or
	    NOT_DB14 or
	    NOT_DB15 or
	    NOT_DB16 or
	    NOT_DB17 or
	    NOT_DB18 or
	    NOT_DB19 or
	    NOT_DB20 or
	    NOT_DB21 or
	    NOT_DB22 or
	    NOT_DB23 or
	    NOT_DB24 or
	    NOT_DB25 or
	    NOT_DB26 or
	    NOT_DB27 or
	    NOT_DB28 or
	    NOT_DB29 or
	    NOT_DB30 or
	    NOT_DB31 or
	    NOT_DB32 or
	    NOT_DB33 or
	    NOT_DB34 or
	    NOT_DB35 or
	    NOT_DB36 or
	    NOT_DB37 or
	    NOT_DB38 or
	    NOT_DB39 or
	    NOT_DB40 or
	    NOT_DB41 or
	    NOT_DB42 or
	    NOT_DB43 or
	    NOT_DB44 or
	    NOT_DB45 or
	    NOT_DB46 or
	    NOT_DB47 or
	    NOT_DB48 or
	    NOT_DB49 or
	    NOT_DB50 or
	    NOT_DB51 or
	    NOT_DB52 or
	    NOT_DB53 or
	    NOT_DB54 or
	    NOT_DB55 or
	    NOT_DB56 or
	    NOT_DB57 or
	    NOT_DB58 or
	    NOT_DB59 or
	    NOT_DB60 or
	    NOT_DB61 or
	    NOT_DB62 or
	    NOT_DB63 or
	    NOT_DB64 or
	    NOT_DB65 or
	    NOT_DB66 or
	    NOT_DB67 or
	    NOT_DB68 or
	    NOT_DB69 or
	    NOT_DB70 or
	    NOT_DB71 or
	    NOT_DB72 or
	    NOT_DB73 or
	    NOT_DB74 or
	    NOT_DB75 or
	    NOT_DB76 or
	    NOT_DB77 or
	    NOT_DB78 or
	    NOT_DB79 or
	    NOT_DB80 or
	    NOT_DB81 or
	    NOT_DB82 or
	    NOT_DB83 or
	    NOT_DB84 or
	    NOT_DB85 or
	    NOT_DB86 or
	    NOT_DB87 or
	    NOT_DB88 or
	    NOT_DB89 or
	    NOT_DB90 or
	    NOT_DB91 or
	    NOT_DB92 or
	    NOT_DB93 or
	    NOT_DB94 or
	    NOT_DB95 or
	    NOT_DB96 or
	    NOT_DB97 or
	    NOT_DB98 or
	    NOT_DB99 or
	    NOT_DB100 or
	    NOT_DB101 or
	    NOT_DB102 or
	    NOT_DB103 or
	    NOT_DB104 or
	    NOT_DB105 or
	    NOT_DB106 or
	    NOT_DB107 or
	    NOT_DB108 or
	    NOT_DB109 or
	    NOT_DB110 or
	    NOT_DB111 or
	    NOT_DB112 or
	    NOT_DB113 or
	    NOT_DB114 or
	    NOT_DB115 or
	    NOT_DB116 or
	    NOT_DB117 or
	    NOT_DB118 or
	    NOT_DB119 or
	    NOT_DB120 or
	    NOT_DB121 or
	    NOT_DB122 or
	    NOT_DB123 or
	    NOT_DB124 or
	    NOT_DB125 or
	    NOT_DB126 or
	    NOT_DB127 or
	    NOT_WENB or
	    NOT_CENB or
            NOT_CONTB or
	    NOT_CLKB_PER or
	    NOT_CLKB_MINH or
	    NOT_CLKB_MINL
	    )
      begin
         process_violationsB;
      end

   always @( _CLKA )
      begin
         casez({LAST_CLKA,_CLKA})
	   2'b01: begin
	      latch_Ainputs;
	      update_Alogic;
	      mem_cycleA;
	   end

	   2'b10,
	   2'bx?,
	   2'b00,
	   2'b11: ;

	   2'b?x: begin
	      x_mem;
              read_memA(0,1);
	   end
	   
	 endcase
	 LAST_CLKA = _CLKA;
      end
   always @( _CLKB )
      begin
         casez({LAST_CLKB,_CLKB})
	   2'b01: begin
	      latch_Binputs;
	      update_Blogic;
	      mem_cycleB;
	   end

	   2'b10,
	   2'bx?,
	   2'b00,
	   2'b11: ;

	   2'b?x: begin
	      x_mem;
              read_memB(0,1);
	   end
	   
	 endcase
	 LAST_CLKB = _CLKB;
      end

   specify
      $setuphold(posedge CLKA,posedge CENA, 1.000, 0.500, NOT_CENA);
      $setuphold(posedge CLKA,negedge CENA, 1.000, 0.500, NOT_CENA);
      $setuphold(posedge CLKA &&& re_flagA,posedge WENA, 1.000, 0.500, NOT_WENA);
      $setuphold(posedge CLKA &&& re_flagA,negedge WENA, 1.000, 0.500, NOT_WENA);
      $setuphold(posedge CLKA &&& re_flagA,posedge AA[0], 1.000, 0.500, NOT_AA0);
      $setuphold(posedge CLKA &&& re_flagA,negedge AA[0], 1.000, 0.500, NOT_AA0);
      $setuphold(posedge CLKA &&& re_flagA,posedge AA[1], 1.000, 0.500, NOT_AA1);
      $setuphold(posedge CLKA &&& re_flagA,negedge AA[1], 1.000, 0.500, NOT_AA1);
      $setuphold(posedge CLKA &&& re_flagA,posedge AA[2], 1.000, 0.500, NOT_AA2);
      $setuphold(posedge CLKA &&& re_flagA,negedge AA[2], 1.000, 0.500, NOT_AA2);
      $setuphold(posedge CLKA &&& re_flagA,posedge AA[3], 1.000, 0.500, NOT_AA3);
      $setuphold(posedge CLKA &&& re_flagA,negedge AA[3], 1.000, 0.500, NOT_AA3);
      $setuphold(posedge CLKA &&& re_flagA,posedge AA[4], 1.000, 0.500, NOT_AA4);
      $setuphold(posedge CLKA &&& re_flagA,negedge AA[4], 1.000, 0.500, NOT_AA4);
      $setuphold(posedge CLKA &&& re_flagA,posedge AA[5], 1.000, 0.500, NOT_AA5);
      $setuphold(posedge CLKA &&& re_flagA,negedge AA[5], 1.000, 0.500, NOT_AA5);
      $setuphold(posedge CLKA &&& re_flagA,posedge AA[6], 1.000, 0.500, NOT_AA6);
      $setuphold(posedge CLKA &&& re_flagA,negedge AA[6], 1.000, 0.500, NOT_AA6);
      $setuphold(posedge CLKA &&& re_flagA,posedge AA[7], 1.000, 0.500, NOT_AA7);
      $setuphold(posedge CLKA &&& re_flagA,negedge AA[7], 1.000, 0.500, NOT_AA7);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[0], 1.000, 0.500, NOT_DA0);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[0], 1.000, 0.500, NOT_DA0);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[1], 1.000, 0.500, NOT_DA1);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[1], 1.000, 0.500, NOT_DA1);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[2], 1.000, 0.500, NOT_DA2);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[2], 1.000, 0.500, NOT_DA2);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[3], 1.000, 0.500, NOT_DA3);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[3], 1.000, 0.500, NOT_DA3);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[4], 1.000, 0.500, NOT_DA4);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[4], 1.000, 0.500, NOT_DA4);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[5], 1.000, 0.500, NOT_DA5);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[5], 1.000, 0.500, NOT_DA5);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[6], 1.000, 0.500, NOT_DA6);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[6], 1.000, 0.500, NOT_DA6);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[7], 1.000, 0.500, NOT_DA7);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[7], 1.000, 0.500, NOT_DA7);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[8], 1.000, 0.500, NOT_DA8);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[8], 1.000, 0.500, NOT_DA8);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[9], 1.000, 0.500, NOT_DA9);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[9], 1.000, 0.500, NOT_DA9);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[10], 1.000, 0.500, NOT_DA10);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[10], 1.000, 0.500, NOT_DA10);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[11], 1.000, 0.500, NOT_DA11);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[11], 1.000, 0.500, NOT_DA11);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[12], 1.000, 0.500, NOT_DA12);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[12], 1.000, 0.500, NOT_DA12);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[13], 1.000, 0.500, NOT_DA13);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[13], 1.000, 0.500, NOT_DA13);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[14], 1.000, 0.500, NOT_DA14);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[14], 1.000, 0.500, NOT_DA14);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[15], 1.000, 0.500, NOT_DA15);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[15], 1.000, 0.500, NOT_DA15);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[16], 1.000, 0.500, NOT_DA16);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[16], 1.000, 0.500, NOT_DA16);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[17], 1.000, 0.500, NOT_DA17);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[17], 1.000, 0.500, NOT_DA17);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[18], 1.000, 0.500, NOT_DA18);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[18], 1.000, 0.500, NOT_DA18);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[19], 1.000, 0.500, NOT_DA19);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[19], 1.000, 0.500, NOT_DA19);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[20], 1.000, 0.500, NOT_DA20);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[20], 1.000, 0.500, NOT_DA20);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[21], 1.000, 0.500, NOT_DA21);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[21], 1.000, 0.500, NOT_DA21);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[22], 1.000, 0.500, NOT_DA22);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[22], 1.000, 0.500, NOT_DA22);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[23], 1.000, 0.500, NOT_DA23);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[23], 1.000, 0.500, NOT_DA23);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[24], 1.000, 0.500, NOT_DA24);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[24], 1.000, 0.500, NOT_DA24);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[25], 1.000, 0.500, NOT_DA25);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[25], 1.000, 0.500, NOT_DA25);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[26], 1.000, 0.500, NOT_DA26);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[26], 1.000, 0.500, NOT_DA26);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[27], 1.000, 0.500, NOT_DA27);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[27], 1.000, 0.500, NOT_DA27);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[28], 1.000, 0.500, NOT_DA28);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[28], 1.000, 0.500, NOT_DA28);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[29], 1.000, 0.500, NOT_DA29);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[29], 1.000, 0.500, NOT_DA29);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[30], 1.000, 0.500, NOT_DA30);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[30], 1.000, 0.500, NOT_DA30);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[31], 1.000, 0.500, NOT_DA31);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[31], 1.000, 0.500, NOT_DA31);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[32], 1.000, 0.500, NOT_DA32);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[32], 1.000, 0.500, NOT_DA32);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[33], 1.000, 0.500, NOT_DA33);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[33], 1.000, 0.500, NOT_DA33);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[34], 1.000, 0.500, NOT_DA34);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[34], 1.000, 0.500, NOT_DA34);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[35], 1.000, 0.500, NOT_DA35);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[35], 1.000, 0.500, NOT_DA35);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[36], 1.000, 0.500, NOT_DA36);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[36], 1.000, 0.500, NOT_DA36);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[37], 1.000, 0.500, NOT_DA37);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[37], 1.000, 0.500, NOT_DA37);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[38], 1.000, 0.500, NOT_DA38);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[38], 1.000, 0.500, NOT_DA38);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[39], 1.000, 0.500, NOT_DA39);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[39], 1.000, 0.500, NOT_DA39);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[40], 1.000, 0.500, NOT_DA40);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[40], 1.000, 0.500, NOT_DA40);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[41], 1.000, 0.500, NOT_DA41);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[41], 1.000, 0.500, NOT_DA41);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[42], 1.000, 0.500, NOT_DA42);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[42], 1.000, 0.500, NOT_DA42);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[43], 1.000, 0.500, NOT_DA43);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[43], 1.000, 0.500, NOT_DA43);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[44], 1.000, 0.500, NOT_DA44);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[44], 1.000, 0.500, NOT_DA44);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[45], 1.000, 0.500, NOT_DA45);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[45], 1.000, 0.500, NOT_DA45);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[46], 1.000, 0.500, NOT_DA46);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[46], 1.000, 0.500, NOT_DA46);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[47], 1.000, 0.500, NOT_DA47);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[47], 1.000, 0.500, NOT_DA47);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[48], 1.000, 0.500, NOT_DA48);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[48], 1.000, 0.500, NOT_DA48);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[49], 1.000, 0.500, NOT_DA49);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[49], 1.000, 0.500, NOT_DA49);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[50], 1.000, 0.500, NOT_DA50);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[50], 1.000, 0.500, NOT_DA50);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[51], 1.000, 0.500, NOT_DA51);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[51], 1.000, 0.500, NOT_DA51);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[52], 1.000, 0.500, NOT_DA52);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[52], 1.000, 0.500, NOT_DA52);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[53], 1.000, 0.500, NOT_DA53);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[53], 1.000, 0.500, NOT_DA53);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[54], 1.000, 0.500, NOT_DA54);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[54], 1.000, 0.500, NOT_DA54);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[55], 1.000, 0.500, NOT_DA55);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[55], 1.000, 0.500, NOT_DA55);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[56], 1.000, 0.500, NOT_DA56);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[56], 1.000, 0.500, NOT_DA56);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[57], 1.000, 0.500, NOT_DA57);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[57], 1.000, 0.500, NOT_DA57);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[58], 1.000, 0.500, NOT_DA58);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[58], 1.000, 0.500, NOT_DA58);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[59], 1.000, 0.500, NOT_DA59);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[59], 1.000, 0.500, NOT_DA59);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[60], 1.000, 0.500, NOT_DA60);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[60], 1.000, 0.500, NOT_DA60);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[61], 1.000, 0.500, NOT_DA61);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[61], 1.000, 0.500, NOT_DA61);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[62], 1.000, 0.500, NOT_DA62);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[62], 1.000, 0.500, NOT_DA62);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[63], 1.000, 0.500, NOT_DA63);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[63], 1.000, 0.500, NOT_DA63);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[64], 1.000, 0.500, NOT_DA64);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[64], 1.000, 0.500, NOT_DA64);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[65], 1.000, 0.500, NOT_DA65);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[65], 1.000, 0.500, NOT_DA65);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[66], 1.000, 0.500, NOT_DA66);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[66], 1.000, 0.500, NOT_DA66);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[67], 1.000, 0.500, NOT_DA67);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[67], 1.000, 0.500, NOT_DA67);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[68], 1.000, 0.500, NOT_DA68);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[68], 1.000, 0.500, NOT_DA68);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[69], 1.000, 0.500, NOT_DA69);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[69], 1.000, 0.500, NOT_DA69);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[70], 1.000, 0.500, NOT_DA70);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[70], 1.000, 0.500, NOT_DA70);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[71], 1.000, 0.500, NOT_DA71);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[71], 1.000, 0.500, NOT_DA71);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[72], 1.000, 0.500, NOT_DA72);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[72], 1.000, 0.500, NOT_DA72);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[73], 1.000, 0.500, NOT_DA73);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[73], 1.000, 0.500, NOT_DA73);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[74], 1.000, 0.500, NOT_DA74);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[74], 1.000, 0.500, NOT_DA74);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[75], 1.000, 0.500, NOT_DA75);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[75], 1.000, 0.500, NOT_DA75);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[76], 1.000, 0.500, NOT_DA76);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[76], 1.000, 0.500, NOT_DA76);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[77], 1.000, 0.500, NOT_DA77);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[77], 1.000, 0.500, NOT_DA77);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[78], 1.000, 0.500, NOT_DA78);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[78], 1.000, 0.500, NOT_DA78);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[79], 1.000, 0.500, NOT_DA79);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[79], 1.000, 0.500, NOT_DA79);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[80], 1.000, 0.500, NOT_DA80);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[80], 1.000, 0.500, NOT_DA80);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[81], 1.000, 0.500, NOT_DA81);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[81], 1.000, 0.500, NOT_DA81);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[82], 1.000, 0.500, NOT_DA82);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[82], 1.000, 0.500, NOT_DA82);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[83], 1.000, 0.500, NOT_DA83);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[83], 1.000, 0.500, NOT_DA83);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[84], 1.000, 0.500, NOT_DA84);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[84], 1.000, 0.500, NOT_DA84);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[85], 1.000, 0.500, NOT_DA85);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[85], 1.000, 0.500, NOT_DA85);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[86], 1.000, 0.500, NOT_DA86);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[86], 1.000, 0.500, NOT_DA86);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[87], 1.000, 0.500, NOT_DA87);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[87], 1.000, 0.500, NOT_DA87);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[88], 1.000, 0.500, NOT_DA88);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[88], 1.000, 0.500, NOT_DA88);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[89], 1.000, 0.500, NOT_DA89);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[89], 1.000, 0.500, NOT_DA89);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[90], 1.000, 0.500, NOT_DA90);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[90], 1.000, 0.500, NOT_DA90);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[91], 1.000, 0.500, NOT_DA91);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[91], 1.000, 0.500, NOT_DA91);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[92], 1.000, 0.500, NOT_DA92);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[92], 1.000, 0.500, NOT_DA92);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[93], 1.000, 0.500, NOT_DA93);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[93], 1.000, 0.500, NOT_DA93);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[94], 1.000, 0.500, NOT_DA94);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[94], 1.000, 0.500, NOT_DA94);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[95], 1.000, 0.500, NOT_DA95);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[95], 1.000, 0.500, NOT_DA95);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[96], 1.000, 0.500, NOT_DA96);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[96], 1.000, 0.500, NOT_DA96);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[97], 1.000, 0.500, NOT_DA97);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[97], 1.000, 0.500, NOT_DA97);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[98], 1.000, 0.500, NOT_DA98);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[98], 1.000, 0.500, NOT_DA98);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[99], 1.000, 0.500, NOT_DA99);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[99], 1.000, 0.500, NOT_DA99);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[100], 1.000, 0.500, NOT_DA100);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[100], 1.000, 0.500, NOT_DA100);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[101], 1.000, 0.500, NOT_DA101);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[101], 1.000, 0.500, NOT_DA101);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[102], 1.000, 0.500, NOT_DA102);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[102], 1.000, 0.500, NOT_DA102);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[103], 1.000, 0.500, NOT_DA103);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[103], 1.000, 0.500, NOT_DA103);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[104], 1.000, 0.500, NOT_DA104);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[104], 1.000, 0.500, NOT_DA104);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[105], 1.000, 0.500, NOT_DA105);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[105], 1.000, 0.500, NOT_DA105);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[106], 1.000, 0.500, NOT_DA106);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[106], 1.000, 0.500, NOT_DA106);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[107], 1.000, 0.500, NOT_DA107);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[107], 1.000, 0.500, NOT_DA107);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[108], 1.000, 0.500, NOT_DA108);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[108], 1.000, 0.500, NOT_DA108);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[109], 1.000, 0.500, NOT_DA109);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[109], 1.000, 0.500, NOT_DA109);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[110], 1.000, 0.500, NOT_DA110);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[110], 1.000, 0.500, NOT_DA110);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[111], 1.000, 0.500, NOT_DA111);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[111], 1.000, 0.500, NOT_DA111);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[112], 1.000, 0.500, NOT_DA112);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[112], 1.000, 0.500, NOT_DA112);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[113], 1.000, 0.500, NOT_DA113);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[113], 1.000, 0.500, NOT_DA113);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[114], 1.000, 0.500, NOT_DA114);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[114], 1.000, 0.500, NOT_DA114);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[115], 1.000, 0.500, NOT_DA115);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[115], 1.000, 0.500, NOT_DA115);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[116], 1.000, 0.500, NOT_DA116);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[116], 1.000, 0.500, NOT_DA116);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[117], 1.000, 0.500, NOT_DA117);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[117], 1.000, 0.500, NOT_DA117);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[118], 1.000, 0.500, NOT_DA118);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[118], 1.000, 0.500, NOT_DA118);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[119], 1.000, 0.500, NOT_DA119);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[119], 1.000, 0.500, NOT_DA119);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[120], 1.000, 0.500, NOT_DA120);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[120], 1.000, 0.500, NOT_DA120);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[121], 1.000, 0.500, NOT_DA121);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[121], 1.000, 0.500, NOT_DA121);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[122], 1.000, 0.500, NOT_DA122);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[122], 1.000, 0.500, NOT_DA122);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[123], 1.000, 0.500, NOT_DA123);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[123], 1.000, 0.500, NOT_DA123);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[124], 1.000, 0.500, NOT_DA124);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[124], 1.000, 0.500, NOT_DA124);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[125], 1.000, 0.500, NOT_DA125);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[125], 1.000, 0.500, NOT_DA125);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[126], 1.000, 0.500, NOT_DA126);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[126], 1.000, 0.500, NOT_DA126);
      $setuphold(posedge CLKA &&& re_data_flagA,posedge DA[127], 1.000, 0.500, NOT_DA127);
      $setuphold(posedge CLKA &&& re_data_flagA,negedge DA[127], 1.000, 0.500, NOT_DA127);
      $setuphold(posedge CLKB,posedge CENB, 1.000, 0.500, NOT_CENB);
      $setuphold(posedge CLKB,negedge CENB, 1.000, 0.500, NOT_CENB);
      $setuphold(posedge CLKB &&& re_flagB,posedge WENB, 1.000, 0.500, NOT_WENB);
      $setuphold(posedge CLKB &&& re_flagB,negedge WENB, 1.000, 0.500, NOT_WENB);
      $setuphold(posedge CLKB &&& re_flagB,posedge AB[0], 1.000, 0.500, NOT_AB0);
      $setuphold(posedge CLKB &&& re_flagB,negedge AB[0], 1.000, 0.500, NOT_AB0);
      $setuphold(posedge CLKB &&& re_flagB,posedge AB[1], 1.000, 0.500, NOT_AB1);
      $setuphold(posedge CLKB &&& re_flagB,negedge AB[1], 1.000, 0.500, NOT_AB1);
      $setuphold(posedge CLKB &&& re_flagB,posedge AB[2], 1.000, 0.500, NOT_AB2);
      $setuphold(posedge CLKB &&& re_flagB,negedge AB[2], 1.000, 0.500, NOT_AB2);
      $setuphold(posedge CLKB &&& re_flagB,posedge AB[3], 1.000, 0.500, NOT_AB3);
      $setuphold(posedge CLKB &&& re_flagB,negedge AB[3], 1.000, 0.500, NOT_AB3);
      $setuphold(posedge CLKB &&& re_flagB,posedge AB[4], 1.000, 0.500, NOT_AB4);
      $setuphold(posedge CLKB &&& re_flagB,negedge AB[4], 1.000, 0.500, NOT_AB4);
      $setuphold(posedge CLKB &&& re_flagB,posedge AB[5], 1.000, 0.500, NOT_AB5);
      $setuphold(posedge CLKB &&& re_flagB,negedge AB[5], 1.000, 0.500, NOT_AB5);
      $setuphold(posedge CLKB &&& re_flagB,posedge AB[6], 1.000, 0.500, NOT_AB6);
      $setuphold(posedge CLKB &&& re_flagB,negedge AB[6], 1.000, 0.500, NOT_AB6);
      $setuphold(posedge CLKB &&& re_flagB,posedge AB[7], 1.000, 0.500, NOT_AB7);
      $setuphold(posedge CLKB &&& re_flagB,negedge AB[7], 1.000, 0.500, NOT_AB7);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[0], 1.000, 0.500, NOT_DB0);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[0], 1.000, 0.500, NOT_DB0);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[1], 1.000, 0.500, NOT_DB1);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[1], 1.000, 0.500, NOT_DB1);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[2], 1.000, 0.500, NOT_DB2);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[2], 1.000, 0.500, NOT_DB2);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[3], 1.000, 0.500, NOT_DB3);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[3], 1.000, 0.500, NOT_DB3);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[4], 1.000, 0.500, NOT_DB4);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[4], 1.000, 0.500, NOT_DB4);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[5], 1.000, 0.500, NOT_DB5);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[5], 1.000, 0.500, NOT_DB5);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[6], 1.000, 0.500, NOT_DB6);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[6], 1.000, 0.500, NOT_DB6);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[7], 1.000, 0.500, NOT_DB7);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[7], 1.000, 0.500, NOT_DB7);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[8], 1.000, 0.500, NOT_DB8);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[8], 1.000, 0.500, NOT_DB8);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[9], 1.000, 0.500, NOT_DB9);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[9], 1.000, 0.500, NOT_DB9);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[10], 1.000, 0.500, NOT_DB10);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[10], 1.000, 0.500, NOT_DB10);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[11], 1.000, 0.500, NOT_DB11);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[11], 1.000, 0.500, NOT_DB11);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[12], 1.000, 0.500, NOT_DB12);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[12], 1.000, 0.500, NOT_DB12);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[13], 1.000, 0.500, NOT_DB13);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[13], 1.000, 0.500, NOT_DB13);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[14], 1.000, 0.500, NOT_DB14);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[14], 1.000, 0.500, NOT_DB14);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[15], 1.000, 0.500, NOT_DB15);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[15], 1.000, 0.500, NOT_DB15);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[16], 1.000, 0.500, NOT_DB16);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[16], 1.000, 0.500, NOT_DB16);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[17], 1.000, 0.500, NOT_DB17);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[17], 1.000, 0.500, NOT_DB17);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[18], 1.000, 0.500, NOT_DB18);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[18], 1.000, 0.500, NOT_DB18);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[19], 1.000, 0.500, NOT_DB19);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[19], 1.000, 0.500, NOT_DB19);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[20], 1.000, 0.500, NOT_DB20);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[20], 1.000, 0.500, NOT_DB20);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[21], 1.000, 0.500, NOT_DB21);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[21], 1.000, 0.500, NOT_DB21);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[22], 1.000, 0.500, NOT_DB22);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[22], 1.000, 0.500, NOT_DB22);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[23], 1.000, 0.500, NOT_DB23);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[23], 1.000, 0.500, NOT_DB23);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[24], 1.000, 0.500, NOT_DB24);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[24], 1.000, 0.500, NOT_DB24);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[25], 1.000, 0.500, NOT_DB25);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[25], 1.000, 0.500, NOT_DB25);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[26], 1.000, 0.500, NOT_DB26);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[26], 1.000, 0.500, NOT_DB26);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[27], 1.000, 0.500, NOT_DB27);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[27], 1.000, 0.500, NOT_DB27);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[28], 1.000, 0.500, NOT_DB28);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[28], 1.000, 0.500, NOT_DB28);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[29], 1.000, 0.500, NOT_DB29);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[29], 1.000, 0.500, NOT_DB29);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[30], 1.000, 0.500, NOT_DB30);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[30], 1.000, 0.500, NOT_DB30);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[31], 1.000, 0.500, NOT_DB31);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[31], 1.000, 0.500, NOT_DB31);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[32], 1.000, 0.500, NOT_DB32);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[32], 1.000, 0.500, NOT_DB32);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[33], 1.000, 0.500, NOT_DB33);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[33], 1.000, 0.500, NOT_DB33);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[34], 1.000, 0.500, NOT_DB34);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[34], 1.000, 0.500, NOT_DB34);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[35], 1.000, 0.500, NOT_DB35);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[35], 1.000, 0.500, NOT_DB35);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[36], 1.000, 0.500, NOT_DB36);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[36], 1.000, 0.500, NOT_DB36);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[37], 1.000, 0.500, NOT_DB37);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[37], 1.000, 0.500, NOT_DB37);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[38], 1.000, 0.500, NOT_DB38);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[38], 1.000, 0.500, NOT_DB38);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[39], 1.000, 0.500, NOT_DB39);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[39], 1.000, 0.500, NOT_DB39);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[40], 1.000, 0.500, NOT_DB40);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[40], 1.000, 0.500, NOT_DB40);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[41], 1.000, 0.500, NOT_DB41);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[41], 1.000, 0.500, NOT_DB41);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[42], 1.000, 0.500, NOT_DB42);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[42], 1.000, 0.500, NOT_DB42);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[43], 1.000, 0.500, NOT_DB43);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[43], 1.000, 0.500, NOT_DB43);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[44], 1.000, 0.500, NOT_DB44);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[44], 1.000, 0.500, NOT_DB44);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[45], 1.000, 0.500, NOT_DB45);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[45], 1.000, 0.500, NOT_DB45);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[46], 1.000, 0.500, NOT_DB46);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[46], 1.000, 0.500, NOT_DB46);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[47], 1.000, 0.500, NOT_DB47);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[47], 1.000, 0.500, NOT_DB47);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[48], 1.000, 0.500, NOT_DB48);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[48], 1.000, 0.500, NOT_DB48);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[49], 1.000, 0.500, NOT_DB49);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[49], 1.000, 0.500, NOT_DB49);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[50], 1.000, 0.500, NOT_DB50);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[50], 1.000, 0.500, NOT_DB50);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[51], 1.000, 0.500, NOT_DB51);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[51], 1.000, 0.500, NOT_DB51);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[52], 1.000, 0.500, NOT_DB52);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[52], 1.000, 0.500, NOT_DB52);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[53], 1.000, 0.500, NOT_DB53);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[53], 1.000, 0.500, NOT_DB53);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[54], 1.000, 0.500, NOT_DB54);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[54], 1.000, 0.500, NOT_DB54);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[55], 1.000, 0.500, NOT_DB55);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[55], 1.000, 0.500, NOT_DB55);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[56], 1.000, 0.500, NOT_DB56);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[56], 1.000, 0.500, NOT_DB56);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[57], 1.000, 0.500, NOT_DB57);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[57], 1.000, 0.500, NOT_DB57);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[58], 1.000, 0.500, NOT_DB58);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[58], 1.000, 0.500, NOT_DB58);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[59], 1.000, 0.500, NOT_DB59);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[59], 1.000, 0.500, NOT_DB59);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[60], 1.000, 0.500, NOT_DB60);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[60], 1.000, 0.500, NOT_DB60);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[61], 1.000, 0.500, NOT_DB61);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[61], 1.000, 0.500, NOT_DB61);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[62], 1.000, 0.500, NOT_DB62);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[62], 1.000, 0.500, NOT_DB62);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[63], 1.000, 0.500, NOT_DB63);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[63], 1.000, 0.500, NOT_DB63);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[64], 1.000, 0.500, NOT_DB64);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[64], 1.000, 0.500, NOT_DB64);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[65], 1.000, 0.500, NOT_DB65);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[65], 1.000, 0.500, NOT_DB65);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[66], 1.000, 0.500, NOT_DB66);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[66], 1.000, 0.500, NOT_DB66);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[67], 1.000, 0.500, NOT_DB67);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[67], 1.000, 0.500, NOT_DB67);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[68], 1.000, 0.500, NOT_DB68);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[68], 1.000, 0.500, NOT_DB68);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[69], 1.000, 0.500, NOT_DB69);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[69], 1.000, 0.500, NOT_DB69);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[70], 1.000, 0.500, NOT_DB70);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[70], 1.000, 0.500, NOT_DB70);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[71], 1.000, 0.500, NOT_DB71);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[71], 1.000, 0.500, NOT_DB71);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[72], 1.000, 0.500, NOT_DB72);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[72], 1.000, 0.500, NOT_DB72);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[73], 1.000, 0.500, NOT_DB73);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[73], 1.000, 0.500, NOT_DB73);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[74], 1.000, 0.500, NOT_DB74);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[74], 1.000, 0.500, NOT_DB74);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[75], 1.000, 0.500, NOT_DB75);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[75], 1.000, 0.500, NOT_DB75);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[76], 1.000, 0.500, NOT_DB76);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[76], 1.000, 0.500, NOT_DB76);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[77], 1.000, 0.500, NOT_DB77);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[77], 1.000, 0.500, NOT_DB77);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[78], 1.000, 0.500, NOT_DB78);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[78], 1.000, 0.500, NOT_DB78);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[79], 1.000, 0.500, NOT_DB79);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[79], 1.000, 0.500, NOT_DB79);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[80], 1.000, 0.500, NOT_DB80);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[80], 1.000, 0.500, NOT_DB80);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[81], 1.000, 0.500, NOT_DB81);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[81], 1.000, 0.500, NOT_DB81);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[82], 1.000, 0.500, NOT_DB82);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[82], 1.000, 0.500, NOT_DB82);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[83], 1.000, 0.500, NOT_DB83);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[83], 1.000, 0.500, NOT_DB83);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[84], 1.000, 0.500, NOT_DB84);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[84], 1.000, 0.500, NOT_DB84);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[85], 1.000, 0.500, NOT_DB85);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[85], 1.000, 0.500, NOT_DB85);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[86], 1.000, 0.500, NOT_DB86);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[86], 1.000, 0.500, NOT_DB86);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[87], 1.000, 0.500, NOT_DB87);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[87], 1.000, 0.500, NOT_DB87);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[88], 1.000, 0.500, NOT_DB88);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[88], 1.000, 0.500, NOT_DB88);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[89], 1.000, 0.500, NOT_DB89);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[89], 1.000, 0.500, NOT_DB89);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[90], 1.000, 0.500, NOT_DB90);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[90], 1.000, 0.500, NOT_DB90);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[91], 1.000, 0.500, NOT_DB91);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[91], 1.000, 0.500, NOT_DB91);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[92], 1.000, 0.500, NOT_DB92);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[92], 1.000, 0.500, NOT_DB92);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[93], 1.000, 0.500, NOT_DB93);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[93], 1.000, 0.500, NOT_DB93);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[94], 1.000, 0.500, NOT_DB94);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[94], 1.000, 0.500, NOT_DB94);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[95], 1.000, 0.500, NOT_DB95);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[95], 1.000, 0.500, NOT_DB95);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[96], 1.000, 0.500, NOT_DB96);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[96], 1.000, 0.500, NOT_DB96);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[97], 1.000, 0.500, NOT_DB97);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[97], 1.000, 0.500, NOT_DB97);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[98], 1.000, 0.500, NOT_DB98);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[98], 1.000, 0.500, NOT_DB98);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[99], 1.000, 0.500, NOT_DB99);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[99], 1.000, 0.500, NOT_DB99);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[100], 1.000, 0.500, NOT_DB100);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[100], 1.000, 0.500, NOT_DB100);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[101], 1.000, 0.500, NOT_DB101);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[101], 1.000, 0.500, NOT_DB101);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[102], 1.000, 0.500, NOT_DB102);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[102], 1.000, 0.500, NOT_DB102);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[103], 1.000, 0.500, NOT_DB103);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[103], 1.000, 0.500, NOT_DB103);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[104], 1.000, 0.500, NOT_DB104);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[104], 1.000, 0.500, NOT_DB104);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[105], 1.000, 0.500, NOT_DB105);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[105], 1.000, 0.500, NOT_DB105);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[106], 1.000, 0.500, NOT_DB106);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[106], 1.000, 0.500, NOT_DB106);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[107], 1.000, 0.500, NOT_DB107);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[107], 1.000, 0.500, NOT_DB107);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[108], 1.000, 0.500, NOT_DB108);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[108], 1.000, 0.500, NOT_DB108);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[109], 1.000, 0.500, NOT_DB109);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[109], 1.000, 0.500, NOT_DB109);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[110], 1.000, 0.500, NOT_DB110);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[110], 1.000, 0.500, NOT_DB110);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[111], 1.000, 0.500, NOT_DB111);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[111], 1.000, 0.500, NOT_DB111);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[112], 1.000, 0.500, NOT_DB112);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[112], 1.000, 0.500, NOT_DB112);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[113], 1.000, 0.500, NOT_DB113);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[113], 1.000, 0.500, NOT_DB113);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[114], 1.000, 0.500, NOT_DB114);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[114], 1.000, 0.500, NOT_DB114);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[115], 1.000, 0.500, NOT_DB115);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[115], 1.000, 0.500, NOT_DB115);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[116], 1.000, 0.500, NOT_DB116);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[116], 1.000, 0.500, NOT_DB116);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[117], 1.000, 0.500, NOT_DB117);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[117], 1.000, 0.500, NOT_DB117);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[118], 1.000, 0.500, NOT_DB118);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[118], 1.000, 0.500, NOT_DB118);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[119], 1.000, 0.500, NOT_DB119);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[119], 1.000, 0.500, NOT_DB119);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[120], 1.000, 0.500, NOT_DB120);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[120], 1.000, 0.500, NOT_DB120);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[121], 1.000, 0.500, NOT_DB121);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[121], 1.000, 0.500, NOT_DB121);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[122], 1.000, 0.500, NOT_DB122);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[122], 1.000, 0.500, NOT_DB122);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[123], 1.000, 0.500, NOT_DB123);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[123], 1.000, 0.500, NOT_DB123);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[124], 1.000, 0.500, NOT_DB124);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[124], 1.000, 0.500, NOT_DB124);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[125], 1.000, 0.500, NOT_DB125);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[125], 1.000, 0.500, NOT_DB125);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[126], 1.000, 0.500, NOT_DB126);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[126], 1.000, 0.500, NOT_DB126);
      $setuphold(posedge CLKB &&& re_data_flagB,posedge DB[127], 1.000, 0.500, NOT_DB127);
      $setuphold(posedge CLKB &&& re_data_flagB,negedge DB[127], 1.000, 0.500, NOT_DB127);
      $setup(posedge CLKA, posedge CLKB &&& contB_flag, 3.000, NOT_CONTB);
      $setup(posedge CLKB, posedge CLKA &&& contA_flag, 3.000, NOT_CONTA);
      $hold(posedge CLKA, posedge CLKB &&& cont_flag, 0.010, NOT_CONTB);

      $period(posedge CLKA, 3.000, NOT_CLKA_PER);
      $width(posedge CLKA, 1.000, 0, NOT_CLKA_MINH);
      $width(negedge CLKA, 1.000, 0, NOT_CLKA_MINL);
      $period(posedge CLKB, 3.000, NOT_CLKB_PER);
      $width(posedge CLKB, 1.000, 0, NOT_CLKB_MINH);
      $width(negedge CLKB, 1.000, 0, NOT_CLKB_MINL);

      (posedge CLKA => (QA[0]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[1]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[2]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[3]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[4]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[5]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[6]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[7]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[8]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[9]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[10]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[11]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[12]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[13]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[14]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[15]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[16]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[17]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[18]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[19]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[20]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[21]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[22]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[23]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[24]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[25]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[26]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[27]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[28]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[29]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[30]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[31]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[32]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[33]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[34]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[35]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[36]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[37]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[38]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[39]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[40]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[41]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[42]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[43]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[44]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[45]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[46]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[47]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[48]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[49]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[50]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[51]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[52]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[53]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[54]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[55]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[56]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[57]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[58]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[59]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[60]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[61]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[62]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[63]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[64]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[65]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[66]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[67]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[68]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[69]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[70]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[71]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[72]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[73]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[74]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[75]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[76]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[77]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[78]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[79]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[80]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[81]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[82]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[83]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[84]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[85]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[86]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[87]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[88]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[89]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[90]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[91]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[92]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[93]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[94]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[95]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[96]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[97]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[98]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[99]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[100]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[101]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[102]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[103]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[104]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[105]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[106]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[107]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[108]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[109]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[110]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[111]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[112]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[113]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[114]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[115]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[116]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[117]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[118]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[119]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[120]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[121]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[122]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[123]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[124]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[125]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[126]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKA => (QA[127]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge OENA => (QA[0]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[1]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[2]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[3]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[4]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[5]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[6]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[7]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[8]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[9]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[10]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[11]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[12]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[13]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[14]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[15]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[16]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[17]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[18]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[19]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[20]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[21]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[22]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[23]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[24]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[25]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[26]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[27]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[28]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[29]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[30]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[31]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[32]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[33]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[34]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[35]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[36]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[37]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[38]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[39]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[40]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[41]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[42]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[43]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[44]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[45]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[46]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[47]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[48]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[49]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[50]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[51]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[52]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[53]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[54]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[55]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[56]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[57]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[58]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[59]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[60]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[61]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[62]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[63]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[64]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[65]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[66]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[67]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[68]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[69]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[70]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[71]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[72]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[73]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[74]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[75]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[76]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[77]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[78]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[79]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[80]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[81]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[82]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[83]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[84]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[85]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[86]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[87]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[88]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[89]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[90]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[91]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[92]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[93]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[94]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[95]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[96]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[97]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[98]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[99]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[100]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[101]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[102]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[103]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[104]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[105]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[106]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[107]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[108]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[109]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[110]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[111]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[112]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[113]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[114]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[115]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[116]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[117]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[118]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[119]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[120]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[121]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[122]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[123]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[124]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[125]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[126]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENA => (QA[127]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge CLKB => (QB[0]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[1]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[2]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[3]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[4]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[5]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[6]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[7]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[8]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[9]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[10]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[11]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[12]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[13]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[14]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[15]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[16]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[17]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[18]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[19]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[20]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[21]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[22]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[23]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[24]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[25]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[26]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[27]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[28]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[29]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[30]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[31]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[32]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[33]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[34]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[35]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[36]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[37]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[38]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[39]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[40]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[41]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[42]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[43]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[44]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[45]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[46]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[47]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[48]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[49]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[50]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[51]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[52]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[53]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[54]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[55]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[56]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[57]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[58]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[59]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[60]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[61]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[62]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[63]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[64]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[65]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[66]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[67]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[68]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[69]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[70]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[71]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[72]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[73]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[74]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[75]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[76]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[77]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[78]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[79]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[80]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[81]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[82]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[83]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[84]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[85]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[86]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[87]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[88]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[89]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[90]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[91]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[92]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[93]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[94]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[95]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[96]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[97]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[98]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[99]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[100]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[101]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[102]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[103]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[104]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[105]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[106]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[107]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[108]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[109]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[110]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[111]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[112]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[113]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[114]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[115]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[116]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[117]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[118]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[119]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[120]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[121]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[122]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[123]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[124]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[125]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[126]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge CLKB => (QB[127]:1'bx))=(1.000, 1.000, 0.500, 1.000, 0.500, 1.000);
      (posedge OENB => (QB[0]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[1]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[2]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[3]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[4]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[5]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[6]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[7]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[8]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[9]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[10]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[11]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[12]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[13]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[14]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[15]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[16]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[17]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[18]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[19]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[20]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[21]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[22]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[23]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[24]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[25]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[26]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[27]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[28]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[29]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[30]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[31]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[32]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[33]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[34]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[35]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[36]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[37]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[38]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[39]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[40]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[41]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[42]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[43]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[44]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[45]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[46]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[47]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[48]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[49]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[50]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[51]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[52]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[53]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[54]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[55]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[56]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[57]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[58]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[59]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[60]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[61]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[62]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[63]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[64]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[65]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[66]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[67]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[68]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[69]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[70]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[71]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[72]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[73]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[74]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[75]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[76]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[77]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[78]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[79]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[80]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[81]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[82]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[83]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[84]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[85]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[86]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[87]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[88]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[89]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[90]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[91]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[92]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[93]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[94]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[95]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[96]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[97]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[98]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[99]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[100]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[101]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[102]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[103]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[104]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[105]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[106]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[107]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[108]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[109]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[110]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[111]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[112]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[113]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[114]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[115]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[116]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[117]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[118]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[119]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[120]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[121]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[122]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[123]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[124]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[125]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[126]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
      (posedge OENB => (QB[127]:1'bx))=(1.000, 1.000, 1.000, 1.000, 1.000, 1.000);
   endspecify

endmodule
`endcelldefine
