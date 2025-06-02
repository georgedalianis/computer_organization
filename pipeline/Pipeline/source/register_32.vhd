library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constants.all;

entity register_32 is
    Port (
        clock: in std_logic;
        reset: in std_logic;
        write_enable: in std_logic;
        
        datain: in std_logic_vector(31 downto 0);
        dataout: out std_logic_vector(31 downto 0)
    );
end register_32;

architecture Behavioral of register_32 is

signal write_data: std_logic_vector(31 downto 0);

begin

    process begin
        
        -- Wait for rising edge of the clock...
        wait until clock'event and clock = '1';
        
        -- Reset signal is the highest priority (ignores write enable).
        if reset = '1' then
            write_data <= x"00000000" after latency;
        else
            if write_enable = '1' then
                write_data <= datain after latency;
            end if;
        end if;
        
    end process;
    
    dataout <= write_data;

end Behavioral;
