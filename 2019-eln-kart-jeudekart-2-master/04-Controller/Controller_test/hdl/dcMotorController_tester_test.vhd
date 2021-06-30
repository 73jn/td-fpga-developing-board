LIBRARY std;
  USE std.textio.ALL;
LIBRARY ieee;
  USE ieee.std_logic_textio.ALL;

ARCHITECTURE test OF dcMotorController_tester IS
                                                              -- clock and reset
  constant clockPeriod  : time          := 1.0/clockFrequency * 1 sec;
  signal sClock         : std_uLogic    := '1';
  signal sReset         : std_uLogic ;
                                                               -- signal periods
  constant rs232Frequency: real := rs232Baudrate;
  constant rs232Period: time := (1.0/rs232Frequency) * 1 sec;
  constant i2cPeriod: time := (1.0/i2cBaudrate) * 1 sec;
  constant i2cUpdatePeriod: time := (1.0/i2cUpdateRate) * 1 sec;
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
                                                                     -- sequence
  constant commandNoOperation: natural := 0;
  constant commandSetSpeed: natural := 1;
  constant commandRunFor: natural := 5;
  constant commandEnd: natural := 15;
  type sequenceType is array(2**sequenceAddressBitNb-1 downto 0) of natural;
  constant sequence: sequenceType := (
    0 => 2**sequenceArgumentBitNb * commandSetSpeed + 10,
    1 => 2**sequenceArgumentBitNb * commandRunFor + 300,
    2 => 2**sequenceArgumentBitNb * commandSetSpeed + 5,
    3 => 2**sequenceArgumentBitNb * commandRunFor + 200,
    4 => 2**sequenceArgumentBitNb * commandSetSpeed + 0,
    5 => 2**sequenceArgumentBitNb * commandEnd,
    others => 2**sequenceArgumentBitNb * commandNoOperation
  );

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
    -- DC motor controls: forwards, normal orientation
    ----------------------------------------------------------------------------
    write(output,
      "At time " & integer'image(now/1 us) & " us, " &
      "DC motor forwards, normal orientation" &
      lf & lf
    );
                                                      -- write prescaler divider
    busAddress <= 0/2;
    busData    <= 50;
    busSend <= '1', '0' after 1 ns;
    wait until rising_edge(busSendDone);
                                                                  -- write speed
    busAddress <= 02/2;
    busData    <= 10;
    busSend <= '1', '0' after 1 ns;
    wait until rising_edge(busSendDone);
                                                          -- write special value
    busAddress <= 04/2;
    busData    <= 16#55AA#;
    busSend <= '1', '0' after 1 ns;
    wait until rising_edge(busSendDone);
                                                   -- write hardware orientation
    busAddress <= 08/2;
    busData    <= 2#000#;
    busSend <= '1', '0' after 1 ns;
    wait until rising_edge(busSendDone);

    ----------------------------------------------------------------------------
    -- DC motor controls: backwards, normal orientation
    ----------------------------------------------------------------------------
    wait for 1.5*i2cUpdatePeriod - now;
    write(output,
      "At time " & integer'image(now/1 us) & " us, " &
      "DC motor backwards, normal orientation" &
      lf & lf
    );
                                                                  -- write speed
    busAddress <= 02/2;
    busData    <= -10;
    busSend <= '1', '0' after 1 ns;
    wait until rising_edge(busSendDone);

    ----------------------------------------------------------------------------
    -- DC motor controls: forwards, reverse orientation
    ----------------------------------------------------------------------------
    wait for 2.5*i2cUpdatePeriod - now;
    write(output,
      "At time " & integer'image(now/1 us) & " us, " &
      "DC motor forwards, normal orientation" &
      lf & lf
    );
                                                                  -- write speed
    busAddress <= 02/2;
    busData    <= 3;
    busSend <= '1', '0' after 1 ns;
    wait until rising_edge(busSendDone);
                                                   -- write hardware orientation
    busAddress <= 08/2;
    busData    <= 2#001#;
    busSend <= '1', '0' after 1 ns;
    wait until rising_edge(busSendDone);

    ----------------------------------------------------------------------------
    -- DC motor controls: backwards, reverse orientation
    ----------------------------------------------------------------------------
    wait for 3.5*i2cUpdatePeriod - now;
    write(output,
      "At time " & integer'image(now/1 us) & " us, " &
      "DC motor backwards, normal orientation" &
      lf & lf
    );
                                                                  -- write speed
    busAddress <= 02/2;
    busData    <= -3;
    busSend <= '1', '0' after 1 ns;
    wait until rising_edge(busSendDone);

    ----------------------------------------------------------------------------
    -- DC motor controls: large values
    ----------------------------------------------------------------------------
    wait for 4.5*i2cUpdatePeriod - now;
    write(output,
      "At time " & integer'image(now/1 us) & " us, " &
      "DC motor registers with large values" &
      lf & lf
    );
                                                      -- write prescaler divider
    busAddress <= 00/2;
    busData    <= 16#C33C#;
    busSend <= '1', '0' after 1 ns;
    wait until rising_edge(busSendDone);
                                                                  -- write speed
    busAddress <= 02/2;
    busData    <= 16#0FF0#;
    busSend <= '1', '0' after 1 ns;
    wait until rising_edge(busSendDone);
                                                      -- write prescaler divider
    wait for 2*i2cUpdatePeriod;
    write(output,
      "At time " & integer'image(now/1 us) & " us, " &
      "DC motor prescaler back" &
      lf & lf
    );
    busAddress <= 0/2;
    busData    <= 50;
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
    for index in 0 to 5 loop
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
    wait for i2cUpdatePeriod;
    write(output,
      "--" & lf &
      "-- End of simulation" & lf &
      "----------------------------------------------------------------" & lf &
      lf & lf & lf
    );
    assert false
      severity failure;

    wait;
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

END ARCHITECTURE test;
