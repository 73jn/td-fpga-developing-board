--
-- VHDL Architecture Poetic.DAC.DAC124S085
--
-- Created:
--          by - jeann.UNKNOWN (DESKTOP-V46KISN)
--          at - 09:21:02 18.06.2021
--
-- using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
--
ARCHITECTURE DAC124S085 OF DAC IS
BEGIN
  concatenate : process (reset, clock)
  begin
    if reset = '1' then
      masterData <= (others => '0');
      masterWr <= '0';
    elsif rising_edge(clock) then
    masterWr <= '0';
      if send = '1' then
        masterData <= dacSel & mode & data;
        masterWr <= '1';
      end if;
    end if;
  end process concatenate;
END ARCHITECTURE DAC124S085;

