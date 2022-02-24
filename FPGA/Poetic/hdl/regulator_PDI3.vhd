--
-- VHDL Architecture Poetic.regulator.PDI3
--
-- Created:
--          by - jean.nanchen.UNKNOWN (WEA30407)
--          at - 20:04:32 22.07.2021
--
-- using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
--
ARCHITECTURE PDI3 OF regulator IS
  type State is (
    ready, calculateNewError,calculatePID, checkOverFlow, print
  );
  constant Kp : integer := 4;
  constant Ki : integer := 3;
  signal mainState : State;
  signal updatePID : std_ulogic;
  signal PIDHasBeenUpdate : std_ulogic;
  signal error : signed(pidBitNb DOWNTO 0);
  signal error_sum : signed(pidBitNb+20 DOWNTO 0); --BIG NUMBER
  signal pidValue : signed(pidBitNb+5+1 DOWNTO 0);
  signal p : signed(pidBitNb+5 DOWNTO 0);
  signal i : signed(pidBitNb+5 DOWNTO 0);
  signal d : signed(pidBitNb+5 DOWNTO 0);
  signal sOutput : unsigned(pidBitNb-1 DOWNTO 0);
BEGIN
  process (clock, reset)
  begin
    if reset = '1' then
      output <= (others => '0');
      mainState <= ready;
      error <= (others => '0');
      p <= (others => '0');
      i <= (others => '0');
      d <= (others => '0');
      pidValue <= (others => '0');
      sOutput <= (others => '0');
      PIDHasBeenUpdate <= '0';
      error_sum <= (others => '0');
    elsif rising_edge(clock) then
      case mainState is 
        when ready =>
          mainState <= calculateNewError;
        when calculateNewError =>
          error <= signed(resize(unsigned(Setval), error'length)) - signed(resize(unsigned(adc_data), error'length));
          if updatePID = '1' AND ki_sw = '1' then
            error_sum <= error_sum + error;
            PIDHasBeenUpdate <= '1';
          else
            PIDHasBeenUpdate <= '0';
          end if;
          mainState <= calculatePID;
        when calculatePID =>
          if kp_sw = '1' then
            p <= resize(Kp * error, p'length);
          end if;
          if ki_sw = '1' then
            i <= resize(Ki*shift_right(error_sum,0), i'length);
          end if;
          pidValue <= resize(p, pidValue'length) + resize(i, pidValue'length) + resize(d, pidValue'length);
          mainState <= checkOverFlow;
        when checkOverFlow =>
          if pidValue > 4095 then
            sOutput <= (others => '1');
          elsif pidValue < 0 then
            sOutput <= (others => '0');
          else
            sOutput <= resize(unsigned(pidValue), sOutput'length);
          end if;
          mainState <= print;
        when print => 
          mainState <= ready;
          output <= sOutput;
      end case;
    end if;
  end process;
  
  process (clock, reset)
    variable counter : integer := 0;   
  begin
    if reset = '1' then
      counter := 0;
      updatePID <= '0';
    elsif rising_edge(clock) then
      counter := counter + 1;
      if PIDHasBeenUpdate = '1' then
        updatePID <= '0';
      end if;
      if counter > 100000 then
        updatePID <= '1';
        counter := 0;
      end if;
    end if;
  end process;
END ARCHITECTURE PDI3;

