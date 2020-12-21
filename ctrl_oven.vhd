
library ieee;
use ieee.std_logic_1164.all;


entity ctrl_oven is
	port (
		clk         : in  std_logic;
		reset       : in  std_logic;
		half_power  : in  std_logic;
		full_power  : in  std_logic;
		start       : in  std_logic;
		s30         : in  std_logic;
		s60         : in  std_logic;
		s120        : in  std_logic;
		time_set    : in  std_logic;
		door_open   : in  std_logic;
		timeout     : in  std_logic;
		full        : out std_logic;
		half        : out std_logic;
		finished    : out std_logic;
		in_light    : out std_logic;
		start_count : out std_logic;
		stop_count  : out std_logic 
	);
end ctrl_oven;

architecture ctrl_oven_arc of ctrl_oven is

	type type_State is (IDLE,FULL_POWER_ON,HALF_POWER_ON,SET_TIME,OPERATION_ENABLED,OPERATION_DISABLED,OPERATING,COMPLETE);
	signal time_selected,stop_count_next : std_logic;
	signal CS,NS         : type_State;


begin


	Next_state_update : process( CS,half_power,full_power,start,time_set,time_selected,door_open,timeout ) -- TODO : ADD LATER
	begin
		NS <= CS;
		case (CS) is
			when IDLE =>
				assert not (half_power = '1' and full_power = '1') report "Both full and half power on" severity WARNING ;
				if (full_power = '1') then
					NS <= FULL_POWER_ON;
				elsif (half_power = '1') then
					NS <= HALF_POWER_ON;
				end if;

			when FULL_POWER_ON =>
				assert not (half_power = '1' and full_power = '1') report "Both full and half power on" severity WARNING;
				if (half_power = '1') then
					NS <= HALF_POWER_ON;
				elsif (time_selected = '1') then
					NS <= SET_TIME;
				end if;

			when HALF_POWER_ON =>
				assert not (half_power = '1' and full_power = '1') report "Both full and half power on" severity WARNING;
				if (full_power = '1') then
					NS <= FULL_POWER_ON;
				elsif (time_selected = '1') then
					NS <= SET_TIME;
				end if;

			when SET_TIME =>
				assert not (time_set = 'X' or door_open = 'X') report "Unknown values on time_set or door_open" severity WARNING;
				if (time_set = '1' and door_open = '0') then
					NS <= OPERATION_ENABLED;
				elsif (time_set = '1' or door_open = '1') then
					NS <= OPERATION_DISABLED;
				end if;

			when OPERATION_ENABLED =>
				assert not (door_open = 'X') report "door open unknown" severity WARNING;
				if (door_open = '1') then
					NS <= OPERATION_DISABLED;
				elsif (start = '1') then
					NS <= OPERATING;
				end if;

			when OPERATION_DISABLED =>
				assert not (door_open = 'X') report "door open unknown" severity WARNING;
				if (door_open = '0') then
					NS <= OPERATION_ENABLED;
				end if;

			when OPERATING =>
				assert not (timeout = 'X') report "timeout unknown" severity WARNING;
				assert not (door_open = 'X') report "door open unknown" severity WARNING;
				if (door_open = '1') then
					NS <= OPERATION_DISABLED;
				elsif (timeout = '1') then
					NS <= COMPLETE;
				end if;

			when COMPLETE =>
				assert not (door_open = 'X') report "door open unknown" severity WARNING;
				if (door_open = '1') then
					NS <= IDLE;
				end if;

		end case;
	end process ; -- Next_state_update


	output_driver : process( CS, NS )
	begin
		if(CS = FULL_POWER_ON) then
			full <= '1';
		else
			full <= '0';
		end if;
		if (CS = HALF_POWER_ON) then
			half <= '1';
		else
			half <= '0';
		end if ;
		if (CS = OPERATION_DISABLED or CS = OPERATING) then
			in_light <= '1';
		else
			in_light <= '0';
		end if;
		if (CS = OPERATING) then
			start_count <= '1';
		else
			start_count <= '0';
		end if;
		if (CS = OPERATING and NS = OPERATION_DISABLED) then
			stop_count_next <= '1';
		else
			stop_count_next <= '0';
		end if;
		if (CS = COMPLETE) then
			finished <= '1';
		else
			finished <= '0';
		end if;


	end process ; -- output_driver



	is_time_set : process( s30,s60,s120 )
	begin
		assert not (s30 = '1' and s60 = '1' ) report "more than one time selection is high" severity WARNING;
		assert not (s30 = '1' and s120 = '1' ) report "more than one time selection is high" severity WARNING;
		assert not (s60 = '1' and s120 = '1' ) report "more than one time selection is high" severity WARNING;
		if (s30 = '1' or s60 = '1' or s120 = '1') then
			time_selected <= '1';
		else
			time_selected <= '0';
		end if;
	end process ; -- is_time_set

	state_update : process (reset, clk)
	begin
		if (reset = '1') then
			CS <= IDLE;
			stop_count <= '0';
		elsif (rising_edge(clk)) then
			CS <= NS;
			stop_count <= stop_count_next;
		end if;
	end process ; --state_update



end ctrl_oven_arc;
