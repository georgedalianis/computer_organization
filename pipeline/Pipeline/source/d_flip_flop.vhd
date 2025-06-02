library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity d_flip_flop is
    Port (
        clock: in std_logic;
        reset: in std_logic;
        
        datain: in std_logic;
        dataout: out std_logic
    );
end d_flip_flop;

architecture Behavioral of d_flip_flop is

signal output: std_logic;

begin

    dataout <= output;

    process begin
    
    wait until clock'event and clock = '1';
    
    if reset = '1' then
        output <= '0';
    else
        output <= datain;
    end if;
    
    end process;


end Behavioral;
