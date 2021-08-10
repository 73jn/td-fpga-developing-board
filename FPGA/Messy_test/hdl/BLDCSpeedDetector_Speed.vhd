--
-- VHDL Architecture Poetic_test.BLDCSpeedDetector.Speed
--
-- Created:
--          by - jean.nanchen.UNKNOWN (WEA30407)
--          at - 16:19:26 23.07.2021
--
-- using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
--
ARCHITECTURE Speed OF BLDCSpeedDetector IS
  type State is (
    count, print, setToZero
  );
  signal mainState : State;
  signal bigCounter : unsigned(26 DOWNTO 0);
  signal hallReg : std_ulogic_vector(2 DOWNTO 0);
  signal oneSecondPassed : std_ulogic;
  signal rotationHappen : std_ulogic;
  signal old_hallReg : std_ulogic_vector(2 DOWNTO 0);
BEGIN
  process (clock, reset)
    variable bigCounter : integer;
  begin
    if reset = '1' then
      bigCounter := 0;
      oneSecondPassed <= '0';
    elsif rising_edge(clock) then
	    bigCounter := bigCounter + 1;
      if (bigCounter > 10000000) then
        bigCounter := 0;
        oneSecondPassed <= '1';
      else
        oneSecondPassed <= '0';
      end if;
    end if;
  end process;
  countNumberOfRotationPerSecond : process (clock, reset)
    variable rotationCounter : integer;
  begin
    if reset = '1' then
      rotationCounter := 0;
      mainState <= count;
      speed <= (others => '0');
    elsif rising_edge(clock) then
      case mainState is 
        when count =>
          if oneSecondPassed = '1' then
            mainState <= print;
          end if;
          if rotationHappen = '1' then
            rotationCounter := rotationCounter + 1;
          end if;
        when print =>
          speed <= std_logic_vector(10*to_unsigned(rotationCounter, speed'length)); -- * 10 pour tr/secondes
          mainState <= setToZero;
        when setToZero =>
          rotationCounter := 0;
          mainState <= count;
      end case;
    end if;
  end process countNumberOfRotationPerSecond;
  
  mecRotationDetect : process (reset, clock)
  begin
    if reset = '1' then
      rotationHappen <= '0';
    elsif rising_edge(clock) then
      if old_hallReg /= hallReg then
        old_hallReg <= hallReg;
        if hallReg = "001" then
          rotationHappen <= '1';
        else
          rotationHappen <= '0';
        end if;
      else
        rotationHappen <= '0';
      end if;
      
    end if;
  end process mecRotationDetect;

  updateHallReg : process (Hall_A, Hall_B, Hall_C)
  begin
    hallReg <= Hall_A & Hall_B & Hall_C;
  end process updateHallReg;
END ARCHITECTURE Speed;

