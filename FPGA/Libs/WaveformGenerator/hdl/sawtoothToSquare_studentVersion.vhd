ARCHITECTURE studentVersion OF sawtoothToSquare IS
BEGIN
  invert: process(sawtooth)
  begin
    if sawtooth(sawtooth'high) = '0' then
      square <= (others => '1');
    else
      square <= (others => '0');
    end if;
  end process invert;
END ARCHITECTURE studentVersion;