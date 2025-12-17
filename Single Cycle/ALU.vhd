

library ieee;
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;



entity ALU is
	port(
	alu_op1	: in std_logic_vector(31 downto 0);	 
	alu_op2	: in std_logic_vector(31 downto 0);	
	ALUControl  : in std_logic_vector(3 downto 0); 	
	alu_result		: out std_logic_vector(31 downto 0); 
	zero		: out std_logic );		  
end entity;

architecture Behavior of ALU is		  
	signal temp : std_logic_vector(31 downto 0):= (others => '0');
begin	  
process(alu_op1, alu_op2, ALUControl) is
	begin
		case ALUControl is
			when "0000" =>		   
				temp <= alu_op1 and alu_op2; -- and
			when "0110" =>
				temp <= alu_op1 - alu_op2; --sub
			when "0010" =>
				temp <= alu_op1 + alu_op2; -- add
			when "0001" =>
				temp <= alu_op1 or alu_op2; -- or
			when "0011" =>
			temp <= not (alu_op1 or alu_op2); -- nor
		     -- shift left logical
            when "1000" =>
		    temp <=std_logic_vector(shift_left(unsigned(alu_op1), to_integer(unsigned(alu_op2(10 downto 6)))));
			 when "1001" =>
            -- shift right logical
            temp <=std_logic_vector(shift_right(unsigned(alu_op1), to_integer(unsigned(alu_op2(10 downto 6)))));
            when "1110" =>
				if signed(alu_op1) < signed(alu_op2) then
					temp <= (31 downto 1 => '0') & '1'; --slt -> A less than B -> '1'
				else
					temp <= (others => '0'); --slt -> A not less than B -> '0'
				end if;
			when others =>
				temp <= (others => '0');
		end case;		
	end process;
		
	zero <= '1' when (temp <= x"00000000") else '0';
  	alu_result <= temp;

end architecture ;
