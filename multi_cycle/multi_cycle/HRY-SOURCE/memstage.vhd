
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity memstage is
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
end memstage;

architecture Structural of memstage is

begin

    ram_wren <= mem_wren;
    
    ram_addr <= alu_mem_addr(11 downto 2);
    
    ram_data_to <= mem_datain when byte_op = '0' else x"000000" & mem_datain(7 downto 0) when byte_op = '1';
    
    rf_mem_out <= ram_data_from when byte_op = '0' else x"000000" & ram_data_from(7 downto 0) when byte_op = '1';


end Structural;
