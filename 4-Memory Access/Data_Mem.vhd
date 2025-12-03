library std;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;		

library work;
use work.MIPS_CONST_PKG.all; 

entity Data_Mem is
	generic (n :NATURAL; m :NATURAL);
	port(
		reset		:	in  STD_LOGIC;			
		addr		:	in  STD_LOGIC_VECTOR (n-1 downto 0);
		write_data	:	in  STD_LOGIC_VECTOR (n-1 downto 0);
		memRead		:	in  STD_LOGIC;			
		memWrite	:	in  STD_LOGIC;		
		read_data	:	out STD_LOGIC_VECTOR (n-1 downto 0)
	);
end Data_Mem; 

architecture Data_Mem_arc of Data_Mem is
  
	type mem_temp is array (m-1 downto 0) of STD_LOGIC_VECTOR (n-1 downto 0);
	signal mem : mem_temp;
  
begin

	MEM_PROC:
		process(reset,memWrite,memRead,write_data,MEM,addr)
		begin	
			if (reset = '1') then
				for i in 0 to m-1 loop
					mem(i) <= (others => '1');  --it's common to have zeros in memory but rare to have all ones (-1)
				end loop;
			elsif memWrite='1' then 
				mem(to_integer(unsigned( addr(9 downto 0) ))) <= write_data;   -- mem with size 1024 so take 9 down to 0
			elsif memRead='1' then
			    	read_data <= mem(to_integer(unsigned( addr(9 downto 0) )));
			end if;
		end process MEM_PROC;

end Data_Mem_arc;