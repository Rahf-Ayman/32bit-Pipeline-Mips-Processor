library ieee;
use ieee.std_logic_1164.all;

entity Mux2To1 is
	generic(
	n:integer:=32
	);
	port(
	in0:in std_logic_vector(n-1 downto 0); 
	in1:in std_logic_vector(n-1 downto 0);
	selector: in std_logic;
	output:out std_logic_vector(n-1 downto 0)
	);
end entity;

architecture behave of Mux2To1 is
begin	
	with selector select 
	output<= in0 when '0',
	         in1 when others;
	
end architecture ;