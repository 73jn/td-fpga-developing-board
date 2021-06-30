--
-- VHDL Architecture Poetic.ADC.ads7886_decoder
--
-- Created:
--          by - jeann.UNKNOWN (DESKTOP-V46KISN)
--          at - 14:09:37 17.06.2021
--
-- using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
--
ARCHITECTURE ads7886_decoder OF ADC IS
  type decodeState is (
    sendLowCS, waitForData, readData, sendHighCS, ready
  );
  signal mainState : decodeState;
  signal memSCLK, risingSCLK : std_ulogic;
  signal counterWaitData : unsigned(1 DOWNTO 0);
  signal counterReadData : unsigned(10 DOWNTO 0);
  signal dataReg : unsigned(adcBitNb-1 DOWNTO 0);
BEGIN
  decode : process(reset, clock)
  begin
    if reset = '1' then
      mainState <= ready;
      Data <= (others => '0');
      CS_n <= '1';
      counterReadData <= (others => '0');
      counterWaitData <= (others => '0');
      dataReg <= (others => '0');
    elsif rising_edge(clock) then
      case mainState is 
        when ready =>
          if enable = '1' AND risingSCLK = '1' then
            mainState <= sendLowCS;
          end if;
        when sendLowCS =>
          CS_n <= '0';
          mainState <= waitForData;
        when waitForData =>
          if risingSCLK = '1' then
            counterWaitData <= counterWaitData +1;
            if counterWaitData = 2 then
              mainState <= readData;
              counterWaitData <= (others => '0');
            end if;
          end if;
        when readData =>
          if risingSCLK = '1' then
            counterReadData <= counterReadData + 1;
            dataReg <= shift_left(dataReg, 1);
            dataReg(dataReg'low) <= SDO;
            if (counterReadData = adcBitNb) then
              mainState <= sendHighCS;
            end if;
          end if;
        when sendHighCS =>
            if risingSCLK = '1' then
              CS_n <= '1';
              mainState <= ready;
            end if;
      end case;
    end if;
  end process decode;
  
  detectRisingSCLK : process (reset, clock)
  begin
    if reset = '1' then
      memSCLK <= '0';
      risingSCLK <= '0';
    elsif rising_edge(clock) then
      risingSCLK <= '0';
      if memSCLK = '0' AND SCLK = '1' then
        risingSCLK <= '1';
        memSCLK <= SCLK;
      else
        memSCLK <= SCLK;
      end if;
    end if;
  end process detectRisingSCLK;
  
  
END ARCHITECTURE ads7886_decoder;

