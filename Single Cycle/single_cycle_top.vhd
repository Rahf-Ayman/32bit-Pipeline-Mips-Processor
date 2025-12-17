library ieee;							   
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity single_cycle_top is
    Port(
        clk : in STD_LOGIC;
        reset : in STD_LOGIC
    );
end single_cycle_top;



architecture Behavioral of single_cycle_top is	

-- #############################   components    #############################
component ControlUnit
	port(
		OP : in  STD_LOGIC_VECTOR(5 downto 0);
        RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch : out STD_LOGIC;   						 
        ALUOp : out STD_LOGIC_VECTOR(1 downto 0)	
	);
end component;

component sign_extend is
  port( 
        extend_in  : in std_logic_vector(15 downto 0);
        extend_out : out std_logic_vector(31 downto 0) );
end component;	
	
component ALU is
	port(
	alu_op1	: in std_logic_vector(31 downto 0);	 
	alu_op2	: in std_logic_vector(31 downto 0);	
	ALUControl  : in std_logic_vector(3 downto 0); 	
	alu_result		: out std_logic_vector(31 downto 0); 
	zero		: out std_logic );		  
end component;

component InstrMemory is
    port (
        address          : in  std_logic_vector(31 downto 0);
        Instruction : out std_logic_vector(31 downto 0)
    );
end component;

component Mux is
  port( 
 		 mux_in1 : in std_logic_vector(31 downto 0 );
 		 mux_in2 : in std_logic_vector(31 downto 0 ); 
		 mux_select : in std_logic;
 		 mux_out : out std_logic_vector(31 downto 0 ) );
end component;

component pc is
    Port (
        clk , reset    : in  STD_LOGIC;
        pc_in   : in  STD_LOGIC_VECTOR(31 downto 0);
        pc_out  : out STD_LOGIC_VECTOR(31 downto 0)
    );
end component;

component register_file is
    port (
        clk , reset : in std_logic;
        reg_write : in std_logic;
        read_reg1, read_reg2  : in std_logic_vector(4 downto 0);
        write_reg      : in std_logic_vector(4 downto 0);
        write_data     : in std_logic_vector(31 downto 0);
        read_data1 , read_data2 : out std_logic_vector(31 downto 0)
    );
end component;

component adder is	
	port (
		adder_in1,adder_in2: in std_logic_vector(31 downto 0);
		adder_out: out std_logic_vector(31 downto 0)
	);
end component;	

component ShiftLeft2 is
  port( 
        SHL_input  : in std_logic_vector(31 downto 0);
        SHL_output : out std_logic_vector(31 downto 0) );
end component;
  
component data_memory is 
	port(
	clk, MemWrite, MemRead: in STD_LOGIC;
	address, write_data: in STD_LOGIC_VECTOR (31 downto 0);
	read_data: out STD_LOGIC_VECTOR (31 downto 0));
end component;   

component ALUControl is
  port(
    ALUOp      : in  std_logic_vector(1 downto 0);
    funct      : in  std_logic_vector(5 downto 0);
    ALUControl : out std_logic_vector(3 downto 0) );
end component;


-- #######################    Signals    ###########################

signal pc_current, pc_next, pc_plus_4 : std_logic_vector(31 downto 0);
signal instruction : std_logic_vector(31 downto 0);	-- instruction coming from instruction memory
signal reg_read1, reg_read2 : std_logic_vector(31 downto 0); -- rs (instruction[25:21]) ? rt (instruction[20:16])
signal write_back_data : std_logic_vector(31 downto 0); -- data written back into register file (ALU result or memory data)
signal extend_out : std_logic_vector(31 downto 0); -- sign-extended immediate (from instruction[15:0])
signal shifted_out : std_logic_vector(31 downto 0); --used for branch target address
signal alu_src_out : std_logic_vector(31 downto 0);-- second ALU operand after ALUSrc mux 
signal alu_result : std_logic_vector(31 downto 0);-- result produced by the ALU
signal zero_flag : std_logic;  -- ALU zero flag
signal mem_read_data : std_logic_vector(31 downto 0);-- data read from Data Memory during LW
signal RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch : std_logic;-- control unit signals
signal ALUOp  : std_logic_vector(1 downto 0); --telling ALU Control which operation group
signal ALUCtr : std_logic_vector(3 downto 0);  --ALU control lines (AND,OR,ADD,SUB .....)
signal write_reg : std_logic_vector(4 downto 0); -- selected register number to write in register file
signal branch_target : std_logic_vector(31 downto 0); -- PC+4 + (immediate<<2)
signal branch_mux_out : std_logic_vector(31 downto 0);-- output of branch mux
signal branch_and_zero : std_logic;	-- becomes 1 only when we have a BEQ instruction and the ALU result is zero (rs == rt)
signal write_reg_rt : std_logic_vector(31 downto 0);-- instruction[20:16]
signal write_reg_rd : std_logic_vector(31 downto 0);-- instruction[15:11]

-- #############################   CONNECTIONS    #############################

begin
-- PC
PC_Main: pc
    port map(
        clk    => clk,
        reset  => reset,
        pc_in  => pc_next,
        pc_out => pc_current
    );

-- Instruction Memory
IM: InstrMemory
    port map(
        address => pc_current,
        Instruction => instruction
    );

-- PC + 4
ADD_PC: adder
    port map(
        adder_in1 => pc_current,
        adder_in2 => x"00000004",
        adder_out => pc_plus_4
    );

-- Control Unit
CTRL: ControlUnit
    port map(
        OP    => instruction(31 downto 26),
        RegDst    => RegDst,
        ALUSrc    => ALUSrc,
        MemtoReg  => MemtoReg,
        RegWrite  => RegWrite,
        MemRead   => MemRead,
        MemWrite  => MemWrite,
        Branch    => Branch,
        ALUOp     => ALUOp
    );

write_reg_rt <= (31 downto 5 => '0') & instruction(20 downto 16);
write_reg_rd <= (31 downto 5 => '0') & instruction(15 downto 11);

-- Register Destination Mux
RegDst_MUX: Mux
    port map(
        mux_in1 => write_reg_rt,
	    mux_in2 => write_reg_rd,
        mux_select => RegDst,
        mux_out    => open -- 32-bit, we need only 5 bits, fix below
    );

-- Correct 5-bit write register selection
write_reg <= instruction(20 downto 16) when RegDst = '0' else instruction(15 downto 11);

-- Register File
RF: register_file
    port map(
        clk        => clk,
        reset      => reset,
        reg_write  => RegWrite,
        read_reg1  => instruction(25 downto 21),
        read_reg2  => instruction(20 downto 16),
        write_reg  => write_reg,
        write_data => write_back_data,
        read_data1 => reg_read1,
        read_data2 => reg_read2
    );

-- Sign Extension
SE: sign_extend
    port map(
        extend_in  => instruction(15 downto 0),
        extend_out => extend_out
    );

-- ALU Src Mux
ALUSRC_MUX: Mux
    port map(
        mux_in1    => reg_read2,
        mux_in2    => extend_out,
        mux_select => ALUSrc,
        mux_out    => alu_src_out
    );

-- ALU Control
ALUCTRL: ALUControl
    port map(
        ALUOp      => ALUOp,
        funct      => instruction(5 downto 0),
        ALUControl => ALUCtr
    );

-- ALU
ALU_MAIN: ALU
    port map(
        alu_op1    => reg_read1,
        alu_op2    => alu_src_out,
        ALUControl => ALUCtr,
        alu_result => alu_result,
        zero       => zero_flag
    );

-- Data Memory
DM: data_memory
    port map(
        clk        => clk,
        MemWrite   => MemWrite,
        MemRead    => MemRead,
        address    => alu_result,
        write_data => reg_read2,
        read_data  => mem_read_data
    );

-- Write back Mux
WB_MUX: Mux
    port map(
        mux_in1    => alu_result,
        mux_in2    => mem_read_data,
        mux_select => MemtoReg,
        mux_out    => write_back_data
    );

-- Shift-left-2 of immediate
SHL: ShiftLeft2
    port map(
        SHL_input  => extend_out,
        SHL_output => shifted_out
    );

-- Branch Address = PC + 4 + shifted immediate
ADD_BRANCH: adder
    port map(
        adder_in1 => pc_plus_4,
        adder_in2 => shifted_out,
        adder_out => branch_target
    );

-- Branch Decision
branch_and_zero <= Branch AND zero_flag;

-- PC Mux (branch or sequential)
PC_MUX: Mux
    port map(
        mux_in1    => pc_plus_4,
        mux_in2    => branch_target,
        mux_select => branch_and_zero,
        mux_out    => pc_next
    );

end Behavioral;
