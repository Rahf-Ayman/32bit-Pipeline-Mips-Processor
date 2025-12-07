library IEEE;
use IEEE.STD_LOGIC_1164.all;		
use IEEE.numeric_std.all;

library work;
use work.MIPS_CONST_PKG.all;

entity Execution is
	port( 
     	CLK			: in STD_LOGIC;					
		RESET			: in STD_LOGIC;					
     	WB_CR			: in WB_CTRL_REG; 			
		MEM_CR			: in MEM_CTRL_REG;				
		EX_CR			: in EX_CTRL_REG;					     	
		NEW_PC_ADDR_IN		: in STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);	
		RS	 		: in STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
	    RT 			: in STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);	
		OFFSET			: in STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);	
		RT_ADDR			: in STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0);	
		RD_ADDR			: in STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0);				 				
				     	      
		WB_CR_OUT		: out WB_CTRL_REG;
		MEM_CR_OUT		: out MEM_CTRL_REG;				
		PC_ADDR_OUT		: out STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);	
		ALU_FLAGS_OUT		: out ALU_FLAGS;				
		ALU_RES_OUT		: out STD_LOGIC_VECTOR(INST_SIZE-1 downto 0);
		RT_OUT			: out STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
		RT_RD_ADDR_OUT		: out STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0)			
	);
end Execution;

architecture Execution_ARC of Execution is	

	component ALU_Control is
		port(
			Fun: in STD_LOGIC_VECTOR(5 downto 0);	
			ALUOP: in ALU_OP_INPUT;		
		   ALU_IN: out ALU_INPUT			
		);
	end component ALU_CONTROL;
	
	component ALU is 
		generic (INST_SIZE:INTEGER := INST_SIZE);
		port(
			operand_A: in STD_LOGIC_VECTOR(INST_SIZE-1 downto 0);
			operand_B: in STD_LOGIC_VECTOR(INST_SIZE-1 downto 0);
			alu_ctrl: in ALU_INPUT;
			result: out STD_LOGIC_VECTOR(INST_SIZE-1 downto 0);
			FLAGS: out ALU_FLAGS	
		);
	end component ALU;
	
	component adder is 
		generic (N: natural);
	    port(
		x	: in	STD_LOGIC_VECTOR(N-1 downto 0);
		y	: in	STD_LOGIC_VECTOR(N-1 downto 0);
		cin	: in	STD_LOGIC;
		cout	: out	STD_LOGIC;
		sum	: out	STD_LOGIC_VECTOR(N-1 downto 0)
		);
	end component adder;
	
	component EX_Reg is  
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
		ALU_FLAGS_OUT	:out ALU_FLAGS;					
		ALU_RES_OUT	:	out STD_LOGIC_VECTOR(INST_SIZE-1 downto 0);	
		RT_OUT		:	out STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);	
		RT_RD_ADDR_OUT	:	out STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0)		
		);
	end component EX_Reg; 
	component Mux2to1 is
		generic (n:integer:=INST_SIZE);
	    port(
		in0: in std_logic_vector(n-1 downto 0); 
		in1:in std_logic_vector(n-1 downto 0);
		selector:in std_logic;
		output:out std_logic_vector(n-1 downto 0));
	end component Mux2to1;
	component ShiftLeft2 is
	port(
	i:in std_logic_vector(29 downto 0);
	o:out  std_logic_vector(31 downto 0)
	); 
	end component ShiftLeft2;
	
	signal CARRY_EX	: STD_LOGIC;
	signal ALU_IN_EX	: ALU_INPUT;
	signal PC_ADDR_EX	: STD_LOGIC_VECTOR (INST_SIZE-1 downto 0); 
	signal RT_RD_ADDR_EX	: STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0);
	signal OFFSET_SHIFT2	: STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
	signal ALU_REG_IN	: STD_LOGIC_VECTOR (INST_SIZE-1 downto 0); 
	signal ALU_RES_EX	: STD_LOGIC_VECTOR (INST_SIZE-1 downto 0); 
	signal ALU_FLAGS_EX	: ALU_FLAGS;
	 
begin

	ALU_CTR:
		ALU_Control port map(
			Fun	=> OFFSET(5 downto 0),
			ALUOP	=> EX_CR.ALUOp,
		    ALU_IN	=> ALU_IN_EX
		);
	
	ADDER_MIPS: 
		adder generic map (N => INST_SIZE) 
		port map(
			x	 => NEW_PC_ADDR_IN,
			y	 => OFFSET_SHIFT2,
			cin  => '0',
			cout => CARRY_EX,
			sum	 => PC_ADDR_EX
		);
        
	MUX_RT_RD:
	   Mux2to1 generic map (n=>ADDR_SIZE)
	   port map(	   
		in0 => RT_ADDR, 
		in1 => RD_ADDR,
		selector => EX_CR.RegDst,
		output => RT_RD_ADDR_EX
	   );	
	shift2:
	   ShiftLeft2 port map(	   
	    i => OFFSET(29 downto 0),
	    o =>OFFSET_SHIFT2
	   );	
	MUX_ALU:
	Mux2to1 generic map (n=>INST_SIZE)
	port map(	   
		in0 => RT, 
		in1 => OFFSET,
		selector => EX_CR.AluSrc,
		output => ALU_REG_IN
	);
	 
	ALU_MIPS: 
		ALU generic map (INST_SIZE => INST_SIZE)
		port map(
			operand_A	=> RS,
			operand_B	=> ALU_REG_IN,
			alu_ctrl	=> ALU_IN_EX,
			result	=> ALU_RES_EX,
			FLAGS	=> ALU_FLAGS_EX
		);

	EX_MEM_REGS:
		 EX_Reg port map(
			CLK		=> CLK,
			RESET		=> RESET,
			WB_CR_IN	=> WB_CR,
			MEM_CR_IN	=> MEM_CR,
			PC_ADDR_IN	=> PC_ADDR_EX,
			ALU_FLAGS_IN	=> ALU_FLAGS_EX,
			ALU_RES_IN	=> ALU_RES_EX,
			RT_IN		=> RT,
			RT_RD_ADDR_IN	=> RT_RD_ADDR_EX,	
			WB_CR_OUT	=> WB_CR_OUT,
			MEM_CR_OUT	=> MEM_CR_OUT,
			PC_ADDR_OUT	=> PC_ADDR_OUT,
			ALU_FLAGS_OUT	=> ALU_FLAGS_OUT,
			ALU_RES_OUT	=> ALU_RES_OUT,
			RT_OUT		=> RT_OUT,
			RT_RD_ADDR_OUT	=> RT_RD_ADDR_OUT	
		);

end Execution_ARC;