library Common;
  use Common.CommonLib.all;

architecture RTL of timingGenerator is

  constant prescalerRate: real := 1.0E3;
--  constant prescalerPeriod: time := (1.0 / prescalerRate) * 1 sec;
  constant prescalerPeriod: time := 1 ms;
  constant prescalerMaxValue : positive := integer(clockFrequency/prescalerRate);

  constant i2cDivide: positive := integer(clockFrequency/i2cUpdateRate);
  constant resetPulseCount: positive := integer(resetPulseLength/prescalerPeriod);

  signal khzCounter        : unsigned(requiredBitNb(prescalerMaxValue)-1 downto 0);
  signal statusCounter     : unsigned(statusDivide'range);
  signal i2cUpdateCounter  : unsigned(requiredBitNb(i2cDivide)-1 downto 0);
  signal enable1ms         : std_ulogic;
  signal enableStatus_int  : std_ulogic;
  signal enableI2c_int     : std_ulogic;
  signal resetPulseCounter : unsigned(requiredBitNb(resetPulseCount)-1 downto 0);
  signal endOfResetPulse   : std_ulogic;

begin
  ------------------------------------------------------------------------------
                                     -- Divide 0.1 ms clock to i2c update period
  countI2c: process(clock, reset)
  begin
    if reset = '1' then
      i2cUpdateCounter <= (others => '0');
    elsif rising_edge(clock) then
      if enableI2c_int = '1' then
        i2cUpdateCounter <= (others => '0');
      else
        i2cUpdateCounter <= i2cUpdateCounter + 1;
      end if;
    end if;
  end process countI2c;

  enableI2c_int <= '1' when i2cUpdateCounter >= i2cDivide-1 else '0';

  ------------------------------------------------------------------------------
                            -- Prescaler: divide clock frequency to 1 kHz (1 ms)
  count1ms: process(clock, reset)
  begin
    if reset = '1' then
      khzCounter <= (others => '0');
    elsif rising_edge(clock) then
      if enable1ms = '1' then
        khzCounter <= (others => '0');
      else
        khzCounter <= khzCounter + 1;
      end if;
    end if;
  end process count1ms;

  enable1ms <= '1' when khzCounter >= prescalerMaxValue-1 else '0';

  ------------------------------------------------------------------------------
                                           -- Divide 1 ms clock to status period
  countRs232: process(clock, reset)
  begin
    if reset = '1' then
      statusCounter <= (others => '0');
    elsif rising_edge(clock) then
      if enable1ms = '1' then
        if enableStatus_int = '1' then
          statusCounter <= (others => '0');
        else
          statusCounter <= statusCounter + 1;
        end if;
      end if;
    end if;
  end process countRs232;

  enableStatus_int <= enable1ms when statusCounter >= statusDivide-1 else '0';

  ------------------------------------------------------------------------------
                                      -- Count to BT reset pulse length and stop
  countResetLength: process(clock, reset)
   begin
    if reset = '1' then
      resetPulseCounter <= (others => '0');
    elsif rising_edge(clock) then
      if enable1ms = '1' then
        if endOfResetPulse = '0' then
          resetPulseCounter <= resetPulseCounter + 1;
        end if;
      end if;
    end if;
  end process countResetLength;

  endOfResetPulse <= '1' when resetPulseCounter >= resetPulseCount else '0';

  ------------------------------------------------------------------------------
  -- Assign outputs
  ------------------------------------------------------------------------------
  pOnReset <= not endOfResetPulse;
  enI2c <= enableI2c_int;
  enStatus <= enableStatus_int;

end architecture RTL;

