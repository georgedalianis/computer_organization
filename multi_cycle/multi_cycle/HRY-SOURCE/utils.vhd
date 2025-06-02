library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package vector_array is
    type bus_array is array(natural range <>) of std_logic_vector(31 downto 0);
end package;