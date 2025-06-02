
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control is
    Port (
        instr: in std_logic_vector(31 downto 0);
        
        control_pc_lden: out std_logic;                                 -- OK          
        control_pc_sel: out std_logic;                                  -- OK
        
        control_alu_zero: in std_logic;                                 -- OK
        
        control_rf_b_sel: out std_logic;                                -- OK
        control_rf_wrdata_sel: out std_logic;                           -- OK
        control_rf_wren: out std_logic;                                 -- OK
        control_rf_immed_ext_op: out std_logic_vector(1 downto 0);      -- OK
        
        control_alu_bin_sel: out std_logic;                             -- OK
        control_alu_func: out std_logic_vector(3 downto 0);             -- OK
        
        control_byte_op: out std_logic;                                 -- OK
        control_mem_wren: out std_logic                                 -- OK
    );
end control;

architecture Structural of control is

signal opcode: std_logic_vector(5 downto 0);

begin

    opcode <= instr(31 downto 26);

    control_alu_func <= instr(3 downto 0) when opcode = "100000" 
                   else "0001" when (opcode = "010000" or opcode = "010001") 
                   else "0000" when (opcode = "000011" or opcode = "000111" or opcode = "001111" or opcode = "011111" or opcode = "111000" or opcode = "111001" or opcode = "110000")
                   else "0010" when opcode = "110010" 
                   else "0011" when opcode = "110011"
                   else "----";

    control_alu_bin_sel <= '0' when (opcode = "100000" or opcode = "010000" or opcode = "010001") else '1';
    
    control_rf_immed_ext_op <= "00" when (opcode = "110010" or opcode = "110011")
                          else "01" when (opcode = "111000" or opcode = "110000" or opcode = "000011" or opcode = "000111" or opcode = "001111" or opcode = "011111")
                          else "10" when (opcode = "111001")
                          else "11" when (opcode = "111111" or opcode = "010000" or opcode = "010001")
                          else "--";
                          
    control_rf_wren <= '0' when (opcode = "111111" or opcode = "010000" or opcode = "010001" or opcode = "000111" or opcode = "011111") else '1';
    
    control_rf_wrdata_sel <= '1' when (opcode = "000011" or opcode = "001111") else '0';
    
    control_pc_lden <= '0' when opcode = "000000" else '1';
    
    control_pc_sel <= '1' when (opcode = "111111" or (opcode = "010000" and control_alu_zero = '1') or (opcode = "010001" and control_alu_zero = '0')) else '0';
    
    control_rf_b_sel <= '1' when opcode = "100000" and (instr(3 downto 0) = x"0" or instr(3 downto 0) = x"1" or instr(3 downto 0) = x"2" or instr(3 downto 0) = x"3") else '0';
    
    control_byte_op <= '1' when (opcode = "000011" or opcode = "000111");
    
    control_mem_wren <= '1' when (opcode = "000111" or opcode = "011111");
    
end Structural;
