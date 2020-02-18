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

PACKAGE sgate_pack IS

	 function sgate_conv_integer(arg : in std_logic_vector)
             return integer;
	
	 COMPONENT  oper_add
	 GENERIC 
	 (
		sgate_representation	: NATURAL;
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

	 COMPONENT  oper_addsub
	 GENERIC 
	 (
		sgate_representation	: NATURAL ;
		width_a	:	NATURAL;
		width_b	:	NATURAL;
		width_o	:	NATURAL
	 );
	 PORT
	 ( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		b	:	IN STD_LOGIC_VECTOR(width_b-1 DOWNTO 0);
		addnsub	:	IN STD_LOGIC;
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	 ); 
	 END COMPONENT;

	 COMPONENT  mux21
	 PORT
	 ( 
		dataa	:	IN STD_LOGIC;
		datab	:	IN STD_LOGIC;
		dataout	:	OUT STD_LOGIC;
		outputselect	:	IN STD_LOGIC
	 ); 
	 END COMPONENT;

	 COMPONENT  io_buf_tri
	 PORT
	 ( 
		datain	:	IN STD_LOGIC;
		dataout	:	OUT STD_LOGIC;
		oe	:	IN STD_LOGIC
	 ); 
	 END COMPONENT;

	 COMPONENT  io_buf_opdrn
	 PORT
	 ( 
		datain	:	IN STD_LOGIC;
		dataout	:	OUT STD_LOGIC
	 ); 
	 END COMPONENT;


	 COMPONENT  tri_bus
	 GENERIC
	 (
		width_datain	: NATURAL; 	
		width_dataout	: NATURAL 	
	 );
	 PORT
	 ( 
		datain	:	IN STD_LOGIC_VECTOR(width_datain-1 downto 0);
		dataout	:	OUT STD_LOGIC_VECTOR(width_dataout-1 downto 0)
	 ); 
	 END COMPONENT;


	 COMPONENT  oper_mult
	 GENERIC 
	 (
		sgate_representation	: NATURAL;
		width_a	:	NATURAL;
		width_b	:	NATURAL;
		width_o	:	NATURAL
	 );
	 PORT
	 ( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		b	:	IN STD_LOGIC_VECTOR(width_b-1 DOWNTO 0);
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	 ); 
	 END COMPONENT;

	 COMPONENT  oper_div
	 GENERIC 
	 (
		sgate_representation	: NATURAL;
		width_a	:	NATURAL;
		width_b	:	NATURAL;
		width_o	:	NATURAL
	 );
	 PORT
	 ( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		b	:	IN STD_LOGIC_VECTOR(width_b-1 DOWNTO 0);
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	 ); 
	 END COMPONENT;

	 COMPONENT  oper_mod
	 GENERIC 
	 (
		sgate_representation	: NATURAL;
		width_a	:	NATURAL;
		width_b	:	NATURAL;
		width_o	:	NATURAL
	 );
	 PORT
	 ( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		b	:	IN STD_LOGIC_VECTOR(width_b-1 DOWNTO 0);
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	 ); 
	 END COMPONENT;

	 COMPONENT  oper_left_shift
	 GENERIC 
	 (
		width_a	:	NATURAL;
		width_amount	:	NATURAL;
		width_o	:	NATURAL
	 );
	 PORT
	 ( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		amount	:	IN STD_LOGIC_VECTOR(width_amount-1 DOWNTO 0);
		cin	:	IN STD_LOGIC;
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	 ); 
	 END COMPONENT;

	 COMPONENT  oper_right_shift
	 GENERIC 
	 (
		sgate_representation	: NATURAL;
		width_a	:	NATURAL;
		width_amount	:	NATURAL;
		width_o	:	NATURAL
	 );
	 PORT
	 ( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		amount	:	IN STD_LOGIC_VECTOR(width_amount-1 DOWNTO 0);
		cin	:	IN STD_LOGIC;
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	 ); 
	 END COMPONENT;

	 COMPONENT  oper_rotate_left
	 GENERIC 
	 (
		width_a	:	NATURAL;
		width_amount	:	NATURAL;
		width_o	:	NATURAL
	 );
	 PORT
	 ( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		amount	:	IN STD_LOGIC_VECTOR(width_amount-1 DOWNTO 0);
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	 ); 
	 END COMPONENT;

	 COMPONENT  oper_rotate_right
	 GENERIC 
	 (
		width_a	:	NATURAL;
		width_amount	:	NATURAL;
		width_o	:	NATURAL
	 );
	 PORT
	 ( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		amount	:	IN STD_LOGIC_VECTOR(width_amount-1 DOWNTO 0);
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	 ); 
	 END COMPONENT;

	 COMPONENT  oper_less_than
	 GENERIC 
	 (
		sgate_representation	: NATURAL;
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

	 COMPONENT  oper_mux
	 GENERIC 
	 (
		width_sel	:	NATURAL;
		width_data	:	NATURAL
	 );
	 PORT
	 ( 
		sel	:	IN STD_LOGIC_VECTOR(width_sel-1 DOWNTO 0);
		data	:	IN STD_LOGIC_VECTOR(width_data-1 DOWNTO 0);
		o	:	OUT STD_LOGIC
	 ); 
	 END COMPONENT;


	 COMPONENT  oper_selector
	 GENERIC 
	 (
		width_sel	:	NATURAL;
		width_data	:	NATURAL
	 );
	 PORT
	 ( 
		sel	:	IN STD_LOGIC_VECTOR(width_sel-1 DOWNTO 0);
		data	:	IN STD_LOGIC_VECTOR(width_data-1 DOWNTO 0);
		o	:	OUT STD_LOGIC
	 ); 
	 END COMPONENT;

	 COMPONENT  oper_prio_selector
	 GENERIC 
	 (
		width_sel	:	NATURAL;
		width_data	:	NATURAL
	 );
	 PORT
	 ( 
		sel	:	IN STD_LOGIC_VECTOR(width_sel-1 DOWNTO 0);
		data	:	IN STD_LOGIC_VECTOR(width_data-1 DOWNTO 0);
		cin	:	IN STD_LOGIC;
		o	:	OUT STD_LOGIC
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


	 COMPONENT  oper_bus_mux
	 GENERIC 
	 (
		width_a	:	NATURAL;
		width_b	:	NATURAL;
		width_o	:	NATURAL
	 );
	 PORT
	 ( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		b	:	IN STD_LOGIC_VECTOR(width_b-1 DOWNTO 0);
		sel	:	IN STD_LOGIC;
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	 ); 
	 END COMPONENT;


END sgate_pack;	

package body sgate_pack is

-- convert std_logic_vector to integer
function sgate_conv_integer(arg : in std_logic_vector) return integer is
variable result : integer := 0;
begin
    result := 0;
    for i in arg'range loop
        if arg(i) = '1' then
            result := result + 2**i;
        end if;
    end loop;
    return result;
end sgate_conv_integer;

end sgate_pack;

