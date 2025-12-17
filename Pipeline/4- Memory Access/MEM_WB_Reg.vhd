library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.MIPS_CONST_PKG.all;

entity WB_Reg is port(
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
end WB_Reg;

architecture WB_Reg_arc of WB_Reg is        
begin
	SYNC_MEM_WB:
		process(clk,reset)
		begin
			if reset = '1' then
			    WB_out	<= ('0','0');
				read_data_out	<= ZERO32b;
				addr_out <= ZERO32b;
				write_reg_out	<= "00000";
			elsif rising_edge(clk) then
			    WB_out		<= WB;
				read_data_out<= read_data;
				addr_out	<= addr;
				write_reg_out<= write_reg;
			end if;
		end process; 

end WB_Reg_arc;