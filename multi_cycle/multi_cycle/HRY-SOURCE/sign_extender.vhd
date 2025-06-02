library IEEE;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_1164.ALL;

--  op: 00              -> Zero fill (Append with 16 zeros)
--  op: 01              -> Sign extend (Append with sign)
--  op: 10              -> << 16 & Zero fill
--  op: 11              -> Sign extend and multiply x4

entity sign_extender is
    Port (
        input_immed: in std_logic_vector(15 downto 0);
        op: in std_logic_vector(1 downto 0);
        extended_immed: out std_logic_vector(31 downto 0)
    );
end sign_extender;

architecture Structural of sign_extender is

signal zero_fill: std_logic_vector(31 downto 0);
signal sign_extend: std_logic_vector(31 downto 0);

begin
    
    zero_fill <= std_logic_vector(resize(unsigned(input_immed), 32));
    sign_extend <= std_logic_vector(resize(signed(input_immed), 32));
    
    extended_immed <= zero_fill when op = "00"
                 else sign_extend when op = "01"
                 else zero_fill(15 downto 0) & x"0000" when op = "10"
                 else sign_extend(29 downto 0) & "00" when op = "11";


end Structural;
