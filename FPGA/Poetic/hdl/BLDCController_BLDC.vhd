--
-- VHDL Architecture Poetic.BLDCController.BLDC
--
-- Created:
--          by - jean.nanchen.UNKNOWN (WEA30407)
--          at - 11:42:58 22.07.2021
--
-- using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
--
ARCHITECTURE BLDC OF BLDCController IS
	CONSTANT con_Kp : INTEGER := 1;
  signal bigCounter : unsigned(26 DOWNTO 0);
  signal hallReg : std_ulogic_vector(2 DOWNTO 0);
BEGIN
  process (clock, reset)
  begin
    if reset = '1' then
      bigCounter <= 0;
    elsif rising_edge(clock) then
	    bigCounter <= bigCounter + 1;
	end if;
  end process;

  updateHallReg : process (Hall_A, Hall_B, Hall_C)
  begin
    hallReg <= Hall_A & Hall_B & Hall_C;
  end process updateHallReg;
END ARCHITECTURE BLDC;

