--
-- VHDL Architecture Sensors.counter_pos1.counter16
--
-- Created:
--          by - aurelien.heritier.UNKNOWN (WEA20305)
--          at - 10:38:02 02.09.2019
--
-- using Mentor Graphics HDL Designer(TM) 2018.1 (Build 12)
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY counter_pos1 IS
    PORT( 
        clock : IN     STD_LOGIC;               -- input clock
        reset : IN     STD_LOGIC;               -- input reset
        en    : IN     STD_ULOGIC;
        value : OUT    unsigned (15 DOWNTO 0)
    );

-- Declarations

END counter_pos1 ;

ARCHITECTURE counter16 OF counter_pos1 IS
	signal sCountOut   : unsigned (15 downto 0);
BEGIN

	count: process(reset, clock)
	begin
	if reset = '1' then
      sCountOut <= (others => '0');
    elsif rising_edge(clock) then
      if en = '1' then
        sCountOut <= sCountOut + 1;
	else
		sCountOut <= (others => '0');
      end if;
    end if;
  end process count;

  value <= sCountOut;

END ARCHITECTURE counter16;

