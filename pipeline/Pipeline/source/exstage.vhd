library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity exstage is
    Port (
        rf_a: in std_logic_vector(31 downto 0);
        rf_b: in std_logic_vector(31 downto 0);
        immed: in std_logic_vector(31 downto 0);
        
        alu_bin_sel: in std_logic;
        
        alu_func: in std_logic_vector(3 downto 0);
        alu_out: out std_logic_vector(31 downto 0);
        alu_zero: out std_logic
    );
end exstage;

architecture Structural of exstage is

component mux_2 is
    Port (
        A: in std_logic_vector(31 downto 0);
        B: in std_logic_vector(31 downto 0);
        sel: in std_logic;
        output: out std_logic_vector(31 downto 0)
    );
end component;

component alu is
    Port (
        A: in std_logic_vector(31 downto 0);
        B: in std_logic_vector(31 downto 0);
        op: in std_logic_vector(3 downto 0);
        
        output: out std_logic_vector(31 downto 0);
        zero: out std_logic;
        cout: out std_logic;
        ovf: out std_logic
    );
end component;

signal mux_output: std_logic_vector(31 downto 0);

begin

    input_selector: mux_2 port map(
        A => immed,
        B => rf_b,
        sel => alu_bin_sel,
        output => mux_output
    );
    
    executor: alu port map(
        A => rf_a,
        B => mux_output,
        op => alu_func,
        zero => alu_zero,
        output => alu_out,
        cout => open,
        ovf => open
    );

end Structural;
