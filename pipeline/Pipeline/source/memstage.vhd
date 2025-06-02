library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity memstage is
    Port ( 
        byte_op: in std_logic;
        mem_wren: in std_logic;
        
        alu_mem_addr: in std_logic_vector(31 downto 0);
        
        mem_datain: in std_logic_vector(31 downto 0);
        mem_dataout: out std_logic_vector(31 downto 0);
        
        mm_wren: out std_logic;
        mm_addr: out std_logic_vector(10 downto 0);
        
        mm_wrdata: out std_logic_vector(31 downto 0);
        mm_rddata: in std_logic_vector(31 downto 0)
    );
end memstage;

architecture Structural of memstage is

component byte_parser is
    Port (
        word: in std_logic_vector(31 downto 0);
        sel: in std_logic_vector(1 downto 0);
        
        byte: out std_logic_vector(31 downto 0)
    );
end component;

component byte_replacer is
    Port (
        byte: in std_logic_vector(7 downto 0);
        ram_data: in std_logic_vector(31 downto 0);
        sel: in std_logic_vector(1 downto 0);
        
        word_out: out std_logic_vector(31 downto 0)
    );
end component;

signal byte_input: std_logic_vector(31 downto 0);
signal byte_output: std_logic_vector(31 downto 0);

signal byte_select: std_logic_vector(1 downto 0);

begin

    mm_wren <= mem_wren;
    mm_addr <= std_logic_vector(unsigned(alu_mem_addr(12 downto 2)) + "0100000000");
    
    byte_select <= alu_mem_addr(1 downto 0);
    
    byte_in: byte_replacer port map(
        byte => mem_datain(7 downto 0),
        ram_data => mm_rddata,
        sel => byte_select,
        word_out => byte_input
    );
    
    mm_wrdata <= mem_datain when byte_op = '0' else byte_input;
    
    byte_out: byte_parser port map(
        word => mm_rddata,
        sel => byte_select,
        byte => byte_output
    );
    
    mem_dataout <= mm_rddata when byte_op = '0' else byte_output;

end Structural;
