library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
 
entity adder is 
	generic (N: natural);
	port(
		x	: in	STD_LOGIC_VECTOR(N-1 downto 0);
		y	: in	STD_LOGIC_VECTOR(N-1 downto 0);
		cin	: in	STD_LOGIC;
		cout	: out	STD_LOGIC;
		sum	: out	STD_LOGIC_VECTOR(N-1 downto 0)
	);
end adder;

architecture struct of adder is
  
	component fullAdder is
	    port(
	        x	: in	std_logic;
	        y	: in	std_logic;
	        cin	: in	std_logic;
	        cout	: out	std_logic;
	        sum	: out	std_logic
        );
	end component fullAdder;

	signal C_signal :	STD_LOGIC_VECTOR (N-1 downto 0);
      
begin

	first_Full:
		fullAdder port map (
			x	=> x(0),
			y	=> y(0),
			cin	=> cin,
			cout	=> C_signal(0),
			sum	=> sum(0)
		);
		
	gen_unit:
		for i in 1 to N-1 generate
			next_Full:
				fullAdder port map (
					x	=> x(i),
					y	=> y(i),	
					cin	=> C_signal(i-1),
					cout=> C_signal(i),
					sum	=> sum(i)
				);
		end generate;
	cout <= C_signal(N - 1);
	
end struct;