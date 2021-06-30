ARCHITECTURE RTL OF sequenceRam IS

  constant sequenceRegisterLength: positive := command'length + argument'length;
  signal addressReg: unsigned(ramAddressBitNb-1 downto 0);
  signal dataReg: std_ulogic_vector(sequenceRegisterLength-1 downto 0);

  subtype sequenceType is unsigned(sequenceRegisterLength-1 downto 0);
  type sequenceArrayType is array(2**ramAddressBitNb-1 downto 0) of sequenceType;
  signal sequenceSet: sequenceArrayType;

  constant controlRegisterId  : natural := 7;
  constant controlNewSequenceId  : natural := 0;
  constant controlRunId          : natural := 1;
  constant sequenceRegisterId : natural := 8;
  constant commandGoto        : natural := 14;
  signal newSequence, newSequenceDelayed, loadNewSequence: std_ulogic;
  signal run_stop: std_ulogic;
  signal command_int: unsigned(command'range);
  signal argument_int: unsigned(argument'range);
                                          -- Bluetooth connection lost detection
  signal btConnectedDelayed, btConnectionLost: std_ulogic;
                                                          -- mapping to blockRam
  signal ramWriteEnable: std_ulogic;
  signal ramWriteAddress: unsigned(ramAddressBitNb-1 downto 0);
  signal ramWriteData: sequenceType;
  signal ramReadAddress: unsigned(ramAddressBitNb-1 downto 0);

BEGIN
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
                                                             -- control register
  updateControls: process(reset, clock)
  begin
    if reset = '1' then
      newSequence <= '0';
      newSequenceDelayed <= '0';
      run_stop <= '0';
    elsif rising_edge(clock) then
      newSequenceDelayed <= newSequence;
      if (dataValid = '1') and (addressReg = controlRegisterId) then
        newSequence <= dataReg(controlNewSequenceId);
        run_stop <= dataReg(controlRunId);
      end if;
    end if;
  end process updateControls;

  loadNewSequence <= '1' when newSequence = '1' and newSequenceDelayed = '0'
    else '0';
  act <= run_stop when btConnected = '1'
    else '0';
  running <= '0' when command_int+1 = 0
    else run_stop;

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

  btConnectionLost <= '1' when btConnected = '0' and btConnectedDelayed = '1'
    else '0';

  ------------------------------------------------------------------------------
                                                 -- post-increment write address
  updateWriteAddress: process(reset, clock)
  begin
    if reset = '1' then
      ramWriteAddress <= (others => '0');
    elsif rising_edge(clock) then
      if loadNewSequence = '1' then
        ramWriteAddress <= (others => '0');
      elsif ramWriteEnable = '1' then
        ramWriteAddress <= ramWriteAddress + 1;
      end if;
    end if;
  end process updateWriteAddress;
                                                       -- increment read address
  updateReadAddress: process(reset, clock)
  begin
    if reset = '1' then
      ramReadAddress <= (others => '0');
    elsif rising_edge(clock) then
      if loadNewSequence = '1' then
        ramReadAddress <= (others => '0');
      elsif done = '1' then
        if (command_int = commandGoto) and (flagZero = '0') then
          ramReadAddress <= resize(argument_int, ramReadAddress'length);
        else
          ramReadAddress <= ramReadAddress + 1;
        end if;
      end if;
    end if;
  end process updateReadAddress;

  ------------------------------------------------------------------------------
                                                                 -- sequence RAM
  ramWriteEnable <= dataValid when addressReg = sequenceRegisterId
    else '0';
  ramWriteData <= unsigned(dataReg);

  writeToRam: process(clock)
  begin
    if rising_edge(clock) then
      if ramWriteEnable = '1' then
        sequenceSet(to_integer(ramWriteAddress)) <= ramWriteData;
      end if;
    end if;
  end process writeToRam;

  readRegisters: process(reset, clock)
  begin
    if reset = '1' then
      command_int <= (others => '0');
      argument_int <= (others => '0');
    elsif rising_edge(clock) then
      command_int <= sequenceSet(to_integer(ramReadAddress))(sequenceRegisterLength-1 downto sequenceRegisterLength-command'length);
      argument_int <= sequenceSet(to_integer(ramReadAddress))(argument'range);
    end if;
  end process readRegisters;

  command <= command_int;
  argument <= argument_int;

END ARCHITECTURE RTL;
