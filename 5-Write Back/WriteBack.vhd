library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.MIPS_CONST_PKG.all;

entity WriteBack is
port( 
	reset		: in STD_LOGIC;		
	WB			: in WB_CTRL_REG;				
	read_data	: in STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);	
	addr		: in STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);	
	write_reg	: in STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0);			
	
	regWrite	: out STD_LOGIC;			
	write_reg_out	: out STD_LOGIC_VECTOR (ADDR_SIZE-1 downto 0);	
	write_data	: out STD_LOGIC_VECTOR (INST_SIZE-1 downto 0)
);
end WriteBack;

architecture WriteBack_arc of WriteBack is 

   component Mux2to1 is
		generic (n:integer:=32);
	    port(
		in0: in std_logic_vector(n-1 downto 0); 
		in1:in std_logic_vector(n-1 downto 0);
		selector:in std_logic;
		output:out std_logic_vector(n-1 downto 0));
   end component Mux2to1;
   signal mux_output : STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
begin
	
	 MUX_DATA: Mux2to1 
        generic map (n => INST_SIZE)
        port map(
            in0     => addr,      
            in1     => read_data,    
            selector=> WB.MemtoReg,  
            output  => mux_output
        );		
		
	WB_PROC: process(reset, mux_output, write_reg, WB)
    begin
        if reset = '1' then
            regWrite <= '0';
            write_reg_out <= (others => '0');  
            write_data <= (others => '0');    
        else
            regWrite <= WB.RegWrite;
            write_reg_out <= write_reg;
            write_data <= mux_output;       
        end if;
    end process WB_PROC;
end WriteBack_arc;