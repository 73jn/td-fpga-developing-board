ARCHITECTURE test_testCircuit OF motorControl_tester IS

  constant clockPeriod  : time          := 100 ns;
  signal sClock         : std_uLogic    := '1';

BEGIN

  reset <= '1', '0' after clockPeriod/5;

  sClock <= not sClock after clockPeriod/2;
  clock <= sClock after clockPeriod/10;

--------------------------------------------------------------------------------
                                                                -- test sequence
  testSequence: process
  begin
                                                               -- initial values
    stepper_end         <= '0';
    joystick_left       <= '0';
    joystick_right      <= '0';
    joystick_backwards  <= '0';
    joystick_forwards   <= '0';
    joystick_toggleSpeed<= '0';
    testMode            <= '1';

    wait for 1 us;
    assert false
      report
        lf & lf & lf &
        "========================" & lf &
        "== Starting testbench   " & lf &
        "========================"
      severity note;

    ----------------------------------------------------------------------------
    -- DC motor controls
    ----------------------------------------------------------------------------
    assert false
      report
        lf & lf & lf &
        "===============================" & lf &
        "== Testing DC motor controls   " & lf &
        "==============================="
      severity note;

    joystick_toggleSpeed <= '1';
    wait for 1 us;
    joystick_toggleSpeed <= '0';
    joystick_left <= '1';
    wait for 1 us;
    joystick_left <= '0';
    joystick_right <= '1';
    wait for 1 us;
    joystick_right <= '0';

    ----------------------------------------------------------------------------
    -- Stepper motor controls
    ----------------------------------------------------------------------------
    wait for 1 us;
    assert false
      report
        lf & lf & lf &
        "===========================" & lf &
        "== Testing stepper motor   " & lf &
        "==========================="
      severity note;
                                                   -- write stepper motor period
    joystick_backwards <= '1';
    wait for 1 us;
    joystick_backwards <= '0';
    wait for 4 us;
    joystick_forwards <= '1';
    wait for 1 us;
    joystick_forwards <= '0';
    wait for 4 us;
    testMode <= '0';

    ----------------------------------------------------------------------------
    -- End of simulation
    ----------------------------------------------------------------------------
    wait for 4 sec - now;
    assert false
      report
        lf & lf & lf &
        "=======================" & lf &
        "== End of simulation   " & lf &
        "======================="
      severity failure;

  end process testSequence;

END test_testCircuit;
