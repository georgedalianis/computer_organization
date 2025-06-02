library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity immed_extender is
    Port (
        input_immed: in std_logic_vector(15 downto 0);
        operation: in std_logic_vector(1 downto 0);
        
        extended_immed: out std_logic_vector(31 downto 0)
    );
end immed_extender;

architecture Structural of immed_extender is

signal zero_fill: std_logic_vector(31 downto 0);
signal sign_extend: std_logic_vector(31 downto 0);

begin

    zero_fill <= std_logic_vector(resize(unsigned(input_immed), 32));
    sign_extend <= std_logic_vector(resize(signed(input_immed), 32));
    
    extended_immed <= zero_fill when operation = "00"
                      else sign_extend when operation = "01"
                      else zero_fill(15 downto 0) & x"0000" when operation = "10"
                      else sign_extend(29 downto 0) & "00";
    

end Structural;