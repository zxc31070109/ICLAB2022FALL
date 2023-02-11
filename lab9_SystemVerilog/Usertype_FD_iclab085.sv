//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   2022 ICLAB Fall Course
//   Lab09      : FD
//   Author     : Po-Kang Chang
//                
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : Usertype_FD.sv
//   Module Name : usertype
//   Release version : v1.0 (Release Date: Nov-2022)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

`ifndef USERTYPE
`define USERTYPE

package usertype;

typedef enum logic  [3:0] { No_action	        = 4'd0,
                            Take		        = 4'd1,
							Deliver		        = 4'd2,
							Order   		    = 4'd4, 
							Cancel   	        = 4'd8 
							}  Action ;
							
typedef enum logic  [3:0] { No_Err       		= 4'b0000, //No error
                            No_Food             = 4'b0001, //No food
							D_man_busy          = 4'b0010, //Delivery man busy
						    No_customers	    = 4'b0100, //No customers  
							Res_busy	        = 4'b1000, //Restaurant is busy
							Wrong_cancel        = 4'b1010, //Wrong cancel
							Wrong_res_ID        = 4'b1011, //Wrong Restaurant ID
							Wrong_food_ID       = 4'b1100  //Wrong Food ID
							}  Error_Msg ;

typedef enum logic  [1:0]	{ None              = 2'b00,
							Normal      	    = 2'b01,
							VIP                 = 2'b11
							}  Customer_status ;				

typedef enum logic  [1:0] { No_food      	    = 2'd0,
							FOOD1	       	    = 2'd1,
							FOOD2       	    = 2'd2,
							FOOD3 			    = 2'd3
							}  Food_id ;


typedef logic [7:0] Delivery_man_id;
typedef logic [7:0] Restaurant_id;
typedef logic [3:0] servings_of_food; 
typedef logic [7:0] limit_of_orders;
typedef logic [7:0] servings_of_FOOD; 

typedef struct packed {
    Customer_status		ctm_status; //Customer status // 2bits
	Restaurant_id   	res_ID;     //restaurant ID   // 8bits
	Food_id				food_ID;    //food ID 		  // 2bit
	servings_of_food    ser_food;   //servings of food// 4bits
} Ctm_Info; //Customer info

typedef struct packed {
	Ctm_Info 	ctm_info1; //customer1 info
	Ctm_Info 	ctm_info2; //customer2 info
} D_man_Info; //Delivery man info

typedef struct packed {
	limit_of_orders		limit_num_orders; //limit of total number of orders
	servings_of_FOOD	ser_FOOD1; //Servings of FOOD1
	servings_of_FOOD	ser_FOOD2; //Servings of FOOD2
	servings_of_FOOD	ser_FOOD3; //Servings of FOOD3	
} res_info; //restaurant info

typedef struct packed {
	Food_id				d_food_ID;    //food ID           // 2bit
	servings_of_food    d_ser_food;   //servings of food  // 4bits
} food_ID_servings; //food ID & servings of food

typedef union packed{ 
	Delivery_man_id		[5:0]	d_id;		    //8*6
    Action		    	[11:0]	d_act;			//4*12
	Ctm_Info        	[2:0]	d_ctm_info;     //16*3
	Restaurant_id		[5:0]   d_res_id;       //8*6
	food_ID_servings	[7:0]   d_food_ID_ser;  //6*8 =48
} DATA;

//################################################## Don't revise the code above

//#################################
// Type your user define type here
//#################################


typedef struct packed {
 D_man_Info golden_d_man_info;
 res_info   golden_res_info;
} OUT_INFO;


//################################################## Don't revise the code below
endpackage
import usertype::*; //import usertype into $unit

`endif

