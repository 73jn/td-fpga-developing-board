ARCHITECTURE RTL OF txRegisters IS

  subtype registerType is std_ulogic_vector(regTxData'range);
  type registerArrayType is array(2**regTxAddr'length-1 downto 0) of registerType;
  signal registerSet: registerArrayType;

BEGIN
  ------------------------------------------------------------------------------
                                                                 -- register set
  updateRegisters: process(reset, clock)
  begin
--    if reset = '1' then
--      registerSet <= (others => (others => '0'));
--    elsif rising_edge(clock) then
    if rising_edge(clock) then
      if updateTxReg = '1' then
        registerSet(to_integer(regTxAddr)) <= regTxData;
      end if;
    end if;
  end process updateRegisters;

  ------------------------------------------------------------------------------
                                                  -- readback register for RS232
--  regRxData <= registerSet(to_integer(txAddr));

  readRegisters: process(reset, clock)
  begin
    if reset = '1' then
      regRxData <= (others => '0');
    elsif rising_edge(clock) then
      regRxData <= registerSet(to_integer(txAddr));
    end if;
  end process readRegisters;

END ARCHITECTURE RTL;
