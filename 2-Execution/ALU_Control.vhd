library IEEE;
use IEEE.STD_LOGIC_1164.all;		
use IEEE.numeric_std.all;

library work;
use work.MIPS_CONST_PKG.all; 

entity ALU_Control is 
	port(	
	Fun: in STD_LOGIC_VECTOR(5 downto 0); 		 
	ALUOP : in ALU_OP_INPUT;
	ALU_IN : out ALU_INPUT
	);
end ALU_Control;

architecture ALU_Con_Arc of ALU_Control is 
signal op_code : std_logic_vector(1 downto 0);
begin	  
	op_code <= ALUOP.Op1 & ALUOP.Op0;
    process(ALUOP, Fun)	
	
    begin
        -- Default values and
        ALU_IN.Op3 <= '0';
        ALU_IN.Op2 <= '0';
        ALU_IN.Op1 <= '0';
        ALU_IN.Op0 <= '0';
        						
     case op_code is
            when "00" =>  -- lw, sw, addi
                -- ADD operation: 0010
                ALU_IN.Op3 <= '0';
                ALU_IN.Op2 <= '0';
                ALU_IN.Op1 <= '1';
                ALU_IN.Op0 <= '0';
                
            when "01" =>  -- beq, bne
                -- SUB operation: 0110
                ALU_IN.Op3 <= '0';
                ALU_IN.Op2 <= '1';
                ALU_IN.Op1 <= '1';
                ALU_IN.Op0 <= '0';
                
            when "10" => 
                case Fun is
                    -- R-type arithmetic/logic operations
                    when "100000" =>  -- ADD
                        ALU_IN.Op3 <= '0';
                        ALU_IN.Op2 <= '0';
                        ALU_IN.Op1 <= '1';
                        ALU_IN.Op0 <= '0';
                        
                    when "100010" =>  -- SUB
                        ALU_IN.Op3 <= '0';
                        ALU_IN.Op2 <= '1';
                        ALU_IN.Op1 <= '1';
                        ALU_IN.Op0 <= '0';
                        
                    when "100100" =>  -- AND
                        ALU_IN.Op3 <= '0';
                        ALU_IN.Op2 <= '0';
                        ALU_IN.Op1 <= '0';
                        ALU_IN.Op0 <= '0';
                        
                    when "100101" =>  -- OR
                        ALU_IN.Op3 <= '0';
                        ALU_IN.Op2 <= '0';
                        ALU_IN.Op1 <= '0';
                        ALU_IN.Op0 <= '1';
                        
                    when "100110" =>  -- XOR
                        ALU_IN.Op3 <= '0';
                        ALU_IN.Op2 <= '0';
                        ALU_IN.Op1 <= '1';
                        ALU_IN.Op0 <= '0';
                        
                    when "100111" =>  -- NOR
                        ALU_IN.Op3 <= '0';
                        ALU_IN.Op2 <= '0';
                        ALU_IN.Op1 <= '1';
                        ALU_IN.Op0 <= '1';
                        
                    when "101010" =>  -- SLT
                        ALU_IN.Op3 <= '1';
                        ALU_IN.Op2 <= '1';
                        ALU_IN.Op1 <= '1';
                        ALU_IN.Op0 <= '0';
                        
                    when "000000" =>  -- SLL 
                        ALU_IN.Op3 <= '1';  -- Op3=1
                        ALU_IN.Op2 <= '0';
                        ALU_IN.Op1 <= '0';
                        ALU_IN.Op0 <= '0';
                        
                    when "000010" =>  -- SRL
                        ALU_IN.Op3 <= '1';
                        ALU_IN.Op2 <= '0';
                        ALU_IN.Op1 <= '0';
                        ALU_IN.Op0 <= '1';
                        
                    when others =>
                        -- Default to AND
                        ALU_IN.Op3 <= '0';
                        ALU_IN.Op2 <= '0';
                        ALU_IN.Op1 <= '0';
                        ALU_IN.Op0 <= '0';
                end case;
                
            when others =>
                -- Default to AND
                ALU_IN.Op3 <= '0';
                ALU_IN.Op2 <= '0';
                ALU_IN.Op1 <= '0';
                ALU_IN.Op0 <= '0';
        end case;
    end process;
end ALU_Con_Arc;
	
	