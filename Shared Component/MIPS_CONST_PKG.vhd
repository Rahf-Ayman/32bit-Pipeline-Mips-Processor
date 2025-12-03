library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package MIPS_CONST_PKG is
	
	type WB_CTRL_REG is
	record
		RegWrite	:	STD_LOGIC;
		MemtoReg	:	STD_LOGIC; 
		end record;
	
	type MEM_CTRL_REG is
		record
		Branch		:	STD_LOGIC;
		MemRead		:	STD_LOGIC;	
		MemWrite	:	STD_LOGIC;	
		end record;

	type ALU_OP_INPUT is
		record
			Op0		:	STD_LOGIC;
			Op1		:	STD_LOGIC;
		end record;
	
	type EX_CTRL_REG is
		record
			RegDst		:	STD_LOGIC;
			ALUOp		:	ALU_OP_INPUT;
		ALUSrc		:	STD_LOGIC;
		end record;
	

	type ALU_INPUT is
	record
		Op0		:	STD_LOGIC;
		Op1		:	STD_LOGIC;
		Op2		:	STD_LOGIC;
		Op3		:	STD_LOGIC;
	end record;

		
	type ALU_FLAGS is
		record
			Carry		:	STD_LOGIC;
			Overflow	:	STD_LOGIC;
			Zero		:	STD_LOGIC;
			Negative	:	STD_LOGIC;
		end record;

	--Constantes
	
	constant INST_SIZE	: INTEGER := 32;		
	constant ADDR_SIZE	: INTEGER := 5;			
	constant NUM_REG	: INTEGER := 32;
	
	--constant NUM_ADDR	: INTEGER := 1073741824;	
	constant NUM_ADDR	: INTEGER := 1024;		
	
	constant PC_COUNT	: STD_LOGIC_VECTOR(31 downto 0) :=  "00000000000000000000000000000100";	

	constant ZERO32b	: STD_LOGIC_VECTOR(31 downto 0) :=  "00000000000000000000000000000000";	
	constant ZERO16b	: STD_LOGIC_VECTOR(15 downto 0) :=  "0000000000000000";
	constant ONE32b		: STD_LOGIC_VECTOR(31 downto 0) :=  "11111111111111111111111111111111";	
	constant ONE16b		: STD_LOGIC_VECTOR(15 downto 0) :=  "1111111111111111";	

end MIPS_CONST_PKG;