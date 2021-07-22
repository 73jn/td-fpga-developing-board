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
  constant Kp : integer := 3;
  signal mainState : State;
  signal updatePID : std_ulogic;
  signal error : signed(pidBitNb DOWNTO 0);
  signal pidValue : signed(pidBitNb+1 DOWNTO 0);
  signal sOutput : unsigned(pidBitNb-1 DOWNTO 0);
BEGIN
  process (clock, reset)
  begin
    if reset = '1' then
      output <= (others => '0');
      mainState <= ready;
      error <= (others => '0');
    elsif rising_edge(clock) then
      case mainState is 
        when ready =>
          mainState <= calculateNewError;
        when calculateNewError =>
          error <= signed(resize(unsigned(Setval) - unsigned(adc_data),error'length));
          mainState <= calculatePID;
        when calculatePID =>
          pidValue <= resize(Kp * error, pidValue'length);
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
      updatePID <= '0';
      if counter > 10000 then
        updatePID <= '1';
        counter := 0;
      end if;
    end if;
  end process;
END ARCHITECTURE PDI3;

