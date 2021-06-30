LIBRARY std;
  USE std.textio.ALL;
LIBRARY ieee;
  USE ieee.std_logic_textio.ALL;

ARCHITECTURE test OF dcMotorController_tester IS
                                                              -- reset and clock
  constant clockPeriod : time := 1.0/clockFrequency * 1 sec;
  signal sClock: std_uLogic := '1';
                                                                    -- test info
  signal testInfo: string(1 to 16) := (others => ' ');
                                                                -- I2C interface
  constant i2cPeriod : time := 1.0/i2cBaudRate * 1 sec;
  constant i2cRegisterNb: positive := 16;
  type i2cRegistersType is array(0 to i2cRegisterNb-1) of integer;
  signal i2cBaseAddress: natural;
  signal i2cRegisters: i2cRegistersType;
  signal i2cDataLength: positive;
  signal i2cWrite: std_ulogic;
  signal i2cSend: std_ulogic;
  signal i2cDone: std_ulogic;
  signal i2cDataOut: unsigned(i2cBitNb-1-1 downto 0);
  signal i2cSendWord: std_ulogic;
  signal i2cWordDone: std_ulogic;
  signal i2cDataIn: integer;
                                                               -- control values
  constant restart: natural := 16#10#;
  constant btConnected: natural := 16#20#;
  signal orientation: integer;
  signal absSpeed: integer;
  constant pwmDivideValue: positive := 10;
  constant pwmPeriod : time := 2**(speedBitNb-1) * pwmDivideValue * clockPeriod;
  constant speedMaxValue: positive := 2**(speedBitNb-1)-1;
                                                               -- PWM mean value
  constant pwmLowpassShift: positive := 8;
  signal pwmLowpassAccumulator, motorSpeed: real := 0.0;
  signal motorSpeed_int: integer := 0;

BEGIN
  ------------------------------------------------------------------------------
                                                              -- reset and clock
  reset <= '1', '0' after 4*clockPeriod;

  sClock <= not sClock after clockPeriod/2;
  clock <= transport sClock after 0.9*clockPeriod;

  ------------------------------------------------------------------------------
                                                                -- test sequence
  process
  begin
    i2cSend <= '0';
    i2cWrite <= '0';
    i2cBaseAddress <= 0;
    i2cRegisters <= (others => 0);
    i2cDataLength <= 2;

    wait for 10*i2cPeriod;
    write(output,
      lf & lf & lf &
      "----------------------------------------------------------------" & lf &
      "-- Starting testbench" & lf &
      "--" &
      lf & lf
    );
                                                             -- send orientation
    testInfo <= "Init            ";
    write(output,
      "Setting hardware orientation" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    orientation <= 1;
    i2cBaseAddress <= orientationBaseAddress; wait for 0 ns;
    i2cDataLength <= 1;
    i2cRegisters(i2cBaseAddress) <= orientation + btConnected;
    i2cWrite <= '1';
    i2cSend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    wait for 10*i2cPeriod;
                                                               -- send prescaler
    wait for 2*i2cPeriod;
    write(output,
      "Sending prescaler value" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    i2cBaseAddress <= baseAddress; wait for 0 ns;
    i2cDataLength <= 2;
    i2cRegisters(i2cBaseAddress)   <= pwmDivideValue;
    i2cRegisters(i2cBaseAddress+1) <= 0;
    i2cWrite <= '1';
    i2cSend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    wait for 10*pwmPeriod;
                                                               -- send 1/3 speed
    testInfo <= "speed 1/3       ";
    write(output,
      "Sending speed control to 1/3 max value forwards" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    absSpeed <= speedMaxValue / 3;
    i2cBaseAddress <= baseAddress + 2; wait for 0 ns;
    i2cDataLength <= 2;
    i2cRegisters(i2cBaseAddress)   <= absSpeed;
    i2cRegisters(i2cBaseAddress+1) <= 0;
    i2cWrite <= '1';
    i2cSend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    wait for 10*pwmPeriod;
    assert forwards = '1'
      report "Direction error"
      severity error;
    assert abs(motorSpeed_int-absSpeed) <= 1
      report "PWM error"
      severity error;
                                                               -- send 2/3 speed
    testInfo <= "speed 2/3       ";
    write(output,
      "Sending speed control to 2/3 max value forwards" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    absSpeed <= speedMaxValue * 2/3;
    i2cBaseAddress <= baseAddress + 2; wait for 0 ns;
    i2cDataLength <= 2;
    i2cRegisters(i2cBaseAddress)   <= absSpeed;
    i2cRegisters(i2cBaseAddress+1) <= 0;
    i2cWrite <= '1';
    i2cSend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    wait for 10*pwmPeriod;
    assert forwards = '1'
      report "Direction error"
      severity error;
    assert abs(motorSpeed_int-absSpeed) <= 1
      report "PWM error"
      severity error;
                                                              -- send full speed
    testInfo <= "full speed      ";
    write(output,
      "Sending speed control to max value forwards" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    absSpeed <= speedMaxValue;
    i2cBaseAddress <= baseAddress + 2; wait for 0 ns;
    i2cDataLength <= 2;
    i2cRegisters(i2cBaseAddress)   <= absSpeed;
    i2cRegisters(i2cBaseAddress+1) <= 0;
    i2cWrite <= '1';
    i2cSend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    wait for 10*pwmPeriod;
    assert forwards = '1'
      report "Direction error"
      severity error;
    assert abs(motorSpeed_int-absSpeed) <= 1
      report "PWM error"
      severity error;
                                                     -- send 1/3 speed backwards
    testInfo <= "speed 1/3 back  ";
    write(output,
      "Sending speed control to 1/3 max value backwards" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    absSpeed <= speedMaxValue / 3;
    i2cBaseAddress <= baseAddress + 2; wait for 0 ns;
    i2cDataLength <= 2;
    i2cRegisters(i2cBaseAddress)   <= -absSpeed;
    i2cRegisters(i2cBaseAddress+1) <= -1;
    i2cWrite <= '1';
    i2cSend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    wait for 10*pwmPeriod;
    assert forwards = '0'
      report "Direction error"
      severity error;
    assert abs(motorSpeed_int+absSpeed) <= 1
      report "PWM error"
      severity error;
                                                     -- send 2/3 speed backwards
    testInfo <= "speed 2/3 back  ";
    write(output,
      "Sending speed control to 2/3 max value backwards" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    absSpeed <= speedMaxValue * 2/3;
    i2cBaseAddress <= baseAddress + 2; wait for 0 ns;
    i2cDataLength <= 2;
    i2cRegisters(i2cBaseAddress)   <= -absSpeed;
    i2cRegisters(i2cBaseAddress+1) <= -1;
    i2cWrite <= '1';
    i2cSend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    wait for 10*pwmPeriod;
    assert forwards = '0'
      report "Direction error"
      severity error;
    assert abs(motorSpeed_int+absSpeed) <= 1
      report "PWM error"
      severity error;
                                                    -- send full speed backwards
    testInfo <= "full speed back ";
    write(output,
      "Sending speed control to max value backwards" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    absSpeed <= speedMaxValue;
    i2cBaseAddress <= baseAddress + 2; wait for 0 ns;
    i2cDataLength <= 2;
    i2cRegisters(i2cBaseAddress)   <= -absSpeed;
    i2cRegisters(i2cBaseAddress+1) <= -1;
    i2cWrite <= '1';
    i2cSend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    wait for 10*pwmPeriod;
    assert forwards = '0'
      report "Direction error"
      severity error;
    assert abs(motorSpeed_int+absSpeed) <= 1
      report "PWM error"
      severity error;
                                                           -- change orientation
    testInfo <= "orientation     ";
    write(output,
      "Changing hardware orientation" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    orientation <= 0;
    i2cBaseAddress <= orientationBaseAddress; wait for 0 ns;
    i2cDataLength <= 1;
    i2cRegisters(i2cBaseAddress) <= orientation + btConnected;
    i2cWrite <= '1';
    i2cSend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    wait for 10*i2cPeriod;
                                                              -- send half speed
    testInfo <= "half speed      ";
    write(output,
      "Sending speed control to half max value forwards" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    absSpeed <= (speedMaxValue+1) / 2;
    i2cBaseAddress <= baseAddress + 2; wait for 0 ns;
    i2cDataLength <= 2;
    i2cRegisters(i2cBaseAddress)   <= absSpeed;
    i2cRegisters(i2cBaseAddress+1) <= 0;
    i2cWrite <= '1';
    i2cSend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    wait for 10*pwmPeriod;
    assert forwards = '0'
      report "Direction error"
      severity error;
    assert abs(motorSpeed_int-absSpeed) <= 1
      report "PWM error"
      severity error;
                                                              -- send full speed
    testInfo <= "full speed      ";
    write(output,
      "Sending speed control to max value forwards" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    absSpeed <= speedMaxValue;
    i2cBaseAddress <= baseAddress + 2; wait for 0 ns;
    i2cDataLength <= 2;
    i2cRegisters(i2cBaseAddress)   <= absSpeed;
    i2cRegisters(i2cBaseAddress+1) <= 0;
    i2cWrite <= '1';
    i2cSend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    wait for 10*pwmPeriod;
    assert forwards = '0'
      report "Direction error"
      severity error;
    assert abs(motorSpeed_int-absSpeed) <= 1
      report "PWM error"
      severity error;
                                                    -- send half speed backwards
    testInfo <= "half speed back ";
    write(output,
      "Sending speed control to half max value backwards" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    absSpeed <= (speedMaxValue+1) / 2;
    i2cBaseAddress <= baseAddress + 2; wait for 0 ns;
    i2cDataLength <= 2;
    i2cRegisters(i2cBaseAddress)   <= -absSpeed;
    i2cRegisters(i2cBaseAddress+1) <= -1;
    i2cWrite <= '1';
    i2cSend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    wait for 10*pwmPeriod;
    assert forwards = '1'
      report "Direction error"
      severity error;
    assert abs(motorSpeed_int+absSpeed) <= 1
      report "PWM error"
      severity error;
                                                    -- send full speed backwards
    testInfo <= "full speed back ";
    write(output,
      "Sending speed control to max value backwards" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    absSpeed <= speedMaxValue;
    i2cBaseAddress <= baseAddress + 2; wait for 0 ns;
    i2cDataLength <= 2;
    i2cRegisters(i2cBaseAddress)   <= -absSpeed;
    i2cRegisters(i2cBaseAddress+1) <= -1;
    i2cWrite <= '1';
    i2cSend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    wait for 10*pwmPeriod;
    assert forwards = '1'
      report "Direction error"
      severity error;
    assert abs(motorSpeed_int+absSpeed) <= 1
      report "PWM error"
      severity error;
                                                                 -- send speed 2
    testInfo <= "speed 2         ";
    write(output,
      "Sending speed control to 2 forwards" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    absSpeed <= 2;
    i2cBaseAddress <= baseAddress + 2; wait for 0 ns;
    i2cDataLength <= 2;
    i2cRegisters(i2cBaseAddress)   <= absSpeed;
    i2cRegisters(i2cBaseAddress+1) <= 0;
    i2cWrite <= '1';
    i2cSend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    wait for 10*pwmPeriod;
    assert motorSpeed_int > 0
      report "PWM error"
      severity error;
                                                                 -- send restart
    testInfo <= "restart         ";
    write(output,
      "Sending restart control" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    i2cBaseAddress <= orientationBaseAddress; wait for 0 ns;
    i2cDataLength <= 1;
    i2cRegisters(i2cBaseAddress) <= restart + btConnected;
    i2cWrite <= '1';
    i2cSend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    wait for 10*pwmPeriod;
    assert motorSpeed_int = 0
      report "PWM error"
      severity error;
    write(output,
      "Stopping restart control" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    i2cBaseAddress <= orientationBaseAddress; wait for 0 ns;
    i2cDataLength <= 1;
    i2cRegisters(i2cBaseAddress) <= btConnected;
    i2cWrite <= '1';
    i2cSend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    wait for 10*pwmPeriod;
    assert motorSpeed_int > 0
      report "PWM error"
      severity error;
                                                          -- loose BT connection
    testInfo <= "loose BT conn.  ";
    write(output,
      "Loosing BT connection" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    i2cBaseAddress <= orientationBaseAddress; wait for 0 ns;
    i2cDataLength <= 1;
    i2cRegisters(i2cBaseAddress) <= 0;
    i2cWrite <= '1';
    i2cSend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    wait for 10*pwmPeriod;
    assert motorSpeed_int = 0
      report "PWM error"
      severity error;
                                                            -- end of simulation
    assert false
      report "End of simulation"
      severity failure;
    wait;
  end process;


  --============================================================================
                                                               -- i2c send frame
  sendI2cFrame: process
  begin
    i2cDone <= '0';
    i2cSendWord <= '0';
    sCl <= 'H';
    sDa <= 'H';
    wait until rising_edge(i2cSend);
                                                              -- start condition
    sDa <= '0', 'H' after i2cPeriod;
    wait for i2cPeriod/2;
                                                            -- send chip address
    i2cDataOut <= to_unsigned(chipAddress/2, i2cDataOut'length-2) & '0' & '1';
    i2cSendWord <= '1', '0' after 1 ns;
    wait until falling_edge(i2cWordDone);
                                                        -- send register address
    i2cDataOut <= to_unsigned(i2cBaseAddress, i2cDataOut'length-1) & '1';
    i2cSendWord <= '1', '0' after 1 ns;
    wait until falling_edge(i2cWordDone);
                                                                 -- write access
    if i2cWrite = '1' then
                                                              -- send data bytes
      for wordIndex in i2cBaseAddress to i2cBaseAddress+i2cDataLength-1 loop
        i2cDataOut <= unsigned(
          to_signed(i2cRegisters(wordIndex), i2cDataOut'length-1) & '1'
        );
        if (i2cWrite = '0') and (wordIndex = i2cBaseAddress+i2cDataLength-1) then
          i2cDataOut(0) <= '0';
        end if;
        i2cSendWord <= '1', '0' after 1 ns;
        wait until falling_edge(i2cWordDone);
      end loop;
                                                                  -- read access
    else
                                                              -- start condition
      wait for 4*i2cPeriod;
      sDa <= '0', 'H' after i2cPeriod;
      wait for i2cPeriod/2;
                                                            -- send chip address
      i2cDataOut <= to_unsigned(chipAddress/2, i2cDataOut'length-2) & not(i2cWrite) & '1';
      i2cSendWord <= '1', '0' after 1 ns;
      wait until falling_edge(i2cWordDone);
                                                              -- read data bytes
      for wordIndex in i2cBaseAddress to i2cBaseAddress+i2cDataLength-1 loop
        i2cDataOut <= unsigned(
          to_signed(i2cRegisters(wordIndex), i2cDataOut'length-1) & '1'
        );
        if wordIndex < i2cBaseAddress+i2cDataLength-1 then
          i2cDataOut(0) <= '0';
        end if;
        i2cSendWord <= '1', '0' after 1 ns;
        wait until falling_edge(i2cWordDone);
      end loop;
    end if;
                                                               -- stop condition
    sDa <= '0';
    wait for i2cPeriod/2;
    sCl <= 'H';
    i2cDone <= '1';
    wait for i2cPeriod/2;
  end process sendI2cFrame;

  ------------------------------------------------------------------------------
                                                    -- i2c send and receive byte
  sendI2cByte: process
    variable i2cReadData: unsigned(i2cBitNb-1-1 downto 0);
  begin
    i2cWordDone <= '0';
    sCl <= 'H' after i2cPeriod/4;
    sDa <= 'H';
    wait until rising_edge(i2cSendWord);
                                                                    -- send byte
    for bitIndex in i2cDataOut'range loop
      sCl <= '0';
      wait for i2cPeriod/4;
      if i2cDataOut(bitIndex) = '0' then sDa <= '0'; else sDa <= 'H'; end if;
      wait for i2cPeriod/4;
      sCl <= 'H';
      i2cReadData := shift_left(i2cReadData, 1);
      i2cReadData(0) := to_X01(sDa);
      wait for i2cPeriod/2;
    end loop;
    if i2cWrite = '0' then
      i2cDataIn <= to_integer(shift_right(i2cReadData, 1));
    end if;
    sCl <= '0';
    wait for i2cPeriod;
    i2cWordDone <= '1';
    wait for 1 ns;
  end process sendI2cByte;

  --============================================================================
                                                                  -- PWM lowpass
  lowpassIntegrator: process
  begin
    wait until rising_edge(sClock);
    if pwm = '1' then
      if (forwards xor to_unsigned(orientation, 1)(0)) = '0' then
        pwmLowpassAccumulator <= pwmLowpassAccumulator - motorSpeed + 1.0;
      else
        pwmLowpassAccumulator <= pwmLowpassAccumulator - motorSpeed - 1.0;
      end if;
    else
      pwmLowpassAccumulator <= pwmLowpassAccumulator - motorSpeed;
    end if;
  end process lowpassIntegrator;

  motorSpeed <= pwmLowpassAccumulator / 2.0**pwmLowpassShift;
  motorSpeed_int <= integer(real(speedMaxValue) * motorSpeed);

END ARCHITECTURE test;
