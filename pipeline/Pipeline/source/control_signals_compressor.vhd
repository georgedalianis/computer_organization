library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_signals_compressor is
    Port (        
        branch: in std_logic;
        conditional_branch: in std_logic;
        conditional_not_branch: in std_logic;
        pc_lden: in std_logic;
        
        alu_bin_sel: in std_logic;
        alu_func: in std_logic_vector(3 downto 0);
        
        rf_wrdata_sel: in std_logic;
        rf_b_sel: in std_logic;
        rf_wren: in std_logic;
        immed_ext: in std_logic_vector(1 downto 0);
        
        byte_op: in std_logic;
        mem_wren: in std_logic;
        
        output_signals: out std_logic_vector(15 downto 0)
    );
end control_signals_compressor;

architecture Structural of control_signals_compressor is

begin
    
    output_signals <= branch & conditional_branch & conditional_not_branch & pc_lden & alu_bin_sel & alu_func
    & rf_wrdata_sel & rf_b_sel & rf_wren & immed_ext & byte_op & mem_wren;

end Structural;
