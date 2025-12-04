library IEEE;
use IEEE.STD_LOGIC_1164.all;		
use IEEE.numeric_std.all;

entity Mips_Processor_TB is
end Mips_Processor_TB;

architecture behavior of Mips_Processor_TB is

	component Mips_Processor is
		port(
			CLK 	 :	in STD_LOGIC;
			RESET	 :	in STD_LOGIC
		);
	end component Mips_Processor;

	signal CLK	: STD_LOGIC := '0';
	signal RESET	: STD_LOGIC := '0';

begin
	DUT:
		Mips_Processor port map(
			CLK => CLK,
			RESET => RESET
		);

	CLK <= not CLK after 100ns;

	RESET_PROC:
		process
		begin
			RESET<='1';
			wait for 50 ns;
			RESET<='0';
			wait;
		end process RESET_PROC;
   	
end behavior;