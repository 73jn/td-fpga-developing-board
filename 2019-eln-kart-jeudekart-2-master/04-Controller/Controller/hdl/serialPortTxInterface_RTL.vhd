library Common;
  use Common.CommonLib.all;

ARCHITECTURE RTL OF serialPortTxInterface IS

  constant registerStart : natural := 0;
  constant registerStop : natural := 15;
  signal registerCounter: unsigned(requiredBitNb(registerStop-1)-1 downto 0);

  constant writeStepNb: positive := 5;
  constant writeSequenceLength: positive := writeStepNb*(registerStop-registerStart+1);
  constant maxSequenceLength  : positive := writeSequenceLength;
  signal sequenceCounter: unsigned(requiredBitNb(maxSequenceLength)-1 downto 0);
  signal writeItemCounter: unsigned(requiredBitNb(writeStepNb)-1 downto 0);

BEGIN
  ------------------------------------------------------------------------------
                                                 -- count read or write sequence
  countSequence: process(reset, clock)
  begin
    if reset = '1' then
      sequenceCounter <= (others => '0');
      writeItemCounter <= (others => '0');
    elsif rising_edge(clock) then
      if sequenceCounter = 0 then
        if sendStatus = '1' then
          sequenceCounter <= sequenceCounter + 1;
        end if;
        writeItemCounter <= (others => '0');
      else
        if txFull = '0' then
          if sequenceCounter >= writeSequenceLength then
            sequenceCounter <= (others => '0');
          else
            sequenceCounter <= sequenceCounter + 1;
            if writeItemCounter < writeStepNb-1 then
              writeItemCounter <= writeItemCounter + 1;
            else
              writeItemCounter <= (others => '0');
            end if;
          end if;
        end if;
      end if;
    end if;
  end process countSequence;

  ------------------------------------------------------------------------------
                                                            -- count register id
  countRegisters: process(reset, clock)
  begin
    if reset = '1' then
      registerCounter <= (others => '0');
    elsif rising_edge(clock) then
      if sequenceCounter = 0 then
        registerCounter <= to_unsigned(registerStart, registerCounter'length);
      elsif writeItemCounter = writeStepNb-1 then
        if txFull = '0' then
          registerCounter <= registerCounter + 1;
        end if;
      end if;
    end if;
  end process countRegisters;

  registerAddress <= resize(registerCounter, registerAddress'length);

  ------------------------------------------------------------------------------
                                                              -- control outputs
  driveOutputs: process(
    sequenceCounter, registerCounter, writeItemCounter,
    busDataIn,
    txFull
  )
  begin
                                                             -- default values
    txData <= (others => '0');
    txWr <= '0';
                                                             -- write sequence
    if sequenceCounter > 0 then
      txWr <= not txFull;
      case to_integer(writeItemCounter) is
        when 0 =>
          txData <= X"55";
        when 1 =>
          txData <= std_ulogic_vector(
            resize(registerCounter, txData'length)
          );
        when 2 =>
          txData <= busDataIn(busDataIn'high downto busDataIn'high - txData 'length + 1);
        when 3 =>
          txData <= busDataIn(txData'range);
        when 4 =>
          txData <= X"AA";
        when others => null;
      end case;
    end if;
  end process driveOutputs;

END ARCHITECTURE RTL;

