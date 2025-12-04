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
			
	component Execution is 
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
   end component Execution;	 
   
    component Mem_Con is
	port( 
		clk			: in STD_LOGIC;					
		reset			: in STD_LOGIC;					
		WB_in			: in WB_CTRL_REG;				
		mem			: in MEM_CTRL_REG;				
		zero_flag		: in STD_LOGIC;					
		PC_addr		: in STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);	
		addr_in		: in STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);	
		write_data		: in STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);	
		write_reg_in		: in STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0);	
		
		WB_out			: out WB_CTRL_REG;				
		read_data		: out STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);	
		addr_out		: out STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);	
		write_reg_out		: out STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0);	
		
		PC_addr_out	: out STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);	
		PCSrc			: out STD_LOGIC					
	);
   end component Mem_Con;
  
    component WriteBack is
    port( 
	  reset		: in STD_LOGIC;		
	 WB			: in WB_CTRL_REG;				
	 read_data	: in STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);	
	 addr		: in STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);	
	 write_reg	: in STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0);			
	
	 regWrite	: out STD_LOGIC;			
	 write_reg_out	: out STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0);	
	 write_data	: out STD_LOGIC_VECTOR (INST_SIZE-1 downto 0)
    );
    end component  WriteBack;  
	--end of EX ME WR
	
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
			
	signal new_PC_addr_intern1		: STD_LOGIC_vector (INST_SIZE-1 downto 0);
    signal instruction_intern		: STD_LOGIC_vector (INST_SIZE-1 downto 0);
    -- end of IF ID s	
		
	-- EX ME WR s
	--EX/MEM
	signal new_PC_adder_intern3	: STD_LOGIC_VECTOR (INST_SIZE-1 downto 0); 
	signal RT_RD_addr_mux: STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0);
	signal OFFSET_SHIFT2: STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
	signal rt_intern2	: STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
	signal ALU_Flags: ALU_FLAGS;
    signal WB_unit_intern2	: WB_CTRL_REG;
	signal MEM_unit_intern2	: MEM_CTRL_REG;	
	signal ALU_Res: STD_LOGIC_vector (INST_SIZE-1 downto 0); 
	--MEM/WB
    signal WB_unit_intern3	: WB_CTRL_REG;
	signal read_data1 : STD_LOGIC_vector (INST_SIZE-1 downto 0);
    signal addr_result	: STD_LOGIC_vector (INST_SIZE-1 downto 0); 
	signal write_reg : STD_LOGIC_vector (ADDR_SIZE-1 downto 0);	
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
	EXE:
		Execution port map( 
			CLK	 => CLK,
			RESET => RESET,
			WB_CR => WB_unit_intern1,
			MEM_CR => MEM_unit_intern1,
			EX_CR => EX_unit_intern, 	     	
			NEW_PC_ADDR_IN => new_PC_adder_intern2,
			RS => rs_intern,
		    RT 	=> rt_intern1,
			OFFSET	=> offset_intern,
			RT_ADDR	=> rt_addr_intern,
			RD_ADDR	=> rd_addr_intern,
			
			WB_CR_OUT => WB_unit_intern2,
			MEM_CR_OUT => MEM_unit_intern2,
		    PC_ADDR_OUT	=> new_PC_adder_intern3,
			ALU_FLAGS_OUT => ALU_Flags,
			ALU_RES_OUT	=> ALU_Res,
			RT_OUT	=> rt_intern2,
			RT_RD_ADDR_OUT => RT_RD_addr_mux
		);	
		
	MEM_ACC:
		Mem_Con port map( 
		    clk	=>CLK,				
		    reset => RESET,	  				
		    WB_in => WB_unit_intern2,				
		    mem => MEM_unit_intern2,				
		    zero_flag => ALU_Flags.Zero,					
		    PC_addr	=> new_PC_adder_intern3,	
		    addr_in => ALU_Res,	
		    write_data => rt_intern2,	
		    write_reg_in => RT_RD_addr_mux,	
		
		    WB_out => WB_unit_intern3,			
		    read_data => read_data1,	
		    addr_out => addr_result,
		    write_reg_out => write_reg,
			PC_addr_out	=> new_PC_addr_intern,
		    PCSrc => PCSrc_intern
		); 

	WR_BK:
		WriteBack port map( 			
	        reset => RESET,		
	        WB => WB_unit_intern3 ,				
	        read_data => read_data1,	
	        addr => addr_result,	
	        write_reg => write_reg,			
			
	        regWrite => RegWrite_intern,			
	        write_reg_out => write_reg_intern2,	
	        write_data => write_data_intern
        );
	
	--end of EX ME WR

end struct;		