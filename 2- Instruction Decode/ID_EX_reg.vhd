library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.MIPS_CONST_PKG.all;



entity ID_EX_reg is 
	port(
		clk				: in	STD_LOGIC;
		reset				: in	STD_LOGIC;	
		new_PC_addr_in			: in	STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
		 --instr
		offset_in			: in	STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);--n  [15-0]
		rt_addr_in			: in	STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0);--RT [20-16]
		rd_addr_in			: in	STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0);--RD [15-11]
		--Reg File
		rs_in	 			: in	STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);-- RS [25-21]
		rt_in				: in	STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
		 --CU
		WB_in				: in	WB_CTRL_REG;
		M_in				: in	MEM_CTRL_REG;
		EX_in				: in	EX_CTRL_REG;
		
		
		new_PC_addr_out			: out	STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
		 --instr
		offset_out			: out	STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
		rt_addr_out			: out	STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0);
		rd_addr_out		: out	STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0);
		 --Reg File
		rs_out	 			: out	STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
		rt_out				: out	STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
		 --CU
		WB_out				: out	WB_CTRL_REG;
		M_out				: out	MEM_CTRL_REG;
		EX_out				: out	EX_CTRL_REG	
	);
end ID_EX_reg;

architecture rtl of ID_EX_reg is
begin
	SYNC_ID_EX:
	  process(clk,reset)
	  begin
		if reset = '1' then
				new_PC_addr_out		<= (others => '0');
				offset_out		<= (others => '0');
				rt_addr_out		<= (others => '0');
				rd_addr_out		<= (others => '0');
				rs_out	 		<= (others => '0');
				rt_out 			<= (others => '0');
				WB_OUT			<= ('0','0');
				M_OUT			<= ('0','0','0');
				EX_OUT			<= ('0',('0','0'),'0');
		elsif rising_edge(clk) then
				new_PC_addr_out		<= new_PC_addr_in;
				offset_out		<= offset_in;
				rt_addr_out 	<= rt_addr_in;
				rd_addr_out		<= rd_addr_in;	
				rs_out	 		<= rs_in;
				rt_out 			<= rt_in;
				WB_out			<= WB_in;
				M_out			<= M_in;
				EX_out			<= EX_in;
		end if;
	  end process;

end rtl;