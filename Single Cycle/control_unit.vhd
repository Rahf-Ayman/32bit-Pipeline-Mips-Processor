library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_unit is
    Port ( OP : in  STD_LOGIC_VECTOR (5 downto 0);
	   RegDst : out  STD_LOGIC;
	   Branch : out  STD_LOGIC;
	   MemRead : out STD_LOGIC;
       MemtoReg : out  STD_LOGIC;
       MemWrite : out  STD_LOGIC;
       AluSrc : out  STD_LOGIC;
       RegWrite : out  STD_LOGIC;
       ALUOP : out  STD_LOGIC_VECTOR (1 downto 0)
	   );
end control_unit;

architecture Behavioral of control_unit is
    signal r_type : std_logic := '0';
    signal lw     : std_logic := '0';
    signal sw     : std_logic := '0';
    signal beq    : std_logic := '0';
	signal addi : std_logic := '0';
    signal andi     : std_logic := '0';
	
begin	

	r_type	<=	not OP(5) and not OP(4) and not OP(3) and 
				not OP(2) and not OP(1) and not OP(0);
		
	lw	<=	OP(5) and not OP(4) and not OP(3) and 
			not OP(2) and    OP(1) and     OP(0);
		
	sw	<=	OP(5) and not OP(4) and 	OP(3) and 
			not OP(2) and     OP(1) and     OP(0);

	beq	<=	not OP(5) and not OP(4) and not OP(3) and 
		    OP(2) and not OP(1) and not OP(0);
	
	andi <= not OP(5) and not OP(4) and  OP(3) and 
	        OP(2) and not OP(1) and not OP(0);
	
	addi <= not OP(5) and not OP(4) and  OP(3) and 
	        not OP(2) and not OP(1) and not OP(0);
	
	RegWrite <= r_type or lw or addi or andi;		
	MemtoReg <= lw;		
	Branch   <= beq;	
	MemRead  <= lw;
	MemWrite <= sw;
	RegDst	 <= r_type;
	ALUSrc	 <= lw or sw or addi or andi;
	ALUOp(0) <= beq or andi;
	ALUOp(1) <= r_type or andi;
    
end Behavioral;

