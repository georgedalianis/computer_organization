

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sim_control_mc is
end sim_control_mc;

architecture Behavioral of sim_control_mc is

component control_mc is
    Port (
        clk: in std_logic;
        rst: in std_logic;
        
        instr: in std_logic_vector(31 downto 0);
        
        control_pc_lden: out std_logic;                                 -- OK          
        control_pc_sel: out std_logic;                                  -- OK
        
        control_alu_zero: in std_logic;                                 -- OK
        
        control_rf_b_sel: out std_logic;                                -- OK
        control_rf_wrdata_sel: out std_logic;                           -- OK
        control_rf_wren: out std_logic;                                 -- OK
        control_rf_immed_ext_op: out std_logic_vector(1 downto 0);      -- OK
        
        control_alu_bin_sel: out std_logic;                             -- OK
        control_alu_func: out std_logic_vector(3 downto 0);             -- OK
        
        control_byte_op: out std_logic;                                 -- OK
        control_mem_wren: out std_logic                                 -- OK
    );
end component;

signal instr: std_logic_vector(31 downto 0);
signal control_pc_lden: std_logic;
signal control_pc_sel: std_logic;
signal control_alu_zero: std_logic := '-';
signal control_rf_b_sel: std_logic;
signal control_rf_wrdata_sel: std_logic;
signal control_rf_wren: std_logic;
signal control_rf_immed_ext_op: std_logic_vector(1 downto 0);
signal control_alu_bin_sel: std_logic;
signal control_alu_func: std_logic_vector(3 downto 0);

signal clk: std_logic := '0';
signal rst: std_logic := '1';

begin

    uut: control_mc port map(
        clk => clk,
        rst => rst,
        instr => instr,
        control_pc_lden => control_pc_lden,
        control_pc_sel => control_pc_sel,
        control_alu_zero => control_alu_zero,
        control_rf_b_sel => control_rf_b_sel,
        control_rf_wrdata_sel => control_rf_wrdata_sel,
        control_rf_wren => control_rf_wren,
        control_rf_immed_ext_op => control_rf_immed_ext_op,
        control_alu_bin_sel => control_alu_bin_sel,
        control_alu_func => control_alu_func
    );
    
    clk <= not clk after 100 ns;
    
    testbench: process begin
    
        wait for 200 ns;
        
        rst <= '0';
        wait;
    
        wait;
    
    end process;


end Behavioral;
