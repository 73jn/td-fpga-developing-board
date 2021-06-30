--
-- VHDL Architecture Sensors.counterImpuls.counter
--
-- Created:
--          by - aurelien.heritier.UNKNOWN (WEA20305)
--          at - 08:22:13 22.08.2019
--
-- using Mentor Graphics HDL Designer(TM) 2018.1 (Build 12)
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY counterImpuls IS
    PORT( 
        clk   : IN     STD_LOGIC;               -- input clock
        rst   : IN     STD_LOGIC;               -- input reset
        clear : IN     STD_ULOGIC;
        en    : IN     STD_ULOGIC;
        value : OUT    unsigned (15 DOWNTO 0)
    );

-- Declarations

END counterImpuls ;

ARCHITECTURE counter OF counterImpuls IS
	signal sCountOut   : unsigned (15 downto 0);
BEGIN

	count: process(rst, clk)
	begin
	if rst = '1' then
      sCountOut <= (others => '0');
	elsif clear = '1' then
		sCountOut <= (others => '0');
    elsif rising_edge(clk) then
      if en = '1' then
        sCountOut <= sCountOut + 1;
      end if;
    end if;
  end process count;

  value <= sCountOut;

END ARCHITECTURE counter;
