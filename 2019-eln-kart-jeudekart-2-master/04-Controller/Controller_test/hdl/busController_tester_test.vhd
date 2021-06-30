LIBRARY std;
  USE std.textio.ALL;
library ieee;
  USE ieee.std_logic_textio.ALL;
  use ieee.math_real.all;

ARCHITECTURE test OF busController_tester IS

  constant clockPeriod  : time          := 1.0/clockFrequency * 1 sec;
  signal sClock         : std_uLogic    := '1';
  signal sReset         : std_uLogic ;
                                                               -- signal periods
  constant rs232Frequency: real := rs232Baudrate;
  constant rs232Period: time := (1.0/rs232Frequency) * 1 sec;
  constant i2cPeriod: time := (1.0/i2cBaudrate) * 1 sec;
                                                               -- RS232 controls
  constant controlRegisterId   : natural := 7;
  constant controlNewSequenceId  : natural := 0;
  constant controlRunId          : natural := 1;
  constant sequenceRegisterId  : natural := 8;
  constant linkSpeedRegisterId : natural := 15;
  type commandType is array(1 to 5) of unsigned(7 downto 0);
  signal busAddress : natural;
  signal busData : integer;
  signal busSend: std_uLogic := '0';
  signal busSendDone: std_uLogic := '0';
  signal rs232Command : commandType;
  signal rs232SendCommand: std_uLogic := '0';
  signal rs232SendCommandDone: std_uLogic;
  signal rs232RxByte: unsigned(rs232BitNb-1 downto 0);
  signal rs232SendRxByte: std_uLogic := '0';
  signal rs232TxByte: unsigned(rs232BitNb-1 downto 0);
                                                                 -- I2C controls
  signal sDaIn, sDaOut: std_uLogic;
  signal ackOut: std_uLogic := '0';
  signal i2cStart: std_uLogic := '0';
  signal i2cStop: std_uLogic := '0';
  signal i2cRxByte: unsigned(7 downto 0) := (others => '0');
  signal i2cChipAddress: unsigned(i2cRxByte'range) := (others => '0');
  signal i2cRxAddress: unsigned(i2cRxByte'high-1 downto 0) := (others => '0');
  signal i2cRead1, i2cRead: std_uLogic := '0';
  signal i2cDataValid, i2cChipAddressValid, i2cDataValidShifted: std_uLogic := '0';
  signal i2cTxByte: unsigned(i2cRxByte'range) := (others => '0');
  signal i2cAck: std_uLogic := '0';
                                                                    -- registers
  constant registerAddressBitNb: positive := 4;
  constant registerByteOffsetBitNb: positive := 1;
  subtype dataRegisterType is unsigned(2**registerByteOffsetBitNb*i2cRxByte'length-1 downto 0);
  type dataRegisterArrayType is array(2**registerAddressBitNb-1 downto 0) of dataRegisterType;
  signal registersIn: dataRegisterArrayType;
  signal registersOut: dataRegisterArrayType;
                                                                     -- sequence
  constant commandNoOperation: natural := 0;
  constant commandSetSpeed: natural := 1;
  constant commandSetAngle: natural := 2;
  constant commandSetLEDs: natural := 3;
  constant commandRunFor: natural := 5;
  constant commandEnd: natural := 15;
  type sequenceType is array(2**sequenceAddressBitNb-1 downto 0) of natural;
  constant sequence: sequenceType := (
    0  => 2**sequenceArgumentBitNb * commandSetSpeed + 10,
    1  => 2**sequenceArgumentBitNb * commandSetAngle + 200,
    2  => 2**sequenceArgumentBitNb * commandRunFor + 300,
    3  => 2**sequenceArgumentBitNb * commandSetSpeed + 2**sequenceArgumentBitNb - 5,
    4  => 2**sequenceArgumentBitNb * commandSetAngle + 0,
    5  => 2**sequenceArgumentBitNb * commandSetLEDs + 3,
    6  => 2**sequenceArgumentBitNb * commandRunFor + 200,
    7  => 2**sequenceArgumentBitNb * commandSetSpeed + 0,
    8  => 2**sequenceArgumentBitNb * commandSetAngle + 100,
    9  => 2**sequenceArgumentBitNb * commandSetLEDs + 0,
    10 => 2**sequenceArgumentBitNb * commandEnd,
    others => 2**sequenceArgumentBitNb * commandNoOperation
  );
                                                       -- power supply board ADC
  signal sampleFrequency : real := 100.3E3;
  signal signalFrequency : real := sampleFrequency / 9.0;
  signal tEn: std_ulogic := '0';
  signal tReal: real := 0.0;
  signal signalAmplitude : real := 2.0**(adcBitNb-1) - 1.0;
  signal signalReal: real := 0.0;

BEGIN
  ------------------------------------------------------------------------------
                                                              -- reset and clock
  sReset <= '1', '0' after 4*clockPeriod;
  reset <= sReset;

  sClock <= not sClock after clockPeriod/2;
  clock <= transport sClock after 0.9*clockPeriod;

  ------------------------------------------------------------------------------
                                                                -- test sequence
  testSequence: process
  begin
    wait for 5 us;
    write(output,
      lf & lf & lf &
      "----------------------------------------------------------------" & lf &
      "-- Starting testbench" & lf &
      "--" &
      lf & lf
    );

    ----------------------------------------------------------------------------
    -- Write registers
    ----------------------------------------------------------------------------
    wait for 5 us;
    write(output,
      "At time " & integer'image(now/1 us) & " us, " &
      "writing register set" &
      lf & lf
    );
                                              -- write all registers except last
    for index in 0 to linkSpeedRegisterId-1 loop
      wait for 2*rs232Period;
      busAddress <= index;
      busData <= 16#0102# * index;
      busSend <= '1', '0' after 1 ns;
      wait until rising_edge(busSendDone);
    end loop;
                                                   -- write RS232 timer register
    wait for 2*rs232Period;
    write(output,
      "At time " & integer'image(now/1 us) & " us, " &
      "writing timer register" &
      lf & lf
    );
    busAddress <= linkSpeedRegisterId;
    busData <= 4;
    busSend <= '1', '0' after 1 ns;
    wait until rising_edge(busSendDone);

    ----------------------------------------------------------------------------
    -- Test sequence
    ----------------------------------------------------------------------------
                                                           -- write new sequence
    wait for 10*rs232Period;
    write(output,
      "At time " & integer'image(now/1 us) & " us, " &
      "preparing sequence" &
      lf & lf
    );
    busAddress <= controlRegisterId;
    busData <= 2**controlNewSequenceId;
    busSend <= '1', '0' after 1 ns;
    wait until rising_edge(busSendDone);
                                                               -- write sequence
    wait for 10*rs232Period;
    write(output,
      "At time " & integer'image(now/1 us) & " us, " &
      "writing sequence RAM" &
      lf & lf
    );
    for index in sequence'reverse_range loop
      wait for 2*rs232Period;
      busAddress <= sequenceRegisterId;
      busData <= sequence(index);
      busSend <= '1', '0' after 1 ns;
      wait until rising_edge(busSendDone);
    end loop;
                                                                 -- run sequence
    wait for 10*rs232Period;
    write(output,
      "At time " & integer'image(now/1 us) & " us, " &
      "starting sequence" &
      lf & lf
    );
    busAddress <= controlRegisterId;
    busData <= 2**controlRunId;
    busSend <= '1', '0' after 1 ns;
    wait until rising_edge(busSendDone);
                                                                -- stop sequence
    wait for 6 ms;
    write(output,
      "At time " & integer'image(now/1 us) & " us, " &
      "stopping sequence" &
      lf & lf
    );
    busAddress <= controlRegisterId;
    busData <= 0;
    busSend <= '1', '0' after 1 ns;
    wait until rising_edge(busSendDone);

    ----------------------------------------------------------------------------
    -- End of simulation
    ----------------------------------------------------------------------------
    wait for 21 ms - now;
    write(output,
      "--" & lf &
      "-- End of simulation" & lf &
      "----------------------------------------------------------------" & lf &
      lf & lf & lf
    );
    assert false
      severity failure;

  end process testSequence;


  --============================================================================
  -- RS232 I/O functions
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
                                                                 -- send command
  sendCommand: process
    variable dataUnsigned: natural;
  begin
    busSendDone <= '1';
    rs232Command(1) <= to_unsigned(16#55#, rs232Command(1)'length);
    rs232Command(5) <= to_unsigned(16#AA#, rs232Command(5)'length);

    wait until rising_edge(busSend);
    busSendDone <= '0';
    dataUnsigned := to_integer(
      unsigned(
        to_signed(busData, 2*rs232BitNb)
      )
    );

    rs232Command(2) <= to_unsigned(busAddress, rs232Command(2)'length);
    rs232Command(3) <= to_unsigned(dataUnsigned / 2**8, rs232Command(3)'length);
    rs232Command(4) <= to_unsigned(dataUnsigned mod 2**8, rs232Command(4)'length);
    wait for 1 ns;
    rs232SendCommand <= '1', '0' after 1 ns;
    
    wait until rising_edge(rs232SendCommandDone);

  end process sendCommand;

  ------------------------------------------------------------------------------
                                                            -- RS232 send serial
  rxSendString: process
    constant rs232BytePeriod : time := 15*rs232Period;
    variable stringRight: natural;
  begin

    rs232SendCommandDone <= '1';

    wait until rising_edge(rs232SendCommand);
    rs232SendCommandDone <= '0';

    for index in rs232Command'range loop
      rs232RxByte <= rs232Command(index);
      rs232SendRxByte <= '1', '0' after 1 ns;
      wait for rs232BytePeriod;
    end loop;

  end process rxSendString;

  rsSendByte: process
    variable rxData: unsigned(rs232BitNb-1 downto 0);
  begin
    bt_TxD <= '1';

    wait until rising_edge(rs232SendRxByte);
    rxData := rs232RxByte;

    bt_TxD <= '0';
    wait for rs232Period;

    for index in rxData'reverse_range loop
      bt_TxD <= rxData(index);
      wait for rs232Period;
    end loop;

  end process rsSendByte;

  uart_TxD <= '1';

  ------------------------------------------------------------------------------
                                                           -- RS232 receive byte
  rsReceiveByte: process
    variable txData: unsigned(rs232BitNb-1 downto 0);
  begin
    wait until falling_edge(bt_rxd);

    wait for 1.5 * rs232Period;

    for index in txData'reverse_range loop
      txData(index) := bt_rxd;
      wait for rs232Period;
    end loop;

    rs232TxByte <= txData;

  end process rsReceiveByte;


  --============================================================================
  -- I2C I/O functions
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
                                                             -- sDa binary value
  sDaIn <= To_X01(sDa);

  ------------------------------------------------------------------------------
                                                                 -- send command
  detectStartStop: process(sDaIn, sCl)
  begin
    if falling_edge(sCl) then
      i2cStart <= '0';
      i2cStop <= '0';
    elsif sCl /= '0' then
      if falling_edge(sDaIn) then
        i2cStart <= '1';
        i2cStop <= '0';
      elsif rising_edge(sDaIn) then
        i2cStop <= '1';
        i2cStart <= '0';
      end if;
    end if;
  end process detectStartStop;

  ------------------------------------------------------------------------------
                                                             -- I2C receive byte
  i2cReceiveByte: process
    variable rxByte: unsigned(i2cRxByte'range);
    variable bitCounter: natural;
    variable firstByte, secondByte: boolean := false;
  begin
    wait on i2cStart, sCl;
    if i2cStart = '1' then
      bitCounter := 0;
      firstByte := true;
      i2cRead1 <= '0';
    elsif rising_edge(sCl) then
      rxByte := shift_left(rxByte, 1);
      rxByte(0) := sDaIn;
      if bitCounter <= rxByte'length then
        bitCounter := bitCounter + 1;
      else
        bitCounter := 1;
      end if;
      if bitCounter = rxByte'length then
        i2cRead <= i2cRead1;
        i2cRxByte <= rxByte;
        if firstByte then
          i2cChipAddress <= resize(shift_right(rxByte, 1), i2cChipAddress'length);
          i2cChipAddressValid <= '1' after 1 ns, '0' after 2 ns;
          i2cRead1 <= rxByte(0);
          firstByte := false;
          secondByte := true;
        elsif secondByte and (i2cRead1 = '0') then
          i2cRxAddress <= resize(rxByte, i2cRxAddress'length) - 1;
          secondByte := false;
        else
          i2cRxAddress <= i2cRxAddress + 1;
          i2cDataValid <= '1' after 1 ns, '0' after 2 ns;
          secondByte := false;
        end if;
      end if;
      if bitCounter = rxByte'length+1 then
        i2cAck <= sDaIn;
        if sDaIn /= '0' then
          i2cRead1 <= '0';
          i2cRead <= '0';
        end if;
      end if;
    elsif falling_edge(sCl) then
      ackOut <= '0';
      if bitCounter = rxByte'length then
        if (i2cRead = '0') and (i2cChipAddress = kartBaseAddress/2) then
          ackOut <= '1';
        end if;
      end if;
    end if;
  end process i2cReceiveByte;

  shiftDataValid: process
  begin
    i2cDataValidShifted <= '0';
    wait until rising_edge(i2cDataValid) or rising_edge(i2cChipAddressValid);
    wait until rising_edge(sCl);
    wait for 1 ns;
    i2cDataValidShifted <= '1';
    wait for 1 ns;
  end process shiftDataValid;


  ------------------------------------------------------------------------------
                                                            -- I2C register sets
  i2cUpdateWriteRegisters: process(i2cDataValid)
    variable byteOffset: natural;
    variable registerAddress: natural;
  begin
    if rising_edge(i2cDataValid) then
      if not(i2cRead) = '1' then
        byteOffset := i2cRxByte'length
          * to_integer(i2cRxAddress(registerByteOffsetBitNb-1 downto 0));
        registerAddress := to_integer(i2cRxAddress)/2**registerByteOffsetBitNb;
        if registerAddress <= registersIn'high then
          registersIn
            (registerAddress)
            (byteOffset+i2cRxByte'high downto byteOffset)
              <= i2cRxByte;
        end if;
      end if;
    end if;
  end process i2cUpdateWriteRegisters;

  i2cUpdateReadRegisters: process
  begin
    for index in registersOut'range loop
      registersOut(index) <= to_unsigned(
        index*(1 + 2**(registerByteOffsetBitNb*i2cRxByte'length+1)),
        registersOut(index)'length
      );
    end loop;
    wait;
  end process i2cUpdateReadRegisters;

  ------------------------------------------------------------------------------
                                                                -- I2C send byte
  i2cSelectWriteData: process(i2cRxAddress)
    variable i2cAddress: natural;
    variable registerAddress: natural;
    variable byteOffset: natural;
  begin
    i2cAddress := to_integer(i2cRxAddress+1);
    registerAddress := i2cAddress/2**registerByteOffsetBitNb;
    if registerAddress <= registersOut'high then
      byteOffset := i2cTxByte'length
        * (i2cAddress mod 2**registerByteOffsetBitNb);
      i2cTxByte <= registersOut
        (registerAddress)
        (byteOffset+i2cTxByte'high downto byteOffset);
    end if;
  end process i2cSelectWriteData;

  i2cSendByte: process
    variable rxByte: unsigned(i2cRxByte'high downto 0);
    variable bitCounter: integer;
  begin
    sDaOut <= '1';
    wait until rising_edge(i2cDataValidShifted);
    if i2cRead1 = '1' then
      for index in 1 to 1 loop
        wait until falling_edge(sCl);
      end loop;
      wait for i2cPeriod;
      bitCounter := 7;
      while bitCounter >= 0 loop
        sDaOut <= i2cTxByte(bitCounter) after i2cPeriod;
        wait until falling_edge(sCl);
        bitCounter := bitCounter - 1;
      end loop;
      wait for i2cPeriod;
    end if;
  end process i2cSendByte;

  sDa <= '0' when (i2cRead1 = '1') and (sDaOut = '0')
    else '0' when ackOut = '1'
    else 'Z';

  --============================================================================
                                                              -- battery voltage
  tEn <= not tEn after 1.0/(sampleFrequency*2.0) * 1 sec;

  process(tEn)
  begin
    if rising_edge(tEn) then
      tReal <= tReal + 1.0/sampleFrequency;
    end if;
  end process;

  signalReal <= signalAmplitude * sin(2.0*math_pi*signalFrequency*tReal);
  VINp <= integer(signalReal) when signalReal > 0.0
    else 0;
  VINm <= -integer(signalReal) when signalReal < 0.0
    else 0;

END ARCHITECTURE test;
