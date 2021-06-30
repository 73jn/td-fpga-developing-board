ARCHITECTURE RTL OF i2cController IS

  constant sequenceIdBitNb: positive := 3;
  signal sequenceCounter: unsigned(regRxAddr'high+sequenceIdBitNb+1 downto 0);
  signal sequenceId: unsigned(sequenceIdBitNb-1 downto 0);
  signal sequenceAddress: unsigned(regRxAddr'high+1 downto 0);

  signal txStart_stop   : std_ulogic;
  signal txDataByte     : unsigned(txData'high-2 downto 0);
  signal txAck          : std_ulogic;
  signal regRxAddrChanging  : std_ulogic;

  signal rxNewData      : std_ulogic;
  signal rxStart, rxStop: std_ulogic;
  signal rxDataByte     : unsigned(rxData'high-2 downto 0);
  signal rxAck          : std_ulogic;

  constant adcConfiguration : unsigned(txDataByte'range) := '1' & "00" & '1' & "10" & "00";
  constant adcRegAddress: natural := 5;
  signal adcValue       : unsigned(2*rxDataByte'length-1 downto 0);
  signal updateAdcValue : std_ulogic;

  type   rxStateType    is (idle, readChipAddress, readRegAddress, incAddress);
  signal rxState        : rxStateType;
  signal txAddress      : unsigned(regTxAddr'high+2 downto 0);
  signal txDataReg      : unsigned(rxDataByte'range);

BEGIN
  ------------------------------------------------------------------------------
                                                -- count I2C write/read sequence
  sequenceId <= sequenceCounter(
    sequenceCounter'high downto
    sequenceCounter'high-sequenceId'length+1
  );
  sequenceAddress <= sequenceCounter(regRxAddr'high+1 downto 0);

  countSequence: process(reset, clock)
  begin
    if reset = '1' then
      sequenceCounter <= (others => '0');
      regRxAddrChanging <= '0';
    elsif rising_edge(clock) then
      regRxAddrChanging <= '0';
      if (txFull = '0') and (regRxAddrChanging = '0') then
        if sequenceCounter = 0 then
          if startI2c = '1' then
            sequenceCounter <= sequenceCounter + 1;
          end if;
        else
          if (sequenceId = 0) and (sequenceAddress = 3) then
            sequenceCounter <= to_unsigned(
              2**(regRxAddr'length+1),
              sequenceCounter'length
            );
          elsif (sequenceId = 2) and (sequenceAddress = 5) then
            sequenceCounter <= to_unsigned(
              3*2**(regRxAddr'length+1),
              sequenceCounter'length
            );
          elsif (sequenceId = 4) and (sequenceAddress = 9) then
            sequenceCounter <= (others => '0');
          else
            sequenceCounter <= sequenceCounter + 1;
            if sequenceId = 1 then
              regRxAddrChanging <= '1';
            end if;
          end if;
        end if;
      end if;
    end if;
  end process countSequence;

  ------------------------------------------------------------------------------
                                              -- control I2C write/read sequence
  regRxAddr <= (others => '0') when sequenceId /= 1
    else resize(shift_right(sequenceAddress, 1), regRxAddr'length);

  sendI2c: process(sequenceAddress, sequenceId, regRxData)
  begin
                                                               -- default values
    txStart_stop <= '0';
    txDataByte <= (others => '0');
    txAck <= '1';
                                                  -- beginning of write sequence
    if sequenceId = 0 then
      case to_integer(sequenceAddress) is
        when 1 =>                                                       -- start
          txStart_stop <= '1';
        when 2 =>                                    -- chip address, write mode
          txDataByte <= to_unsigned(kartBaseAddress, txDataByte'length);
        when 3 =>                                            -- register address
          txDataByte <= (others => '0');
        when others => null;
      end case;
                                                               -- write sequence
    elsif sequenceId = 1 then
      if sequenceAddress(0) = '0' then
        txDataByte <= resize(unsigned(regRxData), txDataByte'length);
      else
        txDataByte <= resize(
          shift_right(unsigned(regRxData), txDataByte'length),
          txDataByte'length
        );
      end if;
      txAck <= '1';
                                                  -- transition to read sequence
    elsif sequenceId = 2 then
      case to_integer(sequenceAddress) is
        when 0 =>                                                        -- stop
          txStart_stop <= '1';
          txDataByte <= (others => '1');
        when 1 =>                                                       -- start
          txStart_stop <= '1';
        when 2 =>                                    -- chip address, write mode
          txDataByte <= to_unsigned(kartBaseAddress, txDataByte'length);
        when 3 =>                                            -- register address
          txDataByte <= (others => '0');
        when 4 =>                                                       -- start
          txStart_stop <= '1';
        when 5 =>                                     -- chip address, read mode
          txDataByte <= to_unsigned(kartBaseAddress+1, txDataByte'length);
        when others => null;
      end case;
                                                                -- read sequence
    elsif sequenceId = 3 then
      txDataByte <= (others => '1');
      if sequenceAddress+1 = 0 then
        txAck <= '1';
      else
        txAck <= '0';
      end if;
                                                    -- end of sequence, read ADC
    elsif sequenceId = 4 then
      case to_integer(sequenceAddress) is
        when 0 =>                                                        -- stop
          txStart_stop <= '1';
          txDataByte <= (others => '1');
        when 1 =>                                                       -- start
          txStart_stop <= '1';
        when 2 =>                                     -- chip address, read mode
          txDataByte <= to_unsigned(adcAddress+1, txDataByte'length);
        when 3 =>                                                   -- read MSBs
          txAck <= '0';
          txDataByte <= (others => '1');
        when 4 =>                                                   -- read LSBs
          txDataByte <= (others => '1');
        when 5 =>                                                        -- stop
          txStart_stop <= '1';
          txDataByte <= (others => '1');
        when 6 =>                                                       -- start
          txStart_stop <= '1';
        when 7 =>                                    -- chip address, write mode
          txDataByte <= to_unsigned(adcAddress, txDataByte'length);
        when 8 =>                                -- write configuration register
          txDataByte <= adcConfiguration;
        when 9 =>                                                        -- stop
          txStart_stop <= '1';
          txDataByte <= (others => '1');
        when others => null;
      end case;
    end if;

  end process sendI2c;

  txData <= txStart_stop & txAck & std_ulogic_vector(txDataByte);
  txWr <= '0' when sequenceCounter = 0
    else '1' when (txFull = '0') and (regRxAddrChanging = '0')
    else '0';

  ------------------------------------------------------------------------------
                                                                    -- ADC value
  storeAdcValue: process(reset, clock)
  begin
    if reset = '1' then
      adcValue <= (others => '0');
    elsif rising_edge(clock) then
      if rxNewData = '1' then
        adcValue <= shift_left(adcValue, adcValue'length/2);
        adcValue(adcValue'length/2-1 downto 0) <= resize(unsigned(rxData), adcValue'length/2);
      end if;
    end if;
  end process storeAdcValue;

  updateAdcValue <= '0' when txAddress < 16#20#
    else '1';

  ------------------------------------------------------------------------------
                                                          -- readbAck I2C values
  rxRd <= not rxEmpty;

  readDataFromI2c: process(reset, clock)
  begin
    if reset = '1' then
      rxStart <= '0';
      rxStop <= '0';
      rxDataByte <= (others => '0');
      rxAck <= '0';
      rxNewData <= '0';
    elsif rising_edge(clock) then
      rxNewData <= '0';
      if rxEmpty = '0' then
        rxStart <= rxData(rxData'high) and not rxData(0);
        rxStop <= rxData(rxData'high) and rxData(0);
        rxDataByte <= resize(unsigned(rxData), rxDataByte'length);
        rxAck <= rxData(rxDataByte'high+1);
        rxNewData <= '1';
      end if;
    end if;
  end process readDataFromI2c;

  rxFsm: process(reset, clock)
  begin
    if reset = '1' then
      rxState <= idle;
    elsif rising_edge(clock) then
      if rxNewData = '1' then
        case rxState is
          when idle =>
            if rxStart = '1' then
              rxState <= readChipAddress;
            end if;
          when readChipAddress =>
            if rxDataByte(0) = '1' then  -- read mode
              rxState <= incAddress;
            else
              rxState <= readRegAddress;
            end if;
          when readRegAddress =>
            rxState <= idle;
          when incAddress =>
            if rxStop = '1' then
              rxState <= idle;
            end if;
        end case;
      end if;
    end if;
  end process rxFsm;

  updateAddress: process(reset, clock)
  begin
    if reset = '1' then
      txAddress <= (others => '0');
    elsif rising_edge(clock) then
      if rxNewData = '1' then
        case rxState is
          when readRegAddress =>
            txAddress <= resize(rxDataByte, txAddress'length);
          when incAddress =>
            txAddress <= txAddress + 1;
          when others => null;
        end case;
      end if;
    end if;
  end process updateAddress;

  regTxAddr <= resize(shift_right(txAddress, 1), regTxAddr'length) when updateAdcValue = '0'
    else to_unsigned(adcRegAddress, regTxAddr'length);
  updateTxReg <= rxNewData when
      (updateAdcValue = '0') and
      (rxState = incAddress) and
      (txAddress(0) = '1') and
      (shift_right(txAddress, 1) /= adcRegAddress)
    else rxNewData when txAddress = 16#23#
    else '0';

  storedataByte: process(reset, clock)
  begin
    if reset = '1' then
      txDataReg <= (others => '0');
    elsif rising_edge(clock) then
      if rxNewData = '1' then
        txDataReg <= rxDataByte;
--regTxData <= std_ulogic_vector(rxDataByte & txDataReg);
      end if;
    end if;
  end process storedataByte;

  regTxData <= std_ulogic_vector(rxDataByte & txDataReg) when updateAdcValue = '0'
    else std_ulogic_vector(adcValue);

  ------------------------------------------------------------------------------
                                                                     -- test out
  process(sequenceId)
  begin
    testOut <= (others => '0');
    testOut(sequenceId'range) <= std_ulogic_vector(sequenceId);
  end process;

END ARCHITECTURE RTL;
