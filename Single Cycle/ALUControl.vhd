

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

   --> funct codes <--
--------------------------------
-- add         		  | 100000 |
-- subtract    		  | 100010 |
-- and         		  | 100100 |
-- or          		  | 100101 |
-- nor         		  | 100111 |
-- shift_left  		  | 000000 |
-- shift_right 		  | 000010 |
-- set_is_less_than   | 101010 |
--------------------------------

entity ALUControl is
  port(
    ALUOp      : in  std_logic_vector(1 downto 0);
    funct      : in  std_logic_vector(5 downto 0);
    ALUControl : out std_logic_vector(3 downto 0) );
end entity;

architecture Behavior of ALUControl is
begin

  process(ALUOp, funct)
  begin
    case ALUOp is

      -- LW, SW , addi => ADD 
      when "00" =>
        ALUControl <= "0010";

      -- BEQ => SUB
      when "01" =>
        ALUControl <= "0110";

      -- R-type
      when "10" =>
        case funct is
          when "100000" => ALUControl <= "0010"; -- add
          when "100010" => ALUControl <= "0110"; -- sub
          when "100100" => ALUControl <= "0000"; -- and
          when "100101" => ALUControl <= "0001"; -- or
          when "100111" => ALUControl <= "0011"; -- nor
          when "000000" => ALUControl <= "1000"; -- sll
          when "000010" => ALUControl <= "1001"; -- srl
	  when "101010" => ALUControl <= "1110"; -- slt
          when others   => ALUControl <= "0000"; -- Default AND
        end case;

      when others =>
        ALUControl <= "0000";

    end case;
  end process;

end architecture;
