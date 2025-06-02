library IEEE;
library numeric_std;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity decoder_5to32 is
    Port (
        input: in std_logic_vector(4 downto 0);
        output: out std_logic_vector(31 downto 0)
    );
end decoder_5to32;

architecture Structural of decoder_5to32 is

begin

    output <= std_logic_vector(shift_left(to_unsigned(1, 32), to_integer(unsigned(input))));

end Structural;
