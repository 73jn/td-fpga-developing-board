ARCHITECTURE RTL OF controllerRegisters IS

  signal addressDelayed: unsigned(address'range);

  subtype registerType is std_ulogic_vector(data'range);
  type registerArrayType is array(1 to 1) of registerType;
  signal registerSet: registerArrayType;

  constant statusDivideAddr: positive := 15;
  constant statusDivideId: positive := 1;

BEGIN
  ------------------------------------------------------------------------------
                                                                 -- register set
  delayAddress: process(reset, clock)
  begin
    if reset = '1' then
      addressDelayed <= (others => '0');
    elsif rising_edge(clock) then
      addressDelayed <= address;
    end if;
  end process delayAddress;
  ------------------------------------------------------------------------------
                                                                 -- register set
  updateRegisters: process(reset, clock)
  begin
    if reset = '1' then
      registerSet <= (others => (others => '0'));
      registerSet(statusDivideId) <= (others => '1');
    elsif rising_edge(clock) then
      if dataValid = '1' then
        case to_integer(addressDelayed) is
          when statusDivideAddr => registerSet(statusDivideId) <= data;
          when others => null;
        end case;
      end if;
    end if;
  end process updateRegisters;

  statusDivide <= unsigned(registerSet(statusDivideId));

END ARCHITECTURE RTL;
