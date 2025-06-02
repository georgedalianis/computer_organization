
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity exstage is
    Port (
        rf_a: in std_logic_vector(31 downto 0);
        rf_b: in std_logic_vector(31 downto 0);
        immed: in std_logic_vector(31 downto 0);
        alu_bin_sel: in std_logic;
        alu_func: in std_logic_vector(3 downto 0);
        
        alu_zero: out std_logic;
        alu_out: out std_logic_vector(31 downto 0)
    );
end exstage;

architecture Structural of exstage is

component alu is
    Port (
        a: in std_logic_vector(31 downto 0);
        b: in std_logic_vector(31 downto 0);
        op: in std_logic_vector(3 downto 0);
        
        output: out std_logic_vector(31 downto 0);
        zero: out std_logic;
        cout: out std_logic;
        ovf: out std_logic
    );
end component;

component mux_2 is
    Port (
        a: in std_logic_vector(31 downto 0);
        b: in std_logic_vector(31 downto 0);
        ctrl: in std_logic;
        
        output: out std_logic_vector(31 downto 0)
    );
end component;

signal selected_b: std_logic_vector(31 downto 0);

begin

    b_selector: mux_2 port map(
        a => rf_b,
        b => immed,
        ctrl => alu_bin_sel,
        output => selected_b
    );

    compute: alu port map(
        a => rf_a,
        b => selected_b,
        op => alu_func,
        output => alu_out,
        zero => alu_zero
    );


end Structural;
