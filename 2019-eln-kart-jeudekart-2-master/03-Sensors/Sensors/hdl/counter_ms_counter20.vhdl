--
-- VHDL Architecture Sensors.counter_ms.counter20
--
-- Created:
--          by - aurelien.heritier.UNKNOWN (WEA20305)
--          at - 10:41:28 02.09.2019
--
-- using Mentor Graphics HDL Designer(TM) 2018.1 (Build 12)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
LIBRARY gates;
USE gates.gates.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY counter_ms IS
    PORT( 
        clock      : IN     STD_LOGIC;    -- input clock
        reset      : IN     STD_LOGIC;    -- input reset
        pulse_read : OUT    std_ulogic
    );

-- Declarations

END counter_ms ;

ARCHITECTURE counter20 OF counter_ms IS
	signal sCountOut   : unsigned (31 downto 0);
	signal valOut   : STD_ULOGIC;
	
BEGIN

	count: process(reset, clock)
	begin
	if reset = '1' then
      sCountOut <= (others => '0');
	  valOut <= '0';
    elsif rising_edge(clock) then
      if sCountOut = "11110100001001000000" then
        sCountOut <= (others => '0');
		valOut <= '1';
	else
		sCountOut <= sCountOut + 1;
		valOut <= '0';
      end if;
    end if;
  end process count;

  pulse_read <= valOut;

END ARCHITECTURE counter20;
