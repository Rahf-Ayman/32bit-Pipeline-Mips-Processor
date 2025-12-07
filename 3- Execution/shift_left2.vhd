library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity ShiftLeft2 is
	port(
	i:in std_logic_vector(29 downto 0);
	o:out  std_logic_vector(31 downto 0)
	
	);
end entity;

architecture behave of ShiftLeft2 is
begin	
	 o <= i&"00";
end architecture ;
