
library ieee;
use ieee.std_logic_1164.all;

entity Mux is
  port( 
 		 mux_in1 : in std_logic_vector(31 downto 0 );
 		 mux_in2 : in std_logic_vector(31 downto 0 ); 
		 mux_select : in std_logic;
 		 mux_out : out std_logic_vector(31 downto 0 ) );
end entity;					

architecture Behavior of Mux is
begin
	with mux_select select
		mux_out <= mux_in1 when '0',
		           mux_in2 when others;
end architecture ;