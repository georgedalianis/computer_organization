library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_8 is
    Port (
        in0: in std_logic_vector(31 downto 0);
        in1: in std_logic_vector(31 downto 0);
        in2: in std_logic_vector(31 downto 0);
        in3: in std_logic_vector(31 downto 0);
        in4: in std_logic_vector(31 downto 0);
        in5: in std_logic_vector(31 downto 0);
        in6: in std_logic_vector(31 downto 0);
        in7: in std_logic_vector(31 downto 0);
        
        sel: in std_logic_vector(2 downto 0);
        
        output: out std_logic_vector(31 downto 0)
    );
end mux_8;

architecture Behavioral of mux_8 is

begin

    output <= in0 when sel = "000" else
              in1 when sel = "001" else
              in2 when sel = "010" else
              in3 when sel = "011" else
              in4 when sel = "100" else
              in5 when sel = "101" else
              in6 when sel = "110" else
              in7;  

end Behavioral;
