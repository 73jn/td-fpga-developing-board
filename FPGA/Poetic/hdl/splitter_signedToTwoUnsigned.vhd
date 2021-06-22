--
-- VHDL Architecture Poetic.splitter.signedToTwoUnsigned
--
-- Created:
--          by - jeann.UNKNOWN (DESKTOP-V46KISN)
--          at - 10:06:48 22.06.2021
--
-- using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
--
ARCHITECTURE signedToTwoUnsigned OF splitter IS
  signal sigUnsignedNeg : unsigned(unsignedNeg'range);
  signal sigUnsignedPos : unsigned(unsignedPos'range);
BEGIN
  unsignedNeg <= sigUnsignedNeg;
  unsignedPos <= sigUnsignedPos;
  process (clock, reset)
  begin
    if reset = '1' then
      sigUnsignedNeg <= (others => '0');
      sigUnsignedPos <= (others => '0');
    elsif rising_edge(clock) then
      if signedIn > 0 then
        sigUnsignedPos <= shift_left(unsigned(signedIn),1);
        sigUnsignedNeg <= (others => '0');
      else
        sigUnsignedNeg <= shift_left(unsigned(not(signedIn)),1);
        sigUnsignedPos <= (others => '0');
      end if;
    end if;
  end process;
END ARCHITECTURE signedToTwoUnsigned;