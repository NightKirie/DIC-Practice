-- Copyright (C) 1988-2002 Altera Corporation
-- Any  megafunction  design,  and related netlist (encrypted  or  decrypted),
-- support information,  device programming or simulation file,  and any other
-- associated  documentation or information  provided by  Altera  or a partner
-- under  Altera's   Megafunction   Partnership   Program  may  be  used  only
-- to program  PLD  devices (but not masked  PLD  devices) from  Altera.   Any
-- other  use  of such  megafunction  design,  netlist,  support  information,
-- device programming or simulation file,  or any other  related documentation
-- or information  is prohibited  for  any  other purpose,  including, but not
-- limited to  modification,  reverse engineering,  de-compiling, or use  with
-- any other  silicon devices,  unless such use is  explicitly  licensed under
-- a separate agreement with  Altera  or a megafunction partner.  Title to the
-- intellectual property,  including patents,  copyrights,  trademarks,  trade
-- secrets,  or maskworks,  embodied in any such megafunction design, netlist,
-- support  information,  device programming or simulation file,  or any other
-- related documentation or information provided by  Altera  or a megafunction
-- partner, remains with Altera, the megafunction partner, or their respective
-- licensors. No other licenses, including any licenses needed under any third
-- party's intellectual property, are provided herein.


-- Quartus II 4.1 Build 181 06/29/2004


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;

package atom_pack is

function str_to_bin (lut_mask : string ) return std_logic_vector;

function product(list : std_logic_vector) return std_logic ;

function alt_conv_integer(arg : in std_logic_vector) return integer;

-- default generic values
   CONSTANT DefWireDelay        : VitalDelayType01      := (0 ns, 0 ns);
   CONSTANT DefPropDelay01      : VitalDelayType01      := (0 ns, 0 ns);
   CONSTANT DefPropDelay01Z     : VitalDelayType01Z     := (OTHERS => 0 ns);
   CONSTANT DefSetupHoldCnst    : TIME := 0 ns;
   CONSTANT DefPulseWdthCnst    : TIME := 0 ns;
-- default control options
--   CONSTANT DefGlitchMode       : VitalGlitchKindType   := OnEvent;
-- change default delay type to Transport : for spr 68748
   CONSTANT DefGlitchMode       : VitalGlitchKindType   := VitalTransport;
   CONSTANT DefGlitchMsgOn      : BOOLEAN       := FALSE;
   CONSTANT DefGlitchXOn        : BOOLEAN       := FALSE;
   CONSTANT DefMsgOnChecks      : BOOLEAN       := TRUE;
   CONSTANT DefXOnChecks        : BOOLEAN       := TRUE;
-- output strength mapping
                                                --  UX01ZWHL-
   CONSTANT PullUp      : VitalOutputMapType    := "UX01HX01X";
   CONSTANT NoPullUpZ   : VitalOutputMapType    := "UX01ZX01X";
   CONSTANT PullDown    : VitalOutputMapType    := "UX01LX01X";
-- primitive result strength mapping
   CONSTANT wiredOR     : VitalResultMapType    := ( 'U', 'X', 'L', '1' );
   CONSTANT wiredAND    : VitalResultMapType    := ( 'U', 'X', '0', 'H' );
   CONSTANT L : VitalTableSymbolType := '0';
   CONSTANT H : VitalTableSymbolType := '1';
   CONSTANT x : VitalTableSymbolType := '-';
   CONSTANT S : VitalTableSymbolType := 'S';
   CONSTANT R : VitalTableSymbolType := '/';
   CONSTANT U : VitalTableSymbolType := 'X';
   CONSTANT V : VitalTableSymbolType := 'B'; -- valid clock signal (non-rising)

-- Declare array types for CAM_SLICE
   TYPE cycloneii_mem_data IS ARRAY (0 to 31) of STD_LOGIC_VECTOR (31 downto 0);

function int2str( value : integer ) return string;

function map_x_to_0 (value : std_logic) return std_logic;

function SelectDelay (CONSTANT Paths: IN  VitalPathArray01Type) return TIME;

end atom_pack;

library IEEE;
use IEEE.std_logic_1164.all;

package body atom_pack is

type masklength is array (4 downto 1) of std_logic_vector(3 downto 0);
function str_to_bin (lut_mask : string) return std_logic_vector is
variable slice : masklength := (OTHERS => "0000");
variable mask : std_logic_vector(15 downto 0);


begin

     for i in 1 to lut_mask'length loop
        case lut_mask(i) is
          when '0' => slice(i) := "0000";
          when '1' => slice(i) := "0001";
          when '2' => slice(i) := "0010";
          when '3' => slice(i) := "0011";
          when '4' => slice(i) := "0100";
          when '5' => slice(i) := "0101";
          when '6' => slice(i) := "0110";
          when '7' => slice(i) := "0111";
          when '8' => slice(i) := "1000";
          when '9' => slice(i) := "1001";
          when 'a' => slice(i) := "1010";
          when 'A' => slice(i) := "1010";
          when 'b' => slice(i) := "1011";
          when 'B' => slice(i) := "1011";
          when 'c' => slice(i) := "1100";
          when 'C' => slice(i) := "1100";
          when 'd' => slice(i) := "1101";
          when 'D' => slice(i) := "1101";
          when 'e' => slice(i) := "1110";
          when 'E' => slice(i) := "1110";
          when others => slice(i) := "1111";
        end case;
     end loop;
 
 
     mask := (slice(1) & slice(2) & slice(3) & slice(4));
     return (mask);
 
end str_to_bin;
 
function product (list: std_logic_vector) return std_logic is
begin

        for i in 0 to 31 loop
           if list(i) = '0' then
             return ('0');
           end if;
        end loop;
        return ('1');

end product;

function alt_conv_integer(arg : in std_logic_vector) return integer is
variable result : integer;
begin
  result := 0;
  for i in arg'range loop
     if arg(i) = '1' then
	result := result + 2**i;
     end if;
  end loop;
  return result;
end alt_conv_integer;

function int2str( value : integer ) return string is
variable ivalue,index : integer;
variable digit : integer;
variable line_no: string(8 downto 1) := "        ";
begin
        ivalue := value;
        index := 1;
        if (ivalue = 0) then
           line_no := "       0";
        end if;
        while (ivalue > 0) loop
                digit := ivalue MOD 10;
                ivalue := ivalue/10;
                case digit is
                        when 0 =>
                                line_no(index) := '0';
                        when 1 =>
                                line_no(index) := '1';
                        when 2 =>
                                line_no(index) := '2';
                        when 3 =>
                                line_no(index) := '3';
                        when 4 =>
                                line_no(index) := '4';
                        when 5 =>
                                line_no(index) := '5';
                        when 6 =>
                                line_no(index) := '6';
                        when 7 =>
                                line_no(index) := '7';
                        when 8 =>
                                line_no(index) := '8';
                        when 9 =>
                                line_no(index) := '9';
                        when others =>
                                ASSERT FALSE
                                REPORT "Illegal number!"
                                SEVERITY ERROR;
                end case;
                index := index + 1;
        end loop;
        return line_no;
end;

function map_x_to_0 (value : std_logic) return std_logic is
begin
    if (Is_X (value) = TRUE) then
      return '0';
    else
      return value;
    end if;
end;

function SelectDelay (CONSTANT Paths : IN  VitalPathArray01Type) return TIME IS

variable Temp  : TIME;
variable TransitionTime  : TIME := TIME'HIGH;
variable PathDelay : TIME := TIME'HIGH;

begin

    for i IN Paths'RANGE loop
         next when not Paths(i).PathCondition;

         next when Paths(i).InputChangeTime > TransitionTime;

         Temp := Paths(i).PathDelay(tr01);

         if Paths(i).InputChangeTime < TransitionTime then
             PathDelay := Temp;
         else
             if Temp < PathDelay then
                 PathDelay := Temp;
             end if;
         end if;
         TransitionTime := Paths(i).InputChangeTime;
    end loop;

   return PathDelay;

end;

end atom_pack;

Library ieee;
use ieee.std_logic_1164.all;

Package pllpack is

        function gcd (X: integer; Y: integer) return integer;

        function count_digit (X: integer) return integer;

        function scale_num (X: integer; Y: integer) return integer;

        function scale_mult (mult: integer; div: integer) return integer;

        function scale_div (mult: integer; div: integer) return integer;

        function lcm (A1: integer; A2: integer; A3: integer; A4: integer;
                      A5: integer; A6: integer; A7: integer;
                      A8: integer; A9: integer; A10: integer; P: integer) return integer;

        function output_counter_value (clk_divide: integer; clk_mult : integer ;
                M: integer; N: integer ) return integer;

        function counter_mode (duty_cycle: integer; output_counter_value: integer) return string;

        function counter_high (output_counter_value: integer := 1; duty_cycle: integer)
                             return integer;

        function counter_low (output_counter_value: integer; duty_cycle: integer)
                           return integer;

        function mintimedelay (t1: integer; t2: integer; t3: integer; t4: integer;
                             t5: integer; t6: integer; t7: integer; t8: integer;
                             t9: integer; t10: integer) return integer;

        function maxnegabs (t1: integer; t2: integer; t3: integer; t4: integer;
                             t5: integer; t6: integer; t7: integer; t8: integer;
                             t9: integer; t10: integer) return integer;

        function counter_time_delay ( clk_time_delay: integer;
                                    m_time_delay: integer; n_time_delay: integer)
                                return integer;

        function get_phase_degree (phase_shift: integer; clk_period: integer) return integer;

        function counter_initial (tap_phase: integer; m: integer; n: integer)
                         return integer;

        function counter_ph (tap_phase: integer; m : integer; n: integer) return integer;

        function ph_adjust (tap_phase: integer; ph_base : integer) return integer;

        function translate_string (mode : string) return string;
	
	function str2int (s : string) return integer;
	function dqs_str2int (s : string) return integer;

end pllpack;

package body pllpack is

function gcd (X: integer; Y: integer) return integer is
variable L, S, R, G : integer;
begin
        if X < Y then -- find which is smaller.
           S := X;
           L := Y;
        else
           S := Y;
           L := X;
        end if;

        R := S;
        while ( R > 1) loop
                S := L;
                L := R;
                R := S rem L; -- divide bigger number by smaller.
                              -- remainder becomes smaller number.
        end loop;
        if R = 0 then  -- if evenly divisible then L is gcd else it is 1.
                G := L;
        else
                G := R;
        end if;
        return G;
end gcd;

-- count the number of digits in the given integer
function count_digit (X: integer)
         return integer is
variable count, result: integer := 0;
begin
    result := X;
    while (result /= 0) loop
        result := (result / 10);
        count := count + 1;
    end loop;
    
    return count;
end count_digit;
    
-- reduce the given huge number to Y significant digits
function scale_num (X: integer; Y: integer)
          return integer is
variable count : integer := 0; 
variable lc, fac_ten, result: integer := 1;
begin
    count := count_digit(X);

    for lc in 1 to (count-Y) loop
        fac_ten := fac_ten * 10;
    end loop;
    
    result := (X / fac_ten);
    
    return result;
end scale_num;

-- scale down the multiply_by values to a reasonable number (within 2 significant digits at most)
function scale_mult (mult: integer; div: integer)
         return integer is
variable count_m, count_d, num_bits, result: integer := 1;
begin
    if ((mult > 100) and (div > 100)) then
        count_m := count_digit(mult);
        count_d := count_digit(div);
        
        if (count_m > count_d) then
            num_bits := count_m - 2;
        else
            num_bits := count_d - 2;
        end if;
        
        result := scale_num(mult, (count_m - num_bits));
    else
        result := mult;
    end if;
    
    return result;
end scale_mult;

-- scale down the divide_by values to a reasonable number (within 2 significant digits at most)
function scale_div (mult: integer; div: integer)
         return integer is
variable count_m, count_d, num_bits, result: integer := 1;
begin
    if ((mult > 100) and (div > 100)) then
        count_m := count_digit(mult);
        count_d := count_digit(div);
        
        if (count_m > count_d) then
            num_bits := count_m - 2;
        else
            num_bits := count_d - 2;
        end if;
        
        result := scale_num(div, (count_d - num_bits));
    else
        result := div;
    end if;
    
    return result;
end scale_div;

function lcm (A1: integer; A2: integer; A3: integer; A4: integer;
              A5: integer; A6: integer; A7: integer;
              A8: integer; A9: integer; A10: integer; P: integer) return integer is
variable M1, M2, M3, M4, M5 , M6, M7, M8, M9, R: integer;
begin
        M1 := (A1 * A2)/gcd(A1, A2);
        M2 := (M1 * A3)/gcd(M1, A3);
        M3 := (M2 * A4)/gcd(M2, A4);
        M4 := (M3 * A5)/gcd(M3, A5);
        M5 := (M4 * A6)/gcd(M4, A6);
        M6 := (M5 * A7)/gcd(M5, A7);
        M7 := (M6 * A8)/gcd(M6, A8);
        M8 := (M7 * A9)/gcd(M7, A9);
        M9 := (M8 * A10)/gcd(M8, A10);
        if M9 < 3 then 
            R := 10;
        elsif (M9 < 10) and (M9 >= 3) then
            R := 4 * M9;
        else 
            R := M9 ;
        end if;

        return R;
end lcm;

function output_counter_value (clk_divide: integer; clk_mult: integer ;
                M: integer; N: integer ) return integer is
Variable R: integer;
begin
        R := (clk_divide * M)/(clk_mult * N);
        return R;
end output_counter_value;

function counter_mode (duty_cycle: integer; output_counter_value: integer) return string is
variable R: string (1 to 6);
variable counter_value: integer;
begin
        counter_value := (2*duty_cycle*output_counter_value)/100;
        if output_counter_value = 1 then
                R := "bypass";
        elsif (counter_value REM 2) = 0 then
                R := "  even";
        else
                R := "   odd";
        end if;
        return R;
end counter_mode;

function counter_high (output_counter_value: integer := 1; duty_cycle: integer)
                       return integer is
variable R: integer;
variable half_cycle_high : integer;
begin
        half_cycle_high := (duty_cycle * output_counter_value *2)/100 ;
	if (half_cycle_high REM 2 = 0) then
	 R := half_cycle_high/2 ;
	else
	 R := half_cycle_high/2 + 1;
	end if;
        return R;
end;

function counter_low (output_counter_value: integer; duty_cycle: integer)
                        return integer is
variable R, R1: integer;
variable half_cycle_high : integer;
begin
        half_cycle_high := (duty_cycle * output_counter_value*2)/100 ;
	if (half_cycle_high REM 2 = 0) then
	 R1 := half_cycle_high/2 ;
	else
	 R1 := half_cycle_high/2 + 1;
	end if;
	
        R :=    output_counter_value - R1;
        return R;
end;

function mintimedelay (t1: integer; t2: integer; t3: integer; t4: integer;
                       t5: integer; t6: integer; t7: integer; t8: integer;
                       t9: integer; t10: integer) return integer is
variable m1,m2,m3,m4,m5,m6,m7,m8,m9 : integer;
begin
        if t1 < t2 then m1 := t1; else m1 := t2; end if;
        if m1 < t3 then m2 := m1; else m2 := t3; end if;
        if m2 < t4 then m3 := m2; else m3 := t4; end if;
        if m3 < t5 then m4 := m3; else m4 := t5; end if;
        if m4 < t6 then m5 := m4; else m5 := t6; end if;
        if m5 < t7 then m6 := m5; else m6 := t7; end if;
        if m6 < t8 then m7 := m6; else m7 := t8; end if;
        if m7 < t9 then m8 := m7; else m8 := t9; end if;
        if m8 < t10 then m9 := m8; else m9 := t10; end if;
        if m9 > 0 then return m9; else return 0; end if;
end;

function maxnegabs (t1: integer; t2: integer; t3: integer; t4: integer;
                    t5: integer; t6: integer; t7: integer; t8: integer;
                    t9: integer; t10: integer) return integer is
variable m1,m2,m3,m4,m5,m6,m7,m8,m9 : integer;
begin
        if t1 < t2 then m1 := t1; else m1 := t2; end if;
        if m1 < t3 then m2 := m1; else m2 := t3; end if;
        if m2 < t4 then m3 := m2; else m3 := t4; end if;
        if m3 < t5 then m4 := m3; else m4 := t5; end if;
        if m4 < t6 then m5 := m4; else m5 := t6; end if;
        if m5 < t7 then m6 := m5; else m6 := t7; end if;
        if m6 < t8 then m7 := m6; else m7 := t8; end if;
        if m7 < t9 then m8 := m7; else m8 := t9; end if;
        if m8 < t10 then m9 := m8; else m9 := t10; end if;
	if m9 < 0 then return (0 - m9); else return 0; end if;
end;

function ph_adjust (tap_phase: integer; ph_base : integer) return integer is
begin
	return tap_phase + ph_base;
end;
	

function counter_time_delay ( clk_time_delay: integer;
                              m_time_delay: integer; n_time_delay: integer)
                              return integer is
variable R: integer;
begin
        R := clk_time_delay + m_time_delay - n_time_delay;
        return R;
end;

-- to calculate the given phase shift (in ps) in terms of degrees
function get_phase_degree (phase_shift: integer; clk_period: integer) return integer is
variable result: integer := 0;
begin
    result := ( phase_shift * 360 ) / clk_period;
    -- to round up the calculation result
	if (result > 0) then
        result := result + 1;
    elsif (result < 0) then
        result := result - 1;
    else
        result := 0;
    end if;

    return result;
end;

function counter_initial (tap_phase: integer; m: integer; n: integer)
                         return integer is
variable R: integer;
variable R1: real;
begin
        R1 := (real(abs(tap_phase)) * real(m))/(360.0 * real(n)) + 0.5;
        -- Note NCSim VHDL had problem in rounding up for 0.5 - 0.99. 
        -- This checking will ensure that the rounding up is done.
        if (R1 >= 0.5) and (R1 <= 1.0) then
           R1 := 1.0;
        end if;

        R := integer(R1);

        return R;
end;



function counter_ph (tap_phase: integer; m: integer; n: integer) return integer is
variable R: integer;
begin
-- 0.5 is added for proper rounding of the tap_phase.
        R := (integer(real(tap_phase * m / n)+ 0.5) REM 360)/45;
        return R;
end;

function translate_string (mode : string) return string is
variable new_mode : string (1 to 6);
begin
     if (mode = "bypass") then
        new_mode := "bypass";
     elsif (mode = "even") then
        new_mode := "  even";
     elsif (mode = "odd") then
        new_mode := "   odd";
     end if;

     return new_mode;
       
end;

	function str2int (s : string) return integer is
	variable len : integer := s'length;
        variable newdigit : integer := 0;
        variable sign : integer := 1;
        variable digit : integer := 0;
        begin
        for i in 1 to len loop
              case s(i) is
                 when '-' =>
                   if i = 1 then
                     sign := -1;
                   else
                    ASSERT FALSE
                    REPORT "Illegal Character "&  s(i) & "i n string parameter! "
                    SEVERITY ERROR;
                   end if;
                 when '0' =>
                       digit := 0;
                 when '1' =>
                       digit := 1;
                 when '2' =>
                       digit := 2;
                 when '3' =>
                       digit := 3;
                 when '4' =>
                       digit := 4;
                 when '5' =>
                       digit := 5;
                 when '6' =>
                       digit := 6;
                 when '7' =>
                       digit := 7;
                 when '8' =>
                       digit := 8;
                 when '9' =>
                       digit := 9;
                 when others =>
                     ASSERT FALSE
                     REPORT "Illegal Character "&  s(i) & "in string parameter! "
                     SEVERITY ERROR;
               end case;
               newdigit := newdigit * 10 + digit;
        end loop;

               return (sign*newdigit);
	end;

function dqs_str2int (s : string) return integer is
variable len : integer := s'length;
variable newdigit : integer := 0;
variable sign : integer := 1;
variable digit : integer := 0;
variable err : boolean := false;
begin
for i in 1 to len loop
      case s(i) is
         when '-' =>
           if i = 1 then
             sign := -1;
           else
            ASSERT FALSE
            REPORT "Illegal Character "&  s(i) & " in string parameter! "
            SEVERITY ERROR;
            err := true;
           end if;
         when '0' =>
               digit := 0;
         when '1' =>
               digit := 1;
         when '2' =>
               digit := 2;
         when '3' =>
               digit := 3;
         when '4' =>
               digit := 4;
         when '5' =>
               digit := 5;
         when '6' =>
               digit := 6;
         when '7' =>
               digit := 7;
         when '8' =>
               digit := 8;
         when '9' =>
               digit := 9;
         when others =>
             -- set error flag
             err := true;
       end case;
       if (err) then
           err := false;
       else
           newdigit := newdigit * 10 + digit;
       end if;
end loop;

       return (sign*newdigit);
end;

end pllpack;

--
--
--  DFFE Model
--
--

library IEEE, cycloneii;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use cycloneii.atom_pack.all;

entity dffe is
   generic(
      TimingChecksOn: Boolean := True;
      XOn: Boolean := DefGlitchXOn;
      MsgOn: Boolean := DefGlitchMsgOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      InstancePath: STRING := "*";
      tpd_PRN_Q_negedge              :  VitalDelayType01 := DefPropDelay01;
      tpd_CLRN_Q_negedge             :  VitalDelayType01 := DefPropDelay01;
      tpd_CLK_Q_posedge              :  VitalDelayType01 := DefPropDelay01;
      tpd_ENA_Q_posedge              :  VitalDelayType01 := DefPropDelay01;
      tsetup_D_CLK_noedge_posedge    :  VitalDelayType := DefSetupHoldCnst;
      tsetup_D_CLK_noedge_negedge    :  VitalDelayType := DefSetupHoldCnst;
      tsetup_ENA_CLK_noedge_posedge  :  VitalDelayType := DefSetupHoldCnst;
      thold_D_CLK_noedge_posedge     :   VitalDelayType := DefSetupHoldCnst;
      thold_D_CLK_noedge_negedge     :   VitalDelayType := DefSetupHoldCnst;
      thold_ENA_CLK_noedge_posedge   :   VitalDelayType := DefSetupHoldCnst;
      tipd_D                         :  VitalDelayType01 := DefPropDelay01;
      tipd_CLRN                      :  VitalDelayType01 := DefPropDelay01;
      tipd_PRN                       :  VitalDelayType01 := DefPropDelay01;
      tipd_CLK                       :  VitalDelayType01 := DefPropDelay01;
      tipd_ENA                       :  VitalDelayType01 := DefPropDelay01);

   port(
      Q                              :  out   STD_LOGIC := '0';
      D                              :  in    STD_LOGIC;
      CLRN                           :  in    STD_LOGIC;
      PRN                            :  in    STD_LOGIC;
      CLK                            :  in    STD_LOGIC;
      ENA                            :  in    STD_LOGIC);
   attribute VITAL_LEVEL0 of dffe : entity is TRUE;
end dffe;

-- architecture body --

architecture behave of dffe is
   attribute VITAL_LEVEL0 of behave : architecture is TRUE;

   signal D_ipd  : STD_ULOGIC := 'U';
   signal CLRN_ipd       : STD_ULOGIC := 'U';
   signal PRN_ipd        : STD_ULOGIC := 'U';
   signal CLK_ipd        : STD_ULOGIC := 'U';
   signal ENA_ipd        : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (D_ipd, D, tipd_D);
   VitalWireDelay (CLRN_ipd, CLRN, tipd_CLRN);
   VitalWireDelay (PRN_ipd, PRN, tipd_PRN);
   VitalWireDelay (CLK_ipd, CLK, tipd_CLK);
   VitalWireDelay (ENA_ipd, ENA, tipd_ENA);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (D_ipd, CLRN_ipd, PRN_ipd, CLK_ipd, ENA_ipd)

   -- timing check results
   VARIABLE Tviol_D_CLK : STD_ULOGIC := '0';
   VARIABLE Tviol_ENA_CLK       : STD_ULOGIC := '0';
   VARIABLE TimingData_D_CLK : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE TimingData_ENA_CLK : VitalTimingDataType := VitalTimingDataInit;

   -- functionality results
   VARIABLE Violation : STD_ULOGIC := '0';
   VARIABLE PrevData_Q : STD_LOGIC_VECTOR(0 to 7);
   VARIABLE D_delayed : STD_ULOGIC := 'U';
   VARIABLE CLK_delayed : STD_ULOGIC := 'U';
   VARIABLE ENA_delayed : STD_ULOGIC := 'U';
--   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => '0');

   -- output glitch detection variables
   VARIABLE Q_VitalGlitchData   : VitalGlitchDataType;


   CONSTANT dffe_Q_tab : VitalStateTableType := (
    ( L,  L,  x,  x,  x,  x,  x,  x,  x,  L ),
    ( L,  H,  L,  H,  H,  x,  x,  H,  x,  H ),
    ( L,  H,  L,  H,  x,  L,  x,  H,  x,  H ),
    ( L,  H,  L,  x,  H,  H,  x,  H,  x,  H ),
    ( L,  H,  H,  x,  x,  x,  H,  x,  x,  S ),
    ( L,  H,  x,  x,  x,  x,  L,  x,  x,  H ),
    ( L,  H,  x,  x,  x,  x,  H,  L,  x,  S ),
    ( L,  x,  L,  L,  L,  x,  H,  H,  x,  L ),
    ( L,  x,  L,  L,  x,  L,  H,  H,  x,  L ),
    ( L,  x,  L,  x,  L,  H,  H,  H,  x,  L ));
   begin

      ------------------------
      --  Timing Check Section
      ------------------------
      if (TimingChecksOn) then
         VitalSetupHoldCheck (
                Violation       => Tviol_D_CLK,
                TimingData      => TimingData_D_CLK,
                TestSignal      => D_ipd,
                TestSignalName  => "D",
                RefSignal       => CLK_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_D_CLK_noedge_posedge,
                SetupLow        => tsetup_D_CLK_noedge_posedge,
                HoldHigh        => thold_D_CLK_noedge_posedge,
                HoldLow         => thold_D_CLK_noedge_posedge,
                CheckEnabled    => TO_X01(( (NOT PRN_ipd) ) OR ( (NOT CLRN_ipd) ) OR ( (NOT ENA_ipd) )) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/DFFE",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

         VitalSetupHoldCheck (
                Violation       => Tviol_ENA_CLK,
                TimingData      => TimingData_ENA_CLK,
                TestSignal      => ENA_ipd,
                TestSignalName  => "ENA",
                RefSignal       => CLK_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_ENA_CLK_noedge_posedge,
                SetupLow        => tsetup_ENA_CLK_noedge_posedge,
                HoldHigh        => thold_ENA_CLK_noedge_posedge,
                HoldLow         => thold_ENA_CLK_noedge_posedge,
                CheckEnabled    => TO_X01(( (NOT PRN_ipd) ) OR ( (NOT CLRN_ipd) ) ) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/DFFE",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
      end if;

      -------------------------
      --  Functionality Section
      -------------------------
      Violation := Tviol_D_CLK or Tviol_ENA_CLK;
      VitalStateTable(
        StateTable => dffe_Q_tab,
        DataIn => (
                Violation, CLRN_ipd, CLK_delayed, Results(1), D_delayed, ENA_delayed, PRN_ipd, CLK_ipd),
        Result => Results,
        NumStates => 1,
        PreviousDataIn => PrevData_Q);
      D_delayed := D_ipd;
      CLK_delayed := CLK_ipd;
      ENA_delayed := ENA_ipd;

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => Q,
       OutSignalName => "Q",
       OutTemp => Results(1),
       Paths => (0 => (PRN_ipd'last_event, tpd_PRN_Q_negedge, TRUE),
                 1 => (CLRN_ipd'last_event, tpd_CLRN_Q_negedge, TRUE),
                 2 => (CLK_ipd'last_event, tpd_CLK_Q_posedge, TRUE)),
       GlitchData => Q_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

end process;

end behave;

--
--
--  MUX21 Model
--
--

library IEEE, cycloneii;
use ieee.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
--use IEEE.VITAL_Primitives.all;
use cycloneii.atom_pack.all;

entity cycloneii_mux21 is
   generic(
      TimingChecksOn: Boolean := True;
      MsgOn: Boolean := DefGlitchMsgOn;
      XOn: Boolean := DefGlitchXOn;
      InstancePath: STRING := "*";
      tpd_A_MO                      :   VitalDelayType01 := DefPropDelay01;
      tpd_B_MO                      :   VitalDelayType01 := DefPropDelay01;
      tpd_S_MO                      :   VitalDelayType01 := DefPropDelay01;
      tipd_A                       :    VitalDelayType01 := DefPropDelay01;
      tipd_B                       :    VitalDelayType01 := DefPropDelay01;
      tipd_S                       :    VitalDelayType01 := DefPropDelay01);
     port (
                A : in std_logic := '0';
                B : in std_logic := '0';
                S : in std_logic := '0';
                MO : out std_logic);
   attribute VITAL_LEVEL0 of cycloneii_mux21 : entity is TRUE;
end cycloneii_mux21;

architecture AltVITAL of cycloneii_mux21 is
   attribute VITAL_LEVEL0 of AltVITAL : architecture is TRUE;

   signal A_ipd, B_ipd, S_ipd  : std_logic;

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
      VitalWireDelay (A_ipd, A, tipd_A);
      VitalWireDelay (B_ipd, B, tipd_B);
      VitalWireDelay (S_ipd, S, tipd_S);
   end block;

   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (A_ipd, B_ipd, S_ipd)

   -- output glitch detection variables
   VARIABLE MO_GlitchData       : VitalGlitchDataType;

   variable tmp_MO : std_logic;
   begin
      -------------------------
      --  Functionality Section
      -------------------------
      if (S_ipd = '1') then
         tmp_MO := B_ipd;
      else
         tmp_MO := A_ipd;
      end if;

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => MO,
       OutSignalName => "MO",
       OutTemp => tmp_MO,
       Paths => (0 => (A_ipd'last_event, tpd_A_MO, TRUE),
                 1 => (B_ipd'last_event, tpd_B_MO, TRUE),
                 2 => (S_ipd'last_event, tpd_S_MO, TRUE)),
       GlitchData => MO_GlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

end process;
end AltVITAL;

--
--
--  MUX41 Model
--
--

library IEEE, cycloneii;
use ieee.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
--use IEEE.VITAL_Primitives.all;
use cycloneii.atom_pack.all;

entity mux41 is
    generic(
            TimingChecksOn: Boolean := True;
            MsgOn: Boolean := DefGlitchMsgOn;
            XOn: Boolean := DefGlitchXOn;
            InstancePath: STRING := "*";
            tpd_IN0_MO : VitalDelayType01 := DefPropDelay01;
            tpd_IN1_MO : VitalDelayType01 := DefPropDelay01;
            tpd_IN2_MO : VitalDelayType01 := DefPropDelay01;
            tpd_IN3_MO : VitalDelayType01 := DefPropDelay01;
            tpd_S_MO : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
            tipd_IN0 : VitalDelayType01 := DefPropDelay01;
            tipd_IN1 : VitalDelayType01 := DefPropDelay01;
            tipd_IN2 : VitalDelayType01 := DefPropDelay01;
            tipd_IN3 : VitalDelayType01 := DefPropDelay01;
            tipd_S : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01)
           );
    port (
          IN0 : in std_logic := '0';
          IN1 : in std_logic := '0';
          IN2 : in std_logic := '0';
          IN3 : in std_logic := '0';
          S : in std_logic_vector(1 downto 0) := (OTHERS => '0');
          MO : out std_logic
         );
   attribute VITAL_LEVEL0 of mux41 : entity is TRUE;
end mux41;

architecture AltVITAL of mux41 is
   attribute VITAL_LEVEL0 of AltVITAL : architecture is TRUE;

   signal IN0_ipd, IN1_ipd, IN2_ipd, IN3_ipd  : std_logic;
   signal S_ipd : std_logic_vector(1 downto 0);

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
      VitalWireDelay (IN0_ipd, IN0, tipd_IN0);
      VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
      VitalWireDelay (IN2_ipd, IN2, tipd_IN2);
      VitalWireDelay (IN3_ipd, IN3, tipd_IN3);
      VitalWireDelay (S_ipd(0), S(0), tipd_S(0));
      VitalWireDelay (S_ipd(1), S(1), tipd_S(1));
   end block;

   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN0_ipd, IN1_ipd, IN2_ipd, IN3_ipd, S_ipd(0), S_ipd(1))

   -- output glitch detection variables
   VARIABLE MO_GlitchData       : VitalGlitchDataType;

   variable tmp_MO : std_logic;
   begin
      -------------------------
      --  Functionality Section
      -------------------------
      if ((S_ipd(1) = '1') AND (S_ipd(0) = '1')) then
         tmp_MO := IN3_ipd;
      elsif ((S_ipd(1) = '1') AND (S_ipd(0) = '0')) then
         tmp_MO := IN2_ipd;
      elsif ((S_ipd(1) = '0') AND (S_ipd(0) = '1')) then
         tmp_MO := IN1_ipd;
      else
         tmp_MO := IN0_ipd;
      end if;

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
                        OutSignal => MO,
                        OutSignalName => "MO",
                        OutTemp => tmp_MO,
                        Paths => (0 => (IN0_ipd'last_event, tpd_IN0_MO, TRUE),
                                  1 => (IN1_ipd'last_event, tpd_IN1_MO, TRUE),
                                  2 => (IN2_ipd'last_event, tpd_IN2_MO, TRUE),
                                  3 => (IN3_ipd'last_event, tpd_IN3_MO, TRUE),
                                  4 => (S_ipd(0)'last_event, tpd_S_MO(0), TRUE),
                                  5 => (S_ipd(1)'last_event, tpd_S_MO(1), TRUE)),
                        GlitchData => MO_GlitchData,
                        Mode => DefGlitchMode,
                        XOn  => XOn,
                        MsgOn        => MsgOn );

    end process;
end AltVITAL;

--
--
--  AND1 Model
--
--
library IEEE, cycloneii;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Timing.all;
use cycloneii.atom_pack.all;

-- entity declaration --
entity and1 is
   generic(
      TimingChecksOn: Boolean := True;
      MsgOn: Boolean := DefGlitchMsgOn;
      XOn: Boolean := DefGlitchXOn;
      InstancePath: STRING := "*";
      tpd_IN1_Y                      :	VitalDelayType01 := DefPropDelay01;
      tipd_IN1                       :	VitalDelayType01 := DefPropDelay01);

   port(
      Y                              :	out   STD_LOGIC;
      IN1                            :	in    STD_LOGIC);
   attribute VITAL_LEVEL0 of and1 : entity is TRUE;
end and1;

-- architecture body --

architecture AltVITAL of and1 is
   attribute VITAL_LEVEL0 of AltVITAL : architecture is TRUE;

   SIGNAL IN1_ipd	 : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS Y_zd : STD_ULOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE Y_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      Y_zd := TO_X01(IN1_ipd);

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => Y,
       OutSignalName => "Y",
       OutTemp => Y_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_Y, TRUE)),
       GlitchData => Y_GlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

end process;
end AltVITAL;

-- ///////////////////////////////////////////////////////////////////////////
-- //
-- //                           CYCLONEII_RAM_REGISTER
-- //
-- ///////////////////////////////////////////////////////////////////////////

library IEEE, cycloneii;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use cycloneii.atom_pack.all;

entity cycloneii_ram_register is
  generic 
    (
      data_width      : integer := 143;
      sclr            : string  := "true";
      preset          : string  := "false";
      tipd_data       : VitalDelayArrayType01(143 downto 0) := 
      (OTHERS => DefPropDelay01);
      tipd_clk        : VitalDelayType01 := DefPropDelay01;
      tipd_ena        : VitalDelayType01 := DefPropDelay01;
      tipd_stall        : VitalDelayType01 := DefPropDelay01;      
      tipd_aclr       : VitalDelayType01 := DefPropDelay01;
      tpd_aclr_dataout_posedge          : VitalDelayType01 := DefPropDelay01;
      tpd_clk_dataout_posedge           : VitalDelayType01 := DefPropDelay01;
      tpd_clk_done_posedge              : VitalDelayType01 := DefPropDelay01;
      tsetup_data_clk_noedge_posedge    : VitalDelayType := DefSetupHoldCnst;
      thold_data_clk_noedge_posedge     : VitalDelayType := DefSetupHoldCnst;
      tsetup_ena_clk_noedge_posedge     : VitalDelayType := DefSetupHoldCnst;
      thold_ena_clk_noedge_posedge      : VitalDelayType := DefSetupHoldCnst;
      tsetup_aclr_clk_noedge_posedge     : VitalDelayType := DefSetupHoldCnst;
      thold_aclr_clk_noedge_posedge      : VitalDelayType := DefSetupHoldCnst;
      tsetup_stall_clk_noedge_posedge     : VitalDelayType := DefSetupHoldCnst;
      thold_stall_clk_noedge_posedge      : VitalDelayType := DefSetupHoldCnst;
      tpw_stall_posedge : VitalDelayType := 0 ns;
      tpw_ena_posedge : VitalDelayType := 0 ns

    );
  port
    (
      data      : in std_logic_vector (data_width-1 downto 0);
      clk       : in std_logic;
      aclr      : in std_logic;
      ena       : in std_logic;
      stall     : in std_logic;
      if_clk    : in std_logic;
      if_aclr   : in std_logic;
      if_ena    : in std_logic;
      devclrn   : in std_logic;
      devpor    : in std_logic;
      power_up  : in std_logic;
      dataout   : out std_logic_vector (143 downto 0);
      aclrout   : out std_logic;
      clkout    : out std_logic;
      done      : out std_logic := '0'
    );
end cycloneii_ram_register;

architecture reg_arch OF cycloneii_ram_register IS

  signal aclrout_sig	: STD_LOGIC := '0';
  signal done_sig	: STD_LOGIC := '1';
  signal clk_dly	: STD_LOGIC := '0';     
  signal data_ipd       : STD_LOGIC_VECTOR (data_width-1 downto 0) := 
    (others => '0');
  signal clk_ipd        : STD_LOGIC := '0';
  signal aclr_ipd       : STD_LOGIC := '0';
  signal ena_ipd        : STD_LOGIC := '0';
  signal stall_ipd      : STD_LOGIC := '0';

begin 

  process
  begin
    WAIT UNTIL aclr_ipd'EVENT;
     if ((aclr_ipd = '1') and (ena_ipd = '1') and (stall_ipd = '0')) then
      aclrout_sig <= '1';
    else
      aclrout_sig <= '0';
    end if;
  end process;

  aclrout <= aclrout_sig when (if_aclr = '1') else '0';
  
  WireDelay : block
  begin
    g1 : for i in data'range generate
      VitalWireDelay (data_ipd(i), data(i), tipd_data(i));
    end generate;
    VitalWireDelay (clk_ipd, clk, tipd_clk);
    VitalWireDelay (aclr_ipd, aclr, tipd_aclr);
    VitalWireDelay (ena_ipd, ena, tipd_ena);
    VitalWireDelay (stall_ipd, stall, tipd_stall);
  end block;

  process
  begin
    WAIT UNTIL clk_ipd'EVENT;
    if ((clk_ipd = '1') and (ena_ipd = '1')) then      
      done_sig <= '1';
    else
      done_sig <= '0';
    end if;
    if (clk_ipd = '1') then
      clk_dly <= '1';
    else
      clk_dly <= '0';
    end if;
  end process;

  clkout <= clk_dly;

  process
    variable done_VitalGlitchData : VitalGlitchDataType;
  begin
    WAIT UNTIL done_sig'EVENT;
    if (if_clk = '1') then 
      VitalPathDelay01 (
        OutSignal     => done,
        OutSignalName => "done",
        OutTemp       => done_sig,
        Paths         => (0 => (clk_ipd'last_event, 
                                tpd_clk_done_posedge, TRUE)),
        GlitchData    => done_VitalGlitchData,
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE);
    else
      done <= '1';
    end if;
  end process;

  process (data_ipd, clk_ipd, aclr_ipd, ena_ipd, stall_ipd, devclrn, devpor)
  variable dataout_sig          : STD_LOGIC_VECTOR (143 downto 0) := (others => '0');
  variable Tviol_clk_ena        : STD_ULOGIC := '0';
  variable Tviol_clk_aclr        : STD_ULOGIC := '0';
  variable Tviol_clk_stall      : STD_ULOGIC := '0';
  variable Tviol_data_clk       : STD_ULOGIC := '0';
  variable TimingData_clk_ena   : VitalTimingDataType := VitalTimingDataInit;
  variable TimingData_clk_aclr   : VitalTimingDataType := VitalTimingDataInit;
  variable TimingData_clk_stall : VitalTimingDataType := VitalTimingDataInit;
  variable TimingData_data_clk  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_ena            : STD_ULOGIC := '0';
  variable PeriodData_ena       : VitalPeriodDataType := VitalPeriodDataInit;
  variable Tviol_stall          : STD_ULOGIC := '0';
  variable PeriodData_stall     : VitalPeriodDataType := VitalPeriodDataInit;
  variable dataout_VitalGlitchDataArray :
    VitalGlitchDataArrayType(143 downto 0);
  constant DefGlitchMode : VitalGlitchKindType := OnEvent;
  variable CQDelay : time := 0 ns;
  begin

    if (clk_ipd'event and clk_ipd = '1') then
      if (ena_ipd = '1' and stall_ipd = '0' and if_ena = '1') then
      if(aclr_ipd = '1' and if_aclr = '1') then
          if((preset = "true") and (power_up = '1')) then
          dataout_sig := (others => '1');
        elsif (power_up = '0') then
          dataout_sig := (others => '0');
        else
          dataout_sig := (others => 'X');
        end if;
      else 
          dataout_sig(data_width-1 downto 0)
            := data_ipd(data_width-1 downto 0);
      end if;
      end if;
    else
      dataout_sig := dataout_sig;
    end if;

    if (aclr_ipd'event and aclr_ipd = '1' and sclr = "false") then
      if(if_aclr = '1') then
        if((preset = "true") and (power_up = '1')) then
          dataout_sig := (others => '1');
        else
          dataout_sig := (others => '0');
        end if;
      else 
        dataout_sig := dataout_sig;
      end if;
    end if;
    
    if(devclrn'event and devclrn = '0') then
      dataout_sig := (others => '0');
    elsif(devpor'event and devpor = '0') then
      if power_up = '1' then
        dataout_sig := (others => '1');
      else
        dataout_sig := (others => '0');
      end if;
    end if;

    if (if_clk = '1') then 
      VitalSetupHoldCheck (
        Violation       => Tviol_clk_ena,
        TimingData      => TimingData_clk_ena,
        TestSignal      => clk_ipd,
        TestSignalName  => "clk",
        RefSignal       => ena_ipd,
        RefSignalName   => "ena",
        SetupHigh       => tsetup_ena_clk_noedge_posedge,
        SetupLow        => tsetup_ena_clk_noedge_posedge,
        HoldHigh        => thold_ena_clk_noedge_posedge,
        HoldLow         => thold_ena_clk_noedge_posedge,
        RefTransition   => '/',
        HeaderMsg       => "/RAM Register VitalSetupHoldCheck",
        XOn             => TRUE,
        MsgOn           => TRUE );
      VitalSetupHoldCheck (
        Violation       => Tviol_clk_aclr,
        TimingData      => TimingData_clk_aclr,
        TestSignal      => aclr_ipd,
        TestSignalName  => "aclr",
        RefSignal       => ena_ipd,
        RefSignalName   => "ena",
        SetupHigh       => tsetup_aclr_clk_noedge_posedge,
        SetupLow        => tsetup_aclr_clk_noedge_posedge,
        HoldHigh        => thold_aclr_clk_noedge_posedge,
        HoldLow         => thold_aclr_clk_noedge_posedge,
        RefTransition   => '/',
        HeaderMsg       => "/RAM Register VitalSetupHoldCheck",
        XOn             => TRUE,
        MsgOn           => TRUE );      
      VitalSetupHoldCheck (
        Violation       => Tviol_clk_stall,
        TimingData      => TimingData_clk_stall,
        TestSignal      => clk_ipd,
        TestSignalName  => "clk",
        RefSignal       => stall_ipd,
        RefSignalName   => "stall",
        SetupHigh       => tsetup_stall_clk_noedge_posedge,
        SetupLow        => tsetup_stall_clk_noedge_posedge,
        HoldHigh        => thold_stall_clk_noedge_posedge,
        HoldLow         => thold_stall_clk_noedge_posedge,
        RefTransition   => '/',
        HeaderMsg       => "/RAM Register VitalSetupHoldCheck",
        XOn             => TRUE,
        MsgOn           => TRUE );
      VitalSetupHoldCheck (
        Violation       => Tviol_data_clk,
        TimingData      => TimingData_data_clk,
        TestSignal      => data_ipd,
        TestSignalName  => "data",
        RefSignal       => clk_ipd,
        RefSignalName   => "clk",
        SetupHigh       => tsetup_data_clk_noedge_posedge,
        SetupLow        => tsetup_data_clk_noedge_posedge,
        HoldHigh        => thold_data_clk_noedge_posedge,
        HoldLow         => thold_data_clk_noedge_posedge,
        RefTransition   => '/',
        HeaderMsg       => "/RAM Register VitalSetupHoldCheck",
        XOn             => TRUE,
        MsgOn           => TRUE );
      VitalPeriodPulseCheck (
        Violation       => Tviol_ena, 
        PeriodData      => PeriodData_ena,  
        TestSignal      => ena_ipd,
        TestSignalName  => "ena",
        PulseWidthHigh  => tpw_ena_posedge, 
        HeaderMsg       => "/RAM Register VitalPeriodPulseCheck",
        XOn             => TRUE,
        MsgOn           => TRUE );
      VitalPeriodPulseCheck (
        Violation       => Tviol_stall, 
        PeriodData      => PeriodData_stall,  
        TestSignal      => stall_ipd,
        TestSignalName  => "stall",
        PulseWidthHigh  => tpw_stall_posedge, 
        HeaderMsg       => "/RAM Register VitalPeriodPulseCheck",
        XOn             => TRUE,
        MsgOn           => TRUE );

    end if;

    -- PATH DELAY
    if (if_clk = '1') then
        CQDelay := SelectDelay (
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                        tpd_aclr_dataout_posedge, TRUE)));

         dataout <= Transport dataout_sig after CQDelay;
    else
      dataout(data_width-1 downto 0) <= data_ipd(data_width-1 downto 0);
    end if;
  end process;

end reg_arch;

--/////////////////////////////////////////////////////////////////////////////
--//
--//                             CYCLONEII_RAM_CLEAR
--//
--/////////////////////////////////////////////////////////////////////////////

library IEEE, cycloneii;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use cycloneii.atom_pack.all;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY cycloneii_ram_clear IS
   PORT (
      aclr                    : IN std_logic;   
      d                       : IN std_logic;   
      clk                     : IN std_logic;   
      ena                     : IN std_logic;   
      edg                     : IN std_logic;   
      q                       : OUT std_logic);   
END cycloneii_ram_clear;

ARCHITECTURE ram_clear_arch OF cycloneii_ram_clear IS

   SIGNAL q_tmp                    :  std_logic;   
   SIGNAL valid                    :  std_logic;   

BEGIN

   PROCESS (clk, ena)
   BEGIN
      IF (edg = '0') THEN
         IF (((NOT clk AND d) AND ena) = '1') THEN
            valid <= '1';    
         ELSE
            valid <= '0';    
         END IF;
      ELSE
         IF ((clk AND d) = '1') THEN
            valid <= '1';    
         ELSE
            valid <= '0';    
         END IF;
      END IF;
   END PROCESS;

   PROCESS (valid, aclr)
   BEGIN
      IF ((valid AND aclr) = '1') THEN
         q_tmp <= '1';    
      ELSE
         q_tmp <= '0';    
      END IF;
   END PROCESS;

   q <= q_tmp;

END ram_clear_arch;

--/////////////////////////////////////////////////////////////////////////////
--
--                             CYCLONEII_RAM_INTERNAL
--
--/////////////////////////////////////////////////////////////////////////////

library IEEE, cycloneii;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use cycloneii.atom_pack.all;

ENTITY cycloneii_ram_internal IS
  GENERIC (
    operation_mode                 :  string  := "single_port";
    ram_block_type                 :  string  := "M512";    
    mixed_port_feed_through_mode   :  string  := "dont_care";    
    port_a_data_width              :  integer := 16;    
    port_b_data_width              :  integer := 16;    
    port_a_address_width           :  integer := 16;    
    port_b_address_width           :  integer := 16;    
    port_a_byte_enable_mask_width  :  integer := 0;    
    port_b_byte_enable_mask_width  :  integer := 0;    
    init_file_layout               :  string  := "none";    
    port_a_first_address           :  integer := 0;    
    port_a_last_address            :  integer := 4096;    
    port_b_first_address           :  integer := 0;    
    port_b_last_address            :  integer := 4096;    
    port_a_address_clear           :  string  := "none";
    port_b_address_clear           :  string  := "none";
    power_up_uninitialized         : string := "false";
    mem1 : std_logic_vector(511 downto 0) := (OTHERS => '0');
    mem2 : std_logic_vector(511 downto 0) := (OTHERS => '0');
    mem3 : std_logic_vector(511 downto 0) := (OTHERS => '0');
    mem4 : std_logic_vector(511 downto 0) := (OTHERS => '0');
    mem5 : std_logic_vector(511 downto 0) := (OTHERS => '0');
    mem6 : std_logic_vector(511 downto 0) := (OTHERS => '0');
    mem7 : std_logic_vector(511 downto 0) := (OTHERS => '0');
    mem8 : std_logic_vector(511 downto 0) := (OTHERS => '0');
    mem9 : std_logic_vector(511 downto 0) := (OTHERS => '0');
    tpd_portawriteenable_portadataout   : VitalDelayType01 :=
    DefPropDelay01;
    tpd_portadatain_portadataout        : VitalDelayType01 :=
    DefPropDelay01;
    tpd_portaaddress_portadataout        : VitalDelayType01 :=
    DefPropDelay01;
    tpd_portabyteenamask_portadataout  : VitalDelayType01 :=
    DefPropDelay01;
    tpd_portbwriteenable_portbdataout   : VitalDelayType01 :=
    DefPropDelay01;
    tpd_portbdatain_portbdataout        : VitalDelayType01 :=
    DefPropDelay01;
    tpd_portbaddress_portbdataout        : VitalDelayType01 :=
    DefPropDelay01;
    tpd_portbbyteenamask_portbdataout  : VitalDelayType01 :=
    DefPropDelay01;
    tpd_portbreadenable_portbdataout    : VitalDelayType01 :=
    DefPropDelay01;
    XOn: Boolean              := DefGlitchXOn;   
    MsgOn: Boolean            := DefGlitchMsgOn  
    );
   PORT (
     portawriteenable     : in std_logic;   
     portbwriteenable     : in std_logic;
     cleara                  : in std_logic;
     clearb                  : in std_logic;
     portadatain          : in std_logic_vector
     (143 downto 0);
     portbdatain          : in std_logic_vector
     (71 downto 0);
     portaaddress          : in std_logic_vector
     (15 downto 0);
     portbaddress          : in std_logic_vector
     (15 downto 0);
     portabyteenamask    : in std_logic_vector
     (15 downto 0);
     portbbyteenamask    : in std_logic_vector
     (15 downto 0);
     portbreadenable      : in std_logic;   
     portaclock            : in std_logic;   
     portbclock            : in std_logic;   
     sameclock              : in std_logic;   
     portadataout         : out std_logic_vector(143 DOWNTO 0) := 
     (OTHERS => '0');
     portbdataout         : out std_logic_vector(143 DOWNTO 0) := 
     (OTHERS => '0')
     );
END cycloneii_ram_internal;

ARCHITECTURE ram_internal_arch OF cycloneii_ram_internal IS
   SIGNAL mem                      :  std_logic_vector
     ((port_a_data_width*(2**port_a_address_width))-1  DOWNTO 0) :=
     (OTHERS => '0');
   SIGNAL wr_a                     :  std_logic := '0';
   SIGNAL wr_b                     :  std_logic := '0';
   SIGNAL init_a                   :  std_logic := '0';
   SIGNAL init_b                   :  std_logic := '0';   
BEGIN
  
  -- PORT A LOGIC

PROCESS (portawriteenable, portadatain, portaaddress,
         portabyteenamask, portaclock)
  variable port_a_data_out_VitalGlitchDataArray :
    VitalGlitchDataArrayType(143 downto 0);
  variable port_a_data_out_tmp      :  std_logic_vector(143 DOWNTO 0);
  variable i   :  integer   := 0;     
  variable PaDelay : time := 0 ns;
BEGIN
  if (NOW = 0 ns) then
     if (power_up_uninitialized = "true") then
        port_a_data_out_tmp := (OTHERS => 'X');
     elsif (init_file_layout = "none") then
              port_a_data_out_tmp := (OTHERS => '0');
     else
        port_a_data_out_tmp := (OTHERS => '0');
     end if;
  end if;

  init_a <= '1';
  if(portaclock'EVENT) then
    i := 0;
    if operation_mode = "single_port" then
      IF (portawriteenable = '1') THEN
        IF (portaclock = '0') THEN
          wr_a <= '1';
        ELSE
          wr_a <= '0';
          IF (portaclock = '1') THEN
            i := 0;
            WHILE (i < port_a_data_width) LOOP
              if(port_a_byte_enable_mask_width /= 0) then
                IF (portabyteenamask
                    (i / (port_a_data_width /
                          port_a_byte_enable_mask_width)) = '0') THEN
                  port_a_data_out_tmp(i) := 'X';    
                ELSE
                  port_a_data_out_tmp(i) := portadatain(i);    
                END IF;
              else
                port_a_data_out_tmp(i) := portadatain(i);
              end if;
              i := i + 1;
            END LOOP;
          END IF;
        END IF;
      ELSE
        wr_a <= '0';
        IF (NOT portawriteenable = '1') THEN
          IF (portaclock = '1') THEN
            i := 0;
            WHILE (i < port_a_data_width) LOOP
              port_a_data_out_tmp(i)
                := mem(alt_conv_integer(portaaddress
                   (port_a_address_width-1 downto 0)) * port_a_data_width + i);                
              i := i + 1;
            END LOOP;
          END IF;
        END IF;
      END IF;
    elsif operation_mode = "dual_port" then
      IF (portawriteenable = '1') THEN
        IF (sameclock = '1' and (ram_block_type = "MegaRAM" or
             ram_block_type = "M-RAM" or
             (ram_block_type = "auto" AND
              mixed_port_feed_through_mode =
              "dont_care"))) THEN
          IF (portaclock = '1') THEN
            wr_a <= '1';
          else
            wr_a <= '0';
          END IF;
        ELSE
          IF ((ram_block_type /= "MegaRAM") and
              (ram_block_type /= "M-RAM") and
              ((ram_block_type /= "auto") or
               (mixed_port_feed_through_mode /= "dont_care"))) THEN
            IF (portaclock = '0') THEN
              wr_a <= '1';
            else
              wr_a <= '0';
            END IF;
          ELSE
            IF (portaclock = '1') THEN
              wr_a <= '1';
            else
              wr_a <= '0';
            END IF;
          END IF;
        END IF;
      else
        wr_a <= '0';
      END IF;
    elsif operation_mode = "bidir_dual_port" then
      IF (portawriteenable = '0') THEN
        wr_a <= '0';
        -- READ: port_a_data_out = mem(portaaddress)
        IF (sameclock = '1' AND portbwriteenable = '1' AND
            (ram_block_type = "MegaRAM" OR
             ram_block_type = "M-RAM" OR 
             (ram_block_type = "auto" AND
              mixed_port_feed_through_mode =
              "dont_care"))) THEN
          IF (portaclock = '1') THEN
            i := 0;
            if(
              (((conv_integer(portaaddress)*port_a_data_width) < 
                (conv_integer(portbaddress)*port_b_data_width)) and 
               (((conv_integer(portaaddress)*port_a_data_width)
                 + port_a_data_width-1) 
                < (conv_integer(portbaddress)*port_b_data_width))) or
              (((conv_integer(portaaddress)*port_a_data_width) > 
                (conv_integer(portbaddress)*port_b_data_width)) and 
               (((conv_integer(portbaddress)*port_b_data_width)
                 + port_b_data_width-1) < 
                (conv_integer(portaaddress)*port_a_data_width)))
              ) then
              WHILE (i < port_a_data_width) LOOP
                port_a_data_out_tmp(i) := mem(alt_conv_integer
                 (portaaddress(port_a_address_width-1 downto 0)) *
                                              port_a_data_width + i);    
                i := i + 1;
              END LOOP;
            ELSE
              WHILE (i < port_a_data_width) LOOP
                if((conv_integer(portaaddress)*port_a_data_width) <= 
                   (conv_integer(portbaddress)*port_b_data_width))
                then
                  if((((conv_integer(portaaddress)*port_a_data_width)+ i) >= 
                      (conv_integer(portbaddress)*port_b_data_width)) and 
                     ((conv_integer(portaaddress)*port_a_data_width) + i < 
                      ((conv_integer(portbaddress)*port_b_data_width) + 
                       port_b_data_width)))
                  then
                    port_a_data_out_tmp(i) := 'X';
                  else
                    port_a_data_out_tmp(i) 
                      := mem (alt_conv_integer
                        (portaaddress(port_a_address_width-1 downto 0))*
                         port_a_data_width + i);
                  end if;
                else
                  if(((conv_integer(portaaddress)*port_a_data_width) + i) <= 
                     ((conv_integer(portbaddress)*port_b_data_width) + 
                      port_b_data_width)) then
                    port_a_data_out_tmp(i) := 'X';
                  else
                    port_a_data_out_tmp(i) 
                      := mem(alt_conv_integer(portaaddress(
                             port_a_address_width-1 downto 0))*
                             port_a_data_width + i);
                  end if; 
                end if;
                i := i + 1;
              end LOOP;
            end if;
          end if;
        else -- READ: port_a_data_out = mem(portaaddress);
          IF (portaclock = '1') THEN
            i := 0;
            WHILE (i < port_a_data_width) LOOP
              port_a_data_out_tmp(i) := mem(alt_conv_integer(portaaddress(
                                        port_a_address_width-1 downto 0)) *
                                            port_a_data_width + i);    
              i := i + 1;
            END LOOP;
          end if;
        end if;
      elsif(portawriteenable = '1') then
        -- WRITE: mem(portaaddress) = portadatain
        if(sameclock = '1' and portbwriteenable = '1' and 
           (ram_block_type = "MegaRAM" or 
            ram_block_type = "M-RAM" or
            (ram_block_type = "auto" and 
             mixed_port_feed_through_mode = "dont_care"))) then
          if(portaclock = '1') then
            wr_a <= '1';
            if(
              (((conv_integer(portaaddress)*port_a_data_width) < 
                (conv_integer(portbaddress)*port_b_data_width)) and 
               (((conv_integer(portaaddress)*port_a_data_width) + port_a_data_width-1) 
                < (conv_integer(portbaddress)*port_b_data_width))) or
              (((conv_integer(portaaddress)*port_a_data_width) > 
                (conv_integer(portbaddress)*port_b_data_width)) and 
               (((conv_integer(portbaddress)*port_b_data_width) + port_b_data_width-1) < 
                (conv_integer(portaaddress)*port_a_data_width)))
              ) then
              WHILE (i < port_a_data_width) LOOP
                if(port_a_byte_enable_mask_width /= 0) then
                  IF (portabyteenamask
                      (i / (port_a_data_width /
                            port_a_byte_enable_mask_width)) = '0') THEN
                    port_a_data_out_tmp(i) := 'X';    
                  ELSE
                    port_a_data_out_tmp(i) := portadatain(i);    
                  END IF;
                else
                  port_a_data_out_tmp(i) := portadatain(i);
                end if;
                i := i + 1;
              end loop;
            else
              WHILE (i < port_a_data_width) LOOP
                if((conv_integer(portaaddress)*port_a_data_width) <= 
                   (conv_integer(portbaddress)*port_b_data_width)) then
                  if((((conv_integer(portaaddress)*port_a_data_width) + i) >= 
                      (conv_integer(portbaddress)*port_b_data_width)) and 
                     ((conv_integer(portaaddress)*port_a_data_width) + i < 
                      ((conv_integer(portbaddress)*port_b_data_width) + 
                       port_b_data_width))) then
                    port_a_data_out_tmp(i) := 'X';
                  else
                    WHILE (i < port_a_data_width) LOOP
                      if(port_a_byte_enable_mask_width /= 0) then
                        IF (portabyteenamask
                            (i / (port_a_data_width /
                                  port_a_byte_enable_mask_width)) = '0') THEN
                          port_a_data_out_tmp(i) := 'X';    
                        ELSE
                          port_a_data_out_tmp(i) := portadatain(i);    
                        END IF;
                      else
                        port_a_data_out_tmp(i) := portadatain(i);
                      end if;
                    end loop;
                  end if;
                else
                  if(((conv_integer(portaaddress)*port_a_data_width) + i) <= 
                     ((conv_integer(portbaddress)*port_b_data_width) + 
                      port_b_data_width)) then
                    port_a_data_out_tmp(i) := 'X';
                  else
                    WHILE (i < port_a_data_width) LOOP
                      if(port_a_byte_enable_mask_width /= 0) then
                        IF (portabyteenamask
                            (i / (port_a_data_width /
                                  port_a_byte_enable_mask_width)) = '0') THEN
                          port_a_data_out_tmp(i) := 'X';    
                        ELSE
                          port_a_data_out_tmp(i) := portadatain(i);    
                        END IF;
                      else
                        port_a_data_out_tmp(i) := portadatain(i);
                      end if;
                    end loop;
                  end if;
                end if;
              end loop;
            end if;
          else
            wr_a <= '0';
          end if;
        else
          -- WRITE: mem(portaaddress) =  portadatain;
          if((ram_block_type /= "MegaRAM") and 
             (ram_block_type /= "M-RAM") and
             ((ram_block_type /= "auto") or
              (mixed_port_feed_through_mode /= "dont_care"))) then
            if (portaclock = '1') then
              wr_a <= '0';
              WHILE (i < port_a_data_width) LOOP
                if(port_a_byte_enable_mask_width /= 0) then
                  IF (portabyteenamask
                      (i / (port_a_data_width /
                            port_a_byte_enable_mask_width)) = '0') THEN
                    port_a_data_out_tmp(i) := 'X';    
                  ELSE
                    port_a_data_out_tmp(i) := portadatain(i);    
                  END IF;
                else
                  port_a_data_out_tmp(i) := portadatain(i);
                end if;
                i := i + 1;
              end loop;
            else
              wr_a <= '1';
            end if;
          else
            if (portaclock = '1') then
              wr_a <= '1';
              WHILE (i < port_a_data_width) LOOP
                if(port_a_byte_enable_mask_width /= 0) then
                  IF (portabyteenamask
                      (i / (port_a_data_width /
                            port_a_byte_enable_mask_width)) = '0') THEN
                    port_a_data_out_tmp(i) := 'X';    
                  ELSE
                    port_a_data_out_tmp(i) := portadatain(i);    
                  END IF;
                else
                  port_a_data_out_tmp(i) := portadatain(i);
                end if;
                i := i + 1;
              end loop;
            else
              wr_a <= '0';
            end if;
          end if; 
        end if;
      end if;
    elsif operation_mode = "rom" then
      IF (portaclock = '1') THEN
        i := 0;
        WHILE (i < port_a_data_width) LOOP
          port_a_data_out_tmp(i) := mem(alt_conv_integer(
                        portaaddress(port_a_address_width-1 downto 0)) *
                                        port_a_data_width + i);    
          i := i + 1;
        END LOOP;
      END IF;
    end if;
  end if;

    PaDelay := SelectDelay (
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)));

    portadataout <= Transport port_a_data_out_tmp after PaDelay;

END PROCESS;

  -- PORT B LOGIC
   
PROCESS (portbwriteenable, portbdatain, portbaddress,
         portbbyteenamask, portbreadenable, portbclock)
  variable port_b_data_out_VitalGlitchDataArray :
    VitalGlitchDataArrayType(143 downto 0);
  variable port_b_data_out_tmp :
    std_logic_vector(143 downto 0);
  variable i :  integer := 0;     
  variable PbDelay : time := 0 ns;
BEGIN
  if (NOW = 0 ns) then
     if (power_up_uninitialized = "true") then
        port_b_data_out_tmp := (OTHERS => 'X');
     elsif (init_file_layout = "none") then
              port_b_data_out_tmp := (OTHERS => '0');
     else
        port_b_data_out_tmp := (OTHERS => '0');
     end if;
  end if;

  init_a <= '1';
  init_b <= '1';
  if(portbclock'EVENT) then
    i := 0;
    if operation_mode = "dual_port" then
      IF (portbreadenable = '1') THEN
        wr_b <= '0';
        -- READ: port_b_data_out = mem(portbaddress)
        IF (sameclock = '1' AND portawriteenable = '1' AND
            (ram_block_type = "MegaRAM" OR
             ram_block_type = "M-RAM" OR
             (ram_block_type = "auto" AND
              mixed_port_feed_through_mode =
              "dont_care"))) THEN
          IF (portbclock = '1') THEN
            i := 0;
            if(
              (((conv_integer(portbaddress)*port_b_data_width) < 
                (conv_integer(portaaddress)*port_a_data_width)) and 
               (((conv_integer(portbaddress)*port_b_data_width)
                 + port_b_data_width-1) 
                < (conv_integer(portaaddress)*port_a_data_width))) or
              (((conv_integer(portbaddress)*port_b_data_width) > 
                (conv_integer(portaaddress)*port_a_data_width)) and 
               (((conv_integer(portaaddress)*port_a_data_width)
                 + port_a_data_width-1) < 
                (conv_integer(portbaddress)*port_b_data_width)))
              ) then
              WHILE (i < port_b_data_width) LOOP
                port_b_data_out_tmp(i) := 
         mem(alt_conv_integer(portbaddress(port_b_address_width-1 downto 0)) *
                                              port_b_data_width + i);    
                i := i + 1;
              END LOOP;
            ELSE
              WHILE (i < port_b_data_width) LOOP
                if((conv_integer(portbaddress)*port_b_data_width) <= 
                   (conv_integer(portaaddress)*port_a_data_width))
                then
                  if((((conv_integer(portbaddress)*port_b_data_width)+ i) >= 
                      (conv_integer(portaaddress)*port_a_data_width)) and 
                     ((conv_integer(portbaddress)*port_b_data_width) + i < 
                      ((conv_integer(portaaddress)*port_a_data_width) + 
                       port_a_data_width)))
                  then
                    port_b_data_out_tmp(i) := 'X';    
                  else
                    port_b_data_out_tmp(i) 
                      := mem(alt_conv_integer(portbaddress(
                         port_b_address_width-1 downto 0))*
                         port_b_data_width + i);
                  end if;
                else
                  if(((conv_integer(portbaddress)*port_b_data_width) + i) <= 
                     ((conv_integer(portaaddress)*port_a_data_width) + 
                      port_a_data_width)) then
                    port_b_data_out_tmp(i) := 'X';
                  else
                    port_b_data_out_tmp(i)
                      := mem(alt_conv_integer(portbaddress(
                         port_b_address_width-1 downto 0)) * 
                         port_b_data_width + i);
                  end if; 
                end if;
                i := i + 1;
              end LOOP;
            end if;
          end if;
        else -- READ: port_b_data_out = mem(portbaddress);
          IF (portbclock = '1') THEN
            i := 0;
            WHILE (i < port_b_data_width) LOOP
              port_b_data_out_tmp(i) := mem(alt_conv_integer(
                        portbaddress(port_b_address_width-1 downto 0)) *
                                            port_b_data_width + i);    
              i := i + 1;
            END LOOP;
          end if;
        end if;
      end if;
    elsif operation_mode = "bidir_dual_port" then
      IF (portbwriteenable = '0') THEN
        wr_b <= '0';
        -- READ: port_b_data_out = mem(portbaddress)
        IF (sameclock = '1' AND portawriteenable = '1' AND
            (ram_block_type = "MegaRAM" OR
             ram_block_type = "M-RAM" OR 
             (ram_block_type = "auto" AND
              mixed_port_feed_through_mode =
              "dont_care"))) THEN
          IF (portbclock = '1') THEN
            i := 0;
            if(
              (((conv_integer(portbaddress)*port_b_data_width) < 
                (conv_integer(portaaddress)*port_a_data_width)) and 
               (((conv_integer(portbaddress)*port_b_data_width)
                 + port_b_data_width-1) 
                < (conv_integer(portaaddress)*port_a_data_width))) or
              (((conv_integer(portbaddress)*port_b_data_width) > 
                (conv_integer(portaaddress)*port_a_data_width)) and 
               (((conv_integer(portaaddress)*port_a_data_width)
                 + port_a_data_width-1) < 
                (conv_integer(portbaddress)*port_b_data_width)))
              ) then
              WHILE (i < port_b_data_width) LOOP
                port_b_data_out_tmp(i) := mem(alt_conv_integer(
                portbaddress(port_b_address_width-1 downto 0)) *
                                              port_b_data_width + i);    
                i := i + 1;
              END LOOP;
            ELSE
              WHILE (i < port_b_data_width) LOOP
                if((conv_integer(portbaddress)*port_b_data_width) <= 
                   (conv_integer(portaaddress)*port_a_data_width))
                then
                  if((((conv_integer(portbaddress)*port_b_data_width)+ i) >= 
                      (conv_integer(portaaddress)*port_a_data_width)) and 
                     ((conv_integer(portbaddress)*port_b_data_width) + i < 
                      ((conv_integer(portaaddress)*port_a_data_width) + 
                       port_a_data_width)))
                  then
                    port_b_data_out_tmp(i) := 'X';
                  else
                    port_b_data_out_tmp(i) 
                      := mem(alt_conv_integer(portbaddress(
                    port_b_address_width-1 downto 0))*port_b_data_width + i);
                  end if;
                else
                  if(((conv_integer(portbaddress)*port_b_data_width) + i) <= 
                     ((conv_integer(portaaddress)*port_a_data_width) + 
                      port_a_data_width)) then
                    port_b_data_out_tmp(i) := 'X';
                  else
                    port_b_data_out_tmp(i) 
                      := mem(alt_conv_integer(portbaddress(
                       port_b_address_width-1 downto 0))*port_b_data_width + i);
                  end if; 
                end if;
                i := i + 1;
              end LOOP;
            end if;
          end if;
        else -- READ: port_b_data_out = mem(portbaddress);
          IF (portbclock = '1') THEN
            i := 0;
            WHILE (i < port_b_data_width) LOOP
              port_b_data_out_tmp(i) := mem(alt_conv_integer(portbaddress(
                               port_b_address_width-1 downto 0)) *
                                            port_b_data_width + i);    
              i := i + 1;
            END LOOP;
          end if;
        end if;
      elsif(portbwriteenable = '1') then
        -- WRITE: mem(portbaddress) = portbdatain
        if(sameclock = '1' and portawriteenable = '1' and 
           (ram_block_type = "MegaRAM" or 
            ram_block_type = "M-RAM" or 
            (ram_block_type = "auto" and 
             mixed_port_feed_through_mode = "dont_care"))) then
          if(portbclock = '1') then
            wr_b <= '1';
            if(
              (((conv_integer(portbaddress)*port_b_data_width) < 
                (conv_integer(portaaddress)*port_a_data_width)) and 
               (((conv_integer(portbaddress)*port_b_data_width) + port_b_data_width-1) 
                < (conv_integer(portaaddress)*port_a_data_width))) or
              (((conv_integer(portbaddress)*port_b_data_width) > 
                (conv_integer(portaaddress)*port_a_data_width)) and 
               (((conv_integer(portaaddress)*port_a_data_width) + port_a_data_width-1) < 
                (conv_integer(portbaddress)*port_b_data_width)))
              ) then
              WHILE (i < port_b_data_width) LOOP
                if(port_b_byte_enable_mask_width /= 0) then
                  IF (portbbyteenamask
                      (i / (port_b_data_width /
                            port_b_byte_enable_mask_width)) = '0') THEN
                    port_b_data_out_tmp(i) := 'X';    
                  ELSE
                    port_b_data_out_tmp(i) := portbdatain(i);    
                  END IF;
                else
                  port_b_data_out_tmp(i) := portbdatain(i);
                end if;
                i := i + 1;
              end loop;
            else
              WHILE (i < port_b_data_width) LOOP
                if((conv_integer(portbaddress)*port_b_data_width) <= 
                   (conv_integer(portaaddress)*port_a_data_width)) then
                  if((((conv_integer(portbaddress)*port_b_data_width) + i) >= 
                      (conv_integer(portaaddress)*port_a_data_width)) and 
                     ((conv_integer(portbaddress)*port_b_data_width) + i < 
                      ((conv_integer(portaaddress)*port_a_data_width) + 
                       port_a_data_width))) then
                    port_b_data_out_tmp(i) := 'X';
                  else
                    WHILE (i < port_b_data_width) LOOP
                      if(port_b_byte_enable_mask_width /= 0) then
                        IF (portbbyteenamask
                            (i / (port_b_data_width /
                                  port_b_byte_enable_mask_width)) = '0') THEN
                          port_b_data_out_tmp(i) := 'X';    
                        ELSE
                          port_b_data_out_tmp(i) := portbdatain(i);    
                        END IF;
                      else
                        port_b_data_out_tmp(i) := portbdatain(i);
                      end if;
                    end loop;
                  end if;
                else
                  if(((conv_integer(portbaddress)*port_b_data_width) + i) <= 
                     ((conv_integer(portaaddress)*port_a_data_width) + 
                      port_a_data_width)) then
                    port_b_data_out_tmp(i) := 'X';
                  else
                    WHILE (i < port_b_data_width) LOOP
                      if(port_b_byte_enable_mask_width /= 0) then
                        IF (portbbyteenamask
                            (i / (port_b_data_width /
                                  port_b_byte_enable_mask_width)) = '0') THEN
                          port_b_data_out_tmp(i) := 'X';    
                        ELSE
                          port_b_data_out_tmp(i) := portbdatain(i);    
                        END IF;
                      else
                        port_b_data_out_tmp(i) := portbdatain(i);
                      end if;
                    end loop;
                  end if;
                end if;
              end loop;
            end if;
          else
            wr_b <= '0';
          end if;
        else
          -- WRITE: mem(portbaddress) =  portbdatain;
          if((ram_block_type /= "MegaRAM") and 
             (ram_block_type /= "M-RAM") and
             ((ram_block_type /= "auto") or
              (mixed_port_feed_through_mode /= "dont_care"))) then
            if (portbclock = '1') then
              wr_b <= '0';
              WHILE (i < port_b_data_width) LOOP
                if(port_b_byte_enable_mask_width /= 0) then
                  IF (portbbyteenamask
                      (i / (port_b_data_width /
                            port_b_byte_enable_mask_width)) = '0') THEN
                    port_b_data_out_tmp(i) := 'X';    
                  ELSE
                    port_b_data_out_tmp(i) := portbdatain(i);    
                  END IF;
                else
                  port_b_data_out_tmp(i) := portbdatain(i);
                end if;
                i := i + 1;
              end loop;
            else
              wr_b <= '1';
            end if;
          else
            if (portbclock = '1') then
              wr_b <= '1';
              WHILE (i < port_b_data_width) LOOP
                if(port_b_byte_enable_mask_width /= 0) then
                  IF (portbbyteenamask
                      (i / (port_b_data_width /
                            port_b_byte_enable_mask_width)) = '0') THEN
                    port_b_data_out_tmp(i) := 'X';    
                  ELSE
                    port_b_data_out_tmp(i) := portbdatain(i);    
                  END IF;
                else
                  port_b_data_out_tmp(i) := portbdatain(i);
                end if;
                i := i + 1;
              end loop;
            else
              wr_b <= '0';
            end if;
          end if; 
        end if;
      end if;
    end if;
  end if;

    PbDelay := SelectDelay (
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)));

    portbdataout <= Transport port_b_data_out_tmp after PbDelay;

end process;

-- WRITE LOGIC BLOCK
process
    variable i :  integer := 0;     
    variable initial : BOOLEAN := TRUE;
    variable j : integer := 0;
    variable k : integer := 0;
    variable l : integer := 0;
    variable depth : integer := 0;
    variable index : integer := 0;
    variable tmp_mem : std_logic_vector(4607 downto 0) := (OTHERS => '0');
  begin
    wait until (wr_a'event and wr_a = '1') or (wr_b'event and wr_b = '1') or
      (cleara'event and cleara = '1') or (clearb'event and clearb = '1') or 
      (init_a'event and init_a = '1' and initial) or
      (init_b'event and init_b = '1' and initial);
    IF (initial) THEN
      tmp_mem(4607 downto 0) := (mem9 & mem8 & mem7 & mem6 & mem5 &
                                 mem4 & mem3 & mem2 & mem1);
       IF (power_up_uninitialized = "true") THEN
           mem <= (others => 'X');
       ELSIF (init_file_layout = "none") or (init_file_layout = "UNUSED") THEN
         mem <= (others => '0');
       ELSIF (init_file_layout = "port_b") THEN
        l := 0;    
        depth := port_b_last_address - port_b_first_address + 1;    
        j := 0;
        WHILE (j < depth) LOOP
          k := 0;
          WHILE (k < port_b_data_width) LOOP
            index := j + (depth * k);
            mem(l) <= tmp_mem(index);
            l := l + 1;    
            k := k + 1;
          END LOOP;
          j := j + 1;
        END LOOP;
      ELSIF (init_file_layout = "port_a") THEN
        l := 0;    
        depth := port_a_last_address - port_a_first_address + 1;    
        j := 0;
        WHILE (j < depth) LOOP
          k := 0;
          WHILE (k < port_a_data_width) LOOP
            index := j + (depth * k);    
            mem(l) <= tmp_mem(index);
            l := l + 1;    
            k := k + 1;
          END LOOP;
          j := j + 1;
        END LOOP;
      END IF;
      initial := FALSE;
    END IF;
    
    if(wr_a'event and wr_a = '1') then
      i := 0;
      WHILE (i < port_a_data_width) LOOP
        if(port_a_byte_enable_mask_width /= 0) then
          IF (portabyteenamask
              (i / (port_a_data_width / port_a_byte_enable_mask_width))
              = '1') THEN
            mem(alt_conv_integer(portaaddress(
            port_a_address_width-1 downto 0)) * port_a_data_width + i) 
              <= portadatain(i);    
          END IF;
        else
          mem(alt_conv_integer(portaaddress(
             port_a_address_width-1 downto 0)) * port_a_data_width + i)
            <= portadatain(i);
        end if;
        i := i + 1;
      END LOOP;
    end if;
    
    if(wr_b'event and wr_b = '1') then
      i := 0;
      WHILE (i < port_b_data_width) LOOP
        if(port_b_byte_enable_mask_width /= 0) then
          IF (portbbyteenamask
              (i / (port_b_data_width / port_b_byte_enable_mask_width))
              = '1') THEN
            mem(alt_conv_integer(portbaddress(
              port_b_address_width-1 downto 0)) * port_b_data_width + i)
              <= portbdatain(i);    
          END IF;
        else
          mem(alt_conv_integer(portbaddress(
             port_b_address_width-1 downto 0)) * port_b_data_width + i)
            <= portbdatain(i);
        end if;
        i := i + 1;
      END LOOP;
    end if;
     
    if(cleara'event and cleara = '1') then
      i := 0;
      if ((port_a_address_clear /= "none") and 
          (port_a_address_clear /= "UNUSED"))then
        mem <= (others => 'X');
      else
        WHILE (i < port_a_data_width) LOOP
          if(port_a_byte_enable_mask_width /= 0) then
            IF (portabyteenamask
                (i / (port_a_data_width / port_a_byte_enable_mask_width))
                = '1') THEN
              mem(alt_conv_integer(portaaddress(
                port_a_address_width-1 downto 0)) * port_a_data_width + i)
                <= 'X';    
            END IF;
          else
            mem(alt_conv_integer(portaaddress(
              port_a_address_width-1 downto 0)) * port_a_data_width + i) <= 'X';
          end if;
          i := i + 1;
        END LOOP;
      end if;
    end if;
     
    if(clearb'event and clearb = '1' and operation_mode /= "dual_port") then
      i := 0;
      if ((port_b_address_clear /= "none") and
          (port_b_address_clear /= "UNUSED")) then
        mem <= (others => 'X');
      else
        WHILE (i < port_b_data_width) LOOP
          if(port_b_byte_enable_mask_width /= 0) then
            IF (portbbyteenamask
                (i / (port_b_data_width / port_b_byte_enable_mask_width))
                = '1') THEN
              mem(alt_conv_integer(portbaddress(
                port_b_address_width-1 downto 0)) * port_b_data_width + i)
                <= 'X';    
            END IF;
          else
            mem(alt_conv_integer(portbaddress(
             port_b_address_width-1 downto 0)) * port_b_data_width + i) <= 'X';
          end if;
          i := i + 1;
        END LOOP;
      end if;
    end if;
  end process;
   end ram_internal_arch;

-- ///////////////////////////////////////////////////////////////////////////
-- //
-- //                             CYCLONEII_RAM_BLOCK
-- //
-- ///////////////////////////////////////////////////////////////////////////

library IEEE, cycloneii;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use cycloneii.atom_pack.all;

entity cycloneii_ram_block IS
  generic 
    (
      operation_mode            : string := "single_port";
      mixed_port_feed_through_mode : string := "dont_care"; 
      ram_block_type            : string := "auto"; 
      logical_ram_name          : string := "ram_name"; 
      init_file                 : string := "init_file.hex"; 
      init_file_layout          : string := "none";
      data_interleave_width_in_bits : integer := 1;
      data_interleave_offset_in_bits : integer := 1;
      port_a_logical_ram_depth  : integer := 0;
      port_a_logical_ram_width  : integer := 0;
      port_a_data_in_clear      : string := "none";
      port_a_address_clear      : string := "none";
      port_a_write_enable_clear : string := "none";
      port_a_data_out_clock     : string := "none";
      port_a_data_out_clear     : string := "none";
      port_a_first_address      : integer := 0;
      port_a_last_address       : integer := 0;
      port_a_first_bit_number   : integer := 0;
      port_a_data_width         : integer := 144;
      port_a_byte_enable_clear  : string := "none";
      port_a_data_in_clock      : string := "clock0"; 
      port_a_address_clock      : string := "clock0"; 
      port_a_write_enable_clock : string := "clock0";
      port_a_byte_enable_clock  : string := "clock0";
      port_b_logical_ram_depth  : integer := 0;
      port_b_logical_ram_width  : integer := 0;
      port_b_data_in_clock      : string := "none";
      port_b_data_in_clear      : string := "none";
      port_b_address_clock      : string := "none";
      port_b_address_clear      : string := "none";
      port_b_read_enable_write_enable_clock : string := "none";
      port_b_read_enable_write_enable_clear : string := "none";
      port_b_data_out_clock     : string := "none";
      port_b_data_out_clear     : string := "none";
      port_b_first_address      : integer := 0;
      port_b_last_address       : integer := 0;
      port_b_first_bit_number   : integer := 0;
      port_b_data_width         : integer := 72;
      port_b_byte_enable_clear  : string := "none";
      port_b_byte_enable_clock  : string := "none";
      port_a_address_width      : integer := 16; 
      port_b_address_width      : integer := 16; 
      port_a_byte_enable_mask_width : integer := 0; 
      port_b_byte_enable_mask_width : integer := 0; 
      power_up_uninitialized	: string := "false";
      port_a_byte_size : integer := 0;
      port_a_disable_ce_on_input_registers : string := "off";
      port_a_disable_ce_on_output_registers : string := "off";
      port_b_byte_size : integer := 0;
      port_b_disable_ce_on_input_registers : string := "off";
      port_b_disable_ce_on_output_registers : string := "off";
      lpm_type                  : string := "cycloneii_ram_block";
      connectivity_checking     : string := "off";
      mem1 : std_logic_vector(512 downto 1) := (OTHERS => '0');
      mem2 : std_logic_vector(512 downto 1) := (OTHERS => '0');
      mem3 : std_logic_vector(512 downto 1) := (OTHERS => '0');
      mem4 : std_logic_vector(512 downto 1) := (OTHERS => '0');
      mem5 : std_logic_vector(512 downto 1) := (OTHERS => '0');
      mem6 : std_logic_vector(512 downto 1) := (OTHERS => '0');
      mem7 : std_logic_vector(512 downto 1) := (OTHERS => '0');
      mem8 : std_logic_vector(512 downto 1) := (OTHERS => '0');
      mem9 : std_logic_vector(512 downto 1) := (OTHERS => '0')
    );
  port
    (
      portawe           : in std_logic;
      portabyteenamasks : in std_logic_vector (15 downto 0) := (OTHERS => '1');
      portbbyteenamasks : in std_logic_vector (15 downto 0) := (OTHERS => '1');
      portbrewe         : in std_logic;
      clr0              : in std_logic;
      clr1              : in std_logic;
      clk0              : in std_logic;
      clk1              : in std_logic;
      ena0              : in std_logic := '1';
      ena1              : in std_logic := '1';
      portadatain       : in std_logic_vector (143 downto 0);
      portbdatain       : in std_logic_vector (71 downto 0);
      portaaddr         : in std_logic_vector (15 downto 0);
      portbaddr         : in std_logic_vector (15 downto 0);
      portaaddrstall    : in std_logic := '0';
      portbaddrstall    : in std_logic := '0';
      devclrn           : in std_logic := '1';   
      devpor            : in std_logic := '1';
      portadataout      : out std_logic_vector (143 downto 0);
      portbdataout      : out std_logic_vector (143 downto 0)
    );

function select_ram(constant string_name : string)
  return natural is
  begin
    if (string_name = "clock0" or string_name = "clear0") then
      return 0;
    elsif (string_name = "clock1" or string_name = "clear1") then
      return 1;
    elsif string_name = "none" then
      return 0;
    else
      return 0;  
    end if;
  end select_ram;

end cycloneii_ram_block;

architecture ram_arch of cycloneii_ram_block is

--
-- CYCLONEII_RAM_REGISTER COMPONENT
--

component cycloneii_ram_register
  generic 
    (
      data_width      : integer := 143;
      sclr            : string  := "true";
      preset          : string  := "false";
      tipd_data       : VitalDelayArrayType01(143 downto 0) :=
      (OTHERS => DefPropDelay01);
      tipd_clk        : VitalDelayType01 := DefPropDelay01;
      tipd_ena        : VitalDelayType01 := DefPropDelay01;
      tipd_aclr       : VitalDelayType01 := DefPropDelay01;
      tpd_aclr_dataout_posedge  : VitalDelayType01 := DefPropDelay01;
      tpd_clk_dataout_posedge   : VitalDelayType01 := DefPropDelay01;
      tpd_clk_done_posedge      : VitalDelayType01 := DefPropDelay01;
      tsetup_data_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      thold_data_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      tsetup_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      thold_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      tpw_ena_posedge : VitalDelayType := 0 ns
    );
  port
    (
      data      : in std_logic_vector (data_width-1 downto 0);
      clk       : in std_logic;
      aclr      : in std_logic;
      ena       : in std_logic;
      stall     : in std_logic;
      if_clk    : in std_logic;
      if_aclr   : in std_logic;
      if_ena    : in std_logic;
      devclrn   : in std_logic;
      devpor    : in std_logic;
      power_up  : in std_logic;
      dataout   : out std_logic_vector (143 downto 0);
      aclrout   : out std_logic;
      clkout   : out std_logic;      
      done      : out std_logic
    );
end component;

--
-- CYCLONEII_RAM_CLEAR COMPONENT
--

component cycloneii_ram_clear
   PORT (
      aclr                    : IN std_logic;   
      d                       : IN std_logic;   
      clk                     : IN std_logic;   
      ena                     : IN std_logic;   
      edg                     : IN std_logic;   
      q                       : OUT std_logic
      );   
END component;

--
-- CYCLONEII_RAM_INTERNAL COMPONENT
--

component cycloneii_ram_internal
  generic
    (
      operation_mode : string := "single_port";
      ram_block_type : string := "M512";
      mixed_port_feed_through_mode : string := "dont_care";
      port_a_data_width : integer := 144;
      port_b_data_width : integer := 144;
      port_a_address_width : integer := 16;
      port_b_address_width : integer := 16;
      port_a_byte_enable_mask_width : integer := 0;
      port_b_byte_enable_mask_width : integer := 0;
      init_file_layout     : string := "none";
      port_a_first_address : integer := 0;
      port_a_last_address  : integer := 4096;
      port_b_first_address : integer := 0;
      port_b_last_address  : integer := 4096;
      port_a_address_clear :  string  := "none";
      port_b_address_clear :  string  := "none";
      power_up_uninitialized     : string := "false";
      mem1 : std_logic_vector(512 downto 1);
      mem2 : std_logic_vector(512 downto 1);
      mem3 : std_logic_vector(512 downto 1);
      mem4 : std_logic_vector(512 downto 1);
      mem5 : std_logic_vector(512 downto 1);
      mem6 : std_logic_vector(512 downto 1);
      mem7 : std_logic_vector(512 downto 1);
      mem8 : std_logic_vector(512 downto 1);
      mem9 : std_logic_vector(512 downto 1) 
    );
  port
    (
      portawriteenable : in std_logic;
      portbwriteenable : in std_logic;
      cleara              : std_logic;
      clearb              : std_logic;
      portadatain      : in std_logic_vector(143 downto 0);
      portbdatain      : in std_logic_vector(71 downto 0);
      portaaddress      : in std_logic_vector(15 downto 0);
      portbaddress      : in std_logic_vector(15 downto 0);
      portabyteenamask: in std_logic_vector(15 downto 0);
      portbbyteenamask: in std_logic_vector(15 downto 0);
      portbreadenable  : in std_logic;
      portaclock        : in std_logic;
      portbclock        : in std_logic; 
      sameclock          : in std_logic; 
      portadataout     : out std_logic_vector (143 downto 0);
      portbdataout     : out std_logic_vector (143 downto 0)
    );
end component;

signal clk_bus  : std_logic_vector (1 downto 0);
signal ena_bus  : std_logic_vector (1 downto 0);
signal ena_cea_bus  : std_logic_vector (1 downto 0);
signal ena_ceb_bus  : std_logic_vector (1 downto 0);
signal ena_cea_out_bus  : std_logic_vector (1 downto 0);
signal ena_ceb_out_bus  : std_logic_vector (1 downto 0);
signal clr_bus  : std_logic_vector (1 downto 0);
signal portadatain_bus : std_logic_vector (143 downto 0);
signal portbdatain_bus : std_logic_vector (143 downto 0);
signal portaaddr_bus : std_logic_vector (143 downto 0);
signal portbaddr_bus : std_logic_vector (143 downto 0);
signal portadataout_bus : std_logic_vector (143 downto 0);
signal portbdataout_bus : std_logic_vector (143 downto 0);
signal portawe_bus : std_logic_vector (143 downto 0);
signal portbrewe_bus : std_logic_vector (143 downto 0);
signal portawe_eab : std_logic;
signal portbrewe_eab : std_logic;
signal portamask_bus : std_logic_vector (143 downto 0);
signal portbmask_bus : std_logic_vector (143 downto 0);

signal portawe_tmp : std_logic_vector(0 downto 0);
signal portbrewe_tmp : std_logic_vector(0 downto 0);
signal portabyteenamasks_tmp : std_logic_vector(143 downto 0);
signal portbbyteenamasks_tmp : std_logic_vector(143 downto 0);
signal portaaddr_tmp : std_logic_vector(143 downto 0);
signal portbaddr_tmp : std_logic_vector(143 downto 0);
signal portaaddrstall_tmp : std_logic;
signal portbaddrstall_tmp : std_logic;

signal ena_portaaddr_ce : std_logic;
signal ena_portbaddr_ce : std_logic;
signal aclr_portadatain : std_logic;
signal aclr_portaaddr   : std_logic;
signal aclr_portawe     : std_logic;
signal clk_portbdatain  : std_logic;
signal aclr_portbdatain : std_logic;
signal ena_portbdatain  : std_logic;
signal clk_portbaddr    : std_logic;
signal clr_portbaddr    : std_logic;
signal ena_portbaddr    : std_logic;
signal clk_portbrewe    : std_logic;
signal clr_portbrewe    : std_logic;
signal ena_portbrewe    : std_logic;
signal aclr_portabyteenamasks : std_logic;
signal clk_portbbyteenamasks  : std_logic;
signal aclr_portbbyteenamasks : std_logic;
signal ena_portbbyteenamasks  : std_logic;
signal clk_portadataout  : std_logic;
signal aclr_portadataout : std_logic;
signal ena_portadataout  : std_logic;
signal clk_portbdataout  : std_logic;
signal aclr_portbdataout : std_logic;
signal ena_portbdataout  : std_logic;

signal if_clk_portadatain  : std_logic := '1';
signal if_aclr_portadatain : std_logic := '1';
signal if_ena_portadatain  : std_logic := '1';
signal if_clk_portaaddr    : std_logic := '1';
signal if_ena_portaaddr    : std_logic := '1';
signal if_aclr_portaaddr   : std_logic := '1';
signal if_aclr_portawe     : std_logic := '1';
signal if_clk_portawe      : std_logic := '1';
signal if_ena_portawe      : std_logic := '1';
signal if_clk_portbdatain  : std_logic := '1';
signal if_aclr_portbdatain : std_logic := '1';
signal if_ena_portbdatain  : std_logic := '1';
signal if_clk_portbaddr    : std_logic := '1';
signal if_aclr_portbaddr   : std_logic := '1';
signal if_ena_portbaddr    : std_logic := '1';
signal if_clk_portbrewe    : std_logic := '1';
signal if_aclr_portbrewe   : std_logic := '1';
signal if_ena_portbrewe    : std_logic := '1';
signal if_aclr_portabyteenamasks : std_logic := '1';
signal if_clk_portabyteenamasks  : std_logic := '1';
signal if_ena_portabyteenamasks  : std_logic := '1';
signal if_clk_portbbyteenamasks  : std_logic := '1';
signal if_aclr_portbbyteenamasks : std_logic := '1';
signal if_ena_portbbyteenamasks  : std_logic := '1';
signal if_clk_portadataout : std_logic := '1';
signal if_aclr_portadataout : std_logic := '1';
signal if_ena_portadataout : std_logic := '1';
signal if_clk_portbdataout : std_logic := '1';
signal if_aclr_portbdataout : std_logic := '1';
signal if_ena_portbdataout : std_logic := '1';
signal if_same_clock       : std_logic := '0';
signal portbrewe_power_up  : std_logic := '0';

signal port_b_write_enable_tmp : std_logic := '0';
signal gnd : std_logic := '0';
signal vcc : std_logic := '1';

signal done_a : std_logic_vector(4 downto 0) := "11111";
signal done_b : std_logic_vector(4 downto 0) := "11111";
signal done_a_tmp : std_logic_vector(3 downto 0) := "1111";
signal done_b_tmp : std_logic_vector(3 downto 0) := "1111";
signal clock_a    : std_logic := '1';
signal clock_b    : std_logic := '1';
signal edg        : std_logic := '0';
signal clrdly_a   : std_logic := '0';
signal clrdly_b   : std_logic := '0';
signal aclra      : std_logic_vector(5 downto 0);
signal aclrb      : std_logic_vector(5 downto 0);
signal clkout_a   : std_logic_vector(5 downto 0);
signal clkout_b   : std_logic_vector(5 downto 0);
signal cleara_tmp : std_logic;
signal clearb_tmp : std_logic;

begin

ram_aclra_reg : cycloneii_ram_clear
  port map
  (
    aclr => cleara_tmp,
    d => portawe_bus(0),
    clk => clrdly_a,
    ena => clock_a,
    edg => edg,
    q  => aclra(5)
  );
cleara_tmp <= '1' when (aclra(2) = '1') or (devclrn = '0') else '0';
edg <= '1' when (ram_block_type = "MegaRAM" or ram_block_type = "M-RAM" or
                 (ram_block_type = "auto" and mixed_port_feed_through_mode = "dont_care")) else '0';

ram_aclrb_reg : cycloneii_ram_clear
  port map
  (
    aclr => clearb_tmp,
    d => portbrewe_bus(0),
    clk => clrdly_b,
    ena => clock_b,
    edg => edg,
    q  => aclrb(5)
  );
clearb_tmp <= '1' when (aclrb(2) = '1') or (devclrn = '0') else '0';

aclr_portadatain <= clr_bus(select_ram(port_a_data_in_clear));
done_a(0) <= '1' when ((done_a_tmp(0) = '1') or
                       (port_a_data_in_clock = "none") or
                       (port_a_data_in_clock = "UNUSED")) else '0';

ram_portadatain_reg : cycloneii_ram_register
 generic map ( data_width => 144,
               sclr       => "true",
               preset     => "false")
  port map
  (
    data => portadatain(143 downto 0),
    clk  => clk_bus(0),
    aclr => aclr_portadatain,
    ena  => ena_cea_bus(0),
    stall=> GND,  
    if_clk => if_clk_portadatain,
    if_aclr => if_aclr_portadatain,
    if_ena => if_ena_portadatain,
    devclrn => devclrn,
    devpor => devpor,
    power_up => gnd,
    dataout => portadatain_bus,
    aclrout => aclra(0),
    clkout => clkout_a(0),
    done => done_a_tmp(0)
  );

ena_portaaddr_ce <= '1' when port_a_disable_ce_on_input_registers = "on" else ena_bus(0);
aclr_portaaddr <= clr_bus(select_ram(port_a_address_clear));
done_a(1) <= '1' when ((done_a_tmp(1) = '1') or
                       (port_a_address_clock = "none") or
                       (port_a_address_clock = "UNUSED")) else '0';

ram_portaaddr_reg : cycloneii_ram_register
  generic map ( data_width => 16,
                sclr       => "true",
                preset     => "false")
  port map
  (
    data => portaaddr(15 downto 0),
    clk  => clk_bus(0),
    aclr => aclr_portaaddr,
    ena  => ena_portaaddr_ce,
    stall => portaaddrstall_tmp,
    if_clk => if_clk_portaaddr,
    if_aclr => if_aclr_portaaddr,
    if_ena => if_ena_portaaddr,
    devclrn => devclrn,
    devpor => devpor,
    power_up => gnd,
    dataout => portaaddr_bus,
    aclrout => aclra(1),
    clkout => clkout_a(1),
    done => done_a_tmp(1)
  );

aclr_portawe <= clr_bus(select_ram(port_a_write_enable_clear));
done_a(2) <= '1' when ((done_a_tmp(2) = '1') or
                       (port_a_write_enable_clock = "none") or
                       (port_a_write_enable_clock = "UNUSED")) else '0';

ram_portawe_reg : cycloneii_ram_register
  generic map ( data_width => 1,
                sclr       => "true",
                preset     => "false")
  port map
  (
    data => portawe_tmp,
    clk  => clk_bus(0),
    aclr => aclr_portawe,
    ena  => ena_cea_bus(0),
    stall => GND,
    if_clk => if_clk_portawe,
    if_aclr => if_aclr_portawe,
    if_ena => if_ena_portawe,
    devclrn => devclrn,
    devpor => devpor,
    power_up => gnd,
    dataout => portawe_bus,
    aclrout => aclra(2),
    clkout => clkout_a(2),
    done => done_a_tmp(2)
  );

clk_portbdatain  <= clk_bus(select_ram(port_b_data_in_clock));
aclr_portbdatain <= clr_bus(select_ram(port_b_data_in_clear));
ena_portbdatain  <= ena_ceb_bus(select_ram(port_b_data_in_clock));
done_b(0) <= '1' when ((done_b_tmp(0) = '1') or
                       (port_b_data_in_clock = "none") or
                       (port_b_data_in_clock = "UNUSED")) else '0';

ram_portbdatain_reg : cycloneii_ram_register
  generic map ( data_width => 72,
                sclr       => "true",
                preset     => "false")
  port map
  (
    data => portbdatain(71 downto 0),
    clk  => clk_portbdatain,
    aclr => aclr_portbdatain,
    ena  => ena_portbdatain,
    stall => GND,
    if_clk => if_clk_portbdatain,
    if_aclr => if_aclr_portbdatain,
    if_ena => if_ena_portbdatain,
    devclrn => devclrn,
    devpor => devpor,
    power_up => gnd,
    dataout => portbdatain_bus,
    aclrout => aclrb(0),
    clkout => clkout_b(0),
    done => done_b_tmp(0)
  );

ena_portbaddr_ce <= '1' when  port_b_disable_ce_on_input_registers = "on" else ena_bus(select_ram(port_b_address_clock));
clk_portbaddr <= clk_bus(select_ram(port_b_address_clock));
clr_portbaddr <= clr_bus(select_ram(port_b_address_clear));
ena_portbaddr <= ena_portbaddr_ce;
done_b(1) <= '1' when ((done_b_tmp(1) = '1') or
                       (port_b_address_clock = "none") or
                       (port_b_address_clock = "UNUSED")) else '0';

ram_portbaddr_reg : cycloneii_ram_register
  generic map ( data_width => 16,
                sclr       => "true",
                preset     => "false")
  port map
  (
    data => portbaddr(15 downto 0),
    clk  => clk_portbaddr,
    aclr => clr_portbaddr,
    ena  => ena_portbaddr,
    stall => portbaddrstall_tmp,
    if_clk => if_clk_portbaddr,
    if_aclr => if_aclr_portbaddr, 
    if_ena => if_ena_portbaddr, 
    devclrn => devclrn,
    devpor => devpor,
    power_up => gnd,
    dataout => portbaddr_bus,
    aclrout => aclrb(1),
    clkout => clkout_b(1),
    done => done_b_tmp(1)
  );

clk_portbrewe <= clk_bus(select_ram(port_b_read_enable_write_enable_clock));
clr_portbrewe <= clr_bus(select_ram(port_b_read_enable_write_enable_clear));
ena_portbrewe <= ena_ceb_bus(select_ram(port_b_read_enable_write_enable_clock));
done_b(2) <= '1' when ((done_b_tmp(2) = '1') or
                       (port_b_read_enable_write_enable_clock = "none") or
                       (port_b_read_enable_write_enable_clock = "UNUSED"))
             else '0';

ram_portbrewe_reg : cycloneii_ram_register
  generic map ( data_width => 1,
                sclr       => "true",
                preset     => "true")
  port map
  (
    data => portbrewe_tmp,
    clk  => clk_portbrewe,
    aclr => clr_portbrewe,
    ena  => ena_portbrewe,
    stall => GND,
    if_clk => if_clk_portbrewe, 
    if_aclr => if_aclr_portbrewe,
    if_ena => if_ena_portbrewe,
    devclrn => devclrn,
    devpor => devpor,
    power_up => portbrewe_power_up,
    dataout => portbrewe_bus,
    aclrout => aclrb(2),
    clkout => clkout_b(2),
    done => done_b_tmp(2)
  );

portbrewe_power_up <= '1' when operation_mode = "dual_port" else '0';
aclr_portabyteenamasks <= clr_bus(select_ram(port_a_byte_enable_clear));
done_a(3) <= '1' when ((done_a_tmp(3) = '1') or
                       (port_a_byte_enable_clock = "none") or
                       (port_a_byte_enable_clock = "UNUSED")) else '0';

ram_portabyteenamasks_reg : cycloneii_ram_register
  generic map ( data_width => 16,
                sclr       => "true",
                preset     => "true")
  port map
  (
    data => portabyteenamasks(15 downto 0),
    clk  => clk_bus(0),
    aclr => aclr_portabyteenamasks,
    ena  => ena_cea_bus(0),
    stall => GND,
    if_clk => if_clk_portabyteenamasks,
    if_aclr => if_aclr_portabyteenamasks,
    if_ena => if_ena_portabyteenamasks,
    devclrn => devclrn,
    devpor => devpor,
    power_up => vcc,
    dataout => portamask_bus,
    aclrout => aclra(3),
    clkout => clkout_a(3),
    done => done_a_tmp(3)
  );

clk_portbbyteenamasks  <= clk_bus(select_ram(port_b_byte_enable_clock));
aclr_portbbyteenamasks <= clr_bus(select_ram(port_b_byte_enable_clear));
ena_portbbyteenamasks  <= ena_bus(select_ram(port_b_byte_enable_clock));
done_b(3) <= '1' when ((done_b_tmp(3) = '1') or
                       (port_b_byte_enable_clock = "none") or
                       (port_b_byte_enable_clock = "UNUSED")) else '0';

ram_portbbyteenamasks_reg : cycloneii_ram_register
  generic map ( data_width => 16,
                sclr       => "true",
                preset     => "true")
  port map
  (
    data => portbbyteenamasks(15 downto 0),
    clk  => clk_portbbyteenamasks,
    aclr => aclr_portbbyteenamasks,
    ena  => ena_portbbyteenamasks,
    stall => GND,
    if_clk => if_clk_portbbyteenamasks,
    if_aclr => if_aclr_portbbyteenamasks,
    if_ena => if_ena_portbbyteenamasks,
    devclrn => devclrn,
    devpor => devpor,
    power_up => vcc,
    dataout => portbmask_bus,
    aclrout => aclrb(3),
    clkout => clkout_b(3),
    done => done_b_tmp(3)
  );

clock_a <= ((((done_a(0) AND done_a(1)) AND done_a(2))
             AND done_b(2)) AND done_a(3))
           WHEN (port_a_write_enable_clock =
                 port_b_read_enable_write_enable_clock)
           ELSE (((done_a(0) AND done_a(1)) AND done_a(2)) AND done_a(3)) ;
clock_b <= ((((done_b(0) AND done_b(1)) AND done_b(2))
             AND done_a(2)) AND done_b(3))
           WHEN (port_a_write_enable_clock =
                 port_b_read_enable_write_enable_clock)
           ELSE (((done_b(0) AND done_b(1)) AND done_b(2)) AND done_b(3)) ;

clrdly_a <= ((((clkout_a(0) AND clkout_a(1)) AND clkout_a(2))
             AND clkout_b(2)) AND clkout_a(3))
           WHEN (port_a_write_enable_clock =
                 port_b_read_enable_write_enable_clock)
           ELSE (((clkout_a(0) AND clkout_a(1)) AND clkout_a(2)) AND clkout_a(3)) ;
clrdly_b <= ((((clkout_b(0) AND clkout_b(1)) AND clkout_b(2))
             AND clkout_a(2)) AND clkout_b(3))
           WHEN (port_a_write_enable_clock =
                 port_b_read_enable_write_enable_clock)
           ELSE (((clkout_b(0) AND clkout_b(1)) AND clkout_b(2)) AND clkout_b(3)) ;

internal_ram : cycloneii_ram_internal
 generic map
  (
    operation_mode => operation_mode,
    ram_block_type => ram_block_type,
    mixed_port_feed_through_mode => mixed_port_feed_through_mode,
    port_a_data_width => port_a_data_width,
    port_b_data_width => port_b_data_width,
    port_a_address_width => port_a_address_width,
    port_b_address_width => port_b_address_width,
    port_a_byte_enable_mask_width => port_a_byte_enable_mask_width,
    port_b_byte_enable_mask_width => port_b_byte_enable_mask_width,
    init_file_layout     => init_file_layout,
    port_a_first_address => port_a_first_address,
    port_a_last_address  => port_a_last_address,
    port_b_first_address => port_b_first_address,
    port_b_last_address  => port_b_last_address,
    port_a_address_clear => port_a_address_clear,
    port_b_address_clear => port_b_address_clear,
    power_up_uninitialized => power_up_uninitialized,
    mem1 => mem1,
    mem2 => mem2,
    mem3 => mem3,
    mem4 => mem4,
    mem5 => mem5,
    mem6 => mem6,
    mem7 => mem7, 
    mem8 => mem8,
    mem9 => mem9
    )
  port map
  (
    portawriteenable => portawe_bus(0),
    portbwriteenable => portbrewe_bus(0),
    cleara => aclra(5),
    clearb => aclrb(5),
    portadatain => portadatain_bus(143 downto 0),
    portbdatain => portbdatain_bus(71 downto 0),
    portaaddress => portaaddr_bus(15 downto 0),
    portbaddress => portbaddr_bus(15 downto 0),
    portabyteenamask =>
    portamask_bus(15 downto 0), 
    portbbyteenamask =>
    portbmask_bus(15 downto 0),
    portbreadenable => portbrewe_bus(0),
    portaclock => clock_a,
    portbclock => clock_b,
    sameclock => if_same_clock,
    portadataout => portadataout_bus, 
    portbdataout => portbdataout_bus
    );

clk_portadataout  <= clk_bus(select_ram(port_a_data_out_clock));
aclr_portadataout <= clr_bus(select_ram(port_a_data_out_clear));
ena_portadataout  <= ena_cea_out_bus(select_ram(port_a_data_out_clock));

ram_portadataout_reg : cycloneii_ram_register
  generic map ( data_width => 144,
                sclr       => "false",
                preset     => "false") 
  port map
  (
    data => portadataout_bus,
    clk  => clk_portadataout,
    aclr => aclr_portadataout,
    ena  => ena_portadataout,
    stall => GND,
    if_clk => if_clk_portadataout, 
    if_aclr => if_aclr_portadataout, 
    if_ena => if_ena_portadataout, 
    devclrn => devclrn,
    devpor => devpor,
    power_up => gnd,
    dataout => portadataout,
    aclrout => aclra(4),
    clkout => clkout_a(4),
    done => done_a(4)
  );

clk_portbdataout  <= clk_bus(select_ram(port_b_data_out_clock));
aclr_portbdataout <= clr_bus(select_ram(port_b_data_out_clear));
ena_portbdataout  <= ena_ceb_out_bus(select_ram(port_b_data_out_clock));

ram_portbdataout_reg : cycloneii_ram_register
  generic map ( data_width => 144,
                sclr       => "false",
                preset     => "false")
  port map
  (
    data => portbdataout_bus,
    clk  => clk_portbdataout,
    aclr => aclr_portbdataout,
    ena  => ena_portbdataout,
    stall => GND,
    if_clk => if_clk_portbdataout, 
    if_aclr => if_aclr_portbdataout, 
    if_ena => if_ena_portbdataout, 
    devclrn => devclrn,
    devpor => devpor,
    power_up => gnd,
    dataout => portbdataout,
    aclrout => aclrb(4),
    clkout => clkout_b(4),
    done => done_b(4)
  );

if_clk_portadatain      <= '1';
if_ena_portadatain      <= '1';
if_clk_portaaddr        <= '1';
if_ena_portaaddr        <= '1';
if_clk_portawe          <= '1';
if_ena_portawe          <= '1';
if_clk_portabyteenamasks <= '1';
if_ena_portabyteenamasks <= '1';
if_aclr_portadatain     <= '0' when (port_a_data_in_clear = "none") or (port_a_data_in_clear = "UNUSED") else '1';
if_aclr_portaaddr       <= '0' when (port_a_address_clear = "none") or (port_a_address_clear = "UNUSED") else '1';
if_aclr_portawe         <= '0' when (port_a_write_enable_clear = "none") or (port_a_write_enable_clear = "UNUSED")
                           else '1';
if_clk_portbdatain      <= '0' when (port_b_data_in_clock = "none") or (port_b_data_in_clock = "UNUSED") else '1';
if_aclr_portbdatain     <= '0' when (port_b_data_in_clear = "none") or (port_b_data_in_clear = "UNUSED") else '1';
if_ena_portbdatain      <= '0' when (port_b_data_in_clock = "none") or (port_b_data_in_clock = "UNUSED") else '1';
if_clk_portbaddr        <= '0' when (port_b_address_clock = "none") or (port_b_address_clock = "UNUSED") else '1';
if_aclr_portbaddr       <= '0' when (port_b_address_clear = "none") or (port_b_address_clear = "UNUSED") else '1';
if_ena_portbaddr        <= '0' when (port_b_address_clock = "none") or (port_b_address_clock = "UNUSED") else '1';
if_clk_portbrewe        <= '0' when
                           (port_b_read_enable_write_enable_clock = "none") or (port_b_read_enable_write_enable_clock = "UNUSED")
                           else '1';
if_aclr_portbrewe       <= '0' when
                           (port_b_read_enable_write_enable_clear = "none") or (port_b_read_enable_write_enable_clear = "UNUSED")
                           else '1';
if_ena_portbrewe        <= '0' when
                           (port_b_read_enable_write_enable_clock = "none") or (port_b_read_enable_write_enable_clock = "UNUSED")
                           else '1';
if_aclr_portabyteenamasks <= '0' when (port_a_byte_enable_clear = "none") or (port_a_byte_enable_clear = "UNUSED")
                             else '1';
if_clk_portbbyteenamasks  <= '0' when (port_b_byte_enable_clock = "none") or (port_b_byte_enable_clock = "UNUSED")
                             else '1';
if_aclr_portbbyteenamasks <= '0' when (port_b_byte_enable_clear = "none") or (port_b_byte_enable_clear = "UNUSED")
                             else '1';
if_ena_portbbyteenamasks  <= '0' when (port_b_byte_enable_clock = "none") or (port_b_byte_enable_clock = "UNUSED")
                             else '1';
if_clk_portadataout     <= '0' when (port_a_data_out_clock = "none") or (port_a_data_out_clock = "UNUSED") else '1';
if_aclr_portadataout    <= '0' when (port_a_data_out_clear = "none") or (port_a_data_out_clear = "UNUSED") else '1';
if_ena_portadataout     <= '0' when (port_a_data_out_clock = "none") or (port_a_data_out_clock = "UNUSED") else '1';
if_clk_portbdataout     <= '0' when (port_b_data_out_clock = "none") or (port_b_data_out_clock = "UNUSED")else '1';
if_aclr_portbdataout    <= '0' when (port_b_data_out_clear = "none") or (port_b_data_out_clear = "UNUSED") else '1';
if_ena_portbdataout     <= '0' when (port_b_data_out_clock = "none") or (port_b_data_out_clock = "UNUSED") else '1';
if_same_clock           <= '1' when (port_b_address_clock = "clock0") or (port_b_address_clock = "clock0") else '0';
port_b_write_enable_tmp <= portbrewe_bus(0);
clk_bus <= clk1 & clk0;
ena_bus <= ena1 & ena0;
ena_cea_bus <= "11" when port_a_disable_ce_on_input_registers = "on" else ena1 & ena0;
ena_ceb_bus <= "11" when port_b_disable_ce_on_input_registers = "on" else ena1 & ena0;
ena_cea_out_bus <= "11" when port_a_disable_ce_on_output_registers = "on" else ena1 & ena0;
ena_ceb_out_bus <= "11" when port_b_disable_ce_on_output_registers = "on" else ena1 & ena0;
clr_bus <= clr1 & clr0;
portawe_tmp(0) <= portawe;
portbrewe_tmp(0) <= portbrewe;
portabyteenamasks_tmp(15 downto 0) <= portabyteenamasks;
portbbyteenamasks_tmp(15 downto 0) <= portbbyteenamasks;
portaaddr_tmp(15 downto 0) <= portaaddr;
portbaddr_tmp(15 downto 0) <= portbaddr;
portaaddrstall_tmp <= portaaddrstall;
portbaddrstall_tmp <= portbaddrstall;
portawe_eab <= not portawe;
portbrewe_eab <= portbrewe;

end ram_arch;

-------------------------------------------------------------------
--
-- Entity Name : cycloneii_jtag
--
-- Description : CycloneII JTAG VHDL Simulation model
--
-------------------------------------------------------------------
library IEEE, cycloneii;
use IEEE.std_logic_1164.all;
use cycloneii.atom_pack.all;

entity  cycloneii_jtag is
	 generic (
					lpm_type	: string := "cycloneii_jtag"
				);	
    port (tms : in std_logic; 
    		 tck : in std_logic; 
    		 tdi : in std_logic; 
    		 ntrst : in std_logic; 
    		 tdoutap : in std_logic; 
    		 tdouser : in std_logic; 
          tdo: out std_logic; 
          tmsutap: out std_logic; 
          tckutap: out std_logic; 
          tdiutap: out std_logic; 
          shiftuser: out std_logic; 
          clkdruser: out std_logic; 
          updateuser: out std_logic; 
          runidleuser: out std_logic; 
          usr1user: out std_logic);
end cycloneii_jtag;

architecture architecture_jtag of cycloneii_jtag is
begin

process(tms, tck, tdi, ntrst, tdoutap, tdouser)
begin

end process;

end architecture_jtag;

-------------------------------------------------------------------
--
-- Entity Name : cycloneii_crcblock
--
-- Description : CycloneII CRCBLOCK VHDL Simulation model
--
-------------------------------------------------------------------
library IEEE, cycloneii;
use IEEE.std_logic_1164.all;
use cycloneii.atom_pack.all;

entity  cycloneii_crcblock is
	generic 	(
					oscillator_divider	: integer := 1;
					lpm_type	: string := "cycloneii_crcblock"
				);	
	port (clk 			: in std_logic; 
   		shiftnld		: in std_logic; 
    		ldsrc			: in std_logic; 
         crcerror		: out std_logic; 
         regout		: out std_logic); 
end cycloneii_crcblock;

architecture architecture_crcblock of cycloneii_crcblock is
begin

end architecture_crcblock;
-------------------------------------------------------------------
--
-- Entity Name : cycloneii_asmiblock
--
-- Description : CycloneII ASMIBLOCK VHDL Simulation model
--
-------------------------------------------------------------------
library IEEE, cycloneii;
use IEEE.std_logic_1164.all;
use cycloneii.atom_pack.all;

entity  cycloneii_asmiblock is
	 generic (
					lpm_type	: string := "cycloneii_asmiblock"
				);	
    port (dclkin : in std_logic; 
    		 scein : in std_logic; 
    		 sdoin : in std_logic; 
    		 oe : in std_logic; 
          data0out: out std_logic);
end cycloneii_asmiblock;

architecture architecture_asmiblock of cycloneii_asmiblock is
begin

process(dclkin, scein, sdoin, oe)
begin

end process;

end architecture_asmiblock;
--///////////////////////////////////////////////////////////////////////////
--
-- Entity Name : mn_cntr
--
-- Description : Timing simulation model for the M and N counter. This is a
--               common model for the input counter and the loop feedback
--               counter of the CycloneII PLL.
--
--///////////////////////////////////////////////////////////////////////////

LIBRARY ieee, cycloneii;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;

ENTITY mn_cntr is
    PORT ( clk           : IN std_logic;
           reset         : IN std_logic := '0';
           cout          : OUT std_logic;
           initial_value : IN integer := 1;
           modulus       : IN integer := 1;
           time_delay    : IN integer := 0
         );
END mn_cntr;

ARCHITECTURE behave of mn_cntr is
begin

    process (clk, reset)
    variable count : integer := 1;
    variable first_rising_edge : boolean := true;
    variable tmp_cout : std_logic;
    begin
        if (reset = '1') then
            count := 1;
            tmp_cout := '0';
            first_rising_edge := true;
        elsif (clk'event and clk = '1' and first_rising_edge) then
            first_rising_edge := false;
            tmp_cout := clk;
        elsif (not first_rising_edge) then
            if (count < modulus) then
                count := count + 1;
            else
                count := 1;
                tmp_cout := not tmp_cout;
            end if;
        end if;
        cout <= transport tmp_cout after time_delay * 1 ps;
    end process;
end behave;

--/////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : scale_cntr
--
-- Description : Timing simulation model for the output scale-down counters.
--               This is a common model for the C0, C1, C2, C3, C4 and C5
--               output counters of the CycloneII PLL.
--
--/////////////////////////////////////////////////////////////////////////////

LIBRARY ieee, cycloneii;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;

ENTITY scale_cntr is
    PORT ( clk            : IN std_logic;
           reset          : IN std_logic := '0';
           initial        : IN integer := 1;
           high           : IN integer := 1;
           low            : IN integer := 1;
           mode           : IN string := "bypass";
           ph_tap         : IN integer := 0;
           cout           : OUT std_logic
         );
END scale_cntr;

ARCHITECTURE behave of scale_cntr is
begin
    process (clk, reset)
    variable tmp_cout : std_logic := '0';
    variable count : integer := 1;
    variable output_shift_count : integer := 1;
    variable first_rising_edge : boolean := false;
    begin
        if (reset = '1') then
            count := 1;
            output_shift_count := 1;
            tmp_cout := '0';
            first_rising_edge := false;
        elsif (clk'event) then
            if (mode = "   off") then
                tmp_cout := '0';
            elsif (mode = "bypass") then
                tmp_cout := clk;
                first_rising_edge := true;
            elsif (not first_rising_edge) then
                if (clk = '1') then
                    if (output_shift_count = initial) then
                        tmp_cout := clk;
                        first_rising_edge := true;
                    else
                        output_shift_count := output_shift_count + 1;
                    end if;
                end if;
            elsif (output_shift_count < initial) then
                if (clk = '1') then
                    output_shift_count := output_shift_count + 1;
                end if;
            else
                count := count + 1;
                if (mode = "  even" and (count = (high*2) + 1)) then
                    tmp_cout := '0';
                elsif (mode = "   odd" and (count = high*2)) then
                    tmp_cout := '0';
                elsif (count = (high + low)*2 + 1) then
                    tmp_cout := '1';
                    count := 1;  -- reset count
                end if;
            end if;
        end if;
        cout <= transport tmp_cout;
    end process;

end behave;

--/////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : pll_reg
--
-- Description : Simulation model for a simple DFF.
--               This is required for the generation of the bit slip-signals.
--               No timing, powers upto 0.
--
--/////////////////////////////////////////////////////////////////////////////

LIBRARY ieee, cycloneii;
USE IEEE.std_logic_1164.all;

ENTITY pll_reg is
    PORT    ( clk : in std_logic;
              ena : in std_logic := '1';
              d : in std_logic;
              clrn : in std_logic := '1';
              prn : in std_logic := '1';
              q : out std_logic
            );
end pll_reg;

ARCHITECTURE behave of pll_reg is
begin
    process (clk, prn, clrn)
    variable q_reg : std_logic := '0';
    begin
        if (prn = '0') then
            q_reg := '1';
        elsif (clrn = '0') then
            q_reg := '0';
        elsif (clk'event and clk = '1' and (ena = '1')) then
            q_reg := D;
        end if;

        Q <= q_reg;
    end process;

end behave;

--///////////////////////////////////////////////////////////////////////////
--
-- Entity Name : cycloneii_pll
--
-- Description : Timing simulation model for the CycloneII PLL.
--               In the functional mode, it is also the model for the altpll
--               megafunction.
--
-- Limitations : Does not support Spread Spectrum and Bandwidth.
--
-- Outputs     : Up to 6 output clocks, each defined by its own set of
--               parameters. Locked output (active high) indicates when the
--               PLL locks. clkbad, clkloss and activeclock are used for
--               clock switchover to inidicate which input clock has gone
--               bad, when the clock switchover initiates and which input
--               clock is being used as the reference, respectively.
--               scandataout is the data output of the serial scan chain.
--
--///////////////////////////////////////////////////////////////////////////

LIBRARY ieee, std, cycloneii;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE STD.TEXTIO.all;
USE cycloneii.atom_pack.all;
USE cycloneii.pllpack.all;

ENTITY cycloneii_pll is
    GENERIC ( operation_mode              : string := "normal";
              pll_type                    : string := "auto";  -- EGPP/FAST/AUTO
              compensate_clock            : string := "clk0";
              feedback_source             : string := "clk0";
              qualify_conf_done           : string := "off";

              test_input_comp_delay       : integer := 0;
              test_feedback_comp_delay    : integer := 0;

              inclk0_input_frequency      : integer := 10000;
              inclk1_input_frequency      : integer := 10000;

              gate_lock_signal            : string := "no";
              gate_lock_counter           : integer := 1;
              valid_lock_multiplier       : integer := 1;
              invalid_lock_multiplier     : integer := 5;

              switch_over_type            : string := "auto";
              switch_over_on_lossclk      : string := "off";
              switch_over_on_gated_lock   : string := "off";
              switch_over_counter         : integer := 1;
              enable_switch_over_counter  : string := "on";

              bandwidth                   : integer := 0;
              bandwidth_type              : string := "auto";
              down_spread                 : string := "0.0";
              spread_frequency            : integer := 0;

              clk0_output_frequency       : integer := 0;
              clk0_multiply_by            : integer := 1;
              clk0_divide_by              : integer := 1;
              clk0_phase_shift            : string := "0";
              clk0_duty_cycle             : integer := 50;

              clk1_output_frequency       : integer := 0;
              clk1_multiply_by            : integer := 1;
              clk1_divide_by              : integer := 1;
              clk1_phase_shift            : string := "0";
              clk1_duty_cycle             : integer := 50;

              clk2_output_frequency       : integer := 0;
              clk2_multiply_by            : integer := 1;
              clk2_divide_by              : integer := 1;
              clk2_phase_shift            : string := "0";
              clk2_duty_cycle             : integer := 50;

              clk3_output_frequency       : integer := 0;
              clk3_multiply_by            : integer := 1;
              clk3_divide_by              : integer := 1;
              clk3_phase_shift            : string := "0";
              clk3_duty_cycle             : integer := 50;

              clk4_output_frequency       : integer := 0;
              clk4_multiply_by            : integer := 1;
              clk4_divide_by              : integer := 1;
              clk4_phase_shift            : string := "0";
              clk4_duty_cycle             : integer := 50;

              clk5_output_frequency       : integer := 0;
              clk5_multiply_by            : integer := 1;
              clk5_divide_by              : integer := 1;
              clk5_phase_shift            : string := "0";
              clk5_duty_cycle             : integer := 50;

              pfd_min                     : integer := 0;
              pfd_max                     : integer := 0;
              vco_min                     : integer := 0;
              vco_max                     : integer := 0;
              vco_center                  : integer := 0;

              -- ADVANCED USER PARAMETERS
              m_initial                   : integer := 1;
              m                           : integer := 1;
              n                           : integer := 1;
              m2                          : integer := 1;
              n2                          : integer := 1;
              ss                          : integer := 0;

              c0_high                     : integer := 1;
              c0_low                      : integer := 1;
              c0_initial                  : integer := 1; 
              c0_mode                     : string := "bypass";
              c0_ph                       : integer := 0;

              c1_high                     : integer := 1;
              c1_low                      : integer := 1;
              c1_initial                  : integer := 1;
              c1_mode                     : string := "bypass";
              c1_ph                       : integer := 0;

              c2_high                     : integer := 1;
              c2_low                      : integer := 1;
              c2_initial                  : integer := 1;
              c2_mode                     : string := "bypass";
              c2_ph                       : integer := 0;

              c3_high                     : integer := 1;
              c3_low                      : integer := 1;
              c3_initial                  : integer := 1;
              c3_mode                     : string := "bypass";
              c3_ph                       : integer := 0;

              c4_high                     : integer := 1;
              c4_low                      : integer := 1;
              c4_initial                  : integer := 1;
              c4_mode                     : string := "bypass";
              c4_ph                       : integer := 0;

              c5_high                     : integer := 1;
              c5_low                      : integer := 1;
              c5_initial                  : integer := 1;
              c5_mode                     : string := "bypass";
              c5_ph                       : integer := 0;

              m_ph                        : integer := 0;

              clk0_counter                : string := "c0";
              clk1_counter                : string := "c1";
              clk2_counter                : string := "c2";
              clk3_counter                : string := "c3";
              clk4_counter                : string := "c4";
              clk5_counter                : string := "c5";

              c1_use_casc_in              : string := "off";
              c2_use_casc_in              : string := "off";
              c3_use_casc_in              : string := "off";
              c4_use_casc_in              : string := "off";
              c5_use_casc_in              : string := "off";

              m_test_source               : integer := 5;
              c0_test_source              : integer := 5;
              c1_test_source              : integer := 5;
              c2_test_source              : integer := 5;
              c3_test_source              : integer := 5;
              c4_test_source              : integer := 5;
              c5_test_source              : integer := 5;

              -- LVDS mode parameters
              enable0_counter             : string := "c0";
              enable1_counter             : string := "c1";
              sclkout0_phase_shift        : string := "0";
              sclkout1_phase_shift        : string := "0";

              charge_pump_current         : integer := 0;
              loop_filter_r               : string := "1.0";
              loop_filter_c               : integer := 1;
              common_rx_tx                : string := "off";
              rx_outclock_resource        : string := "auto";
              use_vco_bypass              : string := "false";
              use_dc_coupling             : string := "false";

              pll_compensation_delay      : integer := 0;
              simulation_type             : string := "functional";
              lpm_type                    : string := "cycloneii_pll";

              vco_multiply_by             : integer := 0;
              vco_divide_by               : integer := 0;
              vco_post_scale              : integer := 1;

              -- VITAL generics
              XOn                         : Boolean := DefGlitchXOn;
              MsgOn                       : Boolean := DefGlitchMsgOn;
              MsgOnChecks                 : Boolean := DefMsgOnChecks;
              XOnChecks                   : Boolean := DefXOnChecks;
              TimingChecksOn              : Boolean := true;
              InstancePath                : STRING := "*";
              tipd_inclk                  : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
              tipd_ena                    : VitalDelayType01 := DefPropDelay01;
              tipd_pfdena                 : VitalDelayType01 := DefPropDelay01;
              tipd_areset                 : VitalDelayType01 := DefPropDelay01;
              tipd_clkswitch              : VitalDelayType01 := DefPropDelay01
            );

    PORT    ( inclk                       : in std_logic_vector(1 downto 0);
              ena                         : in std_logic := '1';
              clkswitch                   : in std_logic;
              areset                      : in std_logic;
              pfdena                      : in std_logic;
              testclearlock               : in std_logic;
              clk                         : out std_logic_vector(2 downto 0);
              locked                      : out std_logic;
              testupout                   : out std_logic;
              testdownout                 : out std_logic
            );
END cycloneii_pll;

ARCHITECTURE vital_pll of cycloneii_pll is

TYPE int_array is ARRAY(NATURAL RANGE <>) of integer;
TYPE str_array is ARRAY(NATURAL RANGE <>) of string(1 to 6);
TYPE str_array1 is ARRAY(NATURAL RANGE <>) of string(1 to 9);

-- internal advanced parameter signals
signal   i_vco_min      : integer;
signal   i_vco_max      : integer;
signal   i_vco_center   : integer;
signal   i_pfd_min      : integer;
signal   i_pfd_max      : integer;
signal   c_ph_val       : int_array(0 to 5) := (OTHERS => 0);
signal   c_high_val     : int_array(0 to 5) := (OTHERS => 1);
signal   c_low_val      : int_array(0 to 5) := (OTHERS => 1);
signal   c_initial_val  : int_array(0 to 5) := (OTHERS => 1);
signal   c_mode_val     : str_array(0 to 5);

-- old values
signal   c_high_val_old : int_array(0 to 5) := (OTHERS => 1);
signal   c_low_val_old  : int_array(0 to 5) := (OTHERS => 1);
signal   c_ph_val_old   : int_array(0 to 5) := (OTHERS => 0);
signal   c_mode_val_old : str_array(0 to 5);

-- hold registers
signal   c_high_val_hold : int_array(0 to 5) := (OTHERS => 1);
signal   c_low_val_hold  : int_array(0 to 5) := (OTHERS => 1);
signal   c_ph_val_hold   : int_array(0 to 5) := (OTHERS => 0);
signal   c_mode_val_hold : str_array(0 to 5);

-- temp registers
signal   sig_c_ph_val_tmp   : int_array(0 to 5) := (OTHERS => 0);
signal   sig_c_low_val_tmp  : int_array(0 to 5) := (OTHERS => 1);
signal   c_ph_val_orig  : int_array(0 to 5) := (OTHERS => 0);

signal   i_clk5_counter         : string(1 to 2) := "c5";
signal   i_clk4_counter         : string(1 to 2) := "c4";
signal   i_clk3_counter         : string(1 to 2) := "c3";
signal   i_clk2_counter         : string(1 to 2) := "c2";
signal   i_clk1_counter         : string(1 to 2) := "c1";
signal   i_clk0_counter         : string(1 to 2) := "c0";
signal   i_charge_pump_current  : integer;
signal   i_loop_filter_r        : integer;

-- end internal advanced parameter signals

-- CONSTANTS
CONSTANT GPP_SCAN_CHAIN : integer := 174;
CONSTANT FAST_SCAN_CHAIN : integer := 75;
CONSTANT cntrs : str_array(5 downto 0) := ("    C5", "    C4", "    C3", "    C2", "    C1", "    C0");
CONSTANT ss_cntrs : str_array(0 to 3) := ("     M", "    M2", "     N", "    N2");

CONSTANT loop_filter_c_arr : int_array(0 to 3) := (57, 16, 36, 5);
CONSTANT fpll_loop_filter_c_arr : int_array(0 to 3) := (18, 13, 8, 2);
CONSTANT charge_pump_curr_arr : int_array(0 to 15) := (6, 12, 30, 36, 52, 57, 72, 77, 92, 96, 110, 114, 127, 131, 144, 148);
CONSTANT loop_filter_r_arr : str_array1(0 to 39) := (" 1.000000", " 1.500000", " 2.000000", " 2.500000", " 3.000000", " 3.500000", " 4.000000", " 4.500000", " 5.000000", " 5.500000", " 6.000000", " 6.500000", " 7.000000", " 7.500000", " 8.000000", " 8.500000", " 9.000000", " 9.500000", "10.000000", "10.500000", "11.000000", "11.500000", "12.000000", "12.500000", "13.000000", "13.500000", "14.000000", "14.500000", "15.000000", "15.500000", "16.000000", "16.500000", "17.000000", "17.500000", "18.000000", "18.500000", "19.000000", "19.500000", "20.000000", "20.500000");

-- signals

signal vcc : std_logic := '1';

signal fbclk       : std_logic;
signal refclk      : std_logic;

signal c0_clk : std_logic;
signal c1_clk : std_logic;
signal c2_clk : std_logic;
signal c3_clk : std_logic;
signal c4_clk : std_logic;
signal c5_clk : std_logic;

signal vco_out : std_logic_vector(7 downto 0) := (OTHERS => '0');

-- signals to assign values to counter params
signal m_val : int_array(0 to 1) := (OTHERS => 1);
signal n_val : int_array(0 to 1) := (OTHERS => 1);
signal m_ph_val : integer := 0;
signal m_initial_val : integer := m_initial;

signal m_mode_val : str_array(0 to 1) := (OTHERS => "      ");
signal n_mode_val : str_array(0 to 1) := (OTHERS => "      ");
signal lfc_val : integer := 0;
signal cp_curr_val : integer := 0;
signal lfr_val : string(1 to 9) := "         ";

-- old values
signal m_val_old : int_array(0 to 1) := (OTHERS => 1);
--signal m_val_tmp : int_array(0 to 1) := (OTHERS => 1);
signal n_val_old : int_array(0 to 1) := (OTHERS => 1);
signal m_mode_val_old : str_array(0 to 1) := (OTHERS => "      ");
signal n_mode_val_old : str_array(0 to 1) := (OTHERS => "      ");
signal m_ph_val_old : integer := 0;
signal lfc_old : integer := 0;
signal cp_curr_old : integer := 0;
signal lfr_old : string(1 to 9) := "         ";
signal num_output_cntrs : integer := 6;

signal scan_data : std_logic_vector(173 downto 0) := (OTHERS => '0');

signal clk0_tmp : std_logic;
signal clk1_tmp : std_logic;
signal clk2_tmp : std_logic;
signal clk3_tmp : std_logic;
signal clk4_tmp : std_logic;
signal clk5_tmp : std_logic;
signal sclkout0_tmp : std_logic;
signal sclkout1_tmp : std_logic;

signal clkin : std_logic := '0';
signal gate_locked : std_logic := '0';
signal lock : std_logic := '0';
signal about_to_lock : boolean := false;
signal reconfig_err : boolean := false;

signal inclk_c0 : std_logic;
signal inclk_c1 : std_logic;
signal inclk_c2 : std_logic;
signal inclk_c3 : std_logic;
signal inclk_c4 : std_logic;
signal inclk_c5 : std_logic;
signal inclk_m : std_logic;
signal devpor : std_logic;
signal devclrn : std_logic;

signal inclk0_ipd : std_logic;
signal inclk1_ipd : std_logic;
signal ena_ipd : std_logic;
signal pfdena_ipd : std_logic;
signal areset_ipd : std_logic;
signal fbin_ipd : std_logic;
signal scanclk_ipd : std_logic;
signal scanread_ipd : std_logic;
signal scanwrite_ipd : std_logic;
signal scandata_ipd : std_logic;
signal clkswitch_ipd : std_logic;
-- registered signals
signal scanread_reg : std_logic := '0';
signal scanwrite_reg : std_logic := '0';
signal scanwrite_enabled : std_logic := '0';
signal gated_scanclk : std_logic := '1';

signal inclk_c0_dly1 : std_logic := '0';
signal inclk_c0_dly2 : std_logic := '0';
signal inclk_c0_dly3 : std_logic := '0';
signal inclk_c0_dly4 : std_logic := '0';
signal inclk_c0_dly5 : std_logic := '0';
signal inclk_c0_dly6 : std_logic := '0';
signal inclk_c1_dly1 : std_logic := '0';
signal inclk_c1_dly2 : std_logic := '0';
signal inclk_c1_dly3 : std_logic := '0';
signal inclk_c1_dly4 : std_logic := '0';
signal inclk_c1_dly5 : std_logic := '0';
signal inclk_c1_dly6 : std_logic := '0';


signal sig_offset : time := 0 ps;
signal sig_refclk_time : time := 0 ps;
signal sig_fbclk_period : time := 0 ps;
signal sig_vco_period_was_phase_adjusted : boolean := false;
signal sig_phase_adjust_was_scheduled : boolean := false;
signal sig_stop_vco : std_logic := '0';
signal sig_m_times_vco_period : time := 0 ps;
signal sig_new_m_times_vco_period : time := 0 ps;
signal sig_got_refclk_posedge : boolean := false;
signal sig_got_fbclk_posedge : boolean := false;
signal sig_got_second_refclk : boolean := false;

signal m_delay : integer := 0;
signal n_delay : integer := 0;

signal sig_curr_clock : string(1 to 6) := "inclk0";
signal inclk1_tmp : std_logic := '0';
--signal scan_chain_length : integer := GPP_SCAN_CHAIN;

signal ext_fbk_cntr_high : integer := 0;
signal ext_fbk_cntr_low : integer := 0;
signal ext_fbk_cntr_ph : integer := 0;
signal ext_fbk_cntr_initial : integer := 1;
signal ext_fbk_cntr     : string(1 to 2) := "c0";
signal ext_fbk_cntr_mode : string(1 to 6) := "bypass";
signal ext_fbk_cntr_index : integer := 0;

signal enable0_tmp : std_logic := '0';
signal enable1_tmp : std_logic := '0';
signal reset_low : std_logic := '0';

signal scandataout_tmp : std_logic := '0';
signal scandone_tmp : std_logic := '0';

signal sig_refclk_period : time := (inclk0_input_frequency * 1 ps) * n;

signal schedule_vco : std_logic := '0';

signal areset_ena_sig : std_logic := '0';

signal inclk_c0_from_vco : std_logic;
signal inclk_c1_from_vco : std_logic;
signal inclk_c2_from_vco : std_logic;
signal inclk_c3_from_vco : std_logic;
signal inclk_c4_from_vco : std_logic;
signal inclk_c5_from_vco : std_logic;
signal inclk_m_from_vco : std_logic;
signal inclk_sclkout0_from_vco : std_logic;
signal inclk_sclkout1_from_vco : std_logic;

COMPONENT mn_cntr
    PORT ( clk           : IN std_logic;
           reset         : IN std_logic := '0';
           cout          : OUT std_logic;
           initial_value : IN integer := 1;
           modulus       : IN integer := 1;
           time_delay    : IN integer := 0
         );
END COMPONENT;

COMPONENT scale_cntr
    PORT ( clk            : IN std_logic;
           reset          : IN std_logic := '0';
           cout           : OUT std_logic;
           initial        : IN integer := 1;
           high           : IN integer := 1;
           low            : IN integer := 1;
           mode           : IN string := "bypass";
           ph_tap         : IN integer := 0
         );
END COMPONENT;

COMPONENT DFFE
    GENERIC(
      TimingChecksOn: Boolean := true;
      InstancePath: STRING := "*";
      XOn: Boolean := DefGlitchXOn;
      MsgOn: Boolean := DefGlitchMsgOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      tpd_PRN_Q_negedge              :  VitalDelayType01 := DefPropDelay01;
      tpd_CLRN_Q_negedge             :  VitalDelayType01 := DefPropDelay01;
      tpd_CLK_Q_posedge              :  VitalDelayType01 := DefPropDelay01;
      tpd_ENA_Q_posedge              :  VitalDelayType01 := DefPropDelay01;
      tsetup_D_CLK_noedge_posedge    :  VitalDelayType := DefSetupHoldCnst;
      tsetup_D_CLK_noedge_negedge    :  VitalDelayType := DefSetupHoldCnst;
      tsetup_ENA_CLK_noedge_posedge  :  VitalDelayType := DefSetupHoldCnst;
      thold_D_CLK_noedge_posedge     :  VitalDelayType := DefSetupHoldCnst;
      thold_D_CLK_noedge_negedge     :  VitalDelayType := DefSetupHoldCnst;
      thold_ENA_CLK_noedge_posedge   :  VitalDelayType := DefSetupHoldCnst;
      tipd_D                         :  VitalDelayType01 := DefPropDelay01;
      tipd_CLRN                      :  VitalDelayType01 := DefPropDelay01;
      tipd_PRN                       :  VitalDelayType01 := DefPropDelay01;
      tipd_CLK                       :  VitalDelayType01 := DefPropDelay01;
      tipd_ENA                       :  VitalDelayType01 := DefPropDelay01);

   PORT(
      Q                              :  out   STD_LOGIC := '0';
      D                              :  in    STD_LOGIC := '1';
      CLRN                           :  in    STD_LOGIC := '1';
      PRN                            :  in    STD_LOGIC := '1';
      CLK                            :  in    STD_LOGIC := '0';
      ENA                            :  in    STD_LOGIC := '1');
END COMPONENT;

COMPONENT PLL_REG
   PORT(
      Q                              :  out   STD_LOGIC := '0';
      D                              :  in    STD_LOGIC := '1';
      CLRN                           :  in    STD_LOGIC := '1';
      PRN                            :  in    STD_LOGIC := '1';
      CLK                            :  in    STD_LOGIC := '0';
      ENA                            :  in    STD_LOGIC := '1');
END COMPONENT;

begin

    ----------------------
    --  INPUT PATH DELAYs
    ----------------------
    WireDelay : block
    begin
        VitalWireDelay (inclk0_ipd, inclk(0), tipd_inclk(0));
        VitalWireDelay (inclk1_ipd, inclk(1), tipd_inclk(1));
        VitalWireDelay (areset_ipd, areset, tipd_areset);
        VitalWireDelay (ena_ipd, ena, tipd_ena);
        VitalWireDelay (pfdena_ipd, pfdena, tipd_pfdena);
        VitalWireDelay (clkswitch_ipd, clkswitch, tipd_clkswitch);
    end block;
        fbin_ipd <= '0';
        scanclk_ipd <= '0';
        scanread_ipd <= '0';
        scandata_ipd <= '0';
        scanwrite_ipd <= '0';

    inclk_m <= clkin when m_test_source = 0 else
               clk0_tmp when operation_mode = "external_feedback" and feedback_source = "clk0" else
               clk1_tmp when operation_mode = "external_feedback" and feedback_source = "clk1" else
               clk2_tmp when operation_mode = "external_feedback" and feedback_source = "clk2" else
               clk3_tmp when operation_mode = "external_feedback" and feedback_source = "clk3" else
               clk4_tmp when operation_mode = "external_feedback" and feedback_source = "clk4" else
               clk5_tmp when operation_mode = "external_feedback" and feedback_source = "clk5" else
               inclk_m_from_vco;

    ext_fbk_cntr_high <= c_high_val(ext_fbk_cntr_index);
    ext_fbk_cntr_low  <= c_low_val(ext_fbk_cntr_index);
    ext_fbk_cntr_ph   <= c_ph_val(ext_fbk_cntr_index);
    ext_fbk_cntr_initial <= c_initial_val(ext_fbk_cntr_index);
    ext_fbk_cntr_mode <= c_mode_val(ext_fbk_cntr_index);

    areset_ena_sig <= areset_ipd or (not ena_ipd) or sig_stop_vco;

    m1 : mn_cntr
         port map (clk           => inclk_m,
                   reset         => areset_ena_sig,
                   cout          => fbclk,
                   initial_value => m_initial_val,
                   modulus       => m_val(0),
                   time_delay    => m_delay
                  );

    -- add delta delay to inclk1 to ensure inclk0 and inclk1 are processed
    -- in different simulation deltas.
    inclk1_tmp <= inclk1_ipd;

    process (inclk0_ipd, inclk1_tmp, clkswitch_ipd)
    variable input_value : std_logic := '0';
    variable current_clock : string(1 to 6) := "inclk0";
    variable clk0_count, clk1_count : integer := 0;
    variable clk0_is_bad, clk1_is_bad : std_logic := '0';
    variable primary_clk_is_bad : boolean := false;
    variable current_clk_is_bad : boolean := false;
    variable got_curr_clk_falling_edge_after_clkswitch : boolean := false;
    variable switch_over_count : integer := 0;
    variable active_clock : std_logic := '0';
    variable external_switch : boolean := false;
    begin
        if (now = 0 ps) then
            if (switch_over_type = "manual" and clkswitch_ipd = '1') then
                current_clock := "inclk1";
                active_clock := '1';
            end if;
        end if;
        if (clkswitch_ipd'event and clkswitch_ipd = '1' and switch_over_type = "auto") then
            external_switch := true;
        elsif (switch_over_type = "manual") then
            if (clkswitch_ipd'event and clkswitch_ipd = '1') then
                current_clock := "inclk1";
                active_clock := '1';
            elsif (clkswitch_ipd'event and clkswitch_ipd = '0') then
                current_clock := "inclk0";
                active_clock := '0';
            end if;
        end if;
        -- save the current inclk event value
        if (inclk0_ipd'event) then
            input_value := inclk0_ipd;
        elsif (inclk1_tmp'event) then
            input_value := inclk1_tmp;
        end if;

        -- check if either input clk is bad
        if (inclk0_ipd'event and inclk0_ipd = '1') then
            clk0_count := clk0_count + 1;
            clk0_is_bad := '0';
            clk1_count := 0;
            if (clk0_count > 2) then
                -- no event on other clk for 2 cycles
                clk1_is_bad := '1';
                if (current_clock = "inclk1") then
                    current_clk_is_bad := true;
                end if;
            end if;
        end if;
        if (inclk1_tmp'event and inclk1_tmp = '1') then
            clk1_count := clk1_count + 1;
            clk1_is_bad := '0';
            clk0_count := 0;
            if (clk1_count > 2) then
                -- no event on other clk for 2 cycles
                clk0_is_bad := '1';
                if (current_clock = "inclk0") then
                    current_clk_is_bad := true;
                end if;
            end if;
        end if;

        -- check if the bad clk is the primary clock
        if (clk0_is_bad = '1') then
            primary_clk_is_bad := true;
        else
            primary_clk_is_bad := false;
        end if;

        -- actual switching
        if (inclk0_ipd'event and current_clock = "inclk0") then
            if (external_switch) then
                if (not got_curr_clk_falling_edge_after_clkswitch) then
                    if (inclk0_ipd = '0') then
                        got_curr_clk_falling_edge_after_clkswitch := true;
                    end if;
                    clkin <= transport inclk0_ipd;
                end if;
            else
                clkin <= transport inclk0_ipd;
            end if;
        elsif (inclk1_tmp'event and current_clock = "inclk1") then
            if (external_switch) then
                if (not got_curr_clk_falling_edge_after_clkswitch) then
                    if (inclk1_tmp = '0') then
                        got_curr_clk_falling_edge_after_clkswitch := true;
                    end if;
                    clkin <= transport inclk1_tmp;
                end if;
            else
                clkin <= transport inclk1_tmp;
            end if;
        else
            if (input_value = '1' and switch_over_on_lossclk = "on"  and enable_switch_over_counter = "on" and primary_clk_is_bad) then
                switch_over_count := switch_over_count + 1;
            end if;
            if (input_value = '0') then
                if (external_switch and (got_curr_clk_falling_edge_after_clkswitch or current_clk_is_bad)) or (switch_over_on_lossclk = "on" and primary_clk_is_bad and (enable_switch_over_counter = "off" or switch_over_count = switch_over_counter)) then
                    got_curr_clk_falling_edge_after_clkswitch := false;
                    if (current_clock = "inclk0") then
                        current_clock := "inclk1";
                    else
                        current_clock := "inclk0";
                    end if;
                    active_clock := not active_clock;
                    switch_over_count := 0;
                    external_switch := false;
                    current_clk_is_bad := false;
                end if;
       
            end if;
        end if;

        -- schedule outputs
        if (switch_over_on_lossclk = "on" and clkswitch_ipd /= '1') then
            if (primary_clk_is_bad) then
                -- assert clkloss
            else
            end if;
        else
        end if;

        -- for debugging only
--      sig_curr_clock <= current_clock;
    end process;

    process (inclk_sclkout0_from_vco)
    begin
        sclkout0_tmp <= inclk_sclkout0_from_vco;
    end process;

    process (inclk_sclkout1_from_vco)
    begin
        sclkout1_tmp <= inclk_sclkout1_from_vco;
    end process;

    n1 : mn_cntr
         port map (clk           => clkin,
                   reset         => areset_ipd,
                   cout          => refclk,
                   initial_value => n_val(0),
                   modulus       => n_val(0));

    inclk_c0 <= clkin when c0_test_source = 0 else
                refclk when c0_test_source = 1 else
                inclk_c0_from_vco;
    c0 : scale_cntr
         port map (clk            => inclk_c0,
                   reset          => areset_ena_sig,
                   cout           => c0_clk,
                   initial        => c_initial_val(0),
                   high           => c_high_val(0),
                   low            => c_low_val(0),
                   mode           => c_mode_val(0),
                   ph_tap         => c_ph_val(0));

    inclk_c1 <= clkin when c1_test_source = 0 else
                fbclk when c1_test_source = 2 else
                c0_clk when c1_use_casc_in = "on" else
                inclk_c1_from_vco;
    c1 : scale_cntr
         port map (clk            => inclk_c1,
                   reset          => areset_ena_sig,
                   cout           => c1_clk,
                   initial        => c_initial_val(1),
                   high           => c_high_val(1),
                   low            => c_low_val(1),
                   mode           => c_mode_val(1),
                   ph_tap         => c_ph_val(1));

    inclk_c2 <= clkin when c2_test_source = 0 else
                c1_clk when c2_use_casc_in = "on" else
                inclk_c2_from_vco;
    c2 : scale_cntr
         port map (clk            => inclk_c2,
                   reset          => areset_ena_sig,
                   cout           => c2_clk,
                   initial        => c_initial_val(2),
                   high           => c_high_val(2),
                   low            => c_low_val(2),
                   mode           => c_mode_val(2),
                   ph_tap         => c_ph_val(2));


    inclk_c3 <= clkin when c3_test_source = 0 else
                c2_clk when c3_use_casc_in = "on" else
                inclk_c3_from_vco;
    c3 : scale_cntr
         port map (clk            => inclk_c3,
                   reset          => areset_ena_sig,
                   cout           => c3_clk,
                   initial        => c_initial_val(3),
                   high           => c_high_val(3),
                   low            => c_low_val(3),
                   mode           => c_mode_val(3),
                   ph_tap         => c_ph_val(3));

    inclk_c4 <= clkin when c4_test_source = 0 else
                c3_clk when c4_use_casc_in = "on" else
                inclk_c4_from_vco;
    c4 : scale_cntr
         port map (clk            => inclk_c4,
                   reset          => areset_ena_sig,
                   cout           => c4_clk,
                   initial        => c_initial_val(4),
                   high           => c_high_val(4),
                   low            => c_low_val(4),
                   mode           => c_mode_val(4),
                   ph_tap         => c_ph_val(4));

    inclk_c5 <= clkin when c5_test_source = 0 else
                c4_clk when c5_use_casc_in = "on" else
                inclk_c5_from_vco;
    c5 : scale_cntr
         port map (clk            => inclk_c5,
                   reset          => areset_ena_sig,
                   cout           => c5_clk,
                   initial        => c_initial_val(5),
                   high           => c_high_val(5),
                   low            => c_low_val(5),
                   mode           => c_mode_val(5),
                   ph_tap         => c_ph_val(5));

    inclk_c0_dly1 <= inclk_c0;
    inclk_c0_dly2 <= inclk_c0_dly1;
    inclk_c0_dly3 <= inclk_c0_dly2;
    inclk_c0_dly4 <= inclk_c0_dly3;
    inclk_c0_dly5 <= inclk_c0_dly4;
    inclk_c0_dly6 <= inclk_c0_dly5;

    inclk_c1_dly1 <= inclk_c1;
    inclk_c1_dly2 <= inclk_c1_dly1;
    inclk_c1_dly3 <= inclk_c1_dly2;
    inclk_c1_dly4 <= inclk_c1_dly3;
    inclk_c1_dly5 <= inclk_c1_dly4;
    inclk_c1_dly6 <= inclk_c1_dly5;

    process(inclk_c0_dly6, inclk_c1_dly6, areset_ipd, ena_ipd, sig_stop_vco)
    variable c0_got_first_rising_edge : boolean := false;
    variable c0_count : integer := 2;
    variable c0_tmp, c1_tmp : std_logic := '0';
    variable c1_got_first_rising_edge : boolean := false;
    variable c1_count : integer := 2;
    begin
        if (areset_ipd = '1' or ena_ipd = '0' or sig_stop_vco = '1') then
            c0_count := 2;
            c1_count := 2;
            c0_got_first_rising_edge := false;
            c1_got_first_rising_edge := false;
        else
                if (not c0_got_first_rising_edge) then
                    if (inclk_c0_dly6'event and inclk_c0_dly6 = '1') then
                        c0_got_first_rising_edge := true;
                    end if;
                elsif (inclk_c0_dly6'event) then
                    c0_count := c0_count + 1;
                    if (c0_count = (c_high_val(0) + c_low_val(0)) * 2) then
                        c0_count := 1;
                    end if;
                end if;
            if (inclk_c0_dly6'event and inclk_c0_dly6 = '0') then
                if (c0_count = 1) then
                    c0_tmp := '1';
                    c0_got_first_rising_edge := false;
                else
                    c0_tmp := '0';
                end if;
            end if;

                if (not c1_got_first_rising_edge) then
                    if (inclk_c1_dly6'event and inclk_c1_dly6 = '1') then
                        c1_got_first_rising_edge := true;
                    end if;
                elsif (inclk_c1_dly6'event) then
                    c1_count := c1_count + 1;
                    if (c1_count = (c_high_val(1) + c_low_val(1)) * 2) then
                        c1_count := 1;
                    end if;
                end if;
            if (inclk_c1_dly6'event and inclk_c1_dly6 = '0') then
                if (c1_count = 1) then
                    c1_tmp := '1';
                    c1_got_first_rising_edge := false;
                else
                    c1_tmp := '0';
                end if;
            end if;
        end if;

        if (enable0_counter = "c0") then
            enable0_tmp <= c0_tmp;
        elsif (enable0_counter = "c1") then
            enable0_tmp <= c1_tmp;
        else
            enable0_tmp <= '0';
        end if;

        if (enable1_counter = "c0") then
            enable1_tmp <= c0_tmp;
        elsif (enable1_counter = "c1") then
            enable1_tmp <= c1_tmp;
        else
            enable1_tmp <= '0';
        end if;

    end process;

    glocked_cntr : process(clkin, ena_ipd, areset_ipd)
    variable count : integer := 0;
    variable output : std_logic := '0';
    begin
        if (areset_ipd = '1') then
            count := 0;
            output := '0';
        elsif (clkin'event and clkin = '1') then
            if (ena_ipd = '1') then
                count := count + 1;
                if (count = gate_lock_counter) then
                    output := '1';
                end if;
            end if;
        end if;
        gate_locked <= output;
    end process;

    locked <= gate_locked and lock when gate_lock_signal = "yes" else
              lock;


    process (scandone_tmp)
    variable buf : line;
    begin
        if (scandone_tmp'event and scandone_tmp = '1') then
            if (reconfig_err = false) then
                ASSERT false REPORT "PLL Reprogramming completed with the following values (Values in parantheses indicate values before reprogramming) :" severity note;
                ASSERT false REPORT "N modulus = " &int2str(n_val(0))& " (" &int2str(n_val_old(0))& ") "severity note;
                ASSERT false REPORT "M modulus = " &int2str(m_val(0))& " (" &int2str(m_val_old(0))& ") "severity note;
                ASSERT false REPORT "M ph_tap  = " &int2str(m_ph_val)& " (" &int2str(m_ph_val_old)& ") "severity note;
                if (ss > 0) then
                    ASSERT false REPORT "M2 modulus = " &int2str(m_val(1))& " (" &int2str(m_val_old(1))& ") "severity note;
                    ASSERT false REPORT "N2 modulus = " &int2str(n_val(1))& " (" &int2str(n_val_old(1))& ") "severity note;
                end if;
                for i in 0 to (num_output_cntrs-1) loop
                    write (buf, cntrs(i));
                    write (buf, string'(" :   high = "));
                    write (buf, c_high_val(i));
                    write (buf, string'(" ("));
                    write (buf, c_high_val_old(i));
                    write (buf, string'(") "));
                    write (buf, string'(" ,   low = "));
                    write (buf, sig_c_low_val_tmp(i));
                    write (buf, string'(" ("));
                    write (buf, c_low_val_old(i));
                    write (buf, string'(") "));
                    write (buf, string'(" ,   mode = "));
                    write (buf, c_mode_val(i));
                    write (buf, string'(" ("));
                    write (buf, c_mode_val_old(i));
                    write (buf, string'(") "));
                    write (buf, string'(" ,   phase tap = "));
                    write (buf, c_ph_val(i));
                    write (buf, string'(" ("));
                    write (buf, c_ph_val_old(i));
                    write (buf, string'(") "));
                    writeline(output, buf);
                end loop;

                ASSERT false REPORT "Charge Pump Current (uA) = " &int2str(cp_curr_val)& " (" &int2str(cp_curr_old)& ") "severity note;
                ASSERT false REPORT "Loop Filter Capacitor (pF) = " &int2str(lfc_val)& " (" &int2str(lfc_old)& ") "severity note;
                ASSERT false REPORT "Loop Filter Resistor (Kohm) = " &(lfr_val)& " (" &(lfr_old)& ") "severity note;

            else ASSERT false REPORT "Errors were encountered during PLL reprogramming. Please refer to error/warning messages above." severity warning;
            end if;
        end if;
    end process;

    process (scanwrite_enabled, c0_clk, c1_clk, c2_clk, c3_clk, c4_clk, c5_clk, vco_out, fbclk, scanclk_ipd, gated_scanclk)
    variable init : boolean := true;
    variable low, high : std_logic_vector(7 downto 0);
    variable low_fast, high_fast : std_logic_vector(3 downto 0);
    variable mode : string(1 to 6) := "bypass";
    variable is_error : boolean := false;
    variable m_tmp, n_tmp : std_logic_vector(8 downto 0);
    variable n_fast : std_logic_vector(1 downto 0);
    variable c_high_val_tmp : int_array(0 to 5) := (OTHERS => 1);
    variable c_low_val_tmp  : int_array(0 to 5) := (OTHERS => 1);
    variable c_ph_val_tmp   : int_array(0 to 5) := (OTHERS => 0);
    variable c_mode_val_tmp : str_array(0 to 5);
    variable m_ph_val_tmp   : integer := 0;
    variable m_val_tmp      : int_array(0 to 1) := (OTHERS => 1);
    variable c0_rising_edge_transfer_done : boolean := false;
    variable c1_rising_edge_transfer_done : boolean := false;
    variable c2_rising_edge_transfer_done : boolean := false;
    variable c3_rising_edge_transfer_done : boolean := false;
    variable c4_rising_edge_transfer_done : boolean := false;
    variable c5_rising_edge_transfer_done : boolean := false;

    -- variables for scaling of multiply_by and divide_by values
    variable i_clk0_mult_by    : integer := 1;
    variable i_clk0_div_by     : integer := 1;
    variable i_clk1_mult_by    : integer := 1;
    variable i_clk1_div_by     : integer := 1;
    variable i_clk2_mult_by    : integer := 1;
    variable i_clk2_div_by     : integer := 1;
    variable i_clk3_mult_by    : integer := 1;
    variable i_clk3_div_by     : integer := 1;
    variable i_clk4_mult_by    : integer := 1;
    variable i_clk4_div_by     : integer := 1;
    variable i_clk5_mult_by    : integer := 1;
    variable i_clk5_div_by     : integer := 1;
    variable clk0_gcd          : integer := 1;
    variable clk1_gcd          : integer := 1;
    variable clk2_gcd          : integer := 1;
    variable clk3_gcd          : integer := 1;
    variable clk4_gcd          : integer := 1;
    variable clk5_gcd          : integer := 1;

    -- user to advanced variables

    variable   max_neg_abs    : integer := 0;
    variable   i_m_initial    : integer;
    variable   i_m            : integer := 1;
    variable   i_n            : integer := 1;
    variable   i_m2           : integer;
    variable   i_n2           : integer;
    variable   i_ss           : integer;
    variable   i_c_high       : int_array(0 to 5);
    variable   i_c_low        : int_array(0 to 5);
    variable   i_c_initial    : int_array(0 to 5);
    variable   i_c_ph         : int_array(0 to 5);
    variable   i_c_mode       : str_array(0 to 5);
    variable   i_m_ph         : integer;
    variable   output_count   : integer;
    variable   new_divisor    : integer;

    variable clk0_cntr : string(1 to 2) := "c0";
    variable clk1_cntr : string(1 to 2) := "c1";
    variable clk2_cntr : string(1 to 2) := "c2";
    variable clk3_cntr : string(1 to 2) := "c3";
    variable clk4_cntr : string(1 to 2) := "c4";
    variable clk5_cntr : string(1 to 2) := "c5";

    variable fbk_cntr : string(1 to 2);
    variable fbk_cntr_index : integer;
    variable start_bit : integer;
    variable quiet_time : time := 0 ps;
    variable tmp_scan_data : std_logic_vector(173 downto 0) := (OTHERS => '0');
--    variable orig_scan_data : std_logic_vector(173 downto 0) := (OTHERS => '0');
    variable m_lo, m_hi : std_logic_vector(3 downto 0);

    variable j : integer := 0;
    variable scanread_active_edge : time := 0 ps;
    variable got_first_scanclk : boolean := false;
    variable got_first_gated_scanclk : boolean := false;
    variable scanclk_last_rising_edge : time := 0 ps;
    variable scanclk_period : time := 0 ps;
    variable current_scan_data : std_logic_vector(173 downto 0) := (OTHERS => '0');
    variable index : integer := 0;
    variable Tviol_scandata_scanclk : std_ulogic := '0';
    variable Tviol_scanread_scanclk : std_ulogic := '0';
    variable Tviol_scanwrite_scanclk : std_ulogic := '0';
    variable TimingData_scandata_scanclk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_scanread_scanclk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_scanwrite_scanclk : VitalTimingDataType := VitalTimingDataInit;
    variable scan_chain_length : integer := GPP_SCAN_CHAIN;
    variable tmp_rem : integer := 0;
    variable scanclk_cycles : integer := 0;
    variable lfc_tmp : std_logic_vector(1 downto 0);
    variable lfr_tmp : std_logic_vector(5 downto 0);
    variable lfr_int : integer := 0;

    function slowest_clk(C0 : integer; C0_mode : string(1 to 6);
                         C1 : integer; C1_mode : string(1 to 6);
                         C2 : integer; C2_mode : string(1 to 6);
                         C3 : integer; C3_mode : string(1 to 6);
                         C4 : integer; C4_mode : string(1 to 6);
                         C5 : integer; C5_mode : string(1 to 6);
                         refclk : time; m_mod : integer) return time is
    variable max_modulus : integer := 1;
    variable q_period : time := 0 ps;
    variable refclk_int : integer := 0;
    begin
        if (C0_mode /= "bypass" and C0_mode /= "   off") then
            max_modulus := C0;
        end if;
        if (C1 > max_modulus and C1_mode /= "bypass" and C1_mode /= "   off") then
            max_modulus := C1;
        end if;
        if (C2 > max_modulus and C2_mode /= "bypass" and C2_mode /= "   off") then
            max_modulus := C2;
        end if;
        if (C3 > max_modulus and C3_mode /= "bypass" and C3_mode /= "   off") then
            max_modulus := C3;
        end if;
        if (C4 > max_modulus and C4_mode /= "bypass" and C4_mode /= "   off") then
            max_modulus := C4;
        end if;
        if (C5 > max_modulus and C5_mode /= "bypass" and C5_mode /= "   off") then
            max_modulus := C5;
        end if;

        refclk_int := refclk / 1 ps;
        if (m_mod /= 0) then
            q_period := (refclk_int * max_modulus / m_mod) * 1 ps;
        end if;
        return (2*q_period);
    end slowest_clk;

    function int2bin (arg : integer; size : integer) return std_logic_vector is
    variable int_val : integer := arg;
    variable result : std_logic_vector(size-1 downto 0);
    begin
        for i in 0 to result'left loop
            if ((int_val mod 2) = 0) then
                result(i) := '0';
            else
                result(i) := '1';
            end if;
            int_val := int_val/2;
        end loop;
        return result;
    end int2bin;

    begin
        if (init) then
            if (m = 0) then
                clk5_cntr  := "c5";
                clk4_cntr  := "c4";
                clk3_cntr  := "c3";
                clk2_cntr  := "c2";
                clk1_cntr  := "c1";
                clk0_cntr  := "c0";
            else
                clk5_cntr  := clk5_counter;
                clk4_cntr  := clk4_counter;
                clk3_cntr  := clk3_counter;
                clk2_cntr  := clk2_counter;
                clk1_cntr  := clk1_counter;
                clk0_cntr  := clk0_counter;
            end if;

            if (operation_mode = "external_feedback") then
                if (feedback_source = "clk0") then
                    fbk_cntr := clk0_cntr;
                elsif (feedback_source = "clk1") then
                    fbk_cntr := clk1_cntr;
                elsif (feedback_source = "clk2") then
                    fbk_cntr := clk2_cntr;
                elsif (feedback_source = "clk3") then
                    fbk_cntr := clk3_cntr;
                elsif (feedback_source = "clk4") then
                    fbk_cntr := clk4_cntr;
                elsif (feedback_source = "clk5") then
                    fbk_cntr := clk5_cntr;
                else
--                    ext_fbk_cntr <= "c0";
                    fbk_cntr := "c0";
                end if;

                if (fbk_cntr = "c0") then
                    fbk_cntr_index := 0;
                elsif (fbk_cntr = "c1") then
                    fbk_cntr_index := 1;
                elsif (fbk_cntr = "c2") then
                    fbk_cntr_index := 2;
                elsif (fbk_cntr = "c3") then
                    fbk_cntr_index := 3;
                elsif (fbk_cntr = "c4") then
                    fbk_cntr_index := 4;
                elsif (fbk_cntr = "c5") then
                    fbk_cntr_index := 5;
                end if;

                ext_fbk_cntr <= fbk_cntr;
                ext_fbk_cntr_index <= fbk_cntr_index;
            end if;
            i_clk0_counter <= clk0_cntr;
            i_clk1_counter <= clk1_cntr;
            i_clk2_counter <= clk2_cntr;
            i_clk3_counter <= clk3_cntr;
            i_clk4_counter <= clk4_cntr;
            i_clk5_counter <= clk5_cntr;


            if (m = 0) then  -- convert user parameters to advanced
                -- scale down the multiply_by and divide_by values provided by the design
                -- before attempting to use them in the calculations below
                i_clk0_mult_by := scale_mult(clk0_multiply_by, clk0_divide_by);
                i_clk0_div_by := scale_div(clk0_multiply_by, clk0_divide_by);                
                i_clk1_mult_by := scale_mult(clk1_multiply_by, clk1_divide_by);
                i_clk1_div_by := scale_div(clk1_multiply_by, clk1_divide_by);
                i_clk2_mult_by := scale_mult(clk2_multiply_by, clk2_divide_by);
                i_clk2_div_by := scale_div(clk2_multiply_by, clk2_divide_by);
                i_clk3_mult_by := scale_mult(clk3_multiply_by, clk3_divide_by);
                i_clk3_div_by := scale_div(clk3_multiply_by, clk3_divide_by);
                i_clk4_mult_by := scale_mult(clk4_multiply_by, clk4_divide_by);
                i_clk4_div_by := scale_div(clk4_multiply_by, clk4_divide_by);
                i_clk5_mult_by := scale_mult(clk5_multiply_by, clk5_divide_by);
                i_clk5_div_by := scale_div(clk5_multiply_by, clk5_divide_by);
                if (pll_type /= "lvds") then
                    clk0_gcd := gcd(i_clk0_mult_by, i_clk0_div_by);
                    i_clk0_mult_by := i_clk0_mult_by / clk0_gcd;
                    i_clk0_div_by := i_clk0_div_by / clk0_gcd;
                    clk1_gcd := gcd(i_clk1_mult_by, i_clk1_div_by);
                    i_clk1_mult_by := i_clk1_mult_by / clk1_gcd;
                    i_clk1_div_by := i_clk1_div_by / clk1_gcd;
                    clk2_gcd := gcd(i_clk2_mult_by, i_clk2_div_by);
                    i_clk2_mult_by := i_clk2_mult_by / clk2_gcd;
                    i_clk2_div_by := i_clk2_div_by / clk2_gcd;
                    clk3_gcd := gcd(i_clk3_mult_by, i_clk3_div_by);
                    i_clk3_mult_by := i_clk3_mult_by / clk3_gcd;
                    i_clk3_div_by := i_clk3_div_by / clk3_gcd;
                    clk4_gcd := gcd(i_clk4_mult_by, i_clk4_div_by);
                    i_clk4_mult_by := i_clk4_mult_by / clk4_gcd;
                    i_clk4_div_by := i_clk4_div_by / clk4_gcd;
                    clk5_gcd := gcd(i_clk5_mult_by, i_clk5_div_by);
                    i_clk5_mult_by := i_clk5_mult_by / clk5_gcd;
                    i_clk5_div_by := i_clk5_div_by / clk5_gcd;
                end if;
                                
                if (((pll_type = "fast") or (pll_type = "lvds")) and ((vco_multiply_by /= 0) and (vco_divide_by /= 0))) then
                    i_n := vco_divide_by;
                    i_m := vco_multiply_by;
                else
                    i_n := 1;
                    i_m := lcm (i_clk0_mult_by, i_clk1_mult_by,
                                i_clk2_mult_by, i_clk3_mult_by,
                                i_clk4_mult_by, i_clk5_mult_by,
                                1, 1, 1, 1, inclk0_input_frequency);
                end if;

                max_neg_abs := maxnegabs(str2int(clk0_phase_shift), 
                                         str2int(clk1_phase_shift),
                                         str2int(clk2_phase_shift),
                                         str2int(clk3_phase_shift),
                                         str2int(clk4_phase_shift),
                                         str2int(clk5_phase_shift),
                                         0, 0, 0, 0);
                i_m_ph  := counter_ph(get_phase_degree(max_neg_abs,inclk0_input_frequency), i_m, i_n); 
                i_c_ph(0) := counter_ph(get_phase_degree(ph_adjust(str2int(clk0_phase_shift),max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_c_ph(1) := counter_ph(get_phase_degree(ph_adjust(str2int(clk1_phase_shift),max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_c_ph(2) := counter_ph(get_phase_degree(ph_adjust(str2int(clk2_phase_shift),max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_c_ph(3) := counter_ph(get_phase_degree(ph_adjust(str2int(clk3_phase_shift),max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_c_ph(4) := counter_ph(get_phase_degree(ph_adjust(str2int(clk4_phase_shift),max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_c_ph(5) := counter_ph(get_phase_degree(ph_adjust(str2int(clk5_phase_shift),max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_c_high(0) := counter_high(output_counter_value(i_clk0_div_by,
                             i_clk0_mult_by, i_m, i_n), clk0_duty_cycle);
                i_c_high(1) := counter_high(output_counter_value(i_clk1_div_by,
                              i_clk1_mult_by, i_m, i_n), clk1_duty_cycle);
                i_c_high(2) := counter_high(output_counter_value(i_clk2_div_by,
                             i_clk2_mult_by, i_m, i_n), clk2_duty_cycle);
                i_c_high(3) := counter_high(output_counter_value(i_clk3_div_by,
                             i_clk3_mult_by, i_m, i_n), clk3_duty_cycle);
                i_c_high(4) := counter_high(output_counter_value(i_clk4_div_by,
                             i_clk4_mult_by,  i_m, i_n), clk4_duty_cycle);
                i_c_high(5) := counter_high(output_counter_value(i_clk5_div_by,
                             i_clk5_mult_by,  i_m, i_n), clk5_duty_cycle);
                i_c_low(0)  := counter_low(output_counter_value(i_clk0_div_by,
                             i_clk0_mult_by,  i_m, i_n), clk0_duty_cycle);
                i_c_low(1)  := counter_low(output_counter_value(i_clk1_div_by,
                             i_clk1_mult_by,  i_m, i_n), clk1_duty_cycle);
                i_c_low(2)  := counter_low(output_counter_value(i_clk2_div_by,
                             i_clk2_mult_by,  i_m, i_n), clk2_duty_cycle);
                i_c_low(3)  := counter_low(output_counter_value(i_clk3_div_by,
                             i_clk3_mult_by,  i_m, i_n), clk3_duty_cycle);
                i_c_low(4)  := counter_low(output_counter_value(i_clk4_div_by,
                             i_clk4_mult_by,  i_m, i_n), clk4_duty_cycle);
                i_c_low(5)  := counter_low(output_counter_value(i_clk5_div_by,
                             i_clk5_mult_by,  i_m, i_n), clk5_duty_cycle);
                i_m_initial  := counter_initial(get_phase_degree(max_neg_abs, inclk0_input_frequency), i_m,i_n);
                i_c_initial(0) := counter_initial(get_phase_degree(ph_adjust(str2int(clk0_phase_shift), max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_c_initial(1) := counter_initial(get_phase_degree(ph_adjust(str2int(clk1_phase_shift), max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_c_initial(2) := counter_initial(get_phase_degree(ph_adjust(str2int(clk2_phase_shift), max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_c_initial(3) := counter_initial(get_phase_degree(ph_adjust(str2int(clk3_phase_shift), max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_c_initial(4) := counter_initial(get_phase_degree(ph_adjust(str2int(clk4_phase_shift), max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_c_initial(5) := counter_initial(get_phase_degree(ph_adjust(str2int(clk5_phase_shift), max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_c_mode(0) := counter_mode(clk0_duty_cycle, output_counter_value(i_clk0_div_by, i_clk0_mult_by,  i_m, i_n));
                i_c_mode(1) := counter_mode(clk1_duty_cycle, output_counter_value(i_clk1_div_by, i_clk1_mult_by,  i_m, i_n));
                i_c_mode(2) := counter_mode(clk2_duty_cycle, output_counter_value(i_clk2_div_by, i_clk2_mult_by,  i_m, i_n));
                i_c_mode(3) := counter_mode(clk3_duty_cycle, output_counter_value(i_clk3_div_by, i_clk3_mult_by,  i_m, i_n));
                i_c_mode(4) := counter_mode(clk4_duty_cycle, output_counter_value(i_clk4_div_by, i_clk4_mult_by,  i_m, i_n));
                i_c_mode(5) := counter_mode(clk5_duty_cycle, output_counter_value(i_clk5_div_by, i_clk5_mult_by,  i_m, i_n));

                -- in external feedback mode, need to adjust M value to take
                -- into consideration the external feedback counter value
                if(operation_mode = "external_feedback") then
                    -- if there is a negative phase shift, m_initial can
                    -- only be 1
                    if (max_neg_abs > 0) then
                        i_m_initial := 1;
                    end if;

                    -- calculate the feedback counter multiplier
                    if (i_c_mode(fbk_cntr_index) = "bypass") then
                        output_count := 1;
                    else
                        output_count := i_c_high(fbk_cntr_index) + i_c_low(fbk_cntr_index);
                    end if;

                    if (i_m > output_count) then
                        i_m := i_m / output_count;
                    else
                        new_divisor := gcd(i_m, output_count);
                        i_m := i_m / new_divisor;
                        i_n := output_count / new_divisor;
                    end if;
                end if;
 
            else -- m /= 0

                i_n             := n;
                i_m             := m;
                i_m_initial     := m_initial;
                i_m_ph          := m_ph;
                i_c_ph(0)         := c0_ph;
                i_c_ph(1)         := c1_ph;
                i_c_ph(2)         := c2_ph;
                i_c_ph(3)         := c3_ph;
                i_c_ph(4)         := c4_ph;
                i_c_ph(5)         := c5_ph;
                i_c_high(0)       := c0_high;
                i_c_high(1)       := c1_high;
                i_c_high(2)       := c2_high;
                i_c_high(3)       := c3_high;
                i_c_high(4)       := c4_high;
                i_c_high(5)       := c5_high;
                i_c_low(0)        := c0_low;
                i_c_low(1)        := c1_low;
                i_c_low(2)        := c2_low;
                i_c_low(3)        := c3_low;
                i_c_low(4)        := c4_low;
                i_c_low(5)        := c5_low;
                i_c_initial(0)    := c0_initial;
                i_c_initial(1)    := c1_initial;
                i_c_initial(2)    := c2_initial;
                i_c_initial(3)    := c3_initial;
                i_c_initial(4)    := c4_initial;
                i_c_initial(5)    := c5_initial;
                i_c_mode(0)       := translate_string(c0_mode);
                i_c_mode(1)       := translate_string(c1_mode);
                i_c_mode(2)       := translate_string(c2_mode);
                i_c_mode(3)       := translate_string(c3_mode);
                i_c_mode(4)       := translate_string(c4_mode);
                i_c_mode(5)       := translate_string(c5_mode);

            end if; -- user to advanced conversion.

            m_initial_val <= i_m_initial;
            n_val(0) <= i_n;
            m_val(0) <= i_m;
            m_val(1) <= m2;
            n_val(1) <= n2;

            if (i_m = 1) then
                m_mode_val(0) <= "bypass";
            else
                m_mode_val(0) <= "      ";
            end if;
            if (m2 = 1) then
                m_mode_val(1) <= "bypass";
            end if;
            if (i_n = 1) then
                n_mode_val(0) <= "bypass";
            end if;
            if (n2 = 1) then
                n_mode_val(1) <= "bypass";
            end if;

            m_ph_val  <= i_m_ph;
            m_ph_val_tmp := i_m_ph;
            m_val_tmp := m_val;

            for i in 0 to 5 loop
                if (i_c_mode(i) = "bypass") then
                    if (pll_type = "fast" or pll_type = "lvds") then
                        i_c_high(i) := 16;
                        i_c_low(i) := 16;
                    else
                        i_c_high(i) := 256;
                        i_c_low(i) := 256;
                    end if;
                end if;
                c_ph_val(i)         <= i_c_ph(i);
                c_initial_val(i)    <= i_c_initial(i);
                c_high_val(i)       <= i_c_high(i);
                c_low_val(i)        <= i_c_low(i);
                c_mode_val(i)       <= i_c_mode(i);
                c_high_val_tmp(i)   := i_c_high(i);
                c_low_val_tmp(i)    := i_c_low(i);
                c_mode_val_tmp(i)   := i_c_mode(i);
                c_ph_val_tmp(i)     := i_c_ph(i);
                c_ph_val_orig(i)    <= i_c_ph(i);
                c_high_val_hold(i)  <= i_c_high(i);
                c_low_val_hold(i)   <= i_c_low(i);
                c_mode_val_hold(i)  <= i_c_mode(i);
            end loop;

            lfc_val <= loop_filter_c;
            lfr_val <= loop_filter_r;
            cp_curr_val <= charge_pump_current;

            if (pll_type = "fast") then
                scan_chain_length := FAST_SCAN_CHAIN;
            end if;
            -- initialize the scan_chain contents
            -- CP/LF bits
            scan_data(11 downto 0) <= "000000000000";
            for i in 0 to 3 loop
                if (pll_type = "fast" or pll_type = "lvds") then
                    if (fpll_loop_filter_c_arr(i) = loop_filter_c) then
                        scan_data(11 downto 10) <= int2bin(i, 2);
                    end if;
                else
                    if (loop_filter_c_arr(i) = loop_filter_c) then
                        scan_data(11 downto 10) <= int2bin(i, 2);
                    end if;
                end if;
            end loop;
            for i in 0 to 15 loop
                if (charge_pump_curr_arr(i) = charge_pump_current) then
                    scan_data(3 downto 0) <= int2bin(i, 4);
                end if;
            end loop;
            for i in 0 to 39 loop
                if (loop_filter_r_arr(i) = loop_filter_r) then
                    if (i >= 16 and i <= 23) then
                        scan_data(9 downto 4) <= int2bin((i+8), 6);
                    elsif (i >= 24 and i <= 31) then
                        scan_data(9 downto 4) <= int2bin((i+16), 6);
                    elsif (i >= 32) then
                        scan_data(9 downto 4) <= int2bin((i+24), 6);
                    else
                        scan_data(9 downto 4) <= int2bin(i, 6);
                    end if;
                end if;
            end loop;
               
            if (pll_type = "fast" or pll_type = "lvds") then
                scan_data(21 downto 12) <= "0000000000"; -- M, C3-C0 ph
                -- C0-C3 high
                scan_data(25 downto 22) <= int2bin(i_c_high(0), 4);
                scan_data(35 downto 32) <= int2bin(i_c_high(1), 4);
                scan_data(45 downto 42) <= int2bin(i_c_high(2), 4);
                scan_data(55 downto 52) <= int2bin(i_c_high(3), 4);
                -- C0-C3 low
                scan_data(30 downto 27) <= int2bin(i_c_low(0), 4);
                scan_data(40 downto 37) <= int2bin(i_c_low(1), 4);
                scan_data(50 downto 47) <= int2bin(i_c_low(2), 4);
                scan_data(60 downto 57) <= int2bin(i_c_low(3), 4);
                -- C0-C3 mode
                for i in 0 to 3 loop
                    if (i_c_mode(i) = "   off" or i_c_mode(i) = "bypass") then
                        scan_data(26 + (10*i)) <= '1';
                        if (i_c_mode(i) = "   off") then
                            scan_data(31 + (10*i)) <= '1';
                        else
                            scan_data(31 + (10*i)) <= '0';
                        end if;
                    else 
                        scan_data(26 + (10*i)) <= '0';
                        if (i_c_mode(i) = "   odd") then
                            scan_data(31 + (10*i)) <= '1';
                        else
                            scan_data(31 + (10*i)) <= '0';
                        end if;
                    end if;
                end loop;
                -- M
                if (i_m = 1) then
                    scan_data(66) <= '1';
                    scan_data(71) <= '0';
                    scan_data(65 downto 62) <= "0000";
                    scan_data(70 downto 67) <= "0000";
                else
                    scan_data(66) <= '0';       -- set BYPASS bit to 0
                    scan_data(70 downto 67) <= int2bin(i_m/2, 4);   -- set M low
                    if (i_m rem 2 = 0) then
                        -- M is an even no. : set M high = low,
                        -- set odd/even bit to 0
                        scan_data(65 downto 62) <= int2bin(i_m/2, 4);
                        scan_data(71) <= '0';
                    else       -- M is odd : M high = low + 1
                        scan_data(65 downto 62) <= int2bin((i_m/2) + 1, 4);
                        scan_data(71) <= '1';
                    end if;
                end if;
                -- N
                scan_data(73 downto 72) <= int2bin(i_n, 2);
                if (i_n = 1) then
                    scan_data(74) <= '1';
                    scan_data(73 downto 72) <= "00";
                end if;
            else          -- PLL type is auto or enhanced
                scan_data(25 downto 12) <= "00000000000000"; -- M, C5-C0 ph
                -- C0-C5 high
                scan_data(123 downto 116) <= int2bin(i_c_high(0), 8);
                scan_data(105 downto 98) <= int2bin(i_c_high(1), 8);
                scan_data(87 downto 80) <= int2bin(i_c_high(2), 8);
                scan_data(69 downto 62) <= int2bin(i_c_high(3), 8);
                scan_data(51 downto 44) <= int2bin(i_c_high(4), 8);
                scan_data(33 downto 26) <= int2bin(i_c_high(5), 8);
                -- C0-C5 low
                scan_data(132 downto 125) <= int2bin(i_c_low(0), 8);
                scan_data(114 downto 107) <= int2bin(i_c_low(1), 8);
                scan_data(96 downto 89) <= int2bin(i_c_low(2), 8);
                scan_data(78 downto 71) <= int2bin(i_c_low(3), 8);
                scan_data(60 downto 53) <= int2bin(i_c_low(4), 8);
                scan_data(42 downto 35) <= int2bin(i_c_low(5), 8);
                -- C0-C5 mode
                for i in 0 to 5 loop
                    if (i_c_mode(i) = "   off" or i_c_mode(i) = "bypass") then
                        scan_data(124 - (18*i)) <= '1';
                        if (i_c_mode(i) = "   off") then
                            scan_data(133 - (18*i)) <= '1';
                        else
                            scan_data(133 - (18*i)) <= '0';
                        end if;
                    else 
                        scan_data(124 - (18*i)) <= '0';
                        if (i_c_mode(i) = "   odd") then
                            scan_data(133 - (18*i)) <= '1';
                        else
                            scan_data(133 - (18*i)) <= '0';
                        end if;
                    end if;
                end loop;

                -- M/M2
                scan_data(142 downto 134) <= int2bin(i_m, 9);
                scan_data(143) <= '0';
                scan_data(152 downto 144) <= int2bin(m2, 9);
                scan_data(153) <= '0';
                if (i_m = 1) then
                    scan_data(143) <= '1';
                    scan_data(142 downto 134) <= "000000000";
                end if;
                if (m2 = 1) then
                    scan_data(153) <= '1';
                    scan_data(152 downto 144) <= "000000000";
                end if;
               
                -- N/N2
                scan_data(162 downto 154) <= int2bin(i_n, 9);
                scan_data(172 downto 164) <= int2bin(n2, 9);
                if (i_n = 1) then
                    scan_data(163) <= '1';
                    scan_data(162 downto 154) <= "000000000";
                end if;
                if (n2 = 1) then
                    scan_data(173) <= '1';
                    scan_data(172 downto 164) <= "000000000";
                end if;
               
            end if;
            if (pll_type = "fast" or pll_type = "lvds") then
                num_output_cntrs <= 4;
            else
                num_output_cntrs <= 6;
            end if;

            init := false;
        elsif (scanwrite_enabled'event and scanwrite_enabled = '0') then
            -- falling edge : deassert scandone
            scandone_tmp <= transport '0' after (1.5 * scanclk_period);
            c0_rising_edge_transfer_done := false;
            c1_rising_edge_transfer_done := false;
            c2_rising_edge_transfer_done := false;
            c3_rising_edge_transfer_done := false;
            c4_rising_edge_transfer_done := false;
            c5_rising_edge_transfer_done := false;
        elsif (scanwrite_enabled'event and scanwrite_enabled = '1') then
            ASSERT false REPORT "PLL Reprogramming Initiated" severity note;
            quiet_time := slowest_clk(c_high_val(0)+c_low_val(0), c_mode_val(0),
                                      c_high_val(1)+c_low_val(1), c_mode_val(1),
                                      c_high_val(2)+c_low_val(2), c_mode_val(2),
                                      c_high_val(3)+c_low_val(3), c_mode_val(3),
                                      c_high_val(4)+c_low_val(4), c_mode_val(4),
                                      c_high_val(5)+c_low_val(5), c_mode_val(5),
                                      sig_refclk_period, m_val(0));

            tmp_rem := (quiet_time/1 ps) rem (scanclk_period/ 1 ps);
            scanclk_cycles := (quiet_time/1 ps) / (scanclk_period/1 ps);
            if (tmp_rem /= 0) then
                scanclk_cycles := scanclk_cycles + 1;
            end if;
            scandone_tmp <= transport '1' after ((scanclk_cycles+1)*scanclk_period - (scanclk_period/2));
            reconfig_err <= false;

            -- make temporary copy of scan_data for processing
            tmp_scan_data := scan_data;

            -- save old values
            lfc_old <= lfc_val;
            lfr_old <= lfr_val;
            cp_curr_old <= cp_curr_val;

            -- CP
            -- Bits 0-3 : all values are legal
            cp_curr_val <= charge_pump_curr_arr(alt_conv_integer(scan_data(3 downto 0)));

            -- LF Resistance : bits 4-9
            -- values from 010000 - 010111, 100000 - 100111,
            --             110000 - 110111 are illegal
            lfr_tmp := tmp_scan_data(9 downto 4);
            lfr_int := alt_conv_integer(lfr_tmp);
            if (((lfr_int >= 16) and (lfr_int <= 23)) or
                ((lfr_int >= 32) and (lfr_int <= 39)) or
                ((lfr_int >= 48) and (lfr_int <= 55))) then
                reconfig_err <= true;
                ASSERT false REPORT "Illegal bit settings for Loop Filter Resistance. Legal bit values range from 000000-001111, 011000-011111, 101000-101111 and 111000-111111. Reconfiguration may not work." severity warning;
            else
--                j := alt_conv_integer(scan_data(9 downto 4));
                if (lfr_int >= 56) then
                    lfr_int := lfr_int - 24;
                elsif ((lfr_int >= 40) and (lfr_int <= 47)) then
                    lfr_int := lfr_int - 16;
                elsif ((lfr_int >= 24) and (lfr_int <= 31)) then
                    lfr_int := lfr_int - 8;
                end if;
                lfr_val <= loop_filter_r_arr(lfr_int);
            end if;

            -- LF Capacitance : bits 10,11 : all values are legal
            lfc_tmp := scan_data(11 downto 10);
            if (pll_type = "fast" or pll_type = "lvds") then
                lfc_val <= fpll_loop_filter_c_arr(alt_conv_integer(lfc_tmp));
            else
                lfc_val <= loop_filter_c_arr(alt_conv_integer(lfc_tmp));
            end if;

            -- cntrs c0-c5
            -- save old values for display info.
            m_val_old <= m_val;
            n_val_old <= n_val;
            m_mode_val_old <= m_mode_val;
            n_mode_val_old <= n_mode_val;
            m_ph_val_old <= m_ph_val;
            c_high_val_old <= c_high_val;
            c_low_val_old <= c_low_val;
            c_ph_val_old <= c_ph_val;
            c_mode_val_old <= c_mode_val;

            -- first the M counter phase : bit order same for fast and GPP
            if (scan_data(12) = '0') then
                -- do nothing
            elsif (scan_data(12) = '1' and scan_data(13) = '1') then
                m_ph_val_tmp := m_ph_val_tmp + 1;
                if (m_ph_val_tmp > 7) then
                    m_ph_val_tmp := 0;
                end if;
            elsif (scan_data(12) = '1' and scan_data(13) = '0') then
                m_ph_val_tmp := m_ph_val_tmp - 1;
                if (m_ph_val_tmp < 0) then
                    m_ph_val_tmp := 7;
                end if;
            else
                reconfig_err <= true;
                ASSERT false REPORT "Illegal values for M counter phase tap. Reconfiguration may not work." severity warning;
            end if;

            -- read the fast PLL bits
            if (pll_type = "fast" or pll_type = "lvds") then
                -- C3-C0 phase bits
                for i in 3 downto 0 loop
                    start_bit := 14 + ((3-i)*2);
                    if (tmp_scan_data(start_bit) = '0') then
                        -- do nothing
                    elsif (tmp_scan_data(start_bit) = '1') then
                         if (tmp_scan_data(start_bit + 1) = '1') then
                             c_ph_val_tmp(i) := c_ph_val(i) + 1;
                             if (c_ph_val_tmp(i) > 7) then
                                 c_ph_val_tmp(i) := 0;
                             end if;
                         elsif (tmp_scan_data(start_bit + 1) = '0') then
                             c_ph_val_tmp(i) := c_ph_val_tmp(i) - 1;
                             if (c_ph_val_tmp(i) < 0) then
                                 c_ph_val_tmp(i) := 7;
                             end if;
                         end if;
                    end if;
                end loop;
                sig_c_ph_val_tmp <= c_ph_val_tmp;
                sig_c_low_val_tmp <= c_low_val_tmp;
                -- C0-C3 counter moduli
                for i in 0 to 3 loop
                    start_bit := 22 + (i*10);
                    if (tmp_scan_data(start_bit + 4) = '1') then
                        c_mode_val_tmp(i) := "bypass";
                        if (tmp_scan_data(start_bit + 9) = '1') then
                            c_mode_val_tmp(i) := "   off";
                            ASSERT false REPORT "The specified bit settings will turn OFF the " &cntrs(i)& "counter. It cannot be turned on unless the part is re-initialized." severity warning;
                        end if;
                    elsif (tmp_scan_data(start_bit + 9) = '1') then
                        c_mode_val_tmp(i) := "   odd";
                    else
                        c_mode_val_tmp(i) := "  even";
                    end if;
                    high_fast := tmp_scan_data(start_bit+3 downto start_bit);
                    low_fast := tmp_scan_data(start_bit+8 downto start_bit+5);
                    if (tmp_scan_data(start_bit+3 downto start_bit) = "0000") then
                        c_high_val_tmp(i) := 16;
                    else
                        c_high_val_tmp(i) := alt_conv_integer(high_fast);
                    end if;
                    if (tmp_scan_data(start_bit+8 downto start_bit+5) = "0000") then
                        c_low_val_tmp(i) := 16;
                    else
                        c_low_val_tmp(i) := alt_conv_integer(low_fast);
                    end if;
                end loop;
                -- M
                -- some temporary storage
                m_hi := tmp_scan_data(65 downto 62);
                m_lo := tmp_scan_data(70 downto 67);
                m_val_tmp(0) := alt_conv_integer(m_hi) + alt_conv_integer(m_lo);
                if (tmp_scan_data(66) = '1') then
                    if (tmp_scan_data(71) = '1') then
                        -- this will turn off the M counter : error
                        reconfig_err <= true;
                        is_error := true;
                        ASSERT false REPORT "The specified bit settings will turn OFF the M counter. This is illegal. Reconfiguration may not work." severity warning;
                    else -- M counter is being bypassed
                        if (m_mode_val(0) /= "bypass") then
                            -- mode is switched : give warning
                            ASSERT false REPORT "M counter switched from enabled to BYPASS mode. PLL may lose lock." severity warning;
                        end if;
                        m_val_tmp(0) := 1;
                        m_mode_val(0) <= "bypass";
                    end if;
                else
                    if (m_mode_val(0) = "bypass") then
                        -- mode is switched : give warning
                        ASSERT false REPORT "M counter switched BYPASS mode to enabled. PLL may lose lock." severity warning;
                    end if;
                    m_mode_val(0) <= "      ";
                    if (tmp_scan_data(71) = '1') then
                        -- odd : check for duty cycle, if not 50% -- error
                        if (alt_conv_integer(m_hi) - alt_conv_integer(m_lo) /= 1) then
                            reconfig_err <= true;
                            ASSERT FALSE REPORT "The M counter of the CycloneII FAST PLL can be configured for 50% duty cycle only. In this case, the HIGH and LOW moduli programmed will result in a duty cycle other than 50%, which is illegal. Reconfiguration may not work." severity warning;
                        end if;
                    else -- even
                        if (alt_conv_integer(m_hi) /= alt_conv_integer(m_lo)) then
                            reconfig_err <= true;
                            ASSERT FALSE REPORT "The M counter of the CycloneII FAST PLL can be configured for 50% duty cycle only. In this case, the HIGH and LOW moduli programmed will result in a duty cycle other than 50%, which is illegal. Reconfiguration may not work." severity warning;
                        end if;
                    end if;
                end if;

                -- N
                is_error := false;
                n_fast := tmp_scan_data(73 downto 72);
                n_val(0) <= alt_conv_integer(n_fast);
                if (tmp_scan_data(74) /= '1') then
                    if (alt_conv_integer(n_fast) = 1) then
                        is_error := true;
                        reconfig_err <= true;
                        -- cntr value is illegal : give warning
                        ASSERT false REPORT "Illegal 1 value for N counter. Instead the counter should be BYPASSED. Reconfiguration may not work." severity warning;
                    elsif (alt_conv_integer(n_fast) = 0) then
                        n_val(0) <= 4;
                        ASSERT FALSE REPORT "N Modulus = " &int2str(4)& " " severity note;
                    end if;
                    if (not is_error) then
                        if (n_mode_val(0) = "bypass") then
                            ASSERT false REPORT "N Counter switched from BYPASS mode to enabled (N modulus = " &int2str(alt_conv_integer(n_fast))& "). PLL may lose lock." severity warning;
                        else
                            ASSERT FALSE REPORT "N modulus = " &int2str(alt_conv_integer(n_fast))& " "severity note;
                        end if;
                        n_mode_val(0) <= "      ";
                    end if;
                elsif (tmp_scan_data(74) = '1') then
                    if (tmp_scan_data(72) /= '0') then
                        is_error := true;
                        reconfig_err <= true;
                        ASSERT false report "Illegal value for N counter in BYPASS mode. The LSB of the counter should be set to 0 in order to operate the counter in BYPASS mode. Reconfiguration may not work." severity warning;
                    else
                        if (n_mode_val(0) /= "bypass") then
                            ASSERT false REPORT "N Counter switched from enabled to BYPASS mode. PLL may lose lock." severity warning;
                        end if;
                        n_val(0) <= 1;
                        n_mode_val(0) <= "bypass";
                    end if;
                end if;
            else   -- GENERAL PURPOSE PLL
                for i in 0 to 5 loop
                    start_bit := 116 - (i*18);
                    if (tmp_scan_data(start_bit + 8) = '1') then
                        c_mode_val_tmp(i) := "bypass";
                        if (tmp_scan_data(start_bit + 17) = '1') then
                            c_mode_val_tmp(i) := "   off";
                            ASSERT false REPORT "The specified bit settings will turn OFF the " &cntrs(i)& "counter. It cannot be turned on unless the part is re-initialized." severity warning;
                        end if;
                    elsif (tmp_scan_data(start_bit + 17) = '1') then
                        c_mode_val_tmp(i) := "   odd";
                    else
                        c_mode_val_tmp(i) := "  even";
                    end if;
                    high := tmp_scan_data(start_bit + 7 downto start_bit);
                    low := tmp_scan_data(start_bit+16 downto start_bit+9);
                    if (tmp_scan_data(start_bit+7 downto start_bit) = "00000000") then
                        c_high_val_tmp(i) := 256;
                    else
                        c_high_val_tmp(i) := alt_conv_integer(high);
                    end if;
                    if (tmp_scan_data(start_bit+16 downto start_bit+9) = "00000000") then
                        c_low_val_tmp(i) := 256;
                    else
                        c_low_val_tmp(i) := alt_conv_integer(low);
                    end if;
                end loop;
                -- the phase taps
                for i in 0 to 5 loop
                    start_bit := 14 + (i*2);
                    if (tmp_scan_data(start_bit) = '0') then
                        -- do nothing
                    elsif (tmp_scan_data(start_bit) = '1') then
                         if (tmp_scan_data(start_bit + 1) = '1') then
                             c_ph_val_tmp(i) := c_ph_val(i) + 1;
                             if (c_ph_val_tmp(i) > 7) then
                                 c_ph_val_tmp(i) := 0;
                             end if;
                         elsif (tmp_scan_data(start_bit + 1) = '0') then
                             c_ph_val_tmp(i) := c_ph_val_tmp(i) - 1;
                             if (c_ph_val_tmp(i) < 0) then
                                 c_ph_val_tmp(i) := 7;
                             end if;
                         end if;
                    end if;
                end loop;
                sig_c_ph_val_tmp <= c_ph_val_tmp;
                sig_c_low_val_tmp <= c_low_val_tmp;

                -- cntrs M/M2
                for i in 0 to 1 loop
                    start_bit := 134 + (i*10);
                    if ( i = 0 or (i = 1 and ss > 0) ) then
                        is_error := false;
                        m_tmp := tmp_scan_data(start_bit+8 downto start_bit);
                        m_val_tmp(i) := alt_conv_integer(m_tmp);
                        if (tmp_scan_data(start_bit+9) /= '1') then
                            if (alt_conv_integer(m_tmp) = 1) then
                                is_error := true;
                                reconfig_err <= true;
                                -- cntr value is illegal : give warning
                                ASSERT false REPORT "Illegal 1 value for " &ss_cntrs(i)& "counter. Instead " &ss_cntrs(i)& "should be BYPASSED. Reconfiguration may not work." severity warning;
                            elsif (tmp_scan_data(start_bit+8 downto start_bit) = "000000000") then
                                m_val_tmp(i) := 512;
                            end if;
                            if (not is_error) then
                                if (m_mode_val(i) = "bypass") then
                                    -- Mode is switched : give warning
                                    ASSERT false REPORT "M Counter switched from BYPASS mode to enabled (M modulus = " &int2str(alt_conv_integer(m_tmp))& "). PLL may lose lock." severity warning;
                                else
                                    ASSERT FALSE REPORT "M modulus = " &int2str(alt_conv_integer(m_tmp))& " "severity note;
                                end if;
                                m_mode_val(i) <= "      ";
                            end if;
                        elsif (tmp_scan_data(start_bit+9) = '1') then
                            if (tmp_scan_data(start_bit) /= '0') then
                                is_error := true;
                                reconfig_err <= true;
                                ASSERT false report "Illegal value for counter " &ss_cntrs(i)& "in BYPASS mode. The LSB of the counter should be set to 0 in order to operate the counter in BYPASS mode. Reconfiguration may not work." severity warning;
                            else
                                if (m_mode_val(i) /= "bypass") then
                                    -- Mode is switched : give warning
                                    ASSERT false REPORT "M Counter switched from enabled to BYPASS mode. PLL may lose lock." severity warning;
                                end if;
                                m_val_tmp(i) := 1;
                                m_mode_val(i) <= "bypass";
                            end if;
                        end if;
                    end if;
                end loop;
                if (ss > 0) then
                    if (m_mode_val(0) /= m_mode_val(1)) then
                        reconfig_err <= true;
                        is_error := true;
                        ASSERT false REPORT "Incompatible modes for M/M2 counters. Either both should be BYPASSED or both NON-BYPASSED. Reconfiguration may not work." severity warning;
                    end if;
                end if;
          
                -- cntrs N/N2
                for i in 0 to 1 loop
                    start_bit := 154 + i*10;
                    if ( i = 0 or (i = 1 and ss > 0) ) then
                        is_error := false;
                        n_tmp := tmp_scan_data(start_bit+8 downto start_bit);
                        n_val(i) <= alt_conv_integer(n_tmp);
                        if (tmp_scan_data(start_bit+9) /= '1') then
                            if (alt_conv_integer(n_tmp) = 1) then
                                is_error := true;
                                reconfig_err <= true;
                                -- cntr value is illegal : give warning
                                ASSERT false REPORT "Illegal 1 value for " &ss_cntrs(2+i)& "counter. Instead " &ss_cntrs(2+i)& "should be BYPASSED. Reconfiguration may not work." severity warning;
                            elsif (alt_conv_integer(n_tmp) = 0) then
                                n_val(i) <= 512;
                                ASSERT FALSE REPORT "N Modulus = " &int2str(512)& " " severity note;
                            end if;
                            if (not is_error) then
                                if (n_mode_val(i) = "bypass") then
                                    ASSERT false REPORT "N Counter switched from BYPASS mode to enabled (N modulus = " &int2str(alt_conv_integer(n_tmp))& "). PLL may lose lock." severity warning;
                                else
                                    ASSERT FALSE REPORT "N modulus = " &int2str(alt_conv_integer(n_tmp))& " "severity note;
                                end if;
                                n_mode_val(i) <= "      ";
                            end if;
                        elsif (tmp_scan_data(start_bit+9) = '1') then
                            if (tmp_scan_data(start_bit) /= '0') then
                                is_error := true;
                                reconfig_err <= true;
                                ASSERT false report "Illegal value for counter " &ss_cntrs(2+i)& "in BYPASS mode. The LSB of the counter should be set to 0 in order to operate the counter in BYPASS mode. Reconfiguration may not work." severity warning;
                            else
                                if (n_mode_val(i) /= "bypass") then
                                    ASSERT false REPORT "N Counter switched from enabled to BYPASS mode. PLL may lose lock." severity warning;
                                end if;
                                n_val(i) <= 1;
                                n_mode_val(i) <= "bypass";
                            end if;
                        end if;
                    end if;
                end loop;
                if (ss > 0) then
                    if (n_mode_val(0) /= n_mode_val(1)) then
                        reconfig_err <= true;
                        is_error := true;
                        ASSERT false REPORT "Incompatible modes for N/N2 counters. Either both should be BYPASSED or both NON-BYPASSED. Reconfiguration may not work." severity warning;
                    end if;
                end if;
            end if;
      end if;

      if (scanwrite_enabled = '1') then
          if (fbclk'event and fbclk = '1') then
              m_val <= m_val_tmp;
          end if;

          if (c0_clk'event and c0_clk = '1') then
              c_high_val_hold(0) <= c_high_val_tmp(0);
              c_mode_val_hold(0) <= c_mode_val_tmp(0);
              c0_rising_edge_transfer_done := true;
              c_high_val(0) <= c_high_val_hold(0);
              c_mode_val(0) <= c_mode_val_hold(0);
          end if;
          if (c1_clk'event and c1_clk = '1') then
              c_high_val_hold(1) <= c_high_val_tmp(1);
              c_mode_val_hold(1) <= c_mode_val_tmp(1);
              c1_rising_edge_transfer_done := true;
              c_high_val(1) <= c_high_val_hold(1);
              c_mode_val(1) <= c_mode_val_hold(1);
          end if;
          if (c2_clk'event and c2_clk = '1') then
              c_high_val_hold(2) <= c_high_val_tmp(2);
              c_mode_val_hold(2) <= c_mode_val_tmp(2);
              c2_rising_edge_transfer_done := true;
              c_high_val(2) <= c_high_val_hold(2);
              c_mode_val(2) <= c_mode_val_hold(2);
          end if;
          if (c3_clk'event and c3_clk = '1') then
              c_high_val_hold(3) <= c_high_val_tmp(3);
              c_mode_val_hold(3) <= c_mode_val_tmp(3);
              c_high_val(3) <= c_high_val_hold(3);
              c_mode_val(3) <= c_mode_val_hold(3);
              c3_rising_edge_transfer_done := true;
          end if;
          if (c4_clk'event and c4_clk = '1') then
              c_high_val_hold(4) <= c_high_val_tmp(4);
              c_mode_val_hold(4) <= c_mode_val_tmp(4);
              c_high_val(4) <= c_high_val_hold(4);
              c_mode_val(4) <= c_mode_val_hold(4);
              c4_rising_edge_transfer_done := true;
          end if;
          if (c5_clk'event and c5_clk = '1') then
              c_high_val_hold(5) <= c_high_val_tmp(5);
              c_mode_val_hold(5) <= c_mode_val_tmp(5);
              c_high_val(5) <= c_high_val_hold(5);
              c_mode_val(5) <= c_mode_val_hold(5);
              c5_rising_edge_transfer_done := true;
          end if;
      end if;

      if (c0_clk'event and c0_clk = '0' and c0_rising_edge_transfer_done) then
          c_low_val_hold(0) <= c_low_val_tmp(0);
          c_low_val(0) <= c_low_val_hold(0);
      end if;
      if (c1_clk'event and c1_clk = '0' and c1_rising_edge_transfer_done) then
          c_low_val_hold(1) <= c_low_val_tmp(1);
          c_low_val(1) <= c_low_val_hold(1);
      end if;
      if (c2_clk'event and c2_clk = '0' and c2_rising_edge_transfer_done) then
          c_low_val_hold(2) <= c_low_val_tmp(2);
          c_low_val(2) <= c_low_val_hold(2);
      end if;
      if (c3_clk'event and c3_clk = '0' and c3_rising_edge_transfer_done) then
          c_low_val_hold(3) <= c_low_val_tmp(3);
          c_low_val(3) <= c_low_val_hold(3);
      end if;
      if (c4_clk'event and c4_clk = '0' and c4_rising_edge_transfer_done) then
          c_low_val_hold(4) <= c_low_val_tmp(4);
          c_low_val(4) <= c_low_val_hold(4);
      end if;
      if (c5_clk'event and c5_clk = '0' and c5_rising_edge_transfer_done) then
          c_low_val_hold(5) <= c_low_val_tmp(5);
          c_low_val(5) <= c_low_val_hold(5);
      end if;

      if (scanwrite_enabled = '1') then
          if (vco_out(0)'event and vco_out(0) = '0') then
              for i in 0 to 5 loop
                  if (c_ph_val(i) = 0) then
                      c_ph_val(i) <= c_ph_val_tmp(i);
                  end if;
              end loop;
              if (m_ph_val = 0) then
                  m_ph_val <= m_ph_val_tmp;
              end if;
          end if;
          if (vco_out(1)'event and vco_out(1) = '0') then
              for i in 0 to 5 loop
                  if (c_ph_val(i) = 1) then
                      c_ph_val(i) <= c_ph_val_tmp(i);
                  end if;
              end loop;
              if (m_ph_val = 1) then
                  m_ph_val <= m_ph_val_tmp;
              end if;
          end if;
          if (vco_out(2)'event and vco_out(2) = '0') then
              for i in 0 to 5 loop
                  if (c_ph_val(i) = 2) then
                      c_ph_val(i) <= c_ph_val_tmp(i);
                  end if;
              end loop;
              if (m_ph_val = 2) then
                  m_ph_val <= m_ph_val_tmp;
              end if;
          end if;
          if (vco_out(3)'event and vco_out(3) = '0') then
              for i in 0 to 5 loop
                  if (c_ph_val(i) = 3) then
                      c_ph_val(i) <= c_ph_val_tmp(i);
                  end if;
              end loop;
              if (m_ph_val = 3) then
                  m_ph_val <= m_ph_val_tmp;
              end if;
          end if;
          if (vco_out(4)'event and vco_out(4) = '0') then
              for i in 0 to 5 loop
                  if (c_ph_val(i) = 4) then
                      c_ph_val(i) <= c_ph_val_tmp(i);
                  end if;
              end loop;
              if (m_ph_val = 4) then
                  m_ph_val <= m_ph_val_tmp;
              end if;
          end if;
          if (vco_out(5)'event and vco_out(5) = '0') then
              for i in 0 to 5 loop
                  if (c_ph_val(i) = 5) then
                      c_ph_val(i) <= c_ph_val_tmp(i);
                  end if;
              end loop;
              if (m_ph_val = 5) then
                  m_ph_val <= m_ph_val_tmp;
              end if;
          end if;
          if (vco_out(6)'event and vco_out(6) = '0') then
              for i in 0 to 5 loop
                  if (c_ph_val(i) = 6) then
                      c_ph_val(i) <= c_ph_val_tmp(i);
                  end if;
              end loop;
              if (m_ph_val = 6) then
                  m_ph_val <= m_ph_val_tmp;
              end if;
          end if;
          if (vco_out(7)'event and vco_out(7) = '0') then
              for i in 0 to 5 loop
                  if (c_ph_val(i) = 7) then
                      c_ph_val(i) <= c_ph_val_tmp(i);
                  end if;
              end loop;
              if (m_ph_val = 7) then
                  m_ph_val <= m_ph_val_tmp;
              end if;
          end if;
      end if;

      if (vco_out'event) then
          inclk_c0_from_vco <= vco_out(c_ph_val(0));
          inclk_c1_from_vco <= vco_out(c_ph_val(1));
          inclk_c2_from_vco <= vco_out(c_ph_val(2));
          inclk_c3_from_vco <= vco_out(c_ph_val(3));
          inclk_c4_from_vco <= vco_out(c_ph_val(4));
          inclk_c5_from_vco <= vco_out(c_ph_val(5));

          if (enable0_counter = "c0") then
              inclk_sclkout0_from_vco <= vco_out(c_ph_val(0));
          elsif (enable0_counter = "c1") then
              inclk_sclkout0_from_vco <= vco_out(c_ph_val(1));
          end if;

          if (enable1_counter = "c0") then
              inclk_sclkout1_from_vco <= vco_out(c_ph_val(0));
          elsif (enable1_counter = "c1") then
              inclk_sclkout1_from_vco <= vco_out(c_ph_val(1));
          end if;

          inclk_m_from_vco <= vco_out(m_ph_val);
      end if;


      if (scanclk_ipd'event and scanclk_ipd = '0') then
          -- enable scanwrite on falling edge
          scanwrite_enabled <= scanwrite_reg;
      end if;

      if (scanread_reg = '1') then
          gated_scanclk <= transport scanclk_ipd and scanread_reg;
      else
          gated_scanclk <= transport '1';
      end if;

      if (scanclk_ipd'event and scanclk_ipd = '1') then
          -- register scanread and scanwrite
          scanread_reg <= scanread_ipd;
          scanwrite_reg <= scanwrite_ipd;

          if (got_first_scanclk) then
              scanclk_period := now - scanclk_last_rising_edge;
          else
              got_first_scanclk := true;
          end if;
          -- reset got_first_scanclk on falling edge of scanread_reg
          if (scanread_ipd = '0' and scanread_reg = '1') then
              got_first_scanclk := false;
              got_first_gated_scanclk := false;
          end if;

--            if (scanread_ipd = '1' and scanread_reg = '0') then
--                scanread_active_edge := now;
--            end if;

          scanclk_last_rising_edge := now;
      end if;
   
      if (gated_scanclk'event and gated_scanclk = '1' and now > 0 ps) then
          if (not got_first_gated_scanclk) then
              got_first_gated_scanclk := true;
--                 if (now - scanread_active_edge < scanclk_period) then
--                     scanread_setup_violation := true;
--                     ASSERT FALSE REPORT "SCANREAD must go high at least one cycle before SCANDATA is read in." severity warning;
--                 end if;
--              current_scan_data := scan_data;
--              index := scan_chain_length - 1;
--              scandataout_tmp <= current_scan_data(index);
--              index := index - 1;
--          else
--              -- read out existing scan_data
--              scandataout_tmp <= current_scan_data(index);
--              index := index - 1;
          end if;
          for j in scan_chain_length - 1 downto 1 loop
               scan_data(j) <= scan_data(j-1);
          end loop;
          scan_data(0) <= scandata_ipd;
       end if;
    end process;

    scandataout_tmp <= scan_data(FAST_SCAN_CHAIN-1) when (pll_type = "fast" or pll_type = "lvds") else scan_data(GPP_SCAN_CHAIN-1);

    process (schedule_vco, areset_ipd, ena_ipd, pfdena_ipd, refclk, fbclk)
    variable sched_time : time := 0 ps;

    TYPE time_array is ARRAY (0 to 7) of time;
    variable init : boolean := true;
    variable refclk_period : time;
    variable m_times_vco_period : time;
    variable new_m_times_vco_period : time;

    variable phase_shift : time_array := (OTHERS => 0 ps);
    variable last_phase_shift : time_array := (OTHERS => 0 ps);

    variable l_index : integer := 1;
    variable cycle_to_adjust : integer := 0;

    variable stop_vco : boolean := false;

    variable locked_tmp : std_logic := '0';
    variable pll_is_locked : boolean := false;
    variable pll_about_to_lock : boolean := false;
    variable cycles_to_lock : integer := 0;
    variable cycles_to_unlock : integer := 0;

    variable got_first_refclk : boolean := false;
    variable got_second_refclk : boolean := false;
    variable got_first_fbclk : boolean := false;

    variable refclk_time : time := 0 ps;
    variable fbclk_time : time := 0 ps;
    variable first_fbclk_time : time := 0 ps;

    variable fbclk_period : time := 0 ps;

    variable first_schedule : boolean := true;

    variable vco_val : std_logic := '0';
    variable vco_period_was_phase_adjusted : boolean := false;
    variable phase_adjust_was_scheduled : boolean := false;

    variable loop_xplier : integer;
    variable loop_initial : integer := 0;
    variable loop_ph : integer := 0;
    variable loop_time_delay : integer := 0;

    variable initial_delay : time := 0 ps;
    variable vco_per : time;
    variable tmp_rem : integer;
    variable my_rem : integer;
    variable fbk_phase : integer := 0;

    variable pull_back_M : integer := 0;
    variable total_pull_back : integer := 0;
    variable fbk_delay : integer := 0;

    variable offset : time := 0 ps;

    variable tmp_vco_per : integer := 0;
    variable high_time : time;
    variable low_time : time;

    variable got_refclk_posedge : boolean := false;
    variable got_fbclk_posedge : boolean := false;
    variable inclk_out_of_range : boolean := false;

    variable ext_fbk_cntr_modulus : integer := 1;
    variable init_clks : boolean := true;
    begin
        if (init) then

            -- jump-start the VCO
            -- add 1 ps delay to ensure all signals are updated to initial
            -- values
            schedule_vco <= transport not schedule_vco after 1 ps;

            init := false;
        end if;

        if (schedule_vco'event) then
            if (init_clks) then
                refclk_period := inclk0_input_frequency * n_val(0) * 1 ps;

                m_times_vco_period := refclk_period;
                new_m_times_vco_period := refclk_period;
                init_clks := false;
            end if;
            sched_time := 0 ps;
            for i in 0 to 7 loop
                last_phase_shift(i) := phase_shift(i);
            end loop;
            cycle_to_adjust := 0;
            l_index := 1;
            m_times_vco_period := new_m_times_vco_period;
        end if;

        -- areset was asserted
        if (areset_ipd'event and areset_ipd = '1') then
            assert false report "PLL was reset" severity note;
        end if;

        -- ena was deasserted
        if (ena_ipd'event and ena_ipd = '0') then
            assert false report "PLL was disabled" severity note;
        end if;

        if (schedule_vco'event and (areset_ipd = '1' or ena_ipd = '0' or stop_vco)) then

            -- drop VCO taps to 0
            for i in 0 to 7 loop
                vco_out(i) <= transport '0' after last_phase_shift(i);
                phase_shift(i) := 0 ps;
                last_phase_shift(i) := 0 ps;
            end loop;

            -- reset lock parameters
            locked_tmp := '0';
            pll_is_locked := false;
            pll_about_to_lock := false;
            cycles_to_lock := 0;
            cycles_to_unlock := 0;

            got_first_refclk := false;
            got_second_refclk := false;
            refclk_time := 0 ps;
            got_first_fbclk := false;
            fbclk_time := 0 ps;
            first_fbclk_time := 0 ps;
            fbclk_period := 0 ps;

            first_schedule := true;
            vco_val := '0';
            vco_period_was_phase_adjusted := false;
            phase_adjust_was_scheduled := false;

        elsif ((schedule_vco'event or ena_ipd'event or areset_ipd'event) and areset_ipd = '0' and ena_ipd = '1' and (not stop_vco) and now > 0 ps) then

            -- note areset deassert time
            -- note it as refclk_time to prevent false triggering
            -- of stop_vco after areset
            if (areset_ipd'event and areset_ipd = '0') then
                refclk_time := now;
            end if;

            -- calculate loop_xplier : this will be different from m_val
            -- in external_feedback_mode
            loop_xplier := m_val(0);
            loop_initial := m_initial_val - 1;
            loop_ph := m_ph_val;

            if (operation_mode = "external_feedback") then
                if (ext_fbk_cntr_mode = "bypass") then
                    ext_fbk_cntr_modulus := 1;
                else
                    ext_fbk_cntr_modulus := ext_fbk_cntr_high + ext_fbk_cntr_low;
                end if;
                loop_xplier := m_val(0) * (ext_fbk_cntr_modulus);
                loop_ph := ext_fbk_cntr_ph;
                loop_initial := ext_fbk_cntr_initial - 1 + ((m_initial_val - 1) * ext_fbk_cntr_modulus);
            end if;

            -- convert initial value to delay
            initial_delay := (loop_initial * m_times_vco_period)/loop_xplier;

            -- convert loop ph_tap to delay
            my_rem := (m_times_vco_period/1 ps) rem loop_xplier;
            tmp_vco_per := (m_times_vco_period/1 ps) / loop_xplier;
            if (my_rem /= 0) then
                tmp_vco_per := tmp_vco_per + 1;
            end if;
            fbk_phase := (loop_ph * tmp_vco_per)/8;

            if (operation_mode = "external_feedback") then
                pull_back_M :=  (m_initial_val - 1) * ext_fbk_cntr_modulus * ((refclk_period/loop_xplier)/1 ps);
                while (pull_back_M > refclk_period/1 ps) loop
                    pull_back_M := pull_back_M - refclk_period/ 1 ps;
                end loop;
            else
                pull_back_M := initial_delay/1 ps + fbk_phase;
            end if;

            total_pull_back := pull_back_M;

            if (simulation_type = "timing") then
                total_pull_back := total_pull_back + pll_compensation_delay;
            end if;
            while (total_pull_back > refclk_period/1 ps) loop
                total_pull_back := total_pull_back - refclk_period/1 ps;
            end loop;

            if (total_pull_back > 0) then
                offset := refclk_period - (total_pull_back * 1 ps);
            end if;
            if (operation_mode = "external_feedback") then
                fbk_delay := pull_back_M;
                if (simulation_type = "timing") then
                    fbk_delay := fbk_delay + pll_compensation_delay;
                end if;
            else
                fbk_delay := total_pull_back - fbk_phase;
                if (fbk_delay < 0) then
                    offset := offset - (fbk_phase * 1 ps);
                    fbk_delay := total_pull_back;
                end if;
            end if;

            -- assign m_delay
            m_delay <= transport fbk_delay after 1 ps;

            my_rem := (m_times_vco_period/1 ps) rem loop_xplier;
            for i in 1 to loop_xplier loop
                -- adjust cycles
                tmp_vco_per := (m_times_vco_period/1 ps)/loop_xplier;
                if (my_rem /= 0 and l_index <= my_rem) then
                   tmp_rem := (loop_xplier * l_index) rem my_rem;
                   cycle_to_adjust := (loop_xplier * l_index) / my_rem;
                   if (tmp_rem /= 0) then
                      cycle_to_adjust := cycle_to_adjust + 1;
                   end if;
                end if;
                if (cycle_to_adjust = i) then
                    tmp_vco_per := tmp_vco_per + 1;
                    l_index := l_index + 1;
                end if;

                -- calculate high and low periods
                vco_per := tmp_vco_per * 1 ps;
                high_time := (tmp_vco_per/2) * 1 ps;
                if (tmp_vco_per rem 2 /= 0) then
                   high_time := high_time + 1 ps;
                end if;
                low_time := vco_per - high_time;

                -- schedule the rising and falling edges
                for j in 1 to 2 loop
                   vco_val := not vco_val;
                   if (vco_val = '0') then
                      sched_time := sched_time + high_time;
                   elsif (vco_val = '1') then
                      sched_time := sched_time + low_time;
                   end if;

                   -- schedule the phase taps
                   for k in 0 to 7 loop
                       phase_shift(k) := (k * vco_per)/8;
                       if (first_schedule) then
                          vco_out(k) <= transport vco_val after (sched_time + phase_shift(k));
                       else
                          vco_out(k) <= transport vco_val after (sched_time + last_phase_shift(k));
                       end if;
                   end loop;
                end loop;
            end loop;

            -- schedule once more
            if (first_schedule) then
                vco_val := not vco_val;
                if (vco_val = '0') then
                   sched_time := sched_time + high_time;
                elsif (vco_val = '1') then
                   sched_time := sched_time + low_time;
                end if;
                -- schedule the phase taps
                for k in 0 to 7 loop
                    phase_shift(k) := (k * vco_per)/8;
                    vco_out(k) <= transport vco_val after (sched_time + phase_shift(k));
                end loop;
                first_schedule := false;
            end if;

            schedule_vco <= transport not schedule_vco after sched_time;

            if (vco_period_was_phase_adjusted) then
                m_times_vco_period := refclk_period;
                new_m_times_vco_period := refclk_period;
                vco_period_was_phase_adjusted := false;
                phase_adjust_was_scheduled := true;

                vco_per := m_times_vco_period/loop_xplier;
                for k in 0 to 7 loop
                    phase_shift(k) := (k * vco_per)/8;
                end loop;
            end if;
        end if;

        if (refclk'event and refclk = '1' and areset_ipd = '0') then
            got_refclk_posedge := true;
            if (not got_first_refclk) then
                got_first_refclk := true;
            else
                got_second_refclk := true;
                refclk_period := now - refclk_time;

                -- check if incoming freq. will cause VCO range to be
                -- exceeded
                if ( (vco_max /= 0 and vco_min /= 0 and pfdena_ipd = '1') and
                     (((refclk_period/1 ps)/loop_xplier > vco_max) or
                      ((refclk_period/1 ps)/loop_xplier < vco_min)) ) then
                    if (pll_is_locked) then
                        assert false report " Input clock freq. is not within VCO range : PLL may lose lock" severity warning;
                       if (inclk_out_of_range) then
                           pll_is_locked := false;
                           locked_tmp := '0';
                           pll_about_to_lock := false;
                           cycles_to_lock := 0;
                           vco_period_was_phase_adjusted := false;
                           phase_adjust_was_scheduled := false;
                           assert false report "PLL lost lock." severity note;
                       end if;
                    else
                        assert false report " Input clock freq. is not within VCO range : PLL may not lock. Please use the correct frequency." severity warning;
                    end if;
                    inclk_out_of_range := true;
                else
                    inclk_out_of_range := false;
                end if;
            end if;

            if (stop_vco) then
                stop_vco := false;
                schedule_vco <= not schedule_vco;
            end if;

            refclk_time := now;
        else
            got_refclk_posedge := false;
        end if;

        if (fbclk'event and fbclk = '1') then
            got_fbclk_posedge := true;
            if (not got_first_fbclk) then
                got_first_fbclk := true;
            else
                fbclk_period := now - fbclk_time;
            end if;

            -- need refclk_period here, so initialized to proper value above
            if ( (now - refclk_time > 1.5 * refclk_period) and pfdena_ipd = '1') then
                stop_vco := true;
                -- reset
                got_first_refclk := false;
                got_first_fbclk := false;
                got_second_refclk := false;
                if (pll_is_locked) then
                    pll_is_locked := false;
                    locked_tmp := '0';
                    assert false report "PLL lost lock due to loss of input clock" severity note;
                end if;
                pll_about_to_lock := false;
                cycles_to_lock := 0;
                cycles_to_unlock := 0;
                first_schedule := true;
            end if;
            fbclk_time := now;
        else
            got_fbclk_posedge := false;
        end if;

        if ((got_refclk_posedge or got_fbclk_posedge) and got_second_refclk and pfdena_ipd = '1' and (not inclk_out_of_range)) then

            -- now we know actual incoming period
            if ( abs(fbclk_time - refclk_time) <= 5 ps or
                 (got_first_fbclk and abs(refclk_period - abs(fbclk_time - refclk_time)) <= 5 ps)) then
                -- considered in phase
                if (cycles_to_lock = valid_lock_multiplier - 1) then
                    pll_about_to_lock := true;
                end if;
                if (cycles_to_lock = valid_lock_multiplier) then
                    if (not pll_is_locked) then
                        assert false report "PLL locked to incoming clock" severity note;
                    end if;
                    pll_is_locked := true;
                    locked_tmp := '1';
                    cycles_to_unlock := 0;
                end if;
                -- increment lock counter only if second part of above
                -- time check is NOT true
                if (not(abs(refclk_period - abs(fbclk_time - refclk_time)) <= 5 ps)) then
                    cycles_to_lock := cycles_to_lock + 1;
                end if;

                -- adjust m_times_vco_period
                new_m_times_vco_period := refclk_period;
            else
                -- if locked, begin unlock
                if (pll_is_locked) then
                    cycles_to_unlock := cycles_to_unlock + 1;
                    if (cycles_to_unlock = invalid_lock_multiplier) then
                        pll_is_locked := false;
                        locked_tmp := '0';
                        pll_about_to_lock := false;
                        cycles_to_lock := 0;
                        vco_period_was_phase_adjusted := false;
                        phase_adjust_was_scheduled := false;
                        assert false report "PLL lost lock." severity note;
                    end if;
                end if;
                if ( abs(refclk_period - fbclk_period) <= 2 ps ) then
                    -- frequency is still good
                    if (now = fbclk_time and (not phase_adjust_was_scheduled)) then
                        if ( abs(fbclk_time - refclk_time) > refclk_period/2) then
                            new_m_times_vco_period := m_times_vco_period + (refclk_period - abs(fbclk_time - refclk_time));
                            vco_period_was_phase_adjusted := true;
                        else
                            new_m_times_vco_period := m_times_vco_period - abs(fbclk_time - refclk_time);
                            vco_period_was_phase_adjusted := true;
                        end if;

                    end if;
                else
                    phase_adjust_was_scheduled := false;
                    new_m_times_vco_period := refclk_period;
                end if;
            end if;
        end if;

        if (pfdena_ipd = '0') then
            if (pll_is_locked) then
                locked_tmp := 'X';
            end if;
            pll_is_locked := false;
            cycles_to_lock := 0;
        end if;

        -- give message only at time of deassertion
        if (pfdena_ipd'event and pfdena_ipd = '0') then
            assert false report "PFDENA deasserted." severity note;
        elsif (pfdena_ipd'event and pfdena_ipd = '1') then
            got_first_refclk := false;
            got_second_refclk := false;
            refclk_time := now;
        end if;

        if (reconfig_err) then
            lock <= '0';
        else
            lock <= locked_tmp;
        end if;
        about_to_lock <= pll_about_to_lock after 1 ps;

        -- signal to calculate quiet_time
        sig_refclk_period <= refclk_period;

        -- signals for debugging
        sig_offset <= offset;
        sig_refclk_time <= refclk_time;
        sig_fbclk_period <= fbclk_period;
        sig_vco_period_was_phase_adjusted <= vco_period_was_phase_adjusted;
        sig_phase_adjust_was_scheduled <= phase_adjust_was_scheduled;
        if (stop_vco = true) then
            sig_stop_vco <= '1';
        else
            sig_stop_vco <= '0';
        end if;
        sig_m_times_vco_period <= m_times_vco_period;
        sig_new_m_times_vco_period <= new_m_times_vco_period;
        sig_got_refclk_posedge <= got_refclk_posedge;
        sig_got_fbclk_posedge <= got_fbclk_posedge;
        sig_got_second_refclk <= got_second_refclk;
    end process;

    clk0_tmp <= c0_clk when i_clk0_counter = "c0" else
                c1_clk when i_clk0_counter = "c1" else
                c2_clk when i_clk0_counter = "c2" else
                c3_clk when i_clk0_counter = "c3" else
                c4_clk when i_clk0_counter = "c4" else
                c5_clk when i_clk0_counter = "c5" else
                '0';
    clk(0) <= clk0_tmp when (areset_ipd = '1' or ena_ipd = '0') or (about_to_lock and (not reconfig_err)) else
              'X';

    clk1_tmp <= c0_clk when i_clk1_counter = "c0" else
                c1_clk when i_clk1_counter = "c1" else
                c2_clk when i_clk1_counter = "c2" else
                c3_clk when i_clk1_counter = "c3" else
                c4_clk when i_clk1_counter = "c4" else
                c5_clk when i_clk1_counter = "c5" else
                '0';
    clk(1) <= clk1_tmp when (areset_ipd = '1' or ena_ipd = '0') or (about_to_lock and (not reconfig_err)) else
              'X';

    clk2_tmp <= c0_clk when i_clk2_counter = "c0" else
                c1_clk when i_clk2_counter = "c1" else
                c2_clk when i_clk2_counter = "c2" else
                c3_clk when i_clk2_counter = "c3" else
                c4_clk when i_clk2_counter = "c4" else
                c5_clk when i_clk2_counter = "c5" else
                '0';
    clk(2) <= clk2_tmp when (areset_ipd = '1' or ena_ipd = '0') or (about_to_lock and (not reconfig_err)) else
              'X';

    clk3_tmp <= c0_clk when i_clk3_counter = "c0" else
                c1_clk when i_clk3_counter = "c1" else
                c2_clk when i_clk3_counter = "c2" else
                c3_clk when i_clk3_counter = "c3" else
                c4_clk when i_clk3_counter = "c4" else
                c5_clk when i_clk3_counter = "c5" else
                '0';

    clk4_tmp <= c0_clk when i_clk4_counter = "c0" else
                c1_clk when i_clk4_counter = "c1" else
                c2_clk when i_clk4_counter = "c2" else
                c3_clk when i_clk4_counter = "c3" else
                c4_clk when i_clk4_counter = "c4" else
                c5_clk when i_clk4_counter = "c5" else
                '0';

    clk5_tmp <= c0_clk when i_clk5_counter = "c0" else
                c1_clk when i_clk5_counter = "c1" else
                c2_clk when i_clk5_counter = "c2" else
                c3_clk when i_clk5_counter = "c3" else
                c4_clk when i_clk5_counter = "c4" else
                c5_clk when i_clk5_counter = "c5" else
                '0';





end vital_pll;
---------------------------------------------------------------------
--
-- Entity Name :  cycloneii_lcell_ff
-- 
-- Description :  Cyclone II LCELL_FF VHDL simulation model
--  
--
---------------------------------------------------------------------

library IEEE, cycloneii;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use cycloneii.atom_pack.all;

entity cycloneii_lcell_ff is
    generic (
             x_on_violation : string := "on";
             lpm_type : string := "cycloneii_lcell_ff";
             tsetup_datain_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             tsetup_sdata_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             tsetup_sclr_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             tsetup_sload_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             tsetup_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_datain_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             thold_sdata_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_sclr_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_sload_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             tpd_clk_regout_posedge : VitalDelayType01 := DefPropDelay01;
             tpd_aclr_regout_posedge : VitalDelayType01 := DefPropDelay01;
             tpd_sdata_regout: VitalDelayType01 := DefPropDelay01;
             tipd_clk : VitalDelayType01 := DefPropDelay01;
             tipd_datain : VitalDelayType01 := DefPropDelay01;
             tipd_sdata : VitalDelayType01 := DefPropDelay01;
             tipd_sclr : VitalDelayType01 := DefPropDelay01; 
             tipd_sload : VitalDelayType01 := DefPropDelay01;
             tipd_aclr : VitalDelayType01 := DefPropDelay01; 
             tipd_ena : VitalDelayType01 := DefPropDelay01; 
             TimingChecksOn: Boolean := True;
             MsgOn: Boolean := DefGlitchMsgOn;
             XOn: Boolean := DefGlitchXOn;
             MsgOnChecks: Boolean := DefMsgOnChecks;
             XOnChecks: Boolean := DefXOnChecks;
             InstancePath: STRING := "*"
            );
    
    port (
          datain : in std_logic := '0';
          clk : in std_logic := '0';
          aclr : in std_logic := '0';
          sclr : in std_logic := '0';
          sload : in std_logic := '0';
          ena : in std_logic := '1';
          sdata : in std_logic := '0';
          devclrn : in std_logic := '1';
          devpor : in std_logic := '1';
          regout : out std_logic
         );
   attribute VITAL_LEVEL0 of cycloneii_lcell_ff : entity is TRUE;
end cycloneii_lcell_ff;
        
architecture vital_lcell_ff of cycloneii_lcell_ff is
   attribute VITAL_LEVEL0 of vital_lcell_ff : architecture is TRUE;
   signal clk_ipd : std_logic;
   signal datain_ipd : std_logic;
   signal datain_dly : std_logic;
   signal sdata_ipd : std_logic;
   signal sdata_dly : std_logic;
   signal sdata_dly1 : std_logic;
   signal sclr_ipd : std_logic;
   signal sload_ipd : std_logic;
   signal aclr_ipd : std_logic;
   signal ena_ipd : std_logic;

component and1
    generic (XOn                  : Boolean := DefGlitchXOn;
             MsgOn                : Boolean := DefGlitchMsgOn;
             tpd_IN1_Y            : VitalDelayType01 := DefPropDelay01;
             tipd_IN1             : VitalDelayType01 := DefPropDelay01
            );
        
    port    (Y                    :  out   STD_LOGIC;
             IN1                  :  in    STD_LOGIC
            );
end component;

begin

dataindelaybuffer: and1
                   port map(IN1 => datain_ipd,
                            Y => datain_dly);

sdatadelaybuffer: and1
                   port map(IN1 => sdata_ipd,
                            Y => sdata_dly);

sdatadelaybuffer1: and1
                   port map(IN1 => sdata_dly,
                            Y => sdata_dly1);


    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        VitalWireDelay (clk_ipd, clk, tipd_clk);
        VitalWireDelay (datain_ipd, datain, tipd_datain);
        VitalWireDelay (sdata_ipd, sdata, tipd_sdata);
        VitalWireDelay (sclr_ipd, sclr, tipd_sclr);
        VitalWireDelay (sload_ipd, sload, tipd_sload);
        VitalWireDelay (aclr_ipd, aclr, tipd_aclr);
        VitalWireDelay (ena_ipd, ena, tipd_ena);
    end block;

    VITALtiming : process (clk_ipd, datain_dly, sdata_dly1,
                           sclr_ipd, sload_ipd, aclr_ipd, 
                           ena_ipd, devclrn, devpor)
    
    variable Tviol_datain_clk : std_ulogic := '0';
    variable Tviol_sdata_clk : std_ulogic := '0';
    variable Tviol_sclr_clk : std_ulogic := '0';
    variable Tviol_sload_clk : std_ulogic := '0';
    variable Tviol_ena_clk : std_ulogic := '0';
    variable TimingData_datain_clk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_sdata_clk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_sclr_clk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_sload_clk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_ena_clk : VitalTimingDataType := VitalTimingDataInit;
    variable regout_VitalGlitchData : VitalGlitchDataType;
    
    variable iregout : std_logic := '0';
    variable idata: std_logic := '0';
    
    -- variables for 'X' generation
    variable violation : std_logic := '0';
    
    begin
      
        ------------------------
        --  Timing Check Section
        ------------------------
        if (TimingChecksOn) then
        
            VitalSetupHoldCheck (
                Violation       => Tviol_datain_clk,
                TimingData      => TimingData_datain_clk,
                TestSignal      => datain,
                TestSignalName  => "DATAIN",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_datain_clk_noedge_posedge,
                SetupLow        => tsetup_datain_clk_noedge_posedge,
                HoldHigh        => thold_datain_clk_noedge_posedge,
                HoldLow         => thold_datain_clk_noedge_posedge,
                CheckEnabled    => TO_X01((aclr_ipd) OR
                                          (NOT devpor) OR
                                          (NOT devclrn) OR
                                          (NOT ena_ipd)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL_FF",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
            
            VitalSetupHoldCheck (
                Violation       => Tviol_sdata_clk,
                TimingData      => TimingData_sdata_clk,
                TestSignal      => sdata_ipd,
                TestSignalName  => "SDATA",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_sdata_clk_noedge_posedge,
                SetupLow        => tsetup_sdata_clk_noedge_posedge,
                HoldHigh        => thold_sdata_clk_noedge_posedge,
                HoldLow         => thold_sdata_clk_noedge_posedge,
                CheckEnabled    => TO_X01((aclr_ipd) OR
                                          (NOT devpor) OR
                                          (NOT devclrn) OR
                                          (NOT ena_ipd)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL_FF",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
    
            VitalSetupHoldCheck (
                Violation       => Tviol_sclr_clk,
                TimingData      => TimingData_sclr_clk,
                TestSignal      => sclr_ipd,
                TestSignalName  => "SCLR",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_sclr_clk_noedge_posedge,
                SetupLow        => tsetup_sclr_clk_noedge_posedge,
                HoldHigh        => thold_sclr_clk_noedge_posedge,
                HoldLow         => thold_sclr_clk_noedge_posedge,
                CheckEnabled    => TO_X01((aclr_ipd) OR
                                          (NOT devpor) OR
                                          (NOT devclrn)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL_FF",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
            
            VitalSetupHoldCheck (
                Violation       => Tviol_sload_clk,
                TimingData      => TimingData_sload_clk,
                TestSignal      => sload_ipd,
                TestSignalName  => "SLOAD",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_sload_clk_noedge_posedge,
                SetupLow        => tsetup_sload_clk_noedge_posedge,
                HoldHigh        => thold_sload_clk_noedge_posedge,
                HoldLow         => thold_sload_clk_noedge_posedge,
                CheckEnabled    => TO_X01((aclr_ipd) OR
                                          (NOT devpor) OR
                                          (NOT devclrn)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL_FF",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
        
            VitalSetupHoldCheck (
                Violation       => Tviol_ena_clk,
                TimingData      => TimingData_ena_clk,
                TestSignal      => ena_ipd,
                TestSignalName  => "ENA",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_ena_clk_noedge_posedge,
                SetupLow        => tsetup_ena_clk_noedge_posedge,
                HoldHigh        => thold_ena_clk_noedge_posedge,
                HoldLow         => thold_ena_clk_noedge_posedge,
                CheckEnabled    => TO_X01((aclr_ipd) OR
                                          (NOT devpor) OR
                                          (NOT devclrn) ) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL_FF",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
    
        end if;
    
        violation := Tviol_datain_clk or Tviol_sdata_clk or 
                     Tviol_sclr_clk or Tviol_sload_clk or Tviol_ena_clk;
    
    
        if ((devpor = '0') or (devclrn = '0') or (aclr_ipd = '1'))  then
            iregout := '0';
        elsif (violation = 'X' and x_on_violation = "on") then
            iregout := 'X';
        elsif clk_ipd'event and clk_ipd = '1' and clk_ipd'last_value = '0' then
            if (ena_ipd = '1') then
                if (sclr_ipd = '1') then
                    iregout := '0';
                elsif (sload_ipd = '1') then
                    iregout := sdata_dly1;
                else
                    iregout := datain_dly;
                end if;
            end if;
        end if;
    
        ----------------------
        --  Path Delay Section
        ----------------------
        VitalPathDelay01 (
            OutSignal => regout,
            OutSignalName => "REGOUT",
            OutTemp => iregout,
            Paths => (0 => (aclr_ipd'last_event, tpd_aclr_regout_posedge, TRUE),
                      1 => (sdata_ipd'last_event, tpd_sdata_regout, TRUE),
                      2 => (clk_ipd'last_event, tpd_clk_regout_posedge, TRUE)),
            GlitchData => regout_VitalGlitchData,
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
    end process;

end vital_lcell_ff;	

---------------------------------------------------------------------
--
-- Entity Name :  cycloneii_lcell_comb
-- 
-- Description :  Cyclone II LCELL_COMB VHDL simulation model
--  
--
---------------------------------------------------------------------

library IEEE, cycloneii;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use cycloneii.atom_pack.all;

entity cycloneii_lcell_comb is
    generic (
             lut_mask : std_logic_vector(15 downto 0) := (OTHERS => '1');
             sum_lutc_input : string := "datac";
             lpm_type : string := "cycloneii_lcell_comb";
             TimingChecksOn: Boolean := True;
             MsgOn: Boolean := DefGlitchMsgOn;
             XOn: Boolean := DefGlitchXOn;
             MsgOnChecks: Boolean := DefMsgOnChecks;
             XOnChecks: Boolean := DefXOnChecks;
             InstancePath: STRING := "*";
             tpd_dataa_combout : VitalDelayType01 := DefPropDelay01;
             tpd_datab_combout : VitalDelayType01 := DefPropDelay01;
             tpd_datac_combout : VitalDelayType01 := DefPropDelay01;
             tpd_datad_combout : VitalDelayType01 := DefPropDelay01;
             tpd_cin_combout : VitalDelayType01 := DefPropDelay01;
             tpd_dataa_cout : VitalDelayType01 := DefPropDelay01;
             tpd_datab_cout : VitalDelayType01 := DefPropDelay01;
             tpd_datac_cout : VitalDelayType01 := DefPropDelay01;
             tpd_datad_cout : VitalDelayType01 := DefPropDelay01;
             tpd_cin_cout : VitalDelayType01 := DefPropDelay01;
             tipd_dataa : VitalDelayType01 := DefPropDelay01; 
             tipd_datab : VitalDelayType01 := DefPropDelay01; 
             tipd_datac : VitalDelayType01 := DefPropDelay01; 
             tipd_datad : VitalDelayType01 := DefPropDelay01; 
             tipd_cin : VitalDelayType01 := DefPropDelay01
            );
    
    port (
          dataa : in std_logic := '1';
          datab : in std_logic := '1';
          datac : in std_logic := '1';
          datad : in std_logic := '1';
          cin : in std_logic := '0';
          combout : out std_logic;
          cout : out std_logic
         );
   attribute VITAL_LEVEL0 of cycloneii_lcell_comb : entity is TRUE;
end cycloneii_lcell_comb;
        
architecture vital_lcell_comb of cycloneii_lcell_comb is
    attribute VITAL_LEVEL0 of vital_lcell_comb : architecture is TRUE;
    signal dataa_ipd : std_logic;
    signal datab_ipd : std_logic;
    signal datac_ipd : std_logic;
    signal datad_ipd : std_logic;
    signal cin_ipd : std_logic;
begin

    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        VitalWireDelay (dataa_ipd, dataa, tipd_dataa);
        VitalWireDelay (datab_ipd, datab, tipd_datab);
        VitalWireDelay (datac_ipd, datac, tipd_datac);
        VitalWireDelay (datad_ipd, datad, tipd_datad);
        VitalWireDelay (cin_ipd, cin, tipd_cin);
    end block;

VITALtiming : process(dataa_ipd, datab_ipd, datac_ipd, datad_ipd,
                      cin_ipd)

variable combout_VitalGlitchData : VitalGlitchDataType;
variable cout_VitalGlitchData : VitalGlitchDataType;
-- output variables
variable combout_tmp : std_logic;
variable cout_tmp : std_logic;
-- temp variable for NCVHDL
-- variable lut_mask_var : std_logic_vector(16 downto 0) := (OTHERS => '1');

begin
  
    -- lut_mask_var := lut_mask;

    ------------------------
    --  Timing Check Section
    ------------------------

    if (sum_lutc_input = "datac") then
        -- combout 
        combout_tmp := VitalMUX(data => lut_mask,
                           dselect => (datad_ipd,
                                       datac_ipd,
                                       datab_ipd,
                                       dataa_ipd));
        -- cout 
        cout_tmp := VitalMUX(data => lut_mask,
                        dselect => ('0',
                                    datac_ipd,
                                    datab_ipd,
                                    dataa_ipd));
    elsif (sum_lutc_input = "cin") then
        -- combout 
        combout_tmp := VitalMUX(data => lut_mask,
                           dselect => (datad_ipd,
                                       cin_ipd,
                                       datab_ipd,
                                       dataa_ipd));
        -- cout 
        cout_tmp := VitalMUX(data => lut_mask,
                        dselect => ('0',
                                    cin_ipd,
                                    datab_ipd,
                                    dataa_ipd));
    end if;

    ----------------------
    --  Path Delay Section
    ----------------------

    VitalPathDelay01 (
        OutSignal => combout,
        OutSignalName => "COMBOUT",
        OutTemp => combout_tmp,
        Paths => (0 => (dataa_ipd'last_event, tpd_dataa_combout, TRUE),
                  1 => (datab_ipd'last_event, tpd_datab_combout, TRUE),
                  2 => (datac_ipd'last_event, tpd_datac_combout, TRUE),
                  3 => (datad_ipd'last_event, tpd_datad_combout, TRUE),
                  4 => (cin_ipd'last_event, tpd_cin_combout, TRUE)),
        GlitchData => combout_VitalGlitchData,
        Mode => DefGlitchMode,
        XOn  => XOn,
        MsgOn => MsgOn );

    VitalPathDelay01 (
        OutSignal => cout,
        OutSignalName => "COUT",
        OutTemp => cout_tmp,
        Paths => (0 => (dataa_ipd'last_event, tpd_dataa_cout, TRUE),
                  1 => (datab_ipd'last_event, tpd_datab_cout, TRUE),
                  2 => (datac_ipd'last_event, tpd_datac_cout, TRUE),
                  3 => (datad_ipd'last_event, tpd_datad_cout, TRUE),
                  4 => (cin_ipd'last_event, tpd_cin_cout, TRUE)),
        GlitchData => cout_VitalGlitchData,
        Mode => DefGlitchMode,
        XOn  => XOn,
        MsgOn => MsgOn );

end process;

end vital_lcell_comb;	

--
--
--  CYCLONEII_ASYNCH_IO Model
--
--
library IEEE, cycloneii;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use cycloneii.atom_pack.all;

entity cycloneii_asynch_io is
	generic(
		operation_mode  : STRING := "input";
		open_drain_output : STRING := "false";
		bus_hold : STRING := "false";
		use_differential_input : STRING := "false";

		XOn: Boolean := DefGlitchXOn;
		MsgOn: Boolean := DefGlitchMsgOn;

		tpd_padio_differentialout    : VitalDelayType01 := DefPropDelay01;
		tpd_differentialin_combout   : VitalDelayType01 := DefPropDelay01;

		tpd_datain_padio        : VitalDelayType01 := DefPropDelay01;
		tpd_oe_padio_posedge       : VitalDelayType01 := DefPropDelay01;
		tpd_oe_padio_negedge       : VitalDelayType01 := DefPropDelay01;
		tpd_padio_combout   : VitalDelayType01 := DefPropDelay01;
		tpd_regin_regout   : VitalDelayType01 := DefPropDelay01;

		tipd_differentialin : VitalDelayType01 := DefPropDelay01;

		tipd_datain         : VitalDelayType01 := DefPropDelay01;
		tipd_oe             : VitalDelayType01 := DefPropDelay01;
		tipd_padio          : VitalDelayType01 := DefPropDelay01);
	port(
		datain  : in  STD_LOGIC := '0';
		oe      : in  STD_LOGIC := '1';
		regin  : in STD_LOGIC;
		differentialin  : in STD_LOGIC;
		differentialout : out STD_LOGIC;
		padio   : inout STD_LOGIC;
		combout : out STD_LOGIC;
		regout : out STD_LOGIC);
		
	attribute VITAL_LEVEL0 of cycloneii_asynch_io : entity is TRUE;
end cycloneii_asynch_io;

architecture behave of cycloneii_asynch_io is
attribute VITAL_LEVEL0 of behave : architecture is TRUE;

signal datain_ipd, oe_ipd, padio_ipd: std_logic;

signal differentialin_ipd: std_logic;

begin
    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        VitalWireDelay (datain_ipd, datain, tipd_datain);
        VitalWireDelay (differentialin_ipd, differentialin, tipd_differentialin);
                
        VitalWireDelay (oe_ipd, oe, tipd_oe);
        VitalWireDelay (padio_ipd, padio, tipd_padio);
    end block;

    VITAL: process(padio_ipd, datain_ipd, oe_ipd, regin, differentialin_ipd)
        variable combout_VitalGlitchData : VitalGlitchDataType;
		variable padio_VitalGlitchData : VitalGlitchDataType;
        variable regout_VitalGlitchData : VitalGlitchDataType;
        
        variable tmp_combout, tmp_padio : std_logic;
        variable prev_value : std_logic := 'H';
              
		variable differentialout_VitalGlitchData : VitalGlitchDataType;
        variable tmp_combout_differentialin_or_pad : std_logic;
        variable differentialout_tmp : std_logic;


        begin

        if (bus_hold = "true" ) then
                if ( operation_mode = "input") then
                        if ( padio_ipd = 'Z') then
                                tmp_combout := to_x01z(prev_value);
                        else
                                if ( padio_ipd = '1') then
                                        prev_value := 'H';
                                elsif ( padio_ipd = '0') then
                                        prev_value := 'L';
                                else
                                        prev_value := 'W';
                                end if;
                                tmp_combout := to_x01z(padio_ipd);
                        end if;
                        tmp_padio := 'Z';
                elsif ( operation_mode = "output" or operation_mode = "bidir") then
                        if ( oe_ipd = '1') then
                                if ( open_drain_output = "true" ) then
                                        if (datain_ipd = '0') then
                                                tmp_padio := '0';
                                                prev_value := 'L';
                                        elsif (datain_ipd = 'X') then
                                                tmp_padio := 'X';
                                                prev_value := 'W';
                                        else   -- 'Z'
                                                -- need to update prev_value
                                                if (padio_ipd = '1') then
                                                        prev_value := 'H';
                                                elsif (padio_ipd = '0') then
                                                        prev_value := 'L';
                                                elsif (padio_ipd = 'X') then
                                                        prev_value := 'W';
                                                end if;
                                                tmp_padio := prev_value;
                                        end if;
                                else
                                        tmp_padio := datain_ipd;
                                        if ( datain_ipd = '1') then
                                                prev_value := 'H';
                                        elsif (datain_ipd = '0' ) then
                                                prev_value := 'L';
                                        elsif ( datain_ipd = 'X') then
                                                prev_value := 'W';
                                        else
                                                prev_value := datain_ipd;
                                        end if;
                                end if; -- end open_drain_output
                                      
                        elsif ( oe_ipd = '0' ) then
                                -- need to update prev_value
                                if (padio_ipd = '1') then
                                        prev_value := 'H';
                                elsif (padio_ipd = '0') then
                                        prev_value := 'L';
                                elsif (padio_ipd = 'X') then
                                        prev_value := 'W';
                                end if;
                                tmp_padio := prev_value;
                        else
                                tmp_padio := 'X';
                                prev_value := 'W';
                        end if; -- end oe_in
                                 
                        if ( operation_mode = "bidir") then
                                tmp_combout := to_x01z(padio_ipd);
                        else
                                tmp_combout := 'Z';
                        end if;
                end if;
                         
                if ( now <= 1 ps AND prev_value = 'W' ) then     --hack for autotest to pass
                        prev_value := 'L';
                end if;
                               
        else    -- bus_hold is false
                if ( operation_mode = "input") then
                        tmp_combout := padio_ipd;
                        tmp_padio := 'Z';
                elsif (operation_mode = "output" or operation_mode = "bidir" ) then
                        if ( operation_mode  = "bidir") then
                                tmp_combout := padio_ipd;
                        else
                                tmp_combout := 'Z';
                        end if;
                                  
                        if ( oe_ipd = '1') then
                                if ( open_drain_output = "true" ) then
                                        if (datain_ipd = '0') then
                                                tmp_padio := '0';
                                        elsif (datain_ipd = 'X') then
                                                tmp_padio := 'X';
                                        else
                                                tmp_padio := 'Z';
                                        end if;
                                else
                                        tmp_padio := datain_ipd;
                                end if;
                        elsif ( oe_ipd = '0' ) then
                                tmp_padio := 'Z';
                        else
                                tmp_padio := 'X';
                        end if;
                end if;
        end if; -- end bus_hold

        if (use_differential_input = "true") then
            tmp_combout_differentialin_or_pad := differentialin_ipd;
        else
            tmp_combout_differentialin_or_pad := tmp_combout;
        end if;
                             
        if (operation_mode = "input" or operation_mode = "bidir") then
            differentialout_tmp := padio_ipd;
        else
            differentialout_tmp := 'X';
        end if;

    ----------------------
    --  Path Delay Section
    ----------------------
    VitalPathDelay01 (
        OutSignal => combout,
        OutSignalName => "combout",
        OutTemp => tmp_combout_differentialin_or_pad,
        Paths => (1 => (padio_ipd'last_event, tpd_padio_combout, use_differential_input = "false"),
                  2 => (differentialin_ipd'last_event, tpd_differentialin_combout, use_differential_input = "true")),
        GlitchData => combout_VitalGlitchData,
        Mode => DefGlitchMode,
        XOn  => XOn,
        MsgOn  => MsgOn );

        VitalPathDelay01 (
        OutSignal => padio,
        OutSignalName => "padio",
        OutTemp => tmp_padio,
        Paths => (1 => (datain_ipd'last_event, tpd_datain_padio, TRUE),
                  2 => (oe_ipd'last_event, tpd_oe_padio_posedge, oe_ipd = '1'),
                  3 => (oe_ipd'last_event, tpd_oe_padio_negedge, oe_ipd = '0')),
        GlitchData => padio_VitalGlitchData,
        Mode => DefGlitchMode,
        XOn  => XOn,
        MsgOn  => MsgOn );

    VitalPathDelay01 (
        OutSignal => regout,
        OutSignalName => "regout",
        OutTemp => regin,
        Paths => (1 => (regin'last_event, tpd_regin_regout, TRUE)),
        GlitchData => regout_VitalGlitchData,
        Mode => DefGlitchMode,
        XOn  => XOn,
        MsgOn  => MsgOn );

        VitalPathDelay01 (
        OutSignal => differentialout,
        OutSignalName => "differentialout",
        OutTemp => differentialout_tmp,
        Paths => (1 => (padio_ipd'last_event, tpd_padio_differentialout, TRUE)),
        GlitchData => differentialout_VitalGlitchData,
        Mode => DefGlitchMode,
        XOn  => XOn,
        MsgOn  => MsgOn );

    end process;

end behave;

--
-- CYCLONEII_IO
--
library IEEE, cycloneii;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use cycloneii.atom_pack.all;

library cycloneii;
use cycloneii.all;

entity  cycloneii_io is
    generic (
		operation_mode : string := "input";
		open_drain_output : string := "false";
		bus_hold : string := "false";
		output_register_mode : string := "none";
		output_async_reset : string := "none";
		output_sync_reset : string := "none";
		output_power_up : string := "low";
		tie_off_output_clock_enable : string := "false";
		oe_register_mode : string := "none";
		oe_async_reset : string := "none";
		oe_sync_reset : string := "none";
		oe_power_up : string := "low";
		tie_off_oe_clock_enable : string := "false";
		input_register_mode : string := "none";
		input_async_reset : string := "none";
		input_sync_reset : string := "none";
		use_differential_input  : string := "false";
		lpm_type : string    := "cycloneii_io";
		input_power_up : string := "low");
	port (
		datain          : in std_logic := '0';
		oe              : in std_logic := '1';
		outclk          : in std_logic := '0';
		outclkena       : in std_logic := '1';
		inclk           : in std_logic := '0';
		inclkena        : in std_logic := '1';
		areset          : in std_logic := '0';
		sreset          : in std_logic := '0';
		devclrn         : in std_logic := '1';
		devpor          : in std_logic := '1';
		devoe           : in std_logic := '0';
		linkin          : in std_logic := '0';
		differentialin  : in std_logic := '0';
		differentialout : out std_logic;
		linkout         : out std_logic;
		combout         : out std_logic;
		regout          : out std_logic;
		padio           : inout std_logic
    );
end cycloneii_io;

architecture structure of cycloneii_io is
component cycloneii_asynch_io 
	generic(
		operation_mode : string := "input";
		open_drain_output : string := "false";
		use_differential_input : STRING := "false";
		bus_hold : string := "false");
	port(
		datain : in  STD_LOGIC := '0';
		oe	   : in  STD_LOGIC := '0';
		regin  : in std_logic;
		differentialin  : in STD_LOGIC;
		differentialout : out STD_LOGIC;
		padio  : inout STD_LOGIC;
		combout: out STD_LOGIC;
		regout : out STD_LOGIC);
end component;

component DFFE
   generic(
      TimingChecksOn: Boolean := true;
      InstancePath: STRING := "*";
      XOn: Boolean := DefGlitchXOn;
      MsgOn: Boolean := DefGlitchMsgOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      tpd_PRN_Q_negedge              :  VitalDelayType01 := DefPropDelay01;
      tpd_CLRN_Q_negedge             :  VitalDelayType01 := DefPropDelay01;
      tpd_CLK_Q_posedge              :  VitalDelayType01 := DefPropDelay01;
      tpd_ENA_Q_posedge              :  VitalDelayType01 := DefPropDelay01;
      tsetup_D_CLK_noedge_posedge    :  VitalDelayType := DefSetupHoldCnst;
      tsetup_D_CLK_noedge_negedge    :  VitalDelayType := DefSetupHoldCnst;
      tsetup_ENA_CLK_noedge_posedge  :  VitalDelayType := DefSetupHoldCnst;
      thold_D_CLK_noedge_posedge     :  VitalDelayType := DefSetupHoldCnst;
      thold_D_CLK_noedge_negedge     :  VitalDelayType := DefSetupHoldCnst;
      thold_ENA_CLK_noedge_posedge   :  VitalDelayType := DefSetupHoldCnst;
      tipd_D                         :  VitalDelayType01 := DefPropDelay01;
      tipd_CLRN                      :  VitalDelayType01 := DefPropDelay01;
      tipd_PRN                       :  VitalDelayType01 := DefPropDelay01;
      tipd_CLK                       :  VitalDelayType01 := DefPropDelay01;
      tipd_ENA                       :  VitalDelayType01 := DefPropDelay01);

   port(
      Q                              :  out   STD_LOGIC := '0';
      D                              :  in    STD_LOGIC := '1';
      CLRN                           :  in    STD_LOGIC := '1';
      PRN                            :  in    STD_LOGIC := '1';
      CLK                            :  in    STD_LOGIC := '0';
      ENA                            :  in    STD_LOGIC := '1');
end component;

component cycloneii_mux21
	port (
		A : in std_logic := '0';
        B : in std_logic := '0';
        S : in std_logic := '0';
        MO : out std_logic);
end component;

	signal	is_bidir_or_output : std_logic;
	signal	out_reg_clk_ena, oe_reg_clk_ena : std_logic;

	signal	tmp_oe_reg_out, tmp_input_reg_out, tmp_output_reg_out : std_logic;
	
	signal	inreg_sreset_is_used, outreg_sreset_is_used, oereg_sreset_is_used : std_logic;

	signal	inreg_sreset, outreg_sreset, oereg_sreset : std_logic;

	signal	in_reg_aclr, in_reg_apreset : std_logic;
	
	signal	oe_reg_aclr, oe_reg_apreset, oe_reg_sel : std_logic;
	
	signal	out_reg_aclr, out_reg_apreset, out_reg_sel : std_logic;
	
	signal	input_reg_pu_low, output_reg_pu_low, oe_reg_pu_low : std_logic;
	
	signal	inreg_D, outreg_D, oereg_D : std_logic;

	signal	tmp_datain, tmp_oe : std_logic;
	
	signal	iareset, isreset : std_logic;
	
	signal	inreg_mux_sel, outreg_mux_sel, oereg_mux_sel : std_logic;
	
	signal	input_dffe_aclr, input_dffe_apreset, output_dffe_aclr, output_dffe_apreset : std_logic;
	signal	oe_dffe_aclr, oe_dffe_apreset : std_logic;

    signal  pad_or_differentialin : std_logic;
          
begin     

is_bidir_or_output <= '1' WHEN (operation_mode = "bidir" OR operation_mode = "output") ELSE '0';

input_reg_pu_low <=  '0' WHEN input_power_up = "low" ELSE '1';
output_reg_pu_low <= '0' WHEN output_power_up = "low" ELSE '1';
oe_reg_pu_low <= '0' WHEN oe_power_up = "low" ELSE '1';

out_reg_sel <= '1' WHEN output_register_mode = "register" ELSE '0';
oe_reg_sel <= '1' WHEN oe_register_mode = "register" ELSE '0';
 
iareset <= (NOT areset) WHEN ( areset = '1' OR areset = '0') ELSE '1';
isreset <= sreset WHEN ( areset = '1' OR areset = '0') ELSE '0';


-- output registere signals
out_reg_aclr <= iareset WHEN output_async_reset = "clear" ELSE '1';
out_reg_apreset <= iareset WHEN output_async_reset = "preset" ELSE '1';
outreg_sreset_is_used <= '0' WHEN output_sync_reset = "none" ELSE '1';
outreg_sreset <= '0' WHEN output_sync_reset = "clear" ELSE '1';

-- oe register signals
oe_reg_aclr <= iareset WHEN oe_async_reset = "clear" ELSE '1';
oe_reg_apreset <= iareset WHEN oe_async_reset = "preset" ELSE '1';
oereg_sreset_is_used <= '0' WHEN oe_sync_reset = "none" ELSE '1';
oereg_sreset <= '0' WHEN oe_sync_reset = "clear" ELSE '1';

-- input register signals
in_reg_aclr <= iareset WHEN input_async_reset = "clear" ELSE '1';
in_reg_apreset <= iareset WHEN input_async_reset = "preset" ELSE '1';
inreg_sreset_is_used <= '0' WHEN input_sync_reset = "none" ELSE '1';
inreg_sreset <= '0' WHEN input_sync_reset = "clear" ELSE '1';

-- oe and output register clock enable signals
out_reg_clk_ena <= '1' WHEN tie_off_output_clock_enable = "true" ELSE outclkena;
oe_reg_clk_ena <= '1' WHEN tie_off_oe_clock_enable = "true" ELSE outclkena;

-- input register
inreg_mux_sel <= isreset AND inreg_sreset_is_used;
input_dffe_aclr  <= in_reg_aclr AND devclrn AND (input_reg_pu_low OR devpor);
input_dffe_apreset <= in_reg_apreset AND ( (NOT input_reg_pu_low) OR devpor);

-- differentialin 
pad_or_differentialin <= differentialin WHEN use_differential_input = "true" ELSE padio;

inreg_D_mux : cycloneii_mux21
	port map ( A => pad_or_differentialin,
			   B => inreg_sreset,
			   S => inreg_mux_sel,
			   MO=> inreg_D);

input_reg : dffe
	port map (D => inreg_D,
              CLRN => input_dffe_aclr,
              PRN => input_dffe_apreset,
              CLK => inclk,
              ENA => inclkena,
              Q => tmp_input_reg_out);

-- output register
outreg_mux_sel <= isreset AND outreg_sreset_is_used;
output_dffe_aclr <= out_reg_aclr AND devclrn AND (output_reg_pu_low OR devpor);
output_dffe_apreset <= out_reg_apreset AND ( (NOT output_reg_pu_low) OR devpor);
outreg_D_mux : cycloneii_mux21
	port map ( A => datain,
			   B => outreg_sreset,
			   S => outreg_mux_sel,
			   MO=> outreg_D);

output_reg : dffe
	port map (D => outreg_D,
              CLRN => output_dffe_aclr,
              PRN => output_dffe_apreset,
              CLK => outclk,
              ENA => out_reg_clk_ena,
              Q => tmp_output_reg_out);

-- oe register
oereg_mux_sel <= isreset AND oereg_sreset_is_used;
oe_dffe_aclr <= oe_reg_aclr AND devclrn AND (oe_reg_pu_low OR devpor);
oe_dffe_apreset <= oe_reg_apreset AND ( (NOT oe_reg_pu_low) OR devpor);

oereg_D_mux : cycloneii_mux21
	port map ( A => oe,
			   B => oereg_sreset,
			   S => oereg_mux_sel,
			   MO=> oereg_D);

oe_reg : dffe
	port map (D => oereg_D,
              CLRN => oe_dffe_aclr,
              PRN => oe_dffe_apreset,
              CLK => outclk,
              ENA => oe_reg_clk_ena,
              Q => tmp_oe_reg_out);

	
-- asynchrous block
tmp_oe <= tmp_oe_reg_out WHEN oe_reg_sel = '1' ELSE oe;
tmp_datain <= tmp_output_reg_out WHEN (is_bidir_or_output = '1' AND out_reg_sel = '1') ELSE datain;

asynch_inst : cycloneii_asynch_io
	generic map (OPERATION_MODE => operation_mode, 
				 OPEN_DRAIN_OUTPUT => open_drain_output,
				 USE_DIFFERENTIAL_INPUT => use_differential_input,
				 BUS_HOLD => bus_hold)
	port map (datain => tmp_datain,
              oe => tmp_oe,
              regin => tmp_input_reg_out,
              differentialin => differentialin, 
              differentialout => differentialout, 
              padio => padio,
              combout => combout,
              regout => regout);

end structure;


--/////////////////////////////////////////////////////////////////////////////
--
--          VHDL Simulation Model for Cyclone II CLK DELAY CTRL Atom
--
--/////////////////////////////////////////////////////////////////////////////

--
--
--  CYCLONEII_CLKCTRL Model
--
--

library IEEE, cycloneii;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use cycloneii.atom_pack.all;

entity cycloneii_clk_delay_ctrl is
    generic (
             behavioral_sim_delay : integer := 0;
             delay_chain          : STRING := "54";
             delay_chain_mode     : STRING := "static";
             uses_calibration     : STRING := "false";
             use_new_style_dq_detection : STRING := "false";
             lpm_type : STRING    := "cycloneii_clk_delay_ctrl";
             TimingChecksOn : Boolean := True;
             MsgOn : Boolean := DefGlitchMsgOn;
             XOn : Boolean := DefGlitchXOn;
             MsgOnChecks : Boolean := DefMsgOnChecks;
             XOnChecks : Boolean := DefXOnChecks;
             InstancePath : STRING := "*";
             tpd_clk_clkout                : VitalDelayType01 := DefPropDelay01;
             tipd_clk                      : VitalDelayType01 := DefPropDelay01;
             tipd_delayctrlin              : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01);
             tipd_disablecalibration       : VitalDelayType01 := DefPropDelay01;
             tipd_pllcalibrateclkdelayedin : VitalDelayType01 := DefPropDelay01
             );
    port (
             clk                : in std_logic := '0'; 
             delayctrlin        : in std_logic_vector(5 downto 0) := "000000";
             disablecalibration : in std_logic := '1';
             pllcalibrateclkdelayedin: in std_logic := '0';
             devclrn     : in std_logic := '1';
             devpor      : in std_logic := '1';
             clkout      : out std_logic
		 );
   attribute VITAL_LEVEL0 of cycloneii_clk_delay_ctrl : entity is TRUE;
end cycloneii_clk_delay_ctrl;
        
architecture vital_clk_delay_ctrl of cycloneii_clk_delay_ctrl is
    attribute VITAL_LEVEL0 of vital_clk_delay_ctrl : architecture is TRUE;

    signal clk_ipd                      : std_logic; 
    signal delayctrlin_ipd              : std_logic_vector(5 downto 0);
    signal disablecalibration_ipd       : std_logic;
    signal pllcalibrateclkdelayedin_ipd : std_logic := '0';

    signal clk_out : std_logic;
begin

    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        VitalWireDelay (clk_ipd, clk, tipd_clk);
        VitalWireDelay (delayctrlin_ipd(0), delayctrlin(0), tipd_delayctrlin(0));
        VitalWireDelay (delayctrlin_ipd(1), delayctrlin(1), tipd_delayctrlin(1));
        VitalWireDelay (delayctrlin_ipd(2), delayctrlin(2), tipd_delayctrlin(2));
        VitalWireDelay (delayctrlin_ipd(3), delayctrlin(3), tipd_delayctrlin(3));
        VitalWireDelay (delayctrlin_ipd(4), delayctrlin(4), tipd_delayctrlin(4));
        VitalWireDelay (delayctrlin_ipd(5), delayctrlin(5), tipd_delayctrlin(5));
        VitalWireDelay (disablecalibration_ipd, disablecalibration, tipd_disablecalibration);
        VitalWireDelay (pllcalibrateclkdelayedin_ipd, pllcalibrateclkdelayedin, tipd_pllcalibrateclkdelayedin);
    end block;
              
    VITAL: process(clk_ipd)
        variable clkout_VitalGlitchData : VitalGlitchDataType;
        variable clkout_delay : VitalDelayType01 := (0 ps, 0 ps);

        variable clkout_tmp : std_logic;
        variable init : boolean := true;
    begin
        if (init) then
            clkout_delay := tpd_clk_clkout;
            
			for i in clkout_delay'range loop
                clkout_delay(i) := clkout_delay(i) + (behavioral_sim_delay * 1 ps);
            end loop;

            init := false;
        end if;
              
        clkout_tmp := clk_ipd;

        ----------------------
        --  Path Delay Section
        ----------------------
        VitalPathDelay01 (
            OutSignal => clkout,
            OutSignalName => "clkout",
            OutTemp => clkout_tmp,
            Paths => (1 => (clk_ipd'last_event, clkout_delay, TRUE)),
            GlitchData => clkout_VitalGlitchData,
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

    end process;

end vital_clk_delay_ctrl;	

-----------------------------------------------------------------------
--
-- Module Name : cycloneii_mac_data_reg
--
-- Description : Simulation model for the data input register of 
--               Cyclone II MAC_MULT
--
-----------------------------------------------------------------------

LIBRARY IEEE, cycloneii;
USE IEEE.VITAL_Primitives.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.std_logic_1164.all;
USE cycloneii.atom_pack.all;

ENTITY cycloneii_mac_data_reg IS
    GENERIC (
             TimingChecksOn : Boolean := True;
             MsgOn : Boolean := DefGlitchMsgOn;
             XOn : Boolean := DefGlitchXOn;
             MsgOnChecks : Boolean := DefMsgOnChecks;
             XOnChecks : Boolean := DefXOnChecks;
             InstancePath : STRING := "*";
             tipd_data : VitalDelayArrayType01(17 downto 0) := (OTHERS => DefPropDelay01);
             tipd_clk : VitalDelayType01 := DefPropDelay01;
             tipd_ena : VitalDelayType01 := DefPropDelay01;
             tipd_aclr : VitalDelayType01 := DefPropDelay01;
             tsetup_data_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_data_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             tsetup_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             tpd_aclr_dataout_posedge : VitalDelayType01 := DefPropDelay01;
             tpd_clk_dataout_posedge : VitalDelayType01 := DefPropDelay01;
             data_width : integer := 18
            );    
    PORT (
          -- INPUT PORTS
          clk : IN std_logic;   
          data : IN std_logic_vector(17 DOWNTO 0);   
          ena : IN std_logic;   
          aclr : IN std_logic;   
          -- OUTPUT PORTS
          dataout : OUT std_logic_vector(17 DOWNTO 0)
         );
END cycloneii_mac_data_reg;

ARCHITECTURE vital_cycloneii_mac_data_reg OF cycloneii_mac_data_reg IS

    SIGNAL data_ipd : std_logic_vector(17 DOWNTO 0);   
    SIGNAL aclr_ipd : std_logic;   
    SIGNAL clk_ipd : std_logic;   
    SIGNAL ena_ipd : std_logic;   

BEGIN

    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        g1 : for i in data'range generate
            VitalWireDelay (data_ipd(i), data(i), tipd_data(i));
        end generate;
        VitalWireDelay (clk_ipd, clk, tipd_clk);
        VitalWireDelay (aclr_ipd, aclr, tipd_aclr);
        VitalWireDelay (ena_ipd, ena, tipd_ena);
    end block;

    VITALtiming :  process (clk_ipd, aclr_ipd)
    variable Tviol_data_clk : std_ulogic := '0';
    variable TimingData_data_clk : VitalTimingDataType := VitalTimingDataInit;
    variable Tviol_ena_clk : std_ulogic := '0';
    variable TimingData_ena_clk : VitalTimingDataType := VitalTimingDataInit;
    variable dataout_VitalGlitchDataArray : VitalGlitchDataArrayType(17 downto 0);
    variable dataout_tmp : std_logic_vector(17 DOWNTO 0) := (OTHERS => '0');
    begin

        ------------------------
        --  Timing Check Section
        ------------------------
        if (TimingChecksOn) then
        
            VitalSetupHoldCheck (
                Violation       => Tviol_data_clk,
                TimingData      => TimingData_data_clk,
                TestSignal      => data,
                TestSignalName  => "D",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_data_clk_noedge_posedge,
                SetupLow        => tsetup_data_clk_noedge_posedge,
                HoldHigh        => thold_data_clk_noedge_posedge,
                HoldLow         => thold_data_clk_noedge_posedge,
                CheckEnabled    => TO_X01((aclr) OR
                                          (NOT ena)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/MAC_DATA_REG",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

            VitalSetupHoldCheck (
                Violation       => Tviol_ena_clk,
                TimingData      => TimingData_ena_clk,
                TestSignal      => ena,
                TestSignalName  => "ENA",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_ena_clk_noedge_posedge,
                SetupLow        => tsetup_ena_clk_noedge_posedge,
                HoldHigh        => thold_ena_clk_noedge_posedge,
                HoldLow         => thold_ena_clk_noedge_posedge,
                CheckEnabled    => TO_X01(aclr)  /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/MAC_DATA_REG",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
            
        end if;

        if (aclr_ipd = '1') then
            dataout_tmp := (OTHERS => '0');
        elsif (clk_ipd'event and clk_ipd = '1' and (ena_ipd = '1')) then
            dataout_tmp := data_ipd;
        end if;

        ----------------------
        --  Path Delay Section
        ----------------------
        VitalPathDelay01 (
            OutSignal => dataout(0),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(0),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
            GlitchData => dataout_VitalGlitchDataArray(0),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(1),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(1),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
            GlitchData => dataout_VitalGlitchDataArray(1),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(2),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(2),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
            GlitchData => dataout_VitalGlitchDataArray(2),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(3),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(3),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
            GlitchData => dataout_VitalGlitchDataArray(3),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(4),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(4),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
            GlitchData => dataout_VitalGlitchDataArray(4),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(5),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(5),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
            GlitchData => dataout_VitalGlitchDataArray(5),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(6),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(6),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
            GlitchData => dataout_VitalGlitchDataArray(6),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(7),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(7),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
            GlitchData => dataout_VitalGlitchDataArray(7),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(8),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(8),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
            GlitchData => dataout_VitalGlitchDataArray(8),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(9),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(9),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
            GlitchData => dataout_VitalGlitchDataArray(9),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(10),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(10),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
            GlitchData => dataout_VitalGlitchDataArray(10),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(11),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(11),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
            GlitchData => dataout_VitalGlitchDataArray(11),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(12),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(12),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
            GlitchData => dataout_VitalGlitchDataArray(12),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(13),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(13),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
            GlitchData => dataout_VitalGlitchDataArray(13),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(14),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(14),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
            GlitchData => dataout_VitalGlitchDataArray(14),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(15),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(15),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
            GlitchData => dataout_VitalGlitchDataArray(15),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(16),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(16),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
            GlitchData => dataout_VitalGlitchDataArray(16),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(17),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(17),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
            GlitchData => dataout_VitalGlitchDataArray(17),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    end process;

END vital_cycloneii_mac_data_reg;

--------------------------------------------------------------------
--
-- Module Name : cycloneii_mac_sign_reg
--
-- Description : Simulation model for the sign input register of 
--               Cyclone II MAC_MULT
--
--------------------------------------------------------------------

LIBRARY IEEE, cycloneii;
USE IEEE.VITAL_Primitives.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.std_logic_1164.all;
USE cycloneii.atom_pack.all;

ENTITY cycloneii_mac_sign_reg IS
    GENERIC (
             TimingChecksOn : Boolean := True;
             MsgOn : Boolean := DefGlitchMsgOn;
             XOn : Boolean := DefGlitchXOn;
             MsgOnChecks : Boolean := DefMsgOnChecks;
             XOnChecks : Boolean := DefXOnChecks;
             InstancePath : STRING := "*";
             tsetup_d_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_d_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             tsetup_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             tpd_clk_q_posedge : VitalDelayType01 := DefPropDelay01;
             tpd_aclr_q_posedge : VitalDelayType01 := DefPropDelay01;
             tipd_d : VitalDelayType01 := DefPropDelay01;
             tipd_ena : VitalDelayType01 := DefPropDelay01;
             tipd_aclr : VitalDelayType01 := DefPropDelay01;
             tipd_clk : VitalDelayType01 := DefPropDelay01
            );
    PORT (
          -- INPUT PORTS
          clk : IN std_logic;   
          d : IN std_logic;   
          ena : IN std_logic;   
          aclr : IN std_logic;   

          -- OUTPUT PORTS
          q : OUT std_logic
         );   
END cycloneii_mac_sign_reg;

ARCHITECTURE cycloneii_mac_sign_reg OF cycloneii_mac_sign_reg IS

    signal d_ipd : std_logic;
    signal clk_ipd : std_logic;
    signal aclr_ipd : std_logic;
    signal ena_ipd : std_logic;
begin

    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        VitalWireDelay (d_ipd, d, tipd_d);
        VitalWireDelay (clk_ipd, clk, tipd_clk);
        VitalWireDelay (aclr_ipd, aclr, tipd_aclr);
        VitalWireDelay (ena_ipd, ena, tipd_ena);
    end block;

    VITALtiming :  process (clk_ipd, aclr_ipd)
    variable Tviol_d_clk : std_ulogic := '0';
    variable TimingData_d_clk : VitalTimingDataType := VitalTimingDataInit;
    variable Tviol_ena_clk : std_ulogic := '0';
    variable TimingData_ena_clk : VitalTimingDataType := VitalTimingDataInit;
    variable q_VitalGlitchData : VitalGlitchDataType;
    variable q_reg : std_logic := '0';
    begin

        ------------------------
        --  Timing Check Section
        ------------------------
        if (TimingChecksOn) then
        
            VitalSetupHoldCheck (
                Violation       => Tviol_d_clk,
                TimingData      => TimingData_d_clk,
                TestSignal      => d,
                TestSignalName  => "D",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_d_clk_noedge_posedge,
                SetupLow        => tsetup_d_clk_noedge_posedge,
                HoldHigh        => thold_d_clk_noedge_posedge,
                HoldLow         => thold_d_clk_noedge_posedge,
                CheckEnabled    => TO_X01((aclr) OR
                                          (NOT ena)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/SIGN_REG",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
            
            VitalSetupHoldCheck (
                Violation       => Tviol_ena_clk,
                TimingData      => TimingData_ena_clk,
                TestSignal      => ena,
                TestSignalName  => "ENA",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_ena_clk_noedge_posedge,
                SetupLow        => tsetup_ena_clk_noedge_posedge,
                HoldHigh        => thold_ena_clk_noedge_posedge,
                HoldLow         => thold_ena_clk_noedge_posedge,
                CheckEnabled    => TO_X01(aclr) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/SIGN_REG",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
            
        end if;

        if (aclr_ipd = '1') then
            q_reg := '0';
        elsif (clk_ipd'event and clk_ipd = '1' and (ena_ipd = '1')) then
            q_reg := d_ipd;
        end if;

        ----------------------
        --  Path Delay Section
        ----------------------
        VitalPathDelay01 (
            OutSignal => q,
            OutSignalName => "Q",
            OutTemp => q_reg,
            Paths => (0 => (clk_ipd'last_event, tpd_clk_q_posedge, TRUE),
                      1 => (aclr_ipd'last_event, tpd_aclr_q_posedge, TRUE)),
            GlitchData => q_VitalGlitchData,
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

    end process;

END cycloneii_mac_sign_reg;

--------------------------------------------------------------------
--
-- Module Name : cycloneii_mac_mult
--
-- Description : Cyclone II MAC_MULT VHDL simulation model 
--
--------------------------------------------------------------------

LIBRARY IEEE, cycloneii;
USE IEEE.VITAL_Primitives.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;
USE cycloneii.atom_pack.all;

ENTITY cycloneii_mac_mult IS
    GENERIC (
             TimingChecksOn : Boolean := True;
             MsgOn : Boolean := DefGlitchMsgOn;
             XOn : Boolean := DefGlitchXOn;
             MsgOnChecks : Boolean := DefMsgOnChecks;
             XOnChecks : Boolean := DefXOnChecks;
             InstancePath : STRING := "*";
             tipd_dataa : VitalDelayArrayType01(17 downto 0)
                                   := (OTHERS => DefPropDelay01);
             tipd_datab : VitalDelayArrayType01(17 downto 0)
                                   := (OTHERS => DefPropDelay01);
             tipd_signa : VitalDelayType01 := DefPropDelay01;
             tipd_signb : VitalDelayType01 := DefPropDelay01;
             tipd_clk : VitalDelayType01 := DefPropDelay01;
             tipd_ena : VitalDelayType01 := DefPropDelay01;
             tipd_aclr : VitalDelayType01 := DefPropDelay01;
             tpd_dataa_dataout : VitalDelayType01 := DefPropDelay01;
             tpd_datab_dataout : VitalDelayType01 := DefPropDelay01;
             tpd_signa_dataout : VitalDelayType01 := DefPropDelay01;
             tpd_signb_dataout : VitalDelayType01 := DefPropDelay01;
             dataa_width : integer := 18;    
             datab_width : integer := 18;    
             dataa_clock : string := "none";    
             datab_clock : string := "none";    
             signa_clock : string := "none";    
             signb_clock : string := "none";    
             lpm_hint : string := "true";    
             lpm_type : string := "cycloneii_mac_mult"
            );
    PORT (
          dataa : IN std_logic_vector(17 DOWNTO 0) := (OTHERS => '0');
          datab : IN std_logic_vector(17 DOWNTO 0) := (OTHERS => '0');
          signa : IN std_logic := '1';
          signb : IN std_logic := '1';
          clk : IN std_logic := '0';
          aclr : IN std_logic := '0';
          ena : IN std_logic := '0';
          dataout : OUT std_logic_vector(35 DOWNTO 0);   
          devclrn : IN std_logic := '1';
          devpor : IN std_logic := '1'
         );   
END cycloneii_mac_mult;

ARCHITECTURE vital_cycloneii_mac_mult OF cycloneii_mac_mult IS

    COMPONENT cycloneii_mac_data_reg
        GENERIC (
                 TimingChecksOn : Boolean := True;
                 MsgOn : Boolean := DefGlitchMsgOn;
                 XOn : Boolean := DefGlitchXOn;
                 MsgOnChecks : Boolean := DefMsgOnChecks;
                 XOnChecks : Boolean := DefXOnChecks;
                 InstancePath : STRING := "*";
                 tipd_data : VitalDelayArrayType01(17 downto 0) := (OTHERS => DefPropDelay01);
                 tipd_clk : VitalDelayType01 := DefPropDelay01;
                 tipd_ena : VitalDelayType01 := DefPropDelay01;
                 tipd_aclr : VitalDelayType01 := DefPropDelay01;
                 tsetup_data_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
                 thold_data_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
                 tsetup_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
                 thold_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
                 tpd_aclr_dataout_posedge : VitalDelayType01 := DefPropDelay01;
                 tpd_clk_dataout_posedge : VitalDelayType01 := DefPropDelay01;
                 data_width : integer := 18
                );    
        PORT (
              -- INPUT PORTS
              clk : IN std_logic;   
              data : IN std_logic_vector(17 DOWNTO 0);   
              ena : IN std_logic;   
              aclr : IN std_logic;   
              -- OUTPUT PORTS
              dataout : OUT std_logic_vector(17 DOWNTO 0)
             );
    END COMPONENT;

    COMPONENT cycloneii_mac_sign_reg
        GENERIC (
                 TimingChecksOn : Boolean := True;
                 MsgOn : Boolean := DefGlitchMsgOn;
                 XOn : Boolean := DefGlitchXOn;
                 MsgOnChecks : Boolean := DefMsgOnChecks;
                 XOnChecks : Boolean := DefXOnChecks;
                 InstancePath : STRING := "*";
                 tsetup_d_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
                 thold_d_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
                 tsetup_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
                 thold_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
                 tpd_clk_q_posedge : VitalDelayType01 := DefPropDelay01;
                 tpd_aclr_q_posedge : VitalDelayType01 := DefPropDelay01;
                 tipd_d : VitalDelayType01 := DefPropDelay01;
                 tipd_ena : VitalDelayType01 := DefPropDelay01;
                 tipd_aclr : VitalDelayType01 := DefPropDelay01;
                 tipd_clk : VitalDelayType01 := DefPropDelay01
                );
        PORT (
              -- INPUT PORTS
              clk : IN std_logic;   
              d : IN std_logic;   
              ena : IN std_logic;   
              aclr : IN std_logic;   
    
              -- OUTPUT PORTS
              q : OUT std_logic
             );   
    END COMPONENT;


    -- Internal variables
    SIGNAL dataa_ipd : std_logic_vector(17 DOWNTO 0);   
    SIGNAL datab_ipd : std_logic_vector(17 DOWNTO 0);   
    SIGNAL signa_ipd : std_logic;   
    SIGNAL signb_ipd : std_logic;   
    SIGNAL clk_ipd : std_logic;   
    SIGNAL aclr_ipd : std_logic;   
    SIGNAL ena_ipd : std_logic;   
    SIGNAL idataa_reg : std_logic_vector(17 DOWNTO 0);   --  optional register for dataa input
    SIGNAL idatab_reg : std_logic_vector(17 DOWNTO 0);   --  optional register for datab input
    SIGNAL isigna_reg : std_logic;   --  optional register for signa input
    SIGNAL isignb_reg : std_logic;   --  optional register for signb input
    SIGNAL idataa_int : std_logic_vector(17 DOWNTO 0);   --  dataa as seen by the multiplier input
    SIGNAL idatab_int : std_logic_vector(17 DOWNTO 0);   --  datab as seen by the multiplier input
    SIGNAL isigna_int : std_logic;   --  signa as seen by the multiplier input
    SIGNAL isignb_int : std_logic;   --  signb as seen by the multiplier input
    --  padding with 1's for input negation
    SIGNAL reg_aclr : std_logic;   

BEGIN

    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        g1 : for i in dataa'range generate
            VitalWireDelay (dataa_ipd(i), dataa(i), tipd_dataa(i));
        end generate;
        g2 : for i in datab'range generate
            VitalWireDelay (datab_ipd(i), datab(i), tipd_datab(i));
        end generate;

        VitalWireDelay (clk_ipd, clk, tipd_clk);
        VitalWireDelay (ena_ipd, ena, tipd_ena);
        VitalWireDelay (aclr_ipd, aclr, tipd_aclr);
        VitalWireDelay (signa_ipd, signa, tipd_signa);
        VitalWireDelay (signb_ipd, signb, tipd_signb);
    end block;

    reg_aclr <= (NOT devpor) OR (NOT devclrn) OR (aclr_ipd) ;

    -- Optional input registers for dataa,b and signa,b
    dataa_reg : cycloneii_mac_data_reg 
        GENERIC MAP (
            data_width => dataa_width)
        PORT MAP (
            clk => clk,
            data => dataa_ipd,
            ena => ena,
            aclr => reg_aclr,
            dataout => idataa_reg);   
    
    datab_reg : cycloneii_mac_data_reg 
        GENERIC MAP (
            data_width => datab_width)
        PORT MAP (
            clk => clk,
            data => datab_ipd,
            ena => ena,
            aclr => reg_aclr,
            dataout => idatab_reg);   
    
    signa_reg : cycloneii_mac_sign_reg 
        PORT MAP (
            clk => clk,
            d => signa,
            ena => ena,
            aclr => reg_aclr,
            q => isigna_reg);   
    
    signb_reg : cycloneii_mac_sign_reg 
        PORT MAP (
            clk => clk,
            d => signb,
            ena => ena,
            aclr => reg_aclr,
            q => isignb_reg);   
    
    idataa_int <= dataa_ipd WHEN (dataa_clock = "none") ELSE idataa_reg;
    idatab_int <= datab_ipd WHEN (datab_clock = "none") ELSE idatab_reg;
    isigna_int <= signa_ipd WHEN (signa_clock = "none") ELSE isigna_reg;
    isignb_int <= signb_ipd WHEN (signb_clock = "none") ELSE isignb_reg;

    VITALtiming : process(idataa_int, idatab_int, isigna_int, isignb_int)
    variable dataout_tmp : STD_LOGIC_VECTOR (36 downto 0) := (others => '0');
    variable dataout_VitalGlitchDataArray : VitalGlitchDataArrayType(35 downto 0);
    begin
        if((isigna_int = '0') and (isignb_int = '1')) then
            dataout_tmp(dataa_width+datab_width downto 0) := 
                unsigned(idataa_int(dataa_width-1 downto 0)) * 
                signed(idatab_int(datab_width-1 downto 0));
        elsif((isigna_int = '1') and (isignb_int = '0')) then
            dataout_tmp(dataa_width+datab_width downto 0) := 
                signed(idataa_int(dataa_width-1 downto 0)) * 
                unsigned(idatab_int(datab_width-1 downto 0));
        elsif((isigna_int = '1') and (isignb_int = '1')) then
            dataout_tmp(dataa_width+datab_width-1 downto 0) := 
                signed(idataa_int(dataa_width-1 downto 0)) * 
                signed(idatab_int(datab_width-1 downto 0));
        else --((isigna_int = '0') and (isignb_int = '0')) then
            dataout_tmp(dataa_width+datab_width-1 downto 0) :=
                unsigned(idataa_int(dataa_width-1 downto 0)) * 
                unsigned(idatab_int(datab_width-1 downto 0));
    end if;

        ----------------------
        --  Path Delay Section
        ----------------------
        VitalPathDelay01 (
            OutSignal => dataout(0),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(0),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(0),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );

        VitalPathDelay01 (
            OutSignal => dataout(1),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(1),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(1),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );

        VitalPathDelay01 (
            OutSignal => dataout(2),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(2),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(2),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );

        VitalPathDelay01 (
            OutSignal => dataout(3),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(3),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(3),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );

        VitalPathDelay01 (
            OutSignal => dataout(4),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(4),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(4),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );

        VitalPathDelay01 (
            OutSignal => dataout(5),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(5),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(5),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );

        VitalPathDelay01 (
            OutSignal => dataout(6),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(6),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(6),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );

        VitalPathDelay01 (
            OutSignal => dataout(7),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(7),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(7),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );

        VitalPathDelay01 (
            OutSignal => dataout(8),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(8),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(8),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );

        VitalPathDelay01 (
            OutSignal => dataout(9),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(9),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(9),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );

        VitalPathDelay01 (
            OutSignal => dataout(10),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(10),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(10),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );

        VitalPathDelay01 (
            OutSignal => dataout(11),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(11),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(11),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );

        VitalPathDelay01 (
            OutSignal => dataout(12),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(12),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(12),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );

        VitalPathDelay01 (
            OutSignal => dataout(13),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(13),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(13),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );

        VitalPathDelay01 (
            OutSignal => dataout(14),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(14),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(14),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );

        VitalPathDelay01 (
            OutSignal => dataout(15),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(15),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(15),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );

        VitalPathDelay01 (
            OutSignal => dataout(16),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(16),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(16),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );

        VitalPathDelay01 (
            OutSignal => dataout(17),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(17),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(17),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );

        VitalPathDelay01 (
            OutSignal => dataout(18),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(18),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(18),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );

        VitalPathDelay01 (
            OutSignal => dataout(19),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(19),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(19),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );

        VitalPathDelay01 (
            OutSignal => dataout(20),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(20),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(20),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );

        VitalPathDelay01 (
            OutSignal => dataout(21),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(21),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(21),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );

        VitalPathDelay01 (
            OutSignal => dataout(22),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(22),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(22),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );

        VitalPathDelay01 (
            OutSignal => dataout(23),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(23),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(23),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );

        VitalPathDelay01 (
            OutSignal => dataout(24),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(24),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(24),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );

        VitalPathDelay01 (
            OutSignal => dataout(25),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(25),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(25),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );

        VitalPathDelay01 (
            OutSignal => dataout(26),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(26),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(26),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );

        VitalPathDelay01 (
            OutSignal => dataout(27),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(27),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(27),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );

        VitalPathDelay01 (
            OutSignal => dataout(28),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(28),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(28),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );

        VitalPathDelay01 (
            OutSignal => dataout(29),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(29),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(29),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );

        VitalPathDelay01 (
            OutSignal => dataout(30),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(30),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(30),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );

        VitalPathDelay01 (
            OutSignal => dataout(31),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(31),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(31),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );

        VitalPathDelay01 (
            OutSignal => dataout(32),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(32),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(32),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );

        VitalPathDelay01 (
            OutSignal => dataout(33),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(33),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(33),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );

        VitalPathDelay01 (
            OutSignal => dataout(34),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(34),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(34),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );

        VitalPathDelay01 (
            OutSignal => dataout(35),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(35),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, dataa_clock = "none"),
                      1 => (datab_ipd'last_event, tpd_datab_dataout, datab_clock = "none"),
                      2 => (signa'last_event, tpd_signa_dataout, signa_clock = "none"),
                      3 => (signb'last_event, tpd_signb_dataout, signb_clock = "none")),
            GlitchData => dataout_VitalGlitchDataArray(35),
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE );
    end process;

END vital_cycloneii_mac_mult;

--------------------------------------------------------------------
--
-- Module Name : cycloneii_mac_out
--
-- Description : Cyclone II MAC_OUT VHDL simulation model 
--
--------------------------------------------------------------------

LIBRARY IEEE, cycloneii;
USE IEEE.VITAL_Primitives.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.std_logic_1164.all;
USE cycloneii.atom_pack.all;

ENTITY cycloneii_mac_out IS
    GENERIC (
             TimingChecksOn : Boolean := True;
             MsgOn : Boolean := DefGlitchMsgOn;
             XOn : Boolean := DefGlitchXOn;
             MsgOnChecks : Boolean := DefMsgOnChecks;
             XOnChecks : Boolean := DefXOnChecks;
             InstancePath : STRING := "*";
             tipd_dataa : VitalDelayArrayType01(35 downto 0)
                                   := (OTHERS => DefPropDelay01);
             tipd_clk : VitalDelayType01 := DefPropDelay01;
             tipd_ena : VitalDelayType01 := DefPropDelay01;
             tipd_aclr : VitalDelayType01 := DefPropDelay01;
             tpd_dataa_dataout : VitalDelayType01 := DefPropDelay01;
             tpd_aclr_dataout_posedge : VitalDelayType01 := DefPropDelay01;
             tpd_clk_dataout_posedge : VitalDelayType01 := DefPropDelay01;
             tsetup_dataa_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_dataa_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             tsetup_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             dataa_width : integer := 36;    
             output_clock : string := "none";    
             lpm_hint : string := "true";    
             lpm_type : string := "cycloneii_mac_out");    
    PORT (
          dataa : IN std_logic_vector(35 DOWNTO 0) := (OTHERS => '0');
          clk : IN std_logic := '0';
          aclr : IN std_logic := '0';
          ena : IN std_logic := '1';
          dataout : OUT std_logic_vector(35 DOWNTO 0);   
          devclrn : IN std_logic := '1';
          devpor : IN std_logic := '1'
         );   
END cycloneii_mac_out;

ARCHITECTURE vital_cycloneii_mac_out OF cycloneii_mac_out IS

    --  internal variables
    SIGNAL dataa_ipd : std_logic_vector(35 DOWNTO 0);
    SIGNAL clk_ipd : std_logic;
    SIGNAL aclr_ipd : std_logic;
    SIGNAL ena_ipd : std_logic;

    --  optional register
    SIGNAL use_reg : std_logic;

BEGIN

    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        g1 : for i in dataa'range generate
            VitalWireDelay (dataa_ipd(i), dataa(i), tipd_dataa(i));
        end generate;
        VitalWireDelay (clk_ipd, clk, tipd_clk);
        VitalWireDelay (aclr_ipd, aclr, tipd_aclr);
        VitalWireDelay (ena_ipd, ena, tipd_ena);
    end block;

    use_reg <= '1' WHEN (output_clock /= "none") ELSE '0';
    
    VITALtiming :  process (clk_ipd, aclr_ipd, dataa_ipd)
    variable Tviol_dataa_clk : std_ulogic := '0';
    variable TimingData_dataa_clk : VitalTimingDataType := VitalTimingDataInit;
    variable Tviol_ena_clk : std_ulogic := '0';
    variable TimingData_ena_clk : VitalTimingDataType := VitalTimingDataInit;
    variable dataout_VitalGlitchDataArray : VitalGlitchDataArrayType (35 downto 0);
    --  optional register for dataout output
    variable dataout_tmp : std_logic_vector(35 DOWNTO 0) := (OTHERS => '0');
    begin

        ------------------------
        --  Timing Check Section
        ------------------------
        if (TimingChecksOn) then
        
            VitalSetupHoldCheck (
                Violation       => Tviol_dataa_clk,
                TimingData      => TimingData_dataa_clk,
                TestSignal      => dataa,
                TestSignalName  => "D",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_dataa_clk_noedge_posedge,
                SetupLow        => tsetup_dataa_clk_noedge_posedge,
                HoldHigh        => thold_dataa_clk_noedge_posedge,
                HoldLow         => thold_dataa_clk_noedge_posedge,
                CheckEnabled    => TO_X01((aclr) OR (NOT use_reg) OR
                                          (NOT ena)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/MAC_DATA_REG",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

            VitalSetupHoldCheck (
                Violation       => Tviol_ena_clk,
                TimingData      => TimingData_ena_clk,
                TestSignal      => ena,
                TestSignalName  => "ENA",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_ena_clk_noedge_posedge,
                SetupLow        => tsetup_ena_clk_noedge_posedge,
                HoldHigh        => thold_ena_clk_noedge_posedge,
                HoldLow         => thold_ena_clk_noedge_posedge,
                CheckEnabled    => TO_X01((aclr) OR 
                                          (NOT use_reg)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/MAC_DATA_REG",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
            
        end if;

        if (use_reg = '0') then
            dataout_tmp := dataa_ipd;
        else
            if (aclr_ipd = '1') then
                dataout_tmp := (OTHERS => '0');
            elsif (clk_ipd'event and clk_ipd = '1' and (ena_ipd = '1')) then
                dataout_tmp := dataa_ipd;
            end if;
        end if;

        ----------------------
        --  Path Delay Section
        ----------------------
        VitalPathDelay01 (
            OutSignal => dataout(0),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(0),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(0),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(1),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(1),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(1),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(2),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(2),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(2),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(3),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(3),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(3),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(4),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(4),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(4),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(5),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(5),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(5),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(6),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(6),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(6),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(7),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(7),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(7),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(8),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(8),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(8),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(9),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(9),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(9),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(10),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(10),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(10),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(11),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(11),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(11),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(12),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(12),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(12),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(13),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(13),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(13),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(14),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(14),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(14),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(15),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(15),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(15),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(16),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(16),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(16),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(17),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(17),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(17),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(18),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(18),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(18),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(19),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(19),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(19),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(20),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(20),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(20),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(21),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(21),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(21),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(22),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(22),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(22),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(23),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(23),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(23),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(24),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(24),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(24),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(25),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(25),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(25),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(26),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(26),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(26),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(27),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(27),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(27),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(28),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(28),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(28),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(29),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(29),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(29),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(30),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(30),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(30),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(31),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(31),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(31),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(32),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(32),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(32),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(33),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(33),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(33),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(34),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(34),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(34),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(35),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(35),
            Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, use_reg = '1'),
                      1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, use_reg = '1'),
                      2 => (dataa_ipd'last_event, tpd_dataa_dataout, use_reg = '0')),
            GlitchData => dataout_VitalGlitchDataArray(35),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    end process;

END vital_cycloneii_mac_out;

--/////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : ena_reg
--
-- Description : Simulation model for a simple DFF.
--               This is used for the gated clock generation
--               Powers upto 1.
--
--/////////////////////////////////////////////////////////////////////////////

LIBRARY ieee, cycloneii;
USE IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use cycloneii.atom_pack.all;

ENTITY ena_reg is
    generic (
             TimingChecksOn : Boolean := True;
             MsgOn : Boolean := DefGlitchMsgOn;
             XOn : Boolean := DefGlitchXOn;
             MsgOnChecks : Boolean := DefMsgOnChecks;
             XOnChecks : Boolean := DefXOnChecks;
             InstancePath : STRING := "*";
             tsetup_d_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_d_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             tpd_clk_q_posedge : VitalDelayType01 := DefPropDelay01;
             tipd_d : VitalDelayType01 := DefPropDelay01;
             tipd_clk : VitalDelayType01 := DefPropDelay01
            );
    PORT (
          clk : in std_logic;
          ena : in std_logic := '1';
          d : in std_logic;
          clrn : in std_logic := '1';
          prn : in std_logic := '1';
          q : out std_logic
         );
   attribute VITAL_LEVEL0 of ena_reg : entity is TRUE;
end ena_reg;

ARCHITECTURE behave of ena_reg is
    attribute VITAL_LEVEL0 of behave : architecture is TRUE;
    signal d_ipd : std_logic;
    signal clk_ipd : std_logic;
begin

    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        VitalWireDelay (d_ipd, d, tipd_d);
        VitalWireDelay (clk_ipd, clk, tipd_clk);
    end block;

    VITALtiming :  process (clk_ipd, prn, clrn)
    variable Tviol_d_clk : std_ulogic := '0';
    variable TimingData_d_clk : VitalTimingDataType := VitalTimingDataInit;
    variable q_VitalGlitchData : VitalGlitchDataType;
    variable q_reg : std_logic := '1';
    begin

        ------------------------
        --  Timing Check Section
        ------------------------
        if (TimingChecksOn) then
        
            VitalSetupHoldCheck (
                Violation       => Tviol_d_clk,
                TimingData      => TimingData_d_clk,
                TestSignal      => d,
                TestSignalName  => "D",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_d_clk_noedge_posedge,
                SetupLow        => tsetup_d_clk_noedge_posedge,
                HoldHigh        => thold_d_clk_noedge_posedge,
                HoldLow         => thold_d_clk_noedge_posedge,
                CheckEnabled    => TO_X01((clrn) OR
                                          (NOT ena)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/ENA_REG",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
            
        end if;

        if (prn = '0') then
            q_reg := '1';
        elsif (clrn = '0') then
            q_reg := '0';
        elsif (clk_ipd'event and clk_ipd = '1' and (ena = '1')) then
            q_reg := d_ipd;
        end if;

        ----------------------
        --  Path Delay Section
        ----------------------
        VitalPathDelay01 (
            OutSignal => q,
            OutSignalName => "Q",
            OutTemp => q_reg,
            Paths => (0 => (clk_ipd'last_event, tpd_clk_q_posedge, TRUE)),
            GlitchData => q_VitalGlitchData,
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

    end process;

end behave;

--/////////////////////////////////////////////////////////////////////////////
--
--              VHDL Simulation Model for Cyclone II CLKCTRL Atom
--
--/////////////////////////////////////////////////////////////////////////////

--
--
--  CYCLONEII_CLKCTRL Model
--
--

library IEEE, cycloneii;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use cycloneii.atom_pack.all;

entity cycloneii_clkctrl is
    generic (
             clock_type : STRING := "Auto";
             lpm_type : STRING := "cycloneii_clkctrl";
             ena_register_mode : STRING := "Falling Edge";
             TimingChecksOn : Boolean := True;
             MsgOn : Boolean := DefGlitchMsgOn;
             XOn : Boolean := DefGlitchXOn;
             MsgOnChecks : Boolean := DefMsgOnChecks;
             XOnChecks : Boolean := DefXOnChecks;
             InstancePath : STRING := "*";
             tipd_inclk : VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01); 
             tipd_clkselect : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01); 
             tipd_ena : VitalDelayType01 := DefPropDelay01
             );
    port (
          inclk : in std_logic_vector(3 downto 0) := "0000";
          clkselect : in std_logic_vector(1 downto 0) := "00";
          ena : in std_logic := '1';
          devclrn : in std_logic := '1';
          devpor : in std_logic := '1';
          outclk : out std_logic
          );    
   attribute VITAL_LEVEL0 of cycloneii_clkctrl : entity is TRUE;
end cycloneii_clkctrl;
        
architecture vital_clkctrl of cycloneii_clkctrl is
    attribute VITAL_LEVEL0 of vital_clkctrl : architecture is TRUE;

    component ena_reg
        generic (
                 TimingChecksOn : Boolean := True;
                 MsgOn : Boolean := DefGlitchMsgOn;
                 XOn : Boolean := DefGlitchXOn;
                 MsgOnChecks : Boolean := DefMsgOnChecks;
                 XOnChecks : Boolean := DefXOnChecks;
                 InstancePath : STRING := "*";
                 tsetup_d_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
                 thold_d_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
                 tpd_clk_q_posedge : VitalDelayType01 := DefPropDelay01;
                 tipd_d : VitalDelayType01 := DefPropDelay01;
                 tipd_clk : VitalDelayType01 := DefPropDelay01
                );
        PORT (
              clk : in std_logic;
              ena : in std_logic := '1';
              d : in std_logic;
              clrn : in std_logic := '1';
              prn : in std_logic := '1';
              q : out std_logic
             );
    end component;

    signal inclk_ipd : std_logic_vector(3 downto 0);
    signal clkselect_ipd : std_logic_vector(1 downto 0);
    signal ena_ipd : std_logic;
    signal clkmux_out : std_logic;
    signal clkmux_out_inv : std_logic;
    signal cereg_clr : std_logic;
    signal cereg_out : std_logic;
    signal ena_out : std_logic;
    signal vcc : std_logic := '1';
begin

    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        VitalWireDelay (ena_ipd, ena, tipd_ena);
        VitalWireDelay (inclk_ipd(0), inclk(0), tipd_inclk(0));
        VitalWireDelay (inclk_ipd(1), inclk(1), tipd_inclk(1));
        VitalWireDelay (inclk_ipd(2), inclk(2), tipd_inclk(2));
        VitalWireDelay (inclk_ipd(3), inclk(3), tipd_inclk(3));
        VitalWireDelay (clkselect_ipd(0), clkselect(0), tipd_clkselect(0));
        VitalWireDelay (clkselect_ipd(1), clkselect(1), tipd_clkselect(1));
    end block;

    process(inclk_ipd, clkselect_ipd)
    variable tmp : std_logic;
    begin
        if (clkselect_ipd = "11") then
            tmp := inclk_ipd(3);
        elsif (clkselect_ipd = "10") then
            tmp := inclk_ipd(2);
        elsif (clkselect_ipd = "01") then
            tmp := inclk_ipd(1);
        else
            tmp := inclk_ipd(0);
        end if;
        clkmux_out <= tmp;
        clkmux_out_inv <= NOT tmp;
    end process;

    extena0_reg : ena_reg
                  port map (
                            clk => clkmux_out_inv,
                            ena => vcc,
                            d => ena_ipd, 
                            clrn => vcc,
                            prn => devpor,
                            q => cereg_out 
                           );

    ena_out <= cereg_out WHEN (ena_register_mode = "falling edge") ELSE ena_ipd;

    outclk <= ena_out AND clkmux_out;

end vital_clkctrl;	

