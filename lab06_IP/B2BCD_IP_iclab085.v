//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   File Name   : B2BCD_IP.v
//   Module Name : B2BCD_IP
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

module B2BCD_IP #(parameter WIDTH = 4, parameter DIGIT = 2) (
    // Input signals
    Binary_code,
    // Output signals
    BCD_code
);

// ===============================================================
// Declaration
// ===============================================================
input  [WIDTH-1:0]   Binary_code; // 7 = W
output [DIGIT*4-1:0] BCD_code;    // 3 D=3

wire [DIGIT*4+1:0]line[0:WIDTH-4];
wire flag[0:WIDTH];
wire [DIGIT*4+1:0]in_data;
parameter B=(4*DIGIT)-WIDTH;  //

// ===============================================================
// Soft IP DESIGN
// =============================================================
assign in_data = Binary_code;////{{B{1'b0}},Binary_code};
genvar i,j,k;
assign line[0][WIDTH-4:0] = in_data[WIDTH-4:0];
assign flag[0]=1;
assign line[0][DIGIT*4+1:WIDTH+1] = in_data[DIGIT*4+1:WIDTH+1];
assign flag[WIDTH]=1;
assign {line[0][WIDTH-:4]} = ({in_data[WIDTH -: 4]} > 4'd4)? ({in_data[WIDTH -: 4]} +4'd3):({in_data[WIDTH -: 4]});
generate
    for(i=1;i<=(WIDTH-4);i=i+1)begin: loop_i
        for(j=0;j<=(i/3);j=j+1)begin: loop_j 
            assign {line[i][WIDTH-i+(i/3)*4-(4*j) -: 4]} = ( line[i-1][WIDTH-i+(i/3)*4-(4*j) -: 4] > 4'd4)? (line[i-1][WIDTH-i+(i/3)*4-(4*j) -: 4] +4'd3):(line[i-1][WIDTH-i+(i/3)*4-(4*j) -: 4]);
            assign flag[i]=1;
            assign line[i][WIDTH-4-i:0]=line[i-1][WIDTH-4-i:0];
            assign line[i][DIGIT*4+1:WIDTH-i+(i/3)*4+1] = line[i-1][DIGIT*4+1:WIDTH-i+(i/3)*4+1];
        end
    end
    
endgenerate
assign BCD_code = line[WIDTH-4];

endmodule