ARCHITECTURE RTL OF dcMotorRegisters IS

  constant prescalerBaseAddr: natural := baseAddress;
  constant speedBaseAddr    : natural := baseAddress + 2;
  constant hwRestartId      : natural := 4;
  constant hwBtConnectedId  : natural := 5;
  constant registerLength: positive := 2*busDataIn'length;
  signal prescaler_int: unsigned(registerLength-1 downto 0);
  signal speed_int    :   signed(registerLength-1 downto 0);
  signal enDelayed: std_ulogic;

BEGIN
  ------------------------------------------------------------------------------
                                                         -- store bytes from I2C
  storeBytes: process(reset, clock)
  begin
    if reset = '1' then
      prescaler_int <= (others => '0');
      speed_int <= (others => '0');
      hwOrientation <= (others => '0');
      restart <= '0';
      btConnected <= '0';
    elsif rising_edge(clock) then
      if en = '1' then
        if write = '1' then
          case to_integer(busAddress) is
            when prescalerBaseAddr =>
              prescaler_int(busDataIn'range) <= unsigned(busDataIn);
            when prescalerBaseAddr+1 =>
              prescaler_int(
                prescaler_int'high downto prescaler_int'length-busDataIn'length
              ) <= unsigned(busDataIn);
            when speedBaseAddr =>
              speed_int(busDataIn'range) <= signed(busDataIn);
            when speedBaseAddr+1 =>
              speed_int(
                speed_int'high downto speed_int'length-busDataIn'length
              ) <= signed(busDataIn);
            when orientationBaseAddress =>
              hwOrientation <= busDataIn(hwOrientation'range);
              restart <= busDataIn(hwRestartId);
              btConnected <= busDataIn(hwBtConnectedId);
            when others => null;
          end case;
        end if;
      end if;
    end if;
  end process storeBytes;

  ------------------------------------------------------------------------------
                                                                 -- update words
  storeValues: process(reset, clock)
  begin
    if reset = '1' then
      enDelayed <= '0';
      prescaler <= (others => '0');
      speed <= (others => '0');
    elsif rising_edge(clock) then
      enDelayed <= en;
      if enDelayed = '1' then
        if busAddress(0) = '1' then
          prescaler <= resize(prescaler_int, prescaler'length);
          speed <= resize(speed_int, speed'length);
        end if;
      end if;
    end if;
  end process storeValues;

  --============================================================================
                                                            -- send bytes to I2C
  busDataOut <= (others => '1');

END ARCHITECTURE RTL;
