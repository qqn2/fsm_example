library ieee;
use ieee.std_logic_1164.all;

entity top is
port (
		clk 		: in  std_logic;
		reset       : in  std_logic;
		half_power  : in  std_logic;
		full_power  : in  std_logic;
		start       : in  std_logic;
		s30         : in  std_logic;
		s60         : in  std_logic;
		s120        : in  std_logic;
		time_set    : in  std_logic;
		door_open   : in  std_logic;
		full        : out std_logic;
		half        : out std_logic;
		finished    : out std_logic;
		in_light    : out std_logic
	);
	


end entity top;

architecture interco of top is

component counter_oven is
	port (
		clk         : in  std_logic;
		reset       : in  std_logic;
		start  		: in  std_logic;
		stop 		: in  std_logic;
		s30         : in  std_logic;
		s60         : in  std_logic;
		s120        : in  std_logic;
	    aboveth     : out std_logic
	);
end component counter_oven;

component ctrl_oven is
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
end component ctrl_oven;

signal ctrl_timeout     : std_logic;
signal ctrl_start_count : std_logic;
signal ctrl_stop_count  : std_logic;

begin

top_counter_oven : counter_oven port map (
		clk         => clk,
		reset       => reset,
		start  		=> ctrl_start_count,
		stop 		=> ctrl_stop_count,
		s30         => s30,
		s60         => s60,
		s120        => s120,
	    aboveth     => ctrl_timeout
);

top_ctrl_oven : ctrl_oven port map (
		clk         => clk,
		reset       => reset,
		half_power  => half_power,
		full_power  => full_power,
		start       => start,
		s30         => s30,
		s60         => s60,
		s120        => s120,
		time_set    => time_set,
		door_open   => door_open,
		timeout     => ctrl_timeout,
		full        => full,
		half        => half,
		finished    => finished,
		in_light    => in_light,
		start_count => ctrl_start_count,
		stop_count  => ctrl_stop_count

);






	
end architecture interco;