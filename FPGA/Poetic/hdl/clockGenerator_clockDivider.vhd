--
-- VHDL Architecture Poetic.clockGenerator.clockDivider
--
-- Created:
--          by - jeann.UNKNOWN (DESKTOP-V46KISN)
--          at - 11:15:13 17.06.2021
--
-- using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
--
ARCHITECTURE clockDivider OF clockGenerator IS
  constant countValue : integer := integer(real(frequencyIn) / real((frequencyOut*2)));
  signal counter : unsigned(counterBitNb-1 DOWNTO 0);
  signal clockOut_int : std_ulogic;
BEGIN
  clockOut <= clockOut_int;
  increment : process(reset, clock)
  begin
    if reset = '1' then
	  clockOut_int <= '0';
      counter <= (others => '0');
      counter(counter'low) <= '1';
    elsif rising_edge(clock) then
      if enable = '1' then
        counter <= counter + 1;
          if (counter >= countValue) then
            clockOut_int <= not clockOut_int;
            counter <= (others => '0');
            counter(counter'low) <= '1';
          end if;
      else
        clockOut_int <= '0';
      end if;
    end if;
  end process increment;
END ARCHITECTURE clockDivider;

