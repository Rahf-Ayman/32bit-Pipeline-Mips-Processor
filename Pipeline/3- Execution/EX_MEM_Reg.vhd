library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.MIPS_CONST_PKG.all;

entity EX_Reg is 
    port(
		CLK		:	in STD_LOGIC;			
		RESET		:	in STD_LOGIC;			
		WB_CR_IN	:	in WB_CTRL_REG; 			
		MEM_CR_IN	:	in MEM_CTRL_REG;		
		PC_ADDR_IN	:	in STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);	
		ALU_FLAGS_IN	:	in ALU_FLAGS;			
		ALU_RES_IN	:	in STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);	
		RT_IN		:	in STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);	
		RT_RD_ADDR_IN	:	in STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0);		
		 						     	      
		WB_CR_OUT	:	out WB_CTRL_REG; 			
		MEM_CR_OUT	:	out MEM_CTRL_REG;			
		PC_ADDR_OUT	:	out STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);	
		ALU_FLAGS_OUT	:	out ALU_FLAGS;					
		ALU_RES_OUT	:	out STD_LOGIC_VECTOR(INST_SIZE-1 downto 0);	
		RT_OUT		:	out STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);	
		RT_RD_ADDR_OUT	:	out STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0)		
	        
        );
end EX_Reg;

architecture EX_Reg_arc of EX_Reg is 

begin 
	SYNC_EX_MEM:
	  process(CLK,RESET)
	  begin
		if RESET = '1' then
	    	WB_CR_OUT	<= ('0','0');
			MEM_CR_OUT	<= ('0','0','0');
			PC_ADDR_OUT	<= ZERO32b;
			ALU_FLAGS_OUT	<= ('0','0','0','0');
			ALU_RES_OUT	<= ZERO32b;
			RT_OUT		<= ZERO32b;
			RT_RD_ADDR_OUT	<= "00000";
		elsif rising_edge(CLK) then
	    	WB_CR_OUT	<= WB_CR_IN;
			MEM_CR_OUT	<= MEM_CR_IN;
			PC_ADDR_OUT	<= PC_ADDR_IN;
			ALU_FLAGS_OUT	<= ALU_FLAGS_IN;
			ALU_RES_OUT	<= ALU_RES_IN;
			RT_OUT		<= RT_IN;
			RT_RD_ADDR_OUT	<= RT_RD_ADDR_IN;  
		end if;
	  end process; 

end EX_Reg_arc;