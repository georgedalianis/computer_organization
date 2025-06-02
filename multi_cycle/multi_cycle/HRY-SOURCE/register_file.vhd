library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.vector_array.all;

entity register_file is
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
end register_file;

architecture Behavioral of register_file is

component compare_module is
    Port (
        ard: in std_logic_vector(4 downto 0);
        awr: in std_logic_vector(4 downto 0);
        
        cmp: out std_logic
    );
end component;

component decoder_5to32 is
    Port (
        input: in std_logic_vector(4 downto 0);
        output: out std_logic_vector(31 downto 0)
    );
end component;

component register32 is
    Port (
        clk: in std_logic;
        data: in std_logic_vector(31 downto 0);
        we: in std_logic;
        rst: in std_logic;
        
        dout: out std_logic_vector(31 downto 0)
    );
end component;

component mux_32 is
    Port (
        input: in bus_array(31 downto 0);
        ctrl: in std_logic_vector(4 downto 0);
        
        output: out std_logic_vector(31 downto 0)
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

signal cmp_out_1: std_logic;
signal cmp_out_2: std_logic;

signal decoder_out: std_logic_vector(31 downto 0);
signal wren_bus: std_logic_vector(31 downto 0);

signal reg_out_bus: bus_array(31 downto 0);

signal mux_32_out_1: std_logic_vector(31 downto 0);
signal mux_32_out_2: std_logic_vector(31 downto 0);

begin

    -- ffff fffe = 1111 1111 1111 1111 1111 1111 1111 1110
    -- decoder out 0000 0000 0000 0100 0000 0000 0000 0000
    wren_bus <= x"00000000" when wren = '0' else (x"fffffffe" and decoder_out) when wren = '1'; 

    registers:
    for i in 0 to 31 generate
        reg: register32 port map(
            clk => clk,
            rst => rst,
            data => din,
            we => wren_bus(i),
            dout => reg_out_bus(i)
        );
    end generate;
    
    mux_32_1: mux_32 port map(
        input => reg_out_bus,
        ctrl => ard1,
        output => mux_32_out_1
    );
    
    mux_32_2: mux_32 port map(
        input => reg_out_bus,
        ctrl => ard2,
        output => mux_32_out_2
    );
    
    mux_2_1: mux_2 port map(
        a => mux_32_out_1,
        b => din,
        ctrl => cmp_out_1,
        output => dout1
    );
    
    mux_2_2: mux_2 port map(
        a => mux_32_out_2,
        b => din,
        ctrl => cmp_out_2,
        output => dout2
    );

    compare_module1: compare_module port map(
        ard => ard1,
        awr => awr,
        cmp => cmp_out_1
    );
    
    compare_module2: compare_module port map(
        ard => ard2,
        awr => awr,
        cmp => cmp_out_2
    );
    
    decoder: decoder_5to32 port map(
        input => awr,
        output => decoder_out
    );


end Behavioral;
