library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fetch_register is
    Port (
        clock: in std_logic;
        reset: in std_logic;
        write_enable: in std_logic;
    
        instr_in: in std_logic_vector(31 downto 0);
        instr_out: out std_logic_vector(31 downto 0);
        
        control_signals_in: in std_logic_vector(15 downto 0);
        control_signals_out: out std_logic_vector(31 downto 0)
    );
end fetch_register;

architecture Behavioral of fetch_register is

component register_32 is
    Port (
        clock: in std_logic;
        reset: in std_logic;
        write_enable: in std_logic;
        
        datain: in std_logic_vector(31 downto 0);
        dataout: out std_logic_vector(31 downto 0)
    );
end component;

signal control_signals_32bit: std_logic_vector(31 downto 0);

begin

    control_signals_32bit <= x"0000" & control_signals_in;

    instruction_register: register_32 port map(
        clock => clock,
        reset => reset,
        write_enable => write_enable,
        datain => instr_in,
        dataout => instr_out
    );
    
    control_signals_register: register_32 port map(
        clock => clock,
        reset => reset,
        write_enable => write_enable,
        datain => control_signals_32bit,
        dataout => control_signals_out
    );

end Behavioral;
