library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity compare_module is
    Port (
        ard: in std_logic_vector(4 downto 0);
        awr: in std_logic_vector(4 downto 0);
        
        cmp: out std_logic
    );
end compare_module;

architecture Structural of compare_module is

begin
    -- cmp = 1 when ard == awr
    cmp <= '1' when (ard xor awr) = "00000" else '0';


end Structural;
