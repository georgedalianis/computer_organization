library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity datapath_pipeline is
    Port (
        clock: in std_logic;
        reset: in std_logic;
        
        instruction: in std_logic_vector(31 downto 0);
        control_signals: in std_logic_vector(15 downto 0);
        
        pc: out std_logic_vector(31 downto 0);
        
        mm_wren: out std_logic;
        mm_rddata: in std_logic_vector(31 downto 0);
        mm_wrdata: out std_logic_vector(31 downto 0);
        mm_addr: out std_logic_vector(10 downto 0)
    );
end datapath_pipeline;

architecture Behavioral of datapath_pipeline is

component fetch_register is
    Port (
        clock: in std_logic;
        reset: in std_logic;
        write_enable: in std_logic;
    
        instr_in: in std_logic_vector(31 downto 0);
        instr_out: out std_logic_vector(31 downto 0);
        
        control_signals_in: in std_logic_vector(15 downto 0);
        control_signals_out: out std_logic_vector(31 downto 0)
    );
end component;

component ifstage is
    Port (
        clock: in std_logic;
        reset: in std_logic;
        
        pc_lden: in std_logic;
        pc_sel: in std_logic;
        
        pc_immed: in std_logic_vector(31 downto 0);
        pc: out std_logic_vector(31 downto 0)
    );
end component;

component decode_register is
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
end component;

component decstage_pipeline is
    Port (
        clock: in std_logic;
        reset: in std_logic;
        
        instr: in std_logic_vector(31 downto 0);
        
        rf_wren: in std_logic;
        alu_out: in std_logic_vector(31 downto 0);
        mem_out: in std_logic_vector(31 downto 0);
        rf_wrdata_sel: in std_logic;
        address_write: in std_logic_vector(4 downto 0);
        
        rf_b_sel: in std_logic;
        
        imm_ext: in std_logic_vector(1 downto 0);
        
        immed: out std_logic_vector(31 downto 0);
        rf_a: out std_logic_vector(31 downto 0);
        rf_b: out std_logic_vector(31 downto 0)
    );
end component;

component branch_controler is
    Port (
        b: in std_logic;
        cb: in std_logic;
        cnb: in std_logic;
        alu_zero: in std_logic;
        
        branch_immed: in std_logic_vector(31 downto 0);
        conditional_immed: in std_logic_vector(31 downto 0);
        
        dump: out std_logic;
        chosen_immed: out std_logic_vector(31 downto 0)
    );
end component;

component exstage is
    Port (
        rf_a: in std_logic_vector(31 downto 0);
        rf_b: in std_logic_vector(31 downto 0);
        immed: in std_logic_vector(31 downto 0);
        
        alu_bin_sel: in std_logic;
        
        alu_func: in std_logic_vector(3 downto 0);
        alu_out: out std_logic_vector(31 downto 0);
        alu_zero: out std_logic
    );
end component;

component execute_register is
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
end component;

component memstage is
    Port ( 
        byte_op: in std_logic;
        mem_wren: in std_logic;
        
        alu_mem_addr: in std_logic_vector(31 downto 0);
        
        mem_datain: in std_logic_vector(31 downto 0);
        mem_dataout: out std_logic_vector(31 downto 0);
        
        mm_wren: out std_logic;
        mm_addr: out std_logic_vector(10 downto 0);
        
        mm_wrdata: out std_logic_vector(31 downto 0);
        mm_rddata: in std_logic_vector(31 downto 0)
    );
end component;

component memory_register is
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
end component;

component interrupt_generator is
    Port (
        mem_rf_wrdata_sel: in std_logic;
        mem_rf_wren: in std_logic;
        ex_rf_wrdata_sel: in std_logic;
        ex_rf_wren: in std_logic;
        
        comparator_halt: in std_logic;
        
        address_ex: in std_logic_vector(4 downto 0);
        address_mem: in std_logic_vector(4 downto 0);
        address_write: out std_logic_vector(4 downto 0);
        
        rf_wren: out std_logic;
        rf_wrdata_sel: out std_logic;
        halt: out std_logic
    );
end component;

component forwarding_unit is
    Port ( 
        rd: in std_logic_vector(4 downto 0);
        rt: in std_logic_vector(4 downto 0);
        rs: in std_logic_vector(4 downto 0);
        b_sel: in std_logic;
        
        wb_rd: in std_logic_vector(4 downto 0);
        ex_rd: in std_logic_vector(4 downto 0);
        mem_rd: in std_logic_vector(4 downto 0);
        
        wb_rf_wren: in std_logic;
        ex_rf_wren: in std_logic;
        mem_rf_wren: in std_logic;
        
        ex_rf_wrdata_sel: in std_logic;
        mem_rf_wrdata_sel: in std_logic;
        
        wb_data: in std_logic_vector(31 downto 0);
        ex_data: in std_logic_vector(31 downto 0);
        mem_data: in std_logic_vector(31 downto 0);
        
        A: in std_logic_vector(31 downto 0);
        B: in std_logic_vector(31 downto 0);
        
        forwarded_A: out std_logic_vector(31 downto 0);
        forwarded_B: out std_logic_vector(31 downto 0);
        
        stall: out std_logic
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

-- FETCH REGISTER SIGNALS
signal fetch_register_reset_signal: std_logic;
signal fetch_register_instruction_signal: std_logic_vector(31 downto 0);
signal fetch_register_control_signals: std_logic_vector(31 downto 0);

-- DECODE REGISTER SIGNALS
signal decode_register_reset_signal: std_logic;
signal decode_register_instruction_signal: std_logic_vector(31 downto 0);
signal decode_register_control_signals: std_logic_vector(31 downto 0);
signal decode_register_rf_a_signal: std_logic_vector(31 downto 0);
signal decode_register_rf_b_signal: std_logic_vector(31 downto 0);
signal decode_register_immed_signal: std_logic_vector(31 downto 0);
signal decode_register_wb_data_signal: std_logic_vector(31 downto 0);
signal decode_register_wb_rf_wren_signal: std_logic;
signal decode_register_wb_address_write_signal: std_logic_vector(4 downto 0);

-- EXECUTE REGISTER SIGNALS
signal execute_register_reset_signal: std_logic;
signal execute_register_instruction_signal: std_logic_vector(31 downto 0);
signal execute_register_control_signals: std_logic_vector(31 downto 0);
signal execute_register_alu_out_signal: std_logic_vector(31 downto 0);
signal execute_register_B_signal: std_logic_vector(31 downto 0);

-- MEMORY REGISTER SIGNALS
signal memory_register_reset_signal: std_logic;
signal memory_register_instruction_signal: std_logic_vector(31 downto 0);
signal memory_register_control_signals: std_logic_vector(31 downto 0);
signal memory_register_mem_out_signal: std_logic_vector(31 downto 0);

-- DECSTAGE SIGNALS
signal rf_a_signal: std_logic_vector(31 downto 0);
signal immediate_signal: std_logic_vector(31 downto 0);
signal rf_b_signal: std_logic_vector(31 downto 0);

-- EXSTAGE SIGNALS
signal alu_zero_signal: std_logic;
signal alu_out_signal: std_logic_vector(31 downto 0);

-- MEMSTAGE SIGNALS
signal mem_out_signal: std_logic_vector(31 downto 0);

-- INTERRUPT GENERATOR SIGNALS
signal halt: std_logic;
signal halt_signal: std_logic;
signal rf_wren_signal: std_logic;
signal rf_address_write: std_logic_vector(4 downto 0);
signal rf_write_data: std_logic_vector(31 downto 0);
signal rf_wrdata_sel: std_logic;

-- BRANCH CONTROLLER SIGNALS
signal dump: std_logic;
signal pc_immed_signal: std_logic_vector(31 downto 0);

-- FORWARDER SIGNALS
signal stall_signal: std_logic;
signal forwarded_A: std_logic_vector(31 downto 0);
signal forwarded_B: std_logic_vector(31 downto 0);

-- FLIP FLOP SIGNALS
signal previous_halt: std_logic;
signal not_halt: std_logic;

begin

    not_halt <= not halt;
    
    memory_register_reset_signal <= previous_halt or reset;

    flop: d_flip_flop port map(
        clock => clock,
        reset => reset,
        
        datain => not_halt,
        dataout => previous_halt
    );

    rf_write_data <= execute_register_alu_out_signal when rf_wrdata_sel = '0' else memory_register_mem_out_signal;
    
    halt <= not (halt_signal and (not previous_halt));
    
    fetch_register_reset_signal <= (dump and halt) or reset;
    
    decode_register_reset_signal <= (dump and halt and (decode_register_control_signals(14) or decode_register_control_signals(13))) or reset;
    
    execute_register_reset_signal <= reset;

    fetch_stage: ifstage port map(
        clock => clock,
        reset => reset,
        
        pc_lden => halt,
        pc_sel => dump,
        
        pc_immed => pc_immed_signal,
        pc => pc
    );

    fetch_register_component: fetch_register port map(
        clock => clock,
        reset => fetch_register_reset_signal,
        write_enable => halt,
        
        instr_in => instruction,
        instr_out => fetch_register_instruction_signal,
        
        control_signals_in => control_signals,
        control_signals_out => fetch_register_control_signals
    );
    
    decode_register_component: decode_register port map(
        clock => clock,
        reset => decode_register_reset_signal,
        write_enable => halt,
        
        instr_in => fetch_register_instruction_signal,
        instr_out => decode_register_instruction_signal,
        
        control_signals_in => fetch_register_control_signals,
        control_signals_out => decode_register_control_signals,
        
        rf_a_in => rf_a_signal,
        rf_a_out => decode_register_rf_a_signal,
        
        rf_b_in => rf_b_signal,
        rf_b_out => decode_register_rf_b_signal,
        
        immed_in => immediate_signal,
        immed_out => decode_register_immed_signal,
        
        write_back_data_in => rf_write_data,
        write_back_data_out => decode_register_wb_data_signal,
        
        write_address_in => rf_address_write,
        write_address_out => decode_register_wb_address_write_signal,
        
        was_written_in => rf_wren_signal,
        was_written_out => decode_register_wb_rf_wren_signal
    );
    
    decodint_stage: decstage_pipeline port map(
        clock => clock,
        reset => reset,
        
        instr => fetch_register_instruction_signal,
        
        rf_wren => rf_wren_signal,
        alu_out => execute_register_alu_out_signal,
        mem_out => memory_register_mem_out_signal,
        rf_wrdata_sel => rf_wrdata_sel,
        address_write => rf_address_write,
        
        rf_b_sel => fetch_register_control_signals(5),
        
        imm_ext => fetch_register_control_signals(3 downto 2),
        
        immed => immediate_signal,
        rf_a => rf_a_signal,
        rf_b => rf_b_signal
    );
    
    branch_controller_component: branch_controler port map(
        b => fetch_register_control_signals(15),
        cb => decode_register_control_signals(14),
        cnb => decode_register_control_signals(13),
        alu_zero => alu_zero_signal,
        
        branch_immed => immediate_signal,
        conditional_immed => decode_register_immed_signal,
        
        dump => dump,
        chosen_immed => pc_immed_signal
    );
    
    execute_stage: exstage port map(
        rf_a => forwarded_A,
        rf_b => forwarded_B,
        immed => decode_register_immed_signal,
        
        alu_bin_sel => decode_register_control_signals(11),
        alu_func => decode_register_control_signals(10 downto 7),
        
        alu_out => alu_out_signal,
        alu_zero => alu_zero_signal
    );
    
    execute_register_component: execute_register port map(
        clock => clock,
        reset => execute_register_reset_signal,
        write_enable => halt,
        
        instr_in => decode_register_instruction_signal,
        instr_out => execute_register_instruction_signal,
        
        control_signals_in => decode_register_control_signals,
        control_signals_out => execute_register_control_signals,
        
        alu_result_in => alu_out_signal,
        alu_result_out => execute_register_alu_out_signal,
        
        B_in => forwarded_B,
        B_out => execute_register_B_signal
    );
    
    memory_stage: memstage port map(
        byte_op => execute_register_control_signals(1),
        mem_wren => execute_register_control_signals(0),
        
        alu_mem_addr => execute_register_alu_out_signal,
        
        mem_datain => execute_register_B_signal,
        mem_dataout => mem_out_signal,
        
        mm_wren => mm_wren,
        mm_addr => mm_addr,
        
        mm_wrdata => mm_wrdata,
        mm_rddata => mm_rddata
    );
    
    memory_register_component: memory_register port map(
        clock => clock,
        reset => memory_register_reset_signal,
        write_enable => '1',
        
        instr_in => execute_register_instruction_signal,
        instr_out => memory_register_instruction_signal,
        
        control_signals_in => execute_register_control_signals,
        control_signals_out => memory_register_control_signals,
        
        mem_data_in => mem_out_signal,
        mem_data_out => memory_register_mem_out_signal
    );
    
    interrupt_component: interrupt_generator port map(
        mem_rf_wrdata_sel => memory_register_control_signals(6),
        mem_rf_wren => memory_register_control_signals(4),
        ex_rf_wrdata_sel => execute_register_control_signals(6),
        ex_rf_wren => execute_register_control_signals(4),
        
        comparator_halt => stall_signal,
        
        address_ex => execute_register_instruction_signal(20 downto 16),
        address_mem => memory_register_instruction_signal(20 downto 16),
        address_write => rf_address_write,
        
        rf_wren => rf_wren_signal,
        rf_wrdata_sel => rf_wrdata_sel,
        halt => halt_signal
    );
    
    forwarding_unit_component: forwarding_unit port map(
        rd => decode_register_instruction_signal(20 downto 16),
        rt => decode_register_instruction_signal(15 downto 11),
        rs => decode_register_instruction_signal(25 downto 21),
        b_sel => decode_register_control_signals(5),
        
        wb_rd => decode_register_wb_address_write_signal,
        ex_rd => execute_register_instruction_signal(20 downto 16),
        mem_rd => memory_register_instruction_signal(20 downto 16),
        
        wb_rf_wren => decode_register_wb_rf_wren_signal,
        ex_rf_wren => execute_register_control_signals(4),
        mem_rf_wren => memory_register_control_signals(4),
        
        ex_rf_wrdata_sel => execute_register_control_signals(6),
        mem_rf_wrdata_sel => memory_register_control_signals(6),
        
        wb_data => decode_register_wb_data_signal,
        ex_data => execute_register_alu_out_signal,
        mem_data => memory_register_mem_out_signal,
        
        A => decode_register_rf_a_signal,
        B => decode_register_rf_b_signal,
        
        forwarded_A => forwarded_A,
        forwarded_B => forwarded_B,
        
        stall => stall_signal
    );

end Behavioral;
