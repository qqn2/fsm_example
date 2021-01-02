library IEEE;
use IEEE.std_logic_1164.all;

entity counter_oven is
    port(
        clk         : in  std_logic;
        reset       : in  std_logic;
        start       : in  std_logic;
        stop        : in  std_logic;
        s30         : in  std_logic;
        s60         : in  std_logic;
        s120        : in  std_logic;
        aboveth     : out std_logic
);

end entity;

architecture impl of counter_oven is

    type type_State is (IDLE, COUNTING, STOPPED);
    signal CS, NS: type_State;
    signal counter, counter_next: natural;

    begin

        process (CS, counter, start, stop, s30, s60, s120)
            begin
            NS <= CS;
            counter_next <= counter;
            
            case (CS) is

                when IDLE =>
                if (start = '1') then 
                    NS <= COUNTING;
                    counter_next <= counter + 1;
                else 
                    counter_next <= 0;
                end if;

                when COUNTING =>
                assert not (stop = 'X') report "Stop unknown" severity WARNING;
                assert not (s30 = 'X' or s60 = 'X' or s120 = 'X') report "s30,s60,s120 unknown" severity WARNING;
                if (stop = '1') then
                    NS <= STOPPED;
                elsif ((s30='1' and counter >= 30) or (s60='1' and counter >= 60) or (s120='1' and counter >= 120)) then
                    NS <= IDLE;
                    counter_next <= 0;
                else
                    counter_next <= counter + 1;
                end if;

                when STOPPED =>
                if start='1' then
                    NS <= COUNTING;
                    counter_next <= counter + 1;
                end if;

            end case;

        end process;

        process (reset, clk)
            begin
            -- if asynchronous reset
            if (reset = '1') then
                CS <= IDLE;
                counter <= 0;
            -- if rising edge
            elsif (rising_edge(clk)) then
            CS <= NS;
            counter <= counter_next;
            end if;
            end process;
            aboveth <= '1' when ((s30='1' and counter >= 30) or (s60='1' and counter >= 60) or
            (s120='1' and counter >= 120)) else '0';

end architecture;