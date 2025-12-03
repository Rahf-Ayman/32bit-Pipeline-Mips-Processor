

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity fullAdder is 
    port(
	        x	: in	std_logic;
	        y	: in	std_logic;
	        cin	: in	std_logic;
	        cout	: out	std_logic;
	        sum	: out	std_logic
        );
end fullAdder;

architecture behave of fullAdder is


signal G,P,K : std_logic;

begin
	G <= x and y;
	P <= x xor y;
	cout <= G or ( P and cin );
	sum <= p xor cin;    
end behave;