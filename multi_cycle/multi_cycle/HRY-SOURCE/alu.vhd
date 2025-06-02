library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity alu is
    Port (
        a: in std_logic_vector(31 downto 0);
        b: in std_logic_vector(31 downto 0);
        op: in std_logic_vector(3 downto 0);
        
        output: out std_logic_vector(31 downto 0);
        zero: out std_logic;
        cout: out std_logic;
        ovf: out std_logic
    );
end alu;

architecture Structural of alu is

signal result: std_logic_vector(31 downto 0);
signal ovf_result: std_logic_vector(32 downto 0);

begin

    ovf_result <= std_logic_vector(unsigned('0' & a) + unsigned('0' & b)) when op = x"0"
         else std_logic_vector(unsigned('0' & a) - unsigned('0' & b)) when op = x"1"
         else '0' & x"00000000";
    
    result <= std_logic_vector(unsigned(a) + unsigned(b)) when op = x"0"
         else std_logic_vector(unsigned(a) - unsigned(b)) when op = x"1"
         else a and b                                     when op = x"2"
         else a or b                                      when op = x"3"
         else not a                                       when op = x"4"
         else a(31) & a(31 downto 1)                      when op = x"8"
         else '0' & a(31 downto 1)                        when op = x"9"
         else a(30 downto 0) & '0'                        when op = x"a"
         else a(30 downto 0) & a(31)                      when op = x"c"
         else a(0) & a(31 downto 1)                       when op = x"d";

    output <= result;
    
    zero <= '1' when result = x"00000000" else '0';
    cout <= ovf_result(32);
    ovf <= '1' when (op = x"0" and a(31) = b(31) and result(31) /= a(31)) or (op = x"1" and a(31) /= b(31) and result(31) /= a(31)) else '0';

end Structural;
