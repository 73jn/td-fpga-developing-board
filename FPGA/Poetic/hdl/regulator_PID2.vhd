--
-- VHDL Architecture Poetic.regulator.PID2
--
-- Created:
--          by - jean.nanchen.UNKNOWN (WEA30407)
--          at - 17:33:17 22.07.2021
--
-- using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
--
ARCHITECTURE PID2 OF regulator IS
  type State is (
    ready, calculateNewError, calculatePID, DivideKg, SOverload, print
  );
  signal mainState : State;
  signal memUpdate, risingUpdate : std_ulogic;
  
  signal Kp : integer := 1;		--proportional constant
  signal Kd : integer := 1;		--differential constant
  signal Ki : integer := 1;		--integral constant
  signal sOutput : integer := 1;	--intermediate output
  signal inter: integer := 0;		--intermediate signal
  signal sAdc : integer := 0 ;	--stores the integer converted value of the ADC input
  signal Error: natural := 0;		--Stores the deviation of the input from the set point
  signal Error_sum : natural := 0;
  signal p,i,d : integer := 0;	--Contain the proportional, derivative and integral errors respectively
BEGIN
  process (clock, reset)
      variable Output_Old : integer := 0;   
      variable Error_Old : natural := 0;
  begin
    if reset = '1' then
      output <= (others => '0');
      mainState <= ready;
    elsif rising_edge(clock) then
      case mainState is 
        when ready =>
          if (risingUpdate = '1') then
            sAdc <= to_integer(unsigned(adc_data));
            Error_Old := Error;  --Capture old error
            Output_Old := sOutput;    --Capture old PID output
            mainState <= calculateNewError;
          end if;
        when calculateNewError => 
          inter <= (to_integer(unsigned(Setval))-sAdc); --Calculate Error
          Error <= to_integer(to_unsigned(inter,32));
          Error_sum <= Error + Error_sum;
          mainState <= calculatePID;
        when calculatePID =>
          p <= Kp*(Error);              --Calculate PID 
          i <= Ki*(Error_sum);
          d <= Kd *(Error-Error_Old);  
          mainState <= DivideKg;
        when DivideKg =>
          mainState <= SOverload;
          sOutput <=  Output_Old+(p+i+d)/65536; --Calculate new output (/65536 to scale the output correctly)
        when SOverload =>
          if sOutput > 4095 then
             sOutput <= 4095 ;
          end if;     
          if sOutput < 1 then 
             sOutput <= 1;
          end if;
          mainState <= print;
        when print =>
          output <= to_unsigned(sOutput,output'length);
          mainState <= ready;
      end case;
    end if;
  end process;
  
  
  detectRisingUpdate : process (reset, clock)
  begin
    if reset = '1' then
      memUpdate <= '0';
      risingUpdate <= '0';
    elsif rising_edge(clock) then
      risingUpdate <= '0';
      if memUpdate = '0' AND update = '1' then
        risingUpdate <= '1';
        memUpdate <= update;
      else
        memUpdate <= update;
      end if;
    end if;
  end process detectRisingUpdate;
END ARCHITECTURE PID2;

