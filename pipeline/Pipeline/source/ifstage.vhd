library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity ifstage is
    Port (
        clock: in std_logic;
        reset: in std_logic;
        
        pc_lden: in std_logic;
        pc_sel: in std_logic;
        
        pc_immed: in std_logic_vector(31 downto 0);
        pc: out std_logic_vector(31 downto 0)
    );
end ifstage;

architecture Structural of ifstage is

component register_32 is
    Port (
        clock: in std_logic;
        reset: in std_logic;
        write_enable: in std_logic;
        
        datain: in std_logic_vector(31 downto 0);
        dataout: out std_logic_vector(31 downto 0)
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

signal pc_input: std_logic_vector(31 downto 0);
signal pc_output: std_logic_vector(31 downto 0);

signal input_mux_a: std_logic_vector(31 downto 0);
signal input_mux_b: std_logic_vector(31 downto 0);

begin

    pc <= pc_output;
    
    input_mux_a <= std_logic_vector(unsigned(pc_output) + x"00000004" + unsigned(pc_immed));
    input_mux_b <= std_logic_vector(unsigned(pc_output) + x"00000004");
    
    program_counter: register_32 port map(
        clock => clock,
        reset => reset,
        write_enable => pc_lden,
        datain => pc_input,
        dataout => pc_output
    );
    
    pc_selector: mux_2 port map(
        sel => pc_sel,
        output => pc_input,
        A => input_mux_a,
        B => input_mux_b
    );
    
end Structural;