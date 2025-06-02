library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity interrupt_generator is
    Port (
        mem_rf_wrdata_sel: in std_logic;
        mem_rf_wren: in std_logic;
        ex_rf_wrdata_sel: in std_logic;
        ex_rf_wren: in std_logic;
        
        comparator_halt: in std_logic;
        
        address_ex: in std_logic_vector(4 downto 0);
        address_mem: in std_logic_vector(4 downto 0);
        address_write: out std_logic_vector(4 downto 0);
        
        rf_wren: out std_logic;
        rf_wrdata_sel: out std_logic;
        halt: out std_logic
    );
end interrupt_generator;

architecture Behavioral of interrupt_generator is

begin

    halt <= ((mem_rf_wrdata_sel and mem_rf_wren) and ((not ex_rf_wrdata_sel) and ex_rf_wren)) or comparator_halt;
        
    rf_wren <= (mem_rf_wren and mem_rf_wrdata_sel) or (ex_rf_wren and (not ex_rf_wrdata_sel));
    rf_wrdata_sel <= mem_rf_wrdata_sel and mem_rf_wren;
    
    address_write <= address_mem when (mem_rf_wren and mem_rf_wrdata_sel) = '1' else address_ex;

end Behavioral;
