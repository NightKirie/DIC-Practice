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
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;


ENTITY oper_add IS
	GENERIC 
	(
		sgate_representation	: NATURAL :=1;
		width_a	:	NATURAL:=8;
		width_b	:	NATURAL:=8;
		width_o	:	NATURAL :=8
	);
	PORT
	( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		b	:	IN STD_LOGIC_VECTOR(width_b-1 DOWNTO 0);
		cin	:	IN STD_LOGIC;
		cout	:	OUT STD_LOGIC;
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	); 
END oper_add;

ARCHITECTURE sim_arch OF oper_add IS

SIGNAL 	a_ext	: STD_LOGIC_VECTOR(width_a+1 DOWNTO 0);
SIGNAL 	b_ext	: STD_LOGIC_VECTOR(width_a+1 DOWNTO 0);
SIGNAL 	o_ext	: STD_LOGIC_VECTOR(width_a+1 DOWNTO 0);

BEGIN

g1: IF (width_a=width_b) AND (width_b=width_o) GENERATE

	a_ext(width_a-1 DOWNTO 0) 	<= a(width_a-1 DOWNTO 0);
	b_ext(width_a-1 DOWNTO 0) 	<= b(width_a-1 DOWNTO 0);
	
	g2: IF (sgate_representation>0) GENERATE
		a_ext(width_a) 		<= a_ext(width_a-1);
		a_ext(width_a+1) 	<= a_ext(width_a-1);
		b_ext(width_a) 		<= b_ext(width_a-1);
		b_ext(width_a+1) 	<= b_ext(width_a-1);
	END GENERATE g2;

	g3: IF (sgate_representation=0) GENERATE
		a_ext(width_a) 		<= '0';
		a_ext(width_a+1) 	<= '0';
		b_ext(width_a) 		<= '0';
		b_ext(width_a+1) 	<= '0';		
	END GENERATE g3;	
		
	o_ext <= cin+a_ext+b_ext;
	cout	<= o_ext(width_a);
	o(width_o-1 DOWNTO 0) 		<= o_ext(width_a-1 DOWNTO 0);
		
END GENERATE g1;

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;


ENTITY  oper_addsub IS
	GENERIC 
	(
		sgate_representation	: NATURAL :=1;
		width_a	:	NATURAL	:=8;
		width_b	:	NATURAL	:=8;
		width_o	:	NATURAL	:=8
	);
	PORT
	( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		b	:	IN STD_LOGIC_VECTOR(width_b-1 DOWNTO 0);
		addnsub	:	IN STD_LOGIC;
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	); 
END oper_addsub;

ARCHITECTURE sim_arch OF oper_addsub IS

SIGNAL 	a_ext	: STD_LOGIC_VECTOR(width_a DOWNTO 0);
SIGNAL 	b_ext	: STD_LOGIC_VECTOR(width_a DOWNTO 0);
SIGNAL 	o_ext	: STD_LOGIC_VECTOR(width_a DOWNTO 0);

BEGIN

g1: IF (width_a=width_b) AND (width_b=width_o) GENERATE

	a_ext(width_a-1 DOWNTO 0) 	<= a(width_a-1 DOWNTO 0);
	b_ext(width_a-1 DOWNTO 0) 	<= b(width_a-1 DOWNTO 0);
	
	g2: IF (sgate_representation>0) GENERATE
		a_ext(width_a) 		<= a_ext(width_a-1);
		b_ext(width_a) 		<= b_ext(width_a-1);
	END GENERATE g2;

	g3: IF (sgate_representation=0) GENERATE
		a_ext(width_a) 		<= '0';
		b_ext(width_a) 		<= '0';
	END GENERATE g3;	
		
	o_ext <= a_ext+b_ext when (addnsub='1') ELSE a_ext-b_ext;

	o(width_o-1 DOWNTO 0) 		<= o_ext(width_a-1 DOWNTO 0);
		
END GENERATE g1;

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


ENTITY  mux21 IS
	PORT
	( 
		dataa	:	IN STD_LOGIC;
		datab	:	IN STD_LOGIC;
		dataout	:	OUT STD_LOGIC;
		outputselect	:	IN STD_LOGIC
	); 
END mux21;

ARCHITECTURE sim_arch OF mux21 IS

BEGIN

	dataout <= dataa WHEN outputselect='0' ELSE datab;

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;


ENTITY  io_buf_tri IS
	PORT
	( 
		datain	:	IN STD_LOGIC;
		dataout	:	OUT STD_LOGIC;
		oe	:	IN STD_LOGIC
	); 
END io_buf_tri;

ARCHITECTURE sim_arch OF io_buf_tri IS
BEGIN

	dataout <= datain WHEN oe='1' ELSE 'Z';

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;


ENTITY  io_buf_opdrn IS
	PORT
	( 
		datain	:	IN STD_LOGIC;
		dataout	:	OUT STD_LOGIC
	); 
END io_buf_opdrn;

ARCHITECTURE sim_arch OF io_buf_opdrn IS
BEGIN

	dataout <= '0' when datain='0' else 'Z';

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------





library IEEE;
use IEEE.std_logic_1164.all;


ENTITY  tri_bus IS
	 GENERIC
	 (
		width_datain	: NATURAL:=2; 	
		width_dataout	: NATURAL:=1 	
	 );
	 PORT
	 ( 
		datain	:	IN STD_LOGIC_VECTOR(width_datain-1 downto 0);
		dataout	:	OUT STD_LOGIC_VECTOR(width_dataout-1 downto 0)
	 ); 
END tri_bus;


ARCHITECTURE sim_arch OF tri_bus IS

BEGIN

g:for i in 0 to width_datain-1 generate
	dataout(0) <= datain(i) when (datain(i)='1' or datain(i)='0') ELSE 'Z';
end generate g;

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;


ENTITY  oper_mult IS
	GENERIC 
	(
		sgate_representation : NATURAL :=1;
		width_a	:	NATURAL :=8;
		width_b	:	NATURAL :=6;
		width_o	:	NATURAL :=8
	);
	PORT
	( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		b	:	IN STD_LOGIC_VECTOR(width_b-1 DOWNTO 0);
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	); 
END oper_mult;

ARCHITECTURE sim_arch OF oper_mult IS

SIGNAL a_ext : STD_LOGIC_VECTOR(width_a downto 0);
SIGNAL b_ext : STD_LOGIC_VECTOR(width_b downto 0);
SIGNAL o_ext : STD_LOGIC_VECTOR(width_a+width_b+1 downto 0);

BEGIN

	g1: IF (sgate_representation>0) GENERATE
		a_ext(width_a) 		<= a_ext(width_a-1);
		b_ext(width_b) 		<= b_ext(width_b-1);
	END GENERATE g1;
	
	g2: IF (sgate_representation=0) GENERATE
		a_ext(width_a) 		<= '0';
		b_ext(width_b) 		<= '0';
	END GENERATE g2;
	
	a_ext(width_a-1 DOWNTO 0) <= a(width_a-1 DOWNTO 0);
	b_ext(width_b-1 DOWNTO 0) <= b(width_b-1 DOWNTO 0);
	
	o_ext 					<= a_ext*b_ext;
	o(width_o-1 DOWNTO 0) 	<= o_ext(width_o-1 DOWNTO 0);

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

library LPM;
use LPM.LPM_COMPONENTS.all;


ENTITY  oper_div IS
	GENERIC 
	(
		sgate_representation : NATURAL :=1;
		width_a	:	NATURAL :=8;
		width_b	:	NATURAL :=8;
		width_o	:	NATURAL :=8
	);
	PORT
	( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		b	:	IN STD_LOGIC_VECTOR(width_b-1 DOWNTO 0);
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	); 
END oper_div;

ARCHITECTURE sim_arch OF oper_div IS

FUNCTION STR_REPRESENTATION( i : NATURAL ) RETURN STRING IS
BEGIN
	IF (i>0) THEN 
		RETURN "SIGNED";
	ELSE
		RETURN "UNSIGNED";
	END IF;
END;

SIGNAL quotient : STD_LOGIC_VECTOR(width_a-1 DOWNTO 0); 

BEGIN

	u0 : lpm_divide	GENERIC MAP (
								lpm_widthn => width_a,
								lpm_widthd => width_b,
								lpm_type => "LPM_DIVIDE",
								lpm_nrepresentation => STR_REPRESENTATION(sgate_representation),
								lpm_hint => "LPM_REMAINDERPOSITIVE=FALSE",
								lpm_drepresentation => STR_REPRESENTATION(sgate_representation)
								)
						PORT MAP (
								denom => b,
								numer => a,
								quotient => quotient,
								remain => open
								);
														
	o(width_o-1 DOWNTO 0) <= quotient(width_o-1 DOWNTO 0);

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

LIBRARY LPM;
USE LPM.LPM_COMPONENTS.all;

ENTITY  oper_mod IS
	GENERIC 
	(
		sgate_representation : NATURAL;
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
END oper_mod;

ARCHITECTURE sim_arch OF oper_mod IS

FUNCTION STR_REPRESENTATION( i : NATURAL ) RETURN STRING IS
BEGIN
	IF (i>0) THEN 
		RETURN "SIGNED";
	ELSE
		RETURN "UNSIGNED";
	END IF;
END;

SIGNAL remain : STD_LOGIC_VECTOR(width_b-1 DOWNTO 0); 

BEGIN

	u0 : lpm_divide	GENERIC MAP (
								lpm_widthn => width_a,
								lpm_widthd => width_b,
								lpm_type => "LPM_DIVIDE",
								lpm_nrepresentation => STR_REPRESENTATION(sgate_representation),
								lpm_hint => "LPM_REMAINDERPOSITIVE=FALSE",
								lpm_drepresentation => STR_REPRESENTATION(sgate_representation)
								)
						PORT MAP (
								denom => b,
								numer => a,
								quotient => open ,
								remain => remain
								);													
	o(width_o-1 DOWNTO 0) <= remain(width_o-1 DOWNTO 0);

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


LIBRARY LPM;
USE LPM.LPM_COMPONENTS.all;

ENTITY  oper_left_shift IS
	GENERIC 
	(
		width_a	:	NATURAL :=8;
		width_amount	:	NATURAL :=2;
		width_o	:	NATURAL :=8
	);
	PORT
	( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		amount	:	IN STD_LOGIC_VECTOR(width_amount-1 DOWNTO 0);
		cin	:	IN STD_LOGIC;
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	); 
END oper_left_shift;

ARCHITECTURE sim_arch OF oper_left_shift IS

SIGNAL res		: STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
SIGNAL resx		: STD_LOGIC_VECTOR(width_a-1 DOWNTO 0); --need to add cin xor functionality

BEGIN

	U0 : lpm_clshift
		GENERIC MAP (
			lpm_type => "LPM_CLSHIFT",
			lpm_shifttype => "ARITHMETIC",
			lpm_width => width_a,
			lpm_widthdist => width_amount
		)
		PORT MAP (
			distance => amount,
			direction => '0',
			data => a,
			result => res
		);
	
	o(width_o-1 DOWNTO 0) <= res(width_o-1 DOWNTO 0);

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;


LIBRARY LPM;
USE LPM.LPM_COMPONENTS.all;

ENTITY  oper_right_shift IS
	GENERIC 
	(
		sgate_representation : NATURAL :=1;
		width_a	:	NATURAL :=8;
		width_amount	:	NATURAL :=3;
		width_o	:	NATURAL :=8
	);
	PORT
	( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		amount	:	IN STD_LOGIC_VECTOR(width_amount-1 DOWNTO 0);
		cin	:	IN STD_LOGIC;
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	); 
END oper_right_shift;

ARCHITECTURE sim_arch OF oper_right_shift IS

FUNCTION STR_REPRESENTATION( i : NATURAL ) RETURN STRING IS
BEGIN
	IF (i>0) THEN 
		RETURN "ARITHMETIC";
	ELSE
		RETURN "LOGICAL";
	END IF;
END;

SIGNAL res		: STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);

BEGIN

	U0 : lpm_clshift	GENERIC MAP (
			lpm_type => "LPM_CLSHIFT",
			lpm_shifttype => STR_REPRESENTATION(sgate_representation),
			lpm_width => width_a,
			lpm_widthdist => width_amount
		)
		PORT MAP (
			distance => amount,
			direction => '1',
			data => a,
			result => res
		);
	
	o(width_o-1 DOWNTO 0) <= res(width_o-1 DOWNTO 0);

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

LIBRARY LPM;
USE LPM.LPM_COMPONENTS.all;

ENTITY  oper_rotate_left IS
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
END oper_rotate_left;

ARCHITECTURE sim_arch OF oper_rotate_left IS

SIGNAL res		: STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);

BEGIN

	U0 : lpm_clshift
		GENERIC MAP (
			lpm_type => "LPM_CLSHIFT",
			lpm_shifttype => "ROTATE",
			lpm_width => width_a,
			lpm_widthdist => width_amount
		)
		PORT MAP (
			distance => amount,
			direction => '0',
			data => a,
			result => res
		);
	
	o(width_o-1 DOWNTO 0) <= res(width_o-1 DOWNTO 0);

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


LIBRARY LPM;
USE LPM.LPM_COMPONENTS.all;

ENTITY  oper_rotate_right IS
	GENERIC 
	(
		width_a	:	NATURAL :=8;
		width_amount	:	NATURAL :=4;
		width_o	:	NATURAL :=8
	);
	PORT
	( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		amount	:	IN STD_LOGIC_VECTOR(width_amount-1 DOWNTO 0);
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	); 
END oper_rotate_right;

ARCHITECTURE sim_arch OF oper_rotate_right IS

SIGNAL res		: STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);

BEGIN

	U0 : lpm_clshift
		GENERIC MAP (
			lpm_type => "LPM_CLSHIFT",
			lpm_shifttype => "ROTATE",
			lpm_width => width_a,
			lpm_widthdist => width_amount
		)
		PORT MAP (
			distance => amount,
			direction => '1',
			data => a,
			result => res
		);

	o(width_o-1 DOWNTO 0) <= res(width_o-1 DOWNTO 0);

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;


ENTITY  oper_less_than IS
	GENERIC 
	(
		sgate_representation : NATURAL :=0;
		width_a	:	NATURAL :=8;
		width_b	:	NATURAL :=5
	);
	PORT
	( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		b	:	IN STD_LOGIC_VECTOR(width_b-1 DOWNTO 0);
		cin	:	IN STD_LOGIC;
		o	:	OUT STD_LOGIC
	); 
END oper_less_than;

ARCHITECTURE sim_arch OF oper_less_than IS

BEGIN

g1:IF sgate_representation>0 GENERATE
	PROCESS(a,b,cin)
		VARIABLE va		: SIGNED(width_a-1 DOWNTO 0); 
		VARIABLE vb		: SIGNED(width_b-1 DOWNTO 0); 
		BEGIN
			va := SIGNED(a);
			vb := SIGNED(b);
			IF (va<vb) THEN
				o <= '1';
			ELSIF (va=vb) AND (cin='1') THEN
				o <= '1';
			ELSE 	
				o <= '0';
			END IF;	 	
	END PROCESS;
END GENERATE g1;

g2:IF sgate_representation=0 GENERATE
	PROCESS(a,b,cin)
		VARIABLE va		: UNSIGNED(width_a-1 DOWNTO 0); 
		VARIABLE vb		: UNSIGNED(width_b-1 DOWNTO 0); 
		BEGIN
			va := UNSIGNED(a);
			vb := UNSIGNED(b);
			IF (va<vb) THEN
				o <= '1';
			ELSIF (va=vb) AND (cin='1') THEN
				o <= '1';
			ELSE
				o <= '0';
			END IF;
	END PROCESS;
END GENERATE g2;

END sim_arch;
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

library sgate;
use sgate.sgate_pack.all;

ENTITY  oper_mux IS
	GENERIC 
	(
		width_sel	:	NATURAL :=3;
		width_data	:	NATURAL :=8
	);
	PORT
	( 
		sel	:	IN STD_LOGIC_VECTOR(width_sel-1 DOWNTO 0);
		data	:	IN STD_LOGIC_VECTOR(width_data-1 DOWNTO 0);
		o	:	OUT STD_LOGIC
	); 
END oper_mux;


ARCHITECTURE sim_arch OF oper_mux IS


BEGIN

o <= data(sgate_conv_integer(sel));

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


ENTITY  oper_selector IS
	GENERIC 
	(
		width_sel	:	NATURAL :=8;
		width_data	:	NATURAL :=8
	);
	PORT
	( 
		sel	:	IN STD_LOGIC_VECTOR(width_sel-1 DOWNTO 0);
		data	:	IN STD_LOGIC_VECTOR(width_data-1 DOWNTO 0);
		o	:	OUT STD_LOGIC
	); 
END oper_selector;

ARCHITECTURE sim_arch OF oper_selector IS
BEGIN

	g1:FOR k IN 0 TO width_data-1 GENERATE
		o <= data(k) WHEN (sel(k)='1') ELSE 'Z';
	END GENERATE;

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;


ENTITY  oper_prio_selector IS
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
END oper_prio_selector;

ARCHITECTURE sim_arch OF oper_prio_selector IS
BEGIN

	g1:FOR k IN 0 TO width_sel-1 GENERATE
		o <= data(k) WHEN (sel(k)='1') ELSE 'Z';
	END GENERATE;

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;


ENTITY oper_decoder IS
	GENERIC 
	(
		width_i	:	NATURAL :=1;
		width_o	:	NATURAL :=2
	);
	PORT
	( 
		i	:	IN STD_LOGIC_VECTOR(width_i-1 DOWNTO 0);
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	); 
END oper_decoder;

ARCHITECTURE sim_arch OF oper_decoder IS

FUNCTION int2ustd(value : integer; width : integer) RETURN std_logic_vector IS 
-- convert integer to unsigned std_logicvector 
BEGIN
	RETURN conv_std_logic_vector(CONV_UNSIGNED(value, width ), width);
END int2ustd;

BEGIN

	G1:FOR k IN 0 TO width_o-1 GENERATE
		o(k) <= '1' WHEN (i=int2ustd(k,width_i)) ELSE '0';
	END GENERATE;

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


ENTITY  oper_bus_mux IS
	GENERIC 
	(
		width_a	:	NATURAL :=8;
		width_b	:	NATURAL :=8;
		width_o	:	NATURAL :=8
	);
	PORT
	( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		b	:	IN STD_LOGIC_VECTOR(width_b-1 DOWNTO 0);
		sel	:	IN STD_LOGIC;
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	); 
END oper_bus_mux;


ARCHITECTURE sim_arch OF oper_bus_mux IS

BEGIN

	o <= a WHEN sel='0' ELSE b;

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
ENTITY latch IS
	PORT
	(
		datain	:	IN STD_LOGIC;
		dataout	:	OUT STD_LOGIC;
		latch_enable	:	IN STD_LOGIC
	);
END latch;

ARCHITECTURE sim_arch OF latch IS

BEGIN
	PROCESS(datain, latch_enable)
	BEGIN
		if (latch_enable = '1') then
			dataout <= datain;
		end if;
	END PROCESS;

END sim_arch;
