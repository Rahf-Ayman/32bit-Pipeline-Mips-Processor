library ieee;
use ieee.std_logic_1164.all;

entity Mux is
	generic(
		n:integer:=32
	);
	port(
	in0:in std_logic_vector(n-1 downto 0); 
	in1:in std_logic_vector(n-1 downto 0);
	selector: in std_logic;
	output:out std_logic_vector(n-1 downto 0)
	);
end Mux;

architecture behave of Mux is
begin	
	with selector select 
	output<= in0 when '0',
	         in1 when others;
	
end behave ;