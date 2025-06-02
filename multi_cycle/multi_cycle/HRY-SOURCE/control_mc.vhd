
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_mc is
    Port (
        clk: in std_logic;
        rst: in std_logic;
        
        instr: in std_logic_vector(31 downto 0);
        
        control_pc_lden: out std_logic;                                 -- OK
        control_pc_sel: out std_logic;                                  -- OK
        
        control_alu_zero: in std_logic;                                 -- 
        
        control_intermediate_register_we: out std_logic_vector(4 downto 0);
        
        control_rf_b_sel: out std_logic;                                -- OK
        control_rf_wrdata_sel: out std_logic;                           -- OK
        control_rf_wren: out std_logic;                                 -- OK
        control_rf_immed_ext_op: out std_logic_vector(1 downto 0);      -- OK
        
        control_alu_bin_sel: out std_logic;                             -- OK
        control_alu_func: out std_logic_vector(3 downto 0);             -- OK
        
        control_byte_op: out std_logic;                                 -- OK
        control_mem_wren: out std_logic                                 -- OK
    );
end control_mc;

architecture Behavioral of control_mc is

type instruction_state is (
    FETCH,
    DECODE,
    EXECUTE,
    BRANCH_COMPLETION,
    COND_BRANCH_COMPLETION,
    MEM_STORE,
    MEM_LOAD,
    RF_WRITE_ALU,
    RF_WRITE_MEM
);

signal state: instruction_state;
signal opcode: std_logic_vector(5 downto 0);

-- opcode = 100000              FETCH -> DECODE -> EXECUTE -> RF_WRITE_ALU
-- opcode = 111000 (li)         FETCH -> DECODE -> EXECUTE -> RF_WRITE_ALU
-- opcode = 111001 (lui)        FETCH -> DECODE -> EXECUTE -> RF_WRITE_ALU
-- opcode = 110000 (addi)       FETCH -> DECODE -> EXECUTE -> RF_WRITE_ALU
-- opcode = 110010 (andi)       FETCH -> DECODE -> EXECUTE -> RF_WRITE_ALU
-- opcode = 110011 (ori)        FETCH -> DECODE -> EXECUTE -> RF_WRITE_ALU
-- opcode = 111111 (b)          FETCH -> DECODE -> BRANCH_COMPLETION
-- opcode = 010000 (beq)        FETCH -> DECODE -> EXECUTE -> COND_BRANCH_COMPLETION
-- opcode = 010001 (bne)        FETCH -> DECODE -> EXECUTE -> COND_BRANCH_COMPLETION
-- opcode = 000011 (lb)         FETCH -> DECODE -> EXECUTE -> MEM_LOAD -> EF_WRITE_MEM
-- opcode = 001111 (lw)         FETCH -> DECODE -> EXECUTE -> MEM_LOAD -> EF_WRITE_MEM
-- opcode = 000111 (sb)         FETCH -> DECODE -> EXECUTE -> MEM_STORE
-- opcode = 011111 (sw)         FETCH -> DECODE -> EXECUTE -> MEM_STORE

begin

    opcode <= instr(31 downto 26);
    
    control_pc_lden <= '1' when state = FETCH or state = BRANCH_COMPLETION or (state = COND_BRANCH_COMPLETION and control_alu_zero = '1' and opcode = "010000")
                             or (state = COND_BRANCH_COMPLETION and control_alu_zero = '0' and opcode = "010001") else '0';
                             
                           
    control_pc_sel <= '1' when state = BRANCH_COMPLETION or state = COND_BRANCH_COMPLETION else '0';
    
    control_byte_op <= '1' when (state = MEM_LOAD and opcode = "000011") or (state = MEM_STORE and opcode = "000111") else '0';
    control_mem_wren <= '1' when state = MEM_STORE else '0';
    
    control_alu_func <= "----" when state /= EXECUTE else
                        instr(3 downto 0) when opcode = "100000" else
                        x"1" when opcode = "010000" or opcode = "010001" else
                        x"0" when opcode = "110000" or opcode = "000011" or opcode = "000111" or
                        opcode = "001111" or opcode = "011111" or opcode = "111000" or opcode = "111001" else
                        x"2" when opcode = "110010" else
                        x"3" when opcode = "110011" else 
                        "----";
                        
    control_alu_bin_sel <= '-' when state /= EXECUTE else
                           '0' when (opcode = "100000" or opcode = "010000" or opcode = "010001") else '1';
                           
    control_rf_immed_ext_op <= "--" when state /= DECODE else
                               "00" when (opcode = "110010" or opcode = "110011")
                          else "01" when (opcode = "111000" or opcode = "110000" or opcode = "000011" or opcode = "000111" or opcode = "001111" or opcode = "011111")
                          else "10" when (opcode = "111001")
                          else "11" when (opcode = "111111" or opcode = "010000" or opcode = "010001")
                          else "--";
                          
    control_rf_wren <= '1' when state = RF_WRITE_ALU or state = RF_WRITE_MEM else '0';
    control_rf_wrdata_sel <= '1' when state = RF_WRITE_MEM else '0' when state = RF_WRITE_ALU else '-';
    
    control_rf_b_sel <= '-' when state /= DECODE else
                        '1' when (opcode = "100000" and (instr(3 downto 0) = x"0" or instr(3 downto 0) = x"1" or 
                        instr(3 downto 0) = x"2" or instr(3 downto 0) = x"3")) or opcode = "010000" or opcode = "010001" else '0';
                        
                        
    control_intermediate_register_we <= "00001" when state = FETCH else "01110" when state = DECODE else 
                                        "10000" when state = EXECUTE else "00000";
    
    MEALY_FSM: process begin
    
        wait until clk'event and clk = '1';
        
        if rst = '1' then
            state <= FETCH;
        else
            case state is
            
                when FETCH => 
                    state <= DECODE;
                
                when DECODE =>
                    if opcode /= "111111" then
                        state <= EXECUTE;
                    else
                        state <= BRANCH_COMPLETION;
                    end if;
                    
                when BRANCH_COMPLETION =>
                    state <= FETCH;
                
                when EXECUTE =>
                    if opcode = "010000" or opcode = "010001" then
                        state <= COND_BRANCH_COMPLETION;
                    elsif opcode = "000011" or opcode = "001111" then
                        state <= MEM_LOAD;
                    elsif opcode = "000111" or opcode = "011111" then
                        state <= MEM_STORE;
                    else
                        state <= RF_WRITE_ALU;
                    end if;
                    
                when COND_BRANCH_COMPLETION =>
                    state <= FETCH;
                    
                when MEM_LOAD =>
                    state <= RF_WRITE_MEM;
                    
                when MEM_STORE =>
                    state <= FETCH;
                    
                when RF_WRITE_ALU =>
                    state <= FETCH;
                    
                when RF_WRITE_MEM =>
                    state <= FETCH;
            
            end case;
        end if;
    
    end process;


end Behavioral;
