--
-- VHDL Architecture Poetic_test.motor.dc
--
-- Created:
--          by - jeann.UNKNOWN (DESKTOP-V46KISN)
--          at - 14:32:12 01.07.2021
--
-- using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
--
ARCHITECTURE dc OF motor IS
  constant clockFrequency: real := 100.0E03;
  constant clockPeriod: real := (1.0/clockFrequency);
  constant L : real := 0.1;
  constant Kphi : real := 0.2;
  constant J : real := 0.1;
  constant B : real := 0.1;
  constant R : real := 1.6;
BEGIN
  decode : process(reset, clock)
    variable di_dt : real;
    variable dw_dt : real;
    variable w : real;
    variable i : real;
  begin
    if reset = '1' then
      di_dt := 0.0;
      dw_dt := 0.0;
      i := 0.0;
      w := 0.0;
      speed <= (others => '0');
    elsif rising_edge(clock) then
      di_dt := (real(to_integer(Vapp))/L) - ((R/L) * i) - ((Kphi/L)*w);
      dw_dt := ((Kphi/J) * i) - ((B/J) * w);
      w := w + dw_dt * clockPeriod;
      i := i + di_dt * clockPeriod;
      speed <= std_logic_vector(to_unsigned(integer(w), speed'length));
    end if;
  end process decode;
END ARCHITECTURE dc;

