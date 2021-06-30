LIBRARY std;
  USE std.textio.ALL;
LIBRARY ieee;
  USE ieee.std_logic_textio.ALL;
  use ieee.math_real.all;

ARCHITECTURE test OF kartControl_tester IS
                                                              -- clock and reset
  constant clockPeriod  : time          := 1.0/clockFrequency * 1 sec;
  signal sClock         : std_uLogic    := '1';
  signal sReset         : std_uLogic ;
                                                               -- signal periods
  constant rs232Frequency: real := rs232Baudrate;
  constant rs232Period: time := (1.0/rs232Frequency) * 1 sec;
  constant i2cUpdatePeriod: time := (1.0/i2cUpdateRate) * 1 sec;
  constant testItemPeriod: time := 1 ms;
  signal testItemCount: natural := 0;
  signal testItemComment: string(1 to 16) := (others => ' ');
                                                               -- RS232 controls
  constant dcPeriodRegisterId        : natural := 0;
  constant dcSpeedRegisterId         : natural := 1;
  constant stepperPeriodRegisterId   : natural := 2;
  constant stepperTargetRegisterId   : natural := 3;
  constant hardwareControlRegisterId : natural := 5;
  constant sequenceControlRegisterId : natural := 7;
  constant controlNewSequenceId        : natural := 0;
  constant controlRunId                : natural := 1;
  constant sequenceRegisterId        : natural := 8;
  constant linkSpeedRegisterId       : natural := 15;
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
  signal rs232ReceivedTxByte: std_uLogic := '0';
                                                                     -- sequence
  constant commandNoOperation : natural := 0;
  constant commandSetSpeed    : natural := 1;
  constant commandSetAngle    : natural := 2;
  constant commandDriveLEDs   : natural := 3;
  constant commandSetLEDs     : natural := 4;
  constant commandClearLEDs   : natural := 5;
  constant commandBlinkLEDs   : natural := 6;
  constant commandRunDistance : natural := 8;
  constant commandRunFor      : natural := 9;
  constant commandRegisterOp  : natural := 13;
  constant   registerOpSet    : natural := 0;
  constant   registerOpAdd    : natural := 2;
  constant   registerOpSub    : natural := 3;
  constant commandGoto        : natural := 14;
  constant commandEnd         : natural := 15;
  constant operandBitNb : positive := sequenceArgumentBitNb - 2;
  type sequenceType is array(2**sequenceAddressBitNb-1 downto 0) of natural;
  constant sequence: sequenceType := (
    0  => 2**sequenceArgumentBitNb*commandRegisterOp  + 2**operandBitNb*registerOpSet + 3,
    1  => 2**sequenceArgumentBitNb*commandDriveLEDs   + 3,
    2  => 2**sequenceArgumentBitNb*commandSetAngle    + 200,
    3  => 2**sequenceArgumentBitNb*commandSetSpeed    + 10,
    4  => 2**sequenceArgumentBitNb*commandRunFor      + 100,
    5  => 2**sequenceArgumentBitNb*commandNoOperation,
    6  => 2**sequenceArgumentBitNb*commandSetLEDs     + 6,
    7  => 2**sequenceArgumentBitNb*commandSetAngle    + 50,
    8  => 2**sequenceArgumentBitNb*commandSetSpeed    + 2**sequenceArgumentBitNb - 5,
    9  => 2**sequenceArgumentBitNb*commandRunDistance + 100,
    10 => 2**sequenceArgumentBitNb*commandRegisterOp  + 2**operandBitNb*registerOpSub + 1,
    11 => 2**sequenceArgumentBitNb*commandGoto        + 1,
    12 => 2**sequenceArgumentBitNb*commandClearLEDs   + 2,
    13 => 2**sequenceArgumentBitNb*commandSetAngle    + 100,
    14 => 2**sequenceArgumentBitNb*commandSetSpeed    + 0,
    15 => 2**sequenceArgumentBitNb*commandEnd,
    others => 2**sequenceArgumentBitNb * commandNoOperation
  );
                                                              -- PWM to distance
  constant pwmLowpassShift: positive := 12;
  signal pwmLowpassAccumulator, motorSpeed: real := 0.0;
  signal kartDistance: real := 0.0;
  signal kartHallPulseCount: integer := 0;
                                                                 -- RS232 status
  constant batteryVoltageRegisterId : natural := 5;
  type receiverStateType is (
    waitStart,
    readAddress, readDataHigh, readDataLow,
    checkEnd
  );
  signal receiverState: receiverStateType := waitStart;
  signal receivedAddress: natural;
  signal receivedData: integer;
  signal batteryVoltage: integer := 0;
                                                       -- power supply board ADC
  signal sampleFrequency : real := 100.3E3;
  signal signalFrequency : real := sampleFrequency / 9.0;
  signal tEn: std_ulogic := '0';
  signal tReal: real := 0.0;
  constant batteryVoltageOffet : real := 2.0**(powerBoardAdcBitNb-2);
  signal batteryVoltageAmplitude : real := 2.0**(powerBoardAdcBitNb/4);
  signal batteryVoltageReal: real := 0.0;

BEGIN
  --============================================================================
  -- Test sequence
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
    stepperTestMode <= '0';
    stepperEnd <= '0';
    bt_connected <= '0';
    busSend <= '0';
    wait for 5 us;
    bt_connected <= '1';
    write(output,
      lf & lf & lf &
      "----------------------------------------------------------------" & lf &
      "-- Starting testbench" & lf &
      "--" &
      lf & lf
    );

    ----------------------------------------------------------------------------
    -- Initialization
    ----------------------------------------------------------------------------
    testItemComment <= "init            ";
    testItemCount <= testItemCount + 1; wait for 0 ns;
    write(output,
      "At time " & integer'image(now/1 us) & " us, " &
      "Sending setup values" &
      lf & lf
    );
                                                   -- write DC motor PWM divider
    busAddress <= dcPeriodRegisterId;
    busData    <= 50;
    busSend <= '1', '0' after 1 ns;
    wait until rising_edge(busSendDone);
                                              -- write stepper motor PWM divider
    busAddress <= stepperPeriodRegisterId;
    busData    <= 8;
    busSend <= '1', '0' after 1 ns;
    wait until rising_edge(busSendDone);
                                                   -- write RS232 timer register
    busAddress <= linkSpeedRegisterId;
    busData <= 4;
    busSend <= '1', '0' after 1 ns;
    wait for testItemCount * testItemPeriod - now;
                                       -- write hardware orientation and restart
    testItemComment <= "restart         ";
    testItemCount <= testItemCount + 1; wait for 0 ns;
    busAddress <= hardwareControlRegisterId;
    busData    <= 2#010111#;
    busSend <= '1', '0' after 1 ns;
    wait for testItemCount * testItemPeriod - now;
                                                              -- act stepper end
    testItemCount <= testItemCount + 1; wait for 0 ns;
    stepperEnd <= '1';
                                                            -- clear restart bit
    busAddress <= hardwareControlRegisterId;
    busData    <= 2#000111#;
    busSend <= '1', '0' after 1 ns;
    wait for testItemCount * testItemPeriod - now;

    ----------------------------------------------------------------------------
    -- DC motor test: forwards, backwards and stop
    ----------------------------------------------------------------------------
    testItemComment <= "speed           ";
    testItemCount <= testItemCount + 1; wait for 0 ns;
    write(output,
      "At time " & integer'image(now/1 us) & " us, " &
      "testing DC motor" &
      lf & lf
    );
                                                                  -- write speed
    busAddress <= dcSpeedRegisterId;
    busData    <= 10;
    busSend <= '1', '0' after 1 ns;
    wait for testItemCount * testItemPeriod - now;
                                                         -- write negative speed
    testItemCount <= testItemCount + 1; wait for 0 ns;
    busAddress <= dcSpeedRegisterId;
    busData    <= -5;
    busSend <= '1', '0' after 1 ns;
    wait for testItemCount * testItemPeriod - now;
                                                             -- write zero speed
    testItemCount <= testItemCount + 1; wait for 0 ns;
    busAddress <= dcSpeedRegisterId;
    busData    <= 0;
    busSend <= '1', '0' after 1 ns;
    wait until rising_edge(busSendDone);
    wait for testItemCount * testItemPeriod - now;

    ----------------------------------------------------------------------------
    -- Stepper motor test
    ----------------------------------------------------------------------------
    testItemComment <= "angle           ";
    testItemCount <= testItemCount + 1; wait for 0 ns;
    write(output,
      "At time " & integer'image(now/1 us) & " us, " &
      "testing stepper motor" &
      lf & lf
    );
                                                            -- write large angle
    busAddress <= stepperTargetRegisterId;
    busData    <= 200;
    busSend <= '1', '0' after 1 ns;
    wait for testItemCount * testItemPeriod - now;
                                                           -- remove stepper end
    testItemCount <= testItemCount + 1; wait for 0 ns;
    stepperEnd <= '0';
    wait for testItemCount * testItemPeriod - now;
                                                          -- write smaller angle
    busAddress <= stepperTargetRegisterId;
    busData    <= 100;
    busSend <= '1', '0' after 1 ns;
    testItemCount <= testItemCount + 1; wait for 0 ns;
    wait for testItemCount * testItemPeriod - now;

    ----------------------------------------------------------------------------
    -- Drive sequence
    ----------------------------------------------------------------------------
                                                        -- announce new sequence
    testItemComment <= "sequence clear  ";
    testItemCount <= testItemCount + 1; wait for 0 ns;
    write(output,
      "At time " & integer'image(now/1 us) & " us, " &
      "preparing sequence" &
      lf & lf
    );
    busAddress <= sequenceControlRegisterId;
    busData <= 2**controlNewSequenceId;
    busSend <= '1', '0' after 1 ns;
    wait for testItemCount * testItemPeriod - now;
                                                               -- write sequence
    testItemComment <= "sequence send   ";
    testItemCount <= testItemCount + 9; wait for 0 ns;
    write(output,
      "At time " & integer'image(now/1 us) & " us, " &
      "writing sequence to RAM" &
      lf & lf
    );
    for index in sequence'reverse_range loop
      wait for 2*rs232Period;
      busAddress <= sequenceRegisterId;
      busData <= sequence(index);
      busSend <= '1', '0' after 1 ns;
      wait until rising_edge(busSendDone);
    end loop;
    wait for testItemCount * testItemPeriod - now;
                                                                 -- run sequence
    testItemComment <= "sequence start  ";
    testItemCount <= testItemCount + 9; wait for 0 ns;
    write(output,
      "At time " & integer'image(now/1 us) & " us, " &
      "starting sequence" &
      lf & lf
    );
    busAddress <= sequenceControlRegisterId;
    busData <= 2**controlRunId;
    busSend <= '1', '0' after 1 ns;
    wait until rising_edge(busSendDone);
    wait for testItemCount * testItemPeriod - now;
                                                                -- stop sequence
    testItemComment <= "sequence end    ";
    testItemCount <= testItemCount + 1; wait for 0 ns;
    write(output,
      "At time " & integer'image(now/1 us) & " us, " &
      "stopping sequence" &
      lf & lf
    );
    busAddress <= sequenceControlRegisterId;
    busData <= 0;
    busSend <= '1', '0' after 1 ns;
    wait for testItemCount * testItemPeriod - now;

    ----------------------------------------------------------------------------
    -- BT connected test: DC forwards, BT off and on again
    ----------------------------------------------------------------------------
    write(output,
      "At time " & integer'image(now/1 us) & " us, " &
      "testing BT disconnection" &
      lf & lf
    );
                                                                  -- write speed
    busAddress <= dcSpeedRegisterId;
    busData    <= 10;
    busSend <= '1', '0' after 1 ns;
    testItemComment <= "BT connection   ";
    testItemCount <= testItemCount + 2; wait for 0 ns;
    wait for testItemCount * testItemPeriod - now;
                                                                -- disconnect BT
    bt_connected <= '0';
    testItemCount <= testItemCount + 2; wait for 0 ns;
    wait for testItemCount * testItemPeriod - now;
                                                                 -- reconnect BT
    bt_connected <= '1';
    testItemCount <= testItemCount + 1; wait for 0 ns;
    wait for testItemCount * testItemPeriod - now;

    ----------------------------------------------------------------------------
    -- End of simulation
    ----------------------------------------------------------------------------
    testItemComment <= "end             ";
    testItemCount <= testItemCount + 1; wait for 0 ns;
    wait for testItemCount * testItemPeriod - now;
    write(output,
      "--" & lf &
      "-- End of simulation" & lf &
      "----------------------------------------------------------------" & lf &
      lf & lf & lf
    );
    wait for 1 ns;
    assert false
      severity failure;

    wait;
  end process testSequence;

  --============================================================================
  -- RS232 I/O functions
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
    rs232ReceivedTxByte <= '0';
    wait until falling_edge(bt_rxd);

    wait for 1.5 * rs232Period;

    for index in txData'reverse_range loop
      txData(index) := bt_rxd;
      wait for rs232Period;
    end loop;

    rs232TxByte <= txData;
    wait for 0 ns;
    rs232ReceivedTxByte <= '1';
    wait for 1 ns;

  end process rsReceiveByte;

  --============================================================================
  -- Propulsion
  ------------------------------------------------------------------------------
                                                                  -- PWM lowpass
  lowpassIntegrator: process
  begin
    wait until rising_edge(sClock);
    if pwm = '1' then
      if forwards = '1' then
        pwmLowpassAccumulator <= pwmLowpassAccumulator - motorSpeed + 1.0;
      else
        pwmLowpassAccumulator <= pwmLowpassAccumulator - motorSpeed - 1.0;
      end if;
    else
      pwmLowpassAccumulator <= pwmLowpassAccumulator - motorSpeed;
    end if;
  end process lowpassIntegrator;

  motorSpeed <= pwmLowpassAccumulator / 2.0**pwmLowpassShift;

  ------------------------------------------------------------------------------
                                                            -- speed to distance
  speedToDistance: process
  begin
    wait until rising_edge(sClock);
    hallPulses <= (others => '0');
    kartDistance <= kartDistance + 10.0E-3 * motorSpeed;
    if kartDistance - real(kartHallPulseCount) > 1.0 then
      kartHallPulseCount <= kartHallPulseCount + 1;
      hallPulses <= (others => '1');
    elsif kartDistance - real(kartHallPulseCount) < -1.0 then
      kartHallPulseCount <= kartHallPulseCount - 1;
      hallPulses <= (others => '1');
    end if;
  end process speedToDistance;

  --============================================================================
  -- Interpret received data
  ------------------------------------------------------------------------------
                                                                          -- FSM
  receiveDataFromKart: process
  begin
    wait until rising_edge(rs232ReceivedTxByte);
    case receiverState is
      when waitStart =>
        if rs232TxByte = 16#55# then
          receiverState <= readAddress;
        end if;
      when readAddress =>
        receivedAddress <= to_integer(signed(rs232TxByte));
        receiverState <= readDataHigh;
      when readDataHigh =>
        receivedData <= 2**rs232TxByte'length * to_integer(signed(rs232TxByte));
        receiverState <= readDataLow;
      when readDataLow =>
        receivedData <= receivedData + to_integer(rs232TxByte);
        receiverState <= checkEnd;
      when checkEnd =>
        if rs232TxByte = 16#AA# then
          case receivedAddress is
            when batteryVoltageRegisterId => batteryVoltage <= receivedData;
            when others => null;
          end case;
        end if;
        receiverState <= waitStart;
    end case;
  end process receiveDataFromKart;

  --============================================================================
  -- battery voltage
  ------------------------------------------------------------------------------
                                                                         -- time
  tEn <= not tEn after 1.0/(sampleFrequency*2.0) * 1 sec;

  process(tEn)
  begin
    if rising_edge(tEn) then
      tReal <= tReal + 1.0/sampleFrequency;
    end if;
  end process;
                                                              -- signal waveform
  batteryVoltageReal <=
    batteryVoltageOffet + 
    batteryVoltageAmplitude * sin(2.0*math_pi*signalFrequency*tReal);
                                                          -- differential output
  VINp <= integer(batteryVoltageReal) when batteryVoltageReal > 0.0
    else 0;
  VINm <= -integer(batteryVoltageReal) when batteryVoltageReal < 0.0
    else 0;

END ARCHITECTURE test;

