--
-- VHDL Architecture Poetic.Converter.BinaryToAsci
--
-- Created:
--          by - jeann.UNKNOWN (DESKTOP-V46KISN)
--          at - 11:25:06 13.07.2021
--
-- using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
--
ARCHITECTURE BinaryToAsci OF Converter IS
  type decodeState is (
    waitForTriggerDataIn, howManyDigit, separateDigit, sendCharacter
  );
  signal mainState : decodeState;
  signal memInBinary : unsigned (adcBitNb-1 DOWNTO 0);
BEGIN
  converter: process(reset, clock)
    variable digitCounter : integer;
    variable decBaseComp : integer;
    variable decSeparate : integer;
    variable memDecSeparate : integer;
    variable separateCounter : integer;
    variable counterDec : integer;
  begin
    if reset = '1' then
      mainState <= waitForTriggerDataIn;
      digitCounter := 1;
      decBaseComp := 10;
      decSeparate := 1;
      separateCounter := 0;
      memDecSeparate := 1;
      counterDec := 0;
      memInBinary <= (others => '0');
    elsif rising_edge(clock) then
      case mainState is 
        when waitForTriggerDataIn =>
          if InTrigger = '1' then
            memInBinary <= unsigned(InBinary);
            mainState <= howManyDigit;
          end if;
        when howManyDigit =>
          if memInBinary < decBaseComp then
            mainState <= separateDigit;
          else
            decBaseComp <= decBaseComp * 10;
            digitCounter := digitCounter + 1;
          end if;
        when separateDigit =>
          if separateCounter < digitCounter then
            separateCounter := separateCounter + 1;
            decSeparate := decSeparate * 10;   
            memDecSeparate := decSeparate;
          else -- separateCounter >= digitCounter
            if InBinary - memDecSeparate < decSeparate
              mainState <= sendCharacter;
            else
              memDecSeparate := memDecSeparate + decSeparate;
              counterDec := counterDec + 1;
            end if;
          end if;
        when sendCharacter =>
          case counterDec is
            when 0 => outAscii := outAscii;
            when 2 => uOutput := (uOutput + 1) * 10;
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
      end case;
    end if;
  end process converter;
END ARCHITECTURE BinaryToAsci;

