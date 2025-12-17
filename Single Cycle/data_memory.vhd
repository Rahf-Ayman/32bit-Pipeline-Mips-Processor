


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity data_memory is 
	port(clk, MemWrite, MemRead: in STD_LOGIC;
	address, write_data: in STD_LOGIC_VECTOR (31 downto 0);
	read_data: out STD_LOGIC_VECTOR (31 downto 0));
end;   

architecture Behavioral of data_memory is	
type mem_temp is array (60 downto 0) of STD_LOGIC_VECTOR (7 downto 0);
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

  process(CLK)
  variable addr : integer;
begin
  if rising_edge(CLK) then
    if MemWrite = '1' then
      addr := to_integer(unsigned(address));
      if addr <= 57 then  -- prevent overflow 
        mem(addr)     <= write_data(31 downto 24);
        mem(addr + 1) <= write_data(23 downto 16);
        mem(addr + 2) <= write_data(15 downto 8);
        mem(addr + 3) <= write_data(7  downto 0);
      end if;
    end if;
  end if;
end process;

-- Combinational read (with bound checking)
read_data <=
  mem(to_integer(unsigned(address)))     &
  mem(to_integer(unsigned(address)) + 1) &
  mem(to_integer(unsigned(address)) + 2) &
  mem(to_integer(unsigned(address)) + 3) when
    (MemRead = '1' and to_integer(unsigned(address)) <= 60)
else (others => '0');
end architecture ;
