
module MMSA(
// input signals
    clk,
    rst_n,
    in_valid,
        in_valid2,
    matrix,
        matrix_size,
    i_mat_idx,
    w_mat_idx,
    
// output signals
    out_valid,
    out_value
);
//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION
//---------------------------------------------------------------------
input        clk, rst_n, in_valid, in_valid2;
input            matrix;
input [1:0]  matrix_size;
input            i_mat_idx, w_mat_idx;

output reg               out_valid;//
output reg                       out_value;//
//---------------------------------------------------------------------
//   WIRE AND REG DECLARATION
//---------------------------------------------------------------------
reg [19:0]i,idx;
reg two_idx;
reg [1:0]four_idx;
reg [2:0]eight_idx;
reg [3:0]sixteen_idx;
reg [63:0]input_data;
//SRAM control
reg I1_WEN,I2_WEN,I3_WEN,I4_WEN,W1_WEN,W2_WEN,W3_WEN,W4_WEN;
wire [6:0]I_A1,I_A2,I_A3,I_A4;
wire [6:0]W_A1,W_A2,W_A3,W_A4;
wire [63:0]I_D1,I_D2,I_D3,I_D4;
wire [63:0]W_D1,W_D2,W_D3,W_D4;
wire [63:0]I_Q1,I_Q2,I_Q3,I_Q4;
wire [63:0]W_Q1,W_Q2,W_Q3,W_Q4;
reg [63:0]i_mat,w_mat;
reg [63:0]i_mat2,w_mat2;
reg [63:0]i_mat3,w_mat3;
reg [63:0]i_mat4,w_mat4;
reg[3:0]sel_i_mat,sel_w_mat;
reg [7+1:0]address;
reg [7:0]addressw;
reg [1:0] rec_matrix_size;
//delay register
reg signed[15:0]i_mat_0;
reg signed[15:0]i_mat_1,i_mat_1d;
reg signed[15:0]i_mat_2[0:2];
reg signed[15:0]i_mat_3[0:3];
reg signed[15:0]i_mat_4[0:4];
reg signed[15:0]i_mat_5[0:5];
reg signed[15:0]i_mat_6[0:6];
reg signed[15:0]i_mat_7[0:7];
reg signed[35:0]c1,c2,c3,c4,c5,c6,c7,c8;
wire signed[15:0]d[0:15][0:15];
wire signed[35:0]c[0:15][0:15];
wire signed[39:0]out_c;


reg signed[39:0]cur_out,out_vr;

wire signed[39:0]ns_out,out_v;
reg signed[39:0]out[0:14];
reg [5:0]len,len_r;
wire signed[39:0]out_line;
reg[3:0]counter;
reg [15:0]mat;
reg finish;
reg[6:0]matrix_count;
integer jdx;
reg [5:0] len_r_store[0:14];
reg [5:0]count_ans;
reg [2:0]count_out;
reg flag_value;
reg flag_leng;
reg [4:0]count_num;
//---------------------------------------------------------------------
//   PARAMETER $ FSM
//---------------------------------------------------------------------
//***********************************              
// parameter      
//***********************************      
parameter IDLE       =  3'd0;
parameter INPUT      =  3'd1;
parameter DELAY      =  3'd2;
parameter INPUT_2    =  3'd3;
parameter CAL        =  3'd4;
parameter OUTPUT     =  3'd5;    
parameter OUTPUT_VALUE     =  3'd6;    

//****************************************
//Reg Daclaration          
//****************************************
reg [2:0]cstate;
reg [2:0]nstate;                            
reg [2:0]cstate_d1;      

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
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n) 
        cstate_d1 <= IDLE;
    else
        cstate_d1 <= cstate;
end
always@(*)
begin
    case(cstate)
    IDLE:
        nstate = (in_valid)? INPUT:IDLE; 
        
    INPUT:
        nstate = (!in_valid) ? DELAY:INPUT;    
    DELAY:
        nstate = INPUT_2;     
    INPUT_2:
        nstate = (!in_valid2) ? CAL:INPUT_2;   
    CAL:begin
        if(rec_matrix_size == 0)begin
            nstate = (i==7)? OUTPUT_VALUE : CAL;
        end 

        else if(rec_matrix_size == 1)begin
            nstate = (i==9)? OUTPUT_VALUE : CAL;
        end 
        else if(rec_matrix_size == 2)begin
            nstate = (i==14)? OUTPUT_VALUE : CAL;
        end 
        else 
            nstate = CAL;
    end
    OUTPUT_VALUE:
        nstate = ((matrix_count == 64)&&finish)?IDLE:((finish)?INPUT_2:OUTPUT_VALUE);
        
    default: nstate = IDLE;         
    endcase

end

//---------------------------------------------------------------------
//   DESIGN
//---------------------------------------------------------------------
SRAM_128_64_200M MEM1 (.Q(I_Q1), .CLK(clk), .CEN(1'b0), .WEN(I1_WEN), .A(I_A1), .D(I_D1), .OEN(1'b0));
SRAM_128_64_200M MEM2 (.Q(I_Q2), .CLK(clk), .CEN(1'b0), .WEN(I2_WEN), .A(I_A2), .D(I_D2), .OEN(1'b0));
////SRAM1 MEMW (.Q(I_Qw), .CLK(~clk), .CEN(1'b0), .WEN(I_WENw), .A(I_Aw), .D(I_Dw), .OEN(1'b0));
SRAM_128_64_200M MEMW1 (.Q(W_Q1), .CLK(clk), .CEN(1'b0), .WEN(W1_WEN), .A(W_A1), .D(W_D1), .OEN(1'b0));
SRAM_128_64_200M MEMW2 (.Q(W_Q2), .CLK(clk), .CEN(1'b0), .WEN(W2_WEN), .A(W_A2), .D(W_D2), .OEN(1'b0));
always @(*) begin
    if((cstate == INPUT)&&(rec_matrix_size==0)&&(two_idx == 1)&&(idx<66)&&(counter == 0)&&(idx != 1))begin
        I1_WEN = 0;
    end
    else if((cstate == INPUT)&&(rec_matrix_size==1)&&(four_idx == 1)&&(idx<258)&&(counter == 0)&&(idx != 1))begin
        I1_WEN = 0;
    end
    else if((cstate == INPUT)&&(rec_matrix_size==2)&&(eight_idx == 1)&&(idx<1026)&&(counter == 0)&&(idx != 1))begin
        I1_WEN = 0;
    end
    else
        I1_WEN = 1;
end
always @(*) begin
    if((cstate == INPUT)&&(rec_matrix_size==0)&&(two_idx == 1)&&(idx>65)&&(counter == 0)&&(idx != 1))begin
        W1_WEN = 0;
    end
    else if((cstate == INPUT)&&(rec_matrix_size==1)&&(four_idx == 1)&&(idx>257)&&(counter == 0)&&(idx != 1))begin
        W1_WEN = 0;
    end
    else if((cstate == INPUT)&&(rec_matrix_size==2)&&(eight_idx == 1)&&(idx>1025)&&(counter == 0)&&(idx != 1))begin
        W1_WEN = 0;
    end
    else if(cstate == DELAY)
        W1_WEN = 0;
    else
        W1_WEN = 1;
end

//SRAM2
always @(*) begin
    if((cstate == INPUT)&&(rec_matrix_size==2)&&(eight_idx == 5)&&(idx<1025)&&(counter == 0)&&(idx != 0))begin
        I2_WEN = 0;
    end
    else
        I2_WEN = 1;
end
always @(*) begin
    if((cstate == INPUT)&&(rec_matrix_size==2)&&(eight_idx == 5)&&(idx>1024)&&(counter == 0)&&(idx != 0))begin
        W2_WEN = 0;
    end
    else
        W2_WEN = 1;
end

assign I_D1 = input_data;
assign W_D1 = input_data;
assign I_D2 = input_data;
assign W_D2 = input_data;
//idx
always @(*) begin
    case (idx[0])
        0:two_idx = 0;
        1:two_idx = 1;
    endcase
end
always @(*) begin
    case (idx[1:0])
        0:four_idx = 0;
        1:four_idx = 1;
        2:four_idx = 2;
        3:four_idx = 3;
    endcase
end
always @(*) begin
    case (idx[2:0])
        0:eight_idx = 0;
        1:eight_idx = 1;
        2:eight_idx = 2;
        3:eight_idx = 3;
        4:eight_idx = 4;
        5:eight_idx = 5;
        6:eight_idx = 6;
        7:eight_idx = 7;
    endcase
end
always @(*) begin
    case (i[3:0])
        0:sixteen_idx = 0;
        1:sixteen_idx = 1;
        2:sixteen_idx = 2;
        3:sixteen_idx = 3;
        4:sixteen_idx = 4;
        5:sixteen_idx = 5;
        6:sixteen_idx = 6;
        7:sixteen_idx = 7;
        8:sixteen_idx = 8;
        9:sixteen_idx = 9;
        10:sixteen_idx = 10;
        11:sixteen_idx = 11;
        12:sixteen_idx = 12;
        13:sixteen_idx = 13;
        14:sixteen_idx = 14;
        15:sixteen_idx = 15;
    endcase
end


always @(posedge clk or negedge rst_n) begin : proc_counter
    if(~rst_n) begin
        counter <= 0;
    end else begin
        if(in_valid)
            counter <= counter +1 ;
        else if(cstate == OUTPUT)
            counter <= counter +1;

        else 
            counter <= 0;
    end
end

always @(posedge clk or negedge rst_n) begin : proc_mat
    if(~rst_n) begin
        mat <= 0;
    end else begin
        if(in_valid)
            mat <= {mat,matrix};
        else 
            mat <= 0;
    end
end
always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
         i <= 0;
    end 
    else begin
        if(nstate == IDLE)
            i <= 0;
        else if(nstate == INPUT) begin
            i <= i + 1;
        end
        else if(in_valid2)begin
            i <= 0;
        end
        else if(nstate == CAL || nstate == OUTPUT_VALUE || nstate ==OUTPUT) begin
            i <= i + 1;
        end
        
        else begin
            i<=0;
        end
    end
end
always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
         idx <= 0;
    end 
    else begin
        if(nstate == IDLE)
            idx <= 0;
        else if(nstate == INPUT && counter == 15) begin
            idx <= idx + 1;
        end
        else if(nstate == INPUT ) begin
            idx <= idx ;
        end
        else begin
            idx<=0;
        end
    end
end
always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
         rec_matrix_size <= 0;
    end 
    else begin
        if(nstate == IDLE)
            rec_matrix_size <= 0;
        else if((in_valid)&&(i == 0)) begin
            rec_matrix_size <= matrix_size;
        end
    end
end
// 2 x 2 input matrix
assign I_A1 = address;
assign I_A2 = address;
always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
         address <= 0;
    end 
    else begin
        if(cstate == IDLE)
            address <= 0;
        else if(cstate == INPUT) begin
            if((rec_matrix_size == 0)&&(two_idx == 1)&&(counter == 0)&&(idx != 1))
                address <= address + 1;
            else if((rec_matrix_size == 1)&&(four_idx == 1)&&(counter == 0)&&(idx != 1))
                address <= address + 1;
            else if((rec_matrix_size == 2)&&(eight_idx == 1)&&(counter == 0)&&(idx != 1))
                address <= address + 1;
        end
       
        else if(cstate == CAL)begin
            case (rec_matrix_size)
                0:begin 
                    if(i==1)
                        address <= (sel_i_mat*2);
                    else
                        address <= address +1 ;
                end
                1:begin 
                    if(i==1)
                        address <= (sel_i_mat*4);
                    else
                        address <= address +1 ;
                end
                2:begin 
                    if(i==1)
                        address <= (sel_i_mat*8);
                    else
                        address <= address +1 ;
                end
                
                
            endcase
        end
       
    end
end
// 2 x 2 wight matrix
assign W_A1 = addressw;
assign W_A2 = addressw;
always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
         addressw <= 0;
    end 
    else begin
        if(cstate == IDLE)
            addressw <= 0;
        else if(cstate == INPUT) begin
            if((rec_matrix_size == 0)&&(two_idx == 1)&&(address > 31)&&(counter == 0)&&(idx != 0))
                addressw <= addressw + 1;
            else if((rec_matrix_size == 1)&&(four_idx == 1)&&(address > 63)&&(counter == 0)&&(idx != 0))
                addressw <= addressw + 1;
            else if((rec_matrix_size == 2)&&(eight_idx == 1)&&(address > 127)&&(counter == 0)&&(idx != 0))
                addressw <= addressw + 1;
        end
        
        else if(cstate == CAL)begin
            case (rec_matrix_size)
                0:begin 
                    if(i==1)
                        addressw <= (sel_w_mat*2);
                    else
                        addressw <= addressw +1 ;
                end
                1:begin 
                    if(i==1)
                        addressw <= (sel_w_mat*4);
                    else
                        addressw <= addressw +1 ;
                end
                2:begin 
                    if(i==1)
                        addressw <= (sel_w_mat*8);
                    else
                        addressw <= addressw +1 ;
                end
                
            endcase
        end
       
    end
end
always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
        input_data <= 0;
    end else begin
        if(nstate == IDLE)
           input_data <= 0;
        else if((nstate == INPUT||nstate==DELAY) && counter == 0 && idx !=0)begin
            case (rec_matrix_size)
                0:begin 
                    if(!two_idx)
                        input_data <= {input_data[47:32],mat,32'b0};   // a b 0 0
                    else
                        input_data <= {16'b0,mat,16'b0,mat};
                end
                default:begin 
                    input_data <= {input_data,mat};
                end
                
                
            endcase
             
        end
    end
end
//select matrix
always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
        sel_i_mat <= 0;
        sel_w_mat <= 0;
    end else begin
        if(cstate == IDLE)begin
            sel_i_mat <= 0;
            sel_w_mat <= 0;
        end
        else if(in_valid2)begin
             sel_i_mat <= {sel_i_mat,i_mat_idx};
             sel_w_mat <= {sel_w_mat,w_mat_idx};
        end
    end
end
//---------------------------------------------------------------------
//   SRAM READ
//---------------------------------------------------------------------
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
       i_mat <= 0;
       w_mat <= 0;
    end 
    else begin
       if(cstate== IDLE)begin
            i_mat <= 0;
            w_mat <= 0;
       end
       else if(cstate== CAL)begin
            case (rec_matrix_size)
                    0:begin 
                        if(i>2&&i<5)begin //2
                            i_mat <= I_Q1;
                            w_mat <= W_Q1;
                        end
                        else begin
                            i_mat <= 0;
                            w_mat <= 0;
                        end    
                    end
                    1:begin 
                        if(i>2&&i<7)begin //4
                            i_mat <= I_Q1;
                            w_mat <= W_Q1;
                        end
                        else begin
                            i_mat <= 0;
                            w_mat <= 0;
                        end 
                    end
                    2:begin 
                        if(i>2&&i<11)begin//8
                            i_mat <= I_Q2;
                            w_mat <= W_Q2;
                        end
                        else begin
                            i_mat <= 0;
                            w_mat <= 0;
                        end 
                    end
                    
                endcase
       end
    end
end
//sram2
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
       i_mat2 <= 0;
       w_mat2 <= 0;
    end 
    else begin
       if(cstate== IDLE)begin
            i_mat2 <= 0;
            w_mat2 <= 0;
       end
       else if(cstate== CAL)begin
            if(i>2&&i<11)begin//8
                i_mat2 <= I_Q1;
                w_mat2 <= W_Q1;
            end
            else begin
                i_mat2 <= 0;
                w_mat2 <= 0;
            end
       end
    end
end

//---------------------------------------------------------------------
//   PE
//---------------------------------------------------------------------
assign flag = (cstate == CAL)&&(i==4);
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        i_mat_0 <= 0;
    end 
    else begin
        i_mat_0 <= i_mat[63:48];
    end
end
PE PE00(.clk(clk),.rst_n(rst_n),.set_zero(flag),.A(i_mat_0),.B(36'b0),.W(w_mat[63:48]),.C(c[0][0]),.D(d[0][0]));
PE PE01(.clk(clk),.rst_n(rst_n),.set_zero(flag),.A(d[0][0]),.B(36'b0),.W(w_mat[47:32]),.C(c[0][1]),.D(d[0][1]));
PE PE02(.clk(clk),.rst_n(rst_n),.set_zero(flag),.A(d[0][1]),.B(36'b0),.W(w_mat[31:16]),.C(c[0][2]),.D(d[0][2]));
PE PE03(.clk(clk),.rst_n(rst_n),.set_zero(flag),.A(d[0][2]),.B(36'b0),.W(w_mat[15:0] ),.C(c[0][3]),.D(d[0][3]));
PE PE04(.clk(clk),.rst_n(rst_n),.set_zero(flag),.A(d[0][3]),.B(36'b0),.W(w_mat2[63:48]),.C(c[0][4]),.D(d[0][4]));
PE PE05(.clk(clk),.rst_n(rst_n),.set_zero(flag),.A(d[0][4]),.B(36'b0),.W(w_mat2[47:32]),.C(c[0][5]),.D(d[0][5]));
PE PE06(.clk(clk),.rst_n(rst_n),.set_zero(flag),.A(d[0][5]),.B(36'b0),.W(w_mat2[31:16]),.C(c[0][6]),.D(d[0][6]));
PE PE07(.clk(clk),.rst_n(rst_n),.set_zero(flag),.A(d[0][6]),.B(36'b0),.W(w_mat2[15:0] ),.C(c[0][7]),.D(d[0][7]));
always @(posedge clk or negedge rst_n) begin                    
    if(~rst_n) begin
        i_mat_1 <= 0;
        i_mat_1d<=0;
    end 
    else begin
        {i_mat_1,i_mat_1d} <= {i_mat_1d,i_mat[47:32]};
    end
end
PE PE10(.clk(clk),.rst_n(rst_n),.set_zero((cstate == CAL)&&  (i==5)),.A(i_mat_1),.B(c[0][0]),.W(w_mat[63:48]),.C(c[1][0]),.D(d[1][0]));
PE PE11(.clk(clk),.rst_n(rst_n),.set_zero((cstate == CAL)&&  (i==5)),.A(d[1][0]),.B(c[0][1]),.W(w_mat[47:32]),.C(c[1][1]),.D(d[1][1])) ;
PE PE12(.clk(clk),.rst_n(rst_n),.set_zero((cstate == CAL)&&  (i==5)),.A(d[1][1]),.B(c[0][2]),.W(w_mat[31:16]),.C(c[1][2]),.D(d[1][2])) ;
PE PE13(.clk(clk),.rst_n(rst_n),.set_zero((cstate == CAL)&&  (i==5)),.A(d[1][2]),.B(c[0][3]),.W(w_mat[15:0] ),.C(c[1][3]),.D(d[1][3])) ;
PE PE14 (.clk(clk),.rst_n(rst_n), .set_zero((cstate == CAL)&&(i==5)),.A(d[1][3]), .B(c[0][4] ),.W(w_mat2[63:48]),.C(c[1][4] ),.D(d[1][4]));
PE PE15 (.clk(clk),.rst_n(rst_n), .set_zero((cstate == CAL)&&(i==5)),.A(d[1][4]), .B(c[0][5] ),.W(w_mat2[47:32]),.C(c[1][5] ),.D(d[1][5]));
PE PE16 (.clk(clk),.rst_n(rst_n), .set_zero((cstate == CAL)&&(i==5)),.A(d[1][5]), .B(c[0][6] ),.W(w_mat2[31:16]),.C(c[1][6] ),.D(d[1][6]));
PE PE17 (.clk(clk),.rst_n(rst_n), .set_zero((cstate == CAL)&&(i==5)),.A(d[1][6]), .B(c[0][7] ),.W(w_mat2[15:0] ),.C(c[1][7] ),.D(d[1][7]));
genvar j;
generate
for(j=0;j<3;j=j+1) begin:delay2
 always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
        i_mat_2[j]<=0;
  end
  else begin
        if(j==0)
            i_mat_2[j]<=i_mat[31:16];
        else
            i_mat_2[j]<=i_mat_2[j-1];
  end
 end
end
endgenerate
PE PE20(.clk(clk),.rst_n(rst_n),.set_zero((cstate == CAL)&&  (i==6)),.A(i_mat_2[2]),.B(c[1][0]),.W(w_mat[63:48]),.C(c[2][0]),.D(d[2][0]));
PE PE21(.clk(clk),.rst_n(rst_n),.set_zero((cstate == CAL)&&  (i==6)),.A(d[2][0]),.B(c[1][1]),.W(w_mat[47:32]),.C(c[2][1]),.D(d[2][1]));
PE PE22(.clk(clk),.rst_n(rst_n),.set_zero((cstate == CAL)&&  (i==6)),.A(d[2][1]),.B(c[1][2]),.W(w_mat[31:16]),.C(c[2][2]),.D(d[2][2]));
PE PE23(.clk(clk),.rst_n(rst_n),.set_zero((cstate == CAL)&&  (i==6)),.A(d[2][2]),.B(c[1][3]),.W(w_mat[15:0] ),.C(c[2][3]),.D(d[2][3]));
PE PE24 (.clk(clk),.rst_n(rst_n), .set_zero((cstate == CAL)&&(i==6)),.A(d[2][3]), .B(c[1][4] ),.W(w_mat2[63:48]),.C(c[2][4] ),.D(d[2][4]));
PE PE25 (.clk(clk),.rst_n(rst_n), .set_zero((cstate == CAL)&&(i==6)),.A(d[2][4]), .B(c[1][5] ),.W(w_mat2[47:32]),.C(c[2][5] ),.D(d[2][5]));
PE PE26 (.clk(clk),.rst_n(rst_n), .set_zero((cstate == CAL)&&(i==6)),.A(d[2][5]), .B(c[1][6] ),.W(w_mat2[31:16]),.C(c[2][6] ),.D(d[2][6]));
PE PE27 (.clk(clk),.rst_n(rst_n), .set_zero((cstate == CAL)&&(i==6)),.A(d[2][6]), .B(c[1][7] ),.W(w_mat2[15:0] ),.C(c[2][7] ),.D(d[2][7]));

genvar k;
generate
for(k=0;k<4;k=k+1) begin:delay3
 always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
        i_mat_3[k]<=0;
  end
  else begin
        if(k==0)
            i_mat_3[k]<=i_mat[15:0];
        else
            i_mat_3[k]<=i_mat_3[k-1];
  end
 end
end
endgenerate

PE PE30(.clk(clk),.rst_n(rst_n),  .set_zero((cstate == CAL)&&(i==7)),.A(i_mat_3[3]),.B(c[2][0]), .W(w_mat[63:48]), .C(c[3][0] ),.D(d[3][0]));
PE PE31(.clk(clk),.rst_n(rst_n),  .set_zero((cstate == CAL)&&(i==7)),.A(d[3][0]),   .B(c[2][1]), .W(w_mat[47:32]), .C(c[3][1] ),.D(d[3][1]));
PE PE32(.clk(clk),.rst_n(rst_n),  .set_zero((cstate == CAL)&&(i==7)),.A(d[3][1]),   .B(c[2][2]), .W(w_mat[31:16]), .C(c[3][2] ),.D(d[3][2]));
PE PE33(.clk(clk),.rst_n(rst_n),  .set_zero((cstate == CAL)&&(i==7)),.A(d[3][2]),   .B(c[2][3]), .W(w_mat[15:0] ), .C(c[3][3] ),.D(d[3][3]));
PE PE34 (.clk(clk),.rst_n(rst_n), .set_zero((cstate == CAL)&&(i==7)),.A(d[3][3]), .B(c[2][4] ),.W(w_mat2[63:48]),.C(c[3][4] ),.D(d[3][4]));
PE PE35 (.clk(clk),.rst_n(rst_n), .set_zero((cstate == CAL)&&(i==7)),.A(d[3][4]), .B(c[2][5] ),.W(w_mat2[47:32]),.C(c[3][5] ),.D(d[3][5]));
PE PE36 (.clk(clk),.rst_n(rst_n), .set_zero((cstate == CAL)&&(i==7)),.A(d[3][5]), .B(c[2][6] ),.W(w_mat2[31:16]),.C(c[3][6] ),.D(d[3][6]));
PE PE37 (.clk(clk),.rst_n(rst_n), .set_zero((cstate == CAL)&&(i==7)),.A(d[3][6]), .B(c[2][7] ),.W(w_mat2[15:0] ),.C(c[3][7] ),.D(d[3][7]));
//delay 4
genvar d4;
generate
for(d4=0;d4<5;d4=d4+1) begin:delay4
 always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
        i_mat_4[d4]<=0;
  end
  else begin
        if(d4==0)
            i_mat_4[d4]<=i_mat2[63:48];
        else
            i_mat_4[d4]<=i_mat_4[d4-1];
  end
 end
end
endgenerate

PE PE40(.clk(clk),.rst_n(rst_n),  .set_zero((cstate == CAL)&&(i==8)),.A(i_mat_4[4]),.B(c[3][0]), .W(w_mat[63:48]), .C(c[4][0] ),.D(d[4][0]));
PE PE41(.clk(clk),.rst_n(rst_n),  .set_zero((cstate == CAL)&&(i==8)),.A(d[4][0]),   .B(c[3][1]), .W(w_mat[47:32]), .C(c[4][1] ),.D(d[4][1]));
PE PE42(.clk(clk),.rst_n(rst_n),  .set_zero((cstate == CAL)&&(i==8)),.A(d[4][1]),   .B(c[3][2]), .W(w_mat[31:16]), .C(c[4][2] ),.D(d[4][2]));
PE PE43(.clk(clk),.rst_n(rst_n),  .set_zero((cstate == CAL)&&(i==8)),.A(d[4][2]),   .B(c[3][3]), .W(w_mat[15:0] ), .C(c[4][3] ),.D(d[4][3]));
PE PE44 (.clk(clk),.rst_n(rst_n), .set_zero((cstate == CAL)&&(i==8)),.A(d[4][3]),   .B(c[3][4] ),.W(w_mat2[63:48]),.C(c[4][4] ),.D(d[4][4]));
PE PE45 (.clk(clk),.rst_n(rst_n), .set_zero((cstate == CAL)&&(i==8)),.A(d[4][4]),   .B(c[3][5] ),.W(w_mat2[47:32]),.C(c[4][5] ),.D(d[4][5]));
PE PE46 (.clk(clk),.rst_n(rst_n), .set_zero((cstate == CAL)&&(i==8)),.A(d[4][5]),   .B(c[3][6] ),.W(w_mat2[31:16]),.C(c[4][6] ),.D(d[4][6]));
PE PE47 (.clk(clk),.rst_n(rst_n), .set_zero((cstate == CAL)&&(i==8)),.A(d[4][6]),   .B(c[3][7] ),.W(w_mat2[15:0] ),.C(c[4][7] ),.D(d[4][7]));
//delay 5
genvar d5;
generate
for(d5=0;d5<6;d5=d5+1) begin:delay5
 always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
        i_mat_5[d5]<=0;
  end
  else begin
        if(d5==0)
            i_mat_5[d5]<=i_mat2[47:32];
        else
            i_mat_5[d5]<=i_mat_5[d5-1];
  end
 end
end
endgenerate

PE PE50(.clk(clk),.rst_n(rst_n),  .set_zero((cstate == CAL)&&(i==9)),.A(i_mat_5[5]),.B(c[4][0]), .W(w_mat[63:48]), .C(c[5][0] ),.D(d[5][0]));
PE PE51(.clk(clk),.rst_n(rst_n),  .set_zero((cstate == CAL)&&(i==9)),.A(d[5][0]),   .B(c[4][1]), .W(w_mat[47:32]), .C(c[5][1] ),.D(d[5][1]));
PE PE52(.clk(clk),.rst_n(rst_n),  .set_zero((cstate == CAL)&&(i==9)),.A(d[5][1]),   .B(c[4][2]), .W(w_mat[31:16]), .C(c[5][2] ),.D(d[5][2]));
PE PE53(.clk(clk),.rst_n(rst_n),  .set_zero((cstate == CAL)&&(i==9)),.A(d[5][2]),   .B(c[4][3]), .W(w_mat[15:0] ), .C(c[5][3] ),.D(d[5][3]));
PE PE54 (.clk(clk),.rst_n(rst_n), .set_zero((cstate == CAL)&&(i==9)),.A(d[5][3]),   .B(c[4][4] ),.W(w_mat2[63:48]),.C(c[5][4] ),.D(d[5][4]));
PE PE55 (.clk(clk),.rst_n(rst_n), .set_zero((cstate == CAL)&&(i==9)),.A(d[5][4]),   .B(c[4][5] ),.W(w_mat2[47:32]),.C(c[5][5] ),.D(d[5][5]));
PE PE56 (.clk(clk),.rst_n(rst_n), .set_zero((cstate == CAL)&&(i==9)),.A(d[5][5]),   .B(c[4][6] ),.W(w_mat2[31:16]),.C(c[5][6] ),.D(d[5][6]));
PE PE57 (.clk(clk),.rst_n(rst_n), .set_zero((cstate == CAL)&&(i==9)),.A(d[5][6]),   .B(c[4][7] ),.W(w_mat2[15:0] ),.C(c[5][7] ),.D(d[5][7]));
//delay 6
genvar d6;
generate
for(d6=0;d6<7;d6=d6+1) begin:delay6
 always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
        i_mat_6[d6]<=0;
  end
  else begin
        if(d6==0)
            i_mat_6[d6]<=i_mat2[31:16];
        else
            i_mat_6[d6]<=i_mat_6[d6-1];
  end
 end
end
endgenerate
PE PE60(.clk(clk),.rst_n(rst_n),  .set_zero((cstate == CAL)&&(i==10)),.A(i_mat_6[6]),.B(c[5][0]), .W(w_mat[63:48]), .C(c[6][0] ),.D(d[6][0]));
PE PE61(.clk(clk),.rst_n(rst_n),  .set_zero((cstate == CAL)&&(i==10)),.A(d[6][0]),   .B(c[5][1]), .W(w_mat[47:32]), .C(c[6][1] ),.D(d[6][1]));
PE PE62(.clk(clk),.rst_n(rst_n),  .set_zero((cstate == CAL)&&(i==10)),.A(d[6][1]),   .B(c[5][2]), .W(w_mat[31:16]), .C(c[6][2] ),.D(d[6][2]));
PE PE63(.clk(clk),.rst_n(rst_n),  .set_zero((cstate == CAL)&&(i==10)),.A(d[6][2]),   .B(c[5][3]), .W(w_mat[15:0] ), .C(c[6][3] ),.D(d[6][3]));
PE PE64 (.clk(clk),.rst_n(rst_n), .set_zero((cstate == CAL)&&(i==10)),.A(d[6][3]),   .B(c[5][4] ),.W(w_mat2[63:48]),.C(c[6][4] ),.D(d[6][4]));
PE PE65 (.clk(clk),.rst_n(rst_n), .set_zero((cstate == CAL)&&(i==10)),.A(d[6][4]),   .B(c[5][5] ),.W(w_mat2[47:32]),.C(c[6][5] ),.D(d[6][5]));
PE PE66 (.clk(clk),.rst_n(rst_n), .set_zero((cstate == CAL)&&(i==10)),.A(d[6][5]),   .B(c[5][6] ),.W(w_mat2[31:16]),.C(c[6][6] ),.D(d[6][6]));
PE PE67 (.clk(clk),.rst_n(rst_n), .set_zero((cstate == CAL)&&(i==10)),.A(d[6][6]),   .B(c[5][7] ),.W(w_mat2[15:0] ),.C(c[6][7] ),.D(d[6][7]));
genvar d7;
generate
for(d7=0;d7<8;d7=d7+1) begin:delay7
 always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
        i_mat_7[d7]<=0;
  end
  else begin
        if(d7==0)
            i_mat_7[d7]<=i_mat2[15:0];
        else
            i_mat_7[d7]<=i_mat_7[d7-1];
  end
 end
end
endgenerate
PE PE70(.clk(clk),.rst_n(rst_n),  .set_zero((cstate == CAL)&&(i==11)),.A(i_mat_7[7]),.B(c[6][0]), .W(w_mat[63:48]), .C(c[7][0] ),.D(d[7][0]));
PE PE71(.clk(clk),.rst_n(rst_n),  .set_zero((cstate == CAL)&&(i==11)),.A(d[7][0]),   .B(c[6][1]), .W(w_mat[47:32]), .C(c[7][1] ),.D(d[7][1]));
PE PE72(.clk(clk),.rst_n(rst_n),  .set_zero((cstate == CAL)&&(i==11)),.A(d[7][1]),   .B(c[6][2]), .W(w_mat[31:16]), .C(c[7][2] ),.D(d[7][2]));
PE PE73(.clk(clk),.rst_n(rst_n),  .set_zero((cstate == CAL)&&(i==11)),.A(d[7][2]),   .B(c[6][3]), .W(w_mat[15:0] ), .C(c[7][3] ),.D(d[7][3]));
PE PE74 (.clk(clk),.rst_n(rst_n), .set_zero((cstate == CAL)&&(i==11)),.A(d[7][3]),   .B(c[6][4] ),.W(w_mat2[63:48]),.C(c[7][4] ),.D(d[7][4]));
PE PE75 (.clk(clk),.rst_n(rst_n), .set_zero((cstate == CAL)&&(i==11)),.A(d[7][4]),   .B(c[6][5] ),.W(w_mat2[47:32]),.C(c[7][5] ),.D(d[7][5]));
PE PE76 (.clk(clk),.rst_n(rst_n), .set_zero((cstate == CAL)&&(i==11)),.A(d[7][5]),   .B(c[6][6] ),.W(w_mat2[31:16]),.C(c[7][6] ),.D(d[7][6]));
PE PE77 (.clk(clk),.rst_n(rst_n), .set_zero((cstate == CAL)&&(i==11)),.A(d[7][6]),   .B(c[6][7] ),.W(w_mat2[15:0] ),.C(c[7][7] ),.D(d[7][7]));

//---------------------------------------------------------------------
//   OUTPUT
//---------------------------------------------------------------------
always @(*) begin 
    case (rec_matrix_size)
        0: c1 = c[1][0];
        1: c1 = c[3][0];
        2: c1 = c[7][0];
        3: c1 = 0;
    endcase
end
always @(*) begin 
    case (rec_matrix_size)
        0: c2 = c[1][1];
        1: c2 = c[3][1];
        2: c2 = c[7][1];
        3: c2 = 0;
    endcase
end
always @(*) begin 
    case (rec_matrix_size)
        0: c3 = 0;
        1: c3 = c[3][2];
        2: c3 = c[7][2];
        3: c3 = 0;
    endcase
end
always @(*) begin 
    case (rec_matrix_size)
        0: c4 = 0;
        1: c4 = c[3][3];
        2: c4 = c[7][3];
        3: c4 = 0;
    endcase
end
always @(*) begin 
    case (rec_matrix_size)
        0: c5 = 0;
        1: c5 = 0;
        2: c5 = c[7][4];
        3: c5 = 0;
    endcase
end
always @(*) begin 
    case (rec_matrix_size)
        0: c6 = 0;
        1: c6 = 0;
        2: c6 = c[7][5];
        3: c6 = 0;
    endcase
end
always @(*) begin 
    case (rec_matrix_size)
        0: c7 = 0;
        1: c7 = 0;
        2: c7 = c[7][6];
        3: c7 = 0;
    endcase
end
always @(*) begin 
    case (rec_matrix_size)
        0: c8 = 0;
        1: c8 = 0;
        2: c8 = c[7][7];
        3: c8 = 0;
    endcase
end


//assign out_line = out[0];
always @(*) begin
    casez(out_c)
        40'b1???_????_????_????_????_????_????_????_????_???? : len <= 6'd40;
        40'b01??_????_????_????_????_????_????_????_????_???? : len <= 6'd39;
        40'b001?_????_????_????_????_????_????_????_????_???? : len <= 6'd38;
        40'b0001_????_????_????_????_????_????_????_????_???? : len <= 6'd37;
        40'b0000_1???_????_????_????_????_????_????_????_???? : len <= 6'd36;
        40'b0000_01??_????_????_????_????_????_????_????_???? : len <= 6'd35;
        40'b0000_001?_????_????_????_????_????_????_????_???? : len <= 6'd34;
        40'b0000_0001_????_????_????_????_????_????_????_???? : len <= 6'd33;
        40'b0000_0000_1???_????_????_????_????_????_????_???? : len <= 6'd32;
        40'b0000_0000_01??_????_????_????_????_????_????_???? : len <= 6'd31;
        40'b0000_0000_001?_????_????_????_????_????_????_???? : len <= 6'd30;
        40'b0000_0000_0001_????_????_????_????_????_????_???? : len <= 6'd29;
        40'b0000_0000_0000_1???_????_????_????_????_????_???? : len <= 6'd28;
        40'b0000_0000_0000_01??_????_????_????_????_????_???? : len <= 6'd27;
        40'b0000_0000_0000_001?_????_????_????_????_????_???? : len <= 6'd26;
        40'b0000_0000_0000_0001_????_????_????_????_????_???? : len <= 6'd25;
        40'b0000_0000_0000_0000_1???_????_????_????_????_???? : len <= 6'd24;
        40'b0000_0000_0000_0000_01??_????_????_????_????_???? : len <= 6'd23;
        40'b0000_0000_0000_0000_001?_????_????_????_????_???? : len <= 6'd22;
        40'b0000_0000_0000_0000_0001_????_????_????_????_???? : len <= 6'd21;
        40'b0000_0000_0000_0000_0000_1???_????_????_????_???? : len <= 6'd20;
        40'b0000_0000_0000_0000_0000_01??_????_????_????_???? : len <= 6'd19;
        40'b0000_0000_0000_0000_0000_001?_????_????_????_???? : len <= 6'd18;
        40'b0000_0000_0000_0000_0000_0001_????_????_????_???? : len <= 6'd17;
        40'b0000_0000_0000_0000_0000_0000_1???_????_????_???? : len <= 6'd16;
        40'b0000_0000_0000_0000_0000_0000_01??_????_????_???? : len <= 6'd15;
        40'b0000_0000_0000_0000_0000_0000_001?_????_????_???? : len <= 6'd14;
        40'b0000_0000_0000_0000_0000_0000_0001_????_????_???? : len <= 6'd13;
        40'b0000_0000_0000_0000_0000_0000_0000_1???_????_???? : len <= 6'd12;
        40'b0000_0000_0000_0000_0000_0000_0000_01??_????_???? : len <= 6'd11;
        40'b0000_0000_0000_0000_0000_0000_0000_001?_????_???? : len <= 6'd10;
        40'b0000_0000_0000_0000_0000_0000_0000_0001_????_???? : len <= 6'd9;
        40'b0000_0000_0000_0000_0000_0000_0000_0000_1???_???? : len <= 6'd8;
        40'b0000_0000_0000_0000_0000_0000_0000_0000_01??_???? : len <= 6'd7;
        40'b0000_0000_0000_0000_0000_0000_0000_0000_001?_???? : len <= 6'd6;
        40'b0000_0000_0000_0000_0000_0000_0000_0000_0001_???? : len <= 6'd5;
        40'b0000_0000_0000_0000_0000_0000_0000_0000_0000_1??? : len <= 6'd4;
        40'b0000_0000_0000_0000_0000_0000_0000_0000_0000_01?? : len <= 6'd3;
        40'b0000_0000_0000_0000_0000_0000_0000_0000_0000_001? : len <= 6'd2;
        40'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0001 : len <= 6'd1;
        default : len <= 6'd1;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        for(jdx=0;jdx<15;jdx=jdx+1)
            len_r_store[jdx]<= 0;
    end else begin
        if(rec_matrix_size == 0)begin
            case (i)
            7 :  len_r_store[0] <=len;
            8:  len_r_store[1] <=len;
            9: len_r_store[2] <=len;
        endcase
        end
        else if(rec_matrix_size == 1)begin
        case (i)
            9 :  len_r_store[0] <=len;
            10:  len_r_store[1] <=len;
            11: len_r_store[2] <=len;
            12: len_r_store[3] <=len;
            13: len_r_store[4] <=len;
            14: len_r_store[5] <=len;
            15: len_r_store[6] <=len;
        endcase
        end
        else  if(rec_matrix_size == 2)begin
        case (i)
            13: len_r_store[0] <=len;
            14: len_r_store[1] <=len;
            15: len_r_store[2] <=len;
            16: len_r_store[3] <=len;
            17: len_r_store[4] <=len;
            18: len_r_store[5] <=len;
            19: len_r_store[6] <=len;
            20: len_r_store[7] <=len;
            21: len_r_store[8] <=len;
            22: len_r_store[9] <=len;
            23: len_r_store[10] <=len;
            24: len_r_store[11] <=len;
            25: len_r_store[12] <=len;
            26: len_r_store[13] <=len;
            27: len_r_store[14] <=len;
        endcase
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        for(jdx=0;jdx<15;jdx=jdx+1)
            out[jdx]<= 0;
    end else begin
        if(rec_matrix_size == 0)begin
            case (i)
            7 : out[0] <=out_c;
            8: out[1] <=out_c;
            9: out[2] <=out_c;
        endcase
        end
        else if(rec_matrix_size == 1)begin
        case (i)
            9 :out[0] <=out_c;
            10:out[1] <=out_c;
            11: out[2] <=out_c;
            12: out[3] <=out_c;
            13: out[4] <=out_c;
            14: out[5] <=out_c;
            15: out[6] <=out_c;
        endcase
        end
        else if(rec_matrix_size == 2)begin
        case (i)
            13: out[0] <=out_c;
            14: out[1] <=out_c;
            15: out[2] <=out_c;
            16: out[3] <=out_c;
            17: out[4] <=out_c;
            18: out[5] <=out_c;
            19: out[6] <=out_c;
            20: out[7] <=out_c;
            21: out[8] <=out_c;
            22: out[9] <=out_c;
            23: out[10] <=out_c;
            24: out[11] <=out_c;
            25: out[12] <=out_c;
            26: out[13] <=out_c;
            27: out[14] <=out_c;
        endcase
        end
    end
end
always @(posedge clk or negedge rst_n) begin : proc_count_ans
    if(~rst_n) begin
        count_ans <= 0;
    end else begin
        if(cstate == OUTPUT_VALUE )
            if(count_out == 5)
                count_ans <= len_r_store[count_num];
            else 
                count_ans <= count_ans - 1;
        else 
            count_ans <= 0;
    end
end

always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
        count_out <= 0;
    end else begin
        if(cstate == OUTPUT_VALUE)
            if(count_out ==5) count_out <= 7;
            else if(count_ans == 1)
                count_out <= count_out +1;
            else if(count_out == 7)
                count_out <= 7;
            else if(flag_value)
                count_out <= count_out +1;

        else 
            count_out <= 0;
    end
end
always @(posedge clk or negedge rst_n) begin : proc_flag_value
    if(~rst_n) begin
        flag_value <= 0;
    end else begin
        if(cstate == OUTPUT_VALUE)begin
            if(count_ans == 1)
                flag_value <= 1;
            else if(count_out >= 5 )
                flag_value <= 0;
            else 
                flag_value <= 1;
        end
        else 
            flag_value <= 0;
    end
end
always @(posedge clk or negedge rst_n) begin : proc_
    if(~rst_n) begin
        count_num <= 0;
    end else begin
        if(cstate == INPUT_2)
            count_num <= 0;
        else if(count_out ==5 && flag_value)
            count_num <= count_num + 1;

    end
end
adder add16 (c1,c2,c3,c4,c5,c6,c7,c8,out_c);
always@(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        out_valid <= 0; /* remember to reset */
        end
    else begin
        
        if(nstate != OUTPUT_VALUE)
            out_valid <= 0;
        else if(( cstate_d1 == OUTPUT_VALUE)) 
            out_valid<=1;
        else
            out_valid<=0;
    end
    
end

assign chose = (flag_value)? len_r_store[count_num][5-count_out]: out[count_num-1][count_ans-1];

always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
        out_value <= 0; /* remember to reset */
    else begin
         
        if(nstate != OUTPUT_VALUE)
            out_value <= 0;
        else if(cstate_d1 == OUTPUT_VALUE)begin
            out_value <= chose;
        end
        else
            out_value <= 0;

    end
end 

always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
        matrix_count <= 0; /* remember to reset */
    else begin
        if(cstate == IDLE)
            matrix_count <= 0;
        else if(in_valid2)
            matrix_count <= matrix_count + 1;
    end
end 

always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
        finish <= 0; /* remember to reset */
    else begin
        if(cstate == IDLE)
            finish <= 0;
        else if((cstate == OUTPUT_VALUE)&&(rec_matrix_size == 0)&&(count_num == 3)&&(count_ans==1))
            finish <= 1;
        else if((cstate == OUTPUT_VALUE)&&(rec_matrix_size == 1)&&(count_num == 7)&&(count_ans==1))
            finish <= 1;
        else if((cstate == OUTPUT_VALUE)&&(rec_matrix_size == 2)&&(count_num == 15)&&(count_ans==1))
            finish <= 1;
        else
            finish <= 0;
    end
end 


endmodule


module PE(clk,rst_n,set_zero,A,B,W,C,D);
input clk;    // Clock
input rst_n;  // Asynchronous reset active low
input set_zero;
input signed[15:0]A;
input signed[35:0]B;
input  signed[15:0]W;
output reg signed[35:0]C;
output reg signed[15:0]D;
reg signed[15:0] w_reg;
always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
        C <= 0;
    end 
    else begin
        C <= (A*w_reg)+B;
    end
end
always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
        D <= 0;
    end 
    else begin
        D <= A;
    end
end
always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
        w_reg <= 0;
    end 
    else begin
        if(set_zero)
            w_reg <= W;

    end
end
endmodule 


module adder (
input signed[35:0]in1,
input signed[35:0]in2,
input signed[35:0]in3,
input signed[35:0]in4,
input signed[35:0]in5,
input signed[35:0]in6,
input signed[35:0]in7,
input signed[35:0]in8,

output signed[39:0]out
);
assign out = in1+in2+in3+in4+in5+in6+in7+in8;
endmodule 
