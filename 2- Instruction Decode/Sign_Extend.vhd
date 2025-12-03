library ieee;
use ieee.std_logic_1164.all;

entity SignExtend is
	port(
	i:in std_logic_vector(15 downto 0);
	o:out  std_logic_vector(31 downto 0)
	);
end entity;

architecture behave of SignExtend is
begin	
o <= "0000000000000000"&i when (i(15)='0') else  
		"1111111111111111"&i;
end behave ;