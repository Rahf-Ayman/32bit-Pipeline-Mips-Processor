

library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity adder is	
	port (
		adder_in1,adder_in2: in std_logic_vector(31 downto 0);
		adder_out: out std_logic_vector(31 downto 0)
	);
end adder;								   

architecture rtl of adder is
begin

	 adder_out <= adder_in1 + adder_in2;

end rtl;
