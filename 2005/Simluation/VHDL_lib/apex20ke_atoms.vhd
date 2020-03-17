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

end atom_pack;
--/////////////////////////////////////////////////////////////////////////////
--
--              VHDL Simulation Models for APEX20KE Atoms
--
--/////////////////////////////////////////////////////////////////////////////
--
--/////////////////////////////////////////////////////////////////////////////

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : mux21
--
-- Description : Simulation model for a 2 to 1 mux used in the RAM_SLICE
--               This is a purely functional module, without any timing.
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mux21 is
     PORT (
                A : in std_logic := '0';
                B : in std_logic := '0';
                S : in std_logic := '0';
                MO : out std_logic);
end mux21;

ARCHITECTURE structure of mux21 is
begin
   MO <= B when (S = '1') else A;
end structure;


LIBRARY IEEE, apex20ke;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use apex20ke.atom_pack.all;

ENTITY dffe_io is
   GENERIC (
      TimingChecksOn: Boolean := True;
      XGenerationOn: Boolean := False;
      XOn: Boolean := DefGlitchXOn;
      MsgOn: Boolean := DefGlitchMsgOn;
      XOnChecks: Boolean := DefXOnChecks;
      MsgOnChecks: Boolean := DefMsgOnChecks;
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

   PORT (
      Q                              :  out   STD_LOGIC;
      D                              :  in    STD_LOGIC;
      CLRN                           :  in    STD_LOGIC;
      PRN                            :  in    STD_LOGIC;
      CLK                            :  in    STD_LOGIC;
      ENA                            :  in    STD_LOGIC);
   attribute VITAL_LEVEL0 of dffe_io : ENTITY is TRUE;
end dffe_io;

-- ARCHITECTURE body --

ARCHITECTURE behave of dffe_io is
   attribute VITAL_LEVEL0 of behave : ARCHITECTURE is TRUE;

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
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');

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

LIBRARY IEEE, apex20ke;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use apex20ke.atom_pack.all;

ENTITY apex20ke_asynch_lcell is
  GENERIC (operation_mode    : string := "normal";
      output_mode   : string := "comb_and_reg";
      lut_mask       : string := "ffff";
      power_up : string := "low";
      cin_used       : string := "false";
      TimingChecksOn: Boolean := True;
      MsgOn: Boolean := DefGlitchMsgOn;
      XOn: Boolean := DefGlitchXOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      InstancePath: STRING := "*";
      tpd_dataa_combout                 : VitalDelayType01 := DefPropDelay01;
      tpd_datab_combout                 : VitalDelayType01 := DefPropDelay01;
      tpd_datac_combout                 : VitalDelayType01 := DefPropDelay01;
      tpd_datad_combout                 : VitalDelayType01 := DefPropDelay01;
      tpd_qfbkin_combout                : VitalDelayType01 := DefPropDelay01;
      tpd_cin_combout                   : VitalDelayType01 := DefPropDelay01;
      tpd_cascin_combout	        : VitalDelayType01 := DefPropDelay01;
      tpd_dataa_regin                   : VitalDelayType01 := DefPropDelay01;
      tpd_datab_regin                   : VitalDelayType01 := DefPropDelay01;
      tpd_datac_regin                   : VitalDelayType01 := DefPropDelay01;
      tpd_datad_regin                   : VitalDelayType01 := DefPropDelay01;
      tpd_qfbkin_regin                  : VitalDelayType01 := DefPropDelay01;
      tpd_cin_regin                     : VitalDelayType01 := DefPropDelay01;
      tpd_cascin_regin  	        : VitalDelayType01 := DefPropDelay01;
      tpd_dataa_cout	                : VitalDelayType01 := DefPropDelay01;
      tpd_datab_cout	                : VitalDelayType01 := DefPropDelay01;
      tpd_datac_cout    	        : VitalDelayType01 := DefPropDelay01;
      tpd_datad_cout    	        : VitalDelayType01 := DefPropDelay01;
      tpd_qfbkin_cout                   : VitalDelayType01 := DefPropDelay01;
      tpd_cin_cout		        : VitalDelayType01 := DefPropDelay01;
      tpd_cascin_cascout	        : VitalDelayType01 := DefPropDelay01;
      tpd_cin_cascout    	        : VitalDelayType01 := DefPropDelay01;
      tpd_dataa_cascout	                : VitalDelayType01 := DefPropDelay01;
      tpd_datab_cascout	                : VitalDelayType01 := DefPropDelay01;
      tpd_datac_cascout    	        : VitalDelayType01 := DefPropDelay01;
      tpd_datad_cascout    	        : VitalDelayType01 := DefPropDelay01;
      tpd_qfbkin_cascout                : VitalDelayType01 := DefPropDelay01;
      tipd_dataa			: VitalDelayType01 := DefPropDelay01; 
      tipd_datab			: VitalDelayType01 := DefPropDelay01; 
      tipd_datac			: VitalDelayType01 := DefPropDelay01; 
      tipd_datad			: VitalDelayType01 := DefPropDelay01; 
      tipd_cin  			: VitalDelayType01 := DefPropDelay01; 
      tipd_cascin			: VitalDelayType01 := DefPropDelay01 );

  PORT (
        dataa     : in std_logic := '1';
        datab     : in std_logic := '1';
        datac     : in std_logic := '1';
        datad     : in std_logic := '1';
        cin       : in std_logic := '0';
        cascin    : in std_logic := '1';
        qfbkin    : in std_logic := '0';
        combout   : out std_logic;
        cout      : out std_logic;
        cascout   : out std_logic;
        regin     : out std_logic);
   attribute VITAL_LEVEL0 of apex20ke_asynch_lcell : ENTITY is TRUE;
end apex20ke_asynch_lcell;
        
ARCHITECTURE vital_le of apex20ke_asynch_lcell is
   attribute VITAL_LEVEL0 of vital_le : ARCHITECTURE is TRUE;
   signal dataa_ipd, datab_ipd : std_logic;
   signal datac_ipd, datad_ipd, cin_ipd, cascin_ipd : std_logic;
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
   VitalWireDelay (cascin_ipd, cascin, tipd_cascin);
   end block;

VITALtiming : process(dataa_ipd, datab_ipd, datac_ipd, datad_ipd, cin_ipd, cascin_ipd, qfbkin)

variable combout_VitalGlitchData : VitalGlitchDataType;
variable cout_VitalGlitchData : VitalGlitchDataType;
variable cascout_VitalGlitchData : VitalGlitchDataType;
variable regin_VitalGlitchData : VitalGlitchDataType;

variable icomb, icomb1, icout : std_logic;
variable idata, setbit : std_logic := '0';
variable tmp_combout, tmp_cascout, tmp_cout, tmp_regin : std_logic;
variable lut_mask_std : std_logic_vector (15 downto 0) :=  str_to_bin(lut_mask); -- Added By ModelTech

begin


	if operation_mode = "normal" then
		if cin_used = "true" then
			icomb1 := VitalMUX(data => lut_mask_std,
                		  dselect => (datad_ipd, cin_ipd, datab_ipd, dataa_ipd)); -- Added By ModelTech
		else
			icomb1 := VitalMUX(data => lut_mask_std,
                		  dselect => (datad_ipd, datac_ipd, datab_ipd, dataa_ipd)); -- Added By ModelTech
		end if;
			icomb := icomb1 and cascin_ipd;
	end if;

	if operation_mode = "arithmetic" then
		icomb1 := VitalMUX(data => lut_mask_std,
                         dselect => ('1', cin_ipd, datab_ipd, dataa_ipd)); -- Added By ModelTech

		icout := VitalMUX(data => lut_mask_std,
                         dselect => ('0', cin_ipd, datab_ipd, dataa_ipd)); -- Added By ModelTech
		icomb := icomb1 and cascin_ipd;
	end if;

	if operation_mode = "counter" then
		icomb1 := VitalMUX(data => lut_mask_std,
                         dselect => ('1', cin_ipd, datab_ipd, dataa_ipd)); -- Added By ModelTech
		icout := VitalMUX(data => lut_mask_std,
                         dselect => ('0', cin_ipd, datab_ipd, dataa_ipd)); -- Added By ModelTech
		icomb := icomb1 and cascin_ipd;
	end if;

	if operation_mode = "qfbk_counter" then
		icomb1 := VitalMUX(data => lut_mask_std,
                         dselect => ('1', qfbkin, datab_ipd, dataa_ipd)); -- Added By ModelTech
		icout := VitalMUX(data => lut_mask_std,
                         dselect => ('0', qfbkin, datab_ipd, dataa_ipd)); -- Added By ModelTech
		icomb := icomb1 and cascin_ipd;
	end if;


	tmp_combout := icomb;
	tmp_cascout := icomb;
	tmp_cout := icout;
        tmp_regin := icomb;

      ----------------------
      --  Path Delay Section
      ----------------------

      VitalPathDelay01 (
       OutSignal => combout,
       OutSignalName => "COMBOUT",
       OutTemp => tmp_combout,
       Paths => (0 => (dataa_ipd'last_event, tpd_dataa_combout, TRUE),
                 1 => (datab_ipd'last_event, tpd_datab_combout, TRUE),
                 2 => (datac_ipd'last_event, tpd_datac_combout, TRUE),
                 3 => (datad_ipd'last_event, tpd_datad_combout, TRUE),
                 4 => (cin_ipd'last_event, tpd_cin_combout, TRUE),
                 5 => (cascin_ipd'last_event, tpd_cascin_combout, TRUE),
                 6 => (qfbkin'last_event, tpd_qfbkin_combout, TRUE)),
       GlitchData => combout_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn => MsgOn );

      VitalPathDelay01 (
       OutSignal => regin,
       OutSignalName => "REGIN",
       OutTemp => tmp_regin,
       Paths => (0 => (dataa_ipd'last_event, tpd_dataa_regin, TRUE),
                 1 => (datab_ipd'last_event, tpd_datab_regin, TRUE),
                 2 => (datac_ipd'last_event, tpd_datac_regin, TRUE),
                 3 => (datad_ipd'last_event, tpd_datad_regin, TRUE),
                 4 => (cin_ipd'last_event, tpd_cin_regin, TRUE),
                 5 => (cascin_ipd'last_event, tpd_cascin_regin, TRUE),
                 6 => (qfbkin'last_event, tpd_qfbkin_regin, TRUE)),
       GlitchData => regin_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn => MsgOn );

      VitalPathDelay01 ( 
       OutSignal => cascout, 
       OutSignalName => "CASCOUT",
       OutTemp => tmp_cascout,
       Paths => (0 => (dataa_ipd'last_event, tpd_dataa_cascout, TRUE),
                 1 => (datab_ipd'last_event, tpd_datab_cascout, TRUE),
                 2 => (datac_ipd'last_event, tpd_datac_cascout, TRUE),
                 3 => (datad_ipd'last_event, tpd_datad_cascout, TRUE),
                 4 => (cin_ipd'last_event, tpd_cin_cascout, TRUE),
                 5 => (cascin_ipd'last_event, tpd_cascin_cascout, TRUE),
                 6 => (qfbkin'last_event, tpd_qfbkin_cascout, TRUE)),
       GlitchData => cascout_VitalGlitchData,    
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
                 5 => (qfbkin'last_event, tpd_qfbkin_cout, TRUE)),
       GlitchData => cout_VitalGlitchData,    
       Mode => DefGlitchMode, 
       XOn  => XOn, 
       MsgOn => MsgOn );

end process;

end vital_le;	

LIBRARY IEEE, apex20ke;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use apex20ke.atom_pack.all;

ENTITY apex20ke_lcell_register is
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
      tpd_aclr_regout_posedge		: VitalDelayType01 := DefPropDelay01;
      tpd_clk_qfbko_posedge		: VitalDelayType01 := DefPropDelay01;
      tpd_aclr_qfbko_posedge		: VitalDelayType01 := DefPropDelay01;
      tperiod_clk_posedge               : VitalDelayType := DefPulseWdthCnst;
      tipd_datac  			: VitalDelayType01 := DefPropDelay01; 
      tipd_ena  			: VitalDelayType01 := DefPropDelay01; 
      tipd_aclr 			: VitalDelayType01 := DefPropDelay01; 
      tipd_sclr 			: VitalDelayType01 := DefPropDelay01; 
      tipd_sload 			: VitalDelayType01 := DefPropDelay01; 
      tipd_clk  			: VitalDelayType01 := DefPropDelay01);

  PORT (clk :in std_logic;
        datain  : in std_logic := '1';
        datac     : in std_logic := '1';
        aclr    : in std_logic := '0';
        sclr : in std_logic := '0';
        sload : in std_logic := '0';
        ena : in std_logic := '1';
        devclrn   : in std_logic := '1';
        devpor    : in std_logic := '1';
        regout    : out std_logic;
        qfbko     : out std_logic);
   attribute VITAL_LEVEL0 of apex20ke_lcell_register : ENTITY is TRUE;
end apex20ke_lcell_register;
        
ARCHITECTURE vital_le_reg of apex20ke_lcell_register is
   attribute VITAL_LEVEL0 of vital_le_reg : ARCHITECTURE is TRUE;
   signal ena_ipd, sload_ipd, datac_ipd : std_logic;
   signal clk_ipd, aclr_ipd, sclr_ipd : std_logic;
begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (datac_ipd, datac, tipd_datac);
   VitalWireDelay (clk_ipd, clk, tipd_clk);
   VitalWireDelay (aclr_ipd, aclr, tipd_aclr);
   VitalWireDelay (sclr_ipd, sclr, tipd_sclr);
   VitalWireDelay (sload_ipd, sload, tipd_sload);
   VitalWireDelay (ena_ipd, ena, tipd_ena);
   end block;

VITALtiming : process(clk_ipd, aclr_ipd, devclrn, devpor, sclr_ipd, ena_ipd, datain, datac_ipd, sload_ipd)

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
variable qfbko_VitalGlitchData : VitalGlitchDataType;

variable iregout : std_logic;
variable idata, setbit : std_logic := '0';
variable tmp_regout : std_logic;
variable tmp_qfbko : std_logic;

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
                CheckEnabled    => TO_X01((aclr_ipd) OR (NOT devpor) OR (NOT devclrn) OR (NOT ena_ipd)) /= '1',
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
                CheckEnabled    => TO_X01((aclr_ipd) OR (NOT devpor) OR (NOT devclrn)) /= '1',
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
                CheckEnabled    => TO_X01((aclr_ipd) OR (NOT devpor) OR (NOT devclrn)) /= '1',
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
                CheckEnabled    => TO_X01((aclr_ipd) OR (NOT devpor) OR (NOT devclrn)) /= '1',
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
                 CheckEnabled    => TO_X01((aclr_ipd) OR (NOT devpor) OR (NOT devclrn)) /= '1',
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
      elsif (violation = 'X' and x_on_violation = "on") then
            iregout := 'X';
      elsif clk_ipd'event and clk_ipd = '1' and clk_ipd'last_value = '0' then
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
      tmp_qfbko := iregout;

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => regout,
       OutSignalName => "REGOUT",
       OutTemp => tmp_regout,
       Paths => (0 => (aclr_ipd'last_event, tpd_aclr_regout_posedge, TRUE),
                 1 => (clk_ipd'last_event, tpd_clk_regout_posedge, TRUE)),
       GlitchData => regout_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => qfbko,
       OutSignalName => "QFBKO",
       OutTemp => tmp_qfbko,
       Paths => (0 => (aclr_ipd'last_event, tpd_aclr_qfbko_posedge, TRUE),
                 1 => (clk_ipd'last_event, tpd_clk_qfbko_posedge, TRUE)),
       GlitchData => qfbko_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

end process;

end vital_le_reg;	


LIBRARY IEEE, apex20ke;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use apex20ke.atom_pack.all;

ENTITY apex20ke_lcell is
  GENERIC (
    operation_mode : string := "normal";
    output_mode    : string := "comb_and_reg";
    packed_mode    : string := "false";
    lut_mask       : string := "ffff";
    power_up       : string := "low";
    cin_used       : string := "false";
    lpm_type       : string := "apex20ke_lcell";
    x_on_violation : string := "on"
  );

  PORT (clk     : in std_logic;
        dataa     : in std_logic := '1';
        datab     : in std_logic := '1';
        datac     : in std_logic := '1';
        datad     : in std_logic := '1';
        aclr    : in std_logic := '0';
        sclr : in std_logic := '0';
        sload : in std_logic := '0';
        ena : in std_logic := '1';
        cin   : in std_logic := '0';
        cascin     : in std_logic := '1';
        devclrn   : in std_logic := '1';
        devpor    : in std_logic := '1';
        combout   : out std_logic;
        regout    : out std_logic;
        cout  : out std_logic;
        cascout    : out std_logic);
end apex20ke_lcell;
        
ARCHITECTURE vital_le_atom of apex20ke_lcell is

signal dffin : std_logic;
signal qfbk  : std_logic;

COMPONENT apex20ke_asynch_lcell 
  GENERIC (operation_mode    : string := "normal";
      output_mode   : string := "comb_and_reg";
      lut_mask       : string := "ffff";
      power_up : string := "low";
      cin_used       : string := "false";
      TimingChecksOn: Boolean := True;
      MsgOn: Boolean := DefGlitchMsgOn;
      XOn: Boolean := DefGlitchXOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      InstancePath: STRING := "*";
      tpd_dataa_combout                 : VitalDelayType01 := DefPropDelay01;
      tpd_datab_combout                 : VitalDelayType01 := DefPropDelay01;
      tpd_datac_combout                 : VitalDelayType01 := DefPropDelay01;
      tpd_datad_combout                 : VitalDelayType01 := DefPropDelay01;
      tpd_qfbkin_combout                : VitalDelayType01 := DefPropDelay01;
      tpd_cin_combout                   : VitalDelayType01 := DefPropDelay01;
      tpd_cascin_combout	        : VitalDelayType01 := DefPropDelay01;
      tpd_dataa_regin                   : VitalDelayType01 := DefPropDelay01;
      tpd_datab_regin                   : VitalDelayType01 := DefPropDelay01;
      tpd_datac_regin                   : VitalDelayType01 := DefPropDelay01;
      tpd_datad_regin                   : VitalDelayType01 := DefPropDelay01;
      tpd_qfbkin_regin                  : VitalDelayType01 := DefPropDelay01;
      tpd_cin_regin                     : VitalDelayType01 := DefPropDelay01;
      tpd_cascin_regin  	        : VitalDelayType01 := DefPropDelay01;
      tpd_dataa_cout	                : VitalDelayType01 := DefPropDelay01;
      tpd_datab_cout	                : VitalDelayType01 := DefPropDelay01;
      tpd_datac_cout    	        : VitalDelayType01 := DefPropDelay01;
      tpd_datad_cout    	        : VitalDelayType01 := DefPropDelay01;
      tpd_qfbkin_cout                   : VitalDelayType01 := DefPropDelay01;
      tpd_cin_cout		        : VitalDelayType01 := DefPropDelay01;
      tpd_cascin_cascout	        : VitalDelayType01 := DefPropDelay01;
      tpd_cin_cascout    	        : VitalDelayType01 := DefPropDelay01;
      tpd_dataa_cascout	                : VitalDelayType01 := DefPropDelay01;
      tpd_datab_cascout	                : VitalDelayType01 := DefPropDelay01;
      tpd_datac_cascout    	        : VitalDelayType01 := DefPropDelay01;
      tpd_datad_cascout    	        : VitalDelayType01 := DefPropDelay01;
      tpd_qfbkin_cascout                : VitalDelayType01 := DefPropDelay01;
      tipd_dataa			: VitalDelayType01 := DefPropDelay01; 
      tipd_datab			: VitalDelayType01 := DefPropDelay01; 
      tipd_datac			: VitalDelayType01 := DefPropDelay01; 
      tipd_datad			: VitalDelayType01 := DefPropDelay01; 
      tipd_cin  			: VitalDelayType01 := DefPropDelay01; 
      tipd_cascin			: VitalDelayType01 := DefPropDelay01); 

  PORT (
        dataa     : in std_logic := '1';
        datab     : in std_logic := '1';
        datac     : in std_logic := '1';
        datad     : in std_logic := '1';
        cin       : in std_logic := '0';
        cascin    : in std_logic := '1';
        qfbkin    : in std_logic := '0';
        combout   : out std_logic;
        cout      : out std_logic;
        cascout   : out std_logic;
        regin     : out std_logic);
END COMPONENT;

COMPONENT apex20ke_lcell_register
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
      tpd_aclr_regout_posedge		: VitalDelayType01 := DefPropDelay01;
      tpd_clk_qfbko_posedge		: VitalDelayType01 := DefPropDelay01;
      tpd_aclr_qfbko_posedge		: VitalDelayType01 := DefPropDelay01;
      tperiod_clk_posedge               : VitalDelayType := DefPulseWdthCnst;
      tipd_datac  			: VitalDelayType01 := DefPropDelay01; 
      tipd_ena  			: VitalDelayType01 := DefPropDelay01; 
      tipd_aclr 			: VitalDelayType01 := DefPropDelay01; 
      tipd_sclr 			: VitalDelayType01 := DefPropDelay01; 
      tipd_sload 			: VitalDelayType01 := DefPropDelay01; 
      tipd_clk  			: VitalDelayType01 := DefPropDelay01);

  PORT (clk     : in std_logic;
        datain     : in std_logic := '1';
        datac     : in std_logic := '1';
        aclr    : in std_logic := '0';
        sclr : in std_logic := '0';
        sload : in std_logic := '0';
        ena : in std_logic := '1';
        devclrn   : in std_logic := '1';
        devpor    : in std_logic := '1';
        regout    : out std_logic;
        qfbko     : out std_logic);
END COMPONENT;

begin

lecomb: apex20ke_asynch_lcell
        generic map (operation_mode => operation_mode, output_mode => output_mode,
                     lut_mask => lut_mask, cin_used => cin_used)
        port map (dataa => dataa, datab => datab, datac => datac, datad => datad,
                  cin => cin, cascin => cascin, qfbkin => qfbk,
                  combout => combout, cout => cout, cascout => cascout, regin => dffin);

lereg: apex20ke_lcell_register
	generic map (power_up => power_up, packed_mode => packed_mode,
                     x_on_violation => x_on_violation)
  	port map (clk => clk, datain => dffin, datac => datac, 
                  aclr => aclr, sclr => sclr, sload => sload, ena => ena,
                  devclrn => devclrn, devpor => devpor, regout => regout,
                  qfbko => qfbk);


end vital_le_atom;

--
--
--  APEX20KE_IO Model
--
--
LIBRARY IEEE, apex20ke;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use apex20ke.atom_pack.all;

ENTITY apex20ke_asynch_io is
   GENERIC (operation_mode : string := "input";
      reg_source_mode :  string := "none";
      feedback_mode : string := "from_pin";
      open_drain_output : string := "false";
      TimingChecksOn: Boolean := True;
      MsgOn: Boolean := DefGlitchMsgOn;
      XOn: Boolean := DefGlitchXOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      InstancePath: STRING := "*";
      tpd_datain_padio			 : VitalDelayType01 := DefPropDelay01;
      tpd_padio_combout                  : VitalDelayType01 := DefPropDelay01;
      tpd_oe_padio_posedge               : VitalDelayType01 := DefPropDelay01;
      tpd_oe_padio_negedge               : VitalDelayType01 := DefPropDelay01;
      tpd_dffeQ_padio			 : VitalDelayType01 := DefPropDelay01;
      tpd_dffeQ_regout			 : VitalDelayType01 := DefPropDelay01;
      tipd_datain                        : VitalDelayType01 := DefPropDelay01;
      tipd_oe                            : VitalDelayType01 := DefPropDelay01;
      tipd_padio                         : VitalDelayType01 := DefPropDelay01);

    PORT (datain : in std_logic;
          dffeQ : in std_logic;
          oe   : in std_logic;
          padio  : inout std_logic;
          dffeD : out std_logic;
          combout : out std_logic; 
          regout  : out std_logic);

    attribute VITAL_LEVEL0 of apex20ke_asynch_io : ENTITY is TRUE;
end apex20ke_asynch_io;

ARCHITECTURE vital_asynch_io of apex20ke_asynch_io is
   attribute VITAL_LEVEL0 of vital_asynch_io : ARCHITECTURE is TRUE;

   signal oe_ipd : std_logic;
   signal datain_ipd, padio_ipd : std_logic;

begin
   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
      VitalWireDelay (datain_ipd, datain, tipd_datain);
      VitalWireDelay (padio_ipd, padio, tipd_padio);
      VitalWireDelay (oe_ipd, oe, tipd_oe);
   end block;

VITALtiming : process(datain_ipd, oe_ipd, padio_ipd, dffeQ)
variable Tviol_datain_clk : std_ulogic := '0';
variable Tviol_padio_clk : std_ulogic := '0';
variable Tviol_ena_clk : std_ulogic := '0';
variable TimingData_datain_clk : VitalTimingDataType := VitalTimingDataInit;
variable TimingData_padio_clk : VitalTimingDataType := VitalTimingDataInit;
variable TimingData_ena_clk : VitalTimingDataType := VitalTimingDataInit;
variable regout_VitalGlitchData : VitalGlitchDataType;
variable combout_VitalGlitchData : VitalGlitchDataType;
variable padio_VitalGlitchData : VitalGlitchDataType;
variable dffeD_VitalGlitchData : VitalGlitchDataType;

variable tri_in : std_logic := '0';
variable reg_indata, tmp_combout, tmp_padio, oe_val, temp : std_logic;
begin

	if ((reg_source_mode = "none") and
                     (feedback_mode = "none")) then
		if ((operation_mode = "output") or
		          (operation_mode = "bidir")) then
		     tri_in := datain_ipd;
		end if;
	elsif ((reg_source_mode = "none") and
                     (feedback_mode = "from_pin")) then
		if (operation_mode = "input") then
			tmp_combout := to_x01z(padio_ipd);
		elsif (operation_mode = "bidir") then
			tmp_combout := to_x01z(padio_ipd);
		        tri_in := datain_ipd;
		end if;
	elsif ((reg_source_mode = "data_in") and
			(feedback_mode = "from_reg")) then
		if ((operation_mode = "output") or
		          (operation_mode = "bidir")) then
		     tri_in := datain_ipd;
		     reg_indata := datain_ipd;
                end if;
	elsif ((reg_source_mode = "data_in") and
			(feedback_mode = "from_pin_and_reg")) then
		if (operation_mode = "input") then
			tmp_combout := to_x01z(padio_ipd);
			reg_indata := datain_ipd;
		elsif (operation_mode = "bidir")  then
			tmp_combout := to_x01z(padio_ipd);
			tri_in := datain_ipd;
			reg_indata := datain_ipd;
		end  if;
	elsif ((reg_source_mode = "pin_only") and
			(feedback_mode = "from_pin_and_reg"))  then
		if (operation_mode = "input") then
			tmp_combout := to_x01z(padio_ipd);
			reg_indata := to_x01z(padio_ipd);
		elsif (operation_mode = "bidir") then
			tri_in := datain_ipd;
			tmp_combout := to_x01z(padio_ipd);
			reg_indata := to_x01z(padio_ipd);
		end if;
	elsif ((reg_source_mode = "pin_only") and
			(feedback_mode = "from_reg"))   then
		if (operation_mode = "input") then
			reg_indata := to_x01z(padio_ipd);
		elsif (operation_mode = "bidir")  then
			tri_in := datain_ipd;
			reg_indata := to_x01z(padio_ipd);
		end if;
	elsif ((reg_source_mode = "data_in_to_pin") and
			(feedback_mode = "from_pin")) then
		if (operation_mode = "bidir") then
			tri_in := dffeQ;
			reg_indata := datain_ipd;
			tmp_combout := to_x01z(padio_ipd);
		end if;
	elsif ((reg_source_mode = "data_in_to_pin") and
			(feedback_mode = "from_reg"))     then
		if ((operation_mode = "output") or
		          (operation_mode = "bidir")) then
			reg_indata := datain_ipd;
			tri_in := dffeQ;
		end  if;
	elsif ((reg_source_mode = "data_in_to_pin") and
			(feedback_mode = "none"))       then
		if ((operation_mode = "output") or
		          (operation_mode = "bidir")) then
			tri_in := dffeQ;
			reg_indata := datain_ipd;
		end   if;
	elsif ((reg_source_mode = "data_in_to_pin") and
			(feedback_mode = "from_pin_and_reg"))       then
		if (operation_mode = "bidir") then
			reg_indata := datain_ipd;
			tri_in := dffeQ;
			tmp_combout := to_x01z(padio_ipd);
		end if;
	elsif ((reg_source_mode = "pin_loop") and
			(feedback_mode = "from_pin")) then
		if (operation_mode = "bidir") then
			tri_in := dffeQ;
			reg_indata := to_x01z(padio_ipd);
			tmp_combout := to_x01z(padio_ipd);
		end if;
	elsif ((reg_source_mode = "pin_loop") and
			(feedback_mode = "from_pin_and_reg")) then
		if (operation_mode = "bidir") then
			reg_indata := to_x01z(padio_ipd);
			tri_in := dffeQ;
			tmp_combout := to_x01z(padio_ipd);
		end if;
	elsif ((reg_source_mode = "pin_loop") and
			(feedback_mode = "from_reg")) then
		if (operation_mode = "bidir") then
			reg_indata := to_x01z(padio_ipd);
			tri_in := dffeQ;
		end if;
	end if;
	if (operation_mode = "output") then
	   oe_val := to_x01z(oe_ipd);
	   if (oe_val = '0') then
	       temp := 'Z';
	   else
	       temp := tri_in;
	   end if;
	   if (open_drain_output = "false") then
	      tmp_padio := temp;
	   elsif (open_drain_output = "true") then
	      if (temp = '0') then
	         tmp_padio := '0';
	      else
		 tmp_padio := 'Z';
	      end if;
	   end if;
	elsif ((operation_mode = "bidir") and (oe_ipd = '1')) then
	   if (open_drain_output = "false") then
	      tmp_padio := tri_in;
	   elsif (open_drain_output = "true") then
	      if (tri_in = '0') then
		 tmp_padio := '0';
	      else
		 tmp_padio := 'Z';
	      end if;
	   end if;
	else
	   tmp_padio := 'Z';
	end if;

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => regout,
       OutSignalName => "REGOUT",
       OutTemp => dffeQ,
       Paths => (0 => (dffeQ'last_event,
                       tpd_dffeQ_regout,
                       TRUE)),
       GlitchData => regout_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );
 
      VitalPathDelay01 (
       OutSignal => combout,
       OutSignalName => "COMBOUT",
       OutTemp => tmp_combout,
       Paths => (0 => (padio_ipd'last_event,
                       tpd_padio_combout,
                       TRUE)),
       GlitchData => combout_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn => MsgOn );

      VitalPathDelay01 ( 
       OutSignal => padio, 
       OutSignalName => "PADIO", 
       OutTemp => tmp_padio,   
       Paths => (0 => (dffeQ'last_event,
                       tpd_dffeQ_padio,
                       TRUE),
                 1 => (oe_ipd'last_event,
                       tpd_oe_padio_posedge,
                       oe_ipd = '1'), 
                 2 => (oe_ipd'last_event,
                       tpd_oe_padio_negedge,
                       oe_ipd = '0'), 
                 3 => (datain_ipd'last_event,
                       tpd_datain_padio,
                       (reg_source_mode = "none" or reg_source_mode = "data_in"
                        or reg_source_mode = "pin_only"))),
       GlitchData => padio_VitalGlitchData,  
       Mode => DefGlitchMode, 
       XOn  => XOn,   
       MsgOn => MsgOn );

      VitalPathDelay01 ( 
       OutSignal => dffeD, 
       OutSignalName => "DFFED", 
       OutTemp => reg_indata,   
       Paths => (0 => (datain_ipd'last_event, (0 ns, 0 ns),
                       reg_source_mode = "data_in" or
                       reg_source_mode = "data_in_to_pin"),
                 1 => (padio_ipd'last_event, (0 ns, 0 ns),
                       reg_source_mode = "pin_only" or
                       reg_source_mode = "pin_loop")),
       GlitchData => dffeD_VitalGlitchData,  
       Mode => DefGlitchMode, 
       XOn  => XOn,   
       MsgOn => MsgOn );

end process;

end vital_asynch_io;

LIBRARY IEEE, apex20ke;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use apex20ke.atom_pack.all;

ENTITY  apex20ke_io is
   GENERIC (operation_mode : string := "input";
      reg_source_mode :  string := "none";
      feedback_mode : string := "from_pin";
      power_up : string := "low";
      open_drain_output : string := "false");

    PORT (clk    : in std_logic;
          datain : in std_logic;
          aclr   : in std_logic;
          preset : in std_logic;
          ena    : in std_logic;
          oe     : in std_logic;
          devclrn   : in std_logic := '1';
          devpor : in std_logic := '1';
          devoe  : in std_logic := '0';
          padio  : inout std_logic;
          combout : out std_logic;
          regout  : out std_logic);

end apex20ke_io;

ARCHITECTURE arch of apex20ke_io is

   signal reg_clr, reg_pre : std_logic := '1';
   signal ioreg_clr, ioreg_pre : std_logic := '1';
   signal vcc : std_logic := '1';
   signal dffeD : std_logic;
   signal comb_out, reg_out : std_logic;
   signal dffe_Q : std_logic;

COMPONENT DFFE_IO
   GENERIC (
      TimingChecksOn: Boolean := true;
      XGenerationOn: Boolean := false;
      InstancePath: STRING := "*";
      XOn: Boolean := DefGlitchXOn;
      MsgOn: Boolean := DefGlitchMsgOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      tpd_PRN_Q_negedge                :        VitalDelayType01 := DefPropDelay01;
      tpd_CLRN_Q_negedge             :  VitalDelayType01 := DefPropDelay01;
      tpd_CLK_Q_posedge              :  VitalDelayType01 := DefPropDelay01;
      tpd_ENA_Q_posedge              :  VitalDelayType01 := DefPropDelay01;
      tsetup_D_CLK_noedge_posedge    :  VitalDelayType := DefSetupHoldCnst;
      tsetup_D_CLK_noedge_negedge    :  VitalDelayType := DefSetupHoldCnst;
      tsetup_ENA_CLK_noedge_posedge    :  VitalDelayType := DefSetupHoldCnst;
      thold_D_CLK_noedge_posedge    :   VitalDelayType := DefSetupHoldCnst;
      thold_D_CLK_noedge_negedge    :   VitalDelayType := DefSetupHoldCnst;
      thold_ENA_CLK_noedge_posedge    :   VitalDelayType := DefSetupHoldCnst;
      tipd_D                         :  VitalDelayType01 := DefPropDelay01;
      tipd_CLRN                      :  VitalDelayType01 := DefPropDelay01;
      tipd_PRN                       :  VitalDelayType01 := DefPropDelay01;
      tipd_CLK                       :  VitalDelayType01 := DefPropDelay01;
      tipd_ENA                       :  VitalDelayType01 := DefPropDelay01);

   PORT (
      Q                              :  out   STD_LOGIC := '0';
      D                              :  in    STD_LOGIC := '1';
      CLRN                           :  in    STD_LOGIC := '1';
      PRN                            :  in    STD_LOGIC := '1';
      CLK                            :  in    STD_LOGIC := '0';
      ENA                            :  in    STD_LOGIC := '1');
END COMPONENT;

COMPONENT apex20ke_asynch_io
   GENERIC (operation_mode : string := "input";
      reg_source_mode :  string := "none";
      feedback_mode : string := "from_pin";
      open_drain_output : string := "false";
      TimingChecksOn: Boolean := True;
      MsgOn: Boolean := DefGlitchMsgOn;
      XOn: Boolean := DefGlitchXOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      InstancePath: STRING := "*";
      tpd_datain_padio			 : VitalDelayType01 := DefPropDelay01;
      tpd_padio_combout                  : VitalDelayType01 := DefPropDelay01;
      tpd_oe_padio_posedge               : VitalDelayType01 := DefPropDelay01;
      tpd_oe_padio_negedge               : VitalDelayType01 := DefPropDelay01;
      tpd_dffeQ_padio			 : VitalDelayType01 := DefPropDelay01;
      tpd_dffeQ_regout			 : VitalDelayType01 := DefPropDelay01;
      tipd_datain                        : VitalDelayType01 := DefPropDelay01;
      tipd_oe                            : VitalDelayType01 := DefPropDelay01;
      tipd_padio                         : VitalDelayType01 := DefPropDelay01);

    PORT (datain : in std_logic;
          dffeQ : in std_logic;
          oe   : in std_logic;
          padio  : inout std_logic;
          dffeD : out std_logic;
          combout : out std_logic;
          regout  : out std_logic);
END COMPONENT;

begin

reg_clr <= devpor when power_up = "low" else vcc;
reg_pre <= devpor when power_up = "high" else vcc;

ioreg_clr <= devclrn and (not aclr) and reg_clr;
ioreg_pre <= (not preset) and reg_pre;

asynch_inst: apex20ke_asynch_io
     generic map (operation_mode => operation_mode,
                  reg_source_mode => reg_source_mode,
                  feedback_mode => feedback_mode,
                  open_drain_output => open_drain_output)

     port map (datain => datain, oe => oe, padio => padio,
                           dffeD => dffeD, dffeQ => dffe_Q, combout => comb_out,
                           regout => reg_out);

io_reg: dffe_io
      port map (D => dffeD, clk => clk, ena => ena, Q => dffe_Q,
              CLRN => ioreg_clr, PRN => ioreg_pre);

combout <= comb_out;
regout <= reg_out;

end arch;

--
--  APEX20KE PTERM Model
-- 
--
LIBRARY IEEE, apex20ke;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use apex20ke.atom_pack.all;

ENTITY apex20ke_asynch_pterm is
  GENERIC (operation_mode     : string := "normal";
      invert_pterm1_mode : string := "false";
      TimingChecksOn: Boolean := True;
      MsgOn: Boolean := DefGlitchMsgOn;
      XOn: Boolean := DefGlitchXOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      InstancePath: STRING := "*";
      tpd_pterm0_combout            :  VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
      tpd_pterm1_combout            :  VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
      tpd_pexpin_combout            :  VitalDelayType01 := DefPropDelay01;
      tpd_fbkin_combout            :  VitalDelayType01 := DefPropDelay01;
      tpd_pterm0_regin            :  VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
      tpd_pterm1_regin            :  VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
      tpd_pexpin_regin            :  VitalDelayType01 := DefPropDelay01;
      tpd_fbkin_regin            :  VitalDelayType01 := DefPropDelay01;
      tpd_pterm0_pexpout            :  VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
      tpd_pterm1_pexpout            :  VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
      tpd_pexpin_pexpout            :  VitalDelayType01 := DefPropDelay01;
      tpd_fbkin_pexpout            :  VitalDelayType01 := DefPropDelay01;
      tipd_pterm0                       :  VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
      tipd_pterm1                       :  VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
      tipd_pexpin                       :  VitalDelayType01 := DefPropDelay01);


  PORT (pterm0	: in std_logic_vector(31 downto 0) := "11111111111111111111111111111111";
        pterm1  : in std_logic_vector(31 downto 0) := "11111111111111111111111111111111";
        pexpin	: in std_logic := '0';
        fbkin : in std_logic;
		combout : out std_logic;
		regin : out std_logic;
        pexpout : out std_logic );
   attribute VITAL_LEVEL0 of apex20ke_asynch_pterm : ENTITY is TRUE;
end apex20ke_asynch_pterm; 

ARCHITECTURE vital_pterm of apex20ke_asynch_pterm is
   attribute VITAL_LEVEL0 of vital_pterm : ARCHITECTURE is TRUE;

signal pterm0_ipd	:std_logic_vector(31 downto 0) := (OTHERS => 'U');
signal pterm1_ipd	:std_logic_vector(31 downto 0) := (OTHERS => 'U');
signal pexpin_ipd	:std_ulogic := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (pterm0_ipd(0), pterm0(0), tipd_pterm0(0));
   VitalWireDelay (pterm0_ipd(1), pterm0(1), tipd_pterm0(1));
   VitalWireDelay (pterm0_ipd(2), pterm0(2), tipd_pterm0(2));
   VitalWireDelay (pterm0_ipd(3), pterm0(3), tipd_pterm0(3));
   VitalWireDelay (pterm0_ipd(4), pterm0(4), tipd_pterm0(4));
   VitalWireDelay (pterm0_ipd(5), pterm0(5), tipd_pterm0(5));
   VitalWireDelay (pterm0_ipd(6), pterm0(6), tipd_pterm0(6));
   VitalWireDelay (pterm0_ipd(7), pterm0(7), tipd_pterm0(7));
   VitalWireDelay (pterm0_ipd(8), pterm0(8), tipd_pterm0(8));
   VitalWireDelay (pterm0_ipd(9), pterm0(9), tipd_pterm0(9));
   VitalWireDelay (pterm0_ipd(10), pterm0(10), tipd_pterm0(10));
   VitalWireDelay (pterm0_ipd(11), pterm0(11), tipd_pterm0(11));
   VitalWireDelay (pterm0_ipd(12), pterm0(12), tipd_pterm0(12));
   VitalWireDelay (pterm0_ipd(13), pterm0(13), tipd_pterm0(13));
   VitalWireDelay (pterm0_ipd(14), pterm0(14), tipd_pterm0(14));
   VitalWireDelay (pterm0_ipd(15), pterm0(15), tipd_pterm0(15));
   VitalWireDelay (pterm0_ipd(16), pterm0(16), tipd_pterm0(16));
   VitalWireDelay (pterm0_ipd(17), pterm0(17), tipd_pterm0(17));
   VitalWireDelay (pterm0_ipd(18), pterm0(18), tipd_pterm0(18));
   VitalWireDelay (pterm0_ipd(19), pterm0(19), tipd_pterm0(19));
   VitalWireDelay (pterm0_ipd(20), pterm0(20), tipd_pterm0(20));
   VitalWireDelay (pterm0_ipd(21), pterm0(21), tipd_pterm0(21));
   VitalWireDelay (pterm0_ipd(22), pterm0(22), tipd_pterm0(22));
   VitalWireDelay (pterm0_ipd(23), pterm0(23), tipd_pterm0(23));
   VitalWireDelay (pterm0_ipd(24), pterm0(24), tipd_pterm0(24));
   VitalWireDelay (pterm0_ipd(25), pterm0(25), tipd_pterm0(25));
   VitalWireDelay (pterm0_ipd(26), pterm0(26), tipd_pterm0(26));
   VitalWireDelay (pterm0_ipd(27), pterm0(27), tipd_pterm0(27));
   VitalWireDelay (pterm0_ipd(28), pterm0(28), tipd_pterm0(28));
   VitalWireDelay (pterm0_ipd(29), pterm0(29), tipd_pterm0(29));
   VitalWireDelay (pterm0_ipd(30), pterm0(30), tipd_pterm0(30));
   VitalWireDelay (pterm0_ipd(31), pterm0(31), tipd_pterm0(31));
   VitalWireDelay (pterm1_ipd(0), pterm1(0), tipd_pterm1(0));
   VitalWireDelay (pterm1_ipd(1), pterm1(1), tipd_pterm1(1));
   VitalWireDelay (pterm1_ipd(2), pterm1(2), tipd_pterm1(2));
   VitalWireDelay (pterm1_ipd(3), pterm1(3), tipd_pterm1(3));
   VitalWireDelay (pterm1_ipd(4), pterm1(4), tipd_pterm1(4));
   VitalWireDelay (pterm1_ipd(5), pterm1(5), tipd_pterm1(5));
   VitalWireDelay (pterm1_ipd(6), pterm1(6), tipd_pterm1(6));
   VitalWireDelay (pterm1_ipd(7), pterm1(7), tipd_pterm1(7));
   VitalWireDelay (pterm1_ipd(8), pterm1(8), tipd_pterm1(8));
   VitalWireDelay (pterm1_ipd(9), pterm1(9), tipd_pterm1(9));
   VitalWireDelay (pterm1_ipd(10), pterm1(10), tipd_pterm1(10));
   VitalWireDelay (pterm1_ipd(11), pterm1(11), tipd_pterm1(11));
   VitalWireDelay (pterm1_ipd(12), pterm1(12), tipd_pterm1(12));
   VitalWireDelay (pterm1_ipd(13), pterm1(13), tipd_pterm1(13));
   VitalWireDelay (pterm1_ipd(14), pterm1(14), tipd_pterm1(14));
   VitalWireDelay (pterm1_ipd(15), pterm1(15), tipd_pterm1(15));
   VitalWireDelay (pterm1_ipd(16), pterm1(16), tipd_pterm1(16));
   VitalWireDelay (pterm1_ipd(17), pterm1(17), tipd_pterm1(17));
   VitalWireDelay (pterm1_ipd(18), pterm1(18), tipd_pterm1(18));
   VitalWireDelay (pterm1_ipd(19), pterm1(19), tipd_pterm1(19));
   VitalWireDelay (pterm1_ipd(20), pterm1(20), tipd_pterm1(20));
   VitalWireDelay (pterm1_ipd(21), pterm1(21), tipd_pterm1(21));
   VitalWireDelay (pterm1_ipd(22), pterm1(22), tipd_pterm1(22));
   VitalWireDelay (pterm1_ipd(23), pterm1(23), tipd_pterm1(23));
   VitalWireDelay (pterm1_ipd(24), pterm1(24), tipd_pterm1(24));
   VitalWireDelay (pterm1_ipd(25), pterm1(25), tipd_pterm1(25));
   VitalWireDelay (pterm1_ipd(26), pterm1(26), tipd_pterm1(26));
   VitalWireDelay (pterm1_ipd(27), pterm1(27), tipd_pterm1(27));
   VitalWireDelay (pterm1_ipd(28), pterm1(28), tipd_pterm1(28));
   VitalWireDelay (pterm1_ipd(29), pterm1(29), tipd_pterm1(29));
   VitalWireDelay (pterm1_ipd(30), pterm1(30), tipd_pterm1(30));
   VitalWireDelay (pterm1_ipd(31), pterm1(31), tipd_pterm1(31));
   VitalWireDelay (pexpin_ipd, pexpin, tipd_pexpin);
   end block;

VITALtiming : process(pterm0_ipd, pterm1_ipd, pexpin_ipd, fbkin)


variable combout_VitalGlitchData : VitalGlitchDataType;
variable regin_VitalGlitchData : VitalGlitchDataType;
variable pexpout_VitalGlitchData : VitalGlitchDataType;

variable tmp_comb, tmp_pexpout : std_logic;
variable ipterm1 : std_logic := '1';

begin
  if (invert_pterm1_mode = "false") then
    ipterm1 := product(pterm1_ipd);
  else
    ipterm1 := not product(pterm1_ipd);
  end if;
  
  if (operation_mode = "normal") then
    tmp_comb := (product(pterm0_ipd) or ipterm1) or pexpin_ipd;
  elsif (operation_mode = "invert") then
    tmp_comb := (product(pterm0_ipd) or ipterm1 or pexpin_ipd) xor '1';
  elsif (operation_mode = "xor") then
    tmp_comb := (ipterm1 or pexpin_ipd) xor product(pterm0_ipd);
  elsif (operation_mode = "packed_pterm_exp") then
    tmp_comb := product(pterm0_ipd);
    tmp_pexpout := ipterm1 or pexpin_ipd;
  elsif (operation_mode = "pterm_exp") then
    tmp_pexpout := product(pterm0_ipd) or ipterm1 or pexpin_ipd;
  elsif (operation_mode = "tff") then
    tmp_comb := (product(pterm0_ipd) or ipterm1 or pexpin_ipd) xor fbkin;
  elsif (operation_mode = "tbarff") then
    tmp_comb := (product(pterm0_ipd) or ipterm1 or pexpin_ipd) xor  (not fbkin);
  elsif (operation_mode = "packed_tff") then
    tmp_pexpout := product(pterm0_ipd) or ipterm1 or pexpin_ipd;
    tmp_comb := fbkin xor '1'; -- feed this to regin. not combout
  else
    tmp_comb := 'Z';
    tmp_pexpout := 'Z';
  end if;
  
      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => combout,
       OutSignalName => "COMBOUT",
       OutTemp => tmp_comb,
       Paths => (1 => (pterm0_ipd'last_event, tpd_pterm0_combout(0), TRUE),
                 2 => (pterm1_ipd'last_event, tpd_pterm1_combout(0), TRUE),
                 3 => (pexpin_ipd'last_event, tpd_pexpin_combout, TRUE),
                 4 => (fbkin'last_event, tpd_fbkin_combout, TRUE)),
       GlitchData => combout_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 ( 
       OutSignal => pexpout, 
       OutSignalName => "PEXPOUT", 
       OutTemp => tmp_pexpout,  
       Paths => (1 => (pterm0_ipd'last_event, tpd_pterm0_pexpout(0), TRUE),
                 2 => (pterm1_ipd'last_event, tpd_pterm1_pexpout(0), TRUE),
                 3 => (pexpin_ipd'last_event, tpd_pexpin_pexpout, TRUE),
                 4 => (fbkin'last_event, tpd_fbkin_pexpout, TRUE)),
       GlitchData => pexpout_VitalGlitchData, 
       Mode => DefGlitchMode, 
       XOn  => XOn, 
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => regin,
       OutSignalName => "REGIN",
       OutTemp => tmp_comb,
       Paths => (1 => (pterm0_ipd'last_event, tpd_pterm0_regin(0), TRUE),
                 2 => (pterm1_ipd'last_event, tpd_pterm1_regin(0), TRUE),
                 3 => (pexpin_ipd'last_event, tpd_pexpin_regin, TRUE),
                 4 => (fbkin'last_event, tpd_fbkin_regin, TRUE)),
       GlitchData => regin_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );
       

end process;

end vital_pterm;

LIBRARY IEEE, apex20ke;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use apex20ke.atom_pack.all;

ENTITY apex20ke_pterm_register is
  GENERIC (
      power_up : string := "low";
      TimingChecksOn: Boolean := True;
      MsgOn: Boolean := DefGlitchMsgOn;
      XOn: Boolean := DefGlitchXOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      InstancePath: STRING := "*";
      tpd_aclr_regout_posedge      :  VitalDelayType01 := DefPropDelay01;
      tpd_clk_regout_posedge       :  VitalDelayType01 := DefPropDelay01;
      tpd_aclr_fbkout_posedge      :  VitalDelayType01 := DefPropDelay01;
      tpd_clk_fbkout_posedge       :  VitalDelayType01 := DefPropDelay01;
	  tsetup_datain_clk_noedge_posedge  :  VitalDelayType := DefSetupHoldCnst;
      tsetup_ena_clk_noedge_posedge     :  VitalDelayType := DefSetupHoldCnst;
      thold_datain_clk_noedge_posedge   :  VitalDelayType := DefSetupHoldCnst;
      thold_ena_clk_noedge_posedge      :  VitalDelayType := DefSetupHoldCnst;
      tipd_aclr                         :  VitalDelayType01 := DefPropDelay01;
      tipd_ena                          :  VitalDelayType01 := DefPropDelay01;
      tipd_clk                          :  VitalDelayType01 := DefPropDelay01);

  PORT (
        datain	: in std_logic;
        clk	: in std_logic;
        ena 	: in std_logic := '1';
	aclr	: in std_logic := '0';
        devclrn   : in std_logic := '1';
        devpor : in std_logic := '1';
	regout : out std_logic;
        fbkout : out std_logic);
   attribute VITAL_LEVEL0 of apex20ke_pterm_register : ENTITY is TRUE;
end apex20ke_pterm_register; 

ARCHITECTURE vital_pterm_reg of apex20ke_pterm_register is
   attribute VITAL_LEVEL0 of vital_pterm_reg : ARCHITECTURE is TRUE;

signal clk_ipd  	:std_ulogic := 'U';
signal aclr_ipd	        :std_ulogic := 'U';
signal ena_ipd	        :std_ulogic := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (clk_ipd, clk, tipd_clk);
   VitalWireDelay (aclr_ipd, aclr, tipd_aclr);
   VitalWireDelay (ena_ipd, ena, tipd_ena);
   end block;

VITALtiming : process(datain, clk_ipd, aclr_ipd, ena_ipd, devclrn, devpor)
variable Tviol_datain_clk : std_ulogic := '0';
variable Tviol_ena_clk : std_ulogic := '0';
variable Tviol_clk : std_ulogic := '0';

variable TimingData_datain_clk : VitalTimingDataType := VitalTimingDataInit;
variable TimingData_ena_clk : VitalTimingDataType := VitalTimingDataInit;

variable regout_VitalGlitchData : VitalGlitchDataType;
variable fbkout_VitalGlitchData : VitalGlitchDataType;

variable tmp_regout : std_logic;

-- variables for 'X' generation
variable violation : std_logic := '0';

begin

      if (now = 0 ns) then
         if (power_up = "low") then
            tmp_regout := '0';
         elsif (power_up = "high") then
            tmp_regout := '1';
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
                CheckEnabled    => TO_X01(aclr_ipd) /= '1',
                RefTransition   => '/', 
                HeaderMsg       => InstancePath & "/PTERM", 
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
                CheckEnabled    => TO_X01(aclr_ipd) /= '1',
                RefTransition   => '/', 
                HeaderMsg       => InstancePath & "/PTERM", 
                XOn             => XOnChecks, 
                MsgOn           => MsgOnChecks ); 
      end if;

      violation := Tviol_datain_clk or Tviol_ena_clk;

      if (devpor = '0') then
         if (power_up = "low") then
            tmp_regout := '0';
         elsif (power_up = "high") then
            tmp_regout := '1';
         end if;
      elsif (aclr_ipd =  '1') then
         tmp_regout := '0';
      elsif (violation = 'X') then
         tmp_regout := 'X';
      elsif ((clk_ipd'event and clk_ipd = '1') and (ena_ipd = '1')) then
	 tmp_regout := datain;
      end if;

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => regout,
       OutSignalName => "REGOUT",
       OutTemp => tmp_regout,
       Paths => (0 => (aclr_ipd'last_event, tpd_aclr_regout_posedge, TRUE),
                 1 => (clk_ipd'last_event, tpd_clk_regout_posedge, TRUE)),
       GlitchData => regout_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 ( 
       OutSignal => fbkout, 
       OutSignalName => "FBKOUT", 
       OutTemp => tmp_regout,  
       Paths => (0 => (aclr_ipd'last_event, tpd_aclr_regout_posedge, TRUE),
                 1 => (clk_ipd'last_event, tpd_clk_regout_posedge, TRUE)),
       GlitchData => fbkout_VitalGlitchData, 
       Mode => DefGlitchMode, 
       XOn  => XOn, 
       MsgOn        => MsgOn );


end process;

end vital_pterm_reg;

LIBRARY IEEE, apex20ke;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use apex20ke.atom_pack.all;

ENTITY apex20ke_pterm is
  GENERIC (
      operation_mode     : string := "normal";
      output_mode        : string := "comb";
      invert_pterm1_mode : string := "false";
      power_up : string := "low" );

  PORT (pterm0	: in std_logic_vector(31 downto 0) := "11111111111111111111111111111111";
        pterm1  : in std_logic_vector(31 downto 0) := "11111111111111111111111111111111";
        pexpin	: in std_logic := '0';
        clk	: in std_logic := '0';
        ena 	: in std_logic := '1';
		aclr	: in std_logic := '0';
        devclrn   : in std_logic := '1';
        devpor : in std_logic := '1';
        dataout : out std_logic;
        pexpout : out std_logic );
   attribute VITAL_LEVEL0 of apex20ke_pterm : ENTITY is TRUE;
end apex20ke_pterm; 

ARCHITECTURE vital_pterm_atom of apex20ke_pterm is
   attribute VITAL_LEVEL0 of vital_pterm_atom : ARCHITECTURE is TRUE;

COMPONENT apex20ke_asynch_pterm
  GENERIC (operation_mode     : string := "normal";
      invert_pterm1_mode : string := "false";
      TimingChecksOn: Boolean := True;
      MsgOn: Boolean := DefGlitchMsgOn;
      XOn: Boolean := DefGlitchXOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      InstancePath: STRING := "*";
      tpd_pterm0_combout            :  VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
      tpd_pterm1_combout            :  VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
      tpd_pexpin_combout            :  VitalDelayType01 := DefPropDelay01;
      tpd_fbkin_combout            :  VitalDelayType01 := DefPropDelay01;
      tpd_pterm0_pexpout            :  VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
      tpd_pterm1_pexpout            :  VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
      tpd_pexpin_pexpout            :  VitalDelayType01 := DefPropDelay01;
      tpd_fbkin_pexpout            :  VitalDelayType01 := DefPropDelay01;
      tipd_pterm0                       :  VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
      tipd_pterm1                       :  VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
      tipd_pexpin                       :  VitalDelayType01 := DefPropDelay01);


  PORT (pterm0	: in std_logic_vector(31 downto 0) := "11111111111111111111111111111111";
        pterm1  : in std_logic_vector(31 downto 0) := "11111111111111111111111111111111";
        pexpin	: in std_logic := '0';
        fbkin : in std_logic;
		combout : out std_logic;
        regin : out std_logic;
        pexpout : out std_logic );
END COMPONENT; 

COMPONENT apex20ke_pterm_register
  GENERIC (
      power_up : string := "low";
      TimingChecksOn: Boolean := True;
      MsgOn: Boolean := DefGlitchMsgOn;
      XOn: Boolean := DefGlitchXOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      InstancePath: STRING := "*";
      tpd_aclr_regout_posedge      :  VitalDelayType01 := DefPropDelay01;
      tpd_clk_regout_posedge       :  VitalDelayType01 := DefPropDelay01;
      tpd_aclr_fbkout_posedge      :  VitalDelayType01 := DefPropDelay01;
      tpd_clk_fbkout_posedge       :  VitalDelayType01 := DefPropDelay01;
      tsetup_datain_clk_noedge_posedge  :  VitalDelayType := DefSetupHoldCnst;
      tsetup_ena_clk_noedge_posedge     :  VitalDelayType := DefSetupHoldCnst;
      thold_datain_clk_noedge_posedge   :  VitalDelayType := DefSetupHoldCnst;
      thold_ena_clk_noedge_posedge      :  VitalDelayType := DefSetupHoldCnst;
      tipd_aclr                         :  VitalDelayType01 := DefPropDelay01;
      tipd_ena                          :  VitalDelayType01 := DefPropDelay01;
      tipd_clk                          :  VitalDelayType01 := DefPropDelay01);


  PORT (
        datain	: in std_logic;
        clk	: in std_logic;
        ena 	: in std_logic;
	aclr	: in std_logic;
        devclrn   : in std_logic := '1';
        devpor : in std_logic := '1';
	regout : out std_logic;
        fbkout : out std_logic);
END COMPONENT; 

signal fbk, dffin, combo, dffo	:std_ulogic ;

begin

pcom: apex20ke_asynch_pterm 
	generic map ( operation_mode => operation_mode, invert_pterm1_mode => invert_pterm1_mode)
	port map ( pterm0 => pterm0, pterm1 => pterm1, pexpin => pexpin,
                   fbkin => fbk, regin => dffin, combout => combo, 
                   pexpout => pexpout);

preg: apex20ke_pterm_register
	generic map ( power_up => power_up)
	port map ( datain => dffin, clk => clk, ena => ena, aclr => aclr,
                   devclrn => devclrn, devpor => devpor, regout => dffo,
                   fbkout => fbk);	

dataout <= combo when output_mode = "comb" else dffo;

end vital_pterm_atom;

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : APEX20K_ASYNCH_MEM
--
-- Description : Timing simulation model for the asynchronous RAM array.
--               Size of array : 2048x1
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE, apex20ke;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE apex20ke.atom_pack.all;

 
ENTITY apex20ke_asynch_mem is
    GENERIC (
             logical_ram_depth                : integer := 2048;
             inifile                          : string := "none";
             address_width                    : integer := 1;
             deep_ram_mode                    : string := "off";
             first_address                    : integer := 0;
             last_address                     : integer := 2047;
             mem1                             : std_logic_vector(512 downto 1);
             mem2                             : std_logic_vector(512 downto 1);
             mem3                             : std_logic_vector(512 downto 1);
             mem4                             : std_logic_vector(512 downto 1);
             bit_number                       : integer := 0;
             write_logic_clock                : string := "none";
             read_enable_clock                : string := "none";
             data_out_clock                   : string := "none";
             operation_mode                   : string := "single_port";
             TimingChecksOn                   : Boolean := True;
             MsgOn                            : Boolean := DefGlitchMsgOn;
             XOn                              : Boolean := DefGlitchXOn;
             MsgOnChecks                      : Boolean := DefMsgOnChecks;
             XOnChecks                        : Boolean := DefXOnChecks;
             InstancePath                     : STRING := "*";
             tsetup_waddr_we_noedge_posedge   : VitalDelayArrayType(15 downto 0) := (OTHERS => DefSetupHoldCnst);
             thold_waddr_we_noedge_negedge    : VitalDelayArrayType(15 downto 0) := (OTHERS => DefSetupHoldCnst);
             tsetup_datain_we_noedge_negedge  : VitalDelayType := DefSetupHoldCnst;
             thold_datain_we_noedge_negedge   : VitalDelayType := DefSetupHoldCnst;
             tsetup_raddr_re_noedge_negedge   : VitalDelayArrayType(15 downto 0) := (OTHERS => DefSetupHoldCnst);
             thold_raddr_re_noedge_negedge    : VitalDelayArrayType(15 downto 0) := (OTHERS => DefSetupHoldCnst);
             tpd_raddr_dataout                : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
             tpd_waddr_dataout                : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
             tpd_re_dataout                   : VitalDelayType01 := DefPropDelay01;
             tpd_datain_dataout               : VitalDelayType01 := DefPropDelay01;
             tpd_we_dataout                   : VitalDelayType01 := DefPropDelay01;
             tipd_datain                      : VitalDelayType01 := DefPropDelay01;
             tipd_we                          : VitalDelayType01 := DefPropDelay01;
             tipd_re                          : VitalDelayType01 := DefPropDelay01;
             tipd_raddr                       : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
             tipd_waddr                       : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
             tpw_we_posedge                   : VitalDelayType := 0 ns;
             tpw_re_posedge                   : VitalDelayType := 0 ns
            );
 
          PORT (datain  : in std_logic := '0';
                we      : in std_logic := '0';
                re      : in std_logic := '1';
                raddr   : in std_logic_vector(15 downto 0) := "0000000000000000";
                waddr   : in std_logic_vector(15 downto 0) := "0000000000000000";
                devclrn : in std_logic := '1';
                devpor  : in std_logic := '1';
                modesel : in std_logic_vector(17 downto 0) := "000000000000000000";
                dataout : out std_logic
               );

   attribute VITAL_LEVEL0 of apex20ke_asynch_mem : ENTITY is TRUE;

end apex20ke_asynch_mem;
 
ARCHITECTURE behave of apex20ke_asynch_mem is
signal datain_ipd     : std_logic;
signal we_ipd         : std_logic;
signal re_ipd         : std_logic;
signal waddr_ipd      : std_logic_vector(15 downto 0);
signal raddr_ipd      : std_logic_vector(15 downto 0);
begin

  ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
      VitalWireDelay (raddr_ipd(0), raddr(0), tipd_raddr(0));
      VitalWireDelay (raddr_ipd(1), raddr(1), tipd_raddr(1));
      VitalWireDelay (raddr_ipd(2), raddr(2), tipd_raddr(2));
      VitalWireDelay (raddr_ipd(3), raddr(3), tipd_raddr(3));
      VitalWireDelay (raddr_ipd(4), raddr(4), tipd_raddr(4));
      VitalWireDelay (raddr_ipd(5), raddr(5), tipd_raddr(5));
      VitalWireDelay (raddr_ipd(6), raddr(6), tipd_raddr(6));
      VitalWireDelay (raddr_ipd(7), raddr(7), tipd_raddr(7));
      VitalWireDelay (raddr_ipd(8), raddr(8), tipd_raddr(8));
      VitalWireDelay (raddr_ipd(9), raddr(9), tipd_raddr(9));
      VitalWireDelay (raddr_ipd(10), raddr(10), tipd_raddr(10));
      VitalWireDelay (raddr_ipd(11), raddr(11), tipd_raddr(11));
      VitalWireDelay (raddr_ipd(12), raddr(12), tipd_raddr(12));
      VitalWireDelay (raddr_ipd(13), raddr(13), tipd_raddr(13));
      VitalWireDelay (raddr_ipd(14), raddr(14), tipd_raddr(14));
      VitalWireDelay (raddr_ipd(15), raddr(15), tipd_raddr(15));
      VitalWireDelay (waddr_ipd(0), waddr(0), tipd_waddr(0));
      VitalWireDelay (waddr_ipd(1), waddr(1), tipd_waddr(1));
      VitalWireDelay (waddr_ipd(2), waddr(2), tipd_waddr(2));
      VitalWireDelay (waddr_ipd(3), waddr(3), tipd_waddr(3));
      VitalWireDelay (waddr_ipd(4), waddr(4), tipd_waddr(4));
      VitalWireDelay (waddr_ipd(5), waddr(5), tipd_waddr(5));
      VitalWireDelay (waddr_ipd(6), waddr(6), tipd_waddr(6));
      VitalWireDelay (waddr_ipd(7), waddr(7), tipd_waddr(7));
      VitalWireDelay (waddr_ipd(8), waddr(8), tipd_waddr(8));
      VitalWireDelay (waddr_ipd(9), waddr(9), tipd_waddr(9));
      VitalWireDelay (waddr_ipd(10), waddr(10), tipd_waddr(10));
      VitalWireDelay (waddr_ipd(11), waddr(11), tipd_waddr(11));
      VitalWireDelay (waddr_ipd(12), waddr(12), tipd_waddr(12));
      VitalWireDelay (waddr_ipd(13), waddr(13), tipd_waddr(13));
      VitalWireDelay (waddr_ipd(14), waddr(14), tipd_waddr(14));
      VitalWireDelay (waddr_ipd(15), waddr(15), tipd_waddr(15));
      VitalWireDelay (we_ipd, we, tipd_we);
      VitalWireDelay (re_ipd, re, tipd_re);
      VitalWireDelay (datain_ipd, datain, tipd_datain);
   end block;

   VITAL: process(datain_ipd, we_ipd, re_ipd, raddr_ipd, waddr_ipd)
   variable Tviol_waddr_we : std_ulogic := '0';
   variable Tviol_raddr_re : std_ulogic := '0';
   variable Tviol_datain_we : std_ulogic := '0';
   variable TimingData_waddr_we : VitalTimingDataType := VitalTimingDataInit;
   variable TimingData_raddr_re : VitalTimingDataType := VitalTimingDataInit;
   variable TimingData_datain_we : VitalTimingDataType := VitalTimingDataInit;
   variable dataout_VitalGlitchData : VitalGlitchDataType;

   variable read_en : std_logic;
   variable write_en : std_logic;
   variable rword : integer;
   variable wword : integer;
   variable deep_ram_Read : integer;
   variable deep_Ram_write : integer;
   variable mem : std_logic_vector(2047 downto 0);
   variable tmp_dataout : std_logic;
   variable write_en_last_value : std_logic := '0';

   variable do_init_mem : boolean := true;
   variable i : integer := 0;
   begin

      ------------------------
      --  Timing Check Section
      ------------------------
      if (TimingChecksOn) then

         VitalSetupHoldCheck (
                Violation       => Tviol_waddr_we,
                TimingData      => TimingData_waddr_we,
                TestSignal      => waddr_ipd,
                TestSignalName  => "WADDR",
                RefSignal       => we_ipd,
                RefSignalName   => "WE",
                SetupHigh       => tsetup_waddr_we_noedge_posedge(0),
                SetupLow        => tsetup_waddr_we_noedge_posedge(0),
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/APEX20KE_ASYNCH_MEM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

         VitalSetupHoldCheck (
                Violation       => Tviol_waddr_we,
                TimingData      => TimingData_waddr_we,
                TestSignal      => waddr_ipd,
                TestSignalName  => "WADDR",
                RefSignal       => we_ipd,
                RefSignalName   => "WE",
                HoldHigh        => thold_waddr_we_noedge_negedge(0),
                HoldLow         => thold_waddr_we_noedge_negedge(0),
                RefTransition   => '\',
                HeaderMsg       => InstancePath & "/APEX20KE_ASYNCH_MEM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

         VitalSetupHoldCheck (
                Violation       => Tviol_raddr_re,
                TimingData      => TimingData_raddr_re,
                TestSignal      => raddr_ipd,
                TestSignalName  => "RADDR",
                RefSignal       => re_ipd,
                RefSignalName   => "RE",
                SetupHigh       => tsetup_raddr_re_noedge_negedge(0),
                SetupLow        => tsetup_raddr_re_noedge_negedge(0),
                HoldHigh        => thold_raddr_re_noedge_negedge(0),
                HoldLow         => thold_raddr_re_noedge_negedge(0),
                RefTransition   => '\',
                HeaderMsg       => InstancePath & "/APEX20KE_ASYNCH_MEM",
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
                HeaderMsg       => InstancePath & "/APEX20KE_ASYNCH_MEM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
      end if;

      rword := conv_integer(raddr_ipd(10 downto 0));
      wword := conv_integer(waddr_ipd(10 downto 0));
      deep_ram_read := conv_integer(raddr_ipd(15 downto 0));
      deep_ram_write := conv_integer(waddr_ipd(15 downto 0));

      if (now = 0 ns and do_init_mem) then
         do_init_mem := false;
         mem := (mem4 & mem3 & mem2 & mem1);

         -- memory contents depend on WE registered or not
         -- if WE is unregistered, initialize RAM to 'X'

         if (operation_mode /= "rom" and write_logic_clock = "none") then
            for i in 0 to 2047 loop
              mem(i) := 'X';
            end loop;
         end if;

         if (operation_mode = "rom" or operation_mode = "single_port") then
            -- re is always active
            tmp_dataout := mem(0);
         else   -- re is inactive
            tmp_dataout := '0';
         end if;
         if (read_enable_clock /= "none") then
            if (operation_mode = "rom" or operation_mode = "single_port") then
               -- implies re is active
               tmp_dataout := mem(0);
            else
               -- eab cell output powers up to VCC
               tmp_dataout := '1';
            end if;
         end if;
      end if;

      if deep_ram_mode = "off" then
         read_en := re_ipd;
         write_en := we_ipd;
      else -- Deep RAM Mode
         if (deep_ram_read <= last_address) and (deep_ram_read >= first_address) then
            read_en := re_ipd;
         else
            read_en := '0';
         end if;
         if (deep_ram_write <= last_address) and (deep_ram_write >= first_address) then
            write_en := we_ipd; 
         else 
            write_en := '0'; 
         end if;
      end if;

      if modesel(17 downto 16) = 2 then -- ROM
         if read_en = '1' then
            tmp_dataout := mem(rword);
         end if;
      elsif modesel(17 downto 16) = 0 then -- Single Port RAM
         if (write_en = '0') and (write_en_last_value = '1') then
            mem(wword) := datain_ipd;
         end if;
         if write_en = '0' then
            tmp_dataout := mem(wword);
         elsif write_en = '1' then
            tmp_dataout := datain_ipd;
         else
            tmp_dataout := 'X';
         end if;
      elsif modesel(17 downto 16) = 1 then -- Dual Port RAM 
         if (write_en = '0') and (write_en_last_value = '1') then
            mem(wword) := datain_ipd;
         end if;
         if (read_en = '1') and (wword = rword) and (write_en = '1') then    
            tmp_dataout := datain_ipd;
         elsif (read_en = '1') then  
            tmp_dataout := mem(rword);
         end if;
      end if;

      write_en_last_value := write_en;

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => dataout,
       OutSignalName => "DATAOUT",
       OutTemp => tmp_dataout,
       Paths => (1 => (raddr_ipd'last_event, tpd_raddr_dataout(0), TRUE),
                 2 => (waddr_ipd'last_event, tpd_waddr_dataout(0), TRUE),
                 3 => (we_ipd'last_event, tpd_we_dataout, TRUE),
                 4 => (re_ipd'last_event, tpd_re_dataout, TRUE),
                 5 => (datain_ipd'last_event, tpd_datain_dataout, TRUE)),
       GlitchData => dataout_VitalGlitchData,
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
 
LIBRARY IEEE, apex20ke;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE apex20ke.atom_pack.all;

ENTITY dffe is
   GENERIC (
            TimingChecksOn                : Boolean := True;
            XOn                           : Boolean := DefGlitchXOn;
            MsgOn                         : Boolean := DefGlitchMsgOn;
            MsgOnChecks                   : Boolean := DefMsgOnChecks;
            XOnChecks                     : Boolean := DefXOnChecks;
            InstancePath                  : STRING := "*";
            tpd_PRN_Q_negedge             :  VitalDelayType01 := DefPropDelay01;
            tpd_CLRN_Q_negedge            :  VitalDelayType01 := DefPropDelay01;
            tpd_CLK_Q_posedge             :  VitalDelayType01 := DefPropDelay01;
            tpd_ENA_Q_posedge             :  VitalDelayType01 := DefPropDelay01;
            tsetup_D_CLK_noedge_posedge   :  VitalDelayType := DefSetupHoldCnst;
            tsetup_D_CLK_noedge_negedge   :  VitalDelayType := DefSetupHoldCnst;
            tsetup_ENA_CLK_noedge_posedge :  VitalDelayType := DefSetupHoldCnst;
            thold_D_CLK_noedge_posedge    :  VitalDelayType := DefSetupHoldCnst;
            thold_D_CLK_noedge_negedge    :  VitalDelayType := DefSetupHoldCnst;
            thold_ENA_CLK_noedge_posedge  :  VitalDelayType := DefSetupHoldCnst;
            tipd_D                        :  VitalDelayType01 := DefPropDelay01;
            tipd_CLRN                     :  VitalDelayType01 := DefPropDelay01;
            tipd_PRN                      :  VitalDelayType01 := DefPropDelay01;
            tipd_CLK                      :  VitalDelayType01 := DefPropDelay01;
            tipd_ENA                      :  VitalDelayType01 := DefPropDelay01
           );

   PORT    (
            Q                             :  out   STD_LOGIC;
            D                             :  in    STD_LOGIC;
            CLRN                          :  in    STD_LOGIC;
            PRN                           :  in    STD_LOGIC;
            CLK                           :  in    STD_LOGIC;
            ENA                           :  in    STD_LOGIC
           );

   attribute VITAL_LEVEL0 of dffe : ENTITY is TRUE;

end dffe;

-- ARCHITECTURE body --

ARCHITECTURE behave of dffe is
   attribute VITAL_LEVEL0 of behave : ARCHITECTURE is TRUE;

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
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');

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

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : and1
--
-- Description : Simulation model for a 1-input AND gate
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE, apex20ke;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.VITAL_Timing.all;

--USE apex20ke.SUPPORT.all;
USE apex20ke.atom_pack.all;

-- ENTITY declaration --
ENTITY and1 IS
   GENERIC (
            MsgOn                    : Boolean := DefGlitchMsgOn;
            XOn                      : Boolean := DefGlitchXOn;
            tpd_IN1_Y                :  VitalDelayType01 := DefPropDelay01;
            tipd_IN1                 :  VitalDelayType01 := DefPropDelay01);

   PORT    ( Y                       :  out  STD_LOGIC;
             IN1                     :  in   STD_LOGIC
           );
   attribute VITAL_LEVEL0 of and1 : ENTITY is TRUE;
END and1;

-- ARCHITECTURE body --

ARCHITECTURE AltVITAL of and1 is
   attribute VITAL_LEVEL0 of AltVITAL : ARCHITECTURE is TRUE;

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
END nmux21;

ARCHITECTURE structure of nmux21 is
begin

   MO <=  not B when (S = '1') else not A;

END structure;

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
     PORT ( 
                A : in std_logic_vector(15 downto 0) := (OTHERS => '0');
                B : in std_logic_vector(15 downto 0) := (OTHERS => '0');
                S : in std_logic := '0'; 
                MO : out std_logic_vector(15 downto 0)); 
END bmux21; 
 
ARCHITECTURE structure of bmux21 is
BEGIN 
 
   MO <= B when (S = '1') else A; 
 
END structure;

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : APEX20KE_RAM_SLICE
--
-- Description : Timing simulation model for a single RAM segment of the
--               APEX20KE family.
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE, apex20ke;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE IEEE.VITAL_Timing.all;
USE apex20ke.atom_pack.all;

LIBRARY apex20ke;
USE apex20ke.all;

ENTITY  apex20ke_ram_slice is
    GENERIC (
             operation_mode             : string := "single_port";
             deep_ram_mode              : string := "off";
             logical_ram_name           : string := "ram_xxx";
             logical_ram_depth          : integer := 2048;
             logical_ram_width          : integer:= 1;
             address_width              : integer:= 16;
             data_in_clock              : string := "none";
             data_in_clear              : string := "none";
             write_logic_clock          : string := "none";
             write_logic_clear          : string := "none";
             read_enable_clock          : string := "none";
             read_enable_clear          : string := "none";
             read_address_clock         : string := "none";
             read_address_clear         : string := "none";
             data_out_clock             : string := "none";
             data_out_clear             : string := "none";
             init_file                  : string := "none";
             first_address              : integer:= 1;
             last_address               : integer:= 100;
             bit_number                 : integer:= 1;
             power_up                   : string := "low";
             mem1                       : std_logic_vector(512 downto 1);
             mem2                       : std_logic_vector(512 downto 1);
             mem3                       : std_logic_vector(512 downto 1);
             mem4                       : std_logic_vector(512 downto 1)
            );

    PORT    (datain                     : in std_logic;
             clk0                       : in std_logic;
             clk1                       : in std_logic;
             clr0                       : in std_logic;
             clr1                       : in std_logic;
             ena0                       : in std_logic;
             ena1                       : in std_logic;
             we                         : in std_logic;
             re                         : in std_logic;
             waddr                      : in std_logic_vector(15 downto 0);
             raddr                      : in std_logic_vector(15 downto 0);
             devclrn                    : in std_logic := '1';
             devpor                     : in std_logic := '1';
             modesel                    : in std_logic_vector(17 downto 0) := (OTHERS => '0');
             dataout                    : out std_logic
            );
end apex20ke_ram_slice;

ARCHITECTURE structure of apex20ke_ram_slice is
   signal  datain_reg : std_logic;
   signal  we_reg : std_logic;
   signal  re_reg : std_logic;
   signal  dataout_reg : std_logic;
   signal  we_reg_mux : std_logic;
   signal  we_reg_mux_delayed : std_logic;
   signal  raddr_reg : std_logic_vector(15 downto 0);
   signal  waddr_reg : std_logic_vector(15 downto 0);
   signal  datain_int : std_logic;
   signal  we_int : std_logic;
   signal  re_int : std_logic;
   signal  dataout_int : std_logic;
   signal  raddr_int : std_logic_vector(15 downto 0);
   signal  waddr_int : std_logic_vector(15 downto 0);
   signal  reen : std_logic;
   signal  raddren : std_logic;
   signal  dataouten : std_logic;
   signal  datain_clr : std_logic;
   signal  re_clk : std_logic;
   signal  re_clr : std_logic;
   signal  raddr_clk : std_logic;
   signal  raddr_clr : std_logic;
   signal  dataout_clk : std_logic;
   signal  dataout_clr : std_logic;
   signal  datain_reg_sel : std_logic;
   signal  write_reg_sel : std_logic;
   signal  raddr_reg_sel : std_logic;
   -- initialize re_reg_sel right here to avoid glitch on re_int
--   signal  re_reg_sel, dataout_reg_sel, re_clk_sel, re_en_sel : std_logic;
   signal  dataout_reg_sel : std_logic;
   signal  re_clk_sel : std_logic;
   signal  re_en_sel : std_logic;
   signal  re_reg_sel : std_logic;
   signal  re_clr_sel : std_logic;
   signal  raddr_clk_sel : std_logic;
   signal  raddr_clr_sel : std_logic;
   signal  raddr_en_sel : std_logic;
   signal  dataout_clk_sel : std_logic; 
   signal  dataout_clr_sel : std_logic; 
   signal  dataout_en_sel : std_logic; 
   signal  datain_reg_clr : std_logic;
   signal  write_reg_clr : std_logic;
   signal  raddr_reg_clr : std_logic;
   signal  re_reg_clr : std_logic;
   signal  dataout_reg_clr : std_logic;
   signal  datain_reg_clr_sel: std_logic;
   signal  write_reg_clr_sel: std_logic;
   signal  raddr_reg_clr_sel: std_logic;
   signal  re_reg_clr_sel : std_logic;
   signal  dataout_reg_clr_sel : std_logic;
   signal  NC : std_logic := '0';

   signal  dinreg_clr : std_logic;
   signal  wereg_clr : std_logic;
   signal  rereg_clr : std_logic;
   signal  dataoutreg_clr : std_logic;
   signal  raddrreg_clr : std_logic;
   signal  we_pulse : std_logic;
   signal  dataout_tmp : std_logic;
   signal  valid_addr : std_logic;
   signal  raddr_num : integer;

   signal waddr_reg_delayed_1 : std_logic_vector(15 downto 0);
   signal waddr_reg_delayed_2 : std_logic_vector(15 downto 0);
   signal waddr_reg_delayed_3 : std_logic_vector(15 downto 0);
   signal datain_reg_delayed_1 : std_logic;
   signal datain_reg_delayed_2 : std_logic;
   signal datain_reg_delayed_3 : std_logic;

   signal clk0_delayed : std_logic;

COMPONENT DFFE
    GENERIC (TimingChecksOn                : Boolean := true;
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

    PORT    (Q                             :  out   STD_LOGIC := '0';
             D                             :  in    STD_LOGIC := '1';
             CLRN                          :  in    STD_LOGIC := '1';
             PRN                           :  in    STD_LOGIC := '1';
             CLK                           :  in    STD_LOGIC := '0';
             ENA                           :  in    STD_LOGIC := '1'
            );
END COMPONENT;

COMPONENT and1
    GENERIC (XOn                           : Boolean := DefGlitchXOn;
             MsgOn                         : Boolean := DefGlitchMsgOn;
             tpd_IN1_Y                     : VitalDelayType01 := DefPropDelay01;
             tipd_IN1                      : VitalDelayType01 := DefPropDelay01
            );
        
    PORT    (Y                             :  out   STD_LOGIC;
             IN1                           :  in    STD_LOGIC
            );
END COMPONENT;

COMPONENT mux21
    PORT    (A : in std_logic := '0';
             B : in std_logic := '0';
             S : in std_logic := '0';
             MO : out std_logic
            );
END COMPONENT;

COMPONENT nmux21
     PORT ( A : in std_logic := '0';
            B : in std_logic := '0';
            S : in std_logic := '0';
            MO : out std_logic
          );
END COMPONENT;

COMPONENT bmux21
     PORT ( A : in std_logic_vector(15 downto 0) := (OTHERS => '0');
            B : in std_logic_vector(15 downto 0) := (OTHERS => '0');
            S : in std_logic := '0';
            MO : out std_logic_vector(15 downto 0)
          );
END COMPONENT;

COMPONENT apex20ke_asynch_mem
     GENERIC (logical_ram_depth : integer := 2048;
              deep_ram_mode     : string := "OFF";
              bit_number        : integer := 0;
              first_address     : integer := 0;
              last_address      : integer := 2047;
              inifile           : string := "none";
              write_logic_clock : string := "none";
              read_enable_clock : string := "none";
              data_out_clock    : string := "none";
              operation_mode    : string := "single_port";
              mem1              : std_logic_vector(512 downto 1) := (OTHERS=>'0');
              mem2              : std_logic_vector(512 downto 1) := (OTHERS=>'X');
              mem3              : std_logic_vector(512 downto 1) := (OTHERS=>'X');
              mem4              : std_logic_vector(512 downto 1) := (OTHERS=>'X');
              address_width     : integer := 1
             );

     PORT    (datain            : in std_logic := '0';
              we                : in std_logic := '0';
              re                : in std_logic := '0';
              raddr             : in std_logic_vector(15 downto 0) := (OTHERS => '0');
              waddr             : in std_logic_vector(15 downto 0) := (OTHERS => '0');
              devclrn           : in std_logic := '1';
              devpor            : in std_logic := '1';
              modesel           : in std_logic_vector(17 downto 0) := "000000000000000000";
              dataout           : out std_logic
             );
END COMPONENT;
 
begin     

   re_reg_sel <= modesel(6);

   datain_reg_sel         <= modesel(0);
   datain_reg_clr_sel     <= modesel(1);
   write_reg_sel          <= modesel(2);
   write_reg_clr_sel      <= modesel(3);
   raddr_reg_sel          <= modesel(4);
   raddr_reg_clr_sel      <= modesel(5);
   re_reg_sel             <= modesel(6);
   re_reg_clr_sel         <= modesel(7);
   dataout_reg_sel        <= modesel(8);
   dataout_reg_clr_sel    <= modesel(9);
   re_clk_sel             <= modesel(10);
   re_en_sel              <= modesel(10);
   re_clr_sel             <= modesel(11);
   raddr_clk_sel          <= modesel(12);
   raddr_en_sel           <= modesel(12);
   raddr_clr_sel          <= modesel(13);
   dataout_clk_sel        <= modesel(14);
   dataout_en_sel         <= modesel(14);
   dataout_clr_sel        <= modesel(15);

   -- the following assignments insert delta delays for functional
   -- simulation
   datain_reg_delayed_1 <= datain_reg;
   datain_reg_delayed_2 <= datain_reg_delayed_1;
   datain_reg_delayed_3 <= datain_reg_delayed_2;

   datainsel: mux21 
           port map (A => datain,
                     B => datain_reg_delayed_3, 
                     S => datain_reg_sel, 
                     MO => datain_int
                    );

   datainregclr: nmux21
           port map (A => NC, 
                     B => clr0, 
                     S => datain_reg_clr_sel,
                     MO => datain_reg_clr
                    );

   -- the following assignments insert delta delays for functional
   -- simulation
   waddr_reg_delayed_1 <= waddr_reg;
   waddr_reg_delayed_2 <= waddr_reg_delayed_1;
   waddr_reg_delayed_3 <= waddr_reg_delayed_2;

   waddrsel: bmux21 
           port map (A => waddr,
                     B => waddr_reg_delayed_3, 
                     S => write_reg_sel, 
                     MO => waddr_int
                    );
   writeregclr: nmux21
	   port map (A => NC, 
                     B => clr0, 
                     S => write_reg_clr_sel,
                     MO => write_reg_clr
                    );
   wesel2: mux21
           port map (A => we_reg_mux_delayed, 
                     B => we_pulse, 
                     S => write_reg_sel,
                     MO => we_int
                    );
   wesel1: mux21
           port map (A => we, 
                     B => we_reg, 
                     S => write_reg_sel,
                     MO => we_reg_mux
                    );
   raddrsel: bmux21
	   port map (A => raddr, 
                     B => raddr_reg, 
                     S => raddr_reg_sel,
                     MO => raddr_int
                    );
   raddrregclr: nmux21
           port map (A => NC, 
                     B => raddr_clr, 
                     S => raddr_reg_clr_sel,
                     MO => raddr_reg_clr
                    );
   resel: mux21
           port map (A => re, 
                     B => re_reg, 
                     S => re_reg_sel,
                     MO => re_int
                    ); 
   dataoutsel: mux21
           port map (A => dataout_int, 
                     B => dataout_reg, 
                     S => dataout_reg_sel,
                     MO => dataout_tmp
                    ); 
   dataoutregclr: nmux21
           port map (A => NC, 
                     B => dataout_clr, 
                     S => dataout_reg_clr_sel,
                     MO => dataout_reg_clr
                    );
   raddrclksel: mux21
           port map (A => clk0, 
                     B => clk1, 
                     S => raddr_clk_sel,
                     MO => raddr_clk
                    ); 
   raddrensel: mux21
           port map (A => ena0, 
                     B => ena1, 
                     S => raddr_en_sel,
                     MO => raddren
                    ); 
   raddrclrsel: mux21
           port map (A => clr0, 
                     B => clr1, 
                     S => raddr_clr_sel,
                     MO => raddr_clr
                    ); 
   reclksel: mux21
           port map (A => clk0, 
                     B => clk1, 
                     S => re_clk_sel,
                     MO => re_clk
                    ); 
   reensel: mux21
           port map (A => ena0, 
                     B => ena1, 
                     S => re_en_sel,
                     MO => reen
                    ); 
   reclrsel: mux21
           port map (A => clr0, 
                     B => clr1, 
                     S => re_clr_sel,
                     MO => re_clr
                    ); 
   reregclr: nmux21
	   port map (A => NC, 
                     B => re_clr, 
                     S => re_reg_clr_sel,
                     MO => re_reg_clr
                    );
   dataoutclksel: mux21
           port map (A => clk0, 
                     B => clk1, 
                     S => dataout_clk_sel,
                     MO => dataout_clk
                    ); 
   dataoutensel: mux21
           port map (A => ena0, 
                     B => ena1, 
                     S => dataout_en_sel,
                     MO => dataouten
                    ); 
   dataoutclrsel: mux21
           port map (A => clr0, 
                     B => clr1, 
                     S => dataout_clr_sel,
                     MO => dataout_clr
                    ); 

   dinreg_clr <= datain_reg_clr and devclrn and devpor;
   dinreg: dffe
           port map (D => datain,
                     CLRN => dinreg_clr, 
                     CLK => clk0,
                       ENA => ena0, 
                     Q => datain_reg
                     );

   wereg_clr <= write_reg_clr and devclrn and devpor; 
   wereg: dffe 
           port map (D => we, 
                     CLRN => wereg_clr, 
                     CLK => clk0,
                     ENA => ena0, 
                     Q => we_reg
                    );

   -- clk0 for we_pulse should have the same delay as
   -- clk of wereg
   we_pulse <= we_reg_mux_delayed and (not clk0_delayed);

   wedelaybuf: and1
           port map (IN1 => we_reg_mux, 
                     Y => we_reg_mux_delayed
                    );
   clk0weregdelaybuf: and1
           port map (IN1 => clk0, 
                     Y => clk0_delayed
                    );

   rereg_clr <= re_reg_clr and devclrn and devpor; 
   rereg: dffe 
           port map (D => re, 
                     CLRN => rereg_clr, 
                     CLK => re_clk,
                     ENA => reen, 
                     Q => re_reg
                    );

   dataoutreg_clr <= dataout_reg_clr and devclrn and devpor;
   dataoutreg: dffe 
           port map (D => dataout_int, 
                     CLRN => dataoutreg_clr, 
                     CLK => dataout_clk, 
                     ENA => dataouten, 
                     Q => dataout_reg
                    );
   waddrreg_0: dffe 
            port map (D => waddr(0), 
                      CLRN => wereg_clr, 
                      CLK => clk0,
                      ENA => ena0, 
                      Q => waddr_reg(0)
                     );
   waddrreg_1: dffe 
            port map (D => waddr(1), 
                      CLRN => wereg_clr, 
                      CLK => clk0,
                      ENA => ena0, 
                      Q => waddr_reg(1)
                     );
   waddrreg_2: dffe 
            port map (D => waddr(2), 
                      CLRN => wereg_clr, 
                      CLK => clk0,
                      ENA => ena0, 
                      Q => waddr_reg(2)
                     );
   waddrreg_3: dffe 
            port map (D => waddr(3), 
                      CLRN => wereg_clr, 
                      CLK => clk0,
                      ENA => ena0, 
                      Q => waddr_reg(3)
                     );
   waddrreg_4: dffe 
            port map (D => waddr(4), 
                      CLRN => wereg_clr, 
                      CLK => clk0,
                      ENA => ena0, 
                      Q => waddr_reg(4)
                     );
   waddrreg_5: dffe 
            port map (D => waddr(5), 
                      CLRN => wereg_clr, 
                      CLK => clk0,
                      ENA => ena0, 
                      Q => waddr_reg(5)
                     );
   waddrreg_6: dffe 
            port map (D => waddr(6), 
                      CLRN => wereg_clr, 
                      CLK => clk0,
                      ENA => ena0, 
                      Q => waddr_reg(6)
                     );
   waddrreg_7: dffe 
            port map (D => waddr(7), 
                      CLRN => wereg_clr, 
                      CLK => clk0,
                      ENA => ena0, 
                      Q => waddr_reg(7)
                     );
   waddrreg_8: dffe 
            port map (D => waddr(8), 
                      CLRN => wereg_clr, 
                      CLK => clk0,
                      ENA => ena0, 
                      Q => waddr_reg(8)
                     );
   waddrreg_9: dffe 
            port map (D => waddr(9), 
                      CLRN => wereg_clr, 
                      CLK => clk0,
                      ENA => ena0, 
                      Q => waddr_reg(9)
                     );
   waddrreg_10: dffe 
            port map (D => waddr(10), 
                      CLRN => wereg_clr, 
                      CLK => clk0,
                      ENA => ena0, 
                      Q => waddr_reg(10)
                     );
   waddrreg_11: dffe 
            port map (D => waddr(11), 
                      CLRN => wereg_clr, 
                      CLK => clk0,
                      ENA => ena0, 
                      Q => waddr_reg(11)
                     );
   waddrreg_12: dffe 
            port map (D => waddr(12), 
                      CLRN => wereg_clr, 
                      CLK => clk0,
                      ENA => ena0, 
                      Q => waddr_reg(12)
                     );
   waddrreg_13: dffe 
            port map (D => waddr(13), 
                      CLRN => wereg_clr, 
                      CLK => clk0,
                      ENA => ena0, 
                      Q => waddr_reg(13)
                     );
   waddrreg_14: dffe 
            port map (D => waddr(14), 
                      CLRN => wereg_clr, 
                      CLK => clk0,
                      ENA => ena0, 
                      Q => waddr_reg(14)
                     );
   waddrreg_15: dffe 
            port map (D => waddr(15), 
                      CLRN => wereg_clr, 
                      CLK => clk0,
                      ENA => ena0, 
                      Q => waddr_reg(15)
                     );

   raddrreg_clr <= raddr_reg_clr and devclrn and devpor;

   raddrreg_0: dffe 
            port map (D => raddr(0), 
                      CLRN => raddrreg_clr, 
                      CLK => raddr_clk,
                      ENA => raddren, 
                      Q => raddr_reg(0)
                     );
   raddrreg_1: dffe 
            port map (D => raddr(1), 
                      CLRN => raddrreg_clr, 
                      CLK => raddr_clk,
                      ENA => raddren, 
                      Q => raddr_reg(1)
                     );
   raddrreg_2: dffe 
            port map (D => raddr(2), 
                      CLRN => raddrreg_clr, 
                      CLK => raddr_clk,
                      ENA => raddren, 
                      Q => raddr_reg(2)
                     );
   raddrreg_3: dffe 
            port map (D => raddr(3), 
                      CLRN => raddrreg_clr, 
                      CLK => raddr_clk,
                      ENA => raddren, 
                      Q => raddr_reg(3)
                     );
   raddrreg_4: dffe 
            port map (D => raddr(4), 
                      CLRN => raddrreg_clr, 
                      CLK => raddr_clk,
                      ENA => raddren, 
                      Q => raddr_reg(4)
                     );
   raddrreg_5: dffe 
            port map (D => raddr(5), 
                      CLRN => raddrreg_clr, 
                      CLK => raddr_clk,
                      ENA => raddren, 
                      Q => raddr_reg(5)
                     );
   raddrreg_6: dffe 
            port map (D => raddr(6), 
                      CLRN => raddrreg_clr, 
                      CLK => raddr_clk,
                      ENA => raddren, 
                      Q => raddr_reg(6)
                     );
   raddrreg_7: dffe 
            port map (D => raddr(7), 
                      CLRN => raddrreg_clr, 
                      CLK => raddr_clk,
                      ENA => raddren, 
                      Q => raddr_reg(7)
                     );
   raddrreg_8: dffe 
            port map (D => raddr(8), 
                      CLRN => raddrreg_clr, 
                      CLK => raddr_clk,
                      ENA => raddren, 
                      Q => raddr_reg(8)
                     );
   raddrreg_9: dffe 
            port map (D => raddr(9), 
                      CLRN => raddrreg_clr, 
                      CLK => raddr_clk,
                      ENA => raddren, 
                      Q => raddr_reg(9)
                     );
   raddrreg_10: dffe 
            port map (D => raddr(10), 
                      CLRN => raddrreg_clr, 
                      CLK => raddr_clk,
                      ENA => raddren, 
                      Q => raddr_reg(10)
                     );
   raddrreg_11: dffe 
            port map (D => raddr(11), 
                      CLRN => raddrreg_clr, 
                      CLK => raddr_clk,
                      ENA => raddren, 
                      Q => raddr_reg(11)
                     );
   raddrreg_12: dffe 
            port map (D => raddr(12), 
                      CLRN => raddrreg_clr, 
                      CLK => raddr_clk,
                      ENA => raddren, 
                      Q => raddr_reg(12)
                     );
   raddrreg_13: dffe 
            port map (D => raddr(13), 
                      CLRN => raddrreg_clr, 
                      CLK => raddr_clk,
                      ENA => raddren, 
                      Q => raddr_reg(13)
                     );
   raddrreg_14: dffe 
            port map (D => raddr(14), 
                      CLRN => raddrreg_clr, 
                      CLK => raddr_clk,
                      ENA => raddren, 
                      Q => raddr_reg(14)
                     );
   raddrreg_15: dffe 
            port map (D => raddr(15), 
                      CLRN => raddrreg_clr, 
                      CLK => raddr_clk,
                      ENA => raddren, 
                      Q => raddr_reg(15)
                     );

   apexmem: apex20ke_asynch_mem
         generic map (ADDRESS_WIDTH       => address_width,
                      BIT_NUMBER          => bit_number,
                      DEEP_RAM_MODE       => deep_ram_mode,
                      FIRST_ADDRESS       => first_address,
                      LAST_ADDRESS        => last_address,
                      MEM1                => mem1,
                      MEM2                => mem2,
                      MEM3                => mem3,
                      MEM4                => mem4,
                      INIFILE             => init_file,
                      WRITE_LOGIC_CLOCK   => write_logic_clock,
                      READ_ENABLE_CLOCK   => read_enable_clock,
                      DATA_OUT_CLOCK      => data_out_clock,
                      OPERATION_MODE      => operation_mode,
                      LOGICAL_RAM_DEPTH   => logical_ram_depth
                     )

	 port map    (DATAIN              => datain_int,
                      WE                  => we_int,
                      RE                  => re_int,
                      RADDR               => raddr_int,
                      WADDR               => waddr_int, 
                      MODESEL             => modesel,
                      DATAOUT             => dataout_int
                     );

   raddr_num <= conv_integer(raddr_int);

   valid_addr <= '1' when raddr_num <= last_address and raddr_num >= first_address else '0';

   dataout <= dataout_tmp when deep_ram_mode = "off" or (deep_ram_mode = "on" and valid_addr = '1') else 'Z';

end structure;

--/////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : APEX20KE_CAM
--
-- Description : Timing simulation model for the asynchronous CAM array.
--
--/////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE, apex20ke;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE IEEE.VITAL_Primitives.all;
USE IEEE.VITAL_Timing.all;
USE apex20ke.atom_pack.all;

ENTITY  apex20ke_cam IS
    GENERIC (
             operation_mode                     : string := "encoded_address";
             logical_cam_depth                  : integer := 32;
             address_width                      : integer := 5;
             pattern_width                      : integer := 32;
             first_address                      : integer := 0;
             last_address                       : integer := 31;
             init_mem_true                      : apex20ke_mem_data := (OTHERS=> "11111111111111111111111111111111");
             init_mem_comp                      : apex20ke_mem_data := (OTHERS=> "11111111111111111111111111111111");
             first_pattern_bit                  : integer := 0;
             TimingChecksOn                     : Boolean := True;
             MsgOn                              : Boolean := DefGlitchMsgOn;
             XOn                                : Boolean := DefGlitchXOn;
             MsgOnChecks                        : Boolean := DefMsgOnChecks;
             XOnChecks                          : Boolean := DefXOnChecks;
             InstancePath                       : STRING := "*";
             tsetup_lit_we_noedge_posedge       : VitalDelayArrayType(31 downto 0) := (OTHERS => DefSetupHoldCnst);
             thold_lit_we_noedge_posedge        : VitalDelayArrayType(31 downto 0) := (OTHERS => DefSetupHoldCnst);
             tsetup_datain_we_noedge_negedge    : VitalDelayType := DefSetupHoldCnst;
             thold_datain_we_noedge_negedge     : VitalDelayType := DefSetupHoldCnst;
             tsetup_wrinvert_we_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
             thold_wrinvert_we_noedge_posedge   : VitalDelayType := DefSetupHoldCnst;
             tpd_lit_matchout                   : VitalDelayArrayType01(511 downto 0) := (OTHERS => DefPropDelay01);
             tpd_lit_matchfound                 : VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
             tpd_we_matchout                    : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
             tpd_we_matchfound                  : VitalDelayType01 := DefPropDelay01;
             tpd_outputselect_matchout          : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
             tipd_datain                        : VitalDelayType01 := DefPropDelay01;
             tipd_wrinvert                      : VitalDelayType01 := DefPropDelay01;
             tipd_we                            : VitalDelayType01 := DefPropDelay01;
             tipd_outputselect                  : VitalDelayType01 := DefPropDelay01;
             tipd_waddr                         : VitalDelayArrayType01(4 downto 0) := (OTHERS => DefPropDelay01);
             tipd_lit                           : VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01)
            );
 
     PORT   (datain                : in std_logic := '0';
             wrinvert              : in std_logic := '0';
             outputselect          : in std_logic := '0';
             we                    : in std_logic := '0';
             lit                   : in std_logic_vector(31 downto 0);
             waddr                 : in std_logic_vector(4 downto 0) := "00000";
             modesel               : in std_logic_vector(1 downto 0) := "00";
             matchout              : out std_logic_vector(15 downto 0);
             matchfound            : out std_logic
            );

   attribute VITAL_LEVEL0 of apex20ke_cam : ENTITY is TRUE;
END apex20ke_cam;

ARCHITECTURE behave of apex20ke_cam IS
signal datain_ipd, we_ipd, wrinvert_ipd, outputselect_ipd : std_logic;
signal waddr_ipd : std_logic_vector(4 downto 0);
signal lit_ipd : std_logic_vector(31 downto 0);
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
    variable matchout_VitalGlitchDataArray : VitalGlitchDataArrayType(15 downto 0);

    variable wword : std_logic_vector(address_width-1 downto 0);
    variable pattern_tmp, read_pattern : std_logic_vector(pattern_width-1 downto 0);
    variable compare_data, temp : std_logic_vector(pattern_width-1 downto 0);
    variable wdatain_last_value, wrinvert_last_value : std_logic;
    variable m_found, continue : boolean;
    variable wword_int : integer;
    variable encoded_match_addr : std_logic_vector(4 downto 0);
    variable match_out : std_logic_vector(15 downto 0);
    variable match_found : std_logic;

    --  types for true and complement memory arrays
    TYPE mem_array is ARRAY(0 to 31) of std_logic_vector (31 downto 0);

    variable mem_true, mem_comp : mem_array;

    variable mult_match_array : std_logic_vector(31 downto 0) := (OTHERS => '0');
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
                HeaderMsg       => InstancePath & "/APEX20KE_CAM",
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
                HeaderMsg       => InstancePath & "/APEX20KE_CAM",
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
                HeaderMsg       => InstancePath & "/APEX20KE_CAM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

        end if;

   if (we_ipd'event or lit_ipd'event or outputselect_ipd'event) then

   if init then
     -- initialize CAM from generics
      if (operation_mode = "encoded_address") or (operation_mode = "unencoded_32_address")
         or (operation_mode = "single_match") or (operation_mode = "multiple_match") then
         for i in 0 to 31 loop
            mem_true(i) := init_mem_true(i);
            mem_comp(i) := init_mem_comp(i);
         end loop;
      elsif (operation_mode = "unencoded_16_address") or (operation_mode = "fast_multiple_match") then
         for i in 0 to 15 loop
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
         pattern_tmp := lit_ipd(pattern_width-1 downto 0);
         wword := waddr_ipd(address_width-1 downto 0);
         wword_int := alt_conv_integer(wword);
         if (modesel = "10") then   -- unencoded_16_address mode
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
            if (modesel = "10") then   -- unencoded_16_address mode
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
            if (modesel = "10") then   -- unencoded_16_address mode
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
--   elsif (we_pulse = '0') then
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
              encoded_match_addr := conv_std_logic_vector(i, 5);
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
             match_out(4 downto 0) := encoded_match_addr;
             match_found := '1';
         else
             match_out(4 downto 0) := (OTHERS => '0');
             match_found := '0';
         end if;
         match_out(15 downto 5) := (OTHERS => '0');
      elsif (modesel = "01") then
         match_found := '0';
         if (outputselect_ipd = '0') then
            for i in 0 to 15 loop
              match_out(i) := mult_match_array(2*i);
            end loop;
         elsif (outputselect_ipd = '1') then
            for i in 0 to 15 loop
              match_out(i) := mult_match_array(2*i+1);
            end loop;
         end if;
      elsif (modesel = "10") then
        -- output only even addresses
         for i in 0 to 15 loop
            match_out(i) := mult_match_array(2*i);
         end loop;
      end if;

   if (outputselect_ipd'event and outputselect_ipd = '0') then
      for i in 0 to 15 loop
          match_out(i) := mult_match_array(2*i);
      end loop;
   elsif (outputselect_ipd'event and outputselect_ipd = '1') then
      for i in 0 to 15 loop
          match_out(i) := mult_match_array(2*i+1);
      end loop;
   end if;

--   end if;

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

    end process;

end behave;


--/////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : APEX20KE_CAM_SLICE
--
-- Description : Structural model for a single CAM segment of the APEX20KE
--               device family
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE, apex20ke;
USE ieee.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE apex20ke.atom_pack.all;

LIBRARY apex20ke;
USE apex20ke.all;

ENTITY  apex20ke_cam_slice is
    GENERIC (
             operation_mode             : string := "encoded_address";
             logical_cam_name           : string := "cam_xxx";
             logical_cam_depth          : integer := 32;
             logical_cam_width          : integer:= 32;
             address_width              : integer:= 5;
             waddr_clear                : string := "none";
             write_enable_clear         : string := "none";
             write_logic_clock          : string := "none";
             write_logic_clear          : string := "none";
             output_clock               : string := "none";
             output_clear               : string := "none";
             init_file                  : string := "xxx";
             init_filex                 : string := "xxx";
             first_address              : integer:= 0;
             last_address               : integer:= 31;
             first_pattern_bit          : integer:= 0;
             pattern_width              : integer:= 32;
             power_up                   : string := "low";
             init_mem_true              : apex20ke_mem_data;
             init_mem_comp              : apex20ke_mem_data
            );

    PORT    (clk0             : in std_logic;
             clk1             : in std_logic; 
             clr0             : in std_logic; 
             clr1             : in std_logic;
             ena0             : in std_logic;
             ena1             : in std_logic;
             we               : in std_logic;
             datain           : in std_logic;
             wrinvert         : in std_logic;
             outputselect     : in std_logic;
             waddr            : in std_logic_vector(4 downto 0);
             lit              : in std_logic_vector(31 downto 0);
             devclrn          : in std_logic := '1';
             devpor           : in std_logic := '1';
             modesel          : in std_logic_vector(9 downto 0) := (OTHERS => '0');
             matchout         : out std_logic_vector(15 downto 0);
             matchfound       : out std_logic
            );

end apex20ke_cam_slice;

ARCHITECTURE structure of apex20ke_cam_slice is
signal waddr_clr_sel, write_logic_clr_sel, we_clr_sel : std_logic;
signal output_clr_sel, output_reg_clr_sel : std_logic;
signal write_logic_sel, output_reg_sel, output_clk_sel : std_logic;
signal output_clk, output_clk_en, output_clr : std_logic;
signal output_reg_clr, we_clr, waddr_clr, write_logic_clr : std_logic;
signal matchfound_int, matchfound_reg, matchfound_tmp : std_logic;
signal wdatain_reg, wdatain_int, wrinv_reg, wrinv_int : std_logic;
signal matchout_reg, matchout_int : std_logic_vector(15 downto 0);
signal waddr_reg : std_logic_vector(4 downto 0);
signal we_reg, we_reg_delayed : std_logic;
signal NC : std_logic := '0';

signal wereg_clr, writelogic_clr : std_logic;
signal waddrreg_clr, outputreg_clr : std_logic;
signal we_pulse : std_logic;

-- clk0 for we_pulse should have the same delay as
-- clk of wereg
signal clk0_delayed : std_logic;

COMPONENT DFFE
    GENERIC (
             TimingChecksOn               : Boolean := true;
             InstancePath                 : STRING := "*";
             XOn                          : Boolean := DefGlitchXOn;
             MsgOn                        : Boolean := DefGlitchMsgOn;
             MsgOnChecks                  : Boolean := DefMsgOnChecks;
             XOnChecks                    : Boolean := DefXOnChecks;
             tpd_PRN_Q_negedge            : VitalDelayType01 := DefPropDelay01;
             tpd_CLRN_Q_negedge           : VitalDelayType01 := DefPropDelay01;
             tpd_CLK_Q_posedge            : VitalDelayType01 := DefPropDelay01;
             tpd_ENA_Q_posedge            : VitalDelayType01 := DefPropDelay01;
             tsetup_D_CLK_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
             tsetup_D_CLK_noedge_negedge  : VitalDelayType := DefSetupHoldCnst;
             tsetup_ENA_CLK_noedge_posedge: VitalDelayType := DefSetupHoldCnst;
             thold_D_CLK_noedge_posedge   : VitalDelayType := DefSetupHoldCnst;
             thold_D_CLK_noedge_negedge   : VitalDelayType := DefSetupHoldCnst;
             thold_ENA_CLK_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             tipd_D                       : VitalDelayType01 := DefPropDelay01;
             tipd_CLRN                    : VitalDelayType01 := DefPropDelay01;
             tipd_PRN                     : VitalDelayType01 := DefPropDelay01;
             tipd_CLK                     : VitalDelayType01 := DefPropDelay01;
             tipd_ENA                     : VitalDelayType01 := DefPropDelay01
            );

    PORT    (
             Q                            :  out   STD_LOGIC := '0';
             D                            :  in    STD_LOGIC := '1';
             CLRN                         :  in    STD_LOGIC := '1';
             PRN                          :  in    STD_LOGIC := '1';
             CLK                          :  in    STD_LOGIC := '0';
             ENA                          :  in    STD_LOGIC := '1'
            );
END COMPONENT;

COMPONENT and1
    GENERIC (
             XOn            : Boolean := DefGlitchXOn;
             MsgOn          : Boolean := DefGlitchMsgOn;
             tpd_IN1_Y      :  VitalDelayType01 := DefPropDelay01;
             tipd_IN1       :  VitalDelayType01 := DefPropDelay01
            );

    PORT    (Y              :  out   STD_LOGIC;
             IN1            :  in    STD_LOGIC
            );
END COMPONENT;

COMPONENT mux21
    PORT ( A : in std_logic := '0';
           B : in std_logic := '0';
           S : in std_logic := '0';
           MO : out std_logic
         );
END COMPONENT;

COMPONENT nmux21
    PORT ( A : in std_logic := '0';
           B : in std_logic := '0';
           S : in std_logic := '0';
           MO : out std_logic
         );
END COMPONENT;

COMPONENT bmux21
    PORT ( A : in std_logic_vector(15 downto 0) := (OTHERS => '0');
           B : in std_logic_vector(15 downto 0) := (OTHERS => '0');
           S : in std_logic := '0';
           MO : out std_logic_vector(15 downto 0)
         );
END COMPONENT;

COMPONENT apex20ke_cam
    GENERIC (operation_mode       : string := "encoded_address";
             logical_cam_depth    : integer := 32;
             first_pattern_bit    : integer := 0;
             first_address        : integer := 0;
             last_address         : integer := 31;
             init_mem_true        : apex20ke_mem_data := (OTHERS => "11111111111111111111111111111111");
             init_mem_comp        : apex20ke_mem_data := (OTHERS => "11111111111111111111111111111111");
             address_width        : integer := 1;
             pattern_width        : integer := 32
            );

     PORT    (datain              : in std_logic := '0';
              wrinvert            : in std_logic := '0';
              outputselect        : in std_logic := '0';
              we                  : in std_logic := '0';
              waddr               : in std_logic_vector(4 downto 0) := (OTHERS => '0');
              lit                 : in std_logic_vector(31 downto 0) := (OTHERS => '0');
              modesel             : in std_logic_vector(1 downto 0) := "00";
              matchfound          : out std_logic;
              matchout            : out std_logic_vector(15 downto 0)
             );
END COMPONENT;

begin
    -- READ THE MODESEL PORT BITS
  
    waddr_clr_sel             <= modesel(0);
    write_logic_sel           <= modesel(1);
    write_logic_clr_sel       <= modesel(2);
    we_clr_sel                <= modesel(3);
    output_reg_sel            <= modesel(4);
    output_clk_sel            <= modesel(5);
    output_clr_sel            <= modesel(6);
    output_reg_clr_sel        <= modesel(7);
    
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
    matchoutsel: bmux21
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
    matchfoundreg: dffe
            port map (D => matchfound_int,
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchfound_reg
                     );
    
    cam1: apex20ke_cam
           generic map (operation_mode      => operation_mode,
                        address_width       => address_width,
                        pattern_width       => pattern_width,
                        first_pattern_bit   => first_pattern_bit,
                        first_address       => first_address,
                        last_address        => last_address,
                        init_MEM_TRUE       => init_mem_true,
                        init_MEM_COMP       => init_mem_comp,
                        LOGICAL_CAM_DEPTH   => logical_cam_depth
                       )

            port map   (datain              => wdatain_int,
                        wrinvert            => wrinv_int,
                        outputselect        => outputselect,
                        we                  => we_pulse,
                        waddr               => waddr_reg,
                        lit                 => lit,
                        modesel             => modesel(9 downto 8),
                        matchout            => matchout_int,
                        matchfound          => matchfound_int
                       );

end structure;

--
-- APEX20KE_LVDS_TRANSMITTER
--
LIBRARY IEEE, apex20ke;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use apex20ke.atom_pack.all;


ENTITY apex20ke_lvds_transmitter is
    GENERIC (
		channel_width		: integer := 8;
--		power_up		: string  := "low";
		TimingChecksOn		: Boolean := True;
		MsgOn			: Boolean := DefGlitchMsgOn;
                MsgOnChecks             : Boolean := DefMsgOnChecks;
                XOnChecks               : Boolean := DefXOnChecks;
		XOn			: Boolean := DefGlitchXOn;
		InstancePath		: String := "*";
		tsetup_datain_clk1_noedge_negedge  : VitalDelayArrayType(7 downto 0) := (OTHERS => DefSetupHoldCnst);
		thold_datain_clk1_noedge_negedge   : VitalDelayArrayType(7 downto 0) := (OTHERS => DefSetupHoldCnst);
		tpd_clk0_dataout_negedge: VitalDelayType01 := DefPropDelay01;
		tipd_clk0		: VitalDelayType01 := DefpropDelay01;
		tipd_clk1		: VitalDelayType01 := DefpropDelay01;
		tipd_datain		: VitalDelayArrayType01(7 downto 0) := (OTHERS => DefpropDelay01));

	PORT (
		clk0		: in std_logic;
		clk1		: in std_logic;
		datain		: in std_logic_vector(7 downto 0);
		devclrn		: in std_logic := '1';
		devpor		: in std_logic := '1';
		dataout		: out std_logic);
	attribute VITAL_LEVEL0 of apex20ke_lvds_transmitter : ENTITY is TRUE;
end apex20ke_lvds_transmitter;

ARCHITECTURE vital_transmitter_atom of apex20ke_lvds_transmitter is
    attribute VITAL_LEVEL0 of vital_transmitter_atom : ARCHITECTURE is TRUE;
    signal clk0_ipd, clk1_ipd : std_logic;
    signal datain_ipd : std_logic_vector(7 downto 0);

begin
	----------------------
	--  INPUT PATH DELAYs
	----------------------
	WireDelay : block
	begin
	VitalWireDelay (clk0_ipd, clk0, tipd_clk0);
	VitalWireDelay (clk1_ipd, clk1, tipd_clk1);
	VitalWireDelay (datain_ipd(0), datain(0), tipd_datain(0));
	VitalWireDelay (datain_ipd(1), datain(1), tipd_datain(1));
	VitalWireDelay (datain_ipd(2), datain(2), tipd_datain(2));
	VitalWireDelay (datain_ipd(3), datain(3), tipd_datain(3));
	VitalWireDelay (datain_ipd(4), datain(4), tipd_datain(4));
	VitalWireDelay (datain_ipd(5), datain(5), tipd_datain(5));
	VitalWireDelay (datain_ipd(6), datain(6), tipd_datain(6));
	VitalWireDelay (datain_ipd(7), datain(7), tipd_datain(7));
	end block;

VITAL: process (clk0_ipd, clk1_ipd, devclrn, devpor)
variable Tviol_datain_clk1 : std_ulogic := '0';
variable TimingData_datain_clk1 : VitalTimingDataType := VitalTimingDataInit;
variable dataout_VitalGlitchData : VitalGlitchDataType;
variable i : integer := 0;
variable dataout_tmp : std_logic;
variable indata : std_logic_vector(channel_width-1 downto 0);
variable regdata : std_logic_vector(channel_width-1 downto 0);
variable fast_clk_count : integer := 4;
begin

      if (now = 0 ns) then
	 dataout_tmp := '0';
      end if;

      ------------------------
      --  Timing Check Section
      ------------------------
      if (TimingChecksOn) then

         VitalSetupHoldCheck (
                Violation       => Tviol_datain_clk1,
                TimingData      => TimingData_datain_clk1,
                TestSignal      => datain_ipd,
                TestSignalName  => "DATAIN",
                RefSignal       => clk0_ipd,
                RefSignalName   => "CLK1",
                SetupHigh       => tsetup_datain_clk1_noedge_negedge(0),
                SetupLow        => tsetup_datain_clk1_noedge_negedge(0),
                HoldHigh        => thold_datain_clk1_noedge_negedge(0),
                HoldLow         => thold_datain_clk1_noedge_negedge(0),
                RefTransition   => '\',
                HeaderMsg       => InstancePath & "/APEX20KE_LVDS_TX",
                XOn             => XOn,
                MsgOn           => MsgOn );

      end if;

   if ((devpor = '0') or (devclrn = '0')) then
--      if (power_up = "low") then
         dataout_tmp := '0';
--      elsif (power_up = "high") then
--         dataout_tmp := '1';
--      end if;
   else
      if (clk1_ipd'event and clk1_ipd = '1') then
--	 indata := datain_ipd(channel_width-1 downto 0);
	 fast_clk_count := 0;
      end if;
      if (clk0_ipd'event and clk0_ipd = '1') then
		-- SPR 87691	fast_clk_count := fast_clk_count + 1;
			if (fast_clk_count = 2) then
         	for i in channel_width-1 downto 0 loop
					regdata(i) := indata(i);
	 			end loop;
			end if;
         dataout_tmp := regdata(channel_width-1);
         for i in channel_width-1 downto 1 loop
				regdata(i) := regdata(i-1);
	 		end loop;
      end if;
      if (clk0_ipd'event and clk0_ipd = '0') then  -- falling edge
			fast_clk_count := fast_clk_count + 1; -- SPR 87691
	 if (fast_clk_count = 3) then
	    indata := datain_ipd(channel_width-1 downto 0);
	 end if;
      end if;
   end if;

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => dataout,
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp,
       Paths => (1 => (clk0_ipd'last_event, tpd_clk0_dataout_negedge, TRUE)),
       GlitchData => dataout_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

end process;

end vital_transmitter_atom;

--
-- APEX20KE_LVDS_RECEIVER
--

LIBRARY IEEE, apex20ke, std;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use apex20ke.atom_pack.all;
use std.textio.all;


ENTITY apex20ke_lvds_receiver is
    GENERIC (
		channel_width		: integer := 8;
--		power_up		: string  := "low";
		TimingChecksOn		: Boolean := True;
		MsgOn			: Boolean := DefGlitchMsgOn;
		XOn			: Boolean := DefGlitchXOn;
                MsgOnChecks             : Boolean := DefMsgOnChecks;
                XOnChecks               : Boolean := DefXOnChecks;
		InstancePath		: String := "*";
		tpd_clk0_dataout_negedge: VitalDelayArrayType01(7 downto 0) := (OTHERS => DefPropDelay01);
		tipd_clk0		: VitalDelayType01 := DefpropDelay01;
		tipd_clk1		: VitalDelayType01 := DefpropDelay01;
		tipd_deskewin		: VitalDelayType01 := DefpropDelay01;
		tipd_datain		: VitalDelayType01 := DefpropDelay01);

	PORT (
		clk0		: in std_logic;
		clk1		: in std_logic;
		datain		: in std_logic;
		deskewin	: in std_logic := '0';
		devclrn		: in std_logic := '1';
		devpor		: in std_logic := '1';
		dataout		: out std_logic_vector(7 downto 0));
	attribute VITAL_LEVEL0 of apex20ke_lvds_receiver : ENTITY is TRUE;
end apex20ke_lvds_receiver;

ARCHITECTURE vital_receiver_atom of apex20ke_lvds_receiver is
    attribute VITAL_LEVEL0 of vital_receiver_atom : ARCHITECTURE is TRUE;
    signal clk0_tmp, clk0_ipd, clk1_ipd, deskewin_ipd : std_logic;
    signal clk0_tmp1, clk0_tmp2 : std_logic;
    signal datain_ipd : std_logic;

begin
	----------------------
	--  INPUT PATH DELAYs
	----------------------
	WireDelay : block
	begin
	VitalWireDelay (clk0_tmp, clk0, tipd_clk0);
	VitalWireDelay (clk1_ipd, clk1, tipd_clk1);
	VitalWireDelay (deskewin_ipd, deskewin, tipd_deskewin);
	VitalWireDelay (datain_ipd, datain, tipd_datain);
	end block;

clk0_tmp1 <= clk0_tmp after 0 ns;
clk0_tmp2 <= clk0_tmp1 after 0 ns;
clk0_ipd <= clk0_tmp2 after 0 ns;

VITAL: process (deskewin_ipd, clk0_ipd, clk1_ipd, devpor, devclrn)
variable Tviol_datain_clk0 : std_ulogic := '0';
variable Tviol_deskewin_clk0 : std_ulogic := '0';
variable TimingData_datain_clk0 : VitalTimingDataType := VitalTimingDataInit;
variable TimingData_deskewin_clk0 : VitalTimingDataType := VitalTimingDataInit;
variable dataout_VitalGlitchDataArray : VitalGlitchDataArrayType(7 downto 0);
variable clk0_count, cal_error : integer := 0;
variable cal_cycle : integer := 1;
variable deser_data_arr : std_logic_vector(channel_width-1 downto 0);
variable dataout_tmp : std_logic_vector(7 downto 0);
variable first_cycle : boolean := true;
variable fast_clk_count : integer := 4;
variable deskew_asserted, calibrated, check_calibration : boolean := false;
variable screen_buffer : LINE;
variable temp7vec : bit_vector(6 downto 0);
variable temp8vec : bit_vector(7 downto 0);
variable result : boolean := false;
begin

      if (now = 0 ns) then
         dataout_tmp := (OTHERS => '0');
      end if;

      ------------------------
      --  Timing Check Section
      ------------------------

if ((devpor = '0') or (devclrn = '0')) then
--      if (power_up = "low") then
         dataout_tmp := (OTHERS => '0');
--      elsif (power_up = "high") then
--         dataout_tmp := (OTHERS => '1');
--      end if;
else
   if (deskewin_ipd'event and deskewin_ipd = '1') then
      deskew_asserted := true;
      calibrated := false;
      if (channel_width < 7) then
	 assert false report "Channel Width is less than 7. Calibration signal ignored." severity warning;
      else
	 assert false report "Calibrating receiver ...." severity note;
      end if;
   end if;
   if (deskewin_ipd'event and deskewin_ipd = '0') then
      deskew_asserted := false;
   end if;

   if (clk1_ipd'event and clk1_ipd = '1') then
      clk0_count := 0;
      if (check_calibration and not calibrated) then
      -- old is_calibration_pattern function
         if (channel_width = 7) then
            if (deser_data_arr = "0000111") then
               -- calibrate ok
               write(screen_buffer, string'("Cycle : "));
               write(screen_buffer, cal_cycle);
               write(screen_buffer, string'(", Calibration pattern: 0000111."));
               writeline (OUTPUT, screen_buffer);
               result := true;
            else
               write(screen_buffer, string'("Calibration error in cycle "));
               write(screen_buffer, cal_cycle);
               writeline (OUTPUT, screen_buffer);
               write(screen_buffer, string'("Expected pattern: 0000111, Actual pattern: "));
               temp7vec := To_BitVector(deser_data_arr);
               write(screen_buffer, temp7vec);
               writeline (OUTPUT, screen_buffer);
               result := false;
            end if;
         elsif (channel_width = 8) then
            if (deser_data_arr = "00001111") then
               -- calibrate ok
               write(screen_buffer, string'("Cycle : "));
               write(screen_buffer, cal_cycle);
               write(screen_buffer, string'(", Calibration pattern: 00001111."));
               writeline (OUTPUT, screen_buffer);
               result := true;
            else
               write(screen_buffer, string'("Calibration error in cycle "));
               write(screen_buffer, cal_cycle);
               writeline (OUTPUT, screen_buffer);
               write(screen_buffer, string'("Expected pattern: 00001111, Actual pattern: "));
               temp8vec := To_BitVector(deser_data_arr);
               write(screen_buffer, temp8vec);
               writeline (OUTPUT, screen_buffer);
               result := false;
            end if;
         end if;
         if (result = true) then
             cal_cycle := cal_cycle + 1;
	     if (cal_cycle >= 4) then
                calibrated := true;
                assert false report "Receiver Calibration successful" severity note;
             end if;
         else
         	if (not calibrated and not deskew_asserted) then
         	    write(screen_buffer, string'("Receiver calibration requires at least 3 clock cycles.  Only "));
         	    write(screen_buffer, cal_cycle);
         	    write(screen_buffer, string'("cycles were completed when deskew was deasserted. Receiver may not be calibrated."));
         	    writeline (OUTPUT, screen_buffer);
         	end if;
            cal_cycle := 0;
         end if;
      end if;
      if (deskew_asserted) then
         check_calibration := true;
      else
         check_calibration := false;
      end if;
   end if;
   if (clk0_ipd'event and clk0_ipd = '1') then
       -- SPR 87691clk0_count := clk0_count + 1;
   end if;
   if (clk0_ipd'event and clk0_ipd = '0') then
       clk0_count := clk0_count + 1;
      if (clk0_count = 3 and not deskew_asserted) then
	 dataout_tmp(channel_width-1 downto 0) := deser_data_arr;
      end if;
      for i in channel_width-1 downto 1 loop
	  deser_data_arr(i) := deser_data_arr(i-1);
      end loop;
      deser_data_arr(0) := datain_ipd;
   end if;
end if;

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => dataout(0),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(0),
       Paths => (1 => (clk0_ipd'last_event, tpd_clk0_dataout_negedge(0), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(0),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(1),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(1),
       Paths => (1 => (clk0_ipd'last_event, tpd_clk0_dataout_negedge(1), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(1),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(2),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(2),
       Paths => (1 => (clk0_ipd'last_event, tpd_clk0_dataout_negedge(2), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(2),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(3),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(3),
       Paths => (1 => (clk0_ipd'last_event, tpd_clk0_dataout_negedge(3), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(3),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(4),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(4),
       Paths => (1 => (clk0_ipd'last_event, tpd_clk0_dataout_negedge(4), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(4),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(5),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(5),
       Paths => (1 => (clk0_ipd'last_event, tpd_clk0_dataout_negedge(5), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(5),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(6),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(6),
       Paths => (1 => (clk0_ipd'last_event, tpd_clk0_dataout_negedge(6), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(6),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => dataout(7),
       OutSignalName => "DATAOUT",
       OutTemp => dataout_tmp(7),
       Paths => (1 => (clk0_ipd'last_event, tpd_clk0_dataout_negedge(7), TRUE)),
       GlitchData => dataout_VitalGlitchDataArray(7),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

end process;

end vital_receiver_atom;

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : APEX20KE_PLL
--
-- Description : Timing simulation model for APEX20KE device family PLL
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE, apex20ke;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE apex20ke.atom_pack.all;

ENTITY  apex20ke_pll is
    GENERIC (
             input_frequency            : integer  := 1000;
             operation_mode             : string := "normal";
             simulation_type            : string := "timing";
             clk0_multiply_by           : integer := 1;
             clk0_divide_by             : integer := 1;
             clk1_multiply_by           : integer := 1;
             clk1_divide_by             : integer := 1;
             phase_shift                : integer := 0;
             effective_phase_shift      : integer := 0;
             effective_clk0_delay       : integer := 0;
             effective_clk1_delay       : integer := 0;
             lock_high                  : integer := 1;
             invalid_lock_multiplier    : integer := 5;
             valid_lock_multiplier      : integer := 5;
             lock_low                   : integer := 1;
             MsgOn                      : Boolean := DefGlitchMsgOn;
             XOn                        : Boolean := DefGlitchXOn;
             tpd_ena_clk0               : VitalDelayType01 := DefPropDelay01;
             tpd_ena_clk1               : VitalDelayType01 := DefPropDelay01;
             tpd_clk_locked             : VitalDelayType01 := DefPropDelay01;
             tpd_fbin_clk0              : VitalDelayType01 := DefPropDelay01;
             tpd_fbin_clk1              : VitalDelayType01 := DefPropDelay01;
             tipd_clk                   : VitalDelayType01 := DefpropDelay01;
             tipd_fbin                  : VitalDelayType01 := DefpropDelay01;
             tipd_ena                   : VitalDelayType01 := DefpropDelay01
            );

    PORT    (clk                        : in std_logic;
             ena                        : in std_logic;
             fbin                       : in std_logic;
             clk0                       : out std_logic;
             clk1                       : out std_logic;
             locked                     : out std_logic
            );
        attribute VITAL_LEVEL0 of apex20ke_pll : ENTITY is TRUE;
end apex20ke_pll;

ARCHITECTURE vital_pll_atom of apex20ke_pll is
attribute VITAL_LEVEL0 of vital_pll_atom : ARCHITECTURE is TRUE;
signal clk_ipd : std_logic;
signal ena_ipd : std_logic;
signal fbin_ipd : std_logic;

SIGNAL clk0_period, clk1_period, half_inclk : time;
SIGNAL pll_lock : std_logic := '0';
SIGNAL lock_on_rise, lock_on_fall : integer := 0;
SIGNAL clk_check : std_logic := '0';

SIGNAL clk0_tmp, clk1_tmp : std_logic := 'X';
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

    process (clk_ipd, ena_ipd, pll_lock, clk_check)
    variable expected_cycle, real_cycle : real := 0.0;
    variable inclk_ps : time := 0 ps;
    variable violation : boolean := false;
    variable pll_lock_tmp : std_logic := '0';
    variable start_lock_count, stop_lock_count : integer := 0;
    variable pll_last_rising_edge, pll_last_falling_edge : time := 0 ps;
    variable pll_rising_edge_count : integer := 0 ;
    variable pll_cycle, pll_duty_cycle : time := 0 ps;
    variable expected_next_clk_edge : time := 0 ps;
    variable clk_per_tolerance : time := 0 ps; 
    variable locked_VitalGlitchData : VitalGlitchDataType;

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
    variable clk1_cycles_per_sync_period : integer := clk1_multiply_by;
    variable schedule_clk0, schedule_clk1 : boolean := false;
    variable clk0_phase_delay, clk1_phase_delay : time := 0 ps;
    begin
       if (init) then
          clk0_cycles_per_sync_period := clk0_multiply_by;
          clk1_cycles_per_sync_period := clk1_multiply_by;
          input_cycles_per_clk0 := clk0_divide_by;
          input_cycles_per_clk1 := clk1_divide_by;
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
             inclk_ps := (input_frequency / 1 ) * 1 ps;
             half_inclk <= inclk_ps/2;
             clk_per_tolerance := 0.1 * inclk_ps;
             clk0_period <= (clk0_divide_by * inclk_ps) / clk0_multiply_by;
             clk1_period <= (clk1_divide_by * inclk_ps)/ clk1_multiply_by;
             pll_duty_cycle := inclk_ps/2;

             if (simulation_type = "functional") then
                clk0_phase_delay := phase_shift * 1 ps;
                clk1_phase_delay := phase_shift * 1 ps;
             else
                clk0_phase_delay := effective_clk0_delay * 1 ps;
                clk1_phase_delay := effective_clk1_delay * 1 ps;
             end if;
          elsif pll_rising_edge_count = 1 then      -- at 2nd rising edge
             pll_cycle := now - pll_last_rising_edge;    -- calculate period
             expected_cycle := real(input_frequency) / 1000.0;
             real_cycle := REAL( (NOW - pll_last_rising_edge) / 1 ns);
             if ( (NOW - pll_last_rising_edge) < (inclk_ps - clk_per_tolerance)  or
                  (NOW - pll_last_rising_edge) > (inclk_ps + clk_per_tolerance)) then
                assert false report " Inclock_Period Violation " severity warning;
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
             if ( (now - pll_last_falling_edge) < (pll_duty_cycle - clk_per_tolerance/2) or (now - pll_last_falling_edge) > (pll_duty_cycle + clk_per_tolerance/2) ) then
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
                 (now - pll_last_rising_edge) > (inclk_ps + clk_per_tolerance) ) then
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
                      clk0_synchronizing_period := ((pll_cycle/1 ps) * clk0_divide_by) * 1 ps;
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
             start_lock_count := 1;
          end if;

       elsif (clk_ipd'event and clk_ipd= '0') then
          if (pll_lock_tmp = '1') then
             clk_check <= not clk_check after (inclk_ps+clk_per_tolerance)/2.0;
             if (now > 0 ns and ((now - pll_last_rising_edge) < (pll_duty_cycle - clk_per_tolerance/2) or (now - pll_last_rising_edge) > (pll_duty_cycle + clk_per_tolerance/2) ) ) then
                assert false report "Duty Cycle Violation" severity warning; 
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
          start_lock_count := 0;
          stop_lock_count := 0;
          lock_on_rise <= 0;
          lock_on_fall <= 0;
       end if;

       ----------------------
       --  Path Delay Section
       ----------------------
       VitalPathDelay01 (
         OutSignal => locked,
         OutSignalName => "LOCKED",
         OutTemp => pll_lock,
         Paths => (1 => (clk_ipd'last_event, tpd_clk_locked, TRUE)),
         GlitchData => locked_VitalGlitchData,
         Mode => DefGlitchMode,
         XOn  => XOn,
         MsgOn  => MsgOn );

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

end vital_pll_atom;

LIBRARY IEEE, apex20ke;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use apex20ke.atom_pack.all;

ENTITY output_delay is
  
  GENERIC (
    tpd_clk_out_posedge : VitalDelayType01 := DefPropDelay01;  -- tco
    MsgOn: Boolean := DefGlitchMsgOn;
    XOn: Boolean := DefGlitchXOn);

  PORT (
    clk    : in  std_logic;
    input  : in  std_logic;
    output : out std_logic);

end output_delay;

ARCHITECTURE v1 of output_delay is

begin  -- v1

process (input, clk)
variable output_VitalGlitchData : VitalGlitchDataType;
begin  -- process
  VitalPathDelay01 (
    OutSignal => output,
    OutSignalName => "REGOUT",
    OutTemp => input,
    Paths => (0 => (clk'last_event, tpd_clk_out_posedge, TRUE)),
    GlitchData => output_VitalGlitchData,
    Mode => DefGlitchMode,
    XOn  => XOn,
    MsgOn  => MsgOn );
 
end process;
 

end v1;


--
-- Excalibur DPRAM atom.
--


LIBRARY IEEE, apex20ke;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_textio.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use apex20ke.atom_pack.all;

use std.textio.all;

LIBRARY apex20ke;
use apex20ke.all;

ENTITY apex20ke_dpram is
  GENERIC (
            operation_mode                              : string;
            output_mode                                 : string;
            width                                       : integer;
            addrwidth                                   : integer;
            depth                                       : integer;
            ramblock                                    : integer                            := -1;
            ramcontent                                  : string                             := "none" ;
            MsgOn                                       : Boolean                            := DefGlitchMsgOn;
            XOn                                         : Boolean                            := DefGlitchXOn;
            MsgOnChecks	                               	: Boolean                            := DefMsgOnChecks;
            XOnChecks                                   : Boolean                            := DefXOnChecks;
            InstancePath                                : String                             := "*";
            tipd_portadatain                            : VitalDelayArrayType01(63 downto 0) := (OTHERS => DefPropDelay01);
            tipd_portbdatain                            : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
            tipd_portaaddr                              : VitalDelayArrayType01(16 downto 0) := (OTHERS => DefPropDelay01);
            tipd_portbaddr                              : VitalDelayArrayType01(14 downto 0) := (OTHERS => DefPropDelay01);
            tipd_portaclk                               : VitalDelayType01                   := DefPropDelay01;
            tipd_portbclk                               : VitalDelayType01                   := DefPropDelay01;
            tipd_portawe                                : VitalDelayType01                   := DefPropDelay01;
            tipd_portbwe                                : VitalDelayType01                   := DefPropDelay01;
            tipd_portaena                               : VitalDelayType01                   := DefPropDelay01;
            tipd_portbena                               : VitalDelayType01                   := DefPropDelay01;
            tpd_portaclk_portadataout_posedge           : VitalDelayArrayType01(63 downto 0) := (OTHERS => DefPropDelay01);
            tpd_portbclk_portbdataout_posedge           : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
            tsetup_portadataout_portaclk_noedge_posedge : VitalDelayArrayType  (63 downto 0) := (OTHERS => DefSetupHoldCnst);
            tsetup_portbdataout_portbclk_noedge_posedge : VitalDelayArrayType  (15 downto 0) := (OTHERS => DefSetupHoldCnst);
            thold_portadataout_portaclk_noedge_posedge  : VitalDelayArrayType  (63 downto 0) := (OTHERS => DefSetupHoldCnst);
            thold_portbdataout_portbclk_noedge_posedge  : VitalDelayArrayType  (15 downto 0) := (OTHERS => DefSetupHoldCnst);
            tsetup_portadatain_portaclk_noedge_posedge  : VitalDelayArrayType  (63 downto 0) := (OTHERS => DefSetupHoldCnst);
            tsetup_portbdatain_portbclk_noedge_posedge  : VitalDelayArrayType  (15 downto 0) := (OTHERS => DefSetupHoldCnst);
            thold_portadatain_portaclk_noedge_posedge   : VitalDelayArrayType  (63 downto 0) := (OTHERS => DefSetupHoldCnst);
            thold_portbdatain_portbclk_noedge_posedge   : VitalDelayArrayType  (15 downto 0) := (OTHERS => DefSetupHoldCnst));

  PORT (
         portaclk     : in  std_logic                     := '0';
         portaena     : in  std_logic                     := '0';
         portawe      : in  std_logic                     := '0';
         portaaddr    : in  std_logic_vector(addrwidth-1 downto 0) := (others => '0');
         portadatain  : in  std_logic_vector(width-1 downto 0) := (others => '0');
         portadataout : out std_logic_vector(width-1 downto 0) ;
         portbclk     : in  std_logic                     := '0';
         portbena     : in  std_logic                     := '0';
         portbwe      : in  std_logic                     := '0';
         portbaddr    : in  std_logic_vector(addrwidth-1 downto 0) := (others => '0');
         portbdatain  : in  std_logic_vector(width-1 downto 0) := (others => '0');
         portbdataout : out std_logic_vector(width-1 downto 0));
--  attribute VITAL_LEVEL0 of apex20ke_dpram : ENTITY is TRUE;

end apex20ke_dpram;


ARCHITECTURE vital_dpram_atom of apex20ke_dpram is

	--
	-- Hex Read procedure.
	--
	procedure local_Char2QuadBits(C: Character; 
				RESULT: out Bit_Vector(3 downto 0);
				GOOD: out Boolean;
				ISSUE_ERROR: in Boolean) is
	begin
		case c is
			when '0' => result :=  x"0"; good := TRUE;
			when '1' => result :=  x"1"; good := TRUE;
			when '2' => result :=  x"2"; good := TRUE;
			when '3' => result :=  x"3"; good := TRUE;
			when '4' => result :=  x"4"; good := TRUE;
			when '5' => result :=  x"5"; good := TRUE;
			when '6' => result :=  x"6"; good := TRUE;
			when '7' => result :=  x"7"; good := TRUE;
			when '8' => result :=  x"8"; good := TRUE;
			when '9' => result :=  x"9"; good := TRUE;
			when 'A' => result :=  x"A"; good := TRUE;
			when 'B' => result :=  x"B"; good := TRUE;
			when 'C' => result :=  x"C"; good := TRUE;
			when 'D' => result :=  x"D"; good := TRUE;
			when 'E' => result :=  x"E"; good := TRUE;
			when 'F' => result :=  x"F"; good := TRUE;
 
			when 'a' => result :=  x"A"; good := TRUE;
			when 'b' => result :=  x"B"; good := TRUE;
			when 'c' => result :=  x"C"; good := TRUE;
			when 'd' => result :=  x"D"; good := TRUE;
			when 'e' => result :=  x"E"; good := TRUE;
			when 'f' => result :=  x"F"; good := TRUE;
			when others =>
			   if ISSUE_ERROR then 
				   assert FALSE report
					"HREAD Error: Read a '" & c &
					   "', expected a Hex character (0-F).";
			   end if;
			   good := FALSE;
		end case;
	end;

	procedure HREAD_BV(L:inout LINE; VALUE:out BIT_VECTOR)  is
		variable ok: boolean;
		variable c:  character;
		constant ne: integer := value'length/4;
		variable bv: bit_vector(0 to value'length-1);
		variable s:  string(1 to ne-1);
	begin
		if value'length mod 4 /= 0 then
			assert FALSE report 
				"HREAD_BV Error: Trying to read vector " &
				   "with an odd (non multiple of 4) length";
			return;
		end if;

		loop					-- skip white space
			read(l,c);
			exit when ((c /= ' ') and (c /= CR) and (c /= HT));
		end loop;

		local_Char2QuadBits(c, bv(0 to 3), ok, TRUE);
		if not ok then 
			return;
		end if;

		read(L, s, ok);
		if not ok then
			assert FALSE 
				report "HREAD_bv Error: Failed to read the STRING";
			return;
		end if;

		for i in 1 to ne-1 loop
			local_Char2QuadBits(s(i), bv(4*i to 4*i+3), ok, TRUE);
			if not ok then
				return;
			end if;
		end loop;
		value := bv;
	end HREAD_bv; 


--attribute VITAL_LEVEL0 of vital_dpram_atom : ARCHITECTURE is TRUE;

type dpram_memory is array (depth-1 downto 0) of std_logic_vector(width-1 downto 0) ;

        -------------------------
        function dpram_loadmem return dpram_memory is
            variable result           : dpram_memory := (others=>(others=>'X'));
    FILE memory_file: TEXT;
            variable data_line        : LINE                             ;
            variable memory_bitvector : bit_vector (width-1 downto 0)    ; 
            variable line_counter     : INTEGER := 0                     ; 

        begin
            read_memory : 
   FILE_OPEN(memory_file, ramcontent, READ_MODE);
            while not ENDFILE(memory_file)
            loop
                if ( line_counter <= depth-1 ) 
                then 
                    READLINE (memory_file, data_line) ;
                    if ( data_line'LENGTH = 0 ) then 
                        next ;
                    elsif ( data_line (1) = '/' )  then 
                        next ;
                    end if ;
                    HREAD_bv (data_line , memory_bitvector ) ;
                    result (line_counter) := To_StdLogicVector (memory_bitvector) ;
                    line_counter := line_counter + 1 ; 
                end if ; 
            end loop ; 
   FILE_CLOSE(memory_file);

            return result;
        end dpram_loadmem;
        -------------------------

        -------------------------
        function dpram_checkmem return dpram_memory is
            variable result : dpram_memory := (others=>(others=>'X'));
        begin

            if (ramcontent /= "NONE" and ramcontent /= "none") 
            then 
                result := dpram_loadmem ;
            end if ;

            return result;

        end dpram_checkmem;
        -------------------------



signal portadataout_reg     : std_logic_vector(width-1 downto 0);
signal portbdataout_reg     : std_logic_vector(width-1 downto 0);
signal portadataout_reg_out : std_logic_vector(width-1 downto 0);
signal portbdataout_reg_out : std_logic_vector(width-1 downto 0);
signal portadataout_unreg   : std_logic_vector(width-1 downto 0);
signal portbdataout_unreg   : std_logic_vector(width-1 downto 0);


signal portaclk_ipd         : std_logic;
signal portbclk_ipd         : std_logic;
signal portawe_ipd          : std_logic;
signal portbwe_ipd          : std_logic;
signal portaena_ipd         : std_logic;
signal portbena_ipd         : std_logic;
signal portadatain_ipd      : std_logic_vector(width-1 downto 0);
signal portbdatain_ipd      : std_logic_vector(width-1 downto 0);
signal portaaddr_ipd        : std_logic_vector(addrwidth-1 downto 0);
signal portbaddr_ipd        : std_logic_vector(addrwidth-1 downto 0);

signal portadataout_tmp     : std_logic_vector(width-1 downto 0);
signal portbdataout_tmp     : std_logic_vector(width-1 downto 0);

COMPONENT output_delay
  GENERIC (
    tpd_clk_out_posedge : VitalDelayType01;
    XOn                 : Boolean := DefGlitchXOn;
    MsgOn               : Boolean := DefGlitchMsgOn);
 PORT (
    clk    : in  std_logic;
    input  : in  std_logic;
    output : out std_logic);
  
END COMPONENT;

begin

	----------------------
	--  INPUT PATH DELAYs
	----------------------
  WireDelay : block
  begin
    VitalWireDelay (portaclk_ipd, portaclk, tipd_portaclk);
    VitalWireDelay (portbclk_ipd, portbclk, tipd_portbclk);
    VitalWireDelay (portawe_ipd,  portawe,  tipd_portawe );
    VitalWireDelay (portbwe_ipd,  portbwe,  tipd_portbwe );
    VitalWireDelay (portaena_ipd, portaena, tipd_portaena);
    VitalWireDelay (portbena_ipd, portbena, tipd_portbena);
    
    G1: for I in 0 to (width-1) generate
      VitalWireDelay (portadatain_ipd(I), portadatain(I), tipd_portadatain(I));
      portadoutdelay: output_delay generic map ( tpd_clk_out_posedge => tpd_portaclk_portadataout_posedge(0))
        port map (
          input  => portadataout_tmp(I),
          output => portadataout(I),
          clk    => portaclk_ipd);
      DP: if (operation_mode = "dual_port" or operation_mode = "DUAL_PORT") generate
        VitalWireDelay (portbdatain_ipd(I), portbdatain(I), tipd_portbdatain(I));
        portbdoutdelay: output_delay generic map ( tpd_clk_out_posedge => tpd_portbclk_portbdataout_posedge(0))
          port map (
            input  => portbdataout_tmp(I),
            output => portbdataout(I),
            clk    => portbclk_ipd);        
      end generate DP;
    end generate;

    
    G2: for I in 0 to (addrwidth-1) generate
      VitalWireDelay (portaaddr_ipd(I), portaaddr(I), tipd_portaaddr(I));
    end generate;
        
    G3: for I in 0 to (addrwidth-1) generate
      DP: if (operation_mode = "dual_port") generate
       VitalWireDelay (portbaddr_ipd(I), portbaddr(I), tipd_portbaddr(I));
      end generate DP;
    end generate;

end block;


CLOCK: process(portaclk_ipd, portbclk_ipd)
  variable dpram_content                    : dpram_memory        := dpram_checkmem ;
  variable Tviol_portadatain_portaclk       : std_ulogic          := '0';
  variable TimingData_portadatain_portaclk  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_portadataout_portaclk      : std_ulogic          := '0';
  variable TimingData_portadataout_portaclk : VitalTimingDataType := VitalTimingDataInit;

  variable Tviol_portbdatain_portbclk       : std_ulogic          := '0';
  variable TimingData_portbdatain_portbclk  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_portbdataout_portbclk      : std_ulogic          := '0';
  variable TimingData_portbdataout_portbclk : VitalTimingDataType := VitalTimingDataInit;

  variable portawe_latched : std_ulogic;
  variable portbwe_latched : std_ulogic;

  variable address_A       : integer;
  variable address_B       : integer;
  variable valid_addr_A    : boolean:=FALSE;
  variable valid_addr_B    : boolean:=FALSE;

begin

--  Dual Port Contention  Port A address = Port B address
--
--  +-----------+----------+-------------+-------------+--------------+--------------+---------------------+
--  |  Port A   |  Port B  |  A Data In  |  B Data In  |  A Data Out  |  B Data Out  |     Memory State    |
--  +-----------+----------+-------------+-------------+--------------+--------------+---------------------+
--  |   read    |   read   |     DA      |     DB      |    memory    |    memory    |      no change      |
--  +-----------+----------+-------------+-------------+--------------+--------------+---------------------+
--  |   write   |   read   |     DA      |     DB      |    unknown   |    unknown   |    memory <= DA     |
--  +-----------+----------+-------------+-------------+--------------+--------------+---------------------+
--  |   read    |   write  |     DA      |     DB      |    unknown   |    unknown   |    memory <= DB     |
--  +-----------+----------+-------------+-------------+--------------+--------------+---------------------+
--  |   write   |   write  |     DA      |     DB      |    unknown   |    unknown   |  memory <= unknown  |
--  +-----------+----------+-------------+-------------+--------------+--------------+---------------------+
--
--  Dual Port Contention  Port A address != Port B address
--
--  +-----------+----------+-------------+-------------+--------------+--------------+---------------------+
--  |  Port A   |  Port B  |  A Data In  |  B Data In  |  A Data Out  |  B Data Out  |     Memory State    |
--  +-----------+----------+-------------+-------------+--------------+--------------+---------------------+
--  |   read    |   read   |     DA      |     DB      |  mem[A_addr] |  mem[B_Addr] |      no change      |
--  +-----------+----------+-------------+-------------+--------------+--------------+---------------------+
--  |   write   |   read   |     DA      |     DB      |    unknown   |  mem[B_Addr] |  mem[A_Addr] <= DA  |
--  +-----------+----------+-------------+-------------+--------------+--------------+---------------------+
--  |   read    |   write  |     DA      |     DB      |  mem[A_addr] |    unknown   |  mem[B_Addr] <= DB  |
--  +-----------+----------+-------------+-------------+--------------+--------------+---------------------+
--  |   write   |   write  |     DA      |     DB      |    unknown   |    unknown   |  mem[A_Addr] <= DA  |
--  |           |          |             |             |              |              |  mem[B_Addr] <= DB  |
--  +-----------+----------+-------------+-------------+--------------+--------------+---------------------+
-- 
-- NB: output is always unknown when writing



  if(portaclk_ipd'event and portaclk_ipd='1') then  -- rising edge port a clock

    VitalSetupHoldCheck (
      Violation       => Tviol_portadatain_portaclk,
      TimingData      => TimingData_portadatain_portaclk,
      TestSignal      => portadatain_ipd,
      TestSignalName  => "PORTADATAIN",
      RefSignal       => portaclk_ipd,
      RefSignalName   => "PORTACLK",
      SetupHigh       => tsetup_portadatain_portaclk_noedge_posedge(0),
      SetupLow        => tsetup_portadatain_portaclk_noedge_posedge(0),
      HoldHigh        => thold_portadatain_portaclk_noedge_posedge(0),
      HoldLow         => thold_portadatain_portaclk_noedge_posedge(0),
      RefTransition   => '/',
      HeaderMsg       => InstancePath & "/APEX20k_ASYNCH_MEM",
      XOn             => XOnChecks,
      MsgOn           => MsgOnChecks );

    VitalSetupHoldCheck (
      Violation       => Tviol_portadataout_portaclk,
      TimingData      => TimingData_portadataout_portaclk,
      TestSignal      => portadataout_unreg,
      TestSignalName  => "PORTADATAOUT",
      RefSignal       => portaclk_ipd,
      RefSignalName   => "PORTACLK",
      SetupHigh       => tsetup_portadataout_portaclk_noedge_posedge(0),
      SetupLow        => tsetup_portadataout_portaclk_noedge_posedge(0),
      RefTransition   => '/',
      HeaderMsg       => InstancePath & "/APEX20k_ASYNCH_MEM",
      XOn             => XOnChecks,
      MsgOn           => MsgOnChecks );

  
    portawe_latched := portawe_ipd;

    valid_addr_A := not Is_X(portaaddr_ipd(addrwidth-1 downto 0));

    if ( valid_addr_A ) then 

      address_A       := conv_integer(portaaddr_ipd);

         if portawe_latched ='0' 
         then
	     -- reading from A
             if valid_addr_B and address_A = address_B and portbwe_latched = '1' 
             then
                 -- B simultaneously writing to same address (effect of B write to memory handled below)
                 portadataout_reg         <= portadataout_unreg;
                 portadataout_unreg       <= (others => 'X')   ;
             else
                 -- B reading from same address, or reading/writing to different address. 
                 portadataout_reg   <= portadataout_unreg      ;
                 portadataout_unreg <= dpram_content(address_A);
             end if;
         else
             -- writing to A
             if valid_addr_B and address_A = address_B and portawe_latched = '1' and portbwe_latched = '1' 
             then
                 -- A and B simultaneously writing to same address
                 portadataout_reg         <= portadataout_unreg;
                 dpram_content(address_A) := (others => 'X')   ;
                 portadataout_unreg       <= (others => 'X')   ;
             else
                 -- B reading from same address or reading/writing to different address
                 portadataout_reg         <= portadataout_unreg;
                 dpram_content(address_A) := portadatain_ipd   ;
                 portadataout_unreg       <= (others => 'X')   ;
             end if;
         end if;

    else 
        portadataout_reg    <= portadataout_unreg;
        address_A                             := 0 ; 
        portadataout_unreg  <= (others => 'X')   ;
    end if ; 

  end if ; 
    
  if (portbclk_ipd'event and portbclk_ipd = '1') then  -- rising edge port b clock
    VitalSetupHoldCheck (
      Violation      => Tviol_portbdatain_portbclk,
      TimingData     => TimingData_portbdatain_portbclk,
      TestSignal     => portbdatain_ipd,
      TestSignalName => "PORTBDATAIN",
      RefSignal      => portbclk_ipd,
      RefSignalName  => "PORTBCLK",
      SetupHigh      => tsetup_portbdatain_portbclk_noedge_posedge(0),
      SetupLow       => tsetup_portbdatain_portbclk_noedge_posedge(0),
      HoldHigh       => thold_portbdatain_portbclk_noedge_posedge(0),
      HoldLow        => thold_portbdatain_portbclk_noedge_posedge(0),
      RefTransition  => '/',
      HeaderMsg      => InstancePath & "/APEX20k_ASYNCH_MEM",
      XOn            => XOnChecks,
      MsgOn          => MsgOnChecks );

    VitalSetupHoldCheck (
      Violation      => Tviol_portbdataout_portbclk,
      TimingData     => TimingData_portbdataout_portbclk,
      TestSignal     => portbdataout_unreg,
      TestSignalName => "PORTBDATAOUT",
      RefSignal      => portbclk_ipd,
      RefSignalName  => "PORTBCLK",
      SetupHigh      => tsetup_portbdataout_portbclk_noedge_posedge(0),
      SetupLow       => tsetup_portbdataout_portbclk_noedge_posedge(0),
      RefTransition  => '/',
      HeaderMsg      => InstancePath & "/APEX20k_ASYNCH_MEM",
      XOn            => XOnChecks,
      MsgOn          => MsgOnChecks );


      portbwe_latched := portbwe_ipd;

      valid_addr_B := not Is_X(portbaddr_ipd(addrwidth-1 downto 0));

      if ( valid_addr_B ) then 

       address_B := conv_integer(portbaddr_ipd);
 
         if portbwe_latched ='0' 
         then
	     -- reading from B
             if valid_addr_A and address_B = address_A and portawe_latched = '1' 
             then
                 -- A simultaneously writing to same address (effect of A write to memory handled above)
                 portbdataout_reg         <= portbdataout_unreg;
                 portbdataout_unreg       <= (others => 'X')   ;
             else
                 -- A reading from same address, or reading/writing to different address. 
                 portbdataout_reg   <= portbdataout_unreg      ;
                 portbdataout_unreg <= dpram_content(address_B);
             end if;
         else
             -- writing to B
             if valid_addr_A and address_B = address_A and portbwe_latched = '1' and portawe_latched = '1' 
             then
                 -- B and A simultaneously writing to same address
                 portbdataout_reg         <= portbdataout_unreg;
                 dpram_content(address_B) := (others => 'X')   ;
                 portbdataout_unreg       <= (others => 'X')   ;
             else
                 -- A reading from same address or reading/writing to different address
                 portbdataout_reg         <= portbdataout_unreg;
                 dpram_content(address_B) := portbdatain_ipd   ;
                 portbdataout_unreg       <= (others => 'X')   ;
             end if;
         end if;

      else 
        portbdataout_reg   <= portbdataout_unreg;
        address_B                             := 0 ; 
        portbdataout_unreg <= (others => 'X')   ;
       end if ; 

     end if;
  end process CLOCK;



  OUTPUT_ENABLE_A : process(portaena_ipd, portadataout_reg)
  begin
      if((output_mode = "REG" or output_mode = "reg") and portaena_ipd = '1') then
          portadataout_reg_out <= portadataout_reg ;  
      end if;
  end process OUTPUT_ENABLE_A;

  OUTPUT_ENABLE_B : process(portbena_ipd, portbdataout_reg)
  begin
      if((output_mode = "REG" or output_mode = "reg") and portbena_ipd = '1') then
          portbdataout_reg_out <= portbdataout_reg ;  
      end if;
  end process OUTPUT_ENABLE_B;




  REG_UNREG_SEL_A : process(portadataout_reg_out, portadataout_unreg)
  begin
  if(output_mode = "UNREG" or output_mode = "unreg") then
    portadataout_tmp <= portadataout_unreg;
      else
    portadataout_tmp <= portadataout_reg_out;
      end if;
  end process REG_UNREG_SEL_A;

  REG_UNREG_SEL_B : process(portbdataout_reg_out, portbdataout_unreg)
  begin
  if(output_mode = "UNREG" or output_mode = "unreg") then
    portbdataout_tmp <= portbdataout_unreg;
      else
    portbdataout_tmp <= portbdataout_reg_out;
      end if;
  end process REG_UNREG_SEL_B;

end vital_dpram_atom;


--
-- Excalibur UPCORE atom.
--

LIBRARY apex20ke;
use apex20ke.all;


LIBRARY IEEE, apex20ke;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_textio.all;
use IEEE.std_logic_unsigned.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use apex20ke.atom_pack.all;
use std.textio.all;


ENTITY apex20ke_upcore is
  GENERIC (
            processor      : string := "arm"           ;
            source         : string := ""              ;
            sdram_width    : integer := 32             ;
            sdramdqm_width : integer := 4              ;
            gpio_width     : integer := 4              ;
            MsgOn          : Boolean := DefGlitchMsgOn ;
            XOn            : Boolean := DefGlitchXOn   ;
            MsgOnChecks    : Boolean := DefMsgOnChecks ;
            XOnChecks      : Boolean := DefXOnChecks   ;
            InstancePath   : String  := "*"            ;

    tipd_clkref         : VitalDelayType01                    := DefPropDelay01;
    tipd_npor           : VitalDelayType01                    := DefPropDelay01;
    tipd_nreseti        : VitalDelayType01                    := DefPropDelay01;
    tipd_intpld         : VitalDelayArrayType01 ( 5 downto 0) := (others => DefPropDelay01);
    tipd_intnmi         : VitalDelayType01                    := DefPropDelay01;
    tipd_debugrq        : VitalDelayType01                    := DefPropDelay01;
    tipd_debugext0      : VitalDelayType01                    := DefPropDelay01;
    tipd_debugext1      : VitalDelayType01                    := DefPropDelay01;
    tipd_debugiebrkpt   : VitalDelayType01                    := DefPropDelay01;
    tipd_debugdewpt     : VitalDelayType01                    := DefPropDelay01;
    tipd_debugextin     : VitalDelayArrayType01 ( 3 downto 0) := (others => DefPropDelay01);
    tipd_slavehclk      : VitalDelayType01                    := DefPropDelay01;
    tipd_slavehwrite    : VitalDelayType01                    := DefPropDelay01;
    tipd_slavehreadyi   : VitalDelayType01                    := DefPropDelay01;
    tipd_slavehselreg   : VitalDelayType01                    := DefPropDelay01;
    tipd_slavehsel      : VitalDelayType01                    := DefPropDelay01;
    tipd_slavehmastlock : VitalDelayType01                    := DefPropDelay01;
    tipd_slavehaddr     : VitalDelayArrayType01 (31 downto 0) := (others => DefPropDelay01);
    tipd_slavehwdata    : VitalDelayArrayType01 (31 downto 0) := (others => DefPropDelay01);
    tipd_slavehtrans    : VitalDelayArrayType01 ( 1 downto 0) := (others => DefPropDelay01);
    tipd_slavehsize     : VitalDelayArrayType01 ( 1 downto 0) := (others => DefPropDelay01);
    tipd_slavehburst    : VitalDelayArrayType01 ( 2 downto 0) := (others => DefPropDelay01);
    tipd_masterhclk     : VitalDelayType01                    := DefPropDelay01;
    tipd_masterhrdata   : VitalDelayArrayType01 (31 downto 0) := (others => DefPropDelay01);
    tipd_masterhresp    : VitalDelayArrayType01 ( 1 downto 0) := (others => DefPropDelay01);
    tipd_masterhready   : VitalDelayType01                    := DefPropDelay01;
    tipd_masterhgrant   : VitalDelayType01                    := DefPropDelay01;
    tipd_lockreqdp0     : VitalDelayType01                    := DefPropDelay01;
    tipd_lockreqdp1     : VitalDelayType01                    := DefPropDelay01;
    tipd_ebiack         : VitalDelayType01                    := DefPropDelay01;
    tipd_ebidqin        : VitalDelayArrayType01 (15 downto 0) := (others => DefPropDelay01);
    tipd_uartctsn       : VitalDelayType01                    := DefPropDelay01;
    tipd_uartdsrn       : VitalDelayType01                    := DefPropDelay01;
    tipd_uartrxd        : VitalDelayType01                    := DefPropDelay01;
    tipd_uartdcdin      : VitalDelayType01                    := DefPropDelay01;
    tipd_uartriin       : VitalDelayType01                    := DefPropDelay01;
    tipd_sdramdqin      : VitalDelayArrayType01 (31 downto 0) := (others => DefPropDelay01);
    tipd_sdramdqsin     : VitalDelayArrayType01 ( 3 downto 0) := (others => DefPropDelay01);
    tipd_intextpin      : VitalDelayType01                    := DefPropDelay01;
    tipd_gpi            : VitalDelayArrayType01 ( 5 downto 0) := (others => DefPropDelay01);

    tpd_slavehclk_slavehreadyo_posedge   : VitalDelayType01                   := DefPropDelay01;
    tpd_slavehclk_slavebuserrint_posedge : VitalDelayType01                   := DefPropDelay01;
    tpd_slavehclk_slavehrdata_posedge    : VitalDelayArrayType01(31 downto 0) := (others => DefPropDelay01);
    tpd_slavehclk_slavehresp_posedge     : VitalDelayArrayType01(1 downto 0)  := (others => DefPropDelay01);
    tpd_masterhclk_masterhlock_posedge   : VitalDelayType01                   := DefPropDelay01;
    tpd_masterhclk_masterhwrite_posedge  : VitalDelayType01                   := DefPropDelay01;
    tpd_masterhclk_masterhbusreq_posedge : VitalDelayType01                   := DefPropDelay01;
    tpd_masterhclk_masterhaddr_posedge   : VitalDelayArrayType01(31 downto 0) := (others => DefPropDelay01);
    tpd_masterhclk_masterhwdata_posedge  : VitalDelayArrayType01(31 downto 0) := (others => DefPropDelay01);
    tpd_masterhclk_masterhtrans_posedge  : VitalDelayArrayType01(1 downto 0)  := (others => DefPropDelay01);
    tpd_masterhclk_masterhsize_posedge   : VitalDelayArrayType01(1 downto 0)  := (others => DefPropDelay01);
    tpd_masterhclk_masterhburst_posedge  : VitalDelayArrayType01(2 downto 0)  := (others => DefPropDelay01);
    tsetup_masterhgrant_masterhclk       : VitalDelayType                     := DefSetupHoldCnst;
    tsetup_masterhrdata_masterhclk       : VitalDelayArrayType(31 downto 0)   := (others => DefSetupHoldCnst);
    tsetup_masterhready_masterhclk       : VitalDelayType                     := DefSetupHoldCnst;
    tsetup_masterhresp_masterhclk        : VitalDelayArrayType(1 downto 0)    := (others => DefSetupHoldCnst);
    tsetup_slavehaddr_slavehclk          : VitalDelayArrayType(31 downto 0)   := (others => DefSetupHoldCnst);
    tsetup_slavehburst_slavehclk         : VitalDelayArrayType(2 downto 0)    := (others => DefSetupHoldCnst);
    tsetup_slavehreadyi_slavehclk        : VitalDelayType                     := DefSetupHoldCnst;
    tsetup_slavehsel_slavehclk           : VitalDelayType                     := DefSetupHoldCnst;
    tsetup_slavehselreg_slavehclk        : VitalDelayType                     := DefSetupHoldCnst;
    tsetup_slavehsize_slavehclk          : VitalDelayArrayType(1 downto 0)    := (others => DefSetupHoldCnst);
    tsetup_slavehtrans_slavehclk         : VitalDelayArrayType(1 downto 0)    := (others => DefSetupHoldCnst);
    tsetup_slavehwdata_slavehclk         : VitalDelayArrayType(31 downto 0)   := (others => DefSetupHoldCnst);
    tsetup_slavehwrite_slavehclk         : VitalDelayType                     := DefSetupHoldCnst;
    tsetup_debugiebrkpt_masterhclk       : VitalDelayType                     := DefSetupHoldCnst;
    tsetup_debugdewpt_masterhclk         : VitalDelayType                     := DefSetupHoldCnst;
    tsetup_slavehmastlock_masterhclk     : VitalDelayType                     := DefSetupHoldCnst;
    thold_masterhgrant_masterhclk        : VitalDelayType                     := DefSetupHoldCnst;
    thold_masterhrdata_masterhclk        : VitalDelayArrayType(31 downto 0)   := (others => DefSetupHoldCnst);
    thold_masterhready_masterhclk        : VitalDelayType                     := DefSetupHoldCnst;
    thold_masterhresp_masterhclk         : VitalDelayArrayType(1 downto 0)    := (others => DefSetupHoldCnst);
    thold_slavehaddr_slavehclk           : VitalDelayArrayType(31 downto 0)   := (others => DefSetupHoldCnst);
    thold_slavehburst_slavehclk          : VitalDelayArrayType(2 downto 0)    := (others => DefSetupHoldCnst);
    thold_slavehreadyi_slavehclk         : VitalDelayType                     := DefSetupHoldCnst;
    thold_slavehsel_slavehclk            : VitalDelayType                     := DefSetupHoldCnst;
    thold_slavehselreg_slavehclk         : VitalDelayType                     := DefSetupHoldCnst;
    thold_slavehsize_slavehclk           : VitalDelayArrayType(1 downto 0)    := (others => DefSetupHoldCnst);
    thold_slavehtrans_slavehclk          : VitalDelayArrayType(1 downto 0)    := (others => DefSetupHoldCnst);
    thold_slavehwdata_slavehclk          : VitalDelayArrayType(31 downto 0)   := (others => DefSetupHoldCnst);
    thold_slavehwrite_slavehclk          : VitalDelayType                     := DefSetupHoldCnst;
    thold_debugiebrkpt_masterhclk        : VitalDelayType                     := DefSetupHoldCnst;
    thold_debugdewpt_masterhclk          : VitalDelayType                     := DefSetupHoldCnst;
    thold_slavehmastlock_masterhclk      : VitalDelayType                     := DefSetupHoldCnst );

  PORT (
            clkref         : in  std_logic                      ;
            npor           : in  std_logic                      ;
            nreseti        : in  std_logic                      ;
            nreseto        : out std_logic                      ;
            nresetoe       : out std_logic                      ;

            intpld         : in  std_logic_vector ( 5 downto 0) := (others => '0');
            intnmi         : in  std_logic                      := '0';
            perreset       : out std_logic                      ;
            intuart        : out std_logic                      ;
            inttimer0      : out std_logic                      ;
            inttimer1      : out std_logic                      ;
            intproc0       : out std_logic                      ;
            intproc1       : out std_logic                      ;

            debugrq        : in  std_logic                      := '0';
            debugext0      : in  std_logic                      := '0';
            debugext1      : in  std_logic                      := '0';
            debugiebrkpt   : in  std_logic                      := '0';
            debugdewpt     : in  std_logic                      := '0';
            debugextin     : in  std_logic_vector ( 3 downto 0) := (others => '0');    
            debugack       : out std_logic                      ;
            debugrng0      : out std_logic                      ;
            debugrng1      : out std_logic                      ;
            debugextout    : out std_logic_vector ( 3 downto 0) ;    

            slavehclk      : in  std_logic                      := '0';
            slavehwrite    : in  std_logic                      := '0';
            slavehreadyi   : in  std_logic                      := '0';
            slavehselreg   : in  std_logic                      := '0';
            slavehsel      : in  std_logic                      := '0';
            slavehmastlock : in  std_logic                      := '0';
            slavehaddr     : in  std_logic_vector (31 downto 0) := (others => '0');
            slavehwdata    : in  std_logic_vector (31 downto 0) := (others => '0');
            slavehtrans    : in  std_logic_vector ( 1 downto 0) := (others => '0');
            slavehsize     : in  std_logic_vector ( 1 downto 0) := (others => '0');
            slavehburst    : in  std_logic_vector ( 2 downto 0) := (others => '0');
            slavehreadyo   : out std_logic                      ;
            slavebuserrint : out std_logic                      ;
            slavehrdata    : out std_logic_vector (31 downto 0) ;
            slavehresp     : out std_logic_vector ( 1 downto 0) ;

            masterhclk     : in  std_logic                      := '0';
            masterhrdata   : in  std_logic_vector (31 downto 0) := (others => '0');
            masterhresp    : in  std_logic_vector ( 1 downto 0) := (others => '0');
            masterhwrite   : out std_logic                      ;
            masterhlock    : out std_logic                      ;
            masterhbusreq  : out std_logic                      ;
            masterhaddr    : out std_logic_vector (31 downto 0) ;
            masterhwdata   : out std_logic_vector (31 downto 0) ;
            masterhtrans   : out std_logic_vector ( 1 downto 0) ;
            masterhsize    : out std_logic_vector ( 1 downto 0) ;
            masterhready   : in  std_logic                      := '0';
            masterhburst   : out std_logic_vector ( 2 downto 0) ;
            masterhgrant   : in  std_logic                      := '0';

            lockreqdp0     : in  std_logic                      := '0';
            lockreqdp1     : in  std_logic                      := '0';
            lockgrantdp0   : out std_logic                      ;
            lockgrantdp1   : out std_logic                      ;

            ebiack         : in  std_logic                      := '0';
            ebiwen         : out std_logic                      ;
            ebioen         : out std_logic                      ;
            ebiclk         : out std_logic                      ;
            ebibe          : out std_logic_vector ( 1 downto 0) ;
            ebicsn         : out std_logic_vector ( 3 downto 0) ;
            ebiaddr        : out std_logic_vector (24 downto 0) ;
            ebidqoe        : out std_logic                      ;
            ebidqout       : out std_logic_vector (15 downto 0) ;
            ebidqin        : in  std_logic_vector (15 downto 0) := (others => '0');

            uarttxd        : out std_logic                      ;
            uartrtsn       : out std_logic                      ;
            uartdtrn       : out std_logic                      ;
            uartctsn       : in  std_logic                      := '0';
            uartdsrn       : in  std_logic                      := '0';
            uartrxd        : in  std_logic                      := '0';
            uartdcdon      : out std_logic                      ;
            uartdcdin      : in  std_logic                      := '0';
            uartriin       : in  std_logic                      := '0';
            uartrion       : out std_logic                      ;
            uartdcdrioe    : out std_logic                      ;

              
            sdramclk       : out std_logic                      ;
            sdramclkn      : out std_logic                      ;
            sdramclke      : out std_logic                      ;
            sdramwen       : out std_logic                      ;
            sdramcasn      : out std_logic                      ;
            sdramrasn      : out std_logic                      ;
            sdramdqm       : out std_logic_vector (sdramdqm_width-1 downto 0) ;
            sdramaddr      : out std_logic_vector (14 downto 0) ;
            sdramdqoe      : out std_logic_vector (sdramdqm_width-1 downto 0) ;
            sdramdqout     : out std_logic_vector (sdram_width-1 downto 0) ;
            sdramdqin      : in  std_logic_vector (sdram_width-1 downto 0) := (others => '0');
            sdramdqsoe     : out std_logic                      ;
            sdramcsn       : out std_logic_vector ( 1 downto 0) ;
            sdramdqsout    : out std_logic_vector (sdramdqm_width-1 downto 0) ;
            sdramdqsin     : in  std_logic_vector (sdramdqm_width-1 downto 0) := (others => '0');

            intextpin      : in  std_logic                      := '0';
            traceclk       : out std_logic                      ;
            tracesync      : out std_logic                      ;
            tracepipestat  : out std_logic_vector ( 2 downto 0) ;
            tracepkt       : out std_logic_vector (15 downto 0) ;

            gpi            : in  std_logic_vector (gpio_width-1 downto 0) := (others =>'0');
            gpo            : out std_logic_vector (gpio_width-1 downto 0) );


--  attribute VITAL_LEVEL0 of apex20ke_upcore : ENTITY is TRUE;


end apex20ke_upcore;


ARCHITECTURE vital_upcore_atom of apex20ke_upcore is

--attribute VITAL_LEVEL0 of vital_upcore_atom : ARCHITECTURE is TRUE;

	--/////////////////////////////////////////////////////////////////////////////////////////////////
	--// 
	--/////////////////////////////////////////////////////////////////////////////////////////////////


	--
	-- Hex Read and Write procedures.
	--
	procedure local_Char2QuadBits(C: Character; 
				RESULT: out Bit_Vector(3 downto 0);
				GOOD: out Boolean;
				ISSUE_ERROR: in Boolean) is
	begin
		case c is
			when '0' => result :=  x"0"; good := TRUE;
			when '1' => result :=  x"1"; good := TRUE;
			when '2' => result :=  x"2"; good := TRUE;
			when '3' => result :=  x"3"; good := TRUE;
			when '4' => result :=  x"4"; good := TRUE;
			when '5' => result :=  x"5"; good := TRUE;
			when '6' => result :=  x"6"; good := TRUE;
			when '7' => result :=  x"7"; good := TRUE;
			when '8' => result :=  x"8"; good := TRUE;
			when '9' => result :=  x"9"; good := TRUE;
			when 'A' => result :=  x"A"; good := TRUE;
			when 'B' => result :=  x"B"; good := TRUE;
			when 'C' => result :=  x"C"; good := TRUE;
			when 'D' => result :=  x"D"; good := TRUE;
			when 'E' => result :=  x"E"; good := TRUE;
			when 'F' => result :=  x"F"; good := TRUE;
 
			when 'a' => result :=  x"A"; good := TRUE;
			when 'b' => result :=  x"B"; good := TRUE;
			when 'c' => result :=  x"C"; good := TRUE;
			when 'd' => result :=  x"D"; good := TRUE;
			when 'e' => result :=  x"E"; good := TRUE;
			when 'f' => result :=  x"F"; good := TRUE;
			when others =>
			   if ISSUE_ERROR then 
				   assert FALSE report
					"HREAD Error: Read a '" & c &
					   "', expected a Hex character (0-F).";
			   end if;
			   good := FALSE;
		end case;
	end;

	procedure HREAD_BV(L:inout LINE; VALUE:out BIT_VECTOR)  is
		variable ok: boolean;
		variable c:  character;
		constant ne: integer := value'length/4;
		variable bv: bit_vector(0 to value'length-1);
		variable s:  string(1 to ne-1);
	begin
		if value'length mod 4 /= 0 then
			assert FALSE report 
				"HREAD_BV Error: Trying to read vector " &
				   "with an odd (non multiple of 4) length";
			return;
		end if;

		loop					-- skip white space
			read(l,c);
			exit when ((c /= ' ') and (c /= CR) and (c /= HT));
		end loop;

		local_Char2QuadBits(c, bv(0 to 3), ok, TRUE);
		if not ok then 
			return;
		end if;

		read(L, s, ok);
		if not ok then
			assert FALSE 
				report "HREAD_bv Error: Failed to read the STRING";
			return;
		end if;

		for i in 1 to ne-1 loop
			local_Char2QuadBits(s(i), bv(4*i to 4*i+3), ok, TRUE);
			if not ok then
				return;
			end if;
		end loop;
		value := bv;
	end HREAD_bv; 


     -- functions to match Verilog functions and operators

     -- Bitwise left shift
        function shift_left ( val : std_logic_vector ) return std_logic_vector is
            variable result : std_logic_vector(val'length-1 downto 0);
        begin
            result:=val;
            if (val'length>1) then
                for i in (val'length-1) downto 1 loop
                    result(i):=result(i-1);
                end loop;
            end if;
            result(0) := '0';
            return result;
        end shift_left;
        function shift_left ( val : std_logic_vector; n : integer ) return std_logic_vector is
            variable result : std_logic_vector(val'length-1 downto 0);
        begin
            result:=val;
            for i in 1 to n loop
                result:=shift_left(result);
            end loop;
            return result;
        end shift_left;
	

     -- Unary reduction OR : use ur_OR(foo) as a replacement for Verilog (|foo).
        function ur_OR (val : std_logic_vector ) return std_logic is
            variable result : std_logic ;
        begin
            if (val'length > 0) then
                result := val(val'length-1) ;
                for i in (val'length-2) downto 0 loop
                    result := (result or val(i));
                end loop;
            else
                result := '0';
            end if;
            return result;
        end ur_OR;

     -- Unary reduction XOR : use ur_XOR(foo) as a replacement for Verilog (^foo).
        function ur_XOR (val : std_logic_vector ) return std_logic is
            variable result : std_logic := '0' ;
            variable count  : integer   :=  0  ;
        begin
            if (val'length > 0) then
                for i in (val'length-1) downto 0 loop
                    if (result /= 'X') then
                        if    (val(i) = '1') then count  := count + 1 ;
                        elsif (val(i) = 'X') then result := 'X'  ;
                        end if ; 
                    end if ; 
                end loop;
            else
                result := '0';
            end if;
            if ( result = 'X') then 
                return result ;
            elsif (count > 1 ) then 
                return '0' ;
            else
                return '1' ;
            end if ;
        end ur_XOR;


     -- Components

        COMPONENT output_delay
            GENERIC (
                tpd_clk_out_posedge : VitalDelayType01          ;
                XOn                 : Boolean := DefGlitchXOn   ;
                MsgOn               : Boolean := DefGlitchMsgOn ) ;
            PORT (
                clk    : in  std_logic;
                input  : in  std_logic;
                output : out std_logic);
	  
        END COMPONENT;

        COMPONENT DFFE
            GENERIC (
                TimingChecksOn                 : Boolean          := true             ;
                InstancePath                   : STRING           := "*"              ;
                XOn                            : Boolean          := DefGlitchXOn     ;
                MsgOn                          : Boolean          := DefGlitchMsgOn   ;
                XOnChecks                      : Boolean          := DefXOnChecks     ;
                MsgOnChecks                    : Boolean          := DefMsgOnChecks   ;
                tpd_PRN_Q_negedge              : VitalDelayType01 := DefPropDelay01   ;
                tpd_CLRN_Q_negedge             : VitalDelayType01 := DefPropDelay01   ;
                tpd_CLK_Q_posedge              : VitalDelayType01 := DefPropDelay01   ;
                tpd_ENA_Q_posedge              : VitalDelayType01 := DefPropDelay01   ;
                tsetup_D_CLK_noedge_posedge    : VitalDelayType   := DefSetupHoldCnst ;
                tsetup_D_CLK_noedge_negedge    : VitalDelayType   := DefSetupHoldCnst ;
                tsetup_ENA_CLK_noedge_posedge  : VitalDelayType   := DefSetupHoldCnst ;
                thold_D_CLK_noedge_posedge     : VitalDelayType   := DefSetupHoldCnst ;
                thold_D_CLK_noedge_negedge     : VitalDelayType   := DefSetupHoldCnst ;
                thold_ENA_CLK_noedge_posedge   : VitalDelayType   := DefSetupHoldCnst ;
                tipd_D                         : VitalDelayType01 := DefPropDelay01   ;
                tipd_CLRN                      : VitalDelayType01 := DefPropDelay01   ;
                tipd_PRN                       : VitalDelayType01 := DefPropDelay01   ;
                tipd_CLK                       : VitalDelayType01 := DefPropDelay01   ;
                tipd_ENA                       : VitalDelayType01 := DefPropDelay01   );

            PORT (
                Q                              :  out   STD_LOGIC := '0';
                D                              :  in    STD_LOGIC := '1';
                CLRN                           :  in    STD_LOGIC := '1';
                PRN                            :  in    STD_LOGIC := '1';
                CLK                            :  in    STD_LOGIC := '0';
                ENA                            :  in    STD_LOGIC := '1');
        END COMPONENT;

     -- +---------------+
     -- | AHB Constants |
     -- +---------------+

     -- // number of memory banks   
        constant  NUMBANKS           : integer := 6 ;
	
     -- // respones (HRESP)
        constant  H_OKAY   : std_logic_vector(1 downto 0) := "00" ;
        constant  H_ERROR  : std_logic_vector(1 downto 0) := "01" ;
        constant  H_RETRY  : std_logic_vector(1 downto 0) := "10" ;
        constant  H_SPLIT  : std_logic_vector(1 downto 0) := "11" ;
	
     -- // transaction types (HTRANS)
        constant  H_IDLE   : std_logic_vector(1 downto 0) := "00" ;
        constant  H_BUSY   : std_logic_vector(1 downto 0) := "01" ;
        constant  H_NONSEQ : std_logic_vector(1 downto 0) := "10" ;
        constant  H_SEQ    : std_logic_vector(1 downto 0) := "11" ;
	
     -- // burst mode (HBURST)
        constant  H_SINGLE : std_logic_vector(2 downto 0) := "000";
        constant  H_INCR   : std_logic_vector(2 downto 0) := "001";
        constant  H_WRAP4  : std_logic_vector(2 downto 0) := "010";
        constant  H_INCR4  : std_logic_vector(2 downto 0) := "011";
        constant  H_WRAP8  : std_logic_vector(2 downto 0) := "100";
        constant  H_INCR8  : std_logic_vector(2 downto 0) := "101";
        constant  H_WRAP16 : std_logic_vector(2 downto 0) := "110";
        constant  H_INCR16 : std_logic_vector(2 downto 0) := "111";
	
     -- // transaction sizes (HSIZE 8,16,32 bits -- larger sizes not supported)
        constant  H_BYTE   : std_logic_vector(1 downto 0) := "00" ;
        constant  H_HWORD  : std_logic_vector(1 downto 0) := "01" ;
        constant  H_WORD   : std_logic_vector(1 downto 0) := "10" ;

     -- // maximum number of transmissions   
        constant  NUMTRANS           : integer :=   2048       ; -- was 65535, but may lead to memory allocation problems

     -- // data sub-ranges within transmission
        constant  Trns_b             : integer :=    255       ; 
        --                                           255..254  ; -- spare
        constant  Trns_RESP_b        : integer :=    253       ; -- response
        constant  Trns_RESP_l        : integer :=    252       ;
        constant  Trns_READ_b        : integer :=    251       ; -- read data
        constant  Trns_READ_l        : integer :=    220       ;
        constant  Trns_BUSY          : integer :=    219       ; -- go busy 
        --                                           218..217  ; -- spare
        constant  Trns_NUMSEQBEATS_b : integer :=    216       ; -- number of beats in sequential transaction
        constant  Trns_NUMSEQBEATS_l : integer :=    208       ;
        constant  Trns_STARTADDR_b   : integer :=    207       ; -- start address of transaction
        constant  Trns_STARTADDR_l   : integer :=    176       ; 
        constant  Trns_EXPDATA_b     : integer :=    175       ; -- expected data
        constant  Trns_EXPDATA_l     : integer :=    144       ;
        constant  Trns_TRANSNUM_b    : integer :=    143       ; -- transaction number
        constant  Trns_TRANSNUM_l    : integer :=    128       ; 
        -- ----------------------------------------------------  -- following fields read from command file
        --                                           127..112  ; -- spare
        --                                           111..109  ; -- spare
        constant  Trns_BUSCOMMD      : integer :=    108       ; -- bus command (0 => inactive)
        constant  Trns_ADDR_b        : integer :=    107       ; -- address
        constant  Trns_ADDR_l        : integer :=     76       ;
        --                                            75.. 73  ; -- spare
        constant  Trns_WRITE         : integer :=     72       ; -- write
        constant  Trns_DATA_b        : integer :=     71       ; -- write data / expected read data
        constant  Trns_DATA_l        : integer :=     40       ;
        --                                            39.. 37  ; -- spare
        constant  Trns_LOCK          : integer :=     36       ; -- lock (not implemented)
        --                                            35.. 33  ; -- spare
        constant  Trns_CHKDATA       : integer :=     32       ; -- check expected data (not implemented)
        --                                            31.. 30  ; -- spare
        constant  Trns_TRANSTYPE_b   : integer :=     29       ; -- transaction type
        constant  Trns_TRANSTYPE_l   : integer :=     28       ; 
        --                                            27.. 23  ; -- spare
        constant  Trns_BURSTTYPE_b   : integer :=     22       ; -- burst type
        constant  Trns_BURSTTYPE_l   : integer :=     20       ;
        --                                            19       ; -- spare
        constant  Trns_SIZE_b        : integer :=     18       ; -- size
        constant  Trns_SIZE_l        : integer :=     16       ;
        constant  Trns_RPTCOUNT_b    : integer :=     15       ; -- repeat count
        constant  Trns_RPTCOUNT_l    : integer :=      0       ;

     -- +------------+
     -- | slave port |
     -- +------------+

     -- record of address and control information (latched on address phase)

        signal  startReg  : std_logic_vector(31 downto 0) := ( others => '0') ; --// start address for burst
        signal   addrReg  : std_logic_vector(31 downto 0) := ( others => '0') ;
        signal 	transReg  : std_logic_vector( 1 downto 0) := H_IDLE           ;
        signal   sizeReg  : std_logic_vector( 1 downto 0) := H_WORD           ;
        signal 	writeReg  : std_logic                     := '0'              ;
        signal 	burstReg  : std_logic_vector( 2 downto 0) := H_SINGLE         ;
        signal    selReg  : std_logic                     := '0'              ;
        signal   waitReg  : std_logic_vector( 7 downto 0) := ( others => '0') ;

     -- Implement 6 banks of 256K = (1.5MB of address space)
        
        constant membank_size     : integer := 20480 ; -- full 65535 leads to memory allocation problems

        type upcore_membank       is array (0 to membank_size) of std_logic_vector(31 downto 0);  
        type upcore_bankcfg       is array (0 to 5) of std_logic_vector(79 downto 0);
        type upcore_bankstart_end is array (0 to 5) of std_logic_vector(31 downto 0);
        type upcore_memwait       is array (0 to 5) of std_logic_vector( 7 downto 0);

        constant start_addr_b     : integer := 79   ; -- start address index upper limit
        constant start_addr_l     : integer := 48   ; -- start address index lower limit
        constant end_addr_b       : integer := 47   ; -- end address index upper limit
        constant end_addr_l       : integer := 16   ; -- end address index lower limit
        constant first_acc_wait_b : integer := 15   ; -- wait states on first access index upper limit
        constant first_acc_wait_l : integer :=  8   ; -- wait states on first access index lower limit
        constant cycle_wait_b     : integer :=  7   ; -- wait states per cycle index upper limit
        constant cycle_wait_l     : integer :=  0   ; -- wait states per cycle index lower limit

        -------------------------
        function upcore_loadcfg return upcore_bankcfg is
   FILE slavememory_cfg: TEXT;
            variable result                : upcore_bankcfg := (others=>(others=>'0')) ;
            variable memory_cfg_bitvector  : bit_vector (start_addr_b downto 0)        ;
            variable mem_bank_counter      : INTEGER := 0                              ;
            variable cfgline               : LINE                                      ; 
        begin

                read_memory : 
    	FILE_OPEN(slavememory_cfg, "slavememory.cfg.dat", READ_MODE);

                while (not ENDFILE(slavememory_cfg) and (mem_bank_counter < NUMBANKS))
                loop
                 -- read next data line 
                    READLINE (slavememory_cfg, cfgline) ;
                    if ( cfgline'LENGTH = 0 ) then 
                        next ;
                    elsif ( cfgline (1) = '/' )  then 
                        next ;
                    end if ;
                 -- data is a 20 digit (memory_bitvector'LENGTH/4) HEX string
                    HREAD_bv (cfgline , memory_cfg_bitvector ) ;
                    result   (mem_bank_counter) := To_StdLogicVector ( memory_cfg_bitvector );
                    mem_bank_counter := mem_bank_counter + 1 ;
                end loop; -- read_memory 
       FILE_CLOSE(slavememory_cfg);
            return result;
        end upcore_loadcfg;
        -------------------------

        signal memCfg       : upcore_bankcfg       := upcore_loadcfg                ; -- // slavememory.cfg.dat

        -------------------------
        function upcore_loadbank(bank        : integer        ;
                                 bank_string : string(1 to 17);  
                                 config      : upcore_bankcfg ) return upcore_membank is
            variable result           : upcore_membank := (others=>(others=>'0'));
   FILE memory_file: TEXT;
            variable data_line        : LINE                             ;
            variable memory_bitvector : bit_vector (31 downto 0)         ; 
            variable line_counter     : INTEGER := 0                     ; 

        begin
           read_slave_bank : 
  FILE_OPEN(memory_file, bank_string, READ_MODE);          
           while not ENDFILE(memory_file)
            loop
                READLINE (memory_file, data_line) ;
                if ( data_line'LENGTH = 0 ) then 
                    next ;
                elsif ( data_line (1) = '/' )  then 
                    next ;
                end if ;
                HREAD_bv (data_line , memory_bitvector ) ;
                result (line_counter) := To_StdLogicVector (memory_bitvector) ;
                line_counter := line_counter + 1 ; 
            end loop ; 
   FILE_CLOSE(memory_file);
            return result;
        end upcore_loadbank;
        -------------------------


        -------------------------
        function upcore_checkbank(bank        : integer        ;
                                  bank_string : string(1 to 17) ) return upcore_membank is
            variable config : upcore_bankcfg  := upcore_loadcfg ;
            variable result : upcore_membank  := (others=>(others=>'0'));
        begin

         -- If end =/= start, read in the memory file (otherwise everything set to zero).

            if (   conv_integer((config(bank)(start_addr_b downto start_addr_l))) /= conv_integer((config(bank)(end_addr_b downto end_addr_l))) ) 
            then 
                result := upcore_loadbank(bank,bank_string,config);
            end if ; -- different start and end address
            return result;

        end upcore_checkbank;
        -------------------------

        -------------------------
        function initialise_memstart return upcore_bankstart_end is
            variable config : upcore_bankcfg := upcore_loadcfg ;
            variable result : upcore_bankstart_end := (others=>(others=>'0'))  ;
        begin 
            result(0) := config(0) (start_addr_b downto start_addr_l);
            result(1) := config(1) (start_addr_b downto start_addr_l);
            result(2) := config(2) (start_addr_b downto start_addr_l);
            result(3) := config(3) (start_addr_b downto start_addr_l);
            result(4) := config(4) (start_addr_b downto start_addr_l);
            result(5) := config(5) (start_addr_b downto start_addr_l);
            return result;
        end initialise_memstart;
        -------------------------

        -------------------------
        function initialise_memend return upcore_bankstart_end is
            variable config : upcore_bankcfg := upcore_loadcfg ;
            variable result : upcore_bankstart_end := (others=>(others=>'0'))  ;
        begin 
            result(0) := config(0) (end_addr_b downto end_addr_l);
            result(1) := config(1) (end_addr_b downto end_addr_l);
            result(2) := config(2) (end_addr_b downto end_addr_l);
            result(3) := config(3) (end_addr_b downto end_addr_l);
            result(4) := config(4) (end_addr_b downto end_addr_l);
            result(5) := config(5) (end_addr_b downto end_addr_l);
            return result;
        end initialise_memend;
        -------------------------
	
        -------------------------
        function initialise_memwaitstart return upcore_memwait is
            variable config : upcore_bankcfg := upcore_loadcfg ;
            variable result : upcore_memwait := (others=>(others=>'0'))  ;
        begin 
            result(0) := config(0) (first_acc_wait_b downto first_acc_wait_l);
            result(1) := config(1) (first_acc_wait_b downto first_acc_wait_l);
            result(2) := config(2) (first_acc_wait_b downto first_acc_wait_l);
            result(3) := config(3) (first_acc_wait_b downto first_acc_wait_l);
            result(4) := config(4) (first_acc_wait_b downto first_acc_wait_l);
            result(5) := config(5) (first_acc_wait_b downto first_acc_wait_l);
            return result;
        end initialise_memwaitstart;
        -------------------------

        -------------------------
        function initialise_memwait return upcore_memwait is
            variable config : upcore_bankcfg := upcore_loadcfg ;
            variable result : upcore_memwait := (others=>(others=>'0'))  ;
        begin 
            result(0) := config(0) (cycle_wait_b downto cycle_wait_l);
            result(1) := config(1) (cycle_wait_b downto cycle_wait_l);
            result(2) := config(2) (cycle_wait_b downto cycle_wait_l);
            result(3) := config(3) (cycle_wait_b downto cycle_wait_l);
            result(4) := config(4) (cycle_wait_b downto cycle_wait_l);
            result(5) := config(5) (cycle_wait_b downto cycle_wait_l);
            return result;
        end initialise_memwait;
        -------------------------

        signal memStart     : upcore_bankstart_end := initialise_memstart                     ;
        signal memEnd       : upcore_bankstart_end := initialise_memend                       ;
        signal memWaitStart : upcore_memwait       := initialise_memwaitstart                 ;
        signal memWait      : upcore_memwait       := initialise_memwait                      ;
	
        signal sel          : std_logic                     := '0'           ;
        signal doWork       : std_logic                     := '0'           ;
        signal doBusyWork   : std_logic                     := '0'           ;
        signal seqTrans     : std_logic                     := '0'           ;

        signal wrapmask     : std_logic_vector(31 downto 0) := (others=>'0') ;
        signal wrapmask_w   : std_logic_vector(31 downto 0) := (others=>'0') ;
        signal seqPlusAddr  : std_logic_vector(31 downto 0) := (others=>'0') ;
        signal seqAddr      : std_logic_vector(31 downto 0) := (others=>'0') ;
        signal startNext    : std_logic_vector(31 downto 0) := (others=>'0') ;
        signal addrNext     : std_logic_vector(31 downto 0) := (others=>'0') ;
        signal transNext    : std_logic_vector( 1 downto 0) := (others=>'0') ;
        signal sizeNext     : std_logic_vector( 1 downto 0) := (others=>'0') ;
        signal burstNext    : std_logic_vector( 2 downto 0) := (others=>'0') ;
        signal writeNext    : std_logic                     := '0'           ;
		
        signal bankA        : std_logic                     := '0'           ;
        signal bankB        : std_logic                     := '0'           ;
        signal bankC        : std_logic                     := '0'           ;
        signal bankD        : std_logic                     := '0'           ;
        signal bankE        : std_logic                     := '0'           ;
        signal bankF        : std_logic                     := '0'           ;
        signal offsetA      : std_logic_vector(31 downto 0) := (others=>'0') ;
        signal offsetB      : std_logic_vector(31 downto 0) := (others=>'0') ;
        signal offsetC      : std_logic_vector(31 downto 0) := (others=>'0') ;
        signal offsetD      : std_logic_vector(31 downto 0) := (others=>'0') ;
        signal offsetE      : std_logic_vector(31 downto 0) := (others=>'0') ;
        signal offsetF      : std_logic_vector(31 downto 0) := (others=>'0') ;
        signal wordA        : std_logic_vector(15 downto 0) := (others=>'0') ;
        signal wordB        : std_logic_vector(15 downto 0) := (others=>'0') ;
        signal wordC        : std_logic_vector(15 downto 0) := (others=>'0') ;
        signal wordD        : std_logic_vector(15 downto 0) := (others=>'0') ;
        signal wordE        : std_logic_vector(15 downto 0) := (others=>'0') ;
        signal wordF        : std_logic_vector(15 downto 0) := (others=>'0') ;
        signal be0          : std_logic                     := '0'           ;
        signal be1          : std_logic                     := '0'           ;
        signal be2          : std_logic                     := '0'           ;
        signal be3          : std_logic                     := '0'           ;
        signal readDataMask : std_logic_vector(31 downto 0) := (others=>'0') ;
        signal currentValSig   : std_logic_vector(31 downto 0) := (others=>'0') ;

     -- +--------------+
     -- | master port  |
     -- +--------------+
	
        type upcore_transStore is array (NUMTRANS downto 1) of std_logic_vector(Trns_TRANSNUM_l-1 downto 0);

        -------------------------
        function upcore_loadtrans return upcore_transStore is
   FILE mastercommands: TEXT;
            variable result                : upcore_transStore := (others=>(others=>'0')) ;
            variable commandsline          : LINE                                         ; 
            variable transaction_bitvector : bit_vector (Trns_TRANSNUM_l-1 downto 0)      ;
            variable trans_num_iter        : INTEGER := 1                                 ; 
        begin

                read_commands : 
       FILE_OPEN(mastercommands, "mastercommands.dat", READ_MODE);          
                while not ENDFILE(mastercommands) 
                loop
                 -- read next data line 
                    READLINE (mastercommands , commandsline) ;
                    if ( commandsline'LENGTH = 0 ) then 
                        next ;
                    elsif ( commandsline (1) = '/' )  then 
                        next ;
                    end if ;
                    HREAD_bv (commandsline , transaction_bitvector ) ;
                    result   (trans_num_iter) := To_StdLogicVector (transaction_bitvector) ;
                    trans_num_iter := trans_num_iter + 1 ; 
                end loop; -- read_commands 
       FILE_CLOSE(mastercommands);

            return result;
        end upcore_loadtrans;
        -------------------------

     -- +-----------------------------------------------------------------+
     -- |  Transaction records                                            |
     -- |                                                                 |
     -- |  The transactor pipeline consists of 4 stages:                  |
     -- |                                                                 |
     -- |  nextTrans    - the next transaction from the store             |
     -- |  controlTrans - the current control/address stage transaction   |
     -- |  dataTrans    - the data stage transaction                      |
     -- |  reportTrans  - the completed stage for reporting               |
     -- |                                                                 |
     -- |  controlTrans is updated from nextTrans when a new transaction  |
     -- |  begins or from dataTrans in the case of split/retry            |
     -- |                                                                 |
     -- +-----------------------------------------------------------------+

        -- dataTrans    <= idleTrans ;  -- fill pipe with null's
        -- controlTrans <= idleTrans ;
        -- reportTrans  <= idleTrans ;                               
        -- nextTrans    <= idleTrans ;
        -- nextTrans(2) <= '1'       ;  -- repeat 4

        subtype trans_vector is std_logic_vector (Trns_b downto 0) ;

        -------------------------
        function initialise_idle return trans_vector is
            variable result   : trans_vector := (others=>'0') ;
        begin 
         -- set up a null transaction record
            result (Trns_TRANSNUM_b  downto Trns_TRANSNUM_l ) := (OTHERS => '1') ; 
            result (Trns_TRANSTYPE_b downto Trns_TRANSTYPE_l) := H_IDLE          ;
            return result;
        end initialise_idle;
        -------------------------

        -------------------------
        function initialise_next return trans_vector is
            variable result   : trans_vector := (others=>'0') ;
        begin 
         -- set up a null transaction record
            result (Trns_TRANSNUM_b  downto Trns_TRANSNUM_l ) := (OTHERS => '1') ; 
            result (Trns_TRANSTYPE_b downto Trns_TRANSTYPE_l) := H_IDLE          ;
         -- repeat 4
            result (2) := '1' ;  
            return result;
        end initialise_next;
        -------------------------


        signal trans_num       : std_logic_vector(15 downto 0)                := (others=>'0')    ; -- limit is 2^16-1 = NUMTRANS
        signal tmp_transaction : std_logic_vector(Trns_TRANSNUM_l-1 downto 0) := (others=>'0')    ;
        signal currTransNum    : std_logic_vector(15 downto 0)                := (others=>'0')    ;
        signal tmp_beats       : std_logic_vector( 8 downto 0)                := (others=>'0')    ;


        signal idleTrans       : trans_vector      := initialise_idle  ;
        signal controlTrans    : trans_vector      := initialise_idle  ;
        signal dataTrans       : trans_vector      := initialise_idle  ;
        signal reportTrans     : trans_vector      := initialise_idle  ; 
        signal retryTrans      : trans_vector      := initialise_idle  ;
        signal nextTrans       : trans_vector      := initialise_next  ;

     -- +-----------------------------------------+
     -- |  Control signals for master transactor  |
     -- +-----------------------------------------+

        signal reset                : std_logic                     := '1'                       ;
        signal stop                 : std_logic                     := '0'                       ;
        signal continue_after_error : std_logic                     := '1'                       ;
        signal generate_data        : std_logic                     := '0'                       ;
        signal write                : std_logic                                                  ;
        signal start                : std_logic                                                  ;
        signal go_busy              : std_logic                                                  ;
        signal insert_busy          : std_logic_vector( 1 downto 0) := "00"                      ;         
        signal beats                : std_logic_vector( 8 downto 0)                              ;
        signal start_address        : std_logic_vector(31 downto 0)                              ;
        signal data                 : std_logic_vector(31 downto 0)                              ;
        signal burst                : std_logic_vector( 2 downto 0)                              ;
        signal size                 : std_logic_vector( 2 downto 0)                              ;

        signal length               : std_logic_vector( 8 downto 0) := (others=>'0') ;
        signal address_length       : std_logic_vector( 8 downto 0) := (others=>'0') ;

     -- +----------------------------------+
     -- |  Transactor state and responses  |
     -- +----------------------------------+

        signal masterhgrant_in_r           : std_logic                     :=          '0'  ;
        signal break_wrap                  : std_logic                     :=          '0'  ;
        signal original_burst              : std_logic_vector( 2 downto 0) := (others=>'0') ;
        signal busy_states                 : std_logic_vector( 1 downto 0) := (others=>'0') ;
        signal busy_counter                : std_logic_vector( 1 downto 0) := (others=>'0') ;
        signal init_wrap_mask              : std_logic_vector( 9 downto 0) := (others=>'0') ;
        signal wrap_mask                   : std_logic_vector( 9 downto 0) := (others=>'0') ;
        signal masterhaddr_out_r_inc       : std_logic_vector( 7 downto 0) := (others=>'0') ;
        signal init_wrap_boundary_bit      : std_logic_vector( 7 downto 0) := (others=>'0') ;
        signal init_next_masterhaddr_out_r : std_logic_vector(10 downto 0) := (others=>'0') ;
        signal wrap_boundary_bit           : std_logic_vector(10 downto 0) := (others=>'0') ;
        signal next_masterhaddr_out_r      : std_logic_vector( 9 downto 0) := (others=>'0') ;

        signal address_bus_owned           : std_logic                     := '0' ;
        signal data_bus_owned              : std_logic                     := '0' ;
        signal add_go                      : std_logic                     := '0' ;
        signal data_go                     : std_logic                     := '0' ;
        signal reading                     : std_logic                     := '0' ;
        signal writing                     : std_logic                     := '0' ;
        signal first_beat                  : std_logic                     := '0' ;
        signal need_retry                  : std_logic                     := '0' ;
        signal wrap                        : std_logic                     := '0' ;
        signal new_grant                   : std_logic                     := '0' ;
        signal first_masterhtrans_out_r    : std_logic                     := '0' ;
        signal addr_ack                    : std_logic                     := '0' ;
        signal data_ack                    : std_logic                     := '0' ;
        signal add_go_r                    : std_logic                     := '0' ;
        signal replay_wrap                 : std_logic_vector( 2 downto 0) := (others=>'0') ;

     -- output signals

        signal   masterhwrite_out   : std_logic                      :=          '0' ;
        signal   masterhlock_out    : std_logic                      :=          '0' ;
        signal   masterhbusreq_out  : std_logic                      :=          '0' ;
        signal   masterhaddr_out    : std_logic_vector (31 downto 0) := (others=>'0');
        signal   masterhwdata_out   : std_logic_vector (31 downto 0) := (others=>'0');
        signal   masterhtrans_out   : std_logic_vector ( 1 downto 0) := (others=>'0');
        signal   masterhsize_out    : std_logic_vector ( 1 downto 0) := (others=>'0');
        signal   masterhburst_out   : std_logic_vector ( 2 downto 0) := (others=>'0');

        signal   slavehrdata_out    : std_logic_vector (31 downto 0) := (others=>'0');
        signal   slavehreadyo_out   : std_logic                      :=          '0' ;
        signal   slavehresp_out     : std_logic_vector ( 1 downto 0) := (others=>'0');
        signal   slavebuserrint_out : std_logic                      :=          '0' ;

     -- register outputs 
  
        signal   masterhtrans_out_r : std_logic_vector ( 1 downto 0) := (others=>'0');
        signal   masterhaddr_out_r  : std_logic_vector (31 downto 0) := (others=>'0');
        signal   masterhwdata_out_r : std_logic_vector (31 downto 0) := (others=>'0');
        signal   masterhburst_out_r : std_logic_vector ( 2 downto 0) := (others=>'0');
        signal   masterhwrite_out_r : std_logic                      :=          '0' ;
        signal   masterhsize_outl   : std_logic_vector ( 2 downto 0) := (others=>'0'); --  the transactor implements the full 3 bit size field

        signal   slavehreadyo_out_r : std_logic                      :=          '0' ;
        signal   slavehresp_out_r   : std_logic_vector ( 1 downto 0) := (others=>'0');

     -- bus request signals

        signal   single_beat     : std_logic := '0' ;
        signal   last_beat       : std_logic := '0' ;
        signal   retry           : std_logic := '0' ;
        signal   error           : std_logic := '0' ;

     -- bus request states

        constant req_idle        : std_logic_vector(2 downto 0) := "000";
        constant req_first       : std_logic_vector(2 downto 0) := "001";
        constant req_wait        : std_logic_vector(2 downto 0) := "101";
        constant req_masterhold  : std_logic_vector(2 downto 0) := "011";
        constant req_using       : std_logic_vector(2 downto 0) := "010";
        constant req_again       : std_logic_vector(2 downto 0) := "111";

        signal   req_state       : std_logic_vector(2 downto 0) := "000";
        signal   single_beat_r   : std_logic                    := '0'  ;

     -- complete data phase signals 

        signal   trans_end       : std_logic                    := '0'  ;

     -- write data signals 

        signal   addr_offset              : std_logic_vector( 7 downto 0) := (others=>'0');
        signal   masterhwdata_out_r_pipe  : std_logic_vector(31 downto 0) := (others=>'0');
        signal   masterhwdata_out_r_retry : std_logic_vector(31 downto 0) := (others=>'0');

     -- wait state generation

        signal   s_addr_latch  : std_logic                     := '0'          ; --  slave address latched this cycle
        signal   waitStart     : std_logic_vector( 7 downto 0) := (others=>'0');
        signal   waitSeq       : std_logic_vector( 7 downto 0) := (others=>'0');
        signal   waitStartNext : std_logic_vector( 7 downto 0) := (others=>'0');

    file     results_file  : TEXT OPEN WRITE_MODE is "output.dat" ;


    begin

     -- Note: in processes where signals are assigned to and used at the same simulation time, 
     -- temporary variables have been created to remove non-determinism as far as possible. 

     -- +==================================================================+
     -- | Initialisation :                                                 |
     -- | This process is executed once at the start of run then suspended |
     -- +==================================================================+

     initialisation : process 

     begin 

     -- Unused signals tied off to ground

	      lockgrantdp0  <= '0';
	      lockgrantdp1  <= '0';
	
	      debugack      <= '0';
	      debugrng0     <= '0';
	      debugrng1     <= '0';
	      debugextout   <= ( others => '0') ;

	      intuart       <= '0';
	      inttimer0     <= '0';
	      inttimer1     <= '0';
	      intproc0      <= '0';
	      intproc1      <= '0';

        slavehresp_out_r <= H_OKAY;

        reset <= '1'   ;
        wait for 10 ns ;
        reset <= '1'   ;
        wait for 20 ns ;
        reset <= '0'   ;
     
        wait ; 

     end process initialisation ;


     -- +---------------------------------------------------------------------------------+
     -- | Concurrent Signal Assignments (these will appear as wires in the Verilog model) |
     -- | also see - 'Slave port implementation' and 'burst mode support'                 |
     -- +---------------------------------------------------------------------------------+

        start            <= nextTrans(Trns_BUSCOMMD                               ) ;
        go_busy          <= nextTrans(Trns_BUSY                                   ) ;
        beats            <= nextTrans(Trns_NUMSEQBEATS_b downto Trns_NUMSEQBEATS_l) ;
        burst            <= nextTrans(Trns_BURSTTYPE_b   downto Trns_BURSTTYPE_l  ) ;
        size             <= nextTrans(Trns_SIZE_b        downto Trns_SIZE_l       ) ;
        write            <= nextTrans(Trns_WRITE                                  ) ;
        start_address    <= nextTrans(Trns_STARTADDR_b   downto Trns_STARTADDR_l  ) ;
        data             <= nextTrans(Trns_DATA_b        downto Trns_DATA_l       ) ;        

     -- +----------------------------+
     -- | Output Signal Assignments  |
     -- +----------------------------+

     -- direct output assignments 

        masterhwrite     <= masterhwrite_out   ;
        masterhlock      <= masterhlock_out    ;
        masterhbusreq    <= masterhbusreq_out  ;
        masterhaddr      <= masterhaddr_out    ;
        masterhwdata     <= masterhwdata_out   ;
        masterhtrans     <= masterhtrans_out   ;
        masterhsize      <= masterhsize_out    ;
        masterhburst     <= masterhburst_out   ;

        slavehreadyo     <= slavehreadyo_out   ;
        slavebuserrint   <= slavebuserrint_out ;
        slavehrdata      <= slavehrdata_out    ;
        slavehresp       <= slavehresp_out     ;

     -- registered output assignments 

        masterhtrans_out <= masterhtrans_out_r ;
        masterhaddr_out  <= masterhaddr_out_r  ;
        masterhwdata_out <= masterhwdata_out_r ;
        masterhburst_out <= masterhburst_out_r ;
        masterhtrans_out <= masterhtrans_out_r ;
        masterhwrite_out <= masterhwrite_out_r ;
        masterhsize_out  <= masterhsize_outl (1 downto 0);  -- upCore only uses 2 bits of the full 3 bit size field

        slavehreadyo_out <= slavehreadyo_out_r ;
        slavehresp_out   <= slavehresp_out_r   ;


     -- +===============================================+
     -- | process NEXTTRANSACTION                       |
     -- |                                               |
     -- |   Sets up the next transaction and waits for  |
     -- |   it to be accepted (rising edge of clk)      |
     -- +===============================================+

        nexttransaction : process 

         -- Some signals are used in checks at current simulation time, t,
         -- rather than at t+delta, so create temporary variables. This should
         -- then give the same functionality as the blocking statements in the 
         -- Verilog version of this model.  

            variable temp_nextTrans       : trans_vector                                 ;
            variable temp_tmp_transaction : std_logic_vector(Trns_TRANSNUM_l-1 downto 0) := (others=>'0') ;
            variable temp_trans_num       : std_logic_vector(15                downto 0) := (others=>'0') ;
            variable temp_tmp_beats       : std_logic_vector( 8                downto 0) := (others=>'0') ;
            variable transactions         : upcore_transStore := upcore_loadtrans ;

        begin

        while ( conv_integer(trans_num) < NUMTRANS )
        loop 

            temp_trans_num := trans_num ;
            temp_tmp_beats := tmp_beats ;
  
            if (conv_integer(nextTrans(Trns_RPTCOUNT_b downto Trns_RPTCOUNT_l)) = 0 ) then
       
             -- get the next record out of those read from the mastercommands file

                temp_trans_num                                           := temp_trans_num + '1' ; 

             -- set temp_tmp_transaction variable now so it can be used straight away in the assignments and checks below.
                    
                temp_tmp_transaction                                     := transactions(conv_integer(temp_trans_num)) ;
                temp_nextTrans                                           := nextTrans ;
                temp_nextTrans(Trns_EXPDATA_b    downto Trns_EXPDATA_l ) := temp_tmp_transaction (Trns_DATA_b downto Trns_DATA_l); -- copy data to expected transaction data
                temp_nextTrans(Trns_TRANSNUM_b   downto Trns_TRANSNUM_l) := temp_trans_num       ;
                temp_nextTrans(Trns_TRANSNUM_l-1 downto               0) := temp_tmp_transaction ;

             -- check for a BUSY
  
                if (UNSIGNED(temp_tmp_transaction(Trns_TRANSTYPE_b downto Trns_TRANSTYPE_l)) = UNSIGNED(H_BUSY)) then
                    temp_nextTrans(Trns_BUSY) := '1';
                else
                    temp_nextTrans(Trns_BUSY) := '0';
                end if ;
    
             -- compute the number of beats in burst

                if (    (UNSIGNED(temp_nextTrans(Trns_BURSTTYPE_b downto Trns_BURSTTYPE_l)) /= UNSIGNED(H_SINGLE))  
                    and (UNSIGNED(temp_nextTrans(Trns_TRANSTYPE_b downto Trns_TRANSTYPE_l))  = UNSIGNED(H_NONSEQ)) ) then
                    temp_tmp_beats := "000000001";
                    temp_nextTrans(Trns_NUMSEQBEATS_b downto Trns_NUMSEQBEATS_l) := "000000001";
                    temp_tmp_transaction := transactions(conv_integer(temp_trans_num) + conv_integer(temp_tmp_beats)) ;
                    while (    (UNSIGNED(temp_tmp_transaction(Trns_TRANSTYPE_b downto Trns_TRANSTYPE_l)) = UNSIGNED(H_SEQ) )
                            or (UNSIGNED(temp_tmp_transaction(Trns_TRANSTYPE_b downto Trns_TRANSTYPE_l)) = UNSIGNED(H_BUSY)) ) 
                    loop 
                        temp_nextTrans(Trns_NUMSEQBEATS_b downto Trns_NUMSEQBEATS_l) := 
                                                     temp_nextTrans(Trns_NUMSEQBEATS_b downto Trns_NUMSEQBEATS_l) + 
                                                     conv_integer(temp_tmp_transaction(Trns_RPTCOUNT_b downto Trns_RPTCOUNT_l)) + 
                                                     1 ;
                        temp_tmp_beats            := temp_tmp_beats + 1 ;
                        temp_tmp_transaction      := transactions(conv_integer(temp_trans_num) + conv_integer(temp_tmp_beats));
                    end loop ;
                    tmp_beats <= temp_tmp_beats ;
                end if ;
    
             -- update the start address

                if (    (UNSIGNED(temp_nextTrans(Trns_TRANSTYPE_b downto Trns_TRANSTYPE_l)) /= UNSIGNED(H_SEQ) )  
                    and (UNSIGNED(temp_nextTrans(Trns_TRANSTYPE_b downto Trns_TRANSTYPE_l)) /= UNSIGNED(H_BUSY)) ) then
                    temp_nextTrans(Trns_STARTADDR_b downto Trns_STARTADDR_l) := temp_nextTrans(Trns_ADDR_b downto Trns_ADDR_l); -- start address
                end if ;

             -- assign the temporary variables we've been using to the signals they represent
                nextTrans       <= temp_nextTrans       ;
                tmp_transaction <= temp_tmp_transaction ;
                trans_num       <= temp_trans_num       ; 

            else
                nextTrans(Trns_RPTCOUNT_b downto Trns_RPTCOUNT_l) <= nextTrans(Trns_RPTCOUNT_b downto Trns_RPTCOUNT_l)- 1 ;
            end if ;

            -- wait for the current transaction to be accepted (rising edge of clk)
            
            wait on masterhclk until ( masterhclk = '1' ) ;
            while ( not ( addr_ack='1' or data_ack='1' ) and nextTrans(Trns_BUSCOMMD)='1') 
            loop
                wait on masterhclk until ( masterhclk = '1' ) ;
            end loop ; 
 
            -- transactions in buffer

        end loop ; 
   
        assert FALSE
            report "Altera BFM stripe-to-PLD transaction list exhausted"
            severity WARNING;

        wait;

     end process nexttransaction ;  

     -- +=============================================================+	
     -- | process COMPBURSTLEN                                        |
     -- |                                                             |
     -- |          Compute burst length                               |
     -- |                                                             |
     -- |          add_go_r prevents a newly loaded length being      |
     -- |          decremented by the last data beat of the previous  |
     -- |          transaction.                                       |       
     -- +=============================================================+	

     compburstlen : process ( masterhclk , reset )
  
        variable report_string_80   : string(1 to 80) := (others=>' ') ;
        variable report_string_20   : string(1 to 20) := (others=>' ') ;
        variable report_string_10   : string(1 to 10) := (others=>' ') ;
        variable display_line       : LINE                             ;

     begin

         if (masterhclk'event) then 
             if (masterhready='1') then 
                 add_go_r <= add_go;
             end if ;
         end if ;

         if (    ( masterhclk'event and masterhclk='1') 
              or ( reset'event      and reset='1'     ) ) then

             if (reset='1') then
                 length <= "000000000";
             elsif (add_go='1') then
                 case burst
                 is 
                     when H_SINGLE => length <= "000000001";
                     when H_INCR   => length <=  beats     ;
                     when H_WRAP4  |
                          H_INCR4  => length <= "000000100";
                     when H_WRAP8  |
                          H_INCR8  => length <= "000001000";
                     when H_WRAP16 |
                          H_INCR16 => length <= "000010000";
                     when others   => report_string_80(1 to 21) := "error in burst signal" ;
                                      std.textio.write(display_line , report_string_80);
                                      std.textio.writeline(results_file, display_line );		

                 end case ;
             elsif (     (reading = '1' or writing = '1') 
                     and masterhready='1'
                     and add_go_r /= '1' 
                     and (UNSIGNED(masterhresp)=UNSIGNED(H_OKAY) or UNSIGNED(masterhresp)=UNSIGNED(H_ERROR)) ) then 
                 length <= length - ur_OR(length);
             end if ;

             if (reset='1') then
                 address_length <= "000000000";
             elsif (add_go='1') then
                 case burst
                 is 
                     when H_SINGLE => address_length <= "000000001";
                     when H_INCR   => address_length <=  beats     ;
                     when H_WRAP4  |
                          H_INCR4  => address_length <= "000000100";
                     when H_WRAP8  |
                          H_INCR8  => address_length <= "000001000";
                     when H_WRAP16 |
                          H_INCR16 => address_length <= "000010000";
                     when others   => report_string_80(1 to 21) := "error in burst signal" ;
                                      std.textio.write(display_line , report_string_80);
                                      std.textio.writeline(results_file, display_line );		
                 end case ;
             elsif (    data_bus_owned        = '1' 
                    and masterhready         /= '1'
                    and (UNSIGNED(masterhresp) = UNSIGNED(H_RETRY) or UNSIGNED(masterhresp) = UNSIGNED(H_SPLIT)) ) then 
                 address_length <= address_length + '1' ;
             elsif (    address_bus_owned     = '1' 
                    and masterhready          = '1' 
                    and ur_OR (busy_states)  /= '1'
                    and UNSIGNED(masterhtrans_out_r) /= UNSIGNED(H_IDLE)) then
                 address_length <= address_length - ur_OR (address_length);
             elsif (    address_bus_owned     = '1'
                    and masterhready          = '1'
                    and ur_OR (busy_states)   = '1'
                    and UNSIGNED(masterhtrans_out_r) = UNSIGNED(H_BUSY)
                    and ur_OR (busy_counter) /= '1'  ) then 
                 address_length <= address_length - ur_OR (address_length);
             end if ; 
         end if ; 

     end process compburstlen ;

     -- +-----------------------------------------------------------+
     -- | Slave port implementation : concurrent signal assignments |
     -- +-----------------------------------------------------------+

     -- select signal

        sel        <= slavehsel and slavehreadyi;
	
     -- determine if the transaction includes an operation / a "busy"

        doWork     <= '1' when ( selReg='1' and 
		               ( transReg=conv_integer(H_NONSEQ) or transReg=conv_integer(H_SEQ)) )
                 else '0';

        doBusyWork <= '1' when ( selReg='1' and transReg=conv_integer(H_BUSY) ) 
                 else '0';
	
     -- +--------------------------------------------------+
     -- | BURST MODE SUPPORT                               |
     -- |                                                  |
     -- | If we are in burst mode we'll compute our own    |
     -- | address and control settings based on the spec.  |
     -- |                                                  |
     -- | compute values SEQuential (burst) transfers      |
     -- +--------------------------------------------------+

         seqTrans <= '1' when  selReg='1' 
                        and ( doWork='1' or doBusyWork='1') 
                        and (slavehtrans=conv_integer(H_SEQ) or slavehtrans=conv_integer(H_BUSY)) 
               else '0';

         with burstReg select
             wrapmask  <= (1 downto 0=>'0', others=>'1') when H_WRAP4 
                        , (2 downto 0=>'0', others=>'1') when H_WRAP8 
                        , (2 downto 0=>'0', others=>'1') when H_WRAP16 
                        , (others=>'0')                  when others ;
					
         with sizeReg select
             wrapmask_w <= shift_left(wrapmask, 2) when H_WORD  
                         , shift_left(wrapmask, 1) when H_HWORD 
                         , wrapmask                when others  ;

         with sizeReg select
             seqPlusAddr<= addrReg + 1 when H_BYTE 
                         , addrReg + 2 when H_HWORD 
                         , addrReg + 4 when H_WORD 
                         , addrReg     when others ;
					
         seqAddr <= addrReg when slavehtrans = conv_integer(H_BUSY) 
                              or burstReg    = conv_integer(H_SINGLE) 
               else (startReg and wrapmask_w) or (seqPlusAddr and (not(wrapmask_w)));
			
         -- if this is a sequential transaction only sample HTRANS

        startNext <= startReg when seqTrans='1' else slavehaddr  ;
         addrNext <= seqAddr  when seqTrans='1' else slavehaddr  ;
        transNext <= slavehtrans;
         sizeNext <= sizeReg  when seqTrans='1' else slavehsize  ;
        burstNext <= burstReg when seqTrans='1' else slavehburst ;
        writeNext <= writeReg when seqTrans='1' else slavehwrite ;
	
     -- +==============================================================+	
     -- |                                                              |
     -- | process CTRLLATCH :                                          |
     -- |                                                              |
     -- |        Latch the control data if we are selected             |
     -- |                                                              |
     -- +==============================================================+	

        ctrllatch: process ( slavehclk )
        begin 
            if ( slavehclk'event and slavehclk='1') then

             -- if read is low another device is wait stating its
             -- data phase and hence extending our address phase

                if ( slavehreadyi = '1' ) then
                    selReg <= sel;
                    if ( sel = '1' ) then		-- latch the control data
                        startReg <= startNext    ;
                         addrReg <=  addrNext    ;
                        transReg <= transNext    ;
                         sizeReg <=  sizeNext    ;
                        writeReg <= writeNext    ;
                        burstReg <= burstNext    ;
                    else
                        startReg <= (others=>'0');
                         addrReg <= (others=>'0');
                        transReg <= H_IDLE       ;
                         sizeReg <= H_WORD       ;
                        writeReg <= '0'          ;
                        burstReg <= H_SINGLE     ;
                    end if;
                end if;
            end if;
        end process ctrllatch;
	

        bankA <= '1' when (           conv_integer(addrReg)     >= memStart(0) 
                            and conv_integer(addrReg)     <= memEnd(0) 
                            and conv_integer(memStart(0)) /= memEnd(0) ) 
                     else '0';

        bankB <= '1' when (           conv_integer(addrReg)     >= memStart(1) 
                            and conv_integer(addrReg)     <= memEnd(1) 
                            and conv_integer(memStart(1)) /= memEnd(1) )  
                     else '0';

        bankC <= '1' when (           conv_integer(addrReg)     >= memStart(2) 
                            and conv_integer(addrReg)     <= memEnd(2) 
                            and conv_integer(memStart(2)) /= memEnd(2) ) 
                     else '0';

        bankD <= '1' when (           conv_integer(addrReg)     >= memStart(3) 
                            and conv_integer(addrReg)     <= memEnd(3) 
                            and conv_integer(memStart(3)) /= memEnd(3) ) 
                     else '0';

        bankE <= '1' when (           conv_integer(addrReg)     >= memStart(4) 
                            and conv_integer(addrReg)     <= memEnd(4) 
                            and conv_integer(memStart(4)) /= memEnd(4) )  
                     else '0';

        bankF <= '1' when (           conv_integer(addrReg)     >= memStart(5) 
                            and conv_integer(addrReg)     <= memEnd(5) 
                            and conv_integer(memStart(5)) /= memEnd(5) )  
                     else '0';

	
      -- byte offset into bank                  -- word offset into bank

         offsetA <= addrReg - memStart(0);         
                                                   wordA <= offsetA(17 downto 2);
         offsetB <= addrReg - memStart(1);         
                                                   wordB <= offsetB(17 downto 2);
         offsetC <= addrReg - memStart(2);         
                                                   wordC <= offsetC(17 downto 2);
         offsetD <= addrReg - memStart(3);         
                                                   wordD <= offsetD(17 downto 2);
         offsetE <= addrReg - memStart(4);         
                                                   wordE <= offsetE(17 downto 2);
         offsetF <= addrReg - memStart(5);         
                                                   wordF <= offsetF(17 downto 2);

         -- byte enables

         be0<= '1' when 	( UNSIGNED(sizeReg)=UNSIGNED(H_WORD)  or
                         ( UNSIGNED(sizeReg)=UNSIGNED(H_HWORD) and addrReg(1)='0' ) or
                         ( UNSIGNED(sizeReg)=UNSIGNED(H_BYTE)  and UNSIGNED(addrReg(1 downto 0))=0) )
                  else '0';
         be1<= '1' when 	( UNSIGNED(sizeReg)=UNSIGNED(H_WORD)  or
                         ( UNSIGNED(sizeReg)=UNSIGNED(H_HWORD) and addrReg(1)='0' ) or
                         ( UNSIGNED(sizeReg)=UNSIGNED(H_BYTE)  and UNSIGNED(addrReg(1 downto 0))=1) )
                  else '0';
         be2<= '1' when 	( UNSIGNED(sizeReg)=UNSIGNED(H_WORD)  or
                         ( UNSIGNED(sizeReg)=UNSIGNED(H_HWORD) and addrReg(1)='1' ) or
                         ( UNSIGNED(sizeReg)=UNSIGNED(H_BYTE)  and UNSIGNED(addrReg(1 downto 0))=2) )
                  else '0';
         be3<= '1' when 	( UNSIGNED(sizeReg)=UNSIGNED(H_WORD)  or
                         ( UNSIGNED(sizeReg)=UNSIGNED(H_HWORD) and addrReg(1)='1' ) or
                         ( UNSIGNED(sizeReg)=UNSIGNED(H_BYTE)  and UNSIGNED(addrReg(1 downto 0))=3) )
                  else '0';

         readDataMask( 7 downto  0) <= "11111111"  when ( be0='1' ) else "00000000" ;
         readDataMask(15 downto  8) <= "11111111"  when ( be1='1' ) else "00000000" ;
         readDataMask(23 downto 16) <= "11111111"  when ( be2='1' ) else "00000000" ;
         readDataMask(31 downto 24) <= "11111111"  when ( be3='1' ) else "00000000" ;
			
     -- +=================================+	
     -- | process waitgen                 |
     -- |                                 |
     -- |     wait state generation       |
     -- +=================================+	

        waitstartgen : process (bankA, bankB, bankC, bankD, bankE, bankF )
        begin
            if    (bankA='1') then waitStart <= memWaitStart(0);
            elsif (bankB='1') then waitStart <= memWaitStart(1);
            elsif (bankC='1') then waitStart <= memWaitStart(2);
            elsif (bankD='1') then waitStart <= memWaitStart(3);
            elsif (bankE='1') then waitStart <= memWaitStart(4);
            elsif (bankF='1') then waitStart <= memWaitStart(5);
            end if ;
        end process waitstartgen ; 

        waitseqgen : process (bankA, bankB, bankC, bankD, bankE, bankF )
        begin
            if    (bankA='1') then waitSeq   <= memWait(0);
            elsif (bankB='1') then waitSeq   <= memWait(1);
            elsif (bankC='1') then waitSeq   <= memWait(2);
            elsif (bankD='1') then waitSeq   <= memWait(3);
            elsif (bankE='1') then waitSeq   <= memWait(4);
            elsif (bankF='1') then waitSeq   <= memWait(5);
            end if ;
        end process waitseqgen ; 

     -- +==================================================================+	
     -- | slave wait processes                                             |
     -- |                                                                  |
     -- | wait if                                                          |
     -- |    first beat and memWaitStart and addr has just been latched    |
     -- | or                                                               |
     -- |    first beat and waitReg (more than 1 wait state)               |
     -- | or                                                               |
     -- |    seq beat and waitReg                                          |
     -- | else ready                                                       |
     -- +==================================================================+	

        slavelatch : process ( slavehclk )
        begin
        if ( slavehclk'event and slavehclk='1') then
            s_addr_latch <= slavehreadyi and slavehsel;
        end if ; 
        end process slavelatch ;

        slavewait : process ( doWork, transReg, waitReg, waitStart, s_addr_latch )
            variable report_string_20 : string(1 to 20) := (others=>' ') ;
            variable display_line     : LINE                             ;
        begin 
            if    (doWork='1' and UNSIGNED(transReg)=UNSIGNED(H_NONSEQ) and UNSIGNED(waitStart)/=0 and s_addr_latch='1' ) then
                slavehreadyo_out_r <= '0' ;
                --report_string_20 := "SLAVE: wait on first" ;
                --std.textio.write (display_line , report_string_20);
                --std.textio.writeline (results_file, display_line );
            elsif (doWork='1' and UNSIGNED(transReg)=UNSIGNED(H_NONSEQ) and UNSIGNED(waitReg)/=0 ) then 
                slavehreadyo_out_r <= '0' ;
                --report_string_20 := "SLAVE: wait         " ;
                --std.textio.write (display_line , report_string_20);
                --std.textio.writeline (results_file, display_line );
            elsif (doWork='1' and UNSIGNED(transReg)=UNSIGNED(H_SEQ) and UNSIGNED(waitReg)/=0) then 
                slavehreadyo_out_r <= '0' ;
                --report_string_20 := "SLAVE: wait         " ;
                --std.textio.write (display_line , report_string_20);
                --std.textio.writeline (results_file, display_line );
            else
                slavehreadyo_out_r <= '1' ;
            end if ; 
        end process slavewait ;

         -- if we are waiting (waitReg>0) and not in a busy decrement the counter
         -- otherwise get the new value from memWait of memWaitStart according to
         -- the transaction type 

         waitStartNext <= waitStart - 1 when ( UNSIGNED(waitStart) > 1 )
                      else "00000000";
  
         slavewaitreg : process ( slavehclk )
         begin
            if ( slavehclk'event and slavehclk='1') then
                if (UNSIGNED(waitReg) /= 0 and doBusyWork/='1') then 
                    waitReg <= waitReg - '1' ;
                elsif (doWork='1' and UNSIGNED(transReg)=UNSIGNED(H_NONSEQ) and UNSIGNED(waitStart)/=0 and s_addr_latch='1' ) then
                    waitReg <= waitStartNext ;
                elsif (seqTrans='1' ) then
                    waitReg <= waitSeq ;
                else 
                    waitReg <= "00000000" ;
                end if ; 
            end if ; 
         end process slavewaitreg ;

         -- read data
      slavehrdata_out <= (readDataMask and currentValSig) when (doWork='1' and writeReg/='1' and slavehreadyo_out_r='1')
                   else (others=>'0');

     -- +===========================================================================+	
     -- |                                                                           |
     -- | process MEMWORK :                                                         |
     -- |                                                                           |
     -- |      +  records reads and writes in memory banks                          |
     -- |      +  writes a text report to the screen                                |
     -- |                                                                           |
     -- +===========================================================================+	

        memwork : process ( slavehclk ,
                 wordA,   wordB,   wordC,   wordD,   wordE,   wordF, 
                 bankA,   bankB,   bankC,   bankD,   bankE,   bankF)

            variable memMapA      : upcore_membank       := upcore_checkbank(0,"slavememory.0.dat") ;
            variable memMapB      : upcore_membank       := upcore_checkbank(1,"slavememory.1.dat") ;
            variable memMapC      : upcore_membank       := upcore_checkbank(2,"slavememory.2.dat") ;
            variable memMapD      : upcore_membank       := upcore_checkbank(3,"slavememory.3.dat") ;
            variable memMapE      : upcore_membank       := upcore_checkbank(4,"slavememory.4.dat") ;
            variable memMapF      : upcore_membank       := upcore_checkbank(5,"slavememory.5.dat") ;

            variable report_string_11   : string(1 to 11) := (others=>' ') ;
            variable report_string_10   : string(1 to 10) := (others=>' ') ;
            variable report_string_9    : string(1 to  9) := (others=>' ') ;
            variable report_string_8    : string(1 to  8) := (others=>' ') ;
            variable report_string_6    : string(1 to  6) := (others=>' ') ;
            variable display_line       : LINE                             ;
            variable decimal            : BOOLEAN := FALSE                 ;
            variable temp_memWord       : std_logic_vector(31 downto 0)    ;
            variable currentVal         : std_logic_vector(31 downto 0) := (others=>'0') ;

        begin

            if    (bankA='1' and conv_integer(wordA)< membank_size ) then currentVal := memMapA(conv_integer(wordA)) ; 
            elsif (bankB='1' and conv_integer(wordB)< membank_size ) then currentVal := memMapB(conv_integer(wordB)) ; 
            elsif (bankC='1' and conv_integer(wordC)< membank_size ) then currentVal := memMapC(conv_integer(wordC)) ; 
            elsif (bankD='1' and conv_integer(wordD)< membank_size ) then currentVal := memMapD(conv_integer(wordD)) ; 
            elsif (bankE='1' and conv_integer(wordE)< membank_size ) then currentVal := memMapE(conv_integer(wordE)) ; 
            elsif (bankF='1' and conv_integer(wordF)< membank_size ) then currentVal := memMapF(conv_integer(wordF)) ; 
            end if;

            currentValSig <= currentVal;

            if ( slavehclk'event and slavehclk='1') 
            then
	
                if (doWork='1' and slavehreadyo_out_r='1') 
                then
 
                    temp_memWord := currentVal ;

                    if (writeReg='1') 
                    then
                        if (be0='1') then temp_memWord( 7 downto  0) := slavehwdata( 7 downto  0); end if;
                        if (be1='1') then temp_memWord(15 downto  8) := slavehwdata(15 downto  8); end if;
                        if (be2='1') then temp_memWord(23 downto 16) := slavehwdata(23 downto 16); end if;
                        if (be3='1') then temp_memWord(31 downto 24) := slavehwdata(31 downto 24); end if;
		
                        if (bankA='1') then memMapA(conv_integer(wordA)) := temp_memWord; end if;
                        if (bankB='1') then memMapB(conv_integer(wordB)) := temp_memWord; end if;
                        if (bankC='1') then memMapC(conv_integer(wordC)) := temp_memWord; end if;
                        if (bankD='1') then memMapD(conv_integer(wordD)) := temp_memWord; end if;
                        if (bankE='1') then memMapE(conv_integer(wordE)) := temp_memWord; end if;
                        if (bankF='1') then memMapF(conv_integer(wordF)) := temp_memWord; end if;
                    end if;


                 -- display a text report on screen
                    report_string_10 := "SLAVE:    " ;
                    std.textio.write (display_line , report_string_10);
                    report_string_10 := "          " ;
                    std.textio.write (display_line , report_string_10);
                    report_string_9  := "   addr=[" ;
                    std.textio.write (display_line , report_string_9);
                    if (decimal) then 
                        std.textio.write (display_line, conv_integer(addrReg),right,8);
                    else
                        IEEE.std_logic_textio.hwrite (display_line,addrReg,right,8);
                    end if ; 
                    if (writeReg = '1') 
                    then 
                        report_string_8 := "] WRITE " ;
                    else 
                        report_string_8 := "] READ  " ; 
                    end if;
                    std.textio.write (display_line, report_string_8);

                    report_string_6 := "data=[" ;
                    std.textio.write (display_line , report_string_6);
                    if (writeReg='1') 
                    then 
                        if (decimal) then 
                            std.textio.write (display_line, conv_integer(slavehwdata),right,8);
                        else
                            IEEE.std_logic_textio.hwrite (display_line,slavehwdata,right,8);
                        end if ; 
                    else
                        if (decimal) then 
                            std.textio.write (display_line, conv_integer(slavehrdata_out),right,8);
                        else
                            IEEE.std_logic_textio.hwrite (display_line,slavehrdata_out,right,8);
                        end if ; 
                    end if;
                    report_string_6  := "]     " ;
                    std.textio.write (display_line , report_string_6);
                    report_string_11 := "           " ;
                    std.textio.write (display_line , report_string_11);
                    report_string_10 := "          " ;
                    std.textio.write (display_line , report_string_10);

                    case sizeReg 
                    is
                        when H_BYTE => report_string_10 :=  "     BYTE " ;
                        when H_HWORD=> report_string_10 :=  "HALF WORD " ;
                        when H_WORD => report_string_10 :=  "     WORD " ;
                        when others => report_string_10 :=  " <error>  " ;
                    end case;
                    std.textio.write (display_line , report_string_10);

                    std.textio.writeline(results_file, display_line );		

                end if;

            end if;

        end process memwork;

     -- +==========================================+
     -- |                                          |
     -- | process reportcomptrans :                |
     -- |                                          |
     -- |        Report completed transactions     |
     -- |                                          |
     -- +==========================================+

        reportcomptrans : process ( masterhclk )

            variable report_string_14   : string(1 to 14) := (others=>' ') ;
            variable report_string_9    : string(1 to 9 ) := (others=>' ') ;
            variable report_string_7    : string(1 to 7 ) := (others=>' ') ;
            variable display_line       : LINE                             ;
            variable decimal            : BOOLEAN := FALSE                 ;

        begin

            if ( masterhclk'event and masterhclk='1')
            then
                if (reportTrans(Trns_BUSCOMMD)='1') 
                then 
                    report_string_7 := "MASTER:" ;
                    std.textio.write (display_line, report_string_7);

                    report_string_9 := " trans=[ " ;	
                    std.textio.write (display_line, report_string_9);
                    std.textio.write (display_line, conv_integer(reportTrans(Trns_TRANSNUM_b downto Trns_TRANSNUM_l)),right,4);

                    report_string_9 := "]  addr=[" ;	
                    std.textio.write (display_line, report_string_9);
                    if (decimal) then 
                        std.textio.write (display_line, conv_integer(reportTrans(Trns_ADDR_b downto Trns_ADDR_l)),right,8);
                    else
                        IEEE.std_logic_textio.hwrite (display_line, reportTrans(Trns_ADDR_b downto Trns_ADDR_l),right,8);
                    end if ; 

                    if (reportTrans(Trns_WRITE) = '1') 
                    then 
                        report_string_14 := "] WRITE data=[" ;
                        std.textio.write (display_line, report_string_14);
                        if (decimal) then 
                            std.textio.write (display_line, conv_integer(reportTrans(Trns_DATA_b downto Trns_DATA_l)),right,8);
                        else
                            IEEE.std_logic_textio.hwrite (display_line, reportTrans(Trns_DATA_b downto Trns_DATA_l),right,8);
                        end if ; 
                    else 
                        report_string_14 := "] READ  data=[" ; 
                        std.textio.write (display_line, report_string_14);
                        if (decimal) then 
                            std.textio.write (display_line, conv_integer(reportTrans(Trns_READ_b downto Trns_READ_l)),right,8);
                        else
                            IEEE.std_logic_textio.hwrite (display_line, reportTrans(Trns_READ_b downto Trns_READ_l),right,8);
                        end if ; 
                    end if;

                    report_string_14 := "]   expected=[" ;	
                    std.textio.write (display_line, report_string_14);
                    if (decimal) then 
                        std.textio.write (display_line, conv_integer(reportTrans(Trns_EXPDATA_b downto Trns_EXPDATA_l)),right,8);
                    else
                        IEEE.std_logic_textio.hwrite (display_line, reportTrans(Trns_EXPDATA_b downto Trns_EXPDATA_l),right,8);
                    end if ; 

                    case reportTrans(Trns_SIZE_b-1 downto Trns_SIZE_l) -- (only 2 of the 3 bits are used)
                    is
                        when H_BYTE  => report_string_14 :=  "]         BYTE" ;
                        when H_HWORD => report_string_14 :=  "]    HALF WORD" ;
                        when H_WORD  => report_string_14 :=  "]         WORD" ;
                        when others  => report_string_14 :=  "]      <error>" ;
                    end case;
                    std.textio.write (display_line , report_string_14);

                    if (UNSIGNED(reportTrans(Trns_RESP_b downto Trns_RESP_l))=UNSIGNED(H_OKAY) ) then
                        report_string_9 :=  "  OKAY   " ;
                    else
                        report_string_9 :=  "  ERROR  " ;
                    end if ; 
                    std.textio.write (display_line , report_string_9);

                    std.textio.writeline(results_file, display_line );		
 
                end if;	
            end if;
        end process reportcomptrans;

     -- +====================================================================================+
     -- |                                                                                    |
     -- | process BUSREQUEST :                                                               |
     -- |                                                                                    |
     -- | Bus request state machine                                                          |
     -- |                                                                                    |
     -- |     Bus request machine follows the principle that the arbiter will generally      |
     -- |     only re-assign bus grants at the end of a burst transaction. For defined       |
     -- |     bursts masterhbusreq_out is removed as soon as we masterhave started the       |
     -- |     transaction. Undefined (INCR) bursts will masterhold masterhbusreq_out         |
     -- |     asserted until the last beat of the transaction.                               |
     -- |                                                                                    |
     -- |     Locked transactions must always assert masterhlock_out for at least one        |
     -- |     cycle before the address to be locked to allow the arbiter to see the lock.    |
     -- |     In practice, this means inserting an idle cycle.                               | 
     -- |                                                                                    |
     -- |     Have to be careful using burst and beats from the control word. As soon        |
     -- |     as the master address phase masterhas finished and the addr_ack is asserted    |
     -- |     the testbench can change the control word. So don't use them after the         | 
     -- |     initial request. Use the ahb outputs instead which will tell us what sort      |
     -- |     of transaction we're doing.                                                    |
     -- |                                                                                    |
     -- | Bus request machine master has 5 states:                                           |
     -- |                                                                                    |
     -- |    1) req_idle:  masterhbusreq_out negated. When we want to do something           |
     -- |                  we jump to req_first. The last beat may get a retry               |
     -- |                  response in which case we jump to req_again.                      |
     -- |                                                                                    |
     -- |    2) req_first: masterhbusreq_out asserted. Wait here for masterhgrant            |
     -- |                  and until the transaction starts. If granted and it's an          |
     -- |                  undefined and not a single beat then jump to req_masterhold.      |
     -- |                  Else if it's a single beat jump to req_idle. Otherwise jump       |
     -- |                  to req_using.                                                     |
     -- |                                                                                    |
     -- |    3) req_masterhold: masterhbusreq_out asserted. Hold masterhbusreq_out           |
     -- |                  asserted until last beat of an undefined. If there's a            |
     -- |                  new request then we jump to req_first, otherwise back to          |
     -- |                  req_idle. If we lose masterhgrant in this state then we           |
     -- |                  just stay here with masterhbusreq_out asserted until the          |
     -- |                  transaction can be finished. Also hold in this state if           |
     -- |                  retry is asserted to reduce the chance of releaseing the          |
     -- |                  bus and having to re-request it to complete a transaction.        |
     -- |                                                                                    |
     -- |    4) req_using: masterhbusreq_out negated. Wait here for last beat of             |
     -- |                  defined length transaction. If there's a new request then         |
     -- |                  we jump to req_first, otherwise back to req_idle. If a            |
     -- |                  posted write is errored before the last beat or a transaction     |
     -- |                  is retried or we lose masterhgrant then we jump to                | 
     -- |                  req_again.                                                        |
     -- |                                                                                    |
     -- |    5) req_again: masterhbusreq_out asserted for completion of transaction          |
     -- |                  interrupted by loss of masterhgrant. Wait here for                |
     -- |                  masterhgrant and until the transaction starts then                |
     -- |                  jump to req_using if first_beat is asserted or                    |
     -- |                  req_masterhold if not.                                            |
     -- |                  *** We may see a new address toggle whilst in this state.         |
     -- |                                                                                    |
     -- +====================================================================================+


        single_beat <= '1' when (UNSIGNED(burst)=UNSIGNED(H_SINGLE) or (UNSIGNED(burst)=UNSIGNED(H_INCR) and UNSIGNED(beats)=1))
                  else '0' ;

        last_beat   <= '1' when (address_bus_owned='1' and masterhready='1' and UNSIGNED(address_length) <= 1) 
                  else '0' ;

        retry       <= '1' when (data_bus_owned='1' and (UNSIGNED(masterhresp)=UNSIGNED(H_RETRY) or UNSIGNED(masterhresp)=UNSIGNED(H_SPLIT)))
                  else '0' ;

        error       <= '1' when (data_bus_owned='1' and masterhready='1' and UNSIGNED(masterhresp)=UNSIGNED(H_ERROR))
                  else '0' ;

        masterhbusreq_out <= '1' when (   (start     = '1'           )
                                       or (UNSIGNED(req_state) = UNSIGNED(req_first)     )
                                       or (UNSIGNED(req_state) = UNSIGNED(req_wait)      )
                                       or (UNSIGNED(req_state) = UNSIGNED(req_masterhold))
                                       or (UNSIGNED(req_state) = UNSIGNED(req_again)     ) )
                        else '0' ;

        busrequest : process ( masterhclk , reset)

        begin

            if (masterhclk'event and masterhclk = '1') then 
                if (addr_ack='1') then
                 -- save single_beat for use after it may have changed
                    single_beat_r <= single_beat;
                end if ;
            end if ;

            if (   (masterhclk'event and masterhclk = '1') 
                or (reset'event      and reset      = '1') ) then

                if (reset='1') then
                    req_state <= req_idle;
                else
                  case req_state 
                  is
                    when req_idle       => if (retry='1') then
                                               req_state <= req_again;
                                           elsif (start='1') then
                                               req_state <= req_first;
                                           else
                                               req_state <= req_idle ;
                                           end if ;

                    when req_first      => if (retry='1') then
                                               req_state <= req_again;
                                           elsif (masterhgrant/='1' and not (UNSIGNED(masterhtrans_out_r)=UNSIGNED(H_NONSEQ) and masterhready='1')) then
                                               req_state <= req_first;
                                           elsif (UNSIGNED(masterhtrans_out_r)=UNSIGNED(H_NONSEQ) and masterhready='1') then
                                               if (add_go='1') then
                                                   req_state <= req_first;
                                               elsif (UNSIGNED(burst)=UNSIGNED(H_INCR) and single_beat/='1') then
                                                   req_state <= req_masterhold;
                                               elsif (single_beat='1') then
                                                   req_state <= req_idle;
                                               else
                                                   req_state <= req_using;
                                               end if ;
                                           else
                                               req_state <= req_wait;
                                           end if ;

                    when req_wait       => if (retry='1') then
                                               req_state <= req_again;
                                           elsif (masterhgrant/='1' and not (UNSIGNED(masterhtrans_out_r)=UNSIGNED(H_NONSEQ) and masterhready='1')) then
                                               req_state <= req_first;
                                           elsif (masterhgrant='1' and not (UNSIGNED(masterhtrans_out_r)=UNSIGNED(H_NONSEQ) and masterhready='1')) then
                                               req_state <= req_wait;
                                           elsif (add_go='1') then
                                               req_state <= req_first;
                                           elsif (UNSIGNED(burst)=UNSIGNED(H_INCR) and single_beat/='1') then
                                               req_state <= req_masterhold;
                                           elsif (single_beat_r='1') then
                                               req_state <= req_idle;
                                           else
                                               req_state <= req_using;
                                           end if ;

                    when req_masterhold => if (error='1' and continue_after_error/='1') then
                                               req_state <= req_idle;
                                           elsif (   (masterhgrant/='1' and (conv_integer(address_length) > 1 )) 
                                                  or retry='1' ) then
                                               req_state <= req_again;
                                           elsif (last_beat='1') then
                                               if (start='1') then
                                                   req_state <= req_first;
                                               else
                                                   req_state <= req_idle;
                                               end if ;
                                           elsif (add_go='1') then
                                               req_state <= req_first;
                                           else
                                               req_state <= req_masterhold;
                                           end if ;

                    when req_using      => if (error='1' and continue_after_error/='1') then
                                               req_state <= req_idle;
                                           elsif (last_beat='1') then
                                               if (start='1') then
                                                   req_state <= req_first;
                                               else
                                                   req_state <= req_idle;
                                               end if ;
                                           elsif (   (masterhgrant/='1' and (conv_integer(address_length) > 1 )) 
                                                  or retry='1') then
                                               req_state <= req_again;
                                           else
                                               req_state <= req_using;
                                           end if ;

                    when req_again      => if (error='1' and continue_after_error/='1') then
                                               req_state <= req_idle;
                                           elsif (     (   (data_bus_owned/='1') 
                                                        or (data_bus_owned='1' and (UNSIGNED(masterhresp) = UNSIGNED(H_OKAY))) )
                                                   and address_bus_owned='1' 
                                                   and UNSIGNED(masterhtrans_out_r)=UNSIGNED(H_IDLE) 
                                                   and masterhready='1'
                                                   and masterhlock_out/='1') then
                                               req_state <= req_idle;
                                           elsif (     (masterhgrant/='1' and (conv_integer(address_length) > 1 )) 
                                                    or (not ((UNSIGNED(masterhtrans_out_r)=UNSIGNED(H_NONSEQ)) and (masterhready='1'))) ) then
                                               req_state <= req_again;
                                           elsif (     (    (last_beat='1') 
                                                        or  (UNSIGNED(masterhburst_out_r)=UNSIGNED(H_SINGLE)))
                                                    or (    (UNSIGNED(masterhburst_out_r)=UNSIGNED(H_INCR)) 
                                                        and (single_beat_r='1'))    ) then
                                               req_state <= req_idle;
                                           elsif (first_beat='1') then
                                               req_state <= req_using;
                                           else
                                               req_state <= req_masterhold;
                                           end if ;

                    when others         => req_state <= req_idle;
                                                 
                  end case ;
                end if ;
            end if ;
 
         end process busrequest ;

     -- +------------------------------------------------------+
     -- | Address and Data acknowledge assignments             |
     -- |                                                      |
     -- | Signals when an address has been transferred and a   |
     -- | new one may be presented for the next transaction.   |
     -- +------------------------------------------------------+

        addr_ack <= add_go  ;
        data_ack <= data_go ;

     -- +======================================================+
     -- | process busownership                                 |
     -- |                                                      |
     -- | Data bus ownership follows address by one cycle      |
     -- +======================================================+

        busownership : process (masterhclk, reset)
        begin
        if (   ( masterhclk'event and masterhclk='1')  
            or ( reset'event      and reset='1'     ) ) then 
            if ( reset ='1' ) then
                address_bus_owned <= '0' ;
                data_bus_owned    <= '0' ;
            elsif (masterhready ='1' ) then 
                address_bus_owned <= masterhgrant;
                data_bus_owned    <= address_bus_owned;
            end if ;
        end if ; 
        end process busownership ;

     -- +===============================================================+
     -- | process ENABLEADDRESSPHASE                                    |
     -- |                                                               |
     -- |      add_go enables the address phase for a new transaction   |
     -- |      (not the continuation of a retried transaction or a      |
     -- |      transaction during which we lose the bus).               |
     -- |      It asserts immediately on address request if we're not   |
     -- |      actively using the bus and not waiting for it to be      |
     -- |      re-granted to complete a previous transaction, the       |
     -- |               (masterhtrans_out_r = IDLE)                     |
     -- |      term ensuring it only asserts for one clock.             |
     -- +===============================================================+

        enableaddressphase : process (start, masterhbusreq_out, masterhgrant, masterhready, reading,
                                      writing, masterhtrans_out_r, req_state, length, reset   )
        begin
            if   (     start               = '1' 
                   and masterhbusreq_out   = '1' 
                   and masterhgrant        = '1' 
                   and masterhready        = '1' 
                   and reading            /= '1' 
                   and writing            /= '1'
                   and UNSIGNED(masterhtrans_out_r)=UNSIGNED(H_IDLE) 
                   and UNSIGNED(req_state)        /=UNSIGNED(req_again)
                   and reset              /= '1' ) then
                add_go <= '1' ;
            elsif (    start               = '1' 
                   and masterhbusreq_out   = '1' 
                   and masterhgrant        = '1' 
                   and masterhready        = '1' 
                   and conv_integer(length) < 2
                   and retry              /= '1'
                   and UNSIGNED(masterhtrans_out_r)/=UNSIGNED(H_BUSY) 
                   and UNSIGNED(masterhtrans_out_r)/=UNSIGNED(H_NONSEQ)
                   and reset              /= '1' ) then
                add_go <= '1' ;
            else
                add_go <= '0' ;
            end if ; 
        end process enableaddressphase ;

     -- +=================================================================+
     -- | process COMPLETEDATAPHASE			                                    |
     -- |                                                                 |
     -- |      data_go indicates the completion of the data phase for a   |
     -- |      transaction. Like add_go it asserts when the master        |
     -- |      takes control of the address lines to start a transaction. |
     -- |      It also asserts on all the accepted data beats of a burst  |
     -- |      except the last.                                           |
     -- +=================================================================+

        updatetrans_end : process ( data_bus_owned, reading, writing, masterhready, masterhresp )
            variable boolean_1 : std_logic ;
        begin
            if (UNSIGNED(masterhresp)=UNSIGNED(H_OKAY) or UNSIGNED(masterhresp)=UNSIGNED(H_ERROR)) then boolean_1 := '1' ; else boolean_1 := '0' ; end if ; 
            trans_end <=  (    data_bus_owned
                           and (reading or writing) 
                           and masterhready
                           and boolean_1 ) ;
        end process updatetrans_end ; 


        completedataphase : process (start,   masterhbusreq_out, writing,    reset, 
                                     reading, masterhgrant,  req_state,  trans_end,
                                     length,  masterhready,  need_retry, masterhtrans_out_r )

        begin

            if (    start                = '1' 
                and masterhbusreq_out    = '1' 
                and masterhgrant         = '1' 
                and masterhready         = '1' 
                and reading             /= '1' 
                and writing             /= '1'
                and UNSIGNED(masterhtrans_out_r) = UNSIGNED(H_IDLE)
                and UNSIGNED(req_state)         /= UNSIGNED(req_again)
                and reset               /= '1' 
                and need_retry          /= '1' ) then
                data_go <= '1' ;
            elsif ( start                = '1' 
                and masterhbusreq_out    = '1' 
                and masterhgrant         = '1' 
                and masterhready         = '1' 
                and conv_integer(address_length) > 1 
                and retry               /= '1'
                and reset               /= '1' 
                and (need_retry/='1' or trans_end='1') ) then
                data_go <= '1' ;
            else
                data_go <= '0' ;
            end if ; 

        end process completedataphase ;

     -- +======================================================+
     -- | process UPDATES                                      |
     -- |                                                      |
     -- |    update masterhwrite_out_r, Transaction size,      |
     -- |    busy state and counter on leading edge of clock   |
     -- |    or reset                                          |
     -- +======================================================+

        updates : process ( masterhclk, reset ) 

        begin

            if (   ( masterhclk'event and masterhclk='1')  
                or ( reset'event      and reset='1'     ) ) then 

             -- +------------------------------------------------------+
             -- | masterhwrite_out_r update                            |
             -- |                                                      |
             -- |  Updated on any clock that starts a new transaction  |
             -- +------------------------------------------------------+

                if ( reset='1' ) then
                    masterhwrite_out_r <= '1' ;
                elsif ( addr_ack='1' ) then 
                    masterhwrite_out_r <= write ;
                end if ;

             -- +------------------------------------------------------+
             -- | Transaction size update                              |
             -- |                                                      |
             -- |  Updated on any clock that starts a new transaction  |
             -- +------------------------------------------------------+

                if ( reset ='1' ) then
                    masterhsize_outl <= "000" ;
                elsif ( addr_ack ='1' ) then 
                    masterhsize_outl <= size ;
                end if ;
 
             -- +------------------------------------------------------+
             -- | Busy state and counter update                        |
             -- |                                                      |
             -- |  Insert BUSY states into burst transactions.         |
             -- |  Capture control word. Load counter on every active  |
             -- |  phase and decrement to zero.                        |
             -- +------------------------------------------------------+

                if ( reset ='1' ) then
                    busy_states <= "00" ;
                elsif ( addr_ack ='1' ) then 
                    busy_states <= insert_busy ;
                end if ;
  
                if ( reset ='1' ) then
                    busy_counter <= "00" ;
                elsif ((UNSIGNED(masterhtrans_out_r)=UNSIGNED(H_NONSEQ)) or (UNSIGNED(masterhtrans_out_r) = UNSIGNED(H_SEQ))) then 
                    busy_counter <= busy_states - 1;
                else
                    busy_counter <= busy_counter - ur_OR(busy_counter);
                end if ;

            end if ; 

        end process updates ; 

     -- +=================================================================+
     -- |  RESTART TRANS processes                                        |
     -- |                                                                 |
     -- |  first_masterhtrans_out_r is asserted to enable the first beat  |
     -- |  of a transaction addr_ack (which is always NONSEQ) to :        |
     -- |       + restart a transaction that was interrupted by loss      |
     -- |         of masterhgrant if we receive a new masterhgrant        |
     -- |         whilst in req_again or req_masterhold states.           |
     -- |       + restart a transaction after a RETRY response.           |
     -- |       + restart a transaction after a SPLIT response.           |
     -- |       + break an undefined INCR replay of a retried or split    |
     -- |         wrapping burst at the wrap address boundary.            |
     -- +-----------------------------------------------------------------+

        restarttrans : process (masterhclk, reset)

            variable masterhgrant_in_leading_edge  : std_logic := '0' ;

        begin

            if ( masterhclk'event and masterhclk ='1') then
                masterhgrant_in_r <= masterhgrant;
            end if ;

            masterhgrant_in_leading_edge := masterhgrant and not masterhgrant_in_r ;

            if (   ( masterhclk'event and masterhclk ='1') 
                or ( reset'event      and reset='1'     ) ) then
                if (reset = '1') then
                    new_grant <= '0' ;
                elsif (masterhgrant_in_leading_edge = '1' and first_masterhtrans_out_r /= '1') then
                    new_grant <= '1' ;
                elsif (first_masterhtrans_out_r = '1' or masterhgrant /= '1') then
                    new_grant <= '0' ;
                end if ;
            end if ;

         end process restarttrans ;


         updatefirst_masterhtrans_out_r : process ( addr_ack, masterhgrant, masterhgrant_in_r, new_grant, masterhready, masterhwrite_out_r, 
                                                    first_beat, data_bus_owned, address_bus_owned, length, masterhresp, req_state)

            variable boolean_1 : std_logic := '0' ; 
            variable boolean_2 : std_logic := '0' ; 
            variable boolean_3 : std_logic := '0' ; 
            variable boolean_4 : std_logic := '0' ; 
            variable boolean_5 : std_logic := '0' ; 
            variable masterhgrant_in_leading_edge  : std_logic := '0' ;

         begin

            -- convert booleans in expression to '1's or '0's

            masterhgrant_in_leading_edge := masterhgrant and not masterhgrant_in_r ;

            if (UNSIGNED(req_state)  =UNSIGNED(req_masterhold)) then boolean_1 := '1' ; else boolean_1 := '0' ; end if ;
            if (UNSIGNED(req_state)  =UNSIGNED(req_again)     ) then boolean_2 := '1' ; else boolean_2 := '0' ; end if ;
            if (UNSIGNED(masterhresp)=UNSIGNED(H_RETRY)       ) then boolean_3 := '1' ; else boolean_3 := '0' ; end if ;
            if (UNSIGNED(masterhresp)=UNSIGNED(H_SPLIT)       ) then boolean_4 := '1' ; else boolean_4 := '0' ; end if ;
            if (conv_integer(length) > 1  ) then boolean_5 := '1' ; else boolean_5 := '0' ; end if ;

            first_masterhtrans_out_r <= (addr_ack 
                or ((((masterhgrant_in_leading_edge or (masterhgrant and new_grant)) and masterhready) and (not masterhwrite_out_r)) and (boolean_1 or boolean_2))
                or ((masterhgrant_in_leading_edge or (masterhgrant and new_grant)) and (masterhready and masterhwrite_out_r) and (boolean_1 or boolean_2)  )
                or ((data_bus_owned and masterhready) and (boolean_3 or boolean_4)))
                or (((address_bus_owned and masterhready) and (not first_beat)) and (break_wrap and boolean_5));

         end process updatefirst_masterhtrans_out_r ; 
 
         -- +------------------------------------------------------+
         -- | The only time masterhtrans_out_r changes is when     |
         -- | masterhready is negated is during reset or after     |
         -- | the first cycle of a two-cyle error response.        |
         -- | Otherwise, masterhtrans_out_r can only change when   |
         -- | masterhgrant and masterhready are asserted.          |
         -- +------------------------------------------------------+

         updatemasterhtrans_out_r : process ( masterhclk, reset )

         begin

            if (   ( masterhclk'event and masterhclk='1')  
                or ( reset'event      and reset='1'     ) ) then 
                if (reset='1') then
                    masterhtrans_out_r <= H_IDLE;
                elsif (    data_bus_owned        = '1'
                       and masterhready         /= '1'
                       and UNSIGNED(masterhresp)/=UNSIGNED(H_OKAY)
                       and continue_after_error /= '1' ) then   -- ERROR'ed transactions cancelled
                    masterhtrans_out_r <= H_IDLE;
                elsif (    data_bus_owned        = '1' 
                       and masterhready         /= '1' 
                       and UNSIGNED(masterhresp)/= UNSIGNED(H_OKAY)
                       and UNSIGNED(masterhresp)/= UNSIGNED(H_ERROR)
                       and continue_after_error  = '1' ) then       -- ERROR'ed transactions not cancelled
                    masterhtrans_out_r <= H_IDLE;
                elsif (    masterhgrant='1' 
                       and masterhready='1') then
                    case masterhtrans_out_r
                    is
                        when H_IDLE    => if (first_masterhtrans_out_r='1') then 
                                              masterhtrans_out_r <= H_NONSEQ;
                                          else
                                              masterhtrans_out_r <= H_IDLE;
                                          end if ;
    
                        when H_NONSEQ  |
                             H_SEQ     => if (first_masterhtrans_out_r='1') then 
                                              masterhtrans_out_r <= H_NONSEQ;
                                          elsif ((UNSIGNED(masterhburst_out_r)=UNSIGNED(H_SINGLE)) or (conv_integer(address_length) <= 1) ) then -- Last beat
                                              masterhtrans_out_r <= H_IDLE;
                                          elsif (go_busy = '1') then 
                                              masterhtrans_out_r <= H_BUSY;
                                          else
                                              masterhtrans_out_r <= H_SEQ;
                                          end if ;
    
                        when H_BUSY    => if (first_masterhtrans_out_r='1') then 
                                              masterhtrans_out_r <= H_NONSEQ;
                                          elsif (go_busy='1') then 
                                              masterhtrans_out_r <= H_BUSY;
                                          else
                                              masterhtrans_out_r <= H_SEQ;
                                          end if ;
                        when others    => assert false report "error in masterhtrans_out_r" severity warning;
                    end case ;
                elsif (masterhready='1' and masterhgrant/='1') then
                    masterhtrans_out_r <= H_IDLE;
                end if ;
            end if ;
  
         end process updatemasterhtrans_out_r ;

         -- +------------------------------------------------------+
         -- | One of reading or writing is asserted during any     | 
         -- | data beat for which we are actively using the bus.   |
         -- +------------------------------------------------------+

         updatereadingwriting : process (masterhclk, reset) 

         begin

            if (   ( masterhclk'event and masterhclk='1')  
                or ( reset'event      and reset='1'     ) ) then 
                if (reset='1') then
                    reading <= '0' ;
                    writing <= '0' ;
                elsif (masterhready = '1') then
                    if (    masterhwrite_out_r /= '1'
                        and address_bus_owned   = '1'
                        and UNSIGNED(masterhtrans_out_r)/= UNSIGNED(H_IDLE) 
                        and UNSIGNED(masterhtrans_out_r)/= UNSIGNED(H_BUSY) ) then 
                        reading <= '1' ; 
                    else 
                        reading <= '0' ;
                    end if ;  
                    if (    masterhwrite_out_r  = '1'
                        and address_bus_owned   = '1'
                        and UNSIGNED(masterhtrans_out_r) /= UNSIGNED(H_IDLE) 
                        and UNSIGNED(masterhtrans_out_r )/= UNSIGNED(H_BUSY) ) then  
                        writing <= '1' ;
                    else 
                        writing <= '0' ;
                    end if ; 
                end if ; 
            end if ; 

         end process updatereadingwriting ;

         -- +----------------------------------------------------------+
         -- | Burst size                                               |
         -- |                                                          |
         -- | first_beat is used to keep masterhburst_out_r unchanged  |
         -- | when the first beat is to be replayed. It alse controls  |
         -- | the bus request. A transaction that is split or retried  |
         -- | on any other beat will be replayed as INCR and           |
         -- | masterhbusreq_out must be held asserted.                 |
         -- |                                                          |
         -- | Tmasterhis means that a defined length read that us      |
         -- | interrupted mid-burst will complete as an undefined INCR |
         -- | and may pre-fetch past the end of the defined length     |
         -- | (unless, of course, no_prefetch is asserted).            |
         -- +----------------------------------------------------------+

         burst_beat : process (masterhclk, reset)
         begin
            if (   ( masterhclk'event and masterhclk='1')  
                or ( reset'event      and reset='1'     ) ) then 
                if (reset='1') then
                    first_beat <= '0' ;
                elsif (addr_ack='1') then 
                    first_beat <= '1' ;
                elsif (data_bus_owned='1' and (reading='1' or writing='1') and masterhready='1' and UNSIGNED(masterhresp)=UNSIGNED(H_OKAY)) then
                    first_beat <= '0' ;
                end if ; 
             end if ; 
         end process burst_beat ; 

         burst_burst_out : process (masterhclk, reset)
         begin
            if (   ( masterhclk'event and masterhclk='1')  
                or ( reset'event      and reset='1'     ) ) then 
                if (reset='1') then
                    masterhburst_out_r <= "000" ;
                elsif (addr_ack='1') then 
                    masterhburst_out_r <= burst ;
                elsif (first_masterhtrans_out_r='1' and first_beat/='1') then 
                    masterhburst_out_r <= H_INCR;
                end if ; 
             end if ; 
         end process burst_burst_out ; 

         -- +------------+
         -- | need_retry |
         -- +------------+

         burst_need_retry : process (masterhclk, reset)
         begin
            if (   ( masterhclk'event and masterhclk='1')  
                or ( reset'event      and reset='1'     ) ) then 
                if (reset='1') then
                    need_retry <= '0' ;
                elsif (    data_bus_owned='1' 
                       and masterhready /='1' 
                       and (UNSIGNED(masterhresp)=UNSIGNED(H_RETRY) or UNSIGNED(masterhresp)=UNSIGNED(H_SPLIT)) ) then
                    need_retry <= '1' ;
                elsif (    data_bus_owned='1' 
                       and masterhready  ='1' 
                       and (reading='1' or writing='1')
                       and (UNSIGNED(masterhresp)=UNSIGNED(H_OKAY) or UNSIGNED(masterhresp) = UNSIGNED(H_ERROR)) ) then
                    need_retry <= '0' ;
                end if ;  
             end if ; 
         end process burst_need_retry ; 
 
         burst_wraps : process (masterhclk, reset)
         begin
            if (   ( masterhclk'event and masterhclk='1')  
                or ( reset'event      and reset='1'     ) ) then 
                if (reset = '1') then
                    wrap           <= '0'   ;
                    original_burst <= "000" ;
                    replay_wrap    <= "000" ;
                elsif (addr_ack = '1') then
                    if (UNSIGNED(burst)=UNSIGNED(H_WRAP4) or UNSIGNED(burst)=UNSIGNED(H_WRAP8) or UNSIGNED(burst)=UNSIGNED(H_WRAP16)) then 
                        wrap       <= '1' ;
                    else
                        wrap       <= '0' ;
                    end if ; 
                    original_burst <= burst;
                    replay_wrap    <= "000" ;
                elsif (    data_bus_owned ='1' 
                       and masterhready  /='1' 
                       and wrap           ='1' 
                       and (UNSIGNED(masterhresp)=UNSIGNED(H_RETRY) or UNSIGNED(masterhresp)=UNSIGNED(H_SPLIT)) ) then
                    replay_wrap <= "001" ;
                end if ; 
            end if ; 
        end process burst_wraps ;

     -- +===========================================================+
     -- |  Compute Wrap Mask and Bound bit processes                |
     -- |                                                           |
     -- |  Used to modify next_masterhaddr_out_r during wrapping    |
     -- |  bursts. First case statement forms a mask based on the   |
     -- |  transfer size. This is then shifted left with '1's       |
     -- |  inserted to form the final mask.                         |
     -- |  E.g. masterhsize_outl == word (3'b010) wrapped at a four | 
     -- |  beat boundary results in wrap_mask set to 10'b0000001111 | 
     -- |  allowing the four lsbs of the address to increment and   |
     -- |  wrap addressing sixteen bytes in total.                  |
     -- +===========================================================+

        computeinitwrapmask : process ( masterhsize_outl )
        begin
            case masterhsize_outl
            is
                when "000"  => init_wrap_mask <= "0000000000" ;
                when "001"  => init_wrap_mask <= "0000000001" ;
                when "010"  => init_wrap_mask <= "0000000011" ;
                when "011"  => init_wrap_mask <= "0000000111" ;
                when "100"  => init_wrap_mask <= "0000001111" ;
                when "101"  => init_wrap_mask <= "0000011111" ;
                when "110"  => init_wrap_mask <= "0000111111" ;
                when "111"  => init_wrap_mask <= "0001111111" ;
                when others => init_wrap_mask <= "0000000000" ;
                               assert false report "error in masterhsize_outl" severity warning;
            end case ;
        end process computeinitwrapmask ; 


        computewrapmask : process ( original_burst, init_wrap_mask )
        begin
            case original_burst
            is
                when H_WRAP4  =>  wrap_mask(9 downto 2) <= init_wrap_mask(7 downto 0) ;
                                  wrap_mask(1 downto 0) <= "11" ;
                when H_WRAP8  =>  wrap_mask(9 downto 3) <= init_wrap_mask(6 downto 0) ;
                                  wrap_mask(2 downto 0) <= "111" ;
                when H_WRAP16 =>  wrap_mask(9 downto 4) <= init_wrap_mask(5 downto 0) ;
                                  wrap_mask(3 downto 0) <= "1111" ;
                when others   =>  wrap_mask             <= "0000000000" ;
            end case ;
        end process computewrapmask ;



        computeinitwrapbound : process ( masterhsize_outl )
        begin
            case masterhsize_outl
            is
                when "000"  => init_wrap_boundary_bit <= "00000001" ;
                when "001"  => init_wrap_boundary_bit <= "00000010" ;
                when "010"  => init_wrap_boundary_bit <= "00000100" ;
                when "011"  => init_wrap_boundary_bit <= "00001000" ;
                when "100"  => init_wrap_boundary_bit <= "00010000" ;
                when "101"  => init_wrap_boundary_bit <= "00100000" ;
                when "110"  => init_wrap_boundary_bit <= "01000000" ;
                when "111"  => init_wrap_boundary_bit <= "10000000" ;
                when others => init_wrap_boundary_bit <= "00000000" ;
                               assert false report "error in masterhsize_outl" severity warning;
            end case ;
        end process computeinitwrapbound ; 

        computewrapbound : process ( original_burst, init_wrap_boundary_bit )
        begin
            case original_burst
            is
                when H_WRAP4  => wrap_boundary_bit(9 downto 2) <= init_wrap_boundary_bit ;
                                 wrap_boundary_bit(1 downto 0) <= "00" ;
                when H_WRAP8  => wrap_boundary_bit(9 downto 3) <= init_wrap_boundary_bit(6 downto 0) ;
                                 wrap_boundary_bit(2 downto 0) <= "000" ;
                when H_WRAP16 => wrap_boundary_bit(9 downto 4) <= init_wrap_boundary_bit(5 downto 0) ;
                                 wrap_boundary_bit(3 downto 0) <= "0000" ;
                when others   => wrap_boundary_bit              <= "00000000000" ;
            end case ;
        end process computewrapbound ;

     -- +============================================================+
     -- | CALCULATE ADDRESS processes                                |
     -- +============================================================+

     -- +------------------------------------------------------------+
     -- | Compute address increment                                  |
     -- |                                                            |
     -- | This code allows for all possibilities by inferring        |
     -- | a 3-to-8 decoder on the transfer size. AHB spec is         |
     -- | unclear how a burst with a transfer size greater           |
     -- | than the bus width should be handled.                      |
     -- +------------------------------------------------------------+

        computeaddressincrement : process ( masterhsize_outl )
        begin
            masterhaddr_out_r_inc                                 <= "00000000" ;
            masterhaddr_out_r_inc(conv_integer(masterhsize_outl)) <= '1'        ;
        end process computeaddressincrement ; 

     -- +------------------------------------------------------------+
     -- | Compute next address                                       |
     -- |                                                            |
     -- | Next address is based on the increment computed from the   |
     -- | transfer size, and the burst type, which may tell us to    |
     -- | wrap. Wrapping is achieved by preserving some of the upper |
     -- | bits through use of wrap_mask.                             |
     -- |                                                            |
     -- | If beat n is retried, we're already putting out the        |
     -- | address for beat n+1 so we need to decrement.              |
     -- +------------------------------------------------------------+

        computeinitnextaddress : process (data_bus_owned, masterhresp, masterhready, 
                                          masterhaddr_out_r, masterhaddr_out_r_inc ) 
            variable temp_init_next_masterhaddr_out_r : std_logic_vector (10 downto 0) ;
        begin
            temp_init_next_masterhaddr_out_r(10)         := '1' ;
            temp_init_next_masterhaddr_out_r(9 downto 0) := masterhaddr_out_r(9 downto 0) ;
            if (data_bus_owned='1' and ((UNSIGNED(masterhresp)=UNSIGNED(H_RETRY)) or (UNSIGNED(masterhresp)=UNSIGNED(H_SPLIT)))) then
                init_next_masterhaddr_out_r <= temp_init_next_masterhaddr_out_r - masterhaddr_out_r_inc;
            else
                init_next_masterhaddr_out_r <= temp_init_next_masterhaddr_out_r + masterhaddr_out_r_inc;
            end if ; 
        end process computeinitnextaddress ; 
  

        computenextaddress : process (original_burst, wrap_mask, masterhaddr_out_r, 
                                      init_next_masterhaddr_out_r ) 
        begin
            if (   (UNSIGNED(original_burst)=UNSIGNED(H_WRAP4) )
                or (UNSIGNED(original_burst)=UNSIGNED(H_WRAP8) )
                or (UNSIGNED(original_burst)=UNSIGNED(H_WRAP16)) ) then
                next_masterhaddr_out_r <=    (wrap_mask and init_next_masterhaddr_out_r(9 downto 0)) 
                                          or (not wrap_mask and masterhaddr_out_r(9 downto 0)) ;
            else
                next_masterhaddr_out_r <= init_next_masterhaddr_out_r (9 downto 0) ;
            end if ;
        end process computenextaddress ; 

        break_wrap <=       replay_wrap(1)
                      and ( ur_OR(init_next_masterhaddr_out_r and wrap_boundary_bit) xor ur_OR(masterhaddr_out_r(10 downto 0) and wrap_boundary_bit)  ) ;


     -- +------------------------------------------------------------+
     -- | Address Generation                                         |
     -- |                                                            |
     -- | AHB address has to track the changing address during       |
     -- | bursts. next_masterhaddr_out_r computes the next address.  | 
     -- |                                                            |
     -- | NOTE: It is incumbent upon the command file not to attempt |
     -- | a transaction that would cross a 1Kbyte address boundary.  |
     -- |                                                            |
     -- | Address is normally updated after each address phase. It   |
     -- | is also updated during the second cycle of a two cycle     |
     -- | retry or split response to rewind the address and allow    |
     -- | the transaction to be replayed.                            |
     -- +------------------------------------------------------------+

        addressgeneration : process (masterhclk, reset)
        begin
            if (   ( masterhclk'event and masterhclk='1')  
                or ( reset'event      and reset='1'     ) ) then 
                if (reset='1') then
                    masterhaddr_out_r <= (OTHERS => '0' ) ;
                elsif (addr_ack='1') then
                    masterhaddr_out_r <= start_address ;
                elsif (    data_bus_owned ='1'
                       and masterhready   ='1' 
                       and (UNSIGNED(masterhresp)=UNSIGNED(H_RETRY) or UNSIGNED(masterhresp)=UNSIGNED(H_SPLIT)) ) then 
                    masterhaddr_out_r(9 downto 0) <= next_masterhaddr_out_r ;
                elsif (    address_bus_owned ='1'
                       and masterhready      ='1'
                       and (UNSIGNED(masterhtrans_out_r)=UNSIGNED(H_NONSEQ) or UNSIGNED(masterhtrans_out_r)=UNSIGNED(H_SEQ)) ) then
                    masterhaddr_out_r(9 downto 0) <= next_masterhaddr_out_r ;
                end if ; 
            end if; 
        end process addressgeneration ;

     -- +============================================================+
     -- | WRITEDATA processes                                        |
     -- |                                                            |
     -- | If generate_data is negated then initial data is taken     |
     -- | from data input. If generate_data is asserted then data is |
     -- | generated from the address offset to match that expected   |
     -- | by the checkers.                                           |
     -- |                                                            |
     -- | The expected data and the transaction number follow the    |
     -- | write data.                                                |
     -- |                                                            |
     -- | At the end of a burst data is set to X so we can ensure    |
     -- | nothing is relying on invalid data.                        |
     -- +============================================================+

        writedatapipeandretry: process (masterhclk)
        begin
            if ( masterhclk'event and masterhclk='1') then
                if (    data_bus_owned  ='1' 
                    and masterhready   /='1' 
                    and (UNSIGNED(masterhresp)=UNSIGNED(H_RETRY) or UNSIGNED(masterhresp)=UNSIGNED(H_SPLIT)) ) then
                    masterhwdata_out_r_retry <= masterhwdata_out_r ;
                elsif (addr_ack='1' or data_ack='1') then
                    masterhwdata_out_r_pipe  <= data ;
                end if ;
            end if ; 
        end process writedatapipeandretry ;

        addr_offset(7 downto 2) <= masterhaddr_out_r (7 downto 2) ;
        addr_offset(1 downto 0) <= "00" ;      

        writedata: process (masterhclk, reset)
        begin
            if (   ( masterhclk'event and masterhclk='1')  
                or ( reset'event      and reset='1'     ) ) then 
                if (reset='1') then 
                    masterhwdata_out_r <= (OTHERS=> '0') ;
                elsif (address_bus_owned /='1' and masterhready='1') then
                    masterhwdata_out_r <= (OTHERS=> '0') ;
                elsif (masterhready='1' and generate_data /='1') then
                    if (address_bus_owned='1' and masterhwrite_out_r='1' and need_retry='1' and trans_end/='1') then
                        masterhwdata_out_r <= masterhwdata_out_r_retry;
                    elsif (address_bus_owned='1' and masterhwrite_out_r='1' and UNSIGNED(masterhtrans_out_r)=UNSIGNED(H_NONSEQ)) then
                        masterhwdata_out_r <= masterhwdata_out_r_pipe ; 
                    elsif (UNSIGNED(length) = 0 ) then
                        masterhwdata_out_r <= (OTHERS=> '0') ;
                    elsif (address_bus_owned='1' and masterhwrite_out_r='1' and UNSIGNED(masterhtrans_out_r)=UNSIGNED(H_SEQ)) then
                        masterhwdata_out_r <= masterhwdata_out_r_pipe; 
                    else
                        masterhwdata_out_r <= (OTHERS=> '0') ;
                    end if ;
                elsif (masterhready='1' and generate_data='1') then
                    if (address_bus_owned='1' and masterhwrite_out_r='1' and UNSIGNED(masterhtrans_out_r)=UNSIGNED(H_NONSEQ)) then
                        masterhwdata_out_r (31 downto 24) <= addr_offset ;
                        masterhwdata_out_r (23 downto 16) <= addr_offset ;
                        masterhwdata_out_r (15 downto  8) <= addr_offset ;
                        masterhwdata_out_r ( 7 downto  0) <= addr_offset ;
                    elsif (UNSIGNED(length) = 0 ) then
                        masterhwdata_out_r <= (OTHERS=> '0') ;
                    elsif (address_bus_owned='1' and masterhwrite_out_r='1' and UNSIGNED(masterhtrans_out_r)=UNSIGNED(H_SEQ)) then
                        masterhwdata_out_r (31 downto 24) <= addr_offset ;
                        masterhwdata_out_r (23 downto 16) <= addr_offset ;
                        masterhwdata_out_r (15 downto  8) <= addr_offset ;
                        masterhwdata_out_r ( 7 downto  0) <= addr_offset ;
                    end if ;
                end if ; 
            end if ; 
        end process writedata ;

     -- +================================================================+
     -- | Transaction Details processes                                  |
     -- |                                                                |
     -- | The transactor pipeline consists of four stages                |
     -- |                                                                |
     -- |    nextTrans - the next transaction from the store             |
     -- | controlTrans - the current control / address stage transaction |
     -- |    dataTrans - the data stage transaction                      |
     -- |  reportTrans - the completed stage for reporting               |
     -- |                                                                |
     -- |  controlTrans is updated from nextTrans when a new transaction |
     -- |  begins or from dataTrans in the case of split/retry           |
     -- +================================================================+

        transdetails : process (masterhclk)
        begin 
            if ( masterhclk'event and masterhclk='1') then
                if (    data_bus_owned ='1' 
                    and masterhready /='1'
                    and (UNSIGNED(masterhresp)=UNSIGNED(H_RETRY) or UNSIGNED(masterhresp)=UNSIGNED(H_SPLIT)) ) then
                    retryTrans   <= dataTrans ;
                elsif (addr_ack='1' or data_ack='1') then
                    controlTrans <= nextTrans ;
                end if ;
            end if ;
        end process transdetails ;

        setdatatransdetails : process (masterhclk, reset)
        begin 
            if (   ( masterhclk'event and masterhclk='1')  
                or ( reset'event      and reset='1'     ) ) then 
                if (    address_bus_owned = '1' 
                    and masterhready = '1' 
                    and reset /= '1'
                    and (need_retry/='1' or trans_end='1') ) then

                    dataTrans                                             <= controlTrans       ;
                    dataTrans (Trns_ADDR_b      downto Trns_ADDR_l     )  <= masterhaddr_out_r  ;
                    dataTrans (Trns_WRITE                              )  <= masterhwrite_out_r ;
                    dataTrans (Trns_LOCK                               )  <= masterhlock_out    ;
                    dataTrans (Trns_TRANSTYPE_b downto Trns_TRANSTYPE_l)  <= masterhtrans_out_r ;
                    dataTrans (Trns_BURSTTYPE_b downto Trns_BURSTTYPE_l)  <= masterhburst_out_r ;
                    dataTrans (Trns_SIZE_b      downto Trns_SIZE_l     )  <= masterhsize_outl   ;

                elsif (    address_bus_owned = '1' 
                       and masterhready = '1' 
                       and reset /='1' 
                       and need_retry ='1' ) then

                    dataTrans                                             <= retryTrans         ;
                    dataTrans (Trns_ADDR_b      downto Trns_ADDR_l     )  <= masterhaddr_out_r  ;
                    dataTrans (Trns_WRITE                              )  <= masterhwrite_out_r ;
                    dataTrans (Trns_LOCK                               )  <= masterhlock_out    ;
                    dataTrans (Trns_TRANSTYPE_b downto Trns_TRANSTYPE_l)  <= masterhtrans_out_r ;
                    dataTrans (Trns_BURSTTYPE_b downto Trns_BURSTTYPE_l)  <= masterhburst_out_r ;
                    dataTrans (Trns_SIZE_b      downto Trns_SIZE_l     )  <= masterhsize_outl   ;

                elsif ( (address_bus_owned /= '1' and masterhready='1') or reset='1') then

                    dataTrans                                             <= idleTrans          ;

                end if ; 
            end if ;
        end process setdatatransdetails ;


        setreporttransdetails : process (masterhclk)
        begin 
            if ( masterhclk'event and masterhclk='1') then
                if (trans_end='1' and need_retry /='1') then
                    reportTrans (Trns_RESP_b downto Trns_RESP_l) <= masterhresp;
                    reportTrans (Trns_READ_b downto Trns_READ_l) <= masterhrdata; 
                    reportTrans (Trns_BUSY   downto          0 ) <= dataTrans(Trns_BUSY downto 0);
                elsif (trans_end='1' and need_retry = '1') then
                    reportTrans (Trns_RESP_b downto Trns_RESP_l) <= masterhresp;
                    reportTrans (Trns_READ_b downto Trns_READ_l) <= masterhrdata; 
                    reportTrans (Trns_BUSY   downto          0 ) <= retryTrans(Trns_BUSY downto 0);
                else
                    reportTrans                                  <= idleTrans;
                end if ; 
            end if ;
        end process setreporttransdetails ;  

     -- +------------------+
     -- | masterhlock_out  |
     -- +------------------+
  
        masterhlock_out <= '0' ;
  
-- +--------------------------------------------------------------------+
-- +--------------------------------------------------------------------+

end vital_upcore_atom ; -- apex_20ke_upcore

--
--
--  APEX20KE_JTAGB Model
--
--
LIBRARY IEEE, apex20ke;
use IEEE.std_logic_1164.all;
use apex20ke.atom_pack.all;

ENTITY  apex20ke_jtagb is
    PORT (tms : in std_logic; 
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
end apex20ke_jtagb;

ARCHITECTURE architecture_jtagb of apex20ke_jtagb is
begin

process(tms, tck, tdi, ntrst, tdoutap, tdouser)
begin

end process;

end architecture_jtagb;
