ARCHITECTURE RTL OF rxRegisters IS

  signal addressReg: unsigned(address'range);
  signal dataReg: std_ulogic_vector(data'range);

  subtype registerType is std_ulogic_vector(data'range);
  type registerArrayType is array(2**address'length-1 downto 0) of registerType;
  signal registerSet: registerArrayType;

  constant DCMotorPwmRateId       : natural :=  0;
  constant DCMotorSpeedId         : natural :=  1;
  constant stepperMotorPwmRateId  : natural :=  2;
  constant stepperMotorEndSwitchId: natural :=  4;
  constant hardwareControlId      : natural :=  5;
  constant bluetoothConnectedId     : natural :=  5;
  constant serialUpdateRateId     : natural := 15;

  constant registerInit: registerArrayType := (
    DCMotorPwmRateId        => X"0040",
    stepperMotorPwmRateId   => X"0100",
    stepperMotorEndSwitchId => X"0008",
    hardwareControlId       => X"0007",
    serialUpdateRateId      => X"0400", -- 1024
    others => (others => '0')
  );
  signal initCounter: unsigned(address'range);
  signal initDone, initDoneReg: std_ulogic;
                                          -- Bluetooth connection lost detection
  signal btConnectedDelayed, btConnectionChanged: std_ulogic;
  signal orientationBtMask: registerType;
                                                          -- mapping to blockRam
  signal ramEnable: std_ulogic;
  signal ramAddress: unsigned(address'range);
  signal ramDataIn, ramDataOut: registerType;

BEGIN
  ------------------------------------------------------------------------------
                                                   -- count registers at startup
  countRegistersAtInit: process(reset, clock)
  begin
    if reset = '1' then
      initCounter <= (others => '0');
      initDoneReg <= '0';
    elsif rising_edge(clock) then
      if initDone = '0' then
        initCounter <= initCounter + 1;
      end if;
      initDoneReg <= initDone;
    end if;
  end process countRegistersAtInit;

  initDone <= '1' when initCounter+1 = 0
    else '0';

  ------------------------------------------------------------------------------
                                             -- detect Bluetooth connection lost
  delayBtConnected: process(reset, clock)
  begin
    if reset = '1' then
      btConnectedDelayed <= '0';
    elsif rising_edge(clock) then
      btConnectedDelayed <= btConnected;
    end if;
  end process delayBtConnected;

  btConnectionChanged <= '1' when btConnected /= btConnectedDelayed
    else '0';

  orientationBtMask <= (others => '0') when btConnected = '0'
    else std_ulogic_vector(to_unsigned(2**bluetoothConnectedId, ramDataOut'length));

  ------------------------------------------------------------------------------
                                           -- store information from RS232 frame
  storeValues: process(reset, clock)
  begin
    if reset = '1' then
      addressReg <= (others => '0');
      dataReg <= (others => '0');
    elsif rising_edge(clock) then
      if addressEn = '1' then
        addressReg <= resize(unsigned(rxData), addressReg'length);
      end if;
      if dataHEn = '1' then
        dataReg(dataReg'high downto dataReg'high-rxData'length+1) <= rxData;
      end if;
      if dataLEn = '1' then
        dataReg(rxData'range) <= rxData;
      end if;
    end if;
  end process storeValues;

  ------------------------------------------------------------------------------
                                                    -- register set: FPGA fabric
--  updateRegisters: process(reset, clock)
--  begin
--    if reset = '1' then
--      registerSet <= (others => (others => '0'));
--    elsif rising_edge(clock) then
--    if rising_edge(clock) then
--      if initDoneReg = '0' then
--        registerSet(to_integer(initCounter)) <= registerInit(to_integer(initCounter));
--      elsif dataValid = '1' then
--        registerSet(to_integer(addressReg)) <= dataReg;
--      elsif btConnectionChanged = '1' then
--        registerSet(DCMotorSpeedId) <= registerInit(DCMotorSpeedId);
--      end if;
--    end if;
--  end process updateRegisters;
--
--  data <= registerSet(to_integer(address));

  ------------------------------------------------------------------------------
                                                     -- register set: RAM blocks
  ramEnable <= not(initDoneReg) or dataValid;
  ramAddress <=
    initCounter when initDoneReg = '0' else
    addressReg when dataValid = '1';
  ramDataIn <=
    registerInit(to_integer(initCounter)) when initDoneReg = '0' else
    dataReg when dataValid = '1';

  updateRegisters: process(clock)
  begin
    if rising_edge(clock) then
      if ramEnable = '1' then
        registerSet(to_integer(ramAddress)) <= ramDataIn;
      end if;
    end if;
  end process updateRegisters;

  readRegisters: process(reset, clock)
  begin
    if reset = '1' then
      ramDataOut <= (others => '0');
    elsif rising_edge(clock) then
      ramDataOut <= registerSet(to_integer(address));
    end if;
  end process readRegisters;

  data <= ramDataOut or orientationBtMask when address = hardwareControlId
    else ramDataOut;

END ARCHITECTURE RTL;
