library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library work;
use work.MIPS_CONST_PKG.all;

entity CTRL is
	port( 
		OP			: in	STD_LOGIC_VECTOR (5 downto 0);
	
		EX_signals : out EX_CTRL_REG;
		M_signals  : out MEM_CTRL_REG;
		WB_signals : out WB_CTRL_REG
	);
end CTRL;


architecture rtl of CTRL is  

	signal r_type : std_logic := '0';
    signal lw     : std_logic := '0';
    signal sw     : std_logic := '0';
    signal beq    : std_logic := '0';
	signal addi : std_logic := '0';
    signal andi     : std_logic := '0';
	
begin	

	r_type		<=	not OP(5) and not OP(4) and not OP(3) and 
				not OP(2) and not OP(1) and not OP(0);
		
	lw		<=	OP(5) and not OP(4) and not OP(3) and 
				not OP(2) and    OP(1) and     OP(0);
		
	sw		<=	OP(5) and not OP(4) and 	OP(3) and 
				not OP(2) and     OP(1) and     OP(0);

	beq		<=	not OP(5) and not OP(4) and not OP(3) and 
				    OP(2) and not OP(1) and not OP(0);
	
	andi 	<= not OP(5) and not OP(4) and  OP(3) and 
	OP(2) and not OP(1) and not OP(0);
	
	addi 	<= not OP(5) and not OP(4) and  OP(3) and 
	not OP(2) and not OP(1) and not OP(0);
	
	WB_signals.RegWrite	<= r_type or lw or addi or andi;		
	WB_signals.MemtoReg	<= lw;		
	M_signals.Branch <= beq;	
	M_signals.MemRead <= lw;
	M_signals.MemWrite	<= sw;
	EX_signals.RegDst		<= r_type;
	EX_signals.ALUSrc		<= lw or sw or addi or andi;
	EX_signals.ALUOp.Op0		<= beq or andi;
	EX_signals.ALUOp.Op1		<= r_type or andi;
			
end rtl;