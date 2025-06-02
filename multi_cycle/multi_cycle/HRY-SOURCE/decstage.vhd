
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decstage is
    Port (
        clk: in std_logic;
        rst: in std_logic;
        
        rf_b_sel: in std_logic;
        rf_wrdata_sel: in std_logic;
        rf_wren: in std_logic;
        
        alu_out: in std_logic_vector(31 downto 0);
        mem_out: in std_logic_vector(31 downto 0);
        instr: in std_logic_vector(31 downto 0);
        
        sign_extention_mode: in std_logic_vector(1 downto 0);
        
        immed: out std_logic_vector(31 downto 0);
        rf_a: out std_logic_vector(31 downto 0);
        rf_b: out std_logic_vector(31 downto 0)
    );
end decstage;

architecture Behavioral of decstage is

component register_file is
    Port (
        clk: in std_logic;
        rst: in std_logic;
        wren: in std_logic;
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
        a: in std_logic_vector(31 downto 0);
        b: in std_logic_vector(31 downto 0);
        ctrl: in std_logic;
        
        output: out std_logic_vector(31 downto 0)
    );
end component;

component sign_extender is
    Port (
        input_immed: in std_logic_vector(15 downto 0);
        op: in std_logic_vector(1 downto 0);
        extended_immed: out std_logic_vector(31 downto 0)
    );
end component;

signal wr_data_in: std_logic_vector(31 downto 0);
signal rd_addr_2: std_logic_vector(4 downto 0);

begin
    
    rd_addr_2 <= instr(15 downto 11) when rf_b_sel = '0' else instr(20 downto 16) when rf_b_sel = '1';

    wr_data_selector: mux_2 port map(
        ctrl => rf_wrdata_sel,
        a => alu_out,
        b => mem_out,
        output => wr_data_in
    );
    
    rf: register_file port map(
        clk => clk,
        rst => rst,
        wren => rf_wren,
        ard1 => instr(25 downto 21),
        ard2 => rd_addr_2,
        awr => instr(20 downto 16),
        din => wr_data_in,
        dout1 => rf_a,
        dout2 => rf_b
    );
    
    extender: sign_extender port map(
        input_immed => instr(15 downto 0),
        op => sign_extention_mode,
        extended_immed => immed
    );


end Behavioral;
