library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity CTRL is
	port( 
		OP			: in	STD_LOGIC_VECTOR (5 downto 0);

		RegWrite		: out	STD_LOGIC; 	
		MemtoReg		: out	STD_LOGIC;  	
		Branch			: out	STD_LOGIC; 
		MemRead			: out	STD_LOGIC; 
		MemWrite		: out	STD_LOGIC; 
		RegDst			: out	STD_LOGIC;
		ALUSrc			: out	STD_LOGIC;
		ALUOp0			: out	STD_LOGIC;
		ALUOp1			: out	STD_LOGIC
	);
end CTRL;


architecture rtl of CTRL is  

	signal r_type : std_logic := '0';
    signal lw     : std_logic := '0';
    signal sw     : std_logic := '0';
    signal beq    : std_logic := '0';
	
begin	

	r_type		<=	not OP(5) and not OP(4) and not OP(3) and 
				not OP(2) and not OP(1) and not OP(0);
		
	lw		<=	OP(5) and not OP(4) and not OP(3) and 
				not OP(2) and    OP(1) and     OP(0);
		
	sw		<=	OP(5) and not OP(4) and 	OP(3) and 
				not OP(2) and     OP(1) and     OP(0);

	beq		<=	not OP(5) and not OP(4) and not OP(3) and 
				    OP(2) and not OP(1) and not OP(0);
	
	RegWrite	<= r_type or lw;		
	MemtoReg	<= lw;		
	Branch		<= beq;	
	MemRead		<= lw;
	MemWrite	<= sw;
	RegDst		<= r_type;
	ALUSrc		<= lw or sw;
	ALUOp0		<= beq;
	ALUOp1		<= r_type;
			
end rtl;