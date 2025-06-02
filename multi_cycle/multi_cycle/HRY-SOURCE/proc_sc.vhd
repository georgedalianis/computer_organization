
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity proc_sc is
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
end proc_sc;

architecture Behavioral of proc_sc is

component datapath is
    Port (
        clk: in std_logic;
        rst: in std_logic;
        
        instr: in std_logic_vector(31 downto 0);
        
        control_pc_lden: in std_logic;
        control_pc_sel: in std_logic;
        
        control_rf_b_sel: in std_logic;
        control_rf_wrdata_sel: in std_logic;
        control_rf_wren: in std_logic;
        control_rf_immed_ext_op: in std_logic_vector(1 downto 0);
        
        control_alu_bin_sel: in std_logic;
        control_alu_func: in std_logic_vector(3 downto 0);
        
        control_alu_zero: out std_logic;
        
        control_byte_op: in std_logic;
        control_mem_wren: in std_logic;
        
        ram_input_data: in std_logic_vector(31 downto 0);
        ram_addr: out std_logic_vector(9 downto 0);
        ram_data_to: out std_logic_vector(31 downto 0);
        ram_wren: out std_logic;
        
        instr_addr: out std_logic_vector(31 downto 0)
    );
end component;

component control is
    Port (
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

signal alu_zero: std_logic;

signal pc_lden: std_logic;
signal pc_sel: std_logic;

signal rf_b_sel: std_logic;
signal rf_wrdata_sel: std_logic;
signal rf_wren: std_logic;
signal rf_immed_ext_op: std_logic_vector(1 downto 0);

signal alu_bin_sel: std_logic;
signal alu_func: std_logic_vector(3 downto 0);

signal byte_op: std_logic;
signal mem_wren: std_logic;

begin

    CPU_CONTROL: control port map(
        instr => instruction,
        control_alu_zero => alu_zero,
        control_pc_lden => pc_lden,        
        control_pc_sel => pc_sel,
        
        control_rf_b_sel => rf_b_sel,
        control_rf_wrdata_sel => rf_wrdata_sel,
        control_rf_wren => rf_wren,
        control_rf_immed_ext_op => rf_immed_ext_op,
        
        control_alu_bin_sel => alu_bin_sel,
        control_alu_func => alu_func,
        
        control_byte_op => byte_op,
        control_mem_wren => mem_wren
    );
    
    CPU_DATAPATH: datapath port map(
        clk => clk,
        rst => rst,
        
        instr => instruction,
        
        control_alu_zero => alu_zero,
        control_pc_lden => pc_lden,        
        control_pc_sel => pc_sel,
        
        control_rf_b_sel => rf_b_sel,
        control_rf_wrdata_sel => rf_wrdata_sel,
        control_rf_wren => rf_wren,
        control_rf_immed_ext_op => rf_immed_ext_op,
        
        control_alu_bin_sel => alu_bin_sel,
        control_alu_func => alu_func,
        
        control_byte_op => byte_op,
        control_mem_wren => mem_wren,
        
        ram_input_data => ram_data_from,
        ram_addr => ram_data_addr,
        ram_data_to => ram_data_to,
        ram_wren => ram_wren,
        
        instr_addr => ram_instr_addr
    );


end Behavioral;
