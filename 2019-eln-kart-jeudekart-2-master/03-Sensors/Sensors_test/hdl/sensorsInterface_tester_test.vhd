LIBRARY std;
  USE std.textio.ALL;
LIBRARY ieee;
  USE ieee.std_logic_textio.ALL;

ARCHITECTURE test OF sensorsInterface_tester IS
                                                              -- reset and clock
  constant clockPeriod : time := 1.0/clockFrequency * 1 sec;
  signal sClock: std_ulogic := '1';
                                                                    -- test info
  signal testInfo: string(1 to 16) := (others => ' ');
                                                                -- I2C interface
  constant i2cPeriod : time := 1.0/i2cBaudRate * 1 sec;
  constant i2cRegisterNb: positive := 32;
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
                                                                  -- Hall pulses
  constant hallFrequency: real := 10.0E3;
  constant hallPeriod : time := 1.0/real(hallFrequency) * 1 sec;
  signal hallPulses_int: std_ulogic_vector(1 to hallSensorNb) := (others => '0');
  type hallCountersType is array (1 to hallSensorNb) of integer;
  signal tbHallCounters: hallCountersType := (others => -1);
  signal dutHallCounters: hallCountersType := (others => 0);
                                                                    -- IR ranger
  signal tbRangerDistance: natural := 1E3;
  signal dutRangerDistance: natural := 0;
                                                             -- proximity sensor
  constant proximityClockPeriod : time := 1.0/proximityBaudRate * 1 sec;
  constant proximityFramePeriod : time := 20*10*proximityClockPeriod;
                                                                    -- IR ranger
  signal tbEndSwitches: std_ulogic_vector(endSwitches'range) := (others => '0');
  signal dutEndSwitches: std_ulogic_vector(endSwitches'range) := (others => '0');

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
    i2cRegistersOut <= (others => 0);
    i2cDataLength <= 2;

    wait for 10*i2cPeriod;
    write(output,
      lf & lf & lf &
      "----------------------------------------------------------------" & lf &
      "-- Starting testbench" & lf &
      "--" &
      lf & lf
    );
                                                                    -- send LEDs
    testInfo <= "LEDs            ";
    write(output,
      "Setting LEDs" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    i2cBaseAddress <= ledsBaseAddress; wait for 0 ns;
    i2cDataLength <= 2;
    i2cRegistersOut(i2cBaseAddress)   <= 16#55#;
    i2cRegistersOut(i2cBaseAddress+1) <= 16#00#;
    i2cWrite <= '1';
    i2cSend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    assert leds = "1010"  -- range is 1 to 4 => reversal
      report "Leds control error"
      severity error;
    wait for 10*i2cPeriod;
                                                                    -- send LEDs
    write(output,
      "Inverting LEDs" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    i2cBaseAddress <= ledsBaseAddress; wait for 0 ns;
    i2cDataLength <= 2;
    i2cRegistersOut(i2cBaseAddress)   <= 16#0A#;
    i2cRegistersOut(i2cBaseAddress+1) <= 16#00#;
    i2cWrite <= '1';
    i2cSend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    assert leds = "0101"
      report "Leds control error"
      severity error;
    wait for 100*i2cPeriod;
                                                           -- read Hall counters
    testInfo <= "Hall count      ";
    write(output,
      "Reading Hall sensor counters" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    i2cBaseAddress <= hallBaseAddress; wait for 0 ns;
    i2cDataLength <= 2*hallSensorNb; wait for 0 ns;
    for index in 0 to i2cDataLength-1 loop
      i2cRegistersOut(i2cBaseAddress+index) <= 16#FF#;
    end loop;
    i2cWrite <= '0';
    i2cSend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    assert dutHallCounters = tbHallCounters
      report "Hall count error"
      severity error;
    wait for 100*i2cPeriod;
                                                     -- read ultrasound distance
    testInfo <= "ultrasound range";
    wait for 2*i2cPeriod;
    write(output,
      "Reading ultrasound ranger distance" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    i2cBaseAddress <= rangeBaseAddress; wait for 0 ns;
    i2cDataLength <= 2; wait for 0 ns;
    for index in 0 to i2cDataLength-1 loop
      i2cRegistersOut(i2cBaseAddress+index) <= 16#FF#;
    end loop;
    i2cWrite <= '0';
    i2cSend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    assert abs(tbRangerDistance - dutRangerDistance) <= 2
      report "Ultrasound ranger count error"
      severity error;
    wait for 100*i2cPeriod;
                                                      -- start proximity sensors
    testInfo <= "proximity sensor";
    wait for 2*i2cPeriod;
    write(output,
      "Starting proximity sensors" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    i2cBaseAddress <= proximityBaseAddress+2*2*proximitySensorNb-1; wait for 0 ns;
    i2cDataLength <= 1;
    i2cRegistersOut(i2cBaseAddress) <= 16#FF#;
    i2cWrite <= '0';
    i2cSend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    wait for proximityFramePeriod;
                                                       -- read proximity sensors
    wait for 2*i2cPeriod;
    write(output,
      "Reading proximity sensors" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    i2cBaseAddress <= proximityBaseAddress; wait for 0 ns;
    i2cDataLength <= 2*2*proximitySensorNb; wait for 0 ns;
    for index in 0 to i2cDataLength-1 loop
      i2cRegistersOut(i2cBaseAddress+index) <= 16#FF#;
    end loop;
    i2cWrite <= '0';
    i2cSend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    wait for proximityFramePeriod;
--    wait for 100*i2cPeriod;
                                                 -- activate and read end switch
    testInfo <= "end switch      ";
    write(output,
      "Reading activated end switch" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    i2cBaseAddress <= endSwitchBaseAddress; wait for 0 ns;
    i2cDataLength <= 1; wait for 0 ns;
    for index in 0 to i2cDataLength-1 loop
      i2cRegistersOut(i2cBaseAddress+index) <= 16#FF#;
    end loop;
    i2cWrite <= '0';
    i2cSend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    wait for 20*i2cPeriod;
    tbEndSwitches(1) <= '1';
    i2cBaseAddress <= endSwitchBaseAddress; wait for 0 ns;
    i2cDataLength <= 1; wait for 0 ns;
    for index in 0 to i2cDataLength-1 loop
      i2cRegistersOut(i2cBaseAddress+index) <= 16#FF#;
    end loop;
    i2cWrite <= '0';
    i2cSend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    assert dutEndSwitches = tbEndSwitches
      report "End switch error"
      severity error;
    wait for 20*i2cPeriod;
                                               -- deactivate and read end switch
    wait for 2*i2cPeriod;
    write(output,
      "Reading deactivated end switch" &
      " at time " & integer'image(now/1 us) & " us" &
      lf & lf
    );
    tbEndSwitches(1) <= '0';
    i2cBaseAddress <= endSwitchBaseAddress; wait for 0 ns;
    i2cDataLength <= 1; wait for 0 ns;
    for index in 0 to i2cDataLength-1 loop
      i2cRegistersOut(i2cBaseAddress+index) <= 16#FF#;
    end loop;
    i2cWrite <= '0';
    i2cSend <= '1', '0' after 1 ns;
    wait until i2cDone = '1';
    assert dutEndSwitches = tbEndSwitches
      report "End switch error"
      severity error;
    wait for 100*i2cPeriod;
                                                            -- end of simulation
    assert false
      report "End of simulation"
      severity failure;
    wait;
  end process;

  --============================================================================
                                                                 -- hall sensors
  buildPulses: for index in hallPulses_int'range generate
    hallPulses_int(index) <= not hallPulses_int(index) after hallPeriod * (index+1) / 2;
  end generate buildPulses;

  hallPulses <= hallPulses_int;

  updateHallCount: for index in hallPulses_int'range generate
    process(hallPulses_int(index))
    begin
      tbHallCounters(index) <= tbHallCounters(index) + 1;
    end process;
  end generate updateHallCount;

  ------------------------------------------------------------------------------
                                                            -- ultrasound ranger
  tbRangerDistance <= tbRangerDistance + 1 after 1E3*clockPeriod;

  sendDistancePulse: process
  begin
    distancePulse <= '0';
    wait until rising_edge(distanceStart);
    wait for 20 us;
    distancePulse <= '1';
    wait for tbRangerDistance * clockPeriod;
  end process;

  ------------------------------------------------------------------------------
                                                            -- proximity sensors
  proxySDaIn <= proxySDaOut;

  ------------------------------------------------------------------------------
                                                                 -- end switches
  endSwitches <= tbEndSwitches;

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
  assignHallCounters: for index in dutHallCounters'range generate
    dutHallCounters(index) <= i2cRegistersIn(hallBaseAddress + 2*(index-1))
      + 2**8 * i2cRegistersIn(hallBaseAddress + 2*(index-1)+1);
  end generate assignHallCounters;

  dutRangerDistance <= i2cRegistersIn(rangeBaseAddress)
      + 2**8 * i2cRegistersIn(rangeBaseAddress + 1);

  dutEndSwitches <= not std_ulogic_vector(
    to_unsigned(i2cRegistersIn(endSwitchBaseAddress), dutEndSwitches'length)
  );

END ARCHITECTURE test;
