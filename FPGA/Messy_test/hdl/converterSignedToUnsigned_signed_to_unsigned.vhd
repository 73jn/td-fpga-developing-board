--
-- VHDL Architecture Poetic_test.converterSignedToUnsigned.signed_to_unsigned
--
-- Created:
--          by - jeann.UNKNOWN (DESKTOP-V46KISN)
--          at - 14:51:17 02.07.2021
--
-- using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
--
ARCHITECTURE signed_to_unsigned OF converterSignedToUnsigned IS
BEGIN
  process (input)
  begin
    output <= unsigned(input);
  end process;
END ARCHITECTURE signed_to_unsigned;

