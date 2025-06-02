library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity memory_register is
    Port (
        clock: in std_logic;
        reset: in std_logic;
        write_enable: in std_logic;
        
        instr_in: in std_logic_vector(31 downto 0);
        instr_out: out std_logic_vector(31 downto 0);
        
        control_signals_in: in std_logic_vector(31 downto 0);
        control_signals_out: out std_logic_vector(31 downto 0);
        
        mem_data_in: in std_logic_vector(31 downto 0);
        mem_data_out: out std_logic_vector(31 downto 0)
    );
end memory_register;

architecture Behavioral of memory_register is

component register_32 is
    Port (
        clock: in std_logic;
        reset: in std_logic;
        write_enable: in std_logic;
        
        datain: in std_logic_vector(31 downto 0);
        dataout: out std_logic_vector(31 downto 0)
    );
end component;

begin

    instruction_register: register_32 port map(
        clock => clock,
        reset => reset,
        write_enable => write_enable,
        datain => instr_in,
        dataout => instr_out
    );
    
    control_register: register_32 port map(
        clock => clock,
        reset => reset,
        write_enable => write_enable,
        datain => control_signals_in,
        dataout => control_signals_out
    );
    
    memory_reg: register_32 port map(
        clock => clock,
        reset => reset,
        write_enable => '1',
        datain => mem_data_in,
        dataout => mem_data_out
    );

end Behavioral;
