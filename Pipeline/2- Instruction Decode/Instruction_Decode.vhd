library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.MIPS_CONST_PKG.all;


entity Instruction_Decode is
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
end Instruction_Decode;

architecture struct of Instruction_Decode is
	component Reg_file is 
	port (
        clk            : in std_logic;
        reset          : in std_logic;
        reg_write      : in std_logic;
        read_reg1      : in std_logic_vector(ADDR_SIZE-1 downto 0);
        read_reg2      : in std_logic_vector(ADDR_SIZE-1 downto 0);
        write_reg      : in std_logic_vector(ADDR_SIZE-1 downto 0);
        write_data     : in std_logic_vector(INST_SIZE-1 downto 0);
        read_data1     : out std_logic_vector(INST_SIZE-1 downto 0);
        read_data2     : out std_logic_vector(INST_SIZE-1 downto 0)
    );
	end component Reg_file;
	
	component CTRL is
	port( 
		OP			: in	STD_LOGIC_VECTOR (5 downto 0);
	
		EX_signals : out EX_CTRL_REG;
		M_signals  : out MEM_CTRL_REG;
		WB_signals : out WB_CTRL_REG
	);
	end component CTRL;
	
	component ID_EX_Reg is     
	port(
		clk				: in	STD_LOGIC;
		reset				: in	STD_LOGIC;		
		new_PC_addr_in			: in	STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
		offset_in			: in	STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
		rt_addr_in			: in	STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0);
		rd_addr_in			: in	STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0);
		rs_in	 			: in	STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
		rt_in				: in	STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
		WB_in				: in	WB_CTRL_REG;
		M_in				: in	MEM_CTRL_REG;
		EX_in				: in	EX_CTRL_REG;
		new_PC_addr_out			: out	STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
		offset_out			: out	STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
		rt_addr_out			: out	STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0);
		rd_addr_out		: out	STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0);
		rs_out	 			: out	STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
		rt_out				: out	STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
		WB_out				: out	WB_CTRL_REG;
		M_out				: out	MEM_CTRL_REG;
		EX_out				: out	EX_CTRL_REG	
	);
	end component ID_EX_Reg;
	
	component SignExtend is
		port(
		i:in std_logic_vector(15 downto 0);
		o:out  std_logic_vector(31 downto 0)
		);
	end component SignExtend;
	
	signal offset_intern	: STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
	signal rs_intern		: STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
	signal rt_intern		: STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
	signal WB_intern		: WB_CTRL_REG;
	signal M_intern		: MEM_CTRL_REG;
	signal EX_intern		: EX_CTRL_REG;
		
begin
	  REGS: 
	  Reg_file port map(
			clk 		=> clk,
			reset		=> reset,
			reg_write 		=> RegWrite,
			read_reg1 	=> instruction(25 downto 21),
			read_reg2 	=> instruction(20 downto 16),
			write_reg 	=> write_reg,
			write_data	=> write_data,
			read_data1 		=> rs_intern,
			read_data2 		=> rt_intern
		);
		
	Sign:
	SignExtend port map(
		i => instruction(15 downto 0),
		o => offset_intern
	);
	
	CU:
	CTRL port map(
		OP	=> instruction(INST_SIZE-1 downto 26),
		WB_signals => WB_intern, 	 	
		M_signals	=> M_intern, 
		EX_signals	=> EX_intern
	);
	
	ID_EX:
	ID_EX_Reg port map(
		clk	=> clk,
		reset => reset,	
		new_PC_addr_in	=> new_PC_addr_in,
		offset_in => offset_intern,
		rt_addr_in	=> instruction(20 downto 16),
		rd_addr_in	=> instruction(15 downto 11),
		rs_in	 => rs_intern,
		rt_in => rt_intern,
		WB_in => WB_intern,
		M_in => M_intern,
		EX_in => EX_intern,
		new_PC_addr_out	=> new_PC_addr_out,
		offset_out	=> offset,
		rt_addr_out	=> rt_addr,
		rd_addr_out	=> rd_addr,
		rs_out =>  rs,
		rt_out	=> rt,
		WB_out	=> WB_unit,
		M_out	=> M_unit,
		EX_out	=>EX_unit 
	);
	
end struct;