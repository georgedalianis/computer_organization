
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity forwarding_unit is
    Port ( 
        rd: in std_logic_vector(4 downto 0);
        rt: in std_logic_vector(4 downto 0);
        rs: in std_logic_vector(4 downto 0);
        b_sel: in std_logic;
        
        wb_rd: in std_logic_vector(4 downto 0);
        ex_rd: in std_logic_vector(4 downto 0);
        mem_rd: in std_logic_vector(4 downto 0);
        
        wb_rf_wren: in std_logic;
        ex_rf_wren: in std_logic;
        mem_rf_wren: in std_logic;
        
        ex_rf_wrdata_sel: in std_logic;
        mem_rf_wrdata_sel: in std_logic;
        
        wb_data: in std_logic_vector(31 downto 0);
        ex_data: in std_logic_vector(31 downto 0);
        mem_data: in std_logic_vector(31 downto 0);
        
        A: in std_logic_vector(31 downto 0);
        B: in std_logic_vector(31 downto 0);
        
        forwarded_A: out std_logic_vector(31 downto 0);
        forwarded_B: out std_logic_vector(31 downto 0);
        
        stall: out std_logic
    );
end forwarding_unit;

architecture Behavioral of forwarding_unit is

component forwarder is
    Port (
        need: in std_logic_vector(4 downto 0);
        
        wb_rd: in std_logic_vector(4 downto 0);
        ex_rd: in std_logic_vector(4 downto 0);
        mem_rd: in std_logic_vector(4 downto 0);
        
        wb_rf_wren: in std_logic;
        ex_rf_wren: in std_logic;
        mem_rf_wren: in std_logic;
        
        ex_rf_wrdata_sel: in std_logic;
        mem_rf_wrdata_sel: in std_logic;
        
        wb_data: in std_logic_vector(31 downto 0);
        ex_data: in std_logic_vector(31 downto 0);
        mem_data: in std_logic_vector(31 downto 0);
        raw_data: in std_logic_vector(31 downto 0);
        
        forwarded: out std_logic_vector(31 downto 0);
        stall_f: out std_logic
    );
end component;

signal stall_A: std_logic;
signal stall_B: std_logic;

signal need_b: std_logic_vector(4 downto 0);

begin

    stall <= stall_A or stall_B;
    need_b <= rd when b_sel = '1' else rt;

    A_forwarder: forwarder port map(
        need => rs,
        wb_rd => wb_rd,
        ex_rd => ex_rd,
        mem_rd => mem_rd,
        
        wb_rf_wren => wb_rf_wren,
        ex_rf_wren => ex_rf_wren,
        mem_rf_wren => mem_rf_wren,
        
        ex_rf_wrdata_sel => ex_rf_wrdata_sel,
        mem_rf_wrdata_sel => mem_rf_wrdata_sel,
        
        wb_data => wb_data,
        ex_data => ex_data,
        mem_data => mem_data,
        raw_data => A,
        
        forwarded => forwarded_A,
        stall_f => stall_A
    );
    
    B_forwarder: forwarder port map(
        need => need_b,
        wb_rd => wb_rd,
        ex_rd => ex_rd,
        mem_rd => mem_rd,
        
        wb_rf_wren => wb_rf_wren,
        ex_rf_wren => ex_rf_wren,
        mem_rf_wren => mem_rf_wren,
        
        ex_rf_wrdata_sel => ex_rf_wrdata_sel,
        mem_rf_wrdata_sel => mem_rf_wrdata_sel,
        
        wb_data => wb_data,
        ex_data => ex_data,
        mem_data => mem_data,
        raw_data => B,
        
        forwarded => forwarded_B,
        stall_f => stall_B
    );

end Behavioral;
