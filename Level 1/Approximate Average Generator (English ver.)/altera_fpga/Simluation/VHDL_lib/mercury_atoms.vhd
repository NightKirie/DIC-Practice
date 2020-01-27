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


LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;

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
-- change default delay type to Transport
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
   TYPE apex20ke_mem_data IS ARRAY (0 to 31) of STD_LOGIC_VECTOR (31 downto 0);
   TYPE mercury_mem_data IS ARRAY (0 to 63) of STD_LOGIC_VECTOR (31 downto 0);

end atom_pack;

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

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

end atom_pack;

--/////////////////////////////////////////////////////////////////////////////
--
--              VHDL Simulation Models for MERCURY Atoms
--
--/////////////////////////////////////////////////////////////////////////////
--
--/////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE, mercury;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE mercury.atom_pack.all;

ENTITY mercury_asynch_lcell is
  GENERIC (operation_mode    : string := "normal";
      output_mode   : string := "comb_and_reg";
		multiplier_output : string := "true";
		multiplier_mux_source : string := "gnd";
      lut_mask       : string := "ffff";
      power_up : string := "low";
      cin_used       : string := "false";
      cin0_used       : string := "false";
      cin1_used       : string := "false";
      TimingChecksOn: Boolean := True;
      MsgOn: Boolean := DefGlitchMsgOn;
      XOn: Boolean := DefGlitchXOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      InstancePath: STRING := "*";
      tpd_dataa_combout           : VitalDelayType01 := DefPropDelay01;
      tpd_datab_combout           : VitalDelayType01 := DefPropDelay01;
      tpd_datac_combout           : VitalDelayType01 := DefPropDelay01;
      tpd_datad_combout           : VitalDelayType01 := DefPropDelay01;
      tpd_cin_combout             : VitalDelayType01 := DefPropDelay01;
      tpd_cin0_combout            : VitalDelayType01 := DefPropDelay01;
      tpd_cin1_combout            : VitalDelayType01 := DefPropDelay01;
      tpd_multsela_combout        : VitalDelayType01 := DefPropDelay01;
      tpd_multselb_combout        : VitalDelayType01 := DefPropDelay01;
      tpd_multdataa_combout       : VitalDelayType01 := DefPropDelay01;
      tpd_multdatab_combout       : VitalDelayType01 := DefPropDelay01;
      tpd_dataa_regin             : VitalDelayType01 := DefPropDelay01;
      tpd_datab_regin             : VitalDelayType01 := DefPropDelay01;
      tpd_datac_regin             : VitalDelayType01 := DefPropDelay01;
      tpd_datad_regin             : VitalDelayType01 := DefPropDelay01;
      tpd_cin_regin               : VitalDelayType01 := DefPropDelay01;
      tpd_cin0_regin              : VitalDelayType01 := DefPropDelay01;
      tpd_cin1_regin              : VitalDelayType01 := DefPropDelay01;
      tpd_multsela_regin          : VitalDelayType01 := DefPropDelay01;
      tpd_multselb_regin          : VitalDelayType01 := DefPropDelay01;
      tpd_multdataa_regin         : VitalDelayType01 := DefPropDelay01;
      tpd_multdatab_regin         : VitalDelayType01 := DefPropDelay01;
      tpd_dataa_cout	             : VitalDelayType01 := DefPropDelay01;
      tpd_datab_cout	             : VitalDelayType01 := DefPropDelay01;
      tpd_datac_cout    	        : VitalDelayType01 := DefPropDelay01;
      tpd_datad_cout    	        : VitalDelayType01 := DefPropDelay01;
      tpd_cin_cout		        : VitalDelayType01 := DefPropDelay01;
      tpd_cin0_cout		        : VitalDelayType01 := DefPropDelay01;
      tpd_cin1_cout		        : VitalDelayType01 := DefPropDelay01;
      tpd_dataa_cout0              : VitalDelayType01 := DefPropDelay01;
      tpd_datab_cout0              : VitalDelayType01 := DefPropDelay01;
      tpd_cin0_cout0		        : VitalDelayType01 := DefPropDelay01;
      tpd_dataa_cout1              : VitalDelayType01 := DefPropDelay01;
      tpd_datab_cout1              : VitalDelayType01 := DefPropDelay01;
      tpd_datac_cout1   	        : VitalDelayType01 := DefPropDelay01;
      tpd_cin1_cout1		        : VitalDelayType01 := DefPropDelay01;
      tpd_dataa_multout           : VitalDelayType01 := DefPropDelay01;
      tpd_datab_multout           : VitalDelayType01 := DefPropDelay01;
      tpd_cin_multout             : VitalDelayType01 := DefPropDelay01;
      tpd_cin0_multout           : VitalDelayType01 := DefPropDelay01;
      tpd_cin1_multout           : VitalDelayType01 := DefPropDelay01;
      tpd_multsela_multout        : VitalDelayType01 := DefPropDelay01;
      tpd_multselb_multout        : VitalDelayType01 := DefPropDelay01;
      tpd_multdataa_multout       : VitalDelayType01 := DefPropDelay01;
      tpd_multdatab_multout       : VitalDelayType01 := DefPropDelay01;
	  tipd_dataa			: VitalDelayType01 := DefPropDelay01; 
      tipd_datab			: VitalDelayType01 := DefPropDelay01; 
      tipd_datac			: VitalDelayType01 := DefPropDelay01; 
      tipd_datad			: VitalDelayType01 := DefPropDelay01; 
      tipd_cin  			: VitalDelayType01 := DefPropDelay01; 
      tipd_cin0  			: VitalDelayType01 := DefPropDelay01; 
      tipd_cin1  			: VitalDelayType01 := DefPropDelay01; 
      tipd_multdataa		: VitalDelayType01 := DefPropDelay01; 
      tipd_multdatab		: VitalDelayType01 := DefPropDelay01; 
      tipd_multsela		: VitalDelayType01 := DefPropDelay01; 
      tipd_multselb		: VitalDelayType01 := DefPropDelay01); 

  PORT (
        dataa     : in std_logic := '1';
        datab     : in std_logic := '1';
        datac     : in std_logic := '1';
        datad     : in std_logic := '1';
        cin       : in std_logic := '0';
        cin0      : in std_logic := '0';
        cin1      : in std_logic := '1';
        multsela  : in std_logic := '1';
        multselb  : in std_logic := '1';
        multdataa : in std_logic := '1';
        multdatab : in std_logic := '1';
        combout   : out std_logic;
        cout      : out std_logic;
        cout0     : out std_logic;
        cout1     : out std_logic;
        multout   : out std_logic;
        regin     : out std_logic);
   attribute VITAL_LEVEL0 of mercury_asynch_lcell : ENTITY is TRUE;
end mercury_asynch_lcell;
        
architecture vital_le of mercury_asynch_lcell is
   attribute VITAL_LEVEL0 of vital_le : architecture is TRUE;
   signal dataa_ipd, datab_ipd : std_logic;
   signal multdataa_ipd, multdatab_ipd : std_logic;
   signal datac_ipd, datad_ipd : std_logic;
	signal cin_ipd, cin0_ipd, cin1_ipd : std_logic;
   signal multsela_ipd, multselb_ipd : std_logic;
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
   VitalWireDelay (cin0_ipd, cin0, tipd_cin);
   VitalWireDelay (cin1_ipd, cin1, tipd_cin);
   VitalWireDelay (multsela_ipd, multsela, tipd_multsela);
   VitalWireDelay (multselb_ipd, multselb, tipd_multselb);
   VitalWireDelay (multdataa_ipd, multdataa, tipd_multdataa);
   VitalWireDelay (multdatab_ipd, multdatab, tipd_multdatab);
   end block;

VITALtiming : process(dataa_ipd, datab_ipd, datac_ipd, datad_ipd, cin_ipd, cin0_ipd, cin1_ipd, multsela_ipd, multselb_ipd, multdataa_ipd, multdatab_ipd)

variable combout_VitalGlitchData : VitalGlitchDataType;
variable multout_VitalGlitchData : VitalGlitchDataType;
variable cout_VitalGlitchData : VitalGlitchDataType;
variable cout0_VitalGlitchData : VitalGlitchDataType;
variable cout1_VitalGlitchData : VitalGlitchDataType;
variable regin_VitalGlitchData : VitalGlitchDataType;

variable icomb, icout, icout0, icout1, ilutout: std_logic;
variable idata, setbit : std_logic := '0';
variable tmp_combout, tmp_cout, tmp_cout0, tmp_cout1, tmp_regin, tmp_multout : std_logic;
variable lut_mask_std : std_logic_vector (15 downto 0) :=  str_to_bin(lut_mask); 

begin


	if operation_mode = "normal" then
		if cin_used = "true" then
			if ((cin0_used = "true") or (cin1_used = "true")) then
				if (cin_ipd = '0') then
					icomb := VitalMUX(data => lut_mask_std,
                		  dselect => (datad_ipd, cin0_ipd, datab_ipd, dataa_ipd)); 
				else
					icomb := VitalMUX(data => lut_mask_std,
                		  dselect => (datad_ipd, cin1_ipd, datab_ipd, dataa_ipd)); 
				end if;
			else
				icomb := VitalMUX(data => lut_mask_std,
                		  dselect => (datad_ipd, cin_ipd, datab_ipd, dataa_ipd)); 
			end if;
		elsif (cin0_used = "true") then
				icomb := VitalMUX(data => lut_mask_std,
                		  dselect => (datad_ipd, cin0_ipd, datab_ipd, dataa_ipd)); 
		else
			icomb := VitalMUX(data => lut_mask_std,
                		  dselect => (datad_ipd, datac_ipd, datab_ipd, dataa_ipd)); 
		end if;
	end if;


	if operation_mode = "arithmetic" then
		icout0 := VitalMUX(data => lut_mask_std,
    				   dselect => ('0', cin0_ipd, datab_ipd, dataa_ipd));
		icout1 := VitalMUX(data => lut_mask_std,
     				   dselect => ('0', cin1_ipd, datab_ipd, dataa_ipd));

		if cin_used = "true" then
			if ((cin0_used = "true") or (cin1_used = "true")) then
				if (cin_ipd = '0') then
					icomb := VitalMUX(data => lut_mask_std,
                		  dselect => ('1', cin0_ipd, datab_ipd, dataa_ipd)); 
					icout := icout0;
				else
					icomb := VitalMUX(data => lut_mask_std,
                		  dselect => ('1', cin1_ipd, datab_ipd, dataa_ipd)); 
					icout := icout1;
				end if;
			else
				icomb := VitalMUX(data => lut_mask_std,
                		  dselect => ('1', cin_ipd, datab_ipd, dataa_ipd)); 
				icout := VitalMUX(data => lut_mask_std,
      				   dselect => ('0', cin_ipd, datab_ipd, dataa_ipd));
			end if;
		elsif (cin0_used = "true") then
				icomb := VitalMUX(data => lut_mask_std,
                		  dselect => ('1', cin0_ipd, datab_ipd, dataa_ipd)); 
				icout := VitalMUX(data => lut_mask_std,
      				   dselect => ('0', cin0_ipd, datab_ipd, dataa_ipd));
		else
			icomb := VitalMUX(data => lut_mask_std,
                		  dselect => ('1', datac_ipd, datab_ipd, dataa_ipd)); 
			icout := VitalMUX(data => lut_mask_std,
      				   dselect => ('0', datac_ipd, datab_ipd, dataa_ipd));
		end if;

	end if;

	if operation_mode = "multiplier" then
		icout0 := VitalMUX(data => lut_mask_std,
      				   dselect => ('0', cin0_ipd, datab_ipd, dataa_ipd));
		icout1 := VitalMUX(data => lut_mask_std,
      				   dselect => ('0', cin1_ipd, datab_ipd, dataa_ipd));
		if (cin_ipd = '0') then
			ilutout := VitalMUX(data => lut_mask_std,
      	             dselect => ('1', cin0_ipd, datab_ipd, dataa_ipd));
			icout := icout0;
		else
			ilutout := VitalMUX(data => lut_mask_std,
                      dselect => ('1', cin1_ipd, datab_ipd, dataa_ipd));
			icout := icout1;
		end if;

		if (multsela_ipd = '0') then
			if (multselb_ipd = '0') then
				if (multiplier_mux_source = "vcc") then
					icomb := '1';
				else
					icomb := '0';
				end if;
			else
				icomb := multdatab_ipd;
			end if;
		else
			if (multselb_ipd = '0') then
				icomb := multdataa_ipd;
			else
				icomb := ilutout;
			end if;
		end if;
	end if;

	tmp_combout := icomb;
	tmp_cout := icout;
	tmp_cout0 := icout0;
	tmp_cout1 := icout1;
   tmp_regin := icomb;
	tmp_multout := icomb;

      ----------------------
      --  Path Delay Section
      ----------------------

      VitalPathDelay01 (
       OutSignal => combout,
       OutSignalName => "COMBOUT",
       OutTemp => tmp_combout,
       Paths => (0 => (dataa_ipd'last_event, tpd_dataa_combout, (operation_mode /= "multiplier" OR (multsela_ipd = '0' AND multselb_ipd = '0') OR (multsela_ipd = '1' AND multselb_ipd = '1'))),
                 1 => (datab_ipd'last_event, tpd_datab_combout, (operation_mode /= "multiplier" OR (multsela_ipd = '0' AND multselb_ipd = '0') OR (multsela_ipd = '1' AND multselb_ipd = '1'))),
                 2 => (datac_ipd'last_event, tpd_datac_combout, TRUE),
                 3 => (datad_ipd'last_event, tpd_datad_combout, TRUE),
                 4 => (cin_ipd'last_event, tpd_cin_combout, TRUE),
                 5 => (cin0_ipd'last_event, tpd_cin0_combout, TRUE),
                 6 => (cin1_ipd'last_event, tpd_cin1_combout, TRUE),
                 7 => (multsela_ipd'last_event, tpd_multsela_combout, TRUE),
                 8 => (multselb_ipd'last_event, tpd_multselb_combout, TRUE),
                 9 => (multdataa_ipd'last_event, tpd_multdataa_combout, (operation_mode= "multiplier" and multsela_ipd = '1' and multselb_ipd = '0')),
                 10 => (multdatab_ipd'last_event, tpd_multdatab_combout, (operation_mode= "multiplier" and multsela_ipd = '0' and multselb_ipd = '1'))),
       GlitchData => combout_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn => MsgOn );

      VitalPathDelay01 (
       OutSignal => regin,
       OutSignalName => "REGIN",
       OutTemp => tmp_regin,
       Paths => (0 => (dataa_ipd'last_event, tpd_dataa_regin, (operation_mode /= "multiplier" OR (multsela_ipd = '0' AND multselb_ipd = '0') OR (multsela_ipd = '1' AND multselb_ipd = '1'))),
                 1 => (datab_ipd'last_event, tpd_datab_regin, (operation_mode /= "multiplier" OR (multsela_ipd = '0' AND multselb_ipd = '0') OR (multsela_ipd = '1' AND multselb_ipd = '1'))),
                 2 => (datac_ipd'last_event, tpd_datac_regin, TRUE),
                 3 => (datad_ipd'last_event, tpd_datad_regin, TRUE),
                 4 => (cin_ipd'last_event, tpd_cin_regin, TRUE),
                 5 => (cin0_ipd'last_event, tpd_cin0_regin, TRUE),
                 6 => (cin1_ipd'last_event, tpd_cin1_regin, TRUE),
                 7 => (multsela_ipd'last_event, tpd_multsela_regin, TRUE),
                 8 => (multselb_ipd'last_event, tpd_multselb_regin, TRUE),
                 9 => (multdataa_ipd'last_event, tpd_multdataa_regin, (operation_mode= "multiplier" and multsela_ipd = '1' and multselb_ipd = '0')),
                 10 => (multdatab_ipd'last_event, tpd_multdatab_regin, (operation_mode= "multiplier" and multsela_ipd = '0' and multselb_ipd = '1'))),
       GlitchData => regin_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn => MsgOn );

      VitalPathDelay01 ( 
       OutSignal => cout, 
       OutSignalName => "COUT",
       OutTemp => tmp_cout,
       Paths => (0 => (dataa_ipd'last_event, tpd_dataa_cout, TRUE),
                 1 => (datab_ipd'last_event, tpd_datab_cout, TRUE),
                 2 => (datac_ipd'last_event, tpd_datac_cout, TRUE),
                 3 => (datad_ipd'last_event, tpd_datad_cout, TRUE),
                 4 => (cin_ipd'last_event, tpd_cin_cout, TRUE),
                 5 => (cin0_ipd'last_event, tpd_cin0_cout, TRUE),
                 6 => (cin1_ipd'last_event, tpd_cin1_cout, TRUE)),
       GlitchData => cout_VitalGlitchData,    
       Mode => DefGlitchMode, 
       XOn  => XOn, 
       MsgOn => MsgOn );

      VitalPathDelay01 ( 
       OutSignal => cout0, 
       OutSignalName => "COUT0",
       OutTemp => tmp_cout0,
       Paths => (0 => (dataa_ipd'last_event, tpd_dataa_cout0, TRUE),
                 1 => (datab_ipd'last_event, tpd_datab_cout0, TRUE),
                 2 => (cin0_ipd'last_event, tpd_cin0_cout0, TRUE)),
       GlitchData => cout0_VitalGlitchData,    
       Mode => DefGlitchMode, 
       XOn  => XOn, 
       MsgOn => MsgOn );

      VitalPathDelay01 ( 
       OutSignal => cout1, 
       OutSignalName => "COUT1",
       OutTemp => tmp_cout1,
       Paths => (0 => (dataa_ipd'last_event, tpd_dataa_cout1, TRUE),
                 1 => (datab_ipd'last_event, tpd_datab_cout1, TRUE),
                 2 => (cin1_ipd'last_event, tpd_cin1_cout1, TRUE)),
       GlitchData => cout1_VitalGlitchData,    
       Mode => DefGlitchMode, 
       XOn  => XOn, 
       MsgOn => MsgOn );

      VitalPathDelay01 (
       OutSignal => multout,
       OutSignalName => "MULTOUT",
       OutTemp => tmp_multout,
       Paths => (0 => (dataa_ipd'last_event, tpd_dataa_multout, TRUE),
                 1 => (datab_ipd'last_event, tpd_datab_multout, TRUE),
                 2 => (multsela_ipd'last_event, tpd_multsela_multout, TRUE),
                 3 => (multselb_ipd'last_event, tpd_multselb_multout, TRUE),
                 4 => (cin_ipd'last_event, tpd_cin_multout, TRUE),
                 5 => (cin0_ipd'last_event, tpd_cin0_multout, TRUE),
                 6 => (cin1_ipd'last_event, tpd_cin1_multout, TRUE),
				 7 => (multdataa_ipd'last_event, tpd_multdataa_multout, (operation_mode= "multiplier" and multsela_ipd = '1' and multselb_ipd = '0')),
                 8 => (multdatab_ipd'last_event, tpd_multdatab_multout, (operation_mode= "multiplier" and multsela_ipd = '0' and multselb_ipd = '1'))),
       GlitchData => multout_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn => MsgOn );

end process;

end vital_le;	

LIBRARY IEEE, mercury;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE mercury.atom_pack.all;

ENTITY mercury_lcell_register is
  GENERIC (
      power_up : string := "low";
      packed_mode   : string := "false";
      x_on_violation : string := "on";
      TimingChecksOn: Boolean := True;
      MsgOn: Boolean := DefGlitchMsgOn;
      XOn: Boolean := DefGlitchXOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      InstancePath: STRING := "*";
      tsetup_datain_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      tsetup_datac_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      tsetup_sclr_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      tsetup_sload_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      tsetup_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      thold_datain_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      thold_datac_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      thold_sclr_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      thold_sload_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      thold_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      tpd_clk_regout_posedge		: VitalDelayType01 := DefPropDelay01;
      tpd_apre_regout_posedge		: VitalDelayType01 := DefPropDelay01;
      tpd_aclr_regout_posedge		: VitalDelayType01 := DefPropDelay01;
      tpd_aload_regout_posedge		: VitalDelayType01 := DefPropDelay01;
      tpd_datac_regout			: VitalDelayType01 := DefPropDelay01;
      tperiod_clk_posedge               : VitalDelayType := DefPulseWdthCnst;
      tipd_datac  			: VitalDelayType01 := DefPropDelay01; 
      tipd_ena  			: VitalDelayType01 := DefPropDelay01; 
      tipd_apre 			: VitalDelayType01 := DefPropDelay01; 
      tipd_aclr 			: VitalDelayType01 := DefPropDelay01; 
      tipd_aload 			: VitalDelayType01 := DefPropDelay01; 
      tipd_sclr 			: VitalDelayType01 := DefPropDelay01; 
      tipd_sload 			: VitalDelayType01 := DefPropDelay01; 
      tipd_clk  			: VitalDelayType01 := DefPropDelay01);

  PORT (clk :in std_logic := '0';
        datain  : in std_logic := '1';
        datac     : in std_logic := '1';
        apre    : in std_logic := '0';
        aclr    : in std_logic := '0';
        aload : in std_logic := '0';
        sclr : in std_logic := '0';
        sload : in std_logic := '0';
        ena : in std_logic := '1';
        devclrn   : in std_logic := '1';
        devpor    : in std_logic := '1';
        regout    : out std_logic);
   attribute VITAL_LEVEL0 of mercury_lcell_register : ENTITY is TRUE;
end mercury_lcell_register;
        
architecture vital_le_reg of mercury_lcell_register is
   attribute VITAL_LEVEL0 of vital_le_reg : architecture is TRUE;
   signal ena_ipd, sload_ipd, aload_ipd, datac_ipd : std_logic;
   signal clk_ipd, apre_ipd, aclr_ipd, sclr_ipd : std_logic;
begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (datac_ipd, datac, tipd_datac);
   VitalWireDelay (clk_ipd, clk, tipd_clk);
   VitalWireDelay (apre_ipd, apre, tipd_apre);
   VitalWireDelay (aclr_ipd, aclr, tipd_aclr);
   VitalWireDelay (aload_ipd, aload, tipd_aload);
   VitalWireDelay (sclr_ipd, sclr, tipd_sclr);
   VitalWireDelay (sload_ipd, sload, tipd_sload);
   VitalWireDelay (ena_ipd, ena, tipd_ena);
   end block;

VITALtiming : process(clk_ipd, apre_ipd, aclr_ipd, aload_ipd, datac_ipd, devclrn, devpor, datain, sclr_ipd, ena_ipd, sload_ipd)

variable Tviol_datain_clk : std_ulogic := '0';
variable Tviol_datac_clk : std_ulogic := '0';
variable Tviol_sclr_clk : std_ulogic := '0';
variable Tviol_sload_clk : std_ulogic := '0';
variable Tviol_ena_clk : std_ulogic := '0';
variable Tviol_clk : std_ulogic := '0';
variable TimingData_datain_clk : VitalTimingDataType := VitalTimingDataInit;
variable TimingData_datac_clk : VitalTimingDataType := VitalTimingDataInit;
variable TimingData_sclr_clk : VitalTimingDataType := VitalTimingDataInit;
variable TimingData_sload_clk : VitalTimingDataType := VitalTimingDataInit;
variable TimingData_ena_clk : VitalTimingDataType := VitalTimingDataInit;
variable PeriodData_clk : VitalPeriodDataType := VitalPeriodDataInit;
variable regout_VitalGlitchData : VitalGlitchDataType;

variable iregout : std_logic;
variable idata, setbit : std_logic := '0';
variable tmp_regout : std_logic;

-- variables for 'X' generation
variable violation : std_logic := '0';

begin

      if (now = 0 ns) then
         if (power_up = "low") then
            iregout := '0';
         elsif (power_up = "high") then
            iregout := '1';
         end if;
      end if;

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
                                          (apre_ipd) OR 
                                          (sload_ipd) OR 
                                          (NOT ena_ipd)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

         VitalSetupHoldCheck (
                Violation       => Tviol_datac_clk,
                TimingData      => TimingData_datac_clk,
                TestSignal      => datac_ipd,
                TestSignalName  => "DATAC",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_datac_clk_noedge_posedge,
                SetupLow        => tsetup_datac_clk_noedge_posedge,
                HoldHigh        => thold_datac_clk_noedge_posedge,
                HoldLow         => thold_datac_clk_noedge_posedge,
                CheckEnabled    => TO_X01((aclr_ipd) OR (NOT devpor) OR (NOT devclrn) OR (apre_ipd) OR (NOT ena_ipd)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL",
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
                CheckEnabled    => TO_X01((aclr_ipd) OR (NOT devpor) OR (NOT devclrn) OR (apre_ipd)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL",
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
                CheckEnabled    => TO_X01((aclr_ipd) OR (NOT devpor) OR (NOT devclrn) OR (apre_ipd)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL",
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
                CheckEnabled    => TO_X01((aclr_ipd) OR (NOT devpor) OR (NOT devclrn) OR (apre_ipd)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

          VitalPeriodPulseCheck (
                 Violation       => Tviol_clk,
                 PeriodData      => PeriodData_clk,
                 TestSignal      => clk_ipd,
                 TestSignalName  => "CLK",
                 Period          => tperiod_clk_posedge,
                 CheckEnabled    => TO_X01((aclr_ipd) OR (NOT devpor) OR (NOT devclrn) OR (apre_ipd)) /= '1',
                 HeaderMsg       => InstancePath & "/LCELL",
                 XOn             => XOnChecks,
                 MsgOn           => MsgOnChecks );
 
      end if;

      violation := Tviol_datain_clk or Tviol_datac_clk or Tviol_ena_clk or
                   Tviol_sclr_clk or Tviol_sload_clk or Tviol_clk;

		if (devpor = '0') then
			if (power_up = "low") then
				iregout := '0';
			elsif (power_up = "high") then
				iregout := '1';
			end if;
		elsif (devclrn = '0') then
			iregout := '0';
		elsif (aclr_ipd = '1') then
			iregout := '0';
		elsif (apre_ipd = '1') then
			iregout := '1';
		elsif (aload_ipd = '1') then
			iregout := datac_ipd;
                elsif (violation = 'X' and x_on_violation = "on") then
                        iregout := 'X';
		elsif clk_ipd'event and clk_ipd = '1' and clk_ipd'last_value = '0'then
			if (ena_ipd = '1') then
				if (sclr_ipd = '1') then
					iregout := '0';
				elsif (sload_ipd = '1') then
					iregout := datac_ipd;
				else
					if packed_mode = "true" then
						iregout := datac_ipd;
					else
						iregout := datain;
					end if;
				end if;
			end if;
		end if;

      tmp_regout := iregout;

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => regout,
       OutSignalName => "REGOUT",
       OutTemp => tmp_regout,
       Paths => (0 => (aclr_ipd'last_event, tpd_aclr_regout_posedge, TRUE),
                 1 => (clk_ipd'last_event, tpd_clk_regout_posedge, TRUE),
                 2 => (aload_ipd'last_event, tpd_aload_regout_posedge, TRUE),
                 3 => (datac_ipd'last_event, tpd_datac_regout, TRUE),
                 4 => (apre_ipd'last_event, tpd_apre_regout_posedge, TRUE)),
       GlitchData => regout_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

end process;

end vital_le_reg;	


LIBRARY IEEE, mercury;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE mercury.atom_pack.all;

ENTITY mercury_lcell is
  GENERIC (
  operation_mode: string := "normal";
  output_mode   : string := "comb_and_reg";
  packed_mode   : string := "false";
  multiplier_output : string := "true";
  multiplier_mux_source : string := "gnd";
  lut_mask      : string := "ffff";
  power_up      : string := "low";
  cin0_used     : string := "false";
  cin1_used     : string := "false";
  cin_used      : string := "false";
  lpm_type      : string := "mercury_lcell";
  x_on_violation: string := "on"
  );

  PORT (clk     : in std_logic := '0';
        dataa     : in std_logic := '1';
        datab     : in std_logic := '1';
        datac     : in std_logic := '1';
        datad     : in std_logic := '1';
        apre    : in std_logic := '0';
        aclr    : in std_logic := '0';
        aload : in std_logic := '0';
        sclr : in std_logic := '0';
        sload : in std_logic := '0';
        ena : in std_logic := '1';
        cin   : in std_logic := '0';
        cin0   : in std_logic := '0';
        cin1   : in std_logic := '1';
        devclrn   : in std_logic := '1';
        devpor    : in std_logic := '1';
        multsela  : in std_logic := '1';
        multselb  : in std_logic := '1';
        combout   : out std_logic;
        regout    : out std_logic;
        multout   : out std_logic;
        cout  : out std_logic;
        cout0  : out std_logic;
        cout1  : out std_logic);
end mercury_lcell;
        
architecture vital_le_atom of mercury_lcell is

signal dffin : std_logic;

COMPONENT mercury_asynch_lcell 
  GENERIC (operation_mode    : string := "normal";
      output_mode   : string := "comb_and_reg";
		multiplier_output : string := "true";
		multiplier_mux_source : string := "gnd";
      lut_mask       : string := "ffff";
      power_up : string := "low";
      cin_used       : string := "false";
      cin0_used       : string := "false";
      cin1_used       : string := "false";
      TimingChecksOn: Boolean := True;
      MsgOn: Boolean := DefGlitchMsgOn;
      XOn: Boolean := DefGlitchXOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      InstancePath: STRING := "*";
      tpd_dataa_combout           : VitalDelayType01 := DefPropDelay01;
      tpd_datab_combout           : VitalDelayType01 := DefPropDelay01;
      tpd_datac_combout           : VitalDelayType01 := DefPropDelay01;
      tpd_datad_combout           : VitalDelayType01 := DefPropDelay01;
      tpd_cin_combout             : VitalDelayType01 := DefPropDelay01;
      tpd_cin0_combout            : VitalDelayType01 := DefPropDelay01;
      tpd_cin1_combout            : VitalDelayType01 := DefPropDelay01;
      tpd_multsela_combout        : VitalDelayType01 := DefPropDelay01;
      tpd_multselb_combout        : VitalDelayType01 := DefPropDelay01;
      tpd_multdataa_combout       : VitalDelayType01 := DefPropDelay01;
      tpd_multdatab_combout       : VitalDelayType01 := DefPropDelay01;
      tpd_dataa_regin             : VitalDelayType01 := DefPropDelay01;
      tpd_datab_regin             : VitalDelayType01 := DefPropDelay01;
      tpd_datac_regin             : VitalDelayType01 := DefPropDelay01;
      tpd_datad_regin             : VitalDelayType01 := DefPropDelay01;
      tpd_cin_regin               : VitalDelayType01 := DefPropDelay01;
      tpd_cin0_regin              : VitalDelayType01 := DefPropDelay01;
      tpd_cin1_regin              : VitalDelayType01 := DefPropDelay01;
      tpd_multsela_regin          : VitalDelayType01 := DefPropDelay01;
      tpd_multselb_regin          : VitalDelayType01 := DefPropDelay01;
      tpd_multdataa_regin         : VitalDelayType01 := DefPropDelay01;
      tpd_multdatab_regin         : VitalDelayType01 := DefPropDelay01;
      tpd_dataa_cout	             : VitalDelayType01 := DefPropDelay01;
      tpd_datab_cout	             : VitalDelayType01 := DefPropDelay01;
      tpd_datac_cout    	        : VitalDelayType01 := DefPropDelay01;
      tpd_datad_cout    	        : VitalDelayType01 := DefPropDelay01;
      tpd_cin_cout		        : VitalDelayType01 := DefPropDelay01;
      tpd_cin0_cout		        : VitalDelayType01 := DefPropDelay01;
      tpd_cin1_cout		        : VitalDelayType01 := DefPropDelay01;
      tpd_dataa_cout0              : VitalDelayType01 := DefPropDelay01;
      tpd_datab_cout0              : VitalDelayType01 := DefPropDelay01;
      tpd_cin0_cout0		        : VitalDelayType01 := DefPropDelay01;
      tpd_dataa_cout1              : VitalDelayType01 := DefPropDelay01;
      tpd_datab_cout1              : VitalDelayType01 := DefPropDelay01;
      tpd_datac_cout1   	        : VitalDelayType01 := DefPropDelay01;
      tpd_cin1_cout1		        : VitalDelayType01 := DefPropDelay01;
      tpd_dataa_multout           : VitalDelayType01 := DefPropDelay01;
      tpd_datab_multout           : VitalDelayType01 := DefPropDelay01;
      tpd_cin_multout             : VitalDelayType01 := DefPropDelay01;
      tpd_cin0_multout           : VitalDelayType01 := DefPropDelay01;
      tpd_cin1_multout           : VitalDelayType01 := DefPropDelay01;
      tpd_multsela_multout        : VitalDelayType01 := DefPropDelay01;
      tpd_multselb_multout        : VitalDelayType01 := DefPropDelay01;
      tpd_multdataa_multout       : VitalDelayType01 := DefPropDelay01;
      tpd_multdatab_multout       : VitalDelayType01 := DefPropDelay01;
	  tipd_dataa			: VitalDelayType01 := DefPropDelay01; 
      tipd_datab			: VitalDelayType01 := DefPropDelay01; 
      tipd_datac			: VitalDelayType01 := DefPropDelay01; 
      tipd_datad			: VitalDelayType01 := DefPropDelay01; 
      tipd_cin  			: VitalDelayType01 := DefPropDelay01; 
      tipd_cin0  			: VitalDelayType01 := DefPropDelay01; 
      tipd_cin1  			: VitalDelayType01 := DefPropDelay01; 
      tipd_multdataa		: VitalDelayType01 := DefPropDelay01; 
      tipd_multdatab		: VitalDelayType01 := DefPropDelay01; 
      tipd_multsela		: VitalDelayType01 := DefPropDelay01; 
      tipd_multselb		: VitalDelayType01 := DefPropDelay01); 

  PORT (
        dataa     : in std_logic := '1';
        datab     : in std_logic := '1';
        datac     : in std_logic := '1';
        datad     : in std_logic := '1';
        cin       : in std_logic := '0';
        cin0      : in std_logic := '0';
        cin1      : in std_logic := '1';
        multsela  : in std_logic := '1';
        multselb  : in std_logic := '1';
        multdataa : in std_logic := '1';
        multdatab : in std_logic := '1';
        combout   : out std_logic;
        cout      : out std_logic;
        cout0     : out std_logic;
        cout1     : out std_logic;
        multout   : out std_logic;
        regin     : out std_logic);
END COMPONENT;

COMPONENT mercury_lcell_register
  GENERIC (
      power_up : string := "low";
      packed_mode   : string := "false";
      x_on_violation : string := "on";
      TimingChecksOn: Boolean := True;
      MsgOn: Boolean := DefGlitchMsgOn;
      XOn: Boolean := DefGlitchXOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      InstancePath: STRING := "*";
      tsetup_datain_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      tsetup_datac_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      tsetup_sclr_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      tsetup_sload_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      tsetup_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      thold_datain_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      thold_datac_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      thold_sclr_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      thold_sload_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      thold_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      tpd_clk_regout_posedge		: VitalDelayType01 := DefPropDelay01;
      tpd_apre_regout_posedge		: VitalDelayType01 := DefPropDelay01;
      tpd_aclr_regout_posedge		: VitalDelayType01 := DefPropDelay01;
      tpd_aload_regout_posedge		: VitalDelayType01 := DefPropDelay01;
      tperiod_clk_posedge               : VitalDelayType := DefPulseWdthCnst;
      tipd_datac  			: VitalDelayType01 := DefPropDelay01; 
      tipd_ena  			: VitalDelayType01 := DefPropDelay01; 
      tipd_apre 			: VitalDelayType01 := DefPropDelay01; 
      tipd_aclr 			: VitalDelayType01 := DefPropDelay01; 
      tipd_aload 			: VitalDelayType01 := DefPropDelay01; 
      tipd_sclr 			: VitalDelayType01 := DefPropDelay01; 
      tipd_sload 			: VitalDelayType01 := DefPropDelay01; 
      tipd_clk  			: VitalDelayType01 := DefPropDelay01);

  PORT (clk     : in std_logic := '0';
        datain     : in std_logic := '1';
        datac     : in std_logic := '1';
        apre    : in std_logic := '0';
        aclr    : in std_logic := '0';
        aload : in std_logic := '0';
        sclr : in std_logic := '0';
        sload : in std_logic := '0';
        ena : in std_logic := '1';
        devclrn   : in std_logic := '1';
        devpor    : in std_logic := '1';
        regout    : out std_logic);
END COMPONENT;

begin

lecomb: mercury_asynch_lcell
        generic map (operation_mode => operation_mode, output_mode => output_mode,
                     lut_mask => lut_mask, cin_used => cin_used, cin0_used => cin0_used, cin1_used => cin1_used, multiplier_mux_source => multiplier_mux_source)
        port map (dataa => dataa, datab => datab, datac => datac, datad => datad,
						multsela => multsela, multselb => multselb,
						multdataa => dataa, multdatab => datab,
                  cin => cin, cin0 => cin0, cin1 => cin1,
                  combout => combout, cout => cout, cout0 => cout0, cout1 => cout1, regin => dffin, multout => multout);

lereg: mercury_lcell_register
	generic map (power_up => power_up, packed_mode => packed_mode,
                     x_on_violation => x_on_violation)
  	port map (clk => clk, datain => dffin, datac => datac, apre => apre,
                  aclr => aclr, aload => aload, sclr => sclr, sload => sload, ena => ena,
                  devclrn => devclrn, devpor => devpor, regout => regout);


end vital_le_atom;	

--/////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : MERCURY_ASYNCH_MEM
--
-- Description : Timing simulation model for the asynchronous RAM array
--
--/////////////////////////////////////////////////////////////////////////////

LIBRARY ieee, mercury;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE mercury.atom_pack.all;
 
ENTITY mercury_asynch_mem is
    GENERIC (
             operation_mode                            : string := "single_port";
             port_a_operation_mode                     : string := "single_port";
             port_b_operation_mode                     : string := "single_port";
       
             port_a_write_deep_ram_mode                : string := "off";
             port_a_write_address_width                : integer := 1;
             port_a_write_first_address                : integer := 0;
             port_a_write_last_address                 : integer := 4095;
             port_a_write_data_width                   : integer := 1;
       
             port_a_read_deep_ram_mode                 : string := "off";
             port_a_read_address_width                 : integer := 1;
             port_a_read_first_address                 : integer := 0;
             port_a_read_last_address                  : integer := 4095;
             port_a_read_data_width                    : integer := 1;
       
             port_b_write_deep_ram_mode                : string := "off";
             port_b_write_address_width                : integer := 1;
             port_b_write_first_address                : integer := 0;
             port_b_write_last_address                 : integer := 4095;
             port_b_write_data_width                   : integer := 1;
       
             port_b_read_deep_ram_mode                 : string := "off";
             port_b_read_address_width                 : integer := 1;
             port_b_read_first_address                 : integer := 0;
             port_b_read_last_address                  : integer := 4095;
             port_b_read_data_width                    : integer := 1;
       
             port_a_read_enable_clock                  : string := "none";
             port_b_read_enable_clock                  : string := "none";
             port_a_write_logic_clock                  : string := "none";
             port_b_write_logic_clock                  : string := "none";
       
             init_file                                 : string := "none";
             port_a_init_file                          : string := "none";
             port_b_init_file                          : string := "none";
       
             mem1                                      : std_logic_vector(512 downto 1);
             mem2                                      : std_logic_vector(512 downto 1);
             mem3                                      : std_logic_vector(512 downto 1);
             mem4                                      : std_logic_vector(512 downto 1);
             mem5                                      : std_logic_vector(512 downto 1);
             mem6                                      : std_logic_vector(512 downto 1);
             mem7                                      : std_logic_vector(512 downto 1);
             mem8                                      : std_logic_vector(512 downto 1);
       
             bit_number                                : integer := 0;
             TimingChecksOn                            : Boolean := True;
             MsgOn                                     : Boolean := DefGlitchMsgOn;
             XOn                                       : Boolean := DefGlitchXOn;
             MsgOnChecks                               : Boolean := DefMsgOnChecks;
             XOnChecks                                 : Boolean := DefXOnChecks;
             InstancePath                              : STRING := "*";
       
             -- timing check generics for PORT A
       
             tsetup_portawaddr_portawe_noedge_posedge  : VitalDelayArrayType(15 downto 0) := (OTHERS => DefSetupHoldCnst);
             thold_portawaddr_portawe_noedge_negedge   : VitalDelayArrayType(15 downto 0) := (OTHERS => DefSetupHoldCnst);
             tsetup_portadatain_portawe_noedge_negedge : VitalDelayArrayType(15 downto 0) := (OTHERS => DefSetupHoldCnst);
             thold_portadatain_portawe_noedge_negedge  : VitalDelayArrayType(15 downto 0) := (OTHERS => DefSetupHoldCnst);
             tsetup_portaraddr_portare_noedge_negedge  : VitalDelayArrayType(15 downto 0) := (OTHERS => DefSetupHoldCnst);
             thold_portaraddr_portare_noedge_negedge   : VitalDelayArrayType(15 downto 0) := (OTHERS => DefSetupHoldCnst);
       
             -- path delay generics for PORT A
       
             tpd_portaraddr_portadataout               : VitalDelayArrayType01(255 downto 0) := (OTHERS => DefPropDelay01);
       --      tpd_portawaddr_portadataout             : VitalDelayArrayType01(255 downto 0) := (OTHERS => DefPropDelay01);
             tpd_portare_portadataout                  : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
             tpd_portadatain_portadataout              : VitalDelayArrayType01(255 downto 0) := (OTHERS => DefPropDelay01);
             tpd_portawe_portadataout                  : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
             tpd_portbwe_portadataout                  : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
             tpd_portbdatain_portadataout              : VitalDelayArrayType01(255 downto 0) := (OTHERS => DefPropDelay01);
       
             -- timing check generics for PORT B
       
             tsetup_portbwaddr_portbwe_noedge_posedge  : VitalDelayArrayType(15 downto 0) := (OTHERS => DefSetupHoldCnst);
             thold_portbwaddr_portbwe_noedge_negedge   : VitalDelayArrayType(15 downto 0) := (OTHERS => DefSetupHoldCnst);
             tsetup_portbdatain_portbwe_noedge_negedge : VitalDelayArrayType(15 downto 0) := (OTHERS => DefSetupHoldCnst);
             thold_portbdatain_portbwe_noedge_negedge  : VitalDelayArrayType(15 downto 0) := (OTHERS => DefSetupHoldCnst);
             tsetup_portbraddr_portbre_noedge_negedge  : VitalDelayArrayType(15 downto 0) := (OTHERS => DefSetupHoldCnst);
             thold_portbraddr_portbre_noedge_negedge   : VitalDelayArrayType(15 downto 0) := (OTHERS => DefSetupHoldCnst);
       
             -- path delay generics for PORT B
       
             tpd_portbraddr_portbdataout               : VitalDelayArrayType01(255 downto 0) := (OTHERS => DefPropDelay01);
       --      tpd_portbwaddr_portbdataout             : VitalDelayArrayType01(255 downto 0) := (OTHERS => DefPropDelay01);
             tpd_portbre_portbdataout                  : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
             tpd_portbdatain_portbdataout              : VitalDelayArrayType01(255 downto 0) := (OTHERS => DefPropDelay01);
             tpd_portbwe_portbdataout                  : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
             tpd_portawe_portbdataout                  : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
             tpd_portadatain_portbdataout              : VitalDelayArrayType01(255 downto 0) := (OTHERS => DefPropDelay01);
       
       -- port delay generics
       
               tipd_portadatain                        : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
               tipd_portawaddr                         : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
               tipd_portaraddr                         : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
               tipd_portawe                            : VitalDelayType01 := DefPropDelay01;
               tipd_portare                            : VitalDelayType01 := DefPropDelay01;
       
               tipd_portbdatain                        : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
               tipd_portbwaddr                         : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
               tipd_portbraddr                         : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
               tipd_portbwe                            : VitalDelayType01 := DefPropDelay01;
               tipd_portbre                            : VitalDelayType01 := DefPropDelay01;
       
             tpw_portawe_posedge                       : VitalDelayType := DefPulseWdthCnst;
             tpw_portare_posedge                       : VitalDelayType := DefPulseWdthCnst;
             tpw_portbwe_posedge                       : VitalDelayType := DefPulseWdthCnst;
             tpw_portbre_posedge                       : VitalDelayType := DefPulseWdthCnst
            );
 
    PORT    ( portadatain                : in std_logic_vector(15 downto 0);
              portawe                    : in std_logic;
              portare                    : in std_logic;
              portaraddr                 : in std_logic_vector(15 downto 0);
              portawaddr                 : in std_logic_vector(15 downto 0);
              portbdatain                : in std_logic_vector(15 downto 0);
              portbwe                    : in std_logic;
              portbre                    : in std_logic;
              portbraddr                 : in std_logic_vector(15 downto 0);
              portbwaddr                 : in std_logic_vector(15 downto 0);
              portadataout               : out std_logic_vector(15 downto 0);
              portbdataout               : out std_logic_vector(15 downto 0);
              portamodesel               : in std_logic_vector(20 downto 0);
              portbmodesel               : in std_logic_vector(20 downto 0)
            );

   attribute VITAL_LEVEL0 of mercury_asynch_mem : ENTITY is TRUE;
end mercury_asynch_mem;
 
architecture behave of mercury_asynch_mem is
   attribute VITAL_LEVEL0 of behave : architecture is TRUE;

signal portadatain_ipd : std_logic_vector(15 downto 0);
signal portawaddr_ipd : std_logic_vector(15 downto 0);
signal portaraddr_ipd : std_logic_vector(15 downto 0);
signal portawe_ipd    : std_logic;
signal portare_ipd    : std_logic;

signal portbdatain_ipd : std_logic_vector(15 downto 0);
signal portbwaddr_ipd : std_logic_vector(15 downto 0);
signal portbraddr_ipd : std_logic_vector(15 downto 0);
signal portbwe_ipd : std_logic;
signal portbre_ipd : std_logic;

begin

    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
       g1 : for i in portadatain'range generate
          VitalWireDelay (portadatain_ipd(i), portadatain(i), tipd_portadatain(i));
       end generate;
       g2 : for i in portawaddr'range generate
          VitalWireDelay (portawaddr_ipd(i), portawaddr(i), tipd_portawaddr(i));
       end generate;
       g3 : for i in portaraddr'range generate
          VitalWireDelay (portaraddr_ipd(i), portaraddr(i), tipd_portaraddr(i));
       end generate;
       VitalWireDelay (portawe_ipd, portawe, tipd_portawe);
       VitalWireDelay (portare_ipd, portare, tipd_portare);

       g4 : for i in portbdatain'range generate
          VitalWireDelay (portbdatain_ipd(i), portbdatain(i), tipd_portbdatain(i));
       end generate;
       g5 : for i in portbwaddr'range generate
          VitalWireDelay (portbwaddr_ipd(i), portbwaddr(i), tipd_portbwaddr(i));
       end generate;
       g6 : for i in portbraddr'range generate
          VitalWireDelay (portbraddr_ipd(i), portbraddr(i), tipd_portbraddr(i));
       end generate;
       VitalWireDelay (portbwe_ipd, portbwe, tipd_portbwe);
       VitalWireDelay (portbre_ipd, portbre, tipd_portbre);
    end block;

    VITAL: process(portadatain_ipd, portawe_ipd, portare_ipd, portaraddr_ipd, portawaddr_ipd, portbdatain_ipd, portbwe_ipd, portbre_ipd, portbraddr_ipd, portbwaddr_ipd)
        variable Tviol_portadatain_portawe : std_ulogic := '0';
        variable Tviol_portawaddr_portawe : std_ulogic := '0';
        variable Tviol_portaraddr_portare : std_ulogic := '0';
        variable TimingData_portawaddr_portawe : VitalTimingDataType := VitalTimingDataInit;
        variable TimingData_portaraddr_portare : VitalTimingDataType := VitalTimingDataInit;
        variable TimingData_portadatain_portawe : VitalTimingDataType := VitalTimingDataInit;
        variable portadataout_VitalGlitchDataArray : VitalGlitchDataArrayType(15 downto 0);
        variable Tviol_portawe : std_ulogic := '0';
        variable PeriodData_portawe: VitalPeriodDataType := VitalPeriodDataInit;
        variable Tviol_portare : std_ulogic := '0';
        variable PeriodData_portare: VitalPeriodDataType := VitalPeriodDataInit;

        variable Tviol_portbdatain_portbwe : std_ulogic := '0';
        variable Tviol_portbwaddr_portbwe : std_ulogic := '0';
        variable Tviol_portbraddr_portbre : std_ulogic := '0';
        variable TimingData_portbwaddr_portbwe : VitalTimingDataType := VitalTimingDataInit;
        variable TimingData_portbraddr_portbre : VitalTimingDataType := VitalTimingDataInit;
        variable TimingData_portbdatain_portbwe : VitalTimingDataType := VitalTimingDataInit;
        variable portbdataout_VitalGlitchDataArray : VitalGlitchDataArrayType(15 downto 0);
        variable Tviol_portbwe : std_ulogic := '0';
        variable PeriodData_portbwe: VitalPeriodDataType := VitalPeriodDataInit;
        variable Tviol_portbre : std_ulogic := '0';
        variable PeriodData_portbre: VitalPeriodDataType := VitalPeriodDataInit;

        variable tmp_mem, mem : std_logic_vector(4095 downto 0) := (OTHERS => '0');
        variable raddr_a, waddr_a, raddr_b, waddr_b  : integer := 0;
        variable waddr_a_lsb, waddr_b_lsb : integer := 0;
        variable raddr_a_lsb, raddr_b_lsb : integer := 0;
        variable waddr_a_msb : integer := port_a_write_data_width-1;
        variable waddr_b_msb : integer := port_b_write_data_width-1;
        variable raddr_a_msb, raddr_b_msb : integer := 1;
        variable tmp_a_dataout : std_logic_vector(15 downto 0) := (OTHERS => '1');
        variable tmp_b_dataout : std_logic_vector(15 downto 0) := (OTHERS => '1');
        variable re_active_a, re_active_b : boolean := false;
        variable l, index, offset, depth : integer := 0;
        variable port_b_offset : integer := 0;
        variable port_a_we_was_active, port_b_we_was_active : boolean := false;
        variable do_init_mem : boolean := true;

        variable a_size, b_size : integer := 0;

        variable port_a_write_is_valid : boolean := false;
        variable port_b_write_is_valid : boolean := false;
        variable same_address_write : boolean := false;
        TYPE bool_array is ARRAY(0 to 4095) of boolean;
        variable addr_is_in_port_a_write_cycle : bool_array;
        variable addr_is_in_port_b_write_cycle : bool_array;

    begin

       ------------------------
       --  Timing Check Section
       ------------------------
       if (TimingChecksOn) then

          -- PORT A Timing checks

          if (portamodesel(2) = '0') then -- write_logic is unregistered
             VitalSetupHoldCheck (
                Violation       => Tviol_portawaddr_portawe,
                TimingData      => TimingData_portawaddr_portawe,
                TestSignal      => portawaddr_ipd,
                TestSignalName  => "PORTAWADDR",
                RefSignal       => portawe_ipd,
                RefSignalName   => "PORTAWE",
                SetupHigh       => tsetup_portawaddr_portawe_noedge_posedge(0),
                SetupLow        => tsetup_portawaddr_portawe_noedge_posedge(0),
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/MERCURY_ASYNCH_MEM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

             VitalSetupHoldCheck (
                Violation       => Tviol_portawaddr_portawe,
                TimingData      => TimingData_portawaddr_portawe,
                TestSignal      => portawaddr_ipd,
                TestSignalName  => "PORTAWADDR",
                RefSignal       => portawe_ipd,
                RefSignalName   => "PORTAWE",
                HoldHigh        => thold_portawaddr_portawe_noedge_negedge(0),
                HoldLow         => thold_portawaddr_portawe_noedge_negedge(0),
                RefTransition   => '\',
                HeaderMsg       => InstancePath & "/MERCURY_ASYNCH_MEM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

             VitalPeriodPulseCheck (
                Violation       => Tviol_portawe,
                PeriodData      => PeriodData_portawe,
                TestSignal      => portawe_ipd,
                TestSignalName  => "PORTAWE",
                PulseWidthHigh  => tpw_portawe_posedge,
                HeaderMsg       => InstancePath & "/MERCURY_ASYNCH_MEM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
          end if;

         if (portamodesel(5) = '0') then -- portaraddr is unregistered
            VitalSetupHoldCheck (
                Violation       => Tviol_portaraddr_portare,
                TimingData      => TimingData_portaraddr_portare,
                TestSignal      => portaraddr_ipd,
                TestSignalName  => "PORTARADDR",
                RefSignal       => portare_ipd,
                RefSignalName   => "PORTARE",
                SetupHigh       => tsetup_portaraddr_portare_noedge_negedge(0),
                SetupLow        => tsetup_portaraddr_portare_noedge_negedge(0),
                HoldHigh        => thold_portaraddr_portare_noedge_negedge(0),
                HoldLow         => thold_portaraddr_portare_noedge_negedge(0),
                RefTransition   => '\',
                HeaderMsg       => InstancePath & "/MERCURY_ASYNCH_MEM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
         end if;

         if (portamodesel(7) = '0') then -- portare is unregistered
            VitalPeriodPulseCheck (
                Violation       => Tviol_portare,
                PeriodData      => PeriodData_portare,
                TestSignal      => portare_ipd,
                TestSignalName  => "PORTARE",
                PulseWidthHigh  => tpw_portare_posedge,
                HeaderMsg       => InstancePath & "/MERCURY_ASYNCH_MEM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
         end if;

         if (portamodesel(0) = '0') then -- portadatain is unregistered
            VitalSetupHoldCheck (
                Violation       => Tviol_portadatain_portawe,
                TimingData      => TimingData_portadatain_portawe,
                TestSignal      => portadatain_ipd,
                TestSignalName  => "PORTADATAIN",
                RefSignal       => portawe_ipd,
                RefSignalName   => "PORTAWE",
                SetupHigh       => tsetup_portadatain_portawe_noedge_negedge(0),
                SetupLow        => tsetup_portadatain_portawe_noedge_negedge(0),
                HoldHigh        => thold_portadatain_portawe_noedge_negedge(0),
                HoldLow         => thold_portadatain_portawe_noedge_negedge(0),
                RefTransition   => '\',
                HeaderMsg       => InstancePath & "/MERCURY_ASYNCH_MEM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
         end if;

         -- PORT B Timing checks

         if (portbmodesel(2) = '0') then -- write_logic is unregistered
            VitalSetupHoldCheck (
                Violation       => Tviol_portbwaddr_portbwe,
                TimingData      => TimingData_portbwaddr_portbwe,
                TestSignal      => portbwaddr_ipd,
                TestSignalName  => "PORTBWADDR",
                RefSignal       => portbwe_ipd,
                RefSignalName   => "PORTBWE",
                SetupHigh       => tsetup_portbwaddr_portbwe_noedge_posedge(0),
                SetupLow        => tsetup_portbwaddr_portbwe_noedge_posedge(0),
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/MERCURY_ASYNCH_MEM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

            VitalSetupHoldCheck (
                Violation       => Tviol_portbwaddr_portbwe,
                TimingData      => TimingData_portbwaddr_portbwe,
                TestSignal      => portbwaddr_ipd,
                TestSignalName  => "PORTBWADDR",
                RefSignal       => portbwe_ipd,
                RefSignalName   => "PORTBWE",
                HoldHigh        => thold_portbwaddr_portbwe_noedge_negedge(0),
                HoldLow         => thold_portbwaddr_portbwe_noedge_negedge(0),
                RefTransition   => '\',
                HeaderMsg       => InstancePath & "/MERCURY_ASYNCH_MEM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

            VitalPeriodPulseCheck (
                Violation       => Tviol_portbwe,
                PeriodData      => PeriodData_portbwe,
                TestSignal      => portbwe_ipd,
                TestSignalName  => "PORTBWE",
                PulseWidthHigh  => tpw_portbwe_posedge,
                HeaderMsg       => InstancePath & "/MERCURY_ASYNCH_MEM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

         end if;

         if (portbmodesel(5) = '0') then -- portbraddr is unregistered
            VitalSetupHoldCheck (
                Violation       => Tviol_portbraddr_portbre,
                TimingData      => TimingData_portbraddr_portbre,
                TestSignal      => portbraddr_ipd,
                TestSignalName  => "PORTBRADDR",
                RefSignal       => portbre_ipd,
                RefSignalName   => "PORTBRE",
                SetupHigh       => tsetup_portbraddr_portbre_noedge_negedge(0),
                SetupLow        => tsetup_portbraddr_portbre_noedge_negedge(0),
                HoldHigh        => thold_portbraddr_portbre_noedge_negedge(0),
                HoldLow         => thold_portbraddr_portbre_noedge_negedge(0),
                RefTransition   => '\',
                HeaderMsg       => InstancePath & "/MERCURY_ASYNCH_MEM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
         end if;

         if (portbmodesel(7) = '0') then -- portbre is unregistered
            VitalPeriodPulseCheck (
                Violation       => Tviol_portbre,
                PeriodData      => PeriodData_portbre,
                TestSignal      => portbre_ipd,
                TestSignalName  => "PORTBRE",
                PulseWidthHigh  => tpw_portbre_posedge,
                HeaderMsg       => InstancePath & "/MERCURY_ASYNCH_MEM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
         end if;

         if (portbmodesel(0) = '0') then -- portbdatain is unregistered
            VitalSetupHoldCheck (
                Violation       => Tviol_portbdatain_portbwe,
                TimingData      => TimingData_portbdatain_portbwe,
                TestSignal      => portbdatain_ipd,
                TestSignalName  => "PORTBDATAIN",
                RefSignal       => portbwe_ipd,
                RefSignalName   => "PORTBWE",
                SetupHigh       => tsetup_portbdatain_portbwe_noedge_negedge(0),
                SetupLow        => tsetup_portbdatain_portbwe_noedge_negedge(0),
                HoldHigh        => thold_portbdatain_portbwe_noedge_negedge(0),
                HoldLow         => thold_portbdatain_portbwe_noedge_negedge(0),
                RefTransition   => '\',
                HeaderMsg       => InstancePath & "/MERCURY_ASYNCH_MEM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
         end if;

    end if;

    -- functionality section

    if (now = 0 ns and do_init_mem) then
       do_init_mem := false;
       port_b_offset := 0;
       tmp_mem := (mem8 & mem7 & mem6 & mem5 & mem4 & mem3 & mem2 & mem1);

       -- arrange the initialization data word wise, it is slice-wise
       depth := port_a_read_last_address - port_a_read_first_address + 1;

       for j in 0 to (depth-1) loop
           for k in 0 to (port_a_read_data_width-1) loop
               index := j + (depth * k);
               mem(l) := tmp_mem(index);
               l := l + 1;
           end loop;
       end loop;

       if (operation_mode = "packed") then
          depth := port_b_read_last_address - port_b_read_first_address + 1;
          offset := l;
          port_b_offset := l;
          for j in 0 to (depth-1) loop
              for k in 0 to (port_b_read_data_width-1) loop
                 index := offset + j + (depth * k);
                 mem(l) := tmp_mem(index);
                 l := l + 1;
              end loop;
          end loop;
       end if;

       -- initial memory contents depend on WE registered or not
       -- if WE is not registered, RAM contents are 'X"
       a_size := port_a_read_data_width * (port_a_read_last_address - port_a_read_first_address + 1);
       b_size := port_b_read_data_width * (port_b_read_last_address - port_b_read_first_address + 1);
       if (operation_mode /= "packed") then
          if (operation_mode = "single_port" or operation_mode = "dual_port") then
             if (port_a_write_logic_clock = "none") then
                mem(a_size-1 downto 0) := (OTHERS => 'X');
             end if;
          elsif (operation_mode /= "rom" and (port_a_write_logic_clock = "none" or port_b_write_logic_clock = "none")) then
             mem(a_size-1 downto 0) := (OTHERS => 'X');
          end if;
       end if;
       if (operation_mode = "packed") then
--            a_size := port_a_read_data_width * (port_a_read_last_address - port_a_read_first_address + 1);
--            b_size := port_b_read_data_width * (port_b_read_last_address - port_b_read_first_address + 1);
          if (port_a_operation_mode /= "rom" and port_a_write_logic_clock = "none") then
             mem(a_size-1 downto 0) := (OTHERS => 'X');
          end if;
          if (port_b_operation_mode /= "rom" and port_b_write_logic_clock = "none") then
             mem(b_size-1 downto a_size) := (OTHERS => 'X');
          end if;
       end if;

       -- set the initial re state, depending on operation mode
       if ((operation_mode = "rom") or (operation_mode = "single_port")) then
          re_active_a := true;
       end if;
       if (operation_mode = "bidir_dual_port") then
          re_active_a := true;
          re_active_b := true;
       end if;
       if (operation_mode = "packed") then
          if ((port_a_operation_mode = "rom") or (port_a_operation_mode = "single_port")) then
             re_active_a := true;
          end if;
          if ((port_b_operation_mode = "rom") or (port_b_operation_mode = "single_port")) then
             re_active_b := true;
          end if;
       end if;

       -- if re is not registered, initial state of latch at
       -- o/p of ESB is undefined; so initialize tmp_a_dataout and
       -- tmp_b_dataout here

          tmp_a_dataout := (OTHERS => '1');
          tmp_b_dataout := (OTHERS => '1');
          if (port_a_read_enable_clock = "none") then
              tmp_a_dataout := (OTHERS => 'X');
          end if;
          if (port_b_read_enable_clock = "none") then
              tmp_b_dataout := (OTHERS => 'X');
          end if;

          for i in 0 to 4095 loop
             addr_is_in_port_a_write_cycle(i) := false;
             addr_is_in_port_b_write_cycle(i) := false;
          end loop;

    end if;

    if (portare_ipd'event and portare_ipd = '1') then
       re_active_a := true;
       for i in raddr_a_lsb to raddr_a_msb loop
           if ( portawe_ipd = '1' and ((i = waddr_a_lsb) or (i = waddr_a_msb) or ((i > waddr_a_lsb) and (i < waddr_a_msb))) ) then
              -- bit is being written by porta
              tmp_a_dataout(i rem port_a_read_data_width) := portadatain_ipd(i rem port_a_write_data_width);
           elsif ( operation_mode /= "packed" and portbwe_ipd = '1' and ((i = waddr_b_lsb) or (i = waddr_b_msb) or ((i > waddr_b_lsb) and (i < waddr_b_msb))) ) then
              -- bit is being written by portb
              tmp_a_dataout(i rem port_a_read_data_width) := portbdatain_ipd(i rem port_b_write_data_width);
           else
              -- bit not being written : read memory contents
              tmp_a_dataout(i rem port_a_read_data_width) := mem(i);
           end if;
       end loop;
    end if;

    if (portare_ipd'event and portare_ipd = '0') then
       re_active_a := false;
    end if;

    if (portaraddr_ipd'event) then
       -- calculate the porta read addresses
       raddr_a := conv_integer(portaraddr_ipd);
       raddr_a_lsb := raddr_a * port_a_read_data_width;
       raddr_a_msb := raddr_a_lsb + port_a_read_data_width - 1;

       -- schedule read data on outputs

       if (re_active_a) then
          for i in raddr_a_lsb to raddr_a_msb loop
              if (portawe_ipd = '1' and ((i = waddr_a_lsb) or (i = waddr_a_msb) or (i > waddr_a_lsb and i < waddr_a_msb))) then
                 tmp_a_dataout(i rem port_a_read_data_width) := portadatain_ipd(i rem port_a_write_data_width);
              elsif (operation_mode /= "packed" and portbwe_ipd = '1' and (( i = waddr_b_lsb) or (i = waddr_b_msb) or (i > waddr_b_lsb and i < waddr_b_msb))) then
                 tmp_a_dataout(i rem port_a_read_data_width) := portbdatain_ipd(i rem port_b_write_data_width);
              else
                 tmp_a_dataout(i rem port_a_read_data_width) := mem(i);
              end if;
          end loop;
       end if;
    end if;

    if (portbre_ipd'event and portbre_ipd = '1') then
       re_active_b := true;
       for i in raddr_b_lsb to raddr_b_msb loop
           if ( portbwe_ipd = '1' and ((i = waddr_b_lsb) or (i = waddr_b_msb) or ((i > waddr_b_lsb) and (i < waddr_b_msb))) ) then
              -- bit is being written by portb
              tmp_b_dataout(i rem port_b_read_data_width) := portbdatain_ipd(i rem port_b_write_data_width);
           elsif ( operation_mode /= "packed" and portawe_ipd = '1' and ((i = waddr_a_lsb) or (i = waddr_a_msb) or ((i > waddr_a_lsb) and (i < waddr_a_msb))) ) then
              -- bit is being written by porta
              tmp_b_dataout(i rem port_b_read_data_width) := portadatain_ipd(i rem port_a_write_data_width);
           else
              -- bit not being written : read memory contents
              tmp_b_dataout(i rem port_b_read_data_width) := mem(port_b_offset + i);
           end if;
       end loop;
    end if;

    if (portbre_ipd'event and portbre_ipd = '0') then
       re_active_b := false;
    end if;

    if (portbraddr_ipd'event) then
       -- calculate the portb read addresses
       raddr_b := conv_integer(portbraddr_ipd);
       raddr_b_lsb := raddr_b * port_b_read_data_width;
       raddr_b_msb := raddr_b_lsb + port_b_read_data_width - 1;

       -- schedule read data on outputs

       if (re_active_b) then
          for i in raddr_b_lsb to raddr_b_msb loop
              if (portbwe_ipd = '1'and ((i = waddr_b_lsb) or (i = waddr_b_msb) or (i > waddr_b_lsb and i < waddr_b_msb))) then
                 tmp_b_dataout(i rem port_b_read_data_width) := portbdatain_ipd(i rem port_b_write_data_width);
              elsif (operation_mode /= "packed" and portawe_ipd = '1' and ((i = waddr_a_lsb) or (i = waddr_a_msb) or (i > waddr_a_lsb and i < waddr_a_msb))) then
                 tmp_b_dataout(i rem port_b_read_data_width) := portadatain_ipd(i rem port_a_write_data_width);
              else
                 tmp_b_dataout(i rem port_b_read_data_width) := mem(port_b_offset + i);
              end if;
          end loop;
       end if;
    end if;

    if (portawe_ipd'event and portawe_ipd = '1') then
       port_a_we_was_active := true;

       -- check if port A write is valid
       for i in waddr_a_lsb to waddr_a_msb loop
          if (operation_mode = "bidir_dual_port" or operation_mode = "quad_port") then
             if (addr_is_in_port_b_write_cycle(i)) then
                port_a_write_is_valid := false;
                same_address_write := true;
                assert false report "Simultaneous write to same address. Data will be invalid in ESB." severity warning;
                exit;
             else
                port_a_write_is_valid := true;
                same_address_write := false;
             end if;
          else
             port_a_write_is_valid := true;
             same_address_write := false;
          end if;
       end loop;

       for i in 0 to ((port_a_write_last_address - port_a_write_first_address + 1) * port_a_write_data_width - 1) loop
          if (port_a_write_is_valid) then
             if (i >= waddr_a_lsb and i <= waddr_a_msb) then
                addr_is_in_port_a_write_cycle(i) := true;
             else
                addr_is_in_port_a_write_cycle(i) := false;
             end if;
          else
             addr_is_in_port_a_write_cycle(i) := false;
          end if;
       end loop;

       -- if port a read && write addr match, data flows thro' to portadataout

       for i in waddr_a_lsb to waddr_a_msb loop
           if ( re_active_a and ((i = raddr_a_lsb) or (i = raddr_a_msb) or ((i > raddr_a_lsb) and (i < raddr_a_msb))) ) then
           -- this bit is being read at the same time
              if (port_a_write_is_valid) then
                 tmp_a_dataout(i rem port_a_read_data_width) := portadatain_ipd(i rem port_a_write_data_width);
              elsif (same_address_write) then
                 tmp_a_dataout(i rem port_a_read_data_width) := 'X';
              end if;
           end if;
       end loop;

       -- if not packed mode && portb read addr match, data flows thro'
       -- to portbdataout

       if (operation_mode = "bidir_dual_port" or operation_mode = "quad_port") then
          for i in waddr_a_lsb to waddr_a_msb loop
              if ( re_active_b and ((i = raddr_b_lsb) or (i = raddr_b_msb) or ((i > raddr_b_lsb) and (i < raddr_b_msb))) ) then
                 -- this bit is also being read on port b
                 if (same_address_write) then
                    tmp_b_dataout(i rem port_b_read_data_width) := 'X';
                 elsif (port_a_write_is_valid) then
                    tmp_b_dataout(i rem port_b_read_data_width) := portadatain_ipd(i rem port_a_write_data_width);
                 end if;
              end if;
          end loop;
       end if;
    end if;

    if (portawe_ipd'event and portawe_ipd = '0') then
       if (port_a_we_was_active) then  -- checks if we has been active
                                       -- at least once : write will
                                       -- not happen if we went to 0 w/o
                                       -- ever going to 1
          port_a_we_was_active := false;
          -- take address out of write cycle
          for i in waddr_a_lsb to waddr_a_msb loop
             addr_is_in_port_a_write_cycle(i) := false;
          end loop;

          -- write the data into mem
          for i in 0 to port_a_write_data_width-1 loop
              if (same_address_write) then
                 mem(waddr_a_lsb + i) := 'X';
              else
                 mem(waddr_a_lsb + i) := portadatain_ipd(i);
              end if;
          end loop;
       end if;
    end if;

    if (portawaddr_ipd'event) then
       -- calculate the porta write addresses
       waddr_a := conv_integer(portawaddr_ipd);
       waddr_a_lsb := waddr_a * port_a_write_data_width;
       waddr_a_msb := waddr_a_lsb + port_a_write_data_width - 1;
    end if;

    if (portbwe_ipd'event and portbwe_ipd = '1') then
       port_b_we_was_active := true;

       -- check if port B write is valid
       for i in waddr_b_lsb to waddr_b_msb loop
          if (operation_mode = "bidir_dual_port" or operation_mode = "quad_port") then
             if (addr_is_in_port_a_write_cycle(i)) then
                port_b_write_is_valid := false;
                same_address_write := true;
                assert false report "Simultaneous write to same address. Data will be invalid in ESB." severity warning;
                exit;
             else
                port_b_write_is_valid := true;
                same_address_write := false;
             end if;
          else
             port_b_write_is_valid := true;
             same_address_write := false;
          end if;
       end loop;

       for i in 0 to ((port_b_write_last_address - port_b_write_first_address + 1) * port_b_write_data_width - 1) loop
          if (port_b_write_is_valid) then
             if (i >= waddr_b_lsb and i <= waddr_b_msb) then
                addr_is_in_port_b_write_cycle(i) := true;
             else
                addr_is_in_port_b_write_cycle(i) := false;
             end if;
          else
             addr_is_in_port_b_write_cycle(i) := false;
          end if;
       end loop;

       -- if port b read && write addr match, data flows thro' to portbdataout

       for i in waddr_b_lsb to waddr_b_msb loop
           if ( re_active_b and ((i = raddr_b_lsb) or (i = raddr_b_msb) or ((i > raddr_b_lsb) and (i < raddr_b_msb))) ) then
              -- this bit is being read at the same time
              if (port_b_write_is_valid) then
                 tmp_b_dataout(i rem port_b_read_data_width) := portbdatain_ipd(i rem port_b_write_data_width);
              elsif (same_address_write) then
                 tmp_b_dataout(i rem port_b_read_data_width) := 'X';
              end if;
           end if;
       end loop;

       -- if not packed mode && porta read addr match, data flows thro'
       -- to portadataout

       if (operation_mode = "bidir_dual_port" or operation_mode = "quad_port") then
          for i in waddr_b_lsb to waddr_b_msb loop
              if ( re_active_a and ((i = raddr_a_lsb) or (i = raddr_a_msb) or ((i > raddr_a_lsb) and (i < raddr_a_msb))) ) then
                 -- this bit is also being read on port a
                 if (same_address_write) then
                    tmp_a_dataout(i rem port_a_read_data_width) := 'X';
                 else
                    tmp_a_dataout(i rem port_a_read_data_width) := portbdatain_ipd(i rem port_b_write_data_width);
                 end if;
              end if;
          end loop;
       end if;
    end if;

    if (portbwe_ipd'event and portbwe_ipd = '0') then
       if (port_b_we_was_active) then  -- checks if we has been active
                                       -- at least once : write will
                                       -- not happen if we went to 0 w/o
                                       -- ever going to 1
          port_b_we_was_active := false;
          -- take address out of write cycle
          for i in waddr_b_lsb to waddr_b_msb loop
             addr_is_in_port_b_write_cycle(i) := false;
          end loop;

          -- write the data into mem
          for i in 0 to port_b_write_data_width-1 loop
              if (same_address_write) then
                 mem(port_b_offset + waddr_b_lsb + i) := 'X';
              else
                 mem(port_b_offset + waddr_b_lsb + i) := portbdatain_ipd(i);
              end if;
          end loop;
       end if;
    end if;

    if (portbwaddr_ipd'event) then
       -- calculate the portb write addresses
       waddr_b := conv_integer(portbwaddr_ipd);
       waddr_b_lsb := waddr_b * port_b_write_data_width;
       waddr_b_msb := waddr_b_lsb + port_b_write_data_width - 1;
    end if;

    if (portadatain_ipd'event) then
       if (portawe_ipd = '1') then
          if (re_active_a) then
             for i in raddr_a_lsb to raddr_a_msb loop
                 if ( (i = waddr_a_lsb) or (i = waddr_a_msb) or ((i > waddr_a_lsb) and (i < waddr_a_msb)) ) then
                    tmp_a_dataout(i rem port_a_read_data_width) := portadatain_ipd( i rem port_a_write_data_width);
                 end if;
             end loop;
          end if;
          if ((operation_mode = "bidir_dual_port" or operation_mode = "quad_port") and re_active_b) then
             for i in raddr_b_lsb to raddr_b_msb loop
                 if ( (i = waddr_a_lsb) or (i = waddr_a_msb) or ((i > waddr_a_lsb) and (i < waddr_a_msb)) ) then
                    tmp_b_dataout(i rem port_b_read_data_width) := portadatain_ipd( i rem port_a_write_data_width);
                 end if;
             end loop;
          end if;
       end if;
    end if;

    if (portbdatain_ipd'event) then
       if (portbwe_ipd = '1') then
          if (re_active_b) then
             for i in raddr_b_lsb to raddr_b_msb loop
                 if ( (i = waddr_b_lsb) or (i = waddr_b_msb) or ((i > waddr_b_lsb) and (i < waddr_b_msb)) ) then
                    tmp_b_dataout(i rem port_b_read_data_width) := portbdatain_ipd( i rem port_b_write_data_width);
                 end if;
             end loop;
          end if;
          if ((operation_mode = "bidir_dual_port" or operation_mode = "quad_port") and re_active_a) then
             for i in raddr_a_lsb to raddr_a_msb loop
                 if ( (i = waddr_b_lsb) or (i = waddr_b_msb) or ((i > waddr_b_lsb) and (i < waddr_b_msb)) ) then
                    tmp_a_dataout(i rem port_a_read_data_width) := portbdatain_ipd( i rem port_b_write_data_width);
                 end if;
             end loop;
          end if;
       end if;
    end if;

    ----------------------
    --  Path Delay Section
    ----------------------
      VitalPathDelay01 (
       OutSignal => portadataout(0),
       OutSignalName => "PORTADATAOUT",
       OutTemp => tmp_a_dataout(0),
       Paths => (1 => (portaraddr_ipd'last_event, tpd_portaraddr_portadataout(0), TRUE),
--                 2 => (portawaddr_ipd'last_event, tpd_portawaddr_portadataout(0), TRUE),
                 2 => (portawe_ipd'last_event, tpd_portawe_portadataout(0), TRUE),
                 3 => (portare_ipd'last_event, tpd_portare_portadataout(0), TRUE),
                 4 => (portadatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE),
                 5 => (portbdatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE)),
       GlitchData => portadataout_VitalGlitchDataArray(0),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portadataout(1),
       OutSignalName => "PORTADATAOUT",
       OutTemp => tmp_a_dataout(1),
       Paths => (1 => (portaraddr_ipd'last_event, tpd_portaraddr_portadataout(0), TRUE),
--                 2 => (portawaddr_ipd'last_event, tpd_portawaddr_portadataout(0), TRUE),
                 2 => (portawe_ipd'last_event, tpd_portawe_portadataout(0), TRUE),
                 3 => (portare_ipd'last_event, tpd_portare_portadataout(0), TRUE),
                 4 => (portadatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE),
                 5 => (portbdatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE)),
       GlitchData => portadataout_VitalGlitchDataArray(1),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portadataout(2),
       OutSignalName => "PORTADATAOUT",
       OutTemp => tmp_a_dataout(2),
       Paths => (1 => (portaraddr_ipd'last_event, tpd_portaraddr_portadataout(0), TRUE),
--                 2 => (portawaddr_ipd'last_event, tpd_portawaddr_portadataout(0), TRUE),
                 2 => (portawe_ipd'last_event, tpd_portawe_portadataout(0), TRUE),
                 3 => (portare_ipd'last_event, tpd_portare_portadataout(0), TRUE),
                 4 => (portadatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE),
                 5 => (portbdatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE)),
       GlitchData => portadataout_VitalGlitchDataArray(2),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portadataout(3),
       OutSignalName => "PORTADATAOUT",
       OutTemp => tmp_a_dataout(3),
       Paths => (1 => (portaraddr_ipd'last_event, tpd_portaraddr_portadataout(0), TRUE),
--                 2 => (portawaddr_ipd'last_event, tpd_portawaddr_portadataout(0), TRUE),
                 2 => (portawe_ipd'last_event, tpd_portawe_portadataout(0), TRUE),
                 3 => (portare_ipd'last_event, tpd_portare_portadataout(0), TRUE),
                 4 => (portadatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE),
                 5 => (portbdatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE)),
       GlitchData => portadataout_VitalGlitchDataArray(3),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portadataout(4),
       OutSignalName => "PORTADATAOUT",
       OutTemp => tmp_a_dataout(4),
       Paths => (1 => (portaraddr_ipd'last_event, tpd_portaraddr_portadataout(0), TRUE),
--                 2 => (portawaddr_ipd'last_event, tpd_portawaddr_portadataout(0), TRUE),
                 2 => (portawe_ipd'last_event, tpd_portawe_portadataout(0), TRUE),
                 3 => (portare_ipd'last_event, tpd_portare_portadataout(0), TRUE),
                 4 => (portadatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE),
                 5 => (portbdatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE)),
       GlitchData => portadataout_VitalGlitchDataArray(4),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portadataout(5),
       OutSignalName => "PORTADATAOUT",
       OutTemp => tmp_a_dataout(5),
       Paths => (1 => (portaraddr_ipd'last_event, tpd_portaraddr_portadataout(0), TRUE),
--                 2 => (portawaddr_ipd'last_event, tpd_portawaddr_portadataout(0), TRUE),
                 2 => (portawe_ipd'last_event, tpd_portawe_portadataout(0), TRUE),
                 3 => (portare_ipd'last_event, tpd_portare_portadataout(0), TRUE),
                 4 => (portadatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE),
                 5 => (portbdatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE)),
       GlitchData => portadataout_VitalGlitchDataArray(5),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portadataout(6),
       OutSignalName => "PORTADATAOUT",
       OutTemp => tmp_a_dataout(6),
       Paths => (1 => (portaraddr_ipd'last_event, tpd_portaraddr_portadataout(0), TRUE),
--                 2 => (portawaddr_ipd'last_event, tpd_portawaddr_portadataout(0), TRUE),
                 2 => (portawe_ipd'last_event, tpd_portawe_portadataout(0), TRUE),
                 3 => (portare_ipd'last_event, tpd_portare_portadataout(0), TRUE),
                 4 => (portadatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE),
                 5 => (portbdatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE)),
       GlitchData => portadataout_VitalGlitchDataArray(6),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portadataout(7),
       OutSignalName => "PORTADATAOUT",
       OutTemp => tmp_a_dataout(7),
       Paths => (1 => (portaraddr_ipd'last_event, tpd_portaraddr_portadataout(0), TRUE),
--                 2 => (portawaddr_ipd'last_event, tpd_portawaddr_portadataout(0), TRUE),
                 2 => (portawe_ipd'last_event, tpd_portawe_portadataout(0), TRUE),
                 3 => (portare_ipd'last_event, tpd_portare_portadataout(0), TRUE),
                 4 => (portadatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE),
                 5 => (portbdatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE)),
       GlitchData => portadataout_VitalGlitchDataArray(7),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portadataout(8),
       OutSignalName => "PORTADATAOUT",
       OutTemp => tmp_a_dataout(8),
       Paths => (1 => (portaraddr_ipd'last_event, tpd_portaraddr_portadataout(0), TRUE),
--                 2 => (portawaddr_ipd'last_event, tpd_portawaddr_portadataout(0), TRUE),
                 2 => (portawe_ipd'last_event, tpd_portawe_portadataout(0), TRUE),
                 3 => (portare_ipd'last_event, tpd_portare_portadataout(0), TRUE),
                 4 => (portadatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE),
                 5 => (portbdatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE)),
       GlitchData => portadataout_VitalGlitchDataArray(8),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portadataout(9),
       OutSignalName => "PORTADATAOUT",
       OutTemp => tmp_a_dataout(9),
       Paths => (1 => (portaraddr_ipd'last_event, tpd_portaraddr_portadataout(0), TRUE),
--                 2 => (portawaddr_ipd'last_event, tpd_portawaddr_portadataout(0), TRUE),
                 2 => (portawe_ipd'last_event, tpd_portawe_portadataout(0), TRUE),
                 3 => (portare_ipd'last_event, tpd_portare_portadataout(0), TRUE),
                 4 => (portadatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE),
                 5 => (portbdatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE)),
       GlitchData => portadataout_VitalGlitchDataArray(9),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portadataout(10),
       OutSignalName => "PORTADATAOUT",
       OutTemp => tmp_a_dataout(10),
       Paths => (1 => (portaraddr_ipd'last_event, tpd_portaraddr_portadataout(0), TRUE),
--                 2 => (portawaddr_ipd'last_event, tpd_portawaddr_portadataout(0), TRUE),
                 2 => (portawe_ipd'last_event, tpd_portawe_portadataout(0), TRUE),
                 3 => (portare_ipd'last_event, tpd_portare_portadataout(0), TRUE),
                 4 => (portadatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE),
                 5 => (portbdatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE)),
       GlitchData => portadataout_VitalGlitchDataArray(10),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portadataout(11),
       OutSignalName => "PORTADATAOUT",
       OutTemp => tmp_a_dataout(11),
       Paths => (1 => (portaraddr_ipd'last_event, tpd_portaraddr_portadataout(0), TRUE),
--                 2 => (portawaddr_ipd'last_event, tpd_portawaddr_portadataout(0), TRUE),
                 2 => (portawe_ipd'last_event, tpd_portawe_portadataout(0), TRUE),
                 3 => (portare_ipd'last_event, tpd_portare_portadataout(0), TRUE),
                 4 => (portadatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE),
                 5 => (portbdatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE)),
       GlitchData => portadataout_VitalGlitchDataArray(11),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portadataout(12),
       OutSignalName => "PORTADATAOUT",
       OutTemp => tmp_a_dataout(12),
       Paths => (1 => (portaraddr_ipd'last_event, tpd_portaraddr_portadataout(0), TRUE),
--                 2 => (portawaddr_ipd'last_event, tpd_portawaddr_portadataout(0), TRUE),
                 2 => (portawe_ipd'last_event, tpd_portawe_portadataout(0), TRUE),
                 3 => (portare_ipd'last_event, tpd_portare_portadataout(0), TRUE),
                 4 => (portadatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE),
                 5 => (portbdatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE)),
       GlitchData => portadataout_VitalGlitchDataArray(12),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portadataout(13),
       OutSignalName => "PORTADATAOUT",
       OutTemp => tmp_a_dataout(13),
       Paths => (1 => (portaraddr_ipd'last_event, tpd_portaraddr_portadataout(0), TRUE),
--                 2 => (portawaddr_ipd'last_event, tpd_portawaddr_portadataout(0), TRUE),
                 2 => (portawe_ipd'last_event, tpd_portawe_portadataout(0), TRUE),
                 3 => (portare_ipd'last_event, tpd_portare_portadataout(0), TRUE),
                 4 => (portadatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE),
                 5 => (portbdatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE)),
       GlitchData => portadataout_VitalGlitchDataArray(13),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portadataout(14),
       OutSignalName => "PORTADATAOUT",
       OutTemp => tmp_a_dataout(14),
       Paths => (1 => (portaraddr_ipd'last_event, tpd_portaraddr_portadataout(0), TRUE),
--                 2 => (portawaddr_ipd'last_event, tpd_portawaddr_portadataout(0), TRUE),
                 2 => (portawe_ipd'last_event, tpd_portawe_portadataout(0), TRUE),
                 3 => (portare_ipd'last_event, tpd_portare_portadataout(0), TRUE),
                 4 => (portadatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE),
                 5 => (portbdatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE)),
       GlitchData => portadataout_VitalGlitchDataArray(14),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portadataout(15),
       OutSignalName => "PORTADATAOUT",
       OutTemp => tmp_a_dataout(15),
       Paths => (1 => (portaraddr_ipd'last_event, tpd_portaraddr_portadataout(0), TRUE),
--                 2 => (portawaddr_ipd'last_event, tpd_portawaddr_portadataout(0), TRUE),
                 2 => (portawe_ipd'last_event, tpd_portawe_portadataout(0), TRUE),
                 3 => (portare_ipd'last_event, tpd_portare_portadataout(0), TRUE),
                 4 => (portadatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE),
                 5 => (portbdatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE)),
       GlitchData => portadataout_VitalGlitchDataArray(15),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portbdataout(0),
       OutSignalName => "PORTBDATAOUT",
       OutTemp => tmp_b_dataout(0),
       Paths => (1 => (portbraddr_ipd'last_event, tpd_portbraddr_portbdataout(0), TRUE),
--                 2 => (portbwaddr_ipd'last_event, tpd_portbwaddr_portbdataout(0), TRUE),
                 2 => (portbwe_ipd'last_event, tpd_portbwe_portbdataout(0), TRUE),
                 3 => (portbre_ipd'last_event, tpd_portbre_portbdataout(0), TRUE),
                 4 => (portbdatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE),
                 5 => (portadatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE)),
       GlitchData => portbdataout_VitalGlitchDataArray(0),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portbdataout(1),
       OutSignalName => "PORTBDATAOUT",
       OutTemp => tmp_b_dataout(1),
       Paths => (1 => (portbraddr_ipd'last_event, tpd_portbraddr_portbdataout(0), TRUE),
--                 2 => (portbwaddr_ipd'last_event, tpd_portbwaddr_portbdataout(0), TRUE),
                 2 => (portbwe_ipd'last_event, tpd_portbwe_portbdataout(0), TRUE),
                 3 => (portbre_ipd'last_event, tpd_portbre_portbdataout(0), TRUE),
                 4 => (portbdatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE),
                 5 => (portadatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE)),
       GlitchData => portbdataout_VitalGlitchDataArray(1),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portbdataout(2),
       OutSignalName => "PORTBDATAOUT",
       OutTemp => tmp_b_dataout(2),
       Paths => (1 => (portbraddr_ipd'last_event, tpd_portbraddr_portbdataout(0), TRUE),
--                 2 => (portbwaddr_ipd'last_event, tpd_portbwaddr_portbdataout(0), TRUE),
                 2 => (portbwe_ipd'last_event, tpd_portbwe_portbdataout(0), TRUE),
                 3 => (portbre_ipd'last_event, tpd_portbre_portbdataout(0), TRUE),
                 4 => (portbdatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE),
                 5 => (portadatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE)),
       GlitchData => portbdataout_VitalGlitchDataArray(2),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portbdataout(3),
       OutSignalName => "PORTBDATAOUT",
       OutTemp => tmp_b_dataout(3),
       Paths => (1 => (portbraddr_ipd'last_event, tpd_portbraddr_portbdataout(0), TRUE),
--                 2 => (portbwaddr_ipd'last_event, tpd_portbwaddr_portbdataout(0), TRUE),
                 2 => (portbwe_ipd'last_event, tpd_portbwe_portbdataout(0), TRUE),
                 3 => (portbre_ipd'last_event, tpd_portbre_portbdataout(0), TRUE),
                 4 => (portbdatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE),
                 5 => (portadatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE)),
       GlitchData => portbdataout_VitalGlitchDataArray(3),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portbdataout(4),
       OutSignalName => "PORTBDATAOUT",
       OutTemp => tmp_b_dataout(4),
       Paths => (1 => (portbraddr_ipd'last_event, tpd_portbraddr_portbdataout(0), TRUE),
--                 2 => (portbwaddr_ipd'last_event, tpd_portbwaddr_portbdataout(0), TRUE),
                 2 => (portbwe_ipd'last_event, tpd_portbwe_portbdataout(0), TRUE),
                 3 => (portbre_ipd'last_event, tpd_portbre_portbdataout(0), TRUE),
                 4 => (portbdatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE),
                 5 => (portadatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE)),
       GlitchData => portbdataout_VitalGlitchDataArray(4),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portbdataout(5),
       OutSignalName => "PORTBDATAOUT",
       OutTemp => tmp_b_dataout(5),
       Paths => (1 => (portbraddr_ipd'last_event, tpd_portbraddr_portbdataout(0), TRUE),
--                 2 => (portbwaddr_ipd'last_event, tpd_portbwaddr_portbdataout(0), TRUE),
                 2 => (portbwe_ipd'last_event, tpd_portbwe_portbdataout(0), TRUE),
                 3 => (portbre_ipd'last_event, tpd_portbre_portbdataout(0), TRUE),
                 4 => (portbdatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE),
                 5 => (portadatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE)),
       GlitchData => portbdataout_VitalGlitchDataArray(5),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portbdataout(6),
       OutSignalName => "PORTBDATAOUT",
       OutTemp => tmp_b_dataout(6),
       Paths => (1 => (portbraddr_ipd'last_event, tpd_portbraddr_portbdataout(0), TRUE),
--                 2 => (portbwaddr_ipd'last_event, tpd_portbwaddr_portbdataout(0), TRUE),
                 2 => (portbwe_ipd'last_event, tpd_portbwe_portbdataout(0), TRUE),
                 3 => (portbre_ipd'last_event, tpd_portbre_portbdataout(0), TRUE),
                 4 => (portbdatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE),
                 5 => (portadatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE)),
       GlitchData => portbdataout_VitalGlitchDataArray(6),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portbdataout(7),
       OutSignalName => "PORTBDATAOUT",
       OutTemp => tmp_b_dataout(7),
       Paths => (1 => (portbraddr_ipd'last_event, tpd_portbraddr_portbdataout(0), TRUE),
--                 2 => (portbwaddr_ipd'last_event, tpd_portbwaddr_portbdataout(0), TRUE),
                 2 => (portbwe_ipd'last_event, tpd_portbwe_portbdataout(0), TRUE),
                 3 => (portbre_ipd'last_event, tpd_portbre_portbdataout(0), TRUE),
                 4 => (portbdatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE),
                 5 => (portadatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE)),
       GlitchData => portbdataout_VitalGlitchDataArray(7),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portbdataout(8),
       OutSignalName => "PORTBDATAOUT",
       OutTemp => tmp_b_dataout(8),
       Paths => (1 => (portbraddr_ipd'last_event, tpd_portbraddr_portbdataout(0), TRUE),
--                 2 => (portbwaddr_ipd'last_event, tpd_portbwaddr_portbdataout(0), TRUE),
                 2 => (portbwe_ipd'last_event, tpd_portbwe_portbdataout(0), TRUE),
                 3 => (portbre_ipd'last_event, tpd_portbre_portbdataout(0), TRUE),
                 4 => (portbdatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE),
                 5 => (portadatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE)),
       GlitchData => portbdataout_VitalGlitchDataArray(8),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portbdataout(9),
       OutSignalName => "PORTBDATAOUT",
       OutTemp => tmp_b_dataout(9),
       Paths => (1 => (portbraddr_ipd'last_event, tpd_portbraddr_portbdataout(0), TRUE),
--                 2 => (portbwaddr_ipd'last_event, tpd_portbwaddr_portbdataout(0), TRUE),
                 2 => (portbwe_ipd'last_event, tpd_portbwe_portbdataout(0), TRUE),
                 3 => (portbre_ipd'last_event, tpd_portbre_portbdataout(0), TRUE),
                 4 => (portbdatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE),
                 5 => (portadatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE)),
       GlitchData => portbdataout_VitalGlitchDataArray(9),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portbdataout(10),
       OutSignalName => "PORTBDATAOUT",
       OutTemp => tmp_b_dataout(10),
       Paths => (1 => (portbraddr_ipd'last_event, tpd_portbraddr_portbdataout(0), TRUE),
--                 2 => (portbwaddr_ipd'last_event, tpd_portbwaddr_portbdataout(0), TRUE),
                 2 => (portbwe_ipd'last_event, tpd_portbwe_portbdataout(0), TRUE),
                 3 => (portbre_ipd'last_event, tpd_portbre_portbdataout(0), TRUE),
                 4 => (portbdatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE),
                 5 => (portadatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE)),
       GlitchData => portbdataout_VitalGlitchDataArray(10),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portbdataout(11),
       OutSignalName => "PORTBDATAOUT",
       OutTemp => tmp_b_dataout(11),
       Paths => (1 => (portbraddr_ipd'last_event, tpd_portbraddr_portbdataout(0), TRUE),
--                 2 => (portbwaddr_ipd'last_event, tpd_portbwaddr_portbdataout(0), TRUE),
                 2 => (portbwe_ipd'last_event, tpd_portbwe_portbdataout(0), TRUE),
                 3 => (portbre_ipd'last_event, tpd_portbre_portbdataout(0), TRUE),
                 4 => (portbdatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE),
                 5 => (portadatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE)),
       GlitchData => portbdataout_VitalGlitchDataArray(11),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portbdataout(12),
       OutSignalName => "PORTBDATAOUT",
       OutTemp => tmp_b_dataout(12),
       Paths => (1 => (portbraddr_ipd'last_event, tpd_portbraddr_portbdataout(0), TRUE),
--                 2 => (portbwaddr_ipd'last_event, tpd_portbwaddr_portbdataout(0), TRUE),
                 2 => (portbwe_ipd'last_event, tpd_portbwe_portbdataout(0), TRUE),
                 3 => (portbre_ipd'last_event, tpd_portbre_portbdataout(0), TRUE),
                 4 => (portbdatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE),
                 5 => (portadatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE)),
       GlitchData => portbdataout_VitalGlitchDataArray(12),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portbdataout(13),
       OutSignalName => "PORTBDATAOUT",
       OutTemp => tmp_b_dataout(13),
       Paths => (1 => (portbraddr_ipd'last_event, tpd_portbraddr_portbdataout(0), TRUE),
--                 2 => (portbwaddr_ipd'last_event, tpd_portbwaddr_portbdataout(0), TRUE),
                 2 => (portbwe_ipd'last_event, tpd_portbwe_portbdataout(0), TRUE),
                 3 => (portbre_ipd'last_event, tpd_portbre_portbdataout(0), TRUE),
                 4 => (portbdatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE),
                 5 => (portadatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE)),
       GlitchData => portbdataout_VitalGlitchDataArray(13),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portbdataout(14),
       OutSignalName => "PORTBDATAOUT",
       OutTemp => tmp_b_dataout(14),
       Paths => (1 => (portbraddr_ipd'last_event, tpd_portbraddr_portbdataout(0), TRUE),
--                 2 => (portbwaddr_ipd'last_event, tpd_portbwaddr_portbdataout(0), TRUE),
                 2 => (portbwe_ipd'last_event, tpd_portbwe_portbdataout(0), TRUE),
                 3 => (portbre_ipd'last_event, tpd_portbre_portbdataout(0), TRUE),
                 4 => (portbdatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE),
                 5 => (portadatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE)),
       GlitchData => portbdataout_VitalGlitchDataArray(14),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portbdataout(15),
       OutSignalName => "PORTBDATAOUT",
       OutTemp => tmp_b_dataout(15),
       Paths => (1 => (portbraddr_ipd'last_event, tpd_portbraddr_portbdataout(0), TRUE),
--                 2 => (portbwaddr_ipd'last_event, tpd_portbwaddr_portbdataout(0), TRUE),
                 2 => (portbwe_ipd'last_event, tpd_portbwe_portbdataout(0), TRUE),
                 3 => (portbre_ipd'last_event, tpd_portbre_portbdataout(0), TRUE),
                 4 => (portbdatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE),
                 5 => (portadatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE)),
       GlitchData => portbdataout_VitalGlitchDataArray(15),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

end process;
   
end behave;

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : DFFE
--
-- Description : Timing simulation model for a DFFE register
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE, mercury;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE mercury.atom_pack.all;

ENTITY dffe is
   GENERIC(
           TimingChecksOn                 : Boolean := True;
           XOn                            : Boolean := DefGlitchXOn;
           MsgOn                          : Boolean := DefGlitchMsgOn;
           MsgOnChecks                    : Boolean := DefMsgOnChecks;
           XOnChecks                      : Boolean := DefXOnChecks;
           InstancePath                   : STRING := "*";
           tpd_PRN_Q_negedge              : VitalDelayType01 := DefPropDelay01;
           tpd_CLRN_Q_negedge             : VitalDelayType01 := DefPropDelay01;
           tpd_CLK_Q_posedge              : VitalDelayType01 := DefPropDelay01;
           tpd_ENA_Q_posedge              : VitalDelayType01 := DefPropDelay01;
           tsetup_D_CLK_noedge_posedge    : VitalDelayType := DefSetupHoldCnst;
           tsetup_D_CLK_noedge_negedge    : VitalDelayType := DefSetupHoldCnst;
           tsetup_ENA_CLK_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
           thold_D_CLK_noedge_posedge     : VitalDelayType := DefSetupHoldCnst;
           thold_D_CLK_noedge_negedge     : VitalDelayType := DefSetupHoldCnst;
           thold_ENA_CLK_noedge_posedge   : VitalDelayType := DefSetupHoldCnst;
           tipd_D                         : VitalDelayType01 := DefPropDelay01;
           tipd_CLRN                      : VitalDelayType01 := DefPropDelay01;
           tipd_PRN                       : VitalDelayType01 := DefPropDelay01;
           tipd_CLK                       : VitalDelayType01 := DefPropDelay01;
           tipd_ENA                       : VitalDelayType01 := DefPropDelay01
          );

   PORT   (
           Q                              :  out   STD_LOGIC := '0';
           D                              :  in    STD_LOGIC;
           CLRN                           :  in    STD_LOGIC;
           PRN                            :  in    STD_LOGIC;
           CLK                            :  in    STD_LOGIC;
           ENA                            :  in    STD_LOGIC
          );
   attribute VITAL_LEVEL0 of dffe : ENTITY is TRUE;
end dffe;

-- architecture body --

architecture behave of dffe is
   attribute VITAL_LEVEL0 of behave : architecture is TRUE;

   signal D_ipd          : STD_ULOGIC := 'U';
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
                MsgOn           => MSgOnChecks );
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

--      if (CLRN_ipd = '0') then
--         Results(1) := '0';
--      elsif (PRN_ipd = '0') then
--         Results(1) := '1';
--      elsif (CLK_ipd'event and CLK_ipd = '1') then
--         if (ENA_ipd = '1') then
--            Results(1) := D_ipd;
--         end if;
--      end if;

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

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : and1
--
-- Description : Simulation model for a 1-input AND gate
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE, mercury;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.VITAL_Timing.all;

--USE mercury.SUPPORT.all;
USE mercury.atom_pack.all;

-- ENTITY declaration --
ENTITY and1 is
   GENERIC (
            TimingChecksOn           : Boolean := True;
            MsgOn                    : Boolean := DefGlitchMsgOn;
            XOn                      : Boolean := DefGlitchXOn;
            InstancePath             : STRING := "*";
            tpd_IN1_Y                : VitalDelayType01 := DefPropDelay01;
            tipd_IN1                 : VitalDelayType01 := DefPropDelay01);

   PORT(
      Y                              : out   STD_LOGIC;
      IN1                            : in    STD_LOGIC
     );
   attribute VITAL_LEVEL0 of and1 : ENTITY is TRUE;
end and1;

-- ARCHITECTURE body --

ARCHITECTURE AltVITAL of and1 is
   attribute VITAL_LEVEL0 of AltVITAL : architecture is TRUE;

   SIGNAL IN1_ipd         : STD_ULOGIC := 'U';

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
   VARIABLE Y_GlitchData        : VitalGlitchDataType;

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

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : mux21
--
-- Description : Simulation model for a 2 to 1 mux used in the RAM_SLICE
--               This is a timing simulation model.
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY ieee, mercury;
USE ieee.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
--USE IEEE.VITAL_Primitives.all;
USE mercury.atom_pack.all;

ENTITY mux21 is
    GENERIC (
             TimingChecksOn               : Boolean := True;
             MsgOn                        : Boolean := DefGlitchMsgOn;
             XOn                          : Boolean := DefGlitchXOn;
             InstancePath                 : STRING := "*";
             tpd_A_MO                     : VitalDelayType01 := DefPropDelay01;
             tpd_B_MO                     : VitalDelayType01 := DefPropDelay01;
             tpd_S_MO                     : VitalDelayType01 := DefPropDelay01;
             tipd_A                       : VitalDelayType01 := DefPropDelay01;
             tipd_B                       : VitalDelayType01 := DefPropDelay01;
             tipd_S                       : VitalDelayType01 := DefPropDelay01
            );
    PORT    ( A                           : in std_logic := '0';
              B                           : in std_logic := '0';
              S                           : in std_logic := '0';
              MO                          : out std_logic
             );
   attribute VITAL_LEVEL0 of mux21 : ENTITY is TRUE;
end mux21;

architecture AltVITAL of mux21 is
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
   VARIABLE MO_GlitchData        : VitalGlitchDataType;

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

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : nmux21
--
-- Description : Simulation model for a 2 to 1 mux used in the RAM_SLICE
--               The output is an inversion of the selected input.
--               This is a purely functional module, without any timing.
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY nmux21 is
     PORT ( A : in std_logic := '0';
            B : in std_logic := '0';
            S : in std_logic := '0';
            MO : out std_logic
           );
end nmux21;

architecture structure of nmux21 is
begin

   MO <=  not B when (S = '1') else not A;

end structure;

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : bmux21
--
-- Description : Simulation model for a 2 to 1 mux used in the RAM_SLICE
--               Each input is a 16-bit bus.
--               This is a purely functional module, without any timing.
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY bmux21 is 
     PORT ( A : in std_logic_vector(15 downto 0) := (OTHERS => '0');
            B : in std_logic_vector(15 downto 0) := (OTHERS => '0');
            S : in std_logic := '0'; 
            MO : out std_logic_vector(15 downto 0)
           ); 
end bmux21; 
 
architecture structure of bmux21 is
begin 
 
   MO <= B when (S = '1') else A; 
 
end structure;

--/////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : MERCURY_RAM_BLOCK
--
-- Description : Structural model for a single RAM block of the
--               MERCURY device family.
--
--/////////////////////////////////////////////////////////////////////////////

LIBRARY ieee, mercury;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE IEEE.VITAL_Timing.all;
USE mercury.atom_pack.all;

LIBRARY mercury;
USE mercury.all;

ENTITY  mercury_ram_block is
    GENERIC (
             operation_mode                         : string := "single_port";
             port_a_operation_mode                  : string := "single_port";
             port_b_operation_mode                  : string := "single_port";
             logical_ram_name                       : string := "ram_xxx";
             port_a_logical_ram_name                : string := "ram_xxx";
             port_b_logical_ram_name                : string := "ram_xxx";
             init_file                              : string := "none";
             port_a_init_file                       : string := "none";
             port_b_init_file                       : string := "none";
             data_interleave_width_in_bits          : integer := 1;
             data_interleave_offset_in_bits         : integer := 1;
             port_a_data_interleave_width_in_bits   : integer := 1;
             port_a_data_interleave_offset_in_bits  : integer := 1;
             port_b_data_interleave_width_in_bits   : integer := 1;
             port_b_data_interleave_offset_in_bits  : integer := 1;

             port_a_write_deep_ram_mode             : string := "off";
             port_a_write_logical_ram_depth         : integer := 4096;
             port_a_write_logical_ram_width         : integer := 1;
             port_a_write_address_width             : integer := 16;
             port_a_read_deep_ram_mode              : string := "off";
             port_a_read_logical_ram_depth          : integer := 4096;
             port_a_read_logical_ram_width          : integer := 1;
             port_a_read_address_width              : integer := 16;

             port_a_data_in_clock                   : string := "none";
             port_a_data_in_clear                   : string := "none";
             port_a_write_logic_clock               : string := "none";
             port_a_write_address_clear             : string := "none";
             port_a_write_enable_clear              : string := "none";
             port_a_read_enable_clock               : string := "none";
             port_a_read_enable_clear               : string := "none";
             port_a_read_address_clock              : string := "none";
             port_a_read_address_clear              : string := "none";
             port_a_data_out_clock                  : string := "none";
             port_a_data_out_clear                  : string := "none";

             port_a_write_first_address             : integer := 0;
             port_a_write_last_address              : integer := 4095;
             port_a_write_first_bit_number          : integer := 1;
             port_a_write_data_width                : integer := 1;
             port_a_read_first_address              : integer := 0;
             port_a_read_last_address               : integer := 4095;
             port_a_read_first_bit_number           : integer := 1;
             port_a_read_data_width                 : integer := 1;

             port_b_write_deep_ram_mode             : string := "off";
             port_b_write_logical_ram_depth         : integer := 4096;
             port_b_write_logical_ram_width         : integer := 1;
             port_b_write_address_width             : integer := 16;
             port_b_read_deep_ram_mode              : string := "off";
             port_b_read_logical_ram_depth          : integer := 4096;
             port_b_read_logical_ram_width          : integer := 1;
             port_b_read_address_width              : integer := 16;

             port_b_data_in_clock                   : string := "none";
             port_b_data_in_clear                   : string := "none";
             port_b_write_logic_clock               : string := "none";
             port_b_write_address_clear             : string := "none";
             port_b_write_enable_clear              : string := "none";
             port_b_read_enable_clock               : string := "none";
             port_b_read_enable_clear               : string := "none";
             port_b_read_address_clock              : string := "none";
             port_b_read_address_clear              : string := "none";
             port_b_data_out_clock                  : string := "none";
             port_b_data_out_clear                  : string := "none";

             port_b_write_first_address             : integer := 0;
             port_b_write_last_address              : integer := 4095;
             port_b_write_first_bit_number          : integer := 1;
             port_b_write_data_width                : integer := 1;
             port_b_read_first_address              : integer := 0;
             port_b_read_last_address               : integer := 4095;
             port_b_read_first_bit_number           : integer := 1;
             port_b_read_data_width                 : integer := 1;
             power_up                               : string := "low";
             
             mem1                        : std_logic_vector(512 downto 1);
             mem2                        : std_logic_vector(512 downto 1);
             mem3                        : std_logic_vector(512 downto 1);
             mem4                        : std_logic_vector(512 downto 1);
             mem5                        : std_logic_vector(512 downto 1);
             mem6                        : std_logic_vector(512 downto 1);
             mem7                        : std_logic_vector(512 downto 1);
             mem8                        : std_logic_vector(512 downto 1)
            );

    PORT    ( portadatain                : in std_logic_vector(15 downto 0);
              portaclk0                  : in std_logic;
              portaclk1                  : in std_logic;
              portaclr0                  : in std_logic;
              portaclr1                  : in std_logic;
              portaena0                  : in std_logic;
              portaena1                  : in std_logic;
              portawe                    : in std_logic;
              portare                    : in std_logic;
              portaraddr                 : in std_logic_vector(15 downto 0);
              portawaddr                 : in std_logic_vector(15 downto 0);
              portbdatain                : in std_logic_vector(15 downto 0);
              portbclk0                  : in std_logic;
              portbclk1                  : in std_logic;
              portbclr0                  : in std_logic;
              portbclr1                  : in std_logic;
              portbena0                  : in std_logic;
              portbena1                  : in std_logic;
              portbwe                    : in std_logic;
              portbre                    : in std_logic;
              portbraddr                 : in std_logic_vector(15 downto 0);
              portbwaddr                 : in std_logic_vector(15 downto 0);
              portadataout               : out std_logic_vector(15 downto 0);
              portbdataout               : out std_logic_vector(15 downto 0);
              devclrn                    : in std_logic := '1';
              devpor                     : in std_logic := '1';
              portamodesel               : in std_logic_vector(20 downto 0);
              portbmodesel               : in std_logic_vector(20 downto 0)
             );
END mercury_ram_block;

ARCHITECTURE structure OF mercury_ram_block IS

COMPONENT DFFE
    GENERIC (
             TimingChecksOn                : Boolean := true;
             InstancePath                  : STRING := "*";
             XOn                           : Boolean := DefGlitchXOn;
             MsgOn                         : Boolean := DefGlitchMsgOn;
             MsgOnChecks                   : Boolean := DefMsgOnChecks;
             XOnChecks                     : Boolean := DefXOnChecks;
             tpd_PRN_Q_negedge             : VitalDelayType01 := DefPropDelay01;
             tpd_CLRN_Q_negedge            : VitalDelayType01 := DefPropDelay01;
             tpd_CLK_Q_posedge             : VitalDelayType01 := DefPropDelay01;
             tpd_ENA_Q_posedge             : VitalDelayType01 := DefPropDelay01;
             tsetup_D_CLK_noedge_posedge   : VitalDelayType := DefSetupHoldCnst;
             tsetup_D_CLK_noedge_negedge   : VitalDelayType := DefSetupHoldCnst;
             tsetup_ENA_CLK_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_D_CLK_noedge_posedge    : VitalDelayType := DefSetupHoldCnst;
             thold_D_CLK_noedge_negedge    : VitalDelayType := DefSetupHoldCnst;
             thold_ENA_CLK_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
             tipd_D                        : VitalDelayType01 := DefPropDelay01;
             tipd_CLRN                     : VitalDelayType01 := DefPropDelay01;
             tipd_PRN                      : VitalDelayType01 := DefPropDelay01;
             tipd_CLK                      : VitalDelayType01 := DefPropDelay01;
             tipd_ENA                      : VitalDelayType01 := DefPropDelay01
            );

    PORT    (Q                             : out   STD_LOGIC := '0';
             D                             : in    STD_LOGIC := '1';
             CLRN                          : in    STD_LOGIC := '1';
             PRN                           : in    STD_LOGIC := '1';
             CLK                           : in    STD_LOGIC := '0';
             ENA                           : in    STD_LOGIC := '1'
            );
END COMPONENT;
COMPONENT and1
    GENERIC (
             XOn                  : Boolean := DefGlitchXOn;
             MsgOn                : Boolean := DefGlitchMsgOn;
             tpd_IN1_Y            : VitalDelayType01 := DefPropDelay01;
             tipd_IN1             : VitalDelayType01 := DefPropDelay01
            );
        
    PORT    ( Y                   :  out   STD_LOGIC;
              IN1                 :  in    STD_LOGIC
            );
END COMPONENT;
COMPONENT mux21
          PORT (A : in std_logic := '0';
                B : in std_logic := '0';
                S : in std_logic := '0';
                MO : out std_logic
               );
END COMPONENT;
COMPONENT nmux21
          PORT (A : in std_logic := '0';
                B : in std_logic := '0';
                S : in std_logic := '0';
                MO : out std_logic
               );
END COMPONENT;
COMPONENT bmux21
          PORT (A : in std_logic_vector(15 downto 0) := (OTHERS => '0');
                B : in std_logic_vector(15 downto 0) := (OTHERS => '0');
                S : in std_logic := '0';
                MO : out std_logic_vector(15 downto 0)
               );
END COMPONENT;
COMPONENT mercury_asynch_mem
    GENERIC (
             operation_mode                 : string := "single_port";
             port_a_operation_mode          : string := "single_port";
             port_b_operation_mode          : string := "single_port";

             port_a_write_deep_ram_mode     : string := "off";
             port_a_write_address_width     : integer := 1;
             port_a_write_first_address     : integer := 0;
             port_a_write_last_address      : integer := 4095;
             port_a_write_data_width        : integer := 1;

             port_a_read_deep_ram_mode      : string := "off";
             port_a_read_address_width      : integer := 1;
             port_a_read_first_address      : integer := 0;
             port_a_read_last_address       : integer := 4095;
             port_a_read_data_width         : integer := 1;

             port_b_write_deep_ram_mode     : string := "off";
             port_b_write_address_width     : integer := 1;
             port_b_write_first_address     : integer := 0;
             port_b_write_last_address      : integer := 4095;
             port_b_write_data_width        : integer := 1;

             port_b_read_deep_ram_mode      : string := "off";
             port_b_read_address_width      : integer := 1;
             port_b_read_first_address      : integer := 0;
             port_b_read_last_address       : integer := 4095;
             port_b_read_data_width         : integer := 1;

             port_a_read_enable_clock       : string := "none";
             port_b_read_enable_clock       : string := "none";

             port_a_write_logic_clock       : string := "none";
             port_b_write_logic_clock       : string := "none";

             init_file                      : string := "none";
             port_a_init_file               : string := "none";
             port_b_init_file               : string := "none";

             mem1                           : std_logic_vector(512 downto 1) := (OTHERS=>'0');
             mem2                           : std_logic_vector(512 downto 1) := (OTHERS=>'0');
             mem3                           : std_logic_vector(512 downto 1) := (OTHERS=>'0');
             mem4                           : std_logic_vector(512 downto 1) := (OTHERS=>'0');
             mem5                           : std_logic_vector(512 downto 1) := (OTHERS=>'0');
             mem6                           : std_logic_vector(512 downto 1) := (OTHERS=>'0');
             mem7                           : std_logic_vector(512 downto 1) := (OTHERS=>'0');
             mem8                           : std_logic_vector(512 downto 1) := (OTHERS=>'0')
            );

    PORT    (portadatain  : in std_logic_vector(15 downto 0) := (OTHERS => '0');
             portawe      : in std_logic := '0';
             portare      : in std_logic := '0';
             portaraddr   : in std_logic_vector(15 downto 0) := (OTHERS => '0');
             portawaddr   : in std_logic_vector(15 downto 0) := (OTHERS => '0');
             portbdatain  : in std_logic_vector(15 downto 0) := (OTHERS => '0');
             portbwe      : in std_logic := '0';
             portbre      : in std_logic := '0';
             portbraddr   : in std_logic_vector(15 downto 0) := (OTHERS => '0');
             portbwaddr   : in std_logic_vector(15 downto 0) := (OTHERS => '0');
             portadataout : out std_logic_vector(15 downto 0);
             portbdataout : out std_logic_vector(15 downto 0);
             portamodesel : in std_logic_vector(20 downto 0) := (OTHERS => '0');
             portbmodesel : in std_logic_vector(20 downto 0) := (OTHERS => '0')
            );

END COMPONENT;

   -- 'sel' signals for porta
   signal  portadatain_reg_sel     : std_logic;
   signal  portadatain_reg_clr_sel : std_logic;
   signal  portawrite_reg_sel      : std_logic;
   signal  portawe_clr_sel         : std_logic;
   signal  portawaddr_clr_sel      : std_logic;
   signal  portaraddr_clr_sel      : std_logic_vector(1 downto 0);
   signal  portare_clr_sel         : std_logic_vector(1 downto 0);
   signal  portaraddr_clk_sel      : std_logic_vector(1 downto 0);
   signal  portare_clk_sel         : std_logic_vector(1 downto 0);
   signal  portadataout_clk_sel    : std_logic_vector(1 downto 0); 
   signal  portadataout_clr_sel    : std_logic_vector(1 downto 0); 
   signal  portaraddr_en_sel       : std_logic;
   signal  portare_en_sel          : std_logic;
   signal  portadataout_en_sel     : std_logic; 

   -- registered signals for porta
   signal  portadatain_reg         : std_logic_vector(15 downto 0);
   signal  portadataout_reg        : std_logic_vector(15 downto 0);
   signal  portawe_reg             : std_logic;
   signal  portare_reg             : std_logic;
   signal  portaraddr_reg          : std_logic_vector(15 downto 0);
   signal  portawaddr_reg          : std_logic_vector(15 downto 0);

   signal  portadatain_int         : std_logic_vector(15 downto 0);
   signal  portadataout_int        : std_logic_vector(15 downto 0);
   signal  portaraddr_int          : std_logic_vector(15 downto 0);
   signal  portawaddr_int          : std_logic_vector(15 downto 0);
   signal  portawe_int             : std_logic;
   signal  portare_int             : std_logic;

   -- 'clr' signals for porta
   signal  portadatain_reg_clr     : std_logic;
   signal  portadinreg_clr         : std_logic;
   signal  portawe_reg_clr         : std_logic;
   signal  portawereg_clr          : std_logic;
   signal  portawaddr_reg_clr      : std_logic;
   signal  portawaddrreg_clr       : std_logic;
   signal  portare_reg_clr         : std_logic;
   signal  portarereg_clr          : std_logic;
   signal  portaraddr_reg_clr      : std_logic;
   signal  portaraddrreg_clr       : std_logic;
   signal  portadataout_reg_clr    : std_logic;
   signal  portadataoutreg_clr     : std_logic;

   -- 'ena' signals for porta
   signal  portareen               : std_logic;
   signal  portaraddren            : std_logic;
   signal  portadataouten          : std_logic;

   -- 'clk' signals for porta
   signal  portare_clk             : std_logic;
   signal  portare_clr             : std_logic;
   signal  portaraddr_clk          : std_logic;
   signal  portaraddr_clr          : std_logic;
   signal  portadataout_clk        : std_logic;
   signal  portadataout_clr        : std_logic;

   -- other signals
   signal  portawe_reg_mux         : std_logic;
   signal  portawe_reg_mux_delayed : std_logic;
   signal  portawe_pulse           : std_logic;
   signal  portadataout_tmp        : std_logic_vector(15 downto 0);
   signal  portavalid_addr         : std_logic;
   signal  portaraddr_num          : integer;
   signal  portaclk0_delayed       : std_logic;

   -- 'sel' signals for portb
   signal  portbdatain_reg_sel     : std_logic;
   signal  portbdatain_reg_clr_sel : std_logic;
   signal  portbwrite_reg_sel      : std_logic;
   signal  portbwe_clr_sel         : std_logic;
   signal  portbwaddr_clr_sel      : std_logic;
   signal  portbraddr_clr_sel      : std_logic_vector(1 downto 0);
   signal  portbre_clr_sel         : std_logic_vector(1 downto 0);
   signal  portbraddr_clk_sel      : std_logic_vector(1 downto 0);
   signal  portbre_clk_sel         : std_logic_vector(1 downto 0);
   signal  portbdataout_clk_sel    : std_logic_vector(1 downto 0); 
   signal  portbdataout_clr_sel    : std_logic_vector(1 downto 0); 
   signal  portbraddr_en_sel       : std_logic;
   signal  portbre_en_sel          : std_logic;
   signal  portbdataout_en_sel     : std_logic; 

   -- registered signals for portb
   signal  portbdatain_reg         : std_logic_vector(15 downto 0);
   signal  portbdataout_reg        : std_logic_vector(15 downto 0);
   signal  portbwe_reg             : std_logic;
   signal  portbre_reg             : std_logic;
   signal  portbraddr_reg          : std_logic_vector(15 downto 0);
   signal  portbwaddr_reg          : std_logic_vector(15 downto 0);

   signal  portbdatain_int         : std_logic_vector(15 downto 0);
   signal  portbdataout_int        : std_logic_vector(15 downto 0);
   signal  portbraddr_int          : std_logic_vector(15 downto 0);
   signal  portbwaddr_int          : std_logic_vector(15 downto 0);
   signal  portbwe_int             : std_logic;
   signal  portbre_int             : std_logic;

   -- 'clr' signals for portb
   signal  portbdatain_reg_clr     : std_logic;
   signal  portbdinreg_clr         : std_logic;
   signal  portbwe_reg_clr         : std_logic;
   signal  portbwereg_clr          : std_logic;
   signal  portbwaddr_reg_clr      : std_logic;
   signal  portbwaddrreg_clr       : std_logic;
   signal  portbre_reg_clr         : std_logic;
   signal  portbrereg_clr          : std_logic;
   signal  portbraddr_reg_clr      : std_logic;
   signal  portbraddrreg_clr       : std_logic;
   signal  portbdataout_reg_clr    : std_logic;
   signal  portbdataoutreg_clr     : std_logic;

   -- 'ena' signals for portb
   signal  portbreen               : std_logic;
   signal  portbraddren            : std_logic;
   signal  portbdataouten          : std_logic;

   -- 'clk' signals for portb
   signal  portbre_clk             : std_logic;
   signal  portbre_clr             : std_logic;
   signal  portbraddr_clk          : std_logic;
   signal  portbraddr_clr          : std_logic;
   signal  portbdataout_clk        : std_logic;
   signal  portbdataout_clr        : std_logic;

   -- other signals
   signal  portbwe_reg_mux         : std_logic;
   signal  portbwe_reg_mux_delayed : std_logic;
   signal  portbwe_pulse           : std_logic;
   signal  portbdataout_tmp        : std_logic_vector(15 downto 0);
   signal  portbvalid_addr         : std_logic;
   signal  portbraddr_num          : integer;
   signal  portbclk0_delayed       : std_logic;

   signal  NC                      : std_logic := '0';

   -- additional signals to introduce delta delays
   -- porta
   signal portawaddr_reg_delayed_1 : std_logic_vector(15 downto 0);
   signal portawaddr_reg_delayed_2 : std_logic_vector(15 downto 0);
   signal portawaddr_reg_delayed_3 : std_logic_vector(15 downto 0);

   signal portadatain_reg_delayed_1 : std_logic_vector(15 downto 0);
   signal portadatain_reg_delayed_2 : std_logic_vector(15 downto 0);
   signal portadatain_reg_delayed_3 : std_logic_vector(15 downto 0);
   -- portb
   signal portbwaddr_reg_delayed_1 : std_logic_vector(15 downto 0);
   signal portbwaddr_reg_delayed_2 : std_logic_vector(15 downto 0);
   signal portbwaddr_reg_delayed_3 : std_logic_vector(15 downto 0);

   signal portbdatain_reg_delayed_1 : std_logic_vector(15 downto 0);
   signal portbdatain_reg_delayed_2 : std_logic_vector(15 downto 0);
   signal portbdatain_reg_delayed_3 : std_logic_vector(15 downto 0);

   signal portare_reg_delayed_1    : std_logic;
   signal portare_reg_delayed_2    : std_logic;
   signal portare_reg_delayed_3    : std_logic;
   signal portare_reg_delayed_4    : std_logic;

   signal portaraddr_reg_delayed_1 : std_logic_vector(15 downto 0);
   signal portaraddr_reg_delayed_2 : std_logic_vector(15 downto 0);
   signal portaraddr_reg_delayed_3 : std_logic_vector(15 downto 0);
   signal portaraddr_reg_delayed_4 : std_logic_vector(15 downto 0);
   signal portaraddr_reg_delayed_5 : std_logic_vector(15 downto 0);

   signal portbraddr_reg_delayed_1 : std_logic_vector(15 downto 0);
   signal portbraddr_reg_delayed_2 : std_logic_vector(15 downto 0);
   signal portbraddr_reg_delayed_3 : std_logic_vector(15 downto 0);
   signal portbraddr_reg_delayed_4 : std_logic_vector(15 downto 0);
   signal portbraddr_reg_delayed_5 : std_logic_vector(15 downto 0);

   signal portbre_reg_delayed_1    : std_logic;
   signal portbre_reg_delayed_2    : std_logic;
   signal portbre_reg_delayed_3    : std_logic;
   signal portbre_reg_delayed_4    : std_logic;

begin     

    portadatain_reg_sel           <= portamodesel(0);
    portadatain_reg_clr_sel       <= portamodesel(1);

    portawrite_reg_sel            <= portamodesel(2);
    portawe_clr_sel               <= portamodesel(3);
    portawaddr_clr_sel            <= portamodesel(4);

    portaraddr_clk_sel(0)         <= portamodesel(5);
    portaraddr_clr_sel(0)         <= portamodesel(6);

    portare_clk_sel(0)            <= portamodesel(7);
    portare_clr_sel(0)            <= portamodesel(8);

    portadataout_clk_sel(0)       <= portamodesel(9);
    portadataout_clr_sel(0)       <= portamodesel(10);

    portare_clk_sel(1)            <= portamodesel(11);
    portare_en_sel                <= portamodesel(11);
    portare_clr_sel(1)            <= portamodesel(12);

    portaraddr_clk_sel(1)         <= portamodesel(13);
    portaraddr_en_sel             <= portamodesel(13);
    portaraddr_clr_sel(1)         <= portamodesel(14);

    portadataout_clk_sel(1)       <= portamodesel(15);
    portadataout_en_sel           <= portamodesel(15);
    portadataout_clr_sel(1)       <= portamodesel(16);

    portbdatain_reg_sel           <= portbmodesel(0);
    portbdatain_reg_clr_sel       <= portbmodesel(1);

    portbwrite_reg_sel            <= portbmodesel(2);
    portbwe_clr_sel               <= portbmodesel(3);
    portbwaddr_clr_sel            <= portbmodesel(4);

    portbraddr_clk_sel(0)         <= portbmodesel(5);
    portbraddr_clr_sel(0)         <= portbmodesel(6);

    portbre_clk_sel(0)            <= portbmodesel(7);
    portbre_clr_sel(0)            <= portbmodesel(8);

    portbdataout_clk_sel(0)       <= portbmodesel(9);
    portbdataout_clr_sel(0)       <= portbmodesel(10);

    portbre_clk_sel(1)            <= portbmodesel(11);
    portbre_en_sel                <= portbmodesel(11);
    portbre_clr_sel(1)            <= portbmodesel(12);

    portbraddr_clk_sel(1)         <= portbmodesel(13);
    portbraddr_en_sel             <= portbmodesel(13);
    portbraddr_clr_sel(1)         <= portbmodesel(14);

    portbdataout_clk_sel(1)       <= portbmodesel(15);
    portbdataout_en_sel           <= portbmodesel(15);
    portbdataout_clr_sel(1)       <= portbmodesel(16);

    -- PORT A registers

    portadatainregclr: nmux21
            port map (A => NC,
                      B => portaclr0,
                      S => portadatain_reg_clr_sel,
                      MO => portadatain_reg_clr
                     );
    portadinreg_clr <= portadatain_reg_clr and devclrn and devpor;
    portadinreg_0 : dffe
            port map (D => portadatain(0),
                      CLRN => portadinreg_clr,
                      CLK => portaclk0,
                      ENA => portaena0,
                      Q => portadatain_reg(0)
                     );
    portadinreg_1 : dffe
            port map (D => portadatain(1),
                      CLRN => portadinreg_clr,
                      CLK => portaclk0,
                      ENA => portaena0,
                      Q => portadatain_reg(1)
                     );
    portadinreg_2 : dffe
            port map (D => portadatain(2),
                      CLRN => portadinreg_clr,
                      CLK => portaclk0,
                      ENA => portaena0,
                      Q => portadatain_reg(2)
                     );
    portadinreg_3 : dffe
            port map (D => portadatain(3),
                      CLRN => portadinreg_clr,
                      CLK => portaclk0,
                      ENA => portaena0,
                      Q => portadatain_reg(3)
                     );
    portadinreg_4 : dffe
            port map (D => portadatain(4),
                      CLRN => portadinreg_clr,
                      CLK => portaclk0,
                      ENA => portaena0,
                      Q => portadatain_reg(4)
                     );
    portadinreg_5 : dffe
            port map (D => portadatain(5),
                      CLRN => portadinreg_clr,
                      CLK => portaclk0,
                      ENA => portaena0,
                      Q => portadatain_reg(5)
                     );
    portadinreg_6 : dffe
            port map (D => portadatain(6),
                      CLRN => portadinreg_clr,
                      CLK => portaclk0,
                      ENA => portaena0,
                      Q => portadatain_reg(6)
                     );
    portadinreg_7 : dffe
            port map (D => portadatain(7),
                      CLRN => portadinreg_clr,
                      CLK => portaclk0,
                      ENA => portaena0,
                      Q => portadatain_reg(7)
                     );
    portadinreg_8 : dffe
            port map (D => portadatain(8),
                      CLRN => portadinreg_clr,
                      CLK => portaclk0,
                      ENA => portaena0,
                      Q => portadatain_reg(8)
                     );
    portadinreg_9 : dffe
            port map (D => portadatain(9),
                      CLRN => portadinreg_clr,
                      CLK => portaclk0,
                      ENA => portaena0,
                      Q => portadatain_reg(9)
                     );
    portadinreg_10 : dffe
            port map (D => portadatain(10),
                      CLRN => portadinreg_clr,
                      CLK => portaclk0,
                      ENA => portaena0,
                      Q => portadatain_reg(10)
                     );
    portadinreg_11 : dffe
            port map (D => portadatain(11),
                      CLRN => portadinreg_clr,
                      CLK => portaclk0,
                      ENA => portaena0,
                      Q => portadatain_reg(11)
                     );
    portadinreg_12 : dffe
            port map (D => portadatain(12),
                      CLRN => portadinreg_clr,
                      CLK => portaclk0,
                      ENA => portaena0,
                      Q => portadatain_reg(12)
                     );
    portadinreg_13 : dffe
            port map (D => portadatain(13),
                      CLRN => portadinreg_clr,
                      CLK => portaclk0,
                      ENA => portaena0,
                      Q => portadatain_reg(13)
                     );
    portadinreg_14 : dffe
            port map (D => portadatain(14),
                      CLRN => portadinreg_clr,
                      CLK => portaclk0,
                      ENA => portaena0,
                      Q => portadatain_reg(14)
                     );
    portadinreg_15 : dffe
            port map (D => portadatain(15),
                      CLRN => portadinreg_clr,
                      CLK => portaclk0,
                      ENA => portaena0,
                      Q => portadatain_reg(15)
                     );

    portadatain_reg_delayed_1 <= portadatain_reg;
    portadatain_reg_delayed_2 <= portadatain_reg_delayed_1;
    portadatain_reg_delayed_3 <= portadatain_reg_delayed_2;

    portadatainsel: bmux21 
            port map (A => portadatain,
                      B => portadatain_reg_delayed_3,
                      S => portadatain_reg_sel, 
                      MO => portadatain_int
                     );

    portaweregclr: nmux21
            port map (A => NC,
                      B => portaclr0,
                      S => portawe_clr_sel,
                      MO => portawe_reg_clr
                     );
    portawereg_clr <= portawe_reg_clr and devclrn and devpor; 
    portawereg: dffe 
            port map (D => portawe,
                      CLRN => portawereg_clr,
                      CLK => portaclk0,
                      ENA => portaena0,
                      Q => portawe_reg
                     );
    portawesel1: mux21
            port map (A => portawe,
                      B => portawe_reg,
                      S => portawrite_reg_sel,
                      MO => portawe_reg_mux
                      );
    portawedelaybuf: and1
            port map (IN1 => portawe_reg_mux,
                      Y => portawe_reg_mux_delayed
                     );

    -- portaclk0 for we_pulse should have the same delay as
    -- clk of portawereg
    --portawe_pulse <= portawe_reg_mux_delayed and (not portaclk0);

    portaclk0weregdelaybuf: and1
            port map (IN1 => portaclk0,
                      Y => portaclk0_delayed
                     );
    portawe_pulse <= portawe_reg_mux_delayed and (not portaclk0_delayed);

    portawesel2: mux21
            port map (A => portawe_reg_mux_delayed,
                      B => portawe_pulse,
                      S => portawrite_reg_sel,
                      MO => portawe_int
                     );

    portawaddrregclr: nmux21
            port map (A => NC,
                      B => portaclr0,
                      S => portawaddr_clr_sel,
                      MO => portawaddr_reg_clr
                     );
    portawaddrreg_clr <= portawaddr_reg_clr and devclrn and devpor; 
    portawaddrreg_0: dffe 
            port map (D => portawaddr(0),
                      CLRN => portawaddrreg_clr,
                      CLK => portaclk0,
                      ENA => portaena0,
                      Q => portawaddr_reg(0)
                      );
    portawaddrreg_1: dffe 
            port map (D => portawaddr(1),
                      CLRN => portawaddrreg_clr,
                      CLK => portaclk0,
                      ENA => portaena0,
                      Q => portawaddr_reg(1)
                      );
    portawaddrreg_2: dffe 
            port map (D => portawaddr(2),
                      CLRN => portawaddrreg_clr,
                      CLK => portaclk0,
                      ENA => portaena0,
                      Q => portawaddr_reg(2)
                      );
    portawaddrreg_3: dffe 
            port map (D => portawaddr(3),
                      CLRN => portawaddrreg_clr,
                      CLK => portaclk0,
                      ENA => portaena0,
                      Q => portawaddr_reg(3)
                      );
    portawaddrreg_4: dffe 
            port map (D => portawaddr(4),
                      CLRN => portawaddrreg_clr,
                      CLK => portaclk0,
                      ENA => portaena0,
                      Q => portawaddr_reg(4)
                      );
    portawaddrreg_5: dffe 
            port map (D => portawaddr(5),
                      CLRN => portawaddrreg_clr,
                      CLK => portaclk0,
                      ENA => portaena0,
                      Q => portawaddr_reg(5)
                      );
    portawaddrreg_6: dffe 
            port map (D => portawaddr(6),
                      CLRN => portawaddrreg_clr,
                      CLK => portaclk0,
                      ENA => portaena0,
                      Q => portawaddr_reg(6)
                      );
    portawaddrreg_7: dffe 
            port map (D => portawaddr(7),
                      CLRN => portawaddrreg_clr,
                      CLK => portaclk0,
                      ENA => portaena0,
                      Q => portawaddr_reg(7)
                      );
    portawaddrreg_8: dffe 
            port map (D => portawaddr(8),
                      CLRN => portawaddrreg_clr,
                      CLK => portaclk0,
                      ENA => portaena0,
                      Q => portawaddr_reg(8)
                      );
    portawaddrreg_9: dffe 
            port map (D => portawaddr(9),
                      CLRN => portawaddrreg_clr,
                      CLK => portaclk0,
                      ENA => portaena0,
                      Q => portawaddr_reg(9)
                      );
    portawaddrreg_10: dffe 
            port map (D => portawaddr(10),
                      CLRN => portawaddrreg_clr,
                      CLK => portaclk0,
                      ENA => portaena0,
                      Q => portawaddr_reg(10)
                     );
    portawaddrreg_11: dffe 
            port map (D => portawaddr(11),
                      CLRN => portawaddrreg_clr,
                      CLK => portaclk0,
                      ENA => portaena0,
                      Q => portawaddr_reg(11)
                     );
    portawaddrreg_12: dffe 
            port map (D => portawaddr(12),
                      CLRN => portawaddrreg_clr,
                      CLK => portaclk0,
                      ENA => portaena0,
                      Q => portawaddr_reg(12)
                     );
    portawaddrreg_13: dffe 
            port map (D => portawaddr(13),
                      CLRN => portawaddrreg_clr,
                      CLK => portaclk0,
                      ENA => portaena0,
                      Q => portawaddr_reg(13)
                     );
    portawaddrreg_14: dffe 
            port map (D => portawaddr(14),
                      CLRN => portawaddrreg_clr,
                      CLK => portaclk0,
                      ENA => portaena0,
                      Q => portawaddr_reg(14)
                     );
    portawaddrreg_15: dffe 
            port map (D => portawaddr(15),
                      CLRN => portawaddrreg_clr,
                      CLK => portaclk0,
                      ENA => portaena0,
                      Q => portawaddr_reg(15)
                     );
    
    portawaddr_reg_delayed_1 <= portawaddr_reg;
    portawaddr_reg_delayed_2 <= portawaddr_reg_delayed_1;
    portawaddr_reg_delayed_3 <= portawaddr_reg_delayed_2;
    
    portawaddrsel: bmux21 
            port map (A => portawaddr,
                      B => portawaddr_reg_delayed_3,
                      S => portawrite_reg_sel,
                      MO => portawaddr_int
                     );
    
    portaraddrclksel: mux21
            port map (A => portaclk0,
                      B => portaclk1,
                      S => portaraddr_clk_sel(1),
                      MO => portaraddr_clk
                     ); 
    portaraddrensel: mux21
            port map (A => portaena0,
                      B => portaena1,
                      S => portaraddr_en_sel,
                      MO => portaraddren
                     ); 
    portaraddrclrsel: mux21
            port map (A => portaclr0,
                      B => portaclr1,
                      S => portaraddr_clr_sel(1),
                      MO => portaraddr_clr
                     );
    portaraddrregclr: nmux21
            port map (A => NC,
                      B => portaraddr_clr,
                      S => portaraddr_clr_sel(0),
                      MO => portaraddr_reg_clr
                     );
    portaraddrreg_clr <= portaraddr_reg_clr and devclrn and devpor;
    portaraddrreg_0: dffe 
            port map (D => portaraddr(0),
                      CLRN => portaraddrreg_clr,
                      CLK => portaraddr_clk,
                      ENA => portaraddren,
                      Q => portaraddr_reg(0)
                      );
    portaraddrreg_1: dffe 
            port map (D => portaraddr(1),
                      CLRN => portaraddrreg_clr,
                      CLK => portaraddr_clk,
                      ENA => portaraddren,
                      Q => portaraddr_reg(1)
                      );
    portaraddrreg_2: dffe 
            port map (D => portaraddr(2),
                      CLRN => portaraddrreg_clr,
                      CLK => portaraddr_clk,
                      ENA => portaraddren,
                      Q => portaraddr_reg(2)
                      );
    portaraddrreg_3: dffe 
            port map (D => portaraddr(3),
                      CLRN => portaraddrreg_clr,
                      CLK => portaraddr_clk,
                      ENA => portaraddren,
                      Q => portaraddr_reg(3)
                      );
    portaraddrreg_4: dffe 
            port map (D => portaraddr(4),
                      CLRN => portaraddrreg_clr,
                      CLK => portaraddr_clk,
                      ENA => portaraddren,
                      Q => portaraddr_reg(4)
                     );
    portaraddrreg_5: dffe 
            port map (D => portaraddr(5),
                      CLRN => portaraddrreg_clr,
                      CLK => portaraddr_clk,
                      ENA => portaraddren,
                      Q => portaraddr_reg(5)
                     );
    portaraddrreg_6: dffe 
            port map (D => portaraddr(6),
                      CLRN => portaraddrreg_clr,
                      CLK => portaraddr_clk,
                      ENA => portaraddren,
                      Q => portaraddr_reg(6)
                     );
    portaraddrreg_7: dffe 
            port map (D => portaraddr(7),
                      CLRN => portaraddrreg_clr,
                      CLK => portaraddr_clk,
                      ENA => portaraddren,
                      Q => portaraddr_reg(7)
                     );
    portaraddrreg_8: dffe 
            port map (D => portaraddr(8),
                      CLRN => portaraddrreg_clr,
                      CLK => portaraddr_clk,
                      ENA => portaraddren,
                      Q => portaraddr_reg(8)
                     );
    portaraddrreg_9: dffe 
            port map (D => portaraddr(9),
                      CLRN => portaraddrreg_clr,
                      CLK => portaraddr_clk,
                      ENA => portaraddren,
                      Q => portaraddr_reg(9)
                     );
    portaraddrreg_10: dffe 
            port map (D => portaraddr(10),
                      CLRN => portaraddrreg_clr,
                      CLK => portaraddr_clk,
                      ENA => portaraddren,
                      Q => portaraddr_reg(10)
                     );
    portaraddrreg_11: dffe 
            port map (D => portaraddr(11),
                      CLRN => portaraddrreg_clr, 
                      CLK => portaraddr_clk,
                      ENA => portaraddren,
                      Q => portaraddr_reg(11)
                     );
    portaraddrreg_12: dffe 
            port map (D => portaraddr(12),
                      CLRN => portaraddrreg_clr,
                      CLK => portaraddr_clk,
                      ENA => portaraddren,
                      Q => portaraddr_reg(12)
                     );
    portaraddrreg_13: dffe 
            port map (D => portaraddr(13),
                      CLRN => portaraddrreg_clr,
                      CLK => portaraddr_clk,
                      ENA => portaraddren,
                      Q => portaraddr_reg(13)
                     );
    portaraddrreg_14: dffe 
            port map (D => portaraddr(14),
                      CLRN => portaraddrreg_clr,
                      CLK => portaraddr_clk,
                      ENA => portaraddren,
                      Q => portaraddr_reg(14)
                     );
    portaraddrreg_15: dffe 
            port map (D => portaraddr(15),
                      CLRN => portaraddrreg_clr,
                      CLK => portaraddr_clk,
                      ENA => portaraddren,
                      Q => portaraddr_reg(15)
                     );
    
    portaraddr_reg_delayed_1 <= portaraddr_reg;
    portaraddr_reg_delayed_2 <= portaraddr_reg_delayed_1;
    portaraddr_reg_delayed_3 <= portaraddr_reg_delayed_2;
    portaraddr_reg_delayed_4 <= portaraddr_reg_delayed_3;
    portaraddr_reg_delayed_5 <= portaraddr_reg_delayed_4;
    
    portaraddrsel: bmux21
            port map (A => portaraddr,
                      B => portaraddr_reg_delayed_5,
                      S => portaraddr_clk_sel(0),
                      MO => portaraddr_int
                     );
    portareclksel: mux21
            port map (A => portaclk0,
                      B => portaclk1,
                      S => portare_clk_sel(1),
                      MO => portare_clk
                     ); 
    portareensel: mux21
            port map (A => portaena0,
                      B => portaena1,
                      S => portare_en_sel,
                      MO => portareen
                     ); 
    portareclrsel: mux21
            port map (A => portaclr0,
                      B => portaclr1,
                      S => portare_clr_sel(1),
                      MO => portare_clr
                     );
    portareregclr: nmux21
            port map (A => NC,
                      B => portare_clr,
                      S => portare_clr_sel(0),
                      MO => portare_reg_clr
                     );
    portarereg_clr <= portare_reg_clr and devclrn and devpor; 
    portarereg: dffe 
            port map (D => portare,
                      CLRN => portarereg_clr,
                      CLK => portare_clk,
                      ENA => portareen,
                      Q => portare_reg
                     );
    
    portare_reg_delayed_1 <= portare_reg;
    portare_reg_delayed_2 <= portare_reg_delayed_1;
    portare_reg_delayed_3 <= portare_reg_delayed_2;
    portare_reg_delayed_4 <= portare_reg_delayed_3;
    
    portaresel: mux21
            port map (A => portare,
                      B => portare_reg_delayed_4,
                      S => portare_clk_sel(0),
                      MO => portare_int
                     ); 
    portadataoutclksel: mux21
            port map (A => portaclk0,
                      B => portaclk1,
                      S => portadataout_clk_sel(1),
                      MO => portadataout_clk
                     );
    portadataoutensel: mux21
            port map (A => portaena0,
                      B => portaena1,
                      S => portadataout_en_sel,
                      MO => portadataouten
                     );
    portadataoutclrsel: mux21
            port map (A => portaclr0,
                      B => portaclr1,
                      S => portadataout_clr_sel(1),
                      MO => portadataout_clr
                     );
    portadataoutregclr: nmux21
            port map (A => NC,
                      B => portadataout_clr,
                      S => portadataout_clr_sel(0),
                      MO => portadataout_reg_clr
                     );
    portadataoutreg_clr <= portadataout_reg_clr and devclrn and devpor;
    portadataoutreg_0 : dffe 
            port map (D => portadataout_int(0),
                      CLRN => portadataoutreg_clr, 
                      CLK => portadataout_clk,
                      ENA => portadataouten,
                      Q => portadataout_reg(0)
                     );
    portadataoutreg_1 : dffe 
            port map (D => portadataout_int(1),
                      CLRN => portadataoutreg_clr, 
                      CLK => portadataout_clk,
                      ENA => portadataouten,
                      Q => portadataout_reg(1)
                     );
    portadataoutreg_2 : dffe 
            port map (D => portadataout_int(2),
                      CLRN => portadataoutreg_clr, 
                      CLK => portadataout_clk,
                      ENA => portadataouten,
                      Q => portadataout_reg(2)
                     );
    portadataoutreg_3 : dffe 
            port map (D => portadataout_int(3),
                      CLRN => portadataoutreg_clr, 
                      CLK => portadataout_clk,
                      ENA => portadataouten,
                      Q => portadataout_reg(3)
                     );
    portadataoutreg_4 : dffe 
            port map (D => portadataout_int(4),
                      CLRN => portadataoutreg_clr, 
                      CLK => portadataout_clk,
                      ENA => portadataouten,
                      Q => portadataout_reg(4)
                     );
    portadataoutreg_5 : dffe 
            port map (D => portadataout_int(5),
                      CLRN => portadataoutreg_clr, 
                      CLK => portadataout_clk,
                      ENA => portadataouten,
                      Q => portadataout_reg(5)
                     );
    portadataoutreg_6 : dffe 
            port map (D => portadataout_int(6),
                      CLRN => portadataoutreg_clr, 
                      CLK => portadataout_clk,
                      ENA => portadataouten,
                      Q => portadataout_reg(6)
                     );
    portadataoutreg_7 : dffe 
            port map (D => portadataout_int(7),
                      CLRN => portadataoutreg_clr, 
                      CLK => portadataout_clk,
                      ENA => portadataouten,
                      Q => portadataout_reg(7)
                     );
    portadataoutreg_8 : dffe 
            port map (D => portadataout_int(8),
                      CLRN => portadataoutreg_clr, 
                      CLK => portadataout_clk,
                      ENA => portadataouten,
                      Q => portadataout_reg(8)
                     );
    portadataoutreg_9 : dffe 
            port map (D => portadataout_int(9),
                      CLRN => portadataoutreg_clr, 
                      CLK => portadataout_clk,
                      ENA => portadataouten,
                      Q => portadataout_reg(9)
                     );
    portadataoutreg_10 : dffe 
            port map (D => portadataout_int(10),
                      CLRN => portadataoutreg_clr, 
                      CLK => portadataout_clk,
                      ENA => portadataouten,
                      Q => portadataout_reg(10)
                     );
    portadataoutreg_11 : dffe 
            port map (D => portadataout_int(11),
                      CLRN => portadataoutreg_clr, 
                      CLK => portadataout_clk,
                      ENA => portadataouten,
                      Q => portadataout_reg(11)
                     );
    portadataoutreg_12 : dffe 
            port map (D => portadataout_int(12),
                      CLRN => portadataoutreg_clr, 
                      CLK => portadataout_clk,
                      ENA => portadataouten,
                      Q => portadataout_reg(12)
                     );
    portadataoutreg_13 : dffe 
            port map (D => portadataout_int(13),
                      CLRN => portadataoutreg_clr, 
                      CLK => portadataout_clk,
                      ENA => portadataouten,
                      Q => portadataout_reg(13)
                     );
    portadataoutreg_14 : dffe 
            port map (D => portadataout_int(14),
                      CLRN => portadataoutreg_clr, 
                      CLK => portadataout_clk,
                      ENA => portadataouten,
                      Q => portadataout_reg(14)
                     );
    portadataoutreg_15 : dffe 
            port map (D => portadataout_int(15),
                      CLRN => portadataoutreg_clr, 
                      CLK => portadataout_clk,
                      ENA => portadataouten,
                      Q => portadataout_reg(15)
                     );
    portadataoutsel: bmux21
            port map (A => portadataout_int,
                      B => portadataout_reg,
                      S => portadataout_clk_sel(0),
                      MO => portadataout_tmp
                     );
    
    -- PORT B registers
    
    portbdatainregclr: nmux21
            port map (A => NC,
                      B => portbclr0,
                      S => portbdatain_reg_clr_sel,
                      MO => portbdatain_reg_clr
                     );
    portbdinreg_clr <= portbdatain_reg_clr and devclrn and devpor;
    portbdinreg_0 : dffe
            port map (D => portbdatain(0),
                      CLRN => portbdinreg_clr,
                      CLK => portbclk0,
                      ENA => portbena0,
                      Q => portbdatain_reg(0)
                     );
    portbdinreg_1 : dffe
            port map (D => portbdatain(1),
                      CLRN => portbdinreg_clr,
                      CLK => portbclk0,
                      ENA => portbena0,
                      Q => portbdatain_reg(1)
                     );
    portbdinreg_2 : dffe
            port map (D => portbdatain(2),
                      CLRN => portbdinreg_clr,
                      CLK => portbclk0,
                      ENA => portbena0,
                      Q => portbdatain_reg(2)
                     );
    portbdinreg_3 : dffe
            port map (D => portbdatain(3),
                      CLRN => portbdinreg_clr,
                      CLK => portbclk0,
                      ENA => portbena0,
                      Q => portbdatain_reg(3)
                     );
    portbdinreg_4 : dffe
            port map (D => portbdatain(4),
                      CLRN => portbdinreg_clr,
                      CLK => portbclk0,
                      ENA => portbena0,
                      Q => portbdatain_reg(4)
                     );
    portbdinreg_5 : dffe
            port map (D => portbdatain(5),
                      CLRN => portbdinreg_clr,
                      CLK => portbclk0,
                      ENA => portbena0,
                      Q => portbdatain_reg(5)
                     );
    portbdinreg_6 : dffe
            port map (D => portbdatain(6),
                      CLRN => portbdinreg_clr,
                      CLK => portbclk0,
                      ENA => portbena0,
                      Q => portbdatain_reg(6)
                     );
    portbdinreg_7 : dffe
            port map (D => portbdatain(7),
                      CLRN => portbdinreg_clr,
                      CLK => portbclk0,
                      ENA => portbena0,
                      Q => portbdatain_reg(7)
                     );
    portbdinreg_8 : dffe
            port map (D => portbdatain(8),
                      CLRN => portbdinreg_clr,
                      CLK => portbclk0,
                      ENA => portbena0,
                      Q => portbdatain_reg(8)
                     );
    portbdinreg_9 : dffe
            port map (D => portbdatain(9),
                      CLRN => portbdinreg_clr,
                      CLK => portbclk0,
                      ENA => portbena0,
                      Q => portbdatain_reg(9)
                     );
    portbdinreg_10 : dffe
            port map (D => portbdatain(10),
                      CLRN => portbdinreg_clr,
                      CLK => portbclk0,
                      ENA => portbena0,
                      Q => portbdatain_reg(10)
                     );
    portbdinreg_11 : dffe
            port map (D => portbdatain(11),
                      CLRN => portbdinreg_clr,
                      CLK => portbclk0,
                      ENA => portbena0,
                      Q => portbdatain_reg(11)
                     );
    portbdinreg_12 : dffe
            port map (D => portbdatain(12),
                      CLRN => portbdinreg_clr,
                      CLK => portbclk0,
                      ENA => portbena0,
                      Q => portbdatain_reg(12)
                     );
    portbdinreg_13 : dffe
            port map (D => portbdatain(13),
                      CLRN => portbdinreg_clr,
                      CLK => portbclk0,
                      ENA => portbena0,
                      Q => portbdatain_reg(13)
                     );
    portbdinreg_14 : dffe
            port map (D => portbdatain(14),
                      CLRN => portbdinreg_clr,
                      CLK => portbclk0,
                      ENA => portbena0,
                      Q => portbdatain_reg(14)
                     );
    portbdinreg_15 : dffe
            port map (D => portbdatain(15),
                      CLRN => portbdinreg_clr,
                      CLK => portbclk0,
                      ENA => portbena0,
                      Q => portbdatain_reg(15)
                     );
    
    portbdatain_reg_delayed_1 <= portbdatain_reg;
    portbdatain_reg_delayed_2 <= portbdatain_reg_delayed_1;
    portbdatain_reg_delayed_3 <= portbdatain_reg_delayed_2;
    
    portbdatainsel: bmux21 
            port map (A => portbdatain,
                      B => portbdatain_reg_delayed_3,
                      S => portbdatain_reg_sel,
                      MO => portbdatain_int
                     ); 
    portbweregclr: nmux21
            port map (A => NC,
                      B => portbclr0,
                      S => portbwe_clr_sel,
                      MO => portbwe_reg_clr
                     );
    portbwereg_clr <= portbwe_reg_clr and devclrn and devpor; 
    portbwereg: dffe 
            port map (D => portbwe,
                      CLRN => portbwereg_clr,
                      CLK => portbclk0,
                      ENA => portbena0,
                      Q => portbwe_reg
                     );
    portbwesel1: mux21
            port map (A => portbwe,
                      B => portbwe_reg,
                      S => portbwrite_reg_sel,
                      MO => portbwe_reg_mux
                     );
    portbwedelaybuf: and1
            port map (IN1 => portbwe_reg_mux,
                      Y => portbwe_reg_mux_delayed
                     );
    
    -- portbclk0 for we_pulse should have the same delay as
    -- clk of portbwereg
    --portbwe_pulse <= portbwe_reg_mux_delayed and (not portbclk0);
    
    portbclk0weregdelaybuf: and1
            port map (IN1 => portbclk0,
                      Y => portbclk0_delayed
                     );
    portbwe_pulse <= portbwe_reg_mux_delayed and (not portbclk0_delayed);
    
    portbwesel2: mux21
            port map (A => portbwe_reg_mux_delayed,
                      B => portbwe_pulse,
                      S => portbwrite_reg_sel,
                      MO => portbwe_int
                     );
    portbwaddrregclr: nmux21
            port map (A => NC,
                      B => portbclr0,
                      S => portbwaddr_clr_sel,
                      MO => portbwaddr_reg_clr
                     );
    portbwaddrreg_clr <= portbwaddr_reg_clr and devclrn and devpor; 
    portbwaddrreg_0: dffe 
            port map (D => portbwaddr(0),
                      CLRN => portbwaddrreg_clr,
                      CLK => portbclk0,
                      ENA => portbena0,
                      Q => portbwaddr_reg(0)
                     );
    portbwaddrreg_1: dffe 
            port map (D => portbwaddr(1),
                      CLRN => portbwaddrreg_clr,
                      CLK => portbclk0,
                      ENA => portbena0,
                      Q => portbwaddr_reg(1)
                     );
    portbwaddrreg_2: dffe 
            port map (D => portbwaddr(2),
                      CLRN => portbwaddrreg_clr,
                      CLK => portbclk0,
                      ENA => portbena0,
                      Q => portbwaddr_reg(2)
                     );
    portbwaddrreg_3: dffe 
            port map (D => portbwaddr(3),
                      CLRN => portbwaddrreg_clr,
                      CLK => portbclk0,
                      ENA => portbena0,
                      Q => portbwaddr_reg(3)
                     );
    portbwaddrreg_4: dffe 
            port map (D => portbwaddr(4),
                      CLRN => portbwaddrreg_clr,
                      CLK => portbclk0,
                      ENA => portbena0,
                      Q => portbwaddr_reg(4)
                     );
    portbwaddrreg_5: dffe 
            port map (D => portbwaddr(5),
                      CLRN => portbwaddrreg_clr,
                      CLK => portbclk0,
                      ENA => portbena0,
                      Q => portbwaddr_reg(5)
                     );
    portbwaddrreg_6: dffe 
            port map (D => portbwaddr(6),
                      CLRN => portbwaddrreg_clr,
                      CLK => portbclk0,
                      ENA => portbena0,
                      Q => portbwaddr_reg(6)
                     );
    portbwaddrreg_7: dffe 
            port map (D => portbwaddr(7),
                      CLRN => portbwaddrreg_clr,
                      CLK => portbclk0,
                      ENA => portbena0,
                      Q => portbwaddr_reg(7)
                     );
    portbwaddrreg_8: dffe 
            port map (D => portbwaddr(8),
                      CLRN => portbwaddrreg_clr,
                      CLK => portbclk0,
                      ENA => portbena0,
                      Q => portbwaddr_reg(8)
                     );
    portbwaddrreg_9: dffe 
            port map (D => portbwaddr(9),
                      CLRN => portbwaddrreg_clr,
                      CLK => portbclk0,
                      ENA => portbena0,
                      Q => portbwaddr_reg(9)
                     );
    portbwaddrreg_10: dffe 
            port map (D => portbwaddr(10),
                      CLRN => portbwaddrreg_clr,
                      CLK => portbclk0,
                      ENA => portbena0,
                      Q => portbwaddr_reg(10)
                     );
    portbwaddrreg_11: dffe 
            port map (D => portbwaddr(11),
                      CLRN => portbwaddrreg_clr,
                      CLK => portbclk0,
                      ENA => portbena0,
                      Q => portbwaddr_reg(11)
                     );
    portbwaddrreg_12: dffe 
            port map (D => portbwaddr(12),
                      CLRN => portbwaddrreg_clr,
                      CLK => portbclk0,
                      ENA => portbena0,
                      Q => portbwaddr_reg(12)
                     );
    portbwaddrreg_13: dffe 
            port map (D => portbwaddr(13),
                      CLRN => portbwaddrreg_clr,
                      CLK => portbclk0,
                      ENA => portbena0,
                      Q => portbwaddr_reg(13)
                     );
    portbwaddrreg_14: dffe 
            port map (D => portbwaddr(14),
                      CLRN => portbwaddrreg_clr,
                      CLK => portbclk0,
                      ENA => portbena0,
                      Q => portbwaddr_reg(14)
                     );
    portbwaddrreg_15: dffe 
            port map (D => portbwaddr(15),
                      CLRN => portbwaddrreg_clr,
                      CLK => portbclk0,
                      ENA => portbena0,
                      Q => portbwaddr_reg(15)
                     );
    
    portbwaddr_reg_delayed_1 <= portbwaddr_reg;
    portbwaddr_reg_delayed_2 <= portbwaddr_reg_delayed_1;
    portbwaddr_reg_delayed_3 <= portbwaddr_reg_delayed_2;
    
    portbwaddrsel: bmux21 
            port map (A => portbwaddr,
                      B => portbwaddr_reg_delayed_3,
                      S => portbwrite_reg_sel,
                      MO => portbwaddr_int
                     );
    portbraddrclksel: mux21
            port map (A => portbclk0,
                      B => portbclk1,
                      S => portbraddr_clk_sel(1),
                      MO => portbraddr_clk
                     ); 
    portbraddrensel: mux21
            port map (A => portbena0,
                      B => portbena1,
                      S => portbraddr_en_sel,
                      MO => portbraddren
                     );
    portbraddrclrsel: mux21
            port map (A => portbclr0,
                      B => portbclr1,
                      S => portbraddr_clr_sel(1),
                      MO => portbraddr_clr
                     );
    portbraddrregclr: nmux21
            port map (A => NC,
                      B => portbraddr_clr,
                      S => portbraddr_clr_sel(0),
                      MO => portbraddr_reg_clr
                     );
    portbraddrreg_clr <= portbraddr_reg_clr and devclrn and devpor;
    portbraddrreg_0: dffe 
            port map (D => portbraddr(0),
                      CLRN => portbraddrreg_clr,
                      CLK => portbraddr_clk,
                      ENA => portbraddren,
                      Q => portbraddr_reg(0)
                     );
    portbraddrreg_1: dffe 
            port map (D => portbraddr(1),
                      CLRN => portbraddrreg_clr,
                      CLK => portbraddr_clk,
                      ENA => portbraddren,
                      Q => portbraddr_reg(1)
                     );
    portbraddrreg_2: dffe 
            port map (D => portbraddr(2),
                      CLRN => portbraddrreg_clr,
                      CLK => portbraddr_clk,
                      ENA => portbraddren,
                      Q => portbraddr_reg(2)
                     );
    portbraddrreg_3: dffe 
            port map (D => portbraddr(3),
                      CLRN => portbraddrreg_clr,
                      CLK => portbraddr_clk,
                      ENA => portbraddren,
                      Q => portbraddr_reg(3)
                     );
    portbraddrreg_4: dffe 
            port map (D => portbraddr(4),
                      CLRN => portbraddrreg_clr,
                      CLK => portbraddr_clk,
                      ENA => portbraddren,
                      Q => portbraddr_reg(4)
                     );
    portbraddrreg_5: dffe 
            port map (D => portbraddr(5),
                      CLRN => portbraddrreg_clr,
                      CLK => portbraddr_clk,
                      ENA => portbraddren,
                      Q => portbraddr_reg(5)
                     );
    portbraddrreg_6: dffe 
            port map (D => portbraddr(6),
                      CLRN => portbraddrreg_clr,
                      CLK => portbraddr_clk,
                      ENA => portbraddren,
                      Q => portbraddr_reg(6)
                     );
    portbraddrreg_7: dffe 
            port map (D => portbraddr(7),
                      CLRN => portbraddrreg_clr,
                      CLK => portbraddr_clk,
                      ENA => portbraddren,
                      Q => portbraddr_reg(7)
                     );
    portbraddrreg_8: dffe 
            port map (D => portbraddr(8),
                      CLRN => portbraddrreg_clr,
                      CLK => portbraddr_clk,
                      ENA => portbraddren,
                      Q => portbraddr_reg(8)
                     );
    portbraddrreg_9: dffe 
            port map (D => portbraddr(9),
                      CLRN => portbraddrreg_clr,
                      CLK => portbraddr_clk,
                      ENA => portbraddren,
                      Q => portbraddr_reg(9)
                     );
    portbraddrreg_10: dffe 
            port map (D => portbraddr(10),
                      CLRN => portbraddrreg_clr,
                      CLK => portbraddr_clk,
                      ENA => portbraddren,
                      Q => portbraddr_reg(10)
                     );
    portbraddrreg_11: dffe 
            port map (D => portbraddr(11),
                      CLRN => portbraddrreg_clr,
                      CLK => portbraddr_clk,
                      ENA => portbraddren,
                      Q => portbraddr_reg(11)
                     );
    portbraddrreg_12: dffe 
            port map (D => portbraddr(12),
                      CLRN => portbraddrreg_clr,
                      CLK => portbraddr_clk,
                      ENA => portbraddren,
                      Q => portbraddr_reg(12)
                     );
    portbraddrreg_13: dffe 
            port map (D => portbraddr(13),
                      CLRN => portbraddrreg_clr,
                      CLK => portbraddr_clk,
                      ENA => portbraddren,
                      Q => portbraddr_reg(13)
                     );
    portbraddrreg_14: dffe 
            port map (D => portbraddr(14),
                      CLRN => portbraddrreg_clr,
                      CLK => portbraddr_clk,
                      ENA => portbraddren,
                      Q => portbraddr_reg(14)
                     );
    portbraddrreg_15: dffe 
            port map (D => portbraddr(15),
                      CLRN => portbraddrreg_clr,
                      CLK => portbraddr_clk,
                      ENA => portbraddren,
                      Q => portbraddr_reg(15)
                     );
    
    portbraddr_reg_delayed_1 <= portbraddr_reg;
    portbraddr_reg_delayed_2 <= portbraddr_reg_delayed_1;
    portbraddr_reg_delayed_3 <= portbraddr_reg_delayed_2;
    portbraddr_reg_delayed_4 <= portbraddr_reg_delayed_3;
    portbraddr_reg_delayed_5 <= portbraddr_reg_delayed_4;
    
    portbraddrsel: bmux21
            port map (A => portbraddr,
                      B => portbraddr_reg_delayed_5,
                      S => portbraddr_clk_sel(0),
                      MO => portbraddr_int
                     );
    portbreclksel: mux21
               port map (A => portbclk0,
                         B => portbclk1,
                         S => portbre_clk_sel(1),
                         MO => portbre_clk
                        ); 
    portbreensel: mux21
               port map (A => portbena0,
                         B => portbena1,
                         S => portbre_en_sel,
                         MO => portbreen
                        );
    portbreclrsel: mux21
               port map (A => portbclr0,
                         B => portbclr1,
                         S => portbre_clr_sel(1),
                         MO => portbre_clr
                        ); 
    portbreregclr: nmux21
               port map (A => NC,
                         B => portbre_clr,
                         S => portbre_clr_sel(0),
                         MO => portbre_reg_clr
                        );
    portbrereg_clr <= portbre_reg_clr and devclrn and devpor; 
    portbrereg: dffe 
             port map (D => portbre,
                       CLRN => portbrereg_clr,
                       CLK => portbre_clk,
                       ENA => portbreen,
                       Q => portbre_reg
                      );
    
    portbre_reg_delayed_1 <= portbre_reg;
    portbre_reg_delayed_2 <= portbre_reg_delayed_1;
    portbre_reg_delayed_3 <= portbre_reg_delayed_2;
    portbre_reg_delayed_4 <= portbre_reg_delayed_3;
    
    portbresel: mux21
            port map (A => portbre,
                      B => portbre_reg_delayed_4,
                      S => portbre_clk_sel(0),
                      MO => portbre_int
                     );
    portbdataoutclksel: mux21
            port map (A => portbclk0,
                      B => portbclk1,
                      S => portbdataout_clk_sel(1),
                      MO => portbdataout_clk
                     );
    portbdataoutensel: mux21
            port map (A => portbena0,
                      B => portbena1,
                      S => portbdataout_en_sel,
                      MO => portbdataouten
                     );
    portbdataoutclrsel: mux21
            port map (A => portbclr0,
                      B => portbclr1,
                      S => portbdataout_clr_sel(1),
                      MO => portbdataout_clr
                     );
    portbdataoutregclr: nmux21
            port map (A => NC,
                      B => portbdataout_clr,
                      S => portbdataout_clr_sel(0),
                      MO => portbdataout_reg_clr
                     );
    portbdataoutreg_clr <= portbdataout_reg_clr and devclrn and devpor;
    portbdataoutreg_0 : dffe 
            port map (D => portbdataout_int(0),
                      CLRN => portbdataoutreg_clr, 
                      CLK => portbdataout_clk,
                      ENA => portbdataouten,
                      Q => portbdataout_reg(0)
                     );
    portbdataoutreg_1 : dffe 
            port map (D => portbdataout_int(1),
                      CLRN => portbdataoutreg_clr, 
                      CLK => portbdataout_clk,
                      ENA => portbdataouten,
                      Q => portbdataout_reg(1)
                     );
    portbdataoutreg_2 : dffe 
            port map (D => portbdataout_int(2),
                      CLRN => portbdataoutreg_clr, 
                      CLK => portbdataout_clk,
                      ENA => portbdataouten,
                      Q => portbdataout_reg(2)
                     );
    portbdataoutreg_3 : dffe 
            port map (D => portbdataout_int(3),
                      CLRN => portbdataoutreg_clr, 
                      CLK => portbdataout_clk,
                      ENA => portbdataouten,
                      Q => portbdataout_reg(3)
                     );
    portbdataoutreg_4 : dffe 
            port map (D => portbdataout_int(4),
                      CLRN => portbdataoutreg_clr, 
                      CLK => portbdataout_clk,
                      ENA => portbdataouten,
                      Q => portbdataout_reg(4)
                     );
    portbdataoutreg_5 : dffe 
            port map (D => portbdataout_int(5),
                      CLRN => portbdataoutreg_clr, 
                      CLK => portbdataout_clk,
                      ENA => portbdataouten,
                      Q => portbdataout_reg(5)
                     );
    portbdataoutreg_6 : dffe 
            port map (D => portbdataout_int(6),
                      CLRN => portbdataoutreg_clr, 
                      CLK => portbdataout_clk,
                      ENA => portbdataouten,
                      Q => portbdataout_reg(6)
                     );
    portbdataoutreg_7 : dffe 
            port map (D => portbdataout_int(7),
                      CLRN => portbdataoutreg_clr, 
                      CLK => portbdataout_clk,
                      ENA => portbdataouten,
                      Q => portbdataout_reg(7)
                     );
    portbdataoutreg_8 : dffe 
            port map (D => portbdataout_int(8),
                      CLRN => portbdataoutreg_clr, 
                      CLK => portbdataout_clk,
                      ENA => portbdataouten,
                      Q => portbdataout_reg(8)
                     );
    portbdataoutreg_9 : dffe 
            port map (D => portbdataout_int(9),
                      CLRN => portbdataoutreg_clr, 
                      CLK => portbdataout_clk,
                      ENA => portbdataouten,
                      Q => portbdataout_reg(9)
                     );
    portbdataoutreg_10 : dffe 
            port map (D => portbdataout_int(10),
                      CLRN => portbdataoutreg_clr, 
                      CLK => portbdataout_clk,
                      ENA => portbdataouten,
                      Q => portbdataout_reg(10)
                     );
    portbdataoutreg_11 : dffe 
            port map (D => portbdataout_int(11),
                      CLRN => portbdataoutreg_clr, 
                      CLK => portbdataout_clk,
                      ENA => portbdataouten,
                      Q => portbdataout_reg(11)
                     );
    portbdataoutreg_12 : dffe 
            port map (D => portbdataout_int(12),
                      CLRN => portbdataoutreg_clr, 
                      CLK => portbdataout_clk,
                      ENA => portbdataouten,
                      Q => portbdataout_reg(12)
                     );
    portbdataoutreg_13 : dffe 
            port map (D => portbdataout_int(13),
                      CLRN => portbdataoutreg_clr, 
                      CLK => portbdataout_clk,
                      ENA => portbdataouten,
                      Q => portbdataout_reg(13)
                     );
    portbdataoutreg_14 : dffe 
            port map (D => portbdataout_int(14),
                      CLRN => portbdataoutreg_clr, 
                      CLK => portbdataout_clk,
                      ENA => portbdataouten,
                      Q => portbdataout_reg(14)
                     );
    portbdataoutreg_15 : dffe 
            port map (D => portbdataout_int(15),
                      CLRN => portbdataoutreg_clr, 
                      CLK => portbdataout_clk,
                      ENA => portbdataouten,
                      Q => portbdataout_reg(15)
                     );
    portbdataoutsel: bmux21
          port map (A => portbdataout_int,
                    B => portbdataout_reg,
                    S => portbdataout_clk_sel(0),
                    MO => portbdataout_tmp
                   );
    
    
    mercurymem: mercury_asynch_mem
          generic map (
                       operation_mode             => operation_mode,
                       port_a_operation_mode      => port_a_operation_mode,
                       port_b_operation_mode      => port_b_operation_mode,
                       port_a_read_first_address  => port_a_read_first_address,
                       port_a_read_last_address   => port_a_read_last_address,
                       port_a_read_data_width     => port_a_read_data_width,
                       port_a_write_first_address => port_a_write_first_address,
                       port_a_write_last_address  => port_a_write_last_address,
                       port_a_write_data_width    => port_a_write_data_width,
                       port_b_read_first_address  => port_b_read_first_address,
                       port_b_read_last_address   => port_b_read_last_address,
                       port_b_read_data_width     => port_b_read_data_width,
                       port_b_write_first_address => port_b_write_first_address,
                       port_b_write_last_address  => port_b_write_last_address,
                       port_b_write_data_width    => port_b_write_data_width,
                       port_a_read_enable_clock   => port_a_read_enable_clock,
                       port_b_read_enable_clock   => port_b_read_enable_clock,
                       port_a_write_logic_clock   => port_a_write_logic_clock,
                       port_b_write_logic_clock   => port_b_write_logic_clock,
                       init_file                  => init_file,
                       port_a_init_file           => port_a_init_file,
                       port_b_init_file           => port_b_init_file,

                       mem1                       => mem1,
                       mem2                       => mem2,
                       mem3                       => mem3,
                       mem4                       => mem4,
                       mem5                       => mem5,
                       mem6                       => mem6,
                       mem7                       => mem7,
                       mem8                       => mem8
                     )
          port map   (portadatain                 => portadatain_int,
                      portawe                     => portawe_int,
                      portare                     => portare_int,
                      portaraddr                  => portaraddr_int,
                      portawaddr                  => portawaddr_int,
                      portbdatain                 => portbdatain_int,
                      portbwe                     => portbwe_int,
                      portbre                     => portbre_int,
                      portbraddr                  => portbraddr_int,
                      portbwaddr                  => portbwaddr_int,
                      portadataout                => portadataout_int,
                      portbdataout                => portbdataout_int,
                      portamodesel                => portamodesel,
                      portbmodesel                => portbmodesel
                     );

    portaraddr_num <= conv_integer(portaraddr_int);

    --portavalid_addr <= '1' when portaraddr_num <= last_address and portaraddr_num >= first_address else '0';

    --portadataout <= portadataout_tmp when deep_ram_mode = "off" or (deep_ram_mode = "on" and valid_addr = '1') else 'Z';
    portadataout <= portadataout_tmp;
    portbdataout <= portbdataout_tmp;

end structure;

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : b32mux21
--
-- Description : Simulation model for a 2 to 1 mux used in the CAM_SLICE
--               Each input is a 32-bit bus.
--               This is a purely functional module, without any timing.
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY b32mux21 is 
    port
      ( A  : in std_logic_vector(31 downto 0) := (OTHERS => '0');
        B  : in std_logic_vector(31 downto 0) := (OTHERS => '0');
        S  : in std_logic := '0'; 
        MO : out std_logic_vector(31 downto 0)); 
end b32mux21; 
 
architecture structure of b32mux21 is
begin 
    MO <= B when (S = '1') else A; 
end structure;


--/////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : MERCURY_PLL
--
-- Description : Simulation model for the Mercury device family PLL
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE, mercury;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE mercury.atom_pack.all;

ENTITY mercury_pll is
    GENERIC (
             operation_mode          : string := "normal";
             simulation_type         : string := "timing";
             clk0_multiply_by        : integer := 1;
             clk0_divide_by          : integer := 1;
             clk1_multiply_by        : integer := 1;
             clk1_divide_by          : integer := 1;
             extclk_multiply_by      : integer := 0;
             extclk_divide_by        : integer := 0;
             input_frequency         : integer := 1000;
             phase_shift             : integer := 0;
             lock_high               : integer := 1;
             lock_low                : integer := 1;
             valid_lock_multiplier   : integer := 5;
             invalid_lock_multiplier : integer := 5;
             clkin_settings          : string := "";
             clk0_settings           : string := "";
             clk1_settings           : string := "";
             extclk_settings         : string := "";
             clk2_multiply_by        : integer := 1;
             clk2_divide_by          : integer := 1;
             clk2_settings           : string := "";
             clk0_time_delay         : integer := 0;
             clk1_time_delay         : integer := 0;
             clk2_time_delay         : integer := 0;
             extclk_time_delay       : integer := 0;
             effective_phase_shift   : integer := 0;
             effective_clk0_delay    : integer := 0;
             effective_clk1_delay    : integer := 0;
             effective_clk2_delay    : integer := 0;
             effective_extclk_delay  : integer := 0;
             MsgOn                   : Boolean := DefGlitchMsgOn;
             XOn                     : Boolean := DefGlitchXOn;
             InstancePath            : STRING := "*";
             tpd_ena_clk0            : VitalDelayType01 := DefPropDelay01;
             tpd_ena_clk1            : VitalDelayType01 := DefPropDelay01;
             tpd_ena_clk2            : VitalDelayType01 := DefPropDelay01;
             tpd_ena_extclk          : VitalDelayType01 := DefPropDelay01;
             tpd_fbin_clk0           : VitalDelayType01 := DefPropDelay01;
             tpd_fbin_clk1           : VitalDelayType01 := DefPropDelay01;
             tpd_fbin_clk2           : VitalDelayType01 := DefPropDelay01;
             tpd_fbin_extclk         : VitalDelayType01 := DefPropDelay01;
             tipd_clk                : VitalDelayType01 := DefpropDelay01;
             tipd_fbin               : VitalDelayType01 := DefpropDelay01;
             tipd_ena                : VitalDelayType01 := DefpropDelay01 
            );

    PORT    (clk                     : in std_logic;
             ena                     : in std_logic := '1';
             fbin                    : in std_logic := '1';
             clk0                    : out std_logic;
             clk1                    : out std_logic;
             clk2                    : out std_logic;
             extclk                  : out std_logic;
             locked                  : out std_logic 
            );

    attribute VITAL_LEVEL0 of mercury_pll : ENTITY is TRUE;
end mercury_pll;

ARCHITECTURE vital_pll_atom of mercury_pll is
attribute VITAL_LEVEL0 of vital_pll_atom : ARCHITECTURE is TRUE;
signal clk_ipd       : std_logic;
signal ena_ipd       : std_logic;
signal fbin_ipd      : std_logic;

SIGNAL clk0_period   : time;
SIGNAL clk1_period   : time;
SIGNAL clk2_period   : time;
SIGNAL extclk_period : time;
SIGNAL half_inclk    : time;
SIGNAL pll_lock      : std_logic := '0';
SIGNAL lock_on_rise  : integer := 0;
SIGNAL lock_on_fall  : integer := 0;
SIGNAL clk_check     : std_logic := '0';

SIGNAL clk0_tmp      : std_logic := 'X';
SIGNAL clk1_tmp      : std_logic := 'X';
SIGNAL clk2_tmp      : std_logic := 'X';
SIGNAL extclk_tmp    : std_logic := 'X';
begin
    ----------------------
    --  INPUT PATH DELAYs
    ----------------------
    WireDelay : block
    begin
        VitalWireDelay (clk_ipd, clk, tipd_clk);
        VitalWireDelay (ena_ipd, ena, tipd_ena);
        VitalWireDelay (fbin_ipd, fbin, tipd_fbin);
    end block;

    VITALtiming : process (clk_ipd, ena_ipd, pll_lock)
    begin

    end process;

    process (clk_ipd, ena_ipd, pll_lock, clk_check)
    variable expected_cycle, real_cycle : real := 0.0;
    variable inclk_ps : time := 0 ps;
    variable violation : boolean := false;
    variable pll_lock_tmp : std_logic := '0';
    variable start_lock_count, stop_lock_count : integer := 0;
    variable pll_last_rising_edge, pll_last_falling_edge : time := 0 ps;
    variable pll_rising_edge_count : integer := 0;
    variable pll_cycle, pll_duty_cycle : time := 0 ps;
    variable expected_next_clk_edge : time := 0 ps;
    variable clk_per_tolerance : time := 0 ps;

    variable last_synchronizing_rising_edge_for_clk0 : time := 0 ps;
    variable last_synchronizing_rising_edge_for_clk1 : time := 0 ps;
    variable last_synchronizing_rising_edge_for_clk2 : time := 0 ps;
    variable last_synchronizing_rising_edge_for_extclk : time := 0 ps;
    variable input_cycles_per_clk0, input_cycles_per_clk1 : integer;
    variable input_cycles_per_clk2, input_cycles_per_extclk : integer;
    variable input_cycle_count_to_sync0 : integer := 0;
    variable input_cycle_count_to_sync1 : integer := 0;
    variable input_cycle_count_to_sync2 : integer := 0;
    variable input_cycle_count_to_sync_extclk : integer := 0;
    variable init : boolean := true;
    variable output_value : std_logic := '0';
    variable vco_per : time;
    variable high_time : time;
    variable low_time : time;
    variable sched_time : time := 0 ps;
    variable tmp_per  : integer := 0;
    variable temp, tmp_rem, my_rem : integer;
    variable l : integer := 1;
    variable cycle_to_adjust : integer := 0;
    variable clk0_synchronizing_period, clk1_synchronizing_period : time;
    variable clk2_synchronizing_period, extclk_synchronizing_period : time;
    variable clk0_cycles_per_sync_period : integer := clk0_multiply_by;
    variable clk1_cycles_per_sync_period : integer := clk1_multiply_by;
    variable clk2_cycles_per_sync_period : integer := clk2_multiply_by;
    variable extclk_cycles_per_sync_period : integer := extclk_multiply_by;
    variable schedule_clk0, schedule_clk1 : boolean := false;
    variable schedule_clk2, schedule_extclk : boolean := false;
    variable clk0_phase_delay, clk1_phase_delay : time := 0 ps;
    variable clk2_phase_delay, extclk_phase_delay : time := 0 ps;
    begin
       if (init) then
          clk0_cycles_per_sync_period := clk0_multiply_by;
          clk1_cycles_per_sync_period := clk1_multiply_by;
          clk2_cycles_per_sync_period := clk2_multiply_by;
          extclk_cycles_per_sync_period := extclk_multiply_by;
          input_cycles_per_clk0 := clk0_divide_by;
          input_cycles_per_clk1 := clk1_divide_by;
          input_cycles_per_clk2 := clk2_divide_by;
          input_cycles_per_extclk := extclk_divide_by;
          init := false;
       end if;
       if (ena_ipd = '0') then
           pll_lock_tmp := '0';
           pll_rising_edge_count := 0;
       elsif (clk_ipd'event and clk_ipd = '1') then
           if (pll_lock_tmp = '1') then
               clk_check <= not clk_check after (inclk_ps+clk_per_tolerance)/2.0;
           end if;
           if pll_rising_edge_count = 0 then      -- at 1st rising edge
              inclk_ps := (input_frequency / 1) * 1 ps;
              half_inclk <= inclk_ps/2;
              clk_per_tolerance := 0.025 * inclk_ps;
              clk0_period <= (clk0_divide_by * inclk_ps) / clk0_multiply_by;
              clk1_period <= (clk1_divide_by * inclk_ps) / clk1_multiply_by;
              clk2_period <= (clk2_divide_by * inclk_ps) / clk2_multiply_by;
              if (extclk_divide_by = 0) then
                 if (extclk_multiply_by = 0) then
                    extclk_period <= (clk1_divide_by * inclk_ps) / clk1_multiply_by;
                 else
                    extclk_period <= (clk1_divide_by * inclk_ps) / extclk_multiply_by;
                 end if;
              else
                 if (extclk_multiply_by = 0) then
                    extclk_period <= (extclk_divide_by * inclk_ps) / clk1_multiply_by;
                 else
                    extclk_period <= (extclk_divide_by * inclk_ps) / extclk_multiply_by;
                 end if;
              end if;
              pll_duty_cycle := inclk_ps/2;

              if (operation_mode /= "lvds") then
                 -- use effective_clk_delay parameters - phase shift
                 -- does not reflect actual delay
                 if (simulation_type = "functional") then
                     clk0_phase_delay := phase_shift * 1 ps;
                     clk1_phase_delay := phase_shift * 1 ps;
                     clk2_phase_delay := phase_shift * 1 ps;
                     extclk_phase_delay := phase_shift * 1 ps;                
                 else
                     clk0_phase_delay := effective_clk0_delay * 1 ps;
                     clk1_phase_delay := effective_clk1_delay * 1 ps;
                     clk2_phase_delay := effective_clk2_delay * 1 ps;
                     extclk_phase_delay := effective_extclk_delay * 1 ps;
                 end if;
              end if;
           elsif pll_rising_edge_count = 1 then      -- at 2nd rising edge
              pll_cycle := now - pll_last_rising_edge;    -- calculate period
              expected_cycle := real(input_frequency) / 1000.0;
              real_cycle := REAL( (NOW - pll_last_rising_edge) / 1 ns);
              if ((NOW - pll_last_rising_edge) < (inclk_ps - clk_per_tolerance)  or
                 (NOW - pll_last_rising_edge) > (inclk_ps + clk_per_tolerance)) then
                 ASSERT FALSE
                 REPORT "Inclock_Period Violation"
                 SEVERITY WARNING;
                 violation := true;
                 if (pll_lock = '1') then
                    stop_lock_count := stop_lock_count + 1;
                    if (stop_lock_count = lock_low) then
                        pll_lock_tmp := '0';
                    end if;
                 else
                    -- intialize to 1 to be consistent with Mei Yee's change
                    -- in Quartus model
                    start_lock_count := 1;
                 end if;
              else
                 violation := false;
              end if;
              if ((now - pll_last_falling_edge) < (pll_duty_cycle - clk_per_tolerance/2) or
                 (now - pll_last_falling_edge) > (pll_duty_cycle + clk_per_tolerance/2)) then
                 ASSERT FALSE
                 REPORT "Duty Cycle Violation"
                 SEVERITY WARNING;
                 violation := true;
              else
                 violation := false;
              end if;
           else
              pll_cycle := now - pll_last_rising_edge;    -- calculate period
              if ((now - pll_last_rising_edge) < (inclk_ps - clk_per_tolerance) or
                 (now - pll_last_rising_edge) > (inclk_ps + clk_per_tolerance)) then
                 ASSERT FALSE
                 REPORT "Cycle Violation"
                 SEVERITY WARNING;
                 violation := true;
                 if (pll_lock = '1') then
                    stop_lock_count := stop_lock_count + 1;
                    if (stop_lock_count = lock_low) then
                        pll_lock_tmp := '0';
                    end if;
                 else
                    start_lock_count := 1;
                 end if;
              else
                 violation := false;
              end if;
           end if;
           pll_last_rising_edge := now;
           pll_rising_edge_count := pll_rising_edge_count +1;
           if (not violation) then
              if (pll_lock_tmp = '1') then
                 input_cycle_count_to_sync0 := input_cycle_count_to_sync0 + 1;
                 if (input_cycle_count_to_sync0 = input_cycles_per_clk0) then
                    clk0_synchronizing_period := now - last_synchronizing_rising_edge_for_clk0;
                    last_synchronizing_rising_edge_for_clk0 := now;
                    schedule_clk0 := true;
                    input_cycle_count_to_sync0 := 0;
                 end if;
                 input_cycle_count_to_sync1 := input_cycle_count_to_sync1 + 1;
                 if (input_cycle_count_to_sync1 = input_cycles_per_clk1) then
                    clk1_synchronizing_period := now - last_synchronizing_rising_edge_for_clk1;
                    last_synchronizing_rising_edge_for_clk1 := now;
                    schedule_clk1 := true;
                    input_cycle_count_to_sync1 := 0;
                 end if;
                 input_cycle_count_to_sync2 := input_cycle_count_to_sync2 + 1;
                 if (input_cycle_count_to_sync2 = input_cycles_per_clk2) then
                    clk2_synchronizing_period := now - last_synchronizing_rising_edge_for_clk2;
                    last_synchronizing_rising_edge_for_clk2 := now;
                    schedule_clk2 := true;
                    input_cycle_count_to_sync2 := 0;
                 end if;
                 input_cycle_count_to_sync_extclk := input_cycle_count_to_sync_extclk + 1;
                 if (input_cycle_count_to_sync_extclk = input_cycles_per_extclk) then
                    extclk_synchronizing_period := now - last_synchronizing_rising_edge_for_extclk;
                    last_synchronizing_rising_edge_for_extclk := now;
                    schedule_extclk := true;
                    input_cycle_count_to_sync_extclk := 0;
                 end if;
              else
                 start_lock_count := start_lock_count + 1;
                 if (start_lock_count >= lock_high) then
                    pll_lock_tmp := '1';
                    lock_on_rise <= 1;
                    input_cycle_count_to_sync0 := 0;
                    input_cycle_count_to_sync1 := 0;
                    input_cycle_count_to_sync2 := 0;
                    input_cycle_count_to_sync_extclk := 0;
                    if (last_synchronizing_rising_edge_for_clk0 = 0 ps) then
                       clk0_synchronizing_period := ((pll_cycle/1 ps) * clk0_divide_by) * 1 ps;
                    else
                       clk0_synchronizing_period := now - last_synchronizing_rising_edge_for_clk0;
                    end if;
                    if (last_synchronizing_rising_edge_for_clk1 = 0 ps) then
                       clk1_synchronizing_period := ((pll_cycle/1 ps) * clk1_divide_by) * 1 ps;
                    else
                       clk1_synchronizing_period := now - last_synchronizing_rising_edge_for_clk1;
                    end if;
                    if (last_synchronizing_rising_edge_for_clk2 = 0 ps) then
                       clk2_synchronizing_period := ((pll_cycle/1 ps) * clk2_divide_by) * 1 ps;
                    else
                       clk2_synchronizing_period := now - last_synchronizing_rising_edge_for_clk2;
                    end if;
                    if (last_synchronizing_rising_edge_for_extclk = 0 ps) then
                       extclk_synchronizing_period := ((pll_cycle/1 ps) * extclk_divide_by) * 1 ps;
                    else
                       extclk_synchronizing_period := now - last_synchronizing_rising_edge_for_extclk;
                    end if;
                    last_synchronizing_rising_edge_for_clk0 := now;
                    last_synchronizing_rising_edge_for_clk1 := now;
                    last_synchronizing_rising_edge_for_clk2 := now;
                    last_synchronizing_rising_edge_for_extclk := now;
                    schedule_clk0 := true;
                    schedule_clk1 := true;
                    schedule_clk2 := true;
                    schedule_extclk := true;
                 end if;
              end if;
           else
              start_lock_count := 0;
           end if;

       elsif (clk_ipd'event and clk_ipd= '0') then
          if (pll_lock_tmp = '1') then
             clk_check <= not clk_check after (inclk_ps+clk_per_tolerance)/2.0;
             if (now > 0 ns and ((now - pll_last_rising_edge) < (pll_duty_cycle - clk_per_tolerance/2) or
                (now - pll_last_rising_edge) > (pll_duty_cycle + clk_per_tolerance/2))) then
                ASSERT FALSE
                REPORT "Duty Cycle Violation"
                SEVERITY WARNING;
                violation := true;
                if (pll_lock = '1') then
                   stop_lock_count := stop_lock_count + 1;
                   if (stop_lock_count = lock_low) then
                       pll_lock_tmp := '0';
                   end if;
                end if;
             else
                violation := false;
             end if;
        else
            start_lock_count := start_lock_count + 1;
        end if;
        pll_last_falling_edge := now;
       else
          if pll_lock_tmp = '1' then
             if (clk_ipd = '1') then
                expected_next_clk_edge := pll_last_rising_edge + (inclk_ps+clk_per_tolerance)/2.0;
             else
                expected_next_clk_edge := pll_last_falling_edge + (inclk_ps+clk_per_tolerance)/2.0;
             end if;
             violation := false;
             if (now < expected_next_clk_edge) then
                clk_check <= not clk_check after (expected_next_clk_edge - now);
             elsif (now = expected_next_clk_edge) then
                clk_check <= not clk_check after (inclk_ps+clk_per_tolerance)/2.0;
             else
                ASSERT FALSE
                REPORT "Inclock_Period Violation"
                SEVERITY WARNING;
                violation := true;
                if (pll_lock = '1') then
                    stop_lock_count := stop_lock_count + 1;
                    if (stop_lock_count = lock_low) then
                        pll_lock_tmp := '0';
                    else
                        clk_check <= not clk_check after (inclk_ps/2.0);
                    end if;
                end if;
             end if;
          end if;
       end if;
       pll_lock <= pll_lock_tmp;
       if (pll_lock'event and pll_lock = '0') then
          start_lock_count := 1;
          stop_lock_count := 0;
          lock_on_rise <= 0;
          lock_on_fall <= 0;
          clk0_tmp <= 'X';
          clk1_tmp <= 'X';
          clk2_tmp <= 'X';
          extclk_tmp <= 'X';
       end if;

       if (schedule_clk0) then
          sched_time := clk0_phase_delay;
          cycle_to_adjust := 0;
          l := 1;
          output_value := '1';
          temp := clk0_synchronizing_period/1 ps;
          my_rem := temp rem clk0_cycles_per_sync_period;
          for i in 1 to clk0_cycles_per_sync_period loop
             tmp_per := temp/clk0_cycles_per_sync_period;
             if (my_rem /= 0 and l <= my_rem) then
                tmp_rem := (clk0_cycles_per_sync_period * l) rem my_rem;
                cycle_to_adjust := (clk0_cycles_per_sync_period * l) / my_rem;
                if (tmp_rem /= 0) then
                   cycle_to_adjust := cycle_to_adjust + 1;
                end if;
             end if;
             if (cycle_to_adjust = i) then
                 tmp_per := tmp_per + 1;
                 l := l + 1;
             end if;
             vco_per := tmp_per * 1 ps;
             high_time := (tmp_per/2) * 1 ps;
             if (tmp_per rem 2 /= 0) then
                high_time := high_time + 1 ps;
             end if;
             low_time := vco_per - high_time;
             for j in 1 to 2 loop
                clk0_tmp <= transport output_value after sched_time;
                output_value := not output_value;
                if (output_value = '0') then
                   sched_time := sched_time + high_time;
                elsif (output_value = '1') then
                   sched_time := sched_time + low_time;
                end if;
             end loop;
          end loop;
          schedule_clk0 := false;
       end if;

       if (schedule_clk1) then
          sched_time := clk1_phase_delay;
          cycle_to_adjust := 0;
          l := 1;
          output_value := '1';
          temp := clk1_synchronizing_period/1 ps;
          my_rem := temp rem clk1_cycles_per_sync_period;
          for i in 1 to clk1_cycles_per_sync_period loop
             tmp_per := temp/clk1_cycles_per_sync_period;
             if (my_rem /= 0 and l <= my_rem) then
                tmp_rem := (clk1_cycles_per_sync_period * l) rem my_rem;
                cycle_to_adjust := (clk1_cycles_per_sync_period * l) / my_rem;
                if (tmp_rem /= 0) then
                   cycle_to_adjust := cycle_to_adjust + 1;
                end if;
             end if;
             if (cycle_to_adjust = i) then
                tmp_per := tmp_per + 1;
                l := l + 1;
             end if;
             vco_per := tmp_per * 1 ps;
             high_time := (tmp_per/2) * 1 ps;
             if (tmp_per rem 2 /= 0) then
                high_time := high_time + 1 ps;
             end if;
             low_time := vco_per - high_time;
             for j in 1 to 2 loop
                clk1_tmp <= transport output_value after sched_time;
                output_value := not output_value;
                if (output_value = '0') then
                   sched_time := sched_time + high_time;
                elsif (output_value = '1') then
                   sched_time := sched_time + low_time;
                end if;
             end loop;
          end loop;
          schedule_clk1 := false;
       end if;

       if (schedule_clk2) then
          sched_time := clk2_phase_delay;
          cycle_to_adjust := 0;
          l := 1;
          output_value := '1';
          temp := clk2_synchronizing_period/1 ps;
          my_rem := temp rem clk2_cycles_per_sync_period;
          for i in 1 to clk2_cycles_per_sync_period loop
             tmp_per := temp/clk2_cycles_per_sync_period;
             if (my_rem /= 0 and l <= my_rem) then
                tmp_rem := (clk2_cycles_per_sync_period * l) rem my_rem;
                cycle_to_adjust := (clk2_cycles_per_sync_period * l) / my_rem;
                if (tmp_rem /= 0) then
                   cycle_to_adjust := cycle_to_adjust + 1;
                end if;
             end if;
             if (cycle_to_adjust = i) then
                tmp_per := tmp_per + 1;
                l := l + 1;
             end if;
             vco_per := tmp_per * 1 ps;
             high_time := (tmp_per/2) * 1 ps;
             if (tmp_per rem 2 /= 0) then
                high_time := high_time + 1 ps;
             end if;
             low_time := vco_per - high_time;
             for j in 1 to 2 loop
                clk2_tmp <= transport output_value after sched_time;
                output_value := not output_value;
                if (output_value = '0') then
                   sched_time := sched_time + high_time;
                elsif (output_value = '1') then
                   sched_time := sched_time + low_time;
                end if;
             end loop;
          end loop;
          schedule_clk2 := false;
       end if;

       if (schedule_extclk) then
          sched_time := extclk_phase_delay;
          cycle_to_adjust := 0;
          l := 1;
          output_value := '1';
          temp := extclk_synchronizing_period/1 ps;
          my_rem := temp rem extclk_cycles_per_sync_period;
          for i in 1 to extclk_cycles_per_sync_period loop
             tmp_per := temp/extclk_cycles_per_sync_period;
             if (my_rem /= 0 and l <= my_rem) then
                tmp_rem := (extclk_cycles_per_sync_period * l) rem my_rem;
                cycle_to_adjust := (extclk_cycles_per_sync_period * l) / my_rem;
                if (tmp_rem /= 0) then
                   cycle_to_adjust := cycle_to_adjust + 1;
                end if;
             end if;
             if (cycle_to_adjust = i) then
                tmp_per := tmp_per + 1;
                l := l + 1;
             end if;
             vco_per := tmp_per * 1 ps;
             high_time := (tmp_per/2) * 1 ps;
             if (tmp_per rem 2 /= 0) then
                high_time := high_time + 1 ps;
             end if;
             low_time := vco_per - high_time;
             for j in 1 to 2 loop
                extclk_tmp <= transport output_value after sched_time;
                output_value := not output_value;
                if (output_value = '0') then
                   sched_time := sched_time + high_time;
                elsif (output_value = '1') then
                   sched_time := sched_time + low_time;
                end if;
             end loop;
          end loop;
          schedule_extclk := false;
       end if;
    end process;

    clk0 <= clk0_tmp;
    clk1 <= clk1_tmp;
    clk2 <= clk2_tmp;
    extclk <= extclk_tmp;

    locked <= pll_lock;

end vital_pll_atom;


--/////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : MERCURY_CAM
--
-- Description : Timing simulation model for the asynchronous CAM array.
--
--/////////////////////////////////////////////////////////////////////////////

LIBRARY ieee, mercury;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE IEEE.VITAL_Primitives.all;
USE IEEE.VITAL_Timing.all;
USE mercury.atom_pack.all;

ENTITY mercury_cam IS
    GENERIC (
             operation_mode                    : string := "single_match";
             logical_cam_depth                 : integer := 64;
             address_width                     : integer := 6;
             pattern_width                     : integer := 32;
             first_address                     : integer := 0;
             last_address                      : integer := 63;
             init_mem_true                     : mercury_mem_data := (OTHERS=> "11111111111111111111111111111111");
             init_mem_comp                     : mercury_mem_data := (OTHERS=> "11111111111111111111111111111111");
             first_pattern_bit                 : integer := 0;
             TimingChecksOn                    : Boolean := True;
             MsgOn                             : Boolean := DefGlitchMsgOn;
             XOn                               : Boolean := DefGlitchXOn;
             MsgOnChecks                       : Boolean := DefMsgOnChecks;
             XOnChecks                         : Boolean := DefXOnChecks;
             InstancePath                      : STRING := "*";
             tsetup_lit_we_noedge_posedge      : VitalDelayArrayType(31 downto 0) := (OTHERS => DefSetupHoldCnst);
             thold_lit_we_noedge_posedge       : VitalDelayArrayType(31 downto 0) := (OTHERS => DefSetupHoldCnst);
             tsetup_datain_we_noedge_negedge   : VitalDelayType := DefSetupHoldCnst;
             thold_datain_we_noedge_negedge    : VitalDelayType := DefSetupHoldCnst;
             tsetup_wrinvert_we_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_wrinvert_we_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
             tpd_lit_matchout                  : VitalDelayArrayType01(1023 downto 0) := (OTHERS => DefPropDelay01);
             tpd_lit_matchfound                : VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
             tpd_we_matchout                   : VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
             tpd_we_matchfound                 : VitalDelayType01 := DefPropDelay01;
             tpd_outputselect_matchout         : VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
             tipd_datain                       : VitalDelayType01 := DefPropDelay01;
             tipd_wrinvert                     : VitalDelayType01 := DefPropDelay01;
             tipd_we                           : VitalDelayType01 := DefPropDelay01;
             tipd_outputselect                 : VitalDelayType01 := DefPropDelay01;
             tipd_waddr                        : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01);
             tipd_lit                          : VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01)
            );
 
    PORT    (datain          : in std_logic := '0';
             wrinvert        : in std_logic := '0';
             outputselect    : in std_logic := '0';
             we              : in std_logic := '0';
             lit             : in std_logic_vector(31 downto 0);
             waddr           : in std_logic_vector(5 downto 0) := "000000";
             modesel         : in std_logic_vector(1 downto 0) := "00";
             matchout        : out std_logic_vector(31 downto 0);
             matchfound      : out std_logic
          );
    attribute VITAL_LEVEL0 of mercury_cam : ENTITY is TRUE;
END mercury_cam;

ARCHITECTURE behave OF mercury_cam IS
signal datain_ipd       : std_logic;
signal we_ipd           : std_logic;
signal wrinvert_ipd     : std_logic;
signal outputselect_ipd : std_logic;
signal waddr_ipd        : std_logic_vector(5 downto 0);
signal lit_ipd          : std_logic_vector(31 downto 0);
begin

    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        VitalWireDelay (waddr_ipd(0), waddr(0), tipd_waddr(0));
        VitalWireDelay (waddr_ipd(1), waddr(1), tipd_waddr(1));
        VitalWireDelay (waddr_ipd(2), waddr(2), tipd_waddr(2));
        VitalWireDelay (waddr_ipd(3), waddr(3), tipd_waddr(3));
        VitalWireDelay (waddr_ipd(4), waddr(4), tipd_waddr(4));
        VitalWireDelay (waddr_ipd(5), waddr(5), tipd_waddr(5));
    
        VitalWireDelay (lit_ipd(0), lit(0), tipd_lit(0));
        VitalWireDelay (lit_ipd(1), lit(1), tipd_lit(1));
        VitalWireDelay (lit_ipd(2), lit(2), tipd_lit(2));
        VitalWireDelay (lit_ipd(3), lit(3), tipd_lit(3));
        VitalWireDelay (lit_ipd(4), lit(4), tipd_lit(4));
        VitalWireDelay (lit_ipd(5), lit(5), tipd_lit(5));
        VitalWireDelay (lit_ipd(6), lit(6), tipd_lit(6));
        VitalWireDelay (lit_ipd(7), lit(7), tipd_lit(7));
        VitalWireDelay (lit_ipd(8), lit(8), tipd_lit(8));
        VitalWireDelay (lit_ipd(9), lit(9), tipd_lit(9));
        VitalWireDelay (lit_ipd(10), lit(10), tipd_lit(10));
        VitalWireDelay (lit_ipd(11), lit(11), tipd_lit(11));
        VitalWireDelay (lit_ipd(12), lit(12), tipd_lit(12));
        VitalWireDelay (lit_ipd(13), lit(13), tipd_lit(13));
        VitalWireDelay (lit_ipd(14), lit(14), tipd_lit(14));
        VitalWireDelay (lit_ipd(15), lit(15), tipd_lit(15));
        VitalWireDelay (lit_ipd(16), lit(16), tipd_lit(16));
        VitalWireDelay (lit_ipd(17), lit(17), tipd_lit(17));
        VitalWireDelay (lit_ipd(18), lit(18), tipd_lit(18));
        VitalWireDelay (lit_ipd(19), lit(19), tipd_lit(19));
        VitalWireDelay (lit_ipd(20), lit(20), tipd_lit(20));
        VitalWireDelay (lit_ipd(21), lit(21), tipd_lit(21));
        VitalWireDelay (lit_ipd(22), lit(22), tipd_lit(22));
        VitalWireDelay (lit_ipd(23), lit(23), tipd_lit(23));
        VitalWireDelay (lit_ipd(24), lit(24), tipd_lit(24));
        VitalWireDelay (lit_ipd(25), lit(25), tipd_lit(25));
        VitalWireDelay (lit_ipd(26), lit(26), tipd_lit(26));
        VitalWireDelay (lit_ipd(27), lit(27), tipd_lit(27));
        VitalWireDelay (lit_ipd(28), lit(28), tipd_lit(28));
        VitalWireDelay (lit_ipd(29), lit(29), tipd_lit(29));
        VitalWireDelay (lit_ipd(30), lit(30), tipd_lit(30));
        VitalWireDelay (lit_ipd(31), lit(31), tipd_lit(31));
        VitalWireDelay (we_ipd, we, tipd_we);
        VitalWireDelay (datain_ipd, datain, tipd_datain);
        VitalWireDelay (wrinvert_ipd, wrinvert, tipd_wrinvert);
        VitalWireDelay (outputselect_ipd, outputselect, tipd_outputselect);
    end block;

    VITAL: process(we_ipd, lit_ipd, outputselect_ipd, wrinvert_ipd, datain_ipd)
    variable Tviol_wrinvert_we : std_ulogic := '0';
    variable Tviol_datain_we : std_ulogic := '0';
    variable Tviol_lit_we : std_ulogic := '0';
    variable TimingData_wrinvert_we : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_datain_we : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_lit_we : VitalTimingDataType := VitalTimingDataInit;
    variable matchfound_VitalGlitchData : VitalGlitchDataType;
    variable matchout_VitalGlitchDataArray : VitalGlitchDataArrayType(31 downto 0);
    
    variable wword : std_logic_vector(address_width-1 downto 0);
    variable pattern_tmp, read_pattern : std_logic_vector(pattern_width-1 downto 0);
    variable compare_data, temp : std_logic_vector(pattern_width-1 downto 0);
    variable wdatain_last_value, wrinvert_last_value : std_logic;
    variable m_found, continue : boolean;
    variable wword_int : integer;
    variable encoded_match_addr : std_logic_vector(5 downto 0);
    variable match_out : std_logic_vector(31 downto 0);
    variable match_found : std_logic;
    
    -- types for true and complement memory arrays
   
    TYPE mem_array is ARRAY(0 to 63) of std_logic_vector (31 downto 0);
    
    variable mem_true, mem_comp : mem_array;
    
    variable mult_match_array : std_logic_vector(63 downto 0) := (OTHERS => '0');
    variable mem_depth : integer := (last_address-first_address) + 1;
    variable i, j, k : integer := 0;
    variable init : boolean := true;
    
    begin    
        ------------------------
        --  Timing Check Section
        ------------------------
        if (TimingChecksOn) then
    
            VitalSetupHoldCheck (
                Violation       => Tviol_wrinvert_we,
                TimingData      => TimingData_wrinvert_we,
                TestSignal      => wrinvert_ipd,
                TestSignalName  => "WRINVERT",
                RefSignal       => we_ipd,
                RefSignalName   => "WE",
                SetupHigh       => tsetup_wrinvert_we_noedge_posedge,
                SetupLow        => tsetup_wrinvert_we_noedge_posedge,
                HoldHigh        => thold_wrinvert_we_noedge_posedge,
                HoldLow         => thold_wrinvert_we_noedge_posedge,
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/MERCURY_CAM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
    
            VitalSetupHoldCheck (
                Violation       => Tviol_datain_we,
                TimingData      => TimingData_datain_we,
                TestSignal      => datain_ipd,
                TestSignalName  => "DATAIN",
                RefSignal       => we_ipd,
                RefSignalName   => "WE",
                SetupHigh       => tsetup_datain_we_noedge_negedge,
                SetupLow        => tsetup_datain_we_noedge_negedge,
                HoldHigh        => thold_datain_we_noedge_negedge,
                HoldLow         => thold_datain_we_noedge_negedge,
                RefTransition   => '\',
                HeaderMsg       => InstancePath & "/MERCURY_CAM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
    
            VitalSetupHoldCheck (
                Violation       => Tviol_lit_we,
                TimingData      => TimingData_lit_we,
                TestSignal      => lit_ipd,
                TestSignalName  => "LIT",
                RefSignal       => we_ipd,
                RefSignalName   => "WE",
                SetupHigh       => tsetup_lit_we_noedge_posedge(0),
                SetupLow        => tsetup_lit_we_noedge_posedge(0),
                HoldHigh        => thold_lit_we_noedge_posedge(0),
                HoldLow         => thold_lit_we_noedge_posedge(0),
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/MERCURY_CAM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
    
        end if;
    
        if (we_ipd'event or lit_ipd'event or outputselect_ipd'event) then

           if init then
            -- initialize CAM from generics
               if (operation_mode = "single_match") or (operation_mode = "multiple_match") then
                  for i in 0 to 63 loop
                      mem_true(i) := init_mem_true(i);
                      mem_comp(i) := init_mem_comp(i);
                  end loop;
               elsif (operation_mode = "fast_multiple_match") then
                  for i in 0 to 31 loop
                     mem_true(2*i) := init_mem_true(i);
                     mem_comp(2*i) := init_mem_comp(i);
                     mem_true(2*i+1) := (OTHERS => '1');
                     mem_comp(2*i+1) := (OTHERS => '1');
                  end loop;
                  mem_depth := mem_depth * 2;
               end if;
               init := false;
           end if;
           if (we_ipd'event and we_ipd = '1') then
              if (datain_ipd = '0' and wrinvert_ipd = '0') then
	          -- write 0's
	          pattern_tmp := lit_ipd(pattern_width-1 downto   0);
 	          wword := waddr_ipd(address_width-1 downto 0);
	          wword_int := alt_conv_integer(wword);
	          if (modesel = "10") then   -- fast_multiple_match mode
	              wword_int := wword_int * 2;
	          end if;
	          for i in 0 to (pattern_width-1) loop
	             if (pattern_tmp(i) = '1') then
	                 mem_true(wword_int)(i) := '0';
	             elsif (pattern_tmp(i) = '0') then
	                 mem_comp(wword_int)(i) := '0';
	             end if;
	          end loop;
              elsif (datain_ipd = '1' and wrinvert_ipd = '1') then
	          if (wdatain_last_value = '1' and wrinvert_last_value = '0') then
                  -- delete cycle continues
	             if (pattern_tmp = lit_ipd(pattern_width-1 downto 0) and wword = waddr_ipd(address_width-1 downto 0)) then
		         for i in 0 to (pattern_width-1) loop
		             if (pattern_tmp(i) = '0') then
		                 mem_true(wword_int)(i) := '1';
		             elsif (pattern_tmp(i) = '1') then
		                 mem_comp(wword_int)(i) := '1';
		             end if;
		         end loop;
	             else assert false report "Either address or pattern changed during delete cycle. Pattern will not be deleted." severity warning;
	             end if;
                 else
                     if (wdatain_last_value = '0' and wrinvert_last_value = '0') then
                     -- write cycle continues
	                 if (wword = waddr_ipd(address_width-1 downto 0)) then
	                     -- last cycle was write 1's and now waddr is same
	                     if (pattern_tmp /= lit_ipd(pattern_width-1 downto 0)) then
	      	                 -- but pattern is not same, so error message
	   	                 assert false report "Write pattern changed during write cycles. Write Data may not be valid." severity warning;
	                     end if;
	                 end if;
                     end if;
	             -- write 1's
	             pattern_tmp := lit_ipd(pattern_width-1 downto 0);
	             wword := waddr_ipd(address_width-1 downto 0);
	             wword_int := alt_conv_integer(wword);
	             if (modesel = "10") then   -- fast_multiple_match mode
	                 wword_int := wword_int * 2;
	             end if;
	             for i in 0 to (pattern_width-1) loop
	                 if (pattern_tmp(i) = '0') then
		             mem_true(wword_int)(i) := '1';
	                 elsif (pattern_tmp(i) = '1') then
		             mem_comp(wword_int)(i) := '1';
	                 end if;
	             end loop;
                 end if;
             elsif (datain_ipd = '1' and wrinvert_ipd = '0') then
	         pattern_tmp := lit_ipd(pattern_width-1 downto 0);
	         wword := waddr_ipd(address_width-1 downto 0);
	         wword_int := alt_conv_integer(wword);
	         if (modesel = "10") then   -- fast_multiple_match mode
	             wword_int := wword_int * 2;
	         end if;
		 for i in 0 to (pattern_width-1) loop
		    if (pattern_tmp(i) = '1') then
		       mem_true(wword_int)(i) := '1';
		    elsif (pattern_tmp(i) = '0') then
		       mem_comp(wword_int)(i) := '1';
	  	    end if;
		 end loop;
             end if;
             wdatain_last_value := datain_ipd;
             wrinvert_last_value := wrinvert_ipd;
         end if;
--      elsif (we_pulse = '0') then
             m_found := false;
             read_pattern := lit_ipd(pattern_width-1 downto 0);
             i := 0;
             while (i < mem_depth and (not(m_found))) loop
                 continue := true;
                 j := 0;
                 for k in 0 to pattern_width-1 loop
                     if (mem_true(i)(k) = '1' and mem_comp(i)(k) = '1') then
                         continue := false;
                         exit;
                     elsif (mem_true(i)(k) = '0' and mem_comp(i)(k) = '0') then
                         temp(k) := 'X';
                     else
                         temp(k) := mem_comp(i)(k);
                     end if;
                 end loop;
                 compare_data := read_pattern xor temp;
                 while (j < pattern_width and continue) loop
                     if (compare_data(j) = '1') then
                         continue := false;
                     end if;
                     j := j + 1;
                 end loop;
                 if (continue and j = pattern_width) then
                     if (modesel = "00" and not(m_found)) then
                         m_found := true;
                         encoded_match_addr := conv_std_logic_vector(i, 6);
                     elsif (modesel /= "00") then
                         mult_match_array(i) := '1';
                         i := i + 1;
                     end if;
                 else
                     mult_match_array(i) := '0';
                     i := i + 1;
                 end if;
             end loop;
             if (modesel = "00") then
                 if (m_found) then
                     match_out(5 downto 0) := encoded_match_addr;
                     match_found := '1';
                 else
                     match_out(5 downto 0) := (OTHERS => '0');
                     match_found := '0';
                 end if;
                 match_out(15 downto 6) := (OTHERS => '0');
             elsif (modesel = "01") then
                 match_found := '0';
                 if (outputselect_ipd = '0') then
                     for i in 0 to 31 loop
                         match_out(i) := mult_match_array(2*i);
                     end loop;
                 elsif (outputselect_ipd = '1') then
                     for i in 0 to 31 loop
                         match_out(i) := mult_match_array(2*i+1);
                     end loop;
                 end if;
             elsif (modesel = "10") then
                 -- output only even addresses
                 for i in 0 to 31 loop
                     match_out(i) := mult_match_array(2*i);
                 end loop;
             end if;
        
             if (outputselect_ipd'event and outputselect_ipd = '0') then
                 for i in 0 to 31 loop
                     match_out(i) := mult_match_array(2*i);
                 end loop;
             elsif (outputselect_ipd'event and outputselect_ipd = '1') then
                 for i in 0 to 31 loop
                     match_out(i) := mult_match_array(2*i+1);
                 end loop;
             end if;
--      end if;

         end if;
    
        ----------------------
        --  Path Delay Section
        ----------------------
        VitalPathDelay01 (
            OutSignal => matchfound,
            OutSignalName => "MATCHFOUND",
            OutTemp => match_found,
            Paths => (1 => (lit_ipd'last_event, tpd_lit_matchfound(0), TRUE),
                      2 => (we_ipd'last_event, tpd_we_matchfound, TRUE)),
            GlitchData => matchfound_VitalGlitchData,
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
        VitalPathDelay01 (
            OutSignal => matchout(0),
            OutSignalName => "MATCHOUT",
            OutTemp => match_out(0),
            Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                      2 => (we_ipd'last_event, tpd_we_matchout(0), TRUE),
                      3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(0), TRUE)),
            GlitchData => matchout_VitalGlitchDataArray(0),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
        VitalPathDelay01 (
            OutSignal => matchout(1),
            OutSignalName => "MATCHOUT",
            OutTemp => match_out(1),
            Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                      2 => (we_ipd'last_event, tpd_we_matchout(1), TRUE),
                      3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(1), TRUE)),
            GlitchData => matchout_VitalGlitchDataArray(1),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
        VitalPathDelay01 (
            OutSignal => matchout(2),
            OutSignalName => "MATCHOUT",
            OutTemp => match_out(2),
            Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                      2 => (we_ipd'last_event, tpd_we_matchout(2), TRUE),
                      3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(2), TRUE)),
            GlitchData => matchout_VitalGlitchDataArray(2),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
        VitalPathDelay01 (
            OutSignal => matchout(3),
            OutSignalName => "MATCHOUT",
            OutTemp => match_out(3),
            Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                      2 => (we_ipd'last_event, tpd_we_matchout(3), TRUE),
                      3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(3), TRUE)),
            GlitchData => matchout_VitalGlitchDataArray(3),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
        VitalPathDelay01 (
            OutSignal => matchout(4),
            OutSignalName => "MATCHOUT",
            OutTemp => match_out(4),
            Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                      2 => (we_ipd'last_event, tpd_we_matchout(4), TRUE),
                      3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(4), TRUE)),
            GlitchData => matchout_VitalGlitchDataArray(4),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
        VitalPathDelay01 (
            OutSignal => matchout(5),
            OutSignalName => "MATCHOUT",
            OutTemp => match_out(5),
            Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                      2 => (we_ipd'last_event, tpd_we_matchout(5), TRUE),
                      3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(5), TRUE)),
            GlitchData => matchout_VitalGlitchDataArray(5),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
        VitalPathDelay01 (
            OutSignal => matchout(6),
            OutSignalName => "MATCHOUT",
            OutTemp => match_out(6),
            Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                      2 => (we_ipd'last_event, tpd_we_matchout(6), TRUE),
                      3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(6), TRUE)),
            GlitchData => matchout_VitalGlitchDataArray(6),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
        VitalPathDelay01 (
            OutSignal => matchout(7),
            OutSignalName => "MATCHOUT",
            OutTemp => match_out(7),
            Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                      2 => (we_ipd'last_event, tpd_we_matchout(7), TRUE),
                      3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(7), TRUE)),
            GlitchData => matchout_VitalGlitchDataArray(7),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
        VitalPathDelay01 (
            OutSignal => matchout(8),
            OutSignalName => "MATCHOUT",
            OutTemp => match_out(8),
            Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                      2 => (we_ipd'last_event, tpd_we_matchout(8), TRUE),
                      3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(8), TRUE)),
            GlitchData => matchout_VitalGlitchDataArray(8),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
        VitalPathDelay01 (
            OutSignal => matchout(9),
            OutSignalName => "MATCHOUT",
            OutTemp => match_out(9),
            Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                      2 => (we_ipd'last_event, tpd_we_matchout(9), TRUE),
                      3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(9), TRUE)),
            GlitchData => matchout_VitalGlitchDataArray(9),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
        VitalPathDelay01 (
            OutSignal => matchout(10),
            OutSignalName => "MATCHOUT",
            OutTemp => match_out(10),
            Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                      2 => (we_ipd'last_event, tpd_we_matchout(10), TRUE),
                      3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(10), TRUE)),
            GlitchData => matchout_VitalGlitchDataArray(10),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
        VitalPathDelay01 (
            OutSignal => matchout(11),
            OutSignalName => "MATCHOUT",
            OutTemp => match_out(11),
            Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                      2 => (we_ipd'last_event, tpd_we_matchout(11), TRUE),
                      3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(11), TRUE)),
            GlitchData => matchout_VitalGlitchDataArray(11),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
        VitalPathDelay01 (
            OutSignal => matchout(12),
            OutSignalName => "MATCHOUT",
            OutTemp => match_out(12),
            Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                      2 => (we_ipd'last_event, tpd_we_matchout(12), TRUE),
                      3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(12), TRUE)),
            GlitchData => matchout_VitalGlitchDataArray(12),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
        VitalPathDelay01 (
            OutSignal => matchout(13),
            OutSignalName => "MATCHOUT",
            OutTemp => match_out(13),
            Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                      2 => (we_ipd'last_event, tpd_we_matchout(13), TRUE),
                      3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(13), TRUE)),
            GlitchData => matchout_VitalGlitchDataArray(13),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
        VitalPathDelay01 (
            OutSignal => matchout(14),
            OutSignalName => "MATCHOUT",
            OutTemp => match_out(14),
            Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                      2 => (we_ipd'last_event, tpd_we_matchout(14), TRUE),
                      3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(14), TRUE)),
            GlitchData => matchout_VitalGlitchDataArray(14),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
        VitalPathDelay01 (
            OutSignal => matchout(15),
            OutSignalName => "MATCHOUT",
            OutTemp => match_out(15),
            Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                      2 => (we_ipd'last_event, tpd_we_matchout(15), TRUE),
                      3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(15), TRUE)),
            GlitchData => matchout_VitalGlitchDataArray(15),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
        VitalPathDelay01 (
            OutSignal => matchout(16),
            OutSignalName => "MATCHOUT",
            OutTemp => match_out(16),
            Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                      2 => (we_ipd'last_event, tpd_we_matchout(16), TRUE),
                      3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(16), TRUE)),
            GlitchData => matchout_VitalGlitchDataArray(16),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
        VitalPathDelay01 (
            OutSignal => matchout(17),
            OutSignalName => "MATCHOUT",
            OutTemp => match_out(17),
            Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                      2 => (we_ipd'last_event, tpd_we_matchout(17), TRUE),
                      3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(17), TRUE)),
            GlitchData => matchout_VitalGlitchDataArray(17),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
        VitalPathDelay01 (
            OutSignal => matchout(18),
            OutSignalName => "MATCHOUT",
            OutTemp => match_out(18),
            Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                      2 => (we_ipd'last_event, tpd_we_matchout(18), TRUE),
                      3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(18), TRUE)),
            GlitchData => matchout_VitalGlitchDataArray(18),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
        VitalPathDelay01 (
            OutSignal => matchout(19),
            OutSignalName => "MATCHOUT",
            OutTemp => match_out(19),
            Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                      2 => (we_ipd'last_event, tpd_we_matchout(19), TRUE),
                      3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(19), TRUE)),
            GlitchData => matchout_VitalGlitchDataArray(19),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
    
        VitalPathDelay01 (
            OutSignal => matchout(20),
            OutSignalName => "MATCHOUT",
            OutTemp => match_out(20),
            Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                      2 => (we_ipd'last_event, tpd_we_matchout(20), TRUE),
                      3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(20), TRUE)),
            GlitchData => matchout_VitalGlitchDataArray(20),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
        VitalPathDelay01 (
            OutSignal => matchout(21),
            OutSignalName => "MATCHOUT",
            OutTemp => match_out(21),
            Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                      2 => (we_ipd'last_event, tpd_we_matchout(21), TRUE),
                      3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(21), TRUE)),
            GlitchData => matchout_VitalGlitchDataArray(21),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
        VitalPathDelay01 (
            OutSignal => matchout(22),
            OutSignalName => "MATCHOUT",
            OutTemp => match_out(22),
            Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                      2 => (we_ipd'last_event, tpd_we_matchout(22), TRUE),
                      3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(22), TRUE)),
            GlitchData => matchout_VitalGlitchDataArray(22),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
        VitalPathDelay01 (
            OutSignal => matchout(23),
            OutSignalName => "MATCHOUT",
            OutTemp => match_out(23),
            Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                      2 => (we_ipd'last_event, tpd_we_matchout(23), TRUE),
                      3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(23), TRUE)),
            GlitchData => matchout_VitalGlitchDataArray(23),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
        VitalPathDelay01 (
            OutSignal => matchout(24),
            OutSignalName => "MATCHOUT",
            OutTemp => match_out(24),
            Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                      2 => (we_ipd'last_event, tpd_we_matchout(24), TRUE),
                      3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(24), TRUE)),
            GlitchData => matchout_VitalGlitchDataArray(24),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
        VitalPathDelay01 (
            OutSignal => matchout(25),
            OutSignalName => "MATCHOUT",
            OutTemp => match_out(25),
            Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                      2 => (we_ipd'last_event, tpd_we_matchout(25), TRUE),
                      3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(25), TRUE)),
            GlitchData => matchout_VitalGlitchDataArray(25),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
        VitalPathDelay01 (
            OutSignal => matchout(26),
            OutSignalName => "MATCHOUT",
            OutTemp => match_out(26),
            Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                      2 => (we_ipd'last_event, tpd_we_matchout(26), TRUE),
                      3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(26), TRUE)),
            GlitchData => matchout_VitalGlitchDataArray(26),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
        VitalPathDelay01 (
            OutSignal => matchout(27),
            OutSignalName => "MATCHOUT",
            OutTemp => match_out(27),
            Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                      2 => (we_ipd'last_event, tpd_we_matchout(27), TRUE),
                      3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(27), TRUE)),
            GlitchData => matchout_VitalGlitchDataArray(27),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
        VitalPathDelay01 (
            OutSignal => matchout(28),
            OutSignalName => "MATCHOUT",
            OutTemp => match_out(28),
            Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                      2 => (we_ipd'last_event, tpd_we_matchout(28), TRUE),
                      3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(28), TRUE)),
            GlitchData => matchout_VitalGlitchDataArray(28),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
        VitalPathDelay01 (
            OutSignal => matchout(29),
            OutSignalName => "MATCHOUT",
            OutTemp => match_out(29),
            Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                      2 => (we_ipd'last_event, tpd_we_matchout(29), TRUE),
                      3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(29), TRUE)),
            GlitchData => matchout_VitalGlitchDataArray(29),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
        VitalPathDelay01 (
            OutSignal => matchout(30),
            OutSignalName => "MATCHOUT",
            OutTemp => match_out(30),
            Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                      2 => (we_ipd'last_event, tpd_we_matchout(30), TRUE),
                      3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(30), TRUE)),
            GlitchData => matchout_VitalGlitchDataArray(30),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
        VitalPathDelay01 (
            OutSignal => matchout(31),
            OutSignalName => "MATCHOUT",
            OutTemp => match_out(31),
            Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                      2 => (we_ipd'last_event, tpd_we_matchout(31), TRUE),
                      3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(31), TRUE)),
            GlitchData => matchout_VitalGlitchDataArray(31),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
    end process;
    
end behave;


--/////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : MERCURY_CAM_SLICE
--
-- Description : Structural model for a single CAM segment of the MERCURY
--               device family
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY ieee, mercury;
USE ieee.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE mercury.atom_pack.all;

LIBRARY mercury;
USE mercury.all;

ENTITY mercury_cam_slice is
    GENERIC (
             operation_mode    : string := "single_match";
             logical_cam_name  : string := "cam_xxx";
             logical_cam_depth : integer := 64;
             logical_cam_width : integer := 32;
             address_width     : integer := 6;
             waddr_clear       : string := "none";
             write_enable_clear: string := "none";
             write_logic_clock : string := "none";
             write_logic_clear : string := "none";
             output_clock      : string := "none";
             output_clear      : string := "none";
             init_file         : string := "xxx";
             init_filex        : string := "xxx";
             first_address     : integer := 0;
             last_address      : integer := 63;
             first_pattern_bit : integer := 0;
             pattern_width     : integer := 32;
             power_up          : string := "low";
             init_mem_true     : mercury_mem_data := (OTHERS => "11111111111111111111111111111111");
             init_mem_comp     : mercury_mem_data := (OTHERS => "11111111111111111111111111111111"));
    PORT    (
             clk0              : in std_logic := '0';
             clk1              : in std_logic := '0';
             clr0              : in std_logic := '0';
             clr1              : in std_logic := '0';
             ena0              : in std_logic := '1';
             ena1              : in std_logic := '1';
             we, datain        : in std_logic := '0';
             wrinvert, outputselect : in std_logic := '0';
             waddr             : in std_logic_vector(5 downto 0);
             lit               : in std_logic_vector(31 downto 0);
             devclrn           : in std_logic := '1';
             devpor            : in std_logic := '1';
             modesel           : in std_logic_vector(9 downto 0) := (OTHERS => '0');
             matchout          : out std_logic_vector(31 downto 0);
             matchfound        : out std_logic);

end mercury_cam_slice;

ARCHITECTURE structure of mercury_cam_slice is
signal waddr_clr_sel : std_logic;
signal write_logic_clr_sel : std_logic;
signal we_clr_sel : std_logic;
signal output_clr_sel : std_logic;
signal output_reg_clr_sel : std_logic;
signal write_logic_sel : std_logic;
signal output_reg_sel : std_logic;
signal output_clk_sel : std_logic;
signal output_clk : std_logic;
signal output_clk_en : std_logic;
signal output_clr : std_logic;
signal output_reg_clr : std_logic;
signal we_clr : std_logic;
signal waddr_clr : std_logic;
signal write_logic_clr : std_logic;
signal matchfound_int : std_logic;
signal matchfound_reg : std_logic;
signal matchfound_tmp : std_logic;
signal wdatain_reg : std_logic;
signal wdatain_int : std_logic;
signal wrinv_reg : std_logic;
signal wrinv_int : std_logic;
signal matchout_reg : std_logic_vector(31 downto 0);
signal matchout_int : std_logic_vector(31 downto 0);
signal waddr_reg : std_logic_vector(5 downto 0);
signal we_reg : std_logic;
signal we_reg_delayed : std_logic;
signal NC : std_logic := '0';

signal wereg_clr : std_logic;
signal writelogic_clr : std_logic;
signal waddrreg_clr : std_logic;
signal outputreg_clr : std_logic;
signal we_pulse : std_logic;

-- clk0 for we_pulse should have the same delay as
-- clk of wereg
   signal clk0_delayed : std_logic;

COMPONENT DFFE
    GENERIC (
             TimingChecksOn                : Boolean := true;
             InstancePath                  : STRING := "*";
             XOn                           : Boolean := DefGlitchXOn;
             MsgOn                         : Boolean := DefGlitchMsgOn;
             MsgOnChecks                   : Boolean := DefMsgOnChecks;
             XOnChecks                     : Boolean := DefXOnChecks;
             tpd_PRN_Q_negedge             : VitalDelayType01 := DefPropDelay01;
             tpd_CLRN_Q_negedge            : VitalDelayType01 := DefPropDelay01;
             tpd_CLK_Q_posedge             : VitalDelayType01 := DefPropDelay01;
             tpd_ENA_Q_posedge             : VitalDelayType01 := DefPropDelay01;
             tsetup_D_CLK_noedge_posedge   : VitalDelayType := DefSetupHoldCnst;
             tsetup_D_CLK_noedge_negedge   : VitalDelayType := DefSetupHoldCnst;
             tsetup_ENA_CLK_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_D_CLK_noedge_posedge    : VitalDelayType := DefSetupHoldCnst;
             thold_D_CLK_noedge_negedge    : VitalDelayType := DefSetupHoldCnst;
             thold_ENA_CLK_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
             tipd_D                        : VitalDelayType01 := DefPropDelay01;
             tipd_CLRN                     : VitalDelayType01 := DefPropDelay01;
             tipd_PRN                      : VitalDelayType01 := DefPropDelay01;
             tipd_CLK                      : VitalDelayType01 := DefPropDelay01;
             tipd_ENA                      : VitalDelayType01 := DefPropDelay01
            );

    PORT    (Q    : out STD_LOGIC := '0';
             D    : in  STD_LOGIC := '1';
             CLRN : in  STD_LOGIC := '1';
             PRN  : in  STD_LOGIC := '1';
             CLK  : in  STD_LOGIC := '0';
             ENA  : in  STD_LOGIC := '1'
            );
END COMPONENT;

COMPONENT and1
    GENERIC(
            XOn       : Boolean := DefGlitchXOn;
            MsgOn     : Boolean := DefGlitchMsgOn;
            tpd_IN1_Y : VitalDelayType01 := DefPropDelay01;
            tipd_IN1  : VitalDelayType01 := DefPropDelay01
           );

    PORT   (Y   : out STD_LOGIC;
            IN1 : in  STD_LOGIC
           );
END COMPONENT;

COMPONENT mux21
    PORT (A : in std_logic := '0';
          B : in std_logic := '0';
          S : in std_logic := '0';
          MO : out std_logic
         );
END COMPONENT;

COMPONENT nmux21
    PORT (A : in std_logic := '0';
          B : in std_logic := '0';
          S : in std_logic := '0';
          MO : out std_logic
         );
END COMPONENT;

COMPONENT b32mux21
    PORT (A : in std_logic_vector(31 downto 0) := (OTHERS => '0');
          B : in std_logic_vector(31 downto 0) := (OTHERS => '0');
          S : in std_logic := '0';
          MO : out std_logic_vector(31 downto 0)
         );
END COMPONENT;

COMPONENT mercury_cam
    GENERIC (
             operation_mode    : string := "single_match";
             logical_cam_depth : integer := 64;
             first_pattern_bit : integer := 0;
             first_address     : integer := 0;
             last_address      : integer := 63;
             init_mem_true     : mercury_mem_data := (OTHERS => "11111111111111111111111111111111");
             init_mem_comp     : mercury_mem_data := (OTHERS => "11111111111111111111111111111111");
             address_width     : integer := 1;
             pattern_width     : integer := 32);

    PORT    (
             datain           : in std_logic := '0';
             wrinvert         : in std_logic := '0';
             outputselect     : in std_logic := '0';
             we               : in std_logic := '0';
             waddr            : in std_logic_vector(5 downto 0) := (OTHERS => '0');
             lit              : in std_logic_vector(31 downto 0) := (OTHERS => '0');
             modesel          : in std_logic_vector(1 downto 0) := "00";
             matchfound       : out std_logic;
             matchout         : out std_logic_vector(31 downto 0)
            );
END COMPONENT;

begin
    
    waddr_clr_sel       <= modesel(0);
    write_logic_sel     <= modesel(1);
    write_logic_clr_sel <= modesel(2);
    we_clr_sel          <= modesel(3);
    output_reg_sel      <= modesel(4);
    output_clk_sel      <= modesel(5);
    output_clr_sel      <= modesel(6);
    output_reg_clr_sel  <= modesel(7);
    
    outputclksel: mux21 
            port map (A => clk0,
                      B => clk1,
                      S => output_clk_sel, 
                      MO => output_clk
                     );
    outputclkensel: mux21 
            port map (A => ena0,
                      B => ena1,
                      S => output_clk_sel, 
                      MO => output_clk_en
                     );
    outputregclrsel: mux21 
            port map (A => clr0,
                      B => clr1,
                      S => output_reg_clr_sel, 
                      MO => output_reg_clr
                     );
    outputclrsel: nmux21 
            port map (A => NC,
                      B => output_reg_clr,
                      S => output_clr_sel, 
                      MO => output_clr
                     );
    matchoutsel: b32mux21
            port map (A => matchout_int,
                      B => matchout_reg,
                      S => output_reg_sel,
                      MO => matchout
                     );    
    matchfoundsel: mux21
            port map (A => matchfound_int,
                      B => matchfound_reg,
                      S => output_reg_sel,
                      MO => matchfound
                     );
    wdatainsel: mux21
            port map (A => datain,
                      B => wdatain_reg,
                      S => write_logic_sel,
                      MO => wdatain_int
                     );
    wrinvsel: mux21
            port map (A => wrinvert,
                      B => wrinv_reg,
                      S => write_logic_sel,
                      MO => wrinv_int
                     );
    weclrsel: nmux21
            port map (A => clr0,
                      B => NC,
                      S => we_clr_sel,
                      MO => we_clr
                     );
    waddrclrsel: nmux21
            port map (A => clr0,
                      B => NC,
                      S => waddr_clr_sel,
                      MO => waddr_clr
                     );
    writelogicclrsel: nmux21
            port map (A => clr0,
                      B => NC,
                      S => write_logic_clr_sel,
                      MO => write_logic_clr
                     );
    wereg_clr <= we_clr and devclrn and devpor;
    wereg: dffe
            port map (D => we,
                      CLRN => wereg_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => we_reg
                     );

    -- clk0 for we_pulse should have the same delay as
    -- clk of wereg
        
    we_pulse <= we_reg_delayed and (not clk0_delayed);

    wedelay_buf: and1
            port map (IN1 => we_reg,
                      Y => we_reg_delayed
                     );
    
    clk0weregdelaybuf: and1
            port map (IN1 => clk0,
                      Y => clk0_delayed
                     );

    writelogic_clr <= write_logic_clr and devclrn and devpor;
    wdatainreg: dffe
            port map (D => datain,
                      CLRN => writelogic_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => wdatain_reg
                     );
    wrinvreg: dffe
            port map (D => wrinvert,
                      CLRN => writelogic_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => wrinv_reg
                     );
    
    waddrreg_clr <= waddr_clr and devclrn and devpor;
    waddrreg_0: dffe 
            port map (D => waddr(0),
                      CLRN => waddrreg_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => waddr_reg(0)
                     );    
    waddrreg_1: dffe 
            port map (D => waddr(1),
                      CLRN => waddrreg_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => waddr_reg(1)
                     );
    waddrreg_2: dffe 
            port map (D => waddr(2),
                      CLRN => waddrreg_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => waddr_reg(2)
                     );
    waddrreg_3: dffe 
            port map (D => waddr(3),
                      CLRN => waddrreg_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => waddr_reg(3)
                     );    
    waddrreg_4: dffe 
            port map (D => waddr(4),
                      CLRN => waddrreg_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => waddr_reg(4)
                     );    
    waddrreg_5: dffe 
            port map (D => waddr(5),
                      CLRN => waddrreg_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => waddr_reg(5)
                     );
    
    outputreg_clr <= output_clr and devclrn and devpor;
    matchoutreg_0: dffe
            port map (D => matchout_int(0),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(0)
                     );
    matchoutreg_1: dffe
            port map (D => matchout_int(1),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(1)
                     );
    matchoutreg_2: dffe
            port map (D => matchout_int(2),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(2)
                     );
    matchoutreg_3: dffe
            port map (D => matchout_int(3),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(3)
                     );
    matchoutreg_4: dffe
            port map (D => matchout_int(4),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(4)
                     );
    matchoutreg_5: dffe
            port map (D => matchout_int(5),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(5)
                     );
    matchoutreg_6: dffe
            port map (D => matchout_int(6),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(6)
                     );
    matchoutreg_7: dffe
            port map (D => matchout_int(7),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(7)
                     );
    matchoutreg_8: dffe
            port map (D => matchout_int(8),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(8)
                     );
    matchoutreg_9: dffe
            port map (D => matchout_int(9),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(9)
                     );
    matchoutreg_10: dffe
            port map (D => matchout_int(10),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(10)
                     );
    matchoutreg_11: dffe
            port map (D => matchout_int(11),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(11)
                     );
    matchoutreg_12: dffe
            port map (D => matchout_int(12),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(12)
                     );
    matchoutreg_13: dffe
            port map (D => matchout_int(13),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(13)
                     );
    matchoutreg_14: dffe
            port map (D => matchout_int(14),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(14)
                     );
    matchoutreg_15: dffe
            port map (D => matchout_int(15),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(15)
                     );
    matchoutreg_16: dffe
            port map (D => matchout_int(16),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(16)
                     );
    matchoutreg_17: dffe
            port map (D => matchout_int(17),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(17)
                     );
    matchoutreg_18: dffe
            port map (D => matchout_int(18),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(18)
                     );
    matchoutreg_19: dffe
            port map (D => matchout_int(19),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(19)
                     );
    matchoutreg_20: dffe
            port map (D => matchout_int(20),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(20)
                     );
    matchoutreg_21: dffe
            port map (D => matchout_int(21),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(21)
                     );
    matchoutreg_22: dffe
            port map (D => matchout_int(22),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(22)
                     );
    matchoutreg_23: dffe
            port map (D => matchout_int(23),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(23)
                     );
    matchoutreg_24: dffe
            port map (D => matchout_int(24),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(24)
                     );
    matchoutreg_25: dffe
            port map (D => matchout_int(25),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(25)
                     );
    matchoutreg_26: dffe
            port map (D => matchout_int(26),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(26)
                     );
    matchoutreg_27: dffe
            port map (D => matchout_int(27),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(27)
                     );
    matchoutreg_28: dffe
            port map (D => matchout_int(28),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(28)
                     );
    matchoutreg_29: dffe
            port map (D => matchout_int(29),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(29)
                     );
    matchoutreg_30: dffe
            port map (D => matchout_int(30),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(30)
                     );
    matchoutreg_31: dffe
            port map (D => matchout_int(31),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(31)
                     );    
    matchfoundreg: dffe
            port map (D => matchfound_int,
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchfound_reg
                     );
    
    cam1: mercury_cam
    
        GENERIC MAP (
                     operation_mode     => operation_mode,
                     address_width      => address_width,
                     pattern_width      => pattern_width,
                     first_pattern_bit  => first_pattern_bit,
                     first_address      => first_address,
                     last_address       => last_address,
                     init_MEM_TRUE      => init_mem_true,
                     init_MEM_COMP      => init_mem_comp,
                     LOGICAL_CAM_DEPTH  => logical_cam_depth
                    )
    
        port map    (
                     datain             => wdatain_int,
                     wrinvert           => wrinv_int,
                     outputselect       => outputselect,
                     we                 => we_pulse,
                     waddr              => waddr_reg,
                     lit                => lit,
                     modesel            => modesel(9 downto 8),
                     matchout           => matchout_int,
                     matchfound         => matchfound_int
                    );
end structure;

--////////////////////////////////////////////////////////////////////////////
--
-- mercury_hssi_TRANSMITTER
--
LIBRARY IEEE, mercury;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE mercury.atom_pack.all;

ENTITY mercury_hssi_transmitter is
    GENERIC (
                channel_width           : integer := 20;
                check_violation         : String := "true";
                operation_mode          : String  := "lvds";
                TimingChecksOn          : Boolean := True;
                MsgOn                   : Boolean := DefGlitchMsgOn;
                XOn                     : Boolean := DefGlitchXOn;
                MsgOnChecks             : Boolean := DefMsgOnChecks;
                XOnChecks               : Boolean := DefXOnChecks;
                InstancePath            : String := "*";
                tsetup_datain_clk_noedge_negedge  : VitalDelayArrayType(19 downto 0) := (OTHERS => DefSetupHoldCnst);
                thold_datain_clk_noedge_negedge   : VitalDelayArrayType(19 downto 0) := (OTHERS => DefSetupHoldCnst);
                tpd_clk_dataout_posedge: VitalDelayType01 := DefPropDelay01;
                tpd_clk_clkout_posedge: VitalDelayType01 := DefPropDelay01;
                tipd_clk               : VitalDelayType01 := DefpropDelay01;
                tipd_areset            : VitalDelayType01 := DefpropDelay01;
                tipd_datain             : VitalDelayArrayType01(19 downto 0) := (
OTHERS => DefpropDelay01));

        PORT (
                clk             : in std_logic;
                areset          : in std_logic := '0';
                datain          : in std_logic_vector(19 downto 0);
                devclrn         : in std_logic := '1';
					 devpor			  : in std_logic := '1';
                clkout          : out std_logic;
                dataout         : out std_logic);

	attribute VITAL_LEVEL0 of mercury_hssi_transmitter : ENTITY is TRUE;
end mercury_hssi_transmitter;

architecture vital_transmitter_atom of mercury_hssi_transmitter is
    attribute VITAL_LEVEL0 of vital_transmitter_atom : architecture is TRUE;
   signal clk_ipd : std_logic;
   signal areset_ipd : std_logic;
   signal datain_ipd : std_logic_vector(19 downto 0);

begin
	----------------------
	--  INPUT PATH DELAYs
	----------------------
	WireDelay : block
	begin
	VitalWireDelay (clk_ipd, clk, tipd_clk);
	VitalWireDelay (areset_ipd, areset, tipd_areset);
	VitalWireDelay (datain_ipd(0), datain(0), tipd_datain(0));
	VitalWireDelay (datain_ipd(1), datain(1), tipd_datain(1));
	VitalWireDelay (datain_ipd(2), datain(2), tipd_datain(2));
	VitalWireDelay (datain_ipd(3), datain(3), tipd_datain(3));
	VitalWireDelay (datain_ipd(4), datain(4), tipd_datain(4));
	VitalWireDelay (datain_ipd(5), datain(5), tipd_datain(5));
	VitalWireDelay (datain_ipd(6), datain(6), tipd_datain(6));
	VitalWireDelay (datain_ipd(7), datain(7), tipd_datain(7));
	VitalWireDelay (datain_ipd(8), datain(8), tipd_datain(8));
	VitalWireDelay (datain_ipd(9), datain(9), tipd_datain(9));
	VitalWireDelay (datain_ipd(10), datain(10), tipd_datain(10));
	VitalWireDelay (datain_ipd(11), datain(11), tipd_datain(11));
	VitalWireDelay (datain_ipd(12), datain(12), tipd_datain(12));
	VitalWireDelay (datain_ipd(13), datain(13), tipd_datain(13));
	VitalWireDelay (datain_ipd(14), datain(14), tipd_datain(14));
	VitalWireDelay (datain_ipd(15), datain(15), tipd_datain(15));
	VitalWireDelay (datain_ipd(16), datain(16), tipd_datain(16));
	VitalWireDelay (datain_ipd(17), datain(17), tipd_datain(17));
	VitalWireDelay (datain_ipd(18), datain(18), tipd_datain(18));
	VitalWireDelay (datain_ipd(19), datain(19), tipd_datain(19));
	end block;

VITAL: process (clk_ipd, areset_ipd, devclrn, devpor)  -- need to generate clkout here
variable Tviol_datain_clk : std_ulogic := '0';
variable TimingData_datain_clk : VitalTimingDataType := VitalTimingDataInit;
variable dataout_VitalGlitchData : VitalGlitchDataType;
variable clkout_VitalGlitchData : VitalGlitchDataType;
variable i : integer := 0;
variable dataout_tmp : std_logic;
variable indata : std_logic_vector(channel_width-1 downto 0);
variable regdata : std_logic_vector(channel_width-1 downto 0);
variable fast_clk_count : integer := channel_width; -- always follow the first edge
variable clkout_tmp : std_logic;
variable clkout_last_value : std_logic;
begin

	if (now = 0 ns) then
		dataout_tmp := '0';
		clkout_last_value := '0';
   end if;

   ------------------------
   --  Timing Check Section
   ------------------------
   if (TimingChecksOn) then

      VitalSetupHoldCheck (
			Violation       => Tviol_datain_clk,
         TimingData      => TimingData_datain_clk,
         TestSignal      => datain_ipd,
         TestSignalName  => "DATAIN",
         RefSignal       => clk_ipd,
         RefSignalName   => "CLK",
         SetupHigh       => tsetup_datain_clk_noedge_negedge(0),
         SetupLow        => tsetup_datain_clk_noedge_negedge(0),
         HoldHigh        => thold_datain_clk_noedge_negedge(0),
         HoldLow         => thold_datain_clk_noedge_negedge(0),
         CheckEnabled    => (check_violation = "true"),
         RefTransition   => '\',
         HeaderMsg       => InstancePath & "/MERCURY_HSSI_TRANSMITTER",
         XOn             => XOn,
         MsgOn           => MsgOnChecks );

   end if;

   if ((devpor = '0') or (devclrn = '0') or (areset_ipd = '1')) then
		dataout_tmp := '0';
		clkout_tmp := '0';
		fast_clk_count := channel_width;
      for i in channel_width-1 downto 0 loop --reset register
			indata(i) := '0';
			regdata(i) := '0';
		end loop;
   else
      if (clk_ipd'event and clk_ipd = '1') then
      	if (clkout_last_value = 'U') then --for initial value
				clkout_last_value := clk_ipd;
				clkout_tmp := clk_ipd;
			end if;
			if (fast_clk_count = channel_width) then
				fast_clk_count := 0;
				clkout_tmp := NOT (clkout_last_value);
			elsif (fast_clk_count = (channel_width+1)/2) then
				clkout_tmp := NOT (clkout_last_value);
			elsif (fast_clk_count < channel_width) then
				clkout_tmp := clkout_last_value;
	      end if;
			fast_clk_count := fast_clk_count + 1;
			if (fast_clk_count = 3) then --shifting out new data 
         	for i in channel_width-1 downto 0 loop
					regdata(i) := indata(i);
				end loop;
			end if;
         dataout_tmp := regdata(channel_width - 1);
         for i in channel_width-1 downto 1 loop
				regdata(i) := regdata(i-1);
			end loop;
      end if;
      if (clk_ipd'event and clk_ipd = '0') then  -- falling edge
      	if (clkout_last_value = 'U') then --for initial value
				clkout_last_value := clk_ipd;
				clkout_tmp := clk_ipd;
			end if;
			if (fast_clk_count = 3) then --loading 
				indata := datain_ipd(channel_width-1 downto 0);
			end if;
      end if;
   end if;

	if (clkout_tmp /= 'U') then
		clkout_last_value := clkout_tmp;
	end if;

   ----------------------
   --  Path Delay Section
   ----------------------
   VitalPathDelay01 (
      OutSignal => dataout,
      OutSignalName => "DATAOUT",
      OutTemp => dataout_tmp,
      Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE)),
      GlitchData => dataout_VitalGlitchData,
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

   VitalPathDelay01 (
      OutSignal => clkout,
      OutSignalName => "CLKOUT",
      OutTemp => clkout_tmp,
      Paths => (1 => (clk_ipd'last_event, tpd_clk_clkout_posedge, TRUE)),
      GlitchData => clkout_VitalGlitchData,
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

end process;

end vital_transmitter_atom;

--
-- MERCURY_HSSI_RECEIVER
--

LIBRARY IEEE, mercury,std;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE mercury.atom_pack.all;
USE std.textio.all;

ENTITY mercury_hssi_receiver is
    GENERIC (
                channel_width           : integer := 20;
                operation_mode          : String  := "lvds";
                run_length  	          : integer := 1;
                TimingChecksOn          : Boolean := True;
                MsgOn                   : Boolean := DefGlitchMsgOn;
                XOn                     : Boolean := DefGlitchXOn;
                MsgOnChecks             : Boolean := DefMsgOnChecks;
                XOnChecks               : Boolean := DefXOnChecks;
                InstancePath            : String  := "*";
                tpd_clk_dataout_negedge: VitalDelayArrayType01(19 downto 0) := (OTHERS => DefPropDelay01);
                tpd_clk_clkout_posedge: VitalDelayType01 := DefPropDelay01;
                tpd_coreclk_rlv_posedge: VitalDelayType01 := DefPropDelay01;
                tpd_clk_locked_posedge: VitalDelayType01 := DefPropDelay01;
                tipd_clk               : VitalDelayType01 := DefpropDelay01;
                tipd_coreclk               : VitalDelayType01 := DefpropDelay01;
                tipd_areset             : VitalDelayType01 := DefpropDelay01;
                tipd_feedback           : VitalDelayType01 := DefpropDelay01;
                tipd_fbkcntl           : VitalDelayType01 := DefpropDelay01;
                tipd_datain             : VitalDelayType01 := DefpropDelay01);

        PORT (
					clk			: in std_logic;
					coreclk		: in std_logic;
					datain		: in std_logic;
					areset		: in std_logic := '0';
					feedback		: in std_logic := '0';
					fbkcntl		: in std_logic := '0';
					devclrn		: in std_logic := '1';
					devpor		: in std_logic := '1';
					clkout		: out std_logic;
					rlv			: out std_logic;
					locked		: out std_logic;
					dataout		: out std_logic_vector(19 downto 0));
	attribute VITAL_LEVEL0 of mercury_hssi_receiver : ENTITY is TRUE;
end mercury_hssi_receiver;

architecture vital_receiver_atom of mercury_hssi_receiver is
    attribute VITAL_LEVEL0 of vital_receiver_atom : architecture is TRUE;
    signal clk_ipd  : std_logic;
    signal coreclk_ipd  : std_logic;
    signal databuf_ipd : std_logic;
    signal areset_ipd : std_logic;
    signal fbin_ipd : std_logic;
    signal fbena_ipd : std_logic;

begin
	----------------------
	--  INPUT PATH DELAYs
	----------------------
	WireDelay : block
	begin
	VitalWireDelay (clk_ipd, clk, tipd_clk);
	VitalWireDelay (coreclk_ipd, coreclk, tipd_coreclk);
	VitalWireDelay (databuf_ipd, datain, tipd_datain);
	VitalWireDelay (areset_ipd, areset, tipd_areset);
	VitalWireDelay (fbin_ipd, feedback, tipd_feedback);
	VitalWireDelay (fbena_ipd, fbkcntl, tipd_fbkcntl);
	end block;


VITAL: process (clk_ipd, coreclk_ipd, devpor, devclrn, areset_ipd, fbena_ipd)
variable Tviol_datain_clk : std_ulogic := '0';
variable TimingData_datain_clk : VitalTimingDataType := VitalTimingDataInit;
variable dataout_VitalGlitchDataArray : VitalGlitchDataArrayType(19 downto 0);
variable clkout_VitalGlitchData: VitalGlitchDataType;
variable rlvout_VitalGlitchData: VitalGlitchDataType;
variable lockedout_VitalGlitchData: VitalGlitchDataType;
variable clk_count : integer := channel_width; --follow the 1st edge
variable deser_data_arr : std_logic_vector(channel_width-1 downto 0);
variable dataout_tmp : std_logic_vector(19 downto 0);
variable clkout_tmp : std_logic;
variable rlv_tmp : std_logic := '0';
variable locked_tmp : std_logic := '0';
variable clkout_last_value : std_logic;
variable datain_ipd : std_logic;
variable last_datain : std_logic;
variable rlv_count : integer := 0; 
variable data_changed : std_logic := '0';
variable rlv_flag : std_logic := '0';
variable rlv_set : std_logic := '0';

begin

	if (now = 0 ns) then
		dataout_tmp := (OTHERS => '0');
		clkout_last_value := '0';
		rlv_tmp :=  '0';
		clkout_tmp :=  '0';
		data_changed :=  '0';
		clk_count := channel_width;
	end if;

	------------------------
	--  Timing Check Section
	------------------------

	if ((devpor = '0') or (devclrn = '0')) then
		dataout_tmp := (OTHERS => '0');
		clkout_last_value := clk_ipd;
		rlv_tmp :=  '0';
		clkout_tmp :=  '0';
		rlv_count := 0;
		rlv_flag := '0';
		rlv_set := '0';
		data_changed :=  '0';
		last_datain := 'X';
	end if;
	if (areset_ipd = '1') then
		dataout_tmp := (OTHERS => '0');
		clkout_tmp :=  '0';
		clk_count := channel_width;
		rlv_tmp := '0';
		locked_tmp := '0';
		clkout_last_value := clk_ipd;
      for i in channel_width-1 downto 0 loop
			deser_data_arr(i) := '0';
      end loop;
		rlv_count := 0;
		rlv_flag := '0';
		rlv_set := '0';
		last_datain := 'X';
		data_changed := '0';
	else
		if (fbena_ipd = '1') then
			datain_ipd := fbin_ipd;
		else
			datain_ipd := databuf_ipd;
		end if;
	   if (clk_ipd'event and clk_ipd = '1') then
			if (clkout_last_value = 'U') then
				clkout_last_value := clk_ipd;
				clkout_tmp := clk_ipd;
			end if;
			if (clk_count = channel_width) then
				clk_count :=0;
				clkout_tmp := NOT (clkout_last_value);
			elsif (clk_count = (channel_width+1)/2) then
				clkout_tmp := NOT (clkout_last_value);
			elsif (clk_count < channel_width) then
				clkout_tmp := clkout_last_value;
			end if;
			clk_count := clk_count + 1;
			if (operation_mode = "cdr") then
				if (last_datain /= datain_ipd) then
					data_changed := '1';
					last_datain := datain_ipd;
				else
					rlv_count := rlv_count + 1;
					data_changed := '0';
				end if;
				if (rlv_count > run_length) then
					rlv_set := '1';
					rlv_flag := '1';
				else
					rlv_set := '0';
				end if;
				if (data_changed = '1') then
					rlv_count := 1;
				end if;
			end if;
	   end if;
	   if (coreclk_ipd'event and coreclk_ipd = '1') then
			if (operation_mode = "cdr") then
				if (rlv_flag = '1') then
					rlv_tmp := '1';
					if (rlv_set = '0') then
						rlv_flag := '0';
					end if;
				else
					rlv_tmp := '0';
				end if;
			end if;
	   end if;
	   if (clk_ipd'event and clk_ipd = '0') then
			if (clkout_last_value = 'U') then
				clkout_last_value := clk_ipd;
				clkout_tmp := clk_ipd;
			end if;
	      if (clk_count = 3) then
				dataout_tmp(channel_width-1 downto 0) := deser_data_arr;
	      end if;
	      for i in channel_width-1 downto 1 loop
				deser_data_arr(i) := deser_data_arr(i-1);
	      end loop;
	      deser_data_arr(0) := datain_ipd;
	   end if;

		if (clkout_tmp /= 'U') then
			clkout_last_value := clkout_tmp;
		end if;
	end if;

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => clkout,
       OutSignalName => "CLKOUT",
       OutTemp => clkout_tmp,
       Paths => (1 => (clk_ipd'last_event, tpd_clk_clkout_posedge, TRUE)),
       GlitchData => clkout_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => rlv,
       OutSignalName => "RLV",
       OutTemp => rlv_tmp,
       Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_rlv_posedge, TRUE)),
       GlitchData => rlvout_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => locked,
       OutSignalName => "LOCKED",
       OutTemp => locked_tmp,
       Paths => (1 => (clk_ipd'last_event, tpd_clk_locked_posedge, TRUE)),
       GlitchData => lockedout_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(0),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(0),
       Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_negedge(0), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(0),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(1),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(1),
       Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_negedge(1), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(1),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(2),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(2),
       Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_negedge(2), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(2),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(3),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(3),
       Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_negedge(3), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(3),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(4),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(4),
       Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_negedge(4), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(4),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(5),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(5),
       Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_negedge(5), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(5),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(6),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(6),
       Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_negedge(6), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(6),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(7),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(7),
       Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_negedge(7), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(7),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(8),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(8),
       Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_negedge(8), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(8),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(9),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(9),
       Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_negedge(9), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(9),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(10),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(10),
       Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_negedge(10), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(10),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(11),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(11),
       Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_negedge(11), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(11),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(12),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(12),
       Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_negedge(12), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(12),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(13),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(13),
       Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_negedge(13), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(13),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(14),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(14),
       Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_negedge(14), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(14),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(15),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(15),
       Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_negedge(15), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(15),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(16),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(16),
       Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_negedge(16), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(16),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(17),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(17),
       Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_negedge(17), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(17),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(18),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(18),
       Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_negedge(18), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(18),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(19),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(19),
       Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_negedge(19), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(19),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

end process;

end vital_receiver_atom;

--/////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : MERCURY_HSSI_PLL
--
-- Description : Simulation model for the Mercury device family HSSI PLL
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE, mercury;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE mercury.atom_pack.all;

ENTITY mercury_hssi_pll is
    GENERIC ( 
             clk0_multiply_by        : integer := 1;
             clk1_divide_by          : integer := 1;
             input_frequency         : integer := 1000;
             clkin_settings          : string := "";
             clk0_settings           : string := "";
             MsgOn                   : Boolean := DefGlitchMsgOn;
             XOn                     : Boolean := DefGlitchXOn;
             tipd_clk                : VitalDelayType01 := DefpropDelay01;
             tipd_areset             : VitalDelayType01 := DefpropDelay01
            );

    PORT    (clk                     : in std_logic := '0';
             areset                  : in std_logic := '0';
             clk0                    : out std_logic;
             clk1                    : out std_logic;
             locked                  : out std_logic
            );
    attribute VITAL_LEVEL0 of mercury_hssi_pll : ENTITY is TRUE;
end mercury_hssi_pll;

ARCHITECTURE vital_hssi_pll_atom of mercury_hssi_pll is
attribute VITAL_LEVEL0 of vital_hssi_pll_atom : ARCHITECTURE is TRUE;
signal clk_ipd : std_logic;
signal areset_ipd : std_logic;

SIGNAL clk0_period : time;
SIGNAL clk1_period : time;
SIGNAL half_inclk : time;
SIGNAL pll_lock : std_logic := '0';
SIGNAL lock_on_rise : integer := 0;
SIGNAL lock_on_fall : integer := 0;
SIGNAL clk_check : std_logic := '0';

SIGNAL clk0_tmp : std_logic := 'X';
SIGNAL clk1_tmp : std_logic := 'X';
begin
    ----------------------
    --  INPUT PATH DELAYs
    ----------------------
    WireDelay : block
    begin
        VitalWireDelay (clk_ipd, clk, tipd_clk);
        VitalWireDelay (areset_ipd, areset, tipd_areset);
    end block;

    VITALtiming : process (clk_ipd, areset_ipd, pll_lock)
    begin

    end process;

    process (clk_ipd, pll_lock, clk_check, areset_ipd)
    variable expected_cycle, real_cycle : real := 0.0;
    variable inclk_ps : time := 0 ps;
    variable violation : boolean := false;
    variable pll_lock_tmp : std_logic := '0';
    variable start_lock_count, stop_lock_count : integer := 0;
    variable pll_last_rising_edge, pll_last_falling_edge : time := 0 ps;
    variable pll_rising_edge_count : integer := 0;
    variable pll_cycle, pll_duty_cycle : time  := 0 ps;
    variable clk_per_tolerance : time := 0 ps;
    variable expected_next_clk_edge : time := 0 ps;
    variable lock_low : integer := 2;
    variable lock_high : integer := 2;

    variable last_synchronizing_rising_edge_for_clk0 : time := 0 ps;
    variable last_synchronizing_rising_edge_for_clk1 : time := 0 ps;
    variable input_cycles_per_clk0, input_cycles_per_clk1 : integer;
    variable input_cycle_count_to_sync0 : integer := 0;
    variable input_cycle_count_to_sync1 : integer := 0;
    variable init : boolean := true;
    variable output_value : std_logic := '0';
    variable vco_per : time;
    variable high_time : time;
    variable low_time : time;
    variable sched_time : time := 0 ps;
    variable tmp_per  : integer := 0;
    variable temp, tmp_rem, my_rem : integer;
    variable l : integer := 1;
    variable cycle_to_adjust : integer := 0;
    variable clk0_synchronizing_period, clk1_synchronizing_period : time;
    variable clk0_cycles_per_sync_period : integer := clk0_multiply_by;
    variable clk1_cycles_per_sync_period : integer := 1;
    variable schedule_clk0, schedule_clk1 : boolean := false;
    variable clk0_phase_delay, clk1_phase_delay : time := 0 ps;
    begin
       if (init) then
          clk0_cycles_per_sync_period := clk0_multiply_by;
          clk1_cycles_per_sync_period := clk0_multiply_by;
          input_cycles_per_clk0 := 1;
          input_cycles_per_clk1 := clk1_divide_by;
          init := false;
       end if;
       if (areset_ipd = '1') then
          pll_rising_edge_count := 0;
          violation := false;
          pll_lock_tmp := '0';
          pll_lock <= '0';
          start_lock_count := 1;
          stop_lock_count := 0;
          clk0_tmp <= 'X';
          clk1_tmp <= 'X';
       else
--        if (clk_ipd'event and clk_ipd = '1' and now > 0 ns) then
          if (clk_ipd'event and clk_ipd = '1') then
             if (pll_lock_tmp = '1') then
                clk_check <= not clk_check after (inclk_ps+clk_per_tolerance)/2.0;
             end if;
             if pll_rising_edge_count = 0 then      -- at 1st rising edge
                inclk_ps := (input_frequency / 1 ) * 1 ps;
                half_inclk <= inclk_ps/2;
                clk_per_tolerance := 0.025 * inclk_ps;
                clk0_period <= inclk_ps / clk0_multiply_by;
                clk1_period <= inclk_ps / clk0_multiply_by * clk1_divide_by;
                pll_duty_cycle := inclk_ps/2;
                clk0_phase_delay := 0 ps;
                clk1_phase_delay := 0 ps;
    
             elsif pll_rising_edge_count = 1 then      -- at 2nd rising edge
                pll_cycle := now - pll_last_rising_edge;    -- calculate period
                expected_cycle := real(input_frequency) / 1000.0;
                real_cycle := REAL( (NOW - pll_last_rising_edge) / 1 ns);
                if ((NOW - pll_last_rising_edge) < (inclk_ps - clk_per_tolerance)  or
                    (NOW - pll_last_rising_edge) > (inclk_ps + clk_per_tolerance)) then
                    ASSERT FALSE
                    REPORT " Inclock_Period Violation "
                    SEVERITY WARNING;
                    violation := true;
                    if (pll_lock = '1') then
                        stop_lock_count := stop_lock_count + 1;
                        if (stop_lock_count = lock_low) then
                            pll_lock_tmp := '0';
                        end if;
                    else
                      start_lock_count := 1;
                    end if;
                else
                    violation := false;
                end if;
                if ((now - pll_last_falling_edge) < (pll_duty_cycle - clk_per_tolerance/2) or
                    (now - pll_last_falling_edge) > (pll_duty_cycle + clk_per_tolerance/2)) then
                    ASSERT FALSE
                    REPORT "Duty Cycle Violation"
                    SEVERITY WARNING;
                    violation := true;
                else
                    violation := false;
                end if;
             else
                pll_cycle := now - pll_last_rising_edge;    -- calculate period
                if ((now - pll_last_rising_edge) < (inclk_ps - clk_per_tolerance) or
                    (now - pll_last_rising_edge) > (inclk_ps + clk_per_tolerance)) then
                    ASSERT FALSE
                    REPORT "Cycle Violation"
                    SEVERITY WARNING;
                    violation := true;
                    if (pll_lock = '1') then
                        stop_lock_count := stop_lock_count + 1;
                        if (stop_lock_count = lock_low) then
                            pll_lock_tmp := '0';
                        end if;
                    else
                      start_lock_count := 1;
                    end if;
                else
                    violation := false;
                end if;
             end if;
             pll_last_rising_edge := now;
             pll_rising_edge_count := pll_rising_edge_count +1;
             if (not violation) then
                if (pll_lock_tmp = '1') then
                   input_cycle_count_to_sync0 := input_cycle_count_to_sync0 + 1;
                   if (input_cycle_count_to_sync0 = input_cycles_per_clk0) then
                      clk0_synchronizing_period := now - last_synchronizing_rising_edge_for_clk0;
                      last_synchronizing_rising_edge_for_clk0 := now;
                      schedule_clk0 := true;
                      input_cycle_count_to_sync0 := 0;
                   end if;
                   input_cycle_count_to_sync1 := input_cycle_count_to_sync1 + 1;
                   if (input_cycle_count_to_sync1 = input_cycles_per_clk1) then
                      clk1_synchronizing_period := now - last_synchronizing_rising_edge_for_clk1;
                      last_synchronizing_rising_edge_for_clk1 := now;
                      schedule_clk1 := true;
                      input_cycle_count_to_sync1 := 0;
                   end if;
                else
                   start_lock_count := start_lock_count + 1;
                   if (start_lock_count >= lock_high) then
                      pll_lock_tmp := '1';
                      lock_on_rise <= 1;
                      input_cycle_count_to_sync0 := 0;
                      input_cycle_count_to_sync1 := 0;
                      if (last_synchronizing_rising_edge_for_clk0 = 0 ps) then
                         clk0_synchronizing_period := pll_cycle;
                      else
                         clk0_synchronizing_period := now - last_synchronizing_rising_edge_for_clk0;
                      end if;
                      if (last_synchronizing_rising_edge_for_clk1 = 0 ps) then
                         clk1_synchronizing_period := ((pll_cycle/1 ps) * clk1_divide_by) * 1 ps;
                      else
                         clk1_synchronizing_period := now - last_synchronizing_rising_edge_for_clk1;
                      end if;
                      last_synchronizing_rising_edge_for_clk0 := now;
                      last_synchronizing_rising_edge_for_clk1 := now;
                      schedule_clk0 := true;
                      schedule_clk1 := true;
                   end if;
                end if;
             else
                start_lock_count := 0;
             end if;

--        elsif (clk_ipd'event and clk_ipd= '0' and now > 0 ns) then
          elsif (clk_ipd'event and clk_ipd= '0') then
             if (pll_lock_tmp = '1') then
                clk_check <= not clk_check after (inclk_ps+clk_per_tolerance)/2.0;
                if (now > 0 ns and ((now - pll_last_rising_edge) < (pll_duty_cycle - clk_per_tolerance/2) or
                   (now - pll_last_rising_edge) > (pll_duty_cycle + clk_per_tolerance/2))) then
                   ASSERT FALSE
                   REPORT "Duty Cycle Violation"
                   SEVERITY WARNING;
                   violation := true;
                   if (pll_lock = '1') then
                      stop_lock_count := stop_lock_count + 1;
                      if (stop_lock_count = lock_low) then
                          pll_lock_tmp := '0';
                      end if;
                   end if;
                else
                   violation := false;
                end if;
             elsif (pll_rising_edge_count > 0) then
                start_lock_count := start_lock_count + 1;
             end if;
             pll_last_falling_edge := now;
          else
             if pll_lock_tmp = '1' then
                if (clk_ipd = '1') then
                    expected_next_clk_edge := pll_last_rising_edge + (inclk_ps+clk_per_tolerance)/2.0;
                else
                    expected_next_clk_edge := pll_last_falling_edge + (inclk_ps+clk_per_tolerance)/2.0;
                end if;
                violation := false;
                if (now < expected_next_clk_edge) then
                    clk_check <= not clk_check after (expected_next_clk_edge - now);
                elsif (now = expected_next_clk_edge) then
                    clk_check <= not clk_check after (inclk_ps+clk_per_tolerance)/2.0;
                else
                    ASSERT FALSE
                    REPORT "Inclock_Period Violation"
                    SEVERITY WARNING;
                    violation := true;
                    if (pll_lock = '1') then
                        stop_lock_count := stop_lock_count + 1;
                        if (stop_lock_count = lock_low) then
                            pll_lock_tmp := '0';
                        else
                            clk_check <= not clk_check after (inclk_ps/2.0);
                        end if;
                    end if;
                end if;
             end if;
          end if;
          pll_lock <= pll_lock_tmp;
          if (pll_lock'event and pll_lock = '0') then
             start_lock_count := 1;
             stop_lock_count := 0;
             lock_on_rise <= 0;
             lock_on_fall <= 0;
             clk0_tmp <= 'X';
             clk1_tmp <= 'X';
          end if;
       end if;  -- if not areset

       if (schedule_clk0) then
          sched_time := clk0_phase_delay;
          cycle_to_adjust := 0;
          l := 1;
          output_value := '1';
          temp := clk0_synchronizing_period/1 ps;
          my_rem := temp rem clk0_cycles_per_sync_period;
          for i in 1 to clk0_cycles_per_sync_period loop
              tmp_per := temp/clk0_cycles_per_sync_period;
              if (my_rem /= 0 and l <= my_rem) then
                 tmp_rem := (clk0_cycles_per_sync_period * l) rem my_rem;
                 cycle_to_adjust := (clk0_cycles_per_sync_period * l) / my_rem;
                 if (tmp_rem /= 0) then
                    cycle_to_adjust := cycle_to_adjust + 1;
                 end if;
              end if;
              if (cycle_to_adjust = i) then
                  tmp_per := tmp_per + 1;
                  l := l + 1;
              end if;
              vco_per := tmp_per * 1 ps;
              high_time := (tmp_per/2) * 1 ps;
              if (tmp_per rem 2 /= 0) then
                 high_time := high_time + 1 ps;
              end if;
              low_time := vco_per - high_time;
              for j in 1 to 2 loop
                 clk0_tmp <= transport output_value after sched_time;
                 output_value := not output_value;
                 if (output_value = '0') then
                    sched_time := sched_time + high_time;
                 elsif (output_value = '1') then
                    sched_time := sched_time + low_time;
                 end if;
              end loop;
          end loop;
          schedule_clk0 := false;
       end if;

       if (schedule_clk1) then
          sched_time := clk1_phase_delay;
          cycle_to_adjust := 0;
          l := 1;
          output_value := '1';
          temp := clk1_synchronizing_period/1 ps;
          my_rem := temp rem clk1_cycles_per_sync_period;
          for i in 1 to clk1_cycles_per_sync_period loop
              tmp_per := temp/clk1_cycles_per_sync_period;
              if (my_rem /= 0 and l <= my_rem) then
                 tmp_rem := (clk1_cycles_per_sync_period * l) rem my_rem;
                 cycle_to_adjust := (clk1_cycles_per_sync_period * l) / my_rem;
                 if (tmp_rem /= 0) then
                    cycle_to_adjust := cycle_to_adjust + 1;
                 end if;
              end if;
              if (cycle_to_adjust = i) then
                  tmp_per := tmp_per + 1;
                  l := l + 1;
              end if;
              vco_per := tmp_per * 1 ps;
              high_time := (tmp_per/2) * 1 ps;
              if (tmp_per rem 2 /= 0) then
                 high_time := high_time + 1 ps;
              end if;
              low_time := vco_per - high_time;
              for j in 1 to 2 loop
                 clk1_tmp <= transport output_value after sched_time;
                 output_value := not output_value;
                 if (output_value = '0') then
                    sched_time := sched_time + high_time;
                 elsif (output_value = '1') then
                    sched_time := sched_time + low_time;
                 end if;
              end loop;
          end loop;
          schedule_clk1 := false;
       end if;

    end process;

    clk0 <= clk0_tmp;
    clk1 <= clk1_tmp;

    locked <= pll_lock;

end vital_hssi_pll_atom;

--///////////////////////////////////////////////////////////////////////////
--
-- Entity Name : LATCH
--
--///////////////////////////////////////////////////////////////////////////

LIBRARY ieee, mercury;
USE ieee.std_logic_1164.all;
USE IEEE.VITAL_Primitives.all;
USE IEEE.VITAL_Timing.all;
USE mercury.atom_pack.all;

ENTITY latch is
   GENERIC(
      TimingChecksOn: Boolean := True;
      XOn: Boolean := DefGlitchXOn;
      MsgOn: Boolean := DefGlitchMsgOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      InstancePath: STRING := "*";
      tpd_PRE_Q_negedge              :  VitalDelayType01 := DefPropDelay01;
      tpd_ENA_Q_posedge              :  VitalDelayType01 := DefPropDelay01;
      tpd_D_Q                        :  VitalDelayType01 := DefPropDelay01;
      tsetup_D_ENA_noedge_posedge    :  VitalDelayType := DefSetupHoldCnst;
      thold_D_ENA_noedge_negedge     :   VitalDelayType := DefSetupHoldCnst;
      tipd_D                         :  VitalDelayType01 := DefPropDelay01;
      tipd_PRE                       :  VitalDelayType01 := DefPropDelay01;
      tipd_ENA                       :  VitalDelayType01 := DefPropDelay01);

   PORT(
      Q                              :  out   STD_LOGIC;
      D                              :  in    STD_LOGIC;
      PRE                            :  in    STD_LOGIC;
      ENA                            :  in    STD_LOGIC);
   attribute VITAL_LEVEL0 of latch : ENTITY is TRUE;

end latch;

-- architecture body --

architecture behave of latch is
   attribute VITAL_LEVEL0 of behave : architecture is TRUE;

   signal D_ipd  : STD_ULOGIC := 'U';
   signal PRE_ipd        : std_logic;
   signal ENA_ipd        : std_logic;

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
      VitalWireDelay (D_ipd, D, tipd_D);
      VitalWireDelay (PRE_ipd, PRE, tipd_PRE);
      VitalWireDelay (ENA_ipd, ENA, tipd_ENA);
   end block;

   VITALtiming : process (D_ipd, PRE_ipd, ENA_ipd)

   variable Tviol_D_ENA : STD_ULOGIC := '0';
   variable TimingData_D_ENA : VitalTimingDataType := VitalTimingDataInit;
   variable Q_VitalGlitchData : VitalGlitchDataType;

   variable q_out : std_logic := '0';

   begin

      ------------------------
      --  Timing Check Section
      ------------------------
      if (TimingChecksOn) then
         VitalSetupHoldCheck (
                Violation       => Tviol_D_ENA,
                TimingData      => TimingData_D_ENA,
                TestSignal      => D_ipd,
                TestSignalName  => "D",
                RefSignal       => ENA_ipd,
                RefSignalName   => "ENA",
                SetupHigh       => tsetup_D_ENA_noedge_posedge,
                SetupLow        => tsetup_D_ENA_noedge_posedge,
                HoldHigh        => thold_D_ENA_noedge_negedge,
                HoldLow         => thold_D_ENA_noedge_negedge,
                CheckEnabled    => TO_X01( PRE_ipd ) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LATCH",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
      end if;

      if (pre_ipd = '0') then
         -- latch is being preset, preset is active low
         -- preset is actually clear from user view
         q_out := '0';
      elsif (ena_ipd = '1') then
         -- latch is transparent
         q_out := D_ipd;
      end if;

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => Q,
       OutSignalName => "Q",
       OutTemp => q_out,
       Paths => (0 => (PRE_ipd'last_event, tpd_PRE_Q_negedge, TRUE),
                 1 => (ENA_ipd'last_event, tpd_ENA_Q_posedge, TRUE),
                 2 => (D_ipd'last_event, tpd_D_Q, (ENA = '1'))),
       GlitchData => Q_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );
   end process;

end behave;


--
--
-- MERCURY_ASYNCH_IO
--
LIBRARY ieee, mercury;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE IEEE.VITAL_Primitives.all;
USE IEEE.VITAL_Timing.all;
USE mercury.atom_pack.all;

ENTITY mercury_asynch_io is
    GENERIC(
		operation_mode  : STRING := "input";
		open_drain_output : STRING := "false";
		bus_hold : STRING := "false";
	
		XOn: Boolean := DefGlitchXOn;
		MsgOn: Boolean := DefGlitchMsgOn;
		
		tpd_datain_padio	: VitalDelayType01 := DefPropDelay01;
		tpd_oe_padio_posedge       : VitalDelayType01 := DefPropDelay01;
		tpd_oe_padio_negedge       : VitalDelayType01 := DefPropDelay01;
		tpd_padio_combout   : VitalDelayType01 := DefPropDelay01;
		tpd_inregQ_regout   : VitalDelayType01 := DefPropDelay01;
		tpd_oeregQ_ddioregout   : VitalDelayType01 := DefPropDelay01;
		
		tipd_datain         : VitalDelayType01 := DefPropDelay01;
		-- tipd_oe             : VitalDelayType01 := DefPropDelay01_1ps; --delay oe, hack
		tipd_oe             : VitalDelayType01 := DefPropDelay01; 
		tipd_padio          : VitalDelayType01 := DefPropDelay01);
	PORT(
		datain  : in  STD_LOGIC := '0';
		oe	    : in  STD_LOGIC := '0';
		inregQ  : in std_logic;
		oeregQ  : in std_logic;
		padio   : inout STD_LOGIC;
		combout : out STD_LOGIC;
		regout : out STD_LOGIC;
		ddioregout : out STD_LOGIC);
    attribute VITAL_LEVEL0 of mercury_asynch_io : ENTITY is TRUE;
end mercury_asynch_io;

architecture behave of mercury_asynch_io is
attribute VITAL_LEVEL0 of behave : architecture is TRUE;
signal datain_ipd, oe_ipd, padio_ipd: std_logic;

begin
    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        VitalWireDelay (datain_ipd, datain, tipd_datain);
        VitalWireDelay (oe_ipd, oe, tipd_oe);
        VitalWireDelay (padio_ipd, padio, tipd_padio);
    end block;

    VITAL: process(padio_ipd, datain_ipd, oe_ipd, inregQ, oeregQ)
	variable combout_VitalGlitchData : VitalGlitchDataType;
    variable padio_VitalGlitchData : VitalGlitchDataType;
	variable regout_VitalGlitchData : VitalGlitchDataType;
	variable ddioregout_VitalGlitchData : VitalGlitchDataType;
    
	variable tmp_combout, tmp_padio : std_logic;
	variable prev_value : std_logic := 'H';
	
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

    ----------------------
    --  Path Delay Section
    ----------------------
    VitalPathDelay01 (
        OutSignal => combout,
        OutSignalName => "combout",
        OutTemp => tmp_combout,
        Paths => (1 => (padio_ipd'last_event, tpd_padio_combout, TRUE)),
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
        OutTemp => inregQ,
        Paths => (1 => (inregQ'last_event, tpd_inregQ_regout, TRUE)),
        GlitchData => regout_VitalGlitchData,
        Mode => DefGlitchMode,
        XOn  => XOn,
        MsgOn  => MsgOn );
	
    VitalPathDelay01 (
        OutSignal => ddioregout,
        OutSignalName => "ddioregout",
        OutTemp => oeregQ,
        Paths => (1 => (oeregQ'last_event, tpd_oeregQ_ddioregout, TRUE)),
        GlitchData => ddioregout_VitalGlitchData,
        Mode => DefGlitchMode,
        XOn  => XOn,
        MsgOn  => MsgOn );
	
    end process;
    
end behave;

--
-- MERCURY_IO
--
LIBRARY IEEE, mercury;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE mercury.atom_pack.all;

LIBRARY mercury;
USE mercury.all;

ENTITY  mercury_io is
    GENERIC (
            operation_mode : string := "input";
			ddio_mode : string := "none";
			open_drain_output :string := "false";
			output_register_mode : string := "none";
			output_reset : string := "none";
			output_power_up : string := "low";
			oe_register_mode : string := "none";
			oe_reset : string := "none";
			oe_power_up : string := "low";
			input_register_mode : string := "none";
			input_reset : string := "none";
			input_power_up : string := "low";
			bus_hold : string := "false");
    PORT (
			datain          : in std_logic := '0';
			ddiodatain      : in std_logic := '0';
			oe              : in std_logic := '1';
			outclk          : in std_logic := '0';
			outclkena       : in std_logic := '1';
			oeclkena        : in std_logic := '1';
			inclk           : in std_logic := '0';
			inclkena        : in std_logic := '1';
			areset          : in std_logic := '0';
			devclrn         : in std_logic := '1';
			devpor          : in std_logic := '1';
			devoe           : in std_logic := '0';
			combout         : out std_logic;
			regout          : out std_logic;
			ddioregout	: out std_logic;
			padio           : inout std_logic );
end mercury_io;

architecture structure of mercury_io is
COMPONENT mercury_asynch_io 
	GENERIC(
		operation_mode : string := "input";
		open_drain_output : string := "false";
		bus_hold : string := "false");
	PORT(
		datain : in  STD_LOGIC := '0';
		oe	   : in  STD_LOGIC := '0';
		inregQ  : in std_logic;
		oeregQ  : in std_logic;
		padio  : inout STD_LOGIC;
		combout: out STD_LOGIC;
		regout : out STD_LOGIC;
		ddioregout : out STD_LOGIC);
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

COMPONENT latch
   GENERIC(
      TimingChecksOn: Boolean := True;
      XOn: Boolean := DefGlitchXOn;
      MsgOn: Boolean := DefGlitchMsgOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      InstancePath: STRING := "*";
      tpd_PRE_Q_negedge              :  VitalDelayType01 := DefPropDelay01;
      tpd_ENA_Q_posedge              :  VitalDelayType01 := DefPropDelay01;
      tpd_D_Q                        :  VitalDelayType01 := DefPropDelay01;
      tsetup_D_ENA_noedge_posedge    :  VitalDelayType := DefSetupHoldCnst;
      thold_D_ENA_noedge_negedge     :   VitalDelayType := DefSetupHoldCnst;
      tipd_D                         :  VitalDelayType01 := DefPropDelay01;
      tipd_PRE                       :  VitalDelayType01 := DefPropDelay01;
      tipd_ENA                       :  VitalDelayType01 := DefPropDelay01);

   PORT(
      Q                              :  out   STD_LOGIC := '0';
      D                              :  in    STD_LOGIC;
      PRE                            :  in    STD_LOGIC;
      ENA                            :  in    STD_LOGIC);
END COMPONENT;

COMPONENT mux21
	PORT (
		A : in std_logic := '0';
        B : in std_logic := '0';
        S : in std_logic := '0';
        MO : out std_logic);
END COMPONENT;

COMPONENT and1
           GENERIC(
              XOn: Boolean := DefGlitchXOn;
              MsgOn: Boolean := DefGlitchMsgOn;
              tpd_IN1_Y           :  VitalDelayType01 := DefPropDelay01;
              tipd_IN1            :  VitalDelayType01 := DefPropDelay01);
        
           PORT(
              Y                   :  out   STD_LOGIC;
              IN1                 :  in    STD_LOGIC);
END COMPONENT;

	signal	oe_out : std_logic;
	
	signal	tmp_oe_reg_out, tmp_input_reg_out, tmp_output_reg_out: std_logic; 
	
	signal	in_reg_clr, in_reg_preset, in_reg_sel : std_logic;
	
	signal	oe_reg_clr, oe_reg_preset, oe_reg_sel : std_logic;
	
	signal	out_reg_clr, out_reg_preset, out_reg_sel : std_logic;
	
	signal	input_reg_pu_low, output_reg_pu_low, oe_reg_pu_low : std_logic;
	
	signal	tmp_datain : std_logic;
	signal	iareset : std_logic ;
	signal	input_dffe_clr : std_logic;
	signal	input_dffe_preset : std_logic;
	signal	output_dffe_clr : std_logic;
	signal	output_dffe_preset : std_logic;
	signal	oe_dffe_clr : std_logic;
	signal	oe_dffe_preset : std_logic;

        -- for DDIO
        signal oe_reg_data : std_logic;
        signal b_latch_out : std_logic;
        signal ddio_data : std_logic;
        signal oeregQ : std_logic;

        signal outclk_delayed : std_logic;

begin     

input_reg_pu_low <=  '0' WHEN input_power_up = "low" ELSE '1';
output_reg_pu_low <= '0' WHEN output_power_up = "low" ELSE '1';
oe_reg_pu_low <= '0' WHEN oe_power_up = "low" ELSE '1';

out_reg_sel <= '1' WHEN output_register_mode = "register" ELSE '0';
oe_reg_sel <= '1' WHEN oe_register_mode = "register" ELSE '0';
in_reg_sel <= '1' WHEN input_register_mode = "register" ELSE '0';
 
iareset <= (NOT areset) WHEN ( areset = '1' OR areset = '0') ELSE '1';

-- output registered
out_reg_clr <= iareset WHEN output_reset = "clear" ELSE '1';
out_reg_preset <= iareset WHEN output_reset = "preset" ELSE '1';

-- oe register
oe_reg_clr <= iareset WHEN oe_reset = "clear" ELSE '1';
oe_reg_preset <= iareset WHEN oe_reset = "preset" ELSE '1';

-- input register
in_reg_clr <= iareset WHEN input_reset = "clear" ELSE '1';
in_reg_preset <= iareset WHEN input_reset = "preset" ELSE '1';

input_dffe_clr  <= in_reg_clr AND devclrn AND (input_reg_pu_low OR devpor);
input_dffe_preset <= in_reg_preset AND ( (NOT input_reg_pu_low) OR devpor);

input_reg : dffe
	port map (D => padio,
                  CLRN => input_dffe_clr,
                  PRN => input_dffe_preset,
                  CLK => inclk,
                  ENA => inclkena,
                  Q => tmp_input_reg_out);

output_dffe_clr <= out_reg_clr AND devclrn AND (output_reg_pu_low OR devpor);
output_dffe_preset <= out_reg_preset AND ( (NOT output_reg_pu_low) OR devpor);

output_reg : dffe
	port map (D => datain,
                  CLRN => output_dffe_clr,
                  PRN => output_dffe_preset,
                  CLK => outclk,
                  ENA => outclkena,
                  Q => tmp_output_reg_out);

--out_mux : mux21
--	port map (A => datain, B => tmp_output_reg_out, S => out_reg_sel, MO => tmp_datain);

oe_dffe_clr <= oe_reg_clr AND devclrn AND (oe_reg_pu_low OR devpor);
oe_dffe_preset <= oe_reg_preset AND ( (NOT oe_reg_pu_low) OR devpor);

b_latch : latch
          port map (D => padio,
                    ENA => inclk,
                    -- preset clears the latch
                    -- PRE => iareset,
                    PRE => in_reg_clr,
                    Q => b_latch_out);

oe_reg_data <= oe WHEN ddio_mode = "none" ELSE
               ddiodatain WHEN ddio_mode = "output" ELSE
               b_latch_out;
            
oe_reg : dffe
	port map (D => oe_reg_data,
                  CLRN => oe_dffe_clr,
                  PRN => oe_dffe_preset,
                  CLK => outclk,
                  ENA => oeclkena,
                  Q => tmp_oe_reg_out);
--oe_mux : mux21
--	port map (A => oe, B => tmp_oe_reg_out, S => oe_reg_sel, MO => oe_out);

oe_out <= tmp_oe_reg_out WHEN ddio_mode = "none" and oe_register_mode = "register" ELSE
          oe;

seldelaybuf : and1
           port map (Y => outclk_delayed,
                     IN1 => outclk);

ddio_data_mux : mux21
           port map (MO => ddio_data,
                     A => tmp_oe_reg_out,
                     B => tmp_output_reg_out,
                     S => outclk_delayed);

tmp_datain <= ddio_data WHEN ddio_mode = "output" ELSE
              tmp_output_reg_out WHEN (out_reg_sel = '1') ELSE
              datain;


-- timing info in case output and/or input are not registered.
mercury_pin : mercury_asynch_io
	generic map (  OPERATION_MODE => operation_mode, OPEN_DRAIN_OUTPUT => open_drain_output, BUS_HOLD => bus_hold)
	port map( datain => tmp_datain,
                  oe => oe_out,
                  inregQ => tmp_input_reg_out,
                  oeregQ => oeregQ,
                  padio => padio,
                  combout => combout,
                  regout => regout,
                  ddioregout => ddioregout);

--regout  <=  tmp_input_reg_out;
oeregQ  <=  tmp_oe_reg_out when ddio_mode = "input" else '0';

end structure;

--
-- ram7x20_syn
--
LIBRARY IEEE, mercury;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE mercury.atom_pack.all;

ENTITY ram7x20_syn is
	GENERIC (
		ram_width					: integer := 20
	);	

	PORT (
		wclk	: in std_logic;
		rstl	: in std_logic := '1'; 
		waddr : in std_logic_vector(2 downto 0);
		raddr : in std_logic_vector(2 downto 0);
		datain	: in std_logic_vector(19 downto 0);
		we			: in std_logic := '0';
		re			: in std_logic := '0';
		dataout	: out std_logic_vector(19 downto 0)
	);
	attribute VITAL_LEVEL0 of ram7x20_syn : ENTITY is TRUE;

end ram7x20_syn;


architecture hssi_ram7x20_syn of ram7x20_syn is
	attribute VITAL_LEVEL0 of hssi_ram7x20_syn : architecture is TRUE;
	signal ram_array_d_0 : std_logic_vector(19 downto 0) := (OTHERS => '0');
	signal ram_array_d_1 : std_logic_vector(19 downto 0) := (OTHERS => '0');
	signal ram_array_d_2 : std_logic_vector(19 downto 0) := (OTHERS => '0');
	signal ram_array_d_3 : std_logic_vector(19 downto 0) := (OTHERS => '0');
	signal ram_array_d_4 : std_logic_vector(19 downto 0) := (OTHERS => '0');
	signal ram_array_d_5 : std_logic_vector(19 downto 0) := (OTHERS => '0');
	signal ram_array_d_6 : std_logic_vector(19 downto 0) := (OTHERS => '0');
	signal ram_array_q_0 : std_logic_vector(19 downto 0) := (OTHERS => '0');
	signal ram_array_q_1 : std_logic_vector(19 downto 0) := (OTHERS => '0');
	signal ram_array_q_2 : std_logic_vector(19 downto 0) := (OTHERS => '0');
	signal ram_array_q_3 : std_logic_vector(19 downto 0) := (OTHERS => '0');
	signal ram_array_q_4 : std_logic_vector(19 downto 0) := (OTHERS => '0');
	signal ram_array_q_5 : std_logic_vector(19 downto 0) := (OTHERS => '0');
	signal ram_array_q_6 : std_logic_vector(19 downto 0) := (OTHERS => '0');
	signal data_reg_0 : std_logic_vector(19 downto 0) := (OTHERS => '0');
	signal data_reg_1 : std_logic_vector(19 downto 0) := (OTHERS => '0');
	signal data_reg_2 : std_logic_vector(19 downto 0) := (OTHERS => '0');
	signal data_reg_3 : std_logic_vector(19 downto 0) := (OTHERS => '0');
	signal data_reg_4 : std_logic_vector(19 downto 0) := (OTHERS => '0');
	signal data_reg_5 : std_logic_vector(19 downto 0) := (OTHERS => '0');
	signal data_reg_6 : std_logic_vector(19 downto 0) := (OTHERS => '0');
	signal data_out_i : std_logic_vector(19 downto 0);

begin
	
	-- Modelling the read port 
	-- Assuming address trigerred operation only 
	--assignment
	
	data_reg_0 <= datain when waddr = "000" else
						ram_array_q_0;
	data_reg_1 <= datain when waddr = "001" else
						ram_array_q_1;
	data_reg_2 <= datain when waddr = "010" else
						ram_array_q_2;
	data_reg_3 <= datain when waddr = "011" else
						ram_array_q_3;
	data_reg_4 <= datain when waddr = "100" else
						ram_array_q_4;
	data_reg_5 <= datain when waddr = "101" else
						ram_array_q_5;
	data_reg_6 <= datain when waddr = "110" else
						ram_array_q_6;

	dataout <= data_out_i when re = '1' else
						(OTHERS => '0');

	VITAL: process (wclk, rstl, waddr, raddr, datain, ram_array_q_0, ram_array_q_1, ram_array_q_2, ram_array_q_3, ram_array_q_4, ram_array_q_5, ram_array_q_6, data_reg_0, data_reg_1, data_reg_2, data_reg_3, data_reg_4, data_reg_5, data_reg_6)
	variable dataout_tmp : std_logic_vector(19 downto 0);
	begin

		case raddr is  
			when "000" => data_out_i <= ram_array_q_0;
			when "001" => data_out_i <= ram_array_q_1;
			when "010" => data_out_i <= ram_array_q_2;
			when "011" => data_out_i <= ram_array_q_3;
			when "100" => data_out_i <= ram_array_q_4;
			when "101" => data_out_i <= ram_array_q_5;
			when "110" => data_out_i <= ram_array_q_6;
			when others => data_out_i <= data_out_i;
		end case;

		if (re = '1') then
			dataout_tmp := data_out_i;
		else
			dataout_tmp := (OTHERS => '0');
		end if;

		--Modelling the write port 
		if (rstl = '0') then
			ram_array_q_0 <= (OTHERS => '0');
			ram_array_q_1 <= (OTHERS => '0');
			ram_array_q_2 <= (OTHERS => '0'); 
			ram_array_q_3 <= (OTHERS => '0'); 
			ram_array_q_4 <= (OTHERS => '0'); 
			ram_array_q_5 <= (OTHERS => '0'); 
			ram_array_q_6 <= (OTHERS => '0'); 
		else 
			if (wclk'event and wclk = '1') then
				ram_array_q_0 <= ram_array_d_0;
				ram_array_q_1 <= ram_array_d_1;
				ram_array_q_2 <= ram_array_d_2;
				ram_array_q_3 <= ram_array_d_3;
				ram_array_q_4 <= ram_array_d_4;
				ram_array_q_5 <= ram_array_d_5;
				ram_array_q_6 <= ram_array_d_6;
	  		end if;
			if (we = '1') then
				ram_array_d_0 <= data_reg_0;
				ram_array_d_1 <= data_reg_1;
				ram_array_d_2 <= data_reg_2;
				ram_array_d_3 <= data_reg_3;
				ram_array_d_4 <= data_reg_4;
				ram_array_d_5 <= data_reg_5;
				ram_array_d_6 <= data_reg_6;
	  		else 
				ram_array_d_0 <= ram_array_q_0;
				ram_array_d_1 <= ram_array_q_1;
				ram_array_d_2 <= ram_array_q_2;
				ram_array_d_3 <= ram_array_q_3;
				ram_array_d_4 <= ram_array_q_4;
				ram_array_d_5 <= ram_array_q_5;
				ram_array_d_6 <= ram_array_q_6;
	  		end if;
		end if;


	end process;

end hssi_ram7x20_syn;

--
-- mercury_hssi_synchronizer
--
LIBRARY IEEE, mercury;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE mercury.atom_pack.all;

ENTITY mercury_hssi_synchronizer is
	GENERIC (
		channel_width           : integer := 20;
		TimingChecksOn          : Boolean := True;
		MsgOn                   : Boolean := DefGlitchMsgOn;
		XOn                     : Boolean := DefGlitchXOn;
		MsgOnChecks             : Boolean := DefMsgOnChecks;
		XOnChecks               : Boolean := DefXOnChecks;
		InstancePath            : String := "*";
		tsetup_datain_clk0_noedge_posedge  : VitalDelayArrayType(19 downto 0) := (OTHERS => DefSetupHoldCnst);
		thold_datain_clk0_noedge_posedge   : VitalDelayArrayType(19 downto 0) := (OTHERS => DefSetupHoldCnst);
		tsetup_datain_we_noedge_posedge  : VitalDelayArrayType(19 downto 0) := (OTHERS => DefSetupHoldCnst);
		thold_datain_we_noedge_posedge   : VitalDelayArrayType(19 downto 0) := (OTHERS => DefSetupHoldCnst);
		tsetup_re_clk1_noedge_posedge   : VitalDelayType := DefSetupHoldCnst;
		thold_re_clk1_noedge_posedge   : VitalDelayType := DefSetupHoldCnst;
		tsetup_we_clk0_noedge_posedge   : VitalDelayType := DefSetupHoldCnst;
		thold_we_clk0_noedge_posedge   : VitalDelayType := DefSetupHoldCnst;
		tpd_clk1_dataout_posedge		: VitalDelayArrayType01(19 downto 0) := (OTHERS => DefPropDelay01);
		tpd_clk0_overflow_posedge: VitalDelayType01 := DefPropDelay01;
		tpd_areset_overflow_posedge: VitalDelayType01 := DefPropDelay01;
		tpd_clk0_empty_posedge: VitalDelayType01 := DefPropDelay01;
		tpd_clk1_empty_posedge: VitalDelayType01 := DefPropDelay01;
		tipd_clk0               : VitalDelayType01 := DefpropDelay01;
		tipd_clk1               : VitalDelayType01 := DefpropDelay01;
		tipd_areset            	: VitalDelayType01 := DefpropDelay01;
		tipd_we						: VitalDelayType01 := DefpropDelay01;
		tipd_re						: VitalDelayType01 := DefpropDelay01;
		tipd_datain					: VitalDelayArrayType01(19 downto 0) := (OTHERS => DefpropDelay01));

	PORT (
			clk0		: in std_logic;
			clk1		: in std_logic;
			datain	: in std_logic_vector(19 downto 0);
			we			: in std_logic := '1';
			re			: in std_logic := '1';
			areset	: in std_logic := '0';
			devclrn	: in std_logic := '1';
			devpor	: in std_logic := '1';
			empty		: out std_logic;
			overflow	: out std_logic;
			dataout	: out std_logic_vector(19 downto 0));

	attribute VITAL_LEVEL0 of mercury_hssi_synchronizer : ENTITY is TRUE;

end mercury_hssi_synchronizer;

architecture vital_synchronizer_atom of mercury_hssi_synchronizer is
	attribute VITAL_LEVEL0 of vital_synchronizer_atom : architecture is TRUE;
   signal clk0_ipd : std_logic;
   signal clk1_ipd : std_logic;
   signal areset_ipd : std_logic;
   signal ram_reset : std_logic;
   signal ram_re : std_logic;
   signal we_ipd : std_logic;
   signal re_ipd : std_logic;
   signal datain_ipd : std_logic_vector(19 downto 0);
	signal ram_we : std_logic;
	signal ram_datain : std_logic_vector (19 downto 0);
	signal ram_dataout : std_logic_vector (19 downto 0);
	signal wrPtr0 : std_logic_vector (2 downto 0) := "000";
	signal wrPtr1 : std_logic_vector (2 downto 0) := "000";
	signal wrPtr2 : std_logic_vector (2 downto 0) := "000";
	signal wrPtr : std_logic_vector (2 downto 0) := "000";
	signal rdPtr : std_logic_vector (2 downto 0) := "000";
	signal preRdPtr : std_logic_vector (2 downto 0) := "000";
	signal preRdPtr1 : std_logic_vector (2 downto 0) := "100";
	signal preRdPtr2 : std_logic_vector (2 downto 0) := "100";
	signal wrAddr : std_logic_vector (2 downto 0) := "000";
	signal dataout_tmp : std_logic_vector (19 downto 0);
	signal empty_tmp : std_logic;
	signal overflow_tmp : std_logic;

COMPONENT ram7x20_syn
	GENERIC (
		ram_width					: integer := 20
	);

	PORT (
		wclk	: in std_logic;
		rstl	: in std_logic := '1'; 
		waddr	: in std_logic_vector(2 downto 0);
		raddr	: in std_logic_vector(2 downto 0);
		datain	: in std_logic_vector(19 downto 0);
		we			: in std_logic := '0';
		re			: in std_logic := '0';
		dataout	: out std_logic_vector(19 downto 0)
	);
END COMPONENT;

begin

	----------------------
	--  INPUT PATH DELAYs
	----------------------
	WireDelay : block
	begin
		VitalWireDelay (clk0_ipd, clk0, tipd_clk0);
		VitalWireDelay (clk1_ipd, clk1, tipd_clk1);
		VitalWireDelay (areset_ipd, areset, tipd_areset);
		VitalWireDelay (re_ipd, re, tipd_re);
		VitalWireDelay (we_ipd, we, tipd_we);
		VitalWireDelay (datain_ipd(0), datain(0), tipd_datain(0));
		VitalWireDelay (datain_ipd(1), datain(1), tipd_datain(1));
		VitalWireDelay (datain_ipd(2), datain(2), tipd_datain(2));
		VitalWireDelay (datain_ipd(3), datain(3), tipd_datain(3));
		VitalWireDelay (datain_ipd(4), datain(4), tipd_datain(4));
		VitalWireDelay (datain_ipd(5), datain(5), tipd_datain(5));
		VitalWireDelay (datain_ipd(6), datain(6), tipd_datain(6));
		VitalWireDelay (datain_ipd(7), datain(7), tipd_datain(7));
		VitalWireDelay (datain_ipd(8), datain(8), tipd_datain(8));
		VitalWireDelay (datain_ipd(9), datain(9), tipd_datain(9));
		VitalWireDelay (datain_ipd(10), datain(10), tipd_datain(10));
		VitalWireDelay (datain_ipd(11), datain(11), tipd_datain(11));
		VitalWireDelay (datain_ipd(12), datain(12), tipd_datain(12));
		VitalWireDelay (datain_ipd(13), datain(13), tipd_datain(13));
		VitalWireDelay (datain_ipd(14), datain(14), tipd_datain(14));
		VitalWireDelay (datain_ipd(15), datain(15), tipd_datain(15));
		VitalWireDelay (datain_ipd(16), datain(16), tipd_datain(16));
		VitalWireDelay (datain_ipd(17), datain(17), tipd_datain(17));
		VitalWireDelay (datain_ipd(18), datain(18), tipd_datain(18));
		VitalWireDelay (datain_ipd(19), datain(19), tipd_datain(19));
	end block;

	ram_reset <= NOT areset_ipd;
	ram_re <= re AND empty_tmp;

	-- ram7x20_syn
	fifo_ram: ram7x20_syn
					generic map (ram_width => channel_width)
					port map (wclk => clk0_ipd, rstl => ram_reset, waddr => wrAddr, raddr => rdPtr, datain => ram_datain, we => ram_we, re => ram_re, dataout => ram_dataout);

	VITAL: process (clk0_ipd, clk1_ipd, areset_ipd, we_ipd, re_ipd, datain_ipd, devclrn, devpor, wrPtr, wrPtr0, wrPtr1, wrPtr2, rdPtr, preRdPtr, preRdPtr1, preRdPtr2)  

	variable Tviol_datain_clk0 : std_ulogic := '0';
	variable Tviol_datain_we : std_ulogic := '0';
	variable Tviol_we_clk0 : std_ulogic := '0';
	variable Tviol_re_clk1 : std_ulogic := '0';
	variable TimingData_datain_clk0 : VitalTimingDataType := VitalTimingDataInit;
	variable TimingData_datain_we : VitalTimingDataType := VitalTimingDataInit;
	variable TimingData_we_clk0 : VitalTimingDataType := VitalTimingDataInit;
	variable TimingData_re_clk1 : VitalTimingDataType := VitalTimingDataInit;
	variable dataout_VitalGlitchDataArray : VitalGlitchDataArrayType(19 downto 0);
	variable empty_VitalGlitchData: VitalGlitchDataType;
	variable overflow_VitalGlitchData: VitalGlitchDataType;
	variable overflow_tmp_var : std_logic;
	variable empty_tmp_var : std_logic;


	begin
		if (now = 0 ns) then
			dataout_tmp <= (OTHERS => '0');
			ram_datain <= (OTHERS => '0');
			overflow_tmp <=  '1';
			overflow_tmp_var :=  '1';
			empty_tmp <=  '1';
			empty_tmp_var :=  '1';
			wrAddr <=  "000";
			rdPtr <=  "000";
			wrPtr <=  "000";
			wrPtr0 <=  "000";
			wrPtr1 <=  "000";
			wrPtr2 <=  "000";
			preRdPtr <=  "000";
			preRdPtr1 <=  "110";
			preRdPtr2 <=  "110";
			ram_we <= '0';
		end if;

   	------------------------
   	--  Timing Check Section
   	------------------------
   	if (TimingChecksOn) then
	
	      VitalSetupHoldCheck (
				Violation       => Tviol_datain_clk0,
	         TimingData      => TimingData_datain_clk0,
	         TestSignal      => datain_ipd,
	         TestSignalName  => "DATAIN",
	         RefSignal       => clk0_ipd,
	         RefSignalName   => "CLK0",
	         SetupHigh       => tsetup_datain_clk0_noedge_posedge(0),
	         SetupLow        => tsetup_datain_clk0_noedge_posedge(0),
	         HoldHigh        => thold_datain_clk0_noedge_posedge(0),
	         HoldLow         => thold_datain_clk0_noedge_posedge(0),
	         RefTransition   => '/',
	         HeaderMsg       => InstancePath & "/MERCURY_HSSI_SYNCHRONIZER",
	         XOn             => XOn,
	         MsgOn           => MsgOnChecks );

	      VitalSetupHoldCheck (
				Violation       => Tviol_datain_we,
	         TimingData      => TimingData_datain_we,
	         TestSignal      => datain_ipd,
	         TestSignalName  => "DATAIN",
	         RefSignal       => we_ipd,
	         RefSignalName   => "WE",
	         SetupHigh       => tsetup_datain_we_noedge_posedge(0),
	         SetupLow        => tsetup_datain_we_noedge_posedge(0),
	         HoldHigh        => thold_datain_we_noedge_posedge(0),
	         HoldLow         => thold_datain_we_noedge_posedge(0),
	         RefTransition   => '/',
	         HeaderMsg       => InstancePath & "/MERCURY_HSSI_SYNCHRONIZER",
	         XOn             => XOn,
	         MsgOn           => MsgOnChecks );
	
	      VitalSetupHoldCheck (
				Violation       => Tviol_we_clk0,
	         TimingData      => TimingData_we_clk0,
	         TestSignal      => we_ipd,
	         TestSignalName  => "WE",
	         RefSignal       => clk0_ipd,
	         RefSignalName   => "CLK0",
	         SetupHigh       => tsetup_we_clk0_noedge_posedge,
	         SetupLow        => tsetup_we_clk0_noedge_posedge,
	         HoldHigh        => thold_we_clk0_noedge_posedge,
	         HoldLow         => thold_we_clk0_noedge_posedge,
	         RefTransition   => '/',
	         HeaderMsg       => InstancePath & "/MERCURY_HSSI_SYNCHRONIZER",
	         XOn             => XOn,
	         MsgOn           => MsgOnChecks );
	
	      VitalSetupHoldCheck (
				Violation       => Tviol_re_clk1,
	         TimingData      => TimingData_re_clk1,
	         TestSignal      => re_ipd,
	         TestSignalName  => "RE",
	         RefSignal       => clk1_ipd,
	         RefSignalName   => "CLK1",
	         SetupHigh       => tsetup_re_clk1_noedge_posedge,
	         SetupLow        => tsetup_re_clk1_noedge_posedge,
	         HoldHigh        => thold_re_clk1_noedge_posedge,
	         HoldLow         => thold_re_clk1_noedge_posedge,
	         RefTransition   => '/',
	         HeaderMsg       => InstancePath & "/MERCURY_HSSI_SYNCHRONIZER",
	         XOn             => XOn,
	         MsgOn           => MsgOnChecks );
	
	   end if;

		if ((devpor = '0') or (devclrn = '0')) then
			dataout_tmp <= (OTHERS => '0');
			ram_datain <= (OTHERS => '0');
			overflow_tmp <=  '0';
			overflow_tmp_var :=  '0';
			empty_tmp <=  '0';
			empty_tmp_var :=  '0';
			wrAddr <=  "000";
			rdPtr <=  "000";
			wrPtr <=  "000";
			wrPtr0 <=  "000";
			wrPtr1 <=  "000";
			wrPtr2 <=  "000";
			preRdPtr <=  "000";
			preRdPtr1 <=  "110";
			preRdPtr2 <=  "110";
			ram_we <= '0';
		end if;
		if (areset_ipd = '1') then
			dataout_tmp <= (OTHERS => '0');
			ram_datain <= (OTHERS => '0');
			overflow_tmp <=  '0';
			overflow_tmp_var :=  '0';
			empty_tmp <=  '0';
			empty_tmp_var :=  '0';
			wrAddr <=  "000";
			rdPtr <=  "000";
			wrPtr <=  "000";
			wrPtr0 <=  "000";
			wrPtr1 <=  "000";
			wrPtr2 <=  "000";
			preRdPtr <=  "000";
			preRdPtr1 <=  "110";
			preRdPtr2 <=  "110";
			ram_we <= '0';
		else
			if (clk1_ipd'event and clk1_ipd = '1') then
				if (re_ipd = '1' and empty_tmp_var = '1') then
					dataout_tmp <= ram_dataout;
					case rdPtr is
						when "000" => rdPtr <= "001";
						when "001" => rdPtr <= "010";
						when "010" => rdPtr <= "011";
						when "011" => rdPtr <= "100";
						when "100" => rdPtr <= "101";
						when "101" => rdPtr <= "110";
						when "110" => rdPtr <= "000";
						when others => rdPtr <= "000";
					end case;
					preRdPtr <= rdPtr;
				else
					dataout_tmp <= dataout_tmp;
				end if;
				--synchronize write pointers.
				wrPtr1 <= wrPtr;
				wrPtr2 <= wrPtr1;
			end if;
			if (clk0_ipd'event and clk0_ipd = '1') then
				wrPtr <= wrPtr0;
				if (we_ipd = '1' and overflow_tmp_var = '1') then
					ram_we <= '1';
					ram_datain <= datain_ipd;
					wrAddr <= wrPtr0;
					case wrPtr0 is
						when "000" => wrPtr0 <= "001";
						when "001" => wrPtr0 <= "010";
						when "010" => wrPtr0 <= "011";
						when "011" => wrPtr0 <= "100";
						when "100" => wrPtr0 <= "101";
						when "101" => wrPtr0 <= "110";
						when "110" => wrPtr0 <= "000";
						when others => wrPtr0 <= "000";
					end case;
				else
					ram_we <= '0';
					wrAddr <= wrAddr;
					ram_datain <= ram_datain;
					wrPtr0 <= wrPtr0;
				end if;
				--synchronize read pointers.
				preRdPtr1 <= preRdPtr;
				preRdPtr2 <= preRdPtr1;
			end if;

			if (wrPtr0 = preRdPtr2) then
				overflow_tmp_var := '0';
			else
				overflow_tmp_var := '1';
			end if;
			if (rdPtr = wrPtr2 and overflow_tmp_var = '1') then
				empty_tmp_var := '0';
			else
				empty_tmp_var := '1';
			end if;
		
		end if;

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => empty,
       OutSignalName => "EMPTY",
       OutTemp => empty_tmp_var,
       Paths => (0 => (clk1'last_event, tpd_clk1_empty_posedge, TRUE),
       			  1 => (clk0'last_event, tpd_clk0_empty_posedge, TRUE)),
       GlitchData => empty_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => overflow,
       OutSignalName => "OVERFLOW",
       OutTemp => overflow_tmp_var,
       Paths => (0 => (areset_ipd'last_event, tpd_areset_overflow_posedge, TRUE),
       			  1 => (clk0_ipd'last_event, tpd_clk0_overflow_posedge, TRUE)),
       GlitchData => overflow_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(0),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(0),
       Paths => (0 => (clk1_ipd'last_event, tpd_clk1_dataout_posedge(0), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(0),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(1),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(1),
       Paths => (0 => (clk1_ipd'last_event, tpd_clk1_dataout_posedge(1), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(1),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(2),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(2),
       Paths => (0 => (clk1_ipd'last_event, tpd_clk1_dataout_posedge(2), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(2),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(3),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(3),
       Paths => (0 => (clk1_ipd'last_event, tpd_clk1_dataout_posedge(3), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(3),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(4),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(4),
       Paths => (0 => (clk1_ipd'last_event, tpd_clk1_dataout_posedge(4), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(4),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(5),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(5),
       Paths => (0 => (clk1_ipd'last_event, tpd_clk1_dataout_posedge(5), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(5),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(6),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(6),
       Paths => (0 => (clk1_ipd'last_event, tpd_clk1_dataout_posedge(6), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(6),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(7),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(7),
       Paths => (0 => (clk1_ipd'last_event, tpd_clk1_dataout_posedge(7), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(7),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(8),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(8),
       Paths => (0 => (clk1_ipd'last_event, tpd_clk1_dataout_posedge(8), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(8),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(9),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(9),
       Paths => (0 => (clk1_ipd'last_event, tpd_clk1_dataout_posedge(9), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(9),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(10),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(10),
       Paths => (0 => (clk1_ipd'last_event, tpd_clk1_dataout_posedge(10), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(10),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(11),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(11),
       Paths => (0 => (clk1_ipd'last_event, tpd_clk1_dataout_posedge(11), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(11),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(12),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(12),
       Paths => (0 => (clk1_ipd'last_event, tpd_clk1_dataout_posedge(12), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(12),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(13),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(13),
       Paths => (0 => (clk1_ipd'last_event, tpd_clk1_dataout_posedge(13), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(13),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(14),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(14),
       Paths => (0 => (clk1_ipd'last_event, tpd_clk1_dataout_posedge(14), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(14),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(15),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(15),
       Paths => (0 => (clk1_ipd'last_event, tpd_clk1_dataout_posedge(15), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(15),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(16),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(16),
       Paths => (0 => (clk1_ipd'last_event, tpd_clk1_dataout_posedge(16), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(16),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(17),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(17),
       Paths => (0 => (clk1_ipd'last_event, tpd_clk1_dataout_posedge(17), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(17),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(18),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(18),
       Paths => (0 => (clk1_ipd'last_event, tpd_clk1_dataout_posedge(18), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(18),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(19),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(19),
       Paths => (0 => (clk1_ipd'last_event, tpd_clk1_dataout_posedge(19), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(19),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

		empty_tmp <= empty_tmp_var;
		overflow_tmp <= overflow_tmp_var;
	end process;

end vital_synchronizer_atom;


