library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity byte_parser is
    Port (
        word: in std_logic_vector(31 downto 0);
        sel: in std_logic_vector(1 downto 0);
        
        byte: out std_logic_vector(31 downto 0)
    );
end byte_parser;

architecture Structural of byte_parser is

begin

    byte <=      word(31 downto 0) and x"000000ff" when sel = "00"
            else x"00" & (word(31 downto 8) and x"0000ff") when sel = "01"
            else x"0000" & (word(31 downto 16) and x"00ff") when sel = "10"
            else x"000000" & (word(31 downto 24) and x"ff");

end Structural;
