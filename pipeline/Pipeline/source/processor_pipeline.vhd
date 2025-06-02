library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity processor_pipeline is
    Port (
        clock: in std_logic;
        reset: in std_logic
    );
end processor_pipeline;

architecture Behavioral of processor_pipeline is

component control_pipeline is
    Port (
        instruction: in std_logic_vector(31 downto 0);
        
        branch: out std_logic;
        conditional_branch: out std_logic;
        conditional_not_branch: out std_logic;
        pc_lden: out std_logic;
        
        alu_bin_sel: out std_logic;
        alu_func: out std_logic_vector(3 downto 0);
        
        rf_wrdata_sel: out std_logic;
        rf_b_sel: out std_logic;
        rf_wren: out std_logic;
        immed_ext: out std_logic_vector(1 downto 0);
        
        byte_op: out std_logic;
        mem_wren: out std_logic
    );
end component;

component ram is
    port (
        clk : in std_logic;
        inst_addr : in std_logic_vector(10 downto 0);
        inst_dout : out std_logic_vector(31 downto 0);
        data_we : in std_logic;
        data_addr : in std_logic_vector(10 downto 0);
        data_din : in std_logic_vector(31 downto 0);
        data_dout : out std_logic_vector(31 downto 0)
    );
end component;

component datapath_pipeline is
    Port (
        clock: in std_logic;
        reset: in std_logic;
        
        instruction: in std_logic_vector(31 downto 0);
        control_signals: in std_logic_vector(15 downto 0);
        
        pc: out std_logic_vector(31 downto 0);
        
        mm_wren: out std_logic;
        mm_rddata: in std_logic_vector(31 downto 0);
        mm_wrdata: out std_logic_vector(31 downto 0);
        mm_addr: out std_logic_vector(10 downto 0)
    );
end component;

-- CONTROL SIGNALS...
signal control_signals: std_logic_vector(15 downto 0);

-- RAM & DATAPATH SIGNALS...
signal instruction_signal: std_logic_vector(31 downto 0);
signal ram_instr_addr: std_logic_vector(31 downto 0);
signal ram_wren: std_logic;
signal ram_data_addr: std_logic_vector(10 downto 0);
signal ram_datain: std_logic_vector(31 downto 0);
signal ram_dataout: std_logic_vector(31 downto 0);

begin

    control_component: control_pipeline port map(
        instruction => instruction_signal,
        branch => control_signals(15),
        conditional_branch => control_signals(14),
        conditional_not_branch => control_signals(13),
        pc_lden => control_signals(12),
        
        alu_bin_sel => control_signals(11),
        alu_func => control_signals(10 downto 7),
        
        rf_wrdata_sel => control_signals(6),
        rf_b_sel => control_signals(5),
        rf_wren => control_signals(4),
        immed_ext => control_signals(3 downto 2),
        
        byte_op => control_signals(1),
        mem_wren => control_signals(0)
    );

    random_access_memory: ram port map(
        clk => clock,
        inst_addr => ram_instr_addr(12 downto 2),
        inst_dout => instruction_signal,
        data_we => ram_wren,
        data_addr => ram_data_addr,
        data_din => ram_datain,
        data_dout => ram_dataout
    );
    
    datapath_component: datapath_pipeline port map(
        clock => clock,
        reset => reset,
        
        instruction => instruction_signal,
        control_signals => control_signals,
        
        pc => ram_instr_addr,
        
        mm_wren => ram_wren,
        mm_rddata => ram_dataout,
        mm_wrdata => ram_datain,
        mm_addr => ram_data_addr
    );

end Behavioral;
