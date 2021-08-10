--
-- VHDL Architecture Poetic_test.poetic_tester.test
--
-- Created:
--          by - jeann.UNKNOWN (DESKTOP-V46KISN)
--          at - 15:47:25 15.06.2021
--
-- using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
--
ARCHITECTURE test OF messy_tester IS
  constant clockFrequency: real := 66.0E6;
  constant clockPeriod: time := (1.0/clockFrequency) * 1 sec;
  signal sClock: std_uLogic := '1';
BEGIN
  ------------------------------------------------------------------------------
                                                              -- clock and reset
  sClock <= not sClock after clockPeriod/2;
  clock <= transport sClock after clockPeriod*9/10;
  reset <= '1', '0' after 2*clockPeriod;

  ------------------------------------------------------------------------------
                                                                       -- enable
                                                                       
  enable <= '0', '1' after 1 us;
  notenable <= '0';
  SetVal <= "000000000000", "011111111111" after 15 us;
  dacData <= "00000000", "01010011" after 10 us;
  dacSel <= "11";
  dacMode <= "01";
  send <= '0', '1' after 11 us;
END ARCHITECTURE test;

