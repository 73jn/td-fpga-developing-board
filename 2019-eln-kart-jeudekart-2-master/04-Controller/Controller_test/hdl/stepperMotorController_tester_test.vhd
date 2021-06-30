LIBRARY std;
  USE std.textio.ALL;
LIBRARY ieee;
  USE ieee.std_logic_textio.ALL;

ARCHITECTURE test OF stepperMotorController_tester IS

  constant clockPeriod  : time          := 1.0/clockFrequency * 1 sec;
  signal sClock         : std_uLogic    := '1';
  signal sReset         : std_uLogic ;
                                                               -- signal periods
  constant rs232Frequency: real := rs232Baudrate;
  constant rs232Period: time := (1.0/rs232Frequency) * 1 sec;
  constant i2cPeriod: time := (1.0/i2cBaudrate) * 1 sec;
  constant i2cUpdatePeriod: time := (1.0/i2cUpdateRate) * 1 sec;
                                                        -- RS232 controls
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

  constant angleMaxValue: positive := 2**angleBitNb-1;

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
    stepperTestMode <= '0';
    stepperEnd <= '0';

    wait for 5 us;
    write(output,
      lf & lf & lf &
      "----------------------------------------------------------------" & lf &
      "-- Starting testbench" & lf &
      "--" &
      lf & lf
    );

    ----------------------------------------------------------------------------
    -- Stepper motor controls, normal direction
    ----------------------------------------------------------------------------
    write(output,
      "At time " & integer'image(now/1 us) & " us, " &
      "Half turn, normal orientation" &
      lf & lf
    );
                                                      -- write prescaler divider
    busAddress <= stepperBaseAddress/2;
    busData    <= 8;
    busSend <= '1', '0' after 1 ns;
    wait until rising_edge(busSendDone);
                                                           -- write target angle
    busAddress <= stepperBaseAddress/2 + 1;
    busData    <= 100;
    busSend <= '1', '0' after 1 ns;
    wait until rising_edge(busSendDone);
                                                   -- write hardware orientation
    busAddress <= orientationBaseAddress/2;
    busData    <= 2#000#;
    busSend <= '1', '0' after 1 ns;
    wait until rising_edge(busSendDone);
                                                      -- write RS232 update rate
    busAddress <= 30/2;
    busData    <= 3;
    busSend <= '1', '0' after 1 ns;
    wait until rising_edge(busSendDone);
                                                            -- pulse stepper end
    wait until rising_edge(sClock);
    stepperEnd <= '1', '0' after i2cPeriod;

    ----------------------------------------------------------------------------
    -- Half ramp
    ----------------------------------------------------------------------------
    wait for 2*i2cUpdatePeriod;
    write(output,
      "At time " & integer'image(now/1 us) & " us, " &
      "Half turn" &
      lf & lf
    );
                                                      -- write prescaler divider
    busAddress <= stepperBaseAddress/2;
    busData    <= 4;
    busSend <= '1', '0' after 1 ns;
    wait until rising_edge(busSendDone);
                                                             -- write zero angle
    busAddress <= stepperBaseAddress/2 + 1;
    busData    <= 0;
    busSend <= '1', '0' after 1 ns;
    wait until rising_edge(busSendDone);
                                                   -- write hardware orientation
    busAddress <= orientationBaseAddress/2;
    busData    <= 2#000#;
    busSend <= '1', '0' after 1 ns;
    wait until rising_edge(busSendDone);
                                        -- wait for controls to reach the target
    wait for i2cUpdatePeriod;
                                                            -- pulse stepper end
    wait until rising_edge(sClock);
    stepperEnd <= '1', '0' after i2cPeriod;
                                                         -- write half max angle
    busAddress <= stepperBaseAddress/2 + 1;
    busData    <= angleMaxValue/2;
    busSend <= '1', '0' after 1 ns;
    wait until rising_edge(busSendDone);

    ----------------------------------------------------------------------------
    -- Full ramp
    ----------------------------------------------------------------------------
    wait for 2*i2cUpdatePeriod;
    write(output,
      "At time " & integer'image(now/1 us) & " us, " &
      "Full turn" &
      lf & lf
    );
                                                              -- write max angle
    busAddress <= stepperBaseAddress/2 + 1;
    busData    <= angleMaxValue;
    busSend <= '1', '0' after 1 ns;
    wait until rising_edge(busSendDone);

    ----------------------------------------------------------------------------
    -- Back to zero
    ----------------------------------------------------------------------------
    wait for 2*i2cUpdatePeriod;
    write(output,
      "At time " & integer'image(now/1 us) & " us, " &
      "Back to zero" &
      lf & lf
    );
                                                             -- write zero angle
    busAddress <= stepperBaseAddress/2 + 1;
    busData    <= 0;
    busSend <= '1', '0' after 1 ns;
    wait until rising_edge(busSendDone);
                                                         -- write end contact on
    wait for 1.25*i2cUpdatePeriod;
    busAddress <= orientationBaseAddress/2;
    busData    <= 16#08#;
    busSend <= '1', '0' after 1 ns;
    wait until rising_edge(busSendDone);
                                                        -- write end contact off
    wait for 1.5*i2cUpdatePeriod;
    busAddress <= orientationBaseAddress/2;
    busData    <= 16#00#;
    busSend <= '1', '0' after 1 ns;
    wait until rising_edge(busSendDone);

    ----------------------------------------------------------------------------
    -- Stepper motor controls: large values
    ----------------------------------------------------------------------------
    wait for i2cUpdatePeriod;
    write(output,
      "At time " & integer'image(now/1 us) & " us, " &
      "Stepper motor registers with large values" &
      lf & lf
    );
                                                      -- write prescaler divider
    busAddress <= stepperBaseAddress/2;
    busData    <= 16#0123#;
    busSend <= '1', '0' after 1 ns;
    wait until rising_edge(busSendDone);
                                                                  -- write speed
    busAddress <= stepperBaseAddress/2 + 1;
    busData    <= 16#4567#;
    busSend <= '1', '0' after 1 ns;
    wait until rising_edge(busSendDone);

    ----------------------------------------------------------------------------
    -- End of simulation
    ----------------------------------------------------------------------------
    wait for 2*i2cUpdatePeriod;
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
