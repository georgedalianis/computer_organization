library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_2 is
    Port (
        A: in std_logic_vector(31 downto 0);
        B: in std_logic_vector(31 downto 0);
        sel: in std_logic;
        output: out std_logic_vector(31 downto 0)
    );
end mux_2;

architecture Structural of mux_2 is

begin

    -- Obviously...
    output <= A when sel = '1' else B;

end Structural;
