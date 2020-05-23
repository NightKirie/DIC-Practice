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


library IEEE, maxii;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Timing.all;
use maxii.atom_pack.all;

package MAXII_COMPONENTS is

--
-- MAXII_LCELL
--
  
component maxii_lcell
  generic 
    (
      operation_mode  : string := "normal";
      synch_mode      : string := "off";
      register_cascade_mode   : string := "off";
      sum_lutc_input  : string := "datac";
      lut_mask        : string := "ffff";
      power_up        : string := "low";
      cin0_used       : string := "false";
      cin1_used       : string := "false";
      cin_used        : string := "false";
      output_mode     : string := "comb_only";
      lpm_type        : string := "maxii_lcell";
      x_on_violation  : string := "on"
      );
  port
    (
      clk       : in std_logic := '0';
      dataa     : in std_logic := '1';
      datab     : in std_logic := '1';
      datac     : in std_logic := '1';
      datad     : in std_logic := '1';
      aclr      : in std_logic := '0';
      aload     : in std_logic := '0';
      sclr      : in std_logic := '0';
      sload     : in std_logic := '0';
      ena       : in std_logic := '1';
      cin       : in std_logic := '0';
      cin0      : in std_logic := '0';
      cin1      : in std_logic := '1';
      inverta   : in std_logic := '0';
      regcascin : in std_logic := '0';
      devclrn   : in std_logic := '1';
      devpor    : in std_logic := '1';
      combout   : out std_logic;
      regout    : out std_logic;
      cout      : out std_logic;
      cout0     : out std_logic;
      cout1     : out std_logic
      );
end component;

--
-- MAXII_UFM
--

component maxii_ufm
    generic (
            address_width           :  integer := 9;
            osc_sim_setting         :  integer := 136000; -- default osc frequency to 7.35MHz
            init_file               :  string  := "none";
            lpm_type                :  string  := "maxii_ufm";
            mem1                    : std_logic_vector(511 downto 0) := (OTHERS=>'1');
            mem2                    : std_logic_vector(511 downto 0) := (OTHERS=>'1');
            mem3                    : std_logic_vector(511 downto 0) := (OTHERS=>'1');
            mem4                    : std_logic_vector(511 downto 0) := (OTHERS=>'1');
            mem5                    : std_logic_vector(511 downto 0) := (OTHERS=>'1');
            mem6                    : std_logic_vector(511 downto 0) := (OTHERS=>'1');
            mem7                    : std_logic_vector(511 downto 0) := (OTHERS=>'1');
            mem8                    : std_logic_vector(511 downto 0) := (OTHERS=>'1');
            mem9                    : std_logic_vector(511 downto 0) := (OTHERS=>'1');
            mem10                   : std_logic_vector(511 downto 0) := (OTHERS=>'1');
            mem11                   : std_logic_vector(511 downto 0) := (OTHERS=>'1');
            mem12                   : std_logic_vector(511 downto 0) := (OTHERS=>'1');
            mem13                   : std_logic_vector(511 downto 0) := (OTHERS=>'1');
            mem14                   : std_logic_vector(511 downto 0) := (OTHERS=>'1');
            mem15                   : std_logic_vector(511 downto 0) := (OTHERS=>'1');
            mem16                   : std_logic_vector(511 downto 0) := (OTHERS=>'1')
            );
    port (
            program                 : IN std_logic := '0';
            erase                   : IN std_logic := '0';
            oscena                  : IN std_logic;
            arclk                   : IN std_logic;
            arshft                  : IN std_logic;
            ardin                   : IN std_logic;
            drclk                   : IN std_logic;
            drshft                  : IN std_logic;
            drdin                   : IN std_logic;
            sbdin                   : IN std_logic := '0';
            devclrn                 : IN std_logic := '1';
            devpor                  : IN std_logic := '1';
            ctrl_bgpbusy            : IN std_logic := '0';
            busy                    : OUT std_logic;
            osc                     : OUT std_logic;
            drdout                  : OUT std_logic;
            sbdout                  : OUT std_logic;
            bgpbusy                 : OUT std_logic
        );
end component;

--
-- MAXII_IO
--

component maxii_io
    generic (
             lpm_type : string := "maxii_io";
             operation_mode : string := "input";
             open_drain_output : string := "false";
             bus_hold : string := "false"
            );
    port (
        datain : in std_logic := '0';
        oe : in std_logic := '1';
        combout : out std_logic;
        padio : inout std_logic
        );
end component;


end maxii_components;
