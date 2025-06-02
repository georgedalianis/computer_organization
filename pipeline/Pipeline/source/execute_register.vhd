library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity execute_register is
    Port (
        clock: in std_logic;
        reset: in std_logic;
        write_enable: in std_logic;
        
        instr_in: in std_logic_vector(31 downto 0);
        instr_out: out std_logic_vector(31 downto 0);
        
        control_signals_in: in std_logic_vector(31 downto 0);
        control_signals_out: out std_logic_vector(31 downto 0);
        
        alu_result_in: in std_logic_vector(31 downto 0);
        alu_result_out: out std_logic_vector(31 downto 0);
        
        B_in: in std_logic_vector(31 downto 0);
        B_out: out std_logic_vector(31 downto 0)
    );
end execute_register;

architecture Behavioral of execute_register is

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

    instrucion_register: register_32 port map(
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
        
        datain => control_signals_in,
        dataout => control_signals_out
    );
    
    alu_result_register: register_32 port map(
        clock => clock,
        reset => reset,
        write_enable => write_enable,
        
        datain => alu_result_in,
        dataout => alu_result_out
    );
    
    B_register: register_32 port map(
        clock => clock,
        reset => reset,
        write_enable => write_enable,
        
        datain => B_in,
        dataout => B_out
    );

end Behavioral;
