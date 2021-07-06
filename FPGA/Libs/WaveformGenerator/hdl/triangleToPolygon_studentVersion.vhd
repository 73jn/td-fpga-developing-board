ARCHITECTURE studentVersion OF triangleToPolygon IS
  signal temp : unsigned (triangle'high + 1 downto 0);
  signal temp2 : unsigned (triangle'high + 1 downto 0);
  signal topLimit : unsigned (triangle'high + 1 downto 0);
  signal botLimit : unsigned (triangle'high + 1 downto 0);
  signal allOn : unsigned (triangle'high + 1 downto 0);
BEGIN
  allOn <= (others => '1');
  botLimit <= shift_right(allOn, 3); --On divise par 8
  topLimit <= shift_right(allOn, 3) + shift_right(allOn, 1);
  temp <= resize(triangle,temp'length) + shift_right(triangle,1);
  topolygon: process(temp)
  begin
	if temp < botLimit then
	  temp2 <= botLimit;
	elsif temp > topLimit then
	  temp2 <= topLimit;
	else
	  temp2 <= temp;
	end if;
  end process topolygon;
  polygon <= resize(temp2-botLimit, triangle'length);
END ARCHITECTURE studentVersion;