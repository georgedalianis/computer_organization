library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.vector_array.all;
use work.constants.all;

entity register_file is
    Port (
        clock: in std_logic;
        reset: in std_logic;
        write_enable: in std_logic;
        
        ard1: in std_logic_vector(4 downto 0);
        ard2: in std_logic_vector(4 downto 0);
        awr: in std_logic_vector(4 downto 0);
        
        din: in std_logic_vector(31 downto 0);
        dout1: out std_logic_vector(31 downto 0);
        dout2: out std_logic_vector(31 downto 0)
    );
end register_file;

architecture Structural of register_file is

component decoder_5to32 is
    Port (
        input: in std_logic_vector(4 downto 0);
        output: out std_logic_vector(31 downto 0)
    );
end component;

component register_32 is
    Port (
        clock: in std_logic;
        reset: in std_logic;
        write_enable: in std_logic;
        
        datain: in std_logic_vector(31 downto 0);
        dataout: out std_logic_vector(31 downto 0)
    );
end component;

component mux_32 is
    Port (
        input: in bus_array(31 downto 0);
        sel: in std_logic_vector(4 downto 0);
        output: out std_logic_vector(31 downto 0)
    );
end component;

signal decoded_address_write: std_logic_vector(31 downto 0);
signal write_enable_array: std_logic_vector(31 downto 0);
signal multiplexer_bus: bus_array(31 downto 0);

begin

    -- The register R0 has write enable always equal to 0.
    write_enable_array <= decoded_address_write and x"00000000" after and_gate_latency when write_enable = '0' else decoded_address_write and x"fffffffe" after and_gate_latency;

    decoder: decoder_5to32 port map(
        input => awr,
        output => decoded_address_write
    );
    
    registers:
    for i in 0 to 31 generate
        reg: register_32 port map(
            clock => clock,
            reset => reset,
            write_enable => write_enable_array(i),
            datain => din,
            dataout => multiplexer_bus(i)
        );
    end generate;
    
    multiplexer1: mux_32 port map(
        sel => ard1,
        input => multiplexer_bus,
        output => dout1
    );
    
    multiplexer2: mux_32 port map(
        sel => ard2,
        input => multiplexer_bus,
        output => dout2
    );

end Structural;
