library Common;
  use Common.CommonLib.all;

ARCHITECTURE RTL OF serialPortRxInterface IS

  constant readSequenceLength : positive :=  9;
  signal sequenceCounter: unsigned(requiredBitNb(readSequenceLength+1)-1 downto 0);

BEGIN
  ------------------------------------------------------------------------------
                                                 -- count read or write sequence
  countSequence: process(reset, clock)
  begin
    if reset = '1' then
      sequenceCounter <= (others => '0');
    elsif rising_edge(clock) then
      if sequenceCounter = 0 then
        if rxEmpty = '0' then
          sequenceCounter <= sequenceCounter + 1;
        end if;
      else
        if sequenceCounter = 1 then
          if rxData = X"55" then
            sequenceCounter <= sequenceCounter + 1;
          else
            sequenceCounter <= (others => '0');
          end if;
        elsif sequenceCounter >= readSequenceLength then
          sequenceCounter <= (others => '0');
        elsif sequenceCounter(0) = '0' then
          if rxEmpty = '0' then
            sequenceCounter <= sequenceCounter + 1;
          end if;
        else
          sequenceCounter <= sequenceCounter + 1;
        end if;
      end if;
    end if;
  end process countSequence;

  ------------------------------------------------------------------------------
                                                              -- control outputs
  driveOutputs: process(
    sequenceCounter, rxData,
  )
  begin
                                                             -- default values
    rxRd <= '0';
    addressEn <= '0';
    dataHEn <= '0';
    dataLEn <= '0';
    commandValid <= '0';
    busDataOut <= rxData;
    if sequenceCounter > 0 then
      if sequenceCounter(0) = '1' then
        rxRd <= '1';
      end if;
      case to_integer(sequenceCounter) is
        when 3 => addressEn <= '1';
        when 5 => dataHEn <= '1';
        when 7 => dataLEn <= '1';
        when 9 => commandValid <= '1';
        when others => null;
      end case;
    end if;
  end process driveOutputs;

END ARCHITECTURE RTL;
