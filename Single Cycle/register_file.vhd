


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file is
    port (
        clk            : in std_logic;
        reset          : in std_logic;
        reg_write      : in std_logic;
        read_reg1      : in std_logic_vector(4 downto 0);
        read_reg2      : in std_logic_vector(4 downto 0);
        write_reg      : in std_logic_vector(4 downto 0);
        write_data     : in std_logic_vector(31 downto 0);
        read_data1     : out std_logic_vector(31 downto 0);
        read_data2     : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of register_file is
    type reg_array is array (0 to 31) of std_logic_vector(31 downto 0);
    signal registers : reg_array := (
	 0 => x"00000000",  -- Register 0
    1 => x"00000001",  -- Register 1
    2 => x"00000002",  -- Register 2
    3 => x"00000003",  -- Register 3
    4 => x"00000004",  -- Register 4
    5 => x"00000005",  -- Register 5
    6 => x"00000006",  -- Register 6
    7 => x"00000007",  -- Register 7
    8 => x"00000008",  -- Register 8
    9 => x"00000009",  -- Register 9
    10 => x"0000000A", -- Register 10
    11 => x"0000000B", -- Register 11
    12 => x"0000000C", -- Register 12
    13 => x"0000000D", -- Register 13
    14 => x"0000000E", -- Register 14
    15 => x"0000000F", -- Register 15
    others => (others => '0')  -- Initialize remaining registers to 0

	);
begin

   process(clk, reset)
   begin
	   if(reset = '1') then
				registers <= (others => (others => '0'));
		elsif rising_edge(clk) then
			if  reg_write ='1' then
				if write_reg /= "00000" then -- $zero not changed
				    registers(to_integer(unsigned(write_reg))) <= write_data;
				end if;
			end if;
		end if;
    end process;

    read_data1 <= registers(to_integer(unsigned(read_reg1)));
    read_data2 <= registers(to_integer(unsigned(read_reg2)));

end architecture;
