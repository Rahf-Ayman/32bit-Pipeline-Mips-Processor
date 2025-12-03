library IEEE;
use IEEE.STD_LOGIC_1164.all;		
use IEEE.numeric_std.all;

library work;
use work.MIPS_CONST_PKG.all;


entity IF_ID_reg is 
    port(
	        clk		    : in	STD_LOGIC;
			reset		: in	STD_LOGIC;
	        PC_addr_in	: in	STD_LOGIC_VECTOR(INST_SIZE-1 downto 0);
	        inst_reg_in	: in	STD_LOGIC_VECTOR(INST_SIZE-1 downto 0);
	        PC_addr_out	: out	STD_LOGIC_VECTOR(INST_SIZE-1 downto 0);
	        inst_reg_out: out	STD_LOGIC_VECTOR(INST_SIZE-1 downto 0)	
        );
end IF_ID_reg;

architecture rtl of IF_ID_reg is        
begin
	SYNC_IF_ID:	
		process(clk	,reset)
		begin
			if reset = '1' then
				PC_addr_out	<= (others => '0');
				inst_reg_out	<= (others => '0');
			elsif rising_edge(clk) then
				PC_addr_out	<= PC_addr_in;
				inst_reg_out<= inst_reg_in;
			end if;
		end process; 
end rtl;