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
input [15:0] matrix;
input [1:0]  matrix_size;
input [3:0]  i_mat_idx, w_mat_idx;

output reg               out_valid;
output reg signed [39:0] out_value;
//---------------------------------------------------------------------
//   WIRE AND REG DECLARATION
//---------------------------------------------------------------------
reg [12:0]i;
reg two_idx;
reg [1:0]four_idx;
reg [2:0]eight_idx;
reg [3:0]sixteen_idx;
reg [63:0]input_data;
reg I1_WEN,I2_WEN,I3_WEN,I4_WEN,W1_WEN,W2_WEN,W3_WEN,W4_WEN;
wire [7:0]I_A1,I_A2,I_A3,I_A4;
wire [7:0]W_A1,W_A2,W_A3,W_A4;
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
reg [15:0]i_mat_1;
reg [15:0]i_mat_2,i_mat_2d;
reg [15:0]i_mat_3,i_mat_3d,i_mat_3d1;
//wire signed[39:0]c00,d00,c01,d01,c10,d10,c11,d11;
wire signed[39:0]d[0:15][0:15];
wire signed[39:0]c[0:15][0:15];
wire signed[39:0]two_out;
wire signed[39:0]four_out;
reg finish;
reg[4:0]matrix_count;
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
    


//****************************************
//Reg Daclaration          
//****************************************
reg [2:0]cstate;
reg [2:0]nstate;                            
        

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
        nstate = (!in_valid) ? DELAY:INPUT;    
    DELAY:
        nstate = INPUT_2;     
    INPUT_2:
        nstate = (!in_valid2) ? CAL:INPUT_2;   
    CAL:
        nstate = ((matrix_count == 16)&&finish)?IDLE:((finish)?INPUT_2:CAL);
    
    //OUTPUT_1:
    //    nstate =  () ? IDLE:OUTPUT_1;
    
    default: nstate = IDLE;         
    endcase

end

//---------------------------------------------------------------------
//   DESIGN
//---------------------------------------------------------------------
SRAM_256_64 MEM1 (.Q(I_Q1), .CLK(~clk), .CEN(1'b0), .WEN(I1_WEN), .A(I_A1), .D(I_D1), .OEN(1'b0));
SRAM_256_64 MEM2 (.Q(I_Q2), .CLK(~clk), .CEN(1'b0), .WEN(I2_WEN), .A(I_A2), .D(I_D2), .OEN(1'b0));
SRAM_256_64 MEM3 (.Q(I_Q3), .CLK(~clk), .CEN(1'b0), .WEN(I3_WEN), .A(I_A3), .D(I_D3), .OEN(1'b0));
SRAM_256_64 MEM4 (.Q(I_Q4), .CLK(~clk), .CEN(1'b0), .WEN(I4_WEN), .A(I_A4), .D(I_D4), .OEN(1'b0));
////SRAM1 MEMW (.Q(I_Qw), .CLK(~clk), .CEN(1'b0), .WEN(I_WENw), .A(I_Aw), .D(I_Dw), .OEN(1'b0));
SRAM_256_64 MEMW1 (.Q(W_Q1), .CLK(~clk), .CEN(1'b0), .WEN(W1_WEN), .A(W_A1), .D(W_D1), .OEN(1'b0));
SRAM_256_64 MEMW2 (.Q(W_Q2), .CLK(~clk), .CEN(1'b0), .WEN(W2_WEN), .A(W_A2), .D(W_D2), .OEN(1'b0));
SRAM_256_64 MEMW3 (.Q(W_Q3), .CLK(~clk), .CEN(1'b0), .WEN(W3_WEN), .A(W_A3), .D(W_D3), .OEN(1'b0));
SRAM_256_64 MEMW4 (.Q(W_Q4), .CLK(~clk), .CEN(1'b0), .WEN(W4_WEN), .A(W_A4), .D(W_D4), .OEN(1'b0));
always @(*) begin
    if((cstate == INPUT)&&(rec_matrix_size==0)&&(two_idx == 0)&&(i<65))begin
        I1_WEN = 0;
    end
    else if((cstate == INPUT)&&(rec_matrix_size==1)&&(four_idx == 0)&&(i<257))begin
        I1_WEN = 0;
    end
    else if((cstate == INPUT)&&(rec_matrix_size==2)&&(eight_idx == 4)&&(i<1025))begin
        I1_WEN = 0;
    end
    else if((cstate == INPUT)&&(rec_matrix_size==3)&&(sixteen_idx == 4)&&(i<4097))begin
        I1_WEN = 0;
    end
    else
        I1_WEN = 1;
end
always @(*) begin
    if((cstate == INPUT)&&(rec_matrix_size==0)&&(two_idx == 0)&&(i>64))begin
        W1_WEN = 0;
    end
    else if((cstate == INPUT)&&(rec_matrix_size==1)&&(four_idx == 0)&&(i>256))begin
        W1_WEN = 0;
    end
    else if((cstate == INPUT)&&(rec_matrix_size==2)&&(eight_idx == 4)&&(i>1024))begin
        W1_WEN = 0;
    end
    else if((cstate == INPUT)&&(rec_matrix_size==3)&&(sixteen_idx == 4)&&(i>4096))begin
        W1_WEN = 0;
    end
    else
        W1_WEN = 1;
end

//SRAM2
always @(*) begin
    if((cstate == INPUT)&&(rec_matrix_size==2)&&(eight_idx == 4)&&(i<1025))begin
        I2_WEN = 0;
    end
    else if((cstate == INPUT)&&(rec_matrix_size==3)&&(sixteen_idx == 8)&&(i<4097))begin
        I2_WEN = 0;
    end
    else
        I2_WEN = 1;
end
always @(*) begin
    if((cstate == INPUT)&&(rec_matrix_size==2)&&(eight_idx == 0)&&(i>1024))begin
        W2_WEN = 0;
    end
    else if((cstate == INPUT)&&(rec_matrix_size==3)&&(sixteen_idx == 8)&&(i>4096))begin
        W2_WEN = 0;
    end
    else
        W2_WEN = 1;
end
//SRAM3
always @(*) begin
    if((cstate == INPUT)&&(rec_matrix_size==3)&&(sixteen_idx == 12)&&(i<4097))begin
        I3_WEN = 0;
    end
    else
        I3_WEN = 1;
end
always @(*) begin
    if((cstate == INPUT)&&(rec_matrix_size==3)&&(sixteen_idx == 12)&&(i>4096))begin
        W3_WEN = 0;
    end
    else
        W3_WEN = 1;
end
//SRAM 4
always @(*) begin
    if((cstate == INPUT)&&(rec_matrix_size==3)&&(sixteen_idx == 0)&&(i<4097))begin
        I4_WEN = 0;
    end
    else
        I4_WEN = 1;
end
always @(*) begin
    if((cstate == INPUT)&&(rec_matrix_size==3)&&(sixteen_idx == 0)&&(i>4096))begin
        W4_WEN = 0;
    end
    else
        W4_WEN = 1;
end
assign I_D1 = input_data;
assign W_D1 = input_data;
assign I_D2 = input_data;
assign W_D2 = input_data;
assign I_D3 = input_data;
assign W_D3 = input_data;
assign I_D4 = input_data;
assign W_D4 = input_data;
//idx
always @(*) begin
    case (i[0])
        0:two_idx = 0;
        1:two_idx = 1;
    endcase
end
always @(*) begin
    case (i[1:0])
        0:four_idx = 0;
        1:four_idx = 1;
        2:four_idx = 2;
        3:four_idx = 3;
    endcase
end
always @(*) begin
    case (i[2:0])
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
        else if(nstate == CAL) begin
            i <= i + 1;
        end
        else begin
            i<=0;
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
assign I_A3 = address;
assign I_A4 = address;
always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
         address <= 0;
    end 
    else begin
        if(cstate == IDLE)
            address <= 0;
        else if(cstate == INPUT) begin
            if((rec_matrix_size == 0)&&(two_idx == 0))
                address <= address + 1;
            else if((rec_matrix_size == 1)&&(four_idx == 0))
                address <= address + 1;
            else if((rec_matrix_size == 2)&&(eight_idx == 0))
                address <= address + 1;
            else if((rec_matrix_size == 3)&&(sixteen_idx == 0))
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
                3:begin 
                    if(i==1)
                        address <= (sel_i_mat*16);
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
assign W_A3 = addressw;
assign W_A4 = addressw;
always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
         addressw <= 0;
    end 
    else begin
        if(cstate == IDLE)
            addressw <= 0;
        else if(cstate == INPUT) begin
            if((rec_matrix_size == 0)&&(two_idx == 0)&&(address > 31))
                addressw <= addressw + 1;
            else if((rec_matrix_size == 1)&&(four_idx == 0)&&(address > 63))
                addressw <= addressw + 1;
            else if((rec_matrix_size == 2)&&(eight_idx == 0)&&(address > 127))
                addressw <= addressw + 1;
            else if((rec_matrix_size == 3)&&(sixteen_idx == 0)&&(address > 255))
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
                3:begin 
                    if(i==1)
                        addressw <= (sel_w_mat*16);
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
        else if(nstate == INPUT)begin
            case (rec_matrix_size)
                0:begin 
                    if(two_idx)
                        input_data <= {input_data[47:32],matrix,32'b0};   // a b 0 0
                    else
                        input_data <= {16'b0,matrix,16'b0,matrix};
                end
                default:begin 
                    input_data <= {input_data,matrix};
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
             sel_i_mat <= i_mat_idx;
             sel_w_mat <= w_mat_idx;
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
                        if(i>1&&i<4)begin //2
                            i_mat <= I_Q1;
                            w_mat <= W_Q1;
                        end
                        else begin
                            i_mat <= 0;
                            w_mat <= 0;
                        end    
                    end
                    1:begin 
                        if(i>1&&i<6)begin //4
                            i_mat <= I_Q1;
                            w_mat <= W_Q1;
                        end
                        else begin
                            i_mat <= 0;
                            w_mat <= 0;
                        end 
                    end
                    2:begin 
                        if(i>1&&i<10)begin//8
                            i_mat <= I_Q1;
                            w_mat <= W_Q1;
                        end
                        else begin
                            i_mat <= 0;
                            w_mat <= 0;
                        end 
                    end
                    3:begin 
                        if(i>1&&i<18)begin//16
                            i_mat <= I_Q1;
                            w_mat <= W_Q1;
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
            case (rec_matrix_size)
                   
                    2:begin 
                        if(i>1&&i<10)begin//8
                            i_mat2 <= I_Q2;
                            w_mat2 <= W_Q2;
                        end
                        else begin
                            i_mat2 <= 0;
                            w_mat2 <= 0;
                        end 
                    end
                    3:begin 
                        if(i>1&&i<18)begin//16
                            i_mat2 <= I_Q2;
                            w_mat2 <= W_Q2;
                        end
                        else begin
                            i_mat2 <= 0;
                            w_mat2 <= 0;
                        end 
                    end
                    default:begin
                        i_mat2 <= 0;
                        w_mat2 <= 0;

                    end
                endcase
       end
    end
end
//sram3
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
       i_mat3 <= 0;
       w_mat3 <= 0;
    end 
    else begin
       if(cstate== IDLE)begin
            i_mat3 <= 0;
            w_mat3 <= 0;
       end
       else if(cstate== CAL)begin
            case (rec_matrix_size)
                   
                    3:begin 
                        if(i>1&&i<18)begin//16
                            i_mat3 <= I_Q3;
                            w_mat3 <= W_Q3;
                        end
                        else begin
                            i_mat3 <= 0;
                            w_mat3 <= 0;
                        end 
                    end
                    default:begin
                        i_mat3 <= 0;
                        w_mat3 <= 0;

                    end
                endcase
       end
    end
end
//sram4
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
       i_mat4 <= 0;
       w_mat4 <= 0;
    end 
    else begin
       if(cstate== IDLE)begin
            i_mat4 <= 0;
            w_mat4 <= 0;
       end
       else if(cstate== CAL)begin
            case (rec_matrix_size)
                   
                    3:begin 
                        if(i>1&&i<18)begin//16
                            i_mat4 <= I_Q4;
                            w_mat4 <= W_Q4;
                        end
                        else begin
                            i_mat4 <= 0;
                            w_mat4 <= 0;
                        end 
                    end
                    default:begin
                        i_mat4 <= 0;
                        w_mat4 <= 0;

                    end
                endcase
       end
    end
end
//---------------------------------------------------------------------
//   PE
//---------------------------------------------------------------------
assign flag = (cstate == CAL)&&(i==3);
PE PE00(.clk(clk),.rst_n(rst_n),.set_zero(flag),.A({{24{i_mat[63]}},i_mat[63:48]}),.B(40'b0),.W(w_mat[63:48]),.C(c[0][0]),.D(d[0][0]));
PE PE01(.clk(clk),.rst_n(rst_n),.set_zero(flag),.A(d[0][0]),.B(40'b0),.W(w_mat[47:32]),.C(c[0][1]),.D(d[0][1]));
PE PE02(.clk(clk),.rst_n(rst_n),.set_zero(flag),.A(d[0][1]),.B(40'b0),.W(w_mat[31:16]),.C(c[0][2]),.D(d[0][2]));
PE PE03(.clk(clk),.rst_n(rst_n),.set_zero(flag),.A(d[0][2]),.B(40'b0),.W(w_mat[15:0] ),.C(c[0][3]),.D(d[0][3]));
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        i_mat_1 <= 0;
    end 
    else begin
        i_mat_1 <= i_mat[47:32];
    end
end
PE PE10(.clk(clk),.rst_n(rst_n),.set_zero((cstate == CAL)&&(i==4)),.A({{24{i_mat_1[15]}},i_mat_1}),.B(c[0][0]),.W(w_mat[63:48]),.C(c[1][0]),.D(d[1][0]));
PE PE11(.clk(clk),.rst_n(rst_n),.set_zero((cstate == CAL)&&(i==4)),.A(d[1][0]),                    .B(c[0][1]),.W(w_mat[47:32]),.C(c[1][1]),.D(d[1][1])) ;
PE PE12(.clk(clk),.rst_n(rst_n),.set_zero((cstate == CAL)&&(i==4)),.A(d[1][1]),                    .B(c[0][2]),.W(w_mat[31:16]),.C(c[1][2]),.D(d[1][2])) ;
PE PE13(.clk(clk),.rst_n(rst_n),.set_zero((cstate == CAL)&&(i==4)),.A(d[1][2]),                    .B(c[0][3]),.W(w_mat[15:0] ),.C(c[1][3]),.D(d[1][3])) ;
always @(posedge clk or negedge rst_n) begin                    
    if(~rst_n) begin
        i_mat_2 <= 0;
        i_mat_2d<=0;
    end 
    else begin
        {i_mat_2,i_mat_2d} <= {i_mat_2d,i_mat[31:16]};
    end
end
PE PE20(.clk(clk),.rst_n(rst_n),.set_zero((cstate == CAL)&&(i==5)),.A({{24{i_mat_2[15]}},i_mat_2}),.B(c[1][0]),.W(w_mat[63:48]),.C(c[2][0]),.D(d[2][0]));
PE PE21(.clk(clk),.rst_n(rst_n),.set_zero((cstate == CAL)&&(i==5)),.A(d[2][0]),                    .B(c[1][1]),.W(w_mat[47:32]),.C(c[2][1]),.D(d[2][1]));
PE PE22(.clk(clk),.rst_n(rst_n),.set_zero((cstate == CAL)&&(i==5)),.A(d[2][1]),                    .B(c[1][2]),.W(w_mat[31:16]),.C(c[2][2]),.D(d[2][2]));
PE PE23(.clk(clk),.rst_n(rst_n),.set_zero((cstate == CAL)&&(i==5)),.A(d[2][2]),                    .B(c[1][3]),.W(w_mat[15:0] ),.C(c[2][3]),.D(d[2][3]));
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        i_mat_3 <= 0;
        i_mat_3d<=0;
        i_mat_3d1<=0;
    end 
    else begin
        {i_mat_3,i_mat_3d,i_mat_3d1} <= {i_mat_3d,i_mat_3d1,i_mat[15:0]};
    end
end
PE PE30(.clk(clk),.rst_n(rst_n),.set_zero((cstate == CAL)&&(i==6)),.A({{24{i_mat_3[15]}},i_mat_3}),.B(c[2][0]),.W(w_mat[63:48]),.C(c[3][0]),.D(d[3][0]));
PE PE31(.clk(clk),.rst_n(rst_n),.set_zero((cstate == CAL)&&(i==6)),.A(d[3][0]),                    .B(c[2][1]),.W(w_mat[47:32]),.C(c[3][1]),.D(d[3][1]));
PE PE32(.clk(clk),.rst_n(rst_n),.set_zero((cstate == CAL)&&(i==6)),.A(d[3][1]),                    .B(c[2][2]),.W(w_mat[31:16]),.C(c[3][2]),.D(d[3][2]));
PE PE33(.clk(clk),.rst_n(rst_n),.set_zero((cstate == CAL)&&(i==6)),.A(d[3][2]),                    .B(c[2][3]),.W(w_mat[15:0] ),.C(c[3][3]),.D(d[3][3]));

//two output
assign two_out = c[1][0]+c[1][1];
assign four_out = c[3][0]+c[3][1]+c[3][2]+c[3][3];

//---------------------------------------------------------------------
//   OUTPUT
//---------------------------------------------------------------------
always@(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        out_valid <= 0; /* remember to reset */
        end
    else begin
        if((cstate == CAL)&&(rec_matrix_size == 0)&&((i>4)&&(i<8)))
            out_valid<=1;
        else if((cstate == CAL)&&(rec_matrix_size == 0)&&(i==8))
            out_valid<=0;
        else if((cstate == CAL)&&(rec_matrix_size == 1)&&((i>6)&&(i<14)))
            out_valid<=1;
        else if((cstate == CAL)&&(rec_matrix_size == 1)&&(i==14))
            out_valid<=0;
        else
            out_valid<=0;
    end
    
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
        out_value <= 0; /* remember to reset */
    else begin
        if((cstate == CAL)&&(rec_matrix_size == 0)&&((i>4)&&(i<8)))
            out_value<=two_out;
        else if((cstate == CAL)&&(rec_matrix_size == 0)&&(i==8))
            out_value<=0;
        if((cstate == CAL)&&(rec_matrix_size == 1)&&((i>6)&&(i<14)))
            out_value<=four_out;
        else if((cstate == CAL)&&(rec_matrix_size == 1)&&(i==14))
            out_value<=0;
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
        else if((cstate == CAL)&&(rec_matrix_size == 0)&&(i==8))
            finish <= 1;
        else if((cstate == CAL)&&(rec_matrix_size == 1)&&(i==14))
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
input signed[39:0]A;
input signed[39:0]B;
input  signed[15:0]W;
output reg signed[39:0]C;
output reg signed[39:0]D;
reg signed[15:0] w_reg;
always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
        C <= 0;
    end 
    else begin
        if(set_zero)
            C <= (A*W)+B;
        else 
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

