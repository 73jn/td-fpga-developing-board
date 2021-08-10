--
-- VHDL Architecture Poetic.threephase.phaseGenerator
--
-- Created:
--          by - jeann.UNKNOWN (DESKTOP-V46KISN)
--          at - 13:54:19 21.06.2021
--
-- using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
--
ARCHITECTURE phaseGenerator OF threephase IS
  constant offsetPhase1: unsigned := to_unsigned(0, phase1'length);
  constant offsetPhase2: unsigned := to_unsigned((2**phaseBitNb)/3, phase2'length); -- 1/3 2^phaseBitNb
  constant offsetPhase3: unsigned := to_unsigned(2*((2**phaseBitNb)/3), phase3'length); -- 2/3 phaseBitNb
BEGIN
  generatePhase : process (reset, clock)
  begin
    if reset = '1' then
      phase1 <= (others => '0');
      phase2 <= (others => '0');
      phase3 <= (others => '0');
    elsif rising_edge(clock) then
      phase1 <= phaseIn + offsetPhase1;
      phase2 <= phaseIn + offsetPhase2;
      phase3 <= phaseIn + offsetPhase3;
    end if;
  end process generatePhase;
END ARCHITECTURE phaseGenerator;

