module BP(
  clk,
  rst_n,
  in_valid,
  guy,
  in0,
  in1,
  in2,
  in3,
  in4,
  in5,
  in6,
  in7,
  
  out_valid,
  out
);

input             clk, rst_n;
input             in_valid;
input       [2:0] guy;
input       [1:0] in0, in1, in2, in3, in4, in5, in6, in7;
output reg        out_valid;
output reg  [1:0] out;
//==============================================//
//                 reg declaration              //
//==============================================//    
reg [2:0]guy_temp;
reg [7:0]shift_l,shift_r;
reg [62:0]out_reg_l,out_reg_r;
reg [2:0]position,position_reg;
reg [1:0]a[0:7];
reg [7:0]right_wire,left_wire;
wire [62:0]out_l,out_r;
wire[3:0]diff;
wire[2:0]diff_abs;
reg[5:0]counter;

//***********************************              
// parameter      
//***********************************      
parameter IDLE          =  3'd0;
parameter IN            =  3'd1;
parameter INPUT         =  3'd2;
parameter OUTPUT        =  3'd3;
       


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
                nstate = (in_valid)? IN:IDLE; 
                
            IN:
                nstate = INPUT;
            INPUT:       
                nstate = (in_valid)?INPUT:OUTPUT;   
            OUTPUT:
                nstate = (counter == 63)?IDLE:OUTPUT;
            
            default nstate = IDLE;         
            endcase
       
end

//==============================================//
//                Design                        //
//==============================================//  

generate
    genvar i;
    for(i=0;i<8;i=i+1)
       always @(posedge clk) begin
       
            case(i)
                0: a[i]<=in0;
                1: a[i]<=in1;
                2: a[i]<=in2;
                3: a[i]<=in3;
                4: a[i]<=in4;
                5: a[i]<=in5;
                6: a[i]<=in6;
                7: a[i]<=in7;
            endcase
        
    end
endgenerate

//==============================================//
//                diff                          //
//==============================================//  
assign diff = guy_temp - position_reg;   //A -> B B-A
assign diff_abs = ( diff[2:0]^{3{diff[3]}} ) + diff[3] ;

assign direction = (diff[3])? 1'b1:1'b0; //right == 0 , left == 1
//==============================================//
//            guy's position                    //
//==============================================//    
always @(posedge clk ) begin
    if (nstate == IN) begin  //03
            guy_temp <= guy ;
    end
    else if(nstate == INPUT)begin
        if(in0)begin
            guy_temp <= position;
        end
    end
end
//==============================================//
//                shift register                //
//==============================================// 
assign out_l = out_reg_l << 1;
assign out_r = out_reg_r << 1;
always @(posedge clk) begin
    if(cstate ==IDLE)begin
        out_reg_l <= 0;
    end
    else if(cstate ==INPUT) begin
        if(a[0])begin
            out_reg_l <= {out_l[62:8],(out_l[7:0] | left_wire)};
        end
        else begin
            out_reg_l <= out_l;
        end
    end
    else begin
        out_reg_l <= out_l;
    end
    
end
always @(posedge clk) begin
    if(cstate ==IDLE)begin
        out_reg_r <= 0;
    end
    else if(cstate ==INPUT) begin
        if(a[0])begin
            out_reg_r <= {out_r[62:8],(out_r[7:0] | right_wire)};
        end
        else begin
            out_reg_r <= out_r;
        end
    end
    else begin
        out_reg_r <= out_r;
    end
end
always @(*) begin
    if (a[0]) begin 
        if(direction)begin
            left_wire = shift_l; 
        end   
        else if(a[guy_temp] == 1)
            left_wire = 1;
        else
            left_wire = 0;
    end
    else begin
        left_wire = 0;
    end
end
always @(*) begin
    if (a[0]) begin 
        if(!direction)begin
            right_wire = shift_l; 
        end   
        else if(a[guy_temp] == 1)
            right_wire = 1;
        else
            right_wire = 0;
    end
    else begin
        right_wire = 0;
    end
end
//==============================================//
//           Position calculator                //
//==============================================// 

always @(*) begin
    if(in0 != 3'd3)
        position = 2'd0;
    else if(in1!=2'd3)begin
            position = 3'd1;
        end
    else if(in2!=2'd3)begin
            position = 3'd2;
        end
    else if(in3!=2'd3)begin
            position = 3'd3;
        end
    else if(in4!=2'd3)begin
            position = 3'd4;
        end
    else if(in5!=2'd3)begin
            position = 3'd5;
        end
    else if(in6!=2'd3)begin
            position = 3'd6;
        end
    else if(in7!=2'd3)begin
            position = 3'd7;
    end
    else begin
        position=3'd0;
    end
end
always @(posedge clk) begin
    
    if (in0) begin
        position_reg <= guy_temp ;
    end
    else begin
        position_reg <= 3'b0;
    end
    
end


always @(*) begin
    if(a[guy_temp]==1)begin
        case(diff_abs)
            0:shift_l = 8'b000_00001;
            1:shift_l = 8'b000_00011;
            2:shift_l = 8'b000_00111;
            3:shift_l = 8'b000_01111;
            4:shift_l = 8'b000_11111;
            5:shift_l = 8'b001_11111;
            6:shift_l = 8'b011_11111;
            7:shift_l = 8'b111_11111;
        endcase
    end
    
    else begin
         case(diff_abs)
            0:shift_l = 8'b0000_0000;
            1:shift_l = 8'b0000_0001;
            2:shift_l = 8'b0000_0011;
            3:shift_l = 8'b0000_0111;
            4:shift_l = 8'b0000_1111;
            5:shift_l = 8'b0001_1111;
            6:shift_l = 8'b0011_1111;
            7:shift_l = 8'b0111_1111;
        endcase
    end
end
always @(*) begin
    if(a[guy_temp]==1)begin
        case(diff_abs)
            0:shift_r = 8'b000_00001;
            1:shift_r = 8'b000_00011;
            2:shift_r = 8'b000_00111;
            3:shift_r = 8'b000_01111;
            4:shift_r = 8'b000_11111;
            5:shift_r = 8'b001_11111;
            6:shift_r = 8'b011_11111;
            7:shift_r = 8'b111_11111;
        endcase
    end
    
    else begin
         case(diff_abs)
            0:shift_r = 8'b0000_0000;
            1:shift_r = 8'b0000_0001;
            2:shift_r = 8'b0000_0011;
            3:shift_r = 8'b0000_0111;
            4:shift_r = 8'b0000_1111;
            5:shift_r = 8'b0001_1111;
            6:shift_r = 8'b0011_1111;
            7:shift_r = 8'b0111_1111;
        endcase
    end
end
//==============================================//
//           Output Counter 63 cycles           //
//==============================================//
always @(posedge clk) begin
    if (nstate == OUTPUT) begin
        counter <= counter + 1 ;
    end
    else begin
        counter <= 0 ;
    end
end
//==============================================//
//                Output Block                  //
//==============================================//

always@(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        out_valid <= 0; /* remember to reset */
        end
    else if(nstate == IDLE)begin
        out_valid <= 0;
    end
    else if(nstate == OUTPUT)begin
        out_valid<=1;
    end
    
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
        out <= 0; /* remember to reset */

    else if(nstate == OUTPUT)begin
        out <= {out_l[62],out_r[62]};
    end
    else begin
        out <= 0;
    end
end 
endmodule
