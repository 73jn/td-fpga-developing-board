ARCHITECTURE RTL OF sequenceStatus IS

  constant statusRegisterId: natural := 7;
  constant statusRunningId: natural := 0;
  signal statusRegister: unsigned(regTxDataOut'range);

  constant position1RegisterId: natural := 0;
  constant position2RegisterId: natural := 1;
  signal position1Start, position2Start: unsigned(regTxDataIn'range);
  signal position1Actual, position2Actual: unsigned(regTxDataIn'range);

BEGIN
  ------------------------------------------------------------------------------
                                                        -- build status register
  buildStatusRegister: process(command, running)
  begin
    statusRegister <= (others => '0');
    statusRegister(
      statusRegister'high downto statusRegister'high-command'length+1
    ) <= command;
    statusRegister(statusRunningId) <= running;
  end process buildStatusRegister;

  ------------------------------------------------------------------------------
                           -- store positions at start command and at new values
  storePositions: process(reset, clock)
  begin
    if reset = '1' then
      position1Start <= (others => '0');
      position2Start <= (others => '0');
      position1Actual <= (others => '0');
      position2Actual <= (others => '0');
    elsif rising_edge(clock) then
      if positionStart = '1' then
        position1Start <= position1Actual;
        position2Start <= position2Actual;
      elsif updateTxReg = '1' then
        if txAddr = position1RegisterId then
          position1Actual <= unsigned(regTxDataIn);
        end if;
        if txAddr = position2RegisterId then
          position2Actual <= unsigned(regTxDataIn);
        end if;
      end if;
    end if;
  end process storePositions;
                                      -- calculate and store distance from start
  calcAndStoreDifference: process(reset, clock)
  begin
    if reset = '1' then
      motorPosition <= (others => '0');
    elsif rising_edge(clock) then
      if positionStart = '1' then
        motorPosition <= (others => '0');
               -- calculate position only after both positions have been updated
      elsif txAddr = position2RegisterId+1 then
        motorPosition <= (
          (position1Actual - position1Start) +
          (position2Actual - position2Start)
        ) / 2;
      end if;
    end if;
  end process calcAndStoreDifference;

  ------------------------------------------------------------------------------
                                                            -- multiplex Tx data
  multiplexData: process(txAddr, regTxDataIn)
  begin
    if txAddr = statusRegisterId then
      regTxDataOut <= std_ulogic_vector(statusRegister);
    else
      regTxDataOut <= regTxDataIn;
    end if;
  end process multiplexData;

END ARCHITECTURE RTL;
