library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity forwarder is
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
end forwarder;

architecture Structural of forwarder is

component mux_8 is
    Port (
        in0: in std_logic_vector(31 downto 0);
        in1: in std_logic_vector(31 downto 0);
        in2: in std_logic_vector(31 downto 0);
        in3: in std_logic_vector(31 downto 0);
        in4: in std_logic_vector(31 downto 0);
        in5: in std_logic_vector(31 downto 0);
        in6: in std_logic_vector(31 downto 0);
        in7: in std_logic_vector(31 downto 0);
        
        sel: in std_logic_vector(2 downto 0);
        
        output: out std_logic_vector(31 downto 0)
    );
end component;

signal ex: std_logic;
signal mem: std_logic;
signal wb: std_logic;

signal sel: std_logic_vector(2 downto 0);

begin
    
   
    stall_f <= '1' when (need = ex_rd and ex_rf_wren = '1' and ex_rf_wrdata_sel = '1') else '0';

    ex <= '1' when need = ex_rd and ex_rf_wren = '1' and ex_rf_wrdata_sel = '0' else '0';
    mem <= '1' when need = mem_rd and mem_rf_wren = '1' and mem_rf_wrdata_sel = '1' else '0';
    wb <= '1' when need = wb_rd and wb_rf_wren = '1' else '0';
    
    sel <= ex & mem & wb;
    
    selector: mux_8 port map(
        sel => sel,
        output => forwarded,
        
        in0 => raw_data,
        in1 => wb_data,
        in2 => mem_data,
        in3 => mem_data,
        in4 => ex_data,
        in5 => ex_data,
        in6 => ex_data,
        in7 => ex_data
    );
    
    --forwarded <=    ex_data when need = ex_rd and ex_rf_wren = '1' and ex_rf_wrdata_sel = '0' else
                    --mem_data when need = mem_rd and mem_rf_wren = '1' and mem_rf_wrdata_sel = '1' else
                    --wb_data when need = wb_rd and wb_rf_wren = '1' else
                    --raw_data;

end Structural;
