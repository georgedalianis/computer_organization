library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_2 is
    Port (
        a: in std_logic_vector(31 downto 0);
        b: in std_logic_vector(31 downto 0);
        ctrl: in std_logic;
        
        output: out std_logic_vector(31 downto 0)
    );
end mux_2;

architecture Structural of mux_2 is

begin

    output <= a when ctrl = '0' else b when ctrl = '1';

end Structural;
