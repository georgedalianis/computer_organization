
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity branch_controler is
    Port (
        b: in std_logic;
        cb: in std_logic;
        cnb: in std_logic;
        alu_zero: in std_logic;
        
        branch_immed: in std_logic_vector(31 downto 0);
        conditional_immed: in std_logic_vector(31 downto 0);
        
        dump: out std_logic;
        chosen_immed: out std_logic_vector(31 downto 0)
    );
end branch_controler;

architecture Structural of branch_controler is

component mux_2 is
    Port (
        A: in std_logic_vector(31 downto 0);    -- Selects A when sel = '1'...
        B: in std_logic_vector(31 downto 0);
        sel: in std_logic;
        output: out std_logic_vector(31 downto 0)
    );
end component;

signal immed_sel_signal: std_logic;

signal x: std_logic;    -- Corresponds to singal branch
signal y: std_logic;    -- Corresponds to signal successfull conditional branch
signal z: std_logic;    -- Corresponds to signal successfull conditional not branch

signal reduced_branch_immed: std_logic_vector(31 downto 0);
signal reduced_conditional_branch_immed: std_logic_vector(31 downto 0);

begin

    x <= b;
    y <= alu_zero and cb;
    z <= (not alu_zero) and cnb;
    
    reduced_branch_immed <= std_logic_vector(unsigned(branch_immed) - x"0004");
    reduced_conditional_branch_immed <= std_logic_vector(unsigned(conditional_immed) - x"0008");

    dump <= (x and (not y)) or y or z;
    immed_sel_signal <= (y or z);
    
    immed_selector: mux_2 port map(
        A => reduced_conditional_branch_immed,
        B => reduced_branch_immed,
        sel => immed_sel_signal,
        output => chosen_immed
    );

end Structural;
