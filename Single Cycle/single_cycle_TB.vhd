


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
     
entity single_cycle_TB is
end single_cycle_TB;

architecture sim of single_cycle_TB is
	component single_cycle_top
        port (
            clk   : in std_logic;
            reset : in std_logic;
			
			instr_out  : out STD_LOGIC_VECTOR(31 downto 0);  
			WRITE_DATA_MEM   : out STD_LOGIC_VECTOR(31 downto 0); 
            write_out  : out STD_LOGIC_VECTOR(31 downto 0) 
        );
    end component;

	
    signal clk       : std_logic := '1';
    signal reset     : std_logic := '0';
    signal instr_out : std_logic_vector(31 downto 0);
    signal write_out : std_logic_vector(31 downto 0);
    signal WRITE_DATA_MEM :  STD_LOGIC_VECTOR(31 downto 0);
    constant CLK_PERIOD : time := 100 ns;
  

begin

    
    DUT:single_cycle_top
        port map (
            clk        => clk,
            reset      => reset,
            instr_out  => instr_out,
			WRITE_DATA_MEM => WRITE_DATA_MEM,
            write_out  => write_out
        );

    
    CLK_PROCESS : process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

	RESET_PROC:
		process
		begin
			reset<='1';
			wait for CLK_PERIOD/4;
			reset<='0';
			wait;
		end process RESET_PROC;

    
-- Test process for assertions
    STIMULI: process
        variable cycle_count : integer := 0;
    begin
        while cycle_count < 15 loop
        wait until rising_edge(CLK);
        cycle_count := cycle_count + 1;
		
		wait for 3*CLK_PERIOD/4;
		
        -- Check instructions

        -- Check write-back at cycle 5
        if cycle_count = 1 then	 -- check I-type
            if write_out = x"00000005" then
                report "Write-back data check passed addi $1, $0 ,5 at index 1 at cycle 1!" severity note;
            else
                report "Write-back data check failed addi $1, $0 ,5 at index 1 at cycle 1!" severity warning;
            end if;
        end if;
		
		if cycle_count = 5 then
		    if write_out = x"01000512" then  -- check lw expected value at memory[5]
				
		        report "LW check passed lw $t0, 0($1) at index 5 at cycle 5!" severity note;
		    else
		        report "LW check failed lw $t0, 0($1) at index 5 at cycle 5!" severity warning;
		    end if;
		end if;
		
		if cycle_count = 6 then
		    if WRITE_DATA_MEM = x"00000005" then  -- check sw expected value at memory[24] <- $1
				
		        report "sw check passed sw $1, 24($0) at index 6 at cycle 6!" severity note;
		    else
		        report "sw check failed sw $1, 24($0) at index 6 at cycle 6!" severity warning;
		    end if;
		end if;
		
		if cycle_count = 8 then -- check beq $t0, $t1, 4
			
            if instr_out = x"EEEEEEEE" then	-- INSTR at decode stage
                report "Instruction check passed beq $t0, $t1, 2 at index 7 at cycle 7!" severity note;
            else
                report "Instruction check failed beq $t0, $t1, 2 at index 7 at cycle 7!" severity warning;
            end if;
        end if;
		
    end loop;
    wait;
    end process STIMULI;

end architecture ;
