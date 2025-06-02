
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity proc_pipeline_test is
end proc_pipeline_test;

architecture Behavioral of proc_pipeline_test is

component processor_pipeline is
    Port (
        clock: in std_logic;
        reset: in std_logic
    );
end component;

signal clock: std_logic := '0';
signal reset: std_logic := '1';

begin

    clock <= not clock after 200 ns;
    
    uut: processor_pipeline port map(
        clock => clock,
        reset => reset
    );
    
    testbench: process begin
    
        wait for 1000 ns;
        
        reset <= '0';
        
        wait;
    
    end process;


end Behavioral;
