
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity datapath_mc is
    Port (
        clk: in std_logic;
        rst: in std_logic;
        
        instr: in std_logic_vector(31 downto 0);
        
        control_intermediate_register_we: in std_logic_vector(4 downto 0);
        
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
        
        cached_instruction: out std_logic_vector(31 downto 0);
        
        instr_addr: out std_logic_vector(31 downto 0)
    );
end datapath_mc;

architecture Behavioral of datapath_mc is

component register32 is
    Port (
        clk: in std_logic;
        data: in std_logic_vector(31 downto 0);
        we: in std_logic;
        rst: in std_logic;
        
        dout: out std_logic_vector(31 downto 0)
    );
end component;

component ifstage is
    Port (
        clk: in std_logic;
        rst: in std_logic;
        pc_lden: in std_logic;
        pc_sel: in std_logic;
        pc_immed: in std_logic_vector(31 downto 0);
        
        instr_addr: out std_logic_vector(31 downto 0)
    );
end component;

component decstage is
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
end component;

component exstage is
    Port (
        rf_a: in std_logic_vector(31 downto 0);
        rf_b: in std_logic_vector(31 downto 0);
        immed: in std_logic_vector(31 downto 0);
        alu_bin_sel: in std_logic;
        alu_func: in std_logic_vector(3 downto 0);
        
        alu_zero: out std_logic;
        alu_out: out std_logic_vector(31 downto 0)
    );
end component;

component memstage is
    Port (
        mem_datain: in std_logic_vector(31 downto 0);               -- OK
        alu_mem_addr: in std_logic_vector(31 downto 0);             -- OK
        
        byte_op: in std_logic;
        mem_wren: in std_logic;                                     -- OK
        
        ram_data_from: in std_logic_vector(31 downto 0);            -- Input from RAM
        
        rf_mem_out: out std_logic_vector(31 downto 0);              --  
        ram_addr: out std_logic_vector(9 downto 0);                 -- OK
        ram_data_to: out std_logic_vector(31 downto 0);             -- OK
        ram_wren: out std_logic                                     -- OK
    );
end component;

signal immediate: std_logic_vector(31 downto 0);

signal register1_instr_output: std_logic_vector(31 downto 0);
signal register4_immediate_input: std_logic_vector(31 downto 0);

signal alu_out: std_logic_vector(31 downto 0);
signal mem_out: std_logic_vector(31 downto 0);

signal register2_rf_a_input: std_logic_vector(31 downto 0);
signal register3_rf_b_input: std_logic_vector(31 downto 0);

signal register2_rf_a_output: std_logic_vector(31 downto 0);
signal register3_rf_b_output: std_logic_vector(31 downto 0);

signal register5_addr_output: std_logic_vector(31 downto 0);

begin

    cached_instruction <= register1_instr_output;

    FETCH: ifstage port map(
        clk => clk,
        rst => rst,
        pc_lden => control_pc_lden,
        pc_sel => control_pc_sel,
        pc_immed => immediate,
        instr_addr => instr_addr
    );
    
    REGISTER1: register32 port map(
        clk => clk,
        rst => rst,
        we => control_intermediate_register_we(0),
        data => instr,
        dout => register1_instr_output
    );
    
    DECODE: decstage port map(
        clk => clk,
        rst => rst,
        rf_b_sel => control_rf_b_sel,
        rf_wrdata_sel => control_rf_wrdata_sel,
        rf_wren => control_rf_wren,
        sign_extention_mode => control_rf_immed_ext_op,
        
        immed => register4_immediate_input,
        instr => register1_instr_output,
        rf_a => register2_rf_a_input,
        rf_b => register3_rf_b_input,
        
        mem_out => mem_out,
        alu_out => alu_out
    );
    
    REGISTER2: register32 port map(
        clk => clk,
        rst => rst,
        we => control_intermediate_register_we(1),
        data => register2_rf_a_input,
        dout => register2_rf_a_output
    );
    
    REGISTER3: register32 port map(
        clk => clk,
        rst => rst,
        we => control_intermediate_register_we(2),
        data => register3_rf_b_input,
        dout => register3_rf_b_output
    );
    
    REGISTER4: register32 port map(
        clk => clk,
        rst => rst,
        we => control_intermediate_register_we(3),
        data => register4_immediate_input,
        dout => immediate
    );
    
    EXECUTE: exstage port map(
        rf_a => register2_rf_a_output,
        rf_b => register3_rf_b_output,
        immed => immediate,
        alu_bin_sel => control_alu_bin_sel,
        alu_func => control_alu_func,
        alu_out => alu_out,
        alu_zero => control_alu_zero
    );
    
    REGISTER5: register32 port map(
        clk => clk,
        rst => rst,
        we => control_intermediate_register_we(4),
        data => alu_out,
        dout => register5_addr_output
    );
    
    MEM_CONTROLLER: memstage port map(
        mem_datain => register3_rf_b_output,
        alu_mem_addr => register5_addr_output,
        byte_op => control_byte_op,
        mem_wren => control_mem_wren,
        
        ram_data_from => ram_input_data,
        rf_mem_out => mem_out,
        ram_addr => ram_addr,
        ram_data_to => ram_data_to,
        ram_wren => ram_wren
    );


end Behavioral;
