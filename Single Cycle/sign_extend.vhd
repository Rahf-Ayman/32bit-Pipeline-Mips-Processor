							   						
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign_extend is
  port( 
        extend_in  : in std_logic_vector(15 downto 0);
        extend_out : out std_logic_vector(31 downto 0) );
end entity;			 
  
architecture Behavior of sign_extend is
begin

 extend_out <= "0000000000000000" & extend_in when (extend_in(15) = '0') else
           "1111111111111111" & extend_in;

end architecture;