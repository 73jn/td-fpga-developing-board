--
-- VHDL Architecture Poetic_test.converter.std_uLogic_to_signed
--
-- Created:
--          by - jeann.UNKNOWN (DESKTOP-V46KISN)
--          at - 13:50:02 02.07.2021
--
-- using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
--
ARCHITECTURE std_uLogic_to_signed OF converter IS
BEGIN
  process (input)
  begin
    if input = '0' then
      output <= to_signed(0, output'length);
    else
      output <= to_signed(1, output'length);
    end if;
  end process;
END ARCHITECTURE std_uLogic_to_signed;

