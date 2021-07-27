--
-- VHDL Architecture Poetic.BLDCController.BLDC
--
-- Created:
--          by - jean.nanchen.UNKNOWN (WEA30407)
--          at - 11:42:58 22.07.2021
--
-- using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
--
ARCHITECTURE BLDC OF BLDCController IS
BEGIN
  process (clock, reset)
  begin
    if reset = '1' then
    elsif rising_edge(clock) then
    end if;
  end process;
  
  logic : process (Hall_A, Hall_B, Hall_C)
  variable hallReg : std_ulogic_vector(2 DOWNTO 0);
  begin
    hallReg := Hall_A & Hall_B & Hall_C;
    case hallReg is
      when "001" => --Sa_top 1 & Sb_bot 1
        Sa_top <= PWM_in;
        Sa_bot <= '0';
        Sb_top <= '0';
        Sb_bot <= PWM_in;
        Sc_top <= '0';
        Sc_bot <= '0';
      when "101" => --Sa_top 1 & Sc_bot 1
        Sa_top <= PWM_in;
        Sa_bot <= '0';
        Sb_top <= '0';
        Sb_bot <= '0';
        Sc_top <= '0';
        Sc_bot <= PWM_in;
      when "100" =>
        Sa_top <= '0';
        Sa_bot <= '0';
        Sb_top <= PWM_in;
        Sb_bot <= '0';
        Sc_top <= '0';
        Sc_bot <= PWM_in;
      when "110" =>
        Sa_top <= '0';
        Sa_bot <= PWM_in;
        Sb_top <= PWM_in;
        Sb_bot <= '0';
        Sc_top <= '0';
        Sc_bot <= '0';
      when "010" =>
        Sa_top <= '0';
        Sa_bot <= PWM_in;
        Sb_top <= '0';
        Sb_bot <= '0';
        Sc_top <= PWM_in;
        Sc_bot <= '0';      
      when "011" =>
        Sa_top <= '0';
        Sa_bot <= '0';
        Sb_top <= '0';
        Sb_bot <= PWM_in;
        Sc_top <= PWM_in;
        Sc_bot <= '0'; 
      when others =>
        Sa_top <= '0';
        Sa_bot <= '0';
        Sb_top <= '0';
        Sb_bot <= '0';
        Sc_top <= '0';
        Sc_bot <= '0'; 
    end case;
  end process logic;
END ARCHITECTURE BLDC;