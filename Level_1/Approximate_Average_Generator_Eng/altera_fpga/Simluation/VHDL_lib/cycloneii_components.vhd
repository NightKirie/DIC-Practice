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

library IEEE, cycloneii;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Timing.all;
use cycloneii.atom_pack.all;

package CYCLONEII_COMPONENTS is

--
--
  
component cycloneii_lcell_ff
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
end component;

--
--
  
component cycloneii_lcell_comb
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

end component;

--
-- CYCLONEII_IO
--

component cycloneii_io
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
		padio           : inout std_logic);
end component;


--
-- CYCLONEII_CLK_DELAY_CTRL
--

component cycloneii_clk_delay_ctrl
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
end component;
	
--
-- cycloneii_mac_mult
--

component cycloneii_mac_mult
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
          ena : IN std_logic := '1';
          dataout : OUT std_logic_vector(35 DOWNTO 0);   
          devclrn : IN std_logic := '1';
          devpor : IN std_logic := '1'
         );
end component;

--
-- cycloneii_mac_out
--

component cycloneii_mac_out
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
             dataa_width                    :  integer := 36;    
             output_clock                   :  string := "none";    
             lpm_hint                       :  string := "true";    
             lpm_type                       :  string := "cycloneii_mac_out"
            );
    PORT (
          dataa : IN std_logic_vector(35 DOWNTO 0) := (OTHERS => '0');
          clk : IN std_logic := '0';
          aclr : IN std_logic := '0';
          ena : IN std_logic := '1';
          dataout : OUT std_logic_vector(35 DOWNTO 0);   
          devclrn : IN std_logic := '1';
          devpor : IN std_logic := '1'
         );   
end component;

--
-- CYCLONEII_CLKCTRL
--

component cycloneii_clkctrl
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
          inclk       : in std_logic_vector(3 downto 0) := "0000";
          clkselect   : in std_logic_vector(1 downto 0) := "00";
          ena         : in std_logic := '1';
          devclrn     : in std_logic := '1';
          devpor      : in std_logic := '1';
          outclk      : out std_logic
         );

end component;	
--
-- CYCLONEII_RAM_BLOCK
--

component cycloneii_ram_block
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
      portawe           : in std_logic := '0';
      portabyteenamasks : in std_logic_vector (15 downto 0) := (others => '1');
      portbbyteenamasks : in std_logic_vector (15 downto 0) := (others => '1');
      portbrewe         : in std_logic := '0';
      clr0              : in std_logic := '0';
      clr1              : in std_logic := '0';
      clk0              : in std_logic := '0';
      clk1              : in std_logic := '0';
      ena0              : in std_logic := '1';
      ena1              : in std_logic := '1';
      portadatain       : in std_logic_vector (143 downto 0) := (others => '0');
      portbdatain       : in std_logic_vector (71 downto 0) := (others => '0');
      portaaddr         : in std_logic_vector (15 downto 0) := (others => '0');
      portbaddr         : in std_logic_vector (15 downto 0) := (others => '0');
      portaaddrstall    : in std_logic := '0';
      portbaddrstall    : in std_logic := '0';
      devclrn           : in std_logic := '1';
      devpor            : in std_logic := '1';
      portadataout      : out std_logic_vector (143 downto 0);
      portbdataout      : out std_logic_vector (143 downto 0)
    );
end component;

--
-- CYCLONEII_JTAG
--

component  cycloneii_jtag 
	 generic (
					lpm_type	: string := "cycloneii_jtag"
				);
    port (tms : in std_logic := '0'; 
    		 tck : in std_logic := '0'; 
    		 tdi : in std_logic := '0'; 
    		 ntrst : in std_logic := '0'; 
    		 tdoutap : in std_logic := '0'; 
    		 tdouser : in std_logic := '0'; 
          tdo: out std_logic; 
          tmsutap: out std_logic; 
          tckutap: out std_logic; 
          tdiutap: out std_logic; 
          shiftuser: out std_logic; 
          clkdruser: out std_logic; 
          updateuser: out std_logic; 
          runidleuser: out std_logic; 
          usr1user: out std_logic);
end component;

--
--
--  CYCLONEII_CRCBLOCK 
--
--

component  cycloneii_crcblock 
	generic 	(
					oscillator_divider	: integer := 1;
					lpm_type	: string := "cycloneii_crcblock"
				);
	port (clk 			: in std_logic := '0'; 
   		shiftnld		: in std_logic := '0'; 
    		ldsrc			: in std_logic := '0'; 
         crcerror		: out std_logic; 
         regout		: out std_logic); 
end component;
--
-- CYCLONEII_ASMIBLOCK
--
component  cycloneii_asmiblock
	 generic (
					lpm_type	: string := "cycloneii_asmiblock"
				);	
    port (
          dclkin : in std_logic; 
    		 scein : in std_logic; 
    		 sdoin : in std_logic; 
    		 oe : in std_logic; 
          data0out: out std_logic
         );

end component;

--
-- CYCLONEII_PLL
--

COMPONENT cycloneii_pll
    GENERIC (operation_mode              : string := "normal";
             pll_type                    : string := "auto";
             compensate_clock            : string := "clk0";
             feedback_source             : string := "e0";
             qualify_conf_done           : string := "off";

             test_input_comp_delay       : integer := 0;
             test_feedback_comp_delay    : integer := 0;

             inclk0_input_frequency      : integer := 10000;
             inclk1_input_frequency      : integer := 10000;

             gate_lock_signal            : string := "yes";
             gate_lock_counter           : integer := 1;
             valid_lock_multiplier       : integer := 1;
             invalid_lock_multiplier     : integer := 5;

             switch_over_type            : string := "auto";
             switch_over_on_lossclk      : string := "off";
             switch_over_on_gated_lock   : string := "off";
             switch_over_counter         : integer := 1;
             enable_switch_over_counter  : string := "off";

             bandwidth                   : integer := 0;
             bandwidth_type              : string := "auto";
             down_spread                 : string := "0 %";
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

             -- ADVANCED USE PARAMETERS
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

             enable0_counter             : string := "c0";
             enable1_counter             : string := "c1";
             sclkout0_phase_shift        : string := "0";
             sclkout1_phase_shift        : string := "0";

             charge_pump_current         : integer := 0;
             loop_filter_c               : integer := 1;
             loop_filter_r               : string := "1.0" ;
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

    PORT    (inclk          : IN std_logic_vector(1 downto 0);
             ena            : IN std_logic := '1';
             clkswitch      : IN std_logic := '0';
             areset         : IN std_logic := '0';
             pfdena         : IN std_logic := '1';
             testclearlock  : IN std_logic := '0';
             clk            : OUT std_logic_vector(2 downto 0);
             locked         : OUT std_logic;
             testupout      : OUT std_logic;
             testdownout    : OUT std_logic
            );
END COMPONENT;

end cycloneii_components;
