library IEEE;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_1164.ALL;

entity ifstage is
    Port (
        clk: in std_logic;
        rst: in std_logic;
        pc_lden: in std_logic;
        pc_sel: in std_logic;
        pc_immed: in std_logic_vector(31 downto 0);
        
        instr_addr: out std_logic_vector(31 downto 0)
    );
end ifstage;

architecture Behavioral of ifstage is

component register32 is
    Port (
        clk: in std_logic;
        data: in std_logic_vector(31 downto 0);
        we: in std_logic;
        rst: in std_logic;
        
        dout: out std_logic_vector(31 downto 0)
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

signal mux_out: std_logic_vector(31 downto 0);
signal sig_instr_addr: std_logic_vector(31 downto 0);

signal mux_in_a: std_logic_vector(31 downto 0);
signal mux_in_b: std_logic_vector(31 downto 0);

begin

    instr_addr <= sig_instr_addr;
    
    mux_in_a <= std_logic_vector(unsigned(sig_instr_addr) + x"00000004" + unsigned(pc_immed));
    mux_in_b <= std_logic_vector(unsigned(sig_instr_addr) + x"00000004");

    PC: register32 port map(
        clk => clk,
        rst => rst,
        we => pc_lden,
        data => mux_out,
        dout => sig_instr_addr
    );
    
    PC_mux: mux_2 port map(
        ctrl => pc_sel,
        output => mux_out,
        a => mux_in_b,
        b => mux_in_a
    );


end Behavioral;
