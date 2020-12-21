`timescale 1ns/1ps

module tb_ctrl_oven ();
	localparam PERIOD = 20;
	int emulate_count = 0;
	int time_chosen = 0;

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
	logic timeout   ;
// Outputs
	logic full       ;
	logic half       ;
	logic finished   ;
	logic in_light   ;
	logic start_count;
	logic stop_count ;
// Instancation
	ctrl_oven my_ctrl_oven (.*);   // I <3 systemverilog
	



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
		0 			: Half power mode  
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
		1 			: s60 is chosen
		2			: s120 is chosen
		3 			: not supported
		*/
		function void set_time(input logic[1:0] time_mode = 0);
			begin
			case (time_mode)
				2'b00: 
					begin 
						s30 = 1;
						s60 = 0;
						s120= 0;
						time_set = 1;
						time_chosen = 30;
					end
				2'b01: 
					begin 
						s30 = 0;
						s60 = 1;
						s120= 0;
						time_set = 1;
						time_chosen = 60;
					end
				2'b10: 
					begin 
						s30 = 0;
						s60 = 0;
						s120= 1;
						time_set = 1;
						time_chosen = 120;
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

		task stall(input int N = 5);
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
				time_chosen = 0;
				reset_p();
			end
		endtask : init

 		/* drives reset high for one clock period */
		task reset_p();
			begin 
				@(cb);
				reset 	  = 1  ;
				@(cb);
				reset 	  =	0  ;
			end
		endtask : reset_p
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
						timeout = 1;
						emulate_count = 0;	
					end
				@(cb);
			end

		/* TEST 1 : FULL POWER -> S30(SET_TIME) -> OP_ENABLED -> OP_DISABLED -> OP_ENABLED -> OPERATING -> COMPLETE */
		task sequence_one();
			begin 
				set_power(1);
				@(full);
				set_time(0);
				repeat(5) @(cb);
				open_close_door();
				@(in_light);
				open_close_door();
				start = 1;
				@(finished);
				open_close_door();
				$display("Test 1 ended at %0d",$time);
				repeat (2) @(cb);
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
				repeat (2) @(cb);
				open_close_door();
			end
		endtask : sequence_two

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
				stall(5);
				sequence_two();
				drive_almost_every_input_to_zero(); 
				stall(5);
				/*
				// TEST 3 : FULL POWER -> HALF POWER -> FULL POWER -> S120 -> ENABLED -> OPERATING -> DISABLED -> ENABLED -> OPERATING -> COMPLETE
				time_set = 0;
				start = 0;
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
				repeat (2) @(cb);
				open_close_door();
				// TEST 5 : This one is just edge cases to drive the coverage from 95 to 100
				time_set = 0;
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

				// TEST  : Reset while counter stopped
				set_power(1);
				@(full);
				set_time(2); 
				start = 1;
				repeat (10) @(cb); // After 10 clock cycles, open the door
				@(cb_n) open_close_door();
				repeat (10) @(cb); // Close the door after 10 clock cycles
				reset_p();

				// Reset while State = OP_DISABLED
				door_open = 0;
				time_set = 0;
				start = 0;
				set_power(0);
				@(half);
				set_time(1); 
				open_close_door();
				@(in_light);
				reset_p();

				// Reset while State = Operating
				door_open = 0;
				time_set = 0;
				start = 0;
				set_power(1);
				@(full);
				set_time(1);
				start = 1;
				@(in_light);
				reset_p();


				// Reset while state = op enabled
				set_power(1);
				@(full);
				set_time(0);
				repeat(5) @(cb);
				reset_p();

				// Half to half to reset
				set_time(3);
				time_set = 0;
				set_power(0);
				repeat (5) @(cb);
				reset_p();

*/
				$finish;
			end
		

/*
always
begin 
	
	if (my_ctrl_oven.NS == ^.^.FULL_POWER_ON) begin
		$display("silly test 1: time is %d",$time());
	end
	if (my_ctrl_oven.NS == 3) begin
		$display("silly test 2: time is %d",$time());
	end
	@(cb);
end
*/

	endmodule
