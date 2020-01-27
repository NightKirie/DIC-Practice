
-- package for Boolean vector
--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;

package hssi_pack is

   TYPE boolean_vec IS ARRAY (0 to 3) of BOOLEAN;

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

	-- function to convert align_pattern to binary
	function pattern_conversion (align_pattern : string) return std_logic_vector;
 
end hssi_pack;

library IEEE;
use IEEE.std_logic_1164.all;

package body hssi_pack is
	function pattern_conversion 
		( 	
			align_pattern			: string
		)
		return std_logic_vector is
		variable i : integer;
		variable j : integer := 15;
		variable bin_pat : std_logic_vector(15 downto 0) := (OTHERS => '0');
	begin

		for i in 1 to align_pattern'length loop
			case align_pattern(i) is
				when '0' => bin_pat(j) := '0';
				when '1' => bin_pat(j) := '1';
				when others => bin_pat(j) := '0';
			end case;
			j := j - 1;
		end loop;

		return (bin_pat);

	end pattern_conversion;

end hssi_pack;

--IP Functional Simulation Model
--VERSION_BEGIN 4.1 cbx_mgl 2004:06:17:17:30:06:SJ cbx_simgen 2004:06:22:10:53:08:SJ  VERSION_END


-- Legal Notice: © 2003 Altera Corporation. All rights reserved.
-- You may only use these  simulation  model  output files for simulation
-- purposes and expressly not for synthesis or any other purposes (in which
-- event  Altera disclaims all warranties of any kind). Your use of  Altera
-- Corporation's design tools, logic functions and other software and tools,
-- and its AMPP partner logic functions, and any output files any of the
-- foregoing (including device programming or simulation files), and any
-- associated documentation or information  are expressly subject to the
-- terms and conditions of the  Altera Program License Subscription Agreement
-- or other applicable license agreement, including, without limitation, that
-- your use is for the sole purpose of programming logic devices manufactured
-- by Altera and sold by Altera or its authorized distributors.  Please refer
-- to the applicable agreement for further details.


--synopsys translate_off

--synthesis_resources = lut 97 mux21 43 
 LIBRARY ieee;
 USE ieee.std_logic_1164.all;

 ENTITY  stratixgx_8b10b_decoder IS 
	 PORT 
	 ( 
		 clk	:	IN  STD_LOGIC;
		 datain	:	IN  STD_LOGIC_VECTOR (9 DOWNTO 0);
		 datainvalid	:	IN  STD_LOGIC;
		 dataout	:	OUT  STD_LOGIC_VECTOR (7 DOWNTO 0);
		 decdatavalid	:	OUT  STD_LOGIC;
		 disperr	:	OUT  STD_LOGIC;
		 disperrin	:	IN  STD_LOGIC;
		 errdetect	:	OUT  STD_LOGIC;
		 errdetectin	:	IN  STD_LOGIC;
		 kout	:	OUT  STD_LOGIC;
		 patterndetect	:	OUT  STD_LOGIC;
		 patterndetectin	:	IN  STD_LOGIC;
		 rderr	:	OUT  STD_LOGIC;
		 reset	:	IN  STD_LOGIC;
		 syncstatus	:	OUT  STD_LOGIC;
		 syncstatusin	:	IN  STD_LOGIC;
		 tenBdata	:	OUT  STD_LOGIC_VECTOR (9 DOWNTO 0);
		 valid	:	OUT  STD_LOGIC;
		 xgmctrldet	:	OUT  STD_LOGIC;
		 xgmdataout	:	OUT  STD_LOGIC_VECTOR (7 DOWNTO 0);
		 xgmdatavalid	:	OUT  STD_LOGIC;
		 xgmrunningdisp	:	OUT  STD_LOGIC
	 ); 
 END stratixgx_8b10b_decoder;

 ARCHITECTURE RTL OF stratixgx_8b10b_decoder IS

	 ATTRIBUTE synthesis_clearbox : boolean;
	 ATTRIBUTE synthesis_clearbox OF RTL : ARCHITECTURE IS true;
	 SIGNAL	n0i	:	STD_LOGIC := '0';
	 SIGNAL	n0l	:	STD_LOGIC := '0';
	 SIGNAL	n0l0l58	:	STD_LOGIC := '1';
	 SIGNAL	n0l0l59	:	STD_LOGIC := '0';
	 SIGNAL	n0l0l60	:	STD_LOGIC := '0';
	 SIGNAL	n0lii55	:	STD_LOGIC := '1';
	 SIGNAL	n0lii56	:	STD_LOGIC := '0';
	 SIGNAL	n0lii57	:	STD_LOGIC := '0';
	 SIGNAL	n0liO52	:	STD_LOGIC := '1';
	 SIGNAL	n0liO53	:	STD_LOGIC := '0';
	 SIGNAL	n0liO54	:	STD_LOGIC := '0';
	 SIGNAL	n0lll49	:	STD_LOGIC := '1';
	 SIGNAL	n0lll50	:	STD_LOGIC := '0';
	 SIGNAL	n0lll51	:	STD_LOGIC := '0';
	 SIGNAL	n0lOi46	:	STD_LOGIC := '1';
	 SIGNAL	n0lOi47	:	STD_LOGIC := '0';
	 SIGNAL	n0lOi48	:	STD_LOGIC := '0';
	 SIGNAL	n0O	:	STD_LOGIC := '0';
	 SIGNAL	n0O0O37	:	STD_LOGIC := '1';
	 SIGNAL	n0O0O38	:	STD_LOGIC := '0';
	 SIGNAL	n0O0O39	:	STD_LOGIC := '0';
	 SIGNAL	n0O1i43	:	STD_LOGIC := '1';
	 SIGNAL	n0O1i44	:	STD_LOGIC := '0';
	 SIGNAL	n0O1i45	:	STD_LOGIC := '0';
	 SIGNAL	n0O1O40	:	STD_LOGIC := '1';
	 SIGNAL	n0O1O41	:	STD_LOGIC := '0';
	 SIGNAL	n0O1O42	:	STD_LOGIC := '0';
	 SIGNAL	n0OiO34	:	STD_LOGIC := '1';
	 SIGNAL	n0OiO35	:	STD_LOGIC := '0';
	 SIGNAL	n0OiO36	:	STD_LOGIC := '0';
	 SIGNAL	n0OlO31	:	STD_LOGIC := '1';
	 SIGNAL	n0OlO32	:	STD_LOGIC := '0';
	 SIGNAL	n0OlO33	:	STD_LOGIC := '0';
	 SIGNAL	n0OOl28	:	STD_LOGIC := '1';
	 SIGNAL	n0OOl29	:	STD_LOGIC := '0';
	 SIGNAL	n0OOl30	:	STD_LOGIC := '0';
	 SIGNAL	n1i	:	STD_LOGIC := '0';
	 SIGNAL	n1l	:	STD_LOGIC := '0';
	 SIGNAL	n1O	:	STD_LOGIC := '0';
	 SIGNAL	ni	:	STD_LOGIC := '0';
	 SIGNAL	ni00l4	:	STD_LOGIC := '1';
	 SIGNAL	ni00l5	:	STD_LOGIC := '0';
	 SIGNAL	ni00l6	:	STD_LOGIC := '0';
	 SIGNAL	ni0il1	:	STD_LOGIC := '1';
	 SIGNAL	ni0il2	:	STD_LOGIC := '0';
	 SIGNAL	ni0il3	:	STD_LOGIC := '0';
	 SIGNAL	ni10l19	:	STD_LOGIC := '1';
	 SIGNAL	ni10l20	:	STD_LOGIC := '0';
	 SIGNAL	ni10l21	:	STD_LOGIC := '0';
	 SIGNAL	ni11i25	:	STD_LOGIC := '1';
	 SIGNAL	ni11i26	:	STD_LOGIC := '0';
	 SIGNAL	ni11i27	:	STD_LOGIC := '0';
	 SIGNAL	ni11O22	:	STD_LOGIC := '1';
	 SIGNAL	ni11O23	:	STD_LOGIC := '0';
	 SIGNAL	ni11O24	:	STD_LOGIC := '0';
	 SIGNAL	ni1ii16	:	STD_LOGIC := '1';
	 SIGNAL	ni1ii17	:	STD_LOGIC := '0';
	 SIGNAL	ni1ii18	:	STD_LOGIC := '0';
	 SIGNAL	ni1iO13	:	STD_LOGIC := '1';
	 SIGNAL	ni1iO14	:	STD_LOGIC := '0';
	 SIGNAL	ni1iO15	:	STD_LOGIC := '0';
	 SIGNAL	ni1ll10	:	STD_LOGIC := '1';
	 SIGNAL	ni1ll11	:	STD_LOGIC := '0';
	 SIGNAL	ni1ll12	:	STD_LOGIC := '0';
	 SIGNAL	ni1OO7	:	STD_LOGIC := '1';
	 SIGNAL	ni1OO8	:	STD_LOGIC := '0';
	 SIGNAL	ni1OO9	:	STD_LOGIC := '0';
	 SIGNAL	nii	:	STD_LOGIC := '0';
	 SIGNAL	niiO	:	STD_LOGIC := '0';
	 SIGNAL	nil	:	STD_LOGIC := '0';
	 SIGNAL	nili	:	STD_LOGIC := '0';
	 SIGNAL	nill	:	STD_LOGIC := '0';
	 SIGNAL	nilO	:	STD_LOGIC := '0';
	 SIGNAL	niO	:	STD_LOGIC := '0';
	 SIGNAL	niOi	:	STD_LOGIC := '0';
	 SIGNAL	niOl	:	STD_LOGIC := '0';
	 SIGNAL	niOO	:	STD_LOGIC := '0';
	 SIGNAL	nl	:	STD_LOGIC := '0';
	 SIGNAL	nl0i	:	STD_LOGIC := '0';
	 SIGNAL	nl0l	:	STD_LOGIC := '0';
	 SIGNAL	nl0O	:	STD_LOGIC := '0';
	 SIGNAL	nl1i	:	STD_LOGIC := '0';
	 SIGNAL	nl1l	:	STD_LOGIC := '0';
	 SIGNAL	nl1O	:	STD_LOGIC := '0';
	 SIGNAL	nli	:	STD_LOGIC := '0';
	 SIGNAL	nlii	:	STD_LOGIC := '0';
	 SIGNAL	nlil	:	STD_LOGIC := '0';
	 SIGNAL	nliO	:	STD_LOGIC := '0';
	 SIGNAL	nll	:	STD_LOGIC := '0';
	 SIGNAL	nlli	:	STD_LOGIC := '0';
	 SIGNAL	nlll	:	STD_LOGIC := '0';
	 SIGNAL	nllO	:	STD_LOGIC := '0';
	 SIGNAL	nlO	:	STD_LOGIC := '0';
	 SIGNAL	nlOi	:	STD_LOGIC := '0';
	 SIGNAL	nlOl	:	STD_LOGIC := '0';
	 SIGNAL	nlOO	:	STD_LOGIC := '0';
	 SIGNAL	nO	:	STD_LOGIC := '0';
	 SIGNAL	wire_niO0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl10i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl10l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl10O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl11i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl11l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl11O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli0i_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nli0i_w_lg_dataout129w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nli0l_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nli0l_w_lg_w_lg_w_lg_dataout99w153w157w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0l_w_lg_w_lg_dataout160w164w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0l_w_lg_w_lg_dataout99w153w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0l_w_lg_dataout171w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0l_w_lg_dataout178w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0l_w_lg_dataout203w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0l_w_lg_dataout160w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0l_w_lg_dataout99w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nli0O_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nli0O_w_lg_w_lg_w_lg_dataout100w106w110w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0O_w_lg_w_lg_w_lg_dataout100w130w134w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0O_w_lg_w_lg_w_lg_dataout100w166w170w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0O_w_lg_w_lg_dataout173w177w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0O_w_lg_w_lg_dataout148w152w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0O_w_lg_w_lg_dataout136w140w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0O_w_lg_w_lg_dataout100w106w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0O_w_lg_w_lg_dataout100w130w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0O_w_lg_w_lg_dataout100w202w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0O_w_lg_w_lg_dataout100w166w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0O_w_lg_w_lg_dataout100w159w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0O_w_lg_dataout173w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0O_w_lg_dataout148w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0O_w_lg_dataout136w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0O_w_lg_dataout100w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0O_w_lg_dataout184w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nliii_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nliii_w_lg_dataout82w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nliil_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nliil_w_lg_w_lg_dataout101w105w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliil_w_lg_w_lg_dataout81w83w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliil_w_lg_w_lg_dataout81w193w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliil_w_lg_dataout192w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliil_w_lg_dataout101w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliil_w_lg_dataout81w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliil_w_lg_dataout183w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nlill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlllO_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nlllO_w_lg_w_lg_dataout45w46w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlllO_w_lg_dataout45w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nllOi_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nllOi_w_lg_dataout44w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nllOl_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nllOl_w_lg_dataout53w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n0l1i190w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_ni00i68w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_ni01O67w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_ni0ii69w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_reset1w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_n0O1i145w146w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_ni00l57w58w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_ni0il49w50w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  n0iOO :	STD_LOGIC;
	 SIGNAL  n0l0i :	STD_LOGIC;
	 SIGNAL  n0l1i :	STD_LOGIC;
	 SIGNAL  n0l1l :	STD_LOGIC;
	 SIGNAL  n0l1O :	STD_LOGIC;
	 SIGNAL  n0lOO :	STD_LOGIC;
	 SIGNAL  n0O0l :	STD_LOGIC;
	 SIGNAL  n0Oil :	STD_LOGIC;
	 SIGNAL  n0Oll :	STD_LOGIC;
	 SIGNAL  ni00i :	STD_LOGIC;
	 SIGNAL  ni01l :	STD_LOGIC;
	 SIGNAL  ni01O :	STD_LOGIC;
	 SIGNAL  ni0ii :	STD_LOGIC;
	 SIGNAL  ni0li :	STD_LOGIC;
	 SIGNAL  ni0Oi :	STD_LOGIC;
	 SIGNAL  ni1Oi :	STD_LOGIC;
	 SIGNAL  ni1Ol :	STD_LOGIC;
	 SIGNAL  w_n0l0l176w :	STD_LOGIC;
	 SIGNAL  w_n0lii169w :	STD_LOGIC;
	 SIGNAL  w_n0liO163w :	STD_LOGIC;
	 SIGNAL  w_n0lll156w :	STD_LOGIC;
	 SIGNAL  w_n0lOi151w :	STD_LOGIC;
	 SIGNAL  w_n0O0O133w :	STD_LOGIC;
	 SIGNAL  w_n0O1i145w :	STD_LOGIC;
	 SIGNAL  w_n0O1O139w :	STD_LOGIC;
	 SIGNAL  w_n0OiO127w :	STD_LOGIC;
	 SIGNAL  w_n0OlO119w :	STD_LOGIC;
	 SIGNAL  w_n0OOl114w :	STD_LOGIC;
	 SIGNAL  w_ni00l57w :	STD_LOGIC;
	 SIGNAL  w_ni0il49w :	STD_LOGIC;
	 SIGNAL  w_ni10l96w :	STD_LOGIC;
	 SIGNAL  w_ni11i109w :	STD_LOGIC;
	 SIGNAL  w_ni11O104w :	STD_LOGIC;
	 SIGNAL  w_ni1ii91w :	STD_LOGIC;
	 SIGNAL  w_ni1iO86w :	STD_LOGIC;
	 SIGNAL  w_ni1ll73w :	STD_LOGIC;
	 SIGNAL  w_ni1OO65w :	STD_LOGIC;
 BEGIN

	wire_w_lg_n0l1i190w(0) <= NOT n0l1i;
	wire_w_lg_ni00i68w(0) <= NOT ni00i;
	wire_w_lg_ni01O67w(0) <= NOT ni01O;
	wire_w_lg_ni0ii69w(0) <= NOT ni0ii;
	wire_w_lg_reset1w(0) <= NOT reset;
	wire_w_lg_w_n0O1i145w146w(0) <= NOT w_n0O1i145w;
	wire_w_lg_w_ni00l57w58w(0) <= NOT w_ni00l57w;
	wire_w_lg_w_ni0il49w50w(0) <= NOT w_ni0il49w;
	dataout <= ( nl1l & nO & nl & ni & nlO & nl1i & niOO & niOl);
	decdatavalid <= nlOO;
	disperr <= n1i;
	errdetect <= n0l;
	kout <= nili;
	n0iOO <= wire_nliil_w_lg_w_lg_dataout81w83w(0);
	n0l0i <= ((((wire_nli0l_w_lg_dataout99w(0) AND (wire_nli0O_w_lg_dataout100w(0) AND wire_nliil_w_lg_dataout192w(0))) OR (wire_nli0l_w_lg_dataout99w(0) AND (wire_nli0O_w_lg_dataout100w(0) AND wire_nliil_w_lg_w_lg_dataout81w193w(0)))) OR (wire_nli0l_w_lg_dataout99w(0) AND (wire_nli0O_dataout AND n0iOO))) OR wire_nli0l_w_lg_dataout203w(0));
	n0l1i <= (wire_nli0O_dataout AND wire_nliii_dataout);
	n0l1l <= (wire_nli0O_w_lg_dataout100w(0) AND wire_nliii_w_lg_dataout82w(0));
	n0l1O <= (((wire_nli0i_w_lg_dataout129w(0) AND (((((((wire_nli0l_w_lg_dataout99w(0) AND wire_nli0O_w_lg_w_lg_w_lg_dataout100w130w134w(0)) OR (wire_nli0l_w_lg_dataout99w(0) AND wire_nli0O_w_lg_w_lg_dataout136w140w(0))) OR wire_w_lg_w_n0O1i145w146w(0)) OR wire_nli0l_w_lg_w_lg_w_lg_dataout99w153w157w(0)) OR wire_nli0l_w_lg_w_lg_dataout160w164w(0)) OR wire_nli0l_w_lg_dataout171w(0)) OR wire_nli0l_w_lg_dataout178w(0))) OR (wire_nli0i_dataout AND n0l0i)) AND wire_nli0O_w_lg_dataout184w(0));
	n0lOO <= wire_nliil_w_lg_w_lg_dataout81w193w(0);
	n0O0l <= wire_nliil_w_lg_dataout192w(0);
	n0Oil <= ((wire_nli0i_dataout AND ((wire_nliil_dataout XOR wire_nliii_dataout) AND (wire_nli0l_dataout XOR wire_nli0O_dataout))) AND w_n0OiO127w);
	n0Oll <= ((wire_nli0i_dataout AND ((wire_nli0l_w_lg_dataout99w(0) AND wire_nli0O_w_lg_w_lg_w_lg_dataout100w106w110w(0)) AND w_n0OOl114w)) AND w_n0OlO119w);
	ni00i <= (((wire_nlllO_dataout OR wire_nllOi_dataout) OR wire_nllOl_w_lg_dataout53w(0)) OR wire_w_lg_w_ni00l57w58w(0));
	ni01l <= (wire_nli0i_dataout AND ((wire_nli0l_dataout AND ((wire_nli0O_dataout AND (wire_nliil_w_lg_w_lg_dataout81w83w(0) AND w_ni1iO86w)) AND w_ni1ii91w)) AND w_ni10l96w));
	ni01O <= (datain(7) XOR datain(6));
	ni0ii <= (wire_nlllO_w_lg_w_lg_dataout45w46w(0) OR wire_w_lg_w_ni0il49w50w(0));
	ni0li <= (ni01l OR ((wire_w_lg_ni00i68w(0) AND ni1Oi) AND w_ni1ll73w));
	ni0Oi <= clk;
	ni1Oi <= (wire_nli0i_w_lg_dataout129w(0) AND n0l0i);
	ni1Ol <= (((NOT datain(5)) AND ni01l) AND w_ni1OO65w);
	patterndetect <= n1l;
	rderr <= n0i;
	syncstatus <= n1O;
	tenBdata <= ( nllO & nlll & nlli & nliO & nlil & nlii & nl0O & nl0l & nl0i & nl1O);
	valid <= n0O;
	w_n0l0l176w <= n0l0l60;
	w_n0lii169w <= n0lii57;
	w_n0liO163w <= n0liO54;
	w_n0lll156w <= n0lll51;
	w_n0lOi151w <= n0lOi48;
	w_n0O0O133w <= n0O0O39;
	w_n0O1i145w <= n0O1i45;
	w_n0O1O139w <= n0O1O42;
	w_n0OiO127w <= n0OiO36;
	w_n0OlO119w <= n0OlO33;
	w_n0OOl114w <= n0OOl30;
	w_ni00l57w <= ni00l6;
	w_ni0il49w <= ni0il3;
	w_ni10l96w <= ni10l21;
	w_ni11i109w <= ni11i27;
	w_ni11O104w <= ni11O24;
	w_ni1ii91w <= ni1ii18;
	w_ni1iO86w <= ni1iO15;
	w_ni1ll73w <= ni1ll12;
	w_ni1OO65w <= ni1OO9;
	xgmctrldet <= niiO;
	xgmdataout <= ( nll & nli & niO & nil & nii & niOi & nilO & nill);
	xgmdatavalid <= nlOl;
	xgmrunningdisp <= nlOi;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN n0i <= '0';
		ELSIF (clk = '1' AND clk'event) THEN n0i <= disperrin;
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN n0l <= '0';
		ELSIF (clk = '1' AND clk'event) THEN n0l <= errdetectin;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN n0l0l58 <= n0l0l59;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN n0l0l59 <= n0l0l58;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN n0l0l60 <= (n0l0l59 XOR n0l0l58);
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN n0lii55 <= n0lii56;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN n0lii56 <= n0lii55;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN n0lii57 <= (n0lii56 XOR n0lii55);
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN n0liO52 <= n0liO53;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN n0liO53 <= n0liO52;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN n0liO54 <= (n0liO53 XOR n0liO52);
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN n0lll49 <= n0lll50;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN n0lll50 <= n0lll49;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN n0lll51 <= (n0lll50 XOR n0lll49);
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN n0lOi46 <= n0lOi47;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN n0lOi47 <= n0lOi46;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN n0lOi48 <= (n0lOi47 XOR n0lOi46);
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN n0O <= '0';
		ELSIF (clk = '1' AND clk'event) THEN n0O <= datainvalid;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN n0O0O37 <= n0O0O38;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN n0O0O38 <= n0O0O37;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN n0O0O39 <= (n0O0O38 XOR n0O0O37);
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN n0O1i43 <= n0O1i44;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN n0O1i44 <= n0O1i43;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN n0O1i45 <= (n0O1i44 XOR n0O1i43);
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN n0O1O40 <= n0O1O41;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN n0O1O41 <= n0O1O40;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN n0O1O42 <= (n0O1O41 XOR n0O1O40);
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN n0OiO34 <= n0OiO35;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN n0OiO35 <= n0OiO34;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN n0OiO36 <= (n0OiO35 XOR n0OiO34);
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN n0OlO31 <= n0OlO32;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN n0OlO32 <= n0OlO31;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN n0OlO33 <= (n0OlO32 XOR n0OlO31);
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN n0OOl28 <= n0OOl29;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN n0OOl29 <= n0OOl28;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN n0OOl30 <= (n0OOl29 XOR n0OOl28);
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN n1i <= '0';
		ELSIF (clk = '1' AND clk'event) THEN n1i <= disperrin;
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN n1l <= '0';
		ELSIF (clk = '1' AND clk'event) THEN n1l <= patterndetectin;
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN n1O <= '0';
		ELSIF (clk = '1' AND clk'event) THEN n1O <= syncstatusin;
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN ni <= '0';
		ELSIF (clk = '1' AND clk'event) THEN ni <= wire_niO0i_dataout;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN ni00l4 <= ni00l5;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN ni00l5 <= ni00l4;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN ni00l6 <= (ni00l5 XOR ni00l4);
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN ni0il1 <= ni0il2;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN ni0il2 <= ni0il1;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN ni0il3 <= (ni0il2 XOR ni0il1);
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN ni10l19 <= ni10l20;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN ni10l20 <= ni10l19;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN ni10l21 <= (ni10l20 XOR ni10l19);
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN ni11i25 <= ni11i26;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN ni11i26 <= ni11i25;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN ni11i27 <= (ni11i26 XOR ni11i25);
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN ni11O22 <= ni11O23;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN ni11O23 <= ni11O22;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN ni11O24 <= (ni11O23 XOR ni11O22);
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN ni1ii16 <= ni1ii17;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN ni1ii17 <= ni1ii16;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN ni1ii18 <= (ni1ii17 XOR ni1ii16);
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN ni1iO13 <= ni1iO14;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN ni1iO14 <= ni1iO13;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN ni1iO15 <= (ni1iO14 XOR ni1iO13);
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN ni1ll10 <= ni1ll11;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN ni1ll11 <= ni1ll10;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN ni1ll12 <= (ni1ll11 XOR ni1ll10);
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN ni1OO7 <= ni1OO8;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN ni1OO8 <= ni1OO7;
		END IF;
	END PROCESS;
	PROCESS (ni0Oi)
	BEGIN
		IF (ni0Oi = '1' AND ni0Oi'event) THEN ni1OO9 <= (ni1OO8 XOR ni1OO7);
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN nii <= '0';
		ELSIF (clk = '1' AND clk'event) THEN nii <= wire_niO0l_dataout;
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN niiO <= '1';
		ELSIF (clk = '1' AND clk'event) THEN niiO <= ni0li;
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN nil <= '0';
		ELSIF (clk = '1' AND clk'event) THEN nil <= wire_niO0i_dataout;
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN nili <= '1';
		ELSIF (clk = '1' AND clk'event) THEN nili <= ni0li;
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN nill <= '1';
		ELSIF (clk = '1' AND clk'event) THEN nill <= wire_niOil_dataout;
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN nilO <= '1';
		ELSIF (clk = '1' AND clk'event) THEN nilO <= wire_niOii_dataout;
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN niO <= '0';
		ELSIF (clk = '1' AND clk'event) THEN niO <= wire_nliOi_dataout;
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN niOi <= '1';
		ELSIF (clk = '1' AND clk'event) THEN niOi <= wire_niO0O_dataout;
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN niOl <= '1';
		ELSIF (clk = '1' AND clk'event) THEN niOl <= wire_niOil_dataout;
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN niOO <= '1';
		ELSIF (clk = '1' AND clk'event) THEN niOO <= wire_niOii_dataout;
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN nl <= '0';
		ELSIF (clk = '1' AND clk'event) THEN nl <= wire_nliOi_dataout;
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN nl0i <= '0';
		ELSIF (clk = '1' AND clk'event) THEN nl0i <= datain(1);
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN nl0l <= '0';
		ELSIF (clk = '1' AND clk'event) THEN nl0l <= datain(2);
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN nl0O <= '0';
		ELSIF (clk = '1' AND clk'event) THEN nl0O <= datain(3);
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN nl1i <= '1';
		ELSIF (clk = '1' AND clk'event) THEN nl1i <= wire_niO0O_dataout;
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN nl1l <= '0';
		ELSIF (clk = '1' AND clk'event) THEN nl1l <= wire_nlill_dataout;
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN nl1O <= '0';
		ELSIF (clk = '1' AND clk'event) THEN nl1O <= datain(0);
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN nli <= '0';
		ELSIF (clk = '1' AND clk'event) THEN nli <= wire_nlilO_dataout;
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN nlii <= '0';
		ELSIF (clk = '1' AND clk'event) THEN nlii <= datain(4);
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN nlil <= '0';
		ELSIF (clk = '1' AND clk'event) THEN nlil <= datain(5);
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN nliO <= '0';
		ELSIF (clk = '1' AND clk'event) THEN nliO <= datain(6);
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN nll <= '0';
		ELSIF (clk = '1' AND clk'event) THEN nll <= wire_nlill_dataout;
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN nlli <= '0';
		ELSIF (clk = '1' AND clk'event) THEN nlli <= datain(7);
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN nlll <= '0';
		ELSIF (clk = '1' AND clk'event) THEN nlll <= datain(8);
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN nllO <= '0';
		ELSIF (clk = '1' AND clk'event) THEN nllO <= datain(9);
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN nlO <= '0';
		ELSIF (clk = '1' AND clk'event) THEN nlO <= wire_niO0l_dataout;
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN nlOi <= '0';
		ELSIF (clk = '1' AND clk'event) THEN nlOi <= disperrin;
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN nlOl <= '0';
		ELSIF (clk = '1' AND clk'event) THEN nlOl <= datainvalid;
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN nlOO <= '0';
		ELSIF (clk = '1' AND clk'event) THEN nlOO <= datainvalid;
		END IF;
	END PROCESS;
	PROCESS (clk, reset)
	BEGIN
		IF (reset = '1') THEN nO <= '0';
		ELSIF (clk = '1' AND clk'event) THEN nO <= wire_nlilO_dataout;
		END IF;
	END PROCESS;
	wire_niO0i_dataout <= wire_niOiO_dataout OR ni01l;
	wire_niO0l_dataout <= wire_niOli_dataout OR ni01l;
	wire_niO0O_dataout <= wire_niOll_dataout OR ni01l;
	wire_niOii_dataout <= wire_niOlO_dataout AND NOT(ni01l);
	wire_niOil_dataout <= wire_niOOi_dataout AND NOT(ni01l);
	wire_niOiO_dataout <= wire_niOOl_dataout OR n0Oll;
	wire_niOli_dataout <= wire_niOOO_dataout OR n0Oll;
	wire_niOll_dataout <= wire_nl11i_dataout AND NOT(n0Oll);
	wire_niOlO_dataout <= wire_nl11l_dataout AND NOT(n0Oll);
	wire_niOOi_dataout <= wire_nl11O_dataout AND NOT(n0Oll);
	wire_niOOl_dataout <= wire_nl1li_dataout WHEN n0Oil = '1'  ELSE wire_nl10i_dataout;
	wire_niOOO_dataout <= wire_nl1ll_dataout WHEN n0Oil = '1'  ELSE wire_nl10l_dataout;
	wire_nl10i_dataout <= datain(4) WHEN n0l1O = '1'  ELSE ni1Oi;
	wire_nl10l_dataout <= datain(3) WHEN n0l1O = '1'  ELSE wire_nli0l_w_lg_dataout99w(0);
	wire_nl10O_dataout <= datain(2) WHEN n0l1O = '1'  ELSE wire_nli0O_w_lg_dataout100w(0);
	wire_nl11i_dataout <= wire_nl1ll_dataout WHEN n0Oil = '1'  ELSE wire_nl10O_dataout;
	wire_nl11l_dataout <= wire_nl1ll_dataout WHEN n0Oil = '1'  ELSE wire_nl1ii_dataout;
	wire_nl11O_dataout <= wire_nl1ll_dataout WHEN n0Oil = '1'  ELSE wire_nl1il_dataout;
	wire_nl1ii_dataout <= datain(1) WHEN n0l1O = '1'  ELSE wire_nliii_w_lg_dataout82w(0);
	wire_nl1il_dataout <= datain(0) WHEN n0l1O = '1'  ELSE wire_nliil_w_lg_dataout81w(0);
	wire_nl1li_dataout <= wire_nl1lO_dataout AND NOT(n0l1l);
	wire_nl1ll_dataout <= wire_w_lg_n0l1i190w(0) AND NOT(n0l1l);
	wire_nl1lO_dataout <= (NOT (wire_nli0O_w_lg_dataout100w(0) AND 
		wire_nliii_dataout)) OR n0l1i;
	wire_nli0i_dataout <= datain(4) WHEN datain(5) = '1'  ELSE (NOT datain(4));
	wire_nli0i_w_lg_dataout129w(0) <= NOT wire_nli0i_dataout;
	wire_nli0l_dataout <= datain(3) WHEN datain(5) = '1'  ELSE (NOT datain(3));
	wire_nli0l_w_lg_w_lg_w_lg_dataout99w153w157w(0) <= wire_nli0l_w_lg_w_lg_dataout99w153w(0) AND w_n0lll156w;
	wire_nli0l_w_lg_w_lg_dataout160w164w(0) <= wire_nli0l_w_lg_dataout160w(0) AND w_n0liO163w;
	wire_nli0l_w_lg_w_lg_dataout99w153w(0) <= wire_nli0l_w_lg_dataout99w(0) AND wire_nli0O_w_lg_w_lg_dataout148w152w(0);
	wire_nli0l_w_lg_dataout171w(0) <= wire_nli0l_dataout AND wire_nli0O_w_lg_w_lg_w_lg_dataout100w166w170w(0);
	wire_nli0l_w_lg_dataout178w(0) <= wire_nli0l_dataout AND wire_nli0O_w_lg_w_lg_dataout173w177w(0);
	wire_nli0l_w_lg_dataout203w(0) <= wire_nli0l_dataout AND wire_nli0O_w_lg_w_lg_dataout100w202w(0);
	wire_nli0l_w_lg_dataout160w(0) <= wire_nli0l_dataout AND wire_nli0O_w_lg_w_lg_dataout100w159w(0);
	wire_nli0l_w_lg_dataout99w(0) <= NOT wire_nli0l_dataout;
	wire_nli0O_dataout <= datain(2) WHEN datain(5) = '1'  ELSE (NOT datain(2));
	wire_nli0O_w_lg_w_lg_w_lg_dataout100w106w110w(0) <= wire_nli0O_w_lg_w_lg_dataout100w106w(0) AND w_ni11i109w;
	wire_nli0O_w_lg_w_lg_w_lg_dataout100w130w134w(0) <= wire_nli0O_w_lg_w_lg_dataout100w130w(0) AND w_n0O0O133w;
	wire_nli0O_w_lg_w_lg_w_lg_dataout100w166w170w(0) <= wire_nli0O_w_lg_w_lg_dataout100w166w(0) AND w_n0lii169w;
	wire_nli0O_w_lg_w_lg_dataout173w177w(0) <= wire_nli0O_w_lg_dataout173w(0) AND w_n0l0l176w;
	wire_nli0O_w_lg_w_lg_dataout148w152w(0) <= wire_nli0O_w_lg_dataout148w(0) AND w_n0lOi151w;
	wire_nli0O_w_lg_w_lg_dataout136w140w(0) <= wire_nli0O_w_lg_dataout136w(0) AND w_n0O1O139w;
	wire_nli0O_w_lg_w_lg_dataout100w106w(0) <= wire_nli0O_w_lg_dataout100w(0) AND wire_nliil_w_lg_w_lg_dataout101w105w(0);
	wire_nli0O_w_lg_w_lg_dataout100w130w(0) <= wire_nli0O_w_lg_dataout100w(0) AND wire_nliil_w_lg_dataout101w(0);
	wire_nli0O_w_lg_w_lg_dataout100w202w(0) <= wire_nli0O_w_lg_dataout100w(0) AND n0iOO;
	wire_nli0O_w_lg_w_lg_dataout100w166w(0) <= wire_nli0O_w_lg_dataout100w(0) AND n0lOO;
	wire_nli0O_w_lg_w_lg_dataout100w159w(0) <= wire_nli0O_w_lg_dataout100w(0) AND n0O0l;
	wire_nli0O_w_lg_dataout173w(0) <= wire_nli0O_dataout AND wire_nliil_w_lg_w_lg_dataout81w83w(0);
	wire_nli0O_w_lg_dataout148w(0) <= wire_nli0O_dataout AND n0lOO;
	wire_nli0O_w_lg_dataout136w(0) <= wire_nli0O_dataout AND n0O0l;
	wire_nli0O_w_lg_dataout100w(0) <= NOT wire_nli0O_dataout;
	wire_nli0O_w_lg_dataout184w(0) <= wire_nli0O_dataout OR wire_nliil_w_lg_dataout183w(0);
	wire_nliii_dataout <= datain(1) WHEN datain(5) = '1'  ELSE (NOT datain(1));
	wire_nliii_w_lg_dataout82w(0) <= NOT wire_nliii_dataout;
	wire_nliil_dataout <= datain(0) WHEN datain(5) = '1'  ELSE (NOT datain(0));
	wire_nliil_w_lg_w_lg_dataout101w105w(0) <= wire_nliil_w_lg_dataout101w(0) AND w_ni11O104w;
	wire_nliil_w_lg_w_lg_dataout81w83w(0) <= wire_nliil_w_lg_dataout81w(0) AND wire_nliii_w_lg_dataout82w(0);
	wire_nliil_w_lg_w_lg_dataout81w193w(0) <= wire_nliil_w_lg_dataout81w(0) AND wire_nliii_dataout;
	wire_nliil_w_lg_dataout192w(0) <= wire_nliil_dataout AND wire_nliii_w_lg_dataout82w(0);
	wire_nliil_w_lg_dataout101w(0) <= wire_nliil_dataout AND wire_nliii_dataout;
	wire_nliil_w_lg_dataout81w(0) <= NOT wire_nliil_dataout;
	wire_nliil_w_lg_dataout183w(0) <= wire_nliil_dataout OR wire_nliii_dataout;
	wire_nlill_dataout <= wire_nliOl_dataout AND NOT(wire_w_lg_ni0ii69w(0));
	wire_nlilO_dataout <= wire_nliOO_dataout AND NOT(wire_w_lg_ni0ii69w(0));
	wire_nliOi_dataout <= wire_nll1i_dataout AND NOT(wire_w_lg_ni0ii69w(0));
	wire_nliOl_dataout <= wire_nll1l_dataout OR wire_w_lg_ni00i68w(0);
	wire_nliOO_dataout <= wire_nll1O_dataout OR wire_w_lg_ni00i68w(0);
	wire_nll0i_dataout <= wire_nllOl_dataout WHEN wire_w_lg_ni01O67w(0) = '1'  ELSE wire_nllii_dataout;
	wire_nll0l_dataout <= (NOT datain(8)) WHEN ni1Ol = '1'  ELSE datain(8);
	wire_nll0O_dataout <= (NOT datain(7)) WHEN ni1Ol = '1'  ELSE datain(7);
	wire_nll1i_dataout <= wire_nll0i_dataout OR wire_w_lg_ni00i68w(0);
	wire_nll1l_dataout <= wire_nlllO_dataout WHEN wire_w_lg_ni01O67w(0) = '1'  ELSE wire_nll0l_dataout;
	wire_nll1O_dataout <= wire_nllOi_dataout WHEN wire_w_lg_ni01O67w(0) = '1'  ELSE wire_nll0O_dataout;
	wire_nllii_dataout <= (NOT datain(6)) WHEN ni1Ol = '1'  ELSE datain(6);
	wire_nlllO_dataout <= (NOT datain(8)) WHEN datain(9) = '1'  ELSE datain(8);
	wire_nlllO_w_lg_w_lg_dataout45w46w(0) <= wire_nlllO_w_lg_dataout45w(0) OR wire_nllOl_dataout;
	wire_nlllO_w_lg_dataout45w(0) <= wire_nlllO_dataout OR wire_nllOi_w_lg_dataout44w(0);
	wire_nllOi_dataout <= (NOT datain(7)) WHEN datain(9) = '1'  ELSE datain(7);
	wire_nllOi_w_lg_dataout44w(0) <= NOT wire_nllOi_dataout;
	wire_nllOl_dataout <= (NOT datain(6)) WHEN datain(9) = '1'  ELSE datain(6);
	wire_nllOl_w_lg_dataout53w(0) <= NOT wire_nllOl_dataout;

 END RTL; --stratixgx_8b10b_decoder
--synopsys translate_on
--VALID FILE
--/////////////////////////////////////////////////////////////////////////////
--
--                            STRATIXGX_COMP_FIFO_CORE
--
--/////////////////////////////////////////////////////////////////////////////
 
LIBRARY ieee, stratixgx_gxb,std;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
 
ENTITY stratixgx_comp_fifo_core IS
  GENERIC (
    use_rate_match_fifo     : string  := "true";
    rate_matching_fifo_mode : string  := "xaui";
    use_channel_align       : string  := "true";
    for_engineering_sample_device : string := "true";    
    channel_num             : integer := 0
    );
  PORT (
      reset                   : IN std_logic;   
      writeclk                : IN std_logic;   
      readclk                 : IN std_logic;   
      underflow               : IN std_logic;   
      overflow                : IN std_logic;   
      errdetectin             : IN std_logic;   
      disperrin               : IN std_logic;   
      patterndetectin         : IN std_logic;   
      disablefifowrin         : IN std_logic;   
      disablefifordin         : IN std_logic;   
      re                      : IN std_logic;   
      we                      : IN std_logic;   
      datain                  : IN std_logic_vector(9 DOWNTO 0);   
      datainpre               : IN std_logic_vector(9 DOWNTO 0);   
      syncstatusin            : IN std_logic;   
      disperr                 : OUT std_logic;   
      alignstatus             : IN std_logic;   
      fifordin                : IN std_logic;   
      fifordout               : OUT std_logic;   
      decsync                 : OUT std_logic;   
      fifocntlt5                  : OUT std_logic;   
      fifocntgt9                : OUT std_logic;   
      done                    : OUT std_logic;   
      fifoalmostful           : OUT std_logic;   
      fifofull                : OUT std_logic;   
      fifoalmostempty         : OUT std_logic;   
      fifoempty               : OUT std_logic;   
      alignsyncstatus         : OUT std_logic;   
      smenable                : OUT std_logic;   
      disablefifordout        : OUT std_logic;   
      disablefifowrout        : OUT std_logic;   
      dataout                 : OUT std_logic_vector(9 DOWNTO 0);   
      codevalid               : OUT std_logic;   
      errdetectout            : OUT std_logic;   
      patterndetect           : OUT std_logic;   
      syncstatus              : OUT std_logic);
END stratixgx_comp_fifo_core;
 
ARCHITECTURE arch_stratixgx_comp_fifo_core OF stratixgx_comp_fifo_core IS
 
   SIGNAL ge_xaui_sel              :  std_logic;   
   SIGNAL decsync_1                :  std_logic;   
   SIGNAL fifo_cnt_lt_8                   :  std_logic;   
   SIGNAL fifo_cnt_lt_9                   :  std_logic;   
   SIGNAL fifo_cnt_lt_7                   :  std_logic;   
   SIGNAL fifo_cnt_lt_12                  :  std_logic;   
   SIGNAL fifo_cnt_lt_4                   :  std_logic;   
   SIGNAL fifo_cnt_gt_10                  :  std_logic;   
   SIGNAL fifo_cnt_gt_8                   :  std_logic;   
   SIGNAL fifo_cnt_gt_13                  :  std_logic;   
   SIGNAL fifo_cnt_gt_5                 :  std_logic;   
   SIGNAL fifo_cnt_gt_6                 :  std_logic;   
   SIGNAL almostfull_1             :  std_logic;   
   SIGNAL almostfull_sync          :  std_logic;   
   SIGNAL almostempty_1            :  std_logic;   
   SIGNAL almostempty_sync         :  std_logic;   
   SIGNAL full_1                   :  std_logic;   
   SIGNAL full_sync                :  std_logic;   
   SIGNAL empty_1                  :  std_logic;   
   SIGNAL empty_sync               :  std_logic;   
   SIGNAL rdenable_sync_1          :  std_logic;   
   SIGNAL rdenable_sync            :  std_logic;   
   SIGNAL write_enable_sync        :  std_logic;   
   SIGNAL write_enable_sync_1      :  std_logic;   
   SIGNAL fifo_dec_dly             :  std_logic;   
   SIGNAL count                    :  std_logic_vector(3 DOWNTO 0);   
   SIGNAL count_read               :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL comp_write_d             :  std_logic;   
   SIGNAL comp_write_pre           :  std_logic;   
   SIGNAL comp_write               :  std_logic;   
   SIGNAL write_detect_d           :  std_logic;   
   SIGNAL write_detect_pre         :  std_logic;   
   SIGNAL write_detect             :  std_logic;   
   SIGNAL comp_read_d              :  std_logic;   
   SIGNAL comp_read                :  std_logic;   
   SIGNAL detect_read_d            :  std_logic;   
   SIGNAL detect_read              :  std_logic;   
   SIGNAL comp_read_ext            :  std_logic;   
   SIGNAL read_eco                 :  std_logic;   
   SIGNAL read_eco_dly             :  std_logic;
   SIGNAL reset_fifo_dec           :  std_logic;   
   SIGNAL read_sync_int_1          :  std_logic;   
   SIGNAL read_sync_int            :  std_logic;   
   SIGNAL read_sync                :  std_logic;   
   SIGNAL fifo_dec                 :  std_logic;   
   SIGNAL done_write               :  std_logic;   
   SIGNAL done_read                :  std_logic;   
   SIGNAL underflow_sync_1         :  std_logic;   
   SIGNAL underflow_sync           :  std_logic;   
   SIGNAL done_read_sync_1         :  std_logic;   
   SIGNAL done_read_sync           :  std_logic;   
   SIGNAL alignsyncstatus_sync     :  std_logic;   
   SIGNAL alignstatus_sync_1       :  std_logic;   
   SIGNAL alignstatus_sync         :  std_logic;   
   SIGNAL alignstatus_dly          :  std_logic;   
   SIGNAL re_dly                   :  std_logic;   
   SIGNAL syncstatus_sync_1        :  std_logic;   
   SIGNAL syncstatus_sync          :  std_logic;   
   SIGNAL write_ptr                :  integer := 0 ;   
   SIGNAL read_ptr1                :  integer := 0 ;   
   SIGNAL read_ptr2                :  integer := 0 ;   
   SIGNAL i                        :  integer;   
   SIGNAL j                        :  integer;   
   SIGNAL k                        :  integer;   
   SIGNAL fifo                     :  std_logic_vector(14 * 12 - 1 DOWNTO 0);   
   SIGNAL fifo_errdetectin         :  std_logic;   
   SIGNAL fifo_errdetectin_dly     :  std_logic;   
   SIGNAL fifo_disperrin           :  std_logic;   
   SIGNAL fifo_disperrin_dly       :  std_logic;   
   SIGNAL fifo_patterndetectin     :  std_logic;   
   SIGNAL fifo_patterndetectin_dly :  std_logic;   
   SIGNAL fifo_syncstatusin         :  std_logic;   
   SIGNAL fifo_syncstatusin_dly     :  std_logic;   
   SIGNAL fifo_data_in             :  std_logic_vector(10 DOWNTO 0);   
   SIGNAL fifo_data_in_dly         :  std_logic_vector(10 DOWNTO 0);
   SIGNAL comp_pat1                :  std_logic_vector(11 DOWNTO 0);   
   SIGNAL comp_pat2                :  std_logic_vector(11 DOWNTO 0);   
   SIGNAL fifo_data_in_pre         :  std_logic_vector(12 DOWNTO 0);   
   SIGNAL fifo_data_out1_sync      :  std_logic_vector(13 DOWNTO 0);   
   SIGNAL fifo_data_out1_sync_dly  :  std_logic_vector(13 DOWNTO 0);   
   SIGNAL fifo_data_out1_sync_valid:  std_logic;   
   SIGNAL fifo_data_out2_sync      :  std_logic_vector(13 DOWNTO 0);   
   SIGNAL fifo_data_out1_tmp       :  std_logic_vector(13 DOWNTO 0);   
   SIGNAL fifo_data_out2_tmp       :  std_logic_vector(12 DOWNTO 0);   
   SIGNAL fifo_data_out1           :  std_logic_vector(13 DOWNTO 0);   
   SIGNAL fifo_data_out2           :  std_logic_vector(13 DOWNTO 0);   
   SIGNAL genericfifo_sync_clk2_1  :  std_logic;   
   SIGNAL genericfifo_sync_clk2    :  std_logic;   
   SIGNAL genericfifo_sync_clk1_1  :  std_logic;   
   SIGNAL genericfifo_sync_clk1    :  std_logic;   
   SIGNAL onechannel               :  std_logic;   
   SIGNAL deskewenable             :  std_logic;   
   SIGNAL matchenable              :  std_logic;   
   SIGNAL menable                  :  std_logic;   
   SIGNAL genericfifo              :  std_logic;   
   SIGNAL globalenable             :  std_logic;   
   SIGNAL fifordout_tmp1          :  std_logic;   
   SIGNAL fifoalmostful_tmp2      :  std_logic;   
   SIGNAL fifofull_tmp3           :  std_logic;   
   SIGNAL fifoalmostempty_tmp4    :  std_logic;   
   SIGNAL fifoempty_tmp5          :  std_logic;   
   SIGNAL decsync_tmp6            :  std_logic;   
   SIGNAL fifocntlt5_tmp7             :  std_logic;   
   SIGNAL fifocntgt9_tmp8           :  std_logic;   
   SIGNAL done_tmp9               :  std_logic;   
   SIGNAL alignsyncstatus_tmp10   :  std_logic;   
   SIGNAL smenable_tmp11          :  std_logic;   
   SIGNAL disablefifordout_tmp12  :  std_logic;   
   SIGNAL disablefifowrout_tmp13  :  std_logic;   
   SIGNAL dataout_tmp14           :  std_logic_vector(9 DOWNTO 0);   
   SIGNAL codevalid_tmp15         :  std_logic;   
   SIGNAL errdetectout_tmp16      :  std_logic;   
   SIGNAL syncstatus_tmp17        :  std_logic;   
   SIGNAL patterndetect_tmp18     :  std_logic;   
   SIGNAL disperr_tmp19           :  std_logic;   
   SIGNAL count_less3_tmp         :  std_logic;
   SIGNAL count_2_tmp             :  std_logic;
   SIGNAL count_read_tmp          :  std_logic;
   SIGNAL writeclk_dly            :  std_logic;
   SIGNAL write_done              :  std_logic := '0';
  
BEGIN
   fifordout <= fifordout_tmp1;
   fifoalmostful <= fifoalmostful_tmp2;
   fifofull <= fifofull_tmp3;
   fifoalmostempty <= fifoalmostempty_tmp4;
   fifoempty <= fifoempty_tmp5;
   decsync <= decsync_tmp6;
   fifocntlt5 <= fifocntlt5_tmp7;
   fifocntgt9 <= fifocntgt9_tmp8;
   done <= done_tmp9;
   alignsyncstatus <= alignsyncstatus_tmp10;
   smenable <= smenable_tmp11;
   disablefifordout <= disablefifordout_tmp12;
   disablefifowrout <= disablefifowrout_tmp13;
   dataout <= dataout_tmp14;
   codevalid <= codevalid_tmp15;
   errdetectout <= errdetectout_tmp16;
   syncstatus <= syncstatus_tmp17;
   patterndetect <= patterndetect_tmp18;
   disperr <= disperr_tmp19;
   onechannel <= '1' WHEN (channel_num = 0) ELSE '0' ;
   deskewenable <= '1' WHEN (use_channel_align = "true") ELSE '0' ;
   matchenable <= '1' WHEN (use_rate_match_fifo = "true") ELSE '0' ;
   menable <= matchenable AND NOT deskewenable ;
   genericfifo <= '1' WHEN (rate_matching_fifo_mode = "none") ELSE '0' ;
   globalenable <= matchenable AND deskewenable ;
   ge_xaui_sel <= '1' WHEN (rate_matching_fifo_mode = "gige") ELSE '0' ;

   PROCESS (writeclk)
   BEGIN
     writeclk_dly <= writeclk;
   END PROCESS;

   PROCESS (reset, writeclk_dly)
   BEGIN
      IF (reset = '1') THEN
         comp_write_pre <= '0';    
      ELSIF (writeclk_dly'EVENT AND writeclk_dly = '1') THEN
         IF ((alignsyncstatus_tmp10 AND (write_detect OR NOT ge_xaui_sel)) = '1') THEN
            comp_write_pre <= comp_write_d;    
         ELSE
            comp_write_pre <= '0';    
         END IF;
      END IF;
   END PROCESS;

   PROCESS (reset, writeclk_dly)
   BEGIN
      IF (reset = '1') THEN
         write_detect_pre <= '0';    
      ELSIF (writeclk_dly'EVENT AND writeclk_dly = '1') THEN
         IF ((alignsyncstatus_tmp10 AND ge_xaui_sel) = '1') THEN
            write_detect_pre <= write_detect_d;    
         ELSE
            write_detect_pre <= '0';    
         END IF;
      END IF;
   END PROCESS;

   PROCESS (reset, readclk)
   BEGIN
      IF (reset = '1') THEN
         comp_read <= '0';    
         comp_read_ext <= '0';    
      ELSIF (readclk'EVENT AND readclk = '1') THEN
         comp_read_ext <= (underflow_sync AND comp_read) AND ge_xaui_sel;    
         IF ((alignsyncstatus_sync AND (detect_read OR NOT ge_xaui_sel)) = '1') THEN
            comp_read <= (comp_read_d AND NOT fifo_data_out2_sync(10)) AND NOT fifo_data_out2_sync(12);    
         ELSE
            comp_read <= '0';    
         END IF;
      END IF;
   END PROCESS;

   PROCESS (reset, readclk)
   BEGIN
      IF (reset = '1') THEN
         detect_read <= '0';    
      ELSIF (readclk'EVENT AND readclk = '1') THEN
         IF ((alignsyncstatus_sync AND ge_xaui_sel) = '1') THEN
            detect_read <= (detect_read_d AND NOT fifo_data_out2_sync(10)) AND NOT fifo_data_out2_sync(12);    
         ELSE
            detect_read <= '0';    
         END IF;
      END IF;
   END PROCESS;
   fifo_cnt_lt_4 <= '1' when (count <4) else '0';
   fifocntlt5_tmp7 <= '1' when (count < 5) else '0';
   fifo_cnt_lt_7 <= '1' when (count < 7) else '0';
   fifo_cnt_lt_8 <= '1' when (count < 8) else '0';  -- added in REV-C
   fifo_cnt_lt_9 <= '1' when (count < 9) else '0';
   fifo_cnt_lt_12 <= '1' when (count < 12) else '0';
   fifo_cnt_gt_5 <= '1' when (count > 5) else '0';
   fifo_cnt_gt_6 <= '1' when (count > 6) else '0';  -- added in REV-C
   fifo_cnt_gt_8 <= '1' when (count > 8) else '0';
   fifocntgt9_tmp8 <= '1' when (count > 9) else '0';
   fifo_cnt_gt_10 <= '1' when (count > 10) else '0';
   fifo_cnt_gt_13 <= '1' when (count > 13) else '0';
   disablefifowrout_tmp13 <= disablefifowrin WHEN (globalenable AND NOT onechannel) = '1' ELSE ((overflow AND comp_write) AND NOT done_write) ;

   PROCESS (reset, writeclk_dly)
   BEGIN
      IF (reset = '1') THEN
         count <= "0000";    
      ELSIF (writeclk_dly'EVENT AND writeclk_dly = '1') THEN
         IF (genericfifo_sync_clk1 = '1') THEN
            IF ((write_enable_sync AND NOT decsync_tmp6) = '1') THEN
               count <= count + "0001";    
            ELSE
               IF ((write_enable_sync AND decsync_tmp6) = '1') THEN
                  count <= count - "0010";    
               ELSE
                  IF ((NOT write_enable_sync AND decsync_tmp6) = '1') THEN
                     count <= count - "0011";    
                  ELSE
                     count <= count;    
                  END IF;
               END IF;
            END IF;
         ELSE
            IF (NOT alignsyncstatus_tmp10 = '1') THEN
               count <= "0000";    
            ELSE
               IF ((NOT decsync_tmp6 AND NOT disablefifowrout_tmp13) = '1') THEN
                  count <= count + "0001";    
               ELSE
                  IF ((decsync_tmp6 AND NOT disablefifowrout_tmp13) = '1') THEN
                     count <= count - "0010";    
                  ELSE
                     IF (((NOT ge_xaui_sel AND decsync_tmp6) AND disablefifowrout_tmp13) = '1') THEN
                        count <= count - "0011";    
                     ELSE
                        IF (((ge_xaui_sel AND decsync_tmp6) AND disablefifowrout_tmp13) = '1') THEN
                           count <= count - "0100";    
                        ELSE
                           IF (((ge_xaui_sel AND NOT decsync_tmp6) AND disablefifowrout_tmp13) = '1') THEN
                              count <= count - "0001";    
                           ELSE
                              count <= count;    
                           END IF;
                        END IF;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (reset, writeclk_dly)
   BEGIN
      IF (reset = '1') THEN
         done_write <= '0';    
      ELSIF (writeclk_dly'EVENT AND writeclk_dly = '1') THEN
         done_write <= overflow AND comp_write;    
      END IF;
   END PROCESS;

   PROCESS (reset, writeclk_dly)
   BEGIN
      IF (reset = '1') THEN
         almostfull_1 <= '0';    
      ELSIF (writeclk_dly'EVENT AND writeclk_dly = '1') THEN
         IF (almostfull_1 = '1') THEN
            almostfull_1 <= NOT fifo_cnt_lt_8;    
         ELSE
            almostfull_1 <= fifocntgt9_tmp8;    
         END IF;
      END IF;
   END PROCESS;

   PROCESS (reset, writeclk_dly)
   BEGIN
      IF (reset = '1') THEN
         almostempty_1 <= '1';    
      ELSIF (writeclk_dly'EVENT AND writeclk_dly = '1') THEN
         IF (almostempty_1 = '1') THEN
            almostempty_1 <= NOT fifo_cnt_gt_6;    
         ELSE
            almostempty_1 <= fifocntlt5_tmp7;    
         END IF;
      END IF;
   END PROCESS;

   PROCESS (reset, writeclk_dly)
   BEGIN
      IF (reset = '1') THEN
         full_1 <= '0';    
      ELSIF (writeclk_dly'EVENT AND writeclk_dly = '1') THEN
         IF (full_1 = '1') THEN
            full_1 <= NOT fifo_cnt_lt_12;    
         ELSE
            full_1 <= fifo_cnt_gt_13;    
         END IF;
      END IF;
   END PROCESS;

   PROCESS (reset, writeclk_dly)
   BEGIN
      IF (reset = '1') THEN
         empty_1 <= '1';    
      ELSIF (writeclk_dly'EVENT AND writeclk_dly = '1') THEN
         IF (empty_1 = '1') THEN
            empty_1 <= NOT fifo_cnt_gt_5;    
         ELSE
            empty_1 <= fifo_cnt_lt_4;    
         END IF;
      END IF;
   END PROCESS;
   read_sync <= fifordin WHEN (globalenable AND NOT onechannel) = '1' ELSE fifordout_tmp1 ;
   fifordout_tmp1 <= read_sync_int ;

   count_less3_tmp <= '1' when (count <= 2) else '0';
   count_2_tmp <= '1' when (count = 2) else '0';

   PROCESS (reset, writeclk_dly)
   BEGIN
      IF (reset = '1') THEN
         read_eco <= '0';    
      ELSIF (writeclk_dly'EVENT AND writeclk_dly = '1') THEN
         IF ((read_eco AND count_less3_tmp) = '1') THEN
            read_eco <= '0';    
         ELSE
            IF ((NOT read_eco AND count_2_tmp) = '1') THEN
               read_eco <= '1';    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   alignstatus_dly <= alignstatus after 1 ps;
   read_eco_dly <= read_eco after 1 ps;
   re_dly <= re after 1 ps;

   PROCESS (reset, readclk)
   BEGIN
      IF (reset = '1') THEN
         read_sync_int_1 <= '0';    
         read_sync_int <= '0';    
         underflow_sync_1 <= '0';    
         underflow_sync <= '0';    
         alignstatus_sync_1 <= '0';    
         alignstatus_sync <= '0';    
         syncstatus_sync_1 <= '0';    
         syncstatus_sync <= '0';    
         rdenable_sync_1 <= '0';    
         rdenable_sync <= '0';    
         fifo_data_out1_sync_valid <= '0';    
         fifo_dec_dly <= '0';    
         almostfull_sync <= '0';    
         almostempty_sync <= '1';    
         full_sync <= '0';    
         empty_sync <= '1';    
         fifoalmostful_tmp2 <= '0';    
         fifoalmostempty_tmp4 <= '1';    
         fifofull_tmp3 <= '0';    
         fifoempty_tmp5 <= '1';    
         genericfifo_sync_clk2_1 <= '0';    
         genericfifo_sync_clk2 <= '0';    
      ELSIF (readclk'EVENT AND readclk = '1') THEN
         read_sync_int_1 <= read_eco_dly AND NOT genericfifo_sync_clk2;    
         read_sync_int <= read_sync_int_1;    
         underflow_sync_1 <= underflow;    
         underflow_sync <= underflow_sync_1;    
         alignstatus_sync_1 <= alignstatus_dly;    
         alignstatus_sync <= alignstatus_sync_1;    
         syncstatus_sync_1 <= syncstatusin;    
         syncstatus_sync <= syncstatus_sync_1;    
         rdenable_sync_1 <= re_dly AND genericfifo;    
         rdenable_sync <= rdenable_sync_1;    
         fifo_data_out1_sync_valid <= ((NOT genericfifo_sync_clk2 AND alignsyncstatus_sync) AND read_sync) OR (genericfifo_sync_clk2 AND rdenable_sync);    
         fifo_dec_dly <= fifo_dec;    
         almostfull_sync <= almostfull_1;    
         almostempty_sync <= almostempty_1;    
         full_sync <= full_1;    
         empty_sync <= empty_1;    
         fifoalmostful_tmp2 <= almostfull_sync;    
         fifoalmostempty_tmp4 <= almostempty_sync;    
         fifofull_tmp3 <= full_sync;    
         fifoempty_tmp5 <= empty_sync;    
         genericfifo_sync_clk2_1 <= genericfifo;    
         genericfifo_sync_clk2 <= genericfifo_sync_clk2_1;    
      END IF;
   END PROCESS;
   disablefifordout_tmp12 <= disablefifordin WHEN (globalenable AND NOT onechannel) = '1' ELSE ((underflow_sync AND (comp_read OR comp_read_ext)) AND NOT done_read) ;

   PROCESS (reset, readclk)
   BEGIN
      IF (reset = '1') THEN
         count_read <= "00";    
      ELSIF (readclk'EVENT AND readclk = '1') THEN
         IF ((NOT alignsyncstatus_sync AND NOT genericfifo_sync_clk2) = '1') THEN
            count_read <= "00";    
         ELSE
            IF (((read_sync AND NOT disablefifordout_tmp12) OR rdenable_sync) = '1') THEN
               IF (count_read = 2) THEN
                  count_read <= "00";    
               ELSE
                  count_read <= count_read + "01";    
               END IF;
            ELSE
               count_read <= count_read;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (reset, readclk)
   BEGIN
      IF (reset = '1') THEN
         done_read <= '0';    
      ELSIF (readclk'EVENT AND readclk = '1') THEN
         IF ((underflow_sync AND ((comp_read AND NOT ge_xaui_sel) OR (comp_read_ext AND ge_xaui_sel))) = '1') THEN
            done_read <= '1';    
         ELSE
            IF (NOT underflow_sync = '1') THEN
               done_read <= '0';    
            ELSE
               done_read <= done_read;    
            END IF;
         END IF;
      END IF;
   END PROCESS;
   reset_fifo_dec <= reset OR NOT (NOT fifo_dec_dly OR readclk) ;

   -- count_read_tmp <= '1' when (count_read = 2) else '0';
   count_read_tmp <= '1' when (count_read = 1) else '0';

   PROCESS (reset_fifo_dec, readclk)
   BEGIN
      IF (reset_fifo_dec = '1') THEN
         fifo_dec <= '0';    
      ELSIF (readclk'EVENT AND readclk = '1') THEN
         IF ((count_read_tmp AND ((NOT disablefifordout_tmp12 AND NOT genericfifo_sync_clk2) OR (rdenable_sync AND genericfifo_sync_clk2))) = '1') THEN
            fifo_dec <= '1';    
         ELSE
            fifo_dec <= fifo_dec;    
         END IF;
      END IF;
   END PROCESS;

   PROCESS (reset, writeclk_dly)
   BEGIN
      IF (reset = '1') THEN
         decsync_1 <= '0';    
         decsync_tmp6 <= '0';    
         done_read_sync_1 <= '0';    
         done_read_sync <= '0';    
         write_enable_sync_1 <= '0';    
         write_enable_sync <= '0';    
         genericfifo_sync_clk1_1 <= '0';    
         genericfifo_sync_clk1 <= '0';    
      ELSIF (writeclk_dly'EVENT AND writeclk_dly = '1') THEN
         decsync_1 <= fifo_dec;    
         decsync_tmp6 <= decsync_1 AND NOT decsync_tmp6;    
         done_read_sync_1 <= done_read;    
         done_read_sync <= done_read_sync_1;    
         write_enable_sync_1 <= we AND genericfifo;    
         write_enable_sync <= write_enable_sync_1;    
         genericfifo_sync_clk1_1 <= genericfifo;    
         genericfifo_sync_clk1 <= genericfifo_sync_clk1_1;    
      END IF;
   END PROCESS;

   PROCESS (reset, writeclk_dly)
   BEGIN
      IF (reset = '1') then 
         write_ptr <= 0;
         write_done <= '0';
      ELSIF (writeclk_dly'EVENT AND writeclk_dly = '1') THEN
         IF ((NOT alignsyncstatus_tmp10 AND NOT genericfifo_sync_clk1) = '1') THEN
            write_ptr <= 0;    
         ELSE
            IF (((write_enable_sync AND genericfifo_sync_clk1) OR (NOT disablefifowrout_tmp13 AND NOT genericfifo_sync_clk1)) = '1') THEN
               IF (write_ptr /= 11) THEN
                  write_ptr <= write_ptr + 1;    
               ELSE
                  write_ptr <= 0;    
               END IF;
            ELSE
               IF (((disablefifowrout_tmp13 AND ge_xaui_sel) AND NOT genericfifo_sync_clk1) = '1') THEN
                  IF (write_ptr /= 0) THEN
                     write_ptr <= write_ptr - 1;    
                  ELSE
                     write_ptr <= 11;    
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (reset, readclk)
   BEGIN
      IF (reset = '1') THEN
         read_ptr1 <= 0;    
         read_ptr2 <= 1;    
      ELSIF (readclk'EVENT AND readclk = '1') THEN
         IF ((NOT alignsyncstatus_sync AND NOT genericfifo_sync_clk2) = '1') THEN
            read_ptr1 <= 0;    
            read_ptr2 <= 1;    
         ELSE
            IF ((((read_sync AND NOT disablefifordout_tmp12) AND NOT genericfifo_sync_clk2) OR (rdenable_sync AND genericfifo_sync_clk2)) = '1') THEN
               IF (read_ptr1 /= 11) THEN
                  read_ptr1 <= read_ptr1 + 1;    
               ELSE
                  read_ptr1 <= 0;    
               END IF;
               IF (read_ptr2 /= 11) THEN
                  read_ptr2 <= read_ptr2 + 1;    
               ELSE
                  read_ptr2 <= 0;    
               END IF;
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS(fifo_data_in)
   BEGIN
       fifo_data_in_dly <= fifo_data_in;
   END PROCESS;

   PROCESS(fifo_errdetectin, fifo_disperrin, fifo_patterndetectin, fifo_syncstatusin)
   BEGIN
       fifo_errdetectin_dly <= fifo_errdetectin;
	   fifo_disperrin_dly <= fifo_disperrin;
	   fifo_patterndetectin_dly <= fifo_patterndetectin;
	   fifo_syncstatusin_dly <= fifo_syncstatusin;
   END PROCESS;

   PROCESS(write_ptr, fifo_data_in_dly, fifo_errdetectin_dly, fifo_syncstatusin_dly, fifo_disperrin_dly, fifo_patterndetectin_dly, reset)
     VARIABLE fifo_tmp  : std_logic_vector(14 * 12 - 1 DOWNTO 0);
   BEGIN
      IF (reset = '1') THEN
          FOR i IN 0 TO (168 - 1) LOOP
             fifo_tmp(i) := '0';    
          END LOOP;
	  ELSE
          FOR i IN 0 TO (10 - 1) LOOP
             fifo_tmp(write_ptr * 14 + i) := fifo_data_in_dly(i);    
          END LOOP;
          fifo_tmp(write_ptr * 14 + 10) := fifo_errdetectin_dly;    
          fifo_tmp(write_ptr * 14 + 11) := fifo_syncstatusin_dly;    
          fifo_tmp(write_ptr * 14 + 12) := fifo_disperrin_dly;    
          fifo_tmp(write_ptr * 14 + 13) := fifo_patterndetectin_dly;
	  END IF;
      fifo <= fifo_tmp;
   END PROCESS;

   PROCESS (writeclk_dly, reset, read_ptr1, read_ptr2)
      VARIABLE fifo_data_out1_tmp_tmp21  : std_logic_vector(13 DOWNTO 0);
      VARIABLE fifo_data_out2_tmp_tmp22  : std_logic_vector(12 DOWNTO 0);
   BEGIN
      IF ((writeclk_dly = '1') OR read_ptr1'event OR read_ptr2'event) THEN
         FOR j IN 0 TO (14 - 1) LOOP
            fifo_data_out1_tmp_tmp21(j) := fifo(read_ptr1 * 14 + j);    
         END LOOP;
         FOR k IN 0 TO (13 - 1) LOOP
            fifo_data_out2_tmp_tmp22(k) := fifo(read_ptr2 * 14 + k);    
         END LOOP;
      END IF;
      fifo_data_out1_tmp <= fifo_data_out1_tmp_tmp21;
      fifo_data_out2_tmp <= fifo_data_out2_tmp_tmp22;
   END PROCESS;

   fifo_data_out1 <= fifo_data_out1_tmp after 1 ps;
   fifo_data_out2 <= '0' & fifo_data_out2_tmp after 1 ps;

   PROCESS (reset, readclk)
   BEGIN
      IF (reset = '1') THEN
         fifo_data_out1_sync <= "00000000000000";    
         fifo_data_out1_sync_dly <= "00000000000000";    
         fifo_data_out2_sync <= "00000000000000";    
      ELSIF (readclk'EVENT AND readclk = '1') THEN
         IF (ge_xaui_sel = '1') THEN
            fifo_data_out1_sync_dly <= fifo_data_out1_sync;    
         ELSE
            fifo_data_out1_sync_dly <= "00000000000000";    
         END IF;
         IF (NOT disablefifordout_tmp12 = '1') THEN
            fifo_data_out1_sync <= fifo_data_out1;    
            fifo_data_out2_sync <= fifo_data_out2;    
         ELSE
            IF (ge_xaui_sel = '1') THEN
               fifo_data_out1_sync <= fifo_data_out1_sync_dly;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   done_tmp9 <= done_write OR done_read_sync ;
   smenable_tmp11 <= '1' WHEN ((menable OR (globalenable AND onechannel)) AND NOT genericfifo_sync_clk1) = '1' ELSE '0' ;
   comp_pat1 <= "001010110110" WHEN (ge_xaui_sel) = '1' ELSE "000010111100" ;
   comp_pat2 <= "001101000011" WHEN (ge_xaui_sel) = '0' ELSE "001010001010" WHEN (for_engineering_sample_device) = "true" ELSE "001010001001";
   comp_write_d <= '1' WHEN (fifo_data_in_pre(9 DOWNTO 0) = CONV_INTEGER(comp_pat1)) OR (fifo_data_in_pre(9 DOWNTO 0) = CONV_INTEGER(comp_pat2)) ELSE '0' ;
   comp_read_d <= '1' WHEN (fifo_data_out2_sync(9 DOWNTO 0) = CONV_INTEGER(comp_pat1)) OR (fifo_data_out2_sync(9 DOWNTO 0) = CONV_INTEGER(comp_pat2)) ELSE '0' ;
   write_detect_d <= '1' WHEN (fifo_data_in_pre(9 DOWNTO 0) = CONV_INTEGER("0101111100")) OR (fifo_data_in_pre(9 DOWNTO 0) = CONV_INTEGER("1010000011")) ELSE '0' ;
   detect_read_d <= '1' WHEN (fifo_data_out2_sync(9 DOWNTO 0) = CONV_INTEGER("0101111100")) OR (fifo_data_out2_sync(9 DOWNTO 0) = CONV_INTEGER("1010000011")) ELSE '0' ;
   dataout_tmp14 <= fifo_data_out1_sync(9 DOWNTO 0) WHEN (matchenable OR genericfifo_sync_clk2) = '1' ELSE datain ;
   errdetectout_tmp16 <= fifo_data_out1_sync(10) WHEN (matchenable OR genericfifo_sync_clk2) = '1' ELSE errdetectin ;
   syncstatus_tmp17 <= fifo_data_out1_sync(11) WHEN (matchenable OR genericfifo_sync_clk2) = '1' ELSE syncstatusin ;
   disperr_tmp19 <= fifo_data_out1_sync(12) WHEN (matchenable OR genericfifo_sync_clk2) = '1' ELSE disperrin ;
   patterndetect_tmp18 <= fifo_data_out1_sync(13) WHEN (matchenable OR genericfifo_sync_clk2) = '1' ELSE patterndetectin ;
   codevalid_tmp15 <= fifo_data_out1_sync_valid WHEN (matchenable OR genericfifo_sync_clk2) = '1' ELSE alignstatus_dly WHEN (deskewenable) = '1' ELSE syncstatusin ;
   alignsyncstatus_tmp10 <= '0' WHEN (NOT matchenable OR genericfifo_sync_clk1) = '1' ELSE alignstatus_dly WHEN (deskewenable) = '1' ELSE syncstatusin ;
   alignsyncstatus_sync <= '0' WHEN (NOT matchenable OR genericfifo_sync_clk2) = '1' ELSE alignstatus_sync WHEN (deskewenable) = '1' ELSE syncstatus_sync ;
   fifo_data_in <= '0' & datain ;
   fifo_data_in_pre <= "000" & datainpre ;
   fifo_errdetectin <= errdetectin ;
   fifo_disperrin <= disperrin ;
   fifo_patterndetectin <= patterndetectin ;
   fifo_syncstatusin <= syncstatusin ;
   comp_write <= (comp_write_pre AND NOT errdetectin) AND NOT disperrin ;
   write_detect <= (write_detect_pre AND NOT errdetectin) AND NOT disperrin ;
 
END arch_stratixgx_comp_fifo_core;
 
--IP Functional Simulation Model
--VERSION_BEGIN 4.1 cbx_mgl 2004:06:17:17:30:06:SJ cbx_simgen 2004:06:22:10:53:08:SJ  VERSION_END


-- Legal Notice: © 2003 Altera Corporation. All rights reserved.
-- You may only use these  simulation  model  output files for simulation
-- purposes and expressly not for synthesis or any other purposes (in which
-- event  Altera disclaims all warranties of any kind). Your use of  Altera
-- Corporation's design tools, logic functions and other software and tools,
-- and its AMPP partner logic functions, and any output files any of the
-- foregoing (including device programming or simulation files), and any
-- associated documentation or information  are expressly subject to the
-- terms and conditions of the  Altera Program License Subscription Agreement
-- or other applicable license agreement, including, without limitation, that
-- your use is for the sole purpose of programming logic devices manufactured
-- by Altera and sold by Altera or its authorized distributors.  Please refer
-- to the applicable agreement for further details.


--synopsys translate_off

 LIBRARY sgate;
 USE sgate.sgate_pack.all;

--synthesis_resources = lut 18 mux21 14 oper_selector 6 
 LIBRARY ieee;
 USE ieee.std_logic_1164.all;

 ENTITY  stratixgx_comp_fifo_sm IS 
	 PORT 
	 ( 
		 alignsyncstatus	:	IN  STD_LOGIC;
		 decsync	:	IN  STD_LOGIC;
		 done	:	IN  STD_LOGIC;
		 fifocntgt9	:	IN  STD_LOGIC;
		 fifocntlt5	:	IN  STD_LOGIC;
		 overflow	:	OUT  STD_LOGIC;
		 reset	:	IN  STD_LOGIC;
		 smenable	:	IN  STD_LOGIC;
		 underflow	:	OUT  STD_LOGIC;
		 writeclk	:	IN  STD_LOGIC
	 ); 
 END stratixgx_comp_fifo_sm;

 ARCHITECTURE RTL OF stratixgx_comp_fifo_sm IS

	 ATTRIBUTE synthesis_clearbox : boolean;
	 ATTRIBUTE synthesis_clearbox OF RTL : ARCHITECTURE IS true;
	 SIGNAL	n0ii10	:	STD_LOGIC := '1';
	 SIGNAL	n0ii11	:	STD_LOGIC := '0';
	 SIGNAL	n0ii12	:	STD_LOGIC := '0';
	 SIGNAL	n0iO7	:	STD_LOGIC := '1';
	 SIGNAL	n0iO8	:	STD_LOGIC := '0';
	 SIGNAL	n0iO9	:	STD_LOGIC := '0';
	 SIGNAL	n0Oi4	:	STD_LOGIC := '1';
	 SIGNAL	n0Oi5	:	STD_LOGIC := '0';
	 SIGNAL	n0Oi6	:	STD_LOGIC := '0';
	 SIGNAL	ni	:	STD_LOGIC := '0';
	 SIGNAL	ni1i1	:	STD_LOGIC := '1';
	 SIGNAL	ni1i2	:	STD_LOGIC := '0';
	 SIGNAL	ni1i3	:	STD_LOGIC := '0';
	 SIGNAL	nl	:	STD_LOGIC := '0';
	 SIGNAL	nl1i	:	STD_LOGIC := '0';
	 SIGNAL	nl1l	:	STD_LOGIC := '0';
	 SIGNAL  wire_nl1l_w_lg_w_lg_Q29w34w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl1l_w_lg_Q29w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nlO	:	STD_LOGIC := '0';
	 SIGNAL	nO	:	STD_LOGIC := '0';
	 SIGNAL	wire_n0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nl0i_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nl0i_o	:	STD_LOGIC;
	 SIGNAL  wire_nl0i_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nl0O_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nl0O_o	:	STD_LOGIC;
	 SIGNAL  wire_nl0O_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nl1O_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nl1O_o	:	STD_LOGIC;
	 SIGNAL  wire_nl1O_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlii_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nlii_o	:	STD_LOGIC;
	 SIGNAL  wire_nlii_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nlil_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlil_o	:	STD_LOGIC;
	 SIGNAL  wire_nlil_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlli_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlli_o	:	STD_LOGIC;
	 SIGNAL  wire_nlli_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_w_lg_alignsyncstatus7w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_decsync8w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_done16w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n0lO15w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n0OO62w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_reset1w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_n0ii66w67w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_n0iO32w33w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_n0Oi12w13w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  n0ll :	STD_LOGIC;
	 SIGNAL  n0lO :	STD_LOGIC;
	 SIGNAL  n0OO :	STD_LOGIC;
	 SIGNAL  ni0l :	STD_LOGIC;
	 SIGNAL  w_n0ii66w :	STD_LOGIC;
	 SIGNAL  w_n0iO32w :	STD_LOGIC;
	 SIGNAL  w_n0Oi12w :	STD_LOGIC;
	 SIGNAL  w_ni1i5w :	STD_LOGIC;
	 COMPONENT  oper_selector
	 GENERIC 
	 (
		width_data	:	NATURAL;
		width_sel	:	NATURAL
	 );
	 PORT
	 ( 
		data	:	IN STD_LOGIC_VECTOR(width_data-1 DOWNTO 0);
		o	:	OUT STD_LOGIC;
		sel	:	IN STD_LOGIC_VECTOR(width_sel-1 DOWNTO 0)
	 ); 
	 END COMPONENT;
 BEGIN

	wire_w_lg_alignsyncstatus7w(0) <= NOT alignsyncstatus;
	wire_w_lg_decsync8w(0) <= NOT decsync;
	wire_w_lg_done16w(0) <= NOT done;
	wire_w_lg_n0lO15w(0) <= NOT n0lO;
	wire_w_lg_n0OO62w(0) <= NOT n0OO;
	wire_w_lg_reset1w(0) <= NOT reset;
	wire_w_lg_w_n0ii66w67w(0) <= NOT w_n0ii66w;
	wire_w_lg_w_n0iO32w33w(0) <= NOT w_n0iO32w;
	wire_w_lg_w_n0Oi12w13w(0) <= NOT w_n0Oi12w;
	n0ll <= ((nl OR nl1i) OR wire_w_lg_w_n0ii66w67w(0));
	n0lO <= ((fifocntlt5 OR fifocntgt9) OR wire_w_lg_w_n0Oi12w13w(0));
	n0OO <= ((alignsyncstatus AND smenable) AND w_ni1i5w);
	ni0l <= writeclk;
	overflow <= nlO;
	underflow <= ni;
	w_n0ii66w <= n0ii12;
	w_n0iO32w <= n0iO9;
	w_n0Oi12w <= n0Oi6;
	w_ni1i5w <= ni1i3;
	PROCESS (ni0l)
	BEGIN
		IF (ni0l = '1' AND ni0l'event) THEN n0ii10 <= n0ii11;
		END IF;
	END PROCESS;
	PROCESS (ni0l)
	BEGIN
		IF (ni0l = '1' AND ni0l'event) THEN n0ii11 <= n0ii10;
		END IF;
	END PROCESS;
	PROCESS (ni0l)
	BEGIN
		IF (ni0l = '1' AND ni0l'event) THEN n0ii12 <= (n0ii11 XOR n0ii10);
		END IF;
	END PROCESS;
	PROCESS (ni0l)
	BEGIN
		IF (ni0l = '1' AND ni0l'event) THEN n0iO7 <= n0iO8;
		END IF;
	END PROCESS;
	PROCESS (ni0l)
	BEGIN
		IF (ni0l = '1' AND ni0l'event) THEN n0iO8 <= n0iO7;
		END IF;
	END PROCESS;
	PROCESS (ni0l)
	BEGIN
		IF (ni0l = '1' AND ni0l'event) THEN n0iO9 <= (n0iO8 XOR n0iO7);
		END IF;
	END PROCESS;
	PROCESS (ni0l)
	BEGIN
		IF (ni0l = '1' AND ni0l'event) THEN n0Oi4 <= n0Oi5;
		END IF;
	END PROCESS;
	PROCESS (ni0l)
	BEGIN
		IF (ni0l = '1' AND ni0l'event) THEN n0Oi5 <= n0Oi4;
		END IF;
	END PROCESS;
	PROCESS (ni0l)
	BEGIN
		IF (ni0l = '1' AND ni0l'event) THEN n0Oi6 <= (n0Oi5 XOR n0Oi4);
		END IF;
	END PROCESS;
	PROCESS (writeclk, reset)
	BEGIN
		IF (reset = '1') THEN ni <= '0';
		ELSIF (writeclk = '1' AND writeclk'event) THEN ni <= wire_nl0i_o;
		END IF;
	END PROCESS;
	PROCESS (ni0l)
	BEGIN
		IF (ni0l = '1' AND ni0l'event) THEN ni1i1 <= ni1i2;
		END IF;
	END PROCESS;
	PROCESS (ni0l)
	BEGIN
		IF (ni0l = '1' AND ni0l'event) THEN ni1i2 <= ni1i1;
		END IF;
	END PROCESS;
	PROCESS (ni0l)
	BEGIN
		IF (ni0l = '1' AND ni0l'event) THEN ni1i3 <= (ni1i2 XOR ni1i1);
		END IF;
	END PROCESS;
	PROCESS (writeclk, reset)
	BEGIN
		IF (reset = '1') THEN nl <= '0';
		ELSIF (writeclk = '1' AND writeclk'event) THEN nl <= wire_nlii_o;
		END IF;
	END PROCESS;
	PROCESS (writeclk, reset)
	BEGIN
		IF (reset = '1') THEN nl1i <= '1';
		ELSIF (writeclk = '1' AND writeclk'event) THEN nl1i <= wire_nl0O_o;
		END IF;
	END PROCESS;
	PROCESS (writeclk, reset)
	BEGIN
		IF (reset = '1') THEN nl1l <= '0';
		ELSIF (writeclk = '1' AND writeclk'event) THEN nl1l <= wire_nlli_o;
		END IF;
	END PROCESS;
	wire_nl1l_w_lg_w_lg_Q29w34w(0) <= wire_nl1l_w_lg_Q29w(0) OR wire_w_lg_w_n0iO32w33w(0);
	wire_nl1l_w_lg_Q29w(0) <= nl1l OR nl1i;
	PROCESS (writeclk, reset)
	BEGIN
		IF (reset = '1') THEN nlO <= '0';
		ELSIF (writeclk = '1' AND writeclk'event) THEN nlO <= wire_nl1O_o;
		END IF;
	END PROCESS;
	PROCESS (writeclk, reset)
	BEGIN
		IF (reset = '1') THEN nO <= '0';
		ELSIF (writeclk = '1' AND writeclk'event) THEN nO <= wire_nlil_o;
		END IF;
	END PROCESS;
	wire_n0i_dataout <= wire_w_lg_n0lO15w(0) AND NOT(wire_w_lg_alignsyncstatus7w(0));
	wire_n0l_dataout <= n0lO AND NOT(wire_w_lg_alignsyncstatus7w(0));
	wire_n0O_dataout <= fifocntgt9 WHEN n0lO = '1'  ELSE nlO;
	wire_n1i_dataout <= nlO AND NOT(done);
	wire_n1l_dataout <= nlO WHEN wire_w_lg_alignsyncstatus7w(0) = '1'  ELSE wire_n0O_dataout;
	wire_n1O_dataout <= ni WHEN wire_w_lg_alignsyncstatus7w(0) = '1'  ELSE wire_nii_dataout;
	wire_nii_dataout <= fifocntlt5 WHEN n0lO = '1'  ELSE ni;
	wire_niO_dataout <= wire_w_lg_decsync8w(0) AND NOT(wire_w_lg_alignsyncstatus7w(0));
	wire_nli_dataout <= decsync AND NOT(wire_w_lg_alignsyncstatus7w(0));
	wire_nlll_dataout <= done AND NOT(wire_w_lg_alignsyncstatus7w(0));
	wire_nllO_dataout <= wire_w_lg_done16w(0) AND NOT(wire_w_lg_alignsyncstatus7w(0));
	wire_nlOi_dataout <= wire_nlOO_dataout AND NOT(wire_w_lg_alignsyncstatus7w(0));
	wire_nlOl_dataout <= wire_n1i_dataout AND NOT(wire_w_lg_alignsyncstatus7w(0));
	wire_nlOO_dataout <= ni AND NOT(done);
	wire_nl0i_data <= ( ni & wire_n1O_dataout & wire_nlOi_dataout);
	wire_nl0i_sel <= ( n0ll & nO & nl1l);
	nl0i :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nl0i_data,
		o => wire_nl0i_o,
		sel => wire_nl0i_sel
	  );
	wire_nl0O_data <= ( wire_w_lg_n0OO62w & wire_w_lg_alignsyncstatus7w & wire_w_lg_alignsyncstatus7w & wire_w_lg_alignsyncstatus7w);
	wire_nl0O_sel <= ( nl1i & nl & nO & nl1l);
	nl0O :  oper_selector
	  GENERIC MAP (
		width_data => 4,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_nl0O_data,
		o => wire_nl0O_o,
		sel => wire_nl0O_sel
	  );
	wire_nl1O_data <= ( nlO & wire_n1l_dataout & wire_nlOl_dataout);
	wire_nl1O_sel <= ( n0ll & nO & nl1l);
	nl1O :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nl1O_data,
		o => wire_nl1O_o,
		sel => wire_nl1O_sel
	  );
	wire_nlii_data <= ( n0OO & wire_niO_dataout & "0" & wire_nlll_dataout);
	wire_nlii_sel <= ( nl1i & nl & nO & nl1l);
	nlii :  oper_selector
	  GENERIC MAP (
		width_data => 4,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_nlii_data,
		o => wire_nlii_o,
		sel => wire_nlii_sel
	  );
	wire_nlil_data <= ( "0" & wire_nli_dataout & wire_n0i_dataout);
	wire_nlil_sel <= ( wire_nl1l_w_lg_w_lg_Q29w34w & nl & nO);
	nlil :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlil_data,
		o => wire_nlil_o,
		sel => wire_nlil_sel
	  );
	wire_nlli_data <= ( "0" & wire_n0l_dataout & wire_nllO_dataout);
	wire_nlli_sel <= ( n0ll & nO & nl1l);
	nlli :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlli_data,
		o => wire_nlli_o,
		sel => wire_nlli_sel
	  );

 END RTL; --stratixgx_comp_fifo_sm
--synopsys translate_on
--VALID FILE
--/////////////////////////////////////////////////////////////////////////////
--
--                            STRATIXGX_COMP_FIFO
--
--/////////////////////////////////////////////////////////////////////////////
 
LIBRARY ieee, stratixgx_gxb,std;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
 
ENTITY stratixgx_comp_fifo IS
  GENERIC (
    use_rate_match_fifo     : string  := "true";
    rate_matching_fifo_mode : string  := "xaui";
    use_channel_align       : string  := "true";
    for_engineering_sample_device    : String := "true"; -- new in 3.0 SP2 
    channel_num             : integer := 0
    );
   PORT (
      datain                  : IN std_logic_vector(9 DOWNTO 0);   
      datainpre               : IN std_logic_vector(9 DOWNTO 0);   
      reset                   : IN std_logic;   
      errdetectin             : IN std_logic;   
      syncstatusin            : IN std_logic;   
      disperrin               : IN std_logic;   
      patterndetectin         : IN std_logic;   
      errdetectinpre          : IN std_logic;   
      syncstatusinpre         : IN std_logic;   
      disperrinpre            : IN std_logic;   
      patterndetectinpre      : IN std_logic;   
      writeclk                : IN std_logic;   
      readclk                 : IN std_logic;   
      re                      : IN std_logic;   
      we                      : IN std_logic;   
      fifordin                : IN std_logic;   
      disablefifordin         : IN std_logic;   
      disablefifowrin         : IN std_logic;   
      alignstatus             : IN std_logic;   
      dataout                 : OUT std_logic_vector(9 DOWNTO 0);   
      errdetectout            : OUT std_logic;   
      syncstatus              : OUT std_logic;   
      disperr                 : OUT std_logic;   
      patterndetect           : OUT std_logic;   
      codevalid               : OUT std_logic;   
      fifofull                : OUT std_logic;   
      fifoalmostful           : OUT std_logic;   
      fifoempty               : OUT std_logic;   
      fifoalmostempty         : OUT std_logic;   
      disablefifordout        : OUT std_logic;   
      disablefifowrout        : OUT std_logic;   
      fifordout               : OUT std_logic);   
end stratixgx_comp_fifo;
 
ARCHITECTURE arch_stratixgx_comp_fifo OF stratixgx_comp_fifo IS

   COMPONENT stratixgx_comp_fifo_core
      GENERIC (
          channel_num                    :  integer := 0;    
          rate_matching_fifo_mode        :  string := "xaui";    
          use_channel_align              :  string := "true";    
          for_engineering_sample_device  :  string := "true"; -- new in 3.0 SP2 
          use_rate_match_fifo            :  string := "true");
      PORT (
         reset                   : IN  std_logic;
         writeclk                : IN  std_logic;
         readclk                 : IN  std_logic;
         underflow               : IN  std_logic;
         overflow                : IN  std_logic;
         errdetectin             : IN  std_logic;
         disperrin               : IN  std_logic;
         patterndetectin         : IN  std_logic;
         disablefifowrin         : IN  std_logic;
         disablefifordin         : IN  std_logic;
         re                      : IN  std_logic;
         we                      : IN  std_logic;
         datain                  : IN  std_logic_vector(9 DOWNTO 0);
         datainpre               : IN  std_logic_vector(9 DOWNTO 0);
         syncstatusin            : IN  std_logic;
         disperr                 : OUT std_logic;
         alignstatus             : IN  std_logic;
         fifordin                : IN  std_logic;
         fifordout               : OUT std_logic;
         decsync                 : OUT std_logic;
         fifocntlt5                  : OUT std_logic;
         fifocntgt9                : OUT std_logic;
         done                    : OUT std_logic;
         fifoalmostful           : OUT std_logic;
         fifofull                : OUT std_logic;
         fifoalmostempty         : OUT std_logic;
         fifoempty               : OUT std_logic;
         alignsyncstatus         : OUT std_logic;
         smenable                : OUT std_logic;
         disablefifordout        : OUT std_logic;
         disablefifowrout        : OUT std_logic;
         dataout                 : OUT std_logic_vector(9 DOWNTO 0);
         codevalid               : OUT std_logic;
         errdetectout            : OUT std_logic;
         patterndetect           : OUT std_logic;
         syncstatus              : OUT std_logic);
   END COMPONENT;

   COMPONENT stratixgx_comp_fifo_sm
      PORT (
         writeclk                : IN  std_logic;
         alignsyncstatus         : IN  std_logic;
         reset                   : IN  std_logic;
         smenable                : IN  std_logic;
         done                    : IN  std_logic;
         decsync                 : IN  std_logic;
         fifocntlt5                  : IN  std_logic;
         fifocntgt9                : IN  std_logic;
         underflow               : OUT std_logic;
         overflow                : OUT std_logic);
   END COMPONENT;


   SIGNAL done                     :  std_logic;   
   SIGNAL fifocntgt9                 :  std_logic;   
   SIGNAL fifocntlt5                   :  std_logic;   
   SIGNAL decsync                  :  std_logic;   
   SIGNAL alignsyncstatus          :  std_logic;   
   SIGNAL smenable                 :  std_logic;   
   SIGNAL overflow                 :  std_logic;   
   SIGNAL underflow                :  std_logic;   
   SIGNAL dataout_tmp1            :  std_logic_vector(9 DOWNTO 0);   
   SIGNAL errdetectout_tmp2       :  std_logic;   
   SIGNAL syncstatus_tmp3         :  std_logic;   
   SIGNAL disperr_tmp4            :  std_logic;   
   SIGNAL patterndetect_tmp5      :  std_logic;   
   SIGNAL codevalid_tmp6          :  std_logic;   
   SIGNAL fifofull_tmp7           :  std_logic;   
   SIGNAL fifoalmostful_tmp8      :  std_logic;   
   SIGNAL fifoempty_tmp9          :  std_logic;   
   SIGNAL fifoalmostempty_tmp10   :  std_logic;   
   SIGNAL disablefifordout_tmp11  :  std_logic;   
   SIGNAL disablefifowrout_tmp12  :  std_logic;   
   SIGNAL fifordout_tmp13         :  std_logic;   

BEGIN
   dataout <= dataout_tmp1;
   errdetectout <= errdetectout_tmp2;
   syncstatus <= syncstatus_tmp3;
   disperr <= disperr_tmp4;
   patterndetect <= patterndetect_tmp5;
   codevalid <= codevalid_tmp6;
   fifofull <= fifofull_tmp7;
   fifoalmostful <= fifoalmostful_tmp8;
   fifoempty <= fifoempty_tmp9;
   fifoalmostempty <= fifoalmostempty_tmp10;
   disablefifordout <= disablefifordout_tmp11;
   disablefifowrout <= disablefifowrout_tmp12;
   fifordout <= fifordout_tmp13;
 
   comp_fifo_core : stratixgx_comp_fifo_core 
      GENERIC MAP (
         channel_num => channel_num,
         rate_matching_fifo_mode => rate_matching_fifo_mode,
         use_channel_align => use_channel_align,
         for_engineering_sample_device => for_engineering_sample_device, -- new in 3.0 SP2 
         use_rate_match_fifo => use_rate_match_fifo)
      PORT MAP (
         reset => reset,
         writeclk => writeclk,
         readclk => readclk,
         underflow => underflow,
         overflow => overflow,
         errdetectin => errdetectin,
         disperrin => disperrin,
         patterndetectin => patterndetectin,
         disablefifordin => disablefifordin,
         disablefifowrin => disablefifowrin,
         re => re,
         we => we,
         datain => datain,
         datainpre => datainpre,
         syncstatusin => syncstatusin,
         disperr => disperr_tmp4,
         alignstatus => alignstatus,
         fifordin => fifordin,
         fifordout => fifordout_tmp13,
         fifoalmostful => fifoalmostful_tmp8,
         fifofull => fifofull_tmp7,
         fifoalmostempty => fifoalmostempty_tmp10,
         fifoempty => fifoempty_tmp9,
         decsync => decsync,
         fifocntlt5 => fifocntlt5,
         fifocntgt9 => fifocntgt9,
         done => done,
         alignsyncstatus => alignsyncstatus,
         smenable => smenable,
         disablefifordout => disablefifordout_tmp11,
         disablefifowrout => disablefifowrout_tmp12,
         dataout => dataout_tmp1,
         codevalid => codevalid_tmp6,
         errdetectout => errdetectout_tmp2,
         patterndetect => patterndetect_tmp5,
         syncstatus => syncstatus_tmp3);   
   
   comp_fifo_sm : stratixgx_comp_fifo_sm 
      PORT MAP (
         writeclk => writeclk,
         alignsyncstatus => alignsyncstatus,
         reset => reset,
         smenable => smenable,
         done => done,
         decsync => decsync,
         fifocntlt5 => fifocntlt5,
         fifocntgt9 => fifocntgt9,
         underflow => underflow,
         overflow => overflow);   
   
END arch_stratixgx_comp_fifo;
 

--IP Functional Simulation Model
--VERSION_BEGIN 4.1 cbx_mgl 2004:06:17:17:30:06:SJ cbx_simgen 2004:06:22:10:53:08:SJ  VERSION_END


-- Legal Notice: © 2003 Altera Corporation. All rights reserved.
-- You may only use these  simulation  model  output files for simulation
-- purposes and expressly not for synthesis or any other purposes (in which
-- event  Altera disclaims all warranties of any kind). Your use of  Altera
-- Corporation's design tools, logic functions and other software and tools,
-- and its AMPP partner logic functions, and any output files any of the
-- foregoing (including device programming or simulation files), and any
-- associated documentation or information  are expressly subject to the
-- terms and conditions of the  Altera Program License Subscription Agreement
-- or other applicable license agreement, including, without limitation, that
-- your use is for the sole purpose of programming logic devices manufactured
-- by Altera and sold by Altera or its authorized distributors.  Please refer
-- to the applicable agreement for further details.


--synopsys translate_off

 LIBRARY sgate;
 USE sgate.sgate_pack.all;

--synthesis_resources = lut 289 mux21 285 oper_add 5 oper_decoder 10 oper_less_than 1 oper_selector 60 
 LIBRARY ieee;
 USE ieee.std_logic_1164.all;

 ENTITY  stratixgx_hssi_rx_wal_rtl IS 
	 PORT 
	 ( 
		 A1A2_SIZE	:	IN  STD_LOGIC;
		 AUTOBYTEALIGN_DIS	:	IN  STD_LOGIC;
		 BITSLIP	:	IN  STD_LOGIC;
		 cg_comma	:	OUT  STD_LOGIC;
		 DISABLE_RX_DISP	:	IN  STD_LOGIC;
		 DWIDTH	:	IN  STD_LOGIC;
		 encdet_prbs	:	IN  STD_LOGIC;
		 ENCDT	:	IN  STD_LOGIC;
		 GE_XAUI_SEL	:	IN  STD_LOGIC;
		 IB_INVALID_CODE	:	IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
		 LP10BEN	:	IN  STD_LOGIC;
		 PMADATAWIDTH	:	IN  STD_LOGIC;
		 prbs_en	:	IN  STD_LOGIC;
		 PUDI	:	IN  STD_LOGIC_VECTOR (9 DOWNTO 0);
		 PUDR	:	IN  STD_LOGIC_VECTOR (9 DOWNTO 0);
		 rcvd_clk	:	IN  STD_LOGIC;
		 RLV	:	OUT  STD_LOGIC;
		 RLV_EN	:	IN  STD_LOGIC;
		 RLV_lt	:	OUT  STD_LOGIC;
		 RUNDISP_SEL	:	IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
		 signal_detect	:	IN  STD_LOGIC;
		 signal_detect_sync	:	OUT  STD_LOGIC;
		 soft_reset	:	IN  STD_LOGIC;
		 SUDI	:	OUT  STD_LOGIC_VECTOR (12 DOWNTO 0);
		 SUDI_pre	:	OUT  STD_LOGIC_VECTOR (9 DOWNTO 0);
		 SYNC_COMP_PAT	:	IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
		 SYNC_COMP_SIZE	:	IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
		 sync_curr_st	:	OUT  STD_LOGIC_VECTOR (3 DOWNTO 0);
		 SYNC_SM_DIS	:	IN  STD_LOGIC;
		 sync_status	:	OUT  STD_LOGIC
	 ); 
 END stratixgx_hssi_rx_wal_rtl;

 ARCHITECTURE RTL OF stratixgx_hssi_rx_wal_rtl IS

	 ATTRIBUTE synthesis_clearbox : boolean;
	 ATTRIBUTE synthesis_clearbox OF RTL : ARCHITECTURE IS true;
	 SIGNAL	n0000i	:	STD_LOGIC := '0';
	 SIGNAL	n0000l	:	STD_LOGIC := '0';
	 SIGNAL	n0000O	:	STD_LOGIC := '0';
	 SIGNAL  wire_n0000O_w_lg_Q82w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n0001i	:	STD_LOGIC := '0';
	 SIGNAL	n0001l	:	STD_LOGIC := '0';
	 SIGNAL	n0001O	:	STD_LOGIC := '0';
	 SIGNAL  wire_n0001O_w_lg_Q2495w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0001O_w_lg_Q2461w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n0010i	:	STD_LOGIC := '0';
	 SIGNAL  wire_n0010i_w_lg_Q2496w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n0010l	:	STD_LOGIC := '0';
	 SIGNAL	n0010O	:	STD_LOGIC := '0';
	 SIGNAL	n001ii	:	STD_LOGIC := '0';
	 SIGNAL	n001il	:	STD_LOGIC := '0';
	 SIGNAL	n001iO	:	STD_LOGIC := '0';
	 SIGNAL	n001li	:	STD_LOGIC := '0';
	 SIGNAL	n001ll	:	STD_LOGIC := '0';
	 SIGNAL	n001lO	:	STD_LOGIC := '0';
	 SIGNAL	n001Oi	:	STD_LOGIC := '0';
	 SIGNAL	n001Ol	:	STD_LOGIC := '0';
	 SIGNAL	n001OO	:	STD_LOGIC := '0';
	 SIGNAL	n0i00i	:	STD_LOGIC := '0';
	 SIGNAL  wire_n0i00i_w_lg_w_lg_w_lg_Q675w676w677w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0i00i_w_lg_Q675w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0i00i_w_lg_w_lg_Q675w676w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n0i00l	:	STD_LOGIC := '0';
	 SIGNAL	n0i00O	:	STD_LOGIC := '0';
	 SIGNAL  wire_n0i00O_w_lg_w_lg_w_lg_Q664w665w666w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0i00O_w_lg_Q664w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0i00O_w_lg_w_lg_Q664w665w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n0i01i	:	STD_LOGIC := '0';
	 SIGNAL	n0i01l	:	STD_LOGIC := '0';
	 SIGNAL  wire_n0i01l_w_lg_w_lg_w_lg_Q686w687w688w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0i01l_w_lg_Q686w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0i01l_w_lg_w_lg_Q686w687w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n0i01O	:	STD_LOGIC := '0';
	 SIGNAL	n0i0ii	:	STD_LOGIC := '0';
	 SIGNAL	n0i0il	:	STD_LOGIC := '0';
	 SIGNAL  wire_n0i0il_w_lg_w_lg_w_lg_Q653w654w655w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0i0il_w_lg_Q653w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0i0il_w_lg_w_lg_Q653w654w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n0i0iO	:	STD_LOGIC := '0';
	 SIGNAL	n0i0li	:	STD_LOGIC := '0';
	 SIGNAL  wire_n0i0li_w_lg_w_lg_w_lg_Q642w643w644w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0i0li_w_lg_Q642w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0i0li_w_lg_w_lg_Q642w643w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n0i0ll	:	STD_LOGIC := '0';
	 SIGNAL	n0i0lO	:	STD_LOGIC := '0';
	 SIGNAL  wire_n0i0lO_w_lg_w_lg_w_lg_Q631w632w633w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0i0lO_w_lg_Q631w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0i0lO_w_lg_w_lg_Q631w632w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n0i0Oi	:	STD_LOGIC := '0';
	 SIGNAL	n0i1Oi	:	STD_LOGIC := '0';
	 SIGNAL	n0i1Ol	:	STD_LOGIC := '0';
	 SIGNAL	n0i1OO	:	STD_LOGIC := '0';
	 SIGNAL  wire_n0i1OO_w_lg_w_lg_w_lg_Q697w698w699w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0i1OO_w_lg_Q697w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0i1OO_w_lg_w_lg_Q697w698w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n0iiOO	:	STD_LOGIC := '0';
	 SIGNAL  wire_n0iiOO_w_lg_w_lg_w_lg_Q620w621w622w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0iiOO_w_lg_Q620w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0iiOO_w_lg_w_lg_Q620w621w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n0il0i	:	STD_LOGIC := '0';
	 SIGNAL	n0il0l	:	STD_LOGIC := '0';
	 SIGNAL	n0il0O	:	STD_LOGIC := '0';
	 SIGNAL	n0il1i	:	STD_LOGIC := '0';
	 SIGNAL	n0il1l	:	STD_LOGIC := '0';
	 SIGNAL	n0il1O	:	STD_LOGIC := '0';
	 SIGNAL	n0ilii	:	STD_LOGIC := '0';
	 SIGNAL	n1lO0O55	:	STD_LOGIC := '1';
	 SIGNAL	n1lO0O56	:	STD_LOGIC := '0';
	 SIGNAL	n1lO0O57	:	STD_LOGIC := '0';
	 SIGNAL	n1lO1O58	:	STD_LOGIC := '1';
	 SIGNAL	n1lO1O59	:	STD_LOGIC := '0';
	 SIGNAL	n1lO1O60	:	STD_LOGIC := '0';
	 SIGNAL	n1lOil52	:	STD_LOGIC := '1';
	 SIGNAL	n1lOil53	:	STD_LOGIC := '0';
	 SIGNAL	n1lOil54	:	STD_LOGIC := '0';
	 SIGNAL	n1lOli49	:	STD_LOGIC := '1';
	 SIGNAL	n1lOli50	:	STD_LOGIC := '0';
	 SIGNAL	n1lOli51	:	STD_LOGIC := '0';
	 SIGNAL	n1lOlO46	:	STD_LOGIC := '1';
	 SIGNAL	n1lOlO47	:	STD_LOGIC := '0';
	 SIGNAL	n1lOlO48	:	STD_LOGIC := '0';
	 SIGNAL	n1lOOO43	:	STD_LOGIC := '1';
	 SIGNAL	n1lOOO44	:	STD_LOGIC := '0';
	 SIGNAL	n1lOOO45	:	STD_LOGIC := '0';
	 SIGNAL	n1O00i16	:	STD_LOGIC := '1';
	 SIGNAL	n1O00i17	:	STD_LOGIC := '0';
	 SIGNAL	n1O00i18	:	STD_LOGIC := '0';
	 SIGNAL	n1O00O13	:	STD_LOGIC := '1';
	 SIGNAL	n1O00O14	:	STD_LOGIC := '0';
	 SIGNAL	n1O00O15	:	STD_LOGIC := '0';
	 SIGNAL	n1O01l19	:	STD_LOGIC := '1';
	 SIGNAL	n1O01l20	:	STD_LOGIC := '0';
	 SIGNAL	n1O01l21	:	STD_LOGIC := '0';
	 SIGNAL	n1O0il10	:	STD_LOGIC := '1';
	 SIGNAL	n1O0il11	:	STD_LOGIC := '0';
	 SIGNAL	n1O0il12	:	STD_LOGIC := '0';
	 SIGNAL	n1O0Ol7	:	STD_LOGIC := '1';
	 SIGNAL	n1O0Ol8	:	STD_LOGIC := '0';
	 SIGNAL	n1O0Ol9	:	STD_LOGIC := '0';
	 SIGNAL	n1O10i37	:	STD_LOGIC := '1';
	 SIGNAL	n1O10i38	:	STD_LOGIC := '0';
	 SIGNAL	n1O10i39	:	STD_LOGIC := '0';
	 SIGNAL	n1O10O34	:	STD_LOGIC := '1';
	 SIGNAL	n1O10O35	:	STD_LOGIC := '0';
	 SIGNAL	n1O10O36	:	STD_LOGIC := '0';
	 SIGNAL	n1O11l40	:	STD_LOGIC := '1';
	 SIGNAL	n1O11l41	:	STD_LOGIC := '0';
	 SIGNAL	n1O11l42	:	STD_LOGIC := '0';
	 SIGNAL	n1O1il31	:	STD_LOGIC := '1';
	 SIGNAL	n1O1il32	:	STD_LOGIC := '0';
	 SIGNAL	n1O1il33	:	STD_LOGIC := '0';
	 SIGNAL	n1O1li28	:	STD_LOGIC := '1';
	 SIGNAL	n1O1li29	:	STD_LOGIC := '0';
	 SIGNAL	n1O1li30	:	STD_LOGIC := '0';
	 SIGNAL	n1O1Oi25	:	STD_LOGIC := '1';
	 SIGNAL	n1O1Oi26	:	STD_LOGIC := '0';
	 SIGNAL	n1O1Oi27	:	STD_LOGIC := '0';
	 SIGNAL	n1O1OO22	:	STD_LOGIC := '1';
	 SIGNAL	n1O1OO23	:	STD_LOGIC := '0';
	 SIGNAL	n1O1OO24	:	STD_LOGIC := '0';
	 SIGNAL	n1Oill4	:	STD_LOGIC := '1';
	 SIGNAL	n1Oill5	:	STD_LOGIC := '0';
	 SIGNAL	n1Oill6	:	STD_LOGIC := '0';
	 SIGNAL	n1OiOi1	:	STD_LOGIC := '1';
	 SIGNAL	n1OiOi2	:	STD_LOGIC := '0';
	 SIGNAL	n1OiOi3	:	STD_LOGIC := '0';
	 SIGNAL	n1Ol0i	:	STD_LOGIC := '0';
	 SIGNAL	n1Ol0l	:	STD_LOGIC := '0';
	 SIGNAL	n1Ol0O	:	STD_LOGIC := '0';
	 SIGNAL	n1Olii	:	STD_LOGIC := '0';
	 SIGNAL	n1Olil	:	STD_LOGIC := '0';
	 SIGNAL  wire_n1Olil_w_lg_Q1289w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n1OliO	:	STD_LOGIC := '0';
	 SIGNAL  wire_n1OliO_w_lg_Q2463w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n1OlOi	:	STD_LOGIC := '0';
	 SIGNAL  wire_n1OlOi_w_lg_Q2497w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	ni0liO	:	STD_LOGIC := '0';
	 SIGNAL	ni0lli	:	STD_LOGIC := '0';
	 SIGNAL	ni0lll	:	STD_LOGIC := '0';
	 SIGNAL	ni0llO	:	STD_LOGIC := '0';
	 SIGNAL	ni0lOi	:	STD_LOGIC := '0';
	 SIGNAL	ni0lOl	:	STD_LOGIC := '0';
	 SIGNAL	ni0lOO	:	STD_LOGIC := '0';
	 SIGNAL	ni0OOO	:	STD_LOGIC := '0';
	 SIGNAL	ni1O0i	:	STD_LOGIC := '0';
	 SIGNAL	ni1O0l	:	STD_LOGIC := '0';
	 SIGNAL	ni1O0O	:	STD_LOGIC := '0';
	 SIGNAL	ni1Oii	:	STD_LOGIC := '0';
	 SIGNAL	ni1Oil	:	STD_LOGIC := '0';
	 SIGNAL	ni1OiO	:	STD_LOGIC := '0';
	 SIGNAL	ni1Oli	:	STD_LOGIC := '0';
	 SIGNAL	ni1Oll	:	STD_LOGIC := '0';
	 SIGNAL	ni1OlO	:	STD_LOGIC := '0';
	 SIGNAL	nii11i	:	STD_LOGIC := '0';
	 SIGNAL	nii11l	:	STD_LOGIC := '0';
	 SIGNAL	nii11O	:	STD_LOGIC := '0';
	 SIGNAL	nii1iO	:	STD_LOGIC := '0';
	 SIGNAL	nii1li	:	STD_LOGIC := '0';
	 SIGNAL	nii1ll	:	STD_LOGIC := '0';
	 SIGNAL	nii1lO	:	STD_LOGIC := '0';
	 SIGNAL  wire_nii1lO_w_lg_Q1765w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	niiiOi	:	STD_LOGIC := '0';
	 SIGNAL	niiiOl	:	STD_LOGIC := '0';
	 SIGNAL	niiiOO	:	STD_LOGIC := '0';
	 SIGNAL  wire_niiiOO_w_lg_Q1894w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	niil0i	:	STD_LOGIC := '0';
	 SIGNAL	niil0l	:	STD_LOGIC := '0';
	 SIGNAL	niil0O	:	STD_LOGIC := '0';
	 SIGNAL	niil1i	:	STD_LOGIC := '0';
	 SIGNAL  wire_niil1i_w_lg_Q1900w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	niil1l	:	STD_LOGIC := '0';
	 SIGNAL	niil1O	:	STD_LOGIC := '0';
	 SIGNAL	niilii	:	STD_LOGIC := '0';
	 SIGNAL	niilil	:	STD_LOGIC := '0';
	 SIGNAL	niiliO	:	STD_LOGIC := '0';
	 SIGNAL	niilli	:	STD_LOGIC := '0';
	 SIGNAL	niilll	:	STD_LOGIC := '0';
	 SIGNAL	niillO	:	STD_LOGIC := '0';
	 SIGNAL	niiOOi	:	STD_LOGIC := '0';
	 SIGNAL	niiOOl	:	STD_LOGIC := '0';
	 SIGNAL	niiOOO	:	STD_LOGIC := '0';
	 SIGNAL  wire_niiOOO_w_lg_Q1895w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nil10i	:	STD_LOGIC := '0';
	 SIGNAL	nil10l	:	STD_LOGIC := '0';
	 SIGNAL	nil10O	:	STD_LOGIC := '0';
	 SIGNAL	nil11i	:	STD_LOGIC := '0';
	 SIGNAL	nil11l	:	STD_LOGIC := '0';
	 SIGNAL	nil11O	:	STD_LOGIC := '0';
	 SIGNAL	nil1ii	:	STD_LOGIC := '0';
	 SIGNAL	nil1il	:	STD_LOGIC := '0';
	 SIGNAL	nil1iO	:	STD_LOGIC := '0';
	 SIGNAL	nil1li	:	STD_LOGIC := '0';
	 SIGNAL	nil1ll	:	STD_LOGIC := '0';
	 SIGNAL	nilii	:	STD_LOGIC := '0';
	 SIGNAL	nilil	:	STD_LOGIC := '0';
	 SIGNAL  wire_nilil_w_lg_Q1661w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nilil_w_lg_w_lg_w_lg_Q1569w1570w1571w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nilil_w_lg_w_lg_Q1569w1570w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nilil_w_lg_Q1569w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	niliO	:	STD_LOGIC := '0';
	 SIGNAL  wire_niliO_w_lg_Q1810w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nilli	:	STD_LOGIC := '0';
	 SIGNAL  wire_nilli_w_lg_Q1805w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nilll	:	STD_LOGIC := '0';
	 SIGNAL  wire_nilll_w_lg_Q1803w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nillO	:	STD_LOGIC := '0';
	 SIGNAL  wire_nillO_w_lg_Q1801w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nilOi	:	STD_LOGIC := '0';
	 SIGNAL  wire_nilOi_w_lg_w_lg_w_lg_Q1451w1452w1453w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nilOi_w_lg_w_lg_Q1451w1452w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nilOi_w_lg_w_lg_Q1444w1445w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nilOi_w_lg_Q1451w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nilOi_w_lg_Q1444w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nilOi_w_lg_w_lg_w_lg_w_lg_Q1367w1368w1369w1370w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nilOi_w_lg_w_lg_w_lg_Q1358w1359w1360w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nilOi_w_lg_Q1799w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nilOi_w_lg_w_lg_w_lg_Q1367w1368w1369w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nilOi_w_lg_w_lg_Q1367w1368w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nilOi_w_lg_w_lg_Q1358w1359w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nilOi_w_lg_Q1367w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nilOi_w_lg_Q1358w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nilOl	:	STD_LOGIC := '0';
	 SIGNAL  wire_nilOl_w_lg_w_lg_w_lg_Q1438w1448w1449w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nilOl_w_lg_w_lg_Q1438w1448w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nilOl_w_lg_Q1438w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nilOl_w_lg_w_lg_Q1350w1351w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nilOl_w_lg_Q1808w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nilOl_w_lg_Q1350w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nilOO	:	STD_LOGIC := '0';
	 SIGNAL  wire_nilOO_w_lg_w_lg_Q1441w1442w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nilOO_w_lg_Q1441w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nilOO_w_lg_Q1529w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	niO0i	:	STD_LOGIC := '0';
	 SIGNAL	niO0l	:	STD_LOGIC := '0';
	 SIGNAL	niO0O	:	STD_LOGIC := '0';
	 SIGNAL	niO1i	:	STD_LOGIC := '0';
	 SIGNAL  wire_niO1i_w_lg_Q1825w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	niO1l	:	STD_LOGIC := '0';
	 SIGNAL  wire_niO1l_w_lg_Q1527w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	niO1O	:	STD_LOGIC := '0';
	 SIGNAL	niOii	:	STD_LOGIC := '0';
	 SIGNAL	niOil	:	STD_LOGIC := '0';
	 SIGNAL	niOiO	:	STD_LOGIC := '0';
	 SIGNAL	niOli	:	STD_LOGIC := '0';
	 SIGNAL	niOll	:	STD_LOGIC := '0';
	 SIGNAL	niOlO	:	STD_LOGIC := '0';
	 SIGNAL	niOOi	:	STD_LOGIC := '0';
	 SIGNAL	niOOl	:	STD_LOGIC := '0';
	 SIGNAL	niOOO	:	STD_LOGIC := '0';
	 SIGNAL	nl000i	:	STD_LOGIC := '0';
	 SIGNAL	nl000l	:	STD_LOGIC := '0';
	 SIGNAL	nl000O	:	STD_LOGIC := '0';
	 SIGNAL	nl001i	:	STD_LOGIC := '0';
	 SIGNAL	nl001l	:	STD_LOGIC := '0';
	 SIGNAL	nl001O	:	STD_LOGIC := '0';
	 SIGNAL	nl00ii	:	STD_LOGIC := '0';
	 SIGNAL	nl00il	:	STD_LOGIC := '0';
	 SIGNAL	nl00iO	:	STD_LOGIC := '0';
	 SIGNAL	nl00li	:	STD_LOGIC := '0';
	 SIGNAL	nl00ll	:	STD_LOGIC := '0';
	 SIGNAL  wire_nl00ll_w_lg_Q2225w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl00ll_w_lg_Q1315w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl00ll_w_lg_Q1296w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nl00lO	:	STD_LOGIC := '0';
	 SIGNAL  wire_nl00lO_w_lg_w_lg_Q2224w2226w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl00lO_w_lg_w_lg_Q2224w2261w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl00lO_w_lg_Q2262w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl00lO_w_lg_Q2224w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl00lO_w_lg_Q1316w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl00lO_w_lg_Q1297w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nl00Oi	:	STD_LOGIC := '0';
	 SIGNAL  wire_nl00Oi_w_lg_w_lg_Q2233w2272w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl00Oi_w_lg_w_lg_Q2233w2269w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl00Oi_w_lg_w_lg_Q2233w2289w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl00Oi_w_lg_w_lg_Q2233w2284w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl00Oi_w_lg_Q2227w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl00Oi_w_lg_Q2292w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl00Oi_w_lg_Q2295w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl00Oi_w_lg_Q2233w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl00Oi_w_lg_Q1318w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl00Oi_w_lg_Q1299w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nl00Ol	:	STD_LOGIC := '0';
	 SIGNAL  wire_nl00Ol_w_lg_w_lg_Q1266w2247w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl00Ol_w_lg_w_lg_Q1266w1267w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl00Ol_w_lg_Q2273w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl00Ol_w_lg_Q2270w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl00Ol_w_lg_Q2290w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl00Ol_w_lg_Q2285w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl00Ol_w_lg_Q2228w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl00Ol_w_lg_Q2293w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl00Ol_w_lg_Q2296w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl00Ol_w_lg_Q1266w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl00Ol_w_lg_Q1320w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl00Ol_w_lg_Q1301w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nl00OO	:	STD_LOGIC := '0';
	 SIGNAL  wire_nl00OO_w_lg_Q2232w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl00OO_w_lg_Q1322w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl00OO_w_lg_Q1303w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nl010i	:	STD_LOGIC := '0';
	 SIGNAL	nl010l	:	STD_LOGIC := '0';
	 SIGNAL	nl010O	:	STD_LOGIC := '0';
	 SIGNAL	nl011i	:	STD_LOGIC := '0';
	 SIGNAL	nl011l	:	STD_LOGIC := '0';
	 SIGNAL	nl011O	:	STD_LOGIC := '0';
	 SIGNAL	nl01ii	:	STD_LOGIC := '0';
	 SIGNAL	nl01il	:	STD_LOGIC := '0';
	 SIGNAL	nl01iO	:	STD_LOGIC := '0';
	 SIGNAL	nl01li	:	STD_LOGIC := '0';
	 SIGNAL	nl01ll	:	STD_LOGIC := '0';
	 SIGNAL	nl01lO	:	STD_LOGIC := '0';
	 SIGNAL	nl01Oi	:	STD_LOGIC := '0';
	 SIGNAL	nl01Ol	:	STD_LOGIC := '0';
	 SIGNAL	nl01OO	:	STD_LOGIC := '0';
	 SIGNAL	nl0i0i	:	STD_LOGIC := '0';
	 SIGNAL  wire_nl0i0i_w_lg_w_lg_Q1336w2197w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0i0i_w_lg_w_lg_Q1336w2192w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0i0i_w_lg_w_lg_Q1336w2173w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0i0i_w_lg_w_lg_Q1336w2170w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0i0i_w_lg_Q2177w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0i0i_w_lg_Q2200w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0i0i_w_lg_Q2147w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0i0i_w_lg_Q2203w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0i0i_w_lg_Q1343w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0i0i_w_lg_Q1336w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0i0i_w_lg_Q1330w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0i0i_w_lg_Q1311w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nl0i1i	:	STD_LOGIC := '0';
	 SIGNAL  wire_nl0i1i_w_lg_w_lg_Q2231w2252w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0i1i_w_lg_Q2253w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0i1i_w_lg_Q2231w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0i1i_w_lg_Q1324w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0i1i_w_lg_Q1305w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nl0i1l	:	STD_LOGIC := '0';
	 SIGNAL  wire_nl0i1l_w_lg_w_lg_Q2106w2111w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0i1l_w_lg_w_lg_Q2106w2107w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0i1l_w_lg_Q1276w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0i1l_w_lg_Q2106w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0i1l_w_lg_Q1326w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0i1l_w_lg_Q1307w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nl0i1O	:	STD_LOGIC := '0';
	 SIGNAL  wire_nl0i1O_w_lg_w_lg_w_lg_Q1337w2138w2139w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0i1O_w_lg_w_lg_Q1337w2176w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0i1O_w_lg_w_lg_Q1337w1338w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0i1O_w_lg_w_lg_Q1337w2138w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0i1O_w_lg_w_lg_Q1337w2159w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0i1O_w_lg_Q2146w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0i1O_w_lg_Q1277w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0i1O_w_lg_Q2160w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0i1O_w_lg_Q1342w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0i1O_w_lg_Q2140w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0i1O_w_lg_Q1337w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0i1O_w_lg_Q1328w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0i1O_w_lg_Q1309w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nl10i	:	STD_LOGIC := '0';
	 SIGNAL	nl10l	:	STD_LOGIC := '0';
	 SIGNAL	nl10O	:	STD_LOGIC := '0';
	 SIGNAL	nl11i	:	STD_LOGIC := '0';
	 SIGNAL	nl11l	:	STD_LOGIC := '0';
	 SIGNAL	nl11O	:	STD_LOGIC := '0';
	 SIGNAL	nl1i0i	:	STD_LOGIC := '0';
	 SIGNAL  wire_nl1i0i_w_lg_Q2435w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nl1i0l	:	STD_LOGIC := '0';
	 SIGNAL  wire_nl1i0l_w_lg_Q773w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nl1i0O	:	STD_LOGIC := '0';
	 SIGNAL  wire_nl1i0O_w_lg_Q771w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nl1ii	:	STD_LOGIC := '0';
	 SIGNAL	nl1iii	:	STD_LOGIC := '0';
	 SIGNAL  wire_nl1iii_w_lg_Q769w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nl1iil	:	STD_LOGIC := '0';
	 SIGNAL  wire_nl1iil_w_lg_Q768w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nl1iiO	:	STD_LOGIC := '0';
	 SIGNAL	nl1il	:	STD_LOGIC := '0';
	 SIGNAL	nl1ili	:	STD_LOGIC := '0';
	 SIGNAL  wire_nl1ili_w_lg_Q2434w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nl1ill	:	STD_LOGIC := '0';
	 SIGNAL  wire_nl1ill_w_lg_Q1269w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl1ill_w_lg_Q1256w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nl1iO	:	STD_LOGIC := '0';
	 SIGNAL	nl1li	:	STD_LOGIC := '0';
	 SIGNAL	nl1ll	:	STD_LOGIC := '0';
	 SIGNAL	nl1lO	:	STD_LOGIC := '0';
	 SIGNAL	nl1O0O	:	STD_LOGIC := '0';
	 SIGNAL  wire_nl1O0O_w_lg_Q2460w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nl1Oi	:	STD_LOGIC := '0';
	 SIGNAL	nl1Oii	:	STD_LOGIC := '0';
	 SIGNAL	nl1Oil	:	STD_LOGIC := '0';
	 SIGNAL	nl1OiO	:	STD_LOGIC := '0';
	 SIGNAL	nl1Ol	:	STD_LOGIC := '0';
	 SIGNAL	nl1Oli	:	STD_LOGIC := '0';
	 SIGNAL	nl1Oll	:	STD_LOGIC := '0';
	 SIGNAL	nl1OlO	:	STD_LOGIC := '0';
	 SIGNAL	nl1OO	:	STD_LOGIC := '0';
	 SIGNAL	nl1OOi	:	STD_LOGIC := '0';
	 SIGNAL	nl1OOl	:	STD_LOGIC := '0';
	 SIGNAL	nl1OOO	:	STD_LOGIC := '0';
	 SIGNAL	nli00i	:	STD_LOGIC := '0';
	 SIGNAL	nli00l	:	STD_LOGIC := '0';
	 SIGNAL	nli01i	:	STD_LOGIC := '0';
	 SIGNAL	nli01l	:	STD_LOGIC := '0';
	 SIGNAL	nli01O	:	STD_LOGIC := '0';
	 SIGNAL	nli1ll	:	STD_LOGIC := '0';
	 SIGNAL  wire_nli1ll_w_lg_w_lg_Q1335w2121w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1ll_w_lg_Q2198w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1ll_w_lg_Q2193w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1ll_w_lg_Q2174w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1ll_w_lg_Q2171w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1ll_w_lg_Q2178w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1ll_w_lg_Q2201w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1ll_w_lg_Q2204w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1ll_w_lg_Q1344w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1ll_w_lg_Q1335w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1ll_w_lg_Q1332w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1ll_w_lg_Q1313w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nli1lO	:	STD_LOGIC := '0';
	 SIGNAL	nli1Oi	:	STD_LOGIC := '0';
	 SIGNAL	nli1Ol	:	STD_LOGIC := '0';
	 SIGNAL	nli1OO	:	STD_LOGIC := '0';
	 SIGNAL	nliilO	:	STD_LOGIC := '0';
	 SIGNAL	nliiOi	:	STD_LOGIC := '0';
	 SIGNAL	nliiOl	:	STD_LOGIC := '0';
	 SIGNAL  wire_nliiOl_w_lg_Q814w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nliiOO	:	STD_LOGIC := '0';
	 SIGNAL	nlil0i	:	STD_LOGIC := '0';
	 SIGNAL	nlil0l	:	STD_LOGIC := '0';
	 SIGNAL	nlil1l	:	STD_LOGIC := '0';
	 SIGNAL	nlil1O	:	STD_LOGIC := '0';
	 SIGNAL	nlilO	:	STD_LOGIC := '0';
	 SIGNAL	nliO1O	:	STD_LOGIC := '0';
	 SIGNAL	nliOi	:	STD_LOGIC := '0';
	 SIGNAL	nliOll	:	STD_LOGIC := '0';
	 SIGNAL	nliOlO	:	STD_LOGIC := '0';
	 SIGNAL	nliOOi	:	STD_LOGIC := '0';
	 SIGNAL  wire_nliOOi_w_lg_Q701w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliOOi_w_lg_Q690w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliOOi_w_lg_Q679w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliOOi_w_lg_Q668w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliOOi_w_lg_Q657w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliOOi_w_lg_Q646w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliOOi_w_lg_Q635w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliOOi_w_lg_Q624w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliOOi_w_lg_Q617w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nliOOl	:	STD_LOGIC := '0';
	 SIGNAL	nliOOO	:	STD_LOGIC := '0';
	 SIGNAL	nll10i	:	STD_LOGIC := '0';
	 SIGNAL	nll10l	:	STD_LOGIC := '0';
	 SIGNAL	nll10O	:	STD_LOGIC := '0';
	 SIGNAL	nll11i	:	STD_LOGIC := '0';
	 SIGNAL	nll11l	:	STD_LOGIC := '0';
	 SIGNAL	nll11O	:	STD_LOGIC := '0';
	 SIGNAL	nll1ii	:	STD_LOGIC := '0';
	 SIGNAL	nll1il	:	STD_LOGIC := '0';
	 SIGNAL	nll1iO	:	STD_LOGIC := '0';
	 SIGNAL	nlllO	:	STD_LOGIC := '0';
	 SIGNAL	wire_n0011i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0011l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00iil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00iOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00lii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00lOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00O0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00OOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0101i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0101l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0101O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n010ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n010il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n010iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n010ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n010lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n010Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n010Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n010OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n011OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01i0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01i0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01i0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01i1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01i1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01iii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01iil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01iiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01ili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01ill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01ilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01iOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01iOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01l0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01l0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01l1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01l1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01l1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01lOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01lOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01O0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01O0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01O0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01O1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01Oii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01Oli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01Oll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01OlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01OOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01OOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01OOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0i10l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0i1lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0liil_dataout	:	STD_LOGIC;
	 SIGNAL  wire_n0liil_w_lg_dataout1279w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0liil_w_lg_dataout1271w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_n0lil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0liO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0llO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0Oii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0Oil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0Oli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0Oll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1Olli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1Olll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1OllO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni000i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni000l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni000O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni00i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni00l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni00O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni00Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni00OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni010i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni010l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni010O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni011i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni01i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni01ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni01l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni01O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0i0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0i0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0i0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0i1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0i1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0i1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0iii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0ili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0ill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0ilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0iOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0iOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0l0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0l1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0l1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0l1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0lii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0lil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0O0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0O0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0O0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0O1i_dataout	:	STD_LOGIC;
	 SIGNAL  wire_ni0O1i_w_lg_dataout1761w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_ni0O1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0O1O_dataout	:	STD_LOGIC;
	 SIGNAL  wire_ni0O1O_w_lg_dataout1757w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_ni0Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0Oii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0Oil_dataout	:	STD_LOGIC;
	 SIGNAL  wire_ni0Oil_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_dataout1753w1754w1755w1756w1758w1759w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0Oil_w_lg_w_lg_w_lg_w_lg_w_lg_dataout1753w1754w1755w1756w1758w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0Oil_w_lg_w_lg_w_lg_w_lg_dataout1753w1754w1755w1756w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0Oil_w_lg_w_lg_w_lg_dataout1753w1754w1755w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0Oil_w_lg_w_lg_dataout1753w1754w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0Oil_w_lg_dataout1753w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_ni0Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni10i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni10l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni10O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni11i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni11l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni11O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni11Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1OOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1OOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1OOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii10i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii10l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii10O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii1ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiili_dataout	:	STD_LOGIC;
	 SIGNAL  wire_niiili_w_lg_dataout1771w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_niiiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niilOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niilOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niilOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiO0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiO0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiO0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiO1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiO1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiO1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiOii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiOil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiOiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiOli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiOll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiOlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil00i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil00l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil00O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil01i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil01l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil01O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil0ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil0il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil0iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil0li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil1lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil1Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil1Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil1OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl00i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl00l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl00O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl01i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl01l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl01O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0iOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0iOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0l0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0l0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0l0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0l1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0l1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0l1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0lii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0lil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0liO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0lli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0lll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0llO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0lOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0lOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0lOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0O1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0O1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0O1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0Oil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0OiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0Oli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0Oll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0OlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0OOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0OOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0OOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlil0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlilii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlilil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliliO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlilli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlilll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlillO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlilOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0OO_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nll0OO_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_dataout711w714w717w720w723w726w729w732w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nll0OO_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_dataout711w714w717w720w723w726w729w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nll0OO_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_dataout711w714w717w720w723w726w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nll0OO_w_lg_w_lg_w_lg_w_lg_w_lg_dataout711w714w717w720w723w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nll0OO_w_lg_w_lg_w_lg_w_lg_dataout711w714w717w720w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nll0OO_w_lg_w_lg_w_lg_dataout711w714w717w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nll0OO_w_lg_w_lg_dataout711w714w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nll0OO_w_lg_dataout736w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nll0OO_w_lg_dataout711w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nll1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlli0i_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nlli0i_w_lg_dataout712w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nlli1l_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nlli1l_w_lg_dataout709w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nllii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlliii_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nlliii_w_lg_dataout715w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nllil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllili_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nllili_w_lg_dataout718w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nlliOi_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nlliOi_w_lg_dataout721w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nlll0i_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nlll0i_w_lg_dataout727w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nlll1i_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nlll1i_w_lg_dataout724w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nlllii_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nlllii_w_lg_dataout730w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nlllli_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nlllli_w_lg_dataout733w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n01iOi_a	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_n01iOi_b	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_gnd	:	STD_LOGIC;
	 SIGNAL  wire_n01iOi_o	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_ni011l_a	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni011l_b	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni011l_o	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni011O_a	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_ni011O_b	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_ni011O_o	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_ni0OiO_a	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_ni0OiO_b	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_ni0OiO_o	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_nlilOl_a	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nlilOl_b	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nlilOl_o	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_n00iii_w_lg_w_o_range2423w2425w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n00iii_i	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_n00iii_o	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n00iii_w_o_range2424w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n00iii_w_o_range2423w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n00iOl_w_lg_w_o_range2406w2408w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n00iOl_i	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_n00iOl_o	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n00iOl_w_o_range2407w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n00iOl_w_o_range2406w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n00l0O_w_lg_w_o_range2389w2391w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n00l0O_i	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_n00l0O_o	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n00l0O_w_o_range2390w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n00l0O_w_o_range2389w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n00lOi_w_lg_w_o_range2372w2374w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n00lOi_i	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_n00lOi_o	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n00lOi_w_o_range2373w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n00lOi_w_o_range2372w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n00O0l_w_lg_w_o_range2355w2357w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n00O0l_i	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_n00O0l_o	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n00O0l_w_o_range2356w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n00O0l_w_o_range2355w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n00OlO_w_lg_w_o_range2338w2340w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n00OlO_i	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_n00OlO_o	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n00OlO_w_o_range2339w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n00OlO_w_o_range2338w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0i10i_w_lg_w_o_range2321w2323w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0i10i_i	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_n0i10i_o	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n0i10i_w_o_range2322w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0i10i_w_o_range2321w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0i1ll_w_lg_w_o_range2304w2306w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0i1ll_i	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_n0i1ll_o	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n0i1ll_w_o_range2305w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0i1ll_w_o_range2304w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1li_i	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_nli1li_o	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nliill_i	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nliill_o	:	STD_LOGIC_VECTOR (31 DOWNTO 0);
	 SIGNAL  wire_nii1il_a	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nii1il_b	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nii1il_o	:	STD_LOGIC;
	 SIGNAL  wire_n00i0l_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n00i0l_o	:	STD_LOGIC;
	 SIGNAL  wire_n00i0l_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n00ilO_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n00ilO_o	:	STD_LOGIC;
	 SIGNAL  wire_n00ilO_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n00l0i_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n00l0i_o	:	STD_LOGIC;
	 SIGNAL  wire_n00l0i_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n00lll_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n00lll_o	:	STD_LOGIC;
	 SIGNAL  wire_n00lll_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n00O1O_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n00O1O_o	:	STD_LOGIC;
	 SIGNAL  wire_n00O1O_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n00Oli_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n00Oli_o	:	STD_LOGIC;
	 SIGNAL  wire_n00Oli_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n0110i_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n0110i_o	:	STD_LOGIC;
	 SIGNAL  wire_n0110i_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n0110O_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n0110O_o	:	STD_LOGIC;
	 SIGNAL  wire_n0110O_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n0111l_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n0111l_o	:	STD_LOGIC;
	 SIGNAL  wire_n0111l_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n011il_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n011il_o	:	STD_LOGIC;
	 SIGNAL  wire_n011il_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n011li_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n011li_o	:	STD_LOGIC;
	 SIGNAL  wire_n011li_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n011ll_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n011ll_o	:	STD_LOGIC;
	 SIGNAL  wire_n011ll_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n011Oi_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n011Oi_o	:	STD_LOGIC;
	 SIGNAL  wire_n011Oi_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n0i11l_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n0i11l_o	:	STD_LOGIC;
	 SIGNAL  wire_n0i11l_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n0i1iO_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n0i1iO_o	:	STD_LOGIC;
	 SIGNAL  wire_n0i1iO_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n1OlOl_data	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_n1OlOl_o	:	STD_LOGIC;
	 SIGNAL  wire_n1OlOl_sel	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_n1OlOO_data	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_n1OlOO_o	:	STD_LOGIC;
	 SIGNAL  wire_n1OlOO_sel	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_n1OO0i_data	:	STD_LOGIC_VECTOR (12 DOWNTO 0);
	 SIGNAL  wire_n1OO0i_o	:	STD_LOGIC;
	 SIGNAL  wire_n1OO0i_sel	:	STD_LOGIC_VECTOR (12 DOWNTO 0);
	 SIGNAL  wire_n1OO0l_data	:	STD_LOGIC_VECTOR (12 DOWNTO 0);
	 SIGNAL  wire_n1OO0l_o	:	STD_LOGIC;
	 SIGNAL  wire_n1OO0l_sel	:	STD_LOGIC_VECTOR (12 DOWNTO 0);
	 SIGNAL  wire_n1OO0O_data	:	STD_LOGIC_VECTOR (12 DOWNTO 0);
	 SIGNAL  wire_n1OO0O_o	:	STD_LOGIC;
	 SIGNAL  wire_n1OO0O_sel	:	STD_LOGIC_VECTOR (12 DOWNTO 0);
	 SIGNAL  wire_n1OO1l_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n1OO1l_o	:	STD_LOGIC;
	 SIGNAL  wire_n1OO1l_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n1OOii_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n1OOii_o	:	STD_LOGIC;
	 SIGNAL  wire_n1OOii_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n1OOiO_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n1OOiO_o	:	STD_LOGIC;
	 SIGNAL  wire_n1OOiO_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n1OOll_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n1OOll_o	:	STD_LOGIC;
	 SIGNAL  wire_n1OOll_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n1OOOi_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n1OOOi_o	:	STD_LOGIC;
	 SIGNAL  wire_n1OOOi_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n1OOOO_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n1OOOO_o	:	STD_LOGIC;
	 SIGNAL  wire_n1OOOO_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_ni001i_data	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_ni001i_o	:	STD_LOGIC;
	 SIGNAL  wire_ni001i_sel	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_ni00ii_data	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_ni00ii_o	:	STD_LOGIC;
	 SIGNAL  wire_ni00ii_sel	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_ni00il_data	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_ni00il_o	:	STD_LOGIC;
	 SIGNAL  wire_ni00il_sel	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_ni00li_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni00li_o	:	STD_LOGIC;
	 SIGNAL  wire_ni00li_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni00lO_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni00lO_o	:	STD_LOGIC;
	 SIGNAL  wire_ni00lO_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni01iO_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni01iO_o	:	STD_LOGIC;
	 SIGNAL  wire_ni01iO_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni01li_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni01li_o	:	STD_LOGIC;
	 SIGNAL  wire_ni01li_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni01ll_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni01ll_o	:	STD_LOGIC;
	 SIGNAL  wire_ni01ll_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni01lO_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni01lO_o	:	STD_LOGIC;
	 SIGNAL  wire_ni01lO_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni01Oi_data	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_ni01Oi_o	:	STD_LOGIC;
	 SIGNAL  wire_ni01Oi_sel	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_ni01Ol_data	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_ni01Ol_o	:	STD_LOGIC;
	 SIGNAL  wire_ni01Ol_sel	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_ni01OO_data	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_ni01OO_o	:	STD_LOGIC;
	 SIGNAL  wire_ni01OO_sel	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nli00O_data	:	STD_LOGIC_VECTOR (11 DOWNTO 0);
	 SIGNAL  wire_nli00O_o	:	STD_LOGIC;
	 SIGNAL  wire_nli00O_sel	:	STD_LOGIC_VECTOR (11 DOWNTO 0);
	 SIGNAL  wire_nli0ii_data	:	STD_LOGIC_VECTOR (11 DOWNTO 0);
	 SIGNAL  wire_nli0ii_o	:	STD_LOGIC;
	 SIGNAL  wire_nli0ii_sel	:	STD_LOGIC_VECTOR (11 DOWNTO 0);
	 SIGNAL  wire_nli0il_data	:	STD_LOGIC_VECTOR (11 DOWNTO 0);
	 SIGNAL  wire_nli0il_o	:	STD_LOGIC;
	 SIGNAL  wire_nli0il_sel	:	STD_LOGIC_VECTOR (11 DOWNTO 0);
	 SIGNAL  wire_nli0iO_data	:	STD_LOGIC_VECTOR (11 DOWNTO 0);
	 SIGNAL  wire_nli0iO_o	:	STD_LOGIC;
	 SIGNAL  wire_nli0iO_sel	:	STD_LOGIC_VECTOR (11 DOWNTO 0);
	 SIGNAL  wire_nli0li_data	:	STD_LOGIC_VECTOR (11 DOWNTO 0);
	 SIGNAL  wire_nli0li_o	:	STD_LOGIC;
	 SIGNAL  wire_nli0li_sel	:	STD_LOGIC_VECTOR (11 DOWNTO 0);
	 SIGNAL  wire_nli0ll_data	:	STD_LOGIC_VECTOR (11 DOWNTO 0);
	 SIGNAL  wire_nli0ll_o	:	STD_LOGIC;
	 SIGNAL  wire_nli0ll_sel	:	STD_LOGIC_VECTOR (11 DOWNTO 0);
	 SIGNAL  wire_nli0lO_data	:	STD_LOGIC_VECTOR (11 DOWNTO 0);
	 SIGNAL  wire_nli0lO_o	:	STD_LOGIC;
	 SIGNAL  wire_nli0lO_sel	:	STD_LOGIC_VECTOR (11 DOWNTO 0);
	 SIGNAL  wire_nli0Oi_data	:	STD_LOGIC_VECTOR (11 DOWNTO 0);
	 SIGNAL  wire_nli0Oi_o	:	STD_LOGIC;
	 SIGNAL  wire_nli0Oi_sel	:	STD_LOGIC_VECTOR (11 DOWNTO 0);
	 SIGNAL  wire_nli10i_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nli10i_o	:	STD_LOGIC;
	 SIGNAL  wire_nli10i_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nli10l_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nli10l_o	:	STD_LOGIC;
	 SIGNAL  wire_nli10l_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nli10O_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nli10O_o	:	STD_LOGIC;
	 SIGNAL  wire_nli10O_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nli11i_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nli11i_o	:	STD_LOGIC;
	 SIGNAL  wire_nli11i_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nli11l_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nli11l_o	:	STD_LOGIC;
	 SIGNAL  wire_nli11l_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nli11O_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nli11O_o	:	STD_LOGIC;
	 SIGNAL  wire_nli11O_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nli1ii_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nli1ii_o	:	STD_LOGIC;
	 SIGNAL  wire_nli1ii_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nli1il_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nli1il_o	:	STD_LOGIC;
	 SIGNAL  wire_nli1il_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nliiii_data	:	STD_LOGIC_VECTOR (10 DOWNTO 0);
	 SIGNAL  wire_nliiii_o	:	STD_LOGIC;
	 SIGNAL  wire_nliiii_sel	:	STD_LOGIC_VECTOR (10 DOWNTO 0);
	 SIGNAL  wire_nliiil_data	:	STD_LOGIC_VECTOR (10 DOWNTO 0);
	 SIGNAL  wire_nliiil_o	:	STD_LOGIC;
	 SIGNAL  wire_nliiil_sel	:	STD_LOGIC_VECTOR (10 DOWNTO 0);
	 SIGNAL  wire_nliOl_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nliOl_o	:	STD_LOGIC;
	 SIGNAL  wire_nliOl_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nliOO_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nliOO_o	:	STD_LOGIC;
	 SIGNAL  wire_nliOO_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nll1i_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nll1i_o	:	STD_LOGIC;
	 SIGNAL  wire_nll1i_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nll1l_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nll1l_o	:	STD_LOGIC;
	 SIGNAL  wire_nll1l_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1Oi0i48w49w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_GE_XAUI_SEL2472w2473w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1ll0l693w700w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1ll0l693w695w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1llii682w689w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1llii682w684w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1lliO671w678w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1lliO671w673w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1llll660w667w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1llll660w662w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1llOi649w656w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1llOi649w651w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1llOO638w645w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1llOO638w640w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1lO1l627w634w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1lO1l627w629w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1lOOl615w623w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1lOOl615w618w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_PMADATAWIDTH115w1738w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_PMADATAWIDTH115w1485w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_PMADATAWIDTH115w1469w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_PMADATAWIDTH115w1477w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_PMADATAWIDTH115w1461w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_PMADATAWIDTH115w1704w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_PMADATAWIDTH115w1433w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_GE_XAUI_SEL2471w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1000i2141w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n101iO2243w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1l11O2145w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1l1Oi1261w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1l1Ol2212w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1l1OO1259w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1Oi0i48w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_PMADATAWIDTH1454w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_PMADATAWIDTH1446w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_PMADATAWIDTH1439w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_PMADATAWIDTH1286w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_PMADATAWIDTH1371w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_PMADATAWIDTH1361w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_PMADATAWIDTH1352w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_PMADATAWIDTH1411w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_PMADATAWIDTH1401w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_PMADATAWIDTH1381w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_PMADATAWIDTH1391w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_PMADATAWIDTH1530w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_SYNC_SM_DIS1285w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_DISABLE_RX_DISP1281w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_GE_XAUI_SEL2472w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1001O2114w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n100Oi1903w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1011i2470w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10i0i1763w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10i0l1764w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10i0O1746w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10i1i1898w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10i1O1872w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10iii1745w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10iil1744w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10iiO1743w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10ili1742w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10ill1741w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10ilO1740w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10iOi1712w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10iOl1711w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10iOO1710w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10l0i1706w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10l1i1709w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10l1l1708w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10l1O1707w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10lii1684w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10lil1677w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10liO1675w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10lli1736w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10lll1681w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10llO1673w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10lOi1671w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10lOl1679w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10O0i1629w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10O0l1726w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10O0O1635w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10O1l1638w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10O1O1631w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10Oii1627w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10Oil1625w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10OiO1633w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10OlO1592w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10OOi1585w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10OOl1583w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10OOO1702w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n11O0i2491w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n11O0l2479w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n11O1O2492w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n11Oii2466w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n11Oli2518w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n11Oll2469w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n11OOl2682w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n11OOO2494w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i00i1650w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i00l1653w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i00O1656w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i01l1644w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i01O1647w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i0ii1659w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i0li1594w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i0lO1720w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i0Oi1729w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i0OO1598w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i10i1587w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i11i1589w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i11l1581w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i11O1579w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i1ii1547w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i1il1540w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i1iO1538w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i1li1693w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i1ll1544w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i1lO1536w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i1Oi1534w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i1Ol1542w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i1OO1640w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1ii0O1604w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1ii1O1601w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iiiO1607w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iili1610w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iill1613w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iilO1615w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iiOi1549w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iiOl1431w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iiOO1554w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1il0i1566w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1il0l1577w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1il1i1557w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1il1l1560w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1il1O1563w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1ilii1419w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1ilil1505w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iliO1415w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1illi1687w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1illl1410w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1illO1408w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1ilOi1509w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1ilOl1400w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1ilOO1398w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iO0i1515w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iO0l1380w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iO0O1378w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iO1i1512w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iO1l1390w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iO1O1388w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iOii1518w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iOil1521w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iOiO1524w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iOOl1293w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iOOO1292w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1l00O1254w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1l11i1291w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1li0l786w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1li0O753w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1liii751w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1liil749w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1liiO747w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1lili745w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1lill743w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1lilO741w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1liOi739w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1liOl737w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1liOO735w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1ll0i704w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1ll0l693w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1ll0O692w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1ll1i706w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1ll1l707w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1ll1O703w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1llii682w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1llil681w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1lliO671w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1llli670w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1llll660w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1lllO659w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1llOi649w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1llOl648w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1llOO638w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1lO0l626w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1lO1i637w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1lO1l627w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1lOOl615w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1O0li119w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1O0ll117w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1O0Oi58w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1O1lO614w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1Oi0l59w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1Oi0O52w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1Oi1i50w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1Oiil43w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_PMADATAWIDTH115w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_rcvd_clk45w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_soft_reset46w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_SYNC_SM_DIS1288w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_n1lO0O276w277w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_n1lO1O290w291w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_n1lOil267w268w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_n1lOli260w261w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_n1lOlO250w251w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_n1lOOO239w240w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_n1O00i165w166w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_n1O00O133w134w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_n1O01l172w173w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_n1O0il126w127w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_n1O10i225w226w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_n1O10O216w217w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_n1O11l232w233w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_n1O1il207w208w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_n1O1li201w202w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_n1O1Oi188w189w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_n1O1OO181w182w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_n1Oill36w37w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_n1OiOi29w30w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range157w158w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range155w156w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range152w153w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range149w150w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range146w147w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range143w144w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range140w141w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range120w138w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range118w137w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range116w136w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_PMADATAWIDTH115w1766w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_PMADATAWIDTH115w1766w1776w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_PMADATAWIDTH115w1766w1767w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH115w1766w1776w1777w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH115w1766w1767w1768w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH115w1766w1776w1777w1778w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH115w1766w1767w1768w1769w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH115w1766w1776w1777w1778w1779w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH115w1766w1767w1768w1769w1770w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH115w1766w1776w1777w1778w1779w1780w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH115w1766w1767w1768w1769w1770w1774w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_n1il0O1507w1508w1511w1514w1517w1520w1523w1526w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_n1i0il1596w1597w1600w1603w1606w1609w1612w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_n1i0il1642w1643w1646w1649w1652w1655w1658w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_n1il0O1507w1508w1511w1514w1517w1520w1523w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH1782w1783w1784w1785w1790w1794w1797w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_n1i0il1596w1597w1600w1603w1606w1609w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_n1i0il1642w1643w1646w1649w1652w1655w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_n1il0O1507w1508w1511w1514w1517w1520w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_n1l01O1257w1258w1260w1262w1263w1264w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH1782w1783w1784w1785w1790w1794w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_w_lg_n1i0il1596w1597w1600w1603w1606w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_w_lg_n1i0il1642w1643w1646w1649w1652w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_w_lg_n1il0O1507w1508w1511w1514w1517w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_w_lg_n1l01O1257w1258w1260w1262w1263w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH1782w1783w1784w1785w1790w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_n1i0il1596w1597w1600w1603w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_n1i0il1642w1643w1646w1649w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_n1il0O1507w1508w1511w1514w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_n1l01O1257w1258w1260w1262w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH1782w1783w1784w1785w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_n1i0il1596w1597w1600w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_n1i0il1642w1643w1646w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_n1il0O1507w1508w1511w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_n1l01O1257w1258w1260w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_PMADATAWIDTH1782w1783w1784w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1i0il1596w1597w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1i0il1642w1643w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1il0O1551w1552w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1il0O1507w1508w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1l01O1257w1258w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1l1ii1272w1273w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_PMADATAWIDTH1782w1783w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1001i2213w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1001i2129w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1001l2130w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1001O2124w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i0il1672w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i0il1728w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i0il1626w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i0il1719w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i0il1596w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i0il1642w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1il0O1695w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1il0O1580w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1il0O1535w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1il0O1686w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1il0O1551w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1il0O1507w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iOlO2125w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1l01l2132w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1l01O2131w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1l01O1257w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1l10i1278w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1l1ii1272w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1l1iO1268w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1l1ll2133w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_PMADATAWIDTH1782w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range157w576w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range157w538w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range157w500w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range157w348w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range157w310w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range157w247w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range157w462w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range157w424w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range157w386w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range157w159w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range155w577w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range155w539w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range155w387w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range155w349w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range155w311w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range155w501w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range155w463w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range155w425w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range155w253w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range155w160w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range152w579w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range152w541w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range152w427w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range152w389w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range152w351w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range152w503w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range152w465w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range152w313w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range152w255w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range152w162w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range149w581w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range149w543w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range149w467w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range149w429w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range149w391w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range149w505w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range149w353w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range149w315w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range149w257w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range149w169w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range146w583w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range146w545w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range146w507w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range146w469w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range146w431w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range146w393w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range146w355w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range146w317w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range146w264w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range146w176w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range143w585w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range143w547w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range143w509w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range143w471w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range143w433w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range143w395w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range143w357w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range143w319w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range143w271w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range143w178w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range140w587w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range140w549w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range140w511w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range140w473w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range140w435w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range140w397w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range140w359w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range140w321w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range140w273w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_PAT_range140w185w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  n1000i :	STD_LOGIC;
	 SIGNAL  n1000l :	STD_LOGIC;
	 SIGNAL  n1000O :	STD_LOGIC;
	 SIGNAL  n1001i :	STD_LOGIC;
	 SIGNAL  n1001l :	STD_LOGIC;
	 SIGNAL  n1001O :	STD_LOGIC;
	 SIGNAL  n100ii :	STD_LOGIC;
	 SIGNAL  n100il :	STD_LOGIC;
	 SIGNAL  n100iO :	STD_LOGIC;
	 SIGNAL  n100li :	STD_LOGIC;
	 SIGNAL  n100ll :	STD_LOGIC;
	 SIGNAL  n100lO :	STD_LOGIC;
	 SIGNAL  n100Oi :	STD_LOGIC;
	 SIGNAL  n100Ol :	STD_LOGIC;
	 SIGNAL  n100OO :	STD_LOGIC;
	 SIGNAL  n1010i :	STD_LOGIC;
	 SIGNAL  n1010l :	STD_LOGIC;
	 SIGNAL  n1010O :	STD_LOGIC;
	 SIGNAL  n1011i :	STD_LOGIC;
	 SIGNAL  n1011l :	STD_LOGIC;
	 SIGNAL  n1011O :	STD_LOGIC;
	 SIGNAL  n101ii :	STD_LOGIC;
	 SIGNAL  n101il :	STD_LOGIC;
	 SIGNAL  n101iO :	STD_LOGIC;
	 SIGNAL  n101li :	STD_LOGIC;
	 SIGNAL  n101ll :	STD_LOGIC;
	 SIGNAL  n101lO :	STD_LOGIC;
	 SIGNAL  n101Oi :	STD_LOGIC;
	 SIGNAL  n101Ol :	STD_LOGIC;
	 SIGNAL  n101OO :	STD_LOGIC;
	 SIGNAL  n10i0i :	STD_LOGIC;
	 SIGNAL  n10i0l :	STD_LOGIC;
	 SIGNAL  n10i0O :	STD_LOGIC;
	 SIGNAL  n10i1i :	STD_LOGIC;
	 SIGNAL  n10i1l :	STD_LOGIC;
	 SIGNAL  n10i1O :	STD_LOGIC;
	 SIGNAL  n10iii :	STD_LOGIC;
	 SIGNAL  n10iil :	STD_LOGIC;
	 SIGNAL  n10iiO :	STD_LOGIC;
	 SIGNAL  n10ili :	STD_LOGIC;
	 SIGNAL  n10ill :	STD_LOGIC;
	 SIGNAL  n10ilO :	STD_LOGIC;
	 SIGNAL  n10iOi :	STD_LOGIC;
	 SIGNAL  n10iOl :	STD_LOGIC;
	 SIGNAL  n10iOO :	STD_LOGIC;
	 SIGNAL  n10l0i :	STD_LOGIC;
	 SIGNAL  n10l0l :	STD_LOGIC;
	 SIGNAL  n10l0O :	STD_LOGIC;
	 SIGNAL  n10l1i :	STD_LOGIC;
	 SIGNAL  n10l1l :	STD_LOGIC;
	 SIGNAL  n10l1O :	STD_LOGIC;
	 SIGNAL  n10lii :	STD_LOGIC;
	 SIGNAL  n10lil :	STD_LOGIC;
	 SIGNAL  n10liO :	STD_LOGIC;
	 SIGNAL  n10lli :	STD_LOGIC;
	 SIGNAL  n10lll :	STD_LOGIC;
	 SIGNAL  n10llO :	STD_LOGIC;
	 SIGNAL  n10lOi :	STD_LOGIC;
	 SIGNAL  n10lOl :	STD_LOGIC;
	 SIGNAL  n10lOO :	STD_LOGIC;
	 SIGNAL  n10O0i :	STD_LOGIC;
	 SIGNAL  n10O0l :	STD_LOGIC;
	 SIGNAL  n10O0O :	STD_LOGIC;
	 SIGNAL  n10O1i :	STD_LOGIC;
	 SIGNAL  n10O1l :	STD_LOGIC;
	 SIGNAL  n10O1O :	STD_LOGIC;
	 SIGNAL  n10Oii :	STD_LOGIC;
	 SIGNAL  n10Oil :	STD_LOGIC;
	 SIGNAL  n10OiO :	STD_LOGIC;
	 SIGNAL  n10Oli :	STD_LOGIC;
	 SIGNAL  n10Oll :	STD_LOGIC;
	 SIGNAL  n10OlO :	STD_LOGIC;
	 SIGNAL  n10OOi :	STD_LOGIC;
	 SIGNAL  n10OOl :	STD_LOGIC;
	 SIGNAL  n10OOO :	STD_LOGIC;
	 SIGNAL  n11l0l :	STD_LOGIC;
	 SIGNAL  n11l0O :	STD_LOGIC;
	 SIGNAL  n11lii :	STD_LOGIC;
	 SIGNAL  n11lil :	STD_LOGIC;
	 SIGNAL  n11liO :	STD_LOGIC;
	 SIGNAL  n11lli :	STD_LOGIC;
	 SIGNAL  n11lll :	STD_LOGIC;
	 SIGNAL  n11llO :	STD_LOGIC;
	 SIGNAL  n11lOi :	STD_LOGIC;
	 SIGNAL  n11lOl :	STD_LOGIC;
	 SIGNAL  n11lOO :	STD_LOGIC;
	 SIGNAL  n11O0i :	STD_LOGIC;
	 SIGNAL  n11O0l :	STD_LOGIC;
	 SIGNAL  n11O0O :	STD_LOGIC;
	 SIGNAL  n11O1i :	STD_LOGIC;
	 SIGNAL  n11O1l :	STD_LOGIC;
	 SIGNAL  n11O1O :	STD_LOGIC;
	 SIGNAL  n11Oii :	STD_LOGIC;
	 SIGNAL  n11Oil :	STD_LOGIC;
	 SIGNAL  n11OiO :	STD_LOGIC;
	 SIGNAL  n11Oli :	STD_LOGIC;
	 SIGNAL  n11Oll :	STD_LOGIC;
	 SIGNAL  n11OlO :	STD_LOGIC;
	 SIGNAL  n11OOi :	STD_LOGIC;
	 SIGNAL  n11OOl :	STD_LOGIC;
	 SIGNAL  n11OOO :	STD_LOGIC;
	 SIGNAL  n1i00i :	STD_LOGIC;
	 SIGNAL  n1i00l :	STD_LOGIC;
	 SIGNAL  n1i00O :	STD_LOGIC;
	 SIGNAL  n1i01i :	STD_LOGIC;
	 SIGNAL  n1i01l :	STD_LOGIC;
	 SIGNAL  n1i01O :	STD_LOGIC;
	 SIGNAL  n1i0ii :	STD_LOGIC;
	 SIGNAL  n1i0il :	STD_LOGIC;
	 SIGNAL  n1i0iO :	STD_LOGIC;
	 SIGNAL  n1i0li :	STD_LOGIC;
	 SIGNAL  n1i0ll :	STD_LOGIC;
	 SIGNAL  n1i0lO :	STD_LOGIC;
	 SIGNAL  n1i0Oi :	STD_LOGIC;
	 SIGNAL  n1i0Ol :	STD_LOGIC;
	 SIGNAL  n1i0OO :	STD_LOGIC;
	 SIGNAL  n1i10i :	STD_LOGIC;
	 SIGNAL  n1i10l :	STD_LOGIC;
	 SIGNAL  n1i10O :	STD_LOGIC;
	 SIGNAL  n1i11i :	STD_LOGIC;
	 SIGNAL  n1i11l :	STD_LOGIC;
	 SIGNAL  n1i11O :	STD_LOGIC;
	 SIGNAL  n1i1ii :	STD_LOGIC;
	 SIGNAL  n1i1il :	STD_LOGIC;
	 SIGNAL  n1i1iO :	STD_LOGIC;
	 SIGNAL  n1i1li :	STD_LOGIC;
	 SIGNAL  n1i1ll :	STD_LOGIC;
	 SIGNAL  n1i1lO :	STD_LOGIC;
	 SIGNAL  n1i1Oi :	STD_LOGIC;
	 SIGNAL  n1i1Ol :	STD_LOGIC;
	 SIGNAL  n1i1OO :	STD_LOGIC;
	 SIGNAL  n1ii0i :	STD_LOGIC;
	 SIGNAL  n1ii0l :	STD_LOGIC;
	 SIGNAL  n1ii0O :	STD_LOGIC;
	 SIGNAL  n1ii1i :	STD_LOGIC;
	 SIGNAL  n1ii1l :	STD_LOGIC;
	 SIGNAL  n1ii1O :	STD_LOGIC;
	 SIGNAL  n1iiii :	STD_LOGIC;
	 SIGNAL  n1iiil :	STD_LOGIC;
	 SIGNAL  n1iiiO :	STD_LOGIC;
	 SIGNAL  n1iili :	STD_LOGIC;
	 SIGNAL  n1iill :	STD_LOGIC;
	 SIGNAL  n1iilO :	STD_LOGIC;
	 SIGNAL  n1iiOi :	STD_LOGIC;
	 SIGNAL  n1iiOl :	STD_LOGIC;
	 SIGNAL  n1iiOO :	STD_LOGIC;
	 SIGNAL  n1il0i :	STD_LOGIC;
	 SIGNAL  n1il0l :	STD_LOGIC;
	 SIGNAL  n1il0O :	STD_LOGIC;
	 SIGNAL  n1il1i :	STD_LOGIC;
	 SIGNAL  n1il1l :	STD_LOGIC;
	 SIGNAL  n1il1O :	STD_LOGIC;
	 SIGNAL  n1ilii :	STD_LOGIC;
	 SIGNAL  n1ilil :	STD_LOGIC;
	 SIGNAL  n1iliO :	STD_LOGIC;
	 SIGNAL  n1illi :	STD_LOGIC;
	 SIGNAL  n1illl :	STD_LOGIC;
	 SIGNAL  n1illO :	STD_LOGIC;
	 SIGNAL  n1ilOi :	STD_LOGIC;
	 SIGNAL  n1ilOl :	STD_LOGIC;
	 SIGNAL  n1ilOO :	STD_LOGIC;
	 SIGNAL  n1iO0i :	STD_LOGIC;
	 SIGNAL  n1iO0l :	STD_LOGIC;
	 SIGNAL  n1iO0O :	STD_LOGIC;
	 SIGNAL  n1iO1i :	STD_LOGIC;
	 SIGNAL  n1iO1l :	STD_LOGIC;
	 SIGNAL  n1iO1O :	STD_LOGIC;
	 SIGNAL  n1iOii :	STD_LOGIC;
	 SIGNAL  n1iOil :	STD_LOGIC;
	 SIGNAL  n1iOiO :	STD_LOGIC;
	 SIGNAL  n1iOli :	STD_LOGIC;
	 SIGNAL  n1iOll :	STD_LOGIC;
	 SIGNAL  n1iOlO :	STD_LOGIC;
	 SIGNAL  n1iOOi :	STD_LOGIC;
	 SIGNAL  n1iOOl :	STD_LOGIC;
	 SIGNAL  n1iOOO :	STD_LOGIC;
	 SIGNAL  n1l00i :	STD_LOGIC;
	 SIGNAL  n1l00l :	STD_LOGIC;
	 SIGNAL  n1l00O :	STD_LOGIC;
	 SIGNAL  n1l01i :	STD_LOGIC;
	 SIGNAL  n1l01l :	STD_LOGIC;
	 SIGNAL  n1l01O :	STD_LOGIC;
	 SIGNAL  n1l0ii :	STD_LOGIC;
	 SIGNAL  n1l0il :	STD_LOGIC;
	 SIGNAL  n1l0iO :	STD_LOGIC;
	 SIGNAL  n1l0li :	STD_LOGIC;
	 SIGNAL  n1l0ll :	STD_LOGIC;
	 SIGNAL  n1l0lO :	STD_LOGIC;
	 SIGNAL  n1l0Oi :	STD_LOGIC;
	 SIGNAL  n1l0Ol :	STD_LOGIC;
	 SIGNAL  n1l0OO :	STD_LOGIC;
	 SIGNAL  n1l10i :	STD_LOGIC;
	 SIGNAL  n1l10l :	STD_LOGIC;
	 SIGNAL  n1l10O :	STD_LOGIC;
	 SIGNAL  n1l11i :	STD_LOGIC;
	 SIGNAL  n1l11l :	STD_LOGIC;
	 SIGNAL  n1l11O :	STD_LOGIC;
	 SIGNAL  n1l1ii :	STD_LOGIC;
	 SIGNAL  n1l1il :	STD_LOGIC;
	 SIGNAL  n1l1iO :	STD_LOGIC;
	 SIGNAL  n1l1li :	STD_LOGIC;
	 SIGNAL  n1l1ll :	STD_LOGIC;
	 SIGNAL  n1l1lO :	STD_LOGIC;
	 SIGNAL  n1l1Oi :	STD_LOGIC;
	 SIGNAL  n1l1Ol :	STD_LOGIC;
	 SIGNAL  n1l1OO :	STD_LOGIC;
	 SIGNAL  n1li0i :	STD_LOGIC;
	 SIGNAL  n1li0l :	STD_LOGIC;
	 SIGNAL  n1li0O :	STD_LOGIC;
	 SIGNAL  n1li1i :	STD_LOGIC;
	 SIGNAL  n1li1l :	STD_LOGIC;
	 SIGNAL  n1li1O :	STD_LOGIC;
	 SIGNAL  n1liii :	STD_LOGIC;
	 SIGNAL  n1liil :	STD_LOGIC;
	 SIGNAL  n1liiO :	STD_LOGIC;
	 SIGNAL  n1lili :	STD_LOGIC;
	 SIGNAL  n1lill :	STD_LOGIC;
	 SIGNAL  n1lilO :	STD_LOGIC;
	 SIGNAL  n1liOi :	STD_LOGIC;
	 SIGNAL  n1liOl :	STD_LOGIC;
	 SIGNAL  n1liOO :	STD_LOGIC;
	 SIGNAL  n1ll0i :	STD_LOGIC;
	 SIGNAL  n1ll0l :	STD_LOGIC;
	 SIGNAL  n1ll0O :	STD_LOGIC;
	 SIGNAL  n1ll1i :	STD_LOGIC;
	 SIGNAL  n1ll1l :	STD_LOGIC;
	 SIGNAL  n1ll1O :	STD_LOGIC;
	 SIGNAL  n1llii :	STD_LOGIC;
	 SIGNAL  n1llil :	STD_LOGIC;
	 SIGNAL  n1lliO :	STD_LOGIC;
	 SIGNAL  n1llli :	STD_LOGIC;
	 SIGNAL  n1llll :	STD_LOGIC;
	 SIGNAL  n1lllO :	STD_LOGIC;
	 SIGNAL  n1llOi :	STD_LOGIC;
	 SIGNAL  n1llOl :	STD_LOGIC;
	 SIGNAL  n1llOO :	STD_LOGIC;
	 SIGNAL  n1lO0l :	STD_LOGIC;
	 SIGNAL  n1lO1i :	STD_LOGIC;
	 SIGNAL  n1lO1l :	STD_LOGIC;
	 SIGNAL  n1lOOl :	STD_LOGIC;
	 SIGNAL  n1O0li :	STD_LOGIC;
	 SIGNAL  n1O0ll :	STD_LOGIC;
	 SIGNAL  n1O0lO :	STD_LOGIC;
	 SIGNAL  n1O0Oi :	STD_LOGIC;
	 SIGNAL  n1O1lO :	STD_LOGIC;
	 SIGNAL  n1Oi0i :	STD_LOGIC;
	 SIGNAL  n1Oi0l :	STD_LOGIC;
	 SIGNAL  n1Oi0O :	STD_LOGIC;
	 SIGNAL  n1Oi1i :	STD_LOGIC;
	 SIGNAL  n1Oi1l :	STD_LOGIC;
	 SIGNAL  n1Oi1O :	STD_LOGIC;
	 SIGNAL  n1Oiii :	STD_LOGIC;
	 SIGNAL  n1Oiil :	STD_LOGIC;
	 SIGNAL  n1OiiO :	STD_LOGIC;
	 SIGNAL  n1Oili :	STD_LOGIC;
	 SIGNAL  n1OiOO :	STD_LOGIC;
	 SIGNAL  n1Ol1O :	STD_LOGIC;
	 SIGNAL  w_n1lO0O276w :	STD_LOGIC;
	 SIGNAL  w_n1lO1O290w :	STD_LOGIC;
	 SIGNAL  w_n1lOil267w :	STD_LOGIC;
	 SIGNAL  w_n1lOli260w :	STD_LOGIC;
	 SIGNAL  w_n1lOlO250w :	STD_LOGIC;
	 SIGNAL  w_n1lOOO239w :	STD_LOGIC;
	 SIGNAL  w_n1O00i165w :	STD_LOGIC;
	 SIGNAL  w_n1O00O133w :	STD_LOGIC;
	 SIGNAL  w_n1O01l172w :	STD_LOGIC;
	 SIGNAL  w_n1O0il126w :	STD_LOGIC;
	 SIGNAL  w_n1O0Ol56w :	STD_LOGIC;
	 SIGNAL  w_n1O10i225w :	STD_LOGIC;
	 SIGNAL  w_n1O10O216w :	STD_LOGIC;
	 SIGNAL  w_n1O11l232w :	STD_LOGIC;
	 SIGNAL  w_n1O1il207w :	STD_LOGIC;
	 SIGNAL  w_n1O1li201w :	STD_LOGIC;
	 SIGNAL  w_n1O1Oi188w :	STD_LOGIC;
	 SIGNAL  w_n1O1OO181w :	STD_LOGIC;
	 SIGNAL  w_n1Oill36w :	STD_LOGIC;
	 SIGNAL  w_n1OiOi29w :	STD_LOGIC;
	 SIGNAL  wire_w_SYNC_COMP_PAT_range157w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_SYNC_COMP_PAT_range155w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_SYNC_COMP_PAT_range152w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_SYNC_COMP_PAT_range149w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_SYNC_COMP_PAT_range146w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_SYNC_COMP_PAT_range143w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_SYNC_COMP_PAT_range140w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_SYNC_COMP_PAT_range120w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_SYNC_COMP_PAT_range118w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_SYNC_COMP_PAT_range116w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 COMPONENT  oper_add
	 GENERIC 
	 (
		sgate_representation	:	NATURAL;
		width_a	:	NATURAL;
		width_b	:	NATURAL;
		width_o	:	NATURAL
	 );
	 PORT
	 ( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		b	:	IN STD_LOGIC_VECTOR(width_b-1 DOWNTO 0);
		cin	:	IN STD_LOGIC;
		cout	:	OUT STD_LOGIC;
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	 ); 
	 END COMPONENT;
	 COMPONENT  oper_decoder
	 GENERIC 
	 (
		width_i	:	NATURAL;
		width_o	:	NATURAL
	 );
	 PORT
	 ( 
		i	:	IN STD_LOGIC_VECTOR(width_i-1 DOWNTO 0);
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	 ); 
	 END COMPONENT;
	 COMPONENT  oper_less_than
	 GENERIC 
	 (
		sgate_representation	:	NATURAL;
		width_a	:	NATURAL;
		width_b	:	NATURAL
	 );
	 PORT
	 ( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		b	:	IN STD_LOGIC_VECTOR(width_b-1 DOWNTO 0);
		cin	:	IN STD_LOGIC;
		o	:	OUT STD_LOGIC
	 ); 
	 END COMPONENT;
	 COMPONENT  oper_selector
	 GENERIC 
	 (
		width_data	:	NATURAL;
		width_sel	:	NATURAL
	 );
	 PORT
	 ( 
		data	:	IN STD_LOGIC_VECTOR(width_data-1 DOWNTO 0);
		o	:	OUT STD_LOGIC;
		sel	:	IN STD_LOGIC_VECTOR(width_sel-1 DOWNTO 0)
	 ); 
	 END COMPONENT;
 BEGIN

	wire_gnd <= '0';
	wire_w_lg_w_lg_n1Oi0i48w49w(0) <= wire_w_lg_n1Oi0i48w(0) AND n1Oi1l;
	wire_w_lg_w_lg_GE_XAUI_SEL2472w2473w(0) <= wire_w_lg_GE_XAUI_SEL2472w(0) AND nl1i0i;
	wire_w_lg_w_lg_n1ll0l693w700w(0) <= wire_w_lg_n1ll0l693w(0) AND wire_n0i1OO_w_lg_w_lg_w_lg_Q697w698w699w(0);
	wire_w_lg_w_lg_n1ll0l693w695w(0) <= wire_w_lg_n1ll0l693w(0) AND n0i1Oi;
	wire_w_lg_w_lg_n1llii682w689w(0) <= wire_w_lg_n1llii682w(0) AND wire_n0i01l_w_lg_w_lg_w_lg_Q686w687w688w(0);
	wire_w_lg_w_lg_n1llii682w684w(0) <= wire_w_lg_n1llii682w(0) AND n0ilii;
	wire_w_lg_w_lg_n1lliO671w678w(0) <= wire_w_lg_n1lliO671w(0) AND wire_n0i00i_w_lg_w_lg_w_lg_Q675w676w677w(0);
	wire_w_lg_w_lg_n1lliO671w673w(0) <= wire_w_lg_n1lliO671w(0) AND n0il0O;
	wire_w_lg_w_lg_n1llll660w667w(0) <= wire_w_lg_n1llll660w(0) AND wire_n0i00O_w_lg_w_lg_w_lg_Q664w665w666w(0);
	wire_w_lg_w_lg_n1llll660w662w(0) <= wire_w_lg_n1llll660w(0) AND n0il0l;
	wire_w_lg_w_lg_n1llOi649w656w(0) <= wire_w_lg_n1llOi649w(0) AND wire_n0i0il_w_lg_w_lg_w_lg_Q653w654w655w(0);
	wire_w_lg_w_lg_n1llOi649w651w(0) <= wire_w_lg_n1llOi649w(0) AND n0il0i;
	wire_w_lg_w_lg_n1llOO638w645w(0) <= wire_w_lg_n1llOO638w(0) AND wire_n0i0li_w_lg_w_lg_w_lg_Q642w643w644w(0);
	wire_w_lg_w_lg_n1llOO638w640w(0) <= wire_w_lg_n1llOO638w(0) AND n0il1O;
	wire_w_lg_w_lg_n1lO1l627w634w(0) <= wire_w_lg_n1lO1l627w(0) AND wire_n0i0lO_w_lg_w_lg_w_lg_Q631w632w633w(0);
	wire_w_lg_w_lg_n1lO1l627w629w(0) <= wire_w_lg_n1lO1l627w(0) AND n0il1l;
	wire_w_lg_w_lg_n1lOOl615w623w(0) <= wire_w_lg_n1lOOl615w(0) AND wire_n0iiOO_w_lg_w_lg_w_lg_Q620w621w622w(0);
	wire_w_lg_w_lg_n1lOOl615w618w(0) <= wire_w_lg_n1lOOl615w(0) AND n0il1i;
	wire_w_lg_w_lg_PMADATAWIDTH115w1738w(0) <= wire_w_lg_PMADATAWIDTH115w(0) AND n1i0il;
	wire_w_lg_w_lg_PMADATAWIDTH115w1485w(0) <= wire_w_lg_PMADATAWIDTH115w(0) AND n1i0Ol;
	wire_w_lg_w_lg_PMADATAWIDTH115w1469w(0) <= wire_w_lg_PMADATAWIDTH115w(0) AND n1ii0l;
	wire_w_lg_w_lg_PMADATAWIDTH115w1477w(0) <= wire_w_lg_PMADATAWIDTH115w(0) AND n1ii1l;
	wire_w_lg_w_lg_PMADATAWIDTH115w1461w(0) <= wire_w_lg_PMADATAWIDTH115w(0) AND n1iiil;
	wire_w_lg_w_lg_PMADATAWIDTH115w1704w(0) <= wire_w_lg_PMADATAWIDTH115w(0) AND n1il0O;
	wire_w_lg_w_lg_PMADATAWIDTH115w1433w(0) <= wire_w_lg_PMADATAWIDTH115w(0) AND niO1l;
	wire_w_lg_GE_XAUI_SEL2471w(0) <= GE_XAUI_SEL AND wire_w_lg_n1011i2470w(0);
	wire_w_lg_n1000i2141w(0) <= n1000i AND wire_nl0i1O_w_lg_Q2140w(0);
	wire_w_lg_n101iO2243w(0) <= n101iO AND wire_n0liil_w_lg_dataout1271w(0);
	wire_w_lg_n1l11O2145w(0) <= n1l11O AND n1iOOi;
	wire_w_lg_n1l1Oi1261w(0) <= n1l1Oi AND n1l1lO;
	wire_w_lg_n1l1Ol2212w(0) <= n1l1Ol AND n101iO;
	wire_w_lg_n1l1OO1259w(0) <= n1l1OO AND n1l1Ol;
	wire_w_lg_n1Oi0i48w(0) <= n1Oi0i AND n1Oi1O;
	wire_w_lg_PMADATAWIDTH1454w(0) <= PMADATAWIDTH AND wire_nilOi_w_lg_w_lg_w_lg_Q1451w1452w1453w(0);
	wire_w_lg_PMADATAWIDTH1446w(0) <= PMADATAWIDTH AND wire_nilOi_w_lg_w_lg_Q1444w1445w(0);
	wire_w_lg_PMADATAWIDTH1439w(0) <= PMADATAWIDTH AND wire_nilOl_w_lg_Q1438w(0);
	wire_w_lg_PMADATAWIDTH1286w(0) <= PMADATAWIDTH AND wire_w_lg_SYNC_SM_DIS1285w(0);
	wire_w_lg_PMADATAWIDTH1371w(0) <= PMADATAWIDTH AND wire_nilOi_w_lg_w_lg_w_lg_w_lg_Q1367w1368w1369w1370w(0);
	wire_w_lg_PMADATAWIDTH1361w(0) <= PMADATAWIDTH AND wire_nilOi_w_lg_w_lg_w_lg_Q1358w1359w1360w(0);
	wire_w_lg_PMADATAWIDTH1352w(0) <= PMADATAWIDTH AND wire_nilOl_w_lg_w_lg_Q1350w1351w(0);
	wire_w_lg_PMADATAWIDTH1411w(0) <= PMADATAWIDTH AND wire_w_lg_n1illl1410w(0);
	wire_w_lg_PMADATAWIDTH1401w(0) <= PMADATAWIDTH AND wire_w_lg_n1ilOl1400w(0);
	wire_w_lg_PMADATAWIDTH1381w(0) <= PMADATAWIDTH AND wire_w_lg_n1iO0l1380w(0);
	wire_w_lg_PMADATAWIDTH1391w(0) <= PMADATAWIDTH AND wire_w_lg_n1iO1l1390w(0);
	wire_w_lg_PMADATAWIDTH1530w(0) <= PMADATAWIDTH AND wire_nilOO_w_lg_Q1529w(0);
	wire_w_lg_SYNC_SM_DIS1285w(0) <= SYNC_SM_DIS AND nl1Oii;
	wire_w_lg_DISABLE_RX_DISP1281w(0) <= NOT DISABLE_RX_DISP;
	wire_w_lg_GE_XAUI_SEL2472w(0) <= NOT GE_XAUI_SEL;
	wire_w_lg_n1001O2114w(0) <= NOT n1001O;
	wire_w_lg_n100Oi1903w(0) <= NOT n100Oi;
	wire_w_lg_n1011i2470w(0) <= NOT n1011i;
	wire_w_lg_n10i0i1763w(0) <= NOT n10i0i;
	wire_w_lg_n10i0l1764w(0) <= NOT n10i0l;
	wire_w_lg_n10i0O1746w(0) <= NOT n10i0O;
	wire_w_lg_n10i1i1898w(0) <= NOT n10i1i;
	wire_w_lg_n10i1O1872w(0) <= NOT n10i1O;
	wire_w_lg_n10iii1745w(0) <= NOT n10iii;
	wire_w_lg_n10iil1744w(0) <= NOT n10iil;
	wire_w_lg_n10iiO1743w(0) <= NOT n10iiO;
	wire_w_lg_n10ili1742w(0) <= NOT n10ili;
	wire_w_lg_n10ill1741w(0) <= NOT n10ill;
	wire_w_lg_n10ilO1740w(0) <= NOT n10ilO;
	wire_w_lg_n10iOi1712w(0) <= NOT n10iOi;
	wire_w_lg_n10iOl1711w(0) <= NOT n10iOl;
	wire_w_lg_n10iOO1710w(0) <= NOT n10iOO;
	wire_w_lg_n10l0i1706w(0) <= NOT n10l0i;
	wire_w_lg_n10l1i1709w(0) <= NOT n10l1i;
	wire_w_lg_n10l1l1708w(0) <= NOT n10l1l;
	wire_w_lg_n10l1O1707w(0) <= NOT n10l1O;
	wire_w_lg_n10lii1684w(0) <= NOT n10lii;
	wire_w_lg_n10lil1677w(0) <= NOT n10lil;
	wire_w_lg_n10liO1675w(0) <= NOT n10liO;
	wire_w_lg_n10lli1736w(0) <= NOT n10lli;
	wire_w_lg_n10lll1681w(0) <= NOT n10lll;
	wire_w_lg_n10llO1673w(0) <= NOT n10llO;
	wire_w_lg_n10lOi1671w(0) <= NOT n10lOi;
	wire_w_lg_n10lOl1679w(0) <= NOT n10lOl;
	wire_w_lg_n10O0i1629w(0) <= NOT n10O0i;
	wire_w_lg_n10O0l1726w(0) <= NOT n10O0l;
	wire_w_lg_n10O0O1635w(0) <= NOT n10O0O;
	wire_w_lg_n10O1l1638w(0) <= NOT n10O1l;
	wire_w_lg_n10O1O1631w(0) <= NOT n10O1O;
	wire_w_lg_n10Oii1627w(0) <= NOT n10Oii;
	wire_w_lg_n10Oil1625w(0) <= NOT n10Oil;
	wire_w_lg_n10OiO1633w(0) <= NOT n10OiO;
	wire_w_lg_n10OlO1592w(0) <= NOT n10OlO;
	wire_w_lg_n10OOi1585w(0) <= NOT n10OOi;
	wire_w_lg_n10OOl1583w(0) <= NOT n10OOl;
	wire_w_lg_n10OOO1702w(0) <= NOT n10OOO;
	wire_w_lg_n11O0i2491w(0) <= NOT n11O0i;
	wire_w_lg_n11O0l2479w(0) <= NOT n11O0l;
	wire_w_lg_n11O1O2492w(0) <= NOT n11O1O;
	wire_w_lg_n11Oii2466w(0) <= NOT n11Oii;
	wire_w_lg_n11Oli2518w(0) <= NOT n11Oli;
	wire_w_lg_n11Oll2469w(0) <= NOT n11Oll;
	wire_w_lg_n11OOl2682w(0) <= NOT n11OOl;
	wire_w_lg_n11OOO2494w(0) <= NOT n11OOO;
	wire_w_lg_n1i00i1650w(0) <= NOT n1i00i;
	wire_w_lg_n1i00l1653w(0) <= NOT n1i00l;
	wire_w_lg_n1i00O1656w(0) <= NOT n1i00O;
	wire_w_lg_n1i01l1644w(0) <= NOT n1i01l;
	wire_w_lg_n1i01O1647w(0) <= NOT n1i01O;
	wire_w_lg_n1i0ii1659w(0) <= NOT n1i0ii;
	wire_w_lg_n1i0li1594w(0) <= NOT n1i0li;
	wire_w_lg_n1i0lO1720w(0) <= NOT n1i0lO;
	wire_w_lg_n1i0Oi1729w(0) <= NOT n1i0Oi;
	wire_w_lg_n1i0OO1598w(0) <= NOT n1i0OO;
	wire_w_lg_n1i10i1587w(0) <= NOT n1i10i;
	wire_w_lg_n1i11i1589w(0) <= NOT n1i11i;
	wire_w_lg_n1i11l1581w(0) <= NOT n1i11l;
	wire_w_lg_n1i11O1579w(0) <= NOT n1i11O;
	wire_w_lg_n1i1ii1547w(0) <= NOT n1i1ii;
	wire_w_lg_n1i1il1540w(0) <= NOT n1i1il;
	wire_w_lg_n1i1iO1538w(0) <= NOT n1i1iO;
	wire_w_lg_n1i1li1693w(0) <= NOT n1i1li;
	wire_w_lg_n1i1ll1544w(0) <= NOT n1i1ll;
	wire_w_lg_n1i1lO1536w(0) <= NOT n1i1lO;
	wire_w_lg_n1i1Oi1534w(0) <= NOT n1i1Oi;
	wire_w_lg_n1i1Ol1542w(0) <= NOT n1i1Ol;
	wire_w_lg_n1i1OO1640w(0) <= NOT n1i1OO;
	wire_w_lg_n1ii0O1604w(0) <= NOT n1ii0O;
	wire_w_lg_n1ii1O1601w(0) <= NOT n1ii1O;
	wire_w_lg_n1iiiO1607w(0) <= NOT n1iiiO;
	wire_w_lg_n1iili1610w(0) <= NOT n1iili;
	wire_w_lg_n1iill1613w(0) <= NOT n1iill;
	wire_w_lg_n1iilO1615w(0) <= NOT n1iilO;
	wire_w_lg_n1iiOi1549w(0) <= NOT n1iiOi;
	wire_w_lg_n1iiOl1431w(0) <= NOT n1iiOl;
	wire_w_lg_n1iiOO1554w(0) <= NOT n1iiOO;
	wire_w_lg_n1il0i1566w(0) <= NOT n1il0i;
	wire_w_lg_n1il0l1577w(0) <= NOT n1il0l;
	wire_w_lg_n1il1i1557w(0) <= NOT n1il1i;
	wire_w_lg_n1il1l1560w(0) <= NOT n1il1l;
	wire_w_lg_n1il1O1563w(0) <= NOT n1il1O;
	wire_w_lg_n1ilii1419w(0) <= NOT n1ilii;
	wire_w_lg_n1ilil1505w(0) <= NOT n1ilil;
	wire_w_lg_n1iliO1415w(0) <= NOT n1iliO;
	wire_w_lg_n1illi1687w(0) <= NOT n1illi;
	wire_w_lg_n1illl1410w(0) <= NOT n1illl;
	wire_w_lg_n1illO1408w(0) <= NOT n1illO;
	wire_w_lg_n1ilOi1509w(0) <= NOT n1ilOi;
	wire_w_lg_n1ilOl1400w(0) <= NOT n1ilOl;
	wire_w_lg_n1ilOO1398w(0) <= NOT n1ilOO;
	wire_w_lg_n1iO0i1515w(0) <= NOT n1iO0i;
	wire_w_lg_n1iO0l1380w(0) <= NOT n1iO0l;
	wire_w_lg_n1iO0O1378w(0) <= NOT n1iO0O;
	wire_w_lg_n1iO1i1512w(0) <= NOT n1iO1i;
	wire_w_lg_n1iO1l1390w(0) <= NOT n1iO1l;
	wire_w_lg_n1iO1O1388w(0) <= NOT n1iO1O;
	wire_w_lg_n1iOii1518w(0) <= NOT n1iOii;
	wire_w_lg_n1iOil1521w(0) <= NOT n1iOil;
	wire_w_lg_n1iOiO1524w(0) <= NOT n1iOiO;
	wire_w_lg_n1iOOl1293w(0) <= NOT n1iOOl;
	wire_w_lg_n1iOOO1292w(0) <= NOT n1iOOO;
	wire_w_lg_n1l00O1254w(0) <= NOT n1l00O;
	wire_w_lg_n1l11i1291w(0) <= NOT n1l11i;
	wire_w_lg_n1li0l786w(0) <= NOT n1li0l;
	wire_w_lg_n1li0O753w(0) <= NOT n1li0O;
	wire_w_lg_n1liii751w(0) <= NOT n1liii;
	wire_w_lg_n1liil749w(0) <= NOT n1liil;
	wire_w_lg_n1liiO747w(0) <= NOT n1liiO;
	wire_w_lg_n1lili745w(0) <= NOT n1lili;
	wire_w_lg_n1lill743w(0) <= NOT n1lill;
	wire_w_lg_n1lilO741w(0) <= NOT n1lilO;
	wire_w_lg_n1liOi739w(0) <= NOT n1liOi;
	wire_w_lg_n1liOl737w(0) <= NOT n1liOl;
	wire_w_lg_n1liOO735w(0) <= NOT n1liOO;
	wire_w_lg_n1ll0i704w(0) <= NOT n1ll0i;
	wire_w_lg_n1ll0l693w(0) <= NOT n1ll0l;
	wire_w_lg_n1ll0O692w(0) <= NOT n1ll0O;
	wire_w_lg_n1ll1i706w(0) <= NOT n1ll1i;
	wire_w_lg_n1ll1l707w(0) <= NOT n1ll1l;
	wire_w_lg_n1ll1O703w(0) <= NOT n1ll1O;
	wire_w_lg_n1llii682w(0) <= NOT n1llii;
	wire_w_lg_n1llil681w(0) <= NOT n1llil;
	wire_w_lg_n1lliO671w(0) <= NOT n1lliO;
	wire_w_lg_n1llli670w(0) <= NOT n1llli;
	wire_w_lg_n1llll660w(0) <= NOT n1llll;
	wire_w_lg_n1lllO659w(0) <= NOT n1lllO;
	wire_w_lg_n1llOi649w(0) <= NOT n1llOi;
	wire_w_lg_n1llOl648w(0) <= NOT n1llOl;
	wire_w_lg_n1llOO638w(0) <= NOT n1llOO;
	wire_w_lg_n1lO0l626w(0) <= NOT n1lO0l;
	wire_w_lg_n1lO1i637w(0) <= NOT n1lO1i;
	wire_w_lg_n1lO1l627w(0) <= NOT n1lO1l;
	wire_w_lg_n1lOOl615w(0) <= NOT n1lOOl;
	wire_w_lg_n1O0li119w(0) <= NOT n1O0li;
	wire_w_lg_n1O0ll117w(0) <= NOT n1O0ll;
	wire_w_lg_n1O0Oi58w(0) <= NOT n1O0Oi;
	wire_w_lg_n1O1lO614w(0) <= NOT n1O1lO;
	wire_w_lg_n1Oi0l59w(0) <= NOT n1Oi0l;
	wire_w_lg_n1Oi0O52w(0) <= NOT n1Oi0O;
	wire_w_lg_n1Oi1i50w(0) <= NOT n1Oi1i;
	wire_w_lg_n1Oiil43w(0) <= NOT n1Oiil;
	wire_w_lg_PMADATAWIDTH115w(0) <= NOT PMADATAWIDTH;
	wire_w_lg_rcvd_clk45w(0) <= NOT rcvd_clk;
	wire_w_lg_soft_reset46w(0) <= NOT soft_reset;
	wire_w_lg_SYNC_SM_DIS1288w(0) <= NOT SYNC_SM_DIS;
	wire_w_lg_w_n1lO0O276w277w(0) <= NOT w_n1lO0O276w;
	wire_w_lg_w_n1lO1O290w291w(0) <= NOT w_n1lO1O290w;
	wire_w_lg_w_n1lOil267w268w(0) <= NOT w_n1lOil267w;
	wire_w_lg_w_n1lOli260w261w(0) <= NOT w_n1lOli260w;
	wire_w_lg_w_n1lOlO250w251w(0) <= NOT w_n1lOlO250w;
	wire_w_lg_w_n1lOOO239w240w(0) <= NOT w_n1lOOO239w;
	wire_w_lg_w_n1O00i165w166w(0) <= NOT w_n1O00i165w;
	wire_w_lg_w_n1O00O133w134w(0) <= NOT w_n1O00O133w;
	wire_w_lg_w_n1O01l172w173w(0) <= NOT w_n1O01l172w;
	wire_w_lg_w_n1O0il126w127w(0) <= NOT w_n1O0il126w;
	wire_w_lg_w_n1O10i225w226w(0) <= NOT w_n1O10i225w;
	wire_w_lg_w_n1O10O216w217w(0) <= NOT w_n1O10O216w;
	wire_w_lg_w_n1O11l232w233w(0) <= NOT w_n1O11l232w;
	wire_w_lg_w_n1O1il207w208w(0) <= NOT w_n1O1il207w;
	wire_w_lg_w_n1O1li201w202w(0) <= NOT w_n1O1li201w;
	wire_w_lg_w_n1O1Oi188w189w(0) <= NOT w_n1O1Oi188w;
	wire_w_lg_w_n1O1OO181w182w(0) <= NOT w_n1O1OO181w;
	wire_w_lg_w_n1Oill36w37w(0) <= NOT w_n1Oill36w;
	wire_w_lg_w_n1OiOi29w30w(0) <= NOT w_n1OiOi29w;
	wire_w_lg_w_SYNC_COMP_PAT_range157w158w(0) <= NOT wire_w_SYNC_COMP_PAT_range157w(0);
	wire_w_lg_w_SYNC_COMP_PAT_range155w156w(0) <= NOT wire_w_SYNC_COMP_PAT_range155w(0);
	wire_w_lg_w_SYNC_COMP_PAT_range152w153w(0) <= NOT wire_w_SYNC_COMP_PAT_range152w(0);
	wire_w_lg_w_SYNC_COMP_PAT_range149w150w(0) <= NOT wire_w_SYNC_COMP_PAT_range149w(0);
	wire_w_lg_w_SYNC_COMP_PAT_range146w147w(0) <= NOT wire_w_SYNC_COMP_PAT_range146w(0);
	wire_w_lg_w_SYNC_COMP_PAT_range143w144w(0) <= NOT wire_w_SYNC_COMP_PAT_range143w(0);
	wire_w_lg_w_SYNC_COMP_PAT_range140w141w(0) <= NOT wire_w_SYNC_COMP_PAT_range140w(0);
	wire_w_lg_w_SYNC_COMP_PAT_range120w138w(0) <= NOT wire_w_SYNC_COMP_PAT_range120w(0);
	wire_w_lg_w_SYNC_COMP_PAT_range118w137w(0) <= NOT wire_w_SYNC_COMP_PAT_range118w(0);
	wire_w_lg_w_SYNC_COMP_PAT_range116w136w(0) <= NOT wire_w_SYNC_COMP_PAT_range116w(0);
	wire_w_lg_w_lg_PMADATAWIDTH115w1766w(0) <= wire_w_lg_PMADATAWIDTH115w(0) OR wire_nii1lO_w_lg_Q1765w(0);
	wire_w_lg_w_lg_w_lg_PMADATAWIDTH115w1766w1776w(0) <= wire_w_lg_w_lg_PMADATAWIDTH115w1766w(0) OR nillO;
	wire_w_lg_w_lg_w_lg_PMADATAWIDTH115w1766w1767w(0) <= wire_w_lg_w_lg_PMADATAWIDTH115w1766w(0) OR nilOi;
	wire_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH115w1766w1776w1777w(0) <= wire_w_lg_w_lg_w_lg_PMADATAWIDTH115w1766w1776w(0) OR nilll;
	wire_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH115w1766w1767w1768w(0) <= wire_w_lg_w_lg_w_lg_PMADATAWIDTH115w1766w1767w(0) OR nillO;
	wire_w_lg_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH115w1766w1776w1777w1778w(0) <= wire_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH115w1766w1776w1777w(0) OR nilli;
	wire_w_lg_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH115w1766w1767w1768w1769w(0) <= wire_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH115w1766w1767w1768w(0) OR nilll;
	wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH115w1766w1776w1777w1778w1779w(0) <= wire_w_lg_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH115w1766w1776w1777w1778w(0) OR niliO;
	wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH115w1766w1767w1768w1769w1770w(0) <= wire_w_lg_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH115w1766w1767w1768w1769w(0) OR nilli;
	wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH115w1766w1776w1777w1778w1779w1780w(0) <= wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH115w1766w1776w1777w1778w1779w(0) OR nilil;
	wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH115w1766w1767w1768w1769w1770w1774w(0) <= wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH115w1766w1767w1768w1769w1770w(0) OR niliO;
	wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_n1il0O1507w1508w1511w1514w1517w1520w1523w1526w(0) <= wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_n1il0O1507w1508w1511w1514w1517w1520w1523w(0) OR n1iOiO;
	wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_n1i0il1596w1597w1600w1603w1606w1609w1612w(0) <= wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_n1i0il1596w1597w1600w1603w1606w1609w(0) OR n1iili;
	wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_n1i0il1642w1643w1646w1649w1652w1655w1658w(0) <= wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_n1i0il1642w1643w1646w1649w1652w1655w(0) OR n1i00O;
	wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_n1il0O1507w1508w1511w1514w1517w1520w1523w(0) <= wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_n1il0O1507w1508w1511w1514w1517w1520w(0) OR n1iOil;
	wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH1782w1783w1784w1785w1790w1794w1797w(0) <= wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH1782w1783w1784w1785w1790w1794w(0) OR nilil;
	wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_n1i0il1596w1597w1600w1603w1606w1609w(0) <= wire_w_lg_w_lg_w_lg_w_lg_w_lg_n1i0il1596w1597w1600w1603w1606w(0) OR n1iiiO;
	wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_n1i0il1642w1643w1646w1649w1652w1655w(0) <= wire_w_lg_w_lg_w_lg_w_lg_w_lg_n1i0il1642w1643w1646w1649w1652w(0) OR n1i00l;
	wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_n1il0O1507w1508w1511w1514w1517w1520w(0) <= wire_w_lg_w_lg_w_lg_w_lg_w_lg_n1il0O1507w1508w1511w1514w1517w(0) OR n1iOii;
	wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_n1l01O1257w1258w1260w1262w1263w1264w(0) <= wire_w_lg_w_lg_w_lg_w_lg_w_lg_n1l01O1257w1258w1260w1262w1263w(0) OR n1l1li;
	wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH1782w1783w1784w1785w1790w1794w(0) <= wire_w_lg_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH1782w1783w1784w1785w1790w(0) OR niliO;
	wire_w_lg_w_lg_w_lg_w_lg_w_lg_n1i0il1596w1597w1600w1603w1606w(0) <= wire_w_lg_w_lg_w_lg_w_lg_n1i0il1596w1597w1600w1603w(0) OR n1ii0O;
	wire_w_lg_w_lg_w_lg_w_lg_w_lg_n1i0il1642w1643w1646w1649w1652w(0) <= wire_w_lg_w_lg_w_lg_w_lg_n1i0il1642w1643w1646w1649w(0) OR n1i00i;
	wire_w_lg_w_lg_w_lg_w_lg_w_lg_n1il0O1507w1508w1511w1514w1517w(0) <= wire_w_lg_w_lg_w_lg_w_lg_n1il0O1507w1508w1511w1514w(0) OR n1iO0i;
	wire_w_lg_w_lg_w_lg_w_lg_w_lg_n1l01O1257w1258w1260w1262w1263w(0) <= wire_w_lg_w_lg_w_lg_w_lg_n1l01O1257w1258w1260w1262w(0) OR n1l1ll;
	wire_w_lg_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH1782w1783w1784w1785w1790w(0) <= wire_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH1782w1783w1784w1785w(0) OR nilli;
	wire_w_lg_w_lg_w_lg_w_lg_n1i0il1596w1597w1600w1603w(0) <= wire_w_lg_w_lg_w_lg_n1i0il1596w1597w1600w(0) OR n1ii1O;
	wire_w_lg_w_lg_w_lg_w_lg_n1i0il1642w1643w1646w1649w(0) <= wire_w_lg_w_lg_w_lg_n1i0il1642w1643w1646w(0) OR n1i01O;
	wire_w_lg_w_lg_w_lg_w_lg_n1il0O1507w1508w1511w1514w(0) <= wire_w_lg_w_lg_w_lg_n1il0O1507w1508w1511w(0) OR n1iO1i;
	wire_w_lg_w_lg_w_lg_w_lg_n1l01O1257w1258w1260w1262w(0) <= wire_w_lg_w_lg_w_lg_n1l01O1257w1258w1260w(0) OR wire_w_lg_n1l1Oi1261w(0);
	wire_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH1782w1783w1784w1785w(0) <= wire_w_lg_w_lg_w_lg_PMADATAWIDTH1782w1783w1784w(0) OR nilll;
	wire_w_lg_w_lg_w_lg_n1i0il1596w1597w1600w(0) <= wire_w_lg_w_lg_n1i0il1596w1597w(0) OR n1i0OO;
	wire_w_lg_w_lg_w_lg_n1i0il1642w1643w1646w(0) <= wire_w_lg_w_lg_n1i0il1642w1643w(0) OR n1i01l;
	wire_w_lg_w_lg_w_lg_n1il0O1507w1508w1511w(0) <= wire_w_lg_w_lg_n1il0O1507w1508w(0) OR n1ilOi;
	wire_w_lg_w_lg_w_lg_n1l01O1257w1258w1260w(0) <= wire_w_lg_w_lg_n1l01O1257w1258w(0) OR wire_w_lg_n1l1OO1259w(0);
	wire_w_lg_w_lg_w_lg_PMADATAWIDTH1782w1783w1784w(0) <= wire_w_lg_w_lg_PMADATAWIDTH1782w1783w(0) OR nillO;
	wire_w_lg_w_lg_n1i0il1596w1597w(0) <= wire_w_lg_n1i0il1596w(0) OR n1i0lO;
	wire_w_lg_w_lg_n1i0il1642w1643w(0) <= wire_w_lg_n1i0il1642w(0) OR n1i1OO;
	wire_w_lg_w_lg_n1il0O1551w1552w(0) <= wire_w_lg_n1il0O1551w(0) OR n1iiOi;
	wire_w_lg_w_lg_n1il0O1507w1508w(0) <= wire_w_lg_n1il0O1507w(0) OR n1illi;
	wire_w_lg_w_lg_n1l01O1257w1258w(0) <= wire_w_lg_n1l01O1257w(0) OR n1l01i;
	wire_w_lg_w_lg_n1l1ii1272w1273w(0) <= wire_w_lg_n1l1ii1272w(0) OR n1l10l;
	wire_w_lg_w_lg_PMADATAWIDTH1782w1783w(0) <= wire_w_lg_PMADATAWIDTH1782w(0) OR nilOi;
	wire_w_lg_n1001i2213w(0) <= n1001i OR wire_w_lg_n1l1Ol2212w(0);
	wire_w_lg_n1001i2129w(0) <= n1001i OR n101OO;
	wire_w_lg_n1001l2130w(0) <= n1001l OR wire_w_lg_n1001i2129w(0);
	wire_w_lg_n1001O2124w(0) <= n1001O OR n1iOOi;
	wire_w_lg_n1i0il1672w(0) <= n1i0il OR wire_w_lg_n10lOi1671w(0);
	wire_w_lg_n1i0il1728w(0) <= n1i0il OR wire_w_lg_n10lOl1679w(0);
	wire_w_lg_n1i0il1626w(0) <= n1i0il OR wire_w_lg_n10Oil1625w(0);
	wire_w_lg_n1i0il1719w(0) <= n1i0il OR wire_w_lg_n10OiO1633w(0);
	wire_w_lg_n1i0il1596w(0) <= n1i0il OR n1i0li;
	wire_w_lg_n1i0il1642w(0) <= n1i0il OR n1i0Oi;
	wire_w_lg_n1il0O1695w(0) <= n1il0O OR wire_w_lg_n1i10i1587w(0);
	wire_w_lg_n1il0O1580w(0) <= n1il0O OR wire_w_lg_n1i11O1579w(0);
	wire_w_lg_n1il0O1535w(0) <= n1il0O OR wire_w_lg_n1i1Oi1534w(0);
	wire_w_lg_n1il0O1686w(0) <= n1il0O OR wire_w_lg_n1i1Ol1542w(0);
	wire_w_lg_n1il0O1551w(0) <= n1il0O OR wire_w_lg_n1illl1410w(0);
	wire_w_lg_n1il0O1507w(0) <= n1il0O OR n1ilil;
	wire_w_lg_n1iOlO2125w(0) <= n1iOlO OR wire_w_lg_n1001O2124w(0);
	wire_w_lg_n1l01l2132w(0) <= n1l01l OR wire_w_lg_n1l01O2131w(0);
	wire_w_lg_n1l01O2131w(0) <= n1l01O OR n1l01i;
	wire_w_lg_n1l01O1257w(0) <= n1l01O OR n1l01l;
	wire_w_lg_n1l10i1278w(0) <= n1l10i OR wire_nl0i1O_w_lg_Q1277w(0);
	wire_w_lg_n1l1ii1272w(0) <= n1l1ii OR n1l10O;
	wire_w_lg_n1l1iO1268w(0) <= n1l1iO OR wire_nl00Ol_w_lg_w_lg_Q1266w1267w(0);
	wire_w_lg_n1l1ll2133w(0) <= n1l1ll OR wire_w_lg_n1l01l2132w(0);
	wire_w_lg_PMADATAWIDTH1782w(0) <= PMADATAWIDTH OR wire_nii1lO_w_lg_Q1765w(0);
	wire_w_lg_w_SYNC_COMP_PAT_range157w576w(0) <= wire_w_SYNC_COMP_PAT_range157w(0) XOR wire_n0lil_dataout;
	wire_w_lg_w_SYNC_COMP_PAT_range157w538w(0) <= wire_w_SYNC_COMP_PAT_range157w(0) XOR wire_n0liO_dataout;
	wire_w_lg_w_SYNC_COMP_PAT_range157w500w(0) <= wire_w_SYNC_COMP_PAT_range157w(0) XOR niOOO;
	wire_w_lg_w_SYNC_COMP_PAT_range157w348w(0) <= wire_w_SYNC_COMP_PAT_range157w(0) XOR nl10i;
	wire_w_lg_w_SYNC_COMP_PAT_range157w310w(0) <= wire_w_SYNC_COMP_PAT_range157w(0) XOR nl10l;
	wire_w_lg_w_SYNC_COMP_PAT_range157w247w(0) <= wire_w_SYNC_COMP_PAT_range157w(0) XOR nl10O;
	wire_w_lg_w_SYNC_COMP_PAT_range157w462w(0) <= wire_w_SYNC_COMP_PAT_range157w(0) XOR nl11i;
	wire_w_lg_w_SYNC_COMP_PAT_range157w424w(0) <= wire_w_SYNC_COMP_PAT_range157w(0) XOR nl11l;
	wire_w_lg_w_SYNC_COMP_PAT_range157w386w(0) <= wire_w_SYNC_COMP_PAT_range157w(0) XOR nl11O;
	wire_w_lg_w_SYNC_COMP_PAT_range157w159w(0) <= wire_w_SYNC_COMP_PAT_range157w(0) XOR nl1ii;
	wire_w_lg_w_SYNC_COMP_PAT_range155w577w(0) <= wire_w_SYNC_COMP_PAT_range155w(0) XOR wire_n0liO_dataout;
	wire_w_lg_w_SYNC_COMP_PAT_range155w539w(0) <= wire_w_SYNC_COMP_PAT_range155w(0) XOR wire_n0lli_dataout;
	wire_w_lg_w_SYNC_COMP_PAT_range155w387w(0) <= wire_w_SYNC_COMP_PAT_range155w(0) XOR nl10i;
	wire_w_lg_w_SYNC_COMP_PAT_range155w349w(0) <= wire_w_SYNC_COMP_PAT_range155w(0) XOR nl10l;
	wire_w_lg_w_SYNC_COMP_PAT_range155w311w(0) <= wire_w_SYNC_COMP_PAT_range155w(0) XOR nl10O;
	wire_w_lg_w_SYNC_COMP_PAT_range155w501w(0) <= wire_w_SYNC_COMP_PAT_range155w(0) XOR nl11i;
	wire_w_lg_w_SYNC_COMP_PAT_range155w463w(0) <= wire_w_SYNC_COMP_PAT_range155w(0) XOR nl11l;
	wire_w_lg_w_SYNC_COMP_PAT_range155w425w(0) <= wire_w_SYNC_COMP_PAT_range155w(0) XOR nl11O;
	wire_w_lg_w_SYNC_COMP_PAT_range155w253w(0) <= wire_w_SYNC_COMP_PAT_range155w(0) XOR nl1ii;
	wire_w_lg_w_SYNC_COMP_PAT_range155w160w(0) <= wire_w_SYNC_COMP_PAT_range155w(0) XOR nl1il;
	wire_w_lg_w_SYNC_COMP_PAT_range152w579w(0) <= wire_w_SYNC_COMP_PAT_range152w(0) XOR wire_n0lli_dataout;
	wire_w_lg_w_SYNC_COMP_PAT_range152w541w(0) <= wire_w_SYNC_COMP_PAT_range152w(0) XOR wire_n0lll_dataout;
	wire_w_lg_w_SYNC_COMP_PAT_range152w427w(0) <= wire_w_SYNC_COMP_PAT_range152w(0) XOR nl10i;
	wire_w_lg_w_SYNC_COMP_PAT_range152w389w(0) <= wire_w_SYNC_COMP_PAT_range152w(0) XOR nl10l;
	wire_w_lg_w_SYNC_COMP_PAT_range152w351w(0) <= wire_w_SYNC_COMP_PAT_range152w(0) XOR nl10O;
	wire_w_lg_w_SYNC_COMP_PAT_range152w503w(0) <= wire_w_SYNC_COMP_PAT_range152w(0) XOR nl11l;
	wire_w_lg_w_SYNC_COMP_PAT_range152w465w(0) <= wire_w_SYNC_COMP_PAT_range152w(0) XOR nl11O;
	wire_w_lg_w_SYNC_COMP_PAT_range152w313w(0) <= wire_w_SYNC_COMP_PAT_range152w(0) XOR nl1ii;
	wire_w_lg_w_SYNC_COMP_PAT_range152w255w(0) <= wire_w_SYNC_COMP_PAT_range152w(0) XOR nl1il;
	wire_w_lg_w_SYNC_COMP_PAT_range152w162w(0) <= wire_w_SYNC_COMP_PAT_range152w(0) XOR nl1iO;
	wire_w_lg_w_SYNC_COMP_PAT_range149w581w(0) <= wire_w_SYNC_COMP_PAT_range149w(0) XOR wire_n0lll_dataout;
	wire_w_lg_w_SYNC_COMP_PAT_range149w543w(0) <= wire_w_SYNC_COMP_PAT_range149w(0) XOR wire_n0llO_dataout;
	wire_w_lg_w_SYNC_COMP_PAT_range149w467w(0) <= wire_w_SYNC_COMP_PAT_range149w(0) XOR nl10i;
	wire_w_lg_w_SYNC_COMP_PAT_range149w429w(0) <= wire_w_SYNC_COMP_PAT_range149w(0) XOR nl10l;
	wire_w_lg_w_SYNC_COMP_PAT_range149w391w(0) <= wire_w_SYNC_COMP_PAT_range149w(0) XOR nl10O;
	wire_w_lg_w_SYNC_COMP_PAT_range149w505w(0) <= wire_w_SYNC_COMP_PAT_range149w(0) XOR nl11O;
	wire_w_lg_w_SYNC_COMP_PAT_range149w353w(0) <= wire_w_SYNC_COMP_PAT_range149w(0) XOR nl1ii;
	wire_w_lg_w_SYNC_COMP_PAT_range149w315w(0) <= wire_w_SYNC_COMP_PAT_range149w(0) XOR nl1il;
	wire_w_lg_w_SYNC_COMP_PAT_range149w257w(0) <= wire_w_SYNC_COMP_PAT_range149w(0) XOR nl1iO;
	wire_w_lg_w_SYNC_COMP_PAT_range149w169w(0) <= wire_w_SYNC_COMP_PAT_range149w(0) XOR nl1li;
	wire_w_lg_w_SYNC_COMP_PAT_range146w583w(0) <= wire_w_SYNC_COMP_PAT_range146w(0) XOR wire_n0llO_dataout;
	wire_w_lg_w_SYNC_COMP_PAT_range146w545w(0) <= wire_w_SYNC_COMP_PAT_range146w(0) XOR wire_n0lOi_dataout;
	wire_w_lg_w_SYNC_COMP_PAT_range146w507w(0) <= wire_w_SYNC_COMP_PAT_range146w(0) XOR nl10i;
	wire_w_lg_w_SYNC_COMP_PAT_range146w469w(0) <= wire_w_SYNC_COMP_PAT_range146w(0) XOR nl10l;
	wire_w_lg_w_SYNC_COMP_PAT_range146w431w(0) <= wire_w_SYNC_COMP_PAT_range146w(0) XOR nl10O;
	wire_w_lg_w_SYNC_COMP_PAT_range146w393w(0) <= wire_w_SYNC_COMP_PAT_range146w(0) XOR nl1ii;
	wire_w_lg_w_SYNC_COMP_PAT_range146w355w(0) <= wire_w_SYNC_COMP_PAT_range146w(0) XOR nl1il;
	wire_w_lg_w_SYNC_COMP_PAT_range146w317w(0) <= wire_w_SYNC_COMP_PAT_range146w(0) XOR nl1iO;
	wire_w_lg_w_SYNC_COMP_PAT_range146w264w(0) <= wire_w_SYNC_COMP_PAT_range146w(0) XOR nl1li;
	wire_w_lg_w_SYNC_COMP_PAT_range146w176w(0) <= wire_w_SYNC_COMP_PAT_range146w(0) XOR nl1ll;
	wire_w_lg_w_SYNC_COMP_PAT_range143w585w(0) <= wire_w_SYNC_COMP_PAT_range143w(0) XOR wire_n0lOi_dataout;
	wire_w_lg_w_SYNC_COMP_PAT_range143w547w(0) <= wire_w_SYNC_COMP_PAT_range143w(0) XOR wire_n0lOl_dataout;
	wire_w_lg_w_SYNC_COMP_PAT_range143w509w(0) <= wire_w_SYNC_COMP_PAT_range143w(0) XOR nl10l;
	wire_w_lg_w_SYNC_COMP_PAT_range143w471w(0) <= wire_w_SYNC_COMP_PAT_range143w(0) XOR nl10O;
	wire_w_lg_w_SYNC_COMP_PAT_range143w433w(0) <= wire_w_SYNC_COMP_PAT_range143w(0) XOR nl1ii;
	wire_w_lg_w_SYNC_COMP_PAT_range143w395w(0) <= wire_w_SYNC_COMP_PAT_range143w(0) XOR nl1il;
	wire_w_lg_w_SYNC_COMP_PAT_range143w357w(0) <= wire_w_SYNC_COMP_PAT_range143w(0) XOR nl1iO;
	wire_w_lg_w_SYNC_COMP_PAT_range143w319w(0) <= wire_w_SYNC_COMP_PAT_range143w(0) XOR nl1li;
	wire_w_lg_w_SYNC_COMP_PAT_range143w271w(0) <= wire_w_SYNC_COMP_PAT_range143w(0) XOR nl1ll;
	wire_w_lg_w_SYNC_COMP_PAT_range143w178w(0) <= wire_w_SYNC_COMP_PAT_range143w(0) XOR nl1lO;
	wire_w_lg_w_SYNC_COMP_PAT_range140w587w(0) <= wire_w_SYNC_COMP_PAT_range140w(0) XOR wire_n0lOl_dataout;
	wire_w_lg_w_SYNC_COMP_PAT_range140w549w(0) <= wire_w_SYNC_COMP_PAT_range140w(0) XOR wire_n0OOi_dataout;
	wire_w_lg_w_SYNC_COMP_PAT_range140w511w(0) <= wire_w_SYNC_COMP_PAT_range140w(0) XOR nl10O;
	wire_w_lg_w_SYNC_COMP_PAT_range140w473w(0) <= wire_w_SYNC_COMP_PAT_range140w(0) XOR nl1ii;
	wire_w_lg_w_SYNC_COMP_PAT_range140w435w(0) <= wire_w_SYNC_COMP_PAT_range140w(0) XOR nl1il;
	wire_w_lg_w_SYNC_COMP_PAT_range140w397w(0) <= wire_w_SYNC_COMP_PAT_range140w(0) XOR nl1iO;
	wire_w_lg_w_SYNC_COMP_PAT_range140w359w(0) <= wire_w_SYNC_COMP_PAT_range140w(0) XOR nl1li;
	wire_w_lg_w_SYNC_COMP_PAT_range140w321w(0) <= wire_w_SYNC_COMP_PAT_range140w(0) XOR nl1ll;
	wire_w_lg_w_SYNC_COMP_PAT_range140w273w(0) <= wire_w_SYNC_COMP_PAT_range140w(0) XOR nl1lO;
	wire_w_lg_w_SYNC_COMP_PAT_range140w185w(0) <= wire_w_SYNC_COMP_PAT_range140w(0) XOR nl1Oi;
	cg_comma <= nl1O0O;
	n1000i <= (nl0i0i XOR nl0i1l);
	n1000l <= (nli1ll AND (nl0i0i AND (nl0i1O AND nl0i1l)));
	n1000O <= ((((wire_nli1ll_w_lg_Q1335w(0) AND (nl0i0i AND n101ll)) OR wire_nli1ll_w_lg_Q2198w(0)) OR wire_nli1ll_w_lg_Q2201w(0)) OR wire_nli1ll_w_lg_Q2204w(0));
	n1001i <= ((n101iO AND n101il) OR (n101iO AND n101li));
	n1001l <= (n1l1OO AND n101il);
	n1001O <= (wire_w_lg_n101iO2243w(0) OR (n1l1OO AND wire_n0liil_dataout));
	n100ii <= (ni0OOO OR ni0lOO);
	n100il <= (ni0lOi OR ni0lll);
	n100iO <= (ni0lOl OR ni0llO);
	n100li <= (ni0lli OR ni1O0i);
	n100ll <= ((((ni0OOO OR ni0lOi) OR ni0lll) OR ni0lli) OR ni1O0i);
	n100lO <= ((((ni0lOO OR ni0lOl) OR ni0llO) OR ni0lli) OR ni1O0i);
	n100Oi <= (wire_niil1i_w_lg_Q1900w(0) AND wire_niiiOO_w_lg_Q1894w(0));
	n100Ol <= (wire_niil1i_w_lg_Q1900w(0) AND niiiOO);
	n100OO <= (ni0liO AND ni1OlO);
	n1010i <= wire_nl00lO_w_lg_Q2262w(0);
	n1010l <= wire_nl00lO_w_lg_w_lg_Q2224w2261w(0);
	n1010O <= (n1l1lO AND n101iO);
	n1011i <= (wire_nl1ili_w_lg_Q2434w(0) AND wire_nl1i0i_w_lg_Q2435w(0));
	n1011l <= (nl00lO AND nl00ll);
	n1011O <= wire_nl00lO_w_lg_w_lg_Q2224w2226w(0);
	n101ii <= (wire_nl00Ol_w_lg_Q1266w(0) AND (wire_nl00Oi_w_lg_Q2233w(0) AND wire_nl00lO_w_lg_w_lg_Q2224w2226w(0)));
	n101il <= (nl00Ol AND (nl00Oi AND (nl00lO AND nl00ll)));
	n101iO <= (nl0i1i AND nl00OO);
	n101li <= ((((wire_nl00Ol_w_lg_Q1266w(0) AND (nl00Oi AND n1011l)) OR wire_nl00Ol_w_lg_Q2290w(0)) OR wire_nl00Ol_w_lg_Q2293w(0)) OR wire_nl00Ol_w_lg_Q2296w(0));
	n101ll <= (nl0i1O AND nl0i1l);
	n101lO <= wire_nl0i1O_w_lg_w_lg_Q1337w2176w(0);
	n101Oi <= wire_nl0i1O_w_lg_Q2160w(0);
	n101Ol <= wire_nl0i1O_w_lg_w_lg_Q1337w2159w(0);
	n101OO <= (n1l1Oi AND n101il);
	n10i0i <= (wire_ni0Oil_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_dataout1753w1754w1755w1756w1758w1759w(0) OR wire_ni0O1i_w_lg_dataout1761w(0));
	n10i0l <= (wire_ni0Oil_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_dataout1753w1754w1755w1756w1758w1759w(0) OR wire_ni0O1i_dataout);
	n10i0O <= ((((((wire_w_lg_w_lg_PMADATAWIDTH115w1766w(0) OR wire_nilOi_w_lg_Q1799w(0)) OR wire_nillO_w_lg_Q1801w(0)) OR wire_nilll_w_lg_Q1803w(0)) OR wire_nilli_w_lg_Q1805w(0)) OR wire_niliO_w_lg_Q1810w(0)) OR wire_niiili_w_lg_dataout1771w(0));
	n10i1i <= (wire_niiiOO_w_lg_Q1894w(0) AND wire_niiOOO_w_lg_Q1895w(0));
	n10i1l <= (niiiOO AND wire_niiOOO_w_lg_Q1895w(0));
	n10i1O <= ((((RUNDISP_SEL(4) OR RUNDISP_SEL(3)) OR RUNDISP_SEL(2)) OR RUNDISP_SEL(1)) OR RUNDISP_SEL(0));
	n10iii <= ((((((wire_w_lg_w_lg_PMADATAWIDTH115w1766w(0) OR wire_nilOi_w_lg_Q1799w(0)) OR wire_nillO_w_lg_Q1801w(0)) OR wire_nilll_w_lg_Q1803w(0)) OR wire_nilli_w_lg_Q1805w(0)) OR wire_niiili_w_lg_dataout1771w(0)) OR wire_nilOl_w_lg_Q1808w(0));
	n10iil <= ((((((wire_w_lg_w_lg_PMADATAWIDTH115w1766w(0) OR wire_nillO_w_lg_Q1801w(0)) OR wire_nilll_w_lg_Q1803w(0)) OR wire_nilli_w_lg_Q1805w(0)) OR wire_niliO_w_lg_Q1810w(0)) OR wire_nilil_w_lg_Q1661w(0)) OR wire_niiili_w_lg_dataout1771w(0));
	n10iiO <= (((((((wire_w_lg_PMADATAWIDTH1782w(0) OR wire_nilOi_w_lg_Q1799w(0)) OR wire_nillO_w_lg_Q1801w(0)) OR wire_nilll_w_lg_Q1803w(0)) OR wire_niiili_w_lg_dataout1771w(0)) OR wire_nilOl_w_lg_Q1808w(0)) OR wire_nilOO_w_lg_Q1529w(0)) OR wire_niO1i_w_lg_Q1825w(0));
	n10ili <= (((((((wire_w_lg_PMADATAWIDTH1782w(0) OR wire_nilOi_w_lg_Q1799w(0)) OR wire_nillO_w_lg_Q1801w(0)) OR wire_nilll_w_lg_Q1803w(0)) OR wire_nilli_w_lg_Q1805w(0)) OR wire_niiili_w_lg_dataout1771w(0)) OR wire_nilOl_w_lg_Q1808w(0)) OR wire_nilOO_w_lg_Q1529w(0));
	n10ill <= (((((((wire_w_lg_PMADATAWIDTH1782w(0) OR wire_nilOi_w_lg_Q1799w(0)) OR wire_nillO_w_lg_Q1801w(0)) OR wire_nilll_w_lg_Q1803w(0)) OR wire_nilli_w_lg_Q1805w(0)) OR wire_niliO_w_lg_Q1810w(0)) OR wire_niiili_w_lg_dataout1771w(0)) OR wire_nilOl_w_lg_Q1808w(0));
	n10ilO <= (((((((wire_w_lg_PMADATAWIDTH1782w(0) OR wire_nilOi_w_lg_Q1799w(0)) OR wire_nillO_w_lg_Q1801w(0)) OR wire_nilll_w_lg_Q1803w(0)) OR wire_nilli_w_lg_Q1805w(0)) OR wire_niliO_w_lg_Q1810w(0)) OR wire_nilil_w_lg_Q1661w(0)) OR wire_niiili_w_lg_dataout1771w(0));
	n10iOi <= (wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH115w1766w1767w1768w1769w1770w1774w(0) OR wire_niiili_w_lg_dataout1771w(0));
	n10iOl <= ((wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH115w1766w1767w1768w1769w1770w(0) OR wire_niiili_w_lg_dataout1771w(0)) OR nilOl);
	n10iOO <= (wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH115w1766w1776w1777w1778w1779w1780w(0) OR wire_niiili_w_lg_dataout1771w(0));
	n10l0i <= (wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH1782w1783w1784w1785w1790w1794w1797w(0) OR wire_niiili_w_lg_dataout1771w(0));
	n10l0l <= ((((wire_w_lg_n10lOl1679w(0) OR wire_w_lg_n10lOi1671w(0)) OR wire_w_lg_n10lll1681w(0)) OR wire_w_lg_n10liO1675w(0)) OR wire_w_lg_n10lii1684w(0));
	n10l0O <= (((wire_w_lg_n1i0il1672w(0) OR wire_w_lg_n10llO1673w(0)) OR wire_w_lg_n10liO1675w(0)) OR wire_w_lg_n10lil1677w(0));
	n10l1i <= ((((wire_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH1782w1783w1784w1785w(0) OR wire_niiili_w_lg_dataout1771w(0)) OR nilOl) OR nilOO) OR niO1i);
	n10l1l <= (((wire_w_lg_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH1782w1783w1784w1785w1790w(0) OR wire_niiili_w_lg_dataout1771w(0)) OR nilOl) OR nilOO);
	n10l1O <= ((wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_PMADATAWIDTH1782w1783w1784w1785w1790w1794w(0) OR wire_niiili_w_lg_dataout1771w(0)) OR nilOl);
	n10lii <= (((((((((wire_nilil_w_lg_Q1661w(0) OR n1i0il) OR n1i0Oi) OR n1i1OO) OR n1i01l) OR n1i01O) OR n1i00i) OR n1i00l) OR n1i00O) OR n1i0ii);
	n10lil <= (wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_n1i0il1642w1643w1646w1649w1652w1655w1658w(0) OR wire_w_lg_n1i0ii1659w(0));
	n10liO <= (wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_n1i0il1642w1643w1646w1649w1652w1655w(0) OR wire_w_lg_n1i00O1656w(0));
	n10lli <= (wire_w_lg_w_lg_w_lg_w_lg_w_lg_n1i0il1642w1643w1646w1649w1652w(0) OR wire_w_lg_n1i00l1653w(0));
	n10lll <= (wire_w_lg_w_lg_w_lg_w_lg_n1i0il1642w1643w1646w1649w(0) OR wire_w_lg_n1i00i1650w(0));
	n10llO <= (wire_w_lg_w_lg_w_lg_n1i0il1642w1643w1646w(0) OR wire_w_lg_n1i01O1647w(0));
	n10lOi <= (wire_w_lg_w_lg_n1i0il1642w1643w(0) OR wire_w_lg_n1i01l1644w(0));
	n10lOl <= (n1i0il OR wire_w_lg_n1i1OO1640w(0));
	n10lOO <= ((((wire_w_lg_n10OiO1633w(0) OR wire_w_lg_n10Oil1625w(0)) OR wire_w_lg_n10O0O1635w(0)) OR wire_w_lg_n10O0i1629w(0)) OR wire_w_lg_n10O1l1638w(0));
	n10O0i <= (wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_n1i0il1596w1597w1600w1603w1606w1609w(0) OR wire_w_lg_n1iili1610w(0));
	n10O0l <= (wire_w_lg_w_lg_w_lg_w_lg_w_lg_n1i0il1596w1597w1600w1603w1606w(0) OR wire_w_lg_n1iiiO1607w(0));
	n10O0O <= (wire_w_lg_w_lg_w_lg_w_lg_n1i0il1596w1597w1600w1603w(0) OR wire_w_lg_n1ii0O1604w(0));
	n10O1i <= (((wire_w_lg_n1i0il1626w(0) OR wire_w_lg_n10Oii1627w(0)) OR wire_w_lg_n10O0i1629w(0)) OR wire_w_lg_n10O1O1631w(0));
	n10O1l <= (((((((((n1i0il OR wire_w_lg_n1iilO1615w(0)) OR n1i0li) OR n1i0lO) OR n1i0OO) OR n1ii1O) OR n1ii0O) OR n1iiiO) OR n1iili) OR n1iill);
	n10O1O <= (wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_n1i0il1596w1597w1600w1603w1606w1609w1612w(0) OR wire_w_lg_n1iill1613w(0));
	n10Oii <= (wire_w_lg_w_lg_w_lg_n1i0il1596w1597w1600w(0) OR wire_w_lg_n1ii1O1601w(0));
	n10Oil <= (wire_w_lg_w_lg_n1i0il1596w1597w(0) OR wire_w_lg_n1i0OO1598w(0));
	n10OiO <= (n1i0il OR wire_w_lg_n1i0li1594w(0));
	n10Oli <= ((((wire_w_lg_n1i10i1587w(0) OR wire_w_lg_n1i11O1579w(0)) OR wire_w_lg_n1i11i1589w(0)) OR wire_w_lg_n10OOl1583w(0)) OR wire_w_lg_n10OlO1592w(0));
	n10Oll <= (((wire_w_lg_n1il0O1580w(0) OR wire_w_lg_n1i11l1581w(0)) OR wire_w_lg_n10OOl1583w(0)) OR wire_w_lg_n10OOi1585w(0));
	n10OlO <= ((((((wire_nilil_w_lg_w_lg_w_lg_Q1569w1570w1571w(0) OR wire_w_lg_n1iiOO1554w(0)) OR wire_w_lg_n1il1i1557w(0)) OR wire_w_lg_n1il1l1560w(0)) OR wire_w_lg_n1il1O1563w(0)) OR wire_w_lg_n1il0i1566w(0)) OR wire_w_lg_n1il0l1577w(0));
	n10OOi <= ((((((wire_w_lg_w_lg_n1il0O1551w1552w(0) OR wire_w_lg_n1iiOO1554w(0)) OR wire_w_lg_n1il1i1557w(0)) OR wire_w_lg_n1il1l1560w(0)) OR wire_w_lg_n1il1O1563w(0)) OR wire_w_lg_n1il0i1566w(0)) OR n1il0l);
	n10OOl <= (((((wire_w_lg_w_lg_n1il0O1551w1552w(0) OR wire_w_lg_n1iiOO1554w(0)) OR wire_w_lg_n1il1i1557w(0)) OR wire_w_lg_n1il1l1560w(0)) OR wire_w_lg_n1il1O1563w(0)) OR n1il0i);
	n10OOO <= ((((wire_w_lg_w_lg_n1il0O1551w1552w(0) OR wire_w_lg_n1iiOO1554w(0)) OR wire_w_lg_n1il1i1557w(0)) OR wire_w_lg_n1il1l1560w(0)) OR n1il1O);
	n11l0l <= ((((((n001iO OR n001il) OR n001li) OR n0010l) OR n1Ol0l) OR n001ii) OR n0010O);
	n11l0O <= ((((n001iO OR n001il) OR n0010l) OR n1Ol0l) OR n0010O);
	n11lii <= ((((((((((n0001i OR n001OO) OR n001Ol) OR n001iO) OR n001il) OR n001Oi) OR n001lO) OR n001ll) OR n001li) OR n001ii) OR n0010O);
	n11lil <= (((((((((n0001i OR n001OO) OR n001Ol) OR n001iO) OR n001Oi) OR n001lO) OR n001ll) OR n001li) OR n1Ol0l) OR n001ii);
	n11liO <= (((((((((n0001i OR n001OO) OR n001Ol) OR n001il) OR n001Oi) OR n001lO) OR n001ll) OR n001li) OR n0010l) OR n1Ol0l);
	n11lli <= ((((((((((n0001i OR n001OO) OR n001Ol) OR n001iO) OR n001Oi) OR n001lO) OR n001ll) OR n001li) OR n1Ol0l) OR n001ii) OR n0010O);
	n11lll <= ((((((((((n0001i OR n001OO) OR n001Ol) OR n001il) OR n001Oi) OR n001lO) OR n001ll) OR n001li) OR n0010l) OR n1Ol0l) OR n001ii);
	n11llO <= (((((((((n0001i OR n001OO) OR n001Ol) OR n001iO) OR n001il) OR n001Oi) OR n001ll) OR n0010l) OR n1Ol0l) OR n0010O);
	n11lOi <= ((((((((((n0001i OR n001OO) OR n001iO) OR n001il) OR n001Oi) OR n001lO) OR n001ll) OR n0010l) OR n1Ol0l) OR n001ii) OR n0010O);
	n11lOl <= ((((((((((n0001i OR n001OO) OR n001Ol) OR n001iO) OR n001il) OR n001Oi) OR n001li) OR n0010l) OR n1Ol0l) OR n001ii) OR n0010O);
	n11lOO <= (((((((((n001OO OR n001Ol) OR n001iO) OR n001il) OR n001Oi) OR n001li) OR n0010l) OR n1Ol0l) OR n001ii) OR n0010O);
	n11O0i <= (n0001O AND n11OOO);
	n11O0l <= (n11Oil OR n11Oii);
	n11O0O <= (wire_n0001O_w_lg_Q2461w(0) OR n11OiO);
	n11O1i <= ((((((((((n0001i OR n001OO) OR n001iO) OR n001il) OR n001lO) OR n001ll) OR n001li) OR n0010l) OR n1Ol0l) OR n001ii) OR n0010O);
	n11O1l <= ((((((((((n001Ol OR n001iO) OR n001il) OR n001Oi) OR n001lO) OR n001ll) OR n001li) OR n0010l) OR n1Ol0l) OR n001ii) OR n0010O);
	n11O1O <= (wire_n0001O_w_lg_Q2495w(0) AND (NOT (wire_n0010i_w_lg_Q2496w(0) OR wire_n1OlOi_w_lg_Q2497w(0))));
	n11Oii <= (n0001O AND (nl1O0O AND wire_w_lg_GE_XAUI_SEL2472w(0)));
	n11Oil <= (GE_XAUI_SEL AND n1011i);
	n11OiO <= (wire_w_lg_GE_XAUI_SEL2471w(0) OR wire_w_lg_w_lg_GE_XAUI_SEL2472w2473w(0));
	n11Oli <= (wire_n0001O_w_lg_Q2461w(0) OR n11OOO);
	n11Oll <= (n0001O AND (nl1O0O AND wire_n1OliO_w_lg_Q2463w(0)));
	n11OlO <= (wire_n0001O_w_lg_Q2461w(0) OR n11OiO);
	n11OOi <= (n0001O AND n11Oil);
	n11OOl <= (wire_nl1O0O_w_lg_Q2460w(0) OR wire_n0001O_w_lg_Q2461w(0));
	n11OOO <= (nl1i0i OR (n1OliO AND (nl1O0O AND GE_XAUI_SEL)));
	n1i00i <= ((((nillO AND nilll) AND nilli) AND niliO) AND nilil);
	n1i00l <= (((nilll AND nilli) AND niliO) AND nilil);
	n1i00O <= ((nilli AND niliO) AND nilil);
	n1i01i <= (((((((wire_nilOi_w_lg_Q1451w(0) AND nilll) AND nilli) AND niliO) AND nilil) AND nilOl) AND nilOO) AND niO1i);
	n1i01l <= (((((wire_nilOi_w_lg_Q1451w(0) AND nilll) AND nilli) AND niliO) AND nilil) AND nilOl);
	n1i01O <= ((((wire_nilOi_w_lg_Q1451w(0) AND nilll) AND nilli) AND niliO) AND nilil);
	n1i0ii <= (niliO AND nilil);
	n1i0il <= (wire_w_lg_PMADATAWIDTH115w(0) AND n1i0iO);
	n1i0iO <= ((((((((wire_nilOi_w_lg_Q1451w(0) AND nilll) AND nilli) AND niliO) AND nilil) AND nilOl) AND nilOO) AND niO1i) AND niO1l);
	n1i0li <= (wire_w_lg_PMADATAWIDTH115w(0) AND n1i0ll);
	n1i0ll <= (((((((wire_nilOi_w_lg_Q1451w(0) AND nilll) AND nilli) AND niliO) AND nilOl) AND nilOO) AND niO1i) AND niO1l);
	n1i0lO <= (wire_w_lg_w_lg_PMADATAWIDTH115w1485w(0) OR (PMADATAWIDTH AND n1i0Oi));
	n1i0Oi <= ((((((wire_nilOi_w_lg_Q1451w(0) AND nilll) AND nilli) AND niliO) AND nilil) AND nilOl) AND nilOO);
	n1i0Ol <= ((((((wire_nilOi_w_lg_Q1451w(0) AND nilll) AND nilli) AND nilOl) AND nilOO) AND niO1i) AND niO1l);
	n1i0OO <= (wire_w_lg_w_lg_PMADATAWIDTH115w1477w(0) OR (PMADATAWIDTH AND n1ii1i));
	n1i10i <= (n1il0O OR wire_w_lg_n1iiOi1549w(0));
	n1i10l <= ((((wire_w_lg_n1i1Ol1542w(0) OR wire_w_lg_n1i1Oi1534w(0)) OR wire_w_lg_n1i1ll1544w(0)) OR wire_w_lg_n1i1iO1538w(0)) OR wire_w_lg_n1i1ii1547w(0));
	n1i10O <= (((wire_w_lg_n1il0O1535w(0) OR wire_w_lg_n1i1lO1536w(0)) OR wire_w_lg_n1i1iO1538w(0)) OR wire_w_lg_n1i1il1540w(0));
	n1i11i <= (((wire_w_lg_w_lg_n1il0O1551w1552w(0) OR wire_w_lg_n1iiOO1554w(0)) OR wire_w_lg_n1il1i1557w(0)) OR n1il1l);
	n1i11l <= ((wire_w_lg_w_lg_n1il0O1551w1552w(0) OR wire_w_lg_n1iiOO1554w(0)) OR n1il1i);
	n1i11O <= (wire_w_lg_w_lg_n1il0O1551w1552w(0) OR n1iiOO);
	n1i1ii <= (wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_n1il0O1507w1508w1511w1514w1517w1520w1523w1526w(0) OR (NOT ((wire_w_lg_PMADATAWIDTH115w(0) AND wire_niO1l_w_lg_Q1527w(0)) OR wire_w_lg_PMADATAWIDTH1530w(0))));
	n1i1il <= (wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_n1il0O1507w1508w1511w1514w1517w1520w1523w(0) OR wire_w_lg_n1iOiO1524w(0));
	n1i1iO <= (wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_n1il0O1507w1508w1511w1514w1517w1520w(0) OR wire_w_lg_n1iOil1521w(0));
	n1i1li <= (wire_w_lg_w_lg_w_lg_w_lg_w_lg_n1il0O1507w1508w1511w1514w1517w(0) OR wire_w_lg_n1iOii1518w(0));
	n1i1ll <= (wire_w_lg_w_lg_w_lg_w_lg_n1il0O1507w1508w1511w1514w(0) OR wire_w_lg_n1iO0i1515w(0));
	n1i1lO <= (wire_w_lg_w_lg_w_lg_n1il0O1507w1508w1511w(0) OR wire_w_lg_n1iO1i1512w(0));
	n1i1Oi <= (wire_w_lg_w_lg_n1il0O1507w1508w(0) OR wire_w_lg_n1ilOi1509w(0));
	n1i1Ol <= (n1il0O OR wire_w_lg_n1ilil1505w(0));
	n1i1OO <= (wire_w_lg_PMADATAWIDTH115w(0) AND n1i01i);
	n1ii0i <= ((((wire_nilOi_w_lg_Q1451w(0) AND nilll) AND nilli) AND nilOl) AND nilOO);
	n1ii0l <= ((wire_nilOi_w_lg_w_lg_w_lg_Q1451w1452w1453w(0) AND niO1i) AND niO1l);
	n1ii0O <= (wire_w_lg_w_lg_PMADATAWIDTH115w1461w(0) OR (PMADATAWIDTH AND n1iiii));
	n1ii1i <= (((((wire_nilOi_w_lg_Q1451w(0) AND nilll) AND nilli) AND niliO) AND nilOl) AND nilOO);
	n1ii1l <= (((((wire_nilOi_w_lg_Q1451w(0) AND nilll) AND nilOl) AND nilOO) AND niO1i) AND niO1l);
	n1ii1O <= (wire_w_lg_w_lg_PMADATAWIDTH115w1469w(0) OR (PMADATAWIDTH AND n1ii0i));
	n1iiii <= (((wire_nilOi_w_lg_Q1451w(0) AND nilll) AND nilOl) AND nilOO);
	n1iiil <= ((wire_nilOi_w_lg_w_lg_Q1444w1445w(0) AND niO1i) AND niO1l);
	n1iiiO <= ((wire_w_lg_PMADATAWIDTH115w(0) AND wire_nilOl_w_lg_w_lg_w_lg_Q1438w1448w1449w(0)) OR wire_w_lg_PMADATAWIDTH1454w(0));
	n1iili <= ((wire_w_lg_PMADATAWIDTH115w(0) AND wire_nilOO_w_lg_w_lg_Q1441w1442w(0)) OR wire_w_lg_PMADATAWIDTH1446w(0));
	n1iill <= ((wire_w_lg_PMADATAWIDTH115w(0) AND (niO1i AND niO1l)) OR wire_w_lg_PMADATAWIDTH1439w(0));
	n1iilO <= (wire_w_lg_w_lg_PMADATAWIDTH115w1433w(0) OR (PMADATAWIDTH AND nilOO));
	n1iiOi <= (wire_w_lg_PMADATAWIDTH115w(0) AND wire_w_lg_n1iiOl1431w(0));
	n1iiOl <= (((((((wire_nilOi_w_lg_Q1367w(0) OR nilll) OR nilli) OR niliO) OR nilil) OR nilOl) OR nilOO) OR niO1i);
	n1iiOO <= (((((wire_nilOi_w_lg_Q1367w(0) OR nilll) OR nilli) OR niliO) OR nilil) OR nilOl);
	n1il0i <= ((nilli OR niliO) OR nilil);
	n1il0l <= (niliO OR nilil);
	n1il0O <= (wire_w_lg_PMADATAWIDTH115w(0) AND wire_w_lg_n1ilii1419w(0));
	n1il1i <= ((((wire_nilOi_w_lg_Q1367w(0) OR nilll) OR nilli) OR niliO) OR nilil);
	n1il1l <= ((((nillO OR nilll) OR nilli) OR niliO) OR nilil);
	n1il1O <= (((nilll OR nilli) OR niliO) OR nilil);
	n1ilii <= ((((((((wire_nilOi_w_lg_Q1367w(0) OR nilll) OR nilli) OR niliO) OR nilil) OR nilOl) OR nilOO) OR niO1i) OR niO1l);
	n1ilil <= (wire_w_lg_PMADATAWIDTH115w(0) AND wire_w_lg_n1iliO1415w(0));
	n1iliO <= (((((((wire_nilOi_w_lg_Q1367w(0) OR nilll) OR nilli) OR niliO) OR nilOl) OR nilOO) OR niO1i) OR niO1l);
	n1illi <= ((wire_w_lg_PMADATAWIDTH115w(0) AND wire_w_lg_n1illO1408w(0)) OR wire_w_lg_PMADATAWIDTH1411w(0));
	n1illl <= ((((((wire_nilOi_w_lg_Q1367w(0) OR nilll) OR nilli) OR niliO) OR nilil) OR nilOl) OR nilOO);
	n1illO <= ((((((wire_nilOi_w_lg_Q1367w(0) OR nilll) OR nilli) OR nilOl) OR nilOO) OR niO1i) OR niO1l);
	n1ilOi <= ((wire_w_lg_PMADATAWIDTH115w(0) AND wire_w_lg_n1ilOO1398w(0)) OR wire_w_lg_PMADATAWIDTH1401w(0));
	n1ilOl <= (((((wire_nilOi_w_lg_Q1367w(0) OR nilll) OR nilli) OR niliO) OR nilOl) OR nilOO);
	n1ilOO <= (((((wire_nilOi_w_lg_Q1367w(0) OR nilll) OR nilOl) OR nilOO) OR niO1i) OR niO1l);
	n1iO0i <= ((wire_w_lg_PMADATAWIDTH115w(0) AND wire_w_lg_n1iO0O1378w(0)) OR wire_w_lg_PMADATAWIDTH1381w(0));
	n1iO0l <= (((wire_nilOi_w_lg_Q1367w(0) OR nilll) OR nilOl) OR nilOO);
	n1iO0O <= ((wire_nilOi_w_lg_w_lg_Q1358w1359w(0) OR niO1i) OR niO1l);
	n1iO1i <= ((wire_w_lg_PMADATAWIDTH115w(0) AND wire_w_lg_n1iO1O1388w(0)) OR wire_w_lg_PMADATAWIDTH1391w(0));
	n1iO1l <= ((((wire_nilOi_w_lg_Q1367w(0) OR nilll) OR nilli) OR nilOl) OR nilOO);
	n1iO1O <= ((wire_nilOi_w_lg_w_lg_w_lg_Q1367w1368w1369w(0) OR niO1i) OR niO1l);
	n1iOii <= ((wire_w_lg_PMADATAWIDTH115w(0) AND (NOT ((wire_nilOl_w_lg_Q1350w(0) OR niO1i) OR niO1l))) OR wire_w_lg_PMADATAWIDTH1371w(0));
	n1iOil <= ((wire_w_lg_PMADATAWIDTH115w(0) AND (NOT ((nilOO OR niO1i) OR niO1l))) OR wire_w_lg_PMADATAWIDTH1361w(0));
	n1iOiO <= ((wire_w_lg_PMADATAWIDTH115w(0) AND (NOT (niO1i OR niO1l))) OR wire_w_lg_PMADATAWIDTH1352w(0));
	n1iOli <= (nl0i1i AND (wire_nl00OO_w_lg_Q2232w(0) AND n1l1lO));
	n1iOll <= (wire_nl0i1i_w_lg_Q2231w(0) AND (nl00OO AND n101li));
	n1iOlO <= (wire_nl0i1i_w_lg_Q2231w(0) AND (wire_nl00OO_w_lg_Q2232w(0) AND (wire_nl00Ol_w_lg_Q1266w(0) AND (wire_nl00Oi_w_lg_Q2233w(0) AND (nl00lO AND nl00ll)))));
	n1iOOi <= (nl0i1i AND (nl00OO AND wire_nl00Ol_w_lg_Q2228w(0)));
	n1iOOl <= (((((((((wire_nl00ll_w_lg_Q1315w(0) OR wire_nl00lO_w_lg_Q1316w(0)) OR wire_nl00Oi_w_lg_Q1318w(0)) OR wire_nl00Ol_w_lg_Q1320w(0)) OR wire_nl00OO_w_lg_Q1322w(0)) OR wire_nl0i1i_w_lg_Q1324w(0)) OR wire_nl0i1l_w_lg_Q1326w(0)) OR wire_nl0i1O_w_lg_Q1328w(0)) OR wire_nl0i0i_w_lg_Q1330w(0)) OR wire_nli1ll_w_lg_Q1332w(0));
	n1iOOO <= (((((((((wire_nl00ll_w_lg_Q1296w(0) OR wire_nl00lO_w_lg_Q1297w(0)) OR wire_nl00Oi_w_lg_Q1299w(0)) OR wire_nl00Ol_w_lg_Q1301w(0)) OR wire_nl00OO_w_lg_Q1303w(0)) OR wire_nl0i1i_w_lg_Q1305w(0)) OR wire_nl0i1l_w_lg_Q1307w(0)) OR wire_nl0i1O_w_lg_Q1309w(0)) OR wire_nl0i0i_w_lg_Q1311w(0)) OR wire_nli1ll_w_lg_Q1313w(0));
	n1l00i <= (PMADATAWIDTH AND wire_w_lg_n1l00O1254w(0));
	n1l00l <= (nll10i AND (PMADATAWIDTH AND nll10l));
	n1l00O <= (nll10l AND nll10i);
	n1l01i <= (n1l1OO AND n1l1lO);
	n1l01l <= (n101ii AND n1l1Oi);
	n1l01O <= (n101ii AND n1l1OO);
	n1l0ii <= (wire_nli1li_o(1) OR wire_nli1li_o(0));
	n1l0il <= (wire_nliill_o(1) OR wire_nliill_o(19));
	n1l0iO <= (wire_nliill_o(2) OR wire_nliill_o(20));
	n1l0li <= (wire_nliill_o(3) OR wire_nliill_o(21));
	n1l0ll <= (wire_nliill_o(4) OR wire_nliill_o(22));
	n1l0lO <= (wire_nliill_o(5) OR wire_nliill_o(23));
	n1l0Oi <= (wire_nliill_o(6) OR wire_nliill_o(24));
	n1l0Ol <= (wire_nliill_o(7) OR wire_nliill_o(25));
	n1l0OO <= (((((((((((((wire_nliill_o(31) OR wire_nliill_o(30)) OR wire_nliill_o(29)) OR wire_nliill_o(28)) OR wire_nliill_o(27)) OR wire_nliill_o(26)) OR wire_nliill_o(15)) OR wire_nliill_o(14)) OR wire_nliill_o(13)) OR wire_nliill_o(12)) OR wire_nliill_o(11)) OR wire_nliill_o(10)) OR wire_nliill_o(0)) OR wire_nliill_o(18));
	n1l10i <= (n1000O OR n1000l);
	n1l10l <= (wire_nl0i1O_w_lg_Q1337w(0) AND wire_nl0i1l_w_lg_w_lg_Q2106w2107w(0));
	n1l10O <= (wire_nli1ll_w_lg_Q1335w(0) AND (wire_nl0i0i_w_lg_Q1336w(0) AND wire_nl0i1O_w_lg_w_lg_Q1337w2176w(0)));
	n1l11i <= (((NOT (((n1l10O OR n1000l) OR (((wire_nl0i1l_w_lg_w_lg_Q2106w2111w(0) OR (nl0i1l AND n1l1ii)) AND wire_w_lg_n1001O2114w(0)) AND (NOT (n1iOll OR (n1iOli OR (n1iOOi OR n1iOlO)))))) OR ((wire_nli1ll_w_lg_w_lg_Q1335w2121w(0) OR (nli1ll AND n1l1ii)) AND wire_w_lg_n1iOlO2125w(0)))) AND (NOT (wire_w_lg_n1001l2130w(0) OR wire_w_lg_n1l1ll2133w(0)))) AND (NOT ((IB_INVALID_CODE(0) AND (wire_nl0i1O_w_lg_w_lg_w_lg_Q1337w2138w2139w(0) OR wire_w_lg_n1000i2141w(0))) OR (IB_INVALID_CODE(1) AND (wire_nl0i0i_w_lg_Q2147w(0) OR (wire_nl0i0i_w_lg_Q1336w(0) AND (wire_nl0i1O_w_lg_Q1337w(0) AND (n1l11O AND n1iOlO))))))));
	n1l11l <= (((((wire_nl1ill_w_lg_Q1256w(0) AND wire_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_n1l01O1257w1258w1260w1262w1263w1264w(0)) OR wire_nl1ill_w_lg_Q1269w(0)) OR (wire_n0liil_w_lg_dataout1271w(0) AND wire_w_lg_w_lg_n1l1ii1272w1273w(0))) OR wire_n0liil_w_lg_dataout1279w(0)) AND wire_w_lg_DISABLE_RX_DISP1281w(0));
	n1l11O <= ((((((wire_nli1ll_w_lg_Q1335w(0) AND (wire_nl0i0i_w_lg_Q1336w(0) AND (nl0i1O AND nl0i1l))) OR (wire_nli1ll_w_lg_Q1335w(0) AND (nl0i0i AND n101Ol))) OR (wire_nli1ll_w_lg_Q1335w(0) AND (nl0i0i AND n101Oi))) OR wire_nli1ll_w_lg_Q2171w(0)) OR wire_nli1ll_w_lg_Q2174w(0)) OR wire_nli1ll_w_lg_Q2178w(0));
	n1l1ii <= ((((wire_nli1ll_w_lg_Q1335w(0) AND (wire_nl0i0i_w_lg_Q1336w(0) AND wire_nl0i1O_w_lg_w_lg_Q1337w2159w(0))) OR (wire_nli1ll_w_lg_Q1335w(0) AND (wire_nl0i0i_w_lg_Q1336w(0) AND wire_nl0i1O_w_lg_Q2160w(0)))) OR (wire_nli1ll_w_lg_Q1335w(0) AND (nl0i0i AND n101lO))) OR wire_nli1ll_w_lg_Q2193w(0));
	n1l1il <= (n1l1OO AND n101li);
	n1l1iO <= (((wire_w_lg_n1001i2213w(0) OR (n1l1Oi AND n101li)) OR n101OO) OR n1001l);
	n1l1li <= (nl00Ol AND n1010O);
	n1l1ll <= (n101ii AND n101iO);
	n1l1lO <= ((((wire_nl00Ol_w_lg_Q1266w(0) AND (wire_nl00Oi_w_lg_Q2233w(0) AND wire_nl00lO_w_lg_w_lg_Q2224w2261w(0))) OR (wire_nl00Ol_w_lg_Q1266w(0) AND (wire_nl00Oi_w_lg_Q2233w(0) AND wire_nl00lO_w_lg_Q2262w(0)))) OR (wire_nl00Ol_w_lg_Q1266w(0) AND (nl00Oi AND n1011O))) OR wire_nl00Ol_w_lg_Q2285w(0));
	n1l1Oi <= (wire_nl0i1i_w_lg_w_lg_Q2231w2252w(0) OR wire_nl0i1i_w_lg_Q2253w(0));
	n1l1Ol <= ((((((wire_nl00Ol_w_lg_Q1266w(0) AND (wire_nl00Oi_w_lg_Q2233w(0) AND (nl00lO AND nl00ll))) OR (wire_nl00Ol_w_lg_Q1266w(0) AND (nl00Oi AND n1010l))) OR (wire_nl00Ol_w_lg_Q1266w(0) AND (nl00Oi AND n1010i))) OR wire_nl00Ol_w_lg_Q2270w(0)) OR wire_nl00Ol_w_lg_Q2273w(0)) OR wire_nl00Ol_w_lg_Q2228w(0));
	n1l1OO <= (wire_nl0i1i_w_lg_Q2231w(0) AND wire_nl00OO_w_lg_Q2232w(0));
	n1li0i <= (wire_w_lg_PMADATAWIDTH115w(0) AND wire_w_lg_n1li0l786w(0));
	n1li0l <= (((nliO1O OR nlil0l) OR nlil0i) OR nlil1O);
	n1li0O <= ((((((((wire_nll0OO_w_lg_dataout736w(0) OR wire_w_lg_n1liOl737w(0)) OR wire_w_lg_n1liOi739w(0)) OR wire_w_lg_n1lilO741w(0)) OR wire_w_lg_n1lill743w(0)) OR wire_w_lg_n1lili745w(0)) OR wire_w_lg_n1liiO747w(0)) OR wire_w_lg_n1liil749w(0)) OR wire_w_lg_n1liii751w(0));
	n1li1i <= (((((((((wire_nliill_o(25) OR wire_nliill_o(24)) OR wire_nliill_o(23)) OR wire_nliill_o(22)) OR wire_nliill_o(21)) OR wire_nliill_o(20)) OR wire_nliill_o(19)) OR wire_nliill_o(18)) OR wire_nliill_o(17)) OR wire_nliill_o(16));
	n1li1l <= ((((((((((((wire_nliill_o(31) OR wire_nliill_o(30)) OR wire_nliill_o(29)) OR wire_nliill_o(28)) OR wire_nliill_o(27)) OR wire_nliill_o(26)) OR wire_nliill_o(15)) OR wire_nliill_o(14)) OR wire_nliill_o(13)) OR wire_nliill_o(12)) OR wire_nliill_o(11)) OR wire_nliill_o(10)) OR wire_nliill_o(0));
	n1li1O <= (PMADATAWIDTH AND wire_w_lg_n1li0l786w(0));
	n1liii <= (wire_nll0OO_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_dataout711w714w717w720w723w726w729w732w(0) OR wire_nlllli_w_lg_dataout733w(0));
	n1liil <= (wire_nll0OO_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_dataout711w714w717w720w723w726w729w(0) OR wire_nlllii_w_lg_dataout730w(0));
	n1liiO <= (wire_nll0OO_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_dataout711w714w717w720w723w726w(0) OR wire_nlll0i_w_lg_dataout727w(0));
	n1lili <= (wire_nll0OO_w_lg_w_lg_w_lg_w_lg_w_lg_dataout711w714w717w720w723w(0) OR wire_nlll1i_w_lg_dataout724w(0));
	n1lill <= (wire_nll0OO_w_lg_w_lg_w_lg_w_lg_dataout711w714w717w720w(0) OR wire_nlliOi_w_lg_dataout721w(0));
	n1lilO <= (wire_nll0OO_w_lg_w_lg_w_lg_dataout711w714w717w(0) OR wire_nllili_w_lg_dataout718w(0));
	n1liOi <= (wire_nll0OO_w_lg_w_lg_dataout711w714w(0) OR wire_nlliii_w_lg_dataout715w(0));
	n1liOl <= (wire_nll0OO_w_lg_dataout711w(0) OR wire_nlli0i_w_lg_dataout712w(0));
	n1liOO <= (wire_nll0OO_dataout OR wire_nlli1l_w_lg_dataout709w(0));
	n1ll0i <= (((((((((wire_w_lg_w_SYNC_COMP_PAT_range157w538w(0) OR wire_w_lg_w_SYNC_COMP_PAT_range155w539w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range152w541w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range149w543w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range146w545w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range143w547w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range140w549w(0)) OR (wire_n0O1i_dataout XOR wire_nil1l_dataout)) OR (wire_n0O1l_dataout XOR wire_nil1O_dataout)) OR (wire_nil0i_dataout XOR wire_n0OOl_dataout));
	n1ll0l <= ((((((((((wire_ni0li_dataout XOR niOOO) OR (wire_ni0ll_dataout XOR nl11i)) OR (wire_ni0lO_dataout XOR nl11l)) OR (wire_ni0Oi_dataout XOR nl11O)) OR (wire_ni0Ol_dataout XOR nl10i)) OR (wire_ni0OO_dataout XOR nl10l)) OR (wire_nii1i_dataout XOR nl10O)) OR (wire_nii1l_dataout XOR wire_ni11i_dataout)) OR (wire_nii1O_dataout XOR wire_n0OOl_dataout)) OR (wire_nii0i_dataout XOR wire_ni11l_dataout));
	n1ll0O <= (((((((((wire_w_lg_w_SYNC_COMP_PAT_range157w500w(0) OR wire_w_lg_w_SYNC_COMP_PAT_range155w501w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range152w503w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range149w505w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range146w507w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range143w509w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range140w511w(0)) OR (wire_nil1l_dataout XOR wire_ni11i_dataout)) OR (wire_nil1O_dataout XOR wire_n0OOl_dataout)) OR (wire_nil0i_dataout XOR wire_ni11l_dataout));
	n1ll1i <= ((((((((((wire_n0lil_dataout XOR wire_ni0li_dataout) OR (wire_n0liO_dataout XOR wire_ni0ll_dataout)) OR (wire_n0lli_dataout XOR wire_ni0lO_dataout)) OR (wire_n0lll_dataout XOR wire_ni0Oi_dataout)) OR (wire_n0llO_dataout XOR wire_ni0Ol_dataout)) OR (wire_n0lOi_dataout XOR wire_ni0OO_dataout)) OR (wire_n0lOl_dataout XOR wire_nii1i_dataout)) OR (wire_n0lOO_dataout XOR wire_nii1l_dataout)) OR (wire_n0O1i_dataout XOR wire_nii1O_dataout)) OR (wire_n0O1l_dataout XOR wire_nii0i_dataout));
	n1ll1l <= (((((((((wire_w_lg_w_SYNC_COMP_PAT_range157w576w(0) OR wire_w_lg_w_SYNC_COMP_PAT_range155w577w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range152w579w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range149w581w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range146w583w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range143w585w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range140w587w(0)) OR (wire_n0lOO_dataout XOR wire_nil1l_dataout)) OR (wire_n0O1i_dataout XOR wire_nil1O_dataout)) OR (wire_n0O1l_dataout XOR wire_nil0i_dataout));
	n1ll1O <= ((((((((((wire_ni0li_dataout XOR wire_n0liO_dataout) OR (wire_ni0ll_dataout XOR wire_n0lli_dataout)) OR (wire_ni0lO_dataout XOR wire_n0lll_dataout)) OR (wire_ni0Oi_dataout XOR wire_n0llO_dataout)) OR (wire_ni0Ol_dataout XOR wire_n0lOi_dataout)) OR (wire_ni0OO_dataout XOR wire_n0lOl_dataout)) OR (wire_nii1i_dataout XOR wire_n0OOi_dataout)) OR (wire_nii1l_dataout XOR wire_n0O1i_dataout)) OR (wire_nii1O_dataout XOR wire_n0O1l_dataout)) OR (wire_nii0i_dataout XOR wire_n0OOl_dataout));
	n1llii <= ((((((((((wire_ni0li_dataout XOR nl11i) OR (wire_ni0ll_dataout XOR nl11l)) OR (wire_ni0lO_dataout XOR nl11O)) OR (wire_ni0Oi_dataout XOR nl10i)) OR (wire_ni0Ol_dataout XOR nl10l)) OR (wire_ni0OO_dataout XOR nl10O)) OR (wire_nii1i_dataout XOR nl1ii)) OR (wire_nii1l_dataout XOR wire_ni10i_dataout)) OR (wire_nii1O_dataout XOR wire_ni11l_dataout)) OR (wire_nii0i_dataout XOR wire_ni10l_dataout));
	n1llil <= (((((((((wire_w_lg_w_SYNC_COMP_PAT_range157w462w(0) OR wire_w_lg_w_SYNC_COMP_PAT_range155w463w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range152w465w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range149w467w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range146w469w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range143w471w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range140w473w(0)) OR (wire_nil1l_dataout XOR wire_ni10i_dataout)) OR (wire_nil1O_dataout XOR wire_ni11l_dataout)) OR (wire_nil0i_dataout XOR wire_ni10l_dataout));
	n1lliO <= ((((((((((wire_ni0li_dataout XOR nl11l) OR (wire_ni0ll_dataout XOR nl11O)) OR (wire_ni0lO_dataout XOR nl10i)) OR (wire_ni0Oi_dataout XOR nl10l)) OR (wire_ni0Ol_dataout XOR nl10O)) OR (wire_ni0OO_dataout XOR nl1ii)) OR (wire_nii1i_dataout XOR nl1il)) OR (wire_nii1l_dataout XOR wire_ni1ii_dataout)) OR (wire_nii1O_dataout XOR wire_ni10l_dataout)) OR (wire_nii0i_dataout XOR wire_ni1il_dataout));
	n1llli <= (((((((((wire_w_lg_w_SYNC_COMP_PAT_range157w424w(0) OR wire_w_lg_w_SYNC_COMP_PAT_range155w425w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range152w427w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range149w429w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range146w431w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range143w433w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range140w435w(0)) OR (wire_nil1l_dataout XOR wire_ni1ii_dataout)) OR (wire_nil1O_dataout XOR wire_ni10l_dataout)) OR (wire_nil0i_dataout XOR wire_ni1il_dataout));
	n1llll <= ((((((((((wire_ni0li_dataout XOR nl11O) OR (wire_ni0ll_dataout XOR nl10i)) OR (wire_ni0lO_dataout XOR nl10l)) OR (wire_ni0Oi_dataout XOR nl10O)) OR (wire_ni0Ol_dataout XOR nl1ii)) OR (wire_ni0OO_dataout XOR nl1il)) OR (wire_nii1i_dataout XOR nl1iO)) OR (wire_nii1l_dataout XOR wire_ni1li_dataout)) OR (wire_nii1O_dataout XOR wire_ni1il_dataout)) OR (wire_nii0i_dataout XOR wire_ni1ll_dataout));
	n1lllO <= (((((((((wire_w_lg_w_SYNC_COMP_PAT_range157w386w(0) OR wire_w_lg_w_SYNC_COMP_PAT_range155w387w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range152w389w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range149w391w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range146w393w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range143w395w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range140w397w(0)) OR (wire_nil1l_dataout XOR wire_ni1li_dataout)) OR (wire_nil1O_dataout XOR wire_ni1il_dataout)) OR (wire_nil0i_dataout XOR wire_ni1ll_dataout));
	n1llOi <= ((((((((((wire_ni0li_dataout XOR nl10i) OR (wire_ni0ll_dataout XOR nl10l)) OR (wire_ni0lO_dataout XOR nl10O)) OR (wire_ni0Oi_dataout XOR nl1ii)) OR (wire_ni0Ol_dataout XOR nl1il)) OR (wire_ni0OO_dataout XOR nl1iO)) OR (wire_nii1i_dataout XOR nl1li)) OR (wire_nii1l_dataout XOR wire_ni1Oi_dataout)) OR (wire_nii1O_dataout XOR wire_ni1ll_dataout)) OR (wire_nii0i_dataout XOR wire_ni1Ol_dataout));
	n1llOl <= (((((((((wire_w_lg_w_SYNC_COMP_PAT_range157w348w(0) OR wire_w_lg_w_SYNC_COMP_PAT_range155w349w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range152w351w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range149w353w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range146w355w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range143w357w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range140w359w(0)) OR (wire_nil1l_dataout XOR wire_ni1Oi_dataout)) OR (wire_nil1O_dataout XOR wire_ni1ll_dataout)) OR (wire_nil0i_dataout XOR wire_ni1Ol_dataout));
	n1llOO <= ((((((((((wire_ni0li_dataout XOR nl10l) OR (wire_ni0ll_dataout XOR nl10O)) OR (wire_ni0lO_dataout XOR nl1ii)) OR (wire_ni0Oi_dataout XOR nl1il)) OR (wire_ni0Ol_dataout XOR nl1iO)) OR (wire_ni0OO_dataout XOR nl1li)) OR (wire_nii1i_dataout XOR nl1ll)) OR (wire_nii1l_dataout XOR wire_ni01i_dataout)) OR (wire_nii1O_dataout XOR wire_ni1Ol_dataout)) OR (wire_nii0i_dataout XOR wire_ni01l_dataout));
	n1lO0l <= ((((((((((wire_w_lg_w_SYNC_COMP_PAT_range157w247w(0) XOR wire_w_lg_w_n1lOlO250w251w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range155w253w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range152w255w(0)) OR (wire_w_lg_w_SYNC_COMP_PAT_range149w257w(0) XOR wire_w_lg_w_n1lOli260w261w(0))) OR (wire_w_lg_w_SYNC_COMP_PAT_range146w264w(0) XOR wire_w_lg_w_n1lOil267w268w(0))) OR wire_w_lg_w_SYNC_COMP_PAT_range143w271w(0)) OR (wire_w_lg_w_SYNC_COMP_PAT_range140w273w(0) XOR wire_w_lg_w_n1lO0O276w277w(0))) OR (wire_nil1l_dataout XOR wire_ni00i_dataout)) OR (wire_nil1O_dataout XOR wire_ni01l_dataout)) OR (wire_nil0i_dataout XOR wire_ni00l_dataout));
	n1lO1i <= (((((((((wire_w_lg_w_SYNC_COMP_PAT_range157w310w(0) OR wire_w_lg_w_SYNC_COMP_PAT_range155w311w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range152w313w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range149w315w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range146w317w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range143w319w(0)) OR wire_w_lg_w_SYNC_COMP_PAT_range140w321w(0)) OR (wire_nil1l_dataout XOR wire_ni01i_dataout)) OR (wire_nil1O_dataout XOR wire_ni1Ol_dataout)) OR (wire_nil0i_dataout XOR wire_ni01l_dataout));
	n1lO1l <= ((((((((((wire_ni0li_dataout XOR nl10O) OR ((wire_ni0ll_dataout XOR nl1ii) XOR wire_w_lg_w_n1lO1O290w291w(0))) OR (wire_ni0lO_dataout XOR nl1il)) OR (wire_ni0Oi_dataout XOR nl1iO)) OR (wire_ni0Ol_dataout XOR nl1li)) OR (wire_ni0OO_dataout XOR nl1ll)) OR (wire_nii1i_dataout XOR nl1lO)) OR (wire_nii1l_dataout XOR wire_ni00i_dataout)) OR (wire_nii1O_dataout XOR wire_ni01l_dataout)) OR (wire_nii0i_dataout XOR wire_ni00l_dataout));
	n1lOOl <= (((((((((((wire_ni0li_dataout XOR nl1ii) XOR wire_w_lg_w_n1O1li201w202w(0)) OR ((wire_ni0ll_dataout XOR nl1il) XOR wire_w_lg_w_n1O1il207w208w(0))) OR (wire_ni0lO_dataout XOR nl1iO)) OR ((wire_ni0Oi_dataout XOR nl1li) XOR wire_w_lg_w_n1O10O216w217w(0))) OR (wire_ni0Ol_dataout XOR nl1ll)) OR ((wire_ni0OO_dataout XOR nl1lO) XOR wire_w_lg_w_n1O10i225w226w(0))) OR ((wire_nii1i_dataout XOR nl1Oi) XOR wire_w_lg_w_n1O11l232w233w(0))) OR ((wire_nii1l_dataout XOR wire_ni0ii_dataout) XOR wire_w_lg_w_n1lOOO239w240w(0))) OR (wire_nii1O_dataout XOR wire_ni00l_dataout)) OR (wire_nii0i_dataout XOR wire_ni0il_dataout));
	n1O0li <= ((SYNC_COMP_SIZE(1) OR SYNC_COMP_SIZE(0)) OR wire_w_lg_w_n1O0il126w127w(0));
	n1O0ll <= ((SYNC_COMP_SIZE(1) OR (NOT SYNC_COMP_SIZE(0))) OR wire_w_lg_w_n1O00O133w134w(0));
	n1O0lO <= (wire_n1Olli_dataout AND (NOT (wire_w_lg_w_lg_n1Oi0i48w49w(0) AND wire_w_lg_n1Oi1i50w(0))));
	n1O0Oi <= ((n0000O AND wire_w_lg_n1Oi0O52w(0)) AND w_n1O0Ol56w);
	n1O1lO <= (((((((((wire_w_lg_w_SYNC_COMP_PAT_range157w159w(0) OR wire_w_lg_w_SYNC_COMP_PAT_range155w160w(0)) OR (wire_w_lg_w_SYNC_COMP_PAT_range152w162w(0) XOR wire_w_lg_w_n1O00i165w166w(0))) OR (wire_w_lg_w_SYNC_COMP_PAT_range149w169w(0) XOR wire_w_lg_w_n1O01l172w173w(0))) OR wire_w_lg_w_SYNC_COMP_PAT_range146w176w(0)) OR (wire_w_lg_w_SYNC_COMP_PAT_range143w178w(0) XOR wire_w_lg_w_n1O1OO181w182w(0))) OR (wire_w_lg_w_SYNC_COMP_PAT_range140w185w(0) XOR wire_w_lg_w_n1O1Oi188w189w(0))) OR (wire_nil1l_dataout XOR wire_ni0ii_dataout)) OR (wire_nil1O_dataout XOR wire_ni00l_dataout)) OR (wire_nil0i_dataout XOR wire_ni0il_dataout));
	n1Oi0i <= (wire_nll0OO_w_lg_dataout736w(0) OR wire_w_lg_n1li0O753w(0));
	n1Oi0l <= (n0000O AND n1Oi0O);
	n1Oi0O <= (wire_w_lg_w_lg_n1Oi0i48w49w(0) AND wire_w_lg_n1Oi1i50w(0));
	n1Oi1i <= ((((wire_w_lg_n1liOO735w(0) OR wire_w_lg_n1liOi739w(0)) OR wire_w_lg_n1lill743w(0)) OR wire_w_lg_n1liiO747w(0)) OR wire_w_lg_n1liii751w(0));
	n1Oi1l <= ((((wire_w_lg_n1liOl737w(0) OR wire_w_lg_n1liOi739w(0)) OR wire_w_lg_n1lili745w(0)) OR wire_w_lg_n1liiO747w(0)) OR wire_w_lg_n1li0O753w(0));
	n1Oi1O <= ((((wire_w_lg_n1liOl737w(0) OR wire_w_lg_n1liOi739w(0)) OR wire_w_lg_n1lilO741w(0)) OR wire_w_lg_n1lill743w(0)) OR wire_w_lg_n1li0O753w(0));
	n1Oiii <= (((((n001OO OR n001il) OR n001Oi) OR n001ll) OR n0010l) OR n001ii);
	n1Oiil <= (((((n001OO OR n001Ol) OR n001ll) OR n001li) OR n0010l) OR n1Ol0l);
	n1OiiO <= ((((n001iO OR n001Oi) OR n001lO) OR n001ll) OR n001li);
	n1Oili <= ((((n0001i OR n001OO) OR n001Ol) OR n001iO) OR n001il);
	n1OiOO <= (nii1li OR nii1iO);
	n1Ol1O <= rcvd_clk;
	RLV <= n1OiOO;
	RLV_lt <= ((((nii11O OR nii11l) OR wire_w_lg_w_n1OiOi29w30w(0)) OR (nii11i AND DWIDTH)) OR wire_w_lg_w_n1Oill36w37w(0));
	signal_detect_sync <= n0001O;
	SUDI <= ( nl01ii & nl010O & nl010l & nl010i & nl011O & nl011l & nl011i & nl1OOO & nl1OOl & nl1OOi & nl1OlO & nl1Oll & nl1Oli);
	SUDI_pre <= ( nli1ll & nl0i0i & nl0i1O & nl0i1l & nl0i1i & nl00OO & nl00Ol & nl00Oi & nl00lO & nl00ll);
	sync_curr_st <= ( n1Oili & n1OiiO & wire_w_lg_n1Oiil43w & n1Oiii);
	sync_status <= n1Olil;
	w_n1lO0O276w <= n1lO0O57;
	w_n1lO1O290w <= n1lO1O60;
	w_n1lOil267w <= n1lOil54;
	w_n1lOli260w <= n1lOli51;
	w_n1lOlO250w <= n1lOlO48;
	w_n1lOOO239w <= n1lOOO45;
	w_n1O00i165w <= n1O00i18;
	w_n1O00O133w <= n1O00O15;
	w_n1O01l172w <= n1O01l21;
	w_n1O0il126w <= n1O0il12;
	w_n1O0Ol56w <= n1O0Ol9;
	w_n1O10i225w <= n1O10i39;
	w_n1O10O216w <= n1O10O36;
	w_n1O11l232w <= n1O11l42;
	w_n1O1il207w <= n1O1il33;
	w_n1O1li201w <= n1O1li30;
	w_n1O1Oi188w <= n1O1Oi27;
	w_n1O1OO181w <= n1O1OO24;
	w_n1Oill36w <= n1Oill6;
	w_n1OiOi29w <= n1OiOi3;
	wire_w_SYNC_COMP_PAT_range157w(0) <= SYNC_COMP_PAT(0);
	wire_w_SYNC_COMP_PAT_range155w(0) <= SYNC_COMP_PAT(1);
	wire_w_SYNC_COMP_PAT_range152w(0) <= SYNC_COMP_PAT(2);
	wire_w_SYNC_COMP_PAT_range149w(0) <= SYNC_COMP_PAT(3);
	wire_w_SYNC_COMP_PAT_range146w(0) <= SYNC_COMP_PAT(4);
	wire_w_SYNC_COMP_PAT_range143w(0) <= SYNC_COMP_PAT(5);
	wire_w_SYNC_COMP_PAT_range140w(0) <= SYNC_COMP_PAT(6);
	wire_w_SYNC_COMP_PAT_range120w(0) <= SYNC_COMP_PAT(7);
	wire_w_SYNC_COMP_PAT_range118w(0) <= SYNC_COMP_PAT(8);
	wire_w_SYNC_COMP_PAT_range116w(0) <= SYNC_COMP_PAT(9);
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n0000i <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN n0000i <= n0000l;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n0000l <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN n0000l <= prbs_en;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n0000O <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN n0000O <= n1Olii;
		END IF;
	END PROCESS;
	wire_n0000O_w_lg_Q82w(0) <= NOT n0000O;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n0001i <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN n0001i <= wire_n011Oi_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n0001l <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN n0001l <= (wire_w_lg_SYNC_SM_DIS1288w(0) AND (LP10BEN OR signal_detect));
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n0001O <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN n0001O <= n0001l;
		END IF;
	END PROCESS;
	wire_n0001O_w_lg_Q2495w(0) <= n0001O AND wire_w_lg_n11OOO2494w(0);
	wire_n0001O_w_lg_Q2461w(0) <= NOT n0001O;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n0010i <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN n0010i <= wire_n1OlOO_o;
		END IF;
	END PROCESS;
	wire_n0010i_w_lg_Q2496w(0) <= NOT n0010i;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n0010l <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN n0010l <= wire_n1OOii_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n0010O <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN n0010O <= wire_n1OOiO_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n001ii <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN n001ii <= wire_n1OOll_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n001il <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN n001il <= wire_n1OOOi_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n001iO <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN n001iO <= wire_n1OOOO_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n001li <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN n001li <= wire_n0111l_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n001ll <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN n001ll <= wire_n0110i_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n001lO <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN n001lO <= wire_n0110O_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n001Oi <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN n001Oi <= wire_n011il_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n001Ol <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN n001Ol <= wire_n011li_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n001OO <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN n001OO <= wire_n011ll_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n0i00i <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN n0i00i <= wire_n00Oli_o;
		END IF;
	END PROCESS;
	wire_n0i00i_w_lg_w_lg_w_lg_Q675w676w677w(0) <= NOT wire_n0i00i_w_lg_w_lg_Q675w676w(0);
	wire_n0i00i_w_lg_Q675w(0) <= NOT n0i00i;
	wire_n0i00i_w_lg_w_lg_Q675w676w(0) <= wire_n0i00i_w_lg_Q675w(0) OR n0i01O;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n0i00l <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN n0i00l <= wire_w_lg_n1lllO659w(0);
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n0i00O <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN n0i00O <= wire_n00O1O_o;
		END IF;
	END PROCESS;
	wire_n0i00O_w_lg_w_lg_w_lg_Q664w665w666w(0) <= NOT wire_n0i00O_w_lg_w_lg_Q664w665w(0);
	wire_n0i00O_w_lg_Q664w(0) <= NOT n0i00O;
	wire_n0i00O_w_lg_w_lg_Q664w665w(0) <= wire_n0i00O_w_lg_Q664w(0) OR n0i00l;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n0i01i <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN n0i01i <= wire_w_lg_n1llil681w(0);
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n0i01l <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN n0i01l <= wire_n0i11l_o;
		END IF;
	END PROCESS;
	wire_n0i01l_w_lg_w_lg_w_lg_Q686w687w688w(0) <= NOT wire_n0i01l_w_lg_w_lg_Q686w687w(0);
	wire_n0i01l_w_lg_Q686w(0) <= NOT n0i01l;
	wire_n0i01l_w_lg_w_lg_Q686w687w(0) <= wire_n0i01l_w_lg_Q686w(0) OR n0i01i;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n0i01O <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN n0i01O <= wire_w_lg_n1llli670w(0);
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n0i0ii <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN n0i0ii <= wire_w_lg_n1llOl648w(0);
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n0i0il <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN n0i0il <= wire_n00lll_o;
		END IF;
	END PROCESS;
	wire_n0i0il_w_lg_w_lg_w_lg_Q653w654w655w(0) <= NOT wire_n0i0il_w_lg_w_lg_Q653w654w(0);
	wire_n0i0il_w_lg_Q653w(0) <= NOT n0i0il;
	wire_n0i0il_w_lg_w_lg_Q653w654w(0) <= wire_n0i0il_w_lg_Q653w(0) OR n0i0ii;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n0i0iO <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN n0i0iO <= wire_w_lg_n1lO1i637w(0);
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n0i0li <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN n0i0li <= wire_n00l0i_o;
		END IF;
	END PROCESS;
	wire_n0i0li_w_lg_w_lg_w_lg_Q642w643w644w(0) <= NOT wire_n0i0li_w_lg_w_lg_Q642w643w(0);
	wire_n0i0li_w_lg_Q642w(0) <= NOT n0i0li;
	wire_n0i0li_w_lg_w_lg_Q642w643w(0) <= wire_n0i0li_w_lg_Q642w(0) OR n0i0iO;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n0i0ll <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN n0i0ll <= wire_w_lg_n1lO0l626w(0);
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n0i0lO <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN n0i0lO <= wire_n00ilO_o;
		END IF;
	END PROCESS;
	wire_n0i0lO_w_lg_w_lg_w_lg_Q631w632w633w(0) <= NOT wire_n0i0lO_w_lg_w_lg_Q631w632w(0);
	wire_n0i0lO_w_lg_Q631w(0) <= NOT n0i0lO;
	wire_n0i0lO_w_lg_w_lg_Q631w632w(0) <= wire_n0i0lO_w_lg_Q631w(0) OR n0i0ll;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n0i0Oi <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN n0i0Oi <= wire_w_lg_n1O1lO614w(0);
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n0i1Oi <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN n0i1Oi <= wire_w_lg_n1ll0O692w(0);
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n0i1Ol <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN n0i1Ol <= wire_w_lg_n1ll0O692w(0);
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n0i1OO <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN n0i1OO <= wire_n0i1iO_o;
		END IF;
	END PROCESS;
	wire_n0i1OO_w_lg_w_lg_w_lg_Q697w698w699w(0) <= NOT wire_n0i1OO_w_lg_w_lg_Q697w698w(0);
	wire_n0i1OO_w_lg_Q697w(0) <= NOT n0i1OO;
	wire_n0i1OO_w_lg_w_lg_Q697w698w(0) <= wire_n0i1OO_w_lg_Q697w(0) OR n0i1Ol;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n0iiOO <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN n0iiOO <= wire_n00i0l_o;
		END IF;
	END PROCESS;
	wire_n0iiOO_w_lg_w_lg_w_lg_Q620w621w622w(0) <= NOT wire_n0iiOO_w_lg_w_lg_Q620w621w(0);
	wire_n0iiOO_w_lg_Q620w(0) <= NOT n0iiOO;
	wire_n0iiOO_w_lg_w_lg_Q620w621w(0) <= wire_n0iiOO_w_lg_Q620w(0) OR n0i0Oi;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n0il0i <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN n0il0i <= wire_w_lg_n1llOl648w(0);
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n0il0l <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN n0il0l <= wire_w_lg_n1lllO659w(0);
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n0il0O <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN n0il0O <= wire_w_lg_n1llli670w(0);
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n0il1i <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN n0il1i <= wire_w_lg_n1O1lO614w(0);
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n0il1l <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN n0il1l <= wire_w_lg_n1lO0l626w(0);
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n0il1O <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN n0il1O <= wire_w_lg_n1lO1i637w(0);
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n0ilii <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN n0ilii <= wire_w_lg_n1llil681w(0);
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1lO0O55 <= n1lO0O56;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1lO0O56 <= n1lO0O55;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1lO0O57 <= (n1lO0O56 XOR n1lO0O55);
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1lO1O58 <= n1lO1O59;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1lO1O59 <= n1lO1O58;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1lO1O60 <= (n1lO1O59 XOR n1lO1O58);
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1lOil52 <= n1lOil53;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1lOil53 <= n1lOil52;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1lOil54 <= (n1lOil53 XOR n1lOil52);
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1lOli49 <= n1lOli50;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1lOli50 <= n1lOli49;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1lOli51 <= (n1lOli50 XOR n1lOli49);
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1lOlO46 <= n1lOlO47;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1lOlO47 <= n1lOlO46;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1lOlO48 <= (n1lOlO47 XOR n1lOlO46);
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1lOOO43 <= n1lOOO44;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1lOOO44 <= n1lOOO43;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1lOOO45 <= (n1lOOO44 XOR n1lOOO43);
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O00i16 <= n1O00i17;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O00i17 <= n1O00i16;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O00i18 <= (n1O00i17 XOR n1O00i16);
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O00O13 <= n1O00O14;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O00O14 <= n1O00O13;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O00O15 <= (n1O00O14 XOR n1O00O13);
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O01l19 <= n1O01l20;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O01l20 <= n1O01l19;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O01l21 <= (n1O01l20 XOR n1O01l19);
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O0il10 <= n1O0il11;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O0il11 <= n1O0il10;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O0il12 <= (n1O0il11 XOR n1O0il10);
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O0Ol7 <= n1O0Ol8;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O0Ol8 <= n1O0Ol7;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O0Ol9 <= (n1O0Ol8 XOR n1O0Ol7);
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O10i37 <= n1O10i38;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O10i38 <= n1O10i37;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O10i39 <= (n1O10i38 XOR n1O10i37);
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O10O34 <= n1O10O35;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O10O35 <= n1O10O34;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O10O36 <= (n1O10O35 XOR n1O10O34);
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O11l40 <= n1O11l41;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O11l41 <= n1O11l40;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O11l42 <= (n1O11l41 XOR n1O11l40);
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O1il31 <= n1O1il32;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O1il32 <= n1O1il31;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O1il33 <= (n1O1il32 XOR n1O1il31);
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O1li28 <= n1O1li29;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O1li29 <= n1O1li28;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O1li30 <= (n1O1li29 XOR n1O1li28);
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O1Oi25 <= n1O1Oi26;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O1Oi26 <= n1O1Oi25;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O1Oi27 <= (n1O1Oi26 XOR n1O1Oi25);
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O1OO22 <= n1O1OO23;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O1OO23 <= n1O1OO22;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1O1OO24 <= (n1O1OO23 XOR n1O1OO22);
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1Oill4 <= n1Oill5;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1Oill5 <= n1Oill4;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1Oill6 <= (n1Oill5 XOR n1Oill4);
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1OiOi1 <= n1OiOi2;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1OiOi2 <= n1OiOi1;
		END IF;
	END PROCESS;
	PROCESS (n1Ol1O)
	BEGIN
		IF (n1Ol1O = '1' AND n1Ol1O'event) THEN n1OiOi3 <= (n1OiOi2 XOR 
		n1OiOi1);
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n1Ol0i <= '1';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1Ol0i <= wire_n1OO0i_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n1Ol0l <= '1';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1Ol0l <= wire_n1OO0O_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n1Ol0O <= '1';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN n1Ol0O <= n1Ol0i;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n1Olii <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN n1Olii <= ENCDT;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n1Olil <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1Olil <= wire_n1OO1l_o;
		END IF;
	END PROCESS;
	wire_n1Olil_w_lg_Q1289w(0) <= n1Olil AND wire_w_lg_SYNC_SM_DIS1288w(0);
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n1OliO <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1OliO <= wire_n1OO0l_o;
		END IF;
	END PROCESS;
	wire_n1OliO_w_lg_Q2463w(0) <= NOT n1OliO;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n1OlOi <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1OlOi <= wire_n1OlOl_o;
		END IF;
	END PROCESS;
	wire_n1OlOi_w_lg_Q2497w(0) <= NOT n1OlOi;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN ni0liO <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN ni0liO <= wire_ni011i_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN ni0lli <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN ni0lli <= wire_ni000i_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN ni0lll <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN ni0lll <= wire_ni000l_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN ni0llO <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN ni0llO <= wire_ni000O_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN ni0lOi <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN ni0lOi <= wire_ni00ii_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN ni0lOl <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN ni0lOl <= wire_ni00il_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN ni0lOO <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN ni0lOO <= wire_ni00li_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN ni0OOO <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN ni0OOO <= wire_ni00lO_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN ni1O0i <= '1';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN ni1O0i <= wire_nii1lO_w_lg_Q1765w(0);
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN ni1O0l <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN ni1O0l <= wire_nil0li_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN ni1O0O <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN ni1O0O <= wire_ni011O_o(0);
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN ni1Oii <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN ni1Oii <= wire_ni011O_o(1);
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN ni1Oil <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN ni1Oil <= wire_ni011O_o(2);
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN ni1OiO <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN ni1OiO <= wire_ni011O_o(3);
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN ni1Oli <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN ni1Oli <= wire_ni1OOi_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN ni1Oll <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN ni1Oll <= wire_ni1OOl_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN ni1OlO <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN ni1OlO <= wire_ni1OOO_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nii11i <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nii11i <= wire_nii10i_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nii11l <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nii11l <= wire_nii10l_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nii11O <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nii11O <= wire_nii10O_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nii1iO <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nii1iO <= wire_nii1ii_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nii1li <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nii1li <= nii1ll;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nii1ll <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nii1ll <= (niiOOl OR niiiOl);
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nii1lO <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nii1lO <= niiiOi;
		END IF;
	END PROCESS;
	wire_nii1lO_w_lg_Q1765w(0) <= NOT nii1lO;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN niiiOi <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN niiiOi <= RLV_EN;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN niiiOl <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN niiiOl <= wire_niilOi_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN niiiOO <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN niiiOO <= wire_niilOl_dataout;
		END IF;
	END PROCESS;
	wire_niiiOO_w_lg_Q1894w(0) <= NOT niiiOO;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN niil0i <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN niil0i <= wire_niiO1O_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN niil0l <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN niil0l <= wire_niiO0i_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN niil0O <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN niil0O <= wire_niiO0l_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN niil1i <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN niil1i <= wire_niilOO_dataout;
		END IF;
	END PROCESS;
	wire_niil1i_w_lg_Q1900w(0) <= NOT niil1i;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN niil1l <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN niil1l <= wire_niiO1i_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN niil1O <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN niil1O <= wire_niiO1l_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN niilii <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN niilii <= wire_niiO0O_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN niilil <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN niilil <= wire_niiOii_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN niiliO <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN niiliO <= wire_niiOil_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN niilli <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN niilli <= wire_niiOiO_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN niilll <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN niilll <= wire_niiOli_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN niillO <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN niillO <= wire_niiOll_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN niiOOi <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN niiOOi <= wire_niiOlO_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN niiOOl <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN niiOOl <= wire_nil1lO_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN niiOOO <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN niiOOO <= wire_nil1Oi_dataout;
		END IF;
	END PROCESS;
	wire_niiOOO_w_lg_Q1895w(0) <= NOT niiOOO;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nil10i <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nil10i <= wire_nil01l_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nil10l <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nil10l <= wire_nil01O_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nil10O <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nil10O <= wire_nil00i_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nil11i <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nil11i <= wire_nil1Ol_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nil11l <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nil11l <= wire_nil1OO_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nil11O <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nil11O <= wire_nil01i_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nil1ii <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nil1ii <= wire_nil00l_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nil1il <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nil1il <= wire_nil00O_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nil1iO <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nil1iO <= wire_nil0ii_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nil1li <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nil1li <= wire_nil0il_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nil1ll <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nil1ll <= wire_nil0iO_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nilii <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN 
			IF (n1O0lO = '1') THEN nilii <= n1Oi0i;
			END IF;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nilil <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nilil <= nl1ii;
		END IF;
	END PROCESS;
	wire_nilil_w_lg_Q1661w(0) <= NOT nilil;
	wire_nilil_w_lg_w_lg_w_lg_Q1569w1570w1571w(0) <= wire_nilil_w_lg_w_lg_Q1569w1570w(0) OR n1iiOi;
	wire_nilil_w_lg_w_lg_Q1569w1570w(0) <= wire_nilil_w_lg_Q1569w(0) OR wire_w_lg_n1illl1410w(0);
	wire_nilil_w_lg_Q1569w(0) <= nilil OR n1il0O;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN niliO <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN niliO <= nl1il;
		END IF;
	END PROCESS;
	wire_niliO_w_lg_Q1810w(0) <= NOT niliO;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nilli <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nilli <= nl1iO;
		END IF;
	END PROCESS;
	wire_nilli_w_lg_Q1805w(0) <= NOT nilli;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nilll <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nilll <= nl1li;
		END IF;
	END PROCESS;
	wire_nilll_w_lg_Q1803w(0) <= NOT nilll;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nillO <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nillO <= nl1ll;
		END IF;
	END PROCESS;
	wire_nillO_w_lg_Q1801w(0) <= NOT nillO;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nilOi <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nilOi <= nl1lO;
		END IF;
	END PROCESS;
	wire_nilOi_w_lg_w_lg_w_lg_Q1451w1452w1453w(0) <= wire_nilOi_w_lg_w_lg_Q1451w1452w(0) AND nilOO;
	wire_nilOi_w_lg_w_lg_Q1451w1452w(0) <= wire_nilOi_w_lg_Q1451w(0) AND nilOl;
	wire_nilOi_w_lg_w_lg_Q1444w1445w(0) <= wire_nilOi_w_lg_Q1444w(0) AND nilOO;
	wire_nilOi_w_lg_Q1451w(0) <= nilOi AND nillO;
	wire_nilOi_w_lg_Q1444w(0) <= nilOi AND nilOl;
	wire_nilOi_w_lg_w_lg_w_lg_w_lg_Q1367w1368w1369w1370w(0) <= NOT wire_nilOi_w_lg_w_lg_w_lg_Q1367w1368w1369w(0);
	wire_nilOi_w_lg_w_lg_w_lg_Q1358w1359w1360w(0) <= NOT wire_nilOi_w_lg_w_lg_Q1358w1359w(0);
	wire_nilOi_w_lg_Q1799w(0) <= NOT nilOi;
	wire_nilOi_w_lg_w_lg_w_lg_Q1367w1368w1369w(0) <= wire_nilOi_w_lg_w_lg_Q1367w1368w(0) OR nilOO;
	wire_nilOi_w_lg_w_lg_Q1367w1368w(0) <= wire_nilOi_w_lg_Q1367w(0) OR nilOl;
	wire_nilOi_w_lg_w_lg_Q1358w1359w(0) <= wire_nilOi_w_lg_Q1358w(0) OR nilOO;
	wire_nilOi_w_lg_Q1367w(0) <= nilOi OR nillO;
	wire_nilOi_w_lg_Q1358w(0) <= nilOi OR nilOl;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nilOl <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nilOl <= nl1Oi;
		END IF;
	END PROCESS;
	wire_nilOl_w_lg_w_lg_w_lg_Q1438w1448w1449w(0) <= wire_nilOl_w_lg_w_lg_Q1438w1448w(0) AND niO1l;
	wire_nilOl_w_lg_w_lg_Q1438w1448w(0) <= wire_nilOl_w_lg_Q1438w(0) AND niO1i;
	wire_nilOl_w_lg_Q1438w(0) <= nilOl AND nilOO;
	wire_nilOl_w_lg_w_lg_Q1350w1351w(0) <= NOT wire_nilOl_w_lg_Q1350w(0);
	wire_nilOl_w_lg_Q1808w(0) <= NOT nilOl;
	wire_nilOl_w_lg_Q1350w(0) <= nilOl OR nilOO;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nilOO <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nilOO <= nl1Ol;
		END IF;
	END PROCESS;
	wire_nilOO_w_lg_w_lg_Q1441w1442w(0) <= wire_nilOO_w_lg_Q1441w(0) AND niO1l;
	wire_nilOO_w_lg_Q1441w(0) <= nilOO AND niO1i;
	wire_nilOO_w_lg_Q1529w(0) <= NOT nilOO;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN niO0i <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN 
			IF (PMADATAWIDTH = '0') THEN niO0i <= niOOl;
			END IF;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN niO0l <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN 
			IF (PMADATAWIDTH = '0') THEN niO0l <= niOOO;
			END IF;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN niO0O <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN niO0O <= wire_nl01i_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN niO1i <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN niO1i <= nl1OO;
		END IF;
	END PROCESS;
	wire_niO1i_w_lg_Q1825w(0) <= NOT niO1i;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN niO1l <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN niO1l <= nl1iiO;
		END IF;
	END PROCESS;
	wire_niO1l_w_lg_Q1527w(0) <= NOT niO1l;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN niO1O <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN 
			IF (PMADATAWIDTH = '0') THEN niO1O <= niOOi;
			END IF;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN niOii <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN niOii <= wire_nl01l_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN niOil <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN niOil <= wire_nl01O_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN niOiO <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN niOiO <= wire_nl00i_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN niOli <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN niOli <= wire_nl00l_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN niOll <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN niOll <= wire_nl00O_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN niOlO <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN niOlO <= wire_nl0ii_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN niOOi <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN niOOi <= wire_nl0il_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN niOOl <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN niOOl <= wire_nl0iO_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN niOOO <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN niOOO <= wire_nl0li_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl000i <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl000i <= wire_nli11O_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl000l <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl000l <= wire_nli10i_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl000O <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl000O <= wire_nli10l_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl001i <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl001i <= nl00li;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl001l <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl001l <= wire_nli11i_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl001O <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl001O <= wire_nli11l_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl00ii <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl00ii <= wire_nli10O_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl00il <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl00il <= wire_nli1ii_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl00iO <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl00iO <= wire_nli1il_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl00li <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl00li <= nll10i;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl00ll <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl00ll <= nli1lO;
		END IF;
	END PROCESS;
	wire_nl00ll_w_lg_Q2225w(0) <= NOT nl00ll;
	wire_nl00ll_w_lg_Q1315w(0) <= nl00ll XOR wire_w_lg_w_SYNC_COMP_PAT_range157w158w(0);
	wire_nl00ll_w_lg_Q1296w(0) <= nl00ll XOR wire_w_SYNC_COMP_PAT_range157w(0);
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl00lO <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl00lO <= nli1Oi;
		END IF;
	END PROCESS;
	wire_nl00lO_w_lg_w_lg_Q2224w2226w(0) <= wire_nl00lO_w_lg_Q2224w(0) AND wire_nl00ll_w_lg_Q2225w(0);
	wire_nl00lO_w_lg_w_lg_Q2224w2261w(0) <= wire_nl00lO_w_lg_Q2224w(0) AND nl00ll;
	wire_nl00lO_w_lg_Q2262w(0) <= nl00lO AND wire_nl00ll_w_lg_Q2225w(0);
	wire_nl00lO_w_lg_Q2224w(0) <= NOT nl00lO;
	wire_nl00lO_w_lg_Q1316w(0) <= nl00lO XOR wire_w_lg_w_SYNC_COMP_PAT_range155w156w(0);
	wire_nl00lO_w_lg_Q1297w(0) <= nl00lO XOR wire_w_SYNC_COMP_PAT_range155w(0);
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl00Oi <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl00Oi <= nli1Ol;
		END IF;
	END PROCESS;
	wire_nl00Oi_w_lg_w_lg_Q2233w2272w(0) <= wire_nl00Oi_w_lg_Q2233w(0) AND n1010i;
	wire_nl00Oi_w_lg_w_lg_Q2233w2269w(0) <= wire_nl00Oi_w_lg_Q2233w(0) AND n1010l;
	wire_nl00Oi_w_lg_w_lg_Q2233w2289w(0) <= wire_nl00Oi_w_lg_Q2233w(0) AND n1011l;
	wire_nl00Oi_w_lg_w_lg_Q2233w2284w(0) <= wire_nl00Oi_w_lg_Q2233w(0) AND n1011O;
	wire_nl00Oi_w_lg_Q2227w(0) <= nl00Oi AND wire_nl00lO_w_lg_w_lg_Q2224w2226w(0);
	wire_nl00Oi_w_lg_Q2292w(0) <= nl00Oi AND wire_nl00lO_w_lg_w_lg_Q2224w2261w(0);
	wire_nl00Oi_w_lg_Q2295w(0) <= nl00Oi AND wire_nl00lO_w_lg_Q2262w(0);
	wire_nl00Oi_w_lg_Q2233w(0) <= NOT nl00Oi;
	wire_nl00Oi_w_lg_Q1318w(0) <= nl00Oi XOR wire_w_lg_w_SYNC_COMP_PAT_range152w153w(0);
	wire_nl00Oi_w_lg_Q1299w(0) <= nl00Oi XOR wire_w_SYNC_COMP_PAT_range152w(0);
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl00Ol <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl00Ol <= nli1OO;
		END IF;
	END PROCESS;
	wire_nl00Ol_w_lg_w_lg_Q1266w2247w(0) <= wire_nl00Ol_w_lg_Q1266w(0) AND n1010O;
	wire_nl00Ol_w_lg_w_lg_Q1266w1267w(0) <= wire_nl00Ol_w_lg_Q1266w(0) AND n1l1il;
	wire_nl00Ol_w_lg_Q2273w(0) <= nl00Ol AND wire_nl00Oi_w_lg_w_lg_Q2233w2272w(0);
	wire_nl00Ol_w_lg_Q2270w(0) <= nl00Ol AND wire_nl00Oi_w_lg_w_lg_Q2233w2269w(0);
	wire_nl00Ol_w_lg_Q2290w(0) <= nl00Ol AND wire_nl00Oi_w_lg_w_lg_Q2233w2289w(0);
	wire_nl00Ol_w_lg_Q2285w(0) <= nl00Ol AND wire_nl00Oi_w_lg_w_lg_Q2233w2284w(0);
	wire_nl00Ol_w_lg_Q2228w(0) <= nl00Ol AND wire_nl00Oi_w_lg_Q2227w(0);
	wire_nl00Ol_w_lg_Q2293w(0) <= nl00Ol AND wire_nl00Oi_w_lg_Q2292w(0);
	wire_nl00Ol_w_lg_Q2296w(0) <= nl00Ol AND wire_nl00Oi_w_lg_Q2295w(0);
	wire_nl00Ol_w_lg_Q1266w(0) <= NOT nl00Ol;
	wire_nl00Ol_w_lg_Q1320w(0) <= nl00Ol XOR wire_w_lg_w_SYNC_COMP_PAT_range149w150w(0);
	wire_nl00Ol_w_lg_Q1301w(0) <= nl00Ol XOR wire_w_SYNC_COMP_PAT_range149w(0);
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl00OO <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl00OO <= nli01i;
		END IF;
	END PROCESS;
	wire_nl00OO_w_lg_Q2232w(0) <= NOT nl00OO;
	wire_nl00OO_w_lg_Q1322w(0) <= nl00OO XOR wire_w_lg_w_SYNC_COMP_PAT_range146w147w(0);
	wire_nl00OO_w_lg_Q1303w(0) <= nl00OO XOR wire_w_SYNC_COMP_PAT_range146w(0);
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl010i <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl010i <= wire_nl0lil_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl010l <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl010l <= wire_w_lg_n1l11i1291w(0);
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl010O <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl010O <= (((wire_w_lg_PMADATAWIDTH115w(0) AND (nl1OiO AND SYNC_SM_DIS)) OR wire_w_lg_PMADATAWIDTH1286w(0)) OR wire_n1Olil_w_lg_Q1289w(0));
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl011i <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl011i <= wire_nl0l0l_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl011l <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl011l <= wire_nl0l0O_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl011O <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl011O <= wire_nl0lii_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl01ii <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl01ii <= n1l11l;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl01il <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl01il <= wire_nl0Oil_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl01iO <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl01iO <= wire_nl0OiO_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl01li <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl01li <= wire_nl0Oli_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl01ll <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl01ll <= wire_nl0Oll_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl01lO <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl01lO <= wire_nl0OlO_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl01Oi <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl01Oi <= wire_nl0OOi_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl01Ol <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl01Ol <= wire_nl0OOl_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl01OO <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl01OO <= wire_nl0OOO_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl0i0i <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl0i0i <= nli00l;
		END IF;
	END PROCESS;
	wire_nl0i0i_w_lg_w_lg_Q1336w2197w(0) <= wire_nl0i0i_w_lg_Q1336w(0) AND n101ll;
	wire_nl0i0i_w_lg_w_lg_Q1336w2192w(0) <= wire_nl0i0i_w_lg_Q1336w(0) AND n101lO;
	wire_nl0i0i_w_lg_w_lg_Q1336w2173w(0) <= wire_nl0i0i_w_lg_Q1336w(0) AND n101Oi;
	wire_nl0i0i_w_lg_w_lg_Q1336w2170w(0) <= wire_nl0i0i_w_lg_Q1336w(0) AND n101Ol;
	wire_nl0i0i_w_lg_Q2177w(0) <= nl0i0i AND wire_nl0i1O_w_lg_w_lg_Q1337w2176w(0);
	wire_nl0i0i_w_lg_Q2200w(0) <= nl0i0i AND wire_nl0i1O_w_lg_w_lg_Q1337w2159w(0);
	wire_nl0i0i_w_lg_Q2147w(0) <= nl0i0i AND wire_nl0i1O_w_lg_Q2146w(0);
	wire_nl0i0i_w_lg_Q2203w(0) <= nl0i0i AND wire_nl0i1O_w_lg_Q2160w(0);
	wire_nl0i0i_w_lg_Q1343w(0) <= nl0i0i AND wire_nl0i1O_w_lg_Q1342w(0);
	wire_nl0i0i_w_lg_Q1336w(0) <= NOT nl0i0i;
	wire_nl0i0i_w_lg_Q1330w(0) <= nl0i0i XOR wire_w_lg_w_SYNC_COMP_PAT_range118w137w(0);
	wire_nl0i0i_w_lg_Q1311w(0) <= nl0i0i XOR wire_w_SYNC_COMP_PAT_range118w(0);
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl0i1i <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl0i1i <= nli01l;
		END IF;
	END PROCESS;
	wire_nl0i1i_w_lg_w_lg_Q2231w2252w(0) <= wire_nl0i1i_w_lg_Q2231w(0) AND nl00OO;
	wire_nl0i1i_w_lg_Q2253w(0) <= nl0i1i AND wire_nl00OO_w_lg_Q2232w(0);
	wire_nl0i1i_w_lg_Q2231w(0) <= NOT nl0i1i;
	wire_nl0i1i_w_lg_Q1324w(0) <= nl0i1i XOR wire_w_lg_w_SYNC_COMP_PAT_range143w144w(0);
	wire_nl0i1i_w_lg_Q1305w(0) <= nl0i1i XOR wire_w_SYNC_COMP_PAT_range143w(0);
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl0i1l <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl0i1l <= nli01O;
		END IF;
	END PROCESS;
	wire_nl0i1l_w_lg_w_lg_Q2106w2111w(0) <= wire_nl0i1l_w_lg_Q2106w(0) AND n1000O;
	wire_nl0i1l_w_lg_w_lg_Q2106w2107w(0) <= wire_nl0i1l_w_lg_Q2106w(0) AND n1l11O;
	wire_nl0i1l_w_lg_Q1276w(0) <= nl0i1l AND n1l11O;
	wire_nl0i1l_w_lg_Q2106w(0) <= NOT nl0i1l;
	wire_nl0i1l_w_lg_Q1326w(0) <= nl0i1l XOR wire_w_lg_w_SYNC_COMP_PAT_range140w141w(0);
	wire_nl0i1l_w_lg_Q1307w(0) <= nl0i1l XOR wire_w_SYNC_COMP_PAT_range140w(0);
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl0i1O <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl0i1O <= nli00i;
		END IF;
	END PROCESS;
	wire_nl0i1O_w_lg_w_lg_w_lg_Q1337w2138w2139w(0) <= wire_nl0i1O_w_lg_w_lg_Q1337w2138w(0) AND n1000i;
	wire_nl0i1O_w_lg_w_lg_Q1337w2176w(0) <= wire_nl0i1O_w_lg_Q1337w(0) AND wire_nl0i1l_w_lg_Q2106w(0);
	wire_nl0i1O_w_lg_w_lg_Q1337w1338w(0) <= wire_nl0i1O_w_lg_Q1337w(0) AND n1iOll;
	wire_nl0i1O_w_lg_w_lg_Q1337w2138w(0) <= wire_nl0i1O_w_lg_Q1337w(0) AND n1iOOi;
	wire_nl0i1O_w_lg_w_lg_Q1337w2159w(0) <= wire_nl0i1O_w_lg_Q1337w(0) AND nl0i1l;
	wire_nl0i1O_w_lg_Q2146w(0) <= nl0i1O AND wire_w_lg_n1l11O2145w(0);
	wire_nl0i1O_w_lg_Q1277w(0) <= nl0i1O AND wire_nl0i1l_w_lg_Q1276w(0);
	wire_nl0i1O_w_lg_Q2160w(0) <= nl0i1O AND wire_nl0i1l_w_lg_Q2106w(0);
	wire_nl0i1O_w_lg_Q1342w(0) <= nl0i1O AND n1iOli;
	wire_nl0i1O_w_lg_Q2140w(0) <= nl0i1O AND n1iOlO;
	wire_nl0i1O_w_lg_Q1337w(0) <= NOT nl0i1O;
	wire_nl0i1O_w_lg_Q1328w(0) <= nl0i1O XOR wire_w_lg_w_SYNC_COMP_PAT_range120w138w(0);
	wire_nl0i1O_w_lg_Q1309w(0) <= nl0i1O XOR wire_w_SYNC_COMP_PAT_range120w(0);
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl10i <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nl10i <= wire_nl0Ol_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl10l <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nl10l <= wire_nl0OO_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl10O <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nl10O <= wire_nli1i_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl11i <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nl11i <= wire_nl0ll_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl11l <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nl11l <= wire_nl0lO_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl11O <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nl11O <= wire_nl0Oi_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl1i0i <= '1';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl1i0i <= (n1l11l OR 
		wire_w_lg_n1l11i1291w(0));
		END IF;
	END PROCESS;
	wire_nl1i0i_w_lg_Q2435w(0) <= NOT nl1i0i;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl1i0l <= '1';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nl1i0l <= wire_w_lg_n1Oi1i50w(0);
		END IF;
	END PROCESS;
	wire_nl1i0l_w_lg_Q773w(0) <= NOT nl1i0l;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl1i0O <= '1';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nl1i0O <= n1Oi1l;
		END IF;
	END PROCESS;
	wire_nl1i0O_w_lg_Q771w(0) <= NOT nl1i0O;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl1ii <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nl1ii <= wire_nli1l_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl1iii <= '1';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nl1iii <= n1Oi1O;
		END IF;
	END PROCESS;
	wire_nl1iii_w_lg_Q769w(0) <= NOT nl1iii;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl1iil <= '1';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nl1iil <= n1Oi0i;
		END IF;
	END PROCESS;
	wire_nl1iil_w_lg_Q768w(0) <= NOT nl1iil;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl1iiO <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN 
			IF (PMADATAWIDTH = '0') THEN nl1iiO <= wire_nlill_dataout;
			END IF;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl1il <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nl1il <= wire_nli1O_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl1ili <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl1ili <= (((n1iOOi OR n1iOlO) OR (wire_nli1ll_w_lg_Q1335w(0) AND (wire_nl0i0i_w_lg_Q1336w(0) AND wire_nl0i1O_w_lg_w_lg_Q1337w1338w(0)))) OR wire_nli1ll_w_lg_Q1344w(0));
		END IF;
	END PROCESS;
	wire_nl1ili_w_lg_Q2434w(0) <= NOT nl1ili;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl1ill <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl1ill <= wire_ni11Oi_dataout;
		END IF;
	END PROCESS;
	wire_nl1ill_w_lg_Q1269w(0) <= nl1ill AND wire_w_lg_n1l1iO1268w(0);
	wire_nl1ill_w_lg_Q1256w(0) <= NOT nl1ill;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl1iO <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nl1iO <= wire_nli0i_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl1li <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nl1li <= wire_nli0l_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl1ll <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nl1ll <= wire_nli0O_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl1lO <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nl1lO <= wire_nliii_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl1O0O <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl1O0O <= (wire_w_lg_PMADATAWIDTH115w(0) AND (wire_w_lg_n1iOOO1292w(0) OR wire_w_lg_n1iOOl1293w(0)));
		END IF;
	END PROCESS;
	wire_nl1O0O_w_lg_Q2460w(0) <= NOT nl1O0O;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl1Oi <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nl1Oi <= wire_nliil_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl1Oii <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl1Oii <= nl1Oil;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl1Oil <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl1Oil <= nl1OiO;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl1OiO <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl1OiO <= nliOll;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl1Ol <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nl1Ol <= wire_nliiO_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl1Oli <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl1Oli <= wire_nl0iOl_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl1Oll <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl1Oll <= wire_nl0iOO_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl1OlO <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl1OlO <= wire_nl0l1i_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl1OO <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN 
			IF (PMADATAWIDTH = '0') THEN nl1OO <= wire_nlili_dataout;
			END IF;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl1OOi <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl1OOi <= wire_nl0l1l_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl1OOl <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl1OOl <= wire_nl0l1O_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nl1OOO <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nl1OOO <= wire_nl0l0i_dataout;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nli00i <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nli00i <= wire_nli0Oi_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nli00l <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nli00l <= wire_nliiii_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nli01i <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nli01i <= wire_nli0li_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nli01l <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nli01l <= wire_nli0ll_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nli01O <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nli01O <= wire_nli0lO_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nli1ll <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nli1ll <= nliilO;
		END IF;
	END PROCESS;
	wire_nli1ll_w_lg_w_lg_Q1335w2121w(0) <= wire_nli1ll_w_lg_Q1335w(0) AND n1000O;
	wire_nli1ll_w_lg_Q2198w(0) <= nli1ll AND wire_nl0i0i_w_lg_w_lg_Q1336w2197w(0);
	wire_nli1ll_w_lg_Q2193w(0) <= nli1ll AND wire_nl0i0i_w_lg_w_lg_Q1336w2192w(0);
	wire_nli1ll_w_lg_Q2174w(0) <= nli1ll AND wire_nl0i0i_w_lg_w_lg_Q1336w2173w(0);
	wire_nli1ll_w_lg_Q2171w(0) <= nli1ll AND wire_nl0i0i_w_lg_w_lg_Q1336w2170w(0);
	wire_nli1ll_w_lg_Q2178w(0) <= nli1ll AND wire_nl0i0i_w_lg_Q2177w(0);
	wire_nli1ll_w_lg_Q2201w(0) <= nli1ll AND wire_nl0i0i_w_lg_Q2200w(0);
	wire_nli1ll_w_lg_Q2204w(0) <= nli1ll AND wire_nl0i0i_w_lg_Q2203w(0);
	wire_nli1ll_w_lg_Q1344w(0) <= nli1ll AND wire_nl0i0i_w_lg_Q1343w(0);
	wire_nli1ll_w_lg_Q1335w(0) <= NOT nli1ll;
	wire_nli1ll_w_lg_Q1332w(0) <= nli1ll XOR wire_w_lg_w_SYNC_COMP_PAT_range116w136w(0);
	wire_nli1ll_w_lg_Q1313w(0) <= nli1ll XOR wire_w_SYNC_COMP_PAT_range116w(0);
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nli1lO <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nli1lO <= wire_nli00O_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nli1Oi <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nli1Oi <= wire_nli0ii_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nli1Ol <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nli1Ol <= wire_nli0il_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nli1OO <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nli1OO <= wire_nli0iO_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nliilO <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nliilO <= wire_nliiil_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nliiOi <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nliiOi <= (nliiOO AND wire_nliiOl_w_lg_Q814w(0));
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nliiOl <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nliiOl <= nliiOO;
		END IF;
	END PROCESS;
	wire_nliiOl_w_lg_Q814w(0) <= NOT nliiOl;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nliiOO <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nliiOO <= nlil1l;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nlil0i <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN 
			IF (nliiOi = '1') THEN nlil0i <= wire_nlilii_dataout;
			END IF;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nlil0l <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN 
			IF (nliiOi = '1') THEN nlil0l <= wire_nlilil_dataout;
			END IF;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nlil1l <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nlil1l <= BITSLIP;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nlil1O <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN 
			IF (nliiOi = '1') THEN nlil1O <= wire_nlil0O_dataout;
			END IF;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nlilO <= '1';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nlilO <= wire_nliOO_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nliO1O <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN 
			IF (nliiOi = '1') THEN nliO1O <= wire_nliliO_dataout;
			END IF;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nliOi <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nliOi <= wire_nll1l_o;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nliOll <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nliOll <= (NOT ((NOT (((wire_nl1iil_w_lg_Q768w(0) OR wire_nl1iii_w_lg_Q769w(0)) OR wire_nl1i0O_w_lg_Q771w(0)) OR wire_nl1i0l_w_lg_Q773w(0))) OR (NOT ((((nl1i0l XOR nliOOO) OR (nl1i0O XOR nll11i)) OR (nl1iii XOR nll11l)) OR (nl1iil XOR nll11O)))));
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nliOlO <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nliOlO <= nliOOi;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nliOOi <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nliOOi <= nliOOl;
		END IF;
	END PROCESS;
	wire_nliOOi_w_lg_Q701w(0) <= nliOOi AND wire_w_lg_w_lg_n1ll0l693w700w(0);
	wire_nliOOi_w_lg_Q690w(0) <= nliOOi AND wire_w_lg_w_lg_n1llii682w689w(0);
	wire_nliOOi_w_lg_Q679w(0) <= nliOOi AND wire_w_lg_w_lg_n1lliO671w678w(0);
	wire_nliOOi_w_lg_Q668w(0) <= nliOOi AND wire_w_lg_w_lg_n1llll660w667w(0);
	wire_nliOOi_w_lg_Q657w(0) <= nliOOi AND wire_w_lg_w_lg_n1llOi649w656w(0);
	wire_nliOOi_w_lg_Q646w(0) <= nliOOi AND wire_w_lg_w_lg_n1llOO638w645w(0);
	wire_nliOOi_w_lg_Q635w(0) <= nliOOi AND wire_w_lg_w_lg_n1lO1l627w634w(0);
	wire_nliOOi_w_lg_Q624w(0) <= nliOOi AND wire_w_lg_w_lg_n1lOOl615w623w(0);
	wire_nliOOi_w_lg_Q617w(0) <= NOT nliOOi;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nliOOl <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nliOOl <= A1A2_SIZE;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nliOOO <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nliOOO <= nll1ii;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nll10i <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nll10i <= nliOlO;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nll10l <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN nll10l <= nll10O;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nll10O <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nll10O <= n1O0lO;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nll11i <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nll11i <= nll1il;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nll11l <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nll11l <= nll1iO;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nll11O <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nll11O <= nilii;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nll1ii <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN 
			IF (n1O0lO = '1') THEN nll1ii <= wire_w_lg_n1Oi1i50w(0);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nll1il <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN 
			IF (n1O0lO = '1') THEN nll1il <= n1Oi1l;
			END IF;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nll1iO <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN 
			IF (n1O0lO = '1') THEN nll1iO <= n1Oi1O;
			END IF;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nlllO <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN nlllO <= wire_nll1i_o;
		END IF;
	END PROCESS;
	wire_n0011i_dataout <= n1Ol0i AND n11OOl;
	wire_n0011l_dataout <= wire_n1OliO_w_lg_Q2463w(0) OR NOT(n11OOl);
	wire_n00iil_dataout <= wire_w_lg_n1lOOl615w(0) OR wire_w_lg_n1O1lO614w(0);
	wire_n00iOO_dataout <= wire_w_lg_n1lO1l627w(0) OR wire_w_lg_n1lO0l626w(0);
	wire_n00lii_dataout <= wire_w_lg_n1llOO638w(0) OR wire_w_lg_n1lO1i637w(0);
	wire_n00lOl_dataout <= wire_w_lg_n1llOi649w(0) OR wire_w_lg_n1llOl648w(0);
	wire_n00O0O_dataout <= wire_w_lg_n1llll660w(0) OR wire_w_lg_n1lllO659w(0);
	wire_n00OOi_dataout <= wire_w_lg_n1lliO671w(0) OR wire_w_lg_n1llli670w(0);
	wire_n0101i_dataout <= wire_n01iil_dataout AND NOT(n11Oli);
	wire_n0101l_dataout <= n11O1O AND NOT(n11Oli);
	wire_n0101O_dataout <= wire_w_lg_n11O1O2492w(0) AND NOT(n11Oli);
	wire_n010ii_dataout <= wire_n01iOi_o(0) AND NOT(n11Oli);
	wire_n010il_dataout <= wire_n01iOi_o(1) AND NOT(n11Oli);
	wire_n010iO_dataout <= n1Olil AND NOT(n11Oli);
	wire_n010ll_dataout <= wire_n010Oi_dataout AND NOT(wire_n0001O_w_lg_Q2461w(0));
	wire_n010lO_dataout <= wire_n010Ol_dataout AND NOT(wire_n0001O_w_lg_Q2461w(0));
	wire_n010Oi_dataout <= n11O1O AND NOT(n11O0i);
	wire_n010Ol_dataout <= wire_w_lg_n11O1O2492w(0) AND NOT(n11O0i);
	wire_n010OO_dataout <= wire_w_lg_n11O0i2491w(0) AND NOT(wire_n0001O_w_lg_Q2461w(0));
	wire_n011OO_dataout <= wire_n01iii_dataout AND NOT(n11Oli);
	wire_n01i0i_dataout <= wire_n01i0O_dataout AND NOT(wire_n0001O_w_lg_Q2461w(0));
	wire_n01i0l_dataout <= wire_n01iii_dataout AND NOT(n11O0i);
	wire_n01i0O_dataout <= wire_n01iil_dataout AND NOT(n11O0i);
	wire_n01i1i_dataout <= n11O0i AND NOT(wire_n0001O_w_lg_Q2461w(0));
	wire_n01i1O_dataout <= wire_n01i0l_dataout AND NOT(wire_n0001O_w_lg_Q2461w(0));
	wire_n01iii_dataout <= wire_n01iOi_o(0) AND NOT(n11O1O);
	wire_n01iil_dataout <= wire_n01iOi_o(1) AND NOT(n11O1O);
	wire_n01iiO_dataout <= wire_n01ill_dataout AND NOT(wire_n0001O_w_lg_Q2461w(0));
	wire_n01ili_dataout <= wire_n01ilO_dataout AND NOT(wire_n0001O_w_lg_Q2461w(0));
	wire_n01ill_dataout <= wire_n01iOi_o(0) AND NOT(n11O0i);
	wire_n01ilO_dataout <= wire_n01iOi_o(1) AND NOT(n11O0i);
	wire_n01iOl_dataout <= n1Ol0i OR wire_n0001O_w_lg_Q2461w(0);
	wire_n01iOO_dataout <= n1Olil AND NOT(wire_n0001O_w_lg_Q2461w(0));
	wire_n01l0i_dataout <= n11O0l AND NOT(n11O0O);
	wire_n01l0l_dataout <= n1Olil OR n11O0l;
	wire_n01l1i_dataout <= n1Olil WHEN n11O0O = '1'  ELSE wire_n01l0l_dataout;
	wire_n01l1l_dataout <= n1Ol0i OR n11O0O;
	wire_n01l1O_dataout <= wire_w_lg_n11O0l2479w(0) AND NOT(n11O0O);
	wire_n01lOl_dataout <= n11Oll AND NOT(n11Oli);
	wire_n01lOO_dataout <= wire_w_lg_n11Oll2469w(0) AND NOT(n11Oli);
	wire_n01O0i_dataout <= wire_n01Oii_dataout AND NOT(n11OlO);
	wire_n01O0l_dataout <= n11OOi AND NOT(n11OlO);
	wire_n01O0O_dataout <= wire_w_lg_n11Oii2466w(0) AND NOT(n11OOi);
	wire_n01O1O_dataout <= wire_n01O0O_dataout AND NOT(n11OlO);
	wire_n01Oii_dataout <= n11Oii AND NOT(n11OOi);
	wire_n01Oli_dataout <= wire_n1OliO_w_lg_Q2463w(0) WHEN n11Oli = '1'  ELSE wire_n01OlO_dataout;
	wire_n01Oll_dataout <= n1Ol0i OR n11Oli;
	wire_n01OlO_dataout <= wire_n1OliO_w_lg_Q2463w(0) OR n11Oll;
	wire_n01OOi_dataout <= wire_n1OliO_w_lg_Q2463w(0) WHEN n11OlO = '1'  ELSE wire_n01OOO_dataout;
	wire_n01OOl_dataout <= n1Ol0i OR n11OlO;
	wire_n01OOO_dataout <= wire_n1OliO_w_lg_Q2463w(0) WHEN n11OOi = '1'  ELSE n1OliO;
	wire_n0i10l_dataout <= wire_w_lg_n1llii682w(0) OR wire_w_lg_n1llil681w(0);
	wire_n0i1lO_dataout <= wire_w_lg_n1ll0l693w(0) OR wire_w_lg_n1ll0O692w(0);
	wire_n0liil_dataout <= nl1ill WHEN ((wire_nl00Ol_w_lg_w_lg_Q1266w2247w(0) OR (nl00Ol AND n1l1il)) OR (n1l1Oi AND n1l1Ol)) = '1'  ELSE (n1l1li OR n1l1iO);
	wire_n0liil_w_lg_dataout1279w(0) <= wire_n0liil_dataout AND wire_w_lg_n1l10i1278w(0);
	wire_n0liil_w_lg_dataout1271w(0) <= NOT wire_n0liil_dataout;
	wire_n0lil_dataout <= niOOi WHEN wire_w_lg_n1O0li119w(0) = '1'  ELSE wire_n0O1O_dataout;
	wire_n0liO_dataout <= niOOl WHEN wire_w_lg_n1O0li119w(0) = '1'  ELSE wire_n0O0i_dataout;
	wire_n0lli_dataout <= niOOO WHEN wire_w_lg_n1O0li119w(0) = '1'  ELSE wire_n0O0l_dataout;
	wire_n0lll_dataout <= nl11i WHEN wire_w_lg_n1O0li119w(0) = '1'  ELSE wire_n0O0O_dataout;
	wire_n0llO_dataout <= nl11l WHEN wire_w_lg_n1O0li119w(0) = '1'  ELSE wire_n0Oii_dataout;
	wire_n0lOi_dataout <= nl11O WHEN wire_w_lg_n1O0li119w(0) = '1'  ELSE wire_n0Oil_dataout;
	wire_n0lOl_dataout <= nl10i WHEN wire_w_lg_n1O0li119w(0) = '1'  ELSE wire_n0OiO_dataout;
	wire_n0lOO_dataout <= wire_n0Oli_dataout AND NOT(wire_w_lg_n1O0li119w(0));
	wire_n0O0i_dataout <= niOOl AND NOT(wire_w_lg_n1O0ll117w(0));
	wire_n0O0l_dataout <= niOOO AND NOT(wire_w_lg_n1O0ll117w(0));
	wire_n0O0O_dataout <= nl11i AND NOT(wire_w_lg_n1O0ll117w(0));
	wire_n0O1i_dataout <= wire_n0Oll_dataout AND NOT(wire_w_lg_n1O0li119w(0));
	wire_n0O1l_dataout <= wire_n0OlO_dataout AND NOT(wire_w_lg_n1O0li119w(0));
	wire_n0O1O_dataout <= niOOi AND NOT(wire_w_lg_n1O0ll117w(0));
	wire_n0Oii_dataout <= nl11l AND NOT(wire_w_lg_n1O0ll117w(0));
	wire_n0Oil_dataout <= nl11O AND NOT(wire_w_lg_n1O0ll117w(0));
	wire_n0OiO_dataout <= nl10i AND NOT(wire_w_lg_n1O0ll117w(0));
	wire_n0Oli_dataout <= nl10l AND NOT(wire_w_lg_n1O0ll117w(0));
	wire_n0Oll_dataout <= nl10O AND NOT(wire_w_lg_n1O0ll117w(0));
	wire_n0OlO_dataout <= nl1ii AND NOT(wire_w_lg_n1O0ll117w(0));
	wire_n0OOi_dataout <= nl10l WHEN wire_w_lg_n1O0li119w(0) = '1'  ELSE wire_n0Oli_dataout;
	wire_n0OOl_dataout <= wire_n0OOO_dataout AND NOT(wire_w_lg_n1O0li119w(0));
	wire_n0OOO_dataout <= nl1il AND NOT(wire_w_lg_n1O0ll117w(0));
	wire_n1Olli_dataout <= encdet_prbs WHEN n0000i = '1'  ELSE wire_n1Olll_dataout;
	wire_n1Olll_dataout <= wire_n1OllO_dataout WHEN SYNC_SM_DIS = '1'  ELSE n1Ol0O;
	wire_n1OllO_dataout <= wire_nliOl_o WHEN PMADATAWIDTH = '1'  ELSE n0000O;
	wire_ni000i_dataout <= nii1lO AND ni1O0i;
	wire_ni000l_dataout <= wire_ni0lii_dataout AND ni0lli;
	wire_ni000O_dataout <= wire_ni0lil_dataout AND ni0lli;
	wire_ni00i_dataout <= nl1Oi AND NOT(wire_w_lg_n1O0li119w(0));
	wire_ni00l_dataout <= wire_ni00O_dataout AND NOT(wire_w_lg_n1O0li119w(0));
	wire_ni00O_dataout <= nl1OO AND NOT(wire_w_lg_n1O0ll117w(0));
	wire_ni00Ol_dataout <= niil1l AND NOT(n100OO);
	wire_ni00OO_dataout <= niil1O AND NOT(n100OO);
	wire_ni010i_dataout <= ni1Oli AND n100ii;
	wire_ni010l_dataout <= ni1Oll AND n100ii;
	wire_ni010O_dataout <= ni1OlO AND n100ii;
	wire_ni011i_dataout <= wire_ni011l_o(3) WHEN wire_ni011O_o(4) = '1'  ELSE wire_ni01ii_dataout;
	wire_ni01i_dataout <= nl1lO AND NOT(wire_w_lg_n1O0li119w(0));
	wire_ni01ii_dataout <= ni0liO AND n100ii;
	wire_ni01l_dataout <= wire_ni01O_dataout AND NOT(wire_w_lg_n1O0li119w(0));
	wire_ni01O_dataout <= nl1Ol AND NOT(wire_w_lg_n1O0ll117w(0));
	wire_ni0i0i_dataout <= wire_ni0i0O_dataout AND NOT(wire_nii1lO_w_lg_Q1765w(0));
	wire_ni0i0l_dataout <= wire_ni0iii_dataout AND NOT(wire_nii1lO_w_lg_Q1765w(0));
	wire_ni0i0O_dataout <= n100Oi AND NOT(n100Ol);
	wire_ni0i1i_dataout <= niil0i AND NOT(n100OO);
	wire_ni0i1l_dataout <= niil0l AND NOT(n100OO);
	wire_ni0i1O_dataout <= n100Ol AND NOT(wire_nii1lO_w_lg_Q1765w(0));
	wire_ni0ii_dataout <= nl1Ol AND NOT(wire_w_lg_n1O0li119w(0));
	wire_ni0iii_dataout <= wire_w_lg_n100Oi1903w(0) AND NOT(n100Ol);
	wire_ni0il_dataout <= wire_ni0iO_dataout AND NOT(wire_w_lg_n1O0li119w(0));
	wire_ni0ili_dataout <= nil11i AND NOT(n100OO);
	wire_ni0ill_dataout <= nil11l AND NOT(n100OO);
	wire_ni0ilO_dataout <= nil11O AND NOT(n100OO);
	wire_ni0iO_dataout <= nl1iiO AND NOT(wire_w_lg_n1O0ll117w(0));
	wire_ni0iOi_dataout <= nil10i AND NOT(n100OO);
	wire_ni0iOO_dataout <= n10i1l AND NOT(wire_nii1lO_w_lg_Q1765w(0));
	wire_ni0l0i_dataout <= wire_w_lg_n10i1i1898w(0) AND NOT(n10i1l);
	wire_ni0l1i_dataout <= wire_ni0l1O_dataout AND NOT(wire_nii1lO_w_lg_Q1765w(0));
	wire_ni0l1l_dataout <= wire_ni0l0i_dataout AND NOT(wire_nii1lO_w_lg_Q1765w(0));
	wire_ni0l1O_dataout <= n10i1i AND NOT(n10i1l);
	wire_ni0li_dataout <= wire_w_lg_w_SYNC_COMP_PAT_range157w158w(0) WHEN wire_w_lg_n1O0li119w(0) = '1'  ELSE wire_nii0l_dataout;
	wire_ni0lii_dataout <= niiiOO AND NOT(wire_nii1lO_w_lg_Q1765w(0));
	wire_ni0lil_dataout <= wire_niiiOO_w_lg_Q1894w(0) AND NOT(wire_nii1lO_w_lg_Q1765w(0));
	wire_ni0ll_dataout <= wire_w_lg_w_SYNC_COMP_PAT_range155w156w(0) WHEN wire_w_lg_n1O0li119w(0) = '1'  ELSE wire_nii0O_dataout;
	wire_ni0lO_dataout <= wire_w_lg_w_SYNC_COMP_PAT_range152w153w(0) WHEN wire_w_lg_n1O0li119w(0) = '1'  ELSE wire_niiii_dataout;
	wire_ni0O0i_dataout <= RUNDISP_SEL(1) WHEN PMADATAWIDTH = '1'  ELSE wire_ni0OiO_o(1);
	wire_ni0O0l_dataout <= RUNDISP_SEL(2) WHEN PMADATAWIDTH = '1'  ELSE wire_ni0OiO_o(2);
	wire_ni0O0O_dataout <= RUNDISP_SEL(3) WHEN PMADATAWIDTH = '1'  ELSE wire_ni0OiO_o(3);
	wire_ni0O1i_dataout <= RUNDISP_SEL(0) AND NOT(PMADATAWIDTH);
	wire_ni0O1i_w_lg_dataout1761w(0) <= NOT wire_ni0O1i_dataout;
	wire_ni0O1l_dataout <= RUNDISP_SEL(1) AND NOT(PMADATAWIDTH);
	wire_ni0O1O_dataout <= RUNDISP_SEL(0) WHEN PMADATAWIDTH = '1'  ELSE wire_ni0OiO_o(0);
	wire_ni0O1O_w_lg_dataout1757w(0) <= NOT wire_ni0O1O_dataout;
	wire_ni0Oi_dataout <= wire_w_lg_w_SYNC_COMP_PAT_range149w150w(0) WHEN wire_w_lg_n1O0li119w(0) = '1'  ELSE wire_niiil_dataout;
	wire_ni0Oii_dataout <= RUNDISP_SEL(4) WHEN PMADATAWIDTH = '1'  ELSE wire_ni0OiO_o(4);
	wire_ni0Oil_dataout <= wire_w_lg_n10i1O1872w(0) WHEN PMADATAWIDTH = '1'  ELSE wire_ni0OiO_o(5);
	wire_ni0Oil_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_dataout1753w1754w1755w1756w1758w1759w(0) <= wire_ni0Oil_w_lg_w_lg_w_lg_w_lg_w_lg_dataout1753w1754w1755w1756w1758w(0) OR wire_ni0O1l_dataout;
	wire_ni0Oil_w_lg_w_lg_w_lg_w_lg_w_lg_dataout1753w1754w1755w1756w1758w(0) <= wire_ni0Oil_w_lg_w_lg_w_lg_w_lg_dataout1753w1754w1755w1756w(0) OR wire_ni0O1O_w_lg_dataout1757w(0);
	wire_ni0Oil_w_lg_w_lg_w_lg_w_lg_dataout1753w1754w1755w1756w(0) <= wire_ni0Oil_w_lg_w_lg_w_lg_dataout1753w1754w1755w(0) OR wire_ni0O0i_dataout;
	wire_ni0Oil_w_lg_w_lg_w_lg_dataout1753w1754w1755w(0) <= wire_ni0Oil_w_lg_w_lg_dataout1753w1754w(0) OR wire_ni0O0l_dataout;
	wire_ni0Oil_w_lg_w_lg_dataout1753w1754w(0) <= wire_ni0Oil_w_lg_dataout1753w(0) OR wire_ni0O0O_dataout;
	wire_ni0Oil_w_lg_dataout1753w(0) <= wire_ni0Oil_dataout OR wire_ni0Oii_dataout;
	wire_ni0Ol_dataout <= wire_w_lg_w_SYNC_COMP_PAT_range146w147w(0) WHEN wire_w_lg_n1O0li119w(0) = '1'  ELSE wire_niiiO_dataout;
	wire_ni0OO_dataout <= wire_w_lg_w_SYNC_COMP_PAT_range143w144w(0) WHEN wire_w_lg_n1O0li119w(0) = '1'  ELSE wire_niili_dataout;
	wire_ni10i_dataout <= nl1il AND NOT(wire_w_lg_n1O0li119w(0));
	wire_ni10l_dataout <= wire_ni10O_dataout AND NOT(wire_w_lg_n1O0li119w(0));
	wire_ni10O_dataout <= nl1li AND NOT(wire_w_lg_n1O0ll117w(0));
	wire_ni11i_dataout <= nl1ii AND NOT(wire_w_lg_n1O0li119w(0));
	wire_ni11l_dataout <= wire_ni11O_dataout AND NOT(wire_w_lg_n1O0li119w(0));
	wire_ni11O_dataout <= nl1iO AND NOT(wire_w_lg_n1O0ll117w(0));
	wire_ni11Oi_dataout <= wire_n0liil_dataout WHEN (n1l11O AND 
		(nl0i1O XOR nl0i1l)) = '1'  ELSE (n1l10l OR n1l10i);
	wire_ni1ii_dataout <= nl1iO AND NOT(wire_w_lg_n1O0li119w(0));
	wire_ni1il_dataout <= wire_ni1iO_dataout AND NOT(wire_w_lg_n1O0li119w(0));
	wire_ni1iO_dataout <= nl1ll AND NOT(wire_w_lg_n1O0ll117w(0));
	wire_ni1li_dataout <= nl1li AND NOT(wire_w_lg_n1O0li119w(0));
	wire_ni1ll_dataout <= wire_ni1lO_dataout AND NOT(wire_w_lg_n1O0li119w(0));
	wire_ni1lO_dataout <= nl1lO AND NOT(wire_w_lg_n1O0ll117w(0));
	wire_ni1Oi_dataout <= nl1ll AND NOT(wire_w_lg_n1O0li119w(0));
	wire_ni1Ol_dataout <= wire_ni1OO_dataout AND NOT(wire_w_lg_n1O0li119w(0));
	wire_ni1OO_dataout <= nl1Oi AND NOT(wire_w_lg_n1O0ll117w(0));
	wire_ni1OOi_dataout <= wire_ni011l_o(0) WHEN wire_ni011O_o(4) = '1'  ELSE wire_ni010i_dataout;
	wire_ni1OOl_dataout <= wire_ni011l_o(1) WHEN wire_ni011O_o(4) = '1'  ELSE wire_ni010l_dataout;
	wire_ni1OOO_dataout <= wire_ni011l_o(2) WHEN wire_ni011O_o(4) = '1'  ELSE wire_ni010O_dataout;
	wire_nii0i_dataout <= wire_niiOl_dataout AND NOT(wire_w_lg_n1O0li119w(0));
	wire_nii0l_dataout <= SYNC_COMP_PAT(8) WHEN wire_w_lg_n1O0ll117w(0) = '1'  ELSE wire_w_lg_w_SYNC_COMP_PAT_range157w158w(0);
	wire_nii0O_dataout <= SYNC_COMP_PAT(9) WHEN wire_w_lg_n1O0ll117w(0) = '1'  ELSE wire_w_lg_w_SYNC_COMP_PAT_range155w156w(0);
	wire_nii10i_dataout <= nii11l AND nii1lO;
	wire_nii10l_dataout <= nii11O AND nii1lO;
	wire_nii10O_dataout <= n1OiOO AND nii1lO;
	wire_nii1i_dataout <= wire_w_lg_w_SYNC_COMP_PAT_range140w141w(0) WHEN wire_w_lg_n1O0li119w(0) = '1'  ELSE wire_niill_dataout;
	wire_nii1ii_dataout <= wire_nii1il_o AND nii1lO;
	wire_nii1l_dataout <= wire_niilO_dataout AND NOT(wire_w_lg_n1O0li119w(0));
	wire_nii1O_dataout <= wire_niiOi_dataout AND NOT(wire_w_lg_n1O0li119w(0));
	wire_niiii_dataout <= SYNC_COMP_PAT(10) WHEN wire_w_lg_n1O0ll117w(0) = '1'  ELSE wire_w_lg_w_SYNC_COMP_PAT_range152w153w(0);
	wire_niiil_dataout <= SYNC_COMP_PAT(11) WHEN wire_w_lg_n1O0ll117w(0) = '1'  ELSE wire_w_lg_w_SYNC_COMP_PAT_range149w150w(0);
	wire_niiili_dataout <= wire_w_lg_n10i0l1764w(0) WHEN PMADATAWIDTH = '1'  ELSE wire_w_lg_n10i0i1763w(0);
	wire_niiili_w_lg_dataout1771w(0) <= NOT wire_niiili_dataout;
	wire_niiiO_dataout <= SYNC_COMP_PAT(12) WHEN wire_w_lg_n1O0ll117w(0) = '1'  ELSE wire_w_lg_w_SYNC_COMP_PAT_range146w147w(0);
	wire_niili_dataout <= SYNC_COMP_PAT(13) WHEN wire_w_lg_n1O0ll117w(0) = '1'  ELSE wire_w_lg_w_SYNC_COMP_PAT_range143w144w(0);
	wire_niill_dataout <= SYNC_COMP_PAT(14) WHEN wire_w_lg_n1O0ll117w(0) = '1'  ELSE wire_w_lg_w_SYNC_COMP_PAT_range140w141w(0);
	wire_niilO_dataout <= SYNC_COMP_PAT(15) WHEN wire_w_lg_n1O0ll117w(0) = '1'  ELSE wire_w_lg_w_SYNC_COMP_PAT_range120w138w(0);
	wire_niilOi_dataout <= (wire_w_lg_n10ilO1740w(0) OR (wire_w_lg_n10ill1741w(0) OR (wire_w_lg_n10ili1742w(0) OR (wire_w_lg_n10iiO1743w(0) OR (wire_w_lg_n10iil1744w(0) OR (wire_w_lg_n10iii1745w(0) OR wire_w_lg_n10i0O1746w(0))))))) AND nii1lO;
	wire_niilOl_dataout <= n1iilO AND nii1lO;
	wire_niilOO_dataout <= (wire_w_lg_w_lg_PMADATAWIDTH115w1738w(0) OR (PMADATAWIDTH AND n1i0Oi)) AND nii1lO;
	wire_niiO0i_dataout <= (wire_w_lg_n1i0il1728w(0) OR (NOT ((n1i0il OR wire_w_lg_n1i0Oi1729w(0)) OR n1i1OO))) AND nii1lO;
	wire_niiO0l_dataout <= niilli AND nii1lO;
	wire_niiO0O_dataout <= niilll AND nii1lO;
	wire_niiO1i_dataout <= n10l0l AND nii1lO;
	wire_niiO1l_dataout <= n10l0O AND nii1lO;
	wire_niiO1O_dataout <= (((wire_w_lg_n10lOi1671w(0) OR wire_w_lg_n10llO1673w(0)) OR wire_w_lg_n10lll1681w(0)) OR wire_w_lg_n10lli1736w(0)) AND nii1lO;
	wire_niiOi_dataout <= wire_w_lg_w_SYNC_COMP_PAT_range118w137w(0) AND NOT(wire_w_lg_n1O0ll117w(0));
	wire_niiOii_dataout <= niillO AND nii1lO;
	wire_niiOil_dataout <= niiOOi AND nii1lO;
	wire_niiOiO_dataout <= n10lOO AND nii1lO;
	wire_niiOl_dataout <= wire_w_lg_w_SYNC_COMP_PAT_range116w136w(0) AND NOT(wire_w_lg_n1O0ll117w(0));
	wire_niiOli_dataout <= n10O1i AND nii1lO;
	wire_niiOll_dataout <= (((wire_w_lg_n10Oil1625w(0) OR wire_w_lg_n10Oii1627w(0)) OR wire_w_lg_n10O0O1635w(0)) OR wire_w_lg_n10O0l1726w(0)) AND nii1lO;
	wire_niiOlO_dataout <= (wire_w_lg_n1i0il1719w(0) OR (NOT (wire_w_lg_n1i0il1596w(0) OR wire_w_lg_n1i0lO1720w(0)))) AND nii1lO;
	wire_nil00i_dataout <= nil1li AND nii1lO;
	wire_nil00l_dataout <= nil1ll AND nii1lO;
	wire_nil00O_dataout <= ni1O0l AND nii1lO;
	wire_nil01i_dataout <= (((wire_w_lg_n1i11O1579w(0) OR wire_w_lg_n1i11l1581w(0)) OR wire_w_lg_n1i11i1589w(0)) OR wire_w_lg_n10OOO1702w(0)) AND nii1lO;
	wire_nil01l_dataout <= (wire_w_lg_n1il0O1695w(0) OR (NOT ((n1il0O OR n1illl) OR n1iiOi))) AND nii1lO;
	wire_nil01O_dataout <= nil1iO AND nii1lO;
	wire_nil0i_dataout <= wire_nil0O_dataout AND NOT(wire_w_lg_n1O0li119w(0));
	wire_nil0ii_dataout <= n1i10l AND nii1lO;
	wire_nil0il_dataout <= n1i10O AND nii1lO;
	wire_nil0iO_dataout <= (((wire_w_lg_n1i1Oi1534w(0) OR wire_w_lg_n1i1lO1536w(0)) OR wire_w_lg_n1i1ll1544w(0)) OR wire_w_lg_n1i1li1693w(0)) AND nii1lO;
	wire_nil0l_dataout <= SYNC_COMP_PAT(8) AND NOT(wire_w_lg_n1O0ll117w(0));
	wire_nil0li_dataout <= (wire_w_lg_n1il0O1686w(0) OR (NOT (wire_w_lg_n1il0O1507w(0) OR wire_w_lg_n1illi1687w(0)))) AND nii1lO;
	wire_nil0O_dataout <= SYNC_COMP_PAT(9) AND NOT(wire_w_lg_n1O0ll117w(0));
	wire_nil1l_dataout <= SYNC_COMP_PAT(7) AND NOT(wire_w_lg_n1O0li119w(0));
	wire_nil1lO_dataout <= (wire_w_lg_n10l0i1706w(0) OR (wire_w_lg_n10l1O1707w(0) OR (wire_w_lg_n10l1l1708w(0) OR (wire_w_lg_n10l1i1709w(0) OR (wire_w_lg_n10iOO1710w(0) OR (wire_w_lg_n10iOl1711w(0) OR wire_w_lg_n10iOi1712w(0))))))) AND nii1lO;
	wire_nil1O_dataout <= wire_nil0l_dataout AND NOT(wire_w_lg_n1O0li119w(0));
	wire_nil1Oi_dataout <= (wire_w_lg_w_lg_PMADATAWIDTH115w1704w(0) OR wire_w_lg_PMADATAWIDTH1411w(0)) AND nii1lO;
	wire_nil1Ol_dataout <= n10Oli AND nii1lO;
	wire_nil1OO_dataout <= n10Oll AND nii1lO;
	wire_nl00i_dataout <= nl10i WHEN wire_w_lg_PMADATAWIDTH115w(0) = '1'  ELSE nl11l;
	wire_nl00l_dataout <= nl10l WHEN wire_w_lg_PMADATAWIDTH115w(0) = '1'  ELSE nl11O;
	wire_nl00O_dataout <= nl10O WHEN wire_w_lg_PMADATAWIDTH115w(0) = '1'  ELSE nl10i;
	wire_nl01i_dataout <= nl11i WHEN wire_w_lg_PMADATAWIDTH115w(0) = '1'  ELSE niOOl;
	wire_nl01l_dataout <= nl11l WHEN wire_w_lg_PMADATAWIDTH115w(0) = '1'  ELSE niOOO;
	wire_nl01O_dataout <= nl11O WHEN wire_w_lg_PMADATAWIDTH115w(0) = '1'  ELSE nl11i;
	wire_nl0ii_dataout <= nl1ii WHEN wire_w_lg_PMADATAWIDTH115w(0) = '1'  ELSE nl10l;
	wire_nl0il_dataout <= nl1il WHEN wire_w_lg_PMADATAWIDTH115w(0) = '1'  ELSE nl10O;
	wire_nl0iO_dataout <= nl1iO WHEN wire_w_lg_PMADATAWIDTH115w(0) = '1'  ELSE nl1ii;
	wire_nl0iOl_dataout <= SYNC_COMP_PAT(0) WHEN n1l00l = '1'  ELSE wire_nl0liO_dataout;
	wire_nl0iOO_dataout <= SYNC_COMP_PAT(1) WHEN n1l00l = '1'  ELSE wire_nl0lli_dataout;
	wire_nl0l0i_dataout <= SYNC_COMP_PAT(5) WHEN n1l00l = '1'  ELSE wire_nl0lOl_dataout;
	wire_nl0l0l_dataout <= SYNC_COMP_PAT(6) WHEN n1l00l = '1'  ELSE wire_nl0lOO_dataout;
	wire_nl0l0O_dataout <= SYNC_COMP_PAT(7) WHEN n1l00l = '1'  ELSE wire_nl0O1i_dataout;
	wire_nl0l1i_dataout <= SYNC_COMP_PAT(2) WHEN n1l00l = '1'  ELSE wire_nl0lll_dataout;
	wire_nl0l1l_dataout <= SYNC_COMP_PAT(3) WHEN n1l00l = '1'  ELSE wire_nl0llO_dataout;
	wire_nl0l1O_dataout <= SYNC_COMP_PAT(4) WHEN n1l00l = '1'  ELSE wire_nl0lOi_dataout;
	wire_nl0li_dataout <= nl1li WHEN wire_w_lg_PMADATAWIDTH115w(0) = '1'  ELSE nl1il;
	wire_nl0lii_dataout <= nl001i WHEN n1l00l = '1'  ELSE wire_nl0O1l_dataout;
	wire_nl0lil_dataout <= wire_nl0O1O_dataout AND NOT(n1l00l);
	wire_nl0liO_dataout <= nl01il WHEN n1l00i = '1'  ELSE nl00ll;
	wire_nl0ll_dataout <= nl1ll WHEN wire_w_lg_PMADATAWIDTH115w(0) = '1'  ELSE nl1iO;
	wire_nl0lli_dataout <= nl01iO WHEN n1l00i = '1'  ELSE nl00lO;
	wire_nl0lll_dataout <= nl01li WHEN n1l00i = '1'  ELSE nl00Oi;
	wire_nl0llO_dataout <= nl01ll WHEN n1l00i = '1'  ELSE nl00Ol;
	wire_nl0lO_dataout <= nl1lO WHEN wire_w_lg_PMADATAWIDTH115w(0) = '1'  ELSE nl1li;
	wire_nl0lOi_dataout <= nl01lO WHEN n1l00i = '1'  ELSE nl00OO;
	wire_nl0lOl_dataout <= nl01Oi WHEN n1l00i = '1'  ELSE nl0i1i;
	wire_nl0lOO_dataout <= nl01Ol WHEN n1l00i = '1'  ELSE nl0i1l;
	wire_nl0O1i_dataout <= nl01OO WHEN n1l00i = '1'  ELSE nl0i1O;
	wire_nl0O1l_dataout <= nl001i WHEN n1l00i = '1'  ELSE nl0i0i;
	wire_nl0O1O_dataout <= nli1ll AND NOT(n1l00i);
	wire_nl0Oi_dataout <= nl1Oi WHEN wire_w_lg_PMADATAWIDTH115w(0) = '1'  ELSE nl1ll;
	wire_nl0Oil_dataout <= SYNC_COMP_PAT(0) WHEN n1l00O = '1'  ELSE nl001l;
	wire_nl0OiO_dataout <= SYNC_COMP_PAT(1) WHEN n1l00O = '1'  ELSE nl001O;
	wire_nl0Ol_dataout <= nl1Ol WHEN wire_w_lg_PMADATAWIDTH115w(0) = '1'  ELSE nl1lO;
	wire_nl0Oli_dataout <= SYNC_COMP_PAT(2) WHEN n1l00O = '1'  ELSE nl000i;
	wire_nl0Oll_dataout <= SYNC_COMP_PAT(3) WHEN n1l00O = '1'  ELSE nl000l;
	wire_nl0OlO_dataout <= SYNC_COMP_PAT(4) WHEN n1l00O = '1'  ELSE nl000O;
	wire_nl0OO_dataout <= nl1OO WHEN wire_w_lg_PMADATAWIDTH115w(0) = '1'  ELSE nl1Oi;
	wire_nl0OOi_dataout <= SYNC_COMP_PAT(5) WHEN n1l00O = '1'  ELSE nl00ii;
	wire_nl0OOl_dataout <= SYNC_COMP_PAT(6) WHEN n1l00O = '1'  ELSE nl00il;
	wire_nl0OOO_dataout <= SYNC_COMP_PAT(7) WHEN n1l00O = '1'  ELSE nl00iO;
	wire_nli0i_dataout <= PUDR(2) WHEN LP10BEN = '1'  ELSE PUDI(2);
	wire_nli0l_dataout <= PUDR(3) WHEN LP10BEN = '1'  ELSE PUDI(3);
	wire_nli0O_dataout <= PUDR(4) WHEN LP10BEN = '1'  ELSE PUDI(4);
	wire_nli1i_dataout <= nl1iiO WHEN wire_w_lg_PMADATAWIDTH115w(0) = '1'  ELSE nl1Ol;
	wire_nli1l_dataout <= PUDR(0) WHEN LP10BEN = '1'  ELSE PUDI(0);
	wire_nli1O_dataout <= PUDR(1) WHEN LP10BEN = '1'  ELSE PUDI(1);
	wire_nliii_dataout <= PUDR(5) WHEN LP10BEN = '1'  ELSE PUDI(5);
	wire_nliil_dataout <= PUDR(6) WHEN LP10BEN = '1'  ELSE PUDI(6);
	wire_nliiO_dataout <= PUDR(7) WHEN LP10BEN = '1'  ELSE PUDI(7);
	wire_nlil0O_dataout <= wire_nlilli_dataout OR n1li0i;
	wire_nlili_dataout <= PUDR(8) WHEN LP10BEN = '1'  ELSE PUDI(8);
	wire_nlilii_dataout <= wire_nlilll_dataout AND NOT(n1li0i);
	wire_nlilil_dataout <= wire_nlillO_dataout AND NOT(n1li0i);
	wire_nliliO_dataout <= wire_nlilOi_dataout OR n1li0i;
	wire_nlill_dataout <= PUDR(9) WHEN LP10BEN = '1'  ELSE PUDI(9);
	wire_nlilli_dataout <= wire_nlilOl_o(1) OR n1li1O;
	wire_nlilll_dataout <= wire_nlilOl_o(2) OR n1li1O;
	wire_nlillO_dataout <= wire_nlilOl_o(3) OR n1li1O;
	wire_nlilOi_dataout <= wire_nlilOl_o(4) AND NOT(n1li1O);
	wire_nll0i_dataout <= wire_w_lg_n1Oi0l59w(0) AND NOT(n1O0Oi);
	wire_nll0l_dataout <= n1Oi0l AND NOT(n1O0Oi);
	wire_nll0ll_dataout <= nlil1O WHEN AUTOBYTEALIGN_DIS = '1'  ELSE nll1ii;
	wire_nll0lO_dataout <= nlil0i WHEN AUTOBYTEALIGN_DIS = '1'  ELSE nll1il;
	wire_nll0O_dataout <= n1O0Oi OR n1Oi0l;
	wire_nll0Oi_dataout <= nlil0l WHEN AUTOBYTEALIGN_DIS = '1'  ELSE nll1iO;
	wire_nll0Ol_dataout <= nliO1O WHEN AUTOBYTEALIGN_DIS = '1'  ELSE nilii;
	wire_nll0OO_dataout <= (wire_w_lg_n1ll1i706w(0) OR 
		wire_w_lg_n1ll1l707w(0)) AND NOT(PMADATAWIDTH);
	wire_nll0OO_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_dataout711w714w717w720w723w726w729w732w(0) <= wire_nll0OO_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_dataout711w714w717w720w723w726w729w(0) OR wire_nlllii_dataout;
	wire_nll0OO_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_dataout711w714w717w720w723w726w729w(0) <= wire_nll0OO_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_dataout711w714w717w720w723w726w(0) OR wire_nlll0i_dataout;
	wire_nll0OO_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_dataout711w714w717w720w723w726w(0) <= wire_nll0OO_w_lg_w_lg_w_lg_w_lg_w_lg_dataout711w714w717w720w723w(0) OR wire_nlll1i_dataout;
	wire_nll0OO_w_lg_w_lg_w_lg_w_lg_w_lg_dataout711w714w717w720w723w(0) <= wire_nll0OO_w_lg_w_lg_w_lg_w_lg_dataout711w714w717w720w(0) OR wire_nlliOi_dataout;
	wire_nll0OO_w_lg_w_lg_w_lg_w_lg_dataout711w714w717w720w(0) <= wire_nll0OO_w_lg_w_lg_w_lg_dataout711w714w717w(0) OR wire_nllili_dataout;
	wire_nll0OO_w_lg_w_lg_w_lg_dataout711w714w717w(0) <= wire_nll0OO_w_lg_w_lg_dataout711w714w(0) OR wire_nlliii_dataout;
	wire_nll0OO_w_lg_w_lg_dataout711w714w(0) <= wire_nll0OO_w_lg_dataout711w(0) OR wire_nlli0i_dataout;
	wire_nll0OO_w_lg_dataout736w(0) <= wire_nll0OO_dataout OR wire_w_lg_n1liOO735w(0);
	wire_nll0OO_w_lg_dataout711w(0) <= wire_nll0OO_dataout OR wire_nlli1l_dataout;
	wire_nll1O_dataout <= n1Oi0l OR n1O0Oi;
	wire_nlli0i_dataout <= ((wire_nliOOi_w_lg_Q617w(0) AND wire_w_lg_w_lg_n1ll0l693w695w(0)) OR wire_nliOOi_w_lg_Q701w(0)) WHEN PMADATAWIDTH = '1'  ELSE (wire_w_lg_n1ll0O692w(0) OR wire_w_lg_n1ll0l693w(0));
	wire_nlli0i_w_lg_dataout712w(0) <= NOT wire_nlli0i_dataout;
	wire_nlli1l_dataout <= (wire_w_lg_n1ll1O703w(0) OR wire_w_lg_n1ll0i704w(0)) AND NOT(PMADATAWIDTH);
	wire_nlli1l_w_lg_dataout709w(0) <= NOT wire_nlli1l_dataout;
	wire_nllii_dataout <= wire_w_lg_n1O0Oi58w(0) AND NOT(n1Oi0l);
	wire_nlliii_dataout <= ((wire_nliOOi_w_lg_Q617w(0) AND wire_w_lg_w_lg_n1llii682w684w(0)) OR wire_nliOOi_w_lg_Q690w(0)) WHEN PMADATAWIDTH = '1'  ELSE (wire_w_lg_n1llil681w(0) OR wire_w_lg_n1llii682w(0));
	wire_nlliii_w_lg_dataout715w(0) <= NOT wire_nlliii_dataout;
	wire_nllil_dataout <= n1O0Oi AND NOT(n1Oi0l);
	wire_nllili_dataout <= ((wire_nliOOi_w_lg_Q617w(0) AND wire_w_lg_w_lg_n1lliO671w673w(0)) OR wire_nliOOi_w_lg_Q679w(0)) WHEN PMADATAWIDTH = '1'  ELSE (wire_w_lg_n1llli670w(0) OR wire_w_lg_n1lliO671w(0));
	wire_nllili_w_lg_dataout718w(0) <= NOT wire_nllili_dataout;
	wire_nlliOi_dataout <= ((wire_nliOOi_w_lg_Q617w(0) AND wire_w_lg_w_lg_n1llll660w662w(0)) OR wire_nliOOi_w_lg_Q668w(0)) WHEN PMADATAWIDTH = '1'  ELSE (wire_w_lg_n1lllO659w(0) OR wire_w_lg_n1llll660w(0));
	wire_nlliOi_w_lg_dataout721w(0) <= NOT wire_nlliOi_dataout;
	wire_nlll0i_dataout <= ((wire_nliOOi_w_lg_Q617w(0) AND wire_w_lg_w_lg_n1llOO638w640w(0)) OR wire_nliOOi_w_lg_Q646w(0)) WHEN PMADATAWIDTH = '1'  ELSE (wire_w_lg_n1lO1i637w(0) OR wire_w_lg_n1llOO638w(0));
	wire_nlll0i_w_lg_dataout727w(0) <= NOT wire_nlll0i_dataout;
	wire_nlll1i_dataout <= ((wire_nliOOi_w_lg_Q617w(0) AND wire_w_lg_w_lg_n1llOi649w651w(0)) OR wire_nliOOi_w_lg_Q657w(0)) WHEN PMADATAWIDTH = '1'  ELSE (wire_w_lg_n1llOl648w(0) OR wire_w_lg_n1llOi649w(0));
	wire_nlll1i_w_lg_dataout724w(0) <= NOT wire_nlll1i_dataout;
	wire_nlllii_dataout <= ((wire_nliOOi_w_lg_Q617w(0) AND wire_w_lg_w_lg_n1lO1l627w629w(0)) OR wire_nliOOi_w_lg_Q635w(0)) WHEN PMADATAWIDTH = '1'  ELSE (wire_w_lg_n1lO0l626w(0) OR wire_w_lg_n1lO1l627w(0));
	wire_nlllii_w_lg_dataout730w(0) <= NOT wire_nlllii_dataout;
	wire_nlllli_dataout <= ((wire_nliOOi_w_lg_Q617w(0) AND wire_w_lg_w_lg_n1lOOl615w618w(0)) OR wire_nliOOi_w_lg_Q624w(0)) WHEN PMADATAWIDTH = '1'  ELSE (wire_w_lg_n1O1lO614w(0) OR wire_w_lg_n1lOOl615w(0));
	wire_nlllli_w_lg_dataout733w(0) <= NOT wire_nlllli_dataout;
	wire_n01iOi_a <= ( n0010i & n1OlOi);
	wire_n01iOi_b <= ( "0" & "1");
	n01iOi :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 2,
		width_b => 2,
		width_o => 2
	  )
	  PORT MAP ( 
		a => wire_n01iOi_a,
		b => wire_n01iOi_b,
		cin => wire_gnd,
		o => wire_n01iOi_o
	  );
	wire_ni011l_a <= ( wire_ni01ii_dataout & wire_ni010O_dataout & wire_ni010l_dataout & wire_ni010i_dataout);
	wire_ni011l_b <= ( "0" & "0" & "0" & "1");
	ni011l :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 4,
		width_b => 4,
		width_o => 4
	  )
	  PORT MAP ( 
		a => wire_ni011l_a,
		b => wire_ni011l_b,
		cin => wire_gnd,
		o => wire_ni011l_o
	  );
	wire_ni011O_a <= ( "0" & wire_ni001i_o & wire_ni01OO_o & wire_ni01Ol_o & wire_ni01Oi_o);
	wire_ni011O_b <= ( "0" & wire_ni01lO_o & wire_ni01ll_o & wire_ni01li_o & wire_ni01iO_o);
	ni011O :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 5,
		width_b => 5,
		width_o => 5
	  )
	  PORT MAP ( 
		a => wire_ni011O_a,
		b => wire_ni011O_b,
		cin => wire_gnd,
		o => wire_ni011O_o
	  );
	wire_ni0OiO_a <= ( "0" & "0" & wire_w_lg_n10i1O1872w & RUNDISP_SEL(4 DOWNTO 2));
	wire_ni0OiO_b <= ( wire_w_lg_n10i1O1872w & RUNDISP_SEL(4 DOWNTO 0));
	ni0OiO :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 6,
		width_b => 6,
		width_o => 6
	  )
	  PORT MAP ( 
		a => wire_ni0OiO_a,
		b => wire_ni0OiO_b,
		cin => wire_gnd,
		o => wire_ni0OiO_o
	  );
	wire_nlilOl_a <= ( nliO1O & nlil0l & nlil0i & nlil1O & "1");
	wire_nlilOl_b <= ( "1" & "1" & "1" & "0" & "1");
	nlilOl :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 5,
		width_b => 5,
		width_o => 5
	  )
	  PORT MAP ( 
		a => wire_nlilOl_a,
		b => wire_nlilOl_b,
		cin => wire_gnd,
		o => wire_nlilOl_o
	  );
	wire_n00iii_w_lg_w_o_range2423w2425w(0) <= wire_n00iii_w_o_range2423w(0) OR wire_n00iii_w_o_range2424w(0);
	wire_n00iii_i <= ( n0iiOO & n0i0Oi);
	wire_n00iii_w_o_range2424w(0) <= wire_n00iii_o(0);
	wire_n00iii_w_o_range2423w(0) <= wire_n00iii_o(2);
	n00iii :  oper_decoder
	  GENERIC MAP (
		width_i => 2,
		width_o => 4
	  )
	  PORT MAP ( 
		i => wire_n00iii_i,
		o => wire_n00iii_o
	  );
	wire_n00iOl_w_lg_w_o_range2406w2408w(0) <= wire_n00iOl_w_o_range2406w(0) OR wire_n00iOl_w_o_range2407w(0);
	wire_n00iOl_i <= ( n0i0lO & n0i0ll);
	wire_n00iOl_w_o_range2407w(0) <= wire_n00iOl_o(0);
	wire_n00iOl_w_o_range2406w(0) <= wire_n00iOl_o(2);
	n00iOl :  oper_decoder
	  GENERIC MAP (
		width_i => 2,
		width_o => 4
	  )
	  PORT MAP ( 
		i => wire_n00iOl_i,
		o => wire_n00iOl_o
	  );
	wire_n00l0O_w_lg_w_o_range2389w2391w(0) <= wire_n00l0O_w_o_range2389w(0) OR wire_n00l0O_w_o_range2390w(0);
	wire_n00l0O_i <= ( n0i0li & n0i0iO);
	wire_n00l0O_w_o_range2390w(0) <= wire_n00l0O_o(0);
	wire_n00l0O_w_o_range2389w(0) <= wire_n00l0O_o(2);
	n00l0O :  oper_decoder
	  GENERIC MAP (
		width_i => 2,
		width_o => 4
	  )
	  PORT MAP ( 
		i => wire_n00l0O_i,
		o => wire_n00l0O_o
	  );
	wire_n00lOi_w_lg_w_o_range2372w2374w(0) <= wire_n00lOi_w_o_range2372w(0) OR wire_n00lOi_w_o_range2373w(0);
	wire_n00lOi_i <= ( n0i0il & n0i0ii);
	wire_n00lOi_w_o_range2373w(0) <= wire_n00lOi_o(0);
	wire_n00lOi_w_o_range2372w(0) <= wire_n00lOi_o(2);
	n00lOi :  oper_decoder
	  GENERIC MAP (
		width_i => 2,
		width_o => 4
	  )
	  PORT MAP ( 
		i => wire_n00lOi_i,
		o => wire_n00lOi_o
	  );
	wire_n00O0l_w_lg_w_o_range2355w2357w(0) <= wire_n00O0l_w_o_range2355w(0) OR wire_n00O0l_w_o_range2356w(0);
	wire_n00O0l_i <= ( n0i00O & n0i00l);
	wire_n00O0l_w_o_range2356w(0) <= wire_n00O0l_o(0);
	wire_n00O0l_w_o_range2355w(0) <= wire_n00O0l_o(2);
	n00O0l :  oper_decoder
	  GENERIC MAP (
		width_i => 2,
		width_o => 4
	  )
	  PORT MAP ( 
		i => wire_n00O0l_i,
		o => wire_n00O0l_o
	  );
	wire_n00OlO_w_lg_w_o_range2338w2340w(0) <= wire_n00OlO_w_o_range2338w(0) OR wire_n00OlO_w_o_range2339w(0);
	wire_n00OlO_i <= ( n0i00i & n0i01O);
	wire_n00OlO_w_o_range2339w(0) <= wire_n00OlO_o(0);
	wire_n00OlO_w_o_range2338w(0) <= wire_n00OlO_o(2);
	n00OlO :  oper_decoder
	  GENERIC MAP (
		width_i => 2,
		width_o => 4
	  )
	  PORT MAP ( 
		i => wire_n00OlO_i,
		o => wire_n00OlO_o
	  );
	wire_n0i10i_w_lg_w_o_range2321w2323w(0) <= wire_n0i10i_w_o_range2321w(0) OR wire_n0i10i_w_o_range2322w(0);
	wire_n0i10i_i <= ( n0i01l & n0i01i);
	wire_n0i10i_w_o_range2322w(0) <= wire_n0i10i_o(0);
	wire_n0i10i_w_o_range2321w(0) <= wire_n0i10i_o(2);
	n0i10i :  oper_decoder
	  GENERIC MAP (
		width_i => 2,
		width_o => 4
	  )
	  PORT MAP ( 
		i => wire_n0i10i_i,
		o => wire_n0i10i_o
	  );
	wire_n0i1ll_w_lg_w_o_range2304w2306w(0) <= wire_n0i1ll_w_o_range2304w(0) OR wire_n0i1ll_w_o_range2305w(0);
	wire_n0i1ll_i <= ( n0i1OO & n0i1Ol);
	wire_n0i1ll_w_o_range2305w(0) <= wire_n0i1ll_o(0);
	wire_n0i1ll_w_o_range2304w(0) <= wire_n0i1ll_o(2);
	n0i1ll :  oper_decoder
	  GENERIC MAP (
		width_i => 2,
		width_o => 4
	  )
	  PORT MAP ( 
		i => wire_n0i1ll_i,
		o => wire_n0i1ll_o
	  );
	wire_nli1li_i <= ( nll10l & nll10i);
	nli1li :  oper_decoder
	  GENERIC MAP (
		width_i => 2,
		width_o => 4
	  )
	  PORT MAP ( 
		i => wire_nli1li_i,
		o => wire_nli1li_o
	  );
	wire_nliill_i <= ( PMADATAWIDTH & wire_nll0Ol_dataout & wire_nll0Oi_dataout & wire_nll0lO_dataout & wire_nll0ll_dataout);
	nliill :  oper_decoder
	  GENERIC MAP (
		width_i => 5,
		width_o => 32
	  )
	  PORT MAP ( 
		i => wire_nliill_i,
		o => wire_nliill_o
	  );
	wire_nii1il_a <= ( wire_ni0Oil_dataout & wire_ni0Oii_dataout & wire_ni0O0O_dataout & wire_ni0O0l_dataout & wire_ni0O0i_dataout & wire_ni0O1O_dataout & wire_ni0O1l_dataout & wire_ni0O1i_dataout);
	wire_nii1il_b <= ( ni0liO & ni1OlO & ni1Oll & ni1Oli & ni1OiO & ni1Oil & ni1Oii & ni1O0O);
	nii1il :  oper_less_than
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 8,
		width_b => 8
	  )
	  PORT MAP ( 
		a => wire_nii1il_a,
		b => wire_nii1il_b,
		cin => wire_gnd,
		o => wire_nii1il_o
	  );
	wire_n00i0l_data <= ( wire_n00iil_dataout & "0" & wire_w_lg_n1O1lO614w);
	wire_n00i0l_sel <= ( wire_n00iii_o(3) & wire_n00iii_w_lg_w_o_range2423w2425w & wire_n00iii_o(1));
	n00i0l :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n00i0l_data,
		o => wire_n00i0l_o,
		sel => wire_n00i0l_sel
	  );
	wire_n00ilO_data <= ( wire_n00iOO_dataout & "0" & wire_w_lg_n1lO0l626w);
	wire_n00ilO_sel <= ( wire_n00iOl_o(3) & wire_n00iOl_w_lg_w_o_range2406w2408w & wire_n00iOl_o(1));
	n00ilO :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n00ilO_data,
		o => wire_n00ilO_o,
		sel => wire_n00ilO_sel
	  );
	wire_n00l0i_data <= ( wire_n00lii_dataout & "0" & wire_w_lg_n1lO1i637w);
	wire_n00l0i_sel <= ( wire_n00l0O_o(3) & wire_n00l0O_w_lg_w_o_range2389w2391w & wire_n00l0O_o(1));
	n00l0i :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n00l0i_data,
		o => wire_n00l0i_o,
		sel => wire_n00l0i_sel
	  );
	wire_n00lll_data <= ( wire_n00lOl_dataout & "0" & wire_w_lg_n1llOl648w);
	wire_n00lll_sel <= ( wire_n00lOi_o(3) & wire_n00lOi_w_lg_w_o_range2372w2374w & wire_n00lOi_o(1));
	n00lll :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n00lll_data,
		o => wire_n00lll_o,
		sel => wire_n00lll_sel
	  );
	wire_n00O1O_data <= ( wire_n00O0O_dataout & "0" & wire_w_lg_n1lllO659w);
	wire_n00O1O_sel <= ( wire_n00O0l_o(3) & wire_n00O0l_w_lg_w_o_range2355w2357w & wire_n00O0l_o(1));
	n00O1O :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n00O1O_data,
		o => wire_n00O1O_o,
		sel => wire_n00O1O_sel
	  );
	wire_n00Oli_data <= ( wire_n00OOi_dataout & "0" & wire_w_lg_n1llli670w);
	wire_n00Oli_sel <= ( wire_n00OlO_o(3) & wire_n00OlO_w_lg_w_o_range2338w2340w & wire_n00OlO_o(1));
	n00Oli :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n00Oli_data,
		o => wire_n00Oli_o,
		sel => wire_n00Oli_sel
	  );
	wire_n0110i_data <= ( "0" & wire_n01i1i_dataout & wire_n010ll_dataout);
	wire_n0110i_sel <= ( n11lOi & n001li & n001Ol);
	n0110i :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n0110i_data,
		o => wire_n0110i_o,
		sel => wire_n0110i_sel
	  );
	wire_n0110O_data <= ( "0" & wire_n010OO_dataout & wire_n010lO_dataout);
	wire_n0110O_sel <= ( n11lOl & n001ll & n001lO);
	n0110O :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n0110O_data,
		o => wire_n0110O_o,
		sel => wire_n0110O_sel
	  );
	wire_n0111l_data <= ( "0" & wire_n01l0i_dataout & wire_n010OO_dataout & wire_n010ll_dataout);
	wire_n0111l_sel <= ( n11llO & n001ii & n001li & n001lO);
	n0111l :  oper_selector
	  GENERIC MAP (
		width_data => 4,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_n0111l_data,
		o => wire_n0111l_o,
		sel => wire_n0111l_sel
	  );
	wire_n011il_data <= ( "0" & wire_n01i1i_dataout & wire_n01i1i_dataout & wire_n0101l_dataout);
	wire_n011il_sel <= ( n11lOO & n001ll & n001lO & n0001i);
	n011il :  oper_selector
	  GENERIC MAP (
		width_data => 4,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_n011il_data,
		o => wire_n011il_o,
		sel => wire_n011il_sel
	  );
	wire_n011li_data <= ( "0" & wire_n010OO_dataout & wire_n010lO_dataout);
	wire_n011li_sel <= ( n11O1i & n001Oi & n001Ol);
	n011li :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n011li_data,
		o => wire_n011li_o,
		sel => wire_n011li_sel
	  );
	wire_n011ll_data <= ( "0" & wire_n01i1i_dataout & wire_n01i1i_dataout);
	wire_n011ll_sel <= ( n11O1i & n001Oi & n001Ol);
	n011ll :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n011ll_data,
		o => wire_n011ll_o,
		sel => wire_n011ll_sel
	  );
	wire_n011Oi_data <= ( "0" & wire_w_lg_n11Oli2518w & wire_n0101O_dataout);
	wire_n011Oi_sel <= ( n11O1l & n001OO & n0001i);
	n011Oi :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n011Oi_data,
		o => wire_n011Oi_o,
		sel => wire_n011Oi_sel
	  );
	wire_n0i11l_data <= ( wire_n0i10l_dataout & "0" & wire_w_lg_n1llil681w);
	wire_n0i11l_sel <= ( wire_n0i10i_o(3) & wire_n0i10i_w_lg_w_o_range2321w2323w & wire_n0i10i_o(1));
	n0i11l :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n0i11l_data,
		o => wire_n0i11l_o,
		sel => wire_n0i11l_sel
	  );
	wire_n0i1iO_data <= ( wire_n0i1lO_dataout & "0" & wire_w_lg_n1ll0O692w);
	wire_n0i1iO_sel <= ( wire_n0i1ll_o(3) & wire_n0i1ll_w_lg_w_o_range2304w2306w & wire_n0i1ll_o(1));
	n0i1iO :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n0i1iO_data,
		o => wire_n0i1iO_o,
		sel => wire_n0i1iO_sel
	  );
	wire_n1OlOl_data <= ( "0" & wire_n01iiO_dataout & wire_n01i1O_dataout & wire_n01iiO_dataout
		 & wire_n01i1O_dataout & wire_n010ii_dataout & wire_n011OO_dataout);
	wire_n1OlOl_sel <= ( n11l0l & n001ll & n001lO & n001Oi & n001Ol & n001OO & n0001i);
	n1OlOl :  oper_selector
	  GENERIC MAP (
		width_data => 7,
		width_sel => 7
	  )
	  PORT MAP ( 
		data => wire_n1OlOl_data,
		o => wire_n1OlOl_o,
		sel => wire_n1OlOl_sel
	  );
	wire_n1OlOO_data <= ( "0" & wire_n01ili_dataout & wire_n01i0i_dataout & wire_n01ili_dataout & wire_n01i0i_dataout & wire_n010il_dataout & wire_n0101i_dataout);
	wire_n1OlOO_sel <= ( n11l0l & n001ll & n001lO & n001Oi & n001Ol & n001OO & n0001i);
	n1OlOO :  oper_selector
	  GENERIC MAP (
		width_data => 7,
		width_sel => 7
	  )
	  PORT MAP ( 
		data => wire_n1OlOO_data,
		o => wire_n1OlOO_o,
		sel => wire_n1OlOO_sel
	  );
	wire_n1OO0i_data <= ( wire_n0011i_dataout & wire_n01OOl_dataout & wire_n01Oll_dataout & wire_n01OOl_dataout & wire_n01Oll_dataout & wire_n01l1l_dataout & wire_n01iOl_dataout & wire_n01iOl_dataout & wire_n01iOl_dataout & wire_n01iOl_dataout & wire_n01iOl_dataout & wire_n01Oll_dataout & wire_n01Oll_dataout);
	wire_n1OO0i_sel <= ( n1Ol0l & n0010l & n001il & n0010O & n001iO & n001ii & n001li & n001ll & n001lO & n001Oi & n001Ol & n001OO & n0001i);
	n1OO0i :  oper_selector
	  GENERIC MAP (
		width_data => 13,
		width_sel => 13
	  )
	  PORT MAP ( 
		data => wire_n1OO0i_data,
		o => wire_n1OO0i_o,
		sel => wire_n1OO0i_sel
	  );
	wire_n1OO0l_data <= ( wire_n0011l_dataout & wire_n01OOi_dataout & wire_n01Oli_dataout & wire_n01OOi_dataout & wire_n01Oli_dataout & wire_n1OliO_w_lg_Q2463w & wire_n1OliO_w_lg_Q2463w & wire_n1OliO_w_lg_Q2463w & wire_n1OliO_w_lg_Q2463w & wire_n1OliO_w_lg_Q2463w & wire_n1OliO_w_lg_Q2463w & wire_n1OliO_w_lg_Q2463w & wire_n1OliO_w_lg_Q2463w);
	wire_n1OO0l_sel <= ( n1Ol0l & n0010l & n001il & n0010O & n001iO & n001ii & n001li & n001ll & n001lO & n001Oi & n001Ol & n001OO & n0001i);
	n1OO0l :  oper_selector
	  GENERIC MAP (
		width_data => 13,
		width_sel => 13
	  )
	  PORT MAP ( 
		data => wire_n1OO0l_data,
		o => wire_n1OO0l_o,
		sel => wire_n1OO0l_sel
	  );
	wire_n1OO0O_data <= ( n11OOl & n11OlO & n11Oli & n11OlO & n11Oli & n11O0O & wire_n0001O_w_lg_Q2461w & wire_n0001O_w_lg_Q2461w & wire_n0001O_w_lg_Q2461w & wire_n0001O_w_lg_Q2461w & wire_n0001O_w_lg_Q2461w & n11Oli & n11Oli);
	wire_n1OO0O_sel <= ( n1Ol0l & n0010l & n001il & n0010O & n001iO & n001ii & n001li & n001ll & n001lO & n001Oi & n001Ol & n001OO & n0001i);
	n1OO0O :  oper_selector
	  GENERIC MAP (
		width_data => 13,
		width_sel => 13
	  )
	  PORT MAP ( 
		data => wire_n1OO0O_data,
		o => wire_n1OO0O_o,
		sel => wire_n1OO0O_sel
	  );
	wire_n1OO1l_data <= ( n1Olil & wire_n01l1i_dataout & wire_n01iOO_dataout & wire_n01iOO_dataout & wire_n01iOO_dataout & wire_n01iOO_dataout & wire_n01iOO_dataout & wire_n010iO_dataout & wire_n010iO_dataout);
	wire_n1OO1l_sel <= ( n11l0O & n001ii & n001li & n001ll & n001lO & n001Oi & n001Ol & n001OO & n0001i);
	n1OO1l :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_n1OO1l_data,
		o => wire_n1OO1l_o,
		sel => wire_n1OO1l_sel
	  );
	wire_n1OOii_data <= ( wire_w_lg_n11OOl2682w & wire_n01O1O_dataout & "0");
	wire_n1OOii_sel <= ( n1Ol0l & n0010l & n11lii);
	n1OOii :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n1OOii_data,
		o => wire_n1OOii_o,
		sel => wire_n1OOii_sel
	  );
	wire_n1OOiO_data <= ( "0" & wire_n01O0i_dataout & wire_n01lOl_dataout & wire_n01O1O_dataout);
	wire_n1OOiO_sel <= ( n11lil & n0010l & n001il & n0010O);
	n1OOiO :  oper_selector
	  GENERIC MAP (
		width_data => 4,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_n1OOiO_data,
		o => wire_n1OOiO_o,
		sel => wire_n1OOiO_sel
	  );
	wire_n1OOll_data <= ( "0" & wire_n01O0i_dataout & wire_n01lOl_dataout & wire_n01l1O_dataout);
	wire_n1OOll_sel <= ( n11liO & n0010O & n001iO & n001ii);
	n1OOll :  oper_selector
	  GENERIC MAP (
		width_data => 4,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_n1OOll_data,
		o => wire_n1OOll_o,
		sel => wire_n1OOll_sel
	  );
	wire_n1OOOi_data <= ( "0" & wire_n01O0l_dataout & wire_n01lOO_dataout);
	wire_n1OOOi_sel <= ( n11lli & n0010l & n001il);
	n1OOOi :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n1OOOi_data,
		o => wire_n1OOOi_o,
		sel => wire_n1OOOi_sel
	  );
	wire_n1OOOO_data <= ( "0" & wire_n01O0l_dataout & wire_n01lOO_dataout);
	wire_n1OOOO_sel <= ( n11lll & n0010O & n001iO);
	n1OOOO :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n1OOOO_data,
		o => wire_n1OOOO_o,
		sel => wire_n1OOOO_sel
	  );
	wire_ni001i_data <= ( "0" & nil10i & wire_ni0iOi_dataout & niil0l & wire_ni0i1l_dataout);
	wire_ni001i_sel <= ( n100li & n100iO & ni0lOO & n100il & ni0OOO);
	ni001i :  oper_selector
	  GENERIC MAP (
		width_data => 5,
		width_sel => 5
	  )
	  PORT MAP ( 
		data => wire_ni001i_data,
		o => wire_ni001i_o,
		sel => wire_ni001i_sel
	  );
	wire_ni00ii_data <= ( "0" & wire_ni0iOO_dataout & wire_ni0iOO_dataout & wire_ni0iOO_dataout & wire_ni0i1O_dataout & wire_ni0i1O_dataout & wire_ni0i1O_dataout);
	wire_ni00ii_sel <= ( n100li & ni0llO & ni0lOl & ni0lOO & ni0lll & ni0lOi & ni0OOO);
	ni00ii :  oper_selector
	  GENERIC MAP (
		width_data => 7,
		width_sel => 7
	  )
	  PORT MAP ( 
		data => wire_ni00ii_data,
		o => wire_ni00ii_o,
		sel => wire_ni00ii_sel
	  );
	wire_ni00il_data <= ( "0" & wire_ni0l1i_dataout & wire_ni0l1i_dataout & wire_ni0l1i_dataout & wire_ni0i0i_dataout & wire_ni0i0i_dataout & wire_ni0i0i_dataout);
	wire_ni00il_sel <= ( n100li & ni0llO & ni0lOl & ni0lOO & ni0lll & ni0lOi & ni0OOO);
	ni00il :  oper_selector
	  GENERIC MAP (
		width_data => 7,
		width_sel => 7
	  )
	  PORT MAP ( 
		data => wire_ni00il_data,
		o => wire_ni00il_o,
		sel => wire_ni00il_sel
	  );
	wire_ni00li_data <= ( "0" & wire_ni0l1l_dataout & wire_ni0l1l_dataout & wire_ni0l1l_dataout);
	wire_ni00li_sel <= ( n100ll & ni0llO & ni0lOl & ni0lOO);
	ni00li :  oper_selector
	  GENERIC MAP (
		width_data => 4,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_ni00li_data,
		o => wire_ni00li_o,
		sel => wire_ni00li_sel
	  );
	wire_ni00lO_data <= ( "0" & wire_ni0i0l_dataout & wire_ni0i0l_dataout & wire_ni0i0l_dataout);
	wire_ni00lO_sel <= ( n100lO & ni0lll & ni0lOi & ni0OOO);
	ni00lO :  oper_selector
	  GENERIC MAP (
		width_data => 4,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_ni00lO_data,
		o => wire_ni00lO_o,
		sel => wire_ni00lO_sel
	  );
	wire_ni01iO_data <= ( "0" & nil10l & ni1O0O & niil0O);
	wire_ni01iO_sel <= ( n100li & n100iO & n100ii & n100il);
	ni01iO :  oper_selector
	  GENERIC MAP (
		width_data => 4,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_ni01iO_data,
		o => wire_ni01iO_o,
		sel => wire_ni01iO_sel
	  );
	wire_ni01li_data <= ( "0" & nil10O & ni1Oii & niilii);
	wire_ni01li_sel <= ( n100li & n100iO & n100ii & n100il);
	ni01li :  oper_selector
	  GENERIC MAP (
		width_data => 4,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_ni01li_data,
		o => wire_ni01li_o,
		sel => wire_ni01li_sel
	  );
	wire_ni01ll_data <= ( "0" & nil1ii & ni1Oil
		 & niilil);
	wire_ni01ll_sel <= ( n100li & n100iO & n100ii & n100il);
	ni01ll :  oper_selector
	  GENERIC MAP (
		width_data => 4,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_ni01ll_data,
		o => wire_ni01ll_o,
		sel => wire_ni01ll_sel
	  );
	wire_ni01lO_data <= ( "0" & nil1il & ni1OiO & niiliO);
	wire_ni01lO_sel <= ( n100li & n100iO & n100ii & n100il);
	ni01lO :  oper_selector
	  GENERIC MAP (
		width_data => 4,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_ni01lO_data,
		o => wire_ni01lO_o,
		sel => wire_ni01lO_sel
	  );
	wire_ni01Oi_data <= ( "0" & nil11i & wire_ni0ili_dataout & niil1l & wire_ni00Ol_dataout);
	wire_ni01Oi_sel <= ( n100li & n100iO & ni0lOO & n100il & ni0OOO);
	ni01Oi :  oper_selector
	  GENERIC MAP (
		width_data => 5,
		width_sel => 5
	  )
	  PORT MAP ( 
		data => wire_ni01Oi_data,
		o => wire_ni01Oi_o,
		sel => wire_ni01Oi_sel
	  );
	wire_ni01Ol_data <= ( "0" & nil11l & wire_ni0ill_dataout & niil1O & wire_ni00OO_dataout);
	wire_ni01Ol_sel <= ( n100li & n100iO & ni0lOO & n100il & ni0OOO);
	ni01Ol :  oper_selector
	  GENERIC MAP (
		width_data => 5,
		width_sel => 5
	  )
	  PORT MAP ( 
		data => wire_ni01Ol_data,
		o => wire_ni01Ol_o,
		sel => wire_ni01Ol_sel
	  );
	wire_ni01OO_data <= ( "0" & nil11O & wire_ni0ilO_dataout & niil0i & wire_ni0i1i_dataout);
	wire_ni01OO_sel <= ( n100li & n100iO & ni0lOO & n100il & ni0OOO);
	ni01OO :  oper_selector
	  GENERIC MAP (
		width_data => 5,
		width_sel => 5
	  )
	  PORT MAP ( 
		data => wire_ni01OO_data,
		o => wire_ni01OO_o,
		sel => wire_ni01OO_sel
	  );
	wire_nli00O_data <= ( niOlO & niO0l & niO0O & niOii & niOil & niOiO & niOli & niOll & niOOi & niOOl & niO1O & niO0i);
	wire_nli00O_sel <= ( n1l0OO & n1l0Ol & n1l0Oi & n1l0lO & n1l0ll & n1l0li & n1l0iO & n1l0il & wire_nliill_o(17 DOWNTO 16) & wire_nliill_o(9 DOWNTO 8));
	nli00O :  oper_selector
	  GENERIC MAP (
		width_data => 12,
		width_sel => 12
	  )
	  PORT MAP ( 
		data => wire_nli00O_data,
		o => wire_nli00O_o,
		sel => wire_nli00O_sel
	  );
	wire_nli0ii_data <= ( niOOi & niO0O & niOii & niOil & niOiO & niOli & niOll & niOlO & niOOl & niOOO & niO0i & niO0l);
	wire_nli0ii_sel <= ( n1l0OO & n1l0Ol & n1l0Oi & n1l0lO & n1l0ll & n1l0li & n1l0iO & n1l0il & wire_nliill_o(17 DOWNTO 16) & wire_nliill_o(9 DOWNTO 8));
	nli0ii :  oper_selector
	  GENERIC MAP (
		width_data => 12,
		width_sel => 12
	  )
	  PORT MAP ( 
		data => wire_nli0ii_data,
		o => wire_nli0ii_o,
		sel => wire_nli0ii_sel
	  );
	wire_nli0il_data <= ( niOOl & niOii & niOil & niOiO & niOli & niOll & niOlO & niOOi & niOOO & nl11i & niO0l & niO0O);
	wire_nli0il_sel <= ( n1l0OO & n1l0Ol & n1l0Oi & n1l0lO & n1l0ll & n1l0li & n1l0iO & n1l0il & wire_nliill_o(17 DOWNTO 16) & wire_nliill_o(9 DOWNTO 8));
	nli0il :  oper_selector
	  GENERIC MAP (
		width_data => 12,
		width_sel => 12
	  )
	  PORT MAP ( 
		data => wire_nli0il_data,
		o => wire_nli0il_o,
		sel => wire_nli0il_sel
	  );
	wire_nli0iO_data <= ( niOOO & niOil & niOiO & niOli & niOll & niOlO & niOOi & niOOl & nl11i & nl11l & niO0O & niOii);
	wire_nli0iO_sel <= ( n1l0OO & n1l0Ol & n1l0Oi & n1l0lO & n1l0ll & n1l0li & n1l0iO & n1l0il & wire_nliill_o(17 DOWNTO 16) & wire_nliill_o(9 DOWNTO 8));
	nli0iO :  oper_selector
	  GENERIC MAP (
		width_data => 12,
		width_sel => 12
	  )
	  PORT MAP ( 
		data => wire_nli0iO_data,
		o => wire_nli0iO_o,
		sel => wire_nli0iO_sel
	  );
	wire_nli0li_data <= ( nl11i & niOiO & niOli & niOll & niOlO & niOOi & niOOl & niOOO & nl11l & nl11O & niOii & niOil);
	wire_nli0li_sel <= ( n1l0OO & n1l0Ol & n1l0Oi & n1l0lO & n1l0ll & n1l0li & n1l0iO & n1l0il & wire_nliill_o(17 DOWNTO 16) & wire_nliill_o(9 DOWNTO 8));
	nli0li :  oper_selector
	  GENERIC MAP (
		width_data => 12,
		width_sel => 12
	  )
	  PORT MAP ( 
		data => wire_nli0li_data,
		o => wire_nli0li_o,
		sel => wire_nli0li_sel
	  );
	wire_nli0ll_data <= ( nl11l & niOli & niOll & niOlO & niOOi & niOOl & niOOO & nl11i & nl11O & nl10i & niOil & niOiO);
	wire_nli0ll_sel <= ( n1l0OO & n1l0Ol & n1l0Oi & n1l0lO & n1l0ll & n1l0li & n1l0iO & n1l0il & wire_nliill_o(17 DOWNTO 16) & wire_nliill_o(9 DOWNTO 8));
	nli0ll :  oper_selector
	  GENERIC MAP (
		width_data => 12,
		width_sel => 12
	  )
	  PORT MAP ( 
		data => wire_nli0ll_data,
		o => wire_nli0ll_o,
		sel => wire_nli0ll_sel
	  );
	wire_nli0lO_data <= ( nl11O & niOll & niOlO & niOOi & niOOl & niOOO & nl11i & nl11l & nl10i & nl10l & niOiO & niOli);
	wire_nli0lO_sel <= ( n1l0OO & n1l0Ol & n1l0Oi & n1l0lO & n1l0ll & n1l0li & n1l0iO & n1l0il & wire_nliill_o(17 DOWNTO 16) & wire_nliill_o(9 DOWNTO 8));
	nli0lO :  oper_selector
	  GENERIC MAP (
		width_data => 12,
		width_sel => 12
	  )
	  PORT MAP ( 
		data => wire_nli0lO_data,
		o => wire_nli0lO_o,
		sel => wire_nli0lO_sel
	  );
	wire_nli0Oi_data <= ( nl10i & niOlO & niOOi & niOOl & niOOO & nl11i & nl11l & nl11O & nl10l & nl10O & niOli & niOll);
	wire_nli0Oi_sel <= ( n1l0OO & n1l0Ol & n1l0Oi & n1l0lO & n1l0ll & n1l0li & n1l0iO & n1l0il & wire_nliill_o(17 DOWNTO 16) & wire_nliill_o(9 DOWNTO 8));
	nli0Oi :  oper_selector
	  GENERIC MAP (
		width_data => 12,
		width_sel => 12
	  )
	  PORT MAP ( 
		data => wire_nli0Oi_data,
		o => wire_nli0Oi_o,
		sel => wire_nli0Oi_sel
	  );
	wire_nli10i_data <= ( SYNC_COMP_PAT(11) & SYNC_COMP_PAT(3) & nl00Ol);
	wire_nli10i_sel <= ( wire_nli1li_o(3 DOWNTO 2) & n1l0ii);
	nli10i :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nli10i_data,
		o => wire_nli10i_o,
		sel => wire_nli10i_sel
	  );
	wire_nli10l_data <= ( SYNC_COMP_PAT(12) & SYNC_COMP_PAT(4) & nl00OO);
	wire_nli10l_sel <= ( wire_nli1li_o(3 DOWNTO 2) & n1l0ii);
	nli10l :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nli10l_data,
		o => wire_nli10l_o,
		sel => wire_nli10l_sel
	  );
	wire_nli10O_data <= ( SYNC_COMP_PAT(13) & SYNC_COMP_PAT(5) & nl0i1i);
	wire_nli10O_sel <= ( wire_nli1li_o(3 DOWNTO 2) & n1l0ii);
	nli10O :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nli10O_data,
		o => wire_nli10O_o,
		sel => wire_nli10O_sel
	  );
	wire_nli11i_data <= ( SYNC_COMP_PAT(8) & SYNC_COMP_PAT(0) & nl00ll);
	wire_nli11i_sel <= ( wire_nli1li_o(3 DOWNTO 2) & n1l0ii);
	nli11i :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nli11i_data,
		o => wire_nli11i_o,
		sel => wire_nli11i_sel
	  );
	wire_nli11l_data <= ( SYNC_COMP_PAT(9) & SYNC_COMP_PAT(1) & nl00lO);
	wire_nli11l_sel <= ( wire_nli1li_o(3 DOWNTO 2) & n1l0ii);
	nli11l :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nli11l_data,
		o => wire_nli11l_o,
		sel => wire_nli11l_sel
	  );
	wire_nli11O_data <= ( SYNC_COMP_PAT(10) & SYNC_COMP_PAT(2) & nl00Oi);
	wire_nli11O_sel <= ( wire_nli1li_o(3 DOWNTO 2) & n1l0ii);
	nli11O :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nli11O_data,
		o => wire_nli11O_o,
		sel => wire_nli11O_sel
	  );
	wire_nli1ii_data <= ( SYNC_COMP_PAT(14) & SYNC_COMP_PAT(6) & nl0i1l);
	wire_nli1ii_sel <= ( wire_nli1li_o(3 DOWNTO 2) & n1l0ii);
	nli1ii :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nli1ii_data,
		o => wire_nli1ii_o,
		sel => wire_nli1ii_sel
	  );
	wire_nli1il_data <= ( SYNC_COMP_PAT(15) & SYNC_COMP_PAT(7) & nl0i1O);
	wire_nli1il_sel <= ( wire_nli1li_o(3 DOWNTO 2) & n1l0ii);
	nli1il :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nli1il_data,
		o => wire_nli1il_o,
		sel => wire_nli1il_sel
	  );
	wire_nliiii_data <= ( nl10l & nli00l & niOll & niOlO & niOOi & niOOl & niOOO & nl11i & nl11l & nl11O & nl10i);
	wire_nliiii_sel <= ( n1li1l & n1li1i & wire_nliill_o(9 DOWNTO 1));
	nliiii :  oper_selector
	  GENERIC MAP (
		width_data => 11,
		width_sel => 11
	  )
	  PORT MAP ( 
		data => wire_nliiii_data,
		o => wire_nliiii_o,
		sel => wire_nliiii_sel
	  );
	wire_nliiil_data <= ( nl10O & nliilO & niOlO & niOOi & niOOl & niOOO & nl11i & nl11l & nl11O & nl10i & nl10l);
	wire_nliiil_sel <= ( n1li1l & n1li1i & wire_nliill_o(9 DOWNTO 1));
	nliiil :  oper_selector
	  GENERIC MAP (
		width_data => 11,
		width_sel => 11
	  )
	  PORT MAP ( 
		data => wire_nliiil_data,
		o => wire_nliiil_o,
		sel => wire_nliiil_sel
	  );
	wire_nliOl_data <= ( wire_nll0O_dataout & wire_nll1O_dataout & "0");
	wire_nliOl_sel <= ( nlilO & nlllO & nliOi);
	nliOl :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nliOl_data,
		o => wire_nliOl_o,
		sel => wire_nliOl_sel
	  );
	wire_nliOO_data <= ( wire_nllii_dataout & wire_nll0i_dataout & wire_n0000O_w_lg_Q82w);
	wire_nliOO_sel <= ( nlilO & nlllO
		 & nliOi);
	nliOO :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nliOO_data,
		o => wire_nliOO_o,
		sel => wire_nliOO_sel
	  );
	wire_nll1i_data <= ( n1Oi0l & wire_nll0l_dataout & "0");
	wire_nll1i_sel <= ( nlilO & nlllO & nliOi);
	nll1i :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nll1i_data,
		o => wire_nll1i_o,
		sel => wire_nll1i_sel
	  );
	wire_nll1l_data <= ( wire_nllil_dataout & n1O0Oi & n0000O);
	wire_nll1l_sel <= ( nlilO & nlllO & nliOi);
	nll1l :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nll1l_data,
		o => wire_nll1l_o,
		sel => wire_nll1l_sel
	  );

 END RTL; --stratixgx_hssi_rx_wal_rtl
--synopsys translate_on
--VALID FILE
--
-- STRATIXGX_HSSI_WORD_ALIGNER
--

library IEEE, stratixgx_gxb;
use IEEE.std_logic_1164.all;
use stratixgx_gxb.hssi_pack.all;

ENTITY stratixgx_hssi_word_aligner IS
    generic	(
        channel_width       : integer := 10;
        align_pattern_length: integer := 10;
        infiniband_invalid_code: integer := 0;
        align_pattern 	: string := "0000000101111100";
        synchronization_mode: string := "XAUI";
        use_8b_10b_mode	: string := "true";
        use_auto_bit_slip   : string := "true");
    PORT (
        datain                  : IN std_logic_vector(9 DOWNTO 0);   
        clk                     : IN std_logic;   
        softreset               : IN std_logic;   
        enacdet                 : IN std_logic;   
        bitslip                 : IN std_logic;   
        a1a2size                : IN std_logic;   
        aligneddata             : OUT std_logic_vector(9 DOWNTO 0);   
        aligneddatapre          : OUT std_logic_vector(9 DOWNTO 0);   
        invalidcode             : OUT std_logic;   
        invalidcodepre          : OUT std_logic;   
        syncstatus              : OUT std_logic;   
        syncstatusdeskew        : OUT std_logic;   
        disperr                 : OUT std_logic;   
        disperrpre              : OUT std_logic;   
        patterndetectpre        : OUT std_logic;   
        patterndetect           : OUT std_logic);   
END stratixgx_hssi_word_aligner;

ARCHITECTURE auto_translated OF stratixgx_hssi_word_aligner IS

    COMPONENT stratixgx_hssi_rx_wal_rtl
        PORT (
            rcvd_clk                : IN  std_logic;
            soft_reset              : IN  std_logic;
            LP10BEN                 : IN  std_logic;
            RLV_EN                  : IN  std_logic;
            RUNDISP_SEL             : IN  std_logic_vector(4 DOWNTO 0);
            PMADATAWIDTH            : IN  std_logic;
            SYNC_COMP_PAT           : IN  std_logic_vector(15 DOWNTO 0);
            SYNC_COMP_SIZE          : IN  std_logic_vector(1 DOWNTO 0);
            IB_INVALID_CODE         : IN  std_logic_vector(1 DOWNTO 0);
            AUTOBYTEALIGN_DIS       : IN  std_logic;
            BITSLIP                 : IN  std_logic;
            DISABLE_RX_DISP         : IN  std_logic;
            ENCDT                   : IN  std_logic;
            SYNC_SM_DIS             : IN  std_logic;
            prbs_en                 : IN  std_logic;
            encdet_prbs             : IN  std_logic;
            GE_XAUI_SEL             : IN  std_logic;
            signal_detect           : IN  std_logic;
            PUDI                    : IN  std_logic_vector(9 DOWNTO 0);
            PUDR                    : IN  std_logic_vector(9 DOWNTO 0);
            A1A2_SIZE               : IN  std_logic;
            DWIDTH                  : IN  std_logic;
            cg_comma                : OUT std_logic;
            sync_status             : OUT std_logic;
            signal_detect_sync      : OUT std_logic;
            SUDI                    : OUT std_logic_vector(12 DOWNTO 0);
            SUDI_pre                : OUT std_logic_vector(9 DOWNTO 0);
            RLV                     : OUT std_logic;
            RLV_lt                  : OUT std_logic;
            sync_curr_st            : OUT std_logic_vector(3 DOWNTO 0));
    END COMPONENT;


    -- input interface
    SIGNAL rcvd_clk                 :  std_logic;   
    SIGNAL soft_reset               :  std_logic;   
    SIGNAL LP10BEN                  :  std_logic;   
    SIGNAL RLV_EN                   :  std_logic;   
    SIGNAL RUNDISP_SEL              :  std_logic_vector(4 DOWNTO 0);   
    SIGNAL PMADATAWIDTH             :  std_logic;   
    SIGNAL SYNC_COMP_PAT            :  std_logic_vector(15 DOWNTO 0);   
    SIGNAL SYNC_COMP_SIZE           :  std_logic_vector(1 DOWNTO 0);   
    SIGNAL IB_INVALID_CODE          :  std_logic_vector(1 DOWNTO 0);   
    SIGNAL AUTOBYTEALIGN_DIS        :  std_logic;   
    SIGNAL SYNC_SM_DIS              :  std_logic;   
    SIGNAL GE_XAUI_SEL              :  std_logic;   
    SIGNAL encdet_prbs              :  std_logic;   
    SIGNAL BITSLIP_xhdl11           :  std_logic;   
    SIGNAL ENCDT                    :  std_logic;   
    SIGNAL prbs_en                  :  std_logic;   
    SIGNAL DISABLE_RX_DISP          :  std_logic;   
    SIGNAL signal_detect            :  std_logic;   
    SIGNAL PUDI                     :  std_logic_vector(9 DOWNTO 0);   
    SIGNAL PUDR                     :  std_logic_vector(9 DOWNTO 0);   
    SIGNAL A1A2_SIZE                :  std_logic;  
	 
    -- A1A2 and A1A1A2A2 pattern detection
    SIGNAL DWIDTH                   :  std_logic;   

    -- output interface
    SIGNAL cg_comma                 :  std_logic;   
    SIGNAL sync_status              :  std_logic;   
    SIGNAL signal_detect_sync       :  std_logic;   
    SIGNAL SUDI                     :  std_logic_vector(12 DOWNTO 0);   
    SIGNAL SUDI_pre                 :  std_logic_vector(9 DOWNTO 0);   
    SIGNAL RLV                      :  std_logic;   
    SIGNAL RLV_lt                   :  std_logic;   
    SIGNAL sync_curr_st             :  std_logic_vector(3 DOWNTO 0);   
    SIGNAL temp_xhdl12              :  std_logic;   
    SIGNAL temp_xhdl13              :  std_logic_vector(1 DOWNTO 0);   
    SIGNAL temp_xhdl14              :  std_logic_vector(1 DOWNTO 0);   
    SIGNAL temp_xhdl15              :  std_logic;   
    SIGNAL temp_xhdl16              :  std_logic;   
    SIGNAL temp_xhdl17              :  std_logic;   
    SIGNAL temp_xhdl18              :  std_logic_vector(1 DOWNTO 0);   
    SIGNAL temp_xhdl19              :  std_logic_vector(1 DOWNTO 0);   
    SIGNAL temp_xhdl20              :  std_logic_vector(1 DOWNTO 0);   
    SIGNAL aligneddata_xhdl1        :  std_logic_vector(9 DOWNTO 0);   
    SIGNAL aligneddatapre_xhdl2     :  std_logic_vector(9 DOWNTO 0);   
    SIGNAL invalidcode_xhdl3        :  std_logic;   
    SIGNAL invalidcodepre_xhdl4     :  std_logic;   
    SIGNAL syncstatus_xhdl5         :  std_logic;   
    SIGNAL syncstatusdeskew_xhdl6   :  std_logic;   
    SIGNAL disperr_xhdl7            :  std_logic;   
    SIGNAL disperrpre_xhdl8         :  std_logic;   
    SIGNAL patterndetect_xhdl9      :  std_logic;   
    SIGNAL patterndetectpre_xhdl10  :  std_logic;   

BEGIN
    aligneddata <= aligneddata_xhdl1;
    aligneddatapre <= aligneddatapre_xhdl2;
    invalidcode <= invalidcode_xhdl3;
    invalidcodepre <= invalidcodepre_xhdl4;
    syncstatus <= syncstatus_xhdl5;
    syncstatusdeskew <= syncstatusdeskew_xhdl6;
    disperr <= disperr_xhdl7;
    disperrpre <= disperrpre_xhdl8;
    patterndetect <= patterndetect_xhdl9;
    patterndetectpre <= patterndetectpre_xhdl10;
    RLV_EN <= '0' ;
    RUNDISP_SEL <= "01000" ;
    DWIDTH <= '0' ;
    LP10BEN <= '0' ;
    DISABLE_RX_DISP <= '0' ;
    temp_xhdl12 <= '1' WHEN (align_pattern_length = 16 OR align_pattern_length = 8) ELSE '0';
    PMADATAWIDTH <= temp_xhdl12 ;
    SYNC_COMP_PAT <= pattern_conversion(align_pattern) ;
    temp_xhdl13 <= "01" WHEN (align_pattern_length = 16 OR align_pattern_length = 8) ELSE "10";
    temp_xhdl14 <= "00" WHEN (align_pattern_length = 7) ELSE temp_xhdl13;
    SYNC_COMP_SIZE <= temp_xhdl14 ;
    temp_xhdl15 <= '1' WHEN (synchronization_mode = "none" OR synchronization_mode = "NONE") ELSE '0';
    SYNC_SM_DIS <= temp_xhdl15 ;
    temp_xhdl16 <= '1' WHEN (synchronization_mode = "gige" OR synchronization_mode = "GIGE") ELSE '0';
    GE_XAUI_SEL <= temp_xhdl16 ;
    temp_xhdl17 <= '0' WHEN (use_auto_bit_slip = "true" OR use_auto_bit_slip = "ON") ELSE '1';
    AUTOBYTEALIGN_DIS <= temp_xhdl17 ;
    temp_xhdl18 <= "10" WHEN (infiniband_invalid_code = 2) ELSE "11";
    temp_xhdl19 <= "01" WHEN (infiniband_invalid_code = 1) ELSE temp_xhdl18;
    temp_xhdl20 <= "00" WHEN (infiniband_invalid_code = 0) ELSE temp_xhdl19;
    IB_INVALID_CODE <= temp_xhdl20 ;
    prbs_en <= '0' ;
    encdet_prbs <= '0' ;
    signal_detect <= '1' ;
    rcvd_clk <= clk ;
    soft_reset <= softreset ;
    BITSLIP_xhdl11 <= bitslip ;
    ENCDT <= enacdet ;

	-- filtering X valus
    PUDI(0) <= datain(0) WHEN (datain(0) = '0' OR datain(0) = '1') ELSE '0';
    PUDI(1) <= datain(1) WHEN (datain(1) = '0' OR datain(1) = '1') ELSE '0';
    PUDI(2) <= datain(2) WHEN (datain(2) = '0' OR datain(2) = '1') ELSE '0';
    PUDI(3) <= datain(3) WHEN (datain(3) = '0' OR datain(3) = '1') ELSE '0';
    PUDI(4) <= datain(4) WHEN (datain(4) = '0' OR datain(4) = '1') ELSE '0';
    PUDI(5) <= datain(5) WHEN (datain(5) = '0' OR datain(5) = '1') ELSE '0';
    PUDI(6) <= datain(6) WHEN (datain(6) = '0' OR datain(6) = '1') ELSE '0';
    PUDI(7) <= datain(7) WHEN (datain(7) = '0' OR datain(7) = '1') ELSE '0';
    PUDI(8) <= datain(8) WHEN (datain(8) = '0' OR datain(8) = '1') ELSE '0';
    PUDI(9) <= datain(9) WHEN (datain(9) = '0' OR datain(9) = '1') ELSE '0';

    A1A2_SIZE <= a1a2size ;
    PUDR <= "XXXXXXXXXX" ;
    aligneddata_xhdl1 <= SUDI(9 DOWNTO 0) ;
    invalidcode_xhdl3 <= SUDI(10) ;
    syncstatus_xhdl5 <= SUDI(11) ;
    disperr_xhdl7 <= SUDI(12) ;
    syncstatusdeskew_xhdl6 <= sync_status ;
    patterndetect_xhdl9 <= cg_comma ;
    aligneddatapre_xhdl2 <= SUDI_pre ;
    invalidcodepre_xhdl4 <= '0' ;
    disperrpre_xhdl8 <= '0' ;
    patterndetectpre_xhdl10 <= '0' ;
    m_wal_rtl : stratixgx_hssi_rx_wal_rtl 
        PORT MAP (
            rcvd_clk => rcvd_clk,
            soft_reset => soft_reset,
            LP10BEN => LP10BEN,
            RLV_EN => RLV_EN,
            RUNDISP_SEL => RUNDISP_SEL,
            PMADATAWIDTH => PMADATAWIDTH,
            SYNC_COMP_PAT => SYNC_COMP_PAT,
            SYNC_COMP_SIZE => SYNC_COMP_SIZE,
            IB_INVALID_CODE => IB_INVALID_CODE,
            AUTOBYTEALIGN_DIS => AUTOBYTEALIGN_DIS,
            BITSLIP => BITSLIP_xhdl11,
            DISABLE_RX_DISP => DISABLE_RX_DISP,
            ENCDT => ENCDT,
            SYNC_SM_DIS => SYNC_SM_DIS,
            prbs_en => prbs_en,
            encdet_prbs => encdet_prbs,
            GE_XAUI_SEL => GE_XAUI_SEL,
            signal_detect => signal_detect,
            PUDI => PUDI,
            PUDR => PUDR,
            cg_comma => cg_comma,
            sync_status => sync_status,
            signal_detect_sync => signal_detect_sync,
            SUDI => SUDI,
            SUDI_pre => SUDI_pre,
            RLV => RLV,
            RLV_lt => RLV_lt,
            sync_curr_st => sync_curr_st,
            A1A2_SIZE => A1A2_SIZE,
            DWIDTH => DWIDTH);   
    

END auto_translated;

--
-- STRATIXGX_HSSI_RX_SERDES
--

library IEEE, stratixgx_gxb,std;
use IEEE.std_logic_1164.all;
use stratixgx_gxb.hssi_pack.all;
use std.textio.all;

entity stratixgx_hssi_rx_serdes is
    generic (
					channel_width			: integer := 10;
					rlv_length				: integer := 1;
					run_length_enable		: String := "false";
					cruclk_period			: integer :=5000; 
					cruclk_multiplier		: integer :=4; 
					use_cruclk_divider	: String := "false";
               use_double_data_mode :  string  := "false"    
				);

	port (
				datain		: in std_logic := '0';
				cruclk		: in std_logic := '0';
				areset		: in std_logic := '0';
				feedback		: in std_logic := '0';
				fbkcntl		: in std_logic := '0';
				ltr			: in std_logic := '0';	-- q3.0ll
				ltd			: in std_logic := '0';	-- q3.0ll
				dataout		: out std_logic_vector(9 downto 0);
				clkout		: out std_logic;
				rlv			: out std_logic;
				lock			: out std_logic;
				freqlock		: out std_logic;
				signaldetect: out std_logic
			);

end stratixgx_hssi_rx_serdes;

architecture vital_rx_serdes_atom of stratixgx_hssi_rx_serdes is

   constant	channel_width_max		: integer := 10;

    constant	init_lock_latency		: integer := 9; -- q3.0ll
	signal ltr_ipd            :  std_logic;
	signal ltd_ipd            :  std_logic;
	signal lock_tmp           :  std_logic;
	signal freqlock_tmp       :  std_logic;
	signal freqlock_tmp_dly   :  std_logic;             
	signal freqlock_tmp_dly1  :  std_logic;           
	signal freqlock_tmp_dly2  :  std_logic;         
	signal freqlock_tmp_dly3  :  std_logic;        
	signal freqlock_tmp_dly4  :  std_logic;        

	signal databuf_ipd : std_logic;
	signal cruclk_ipd  : std_logic;
	signal areset_ipd : std_logic;
	signal fbin_ipd : std_logic;
	signal fbena_ipd : std_logic;

	-- add 2 deltas to balance new fastclk_gen - always read prev data
	-- The 1st fastclk has: in_delta + 1(ipd) + 1 (fastclk <= after 0)
	-- remaining fastclk has 0 delta
	-- in summary: fastclk_delta = x(from top) + 1(ipd) + 1 or    0 (no delta)
	--             data          = x(from top) + 1(ipd) + 2 (new)
	signal databuf_tmp1, databuf_tmp2 : std_logic;
	signal areset_tmp1, areset_tmp2   : std_logic;
	signal fbin_tmp1,  fbin_tmp2      : std_logic;
	signal fbena_tmp1, fbena_tmp2     : std_logic;
	signal ltr_tmp1, ltr_tmp2         : std_logic;
	signal ltd_tmp1, ltd_tmp2         : std_logic;

	-- clock gen
	signal fastclk  : std_logic;
	signal cruclk_ipd_last_value : std_logic := 'X';

	signal rlv_flag : std_logic := '0';
	signal rlv_flag_tmp : std_logic := '0';
	signal rlv_set : std_logic := '0';
	signal clkout_int : std_logic := '0';
   signal deser_data_arr : std_logic_vector(channel_width_max-1 downto 0);
	signal deser_data_arr_int : std_logic_vector(channel_width_max-1 downto 0);
	signal deser_data_arr_tmp : std_logic_vector(channel_width_max-1 downto 0);
   signal min_length : integer := 0;
	signal rlv_tmp1 : std_logic := '0';
	signal rlv_tmp2 : std_logic := '0';
	signal rlv_tmp3 : std_logic := '0';
	signal dataout_tmp : std_logic_vector(channel_width_max-1 downto 0);

begin

	----------------------
	--  INPUT PATH DELAYs
	----------------------
   -- for now assuming all delays on top level

	WireDelay : block
	begin
		cruclk_ipd   <= cruclk;

        databuf_tmp1 <= datain;
        fbin_tmp1    <= feedback;
        fbena_tmp1   <= fbkcntl;
        areset_tmp1  <= areset;
        ltr_tmp1     <= ltr;
        ltd_tmp1     <= ltd;

		databuf_tmp2 <= databuf_tmp1;
		fbin_tmp2    <= fbin_tmp1;
		fbena_tmp2   <= fbena_tmp1;
		areset_tmp2  <= areset_tmp1;
		ltr_tmp2     <= ltr_tmp1;
		ltd_tmp2     <= ltd_tmp1;
         
		databuf_ipd <= databuf_tmp2;
		fbin_ipd    <= fbin_tmp2;
		fbena_ipd   <= fbena_tmp2;
		areset_ipd  <= areset_tmp2;
		ltr_ipd     <= ltr_tmp2;
		ltd_ipd     <= ltd_tmp2;

	end block;

	min_length <= 4 WHEN (channel_width = 8) ELSE 5;

process (cruclk_ipd)
    variable init                  : boolean   := true;
    variable n_fastclk             : integer   := 5;
    variable fastclk_period        : integer   := 320;
    variable cru_rem               : integer   := 0;
    variable my_rem                : integer   := 0;
    variable tmp_fastclk_period    : integer   := 320;
    variable cycle_to_adjust       : integer   := 0;
	variable k                     : integer   := 1;
    variable high_time             : integer   := 160;
    variable low_time              : integer   := 160;
    variable sched_time            : time      := 0 ps;
    variable sched_val             : std_logic := '0';
begin
    if (init) then
        if (use_cruclk_divider = "false") then
            n_fastclk := cruclk_multiplier;
        else
            n_fastclk := cruclk_multiplier / 2;
        end if;        
        fastclk_period := cruclk_period / n_fastclk;
        cru_rem := cruclk_period rem n_fastclk;
                      
        init := false;
	end if;

    if ((cruclk_ipd = '1') and (cruclk_ipd_last_value = '0')) then     
        -- schedule n_fastclk of clk with period fastclk_period
	    sched_time := 0 ps;
	    sched_val  := '1';  -- start with rising to match cruclk
        
        k := 1; -- used to distribute rem ps to n_fastclk internals
        for i in 1 to n_fastclk loop
            fastclk <= transport sched_val after sched_time; -- rising
             
            -- wether it needs to add extra ps to the period
            tmp_fastclk_period := fastclk_period;
            if (cru_rem /= 0 and k <= cru_rem) then
               cycle_to_adjust := (n_fastclk * k) / cru_rem;
               my_rem := (n_fastclk * k) rem cru_rem;
               if (my_rem /= 0) then
                   cycle_to_adjust := cycle_to_adjust + 1;
			   end if;
                     
               if (cycle_to_adjust = i) then
                   tmp_fastclk_period := tmp_fastclk_period + 1;
                   k := k + 1;
               end if;
            end if;
                     
            high_time := tmp_fastclk_period / 2;
            low_time  := tmp_fastclk_period - high_time; 
            sched_val := not sched_val;
		    sched_time := sched_time + (high_time * 1 ps);
            fastclk <= transport sched_val after sched_time; -- falling
            sched_time := sched_time + (low_time * 1 ps);
 		    sched_val  := not sched_val;
        end loop;          
    end if; -- rising cruclk
	
	cruclk_ipd_last_value <= cruclk_ipd;
end process;

process (fastclk, areset_ipd, fbena_ipd)

variable clk_count : integer := channel_width; --follow the 1st edge
variable signaldetect_tmp : std_logic := '0';
variable clkout_last_value : std_logic;
variable	clkout_tmp : std_logic;
variable datain_ipd : std_logic;
variable last_datain : std_logic;
variable rlv_count : integer := 0; 
variable data_changed : std_logic := '0';

begin

	if (now = 0 ns) then
		data_changed :=  '0';
		clk_count := channel_width;
		clkout_tmp := '0';
		signaldetect_tmp := '1';
      for i in channel_width_max-1 downto 0 loop
			deser_data_arr(i) <= '0';
			deser_data_arr_int(i) <= '0';
		end loop;
		last_datain := 'X';
	end if;

	------------------------
	--  Timing Check Section
	------------------------

	-- for now assuming all delays on top level module

	if (areset_ipd = '1') then
		clkout_tmp :=  '0';
		clkout_last_value := fastclk;
		clk_count := channel_width;
		signaldetect_tmp := '1';
      for i in channel_width_max-1 downto 0 loop
			deser_data_arr(i) <= '0';
			deser_data_arr_int(i) <= '0';
      end loop;
		rlv_count := 0;
		rlv_flag <= '0';
		rlv_set <= '0';
		last_datain := 'X';
		data_changed := '0';
	else
		if (fbena_ipd = '1') then
			datain_ipd := fbin_ipd;
		else
			datain_ipd := databuf_ipd;
		end if;
	   if (fastclk'event and fastclk /= 'X' and fastclk /= 'U') then
			if (clkout_last_value = 'U') then
				clkout_last_value := fastclk;
				clkout_tmp := fastclk;
			elsif (clk_count = channel_width) then
				clkout_tmp := NOT (clkout_last_value);
			elsif (clk_count = channel_width/2) then
				clkout_tmp := NOT (clkout_last_value);
			elsif (clk_count < channel_width) then
				clkout_tmp := clkout_last_value;
			end if;

			if (clk_count = channel_width) then
				clk_count := 0;
			end if;

			clk_count := clk_count + 1;

			if (run_length_enable = "true") then
				if (last_datain /= datain_ipd) then
					data_changed := '1';
					last_datain := datain_ipd;
					rlv_count := 1;
					rlv_set <= '0';
				else
					rlv_count := rlv_count + 1;
					data_changed := '0';
				end if;
				if (rlv_count > rlv_length AND rlv_count > min_length) then
					rlv_set <= '1';
					rlv_flag <= '1';
				else
					rlv_flag <= rlv_flag_tmp;
				end if;
			end if;
	   end if;

	   if (fastclk'event and fastclk /= 'X'and fastclk /= 'U') then
	      for i in 1 to channel_width_max-1 loop
				deser_data_arr(i - 1) <= deser_data_arr(i);
	      end loop;
	      deser_data_arr(channel_width_max - 1) <= datain_ipd;

			deser_data_arr_int <= deser_data_arr;
	   end if;

		if (clkout_tmp /= 'U') then
			clkout_last_value := clkout_tmp;
		end if;
	end if;

	----------------------
	--  Path Delay Section
	----------------------
	
	-- for now assuming all delays on top level module

	clkout_int <= clkout_tmp;
	signaldetect <= signaldetect_tmp;
	
end process;

process (clkout_int, areset_ipd)
begin

	if (now = 0 ns) then
		dataout_tmp <= (OTHERS => '0');
      for i in channel_width_max-1 downto 0 loop
			deser_data_arr_tmp(i) <= '0';
		end loop;
		rlv_tmp1 <=  '0';
		rlv_tmp2 <=  '0';
		rlv_tmp3 <=  '0';
		rlv_flag_tmp <= '0';
	end if;

	if (areset_ipd = '1') then
		dataout_tmp <= (OTHERS => '0');
      for i in channel_width_max-1 downto 0 loop
			deser_data_arr_tmp(i) <= '0';
		end loop;
		rlv_tmp1 <=  '0';
		rlv_tmp2 <=  '0';
		rlv_tmp3 <=  '0';
	elsif (clkout_int'event and clkout_int = '1') then

		deser_data_arr_tmp <= deser_data_arr_int;

		dataout_tmp(channel_width_max-1 downto 0) <= deser_data_arr_tmp;

		if (run_length_enable = "true") then
         rlv_tmp2 <= rlv_tmp1;
         rlv_tmp3 <= rlv_tmp2;

			if (rlv_flag = '1') then
				if (rlv_set = '0') then
					rlv_flag_tmp <= '0';
				   rlv_tmp1 <= '0';
				else
				   rlv_tmp1 <= '1';
					rlv_flag_tmp <= '1';
				end if;
			else
				rlv_tmp1 <= '0';
				rlv_flag_tmp <= '0';
			end if;
		end if;
   end if;

end process;

-- q3.0ll lock and freqlock based on LTR and LTD
process (cruclk_ipd, areset_ipd)
variable cruclk_cnt : integer := 0;
begin

	if (now = 0 ns) then
        cruclk_cnt := 0;
        lock_tmp <= '1';
        freqlock_tmp <= '0';
        freqlock_tmp_dly <= '0';
        freqlock_tmp_dly1 <= '0';     
        freqlock_tmp_dly2 <= '0';     
        freqlock_tmp_dly3 <= '0';     
        freqlock_tmp_dly4 <= '0';
	end if;

	if (areset_ipd = '1') then
        cruclk_cnt := 0;
        lock_tmp <= '1';
        freqlock_tmp <= '0';
        freqlock_tmp_dly <= '0';
        freqlock_tmp_dly1 <= '0';     
        freqlock_tmp_dly2 <= '0';     
        freqlock_tmp_dly3 <= '0';     
        freqlock_tmp_dly4 <= '0';
	elsif (cruclk_ipd'event and cruclk_ipd = '1' and cruclk_ipd_last_value = '0') then
        freqlock_tmp_dly <= freqlock_tmp_dly4;
        freqlock_tmp_dly4 <= freqlock_tmp_dly3;
        freqlock_tmp_dly3 <= freqlock_tmp_dly2;
        freqlock_tmp_dly2 <= freqlock_tmp_dly1;
        freqlock_tmp_dly1 <= freqlock_tmp;

        if (cruclk_cnt = init_lock_latency) then
            if (ltd_ipd = '1') then
                freqlock_tmp <= '1';
            elsif (ltr_ipd = '1') then
                lock_tmp <= '0';
                freqlock_tmp <= '0';
            else                      -- auto switch
                lock_tmp <= '0';
                freqlock_tmp <= '1';
            end if;
        end if; 			

        -- initial latency
        if (cruclk_cnt < init_lock_latency) then
            cruclk_cnt := cruclk_cnt + 1;
        end if;
	end if;
				
end process;

rlv <= '0' WHEN (run_length_enable = "false") ELSE (rlv_tmp1 OR rlv_tmp2) WHEN (use_double_data_mode = "false") ELSE  (rlv_tmp1 OR rlv_tmp2 OR rlv_tmp3);

lock <= lock_tmp;
freqlock <= freqlock_tmp_dly;
clkout <= clkout_int;
dataout <= dataout_tmp;

end vital_rx_serdes_atom;

--
-- stratixgx_hssi_tx_serdes
--

library IEEE, stratixgx_gxb;
use IEEE.std_logic_1164.all;
use stratixgx_gxb.hssi_pack.all;

entity stratixgx_hssi_tx_serdes is
    generic (
                channel_width           : integer := 10
				);

        port (
                clk             : in std_logic := '0';
                clk1            : in std_logic := '0';
                datain          : in std_logic_vector(9 downto 0) := "0000000000";
					 serialdatain 	  : in std_logic := '0';
					 srlpbk 	  		  : in std_logic := '0';
                areset          : in std_logic := '0';
                dataout         : out std_logic
				);

end stratixgx_hssi_tx_serdes;

architecture vital_tx_serdes_atom of stratixgx_hssi_tx_serdes is
   constant shift_edge : integer := channel_width / 2;
	signal indata : std_logic_vector(channel_width-1 downto 0);
	signal regdata : std_logic_vector(9 downto 0);
   signal clk_dly : std_logic;

begin
	----------------------
	--  INPUT PATH DELAYs
	----------------------
	
	-- for now assuming all timing done at top level

VITAL_clk0_dly: process (clk)  
begin
   clk_dly <= clk;
end process;

VITAL_clk0: process (clk_dly, clk1, areset)  

variable i : integer := 0;
variable dataout_tmp : std_logic;
variable pclk_count : integer := 0;
variable shiftdata : std_logic_vector(9 downto 0);
begin

	if (now = 0 ns) then
		dataout_tmp := '0';
      for i in 9 downto 0 loop --reset register
			regdata(i) <= '0';
			shiftdata(i) := '0';
		end loop;
   end if;

   ------------------------
   --  Timing Check Section
   ------------------------
	
	-- for now assuming all timing done at top level

   if (areset = '1') then
		dataout_tmp := 'Z';
      for i in 9 downto 0 loop --reset register
			regdata(i) <= 'Z';
			shiftdata(i) := 'Z';
		end loop;
   else
      if (clk_dly'event and clk_dly = '1') then
         pclk_count := pclk_count + 1;

         if (pclk_count = shift_edge) then
             shiftdata := regdata;  
         end if;
      end if;

      if (clk_dly'event) then
         -- loading parallel data
         if (pclk_count = 1) then
      	   for i in 9 downto 0 loop 
			   	regdata(i) <= datain(9 - i);
			   end loop;
         end if;

         if (srlpbk = '1') then
            dataout_tmp := serialdatain;
         else
            dataout_tmp := shiftdata(9);
         end if;

         for i in 9 downto (10 - channel_width + 1) loop
				shiftdata(i) := shiftdata(i-1);
			end loop;
      end if;

      if (clk1'event and clk1 = '1') then  -- rising edge
         pclk_count := 0;
      end if;
   end if;

   ----------------------
   --  Path Delay Section
   ----------------------

	-- for now assuming all delays on top level module

	dataout <= dataout_tmp;
	
end process;

end vital_tx_serdes_atom;

--IP Functional Simulation Model
--VERSION_BEGIN 4.1 cbx_mgl 2004:06:17:17:30:06:SJ cbx_simgen 2004:06:22:10:53:08:SJ  VERSION_END


-- Legal Notice: © 2003 Altera Corporation. All rights reserved.
-- You may only use these  simulation  model  output files for simulation
-- purposes and expressly not for synthesis or any other purposes (in which
-- event  Altera disclaims all warranties of any kind). Your use of  Altera
-- Corporation's design tools, logic functions and other software and tools,
-- and its AMPP partner logic functions, and any output files any of the
-- foregoing (including device programming or simulation files), and any
-- associated documentation or information  are expressly subject to the
-- terms and conditions of the  Altera Program License Subscription Agreement
-- or other applicable license agreement, including, without limitation, that
-- your use is for the sole purpose of programming logic devices manufactured
-- by Altera and sold by Altera or its authorized distributors.  Please refer
-- to the applicable agreement for further details.


--synopsys translate_off

--synthesis_resources = lut 137 mux21 348 
 LIBRARY ieee;
 USE ieee.std_logic_1164.all;

 ENTITY  stratixgx_xgm_rx_sm IS 
	 PORT 
	 ( 
		 resetall	:	IN  STD_LOGIC;
		 rxclk	:	IN  STD_LOGIC;
		 rxctrl	:	IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
		 rxctrlout	:	OUT  STD_LOGIC_VECTOR (3 DOWNTO 0);
		 rxdatain	:	IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
		 rxdataout	:	OUT  STD_LOGIC_VECTOR (31 DOWNTO 0);
		 rxdatavalid	:	IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
		 rxrunningdisp	:	IN  STD_LOGIC_VECTOR (3 DOWNTO 0)
	 ); 
 END stratixgx_xgm_rx_sm;

 ARCHITECTURE RTL OF stratixgx_xgm_rx_sm IS

	 ATTRIBUTE synthesis_clearbox : boolean;
	 ATTRIBUTE synthesis_clearbox OF RTL : ARCHITECTURE IS true;
	 SIGNAL	n000i	:	STD_LOGIC := '0';
	 SIGNAL	n000l	:	STD_LOGIC := '0';
	 SIGNAL	n000O	:	STD_LOGIC := '0';
	 SIGNAL	n00ii	:	STD_LOGIC := '0';
	 SIGNAL	n00il	:	STD_LOGIC := '0';
	 SIGNAL	n00iO	:	STD_LOGIC := '0';
	 SIGNAL	n00li	:	STD_LOGIC := '0';
	 SIGNAL	n0li	:	STD_LOGIC := '0';
	 SIGNAL	n0ll	:	STD_LOGIC := '0';
	 SIGNAL	n0OO	:	STD_LOGIC := '0';
	 SIGNAL	n110i	:	STD_LOGIC := '0';
	 SIGNAL	n110l	:	STD_LOGIC := '0';
	 SIGNAL	n110O	:	STD_LOGIC := '0';
	 SIGNAL	n111i	:	STD_LOGIC := '0';
	 SIGNAL	n111l	:	STD_LOGIC := '0';
	 SIGNAL	n111O	:	STD_LOGIC := '0';
	 SIGNAL	n11ii	:	STD_LOGIC := '0';
	 SIGNAL	n11il	:	STD_LOGIC := '0';
	 SIGNAL	n1lOi	:	STD_LOGIC := '0';
	 SIGNAL	n1lOl	:	STD_LOGIC := '0';
	 SIGNAL	n1lOO	:	STD_LOGIC := '0';
	 SIGNAL	n1O1i	:	STD_LOGIC := '0';
	 SIGNAL	n1O1l	:	STD_LOGIC := '0';
	 SIGNAL	ni10O	:	STD_LOGIC := '0';
	 SIGNAL	ni1ii	:	STD_LOGIC := '0';
	 SIGNAL	ni1il	:	STD_LOGIC := '0';
	 SIGNAL	ni1iO	:	STD_LOGIC := '0';
	 SIGNAL	ni1li	:	STD_LOGIC := '0';
	 SIGNAL	ni1ll	:	STD_LOGIC := '0';
	 SIGNAL	ni1lO	:	STD_LOGIC := '0';
	 SIGNAL	ni1Oi	:	STD_LOGIC := '0';
	 SIGNAL	ni1Ol	:	STD_LOGIC := '0';
	 SIGNAL	niOli	:	STD_LOGIC := '0';
	 SIGNAL	niOll	:	STD_LOGIC := '0';
	 SIGNAL	niOlO	:	STD_LOGIC := '0';
	 SIGNAL	niOOi	:	STD_LOGIC := '0';
	 SIGNAL	niOOl	:	STD_LOGIC := '0';
	 SIGNAL	niOOO	:	STD_LOGIC := '0';
	 SIGNAL	nl0iiO58	:	STD_LOGIC := '1';
	 SIGNAL	nl0iiO59	:	STD_LOGIC := '0';
	 SIGNAL	nl0iiO60	:	STD_LOGIC := '0';
	 SIGNAL	nl0ilO55	:	STD_LOGIC := '1';
	 SIGNAL	nl0ilO56	:	STD_LOGIC := '0';
	 SIGNAL	nl0ilO57	:	STD_LOGIC := '0';
	 SIGNAL	nl0iOO52	:	STD_LOGIC := '1';
	 SIGNAL	nl0iOO53	:	STD_LOGIC := '0';
	 SIGNAL	nl0iOO54	:	STD_LOGIC := '0';
	 SIGNAL	nl0l0O49	:	STD_LOGIC := '1';
	 SIGNAL	nl0l0O50	:	STD_LOGIC := '0';
	 SIGNAL	nl0l0O51	:	STD_LOGIC := '0';
	 SIGNAL	nl0lll46	:	STD_LOGIC := '1';
	 SIGNAL	nl0lll47	:	STD_LOGIC := '0';
	 SIGNAL	nl0lll48	:	STD_LOGIC := '0';
	 SIGNAL	nl0lOi43	:	STD_LOGIC := '1';
	 SIGNAL	nl0lOi44	:	STD_LOGIC := '0';
	 SIGNAL	nl0lOi45	:	STD_LOGIC := '0';
	 SIGNAL	nl0lOO40	:	STD_LOGIC := '1';
	 SIGNAL	nl0lOO41	:	STD_LOGIC := '0';
	 SIGNAL	nl0lOO42	:	STD_LOGIC := '0';
	 SIGNAL	nl0O0i34	:	STD_LOGIC := '1';
	 SIGNAL	nl0O0i35	:	STD_LOGIC := '0';
	 SIGNAL	nl0O0i36	:	STD_LOGIC := '0';
	 SIGNAL	nl0O1l37	:	STD_LOGIC := '1';
	 SIGNAL	nl0O1l38	:	STD_LOGIC := '0';
	 SIGNAL	nl0O1l39	:	STD_LOGIC := '0';
	 SIGNAL	nl0Oii31	:	STD_LOGIC := '1';
	 SIGNAL	nl0Oii32	:	STD_LOGIC := '0';
	 SIGNAL	nl0Oii33	:	STD_LOGIC := '0';
	 SIGNAL	nl0Oll28	:	STD_LOGIC := '1';
	 SIGNAL	nl0Oll29	:	STD_LOGIC := '0';
	 SIGNAL	nl0Oll30	:	STD_LOGIC := '0';
	 SIGNAL	nl0OOl25	:	STD_LOGIC := '1';
	 SIGNAL	nl0OOl26	:	STD_LOGIC := '0';
	 SIGNAL	nl0OOl27	:	STD_LOGIC := '0';
	 SIGNAL	nl11i	:	STD_LOGIC := '0';
	 SIGNAL	nl11l	:	STD_LOGIC := '0';
	 SIGNAL	nl11O	:	STD_LOGIC := '0';
	 SIGNAL	nli01O10	:	STD_LOGIC := '1';
	 SIGNAL	nli01O11	:	STD_LOGIC := '0';
	 SIGNAL	nli01O12	:	STD_LOGIC := '0';
	 SIGNAL	nli0ii7	:	STD_LOGIC := '1';
	 SIGNAL	nli0ii8	:	STD_LOGIC := '0';
	 SIGNAL	nli0ii9	:	STD_LOGIC := '0';
	 SIGNAL	nli0li4	:	STD_LOGIC := '1';
	 SIGNAL	nli0li5	:	STD_LOGIC := '0';
	 SIGNAL	nli0li6	:	STD_LOGIC := '0';
	 SIGNAL	nli10l19	:	STD_LOGIC := '1';
	 SIGNAL	nli10l20	:	STD_LOGIC := '0';
	 SIGNAL	nli10l21	:	STD_LOGIC := '0';
	 SIGNAL	nli11l22	:	STD_LOGIC := '1';
	 SIGNAL	nli11l23	:	STD_LOGIC := '0';
	 SIGNAL	nli11l24	:	STD_LOGIC := '0';
	 SIGNAL	nli1ll16	:	STD_LOGIC := '1';
	 SIGNAL	nli1ll17	:	STD_LOGIC := '0';
	 SIGNAL	nli1ll18	:	STD_LOGIC := '0';
	 SIGNAL	nli1OO13	:	STD_LOGIC := '1';
	 SIGNAL	nli1OO14	:	STD_LOGIC := '0';
	 SIGNAL	nli1OO15	:	STD_LOGIC := '0';
	 SIGNAL	nlii1i1	:	STD_LOGIC := '1';
	 SIGNAL	nlii1i2	:	STD_LOGIC := '0';
	 SIGNAL	nlii1i3	:	STD_LOGIC := '0';
	 SIGNAL	nllilO	:	STD_LOGIC := '0';
	 SIGNAL	nlliOi	:	STD_LOGIC := '0';
	 SIGNAL	nlliOl	:	STD_LOGIC := '0';
	 SIGNAL	nlliOO	:	STD_LOGIC := '0';
	 SIGNAL	nlll0i	:	STD_LOGIC := '0';
	 SIGNAL	nlll0l	:	STD_LOGIC := '0';
	 SIGNAL	nlll0O	:	STD_LOGIC := '0';
	 SIGNAL	nlll1i	:	STD_LOGIC := '0';
	 SIGNAL	nlll1l	:	STD_LOGIC := '0';
	 SIGNAL	nlll1O	:	STD_LOGIC := '0';
	 SIGNAL	nlllii	:	STD_LOGIC := '0';
	 SIGNAL	nlllil	:	STD_LOGIC := '0';
	 SIGNAL	nllliO	:	STD_LOGIC := '0';
	 SIGNAL	nlllli	:	STD_LOGIC := '0';
	 SIGNAL	nlllll	:	STD_LOGIC := '0';
	 SIGNAL	nllllO	:	STD_LOGIC := '0';
	 SIGNAL	nlllOi	:	STD_LOGIC := '0';
	 SIGNAL	nlllOl	:	STD_LOGIC := '0';
	 SIGNAL	nlllOO	:	STD_LOGIC := '0';
	 SIGNAL	nllO1i	:	STD_LOGIC := '0';
	 SIGNAL	nllO1l	:	STD_LOGIC := '0';
	 SIGNAL	nllOl	:	STD_LOGIC := '0';
	 SIGNAL	nllOO	:	STD_LOGIC := '0';
	 SIGNAL	nlO00i	:	STD_LOGIC := '0';
	 SIGNAL	nlO00l	:	STD_LOGIC := '0';
	 SIGNAL	nlO00O	:	STD_LOGIC := '0';
	 SIGNAL	nlO01O	:	STD_LOGIC := '0';
	 SIGNAL	nlO0ii	:	STD_LOGIC := '0';
	 SIGNAL	nlO0il	:	STD_LOGIC := '0';
	 SIGNAL	nlO0iO	:	STD_LOGIC := '0';
	 SIGNAL	nlO0li	:	STD_LOGIC := '0';
	 SIGNAL	nlO0ll	:	STD_LOGIC := '0';
	 SIGNAL	nlO1i	:	STD_LOGIC := '0';
	 SIGNAL	nlO1l	:	STD_LOGIC := '0';
	 SIGNAL	nlO1O	:	STD_LOGIC := '0';
	 SIGNAL	nlOOOO	:	STD_LOGIC := '0';
	 SIGNAL	wire_n00i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n010i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n010l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n010O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n011i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n011l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n011O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0i0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0i0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0i0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0i1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0i1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0i1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0iii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0iil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0iiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0ili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0ill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0ilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0iOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0iOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0iOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0liO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0llO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0Oii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0Oil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0Oli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0Oll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n100i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n100l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n100O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n101i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n101l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n101O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1iii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1iil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1iiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1ili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1ill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1ilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1iOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1iOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1l0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1l0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1l0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1l1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1lii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1lil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1liO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1lli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1lll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1O0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1O0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1O0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1O1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1Oii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1Oil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1OiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1Oli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1Oll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1OlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1OOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1OOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1OOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni00i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni00l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni00O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni01i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni01l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni01O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0i_dataout	:	STD_LOGIC;
	 SIGNAL  wire_ni0i_w_lg_dataout309w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_ni0ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni10i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni11i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni11l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni11O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1i_dataout	:	STD_LOGIC;
	 SIGNAL  wire_ni1i_w_lg_dataout248w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_ni1l_dataout	:	STD_LOGIC;
	 SIGNAL  wire_ni1l_w_lg_dataout266w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_ni1O_dataout	:	STD_LOGIC;
	 SIGNAL  wire_ni1O_w_lg_dataout277w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_ni1OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niliO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nillO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl00i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl00l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl00O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl01i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl01l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl01O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl10i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl10l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl10O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlliO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlllO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllO0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllO0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllO0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllO1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO10i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO10l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO10O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO11i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO11l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO11O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOi0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOi0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOi0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOi1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOi1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOi1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOliO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOllO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOOi_dataout	:	STD_LOGIC;
	 SIGNAL  wire_w_lg_w_lg_w_rxctrl_range110w311w315w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_rxctrl_range110w311w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl0ill308w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl0iOl310w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl0l0l264w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl0l1O275w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl0liO249w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl0lli307w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_resetall295w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nl0iOO288w289w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nl0l0O261w262w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nl0lll237w238w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nl0lOi227w228w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nl0lOO219w220w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nl0O0i206w207w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nl0O1l213w214w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nl0Oii193w194w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nl0Oll184w185w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nl0OOl177w178w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nli01O107w108w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nli0ii79w80w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nli0li54w55w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nli10l152w153w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nli11l165w166w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nli1ll129w130w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nli1OO115w116w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nlii1i23w24w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_rxctrl_range26w27w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_rxctrl_range49w50w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_rxctrl_range82w83w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_rxctrl_range110w111w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_rxctrl_range26w27w231w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_rxctrl_range26w27w126w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_rxctrl_range49w50w224w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_rxctrl_range49w50w51w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_rxctrl_range82w83w222w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_rxctrl_range82w83w149w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_rxctrl_range110w111w216w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_rxctrl_range110w111w112w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_rxctrl_range110w111w198w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_nli1Ol201w202w203w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_nli10i196w197w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_nli1Ol201w202w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nli10i196w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nli1Ol201w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  nl00ll :	STD_LOGIC;
	 SIGNAL  nl00lO :	STD_LOGIC;
	 SIGNAL  nl00Oi :	STD_LOGIC;
	 SIGNAL  nl00Ol :	STD_LOGIC;
	 SIGNAL  nl00OO :	STD_LOGIC;
	 SIGNAL  nl0i0i :	STD_LOGIC;
	 SIGNAL  nl0i0l :	STD_LOGIC;
	 SIGNAL  nl0i0O :	STD_LOGIC;
	 SIGNAL  nl0i1i :	STD_LOGIC;
	 SIGNAL  nl0i1l :	STD_LOGIC;
	 SIGNAL  nl0i1O :	STD_LOGIC;
	 SIGNAL  nl0iii :	STD_LOGIC;
	 SIGNAL  nl0iil :	STD_LOGIC;
	 SIGNAL  nl0ill :	STD_LOGIC;
	 SIGNAL  nl0iOl :	STD_LOGIC;
	 SIGNAL  nl0l0i :	STD_LOGIC;
	 SIGNAL  nl0l0l :	STD_LOGIC;
	 SIGNAL  nl0l1l :	STD_LOGIC;
	 SIGNAL  nl0l1O :	STD_LOGIC;
	 SIGNAL  nl0lil :	STD_LOGIC;
	 SIGNAL  nl0liO :	STD_LOGIC;
	 SIGNAL  nl0lli :	STD_LOGIC;
	 SIGNAL  nl0O0O :	STD_LOGIC;
	 SIGNAL  nl0OiO :	STD_LOGIC;
	 SIGNAL  nl0Oli :	STD_LOGIC;
	 SIGNAL  nl0OOi :	STD_LOGIC;
	 SIGNAL  nli00l :	STD_LOGIC;
	 SIGNAL  nli00O :	STD_LOGIC;
	 SIGNAL  nli01l :	STD_LOGIC;
	 SIGNAL  nli0iO :	STD_LOGIC;
	 SIGNAL  nli0lO :	STD_LOGIC;
	 SIGNAL  nli0Oi :	STD_LOGIC;
	 SIGNAL  nli0Ol :	STD_LOGIC;
	 SIGNAL  nli0OO :	STD_LOGIC;
	 SIGNAL  nli10i :	STD_LOGIC;
	 SIGNAL  nli11i :	STD_LOGIC;
	 SIGNAL  nli1ii :	STD_LOGIC;
	 SIGNAL  nli1il :	STD_LOGIC;
	 SIGNAL  nli1iO :	STD_LOGIC;
	 SIGNAL  nli1li :	STD_LOGIC;
	 SIGNAL  nli1Oi :	STD_LOGIC;
	 SIGNAL  nli1Ol :	STD_LOGIC;
	 SIGNAL  w_nl0iiO314w :	STD_LOGIC;
	 SIGNAL  w_nl0ilO305w :	STD_LOGIC;
	 SIGNAL  w_nl0iOO288w :	STD_LOGIC;
	 SIGNAL  w_nl0l0O261w :	STD_LOGIC;
	 SIGNAL  w_nl0lll237w :	STD_LOGIC;
	 SIGNAL  w_nl0lOi227w :	STD_LOGIC;
	 SIGNAL  w_nl0lOO219w :	STD_LOGIC;
	 SIGNAL  w_nl0O0i206w :	STD_LOGIC;
	 SIGNAL  w_nl0O1l213w :	STD_LOGIC;
	 SIGNAL  w_nl0Oii193w :	STD_LOGIC;
	 SIGNAL  w_nl0Oll184w :	STD_LOGIC;
	 SIGNAL  w_nl0OOl177w :	STD_LOGIC;
	 SIGNAL  w_nli01O107w :	STD_LOGIC;
	 SIGNAL  w_nli0ii79w :	STD_LOGIC;
	 SIGNAL  w_nli0li54w :	STD_LOGIC;
	 SIGNAL  w_nli10l152w :	STD_LOGIC;
	 SIGNAL  w_nli11l165w :	STD_LOGIC;
	 SIGNAL  w_nli1ll129w :	STD_LOGIC;
	 SIGNAL  w_nli1OO115w :	STD_LOGIC;
	 SIGNAL  w_nlii1i23w :	STD_LOGIC;
	 SIGNAL  wire_w_rxctrl_range26w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_rxctrl_range49w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_rxctrl_range82w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_rxctrl_range110w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
 BEGIN

	wire_w_lg_w_lg_w_rxctrl_range110w311w315w(0) <= wire_w_lg_w_rxctrl_range110w311w(0) AND w_nl0iiO314w;
	wire_w_lg_w_rxctrl_range110w311w(0) <= wire_w_rxctrl_range110w(0) AND wire_w_lg_nl0iOl310w(0);
	wire_w_lg_nl0ill308w(0) <= NOT nl0ill;
	wire_w_lg_nl0iOl310w(0) <= NOT nl0iOl;
	wire_w_lg_nl0l0l264w(0) <= NOT nl0l0l;
	wire_w_lg_nl0l1O275w(0) <= NOT nl0l1O;
	wire_w_lg_nl0liO249w(0) <= NOT nl0liO;
	wire_w_lg_nl0lli307w(0) <= NOT nl0lli;
	wire_w_lg_resetall295w(0) <= NOT resetall;
	wire_w_lg_w_nl0iOO288w289w(0) <= NOT w_nl0iOO288w;
	wire_w_lg_w_nl0l0O261w262w(0) <= NOT w_nl0l0O261w;
	wire_w_lg_w_nl0lll237w238w(0) <= NOT w_nl0lll237w;
	wire_w_lg_w_nl0lOi227w228w(0) <= NOT w_nl0lOi227w;
	wire_w_lg_w_nl0lOO219w220w(0) <= NOT w_nl0lOO219w;
	wire_w_lg_w_nl0O0i206w207w(0) <= NOT w_nl0O0i206w;
	wire_w_lg_w_nl0O1l213w214w(0) <= NOT w_nl0O1l213w;
	wire_w_lg_w_nl0Oii193w194w(0) <= NOT w_nl0Oii193w;
	wire_w_lg_w_nl0Oll184w185w(0) <= NOT w_nl0Oll184w;
	wire_w_lg_w_nl0OOl177w178w(0) <= NOT w_nl0OOl177w;
	wire_w_lg_w_nli01O107w108w(0) <= NOT w_nli01O107w;
	wire_w_lg_w_nli0ii79w80w(0) <= NOT w_nli0ii79w;
	wire_w_lg_w_nli0li54w55w(0) <= NOT w_nli0li54w;
	wire_w_lg_w_nli10l152w153w(0) <= NOT w_nli10l152w;
	wire_w_lg_w_nli11l165w166w(0) <= NOT w_nli11l165w;
	wire_w_lg_w_nli1ll129w130w(0) <= NOT w_nli1ll129w;
	wire_w_lg_w_nli1OO115w116w(0) <= NOT w_nli1OO115w;
	wire_w_lg_w_nlii1i23w24w(0) <= NOT w_nlii1i23w;
	wire_w_lg_w_rxctrl_range26w27w(0) <= NOT wire_w_rxctrl_range26w(0);
	wire_w_lg_w_rxctrl_range49w50w(0) <= NOT wire_w_rxctrl_range49w(0);
	wire_w_lg_w_rxctrl_range82w83w(0) <= NOT wire_w_rxctrl_range82w(0);
	wire_w_lg_w_rxctrl_range110w111w(0) <= NOT wire_w_rxctrl_range110w(0);
	wire_w_lg_w_lg_w_rxctrl_range26w27w231w(0) <= wire_w_lg_w_rxctrl_range26w27w(0) OR nl0OOi;
	wire_w_lg_w_lg_w_rxctrl_range26w27w126w(0) <= wire_w_lg_w_rxctrl_range26w27w(0) OR nli1Oi;
	wire_w_lg_w_lg_w_rxctrl_range49w50w224w(0) <= wire_w_lg_w_rxctrl_range49w50w(0) OR nl0Oli;
	wire_w_lg_w_lg_w_rxctrl_range49w50w51w(0) <= wire_w_lg_w_rxctrl_range49w50w(0) OR nli0lO;
	wire_w_lg_w_lg_w_rxctrl_range82w83w222w(0) <= wire_w_lg_w_rxctrl_range82w83w(0) OR nl0OiO;
	wire_w_lg_w_lg_w_rxctrl_range82w83w149w(0) <= wire_w_lg_w_rxctrl_range82w83w(0) OR nli1ii;
	wire_w_lg_w_lg_w_rxctrl_range110w111w216w(0) <= wire_w_lg_w_rxctrl_range110w111w(0) OR nl0O0O;
	wire_w_lg_w_lg_w_rxctrl_range110w111w112w(0) <= wire_w_lg_w_rxctrl_range110w111w(0) OR nli01l;
	wire_w_lg_w_lg_w_rxctrl_range110w111w198w(0) <= wire_w_lg_w_rxctrl_range110w111w(0) OR nli11i;
	wire_w_lg_w_lg_w_lg_nli1Ol201w202w203w(0) <= wire_w_lg_w_lg_nli1Ol201w202w(0) OR nli0Oi;
	wire_w_lg_w_lg_nli10i196w197w(0) <= wire_w_lg_nli10i196w(0) OR nli1li;
	wire_w_lg_w_lg_nli1Ol201w202w(0) <= wire_w_lg_nli1Ol201w(0) OR nli0iO;
	wire_w_lg_nli10i196w(0) <= nli10i OR nli1il;
	wire_w_lg_nli1Ol201w(0) <= nli1Ol OR nli00l;
	nl00ll <= (wire_ni0i_dataout OR nli1Ol);
	nl00lO <= (nl0l1l OR nl00Oi);
	nl00Oi <= (nl0l0i OR nl0lil);
	nl00Ol <= (wire_ni1O_dataout OR (nli10i AND nli00l));
	nl00OO <= (wire_ni1O_dataout OR nli00l);
	nl0i0i <= (wire_ni1i_dataout OR (nli1li AND nli0Oi));
	nl0i0l <= (n0li OR (n0ll OR n0OO));
	nl0i0O <= (nl0l1l OR nl0iii);
	nl0i1i <= (wire_ni1l_dataout OR (nli1il AND nli0iO));
	nl0i1l <= (n0li OR n0ll);
	nl0i1O <= (wire_ni1l_dataout OR nli0iO);
	nl0iii <= (nl0l0i OR nl0iil);
	nl0iil <= (nl0lil OR nl0lli);
	nl0ill <= ((((rxdatavalid(3) AND rxdatavalid(2)) AND rxdatavalid(1)) AND rxdatavalid(0)) AND w_nl0ilO305w);
	nl0iOl <= (((((((((NOT rxdatain(31)) OR rxdatain(25)) OR (NOT rxdatain(24))) OR (NOT rxdatain(26))) OR (NOT rxdatain(27))) OR (NOT rxdatain(28))) OR (NOT rxdatain(29))) OR (NOT rxdatain(30))) OR wire_w_lg_w_nl0iOO288w289w(0));
	nl0l0i <= ((rxctrl(1) AND wire_w_lg_nl0l0l264w(0)) AND wire_ni1l_w_lg_dataout266w(0));
	nl0l0l <= (((((((((NOT rxdatain(15)) OR rxdatain(9)) OR (NOT rxdatain(8))) OR (NOT rxdatain(10))) OR (NOT rxdatain(11))) OR (NOT rxdatain(12))) OR (NOT rxdatain(13))) OR (NOT rxdatain(14))) OR wire_w_lg_w_nl0l0O261w262w(0));
	nl0l1l <= ((rxctrl(2) AND wire_w_lg_nl0l1O275w(0)) AND wire_ni1O_w_lg_dataout277w(0));
	nl0l1O <= ((((((((NOT rxdatain(23)) OR rxdatain(17)) OR (NOT rxdatain(16))) OR (NOT rxdatain(18))) OR (NOT rxdatain(19))) OR (NOT rxdatain(20))) OR (NOT rxdatain(21))) OR (NOT rxdatain(22)));
	nl0lil <= (wire_ni1i_w_lg_dataout248w(0) AND (rxctrl(0) AND wire_w_lg_nl0liO249w(0)));
	nl0liO <= ((((((((NOT rxdatain(6)) OR (NOT rxdatain(7))) OR rxdatain(1)) OR (NOT rxdatain(0))) OR (NOT rxdatain(2))) OR (NOT rxdatain(3))) OR (NOT rxdatain(4))) OR (NOT rxdatain(5)));
	nl0lli <= (((((NOT (wire_w_lg_w_lg_nli10i196w197w(0) OR wire_w_lg_w_lg_w_rxctrl_range110w111w198w(0))) OR (NOT (wire_w_lg_w_lg_w_lg_nli1Ol201w202w203w(0) OR wire_w_lg_w_nl0O0i206w207w(0)))) OR wire_w_lg_w_nl0O1l213w214w(0)) OR (NOT ((((wire_w_lg_w_lg_w_rxctrl_range110w111w216w(0) OR wire_w_lg_w_nl0lOO219w220w(0)) OR wire_w_lg_w_lg_w_rxctrl_range82w83w222w(0)) OR (wire_w_lg_w_lg_w_rxctrl_range49w50w224w(0) OR wire_w_lg_w_nl0lOi227w228w(0))) OR wire_w_lg_w_lg_w_rxctrl_range26w27w231w(0)))) OR wire_w_lg_w_nl0lll237w238w(0));
	nl0O0O <= ((((((((rxdatain(31) OR rxdatain(25)) OR rxdatain(24)) OR (NOT rxdatain(26))) OR (NOT rxdatain(27))) OR (NOT rxdatain(28))) OR rxdatain(29)) OR rxdatain(30)) OR wire_w_lg_w_nl0Oii193w194w(0));
	nl0OiO <= (((((((rxdatain(23) OR rxdatain(17)) OR rxdatain(16)) OR (NOT rxdatain(18))) OR (NOT rxdatain(19))) OR (NOT rxdatain(20))) OR rxdatain(21)) OR rxdatain(22));
	nl0Oli <= ((((((((rxdatain(15) OR rxdatain(9)) OR rxdatain(8)) OR (NOT rxdatain(10))) OR (NOT rxdatain(11))) OR (NOT rxdatain(12))) OR rxdatain(13)) OR rxdatain(14)) OR wire_w_lg_w_nl0Oll184w185w(0));
	nl0OOi <= ((((((((rxdatain(6) OR rxdatain(7)) OR rxdatain(1)) OR rxdatain(0)) OR (NOT rxdatain(2))) OR (NOT rxdatain(3))) OR (NOT rxdatain(4))) OR rxdatain(5)) OR wire_w_lg_w_nl0OOl177w178w(0));
	nli00l <= (wire_w_lg_w_rxctrl_range82w83w(0) OR nli00O);
	nli00O <= (((((((((NOT rxdatain(23)) OR rxdatain(17)) OR rxdatain(16)) OR (NOT rxdatain(18))) OR (NOT rxdatain(19))) OR (NOT rxdatain(20))) OR (NOT rxdatain(21))) OR rxdatain(22)) OR wire_w_lg_w_nli0ii79w80w(0));
	nli01l <= (((((((((NOT rxdatain(31)) OR rxdatain(25)) OR rxdatain(24)) OR (NOT rxdatain(26))) OR (NOT rxdatain(27))) OR (NOT rxdatain(28))) OR (NOT rxdatain(29))) OR rxdatain(30)) OR wire_w_lg_w_nli01O107w108w(0));
	nli0iO <= (wire_w_lg_w_lg_w_rxctrl_range49w50w51w(0) OR wire_w_lg_w_nli0li54w55w(0));
	nli0lO <= ((((((((NOT rxdatain(15)) OR rxdatain(9)) OR rxdatain(8)) OR (NOT rxdatain(10))) OR (NOT rxdatain(11))) OR (NOT rxdatain(12))) OR (NOT rxdatain(13))) OR rxdatain(14));
	nli0Oi <= (wire_w_lg_w_rxctrl_range26w27w(0) OR nli0Ol);
	nli0Ol <= ((((((((rxdatain(6) OR (NOT rxdatain(7))) OR rxdatain(1)) OR rxdatain(0)) OR (NOT rxdatain(2))) OR (NOT rxdatain(3))) OR (NOT rxdatain(4))) OR (NOT rxdatain(5))) OR wire_w_lg_w_nlii1i23w24w(0));
	nli0OO <= rxclk;
	nli10i <= (wire_w_lg_w_lg_w_rxctrl_range82w83w149w(0) OR wire_w_lg_w_nli10l152w153w(0));
	nli11i <= ((((((((rxdatain(31) OR rxdatain(25)) OR rxdatain(24)) OR (NOT rxdatain(26))) OR (NOT rxdatain(27))) OR (NOT rxdatain(28))) OR (NOT rxdatain(29))) OR (NOT rxdatain(30))) OR wire_w_lg_w_nli11l165w166w(0));
	nli1ii <= (((((((rxdatain(23) OR rxdatain(17)) OR rxdatain(16)) OR (NOT rxdatain(18))) OR (NOT rxdatain(19))) OR (NOT rxdatain(20))) OR (NOT rxdatain(21))) OR (NOT rxdatain(22)));
	nli1il <= (wire_w_lg_w_rxctrl_range49w50w(0) OR nli1iO);
	nli1iO <= (((((((rxdatain(15) OR rxdatain(9)) OR rxdatain(8)) OR (NOT rxdatain(10))) OR (NOT rxdatain(11))) OR (NOT rxdatain(12))) OR (NOT rxdatain(13))) OR (NOT rxdatain(14)));
	nli1li <= (wire_w_lg_w_lg_w_rxctrl_range26w27w126w(0) OR wire_w_lg_w_nli1ll129w130w(0));
	nli1Oi <= ((((((((NOT rxdatain(6)) OR rxdatain(7)) OR rxdatain(1)) OR rxdatain(0)) OR (NOT rxdatain(2))) OR (NOT rxdatain(3))) OR (NOT rxdatain(4))) OR (NOT rxdatain(5)));
	nli1Ol <= (wire_w_lg_w_lg_w_rxctrl_range110w111w112w(0) OR wire_w_lg_w_nli1OO115w116w(0));
	rxctrlout <= ( nlllll & nlO00i & n111i & nlliOi);
	rxdataout <= ( nlO01O & nllO1l & nllO1i & nlllOO & nlllOl & nlllOi & nllllO & nllilO & nlOOOO & nlO0ll & nlO0li & nlO0iO & nlO0il & nlO0ii & nlO00O & nlO00l & n1lOi & n11il & n11ii & n110O & n110l & n110i & n111O & n111l & nlll1l & n1O1l & n1O1i & nlll1i & nlliOO & nlliOl & n1lOO & n1lOl);
	w_nl0iiO314w <= nl0iiO60;
	w_nl0ilO305w <= nl0ilO57;
	w_nl0iOO288w <= nl0iOO54;
	w_nl0l0O261w <= nl0l0O51;
	w_nl0lll237w <= nl0lll48;
	w_nl0lOi227w <= nl0lOi45;
	w_nl0lOO219w <= nl0lOO42;
	w_nl0O0i206w <= nl0O0i36;
	w_nl0O1l213w <= nl0O1l39;
	w_nl0Oii193w <= nl0Oii33;
	w_nl0Oll184w <= nl0Oll30;
	w_nl0OOl177w <= nl0OOl27;
	w_nli01O107w <= nli01O12;
	w_nli0ii79w <= nli0ii9;
	w_nli0li54w <= nli0li6;
	w_nli10l152w <= nli10l21;
	w_nli11l165w <= nli11l24;
	w_nli1ll129w <= nli1ll18;
	w_nli1OO115w <= nli1OO15;
	w_nlii1i23w <= nlii1i3;
	wire_w_rxctrl_range26w(0) <= rxctrl(0);
	wire_w_rxctrl_range49w(0) <= rxctrl(1);
	wire_w_rxctrl_range82w(0) <= rxctrl(2);
	wire_w_rxctrl_range110w(0) <= rxctrl(3);
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n000i <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN n000i <= wire_n00ll_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n000l <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN n000l <= wire_n00Oi_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n000O <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN n000O <= wire_n00Ol_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n00ii <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN n00ii <= wire_n00OO_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n00il <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN n00il <= wire_n0i1i_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n00iO <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN n00iO <= wire_n0i1l_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n00li <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN n00li <= wire_n0i1O_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n0li <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN n0li <= (wire_ni0i_w_lg_dataout309w(0) AND wire_w_lg_w_lg_w_rxctrl_range110w311w315w(0));
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n0ll <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN n0ll <= nl0l1l;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n0OO <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN n0OO <= nl0l0i;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n110i <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN n110i <= wire_n11lO_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n110l <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN n110l <= wire_n11Oi_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n110O <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN n110O <= wire_n11Ol_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n111i <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN n111i <= wire_n11iO_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n111l <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN n111l <= wire_n11li_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n111O <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN n111O <= wire_n11ll_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n11ii <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN n11ii <= wire_n11OO_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n11il <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN n11il <= wire_n101i_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n1lOi <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN n1lOi <= wire_n101l_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n1lOl <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN n1lOl <= wire_n1O0i_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n1lOO <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN n1lOO <= wire_n1O0l_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n1O1i <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN n1O1i <= wire_n1OiO_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n1O1l <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN n1O1l <= wire_n1Oli_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN ni10O <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN ni10O <= wire_n0i0i_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN ni1ii <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN ni1ii <= wire_ni1OO_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN ni1il <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN ni1il <= wire_ni01i_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN ni1iO <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN ni1iO <= wire_ni01l_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN ni1li <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN ni1li <= wire_ni01O_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN ni1ll <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN ni1ll <= wire_ni00i_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN ni1lO <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN ni1lO <= wire_ni00l_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN ni1Oi <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN ni1Oi <= wire_ni00O_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN ni1Ol <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN ni1Ol <= wire_ni0ii_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN niOli <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN niOli <= wire_ni0il_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN niOll <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN niOll <= wire_nl10i_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN niOlO <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN niOlO <= wire_nl10l_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN niOOi <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN niOOi <= wire_nl10O_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN niOOl <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN niOOl <= wire_nl1ii_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN niOOO <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN niOOO <= wire_nl1il_dataout;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0iiO58 <= nl0iiO59;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0iiO59 <= nl0iiO58;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0iiO60 <= (nl0iiO59 XOR nl0iiO58);
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0ilO55 <= nl0ilO56;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0ilO56 <= nl0ilO55;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0ilO57 <= (nl0ilO56 XOR nl0ilO55);
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0iOO52 <= nl0iOO53;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0iOO53 <= nl0iOO52;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0iOO54 <= (nl0iOO53 XOR nl0iOO52);
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0l0O49 <= nl0l0O50;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0l0O50 <= nl0l0O49;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0l0O51 <= (nl0l0O50 XOR nl0l0O49);
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0lll46 <= nl0lll47;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0lll47 <= nl0lll46;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0lll48 <= (nl0lll47 XOR nl0lll46);
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0lOi43 <= nl0lOi44;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0lOi44 <= nl0lOi43;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0lOi45 <= (nl0lOi44 XOR nl0lOi43);
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0lOO40 <= nl0lOO41;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0lOO41 <= nl0lOO40;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0lOO42 <= (nl0lOO41 XOR nl0lOO40);
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0O0i34 <= nl0O0i35;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0O0i35 <= nl0O0i34;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0O0i36 <= (nl0O0i35 XOR nl0O0i34);
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0O1l37 <= nl0O1l38;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0O1l38 <= nl0O1l37;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0O1l39 <= (nl0O1l38 XOR nl0O1l37);
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0Oii31 <= nl0Oii32;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0Oii32 <= nl0Oii31;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0Oii33 <= (nl0Oii32 XOR nl0Oii31);
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0Oll28 <= nl0Oll29;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0Oll29 <= nl0Oll28;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0Oll30 <= (nl0Oll29 XOR nl0Oll28);
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0OOl25 <= nl0OOl26;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0OOl26 <= nl0OOl25;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nl0OOl27 <= (nl0OOl26 XOR nl0OOl25);
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nl11i <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nl11i <= wire_nl1iO_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nl11l <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nl11l <= wire_nl1li_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nl11O <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nl11O <= wire_nl1ll_dataout;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nli01O10 <= nli01O11;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nli01O11 <= nli01O10;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nli01O12 <= (nli01O11 XOR nli01O10);
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nli0ii7 <= nli0ii8;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nli0ii8 <= nli0ii7;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nli0ii9 <= (nli0ii8 XOR nli0ii7);
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nli0li4 <= nli0li5;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nli0li5 <= nli0li4;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nli0li6 <= (nli0li5 XOR nli0li4);
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nli10l19 <= nli10l20;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nli10l20 <= nli10l19;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nli10l21 <= (nli10l20 XOR 
		nli10l19);
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nli11l22 <= nli11l23;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nli11l23 <= nli11l22;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nli11l24 <= (nli11l23 XOR nli11l22);
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nli1ll16 <= nli1ll17;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nli1ll17 <= nli1ll16;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nli1ll18 <= (nli1ll17 XOR nli1ll16);
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nli1OO13 <= nli1OO14;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nli1OO14 <= nli1OO13;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nli1OO15 <= (nli1OO14 XOR nli1OO13);
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nlii1i1 <= nlii1i2;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nlii1i2 <= nlii1i1;
		END IF;
	END PROCESS;
	PROCESS (nli0OO)
	BEGIN
		IF (nli0OO = '1' AND nli0OO'event) THEN nlii1i3 <= (nlii1i2 XOR nlii1i1);
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nllilO <= '1';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nllilO <= wire_nllO0i_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlliOi <= '1';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nlliOi <= wire_n1O1O_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlliOl <= '1';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nlliOl <= wire_n1O0O_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlliOO <= '1';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nlliOO <= wire_n1Oii_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlll0i <= '1';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nlll0i <= wire_nlO0i_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlll0l <= '1';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nlll0l <= wire_nlOii_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlll0O <= '1';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nlll0O <= wire_nlOil_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlll1i <= '1';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nlll1i <= wire_n1Oil_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlll1l <= '1';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nlll1l <= wire_n1Oll_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlll1O <= '1';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nlll1O <= wire_n00lO_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlllii <= '1';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nlllii <= wire_nlOiO_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlllil <= '1';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nlllil <= wire_nlOlO_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nllliO <= '1';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nllliO <= wire_w_lg_nl0ill308w(0);
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlllli <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nlllli <= wire_n0Oi_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlllll <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nlllll <= wire_nllO1O_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nllllO <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nllllO <= wire_nllO0l_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlllOi <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nlllOi <= wire_nllO0O_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlllOl <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nlllOl <= wire_nllOii_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlllOO <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nlllOO <= wire_nllOil_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nllO1i <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nllO1i <= wire_nllOiO_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nllO1l <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nllO1l <= wire_nllOli_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nllOl <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nllOl <= wire_nl1lO_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nllOO <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nllOO <= wire_nlO0l_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlO00i <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nlO00i <= wire_nlO0lO_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlO00l <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nlO00l <= wire_nlO0Oi_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlO00O <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nlO00O <= wire_nlO0Ol_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlO01O <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nlO01O <= wire_nllOll_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlO0ii <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nlO0ii <= wire_nlO0OO_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlO0il <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nlO0il <= wire_nlOi1i_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlO0iO <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nlO0iO <= wire_nlOi1l_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlO0li <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nlO0li <= wire_nlOi1O_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlO0ll <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nlO0ll <= wire_nlOi0i_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlO1i <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nlO1i <= wire_nlO0O_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlO1l <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nlO1l <= wire_nlOli_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlO1O <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nlO1O <= wire_nlOll_dataout;
		END IF;
	END PROCESS;
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlOOOO <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN nlOOOO <= wire_nlOi0l_dataout;
		END IF;
	END PROCESS;
	wire_n00i_dataout <= rxdatain(2) OR wire_ni1i_dataout;
	wire_n00l_dataout <= rxdatain(3) OR wire_ni1i_dataout;
	wire_n00ll_dataout <= wire_n0O1l_dataout WHEN nlllli = '1'  ELSE wire_n0iOi_dataout;
	wire_n00lO_dataout <= wire_n0O1O_dataout WHEN nlllli = '1'  ELSE wire_n0i0l_dataout;
	wire_n00O_dataout <= rxdatain(4) OR wire_ni1i_dataout;
	wire_n00Oi_dataout <= wire_n0O0i_dataout WHEN nlllli = '1'  ELSE wire_n0i0O_dataout;
	wire_n00Ol_dataout <= wire_n0O0l_dataout WHEN nlllli = '1'  ELSE wire_n0iii_dataout;
	wire_n00OO_dataout <= wire_n0O0O_dataout WHEN nlllli = '1'  ELSE wire_n0iil_dataout;
	wire_n010i_dataout <= wire_n01Oi_dataout WHEN nl0i0l = '1'  ELSE nlO1O;
	wire_n010l_dataout <= wire_n01Ol_dataout WHEN nl0i0l = '1'  ELSE nlllil;
	wire_n010O_dataout <= nlll0i OR nl0i0i;
	wire_n011i_dataout <= wire_n01li_dataout WHEN nl0i0l = '1'  ELSE nlll0O;
	wire_n011l_dataout <= wire_n01ll_dataout WHEN nl0i0l = '1'  ELSE nlllii;
	wire_n011O_dataout <= wire_n01lO_dataout WHEN nl0i0l = '1'  ELSE nlO1l;
	wire_n01i_dataout <= rxctrl(0) OR wire_ni1i_dataout;
	wire_n01ii_dataout <= nllOO AND NOT(nl0i0i);
	wire_n01il_dataout <= nlO1i OR nl0i0i;
	wire_n01iO_dataout <= nlll0l OR nl0i0i;
	wire_n01l_dataout <= rxdatain(0) AND NOT(wire_ni1i_dataout);
	wire_n01li_dataout <= nlll0O OR nl0i0i;
	wire_n01ll_dataout <= nlllii OR nl0i0i;
	wire_n01lO_dataout <= nlO1l OR nl0i0i;
	wire_n01O_dataout <= rxdatain(1) OR wire_ni1i_dataout;
	wire_n01Oi_dataout <= nlO1O OR nl0i0i;
	wire_n01Ol_dataout <= nlllil OR nl0i0i;
	wire_n0i0i_dataout <= wire_n0Oli_dataout WHEN nlllli = '1'  ELSE wire_n0ilO_dataout;
	wire_n0i0l_dataout <= wire_n0iOO_dataout OR wire_w_lg_nl0ill308w(0);
	wire_n0i0O_dataout <= wire_n0l1i_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_n0i1i_dataout <= wire_n0Oii_dataout WHEN nlllli = '1'  ELSE wire_n0iiO_dataout;
	wire_n0i1l_dataout <= wire_n0Oil_dataout WHEN nlllli = '1'  ELSE wire_n0ili_dataout;
	wire_n0i1O_dataout <= wire_n0OiO_dataout WHEN nlllli = '1'  ELSE wire_n0ill_dataout;
	wire_n0ii_dataout <= rxdatain(5) OR wire_ni1i_dataout;
	wire_n0iii_dataout <= wire_n0l1l_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_n0iil_dataout <= wire_n0l1O_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_n0iiO_dataout <= wire_n0l0i_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_n0il_dataout <= rxdatain(6) OR wire_ni1i_dataout;
	wire_n0ili_dataout <= wire_n0l0l_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_n0ill_dataout <= wire_n0l0O_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_n0ilO_dataout <= wire_n0lii_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_n0iO_dataout <= rxdatain(7) OR wire_ni1i_dataout;
	wire_n0iOi_dataout <= wire_n0iOl_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_n0iOl_dataout <= wire_n0lil_dataout OR nl0lli;
	wire_n0iOO_dataout <= wire_n0liO_dataout OR nl0lli;
	wire_n0l0i_dataout <= wire_n0lOi_dataout AND NOT(nl0lli);
	wire_n0l0l_dataout <= wire_n0lOl_dataout AND NOT(nl0lli);
	wire_n0l0O_dataout <= wire_n0lOO_dataout AND NOT(nl0lli);
	wire_n0l1i_dataout <= wire_n0lli_dataout OR nl0lli;
	wire_n0l1l_dataout <= wire_n0lll_dataout OR nl0lli;
	wire_n0l1O_dataout <= wire_n0llO_dataout AND NOT(nl0lli);
	wire_n0lii_dataout <= wire_n0O1i_dataout AND NOT(nl0lli);
	wire_n0lil_dataout <= rxctrl(3) OR wire_ni0i_dataout;
	wire_n0liO_dataout <= rxdatain(24) AND NOT(wire_ni0i_dataout);
	wire_n0lli_dataout <= rxdatain(25) OR wire_ni0i_dataout;
	wire_n0lll_dataout <= rxdatain(26) OR wire_ni0i_dataout;
	wire_n0llO_dataout <= rxdatain(27) OR wire_ni0i_dataout;
	wire_n0lO_dataout <= nl0lli AND NOT(wire_w_lg_nl0ill308w(0));
	wire_n0lOi_dataout <= rxdatain(28) OR wire_ni0i_dataout;
	wire_n0lOl_dataout <= rxdatain(29) OR wire_ni0i_dataout;
	wire_n0lOO_dataout <= rxdatain(30) OR wire_ni0i_dataout;
	wire_n0O0i_dataout <= wire_n0OOi_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_n0O0l_dataout <= wire_n0OOl_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_n0O0O_dataout <= wire_n0OOO_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_n0O1i_dataout <= rxdatain(31) OR wire_ni0i_dataout;
	wire_n0O1l_dataout <= wire_n0Oll_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_n0O1O_dataout <= wire_n0OlO_dataout OR wire_w_lg_nl0ill308w(0);
	wire_n0Oi_dataout <= wire_w_lg_nl0lli307w(0) AND NOT(wire_w_lg_nl0ill308w(0));
	wire_n0Oii_dataout <= wire_ni11i_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_n0Oil_dataout <= wire_ni11l_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_n0OiO_dataout <= wire_ni11O_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_n0Oli_dataout <= wire_ni10i_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_n0Oll_dataout <= wire_n0lil_dataout OR nl0i0O;
	wire_n0OlO_dataout <= wire_n0liO_dataout OR nl0i0O;
	wire_n0OOi_dataout <= wire_n0lli_dataout OR nl0i0O;
	wire_n0OOl_dataout <= wire_n0lll_dataout OR nl0i0O;
	wire_n0OOO_dataout <= wire_n0llO_dataout AND NOT(nl0i0O);
	wire_n100i_dataout <= wire_n1l0i_dataout WHEN nl0lil = '1'  ELSE wire_n10Oi_dataout;
	wire_n100l_dataout <= wire_n1l0l_dataout WHEN nl0lil = '1'  ELSE wire_n10Ol_dataout;
	wire_n100O_dataout <= wire_n1l0O_dataout WHEN nl0lil = '1'  ELSE wire_n10OO_dataout;
	wire_n101i_dataout <= wire_n10li_dataout AND NOT(nllliO);
	wire_n101l_dataout <= wire_n10ll_dataout AND NOT(nllliO);
	wire_n101O_dataout <= wire_n1l1O_dataout WHEN nl0lil = '1'  ELSE wire_n10lO_dataout;
	wire_n10i_dataout <= wire_n1Oi_dataout AND NOT(wire_n0lO_dataout);
	wire_n10ii_dataout <= wire_n1lii_dataout WHEN nl0lil = '1'  ELSE wire_n1i1i_dataout;
	wire_n10il_dataout <= wire_n1lil_dataout WHEN nl0lil = '1'  ELSE wire_n1i1l_dataout;
	wire_n10iO_dataout <= wire_n1liO_dataout WHEN nl0lil = '1'  ELSE wire_n1i1O_dataout;
	wire_n10l_dataout <= wire_n1Ol_dataout AND NOT(wire_n0lO_dataout);
	wire_n10li_dataout <= wire_n1lli_dataout WHEN nl0lil = '1'  ELSE wire_n1i0i_dataout;
	wire_n10ll_dataout <= wire_n1lll_dataout WHEN nl0lil = '1'  ELSE wire_n1i0l_dataout;
	wire_n10lO_dataout <= wire_n1i0O_dataout WHEN nl0i1l = '1'  ELSE niOll;
	wire_n10O_dataout <= wire_n1OO_dataout AND NOT(wire_n0lO_dataout);
	wire_n10Oi_dataout <= wire_n1iii_dataout WHEN nl0i1l = '1'  ELSE niOlO;
	wire_n10Ol_dataout <= wire_n1iil_dataout WHEN nl0i1l = '1'  ELSE niOOi;
	wire_n10OO_dataout <= wire_n1iiO_dataout WHEN nl0i1l = '1'  ELSE niOOl;
	wire_n11i_dataout <= wire_n1li_dataout OR wire_n0lO_dataout;
	wire_n11iO_dataout <= wire_n101O_dataout AND NOT(nllliO);
	wire_n11l_dataout <= wire_n1ll_dataout AND NOT(wire_n0lO_dataout);
	wire_n11li_dataout <= wire_n100i_dataout AND NOT(nllliO);
	wire_n11ll_dataout <= wire_n100l_dataout AND NOT(nllliO);
	wire_n11lO_dataout <= wire_n100O_dataout AND NOT(nllliO);
	wire_n11O_dataout <= wire_n1lO_dataout AND NOT(wire_n0lO_dataout);
	wire_n11Oi_dataout <= wire_n10ii_dataout AND NOT(nllliO);
	wire_n11Ol_dataout <= wire_n10il_dataout AND NOT(nllliO);
	wire_n11OO_dataout <= wire_n10iO_dataout AND NOT(nllliO);
	wire_n1i0i_dataout <= wire_n1iOi_dataout WHEN nl0i1l = '1'  ELSE nl11O;
	wire_n1i0l_dataout <= wire_n1iOl_dataout WHEN nl0i1l = '1'  ELSE nllOl;
	wire_n1i0O_dataout <= niOll OR nl0i1i;
	wire_n1i1i_dataout <= wire_n1ili_dataout WHEN nl0i1l = '1'  ELSE niOOO;
	wire_n1i1l_dataout <= wire_n1ill_dataout WHEN nl0i1l = '1'  ELSE nl11i;
	wire_n1i1O_dataout <= wire_n1ilO_dataout WHEN nl0i1l = '1'  ELSE nl11l;
	wire_n1ii_dataout <= rxctrl(0) WHEN nl0lil = '1'  ELSE wire_n01i_dataout;
	wire_n1iii_dataout <= niOlO AND NOT(nl0i1i);
	wire_n1iil_dataout <= niOOi OR nl0i1i;
	wire_n1iiO_dataout <= niOOl OR nl0i1i;
	wire_n1il_dataout <= rxdatain(0) WHEN nl0lil = '1'  ELSE wire_n01l_dataout;
	wire_n1ili_dataout <= niOOO OR nl0i1i;
	wire_n1ill_dataout <= nl11i OR nl0i1i;
	wire_n1ilO_dataout <= nl11l OR nl0i1i;
	wire_n1iO_dataout <= rxdatain(1) WHEN nl0lil = '1'  ELSE wire_n01O_dataout;
	wire_n1iOi_dataout <= nl11O OR nl0i1i;
	wire_n1iOl_dataout <= nllOl OR nl0i1i;
	wire_n1l0i_dataout <= niOlO AND NOT(nl0i1O);
	wire_n1l0l_dataout <= niOOi OR nl0i1O;
	wire_n1l0O_dataout <= niOOl OR nl0i1O;
	wire_n1l1O_dataout <= niOll OR nl0i1O;
	wire_n1li_dataout <= rxdatain(2) WHEN nl0lil = '1'  ELSE wire_n00i_dataout;
	wire_n1lii_dataout <= niOOO OR nl0i1O;
	wire_n1lil_dataout <= nl11i OR nl0i1O;
	wire_n1liO_dataout <= nl11l OR nl0i1O;
	wire_n1ll_dataout <= rxdatain(3) WHEN nl0lil = '1'  ELSE wire_n00l_dataout;
	wire_n1lli_dataout <= nl11O OR nl0i1O;
	wire_n1lll_dataout <= nllOl OR nl0i1O;
	wire_n1lO_dataout <= rxdatain(4) WHEN nl0lil = '1'  ELSE wire_n00O_dataout;
	wire_n1O0i_dataout <= wire_n1OOi_dataout AND NOT(nllliO);
	wire_n1O0l_dataout <= wire_n1OOl_dataout AND NOT(nllliO);
	wire_n1O0O_dataout <= wire_n1OOO_dataout OR nllliO;
	wire_n1O1O_dataout <= wire_n1OlO_dataout OR nllliO;
	wire_n1Oi_dataout <= rxdatain(5) WHEN nl0lil = '1'  ELSE wire_n0ii_dataout;
	wire_n1Oii_dataout <= wire_n011i_dataout OR nllliO;
	wire_n1Oil_dataout <= wire_n011l_dataout OR nllliO;
	wire_n1OiO_dataout <= wire_n011O_dataout AND NOT(nllliO);
	wire_n1Ol_dataout <= rxdatain(6) WHEN nl0lil = '1'  ELSE wire_n0il_dataout;
	wire_n1Oli_dataout <= wire_n010i_dataout AND NOT(nllliO);
	wire_n1Oll_dataout <= wire_n010l_dataout OR nllliO;
	wire_n1OlO_dataout <= wire_n010O_dataout WHEN nl0i0l = '1'  ELSE nlll0i;
	wire_n1OO_dataout <= rxdatain(7) WHEN nl0lil = '1'  ELSE wire_n0iO_dataout;
	wire_n1OOi_dataout <= wire_n01ii_dataout WHEN nl0i0l = '1'  ELSE nllOO;
	wire_n1OOl_dataout <= wire_n01il_dataout WHEN nl0i0l = '1'  ELSE nlO1i;
	wire_n1OOO_dataout <= wire_n01iO_dataout WHEN nl0i0l = '1'  ELSE nlll0l;
	wire_ni00i_dataout <= wire_nilli_dataout WHEN nlllli = '1'  ELSE wire_ni0Oi_dataout;
	wire_ni00l_dataout <= wire_nilll_dataout WHEN nlllli = '1'  ELSE wire_ni0Ol_dataout;
	wire_ni00O_dataout <= wire_nillO_dataout WHEN nlllli = '1'  ELSE wire_ni0OO_dataout;
	wire_ni01i_dataout <= wire_nilii_dataout WHEN nlllli = '1'  ELSE wire_ni0li_dataout;
	wire_ni01l_dataout <= wire_nilil_dataout WHEN nlllli = '1'  ELSE wire_ni0ll_dataout;
	wire_ni01O_dataout <= wire_niliO_dataout WHEN nlllli = '1'  ELSE wire_ni0lO_dataout;
	wire_ni0i_dataout <= rxrunningdisp(3) AND NOT(nllliO);
	wire_ni0i_w_lg_dataout309w(0) <= NOT wire_ni0i_dataout;
	wire_ni0ii_dataout <= wire_nilOi_dataout WHEN nlllli = '1'  ELSE wire_nii1i_dataout;
	wire_ni0il_dataout <= wire_nilOl_dataout WHEN nlllli = '1'  ELSE wire_nii1l_dataout;
	wire_ni0iO_dataout <= wire_nii1O_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_ni0li_dataout <= wire_nii0i_dataout OR wire_w_lg_nl0ill308w(0);
	wire_ni0ll_dataout <= wire_nii0l_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_ni0lO_dataout <= wire_nii0O_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_ni0Oi_dataout <= wire_niiii_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_ni0Ol_dataout <= wire_niiil_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_ni0OO_dataout <= wire_niiiO_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_ni10i_dataout <= wire_n0O1i_dataout AND NOT(nl0i0O);
	wire_ni11i_dataout <= wire_n0lOi_dataout AND NOT(nl0i0O);
	wire_ni11l_dataout <= wire_n0lOl_dataout AND NOT(nl0i0O);
	wire_ni11O_dataout <= wire_n0lOO_dataout AND NOT(nl0i0O);
	wire_ni1i_dataout <= rxrunningdisp(0) AND NOT(nllliO);
	wire_ni1i_w_lg_dataout248w(0) <= NOT wire_ni1i_dataout;
	wire_ni1l_dataout <= rxrunningdisp(1) AND NOT(nllliO);
	wire_ni1l_w_lg_dataout266w(0) <= NOT wire_ni1l_dataout;
	wire_ni1O_dataout <= rxrunningdisp(2) AND NOT(nllliO);
	wire_ni1O_w_lg_dataout277w(0) <= NOT wire_ni1O_dataout;
	wire_ni1OO_dataout <= wire_nil0O_dataout WHEN nlllli = '1'  ELSE wire_ni0iO_dataout;
	wire_nii0i_dataout <= wire_niiOi_dataout OR nl0lli;
	wire_nii0l_dataout <= wire_niiOl_dataout OR nl0lli;
	wire_nii0O_dataout <= wire_niiOO_dataout OR nl0lli;
	wire_nii1i_dataout <= wire_niili_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_nii1l_dataout <= wire_niill_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_nii1O_dataout <= wire_niilO_dataout OR nl0lli;
	wire_niiii_dataout <= wire_nil1i_dataout AND NOT(nl0lli);
	wire_niiil_dataout <= wire_nil1l_dataout AND NOT(nl0lli);
	wire_niiiO_dataout <= wire_nil1O_dataout AND NOT(nl0lli);
	wire_niili_dataout <= wire_nil0i_dataout AND NOT(nl0lli);
	wire_niill_dataout <= wire_nil0l_dataout AND NOT(nl0lli);
	wire_niilO_dataout <= rxctrl(2) OR wire_ni1O_dataout;
	wire_niiOi_dataout <= rxdatain(16) AND NOT(wire_ni1O_dataout);
	wire_niiOl_dataout <= rxdatain(17) OR wire_ni1O_dataout;
	wire_niiOO_dataout <= rxdatain(18) OR wire_ni1O_dataout;
	wire_nil0i_dataout <= rxdatain(22) OR wire_ni1O_dataout;
	wire_nil0l_dataout <= rxdatain(23) OR wire_ni1O_dataout;
	wire_nil0O_dataout <= wire_nilOO_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_nil1i_dataout <= rxdatain(19) OR wire_ni1O_dataout;
	wire_nil1l_dataout <= rxdatain(20) OR wire_ni1O_dataout;
	wire_nil1O_dataout <= rxdatain(21) OR wire_ni1O_dataout;
	wire_nilii_dataout <= wire_niO1i_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_nilil_dataout <= wire_niO1l_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_niliO_dataout <= wire_niO1O_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_nilli_dataout <= wire_niO0i_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_nilll_dataout <= wire_niO0l_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_nillO_dataout <= wire_niO0O_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_nilOi_dataout <= wire_niOii_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_nilOl_dataout <= wire_niOil_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_nilOO_dataout <= wire_niilO_dataout OR nl0iii;
	wire_niO0i_dataout <= wire_nil1i_dataout AND NOT(nl0iii);
	wire_niO0l_dataout <= wire_nil1l_dataout AND NOT(nl0iii);
	wire_niO0O_dataout <= wire_nil1O_dataout AND NOT(nl0iii);
	wire_niO1i_dataout <= wire_niiOi_dataout OR nl0iii;
	wire_niO1l_dataout <= wire_niiOl_dataout OR nl0iii;
	wire_niO1O_dataout <= wire_niiOO_dataout OR nl0iii;
	wire_niOii_dataout <= wire_nil0i_dataout AND NOT(nl0iii);
	wire_niOil_dataout <= wire_nil0l_dataout AND NOT(nl0iii);
	wire_nl00i_dataout <= wire_nl0Oi_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_nl00l_dataout <= wire_nl0Ol_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_nl00O_dataout <= wire_nl0OO_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_nl01i_dataout <= wire_nl0li_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_nl01l_dataout <= wire_nl0ll_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_nl01O_dataout <= wire_nl0lO_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_nl0ii_dataout <= wire_nli1i_dataout OR nl0lli;
	wire_nl0il_dataout <= wire_nli1l_dataout OR nl0lli;
	wire_nl0iO_dataout <= wire_nli1O_dataout OR nl0lli;
	wire_nl0li_dataout <= wire_nli0i_dataout OR nl0lli;
	wire_nl0ll_dataout <= wire_nli0l_dataout AND NOT(nl0lli);
	wire_nl0lO_dataout <= wire_nli0O_dataout AND NOT(nl0lli);
	wire_nl0Oi_dataout <= wire_nliii_dataout AND NOT(nl0lli);
	wire_nl0Ol_dataout <= wire_nliil_dataout AND NOT(nl0lli);
	wire_nl0OO_dataout <= wire_nliiO_dataout AND NOT(nl0lli);
	wire_nl10i_dataout <= wire_nlili_dataout WHEN nlllli = '1'  ELSE wire_nl1Oi_dataout;
	wire_nl10l_dataout <= wire_nlill_dataout WHEN nlllli = '1'  ELSE wire_nl1Ol_dataout;
	wire_nl10O_dataout <= wire_nlilO_dataout WHEN nlllli = '1'  ELSE wire_nl1OO_dataout;
	wire_nl1ii_dataout <= wire_nliOi_dataout WHEN nlllli = '1'  ELSE wire_nl01i_dataout;
	wire_nl1il_dataout <= wire_nliOl_dataout WHEN nlllli = '1'  ELSE wire_nl01l_dataout;
	wire_nl1iO_dataout <= wire_nliOO_dataout WHEN nlllli = '1'  ELSE wire_nl01O_dataout;
	wire_nl1li_dataout <= wire_nll1i_dataout WHEN nlllli = '1'  ELSE wire_nl00i_dataout;
	wire_nl1ll_dataout <= wire_nll1l_dataout WHEN nlllli = '1'  ELSE wire_nl00l_dataout;
	wire_nl1lO_dataout <= wire_nll1O_dataout WHEN nlllli = '1'  ELSE wire_nl00O_dataout;
	wire_nl1Oi_dataout <= wire_nl0ii_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_nl1Ol_dataout <= wire_nl0il_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_nl1OO_dataout <= wire_nl0iO_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_nli0i_dataout <= rxdatain(10) OR wire_ni1l_dataout;
	wire_nli0l_dataout <= rxdatain(11) OR wire_ni1l_dataout;
	wire_nli0O_dataout <= rxdatain(12) OR wire_ni1l_dataout;
	wire_nli1i_dataout <= rxctrl(1) OR wire_ni1l_dataout;
	wire_nli1l_dataout <= rxdatain(8) AND NOT(wire_ni1l_dataout);
	wire_nli1O_dataout <= rxdatain(9) OR wire_ni1l_dataout;
	wire_nliii_dataout <= rxdatain(13) OR wire_ni1l_dataout;
	wire_nliil_dataout <= rxdatain(14) OR wire_ni1l_dataout;
	wire_nliiO_dataout <= rxdatain(15) OR wire_ni1l_dataout;
	wire_nlili_dataout <= wire_nll0i_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_nlill_dataout <= wire_nll0l_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_nlilO_dataout <= wire_nll0O_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_nliOi_dataout <= wire_nllii_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_nliOl_dataout <= wire_nllil_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_nliOO_dataout <= wire_nlliO_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_nll0i_dataout <= wire_nli1i_dataout OR nl0iil;
	wire_nll0l_dataout <= wire_nli1l_dataout OR nl0iil;
	wire_nll0O_dataout <= wire_nli1O_dataout OR nl0iil;
	wire_nll1i_dataout <= wire_nllli_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_nll1l_dataout <= wire_nllll_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_nll1O_dataout <= wire_nlllO_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_nllii_dataout <= wire_nli0i_dataout OR nl0iil;
	wire_nllil_dataout <= wire_nli0l_dataout AND NOT(nl0iil);
	wire_nlliO_dataout <= wire_nli0O_dataout AND NOT(nl0iil);
	wire_nllli_dataout <= wire_nliii_dataout AND NOT(nl0iil);
	wire_nllll_dataout <= wire_nliil_dataout AND NOT(nl0iil);
	wire_nlllO_dataout <= wire_nliiO_dataout AND NOT(nl0iil);
	wire_nllO0i_dataout <= wire_nllOlO_dataout OR nllliO;
	wire_nllO0l_dataout <= wire_nllOOi_dataout AND NOT(nllliO);
	wire_nllO0O_dataout <= wire_nllOOl_dataout AND NOT(nllliO);
	wire_nllO1O_dataout <= wire_nlO10l_dataout AND NOT(nllliO);
	wire_nllOii_dataout <= wire_nllOOO_dataout AND NOT(nllliO);
	wire_nllOil_dataout <= wire_nlO11i_dataout AND NOT(nllliO);
	wire_nllOiO_dataout <= wire_nlO11l_dataout AND NOT(nllliO);
	wire_nllOli_dataout <= wire_nlO11O_dataout AND NOT(nllliO);
	wire_nllOll_dataout <= wire_nlO10i_dataout AND NOT(nllliO);
	wire_nllOlO_dataout <= wire_nlO10O_dataout WHEN nl00lO = '1'  ELSE nlll1O;
	wire_nllOOi_dataout <= wire_nlO1ii_dataout WHEN nl00lO = '1'  ELSE n000l;
	wire_nllOOl_dataout <= wire_nlO1il_dataout WHEN nl00lO = '1'  ELSE n000O;
	wire_nllOOO_dataout <= wire_nlO1iO_dataout WHEN nl00lO = '1'  ELSE n00ii;
	wire_nlO0i_dataout <= wire_nlOOi_dataout OR wire_w_lg_nl0ill308w(0);
	wire_nlO0l_dataout <= wire_nlOOl_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_nlO0lO_dataout <= wire_nlOi0O_dataout AND NOT(nllliO);
	wire_nlO0O_dataout <= wire_nlOOO_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_nlO0Oi_dataout <= wire_nlOiii_dataout AND NOT(nllliO);
	wire_nlO0Ol_dataout <= wire_nlOiil_dataout AND NOT(nllliO);
	wire_nlO0OO_dataout <= wire_nlOiiO_dataout AND NOT(nllliO);
	wire_nlO10i_dataout <= wire_nlO1Oi_dataout WHEN nl00lO = '1'  ELSE ni10O;
	wire_nlO10l_dataout <= wire_nlO1Ol_dataout WHEN nl00lO = '1'  ELSE n000i;
	wire_nlO10O_dataout <= nlll1O AND NOT(nl00ll);
	wire_nlO11i_dataout <= wire_nlO1li_dataout WHEN nl00lO = '1'  ELSE n00il;
	wire_nlO11l_dataout <= wire_nlO1ll_dataout WHEN nl00lO = '1'  ELSE n00iO;
	wire_nlO11O_dataout <= wire_nlO1lO_dataout WHEN nl00lO = '1'  ELSE n00li;
	wire_nlO1ii_dataout <= n000l OR nl00ll;
	wire_nlO1il_dataout <= n000O OR nl00ll;
	wire_nlO1iO_dataout <= n00ii OR nl00ll;
	wire_nlO1li_dataout <= n00il OR nl00ll;
	wire_nlO1ll_dataout <= n00iO OR nl00ll;
	wire_nlO1lO_dataout <= n00li OR nl00ll;
	wire_nlO1Oi_dataout <= ni10O OR nl00ll;
	wire_nlO1Ol_dataout <= n000i OR nl00ll;
	wire_nlOi0i_dataout <= wire_nlOiOi_dataout AND NOT(nllliO);
	wire_nlOi0l_dataout <= wire_nlOiOl_dataout AND NOT(nllliO);
	wire_nlOi0O_dataout <= wire_nlOO0l_dataout WHEN nl00Oi = '1'  ELSE wire_nlOiOO_dataout;
	wire_nlOi1i_dataout <= wire_nlOili_dataout AND NOT(nllliO);
	wire_nlOi1l_dataout <= wire_nlOill_dataout AND NOT(nllliO);
	wire_nlOi1O_dataout <= wire_nlOilO_dataout AND NOT(nllliO);
	wire_nlOii_dataout <= wire_n11i_dataout OR wire_w_lg_nl0ill308w(0);
	wire_nlOiii_dataout <= wire_nlOO0O_dataout WHEN nl00Oi = '1'  ELSE wire_nlOl1i_dataout;
	wire_nlOiil_dataout <= wire_nlOOii_dataout WHEN nl00Oi = '1'  ELSE wire_nlOl1l_dataout;
	wire_nlOiiO_dataout <= wire_nlOOil_dataout WHEN nl00Oi = '1'  ELSE wire_nlOl1O_dataout;
	wire_nlOil_dataout <= wire_n11l_dataout OR wire_w_lg_nl0ill308w(0);
	wire_nlOili_dataout <= wire_nlOOiO_dataout WHEN nl00Oi = '1'  ELSE wire_nlOl0i_dataout;
	wire_nlOill_dataout <= wire_nlOOli_dataout WHEN nl00Oi = '1'  ELSE wire_nlOl0l_dataout;
	wire_nlOilO_dataout <= wire_nlOOll_dataout WHEN nl00Oi = '1'  ELSE wire_nlOl0O_dataout;
	wire_nlOiO_dataout <= wire_n11O_dataout OR wire_w_lg_nl0ill308w(0);
	wire_nlOiOi_dataout <= wire_nlOOlO_dataout WHEN nl00Oi = '1'  ELSE wire_nlOlii_dataout;
	wire_nlOiOl_dataout <= wire_nlOOOi_dataout WHEN nl00Oi = '1'  ELSE wire_nlOlil_dataout;
	wire_nlOiOO_dataout <= wire_nlOliO_dataout WHEN n0li = '1'  ELSE ni1ii;
	wire_nlOl0i_dataout <= wire_nlOlOi_dataout WHEN n0li = '1'  ELSE ni1ll;
	wire_nlOl0l_dataout <= wire_nlOlOl_dataout WHEN n0li = '1'  ELSE ni1lO;
	wire_nlOl0O_dataout <= wire_nlOlOO_dataout WHEN n0li = '1'  ELSE ni1Oi;
	wire_nlOl1i_dataout <= wire_nlOlli_dataout WHEN n0li = '1'  ELSE ni1il;
	wire_nlOl1l_dataout <= wire_nlOlll_dataout WHEN n0li = '1'  ELSE ni1iO;
	wire_nlOl1O_dataout <= wire_nlOllO_dataout WHEN n0li = '1'  ELSE ni1li;
	wire_nlOli_dataout <= wire_n10i_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_nlOlii_dataout <= wire_nlOO1i_dataout WHEN n0li = '1'  ELSE ni1Ol;
	wire_nlOlil_dataout <= wire_nlOO1l_dataout WHEN n0li = '1'  ELSE niOli;
	wire_nlOliO_dataout <= ni1ii OR nl00Ol;
	wire_nlOll_dataout <= wire_n10l_dataout AND NOT(wire_w_lg_nl0ill308w(0));
	wire_nlOlli_dataout <= ni1il AND NOT(nl00Ol);
	wire_nlOlll_dataout <= ni1iO OR nl00Ol;
	wire_nlOllO_dataout <= ni1li OR nl00Ol;
	wire_nlOlO_dataout <= wire_n10O_dataout OR wire_w_lg_nl0ill308w(0);
	wire_nlOlOi_dataout <= ni1ll OR nl00Ol;
	wire_nlOlOl_dataout <= ni1lO OR nl00Ol;
	wire_nlOlOO_dataout <= ni1Oi OR nl00Ol;
	wire_nlOO0l_dataout <= ni1ii OR nl00OO;
	wire_nlOO0O_dataout <= ni1il AND NOT(nl00OO);
	wire_nlOO1i_dataout <= ni1Ol OR nl00Ol;
	wire_nlOO1l_dataout <= niOli OR nl00Ol;
	wire_nlOOi_dataout <= wire_n1ii_dataout OR wire_n0lO_dataout;
	wire_nlOOii_dataout <= ni1iO OR nl00OO;
	wire_nlOOil_dataout <= ni1li OR nl00OO;
	wire_nlOOiO_dataout <= ni1ll OR nl00OO;
	wire_nlOOl_dataout <= wire_n1il_dataout OR wire_n0lO_dataout;
	wire_nlOOli_dataout <= ni1lO OR nl00OO;
	wire_nlOOll_dataout <= ni1Oi OR nl00OO;
	wire_nlOOlO_dataout <= ni1Ol OR nl00OO;
	wire_nlOOO_dataout <= wire_n1iO_dataout OR wire_n0lO_dataout;
	wire_nlOOOi_dataout <= niOli OR nl00OO;

 END RTL; --stratixgx_xgm_rx_sm
--synopsys translate_on
--VALID FILE
--IP Functional Simulation Model
--VERSION_BEGIN 4.1 cbx_mgl 2004:06:17:17:30:06:SJ cbx_simgen 2004:06:22:10:53:08:SJ  VERSION_END


-- Legal Notice: © 2003 Altera Corporation. All rights reserved.
-- You may only use these  simulation  model  output files for simulation
-- purposes and expressly not for synthesis or any other purposes (in which
-- event  Altera disclaims all warranties of any kind). Your use of  Altera
-- Corporation's design tools, logic functions and other software and tools,
-- and its AMPP partner logic functions, and any output files any of the
-- foregoing (including device programming or simulation files), and any
-- associated documentation or information  are expressly subject to the
-- terms and conditions of the  Altera Program License Subscription Agreement
-- or other applicable license agreement, including, without limitation, that
-- your use is for the sole purpose of programming logic devices manufactured
-- by Altera and sold by Altera or its authorized distributors.  Please refer
-- to the applicable agreement for further details.


--synopsys translate_off

 LIBRARY sgate;
 USE sgate.sgate_pack.all;

--synthesis_resources = lut 146 mux21 317 oper_add 1 oper_decoder 1 oper_less_than 1 oper_selector 39 
 LIBRARY ieee;
 USE ieee.std_logic_1164.all;

 ENTITY  stratixgx_xgm_tx_sm IS 
	 PORT 
	 ( 
		 rdenablesync	:	IN  STD_LOGIC;
		 resetall	:	IN  STD_LOGIC;
		 txclk	:	IN  STD_LOGIC;
		 txctrl	:	IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
		 txctrlout	:	OUT  STD_LOGIC_VECTOR (3 DOWNTO 0);
		 txdatain	:	IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
		 txdataout	:	OUT  STD_LOGIC_VECTOR (31 DOWNTO 0)
	 ); 
 END stratixgx_xgm_tx_sm;

 ARCHITECTURE RTL OF stratixgx_xgm_tx_sm IS

	 ATTRIBUTE synthesis_clearbox : boolean;
	 ATTRIBUTE synthesis_clearbox OF RTL : ARCHITECTURE IS true;
	 SIGNAL	n0iil	:	STD_LOGIC := '0';
	 SIGNAL	n0iiO	:	STD_LOGIC := '0';
	 SIGNAL	n0ili	:	STD_LOGIC := '0';
	 SIGNAL	n10ll	:	STD_LOGIC := '0';
	 SIGNAL	n10lO	:	STD_LOGIC := '0';
	 SIGNAL	n10Oi	:	STD_LOGIC := '0';
	 SIGNAL	nl000O4	:	STD_LOGIC := '1';
	 SIGNAL	nl000O5	:	STD_LOGIC := '0';
	 SIGNAL	nl000O6	:	STD_LOGIC := '0';
	 SIGNAL	nl001O7	:	STD_LOGIC := '1';
	 SIGNAL	nl001O8	:	STD_LOGIC := '0';
	 SIGNAL	nl001O9	:	STD_LOGIC := '0';
	 SIGNAL	nl00li1	:	STD_LOGIC := '1';
	 SIGNAL	nl00li2	:	STD_LOGIC := '0';
	 SIGNAL	nl00li3	:	STD_LOGIC := '0';
	 SIGNAL	nl010l19	:	STD_LOGIC := '1';
	 SIGNAL	nl010l20	:	STD_LOGIC := '0';
	 SIGNAL	nl010l21	:	STD_LOGIC := '0';
	 SIGNAL	nl011l22	:	STD_LOGIC := '1';
	 SIGNAL	nl011l23	:	STD_LOGIC := '0';
	 SIGNAL	nl011l24	:	STD_LOGIC := '0';
	 SIGNAL	nl01il16	:	STD_LOGIC := '1';
	 SIGNAL	nl01il17	:	STD_LOGIC := '0';
	 SIGNAL	nl01il18	:	STD_LOGIC := '0';
	 SIGNAL	nl01lO13	:	STD_LOGIC := '1';
	 SIGNAL	nl01lO14	:	STD_LOGIC := '0';
	 SIGNAL	nl01lO15	:	STD_LOGIC := '0';
	 SIGNAL	nl01OO10	:	STD_LOGIC := '1';
	 SIGNAL	nl01OO11	:	STD_LOGIC := '0';
	 SIGNAL	nl01OO12	:	STD_LOGIC := '0';
	 SIGNAL	nl0li	:	STD_LOGIC := '0';
	 SIGNAL	nl0ll	:	STD_LOGIC := '0';
	 SIGNAL	nl0lO	:	STD_LOGIC := '0';
	 SIGNAL	nl0Oi	:	STD_LOGIC := '0';
	 SIGNAL	nl0Ol	:	STD_LOGIC := '0';
	 SIGNAL	nl0OO	:	STD_LOGIC := '0';
	 SIGNAL	nl10i	:	STD_LOGIC := '0';
	 SIGNAL	nl10li58	:	STD_LOGIC := '1';
	 SIGNAL	nl10li59	:	STD_LOGIC := '0';
	 SIGNAL	nl10li60	:	STD_LOGIC := '0';
	 SIGNAL	nl10Oi55	:	STD_LOGIC := '1';
	 SIGNAL	nl10Oi56	:	STD_LOGIC := '0';
	 SIGNAL	nl10Oi57	:	STD_LOGIC := '0';
	 SIGNAL	nl11i	:	STD_LOGIC := '0';
	 SIGNAL	nl11l	:	STD_LOGIC := '0';
	 SIGNAL	nl11O	:	STD_LOGIC := '0';
	 SIGNAL	nl1i1l52	:	STD_LOGIC := '1';
	 SIGNAL	nl1i1l53	:	STD_LOGIC := '0';
	 SIGNAL	nl1i1l54	:	STD_LOGIC := '0';
	 SIGNAL	nl1iil49	:	STD_LOGIC := '1';
	 SIGNAL	nl1iil50	:	STD_LOGIC := '0';
	 SIGNAL	nl1iil51	:	STD_LOGIC := '0';
	 SIGNAL	nl1ilO46	:	STD_LOGIC := '1';
	 SIGNAL	nl1ilO47	:	STD_LOGIC := '0';
	 SIGNAL	nl1ilO48	:	STD_LOGIC := '0';
	 SIGNAL	nl1l0l40	:	STD_LOGIC := '1';
	 SIGNAL	nl1l0l41	:	STD_LOGIC := '0';
	 SIGNAL	nl1l0l42	:	STD_LOGIC := '0';
	 SIGNAL	nl1l1l43	:	STD_LOGIC := '1';
	 SIGNAL	nl1l1l44	:	STD_LOGIC := '0';
	 SIGNAL	nl1l1l45	:	STD_LOGIC := '0';
	 SIGNAL	nl1lli37	:	STD_LOGIC := '1';
	 SIGNAL	nl1lli38	:	STD_LOGIC := '0';
	 SIGNAL	nl1lli39	:	STD_LOGIC := '0';
	 SIGNAL	nl1O0i31	:	STD_LOGIC := '1';
	 SIGNAL	nl1O0i32	:	STD_LOGIC := '0';
	 SIGNAL	nl1O0i33	:	STD_LOGIC := '0';
	 SIGNAL	nl1O1i34	:	STD_LOGIC := '1';
	 SIGNAL	nl1O1i35	:	STD_LOGIC := '0';
	 SIGNAL	nl1O1i36	:	STD_LOGIC := '0';
	 SIGNAL	nl1OiO28	:	STD_LOGIC := '1';
	 SIGNAL	nl1OiO29	:	STD_LOGIC := '0';
	 SIGNAL	nl1OiO30	:	STD_LOGIC := '0';
	 SIGNAL	nl1OOl25	:	STD_LOGIC := '1';
	 SIGNAL	nl1OOl26	:	STD_LOGIC := '0';
	 SIGNAL	nl1OOl27	:	STD_LOGIC := '0';
	 SIGNAL	nli0i	:	STD_LOGIC := '0';
	 SIGNAL	nli0l	:	STD_LOGIC := '0';
	 SIGNAL	nli0O	:	STD_LOGIC := '0';
	 SIGNAL	nli0Ol	:	STD_LOGIC := '0';
	 SIGNAL	nli0OO	:	STD_LOGIC := '0';
	 SIGNAL	nli1i	:	STD_LOGIC := '0';
	 SIGNAL	nli1l	:	STD_LOGIC := '0';
	 SIGNAL	nli1O	:	STD_LOGIC := '0';
	 SIGNAL	nlii0i	:	STD_LOGIC := '0';
	 SIGNAL	nlii0l	:	STD_LOGIC := '0';
	 SIGNAL	nlii0O	:	STD_LOGIC := '0';
	 SIGNAL	nlii1i	:	STD_LOGIC := '0';
	 SIGNAL	nlii1l	:	STD_LOGIC := '0';
	 SIGNAL	nlii1O	:	STD_LOGIC := '0';
	 SIGNAL	nliii	:	STD_LOGIC := '0';
	 SIGNAL	nliiii	:	STD_LOGIC := '0';
	 SIGNAL	nliiil	:	STD_LOGIC := '0';
	 SIGNAL	nliiiO	:	STD_LOGIC := '0';
	 SIGNAL	nliil	:	STD_LOGIC := '0';
	 SIGNAL	nliili	:	STD_LOGIC := '0';
	 SIGNAL	nliill	:	STD_LOGIC := '0';
	 SIGNAL	nliilO	:	STD_LOGIC := '0';
	 SIGNAL	nliiO	:	STD_LOGIC := '0';
	 SIGNAL	nliiOi	:	STD_LOGIC := '0';
	 SIGNAL	nliiOl	:	STD_LOGIC := '0';
	 SIGNAL	nliiOO	:	STD_LOGIC := '0';
	 SIGNAL	nlil0i	:	STD_LOGIC := '0';
	 SIGNAL	nlil0l	:	STD_LOGIC := '0';
	 SIGNAL	nlil0O	:	STD_LOGIC := '0';
	 SIGNAL	nlil1i	:	STD_LOGIC := '0';
	 SIGNAL	nlil1l	:	STD_LOGIC := '0';
	 SIGNAL	nlil1O	:	STD_LOGIC := '0';
	 SIGNAL	nlili	:	STD_LOGIC := '0';
	 SIGNAL	nlilii	:	STD_LOGIC := '0';
	 SIGNAL	nlilil	:	STD_LOGIC := '0';
	 SIGNAL  wire_nlilil_w_lg_Q504w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlilil_w_lg_Q561w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlilil_w_lg_w_lg_Q561w562w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nliliO	:	STD_LOGIC := '0';
	 SIGNAL	nlill	:	STD_LOGIC := '0';
	 SIGNAL	nlilli	:	STD_LOGIC := '0';
	 SIGNAL  wire_nlilli_w_lg_Q568w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nlilll	:	STD_LOGIC := '0';
	 SIGNAL	nlillO	:	STD_LOGIC := '0';
	 SIGNAL	nlilO	:	STD_LOGIC := '0';
	 SIGNAL	nlilOi	:	STD_LOGIC := '0';
	 SIGNAL	nlilOl	:	STD_LOGIC := '0';
	 SIGNAL	nlilOO	:	STD_LOGIC := '0';
	 SIGNAL	nliO0i	:	STD_LOGIC := '0';
	 SIGNAL	nliO0l	:	STD_LOGIC := '0';
	 SIGNAL	nliO0O	:	STD_LOGIC := '0';
	 SIGNAL	nliO1i	:	STD_LOGIC := '0';
	 SIGNAL	nliO1l	:	STD_LOGIC := '0';
	 SIGNAL	nliO1O	:	STD_LOGIC := '0';
	 SIGNAL	nliOi	:	STD_LOGIC := '0';
	 SIGNAL	nliOii	:	STD_LOGIC := '0';
	 SIGNAL  wire_nliOii_w_lg_Q487w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nliOil	:	STD_LOGIC := '0';
	 SIGNAL  wire_nliOil_w_lg_Q480w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nliOiO	:	STD_LOGIC := '0';
	 SIGNAL	nliOl	:	STD_LOGIC := '0';
	 SIGNAL	nliOli	:	STD_LOGIC := '0';
	 SIGNAL	nliOll	:	STD_LOGIC := '0';
	 SIGNAL	nliOlO	:	STD_LOGIC := '0';
	 SIGNAL	nliOO	:	STD_LOGIC := '0';
	 SIGNAL	nll0i	:	STD_LOGIC := '0';
	 SIGNAL	nll0l	:	STD_LOGIC := '0';
	 SIGNAL	nll0O	:	STD_LOGIC := '0';
	 SIGNAL	nll1i	:	STD_LOGIC := '0';
	 SIGNAL	nll1l	:	STD_LOGIC := '0';
	 SIGNAL	nll1O	:	STD_LOGIC := '0';
	 SIGNAL	nllOO	:	STD_LOGIC := '0';
	 SIGNAL  wire_nllOO_w_lg_Q567w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nlO01i	:	STD_LOGIC := '0';
	 SIGNAL	nlO1i	:	STD_LOGIC := '0';
	 SIGNAL  wire_nlO1i_w_lg_Q484w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlO1i_w_lg_w_lg_Q484w485w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlO1i_w_lg_w_lg_w_lg_Q484w485w499w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlO1i_w_lg_w_lg_Q479w493w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlO1i_w_lg_Q479w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nlO1Ol	:	STD_LOGIC := '0';
	 SIGNAL	nlO1OO	:	STD_LOGIC := '0';
	 SIGNAL	wire_n000i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n000l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n000O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n001i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n001l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n001O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n010i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n010l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n010O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n011i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n011l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n011O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0i0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0i0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0i0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0i1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0i1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0i1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0iii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0ill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0ilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0iOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0iOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0iOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0Oii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0Oil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0Oli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0Oll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n100i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n100l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n100O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n101i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n101l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n101O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n110i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n110l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n110O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n111i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n111l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n111O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1iii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1l0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1l0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1l0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1l1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1lii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1lil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1liO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1lli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1lll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1llO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1lOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1lOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1lOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1O0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1O0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1O0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1O1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1O1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1O1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1Oii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1Oil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1OiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1Oli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1Oll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1OlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1OOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1OOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1OOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni00i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni00l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni00O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni01i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni01l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni01O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni10i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni10l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni10O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni11i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni11l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni11O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niliO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nillO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl10l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl10O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliOOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliOOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliOOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll00i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll00l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll00O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll01O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll10i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll10l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll10O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll11i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll11l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll11O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlli0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlli0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlli0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlli1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlli1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlli1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlliii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlliil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlliiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlliOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlliOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlll0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlll0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlll0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlll1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlllii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlllil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllliO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlllli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlllll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllllO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlllOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlllOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlllOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllO0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllO0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllO0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllO1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllO1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllO1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO00i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO00l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO00O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO01l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO01O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO10l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO10O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO11i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO11l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO11O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOi0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOliO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOllO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOOO_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nl1OO_a	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_nl1OO_b	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_gnd	:	STD_LOGIC;
	 SIGNAL  wire_nl1OO_o	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_nll01l_w_lg_w_o_range593w621w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nll01l_i	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nll01l_o	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nll01l_w_o_range587w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nll01l_w_o_range593w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niOOi_w_lg_o557w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niOOi_a	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_niOOi_b	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_niOOi_o	:	STD_LOGIC;
	 SIGNAL  wire_n0l0l_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n0l0l_o	:	STD_LOGIC;
	 SIGNAL  wire_n0l0l_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n0l0O_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n0l0O_o	:	STD_LOGIC;
	 SIGNAL  wire_n0l0O_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n0lii_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n0lii_o	:	STD_LOGIC;
	 SIGNAL  wire_n0lii_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n0lil_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n0lil_o	:	STD_LOGIC;
	 SIGNAL  wire_n0lil_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n0liO_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n0liO_o	:	STD_LOGIC;
	 SIGNAL  wire_n0liO_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n0lli_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n0lli_o	:	STD_LOGIC;
	 SIGNAL  wire_n0lli_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n0lll_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n0lll_o	:	STD_LOGIC;
	 SIGNAL  wire_n0lll_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n0llO_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n0llO_o	:	STD_LOGIC;
	 SIGNAL  wire_n0llO_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n0lOi_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n0lOi_o	:	STD_LOGIC;
	 SIGNAL  wire_n0lOi_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n1iil_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n1iil_o	:	STD_LOGIC;
	 SIGNAL  wire_n1iil_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n1iiO_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n1iiO_o	:	STD_LOGIC;
	 SIGNAL  wire_n1iiO_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n1ili_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n1ili_o	:	STD_LOGIC;
	 SIGNAL  wire_n1ili_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n1ill_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n1ill_o	:	STD_LOGIC;
	 SIGNAL  wire_n1ill_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n1ilO_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n1ilO_o	:	STD_LOGIC;
	 SIGNAL  wire_n1ilO_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n1iOi_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n1iOi_o	:	STD_LOGIC;
	 SIGNAL  wire_n1iOi_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n1iOl_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n1iOl_o	:	STD_LOGIC;
	 SIGNAL  wire_n1iOl_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n1iOO_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n1iOO_o	:	STD_LOGIC;
	 SIGNAL  wire_n1iOO_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n1l1i_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n1l1i_o	:	STD_LOGIC;
	 SIGNAL  wire_n1l1i_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_niili_data	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_niili_o	:	STD_LOGIC;
	 SIGNAL  wire_niili_sel	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_niilO_data	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_niilO_o	:	STD_LOGIC;
	 SIGNAL  wire_niilO_sel	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_niiOl_data	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_niiOl_o	:	STD_LOGIC;
	 SIGNAL  wire_niiOl_sel	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nll1ii_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_nll1ii_o	:	STD_LOGIC;
	 SIGNAL  wire_nll1ii_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_nll1il_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_nll1il_o	:	STD_LOGIC;
	 SIGNAL  wire_nll1il_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_nll1iO_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_nll1iO_o	:	STD_LOGIC;
	 SIGNAL  wire_nll1iO_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_nll1li_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_nll1li_o	:	STD_LOGIC;
	 SIGNAL  wire_nll1li_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_nll1ll_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_nll1ll_o	:	STD_LOGIC;
	 SIGNAL  wire_nll1ll_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_nll1lO_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_nll1lO_o	:	STD_LOGIC;
	 SIGNAL  wire_nll1lO_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_nll1Oi_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_nll1Oi_o	:	STD_LOGIC;
	 SIGNAL  wire_nll1Oi_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_nll1Ol_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_nll1Ol_o	:	STD_LOGIC;
	 SIGNAL  wire_nll1Ol_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_nll1OO_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_nll1OO_o	:	STD_LOGIC;
	 SIGNAL  wire_nll1OO_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_nlO0ll_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_nlO0ll_o	:	STD_LOGIC;
	 SIGNAL  wire_nlO0ll_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_nlO0lO_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_nlO0lO_o	:	STD_LOGIC;
	 SIGNAL  wire_nlO0lO_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_nlO0Oi_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_nlO0Oi_o	:	STD_LOGIC;
	 SIGNAL  wire_nlO0Oi_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_nlO0Ol_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_nlO0Ol_o	:	STD_LOGIC;
	 SIGNAL  wire_nlO0Ol_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_nlO0OO_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_nlO0OO_o	:	STD_LOGIC;
	 SIGNAL  wire_nlO0OO_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_nlOi0i_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_nlOi0i_o	:	STD_LOGIC;
	 SIGNAL  wire_nlOi0i_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_nlOi1i_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_nlOi1i_o	:	STD_LOGIC;
	 SIGNAL  wire_nlOi1i_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_nlOi1l_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_nlOi1l_o	:	STD_LOGIC;
	 SIGNAL  wire_nlOi1l_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_nlOi1O_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_nlOi1O_o	:	STD_LOGIC;
	 SIGNAL  wire_nlOi1O_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_nl110O495w496w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_rdenablesync554w556w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl111O563w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl11il559w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_rdenablesync558w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl100i1436w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl100l427w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl101i456w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl101O445w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl110i555w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl110O495w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl111i565w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl111l566w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl11ii503w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl11iO1437w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl11li475w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl11lO469w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl11Ol467w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_rdenablesync554w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_resetall477w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nl000O44w45w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nl001O67w68w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nl00li21w22w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nl010l145w146w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nl011l159w160w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nl01il130w131w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nl01lO105w106w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nl01OO90w91w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nl10Oi353w354w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nl1i1l340w341w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nl1iil323w324w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nl1ilO314w315w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nl1l0l280w281w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nl1l1l291w292w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nl1lli254w255w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nl1O0i213w214w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nl1O1i224w225w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nl1OiO199w200w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nl1OOl173w174w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  niOOil :	STD_LOGIC;
	 SIGNAL  niOOiO :	STD_LOGIC;
	 SIGNAL  niOOli :	STD_LOGIC;
	 SIGNAL  niOOll :	STD_LOGIC;
	 SIGNAL  niOOlO :	STD_LOGIC;
	 SIGNAL  niOOOi :	STD_LOGIC;
	 SIGNAL  niOOOl :	STD_LOGIC;
	 SIGNAL  niOOOO :	STD_LOGIC;
	 SIGNAL  nl000l :	STD_LOGIC;
	 SIGNAL  nl001l :	STD_LOGIC;
	 SIGNAL  nl00il :	STD_LOGIC;
	 SIGNAL  nl00iO :	STD_LOGIC;
	 SIGNAL  nl010i :	STD_LOGIC;
	 SIGNAL  nl011i :	STD_LOGIC;
	 SIGNAL  nl01ii :	STD_LOGIC;
	 SIGNAL  nl01li :	STD_LOGIC;
	 SIGNAL  nl01ll :	STD_LOGIC;
	 SIGNAL  nl01Ol :	STD_LOGIC;
	 SIGNAL  nl100i :	STD_LOGIC;
	 SIGNAL  nl100l :	STD_LOGIC;
	 SIGNAL  nl100O :	STD_LOGIC;
	 SIGNAL  nl101i :	STD_LOGIC;
	 SIGNAL  nl101l :	STD_LOGIC;
	 SIGNAL  nl101O :	STD_LOGIC;
	 SIGNAL  nl10ii :	STD_LOGIC;
	 SIGNAL  nl10il :	STD_LOGIC;
	 SIGNAL  nl10iO :	STD_LOGIC;
	 SIGNAL  nl10lO :	STD_LOGIC;
	 SIGNAL  nl10OO :	STD_LOGIC;
	 SIGNAL  nl110i :	STD_LOGIC;
	 SIGNAL  nl110l :	STD_LOGIC;
	 SIGNAL  nl110O :	STD_LOGIC;
	 SIGNAL  nl111i :	STD_LOGIC;
	 SIGNAL  nl111l :	STD_LOGIC;
	 SIGNAL  nl111O :	STD_LOGIC;
	 SIGNAL  nl11ii :	STD_LOGIC;
	 SIGNAL  nl11il :	STD_LOGIC;
	 SIGNAL  nl11iO :	STD_LOGIC;
	 SIGNAL  nl11li :	STD_LOGIC;
	 SIGNAL  nl11ll :	STD_LOGIC;
	 SIGNAL  nl11lO :	STD_LOGIC;
	 SIGNAL  nl11Oi :	STD_LOGIC;
	 SIGNAL  nl11Ol :	STD_LOGIC;
	 SIGNAL  nl11OO :	STD_LOGIC;
	 SIGNAL  nl1i0i :	STD_LOGIC;
	 SIGNAL  nl1i0l :	STD_LOGIC;
	 SIGNAL  nl1i0O :	STD_LOGIC;
	 SIGNAL  nl1i1i :	STD_LOGIC;
	 SIGNAL  nl1iii :	STD_LOGIC;
	 SIGNAL  nl1ili :	STD_LOGIC;
	 SIGNAL  nl1ill :	STD_LOGIC;
	 SIGNAL  nl1iOl :	STD_LOGIC;
	 SIGNAL  nl1iOO :	STD_LOGIC;
	 SIGNAL  nl1l0i :	STD_LOGIC;
	 SIGNAL  nl1l1i :	STD_LOGIC;
	 SIGNAL  nl1lii :	STD_LOGIC;
	 SIGNAL  nl1lil :	STD_LOGIC;
	 SIGNAL  nl1liO :	STD_LOGIC;
	 SIGNAL  nl1llO :	STD_LOGIC;
	 SIGNAL  nl1lOi :	STD_LOGIC;
	 SIGNAL  nl1lOl :	STD_LOGIC;
	 SIGNAL  nl1lOO :	STD_LOGIC;
	 SIGNAL  nl1O0O :	STD_LOGIC;
	 SIGNAL  nl1O1O :	STD_LOGIC;
	 SIGNAL  nl1Oii :	STD_LOGIC;
	 SIGNAL  nl1Oil :	STD_LOGIC;
	 SIGNAL  nl1Oll :	STD_LOGIC;
	 SIGNAL  nl1OlO :	STD_LOGIC;
	 SIGNAL  nl1OOi :	STD_LOGIC;
	 SIGNAL  w_nl000O44w :	STD_LOGIC;
	 SIGNAL  w_nl001O67w :	STD_LOGIC;
	 SIGNAL  w_nl00li21w :	STD_LOGIC;
	 SIGNAL  w_nl010l145w :	STD_LOGIC;
	 SIGNAL  w_nl011l159w :	STD_LOGIC;
	 SIGNAL  w_nl01il130w :	STD_LOGIC;
	 SIGNAL  w_nl01lO105w :	STD_LOGIC;
	 SIGNAL  w_nl01OO90w :	STD_LOGIC;
	 SIGNAL  w_nl10li360w :	STD_LOGIC;
	 SIGNAL  w_nl10Oi353w :	STD_LOGIC;
	 SIGNAL  w_nl1i1l340w :	STD_LOGIC;
	 SIGNAL  w_nl1iil323w :	STD_LOGIC;
	 SIGNAL  w_nl1ilO314w :	STD_LOGIC;
	 SIGNAL  w_nl1l0l280w :	STD_LOGIC;
	 SIGNAL  w_nl1l1l291w :	STD_LOGIC;
	 SIGNAL  w_nl1lli254w :	STD_LOGIC;
	 SIGNAL  w_nl1O0i213w :	STD_LOGIC;
	 SIGNAL  w_nl1O1i224w :	STD_LOGIC;
	 SIGNAL  w_nl1OiO199w :	STD_LOGIC;
	 SIGNAL  w_nl1OOl173w :	STD_LOGIC;
	 COMPONENT  oper_add
	 GENERIC 
	 (
		sgate_representation	:	NATURAL;
		width_a	:	NATURAL;
		width_b	:	NATURAL;
		width_o	:	NATURAL
	 );
	 PORT
	 ( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		b	:	IN STD_LOGIC_VECTOR(width_b-1 DOWNTO 0);
		cin	:	IN STD_LOGIC;
		cout	:	OUT STD_LOGIC;
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	 ); 
	 END COMPONENT;
	 COMPONENT  oper_decoder
	 GENERIC 
	 (
		width_i	:	NATURAL;
		width_o	:	NATURAL
	 );
	 PORT
	 ( 
		i	:	IN STD_LOGIC_VECTOR(width_i-1 DOWNTO 0);
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	 ); 
	 END COMPONENT;
	 COMPONENT  oper_less_than
	 GENERIC 
	 (
		sgate_representation	:	NATURAL;
		width_a	:	NATURAL;
		width_b	:	NATURAL
	 );
	 PORT
	 ( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		b	:	IN STD_LOGIC_VECTOR(width_b-1 DOWNTO 0);
		cin	:	IN STD_LOGIC;
		o	:	OUT STD_LOGIC
	 ); 
	 END COMPONENT;
	 COMPONENT  oper_selector
	 GENERIC 
	 (
		width_data	:	NATURAL;
		width_sel	:	NATURAL
	 );
	 PORT
	 ( 
		data	:	IN STD_LOGIC_VECTOR(width_data-1 DOWNTO 0);
		o	:	OUT STD_LOGIC;
		sel	:	IN STD_LOGIC_VECTOR(width_sel-1 DOWNTO 0)
	 ); 
	 END COMPONENT;
 BEGIN

	wire_gnd <= '0';
	wire_w_lg_w_lg_nl110O495w496w(0) <= wire_w_lg_nl110O495w(0) AND nl11il;
	wire_w_lg_w_lg_rdenablesync554w556w(0) <= wire_w_lg_rdenablesync554w(0) AND wire_w_lg_nl110i555w(0);
	wire_w_lg_nl111O563w(0) <= nl111O AND wire_nlilil_w_lg_w_lg_Q561w562w(0);
	wire_w_lg_nl11il559w(0) <= nl11il AND wire_w_lg_rdenablesync558w(0);
	wire_w_lg_rdenablesync558w(0) <= rdenablesync AND wire_w_lg_nl110i555w(0);
	wire_w_lg_nl100i1436w(0) <= NOT nl100i;
	wire_w_lg_nl100l427w(0) <= NOT nl100l;
	wire_w_lg_nl101i456w(0) <= NOT nl101i;
	wire_w_lg_nl101O445w(0) <= NOT nl101O;
	wire_w_lg_nl110i555w(0) <= NOT nl110i;
	wire_w_lg_nl110O495w(0) <= NOT nl110O;
	wire_w_lg_nl111i565w(0) <= NOT nl111i;
	wire_w_lg_nl111l566w(0) <= NOT nl111l;
	wire_w_lg_nl11ii503w(0) <= NOT nl11ii;
	wire_w_lg_nl11iO1437w(0) <= NOT nl11iO;
	wire_w_lg_nl11li475w(0) <= NOT nl11li;
	wire_w_lg_nl11lO469w(0) <= NOT nl11lO;
	wire_w_lg_nl11Ol467w(0) <= NOT nl11Ol;
	wire_w_lg_rdenablesync554w(0) <= NOT rdenablesync;
	wire_w_lg_resetall477w(0) <= NOT resetall;
	wire_w_lg_w_nl000O44w45w(0) <= NOT w_nl000O44w;
	wire_w_lg_w_nl001O67w68w(0) <= NOT w_nl001O67w;
	wire_w_lg_w_nl00li21w22w(0) <= NOT w_nl00li21w;
	wire_w_lg_w_nl010l145w146w(0) <= NOT w_nl010l145w;
	wire_w_lg_w_nl011l159w160w(0) <= NOT w_nl011l159w;
	wire_w_lg_w_nl01il130w131w(0) <= NOT w_nl01il130w;
	wire_w_lg_w_nl01lO105w106w(0) <= NOT w_nl01lO105w;
	wire_w_lg_w_nl01OO90w91w(0) <= NOT w_nl01OO90w;
	wire_w_lg_w_nl10Oi353w354w(0) <= NOT w_nl10Oi353w;
	wire_w_lg_w_nl1i1l340w341w(0) <= NOT w_nl1i1l340w;
	wire_w_lg_w_nl1iil323w324w(0) <= NOT w_nl1iil323w;
	wire_w_lg_w_nl1ilO314w315w(0) <= NOT w_nl1ilO314w;
	wire_w_lg_w_nl1l0l280w281w(0) <= NOT w_nl1l0l280w;
	wire_w_lg_w_nl1l1l291w292w(0) <= NOT w_nl1l1l291w;
	wire_w_lg_w_nl1lli254w255w(0) <= NOT w_nl1lli254w;
	wire_w_lg_w_nl1O0i213w214w(0) <= NOT w_nl1O0i213w;
	wire_w_lg_w_nl1O1i224w225w(0) <= NOT w_nl1O1i224w;
	wire_w_lg_w_nl1OiO199w200w(0) <= NOT w_nl1OiO199w;
	wire_w_lg_w_nl1OOl173w174w(0) <= NOT w_nl1OOl173w;
	niOOil <= (((((((wire_nll01l_o(15) OR wire_nll01l_o(14)) OR wire_nll01l_o(13)) OR wire_nll01l_o(12)) OR wire_nll01l_o(11)) OR wire_nll01l_o(10)) OR wire_nll01l_o(9)) OR wire_nll01l_o(0));
	niOOiO <= (nl11Oi OR niOOll);
	niOOli <= (((((((wire_nll01l_o(15) OR wire_nll01l_o(14)) OR wire_nll01l_o(13)) OR wire_nll01l_o(12)) OR wire_nll01l_o(11)) OR wire_nll01l_o(10)) OR wire_nll01l_o(9)) OR wire_nll01l_o(0));
	niOOll <= (nl101l OR nl11OO);
	niOOlO <= (((((((wire_nll01l_o(15) OR wire_nll01l_o(14)) OR wire_nll01l_o(13)) OR wire_nll01l_o(12)) OR wire_nll01l_o(11)) OR wire_nll01l_o(10)) OR wire_nll01l_o(9)) OR wire_nll01l_o(0));
	niOOOi <= (((((((((wire_nll01l_o(4) OR wire_nll01l_o(3)) OR wire_nll01l_o(15)) OR wire_nll01l_o(14)) OR wire_nll01l_o(13)) OR wire_nll01l_o(12)) OR wire_nll01l_o(11)) OR wire_nll01l_o(10)) OR wire_nll01l_o(9)) OR wire_nll01l_o(0));
	niOOOl <= (((((((wire_nll01l_o(15) OR wire_nll01l_o(14)) OR wire_nll01l_o(13)) OR wire_nll01l_o(12)) OR wire_nll01l_o(11)) OR wire_nll01l_o(10)) OR wire_nll01l_o(9)) OR wire_nll01l_o(0));
	niOOOO <= ((((((((wire_nll01l_o(1) OR wire_nll01l_o(15)) OR wire_nll01l_o(14)) OR wire_nll01l_o(13)) OR wire_nll01l_o(12)) OR wire_nll01l_o(11)) OR wire_nll01l_o(10)) OR wire_nll01l_o(9)) OR wire_nll01l_o(0));
	nl000l <= ((((((((txdatain(15) OR txdatain(14)) OR txdatain(13)) OR txdatain(12)) OR txdatain(11)) OR (NOT txdatain(9))) OR (NOT txdatain(8))) OR (NOT txdatain(10))) OR wire_w_lg_w_nl000O44w45w(0));
	nl001l <= ((((((((txdatain(23) OR txdatain(22)) OR txdatain(21)) OR txdatain(20)) OR txdatain(19)) OR (NOT txdatain(17))) OR (NOT txdatain(16))) OR (NOT txdatain(18))) OR wire_w_lg_w_nl001O67w68w(0));
	nl00il <= ((((((((txdatain(7) OR txdatain(6)) OR txdatain(5)) OR txdatain(4)) OR txdatain(3)) OR (NOT txdatain(1))) OR (NOT txdatain(0))) OR (NOT txdatain(2))) OR wire_w_lg_w_nl00li21w22w(0));
	nl00iO <= txclk;
	nl010i <= (((((((((NOT txdatain(31)) OR txdatain(30)) OR txdatain(29)) OR (NOT txdatain(28))) OR (NOT txdatain(27))) OR txdatain(25)) OR txdatain(24)) OR (NOT txdatain(26))) OR wire_w_lg_w_nl010l145w146w(0));
	nl011i <= (((((((((NOT txdatain(7)) OR (NOT txdatain(6))) OR (NOT txdatain(5))) OR (NOT txdatain(4))) OR (NOT txdatain(3))) OR (NOT txdatain(1))) OR (NOT txdatain(0))) OR txdatain(2)) OR wire_w_lg_w_nl011l159w160w(0));
	nl01ii <= (((((((((NOT txdatain(23)) OR txdatain(22)) OR txdatain(21)) OR (NOT txdatain(20))) OR (NOT txdatain(19))) OR txdatain(17)) OR txdatain(16)) OR (NOT txdatain(18))) OR wire_w_lg_w_nl01il130w131w(0));
	nl01li <= ((((((((NOT txdatain(15)) OR txdatain(14)) OR txdatain(13)) OR (NOT txdatain(12))) OR (NOT txdatain(11))) OR txdatain(9)) OR txdatain(8)) OR (NOT txdatain(10)));
	nl01ll <= (((((((((NOT txdatain(7)) OR txdatain(6)) OR txdatain(5)) OR (NOT txdatain(4))) OR (NOT txdatain(3))) OR txdatain(1)) OR txdatain(0)) OR (NOT txdatain(2))) OR wire_w_lg_w_nl01lO105w106w(0));
	nl01Ol <= ((((((((txdatain(31) OR txdatain(30)) OR txdatain(29)) OR txdatain(28)) OR txdatain(27)) OR (NOT txdatain(25))) OR (NOT txdatain(24))) OR (NOT txdatain(26))) OR wire_w_lg_w_nl01OO90w91w(0));
	nl100i <= ((((txctrl(3) AND txctrl(2)) AND txctrl(1)) AND txctrl(0)) AND wire_w_lg_nl100l427w(0));
	nl100l <= (((((((((((((((((((((((((((((((txdatain(31) OR txdatain(30)) OR txdatain(29)) OR txdatain(28)) OR txdatain(27)) OR (NOT txdatain(25))) OR (NOT txdatain(24))) OR (NOT txdatain(26))) OR txdatain(23)) OR txdatain(22)) OR txdatain(21)) OR txdatain(20)) OR txdatain(19)) OR (NOT txdatain(17))) OR (NOT txdatain(16))) OR (NOT txdatain(18))) OR txdatain(15)) OR txdatain(14)) OR txdatain(13)) OR txdatain(12)) OR txdatain(11)) OR (NOT txdatain(9))) OR (NOT txdatain(8))) OR (NOT txdatain(10))) OR txdatain(7)) OR txdatain(6)) OR txdatain(5)) OR txdatain(4)) OR txdatain(3)) OR (NOT txdatain(1))) OR (NOT txdatain(0))) OR (NOT txdatain(2)));
	nl100O <= (nl10lO AND (nl1i0l AND (nl1ill AND (nl1l0i AND (nl1llO AND (nl1O1O AND (nl1Oll AND (nl010i AND (txctrl(3) AND nl01Ol)))))))));
	nl101i <= (((((((((((((((((((((((txdatain(31) OR txdatain(30)) OR txdatain(29)) OR txdatain(28)) OR txdatain(27)) OR (NOT txdatain(25))) OR (NOT txdatain(24))) OR (NOT txdatain(26))) OR txdatain(23)) OR txdatain(22)) OR txdatain(21)) OR txdatain(20)) OR txdatain(19)) OR (NOT txdatain(17))) OR (NOT txdatain(16))) OR (NOT txdatain(18))) OR (NOT txdatain(15))) OR (NOT txdatain(14))) OR (NOT txdatain(13))) OR (NOT txdatain(12))) OR (NOT txdatain(11))) OR txdatain(9)) OR (NOT txdatain(8))) OR (NOT txdatain(10)));
	nl101l <= ((NOT ((((NOT txctrl(3)) OR (NOT txctrl(2))) OR (NOT txctrl(1))) OR (NOT txctrl(0)))) AND wire_w_lg_nl101O445w(0));
	nl101O <= (((((((((((((((((((((((((((((((txdatain(31) OR txdatain(30)) OR txdatain(29)) OR txdatain(28)) OR txdatain(27)) OR (NOT txdatain(25))) OR (NOT txdatain(24))) OR (NOT txdatain(26))) OR txdatain(23)) OR txdatain(22)) OR txdatain(21)) OR txdatain(20)) OR txdatain(19)) OR (NOT txdatain(17))) OR (NOT txdatain(16))) OR (NOT txdatain(18))) OR txdatain(15)) OR txdatain(14)) OR txdatain(13)) OR txdatain(12)) OR txdatain(11)) OR (NOT txdatain(9))) OR (NOT txdatain(8))) OR (NOT txdatain(10))) OR (NOT txdatain(7))) OR (NOT txdatain(6))) OR (NOT txdatain(5))) OR (NOT txdatain(4))) OR (NOT txdatain(3))) OR txdatain(1)) OR (NOT txdatain(0))) OR (NOT txdatain(2)));
	nl10ii <= (nl10OO AND (nl1i0O AND (nl1iOl AND (nl1lii AND (nl1lOi AND (nl1O0O AND (nl1OlO AND (nl01ii AND (txctrl(2) AND nl001l)))))))));
	nl10il <= (nl1i1i AND (nl1iii AND (nl1iOO AND (nl1lil AND (nl1lOl AND (nl1Oii AND (nl1OOi AND (nl01li AND (txctrl(1) AND nl000l)))))))));
	nl10iO <= (nl1i0i AND (nl1ili AND (nl1l1i AND (nl1liO AND (nl1lOO AND (nl1Oil AND (nl011i AND (nl01ll AND ((txctrl(0) AND nl00il) AND w_nl10li360w)))))))));
	nl10lO <= (((((((((NOT txdatain(31)) OR (NOT txdatain(30))) OR (NOT txdatain(29))) OR (NOT txdatain(28))) OR txdatain(27)) OR (NOT txdatain(25))) OR (NOT txdatain(24))) OR (NOT txdatain(26))) OR wire_w_lg_w_nl10Oi353w354w(0));
	nl10OO <= ((((((((NOT txdatain(23)) OR (NOT txdatain(22))) OR (NOT txdatain(21))) OR (NOT txdatain(20))) OR txdatain(19)) OR (NOT txdatain(17))) OR (NOT txdatain(16))) OR (NOT txdatain(18)));
	nl110i <= ((wire_nlO1i_w_lg_Q479w(0) OR wire_nliOil_w_lg_Q480w(0)) OR wire_nliOii_w_lg_Q487w(0));
	nl110l <= (wire_w_lg_w_lg_nl110O495w496w(0) AND (((NOT ((wire_nlO1i_w_lg_w_lg_Q484w485w(0) OR wire_nliOil_w_lg_Q480w(0)) OR nliOii)) OR (NOT (wire_nlO1i_w_lg_w_lg_w_lg_Q484w485w499w(0) OR wire_nliOii_w_lg_Q487w(0)))) OR wire_nlilil_w_lg_Q504w(0)));
	nl110O <= ((((nl10i OR nl11O) OR nl11l) OR nl11i) OR nliliO);
	nl111i <= (wire_w_lg_nl100i1436w(0) AND wire_w_lg_nl11iO1437w(0));
	nl111l <= (nlilil AND wire_w_lg_nl110O495w(0));
	nl111O <= (nl11il AND wire_w_lg_nl11ii503w(0));
	nl11ii <= (wire_nlO1i_w_lg_w_lg_Q479w493w(0) OR wire_nliOii_w_lg_Q487w(0));
	nl11il <= (nl100i OR nl11iO);
	nl11iO <= ((NOT (((txctrl(3) OR txctrl(2)) OR txctrl(1)) OR (NOT txctrl(0)))) AND wire_w_lg_nl11li475w(0));
	nl11li <= ((((((((NOT txdatain(7)) OR txdatain(6)) OR txdatain(5)) OR (NOT txdatain(4))) OR (NOT txdatain(3))) OR txdatain(1)) OR txdatain(0)) OR (NOT txdatain(2)));
	nl11ll <= (txctrl(3) AND wire_w_lg_nl11lO469w(0));
	nl11lO <= ((((((((NOT txdatain(31)) OR (NOT txdatain(30))) OR (NOT txdatain(29))) OR (NOT txdatain(28))) OR (NOT txdatain(27))) OR txdatain(25)) OR (NOT txdatain(24))) OR (NOT txdatain(26)));
	nl11Oi <= ((NOT ((NOT txctrl(3)) OR (NOT txctrl(2)))) AND wire_w_lg_nl11Ol467w(0));
	nl11Ol <= (((((((((((((((txdatain(31) OR txdatain(30)) OR txdatain(29)) OR txdatain(28)) OR txdatain(27)) OR (NOT txdatain(25))) OR (NOT txdatain(24))) OR (NOT txdatain(26))) OR (NOT txdatain(23))) OR (NOT txdatain(22))) OR (NOT txdatain(21))) OR (NOT txdatain(20))) OR (NOT txdatain(19))) OR txdatain(17)) OR (NOT txdatain(16))) OR (NOT txdatain(18)));
	nl11OO <= ((NOT (((NOT txctrl(3)) OR (NOT txctrl(2))) OR (NOT txctrl(1)))) AND wire_w_lg_nl101i456w(0));
	nl1i0i <= ((((((((NOT txdatain(7)) OR (NOT txdatain(6))) OR (NOT txdatain(5))) OR (NOT txdatain(4))) OR txdatain(3)) OR (NOT txdatain(1))) OR (NOT txdatain(0))) OR (NOT txdatain(2)));
	nl1i0l <= ((((((((NOT txdatain(31)) OR (NOT txdatain(30))) OR (NOT txdatain(29))) OR (NOT txdatain(28))) OR (NOT txdatain(27))) OR txdatain(25)) OR txdatain(24)) OR (NOT txdatain(26)));
	nl1i0O <= ((((((((NOT txdatain(23)) OR (NOT txdatain(22))) OR (NOT txdatain(21))) OR (NOT txdatain(20))) OR (NOT txdatain(19))) OR txdatain(17)) OR txdatain(16)) OR (NOT txdatain(18)));
	nl1i1i <= (((((((((NOT txdatain(15)) OR (NOT txdatain(14))) OR (NOT txdatain(13))) OR (NOT txdatain(12))) OR txdatain(11)) OR (NOT txdatain(9))) OR (NOT txdatain(8))) OR (NOT txdatain(10))) OR wire_w_lg_w_nl1i1l340w341w(0));
	nl1iii <= (((((((((NOT txdatain(15)) OR (NOT txdatain(14))) OR (NOT txdatain(13))) OR (NOT txdatain(12))) OR (NOT txdatain(11))) OR txdatain(9)) OR txdatain(8)) OR (NOT txdatain(10))) OR wire_w_lg_w_nl1iil323w324w(0));
	nl1ili <= ((((((((NOT txdatain(7)) OR (NOT txdatain(6))) OR (NOT txdatain(5))) OR (NOT txdatain(4))) OR (NOT txdatain(3))) OR txdatain(1)) OR txdatain(0)) OR (NOT txdatain(2)));
	nl1ill <= (((((((((NOT txdatain(31)) OR (NOT txdatain(30))) OR txdatain(29)) OR (NOT txdatain(28))) OR (NOT txdatain(27))) OR txdatain(25)) OR txdatain(24)) OR (NOT txdatain(26))) OR wire_w_lg_w_nl1ilO314w315w(0));
	nl1iOl <= ((((((((NOT txdatain(23)) OR (NOT txdatain(22))) OR txdatain(21)) OR (NOT txdatain(20))) OR (NOT txdatain(19))) OR txdatain(17)) OR txdatain(16)) OR (NOT txdatain(18)));
	nl1iOO <= ((((((((NOT txdatain(15)) OR (NOT txdatain(14))) OR txdatain(13)) OR (NOT txdatain(12))) OR (NOT txdatain(11))) OR txdatain(9)) OR txdatain(8)) OR (NOT txdatain(10)));
	nl1l0i <= ((((((((txdatain(31) OR (NOT txdatain(30))) OR txdatain(29)) OR (NOT txdatain(28))) OR (NOT txdatain(27))) OR txdatain(25)) OR txdatain(24)) OR (NOT txdatain(26))) OR wire_w_lg_w_nl1l0l280w281w(0));
	nl1l1i <= (((((((((NOT txdatain(7)) OR (NOT txdatain(6))) OR txdatain(5)) OR (NOT txdatain(4))) OR (NOT txdatain(3))) OR txdatain(1)) OR txdatain(0)) OR (NOT txdatain(2))) OR wire_w_lg_w_nl1l1l291w292w(0));
	nl1lii <= (((((((txdatain(23) OR (NOT txdatain(22))) OR txdatain(21)) OR (NOT txdatain(20))) OR (NOT txdatain(19))) OR txdatain(17)) OR txdatain(16)) OR (NOT txdatain(18)));
	nl1lil <= (((((((txdatain(15) OR (NOT txdatain(14))) OR txdatain(13)) OR (NOT txdatain(12))) OR (NOT txdatain(11))) OR txdatain(9)) OR txdatain(8)) OR (NOT txdatain(10)));
	nl1liO <= ((((((((txdatain(7) OR (NOT txdatain(6))) OR txdatain(5)) OR (NOT txdatain(4))) OR (NOT txdatain(3))) OR txdatain(1)) OR txdatain(0)) OR (NOT txdatain(2))) OR wire_w_lg_w_nl1lli254w255w(0));
	nl1llO <= (((((((txdatain(31) OR txdatain(30)) OR (NOT txdatain(29))) OR (NOT txdatain(28))) OR (NOT txdatain(27))) OR txdatain(25)) OR txdatain(24)) OR (NOT txdatain(26)));
	nl1lOi <= (((((((txdatain(23) OR txdatain(22)) OR (NOT txdatain(21))) OR (NOT txdatain(20))) OR (NOT txdatain(19))) OR txdatain(17)) OR txdatain(16)) OR (NOT txdatain(18)));
	nl1lOl <= (((((((txdatain(15) OR txdatain(14)) OR (NOT txdatain(13))) OR (NOT txdatain(12))) OR (NOT txdatain(11))) OR txdatain(9)) OR txdatain(8)) OR (NOT txdatain(10)));
	nl1lOO <= ((((((((txdatain(7) OR txdatain(6)) OR (NOT txdatain(5))) OR (NOT txdatain(4))) OR (NOT txdatain(3))) OR txdatain(1)) OR txdatain(0)) OR (NOT txdatain(2))) OR wire_w_lg_w_nl1O1i224w225w(0));
	nl1O0O <= ((((((((NOT txdatain(23)) OR (NOT txdatain(22))) OR (NOT txdatain(21))) OR (NOT txdatain(20))) OR (NOT txdatain(19))) OR txdatain(17)) OR (NOT txdatain(16))) OR (NOT txdatain(18)));
	nl1O1O <= (((((((((NOT txdatain(31)) OR (NOT txdatain(30))) OR (NOT txdatain(29))) OR (NOT txdatain(28))) OR (NOT txdatain(27))) OR txdatain(25)) OR (NOT txdatain(24))) OR (NOT txdatain(26))) OR wire_w_lg_w_nl1O0i213w214w(0));
	nl1Oii <= ((((((((NOT txdatain(15)) OR (NOT txdatain(14))) OR (NOT txdatain(13))) OR (NOT txdatain(12))) OR (NOT txdatain(11))) OR txdatain(9)) OR (NOT txdatain(8))) OR (NOT txdatain(10)));
	nl1Oil <= (((((((((NOT txdatain(7)) OR (NOT txdatain(6))) OR (NOT txdatain(5))) OR (NOT txdatain(4))) OR (NOT txdatain(3))) OR txdatain(1)) OR (NOT txdatain(0))) OR (NOT txdatain(2))) OR wire_w_lg_w_nl1OiO199w200w(0));
	nl1Oll <= ((((((((NOT txdatain(31)) OR (NOT txdatain(30))) OR (NOT txdatain(29))) OR (NOT txdatain(28))) OR (NOT txdatain(27))) OR (NOT txdatain(25))) OR (NOT txdatain(24))) OR txdatain(26));
	nl1OlO <= ((((((((NOT txdatain(23)) OR (NOT txdatain(22))) OR (NOT txdatain(21))) OR (NOT txdatain(20))) OR (NOT txdatain(19))) OR (NOT txdatain(17))) OR (NOT txdatain(16))) OR txdatain(18));
	nl1OOi <= (((((((((NOT txdatain(15)) OR (NOT txdatain(14))) OR (NOT txdatain(13))) OR (NOT txdatain(12))) OR (NOT txdatain(11))) OR (NOT txdatain(9))) OR (NOT txdatain(8))) OR txdatain(10)) OR wire_w_lg_w_nl1OOl173w174w(0));
	txctrlout <= ( nli0Ol & nlii0l & nliill & nlil1l);
	txdataout <= ( nlii0i & nliOlO & nlii1O & nlii1l & nlii1i & nli0OO & nliOll & nliOli & nliili & nlO01i & nliiiO & nliiil & nliiii & nlii0O & nlO1OO & nlO1Ol & nlil1i & n10Oi & nliiOO & nliiOl & nliiOi & nliilO & n10lO & n10ll & nlilii & n0ili & nlil0O & nlil0l & nlil0i & nlil1O & n0iiO & n0iil);
	w_nl000O44w <= nl000O6;
	w_nl001O67w <= nl001O9;
	w_nl00li21w <= nl00li3;
	w_nl010l145w <= nl010l21;
	w_nl011l159w <= nl011l24;
	w_nl01il130w <= nl01il18;
	w_nl01lO105w <= nl01lO15;
	w_nl01OO90w <= nl01OO12;
	w_nl10li360w <= nl10li60;
	w_nl10Oi353w <= nl10Oi57;
	w_nl1i1l340w <= nl1i1l54;
	w_nl1iil323w <= nl1iil51;
	w_nl1ilO314w <= nl1ilO48;
	w_nl1l0l280w <= nl1l0l42;
	w_nl1l1l291w <= nl1l1l45;
	w_nl1lli254w <= nl1lli39;
	w_nl1O0i213w <= nl1O0i33;
	w_nl1O1i224w <= nl1O1i36;
	w_nl1OiO199w <= nl1OiO30;
	w_nl1OOl173w <= nl1OOl27;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n0iil <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN n0iil <= wire_n0ilO_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n0iiO <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN n0iiO <= wire_n0iOi_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n0ili <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN n0ili <= wire_n0l1O_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n10ll <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN n10ll <= wire_n10OO_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n10lO <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN n10lO <= wire_n1i1i_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n10Oi <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN n10Oi <= wire_n1i0O_dataout;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl000O4 <= nl000O5;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl000O5 <= nl000O4;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl000O6 <= (nl000O5 XOR nl000O4);
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl001O7 <= nl001O8;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl001O8 <= nl001O7;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl001O9 <= (nl001O8 XOR nl001O7);
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl00li1 <= nl00li2;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl00li2 <= nl00li1;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl00li3 <= (nl00li2 XOR nl00li1);
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl010l19 <= nl010l20;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl010l20 <= nl010l19;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl010l21 <= (nl010l20 XOR nl010l19);
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl011l22 <= nl011l23;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl011l23 <= nl011l22;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl011l24 <= (nl011l23 XOR nl011l22);
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl01il16 <= nl01il17;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl01il17 <= nl01il16;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl01il18 <= (nl01il17 XOR nl01il16);
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl01lO13 <= nl01lO14;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl01lO14 <= nl01lO13;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl01lO15 <= (nl01lO14 XOR nl01lO13);
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl01OO10 <= nl01OO11;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl01OO11 <= nl01OO10;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl01OO12 <= (nl01OO11 XOR nl01OO10);
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nl0li <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN 
			IF (nl11iO = '1') THEN nl0li <= txdatain(0);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nl0ll <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN 
			IF (nl11iO = '1') THEN nl0ll <= txdatain(1);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nl0lO <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN 
			IF (nl11iO = '1') THEN nl0lO <= txdatain(5);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nl0Oi <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN 
			IF (nl11iO = '1') THEN nl0Oi <= txdatain(6);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nl0Ol <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN 
			IF (nl11iO = '1') THEN nl0Ol <= txdatain(8);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nl0OO <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN 
			IF (nl11iO = '1') THEN nl0OO <= txdatain(9);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nl10i <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN nl10i <= wire_nl1il_dataout;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl10li58 <= nl10li59;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl10li59 <= nl10li58;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl10li60 <= (nl10li59 XOR nl10li58);
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl10Oi55 <= nl10Oi56;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl10Oi56 <= nl10Oi55;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl10Oi57 <= (nl10Oi56 XOR nl10Oi55);
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nl11i <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN nl11i <= wire_nl10l_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nl11l <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN nl11l <= wire_nl10O_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nl11O <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN nl11O <= wire_nl1ii_dataout;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl1i1l52 <= nl1i1l53;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl1i1l53 <= nl1i1l52;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl1i1l54 <= (nl1i1l53 XOR nl1i1l52);
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl1iil49 <= nl1iil50;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl1iil50 <= nl1iil49;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl1iil51 <= (nl1iil50 XOR nl1iil49);
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl1ilO46 <= nl1ilO47;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl1ilO47 <= nl1ilO46;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl1ilO48 <= (nl1ilO47 XOR nl1ilO46);
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl1l0l40 <= nl1l0l41;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl1l0l41 <= nl1l0l40;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl1l0l42 <= (nl1l0l41 XOR nl1l0l40);
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl1l1l43 <= nl1l1l44;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl1l1l44 <= nl1l1l43;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl1l1l45 <= (nl1l1l44 XOR nl1l1l43);
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl1lli37 <= nl1lli38;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl1lli38 <= nl1lli37;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl1lli39 <= (nl1lli38 XOR nl1lli37);
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl1O0i31 <= nl1O0i32;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl1O0i32 <= nl1O0i31;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl1O0i33 <= (nl1O0i32 XOR nl1O0i31);
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl1O1i34 <= nl1O1i35;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl1O1i35 <= nl1O1i34;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl1O1i36 <= (nl1O1i35 XOR nl1O1i34);
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl1OiO28 <= nl1OiO29;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl1OiO29 <= nl1OiO28;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl1OiO30 <= (nl1OiO29 XOR nl1OiO28);
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl1OOl25 <= nl1OOl26;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl1OOl26 <= nl1OOl25;
		END IF;
	END PROCESS;
	PROCESS (nl00iO)
	BEGIN
		IF (nl00iO = '1' AND nl00iO'event) THEN nl1OOl27 <= (nl1OOl26 XOR nl1OOl25);
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nli0i <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN 
			IF (nl11iO = '1') THEN nli0i <= txdatain(13);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nli0l <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN 
			IF (nl11iO = '1') THEN nli0l <= txdatain(14);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nli0O <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN 
			IF (nl11iO = '1') THEN nli0O <= txdatain(15);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nli0Ol <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN nli0Ol <= wire_nliOOi_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nli0OO <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN nli0OO <= wire_nll11i_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nli1i <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN 
			IF (nl11iO = '1') THEN nli1i <= txdatain(10);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nli1l <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN 
			IF (nl11iO = '1') THEN nli1l <= txdatain(11);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nli1O <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN 
			IF (nl11iO = '1') THEN nli1O <= txdatain(12);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlii0i <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN nlii0i <= wire_nll10O_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlii0l <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN nlii0l <= wire_nlO01l_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlii0O <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN nlii0O <= wire_nlO00l_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlii1i <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN nlii1i <= wire_nll11l_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlii1l <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN nlii1l <= wire_nll11O_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlii1O <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN nlii1O <= wire_nll10i_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nliii <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN 
			IF (nl11iO = '1') THEN nliii <= txdatain(16);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nliiii <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN nliiii <= wire_nlO00O_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nliiil <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN nliiil <= wire_nlO0ii_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nliiiO <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN nliiiO <= wire_nlO0il_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nliil <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN 
			IF (nl11iO = '1') THEN nliil <= txdatain(17);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nliili <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN nliili <= wire_nlO0li_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nliill <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN nliill <= wire_n10Ol_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nliilO <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN nliilO <= wire_n1i1l_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nliiO <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN 
			IF (nl11iO = '1') THEN nliiO <= txdatain(18);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nliiOi <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN nliiOi <= wire_n1i1O_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nliiOl <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN nliiOl <= wire_n1i0i_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nliiOO <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN nliiOO <= wire_n1i0l_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlil0i <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN nlil0i <= wire_n0iOO_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlil0l <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN nlil0l <= wire_n0l1i_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlil0O <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN nlil0O <= wire_n0l1l_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlil1i <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN nlil1i <= wire_n1iii_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlil1l <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN nlil1l <= wire_n0ill_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlil1O <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN nlil1O <= wire_n0iOl_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlili <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN 
			IF (nl11iO = '1') THEN nlili <= txdatain(19);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlilii <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN nlilii <= wire_n0l0i_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlilil <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN nlilil <= wire_niO1i_dataout;
		END IF;
	END PROCESS;
	wire_nlilil_w_lg_Q504w(0) <= nlilil AND wire_w_lg_nl11ii503w(0);
	wire_nlilil_w_lg_Q561w(0) <= NOT nlilil;
	wire_nlilil_w_lg_w_lg_Q561w562w(0) <= wire_nlilil_w_lg_Q561w(0) OR nl110O;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nliliO <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN nliliO <= wire_nl1iO_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlill <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN 
			IF (nl11iO = '1') THEN nlill <= txdatain(20);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlilli <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN nlilli <= (nliO1i XOR 
		nlilOO);
		END IF;
	END PROCESS;
	wire_nlilli_w_lg_Q568w(0) <= NOT nlilli;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlilll <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN nlilll <= nlilli;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlillO <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN nlillO <= nlilll;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlilO <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN 
			IF (nl11iO = '1') THEN nlilO <= txdatain(21);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlilOi <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN nlilOi <= nlillO;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlilOl <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN nlilOl <= nlilOi;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlilOO <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN nlilOO <= nlilOl;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nliO0i <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN 
			IF (nl11iO = '1') THEN nliO0i <= txdatain(4);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nliO0l <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN 
			IF (nl11iO = '1') THEN nliO0l <= txdatain(7);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nliO0O <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN 
			IF (nl11iO = '1') THEN nliO0O <= txdatain(25);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nliO1i <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN nliO1i <= nlilOO;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nliO1l <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN 
			IF (nl11iO = '1') THEN nliO1l <= txdatain(2);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nliO1O <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN 
			IF (nl11iO = '1') THEN nliO1O <= txdatain(3);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nliOi <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN 
			IF (nl11iO = '1') THEN nliOi <= txdatain(22);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nliOii <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN nliOii <= wire_niili_o;
		END IF;
	END PROCESS;
	wire_nliOii_w_lg_Q487w(0) <= NOT nliOii;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nliOil <= '1';
		ELSIF (txclk = '1' AND txclk'event) THEN nliOil <= wire_niilO_o;
		END IF;
	END PROCESS;
	wire_nliOil_w_lg_Q480w(0) <= NOT nliOil;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nliOiO <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN nliOiO <= wire_nil1i_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nliOl <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN 
			IF (nl11iO = '1') THEN nliOl <= txdatain(23);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nliOli <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN nliOli <= wire_nliOOl_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nliOll <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN nliOll <= wire_nliOOO_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nliOlO <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN nliOlO <= wire_nll10l_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nliOO <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN 
			IF (nl11iO = '1') THEN nliOO <= txdatain(24);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nll0i <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN 
			IF (nl11iO = '1') THEN nll0i <= txdatain(29);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nll0l <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN 
			IF (nl11iO = '1') THEN nll0l <= txdatain(30);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nll0O <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN 
			IF (nl11iO = '1') THEN nll0O <= txdatain(31);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nll1i <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN 
			IF (nl11iO = '1') THEN nll1i <= txdatain(26);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nll1l <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN 
			IF (nl11iO = '1') THEN nll1l <= txdatain(27);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nll1O <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN 
			IF (nl11iO = '1') THEN nll1O <= txdatain(28);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nllOO <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN nllOO <= wire_nllii_dataout;
		END IF;
	END PROCESS;
	wire_nllOO_w_lg_Q567w(0) <= NOT nllOO;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlO01i <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN nlO01i <= wire_nlO0iO_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlO1i <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN nlO1i <= wire_niiOl_o;
		END IF;
	END PROCESS;
	wire_nlO1i_w_lg_Q484w(0) <= NOT nlO1i;
	wire_nlO1i_w_lg_w_lg_Q484w485w(0) <= wire_nlO1i_w_lg_Q484w(0) OR nliOiO;
	wire_nlO1i_w_lg_w_lg_w_lg_Q484w485w499w(0) <= wire_nlO1i_w_lg_w_lg_Q484w485w(0) OR nliOil;
	wire_nlO1i_w_lg_w_lg_Q479w493w(0) <= wire_nlO1i_w_lg_Q479w(0) OR nliOil;
	wire_nlO1i_w_lg_Q479w(0) <= nlO1i OR nliOiO;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlO1Ol <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN nlO1Ol <= wire_nlO01O_dataout;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlO1OO <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN nlO1OO <= wire_nlO00i_dataout;
		END IF;
	END PROCESS;
	wire_n000i_dataout <= wire_n1O0l_dataout WHEN nl111i = '1'  ELSE wire_nllOiO_dataout;
	wire_n000l_dataout <= wire_n1O1O_dataout AND nl111i;
	wire_n000O_dataout <= wire_n1O0l_dataout AND nl111i;
	wire_n001i_dataout <= nli0O WHEN nllOO = '1'  ELSE wire_nlilli_w_lg_Q568w(0);
	wire_n001l_dataout <= wire_n1O1O_dataout WHEN nl111i = '1'  ELSE wire_nllOil_dataout;
	wire_n001O_dataout <= wire_n1O0i_dataout WHEN nl111i = '1'  ELSE wire_w_lg_nl110O495w(0);
	wire_n00ii_dataout <= wire_n1O1O_dataout WHEN nl111i = '1'  ELSE wire_n00iO_dataout;
	wire_n00il_dataout <= wire_n1O0l_dataout WHEN nl111i = '1'  ELSE wire_n00li_dataout;
	wire_n00iO_dataout <= nli0i AND nllOO;
	wire_n00li_dataout <= nli0O AND nllOO;
	wire_n00ll_dataout <= wire_n1O1O_dataout OR NOT(nl111i);
	wire_n00lO_dataout <= wire_n1O0i_dataout WHEN nl111i = '1'  ELSE nl111l;
	wire_n00Oi_dataout <= wire_n1O0l_dataout WHEN nl111i = '1'  ELSE wire_w_lg_nl111l566w(0);
	wire_n00Ol_dataout <= wire_n1l1O_dataout OR NOT(rdenablesync);
	wire_n00OO_dataout <= wire_n1l0i_dataout AND rdenablesync;
	wire_n010i_dataout <= wire_n1O1i_dataout WHEN nl111i = '1'  ELSE wire_n01lO_dataout;
	wire_n010l_dataout <= wire_n1O1l_dataout WHEN nl111i = '1'  ELSE wire_n01Oi_dataout;
	wire_n010O_dataout <= wire_n1O1O_dataout WHEN nl111i = '1'  ELSE wire_n01Ol_dataout;
	wire_n011i_dataout <= wire_n1lOi_dataout WHEN nl111i = '1'  ELSE wire_n01iO_dataout;
	wire_n011l_dataout <= wire_n1lOl_dataout WHEN nl111i = '1'  ELSE wire_n01li_dataout;
	wire_n011O_dataout <= wire_n1lOO_dataout WHEN nl111i = '1'  ELSE wire_n01ll_dataout;
	wire_n01ii_dataout <= wire_n1O0i_dataout WHEN nl111i = '1'  ELSE wire_n01OO_dataout;
	wire_n01il_dataout <= wire_n1O0l_dataout WHEN nl111i = '1'  ELSE wire_n001i_dataout;
	wire_n01iO_dataout <= nl0Ol AND nllOO;
	wire_n01li_dataout <= nl0OO AND nllOO;
	wire_n01ll_dataout <= nli1i OR NOT(nllOO);
	wire_n01lO_dataout <= nli1l OR NOT(nllOO);
	wire_n01Oi_dataout <= nli1O OR NOT(nllOO);
	wire_n01Ol_dataout <= nli0i WHEN nllOO = '1'  ELSE wire_nlilli_w_lg_Q568w(0);
	wire_n01OO_dataout <= nli0l AND nllOO;
	wire_n0i0i_dataout <= wire_n1lil_dataout OR NOT(rdenablesync);
	wire_n0i0l_dataout <= wire_n000l_dataout OR NOT(rdenablesync);
	wire_n0i0O_dataout <= wire_n1lli_dataout AND rdenablesync;
	wire_n0i1i_dataout <= wire_n1l0l_dataout AND rdenablesync;
	wire_n0i1l_dataout <= wire_n1l0O_dataout OR NOT(rdenablesync);
	wire_n0i1O_dataout <= wire_n1lii_dataout OR NOT(rdenablesync);
	wire_n0iii_dataout <= wire_n000O_dataout OR NOT(rdenablesync);
	wire_n0ill_dataout <= wire_n0l0l_o OR nl10iO;
	wire_n0ilO_dataout <= wire_n0l0O_o AND NOT(nl10iO);
	wire_n0iOi_dataout <= wire_n0lii_o OR nl10iO;
	wire_n0iOl_dataout <= wire_n0lil_o OR nl10iO;
	wire_n0iOO_dataout <= wire_n0liO_o OR nl10iO;
	wire_n0l0i_dataout <= wire_n0lOi_o OR nl10iO;
	wire_n0l1i_dataout <= wire_n0lli_o OR nl10iO;
	wire_n0l1l_dataout <= wire_n0lll_o OR nl10iO;
	wire_n0l1O_dataout <= wire_n0llO_o OR nl10iO;
	wire_n0lOO_dataout <= wire_n0OiO_dataout OR NOT(nl111i);
	wire_n0O0i_dataout <= wire_n0OOi_dataout OR NOT(nl111i);
	wire_n0O0l_dataout <= wire_n0OOl_dataout OR NOT(nl111i);
	wire_n0O0O_dataout <= wire_n0OOO_dataout WHEN nl111i = '1'  ELSE wire_nlilli_w_lg_Q568w(0);
	wire_n0O1i_dataout <= wire_n0Oli_dataout AND nl111i;
	wire_n0O1l_dataout <= wire_n0Oll_dataout AND nl111i;
	wire_n0O1O_dataout <= wire_n0OlO_dataout OR NOT(nl111i);
	wire_n0Oii_dataout <= wire_ni11i_dataout AND nl111i;
	wire_n0Oil_dataout <= wire_ni11l_dataout WHEN nl111i = '1'  ELSE wire_nlilli_w_lg_Q568w(0);
	wire_n0OiO_dataout <= txctrl(0) OR nl101l;
	wire_n0Oli_dataout <= txdatain(0) OR nl101l;
	wire_n0Oll_dataout <= txdatain(1) AND NOT(nl101l);
	wire_n0OlO_dataout <= txdatain(2) OR nl101l;
	wire_n0OOi_dataout <= txdatain(3) OR nl101l;
	wire_n0OOl_dataout <= txdatain(4) OR nl101l;
	wire_n0OOO_dataout <= txdatain(5) OR nl101l;
	wire_n100i_dataout <= wire_nlOiil_dataout AND rdenablesync;
	wire_n100l_dataout <= wire_nlOiiO_dataout OR NOT(rdenablesync);
	wire_n100O_dataout <= wire_nlOili_dataout OR NOT(rdenablesync);
	wire_n101i_dataout <= wire_nlOlil_dataout WHEN nl111i = '1'  ELSE wire_w_lg_nl111l566w(0);
	wire_n101l_dataout <= wire_nlOi0O_dataout OR NOT(rdenablesync);
	wire_n101O_dataout <= wire_nlOiii_dataout AND rdenablesync;
	wire_n10ii_dataout <= wire_nlOill_dataout OR NOT(rdenablesync);
	wire_n10il_dataout <= wire_n11il_dataout OR NOT(rdenablesync);
	wire_n10iO_dataout <= wire_nlOiOi_dataout AND rdenablesync;
	wire_n10li_dataout <= wire_n11iO_dataout OR NOT(rdenablesync);
	wire_n10Ol_dataout <= wire_n1iil_o OR nl10il;
	wire_n10OO_dataout <= wire_n1iiO_o AND NOT(nl10il);
	wire_n110i_dataout <= nliOl WHEN nllOO = '1'  ELSE wire_nlilli_w_lg_Q568w(0);
	wire_n110l_dataout <= wire_nlOl0O_dataout WHEN nl111i = '1'  ELSE wire_nllOil_dataout;
	wire_n110O_dataout <= wire_nlOlii_dataout WHEN nl111i = '1'  ELSE wire_w_lg_nl110O495w(0);
	wire_n111i_dataout <= nlill OR NOT(nllOO);
	wire_n111l_dataout <= nlilO WHEN nllOO = '1'  ELSE wire_nlilli_w_lg_Q568w(0);
	wire_n111O_dataout <= nliOi AND nllOO;
	wire_n11ii_dataout <= wire_nlOlil_dataout WHEN nl111i = '1'  ELSE wire_nllOiO_dataout;
	wire_n11il_dataout <= wire_nlOl0O_dataout AND nl111i;
	wire_n11iO_dataout <= wire_nlOlil_dataout AND nl111i;
	wire_n11li_dataout <= wire_nlOl0O_dataout WHEN nl111i = '1'  ELSE wire_n11lO_dataout;
	wire_n11ll_dataout <= wire_nlOlil_dataout WHEN nl111i = '1'  ELSE wire_n11Oi_dataout;
	wire_n11lO_dataout <= nlilO AND nllOO;
	wire_n11Oi_dataout <= nliOl AND nllOO;
	wire_n11Ol_dataout <= wire_nlOl0O_dataout OR NOT(nl111i);
	wire_n11OO_dataout <= wire_nlOlii_dataout WHEN nl111i = '1'  ELSE nl111l;
	wire_n1i0i_dataout <= wire_n1iOi_o OR nl10il;
	wire_n1i0l_dataout <= wire_n1iOl_o OR nl10il;
	wire_n1i0O_dataout <= wire_n1iOO_o OR nl10il;
	wire_n1i1i_dataout <= wire_n1ili_o OR nl10il;
	wire_n1i1l_dataout <= wire_n1ill_o OR nl10il;
	wire_n1i1O_dataout <= wire_n1ilO_o OR nl10il;
	wire_n1iii_dataout <= wire_n1l1i_o OR nl10il;
	wire_n1l0i_dataout <= wire_n1lOi_dataout AND nl111i;
	wire_n1l0l_dataout <= wire_n1lOl_dataout AND nl111i;
	wire_n1l0O_dataout <= wire_n1lOO_dataout OR NOT(nl111i);
	wire_n1l1O_dataout <= wire_n1llO_dataout OR NOT(nl111i);
	wire_n1lii_dataout <= wire_n1O1i_dataout OR NOT(nl111i);
	wire_n1lil_dataout <= wire_n1O1l_dataout OR NOT(nl111i);
	wire_n1liO_dataout <= wire_n1O1O_dataout WHEN nl111i = '1'  ELSE wire_nlilli_w_lg_Q568w(0);
	wire_n1lli_dataout <= wire_n1O0i_dataout AND nl111i;
	wire_n1lll_dataout <= wire_n1O0l_dataout WHEN nl111i = '1'  ELSE wire_nlilli_w_lg_Q568w(0);
	wire_n1llO_dataout <= wire_n1O0O_dataout OR nl101l;
	wire_n1lOi_dataout <= wire_n1Oii_dataout AND NOT(nl101l);
	wire_n1lOl_dataout <= wire_n1Oil_dataout AND NOT(nl101l);
	wire_n1lOO_dataout <= wire_n1OiO_dataout OR nl101l;
	wire_n1O0i_dataout <= wire_n1OOi_dataout AND NOT(nl101l);
	wire_n1O0l_dataout <= wire_n1OOl_dataout OR nl101l;
	wire_n1O0O_dataout <= txctrl(1) OR nl11OO;
	wire_n1O1i_dataout <= wire_n1Oli_dataout OR nl101l;
	wire_n1O1l_dataout <= wire_n1Oll_dataout OR nl101l;
	wire_n1O1O_dataout <= wire_n1OlO_dataout OR nl101l;
	wire_n1Oii_dataout <= txdatain(8) OR nl11OO;
	wire_n1Oil_dataout <= txdatain(9) AND NOT(nl11OO);
	wire_n1OiO_dataout <= txdatain(10) OR nl11OO;
	wire_n1Oli_dataout <= txdatain(11) OR nl11OO;
	wire_n1Oll_dataout <= txdatain(12) OR nl11OO;
	wire_n1OlO_dataout <= txdatain(13) OR nl11OO;
	wire_n1OOi_dataout <= txdatain(14) OR nl11OO;
	wire_n1OOl_dataout <= txdatain(15) OR nl11OO;
	wire_n1OOO_dataout <= wire_n1llO_dataout WHEN nl111i = '1'  ELSE wire_nllOO_w_lg_Q567w(0);
	wire_ni00i_dataout <= wire_n0OOO_dataout WHEN nl111i = '1'  ELSE wire_nllOil_dataout;
	wire_ni00l_dataout <= wire_ni11i_dataout WHEN nl111i = '1'  ELSE wire_w_lg_nl110O495w(0);
	wire_ni00O_dataout <= wire_ni11l_dataout WHEN nl111i = '1'  ELSE wire_nllOiO_dataout;
	wire_ni01i_dataout <= nl0lO WHEN nllOO = '1'  ELSE wire_nlilli_w_lg_Q568w(0);
	wire_ni01l_dataout <= nl0Oi AND nllOO;
	wire_ni01O_dataout <= nliO0l WHEN nllOO = '1'  ELSE wire_nlilli_w_lg_Q568w(0);
	wire_ni0ii_dataout <= wire_n0OOO_dataout AND nl111i;
	wire_ni0il_dataout <= wire_ni11l_dataout AND nl111i;
	wire_ni0iO_dataout <= wire_n0OOO_dataout WHEN nl111i = '1'  ELSE wire_ni0ll_dataout;
	wire_ni0li_dataout <= wire_ni11l_dataout WHEN nl111i = '1'  ELSE wire_ni0lO_dataout;
	wire_ni0ll_dataout <= nl0lO AND nllOO;
	wire_ni0lO_dataout <= nliO0l AND nllOO;
	wire_ni0Oi_dataout <= wire_n0OOO_dataout OR NOT(nl111i);
	wire_ni0Ol_dataout <= wire_ni11i_dataout WHEN nl111i = '1'  ELSE nl111l;
	wire_ni0OO_dataout <= wire_ni11l_dataout WHEN nl111i = '1'  ELSE wire_w_lg_nl111l566w(0);
	wire_ni10i_dataout <= wire_n0Oll_dataout WHEN nl111i = '1'  ELSE wire_ni1lO_dataout;
	wire_ni10l_dataout <= wire_n0OlO_dataout WHEN nl111i = '1'  ELSE wire_ni1Oi_dataout;
	wire_ni10O_dataout <= wire_n0OOi_dataout WHEN nl111i = '1'  ELSE wire_ni1Ol_dataout;
	wire_ni11i_dataout <= txdatain(6) OR nl101l;
	wire_ni11l_dataout <= txdatain(7) OR nl101l;
	wire_ni11O_dataout <= wire_n0Oli_dataout WHEN nl111i = '1'  ELSE wire_ni1ll_dataout;
	wire_ni1ii_dataout <= wire_n0OOl_dataout WHEN nl111i = '1'  ELSE wire_ni1OO_dataout;
	wire_ni1il_dataout <= wire_n0OOO_dataout WHEN nl111i = '1'  ELSE wire_ni01i_dataout;
	wire_ni1iO_dataout <= wire_ni11i_dataout WHEN nl111i = '1'  ELSE wire_ni01l_dataout;
	wire_ni1li_dataout <= wire_ni11l_dataout WHEN nl111i = '1'  ELSE wire_ni01O_dataout;
	wire_ni1ll_dataout <= nl0li AND nllOO;
	wire_ni1lO_dataout <= nl0ll AND nllOO;
	wire_ni1Oi_dataout <= nliO1l OR NOT(nllOO);
	wire_ni1Ol_dataout <= nliO1O OR NOT(nllOO);
	wire_ni1OO_dataout <= nliO0i OR NOT(nllOO);
	wire_nii0i_dataout <= wire_n0O1O_dataout OR NOT(rdenablesync);
	wire_nii0l_dataout <= wire_n0O0i_dataout OR NOT(rdenablesync);
	wire_nii0O_dataout <= wire_n0O0l_dataout OR NOT(rdenablesync);
	wire_nii1i_dataout <= wire_n0lOO_dataout OR NOT(rdenablesync);
	wire_nii1l_dataout <= wire_n0O1i_dataout AND rdenablesync;
	wire_nii1O_dataout <= wire_n0O1l_dataout AND rdenablesync;
	wire_niiii_dataout <= wire_ni0ii_dataout OR NOT(rdenablesync);
	wire_niiil_dataout <= wire_n0Oii_dataout AND rdenablesync;
	wire_niiiO_dataout <= wire_ni0il_dataout OR NOT(rdenablesync);
	wire_nil0i_dataout <= wire_nilil_dataout OR nl111i;
	wire_nil0l_dataout <= wire_niliO_dataout AND NOT(nl111i);
	wire_nil0O_dataout <= wire_nllOO_w_lg_Q567w(0) AND NOT(nl111i);
	wire_nil1i_dataout <= wire_nilii_dataout AND wire_nll01l_o(7);
	wire_nil1l_dataout <= nlilli OR nl111i;
	wire_nil1O_dataout <= wire_nlilli_w_lg_Q568w(0) AND NOT(nl111i);
	wire_nilii_dataout <= nllOO AND NOT(nl111i);
	wire_nilil_dataout <= nlilli AND NOT(nllOO);
	wire_niliO_dataout <= wire_nlilli_w_lg_Q568w(0) AND NOT(nllOO);
	wire_nilli_dataout <= wire_nillO_dataout OR nl111i;
	wire_nilll_dataout <= wire_nllOil_dataout AND NOT(nl111i);
	wire_nillO_dataout <= nlilli OR wire_w_lg_nl110O495w(0);
	wire_nilOi_dataout <= wire_nllOO_w_lg_Q567w(0) OR nl111i;
	wire_nilOl_dataout <= wire_w_lg_nl111l566w(0) OR nl111i;
	wire_nilOO_dataout <= wire_w_lg_nl111i565w(0) AND rdenablesync;
	wire_niO1i_dataout <= wire_niO1l_dataout OR ((wire_niOOi_w_lg_o557w(0) OR 
		wire_w_lg_nl11il559w(0)) OR wire_w_lg_nl111O563w(0));
	wire_niO1l_dataout <= nlilil AND NOT((nl111l AND nl111O));
	wire_nl10l_dataout <= nlilli WHEN nl110l = '1'  ELSE wire_nl1li_dataout;
	wire_nl10O_dataout <= nlilll WHEN nl110l = '1'  ELSE wire_nl1ll_dataout;
	wire_nl1ii_dataout <= nlillO WHEN nl110l = '1'  ELSE wire_nl1lO_dataout;
	wire_nl1il_dataout <= nlilOi WHEN nl110l = '1'  ELSE wire_nl1Oi_dataout;
	wire_nl1iO_dataout <= wire_nl1Ol_dataout OR nl110l;
	wire_nl1li_dataout <= wire_nl1OO_o(1) WHEN nl110O = '1'  ELSE nl11i;
	wire_nl1ll_dataout <= wire_nl1OO_o(2) WHEN nl110O = '1'  ELSE nl11l;
	wire_nl1lO_dataout <= wire_nl1OO_o(3) WHEN nl110O = '1'  ELSE nl11O;
	wire_nl1Oi_dataout <= wire_nl1OO_o(4) WHEN nl110O = '1'  ELSE nl10i;
	wire_nl1Ol_dataout <= wire_nl1OO_o(5) WHEN nl110O = '1'  ELSE nliliO;
	wire_nliOOi_dataout <= wire_nll1ii_o OR nl100O;
	wire_nliOOl_dataout <= wire_nll1il_o AND NOT(nl100O);
	wire_nliOOO_dataout <= wire_nll1iO_o OR nl100O;
	wire_nll00i_dataout <= wire_nll0Oi_dataout AND nl111i;
	wire_nll00l_dataout <= wire_nll0Ol_dataout AND nl111i;
	wire_nll00O_dataout <= wire_nll0OO_dataout OR NOT(nl111i);
	wire_nll01O_dataout <= wire_nll0lO_dataout OR NOT(nl111i);
	wire_nll0ii_dataout <= wire_nlli1i_dataout OR NOT(nl111i);
	wire_nll0il_dataout <= wire_nlli1l_dataout OR NOT(nl111i);
	wire_nll0iO_dataout <= wire_nlli1O_dataout WHEN nl111i = '1'  ELSE wire_nlilli_w_lg_Q568w(0);
	wire_nll0li_dataout <= wire_nlli0i_dataout AND nl111i;
	wire_nll0ll_dataout <= wire_nlli0l_dataout WHEN nl111i = '1'  ELSE wire_nlilli_w_lg_Q568w(0);
	wire_nll0lO_dataout <= wire_nlli0O_dataout OR niOOiO;
	wire_nll0Oi_dataout <= wire_nlliii_dataout AND NOT(niOOiO);
	wire_nll0Ol_dataout <= wire_nlliil_dataout AND NOT(niOOiO);
	wire_nll0OO_dataout <= wire_nlliiO_dataout OR niOOiO;
	wire_nll10i_dataout <= wire_nll1Oi_o OR nl100O;
	wire_nll10l_dataout <= wire_nll1Ol_o OR nl100O;
	wire_nll10O_dataout <= wire_nll1OO_o OR nl100O;
	wire_nll11i_dataout <= wire_nll1li_o OR nl100O;
	wire_nll11l_dataout <= wire_nll1ll_o OR nl100O;
	wire_nll11O_dataout <= wire_nll1lO_o OR nl100O;
	wire_nlli0i_dataout <= wire_nlliOi_dataout AND NOT(niOOiO);
	wire_nlli0l_dataout <= wire_nlliOl_dataout OR niOOiO;
	wire_nlli0O_dataout <= txctrl(3) OR nl11ll;
	wire_nlli1i_dataout <= wire_nllili_dataout OR niOOiO;
	wire_nlli1l_dataout <= wire_nllill_dataout OR niOOiO;
	wire_nlli1O_dataout <= wire_nllilO_dataout OR niOOiO;
	wire_nllii_dataout <= wire_nllil_dataout OR nl11iO;
	wire_nlliii_dataout <= txdatain(24) OR nl11ll;
	wire_nlliil_dataout <= txdatain(25) AND NOT(nl11ll);
	wire_nlliiO_dataout <= txdatain(26) OR nl11ll;
	wire_nllil_dataout <= nllOO AND NOT((nllOO AND (nl11il AND ((NOT ((wire_nlO1i_w_lg_Q479w(0) OR wire_nliOil_w_lg_Q480w(0)) OR nliOii)) OR (NOT ((wire_nlO1i_w_lg_w_lg_Q484w485w(0) OR wire_nliOil_w_lg_Q480w(0)) OR wire_nliOii_w_lg_Q487w(0)))))));
	wire_nllili_dataout <= txdatain(27) OR nl11ll;
	wire_nllill_dataout <= txdatain(28) OR nl11ll;
	wire_nllilO_dataout <= txdatain(29) OR nl11ll;
	wire_nlliOi_dataout <= txdatain(30) OR nl11ll;
	wire_nlliOl_dataout <= txdatain(31) OR nl11ll;
	wire_nlll0i_dataout <= wire_nll0Oi_dataout WHEN nl111i = '1'  ELSE wire_nllllO_dataout;
	wire_nlll0l_dataout <= wire_nll0Ol_dataout WHEN nl111i = '1'  ELSE wire_nlllOi_dataout;
	wire_nlll0O_dataout <= wire_nll0OO_dataout WHEN nl111i = '1'  ELSE wire_nlllOl_dataout;
	wire_nlll1O_dataout <= wire_nll0lO_dataout WHEN nl111i = '1'  ELSE wire_nllOO_w_lg_Q567w(0);
	wire_nlllii_dataout <= wire_nlli1i_dataout WHEN nl111i = '1'  ELSE wire_nlllOO_dataout;
	wire_nlllil_dataout <= wire_nlli1l_dataout WHEN nl111i = '1'  ELSE wire_nllO1i_dataout;
	wire_nllliO_dataout <= wire_nlli1O_dataout WHEN nl111i = '1'  ELSE wire_nllO1l_dataout;
	wire_nlllli_dataout <= wire_nlli0i_dataout WHEN nl111i = '1'  ELSE wire_nllO1O_dataout;
	wire_nlllll_dataout <= wire_nlli0l_dataout WHEN nl111i = '1'  ELSE wire_nllO0i_dataout;
	wire_nllllO_dataout <= nliOO AND nllOO;
	wire_nlllOi_dataout <= nliO0O AND nllOO;
	wire_nlllOl_dataout <= nll1i OR NOT(nllOO);
	wire_nlllOO_dataout <= nll1l OR NOT(nllOO);
	wire_nllO0i_dataout <= nll0O WHEN nllOO = '1'  ELSE wire_nlilli_w_lg_Q568w(0);
	wire_nllO0l_dataout <= wire_nlli1O_dataout WHEN nl111i = '1'  ELSE wire_nllOil_dataout;
	wire_nllO0O_dataout <= wire_nlli0i_dataout WHEN nl111i = '1'  ELSE wire_w_lg_nl110O495w(0);
	wire_nllO1i_dataout <= nll1O OR NOT(nllOO);
	wire_nllO1l_dataout <= nll0i WHEN nllOO = '1'  ELSE wire_nlilli_w_lg_Q568w(0);
	wire_nllO1O_dataout <= nll0l AND nllOO;
	wire_nllOii_dataout <= wire_nlli0l_dataout WHEN nl111i = '1'  ELSE wire_nllOiO_dataout;
	wire_nllOil_dataout <= wire_nlilli_w_lg_Q568w(0) OR wire_w_lg_nl110O495w(0);
	wire_nllOiO_dataout <= wire_nlilli_w_lg_Q568w(0) AND NOT(wire_w_lg_nl110O495w(0));
	wire_nllOli_dataout <= wire_nlli1O_dataout AND nl111i;
	wire_nllOll_dataout <= wire_nlli0l_dataout AND nl111i;
	wire_nllOlO_dataout <= wire_nlli1O_dataout WHEN nl111i = '1'  ELSE wire_nllOOl_dataout;
	wire_nllOOi_dataout <= wire_nlli0l_dataout WHEN nl111i = '1'  ELSE wire_nllOOO_dataout;
	wire_nllOOl_dataout <= nll0i AND nllOO;
	wire_nllOOO_dataout <= nll0O AND nllOO;
	wire_nlO00i_dataout <= wire_nlO0Oi_o OR nl10ii;
	wire_nlO00l_dataout <= wire_nlO0Ol_o OR nl10ii;
	wire_nlO00O_dataout <= wire_nlO0OO_o OR nl10ii;
	wire_nlO01l_dataout <= wire_nlO0ll_o OR nl10ii;
	wire_nlO01O_dataout <= wire_nlO0lO_o AND NOT(nl10ii);
	wire_nlO0ii_dataout <= wire_nlOi1i_o OR nl10ii;
	wire_nlO0il_dataout <= wire_nlOi1l_o OR nl10ii;
	wire_nlO0iO_dataout <= wire_nlOi1O_o OR nl10ii;
	wire_nlO0li_dataout <= wire_nlOi0i_o OR nl10ii;
	wire_nlO10l_dataout <= wire_nll01O_dataout OR NOT(rdenablesync);
	wire_nlO10O_dataout <= wire_nll00i_dataout AND rdenablesync;
	wire_nlO11i_dataout <= wire_nlli1O_dataout OR NOT(nl111i);
	wire_nlO11l_dataout <= wire_nlli0i_dataout WHEN nl111i = '1'  ELSE nl111l;
	wire_nlO11O_dataout <= wire_nlli0l_dataout WHEN nl111i = '1'  ELSE wire_w_lg_nl111l566w(0);
	wire_nlO1ii_dataout <= wire_nll00l_dataout AND rdenablesync;
	wire_nlO1il_dataout <= wire_nll00O_dataout OR NOT(rdenablesync);
	wire_nlO1iO_dataout <= wire_nll0ii_dataout OR NOT(rdenablesync);
	wire_nlO1li_dataout <= wire_nll0il_dataout OR NOT(rdenablesync);
	wire_nlO1ll_dataout <= wire_nllOli_dataout OR NOT(rdenablesync);
	wire_nlO1lO_dataout <= wire_nll0li_dataout AND rdenablesync;
	wire_nlO1Oi_dataout <= wire_nllOll_dataout OR NOT(rdenablesync);
	wire_nlOi0O_dataout <= wire_nlOiOO_dataout OR NOT(nl111i);
	wire_nlOiii_dataout <= wire_nlOl1i_dataout AND nl111i;
	wire_nlOiil_dataout <= wire_nlOl1l_dataout AND nl111i;
	wire_nlOiiO_dataout <= wire_nlOl1O_dataout OR NOT(nl111i);
	wire_nlOili_dataout <= wire_nlOl0i_dataout OR NOT(nl111i);
	wire_nlOill_dataout <= wire_nlOl0l_dataout OR NOT(nl111i);
	wire_nlOilO_dataout <= wire_nlOl0O_dataout WHEN nl111i = '1'  ELSE wire_nlilli_w_lg_Q568w(0);
	wire_nlOiOi_dataout <= wire_nlOlii_dataout AND nl111i;
	wire_nlOiOl_dataout <= wire_nlOlil_dataout WHEN nl111i = '1'  ELSE wire_nlilli_w_lg_Q568w(0);
	wire_nlOiOO_dataout <= wire_nlOliO_dataout OR niOOll;
	wire_nlOl0i_dataout <= wire_nlOlOi_dataout OR niOOll;
	wire_nlOl0l_dataout <= wire_nlOlOl_dataout OR niOOll;
	wire_nlOl0O_dataout <= wire_nlOlOO_dataout OR niOOll;
	wire_nlOl1i_dataout <= wire_nlOlli_dataout AND NOT(niOOll);
	wire_nlOl1l_dataout <= wire_nlOlll_dataout AND NOT(niOOll);
	wire_nlOl1O_dataout <= wire_nlOllO_dataout OR niOOll;
	wire_nlOlii_dataout <= wire_nlOO1i_dataout AND NOT(niOOll);
	wire_nlOlil_dataout <= wire_nlOO1l_dataout OR niOOll;
	wire_nlOliO_dataout <= txctrl(2) OR nl11Oi;
	wire_nlOlli_dataout <= txdatain(16) OR nl11Oi;
	wire_nlOlll_dataout <= txdatain(17) AND NOT(nl11Oi);
	wire_nlOllO_dataout <= txdatain(18) OR nl11Oi;
	wire_nlOlOi_dataout <= txdatain(19) OR nl11Oi;
	wire_nlOlOl_dataout <= txdatain(20) OR nl11Oi;
	wire_nlOlOO_dataout <= txdatain(21) OR nl11Oi;
	wire_nlOO0i_dataout <= wire_nlOl1i_dataout WHEN nl111i = '1'  ELSE wire_nlOOlO_dataout;
	wire_nlOO0l_dataout <= wire_nlOl1l_dataout WHEN nl111i = '1'  ELSE wire_nlOOOi_dataout;
	wire_nlOO0O_dataout <= wire_nlOl1O_dataout WHEN nl111i = '1'  ELSE wire_nlOOOl_dataout;
	wire_nlOO1i_dataout <= txdatain(22) OR nl11Oi;
	wire_nlOO1l_dataout <= txdatain(23) OR nl11Oi;
	wire_nlOO1O_dataout <= wire_nlOiOO_dataout WHEN nl111i = '1'  ELSE wire_nllOO_w_lg_Q567w(0);
	wire_nlOOii_dataout <= wire_nlOl0i_dataout WHEN nl111i = '1'  ELSE wire_nlOOOO_dataout;
	wire_nlOOil_dataout <= wire_nlOl0l_dataout WHEN nl111i = '1'  ELSE wire_n111i_dataout;
	wire_nlOOiO_dataout <= wire_nlOl0O_dataout WHEN nl111i = '1'  ELSE wire_n111l_dataout;
	wire_nlOOli_dataout <= wire_nlOlii_dataout WHEN nl111i = '1'  ELSE wire_n111O_dataout;
	wire_nlOOll_dataout <= wire_nlOlil_dataout WHEN nl111i = '1'  ELSE wire_n110i_dataout;
	wire_nlOOlO_dataout <= nliii AND nllOO;
	wire_nlOOOi_dataout <= nliil AND nllOO;
	wire_nlOOOl_dataout <= nliiO OR NOT(nllOO);
	wire_nlOOOO_dataout <= nlili OR NOT(nllOO);
	wire_nl1OO_a <= ( nliliO
		 & nl10i & nl11O & nl11l & nl11i & "1");
	wire_nl1OO_b <= ( "1" & "1" & "1" & "1" & "0" & "1");
	nl1OO :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 6,
		width_b => 6,
		width_o => 6
	  )
	  PORT MAP ( 
		a => wire_nl1OO_a,
		b => wire_nl1OO_b,
		cin => wire_gnd,
		o => wire_nl1OO_o
	  );
	wire_nll01l_w_lg_w_o_range593w621w(0) <= wire_nll01l_w_o_range593w(0) OR wire_nll01l_w_o_range587w(0);
	wire_nll01l_i <= ( nliOiO & nlO1i & nliOil & nliOii);
	wire_nll01l_w_o_range587w(0) <= wire_nll01l_o(2);
	wire_nll01l_w_o_range593w(0) <= wire_nll01l_o(4);
	nll01l :  oper_decoder
	  GENERIC MAP (
		width_i => 4,
		width_o => 16
	  )
	  PORT MAP ( 
		i => wire_nll01l_i,
		o => wire_nll01l_o
	  );
	wire_niOOi_w_lg_o557w(0) <= wire_niOOi_o OR wire_w_lg_w_lg_rdenablesync554w556w(0);
	wire_niOOi_a <= ( "1" & "0" & "0" & "0");
	wire_niOOi_b <= ( nliOiO & nlO1i & nliOil & nliOii);
	niOOi :  oper_less_than
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 4,
		width_b => 4
	  )
	  PORT MAP ( 
		a => wire_niOOi_a,
		b => wire_niOOi_b,
		cin => wire_gnd,
		o => wire_niOOi_o
	  );
	wire_n0l0l_data <= ( "1" & wire_n0lOO_dataout & wire_n0lOO_dataout & wire_n0lOO_dataout & wire_n0lOO_dataout & wire_n0lOO_dataout & wire_nii1i_dataout & wire_n0lOO_dataout & wire_n0lOO_dataout);
	wire_n0l0l_sel <= ( niOOOl & wire_nll01l_o(8 DOWNTO 1));
	n0l0l :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_n0l0l_data,
		o => wire_n0l0l_o,
		sel => wire_n0l0l_sel
	  );
	wire_n0l0O_data <= ( "0" & wire_n0O1i_dataout & wire_ni11O_dataout & wire_n0O1i_dataout & wire_n0O1i_dataout & wire_n0O1i_dataout & wire_nii1l_dataout & wire_ni11O_dataout & wire_n0O1i_dataout);
	wire_n0l0O_sel <= ( niOOOl & wire_nll01l_o(8 DOWNTO 1));
	n0l0O :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_n0l0O_data,
		o => wire_n0l0O_o,
		sel => wire_n0l0O_sel
	  );
	wire_n0lii_data <= ( "0" & wire_n0O1l_dataout & wire_ni10i_dataout & wire_n0O1l_dataout & wire_n0O1l_dataout & wire_n0O1l_dataout & wire_nii1O_dataout & wire_ni10i_dataout & wire_n0O1l_dataout);
	wire_n0lii_sel <= ( niOOOl & wire_nll01l_o(8 DOWNTO 1));
	n0lii :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_n0lii_data,
		o => wire_n0lii_o,
		sel => wire_n0lii_sel
	  );
	wire_n0lil_data <= ( "1" & wire_n0O1O_dataout & wire_ni10l_dataout & wire_n0O1O_dataout & wire_n0O1O_dataout & wire_n0O1O_dataout & wire_nii0i_dataout & wire_ni10l_dataout & wire_n0O1O_dataout);
	wire_n0lil_sel <= ( niOOOl & wire_nll01l_o(8 DOWNTO 1));
	n0lil :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_n0lil_data,
		o => wire_n0lil_o,
		sel => wire_n0lil_sel
	  );
	wire_n0liO_data <= ( "1" & wire_n0O0i_dataout & wire_ni10O_dataout & wire_n0O0i_dataout & wire_n0O0i_dataout & wire_n0O0i_dataout & wire_nii0l_dataout & wire_ni10O_dataout & wire_n0O0i_dataout);
	wire_n0liO_sel <= ( niOOOl & wire_nll01l_o(8 DOWNTO 1));
	n0liO :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_n0liO_data,
		o => wire_n0liO_o,
		sel => wire_n0liO_sel
	  );
	wire_n0lli_data <= ( "1" & wire_n0O0l_dataout & wire_ni1ii_dataout & wire_n0O0l_dataout & wire_n0O0l_dataout & wire_n0O0l_dataout & wire_nii0O_dataout & wire_ni1ii_dataout & wire_n0O0l_dataout);
	wire_n0lli_sel <= ( niOOOl & wire_nll01l_o(8 DOWNTO 1));
	n0lli :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_n0lli_data,
		o => wire_n0lli_o,
		sel => wire_n0lli_sel
	  );
	wire_n0lll_data <= ( "1" & wire_n0O0O_dataout & wire_ni1il_dataout & wire_ni00i_dataout & wire_ni00i_dataout & wire_ni0ii_dataout & wire_niiii_dataout & wire_ni0iO_dataout & wire_ni0Oi_dataout);
	wire_n0lll_sel <= ( niOOOl & wire_nll01l_o(8 DOWNTO 1));
	n0lll :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_n0lll_data,
		o => wire_n0lll_o,
		sel => wire_n0lll_sel
	  );
	wire_n0llO_data <= ( "0" & wire_n0Oii_dataout & wire_ni1iO_dataout & wire_ni00l_dataout & wire_ni00l_dataout & wire_n0Oii_dataout & wire_niiil_dataout & wire_ni1iO_dataout & wire_ni0Ol_dataout);
	wire_n0llO_sel <= ( niOOOl & wire_nll01l_o(8 DOWNTO 1));
	n0llO :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_n0llO_data,
		o => wire_n0llO_o,
		sel => wire_n0llO_sel
	  );
	wire_n0lOi_data <= ( "1" & wire_n0Oil_dataout & wire_ni1li_dataout & wire_ni00O_dataout & wire_ni00O_dataout & wire_ni0il_dataout & wire_niiiO_dataout & wire_ni0li_dataout & wire_ni0OO_dataout);
	wire_n0lOi_sel <= ( niOOOl & wire_nll01l_o(8 DOWNTO 1));
	n0lOi :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_n0lOi_data,
		o => wire_n0lOi_o,
		sel => wire_n0lOi_sel
	  );
	wire_n1iil_data <= ( "1" & wire_n1l1O_dataout & wire_n1OOO_dataout & wire_n1l1O_dataout & wire_n1l1O_dataout & wire_n1l1O_dataout & wire_n00Ol_dataout & wire_n1OOO_dataout & wire_n1l1O_dataout);
	wire_n1iil_sel <= ( niOOOl & wire_nll01l_o(8 DOWNTO 1));
	n1iil :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_n1iil_data,
		o => wire_n1iil_o,
		sel => wire_n1iil_sel
	  );
	wire_n1iiO_data <= ( "0" & wire_n1l0i_dataout & wire_n011i_dataout & wire_n1l0i_dataout & wire_n1l0i_dataout & wire_n1l0i_dataout & wire_n00OO_dataout & wire_n011i_dataout & wire_n1l0i_dataout);
	wire_n1iiO_sel <= ( niOOlO & wire_nll01l_o(8 DOWNTO 1));
	n1iiO :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_n1iiO_data,
		o => wire_n1iiO_o,
		sel => wire_n1iiO_sel
	  );
	wire_n1ili_data <= ( "0" & wire_n1l0l_dataout & wire_n011l_dataout & wire_n1l0l_dataout & wire_n1l0l_dataout & wire_n1l0l_dataout & wire_n0i1i_dataout & wire_n011l_dataout & wire_n1l0l_dataout);
	wire_n1ili_sel <= ( niOOlO & wire_nll01l_o(8 DOWNTO 1)
		);
	n1ili :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_n1ili_data,
		o => wire_n1ili_o,
		sel => wire_n1ili_sel
	  );
	wire_n1ill_data <= ( "1" & wire_n1l0O_dataout & wire_n011O_dataout & wire_n1l0O_dataout & wire_n1l0O_dataout & wire_n1l0O_dataout & wire_n0i1l_dataout & wire_n011O_dataout & wire_n1l0O_dataout);
	wire_n1ill_sel <= ( niOOlO & wire_nll01l_o(8 DOWNTO 1));
	n1ill :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_n1ill_data,
		o => wire_n1ill_o,
		sel => wire_n1ill_sel
	  );
	wire_n1ilO_data <= ( "1" & wire_n1lii_dataout & wire_n010i_dataout & wire_n1lii_dataout & wire_n1lii_dataout & wire_n1lii_dataout & wire_n0i1O_dataout & wire_n010i_dataout & wire_n1lii_dataout);
	wire_n1ilO_sel <= ( niOOlO & wire_nll01l_o(8 DOWNTO 1));
	n1ilO :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_n1ilO_data,
		o => wire_n1ilO_o,
		sel => wire_n1ilO_sel
	  );
	wire_n1iOi_data <= ( "1" & wire_n1lil_dataout & wire_n010l_dataout & wire_n1lil_dataout & wire_n1lil_dataout & wire_n1lil_dataout & wire_n0i0i_dataout & wire_n010l_dataout & wire_n1lil_dataout);
	wire_n1iOi_sel <= ( niOOlO & wire_nll01l_o(8 DOWNTO 1));
	n1iOi :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_n1iOi_data,
		o => wire_n1iOi_o,
		sel => wire_n1iOi_sel
	  );
	wire_n1iOl_data <= ( "1" & wire_n1liO_dataout & wire_n010O_dataout & wire_n001l_dataout & wire_n001l_dataout & wire_n000l_dataout & wire_n0i0l_dataout & wire_n00ii_dataout & wire_n00ll_dataout);
	wire_n1iOl_sel <= ( niOOlO & wire_nll01l_o(8 DOWNTO 1));
	n1iOl :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_n1iOl_data,
		o => wire_n1iOl_o,
		sel => wire_n1iOl_sel
	  );
	wire_n1iOO_data <= ( "0" & wire_n1lli_dataout & wire_n01ii_dataout & wire_n001O_dataout & wire_n001O_dataout & wire_n1lli_dataout & wire_n0i0O_dataout & wire_n01ii_dataout & wire_n00lO_dataout);
	wire_n1iOO_sel <= ( niOOlO & wire_nll01l_o(8 DOWNTO 1));
	n1iOO :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_n1iOO_data,
		o => wire_n1iOO_o,
		sel => wire_n1iOO_sel
	  );
	wire_n1l1i_data <= ( "1" & wire_n1lll_dataout & wire_n01il_dataout & wire_n000i_dataout & wire_n000i_dataout & wire_n000O_dataout & wire_n0iii_dataout & wire_n00il_dataout & wire_n00Oi_dataout);
	wire_n1l1i_sel <= ( niOOlO & wire_nll01l_o(8 DOWNTO 1));
	n1l1i :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_n1l1i_data,
		o => wire_n1l1i_o,
		sel => wire_n1l1i_sel
	  );
	wire_niili_data <= ( "1" & wire_nil1l_dataout & wire_nil0i_dataout & wire_nilli_dataout & wire_nilli_dataout & wire_nilOi_dataout & wire_nilOl_dataout);
	wire_niili_sel <= ( niOOOi & wire_nll01l_o(8 DOWNTO 5) & wire_nll01l_o(2 DOWNTO 1));
	niili :  oper_selector
	  GENERIC MAP (
		width_data => 7,
		width_sel => 7
	  )
	  PORT MAP ( 
		data => wire_niili_data,
		o => wire_niili_o,
		sel => wire_niili_sel
	  );
	wire_niilO_data <= ( "1" & wire_nil1O_dataout & wire_nil0l_dataout & wire_nilll_dataout & wire_nilll_dataout & "0" & wire_w_lg_rdenablesync554w & wire_w_lg_nl111i565w);
	wire_niilO_sel <= ( niOOOl & wire_nll01l_o(8 DOWNTO 5) & wire_nll01l_w_lg_w_o_range593w621w & wire_nll01l_o(3) & wire_nll01l_o(1));
	niilO :  oper_selector
	  GENERIC MAP (
		width_data => 8,
		width_sel => 8
	  )
	  PORT MAP ( 
		data => wire_niilO_data,
		o => wire_niilO_o,
		sel => wire_niilO_sel
	  );
	wire_niiOl_data <= ( "0" & wire_w_lg_nl111i565w & wire_nil0O_dataout & wire_w_lg_nl111i565w & wire_w_lg_nl111i565w & wire_w_lg_nl111i565w & wire_nilOO_dataout & wire_w_lg_nl111i565w);
	wire_niiOl_sel <= ( niOOOO & wire_nll01l_o(8 DOWNTO 2));
	niiOl :  oper_selector
	  GENERIC MAP (
		width_data => 8,
		width_sel => 8
	  )
	  PORT MAP ( 
		data => wire_niiOl_data,
		o => wire_niiOl_o,
		sel => wire_niiOl_sel
	  );
	wire_nll1ii_data <= ( "1" & wire_nll01O_dataout & wire_nlll1O_dataout & wire_nll01O_dataout & wire_nll01O_dataout & wire_nll01O_dataout & wire_nlO10l_dataout & wire_nlll1O_dataout & wire_nll01O_dataout);
	wire_nll1ii_sel <= ( niOOOl & wire_nll01l_o(8 DOWNTO 1));
	nll1ii :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_nll1ii_data,
		o => wire_nll1ii_o,
		sel => wire_nll1ii_sel
	  );
	wire_nll1il_data <= ( "0" & wire_nll00i_dataout & wire_nlll0i_dataout & wire_nll00i_dataout & wire_nll00i_dataout & wire_nll00i_dataout & wire_nlO10O_dataout & wire_nlll0i_dataout & wire_nll00i_dataout);
	wire_nll1il_sel <= ( niOOil & wire_nll01l_o(8 DOWNTO 1));
	nll1il :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_nll1il_data,
		o => wire_nll1il_o,
		sel => wire_nll1il_sel
	  );
	wire_nll1iO_data <= ( "0" & wire_nll00l_dataout & wire_nlll0l_dataout & wire_nll00l_dataout & wire_nll00l_dataout & wire_nll00l_dataout & wire_nlO1ii_dataout & wire_nlll0l_dataout & wire_nll00l_dataout);
	wire_nll1iO_sel <= ( niOOil & wire_nll01l_o(8 DOWNTO 1));
	nll1iO :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_nll1iO_data,
		o => wire_nll1iO_o,
		sel => wire_nll1iO_sel
	  );
	wire_nll1li_data <= ( "1" & wire_nll00O_dataout & wire_nlll0O_dataout & wire_nll00O_dataout & wire_nll00O_dataout & wire_nll00O_dataout & wire_nlO1il_dataout & wire_nlll0O_dataout & wire_nll00O_dataout);
	wire_nll1li_sel <= ( niOOil & wire_nll01l_o(8 DOWNTO 1));
	nll1li :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_nll1li_data,
		o => wire_nll1li_o,
		sel => wire_nll1li_sel
	  );
	wire_nll1ll_data <= ( "1" & wire_nll0ii_dataout & wire_nlllii_dataout & wire_nll0ii_dataout & wire_nll0ii_dataout
		 & wire_nll0ii_dataout & wire_nlO1iO_dataout & wire_nlllii_dataout & wire_nll0ii_dataout);
	wire_nll1ll_sel <= ( niOOil & wire_nll01l_o(8 DOWNTO 1));
	nll1ll :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_nll1ll_data,
		o => wire_nll1ll_o,
		sel => wire_nll1ll_sel
	  );
	wire_nll1lO_data <= ( "1" & wire_nll0il_dataout & wire_nlllil_dataout & wire_nll0il_dataout & wire_nll0il_dataout & wire_nll0il_dataout & wire_nlO1li_dataout & wire_nlllil_dataout & wire_nll0il_dataout);
	wire_nll1lO_sel <= ( niOOil & wire_nll01l_o(8 DOWNTO 1));
	nll1lO :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_nll1lO_data,
		o => wire_nll1lO_o,
		sel => wire_nll1lO_sel
	  );
	wire_nll1Oi_data <= ( "1" & wire_nll0iO_dataout & wire_nllliO_dataout & wire_nllO0l_dataout & wire_nllO0l_dataout & wire_nllOli_dataout & wire_nlO1ll_dataout & wire_nllOlO_dataout & wire_nlO11i_dataout);
	wire_nll1Oi_sel <= ( niOOil & wire_nll01l_o(8 DOWNTO 1));
	nll1Oi :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_nll1Oi_data,
		o => wire_nll1Oi_o,
		sel => wire_nll1Oi_sel
	  );
	wire_nll1Ol_data <= ( "0" & wire_nll0li_dataout & wire_nlllli_dataout & wire_nllO0O_dataout & wire_nllO0O_dataout & wire_nll0li_dataout & wire_nlO1lO_dataout & wire_nlllli_dataout & wire_nlO11l_dataout);
	wire_nll1Ol_sel <= ( niOOil & wire_nll01l_o(8 DOWNTO 1));
	nll1Ol :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_nll1Ol_data,
		o => wire_nll1Ol_o,
		sel => wire_nll1Ol_sel
	  );
	wire_nll1OO_data <= ( "1" & wire_nll0ll_dataout & wire_nlllll_dataout & wire_nllOii_dataout & wire_nllOii_dataout & wire_nllOll_dataout & wire_nlO1Oi_dataout & wire_nllOOi_dataout & wire_nlO11O_dataout);
	wire_nll1OO_sel <= ( niOOil & wire_nll01l_o(8 DOWNTO 1));
	nll1OO :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_nll1OO_data,
		o => wire_nll1OO_o,
		sel => wire_nll1OO_sel
	  );
	wire_nlO0ll_data <= ( "1" & wire_nlOi0O_dataout & wire_nlOO1O_dataout & wire_nlOi0O_dataout & wire_nlOi0O_dataout & wire_nlOi0O_dataout & wire_n101l_dataout & wire_nlOO1O_dataout & wire_nlOi0O_dataout);
	wire_nlO0ll_sel <= ( niOOOl & wire_nll01l_o(8 DOWNTO 1));
	nlO0ll :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_nlO0ll_data,
		o => wire_nlO0ll_o,
		sel => wire_nlO0ll_sel
	  );
	wire_nlO0lO_data <= ( "0" & wire_nlOiii_dataout & wire_nlOO0i_dataout & wire_nlOiii_dataout & wire_nlOiii_dataout & wire_nlOiii_dataout & wire_n101O_dataout & wire_nlOO0i_dataout & wire_nlOiii_dataout);
	wire_nlO0lO_sel <= ( niOOli & wire_nll01l_o(8 DOWNTO 1));
	nlO0lO :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_nlO0lO_data,
		o => wire_nlO0lO_o,
		sel => wire_nlO0lO_sel
	  );
	wire_nlO0Oi_data <= ( "0" & wire_nlOiil_dataout & wire_nlOO0l_dataout & wire_nlOiil_dataout & wire_nlOiil_dataout & wire_nlOiil_dataout & wire_n100i_dataout & wire_nlOO0l_dataout & wire_nlOiil_dataout);
	wire_nlO0Oi_sel <= ( niOOli & wire_nll01l_o(8 DOWNTO 1));
	nlO0Oi :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_nlO0Oi_data,
		o => wire_nlO0Oi_o,
		sel => wire_nlO0Oi_sel
	  );
	wire_nlO0Ol_data <= ( "1" & wire_nlOiiO_dataout & wire_nlOO0O_dataout & wire_nlOiiO_dataout & wire_nlOiiO_dataout & wire_nlOiiO_dataout & wire_n100l_dataout & wire_nlOO0O_dataout & wire_nlOiiO_dataout);
	wire_nlO0Ol_sel <= ( niOOli & wire_nll01l_o(8 DOWNTO 1));
	nlO0Ol :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_nlO0Ol_data,
		o => wire_nlO0Ol_o,
		sel => wire_nlO0Ol_sel
	  );
	wire_nlO0OO_data <= ( "1" & wire_nlOili_dataout & wire_nlOOii_dataout & wire_nlOili_dataout & wire_nlOili_dataout & wire_nlOili_dataout & wire_n100O_dataout & wire_nlOOii_dataout & wire_nlOili_dataout);
	wire_nlO0OO_sel <= ( niOOli & wire_nll01l_o(8 DOWNTO 1));
	nlO0OO :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_nlO0OO_data,
		o => wire_nlO0OO_o,
		sel => wire_nlO0OO_sel
	  );
	wire_nlOi0i_data <= ( "1" & wire_nlOiOl_dataout & wire_nlOOll_dataout & wire_n11ii_dataout & wire_n11ii_dataout & wire_n11iO_dataout & wire_n10li_dataout & wire_n11ll_dataout & wire_n101i_dataout);
	wire_nlOi0i_sel <= ( niOOli & wire_nll01l_o(8 DOWNTO 1));
	nlOi0i :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_nlOi0i_data,
		o => wire_nlOi0i_o,
		sel => wire_nlOi0i_sel
	  );
	wire_nlOi1i_data <= ( "1" & wire_nlOill_dataout & wire_nlOOil_dataout & wire_nlOill_dataout & wire_nlOill_dataout & wire_nlOill_dataout & wire_n10ii_dataout & wire_nlOOil_dataout & wire_nlOill_dataout);
	wire_nlOi1i_sel <= ( niOOli & wire_nll01l_o(8 DOWNTO 1));
	nlOi1i :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_nlOi1i_data,
		o => wire_nlOi1i_o,
		sel => wire_nlOi1i_sel
	  );
	wire_nlOi1l_data <= ( "1" & wire_nlOilO_dataout & wire_nlOOiO_dataout & wire_n110l_dataout & wire_n110l_dataout & wire_n11il_dataout
		 & wire_n10il_dataout & wire_n11li_dataout & wire_n11Ol_dataout);
	wire_nlOi1l_sel <= ( niOOli & wire_nll01l_o(8 DOWNTO 1));
	nlOi1l :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_nlOi1l_data,
		o => wire_nlOi1l_o,
		sel => wire_nlOi1l_sel
	  );
	wire_nlOi1O_data <= ( "0" & wire_nlOiOi_dataout & wire_nlOOli_dataout & wire_n110O_dataout & wire_n110O_dataout & wire_nlOiOi_dataout & wire_n10iO_dataout & wire_nlOOli_dataout & wire_n11OO_dataout);
	wire_nlOi1O_sel <= ( niOOli & wire_nll01l_o(8 DOWNTO 1));
	nlOi1O :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_nlOi1O_data,
		o => wire_nlOi1O_o,
		sel => wire_nlOi1O_sel
	  );

 END RTL; --stratixgx_xgm_tx_sm
--synopsys translate_on
--VALID FILE
--IP Functional Simulation Model
--VERSION_BEGIN 4.1 cbx_mgl 2004:06:17:17:30:06:SJ cbx_simgen 2004:06:22:10:53:08:SJ  VERSION_END


-- Legal Notice: © 2003 Altera Corporation. All rights reserved.
-- You may only use these  simulation  model  output files for simulation
-- purposes and expressly not for synthesis or any other purposes (in which
-- event  Altera disclaims all warranties of any kind). Your use of  Altera
-- Corporation's design tools, logic functions and other software and tools,
-- and its AMPP partner logic functions, and any output files any of the
-- foregoing (including device programming or simulation files), and any
-- associated documentation or information  are expressly subject to the
-- terms and conditions of the  Altera Program License Subscription Agreement
-- or other applicable license agreement, including, without limitation, that
-- your use is for the sole purpose of programming logic devices manufactured
-- by Altera and sold by Altera or its authorized distributors.  Please refer
-- to the applicable agreement for further details.


--synopsys translate_off

 LIBRARY sgate;
 USE sgate.sgate_pack.all;

--synthesis_resources = lut 45 mux21 20 oper_selector 10 
 LIBRARY ieee;
 USE ieee.std_logic_1164.all;

 ENTITY  stratixgx_xgm_dskw_sm IS 
	 PORT 
	 ( 
		 adet	:	IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
		 alignstatus	:	OUT  STD_LOGIC;
		 enabledeskew	:	OUT  STD_LOGIC;
		 fiforesetrd	:	OUT  STD_LOGIC;
		 rdalign	:	IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
		 recovclk	:	IN  STD_LOGIC;
		 resetall	:	IN  STD_LOGIC;
		 syncstatus	:	IN  STD_LOGIC_VECTOR (3 DOWNTO 0)
	 ); 
 END stratixgx_xgm_dskw_sm;

 ARCHITECTURE RTL OF stratixgx_xgm_dskw_sm IS

	 ATTRIBUTE synthesis_clearbox : boolean;
	 ATTRIBUTE synthesis_clearbox OF RTL : ARCHITECTURE IS true;
	 SIGNAL	n01i	:	STD_LOGIC := '0';
	 SIGNAL	n01l	:	STD_LOGIC := '0';
	 SIGNAL	n0i	:	STD_LOGIC := '0';
	 SIGNAL	n0l	:	STD_LOGIC := '0';
	 SIGNAL	n0O	:	STD_LOGIC := '0';
	 SIGNAL  wire_n0O_w_lg_w_lg_w_lg_w_lg_w_lg_Q99w114w115w127w128w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0O_w_lg_w_lg_w_lg_w_lg_Q99w114w115w127w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0O_w_lg_w_lg_w_lg_Q99w114w115w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0O_w_lg_w_lg_Q99w114w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0O_w_lg_Q99w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n1i	:	STD_LOGIC := '0';
	 SIGNAL  wire_n1i_w_lg_w_lg_w_lg_Q196w197w202w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1i_w_lg_w_lg_Q196w197w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1i_w_lg_Q196w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n1l	:	STD_LOGIC := '0';
	 SIGNAL	n1O	:	STD_LOGIC := '0';
	 SIGNAL  wire_n1O_w_lg_w_lg_w_lg_w_lg_Q64w65w66w67w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O_w_lg_w_lg_w_lg_Q64w65w66w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O_w_lg_w_lg_Q64w65w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O_w_lg_Q64w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n1Oi	:	STD_LOGIC := '0';
	 SIGNAL	n1Ol	:	STD_LOGIC := '0';
	 SIGNAL  wire_n1Ol_w_lg_Q41w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n1OO	:	STD_LOGIC := '0';
	 SIGNAL  wire_n1OO_w_lg_Q222w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nil	:	STD_LOGIC := '0';
	 SIGNAL	niO	:	STD_LOGIC := '0';
	 SIGNAL	nli	:	STD_LOGIC := '0';
	 SIGNAL  wire_nli_w_lg_Q34w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli_w_lg_w_lg_Q34w35w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nli0l28	:	STD_LOGIC := '1';
	 SIGNAL	nli0l29	:	STD_LOGIC := '0';
	 SIGNAL	nli0l30	:	STD_LOGIC := '0';
	 SIGNAL	nliii25	:	STD_LOGIC := '1';
	 SIGNAL	nliii26	:	STD_LOGIC := '0';
	 SIGNAL	nliii27	:	STD_LOGIC := '0';
	 SIGNAL	nliiO22	:	STD_LOGIC := '1';
	 SIGNAL	nliiO23	:	STD_LOGIC := '0';
	 SIGNAL	nliiO24	:	STD_LOGIC := '0';
	 SIGNAL	nliOi19	:	STD_LOGIC := '1';
	 SIGNAL	nliOi20	:	STD_LOGIC := '0';
	 SIGNAL	nliOi21	:	STD_LOGIC := '0';
	 SIGNAL	nll0i16	:	STD_LOGIC := '1';
	 SIGNAL	nll0i17	:	STD_LOGIC := '0';
	 SIGNAL	nll0i18	:	STD_LOGIC := '0';
	 SIGNAL	nllil13	:	STD_LOGIC := '1';
	 SIGNAL	nllil14	:	STD_LOGIC := '0';
	 SIGNAL	nllil15	:	STD_LOGIC := '0';
	 SIGNAL	nlllO10	:	STD_LOGIC := '1';
	 SIGNAL	nlllO11	:	STD_LOGIC := '0';
	 SIGNAL	nlllO12	:	STD_LOGIC := '0';
	 SIGNAL	nllOO7	:	STD_LOGIC := '1';
	 SIGNAL	nllOO8	:	STD_LOGIC := '0';
	 SIGNAL	nllOO9	:	STD_LOGIC := '0';
	 SIGNAL	nlO1O4	:	STD_LOGIC := '1';
	 SIGNAL	nlO1O5	:	STD_LOGIC := '0';
	 SIGNAL	nlO1O6	:	STD_LOGIC := '0';
	 SIGNAL	nlOii1	:	STD_LOGIC := '1';
	 SIGNAL	nlOii2	:	STD_LOGIC := '0';
	 SIGNAL	nlOii3	:	STD_LOGIC := '0';
	 SIGNAL	nlOO	:	STD_LOGIC := '0';
	 SIGNAL	wire_ni0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOi_dataout	:	STD_LOGIC;
	 SIGNAL  wire_n00l_data	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_n00l_o	:	STD_LOGIC;
	 SIGNAL  wire_n00l_sel	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_n00O_data	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_n00O_o	:	STD_LOGIC;
	 SIGNAL  wire_n00O_sel	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_n01O_data	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_n01O_o	:	STD_LOGIC;
	 SIGNAL  wire_n01O_sel	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_n0ii_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n0ii_o	:	STD_LOGIC;
	 SIGNAL  wire_n0ii_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n0iO_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n0iO_o	:	STD_LOGIC;
	 SIGNAL  wire_n0iO_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n0ll_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n0ll_o	:	STD_LOGIC;
	 SIGNAL  wire_n0ll_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n0Oi_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n0Oi_o	:	STD_LOGIC;
	 SIGNAL  wire_n0Oi_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n0OO_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n0OO_o	:	STD_LOGIC;
	 SIGNAL  wire_n0OO_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni0i_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_ni0i_o	:	STD_LOGIC;
	 SIGNAL  wire_ni0i_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_ni1l_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni1l_o	:	STD_LOGIC;
	 SIGNAL  wire_ni1l_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_w_lg_nllli43w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nllOl171w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nlO0l15w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nlO1l44w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_resetall21w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nliiO200w201w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nliOi131w132w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nll0i70w71w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nllil47w48w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_nlllO38w39w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  nlill :	STD_LOGIC;
	 SIGNAL  nlilO :	STD_LOGIC;
	 SIGNAL  nliOO :	STD_LOGIC;
	 SIGNAL  nll0O :	STD_LOGIC;
	 SIGNAL  nll1i :	STD_LOGIC;
	 SIGNAL  nll1l :	STD_LOGIC;
	 SIGNAL  nll1O :	STD_LOGIC;
	 SIGNAL  nllii :	STD_LOGIC;
	 SIGNAL  nllli :	STD_LOGIC;
	 SIGNAL  nllll :	STD_LOGIC;
	 SIGNAL  nllOl :	STD_LOGIC;
	 SIGNAL  nlO0l :	STD_LOGIC;
	 SIGNAL  nlO0O :	STD_LOGIC;
	 SIGNAL  nlO1l :	STD_LOGIC;
	 SIGNAL  w_nli0l226w :	STD_LOGIC;
	 SIGNAL  w_nliii220w :	STD_LOGIC;
	 SIGNAL  w_nliiO200w :	STD_LOGIC;
	 SIGNAL  w_nliOi131w :	STD_LOGIC;
	 SIGNAL  w_nll0i70w :	STD_LOGIC;
	 SIGNAL  w_nllil47w :	STD_LOGIC;
	 SIGNAL  w_nlllO38w :	STD_LOGIC;
	 SIGNAL  w_nllOO31w :	STD_LOGIC;
	 SIGNAL  w_nlO1O19w :	STD_LOGIC;
	 SIGNAL  w_nlOii10w :	STD_LOGIC;
	 COMPONENT  oper_selector
	 GENERIC 
	 (
		width_data	:	NATURAL;
		width_sel	:	NATURAL
	 );
	 PORT
	 ( 
		data	:	IN STD_LOGIC_VECTOR(width_data-1 DOWNTO 0);
		o	:	OUT STD_LOGIC;
		sel	:	IN STD_LOGIC_VECTOR(width_sel-1 DOWNTO 0)
	 ); 
	 END COMPONENT;
 BEGIN

	wire_w_lg_nllli43w(0) <= NOT nllli;
	wire_w_lg_nllOl171w(0) <= NOT nllOl;
	wire_w_lg_nlO0l15w(0) <= NOT nlO0l;
	wire_w_lg_nlO1l44w(0) <= NOT nlO1l;
	wire_w_lg_resetall21w(0) <= NOT resetall;
	wire_w_lg_w_nliiO200w201w(0) <= NOT w_nliiO200w;
	wire_w_lg_w_nliOi131w132w(0) <= NOT w_nliOi131w;
	wire_w_lg_w_nll0i70w71w(0) <= NOT w_nll0i70w;
	wire_w_lg_w_nllil47w48w(0) <= NOT w_nllil47w;
	wire_w_lg_w_nlllO38w39w(0) <= NOT w_nlllO38w;
	alignstatus <= nil;
	enabledeskew <= n01i;
	fiforesetrd <= ((n01i AND wire_n1OO_w_lg_Q222w(0)) AND w_nli0l226w);
	nlill <= (wire_n0O_w_lg_w_lg_w_lg_w_lg_Q99w114w115w127w(0) OR n1i);
	nlilO <= (wire_n0O_w_lg_w_lg_w_lg_w_lg_w_lg_Q99w114w115w127w128w(0) OR wire_w_lg_w_nliOi131w132w(0));
	nliOO <= ((wire_n0O_w_lg_w_lg_w_lg_Q99w114w115w(0) OR nlOO) OR n1Oi);
	nll0O <= (((((n0i OR n1O) OR n1l) OR n1i) OR nlOO) OR n1Oi);
	nll1i <= (((wire_n0O_w_lg_Q99w(0) OR n1i) OR nlOO) OR n1Oi);
	nll1l <= ((((n0O OR n1l) OR n1i) OR nlOO) OR n1Oi);
	nll1O <= (wire_n1O_w_lg_w_lg_w_lg_w_lg_Q64w65w66w67w(0) OR wire_w_lg_w_nll0i70w71w(0));
	nllii <= (wire_nli_w_lg_w_lg_Q34w35w(0) OR wire_w_lg_w_nllil47w48w(0));
	nllli <= (nlO0l AND wire_n1Ol_w_lg_Q41w(0));
	nllll <= (wire_nli_w_lg_w_lg_Q34w35w(0) OR wire_w_lg_w_nlllO38w39w(0));
	nllOl <= (nli AND ((((adet(3) AND adet(2)) AND adet(1)) AND adet(0)) AND w_nllOO31w));
	nlO0l <= ((((rdalign(3) AND rdalign(2)) AND rdalign(1)) AND rdalign(0)) AND w_nlOii10w);
	nlO0O <= recovclk;
	nlO1l <= (((((rdalign(3) OR rdalign(2)) OR rdalign(1)) OR rdalign(0)) AND wire_w_lg_nlO0l15w(0)) AND w_nlO1O19w);
	w_nli0l226w <= nli0l30;
	w_nliii220w <= nliii27;
	w_nliiO200w <= nliiO24;
	w_nliOi131w <= nliOi21;
	w_nll0i70w <= nll0i18;
	w_nllil47w <= nllil15;
	w_nlllO38w <= nlllO12;
	w_nllOO31w <= nllOO9;
	w_nlO1O19w <= nlO1O6;
	w_nlOii10w <= nlOii3;
	PROCESS (recovclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n01i <= '1';
		ELSIF (recovclk = '1' AND recovclk'event) THEN n01i <= wire_n00l_o;
		END IF;
	END PROCESS;
	PROCESS (recovclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n01l <= '0';
		ELSIF (recovclk = '1' AND recovclk'event) THEN n01l <= ((((syncstatus(3) AND syncstatus(2)) AND syncstatus(1)) AND syncstatus(0)) AND w_nliii220w);
		END IF;
	END PROCESS;
	PROCESS (recovclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n0i <= '0';
		ELSIF (recovclk = '1' AND recovclk'event) THEN n0i <= wire_n0OO_o;
		END IF;
	END PROCESS;
	PROCESS (recovclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n0l <= '0';
		ELSIF (recovclk = '1' AND recovclk'event) THEN n0l <= wire_ni1l_o;
		END IF;
	END PROCESS;
	PROCESS (recovclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n0O <= '0';
		ELSIF (recovclk = '1' AND recovclk'event) THEN n0O <= wire_ni0i_o;
		END IF;
	END PROCESS;
	wire_n0O_w_lg_w_lg_w_lg_w_lg_w_lg_Q99w114w115w127w128w(0) <= wire_n0O_w_lg_w_lg_w_lg_w_lg_Q99w114w115w127w(0) OR n1Oi;
	wire_n0O_w_lg_w_lg_w_lg_w_lg_Q99w114w115w127w(0) <= wire_n0O_w_lg_w_lg_w_lg_Q99w114w115w(0) OR n1l;
	wire_n0O_w_lg_w_lg_w_lg_Q99w114w115w(0) <= wire_n0O_w_lg_w_lg_Q99w114w(0) OR n1O;
	wire_n0O_w_lg_w_lg_Q99w114w(0) <= wire_n0O_w_lg_Q99w(0) OR n0i;
	wire_n0O_w_lg_Q99w(0) <= n0O OR n0l;
	PROCESS (recovclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n1i <= '0';
		ELSIF (recovclk = '1' AND recovclk'event) THEN n1i <= wire_n0iO_o;
		END IF;
	END PROCESS;
	wire_n1i_w_lg_w_lg_w_lg_Q196w197w202w(0) <= wire_n1i_w_lg_w_lg_Q196w197w(0) OR wire_w_lg_w_nliiO200w201w(0);
	wire_n1i_w_lg_w_lg_Q196w197w(0) <= wire_n1i_w_lg_Q196w(0) OR n1Oi;
	wire_n1i_w_lg_Q196w(0) <= n1i OR nlOO;
	PROCESS (recovclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n1l <= '0';
		ELSIF (recovclk = '1' AND recovclk'event) THEN n1l <= wire_n0ll_o;
		END IF;
	END PROCESS;
	PROCESS (recovclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n1O <= '0';
		ELSIF (recovclk = '1' AND recovclk'event) THEN n1O <= wire_n0Oi_o;
		END IF;
	END PROCESS;
	wire_n1O_w_lg_w_lg_w_lg_w_lg_Q64w65w66w67w(0) <= wire_n1O_w_lg_w_lg_w_lg_Q64w65w66w(0) OR n1Oi;
	wire_n1O_w_lg_w_lg_w_lg_Q64w65w66w(0) <= wire_n1O_w_lg_w_lg_Q64w65w(0) OR nlOO;
	wire_n1O_w_lg_w_lg_Q64w65w(0) <= wire_n1O_w_lg_Q64w(0) OR n1i;
	wire_n1O_w_lg_Q64w(0) <= n1O OR n1l;
	PROCESS (recovclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n1Oi <= '1';
		ELSIF (recovclk = '1' AND recovclk'event) THEN n1Oi <= wire_n00O_o;
		END IF;
	END PROCESS;
	PROCESS (recovclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n1Ol <= '1';
		ELSIF (recovclk = '1' AND recovclk'event) THEN n1Ol <= n1OO;
		END IF;
	END PROCESS;
	wire_n1Ol_w_lg_Q41w(0) <= NOT n1Ol;
	PROCESS (recovclk, resetall)
	BEGIN
		IF (resetall = '1') THEN n1OO <= '1';
		ELSIF (recovclk = '1' AND recovclk'event) THEN n1OO <= n01i;
		END IF;
	END PROCESS;
	wire_n1OO_w_lg_Q222w(0) <= NOT n1OO;
	PROCESS (recovclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nil <= '0';
		ELSIF (recovclk = '1' AND recovclk'event) THEN nil <= niO;
		END IF;
	END PROCESS;
	PROCESS (recovclk, resetall)
	BEGIN
		IF (resetall = '1') THEN niO <= '0';
		ELSIF (recovclk = '1' AND recovclk'event) THEN niO <= wire_n01O_o;
		END IF;
	END PROCESS;
	PROCESS (recovclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nli <= '0';
		ELSIF (recovclk = '1' AND recovclk'event) THEN nli <= n01l;
		END IF;
	END PROCESS;
	wire_nli_w_lg_Q34w(0) <= NOT nli;
	wire_nli_w_lg_w_lg_Q34w35w(0) <= wire_nli_w_lg_Q34w(0) OR nlO1l;
	PROCESS (nlO0O)
	BEGIN
		IF (nlO0O = '1' AND nlO0O'event) THEN nli0l28 <= nli0l29;
		END IF;
	END PROCESS;
	PROCESS (nlO0O)
	BEGIN
		IF (nlO0O = '1' AND nlO0O'event) THEN nli0l29 <= nli0l28;
		END IF;
	END PROCESS;
	PROCESS (nlO0O)
	BEGIN
		IF (nlO0O = '1' AND nlO0O'event) THEN nli0l30 <= (nli0l29 XOR nli0l28);
		END IF;
	END PROCESS;
	PROCESS (nlO0O)
	BEGIN
		IF (nlO0O = '1' AND nlO0O'event) THEN nliii25 <= nliii26;
		END IF;
	END PROCESS;
	PROCESS (nlO0O)
	BEGIN
		IF (nlO0O = '1' AND nlO0O'event) THEN nliii26 <= nliii25;
		END IF;
	END PROCESS;
	PROCESS (nlO0O)
	BEGIN
		IF (nlO0O = '1' AND nlO0O'event) THEN nliii27 <= (nliii26 XOR nliii25);
		END IF;
	END PROCESS;
	PROCESS (nlO0O)
	BEGIN
		IF (nlO0O = '1' AND nlO0O'event) THEN nliiO22 <= nliiO23;
		END IF;
	END PROCESS;
	PROCESS (nlO0O)
	BEGIN
		IF (nlO0O = '1' AND nlO0O'event) THEN nliiO23 <= nliiO22;
		END IF;
	END PROCESS;
	PROCESS (nlO0O)
	BEGIN
		IF (nlO0O = '1' AND nlO0O'event) THEN nliiO24 <= (nliiO23 XOR nliiO22);
		END IF;
	END PROCESS;
	PROCESS (nlO0O)
	BEGIN
		IF (nlO0O = '1' AND nlO0O'event) THEN nliOi19 <= nliOi20;
		END IF;
	END PROCESS;
	PROCESS (nlO0O)
	BEGIN
		IF (nlO0O = '1' AND nlO0O'event) THEN nliOi20 <= nliOi19;
		END IF;
	END PROCESS;
	PROCESS (nlO0O)
	BEGIN
		IF (nlO0O = '1' AND nlO0O'event) THEN nliOi21 <= (nliOi20 XOR nliOi19);
		END IF;
	END PROCESS;
	PROCESS (nlO0O)
	BEGIN
		IF (nlO0O = '1' AND nlO0O'event) THEN nll0i16 <= nll0i17;
		END IF;
	END PROCESS;
	PROCESS (nlO0O)
	BEGIN
		IF (nlO0O = '1' AND nlO0O'event) THEN nll0i17 <= nll0i16;
		END IF;
	END PROCESS;
	PROCESS (nlO0O)
	BEGIN
		IF (nlO0O = '1' AND nlO0O'event) THEN nll0i18 <= (nll0i17 XOR nll0i16);
		END IF;
	END PROCESS;
	PROCESS (nlO0O)
	BEGIN
		IF (nlO0O = '1' AND nlO0O'event) THEN nllil13 <= nllil14;
		END IF;
	END PROCESS;
	PROCESS (nlO0O)
	BEGIN
		IF (nlO0O = '1' AND nlO0O'event) THEN nllil14 <= nllil13;
		END IF;
	END PROCESS;
	PROCESS (nlO0O)
	BEGIN
		IF (nlO0O = '1' AND nlO0O'event) THEN nllil15 <= (nllil14 XOR nllil13);
		END IF;
	END PROCESS;
	PROCESS (nlO0O)
	BEGIN
		IF (nlO0O = '1' AND nlO0O'event) THEN nlllO10 <= nlllO11;
		END IF;
	END PROCESS;
	PROCESS (nlO0O)
	BEGIN
		IF (nlO0O = '1' AND nlO0O'event) THEN nlllO11 <= nlllO10;
		END IF;
	END PROCESS;
	PROCESS (nlO0O)
	BEGIN
		IF (nlO0O = '1' AND nlO0O'event) THEN nlllO12 <= (nlllO11 XOR nlllO10);
		END IF;
	END PROCESS;
	PROCESS (nlO0O)
	BEGIN
		IF (nlO0O = '1' AND nlO0O'event) THEN nllOO7 <= nllOO8;
		END IF;
	END PROCESS;
	PROCESS (nlO0O)
	BEGIN
		IF (nlO0O = '1' AND nlO0O'event) THEN nllOO8 <= nllOO7;
		END IF;
	END PROCESS;
	PROCESS (nlO0O)
	BEGIN
		IF (nlO0O = '1' AND nlO0O'event) THEN nllOO9 <= (nllOO8 XOR nllOO7);
		END IF;
	END PROCESS;
	PROCESS (nlO0O)
	BEGIN
		IF (nlO0O = '1' AND nlO0O'event) THEN nlO1O4 <= nlO1O5;
		END IF;
	END PROCESS;
	PROCESS (nlO0O)
	BEGIN
		IF (nlO0O = '1' AND nlO0O'event) THEN nlO1O5 <= nlO1O4;
		END IF;
	END PROCESS;
	PROCESS (nlO0O)
	BEGIN
		IF (nlO0O = '1' AND nlO0O'event) THEN nlO1O6 <= (nlO1O5 XOR nlO1O4);
		END IF;
	END PROCESS;
	PROCESS (nlO0O)
	BEGIN
		IF (nlO0O = '1' AND nlO0O'event) THEN nlOii1 <= nlOii2;
		END IF;
	END PROCESS;
	PROCESS (nlO0O)
	BEGIN
		IF (nlO0O = '1' AND nlO0O'event) THEN nlOii2 <= nlOii1;
		END IF;
	END PROCESS;
	PROCESS (nlO0O)
	BEGIN
		IF (nlO0O = '1' AND nlO0O'event) THEN nlOii3 <= (nlOii2 XOR nlOii1);
		END IF;
	END PROCESS;
	PROCESS (recovclk, resetall)
	BEGIN
		IF (resetall = '1') THEN nlOO <= '0';
		ELSIF (recovclk = '1' AND recovclk'event) THEN nlOO <= wire_n0ii_o;
		END IF;
	END PROCESS;
	wire_ni0O_dataout <= n01i OR nllii;
	wire_niii_dataout <= niO AND NOT(nllii);
	wire_niil_dataout <= nlO0l AND NOT(nllii);
	wire_niiO_dataout <= wire_w_lg_nlO0l15w(0) AND NOT(nllii);
	wire_nill_dataout <= wire_niOl_dataout AND NOT(wire_nli_w_lg_Q34w(0));
	wire_nilO_dataout <= wire_niOO_dataout AND NOT(wire_nli_w_lg_Q34w(0));
	wire_niOi_dataout <= nlO1l AND NOT(wire_nli_w_lg_Q34w(0));
	wire_niOl_dataout <= nlO0l AND NOT(nlO1l);
	wire_niOO_dataout <= wire_w_lg_nlO0l15w(0) AND NOT(nlO1l);
	wire_nl0i_dataout <= niO WHEN nllll = '1'  ELSE wire_nlii_dataout;
	wire_nl0l_dataout <= wire_w_lg_nlO0l15w(0) AND NOT(nllll);
	wire_nl0O_dataout <= nlO0l AND NOT(nllll);
	wire_nl1i_dataout <= n01i OR wire_nli_w_lg_Q34w(0);
	wire_nl1l_dataout <= niO AND NOT(wire_nli_w_lg_Q34w(0));
	wire_nl1O_dataout <= wire_w_lg_nlO1l44w(0) AND NOT(wire_nli_w_lg_Q34w(0));
	wire_nlii_dataout <= niO OR nlO0l;
	wire_nlil_dataout <= n01i OR nllll;
	wire_nliO_dataout <= wire_w_lg_nllli43w(0) AND NOT(nllll);
	wire_nlli_dataout <= nllli AND NOT(nllll);
	wire_nlOi_dataout <= n01i AND NOT(nllOl);
	wire_n00l_data <= ( wire_nlOi_dataout & wire_nlil_dataout & wire_nlil_dataout & wire_nlil_dataout & wire_nl1i_dataout & wire_nl1i_dataout & wire_nl1i_dataout & wire_ni0O_dataout);
	wire_n00l_sel <= ( n1Oi & nlOO & n1i & n1l & n1O & n0i & n0l & n0O);
	n00l :  oper_selector
	  GENERIC MAP (
		width_data => 8,
		width_sel => 8
	  )
	  PORT MAP ( 
		data => wire_n00l_data,
		o => wire_n00l_o,
		sel => wire_n00l_sel
	  );
	wire_n00O_data <= ( wire_w_lg_nllOl171w & nllll & nllll & nllll & wire_nli_w_lg_Q34w & wire_nli_w_lg_Q34w & wire_nli_w_lg_Q34w & nllii);
	wire_n00O_sel <= ( n1Oi & nlOO & n1i & n1l & n1O & n0i & n0l & n0O);
	n00O :  oper_selector
	  GENERIC MAP (
		width_data => 8,
		width_sel => 8
	  )
	  PORT MAP ( 
		data => wire_n00O_data,
		o => wire_n00O_o,
		sel => wire_n00O_sel
	  );
	wire_n01O_data <= ( niO & wire_nl0i_dataout & wire_nl1l_dataout & wire_nl1l_dataout & wire_nl1l_dataout & wire_niii_dataout);
	wire_n01O_sel <= ( wire_n1i_w_lg_w_lg_w_lg_Q196w197w202w & n1l & n1O & n0i & n0l & n0O);
	n01O :  oper_selector
	  GENERIC MAP (
		width_data => 6,
		width_sel => 6
	  )
	  PORT MAP ( 
		data => wire_n01O_data,
		o => wire_n01O_o,
		sel => wire_n01O_sel
	  );
	wire_n0ii_data <= ( nllOl & wire_nliO_dataout & "0");
	wire_n0ii_sel <= ( n1Oi & nlOO & nlill);
	n0ii :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n0ii_data,
		o => wire_n0ii_o,
		sel => wire_n0ii_sel
	  );
	wire_n0iO_data <= ( "0" & wire_nlli_dataout & wire_nl0l_dataout);
	wire_n0iO_sel <= ( nlilO & nlOO & n1i);
	n0iO :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n0iO_data,
		o => wire_n0iO_o,
		sel => wire_n0iO_sel
	  );
	wire_n0ll_data <= ( "0" & wire_nl0O_dataout & wire_nl0l_dataout);
	wire_n0ll_sel <= ( nliOO & n1i & n1l);
	n0ll :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n0ll_data,
		o => wire_n0ll_o,
		sel => wire_n0ll_sel
	  );
	wire_n0Oi_data <= ( "0" & wire_nl0O_dataout & wire_nl1O_dataout & wire_nill_dataout);
	wire_n0Oi_sel <= ( nll1i & n1l & n1O & n0i);
	n0Oi :  oper_selector
	  GENERIC MAP (
		width_data => 4,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_n0Oi_data,
		o => wire_n0Oi_o,
		sel => wire_n0Oi_sel
	  );
	wire_n0OO_data <= ( "0" & wire_niOi_dataout & wire_nilO_dataout & wire_nill_dataout);
	wire_n0OO_sel <= ( nll1l & n1O & n0i & n0l);
	n0OO :  oper_selector
	  GENERIC MAP (
		width_data => 4,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_n0OO_data,
		o => wire_n0OO_o,
		sel => wire_n0OO_sel
	  );
	wire_ni0i_data <= ( "0" & wire_niOi_dataout & wire_niiO_dataout);
	wire_ni0i_sel <= ( nll0O & n0l & n0O);
	ni0i :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_ni0i_data,
		o => wire_ni0i_o,
		sel => wire_ni0i_sel
	  );
	wire_ni1l_data <= ( "0" & wire_niOi_dataout & wire_nilO_dataout & wire_niil_dataout);
	wire_ni1l_sel <= ( nll1O & n0i & n0l & n0O);
	ni1l :  oper_selector
	  GENERIC MAP (
		width_data => 4,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_ni1l_data,
		o => wire_ni1l_o,
		sel => wire_ni1l_sel
	  );

 END RTL; --stratixgx_xgm_dskw_sm
--synopsys translate_on
--VALID FILE
--
-- stratixgx_reset_block
-- 

library IEEE, stratixgx_gxb;
use IEEE.std_logic_1164.all;
use stratixgx_gxb.hssi_pack.all;

ENTITY stratixgx_reset_block IS
   PORT (
      txdigitalreset          : IN std_logic_vector(3 DOWNTO 0);   
      rxdigitalreset          : IN std_logic_vector(3 DOWNTO 0);   
      rxanalogreset           : IN std_logic_vector(3 DOWNTO 0);   
      pllreset                : IN std_logic;   
      pllenable               : IN std_logic;   
      txdigitalresetout       : OUT std_logic_vector(3 DOWNTO 0);   
      rxdigitalresetout       : OUT std_logic_vector(3 DOWNTO 0);   
      txanalogresetout        : OUT std_logic_vector(3 DOWNTO 0);   
      rxanalogresetout        : OUT std_logic_vector(3 DOWNTO 0);   
      pllresetout             : OUT std_logic);   
END stratixgx_reset_block;

ARCHITECTURE stratixgx_reset_arch OF stratixgx_reset_block IS
   -- WIREs:
   signal HARD_RESET              :  std_logic;   
   signal txdigitalresetout_tmp   :  std_logic_vector(3 DOWNTO 0);   
   signal rxdigitalresetout_tmp   :  std_logic_vector(3 DOWNTO 0);   
   signal txanalogresetout_tmp    :  std_logic_vector(3 DOWNTO 0);   
   signal rxanalogresetout_tmp    :  std_logic_vector(3 DOWNTO 0);   
   signal pllresetout_tmp         :  std_logic;   

BEGIN

  txdigitalresetout <= txdigitalresetout_tmp;
   
  rxdigitalresetout <= rxdigitalresetout_tmp;

  txanalogresetout <= txanalogresetout_tmp;

  rxanalogresetout <= rxanalogresetout_tmp;

  pllresetout <= pllresetout_tmp;

  HARD_RESET <= pllreset OR NOT pllenable ;

  rxanalogresetout_tmp <= (HARD_RESET OR rxanalogreset(3)) &
                          (HARD_RESET OR rxanalogreset(2)) &
                          (HARD_RESET OR rxanalogreset(1)) &
                          (HARD_RESET OR rxanalogreset(0)) ;
   
  txanalogresetout_tmp <= (HARD_RESET & HARD_RESET &
                           HARD_RESET & HARD_RESET);
   
  pllresetout_tmp <= ((((((rxanalogresetout_tmp(0) AND rxanalogresetout_tmp(1)) AND
                          rxanalogresetout_tmp(2)) AND rxanalogresetout_tmp(3)) AND
                        txanalogresetout_tmp(0)) AND txanalogresetout_tmp(1)) AND
                      txanalogresetout_tmp(2)) AND txanalogresetout_tmp(3) ;

  rxdigitalresetout_tmp <= (HARD_RESET OR rxdigitalreset(3)) &
                           (HARD_RESET OR rxdigitalreset(2)) &
                           (HARD_RESET OR rxdigitalreset(1)) &
                           (HARD_RESET OR rxdigitalreset(0)) ;
   
  txdigitalresetout_tmp <= (HARD_RESET OR txdigitalreset(3)) &
                           (HARD_RESET OR txdigitalreset(2)) &
                           (HARD_RESET OR txdigitalreset(1)) &
                           (HARD_RESET OR txdigitalreset(0)) ;

END stratixgx_reset_arch;


--IP Functional Simulation Model
--VERSION_BEGIN 4.1 cbx_mgl 2004:06:17:17:30:06:SJ cbx_simgen 2004:06:22:10:53:08:SJ  VERSION_END


-- Legal Notice: © 2003 Altera Corporation. All rights reserved.
-- You may only use these  simulation  model  output files for simulation
-- purposes and expressly not for synthesis or any other purposes (in which
-- event  Altera disclaims all warranties of any kind). Your use of  Altera
-- Corporation's design tools, logic functions and other software and tools,
-- and its AMPP partner logic functions, and any output files any of the
-- foregoing (including device programming or simulation files), and any
-- associated documentation or information  are expressly subject to the
-- terms and conditions of the  Altera Program License Subscription Agreement
-- or other applicable license agreement, including, without limitation, that
-- your use is for the sole purpose of programming logic devices manufactured
-- by Altera and sold by Altera or its authorized distributors.  Please refer
-- to the applicable agreement for further details.


--synopsys translate_off

 LIBRARY sgate;
 USE sgate.sgate_pack.all;

--synthesis_resources = lut 83 mux21 46 oper_decoder 1 oper_selector 10 
 LIBRARY ieee;
 USE ieee.std_logic_1164.all;

 ENTITY  stratixgx_hssi_tx_enc_rtl IS 
	 PORT 
	 ( 
		 ENDEC	:	IN  STD_LOGIC;
		 GE_XAUI_SEL	:	IN  STD_LOGIC;
		 IB_FORCE_DISPARITY	:	IN  STD_LOGIC;
		 INDV	:	IN  STD_LOGIC;
		 prbs_en	:	IN  STD_LOGIC;
		 PUDR	:	OUT  STD_LOGIC_VECTOR (9 DOWNTO 0);
		 soft_reset	:	IN  STD_LOGIC;
		 tx_clk	:	IN  STD_LOGIC;
		 tx_ctl_tc	:	IN  STD_LOGIC;
		 tx_ctl_ts	:	IN  STD_LOGIC;
		 tx_data_9_tc	:	IN  STD_LOGIC;
		 tx_data_pg	:	IN  STD_LOGIC_VECTOR (9 DOWNTO 0);
		 tx_data_tc	:	IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
		 tx_data_ts	:	IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
		 TXLP10B	:	OUT  STD_LOGIC_VECTOR (9 DOWNTO 0)
	 ); 
 END stratixgx_hssi_tx_enc_rtl;

 ARCHITECTURE RTL OF stratixgx_hssi_tx_enc_rtl IS

	 ATTRIBUTE synthesis_clearbox : boolean;
	 ATTRIBUTE synthesis_clearbox OF RTL : ARCHITECTURE IS true;
	 SIGNAL	n00i	:	STD_LOGIC := '0';
	 SIGNAL	n00l	:	STD_LOGIC := '0';
	 SIGNAL	n00O	:	STD_LOGIC := '0';
	 SIGNAL	n01i	:	STD_LOGIC := '0';
	 SIGNAL	n01l	:	STD_LOGIC := '0';
	 SIGNAL	n01O	:	STD_LOGIC := '0';
	 SIGNAL	n0ii	:	STD_LOGIC := '0';
	 SIGNAL	n101l43	:	STD_LOGIC := '1';
	 SIGNAL	n101l44	:	STD_LOGIC := '0';
	 SIGNAL	n101l45	:	STD_LOGIC := '0';
	 SIGNAL	n10ii40	:	STD_LOGIC := '1';
	 SIGNAL	n10ii41	:	STD_LOGIC := '0';
	 SIGNAL	n10ii42	:	STD_LOGIC := '0';
	 SIGNAL	n10l	:	STD_LOGIC := '0';
	 SIGNAL  wire_n10l_w_lg_Q57w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n10ll37	:	STD_LOGIC := '1';
	 SIGNAL	n10ll38	:	STD_LOGIC := '0';
	 SIGNAL	n10ll39	:	STD_LOGIC := '0';
	 SIGNAL	n10O	:	STD_LOGIC := '0';
	 SIGNAL	wire_n10O_ENA	:	STD_LOGIC;
	 SIGNAL  wire_n10O_w_lg_Q122w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n10Oi34	:	STD_LOGIC := '1';
	 SIGNAL	n10Oi35	:	STD_LOGIC := '0';
	 SIGNAL	n10Oi36	:	STD_LOGIC := '0';
	 SIGNAL	n10OO31	:	STD_LOGIC := '1';
	 SIGNAL	n10OO32	:	STD_LOGIC := '0';
	 SIGNAL	n10OO33	:	STD_LOGIC := '0';
	 SIGNAL	n110l55	:	STD_LOGIC := '1';
	 SIGNAL	n110l56	:	STD_LOGIC := '0';
	 SIGNAL	n110l57	:	STD_LOGIC := '0';
	 SIGNAL	n111O58	:	STD_LOGIC := '1';
	 SIGNAL	n111O59	:	STD_LOGIC := '0';
	 SIGNAL	n111O60	:	STD_LOGIC := '0';
	 SIGNAL	n11ii52	:	STD_LOGIC := '1';
	 SIGNAL	n11ii53	:	STD_LOGIC := '0';
	 SIGNAL	n11ii54	:	STD_LOGIC := '0';
	 SIGNAL	n11iO49	:	STD_LOGIC := '1';
	 SIGNAL	n11iO50	:	STD_LOGIC := '0';
	 SIGNAL	n11iO51	:	STD_LOGIC := '0';
	 SIGNAL	n11OO46	:	STD_LOGIC := '1';
	 SIGNAL	n11OO47	:	STD_LOGIC := '0';
	 SIGNAL	n11OO48	:	STD_LOGIC := '0';
	 SIGNAL	n1i0l25	:	STD_LOGIC := '1';
	 SIGNAL	n1i0l26	:	STD_LOGIC := '0';
	 SIGNAL	n1i0l27	:	STD_LOGIC := '0';
	 SIGNAL	n1i1O28	:	STD_LOGIC := '1';
	 SIGNAL	n1i1O29	:	STD_LOGIC := '0';
	 SIGNAL	n1i1O30	:	STD_LOGIC := '0';
	 SIGNAL	n1ii	:	STD_LOGIC := '0';
	 SIGNAL  wire_n1ii_w_lg_w_lg_Q108w112w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1ii_w_lg_w_lg_Q61w65w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1ii_w_lg_Q108w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1ii_w_lg_Q61w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n1iii22	:	STD_LOGIC := '1';
	 SIGNAL	n1iii23	:	STD_LOGIC := '0';
	 SIGNAL	n1iii24	:	STD_LOGIC := '0';
	 SIGNAL	n1iiO19	:	STD_LOGIC := '1';
	 SIGNAL	n1iiO20	:	STD_LOGIC := '0';
	 SIGNAL	n1iiO21	:	STD_LOGIC := '0';
	 SIGNAL	n1il	:	STD_LOGIC := '0';
	 SIGNAL	n1ill16	:	STD_LOGIC := '1';
	 SIGNAL	n1ill17	:	STD_LOGIC := '0';
	 SIGNAL	n1ill18	:	STD_LOGIC := '0';
	 SIGNAL	n1iO	:	STD_LOGIC := '0';
	 SIGNAL	n1iOi13	:	STD_LOGIC := '1';
	 SIGNAL	n1iOi14	:	STD_LOGIC := '0';
	 SIGNAL	n1iOi15	:	STD_LOGIC := '0';
	 SIGNAL	n1iOO10	:	STD_LOGIC := '1';
	 SIGNAL	n1iOO11	:	STD_LOGIC := '0';
	 SIGNAL	n1iOO12	:	STD_LOGIC := '0';
	 SIGNAL	n1l0O4	:	STD_LOGIC := '1';
	 SIGNAL	n1l0O5	:	STD_LOGIC := '0';
	 SIGNAL	n1l0O6	:	STD_LOGIC := '0';
	 SIGNAL	n1l1O7	:	STD_LOGIC := '1';
	 SIGNAL	n1l1O8	:	STD_LOGIC := '0';
	 SIGNAL	n1l1O9	:	STD_LOGIC := '0';
	 SIGNAL	n1li	:	STD_LOGIC := '0';
	 SIGNAL	n1lli1	:	STD_LOGIC := '1';
	 SIGNAL	n1lli2	:	STD_LOGIC := '0';
	 SIGNAL	n1lli3	:	STD_LOGIC := '0';
	 SIGNAL	n1Oi	:	STD_LOGIC := '0';
	 SIGNAL	n1Ol	:	STD_LOGIC := '0';
	 SIGNAL	n1OO	:	STD_LOGIC := '0';
	 SIGNAL	nlO0i	:	STD_LOGIC := '0';
	 SIGNAL	nlO0l	:	STD_LOGIC := '0';
	 SIGNAL	nlO0O	:	STD_LOGIC := '0';
	 SIGNAL	nlO1i	:	STD_LOGIC := '0';
	 SIGNAL	nlO1l	:	STD_LOGIC := '0';
	 SIGNAL	nlO1O	:	STD_LOGIC := '0';
	 SIGNAL	nlOii	:	STD_LOGIC := '0';
	 SIGNAL	wire_n0iiO_dataout	:	STD_LOGIC;
	 SIGNAL  wire_n0iiO_w_lg_w_lg_w_lg_dataout253w256w260w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0iiO_w_lg_w_lg_dataout253w256w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0iiO_w_lg_dataout325w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0iiO_w_lg_dataout253w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_n0liO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0llO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni01l_dataout	:	STD_LOGIC;
	 SIGNAL  wire_ni01l_w_lg_dataout383w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_ni0i_dataout	:	STD_LOGIC;
	 SIGNAL  wire_ni0i_w_lg_w_lg_w_lg_w_lg_w_lg_dataout276w280w282w284w288w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0i_w_lg_w_lg_w_lg_w_lg_dataout276w280w282w284w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0i_w_lg_w_lg_w_lg_dataout276w280w282w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0i_w_lg_w_lg_w_lg_dataout289w290w294w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0i_w_lg_w_lg_dataout276w280w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0i_w_lg_w_lg_dataout289w340w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0i_w_lg_w_lg_dataout289w290w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0i_w_lg_dataout276w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0i_w_lg_dataout341w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0i_w_lg_dataout289w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0i_w_lg_dataout349w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_ni0l_dataout	:	STD_LOGIC;
	 SIGNAL  wire_ni0l_w_lg_dataout275w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_ni0O_dataout	:	STD_LOGIC;
	 SIGNAL  wire_ni0O_w_lg_w_lg_w_lg_dataout281w295w299w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0O_w_lg_w_lg_dataout281w295w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0O_w_lg_w_lg_dataout281w313w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0O_w_lg_w_lg_dataout281w305w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0O_w_lg_w_lg_dataout281w424w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0O_w_lg_w_lg_dataout281w419w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0O_w_lg_w_lg_dataout281w405w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0O_w_lg_w_lg_dataout281w402w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0O_w_lg_dataout408w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0O_w_lg_dataout319w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0O_w_lg_dataout316w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0O_w_lg_dataout361w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0O_w_lg_dataout311w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0O_w_lg_dataout281w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0O_w_lg_dataout350w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_ni1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1li_dataout	:	STD_LOGIC;
	 SIGNAL  wire_ni1li_w_lg_dataout381w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_ni1ll_dataout	:	STD_LOGIC;
	 SIGNAL  wire_ni1ll_w_lg_dataout382w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_ni1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niii_dataout	:	STD_LOGIC;
	 SIGNAL  wire_niii_w_lg_w_lg_dataout283w362w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niii_w_lg_w_lg_dataout283w312w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niii_w_lg_w_lg_dataout283w308w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niii_w_lg_w_lg_dataout283w371w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niii_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_dataout283w312w315w318w321w324w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niii_w_lg_dataout314w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niii_w_lg_dataout306w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niii_w_lg_dataout425w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niii_w_lg_dataout420w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niii_w_lg_dataout406w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niii_w_lg_dataout403w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niii_w_lg_dataout409w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niii_w_lg_dataout320w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niii_w_lg_dataout317w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niii_w_lg_dataout323w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niii_w_lg_dataout283w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niii_w_lg_w_lg_w_lg_dataout283w362w364w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niii_w_lg_w_lg_w_lg_dataout283w312w315w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niii_w_lg_w_lg_w_lg_w_lg_dataout283w362w364w366w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niii_w_lg_w_lg_w_lg_w_lg_dataout283w312w315w318w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niii_w_lg_w_lg_w_lg_w_lg_w_lg_dataout283w362w364w366w368w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niii_w_lg_w_lg_w_lg_w_lg_w_lg_dataout283w312w315w318w321w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niii_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_dataout283w362w364w366w368w369w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_niil_dataout	:	STD_LOGIC;
	 SIGNAL  wire_niil_w_lg_w_lg_dataout322w373w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niil_w_lg_dataout358w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niil_w_lg_dataout367w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niil_w_lg_dataout365w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niil_w_lg_dataout363w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niil_w_lg_dataout322w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niil_w_lg_w_lg_dataout322w352w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_niiO_dataout	:	STD_LOGIC;
	 SIGNAL  wire_niiO_w_lg_dataout327w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niiO_w_lg_dataout337w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nili_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nili_w_lg_dataout328w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nili_w_lg_dataout274w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nill_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nill_w_lg_dataout329w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nill_w_lg_dataout270w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO1O_dataout	:	STD_LOGIC;
	 SIGNAL  wire_niO1O_w_lg_dataout269w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_niOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOil_dataout	:	STD_LOGIC;
	 SIGNAL  wire_niOil_w_lg_dataout271w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_niOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOli_dataout	:	STD_LOGIC;
	 SIGNAL  wire_niOli_w_lg_dataout272w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_niOll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO_dataout	:	STD_LOGIC;
	 SIGNAL  wire_n10i_i	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_n10i_o	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n11i_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n11i_o	:	STD_LOGIC;
	 SIGNAL  wire_n11i_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n11l_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n11l_o	:	STD_LOGIC;
	 SIGNAL  wire_n11l_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOil_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOil_o	:	STD_LOGIC;
	 SIGNAL  wire_nlOil_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOiO_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOiO_o	:	STD_LOGIC;
	 SIGNAL  wire_nlOiO_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOli_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOli_o	:	STD_LOGIC;
	 SIGNAL  wire_nlOli_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOll_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOll_o	:	STD_LOGIC;
	 SIGNAL  wire_nlOll_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOlO_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOlO_o	:	STD_LOGIC;
	 SIGNAL  wire_nlOlO_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOOi_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOOi_o	:	STD_LOGIC;
	 SIGNAL  wire_nlOOi_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOOl_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOOl_o	:	STD_LOGIC;
	 SIGNAL  wire_nlOOl_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOOO_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOOO_o	:	STD_LOGIC;
	 SIGNAL  wire_nlOOO_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_nlOOii354w356w357w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_GE_XAUI_SEL102w106w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_GE_XAUI_SEL75w79w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_GE_XAUI_SEL59w90w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1lil58w101w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1lil58w74w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n100i254w255w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_nlOOii354w356w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_tx_ctl_tc42w107w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_tx_ctl_tc42w60w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_GE_XAUI_SEL102w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_GE_XAUI_SEL75w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_GE_XAUI_SEL59w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n100i262w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1lil58w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nlOOil353w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n100i254w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10iO370w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1l1l127w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nlOO0O379w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nlOOii354w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nlOOil355w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nlOOiO380w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_soft_reset126w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_tx_ctl_tc42w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_n10ii136w137w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_n11OO266w267w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_n1l0O39w40w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_n1l1O54w55w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_n1lli24w25w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_tx_data_tc_range1w2w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n100l261w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nlOO0i375w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nlOO0l376w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nlOOlO372w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nlOOOO374w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_tx_ctl_tc3w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_tx_ctl_tc27w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  n100i :	STD_LOGIC;
	 SIGNAL  n100l :	STD_LOGIC;
	 SIGNAL  n100O :	STD_LOGIC;
	 SIGNAL  n10iO :	STD_LOGIC;
	 SIGNAL  n10li :	STD_LOGIC;
	 SIGNAL  n111i :	STD_LOGIC;
	 SIGNAL  n111l :	STD_LOGIC;
	 SIGNAL  n11ll :	STD_LOGIC;
	 SIGNAL  n11lO :	STD_LOGIC;
	 SIGNAL  n11Oi :	STD_LOGIC;
	 SIGNAL  n11Ol :	STD_LOGIC;
	 SIGNAL  n1i1l :	STD_LOGIC;
	 SIGNAL  n1l0l :	STD_LOGIC;
	 SIGNAL  n1l1l :	STD_LOGIC;
	 SIGNAL  n1lil :	STD_LOGIC;
	 SIGNAL  n1liO :	STD_LOGIC;
	 SIGNAL  nlOlOl :	STD_LOGIC;
	 SIGNAL  nlOlOO :	STD_LOGIC;
	 SIGNAL  nlOO0i :	STD_LOGIC;
	 SIGNAL  nlOO0l :	STD_LOGIC;
	 SIGNAL  nlOO0O :	STD_LOGIC;
	 SIGNAL  nlOO1i :	STD_LOGIC;
	 SIGNAL  nlOO1l :	STD_LOGIC;
	 SIGNAL  nlOO1O :	STD_LOGIC;
	 SIGNAL  nlOOii :	STD_LOGIC;
	 SIGNAL  nlOOil :	STD_LOGIC;
	 SIGNAL  nlOOiO :	STD_LOGIC;
	 SIGNAL  nlOOli :	STD_LOGIC;
	 SIGNAL  nlOOll :	STD_LOGIC;
	 SIGNAL  nlOOlO :	STD_LOGIC;
	 SIGNAL  nlOOOi :	STD_LOGIC;
	 SIGNAL  nlOOOl :	STD_LOGIC;
	 SIGNAL  nlOOOO :	STD_LOGIC;
	 SIGNAL  w_n101l259w :	STD_LOGIC;
	 SIGNAL  w_n10ii136w :	STD_LOGIC;
	 SIGNAL  w_n10ll111w :	STD_LOGIC;
	 SIGNAL  w_n10Oi105w :	STD_LOGIC;
	 SIGNAL  w_n10OO100w :	STD_LOGIC;
	 SIGNAL  w_n110l293w :	STD_LOGIC;
	 SIGNAL  w_n111O298w :	STD_LOGIC;
	 SIGNAL  w_n11ii287w :	STD_LOGIC;
	 SIGNAL  w_n11iO279w :	STD_LOGIC;
	 SIGNAL  w_n11OO266w :	STD_LOGIC;
	 SIGNAL  w_n1i0l89w :	STD_LOGIC;
	 SIGNAL  w_n1i1O95w :	STD_LOGIC;
	 SIGNAL  w_n1iii85w :	STD_LOGIC;
	 SIGNAL  w_n1iiO78w :	STD_LOGIC;
	 SIGNAL  w_n1ill73w :	STD_LOGIC;
	 SIGNAL  w_n1iOi69w :	STD_LOGIC;
	 SIGNAL  w_n1iOO64w :	STD_LOGIC;
	 SIGNAL  w_n1l0O39w :	STD_LOGIC;
	 SIGNAL  w_n1l1O54w :	STD_LOGIC;
	 SIGNAL  w_n1lli24w :	STD_LOGIC;
	 SIGNAL  wire_w_tx_data_tc_range1w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 COMPONENT  oper_decoder
	 GENERIC 
	 (
		width_i	:	NATURAL;
		width_o	:	NATURAL
	 );
	 PORT
	 ( 
		i	:	IN STD_LOGIC_VECTOR(width_i-1 DOWNTO 0);
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	 ); 
	 END COMPONENT;
	 COMPONENT  oper_selector
	 GENERIC 
	 (
		width_data	:	NATURAL;
		width_sel	:	NATURAL
	 );
	 PORT
	 ( 
		data	:	IN STD_LOGIC_VECTOR(width_data-1 DOWNTO 0);
		o	:	OUT STD_LOGIC;
		sel	:	IN STD_LOGIC_VECTOR(width_sel-1 DOWNTO 0)
	 ); 
	 END COMPONENT;
 BEGIN

	wire_w_lg_w_lg_w_lg_nlOOii354w356w357w(0) <= wire_w_lg_w_lg_nlOOii354w356w(0) AND nlOOli;
	wire_w_lg_w_lg_GE_XAUI_SEL102w106w(0) <= wire_w_lg_GE_XAUI_SEL102w(0) AND w_n10Oi105w;
	wire_w_lg_w_lg_GE_XAUI_SEL75w79w(0) <= wire_w_lg_GE_XAUI_SEL75w(0) AND w_n1iiO78w;
	wire_w_lg_w_lg_GE_XAUI_SEL59w90w(0) <= wire_w_lg_GE_XAUI_SEL59w(0) AND w_n1i0l89w;
	wire_w_lg_w_lg_n1lil58w101w(0) <= wire_w_lg_n1lil58w(0) AND w_n10OO100w;
	wire_w_lg_w_lg_n1lil58w74w(0) <= wire_w_lg_n1lil58w(0) AND w_n1ill73w;
	wire_w_lg_w_lg_n100i254w255w(0) <= wire_w_lg_n100i254w(0) AND wire_n1i_dataout;
	wire_w_lg_w_lg_nlOOii354w356w(0) <= wire_w_lg_nlOOii354w(0) AND wire_w_lg_nlOOil355w(0);
	wire_w_lg_w_lg_tx_ctl_tc42w107w(0) <= wire_w_lg_tx_ctl_tc42w(0) AND wire_w_lg_w_lg_GE_XAUI_SEL102w106w(0);
	wire_w_lg_w_lg_tx_ctl_tc42w60w(0) <= wire_w_lg_tx_ctl_tc42w(0) AND wire_w_lg_GE_XAUI_SEL59w(0);
	wire_w_lg_GE_XAUI_SEL102w(0) <= GE_XAUI_SEL AND wire_w_lg_w_lg_n1lil58w101w(0);
	wire_w_lg_GE_XAUI_SEL75w(0) <= GE_XAUI_SEL AND wire_w_lg_w_lg_n1lil58w74w(0);
	wire_w_lg_GE_XAUI_SEL59w(0) <= GE_XAUI_SEL AND wire_w_lg_n1lil58w(0);
	wire_w_lg_n100i262w(0) <= n100i AND wire_n0iiO_w_lg_dataout253w(0);
	wire_w_lg_n1lil58w(0) <= n1lil AND n1l0l;
	wire_w_lg_nlOOil353w(0) <= nlOOil AND wire_niil_w_lg_w_lg_dataout322w352w(0);
	wire_w_lg_n100i254w(0) <= NOT n100i;
	wire_w_lg_n10iO370w(0) <= NOT n10iO;
	wire_w_lg_n1l1l127w(0) <= NOT n1l1l;
	wire_w_lg_nlOO0O379w(0) <= NOT nlOO0O;
	wire_w_lg_nlOOii354w(0) <= NOT nlOOii;
	wire_w_lg_nlOOil355w(0) <= NOT nlOOil;
	wire_w_lg_nlOOiO380w(0) <= NOT nlOOiO;
	wire_w_lg_soft_reset126w(0) <= NOT soft_reset;
	wire_w_lg_tx_ctl_tc42w(0) <= NOT tx_ctl_tc;
	wire_w_lg_w_n10ii136w137w(0) <= NOT w_n10ii136w;
	wire_w_lg_w_n11OO266w267w(0) <= NOT w_n11OO266w;
	wire_w_lg_w_n1l0O39w40w(0) <= NOT w_n1l0O39w;
	wire_w_lg_w_n1l1O54w55w(0) <= NOT w_n1l1O54w;
	wire_w_lg_w_n1lli24w25w(0) <= NOT w_n1lli24w;
	wire_w_lg_w_tx_data_tc_range1w2w(0) <= NOT wire_w_tx_data_tc_range1w(0);
	wire_w_lg_n100l261w(0) <= n100l OR wire_n0iiO_w_lg_w_lg_w_lg_dataout253w256w260w(0);
	wire_w_lg_nlOO0i375w(0) <= nlOO0i OR wire_w_lg_nlOOOO374w(0);
	wire_w_lg_nlOO0l376w(0) <= nlOO0l OR wire_w_lg_nlOO0i375w(0);
	wire_w_lg_nlOOlO372w(0) <= nlOOlO OR wire_niii_w_lg_w_lg_dataout283w371w(0);
	wire_w_lg_nlOOOO374w(0) <= nlOOOO OR wire_niil_w_lg_w_lg_dataout322w373w(0);
	wire_w_lg_tx_ctl_tc3w(0) <= tx_ctl_tc OR wire_w_lg_w_tx_data_tc_range1w2w(0);
	wire_w_lg_tx_ctl_tc27w(0) <= tx_ctl_tc OR wire_w_tx_data_tc_range1w(0);
	n100i <= (n100l OR n11lO);
	n100l <= (wire_niiO_dataout AND wire_nili_dataout);
	n100O <= ((wire_n10i_o(3) OR wire_n10i_o(1)) OR wire_w_lg_w_n10ii136w137w(0));
	n10iO <= (n10l OR (wire_n10O_w_lg_Q122w(0) AND (tx_data_9_tc AND IB_FORCE_DISPARITY)));
	n10li <= (wire_n10l_w_lg_Q57w(0) AND wire_n1ii_w_lg_w_lg_Q108w112w(0));
	n111i <= wire_ni0i_w_lg_dataout341w(0);
	n111l <= wire_ni0i_w_lg_w_lg_dataout289w340w(0);
	n11ll <= (n11lO AND wire_nill_w_lg_dataout270w(0));
	n11lO <= (wire_niiO_w_lg_dataout337w(0) AND wire_nili_w_lg_dataout274w(0));
	n11Oi <= (wire_nill_dataout AND (wire_nili_dataout AND (wire_niiO_dataout AND (((((((wire_ni0i_w_lg_w_lg_w_lg_w_lg_w_lg_dataout276w280w282w284w288w(0) OR (wire_niii_w_lg_dataout283w(0) AND wire_ni0O_w_lg_w_lg_w_lg_dataout281w295w299w(0))) OR (wire_niii_w_lg_dataout283w(0) AND (wire_ni0O_dataout AND n111l))) OR wire_niii_w_lg_dataout306w(0)) AND wire_niii_w_lg_w_lg_dataout283w308w(0)) AND wire_n0iiO_w_lg_dataout253w(0)) OR wire_n0iiO_w_lg_dataout325w(0)) OR wire_nill_w_lg_dataout329w(0)))));
	n11Ol <= ((wire_w_lg_n100l261w(0) XOR wire_w_lg_n100i262w(0)) XOR wire_w_lg_w_n11OO266w267w(0));
	n1i1l <= (n10l AND ((n1ii AND (wire_w_lg_tx_ctl_tc42w(0) AND wire_w_lg_w_lg_GE_XAUI_SEL59w90w(0))) AND w_n1i1O95w));
	n1l0l <= ((((((((wire_w_lg_tx_ctl_tc27w(0) OR (NOT tx_data_tc(6))) OR tx_data_tc(5)) OR tx_data_tc(4)) OR tx_data_tc(3)) OR tx_data_tc(2)) OR (NOT tx_data_tc(1))) OR tx_data_tc(0)) OR wire_w_lg_w_n1l0O39w40w(0));
	n1l1l <= (((((((((wire_w_lg_tx_ctl_tc42w(0) OR wire_w_lg_w_tx_data_tc_range1w2w(0)) OR tx_data_tc(6)) OR (NOT tx_data_tc(5))) OR (NOT tx_data_tc(4))) OR (NOT tx_data_tc(3))) OR (NOT tx_data_tc(2))) OR tx_data_tc(1)) OR tx_data_tc(0)) OR wire_w_lg_w_n1l1O54w55w(0));
	n1lil <= ((((((((wire_w_lg_tx_ctl_tc3w(0) OR tx_data_tc(6)) OR (NOT tx_data_tc(5))) OR (NOT tx_data_tc(4))) OR tx_data_tc(3)) OR (NOT tx_data_tc(2))) OR tx_data_tc(1)) OR (NOT tx_data_tc(0))) OR wire_w_lg_w_n1lli24w25w(0));
	n1liO <= tx_clk;
	nlOlOl <= wire_ni0i_w_lg_dataout341w(0);
	nlOlOO <= wire_ni0i_w_lg_w_lg_dataout289w340w(0);
	nlOO0i <= (wire_niil_dataout AND (nlOOii OR (wire_niii_dataout AND nlOOlO)));
	nlOO0l <= (wire_n1i_dataout AND nlOOil);
	nlOO0O <= (wire_w_lg_nlOOil353w(0) OR wire_niil_w_lg_dataout358w(0));
	nlOO1i <= wire_ni0i_w_lg_w_lg_dataout289w290w(0);
	nlOO1l <= wire_ni0i_w_lg_dataout276w(0);
	nlOO1O <= (wire_niii_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_dataout283w362w364w366w368w369w(0) XOR (wire_w_lg_n10iO370w(0) AND wire_w_lg_nlOO0l376w(0)));
	nlOOii <= ((((wire_niii_w_lg_dataout283w(0) AND (wire_ni0O_dataout AND nlOlOl)) OR wire_niii_w_lg_dataout425w(0)) OR wire_niii_w_lg_dataout317w(0)) OR wire_niii_w_lg_dataout320w(0));
	nlOOil <= ((((((wire_niii_w_lg_dataout283w(0) AND (wire_ni0O_w_lg_dataout281w(0) AND wire_ni0i_w_lg_dataout341w(0))) OR (wire_niii_w_lg_dataout283w(0) AND (wire_ni0O_dataout AND nlOO1l))) OR (wire_niii_w_lg_dataout283w(0) AND (wire_ni0O_dataout AND nlOO1i))) OR wire_niii_w_lg_dataout403w(0)) OR wire_niii_w_lg_dataout406w(0)) OR wire_niii_w_lg_dataout409w(0));
	nlOOiO <= (nlOOll OR (wire_niil_dataout AND nlOOli));
	nlOOli <= (wire_niii_w_lg_dataout283w(0) OR wire_ni0O_w_lg_dataout350w(0));
	nlOOll <= (wire_niil_w_lg_dataout322w(0) AND nlOOlO);
	nlOOlO <= ((((wire_niii_w_lg_dataout283w(0) AND (wire_ni0O_w_lg_dataout281w(0) AND wire_ni0i_w_lg_dataout276w(0))) OR (wire_niii_w_lg_dataout283w(0) AND (wire_ni0O_w_lg_dataout281w(0) AND wire_ni0i_w_lg_w_lg_dataout289w290w(0)))) OR (wire_niii_w_lg_dataout283w(0) AND (wire_ni0O_dataout AND nlOlOO))) OR wire_niii_w_lg_dataout420w(0));
	nlOOOi <= (wire_niii_dataout AND wire_ni0O_w_lg_dataout361w(0));
	nlOOOl <= (wire_niii_w_lg_dataout283w(0) AND (wire_ni0O_w_lg_dataout281w(0) AND wire_ni0i_w_lg_w_lg_dataout289w340w(0)));
	nlOOOO <= (nlOOOi OR nlOOOl);
	PUDR <= ( wire_n11l_o & wire_n11i_o & wire_nlOOO_o & wire_nlOOl_o & wire_nlOOi_o & wire_nlOlO_o & wire_nlOll_o & wire_nlOli_o & wire_nlOiO_o & wire_nlOil_o);
	TXLP10B <= ( nlOii & n0ii & n00O & n00l & n00i & n01O & n01l & n01i & n1OO & n1Ol);
	w_n101l259w <= n101l45;
	w_n10ii136w <= n10ii42;
	w_n10ll111w <= n10ll39;
	w_n10Oi105w <= n10Oi36;
	w_n10OO100w <= n10OO33;
	w_n110l293w <= n110l57;
	w_n111O298w <= n111O60;
	w_n11ii287w <= n11ii54;
	w_n11iO279w <= n11iO51;
	w_n11OO266w <= n11OO48;
	w_n1i0l89w <= n1i0l27;
	w_n1i1O95w <= n1i1O30;
	w_n1iii85w <= n1iii24;
	w_n1iiO78w <= n1iiO21;
	w_n1ill73w <= n1ill18;
	w_n1iOi69w <= n1iOi15;
	w_n1iOO64w <= n1iOO12;
	w_n1l0O39w <= n1l0O6;
	w_n1l1O54w <= n1l1O9;
	w_n1lli24w <= n1lli3;
	wire_w_tx_data_tc_range1w(0) <= tx_data_tc(7);
	PROCESS (tx_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n00i <= '0';
		ELSIF (tx_clk = '1' AND tx_clk'event) THEN n00i <= wire_nlOOi_o;
		END IF;
	END PROCESS;
	PROCESS (tx_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n00l <= '0';
		ELSIF (tx_clk = '1' AND tx_clk'event) THEN n00l <= wire_nlOOl_o;
		END IF;
	END PROCESS;
	PROCESS (tx_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n00O <= '0';
		ELSIF (tx_clk = '1' AND tx_clk'event) THEN n00O <= wire_nlOOO_o;
		END IF;
	END PROCESS;
	PROCESS (tx_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n01i <= '0';
		ELSIF (tx_clk = '1' AND tx_clk'event) THEN n01i <= wire_nlOli_o;
		END IF;
	END PROCESS;
	PROCESS (tx_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n01l <= '0';
		ELSIF (tx_clk = '1' AND tx_clk'event) THEN n01l <= wire_nlOll_o;
		END IF;
	END PROCESS;
	PROCESS (tx_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n01O <= '0';
		ELSIF (tx_clk = '1' AND tx_clk'event) THEN n01O <= wire_nlOlO_o;
		END IF;
	END PROCESS;
	PROCESS (tx_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n0ii <= '0';
		ELSIF (tx_clk = '1' AND tx_clk'event) THEN n0ii <= wire_n11i_o;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n101l43 <= n101l44;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n101l44 <= n101l43;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n101l45 <= (n101l44 XOR n101l43);
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n10ii40 <= n10ii41;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n10ii41 <= n10ii40;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n10ii42 <= (n10ii41 XOR n10ii40);
		END IF;
	END PROCESS;
	PROCESS (tx_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n10l <= '0';
		ELSIF (tx_clk = '1' AND tx_clk'event) THEN n10l <= wire_nilOO_dataout;
		END IF;
	END PROCESS;
	wire_n10l_w_lg_Q57w(0) <= NOT n10l;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n10ll37 <= n10ll38;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n10ll38 <= n10ll37;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n10ll39 <= (n10ll38 XOR n10ll37);
		END IF;
	END PROCESS;
	PROCESS (tx_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n10O <= '0';
		ELSIF (tx_clk = '1' AND tx_clk'event) THEN 
			IF (wire_n10O_ENA = '1') THEN n10O <= '1';
			END IF;
		END IF;
	END PROCESS;
	wire_n10O_ENA <= (wire_n10O_w_lg_Q122w(0) AND (tx_data_9_tc AND IB_FORCE_DISPARITY));
	wire_n10O_w_lg_Q122w(0) <= NOT n10O;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n10Oi34 <= n10Oi35;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n10Oi35 <= n10Oi34;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n10Oi36 <= (n10Oi35 XOR n10Oi34);
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n10OO31 <= n10OO32;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n10OO32 <= n10OO31;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n10OO33 <= (n10OO32 XOR n10OO31);
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n110l55 <= n110l56;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n110l56 <= n110l55;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n110l57 <= (n110l56 XOR n110l55);
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n111O58 <= n111O59;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n111O59 <= n111O58;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n111O60 <= (n111O59 XOR n111O58);
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n11ii52 <= n11ii53;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n11ii53 <= n11ii52;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n11ii54 <= (n11ii53 XOR n11ii52);
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n11iO49 <= n11iO50;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n11iO50 <= n11iO49;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n11iO51 <= (n11iO50 XOR n11iO49);
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n11OO46 <= n11OO47;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n11OO47 <= n11OO46;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n11OO48 <= (n11OO47 XOR n11OO46);
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n1i0l25 <= n1i0l26;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n1i0l26 <= n1i0l25;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n1i0l27 <= (n1i0l26 XOR n1i0l25);
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n1i1O28 <= n1i1O29;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n1i1O29 <= n1i1O28;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n1i1O30 <= (n1i1O29 XOR n1i1O28);
		END IF;
	END PROCESS;
	PROCESS (tx_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n1ii <= '0';
		ELSIF (tx_clk = '1' AND tx_clk'event) THEN n1ii <= wire_w_lg_n1l1l127w(0);
		END IF;
	END PROCESS;
	wire_n1ii_w_lg_w_lg_Q108w112w(0) <= wire_n1ii_w_lg_Q108w(0) AND w_n10ll111w;
	wire_n1ii_w_lg_w_lg_Q61w65w(0) <= wire_n1ii_w_lg_Q61w(0) AND w_n1iOO64w;
	wire_n1ii_w_lg_Q108w(0) <= n1ii AND wire_w_lg_w_lg_tx_ctl_tc42w107w(0);
	wire_n1ii_w_lg_Q61w(0) <= n1ii AND wire_w_lg_w_lg_tx_ctl_tc42w60w(0);
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n1iii22 <= n1iii23;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n1iii23 <= n1iii22;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n1iii24 <= (n1iii23 XOR n1iii22);
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n1iiO19 <= n1iiO20;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n1iiO20 <= n1iiO19;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n1iiO21 <= (n1iiO20 XOR n1iiO19);
		END IF;
	END PROCESS;
	PROCESS (tx_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n1il <= '0';
		ELSIF (tx_clk = '1' AND tx_clk'event) THEN n1il <= wire_n0liO_dataout;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n1ill16 <= n1ill17;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n1ill17 <= n1ill16;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n1ill18 <= (n1ill17 XOR n1ill16);
		END IF;
	END PROCESS;
	PROCESS (tx_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n1iO <= '0';
		ELSIF (tx_clk = '1' AND tx_clk'event) THEN n1iO <= wire_n0lli_dataout;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n1iOi13 <= n1iOi14;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n1iOi14 <= n1iOi13;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n1iOi15 <= (n1iOi14 XOR n1iOi13);
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n1iOO10 <= n1iOO11;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n1iOO11 <= n1iOO10;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n1iOO12 <= (n1iOO11 XOR n1iOO10);
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n1l0O4 <= n1l0O5;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n1l0O5 <= n1l0O4;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n1l0O6 <= (n1l0O5 XOR n1l0O4);
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n1l1O7 <= n1l1O8;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n1l1O8 <= n1l1O7;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n1l1O9 <= (n1l1O8 XOR n1l1O7);
		END IF;
	END PROCESS;
	PROCESS (tx_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n1li <= '0';
		ELSIF (tx_clk = '1' AND tx_clk'event) THEN n1li <= wire_niOlO_dataout;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n1lli1 <= n1lli2;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n1lli2 <= n1lli1;
		END IF;
	END PROCESS;
	PROCESS (n1liO)
	BEGIN
		IF (n1liO = '1' AND n1liO'event) THEN n1lli3 <= (n1lli2 XOR n1lli1);
		END IF;
	END PROCESS;
	PROCESS (tx_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n1Oi <= '0';
		ELSIF (tx_clk = '1' AND tx_clk'event) THEN n1Oi <= wire_niOOl_dataout;
		END IF;
	END PROCESS;
	PROCESS (tx_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n1Ol <= '0';
		ELSIF (tx_clk = '1' AND tx_clk'event) THEN n1Ol <= wire_nlOil_o;
		END IF;
	END PROCESS;
	PROCESS (tx_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN n1OO <= '0';
		ELSIF (tx_clk = '1' AND tx_clk'event) THEN n1OO <= wire_nlOiO_o;
		END IF;
	END PROCESS;
	PROCESS (tx_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nlO0i <= '1';
		ELSIF (tx_clk = '1' AND tx_clk'event) THEN nlO0i <= wire_n0lOl_dataout;
		END IF;
	END PROCESS;
	PROCESS (tx_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nlO0l <= '1';
		ELSIF (tx_clk = '1' AND tx_clk'event) THEN nlO0l <= wire_niOll_dataout;
		END IF;
	END PROCESS;
	PROCESS (tx_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nlO0O <= '1';
		ELSIF (tx_clk = '1' AND tx_clk'event) THEN nlO0O <= wire_niOOi_dataout;
		END IF;
	END PROCESS;
	PROCESS (tx_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nlO1i <= '1';
		ELSIF (tx_clk = '1' AND tx_clk'event) THEN nlO1i <= wire_n0lll_dataout;
		END IF;
	END PROCESS;
	PROCESS (tx_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nlO1l <= '1';
		ELSIF (tx_clk = '1' AND tx_clk'event) THEN nlO1l <= wire_n0llO_dataout;
		END IF;
	END PROCESS;
	PROCESS (tx_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nlO1O <= '1';
		ELSIF (tx_clk = '1' AND tx_clk'event) THEN nlO1O <= wire_n0lOi_dataout;
		END IF;
	END PROCESS;
	PROCESS (tx_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN nlOii <= '0';
		ELSIF (tx_clk = '1' AND tx_clk'event) THEN nlOii <= wire_n11l_o;
		END IF;
	END PROCESS;
	wire_n0iiO_dataout <= wire_w_lg_n10iO370w(0) WHEN (nlOO0i OR (nlOOll OR (nlOOOi OR (nlOOOl OR wire_n1i_dataout)))) = '1'  ELSE n10iO;
	wire_n0iiO_w_lg_w_lg_w_lg_dataout253w256w260w(0) <= wire_n0iiO_w_lg_w_lg_dataout253w256w(0) AND w_n101l259w;
	wire_n0iiO_w_lg_w_lg_dataout253w256w(0) <= wire_n0iiO_w_lg_dataout253w(0) AND wire_w_lg_w_lg_n100i254w255w(0);
	wire_n0iiO_w_lg_dataout325w(0) <= wire_n0iiO_dataout AND wire_niii_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_dataout283w312w315w318w321w324w(0);
	wire_n0iiO_w_lg_dataout253w(0) <= NOT wire_n0iiO_dataout;
	wire_n0liO_dataout <= wire_ni0i_w_lg_dataout289w(0) WHEN nlOO1O = '1'  ELSE wire_ni0i_dataout;
	wire_n0ll_dataout <= tx_data_tc(0) WHEN INDV = '1'  ELSE tx_data_ts(0);
	wire_n0lli_dataout <= wire_ni01l_w_lg_dataout383w(0) WHEN nlOO1O = '1'  ELSE wire_ni01l_dataout;
	wire_n0lll_dataout <= wire_ni1ll_w_lg_dataout382w(0) WHEN nlOO1O = '1'  ELSE wire_ni1ll_dataout;
	wire_n0llO_dataout <= wire_ni1li_w_lg_dataout381w(0) WHEN nlOO1O = '1'  ELSE wire_ni1li_dataout;
	wire_n0lO_dataout <= tx_data_tc(1) WHEN INDV = '1'  ELSE tx_data_ts(1);
	wire_n0lOi_dataout <= wire_w_lg_nlOOiO380w(0) WHEN nlOO1O = '1'  ELSE nlOOiO;
	wire_n0lOl_dataout <= wire_w_lg_nlOO0O379w(0) WHEN nlOO1O = '1'  ELSE nlOO0O;
	wire_n0Oi_dataout <= tx_data_tc(2) WHEN INDV = '1'  ELSE tx_data_ts(2);
	wire_n0Ol_dataout <= tx_data_tc(3) WHEN INDV = '1'  ELSE tx_data_ts(3);
	wire_n0OO_dataout <= tx_data_tc(4) WHEN INDV = '1'  ELSE tx_data_ts(4);
	wire_n1i_dataout <= wire_n1l_dataout AND NOT(((n10l AND 
		(n1ii AND (wire_w_lg_tx_ctl_tc42w(0) AND wire_w_lg_w_lg_GE_XAUI_SEL75w79w(0)))) AND w_n1iii85w));
	wire_n1l_dataout <= wire_nlOO_dataout AND NOT(((wire_n10l_w_lg_Q57w(0) AND wire_n1ii_w_lg_w_lg_Q61w65w(0)) AND w_n1iOi69w));
	wire_ni01l_dataout <= wire_ni0l_w_lg_dataout275w(0) WHEN nlOOOO = '1'  ELSE wire_ni0l_dataout;
	wire_ni01l_w_lg_dataout383w(0) <= NOT wire_ni01l_dataout;
	wire_ni0i_dataout <= wire_nilO_dataout AND NOT(n1i1l);
	wire_ni0i_w_lg_w_lg_w_lg_w_lg_w_lg_dataout276w280w282w284w288w(0) <= wire_ni0i_w_lg_w_lg_w_lg_w_lg_dataout276w280w282w284w(0) AND w_n11ii287w;
	wire_ni0i_w_lg_w_lg_w_lg_w_lg_dataout276w280w282w284w(0) <= wire_ni0i_w_lg_w_lg_w_lg_dataout276w280w282w(0) AND wire_niii_w_lg_dataout283w(0);
	wire_ni0i_w_lg_w_lg_w_lg_dataout276w280w282w(0) <= wire_ni0i_w_lg_w_lg_dataout276w280w(0) AND wire_ni0O_w_lg_dataout281w(0);
	wire_ni0i_w_lg_w_lg_w_lg_dataout289w290w294w(0) <= wire_ni0i_w_lg_w_lg_dataout289w290w(0) AND w_n110l293w;
	wire_ni0i_w_lg_w_lg_dataout276w280w(0) <= wire_ni0i_w_lg_dataout276w(0) AND w_n11iO279w;
	wire_ni0i_w_lg_w_lg_dataout289w340w(0) <= wire_ni0i_w_lg_dataout289w(0) AND wire_ni0l_w_lg_dataout275w(0);
	wire_ni0i_w_lg_w_lg_dataout289w290w(0) <= wire_ni0i_w_lg_dataout289w(0) AND wire_ni0l_dataout;
	wire_ni0i_w_lg_dataout276w(0) <= wire_ni0i_dataout AND wire_ni0l_w_lg_dataout275w(0);
	wire_ni0i_w_lg_dataout341w(0) <= wire_ni0i_dataout AND wire_ni0l_dataout;
	wire_ni0i_w_lg_dataout289w(0) <= NOT wire_ni0i_dataout;
	wire_ni0i_w_lg_dataout349w(0) <= wire_ni0i_dataout OR wire_ni0l_dataout;
	wire_ni0l_dataout <= wire_niOi_dataout AND NOT(n1i1l);
	wire_ni0l_w_lg_dataout275w(0) <= NOT wire_ni0l_dataout;
	wire_ni0O_dataout <= wire_niOl_dataout AND NOT(n1i1l);
	wire_ni0O_w_lg_w_lg_w_lg_dataout281w295w299w(0) <= wire_ni0O_w_lg_w_lg_dataout281w295w(0) AND w_n111O298w;
	wire_ni0O_w_lg_w_lg_dataout281w295w(0) <= wire_ni0O_w_lg_dataout281w(0) AND wire_ni0i_w_lg_w_lg_w_lg_dataout289w290w294w(0);
	wire_ni0O_w_lg_w_lg_dataout281w313w(0) <= wire_ni0O_w_lg_dataout281w(0) AND n111i;
	wire_ni0O_w_lg_w_lg_dataout281w305w(0) <= wire_ni0O_w_lg_dataout281w(0) AND n111l;
	wire_ni0O_w_lg_w_lg_dataout281w424w(0) <= wire_ni0O_w_lg_dataout281w(0) AND nlOlOl;
	wire_ni0O_w_lg_w_lg_dataout281w419w(0) <= wire_ni0O_w_lg_dataout281w(0) AND nlOlOO;
	wire_ni0O_w_lg_w_lg_dataout281w405w(0) <= wire_ni0O_w_lg_dataout281w(0) AND nlOO1i;
	wire_ni0O_w_lg_w_lg_dataout281w402w(0) <= wire_ni0O_w_lg_dataout281w(0) AND nlOO1l;
	wire_ni0O_w_lg_dataout408w(0) <= wire_ni0O_dataout AND wire_ni0i_w_lg_w_lg_dataout289w340w(0);
	wire_ni0O_w_lg_dataout319w(0) <= wire_ni0O_dataout AND wire_ni0i_w_lg_w_lg_dataout289w290w(0);
	wire_ni0O_w_lg_dataout316w(0) <= wire_ni0O_dataout AND wire_ni0i_w_lg_dataout276w(0);
	wire_ni0O_w_lg_dataout361w(0) <= wire_ni0O_dataout AND wire_ni0i_w_lg_dataout341w(0);
	wire_ni0O_w_lg_dataout311w(0) <= wire_ni0O_dataout AND n111i;
	wire_ni0O_w_lg_dataout281w(0) <= NOT wire_ni0O_dataout;
	wire_ni0O_w_lg_dataout350w(0) <= wire_ni0O_dataout OR wire_ni0i_w_lg_dataout349w(0);
	wire_ni1i_dataout <= tx_data_tc(5) WHEN INDV = '1'  ELSE tx_data_ts(5);
	wire_ni1l_dataout <= tx_data_tc(6) WHEN INDV = '1'  ELSE tx_data_ts(6);
	wire_ni1li_dataout <= wire_niii_w_lg_dataout283w(0) WHEN nlOOOi = '1'  ELSE wire_niii_dataout;
	wire_ni1li_w_lg_dataout381w(0) <= NOT wire_ni1li_dataout;
	wire_ni1ll_dataout <= wire_ni0O_w_lg_dataout281w(0) WHEN (nlOOOl OR (wire_niil_dataout AND (wire_niii_dataout AND (wire_ni0O_w_lg_dataout281w(0) AND wire_ni0i_w_lg_w_lg_dataout289w340w(0))))) = '1'  ELSE wire_ni0O_dataout;
	wire_ni1ll_w_lg_dataout382w(0) <= NOT wire_ni1ll_dataout;
	wire_ni1O_dataout <= tx_data_tc(7) WHEN INDV = '1'  ELSE tx_data_ts(7);
	wire_niii_dataout <= wire_niOO_dataout AND NOT(n1i1l);
	wire_niii_w_lg_w_lg_dataout283w362w(0) <= wire_niii_w_lg_dataout283w(0) AND wire_ni0O_w_lg_dataout361w(0);
	wire_niii_w_lg_w_lg_dataout283w312w(0) <= wire_niii_w_lg_dataout283w(0) AND wire_ni0O_w_lg_dataout311w(0);
	wire_niii_w_lg_w_lg_dataout283w308w(0) <= wire_niii_w_lg_dataout283w(0) AND wire_niil_dataout;
	wire_niii_w_lg_w_lg_dataout283w371w(0) <= wire_niii_w_lg_dataout283w(0) AND nlOOii;
	wire_niii_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_dataout283w312w315w318w321w324w(0) <= wire_niii_w_lg_w_lg_w_lg_w_lg_w_lg_dataout283w312w315w318w321w(0) AND wire_niii_w_lg_dataout323w(0);
	wire_niii_w_lg_dataout314w(0) <= wire_niii_dataout AND wire_ni0O_w_lg_w_lg_dataout281w313w(0);
	wire_niii_w_lg_dataout306w(0) <= wire_niii_dataout AND wire_ni0O_w_lg_w_lg_dataout281w305w(0);
	wire_niii_w_lg_dataout425w(0) <= wire_niii_dataout AND wire_ni0O_w_lg_w_lg_dataout281w424w(0);
	wire_niii_w_lg_dataout420w(0) <= wire_niii_dataout AND wire_ni0O_w_lg_w_lg_dataout281w419w(0);
	wire_niii_w_lg_dataout406w(0) <= wire_niii_dataout AND wire_ni0O_w_lg_w_lg_dataout281w405w(0);
	wire_niii_w_lg_dataout403w(0) <= wire_niii_dataout AND wire_ni0O_w_lg_w_lg_dataout281w402w(0);
	wire_niii_w_lg_dataout409w(0) <= wire_niii_dataout AND wire_ni0O_w_lg_dataout408w(0);
	wire_niii_w_lg_dataout320w(0) <= wire_niii_dataout AND wire_ni0O_w_lg_dataout319w(0);
	wire_niii_w_lg_dataout317w(0) <= wire_niii_dataout AND wire_ni0O_w_lg_dataout316w(0);
	wire_niii_w_lg_dataout323w(0) <= wire_niii_dataout AND wire_niil_w_lg_dataout322w(0);
	wire_niii_w_lg_dataout283w(0) <= NOT wire_niii_dataout;
	wire_niii_w_lg_w_lg_w_lg_dataout283w362w364w(0) <= wire_niii_w_lg_w_lg_dataout283w362w(0) OR wire_niil_w_lg_dataout363w(0);
	wire_niii_w_lg_w_lg_w_lg_dataout283w312w315w(0) <= wire_niii_w_lg_w_lg_dataout283w312w(0) OR wire_niii_w_lg_dataout314w(0);
	wire_niii_w_lg_w_lg_w_lg_w_lg_dataout283w362w364w366w(0) <= wire_niii_w_lg_w_lg_w_lg_dataout283w362w364w(0) OR wire_niil_w_lg_dataout365w(0);
	wire_niii_w_lg_w_lg_w_lg_w_lg_dataout283w312w315w318w(0) <= wire_niii_w_lg_w_lg_w_lg_dataout283w312w315w(0) OR wire_niii_w_lg_dataout317w(0);
	wire_niii_w_lg_w_lg_w_lg_w_lg_w_lg_dataout283w362w364w366w368w(0) <= wire_niii_w_lg_w_lg_w_lg_w_lg_dataout283w362w364w366w(0) OR wire_niil_w_lg_dataout367w(0);
	wire_niii_w_lg_w_lg_w_lg_w_lg_w_lg_dataout283w312w315w318w321w(0) <= wire_niii_w_lg_w_lg_w_lg_w_lg_dataout283w312w315w318w(0) OR wire_niii_w_lg_dataout320w(0);
	wire_niii_w_lg_w_lg_w_lg_w_lg_w_lg_w_lg_dataout283w362w364w366w368w369w(0) <= wire_niii_w_lg_w_lg_w_lg_w_lg_w_lg_dataout283w362w364w366w368w(0) OR nlOO0l;
	wire_niil_dataout <= wire_nl1i_dataout OR n1i1l;
	wire_niil_w_lg_w_lg_dataout322w373w(0) <= wire_niil_w_lg_dataout322w(0) AND wire_w_lg_nlOOlO372w(0);
	wire_niil_w_lg_dataout358w(0) <= wire_niil_dataout AND wire_w_lg_w_lg_w_lg_nlOOii354w356w357w(0);
	wire_niil_w_lg_dataout367w(0) <= wire_niil_dataout AND nlOOii;
	wire_niil_w_lg_dataout365w(0) <= wire_niil_dataout AND nlOOOi;
	wire_niil_w_lg_dataout363w(0) <= wire_niil_dataout AND nlOOOl;
	wire_niil_w_lg_dataout322w(0) <= NOT wire_niil_dataout;
	wire_niil_w_lg_w_lg_dataout322w352w(0) <= wire_niil_w_lg_dataout322w(0) OR wire_n1i_dataout;
	wire_niiO_dataout <= wire_nl1l_dataout AND NOT(n1i1l);
	wire_niiO_w_lg_dataout327w(0) <= wire_niiO_dataout AND wire_n1i_dataout;
	wire_niiO_w_lg_dataout337w(0) <= NOT wire_niiO_dataout;
	wire_nili_dataout <= wire_nl1O_dataout OR n1i1l;
	wire_nili_w_lg_dataout328w(0) <= wire_nili_dataout AND wire_niiO_w_lg_dataout327w(0);
	wire_nili_w_lg_dataout274w(0) <= NOT wire_nili_dataout;
	wire_nill_dataout <= wire_nl0i_dataout AND NOT(n1i1l);
	wire_nill_w_lg_dataout329w(0) <= wire_nill_dataout AND wire_nili_w_lg_dataout328w(0);
	wire_nill_w_lg_dataout270w(0) <= NOT wire_nill_dataout;
	wire_nilO_dataout <= wire_n0ll_dataout OR n10li;
	wire_nilOO_dataout <= wire_n0iiO_w_lg_dataout253w(0) WHEN (n11ll OR (n100i AND wire_nill_dataout)) = '1'  ELSE wire_n0iiO_dataout;
	wire_niO0i_dataout <= wire_w_lg_n100i254w(0) AND NOT(wire_nill_dataout);
	wire_niO1O_dataout <= wire_niO0i_dataout OR n11Oi;
	wire_niO1O_w_lg_dataout269w(0) <= NOT wire_niO1O_dataout;
	wire_niOi_dataout <= wire_n0lO_dataout AND NOT(n10li);
	wire_niOil_dataout <= wire_nili_w_lg_dataout274w(0) WHEN n11ll = '1'  ELSE wire_nili_dataout;
	wire_niOil_w_lg_dataout271w(0) <= NOT wire_niOil_dataout;
	wire_niOl_dataout <= wire_n0Oi_dataout OR n10li;
	wire_niOli_dataout <= wire_niiO_dataout AND NOT(n11Oi);
	wire_niOli_w_lg_dataout272w(0) <= NOT wire_niOli_dataout;
	wire_niOll_dataout <= wire_niOli_w_lg_dataout272w(0) WHEN n11Ol = '1'  ELSE wire_niOli_dataout;
	wire_niOlO_dataout <= wire_niOil_w_lg_dataout271w(0) WHEN n11Ol = '1'  ELSE wire_niOil_dataout;
	wire_niOO_dataout <= wire_n0Ol_dataout AND NOT(n10li);
	wire_niOOi_dataout <= wire_nill_w_lg_dataout270w(0) WHEN n11Ol = '1'  ELSE wire_nill_dataout;
	wire_niOOl_dataout <= wire_niO1O_w_lg_dataout269w(0) WHEN n11Ol = '1'  ELSE wire_niO1O_dataout;
	wire_nl0i_dataout <= wire_ni1O_dataout OR n10li;
	wire_nl1i_dataout <= wire_n0OO_dataout AND NOT(n10li);
	wire_nl1l_dataout <= wire_ni1i_dataout AND NOT(n10li);
	wire_nl1O_dataout <= wire_ni1l_dataout OR n10li;
	wire_nlOO_dataout <= tx_ctl_tc WHEN INDV = '1'  ELSE tx_ctl_ts;
	wire_n10i_i <= ( ENDEC & prbs_en);
	n10i :  oper_decoder
	  GENERIC MAP (
		width_i => 2,
		width_o => 4
	  )
	  PORT MAP ( 
		i => wire_n10i_i,
		o => wire_n10i_o
	  );
	wire_n11i_data <= ( tx_data_pg(8) & nlO0O & tx_ctl_tc);
	wire_n11i_sel <= ( n100O & wire_n10i_o(2) & wire_n10i_o(0));
	n11i :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n11i_data,
		o => wire_n11i_o,
		sel => wire_n11i_sel
	  );
	wire_n11l_data <= ( tx_data_pg(9) & n1Oi & tx_data_9_tc);
	wire_n11l_sel <= ( n100O & wire_n10i_o(2) & wire_n10i_o(0));
	n11l :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n11l_data,
		o => wire_n11l_o,
		sel => wire_n11l_sel
	  );
	wire_nlOil_data <= ( tx_data_pg(0) & n1il & tx_data_tc(0));
	wire_nlOil_sel <= ( n100O & wire_n10i_o(2) & wire_n10i_o(0));
	nlOil :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlOil_data,
		o => wire_nlOil_o,
		sel => wire_nlOil_sel
	  );
	wire_nlOiO_data <= ( tx_data_pg(1) & n1iO & tx_data_tc(1));
	wire_nlOiO_sel <= ( n100O & wire_n10i_o(2) & wire_n10i_o(0));
	nlOiO :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlOiO_data,
		o => wire_nlOiO_o,
		sel => wire_nlOiO_sel
	  );
	wire_nlOli_data <= ( tx_data_pg(2) & nlO1i & tx_data_tc(2));
	wire_nlOli_sel <= ( n100O & wire_n10i_o(2) & wire_n10i_o(0));
	nlOli :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlOli_data,
		o => wire_nlOli_o,
		sel => wire_nlOli_sel
	  );
	wire_nlOll_data <= ( tx_data_pg(3) & nlO1l & tx_data_tc(3));
	wire_nlOll_sel <= ( n100O & wire_n10i_o(2) & wire_n10i_o(0));
	nlOll :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlOll_data,
		o => wire_nlOll_o,
		sel => wire_nlOll_sel
	  );
	wire_nlOlO_data <= ( tx_data_pg(4) & nlO1O & tx_data_tc(4));
	wire_nlOlO_sel <= ( n100O & wire_n10i_o(2) & wire_n10i_o(0));
	nlOlO :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlOlO_data,
		o => wire_nlOlO_o,
		sel => wire_nlOlO_sel
	  );
	wire_nlOOi_data <= ( tx_data_pg(5) & nlO0i & tx_data_tc(5));
	wire_nlOOi_sel <= ( n100O & wire_n10i_o(2)
		 & wire_n10i_o(0));
	nlOOi :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlOOi_data,
		o => wire_nlOOi_o,
		sel => wire_nlOOi_sel
	  );
	wire_nlOOl_data <= ( tx_data_pg(6) & nlO0l & tx_data_tc(6));
	wire_nlOOl_sel <= ( n100O & wire_n10i_o(2) & wire_n10i_o(0));
	nlOOl :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlOOl_data,
		o => wire_nlOOl_o,
		sel => wire_nlOOl_sel
	  );
	wire_nlOOO_data <= ( tx_data_pg(7) & n1li & tx_data_tc(7));
	wire_nlOOO_sel <= ( n100O & wire_n10i_o(2) & wire_n10i_o(0));
	nlOOO :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlOOO_data,
		o => wire_nlOOO_o,
		sel => wire_nlOOO_sel
	  );

 END RTL; --stratixgx_hssi_tx_enc_rtl
--synopsys translate_on
--VALID FILE
--/////////////////////////////////////////////////////////////////////////////
--
--                           STRATIXGX_8b10b_ENCODER
--
--/////////////////////////////////////////////////////////////////////////////

library IEEE, stratixgx_gxb;
use IEEE.std_logic_1164.all;

ENTITY stratixgx_8b10b_encoder IS
    GENERIC (
        transmit_protocol              :  string := "none";    
        use_8b_10b_mode                :  string := "true";    
        force_disparity_mode           :  string := "false");    
    PORT (
        clk                     : IN std_logic;   
        reset                   : IN std_logic;   
        xgmctrl                 : IN std_logic;   
        kin                     : IN std_logic;   
        xgmdatain               : IN std_logic_vector(7 DOWNTO 0);   
        datain                  : IN std_logic_vector(7 DOWNTO 0);   
        forcedisparity          : IN std_logic;   
        dataout                 : OUT std_logic_vector(9 DOWNTO 0);   
        parafbkdataout          : OUT std_logic_vector(9 DOWNTO 0));   
END stratixgx_8b10b_encoder;

ARCHITECTURE auto_translated OF stratixgx_8b10b_encoder IS

    COMPONENT stratixgx_hssi_tx_enc_rtl
        PORT (
            tx_clk                  : IN  std_logic;
            soft_reset              : IN  std_logic;
            INDV                    : IN  std_logic;
            ENDEC                   : IN  std_logic;
            GE_XAUI_SEL             : IN  std_logic;
            IB_FORCE_DISPARITY      : IN  std_logic;
            prbs_en                 : IN  std_logic;
            tx_ctl_ts               : IN  std_logic;
            tx_ctl_tc               : IN  std_logic;
            tx_data_ts              : IN  std_logic_vector(7 DOWNTO 0);
            tx_data_tc              : IN  std_logic_vector(7 DOWNTO 0);
            tx_data_9_tc            : IN  std_logic;
            tx_data_pg              : IN  std_logic_vector(9 DOWNTO 0);
            PUDR                    : OUT std_logic_vector(9 DOWNTO 0);
            TXLP10B                 : OUT std_logic_vector(9 DOWNTO 0));
    END COMPONENT;


    -- CORE MODULE INPUTs
    SIGNAL tx_clk                   :  std_logic;   
    SIGNAL soft_reset               :  std_logic;   
    SIGNAL INDV                     :  std_logic;   
    SIGNAL ENDEC                    :  std_logic;   
    SIGNAL GE_XAUI_SEL              :  std_logic;   
    SIGNAL IB_FORCE_DISPARITY       :  std_logic;   
    SIGNAL prbs_en                  :  std_logic;   
    SIGNAL tx_ctl_ts                :  std_logic;   
    SIGNAL tx_ctl_tc                :  std_logic;   
    SIGNAL tx_data_ts               :  std_logic_vector(7 DOWNTO 0);   
    SIGNAL tx_data_tc               :  std_logic_vector(7 DOWNTO 0);   
    SIGNAL tx_data_9_tc             :  std_logic;   
    SIGNAL tx_data_pg               :  std_logic_vector(9 DOWNTO 0);   
    -- CORE MODULE OUTPUTs
    SIGNAL TXLP10B                  :  std_logic_vector(9 DOWNTO 0);   
    SIGNAL PUDR                     :  std_logic_vector(9 DOWNTO 0);   
    SIGNAL temp_xhdl3               :  std_logic;   
    SIGNAL temp_xhdl4               :  std_logic;   
    SIGNAL temp_xhdl5               :  std_logic;   
    SIGNAL temp_xhdl6               :  std_logic;   
    SIGNAL dataout_xhdl1            :  std_logic_vector(9 DOWNTO 0);   
    SIGNAL parafbkdataout_xhdl2     :  std_logic_vector(9 DOWNTO 0);   

BEGIN
    dataout <= dataout_xhdl1;
    parafbkdataout <= parafbkdataout_xhdl2;
    tx_clk <= clk ;
    soft_reset <= reset ;
    temp_xhdl3 <= '1' WHEN (transmit_protocol /= "xaui") ELSE '0';
    INDV <= temp_xhdl3 ;
    temp_xhdl4 <= '1' WHEN (use_8b_10b_mode = "true") ELSE '0';
    ENDEC <= temp_xhdl4 ;
    temp_xhdl5 <= '1' WHEN (transmit_protocol = "gige") ELSE '0';
    GE_XAUI_SEL <= temp_xhdl5 ;
    temp_xhdl6 <= '1' WHEN (force_disparity_mode = "true") ELSE '0';
    IB_FORCE_DISPARITY <= temp_xhdl6 ;
    prbs_en <= '0' ;
    tx_ctl_ts <= xgmctrl ;
    tx_ctl_tc <= kin ;
    tx_data_ts <= xgmdatain ;
    tx_data_tc <= datain ;
    tx_data_9_tc <= forcedisparity ;
    tx_data_pg <= "0000000000" ;
    dataout_xhdl1 <= PUDR ;
    parafbkdataout_xhdl2 <= TXLP10B ;
    m_enc_core : stratixgx_hssi_tx_enc_rtl 
        PORT MAP (
            tx_clk => tx_clk,
            soft_reset => soft_reset,
            INDV => INDV,
            ENDEC => ENDEC,
            GE_XAUI_SEL => GE_XAUI_SEL,
            IB_FORCE_DISPARITY => IB_FORCE_DISPARITY,
            prbs_en => prbs_en,
            tx_ctl_ts => tx_ctl_ts,
            tx_ctl_tc => tx_ctl_tc,
            tx_data_ts => tx_data_ts,
            tx_data_tc => tx_data_tc,
            tx_data_9_tc => tx_data_9_tc,
            tx_data_pg => tx_data_pg,
            PUDR => PUDR,
            TXLP10B => TXLP10B);   
    

END auto_translated;
--/////////////////////////////////////////////////////////////////////////////
--
--                            DESKEW FIFO RAM MODULE
--
--/////////////////////////////////////////////////////////////////////////////

library IEEE, stratixgx_gxb, std;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
USE ieee.std_logic_arith.all; 

ENTITY deskew_ram_block IS
   PORT (
      clk                     : IN std_logic;   
      reset                   : IN std_logic;   
      addrwr                  : IN std_logic_vector(15 DOWNTO 0);   
      addrrd1                 : IN std_logic_vector(15 DOWNTO 0);   
      addrrd2                 : IN std_logic_vector(15 DOWNTO 0);   
      datain                  : IN std_logic_vector(13 DOWNTO 0);   
      we                      : IN std_logic;   
      re                      : IN std_logic;   
      dataout1                : OUT std_logic_vector(13 DOWNTO 0);   
      dataout2                : OUT std_logic_vector(13 DOWNTO 0));   
END deskew_ram_block;

ARCHITECTURE arch_deskew_ram_block OF deskew_ram_block IS

   CONSTANT  read_access_time      :  integer := 0;    
   CONSTANT  write_access_time     :  integer := 0;    
   CONSTANT  ram_width             :  integer := 14;    
   SIGNAL dataout1_i               :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL dataout2_i               :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_d_0            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_d_1            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_d_2            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_d_3            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_d_4            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_d_5            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_d_6            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_d_7            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_d_8            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_d_9            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_d_10           :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_d_11           :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_d_12           :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_d_13           :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_d_14           :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_d_15           :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_q_0            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_q_1            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_q_2            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_q_3            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_q_4            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_q_5            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_q_6            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_q_7            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_q_8            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_q_9            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_q_10           :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_q_11           :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_q_12           :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_q_13           :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_q_14           :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_q_15           :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL data_reg_0               :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL data_reg_1               :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL data_reg_2               :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL data_reg_3               :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL data_reg_4               :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL data_reg_5               :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL data_reg_6               :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL data_reg_7               :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL data_reg_8               :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL data_reg_9               :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL data_reg_10              :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL data_reg_11              :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL data_reg_12              :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL data_reg_13              :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL data_reg_14              :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL data_reg_15              :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL dataout1_tmp1           :  std_logic_vector(13 DOWNTO 0);   
   SIGNAL dataout2_tmp2           :  std_logic_vector(13 DOWNTO 0);   

BEGIN
   dataout1 <= dataout1_tmp1;
   dataout2 <= dataout2_tmp2;
   data_reg_0 <= datain WHEN (addrwr(0) = '1') ELSE ram_array_q_0 ;
   data_reg_1 <= datain WHEN (addrwr(1) = '1') ELSE ram_array_q_1 ;
   data_reg_2 <= datain WHEN (addrwr(2) = '1') ELSE ram_array_q_2 ;
   data_reg_3 <= datain WHEN (addrwr(3) = '1') ELSE ram_array_q_3 ;
   data_reg_4 <= datain WHEN (addrwr(4) = '1') ELSE ram_array_q_4 ;
   data_reg_5 <= datain WHEN (addrwr(5) = '1') ELSE ram_array_q_5 ;
   data_reg_6 <= datain WHEN (addrwr(6) = '1') ELSE ram_array_q_6 ;
   data_reg_7 <= datain WHEN (addrwr(7) = '1') ELSE ram_array_q_7 ;
   data_reg_8 <= datain WHEN (addrwr(8) = '1') ELSE ram_array_q_8 ;
   data_reg_9 <= datain WHEN (addrwr(9) = '1') ELSE ram_array_q_9 ;
   data_reg_10 <= datain WHEN (addrwr(10) = '1') ELSE ram_array_q_10 ;
   data_reg_11 <= datain WHEN (addrwr(11) = '1') ELSE ram_array_q_11 ;
   data_reg_12 <= datain WHEN (addrwr(12) = '1') ELSE ram_array_q_12 ;
   data_reg_13 <= datain WHEN (addrwr(13) = '1') ELSE ram_array_q_13 ;
   data_reg_14 <= datain WHEN (addrwr(14) = '1') ELSE ram_array_q_14 ;
   data_reg_15 <= datain WHEN (addrwr(15) = '1') ELSE ram_array_q_15 ;
   dataout1_tmp1 <= "00000000000000" WHEN re = '1' ELSE dataout1_i after 0 ns;
   dataout2_tmp2 <= "00000000000000" WHEN re = '1' ELSE dataout2_i after 0 ns;

   PROCESS (ram_array_q_0, ram_array_q_1, ram_array_q_2, ram_array_q_3, ram_array_q_4, ram_array_q_5, ram_array_q_6, ram_array_q_7, ram_array_q_8, ram_array_q_9, ram_array_q_10, ram_array_q_11, ram_array_q_12, ram_array_q_13, ram_array_q_14, ram_array_q_15, addrrd1, addrrd2)
      VARIABLE dataout1_i_tmp3  : std_logic_vector(ram_width - 1 DOWNTO 0);
      VARIABLE dataout2_i_tmp4  : std_logic_vector(ram_width - 1 DOWNTO 0);
   BEGIN
      CASE addrrd1 IS
         WHEN "0000000000000001" =>
                  dataout1_i_tmp3 := ram_array_q_0;    
         WHEN "0000000000000010" =>
                  dataout1_i_tmp3 := ram_array_q_1;    
         WHEN "0000000000000100" =>
                  dataout1_i_tmp3 := ram_array_q_2;    
         WHEN "0000000000001000" =>
                  dataout1_i_tmp3 := ram_array_q_3;    
         WHEN "0000000000010000" =>
                  dataout1_i_tmp3 := ram_array_q_4;    
         WHEN "0000000000100000" =>
                  dataout1_i_tmp3 := ram_array_q_5;    
         WHEN "0000000001000000" =>
                  dataout1_i_tmp3 := ram_array_q_6;    
         WHEN "0000000010000000" =>
                  dataout1_i_tmp3 := ram_array_q_7;    
         WHEN "0000000100000000" =>
                  dataout1_i_tmp3 := ram_array_q_8;    
         WHEN "0000001000000000" =>
                  dataout1_i_tmp3 := ram_array_q_9;    
         WHEN "0000010000000000" =>
                  dataout1_i_tmp3 := ram_array_q_10;    
         WHEN "0000100000000000" =>
                  dataout1_i_tmp3 := ram_array_q_11;    
         WHEN "0001000000000000" =>
                  dataout1_i_tmp3 := ram_array_q_12;    
         WHEN "0010000000000000" =>
                  dataout1_i_tmp3 := ram_array_q_13;    
         WHEN "0100000000000000" =>
                  dataout1_i_tmp3 := ram_array_q_14;    
         WHEN "1000000000000000" =>
                  dataout1_i_tmp3 := ram_array_q_15;    
         WHEN OTHERS =>
                  NULL;
         
      END CASE;
      CASE addrrd2 IS
         WHEN "0000000000000001" =>
                  dataout2_i_tmp4 := ram_array_q_0;    
         WHEN "0000000000000010" =>
                  dataout2_i_tmp4 := ram_array_q_1;    
         WHEN "0000000000000100" =>
                  dataout2_i_tmp4 := ram_array_q_2;    
         WHEN "0000000000001000" =>
                  dataout2_i_tmp4 := ram_array_q_3;    
         WHEN "0000000000010000" =>
                  dataout2_i_tmp4 := ram_array_q_4;    
         WHEN "0000000000100000" =>
                  dataout2_i_tmp4 := ram_array_q_5;    
         WHEN "0000000001000000" =>
                  dataout2_i_tmp4 := ram_array_q_6;    
         WHEN "0000000010000000" =>
                  dataout2_i_tmp4 := ram_array_q_7;    
         WHEN "0000000100000000" =>
                  dataout2_i_tmp4 := ram_array_q_8;    
         WHEN "0000001000000000" =>
                  dataout2_i_tmp4 := ram_array_q_9;    
         WHEN "0000010000000000" =>
                  dataout2_i_tmp4 := ram_array_q_10;    
         WHEN "0000100000000000" =>
                  dataout2_i_tmp4 := ram_array_q_11;    
         WHEN "0001000000000000" =>
                  dataout2_i_tmp4 := ram_array_q_12;    
         WHEN "0010000000000000" =>
                  dataout2_i_tmp4 := ram_array_q_13;    
         WHEN "0100000000000000" =>
                  dataout2_i_tmp4 := ram_array_q_14;    
         WHEN "1000000000000000" =>
                  dataout2_i_tmp4 := ram_array_q_15;    
         WHEN OTHERS =>
                  NULL;
         
      END CASE;
      dataout1_i <= dataout1_i_tmp3;
      dataout2_i <= dataout2_i_tmp4;
   END PROCESS;

   PROCESS (clk, reset)
   BEGIN
      IF (reset = '1') THEN
         ram_array_q_0 <= "00000000000000" AFTER 0 ns;    
         ram_array_q_1 <= "00000000000000" AFTER 0 ns;    
         ram_array_q_2 <= "00000000000000" AFTER 0 ns;    
         ram_array_q_3 <= "00000000000000" AFTER 0 ns;    
         ram_array_q_4 <= "00000000000000" AFTER 0 ns;    
         ram_array_q_5 <= "00000000000000" AFTER 0 ns;    
         ram_array_q_6 <= "00000000000000" AFTER 0 ns;    
         ram_array_q_7 <= "00000000000000" AFTER 0 ns;    
         ram_array_q_8 <= "00000000000000" AFTER 0 ns;    
         ram_array_q_9 <= "00000000000000" AFTER 0 ns;    
         ram_array_q_10 <= "00000000000000" AFTER 0 ns;    
         ram_array_q_11 <= "00000000000000" AFTER 0 ns;    
         ram_array_q_12 <= "00000000000000" AFTER 0 ns;    
         ram_array_q_13 <= "00000000000000" AFTER 0 ns;    
         ram_array_q_14 <= "00000000000000" AFTER 0 ns;    
         ram_array_q_15 <= "00000000000000" AFTER 0 ns;    
      ELSIF (clk'EVENT AND clk = '1') THEN
         ram_array_q_0 <= ram_array_d_0 AFTER 0 ns;    
         ram_array_q_1 <= ram_array_d_1 AFTER 0 ns;    
         ram_array_q_2 <= ram_array_d_2 AFTER 0 ns;    
         ram_array_q_3 <= ram_array_d_3 AFTER 0 ns;    
         ram_array_q_4 <= ram_array_d_4 AFTER 0 ns;    
         ram_array_q_5 <= ram_array_d_5 AFTER 0 ns;    
         ram_array_q_6 <= ram_array_d_6 AFTER 0 ns;    
         ram_array_q_7 <= ram_array_d_7 AFTER 0 ns;    
         ram_array_q_8 <= ram_array_d_8 AFTER 0 ns;    
         ram_array_q_9 <= ram_array_d_9 AFTER 0 ns;    
         ram_array_q_10 <= ram_array_d_10 AFTER 0 ns;    
         ram_array_q_11 <= ram_array_d_11 AFTER 0 ns;    
         ram_array_q_12 <= ram_array_d_12 AFTER 0 ns;    
         ram_array_q_13 <= ram_array_d_13 AFTER 0 ns;    
         ram_array_q_14 <= ram_array_d_14 AFTER 0 ns;    
         ram_array_q_15 <= ram_array_d_15 AFTER 0 ns;    
      END IF;
   END PROCESS;

   PROCESS (we, data_reg_0, data_reg_1, data_reg_2, data_reg_3, data_reg_4, data_reg_5, data_reg_6, data_reg_7, data_reg_8, data_reg_9, data_reg_10, data_reg_11, data_reg_12, data_reg_13, data_reg_14, data_reg_15, ram_array_q_0, ram_array_q_1, ram_array_q_2, ram_array_q_3, ram_array_q_4, ram_array_q_5, ram_array_q_6, ram_array_q_7, ram_array_q_8, ram_array_q_9, ram_array_q_10, ram_array_q_11, ram_array_q_12, ram_array_q_13, ram_array_q_14, ram_array_q_15)
   BEGIN
      IF (we = '1') THEN
         ram_array_d_0 <= data_reg_0 AFTER 0 ns;    
         ram_array_d_1 <= data_reg_1 AFTER 0 ns;    
         ram_array_d_2 <= data_reg_2 AFTER 0 ns;    
         ram_array_d_3 <= data_reg_3 AFTER 0 ns;    
         ram_array_d_4 <= data_reg_4 AFTER 0 ns;    
         ram_array_d_5 <= data_reg_5 AFTER 0 ns;    
         ram_array_d_6 <= data_reg_6 AFTER 0 ns;    
         ram_array_d_7 <= data_reg_7 AFTER 0 ns;    
         ram_array_d_8 <= data_reg_8 AFTER 0 ns;    
         ram_array_d_9 <= data_reg_9 AFTER 0 ns;    
         ram_array_d_10 <= data_reg_10 AFTER 0 ns;    
         ram_array_d_11 <= data_reg_11 AFTER 0 ns;    
         ram_array_d_12 <= data_reg_12 AFTER 0 ns;    
         ram_array_d_13 <= data_reg_13 AFTER 0 ns;    
         ram_array_d_14 <= data_reg_14 AFTER 0 ns;    
         ram_array_d_15 <= data_reg_15 AFTER 0 ns;    
      ELSE
         ram_array_d_0 <= ram_array_q_0 AFTER 0 ns;    
         ram_array_d_1 <= ram_array_q_1 AFTER 0 ns;    
         ram_array_d_2 <= ram_array_q_2 AFTER 0 ns;    
         ram_array_d_3 <= ram_array_q_3 AFTER 0 ns;    
         ram_array_d_4 <= ram_array_q_4 AFTER 0 ns;    
         ram_array_d_5 <= ram_array_q_5 AFTER 0 ns;    
         ram_array_d_6 <= ram_array_q_6 AFTER 0 ns;    
         ram_array_d_7 <= ram_array_q_7 AFTER 0 ns;    
         ram_array_d_8 <= ram_array_q_8 AFTER 0 ns;    
         ram_array_d_9 <= ram_array_q_9 AFTER 0 ns;    
         ram_array_d_10 <= ram_array_q_10 AFTER 0 ns;    
         ram_array_d_11 <= ram_array_q_11 AFTER 0 ns;    
         ram_array_d_12 <= ram_array_q_12 AFTER 0 ns;    
         ram_array_d_13 <= ram_array_q_13 AFTER 0 ns;    
         ram_array_d_14 <= ram_array_q_14 AFTER 0 ns;    
         ram_array_d_15 <= ram_array_q_15 AFTER 0 ns;    
      END IF;
   END PROCESS;

END arch_deskew_ram_block;

--/////////////////////////////////////////////////////////////////////////////
--
--                              STRATIXGX_DESKEW_FIFO
--
--/////////////////////////////////////////////////////////////////////////////

library IEEE, stratixgx_gxb, std;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
USE ieee.std_logic_arith.all; 

ENTITY stratixgx_deskew_fifo IS
   PORT (
      datain                  : IN std_logic_vector(9 DOWNTO 0);   
      errdetectin             : IN std_logic;   
      syncstatusin            : IN std_logic;   
      disperrin               : IN std_logic;   
      patterndetectin         : IN std_logic;   
      writeclock              : IN std_logic;   
      readclock               : IN std_logic;   
      adetectdeskew           : OUT std_logic;   
      fiforesetrd             : IN std_logic;   
      enabledeskew            : IN std_logic;   
      reset                   : IN std_logic;   
      dataout                 : OUT std_logic_vector(9 DOWNTO 0);   
      dataoutpre              : OUT std_logic_vector(9 DOWNTO 0);   
      errdetect               : OUT std_logic;   
      syncstatus              : OUT std_logic;   
      disperr                 : OUT std_logic;   
      patterndetect           : OUT std_logic;   
      errdetectpre            : OUT std_logic;   
      syncstatuspre           : OUT std_logic;   
      disperrpre              : OUT std_logic;   
      patterndetectpre        : OUT std_logic;   
      rdalign                 : OUT std_logic);   
END stratixgx_deskew_fifo;

ARCHITECTURE arch_stratixgx_deskew_fifo OF stratixgx_deskew_fifo IS

   COMPONENT deskew_ram_block
      PORT (
         clk                     : IN  std_logic;
         reset                   : IN  std_logic;
         addrwr                  : IN  std_logic_vector(15 DOWNTO 0);
         addrrd1                 : IN  std_logic_vector(15 DOWNTO 0);
         addrrd2                 : IN  std_logic_vector(15 DOWNTO 0);
         datain                  : IN  std_logic_vector(13 DOWNTO 0);
         we                      : IN  std_logic;
         re                      : IN  std_logic;
         dataout1                : OUT std_logic_vector(13 DOWNTO 0);
         dataout2                : OUT std_logic_vector(13 DOWNTO 0));
   END COMPONENT;


   CONSTANT  a                     :  std_logic_vector(9 DOWNTO 0) := "0011000011";    
   CONSTANT  FIFO_DEPTH            :  integer := 16;    
   SIGNAL fifo                     :  std_logic_vector(16 * 15 - 1 DOWNTO 0);   
   SIGNAL dataout_tmp              :  std_logic_vector(9 DOWNTO 0);   
   SIGNAL dataout_tmp_pre          :  std_logic_vector(9 DOWNTO 0);   
   SIGNAL dataout_fifo             :  std_logic_vector(13 DOWNTO 0);   
   SIGNAL adetectdeskew_tmp        :  std_logic;   
   SIGNAL errdetect_tmp            :  std_logic;   
   SIGNAL syncstatus_tmp           :  std_logic;   
   SIGNAL disperr_tmp              :  std_logic;   
   SIGNAL errdetect_tmp_pre        :  std_logic;   
   SIGNAL syncstatus_tmp_pre       :  std_logic;   
   SIGNAL disperr_tmp_pre          :  std_logic;   
   SIGNAL patterndetect_tmp        :  std_logic;   
   SIGNAL patterndetect_tmp_pre    :  std_logic;   
   SIGNAL align_count              :  std_logic_vector(3 DOWNTO 0);   
   SIGNAL adetect_deskew           :  std_logic;   
   SIGNAL adetect_deskew_dly       :  std_logic;
   SIGNAL enabledeskew_dly0        :  std_logic;   
   SIGNAL enabledeskew_dly1        :  std_logic;   
   SIGNAL enabledeskew_dly2        :  std_logic;   
   SIGNAL adetectdeskew_dly        :  std_logic;   
   SIGNAL write_enable             :  std_logic;   
   SIGNAL wr_enable                :  std_logic;   
   SIGNAL reset_fifo               :  std_logic;   
   SIGNAL reset_write              :  std_logic;   
   SIGNAL wr_align                 :  std_logic;   
   SIGNAL AUDI_d                   :  std_logic_vector(13 DOWNTO 0);   
   SIGNAL AUDI_pre_d               :  std_logic_vector(13 DOWNTO 0);   
   SIGNAL write_ptr                :  std_logic_vector(FIFO_DEPTH - 1 DOWNTO 0);   
   SIGNAL read_ptr1                :  std_logic_vector(FIFO_DEPTH - 1 DOWNTO 0);   
   SIGNAL read_ptr2                :  std_logic_vector(FIFO_DEPTH - 1 DOWNTO 0);   
   -- WRITE ENABLE LOGIC
   SIGNAL tmp_23                  :  std_logic_vector(13 DOWNTO 0);   
   -- active low
   -- active high
   SIGNAL port_tmp24              :  std_logic;   
   SIGNAL port_tmp25              :  std_logic;   
   SIGNAL adetect_out              :  std_logic;
   SIGNAL adetect_in               :  std_logic;

BEGIN

   PROCESS (reset, writeclock)
   BEGIN
      IF (reset = '1') THEN
         write_ptr <= "0000000000000001";    
      ELSIF (writeclock'EVENT AND writeclock = '1') THEN
         IF ((reset_fifo OR reset_write) = '1') THEN
            write_ptr <= "0000000000000001";    
         ELSE
            IF ((wr_enable OR wr_align) = '1') THEN
               write_ptr <= write_ptr(FIFO_DEPTH - 2 DOWNTO 0) & write_ptr(FIFO_DEPTH - 1);    
            ELSE
               write_ptr <= write_ptr;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (reset, readclock)
   BEGIN
      IF (reset = '1') THEN
         read_ptr1 <= "0000000000000001";    
         read_ptr2 <= "0000000000000010";    
      ELSIF (readclock'EVENT AND readclock = '1') THEN
         IF (fiforesetrd = '1') THEN
            read_ptr1 <= "0000000000000001";    
            read_ptr2 <= "0000000000000010";    
         ELSE
            IF (NOT enabledeskew = '1') THEN
               read_ptr1 <= read_ptr1(FIFO_DEPTH - 2 DOWNTO 0) & read_ptr1(FIFO_DEPTH - 1);    
               read_ptr2 <= read_ptr2(FIFO_DEPTH - 2 DOWNTO 0) & read_ptr2(FIFO_DEPTH - 1);    
            ELSE
               read_ptr1 <= "0000000000000001";    
               read_ptr2 <= "0000000000000010";    
            END IF;
         END IF;
      END IF;
   END PROCESS;
   tmp_23 <= patterndetectin & disperrin & syncstatusin & errdetectin & datain(9 DOWNTO 0);
   port_tmp24 <= '1';
   port_tmp25 <= '0';
   deskew_ram : deskew_ram_block 
      PORT MAP (
         clk => writeclock,
         reset => reset,
         addrwr => write_ptr,
         addrrd1 => read_ptr1,
         addrrd2 => read_ptr2,
         datain => tmp_23,
         we => port_tmp24,
         re => port_tmp25,
         dataout1 => AUDI_d,
         dataout2 => AUDI_pre_d);   
   
   PROCESS (reset, readclock)
      VARIABLE dataout_tmp_tmp26  : std_logic_vector(9 DOWNTO 0);
      VARIABLE errdetect_tmp_tmp27  : std_logic;
      VARIABLE syncstatus_tmp_tmp28  : std_logic;
      VARIABLE disperr_tmp_tmp29  : std_logic;
      VARIABLE dataout_tmp_pre_tmp30  : std_logic_vector(9 DOWNTO 0);
      VARIABLE errdetect_tmp_pre_tmp31  : std_logic;
      VARIABLE syncstatus_tmp_pre_tmp32  : std_logic;
      VARIABLE disperr_tmp_pre_tmp33  : std_logic;
      VARIABLE patterndetect_tmp_tmp34  : std_logic;
      VARIABLE patterndetect_tmp_pre_tmp35  : std_logic;
   BEGIN
      IF (reset = '1') THEN
         dataout_tmp_tmp26 := "0000000000";    
         errdetect_tmp_tmp27 := '0';    
         syncstatus_tmp_tmp28 := '0';    
         disperr_tmp_tmp29 := '0';    
         dataout_tmp_pre_tmp30 := "0000000000";    
         errdetect_tmp_pre_tmp31 := '0';    
         syncstatus_tmp_pre_tmp32 := '0';    
         disperr_tmp_pre_tmp33 := '0';    
         patterndetect_tmp_tmp34 := '0';    
         patterndetect_tmp_pre_tmp35 := '0';    
      ELSIF (readclock'EVENT AND readclock = '1') THEN
         dataout_tmp_tmp26 := AUDI_d(9 DOWNTO 0);    
         errdetect_tmp_tmp27 := AUDI_d(10);    
         syncstatus_tmp_tmp28 := AUDI_d(11);    
         disperr_tmp_tmp29 := AUDI_d(12);    
         patterndetect_tmp_tmp34 := AUDI_d(13);    
         dataout_tmp_pre_tmp30 := AUDI_pre_d(9 DOWNTO 0);    
         errdetect_tmp_pre_tmp31 := AUDI_pre_d(10);    
         syncstatus_tmp_pre_tmp32 := AUDI_pre_d(11);    
         disperr_tmp_pre_tmp33 := AUDI_pre_d(12);    
         patterndetect_tmp_pre_tmp35 := AUDI_pre_d(13);    
      END IF;
      dataout_tmp <= dataout_tmp_tmp26;
      errdetect_tmp <= errdetect_tmp_tmp27;
      syncstatus_tmp <= syncstatus_tmp_tmp28;
      disperr_tmp <= disperr_tmp_tmp29;
      dataout_tmp_pre <= dataout_tmp_pre_tmp30;
      errdetect_tmp_pre <= errdetect_tmp_pre_tmp31;
      syncstatus_tmp_pre <= syncstatus_tmp_pre_tmp32;
      disperr_tmp_pre <= disperr_tmp_pre_tmp33;
      patterndetect_tmp <= patterndetect_tmp_tmp34;
      patterndetect_tmp_pre <= patterndetect_tmp_pre_tmp35;
   END PROCESS;

   PROCESS (reset, writeclock)
   BEGIN
      IF (reset = '1') THEN
         wr_enable <= '0';    
      ELSIF (writeclock'EVENT AND writeclock = '1') THEN
         IF ((reset_fifo OR reset_write) = '1') THEN
            wr_enable <= '0';    
         ELSE
            IF (wr_align = '1') THEN
               wr_enable <= '1';    
            ELSE
               wr_enable <= wr_enable;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (writeclock, reset)
   BEGIN
      IF (reset = '1') THEN
         adetect_deskew <= '0';    
      ELSIF (writeclock'EVENT AND writeclock = '1') THEN
         IF (wr_align = '1') THEN
            adetect_deskew <= '1';    
         ELSE
            IF (align_count = 0) THEN
               adetect_deskew <= '0';    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (reset, writeclock)
   BEGIN
      IF (reset = '1') THEN
         align_count <= "0000";    
      ELSIF (writeclock'EVENT AND writeclock = '1') THEN
         IF (NOT enabledeskew_dly1 = '1') THEN
            align_count <= "0000";    
         ELSE
            IF (wr_align = '1') THEN
               align_count <= "1001";    
            ELSE
               IF (align_count /= 0) THEN
                  align_count <= align_count - "0001";    
               END IF;
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (writeclock, reset)
   BEGIN
      IF (reset = '1') THEN
         enabledeskew_dly0 <= '1';    
         enabledeskew_dly1 <= '1';    
         enabledeskew_dly2 <= '1';    
      ELSIF (writeclock'EVENT AND writeclock = '1') THEN
         enabledeskew_dly0 <= enabledeskew;    
         enabledeskew_dly1 <= enabledeskew_dly0;    
         enabledeskew_dly2 <= enabledeskew_dly1;    
      END IF;
   END PROCESS;

   adetect_deskew_dly <= adetect_deskew after 1 ps;

   PROCESS (reset, readclock)
   BEGIN
      IF (reset = '1') THEN
         adetectdeskew_dly <= '0';    
         adetectdeskew_tmp <= '0';    
      ELSIF (readclock'EVENT AND readclock = '1') THEN
         adetectdeskew_dly <= adetect_deskew_dly;    
         adetectdeskew_tmp <= adetectdeskew_dly;    
      END IF;
   END PROCESS;

   adetect_out <= '1' when ((unsigned(dataout_tmp(9 DOWNTO 0)) = unsigned(a)) OR 
   (unsigned(dataout_tmp(9 DOWNTO 0)) = unsigned(NOT a))) else '0';
   adetect_in <= '1' when ((unsigned(datain(9 DOWNTO 0)) = unsigned(a)) OR 
   (unsigned(datain(9 DOWNTO 0)) = unsigned(NOT a))) else '0';
   rdalign <= '1' when ( (adetect_out = '1') AND (disperr_tmp = '0') AND (errdetect_tmp = '0') ) else '0' ;
   wr_align <= '1' when ((adetect_in = '1') AND (enabledeskew_dly1 = '1') AND (disperrin = '0') AND (errdetectin = '0')) else '0';
   reset_fifo <= (wr_enable AND write_ptr(FIFO_DEPTH - 1)) AND enabledeskew_dly1 ;
   reset_write <= enabledeskew_dly1 AND NOT enabledeskew_dly2 ;
   adetectdeskew <= adetectdeskew_tmp ;
   dataout <= dataout_tmp ;
   errdetect <= errdetect_tmp ;
   syncstatus <= syncstatus_tmp ;
   disperr <= disperr_tmp ;
   dataoutpre <= dataout_tmp_pre ;
   errdetectpre <= errdetect_tmp_pre ;
   syncstatuspre <= syncstatus_tmp_pre ;
   disperrpre <= disperr_tmp_pre ;
   patterndetect <= patterndetect_tmp ;
   patterndetectpre <= patterndetect_tmp_pre ;

END arch_stratixgx_deskew_fifo;


--/////////////////////////////////////////////////////////////////////////////
--
--                               STRATIXGX_RX_CORE
--
--/////////////////////////////////////////////////////////////////////////////

LIBRARY ieee, stratixgx_gxb;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;
use stratixgx_gxb.hssi_pack.all;

ENTITY stratixgx_rx_core IS
   GENERIC (
      channel_width                  :  integer := 10;    
      use_double_data_mode           :  string  := "false";    
      use_channel_align              :  string  := "false";    
      use_8b_10b_mode                :  string  := "true";    
      align_pattern						 :  string  := "0000000000000000";
      synchronization_mode           :  string  := "none");
   PORT (
      reset                   : IN std_logic;   
      writeclk                : IN std_logic;   
      readclk                 : IN std_logic;   
      errdetectin             : IN std_logic;   
      patterndetectin         : IN std_logic;   
      decdatavalid            : IN std_logic;   
      xgmdatain               : IN std_logic_vector(7 DOWNTO 0);   
      post8b10b               : IN std_logic_vector(9 DOWNTO 0);   
      datain                  : IN std_logic_vector(9 DOWNTO 0);   
      xgmctrlin               : IN std_logic;   
      ctrldetectin            : IN std_logic;   
      syncstatusin            : IN std_logic;   
      disparityerrin          : IN std_logic;   
      syncstatus              : OUT std_logic_vector(1 DOWNTO 0);   
      errdetect               : OUT std_logic_vector(1 DOWNTO 0);   
      ctrldetect              : OUT std_logic_vector(1 DOWNTO 0);   
      disparityerr            : OUT std_logic_vector(1 DOWNTO 0);   
      patterndetect           : OUT std_logic_vector(1 DOWNTO 0);   
      dataout                 : OUT std_logic_vector(19 DOWNTO 0);   
      a1a2sizeout             : OUT std_logic_vector(1 DOWNTO 0);   
      clkout                  : OUT std_logic);   
END stratixgx_rx_core;

ARCHITECTURE arch_stratixgx_rx_core OF stratixgx_rx_core IS
   SIGNAL detect                   :  std_logic;   
   SIGNAL xgmxor                   :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL resync_d                 :  std_logic;   
   SIGNAL disperr_d                :  std_logic;   
   SIGNAL patterndetect_d          :  std_logic;   
   SIGNAL syncstatusin_1           :  std_logic;   
   SIGNAL syncstatusin_2           :  std_logic;   
   SIGNAL disparityerrin_1         :  std_logic;   
   SIGNAL disparityerrin_2         :  std_logic;   
   SIGNAL patterndetectin_1        :  std_logic;   
   SIGNAL patterndetectin_2        :  std_logic;   
   SIGNAL writeclk_by2             :  std_logic := '0';   
   SIGNAL data_low_sync            :  std_logic_vector(12 DOWNTO 0);   
   SIGNAL data_low                 :  std_logic_vector(12 DOWNTO 0);   
   SIGNAL data_high                :  std_logic_vector(12 DOWNTO 0);   
   SIGNAL data_int                 :  std_logic_vector(9 DOWNTO 0);   
   SIGNAL dataout_tmp              :  std_logic_vector(19 DOWNTO 0);   
   SIGNAL patterndetect_tmp        :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL disparityerr_tmp         :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL syncstatus_tmp           :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL errdetect_tmp            :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL ctrldetect_tmp           :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL a1a2sizeout_tmp          :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL dataout_sync1            :  std_logic_vector(19 DOWNTO 0);   
   SIGNAL patterndetect_sync1      :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL disparityerr_sync1       :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL syncstatus_sync1         :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL errdetect_sync1          :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL ctrldetect_sync1         :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL a1a2sizeout_sync1        :  std_logic_vector(1 DOWNTO 0) := "00";
   SIGNAL dataout_sync2            :  std_logic_vector(19 DOWNTO 0);   
   SIGNAL patterndetect_sync2      :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL disparityerr_sync2       :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL syncstatus_sync2         :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL errdetect_sync2          :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL ctrldetect_sync2         :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL a1a2sizeout_sync2        :  std_logic_vector(1 DOWNTO 0) := "00";
   SIGNAL doublewidth              :  std_logic;   
   SIGNAL individual               :  std_logic;   
   SIGNAL ena8b10b                 :  std_logic;   
   SIGNAL smdisable                :  std_logic;   
   SIGNAL syncstatus_tmp1         :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL errdetect_tmp2          :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL ctrldetect_tmp3         :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL disparityerr_tmp4       :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL patterndetect_tmp5      :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL dataout_tmp6            :  std_logic_vector(19 DOWNTO 0);   
   SIGNAL a1a2sizeout_tmp7        :  std_logic_vector(1 downto 0);   
   SIGNAL clkout_tmp8             :  std_logic;   
   SIGNAL running_disp            :  std_logic;
   -- A1A2 patterndetect related signals
   signal align_pattern_int : std_logic_vector(15 downto 0);
   signal patterndetect_8b : std_logic;
   signal patterndetect_1_latch : std_logic;
   signal patterndetect_2_latch : std_logic;
   signal patterndetect_3_latch : std_logic;

BEGIN
  
   syncstatus <= syncstatus_tmp1;
   errdetect <= errdetect_tmp2;
   ctrldetect <= ctrldetect_tmp3;
   disparityerr <= disparityerr_tmp4;
   patterndetect <= patterndetect_tmp5;
   dataout <= dataout_tmp6;
   a1a2sizeout <= a1a2sizeout_tmp7;
   clkout <= clkout_tmp8;
   doublewidth <= '1' WHEN (use_double_data_mode = "true") ELSE '0' ;
   individual <= '1' WHEN (use_channel_align /= "true") ELSE '0' ;
   ena8b10b <= '1' WHEN (use_8b_10b_mode = "true") ELSE '0' ;
   smdisable <= '1' WHEN (synchronization_mode = "none") ELSE '0' ;
   running_disp <= disparityerrin OR errdetectin;
   
   -- A1A2 pattern detection
   align_pattern_int <= pattern_conversion(align_pattern);

   -- A1A2 patterndetect block
   PROCESS (datain, align_pattern_int, patterndetect_1_latch, patterndetect_3_latch)
      VARIABLE patterndetect_8b_tmp10  : std_logic;
      VARIABLE match_tmp  : std_logic := '0';
   BEGIN
      IF (datain(8) = '1') THEN
         if (UNSIGNED(datain(7 DOWNTO 0)) = UNSIGNED(align_pattern_int(15 DOWNTO 8))) then
            match_tmp := '1';
         else
            match_tmp := '0';
         end if;
         patterndetect_8b_tmp10 := match_tmp AND patterndetect_3_latch;    
      ELSE
         if (UNSIGNED(datain(7 DOWNTO 0)) = UNSIGNED(align_pattern_int(15 DOWNTO 8))) then
            match_tmp := '1';
         else
            match_tmp := '0';
         end if;
         patterndetect_8b_tmp10 := match_tmp AND patterndetect_1_latch;    
      END IF;
      patterndetect_8b <= patterndetect_8b_tmp10;
   END PROCESS;

   -- A1A2 patterndetect latch
   PROCESS (reset, writeclk)
      VARIABLE match_low  : std_logic := '0';
      VARIABLE match_high  : std_logic := '0';
   BEGIN
      IF (reset = '1') THEN
         patterndetect_1_latch <= '0';    
         patterndetect_2_latch <= '0';    
         patterndetect_3_latch <= '0';    
      ELSIF (writeclk'EVENT AND writeclk = '1') THEN
         if (UNSIGNED(datain(7 DOWNTO 0)) = UNSIGNED(align_pattern_int(7 DOWNTO 0))) then
            match_low := '1';
         else
            match_low := '0';
         end if;    

         if (UNSIGNED(datain(7 DOWNTO 0)) = UNSIGNED(align_pattern_int(15 DOWNTO 8))) then
            match_high := '1';
         else
            match_high := '0';
         end if;    

         patterndetect_1_latch <= match_low;
         patterndetect_2_latch <= (patterndetect_1_latch) AND match_low;
         patterndetect_3_latch <= (patterndetect_2_latch) AND match_high;
      END IF;
   END PROCESS;

   PROCESS (xgmdatain, datain, xgmctrlin, ctrldetectin, decdatavalid, data_int, syncstatusin, disparityerrin, patterndetectin, patterndetect_8b, syncstatusin_2, disparityerrin_2, patterndetectin_2, running_disp)
 	variable i_detect : std_logic;
   BEGIN
      IF (ena8b10b = '1') THEN
         IF (individual = '1') THEN
            resync_d <= syncstatusin;    
            disperr_d <= disparityerrin;    
            IF ((NOT decdatavalid AND NOT smdisable) = '1') THEN
               data_int(8 DOWNTO 0) <= "110011100";    
               data_int(9) <= '0';    
               patterndetect_d <= '0';    
            ELSE
               IF (channel_width = 10) THEN
                  patterndetect_d <= patterndetectin;    
               ELSE
                  patterndetect_d <= patterndetect_8b;    
               END IF;

               IF (((decdatavalid AND NOT smdisable) AND running_disp) = '1') THEN
                  data_int(8 DOWNTO 0) <= "111111110";    
                  data_int(9) <= running_disp;    
               ELSE
                  data_int(8 DOWNTO 0) <= ctrldetectin & datain(7 DOWNTO 0);    
                  data_int(9) <= running_disp;    
               END IF;
            END IF;
         ELSE
            resync_d <= syncstatusin_2;    
            disperr_d <= disparityerrin_2;    
            patterndetect_d <= patterndetectin_2;    
            data_int(8 DOWNTO 0) <= xgmctrlin & xgmdatain(7 DOWNTO 0);    
       	    i_detect := '0';
            if (xgmxor /= 0) then
 	        i_detect := '1';
            end if;
	    data_int(9) <= xgmctrlin AND NOT i_detect;    

         END IF;
      ELSE
         resync_d <= syncstatusin;    
         disperr_d <= disparityerrin;    
         data_int <= datain;    
         IF ((NOT decdatavalid AND NOT smdisable) = '1') THEN
            patterndetect_d <= '0';    
         ELSE
            IF (channel_width = 10) THEN
               patterndetect_d <= patterndetectin;    
            ELSE
               patterndetect_d <= patterndetect_8b;    
            END IF;
         END IF;
      END IF;
   END PROCESS;
   xgmxor <= xgmdatain(7 DOWNTO 0) XOR "11111110" ;

   PROCESS (reset, writeclk)
   BEGIN
      IF (reset = '1') THEN
         writeclk_by2 <= '0';    
         data_high <= "0000000000000";    
         data_low <= "0000000000000";    
         data_low_sync <= "0000000000000";    
         syncstatusin_1 <= '0';    
         syncstatusin_2 <= '0';    
         disparityerrin_1 <= '0';    
         disparityerrin_2 <= '0';    
         patterndetectin_1 <= '0';    
         patterndetectin_2 <= '0';    
      ELSIF (writeclk'EVENT AND writeclk = '1') THEN
         writeclk_by2 <= NOT ((writeclk_by2 AND individual) OR (writeclk_by2 AND NOT individual));    
         syncstatusin_1 <= syncstatusin;    
         syncstatusin_2 <= syncstatusin_1;    
         disparityerrin_1 <= disparityerrin;    
         disparityerrin_2 <= disparityerrin_1;    
         patterndetectin_1 <= patterndetectin;    
         patterndetectin_2 <= patterndetectin_1;    
         IF ((doublewidth AND NOT writeclk_by2) = '1') THEN
            data_high(9 DOWNTO 0) <= data_int;    
            data_high(10) <= resync_d;    
            data_high(11) <= disperr_d;    
            data_high(12) <= patterndetect_d;    
         END IF;
         IF ((doublewidth AND writeclk_by2) = '1') THEN
            data_low(9 DOWNTO 0) <= data_int;    
            data_low(10) <= resync_d;    
            data_low(11) <= disperr_d;    
            data_low(12) <= patterndetect_d;    
         END IF;
         IF (NOT doublewidth = '1') THEN
            data_low_sync(9 DOWNTO 0) <= data_int;    
            data_low_sync(10) <= resync_d;    
            data_low_sync(11) <= disperr_d;    
            data_low_sync(12) <= patterndetect_d;    
         ELSE
            data_low_sync <= data_low;    
         END IF;
      END IF;
   END PROCESS;

   PROCESS (writeclk_by2, writeclk)
   BEGIN
      IF (doublewidth = '1') THEN
         clkout_tmp8 <= NOT writeclk_by2;    
      ELSE
         clkout_tmp8 <= NOT writeclk;    
      END IF;
   END PROCESS;

   PROCESS (reset, readclk)
   BEGIN
      IF (reset = '1') THEN
         dataout_tmp <= "00000000000000000000";    
         patterndetect_tmp <= "00";    
         disparityerr_tmp <= "00";    
         syncstatus_tmp <= "00";    
         errdetect_tmp <= "00";    
         ctrldetect_tmp <= "00";    
         a1a2sizeout_tmp <= "00";    
         dataout_sync1 <= "00000000000000000000";    
         patterndetect_sync1 <= "00";    
         disparityerr_sync1 <= "00";    
         syncstatus_sync1 <= "00";    
         errdetect_sync1 <= "00";    
         ctrldetect_sync1 <= "00";    
		 a1a2sizeout_sync1 <= "00";   
         dataout_sync2 <= "00000000000000000000";    
         patterndetect_sync2 <= "00";    
         disparityerr_sync2 <= "00";    
         syncstatus_sync2 <= "00";    
         errdetect_sync2 <= "00";    
         ctrldetect_sync2 <= "00";
		 a1a2sizeout_sync2 <= "00";   
      ELSIF (readclk'EVENT AND readclk = '1') THEN
         IF (ena8b10b = '1' OR channel_width = 8 OR channel_width = 16) THEN
            dataout_sync1 <= "0000" & data_high(7 DOWNTO 0) & data_low_sync(7 DOWNTO 0);    
         ELSE
            dataout_sync1 <= data_high(9 DOWNTO 0) & data_low_sync(9 DOWNTO 0);    
         END IF;

         patterndetect_sync1 <= data_high(12) & data_low_sync(12);    
         disparityerr_sync1 <= data_high(11) & data_low_sync(11);    
         syncstatus_sync1 <= data_high(10) & data_low_sync(10);    
         errdetect_sync1 <= data_high(9) & data_low_sync(9);    
         ctrldetect_sync1 <= data_high(8) & data_low_sync(8);    
         IF (channel_width = 8) THEN
            a1a2sizeout_sync1 <= data_high(8) & data_low_sync(8);    
         ELSE
            a1a2sizeout_sync1 <= "00";    
         END IF;
         dataout_sync2 <= dataout_sync1;    
         patterndetect_sync2 <= patterndetect_sync1;    
         disparityerr_sync2 <= disparityerr_sync1;    
         syncstatus_sync2 <= syncstatus_sync1;    
         errdetect_sync2 <= errdetect_sync1;    
         ctrldetect_sync2 <= ctrldetect_sync1;    
         a1a2sizeout_sync2 <= a1a2sizeout_sync1;    
         dataout_tmp <= dataout_sync2;    
         patterndetect_tmp <= patterndetect_sync2;    
         disparityerr_tmp <= disparityerr_sync2;    
         syncstatus_tmp <= syncstatus_sync2;    
         errdetect_tmp <= errdetect_sync2;    
         ctrldetect_tmp <= ctrldetect_sync2;    
         a1a2sizeout_tmp <= a1a2sizeout_sync2;    
      END IF;
   END PROCESS;
   dataout_tmp6 <= dataout_tmp ;
   a1a2sizeout_tmp7 <= a1a2sizeout_tmp;
   patterndetect_tmp5 <= patterndetect_tmp ;
   disparityerr_tmp4 <= disparityerr_tmp ;
   syncstatus_tmp1 <= syncstatus_tmp ;
   errdetect_tmp2 <= errdetect_tmp ;
   ctrldetect_tmp3 <= ctrldetect_tmp ;

END arch_stratixgx_rx_core;

--/////////////////////////////////////////////////////////////////////////////
--
--                               STRATIXGX_TX_CORE
--
--/////////////////////////////////////////////////////////////////////////////

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY stratixgx_tx_core IS
   GENERIC (
      use_double_data_mode           :  string := "false";    
      use_fifo_mode                  :  string := "true";    
      transmit_protocol              :  string := "none";
      channel_width                  :  integer := 10;    
      KCHAR                          :  std_logic := '0';    
      ECHAR                          :  std_logic := '0');
   PORT (
      reset                   : IN std_logic;   
      datain                  : IN std_logic_vector(19 DOWNTO 0);   
      writeclk                : IN std_logic;   
      readclk                 : IN std_logic;   
      ctrlena                 : IN std_logic_vector(1 DOWNTO 0);   
      forcedisp               : IN std_logic_vector(1 DOWNTO 0);   
      dataout                 : OUT std_logic_vector(9 DOWNTO 0);   
      forcedispout            : OUT std_logic;   
      ctrlenaout              : OUT std_logic;   
      rdenasync               : OUT std_logic;   
      xgmctrlena              : OUT std_logic;   
      xgmdataout              : OUT std_logic_vector(7 DOWNTO 0);   
      pre8b10bdataout         : OUT std_logic_vector(9 DOWNTO 0));   
END stratixgx_tx_core;

ARCHITECTURE arch_stratixgx_tx_core OF stratixgx_tx_core IS
   SIGNAL kchar_sync_1             :  std_logic;   
   SIGNAL kchar_sync               :  std_logic;   
   SIGNAL echar_sync_1             :  std_logic;   
   SIGNAL echar_sync               :  std_logic;   
   SIGNAL datain_high              :  std_logic_vector(11 DOWNTO 0);   
   SIGNAL datain_low               :  std_logic_vector(11 DOWNTO 0);   
   SIGNAL fifo_high_tmp            :  std_logic_vector(11 DOWNTO 0);   
   SIGNAL fifo_high_dly1           :  std_logic_vector(11 DOWNTO 0);   
   SIGNAL fifo_high_dly2           :  std_logic_vector(11 DOWNTO 0);   
   SIGNAL fifo_high_dly3           :  std_logic_vector(11 DOWNTO 0);   
   SIGNAL fifo_low_tmp             :  std_logic_vector(11 DOWNTO 0);   
   SIGNAL fifo_low_dly1            :  std_logic_vector(11 DOWNTO 0);   
   SIGNAL fifo_low_dly2            :  std_logic_vector(11 DOWNTO 0);   
   SIGNAL fifo_low_dly3            :  std_logic_vector(11 DOWNTO 0);   
   SIGNAL dataout_read             :  std_logic_vector(11 DOWNTO 0);   
   SIGNAL wr_enable                :  std_logic;   
   SIGNAL rd_enable_sync_1         :  std_logic;   
   SIGNAL rd_enable_sync_2         :  std_logic;   
   SIGNAL rd_enable_sync_out       :  std_logic;   
   SIGNAL fifo_select_out          :  std_logic;   
   SIGNAL rdenasync_tmp            :  std_logic;   
   SIGNAL out_ena1                 :  std_logic;   
   SIGNAL out_ena2                 :  std_logic;   
   SIGNAL out_ena3                 :  std_logic;   
   SIGNAL out_ena4                 :  std_logic;   
   SIGNAL out_ena5                 :  std_logic;   
   SIGNAL doublewidth              :  std_logic;   
   SIGNAL disablefifo              :  std_logic;   
   SIGNAL individual               :  std_logic;   
   SIGNAL writeclk_dly             :  std_logic;   

BEGIN
   doublewidth <= '1' WHEN (use_double_data_mode = "true") ELSE '0' ;
   disablefifo <= '1' WHEN (use_fifo_mode = "false") ELSE '0' ;
   individual <= '1' WHEN (transmit_protocol /= "xaui") ELSE '0' ;

   PROCESS (writeclk)
   BEGIN
     writeclk_dly <= writeclk;
   END PROCESS;

   PROCESS (reset, readclk)
   BEGIN
      IF (reset = '1') THEN
         kchar_sync_1 <= '0';    
         kchar_sync <= '0';    
         echar_sync_1 <= '0';    
         echar_sync <= '0';    
      ELSIF (readclk'EVENT AND readclk = '1') THEN
         kchar_sync_1 <= KCHAR;    
         kchar_sync <= kchar_sync_1;    
         echar_sync_1 <= ECHAR;    
         echar_sync <= echar_sync_1;    
      END IF;
   END PROCESS;

   -- outputs
   dataout         <= dataout_read(9 DOWNTO 0);
   xgmdataout      <= dataout_read(7 DOWNTO 0);
   pre8b10bdataout <= dataout_read(9 DOWNTO 0);

   forcedispout    <= dataout_read(10);
   ctrlenaout      <= dataout_read(11);
   xgmctrlena      <= dataout_read(11);

   rdenasync       <= rdenasync_tmp;

   PROCESS (reset, writeclk_dly, datain, forcedisp, ctrlena)
   BEGIN
      IF (reset = '1') THEN
         datain_high(11 DOWNTO 0) <= "000000000000";    
         datain_low(11 DOWNTO 0) <= "000000000000";    
      ELSE
	     IF (channel_width = 10 OR channel_width = 20) THEN
              IF (doublewidth = '1') THEN
		        datain_high(11 DOWNTO 0) <= ctrlena(1) & forcedisp(1) & datain(19 DOWNTO 10);
		      ELSE
		        datain_high(11 DOWNTO 0) <= ctrlena(0) & forcedisp(0) & datain(9 DOWNTO 0);
			  END IF;

		      datain_low(11 DOWNTO 0) <= ctrlena(0) & forcedisp(0) & datain(9 DOWNTO 0);   
	    ELSE
              IF (doublewidth = '1') THEN
                datain_high(11 DOWNTO 0) <= ctrlena(1) & forcedisp(1) & "00" & datain(15 DOWNTO 8);
		      ELSE
                datain_high(11 DOWNTO 0) <= ctrlena(0) & forcedisp(0) & "00" & datain(7 DOWNTO 0);
		      END IF;

		      datain_low(11 DOWNTO 0) <= ctrlena(0) & forcedisp(0) & "00" & datain(7 DOWNTO 0);
	    END IF;
	  END IF;
   END PROCESS;

   PROCESS (reset, writeclk_dly)
   BEGIN
      IF (reset = '1') THEN
         fifo_high_dly1 <= "000000000000";    
         fifo_high_dly2 <= "000000000000";    
         fifo_high_dly3 <= "000000000000";    
         fifo_high_tmp <= "000000000000";    
      ELSIF (writeclk_dly'EVENT AND writeclk_dly = '1') THEN
         fifo_high_dly1 <= datain_high;    
         fifo_high_dly2 <= fifo_high_dly1;    
         fifo_high_dly3 <= fifo_high_dly2;    
         fifo_high_tmp <= fifo_high_dly3;    
      END IF;
   END PROCESS;

   PROCESS (reset, writeclk_dly)
   BEGIN
      IF (reset = '1') THEN
         fifo_low_dly1 <= "000000000000";    
         fifo_low_dly2 <= "000000000000";    
         fifo_low_dly3 <= "000000000000";    
         fifo_low_tmp <= "000000000000";    
      ELSIF (writeclk_dly'EVENT AND writeclk_dly = '1') THEN
         fifo_low_dly1 <= datain_low;    
         fifo_low_dly2 <= fifo_low_dly1;    
         fifo_low_dly3 <= fifo_low_dly2;    
         fifo_low_tmp <= fifo_low_dly3;    
      END IF;
   END PROCESS;

   -- DATAOUT ENALBE LOGIC
   out_ena1 <= (((NOT disablefifo AND rdenasync_tmp) AND (NOT doublewidth OR fifo_select_out)) AND NOT kchar_sync) AND NOT echar_sync ;
   out_ena2 <= (((NOT disablefifo AND rdenasync_tmp) AND (doublewidth AND NOT fifo_select_out)) AND NOT kchar_sync) AND NOT echar_sync ;
   out_ena3 <= ((disablefifo AND (NOT doublewidth OR NOT fifo_select_out)) AND NOT kchar_sync) AND NOT echar_sync ;
   out_ena4 <= NOT kchar_sync AND echar_sync ;
   out_ena5 <= (((disablefifo AND doublewidth) AND fifo_select_out) AND NOT kchar_sync) AND NOT echar_sync ;

   -- Dataout, CTRL, FORCE_DISP registered by read clock
   PROCESS (reset, readclk)
   BEGIN
      IF (reset = '1') THEN
         dataout_read(11 DOWNTO 0) <= "000000000000";    
      ELSIF (readclk'EVENT AND readclk = '1') THEN
	   IF (out_ena1 = '1') THEN
    	 dataout_read <= fifo_low_tmp;
	   ELSIF (out_ena2 = '1') THEN
	     dataout_read <= fifo_high_tmp;
	   ELSIF (out_ena3 = '1') THEN
	     dataout_read <= datain_low;	     
	   ELSIF (out_ena4 = '1') THEN
		   dataout_read(7 DOWNTO 0) <= "11111110";
		   dataout_read(10) <= '0';
		   dataout_read(11) <= '1';
	   ELSIF (out_ena5 = '1') THEN
		   dataout_read <= datain_high;
	   ELSE 
		   dataout_read(10) <= '0';
		   dataout_read(11) <= '1';  -- fixed from 0 to 1 in 3.0 .
		   IF ((NOT individual) = '1') THEN
	         dataout_read(7 DOWNTO 0) <= "00000111"; 
	       ELSE
	         dataout_read(7 DOWNTO 0) <= "10111100";
		   END IF;
	   END IF;
	     
	 END IF; -- end of not reset
   END PROCESS;

   -- fifo select
   PROCESS (reset, writeclk_dly)
   BEGIN
      IF (reset = '1' OR writeclk_dly = '1') THEN
         fifo_select_out <= '1';    
      ELSE
         fifo_select_out <= '0';    
      END IF;
   END PROCESS;

   PROCESS (reset, readclk)
   BEGIN
      IF (reset = '1') THEN
         rd_enable_sync_1 <= '0';    
         rd_enable_sync_2 <= '0';    
         rd_enable_sync_out <= '0';    
      ELSIF (readclk'EVENT AND readclk = '1') THEN
         rd_enable_sync_1 <= wr_enable OR disablefifo;    
         rd_enable_sync_2 <= rd_enable_sync_1;    
         rd_enable_sync_out <= rd_enable_sync_2;    
      END IF;
   END PROCESS;

   PROCESS (reset, writeclk_dly)
   BEGIN
      IF (reset = '1') THEN
         wr_enable <= '0';    
      ELSIF (writeclk_dly'EVENT AND writeclk_dly = '1') THEN
         wr_enable <= '1';    
      END IF;
   END PROCESS;
   rdenasync_tmp <= rd_enable_sync_out WHEN (individual) = '1' ELSE rd_enable_sync_1 ;

END arch_stratixgx_tx_core;


-- 
-- 4 to 1 MULTIPLEXER
--

library IEEE, stratixgx_gxb,std;
use IEEE.std_logic_1164.all;
use stratixgx_gxb.hssi_pack.all;

ENTITY stratixgx_hssi_mux4 IS
   PORT (
      Y                       : OUT std_logic;   
      I0                      : IN std_logic;   
      I1                      : IN std_logic;   
      I2                      : IN std_logic;   
      I3                      : IN std_logic;   
      C0                      : IN std_logic;   
      C1                      : IN std_logic);
END stratixgx_hssi_mux4;

ARCHITECTURE stratixgx_hssi_mux4_arch OF stratixgx_hssi_mux4 IS
  SIGNAL Y_tmp                  :  std_logic;   
BEGIN
   Y <= Y_tmp;

   PROCESS (I0, I1, I2, I3, C0, C1)
      VARIABLE Y_tmp1  : std_logic;
      VARIABLE ctrl  : std_logic_vector(1 DOWNTO 0);
   BEGIN
      ctrl := C1 & C0;
      CASE ctrl IS
         WHEN "00" =>
                  Y_tmp1 := I0;    
         WHEN "01" =>
                  Y_tmp1 := I1;    
         WHEN "10" =>
                  Y_tmp1 := I2;    
         WHEN "11" =>
                  Y_tmp1 := I3;    
         WHEN OTHERS =>
                  NULL;
      END CASE;
      Y_tmp <= Y_tmp1;
   END PROCESS;

END stratixgx_hssi_mux4_arch;

--
-- DIVIDE BY TWO LOGIC
--

library IEEE, stratixgx_gxb,std;
use IEEE.std_logic_1164.all;
use stratixgx_gxb.hssi_pack.all;

ENTITY stratixgx_hssi_divide_by_two IS
   GENERIC (
      divide                  :  string := "true");
   PORT (
      reset                   : IN std_logic := '0';   
      clkin                   : IN std_logic;   
      clkout                  : OUT std_logic);   
END stratixgx_hssi_divide_by_two;

ARCHITECTURE stratixgx_hssi_divide_by_two_arch OF stratixgx_hssi_divide_by_two IS
  SIGNAL clktmp                   :  std_logic := '0';   
BEGIN
   PROCESS (clkin, reset)
   BEGIN
      IF (divide = "false") THEN
         clktmp <= clkin;    
      ELSIF (reset'event and (reset = '1')) THEN
         clktmp <= '0';
      ELSE
         IF (reset = '0' and clkin'event and (clkin = '1')) THEN
            clktmp <= NOT clktmp;    
         END IF;
      END IF;
   END PROCESS;
   clkout <= clktmp;
END stratixgx_hssi_divide_by_two_arch;

--
-- stratixgx_xgm_interface
--

library IEEE, stratixgx_gxb;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use stratixgx_gxb.hssi_pack.all;

ENTITY stratixgx_xgm_interface IS
  generic (
    use_continuous_calibration_mode : String := "false";
    mode_is_xaui : String := "false";
    rx_ppm_setting_0    : integer := 0;
    rx_ppm_setting_1    : integer := 0;
    digital_test_output_select          : integer := 0;
    analog_test_output_signal_select    : integer := 0;
    analog_test_output_channel_select   : integer := 0;
    use_rx_calibration_status           : String  := "false";
    use_global_serial_loopback          : String  := "false";
    rx_calibration_test_write_value     : integer := 0;
    enable_rx_calibration_test_write    : String  := "false";
    tx_calibration_test_write_value     : integer := 0;
    enable_tx_calibration_test_write    : String  := "false";
    TimingChecksOn      : Boolean := True;
    MsgOn               : Boolean := DefGlitchMsgOn;
    XOn                 : Boolean := DefGlitchXOn;
    MsgOnChecks		: Boolean := DefMsgOnChecks;
    XOnChecks		: Boolean := DefXOnChecks;
    InstancePath	: String  := "*";
    tipd_txdatain       : VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
    tipd_txctrl		: VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
    tipd_rdenablesync	: VitalDelayType01 := DefpropDelay01;
    tipd_txclk		: VitalDelayType01 := DefpropDelay01;
    tipd_rxdatain       : VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
    tipd_rxctrl		: VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
    tipd_rxclk		: VitalDelayType01 := DefpropDelay01;
    tipd_rxrunningdisp  : VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
    tipd_rxdatavalid	: VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
    tipd_resetall	: VitalDelayType01 := DefpropDelay01;
    tipd_adet		: VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
    tipd_syncstatus	: VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
    tipd_rdalign	: VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
    tipd_recovclk	: VitalDelayType01 := DefpropDelay01
    );

   PORT (
      txdatain                : IN std_logic_vector(31 DOWNTO 0) := "00000000000000000000000000000000";
      txctrl                  : IN std_logic_vector(3 DOWNTO 0) := "0000";
      rdenablesync            : IN std_logic := '0';
      txclk                   : IN std_logic := '0';   
      rxdatain                : IN std_logic_vector(31 DOWNTO 0) := "00000000000000000000000000000000";
      rxctrl                  : IN std_logic_vector(3 DOWNTO 0) := "0000";   
      rxrunningdisp           : IN std_logic_vector(3 DOWNTO 0) := "0000";   
      rxdatavalid             : IN std_logic_vector(3 DOWNTO 0) := "0000";   
      rxclk                   : IN std_logic := '0';   
      resetall                : IN std_logic := '0';   
      adet                    : IN std_logic_vector(3 DOWNTO 0) := "0000";   
      syncstatus              : IN std_logic_vector(3 DOWNTO 0) := "0000";   
      rdalign                 : IN std_logic_vector(3 DOWNTO 0) := "0000";   
      recovclk                : IN std_logic := '0';   
      devpor                  : IN std_logic := '0';   
      devclrn                 : IN std_logic := '0';   
      txdataout               : OUT std_logic_vector(31 DOWNTO 0);   
      txctrlout               : OUT std_logic_vector(3 DOWNTO 0);   
      rxdataout               : OUT std_logic_vector(31 DOWNTO 0);   
      rxctrlout               : OUT std_logic_vector(3 DOWNTO 0);   
      resetout                : OUT std_logic;   
      alignstatus             : OUT std_logic;   
      enabledeskew            : OUT std_logic;   
      fiforesetrd             : OUT std_logic;
      -- NEW MDIO/PE ONLY PORTS
      mdioclk                 : IN std_logic := '0';
      mdiodisable             : IN std_logic := '0';
      mdioin                  : IN std_logic := '0';
      rxppmselect             : IN std_logic := '0';
      scanclk                 : IN std_logic := '0';
      scanin                  : IN std_logic := '0';
      scanmode                : IN std_logic := '0';
      scanshift               : IN std_logic := '0';
      -- NEW MDIO/PE ONLY PORTS
      calibrationstatus       : OUT std_logic_vector(4 DOWNTO 0);
      digitalsmtest           : OUT std_logic_vector(3 DOWNTO 0);
      mdiooe                  : OUT std_logic;
      mdioout                 : OUT std_logic;
      scanout                 : OUT std_logic;
      test                    : OUT std_logic;
      -- RESET PORTS
      txdigitalreset          : IN std_logic_vector(3 DOWNTO 0) := "0000";   
      rxdigitalreset          : IN std_logic_vector(3 DOWNTO 0) := "0000";   
      rxanalogreset           : IN std_logic_vector(3 DOWNTO 0) := "0000";   
      pllreset                : IN std_logic := '0';   
      pllenable               : IN std_logic := '1';   
      txdigitalresetout       : OUT std_logic_vector(3 DOWNTO 0);   
      rxdigitalresetout       : OUT std_logic_vector(3 DOWNTO 0);   
      txanalogresetout        : OUT std_logic_vector(3 DOWNTO 0);   
      rxanalogresetout        : OUT std_logic_vector(3 DOWNTO 0);   
      pllresetout             : OUT std_logic
    );   

END stratixgx_xgm_interface;

ARCHITECTURE vital_stratixgx_xgm_interface_atom OF stratixgx_xgm_interface IS

	-- input buffers
	signal txdatain_ipd : std_logic_vector(31 downto 0);
	signal txctrl_ipd : std_logic_vector(3 downto 0);
	signal rdenablesync_ipd : std_logic;
	signal txclk_ipd : std_logic;
	signal rxdatain_ipd : std_logic_vector(31 downto 0);
	signal rxctrl_ipd : std_logic_vector(3 downto 0);
	signal rxrunningdisp_ipd : std_logic_vector(3 downto 0);
	signal rxdatavalid_ipd : std_logic_vector(3 downto 0);
	signal rxclk_ipd : std_logic;
	signal resetall_ipd : std_logic;
	signal adet_ipd : std_logic_vector(3 downto 0);
	signal syncstatus_ipd : std_logic_vector(3 downto 0);
	signal rdalign_ipd : std_logic_vector(3 downto 0);
	signal recovclk_ipd : std_logic;

   -- internal input signals
   SIGNAL reset_int                :  std_logic;
   SIGNAL extended_pllreset        :  std_logic;
   SIGNAL rxdigitalresetout_tmp    :  std_logic_vector(3 downto 0) := "0000";
   SIGNAL txdigitalresetout_tmp    :  std_logic_vector(3 downto 0) := "0000";
   -- internal output signals
   SIGNAL resetout_tmp             :  std_logic;   
   SIGNAL txdataout_xtmp1          :  std_logic_vector(31 DOWNTO 0);   
   SIGNAL txctrlout_xtmp2          :  std_logic_vector(3 DOWNTO 0);   
   SIGNAL rxdataout_xtmp3          :  std_logic_vector(31 DOWNTO 0);   
   SIGNAL rxctrlout_xtmp4          :  std_logic_vector(3 DOWNTO 0);   
   SIGNAL resetout_xtmp5           :  std_logic;   
   SIGNAL alignstatus_xtmp6        :  std_logic;   
   SIGNAL enabledeskew_xtmp7       :  std_logic;   
   SIGNAL fiforesetrd_xtmp8        :  std_logic;   

component stratixgx_reset_block
   PORT (
      txdigitalreset          : IN std_logic_vector(3 DOWNTO 0);   
      rxdigitalreset          : IN std_logic_vector(3 DOWNTO 0);   
      rxanalogreset           : IN std_logic_vector(3 DOWNTO 0);   
      pllreset                : IN std_logic;   
      pllenable               : IN std_logic;   
      txdigitalresetout       : OUT std_logic_vector(3 DOWNTO 0);   
      rxdigitalresetout       : OUT std_logic_vector(3 DOWNTO 0);   
      txanalogresetout        : OUT std_logic_vector(3 DOWNTO 0);   
      rxanalogresetout        : OUT std_logic_vector(3 DOWNTO 0);   
      pllresetout             : OUT std_logic);   
END component;

component stratixgx_xgm_rx_sm 
   port (
     rxdatain			: IN std_logic_vector(31 DOWNTO 0) := "00000000000000000000000000000000";
     rxctrl         : IN std_logic_vector(3 DOWNTO 0) := "0000";
     rxrunningdisp  : IN std_logic_vector(3 DOWNTO 0) := "0000";   
     rxdatavalid    : IN std_logic_vector(3 DOWNTO 0) := "0000";   
     rxclk          : IN std_logic := '0';   
     resetall       : IN std_logic := '0';   
     rxdataout      : OUT std_logic_vector(31 DOWNTO 0);   
     rxctrlout      : OUT std_logic_vector(3 DOWNTO 0)
     );   
end component;

component stratixgx_xgm_tx_sm 
   port (
     txdatain			: IN std_logic_vector(31 DOWNTO 0) := "00000000000000000000000000000000";   
     txctrl         : IN std_logic_vector(3 DOWNTO 0) := "0000";   
     rdenablesync   : IN std_logic := '0';   
     txclk          : IN std_logic := '0';   
     resetall       : IN std_logic := '0';   
     txdataout      : OUT std_logic_vector(31 DOWNTO 0);   
     txctrlout      : OUT std_logic_vector(3 DOWNTO 0));   
end component;

component stratixgx_xgm_dskw_sm 
   port (
     resetall       : IN std_logic := '0';   
     adet           : IN std_logic_vector(3 DOWNTO 0) := "0000";   
     syncstatus     : IN std_logic_vector(3 DOWNTO 0) := "0000";   
     rdalign        : IN std_logic_vector(3 DOWNTO 0) := "0000";   
     recovclk       : IN std_logic := '0';   
     alignstatus    : OUT std_logic;   
     enabledeskew   : OUT std_logic;   
     fiforesetrd    : OUT std_logic);   
end component;

BEGIN
	----------------------
	--  INPUT PATH DELAYs
	----------------------
	WireDelay : block
	begin
		VitalWireDelay (txdatain_ipd(0), txdatain(0), tipd_txdatain(0));
		VitalWireDelay (txdatain_ipd(1), txdatain(1), tipd_txdatain(1));
		VitalWireDelay (txdatain_ipd(2), txdatain(2), tipd_txdatain(2));
		VitalWireDelay (txdatain_ipd(3), txdatain(3), tipd_txdatain(3));
		VitalWireDelay (txdatain_ipd(4), txdatain(4), tipd_txdatain(4));
		VitalWireDelay (txdatain_ipd(5), txdatain(5), tipd_txdatain(5));
		VitalWireDelay (txdatain_ipd(6), txdatain(6), tipd_txdatain(6));
		VitalWireDelay (txdatain_ipd(7), txdatain(7), tipd_txdatain(7));
		VitalWireDelay (txdatain_ipd(8), txdatain(8), tipd_txdatain(8));
		VitalWireDelay (txdatain_ipd(9), txdatain(9), tipd_txdatain(9));
		VitalWireDelay (txdatain_ipd(10), txdatain(10), tipd_txdatain(10));
		VitalWireDelay (txdatain_ipd(11), txdatain(11), tipd_txdatain(11));
		VitalWireDelay (txdatain_ipd(12), txdatain(12), tipd_txdatain(12));
		VitalWireDelay (txdatain_ipd(13), txdatain(13), tipd_txdatain(13));
		VitalWireDelay (txdatain_ipd(14), txdatain(14), tipd_txdatain(14));
		VitalWireDelay (txdatain_ipd(15), txdatain(15), tipd_txdatain(15));
		VitalWireDelay (txdatain_ipd(16), txdatain(16), tipd_txdatain(16));
		VitalWireDelay (txdatain_ipd(17), txdatain(17), tipd_txdatain(17));
		VitalWireDelay (txdatain_ipd(18), txdatain(18), tipd_txdatain(18));
		VitalWireDelay (txdatain_ipd(19), txdatain(19), tipd_txdatain(19));
		VitalWireDelay (txdatain_ipd(20), txdatain(20), tipd_txdatain(20));
		VitalWireDelay (txdatain_ipd(21), txdatain(21), tipd_txdatain(21));
		VitalWireDelay (txdatain_ipd(22), txdatain(22), tipd_txdatain(22));
		VitalWireDelay (txdatain_ipd(23), txdatain(23), tipd_txdatain(23));
		VitalWireDelay (txdatain_ipd(24), txdatain(24), tipd_txdatain(24));
		VitalWireDelay (txdatain_ipd(25), txdatain(25), tipd_txdatain(25));
		VitalWireDelay (txdatain_ipd(26), txdatain(26), tipd_txdatain(26));
		VitalWireDelay (txdatain_ipd(27), txdatain(27), tipd_txdatain(27));
		VitalWireDelay (txdatain_ipd(28), txdatain(28), tipd_txdatain(28));
		VitalWireDelay (txdatain_ipd(29), txdatain(29), tipd_txdatain(29));
		VitalWireDelay (txdatain_ipd(30), txdatain(30), tipd_txdatain(30));
		VitalWireDelay (txdatain_ipd(31), txdatain(31), tipd_txdatain(31));

		VitalWireDelay (rxdatain_ipd(0), rxdatain(0), tipd_rxdatain(0));
		VitalWireDelay (rxdatain_ipd(1), rxdatain(1), tipd_rxdatain(1));
		VitalWireDelay (rxdatain_ipd(2), rxdatain(2), tipd_rxdatain(2));
		VitalWireDelay (rxdatain_ipd(3), rxdatain(3), tipd_rxdatain(3));
		VitalWireDelay (rxdatain_ipd(4), rxdatain(4), tipd_rxdatain(4));
		VitalWireDelay (rxdatain_ipd(5), rxdatain(5), tipd_rxdatain(5));
		VitalWireDelay (rxdatain_ipd(6), rxdatain(6), tipd_rxdatain(6));
		VitalWireDelay (rxdatain_ipd(7), rxdatain(7), tipd_rxdatain(7));
		VitalWireDelay (rxdatain_ipd(8), rxdatain(8), tipd_rxdatain(8));
		VitalWireDelay (rxdatain_ipd(9), rxdatain(9), tipd_rxdatain(9));
		VitalWireDelay (rxdatain_ipd(10), rxdatain(10), tipd_rxdatain(10));
		VitalWireDelay (rxdatain_ipd(11), rxdatain(11), tipd_rxdatain(11));
		VitalWireDelay (rxdatain_ipd(12), rxdatain(12), tipd_rxdatain(12));
		VitalWireDelay (rxdatain_ipd(13), rxdatain(13), tipd_rxdatain(13));
		VitalWireDelay (rxdatain_ipd(14), rxdatain(14), tipd_rxdatain(14));
		VitalWireDelay (rxdatain_ipd(15), rxdatain(15), tipd_rxdatain(15));
		VitalWireDelay (rxdatain_ipd(16), rxdatain(16), tipd_rxdatain(16));
		VitalWireDelay (rxdatain_ipd(17), rxdatain(17), tipd_rxdatain(17));
		VitalWireDelay (rxdatain_ipd(18), rxdatain(18), tipd_rxdatain(18));
		VitalWireDelay (rxdatain_ipd(19), rxdatain(19), tipd_rxdatain(19));
		VitalWireDelay (rxdatain_ipd(20), rxdatain(20), tipd_rxdatain(20));
		VitalWireDelay (rxdatain_ipd(21), rxdatain(21), tipd_rxdatain(21));
		VitalWireDelay (rxdatain_ipd(22), rxdatain(22), tipd_rxdatain(22));
		VitalWireDelay (rxdatain_ipd(23), rxdatain(23), tipd_rxdatain(23));
		VitalWireDelay (rxdatain_ipd(24), rxdatain(24), tipd_rxdatain(24));
		VitalWireDelay (rxdatain_ipd(25), rxdatain(25), tipd_rxdatain(25));
		VitalWireDelay (rxdatain_ipd(26), rxdatain(26), tipd_rxdatain(26));
		VitalWireDelay (rxdatain_ipd(27), rxdatain(27), tipd_rxdatain(27));
		VitalWireDelay (rxdatain_ipd(28), rxdatain(28), tipd_rxdatain(28));
		VitalWireDelay (rxdatain_ipd(29), rxdatain(29), tipd_rxdatain(29));
		VitalWireDelay (rxdatain_ipd(30), rxdatain(30), tipd_rxdatain(30));
		VitalWireDelay (rxdatain_ipd(31), rxdatain(31), tipd_rxdatain(31));

		VitalWireDelay (txctrl_ipd(0), txctrl(0), tipd_txctrl(0));
		VitalWireDelay (txctrl_ipd(1), txctrl(1), tipd_txctrl(1));
		VitalWireDelay (txctrl_ipd(2), txctrl(2), tipd_txctrl(2));
		VitalWireDelay (txctrl_ipd(3), txctrl(3), tipd_txctrl(3));

		VitalWireDelay (rxctrl_ipd(0), rxctrl(0), tipd_rxctrl(0));
		VitalWireDelay (rxctrl_ipd(1), rxctrl(1), tipd_rxctrl(1));
		VitalWireDelay (rxctrl_ipd(2), rxctrl(2), tipd_rxctrl(2));
		VitalWireDelay (rxctrl_ipd(3), rxctrl(3), tipd_rxctrl(3));

		VitalWireDelay (rxrunningdisp_ipd(0), rxrunningdisp(0), tipd_rxrunningdisp(0));
		VitalWireDelay (rxrunningdisp_ipd(1), rxrunningdisp(1), tipd_rxrunningdisp(1));
		VitalWireDelay (rxrunningdisp_ipd(2), rxrunningdisp(2), tipd_rxrunningdisp(2));
		VitalWireDelay (rxrunningdisp_ipd(3), rxrunningdisp(3), tipd_rxrunningdisp(3));

		VitalWireDelay (rxdatavalid_ipd(0), rxdatavalid(0), tipd_rxdatavalid(0));
		VitalWireDelay (rxdatavalid_ipd(1), rxdatavalid(1), tipd_rxdatavalid(1));
		VitalWireDelay (rxdatavalid_ipd(2), rxdatavalid(2), tipd_rxdatavalid(2));
		VitalWireDelay (rxdatavalid_ipd(3), rxdatavalid(3), tipd_rxdatavalid(3));

		VitalWireDelay (rdenablesync_ipd, rdenablesync, tipd_rdenablesync);

		VitalWireDelay (txclk_ipd, txclk, tipd_txclk);
		VitalWireDelay (rxclk_ipd, rxclk, tipd_rxclk);
		VitalWireDelay (recovclk_ipd, recovclk, tipd_recovclk);

		VitalWireDelay (resetall_ipd, resetall, tipd_resetall);

		VitalWireDelay (adet_ipd(0), adet(0), tipd_adet(0));
		VitalWireDelay (adet_ipd(1), adet(1), tipd_adet(1));
		VitalWireDelay (adet_ipd(2), adet(2), tipd_adet(2));
		VitalWireDelay (adet_ipd(3), adet(3), tipd_adet(3));

		VitalWireDelay (syncstatus_ipd(0), syncstatus(0), tipd_syncstatus(0));
		VitalWireDelay (syncstatus_ipd(1), syncstatus(1), tipd_syncstatus(1));
		VitalWireDelay (syncstatus_ipd(2), syncstatus(2), tipd_syncstatus(2));
		VitalWireDelay (syncstatus_ipd(3), syncstatus(3), tipd_syncstatus(3));

		VitalWireDelay (rdalign_ipd(0), rdalign(0), tipd_rdalign(0));
		VitalWireDelay (rdalign_ipd(1), rdalign(1), tipd_rdalign(1));
		VitalWireDelay (rdalign_ipd(2), rdalign(2), tipd_rdalign(2));
		VitalWireDelay (rdalign_ipd(3), rdalign(3), tipd_rdalign(3));
	end block;

	------------------------
	--  Timing Check Section
	------------------------

   txdataout <= txdataout_xtmp1;
   txctrlout <= txctrlout_xtmp2;
   rxdataout <= rxdataout_xtmp3;
   rxctrlout <= rxctrlout_xtmp4;
   resetout <= resetout_xtmp5;
   alignstatus <= alignstatus_xtmp6;
   enabledeskew <= enabledeskew_xtmp7;
   fiforesetrd <= fiforesetrd_xtmp8;
   reset_int <= resetall_ipd ;
   rxdigitalresetout <= rxdigitalresetout_tmp;
   txdigitalresetout <= txdigitalresetout_tmp;
   resetout_tmp <= resetall_ipd ;
   extended_pllreset <= pllreset OR (NOT devpor) OR (NOT devclrn);
        
   stratixgx_reset : stratixgx_reset_block
     port map (
       txdigitalreset => txdigitalreset,
       rxdigitalreset => rxdigitalreset,
       rxanalogreset  => rxanalogreset,
       pllreset       => extended_pllreset,
       pllenable      => pllenable,
       txdigitalresetout => txdigitalresetout_tmp,
       rxdigitalresetout => rxdigitalresetout_tmp,
       txanalogresetout  => txanalogresetout,
       rxanalogresetout  => rxanalogresetout,
       pllresetout       => pllresetout);
        
   s_xgm_rx_sm : stratixgx_xgm_rx_sm 
      PORT MAP (
         rxdatain => rxdatain_ipd,
         rxctrl => rxctrl_ipd,
         rxrunningdisp => rxrunningdisp_ipd,
         rxdatavalid => rxdatavalid_ipd,
         rxclk => rxclk_ipd,
         resetall => rxdigitalresetout_tmp(0),
         rxdataout => rxdataout_xtmp3,
         rxctrlout => rxctrlout_xtmp4);   
   
   s_xgm_tx_sm : stratixgx_xgm_tx_sm 
      PORT MAP (
         txdatain => txdatain_ipd,
         txctrl => txctrl_ipd,
         rdenablesync => rdenablesync_ipd,
         txclk => txclk_ipd,
         resetall => txdigitalresetout_tmp(0),
         txdataout => txdataout_xtmp1,
         txctrlout => txctrlout_xtmp2);   
   
   s_xgm_dskw_sm : stratixgx_xgm_dskw_sm 
      PORT MAP (
         resetall => rxdigitalresetout_tmp(0),
         adet => adet_ipd,
         syncstatus => syncstatus_ipd,
         rdalign => rdalign_ipd,
         recovclk => recovclk_ipd,
         alignstatus => alignstatus_xtmp6,
         enabledeskew => enabledeskew_xtmp7,
         fiforesetrd => fiforesetrd_xtmp8);   
   
   resetout_xtmp5 <= resetout_tmp AND '1';   

	----------------------
	--  Path Delay Section
	----------------------

END vital_stratixgx_xgm_interface_atom;

--
-- STRATIXGX_HSSI_RECEIVER
--

library IEEE, stratixgx_gxb,std;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use stratixgx_gxb.hssi_pack.all;
use std.textio.all;

entity stratixgx_hssi_receiver is
  generic (
    channel_num                 : integer := 1;
    channel_width		: integer := 20;
    deserialization_factor	: integer := 10;
    run_length			: integer := 4;
    run_length_enable		: String  := "false";
    use_8b_10b_mode		: String  := "false";
    use_double_data_mode	: String  := "false";
    use_rate_match_fifo		: String  := "false";
    rate_matching_fifo_mode	: String  := "none";
    use_channel_align		: String  := "false";
    use_symbol_align		: String  := "true";
    use_auto_bit_slip		: String  := "false";
    use_parallel_feedback       : String  := "false";
    use_post8b10b_feedback      : String  := "false";
    send_reverse_parallel_feedback : String := "false";
    synchronization_mode	: String  := "none";
    align_pattern		: String  := "0000000000000000";
    align_pattern_length	: integer  := 7;
    infiniband_invalid_code	: integer  := 0;
    disparity_mode		: String  := "false";
    clk_out_mode_reference	: String  := "true";
    cruclk_period		: integer := 5000;
    cruclk_multiplier 		: integer := 4;
    use_cruclk_divider		: String  := "false";
    use_self_test_mode          : String  := "false";
    self_test_mode          : integer  := 0;
    use_equalizer_ctrl_signal   : String  := "false";
    enable_dc_coupling          : String  := "false";
    equalizer_ctrl_setting      : integer := 20;
    signal_threshold_select     : integer := 2;
    vco_bypass                  : String  := "false";
    force_signal_detect         : String  := "false";
    bandwidth_type          : String  := "low";
    for_engineering_sample_device    : String := "true"; -- new in 3.0 SP2 
    TimingChecksOn		: Boolean := True;
    MsgOn			: Boolean := DefGlitchMsgOn;
    XOn				: Boolean := DefGlitchXOn;
    MsgOnChecks			: Boolean := DefMsgOnChecks;
    XOnChecks			: Boolean := DefXOnChecks;
    InstancePath		: String  := "*";
    tipd_datain			: VitalDelayType01 := DefpropDelay01;
    tipd_cruclk			: VitalDelayType01 := DefpropDelay01;
    tipd_pllclk			: VitalDelayType01 := DefpropDelay01;
    tipd_masterclk		: VitalDelayType01 := DefpropDelay01;
    tipd_coreclk		: VitalDelayType01 := DefpropDelay01;
    tipd_softreset		: VitalDelayType01 := DefpropDelay01;
    tipd_serialfdbk		: VitalDelayType01 := DefpropDelay01;
    tipd_analogreset		: VitalDelayType01 := DefpropDelay01;
    tipd_locktorefclk		: VitalDelayType01 := DefpropDelay01;
    tipd_locktodata		: VitalDelayType01 := DefpropDelay01;
    tipd_equalizerctrl          : VitalDelayArrayType01(2 downto 0) := (OTHERS => DefPropDelay01);
    tipd_parallelfdbk           : VitalDelayArrayType01(9 downto 0) := (OTHERS => DefPropDelay01);
    tipd_post8b10b              : VitalDelayArrayType01(9 downto 0) := (OTHERS => DefPropDelay01);
    tipd_slpbk                  : VitalDelayType01 := DefpropDelay01;
    tipd_bitslip		: VitalDelayType01 := DefpropDelay01;
    tipd_a1a2size		: VitalDelayType01 := DefpropDelay01;
    tipd_enacdet		: VitalDelayType01 := DefpropDelay01;
    tipd_we			: VitalDelayType01 := DefpropDelay01;
    tipd_re			: VitalDelayType01 := DefpropDelay01;
    tipd_alignstatus		: VitalDelayType01 := DefpropDelay01;
    tipd_disablefifordin	: VitalDelayType01 := DefpropDelay01;
    tipd_disablefifowrin	: VitalDelayType01 := DefpropDelay01;
    tipd_fifordin		: VitalDelayType01 := DefpropDelay01;
    tipd_enabledeskew		: VitalDelayType01 := DefpropDelay01;
    tipd_fiforesetrd		: VitalDelayType01 := DefpropDelay01;
    tipd_xgmdatain              : VitalDelayArrayType01(7 downto 0) := (OTHERS => DefPropDelay01);
    tipd_xgmctrlin		: VitalDelayType01 := DefpropDelay01;
    tsetup_re_coreclk_noedge_posedge    : VitalDelayType := DefSetupHoldCnst;
    thold_re_coreclk_noedge_posedge     : VitalDelayType := DefSetupHoldCnst;
    tpd_coreclk_dataout_posedge : VitalDelayArrayType01(19 downto 0) := (OTHERS => DefPropDelay01);
    tpd_coreclk_syncstatus_posedge      : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
    tpd_coreclk_patterndetect_posedge   : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
    tpd_coreclk_ctrldetect_posedge      : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
    tpd_coreclk_errdetect_posedge       : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
    tpd_coreclk_disperr_posedge         : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
    tpd_coreclk_a1a2sizeout_posedge     : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
    tpd_coreclk_fifofull_posedge        : VitalDelayType01 := DefPropDelay01;
    tpd_coreclk_fifoempty_posedge       : VitalDelayType01 := DefPropDelay01;
    tpd_coreclk_fifoalmostfull_posedge  : VitalDelayType01 := DefPropDelay01;
    tpd_coreclk_fifoalmostempty_posedge : VitalDelayType01 := DefPropDelay01
    );

  port (
    datain		: in std_logic := '0';
    cruclk		: in std_logic := '0';
    pllclk		: in std_logic := '0';
    masterclk		: in std_logic := '0';
    coreclk		: in std_logic := '0';
    softreset		: in std_logic := '0';
    serialfdbk		: in std_logic := '0';
    parallelfdbk	: in std_logic_vector(9 downto 0) := "0000000000";
    post8b10b		: in std_logic_vector(9 downto 0) := "0000000000";
    slpbk		: in std_logic := '0';
    bitslip		: in std_logic := '0';
    enacdet		: in std_logic := '0';
    we			: in std_logic := '0';
    re			: in std_logic := '0';
    alignstatus		: in std_logic := '0';
    disablefifordin	: in std_logic := '0';
    disablefifowrin	: in std_logic := '0';
    fifordin		: in std_logic := '0';
    enabledeskew	: in std_logic := '0';
    fiforesetrd		: in std_logic := '0';
    xgmdatain		: in std_logic_vector(7 downto 0) := "00000000";
    xgmctrlin		: in std_logic := '0';
    devclrn		: in std_logic := '1';
    devpor		: in std_logic := '1';
    analogreset		: in std_logic := '0';
    a1a2size		: in std_logic := '0';
    locktorefclk	: in std_logic := '0';
    locktodata		: in std_logic := '0';
    equalizerctrl	: in std_logic_vector(2 downto 0) := "000";
    syncstatus		: out std_logic_vector(1 downto 0);
    patterndetect	: out std_logic_vector(1 downto 0);
    ctrldetect		: out std_logic_vector(1 downto 0);
    errdetect		: out std_logic_vector(1 downto 0);
    disperr		: out std_logic_vector(1 downto 0);
    syncstatusdeskew	: out std_logic;
    adetectdeskew	: out std_logic;
    rdalign		: out std_logic;
    dataout		: out std_logic_vector(19 downto 0);
    xgmdataout		: out std_logic_vector(7 downto 0);
    xgmctrldet		: out std_logic;
    xgmrunningdisp	: out std_logic;
    xgmdatavalid	: out std_logic;
    fifofull		: out std_logic;
    fifoalmostfull	: out std_logic;
    fifoempty		: out std_logic;
    fifoalmostempty	: out std_logic;
    disablefifordout	: out std_logic;
    disablefifowrout	: out std_logic;
    fifordout		: out std_logic;
    signaldetect	: out std_logic;
    lock		: out std_logic;
    freqlock		: out std_logic;
    rlv			: out std_logic;
    clkout		: out std_logic;
    recovclkout		: out std_logic;
    bisterr             : out std_logic := '0';
    bistdone            : out std_logic := '1';
    a1a2sizeout         : out std_logic_vector(1 downto 0) 
    );
end stratixgx_hssi_receiver;

architecture vital_receiver_atom of stratixgx_hssi_receiver is
  signal datain_ipd : std_logic;
  signal cruclk_ipd  : std_logic;
  signal pllclk_ipd  : std_logic;
  signal masterclk_ipd  : std_logic;
  signal coreclk_ipd  : std_logic;
  signal softreset_ipd	: std_logic := '0';
  signal serialfdbk_ipd : std_logic := '0';
  signal analogreset_ipd : std_logic := '0';
  signal locktorefclk_ipd : std_logic := '0';
  signal locktodata_ipd : std_logic := '0';
  signal equalizerctrl_ipd : std_logic_vector(2 downto 0);
  signal parallelfdbk_ipd  : std_logic_vector(9 downto 0);
  signal post8b10b_ipd	: std_logic_vector(9 downto 0);
  signal slpbk_ipd : std_logic := '0';
  signal bitslip_ipd : std_logic := '0';
  signal a1a2size_ipd : std_logic := '0';
  signal enacdet_ipd : std_logic := '0';
  signal we_ipd: std_logic := '0';
  signal re_ipd : std_logic := '0';
  signal alignstatus_ipd : std_logic := '0';
  signal disablefifordin_ipd : std_logic := '0';
  signal disablefifowrin_ipd : std_logic := '0';
  signal fifordin_ipd : std_logic := '0';
  signal enabledeskew_ipd : std_logic := '0';
  signal fiforesetrd_ipd : std_logic := '0';
  signal xgmdatain_ipd : std_logic_vector(7 downto 0);
  signal xgmctrlin_ipd : std_logic := '0';
  
  signal clkout_tmp : std_logic;
  signal dataout_tmp : std_logic_vector(19 downto 0);
  
  --constant signals
  signal vcc : std_logic := '1';
  signal gnd : std_logic := '0';
  signal idle_bus : std_logic_vector(9 downto 0) := "0000000000";

  --lower lever softreset 
  signal reset_int : std_logic;
  
  -- serdes output signals
  signal serdes_clkout : std_logic; --receovered clock
  signal serdes_rlv : std_logic;
  signal serdes_signaldetect : std_logic;
  signal serdes_lock : std_logic;
  signal serdes_freqlock : std_logic;
  signal serdes_dataout : std_logic_vector(9 downto 0);

  -- word aligner input/output signals
  signal wa_datain : std_logic_vector(9 downto 0);
  signal wa_clk : std_logic;
  signal wa_enacdet : std_logic;
  signal wa_bitslip : std_logic;
  signal wa_a1a2size : std_logic;
  
  signal wa_aligneddata : std_logic_vector(9 downto 0);
  signal wa_aligneddatapre : std_logic_vector(9 downto 0);
  signal wa_invalidcode : std_logic;
  signal wa_invalidcodepre : std_logic;
  signal wa_disperr : std_logic;
  signal wa_disperrpre : std_logic;
  signal wa_patterndetect : std_logic;
  signal wa_patterndetectpre : std_logic;
  signal wa_syncstatus : std_logic;
  signal wa_syncstatusdeskew : std_logic;

  -- deskew FIFO input/output signals
  signal dsfifo_datain : std_logic_vector(9 downto 0);     
  signal dsfifo_errdetectin : std_logic;
  signal dsfifo_syncstatusin : std_logic;
  signal dsfifo_disperrin : std_logic; 
  signal dsfifo_patterndetectin : std_logic; 
  signal dsfifo_writeclock : std_logic;
  signal dsfifo_readclock : std_logic; 
  signal dsfifo_fiforesetrd : std_logic; 
  signal dsfifo_enabledeskew : std_logic;
  
  signal dsfifo_dataout : std_logic_vector(9 downto 0); 
  signal dsfifo_dataoutpre : std_logic_vector(9 downto 0); 
  signal dsfifo_errdetect : std_logic;   
  signal dsfifo_syncstatus : std_logic; 
  signal dsfifo_disperr : std_logic;    
  signal dsfifo_patterndetect : std_logic; 
  signal dsfifo_errdetectpre : std_logic;   
  signal dsfifo_syncstatuspre : std_logic; 
  signal dsfifo_disperrpre : std_logic;    
  signal dsfifo_patterndetectpre : std_logic; 
  signal dsfifo_adetectdeskew : std_logic;
  signal dsfifo_rdalign : std_logic;     
   
  -- comp FIFO input/output signals
  signal cmfifo_datain : std_logic_vector(9 downto 0);
  signal cmfifo_datainpre : std_logic_vector(9 downto 0);
  signal cmfifo_invalidcodein : std_logic; 
  signal cmfifo_invalidcodeinpre : std_logic; 
  signal cmfifo_disperrin : std_logic;  
  signal cmfifo_disperrinpre : std_logic;  
  signal cmfifo_patterndetectin : std_logic;
  signal cmfifo_patterndetectinpre : std_logic;
  signal cmfifo_syncstatusin : std_logic;
  signal cmfifo_syncstatusinpre : std_logic;
  signal cmfifo_writeclk : std_logic;      
  signal cmfifo_readclk : std_logic;      
  signal cmfifo_alignstatus : std_logic;
  signal cmfifo_re : std_logic;
  signal cmfifo_we : std_logic;
  signal cmfifo_fifordin : std_logic;
  signal cmfifo_disablefifordin : std_logic; 
  signal cmfifo_disablefifowrin : std_logic;
  
  signal cmfifo_dataout : std_logic_vector(9 downto 0); 
  signal cmfifo_invalidcode : std_logic;
  signal cmfifo_syncstatus : std_logic;
  signal cmfifo_disperr : std_logic;
  signal cmfifo_patterndetect : std_logic;
  signal cmfifo_datavalid : std_logic;
  signal cmfifo_fifofull : std_logic;
  signal cmfifo_fifoalmostfull : std_logic;
  signal cmfifo_fifoempty : std_logic;
  signal cmfifo_fifoalmostempty : std_logic;
  signal cmfifo_disablefifordout : std_logic;
  signal cmfifo_disablefifowrout : std_logic;
  signal cmfifo_fifordout : std_logic;

  -- 8B10B decode input/output signals
  signal decoder_clk : std_logic; 
  signal decoder_datain : std_logic_vector(9 downto 0);   
  signal decoder_errdetectin : std_logic;         
  signal decoder_syncstatusin : std_logic;         
  signal decoder_disperrin : std_logic;         
  signal decoder_patterndetectin : std_logic;         
  signal decoder_indatavalid : std_logic;         
   
  signal decoder_dataout : std_logic_vector(7 downto 0); 
  signal decoder_tenBdata : std_logic_vector(9 downto 0); 
  signal decoder_valid : std_logic;         
  signal decoder_errdetect : std_logic;         
  signal decoder_syncstatus : std_logic;         
  signal decoder_disperr : std_logic;         
  signal decoder_patterndetect : std_logic;         
  signal decoder_rderr : std_logic;         
  signal decoder_decdatavalid : std_logic;    
  signal decoder_ctrldetect : std_logic;   
  signal decoder_xgmdatavalid : std_logic;   
  signal decoder_xgmrunningdisp : std_logic;   
  signal decoder_xgmctrldet : std_logic;   
  signal decoder_xgmdataout : std_logic_vector(7 downto 0); 

  -- rx_core input/output signals
  signal core_datain : std_logic_vector(9 downto 0);
  signal core_writeclk : std_logic;   
  signal core_readclk : std_logic;   
  signal core_decdatavalid : std_logic;   
  signal core_xgmdatain : std_logic_vector(7 downto 0);
  signal core_xgmctrlin : std_logic;   
  signal core_post8b10b : std_logic_vector(9 downto 0);   
  signal core_syncstatusin : std_logic;   
  signal core_errdetectin: std_logic;   
  signal core_ctrldetectin: std_logic;   
  signal core_disparityerrin: std_logic;   
  signal core_patterndetectin: std_logic;   

  signal core_dataout : std_logic_vector(19 downto 0);
  signal core_clkout : std_logic;   
  signal core_syncstatus : std_logic_vector(1 downto 0);   
  signal core_errdetect : std_logic_vector(1 downto 0);   
  signal core_ctrldetect : std_logic_vector(1 downto 0);   
  signal core_disparityerr : std_logic_vector(1 downto 0);   
  signal core_patterndetect : std_logic_vector(1 downto 0);   
  signal core_a1a2sizeout : std_logic_vector(1 downto 0);   

  -- clkout mux output
  -- added gfifo
  signal clkoutmux_clkout     : std_logic;
  signal clkoutmux_clkout_pre : std_logic;

  -- MAIN CLOCKS
  SIGNAL rxrdclk_mux1             :  std_logic;   
  SIGNAL rxrdclk_mux1_by2         :  std_logic;   
  SIGNAL rxrdclkmux1_c0           :  std_logic;   
  SIGNAL rxrdclkmux1_c1           :  std_logic;   
  SIGNAL rxrdclkmux2_c0           :  std_logic;   
  SIGNAL rxrdclkmux2_c1           :  std_logic;  
  
  SIGNAL clk2_mux1                :  std_logic;   
  SIGNAL clk2mux1_c0              :  std_logic;   
  SIGNAL clk2mux1_c1              :  std_logic;   
  
  SIGNAL rcvd_clk                 :  std_logic;   
  SIGNAL clk_1                    :  std_logic;   
  SIGNAL clk_2                    :  std_logic;   
  SIGNAL rx_rd_clk                :  std_logic;   
  SIGNAL rx_rd_clk_mux            :  std_logic;  

-- sub module componet declaration
component stratixgx_hssi_rx_serdes 
  generic (
    channel_width	: integer := 10;
    rlv_length		: integer := 1;
    run_length_enable	: String := "false";
    cruclk_period	: integer :=5000; 
    cruclk_multiplier	: integer :=4; 
    use_cruclk_divider	: String := "false";
    use_double_data_mode :  string  := "false"    
    );
  
  port (
    datain		: in std_logic := '0';
    cruclk		: in std_logic := '0';
    areset		: in std_logic := '0';
    feedback		: in std_logic := '0';
    fbkcntl		: in std_logic := '0';
    ltr		    : in std_logic := '0';
    ltd		    : in std_logic := '0';
    dataout		: out std_logic_vector(9 downto 0);
    clkout		: out std_logic;
    rlv			: out std_logic;
    lock		: out std_logic;
    freqlock		: out std_logic;
    signaldetect        : out std_logic
    );

end component;

component stratixgx_hssi_word_aligner 
  generic	(
    channel_width       : integer := 10;
    align_pattern_length: integer := 10;
    infiniband_invalid_code : integer := 0;
    align_pattern 	: string := "0000000101111100";
    synchronization_mode: string := "XAUI";
    use_8b_10b_mode	: string := "true";
    use_auto_bit_slip   : string := "true"
    );
  port	(
    datain		: in std_logic_vector(9 downto 0) := "0000000000"; 
    clk			: in std_logic := '0'; 
    softreset		: in std_logic := '0'; 
    enacdet		: in std_logic := '0'; 
    bitslip		: in std_logic := '0'; 
    a1a2size		: in std_logic := '0'; 
    aligneddata		: out std_logic_vector(9 downto 0); 
    aligneddatapre	: out std_logic_vector(9 downto 0); 
    invalidcode		: out std_logic;
    invalidcodepre	: out std_logic;
    syncstatus		: out std_logic;
    syncstatusdeskew	: out std_logic;
    disperr		: out std_logic;
    disperrpre		: out std_logic;
    patterndetect	: out std_logic;
    patterndetectpre	: out std_logic
    );

end component;

component stratixgx_deskew_fifo
  port 
	(
    datain        : IN std_logic_vector(9 DOWNTO 0) := "0000000000";   
    errdetectin   : IN std_logic := '0';   
    syncstatusin  : IN std_logic := '0';   
    disperrin     : IN std_logic := '0';   
    patterndetectin : IN std_logic := '0';   
    writeclock	  : IN std_logic := '0';   
    readclock	  : IN std_logic := '0';   
    adetectdeskew : OUT std_logic := '0';  
    fiforesetrd   : IN std_logic := '0';   
    enabledeskew  : IN std_logic := '0';   
    reset         : IN std_logic := '0';   
    dataout       : OUT std_logic_vector(9 DOWNTO 0) := "0000000000";   
    dataoutpre    : OUT std_logic_vector(9 DOWNTO 0) := "0000000000";   
    errdetect     : OUT std_logic := '0';   
    syncstatus    : OUT std_logic := '0';   
    disperr       : OUT std_logic := '0';   
    patterndetect : OUT std_logic := '0';   
    errdetectpre  : OUT std_logic := '0';   
    syncstatuspre : OUT std_logic := '0';   
    disperrpre    : OUT std_logic := '0';   
    patterndetectpre : OUT std_logic := '0';   
    rdalign       : OUT std_logic := '0'
    );  

end component;

component stratixgx_comp_fifo
  GENERIC (
    use_rate_match_fifo     : string  := "true";
    rate_matching_fifo_mode : string  := "xaui";
    use_channel_align       : string  := "true";
    for_engineering_sample_device    : String := "true"; -- new in 3.0 SP2 
    channel_num             : integer := 0
    );
   port (
     datain                  : IN std_logic_vector(9 DOWNTO 0);   
     datainpre               : IN std_logic_vector(9 DOWNTO 0);   
     reset                   : IN std_logic;   
     errdetectin             : IN std_logic;   
     syncstatusin            : IN std_logic;   
     disperrin               : IN std_logic;   
     patterndetectin         : IN std_logic;   
     errdetectinpre          : IN std_logic;   
     syncstatusinpre         : IN std_logic;   
     disperrinpre            : IN std_logic;   
     patterndetectinpre      : IN std_logic;   
     writeclk                : IN std_logic;   
     readclk                 : IN std_logic;   
     re                      : IN std_logic;   
     we                      : IN std_logic;   
     fifordin                : IN std_logic;   
     disablefifordin         : IN std_logic;   
     disablefifowrin         : IN std_logic;   
     alignstatus             : IN std_logic;   
     dataout                 : OUT std_logic_vector(9 DOWNTO 0);   
     errdetectout            : OUT std_logic;   
     syncstatus              : OUT std_logic;   
     disperr                 : OUT std_logic;   
     patterndetect	      : OUT std_logic;   
     codevalid               : OUT std_logic;   
     fifofull                : OUT std_logic;   
     fifoalmostful           : OUT std_logic;   
     fifoempty               : OUT std_logic;   
     fifoalmostempty         : OUT std_logic;   
     disablefifordout        : OUT std_logic;   
     disablefifowrout        : OUT std_logic;   
     fifordout               : OUT std_logic
     );   

end component;

component stratixgx_8b10b_decoder 
  port (
    clk         : in std_logic := '0'; 
    reset       : in std_logic := '0'; -- reset the decoder
    errdetectin : in std_logic := '0';
    syncstatusin: in std_logic := '0';
    disperrin   : in std_logic := '0';
    patterndetectin : in std_logic := '0';
    datainvalid : in std_logic := '0';
    datain      : in std_logic_vector(9 downto 0) := "0000000000"; 
    valid       : out std_logic := '1'; -- valid decode
    dataout     : out std_logic_vector(7 downto 0) := "00000000";  
    tenBdata    : OUT std_logic_vector(9 DOWNTO 0) := "0000000000";   
    errdetect   : out std_logic := '0';
    syncstatus  : out std_logic := '0';
    disperr     : out std_logic := '0';
    patterndetect : out std_logic := '0';
    kout        : out std_logic := '0'; -- high if decode of control word 
    rderr       : out std_logic := '0'; -- running disparity error
    decdatavalid: out std_logic := '0';
    xgmdatavalid: out std_logic := '0';
    xgmrunningdisp : out std_logic := '0';
    xgmctrldet  : out std_logic := '0';
    xgmdataout  : out std_logic_vector(7 downto 0) := "00000000"
    );
end component;

component stratixgx_rx_core
   GENERIC (
      channel_width                  :  integer := 10;    
      use_double_data_mode           :  string  := "false";    
      use_channel_align              :  string  := "false";    
      use_8b_10b_mode                :  string  := "true";    
      align_pattern						 :  string  := "0000000000000000";
      synchronization_mode           :  string  := "none");
   PORT (
      reset                   : IN std_logic;   
      writeclk                : IN std_logic;   
      readclk                 : IN std_logic;   
      errdetectin             : IN std_logic;   
      patterndetectin         : IN std_logic;   
      decdatavalid            : IN std_logic;   
      xgmdatain               : IN std_logic_vector(7 DOWNTO 0);   
      post8b10b               : IN std_logic_vector(9 DOWNTO 0);   
      datain                  : IN std_logic_vector(9 DOWNTO 0);   
      xgmctrlin               : IN std_logic;   
      ctrldetectin            : IN std_logic;   
      syncstatusin            : IN std_logic;   
      disparityerrin          : IN std_logic;   
      syncstatus              : OUT std_logic_vector(1 DOWNTO 0);   
      errdetect               : OUT std_logic_vector(1 DOWNTO 0);   
      ctrldetect              : OUT std_logic_vector(1 DOWNTO 0);   
      disparityerr            : OUT std_logic_vector(1 DOWNTO 0);   
      patterndetect           : OUT std_logic_vector(1 DOWNTO 0);   
      dataout                 : OUT std_logic_vector(19 DOWNTO 0);   
      a1a2sizeout             : OUT std_logic_vector(1 DOWNTO 0);   
      clkout                  : OUT std_logic);   
end component;

component stratixgx_hssi_mux4 
   PORT (
      Y                       : OUT std_logic;   
      I0                      : IN std_logic;   
      I1                      : IN std_logic;   
      I2                      : IN std_logic;   
      I3                      : IN std_logic;   
      C0                      : IN std_logic;   
      C1                      : IN std_logic);   
END component;

component stratixgx_hssi_divide_by_two 
  GENERIC (
    divide                  :  string := "true");
  PORT (
    reset                   : IN std_logic := '0';   
    clkin                   : IN std_logic;   
    clkout                  : OUT std_logic);   
END component;

-- end of sub module componet declaration

begin
	----------------------
	--  INPUT PATH DELAYs
	----------------------
	WireDelay : block
	begin
		VitalWireDelay (datain_ipd, datain, tipd_datain);
		VitalWireDelay (cruclk_ipd, cruclk, tipd_cruclk);
		VitalWireDelay (pllclk_ipd, pllclk, tipd_pllclk);
		VitalWireDelay (masterclk_ipd, masterclk, tipd_masterclk);
		VitalWireDelay (coreclk_ipd, coreclk, tipd_coreclk);
		VitalWireDelay (softreset_ipd, softreset, tipd_softreset);
		VitalWireDelay (serialfdbk_ipd, serialfdbk, tipd_serialfdbk);
		VitalWireDelay (analogreset_ipd, analogreset, tipd_analogreset);
		VitalWireDelay (locktorefclk_ipd, locktorefclk, tipd_locktorefclk);
		VitalWireDelay (locktodata_ipd, locktodata, tipd_locktodata);

		VitalWireDelay (equalizerctrl_ipd(0), equalizerctrl(0), tipd_equalizerctrl(0));
		VitalWireDelay (equalizerctrl_ipd(1), equalizerctrl(1), tipd_equalizerctrl(1));
		VitalWireDelay (equalizerctrl_ipd(2), equalizerctrl(2), tipd_equalizerctrl(2));

		VitalWireDelay (parallelfdbk_ipd(0), parallelfdbk(0), tipd_parallelfdbk(0));
		VitalWireDelay (parallelfdbk_ipd(1), parallelfdbk(1), tipd_parallelfdbk(1));
		VitalWireDelay (parallelfdbk_ipd(2), parallelfdbk(2), tipd_parallelfdbk(2));
		VitalWireDelay (parallelfdbk_ipd(3), parallelfdbk(3), tipd_parallelfdbk(3));
		VitalWireDelay (parallelfdbk_ipd(4), parallelfdbk(4), tipd_parallelfdbk(4));
		VitalWireDelay (parallelfdbk_ipd(5), parallelfdbk(5), tipd_parallelfdbk(5));
		VitalWireDelay (parallelfdbk_ipd(6), parallelfdbk(6), tipd_parallelfdbk(6));
		VitalWireDelay (parallelfdbk_ipd(7), parallelfdbk(7), tipd_parallelfdbk(7));
		VitalWireDelay (parallelfdbk_ipd(8), parallelfdbk(8), tipd_parallelfdbk(8));
		VitalWireDelay (parallelfdbk_ipd(9), parallelfdbk(9), tipd_parallelfdbk(9));

		VitalWireDelay (post8b10b_ipd(0), post8b10b(0), tipd_post8b10b(0));
		VitalWireDelay (post8b10b_ipd(1), post8b10b(1), tipd_post8b10b(1));
		VitalWireDelay (post8b10b_ipd(2), post8b10b(2), tipd_post8b10b(2));
		VitalWireDelay (post8b10b_ipd(3), post8b10b(3), tipd_post8b10b(3));
		VitalWireDelay (post8b10b_ipd(4), post8b10b(4), tipd_post8b10b(4));
		VitalWireDelay (post8b10b_ipd(5), post8b10b(5), tipd_post8b10b(5));
		VitalWireDelay (post8b10b_ipd(6), post8b10b(6), tipd_post8b10b(6));
		VitalWireDelay (post8b10b_ipd(7), post8b10b(7), tipd_post8b10b(7));
                VitalWireDelay (post8b10b_ipd(8), post8b10b(8), tipd_post8b10b(8));
                VitalWireDelay (post8b10b_ipd(9), post8b10b(9), tipd_post8b10b(9));

		VitalWireDelay (slpbk_ipd, slpbk, tipd_slpbk);
		VitalWireDelay (bitslip_ipd, bitslip, tipd_bitslip);
		VitalWireDelay (a1a2size_ipd, a1a2size, tipd_a1a2size);
		VitalWireDelay (enacdet_ipd, enacdet, tipd_enacdet);
		VitalWireDelay (we_ipd, we, tipd_we);
		VitalWireDelay (re_ipd, re, tipd_re);
		VitalWireDelay (alignstatus_ipd, alignstatus, tipd_alignstatus);
		VitalWireDelay (disablefifordin_ipd, disablefifordin, tipd_disablefifordin);
		VitalWireDelay (disablefifowrin_ipd, disablefifowrin, tipd_disablefifowrin);
		VitalWireDelay (fifordin_ipd, fifordin, tipd_fifordin);
		VitalWireDelay (enabledeskew_ipd, enabledeskew, tipd_enabledeskew);
		VitalWireDelay (fiforesetrd_ipd, fiforesetrd, tipd_fiforesetrd);

		VitalWireDelay (xgmdatain_ipd(0), xgmdatain(0), tipd_xgmdatain(0));
		VitalWireDelay (xgmdatain_ipd(1), xgmdatain(1), tipd_xgmdatain(1));
		VitalWireDelay (xgmdatain_ipd(2), xgmdatain(2), tipd_xgmdatain(2));
		VitalWireDelay (xgmdatain_ipd(3), xgmdatain(3), tipd_xgmdatain(3));
		VitalWireDelay (xgmdatain_ipd(4), xgmdatain(4), tipd_xgmdatain(4));
		VitalWireDelay (xgmdatain_ipd(5), xgmdatain(5), tipd_xgmdatain(5));
		VitalWireDelay (xgmdatain_ipd(6), xgmdatain(6), tipd_xgmdatain(6));
		VitalWireDelay (xgmdatain_ipd(7), xgmdatain(7), tipd_xgmdatain(7));
		VitalWireDelay (xgmctrlin_ipd, xgmctrlin, tipd_xgmctrlin);
	end block;

-- generate internal inut signals

reset_int <= softreset_ipd;

-- word_align inputs
wa_datain  <= parallelfdbk when (use_parallel_feedback = "true") else serdes_dataout;
wa_clk     <= rcvd_clk;
wa_enacdet <= enacdet_ipd; 
wa_bitslip <= bitslip_ipd; 
wa_a1a2size <= a1a2size_ipd; 

-- deskew FIFO inputs
dsfifo_datain       <= wa_aligneddata WHEN (use_symbol_align = "true") ELSE idle_bus;     
dsfifo_errdetectin  <= wa_invalidcode WHEN (use_symbol_align = "true") ELSE '0';   
dsfifo_syncstatusin <= wa_syncstatus WHEN (use_symbol_align = "true") ELSE '1';  
dsfifo_disperrin    <= wa_disperr WHEN (use_symbol_align = "true") ELSE '0';
dsfifo_patterndetectin <= wa_patterndetect WHEN (use_symbol_align = "true") ELSE '0';
dsfifo_writeclock   <= rcvd_clk;
dsfifo_readclock    <= clk_1;
dsfifo_fiforesetrd  <= fiforesetrd_ipd; 
dsfifo_enabledeskew <= enabledeskew_ipd;

-- comp FIFO inputs
cmfifo_datain <= dsfifo_dataout WHEN (use_channel_align = "true") ELSE wa_aligneddata WHEN (use_symbol_align = "true") ELSE serdes_dataout;

cmfifo_datainpre <= dsfifo_dataoutpre WHEN (use_channel_align = "true") ELSE wa_aligneddatapre WHEN (use_symbol_align = "true") ELSE idle_bus;

cmfifo_invalidcodein <= dsfifo_errdetect WHEN (use_channel_align = "true") ELSE wa_invalidcode WHEN (use_symbol_align = "true") ELSE '0';

cmfifo_syncstatusin <= dsfifo_syncstatus WHEN (use_channel_align = "true") ELSE wa_syncstatus WHEN (use_symbol_align = "true") ELSE '1';

cmfifo_disperrin <= dsfifo_disperr WHEN (use_channel_align = "true") ELSE wa_disperr WHEN (use_symbol_align = "true") ELSE '0';

cmfifo_patterndetectin <= dsfifo_patterndetect WHEN (use_channel_align = "true") ELSE wa_patterndetect WHEN (use_symbol_align = "true") ELSE '1';

cmfifo_invalidcodeinpre <= dsfifo_errdetectpre WHEN (use_channel_align = "true") ELSE wa_invalidcodepre WHEN (use_symbol_align = "true") ELSE '0';

cmfifo_syncstatusinpre <= dsfifo_syncstatuspre WHEN (use_channel_align = "true") ELSE wa_syncstatusdeskew WHEN (use_symbol_align = "true") ELSE '1';

cmfifo_disperrinpre <= dsfifo_disperrpre WHEN (use_channel_align = "true") ELSE wa_disperrpre WHEN (use_symbol_align = "true") ELSE '0';

cmfifo_patterndetectinpre <= dsfifo_patterndetectpre WHEN (use_channel_align = "true") ELSE wa_patterndetectpre WHEN (use_symbol_align = "true") ELSE '0';

cmfifo_writeclk <= clk_1;

cmfifo_readclk <=  clk_2;

cmfifo_alignstatus <= alignstatus_ipd;
cmfifo_re <= re_ipd;
cmfifo_we <= we_ipd;
cmfifo_fifordin <= fifordin_ipd;
cmfifo_disablefifordin <= disablefifordin_ipd; 
cmfifo_disablefifowrin <= disablefifowrin_ipd;

-- 8B10B decoder inputs
decoder_clk  <= clk_2;
decoder_datain <= cmfifo_dataout WHEN (use_rate_match_fifo = "true") ELSE dsfifo_dataout WHEN (use_channel_align = "true") ELSE wa_aligneddata WHEN (use_symbol_align = "true") ELSE serdes_dataout;   

decoder_errdetectin <= cmfifo_invalidcode WHEN (use_rate_match_fifo = "true") ELSE dsfifo_errdetect WHEN (use_channel_align = "true") ELSE wa_invalidcode WHEN (use_symbol_align = "true") ELSE '0';   

decoder_syncstatusin <= cmfifo_syncstatus WHEN (use_rate_match_fifo = "true") ELSE dsfifo_syncstatus WHEN (use_channel_align = "true") ELSE wa_syncstatus WHEN (use_symbol_align = "true") ELSE '1';   

decoder_disperrin <= cmfifo_disperr WHEN (use_rate_match_fifo = "true") ELSE dsfifo_disperr WHEN (use_channel_align = "true") ELSE wa_disperr WHEN (use_symbol_align = "true") ELSE '0';   

decoder_patterndetectin <= cmfifo_patterndetect WHEN (use_rate_match_fifo = "true") ELSE dsfifo_patterndetect WHEN (use_channel_align = "true") ELSE wa_patterndetect WHEN (use_symbol_align = "true") ELSE '0';   

decoder_indatavalid <= cmfifo_datavalid WHEN (use_rate_match_fifo = "true") ELSE '1';   

-- rx_core inputs
core_datain <= post8b10b when (use_post8b10b_feedback = "true") else ("00" & decoder_dataout) WHEN (use_8b_10b_mode = "true") ELSE decoder_tenBdata;
core_writeclk <= clk_2;
core_readclk <= rx_rd_clk;
core_decdatavalid <= decoder_decdatavalid WHEN (use_8b_10b_mode = "true") ELSE '1'; 
core_xgmdatain <= xgmdatain_ipd;
core_xgmctrlin <= xgmctrlin_ipd;
core_post8b10b <= post8b10b_ipd;
core_syncstatusin <= decoder_syncstatus;
core_errdetectin <= decoder_errdetect;
core_ctrldetectin <= decoder_ctrldetect;
core_disparityerrin <= decoder_disperr;
core_patterndetectin <= decoder_patterndetect;

   rcvd_clk <= pllclk_ipd WHEN (use_parallel_feedback = "true") ELSE serdes_clkout ;
   clk_1 <= pllclk_ipd WHEN (use_parallel_feedback = "true") ELSE masterclk_ipd WHEN (use_channel_align = "true") ELSE serdes_clkout ;
   
   -- added gfifo
   clk_2 <= coreclk_ipd WHEN (clk_out_mode_reference = "false") ELSE clk2_mux1 ;
   rx_rd_clk <= coreclk_ipd WHEN (clk_out_mode_reference = "false") ELSE rx_rd_clk_mux ;

clk2mux1 : stratixgx_hssi_mux4 
      PORT MAP (
         Y => clk2_mux1,
         I0 => serdes_clkout,
         I1 => masterclk_ipd,
         I2 => gnd,
         I3 => pllclk_ipd,
         C0 => clk2mux1_c0,
         C1 => clk2mux1_c1);   
   
   clk2mux1_c0 <= '1' WHEN (use_parallel_feedback = "true") OR (use_channel_align = "true") OR (use_rate_match_fifo = "true") ELSE '0' ;
   clk2mux1_c1 <= '1' WHEN (use_parallel_feedback = "true") OR (use_rate_match_fifo = "true") ELSE '0' ;

   rxrdclkmux1 : stratixgx_hssi_mux4 
      PORT MAP (
         Y => rxrdclk_mux1,
         I0 => serdes_clkout,
         I1 => masterclk_ipd,
         I2 => gnd,
         I3 => pllclk_ipd,
         C0 => rxrdclkmux1_c0,
         C1 => rxrdclkmux1_c1);   

   rxrdclkmux1_c1 <= '1' WHEN (use_parallel_feedback = "true") OR (use_rate_match_fifo = "true") ELSE '0' ;
   rxrdclkmux1_c0 <= '1' WHEN (use_parallel_feedback = "true") OR (use_channel_align = "true") OR (use_rate_match_fifo = "true") ELSE '0' ;

   rxrdclkmux2 : stratixgx_hssi_mux4 
      PORT MAP (
         Y => rx_rd_clk_mux,
         I0 => coreclk_ipd,
         I1 => gnd,
         I2 => rxrdclk_mux1_by2,
         I3 => rxrdclk_mux1,
         C0 => rxrdclkmux2_c0,
         C1 => rxrdclkmux2_c1);   
   
   rxrdclkmux2_c1 <= '1' WHEN (send_reverse_parallel_feedback = "true") ELSE '0' ;
   rxrdclkmux2_c0 <= '1' WHEN ((use_double_data_mode = "false") AND (send_reverse_parallel_feedback = "true")) ELSE '0' ;

   rxrdclkmux_by2 : stratixgx_hssi_divide_by_two 
      GENERIC MAP (
         divide => use_double_data_mode)
      PORT MAP (
         clkin => rxrdclk_mux1,
         clkout => rxrdclk_mux1_by2);   

-- sub modules
s_rx_serdes :	stratixgx_hssi_rx_serdes
					generic map (
									channel_width => deserialization_factor,
									rlv_length => run_length,
									run_length_enable => run_length_enable,
									cruclk_period => cruclk_period,
									cruclk_multiplier => cruclk_multiplier,
	                        use_cruclk_divider => use_cruclk_divider,
                           use_double_data_mode => use_double_data_mode
									)
					port map (
								datain => datain,
							 	cruclk => cruclk,
								areset => analogreset_ipd,
								feedback => serialfdbk,
								fbkcntl => slpbk,
                                ltr => locktorefclk,
                                ltd => locktodata,
								dataout => serdes_dataout,
								clkout => serdes_clkout,
								rlv => serdes_rlv,
								lock => serdes_lock,
								freqlock => serdes_freqlock,
								signaldetect => serdes_signaldetect
								);
				
s_word_align :	stratixgx_hssi_word_aligner
  generic map	(
    channel_width => deserialization_factor,
    align_pattern_length => align_pattern_length,
    infiniband_invalid_code => infiniband_invalid_code,
    align_pattern => align_pattern,
    synchronization_mode => synchronization_mode,
    use_auto_bit_slip => use_auto_bit_slip
    )
  port map	(	
    datain => wa_datain, 
    clk => wa_clk, 
    softreset => reset_int, 
    enacdet => wa_enacdet, 
    bitslip => wa_bitslip, 
    a1a2size => wa_a1a2size, 
    aligneddata => wa_aligneddata, 
    aligneddatapre => wa_aligneddatapre, 
    invalidcode => wa_invalidcode, 
    invalidcodepre => wa_invalidcodepre, 
    syncstatus => wa_syncstatus, 
    syncstatusdeskew => wa_syncstatusdeskew, 
    disperr => wa_disperr, 
    disperrpre => wa_disperrpre, 
    patterndetect => wa_patterndetect,
    patterndetectpre => wa_patterndetectpre
    );

s_dsfifo :	stratixgx_deskew_fifo 
  port map	(
    datain => dsfifo_datain,
    errdetectin => dsfifo_errdetectin,
    syncstatusin => dsfifo_syncstatusin,
    disperrin => dsfifo_disperrin,   
    patterndetectin => dsfifo_patterndetectin,
    writeclock => dsfifo_writeclock,  
    readclock => dsfifo_readclock,   
    adetectdeskew => dsfifo_adetectdeskew,
    fiforesetrd => dsfifo_fiforesetrd,
    enabledeskew => dsfifo_enabledeskew,
    reset => reset_int,
    dataout => dsfifo_dataout,   
    dataoutpre => dsfifo_dataoutpre,   
    errdetect => dsfifo_errdetect,    
    syncstatus => dsfifo_syncstatus,
    disperr => dsfifo_disperr,
    patterndetect => dsfifo_patterndetect,
    errdetectpre => dsfifo_errdetectpre,    
    syncstatuspre => dsfifo_syncstatuspre,
    disperrpre => dsfifo_disperrpre,
    patterndetectpre => dsfifo_patterndetectpre,
    rdalign => dsfifo_rdalign
    );

s_cmfifo :	stratixgx_comp_fifo
  generic map (
    use_rate_match_fifo     => use_rate_match_fifo,
    rate_matching_fifo_mode => rate_matching_fifo_mode,
    use_channel_align       => use_channel_align,
    for_engineering_sample_device  => for_engineering_sample_device, -- new in 3.0 SP2 
    channel_num             => channel_num
    )
  port map (
    datain => cmfifo_datain,
    datainpre => cmfifo_datainpre,
    reset => reset_int,
    errdetectin => cmfifo_invalidcodein, 
    syncstatusin => cmfifo_syncstatusin,
    disperrin => cmfifo_disperrin,
    patterndetectin => cmfifo_patterndetectin,
    errdetectinpre => cmfifo_invalidcodeinpre, 
    syncstatusinpre => cmfifo_syncstatusinpre,
    disperrinpre => cmfifo_disperrinpre,
    patterndetectinpre => cmfifo_patterndetectinpre,
    writeclk => cmfifo_writeclk,
    readclk => cmfifo_readclk,
    re => cmfifo_re,
    we => cmfifo_we,
    fifordin => cmfifo_fifordin,
    disablefifordin => cmfifo_disablefifordin,
    disablefifowrin => cmfifo_disablefifowrin,
    alignstatus => cmfifo_alignstatus,
    dataout => cmfifo_dataout,
    errdetectout => cmfifo_invalidcode,
    syncstatus => cmfifo_syncstatus,
    disperr => cmfifo_disperr,
    patterndetect => cmfifo_patterndetect,
    codevalid => cmfifo_datavalid,
    fifofull => cmfifo_fifofull,
    fifoalmostful => cmfifo_fifoalmostfull,
    fifoempty => cmfifo_fifoempty,
    fifoalmostempty => cmfifo_fifoalmostempty,
    disablefifordout => cmfifo_disablefifordout,
    disablefifowrout => cmfifo_disablefifowrout,
    fifordout => cmfifo_fifordout
    );

s_decoder :	stratixgx_8b10b_decoder
  port map	( 
    clk => decoder_clk, 
    reset => reset_int, 
    errdetectin => decoder_errdetectin, 
    syncstatusin => decoder_syncstatusin, 
    disperrin => decoder_disperrin, 
    patterndetectin => decoder_patterndetectin, 
    datainvalid => decoder_indatavalid, 
    datain => decoder_datain, 
    valid => decoder_valid, 
    dataout => decoder_dataout,
    tenBdata => decoder_tenBdata,
    errdetect => decoder_errdetect,
    syncstatus => decoder_syncstatus,
    disperr => decoder_disperr,
    patterndetect => decoder_patterndetect,
    kout => decoder_ctrldetect,
    rderr => decoder_rderr,
    decdatavalid => decoder_decdatavalid,
    xgmdatavalid => decoder_xgmdatavalid,
    xgmrunningdisp => decoder_xgmrunningdisp,
    xgmctrldet => decoder_xgmctrldet,
    xgmdataout => decoder_xgmdataout
    );

s_rx_clkout_mux : stratixgx_hssi_divide_by_two 
   GENERIC MAP (
      divide => use_double_data_mode)
   PORT MAP (
      reset => reset_int,
      clkin => rxrdclk_mux1,
      clkout => clkoutmux_clkout_pre
   );   

s_rx_core :	stratixgx_rx_core 
generic map (
  channel_width => deserialization_factor,
  use_double_data_mode => use_double_data_mode,
  use_channel_align    => use_channel_align,
  use_8b_10b_mode      => use_8b_10b_mode,
  align_pattern	     => align_pattern,
  synchronization_mode => synchronization_mode
  )
  port map
  (
    reset => reset_int,
    datain => core_datain,
    writeclk => core_writeclk,
    readclk => core_readclk,
    decdatavalid => core_decdatavalid,
    xgmdatain => core_xgmdatain,
    xgmctrlin => core_xgmctrlin,
    post8b10b => core_post8b10b,
    syncstatusin => core_syncstatusin,
    errdetectin => core_errdetectin,
    ctrldetectin => core_ctrldetectin,
    disparityerrin => core_disparityerrin,
    patterndetectin => core_patterndetectin,
    dataout => core_dataout,
    syncstatus => core_syncstatus,
    errdetect => core_errdetect,
    ctrldetect => core_ctrldetect,
    disparityerr => core_disparityerr,
	 patterndetect => core_patterndetect,
	 a1a2sizeout => core_a1a2sizeout,
    clkout => core_clkout
  );   

dataout_tmp <= core_dataout;

-- output from clkout mux
-- - added gfifo
clkoutmux_clkout <= serdes_clkout WHEN ((use_parallel_feedback = "false") AND (clk_out_mode_reference = "false")) ELSE clkoutmux_clkout_pre;

clkout <= clkoutmux_clkout;

VITAL: process (pllclk_ipd, coreclk_ipd, dataout_tmp, core_syncstatus, core_patterndetect,
    cmfifo_fifofull, cmfifo_fifoempty, cmfifo_fifoalmostfull, cmfifo_fifoalmostempty, re_ipd,
	core_a1a2sizeout,
	core_ctrldetect, core_errdetect, core_disparityerr)

variable Tviol_datain_clk : std_ulogic := '0';
variable TimingData_datain_clk : VitalTimingDataType := VitalTimingDataInit;
variable dataout_VitalGlitchDataArray : VitalGlitchDataArrayType(19 downto 0);
variable syncstatus_VitalGlitchDataArray : VitalGlitchDataArrayType(1 downto 0);
variable patterndetect_VitalGlitchDataArray : VitalGlitchDataArrayType(1 downto 0);
variable ctrldetect_VitalGlitchDataArray : VitalGlitchDataArrayType(1 downto 0);
variable errdetect_VitalGlitchDataArray : VitalGlitchDataArrayType(1 downto 0);
variable disperr_VitalGlitchDataArray : VitalGlitchDataArrayType(1 downto 0);
variable a1a2sizeout_VitalGlitchDataArray : VitalGlitchDataArrayType(1 downto 0);
variable fifofull_VitalGlitchData: VitalGlitchDataType;
variable fifoempty_VitalGlitchData: VitalGlitchDataType;
variable fifoalmostfull_VitalGlitchData: VitalGlitchDataType;
variable fifoalmostempty_VitalGlitchData: VitalGlitchDataType;
variable Tviol_re_clk : std_ulogic := '0';
variable TimingData_re_clk : VitalTimingDataType := VitalTimingDataInit;

begin


	------------------------
	--  Timing Check Section
	------------------------

	if (TimingChecksOn) then

		VitalSetupHoldCheck (
			Violation       => Tviol_re_clk,
			TimingData      => TimingData_re_clk,
			TestSignal      => re_ipd,
			TestSignalName  => "RE",
			RefSignal       => coreclk_ipd,
			RefSignalName   => "CORECLK",
			SetupHigh       => tsetup_re_coreclk_noedge_posedge,
			SetupLow        => tsetup_re_coreclk_noedge_posedge,
			HoldHigh        => thold_re_coreclk_noedge_posedge,
			HoldLow         => thold_re_coreclk_noedge_posedge,
			RefTransition   => '/',
			HeaderMsg       => InstancePath & "/STRATIXGX_HSSI_RECEIVER",
			XOn             => XOnChecks,
			MsgOn           => MsgOnChecks );
   end if;



   ----------------------
   --  Path Delay Section
   ----------------------


   VitalPathDelay01 (
      OutSignal => fifofull,
      OutSignalName => "FIFOFULL",
      OutTemp => cmfifo_fifofull,
      Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_fifofull_posedge, TRUE)),
      GlitchData => fifofull_VitalGlitchData,
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

   VitalPathDelay01 (
      OutSignal => fifoempty,
      OutSignalName => "FIFOEMPTY",
      OutTemp => cmfifo_fifoempty,
      Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_fifoempty_posedge, TRUE)),
      GlitchData => fifoempty_VitalGlitchData,
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

   VitalPathDelay01 (
      OutSignal => fifoalmostfull,
      OutSignalName => "FIFOALMOSTFULL",
      OutTemp => cmfifo_fifoalmostfull,
      Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_fifoalmostfull_posedge, TRUE)),
      GlitchData => fifoalmostfull_VitalGlitchData,
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

   VitalPathDelay01 (
      OutSignal => fifoalmostempty,
      OutSignalName => "FIFOALMOSTEMPTY",
      OutTemp => cmfifo_fifoalmostempty,
      Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_fifoalmostempty_posedge, TRUE)),
      GlitchData => fifoalmostempty_VitalGlitchData,
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(0),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(0),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(0), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(0),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(1),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(1),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(1), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(1),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(2),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(2),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(2), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(2),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(3),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(3),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(3), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(3),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(4),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(4),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(4), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(4),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(5),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(5),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(5), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(5),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(6),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(6),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(6), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(6),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(7),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(7),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(7), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(7),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(8),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(8),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(8), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(8),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(9),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(9),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(9), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(9),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(10),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(10),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(10), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(10),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(11),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(11),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(11), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(11),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(12),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(12),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(12), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(12),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(13),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(13),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(13), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(13),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(14),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(14),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(14), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(14),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(15),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(15),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(15), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(15),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(16),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(16),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(16), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(16),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(17),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(17),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(17), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(17),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(18),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(18),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(18), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(18),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(19),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(19),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(19), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(19),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	-- control signals
   VitalPathDelay01 (
      OutSignal => syncstatus(0),
      OutSignalName => "SYNCSTATUS",
      OutTemp => core_syncstatus(0),
      Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_syncstatus_posedge(0), TRUE)),
      GlitchData => syncstatus_VitalGlitchDataArray(0),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

   VitalPathDelay01 (
      OutSignal => syncstatus(1),
      OutSignalName => "SYNCSTATUS",
      OutTemp => core_syncstatus(1),
      Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_syncstatus_posedge(1), TRUE)),
      GlitchData => syncstatus_VitalGlitchDataArray(1),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

   VitalPathDelay01 (
      OutSignal => patterndetect(0),
      OutSignalName => "patterndetect(0)",
      OutTemp => core_patterndetect(0),
      Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_patterndetect_posedge(0), TRUE)),
      GlitchData => patterndetect_VitalGlitchDataArray(0),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

   VitalPathDelay01 (
      OutSignal => patterndetect(1),
      OutSignalName => "patterndetect(1)",
      OutTemp => core_patterndetect(1),
      Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_patterndetect_posedge(1), TRUE)),
      GlitchData => patterndetect_VitalGlitchDataArray(1),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

   VitalPathDelay01 (
      OutSignal => ctrldetect(0),
      OutSignalName => "ctrldetect(0)",
      OutTemp => core_ctrldetect(0),
      Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_ctrldetect_posedge(0), TRUE)),
      GlitchData => ctrldetect_VitalGlitchDataArray(0),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

   VitalPathDelay01 (
      OutSignal => ctrldetect(1),
      OutSignalName => "ctrldetect(1)",
      OutTemp => core_ctrldetect(1),
      Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_ctrldetect_posedge(1), TRUE)),
      GlitchData => ctrldetect_VitalGlitchDataArray(1),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

   VitalPathDelay01 (
      OutSignal => errdetect(0),
      OutSignalName => "errdetect(0)",
      OutTemp => core_errdetect(0),
      Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_errdetect_posedge(0), TRUE)),
      GlitchData => errdetect_VitalGlitchDataArray(0),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

   VitalPathDelay01 (
      OutSignal => errdetect(1),
      OutSignalName => "errdetect(1)",
      OutTemp => core_errdetect(1),
      Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_errdetect_posedge(1), TRUE)),
      GlitchData => errdetect_VitalGlitchDataArray(1),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

   VitalPathDelay01 (
      OutSignal => disperr(0),
      OutSignalName => "disperr(0)",
      OutTemp => core_disparityerr(0),
      Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_disperr_posedge(0), TRUE)),
      GlitchData => disperr_VitalGlitchDataArray(0),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

   VitalPathDelay01 (
      OutSignal => disperr(1),
      OutSignalName => "disperr(1)",
      OutTemp => core_disparityerr(1),
      Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_disperr_posedge(1), TRUE)),
      GlitchData => disperr_VitalGlitchDataArray(1),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

   VitalPathDelay01 (
      OutSignal => a1a2sizeout(0),
      OutSignalName => "a1a2sizeout(0)",
      OutTemp => core_a1a2sizeout(0),
      Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_a1a2sizeout_posedge(0), TRUE)),
      GlitchData => a1a2sizeout_VitalGlitchDataArray(0),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

   VitalPathDelay01 (
      OutSignal => a1a2sizeout(1),
      OutSignalName => "a1a2sizeout(1)",
      OutTemp => core_a1a2sizeout(1),
      Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_a1a2sizeout_posedge(1), TRUE)),
      GlitchData => a1a2sizeout_VitalGlitchDataArray(1),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

end process;


-- generate output signals

-- outputs from serdes
recovclkout <= serdes_clkout;
rlv <= serdes_rlv;
lock <= serdes_lock;
freqlock <= serdes_freqlock;
signaldetect <= serdes_signaldetect;

-- outputs from word_aligner
syncstatusdeskew <= wa_syncstatusdeskew;

-- outputs from deskew FIFO
adetectdeskew <= dsfifo_adetectdeskew;
rdalign <= dsfifo_rdalign;

-- outputs from comp FIFO
-- fifofull <= cmfifo_fifofull;
-- fifoalmostfull <= cmfifo_fifoalmostfull;
-- fifoempty <= cmfifo_fifoempty;
-- fifoalmostempty <= cmfifo_fifoalmostempty;
fifordout <= cmfifo_fifordout;
disablefifordout <= cmfifo_disablefifordout;
disablefifowrout <= cmfifo_disablefifowrout;

-- outputs from decoder
xgmctrldet <= decoder_xgmctrldet;
xgmrunningdisp <= decoder_xgmrunningdisp;
xgmdatavalid <= decoder_xgmdatavalid;
xgmdataout <= decoder_xgmdataout;

end vital_receiver_atom;

--
-- STRATIXGX_HSSI_TRANSMITTER
--

library IEEE, stratixgx_gxb,std;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use stratixgx_gxb.hssi_pack.all;
use std.textio.all;

entity stratixgx_hssi_transmitter is
  generic (
    channel_num		: integer := 1;
    channel_width	: integer := 20;
    serialization_factor: integer := 10;
    use_8b_10b_mode	: String  := "false";
    use_double_data_mode: String  := "false";
    use_fifo_mode	: String  := "false";
    use_reverse_parallel_feedback : String := "false";
    force_disparity_mode: String  := "false";
    transmit_protocol	: String  := "none";
    use_vod_ctrl_signal : String := "false";
    use_preemphasis_ctrl_signal : String := "false";
    use_self_test_mode          : String := "false";
    self_test_mode          : integer  := 0;
    vod_ctrl_setting            : integer := 4;  
    preemphasis_ctrl_setting    : integer := 5;
    termination                 : integer := 0;
    TimingChecksOn	: Boolean := True;
    MsgOn		: Boolean := DefGlitchMsgOn;
    XOn			: Boolean := DefGlitchXOn;
    MsgOnChecks		: Boolean := DefMsgOnChecks;
    XOnChecks		: Boolean := DefXOnChecks;
    InstancePath	: String  := "*";
    tipd_datain         : VitalDelayArrayType01(19 downto 0) := (OTHERS => DefPropDelay01);
    tipd_pllclk		: VitalDelayType01 := DefpropDelay01;
    tipd_fastpllclk	: VitalDelayType01 := DefpropDelay01;
    tipd_coreclk	: VitalDelayType01 := DefpropDelay01;
    tipd_softreset	: VitalDelayType01 := DefpropDelay01;
    tipd_ctrlenable     : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
    tipd_forcedisparity : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
    tipd_serialdatain	: VitalDelayType01 := DefpropDelay01;
    tipd_xgmdatain	: VitalDelayArrayType01(7 downto 0) := (OTHERS => DefPropDelay01);
    tipd_xgmctrl	: VitalDelayType01 := DefpropDelay01;
    tipd_srlpbk		: VitalDelayType01 := DefpropDelay01;
    tipd_analogreset	: VitalDelayType01 := DefpropDelay01;
    tipd_vodctrl	: VitalDelayArrayType01(2 downto 0) := (OTHERS => DefPropDelay01);
    tipd_preemphasisctrl: VitalDelayArrayType01(2 downto 0) := (OTHERS => DefPropDelay01);
    tsetup_datain_coreclk_noedge_posedge        : VitalDelayArrayType(19 downto 0) := (OTHERS => DefSetupHoldCnst);
    thold_datain_coreclk_noedge_posedge         : VitalDelayArrayType(19 downto 0) := (OTHERS => DefSetupHoldCnst);
    tsetup_ctrlenable_coreclk_noedge_posedge    : VitalDelayArrayType(1 downto 0) := (OTHERS => DefSetupHoldCnst);
    thold_ctrlenable_coreclk_noedge_posedge     : VitalDelayArrayType(1 downto 0) := (OTHERS => DefSetupHoldCnst);
    tsetup_forcedisparity_coreclk_noedge_posedge: VitalDelayArrayType(1 downto 0) := (OTHERS => DefSetupHoldCnst);
    thold_forcedisparity_coreclk_noedge_posedge : VitalDelayArrayType(1 downto 0) := (OTHERS => DefSetupHoldCnst)
    );
  
  port (
    datain      : in std_logic_vector(19 downto 0);
    pllclk	: in std_logic := '0';
    fastpllclk	: in std_logic := '0';
    coreclk	: in std_logic := '0';
    softreset	: in std_logic := '0';
    ctrlenable	: in std_logic_vector(1 downto 0) := "00";
    forcedisparity : in std_logic_vector(1 downto 0) := "00";
    serialdatain   : in std_logic := '0';
    xgmdatain	: in std_logic_vector(7 downto 0) := "00000000";
    xgmctrl	: in std_logic := '0';
    srlpbk      : in std_logic := '0';
    devclrn	: in std_logic := '1';
    devpor	: in std_logic := '1';
    analogreset	: in std_logic := '0'; 
    vodctrl	: in std_logic_vector(2 downto 0) := "000";
    preemphasisctrl : in std_logic_vector(2 downto 0) := "000";
    dataout	: out std_logic;
    xgmdataout	: out std_logic_vector(7 downto 0);
    xgmctrlenable : out std_logic;
    rdenablesync  : out std_logic;
    parallelfdbkdata : out std_logic_vector(9 downto 0);
    pre8b10bdata     : out std_logic_vector(9 downto 0)
    );
end stratixgx_hssi_transmitter;

architecture vital_transmitter_atom of stratixgx_hssi_transmitter is
	signal datain_ipd : std_logic_vector(19 downto 0);
	signal pllclk_ipd  : std_logic;
	signal fastpllclk_ipd  : std_logic;
	signal coreclk_ipd  : std_logic;
	signal softreset_ipd  : std_logic;
	signal ctrlenable_ipd : std_logic_vector(1 downto 0);
	signal forcedisparity_ipd : std_logic_vector(1 downto 0);
	signal analogreset_ipd : std_logic;
	signal vodctrl_ipd : std_logic_vector(2 downto 0);
	signal preemphasisctrl_ipd : std_logic_vector(2 downto 0);
	signal serialdatain_ipd  : std_logic;
	signal xgmdatain_ipd : std_logic_vector(7 downto 0);
	signal xgmctrl_ipd  : std_logic;
	signal srlpbk_ipd  : std_logic;

	--constant signals
	signal vcc : std_logic := '1';
	signal gnd : std_logic := '0';
	signal idle_bus : std_logic_vector(9 downto 0) := "0000000000";

	--lower lever softreset 
	signal reset_int : std_logic;

	-- tx_core input/output signals
	signal core_datain : std_logic_vector(19 downto 0);
	signal core_writeclk : std_logic;
	signal core_readclk : std_logic;
	signal core_ctrlena : std_logic_vector(1 downto 0);
	signal core_forcedisp : std_logic_vector(1 downto 0);

	signal core_dataout : std_logic_vector(9 downto 0);
	signal core_forcedispout : std_logic;
	signal core_ctrlenaout : std_logic;
	signal core_rdenasync : std_logic;
	signal core_xgmctrlena : std_logic;
	signal core_xgmdataout : std_logic_vector(7 downto 0);
	signal core_pre8b10bdataout : std_logic_vector(9 downto 0);

	-- serdes input/output signals
	signal serdes_clk : std_logic;
	signal serdes_clk1 : std_logic;
	signal serdes_datain : std_logic_vector(9 downto 0);
	signal serdes_serialdatain : std_logic;
	signal serdes_srlpbk : std_logic;

	signal serdes_dataout : std_logic;

	-- encoder input/output signals
	signal encoder_clk : std_logic := '0'; 
	signal encoder_kin : std_logic := '0';  
	signal encoder_datain : std_logic_vector(7 downto 0) := "00000000";
   signal encoder_para : std_logic_vector(9 downto 0) := "0000000000";
   signal encoder_xgmdatain : std_logic_vector(7 downto 0) := "00000000";
   signal encoder_xgmctrl : std_logic := '0';

	signal encoder_dataout : std_logic_vector(9 downto 0) := "0000000000"; 
	signal encoder_rdout : std_logic := '0'; 

	-- internal signal for parallelfdbkdata
	signal parallelfdbkdata_tmp : std_logic_vector(9 downto 0);

   signal txclk : std_logic;
   signal pllclk_int : std_logic;
    
-- sub module component declaration

component stratixgx_tx_core
  GENERIC (
    use_double_data_mode           :  string := "false";    
    use_fifo_mode                  :  string := "true"; 
    channel_width                  :  integer := 10;   
    transmit_protocol              :  string  := "none";
    KCHAR                          :  std_logic := '0';    
    ECHAR                          :  std_logic := '0');
   port (
	      reset                   : IN std_logic;   
	      datain                  : IN std_logic_vector(19 DOWNTO 0);   
	      writeclk                : IN std_logic;   
	      readclk                 : IN std_logic;   
	      ctrlena                 : IN std_logic_vector(1 DOWNTO 0);   
	      forcedisp               : IN std_logic_vector(1 DOWNTO 0);   
	      dataout                 : OUT std_logic_vector(9 DOWNTO 0);   
	      forcedispout            : OUT std_logic;   
	      ctrlenaout              : OUT std_logic;   
	      rdenasync               : OUT std_logic;   
	      xgmctrlena              : OUT std_logic;   
	      xgmdataout              : OUT std_logic_vector(7 DOWNTO 0);   
	      pre8b10bdataout         : OUT std_logic_vector(9 DOWNTO 0)
		);   

end component;

component stratixgx_hssi_tx_serdes 
  generic (
    channel_width           : integer := 10
    );
  port (
    clk             : in std_logic := '0';
    clk1            : in std_logic := '0';
    datain          : in std_logic_vector(9 downto 0) := "0000000000";
    serialdatain	 : in std_logic := '0';
    srlpbk			 : in std_logic := '0';
    areset          : in std_logic := '0';
    dataout         : out std_logic
    );
end component;

component stratixgx_8b10b_encoder
   GENERIC (
      transmit_protocol              :  string := "none";    
      use_8b_10b_mode                :  string := "true";    
      force_disparity_mode           :  string := "false");
   PORT (
      clk                     : IN std_logic;   
      reset                   : IN std_logic;   
      xgmctrl                 : IN std_logic;   
      kin                     : IN std_logic;   
      xgmdatain               : IN std_logic_vector(7 DOWNTO 0);   
      datain                  : IN std_logic_vector(7 DOWNTO 0);   
      forcedisparity          : IN std_logic;   
      dataout                 : OUT std_logic_vector(9 DOWNTO 0);   
      parafbkdataout          : OUT std_logic_vector(9 DOWNTO 0));   
END component;

component stratixgx_hssi_divide_by_two 
  GENERIC (
    divide                  :  string := "true");
  PORT (
    reset                   : IN std_logic := '0';   
    clkin                   : IN std_logic;   
    clkout                  : OUT std_logic);   
END component;

-- end of sub module component declaration

begin

	----------------------
	--  INPUT PATH DELAYs
	----------------------
	WireDelay : block
	begin
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

		VitalWireDelay (pllclk_ipd, pllclk, tipd_pllclk);
		VitalWireDelay (fastpllclk_ipd, fastpllclk, tipd_fastpllclk);
		VitalWireDelay (coreclk_ipd, coreclk, tipd_coreclk);
		VitalWireDelay (softreset_ipd, softreset, tipd_softreset);

		VitalWireDelay (ctrlenable_ipd(0), ctrlenable(0), tipd_ctrlenable(0));
		VitalWireDelay (ctrlenable_ipd(1), ctrlenable(1), tipd_ctrlenable(1));

		VitalWireDelay (forcedisparity_ipd(0), forcedisparity(0), tipd_forcedisparity(0));
		VitalWireDelay (forcedisparity_ipd(1), forcedisparity(1), tipd_forcedisparity(1));

		VitalWireDelay (analogreset_ipd, analogreset, tipd_analogreset);
		VitalWireDelay (vodctrl_ipd(0), vodctrl(0), tipd_vodctrl(0));
		VitalWireDelay (vodctrl_ipd(1), vodctrl(1), tipd_vodctrl(1));
		VitalWireDelay (vodctrl_ipd(2), vodctrl(2), tipd_vodctrl(2));
		VitalWireDelay (preemphasisctrl_ipd(0), preemphasisctrl(0), tipd_preemphasisctrl(0));
		VitalWireDelay (preemphasisctrl_ipd(1), preemphasisctrl(1), tipd_preemphasisctrl(1));
		VitalWireDelay (preemphasisctrl_ipd(2), preemphasisctrl(2), tipd_preemphasisctrl(2));

		VitalWireDelay (serialdatain_ipd, serialdatain, tipd_serialdatain);

		VitalWireDelay (xgmdatain_ipd(0), xgmdatain(0), tipd_xgmdatain(0));
		VitalWireDelay (xgmdatain_ipd(1), xgmdatain(1), tipd_xgmdatain(1));
		VitalWireDelay (xgmctrl_ipd, xgmctrl, tipd_xgmctrl);
		VitalWireDelay (srlpbk_ipd, srlpbk, tipd_srlpbk);
	end block;

-- generate internal inut signals

    txclk_block : stratixgx_hssi_divide_by_two 
      GENERIC MAP (
        divide => use_double_data_mode)
      PORT MAP (
        clkin => pllclk_ipd,
        clkout => pllclk_int);   

    txclk <= pllclk_int when use_reverse_parallel_feedback = "true" else coreclk_ipd;
        
reset_int <= softreset_ipd;

-- core_interface inputs
core_datain <= datain_ipd;
core_writeclk <= txclk;
core_readclk <= pllclk_ipd;
core_ctrlena <= ctrlenable_ipd;
core_forcedisp <= forcedisparity_ipd;

-- encoder inputs
encoder_clk <= pllclk_ipd;
encoder_kin <=  core_ctrlenaout; 
encoder_datain <= core_dataout(7 downto 0);
encoder_xgmdatain <= xgmdatain(7 downto 0);
encoder_xgmctrl <= xgmctrl_ipd;

-- serdes inputs
serdes_clk <= fastpllclk_ipd;
serdes_clk1 <= pllclk_ipd;
serdes_datain <= encoder_dataout WHEN (use_8b_10b_mode = "true") ELSE core_dataout;
serdes_serialdatain <= serialdatain_ipd;
serdes_srlpbk <= srlpbk_ipd;

-- sub modules

s_tx_core :	stratixgx_tx_core 
  generic map (
    use_double_data_mode => use_double_data_mode, 
    use_fifo_mode => use_fifo_mode,
    channel_width => channel_width,
    transmit_protocol => transmit_protocol)
  port map (
    reset => reset_int,
    datain => core_datain, 
    writeclk => core_writeclk,
    readclk => core_readclk,
    ctrlena => core_ctrlena,
    forcedisp => core_forcedisp,
    dataout => core_dataout,
    forcedispout => core_forcedispout,
    ctrlenaout => core_ctrlenaout,
    rdenasync => core_rdenasync,
    xgmctrlena => core_xgmctrlena,
    xgmdataout => core_xgmdataout,
    pre8b10bdataout => core_pre8b10bdataout
    );   

s_encoder :	stratixgx_8b10b_encoder
  generic map (
    transmit_protocol => transmit_protocol,
    use_8b_10b_mode   => use_8b_10b_mode,
    force_disparity_mode => force_disparity_mode 
    )
  port map (
    clk             => encoder_clk,
    reset           => reset_int,
    kin             => encoder_kin,
    datain          => encoder_datain,
    xgmdatain       => encoder_xgmdatain,
    xgmctrl         => encoder_xgmctrl,
    forcedisparity  => core_forcedispout,
    dataout         => encoder_dataout,
    parafbkdataout  => encoder_para
    );
        
s_tx_serdes :	stratixgx_hssi_tx_serdes 
  generic map (
    channel_width => serialization_factor
    )
  port map (
    clk => serdes_clk,
    clk1 => serdes_clk1,
    datain => serdes_datain,
    serialdatain => serdes_serialdatain,
    srlpbk => serdes_srlpbk,
    areset => analogreset_ipd,
    dataout => serdes_dataout
    );

-- end of sub modules
 
-- generate output signals
parallelfdbkdata_tmp <= encoder_dataout WHEN (use_8b_10b_mode = "true") ELSE core_dataout; 

dataout <= serdes_dataout;
xgmctrlenable <= core_xgmctrlena;
rdenablesync <= core_rdenasync;
xgmdataout <= core_xgmdataout;
pre8b10bdata <= core_pre8b10bdataout;
parallelfdbkdata <= parallelfdbkdata_tmp;

VITAL: process (pllclk_ipd, fastpllclk_ipd, coreclk_ipd)

variable Tviol_datain_clk : std_ulogic := '0';
variable TimingData_datain_clk : VitalTimingDataType := VitalTimingDataInit;
variable Tviol_ctrlenable_clk : std_ulogic := '0';
variable TimingData_ctrlenable_clk : VitalTimingDataType := VitalTimingDataInit;
variable Tviol_forcedisparity_clk : std_ulogic := '0';
variable TimingData_forcedisparity_clk : VitalTimingDataType := VitalTimingDataInit;
variable dataout_VitalGlitchDataArray : VitalGlitchDataArrayType(19 downto 0);
variable clkout_VitalGlitchData: VitalGlitchDataType;

begin

	------------------------
	--  Timing Check Section
	------------------------

	if (TimingChecksOn) then

		VitalSetupHoldCheck (
			Violation       => Tviol_datain_clk,
			TimingData      => TimingData_datain_clk,
			TestSignal      => datain_ipd,
			TestSignalName  => "DATAIN",
			RefSignal       => coreclk_ipd,
			RefSignalName   => "CORECLK",
			SetupHigh       => tsetup_datain_coreclk_noedge_posedge(0),
			SetupLow        => tsetup_datain_coreclk_noedge_posedge(0),
			HoldHigh        => thold_datain_coreclk_noedge_posedge(0),
			HoldLow         => thold_datain_coreclk_noedge_posedge(0),
			RefTransition   => '/',
			HeaderMsg       => InstancePath & "/STRATIXGX_HSSI_TRANSMITTER",
			XOn             => XOn,
			MsgOn           => MsgOnChecks );

		VitalSetupHoldCheck (
			Violation       => Tviol_ctrlenable_clk,
			TimingData      => TimingData_ctrlenable_clk,
			TestSignal      => ctrlenable_ipd,
			TestSignalName  => "CTRLENABLE",
			RefSignal       => coreclk_ipd,
			RefSignalName   => "CORECLK",
			SetupHigh       => tsetup_ctrlenable_coreclk_noedge_posedge(0),
			SetupLow        => tsetup_ctrlenable_coreclk_noedge_posedge(0),
			HoldHigh        => thold_ctrlenable_coreclk_noedge_posedge(0),
			HoldLow         => thold_ctrlenable_coreclk_noedge_posedge(0),
			RefTransition   => '/',
			HeaderMsg       => InstancePath & "/STRATIXGX_HSSI_TRANSMITTER",
			XOn             => XOn,
			MsgOn           => MsgOnChecks );

		VitalSetupHoldCheck (
			Violation       => Tviol_forcedisparity_clk,
			TimingData      => TimingData_forcedisparity_clk,
			TestSignal      => forcedisparity_ipd,
			TestSignalName  => "FORCEDISPARITY",
			RefSignal       => coreclk_ipd,
			RefSignalName   => "CORECLK",
			SetupHigh       => tsetup_forcedisparity_coreclk_noedge_posedge(0),
			SetupLow        => tsetup_forcedisparity_coreclk_noedge_posedge(0),
			HoldHigh        => thold_forcedisparity_coreclk_noedge_posedge(0),
			HoldLow         => thold_forcedisparity_coreclk_noedge_posedge(0),
			RefTransition   => '/',
			HeaderMsg       => InstancePath & "/STRATIXGX_HSSI_TRANSMITTER",
			XOn             => XOn,
			MsgOn           => MsgOnChecks );

   end if;

	----------------------
	--  Path Delay Section
	----------------------

end process;

end vital_transmitter_atom;

