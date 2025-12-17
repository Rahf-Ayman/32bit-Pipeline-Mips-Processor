

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ShiftLeft2 is
  port( 
        SHL_input  : in std_logic_vector(31 downto 0);
        SHL_output : out std_logic_vector(31 downto 0) );
end entity;

architecture Behavior of ShiftLeft2 is
begin

  SHL_output <= std_logic_vector(unsigned(SHL_input) sll 2);

end architecture ;
