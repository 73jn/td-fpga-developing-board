LIBRARY std;
  USE std.textio.ALL;
LIBRARY ieee;
  USE ieee.std_logic_textio.ALL;

ARCHITECTURE test OF stepperMotorController_tester IS
                                                              -- reset and clock
  constant clockPeriod : time := 1.0/clockFrequency * 1 sec;
  signal sClock: std_uLogic := '1';
                                                                    -- test info
  signal testInfo: string(1 to 16) := (others => ' ');
                                                                -- I2C interface
  constant i2cPeriod : time := 1.0/i2cBaudRate * 1 sec;
  constant i2cDataBitNb : positive := i2cBitNb-2;
  constant i2cRegisterNb: positive := 16;
  type i2cRegistersType is array(0 to i2cRegisterNb-1) of integer;
  signal i2cBaseAddress: natural;
  signal i2cRegistersOut: i2cRegistersType;
  signal i2cDataLength: positive;
  signal i2cWrite: std_ulogic;
  signal i2cSend: std_ulogic;
  signal i2cDone: std_ulogic;
  signal i2cDataOut: unsigned(i2cBitNb-1-1 downto 0);
  signal i2cSendWord: std_ulogic;
  signal i2cWordDone: std_ulogic;
  signal i2cDataIn: integer;
                                                        -- I2C registers readout
  signal i2cRegistersIn: i2cRegistersType := (others => 0);
  signal i2cReadAddress: natural;
  signal i2cStart: std_ulogic;
  signal i2cDataValid: std_ulogic;
  type i2cReadStateType is (
    idle,
    readChipAddress, readRegisterAddress,
    readRegisterData
  );
  signal i2cReadState: i2cReadStateType := idle;
                                                           -- DUT readout values
  signal dutReached: std_ulogic;
  signal dutPosition: natural;
                                                               -- coils analysis
  signal coils, prevCoils: std_ulogic_vector(1 to 5);
  signal turn1to4, turnBack: std_ulogic;
  signal lastEvent: time;
  signal onTime: integer;
                                                              -- steering values
  constant stepDivideValue: positive := 3;
  constant angleMaxValue: positive := 1E3;
  constant hardwareOrientation: natural := 2#111#;

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
    testMode <= '0';
    stepperEnd <= '0';
    i2cSend <= '0';
    i2cWrite <= '0';
    i2cBaseAddress <= 0;
    i2cRegistersOut <= (others => 0);
    i2cDataLength <= i2cRegisterNb;

    wait for 1 ns;
    write(output,
      lf & lf & lf &
      "----------------------------------------------------------------" & lf &
      "-- Starting testbench" & lf &
      "--" &
      lf & lf
    );
                                                               -- send prescaler
    testInfo <= "Init            ";
    wait for 10*i2cPeriod;
    stepperEnd <= '0';
    write(output,
      "Sending step divider value" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    i2cBaseAddress <= baseAddress; wait for 0 ns;
    i2cDataLength <= 2;
    i2cRegistersOut(i2cBaseAddress)   <= stepDivideValue;
    i2cRegistersOut(i2cBaseAddress+1) <= 0;
    i2cWrite <= '1';
    I2Csend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    wait for 100*i2cPeriod;
                                                                 -- send restart
    testInfo <= "Restart         ";
    write(output,
      "restarting to zero position" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    i2cBaseAddress <= orientationAddress; wait for 0 ns;
    i2cDataLength <= 1;
    i2cRegistersOut(i2cBaseAddress) <= 16#10# + hardwareOrientation;
    i2cWrite <= '1';
    I2Csend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    wait for 10*i2cPeriod;
    i2cBaseAddress <= orientationAddress; wait for 0 ns;
    i2cDataLength <= 1;
    i2cRegistersOut(i2cBaseAddress) <= hardwareOrientation;
    i2cWrite <= '1';
    I2Csend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    wait for 10*i2cPeriod;
    assert turn1to4 = turnBack
      report "Coil direction error"
      severity error;
                                                           -- actuate end switch
    testInfo <= "End switch local";
    write(output,
      "Activating end of turn switch" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    stepperEnd <= '1', '0' after 4*i2cPeriod;
    wait for 100*i2cPeriod;
    assert unsigned(coils) = 0
      report "Coil on error"
      severity error;
                                                              -- send half angle
    testInfo <= "Turn 1/2        ";
    write(output,
      "Sending turn control to half angle" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    i2cBaseAddress <= baseAddress + 2; wait for 0 ns;
    i2cDataLength <= 2;
    i2cRegistersOut(i2cBaseAddress)   <= angleMaxValue/2 mod 2**i2cDataBitNb;
    i2cRegistersOut(i2cBaseAddress+1) <= angleMaxValue/2 / 2**i2cDataBitNb;
    i2cWrite <= '1';
    i2cSend <= '1', '0' after 1 ns;
                                                               -- ask for status
    wait for angleMaxValue/2*2**prescalerBitNb*stepDivideValue*clockPeriod*3/4;
    testInfo <= "Ask for status  ";
    write(output,
      "Asking for status" &
      " at time " & integer'image(now/1 us) & " us" &
      lf &
      "  Should be FFFDh (not reached)" &
      lf & lf
    );
    i2cBaseAddress <= baseAddress; wait for 0 ns;
    i2cDataLength <= 2;
    i2cRegistersOut(i2cBaseAddress)   <= 16#FF#;
    i2cRegistersOut(i2cBaseAddress+1) <= 16#FF#;
    i2cWrite <= '0';
    i2cSend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    assert dutReached = '0'
      report "Reached flag error"
      severity error;
    assert turn1to4 = not turnBack
      report "Coil direction error"
      severity error;
                                                               -- ask for status
    wait for angleMaxValue/2*2**prescalerBitNb*stepDivideValue*clockPeriod*1/4;
    write(output,
      "Asking for status" &
      " at time " & integer'image(now/1 us) & " us" &
      lf &
      "  Should be FFFFh (reached)" &
      lf & lf
    );
    i2cBaseAddress <= baseAddress; wait for 0 ns;
    i2cDataLength <= 2;
    i2cRegistersOut(i2cBaseAddress)   <= 16#FF#;
    i2cRegistersOut(i2cBaseAddress+1) <= 16#FF#;
    i2cWrite <= '0';
    i2cSend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    assert dutReached = '1'
      report "Reached flag error"
      severity error;
                                                             -- ask for position
    wait for 2*i2cPeriod;
    write(output,
      "Asking for position" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    i2cBaseAddress <= baseAddress + 2; wait for 0 ns;
    i2cDataLength <= 2;
    i2cRegistersOut(i2cBaseAddress)   <= 16#FF#;
    i2cRegistersOut(i2cBaseAddress+1) <= 16#FF#;
    i2cWrite <= '0';
    i2cSend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    assert dutPosition = angleMaxValue/2
      report "Position readback error"
      severity error;
    wait for 100*i2cPeriod;
    assert unsigned(coils) = 0
      report "Coil on error"
      severity error;
                                                              -- send full angle
    testInfo <= "Turn full       ";
    write(output,
      "Sending turn control to full angle" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    i2cBaseAddress <= baseAddress + 2; wait for 0 ns;
    i2cDataLength <= 2;
    i2cRegistersOut(i2cBaseAddress)   <= angleMaxValue mod 2**i2cDataBitNb;
    i2cRegistersOut(i2cBaseAddress+1) <= angleMaxValue / 2**i2cDataBitNb;
    i2cWrite <= '1';
    i2cSend <= '1', '0' after 1 ns;
    wait for angleMaxValue/2*2**prescalerBitNb*stepDivideValue*clockPeriod;
    wait for 100*i2cPeriod;
                                                              -- send zero angle
    testInfo <= "Turn back       ";
    write(output,
      "Sending turn control to angle zero" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    i2cBaseAddress <= baseAddress + 2; wait for 0 ns;
    i2cDataLength <= 2;
    i2cRegistersOut(i2cBaseAddress)   <= 0;
    i2cRegistersOut(i2cBaseAddress+1) <= 0;
    i2cWrite <= '1';
    i2cSend <= '1', '0' after 1 ns;
    wait for angleMaxValue*2**prescalerBitNb*stepDivideValue*clockPeriod*9/10;
    assert turn1to4 = turnBack
      report "Coil direction error"
      severity error;
                                               -- assert end contact from master
    testInfo <= "End switch mst  ";
    write(output,
      "Sending end contact ON" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    i2cBaseAddress <= orientationAddress; wait for 0 ns;
    i2cDataLength <= 1;
    i2cRegistersOut(orientationAddress) <= 16#08# + hardwareOrientation;
    i2cWrite <= '1';
    i2cSend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    wait for 10*i2cPeriod;
                                             -- deassert end contact from master
    write(output,
      "Sending end contact OFF" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    i2cBaseAddress <= orientationAddress; wait for 0 ns;
    i2cDataLength <= 1;
    i2cRegistersOut(i2cBaseAddress) <= hardwareOrientation;
    i2cWrite <= '1';
    i2cSend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    wait for 100*i2cPeriod;
                                                              -- send half angle
    testInfo <= "Turn 1/2        ";
    write(output,
      "Sending turn control to half angle" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    i2cBaseAddress <= baseAddress + 2; wait for 0 ns;
    i2cDataLength <= 2;
    i2cRegistersOut(i2cBaseAddress)   <= (angleMaxValue+1)/2 mod 2**i2cDataBitNb;
    i2cRegistersOut(i2cBaseAddress+1) <= (angleMaxValue+1)/2 / 2**i2cDataBitNb;
    i2cWrite <= '1';
    i2cSend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    wait for angleMaxValue/4*2**prescalerBitNb*stepDivideValue*clockPeriod;
    assert turn1to4 = not turnBack
      report "Coil direction error"
      severity error;
                                                           -- assert restart bit
    testInfo <= "Restart on      ";
    write(output,
      "Sending restart control" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    i2cBaseAddress <= orientationAddress; wait for 0 ns;
    i2cDataLength <= 1;
    i2cRegistersOut(i2cBaseAddress)   <= 16#10# + hardwareOrientation;
    i2cWrite <= '1';
    I2Csend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    wait for 20*i2cPeriod;
    assert turn1to4 = turnBack
      report "Coil direction error"
      severity error;
                                                -- assert end contact from slave
    testInfo <= "End switch I/O  ";
    write(output,
      "Sending end contact ON" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    wait for 10*i2cPeriod;
    i2cBaseAddress <= baseAddress + 4; wait for 0 ns;
    i2cDataLength <= 1;
    i2cRegistersOut(i2cBaseAddress)   <= 16#FE#;
    i2cWrite <= '0';
    i2cSend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    wait for 100*i2cPeriod;
                                                         -- deassert restart bit
    testInfo <= "Restart off     ";
    write(output,
      "Ending restart control" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    i2cBaseAddress <= orientationAddress; wait for 0 ns;
    i2cDataLength <= 1;
    i2cRegistersOut(i2cBaseAddress)   <= hardwareOrientation;
    i2cWrite <= '1';
    I2Csend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    wait for 100*i2cPeriod;
                                              -- deassert end contact from slave
    write(output,
      "Sending end contact OFF" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    i2cBaseAddress <= baseAddress + 4; wait for 0 ns;
    i2cDataLength <= 1;
    i2cRegistersOut(i2cBaseAddress)   <= 16#FF#;
    i2cWrite <= '0';
    i2cSend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    wait for 100*i2cPeriod;
                                             -- deassert end contact from master
    testInfo <= "End switch off  ";
    write(output,
      "Sending end contact OFF" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    i2cBaseAddress <= orientationAddress; wait for 0 ns;
    i2cDataLength <= 1;
    i2cRegistersOut(i2cBaseAddress) <= hardwareOrientation;
    i2cWrite <= '1';
    i2cSend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    wait for angleMaxValue/2*2**prescalerBitNb*stepDivideValue*clockPeriod;
                                                              -- send zero angle
    testInfo <= "Turn back       ";
    write(output,
      "Sending turn control to angle zero" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    i2cBaseAddress <= baseAddress + 2; wait for 0 ns;
    i2cDataLength <= 2;
    i2cRegistersOut(i2cBaseAddress)   <= 0;
    i2cRegistersOut(i2cBaseAddress+1) <= 0;
    i2cWrite <= '1';
    i2cSend <= '1', '0' after 1 ns;
    wait for angleMaxValue*2**prescalerBitNb*stepDivideValue*clockPeriod;
                                                   -- send prescaler large value
    testInfo <= "Step divider    ";
    write(output,
      "Sending large divider value" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    i2cBaseAddress <= baseAddress; wait for 0 ns;
    i2cDataLength <= 2;
    i2cRegistersOut(i2cBaseAddress)   <= 16#34#;
    i2cRegistersOut(i2cBaseAddress+1) <= 16#12#;
    i2cWrite <= '1';
    I2Csend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    wait for 100*i2cPeriod;
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
    i2cStart <= '0';
    i2cSendWord <= '0';
    sCl <= 'H';
    sDa <= 'H';
    wait until rising_edge(i2cSend);
                                                              -- start condition
    sDa <= '0', 'H' after i2cPeriod;
    i2cStart <= '1', '0' after i2cPeriod;
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
          to_signed(i2cRegistersOut(wordIndex), i2cDataOut'length-1) & '1'
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
      i2cStart <= '1', '0' after i2cPeriod;
      wait for i2cPeriod/2;
                                                            -- send chip address
      i2cDataOut <= to_unsigned(chipAddress/2, i2cDataOut'length-2) & not(i2cWrite) & '1';
      i2cSendWord <= '1', '0' after 1 ns;
      wait until falling_edge(i2cWordDone);
                                                              -- read data bytes
      for wordIndex in i2cBaseAddress to i2cBaseAddress+i2cDataLength-1 loop
        i2cDataOut <= unsigned(
          to_signed(i2cRegistersOut(wordIndex), i2cDataOut'length-1) & '1'
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
    i2cDataValid <= '0';
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
      i2cDataValid <= '1' after i2cPeriod / 2;
    end if;
    sCl <= '0';
    wait for i2cPeriod;
    i2cWordDone <= '1';
    wait for 1 ns;
  end process sendI2cByte;

  ------------------------------------------------------------------------------
                                                                 -- i2c readback
  updateState: process(i2cStart, i2cDataValid)
  begin
    if rising_edge(i2cStart) then
      i2cReadState <= readChipAddress;
    elsif rising_edge(i2cDataValid) then
      case i2cReadState is
        when readRegisterAddress =>
          i2cReadAddress <= i2cDataIn;
        when readRegisterData =>
          i2cRegistersIn(i2cReadAddress) <= i2cDataIn;
        when others => null;
      end case;
    elsif falling_edge(i2cDataValid) then
      case i2cReadState is
        when readChipAddress =>
          case i2cDataIn is
            when chipAddress =>
              i2cReadState <= readRegisterAddress;
            when chipAddress+1 =>
              i2cReadState <= readRegisterData;
            when others =>
              i2cReadState <= idle;
          end case;
        when readRegisterAddress =>
          i2cReadState <= readRegisterData;
        when readRegisterData =>
          i2cReadAddress <= i2cReadAddress + 1;
        when others => null;
      end case;
    end if;
  end process updateState;
                                                                -- data decoding
  dutReached <= to_unsigned(i2cRegistersIn(baseAddress), i2cDataBitNb)(1);
  dutPosition <= i2cRegistersIn(baseAddress+2) +
    2**i2cDataBitNb * i2cRegistersIn(baseAddress+3);

  ------------------------------------------------------------------------------
                                                                -- coil analysis
  coils <= (coil1, coil2, coil3, coil4, coil1);

  findDir: process(coils)
    variable onTime_var: integer;
  begin
    turn1to4 <= '0';
    for index in 2 to coils'right loop
      if coils(index) = '1' then
        if prevCoils(index-1) = '1' then
          turn1to4 <= '1';
        end if;
      end if;
    end loop;
    prevCoils <= coils after 1 ns;
    if unsigned(prevCoils) /= 0 then
      onTime_var := integer( (now - lastEvent) / clockPeriod);
      onTime <= onTime_var;
      if unsigned(coils) /= 0 then
        assert onTime_var <= 2**prescalerBitNb*stepDivideValue + 1
          report "Coil on for too long"
          severity error;
      end if;
    end if;
    lastEvent <= now;
  end process findDir;

  turnBack <= '1' when (hardwareOrientation/2 = 1) or (hardwareOrientation/2 = 2)
    else '0';

END ARCHITECTURE test;
