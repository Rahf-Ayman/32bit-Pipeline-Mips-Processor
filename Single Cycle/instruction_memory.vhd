


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
         0 => x"FFFFFFFF",
	    1 => x"20010005", -- addi $1, $0 ,5
	    2 => x"00000000",  
	    3 => x"8C290000", -- lw $t1, 0($1)  $t3 reg 1 mem[$1 = 5] -> $t0  Reg[8] = 01000512
	    4 => x"AC020009", -- used by beq $t0, $t1, 2
	    5 => x"8C280000", -- lw $t0, 0($1)  $t3 reg 1 mem[$1 = 5] -> $t0  Reg[8] = 01000512
		6 => x"AC010018", -- sw $1, 24($0)
		7 => x"11090004", -- beq $t0, $t1, 4 at add 28 branched to 28 + 4 + 4 * 4
		8 => x"EEEEEEE4",
		9 => x"EEEEEEE3",
		10 => x"EEEEEEE2",
		11 => x"EEEEEEE1",
		12 => x"EEEEEEEE", -- at 48	address x"30"
	    others => x"00000000"
    );

begin

    -- PC / 4 = use bits [9:2] as word index (8 bit fit mem size)
    Instruction <= MEM(to_integer(unsigned(address(9 downto 2))));

end Behavioral;