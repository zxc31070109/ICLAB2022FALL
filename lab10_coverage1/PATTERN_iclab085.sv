`include "../00_TESTBED/pseudo_DRAM.sv"
`include "Usertype_FD.sv"

program automatic PATTERN(input clk, INF.PATTERN inf);
import usertype::*;


//================================================================
//      PARAMETERS FOR PATTERN CONTROL
//================================================================

parameter DRAM_OFFSET = 'h10000;
parameter USER_NUM    = 256;
parameter DRAM_p_r    = "../00_TESTBED/DRAM/dram.dat";
integer   SEED         = 152;
parameter PAT_NUM = 500;
//================================================================
//      Declare data
//================================================================

typedef enum {
    id,
    action,
    cus,
    r_id,
    food
} flag;
Action cur_action,last_action;
Delivery_man_id last_del,cur_del;
Ctm_Info last_cus,cur_cus;
Restaurant_id last_res,cur_res;
food_ID_servings last_food,cur_food;
//================================================================
//      PARAMETERS & VARIABLES
//================================================================

integer i;
integer lat,out_lat,pat;
integer d_id_counter;
integer count;
//================================================================
//      CLASS RANDOM
//================================================================
class random_id;
        randc Delivery_man_id rand_id;
        constraint range{
            rand_id inside{[0:255]};
        }
endclass

class random_act;
        rand Action rand_act;
        constraint range{
            rand_act inside{Take,Order,Deliver,Cancel};
        }
endclass
//custom
class random_ctm;
        rand Ctm_Info rand_ctm;
        constraint range{
            rand_ctm.ctm_status inside{Normal,VIP}; //2
            rand_ctm.res_ID inside {[0:255]};
            rand_ctm.food_ID inside {FOOD1,FOOD2,FOOD3};
            rand_ctm.ser_food inside {[1:15]};
        }
endclass

//rest
class random_res_id;
        randc Restaurant_id rand_res_id;
        constraint range{
            rand_res_id inside{[0:255]};
        }
endclass
class servFood_R;
    rand food_ID_servings rand_ser_food;
    constraint range{
        rand_ser_food.d_food_ID  inside { FOOD1, FOOD2, FOOD3 };
        rand_ser_food.d_ser_food inside { [1:15] };
    }
endclass
//==========
//     DRAM
//==========
class dramData;
    logic [7:0] golden_DRAM[ (DRAM_OFFSET+0) : ((DRAM_OFFSET+USER_NUM*8)-1) ];
    logic flag;
    function new();
        $readmemh( DRAM_p_r, golden_DRAM );
    endfunction

	function D_man_Info get_del_man(Delivery_man_id d_id);
        D_man_Info d_out;
        {d_out.ctm_info1,flag} = {golden_DRAM[ (DRAM_OFFSET+d_id*8+4) ],golden_DRAM[ (DRAM_OFFSET+d_id*8+5) ],1'b1};
        {d_out.ctm_info2,flag} = {golden_DRAM[ (DRAM_OFFSET+d_id*8+6) ],golden_DRAM[ (DRAM_OFFSET+d_id*8+7) ],1'b1};
        return d_out;
    endfunction

    function set_del_man(Delivery_man_id d_id, D_man_Info d_info);
        {golden_DRAM[ (DRAM_OFFSET+d_id*8+4) ], golden_DRAM[ (DRAM_OFFSET+d_id*8+5) ]} = d_info.ctm_info1;
        {golden_DRAM[ (DRAM_OFFSET+d_id*8+6) ], golden_DRAM[ (DRAM_OFFSET+d_id*8+7) ]} = d_info.ctm_info2;
    endfunction


    function res_info get_rest_info(Restaurant_id rest_id);
    	res_info rest_out;
    	{rest_out.limit_num_orders,flag}={golden_DRAM[ (DRAM_OFFSET+rest_id*8) ]  ,1'b1};
    	{rest_out.ser_FOOD1       ,flag}={golden_DRAM[ (DRAM_OFFSET+rest_id*8+1) ],1'b1};
    	{rest_out.ser_FOOD2       ,flag}={golden_DRAM[ (DRAM_OFFSET+rest_id*8+2) ],1'b1};
    	{rest_out.ser_FOOD3       ,flag}={golden_DRAM[ (DRAM_OFFSET+rest_id*8+3) ],1'b1};
    	return rest_out;
    endfunction 

    function set_rest_info(res_info rest_in,Restaurant_id rest_id);
    	 {golden_DRAM[ (DRAM_OFFSET+rest_id*8) ]  ,flag} = {rest_in.limit_num_orders,1'b0};
    	 {golden_DRAM[ (DRAM_OFFSET+rest_id*8+1) ],flag} = {rest_in.ser_FOOD1,1'b0};
    	 {golden_DRAM[ (DRAM_OFFSET+rest_id*8+2) ],flag} = {rest_in.ser_FOOD2,1'b0};
    	 {golden_DRAM[ (DRAM_OFFSET+rest_id*8+3) ],flag} = {rest_in.ser_FOOD3,1'b0};
  	endfunction 


  endclass 



class execution;
    dramData DRAM_r;
    Action act;
    //golden
    logic golden_complete;
    Error_Msg golden_err;
    logic [63:0] golden_info;
    //current data
    logic cur_complete;
    Error_Msg cur_err;
    logic [63:0] cur_info;
    //deliver
    Delivery_man_id del_id;
    D_man_Info golden_del;
    D_man_Info cur_del;
    //restaurant
    
    res_info golden_rest;
    res_info cur_rest;


    function  new();
        DRAM_r = new();
        act = No_action;
        golden_complete=0;
        golden_err=No_Err;
        golden_info=0;
        cur_complete=0;
        cur_err=No_Err;
        cur_info=0;
        del_id=0;
        golden_del=0;
        cur_del=0;
        golden_rest=0;
        cur_rest=0;
    endfunction : new


    function  set_cur(logic cur_complete_ns,Error_Msg cur_err_ns,logic [63:0] cur_info_ns);
        cur_complete     = cur_complete_ns;
        cur_err          = cur_err_ns;
        cur_info         = cur_info_ns;
    endfunction
    function bit comp();
        if((golden_complete===cur_complete) && (golden_err===cur_err) && (golden_info===cur_info))begin
            return 1;
        end
        else return 0;
    endfunction 

    function  getDman(Delivery_man_id d_id);
        golden_del = DRAM_r.get_del_man(d_id);
        cur_del    = golden_del;
    endfunction 
    function  getRest(Restaurant_id rest_id);
        golden_rest = DRAM_r.get_rest_info(rest_id);
        cur_rest    = golden_rest;
    endfunction

    


    //Take dman_busy No_food
    function  take(Delivery_man_id d_id,Ctm_Info cus_in);
        void'(getDman(d_id));
        void'(getRest(cus_in.res_ID));

        if(cur_del.ctm_info2.ctm_status !== 0 )begin
            golden_complete     = 0 ;
            golden_err          = D_man_busy;
            golden_info         = 0;
        end
        else if(cus_in.food_ID == FOOD1 && golden_rest.ser_FOOD1 < cus_in.ser_food)begin
            golden_complete     = 0 ;
            golden_err          = No_Food;
            golden_info         = 0;
        end
        else if(cus_in.food_ID == FOOD2 && golden_rest.ser_FOOD2 < cus_in.ser_food)begin
            golden_complete     = 0 ;
            golden_err          = No_Food;
            golden_info         = 0;
        end
        else if(cus_in.food_ID == FOOD3 && golden_rest.ser_FOOD3 < cus_in.ser_food)begin
            golden_complete     = 0 ;
            golden_err          = No_Food;
            golden_info         = 0;
        end
        else begin

            golden_complete     = 1  ;
            golden_err          = No_Err;
            //deliver
            if(cur_del.ctm_info1.ctm_status == Normal)begin
                if(cus_in.ctm_status == VIP)begin
                    cur_del.ctm_info2 = cur_del.ctm_info1;
                    cur_del.ctm_info1 = cus_in;
                end
                else begin
                    cur_del.ctm_info1 = cur_del.ctm_info1;
                    cur_del.ctm_info2 = cus_in;
                end

            end
            else if (cur_del.ctm_info1.ctm_status == None)begin
                cur_del.ctm_info1 = cus_in;
                cur_del.ctm_info2 = cur_del.ctm_info2;
            end
            else begin
                cur_del.ctm_info1 = cur_del.ctm_info1;
                cur_del.ctm_info2 = cus_in;
            end
            //restuarant
            if(cus_in.food_ID == FOOD1) 
                cur_rest.ser_FOOD1 -= cus_in.ser_food;
            if(cus_in.food_ID == FOOD2) 
                cur_rest.ser_FOOD2 -= cus_in.ser_food;
            if(cus_in.food_ID == FOOD3) 
                cur_rest.ser_FOOD3 -= cus_in.ser_food;
            //Write back to dram
            void'(DRAM_r.set_del_man(d_id,cur_del));
            void'(DRAM_r.set_rest_info(cur_rest,cus_in.res_ID));
            golden_info  = {cur_del,cur_rest};
            
        end
       //void'(set_golden(golden_complete, golden_err, golden_info));
    endfunction 

    //Order
    function void order(Restaurant_id res_id_in,food_ID_servings food_in);
        void'(getRest(res_id_in));
        //restaurant busy
        if(food_in.d_ser_food >  (golden_rest.limit_num_orders)-(golden_rest.ser_FOOD1 + golden_rest.ser_FOOD2 + golden_rest.ser_FOOD3 ))begin
            golden_complete     = 0 ;
            golden_err          = Res_busy;
            golden_info         = 0;
        end
        else begin
            golden_complete     = 1 ;
            golden_err          = No_Err;
            if(food_in.d_food_ID == FOOD1) cur_rest.ser_FOOD1 += food_in.d_ser_food;
            if(food_in.d_food_ID == FOOD2) cur_rest.ser_FOOD2 += food_in.d_ser_food;
            if(food_in.d_food_ID == FOOD3) cur_rest.ser_FOOD3 += food_in.d_ser_food;
            void'(DRAM_r.set_rest_info(cur_rest,res_id_in));
            golden_info  = {32'd0,cur_rest};
        end
        //void'(set_golden(golden_complete, golden_err, golden_info));
    endfunction 

    //Deliver
    function void deliver(Delivery_man_id d_id);
        void'(getDman(d_id));
        //No customer
        if(golden_del.ctm_info1 === 0 && golden_del.ctm_info2 === 0)begin
            golden_complete     = 0 ;
            golden_err          = No_customers;
            golden_info         = 0;
        end
        else begin
            if(golden_del.ctm_info2 !== 0) begin
                cur_del.ctm_info1 = cur_del.ctm_info2;
                cur_del.ctm_info2 = 0;
            end
            else begin
                cur_del.ctm_info1 = 0;
                cur_del.ctm_info2 = 0;
            end
            golden_complete     = 1 ;
            golden_err          = No_Err;
            golden_info         = {cur_del,32'b0};
            void'(DRAM_r.set_del_man(d_id,cur_del));
        end
    endfunction 

    function void cancel(Delivery_man_id d_id ,  Restaurant_id rest_id , food_ID_servings food_in);
        void'(getDman(d_id));
        void'(getRest(rest_id));
        //Wrong cancel
        if(cur_del.ctm_info1 === 0 && cur_del.ctm_info2 === 0)begin
            golden_complete     = 0 ;
            golden_err          = Wrong_cancel;
            golden_info         = 0;
        end
       
        
        else if((cur_del.ctm_info1.res_ID !== rest_id) && (cur_del.ctm_info2.res_ID !== rest_id))begin // 66 & 199
            golden_complete     = 0 ;
            golden_err          = Wrong_res_ID;
            golden_info         = 0;
        end
        else if(  (cur_del.ctm_info1.res_ID === rest_id) && (cur_del.ctm_info1.food_ID !== food_in.d_food_ID) &&
                  (cur_del.ctm_info2.res_ID === rest_id) && (cur_del.ctm_info2.food_ID !== food_in.d_food_ID)
                )begin
            golden_complete     = 0 ;
            golden_err          = Wrong_food_ID;
            golden_info         = 0;        
        end
        else if(  (cur_del.ctm_info1.res_ID !== rest_id) &&
                  (cur_del.ctm_info2.res_ID === rest_id) && (cur_del.ctm_info2.food_ID !== food_in.d_food_ID)
                )begin
            golden_complete     = 0 ;
            golden_err          = Wrong_food_ID;
            golden_info         = 0;        
        end
        else if(  (cur_del.ctm_info2.res_ID !== rest_id) &&
                  (cur_del.ctm_info1.res_ID === rest_id) && (cur_del.ctm_info1.food_ID !== food_in.d_food_ID)
                )begin
            golden_complete     = 0 ;
            golden_err          = Wrong_food_ID;
            golden_info         = 0;        
        end
        else begin
            if(cur_del.ctm_info1.res_ID === rest_id  && cur_del.ctm_info2.res_ID === rest_id && cur_del.ctm_info1.food_ID == food_in.d_food_ID && cur_del.ctm_info2.food_ID == food_in.d_food_ID)begin
                golden_complete     = 1 ;
                golden_err          = No_Err;
                cur_del = 0;
                golden_info         = {32'd0,32'd0}; 
            end
            else if(cur_del.ctm_info1.res_ID === rest_id  && cur_del.ctm_info1.food_ID == food_in.d_food_ID )begin
                golden_complete     = 1 ;
                golden_err          = No_Err;
                cur_del.ctm_info1 = cur_del.ctm_info2;
                cur_del.ctm_info2 = 0;
                golden_info         = {cur_del,32'd0}; 
            end
            else if(cur_del.ctm_info2.res_ID === rest_id && cur_del.ctm_info2.food_ID == food_in.d_food_ID )begin
                golden_complete     = 1 ;
                golden_err          = No_Err;
                cur_del.ctm_info2 = 0;
                golden_info         = {cur_del,32'd0}; 
            end
            void'(DRAM_r.set_del_man(d_id,cur_del));
        end

    endfunction 
endclass 
//======================================
//              MAIN
//======================================
execution exe = new();
initial begin
    execution_task;
end


//======================================
//              TASKS
//======================================
task execution_task; begin

    reset_task;
    for(pat=0;pat<PAT_NUM;pat=pat+1)begin
        input_task;
        wait_task;
        check_task;
        //if(exe.golden_err == Wrong_food_ID)begin
        //    $display("\033[1;35m  ====================================================================\033[m");
        //    $display("\033[1;35m  pass %5d ,action= %10s ,err_msg :%10s\033[m",pat,cur_action.name(),exe.golden_err.name()  );
        //    $display("\033[1;35m  ====================================================================\033[m");
        //end
        //else
        //    $display("\033[1;35m  pass %5d ,action= %10s ,err_msg :%10s\033[m",pat,cur_action.name(),exe.golden_err.name()); 

        //$display("pass");
    end
    //$display("\033[1;35m PASS ! \033[m");
    $finish;
    end
endtask
//===========================================================================================================
//   RESET      
//===========================================================================================================
task reset_task ; begin
    inf.rst_n = 1;
    inf.id_valid   = 0;
    inf.act_valid  = 0;
    inf.cus_valid  = 0;
    inf.res_valid  = 0;
    inf.food_valid = 0;
    inf.D          = 'dx;
    out_lat = 0;
    d_id_counter = 0;
    count =0;
    #(0.5);
    inf.rst_n = 0;
    #(1);
    if ( inf.out_valid !== 0 || inf.complete !== 0 || inf.err_msg !== 0 || inf.out_info !== 0 ) begin
        $display("Wrong Answer");
        $finish;
    end
    #(5.5); inf.rst_n = 1 ;
end endtask

//=========
//   Input    
//=========
task input_data;
input flag  in ;
begin
    inf.D = 0;
    if(in == action)begin
        inf.D = cur_action;
    end
    else if(in == id)begin
        inf.D = cur_del;
    end 
    else if(in == cus)begin
        inf.D = cur_cus;
    end
    else if(in == r_id)begin
        inf.D = cur_res;
    end
    else if(in == food)begin
        inf.D = cur_food;
    end
    @(negedge  clk);
    inf.D = 'dx;
end
endtask 
task action_task; begin
    random_act randACT = new();

    inf.act_valid = 'd1;
    void'(randACT.randomize());
    last_action = cur_action;
    if(pat < 20) begin
        cur_action = Cancel;
    end
    else if(pat >=20 && pat <42)begin
        cur_action = Take;
    end
    else if(pat>=42 && pat <66)
        cur_action = Order;
    else
        cur_action = randACT.rand_act;
    end
endtask 
task del_task; begin
    
    inf.id_valid = 'd1;
    last_del = cur_del;
    cur_del = d_id_counter;//rid.rand_id;
    if(pat<20)begin
        d_id_counter = 0;
    end
    else 
        d_id_counter = d_id_counter + 1;
    end
endtask 

task cus_task; begin
    random_ctm cus_rand = new();
    Ctm_Info cus_me;
    cus_me.ctm_status = Normal;
    cus_me.res_ID = 1;
    cus_me.ser_food = 15;
    cus_me.food_ID = 1;
    inf.cus_valid = 'd1;
    void'(cus_rand.randomize());
    last_cus = cur_cus;
    if(pat>=20 && pat<42)
        cur_cus = cus_me;
    else
        cur_cus = cus_rand.rand_ctm;
    end
endtask 

task rest_task();begin
    random_res_id res_rand = new();
    inf.res_valid ='d1;
    void'(res_rand.randomize());
    last_res = cur_res;
    if(pat < 20 )
        cur_res = 0;
    else if(pat>=42 && pat <66)
        cur_res = 0;
    else
        cur_res = res_rand.rand_res_id;
end
endtask 


task food_task();begin
    servFood_R food_rand = new();
    inf.food_valid = 'd1;
    void'(food_rand.randomize());
    last_food = cur_food;
    cur_food = food_rand.rand_ser_food;
end
endtask 

task input_task();begin
    
    repeat( 1 ) @(negedge clk);
    action_task;
    input_data(action);
    inf.act_valid = 'd0;
    repeat( 1 ) @(negedge clk);


    // Take
    if(cur_action == Take)begin
        if(last_action !== Take) begin
            del_task;
            input_data(id);
            inf.id_valid = 'd0;
            repeat( 1 ) @(negedge clk);
            cus_task;
            input_data(cus);
            inf.cus_valid = 'd0;
        end
        else begin
            if(({$random(SEED)} % 2) == 1)begin

                del_task;
                input_data(id);
                inf.id_valid = 'd0;
                repeat( 1 ) @(negedge clk);
            end
            //$display("\033[1;35m  ================================if needed====================================\033[m");
            cus_task;
            input_data(cus);
            inf.cus_valid = 'd0;
        end
        
    end
    else if(cur_action == Order)begin
        if(last_action !== Order)begin
            rest_task;
            input_data(r_id);
            inf.res_valid ='d0;
            repeat( 1 ) @(negedge clk);
            food_task;
            input_data(food);
            inf.food_valid = 'd0;
        end
        else begin
            if(({$random(SEED)} % 2) == 1) begin
               
                rest_task;
                input_data(r_id);
                inf.res_valid ='d0;
                repeat( 1 ) @(negedge clk);
            end
            //$display("\033[1;35m  ================================if needed====================================\033[m");
            food_task;
            input_data(food);
            inf.food_valid = 'd0;
        end
    end
    else if(cur_action == Deliver)begin
        del_task;
        input_data(id);
        inf.id_valid = 'd0;
    end
    else if(cur_action == Cancel) begin
        rest_task;
        input_data(r_id);
        inf.res_valid = 'd0;
        repeat( 1 ) @(negedge clk);
        food_task;
        input_data(food);
        inf.food_valid = 'd0;
        repeat( 1 ) @(negedge clk);
        del_task;
        input_data(id);
        inf.id_valid = 'd0;
    end


    
    //Calculate
    if(cur_action == Take) exe.take(cur_del, cur_cus);
    else if(cur_action == Order) exe.order(cur_res, cur_food);
    else if(cur_action == Deliver) exe.deliver(cur_del);
    else if(cur_action == Cancel) exe.cancel(cur_del,cur_res,cur_food);
    if(exe.golden_err === 0)begin
        count = count + 1;
    end
end
endtask 

task wait_task();begin
     lat = -1;
    while( inf.out_valid !== 1)begin
        if(lat === 1200)begin
            $display("Wrong Answer");
            $finish;
        end
        lat = lat + 1;
        @(negedge clk);
    end
end
    
endtask : wait_task


task check_task();begin
    out_lat = 0;
    while (inf.out_valid === 1)begin
        if(out_lat === 1)begin
            $display("Wrong Answer");
            $finish;
        end
       
        exe.set_cur(inf.complete, inf.err_msg, inf.out_info);
        out_lat = out_lat + 1;
        @(negedge clk);
    end
    
    if(exe.comp() === 0)begin
        $display("Wrong Answer");
        //$display("golden_info:%16h , golden_complete: %b ,golden_err: %10s",exe.golden_info,exe.golden_complete,exe.golden_err.name());
        //$display("cur_info:%16h , cur_complete: %b ,cur_err: %10s",exe.cur_info,exe.cur_complete,exe.cur_err.name());
        $finish;
    end
    

end
    
endtask 



endprogram