library Common;
  use Common.CommonLib.all;

ARCHITECTURE RTL OF sequenceController IS

  constant commandNoOperation: natural := 0;
  constant commandSetSpeed   : natural := 1;
  constant commandSetAngle   : natural := 2;
  constant commandDriveLEDs  : natural := 3;
  constant commandSetLEDs    : natural := 4;
  constant commandClearLEDs  : natural := 5;
  constant commandRunDistance: natural := 8;
  constant commandRunFor     : natural := 9;
  constant commandRegisterOp : natural := 13;
  constant   registerOpSet   : natural := 0;
  constant   registerOpAdd   : natural := 2;
  constant   registerOpSub   : natural := 3;
  constant commandEnd        : natural := 15;
                                                                    -- registers
  constant registerSpeedId: natural := 1;
  constant registerAngleId: natural := 3;
  constant registerLedsId: natural := 6;
  signal speedReg: signed(rxData'range);
  signal angleReg: signed(rxData'range);
  signal ledsReg: signed(rxData'range);
                                                        -- delay for new command
  signal newCommandCounter: unsigned(1 downto 0);
  signal act_delayed, newCommand: std_ulogic;
                                                                 -- done control
  signal done_int: std_ulogic;
                                                                        -- timer
  signal csCounter: unsigned(requiredBitNb(clockToHectoHzCount)-1 downto 0);
  signal csEn: std_ulogic;
  signal timerCounter: unsigned(argument'range);
                                                                     -- register
  signal registerOperation: unsigned(1 downto 0);
  signal registerOperand: unsigned(argument'high-registerOperation'length downto 0);
  signal sequenceRegister: unsigned(registerOperand'range);

BEGIN
  ------------------------------------------------------------------------------
                                                                    -- sequencer
  updateRegisters: process(reset, clock)
  begin
    if reset = '1' then
      speedReg <= (others => '0');
      angleReg <= (others => '0');
      ledsReg <= (others => '0');
    elsif rising_edge(clock) then
      if act = '1' then
        case to_integer(command) is
          when commandSetSpeed =>
            speedReg <= resize(signed(argument), speedReg'length);
          when commandSetAngle =>
            angleReg <= resize(signed(argument), angleReg'length);
          when commandDriveLEDs =>
            ledsReg <= resize(signed(argument), ledsReg'length);
          when commandSetLeds =>
            ledsReg <= ledsReg or resize(signed(argument), ledsReg'length);
          when commandClearLeds =>
            ledsReg <= ledsReg and not(resize(signed(argument), ledsReg'length));
          when others => null;
        end case;
      end if;
    end if;
  end process updateRegisters;
                                       -- delay act command for rising detection
  delayAct: process(reset, clock)
  begin
    if reset = '1' then
      act_delayed <= '0';
    elsif rising_edge(clock) then
      act_delayed <= act;
    end if;
  end process delayAct;
                               -- count waiting time until new command available
  countNewCommandDelay: process(reset, clock)
  begin
    if reset = '1' then
      newCommandCounter <= (others => '0');
    elsif rising_edge(clock) then
      if newCommandCounter = 0 then
        if act = '1' then
          if (act = '1' and act_delayed = '0') or (done_int = '1') then
            newCommandCounter <= newCommandCounter + 1;
          end if;
        end if;
      else
        newCommandCounter <= newCommandCounter + 1;
      end if;
    end if;
  end process countNewCommandDelay;
            -- assert new command at beginning of sequence or after command done
  newCommand <= '1' when newCommandCounter+1 = 0
    else '0';
                                     -- provide end condition for each step type
  findEndOfStep: process(reset, clock)
  begin
    if reset = '1' then
      done_int <= '0';
    elsif rising_edge(clock) then
      done_int <= '0';
      case to_integer(command) is
        when commandRunFor =>
          if timerCounter = argument then
            done_int <= '1';
          end if;
        when commandRunDistance =>
          if motorPosition >= argument then
            done_int <= '1';
          end if;
        when commandEnd =>
          done_int <= '0';
        when others => 
          if newCommandCounter+1 = 0 then
            done_int <= '1';
          end if;
      end case;
    end if;
  end process findEndOfStep;

  done <= done_int when newCommandCounter = 0
    else '0';
  positionStart <= newCommand;

  ------------------------------------------------------------------------------
                                                        -- divide clock to 10 ms
  divideToCentiherz : process(reset, clock)
  begin
    if reset = '1' then
      csCounter <= (others => '0');
    elsif rising_edge(clock) then
      if csCounter < clockToHectoHzCount then
        csCounter <= csCounter + 1;
      else
        csCounter <= (others => '0');
      end if;
    end if;
  end process divideToCentiherz;

  csEn <= '1' when csCounter = 0
    else '0';
                                                               -- sequence timer
  runTimer: process(reset, clock)
  begin
    if reset = '1' then
      timerCounter <= (others => '0');
    elsif rising_edge(clock) then
      if act = '0' then
        timerCounter <= (others => '0');
      elsif done_int = '1' then
        timerCounter <= (others => '0');
      elsif csEn = '1' then
        timerCounter <= timerCounter + 1;
      end if;
    end if;
  end process runTimer;

  ------------------------------------------------------------------------------
                                                           -- sequencer register
  registerOperation <= resize(
    shift_right(argument, argument'length - registerOperation'length),
    registerOperation'length
  );
  registerOperand <= resize(argument, registerOperand'length);

  updateRegister: process(reset, clock)
  begin
    if reset = '1' then
      sequenceRegister <= (others => '1');
    elsif rising_edge(clock) then
      if (command = commandRegisterOp) and (newCommand = '1') then
        case to_integer(registerOperation) is
          when registerOpSet =>
            sequenceRegister <= registerOperand;
          when registerOpAdd =>
            sequenceRegister <= sequenceRegister + registerOperand;
          when registerOpSub =>
            sequenceRegister <= sequenceRegister - registerOperand;
          when others => null;
        end case;
      end if;
    end if;
  end process updateRegister;

  flagZero <= '1' when sequenceRegister = 0
    else '0';

  ------------------------------------------------------------------------------
                                                        -- multiplex data to I2C
  selectRxData: process(
    act, rxAddress, registerData,
    speedReg, angleReg, ledsReg
  )
  begin
    if act = '0' then
      rxData <= registerData;
    else
      rxData <= registerData;
      case to_integer(rxAddress) is
        when registerSpeedId => rxData <= std_ulogic_vector(speedReg);
        when registerAngleId => rxData <= std_ulogic_vector(angleReg);
        when registerLedsId => rxData <= std_ulogic_vector(ledsReg);
        when others => null;
      end case;
    end if;
  end process selectRxData;

END ARCHITECTURE RTL;
