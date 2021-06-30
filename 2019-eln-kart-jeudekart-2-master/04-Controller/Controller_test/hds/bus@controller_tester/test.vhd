LIBRARY std;
  USE std.textio.ALL;
LIBRARY ieee;
  USE ieee.std_logic_textio.ALL;

ARCHITECTURE test OF motorControl_tester IS

  constant clockPeriod  : time          := 100 ns;
  signal sClock         : std_uLogic    := '1';

  signal busAddress     : natural       := 0;
  signal busData        : integer       := 0;
  signal sRW            : std_uLogic    := '0';

  constant testMessageLength: positive := 80;
  signal testMessage: string(1 to testMessageLength);

BEGIN

  reset <= '1', '0' after clockPeriod/5;

  sClock <= not sClock after clockPeriod/2;
  clock <= sClock after clockPeriod/10;

--------------------------------------------------------------------------------
                                                                -- test sequence
  testSequence: process
  begin
                                                               -- initial values
    sRW                 <= '0';
    stepper_end         <= '0';
    joystick_left       <= '0';
    joystick_right      <= '0';
    joystick_backwards  <= '0';
    joystick_forwards   <= '0';
    joystick_toggleSpeed<= '0';
    testMode            <= '0';

    wait for 5 us;
    write(output,
      lf & lf & lf &
      "----------------------------------------------------------------" & lf &
      "-- Starting testbench" & lf &
      "--" &
      lf & lf
    );

    ----------------------------------------------------------------------------
    -- DC motor controls
    ----------------------------------------------------------------------------
    wait for 5 us;
    write(output,
      "At time " & integer'image(now/1 us) & " us, " &
      "testing DC motor controls   " &
      lf & lf
    );
                                                       -- release DC motor brake
    wait for 1 us;
    busAddress <= 1;
    busData <= 0;
                                                 -- write DC motor slow forwards
    wait for 1 us;
    busAddress <= 0;
    busData <= 1;
                                                 -- write DC motor fast forwards
    wait for 1 us;
    busAddress <= 0;
    busData <= 2;
                                                 -- write DC motor slow forwards
    wait for 1 us;
    busAddress <= 0;
    busData <= 1;
                                                          -- write DC motor stop
    wait for 1 us;
    busAddress <= 0;
    busData <= 0;
                                                         -- write DC motor brake
    wait for 5 us;
    busAddress <= 1;
    busData <= 1;
                                                       -- release DC motor brake
    wait for 5 us;
    busAddress <= 1;
    busData <= 0;
                                                -- write DC motor slow backwards
    wait for 1 us;
    busAddress <= 0;
    busData <= -1;
                                                -- write DC motor fast backwards
    wait for 1 us;
    busAddress <= 0;
    busData <= -2;
                                                -- write DC motor slow backwards
    wait for 1 us;
    busAddress <= 0;
    busData <= -1;
                                                          -- write DC motor stop
    wait for 1 us;
    busAddress <= 0;
    busData <= 0;

    ----------------------------------------------------------------------------
    -- Stepper motor with sensor on right side
    ----------------------------------------------------------------------------
    wait for 50 us;
    write(output,
      "At time " & integer'image(now/1 us) & " us, " &
      "testing stepper motor, sensor on right side   " &
      lf & lf
    );
                                                   -- write stepper motor period
    wait for 1 us;
    busAddress <= 5;
    busData <= 10;
                                                    -- write stepper sensor side
    wait for 1 us;
    busAddress <= 6;
    busData <= 1;
                                                    -- start stepper motor right
    wait for 1 us;
    busAddress <= 4;
    busData <= 3;
                                                      -- read stepper end signal
    wait for 10 us;
    sRW <= '1';
    busAddress <= 9;
    wait for 1 us;
    sRW <= '0';
                                                 -- test end of turning capacity
    wait for 10 us;
    stepper_end <= '1';
                                                           -- stop stepper motor
    wait for 10 us;
    busAddress <= 4;
    busData <= 2;
                                                      -- read stepper end signal
    wait for 1 us;
    sRW <= '1';
    busAddress <= 9;
    wait for 1 us;
    sRW <= '0';
                                                     -- start stepper motor left
    wait for 10 us;
    busAddress <= 4;
    busData <= -3;
                                                -- leave end of turning capacity
    wait for 10 us;
    stepper_end <= '0';
                                                          -- stop stepper motor
    wait for 20 us;
    busAddress <= 4;
    busData <= -2;
                                                  -- read stepper motor position
    wait for 1 us;
    sRW <= '1';
    busAddress <= 10;
    wait for 1 us;
    busAddress <= 11;
    wait for 1 us;
    sRW <= '0';

    ----------------------------------------------------------------------------
    -- Stepper motor with sensor on left side
    ----------------------------------------------------------------------------
    wait for 50 us;
    write(output,
      "At time " & integer'image(now/1 us) & " us, " &
      "testing stepper motor, sensor on left side   " &
      lf & lf
    );
                                                      -- set stepper sensor side
    wait for 1 us;
    busAddress <= 6;
    busData <= -1;
                                                     -- start stepper motor left
    wait for 1 us;
    busAddress <= 4;
    busData <= -3;
                                                      -- read stepper end signal
    wait for 10 us;
    sRW <= '1';
    busAddress <= 9;
    wait for 1 us;
    sRW <= '0';
                                                 -- test end of turning capacity
    wait for 10 us;
    stepper_end <= '1';
                                                           -- stop stepper motor
    wait for 10 us;
    busAddress <= 4;
    busData <= 2;
                                                      -- read stepper end signal
    wait for 1 us;
    sRW <= '1';
    busAddress <= 9;
    wait for 1 us;
    sRW <= '0';
                                                    -- start stepper motor right
    wait for 10 us;
    busAddress <= 4;
    busData <= 3;
                                                -- leave end of turning capacity
    wait for 10 us;
    stepper_end <= '0';
                                                          -- stop stepper motor
    wait for 20 us;
    busAddress <= 4;
    busData <= -2;
                                                  -- read stepper motor position
    wait for 1 us;
    sRW <= '1';
    busAddress <= 10;
    wait for 1 us;
    busAddress <= 11;
    wait for 1 us;
    sRW <= '0';
    ----------------------------------------------------------------------------
    -- Stepper motor with sensor on left side
    ----------------------------------------------------------------------------
    wait for 50 us;
    write(output,
      "At time " & integer'image(now/1 us) & " us, " &
      "testing remote controls   " & 
      lf & lf
    );
                                                       -- read joystick controls
    wait for 1 us;
    joystick_left <= '1';
    sRW <= '1';
    busAddress <= 8;
    wait for 1 us;
    busAddress <= 0;
    wait for 1 us;
    joystick_left <= '0';
    joystick_right <= '1';
    joystick_toggleSpeed <= '1';
    busAddress <= 8;
    wait for 1 us;
    sRW <= '0';
    joystick_right <= '0';
    joystick_toggleSpeed <= '0';

    ----------------------------------------------------------------------------
    -- Stepper motor, real speed
    ----------------------------------------------------------------------------
    wait for 50 us;
    write(output,
      "At time " & integer'image(now/1 us) & " us, " &
      "testing stepper motor, real speed   " &
      lf & lf
    );
                                                   -- write stepper motor period
    wait for 1 us;
    busAddress <= 5;
    busData <= 1;
                                                    -- start stepper motor right
    wait for 1 us;
    busAddress <= 4;
    busData <= 1;

    ----------------------------------------------------------------------------
    -- Debug port
    ----------------------------------------------------------------------------
    wait for 50 us;
    write(output,
      "At time " & integer'image(now/1 us) & " us, " &
      "testing debug port   " &
      lf & lf
    );
                                                                   -- write LEDs
    wait for 50 us;
    busAddress <= 14;
    busData <= 5;
                                                            -- write serial port
    wait for 1 us;
    busAddress <= 15;
    busData <= 70;  -- 'F', 46h
                                                      -- read serial port status
    wait for 500 us;
    sRW <= '1';
    busAddress <= 14;
    wait for 1 us;
    sRW <= '0';
                                                            -- write serial port
    wait for 1 us;
    busAddress <= 15;
    busData <= 67;  -- 'C', 43h
                                                      -- read serial port status
    wait for 1.5 ms;
    sRW <= '1';
    busAddress <= 14;
    wait for 1 us;
    sRW <= '0';
                                                            -- write serial port
    wait for 1 us;
    busAddress <= 15;
    busData <= 67;  -- 'C', 43h

    ----------------------------------------------------------------------------
    -- End of simulation
    ----------------------------------------------------------------------------
    wait for 4 ms - now;
    write(output,
      "--" & lf &
      "-- End of simulation" & lf &
      "----------------------------------------------------------------" & lf &
      lf & lf & lf
    );
    assert false
      severity failure;

  end process testSequence;

--------------------------------------------------------------------------------
                                                                 -- bus accesses
  accessBus: process
  begin
    CS <= '0';
    wait until (busAddress'event) or (busAddress'transaction = '1')
            or (busData'event)    or (busData'transaction = '1');
    wait for 4*clockPeriod;
    CS <= '1';
    wait for 4*clockPeriod;
  end process accessBus;

  A <= std_uLogic_vector(to_unsigned(busAddress, A'length));
  D <= std_logic_vector(to_signed(busData, D'length)) when sRW = '0'
       else (others => 'Z');
  RW <= sRW;

END test;
