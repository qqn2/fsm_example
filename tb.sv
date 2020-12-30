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
        function void open_close_door();
            begin
                door_open = ~door_open;
                if (door_open)
                    $display("Door has been opened at %0d",$time);
                else
                    $display("Door has been closed at %0d",$time);
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
                        break;
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
            open_close_door();
            @(in_light);
            open_close_door();
            start = 1;
            @(finished);
            open_close_door();
            $display("Test 1 ended at %0d",$time);
            stall(1);
            open_close_door();
        end
    endtask : sequence_one
    /*  TEST 2 : HALF POWER -> S60(SET_TIME) -> DISABLED -> ENABLED -> OPERATING -> COMPLETE */
    task sequence_two();
        begin
            set_power(0);
            @(half);
            set_time(1);
            open_close_door();
            @(in_light);
            open_close_door();
            start = 1;
            @(finished);
            open_close_door();
            $display("Test 2 ended at %0d",$time);
            stall(2);
            open_close_door();
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
            @(cb_n) open_close_door();
            repeat (10) @(cb); // Close the door after 10 clock cycles
            open_close_door();
            @(finished);
            repeat (2) @(cb); // Stall to make transistion complete - complete
            open_close_door();
            $display("Test 3 ended at %0d",$time);
            stall(1);
            open_close_door();
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
            open_close_door();
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
            open_close_door();
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



`ifdef ASSERT_ON

    `ifdef SYNTHESIS_BINARY
        logic ctrl_CS[2:0] = {my_ctrl_oven.CS_2,my_ctrl_oven.CS_1,my_ctrl_oven.CS_0};
    `elsif SYNTHESIS_GREY
        logic ctrl_CS[2:0] = {my_ctrl_oven.CS_2,my_ctrl_oven.CS_1,my_ctrl_oven.CS_0};
    `elsif SYNTHESIS_ONEHOT
        logic ctrl_CS[7:0] = {my_ctrl_oven.finished,my_ctrl_oven.start_count,my_ctrl_oven.CS_5,my_ctrl_oven.CS_4,my_ctrl_oven.CS_3,my_ctrl_oven.half,my_ctrl_oven.full,my_ctrl_oven.CS_0};
    `endif

    `ifdef SYNTHESIS_BINARY
        logic CS_is_idle        = (ctrl_CS == 3'b000);
        logic CS_is_full_power  = (ctrl_CS == 3'b001);
        logic CS_is_half_power  = (ctrl_CS == 3'b010);
        logic CS_is_set_time    = (ctrl_CS == 3'b011);
        logic CS_is_op_enabled  = (ctrl_CS == 3'b100);
        logic CS_is_op_disabled = (ctrl_CS == 3'b101);
        logic CS_is_operating   = (ctrl_CS == 3'b110);
        logic CS_is_complete    = (ctrl_CS == 3'b111);
    `elsif SYNTHESIS_GREY
        logic CS_is_idle        = (ctrl_CS == 3'b000);
        logic CS_is_full_power  = (ctrl_CS == 3'b001);
        logic CS_is_half_power  = (ctrl_CS == 3'b011);
        logic CS_is_set_time    = (ctrl_CS == 3'b010);
        logic CS_is_op_enabled  = (ctrl_CS == 3'b110);
        logic CS_is_op_disabled = (ctrl_CS == 3'b111);
        logic CS_is_operating   = (ctrl_CS == 3'b101);
        logic CS_is_complete    = (ctrl_CS == 3'b100);
    `elsif SYNTHESIS_ONEHOT
        logic CS_is_idle        = (ctrl_CS[0] == 1);
        logic CS_is_full_power  = (ctrl_CS[1] == 1);
        logic CS_is_half_power  = (ctrl_CS[2] == 1);
        logic CS_is_set_time    = (ctrl_CS[3] == 1);
        logic CS_is_op_enabled  = (ctrl_CS[4] == 1);
        logic CS_is_op_disabled = (ctrl_CS[5] == 1);
        logic CS_is_operating   = (ctrl_CS[6] == 1);
        logic CS_is_complete    = (ctrl_CS[7] == 1);
    `endif



    property P1;
        @(posedge clk) disable iff(reset)
            CS_is_idle && full_power ##1 CS_is_full_power;
    endproperty;

    property P2;
        @(posedge clk) disable iff(reset)
            CS_is_idle && half_power ##1 CS_is_half_power;
    endproperty;

    property P3;
        @(posedge clk) disable iff(reset)
            CS_is_full_power && half_power ##1 CS_is_half_power;
    endproperty;

    property P4;
        @(posedge clk) disable iff(reset)
            CS_is_full_power && (s30 || s60 || s120) ##1 CS_is_set_time;
    endproperty;

    property P5;
        @(posedge clk) disable iff(reset)
            CS_is_half_power && full_power ##1 CS_is_full_power;
    endproperty;

    property P6;
        @(posedge clk) disable iff(reset)
            CS_is_half_power && (s30 || s60 || s120) ##1 CS_is_set_time;
    endproperty;


    property P7;
        @(posedge clk) disable iff(reset)
            CS_is_set_time && time_set && !door_open ##1 CS_is_op_enabled;
    endproperty;

    property P8;
        @(posedge clk) disable iff(reset)
            CS_is_set_time && time_set && door_open ##1 CS_is_op_disabled;
    endproperty;

    property P9;
        @(posedge clk) disable iff(reset)
            CS_is_op_enabled && door_open ##1 CS_is_op_disabled;
    endproperty;

    property P10;
        @(posedge clk) disable iff(reset)
            CS_is_op_enabled && (start && !door_open) ##1 CS_is_operating;
    endproperty;

    property P11;
        @(posedge clk) disable iff(reset)
            CS_is_op_disabled && (!door_open) ##1 CS_is_op_enabled;
    endproperty;

    property P12;
        @(posedge clk) disable iff(reset)
            CS_is_operating && door_open ##1 CS_is_op_enabled;
    endproperty;

    property P13;
        @(posedge clk) disable iff(reset)
            CS_is_operating && door_open ##1 CS_is_op_disabled;
    endproperty;

    property P14;
        @(posedge clk) disable iff(reset)
            CS_is_operating && !door_open && timeout ##1 CS_is_complete;
    endproperty;

    property P15;
        @(posedge clk) disable iff(reset)
            CS_is_complete && !door_open ##1 CS_is_idle;
    endproperty;



        P1_assert : assert property (P1) $display("%0dns Assertion P1 Failed", $time());
        P2_assert : assert property (P2) $display("%0dns Assertion P2 Failed", $time());
        P3_assert : assert property (P3) $display("%0dns Assertion P3 Failed", $time());
        P4_assert : assert property (P4) $display("%0dns Assertion P4 Failed", $time());
        P5_assert : assert property (P5) $display("%0dns Assertion P5 Failed", $time());
        P6_assert : assert property (P6) $display("%0dns Assertion P6 Failed", $time());
        P7_assert : assert property (P7) $display("%0dns Assertion P7 Failed", $time());
        P8_assert : assert property (P8) $display("%0dns Assertion P8 Failed", $time());
        P9_assert : assert property (P9) $display("%0dns Assertion P9 Failed", $time());
        P10_assert : assert property (P10) $display("%0dns Assertion P10 Failed", $time());
        P11_assert : assert property (P11) $display("%0dns Assertion P11 Failed", $time());
        P12_assert : assert property (P12) $display("%0dns Assertion P12 Failed", $time());
        P13_assert : assert property (P13) $display("%0dns Assertion P13 Failed", $time());
        P14_assert : assert property (P14) $display("%0dns Assertion P14 Failed", $time());
        P15_assert : assert property (P15) $display("%0dns Assertion P15 Failed", $time());


`endif



        endmodule
