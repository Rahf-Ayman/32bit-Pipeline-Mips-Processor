


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity single_cycle_TB is
end entity single_cycle_TB;

architecture sim of single_cycle_TB is
signal clk   : std_logic := '0';
signal reset : std_logic := '0';

    
    component single_cycle_top
        port (
            clk   : in std_logic;
            reset : in std_logic
        );
    end component;

begin
    
    DUT: single_cycle_top
        port map (
            clk   => clk,
            reset => reset
        );

    
    clk_generation : process
    begin
        while now < 1 ms loop        
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process clk_generation;

    
    stim_proc: process
    begin
        -- initial reset 
        reset <= '1';
        wait for 20 ns;    -- hold reset for 2 clock cycles
        reset <= '0';
		
        wait for 80 ns;   -- run for 8 clock cycles 

        -- test reset behavior
        reset <= '1';
        wait for 20 ns;
        reset <= '0';

        wait for 200 ns;

        
        report "Simulation Finished" severity note;
        wait;
    end process stim_proc;

end architecture ;
