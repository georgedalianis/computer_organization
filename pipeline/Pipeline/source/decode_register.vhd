library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decode_register is
    Port (
        clock: in std_logic;
        reset: in std_logic;
        write_enable: in std_logic;
    
        instr_in: in std_logic_vector(31 downto 0);
        instr_out: out std_logic_vector(31 downto 0);
        
        control_signals_in: in std_logic_vector(31 downto 0);
        control_signals_out: out std_logic_vector(31 downto 0);
        
        rf_a_in: in std_logic_vector(31 downto 0);
        rf_a_out: out std_logic_vector(31 downto 0);
        
        rf_b_in: in std_logic_vector(31 downto 0);
        rf_b_out: out std_logic_vector(31 downto 0);
        
        immed_in: in std_logic_vector(31 downto 0);
        immed_out: out std_logic_vector(31 downto 0);
        
        write_back_data_in: in std_logic_vector(31 downto 0);
        write_back_data_out: out std_logic_vector(31 downto 0);
        
        write_address_in: in std_logic_vector(4 downto 0);
        write_address_out: out std_logic_vector(4 downto 0);
        
        was_written_in: in std_logic;
        was_written_out: out std_logic
    );
end decode_register;

architecture Behavioral of decode_register is

component register_32 is
    Port (
        clock: in std_logic;
        reset: in std_logic;
        write_enable: in std_logic;
        
        datain: in std_logic_vector(31 downto 0);
        dataout: out std_logic_vector(31 downto 0)
    );
end component;

component d_flip_flop is
    Port (
        clock: in std_logic;
        reset: in std_logic;
        
        datain: in std_logic;
        dataout: out std_logic
    );
end component;

signal address_32: std_logic_vector(31 downto 0);
signal output_address_32: std_logic_vector(31 downto 0);

begin

    address_32 <= x"000000" & "000" & write_address_in;
    write_address_out <= output_address_32(4 downto 0);
        
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
        datain => control_signals_in,
        dataout => control_signals_out
    );
    
    A_register: register_32 port map(
        clock => clock,
        reset => reset,
        write_enable => write_enable,
        datain => rf_a_in,
        dataout => rf_a_out
    );
    
    B_register: register_32 port map(
        clock => clock,
        reset => reset,
        write_enable => write_enable,
        datain => rf_b_in,
        dataout => rf_b_out
    );
    
    immed_register: register_32 port map(
        clock => clock,
        reset => reset,
        write_enable => write_enable,
        datain => immed_in,
        dataout => immed_out
    );
    
    write_back_data_register: register_32 port map(
        clock => clock,
        reset => reset,
        write_enable => '1',
        
        datain => write_back_data_in,
        dataout => write_back_data_out
    );
    
    address_register: register_32 port map(
        clock => clock,
        reset => reset,
        write_enable => '1',
        
        datain => address_32,
        dataout => output_address_32
    );
    
    write_enable_register: d_flip_flop port map(
        clock => clock,
        reset => reset,
        
        datain => was_written_in,
        dataout => was_written_out
    );

end Behavioral;
