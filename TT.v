module TT(
    //Input Port
    clk,
    rst_n,
	in_valid,
    source,
    destination,

    //Output Port
    out_valid,
    cost
    );

input               clk, rst_n, in_valid;
input       [3:0]   source;
input       [3:0]   destination;

output reg          out_valid;
output reg  [3:0]   cost;
//==============================================//
//                 reg declaration              //
//==============================================//
parameter NUM   =  30;  
reg [3:0] source_input,destination_input;
reg adjacency_matrix[0:15][0:15];
reg visit[0:15];

reg pass_flag;
reg [4:0]queue[0:16];
reg [3:0]pointer,node;
reg [4:0]i,i_reg;
reg [3:0]iteration1_counter;
reg find_flag;
reg zero_flag;
reg first;
reg [3:0]counter,number,number_reg;

wire road_flag;

integer j,k;

//***********************************              
// parameter      
//***********************************      
parameter IDLE              =  4'd0;
parameter INPUT             =  4'd1;
parameter INPUT_ROUTE       =  4'd2;
parameter PASS              =  4'd3;
parameter ACC               =  4'd4;
parameter OUT               =  4'd5;
parameter ITERATION1         =  4'd6;  
parameter UPDATE            =  4'd7; 
parameter OUTPUT            =  4'd8;      
parameter OUTPUT_ZERO       =  4'd9; 


//****************************************
//Reg Daclaration          
//****************************************
reg [3:0]cstate;
reg [3:0]nstate;                            
        

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
    if(!rst_n) 
        nstate = IDLE;
    else
        begin
            case(cstate)
            IDLE:
                nstate = (in_valid)? INPUT:IDLE; 
                
            INPUT:
                nstate = INPUT_ROUTE;      
                
            INPUT_ROUTE:
                nstate = (!in_valid)?PASS:INPUT_ROUTE;
            
            PASS:
                nstate = (pass_flag)? OUT : ACC ;
               
            ACC:
                nstate = ITERATION1;
               
            OUT:
                nstate = IDLE;
            ITERATION1: begin
                    if(find_flag)begin
                        nstate = OUTPUT;
                    end
                    else if((i == 4'd15)&&(queue[0]==source_input))
                        nstate = UPDATE;
                    else if (number_reg == 0)
                        nstate = UPDATE;
                    else begin
                        nstate = ITERATION1;
                    end
                end
            UPDATE:
                nstate = (zero_flag)?OUTPUT_ZERO : ITERATION1;
           
            
            OUTPUT:
                nstate = IDLE;
            OUTPUT_ZERO:
                nstate = IDLE;
            default nstate = IDLE;         
            endcase
        end
end
//==============================================//
//                  Input Block                 //
//==============================================//

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // reset
        source_input <= 0 ;
        destination_input <= 0;
    end
    else if ((nstate == INPUT) && in_valid) begin
        source_input <= source ;
        destination_input <= destination;
    end
    else begin
        source_input <= source_input ;
        destination_input <= destination_input;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // reset
        for(j=0;j<16;j=j+1) begin
           for(k=0;k<16;k=k+1) begin
              adjacency_matrix[j][k] <= 0;
          end
        end
       
    end
    else begin
        case (nstate)
            IDLE: begin
                for(j=0;j<16;j=j+1) begin
                   for(k=0;k<16;k=k+1) begin
                      adjacency_matrix[j][k] <= 0;
                  end
                end
            end  
            INPUT_ROUTE:begin
        adjacency_matrix[source][destination] <= 1'b1;
        adjacency_matrix[destination][source] <= 1'b1;
    end

            ITERATION1:  begin
                if(road_flag)begin
                    adjacency_matrix[0][i] <= 1'b0; 
                    adjacency_matrix[1][i] <= 1'b0; 
                    adjacency_matrix[2][i] <= 1'b0; 
                    adjacency_matrix[3][i] <= 1'b0; 
                    adjacency_matrix[4][i] <= 1'b0; 
                    adjacency_matrix[5][i] <= 1'b0; 
                    adjacency_matrix[6][i] <= 1'b0; 
                    adjacency_matrix[7][i] <= 1'b0; 
                    adjacency_matrix[8][i] <= 1'b0; 
                    adjacency_matrix[9][i] <= 1'b0; 
                    adjacency_matrix[10][i] <= 1'b0; 
                    adjacency_matrix[11][i] <= 1'b0; 
                    adjacency_matrix[12][i] <= 1'b0; 
                    adjacency_matrix[13][i] <= 1'b0; 
                    adjacency_matrix[14][i] <= 1'b0; 
                    adjacency_matrix[15][i] <= 1'b0; 
                end
                else begin
                    adjacency_matrix[0][source_input] <= 1'b0; 
                    adjacency_matrix[1][source_input] <= 1'b0; 
                    adjacency_matrix[2][source_input] <= 1'b0; 
                    adjacency_matrix[3][source_input] <= 1'b0; 
                    adjacency_matrix[4][source_input] <= 1'b0; 
                    adjacency_matrix[5][source_input] <= 1'b0; 
                    adjacency_matrix[6][source_input] <= 1'b0; 
                    adjacency_matrix[7][source_input] <= 1'b0; 
                    adjacency_matrix[8][source_input] <= 1'b0; 
                    adjacency_matrix[9][source_input] <= 1'b0; 
                    adjacency_matrix[10][source_input] <= 1'b0; 
                    adjacency_matrix[11][source_input] <= 1'b0; 
                    adjacency_matrix[12][source_input] <= 1'b0; 
                    adjacency_matrix[13][source_input] <= 1'b0; 
                    adjacency_matrix[14][source_input] <= 1'b0; 
                    adjacency_matrix[15][source_input] <= 1'b0; 
                end
            end 
            
        endcase
        end
 end


//==============================================//
//              Calculation Block               //
//==============================================//
//pass_flag
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin 
       pass_flag <= 0;
    end
    else if(cstate == IDLE)begin
        pass_flag <= 0;
    end
    else if (adjacency_matrix[source_input][destination_input])begin
          pass_flag <= 1;
    end
    
    else begin
        pass_flag <= pass_flag;
    end
end
//zero_flag
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin 
       zero_flag <= 0;
    end
    else if(cstate == IDLE)begin
        zero_flag <= 0;
    end
    else if ((cstate == ITERATION1)&&(i==15)&&(!road_flag))begin
        if(queue[1] == 5'd31)
            zero_flag <= 1;    
    end
    
    else begin
        zero_flag <= zero_flag;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // reset
        i_reg <= 5'b0 ;
    end
    else if(cstate == IDLE)begin
        i_reg <= 5'b0;
    end
    else if (cstate == ITERATION1) begin
        if(i_reg == 5'd17) begin
            i_reg<=5'b0;
        end
        else begin
            i_reg <= i_reg+1 ;
        end
    end
    else begin
        i_reg <= 5'b0;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // reset
        i <= 0 ;

    end
    else if (cstate == ITERATION1) begin
        i <= i_reg;
    end
    else begin
        i <= 0 ;
    end
end


//==============================================//
//                Queue                         //
//==============================================//
assign road_flag = (i==5'd16)?0:adjacency_matrix[node][i];
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // reset
        node <= 0 ;

    end
    else if (cstate == IDLE) begin
        node <= 0 ;
    end
    else if(cstate == ACC)begin
        node <= source_input ;
    end
    else if (cstate == ITERATION1)
        node <= queue[0];
    else if(cstate == UPDATE)
        node <= queue[0];
    else begin
        node <= node;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // reset
        pointer <= 0 ;

    end
    else if (cstate == IDLE) begin
        pointer <= 0 ;
    end
    else if (cstate == ACC) begin
        pointer <= 1 ;
    end
    else if (cstate == ITERATION1)begin
        if (i==17)
            pointer <= pointer - 1;
        else if(road_flag)
            pointer <= pointer + 1;
    end
    else if(cstate == UPDATE) begin
        if(pointer == 1)begin
            pointer <= pointer;
        end
        else begin
            pointer <= pointer - 1;
            end
            
    end
    else begin
        pointer <= pointer;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // reset
        for(j=0;j<17;j=j+1)
            queue[j] <= 5'd31 ;

    end
    else if (cstate == IDLE) begin
        for(j=0;j<17;j=j+1)
            queue[j] <= 5'd31 ;
    end
    else if(cstate == ACC) begin
            queue[0] <= source_input;
    end
    else if(cstate== ITERATION1)  begin
            if((i==16) && (number_reg != 0))begin
                for(j=1;j<17;j=j+1)
                    queue[j-1]<=queue[j];
            end
            else if(road_flag)begin
                queue[pointer] <= i;
            end
            
    end
    else if(cstate == UPDATE)begin
            for(j=1;j<17;j=j+1)
                queue[j-1]<=queue[j];
    end
    else begin
        for(j=0;j<16;j=j+1)
                queue[j]<=queue[j];
    end
end
//number
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // reset
        number <= 0 ;

    end
    else if (cstate ==IDLE) begin
        number <= 0 ;
    end
    
    else if(cstate == ITERATION1)begin
        if(road_flag)
            number <= number + 1 ;
    end
    else if(cstate == UPDATE)
            number <= 0;
    else 
            number <= number;
end
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // reset
        number_reg <= 0 ;

    end
    else if (cstate ==IDLE) begin
        number_reg <= 0 ;
    end
    else if(cstate == ACC)begin
        number_reg <= 1;
    end
    else if(cstate == ITERATION1) begin
        if(i==15)begin
            number_reg <= number_reg -1;
            end
        end
    else if(cstate == UPDATE)begin
        number_reg <= number ;
    end
    
end


//==============================================//
//           Iteration1 counter                  //
//==============================================//

//assign find = (i[3:0]==destination_input)? ;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // reset
        find_flag <= 0 ;

    end
    else begin
        if (cstate == IDLE) begin
            find_flag <= 0 ;
        end
        else if(cstate == ITERATION1)begin
            if(road_flag && (i[3:0]==destination_input))begin
                find_flag <= 1 ;
            end
            else 
                find_flag <= 0;
        end
        else begin
            find_flag <= find_flag;
        end
    end
end

//==============================================//
//                Output Block                  //
//==============================================//

always@(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        out_valid <= 0; /* remember to reset */
        end
    else if(nstate == OUT)begin
        out_valid <= 1;
    end
    else if(cstate == OUTPUT)begin
        out_valid <= 1;
    end
    else if(cstate == OUTPUT_ZERO) begin
        out_valid <= 1;
    end
    else begin
        out_valid <= 0;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // reset
        counter <= 1 ;

    end
    else if (cstate == IDLE) begin
        counter <= 1 ;
    end
    else if(cstate == UPDATE)begin
        counter <= counter + 1 ;
    end
    else begin
        counter <= counter ;
    end
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cost <= 0; /* remember to reset */
    else if(nstate == OUT)begin
        cost <= 1;
    end
    else if(cstate == OUTPUT)begin
        if(counter == 2)
            cost <= 4'd2;
        else
            cost <= counter;
        
    end
    else begin
        cost <= 0;
    end
end 

endmodule 