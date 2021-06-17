ARCHITECTURE RTL OF cmdRegUnsigned IS

BEGIN

  updateRegister: process(reset, clock)
  begin
    if reset = '1' then
      regValue <= (others => '0');
    elsif rising_edge(clock) then
      if en = '1' then
        regValue <= commandValue;
      end if;
    end if;
  end process updateRegister;

END ARCHITECTURE RTL;
