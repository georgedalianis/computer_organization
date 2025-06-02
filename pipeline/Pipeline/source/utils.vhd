library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package vector_array is
    type bus_array is array(natural range <>) of std_logic_vector(31 downto 0);
end package;

package constants is
    constant latency: time := 10 ns;
    constant and_gate_latency: time := 2 ns;
    constant clock_period: time := 100 ns;
end package;