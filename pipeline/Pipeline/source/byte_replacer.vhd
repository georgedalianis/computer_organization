library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity byte_replacer is
    Port (
        byte: in std_logic_vector(7 downto 0);
        ram_data: in std_logic_vector(31 downto 0);
        sel: in std_logic_vector(1 downto 0);
        
        word_out: out std_logic_vector(31 downto 0)
    );
end byte_replacer;

architecture Structural of byte_replacer is

begin
    
    word_out <= ram_data(31 downto 8) & byte when sel = "00"
           else ram_data(31 downto 16) & byte & ram_data(7 downto 0) when sel = "01"
           else ram_data(31 downto 24) & byte & ram_data(15 downto 0) when sel = "10"
           else byte & ram_data(23 downto 0);


end Structural;