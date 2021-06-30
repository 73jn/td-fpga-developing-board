ARCHITECTURE RTL OF stepperMotorRegisters IS

  constant dividerBaseAddr  : natural := baseAddress;
  constant angleBaseAddr    : natural := baseAddress + 2;
  constant stepperEndAddr   : natural := baseAddress + 4;
  constant statusAddr       : natural := baseAddress;
  constant statusEndSwitchId: natural := 0;
  constant statusReachedId  : natural := 1;
  constant hwStepperEndId   : natural := 3;
  constant hwRestartId      : natural := 4;
  constant registerLength   : positive := 2*busDataIn'length;
  signal   divider_int      : unsigned(registerLength-1 downto 0);
  signal   target_int       : unsigned(registerLength-1 downto 0);
  signal   actualReg        : unsigned(registerLength-1 downto 0);
  signal   switchAddress    : unsigned(busAddress'range);
  signal   enDelayed        : std_ulogic;
  signal   stepperEndMaster : std_ulogic;
  signal   stepperEndSlave  : std_ulogic;

BEGIN
  ------------------------------------------------------------------------------
                                                         -- store bytes from I2C
  storeBytes: process(reset, clock)
  begin
    if reset = '1' then
      divider_int <= (others => '0');
      target_int <= (others => '0');
      switchAddress <= to_unsigned(stepperEndAddr, switchAddress'length);
      hwOrientation <= (others => '0');
      stepperEndMaster <= '0';
      restart <= '0';
      stepperEndSlave <= '0';
    elsif rising_edge(clock) then
      if en = '1' then
                                                         -- controls from master
        if writeRegs = '1' then
          case to_integer(busAddress) is
            when dividerBaseAddr =>
              divider_int(busDataIn'range) <= unsigned(busDataIn);
            when dividerBaseAddr+1 =>
              divider_int(
                divider_int'high downto divider_int'length-busDataIn'length
              ) <= unsigned(busDataIn);
            when angleBaseAddr =>
              target_int(busDataIn'range) <= unsigned(busDataIn);
            when angleBaseAddr+1 =>
              target_int(
                target_int'high downto target_int'length-busDataIn'length
              ) <= unsigned(busDataIn);
            when stepperEndAddr =>
              switchAddress <= unsigned(busDataIn(switchAddress'range));
            when orientationBaseAddress =>
              hwOrientation <= busDataIn(hwOrientation'range);
              stepperEndMaster <= busDataIn(hwStepperEndId);
              restart <= busDataIn(hwRestartId);
            when others => null;
          end case;
                                                   -- controls from other slaves
                                                 -- !!! adresses are offset by 1
        else
          if busAddress = switchAddress+1 then
            stepperEndSlave <= not busDataIn(0);
          end if;
        end if;
      end if;
    end if;
  end process storeBytes;

  stepperEndBus <= stepperEndSlave or stepperEndMaster;

  ------------------------------------------------------------------------------
                                                -- update data after second byte
  storeControls: process(reset, clock)
  begin
    if reset = '1' then
      enDelayed <= '0';
      divider <= (others => '0');
      target <= (others => '0');
    elsif rising_edge(clock) then
      enDelayed <= en;
      if enDelayed = '1' then
        if busAddress(0) = '1' then
          divider <= resize(divider_int, divider'length);
          target <= resize(target_int, target'length);
        end if;
      end if;
    end if;
  end process storeControls;

  --============================================================================
                                                        -- store actual position
  storeValues: process(reset, clock)
  begin
    if reset = '1' then
      actualReg <= (others => '0');
    elsif rising_edge(clock) then
      if busAddress = angleBaseAddr-1 then
        actualReg <= resize(actual, actualReg'length);
      end if;
    end if;
  end process storeValues;

  ------------------------------------------------------------------------------
                                                        -- multiplex data to I2C
  sendStatus: process(busAddress, actualReg, stepperEndSwitch, reached)
  begin
    busdataOut <= (others => '1');
    case to_integer(busAddress) is
--when 0 => busdataOut <= X"55";
--when 31 => busdataOut <= std_ulogic_vector(to_unsigned(10, busdataOut'length));
      when angleBaseAddr =>
        busdataOut <= std_ulogic_vector(actualReg(busdataOut'range));
      when angleBaseAddr+1 =>
        busdataOut <= std_ulogic_vector(
          actualReg(actualReg'high downto actualReg'length-busdataOut'length)
        );
      when statusAddr =>
        busdataOut(statusEndSwitchId) <= not(stepperEndSwitch);
        busdataOut(statusReachedId) <= reached;
      when others => null;
    end case;
  end process sendStatus;

END ARCHITECTURE RTL;
