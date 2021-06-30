ARCHITECTURE RTL OF stepperMotorDivider IS

  signal testPrescalerCounter: unsigned(testPrescalerBitNb-1 downto 0);
  signal testPrescalerDone: std_ulogic;

  signal prescalerCounter: unsigned(prescalerBitNb-1 downto 0);
  signal prescalerDone: std_ulogic;

  signal dividerCounter: unsigned(divider'range);
  signal divideDone: std_ulogic;

BEGIN
  ------------------------------------------------------------------------------
                                                  -- test mode prescaler counter
  testDivide: process(reset, clock)
  begin
    if reset = '1' then
      testPrescalerCounter <= (others => '0');
    elsif rising_edge(clock) then
      testPrescalerCounter <= testPrescalerCounter + 1;
    end if;
  end process testDivide;

  testPrescalerDone <= '1' when testMode = '0'
    else '1' when testPrescalerCounter = 0
    else '0';

  ------------------------------------------------------------------------------
                                                            -- prescaler counter
  prescalerDivide: process(reset, clock)
  begin
    if reset = '1' then
      prescalerCounter <= (others => '0');
    elsif rising_edge(clock) then
      if testPrescalerDone = '1' then
        prescalerCounter <= prescalerCounter + 1;
      end if;
    end if;
  end process prescalerDivide;

  prescalerDone <= testPrescalerDone when prescalerCounter = 0
    else '0';

  ------------------------------------------------------------------------------
                                                            -- presacler counter
  stepDivide: process(reset, clock)
  begin
    if reset = '1' then
      dividerCounter <= (others => '0');
    elsif rising_edge(clock) then
      if prescalerDone = '1' then
        if divideDone = '1' then
          dividerCounter <= (others => '0');
        else
          dividerCounter <= dividerCounter + 1;
        end if;
      end if;
    end if;
  end process stepDivide;

  divideDone <= prescalerDone when dividerCounter+1 >= divider
    else '0';
  pwmEn <= divideDone;

END ARCHITECTURE RTL;
