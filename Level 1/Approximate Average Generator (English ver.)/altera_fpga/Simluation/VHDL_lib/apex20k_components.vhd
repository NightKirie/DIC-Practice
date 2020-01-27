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


LIBRARY IEEE, apex20k;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.VITAL_Timing.all;
USE apex20k.atom_pack.all;

PACKAGE APEX20K_COMPONENTS IS

COMPONENT apex20k_lcell
    GENERIC (operation_mode     : string := "normal";
             output_mode        : string := "comb_and_reg";
             packed_mode        : string := "false";
             lut_mask           : string := "ffff";
             power_up           : string := "low";
             cin_used           : string := "false";
             lpm_type           : string := "apex20k_lcell";
             x_on_violation     : string := "on"
            );

    PORT    (clk                : in std_logic := '0';
             dataa              : in std_logic := '1';
             datab              : in std_logic := '1';
             datac              : in std_logic := '1';
             datad              : in std_logic := '1';
             aclr               : in std_logic := '0';
             sclr               : in std_logic := '0';
             sload              : in std_logic := '0';
             ena                : in std_logic := '1';
             cin                : in std_logic := '0';
             cascin             : in std_logic := '1';
             devclrn            : in std_logic := '1';
             devpor             : in std_logic := '1';
             combout            : out std_logic;
             regout             : out std_logic;
             cout               : out std_logic;
             cascout            : out std_logic
            );
end COMPONENT;

COMPONENT apex20k_io 
    GENERIC (operation_mode     : string := "input";
             reg_source_mode    : string := "none";
             feedback_mode      : string := "from_pin";
             power_up           : string := "low"
            );

    PORT    (clk                : in std_logic := '0';
             datain             : in std_logic := '1';
             aclr               : in std_logic := '0';
             ena                : in std_logic := '1';
             oe                 : in std_logic := '1';
             devclrn            : in std_logic := '1';
             devpor             : in std_logic := '1';
             devoe              : in std_logic := '0';
             padio              : inout std_logic;
             combout            : out std_logic;
             regout             : out std_logic
            );

END COMPONENT;

COMPONENT apex20k_pterm 
    GENERIC (operation_mode     : string := "normal";
             output_mode        : string := "comb";
             invert_pterm1_mode : string := "false";
             power_up           : string := "low"
            );
  
    PORT    (pterm0             : in std_logic_vector(31 downto 0) := (OTHERS => '1');
             pterm1             : in std_logic_vector(31 downto 0) := (OTHERS => '1');
             pexpin             : in std_logic := '0';
             clk                : in std_logic := '0';
             ena                : in std_logic := '1';
             aclr               : in std_logic := '0';
             devclrn            : in std_logic := '1';
             devpor             : in std_logic := '1';
             dataout            : out std_logic;
             pexpout            : out std_logic
            );
END COMPONENT;

COMPONENT  apex20k_ram_slice
    GENERIC (operation_mode      : string := "single_port";
             deep_ram_mode       : string := "off";
             logical_ram_name    : string := "ram_xxx";
             logical_ram_depth   : integer := 2048;
             logical_ram_width   : integer:= 1;
             address_width       : integer:= 16;
             data_in_clock       : string := "none";
             data_in_clear       : string := "none";
             write_logic_clock   : string := "none";
             write_logic_clear   : string := "none";
             read_enable_clock   : string := "none";
             read_enable_clear   : string := "none";
             read_address_clock  : string := "none";
             read_address_clear  : string := "none";
             data_out_clock      : string := "none";
             data_out_clear      : string := "none";
             init_file           : string := "none";
             lpm_type            : string := "apex20k_ram_slice";
             first_address       : integer:= 0;
             last_address        : integer:= 2047;
             bit_number          : integer:= 0;
             power_up            : string := "low";
             mem1                : std_logic_vector(512 downto 1) := (OTHERS => '0');
             mem2                : std_logic_vector(512 downto 1) := (OTHERS => '0');
             mem3                : std_logic_vector(512 downto 1) := (OTHERS => '0');
             mem4                : std_logic_vector(512 downto 1) := (OTHERS => '0')
            );

    PORT    (datain              : in std_logic := '0';
             clk0                : in std_logic := '0';
             clk1                : in std_logic := '0';
             clr0                : in std_logic := '0';
             clr1                : in std_logic := '0'; 
             ena0                : in std_logic := '1';
             ena1                : in std_logic := '1';
             we                  : in std_logic := '0';
             re                  : in std_logic := '1';
             raddr               : in std_logic_vector(15 downto 0) := (OTHERS => '0');
             waddr               : in std_logic_vector(15 downto 0) := (OTHERS => '0');
             devclrn             : in std_logic := '1';
             devpor              : in std_logic := '1';
             modesel             : in std_logic_vector(17 downto 0) := (OTHERS => '0');
             dataout             : out std_logic
            );
END COMPONENT;

COMPONENT apex20k_pll
    GENERIC (input_frequency     : integer := 1000;
             clk0_multiply_by    : integer := 1;
             clk1_multiply_by    : integer := 1;
             tipd_clk            : VitalDelayType01 := DefpropDelay01
            );

    PORT    (clk                 : in std_logic;
             clk0                : out std_logic;
             clk1                : out std_logic;
             locked              : out std_logic
            );
END COMPONENT;

COMPONENT apex20k_jtagb
    PORT    (tms                 : in std_logic := '0'; 
             tck                 : in std_logic := '0'; 
             tdi                 : in std_logic := '0'; 
             ntrst               : in std_logic := '0'; 
             tdoutap             : in std_logic := '0'; 
             tdouser             : in std_logic := '0'; 
             tdo                 : out std_logic; 
             tmsutap             : out std_logic; 
             tckutap             : out std_logic; 
             tdiutap             : out std_logic; 
             shiftuser           : out std_logic; 
             clkdruser           : out std_logic; 
             updateuser          : out std_logic; 
             runidleuser         : out std_logic; 
             usr1user            : out std_logic
            );
END COMPONENT;

END APEX20K_COMPONENTS;
