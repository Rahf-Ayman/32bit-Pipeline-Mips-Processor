library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.MIPS_CONST_PKG.all;

entity Mem_Con is
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
end Mem_Con;

architecture Mem_Con_arc of Mem_Con is

	
    component Data_Mem is
	    generic (n :integer; m :integer);
	    port(
		   reset		:	in  STD_LOGIC;			
		   addr		:	in  STD_LOGIC_VECTOR (n-1 downto 0);
		   write_data	:	in  STD_LOGIC_VECTOR (n-1 downto 0);
		   memRead		:	in  STD_LOGIC;			
		   memWrite	:	in  STD_LOGIC;		
		   read_data	:	out STD_LOGIC_VECTOR (n-1 downto 0)
		   );
	end component Data_Mem;

	component WB_Reg is port(
		clk		: in STD_LOGIC;
		reset		: in STD_LOGIC;
		WB		: in WB_CTRL_REG;
		read_data	: in STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
		addr		: in STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
		write_reg	: in STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0);	
		WB_out		: out WB_CTRL_REG;
		read_data_out	: out STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
		addr_out	: out STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
		write_reg_out	: out STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0)
	);
	end component WB_Reg;
	 
	signal read_data_mem : STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
 
begin

	 Bran_Mem:	
		process(reset,zero_flag,mem.Branch,PC_addr)
		begin
			if( RESET = '1') then
				PCSrc <= '0';
				PC_addr_out <= ZERO32b;
			else
				PCSrc <= zero_flag and mem.Branch;
				PC_addr_out <= PC_addr;
			end if;
		end process Bran_Mem;

	Data_Memory:
		Data_Mem generic map (n=>INST_SIZE, m=>NUM_ADDR)
	 	port map(
			addr		=> addr_in,
			write_data	=> write_data,
			memRead		=> mem.MemRead,
			memWrite	=> mem.MemWrite,
			read_data	=> read_data_mem
		);
	
	Mem_WB_Reg:
		WB_Reg port map(
			clk	=> clk,
			reset => reset,
			WB	=> WB_in,
			read_data => read_data_mem,
			addr => addr_in,
			write_reg => write_reg_in,
			WB_out	=> WB_out,
			read_data_out => read_data,
			addr_out => addr_out,	
			write_reg_out => write_reg_out 
		);


end Mem_Con_arc;