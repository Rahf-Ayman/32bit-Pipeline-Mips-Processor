library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.MIPS_CONST_PKG.all;

entity Mips_Processor is
	port(
		CLK 	: in STD_LOGIC;
		RESET	: in STD_LOGIC
	);
end Mips_Processor;

architecture struct of Mips_Processor is	

		--IF ID Component
		component Instruction_Fetching is
			port(
				
				clk		: in STD_LOGIC;		
				reset		: in STD_LOGIC;	
				PCSrc		: in STD_LOGIC;	
				new_PC_addr_in	: in STD_LOGIC_VECTOR(INST_SIZE-1 downto 0);
				
				new_PC_addr_out	: out STD_LOGIC_VECTOR(INST_SIZE-1 downto 0);
				instruction 	: out STD_LOGIC_VECTOR(INST_SIZE-1 downto 0)
			);
		end component Instruction_Fetching;
		
		component Instruction_Decode is
			port(
					clk			:	in	STD_LOGIC;	
					reset			:	in	STD_LOGIC;
					
					instruction		:	in	STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
					new_PC_addr_in		:	in	STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
						  
					RegWrite		:	in	STD_LOGIC;				 
					write_data		:	in	STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
					write_reg 		:	in	STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0);
					
					new_PC_addr_out		:	out	STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
					
					offset			:	out	STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);--n  [15-0]
					rt_addr			:	out	STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0);--RT [20-16]
					rd_addr			:	out	STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0);--RD [15-11]
					
					rs	 		:	out	STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);-- RS [25-21]
					rt 			:	out	STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
					
					WB_unit			:	out	WB_CTRL_REG;
					M_unit			:	out	MEM_CTRL_REG;
					EX_unit			:	out	EX_CTRL_REG	    
			);
		end component Instruction_Decode;
		--end of IF ID
			
		--EX ME WR Component
				   -- here
		--end of EX ME WR
		
		-- Signal
		
		-- IF ID s
			--IF/MEM
			signal PCSrc_intern : STD_LOGIC; --
			signal new_PC_addr_intern		: STD_LOGIC_vector (INST_SIZE-1 downto 0); --
			--ID/WB
			signal RegWrite_intern		: STD_LOGIC;
			signal write_reg_intern2		: STD_LOGIC_vector (ADDR_SIZE-1 downto 0);
			signal write_data_intern		: STD_LOGIC_vector (INST_SIZE-1 downto 0);
			--ID/EX
			signal new_PC_adder_intern2		: STD_LOGIC_vector (INST_SIZE-1 downto 0);
			signal offset_intern		: STD_LOGIC_vector (INST_SIZE-1 downto 0);
			signal rt_addr_intern		: STD_LOGIC_vector (ADDR_SIZE-1 downto 0);
			signal rd_addr_intern 		: STD_LOGIC_vector (ADDR_SIZE-1 downto 0);
			signal rs_intern	 		: STD_LOGIC_vector (INST_SIZE-1 downto 0);
			signal rt_intern1 			: STD_LOGIC_vector (INST_SIZE-1 downto 0);
			signal WB_unit_intern1		: WB_CTRL_REG;
			signal MEM_unit_intern1		: MEM_CTRL_REG;
			signal EX_unit_intern		: EX_CTRL_REG;
			--IF/ID
			signal new_PC_addr_intern1		: STD_LOGIC_vector (INST_SIZE-1 downto 0);
			signal instruction_intern		: STD_LOGIC_vector (INST_SIZE-1 downto 0);
		-- end of IF ID s
		
		-- EX ME WR s
				  --here
		-- end of EX ME WR	
	 
begin

	--Port maps
	
	--IF ID Component
		IFetch:
		Instruction_Fetching port map (
			clk => CLK,		
			reset => RESET,	
			PCSrc => PCSrc_intern,
			new_PC_addr_in => new_PC_addr_intern ,
			new_PC_addr_out => new_PC_addr_intern1,
			instruction  => instruction_intern
		);
		
		IDecode: 
		Instruction_Decode port map (
   			clk	=> CLK,	
			reset	=> RESET,
			instruction	=> instruction_intern ,
			new_PC_addr_in	=> new_PC_addr_intern1 ,	  
			RegWrite	=> RegWrite_intern ,				 
			write_data	=> write_data_intern ,
			write_reg 	=> write_reg_intern2 ,
			new_PC_addr_out	=> new_PC_adder_intern2,
			offset	=> offset_intern ,
			rt_addr	=> rt_addr_intern,
			rd_addr	=> rd_addr_intern ,
			rs	 => rs_intern ,
			rt 	=> rt_intern1,
			WB_unit	=> WB_unit_intern1,
			M_unit	=> MEM_unit_intern1,
			EX_unit	=> Ex_unit_intern 
		);
		 
	--end of IF ID
		
	--EX ME WR Component
			   -- here
	--end of EX ME WR

end struct;		