--
-- VHDL Architecture DcMotor.valueAbs.convert
--
-- Created:
--          by - Aurélien.UNKNOWN (DESKTOP-24F3HOD)
--          at - 08:55:00 20.08.2019
--
-- using Mentor Graphics HDL Designer(TM) 2015.2 (Build 5)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
LIBRARY gates;
USE gates.gates.all;

ENTITY valueAbs IS
    PORT( 
        speed    : IN     signed;
        speedAbs : OUT    unsigned (4 DOWNTO 0)
    );

-- Declarations

END valueAbs ;

ARCHITECTURE convert OF valueAbs IS
BEGIN
  speedAbs <= unsigned(abs(speed));
END ARCHITECTURE convert;

