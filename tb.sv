`timescale 1ns/1ps

module tb_ctrl_oven ();
    localparam PERIOD        = 20;


//Inputs
    logic clk       ;
    logic reset     ;
    logic half_power;
    logic full_power;
    logic start     ;
    logic s30       ;
    logic s60       ;
    logic s120      ;
    logic time_set  ;
    logic door_open ;
 `ifndef TOP_TB
    logic timeout   ;
 `endif
// Outputs
    logic full       ;
    logic half       ;
    logic finished   ;
    logic in_light   ;
 `ifndef TOP_TB 
    logic start_count;
    logic stop_count ;
 `endif

    `ifdef TOP_TB
        top my_top (.*);   
    `else
        ctrl_oven my_ctrl_oven (.*);
        int        emulate_count = 0 ;
        int        time_chosen   = 0 ;
    `endif





//   ██████╗██╗      ██████╗  ██████╗██╗  ██╗██╗███╗   ██╗ ██████╗
//  ██╔════╝██║     ██╔═══██╗██╔════╝██║ ██╔╝██║████╗  ██║██╔════╝
//  ██║     ██║     ██║   ██║██║     █████╔╝ ██║██╔██╗ ██║██║  ███╗
//  ██║     ██║     ██║   ██║██║     ██╔═██╗ ██║██║╚██╗██║██║   ██║
//  ╚██████╗███████╗╚██████╔╝╚██████╗██║  ██╗██║██║ ╚████║╚██████╔╝
//   ╚═════╝╚══════╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝


    default clocking cb @(posedge clk);
    endclocking

        clocking cb_n @(negedge clk);
    endclocking

        always
            begin
                #(PERIOD/2.0);
                clk = ~clk;
            end


//  ███████╗██╗   ██╗███╗   ██╗ ██████╗████████╗██╗ ██████╗ ███╗   ██╗███████╗
//  ██╔════╝██║   ██║████╗  ██║██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
//  █████╗  ██║   ██║██╔██╗ ██║██║        ██║   ██║██║   ██║██╔██╗ ██║███████╗
//  ██╔══╝  ██║   ██║██║╚██╗██║██║        ██║   ██║██║   ██║██║╚██╗██║╚════██║
//  ██║     ╚██████╔╝██║ ╚████║╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║███████║
//  ╚═╝      ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝


        /* Sets the power mode
        1 (default) : Full power mode
        0           : Half power mode
        */
        function void set_power(input logic on = 1);
            begin
                if (on) begin
                    full_power = 1;
                    half_power = 0;
                end else begin
                    full_power = 0;
                    half_power = 1;
                end
            end
        endfunction
        /* Sets the time :
        0 (default) : s30 is chosen
        1           : s60 is chosen
        2           : s120 is chosen
        3           : not supported
        */
        function void set_time(input logic[1:0] time_mode = 0);
            begin
                case (time_mode)
                    2'b00 :
                        begin
                            s30 = 1;
                            s60 = 0;
                            s120= 0;
                            time_set = 1;
                            `ifndef TOP_TB
                            time_chosen = 30;
                            `endif
                        end
                    2'b01 :
                        begin
                            s30 = 0;
                            s60 = 1;
                            s120= 0;
                            time_set = 1;
                            `ifndef TOP_TB
                            time_chosen = 60;
                            `endif
                        end
                    2'b10 :
                        begin
                            s30 = 0;
                            s60 = 0;
                            s120= 1;
                            time_set = 1;
                            `ifndef TOP_TB
                            time_chosen = 120;
                            `endif
                        end
                    default :
                        begin
                            $display("Resetting time selections at %0d",$time);
                            s30 = 0;
                            s60 = 0;
                            s120= 0;
                            time_set = 0;
                        end
                endcase
            end
        endfunction



        /* Open or closes the door by inverting current value */
        function void open_close_door(logic in = 0);
            begin
                if (in) begin
                    door_open = 1;
                    $display("Door has been opened at %0d",$time);
                end else begin 
                    door_open = 0;
                    $display("Door has been closed at %0d",$time);
                end
            end
        endfunction


        /* resets  power,start,time and door state */
        function void drive_almost_every_input_to_zero();
            begin
                set_time(3);
                start=0;
                full_power  = 0;
                half_power  = 0;
                door_open   = 0;
            end
        endfunction : drive_almost_every_input_to_zero
        /* Stalls for N clk cycles */

        task stall(input int N = 1);
            begin
                @(cb_n); // This ensures I actually get at least one clk cycle from this task
                repeat (N) @(cb);
            end
        endtask : stall

        /* Initialises inputs and calls async reset for one clk cycle */
        task init();
            begin
                clk       = 0  ;
                half_power= 0  ;
                full_power= 0  ;
                start     = 0  ;
                s30       = 0  ;
                s60       = 0  ;
                s120      = 0  ;
                time_set  = 0  ;
                door_open = 0  ;
                reset       = 0;
                `ifndef TOP_TB
                time_chosen = 0;
                `endif
                reset_p();
            end
        endtask : init

        /* drives reset high for one clock period */
        task reset_p();
            begin
                @(cb);
                reset     = 1  ;
                `ifndef TOP_TB
                emulate_count = 0;
                `endif
                @(cb);
                reset     = 0  ;
            end
        endtask : reset_p

 `ifndef TOP_TB
        /* This process emulates how the counter oven will work */
        always
        begin
            timeout = 0;

            @(start_count == 1);

            while(!stop_count ) // emulate_count == time_chosen
                begin
                    if(emulate_count != time_chosen)
                        @(cb) emulate_count++;
                    else
                        @(cb) break; 
                end

            if (emulate_count == time_chosen && time_chosen != 0)
                begin
                    timeout       = 1;
                    emulate_count = 0;
                end
            @(cb);
        end
 `endif

// TODO : improve your sequence  using your function stall

    /* TEST 1 : FULL POWER -> S30(SET_TIME) -> OP_ENABLED -> OP_DISABLED -> OP_ENABLED -> OPERATING -> COMPLETE */
    task sequence_one();
        begin
            set_power(1);
            @(full);
            set_time(0);
            stall(5);
            open_close_door(1);
            @(in_light);
            open_close_door(0);
            start = 1;
            `ifdef SYNTHESIS
               @(finished);
               @(cb_n);
               if (!finished) begin
                   @(finished);
               end
            `else 
                @(finished);
            `endif 
            stall(1);
            open_close_door(1);
            $display("Test 1 ended at %0d",$time);
            stall(1);
            open_close_door(0);
        end
    endtask : sequence_one


    /*  TEST 2 : HALF POWER -> S60(SET_TIME) -> DISABLED -> ENABLED -> OPERATING -> COMPLETE */
    task sequence_two();
        begin
            set_power(0);
            @(half);
            set_time(1);
            open_close_door(1);
            @(in_light);
            open_close_door(0);
            start = 1;
            `ifdef SYNTHESIS
               @(finished);
               @(cb_n);
               if (!finished) begin
                   @(finished);
               end
            `else 
                @(finished);
            `endif 
            stall(1);
            open_close_door(1);
            $display("Test 2 ended at %0d",$time);
            stall(1);
            open_close_door(0);
        end
    endtask : sequence_two



    /* TEST 3 : FULL POWER -> HALF POWER -> FULL POWER -> S120 -> ENABLED -> OPERATING -> DISABLED -> ENABLED -> OPERATING -> COMPLETE */
    task sequence_three();
        begin
            set_power(1);
            @(full);
            set_power(0);
            @(half);
            set_power(1);
            @(full);
            set_time(2);
            start = 1;
            repeat (10) @(cb); // After 10 clock cycles, open the door
            @(cb_n) open_close_door(1);
            repeat (10) @(cb); // Close the door after 10 clock cycles
            open_close_door(0);
            `ifdef SYNTHESIS
               @(finished);
               @(cb_n);
               if (!finished) begin
                   @(finished);
               end
            `else 
                @(finished);
            `endif 
            repeat (2) @(cb); // Stall to make transistion complete - complete
            open_close_door(1);
            $display("Test 3 ended at %0d",$time);
            stall(1);
            open_close_door(0);
        end
    endtask : sequence_three

    /*TEST 4 : Reset while counter stopped */
    task sequence_four();
        begin
            set_power(1);
            @(full);
            set_time(2);
            start = 1;
            stall(10);// After 10 clock cycles, open the door
            open_close_door(1);
            stall(10); // Close the door after 10 clock cycles
            reset_p();
            $display("Test 4 ended at %0d",$time);
        end
    endtask : sequence_four


    /* TEST 5 : Reset while state = op enabled */
    task sequence_five();
        begin
            set_power(1);
            @(full);
            set_time(0);
            stall(5);
            reset_p();
            $display("Test 5 ended at %0d",$time);
        end
    endtask : sequence_five


    /* TEST 6 :Half to half to reset */
    task sequence_six();
        begin
            set_time(3);
            set_power(0);
            stall(2);
            reset_p();
            $display("Test 6 ended at %0d",$time);
        end
    endtask : sequence_six

    /* TEST 7 : Reset while State = Operating */
    task sequence_seven();
        begin
            set_power(1);
            @(full);
            set_time(1);
            start = 1;
            @(in_light);
            stall();
            reset_p();
            $display("Test 7 ended at %0d",$time);
        end
    endtask : sequence_seven

    /* TEST 8 : Reset while State = OP_DISABLED */
    task sequence_eight();
        begin
            set_power(0);
            @(half);
            set_time(1);
            start = 1;
            open_close_door(1);
            @(in_light);
            reset_p();
            $display("Test 8 ended at %0d",$time);
        end
    endtask : sequence_eight

    task sequence_();
        begin
        end
    endtask : sequence_

//  ████████╗███████╗███████╗████████╗███████╗
//  ╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝██╔════╝
//     ██║   █████╗  ███████╗   ██║   ███████╗
//     ██║   ██╔══╝  ╚════██║   ██║   ╚════██║
//     ██║   ███████╗███████║   ██║   ███████║
//     ╚═╝   ╚══════╝╚══════╝   ╚═╝   ╚══════╝


    initial
        begin
            init();
            sequence_one();
            drive_almost_every_input_to_zero();
            stall(2);
            sequence_two();
            drive_almost_every_input_to_zero();
            stall(2);
            sequence_three();
            drive_almost_every_input_to_zero();
            stall(2);
            sequence_four();
            drive_almost_every_input_to_zero();
            stall(2);
            sequence_five();
            drive_almost_every_input_to_zero();
            stall(2);
            sequence_six();
            drive_almost_every_input_to_zero();
            stall(2);
            sequence_seven();
            drive_almost_every_input_to_zero();
            stall(2);
            sequence_eight();
            drive_almost_every_input_to_zero();
            stall(2);
           
            // TEST : edge cases to drive the coverage from 98 to 100
            set_time(3);
            repeat (2) @(cb);
            set_power(0);
            @(cb);
            reset_p();
            set_power(1);
            @(cb);
            reset_p();
            set_power(1);
            @(full);
            set_time(0);
            time_set = 0;
            repeat(5) @(cb);
            reset_p();
             
            $finish;
        end
        endmodule
