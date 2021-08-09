--
-- VHDL Architecture Poetic_test.AD.ADS7886
--
-- Created:
--          by - jeann.UNKNOWN (DESKTOP-V46KISN)
--          at - 15:32:09 30.06.2021
--
-- using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
--
ARCHITECTURE ADS7886 OF AD IS
  type decodeState is (
    waitHighCS, sendData, sendZeros, waitLowCS, incrementCounterSendData
  );
  signal mainState : decodeState;
  signal memCS, fallingCS : std_ulogic;
  signal memSCLK, fallingSCLK : std_ulogic;
  signal dataReg : unsigned(adcBitNb-1 DOWNTO 0);

BEGIN
  decode : process(reset, clock)
    variable counterWaitData : integer;
    variable counterSendData : integer;
  begin
    if reset = '1' then
      mainState <= waitLowCS;
      counterWaitData := 0;
      counterSendData := 0;
    elsif rising_edge(clock) then
      case mainState is 
        when waitLowCS =>
          if fallingCS = '1' then
            mainState <= sendZeros;
          end if;
        when sendZeros =>
          if fallingSCLK = '1' then
            counterWaitData := counterWaitData + 1;
            SDO <= '0';
            if counterWaitData = 3 then
              mainState <= sendData;
              dataReg <= unsigned(DataToSend);
              counterWaitData := 0;
            end if;
          end if;
        when sendData =>
          if fallingSCLK = '1' then
            if counterSendData >= adcBitNb then
              mainState <= waitHighCS;
              SDO <= '0';
              counterSendData := 0;
            else
              SDO <= dataReg(adcBitNb-1 - counterSendData);
              mainState <= incrementCounterSendData;
            end if;
          end if;
        when incrementCounterSendData =>
          counterSendData := counterSendData + 1;
          mainState <= sendData;
        when waitHighCS =>
          if CS_n = '1' then
            mainState <= waitLowCS;
          end if;
      end case;
    end if;
  end process decode;
  
  detectFallingCS : process (reset, clock)
  begin
    if reset = '1' then
      memCS <= '1';
      fallingCS <= '0';
    elsif rising_edge(clock) then
      fallingCS <= '0';
      if memCS = '1' AND CS_n = '0' then
        fallingCS <= '1';
        memCS <= CS_n;
      else
        memCS <= CS_n;
      end if;
    end if;
  end process detectFallingCS;
  detectFallingSCLK : process (reset, clock)
  begin
    if reset = '1' then
      memSCLK <= '0';
      fallingSCLK <= '0';
    elsif rising_edge(clock) then
      fallingSCLK <= '0';
      if memSCLK = '1' AND SCLK = '0' then
        fallingSCLK <= '1';
        memSCLK <= SCLK;
      else
        memSCLK <= SCLK;
      end if;
    end if;
  end process detectFallingSCLK;
END ARCHITECTURE ADS7886;

