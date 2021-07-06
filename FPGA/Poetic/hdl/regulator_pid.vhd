--
-- VHDL Architecture Poetic.regulator.pid
--
-- Created:
--          by - jeann.UNKNOWN (DESKTOP-V46KISN)
--          at - 09:38:18 25.06.2021
--
-- using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
--
ARCHITECTURE pid OF regulator IS
	CONSTANT con_Kp : INTEGER := 10; --proportional constant
	CONSTANT con_kp_den : INTEGER := 1;
	CONSTANT con_Kd : INTEGER := 1; --differential constant
	CONSTANT con_kd_den : INTEGER := 1;
	CONSTANT con_Ki : INTEGER := 20; --integral constant
	CONSTANT con_ki_den : INTEGER := 1;
	SIGNAL Error, Error_difference, error_sum, old_error, old_old_error : INTEGER := 0; --store values for controller
	SIGNAL p, i, d : INTEGER := 0; --Contain the proportional, derivative and integral errors respectively
	SIGNAL output_loaded, output_saturation_buffer : INTEGER := 0; --allows to check if output is within range
	SIGNAL old_adc : std_logic_vector(11 DOWNTO 0); --stores old adc value
  SIGNAL old_SetVal : std_ulogic_vector(11 DOWNTO 0);
  signal memUpdate, risingUpdate : std_ulogic;
  signal newError : std_ulogic;
	CONSTANT divider_for_time : INTEGER := 100; --stores the time in which the controller acts over example a value of 100 would be equalt to 10ms so 1/divider_for_time = sampling_period
BEGIN
  process (clock, reset)
  begin
    if reset = '1' then
      output <= (others => '0');
      Error <= 0;
      Error_difference <= 0;
      error_sum <= 0;
      old_error <= 0;
      p <= 0;
      i <= 0;
      d <= 0;
      output_loaded <= 0;
      output_saturation_buffer <= 0;
      old_adc <= (others => '0');
      old_old_error <= 0;
    elsif rising_edge(clock) then
      FOR k IN 0 TO 9 LOOP --for loop to run through case statement
        CASE k IS
          WHEN 0 => Error <= (to_integer(unsigned(SetVal)) - to_integer(unsigned(ADC_data))); --calculates error between sensor and reference
          WHEN 1 => --IF adc_data /= old_adc THEN --calculate integral and derivative term
                    IF risingUpdate = '1' then
                      error_sum <= error_sum + error;
                      error_difference <= error - old_error;
                    END IF;
                    --IF SetVal /= old_SetVal THEN
                      --old_SetVal <= SetVal;
                      --error_difference <= 0;
                      --error_sum <= 0;
                    --END IF;
          WHEN 2 => IF kp_sw = '1' THEN   --calculate p term if desired
                          p <= (con_Kp * error)/con_kp_den;
                        ELSE
                          p <= 0;
                        END IF;
          WHEN 3 => IF ki_sw = '1' THEN --calculate i term if desired
                            i <= (con_Ki * error_sum)/(divider_for_time * con_ki_den);
                          ELSE 
                            i <= 0;
                          END IF;
          WHEN 4 => IF kd_sw = '1' THEN  --calculate d term if desired
                              d <= ((con_Kd * error_difference) * divider_for_time)/con_kd_den;
                            ELSE 
                              d <= 0;
                            END IF;
          WHEN 5 => output_saturation_buffer <= (p + i + d); --calculate output of controller
          WHEN 6 => IF output_saturation_buffer < 0 THEN --checks if output within certain range
                              output_loaded <= 0;
                              ELSIF output_saturation_buffer > 4095 THEN
                                  output_loaded <= 4095;
                              ELSE
                                output_loaded <= output_saturation_buffer;
                              END IF;
          WHEN 7 => output <= to_unsigned(output_loaded, 12); --converts to std_logic_vector which can be output to DAC or input to PWM code
          WHEN 8 => old_adc <= adc_data; --storing old adc
          WHEN 9 => newError <= '0';
                    if error /= old_error  then
                      newError <= '1';
                    end if;
                    if newError <= '1' then
                      old_old_error <= error; --storing old error for derivative term
                    end if;
                    if old_old_error /= error then
                      old_error <= old_old_error;
                    end if;
          WHEN OTHERS => NULL;
        END CASE;
      END LOOP;
    end if;
  end process;
  
  detectRisingUpdate : process (reset, clock)
  begin
    if reset = '1' then
      memUpdate <= '0';
      risingUpdate <= '0';
    elsif rising_edge(clock) then
      risingUpdate <= '0';
      if memUpdate = '0' AND update = '1' then
        risingUpdate <= '1';
        memUpdate <= update;
      else
        memUpdate <= update;
      end if;
    end if;
  end process detectRisingUpdate;
END ARCHITECTURE pid;

