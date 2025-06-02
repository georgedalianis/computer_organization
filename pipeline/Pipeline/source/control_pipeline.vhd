library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_pipeline is
    Port (
        instruction: in std_logic_vector(31 downto 0);
        
        branch: out std_logic;
        conditional_branch: out std_logic;
        conditional_not_branch: out std_logic;
        pc_lden: out std_logic;
        
        alu_bin_sel: out std_logic;
        alu_func: out std_logic_vector(3 downto 0);
        
        rf_wrdata_sel: out std_logic;
        rf_b_sel: out std_logic;
        rf_wren: out std_logic;
        immed_ext: out std_logic_vector(1 downto 0);
        
        byte_op: out std_logic;
        mem_wren: out std_logic
    );
end control_pipeline;

architecture Structural of control_pipeline is

signal opcode: std_logic_vector(5 downto 0);

begin
    
    -- The opcode of the instruction
    opcode <= instruction(31 downto 26);
    
    -- Set branch flags...
    branch <= '1' when opcode = "111111" else '0';
    conditional_branch <= '1' when opcode = "000000" else '0';
    conditional_not_branch <= '1' when opcode = "000001" else '0';
    
    -- PC load enable is alaways active
    pc_lden <= '1';
    
    -- The alu function of an instruction
    alu_func <=      instruction(3 downto 0) when opcode = "100000"
                else x"0" when opcode = "111000" or opcode = "111001" or opcode = "110000" or (opcode(5) = '0' and opcode(1 downto 0) = "11")
                else x"1" when opcode = "000000" or opcode = "000001"
                else x"5" when opcode = "110010"
                else x"3" when opcode = "110011"
                else "----";
    
    -- Alu bin sel is 0 when the instruction does not use immed value.
    alu_bin_sel <= '0' when opcode = "100000" or opcode = "000000" or opcode = "000001" else '1';
    
    -- This flag is '1' only when lb and sb instrucitons are used.
    byte_op <= '1' when opcode = "000011" or opcode = "000111" else '0';
    
    -- Write to memory only when instructions are sw or sb
    mem_wren <= '1' when opcode = "000111" or opcode = "011111" else '0';
    
    -- This is '1' only when the Register R[rd] must be read. (instructions beq, bne, sb, sw)...
    rf_b_sel <= '1' when opcode = "000000" or opcode = "000001" or opcode = "000111" or opcode = "011111" else '0';
    
    -- This is '0' only when the instruction does not write data to Register R[rd]. (instructions b, beq, bne, sw, sb)
    rf_wren <= '0' when opcode = "111111" or opcode = "000000" or opcode = "000001" or opcode = "000111" or opcode = "011111" else '1';
    
    -- This is '0' when the instruction is ALU related.
    rf_wrdata_sel <= '0' when instruction(31) = '1' else '1';
    
    -- The operation that will be performed in the immed part of the instruction
    immed_ext <=         "00" when opcode = "100000" or opcode = "111000" or opcode = "110010" or opcode = "110011" or opcode = "000011"
                    else "01" when opcode = "110000" or opcode = "000111" or opcode = "001111" or opcode = "011111"
                    else "10" when opcode = "111001"
                    else "11";

end Structural;