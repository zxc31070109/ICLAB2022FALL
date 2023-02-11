//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   File Name   : UT_TOP.v
//   Module Name : UT_TOP
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

//synopsys translate_off
`include "B2BCD_IP.v"
// synopsys translate_on



module UT_TOP (
    // Input signals
    clk, rst_n, in_valid, in_time,
    // Output signals
    out_valid, out_display, out_day
);

// ===============================================================
// Input & Output Declaration
// ===============================================================
input clk, rst_n, in_valid;
input [30:0] in_time;
output reg out_valid;
output reg [3:0] out_display;
output reg [2:0] out_day;

// ===============================================================
// Reg Declaration
// ===============================================================
reg[14:0]quotient;
reg[5:0]second;
reg[5:0]minute_ans;
reg[4:0]hour_ans;
reg[1:0]count;
reg[1:0]count_w;
reg[8:0]days,day,day_r;
reg[8:0]days_w;
reg[2:0]week;
reg[3:0]month,month_r;
//reg[23:0]temp_128;
//reg[9:0]temp_675_mod;
reg[30:0]in_time_reg;
reg[16:0]reminder_r;
reg[11:0]hour;
reg[14:0]day_reminder;
reg[5:0]day_quotient;
reg[6:0]year_r;
reg [4:0]i;
reg flag_r;

//================================================================
// Wire Declaration
//================================================================
wire[14:0]quotient_w;
wire[6:0]temp_128mod;
wire[9:0]temp_675_mod_w;
wire[16:0]temp_4bit;
wire[16:0]reminder;
wire[16:0]reminder_60_wire;
wire[11:0]hour_wire,min_wire;
wire[5:0]day_1461_Quo;
wire[14:0]day_1461_Rem;
wire flag;
wire [6:0]year;
wire[11:0]BCD_chose_wire;
reg [6:0]chose_wire;
//***********************************              
// parameter      
//***********************************      
parameter IDLE       =  1'd0;
parameter CAL      =    1'd1;

    


//****************************************
//Reg Daclaration          
//****************************************
reg cstate;
reg nstate;                            
        

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
        nstate = (in_valid)? CAL:IDLE; 
           
    CAL:
        nstate = (i==17)?IDLE:CAL;
    
    
    //default: nstate = IDLE;         
    endcase

end
//================================================================
// design
//================================================================
always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
       in_time_reg <= 0;
    end 
    else begin
       if(in_valid)
        in_time_reg <= in_time;
    end
end
assign quotient_w = in_time_reg[30:7] / 10'd675;
always @(posedge clk ) begin 
    if(!cstate) begin
        quotient <= 0;
    end 
    else begin
        quotient <= quotient_w;
    end
end
//always @(posedge clk or negedge rst_n) begin 
//    if(~rst_n) begin
//        quotient <= 0;
//    end else begin
//        quotient <= quotient_w;
//    end
//end
assign reminder = (temp_675_mod_w<<7)+temp_128mod;
always @(posedge clk ) begin 
    if(!cstate) begin
        reminder_r <= 0;
    end 
    else begin
        reminder_r <= reminder;
    end
end
//always @(posedge clk or negedge rst_n) begin 
//    if(~rst_n) begin
//        reminder_r <= 0;
//    end else begin
//        reminder_r <= reminder;
//    end
//end
assign temp_675_mod_w = in_time_reg[30:7] - (quotient* 10'd675);
assign temp_128mod = in_time_reg[6:0];
//================================================================
// days 1461 
//================================================================
assign day_1461_Quo = quotient / 11'd1461;
assign day_1461_Rem = quotient - day_1461_Quo*11'd1461;
always @(posedge clk ) begin 
    if(!cstate) begin
        day_quotient <= 0;
    end 
    else begin
        day_quotient <= day_1461_Quo;
    end
end
//always @(posedge clk or negedge rst_n) begin 
//    if(~rst_n) begin
//        day_quotient <= 0;
//    end else begin
//        day_quotient <= day_1461_Quo;
//    end
//end
always @(posedge clk ) begin 
    if(!cstate) begin
        day_reminder <= 0;
    end 
    else begin
        day_reminder <= day_1461_Rem;
    end
end
//always @(posedge clk or negedge rst_n) begin 
//    if(~rst_n) begin
//        day_reminder <= 0;
//    end else begin
//        day_reminder <= day_1461_Rem;
//    end
//end

always @(*) begin 
    if(day_reminder < 365)begin
        days_w = day_reminder;
    end
    else if (day_reminder-11'd365 < 365)begin
        days_w = day_reminder-11'd365;
    end
    else if (day_reminder-11'd730 < 366)begin  //leap year
        days_w = day_reminder-11'd730;
    end
    else if (day_reminder-11'd1096 < 365)begin
        days_w = day_reminder-11'd1096;
    end
    else begin
         days_w = 0;
    end
end
always @(*) begin 
    if(day_1461_Rem < 365)begin
        count_w = 2'd0;
        
    end
    else if (day_1461_Rem-11'd365 < 365)begin
        count_w = 2'd1;
    end
    else if (day_1461_Rem-11'd730 < 366)begin  //leap year
        count_w = 2'd2;
    end
    else if (day_1461_Rem-11'd1096 < 365)begin
        count_w = 2'd3;
    end
    else begin
         count_w = 2'd0;
    end
end
//always @(posedge clk or negedge rst_n) begin 
//    if(~rst_n) begin
//        count <= 0;
//    end else begin
//        count <= count_w;
//    end
//end
//always @(posedge clk or negedge rst_n) begin 
//    if(~rst_n) begin
//        days <= 0;
//    end else begin
//        days <= days_w;
//    end
//end
always @(posedge clk ) begin 
    if(!cstate) begin
        count <= 0;
        days <= 0;
        flag_r <= 0;
        year_r <= 0;
         day_r  <= 0 ;
        month_r <= 0;
        hour <= 0;
    end 
    else begin
        count <= count_w;
        days <= days_w;
        flag_r <= flag;
        year_r <= year;
         day_r  <= day ;
        month_r <= month;
        hour <= hour_wire;
    end
end
assign flag = (((day_1461_Quo << 2) + count_w)>=30); 
//always @(posedge clk or negedge rst_n) begin 
//    if(~rst_n) begin
//        flag_r <= 0;
//    end else begin
//        flag_r <= flag;
//    end
//end
assign year =(flag_r)?(day_quotient << 2) + count-30:(day_quotient << 2) + count+70;

//always @(posedge clk or negedge rst_n) begin 
//    if(~rst_n) begin
//        year_r <= 0;
//    end else begin
//        year_r <= year;
//    end
//end
//B2BCD_IP #(.WIDTH(11), .DIGIT(4)) I_B2BCD_IP ( .Binary_code(year_r), .BCD_code(BCD_code_wire) );
always @(*) begin 
            case (i)
                4:chose_wire=year_r;
                5:chose_wire=year_r;
                6:chose_wire=month_r; //wire
                7:chose_wire=month_r;//wire
                8:chose_wire=day_r;
                9:chose_wire=day_r;
                10:chose_wire=hour_ans;
                11:chose_wire=hour_ans;
                12:chose_wire=minute_ans;
                13:chose_wire=minute_ans;
                14:chose_wire=second;
                15:chose_wire=second;
                default:chose_wire=0;
            endcase
end

B2BCD_IP #(.WIDTH(7), .DIGIT(3)) I_B2BCD_IP1 ( .Binary_code(chose_wire), .BCD_code(BCD_chose_wire) );


always @(*) begin
    if (count == 2'd2) begin // 1 31
        if(days<31)begin
            day = days +1 ;
            month = 4'd1;
        end
        else if(days <60)begin //2 29
            day = days-31 +1 ;
            month = 4'd2;
        end
        else if( days <91)begin //3 31
            day = days-60 +1 ;
            month = 4'd3;
        end
        else if(days <121)begin //4 30
            day = days-91 +1 ;
            month = 4'd4;
        end
        else if(days <152)begin//5 31
            day = days-121 +1 ;
            month = 4'd5;
        end
        else if( days <182)begin//6 30
            day = days-152 +1 ;
            month = 4'd6;
        end
        else if( days <213)begin//7 31
            day = days-182 +1 ;
            month = 4'd7;
        end
        else if( days <244)begin//8 31
            day = days-213 +1 ;
            month = 4'd8;
        end
        else if( days <274)begin//9 30
            day = days-244 +1 ;
            month = 4'd9;
        end
        else if( days <305)begin//10 31
            day = days-274 +1 ;
            month = 4'd10;
        end
        else if( days <335)begin//11 30
            day = days-305 +1 ;
            month = 4'd11;
        end
        else if( days <366)begin//12 31
            day = days-335 +1 ;
            month = 4'd12;
        end
        else begin
            day = 0 ;
            month = 0;
        end
    end
    else begin
        if(days<31)begin
            day = days +1 ;
            month = 4'd1;
        end
        else if( days <59)begin //2 28
            day = days-30 ;
            month = 4'd2;
        end
        else if( days <90)begin //3 31
            day = days-58 ;
            month = 4'd3;
        end
        else if( days <120)begin //4 30
            day = days-89 ;
            month = 4'd4;
        end
        else if( days <151)begin//5 31
            day = days-119 ;
            month = 4'd5;
        end
        else if( days <181)begin//6 30
            day = days-150 ;
            month = 4'd6;
        end
        else if( days <212)begin//7 31
            day = days-180 ;
            month = 4'd7;
        end
        else if(days <243)begin//8 31
            day = days-211 ;
            month = 4'd8;
        end
        else if( days <273)begin//9 30
            day = days-242 ;
            month = 4'd9;
        end
        else if( days <304)begin//10 31
            day = days-272 ;
            month = 4'd10;
        end
        else if( days <334)begin//11 30
            day = days-303 ;
            month = 4'd11;
        end
        else if( days <365)begin//12 31
            day = days-333 ;
            month = 4'd12;
        end
        else begin
            day = 0 ;
            month = 0;
        end

        
    end
end

//always @(posedge clk or negedge rst_n) begin 
//    if(~rst_n) begin
//         day_r  <= 0 ;
//        month_r <= 0;
//    end else begin
//        day_r  <= day ;
//        month_r <= month;
//    end
//end
//assign mod_7 = quotient / 7;

always @(*) begin 
    case (quotient % 3'd7)
        0: week = 3'd4;
        1: week = 3'd5;
        2: week = 3'd6;
        3: week = 3'd0;
        4: week = 3'd1;
        5: week = 3'd2;
        6: week = 3'd3;
        default : week = 0;
    endcase

end

//================================================================
// hours
//================================================================

assign  hour_wire = reminder_60_wire / 7'd60;
assign min_wire = reminder_60_wire - hour_wire*7'd60;
assign reminder_60_wire = (i==4)?(reminder_r):(hour );

//always @(posedge clk or negedge rst_n) begin 
//    if(~rst_n) begin
//        hour <= 0;
//    end else begin
//
//        hour <= hour_wire;
//    end
//end
always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
        second <= 0;
        minute_ans <= 0;
        hour_ans <= 0;
        
    end else begin
        if(i==4)
            second <= min_wire;
        else if(i==5)
            minute_ans <= min_wire;
        else if(i==6)
            hour_ans <= min_wire;
    end
end
//================================================================
// INPUT
//================================================================
always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
        i <= 0;
    end 
    else begin
        if(!cstate)
            i<=0;
        else
            i <= i +1;
    end
end
//================================================================
// OUTPUT
//================================================================

always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
        out_display <= 0;
    end else begin
        case (i)
            2 :out_display <= (flag)?4'b0010:4'b0001;
            3 :out_display <= (flag)?4'b0000:4'b1001;
            4 :out_display <= BCD_chose_wire[7:4];
            5 :out_display <= BCD_chose_wire[3:0];
            6 :out_display <= BCD_chose_wire[7:4];
            7 :out_display <= BCD_chose_wire[3:0];
            8 :out_display <= BCD_chose_wire[7:4];
            9:out_display  <= BCD_chose_wire[3:0];
            10:out_display <= BCD_chose_wire[7:4];
            11:out_display <= BCD_chose_wire[3:0];
            12:out_display <= BCD_chose_wire[7:4];
            13:out_display <= BCD_chose_wire[3:0];
            14:out_display <= BCD_chose_wire[7:4];
            15:out_display <= BCD_chose_wire[3:0];
                default : out_display <= 0;
        endcase
    end
end

always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
        out_day <= 0;
    end else begin
        if(i>1 && i<=15)
            out_day <= week;
        else 
            out_day <= 0;
    end
end

always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
        out_valid <= 0;
    end else begin
        if(i>1 && i<=15)
            out_valid <= 1;
        else 
            out_valid <= 0;
    end
end

endmodule
