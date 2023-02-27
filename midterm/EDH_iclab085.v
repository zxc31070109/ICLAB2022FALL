//synopsys translate_off
`include "DW_div.v"
`include "DW_div_pipe.v"
`include "DW_addsub_dx.v"
`include "DW_minmax.v"
//synopsys translate_on


module EDH(
    // CHIP IO
    clk          ,
    rst_n        ,
    in_valid     ,
    op           ,
    pic_no       ,
    se_no        ,
    busy         ,

    awid_m_inf   ,
    awaddr_m_inf ,
    awsize_m_inf ,
    awburst_m_inf,
    awlen_m_inf  ,
    awvalid_m_inf,
    awready_m_inf,

    wdata_m_inf  ,
    wlast_m_inf  ,
    wvalid_m_inf ,
    wready_m_inf ,

    bid_m_inf    ,
    bresp_m_inf  ,
    bvalid_m_inf ,
    bready_m_inf ,

    arid_m_inf   ,
    araddr_m_inf ,
    arlen_m_inf  ,
    arsize_m_inf ,
    arburst_m_inf,
    arvalid_m_inf,

    arready_m_inf,
    rid_m_inf    ,
    rdata_m_inf  ,
    rresp_m_inf  ,
    rlast_m_inf  ,
    rvalid_m_inf ,
    rready_m_inf 
);
//======================================
//          I/O PORTS to pattern
//======================================
input    clk          ;
input    rst_n        ;
input    in_valid     ;
input[1:0]    op           ;
input[3:0]    pic_no       ;
input[5:0]    se_no        ;
output reg    busy         ;

//======================================
//          AXI
//======================================
// axi write addr channel 
// src master
parameter ID_WIDTH = 4 , ADDR_WIDTH = 32, DATA_WIDTH = 128;

output  wire [ID_WIDTH-1:0]      awid_m_inf;   //AWID
output  wire [ADDR_WIDTH-1:0]  awaddr_m_inf;   //AWADDR 32bits
output  wire [2:0]             awsize_m_inf;   //AW_SIZE 3'b100 16 BYTES
output  wire [1:0]            awburst_m_inf;   //INCR 2'b01
output  wire [7:0]              awlen_m_inf;   //LEN = 255
output  wire                  awvalid_m_inf;   //VALID MASTER
// src slave
input wire                  awready_m_inf;     //SLAVE READY
// -------------------------

// axi write data channel 
// src master
output  wire [DATA_WIDTH-1:0]   wdata_m_inf;  // 128-bit
output  wire                    wlast_m_inf;  // last signal
output  wire                   wvalid_m_inf;  // write = 1
// src slave
input wire                   wready_m_inf;    // dram ready

// axi write resp channel 
// src slave
input wire  [ID_WIDTH-1:0]      bid_m_inf;    // BID = AWID
input wire  [1:0]             bresp_m_inf;    // 2'b00 = OK
input wire                   bvalid_m_inf;    // 
// src master 
output  wire                   bready_m_inf;  // write = 1
// ------------------------

// axi read addr channel 
// src master
output  wire [ID_WIDTH-1:0]      arid_m_inf;  //ARID read
output  wire [ADDR_WIDTH-1:0]  araddr_m_inf;  //ADDRESS
output  wire [7:0]              arlen_m_inf;  //LEN
output  wire [2:0]             arsize_m_inf;  //SIZE = 3'b100
output  wire [1:0]            arburst_m_inf;  //BURST incr = 2'b01
output  wire                  arvalid_m_inf;  //VALID
// src slave
input wire                  arready_m_inf;    // wait (READY && VALID)
// ------------------------
// axi read data channel 
// slave
input wire [ID_WIDTH-1:0]       rid_m_inf;    //RID
input wire [DATA_WIDTH-1:0]   rdata_m_inf;    //DATA
input wire [1:0]              rresp_m_inf;    //RES
input wire                    rlast_m_inf;    //LAST
input wire                   rvalid_m_inf;    //VALID
// master
output  wire                   rready_m_inf;  //pull ready to read data

// -----------------------------

//======================================
//          fsm
//======================================
//***********************************              
// parameter      
//***********************************      
parameter IDLE                     =  5'd0;
parameter INPUT                    =  5'd1;
parameter SE_PUT_SRAM_VALID        =  5'd2;
parameter SE_PUT_SRAM_DATA         =  5'd3;
parameter READ_PIC_VALID           =  5'd4;
parameter READ_PIC_DATA            =  5'd5; 
parameter CAL                      =  5'd6; 
parameter CAL_HIS1                 =  5'd7; 
parameter CAL_HIS2                 =  5'd8; 
parameter CAL_CDF                  =  5'd9; 
parameter CAL_DIV                  =  5'd10;
parameter READ_SRAM                =  5'd11;
parameter WRITE_VALID              =  5'd12;
parameter WRITE_DATA               =  5'd13;
//****************************************************************************************************************************************************************
//Reg Daclaration          
//****************************************************************************************************************************************************************
reg [4:0]cstate;
reg [4:0]nstate;                            
reg[1:0]    op_reg           ;
reg[3:0]    pic_no_reg       ;
reg[5:0]    se_no_reg        ;     

reg [7:0]rvalid_cnt;
reg [8:0]rvalid_cnt_d1;
wire [1:0]four_idx;
reg [8:0]cnt;
reg se_flag;

//SE SRAM
wire [127:0]DA;
//reg [5:0]address;
wire[5:0]SE_A;
wire[127:0]SE_Q,PIC_Q,PIC_Q1;
wire SE_WEN;

wire [7:0]PIC_A,PIC_B;
reg [7:0]PIC_A_r;
reg PIC_WEN_r;
wire PIC_WEN;


reg [127:0]SRAM_DATA,PIC_DATA;
reg[12:0]cdf_min;
wire WENB;
//AXI Signal
reg [127:0]dram_data,wdata;
reg arvalid;
reg [31:0]araddr;
reg arready;
reg rlast;
reg rvalid;
reg rready;
reg awvalid;
reg wvalid;
reg wlast,bready;
reg valid;
//se
wire [1:0]cnt_4;
assign cnt_4 = rvalid_cnt_d1[1:0];
reg [7:0]linebuffer[0:11];
reg [127:0]se_ans;
reg [7:0]se_b_sel[0:3][0:3];
reg [127:0]line[0:13];
reg [127:0]SE_Q_r;
//cdf
wire [20:0] x;
wire [12:0]down;
wire [20:0] up;
reg[12:0] min_value;
wire[12:0]value;
wire[20:0]quo;
wire[12:0]rem;
wire pin;
reg [8:0]cnt_d;
reg[5:0]flag;
reg [127:0]update_cdf;

reg [12:0]cdf_table[0:255];
//cdf test
//reg [12:0]cdf_table[0:255];

genvar k,p;
//************************************
//          FSM_sample code
//************************************

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
        nstate = (in_valid)?INPUT:SE_PUT_SRAM_VALID;      
        
    SE_PUT_SRAM_VALID:
        nstate = (arready_m_inf)?SE_PUT_SRAM_DATA:SE_PUT_SRAM_VALID;
    
    SE_PUT_SRAM_DATA:
        nstate = (rlast_m_inf)? READ_PIC_VALID : SE_PUT_SRAM_DATA;
    READ_PIC_VALID:
        nstate = (arready_m_inf)?READ_PIC_DATA:READ_PIC_VALID;
    READ_PIC_DATA:
        nstate = (PIC_A_r == 255 && op_reg == 2 && rlast)?CAL:
                 (op_reg != 2 && rvalid_cnt_d1 ==270 &&rlast)? WRITE_VALID:READ_PIC_DATA;
    CAL:
        nstate =CAL_HIS1;
    CAL_HIS1:
        nstate =(cnt==2)?CAL_CDF:CAL_HIS1;
    CAL_CDF:
        nstate = (cnt == 258) ? CAL_DIV:CAL_CDF;
    CAL_DIV:
            nstate = READ_SRAM;
    READ_SRAM:
        nstate = (cnt_d == 258)?WRITE_VALID:READ_SRAM;
    WRITE_VALID:
        nstate = (awready_m_inf)?WRITE_DATA:WRITE_VALID;
    WRITE_DATA:
        nstate = (wlast)?IDLE:WRITE_DATA;
    default: nstate = IDLE;         
    endcase

end

//======================================
//          input
//======================================
always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
            op_reg<= 0;
            pic_no_reg<=0;
            se_no_reg<=0;
    end else begin
           if(in_valid) begin
               op_reg<= op;
               pic_no_reg<=pic_no;
               se_no_reg<=se_no;
           end
    end
end

always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
            dram_data<= 0;
    end else begin
            
            dram_data<= rvalid_m_inf?rdata_m_inf:0;
    end
end
reg [127:0]se_reg;
always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
            se_reg<= 0;
    end else begin
            
            se_reg<= (rvalid_m_inf && cstate == SE_PUT_SRAM_DATA)?rdata_m_inf:se_reg;
    end
end
//======================================
//          SE
//======================================
genvar d;
generate
    for(d=0;d<14;d=d+1)begin
        always @(posedge clk or negedge rst_n) begin
            if(~rst_n) begin
                line[d] <= 0;
            end else begin
                if(d==0)
                    line[d] <= rvalid_m_inf?rdata_m_inf:0;
                else
                    line[d] <= line[d-1];
            end
        end
    end
endgenerate

always @(*) begin
    if(op_reg == 0)begin
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
wire [127:0]minmax_a[0:15];
wire [3:0]minmax_idx[0:15];
wire [7:0]daliation[0:15];
reg [7:0]minx_pipe[0:15][0:15];
genvar j;
generate
    for(j=0;j<13;j=j+1)begin
        
        DW_addsub_dx #(8,2)
        U1 ( .a(line[13][7+8*j-:8]), .b(se_b_sel[0][0]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[0][j]), .co1(co1_inst[0][j]), .co2(co2_inst[0][j])  );
        DW_addsub_dx #(8,2)
        U2 ( .a(line[13][15+8*j-:8]), .b(se_b_sel[0][1]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[1][j]), .co1(co1_inst[1][j]), .co2(co2_inst[1][j])  );
        DW_addsub_dx #(8,2)
        U3 ( .a(line[13][23+8*j-:8]), .b(se_b_sel[0][2]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[2][j]), .co1(co1_inst[2][j]), .co2(co2_inst[2][j])  );
        DW_addsub_dx #(8,2)
        U4 ( .a(line[13][31+8*j-:8]), .b(se_b_sel[0][3]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[3][j]), .co1(co1_inst[3][j]), .co2(co2_inst[3][j])  );
        DW_addsub_dx #(8,2)
        U5 ( .a(line[9][7+8*j-:8]), .b(se_b_sel[1][0]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),  .sum(minx[4][j]), .co1(co1_inst[4][j]), .co2(co2_inst[4][j])  );
        DW_addsub_dx #(8,2)
        U6 ( .a(line[9][15+8*j-:8]), .b(se_b_sel[1][1]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[5][j]), .co1(co1_inst[5][j]), .co2(co2_inst[5][j])  );
        DW_addsub_dx #(8,2)
        U7 ( .a(line[9][23+8*j-:8]), .b(se_b_sel[1][2]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[6][j]), .co1(co1_inst[6][j]), .co2(co2_inst[6][j])  );
        DW_addsub_dx #(8,2)
        U8 ( .a(line[9][31+8*j-:8]), .b(se_b_sel[1][3]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[7][j]), .co1(co1_inst[7][j]), .co2(co2_inst[7][j])  );
        DW_addsub_dx #(8,2)
        U9 ( .a(line[5][7+8*j-:8]), .b(se_b_sel[2][0]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),  .sum(minx[8][j]), .co1(co1_inst[8][j]), .co2(co2_inst[8][j])  );
        DW_addsub_dx #(8,2)
        U10 ( .a(line[5][15+8*j-:8]), .b(se_b_sel[2][1]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[9][j]), .co1(co1_inst[9][j]), .co2(co2_inst[9][j])  );
        DW_addsub_dx #(8,2)
        U11 ( .a(line[5][23+8*j-:8]), .b(se_b_sel[2][2]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[10][j]), .co1(co1_inst[10][j]), .co2(co2_inst[10][j] ) );
        DW_addsub_dx #(8,2)
        U12 ( .a(line[5][31+8*j-:8]), .b(se_b_sel[2][3]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[11][j]), .co1(co1_inst[11][j]), .co2(co2_inst[11][j] ) );
        DW_addsub_dx #(8,2)
        U13 ( .a(line[1][7+8*j-:8]), .b(se_b_sel[3][0]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[12][j]), .co1(co1_inst[12][j]), .co2(co2_inst[12][j] ) );
        DW_addsub_dx #(8,2)
        U14 ( .a(line[1][15+8*j-:8]), .b(se_b_sel[3][1]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[13][j]), .co1(co1_inst[13][j]), .co2(co2_inst[13][j] ) );
        DW_addsub_dx #(8,2)
        U15 ( .a(line[1][23+8*j-:8]), .b(se_b_sel[3][2]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[14][j]), .co1(co1_inst[14][j]), .co2(co2_inst[14][j] ) );
        DW_addsub_dx #(8,2)
        U16 ( .a(line[1][31+8*j-:8]), .b(se_b_sel[3][3]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[15][j]), .co1(co1_inst[15][j]), .co2(co2_inst[15][j] ) );
        
        DW_minmax #(8, 16)
        M1 (.a({minx_pipe[0][j],minx_pipe[1][j],minx_pipe[2][j],minx_pipe[3][j],minx_pipe[4][j],minx_pipe[5][j],minx_pipe[6][j],minx_pipe[7][j],minx_pipe[8][j],minx_pipe[9][j],minx_pipe[10][j],minx_pipe[11][j],minx_pipe[12][j],minx_pipe[13][j],minx_pipe[14][j],minx_pipe[15][j]}), .tc(1'b0), .min_max(op_reg==1),
        .value(daliation[j]), .index(minmax_idx[j]));
    end
endgenerate
generate
for(k=0;k<16;k=k+1)begin
     for(j=0;j<16;j=j+1)begin
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                // reset
                minx_pipe[k][j] <= 0 ;
        
            end
            else begin
                minx_pipe[k][j] <= minx[k][j] ;
            end
        end

     end
    end
endgenerate
//13SE
always @(*) begin
    if(cnt_4 == 0)begin
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
        linebuffer[0] = line[12][7-:8];
        linebuffer[1] = line[8][7-:8];
        linebuffer[2] = line[4][7-:8];
        linebuffer[3] = line[0][7-:8];
        linebuffer[4] = line[12][15-:8];
        linebuffer[5] = line[8][15-:8];
        linebuffer[6] = line[4][15-:8];
        linebuffer[7] = line[0][15-:8];
        linebuffer[8] = line[12][23-:8];
        linebuffer[9] = line[8][23-:8];
        linebuffer[10] =line[4][23-:8];
        linebuffer[11] =line[0][23-:8];
    end
end
DW_addsub_dx #(8,2)se13_1 ( .a(line[13][111-:8]), .b(se_b_sel[0][0]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[0][13]), .co1(co1_inst[0][13]), .co2(co2_inst[0][13])  );
DW_addsub_dx #(8,2)se13_2 ( .a(line[13][119-:8]), .b(se_b_sel[0][1]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[1][13]), .co1(co1_inst[1][13]), .co2(co2_inst[1][13])  );
DW_addsub_dx #(8,2)se13_3 ( .a(line[13][127-:8]), .b(se_b_sel[0][2]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[2][13]), .co1(co1_inst[2][13]), .co2(co2_inst[2][13])  );
DW_addsub_dx #(8,2)se13_4 ( .a(linebuffer[0]), .b(se_b_sel[0][3]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[3][13]), .co1(co1_inst[3][13]), .co2(co2_inst[3][13])  );
DW_addsub_dx #(8,2)se13_5 ( .a(line[9][111-:8]), .b(se_b_sel[1][0]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),  .sum(minx[4][13]), .co1(co1_inst[4][13]), .co2(co2_inst[4][13])  );
DW_addsub_dx #(8,2)se13_6 ( .a(line[9][119-:8]), .b(se_b_sel[1][1]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[5][13]), .co1(co1_inst[5][13]), .co2(co2_inst[5][13])  );
DW_addsub_dx #(8,2)se13_7 ( .a(line[9][127-:8]), .b(se_b_sel[1][2]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[6][13]), .co1(co1_inst[6][13]), .co2(co2_inst[6][13])  );
DW_addsub_dx #(8,2)se13_8 ( .a(linebuffer[1]), .b(se_b_sel[1][3]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[7][13]), .co1(co1_inst[7][13]), .co2(co2_inst[7][13])  );
DW_addsub_dx #(8,2)se13_9 ( .a(line[5][111-:8]), .b(se_b_sel[2][0]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),  .sum(minx[8][13]), .co1(co1_inst[8][13]), .co2(co2_inst[8][13])  );
DW_addsub_dx #(8,2)se13_10 ( .a(line[5][119-:8]), .b(se_b_sel[2][1]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[9][13]), .co1(co1_inst[9][13]), .co2(co2_inst[9][13])  );
DW_addsub_dx #(8,2)se13_11 ( .a(line[5][127-:8]), .b(se_b_sel[2][2]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[10][13]), .co1(co1_inst[10][13]), .co2(co2_inst[10][13] ) );
DW_addsub_dx #(8,2)se13_12 ( .a(linebuffer[2]), .b(se_b_sel[2][3]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[11][13]), .co1(co1_inst[11][13]), .co2(co2_inst[11][13] ) );
DW_addsub_dx #(8,2)se13_13 ( .a(line[1][111-:8]), .b(se_b_sel[3][0]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[12][13]), .co1(co1_inst[12][13]), .co2(co2_inst[12][13] ) );
DW_addsub_dx #(8,2)se13_14 ( .a(line[1][119-:8]), .b(se_b_sel[3][1]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[13][13]), .co1(co1_inst[13][13]), .co2(co2_inst[13][13] ) );
DW_addsub_dx #(8,2)se13_15 ( .a(line[1][127-:8]), .b(se_b_sel[3][2]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[14][13]), .co1(co1_inst[14][13]), .co2(co2_inst[14][13] ) );
DW_addsub_dx #(8,2)se13_16 ( .a(linebuffer[3]), .b(se_b_sel[3][3]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[15][13]), .co1(co1_inst[15][13]), .co2(co2_inst[15][13] ) );
DW_minmax #(8, 16)
M1 (.a({minx_pipe[0][13],minx_pipe[1][13],minx_pipe[2][13],minx_pipe[3][13],minx_pipe[4][13],minx_pipe[5][13],minx_pipe[6][13],minx_pipe[7][13],minx_pipe[8][13],minx_pipe[9][13],minx_pipe[10][13],minx_pipe[11][13],minx_pipe[12][13],minx_pipe[13][13],minx_pipe[14][13],minx_pipe[15][13]}), .tc(1'b0), .min_max(op_reg==1),
.value(daliation[13]), .index(minmax_idx[13]));



//14SE

DW_addsub_dx #(8,2)
se14_1 ( .a(line[13][119-:8]), .b(se_b_sel[0][0]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[0][14]), .co1(co1_inst[0][14]), .co2(co2_inst[0][14])  );
DW_addsub_dx #(8,2)
se14_2 ( .a(line[13][127-:8]), .b(se_b_sel[0][1]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[1][14]), .co1(co1_inst[1][14]), .co2(co2_inst[1][14])  );
DW_addsub_dx #(8,2)
se14_3 ( .a(linebuffer[0]), .b(se_b_sel[0][2]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[2][14]), .co1(co1_inst[2][14]), .co2(co2_inst[2][14])  );
DW_addsub_dx #(8,2)
se14_4 ( .a(linebuffer[4]), .b(se_b_sel[0][3]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[3][14]), .co1(co1_inst[3][14]), .co2(co2_inst[3][14])  );
DW_addsub_dx #(8,2)
se14_5 ( .a(line[9][119-:8]), .b(se_b_sel[1][0]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),  .sum(minx[4][14]), .co1(co1_inst[4][14]), .co2(co2_inst[4][14])  );
DW_addsub_dx #(8,2)
se14_6 ( .a(line[9][127-:8]), .b(se_b_sel[1][1]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[5][14]), .co1(co1_inst[5][14]), .co2(co2_inst[5][14])  );
DW_addsub_dx #(8,2)
se14_7 ( .a(linebuffer[1]), .b(se_b_sel[1][2]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[6][14]), .co1(co1_inst[6][14]), .co2(co2_inst[6][14])  );
DW_addsub_dx #(8,2)
se14_8 ( .a(linebuffer[5]), .b(se_b_sel[1][3]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[7][14]), .co1(co1_inst[7][14]), .co2(co2_inst[7][14])  );
DW_addsub_dx #(8,2)
se14_9 ( .a(line[5][119-:8]), .b(se_b_sel[2][0]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),  .sum(minx[8][14]), .co1(co1_inst[8][14]), .co2(co2_inst[8][14])  );
DW_addsub_dx #(8,2)
se14_10 ( .a(line[5][127-:8]), .b(se_b_sel[2][1]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[9][14]), .co1(co1_inst[9][14]), .co2(co2_inst[9][14])  );
DW_addsub_dx #(8,2)
se14_11 ( .a(linebuffer[2]), .b(se_b_sel[2][2]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[10][14]), .co1(co1_inst[10][14]), .co2(co2_inst[10][14] ) );
DW_addsub_dx #(8,2)
se14_12 ( .a(linebuffer[6]), .b(se_b_sel[2][3]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[11][14]), .co1(co1_inst[11][14]), .co2(co2_inst[11][14] ) );
DW_addsub_dx #(8,2)
se14_13 ( .a(line[1][119-:8]), .b(se_b_sel[3][0]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[12][14]), .co1(co1_inst[12][14]), .co2(co2_inst[12][14] ) );
DW_addsub_dx #(8,2)
se14_14 ( .a(line[1][127-:8]), .b(se_b_sel[3][1]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[13][14]), .co1(co1_inst[13][14]), .co2(co2_inst[13][14] ) );
DW_addsub_dx #(8,2)
se14_15 ( .a(linebuffer[3]), .b(se_b_sel[3][2]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[14][14]), .co1(co1_inst[14][14]), .co2(co2_inst[14][14] ) );
DW_addsub_dx #(8,2)
se14_16 ( .a(linebuffer[7]), .b(se_b_sel[3][3]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[15][14]), .co1(co1_inst[15][14]), .co2(co2_inst[15][14] ) );
        
        DW_minmax #(8, 16)
        Mse14 (.a({minx_pipe[0][14],minx_pipe[1][14],minx_pipe[2][14],minx_pipe[3][14],minx_pipe[4][14],minx_pipe[5][14],minx_pipe[6][14],minx_pipe[7][14],minx_pipe[8][14],minx_pipe[9][14],minx_pipe[10][14],minx_pipe[11][14],minx_pipe[12][14],minx_pipe[13][14],minx_pipe[14][14],minx_pipe[15][14]}), .tc(1'b0), .min_max(op_reg==1),
        .value(daliation[14]), .index(minmax_idx[14]));


//15SE
DW_addsub_dx #(8,2)
se15_1 ( .a(line[13][127-:8]), .b(se_b_sel[0][0]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[0][15]), .co1(co1_inst[0][15]), .co2(co2_inst[0][15])  );
DW_addsub_dx #(8,2)
se15_2 ( .a(linebuffer[0]), .b(se_b_sel[0][1]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[1][15]), .co1(co1_inst[1][15]), .co2(co2_inst[1][15])  );
DW_addsub_dx #(8,2)
se15_3 ( .a(linebuffer[4]), .b(se_b_sel[0][2]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[2][15]), .co1(co1_inst[2][15]), .co2(co2_inst[2][15])  );
DW_addsub_dx #(8,2)
se15_4 ( .a(linebuffer[8]), .b(se_b_sel[0][3]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[3][15]), .co1(co1_inst[3][15]), .co2(co2_inst[3][15])  );
DW_addsub_dx #(8,2)
se15_5 ( .a(line[9][127-:8]), .b(se_b_sel[1][0]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),  .sum(minx[4][15]), .co1(co1_inst[4][15]), .co2(co2_inst[4][15])  );
DW_addsub_dx #(8,2)
se15_6 ( .a(linebuffer[1]), .b(se_b_sel[1][1]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[5][15]), .co1(co1_inst[5][15]), .co2(co2_inst[5][15])  );
DW_addsub_dx #(8,2)
se15_7 ( .a(linebuffer[5]), .b(se_b_sel[1][2]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[6][15]), .co1(co1_inst[6][15]), .co2(co2_inst[6][15])  );
DW_addsub_dx #(8,2)
se15_8 ( .a(linebuffer[9]), .b(se_b_sel[1][3]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[7][15]), .co1(co1_inst[7][15]), .co2(co2_inst[7][15])  );
DW_addsub_dx #(8,2)
se15_9 ( .a(line[5][127-:8]), .b(se_b_sel[2][0]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),  .sum(minx[8][15]), .co1(co1_inst[8][15]), .co2(co2_inst[8][15])  );
DW_addsub_dx #(8,2)
se15_10 ( .a(linebuffer[2]), .b(se_b_sel[2][1]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[9][15]), .co1(co1_inst[9][15]), .co2(co2_inst[9][15])  );
DW_addsub_dx #(8,2)
se15_11 ( .a(linebuffer[6]), .b(se_b_sel[2][2]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[10][15]), .co1(co1_inst[10][15]), .co2(co2_inst[10][15] ) );
DW_addsub_dx #(8,2)
se15_12 ( .a(linebuffer[10]), .b(se_b_sel[2][3]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[11][15]), .co1(co1_inst[11][15]), .co2(co2_inst[11][15] ) );
DW_addsub_dx #(8,2)
se15_13 ( .a(line[1][127-:8]), .b(se_b_sel[3][0]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0), .sum(minx[12][15]), .co1(co1_inst[12][15]), .co2(co2_inst[12][15] ) );
DW_addsub_dx #(8,2)
se15_14 ( .a(linebuffer[3]), .b(se_b_sel[3][1]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[13][15]), .co1(co1_inst[13][15]), .co2(co2_inst[13][15] ) );
DW_addsub_dx #(8,2)
se15_15 ( .a(linebuffer[7]), .b(se_b_sel[3][2]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[14][15]), .co1(co1_inst[14][15]), .co2(co2_inst[14][15] ) );
DW_addsub_dx #(8,2)
se15_16 ( .a(linebuffer[11]), .b(se_b_sel[3][3]), .ci1(1'b0), .ci2(1'b0),.addsub(op_reg==0), .tc(1'b0), .sat(1'b1),.avg(1'b0), .dplx(1'b0),.sum(minx[15][15]), .co1(co1_inst[15][15]), .co2(co2_inst[15][15] ) );
        
        DW_minmax #(8, 16)
        Mse15 (.a({minx_pipe[0][15],minx_pipe[1][15],minx_pipe[2][15],minx_pipe[3][15],minx_pipe[4][15],minx_pipe[5][15],minx_pipe[6][15],minx_pipe[7][15],minx_pipe[8][15],minx_pipe[9][15],minx_pipe[10][15],minx_pipe[11][15],minx_pipe[12][15],minx_pipe[13][15],minx_pipe[14][15],minx_pipe[15][15]}), .tc(1'b0), .min_max(op_reg==1),
        .value(daliation[15]), .index(minmax_idx[15]));
always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
        se_ans <= 0;
    end else begin
        se_ans <= {daliation[15],
daliation[14],
daliation[13],
daliation[12],
daliation[11],
daliation[10],
daliation[9],
daliation[8],
daliation[7],
daliation[6],
daliation[5],
daliation[4],
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

wire pixel[0:15][0:255];
wire [4:0]pixel_acc[0:255];

generate
for(p=0;p<16;p=p+1)begin
    for (k = 0; k < 256; k=k+1) begin
        assign pixel[p][k] = (k >= dram_data[7+8*p-:8])? 1:0;
    end
end
endgenerate
generate
    for(j=0;j<256;j=j+1)begin
       assign pixel_acc[j] = pixel[0][j] + pixel[1][j] + pixel[2][j] + pixel[3][j] + pixel[4][j] + pixel[5][j] + pixel[6][j] + pixel[7][j] + pixel[8][j] + pixel[9][j] + pixel[10][j] + pixel[11][j] + pixel[12][j] + pixel[13][j] + pixel[14][j] + pixel[15][j] ;
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
            if(cstate == READ_PIC_VALID)begin
                    cdf_table[j] <= 0; 
            end
            else  if(rvalid)begin
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
always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset
               min <= 255;
        end
        
        else begin
            if(cstate == READ_PIC_VALID)begin
                    min <= 255; 
            end
            else  if(rvalid)begin
                    min <= min_cdf;
            end
            
        end
end
 DW_minmax #(8, 17)
        Mincdf (.a({min,dram_data}), .tc(1'b0), .min_max(1'b0),
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

always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
        cnt <= 1;
    end else begin
        if(cstate == READ_PIC_DATA && op_reg != 2)begin
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
        else if(cstate == READ_SRAM)  begin
            cnt <= cnt +1;
        end 
        else if(awvalid_m_inf)begin
            cnt<=0;
        end
        else if(cstate == WRITE_DATA)
            if(wvalid_m_inf && wready_m_inf)
                cnt <= cnt +1;
            else 
                cnt <= cnt;
        else
            cnt <= 1;
    end
end
always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
        cnt_d <= 0;
    end else begin

        cnt_d <= cnt;
    end
end

assign x = cdf_table[cnt] - cdf_min ;
assign up = (x<<8) - x;    // 21 bit
assign down = 13'd4096-cdf_min;  //13bit
DW_div_pipe #(21, 13, 0, 1, 4, 1, 1) Div0 ( 
    .clk(clk), 
    .rst_n(rst_n), 
    .en(1'b1), 
    .a(up),  
    .b(down), 
    .quotient(quo),  
    .remainder(rem),  
    .divide_by_0(pin) );
//update cdf
always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
        update_cdf<= 0;
    end else begin
        if(cstate ==READ_SRAM) begin
            update_cdf[7-:8] <= cdf_table[SRAM_DATA[7-:8]];
            update_cdf[15-:8] <= cdf_table[SRAM_DATA[15-:8]];
            update_cdf[23-:8] <= cdf_table[SRAM_DATA[23-:8]];
            update_cdf[31-:8] <= cdf_table[SRAM_DATA[31-:8]];
            update_cdf[39-:8] <= cdf_table[SRAM_DATA[39-:8]];
            update_cdf[47-:8] <= cdf_table[SRAM_DATA[47-:8]];
            update_cdf[55-:8] <= cdf_table[SRAM_DATA[55-:8]];
            update_cdf[63-:8] <= cdf_table[SRAM_DATA[63-:8]];
            update_cdf[71-:8] <= cdf_table[SRAM_DATA[71-:8]];
            update_cdf[79-:8] <= cdf_table[SRAM_DATA[79-:8]];
            update_cdf[87-:8] <= cdf_table[SRAM_DATA[87-:8]];
            update_cdf[95-:8] <= cdf_table[SRAM_DATA[95-:8]];
            update_cdf[103-:8] <= cdf_table[SRAM_DATA[103-:8]];
            update_cdf[111-:8] <= cdf_table[SRAM_DATA[111-:8]];
            update_cdf[119-:8] <= cdf_table[SRAM_DATA[119-:8]];
            update_cdf[127-:8] <= cdf_table[SRAM_DATA[127-:8]];
        end
           

    end
end


//======================================
//          BUSY
//======================================
always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
            busy<= 0;
    end else begin
        if(cstate == INPUT)
            busy<= 1;
        else if(cstate == IDLE)
            busy <= 0;
    end
end
//======================================
//          AXI READ 
//======================================
always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
            arvalid<= 0;
    end else begin
            if( cstate == SE_PUT_SRAM_VALID) begin
                if(arready_m_inf)
                    arvalid <= 0;
                else
                    arvalid <= 1;
            end
            else if(cstate == READ_PIC_VALID)begin
                if(arready_m_inf)
                    arvalid <= 0;
                else
                    arvalid <= 1;
            end
            else
                arvalid <= 0;
    end
end

assign arvalid_m_inf = arvalid;
always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
            araddr<= 0;
    end else begin
            if( cstate == SE_PUT_SRAM_VALID)begin
              
                if(arready_m_inf)
                    araddr <= 0;
                else
                    araddr <= 32'h0003_0000 + (se_no_reg << 4);

            end
            else if (cstate == READ_PIC_VALID)begin
                if(arready_m_inf)
                    araddr <= 0;
                else
                    araddr <= 32'h0004_0000+(pic_no_reg << 12);
            end
            else if(cstate == WRITE_VALID)begin
                if(awready_m_inf)
                    araddr <= 0;
                else
                    araddr <= 32'h0004_0000+(pic_no_reg << 12);
            end
            else
                araddr <= 0;
    end
end
assign araddr_m_inf = araddr;

assign arid_m_inf = 'd0;
assign arlen_m_inf = (cstate == SE_PUT_SRAM_DATA || cstate == SE_PUT_SRAM_VALID)?'d0:'d255;
assign arsize_m_inf = 3'b100;
assign arburst_m_inf = 2'b01;

//rready
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        rready <= 0;
    end
    else begin
        if(cstate == SE_PUT_SRAM_DATA)begin
                rready <= 1;
        end
        else if (cstate == READ_PIC_DATA)begin
                rready <= 1;
        end
        else
                rready <= 0;
    end
end
assign rready_m_inf = rready;
//rlast
always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
        rlast <= 0;
    end else begin
        if(cstate == IDLE)
            rlast <= 0;
        else if(cstate == READ_PIC_DATA)
            if(rlast_m_inf)
                rlast <= 1;
        else if(cstate == WRITE_VALID)
            rlast <= 0;
    end
end

///rvalid_counter
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        rvalid_cnt <= 0;
    end
    else begin
        if(rvalid_m_inf)begin
                rvalid_cnt <= rvalid_cnt + 1;
        end
        
        else
            rvalid_cnt <= 0;
    end
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        rvalid_cnt_d1 <= 0;
    end
    else begin
        if(rvalid_m_inf)begin
                rvalid_cnt_d1 <= rvalid_cnt;
        end
        else if(valid)
            rvalid_cnt_d1 <= rvalid_cnt_d1 + 1;
        else
            rvalid_cnt_d1 <= 0;
    end
end
always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
        valid <= 0;
    end else begin
        if(cstate == IDLE)
            valid <= 0;
        else if(rvalid_m_inf)
            valid <= 1;
    end
end
always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
        rvalid <= 0;
    end else begin
        if(cstate == READ_PIC_DATA)
            rvalid <= rvalid_m_inf;
        else begin
            rvalid <= 0;
        end
    end
end
//======================================
//          AXI WRITE
//======================================

always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
            awvalid<= 0;
    end else begin
            if( cstate == WRITE_VALID) begin
                if(awready_m_inf)
                    awvalid <= 0;
                else
                    awvalid <= 1;
            end
            else
                awvalid <= 0;
    end
end
assign awvalid_m_inf = awvalid;
assign awaddr_m_inf = araddr;
assign awid_m_inf = 'd0;
assign awburst_m_inf = 2'b01;
assign awsize_m_inf = 3'b100;
assign awlen_m_inf =(cstate == WRITE_VALID)?'d255:0 ;
//======================================
//          AXI WRITE DATA
//======================================


assign wdata_m_inf = PIC_Q1;

//wvalid
always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
            wvalid <= 0;
    end else begin
            if( cstate == WRITE_DATA) begin
                if(cnt < 255)
                    wvalid <= 1;
                else 
                    wvalid <= 0;
            end
            else 
                wvalid <=0;
            
    end
end

assign wvalid_m_inf   = wvalid;

//wlast
always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
            wlast <= 0;
    end else begin
            if( cstate == WRITE_DATA) begin
                if(cnt ==  254)
                    wlast <= 1;
                else 
                    wlast <= 0;
            end
            else 
                wlast <=0;
            
    end
end
assign wlast_m_inf =wlast;
//////////////////////////////////////////////
//              Write Response              //
//////////////////////////////////////////////
assign bready_m_inf = 1'd1;

RA2SHPI PIC(
   .QA(PIC_Q),
   .CLKA(clk),
   .CENA(1'b0),
   .WENA(PIC_WEN_r),
   .AA(PIC_A),
   .DA(DA),
   .OENA(1'b0),
   .QB(PIC_Q1),
   .CLKB(clk),
   .CENB(1'b0),
   .WENB(WENB),
   .AB(PIC_B),
   .DB(update_cdf),
   .OENB(1'b0)
);
// sram address
assign DA=(cstate == READ_PIC_DATA && op_reg != 2)?se_ans:dram_data;
//assign SE_A = (cstate != READ_PIC_DATA)?rvalid_cnt: se_no_reg;
assign PIC_A = (cstate == READ_PIC_DATA && op_reg != 2)?rvalid_cnt_d1-5'd15:
               (cstate == READ_PIC_DATA && op_reg == 2)?rvalid_cnt_d1:
               (cstate == READ_SRAM)?cnt_d:se_no_reg;
assign PIC_B = (cstate == READ_PIC_DATA && op_reg == 2 )?rvalid_cnt_d1-1:
                (cstate == READ_PIC_DATA && op_reg != 2 )?rvalid_cnt_d1:
               (cstate == READ_SRAM)?cnt_d-2'd3:
               (cstate == WRITE_DATA )?(wready_m_inf&&wvalid)?cnt+1:cnt:se_no_reg-1;
assign WENB = (cstate == READ_SRAM &&(cnt_d>= 3 && cnt_d <=258 ))? 1'b0 : 1'b1;
//assign SE_WEN = ~(cstate == SE_PUT_SRAM_DATA && rvalid_m_inf);
assign PIC_WEN =(op_reg == 2)? ~(cstate == READ_PIC_DATA && rvalid_m_inf):~(cstate == READ_PIC_DATA && rvalid_cnt_d1>13 && rvalid_cnt_d1 <270);
always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
            PIC_WEN_r<= 0;
            PIC_A_r<=0;
            SRAM_DATA<=0;
            PIC_DATA<=0;
    end else begin
            PIC_WEN_r<= PIC_WEN;
            PIC_A_r<= PIC_A;
            SRAM_DATA <= PIC_Q;
            PIC_DATA <= PIC_Q1;
    end
end


endmodule 