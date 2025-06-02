----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/28/2025 06:06:41 PM
-- Design Name: 
-- Module Name: sim_proc_mc - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sim_proc_mc is
end sim_proc_mc;

architecture Behavioral of sim_proc_mc is

component ram_data is
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
end component;

component blk_mem_gen_0 is
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
end component;

component proc_mc is
    Port (
        clk: in std_logic;
        rst: in std_logic;
        
        ram_instr_addr: out std_logic_vector(31 downto 0);
        instruction: in std_logic_vector(31 downto 0);
        
        ram_data_from: in std_logic_vector(31 downto 0);
        ram_data_to: out std_logic_vector(31 downto 0);
        ram_wren: out std_logic;
        ram_data_addr: out std_logic_vector(9 downto 0)
    );
end component;

signal clk: std_logic := '0';
signal rst: std_logic := '1';

signal instr_addr: std_logic_vector(31 downto 0);
signal instruction: std_logic_vector(31 downto 0);

signal ram_data_from: std_logic_vector(31 downto 0);
signal ram_data_to: std_logic_vector(31 downto 0);
signal ram_wren: std_logic_vector(0 downto 0);
signal ram_data_addr: std_logic_vector(9 downto 0);

signal ram_clk: std_logic := '0';

begin

    CPU: proc_mc port map(
        clk => clk,
        rst => rst,
        
        ram_instr_addr => instr_addr,
        instruction => instruction,
        
        ram_data_from => ram_data_from,
        ram_data_to => ram_data_to,
        ram_wren => ram_wren(0),
        ram_data_addr => ram_data_addr
    );
    
    TEXT_SEGMENT: blk_mem_gen_0 port map(
        clka => ram_clk,
        wea => "0",
        addra => instr_addr(11 downto 2),
        dina => x"00000000",
        douta => instruction
    );
    
    DATA_SEGMENT: ram_data port map(
        clka => ram_clk,
        wea => ram_wren,
        addra => ram_data_addr,
        dina => ram_data_to,
        douta => ram_data_from
    );
    
    clk <= not clk after 100 ns;
    ram_clk <= not ram_clk after 50 ns;
    
    program: process begin
        
        rst <= '1';
        wait for 200 ns;
        
        rst <= '0';
    
        wait;
    
    end process;



end Behavioral;
