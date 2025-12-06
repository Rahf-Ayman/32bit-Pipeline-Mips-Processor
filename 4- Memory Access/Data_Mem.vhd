library std;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;		

library work;
use work.MIPS_CONST_PKG.all; 

entity Data_Mem is
	generic (n :integer; m :integer);
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
	signal mem : mem_temp := (
         0 => x"8C280000",
	    1 => x"20010005",
	    2 => x"12345678",
	    3 => x"2008000A",
	    4 => x"AC020888",
	    5 => x"20080001",
	    others => x"00000000"
    );
  
begin

	MEM_PROC:
		process(memWrite,memRead,write_data,MEM,addr)
		begin	
			if (reset = '1') then
				for i in 0 to m-1 loop
					mem(i) <= (others => '1');  --it's common to have zeros in memory but rare to have all ones (-1)
				end loop;
			else 
			    base_addr := to_integer(unsigned(addr));
				if memWrite = '1' then
                   mem(base_addr)     <= write_data(31 downto 24); 
                   mem(base_addr + 1) <= write_data(23 downto 16); 
                   mem(base_addr + 2) <= write_data(15 downto  8); 
                   mem(base_addr + 3) <= write_data( 7 downto  0); 
				end if;
				if memRead = '1' then
                    read_data <= 
                        mem(base_addr) &
                        mem(base_addr + 1) &
                        mem(base_addr + 2) &
                        mem(base_addr + 3);
                end if;
			end if;
		end process MEM_PROC;

end Data_Mem_arc;