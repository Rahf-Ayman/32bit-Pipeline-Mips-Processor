


library IEEE;
use IEEE.STD_LOGIC_1164.all;		
use IEEE.numeric_std.all;


entity PC_reg is   
	port(
		clk		: in	STD_LOGIC;						
		reset		: in	STD_LOGIC;
		data_in		: in	STD_LOGIC_VECTOR(31 downto 0);	
		data_out	: out	STD_LOGIC_VECTOR(31 downto 0)
	);
end PC_reg;

architecture rtl of PC_reg is        
begin
	process_unit:
		process(clk,reset)
		begin
			if(reset = '1') then
				data_out <= (others => '0');
			elsif rising_edge(clk) then
				data_out <= data_in;
			end if;
		end process; 
end rtl;