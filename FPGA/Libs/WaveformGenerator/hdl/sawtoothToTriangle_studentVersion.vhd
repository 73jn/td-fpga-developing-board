ARCHITECTURE studentVersion OF sawtoothToTriangle IS
 signal temp : unsigned(sawtooth'range);
BEGIN
  invert: process(sawtooth)
  begin
  if sawtooth(sawtooth'high) = '0' then
    temp <= sawtooth;
  else
    temp <= not sawtooth;
  end if;
  end process invert;
  triangle <= temp sll 1;
END ARCHITECTURE studentVersion;