library IEEE;
use IEEE.STD_LOGIC_1164.all;		
use IEEE.numeric_std.all;

library work;
use work.MIPS_CONST_PKG.all;

entity Instruction_Fetching is
	port(
		
		clk		: in STD_LOGIC;		
		reset		: in STD_LOGIC;	
		PCSrc		: in STD_LOGIC;	
		new_PC_addr_in	: in STD_LOGIC_VECTOR(INST_SIZE-1 downto 0);
		
		new_PC_addr_out	: out STD_LOGIC_VECTOR(INST_SIZE-1 downto 0);
		instruction 	: out STD_LOGIC_VECTOR(INST_SIZE-1 downto 0)
	);
end Instruction_Fetching;

architecture struct of Instruction_Fetching is	

   component adder is 
		generic (N: integer := INST_SIZE);
		port(
			x	: in	STD_LOGIC_VECTOR(N-1 downto 0);
			y	: in	STD_LOGIC_VECTOR(N-1 downto 0);
			cin	: in	STD_LOGIC;
			cout	: out	STD_LOGIC;
			sum	: out	STD_LOGIC_VECTOR(N-1 downto 0)
		);
	end component adder;

	component PC_reg is 
		port(
		clk		: in	STD_LOGIC;						
		reset		: in	STD_LOGIC;
		data_in		: in	STD_LOGIC_VECTOR(INST_SIZE-1 downto 0);	
		data_out	: out	STD_LOGIC_VECTOR(INST_SIZE-1 downto 0)
	);
	end component PC_reg;

	component IF_ID_reg is   
		port(
	        clk		    : in	STD_LOGIC;
			reset		: in	STD_LOGIC;
	        PC_addr_in	: in	STD_LOGIC_VECTOR(INST_SIZE-1 downto 0);
	        inst_reg_in	: in	STD_LOGIC_VECTOR(INST_SIZE-1 downto 0);
	        PC_addr_out	: out	STD_LOGIC_VECTOR(INST_SIZE-1 downto 0);
	        inst_reg_out: out	STD_LOGIC_VECTOR(INST_SIZE-1 downto 0)	
        );
	end component IF_ID_reg;

	component InstrMemory is
		port (
	        address          : in  std_logic_vector(31 downto 0);
	        Instruction : out std_logic_vector(31 downto 0)
	    );
	end component InstrMemory;
	
	component Mux is
		generic(
			n : integer := INST_SIZE
		);
		port(
		in0:in std_logic_vector(n-1 downto 0); 
		in1:in std_logic_vector(n-1 downto 0);
		selector: in std_logic;
		output:out std_logic_vector(n-1 downto 0)
		);
	end component Mux;
	
	signal PC_addr_intern1	: STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);	--PC
	signal PC_addr_intern2	: STD_LOGIC_VECTOR (INST_SIZE downto 0);	-- PC + Carry out
	signal PC_addr_intern3	: STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);	--MUX_PC  
	signal inst_intern		: STD_LOGIC_VECTOR (INST_SIZE-1 downto 0);
	
	begin
	myADDER :
		adder generic map (N => INST_SIZE)
		port map(
			x	=> PC_addr_intern1,
			y	=> PC_COUNT, --add fixed 4 
			cin	=> '0',
			cout	=> PC_addr_intern2(INST_SIZE),
			sum	=> PC_addr_intern2(INST_SIZE-1 downto 0)
		);
		
	MUX_PC:
	Mux generic map(
			n => INST_SIZE
		)
	port map(
		in0 => PC_addr_intern2(INST_SIZE-1 downto 0), 
		in1 => new_PC_addr_in,
		selector => PCSrc,
		output => PC_addr_intern3
	);
	
	PC : 
		PC_reg port map(
			clk		=> clk,
			reset		=> reset,
			data_in		=> PC_addr_intern3,
			data_out	=> PC_addr_intern1
		);
		
	INST_MEM:
		InstrMemory port map(
			address	=>	PC_addr_intern1,
			Instruction	=> 	inst_intern
		);
		
	IF_ID:
		IF_ID_reg port map(
			clk		=> clk,
			reset		=> reset,
			PC_addr_in	=> PC_addr_intern2(INST_SIZE-1 downto 0),
			inst_reg_in	=> inst_intern,
			PC_addr_out	=> new_PC_addr_out,
			inst_reg_out	=> instruction
		);		
end struct;