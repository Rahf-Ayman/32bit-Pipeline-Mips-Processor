library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InstrMemory is
    port (
        address          : in  std_logic_vector(31 downto 0);
        Instruction : out std_logic_vector(31 downto 0)
    );
end InstrMemory;

architecture Behavioral of InstrMemory is

    type mem_type is array(0 to 255) of std_logic_vector(31 downto 0);
    signal MEM : mem_type := (
        0 => x"01402020",
        1 => x"00000022",
        others => x"00000000"
    );

begin

    -- PC / 4 = use bits [9:2] as word index (8 bit fit mem size)
    Instruction <= MEM(to_integer(unsigned(address(9 downto 2))));

end Behavioral;