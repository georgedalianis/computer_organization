library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.constants.all;

entity alu is
    Port (
        A: in std_logic_vector(31 downto 0);
        B: in std_logic_vector(31 downto 0);
        op: in std_logic_vector(3 downto 0);
        
        output: out std_logic_vector(31 downto 0);
        zero: out std_logic;
        cout: out std_logic;
        ovf: out std_logic
    );
end alu;

architecture Structural of alu is

signal operation_result: std_logic_vector(31 downto 0);
signal result_33bit: std_logic_vector(32 downto 0);

begin

    result_33bit <=  std_logic_vector(unsigned('0' & A) + unsigned('0'& B)) when op = x"0"
                else std_logic_vector(unsigned('0' & A) - unsigned('0'& B)) when op = x"1"
                else '0' & x"00000000";

    operation_result <=  std_logic_vector(unsigned(A) + unsigned(B)) when op = x"0"
                    else std_logic_vector(unsigned(A) - unsigned(B)) when op = x"1"
                    else A and B                                     when op = x"2"
                    else A or B                                      when op = x"3"
                    else not A                                       when op = x"4"
                    else A nand B                                    when op = x"5"
                    else A nor B                                     when op = x"6"
                    else A(31) & A(31 downto 1)                      when op = x"8"
                    else '0' & A(31 downto 1)                        when op = x"9"
                    else A(30 downto 0) & '0'                        when op = x"a"
                    else A(30 downto 0) & A(31)                      when op = x"c"
                    else A(0) & A(31 downto 1)                       when op = x"d"
                    else x"00000000";

    output <= operation_result after latency;
    zero <= '1' after latency when operation_result = x"00000000" else '0' after latency;
    
    -- Overflow
    -- On addition when the result is negative
    -- On subtraction when the result is positive
    ovf <= '1' after latency when (op = x"0" and A(31) = B(31) and operation_result(31) /= A(31)) or (Op = x"1" and A(31) /= B(31) and operation_result(31) /= A(31)) else '0' after latency;
    cout <= result_33bit(32);
    
end Structural;