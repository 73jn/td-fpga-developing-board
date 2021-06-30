ARCHITECTURE RTL OF dcMotorPwm IS

  signal sign: std_ulogic;
  signal speedAmplitude: unsigned(speed'high-1 downto 0);
  signal sawtooth: unsigned(speedAmplitude'range);

BEGIN
  ------------------------------------------------------------------------------
                                                                    -- direction
  sign <= speed(speed'high);
  forwards <= not sign when normalDirection = '1'
    else sign;

  ------------------------------------------------------------------------------
                                                                          -- PWM
  speedAmplitude <= unsigned(speed(speedAmplitude'range)) when sign = '0'
    else unsigned(-speed(speedAmplitude'range));

  storeValues: process(reset, clock)
  begin
    if reset = '1' then
      sawtooth <= (others => '0');
    elsif rising_edge(clock) then
      if en = '1' then
        sawtooth <= sawtooth + 1;
      end if;
    end if;
  end process storeValues;

  pwmOut <= '0' when speedAmplitude = 0
    else '1' when speedAmplitude >= sawtooth
    else '0';

END ARCHITECTURE RTL;
