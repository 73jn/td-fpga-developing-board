ARCHITECTURE studentVersion OF lowpass IS
  signal acc : unsigned (lowpassIn'high + shiftBitNb downto 0);
BEGIN
  lowp: process(reset, clock)
  begin
  if reset = '1' then
    acc <= (others => '0');
  elsif rising_edge(clock) then
    acc <= acc + lowpassIn  - shift_right(acc, shiftBitNb);
  end if;
  end process lowp;
    lowpassOut <= resize(shift_right(acc,shiftBitNb),lowpassOut'length);
END ARCHITECTURE studentVersion;