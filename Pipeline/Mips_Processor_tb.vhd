library IEEE;
use IEEE.STD_LOGIC_1164.all;		
use IEEE.numeric_std.all;


library work;
use work.MIPS_CONST_PKG.all;

entity Mips_Processor_TB is
end Mips_Processor_TB;

architecture behavior of Mips_Processor_TB is

	component Mips_Processor is
		port(
			CLK 	 :	in STD_LOGIC;
			RESET	 :	in STD_LOGIC;
			
			INSTR   : out STD_LOGIC_VECTOR(INST_SIZE-1 downto 0);
			WRITE_DATA : out STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
			WRITE_DATA_MEM : out STD_LOGIC_VECTOR (INST_SIZE-1 downto 0)
		);
	end component Mips_Processor;
	
	

	signal CLK	: STD_LOGIC := '1';
	signal RESET	: STD_LOGIC := '0';
	
	signal INSTR   : STD_LOGIC_VECTOR(INST_SIZE-1 downto 0);
	signal WRITE_DATA :  STD_LOGIC_VECTOR(INST_SIZE-1 downto 0);
	signal WRITE_DATA_MEM :  STD_LOGIC_VECTOR(INST_SIZE-1 downto 0);
	constant CLK_PERIOD : time := 200 ns; --350 ps (MEM) + 120 ps (reg) + 50 ps (mux) = 520ps (real timing)

begin
	DUT:
		Mips_Processor port map(
			CLK => CLK,
			RESET => RESET,
			
			INSTR => INSTR,
			WRITE_DATA => WRITE_DATA,
			WRITE_DATA_MEM => WRITE_DATA_MEM
		);

	CLK_PROCESS : process
    begin
        CLK <= '0';
        wait for CLK_PERIOD/2;
        CLK <= '1';
        wait for CLK_PERIOD/2;
    end process;

	RESET_PROC:
		process
		begin
			RESET<='1';
			wait for CLK_PERIOD/4;
			RESET<='0';
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
        if cycle_count = 12 then -- check beq $t0, $t1, 4
			-- start at cycle 7 end at 10 next fitch at clk 12 (pass 2 reg)
            if INSTR = x"EEEEEEEE" then	-- INSTR at decode stage
                report "Instruction check passed beq $t0, $t1, 2 at index 7 at cycle 5!" severity note;
            else
                report "Instruction check failed beq $t0, $t1, 2 at index 7 at cycle 5!" severity warning;
            end if;
        end if;

        -- Check write-back at cycle 5
        if cycle_count = 5 then	 -- check I-type
			-- start at cycle 1 end at 5
            if WRITE_DATA = x"00000005" then
                report "Write-back data check passed addi $1, $0 ,5 at index 1 at cycle 5!" severity note;
            else
                report "Write-back data check failed addi $1, $0 ,5 at index 1 at cycle 5!" severity warning;
            end if;
        end if;
		
		if cycle_count = 9 then
		    if WRITE_DATA = x"01000512" then  -- check lw expected value at memory[5]
				-- start at cycle 5 end at 9
		        report "LW check passed lw $t0, 0($1) at index 5 at cycle 9!" severity note;
		    else
		        report "LW check failed lw $t0, 0($1) at index 5 at cycle 9!" severity warning;
		    end if;
		end if;
		
		if cycle_count = 9 then
		    if WRITE_DATA_MEM = x"00000005" then  -- check sw expected value at memory[24] <- $1
				-- start at cycle 6 end at 9
		        report "sw check passed sw $1, 24($0) at index 6 at cycle 9!" severity note;
		    else
		        report "sw check failed sw $1, 24($0) at index 6 at cycle 9!" severity warning;
		    end if;
		end if;
    end loop;
    wait;
    end process STIMULI;	
   	
end behavior;