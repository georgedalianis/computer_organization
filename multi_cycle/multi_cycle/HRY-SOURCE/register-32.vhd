
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register32 is
    Port (
        clk: in std_logic;
        data: in std_logic_vector(31 downto 0);
        we: in std_logic;
        rst: in std_logic;
        
        dout: out std_logic_vector(31 downto 0)
    );
end register32;

architecture Behavioral of register32 is

signal register_data: std_logic_vector(31 downto 0);

begin

    dout <= register_data;

    process begin
    
        wait until clk'event and clk = '1';
        
        if rst = '1' then
            register_data <= x"00000000";
        else
            if we = '1' then
                register_data <= data;
            end if;
        end if;
    
    end process;
end Behavioral;
