--
-- VHDL Architecture Poetic.serialAsciiDecoder.serialAsciiDecoder
--
-- Created:
--          by - jeann.UNKNOWN (DESKTOP-V46KISN)
--          at - 10:55:13 29.06.2021
--
-- using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
--
ARCHITECTURE serialAsciiDecoder OF serialAsciiDecoder IS
  type decodeState is (
    isReceiving, endOfReceive, ready, print, increment, incrementAdder
  );
  signal mainState : decodeState;
  type t_Memory is array (0 to 11) of std_ulogic_vector(7 downto 0);
  signal r_Mem : t_Memory;
BEGIN
  decode : process(reset, clock)
    variable counterCharacter : integer;
    variable counterAdder : integer;
	variable uOutput : integer;
  begin
    if reset = '1' then
      uOutput := 3232;
      output <= (others => '1');
      mainState <= ready;
      counterCharacter := 0;
      counterAdder := 0;
      for i in 0 to 11 loop
        r_Mem(i) <= (others => '0');
      end loop;
    elsif rising_edge(clock) then
      case mainState is 
        when ready =>
		  uOutput := 0;
          if newCharacter = '1' then
            mainState <= isReceiving;
          end if;
        when isReceiving =>
          if endOfMsg = '1' then
            mainState <= endOfReceive;
          end if;
          if newCharacter = '1' then
            mainState <= increment;
            r_Mem(counterCharacter) <= consigne;
          end if;
        when increment =>
          counterCharacter := counterCharacter + 1;
          mainState <= isReceiving;
        when endOfReceive =>
          if counterAdder = counterCharacter then
            mainState <= print;
          else
            r_Mem(counterAdder) <= (others => '0');
            mainState <= incrementAdder;
			if counterAdder /= counterCharacter - 1 then
				case r_Mem(counterAdder) is
				  when X"30" => uOutput := uOutput * 10;
				  when X"31" => uOutput := (uOutput + 1) * 10;
				  when X"32" => uOutput := (uOutput + 2) * 10;
				  when X"33" => uOutput := (uOutput + 3) * 10;
				  when X"34" => uOutput := (uOutput + 4) * 10;
				  when X"35" => uOutput := (uOutput + 5) * 10;
				  when X"36" => uOutput := (uOutput + 6) * 10;
				  when X"37" => uOutput := (uOutput + 7) * 10;
				  when X"38" => uOutput := (uOutput + 8) * 10;
				  when X"39" => uOutput := (uOutput + 9) * 10;
				  when others =>
				end case;
			else
				case r_Mem(counterAdder) is
				  when X"30" => uOutput := uOutput;
				  when X"31" => uOutput := (uOutput + 1);
				  when X"32" => uOutput := (uOutput + 2);
				  when X"33" => uOutput := (uOutput + 3);
				  when X"34" => uOutput := (uOutput + 4);
				  when X"35" => uOutput := (uOutput + 5);
				  when X"36" => uOutput := (uOutput + 6);
				  when X"37" => uOutput := (uOutput + 7);
				  when X"38" => uOutput := (uOutput + 8);
				  when X"39" => uOutput := (uOutput + 9);
				  when others =>
				end case;
			end if;
          end if;
        when incrementAdder =>
          counterAdder := counterAdder + 1;
          mainState <= endOfReceive;
        when print =>
          output <= std_ulogic_vector(to_unsigned(uOutput, output'length));
          counterCharacter := 0;
          counterAdder := 0;
          mainState <= ready;
      end case;
    end if;
  end process decode;
END ARCHITECTURE serialAsciiDecoder;

