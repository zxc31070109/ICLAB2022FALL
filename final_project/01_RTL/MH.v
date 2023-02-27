//synopsys translate_off
`include "DW_div.v"
`include "DW_div_pipe.v"
`include "DW_addsub_dx.v"
`include "DW_minmax.v"
//synopsys translate_on


module MH(
        
    clk            ,   
    clk2           , 
    rst_n          ,    
    in_valid       ,
    op_valid       ,    
    op             ,    
    pic_data       ,      
    se_data        ,      

    
    out_valid      ,
    out_data
        
             );
//======================================
//          I/O PORTS to pattern
//======================================
input  clk, clk2,rst_n, in_valid, op_valid;
input  [2:0] op;
input  [31:0] pic_data;
input  [7:0] se_data;


output reg out_valid;
output reg [31:0] out_data;

//======================================
//          AXI
//======================================
// axi write addr channel 
// src master
parameter ID_WIDTH = 4 , ADDR_WIDTH = 32, DATA_WIDTH = 32;



// -----------------------------

//======================================
//          fsm
//======================================
//***********************************              
// parameter      
//***********************************    

parameter IDLE                     =  4'd0;
parameter INPUT                    =  4'd1;
parameter HIS                      =  4'd2;
parameter OPENOP                   =  4'd3; 
parameter CAL                      =  4'd4; 
parameter CAL_HIS1                 =  4'd5;  
parameter CAL_CDF                  =  4'd6; 
parameter CAL_DIV                  =  4'd7;
parameter READ_SRAM                =  4'd8;
parameter OPEN                     =  4'd9;
parameter OUTPUT                   =  4'd10;
//****************************************************************************************************************************************************************
//Reg Daclaration          
//****************************************************************************************************************************************************************
reg [3:0]cstate;
reg [3:0]cstate_d;
reg [3:0]nstate;                            
reg[2:0]    op_reg           ;
reg[31:0]    pic_no_reg       ;
reg[127:0]    se_no_reg        ;     

reg [7:0]rvalid_cnt;
reg [9:0]rvalid_cnt_d1;
wire [1:0]four_idx;
reg [8:0]cnt;
reg se_flag;

//SE SRAM
wire [127:0]DA;
//reg [5:0]address;
wire[5:0]SE_A;
wire[127:0]SE_Q,PIC_Q,PIC_Q1;
wire SE_WEN;



reg[10:0]cdf_min;


//se
wire [2:0]cnt_4;
assign cnt_4 = cnt[2:0];
reg [3:0]count;
reg [7:0]linebuffer[0:11];
reg [127:0]se_ans;
reg [7:0]se_b_sel[0:3][0:3];
reg [31:0]line[0:25];
reg [127:0]SE_Q_r;


//cdf
wire [18:0] x;
wire [10:0]down;
wire [18:0] up;
wire[12:0]value;
wire[18:0]quo;
wire[10:0]rem;
wire pin;
reg [8:0]cnt_d;
reg[5:0]flag;
reg [31:0]update_cdf;
reg [127:0]se_reg;
reg [10:0]cdf_table[0:255];

///SRAM
wire [7:0]I_A1;
wire [31:0]I_D1;
wire [31:0]I_Q1;
reg I1_WEN;
reg [7:0]address;
genvar k,p;
//************************************
//          FSM_sample code
//************************************

final_256_32_100 MEM1 (.Q(I_Q1),  .CLK(clk), .CEN(1'b0), .WEN(I1_WEN), .A(I_A1), .D(I_D1), .OEN(1'b0));


always@(posedge clk or negedge rst_n)
begin
    if(!rst_n) 
        cstate <= IDLE;
    else
        cstate <= nstate;
end

always@(*)
begin
    case(cstate)
    IDLE:
        nstate = (in_valid)? INPUT:IDLE; 
        
    INPUT:
        nstate = (op_reg==0 & cnt ==256)?HIS:((cnt == 281)?(op_reg[2])?OPEN:OUTPUT:INPUT);      
    HIS:
        nstate = CAL;
    CAL:
        nstate = CAL_HIS1;
    CAL_HIS1:
        nstate =(cnt==2)?CAL_CDF:CAL_HIS1;
   
    CAL_CDF:
        nstate = (cnt == 258) ? READ_SRAM:CAL_CDF;
    READ_SRAM: nstate = (cnt == 255)? IDLE:READ_SRAM;
    OPEN: nstate = OPENOP;
    OPENOP: nstate  = (cnt == 283)?IDLE:OPENOP;
    OUTPUT:
        nstate = (cnt == 255)?IDLE:OUTPUT;
    
    default: nstate = IDLE;         
    endcase

end

//======================================
//          input
//======================================
always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
            pic_no_reg<=0;
    end else begin
           if(in_valid) begin
               pic_no_reg<={pic_data};
           end
    end
end
always @(posedge clk or negedge rst_n) begin : proc_po_reg
    if(~rst_n) begin
        op_reg <= 0;
    end else begin
        if(op_valid)
            op_reg <= op;
        else if(cstate == IDLE)
            op_reg <= 0;
        else if(cstate == OPEN && op_reg == 3'b110)
            op_reg <= 3'b111;
        else if(cstate == OPEN && op_reg == 3'b111)
            op_reg <= 3'b110;
    end
end
always @(posedge clk or negedge rst_n) begin : proc_se_reg
    if(~rst_n) begin
        se_reg <= 0;
    end else begin
        if(count == 4'd15 && in_valid)
            se_reg <= se_reg;
        else if(in_valid)
            se_reg <= {se_reg,se_data};

    end
end
always @(posedge clk or negedge rst_n) begin : proc_count
    if(~rst_n) begin
        count <= 0;
    end else begin
        if(cstate == IDLE)
            count <= 0;
        else if(in_valid)begin
            if(count == 15)
                count <= count;
            else 
                count <= count + 1 ;
        end
          
    end
end
always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
        cnt <= 0;
    end else begin
        if(cstate == IDLE)begin
            cnt <= 0;
        end
        else if(nstate == OUTPUT && cstate ==INPUT)
            cnt <= 0;
        else if(cstate == INPUT)begin
            cnt <= cnt + 1;
        end
        else if(cstate == CAL)begin
            cnt <= 0;
        end
        else if(cstate == CAL_HIS1)begin
            cnt <= cnt + 1;
        end
        else if(cstate == CAL_CDF )begin
            if(cnt == 258)begin
                cnt <= 0;
            end
            else
                cnt <= cnt + 1;
        end
        else if(cstate == OPENOP)
            cnt<=cnt+1;
        else if(cstate == READ_SRAM)
            cnt <= cnt+1;
        else if(cstate == OUTPUT)begin
            cnt <= cnt + 1;
        end
        else 
            cnt <= 0;
    end
end
//======================================
//          SRAM
//======================================
always @(*) begin
    if(op_reg==0 && cstate == INPUT &&  cnt<256)begin
        I1_WEN = 0;
    end
    else if(op_reg != 0 && cstate == INPUT &&  cnt<=255+26)begin
        I1_WEN = 0;
    end
    else
        I1_WEN = 1;
end
assign I_D1 = (cstate == INPUT && cnt>=26 && op_reg!=0)?se_ans:pic_no_reg;
assign I_A1 = address;
always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
         address <= 0;
    end 
    else begin
        if(cstate == IDLE)
            address <= 0;
        else if(cstate == INPUT && cnt <16)
            address <= address + 1;
        else if(op_reg == 0 && cstate == INPUT &&  cnt<255)
            address <= address + 1;
        else if(cstate == INPUT && cnt == 24)
            address <= 0;
        else if(cstate == INPUT && cnt>=26 && cnt<=281)
            address <= address + 1;
        else if(cstate == OPENOP)
            address <= address + 1;
        else if(cstate == READ_SRAM)
            address <= address + 1;
        else if(cstate == OUTPUT)
            address <= address + 1;
        else 
            address <= 0;
    end
end
//======================================
//          SE
//======================================
genvar d;
generate
    for(d=0;d<26;d=d+1)begin
        always @(posedge clk) begin
            if(nstate == IDLE) begin
                line[d] <= 0;
            end else begin
                if(cstate == OPENOP)begin
                    if(d==0)
                        line[d] <= (cnt > 256)?0:I_Q1;
                    else
                        line[d] <= line[d-1];
                end
                else begin
                    if(d==0)
                        line[d] <= in_valid?pic_data:0;
                    else
                        line[d] <= line[d-1];
                end
            end
        end
    end
endgenerate

always @(*) begin
    if(op_reg[1:0] == 2'b11)begin
        se_b_sel[0][0] = se_reg[7-:8] ;
        se_b_sel[0][1] = se_reg[15-:8] ;
        se_b_sel[0][2] = se_reg[23-:8] ;
        se_b_sel[0][3] = se_reg[31-:8] ;
        se_b_sel[1][0] = se_reg[39-:8] ;
        se_b_sel[1][1] = se_reg[47-:8] ;
        se_b_sel[1][2] = se_reg[55-:8] ;
        se_b_sel[1][3] = se_reg[63-:8] ;
        se_b_sel[2][0] = se_reg[71-:8] ;
        se_b_sel[2][1] = se_reg[79-:8] ;
        se_b_sel[2][2] = se_reg[87-:8] ;
        se_b_sel[2][3] = se_reg[95-:8] ;
        se_b_sel[3][0] = se_reg[103-:8];
        se_b_sel[3][1] = se_reg[111-:8];
        se_b_sel[3][2] = se_reg[119-:8];
        se_b_sel[3][3] = se_reg[127-:8];
    end
    else begin
        se_b_sel[3][3] = se_reg[7-:8] ;
        se_b_sel[3][2] = se_reg[15-:8] ;
        se_b_sel[3][1] = se_reg[23-:8] ;
        se_b_sel[3][0] = se_reg[31-:8] ;
        se_b_sel[2][3] = se_reg[39-:8] ;
        se_b_sel[2][2] = se_reg[47-:8] ;
        se_b_sel[2][1] = se_reg[55-:8] ;
        se_b_sel[2][0] = se_reg[63-:8] ;
        se_b_sel[1][3] = se_reg[71-:8] ;
        se_b_sel[1][2] = se_reg[79-:8] ;
        se_b_sel[1][1] = se_reg[87-:8] ;
        se_b_sel[1][0] = se_reg[95-:8] ;
        se_b_sel[0][3] = se_reg[103-:8];
        se_b_sel[0][2] = se_reg[111-:8];
        se_b_sel[0][1] = se_reg[119-:8];
        se_b_sel[0][0] = se_reg[127-:8];
    end
end
wire co1_inst[0:15][0:15];
wire co2_inst[0:15][0:15];
wire [7:0]minx[0:15][0:15];
wire [3:0]minmax_idx[0:15];
wire [7:0]daliation[0:3];
reg [7:0]minx_pipe[0:15][0:3];
genvar j;
// 1 SE
DW_addsub_dx #(8,2)U1 ( .a(line[25][7-:8]), .b(se_b_sel[0][0]), .ci1(1'b0), .ci2(1'b0), .addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[0][0]), .co1(co1_inst[0][0]), .co2(co2_inst[0][0])  );
DW_addsub_dx #(8,2)U2 ( .a(line[25][15-:8]), .b(se_b_sel[0][1]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[1][0]), .co1(co1_inst[1][0]), .co2(co2_inst[1][0])  );
DW_addsub_dx #(8,2)U3 ( .a(line[25][23-:8]), .b(se_b_sel[0][2]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[2][0]), .co1(co1_inst[2][0]), .co2(co2_inst[2][0])  );
DW_addsub_dx #(8,2)U4 ( .a(line[25][31-:8]), .b(se_b_sel[0][3]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[3][0]), .co1(co1_inst[3][0]), .co2(co2_inst[3][0])  );
DW_addsub_dx #(8,2)U5 ( .a(line[17][7-:8]), .b(se_b_sel[1][0]), .ci1(1'b0), .ci2(1'b0), .addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),  .sum(minx[4][0]), .co1(co1_inst[4][0]), .co2(co2_inst[4][0])  );
DW_addsub_dx #(8,2)U6 ( .a(line[17][15-:8]), .b(se_b_sel[1][1]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[5][0]), .co1(co1_inst[5][0]), .co2(co2_inst[5][0])  );
DW_addsub_dx #(8,2)U7 ( .a(line[17][23-:8]), .b(se_b_sel[1][2]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[6][0]), .co1(co1_inst[6][0]), .co2(co2_inst[6][0])  );
DW_addsub_dx #(8,2)U8 ( .a(line[17][31-:8]), .b(se_b_sel[1][3]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[7][0]), .co1(co1_inst[7][0]), .co2(co2_inst[7][0])  );
DW_addsub_dx #(8,2)U9 ( .a(line[9][7-:8]), .b(se_b_sel[2][0]), .ci1(1'b0), .ci2(1'b0),  .addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),  .sum(minx[8][0]), .co1(co1_inst[8][0]), .co2(co2_inst[8][0])  );
DW_addsub_dx #(8,2)U10 ( .a(line[9][15-:8]), .b(se_b_sel[2][1]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[9][0]), .co1(co1_inst[9][0]), .co2(co2_inst[9][0])  );
DW_addsub_dx #(8,2)U11 ( .a(line[9][23-:8]), .b(se_b_sel[2][2]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[10][0]), .co1(co1_inst[10][0]), .co2(co2_inst[10][0] ) );
DW_addsub_dx #(8,2)U12 ( .a(line[9][31-:8]), .b(se_b_sel[2][3]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[11][0]), .co1(co1_inst[11][0]), .co2(co2_inst[11][0] ) );
DW_addsub_dx #(8,2)U13 ( .a(line[1][7-:8]), .b(se_b_sel[3][0]), .ci1(1'b0), .ci2(1'b0), .addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[12][0]), .co1(co1_inst[12][0]), .co2(co2_inst[12][0] ) );
DW_addsub_dx #(8,2)U14 ( .a(line[1][15-:8]), .b(se_b_sel[3][1]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[13][0]), .co1(co1_inst[13][0]), .co2(co2_inst[13][0] ) );
DW_addsub_dx #(8,2)U15 ( .a(line[1][23-:8]), .b(se_b_sel[3][2]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[14][0]), .co1(co1_inst[14][0]), .co2(co2_inst[14][0] ) );
DW_addsub_dx #(8,2)U16 ( .a(line[1][31-:8]), .b(se_b_sel[3][3]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[15][0]), .co1(co1_inst[15][0]), .co2(co2_inst[15][0] ) );
        
       //DW_minmax #(8, 16)
       //M1111 (.a({minx_pipe[0][0],minx_pipe[1][0],minx_pipe[2][0],minx_pipe[3][0],minx_pipe[4][0],minx_pipe[5][0],minx_pipe[6][0],minx_pipe[7][0],minx_pipe[8][0],minx_pipe[9][0],minx_pipe[10][0],minx_pipe[11][0],minx_pipe[12][0],minx_pipe[13][0],minx_pipe[14][0],minx_pipe[15][0]}), .tc(1'b0), .min_max(op_reg==1),
       //.value(daliation[0]), .index(minmax_idx[0]));
       DW_minmax #(8, 16)
       M1111 (.a({minx[0][0],minx[1][0],minx[2][0],minx[3][0],minx[4][0],minx[5][0],minx[6][0],minx[7][0],minx[8][0],minx[9][0],minx[10][0],minx[11][0],minx[12][0],minx[13][0],minx[14][0],minx[15][0]}), .tc(1'b0), .min_max(op_reg[1:0]==2'b11),
       .value(daliation[0]), .index(minmax_idx[0]));

always @(*) begin
    if(cstate == INPUT && cnt_4 == 0)begin
        linebuffer[0] = 0;
        linebuffer[1] = 0;
        linebuffer[2] = 0;
        linebuffer[3] = 0;
        linebuffer[4] = 0;
        linebuffer[5] = 0;
        linebuffer[6] = 0;
        linebuffer[7] = 0;
        linebuffer[8] = 0;
        linebuffer[9] = 0;
        linebuffer[10] = 0;
        linebuffer[11] = 0;

    end
    else if(cstate==OPENOP && cnt_4 == 2)begin
        linebuffer[0] = 0;
        linebuffer[1] = 0;
        linebuffer[2] = 0;
        linebuffer[3] = 0;
        linebuffer[4] = 0;
        linebuffer[5] = 0;
        linebuffer[6] = 0;
        linebuffer[7] = 0;
        linebuffer[8] = 0;
        linebuffer[9] = 0;
        linebuffer[10] = 0;
        linebuffer[11] = 0;

    end
    else begin
        linebuffer[0] = line[24][7-:8];
        linebuffer[1] = line[16][7-:8];
        linebuffer[2] = line[8][7-:8];
        linebuffer[3] = line[0][7-:8];
        linebuffer[4] = line[24][15-:8];
        linebuffer[5] = line[16][15-:8];
        linebuffer[6] = line[8][15-:8];
        linebuffer[7] = line[0][15-:8];
        linebuffer[8] = line[24][23-:8];
        linebuffer[9] = line[16][23-:8];
        linebuffer[10] =line[8][23-:8];
        linebuffer[11] =line[0][23-:8];
    end
end
DW_addsub_dx #(8,2)se13_1 ( .a(line[25][15-:8]), .b(se_b_sel[0][0]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[0][1]), .co1(co1_inst[0][13]), .co2(co2_inst[0][13])  );
DW_addsub_dx #(8,2)se13_2 ( .a(line[25][23-:8]), .b(se_b_sel[0][1]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[1][1]), .co1(co1_inst[1][13]), .co2(co2_inst[1][13])  );
DW_addsub_dx #(8,2)se13_3 ( .a(line[25][31-:8]), .b(se_b_sel[0][2]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[2][1]), .co1(co1_inst[2][13]), .co2(co2_inst[2][13])  );
DW_addsub_dx #(8,2)se13_4 ( .a(linebuffer[0]), .b(se_b_sel[0][3]), .ci1(1'b0), .ci2(1'b0),  .addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),   .sum(minx[3][1]), .co1(co1_inst[3][13]), .co2(co2_inst[3][13])  );
DW_addsub_dx #(8,2)se13_5 ( .a(line[17][15-:8]), .b(se_b_sel[1][0]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[4][1]), .co1(co1_inst[4][13]), .co2(co2_inst[4][13])  );
DW_addsub_dx #(8,2)se13_6 ( .a(line[17][23-:8]), .b(se_b_sel[1][1]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[5][1]), .co1(co1_inst[5][13]), .co2(co2_inst[5][13])  );
DW_addsub_dx #(8,2)se13_7 ( .a(line[17][31-:8]), .b(se_b_sel[1][2]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[6][1]), .co1(co1_inst[6][13]), .co2(co2_inst[6][13])  );
DW_addsub_dx #(8,2)se13_8 ( .a(linebuffer[1]), .b(se_b_sel[1][3]), .ci1(1'b0), .ci2(1'b0),  .addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),   .sum(minx[7][1]), .co1(co1_inst[7][13]), .co2(co2_inst[7][13])  );
DW_addsub_dx #(8,2)se13_9 (  .a(line[9][15-:8]), .b(se_b_sel[2][0]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[8][1]), .co1(co1_inst[8][13]), .co2(co2_inst[8][13])  );
DW_addsub_dx #(8,2)se13_10 ( .a(line[9][23-:8]), .b(se_b_sel[2][1]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[9][1]), .co1(co1_inst[9][13]), .co2(co2_inst[9][13])  );
DW_addsub_dx #(8,2)se13_11 ( .a(line[9][31-:8]), .b(se_b_sel[2][2]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[10][1]), .co1(co1_inst[10][13]), .co2(co2_inst[10][13] ) );
DW_addsub_dx #(8,2)se13_12 ( .a(linebuffer[2]), .b(se_b_sel[2][3]), .ci1(1'b0), .ci2(1'b0), .addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[11][1]), .co1(co1_inst[11][13]), .co2(co2_inst[11][13] ) );
DW_addsub_dx #(8,2)se13_13 ( .a(line[1][15-:8]), .b(se_b_sel[3][0]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[12][1]), .co1(co1_inst[12][13]), .co2(co2_inst[12][13] ) );
DW_addsub_dx #(8,2)se13_14 ( .a(line[1][23-:8]), .b(se_b_sel[3][1]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[13][1]), .co1(co1_inst[13][13]), .co2(co2_inst[13][13] ) );
DW_addsub_dx #(8,2)se13_15 ( .a(line[1][31-:8]), .b(se_b_sel[3][2]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[14][1]), .co1(co1_inst[14][13]), .co2(co2_inst[14][13] ) );
DW_addsub_dx #(8,2)se13_16 ( .a(linebuffer[3]), .b(se_b_sel[3][3]), .ci1(1'b0), .ci2(1'b0), .addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[15][1]), .co1(co1_inst[15][13]), .co2(co2_inst[15][13] ) );
DW_minmax #(8, 16)
M1 (.a({minx[0][1],minx[1][1],minx[2][1],minx[3][1],minx[4][1],minx[5][1],minx[6][1],minx[7][1],minx[8][1],minx[9][1],minx[10][1],minx[11][1],minx[12][1],minx[13][1],minx[14][1],minx[15][1]}), .tc(1'b0), .min_max(op_reg[1:0]==2'b11),
.value(daliation[1]), .index(minmax_idx[1]));



//14SE

DW_addsub_dx #(8,2)se14_1 ( .a(line[25][23-:8]), .b(se_b_sel[0][0]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[0][2]), .co1(co1_inst[0][14]), .co2(co2_inst[0][14])  );
DW_addsub_dx #(8,2)se14_2 ( .a(line[25][31-:8]), .b(se_b_sel[0][1]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[1][2]), .co1(co1_inst[1][14]), .co2(co2_inst[1][14])  );
DW_addsub_dx #(8,2)se14_3 ( .a(linebuffer[0]), .b(se_b_sel[0][2]), .ci1(1'b0), .ci2(1'b0),  .addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),   .sum(minx[2][2]), .co1(co1_inst[2][14]), .co2(co2_inst[2][14])  );
DW_addsub_dx #(8,2)se14_4 ( .a(linebuffer[4]), .b(se_b_sel[0][3]), .ci1(1'b0), .ci2(1'b0),  .addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),   .sum(minx[3][2]), .co1(co1_inst[3][14]), .co2(co2_inst[3][14])  );
DW_addsub_dx #(8,2)se14_5 ( .a(line[17][23-:8]), .b(se_b_sel[1][0]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[4][2]), .co1(co1_inst[4][14]), .co2(co2_inst[4][14])  );
DW_addsub_dx #(8,2)se14_6 ( .a(line[17][31-:8]), .b(se_b_sel[1][1]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[5][2]), .co1(co1_inst[5][14]), .co2(co2_inst[5][14])  );
DW_addsub_dx #(8,2)se14_7 ( .a(linebuffer[1]), .b(se_b_sel[1][2]), .ci1(1'b0), .ci2(1'b0),  .addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),   .sum(minx[6][2]), .co1(co1_inst[6][14]), .co2(co2_inst[6][14])  );
DW_addsub_dx #(8,2)se14_8 ( .a(linebuffer[5]), .b(se_b_sel[1][3]), .ci1(1'b0), .ci2(1'b0),  .addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),   .sum(minx[7][2]), .co1(co1_inst[7][14]), .co2(co2_inst[7][14])  );
DW_addsub_dx #(8,2)se14_9 (  .a(line[9][23-:8]), .b(se_b_sel[2][0]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[8][2]), .co1(co1_inst[8][14]), .co2(co2_inst[8][14])  );
DW_addsub_dx #(8,2)se14_10 ( .a(line[9][31-:8]), .b(se_b_sel[2][1]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[9][2]), .co1(co1_inst[9][14]), .co2(co2_inst[9][14])  );
DW_addsub_dx #(8,2)se14_11 ( .a(linebuffer[2]), .b(se_b_sel[2][2]), .ci1(1'b0), .ci2(1'b0), .addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[10][2]), .co1(co1_inst[10][14]), .co2(co2_inst[10][14] ) );
DW_addsub_dx #(8,2)se14_12 ( .a(linebuffer[6]), .b(se_b_sel[2][3]), .ci1(1'b0), .ci2(1'b0), .addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[11][2]), .co1(co1_inst[11][14]), .co2(co2_inst[11][14] ) );
DW_addsub_dx #(8,2)se14_13 ( .a(line[1][23-:8]), .b(se_b_sel[3][0]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[12][2]), .co1(co1_inst[12][14]), .co2(co2_inst[12][14] ) );
DW_addsub_dx #(8,2)se14_14 ( .a(line[1][31-:8]), .b(se_b_sel[3][1]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[13][2]), .co1(co1_inst[13][14]), .co2(co2_inst[13][14] ) );
DW_addsub_dx #(8,2)se14_15 ( .a(linebuffer[3]), .b(se_b_sel[3][2]), .ci1(1'b0), .ci2(1'b0), .addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[14][2]), .co1(co1_inst[14][14]), .co2(co2_inst[14][14] ) );
DW_addsub_dx #(8,2)se14_16 ( .a(linebuffer[7]), .b(se_b_sel[3][3]), .ci1(1'b0), .ci2(1'b0), .addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[15][2]), .co1(co1_inst[15][14]), .co2(co2_inst[15][14] ) );
        
        DW_minmax #(8, 16)
        Mse14 (.a({minx[0][2],minx[1][2],minx[2][2],minx[3][2],minx[4][2],minx[5][2],minx[6][2],minx[7][2],minx[8][2],minx[9][2],minx[10][2],minx[11][2],minx[12][2],minx[13][2],minx[14][2],minx[15][2]}), .tc(1'b0), .min_max(op_reg[1:0]==2'b11),
       .value(daliation[2]), .index(minmax_idx[2]));


//15SE
DW_addsub_dx #(8,2)se15_1 ( .a(line[25][31-:8]), .b(se_b_sel[0][0]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[0][3]), .co1(co1_inst[0][15]), .co2(co2_inst[0][15])  );
DW_addsub_dx #(8,2)se15_2 ( .a(linebuffer[0]), .b(se_b_sel[0][1]), .ci1(1'b0), .ci2(1'b0),  .addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),   .sum(minx[1][3]), .co1(co1_inst[1][15]), .co2(co2_inst[1][15])  );
DW_addsub_dx #(8,2)se15_3 ( .a(linebuffer[4]), .b(se_b_sel[0][2]), .ci1(1'b0), .ci2(1'b0),  .addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),   .sum(minx[2][3]), .co1(co1_inst[2][15]), .co2(co2_inst[2][15])  );
DW_addsub_dx #(8,2)se15_4 ( .a(linebuffer[8]), .b(se_b_sel[0][3]), .ci1(1'b0), .ci2(1'b0),  .addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),   .sum(minx[3][3]), .co1(co1_inst[3][15]), .co2(co2_inst[3][15])  );
DW_addsub_dx #(8,2)se15_5 ( .a(line[17][31-:8]), .b(se_b_sel[1][0]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[4][3]), .co1(co1_inst[4][15]), .co2(co2_inst[4][15])  );
DW_addsub_dx #(8,2)se15_6 ( .a(linebuffer[1]), .b(se_b_sel[1][1]), .ci1(1'b0), .ci2(1'b0),  .addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),   .sum(minx[5][3]), .co1(co1_inst[5][15]), .co2(co2_inst[5][15])  );
DW_addsub_dx #(8,2)se15_7 ( .a(linebuffer[5]), .b(se_b_sel[1][2]), .ci1(1'b0), .ci2(1'b0),  .addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),   .sum(minx[6][3]), .co1(co1_inst[6][15]), .co2(co2_inst[6][15])  );
DW_addsub_dx #(8,2)se15_8 ( .a(linebuffer[9]), .b(se_b_sel[1][3]), .ci1(1'b0), .ci2(1'b0),  .addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),   .sum(minx[7][3]), .co1(co1_inst[7][15]), .co2(co2_inst[7][15])  );
DW_addsub_dx #(8,2)se15_9 ( .a(line[9][31-:8]), .b(se_b_sel[2][0]), .ci1(1'b0), .ci2(1'b0), .addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),  .sum(minx[8][3]), .co1(co1_inst[8][15]), .co2(co2_inst[8][15])  );
DW_addsub_dx #(8,2)se15_10 ( .a(linebuffer[2]), .b(se_b_sel[2][1]), .ci1(1'b0), .ci2(1'b0), .addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),  .sum(minx[9][3]), .co1(co1_inst[9][15]), .co2(co2_inst[9][15])  );
DW_addsub_dx #(8,2)se15_11 ( .a(linebuffer[6]), .b(se_b_sel[2][2]), .ci1(1'b0), .ci2(1'b0), .addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[10][3]), .co1(co1_inst[10][15]), .co2(co2_inst[10][15] ) );
DW_addsub_dx #(8,2)se15_12 ( .a(linebuffer[10]), .b(se_b_sel[2][3]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[11][3]), .co1(co1_inst[11][15]), .co2(co2_inst[11][15] ) );
DW_addsub_dx #(8,2)se15_13 ( .a(line[1][31-:8]), .b(se_b_sel[3][0]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[12][3]), .co1(co1_inst[12][15]), .co2(co2_inst[12][15] ) );
DW_addsub_dx #(8,2)se15_14 ( .a(linebuffer[3]), .b(se_b_sel[3][1]), .ci1(1'b0), .ci2(1'b0), .addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[13][3]), .co1(co1_inst[13][15]), .co2(co2_inst[13][15] ) );
DW_addsub_dx #(8,2)se15_15 ( .a(linebuffer[7]), .b(se_b_sel[3][2]), .ci1(1'b0), .ci2(1'b0), .addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[14][3]), .co1(co1_inst[14][15]), .co2(co2_inst[14][15] ) );
DW_addsub_dx #(8,2)se15_16 ( .a(linebuffer[11]), .b(se_b_sel[3][3]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg[1:0]==2'b10), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[15][3]), .co1(co1_inst[15][15]), .co2(co2_inst[15][15] ) );
        
        DW_minmax #(8, 16)
        Mse15 (.a({minx[0][3],minx[1][3],minx[2][3],minx[3][3],minx[4][3],minx[5][3],minx[6][3],minx[7][3],minx[8][3],minx[9][3],minx[10][3],minx[11][3],minx[12][3],minx[13][3],minx[14][3],minx[15][3]}), .tc(1'b0), .min_max(op_reg[1:0]==2'b11),
       .value(daliation[3]), .index(minmax_idx[3]));
always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
        se_ans <= 0;
    end else begin
        se_ans <= {
            daliation[3],
            daliation[2],
            daliation[1],
            daliation[0]};
    end
end
//======================================
//          HIS
//======================================
//cdf [0:255]

wire pixel[0:3][0:255];
wire [4:0]pixel_acc[0:255];

generate
for(p=0;p<4;p=p+1)begin
    for (k = 0; k < 256; k=k+1) begin
        assign pixel[p][k] = (k >= line[0][7+8*p-:8])? 1:0;
    end
end
endgenerate
generate
    for(j=0;j<256;j=j+1)begin
       assign pixel_acc[j] = pixel[0][j] + pixel[1][j] + pixel[2][j] + pixel[3][j]  ;
    end
    
endgenerate

generate
    for(j=0;j<256;j=j+1)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset
                cdf_table[j] <= 0;
        end
        
        else begin
            if(cstate == IDLE)begin
                    cdf_table[j] <= 0; 
            end
            else  if(nstate == INPUT && cnt < 256)begin
                    cdf_table[j] <= cdf_table[j]  + pixel_acc[j];
            end
            else if (cstate == CAL_CDF)begin
                if(j == cnt - 3)
                    cdf_table[j] <= quo;
            end
        end
    end
endgenerate
wire[7:0]min_cdf;
reg[7:0]min;
reg in;
always @(posedge clk or negedge rst_n) begin : proc_in
    if(~rst_n) begin
        in <= 0;
    end else begin
        in <= in_valid;
    end
end
always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset
               min <= 255;
        end
        
        else begin
            if(cstate == IDLE)begin
                    min <= 255; 
            end
            else  if(in)begin
                    min <= min_cdf;
            end
            
        end
end
 DW_minmax #(8, 5)
        Mincdf (.a({min,line[0]}), .tc(1'b0), .min_max(1'b0),
        .value(min_cdf), .index());

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // reset
        cdf_min <= 0 ;
    end
    else begin
        if(cstate == CAL)
            cdf_min <= cdf_table[min];

    end
end


assign x = cdf_table[cnt] - cdf_min ;
assign up = (x<<8) - x;    // 21 bit
assign down = 11'd1024-cdf_min;  //13bit


DW_div_pipe #(19, 11, 0, 1, 4, 1, 1) Div0 ( 
    .clk(clk), 
    .rst_n(rst_n), 
    .en(1'b1), 
    .a(up),  
    .b(down), 
    .quotient(quo),  
    .remainder(rem),  
    .divide_by_0(pin) );




//======================================
//          Output
//======================================

always @(posedge clk or negedge rst_n) begin : proc_cstate_d
    if(~rst_n) begin
        cstate_d <= 0;
    end else begin
        cstate_d <= cstate;
    end
end
always@(posedge clk or negedge rst_n) begin

    if(!rst_n)begin
        out_valid <= 0; /* remember to reset */
    end
    else begin
        if(cstate_d == OUTPUT)
            out_valid <= 1;
        else if(cstate_d == READ_SRAM)
            out_valid <= 1;
        else if(cstate==OPENOP && cnt>26 && cnt <283)
            out_valid <= 1;

        else
            out_valid <= 0;

    end
    
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        out_data <= 0; /* remember to reset */
    end
    else begin
        if (cstate_d == OUTPUT) begin
            out_data<=I_Q1;
        end
        else if(cstate_d == READ_SRAM)begin
            out_data[7-:8]  <= cdf_table[I_Q1[7-:8]];
            out_data[15-:8] <= cdf_table[I_Q1[15-:8]];
            out_data[23-:8] <= cdf_table[I_Q1[23-:8]];
            out_data[31-:8] <= cdf_table[I_Q1[31-:8]];
        end
        else if(cstate==OPENOP && cnt>26 && cnt <283)
            out_data <= {
            daliation[3],
            daliation[2],
            daliation[1],
            daliation[0]};
        else
            out_data<=0;
    end
    
end
endmodule 