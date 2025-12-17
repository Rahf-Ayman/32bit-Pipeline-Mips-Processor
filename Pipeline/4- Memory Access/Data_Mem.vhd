
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;		

library work;
use work.MIPS_CONST_PKG.all; 

entity Data_Mem is
	generic (n :integer; m :integer);
	port(	
		clk         : in  STD_LOGIC; 		
		addr		:	in  STD_LOGIC_VECTOR (n-1 downto 0);
		write_data	:	in  STD_LOGIC_VECTOR (n-1 downto 0);
		memRead		:	in  STD_LOGIC;			
		memWrite	:	in  STD_LOGIC;		
		read_data	:	out STD_LOGIC_VECTOR (n-1 downto 0)
	);
end Data_Mem; 

architecture Data_Mem_arc of Data_Mem is
  
	type mem_temp is array (m-1 downto 0) of STD_LOGIC_VECTOR (7 downto 0);
	signal mem : mem_temp := (
         0 => x"8C", 1 => x"28", 2 => x"00", 3 => x"00",  -- 0x8C280000
	    4 => x"20", 5 => x"01", 6 => x"00", 7 => x"05",  -- 0x20010005
	    8 => x"12", 9 => x"34", 10 => x"56", 11 => x"78", -- 0x12345678
	    12 => x"20", 13 => x"08", 14 => x"00", 15 => x"0A", -- 0x2008000A
	    16 => x"AC", 17 => x"02", 18 => x"08", 19 => x"88", -- 0xAC020888
	    20 => x"20", 21 => x"08", 22 => x"00", 23 => x"01", -- 0x20080001
	    others => x"00"
    );
  
begin
    READ_PROC: process(memRead, mem, addr)
        variable base_addr : integer range 0 to m-1;
    begin
         base_addr := to_integer(unsigned(addr(9 downto 0))); 
        
        if memRead='1' then
            if base_addr <= m-4 then
                read_data <= 
                    mem(base_addr) &
                    mem(base_addr + 1) &
                    mem(base_addr + 2) &
                    mem(base_addr + 3);
            else
                read_data <= (others => '0');
            end if;
        else
            read_data <= (others => 'Z');
        end if;
    end process READ_PROC;

    WRITE_PROC: process(clk)
        variable base_addr : integer range 0 to m-1;
    begin
        if rising_edge(clk) then
             base_addr := to_integer(unsigned(addr(9 downto 0))); 
            
            if memWrite='1' then
                if base_addr <= m-4 then
                    mem(base_addr)     <= write_data(31 downto 24); 
                    mem(base_addr + 1) <= write_data(23 downto 16); 
                    mem(base_addr + 2) <= write_data(15 downto  8); 
                    mem(base_addr + 3) <= write_data( 7 downto  0);
                end if;
            end if;
        end if;
    end process WRITE_PROC;
end Data_Mem_arc;