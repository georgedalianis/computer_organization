library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vector_array.all;

entity mux_32 is
    Port (
        input: in bus_array(31 downto 0);
        ctrl: in std_logic_vector(4 downto 0);
        
        output: out std_logic_vector(31 downto 0)
    );
end mux_32;

architecture Structural of mux_32 is

begin
    
    output <= input(to_integer(unsigned(ctrl)));

end Structural;
