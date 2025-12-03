library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MIPS_CONST_PKG.all;

entity ALU is 
    generic (
        WIDTH : integer := 32
    );
    port(
        operand_A : in  std_logic_vector(WIDTH-1 downto 0);
        operand_B : in  std_logic_vector(WIDTH-1 downto 0);
        alu_ctrl  : in  ALU_INPUT;
        result    : out std_logic_vector(WIDTH-1 downto 0);
		FLAGS	: out ALU_FLAGS
    );
end entity ALU;

architecture RTL of ALU is 
    -- Internal signals
    signal arithmetic_result : std_logic_vector(WIDTH downto 0);
    signal logic_result    : std_logic_vector(WIDTH-1 downto 0);
    signal shift_result    : std_logic_vector(WIDTH-1 downto 0);
    signal compare_result  : std_logic_vector(WIDTH-1 downto 0);
    signal final_result    : std_logic_vector(WIDTH-1 downto 0);
    
    signal op_code : std_logic_vector(1 downto 0);
    
    constant ZERO_VECTOR   : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
    
begin
    
    op_code <= alu_ctrl.Op1 & alu_ctrl.Op0;
    
    ARITHMETIC_PROC: process(operand_A, operand_B, alu_ctrl)
        variable sum_temp   : unsigned(WIDTH downto 0);
        variable a_temp, b_temp : unsigned(WIDTH downto 0);
    begin
        a_temp := unsigned('0' & operand_A);
        b_temp := unsigned('0' & operand_B);
        
        if alu_ctrl.Op2 = '0' then  -- ADD	 0010 , sub 0110
            sum_temp := a_temp + b_temp;
        else  -- SUB
            sum_temp := a_temp - b_temp;
        end if;
        
        arithmetic_result <= std_logic_vector(sum_temp);
    end process;

    LOGIC_PROC: process(operand_A, operand_B, op_code)
    begin
        if op_code = "00" then
            logic_result <= operand_A and operand_B;
        elsif op_code = "01" then
            logic_result <= operand_A or operand_B;
        elsif op_code = "10" then
            logic_result <= operand_A xor operand_B;
        elsif op_code = "11" then
            logic_result <= operand_A nor operand_B;
        else
            logic_result <= (others => '0');
        end if;
    end process;
    
    SHIFT_PROC: process(operand_A, operand_B)
        variable shift_amount : integer;
    begin
		
        shift_amount := to_integer(unsigned(operand_B(4 downto 0))); 
		if alu_ctrl.Op0 = '0' then 
			shift_result <= std_logic_vector(shift_left(unsigned(operand_A), shift_amount)); 
		else 
		    shift_result <= std_logic_vector(shift_right(unsigned(operand_A), shift_amount));		 
		end if;
    end process;
    
    COMPARE_PROC: process(operand_A, operand_B, alu_ctrl)
    begin
        compare_result <= (others => '0');
        if alu_ctrl.Op2 = '1' and op_code = "11" then
            if signed(operand_A) < signed(operand_B) then
                compare_result(0) <= '1';
            end if;
        end if;
    end process;
    
       MAIN_MUX_PROC: process(alu_ctrl, arithmetic_result, logic_result, 
                           compare_result, shift_result, op_code)
    begin
        if alu_ctrl.Op3 = '1' then
            -- Shift operation
            final_result <= shift_result;
        else
            if alu_ctrl.Op2 = '0' and op_code = "00" then      -- AND
                final_result <= logic_result;
            elsif alu_ctrl.Op2 = '0' and op_code = "01" then   -- OR
                final_result <= logic_result;
            elsif alu_ctrl.Op2 = '0' and op_code = "10" then   -- XOR
                final_result <= logic_result;
            elsif alu_ctrl.Op2 = '0' and op_code = "11" then   -- NOR
                final_result <= logic_result;
            elsif alu_ctrl.Op2 = '0' and op_code = "10" then   -- ADD
                final_result <= arithmetic_result(WIDTH-1 downto 0);
            elsif alu_ctrl.Op2 = '1' and op_code = "10" then   -- SUB
                final_result <= arithmetic_result(WIDTH-1 downto 0);
            elsif alu_ctrl.Op2 = '1' and op_code = "11" then   -- SLT
                final_result <= compare_result;
            else
                final_result <= (others => '0');
            end if;
        end if;
    end process MAIN_MUX_PROC;
    
    result <= final_result;
    FLAGS.Carry <= arithmetic_result(WIDTH);
    
    FLAGS_PROC: process(final_result, arithmetic_result)
    begin
        -- Zero Flag
        if final_result = ZERO_VECTOR then
            FLAGS.Zero <= '1';
        else
            FLAGS.Zero <= '0';
        end if;
		
		
        -- Negative Flag
        FLAGS.Negative  <= final_result(WIDTH-1);
		
        
        -- Overflow Flag
        FLAGS.Overflow <= arithmetic_result(WIDTH) xor arithmetic_result(WIDTH-1);
    end process FLAGS_PROC;
    
end architecture RTL;