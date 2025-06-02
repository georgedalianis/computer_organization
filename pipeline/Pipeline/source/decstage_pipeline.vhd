library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decstage_pipeline is
    Port (
        clock: in std_logic;
        reset: in std_logic;
        
        instr: in std_logic_vector(31 downto 0);
        
        rf_wren: in std_logic;
        alu_out: in std_logic_vector(31 downto 0);
        mem_out: in std_logic_vector(31 downto 0);
        rf_wrdata_sel: in std_logic;
        address_write: in std_logic_vector(4 downto 0);
        
        rf_b_sel: in std_logic;
        
        imm_ext: in std_logic_vector(1 downto 0);
        
        immed: out std_logic_vector(31 downto 0);
        rf_a: out std_logic_vector(31 downto 0);
        rf_b: out std_logic_vector(31 downto 0)
    );
end decstage_pipeline;

architecture Structural of decstage_pipeline is

component register_file is
    Port (
        clock: in std_logic;
        reset: in std_logic;
        write_enable: in std_logic;
        
        ard1: in std_logic_vector(4 downto 0);
        ard2: in std_logic_vector(4 downto 0);
        awr: in std_logic_vector(4 downto 0);
        
        din: in std_logic_vector(31 downto 0);
        dout1: out std_logic_vector(31 downto 0);
        dout2: out std_logic_vector(31 downto 0)
    );
end component;

component mux_2 is
    Port (
        A: in std_logic_vector(31 downto 0);
        B: in std_logic_vector(31 downto 0);
        sel: in std_logic;
        output: out std_logic_vector(31 downto 0)
    );
end component;

component immed_extender is
    Port (
        input_immed: in std_logic_vector(15 downto 0);
        operation: in std_logic_vector(1 downto 0);
        
        extended_immed: out std_logic_vector(31 downto 0)
    );
end component;

signal mux_output: std_logic_vector(4 downto 0);
signal selected_din: std_logic_vector(31 downto 0);

begin

    mux_output <= instr(20 downto 16) when rf_b_sel = '1' else instr(15 downto 11);

    registers: register_file port map(
        clock => clock,
        reset => reset,
        write_enable => rf_wren,
        
        ard1 => instr(25 downto 21),
        ard2 => mux_output,
        awr => address_write,
        din => selected_din,
        
        dout1 => rf_a,
        dout2 => rf_b
    );
    
    input_selector: mux_2 port map(
        A => mem_out,
        B => alu_out,
        sel => rf_wrdata_sel,
        output => selected_din
    );
    
    immediate_extender: immed_extender port map(
        input_immed => instr(15 downto 0),
        operation => imm_ext,
        extended_immed => immed
    );

end Structural;
