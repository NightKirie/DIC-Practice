// Copyright (C) 1988-2002 Altera Corporation
// Any  megafunction  design,  and related netlist (encrypted  or  decrypted),
// support information,  device programming or simulation file,  and any other
// associated  documentation or information  provided by  Altera  or a partner
// under  Altera's   Megafunction   Partnership   Program  may  be  used  only
// to program  PLD  devices (but not masked  PLD  devices) from  Altera.   Any
// other  use  of such  megafunction  design,  netlist,  support  information,
// device programming or simulation file,  or any other  related documentation
// or information  is prohibited  for  any  other purpose,  including, but not
// limited to  modification,  reverse engineering,  de-compiling, or use  with
// any other  silicon devices,  unless such use is  explicitly  licensed under
// a separate agreement with  Altera  or a megafunction partner.  Title to the
// intellectual property,  including patents,  copyrights,  trademarks,  trade
// secrets,  or maskworks,  embodied in any such megafunction design, netlist,
// support  information,  device programming or simulation file,  or any other
// related documentation or information provided by  Altera  or a megafunction
// partner, remains with Altera, the megafunction partner, or their respective
// licensors. No other licenses, including any licenses needed under any third
// party's intellectual property, are provided herein.


// Quartus II 4.1 Build 181 06/29/2004


`timescale 1 ps/1 ps
module  apex20ke_asynch_lcell (dataa, datab, datac, datad,
                      cin, cascin, qfbkin,
                      combout, regin, cout, cascout) ;

    parameter operation_mode     = "normal" ;
    parameter output_mode        = "reg_and_comb";
    parameter lut_mask        	 = "ffff" ;
    parameter cin_used           = "false";

    input  dataa, datab, datac, datad ;
    input  cin, cascin, qfbkin;
    output cout, cascout, regin, combout ;

    reg icout, data;
    wire icascout, idataa;


	buf (idataa, dataa);
	buf (idatab, datab);
	buf (idatac, datac);
	buf (idatad, datad);
	buf (icascin, cascin);
	buf (icin, cin);

    specify


    (dataa => combout) = (0, 0) ;
    (datab => combout) = (0, 0) ;
    (datac => combout) = (0, 0) ;
    (datad => combout) = (0, 0) ;
    (cascin => combout) = (0, 0) ;
    (cin => combout) = (0, 0) ;
    (qfbkin => combout) = (0, 0) ;

    (dataa => cout) = (0, 0);
    (datab => cout) = (0, 0);
    (datac => cout) = (0, 0);
    (datad => cout) = (0, 0);
    (cin => cout) = (0, 0) ;
    (qfbkin => cout) = (0, 0) ;

    (cascin => cascout) = (0, 0) ;
    (cin => cascout) = (0, 0) ;
    (dataa => cascout) = (0, 0) ;
    (datab => cascout) = (0, 0) ;
    (datac => cascout) = (0, 0) ;
    (datad => cascout) = (0, 0) ;
    (qfbkin => cascout) = (0, 0) ;

    (dataa => regin) = (0, 0) ;
    (datab => regin) = (0, 0) ;
    (datac => regin) = (0, 0) ;
    (datad => regin) = (0, 0) ;
    (cascin => regin) = (0, 0) ;
    (cin => regin) = (0, 0) ;
    (qfbkin => regin) = (0, 0) ;

    endspecify

    function [16:1] str_to_bin ;
      input  [8*4:1] s;
      reg [8*4:1] reg_s;
      reg [4:1]   digit [8:1];
      reg [8:1] tmp;
      integer   m , ivalue ;
      begin
 
         ivalue = 0;
         reg_s = s;
         for (m=1; m<=4; m= m+1 )
         begin
                tmp = reg_s[32:25];
                digit[m] = tmp & 8'b00001111;
                reg_s = reg_s << 8;
                if (tmp[7] == 'b1)
                   digit[m] = digit[m] + 9;
         end
         str_to_bin = {digit[1], digit[2], digit[3], digit[4]};
    end   
    endfunction
  
   function lut4 ;
	input  [4*8:1] lut_mask ;
	input 	     dataa, datab, datac, datad ;
	reg [15:0]     mask ;
	reg 	     prev_lut4;
	reg 	     dataa_new, datab_new, datac_new, datad_new;
	integer 	     h, i, j, k;
	integer 	     hn, in, jn, kn;
	integer 	     exitloop;
	integer 	     check_prev;

	begin
		mask = str_to_bin (lut_mask) ;
		begin
			if ((datad === 1'bx) || (datad === 1'bz))
			begin
				datad_new = 1'b0;
				hn = 2;
			end
			else
			begin
				datad_new = datad;
				hn = 1;
			end
			check_prev = 0;
			exitloop = 0;
			h = 1;
			while ((h <= hn) && (exitloop == 0))
			begin
				if ((datac === 1'bx) || (datac === 1'bz))
				begin
					datac_new = 1'b0;
					in = 2;
				end
				else
				begin
					datac_new = datac;
					in = 1;
				end
				i = 1;
				while ((i <= in) && (exitloop ==0))
				begin
					if ((datab === 1'bx) || (datab === 1'bz))
					begin
						datab_new = 1'b0;
						jn = 2;
					end
					else
					begin
						datab_new = datab;
						jn = 1;
					end
					j = 1;
					while ((j <= jn) && (exitloop ==0))
					begin
						if ((dataa === 1'bx) || (dataa === 1'bz))
						begin
							dataa_new = 1'b0;
							kn = 2;
						end
						else
						begin
							dataa_new = dataa;
							kn = 1;
						end
						k = 1;
						while ((k <= kn) && (exitloop ==0))
						begin
							case ({datad_new, datac_new, datab_new, dataa_new})
							4'b0000: lut4 = mask[0] ; 
							4'b0001: lut4 = mask[1] ; 
							4'b0010: lut4 = mask[2] ; 
							4'b0011: lut4 = mask[3] ; 
							4'b0100: lut4 = mask[4] ; 
							4'b0101: lut4 = mask[5] ; 
							4'b0110: lut4 = mask[6] ; 
							4'b0111: lut4 = mask[7] ; 
							4'b1000: lut4 = mask[8] ; 
							4'b1001: lut4 = mask[9] ; 
							4'b1010: lut4 = mask[10] ; 
							4'b1011: lut4 = mask[11] ; 
							4'b1100: lut4 = mask[12] ; 
							4'b1101: lut4 = mask[13] ; 
							4'b1110: lut4 = mask[14] ; 
							4'b1111: lut4 = mask[15] ; 
							default: $display ("Warning: Reached forbidden part of lcell code.\n");
							endcase
							
							if ((check_prev == 1) && (prev_lut4 !==lut4))
							begin
								lut4 = 1'bx;
								exitloop = 1;
							end
							else
							begin
								check_prev = 1;
								prev_lut4 = lut4;
							end
							k = k + 1;
							dataa_new = 1'b1;
						end // loop a
						j = j + 1;
						datab_new = 1'b1;
					end // loop b
					i = i + 1;
					datac_new = 1'b1;
				end // loop c
				h = h + 1;
				datad_new = 1'b1;
			end // loop d
		end
	end
   endfunction

     always @(idatad or idatac or idatab or idataa or icin or 
             icascin or qfbkin)
     begin
    	if (operation_mode == "normal")
	begin
           data = ((cin_used == "true") ? (lut4 (lut_mask, idataa, idatab, icin, idatad)) : (lut4(lut_mask, idataa, idatab, idatac, idatad))) && icascin;
        end

	if (operation_mode == "arithmetic")
	begin
           data = (lut4 (lut_mask, idataa, idatab, icin, 'b1))
                              && icascin ;
           icout = lut4 ( lut_mask, idataa, idatab, icin, 'b0) ;
        end

	if (operation_mode == "counter")
	begin
		icout = lut4(lut_mask, idataa, idatab, icin, 'b0);
		data = (lut4(lut_mask, idataa, idatab, icin, 'b1)) && icascin;
	end

	if (operation_mode == "qfbk_counter")
	begin
		icout = lut4(lut_mask, idataa, idatab, qfbkin, 'b0);
		data = (lut4(lut_mask, idataa, idatab, qfbkin, 'b1)) && icascin;
	end
     end

     assign icascout = data ;

     and (cascout, icascout, 1'b1) ;
     and (combout, data, 1'b1) ;
     and (cout, icout, 1'b1) ;
     and (regin, data, 1'b1) ;

endmodule

`timescale 1 ps/1 ps

module  apex20ke_lcell_register (clk, aclr, sclr, sload, ena,
                      datain, datac, devclrn, devpor, regout, qfbko) ;

    parameter operation_mode  = "normal" ;
    parameter packed_mode    	 = "false" ;
    parameter power_up     = "low";
    parameter x_on_violation = "on";

    input  clk, ena, datain, datac;
    input  aclr, sclr, sload, devclrn, devpor ;
    output regout, qfbko ;

    reg iregout;
    wire clk_in, idatac;
    wire reset;
    wire nosload;

    reg datain_viol, datac_viol;
    reg sclr_viol, sload_viol;
    reg ena_viol, clk_per_viol;
    reg violation;

    reg clk_last_value;

	buf (clk_in, clk);
	buf (iclr, aclr);
	buf (isclr, sclr);
	buf (isload, sload);
	buf (iena, ena);
	buf (idatac, datac);

    assign reset = devpor && devclrn && (!iclr) && (iena);
    assign nosload = reset && (!sload);

    specify

    $period (posedge clk &&& reset, 0, clk_per_viol);	

    $setuphold (posedge clk &&& nosload, datain, 0, 0, datain_viol) ;
    $setuphold (posedge clk &&& reset, datac, 0, 0, datac_viol) ;
    $setuphold (posedge clk &&& reset, sclr, 0, 0, sclr_viol) ;
    $setuphold (posedge clk &&& reset, sload, 0, 0, sload_viol) ;
    $setuphold (posedge clk &&& reset, ena, 0, 0, ena_viol) ;

    (posedge clk => (regout +: iregout)) = 0 ;
    (posedge aclr => (regout +: 1'b0)) = (0, 0) ;

    (posedge clk => (qfbko +: iregout)) = 0 ;
    (posedge aclr => (qfbko +: 1'b0)) = (0, 0) ;

    endspecify

    initial
    begin
       clk_last_value = 0;
       violation = 0;
       if (power_up == "low")
          iregout <= 'b0;
       else if (power_up == "high")
          iregout <= 'b1;
    end

    always @ (datain_viol or datac_viol or sclr_viol or sload_viol or ena_viol or clk_per_viol)
    begin
        if (x_on_violation == "on")
            violation = 1;
    end

     always @ (clk_in or posedge iclr or negedge devclrn or negedge devpor or posedge violation)
     begin
        if (violation == 1'b1)
        begin
           violation = 0;
           iregout <= 'bx;
        end
        else
        begin
	   if (devpor == 'b0)
	   begin
	      if (power_up == "low")
	         iregout <= 'b0;
	      else if (power_up == "high")
	         iregout <= 'b1;
	   end
	   else if (devclrn == 'b0)
		 iregout <= 'b0;
	   else if (iclr == 'b1) 
		 iregout <= 'b0 ;
	   else if (iena == 'b1 && clk_in == 'b1 && clk_last_value == 'b0)
	   begin
	      if (isclr == 'b1)
	         iregout <= 'b0 ;
	      else if (isload == 'b1)
	         iregout <= idatac;
	      else if (packed_mode == "false")
	         iregout <= datain ;
              else if (operation_mode == "normal")
	         iregout <= idatac ;
	      else
	         $display("Error: Invalid combination of parameters used. Packed mode may be used only when operation_mode is 'normal'.\n");	
	   end
        end
     clk_last_value = clk_in;
     end

     and (regout, iregout, 1'b1) ;
     and (qfbko, iregout, 1'b1) ;

endmodule
`timescale 1 ps/1 ps

module  apex20ke_lcell (clk, dataa, datab, datac, datad, aclr,
                      sclr, sload, ena, cin,
                      cascin, devclrn, devpor,
                      combout, regout, cout, cascout) ;

parameter operation_mode     = "normal" ;
parameter output_mode        = "reg_and_comb";
parameter packed_mode        = "false" ;
parameter lut_mask           = "ffff" ;
parameter power_up           = "low";
parameter cin_used           = "false";
parameter lpm_type           = "apex20ke_lcell";
parameter x_on_violation     = "on";

input  clk, dataa, datab, datac, datad, ena ;
input  aclr, sclr, sload, cin, cascin, devclrn, devpor ;
output cout, cascout, regout, combout ;
wire dffin, qfbk;

apex20ke_asynch_lcell lecomb (dataa, datab, datac, datad, cin, cascin,
                              qfbk, combout, dffin, cout, cascout);

defparam lecomb.operation_mode = operation_mode,
         lecomb.output_mode = output_mode,
         lecomb.cin_used = cin_used,
         lecomb.lut_mask = lut_mask;

apex20ke_lcell_register lereg (clk, aclr, sclr, sload, ena, dffin, datac,
                               devclrn, devpor, regout, qfbk);

defparam lereg.packed_mode = packed_mode,
         lereg.power_up = power_up,
         lereg.x_on_violation = x_on_violation;

endmodule

///////////////////////////////////////////////////////////////////////////////
//
// APEX20KE IO Atom
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module  apex20ke_io (clk, datain, aclr, preset, ena, oe, devclrn, devoe, devpor,
                   padio, combout, regout) ;

  parameter operation_mode  		= "input" ;
  parameter reg_source_mode          	= "none" ;
  parameter feedback_mode		= "from_pin" ;
  parameter power_up                    = "low";
  parameter open_drain_output           = "false";
 
  inout     padio ;
  input     datain, clk, aclr, preset, ena, oe, devpor, devoe, devclrn ;
  output    regout, combout;
  // tri0      aclr, preset;
  // tri1      ena;

  wire reg_pre, reg_clr;

specify

//$setuphold (posedge clk, datain, 0, 0) ;
//$setuphold (posedge clk, padio, 0, 0) ;

//(posedge clk => (regout +: datain)) = (0, 0) ;
//if (ioe == 'b1) (posedge clk => (padio +: datain)) = (0, 0) ;
//if (ioe == 'b1) (posedge aclr => (padio +: 1'b0)) = (0, 0) ;
//if (ioe == 'b1) (posedge preset => (padio +: 1'b1)) = (0, 0) ;

endspecify

//    initial
//    begin
//       if (power_up == "low")
//          tri_in = 'b0;
//       else if (power_up == "high")
//          tri_in = 'b1;
//    end

assign reg_clr = (power_up == "low") ? devpor : 1'b1;
assign reg_pre = (power_up == "high") ? devpor : 1'b1;

apex20ke_asynch_io asynch_inst (datain, oe, padio, dffeD, dffeQ, combout, regout);
   defparam
            asynch_inst.operation_mode = operation_mode,
            asynch_inst.reg_source_mode = reg_source_mode,
            asynch_inst.feedback_mode = feedback_mode,
            asynch_inst.open_drain_output = open_drain_output;

dffe_io io_reg (dffeQ, clk, ena, dffeD, devclrn && !aclr && reg_clr, !preset && reg_pre);

endmodule

//
// ASYNCH_IO
//
module apex20ke_asynch_io(datain, oe, padio, dffeD, dffeQ, combout, regout);

  parameter operation_mode  		= "input" ;
  parameter reg_source_mode          	= "none" ;
  parameter feedback_mode		= "from_pin" ;
  parameter open_drain_output           = "false";

input datain, oe;
input dffeQ;
output dffeD;
output combout;
output regout;
inout padio;

  reg tmp_comb, tri_in, tri_in_new;
  reg reg_indata;

   specify
     (padio => combout) = (0, 0) ;
     (posedge oe => (padio +: tri_in_new)) = 0;
     (negedge oe => (padio +: 1'bz)) = 0;
     (datain => padio) = (0, 0);
     (dffeQ => padio) = (0, 0);
     (dffeQ => regout) = (0, 0);
   endspecify

  buf (ipadio, padio);
  buf (idatain, datain);
  buf (ioe, oe);

// this initialization is redundant : combout always reflects value of padio
//initial
//begin
//  tmp_comb = 0;
//end

always @(ipadio or idatain or ioe or dffeQ)
begin 
	if ((reg_source_mode == "none") && (feedback_mode == "none"))
	begin
		if ((operation_mode == "output") ||
		        (operation_mode == "bidir"))
		    tri_in = idatain;
	end
	else if ((reg_source_mode == "none") && (feedback_mode == "from_pin"))
        begin
		if (operation_mode == "input")
			tmp_comb = ipadio;
		else if (operation_mode == "bidir")
		begin
			tmp_comb = ipadio;
			tri_in = idatain;
		end
		else $display ("Error: Invalid operation_mode specified\n");
        end
	else if ((reg_source_mode == "data_in") && (feedback_mode == "from_reg"))
	begin
		if ((operation_mode == "output") || (operation_mode == "bidir"))
                begin
		     tri_in = idatain;
		     reg_indata = idatain;
                end
		else $display ("Error: Invalid operation_mode specified\n");
	end
	else if ((reg_source_mode == "data_in") && 
			(feedback_mode == "from_pin_and_reg"))
	begin
		if (operation_mode == "input")
		begin
			tmp_comb = ipadio;
			reg_indata = idatain;
		end
		else if (operation_mode == "bidir") 
		begin
			tmp_comb = ipadio;
			tri_in = idatain;
			reg_indata = idatain;
		end
		else $display ("Error: Invalid operation_mode specified\n");
	end	
	else if ((reg_source_mode == "pin_only") && 
			(feedback_mode == "from_pin_and_reg")) 
	begin
		if (operation_mode == "input")
		begin
			tmp_comb = ipadio;
			reg_indata = ipadio;
		end
		else if (operation_mode == "bidir")
		begin
			tri_in = idatain;
			tmp_comb = ipadio;
			reg_indata = ipadio;
		end
		else $display ("Error: Invalid operation_mode specified\n");
	end
	else if ((reg_source_mode == "pin_only") &&
			(feedback_mode == "from_reg"))	
	begin
		if (operation_mode == "input")
			reg_indata = ipadio;
		else if (operation_mode == "bidir")  
		begin
			tri_in = idatain;
			reg_indata = ipadio;
		end
		else $display ("Error: Invalid operation_mode specified\n"); 
	end
	else if ((reg_source_mode == "data_in_to_pin") && 
			(feedback_mode == "from_pin")) 
	begin
		if (operation_mode == "bidir")
		begin
			tri_in = dffeQ;
			reg_indata = idatain;
			tmp_comb = ipadio;
		end
		else $display ("Error: Invalid operation_mode specified\n");
	end
	else if ((reg_source_mode == "data_in_to_pin") &&
			(feedback_mode == "from_reg"))     
	begin 
		if ((operation_mode == "output") ||
                       (operation_mode == "bidir"))
		begin
			reg_indata = idatain;
			tri_in = dffeQ;
		end
		else $display ("Error: Invalid operation_mode specified\n");
	end 
	else if ((reg_source_mode == "data_in_to_pin") && 
			(feedback_mode == "none"))      
	begin  
		if ((operation_mode == "output") ||
                       (operation_mode == "bidir"))
		begin 
			tri_in = dffeQ;
			reg_indata = idatain;
		end 
		else $display ("Error: Invalid operation_mode specified\n"); 
	end  
	else if ((reg_source_mode == "data_in_to_pin") &&  
			(feedback_mode == "from_pin_and_reg"))       
	begin   
		if (operation_mode == "bidir")
		begin   
			reg_indata = idatain;
			tri_in = dffeQ;
			tmp_comb = ipadio;
		end
		else $display ("Error: Invalid operation_mode specified\n");  
	end
	else if ((reg_source_mode == "pin_loop") && 
			(feedback_mode == "from_pin"))
	begin
		if (operation_mode == "bidir")
		begin
			tri_in = dffeQ;
			reg_indata = ipadio;
			tmp_comb = ipadio;
		end
		else $display ("Error: Invalid operation_mode specified\n");
	end
	else if ((reg_source_mode == "pin_loop") && 
			(feedback_mode == "from_pin_and_reg"))
	begin
		if (operation_mode == "bidir")
		begin 
			reg_indata = ipadio;
			tri_in = dffeQ;
			tmp_comb = ipadio;
		end
		else $display ("Error: Invalid operation_mode specified\n");
	end
	else if ((reg_source_mode == "pin_loop") &&  
			(feedback_mode == "from_reg"))
	begin
		if (operation_mode == "bidir")
		begin
			reg_indata = ipadio;
			tri_in = dffeQ;
		end
		else $display ("Error: Invalid operation_mode specified\n");
	end
	else $display ("Error: Invalid combination of parameters used\n");
        if (ioe == 1'b1)
        begin
	   if (open_drain_output == "true")
	   begin
	      if (tri_in == 1'b0)
	         tri_in_new = 0;
	      else if (tri_in == 1'bx)
                 tri_in_new = 'bx;
              else tri_in_new = 'bz;
	   end
	   else if (open_drain_output == "false")
	      tri_in_new = tri_in;
        end
        else if (ioe == 1'b0)
           tri_in_new = 'bz;
        else tri_in_new = 'bx;

end

and (dffeD, reg_indata, 1'b1);
and (regout, dffeQ, 1'b1);
and (combout , tmp_comb, 1'b1);
pmos (padio, tri_in_new, 1'b0);

endmodule
//
//   APEX20KE PTERM ASYNCH 
//
`timescale 1 ps/1 ps
module  apex20ke_asynch_pterm (pterm0, pterm1, pexpin, fbkin, combout, pexpout, regin);

    parameter operation_mode	= "normal";
    parameter invert_pterm1_mode = "false";

    input  [31:0] pterm0, pterm1;
    input  pexpin, fbkin;
    output combout, pexpout, regin;

    reg icomb, ipexpout;
    wire iipterm1;
    wire [31:0] ipterm0, ipterm1;
    
    buf (ipexpin, pexpin);

    buf (ipterm0[0], pterm0[0]);
    buf (ipterm0[1], pterm0[1]);
    buf (ipterm0[2], pterm0[2]);
    buf (ipterm0[3], pterm0[3]);
    buf (ipterm0[4], pterm0[4]);
    buf (ipterm0[5], pterm0[5]);
    buf (ipterm0[6], pterm0[6]);
    buf (ipterm0[7], pterm0[7]);
    buf (ipterm0[8], pterm0[8]);
    buf (ipterm0[9], pterm0[9]);
    buf (ipterm0[10], pterm0[10]);
    buf (ipterm0[11], pterm0[11]);
    buf (ipterm0[12], pterm0[12]);
    buf (ipterm0[13], pterm0[13]);
    buf (ipterm0[14], pterm0[14]);
    buf (ipterm0[15], pterm0[15]);
    buf (ipterm0[16], pterm0[16]);
    buf (ipterm0[17], pterm0[17]);
    buf (ipterm0[18], pterm0[18]);
    buf (ipterm0[19], pterm0[19]);
    buf (ipterm0[20], pterm0[20]);
    buf (ipterm0[21], pterm0[21]);
    buf (ipterm0[22], pterm0[22]);
    buf (ipterm0[23], pterm0[23]);
    buf (ipterm0[24], pterm0[24]);
    buf (ipterm0[25], pterm0[25]);
    buf (ipterm0[26], pterm0[26]);
    buf (ipterm0[27], pterm0[27]);
    buf (ipterm0[28], pterm0[28]);
    buf (ipterm0[29], pterm0[29]);
    buf (ipterm0[30], pterm0[30]);
    buf (ipterm0[31], pterm0[31]);

    buf (ipterm1[0], pterm1[0]);
    buf (ipterm1[1], pterm1[1]);
    buf (ipterm1[2], pterm1[2]);
    buf (ipterm1[3], pterm1[3]);
    buf (ipterm1[4], pterm1[4]);
    buf (ipterm1[5], pterm1[5]);
    buf (ipterm1[6], pterm1[6]);
    buf (ipterm1[7], pterm1[7]);
    buf (ipterm1[8], pterm1[8]);
    buf (ipterm1[9], pterm1[9]);
    buf (ipterm1[10], pterm1[10]);
    buf (ipterm1[11], pterm1[11]);
    buf (ipterm1[12], pterm1[12]);
    buf (ipterm1[13], pterm1[13]);
    buf (ipterm1[14], pterm1[14]);
    buf (ipterm1[15], pterm1[15]);
    buf (ipterm1[16], pterm1[16]);
    buf (ipterm1[17], pterm1[17]);
    buf (ipterm1[18], pterm1[18]);
    buf (ipterm1[19], pterm1[19]);
    buf (ipterm1[20], pterm1[20]);
    buf (ipterm1[21], pterm1[21]);
    buf (ipterm1[22], pterm1[22]);
    buf (ipterm1[23], pterm1[23]);
    buf (ipterm1[24], pterm1[24]);
    buf (ipterm1[25], pterm1[25]);
    buf (ipterm1[26], pterm1[26]);
    buf (ipterm1[27], pterm1[27]);
    buf (ipterm1[28], pterm1[28]);
    buf (ipterm1[29], pterm1[29]);
    buf (ipterm1[30], pterm1[30]);
    buf (ipterm1[31], pterm1[31]);

    specify

   
    (pterm0[0] => combout) = (0, 0) ;
    (pterm0[1] => combout) = (0, 0) ;
    (pterm0[2] => combout) = (0, 0) ;
    (pterm0[3] => combout) = (0, 0) ;
    (pterm0[4] => combout) = (0, 0) ;
    (pterm0[5] => combout) = (0, 0) ;
    (pterm0[6] => combout) = (0, 0) ;
    (pterm0[7] => combout) = (0, 0) ;
    (pterm0[8] => combout) = (0, 0) ;
    (pterm0[9] => combout) = (0, 0) ;
    (pterm0[10] => combout) = (0, 0) ;
    (pterm0[11] => combout) = (0, 0) ;
    (pterm0[12] => combout) = (0, 0) ;
    (pterm0[13] => combout) = (0, 0) ;
    (pterm0[14] => combout) = (0, 0) ;
    (pterm0[15] => combout) = (0, 0) ;
    (pterm0[16] => combout) = (0, 0) ;
    (pterm0[17] => combout) = (0, 0) ;
    (pterm0[18] => combout) = (0, 0) ;
    (pterm0[19] => combout) = (0, 0) ;
    (pterm0[20] => combout) = (0, 0) ;
    (pterm0[21] => combout) = (0, 0) ;
    (pterm0[22] => combout) = (0, 0) ;
    (pterm0[23] => combout) = (0, 0) ;
    (pterm0[24] => combout) = (0, 0) ;
    (pterm0[25] => combout) = (0, 0) ;
    (pterm0[26] => combout) = (0, 0) ;
    (pterm0[27] => combout) = (0, 0) ;
    (pterm0[28] => combout) = (0, 0) ;
    (pterm0[29] => combout) = (0, 0) ;
    (pterm0[30] => combout) = (0, 0) ;
    (pterm0[31] => combout) = (0, 0) ;

    (pterm1[0] => combout) = (0, 0) ;
    (pterm1[1] => combout) = (0, 0) ;
    (pterm1[2] => combout) = (0, 0) ;
    (pterm1[3] => combout) = (0, 0) ;
    (pterm1[4] => combout) = (0, 0) ;
    (pterm1[5] => combout) = (0, 0) ;
    (pterm1[6] => combout) = (0, 0) ;
    (pterm1[7] => combout) = (0, 0) ;
    (pterm1[8] => combout) = (0, 0) ;
    (pterm1[9] => combout) = (0, 0) ;
    (pterm1[10] => combout) = (0, 0) ;
    (pterm1[11] => combout) = (0, 0) ;
    (pterm1[12] => combout) = (0, 0) ;
    (pterm1[13] => combout) = (0, 0) ;
    (pterm1[14] => combout) = (0, 0) ;
    (pterm1[15] => combout) = (0, 0) ;
    (pterm1[16] => combout) = (0, 0) ;
    (pterm1[17] => combout) = (0, 0) ;
    (pterm1[18] => combout) = (0, 0) ;
    (pterm1[19] => combout) = (0, 0) ;
    (pterm1[20] => combout) = (0, 0) ;
    (pterm1[21] => combout) = (0, 0) ;
    (pterm1[22] => combout) = (0, 0) ;
    (pterm1[23] => combout) = (0, 0) ;
    (pterm1[24] => combout) = (0, 0) ;
    (pterm1[25] => combout) = (0, 0) ;
    (pterm1[26] => combout) = (0, 0) ;
    (pterm1[27] => combout) = (0, 0) ;
    (pterm1[28] => combout) = (0, 0) ;
    (pterm1[29] => combout) = (0, 0) ;
    (pterm1[30] => combout) = (0, 0) ;
    (pterm1[31] => combout) = (0, 0) ;

    (pexpin => combout) = (0, 0) ;

    (pterm0[0] => pexpout) = (0, 0) ;
    (pterm0[1] => pexpout) = (0, 0) ;
    (pterm0[2] => pexpout) = (0, 0) ;
    (pterm0[3] => pexpout) = (0, 0) ;
    (pterm0[4] => pexpout) = (0, 0) ;
    (pterm0[5] => pexpout) = (0, 0) ;
    (pterm0[6] => pexpout) = (0, 0) ;
    (pterm0[7] => pexpout) = (0, 0) ;
    (pterm0[8] => pexpout) = (0, 0) ;
    (pterm0[9] => pexpout) = (0, 0) ;
    (pterm0[10] => pexpout) = (0, 0) ;
    (pterm0[11] => pexpout) = (0, 0) ;
    (pterm0[12] => pexpout) = (0, 0) ;
    (pterm0[13] => pexpout) = (0, 0) ;
    (pterm0[14] => pexpout) = (0, 0) ;
    (pterm0[15] => pexpout) = (0, 0) ;
    (pterm0[16] => pexpout) = (0, 0) ;
    (pterm0[17] => pexpout) = (0, 0) ;
    (pterm0[18] => pexpout) = (0, 0) ;
    (pterm0[19] => pexpout) = (0, 0) ;
    (pterm0[20] => pexpout) = (0, 0) ;
    (pterm0[21] => pexpout) = (0, 0) ;
    (pterm0[22] => pexpout) = (0, 0) ;
    (pterm0[23] => pexpout) = (0, 0) ;
    (pterm0[24] => pexpout) = (0, 0) ;
    (pterm0[25] => pexpout) = (0, 0) ;
    (pterm0[26] => pexpout) = (0, 0) ;
    (pterm0[27] => pexpout) = (0, 0) ;
    (pterm0[28] => pexpout) = (0, 0) ;
    (pterm0[29] => pexpout) = (0, 0) ;
    (pterm0[30] => pexpout) = (0, 0) ;
    (pterm0[31] => pexpout) = (0, 0) ;

    (pterm1[0] => pexpout) = (0, 0) ;
    (pterm1[1] => pexpout) = (0, 0) ;
    (pterm1[2] => pexpout) = (0, 0) ;
    (pterm1[3] => pexpout) = (0, 0) ;
    (pterm1[4] => pexpout) = (0, 0) ;
    (pterm1[5] => pexpout) = (0, 0) ;
    (pterm1[6] => pexpout) = (0, 0) ;
    (pterm1[7] => pexpout) = (0, 0) ;
    (pterm1[8] => pexpout) = (0, 0) ;
    (pterm1[9] => pexpout) = (0, 0) ;
    (pterm1[10] => pexpout) = (0, 0) ;
    (pterm1[11] => pexpout) = (0, 0) ;
    (pterm1[12] => pexpout) = (0, 0) ;
    (pterm1[13] => pexpout) = (0, 0) ;
    (pterm1[14] => pexpout) = (0, 0) ;
    (pterm1[15] => pexpout) = (0, 0) ;
    (pterm1[16] => pexpout) = (0, 0) ;
    (pterm1[17] => pexpout) = (0, 0) ;
    (pterm1[18] => pexpout) = (0, 0) ;
    (pterm1[19] => pexpout) = (0, 0) ;
    (pterm1[20] => pexpout) = (0, 0) ;
    (pterm1[21] => pexpout) = (0, 0) ;
    (pterm1[22] => pexpout) = (0, 0) ;
    (pterm1[23] => pexpout) = (0, 0) ;
    (pterm1[24] => pexpout) = (0, 0) ;
    (pterm1[25] => pexpout) = (0, 0) ;
    (pterm1[26] => pexpout) = (0, 0) ;
    (pterm1[27] => pexpout) = (0, 0) ;
    (pterm1[28] => pexpout) = (0, 0) ;
    (pterm1[29] => pexpout) = (0, 0) ;
    (pterm1[30] => pexpout) = (0, 0) ;
    (pterm1[31] => pexpout) = (0, 0) ;

    (pexpin => pexpout) = (0, 0) ;

    (pterm0[0] => regin) = (0, 0) ;
    (pterm0[1] => regin) = (0, 0) ;
    (pterm0[2] => regin) = (0, 0) ;
    (pterm0[3] => regin) = (0, 0) ;
    (pterm0[4] => regin) = (0, 0) ;
    (pterm0[5] => regin) = (0, 0) ;
    (pterm0[6] => regin) = (0, 0) ;
    (pterm0[7] => regin) = (0, 0) ;
    (pterm0[8] => regin) = (0, 0) ;
    (pterm0[9] => regin) = (0, 0) ;
    (pterm0[10] => regin) = (0, 0) ;
    (pterm0[11] => regin) = (0, 0) ;
    (pterm0[12] => regin) = (0, 0) ;
    (pterm0[13] => regin) = (0, 0) ;
    (pterm0[14] => regin) = (0, 0) ;
    (pterm0[15] => regin) = (0, 0) ;
    (pterm0[16] => regin) = (0, 0) ;
    (pterm0[17] => regin) = (0, 0) ;
    (pterm0[18] => regin) = (0, 0) ;
    (pterm0[19] => regin) = (0, 0) ;
    (pterm0[20] => regin) = (0, 0) ;
    (pterm0[21] => regin) = (0, 0) ;
    (pterm0[22] => regin) = (0, 0) ;
    (pterm0[23] => regin) = (0, 0) ;
    (pterm0[24] => regin) = (0, 0) ;
    (pterm0[25] => regin) = (0, 0) ;
    (pterm0[26] => regin) = (0, 0) ;
    (pterm0[27] => regin) = (0, 0) ;
    (pterm0[28] => regin) = (0, 0) ;
    (pterm0[29] => regin) = (0, 0) ;
    (pterm0[30] => regin) = (0, 0) ;
    (pterm0[31] => regin) = (0, 0) ;

    (pterm1[0] => regin) = (0, 0) ;
    (pterm1[1] => regin) = (0, 0) ;
    (pterm1[2] => regin) = (0, 0) ;
    (pterm1[3] => regin) = (0, 0) ;
    (pterm1[4] => regin) = (0, 0) ;
    (pterm1[5] => regin) = (0, 0) ;
    (pterm1[6] => regin) = (0, 0) ;
    (pterm1[7] => regin) = (0, 0) ;
    (pterm1[8] => regin) = (0, 0) ;
    (pterm1[9] => regin) = (0, 0) ;
    (pterm1[10] => regin) = (0, 0) ;
    (pterm1[11] => regin) = (0, 0) ;
    (pterm1[12] => regin) = (0, 0) ;
    (pterm1[13] => regin) = (0, 0) ;
    (pterm1[14] => regin) = (0, 0) ;
    (pterm1[15] => regin) = (0, 0) ;
    (pterm1[16] => regin) = (0, 0) ;
    (pterm1[17] => regin) = (0, 0) ;
    (pterm1[18] => regin) = (0, 0) ;
    (pterm1[19] => regin) = (0, 0) ;
    (pterm1[20] => regin) = (0, 0) ;
    (pterm1[21] => regin) = (0, 0) ;
    (pterm1[22] => regin) = (0, 0) ;
    (pterm1[23] => regin) = (0, 0) ;
    (pterm1[24] => regin) = (0, 0) ;
    (pterm1[25] => regin) = (0, 0) ;
    (pterm1[26] => regin) = (0, 0) ;
    (pterm1[27] => regin) = (0, 0) ;
    (pterm1[28] => regin) = (0, 0) ;
    (pterm1[29] => regin) = (0, 0) ;
    (pterm1[30] => regin) = (0, 0) ;
    (pterm1[31] => regin) = (0, 0) ;
    (pexpin => regin) = (0, 0) ;
    (fbkin => regin) = (0, 0) ;
    (fbkin => pexpout) = (0, 0) ;
    (fbkin => combout) = (0, 0) ;

    endspecify

    assign iipterm1 = (invert_pterm1_mode == "true") ? ~&ipterm1 : &ipterm1;

always @ (ipterm0 or iipterm1 or ipexpin or fbkin) begin
	if (operation_mode == "normal")
		icomb = &ipterm0 | iipterm1 | ipexpin;
	else if (operation_mode == "invert")
		icomb = (&ipterm0 | iipterm1 | ipexpin) ^ 'b1;
	else if (operation_mode == "xor")
		icomb = (iipterm1 | ipexpin) ^ &ipterm0;
	else if (operation_mode == "packed_pterm_exp")
	begin
		icomb = &ipterm0;
		ipexpout = iipterm1 | ipexpin; 
	end
	else if (operation_mode == "pterm_exp")
		ipexpout = &ipterm0 | iipterm1 | ipexpin;
	else if (operation_mode == "tff")
		icomb = (&ipterm0 | iipterm1 | ipexpin) ^ fbkin;
	else if (operation_mode == "tbarff")
		icomb = (&ipterm0 | iipterm1 | ipexpin) ^ ~fbkin;
	else if (operation_mode == "packed_tff")
	begin
		icomb = (fbkin ^ 1'b1); // feed the regin port
		ipexpout = &ipterm0 | iipterm1 | ipexpin;
	end
	else
	begin
		icomb = 'bz;
		ipexpout = 'bz;
	end
end 


and (pexpout, ipexpout, 1'b1);
and (combout, icomb, 1'b1);
and (regin, icomb, 1'b1);

endmodule

//
//   APEX20KE PTERM REG
//
`timescale 1 ps/1 ps
module  apex20ke_pterm_register (datain, clk, ena, aclr, devclrn, devpor,
                            regout, fbkout);
    parameter power_up    = "low";

    input  datain, clk, ena, aclr, devpor, devclrn;
    output regout, fbkout;

    reg  iregout;
    wire reset;

    reg datain_viol, ena_viol;
    reg violation;

    buf (clk_in, clk);
    buf (iena, ena);
    buf (iclr, aclr);

    assign reset = devpor && devclrn && (!aclr);

    specify

    $setuphold (posedge clk &&& reset, datain, 0, 0) ;

    $setuphold (posedge clk &&& reset, ena, 0, 0) ;

    (posedge clk => (regout +: datain)) = 0 ;
    (posedge aclr => (regout +: 1'b0)) = (0, 0) ;

    (posedge clk => (fbkout +: datain)) = 0 ;
    (posedge aclr => (fbkout +: 1'b0)) = (0, 0) ;

    endspecify

    initial
    begin
       violation = 0;
       if (power_up == "low")
          iregout <= 'b0;
       else if (power_up == "high")
          iregout <= 'b1;
    end

    always @(datain_viol or ena_viol)
    begin
       violation = 1;
    end

   always @ (posedge clk_in or posedge iclr or negedge devclrn or 
	     negedge devpor or posedge violation)
     begin
	if (devpor == 'b0)
	  begin
	     if (power_up == "low")
	       iregout <= 0;
	     else if (power_up == "high")
	       iregout <= 1;
	  end
	else if (devclrn == 'b0)
	  iregout <= 0;
	else if (iclr == 1)
	  iregout <= 0;
	else if (violation == 1'b1)
	  begin
             violation = 0;
             iregout <= 'bx;
	  end
	else if (iena == 1) 
	  iregout <= datain;
     end       
   
and (regout, iregout, 1'b1);
and (fbkout, iregout, 1'b1);

endmodule

//
//   APEX20KE PTERM ATOM
//
`timescale 1 ps/1 ps
module  apex20ke_pterm (pterm0, pterm1, pexpin, clk, ena, aclr, 
                       devclrn, devpor, dataout, pexpout);

    parameter operation_mode	= "normal";
    parameter output_mode 	= "comb";
    parameter invert_pterm1_mode = "false";
    parameter power_up    = "low";

    input  [31:0] pterm0, pterm1;
    input  pexpin, clk, ena, aclr, devpor, devclrn;
    output dataout, pexpout;

    wire fbk, dffin, combo, dffo;
    

apex20ke_asynch_pterm pcom (pterm0, pterm1, pexpin, fbk, combo, pexpout, dffin);
apex20ke_pterm_register preg (dffin, clk, ena, aclr, devclrn, devpor, dffo, fbk);

    defparam
	pcom.operation_mode = operation_mode,
	pcom.invert_pterm1_mode = invert_pterm1_mode,
	preg.power_up = power_up;

assign dataout = (output_mode == "comb") ? combo : dffo;	

endmodule


//////////////////////////////////////////////////////////////////////////////
//
// Module Name : APEX20KE_ASYNCH_MEM
//
// Description : Timing simulation model for the asynchronous RAM array
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module apex20ke_asynch_mem (datain,
                            we,
                            re,
                            raddr,
                            waddr,
                            modesel,
                            dataout);

    // INPUT PORTS
    input   datain;
    input   we;
    input   re;
    input   [15:0] raddr;
    input   [15:0] waddr;
    input   [17:0] modesel;

    // OUTPUT PORTS
    output dataout;

    // GLOBAL PARAMETERS
    parameter logical_ram_depth     = 2048;
    parameter infile                = "none";
    parameter address_width         = 16;
    parameter deep_ram_mode         = "off";
    parameter first_address         = 0;
    parameter last_address          = 2047;
    parameter mem1                  = 512'b0;
    parameter mem2                  = 512'b0;
    parameter mem3                  = 512'b0;
    parameter mem4                  = 512'b0;
    parameter bit_number            = 0;
    parameter write_logic_clock     = "none";
    parameter read_enable_clock     = "none";
    parameter data_out_clock        = "none";
    parameter operation_mode        = "single_port";

    // INTERNAL VARIABLES AND NETS
    reg tmp_dataout, deep_ram_read, deep_ram_write;
    reg write_en, read_en;
    reg write_en_last_value;
    reg [10:0] rword, wword;
    reg [15:0] raddr_tmp, waddr_tmp;
    reg [2047:0] mem;
    wire [15:0] waddr_in, raddr_in;
    integer i;

    // BUFFER INPUTS
    buf (we_in, we);
    buf (re_in, re);
    buf (datain_in, datain);

    buf (waddr_in[0], waddr[0]);
    buf (waddr_in[1], waddr[1]);
    buf (waddr_in[2], waddr[2]);
    buf (waddr_in[3], waddr[3]);
    buf (waddr_in[4], waddr[4]);
    buf (waddr_in[5], waddr[5]);
    buf (waddr_in[6], waddr[6]);
    buf (waddr_in[7], waddr[7]);
    buf (waddr_in[8], waddr[8]);
    buf (waddr_in[9], waddr[9]);
    buf (waddr_in[10], waddr[10]);
    buf (waddr_in[11], waddr[11]);
    buf (waddr_in[12], waddr[12]);
    buf (waddr_in[13], waddr[13]);
    buf (waddr_in[14], waddr[14]);
    buf (waddr_in[15], waddr[15]);

    buf (raddr_in[0], raddr[0]);
    buf (raddr_in[1], raddr[1]);
    buf (raddr_in[2], raddr[2]);
    buf (raddr_in[3], raddr[3]);
    buf (raddr_in[4], raddr[4]);
    buf (raddr_in[5], raddr[5]);
    buf (raddr_in[6], raddr[6]);
    buf (raddr_in[7], raddr[7]);
    buf (raddr_in[8], raddr[8]);
    buf (raddr_in[9], raddr[9]);
    buf (raddr_in[10], raddr[10]);
    buf (raddr_in[11], raddr[11]);
    buf (raddr_in[12], raddr[12]);
    buf (raddr_in[13], raddr[13]);
    buf (raddr_in[14], raddr[14]);
    buf (raddr_in[15], raddr[15]);

    // TIMING PATHS
    specify
     
       $setup (waddr[0], posedge we &&& (~modesel[2]), 0);
       $setup (waddr[1], posedge we &&& (~modesel[2]), 0);
       $setup (waddr[2], posedge we &&& (~modesel[2]), 0);
       $setup (waddr[3], posedge we &&& (~modesel[2]), 0);
       $setup (waddr[4], posedge we &&& (~modesel[2]), 0);
       $setup (waddr[5], posedge we &&& (~modesel[2]), 0);
       $setup (waddr[6], posedge we &&& (~modesel[2]), 0);
       $setup (waddr[7], posedge we &&& (~modesel[2]), 0);
       $setup (waddr[8], posedge we &&& (~modesel[2]), 0);
       $setup (waddr[9], posedge we &&& (~modesel[2]), 0);
       $setup (waddr[10], posedge we &&& (~modesel[2]), 0);
       $setup (waddr[11], posedge we &&& (~modesel[2]), 0);
       $setup (waddr[12], posedge we &&& (~modesel[2]), 0);
       $setup (waddr[13], posedge we &&& (~modesel[2]), 0);
       $setup (waddr[14], posedge we &&& (~modesel[2]), 0);
       $setup (waddr[15], posedge we &&& (~modesel[2]), 0);

       $setuphold (negedge re &&& (~modesel[4]), raddr[0], 0, 0);
       $setuphold (negedge re &&& (~modesel[4]), raddr[1], 0, 0);
       $setuphold (negedge re &&& (~modesel[4]), raddr[2], 0, 0);
       $setuphold (negedge re &&& (~modesel[4]), raddr[3], 0, 0);
       $setuphold (negedge re &&& (~modesel[4]), raddr[4], 0, 0);
       $setuphold (negedge re &&& (~modesel[4]), raddr[5], 0, 0);
       $setuphold (negedge re &&& (~modesel[4]), raddr[6], 0, 0);
       $setuphold (negedge re &&& (~modesel[4]), raddr[7], 0, 0);
       $setuphold (negedge re &&& (~modesel[4]), raddr[8], 0, 0);
       $setuphold (negedge re &&& (~modesel[4]), raddr[9], 0, 0);
       $setuphold (negedge re &&& (~modesel[4]), raddr[10], 0, 0);
       $setuphold (negedge re &&& (~modesel[4]), raddr[11], 0, 0);
       $setuphold (negedge re &&& (~modesel[4]), raddr[12], 0, 0);
       $setuphold (negedge re &&& (~modesel[4]), raddr[13], 0, 0);
       $setuphold (negedge re &&& (~modesel[4]), raddr[14], 0, 0);
       $setuphold (negedge re &&& (~modesel[4]), raddr[15], 0, 0);

       $setuphold (negedge we &&& (~modesel[0]), datain, 0, 0);

       $hold (negedge we &&& (~modesel[2]), waddr[0], 0);
       $hold (negedge we &&& (~modesel[2]), waddr[1], 0);
       $hold (negedge we &&& (~modesel[2]), waddr[2], 0);
       $hold (negedge we &&& (~modesel[2]), waddr[3], 0);
       $hold (negedge we &&& (~modesel[2]), waddr[4], 0);
       $hold (negedge we &&& (~modesel[2]), waddr[5], 0);
       $hold (negedge we &&& (~modesel[2]), waddr[6], 0);
       $hold (negedge we &&& (~modesel[2]), waddr[7], 0);
       $hold (negedge we &&& (~modesel[2]), waddr[8], 0);
       $hold (negedge we &&& (~modesel[2]), waddr[9], 0);
       $hold (negedge we &&& (~modesel[2]), waddr[10], 0);
       $hold (negedge we &&& (~modesel[2]), waddr[11], 0);
       $hold (negedge we &&& (~modesel[2]), waddr[12], 0);
       $hold (negedge we &&& (~modesel[2]), waddr[13], 0);
       $hold (negedge we &&& (~modesel[2]), waddr[14], 0);
       $hold (negedge we &&& (~modesel[2]), waddr[15], 0);

       $nochange (posedge we &&& (~modesel[2]), waddr, 0, 0);

       $width (posedge we, 0);
       $width (posedge re, 0);

       (raddr[0] => dataout) = (0, 0);
       (raddr[1] => dataout) = (0, 0);
       (raddr[2] => dataout) = (0, 0);
       (raddr[3] => dataout) = (0, 0);
       (raddr[4] => dataout) = (0, 0);
       (raddr[5] => dataout) = (0, 0);
       (raddr[6] => dataout) = (0, 0);
       (raddr[7] => dataout) = (0, 0);
       (raddr[8] => dataout) = (0, 0);
       (raddr[9] => dataout) = (0, 0);
       (raddr[10] => dataout) = (0, 0);
       (raddr[11] => dataout) = (0, 0);
       (raddr[12] => dataout) = (0, 0);
       (raddr[13] => dataout) = (0, 0);
       (raddr[14] => dataout) = (0, 0);
       (raddr[15] => dataout) = (0, 0);
       (waddr[0] => dataout) = (0, 0);
       (waddr[1] => dataout) = (0, 0);
       (waddr[2] => dataout) = (0, 0);
       (waddr[3] => dataout) = (0, 0);
       (waddr[4] => dataout) = (0, 0);
       (waddr[5] => dataout) = (0, 0);
       (waddr[6] => dataout) = (0, 0);
       (waddr[7] => dataout) = (0, 0);
       (waddr[8] => dataout) = (0, 0);
       (waddr[9] => dataout) = (0, 0);
       (waddr[10] => dataout) = (0, 0);
       (waddr[11] => dataout) = (0, 0);
       (waddr[12] => dataout) = (0, 0);
       (waddr[13] => dataout) = (0, 0);
       (waddr[14] => dataout) = (0, 0);
       (waddr[15] => dataout) = (0, 0);
       (re => dataout) = (0, 0);
       (we => dataout) = (0, 0);
       (datain => dataout) = (0, 0);

    endspecify

    initial
    begin
       mem = {mem4, mem3, mem2, mem1};
       if ((operation_mode != "rom") && (write_logic_clock == "none"))
       begin
          for (i = 0; i <= 2047; i=i+1)
             mem[i] = 'bx;
       end
       tmp_dataout = 'b0;
       if ((operation_mode == "rom") || (operation_mode == "single_port"))
       begin
          // re is always active, so read memory contents
          tmp_dataout = mem[0];
       end
       else begin
          // re is inactive
          tmp_dataout = 'b0;
       end
       if (read_enable_clock != "none")
       begin
          if ((operation_mode == "rom") || (operation_mode == "single_port"))
          begin
             // re is active
             tmp_dataout = mem[0];
          end
          else begin
             // eab cell output powers up to VCC
             tmp_dataout = 'b1;
          end
       end
    end

    always @(we_in or re_in or raddr_in or waddr_in or datain_in)
    begin
       rword = raddr_in[10:0];
       wword = waddr_in[10:0];
       deep_ram_read = raddr_in[15:11];
       deep_ram_write = raddr_in[15:11];
       raddr_tmp = raddr_in;
       waddr_tmp = waddr_in;

       if (deep_ram_mode == "off")
       begin
          read_en = re_in;
          write_en = we_in;
       end
       else begin
          if ((raddr_tmp <= last_address) && (raddr_tmp >= first_address))
             read_en = re_in;
          else
             read_en = 0;
          if ((waddr_tmp <= last_address) && (waddr_tmp >= first_address))
             write_en = we_in;
          else
             write_en = 0;
       end 
 
       if (modesel[17:16] == 2'b10)
       begin
          if (read_en == 1)
             tmp_dataout = mem[rword];
       end
       else if (modesel[17:16] == 2'b00)
       begin
          if ((write_en == 0) && (write_en_last_value == 1))
             mem[wword] = datain_in;
          if (write_en == 0)
             tmp_dataout = mem[wword];
          else if (write_en == 1)
             tmp_dataout = datain_in;
          else tmp_dataout = 'bx;
       end
       else if (modesel[17:16] == 2'b01)
       begin
          if ((write_en == 0) && (write_en_last_value == 1))
             mem[wword] = datain_in;
          if ((read_en == 1) && (rword == wword) && (write_en == 1))
             tmp_dataout = datain_in;
          else if (read_en == 1)
             tmp_dataout = mem[rword];
       end
       write_en_last_value = write_en;
    end

    // ACCELERATE OUTPUT
    and (dataout, tmp_dataout, 1'b1);

endmodule // apex20ke_asynch_mem


//////////////////////////////////////////////////////////////////////////////
//
// Module Name : PRIM_DFFE
//
// Description : State table for UDP PRIM_DFFE
//
//////////////////////////////////////////////////////////////////////////////

primitive PRIM_DFFE (Q, ENA, D, CLK, CLRN, PRN, notifier);
    input D;   
    input CLRN;
    input PRN;
    input CLK;
    input ENA;
    input notifier;
    output Q; reg Q;

    initial Q = 1'b0;

    table

    //  ENA  D   CLK   CLRN  PRN  notifier  :   Qt  :   Qt+1

        (??) ?    ?      1    1      ?      :   ?   :   -;  // pessimism
         x   ?    ?      1    1      ?      :   ?   :   -;  // pessimism
         1   1   (01)    1    1      ?      :   ?   :   1;  // clocked data
         1   1   (01)    1    x      ?      :   ?   :   1;  // pessimism
 
         1   1    ?      1    x      ?      :   1   :   1;  // pessimism
 
         1   0    0      1    x      ?      :   1   :   1;  // pessimism
         1   0    x      1  (?x)     ?      :   1   :   1;  // pessimism
         1   0    1      1  (?x)     ?      :   1   :   1;  // pessimism
 
         1   x    0      1    x      ?      :   1   :   1;  // pessimism
         1   x    x      1  (?x)     ?      :   1   :   1;  // pessimism
         1   x    1      1  (?x)     ?      :   1   :   1;  // pessimism
 
         1   0   (01)    1    1      ?      :   ?   :   0;  // clocked data

         1   0   (01)    x    1      ?      :   ?   :   0;  // pessimism

         1   0    ?      x    1      ?      :   0   :   0;  // pessimism
         0   ?    ?      x    1      ?      :   ?   :   -;

         1   1    0      x    1      ?      :   0   :   0;  // pessimism
         1   1    x    (?x)   1      ?      :   0   :   0;  // pessimism
         1   1    1    (?x)   1      ?      :   0   :   0;  // pessimism

         1   x    0      x    1      ?      :   0   :   0;  // pessimism
         1   x    x    (?x)   1      ?      :   0   :   0;  // pessimism
         1   x    1    (?x)   1      ?      :   0   :   0;  // pessimism

         1   1   (x1)    1    1      ?      :   1   :   1;  // reducing pessimism
         1   0   (x1)    1    1      ?      :   0   :   0;
         1   1   (0x)    1    1      ?      :   1   :   1;
         1   0   (0x)    1    1      ?      :   0   :   0;

         ?   ?   ?       0    1      ?      :   ?   :   0;  // asynch clear

         ?   ?   ?       1    0      ?      :   ?   :   1;  // asynch set

         1   ?   (?0)    1    1      ?      :   ?   :   -;  // ignore falling clock
         1   ?   (1x)    1    1      ?      :   ?   :   -;  // ignore falling clock
         1   *    ?      ?    ?      ?      :   ?   :   -; // ignore data edges

         1   ?   ?     (?1)   ?      ?      :   ?   :   -;  // ignore edges on
         1   ?   ?       ?  (?1)     ?      :   ?   :   -;  //  set and clear

         0   ?   ?       1    1      ?      :   ?   :   -;  //  set and clear

	 ?   ?   ?       1    1      *      :   ?   :   x; // spr 36954 - at any
							   // notifier event,
							   // output 'x'
    endtable

endprimitive // PRIM_DFFE


//////////////////////////////////////////////////////////////////////////////
//
// Module Name : DFFE
//
// Description : Timing simulation model for a DFFE register
//
//////////////////////////////////////////////////////////////////////////////

module dffe ( Q,
              CLK,
              ENA,
              D,
              CLRN,
              PRN );

    // INPUT PORTS
    input D;
    input CLK;
    input CLRN;
    input PRN;
    input ENA;

    // OUTPUT PORTS
    output Q;

    // INTERNAL VARIABLES AND NETS
    wire legal;
    reg viol_notifier;

    // INSTANTIATE THE UDP
    PRIM_DFFE ( Q, ENA, D, CLK, CLRN, PRN, viol_notifier );

    // filter out illegal values like 'X'
    and(legal, ENA, CLRN, PRN);

    specify

        specparam TREG = 0;
        specparam TREN = 0;
        specparam TRSU = 0;
        specparam TRH  = 0;
        specparam TRPR = 0;
        specparam TRCL = 0;
 
        $setup  (  D, posedge CLK &&& legal, TRSU, viol_notifier  ) ;
        $hold   (  posedge CLK &&& legal, D, TRH, viol_notifier   ) ;
        $setup  (  ENA, posedge CLK &&& legal, TREN, viol_notifier  ) ;
        $hold   (  posedge CLK &&& legal, ENA, 0, viol_notifier   ) ;
 
        ( negedge CLRN => (Q  +: 1'b0)) = ( TRCL, TRCL) ;
        ( negedge PRN  => (Q  +: 1'b1)) = ( TRPR, TRPR) ;
        ( posedge CLK  => (Q  +: D)) = ( TREG, TREG) ;
 
    endspecify

endmodule // dffe

//////////////////////////////////////////////////////////////////////////////
//
// Module Name : DFFE_IO
//
// Description : Timing simulation model for a DFFE register for IO atom
//
//////////////////////////////////////////////////////////////////////////////

module dffe_io ( Q, CLK, ENA, D, CLRN, PRN );
    input D;
    input CLK;
    input CLRN;
    input PRN;
    input ENA;
    output Q;

    buf (D_ipd, D);
    buf (ENA_ipd, ENA);
    buf (CLK_ipd, CLK);
    buf (PRN_ipd, PRN);
    buf (CLRN_ipd, CLRN);

    wire legal;
    reg viol_notifier;

    PRIM_DFFE ( Q, ENA_ipd, D_ipd, CLK_ipd, CLRN_ipd, PRN_ipd, viol_notifier);

    and(legal, ENA_ipd, CLRN_ipd, PRN_ipd);

    specify

        specparam TREG = 0;
        specparam TREN = 0;
        specparam TRSU = 0;
        specparam TRH  = 0;
        specparam TRPR = 0;
        specparam TRCL = 0;
 
        $setup  (  D, posedge CLK &&& legal, TRSU, viol_notifier  ) ;
        $hold   (  posedge CLK &&& legal, D, TRH, viol_notifier   ) ;
        $setup  (  ENA, posedge CLK &&& legal, TREN, viol_notifier  ) ;
        $hold   (  posedge CLK &&& legal, ENA, 0, viol_notifier   ) ;
 
        ( negedge CLRN => (Q  +: 1'b0)) = ( TRCL, TRCL) ;
        ( negedge PRN  => (Q  +: 1'b1)) = ( TRPR, TRPR) ;
        ( posedge CLK  => (Q  +: D)) = ( TREG, TREG) ;
 
    endspecify

endmodule // dffe_io

//////////////////////////////////////////////////////////////////////////////
//
// Module Name : mux21
//
// Description : Simulation model for a 2 to 1 mux used in the RAM_SLICE
//               This is a purely functional module, without any timing.
//
//////////////////////////////////////////////////////////////////////////////

module mux21 (MO,
              A,
              B,
              S);

    input A, B, S;
    output MO;

    assign MO = (S == 1) ? B : A;

endmodule

//////////////////////////////////////////////////////////////////////////////
//
// Module Name : and1
//
// Description : Simulation model for a 1-input AND gate
//
//////////////////////////////////////////////////////////////////////////////

module and1 (Y,
             IN1);

    input IN1;
    output Y;

    specify
       (IN1 => Y) = (0, 0);
    endspecify

    buf (Y, IN1);

endmodule

//////////////////////////////////////////////////////////////////////////////
//
// Module Name : and16
//
// Description : Simulation model for a 16 input AND gate
//
//////////////////////////////////////////////////////////////////////////////

module and16 (Y, IN1);
input [15:0] IN1;
output [15:0] Y;

    specify
       (IN1 => Y) = (0, 0);
    endspecify

buf (Y[0], IN1[0]);
buf (Y[1], IN1[1]);
buf (Y[2], IN1[2]);
buf (Y[3], IN1[3]);
buf (Y[4], IN1[4]);
buf (Y[5], IN1[5]);
buf (Y[6], IN1[6]);
buf (Y[7], IN1[7]);
buf (Y[8], IN1[8]);
buf (Y[9], IN1[9]);
buf (Y[10], IN1[10]);
buf (Y[11], IN1[11]);
buf (Y[12], IN1[12]);
buf (Y[13], IN1[13]);
buf (Y[14], IN1[14]);
buf (Y[15], IN1[15]);

endmodule

//////////////////////////////////////////////////////////////////////////////
//
// Module Name : nmux21
//
// Description : Simulation model for a 2 to 1 mux used in the RAM_SLICE.
//               The output is an inversion of the selected input.
//               This is a purely functional module, without any timing.
//
//////////////////////////////////////////////////////////////////////////////

module nmux21 (MO,
               A,
               B,
               S);

    input A, B, S; 
    output MO; 
 
    assign MO = (S == 1) ? ~B : ~A; 
 
endmodule

//////////////////////////////////////////////////////////////////////////////
//
// Module Name : bmux21
//
// Description : Simulation model for a 2 to 1 mux used in the RAM_SLICE.
//               Each input is a 16-bit bus.
//               This is a purely functional module, without any timing.
//
//////////////////////////////////////////////////////////////////////////////

module bmux21 (MO,
               A,
               B,
               S);

    input [15:0] A, B;
    input S;
    output [15:0] MO; 
 
    assign MO = (S == 1) ? B : A; 
 
endmodule

//////////////////////////////////////////////////////////////////////////////
//
// Module Name : b5mux21
//
// Description : Simulation model for a 2 to 1 mux used in the CAM_SLICE.
//               Each input is a 5-bit bus.
//               This is a purely functional module, without any timing.
//
//////////////////////////////////////////////////////////////////////////////

module b5mux21 (MO,
                A,
                B,
                S);

    input [4:0] A, B;
    input S;
    output [4:0] MO; 
 
    assign MO = (S == 1) ? B : A; 
 
endmodule

//////////////////////////////////////////////////////////////////////////////
//
// Module Name : APEX20KE_RAM_SLICE
//
// Description : timing simulation model for single RAM segment of the
//               APEX20KE family.
//
// Assumptions : Default values for unconnected ports will be passed from
//               the Quartus .vo netlist
//
/////////////////////////////////////////////////////////////////////////////

module apex20ke_ram_slice (datain,
                           clk0,
                           clk1,
                           clr0,
                           clr1,
                           ena0,
                           ena1, 
                           we,
                           re,
                           raddr,
                           waddr,
                           devclrn,
                           devpor,
                           modesel,
                           dataout);

    // INPUT PORTS
    input  datain, clk0, clk1;
    input  clr0, clr1, ena0, ena1;
    input  we, re, devclrn, devpor; 
    input  [15:0] raddr, waddr;
    input  [17:0] modesel;

    // OUTPUT PORTS
    output dataout;

    // GLOBAL PARAMETERS
    parameter operation_mode         = "single_port";
    parameter deep_ram_mode          = "off";
    parameter logical_ram_name       = "ram_xxx";
    parameter logical_ram_depth      = "2k";
    parameter logical_ram_width      = "1";
    parameter address_width          = 16;
    parameter data_in_clock          = "none";
    parameter data_in_clear          = "none";
    parameter write_logic_clock      = "none";
    parameter write_logic_clear      = "none";
    parameter read_enable_clock      = "none";
    parameter read_enable_clear      = "none";
    parameter read_address_clock     = "none";
    parameter read_address_clear     = "none";
    parameter data_out_clock         = "none";
    parameter data_out_clear         = "none";
    parameter init_file              = "none";
    parameter first_address          = 0;
    parameter last_address           = 2047;
    parameter bit_number             = "1";
    parameter power_up               = "low";
    parameter mem1                   = 512'b0;
    parameter mem2                   = 512'b0;
    parameter mem3                   = 512'b0;
    parameter mem4                   = 512'b0;

    // INTERNAL VARIABLES AND NETS
    wire  datain_reg, we_reg, re_reg, dataout_reg;
    wire  we_reg_mux, we_reg_mux_delayed;
    wire  [15:0] raddr_reg, waddr_reg;
    wire  datain_int, we_int, re_int, dataout_int, dataout_tmp;
    wire  [15:0] raddr_int, waddr_int;
    wire  reen, raddren, dataouten;
    wire  datain_clr;
    wire  re_clk, re_clr, raddr_clk, raddr_clr;
    wire  dataout_clk, dataout_clr;
    wire  datain_reg_sel, write_reg_sel, raddr_reg_sel;
    wire  re_reg_sel, dataout_reg_sel, re_clk_sel, re_en_sel;
    wire  re_clr_sel, raddr_clk_sel, raddr_clr_sel, raddr_en_sel;
    wire  dataout_clk_sel, dataout_clr_sel, dataout_en_sel;
    wire  datain_reg_clr, write_reg_clr, raddr_reg_clr;
    wire  re_reg_clr, dataout_reg_clr;
    wire  datain_reg_clr_sel, write_reg_clr_sel, raddr_reg_clr_sel;
    wire  re_reg_clr_sel, dataout_reg_clr_sel, NC;
    wire  we_pulse;

    wire clk0_delayed;
    reg we_int_delayed, datain_int_delayed;
    reg [15:0] waddr_int_delayed;

    // PULLUPs
    tri1 iena0;
    tri1 iena1;

    assign datain_reg_sel          = modesel[0];
    assign datain_reg_clr_sel      = modesel[1];
    assign write_reg_sel           = modesel[2];
    assign write_reg_clr_sel       = modesel[3];
    assign raddr_reg_sel           = modesel[4];
    assign raddr_reg_clr_sel       = modesel[5];
    assign re_reg_sel              = modesel[6];
    assign re_reg_clr_sel          = modesel[7];
    assign dataout_reg_sel         = modesel[8];
    assign dataout_reg_clr_sel     = modesel[9];
    assign re_clk_sel              = modesel[10];
    assign re_en_sel               = modesel[10];
    assign re_clr_sel              = modesel[11];
    assign raddr_clk_sel           = modesel[12];
    assign raddr_en_sel            = modesel[12];
    assign raddr_clr_sel           = modesel[13];
    assign dataout_clk_sel         = modesel[14];
    assign dataout_en_sel          = modesel[14];
    assign dataout_clr_sel         = modesel[15];

    assign iena0 = ena0;
    assign iena1 = ena1;

    assign NC = 0;

    always @ (datain_int or waddr_int or we_int)
    begin
       we_int_delayed = we_int;
       waddr_int_delayed <= waddr_int;
       datain_int_delayed <= datain_int;
    end

    mux21     datainsel      (datain_int,
                              datain,
                              datain_reg,
                              datain_reg_sel
                             );

    nmux21    datainregclr   (datain_reg_clr,
                              NC,
                              clr0,
                              datain_reg_clr_sel
                             );

    bmux21    waddrsel       (waddr_int,
                              waddr,
                              waddr_reg,
                              write_reg_sel
                             );

    nmux21    writeregclr    (write_reg_clr,
                              NC,
                              clr0,
                              write_reg_clr_sel
                             );

    mux21     wesel2         (we_int,
                              we_reg_mux_delayed,
                              we_pulse,
                              write_reg_sel
                             );

    mux21     wesel1         (we_reg_mux,
                              we,
                              we_reg,
                              write_reg_sel
                             );

    bmux21    raddrsel       (raddr_int,
                              raddr,
                              raddr_reg,
                              raddr_reg_sel
                             );

    nmux21    raddrregclr    (raddr_reg_clr,
                              NC,
                              raddr_clr,
                              raddr_reg_clr_sel
                             );

    mux21     resel          (re_int,
                              re,
                              re_reg,
                              re_reg_sel
                             );

    mux21     dataoutsel     (dataout_tmp,
                              dataout_int,
                              dataout_reg,
                              dataout_reg_sel
                             );

    nmux21    dataoutregclr  (dataout_reg_clr,
                              NC,
                              dataout_clr,
                              dataout_reg_clr_sel
                             );

    mux21     raddrclksel    (raddr_clk,
                              clk0,
                              clk1,
                              raddr_clk_sel
                             );

    mux21     raddrensel     (raddren,
                              iena0,
                              iena1,
                              raddr_en_sel
                             );

    mux21     raddrclrsel    (raddr_clr,
                              clr0,
                              clr1,
                              raddr_clr_sel
                             );

    mux21     reclksel       (re_clk,
                              clk0,
                              clk1,
                              re_clk_sel
                             );

    mux21     reensel        (reen,
                              iena0,
                              iena1,
                              re_en_sel
                             );

    mux21     reclrsel       (re_clr,
                              clr0,
                              clr1,
                              re_clr_sel
                             );

    nmux21    reregclr       (re_reg_clr,
                              NC,
                              re_clr,
                              re_reg_clr_sel
                             );

    mux21     dataoutclksel  (dataout_clk,
                              clk0,
                              clk1,
                              dataout_clk_sel
                             );

    mux21     dataoutensel   (dataouten,
                              iena0,
                              iena1,
                              dataout_en_sel
                             );

    mux21     dataoutclrsel  (dataout_clr,
                              clr0,
                              clr1,
                              dataout_clr_sel
                             );

    dffe      dinreg         (datain_reg,
                              clk0,
                              iena0,
                              datain,
                              datain_reg_clr && devclrn && devpor,
                              1'b1
                             );

    dffe      wereg          (we_reg,
                              clk0,
                              iena0,
                              we,
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    // clk0 for we_pulse should have same delay as clk of wereg
    and1      clk0weregdelaybuf (clk0_delayed,
                                 clk0
                                );
    assign  we_pulse = we_reg_mux_delayed && (~clk0_delayed);

    and1      wedelaybuf     (we_reg_mux_delayed,
                              we_reg_mux
                             );

    dffe      rereg          (re_reg,
                              re_clk,
                              reen,
                              re,
                              re_reg_clr && devclrn && devpor,
                              1'b1
                             );

    dffe      dataoutreg     (dataout_reg,
                              dataout_clk,
                              dataouten,
                              dataout_int, 
                              dataout_reg_clr && devclrn && devpor,
                              1'b1
                             );

    dffe      waddrreg_0     (waddr_reg[0],
                              clk0,
                              iena0,
                              waddr[0],
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    dffe      waddrreg_1     (waddr_reg[1],
                              clk0,
                              iena0,
                              waddr[1],
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    dffe      waddrreg_2     (waddr_reg[2],
                              clk0,
                              iena0,
                              waddr[2],
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    dffe      waddrreg_3     (waddr_reg[3],
                              clk0,
                              iena0,
                              waddr[3],
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    dffe      waddrreg_4     (waddr_reg[4],
                              clk0,
                              iena0,
                              waddr[4],
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    dffe      waddrreg_5     (waddr_reg[5],
                              clk0,
                              iena0,
                              waddr[5],
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    dffe      waddrreg_6     (waddr_reg[6],
                              clk0,
                              iena0,
                              waddr[6],
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    dffe      waddrreg_7     (waddr_reg[7],
                              clk0,
                              iena0,
                              waddr[7],
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    dffe      waddrreg_8     (waddr_reg[8],
                              clk0,
                              iena0,
                              waddr[8],
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    dffe      waddrreg_9     (waddr_reg[9],
                              clk0,
                              iena0,
                              waddr[9],
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    dffe      waddrreg_10    (waddr_reg[10],
                              clk0,
                              iena0,
                              waddr[10],
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    dffe      waddrreg_11    (waddr_reg[11],
                              clk0,
                              iena0,
                              waddr[11],
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    dffe      waddrreg_12    (waddr_reg[12],
                              clk0,
                              iena0,
                              waddr[12],
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    dffe      waddrreg_13    (waddr_reg[13],
                              clk0,
                              iena0,
                              waddr[13],
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    dffe      waddrreg_14    (waddr_reg[14],
                              clk0,
                              iena0,
                              waddr[14],
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    dffe      waddrreg_15    (waddr_reg[15],
                              clk0,
                              iena0,
                              waddr[15],
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    dffe      raddrreg_0     (raddr_reg[0],
                              raddr_clk,
                              raddren,
                              raddr[0],
                              raddr_reg_clr && devclrn && devpor,
                              1'b1
                             );

    dffe      raddrreg_1     (raddr_reg[1],
                              raddr_clk,
                              raddren,
                              raddr[1],
                              raddr_reg_clr && devclrn && devpor,
                              1'b1
                             );

    dffe      raddrreg_2     (raddr_reg[2],
                              raddr_clk,
                              raddren,
                              raddr[2],
                              raddr_reg_clr && devclrn && devpor,
                              1'b1
                             );

    dffe      raddrreg_3     (raddr_reg[3],
                              raddr_clk,
                              raddren,
                              raddr[3],
                              raddr_reg_clr && devclrn && devpor,
                              1'b1
                             );

    dffe      raddrreg_4     (raddr_reg[4],
                              raddr_clk,
                              raddren,
                              raddr[4],
                              raddr_reg_clr && devclrn && devpor,
                              1'b1
                             );

    dffe      raddrreg_5     (raddr_reg[5],
                              raddr_clk,
                              raddren,
                              raddr[5],
                              raddr_reg_clr && devclrn && devpor,
                              1'b1
                             );

    dffe      raddrreg_6     (raddr_reg[6],
                              raddr_clk,
                              raddren,
                              raddr[6],
                              raddr_reg_clr && devclrn && devpor,
                              1'b1
                             );

    dffe      raddrreg_7     (raddr_reg[7],
                              raddr_clk,
                              raddren,
                              raddr[7],
                              raddr_reg_clr && devclrn && devpor,
                              1'b1
                             );

    dffe      raddrreg_8     (raddr_reg[8],
                              raddr_clk,
                              raddren,
                              raddr[8],
                              raddr_reg_clr && devclrn && devpor,
                              1'b1
                             );

    dffe      raddrreg_9     (raddr_reg[9],
                              raddr_clk,
                              raddren,
                              raddr[9],
                              raddr_reg_clr && devclrn && devpor,
                              1'b1
                             );

    dffe      raddrreg_10    (raddr_reg[10],
                              raddr_clk,
                              raddren,
                              raddr[10],
                              raddr_reg_clr && devclrn && devpor,
                              1'b1
                             );

    dffe      raddrreg_11    (raddr_reg[11],
                              raddr_clk,
                              raddren,
                              raddr[11],
                              raddr_reg_clr && devclrn && devpor,
                              1'b1
                             );

    dffe      raddrreg_12    (raddr_reg[12],
                              raddr_clk,
                              raddren,
                              raddr[12],
                              raddr_reg_clr && devclrn && devpor,
                              1'b1
                             );

    dffe      raddrreg_13    (raddr_reg[13],
                              raddr_clk,
                              raddren,
                              raddr[13],
                              raddr_reg_clr && devclrn && devpor,
                              1'b1
                             );

    dffe      raddrreg_14    (raddr_reg[14],
                              raddr_clk,
                              raddren,
                              raddr[14],
                              raddr_reg_clr && devclrn && devpor,
                              1'b1
                             );

    dffe      raddrreg_15    (raddr_reg[15],
                              raddr_clk,
                              raddren,
                              raddr[15],
                              raddr_reg_clr && devclrn && devpor,
                              1'b1
                             );


    apex20ke_asynch_mem apexmem (.datain (datain_int_delayed),
                                 .we (we_int_delayed),
                                 .re (re_int),
                                 .raddr (raddr_int),
                                 .waddr (waddr_int_delayed),
                                 .modesel (modesel),
                                 .dataout (dataout_int)
                                );

    defparam
        apexmem.address_width          = address_width,
        apexmem.bit_number             = bit_number,
        apexmem.deep_ram_mode          = deep_ram_mode,
        apexmem.logical_ram_depth      = logical_ram_depth,
        apexmem.first_address          = first_address,
        apexmem.last_address           = last_address,
        apexmem.write_logic_clock      = write_logic_clock,
        apexmem.read_enable_clock      = read_enable_clock,
        apexmem.data_out_clock         = data_out_clock,
        apexmem.infile                 = init_file,
        apexmem.operation_mode         = operation_mode,
        apexmem.mem1                   = mem1,
        apexmem.mem2                   = mem2,
        apexmem.mem3                   = mem3,
        apexmem.mem4                   = mem4;


    assign dataout = (deep_ram_mode != "off") ? ((raddr_int <= last_address) ? (raddr_int >= first_address ? dataout_tmp : 'bz) : 'bz ) : dataout_tmp;

endmodule // apex20ke_ram_slice


//////////////////////////////////////////////////////////////////////////////
//
// Module Name : APEX20KE_CAM
//
// Description : Timing simulation model for the asynchronous CAM
//
//////////////////////////////////////////////////////////////////////////////

module apex20ke_cam (waddr,
                     we,
                     datain,
                     wrinvert,
                     lit,
                     outputselect,
                     matchout,
                     matchfound,
                     modesel);

    // INPUT PORTS
    input we;
    input wrinvert;
    input datain;
    input outputselect;
    input [4:0] waddr;
    input [1:0] modesel;
    input [31:0] lit;

    // OUTPUT PORTS
    output [15:0] matchout;
    output matchfound;

    // GLOBAL PARAMETERS
    parameter operation_mode       = "encoded_address";
    parameter address_width        = 5;
    parameter pattern_width        = 32;
    parameter first_address        = 0;
    parameter last_address         = 31;
    parameter init_file            = "none";
    parameter init_filex           = "none";
    parameter init_mem_true1       = 512'b1;
    parameter init_mem_true2       = 512'b1;
    parameter init_mem_comp1       = 512'b1;
    parameter init_mem_comp2       = 512'b1;

    // INTERNAL VARIABLES AND NETS
    reg [address_width-1:0] encoded_match_addr;
    reg [pattern_width-1:0] pattern_tmp;
    reg [pattern_width-1:0] read_pattern;
    reg [pattern_width-1:0] compare_data;
    reg [pattern_width-1:0] temp;
    reg [4:0] wword;

    reg [31:0] NEVER_MATCH;
    reg [31:0] UNKNOWN;
    reg [31:0] temp_true;
    reg [31:0] temp_comp;

    reg [31:0] mem_true [0:31];
    reg [31:0] mem_comp [0:31];
    reg [31:0] memory [0:last_address-first_address];
    reg [31:0] memoryx [0:last_address-first_address];

    integer mem_depth, i, j, k;
    wire we_pulse;
    reg matchfound_tmp;
    reg [15:0] match_out;
    wire [15:0] matchout_tmp;
    reg m_found;
    reg continue;
    reg wdatain_last_value;
    reg we_pulse_last_value;
    reg wrinvert_last_value;
    reg [31:0] mult_match_array;
    reg [1023:0] init_mem_true;
    reg [1023:0] init_mem_comp;

    wire [4:0] waddr_in;
    wire [31:0] lit_in;

    // BUFFER INPUTS
    buf (we_in, we);
    buf (datain_in, datain);
    buf (wrinvert_in, wrinvert);
    buf (waddr_in[0], waddr[0]);
    buf (waddr_in[1], waddr[1]);
    buf (waddr_in[2], waddr[2]);
    buf (waddr_in[3], waddr[3]);
    buf (waddr_in[4], waddr[4]);
    buf (outputselect_in, outputselect);

    buf (lit_in[0], lit[0]);
    buf (lit_in[1], lit[1]);
    buf (lit_in[2], lit[2]);
    buf (lit_in[3], lit[3]);
    buf (lit_in[4], lit[4]);
    buf (lit_in[5], lit[5]);
    buf (lit_in[6], lit[6]);
    buf (lit_in[7], lit[7]);
    buf (lit_in[8], lit[8]);
    buf (lit_in[9], lit[9]);
    buf (lit_in[10], lit[10]);
    buf (lit_in[11], lit[11]);
    buf (lit_in[12], lit[12]);
    buf (lit_in[13], lit[13]);
    buf (lit_in[14], lit[14]);
    buf (lit_in[15], lit[15]);
    buf (lit_in[16], lit[16]);
    buf (lit_in[17], lit[17]);
    buf (lit_in[18], lit[18]);
    buf (lit_in[19], lit[19]);
    buf (lit_in[20], lit[20]);
    buf (lit_in[21], lit[21]);
    buf (lit_in[22], lit[22]);
    buf (lit_in[23], lit[23]);
    buf (lit_in[24], lit[24]);
    buf (lit_in[25], lit[25]);
    buf (lit_in[26], lit[26]);
    buf (lit_in[27], lit[27]);
    buf (lit_in[28], lit[28]);
    buf (lit_in[29], lit[29]);
    buf (lit_in[30], lit[30]);
    buf (lit_in[31], lit[31]);

    // TIMING PATHS
    specify
       $setuphold(posedge we, lit[0], 0, 0);
       $setuphold(posedge we, lit[1], 0, 0);
       $setuphold(posedge we, lit[2], 0, 0);
       $setuphold(posedge we, lit[3], 0, 0);
       $setuphold(posedge we, lit[4], 0, 0);
       $setuphold(posedge we, lit[5], 0, 0);
       $setuphold(posedge we, lit[6], 0, 0);
       $setuphold(posedge we, lit[7], 0, 0);
       $setuphold(posedge we, lit[8], 0, 0);
       $setuphold(posedge we, lit[9], 0, 0);
       $setuphold(posedge we, lit[10], 0, 0);
       $setuphold(posedge we, lit[11], 0, 0);
       $setuphold(posedge we, lit[12], 0, 0);
       $setuphold(posedge we, lit[13], 0, 0);
       $setuphold(posedge we, lit[14], 0, 0);
       $setuphold(posedge we, lit[15], 0, 0);
       $setuphold(posedge we, lit[16], 0, 0);
       $setuphold(posedge we, lit[17], 0, 0);
       $setuphold(posedge we, lit[18], 0, 0);
       $setuphold(posedge we, lit[19], 0, 0);
       $setuphold(posedge we, lit[20], 0, 0);
       $setuphold(posedge we, lit[21], 0, 0);
       $setuphold(posedge we, lit[22], 0, 0);
       $setuphold(posedge we, lit[23], 0, 0);
       $setuphold(posedge we, lit[24], 0, 0);
       $setuphold(posedge we, lit[25], 0, 0);
       $setuphold(posedge we, lit[26], 0, 0);
       $setuphold(posedge we, lit[27], 0, 0);
       $setuphold(posedge we, lit[28], 0, 0);
       $setuphold(posedge we, lit[29], 0, 0);
       $setuphold(posedge we, lit[30], 0, 0);
       $setuphold(posedge we, lit[31], 0, 0);

       $setuphold(negedge we, datain, 0, 0);
       $setuphold(posedge we, wrinvert, 0, 0);

       (we => matchout[0]) = (0, 0);
       (we => matchout[1]) = (0, 0);
       (we => matchout[2]) = (0, 0);
       (we => matchout[3]) = (0, 0);
       (we => matchout[4]) = (0, 0);
       (we => matchout[5]) = (0, 0);
       (we => matchout[6]) = (0, 0);
       (we => matchout[7]) = (0, 0);
       (we => matchout[8]) = (0, 0);
       (we => matchout[9]) = (0, 0);
       (we => matchout[10]) = (0, 0);
       (we => matchout[11]) = (0, 0);
       (we => matchout[12]) = (0, 0);
       (we => matchout[13]) = (0, 0);
       (we => matchout[14]) = (0, 0);
       (we => matchout[15]) = (0, 0);
       (we => matchfound) = (0, 0);

       (lit[0] => matchfound) = (0, 0);
       (lit[1] => matchfound) = (0, 0);
       (lit[2] => matchfound) = (0, 0);
       (lit[3] => matchfound) = (0, 0);
       (lit[4] => matchfound) = (0, 0);
       (lit[5] => matchfound) = (0, 0);
       (lit[6] => matchfound) = (0, 0);
       (lit[7] => matchfound) = (0, 0);
       (lit[8] => matchfound) = (0, 0);
       (lit[9] => matchfound) = (0, 0);
       (lit[10] => matchfound) = (0, 0);
       (lit[11] => matchfound) = (0, 0);
       (lit[12] => matchfound) = (0, 0);
       (lit[13] => matchfound) = (0, 0);
       (lit[14] => matchfound) = (0, 0);
       (lit[15] => matchfound) = (0, 0);
       (lit[16] => matchfound) = (0, 0);
       (lit[17] => matchfound) = (0, 0);
       (lit[18] => matchfound) = (0, 0);
       (lit[19] => matchfound) = (0, 0);
       (lit[20] => matchfound) = (0, 0);
       (lit[21] => matchfound) = (0, 0);
       (lit[22] => matchfound) = (0, 0);
       (lit[23] => matchfound) = (0, 0);
       (lit[24] => matchfound) = (0, 0);
       (lit[25] => matchfound) = (0, 0);
       (lit[26] => matchfound) = (0, 0);
       (lit[27] => matchfound) = (0, 0);
       (lit[28] => matchfound) = (0, 0);
       (lit[29] => matchfound) = (0, 0);
       (lit[30] => matchfound) = (0, 0);
       (lit[31] => matchfound) = (0, 0);

       (lit[0] => matchout[0]) = (0, 0);
       (lit[1] => matchout[0]) = (0, 0);
       (lit[2] => matchout[0]) = (0, 0);
       (lit[3] => matchout[0]) = (0, 0);
       (lit[4] => matchout[0]) = (0, 0);
       (lit[5] => matchout[0]) = (0, 0);
       (lit[6] => matchout[0]) = (0, 0);
       (lit[7] => matchout[0]) = (0, 0);
       (lit[8] => matchout[0]) = (0, 0);
       (lit[9] => matchout[0]) = (0, 0);
       (lit[10] => matchout[0]) = (0, 0);
       (lit[11] => matchout[0]) = (0, 0);
       (lit[12] => matchout[0]) = (0, 0);
       (lit[13] => matchout[0]) = (0, 0);
       (lit[14] => matchout[0]) = (0, 0);
       (lit[15] => matchout[0]) = (0, 0);
       (lit[16] => matchout[0]) = (0, 0);
       (lit[17] => matchout[0]) = (0, 0);
       (lit[18] => matchout[0]) = (0, 0);
       (lit[19] => matchout[0]) = (0, 0);
       (lit[20] => matchout[0]) = (0, 0);
       (lit[21] => matchout[0]) = (0, 0);
       (lit[22] => matchout[0]) = (0, 0);
       (lit[23] => matchout[0]) = (0, 0);
       (lit[24] => matchout[0]) = (0, 0);
       (lit[25] => matchout[0]) = (0, 0);
       (lit[26] => matchout[0]) = (0, 0);
       (lit[27] => matchout[0]) = (0, 0);
       (lit[28] => matchout[0]) = (0, 0);
       (lit[29] => matchout[0]) = (0, 0);
       (lit[30] => matchout[0]) = (0, 0);
       (lit[31] => matchout[0]) = (0, 0);

       (lit[0] => matchout[1]) = (0, 0);
       (lit[1] => matchout[1]) = (0, 0);
       (lit[2] => matchout[1]) = (0, 0);
       (lit[3] => matchout[1]) = (0, 0);
       (lit[4] => matchout[1]) = (0, 0);
       (lit[5] => matchout[1]) = (0, 0);
       (lit[6] => matchout[1]) = (0, 0);
       (lit[7] => matchout[1]) = (0, 0);
       (lit[8] => matchout[1]) = (0, 0);
       (lit[9] => matchout[1]) = (0, 0);
       (lit[10] => matchout[1]) = (0, 0);
       (lit[11] => matchout[1]) = (0, 0);
       (lit[12] => matchout[1]) = (0, 0);
       (lit[13] => matchout[1]) = (0, 0);
       (lit[14] => matchout[1]) = (0, 0);
       (lit[15] => matchout[1]) = (0, 0);
       (lit[16] => matchout[1]) = (0, 0);
       (lit[17] => matchout[1]) = (0, 0);
       (lit[18] => matchout[1]) = (0, 0);
       (lit[19] => matchout[1]) = (0, 0);
       (lit[20] => matchout[1]) = (0, 0);
       (lit[21] => matchout[1]) = (0, 0);
       (lit[22] => matchout[1]) = (0, 0);
       (lit[23] => matchout[1]) = (0, 0);
       (lit[24] => matchout[1]) = (0, 0);
       (lit[25] => matchout[1]) = (0, 0);
       (lit[26] => matchout[1]) = (0, 0);
       (lit[27] => matchout[1]) = (0, 0);
       (lit[28] => matchout[1]) = (0, 0);
       (lit[29] => matchout[1]) = (0, 0);
       (lit[30] => matchout[1]) = (0, 0);
       (lit[31] => matchout[1]) = (0, 0);

       (lit[0] => matchout[2]) = (0, 0);
       (lit[1] => matchout[2]) = (0, 0);
       (lit[2] => matchout[2]) = (0, 0);
       (lit[3] => matchout[2]) = (0, 0);
       (lit[4] => matchout[2]) = (0, 0);
       (lit[5] => matchout[2]) = (0, 0);
       (lit[6] => matchout[2]) = (0, 0);
       (lit[7] => matchout[2]) = (0, 0);
       (lit[8] => matchout[2]) = (0, 0);
       (lit[9] => matchout[2]) = (0, 0);
       (lit[10] => matchout[2]) = (0, 0);
       (lit[11] => matchout[2]) = (0, 0);
       (lit[12] => matchout[2]) = (0, 0);
       (lit[13] => matchout[2]) = (0, 0);
       (lit[14] => matchout[2]) = (0, 0);
       (lit[15] => matchout[2]) = (0, 0);
       (lit[16] => matchout[2]) = (0, 0);
       (lit[17] => matchout[2]) = (0, 0);
       (lit[18] => matchout[2]) = (0, 0);
       (lit[19] => matchout[2]) = (0, 0);
       (lit[20] => matchout[2]) = (0, 0);
       (lit[21] => matchout[2]) = (0, 0);
       (lit[22] => matchout[2]) = (0, 0);
       (lit[23] => matchout[2]) = (0, 0);
       (lit[24] => matchout[2]) = (0, 0);
       (lit[25] => matchout[2]) = (0, 0);
       (lit[26] => matchout[2]) = (0, 0);
       (lit[27] => matchout[2]) = (0, 0);
       (lit[28] => matchout[2]) = (0, 0);
       (lit[29] => matchout[2]) = (0, 0);
       (lit[30] => matchout[2]) = (0, 0);
       (lit[31] => matchout[2]) = (0, 0);

       (lit[0] => matchout[3]) = (0, 0);
       (lit[1] => matchout[3]) = (0, 0);
       (lit[2] => matchout[3]) = (0, 0);
       (lit[3] => matchout[3]) = (0, 0);
       (lit[4] => matchout[3]) = (0, 0);
       (lit[5] => matchout[3]) = (0, 0);
       (lit[6] => matchout[3]) = (0, 0);
       (lit[7] => matchout[3]) = (0, 0);
       (lit[8] => matchout[3]) = (0, 0);
       (lit[9] => matchout[3]) = (0, 0);
       (lit[10] => matchout[3]) = (0, 0);
       (lit[11] => matchout[3]) = (0, 0);
       (lit[12] => matchout[3]) = (0, 0);
       (lit[13] => matchout[3]) = (0, 0);
       (lit[14] => matchout[3]) = (0, 0);
       (lit[15] => matchout[3]) = (0, 0);
       (lit[16] => matchout[3]) = (0, 0);
       (lit[17] => matchout[3]) = (0, 0);
       (lit[18] => matchout[3]) = (0, 0);
       (lit[19] => matchout[3]) = (0, 0);
       (lit[20] => matchout[3]) = (0, 0);
       (lit[21] => matchout[3]) = (0, 0);
       (lit[22] => matchout[3]) = (0, 0);
       (lit[23] => matchout[3]) = (0, 0);
       (lit[24] => matchout[3]) = (0, 0);
       (lit[25] => matchout[3]) = (0, 0);
       (lit[26] => matchout[3]) = (0, 0);
       (lit[27] => matchout[3]) = (0, 0);
       (lit[28] => matchout[3]) = (0, 0);
       (lit[29] => matchout[3]) = (0, 0);
       (lit[30] => matchout[3]) = (0, 0);
       (lit[31] => matchout[3]) = (0, 0);

       (lit[0] => matchout[4]) = (0, 0);
       (lit[1] => matchout[4]) = (0, 0);
       (lit[2] => matchout[4]) = (0, 0);
       (lit[3] => matchout[4]) = (0, 0);
       (lit[4] => matchout[4]) = (0, 0);
       (lit[5] => matchout[4]) = (0, 0);
       (lit[6] => matchout[4]) = (0, 0);
       (lit[7] => matchout[4]) = (0, 0);
       (lit[8] => matchout[4]) = (0, 0);
       (lit[9] => matchout[4]) = (0, 0);
       (lit[10] => matchout[4]) = (0, 0);
       (lit[11] => matchout[4]) = (0, 0);
       (lit[12] => matchout[4]) = (0, 0);
       (lit[13] => matchout[4]) = (0, 0);
       (lit[14] => matchout[4]) = (0, 0);
       (lit[15] => matchout[4]) = (0, 0);
       (lit[16] => matchout[4]) = (0, 0);
       (lit[17] => matchout[4]) = (0, 0);
       (lit[18] => matchout[4]) = (0, 0);
       (lit[19] => matchout[4]) = (0, 0);
       (lit[20] => matchout[4]) = (0, 0);
       (lit[21] => matchout[4]) = (0, 0);
       (lit[22] => matchout[4]) = (0, 0);
       (lit[23] => matchout[4]) = (0, 0);
       (lit[24] => matchout[4]) = (0, 0);
       (lit[25] => matchout[4]) = (0, 0);
       (lit[26] => matchout[4]) = (0, 0);
       (lit[27] => matchout[4]) = (0, 0);
       (lit[28] => matchout[4]) = (0, 0);
       (lit[29] => matchout[4]) = (0, 0);
       (lit[30] => matchout[4]) = (0, 0);
       (lit[31] => matchout[4]) = (0, 0);

       (lit[0] => matchout[5]) = (0, 0);
       (lit[1] => matchout[5]) = (0, 0);
       (lit[2] => matchout[5]) = (0, 0);
       (lit[3] => matchout[5]) = (0, 0);
       (lit[4] => matchout[5]) = (0, 0);
       (lit[5] => matchout[5]) = (0, 0);
       (lit[6] => matchout[5]) = (0, 0);
       (lit[7] => matchout[5]) = (0, 0);
       (lit[8] => matchout[5]) = (0, 0);
       (lit[9] => matchout[5]) = (0, 0);
       (lit[10] => matchout[5]) = (0, 0);
       (lit[11] => matchout[5]) = (0, 0);
       (lit[12] => matchout[5]) = (0, 0);
       (lit[13] => matchout[5]) = (0, 0);
       (lit[14] => matchout[5]) = (0, 0);
       (lit[15] => matchout[5]) = (0, 0);
       (lit[16] => matchout[5]) = (0, 0);
       (lit[17] => matchout[5]) = (0, 0);
       (lit[18] => matchout[5]) = (0, 0);
       (lit[19] => matchout[5]) = (0, 0);
       (lit[20] => matchout[5]) = (0, 0);
       (lit[21] => matchout[5]) = (0, 0);
       (lit[22] => matchout[5]) = (0, 0);
       (lit[23] => matchout[5]) = (0, 0);
       (lit[24] => matchout[5]) = (0, 0);
       (lit[25] => matchout[5]) = (0, 0);
       (lit[26] => matchout[5]) = (0, 0);
       (lit[27] => matchout[5]) = (0, 0);
       (lit[28] => matchout[5]) = (0, 0);
       (lit[29] => matchout[5]) = (0, 0);
       (lit[30] => matchout[5]) = (0, 0);
       (lit[31] => matchout[5]) = (0, 0);

       (lit[0] => matchout[6]) = (0, 0);
       (lit[1] => matchout[6]) = (0, 0);
       (lit[2] => matchout[6]) = (0, 0);
       (lit[3] => matchout[6]) = (0, 0);
       (lit[4] => matchout[6]) = (0, 0);
       (lit[5] => matchout[6]) = (0, 0);
       (lit[6] => matchout[6]) = (0, 0);
       (lit[7] => matchout[6]) = (0, 0);
       (lit[8] => matchout[6]) = (0, 0);
       (lit[9] => matchout[6]) = (0, 0);
       (lit[10] => matchout[6]) = (0, 0);
       (lit[11] => matchout[6]) = (0, 0);
       (lit[12] => matchout[6]) = (0, 0);
       (lit[13] => matchout[6]) = (0, 0);
       (lit[14] => matchout[6]) = (0, 0);
       (lit[15] => matchout[6]) = (0, 0);
       (lit[16] => matchout[6]) = (0, 0);
       (lit[17] => matchout[6]) = (0, 0);
       (lit[18] => matchout[6]) = (0, 0);
       (lit[19] => matchout[6]) = (0, 0);
       (lit[20] => matchout[6]) = (0, 0);
       (lit[21] => matchout[6]) = (0, 0);
       (lit[22] => matchout[6]) = (0, 0);
       (lit[23] => matchout[6]) = (0, 0);
       (lit[24] => matchout[6]) = (0, 0);
       (lit[25] => matchout[6]) = (0, 0);
       (lit[26] => matchout[6]) = (0, 0);
       (lit[27] => matchout[6]) = (0, 0);
       (lit[28] => matchout[6]) = (0, 0);
       (lit[29] => matchout[6]) = (0, 0);
       (lit[30] => matchout[6]) = (0, 0);
       (lit[31] => matchout[6]) = (0, 0);

       (lit[0] => matchout[7]) = (0, 0);
       (lit[1] => matchout[7]) = (0, 0);
       (lit[2] => matchout[7]) = (0, 0);
       (lit[3] => matchout[7]) = (0, 0);
       (lit[4] => matchout[7]) = (0, 0);
       (lit[5] => matchout[7]) = (0, 0);
       (lit[6] => matchout[7]) = (0, 0);
       (lit[7] => matchout[7]) = (0, 0);
       (lit[8] => matchout[7]) = (0, 0);
       (lit[9] => matchout[7]) = (0, 0);
       (lit[10] => matchout[7]) = (0, 0);
       (lit[11] => matchout[7]) = (0, 0);
       (lit[12] => matchout[7]) = (0, 0);
       (lit[13] => matchout[7]) = (0, 0);
       (lit[14] => matchout[7]) = (0, 0);
       (lit[15] => matchout[7]) = (0, 0);
       (lit[16] => matchout[7]) = (0, 0);
       (lit[17] => matchout[7]) = (0, 0);
       (lit[18] => matchout[7]) = (0, 0);
       (lit[19] => matchout[7]) = (0, 0);
       (lit[20] => matchout[7]) = (0, 0);
       (lit[21] => matchout[7]) = (0, 0);
       (lit[22] => matchout[7]) = (0, 0);
       (lit[23] => matchout[7]) = (0, 0);
       (lit[24] => matchout[7]) = (0, 0);
       (lit[25] => matchout[7]) = (0, 0);
       (lit[26] => matchout[7]) = (0, 0);
       (lit[27] => matchout[7]) = (0, 0);
       (lit[28] => matchout[7]) = (0, 0);
       (lit[29] => matchout[7]) = (0, 0);
       (lit[30] => matchout[7]) = (0, 0);
       (lit[31] => matchout[7]) = (0, 0);

       (lit[0] => matchout[8]) = (0, 0);
       (lit[1] => matchout[8]) = (0, 0);
       (lit[2] => matchout[8]) = (0, 0);
       (lit[3] => matchout[8]) = (0, 0);
       (lit[4] => matchout[8]) = (0, 0);
       (lit[5] => matchout[8]) = (0, 0);
       (lit[6] => matchout[8]) = (0, 0);
       (lit[7] => matchout[8]) = (0, 0);
       (lit[8] => matchout[8]) = (0, 0);
       (lit[9] => matchout[8]) = (0, 0);
       (lit[10] => matchout[8]) = (0, 0);
       (lit[11] => matchout[8]) = (0, 0);
       (lit[12] => matchout[8]) = (0, 0);
       (lit[13] => matchout[8]) = (0, 0);
       (lit[14] => matchout[8]) = (0, 0);
       (lit[15] => matchout[8]) = (0, 0);
       (lit[16] => matchout[8]) = (0, 0);
       (lit[17] => matchout[8]) = (0, 0);
       (lit[18] => matchout[8]) = (0, 0);
       (lit[19] => matchout[8]) = (0, 0);
       (lit[20] => matchout[8]) = (0, 0);
       (lit[21] => matchout[8]) = (0, 0);
       (lit[22] => matchout[8]) = (0, 0);
       (lit[23] => matchout[8]) = (0, 0);
       (lit[24] => matchout[8]) = (0, 0);
       (lit[25] => matchout[8]) = (0, 0);
       (lit[26] => matchout[8]) = (0, 0);
       (lit[27] => matchout[8]) = (0, 0);
       (lit[28] => matchout[8]) = (0, 0);
       (lit[29] => matchout[8]) = (0, 0);
       (lit[30] => matchout[8]) = (0, 0);
       (lit[31] => matchout[8]) = (0, 0);

       (lit[0] => matchout[9]) = (0, 0);
       (lit[1] => matchout[9]) = (0, 0);
       (lit[2] => matchout[9]) = (0, 0);
       (lit[3] => matchout[9]) = (0, 0);
       (lit[4] => matchout[9]) = (0, 0);
       (lit[5] => matchout[9]) = (0, 0);
       (lit[6] => matchout[9]) = (0, 0);
       (lit[7] => matchout[9]) = (0, 0);
       (lit[8] => matchout[9]) = (0, 0);
       (lit[9] => matchout[9]) = (0, 0);
       (lit[10] => matchout[9]) = (0, 0);
       (lit[11] => matchout[9]) = (0, 0);
       (lit[12] => matchout[9]) = (0, 0);
       (lit[13] => matchout[9]) = (0, 0);
       (lit[14] => matchout[9]) = (0, 0);
       (lit[15] => matchout[9]) = (0, 0);
       (lit[16] => matchout[9]) = (0, 0);
       (lit[17] => matchout[9]) = (0, 0);
       (lit[18] => matchout[9]) = (0, 0);
       (lit[19] => matchout[9]) = (0, 0);
       (lit[20] => matchout[9]) = (0, 0);
       (lit[21] => matchout[9]) = (0, 0);
       (lit[22] => matchout[9]) = (0, 0);
       (lit[23] => matchout[9]) = (0, 0);
       (lit[24] => matchout[9]) = (0, 0);
       (lit[25] => matchout[9]) = (0, 0);
       (lit[26] => matchout[9]) = (0, 0);
       (lit[27] => matchout[9]) = (0, 0);
       (lit[28] => matchout[9]) = (0, 0);
       (lit[29] => matchout[9]) = (0, 0);
       (lit[30] => matchout[9]) = (0, 0);
       (lit[31] => matchout[9]) = (0, 0);

       (lit[0] => matchout[10]) = (0, 0);
       (lit[1] => matchout[10]) = (0, 0);
       (lit[2] => matchout[10]) = (0, 0);
       (lit[3] => matchout[10]) = (0, 0);
       (lit[4] => matchout[10]) = (0, 0);
       (lit[5] => matchout[10]) = (0, 0);
       (lit[6] => matchout[10]) = (0, 0);
       (lit[7] => matchout[10]) = (0, 0);
       (lit[8] => matchout[10]) = (0, 0);
       (lit[9] => matchout[10]) = (0, 0);
       (lit[10] => matchout[10]) = (0, 0);
       (lit[11] => matchout[10]) = (0, 0);
       (lit[12] => matchout[10]) = (0, 0);
       (lit[13] => matchout[10]) = (0, 0);
       (lit[14] => matchout[10]) = (0, 0);
       (lit[15] => matchout[10]) = (0, 0);
       (lit[16] => matchout[10]) = (0, 0);
       (lit[17] => matchout[10]) = (0, 0);
       (lit[18] => matchout[10]) = (0, 0);
       (lit[19] => matchout[10]) = (0, 0);
       (lit[20] => matchout[10]) = (0, 0);
       (lit[21] => matchout[10]) = (0, 0);
       (lit[22] => matchout[10]) = (0, 0);
       (lit[23] => matchout[10]) = (0, 0);
       (lit[24] => matchout[10]) = (0, 0);
       (lit[25] => matchout[10]) = (0, 0);
       (lit[26] => matchout[10]) = (0, 0);
       (lit[27] => matchout[10]) = (0, 0);
       (lit[28] => matchout[10]) = (0, 0);
       (lit[29] => matchout[10]) = (0, 0);
       (lit[30] => matchout[10]) = (0, 0);
       (lit[31] => matchout[10]) = (0, 0);

       (lit[0] => matchout[11]) = (0, 0);
       (lit[1] => matchout[11]) = (0, 0);
       (lit[2] => matchout[11]) = (0, 0);
       (lit[3] => matchout[11]) = (0, 0);
       (lit[4] => matchout[11]) = (0, 0);
       (lit[5] => matchout[11]) = (0, 0);
       (lit[6] => matchout[11]) = (0, 0);
       (lit[7] => matchout[11]) = (0, 0);
       (lit[8] => matchout[11]) = (0, 0);
       (lit[9] => matchout[11]) = (0, 0);
       (lit[10] => matchout[11]) = (0, 0);
       (lit[11] => matchout[11]) = (0, 0);
       (lit[12] => matchout[11]) = (0, 0);
       (lit[13] => matchout[11]) = (0, 0);
       (lit[14] => matchout[11]) = (0, 0);
       (lit[15] => matchout[11]) = (0, 0);
       (lit[16] => matchout[11]) = (0, 0);
       (lit[17] => matchout[11]) = (0, 0);
       (lit[18] => matchout[11]) = (0, 0);
       (lit[19] => matchout[11]) = (0, 0);
       (lit[20] => matchout[11]) = (0, 0);
       (lit[21] => matchout[11]) = (0, 0);
       (lit[22] => matchout[11]) = (0, 0);
       (lit[23] => matchout[11]) = (0, 0);
       (lit[24] => matchout[11]) = (0, 0);
       (lit[25] => matchout[11]) = (0, 0);
       (lit[26] => matchout[11]) = (0, 0);
       (lit[27] => matchout[11]) = (0, 0);
       (lit[28] => matchout[11]) = (0, 0);
       (lit[29] => matchout[11]) = (0, 0);
       (lit[30] => matchout[11]) = (0, 0);
       (lit[31] => matchout[11]) = (0, 0);

       (lit[0] => matchout[12]) = (0, 0);
       (lit[1] => matchout[12]) = (0, 0);
       (lit[2] => matchout[12]) = (0, 0);
       (lit[3] => matchout[12]) = (0, 0);
       (lit[4] => matchout[12]) = (0, 0);
       (lit[5] => matchout[12]) = (0, 0);
       (lit[6] => matchout[12]) = (0, 0);
       (lit[7] => matchout[12]) = (0, 0);
       (lit[8] => matchout[12]) = (0, 0);
       (lit[9] => matchout[12]) = (0, 0);
       (lit[10] => matchout[12]) = (0, 0);
       (lit[11] => matchout[12]) = (0, 0);
       (lit[12] => matchout[12]) = (0, 0);
       (lit[13] => matchout[12]) = (0, 0);
       (lit[14] => matchout[12]) = (0, 0);
       (lit[15] => matchout[12]) = (0, 0);
       (lit[16] => matchout[12]) = (0, 0);
       (lit[17] => matchout[12]) = (0, 0);
       (lit[18] => matchout[12]) = (0, 0);
       (lit[19] => matchout[12]) = (0, 0);
       (lit[20] => matchout[12]) = (0, 0);
       (lit[21] => matchout[12]) = (0, 0);
       (lit[22] => matchout[12]) = (0, 0);
       (lit[23] => matchout[12]) = (0, 0);
       (lit[24] => matchout[12]) = (0, 0);
       (lit[25] => matchout[12]) = (0, 0);
       (lit[26] => matchout[12]) = (0, 0);
       (lit[27] => matchout[12]) = (0, 0);
       (lit[28] => matchout[12]) = (0, 0);
       (lit[29] => matchout[12]) = (0, 0);
       (lit[30] => matchout[12]) = (0, 0);
       (lit[31] => matchout[12]) = (0, 0);

       (lit[0] => matchout[13]) = (0, 0);
       (lit[1] => matchout[13]) = (0, 0);
       (lit[2] => matchout[13]) = (0, 0);
       (lit[3] => matchout[13]) = (0, 0);
       (lit[4] => matchout[13]) = (0, 0);
       (lit[5] => matchout[13]) = (0, 0);
       (lit[6] => matchout[13]) = (0, 0);
       (lit[7] => matchout[13]) = (0, 0);
       (lit[8] => matchout[13]) = (0, 0);
       (lit[9] => matchout[13]) = (0, 0);
       (lit[10] => matchout[13]) = (0, 0);
       (lit[11] => matchout[13]) = (0, 0);
       (lit[12] => matchout[13]) = (0, 0);
       (lit[13] => matchout[13]) = (0, 0);
       (lit[14] => matchout[13]) = (0, 0);
       (lit[15] => matchout[13]) = (0, 0);
       (lit[16] => matchout[13]) = (0, 0);
       (lit[17] => matchout[13]) = (0, 0);
       (lit[18] => matchout[13]) = (0, 0);
       (lit[19] => matchout[13]) = (0, 0);
       (lit[20] => matchout[13]) = (0, 0);
       (lit[21] => matchout[13]) = (0, 0);
       (lit[22] => matchout[13]) = (0, 0);
       (lit[23] => matchout[13]) = (0, 0);
       (lit[24] => matchout[13]) = (0, 0);
       (lit[25] => matchout[13]) = (0, 0);
       (lit[26] => matchout[13]) = (0, 0);
       (lit[27] => matchout[13]) = (0, 0);
       (lit[28] => matchout[13]) = (0, 0);
       (lit[29] => matchout[13]) = (0, 0);
       (lit[30] => matchout[13]) = (0, 0);
       (lit[31] => matchout[13]) = (0, 0);

       (lit[0] => matchout[14]) = (0, 0);
       (lit[1] => matchout[14]) = (0, 0);
       (lit[2] => matchout[14]) = (0, 0);
       (lit[3] => matchout[14]) = (0, 0);
       (lit[4] => matchout[14]) = (0, 0);
       (lit[5] => matchout[14]) = (0, 0);
       (lit[6] => matchout[14]) = (0, 0);
       (lit[7] => matchout[14]) = (0, 0);
       (lit[8] => matchout[14]) = (0, 0);
       (lit[9] => matchout[14]) = (0, 0);
       (lit[10] => matchout[14]) = (0, 0);
       (lit[11] => matchout[14]) = (0, 0);
       (lit[12] => matchout[14]) = (0, 0);
       (lit[13] => matchout[14]) = (0, 0);
       (lit[14] => matchout[14]) = (0, 0);
       (lit[15] => matchout[14]) = (0, 0);
       (lit[16] => matchout[14]) = (0, 0);
       (lit[17] => matchout[14]) = (0, 0);
       (lit[18] => matchout[14]) = (0, 0);
       (lit[19] => matchout[14]) = (0, 0);
       (lit[20] => matchout[14]) = (0, 0);
       (lit[21] => matchout[14]) = (0, 0);
       (lit[22] => matchout[14]) = (0, 0);
       (lit[23] => matchout[14]) = (0, 0);
       (lit[24] => matchout[14]) = (0, 0);
       (lit[25] => matchout[14]) = (0, 0);
       (lit[26] => matchout[14]) = (0, 0);
       (lit[27] => matchout[14]) = (0, 0);
       (lit[28] => matchout[14]) = (0, 0);
       (lit[29] => matchout[14]) = (0, 0);
       (lit[30] => matchout[14]) = (0, 0);
       (lit[31] => matchout[14]) = (0, 0);

       (lit[0] => matchout[15]) = (0, 0);
       (lit[1] => matchout[15]) = (0, 0);
       (lit[2] => matchout[15]) = (0, 0);
       (lit[3] => matchout[15]) = (0, 0);
       (lit[4] => matchout[15]) = (0, 0);
       (lit[5] => matchout[15]) = (0, 0);
       (lit[6] => matchout[15]) = (0, 0);
       (lit[7] => matchout[15]) = (0, 0);
       (lit[8] => matchout[15]) = (0, 0);
       (lit[9] => matchout[15]) = (0, 0);
       (lit[10] => matchout[15]) = (0, 0);
       (lit[11] => matchout[15]) = (0, 0);
       (lit[12] => matchout[15]) = (0, 0);
       (lit[13] => matchout[15]) = (0, 0);
       (lit[14] => matchout[15]) = (0, 0);
       (lit[15] => matchout[15]) = (0, 0);
       (lit[16] => matchout[15]) = (0, 0);
       (lit[17] => matchout[15]) = (0, 0);
       (lit[18] => matchout[15]) = (0, 0);
       (lit[19] => matchout[15]) = (0, 0);
       (lit[20] => matchout[15]) = (0, 0);
       (lit[21] => matchout[15]) = (0, 0);
       (lit[22] => matchout[15]) = (0, 0);
       (lit[23] => matchout[15]) = (0, 0);
       (lit[24] => matchout[15]) = (0, 0);
       (lit[25] => matchout[15]) = (0, 0);
       (lit[26] => matchout[15]) = (0, 0);
       (lit[27] => matchout[15]) = (0, 0);
       (lit[28] => matchout[15]) = (0, 0);
       (lit[29] => matchout[15]) = (0, 0);
       (lit[30] => matchout[15]) = (0, 0);
       (lit[31] => matchout[15]) = (0, 0);

       (outputselect => matchout[0]) = (0, 0);
       (outputselect => matchout[1]) = (0, 0);
       (outputselect => matchout[2]) = (0, 0);
       (outputselect => matchout[3]) = (0, 0);
       (outputselect => matchout[4]) = (0, 0);
       (outputselect => matchout[5]) = (0, 0);
       (outputselect => matchout[6]) = (0, 0);
       (outputselect => matchout[7]) = (0, 0);
       (outputselect => matchout[8]) = (0, 0);
       (outputselect => matchout[9]) = (0, 0);
       (outputselect => matchout[10]) = (0, 0);
       (outputselect => matchout[11]) = (0, 0);
       (outputselect => matchout[12]) = (0, 0);
       (outputselect => matchout[13]) = (0, 0);
       (outputselect => matchout[14]) = (0, 0);
       (outputselect => matchout[15]) = (0, 0);
    endspecify

    initial
    begin
	for (i = 0; i <= 31; i = i + 1)
	begin
            NEVER_MATCH[i] = 1'b1;
	    UNKNOWN[i] = 1'bx;
	end
	mem_depth = (last_address - first_address) + 1;
        if ((operation_mode == "unencoded_16_address") || (operation_mode == "fast_multiple_match"))
	   mem_depth = 2*mem_depth;
	m_found = 1'b0;
	matchfound_tmp = 0;

	// initialize memory from parameters
	// parameters contain user initialization data or NEVER_MATCH pattern

	init_mem_true = {init_mem_true2, init_mem_true1};
	init_mem_comp = {init_mem_comp2, init_mem_comp1};
	k = 0;
	if ((operation_mode == "encoded_address") || (operation_mode == "unencoded_32_address")
           || (operation_mode == "single_match") || (operation_mode == "multiple_match"))
	begin
	for (i=0; i <= 31; i = i + 1)
	begin
	   for (j=0; j <= 31; j = j + 1)
	   begin
	      temp_true[j] = init_mem_true[k];
	      temp_comp[j] = init_mem_comp[k];
	      k = k + 1;
	   end
	   mem_true[i] = temp_true;
	   mem_comp[i] = temp_comp;
	   mult_match_array[i] = 0;
	end
	end
        else if ((operation_mode == "unencoded_16_address") || (operation_mode == "fast_multiple_match"))
	begin
	   for (i=0; i <= 15; i = i + 1)
	   begin
	      for (j=0; j <= 31; j = j + 1)
	      begin
		 temp_true[j] = init_mem_true[k];
		 temp_comp[j] = init_mem_comp[k];
		 k = k + 1;
	      end
	      mem_true[2*i] = temp_true;
	      mem_comp[2*i] = temp_comp;
	      mult_match_array[2*i] = 0;
	      mem_true[2*i+1] = NEVER_MATCH;
	      mem_comp[2*i+1] = NEVER_MATCH;
	      mult_match_array[2*i+1] = 0;
	   end
	end
    end

    always @(we_in or lit_in)
    begin
    if ((we_in == 1) && (we_pulse_last_value == 0))
      // rising edge on we_pulse
    begin
       if ((datain_in == 0) && (wrinvert_in == 0))
       begin
	// write 0's
	  pattern_tmp = lit_in[pattern_width-1:0];
          wword = waddr_in[address_width-1:0];
	  if (modesel == 2'b10)   // unencoded_16_address mode
	     wword = wword*2;
	  temp_true = mem_true[wword];
	  temp_comp = mem_comp[wword];
	  for (i = 0; i <= pattern_width; i = i + 1)
	      if (pattern_tmp[i] == 1)
		 temp_true[i] = 0;
	      else if (pattern_tmp[i] == 0)
		 temp_comp[i] = 0;
	  if (modesel == 2'b01)     // unencoded_32_address mode
	  begin
	     if ((wword%2) == 0) // address is even
		temp_comp[31] = 0;
	     else     // address is odd
		temp_true[31] = 0;
	  end
	  mem_true[wword] = temp_true;
	  mem_comp[wword] = temp_comp;
       end
       else if ((datain_in == 1) && (wrinvert_in == 1))
       begin
	  if ((wdatain_last_value == 1) && (wrinvert_last_value == 0))
          // delete cycle continues
	  begin
	     if (modesel == 2'b10)   // unencoded_16_address mode
	         wword = wword/2;    // for comparison, reverse the multiply
             if ((pattern_tmp == lit_in[pattern_width-1:0]) && (wword == waddr_in[address_width-1:0]))
	     begin
	        if (modesel == 2'b10)   // fast_multiple_match mode
	            wword = wword*2;    // for comparison, reverse the multiply
	        temp_true = mem_true[wword];
	        temp_comp = mem_comp[wword];
	        for (i = 0; i <= pattern_width-1; i = i + 1)
	            if (pattern_tmp[i] == 0)
	               temp_true[i] = 1;
		    else if (pattern_tmp[i] == 1)
		       temp_comp[i] = 1;
	        mem_true[wword] = temp_true;
	        mem_comp[wword] = temp_comp;
	     end
	     else
             begin
	        if (modesel == 2'b10)   // fast_multiple_match mode
	            wword = wword*2;    // for comparison, reverse the multiply
                $display("Either pattern or address changed during delete pattern. Pattern will not be deleted.");
             end
	  end
          else
          begin
             if ((wdatain_last_value == 0) && (wrinvert_last_value == 0))
             begin
             // write cycle continues
	        if (modesel == 2'b10)   // unencoded_16_address mode
	            wword = wword/2;
	        if (wword == waddr_in[address_width-1:0])
	         // last cycle was write 0's and address is same
	           if (pattern_tmp != lit_in[pattern_width-1:0])
		     // but pattern is not same, so error message
		       $display("Write Pattern changed during write cycles. Write data may not be valid.");
             end
	     // write 1's
	     pattern_tmp = lit_in[pattern_width-1:0];
             wword = waddr_in[address_width-1:0];
	     if (modesel == 2'b10)   // unencoded_16_address mode
	        wword = wword*2;
	     temp_true = mem_true[wword];
	     temp_comp = mem_comp[wword];
	     for (i = 0; i <= pattern_width-1; i = i + 1)
	         if (pattern_tmp[i] == 0)
	            temp_true[i] = 1;
	         else if (pattern_tmp[i] == 1)
	            temp_comp[i] = 1;
//	     if (modesel == 2'b01)     // unencoded_32_address mode
//	     begin
//	        if ((wword%2) == 0) // address is even
//		   temp_comp[31] = 0;
//	        else     // address is odd
//	           temp_true[31] = 0;
//	     end
	     mem_true[wword] = temp_true;
	     mem_comp[wword] = temp_comp;
          end
       end
       else if ((datain_in == 1) && (wrinvert_in == 0))
       begin
	  pattern_tmp = lit_in[pattern_width-1:0];
          wword = waddr_in[address_width-1:0];
	  if (modesel == 2'b10)   // unencoded_16_address mode
	      wword = wword*2;
	  temp_true = mem_true[wword];
	  temp_comp = mem_comp[wword];
	  for (i = 0; i <= pattern_width-1; i = i + 1)
	      if (pattern_tmp[i] == 1)
	         temp_true[i] = 1;
	      else if (pattern_tmp[i] == 0)
	         temp_comp[i] = 1;
	  mem_true[wword] = temp_true;
	  mem_comp[wword] = temp_comp;
       end
       wdatain_last_value = datain_in;
       wrinvert_last_value = wrinvert_in;
    end
//    else if (we_pulse == 0) // read CAM
//    begin
       m_found = 1'b0;
       read_pattern = lit_in[pattern_width-1:0];
       i = 0;
       while ((i < mem_depth) && !m_found)
       begin
	  continue = 1'b1;
	  j = 0;
	  temp_true = mem_true[i];
	  temp_comp = mem_comp[i];
	  for (k = 0; k <= pattern_width-1; k = k + 1)
	      if ((temp_comp[k] == 1) && (temp_true[k] == 1))
		  continue = 0;
	      else if ((temp_comp[k] == 0) && (temp_true[k] == 0))
		 temp[k] = 'bx;
	      else temp[k] = temp_comp[k];
	  compare_data = read_pattern ^ temp;
	  while ((j < pattern_width) && continue)
	  begin
	     if (compare_data[j])
	        continue = 1'b0;
	     j = j + 1;
	  end
	  if ((continue) && (j == pattern_width))
	  begin
	     if ((modesel == 2'b00) && !m_found)
	     begin
		m_found = 1'b1;
		encoded_match_addr = i;
	     end
	     else if (modesel != 2'b00)
	     begin
		mult_match_array[i] = 'b1;
		i = i + 1;
	     end
	  end
	  else begin
	     mult_match_array[i] = 'b0;
	     i = i + 1;
	  end
       end
       if (modesel == 2'b00)  // encoded_address mode
       begin
	  if (m_found)
             match_out[4:0] = encoded_match_addr;
	  else match_out[4:0] = 5'b0;
          match_out[15:5] = 'bz;
       end
       else if (modesel == 2'b01)  // unencoded_32_address_mode
       begin
          if (outputselect_in == 'b0)
	     for (i = 0; i < 16; i = i + 1)
		 match_out[i] = mult_match_array[2*i];
	  else if (outputselect_in == 'b1)
	     for (i = 0; i < 16; i = i + 1)
		 match_out[i] = mult_match_array[2*i+1];
       end
       else if (modesel == 2'b10)  // unencoded_16_address_mode
       begin
	// output only even addresses
	  for (i = 0; i < 16; i = i + 1)
	      match_out[i] = mult_match_array[2*i];
       end
//    end
    we_pulse_last_value = we_in;
    end

    always @(outputselect_in)
    begin
       if (outputselect_in == 'b0)
          for (i = 0; i < 16; i = i + 1)
	     match_out[i] = mult_match_array[2*i];
       else if (outputselect_in == 'b1)
          for (i = 0; i < 16; i = i + 1)
	     match_out[i] = mult_match_array[2*i+1];
    end

    always @(m_found)
    begin
       if (modesel == 2'b00)
          matchfound_tmp = m_found;
       else
          matchfound_tmp = 'b0;
    end

    assign matchout_tmp = match_out;

    // ACCELERATE OUTPUTS
    buf B0 (matchout[0], matchout_tmp[0]);
    buf B1 (matchout[1], matchout_tmp[1]);
    buf B2 (matchout[2], matchout_tmp[2]);
    buf B3 (matchout[3], matchout_tmp[3]);
    buf B4 (matchout[4], matchout_tmp[4]);
    buf B5 (matchout[5], matchout_tmp[5]);
    buf B6 (matchout[6], matchout_tmp[6]);
    buf B7 (matchout[7], matchout_tmp[7]);
    buf B8 (matchout[8], matchout_tmp[8]);
    buf B9 (matchout[9], matchout_tmp[9]);
    buf B10 (matchout[10], matchout_tmp[10]);
    buf B11 (matchout[11], matchout_tmp[11]);
    buf B12 (matchout[12], matchout_tmp[12]);
    buf B13 (matchout[13], matchout_tmp[13]);
    buf B14 (matchout[14], matchout_tmp[14]);
    buf B15 (matchout[15], matchout_tmp[15]);
    buf (matchfound, matchfound_tmp);

endmodule // apex20ke_cam


//////////////////////////////////////////////////////////////////////////////
//
// Module Name : APEX20KE_CAM_SLICE
//
// Description : Structural model for a single CAM segment of the
//               APEX20KE family.
//
// Assumptions : Default values for unconnected ports will be passed from
//               the Quartus .vo netlist
//
/////////////////////////////////////////////////////////////////////////////

module apex20ke_cam_slice (lit,
                           clk0,
                           clk1,
                           clr0,
                           clr1,
                           ena0,
                           ena1,
	                   outputselect,
                           we,
                           wrinvert,
                           datain,
                           waddr,
                           matchout,
                           matchfound, 
                           modesel,
                           devclrn,
                           devpor);

    // INPUT PORTS
    input  clk0;
    input  clk1;
    input  clr0;
    input  clr1;
    input  ena0;
    input  ena1;
    input  we;
    input  datain;
    input  wrinvert;
    input  devclrn;
    input  devpor;
    input  outputselect;
    input  [4:0] waddr;
    input  [31:0] lit;
    input  [9:0] modesel;

    // OUTPUT PORTS
    output [15:0] matchout;
    output matchfound;

    // GLOBAL PARAMETERS
    parameter operation_mode        = "encoded_address";
    parameter logical_cam_name      = "cam_xxx";
    parameter logical_cam_depth     = "32";
    parameter logical_cam_width     = "32";
    parameter address_width         = 5;
    parameter waddr_clear           = "none";
    parameter write_enable_clear    = "none";
    parameter write_logic_clock     = "none";
    parameter write_logic_clear     = "none";
    parameter output_clock          = "none";
    parameter output_clear          = "none";
    parameter init_file             = "none";
    parameter init_filex            = "none";
    parameter first_address         = 0;
    parameter last_address          = 31;
    parameter first_pattern_bit     = "1";
    parameter pattern_width         = 32;
    parameter power_up              = "low";
    parameter init_mem_true1        = 512'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
    parameter init_mem_true2        = 512'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
    parameter init_mem_comp1        = 512'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
    parameter init_mem_comp2        = 512'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;

    // PULLUPs
    tri1 iena0;
    tri1 iena1;

    // INTERNAL VARIABLES AND NETS
    wire wdatain_reg;
    wire we_reg;
    wire [4:0] waddr_reg;
    wire [15:0] matchout_reg;
    wire [15:0] matchout_int;
    wire matchfound_reg;
    wire matchfound_int;
    wire matchfound_tmp;

    wire we_clr_sel;
    wire waddr_clr_sel;
    wire write_logic_clr_sel;
    wire write_logic_sel;
    wire output_reg_sel;
    wire output_clk_sel;
    wire output_clr_sel;
    wire output_reg_clr_sel;
    wire we_pulse;

    wire clk0_delayed;

    assign iena0 = ena0;
    assign iena1 = ena1;

    assign waddr_clr_sel         = modesel[0];
    assign write_logic_sel       = modesel[1];
    assign write_logic_clr_sel   = modesel[2];
    assign we_clr_sel            = modesel[3];
    assign output_reg_sel        = modesel[4];
    assign output_clk_sel        = modesel[5];
    assign output_clr_sel        = modesel[6];
    assign output_reg_clr_sel    = modesel[7];

    mux21   outputclksel     (output_clk,
                              clk0,
                              clk1,
                              output_clk_sel
                             );
    mux21   outputclkensel   (output_clk_en,
                              iena0,
                              iena1,
                              output_clk_sel
                             );
    mux21   outputregclrsel  (output_reg_clr,
                              clr0,
                              clr1,
                              output_reg_clr_sel
                             );
    nmux21  outputclrsel     (output_clr,
                              1'b0,
                              output_reg_clr,
                              output_clr_sel
                             );

    bmux21  matchoutsel      (matchout,
                              matchout_int,
                              matchout_reg,
                              output_reg_sel
                             );
    mux21   matchfoundsel    (matchfound_tmp,
                              matchfound_int,
                              matchfound_reg,
                              output_reg_sel
                             );

    mux21   wdatainsel       (wdatain_int,
                              datain,
                              wdatain_reg,
                              write_logic_sel
                             );
    mux21   wrinvsel         (wrinv_int,
                              wrinvert,
                              wrinv_reg,
                              write_logic_sel
                             );

    nmux21  weclrsel         (we_clr,
                              clr0,
                              1'b0,
                              we_clr_sel
                             );
    nmux21  waddrclrsel      (waddr_clr,
                              clr0,
                              1'b0,
                              waddr_clr_sel
                             );
    nmux21  writelogicclrsel (write_logic_clr,
                              clr0,
                              1'b0,
                              write_logic_clr_sel
                             );

    dffe    wereg            (we_reg,
                              clk0,
                              iena0,
                              we,
                              we_clr && devclrn && devpor,
                              1'b1
                             );

    // clk0 for we_pulse should have same delay as clk of wereg
    and1    clk0weregdelaybuf (clk0_delayed,
                               clk0
                              );
    and1    wedelay_buf       (we_reg_delayed,
                               we_reg
                              );

    assign  we_pulse = we_reg_delayed && (~clk0_delayed);

    dffe    wdatainreg     (wdatain_reg,
                            clk0,
                            iena0,
                            datain,
                            write_logic_clr && devclrn && devpor,
                            1'b1
                           );
    dffe    wrinvreg       (wrinv_reg,
                            clk0,
                            iena0,
                            wrinvert,
                            write_logic_clr && devclrn && devpor,
                            1'b1
                           );
    dffe    waddrreg_0     (waddr_reg[0],
                            clk0,
                            iena0,
                            waddr[0],
                            waddr_clr && devclrn && devpor,
                            1'b1
                           );
    dffe    waddrreg_1     (waddr_reg[1],
                            clk0,
                            iena0,
                            waddr[1],
                            waddr_clr && devclrn && devpor,
                            1'b1
                           );
    dffe    waddrreg_2     (waddr_reg[2],
                            clk0,
                            iena0,
                            waddr[2],
                            waddr_clr && devclrn && devpor,
                            1'b1
                           );
    dffe    waddrreg_3     (waddr_reg[3],
                            clk0,
                            iena0,
                            waddr[3],
                            waddr_clr && devclrn && devpor,
                            1'b1
                           );
    dffe    waddrreg_4     (waddr_reg[4],
                            clk0,
                            iena0,
                            waddr[4],
                            waddr_clr && devclrn && devpor,
                            1'b1
                           );
    
    dffe    matchoutreg_0  (matchout_reg[0],
                            output_clk,
                            output_clk_en,
                            matchout_int[0],
                            output_clr && devclrn && devpor,
                            1'b1
                           );
    dffe    matchoutreg_1  (matchout_reg[1],
                            output_clk,
                            output_clk_en,
                            matchout_int[1],
                            output_clr && devclrn && devpor,
                            1'b1
                           );
    dffe    matchoutreg_2  (matchout_reg[2],
                            output_clk,
                            output_clk_en,
                            matchout_int[2],
                            output_clr && devclrn && devpor,
                            1'b1
                           );
    dffe    matchoutreg_3  (matchout_reg[3],
                            output_clk,
                            output_clk_en,
                            matchout_int[3],
                            output_clr && devclrn && devpor,
                            1'b1
                           );
    dffe    matchoutreg_4  (matchout_reg[4],
                            output_clk,
                            output_clk_en,
                            matchout_int[4],
                            output_clr && devclrn && devpor,
                            1'b1
                           );
    dffe    matchoutreg_5  (matchout_reg[5],
                            output_clk,
                            output_clk_en,
                            matchout_int[5],
                            output_clr && devclrn && devpor,
                            1'b1
                           );
    dffe    matchoutreg_6  (matchout_reg[6],
                            output_clk,
                            output_clk_en,
                            matchout_int[6],
                            output_clr && devclrn && devpor,
                            1'b1
                           );
    dffe    matchoutreg_7  (matchout_reg[7],
                            output_clk,
                            output_clk_en,
                            matchout_int[7],
                            output_clr && devclrn && devpor,
                            1'b1
                           );
    dffe    matchoutreg_8  (matchout_reg[8],
                            output_clk,
                            output_clk_en,
                            matchout_int[8],
                            output_clr && devclrn && devpor,
                            1'b1
                           );
    dffe    matchoutreg_9  (matchout_reg[9],
                            output_clk,
                            output_clk_en,
                            matchout_int[9],
                            output_clr && devclrn && devpor,
                            1'b1
                           );
    dffe    matchoutreg_10 (matchout_reg[10],
                            output_clk,
                            output_clk_en,
                            matchout_int[10],
                            output_clr && devclrn && devpor,
                            1'b1
                           );
    dffe    matchoutreg_11 (matchout_reg[11],
                            output_clk,
                            output_clk_en,
                            matchout_int[11],
                            output_clr && devclrn && devpor,
                            1'b1
                           );
    dffe    matchoutreg_12 (matchout_reg[12],
                            output_clk,
                            output_clk_en,
                            matchout_int[12],
                            output_clr && devclrn && devpor,
                            1'b1
                           );
    dffe    matchoutreg_13 (matchout_reg[13],
                            output_clk,
                            output_clk_en,
                            matchout_int[13],
                            output_clr && devclrn && devpor,
                            1'b1
                           );
    dffe    matchoutreg_14 (matchout_reg[14],
                            output_clk,
                            output_clk_en,
                            matchout_int[14],
                            output_clr && devclrn && devpor,
                            1'b1
                           );
    dffe    matchoutreg_15 (matchout_reg[15],
                            output_clk,
                            output_clk_en,
                            matchout_int[15],
                            output_clr && devclrn && devpor,
                            1'b1
                           );
    dffe    matchfoundreg  (matchfound_reg,
                            output_clk,
                            output_clk_en,
                            matchfound_int,
                            output_clr && devclrn && devpor,
                            1'b1
                           );


    apex20ke_cam cam1 (.waddr(waddr_reg),
                       .we(we_pulse),
                       .outputselect(outputselect),
                       .matchout(matchout_int),
                       .matchfound(matchfound_int),
                       .wrinvert(wrinv_int),
                       .datain(wdatain_int),
                       .lit(lit),
                       .modesel(modesel[9:8])
                      );
    defparam
        cam1.operation_mode    = operation_mode,
        cam1.address_width     = address_width,
        cam1.pattern_width     = pattern_width,
        cam1.first_address     = first_address,
        cam1.last_address      = last_address,
        cam1.init_file         = init_file,
        cam1.init_filex        = init_filex,
        cam1.init_mem_true1    = init_mem_true1,
        cam1.init_mem_true2    = init_mem_true2,
        cam1.init_mem_comp1    = init_mem_comp1,
        cam1.init_mem_comp2    = init_mem_comp2;

    assign matchfound = ((operation_mode == "encoded_address")
                      || (operation_mode == "single_match"))
                    ? matchfound_tmp : 'bz;

endmodule  // apex20ke_cam_slice


////////////////////////////////////////////////////////////////////////////
//
// APEX20KE_LVDS_TRANSMITTER
//
////////////////////////////////////////////////////////////////////////////

module apex20ke_lvds_transmitter (clk0, clk1, datain, dataout, devclrn, devpor);
input [7:0] datain;
input clk0;
input clk1;
input devclrn;
input devpor;
output dataout;

parameter channel_width = 8;

integer i;
reg clk0_in_last_value, dataout_tmp;
reg clk1_in_last_value;
reg [7:0] indata;
reg [7:0] regdata;
integer fast_clk_count;

buf (clk0_in, clk0);
buf (clk1_in, clk1);
buf (datain_in0, datain[0]);
buf (datain_in1, datain[1]);
buf (datain_in2, datain[2]);
buf (datain_in3, datain[3]);
buf (datain_in4, datain[4]);
buf (datain_in5, datain[5]);
buf (datain_in6, datain[6]);
buf (datain_in7, datain[7]);

specify

   $setuphold(negedge clk1, datain[0], 0, 0);
   $setuphold(negedge clk1, datain[1], 0, 0);
   $setuphold(negedge clk1, datain[2], 0, 0);
   $setuphold(negedge clk1, datain[3], 0, 0);
   $setuphold(negedge clk1, datain[4], 0, 0);
   $setuphold(negedge clk1, datain[5], 0, 0);
   $setuphold(negedge clk1, datain[6], 0, 0);
   $setuphold(negedge clk1, datain[7], 0, 0);
   (negedge clk0 => (dataout +: dataout_tmp)) = (0, 0);
endspecify

initial
begin
   i = 0;
   clk0_in_last_value = 0;
   clk1_in_last_value = 0;
   dataout_tmp = 0;
   fast_clk_count = 4;
end

always @(clk0_in or clk1_in or devclrn or devpor)
begin
   if ((devpor == 'b0) || (devclrn == 'b0))
      dataout_tmp = 0;
   else 
   begin 
      if ((clk1_in == 1) && (clk1_in_last_value !== clk1_in))
//         indata = datain[channel_width-1:0]; 
	 fast_clk_count = 0;
      if ((clk0_in == 1) && (clk0_in_last_value !== clk0_in))
      begin
	 		//fast_clk_count = fast_clk_count + 1; SPR 87691
			if (fast_clk_count == 2)
			begin
         	for (i = channel_width-1; i >= 0; i = i - 1)
	    			regdata[i] = indata[i];
			end	
         dataout_tmp = regdata[channel_width-1];
         for (i = channel_width-1; i > 0; i = i - 1)
	    regdata[i] = regdata[i-1];
      end
      if ((clk0_in == 0) && (clk0_in_last_value !== clk0_in))
      begin
	 		fast_clk_count = fast_clk_count + 1;
	 if (fast_clk_count == 3)
	 begin
            indata[0] = datain_in0; 
            indata[1] = datain_in1; 
            indata[2] = datain_in2; 
            indata[3] = datain_in3; 
            indata[4] = datain_in4; 
            indata[5] = datain_in5; 
            indata[6] = datain_in6; 
            indata[7] = datain_in7; 
	 end
      end
   end
   clk0_in_last_value = clk0_in;
   clk1_in_last_value = clk1_in;
end

and (dataout, dataout_tmp,  1'b1);
endmodule

//
// APEX20KE_LVDS_RECEIVER
//
module apex20ke_lvds_receiver (deskewin, clk0, clk1, datain, dataout, devclrn, devpor);
input deskewin;
input datain;
input clk0;
input clk1;
input devclrn;
input devpor;
output [7:0] dataout;

parameter channel_width = 8;

integer i, clk0_count, cal_cycle;
reg clk0_last_value, clk1_last_value, deskewin_last_value;
reg [channel_width-1:0] deser_data_arr;
reg [7:0] dataout_tmp;
wire [7:0] data_out;
integer deskew_asserted, check_calibration, calibrated;
reg match;

// tri1 devclrn, devpor;
// tri0 deskewin;

buf (clk0_in, clk0);
buf (clk1_in, clk1);
buf (deskewin_in, deskewin);
buf (datain_in, datain);

specify
   (negedge clk0 => (dataout[0] +: data_out[0])) = (0, 0);
   (negedge clk0 => (dataout[1] +: data_out[1])) = (0, 0);
   (negedge clk0 => (dataout[2] +: data_out[2])) = (0, 0);
   (negedge clk0 => (dataout[3] +: data_out[3])) = (0, 0);
   (negedge clk0 => (dataout[4] +: data_out[4])) = (0, 0);
   (negedge clk0 => (dataout[5] +: data_out[5])) = (0, 0);
   (negedge clk0 => (dataout[6] +: data_out[6])) = (0, 0);
   (negedge clk0 => (dataout[7] +: data_out[7])) = (0, 0);

endspecify

initial
begin
    i = 0;
    clk0_count = 4;
    clk0_last_value = 0;
    deskewin_last_value = 0;
    calibrated = 0;
    cal_cycle = 1;
    dataout_tmp = 8'b0;
    deskew_asserted = 0;
    check_calibration = 0;
end


always @(deskewin_in or clk0_in or clk1_in or devpor or devclrn)
begin
    if ((deskewin_in == 1) && (deskewin_last_value == 0))
    begin
        deskew_asserted = 1;
        calibrated = 0;
        if (channel_width < 7)
          $display("Channel Width is less than 7. Calibration signal ignored.");
        else
           $display("Calibrating receiver ....");
    end
    if ((deskewin_in == 0) && (deskewin_last_value == 1))
        deskew_asserted = 0;

    if ((clk1_in == 1) && (clk1_last_value !== clk1_in))
    begin
        clk0_count = 0;
        if (check_calibration == 1 && calibrated != 1)
        begin
            if (channel_width == 7)
            begin
                if (deser_data_arr == 7'b0000111)
                begin
                    // calibrate ok
                    $display("Cycle %d: Calibration pattern: 0000111", cal_cycle);
                    match = 1'b1;
                end
                else begin
                    $display("Calibration error in cycle %d", cal_cycle);
                    $display("Expected pattern: 0000111, Actual pattern: %b", deser_data_arr);
                    match = 1'b0;
                end
            end
            else if (channel_width == 8)
            begin
                if (deser_data_arr == 8'b00001111)
                begin
                    // calibrate ok
                    $display("Cycle %d: Calibration pattern: 00001111", cal_cycle);
                    match = 1'b1;
                end
                else begin
                    $display("Calibration error in cycle %d", cal_cycle);
                    $display("Expected pattern: 00001111, Actual pattern: %b", deser_data_arr);
                    match = 1'b0;
                end
            end
            if (match == 1'b1)
            begin
                cal_cycle = cal_cycle + 1;
                if (cal_cycle >= 4)
                begin
                    calibrated = 1;
                    $display("Receiver calibration successful");
                end
            end
        else
        	if (calibrated == 0 && deskew_asserted != 1)
	   		$display("Warning: Receiver Calibration requires at least 3 cycles. Only %d cycles were completed when deskew was deasserted. Receiver may not be calibrated.", cal_cycle);
          cal_cycle = 0;
        end
        if (deskew_asserted == 1)
           check_calibration = 1;
        else
           check_calibration = 0;
    end
    if ((clk0_in == 'b1) && (clk0_last_value !== clk0_in))
    begin
       //clk0_count = clk0_count + 1; SPR 87691
    end

    if ((clk0_in == 'b0) && (clk0_last_value !== clk0_in))
    begin
       clk0_count = clk0_count + 1;
       if ((clk0_count == 3) && (deskew_asserted != 1))
           dataout_tmp[channel_width-1:0] = deser_data_arr;
       for (i = channel_width - 1; i >= 1; i = i - 1)
           deser_data_arr[i] = deser_data_arr[i-1];
       deser_data_arr[0] = datain_in;
    end
    clk0_last_value = clk0_in;
    clk1_last_value = clk1_in;
    deskewin_last_value = deskewin_in;
end
assign data_out = dataout_tmp;

buf (dataout[0], data_out[0]);
buf (dataout[1], data_out[1]);
buf (dataout[2], data_out[2]);
buf (dataout[3], data_out[3]);
buf (dataout[4], data_out[4]);
buf (dataout[5], data_out[5]);
buf (dataout[6], data_out[6]);
buf (dataout[7], data_out[7]);

endmodule


/////////////////////////////////////////////////////////////////////////////
//
// Module Name : APEX20KE_PLL
//
// Description : Simulation model for the APEX20KE device family PLL.
//
// Assumptions : Default values for unconnected ports will be passed from
//               the Quartus .vo netlist
//
/////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module apex20ke_pll (clk,
                     fbin,
                     ena,
                     clk0,
                     clk1,
                     locked
                     );

    // INPUT PORTS
    input clk;
    input ena;
    input fbin;

    // OUTPUT PORTS
    output clk0;
    output clk1;
    output locked;

    // GLOBAL PARAMETERS
    parameter operation_mode             = "normal";
    parameter simulation_type            = "timing";
    parameter clk0_multiply_by           = 1;
    parameter clk0_divide_by             = 1;
    parameter clk1_multiply_by           = 1;
    parameter clk1_divide_by             = 1;
    parameter input_frequency            = 1000;
    parameter phase_shift                = 0;
    parameter effective_phase_shift      = 0;
    parameter effective_clk0_delay       = 0;
    parameter effective_clk1_delay       = 0;
    parameter lock_high                  = 1;
    parameter lock_low                   = 1;
    parameter invalid_lock_multiplier    = 5;
    parameter valid_lock_multiplier      = 5;

    // INTERNAL VARIABLES AND NETS
    reg start_outclk;
    reg new_clk0;
    reg clk0_tmp;
    reg new_clk1;
    reg clk1_tmp;
    reg pll_lock;
    reg clk_last_value;
    reg violation;
    reg clk_check;
    reg [1:0] next_clk_check;

    real pll_last_rising_edge;
    real pll_last_falling_edge;
    real actual_clk_cycle;
    real expected_clk_cycle;
    real pll_duty_cycle;
    real inclk_period;
    real clk0_period;
    real clk1_period;
    real expected_next_clk_edge;
    integer clk0_phase_delay;
    integer clk1_phase_delay;

    integer pll_rising_edge_count;
    integer stop_lock_count;
    integer start_lock_count;
    integer first_clk0_cycle;
    integer first_clk1_cycle;
    integer lock_on_rise;
    integer lock_on_fall;
    integer clk_per_tolerance;

    // variables for clock synchronizing
    integer last_synchronizing_rising_edge_for_clk0;
    integer last_synchronizing_rising_edge_for_clk1;
    integer clk0_synchronizing_period;
    integer clk1_synchronizing_period;
    reg schedule_clk0;
    reg schedule_clk1;
    reg output_value0;
    reg output_value1;

    integer input_cycles_per_clk0;
    integer input_cycles_per_clk1;
    integer clk0_cycles_per_sync_period;
    integer clk1_cycles_per_sync_period;
    integer input_cycle_count_to_sync0;
    integer input_cycle_count_to_sync1;

    integer sched_time0;
    integer rem0;
    integer tmp_rem0;
    integer sched_time1;
    integer rem1;
    integer tmp_rem1;
    integer i, j, l0, l1;
    integer cycle_to_adjust0;
    integer cycle_to_adjust1;
    integer tmp_per0;
    integer high_time0;
    integer low_time0;
    integer tmp_per1;
    integer high_time1;
    integer low_time1;

    // BUFFER INPUTS
    buf (clk_in, clk);
    buf (ena_in, ena);
    buf (fbin_in, fbin);

    // TIMING PATHS  
    specify
       (ena => clk0) = (0, 0);
       (ena => clk1) = (0, 0);
       (clk => locked) = (0, 0);
       (fbin => clk0) = (0, 0);
       (fbin => clk1) = (0, 0);
    endspecify

    initial
    begin
       pll_rising_edge_count = 0;
       pll_lock = 0;
       stop_lock_count = 0;
       start_lock_count = 0;
       clk_last_value = 0;
       clk0_phase_delay = 0;
       clk1_phase_delay = 0;
       first_clk0_cycle = 1;
       first_clk1_cycle = 1;
       clk0_tmp = 1'bx;
       clk1_tmp = 1'bx;
       violation = 0;
       lock_on_rise = 0;
       lock_on_fall = 0;
       pll_last_rising_edge = 0;
       pll_last_falling_edge = 0;
       clk_check = 0;

       last_synchronizing_rising_edge_for_clk0 = 0;
       last_synchronizing_rising_edge_for_clk1 = 0;
       clk0_synchronizing_period = 0;
       clk1_synchronizing_period = 0;
       schedule_clk0 = 0;
       schedule_clk1 = 0;
       input_cycles_per_clk0 = clk0_divide_by;
       input_cycles_per_clk1 = clk1_divide_by;
       clk0_cycles_per_sync_period = clk0_multiply_by;
       clk1_cycles_per_sync_period = clk1_multiply_by;
       input_cycle_count_to_sync0 = 0;
       input_cycle_count_to_sync1 = 0;
       l0 = 1;
       l1 = 1;
       cycle_to_adjust0 = 0;
       cycle_to_adjust1 = 0;
    end

    always @(next_clk_check)
    begin
       if (next_clk_check == 1)
       begin
          #((inclk_period+clk_per_tolerance)/2) clk_check = ~clk_check;
       end
       else if (next_clk_check == 2)
       begin
          #(expected_next_clk_edge - $realtime) clk_check = ~clk_check;
       end
       next_clk_check = 0;
    end

    always @(clk_in or ena_in or clk_check)
    begin
       if (ena_in == 'b0)
          pll_lock = 0;
       else if ((clk_in == 'b1) && (clk_last_value !== clk_in))
       begin
          if (pll_lock == 1)
             next_clk_check = 1;
          if (pll_rising_edge_count == 0)   // this is first rising edge
          begin
             inclk_period = input_frequency;
             pll_duty_cycle = inclk_period/2;
             clk_per_tolerance = 0.1 * inclk_period;

             clk0_period = (clk0_divide_by * inclk_period) / clk0_multiply_by;
             clk1_period = (clk1_divide_by * inclk_period) / clk1_multiply_by;
             start_outclk = 0;
             if (simulation_type == "functional")
             begin
                clk0_phase_delay = phase_shift;
                clk1_phase_delay = phase_shift;
             end
             else begin
                clk0_phase_delay = effective_clk0_delay;
                clk1_phase_delay = effective_clk1_delay;
             end
          end
          else if (pll_rising_edge_count == 1) // this is second rising edge
          begin
             expected_clk_cycle = inclk_period;
             actual_clk_cycle = $realtime - pll_last_rising_edge;
             if (actual_clk_cycle < (expected_clk_cycle - clk_per_tolerance) ||
                 actual_clk_cycle > (expected_clk_cycle + clk_per_tolerance))
             begin
                $display($realtime, "Warning: Input frequency Violation");
                violation = 1;
                if (locked == 'b1)
                begin
                   stop_lock_count = stop_lock_count + 1;
                   if ((locked == 'b1) && (stop_lock_count == lock_low))
                   begin
                      pll_lock = 0;
                      start_lock_count = 0;
                      stop_lock_count = 0;
                      clk0_tmp = 'bx;
                      clk1_tmp = 'bx;
                   end
                end else
                begin
                   // initialize to 1 to be consistent with Mei Yee's change
                   // in Quartus model
                   start_lock_count = 1;
                end
             end
             else violation = 0;
             if ( ($realtime - pll_last_falling_edge) < (pll_duty_cycle - clk_per_tolerance/2) || ($realtime - pll_last_falling_edge) > (pll_duty_cycle + clk_per_tolerance/2) )
             begin
                $display($realtime, "Warning: Duty Cycle Violation");
                violation = 1;
             end
             else violation = 0;
          end
          else if ( ($realtime - pll_last_rising_edge) < (expected_clk_cycle - clk_per_tolerance) || ($realtime - pll_last_rising_edge) > (expected_clk_cycle + clk_per_tolerance) )
          begin
             $display($realtime, "Warning : Cycle Violation");
             violation = 1;
             if (locked == 1'b1)
             begin
                stop_lock_count = stop_lock_count + 1;
                if (stop_lock_count == lock_low)
                begin
                   pll_lock = 0;
                   start_lock_count = 0;
                   stop_lock_count = 0;
                   clk0_tmp = 'bx;
                   clk1_tmp = 'bx;
                end
             end
             else begin
                // initialize to 1 to be consistent with Mei Yee's change
                // in Quartus model
                start_lock_count = 1;
             end
          end else
          begin
             violation = 0;
             actual_clk_cycle = $realtime - pll_last_rising_edge;
          end
          pll_last_rising_edge = $realtime;
          pll_rising_edge_count = pll_rising_edge_count + 1;
          if (!violation)
          begin
             if (pll_lock == 1'b1)
             begin
                input_cycle_count_to_sync0 = input_cycle_count_to_sync0 + 1;
                if (input_cycle_count_to_sync0 == input_cycles_per_clk0)
                begin
                   clk0_synchronizing_period = $realtime - last_synchronizing_rising_edge_for_clk0;
                   last_synchronizing_rising_edge_for_clk0 = $realtime;
                   schedule_clk0 = 1;
                   input_cycle_count_to_sync0 = 0;
                end
                input_cycle_count_to_sync1 = input_cycle_count_to_sync1 + 1;
                if (input_cycle_count_to_sync1 == input_cycles_per_clk1)
                begin
                   clk1_synchronizing_period = $realtime - last_synchronizing_rising_edge_for_clk1;
                   last_synchronizing_rising_edge_for_clk1 = $realtime;
                   schedule_clk1 = 1;
                   input_cycle_count_to_sync1 = 0;
                end
             end else
             begin
                start_lock_count = start_lock_count + 1;
//              if (start_lock_count >= (lock_high + 1))
                // be consistent with Quartus
                if (start_lock_count >= lock_high)
                begin
                    pll_lock = 1;
                    input_cycle_count_to_sync0 = 0;
                    input_cycle_count_to_sync1 = 0;
                    lock_on_rise = 1;
                    if (last_synchronizing_rising_edge_for_clk0 == 0)
                       clk0_synchronizing_period = actual_clk_cycle * clk0_divide_by;
                    else
                       clk0_synchronizing_period = $realtime - last_synchronizing_rising_edge_for_clk0;
                    if (last_synchronizing_rising_edge_for_clk1 == 0)
                       clk1_synchronizing_period = actual_clk_cycle * clk1_divide_by;
                    else
                       clk1_synchronizing_period = $realtime - last_synchronizing_rising_edge_for_clk1;
                    last_synchronizing_rising_edge_for_clk0 = $realtime;
                    last_synchronizing_rising_edge_for_clk1 = $realtime;
                    schedule_clk0 = 1;
                    schedule_clk1 = 1;
                end
             end
          end
          else start_lock_count = 1;
       end
       else if ((clk_in == 'b0) && (clk_last_value !== clk_in))
       begin
          if (pll_lock == 1)
          begin
             next_clk_check = 1;
             if ( ($realtime - pll_last_rising_edge) < (pll_duty_cycle - clk_per_tolerance/2) || ($realtime - pll_last_rising_edge) > (pll_duty_cycle + clk_per_tolerance/2) )
             begin
                $display($realtime, "Warning: Duty Cycle Violation");
	        violation = 1;
                if (locked == 1'b1)
                begin
                   stop_lock_count = stop_lock_count + 1;
                   if (stop_lock_count == lock_low)
                    begin
                       pll_lock = 0;
                       start_lock_count = 0;
                       stop_lock_count = 0;
                       clk0_tmp = 'bx;
                       clk1_tmp = 'bx;
                    end
                end
             end
             else violation = 0;
          end
          else start_lock_count = start_lock_count + 1;
          pll_last_falling_edge = $realtime;
       end
       else if (pll_lock == 1)
       begin
          if (clk_in == 'b1)
             expected_next_clk_edge = pll_last_rising_edge + (inclk_period+clk_per_tolerance)/2;
          else if (clk_in == 'b0)
             expected_next_clk_edge = pll_last_falling_edge + (inclk_period+clk_per_tolerance)/2;
          else
             expected_next_clk_edge = 0;
          violation = 0;
          if ($realtime < expected_next_clk_edge)
             next_clk_check = 2;
             //#(expected_next_clk_edge - $realtime) clk_check = ~clk_check;
          else if ($realtime == expected_next_clk_edge)
             next_clk_check = 1;
             //#((inclk_period+clk_per_tolerance)/2) clk_check = ~clk_check;
          else
          begin
             $display($realtime, "Warning: Input frequency Violation");
             violation = 1;
             if (locked == 1'b1)
             begin
                stop_lock_count = stop_lock_count + 1;
                expected_next_clk_edge = $realtime + inclk_period/2;
                if (stop_lock_count == lock_low)
                begin
                   pll_lock = 0;
                   start_lock_count = 0;
                   stop_lock_count = 0;
                   clk0_tmp = 'bx;
                   clk1_tmp = 'bx;
                end
                else next_clk_check = 2;
             end
          end
       end
       clk_last_value = clk_in;
    end

    always @(posedge schedule_clk0)
    begin
       l0 = 1;
       cycle_to_adjust0 = 0;
       output_value0 = 1'b1;
       sched_time0 = clk0_phase_delay;
       rem0 = clk0_synchronizing_period % clk0_cycles_per_sync_period;
       for (i=1; i <= clk0_cycles_per_sync_period; i = i + 1)
       begin
          tmp_per0 = clk0_synchronizing_period/clk0_cycles_per_sync_period;
          if (rem0 != 0 && l0 <= rem0)
          begin
             tmp_rem0 = (clk0_cycles_per_sync_period * l0) % rem0;
             cycle_to_adjust0 = (clk0_cycles_per_sync_period * l0) / rem0;
             if (tmp_rem0 != 0)
                cycle_to_adjust0 = cycle_to_adjust0 + 1;
          end
          if (cycle_to_adjust0 == i)
          begin
             tmp_per0 = tmp_per0 + 1;
             l0 = l0 + 1;
          end
          high_time0 = tmp_per0/2;
          if (tmp_per0 % 2 != 0)
             high_time0 = high_time0 + 1;
          low_time0 = tmp_per0 - high_time0;
          for (j = 0; j <= 1; j=j+1)
          begin
             clk0_tmp <= #(sched_time0) output_value0;
             output_value0 = ~output_value0;
             if (output_value0 == 1'b0)
                sched_time0 = sched_time0 + high_time0;
             else if (output_value0 == 1'b1)
                sched_time0 = sched_time0 + low_time0;
          end
       end
       schedule_clk0 <= #1 1'b0;
    end

    always @(posedge schedule_clk1)
    begin
       l1 = 1;
       cycle_to_adjust1 = 0;
       output_value1 = 1'b1;
       sched_time1 = clk1_phase_delay;
       rem1 = clk1_synchronizing_period % clk1_cycles_per_sync_period;
       for (i=1; i <= clk1_cycles_per_sync_period; i = i + 1)
       begin
          tmp_per1 = clk1_synchronizing_period/clk1_cycles_per_sync_period;
          if (rem1 != 0 && l1 <= rem1)
          begin
             tmp_rem1 = (clk1_cycles_per_sync_period * l1) % rem1;
             cycle_to_adjust1 = (clk1_cycles_per_sync_period * l1) / rem1;
             if (tmp_rem1 != 0)
                cycle_to_adjust1 = cycle_to_adjust1 + 1;
          end
          if (cycle_to_adjust1 == i)
          begin
             tmp_per1 = tmp_per1 + 1;
             l1 = l1 + 1;
          end
          high_time1 = tmp_per1/2;
          if (tmp_per1 % 2 != 0)
             high_time1 = high_time1 + 1;
          low_time1 = tmp_per1 - high_time1;
          for (j = 0; j <= 1; j=j+1)
          begin
             clk1_tmp <= #(sched_time1) output_value1;
             output_value1 = ~output_value1;
             if (output_value1 == 1'b0)
                sched_time1 = sched_time1 + high_time1;
             else if (output_value1 == 1'b1)
                sched_time1 = sched_time1 + low_time1;
          end
       end
       schedule_clk1 <= #1 1'b0;
    end

    // ACCELERATE OUTPUTS
    buf (clk0, clk0_tmp);
    buf (clk1, clk1_tmp);
    buf (locked, pll_lock);

endmodule  // apex20ke_pll

//////////////////////////////////////////////////////////////////////////
//
// APEX20KE_DPRAM
//
/////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module apex20ke_dpram (portadatain,
 		      portadataout,
		      portaaddr,
		      portawe,
		      portaena,
		      portaclk,
		      portbdatain,
		      portbdataout,
		      portbaddr,
		      portbwe,
		      portbena,
		      portbclk
		      );

   // default parameters
   parameter   operation_mode = "single_port" ;
   parameter   output_mode    = "reg"         ;
   parameter   width          = 32            ;
   parameter   addrwidth      = 14            ;
   parameter   depth          = 16384         ;
   parameter   ramblock       = 65535         ;
   parameter   ramcontent     = ""            ;
   
   // size of memory array   
   reg [63:0]         dpram_content[depth-1:0];



   input              portawe           ,
                      portbwe           ,
                      portaena          ,
                      portbena          ,
                      portaclk          ,
                      portbclk          ;
         
   input  [63:0]      portadatain       ;
   input  [15:0]      portbdatain       ;
   
   input  [16:0]      portaaddr         ;
   input  [14:0]      portbaddr         ;
   
   output [63:0]      portadataout      ;
   output [15:0]      portbdataout      ;
   
   wire               portaclk_in       ;
   wire               portbclk_in       ;
   reg                portaclk_in_last  ;
   reg                portbclk_in_last  ;
   
   wire   [63:0]      portadatain_in    ;
   wire   [15:0]      portbdatain_in    ;
   
   reg    [63:0]      portadataout_tmp  ;
   reg    [15:0]      portbdataout_tmp  ;
   reg    [63:0]      portadataout_reg  ;
   reg    [15:0]      portbdataout_reg  ;
   reg    [63:0]      portadataout_reg_out  ;
   reg    [15:0]      portbdataout_reg_out  ;
   wire   [63:0]      portadataout_tmp2 ;
   wire   [15:0]      portbdataout_tmp2 ;
   
   wire               portawe_in        ;
   wire               portbwe_in        ;
   reg                portawe_latched   ;
   reg                portbwe_latched   ;

   wire               portaena_in       ;
   wire               portbena_in       ;

   wire   [16:0]      portaaddr_in      ;
   wire   [14:0]      portbaddr_in      ;
   reg    [addrwidth-1:0] portaaddr_latched ;
   reg    [addrwidth-1:0] portbaddr_latched ;
  
   specify
      $setuphold(posedge portaclk, portadatain , 0, 0);
      $setuphold(posedge portbclk, portbdatain , 0, 0);
      $setuphold(posedge portaclk, portadataout, 0, 0);
      $setuphold(posedge portbclk, portbdataout, 0, 0);
      (posedge portaclk => (portadataout +: portadataout_tmp2)) = (0, 0);
      (posedge portbclk => (portbdataout +: portbdataout_tmp2)) = (0, 0);
   endspecify

   buf (portadatain_in[63], portadatain[63]);
   buf (portadatain_in[62], portadatain[62]);
   buf (portadatain_in[61], portadatain[61]);
   buf (portadatain_in[60], portadatain[60]);
   buf (portadatain_in[59], portadatain[59]);
   buf (portadatain_in[58], portadatain[58]);
   buf (portadatain_in[57], portadatain[57]);
   buf (portadatain_in[56], portadatain[56]);
   buf (portadatain_in[55], portadatain[55]);
   buf (portadatain_in[54], portadatain[54]);
   buf (portadatain_in[53], portadatain[53]);
   buf (portadatain_in[52], portadatain[52]);
   buf (portadatain_in[51], portadatain[51]);
   buf (portadatain_in[50], portadatain[50]);
   buf (portadatain_in[49], portadatain[49]);
   buf (portadatain_in[48], portadatain[48]);
   buf (portadatain_in[47], portadatain[47]);
   buf (portadatain_in[46], portadatain[46]);
   buf (portadatain_in[45], portadatain[45]);
   buf (portadatain_in[44], portadatain[44]);
   buf (portadatain_in[43], portadatain[43]);
   buf (portadatain_in[42], portadatain[42]);
   buf (portadatain_in[41], portadatain[41]);
   buf (portadatain_in[40], portadatain[40]);
   buf (portadatain_in[39], portadatain[39]);
   buf (portadatain_in[38], portadatain[38]);
   buf (portadatain_in[37], portadatain[37]);
   buf (portadatain_in[36], portadatain[36]);
   buf (portadatain_in[35], portadatain[35]);
   buf (portadatain_in[34], portadatain[34]);
   buf (portadatain_in[33], portadatain[33]);
   buf (portadatain_in[32], portadatain[32]);
   buf (portadatain_in[31], portadatain[31]);
   buf (portadatain_in[30], portadatain[30]);
   buf (portadatain_in[29], portadatain[29]);
   buf (portadatain_in[28], portadatain[28]);
   buf (portadatain_in[27], portadatain[27]);
   buf (portadatain_in[26], portadatain[26]);
   buf (portadatain_in[25], portadatain[25]);
   buf (portadatain_in[24], portadatain[24]);
   buf (portadatain_in[23], portadatain[23]);
   buf (portadatain_in[22], portadatain[22]);
   buf (portadatain_in[21], portadatain[21]);
   buf (portadatain_in[20], portadatain[20]);
   buf (portadatain_in[19], portadatain[19]);
   buf (portadatain_in[18], portadatain[18]);
   buf (portadatain_in[17], portadatain[17]);
   buf (portadatain_in[16], portadatain[16]);
   buf (portadatain_in[15], portadatain[15]);
   buf (portadatain_in[14], portadatain[14]);
   buf (portadatain_in[13], portadatain[13]);
   buf (portadatain_in[12], portadatain[12]);
   buf (portadatain_in[11], portadatain[11]);
   buf (portadatain_in[10], portadatain[10]);
   buf (portadatain_in[9] , portadatain[9] );
   buf (portadatain_in[8] , portadatain[8] );
   buf (portadatain_in[7] , portadatain[7] );
   buf (portadatain_in[6] , portadatain[6] );
   buf (portadatain_in[5] , portadatain[5] );
   buf (portadatain_in[4] , portadatain[4] );
   buf (portadatain_in[3] , portadatain[3] );
   buf (portadatain_in[2] , portadatain[2] );
   buf (portadatain_in[1] , portadatain[1] );
   buf (portadatain_in[0] , portadatain[0] );

   buf (portaaddr_in[16], portaaddr[16]);
   buf (portaaddr_in[15], portaaddr[15]);
   buf (portaaddr_in[14], portaaddr[14]);
   buf (portaaddr_in[13], portaaddr[13]);
   buf (portaaddr_in[12], portaaddr[12]);
   buf (portaaddr_in[11], portaaddr[11]);
   buf (portaaddr_in[10], portaaddr[10]);
   buf (portaaddr_in[9] , portaaddr[9] );
   buf (portaaddr_in[8] , portaaddr[8] );
   buf (portaaddr_in[7] , portaaddr[7] );
   buf (portaaddr_in[6] , portaaddr[6] );
   buf (portaaddr_in[5] , portaaddr[5] );
   buf (portaaddr_in[4] , portaaddr[4] );
   buf (portaaddr_in[3] , portaaddr[3] );
   buf (portaaddr_in[2] , portaaddr[2] );
   buf (portaaddr_in[1] , portaaddr[1] );
   buf (portaaddr_in[0] , portaaddr[0] );

   buf (portaclk_in, portaclk);
   buf (portawe_in , portawe );
   buf (portaena_in, portaena);
  
   buf (portbdatain_in[15], portbdatain[15]);
   buf (portbdatain_in[14], portbdatain[14]);
   buf (portbdatain_in[13], portbdatain[13]);
   buf (portbdatain_in[12], portbdatain[12]);
   buf (portbdatain_in[11], portbdatain[11]);
   buf (portbdatain_in[10], portbdatain[10]);
   buf (portbdatain_in[9] , portbdatain[9] );
   buf (portbdatain_in[8] , portbdatain[8] );
   buf (portbdatain_in[7] , portbdatain[7] );
   buf (portbdatain_in[6] , portbdatain[6] );
   buf (portbdatain_in[5] , portbdatain[5] );
   buf (portbdatain_in[4] , portbdatain[4] );
   buf (portbdatain_in[3] , portbdatain[3] );
   buf (portbdatain_in[2] , portbdatain[2] );
   buf (portbdatain_in[1] , portbdatain[1] );
   buf (portbdatain_in[0] , portbdatain[0] );

   buf (portbaddr_in[14], portbaddr[14]);
   buf (portbaddr_in[13], portbaddr[13]);
   buf (portbaddr_in[12], portbaddr[12]);
   buf (portbaddr_in[11], portbaddr[11]);
   buf (portbaddr_in[10], portbaddr[10]);
   buf (portbaddr_in[9] , portbaddr[9] );
   buf (portbaddr_in[8] , portbaddr[8] );
   buf (portbaddr_in[7] , portbaddr[7] );
   buf (portbaddr_in[6] , portbaddr[6] );
   buf (portbaddr_in[5] , portbaddr[5] );
   buf (portbaddr_in[4] , portbaddr[4] );
   buf (portbaddr_in[3] , portbaddr[3] );
   buf (portbaddr_in[2] , portbaddr[2] );
   buf (portbaddr_in[1] , portbaddr[1] );
   buf (portbaddr_in[0] , portbaddr[0] );

   buf (portbclk_in, portbclk);
   buf (portbwe_in , portbwe );
   buf (portbena_in, portbena);

   //  Dual Port Contention  Port A address = Port B address
   // 
   // +//---------+----------+-------------+-------------+--------------+--------------+---------------------+
   // |  Port A   |  Port B  |  A Data In  |  B Data In  |  A Data Out  |  B Data Out  |     Memory State    |
   // +//---------+----------+-------------+-------------+--------------+--------------+---------------------+
   // |   read    |   read   |     DA      |     DB      |    memory    |    memory    |      no change      |
   // +//---------+----------+-------------+-------------+--------------+--------------+---------------------+
   // |   write   |   read   |     DA      |     DB      |    unknown   |    unknown   |    memory <= DA     |
   // +//---------+----------+-------------+-------------+--------------+--------------+---------------------+
   // |   read    |   write  |     DA      |     DB      |    unknown   |    unknown   |    memory <= DB     |
   // +//---------+----------+-------------+-------------+--------------+--------------+---------------------+
   // |   write   |   write  |     DA      |     DB      |    unknown   |    unknown   |  memory <= unknown  |
   // +//---------+----------+-------------+-------------+--------------+--------------+---------------------+ 
   //  
   //  Dual Port Contention  Port A address != Port B address
   // 
   // +//---------+----------+-------------+-------------+--------------+--------------+---------------------+
   // |  Port A   |  Port B  |  A Data In  |  B Data In  |  A Data Out  |  B Data Out  |     Memory State    |
   // +//---------+----------+-------------+-------------+--------------+--------------+---------------------+
   // |   read    |   read   |     DA      |     DB      |  mem[A_addr] |  mem[B_Addr] |      no change      |
   // +//---------+----------+-------------+-------------+--------------+--------------+---------------------+
   // |   write   |   read   |     DA      |     DB      |    unknown   |  mem[B_Addr] |  mem[A_Addr] <= DA  |
   // +//---------+----------+-------------+-------------+--------------+--------------+---------------------+
   // |   read    |   write  |     DA      |     DB      |  mem[A_addr] |    unknown   |  mem[B_Addr] <= DB  |
   // +//---------+----------+-------------+-------------+--------------+--------------+---------------------+
   // |   write   |   write  |     DA      |     DB      |    unknown   |    unknown   |  mem[A_Addr] <= DA  |
   // |           |          |             |             |              |              |  mem[B_Addr] <= DB  |
   // +//---------+----------+-------------+-------------+--------------+--------------+---------------------+ 
   // 
   // NB: Output state is always unknown when writing. 


   initial
     begin
  
         // Initialise dpram memory contents from file (if filename specified). 

         if (ramcontent != "" ) $readmemh(ramcontent, dpram_content);

         portaclk_in_last  = 0;
         portbclk_in_last  = 0;
     end
    
   always @(portaclk_in)
      begin
      if (portaclk_in != 0 && portaclk_in_last == 0)  // rising edge port a clock
         begin

         portawe_latched   = portawe_in                ;
         portaaddr_latched = portaaddr_in[addrwidth-1:0] ;
	     
         if (portawe_latched == 'b0)
            begin

            // reading A 

            if (portaaddr_latched == portbaddr_latched && portbwe_latched != 'b0)
               begin

               // B simultaneously writing to same address (effect of B write to memory handled below)

               portadataout_reg = portadataout_tmp;
               portadataout_tmp = 64'bx;

               end
            else
               begin

               // B reading from same address, or reading/writing to different address. 

               portadataout_reg = portadataout_tmp;
               portadataout_tmp = dpram_content[portaaddr_latched];

               end
            end

         else

            // writing to A

            begin
            if (portaaddr_latched == portbaddr_latched && portawe_latched != 'b0 && portbwe_latched != 'b0)
               begin

               // A and B simultaneously writing to same address

               portadataout_reg                 = portadataout_tmp ;
               dpram_content[portaaddr_latched] = 64'bx              ;
               portadataout_tmp                 = 64'bx              ;

               end
            else
               begin

               // B reading from same address or reading/writing to different address

               portadataout_reg                 = portadataout_tmp;
               dpram_content[portaaddr_latched] = portadatain_in ;
               portadataout_tmp                 = 64'bx             ;

               end
            end // writing to A 
         end // rising edge port a clock
         portaclk_in_last = portaclk_in;
   end // portaclk_in change event 



   always @(portbclk_in)
   begin
         if (portbclk_in != 0 && portbclk_in_last == 0 && operation_mode == "dual_port")  // rising edge port b clock
            begin	

            portbwe_latched   = portbwe_in   ;
            portbaddr_latched = portbaddr_in ;
	     
            if (portbwe_latched == 'b0)
               begin

               // reading B 

               if (portbaddr_latched == portaaddr_latched && portawe_latched != 'b0)
                  begin

                  // A simultaneously writing to same address (effect of A write to memory handled above)

                  portbdataout_reg = portbdataout_tmp;
                  portbdataout_tmp = 64'bx;

                  end
               else
                  begin

                  // A reading from same address, or reading/writing to different address. 

                  portbdataout_reg = portbdataout_tmp;
                  portbdataout_tmp = dpram_content[portbaddr_latched];

                  end
               end
            else

               // writing to B

               begin
               if (portbaddr_latched == portaaddr_latched && portbwe_latched != 'b0 && portawe_latched != 'b0)
                  begin

                  // B and A simultaneously writing to same address

                  portbdataout_reg                 = portbdataout_tmp ;
                  dpram_content[portbaddr_latched] = 64'bx              ;
                  portbdataout_tmp                 = 64'bx              ;

                  end
               else
                  begin

                  // A reading from same address or reading/writing to different address

                  portbdataout_reg                 = portbdataout_tmp;
                  dpram_content[portbaddr_latched] = portbdatain_in ;
                  portbdataout_tmp                 = 64'bx             ;

                  end
               end // writing to B
            end // rising edge port B clock

            portbclk_in_last = portbclk_in;

         end // portbclk_in change event

   // registered Port A output enabled ?

   always @(portaena_in or portadataout_reg)
   begin
       if (output_mode == "reg") 
           if ( portaena_in == 1'b1 )
               portadataout_reg_out = portadataout_reg ; 
   end

   // registered Port B output enabled ?

   always @(portbena_in or portbdataout_reg)
   begin
       if (output_mode == "reg") 
           if ( portbena_in == 1'b1 )
               portbdataout_reg_out = portbdataout_reg ; 
   end

   // Registered or Unregistered mode ?

   assign portadataout_tmp2 = (output_mode == "reg") ? portadataout_reg_out : portadataout_tmp;
   assign portbdataout_tmp2 = (output_mode == "reg") ? portbdataout_reg_out : portbdataout_tmp;


   // accelerated outputs

   buf (portadataout[63], portadataout_tmp2[63]);
   buf (portadataout[62], portadataout_tmp2[62]);
   buf (portadataout[61], portadataout_tmp2[61]);
   buf (portadataout[60], portadataout_tmp2[60]);
   buf (portadataout[59], portadataout_tmp2[59]);
   buf (portadataout[58], portadataout_tmp2[58]);
   buf (portadataout[57], portadataout_tmp2[57]);
   buf (portadataout[56], portadataout_tmp2[56]);
   buf (portadataout[55], portadataout_tmp2[55]);
   buf (portadataout[54], portadataout_tmp2[54]);
   buf (portadataout[53], portadataout_tmp2[53]);
   buf (portadataout[52], portadataout_tmp2[52]);
   buf (portadataout[51], portadataout_tmp2[51]);
   buf (portadataout[50], portadataout_tmp2[50]);
   buf (portadataout[49], portadataout_tmp2[49]);
   buf (portadataout[48], portadataout_tmp2[48]);
   buf (portadataout[47], portadataout_tmp2[47]);
   buf (portadataout[46], portadataout_tmp2[46]);
   buf (portadataout[45], portadataout_tmp2[45]);
   buf (portadataout[44], portadataout_tmp2[44]);
   buf (portadataout[43], portadataout_tmp2[43]);
   buf (portadataout[42], portadataout_tmp2[42]);
   buf (portadataout[41], portadataout_tmp2[41]);
   buf (portadataout[40], portadataout_tmp2[40]);
   buf (portadataout[39], portadataout_tmp2[39]);
   buf (portadataout[38], portadataout_tmp2[38]);
   buf (portadataout[37], portadataout_tmp2[37]);
   buf (portadataout[36], portadataout_tmp2[36]);
   buf (portadataout[35], portadataout_tmp2[35]);
   buf (portadataout[34], portadataout_tmp2[34]);
   buf (portadataout[33], portadataout_tmp2[33]);
   buf (portadataout[32], portadataout_tmp2[32]);
   buf (portadataout[31], portadataout_tmp2[31]);
   buf (portadataout[30], portadataout_tmp2[30]);
   buf (portadataout[29], portadataout_tmp2[29]);
   buf (portadataout[28], portadataout_tmp2[28]);
   buf (portadataout[27], portadataout_tmp2[27]);
   buf (portadataout[26], portadataout_tmp2[26]);
   buf (portadataout[25], portadataout_tmp2[25]);
   buf (portadataout[24], portadataout_tmp2[24]);
   buf (portadataout[23], portadataout_tmp2[23]);
   buf (portadataout[22], portadataout_tmp2[22]);
   buf (portadataout[21], portadataout_tmp2[21]);
   buf (portadataout[20], portadataout_tmp2[20]);
   buf (portadataout[19], portadataout_tmp2[19]);
   buf (portadataout[18], portadataout_tmp2[18]);
   buf (portadataout[17], portadataout_tmp2[17]);
   buf (portadataout[16], portadataout_tmp2[16]);
   buf (portadataout[15], portadataout_tmp2[15]);
   buf (portadataout[14], portadataout_tmp2[14]);
   buf (portadataout[13], portadataout_tmp2[13]);
   buf (portadataout[12], portadataout_tmp2[12]);
   buf (portadataout[11], portadataout_tmp2[11]);
   buf (portadataout[10], portadataout_tmp2[10]);
   buf (portadataout[9] , portadataout_tmp2[9] );
   buf (portadataout[8] , portadataout_tmp2[8] );
   buf (portadataout[7] , portadataout_tmp2[7] );
   buf (portadataout[6] , portadataout_tmp2[6] );
   buf (portadataout[5] , portadataout_tmp2[5] );
   buf (portadataout[4] , portadataout_tmp2[4] );
   buf (portadataout[3] , portadataout_tmp2[3] );
   buf (portadataout[2] , portadataout_tmp2[2] );
   buf (portadataout[1] , portadataout_tmp2[1] );
   buf (portadataout[0] , portadataout_tmp2[0] );


   buf (portbdataout[15], portbdataout_tmp2[15]);
   buf (portbdataout[14], portbdataout_tmp2[14]);
   buf (portbdataout[13], portbdataout_tmp2[13]);
   buf (portbdataout[12], portbdataout_tmp2[12]);
   buf (portbdataout[11], portbdataout_tmp2[11]);
   buf (portbdataout[10], portbdataout_tmp2[10]);
   buf (portbdataout[9] , portbdataout_tmp2[9] );
   buf (portbdataout[8] , portbdataout_tmp2[8] );
   buf (portbdataout[7] , portbdataout_tmp2[7] );
   buf (portbdataout[6] , portbdataout_tmp2[6] );
   buf (portbdataout[5] , portbdataout_tmp2[5] );
   buf (portbdataout[4] , portbdataout_tmp2[4] );
   buf (portbdataout[3] , portbdataout_tmp2[3] );
   buf (portbdataout[2] , portbdataout_tmp2[2] );
   buf (portbdataout[1] , portbdataout_tmp2[1] );
   buf (portbdataout[0] , portbdataout_tmp2[0] );

   
endmodule // apex20ke_dpram

// ////////////////////////////////////////////////////////////////////////////////////////////////////
// APEX 20KE Excalibur UP Core 
// ////////////////////////////////////////////////////////////////////////////////////////////////////

module apex20ke_upcore (
	    clkref, npor, nreseti, nreseto, nresetoe, intnmi, perreset,
            intpld, intuart, inttimer0, inttimer1, intproc0, intproc1,
            debugrq, debugext0, debugext1, debugiebrkpt, debugdewpt, debugextin, debugack,
            debugrng0, debugrng1, debugextout,

            slavehclk,
            slavehwrite, slavehreadyi, slavehselreg, slavehsel, slavehmastlock, slavehaddr,
            slavehwdata, slavehtrans, slavehsize, slavehburst, slavehreadyo, slavebuserrint,
            slavehrdata, slavehresp,

            masterhclk,
            masterhrdata, masterhresp, masterhwrite, masterhlock, masterhbusreq, masterhaddr,
            masterhwdata, masterhtrans, masterhsize, masterhready, masterhburst, masterhgrant,

            lockreqdp0, lockreqdp1,
            lockgrantdp0, lockgrantdp1,

            ebiack, ebiwen, ebioen, ebiclk, ebibe, ebicsn, ebiaddr, ebidqoe, ebidqout, ebidqin,        

            uarttxd, uartrtsn, uartdtrn, uartctsn, uartdsrn, uartrxd, uartdcdon, uartdcdin,
            uartriin, uartrion, uartdcdrioe,

            sdramclk, sdramclkn, sdramclke, sdramwen, sdramcasn, sdramrasn, sdramdqm,            
            sdramaddr, sdramdqoe, sdramdqout, sdramdqin, sdramdqsoe, sdramcsn,
            sdramdqsout, sdramdqsin,    

            intextpin, traceclk, tracesync, tracepipestat, tracepkt, gpi, gpo
            );

  parameter    processor      = "ARM";
  parameter    source         = ""   ;
  parameter    sdram_width    = 32;
  parameter    sdramdqm_width = 4;
  parameter    gpio_width     = 4;

  // AHB2 Master and Slave bridges
  // Interupt, debug and trace ports
  // DP Ram locks

  input         slavehclk, masterhclk;

  input         slavehwrite, slavehreadyi, slavehselreg, slavehsel,
                slavehmastlock, masterhready, masterhgrant;

  input         lockreqdp0, lockreqdp1, 
                debugrq, debugext0, debugext1, debugiebrkpt, debugdewpt;

  input  [31:0] slavehaddr, slavehwdata, masterhrdata;
  input   [1:0] slavehtrans, slavehsize, masterhresp;
  input   [3:0] debugextin;
  input   [5:0] intpld;
  input   [2:0] slavehburst;

  output        masterhwrite, masterhlock,  masterhbusreq, slavehreadyo, slavebuserrint,
                intuart,      inttimer0,    inttimer1,     intproc0,     intproc1,       
                debugack,     debugrng0,    debugrng1,
                lockgrantdp0, lockgrantdp1;
  input   [7:0] gpi;

  output [31:0] masterhaddr, masterhwdata, slavehrdata;
  output  [1:0] masterhtrans, masterhsize, slavehresp;
  output  [2:0] masterhburst;
  output  [3:0] debugextout;
  output  [7:0] gpo;

  // Shared IO connections
  // EBI Expansion bus
  // SDRAM interface
  // UART and trace port

  input         ebiack;
  output        ebiwen, ebioen, ebiclk, ebidqoe;
  output  [1:0] ebibe;
  output  [3:0] ebicsn;
  output [24:0] ebiaddr;
  input  [15:0] ebidqin;
  output [15:0] ebidqout;

  input         uartctsn,  uartdsrn, uartrxd; 
  output        uarttxd,   uartrtsn, uartdtrn;
  output        uartdcdon, uartrion;
  input         uartdcdin, uartriin;
  output        uartdcdrioe;
          
  output        sdramclk, sdramclkn, sdramclke,
                sdramwen, sdramcasn, sdramrasn;
  output  [1:0] sdramcsn;
  output  [3:0] sdramdqm;     
  output [14:0] sdramaddr;
  
  input  [31:0] sdramdqin;
  output [31:0] sdramdqout;
  output  [3:0] sdramdqoe;
  input   [3:0] sdramdqsin;                 
  output  [3:0] sdramdqsout;                 
  output        sdramdqsoe;
          
  input         intextpin;
  output        traceclk, tracesync;
  output  [2:0] tracepipestat;
  output [15:0] tracepkt;

  // Dedicated pins
  input 	clkref, npor, nreseti;
  output 	nreseto, nresetoe;
 
  //MIPS only ports
  output 	perreset;
  input 	intnmi;
   
  /////////////////////////////////////////////////////////////////////////////////////////////////
  // AHB Constants
  /////////////////////////////////////////////////////////////////////////////////////////////////

// respones (HRESP)
`define H_OKAY   2'b00
`define H_ERROR  2'b01
`define H_RETRY  2'b10
`define H_SPLIT  2'b11

// transcation types  (HTRANS)
`define H_IDLE   2'b00
`define H_BUSY   2'b01
`define H_NONSEQ 2'b10
`define H_SEQ    2'b11

// burst mode (HBURST)
`define H_SINGLE 3'b000
`define H_INCR   3'b001
`define H_WRAP4  3'b010
`define H_INCR4  3'b011
`define H_WRAP8  3'b100
`define H_INCR8  3'b101
`define H_WRAP16 3'b110
`define H_INCR16 3'b111

// transaction sizes (HSIZE 8,16,32 bits // larger sizes not supported)
`define H_BYTE   2'b00
`define H_HWORD  2'b01
`define H_WORD   2'b10


  /////////////////////////////////////////////////////////////////////////////////////////////////
  // slave port
  /////////////////////////////////////////////////////////////////////////////////////////////////

  wire          slavehclk_in;
  wire          slavehwrite_in, slavehreadyi_in, slavehselreg_in, slavehsel_in,
                slavehmastlock_in;
  wire   [31:0] slavehaddr_in, slavehwdata_in;
  wire    [1:0] slavehtrans_in, slavehsize_in;
  wire    [2:0] slavehburst_in;
  wire          slavehreadyo_out, slavebuserrint_out;
  wire   [31:0] slavehrdata_out;
  wire    [1:0] slavehresp_out;

  specify
      $setuphold(posedge slavehclk, slavehwrite   , 0, 0);
      $setuphold(posedge slavehclk, slavehreadyi  , 0, 0);
      $setuphold(posedge slavehclk, slavehselreg  , 0, 0);
      $setuphold(posedge slavehclk, slavehsel     , 0, 0);
      $setuphold(posedge slavehclk, slavehmastlock, 0, 0);
      $setuphold(posedge slavehclk, slavehaddr[0]   , 0, 0);
      $setuphold(posedge slavehclk, slavehaddr[1]   , 0, 0);
      $setuphold(posedge slavehclk, slavehaddr[2]   , 0, 0);
      $setuphold(posedge slavehclk, slavehaddr[3]   , 0, 0);
      $setuphold(posedge slavehclk, slavehaddr[4]   , 0, 0);
      $setuphold(posedge slavehclk, slavehaddr[5]   , 0, 0);
      $setuphold(posedge slavehclk, slavehaddr[6]   , 0, 0);
      $setuphold(posedge slavehclk, slavehaddr[7]   , 0, 0);
      $setuphold(posedge slavehclk, slavehaddr[8]   , 0, 0);
      $setuphold(posedge slavehclk, slavehaddr[9]   , 0, 0);
      $setuphold(posedge slavehclk, slavehaddr[10]  , 0, 0);
      $setuphold(posedge slavehclk, slavehaddr[11]  , 0, 0);
      $setuphold(posedge slavehclk, slavehaddr[12]  , 0, 0);
      $setuphold(posedge slavehclk, slavehaddr[13]  , 0, 0);
      $setuphold(posedge slavehclk, slavehaddr[14]  , 0, 0);
      $setuphold(posedge slavehclk, slavehaddr[15]  , 0, 0);
      $setuphold(posedge slavehclk, slavehaddr[16]  , 0, 0);
      $setuphold(posedge slavehclk, slavehaddr[17]  , 0, 0);
      $setuphold(posedge slavehclk, slavehaddr[18]  , 0, 0);
      $setuphold(posedge slavehclk, slavehaddr[19]  , 0, 0);
      $setuphold(posedge slavehclk, slavehaddr[20]  , 0, 0);
      $setuphold(posedge slavehclk, slavehaddr[21]  , 0, 0);
      $setuphold(posedge slavehclk, slavehaddr[22]  , 0, 0);
      $setuphold(posedge slavehclk, slavehaddr[23]  , 0, 0);
      $setuphold(posedge slavehclk, slavehaddr[24]  , 0, 0);
      $setuphold(posedge slavehclk, slavehaddr[25]  , 0, 0);
      $setuphold(posedge slavehclk, slavehaddr[26]  , 0, 0);
      $setuphold(posedge slavehclk, slavehaddr[27]  , 0, 0);
      $setuphold(posedge slavehclk, slavehaddr[28]  , 0, 0);
      $setuphold(posedge slavehclk, slavehaddr[29]  , 0, 0);
      $setuphold(posedge slavehclk, slavehaddr[30]  , 0, 0);
      $setuphold(posedge slavehclk, slavehaddr[31]  , 0, 0);
      $setuphold(posedge slavehclk, slavehwdata[0]  , 0, 0);
      $setuphold(posedge slavehclk, slavehwdata[1]  , 0, 0);
      $setuphold(posedge slavehclk, slavehwdata[2]  , 0, 0);
      $setuphold(posedge slavehclk, slavehwdata[3]  , 0, 0);
      $setuphold(posedge slavehclk, slavehwdata[4]  , 0, 0);
      $setuphold(posedge slavehclk, slavehwdata[5]  , 0, 0);
      $setuphold(posedge slavehclk, slavehwdata[6]  , 0, 0);
      $setuphold(posedge slavehclk, slavehwdata[7]  , 0, 0);
      $setuphold(posedge slavehclk, slavehwdata[8]  , 0, 0);
      $setuphold(posedge slavehclk, slavehwdata[9]  , 0, 0);
      $setuphold(posedge slavehclk, slavehwdata[10] , 0, 0);
      $setuphold(posedge slavehclk, slavehwdata[11] , 0, 0);
      $setuphold(posedge slavehclk, slavehwdata[12] , 0, 0);
      $setuphold(posedge slavehclk, slavehwdata[13] , 0, 0);
      $setuphold(posedge slavehclk, slavehwdata[14] , 0, 0);
      $setuphold(posedge slavehclk, slavehwdata[15] , 0, 0);
      $setuphold(posedge slavehclk, slavehwdata[16] , 0, 0);
      $setuphold(posedge slavehclk, slavehwdata[17] , 0, 0);
      $setuphold(posedge slavehclk, slavehwdata[18] , 0, 0);
      $setuphold(posedge slavehclk, slavehwdata[19] , 0, 0);
      $setuphold(posedge slavehclk, slavehwdata[20] , 0, 0);
      $setuphold(posedge slavehclk, slavehwdata[21] , 0, 0);
      $setuphold(posedge slavehclk, slavehwdata[22] , 0, 0);
      $setuphold(posedge slavehclk, slavehwdata[23] , 0, 0);
      $setuphold(posedge slavehclk, slavehwdata[24] , 0, 0);
      $setuphold(posedge slavehclk, slavehwdata[25] , 0, 0);
      $setuphold(posedge slavehclk, slavehwdata[26] , 0, 0);
      $setuphold(posedge slavehclk, slavehwdata[27] , 0, 0);
      $setuphold(posedge slavehclk, slavehwdata[28] , 0, 0);
      $setuphold(posedge slavehclk, slavehwdata[29] , 0, 0);
      $setuphold(posedge slavehclk, slavehwdata[30] , 0, 0);
      $setuphold(posedge slavehclk, slavehwdata[31] , 0, 0);
      $setuphold(posedge slavehclk, slavehtrans[0]  , 0, 0);
      $setuphold(posedge slavehclk, slavehtrans[1]  , 0, 0);
      $setuphold(posedge slavehclk, slavehsize[0]   , 0, 0);
      $setuphold(posedge slavehclk, slavehsize[1]   , 0, 0);
      $setuphold(posedge slavehclk, slavehburst[0]  , 0, 0);
      $setuphold(posedge slavehclk, slavehburst[1]  , 0, 0);
      $setuphold(posedge slavehclk, slavehburst[2]  , 0, 0);

      (posedge slavehclk => (slavehreadyo     +: slavehreadyo_out   )) = (0,0);
      (posedge slavehclk => (slavebuserrint   +: slavebuserrint_out )) = (0,0);
      (posedge slavehclk => (slavehresp[1]    +: slavehresp_out[1]  )) = (0,0);
      (posedge slavehclk => (slavehresp[0]    +: slavehresp_out[0]  )) = (0,0);
  
      (posedge slavehclk => (slavehrdata[31]  +: slavehrdata_out[31])) = (0,0);
      (posedge slavehclk => (slavehrdata[30]  +: slavehrdata_out[30])) = (0,0);
      (posedge slavehclk => (slavehrdata[29]  +: slavehrdata_out[29])) = (0,0);
      (posedge slavehclk => (slavehrdata[28]  +: slavehrdata_out[28])) = (0,0);
      (posedge slavehclk => (slavehrdata[27]  +: slavehrdata_out[27])) = (0,0);
      (posedge slavehclk => (slavehrdata[26]  +: slavehrdata_out[26])) = (0,0);
      (posedge slavehclk => (slavehrdata[25]  +: slavehrdata_out[25])) = (0,0);
      (posedge slavehclk => (slavehrdata[24]  +: slavehrdata_out[24])) = (0,0);
      (posedge slavehclk => (slavehrdata[23]  +: slavehrdata_out[23])) = (0,0);
      (posedge slavehclk => (slavehrdata[22]  +: slavehrdata_out[22])) = (0,0);
      (posedge slavehclk => (slavehrdata[21]  +: slavehrdata_out[21])) = (0,0);
      (posedge slavehclk => (slavehrdata[20]  +: slavehrdata_out[20])) = (0,0);
      (posedge slavehclk => (slavehrdata[19]  +: slavehrdata_out[19])) = (0,0);
      (posedge slavehclk => (slavehrdata[18]  +: slavehrdata_out[18])) = (0,0);
      (posedge slavehclk => (slavehrdata[17]  +: slavehrdata_out[17])) = (0,0);
      (posedge slavehclk => (slavehrdata[16]  +: slavehrdata_out[16])) = (0,0);
      (posedge slavehclk => (slavehrdata[15]  +: slavehrdata_out[15])) = (0,0);
      (posedge slavehclk => (slavehrdata[14]  +: slavehrdata_out[14])) = (0,0);
      (posedge slavehclk => (slavehrdata[13]  +: slavehrdata_out[13])) = (0,0);
      (posedge slavehclk => (slavehrdata[12]  +: slavehrdata_out[12])) = (0,0);
      (posedge slavehclk => (slavehrdata[11]  +: slavehrdata_out[11])) = (0,0);
      (posedge slavehclk => (slavehrdata[10]  +: slavehrdata_out[10])) = (0,0);
      (posedge slavehclk => (slavehrdata[9]   +: slavehrdata_out[9] )) = (0,0);
      (posedge slavehclk => (slavehrdata[8]   +: slavehrdata_out[8] )) = (0,0);
      (posedge slavehclk => (slavehrdata[7]   +: slavehrdata_out[7] )) = (0,0);
      (posedge slavehclk => (slavehrdata[6]   +: slavehrdata_out[6] )) = (0,0);
      (posedge slavehclk => (slavehrdata[5]   +: slavehrdata_out[5] )) = (0,0);
      (posedge slavehclk => (slavehrdata[4]   +: slavehrdata_out[4] )) = (0,0);
      (posedge slavehclk => (slavehrdata[3]   +: slavehrdata_out[3] )) = (0,0);
      (posedge slavehclk => (slavehrdata[2]   +: slavehrdata_out[2] )) = (0,0);
      (posedge slavehclk => (slavehrdata[1]   +: slavehrdata_out[1] )) = (0,0);
      (posedge slavehclk => (slavehrdata[0]   +: slavehrdata_out[0] )) = (0,0);
  endspecify

  // buffer inputs

  buf(slavehclk_in     , slavehclk     );
  buf(slavehwrite_in   , slavehwrite   );
  buf(slavehreadyi_in  , slavehreadyi  );
  buf(slavehselreg_in  , slavehselreg  );
  buf(slavehsel_in     , slavehsel     );
  buf(slavehmastlock_in, slavehmastlock);
  
  buf(slavehaddr_in[31], slavehaddr[31]);
  buf(slavehaddr_in[30], slavehaddr[30]);
  buf(slavehaddr_in[29], slavehaddr[29]);
  buf(slavehaddr_in[28], slavehaddr[28]);
  buf(slavehaddr_in[27], slavehaddr[27]);
  buf(slavehaddr_in[26], slavehaddr[26]);
  buf(slavehaddr_in[25], slavehaddr[25]);
  buf(slavehaddr_in[24], slavehaddr[24]);
  buf(slavehaddr_in[23], slavehaddr[23]);
  buf(slavehaddr_in[22], slavehaddr[22]);
  buf(slavehaddr_in[21], slavehaddr[21]);
  buf(slavehaddr_in[20], slavehaddr[20]);
  buf(slavehaddr_in[19], slavehaddr[19]);
  buf(slavehaddr_in[18], slavehaddr[18]);
  buf(slavehaddr_in[17], slavehaddr[17]);
  buf(slavehaddr_in[16], slavehaddr[16]);
  buf(slavehaddr_in[15], slavehaddr[15]);
  buf(slavehaddr_in[14], slavehaddr[14]);
  buf(slavehaddr_in[13], slavehaddr[13]);
  buf(slavehaddr_in[12], slavehaddr[12]);
  buf(slavehaddr_in[11], slavehaddr[11]);
  buf(slavehaddr_in[10], slavehaddr[10]);
  buf(slavehaddr_in[9] , slavehaddr[9] );
  buf(slavehaddr_in[8] , slavehaddr[8] );
  buf(slavehaddr_in[7] , slavehaddr[7] );
  buf(slavehaddr_in[6] , slavehaddr[6] );
  buf(slavehaddr_in[5] , slavehaddr[5] );
  buf(slavehaddr_in[4] , slavehaddr[4] );
  buf(slavehaddr_in[3] , slavehaddr[3] );
  buf(slavehaddr_in[2] , slavehaddr[2] );
  buf(slavehaddr_in[1] , slavehaddr[1] );
  buf(slavehaddr_in[0] , slavehaddr[0] );

  buf(slavehwdata_in[31], slavehwdata[31]);
  buf(slavehwdata_in[30], slavehwdata[30]);
  buf(slavehwdata_in[29], slavehwdata[29]);
  buf(slavehwdata_in[28], slavehwdata[28]);
  buf(slavehwdata_in[27], slavehwdata[27]);
  buf(slavehwdata_in[26], slavehwdata[26]);
  buf(slavehwdata_in[25], slavehwdata[25]);
  buf(slavehwdata_in[24], slavehwdata[24]);
  buf(slavehwdata_in[23], slavehwdata[23]);
  buf(slavehwdata_in[22], slavehwdata[22]);
  buf(slavehwdata_in[21], slavehwdata[21]);
  buf(slavehwdata_in[20], slavehwdata[20]);
  buf(slavehwdata_in[19], slavehwdata[19]);
  buf(slavehwdata_in[18], slavehwdata[18]);
  buf(slavehwdata_in[17], slavehwdata[17]);
  buf(slavehwdata_in[16], slavehwdata[16]);
  buf(slavehwdata_in[15], slavehwdata[15]);
  buf(slavehwdata_in[14], slavehwdata[14]);
  buf(slavehwdata_in[13], slavehwdata[13]);
  buf(slavehwdata_in[12], slavehwdata[12]);
  buf(slavehwdata_in[11], slavehwdata[11]);
  buf(slavehwdata_in[10], slavehwdata[10]);
  buf(slavehwdata_in[9] , slavehwdata[9] );
  buf(slavehwdata_in[8] , slavehwdata[8] );
  buf(slavehwdata_in[7] , slavehwdata[7] );
  buf(slavehwdata_in[6] , slavehwdata[6] );
  buf(slavehwdata_in[5] , slavehwdata[5] );
  buf(slavehwdata_in[4] , slavehwdata[4] );
  buf(slavehwdata_in[3] , slavehwdata[3] );
  buf(slavehwdata_in[2] , slavehwdata[2] );
  buf(slavehwdata_in[1] , slavehwdata[1] );
  buf(slavehwdata_in[0] , slavehwdata[0] );

  buf(slavehtrans_in[1] , slavehtrans[1] );
  buf(slavehtrans_in[0] , slavehtrans[0] );
  buf(slavehsize_in[1]  , slavehsize[1]  );
  buf(slavehsize_in[0]  , slavehsize[0]  );
  buf(slavehburst_in[2] , slavehburst[2] );
  buf(slavehburst_in[1] , slavehburst[1] );
  buf(slavehburst_in[0] , slavehburst[0] );

  // buffer outputs

  buf(slavehreadyo   , slavehreadyo_out   );
  buf(slavebuserrint , slavebuserrint_out ); 
  buf(slavehrdata[31], slavehrdata_out[31]);
  buf(slavehrdata[30], slavehrdata_out[30]);
  buf(slavehrdata[29], slavehrdata_out[29]);
  buf(slavehrdata[28], slavehrdata_out[28]);
  buf(slavehrdata[27], slavehrdata_out[27]);
  buf(slavehrdata[26], slavehrdata_out[26]);
  buf(slavehrdata[25], slavehrdata_out[25]);
  buf(slavehrdata[24], slavehrdata_out[24]);
  buf(slavehrdata[23], slavehrdata_out[23]);
  buf(slavehrdata[22], slavehrdata_out[22]);
  buf(slavehrdata[21], slavehrdata_out[21]);
  buf(slavehrdata[20], slavehrdata_out[20]);
  buf(slavehrdata[19], slavehrdata_out[19]);
  buf(slavehrdata[18], slavehrdata_out[18]);
  buf(slavehrdata[17], slavehrdata_out[17]);
  buf(slavehrdata[16], slavehrdata_out[16]);
  buf(slavehrdata[15], slavehrdata_out[15]);
  buf(slavehrdata[14], slavehrdata_out[14]);
  buf(slavehrdata[13], slavehrdata_out[13]);
  buf(slavehrdata[12], slavehrdata_out[12]);
  buf(slavehrdata[11], slavehrdata_out[11]);
  buf(slavehrdata[10], slavehrdata_out[10]);
  buf(slavehrdata[9] , slavehrdata_out[9] );
  buf(slavehrdata[8] , slavehrdata_out[8] );
  buf(slavehrdata[7] , slavehrdata_out[7] );
  buf(slavehrdata[6] , slavehrdata_out[6] );
  buf(slavehrdata[5] , slavehrdata_out[5] );
  buf(slavehrdata[4] , slavehrdata_out[4] );
  buf(slavehrdata[3] , slavehrdata_out[3] );
  buf(slavehrdata[2] , slavehrdata_out[2] );
  buf(slavehrdata[1] , slavehrdata_out[1] );
  buf(slavehrdata[0] , slavehrdata_out[0] );
  buf(slavehresp[1]  , slavehresp_out[1]  );
  buf(slavehresp[0]  , slavehresp_out[0]  );

  /////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////

  // outputs
  reg         slavehreadyo_out_r ;
  reg [1:0]   slavehresp_out_r   ;

  assign      slavehreadyo_out =  slavehreadyo_out_r ;
  assign      slavehresp_out   =  slavehresp_out_r   ;


  // record of address and control information (latched on address phase)
  reg [31:0]   startReg;            // start address for burst
  reg [31:0]   addrReg;
  reg  [1:0]   transReg;
  reg  [1:0]   sizeReg;
  reg          writeReg;
  reg  [2:0]   burstReg;
  reg          selReg;
  reg  [7:0]   waitReg;
  
  // Implement 6 banks of 256K = (1.5MB of address space)
  // ///////////////////////////////////////////////////////////////////
  reg [79:0]  memCfg[0:5];        // slavememory.cfg.dat
  reg [31:0]  memStart[0:5];
  reg [31:0]  memEnd[0:5];
  reg  [7:0]  memWaitStart[0:5];
  reg  [7:0]  memWait[0:5];
  reg [31:0]  memMapA[0:65535];    // slavememory.0.dat
  reg [31:0]  memMapB[0:65535];
  reg [31:0]  memMapC[0:65535];
  reg [31:0]  memMapD[0:65535];
  reg [31:0]  memMapE[0:65535];
  reg [31:0]  memMapF[0:65535];    // slavememory.5.dat

  reg  [2:0]  memBank;
  reg [79:0]  temp;
  
  integer output_file ; 

  initial begin

      // Open the results file
      output_file = $fopen("output.dat") ;
      if ( !output_file )
           $display("ERROR: Cannot open Output File") ;

  
      // Initialise memory banks from config and map files
      //////////////////////////////////////////////////////////////////////
      temp=80'h00000000_00000000_00_00;
      for (memBank=0;memBank<6;memBank=memBank+1)
      begin
          memCfg[memBank]=temp;
      end

      // 79..48 start address
      // 47..16 end address
      // 15...8 wait states on first access
      //  7...0 wait states per cycle
      $readmemh("slavememory.cfg.dat", memCfg);        
      for (memBank=0;memBank<6;memBank=memBank+1)
      begin
          temp=memCfg[memBank];
          memStart[memBank]     =temp[79:48];
          memEnd[memBank]       =temp[47:16];
          memWaitStart[memBank] =temp[15:8];
          memWait[memBank]      =temp[7:0];
      end
      
      if (memStart[0]!=memEnd[0]) $readmemh("slavememory.0.dat", memMapA);
      if (memStart[1]!=memEnd[1]) $readmemh("slavememory.1.dat", memMapB);
      if (memStart[2]!=memEnd[2]) $readmemh("slavememory.2.dat", memMapC);
      if (memStart[3]!=memEnd[3]) $readmemh("slavememory.3.dat", memMapD);
      if (memStart[4]!=memEnd[4]) $readmemh("slavememory.4.dat", memMapE);
      if (memStart[5]!=memEnd[5]) $readmemh("slavememory.5.dat", memMapF);
      //////////////////////////////////////////////////////////////////////
  
      addrReg=0;
      transReg=`H_IDLE;
      sizeReg=`H_WORD;
      writeReg=0;
      burstReg=`H_NONSEQ;
      selReg=0;

      slavehresp_out_r=`H_OKAY;
  end


  // select signal
  wire    sel = slavehsel_in & slavehreadyi_in;

  // determine if the transaction includes an operation / a "busy"
  wire doWork     = selReg & ((transReg==`H_NONSEQ || transReg==`H_SEQ) ? 1'b1 : 1'b0);
  wire doBusyWork = selReg & ( transReg==`H_BUSY                        ? 1'b1 : 1'b0);


  // BURST MODE SUPPORT
  ///////////////////////////////////////////////////////////////////////////////
  //
  // If we are in burst mode we'll compute our own address and control settings
  // based on the spec.
  //
  // compute values SEQuential (burst) transfers
  wire    seqTrans =  ( selReg & 
                      ( doWork | doBusyWork) & 
                      ( (slavehtrans_in==`H_SEQ || slavehtrans_in==`H_BUSY) ) ? 1'b1 : 1'b0 );
                      

  // mask to determine which bits are retained from the start address
  wire [31:0] wrapmask;
  assign wrapmask =
          ( burstReg==`H_WRAP4  ? {32{1'b1}} << 2:    // all but 2
          ( burstReg==`H_WRAP8  ? {32{1'b1}} << 3:    // all but 3
          ( burstReg==`H_WRAP16 ? {32{1'b1}} << 4:    // all but 4
                                  {32{1'b0}} ) ));    // none
  wire [31:0] wrapmask_w;
  assign wrapmask_w =                                // correct for word size
          ( sizeReg==`H_WORD  ? wrapmask<<2 :
          ( sizeReg==`H_HWORD ? wrapmask<<1 : 
                   /* H_BYTE */ wrapmask         ));
  
  wire [31:0] seqPlusAddr;                // work out the next sequential address
  assign seqPlusAddr =
          ( burstReg == `H_SINGLE) ?  addrReg :
               addrReg +     ( sizeReg==`H_BYTE  ? 1 : 
                          ( sizeReg==`H_HWORD ? 2 : 
                          ( sizeReg==`H_WORD  ? 4 : 0) ) ) ;

  wire [31:0] seqAddr;                    // apply the mask to wrap at boundaries
  assign seqAddr = (slavehtrans_in==`H_BUSY) ? addrReg :
                  ( (startReg&wrapmask_w) | (seqPlusAddr&~wrapmask_w));
                                      
  //
  // if this is a sequential transaction only sample HTRANS
  wire [31:0] startNext;
  wire [31:0] addrNext;
  wire  [1:0] transNext;
  wire  [1:0] sizeNext;
  wire  [2:0] burstNext;
  wire        writeNext;    

  assign startNext = seqTrans ? startReg : slavehaddr_in;
  assign addrNext  = seqTrans ? seqAddr  : slavehaddr_in;
  assign transNext = slavehtrans_in;
  assign sizeNext  = seqTrans ? sizeReg  : slavehsize_in;
  assign burstNext = seqTrans ? burstReg : slavehburst_in;
  assign writeNext = seqTrans ? writeReg : slavehwrite_in;


  // Latch the control data if we are selected
  ///////////////////////////////////////////////////////////////////////////////////
  always @ (posedge slavehclk_in)
  begin
      // if readin is low another device is wait stating its
      // data phase and hence extending our address phase
      if (slavehreadyi_in)
      begin
          selReg <= sel;
          if (sel)            // latch the control data
          begin
              startReg <= startNext;
              addrReg  <= addrNext;
              transReg <= transNext;
              sizeReg  <= sizeNext;
              writeReg <= writeNext;
              burstReg <= burstNext;
          end
          else
          begin
              startReg <= 0;
              addrReg  <= 0;
              transReg <= `H_IDLE;
              sizeReg  <= `H_WORD;
              writeReg <= 0;
              burstReg <= `H_SINGLE;
          end
      end
  end


  // Implment memory banks
  ///////////////////////////////////////////////////////////////////////////////////
  // bank selects
  wire bankA = ( addrReg>=memStart[0] && addrReg<=memEnd[0] && memStart[0]!=memEnd[0]) ? 1'b1 : 1'b0;
  wire bankB = ( addrReg>=memStart[1] && addrReg<=memEnd[1] && memStart[1]!=memEnd[1]) ? 1'b1 : 1'b0;
  wire bankC = ( addrReg>=memStart[2] && addrReg<=memEnd[2] && memStart[2]!=memEnd[2]) ? 1'b1 : 1'b0;    
  wire bankD = ( addrReg>=memStart[3] && addrReg<=memEnd[3] && memStart[3]!=memEnd[3]) ? 1'b1 : 1'b0;    
  wire bankE = ( addrReg>=memStart[4] && addrReg<=memEnd[4] && memStart[4]!=memEnd[4]) ? 1'b1 : 1'b0;    
  wire bankF = ( addrReg>=memStart[5] && addrReg<=memEnd[5] && memStart[5]!=memEnd[5]) ? 1'b1 : 1'b0;    
  
  // byte offset into bank                         //word offset into bank
  wire [31:0] offsetA = addrReg-memStart[0];        wire [15:0] wordA = offsetA[17:2];
  wire [31:0] offsetB = addrReg-memStart[1];        wire [15:0] wordB = offsetB[17:2];
  wire [31:0] offsetC = addrReg-memStart[2];        wire [15:0] wordC = offsetC[17:2];
  wire [31:0] offsetD = addrReg-memStart[3];        wire [15:0] wordD = offsetD[17:2];
  wire [31:0] offsetE = addrReg-memStart[4];        wire [15:0] wordE = offsetE[17:2];
  wire [31:0] offsetF = addrReg-memStart[5];        wire [15:0] wordF = offsetF[17:2];

  // current data
  wire [31:0] dataA   = memMapA[wordA];  
  wire [31:0] dataB   = memMapB[wordB];  
  wire [31:0] dataC   = memMapC[wordC];  
  wire [31:0] dataD   = memMapD[wordD];  
  wire [31:0] dataE   = memMapE[wordE];  
  wire [31:0] dataF   = memMapF[wordF];  

  reg  [31:0] currentVal;
  always @(dataA or dataB or dataC or dataD or dataE or dataF or 
           bankA or bankB or bankC or bankD or bankE or bankF  )
  begin
         if (bankA) currentVal=dataA;
    else if (bankB) currentVal=dataB;
    else if (bankC) currentVal=dataC;
    else if (bankD) currentVal=dataD;
    else if (bankE) currentVal=dataE;
    else if (bankF) currentVal=dataF;
  end
    

  // byte enables
  wire be0 = ( sizeReg==`H_WORD                         || 
              (sizeReg==`H_HWORD && addrReg[1]==1'b0)   || 
              (sizeReg==`H_BYTE  && addrReg[1:0]==2'b00) ) ? 1'b1 : 1'b0;
  wire be1 = ( sizeReg==`H_WORD                         || 
              (sizeReg==`H_HWORD && addrReg[1]==1'b0)   || 
              (sizeReg==`H_BYTE  && addrReg[1:0]==2'b01) ) ? 1'b1 : 1'b0;
  wire be2 = ( sizeReg==`H_WORD                         || 
              (sizeReg==`H_HWORD && addrReg[1]==1'b1)   || 
              (sizeReg==`H_BYTE  && addrReg[1:0]==2'b10) ) ? 1'b1 : 1'b0;
  wire be3 = ( sizeReg==`H_WORD                         || 
              (sizeReg==`H_HWORD && addrReg[1]==1'b1)   || 
              (sizeReg==`H_BYTE  && addrReg[1:0]==2'b11) ) ? 1'b1 : 1'b0;
              
  wire [31:0] readDataMask = { be3 ? 8'hFF : 8'h00,
                                 be2 ? 8'hFF : 8'h00,
                                 be1 ? 8'hFF : 8'h00,
                                 be0 ? 8'hFF : 8'h00 };



  // wait state generation
  ///////////////////////////////////////////////////////////////////////////////////

  reg         s_addr_latch;      // address latched this cycle
  reg   [7:0] waitStart;
  reg   [7:0] waitSeq;

  initial begin 
      s_addr_latch=1'b0;
      waitReg=8'h00;
  end

  always @(bankA or bankB or bankC or bankD or bankE or bankF  )
  begin
         if (bankA) waitStart = memWaitStart[0];
    else if (bankB) waitStart = memWaitStart[1];
    else if (bankC) waitStart = memWaitStart[2];
    else if (bankD) waitStart = memWaitStart[3];
    else if (bankE) waitStart = memWaitStart[4];
    else if (bankF) waitStart = memWaitStart[5];
  end

  always @(bankA or bankB or bankC or bankD or bankE or bankF  )
  begin
         if (bankA) waitSeq = memWait[0];
    else if (bankB) waitSeq = memWait[1];
    else if (bankC) waitSeq = memWait[2];
    else if (bankD) waitSeq = memWait[3];
    else if (bankE) waitSeq = memWait[4];
    else if (bankF) waitSeq = memWait[5];
  end


  //
  // wait if 
  //    first beat and memWaitStart and addr has just been latched
  // or
  //    first beat and waitReg (more than 1 wait state)
  // or     
  //    seq beat and waitReg
  // else ready
  //

  always @(posedge slavehclk_in)
    s_addr_latch <= slavehreadyi_in & slavehsel_in;

  always @(doWork or transReg or waitReg or waitStart or s_addr_latch)
  begin
    if ( doWork & (transReg==`H_NONSEQ) & (waitStart!=8'h00) & s_addr_latch )
      begin
      slavehreadyo_out_r = 1'b0;
      // $fdisplay(output_file, "SLAVE: wait on first" );
      end
    else if ( doWork & (transReg==`H_NONSEQ) & waitReg!=8'h00 )
      begin
      slavehreadyo_out_r = 1'b0;
      // $fdisplay(output_file, "SLAVE: wait" );
      end
    else if (doWork & (transReg==`H_SEQ) & (waitReg!=8'h00))
      begin
      slavehreadyo_out_r = 1'b0;
      // $fdisplay(output_file, "SLAVE: wait" );
      end
    else
      slavehreadyo_out_r = 1'b1;
  end


  // if we are waiting (waitReg>0) and not in a busy decrement the counter
  // otherwise get the new value from memWait of memWaitStart according to
  // the transaction type 
  
  wire [7:0] waitStartNext;
  assign waitStartNext = ( waitStart>8'h01  ? (waitStart-1) : 8'h00);

  always @ (posedge slavehclk_in)
    waitReg<=  (waitReg!=8'h00 & ~doBusyWork) ? (waitReg - 1'b1)  :
       ( doWork & (transReg==`H_NONSEQ) & (waitStart!=8'h00) & s_addr_latch ? waitStartNext :
       ( seqTrans ? waitSeq : 8'h00 ));


  // read data
  ///////////////////////////////////////////////////////////////////////////////////
  assign slavehrdata_out = (doWork & ~writeReg & slavehreadyo_out_r) ? 
                              (readDataMask & currentVal) : {32{1'b0}};


              
  // record writes in memory banks   + report on screen
  ///////////////////////////////////////////////////////////////////////////////////
  reg  [31:0] memWord;        // the word to be updated / read 
  always @ (posedge slavehclk_in)
  begin
      if (doWork & slavehreadyo_out_r)
      begin
        memWord = currentVal;
        if (writeReg)
        begin
          if (be0) memWord[7:0]   =slavehwdata_in[7:0]  ;
          if (be1) memWord[15:8]  =slavehwdata_in[15:8] ;
          if (be2) memWord[23:16] =slavehwdata_in[23:16];                        
          if (be3) memWord[31:24] =slavehwdata_in[31:24];
          
          if (bankA) memMapA[wordA] = memWord;
          if (bankB) memMapB[wordB] = memWord;
          if (bankC) memMapC[wordC] = memWord;
          if (bankD) memMapD[wordD] = memWord;
          if (bankE) memMapE[wordE] = memWord;
          if (bankF) memMapF[wordF] = memWord;
        end
        if (output_file)  
        $fdisplay(output_file,
        "SLAVE:                 addr=[%h] %s data=[%h]                          %s",
          addrReg,
          writeReg ? "WRITE" : "READ",
          writeReg ? slavehwdata_in : slavehrdata_out ,
          sizeReg==`H_BYTE ? "BYTE" : 
                      ( sizeReg==`H_HWORD ? "HALF WORD" : "WORD" ) );
        else 
        $display(
        "SLAVE:                 addr=[%h] %s data=[%h]                          %s",
          addrReg,
          writeReg ? "WRITE" : "READ",
          writeReg ? slavehwdata_in : slavehrdata_out ,
          sizeReg==`H_BYTE ? "BYTE" : 
                      ( sizeReg==`H_HWORD ? "HALF WORD" : "WORD" ) );

      end
  end





  /////////////////////////////////////////////////////////////////////////////////////////////////
  // Master Port transactor
  /////////////////////////////////////////////////////////////////////////////////////////////////

  // timing data - setup and holds
  ////////////////////////////////
  wire          masterhclk_in;
  wire          masterhready_in, masterhgrant_in;
  wire   [31:0] masterhrdata_in;
  wire    [1:0] masterhresp_in;
  wire          masterhwrite_out, masterhlock_out, masterhbusreq_out;
  wire   [31:0] masterhaddr_out, masterhwdata_out;
  wire    [1:0] masterhtrans_out, masterhsize_out;
  wire    [2:0] masterhburst_out;

  specify
      $setuphold(posedge masterhclk, masterhready , 0, 0);
      $setuphold(posedge masterhclk, masterhgrant , 0, 0);
      $setuphold(posedge masterhclk, masterhrdata[0]  , 0, 0);
      $setuphold(posedge masterhclk, masterhrdata[1]  , 0, 0);
      $setuphold(posedge masterhclk, masterhrdata[2]  , 0, 0);
      $setuphold(posedge masterhclk, masterhrdata[3]  , 0, 0);
      $setuphold(posedge masterhclk, masterhrdata[4]  , 0, 0);
      $setuphold(posedge masterhclk, masterhrdata[5]  , 0, 0);
      $setuphold(posedge masterhclk, masterhrdata[6]  , 0, 0);
      $setuphold(posedge masterhclk, masterhrdata[7]  , 0, 0);
      $setuphold(posedge masterhclk, masterhrdata[8]  , 0, 0);
      $setuphold(posedge masterhclk, masterhrdata[9]  , 0, 0);
      $setuphold(posedge masterhclk, masterhrdata[10] , 0, 0);
      $setuphold(posedge masterhclk, masterhrdata[11] , 0, 0);
      $setuphold(posedge masterhclk, masterhrdata[12] , 0, 0);
      $setuphold(posedge masterhclk, masterhrdata[13] , 0, 0);
      $setuphold(posedge masterhclk, masterhrdata[14] , 0, 0);
      $setuphold(posedge masterhclk, masterhrdata[15] , 0, 0);
      $setuphold(posedge masterhclk, masterhrdata[16] , 0, 0);
      $setuphold(posedge masterhclk, masterhrdata[17] , 0, 0);
      $setuphold(posedge masterhclk, masterhrdata[18] , 0, 0);
      $setuphold(posedge masterhclk, masterhrdata[19] , 0, 0);
      $setuphold(posedge masterhclk, masterhrdata[20] , 0, 0);
      $setuphold(posedge masterhclk, masterhrdata[21] , 0, 0);
      $setuphold(posedge masterhclk, masterhrdata[22] , 0, 0);
      $setuphold(posedge masterhclk, masterhrdata[23] , 0, 0);
      $setuphold(posedge masterhclk, masterhrdata[24] , 0, 0);
      $setuphold(posedge masterhclk, masterhrdata[25] , 0, 0);
      $setuphold(posedge masterhclk, masterhrdata[26] , 0, 0);
      $setuphold(posedge masterhclk, masterhrdata[27] , 0, 0);
      $setuphold(posedge masterhclk, masterhrdata[28] , 0, 0);
      $setuphold(posedge masterhclk, masterhrdata[29] , 0, 0);
      $setuphold(posedge masterhclk, masterhrdata[30] , 0, 0);
      $setuphold(posedge masterhclk, masterhrdata[31] , 0, 0);
      $setuphold(posedge masterhclk, masterhresp[0]  , 0, 0);
      $setuphold(posedge masterhclk, masterhresp[1]  , 0, 0);

      (posedge masterhclk => (masterhwrite     +: masterhwrite_out   )) = (0,0);
      (posedge masterhclk => (masterhlock      +: masterhlock_out    )) = (0,0);
      (posedge masterhclk => (masterhbusreq    +: masterhbusreq_out  )) = (0,0);

      (posedge masterhclk => (masterhtrans[1]  +: masterhtrans_out[1])) = (0,0);
      (posedge masterhclk => (masterhtrans[0]  +: masterhtrans_out[0])) = (0,0);

      (posedge masterhclk => (masterhsize[1]   +: masterhsize_out[1] )) = (0,0);
      (posedge masterhclk => (masterhsize[0]   +: masterhsize_out[0] )) = (0,0);

      (posedge masterhclk => (masterhburst[2]  +: masterhburst_out[2])) = (0,0);
      (posedge masterhclk => (masterhburst[1]  +: masterhburst_out[1])) = (0,0);
      (posedge masterhclk => (masterhburst[0]  +: masterhburst_out[0])) = (0,0);

      (posedge masterhclk => (masterhaddr[31]  +: masterhaddr_out[31])) = (0,0);
      (posedge masterhclk => (masterhaddr[30]  +: masterhaddr_out[30])) = (0,0);
      (posedge masterhclk => (masterhaddr[29]  +: masterhaddr_out[29])) = (0,0);
      (posedge masterhclk => (masterhaddr[28]  +: masterhaddr_out[28])) = (0,0);
      (posedge masterhclk => (masterhaddr[27]  +: masterhaddr_out[27])) = (0,0);
      (posedge masterhclk => (masterhaddr[26]  +: masterhaddr_out[26])) = (0,0);
      (posedge masterhclk => (masterhaddr[25]  +: masterhaddr_out[25])) = (0,0);
      (posedge masterhclk => (masterhaddr[24]  +: masterhaddr_out[24])) = (0,0);
      (posedge masterhclk => (masterhaddr[23]  +: masterhaddr_out[23])) = (0,0);
      (posedge masterhclk => (masterhaddr[22]  +: masterhaddr_out[22])) = (0,0);
      (posedge masterhclk => (masterhaddr[21]  +: masterhaddr_out[21])) = (0,0);
      (posedge masterhclk => (masterhaddr[20]  +: masterhaddr_out[20])) = (0,0);
      (posedge masterhclk => (masterhaddr[19]  +: masterhaddr_out[19])) = (0,0);
      (posedge masterhclk => (masterhaddr[18]  +: masterhaddr_out[18])) = (0,0);
      (posedge masterhclk => (masterhaddr[17]  +: masterhaddr_out[17])) = (0,0);
      (posedge masterhclk => (masterhaddr[16]  +: masterhaddr_out[16])) = (0,0);
      (posedge masterhclk => (masterhaddr[15]  +: masterhaddr_out[15])) = (0,0);
      (posedge masterhclk => (masterhaddr[14]  +: masterhaddr_out[14])) = (0,0);
      (posedge masterhclk => (masterhaddr[13]  +: masterhaddr_out[13])) = (0,0);
      (posedge masterhclk => (masterhaddr[12]  +: masterhaddr_out[12])) = (0,0);
      (posedge masterhclk => (masterhaddr[11]  +: masterhaddr_out[11])) = (0,0);
      (posedge masterhclk => (masterhaddr[10]  +: masterhaddr_out[10])) = (0,0);
      (posedge masterhclk => (masterhaddr[9]   +: masterhaddr_out[9] )) = (0,0);
      (posedge masterhclk => (masterhaddr[8]   +: masterhaddr_out[8] )) = (0,0);
      (posedge masterhclk => (masterhaddr[7]   +: masterhaddr_out[7] )) = (0,0);
      (posedge masterhclk => (masterhaddr[6]   +: masterhaddr_out[6] )) = (0,0);
      (posedge masterhclk => (masterhaddr[5]   +: masterhaddr_out[5] )) = (0,0);
      (posedge masterhclk => (masterhaddr[4]   +: masterhaddr_out[4] )) = (0,0);
      (posedge masterhclk => (masterhaddr[3]   +: masterhaddr_out[3] )) = (0,0);
      (posedge masterhclk => (masterhaddr[2]   +: masterhaddr_out[2] )) = (0,0);
      (posedge masterhclk => (masterhaddr[1]   +: masterhaddr_out[1] )) = (0,0);
      (posedge masterhclk => (masterhaddr[0]   +: masterhaddr_out[0] )) = (0,0);
  
      (posedge masterhclk => (masterhwdata[31] +: masterhwdata_out[31])) = (0,0);
      (posedge masterhclk => (masterhwdata[30] +: masterhwdata_out[30])) = (0,0);
      (posedge masterhclk => (masterhwdata[29] +: masterhwdata_out[29])) = (0,0);
      (posedge masterhclk => (masterhwdata[28] +: masterhwdata_out[28])) = (0,0);
      (posedge masterhclk => (masterhwdata[27] +: masterhwdata_out[27])) = (0,0);
      (posedge masterhclk => (masterhwdata[26] +: masterhwdata_out[26])) = (0,0);
      (posedge masterhclk => (masterhwdata[25] +: masterhwdata_out[25])) = (0,0);
      (posedge masterhclk => (masterhwdata[24] +: masterhwdata_out[24])) = (0,0);
      (posedge masterhclk => (masterhwdata[23] +: masterhwdata_out[23])) = (0,0);
      (posedge masterhclk => (masterhwdata[22] +: masterhwdata_out[22])) = (0,0);
      (posedge masterhclk => (masterhwdata[21] +: masterhwdata_out[21])) = (0,0);
      (posedge masterhclk => (masterhwdata[20] +: masterhwdata_out[20])) = (0,0);
      (posedge masterhclk => (masterhwdata[19] +: masterhwdata_out[19])) = (0,0);
      (posedge masterhclk => (masterhwdata[18] +: masterhwdata_out[18])) = (0,0);
      (posedge masterhclk => (masterhwdata[17] +: masterhwdata_out[17])) = (0,0);
      (posedge masterhclk => (masterhwdata[16] +: masterhwdata_out[16])) = (0,0);
      (posedge masterhclk => (masterhwdata[15] +: masterhwdata_out[15])) = (0,0);
      (posedge masterhclk => (masterhwdata[14] +: masterhwdata_out[14])) = (0,0);
      (posedge masterhclk => (masterhwdata[13] +: masterhwdata_out[13])) = (0,0);
      (posedge masterhclk => (masterhwdata[12] +: masterhwdata_out[12])) = (0,0);
      (posedge masterhclk => (masterhwdata[11] +: masterhwdata_out[11])) = (0,0);
      (posedge masterhclk => (masterhwdata[10] +: masterhwdata_out[10])) = (0,0);
      (posedge masterhclk => (masterhwdata[9]  +: masterhwdata_out[9] )) = (0,0);
      (posedge masterhclk => (masterhwdata[8]  +: masterhwdata_out[8] )) = (0,0);
      (posedge masterhclk => (masterhwdata[7]  +: masterhwdata_out[7] )) = (0,0);
      (posedge masterhclk => (masterhwdata[6]  +: masterhwdata_out[6] )) = (0,0);
      (posedge masterhclk => (masterhwdata[5]  +: masterhwdata_out[5] )) = (0,0);
      (posedge masterhclk => (masterhwdata[4]  +: masterhwdata_out[4] )) = (0,0);
      (posedge masterhclk => (masterhwdata[3]  +: masterhwdata_out[3] )) = (0,0);
      (posedge masterhclk => (masterhwdata[2]  +: masterhwdata_out[2] )) = (0,0);
      (posedge masterhclk => (masterhwdata[1]  +: masterhwdata_out[1] )) = (0,0);
      (posedge masterhclk => (masterhwdata[0]  +: masterhwdata_out[0] )) = (0,0);
  endspecify

  // buffer inputs 

  buf(masterhclk_in  , masterhclk  );
  buf(masterhready_in, masterhready);
  buf(masterhgrant_in, masterhgrant);

  buf(masterhrdata_in[31], masterhrdata[31]);
  buf(masterhrdata_in[30], masterhrdata[30]);
  buf(masterhrdata_in[29], masterhrdata[29]);
  buf(masterhrdata_in[28], masterhrdata[28]);
  buf(masterhrdata_in[27], masterhrdata[27]);
  buf(masterhrdata_in[26], masterhrdata[26]);
  buf(masterhrdata_in[25], masterhrdata[25]);
  buf(masterhrdata_in[24], masterhrdata[24]);
  buf(masterhrdata_in[23], masterhrdata[23]);
  buf(masterhrdata_in[22], masterhrdata[22]);
  buf(masterhrdata_in[21], masterhrdata[21]);
  buf(masterhrdata_in[20], masterhrdata[20]);
  buf(masterhrdata_in[19], masterhrdata[19]);
  buf(masterhrdata_in[18], masterhrdata[18]);
  buf(masterhrdata_in[17], masterhrdata[17]);
  buf(masterhrdata_in[16], masterhrdata[16]);
  buf(masterhrdata_in[15], masterhrdata[15]);
  buf(masterhrdata_in[14], masterhrdata[14]);
  buf(masterhrdata_in[13], masterhrdata[13]);
  buf(masterhrdata_in[12], masterhrdata[12]);
  buf(masterhrdata_in[11], masterhrdata[11]);
  buf(masterhrdata_in[10], masterhrdata[10]);
  buf(masterhrdata_in[9] , masterhrdata[9] );
  buf(masterhrdata_in[8] , masterhrdata[8] );
  buf(masterhrdata_in[7] , masterhrdata[7] );
  buf(masterhrdata_in[6] , masterhrdata[6] );
  buf(masterhrdata_in[5] , masterhrdata[5] );
  buf(masterhrdata_in[4] , masterhrdata[4] );
  buf(masterhrdata_in[3] , masterhrdata[3] );
  buf(masterhrdata_in[2] , masterhrdata[2] );
  buf(masterhrdata_in[1] , masterhrdata[1] );
  buf(masterhrdata_in[0] , masterhrdata[0] );

  buf(masterhresp_in[1]  , masterhresp[1]  );
  buf(masterhresp_in[0]  , masterhresp[0]  );

  // buffer outputs 

  buf(masterhwrite     , masterhwrite_out   );
  buf(masterhlock      , masterhlock_out    );
  buf(masterhbusreq    , masterhbusreq_out  );

  buf(masterhtrans[1]  , masterhtrans_out[1]);
  buf(masterhtrans[0]  , masterhtrans_out[0]);

  buf(masterhsize[1]   , masterhsize_out[1] );
  buf(masterhsize[0]   , masterhsize_out[0] );

  buf(masterhburst[2]  , masterhburst_out[2]);
  buf(masterhburst[1]  , masterhburst_out[1]);
  buf(masterhburst[0]  , masterhburst_out[0]);

  buf(masterhaddr[31]  , masterhaddr_out[31]);
  buf(masterhaddr[30]  , masterhaddr_out[30]);
  buf(masterhaddr[29]  , masterhaddr_out[29]);
  buf(masterhaddr[28]  , masterhaddr_out[28]);
  buf(masterhaddr[27]  , masterhaddr_out[27]);
  buf(masterhaddr[26]  , masterhaddr_out[26]);
  buf(masterhaddr[25]  , masterhaddr_out[25]);
  buf(masterhaddr[24]  , masterhaddr_out[24]);
  buf(masterhaddr[23]  , masterhaddr_out[23]);
  buf(masterhaddr[22]  , masterhaddr_out[22]);
  buf(masterhaddr[21]  , masterhaddr_out[21]);
  buf(masterhaddr[20]  , masterhaddr_out[20]);
  buf(masterhaddr[19]  , masterhaddr_out[19]);
  buf(masterhaddr[18]  , masterhaddr_out[18]);
  buf(masterhaddr[17]  , masterhaddr_out[17]);
  buf(masterhaddr[16]  , masterhaddr_out[16]);
  buf(masterhaddr[15]  , masterhaddr_out[15]);
  buf(masterhaddr[14]  , masterhaddr_out[14]);
  buf(masterhaddr[13]  , masterhaddr_out[13]);
  buf(masterhaddr[12]  , masterhaddr_out[12]);
  buf(masterhaddr[11]  , masterhaddr_out[11]);
  buf(masterhaddr[10]  , masterhaddr_out[10]);
  buf(masterhaddr[9]   , masterhaddr_out[9] );
  buf(masterhaddr[8]   , masterhaddr_out[8] );
  buf(masterhaddr[7]   , masterhaddr_out[7] );
  buf(masterhaddr[6]   , masterhaddr_out[6] );
  buf(masterhaddr[5]   , masterhaddr_out[5] );
  buf(masterhaddr[4]   , masterhaddr_out[4] );
  buf(masterhaddr[3]   , masterhaddr_out[3] );
  buf(masterhaddr[2]   , masterhaddr_out[2] );
  buf(masterhaddr[1]   , masterhaddr_out[1] );
  buf(masterhaddr[0]   , masterhaddr_out[0] );
  
  buf(masterhwdata[31] , masterhwdata_out[31]);
  buf(masterhwdata[30] , masterhwdata_out[30]);
  buf(masterhwdata[29] , masterhwdata_out[29]);
  buf(masterhwdata[28] , masterhwdata_out[28]);
  buf(masterhwdata[27] , masterhwdata_out[27]);
  buf(masterhwdata[26] , masterhwdata_out[26]);
  buf(masterhwdata[25] , masterhwdata_out[25]);
  buf(masterhwdata[24] , masterhwdata_out[24]);
  buf(masterhwdata[23] , masterhwdata_out[23]);
  buf(masterhwdata[22] , masterhwdata_out[22]);
  buf(masterhwdata[21] , masterhwdata_out[21]);
  buf(masterhwdata[20] , masterhwdata_out[20]);
  buf(masterhwdata[19] , masterhwdata_out[19]);
  buf(masterhwdata[18] , masterhwdata_out[18]);
  buf(masterhwdata[17] , masterhwdata_out[17]);
  buf(masterhwdata[16] , masterhwdata_out[16]);
  buf(masterhwdata[15] , masterhwdata_out[15]);
  buf(masterhwdata[14] , masterhwdata_out[14]);
  buf(masterhwdata[13] , masterhwdata_out[13]);
  buf(masterhwdata[12] , masterhwdata_out[12]);
  buf(masterhwdata[11] , masterhwdata_out[11]);
  buf(masterhwdata[10] , masterhwdata_out[10]);
  buf(masterhwdata[9]  , masterhwdata_out[9] );
  buf(masterhwdata[8]  , masterhwdata_out[8] );
  buf(masterhwdata[7]  , masterhwdata_out[7] );
  buf(masterhwdata[6]  , masterhwdata_out[6] );
  buf(masterhwdata[5]  , masterhwdata_out[5] );
  buf(masterhwdata[4]  , masterhwdata_out[4] );
  buf(masterhwdata[3]  , masterhwdata_out[3] );
  buf(masterhwdata[2]  , masterhwdata_out[2] );
  buf(masterhwdata[1]  , masterhwdata_out[1] );
  buf(masterhwdata[0]  , masterhwdata_out[0] );


  /////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////

  // Transaction Record Format
  // 255..254 spare
  // 253..252 response
  // 251..220 read data
  //      219 go busy 
  // 218..217 spare
  // 216..208 number of beats in sequential transaction
  // 207..176 start address of transaction
  // 175..144 expected data
  // 143..128 transaction number
  // //----------------------------------- following field read from command file
  // 127..112 spare
  // 111..109 spare
  //      108 bus command (0 => inactive)
  // 107.. 76 address
  //  75.. 73 spare
  //       72 write
  //  71.. 40 write data / expected read data
  //  39.. 37 spare
  //       36 lock (not implemented)
  //  35.. 33 spare
  //       32 check expected data (not implemented)
  //  31.. 30 spare
  //  29.. 28 transaction type
  //  27.. 23 spare
  //  21.. 20 burst type
  //  19.. 18 spare
  //  17.. 16 size
  //  15.. 00 repeat count

  // register outputs
  reg [31:0] masterhaddr_out_r;
  reg [31:0] masterhwdata_out_r;
  reg  [2:0] masterhburst_out_r;
  reg  [1:0] masterhtrans_out_r;
  reg        masterhwrite_out_r;
  
  assign masterhaddr_out  = masterhaddr_out_r;
  assign masterhwdata_out = masterhwdata_out_r;
  assign masterhburst_out = masterhburst_out_r;
  assign masterhtrans_out = masterhtrans_out_r;
  assign masterhwrite_out = masterhwrite_out_r;
  
  reg [2:0] masterhsize_outl;                // the transactor implements the full 3 bit size
  assign masterhsize_out=masterhsize_outl[1:0];    // field but upCore only uses 2


  // ////////////////////////////////////////////////////////////////////////////////////////////
  // 
  reg [128:0] transactions[1:65535];        // space for NUMTRANS transactions
  reg [128:0] tmp_transaction;
  reg   [8:0] tmp_beats;
  
  // Transaction records
  reg [255:0] n_trans;            // next
  reg [255:0] c_trans;            // control / address phase
  reg [255:0] d_trans;            // data phase
  reg [255:0] retry_trans;        // retrying
  reg [255:0] r_trans;            // reporting
  
  reg [255:0] i_trans;            // IDLE Transaction
  
  reg [15:0]  trans_num;          // the current control phase transaction
  

/*//--------------------------------------------------------------------------
 Control signals for master transactor
//--------------------------------------------------------------------------*/
  reg         reset;    
  wire        start                 = n_trans[108];
  wire        stop                  = 1'b0;         
  wire        continue_after_error  = 1'b1;         
  wire        generate_data         = 1'b0;         
  wire [1:0]  insert_busy           = 2'b00;         
  wire        go_busy               = n_trans[219];     
  wire [8:0]  beats                 = n_trans[216:208];        // 511 beats max
  wire [2:0]  burst                 = n_trans[23:20];
  wire [2:0]  size                  = n_trans[18:16];
  wire        write                 = n_trans[72];
  wire [31:0] start_address         = n_trans[207:176];
  wire [31:0] data                  = n_trans[71:40];        


/*//--------------------------------------------------------------------------
Transactor state and responses
//--------------------------------------------------------------------------*/
  reg [2:0]     original_burst;
  reg           masterhgrant_in_r;
  reg [1:0]     busy_states;
  reg [1:0]     busy_counter;
  reg [9:0]     init_wrap_mask, wrap_mask;
  reg [7:0]     masterhaddr_out_r_inc, init_wrap_boundary_bit;
  reg [10:0]    init_next_masterhaddr_out_r, wrap_boundary_bit;
  reg [9:0]     next_masterhaddr_out_r;
  wire          break_wrap;

  reg           address_bus_owned, data_bus_owned;
  reg           add_go, data_go;
  reg           reading, writing;
  reg           first_beat, need_retry, wrap, replay_wrap;
  reg           new_grant;
  wire          first_masterhtrans_out_r;
  wire          addr_ack;
  wire          data_ack;

/*//--------------------------------------------------------------------------
 Initialisation 

 Load the transaction file from disk and set up the first transaction record.
//--------------------------------------------------------------------------*/
  initial
  begin
    i_trans         ={256{1'b0}};    // set up a null transaction record
    i_trans[143:128]=16'hFFFF; 
    i_trans[29:28]  =`H_IDLE;
          
    d_trans=i_trans;                // fill pipe with null's
    c_trans=i_trans;
    r_trans=i_trans;
                                  // initialise the transactions database
    tmp_transaction={128{1'b0}};
    for (trans_num=1;trans_num<65535;trans_num=trans_num+1)
    begin
      transactions[trans_num]=tmp_transaction;
    end
    $readmemh("mastercommands.dat", transactions);        
      
    trans_num=16'h0000;        

    n_trans=i_trans;
    n_trans[2]=1'b1; // repeat 4

        reset=0;                   // reset the transactor on start
    #10 reset=1;
    #20 reset=0; 

  end
  


/*//--------------------------------------------------------------------------
  Report completed transactions

  We could mask and shift the received data for HALFWORD and BYTE
  transactions but we won't.
//--------------------------------------------------------------------------*/
         // received data
  /****
  wire [31:0] r_r_data = r_trans[72]==1'b1 ? r_trans[71:40] : r_trans[251:220];
  wire [31:0] e_r_data = r_trans[175:144];
  wire [31:0] mr_r_data, me_r_data; // byte lane masked recovered and expected

  mr_r_data = r_trans[17:16] == `H_WORD  ? r_r_data :
             (r_trans[17:16] == `H_HWORD ? 
             { 16'h0000, (r_trans[77]==1'b1 ? r_r_data[31:16] : r_r_data[15:0]) } :
             // byte
             { 24'h000000, (r_trans[77:76]==2'b00 ? r_r_data[7:0] :
                            r_trans[77:76]==2'b01 ? r_r_data[15:8] :
                            r_trans[77:76]==2'b10 ? r_r_data[23:16] :
                                                    r_r_data[31:24]) } );

  r_rdata  =  r_trans[17:16] == `H_WORD  ? r_e_data :
             (r_trans[17:16] == `H_HWORD ? 
             { 16'h0000, (r_trans[77]==1'b1 ? r_e_data[31:16] : r_e_data[15:0]) } :
             // byte
             { 24'h000000, (r_trans[77:76]==2'b00 ? r_e_data[7:0] :
                            r_trans[77:76]==2'b01 ? r_e_data[15:8] :
                            r_trans[77:76]==2'b10 ? r_e_data[23:16] :
                                                    r_e_data[31:24]) } );
  ****/
  always @(posedge masterhclk_in)
  begin
   if (r_trans[108]==1'b1) // r_trans contains a valid transaction
   begin
 
     if (output_file)  
      $fdisplay(output_file,
        "MASTER: trans=[%d]  addr=[%h] %s data=[%h]   expected=[%h]    %s %s",
        r_trans[143:128],
        r_trans[107:76],
        r_trans[72]==1'b1 ? "WRITE" : "READ",
        r_trans[72]==1'b1 ? r_trans[71:40] : r_trans[251:220],
        r_trans[175:144],
        r_trans[17:16]==`H_BYTE ? "BYTE" : 
                        ( r_trans[17:16]==`H_HWORD ? "HALF WORD" : "WORD" ),
        r_trans[253:252]==`H_OKAY ? "OKAY" : "ERROR" );
     else
      $display(
        "MASTER: trans=[%d]  addr=[%h] %s data=[%h]   expected=[%h]    %s %s",
        r_trans[143:128],
        r_trans[107:76],
        r_trans[72]==1'b1 ? "WRITE" : "READ",
        r_trans[72]==1'b1 ? r_trans[71:40] : r_trans[251:220],
        r_trans[175:144],
        r_trans[17:16]==`H_BYTE ? "BYTE" : 
                        ( r_trans[17:16]==`H_HWORD ? "HALF WORD" : "WORD" ),
        r_trans[253:252]==`H_OKAY ? "OKAY" : "ERROR" );
    end
  end    



  
  
/*//--------------------------------------------------------------------------
Get Next Transaction
//--------------------------------------------------------------------------*/
  reg [216:208] tmp_repeats;
  always 
  begin

      while ( trans_num<16'hFFFF)
      begin    
  
        if (n_trans[15:0]==16'h0000)
        begin
                                              // get the next record
          trans_num = trans_num+1;                     
          tmp_transaction  = transactions[trans_num];
          n_trans[175:144]<= tmp_transaction[71:40];  // expected data
          n_trans[143:128]<= trans_num;
          n_trans[127:0]  <= tmp_transaction;         
    
    
                                           // check for a BUSY
          n_trans[219]    <= tmp_transaction[29:28]==`H_BUSY ? 1'b1 : 1'b0;
    
                      // update the start address
          if (tmp_transaction[29:28]!=`H_SEQ&&tmp_transaction[29:28]!=`H_BUSY)
          begin
            n_trans[207:176] <= tmp_transaction[107:76]; // start address
          end
    
    
                      // compute the number of beats in burst
          if (tmp_transaction[23:20]!=`H_SINGLE && tmp_transaction[29:28]==`H_NONSEQ)
          begin
            tmp_beats=9'b0_0000_0001;
            tmp_repeats[216:208]=9'b0_0000_0001;
            tmp_transaction=transactions[trans_num+tmp_beats];
            while (tmp_transaction[29:28]==`H_SEQ||tmp_transaction[29:28]==`H_BUSY)
            begin
              tmp_repeats[216:208]=tmp_repeats[216:208]+tmp_transaction[15:0]+1;
              tmp_beats=tmp_beats+1;
              tmp_transaction=transactions[trans_num+tmp_beats];
             end
            n_trans[216:208]<=tmp_repeats[216:208];
          end
    

        end        
        else
        begin
          n_trans[15:0]<=n_trans[15:0]-1;
        end // i

                              // wait for the current transaction to be accepted
        @(posedge masterhclk_in);
        while (~(addr_ack|data_ack) && n_trans[108])
          @(posedge masterhclk_in);

      end // while transactions in buffer

      if (output_file) $fclose(output_file) ;
      $finish(2);
  end
  
    



/*//--------------------------------------------------------------------------
 Compute burst length
 
 add_go_r prevents a newly loaded length being decremented by the last data
 beat of the previous transaction.
//--------------------------------------------------------------------------*/
  reg [8:0] length;
  reg         add_go_r;
  always @(posedge masterhclk_in)
    if (masterhready_in)
      add_go_r <= add_go;

  always @(posedge masterhclk_in or posedge reset)
    if (reset)
      length <= 5'h0;
    else if (add_go)
      case (burst)
    `H_SINGLE:    length <= 9'h1;
    `H_INCR:    length <= beats;
    `H_WRAP4,
    `H_INCR4:    length <= 9'h4;
    `H_WRAP8,
    `H_INCR8:    length <= 9'h8;
    `H_WRAP16,
    `H_INCR16:    length <= 9'h10;
      endcase
    else if ((reading | writing) & masterhready_in & ~add_go_r & ((masterhresp_in == `H_OKAY) | (masterhresp_in == `H_ERROR)))
      length <= length - (|length);

  reg [8:0] address_length;
  always @(posedge masterhclk_in or posedge reset)
    if (reset)
      address_length <= 5'h0;
    else if (add_go)
      case (burst)
    `H_SINGLE:    address_length <= 9'h1;
    `H_INCR:    address_length <= beats;
    `H_WRAP4,
    `H_INCR4:    address_length <= 9'h4;
    `H_WRAP8,
    `H_INCR8:    address_length <= 9'h8;
    `H_WRAP16,
    `H_INCR16:    address_length <= 9'h10;
      endcase
    else if (data_bus_owned & ~masterhready_in & ((masterhresp_in == `H_RETRY) | (masterhresp_in == `H_SPLIT)))
      address_length <= address_length + 9'h1;
    else if (address_bus_owned & masterhready_in & ~(|busy_states) & (masterhtrans_out_r != `H_IDLE))
      address_length <= address_length - (|address_length);
    else if (address_bus_owned & masterhready_in & (|busy_states) & (masterhtrans_out_r == `H_BUSY) & ~(|busy_counter))
      address_length <= address_length - (|address_length);

/*//--------------------------------------------------------------------------
 Bus request state machine
 
 Bus request machine follows the principle that the arbiter will generally
 only re-assign bus grants at the end of a burst transaction. For defined
 bursts masterhbusreq_out is removed as soon as we masterhave started the transaction.
 Undefined (INCR) bursts will masterhold masterhbusreq_out asserted until the last beat of the
 transaction.
 
 Locked transactions must always assert masterhlock_out for at least one cycle before
 the address to be locked to allow the arbiter to see the lock. In practice,
 this means inserting an idle cycle. 
 
 Have to be careful using burst and beats from the control word. As soon as
 the master address phase masterhas finished and the addr_ack is asserted the
 testbench can change the control word. So don't use them after the initial
 request. Use the ahb outputs instead which will tell us what sort of
 transaction we're doing.
//--------------------------------------------------------------------------*/
  reg [2:0] req_state;
  parameter req_idle = 3'b000,
        req_first = 3'b001,
        req_wait = 3'b101,
        req_masterhold = 3'b011,
        req_using = 3'b010,
        req_again = 3'b111;
  assign masterhbusreq_out = start
         | (req_state == req_first)
         | (req_state == req_wait)
         | (req_state == req_masterhold)
         | (req_state == req_again);

  wire single_beat = (burst == `H_SINGLE)
           | (burst == `H_INCR) & (beats == 9'b1);

  reg  single_beat_r;
  always @(posedge masterhclk_in)
    if (addr_ack)
      // save single_beat for use after it may masterhave changed
      single_beat_r = single_beat;

  wire last_beat = address_bus_owned & masterhready_in & (address_length <= 9'b1);
  wire retry = data_bus_owned & ((masterhresp_in == `H_RETRY) | (masterhresp_in == `H_SPLIT));
  wire error = data_bus_owned & masterhready_in & (masterhresp_in == `H_ERROR);

/*//--------------------------------------------------------------------------
 Bus request machine masterhas five states:
 req_idle: masterhbusreq_out negated. Wmasterhen we want to do something we jump to req_first.
    The last beat may get a retry response in which case we jump to
    req_again.
 req_first: masterhbusreq_out asserted. Wait masterhere for masterhgrant_in and until the transaction
    starts. If granted and it's an undefined and not a single beat then
    jump to req_masterhold. Else if it's a single beat jump to req_idle.
    Otherwise jump to req_using.
 req_masterhold: masterhbusreq_out asserted. Hold masterhbusreq_out asserted until last beat of an
    undefined. If there's a new request then we jump to req_first, 
    otherwise back to req_idle. If we lose masterhgrant_in in this state then we
    just stay masterhere with masterhbusreq_out asserted until the transaction can be
    finished. Also masterhold in this state if retry is asserted to reduce the
    chance of releaseing the bus and masterhaving to re-request it to complete
    a transaction.
 req_using: masterhbusreq_out negated. Wait masterhere for last beat of defined length
    transaction. If there's a new request then we jump to req_first, 
    otherwise back to req_idle. If a posted write is errored before the
    last beat or a transaction is retried or we lose masterhgrant_in then we jump
    to req_again.
 req_again: masterhbusreq_out asserted for completion of transaction interrupted by loss
    of masterhgrant_in. Wait masterhere for masterhgrant_in and until the transaction starts then
    jump to req_using if first_beat    is asserted or req_masterhold if not.
    *** We may see a new address toggle whilst in this state.
//--------------------------------------------------------------------------*/
  always @(posedge masterhclk_in or posedge reset)
    if (reset)
      req_state <= req_idle;
    else
      case (req_state)
    req_idle:

      if (retry)
        req_state <= req_again;
      else if (start)
        req_state <= req_first;

      else
        req_state <= req_idle;

    req_first:
      if (retry)
        req_state <= req_again;
      else if (~masterhgrant_in & ~((masterhtrans_out_r == `H_NONSEQ) & masterhready_in))
        req_state <= req_first;
      else if ((masterhtrans_out_r == `H_NONSEQ) & masterhready_in)
      begin
        if (add_go)
          req_state <= req_first;
        else if ((burst == `H_INCR) & ~single_beat)
          req_state <= req_masterhold;
        else if (single_beat)
          req_state <= req_idle;
        else
          req_state <= req_using;
      end
      else
        req_state <= req_wait;

    req_wait:
      if (retry)
        req_state <= req_again;
      else if (~masterhgrant_in & ~((masterhtrans_out_r == `H_NONSEQ) & masterhready_in))
        req_state <= req_first;
      else if (masterhgrant_in & ~((masterhtrans_out_r == `H_NONSEQ) & masterhready_in))
        req_state <= req_wait;
      else if (add_go)
        req_state <= req_first;
      else if ((burst == `H_INCR) & ~single_beat)
        req_state <= req_masterhold;
      else if (single_beat_r)
        req_state <= req_idle;
      else
        req_state <= req_using;

    req_masterhold:
      if (error & ~continue_after_error)
        req_state <= req_idle;
      else if (~masterhgrant_in & (address_length > 9'b1)
          | retry)
        req_state <= req_again;
      else if (last_beat)
      begin
        if (start)
          req_state <= req_first;
        else
          req_state <= req_idle;
      end
      else if (add_go)
        req_state <= req_first;
      else
        req_state <= req_masterhold;
    
    req_using:
      if (error & ~continue_after_error)
        req_state <= req_idle;
      else if (last_beat)
      begin
        if (start)
          req_state <= req_first;
        else
          req_state <= req_idle;
      end
      else if (~masterhgrant_in & (address_length > 9'b1)
           | retry)
        req_state <= req_again;
      else
        req_state <= req_using;

    req_again:
      if (error & ~continue_after_error)
        req_state <= req_idle;
      else if ((~data_bus_owned
           | data_bus_owned & (masterhresp_in == `H_OKAY))
            & address_bus_owned & (masterhtrans_out_r == `H_IDLE) & masterhready_in & ~masterhlock_out)
        req_state <= req_idle;
      else if (~masterhgrant_in & (address_length > 9'b1)
          | ~((masterhtrans_out_r == `H_NONSEQ) & masterhready_in))
        req_state <= req_again;
      else if (last_beat | (masterhburst_out_r == `H_SINGLE)
           | (masterhburst_out_r == `H_INCR) & single_beat_r)
        req_state <= req_idle;
      else if (first_beat)
        req_state <= req_using;
      else
        req_state <= req_masterhold;

    default:    req_state <= req_idle;
      endcase
  
/*//--------------------------------------------------------------------------
 Address acknowledge
 
 Signals when an address masterhas been transferred and a new one may be presented
 for the next transaction.
//--------------------------------------------------------------------------*/
  assign addr_ack = add_go;

/*//--------------------------------------------------------------------------
 Data acknowledge
 
 Signals when an address masterhas been transferred and a new one may be presented
 for the next transaction.
//--------------------------------------------------------------------------*/
  assign data_ack = data_go;

/*//--------------------------------------------------------------------------
 Bus ownership
 
 Data bus ownership follows address by one cycle
//--------------------------------------------------------------------------*/
  always @(posedge masterhclk_in or posedge reset)
    if (reset)
    begin
      address_bus_owned <= 1'b0;
      data_bus_owned <= 1'b0;
    end
    else if (masterhready_in)
    begin
      address_bus_owned <= masterhgrant_in;
      data_bus_owned <= address_bus_owned;
    end

/*//--------------------------------------------------------------------------
 add_go enables the address phase for a new transaction (not the continuation
 of a retried transaction or a transaction during which we lose the bus).
 
 It asserts immediately on address request if we're not actively using the bus
 and not waiting for it to be re-granted to complete a previous transaction,
 the (masterhtrans_out_r == `IDLE) term ensuring it only asserts for one clock.
//--------------------------------------------------------------------------*/
  always @(start or masterhbusreq_out or masterhgrant_in or masterhready_in or reading
       or writing or masterhtrans_out_r or req_state or length or reset)
    if (start & masterhbusreq_out & masterhgrant_in & masterhready_in & ~reading & ~writing
        & (masterhtrans_out_r == `H_IDLE) & (req_state != req_again) & ~reset)
      add_go <= 1'b1;
    else if (start & masterhbusreq_out & masterhgrant_in & masterhready_in & (length < 9'h2) & ~retry
        & (masterhtrans_out_r != `H_BUSY) & (masterhtrans_out_r != `H_NONSEQ) & ~reset)
      add_go <= 1'b1;
    else
      add_go <= 1'b0;


/*//--------------------------------------------------------------------------
 data_go indicates the completion of the data phase for a transaction 

 Like add_go it asserts when the master takes control of the address lines to
 start a transaction.
 It also asserts on all the accepted data beats of a burst except the last.
//--------------------------------------------------------------------------*/
  wire  trans_end = data_bus_owned & (reading | writing) & 
                   masterhready_in & (masterhresp_in == `H_OKAY || masterhresp_in == `H_ERROR);

  always @(start or masterhbusreq_out or masterhgrant_in or masterhready_in or reading
       or writing or masterhtrans_out_r or req_state or length or reset 
       or need_retry or trans_end )
    if (start & masterhbusreq_out & masterhgrant_in & masterhready_in & ~reading & ~writing
        & (masterhtrans_out_r == `H_IDLE) & (req_state != req_again) & ~reset & ~need_retry)
      data_go <= 1'b1;
    else if (start & masterhbusreq_out & masterhgrant_in & masterhready_in & (address_length > 9'h1) & ~retry
         & ~reset & (~need_retry|trans_end))
      data_go <= 1'b1;
    else
      data_go <= 1'b0;


/*//--------------------------------------------------------------------------
 masterhwrite_out_r
 
 Updated on any clock that starts a new transaction
//--------------------------------------------------------------------------*/
  always @(posedge masterhclk_in or posedge reset)
    if (reset)
      masterhwrite_out_r <= 1'b0;
    else if (addr_ack)
      masterhwrite_out_r <= write;
  
/*//--------------------------------------------------------------------------
 Transaction size
 
 Updated on any clock that starts a new transaction
//--------------------------------------------------------------------------*/
  always @(posedge masterhclk_in or posedge reset)
    if (reset)
      masterhsize_outl <= 3'b0;
    else if (addr_ack)
      masterhsize_outl <= size;
  
/*//--------------------------------------------------------------------------
 Busy counter
 
 Insert BUSY states into burst transactions.
 
 Capture control word. Load counter on every active phase and decrement to
 zero.
//--------------------------------------------------------------------------*/
  always @(posedge masterhclk_in or posedge reset)
    if (reset)
      busy_states <= 1'b0;
    else if (addr_ack)
      busy_states <= insert_busy;
  
  always @(posedge masterhclk_in or posedge reset)
    if (reset)
      busy_counter <= 1'b0;
    else if ((masterhtrans_out_r == `H_NONSEQ) | (masterhtrans_out_r == `H_SEQ))
      busy_counter <= busy_states - 1;
    else
      busy_counter <= busy_counter - (|busy_counter);
  
/*//--------------------------------------------------------------------------
 first_masterhtrans_out_r is asserted to enable the first beat of a transaction, which is
 always NONSEQ:
 - The first beat of a new transaction (addr_ack).
 - To restart a transaction that was interrupted by loss of masterhgrant_in if we
   receive a new masterhgrant_in whilst in req_again or req_masterhold states.
 - To restart a transaction after a RETRY response.
 - To restart a transaction after a SPLIT response.
pwd
  - Break an undefined `INCR replay of a retried or split wrapping burst at
   the wrap address boundary.
//--------------------------------------------------------------------------*/
  always @(posedge masterhclk_in)
    masterhgrant_in_r <= masterhgrant_in;

  wire      masterhgrant_in_leading_edge = masterhgrant_in & ~masterhgrant_in_r;
  
  always @(posedge masterhclk_in or posedge reset)
    if (reset)
      new_grant <= 1'b0;
    else if (masterhgrant_in_leading_edge & ~first_masterhtrans_out_r)
      new_grant <= 1'b1;
    else if (first_masterhtrans_out_r | ~masterhgrant_in)
      new_grant <= 1'b0;

  assign first_masterhtrans_out_r = addr_ack
              | (masterhgrant_in_leading_edge | masterhgrant_in & new_grant) & masterhready_in & ~masterhwrite_out_r
              & ((req_state == req_masterhold) | (req_state == req_again))
              | (masterhgrant_in_leading_edge | masterhgrant_in & new_grant) & masterhready_in & masterhwrite_out_r
              & ((req_state == req_masterhold) | (req_state == req_again))
              | data_bus_owned & masterhready_in & (masterhresp_in == `H_RETRY)
              | data_bus_owned & masterhready_in & (masterhresp_in == `H_SPLIT)
              | address_bus_owned & masterhready_in & ~first_beat
            & break_wrap & (length > 9'b1);
  
/*//--------------------------------------------------------------------------
 The only time masterhtrans_out_r changes when masterhready_in is negated is during reset or after
 the first cycle of a two-cyle error response. Otherwise, masterhtrans_out_r can only
 change when masterhgrant_in and masterhready_in are asserted.
 //--------------------------------------------------------------------------*/
  always @(posedge masterhclk_in or posedge reset)
    if (reset)
      masterhtrans_out_r <= `H_IDLE;
    else if (data_bus_owned & ~masterhready_in & (masterhresp_in != `H_OKAY)
        & ~continue_after_error)        // ERROR'ed transactions cancelled
      masterhtrans_out_r <= `H_IDLE;
    else if (data_bus_owned & ~masterhready_in & (masterhresp_in != `H_OKAY) & (masterhresp_in != `H_ERROR)
        & continue_after_error)            // ERROR'ed transactions not cancelled
      masterhtrans_out_r <= `H_IDLE;
    else if (masterhgrant_in & masterhready_in)
      case (masterhtrans_out_r)
    `H_IDLE:
      if (first_masterhtrans_out_r)
        masterhtrans_out_r <= `H_NONSEQ;
      else
        masterhtrans_out_r <= `H_IDLE;
    `H_NONSEQ,`H_SEQ:
      if (first_masterhtrans_out_r)
        masterhtrans_out_r <= `H_NONSEQ;
      else if ((masterhburst_out_r == `H_SINGLE) | (address_length <= 9'h1))
        // Last beat
        masterhtrans_out_r <= `H_IDLE;
      else if (go_busy) // (|busy_states)
        masterhtrans_out_r <= `H_BUSY;
      else
        masterhtrans_out_r <= `H_SEQ;
    
    `H_BUSY:
      if (first_masterhtrans_out_r)
        masterhtrans_out_r <= `H_NONSEQ;
      else if (go_busy)  //(|busy_counter)
        masterhtrans_out_r <= `H_BUSY;
      else
        masterhtrans_out_r <= `H_SEQ;
      endcase
    else if (masterhready_in & ~masterhgrant_in)
      masterhtrans_out_r <= `H_IDLE;
  
/*//--------------------------------------------------------------------------
 One of reading or writing is asserted during any data beat for which we are
 actively using the bus.
//--------------------------------------------------------------------------*/
  always @(posedge masterhclk_in or posedge reset)
    if (reset)
    begin
      reading <= 1'b0;
      writing <= 1'b0;
    end
    else if (masterhready_in)
    begin
      reading <= ~masterhwrite_out_r & address_bus_owned
            & (masterhtrans_out_r != `H_IDLE) & (masterhtrans_out_r != `H_BUSY);
      writing <= masterhwrite_out_r & address_bus_owned
            & (masterhtrans_out_r != `H_IDLE) & (masterhtrans_out_r != `H_BUSY);
    end

/*//--------------------------------------------------------------------------
 Burst size
 
 first_beat is used to keep masterhburst_out_r unchanged when the first beat is to be
 replayed. It alse controls the bus request. A transaction that is split or
 retried on any other beat will be replayed as INCR and masterhbusreq_out must be masterheld
 asserted.
 
 Tmasterhis means that a defined length read that us interrupted mid-burst will
 complete as an undefined INCR and may pre-fetch past the end of the defined
 length (unless, of course, no_prefetch is asserted).
//--------------------------------------------------------------------------*/
  always @(posedge masterhclk_in or posedge reset)
    if (reset)
      first_beat <= 1'b0;
    else if (addr_ack)
      first_beat <= 1'b1;
    else if (data_bus_owned & (reading | writing) & masterhready_in & (masterhresp_in == `H_OKAY))
      first_beat <= 1'b0;

  always @(posedge masterhclk_in or posedge reset)
    if (reset)
      masterhburst_out_r <= 3'b0;
    else if (addr_ack)
      masterhburst_out_r <= burst;
    else if (first_masterhtrans_out_r & ~first_beat)
      masterhburst_out_r <= `H_INCR;

/*//--------------------------------------------------------------------------
 need_retry
//--------------------------------------------------------------------------*/
  always @(posedge masterhclk_in or posedge reset)
    if (reset)
      need_retry <= 1'b0;
    else if (data_bus_owned & ~masterhready_in & ((masterhresp_in == `H_RETRY) | (masterhresp_in == `H_SPLIT)))
      need_retry <= 1'b1;
    else if (data_bus_owned & masterhready_in & (reading | writing)
        & ((masterhresp_in == `H_OKAY) | (masterhresp_in == `H_ERROR)))
      need_retry <= 1'b0;
  
  always @(posedge masterhclk_in or posedge reset)
    if (reset)
      wrap <= 1'b0;
    else if (addr_ack)
      wrap <= (burst == `H_WRAP4) | (burst == `H_WRAP8)
        | (burst == `H_WRAP16);

  always @(posedge masterhclk_in or posedge reset)
    if (reset)
      original_burst <= 3'b0;
    else if (addr_ack)
      original_burst <= burst;

  always @(posedge masterhclk_in or posedge reset)
    if (reset)
      replay_wrap <= 3'b0;
    else if (addr_ack)
      replay_wrap <= 3'b0;
    else if (data_bus_owned & ~masterhready_in & wrap & ((masterhresp_in == `H_RETRY) | (masterhresp_in == `H_SPLIT)))
      replay_wrap <= 3'b1;

/*//--------------------------------------------------------------------------
 Compute wrap mask

 Used to modify next_masterhaddr_out_r during wrapping bursts. First case statement forms
 a mask based on the transfer size. Tmasterhis is then shifted left with '1's
 inserted to form the final mask. E.g. masterhsize_outl == word (3'b010) wrapped at a
 four beat boundary results in wrap_mask set to 10'b0000001111 allowing the
 four lsbs of the address to increment and wrap addressing sixteen bytes in
 total.
//--------------------------------------------------------------------------*/
  always @(masterhsize_outl)
    case (masterhsize_outl)
      3'b000:    init_wrap_mask <= 10'b0;
      3'b001:    init_wrap_mask <= 10'b1;
      3'b010:    init_wrap_mask <= 10'b11;
      3'b011:    init_wrap_mask <= 10'b111;
      3'b100:    init_wrap_mask <= 10'b1111;
      3'b101:    init_wrap_mask <= 10'b11111;
      3'b110:    init_wrap_mask <= 10'b111111;
      3'b111:    init_wrap_mask <= 10'b1111111;
    endcase

  always @(original_burst or init_wrap_mask)
    case (original_burst)
      `H_WRAP4:    wrap_mask <= {init_wrap_mask[7:0], 2'b11};
      `H_WRAP8:    wrap_mask <= {init_wrap_mask[6:0], 3'b111};
      `H_WRAP16:    wrap_mask <= {init_wrap_mask[5:0], 4'b1111};
      default:    wrap_mask <= 10'b0;
    endcase

  always @(masterhsize_outl)
    case (masterhsize_outl)
      3'b000:    init_wrap_boundary_bit <= 8'b1;
      3'b001:    init_wrap_boundary_bit <= 8'b10;
      3'b010:    init_wrap_boundary_bit <= 8'b100;
      3'b011:    init_wrap_boundary_bit <= 8'b1000;
      3'b100:    init_wrap_boundary_bit <= 8'b10000;
      3'b101:    init_wrap_boundary_bit <= 8'b100000;
      3'b110:    init_wrap_boundary_bit <= 8'b1000000;
      3'b111:    init_wrap_boundary_bit <= 8'b10000000;
    endcase

  always @(original_burst or init_wrap_boundary_bit)
    case (original_burst)
      `H_WRAP4:    wrap_boundary_bit <= {init_wrap_boundary_bit, 2'b0};
      `H_WRAP8:    wrap_boundary_bit <= {init_wrap_boundary_bit, 3'b0};
      `H_WRAP16:wrap_boundary_bit <= {init_wrap_boundary_bit[6:0], 4'b0};
      default:    wrap_boundary_bit <= 11'b0;
    endcase

/*//--------------------------------------------------------------------------
 Compute address increment

 Tmasterhis code allows for all possibilities by inferring a 3-to-8 decoder on the
 transfer size. AHB spec is unclear masterhow a burst with a transfer size greater
 than the bus width should be masterhandled.
//--------------------------------------------------------------------------*/
  always @(masterhsize_outl)
  begin
    masterhaddr_out_r_inc <= 10'b0;
    masterhaddr_out_r_inc[masterhsize_outl] <= 1'b1;
  end

/*//--------------------------------------------------------------------------
 Compute next address

 Next address is based on the increment computed from the transfer size, and
 the burst type, which may tell us to wrap. Wrapping is achieved by preserving
 some of the upper bits through use of wrap_mask.

 If beat n is retried, we're already putting out the address for beat n+1 so
 we need to decrement.
//--------------------------------------------------------------------------*/
  always @(data_bus_owned or masterhresp_in or masterhready_in or masterhaddr_out_r or masterhaddr_out_r_inc)
    if (data_bus_owned & ((masterhresp_in == `H_RETRY) | (masterhresp_in == `H_SPLIT)))
      init_next_masterhaddr_out_r <= {1'b0, masterhaddr_out_r[9:0]} - masterhaddr_out_r_inc;
    else
      init_next_masterhaddr_out_r <= {1'b0, masterhaddr_out_r[9:0]} + masterhaddr_out_r_inc;
  
  always @(original_burst or wrap_mask or init_next_masterhaddr_out_r or masterhaddr_out_r)
    if ((original_burst == `H_WRAP4) | (original_burst == `H_WRAP8)
    | (original_burst == `H_WRAP16))
      next_masterhaddr_out_r <= wrap_mask & init_next_masterhaddr_out_r | ~wrap_mask & masterhaddr_out_r;
    else
      next_masterhaddr_out_r <= init_next_masterhaddr_out_r;
  
  assign break_wrap = replay_wrap & ((|(init_next_masterhaddr_out_r & wrap_boundary_bit))
                    ^ (|(masterhaddr_out_r[10:0] & wrap_boundary_bit)));

/*//--------------------------------------------------------------------------
 Address Generation

 AHB address has to track the changing address during bursts. next_masterhaddr_out_r
 computes the next address.
 
 NOTE: It is incumbent upon the command file not to attempt a transaction that
 would cross a 1Kbyte address boundary.
 
 Address is normally updated after each address phase. It is also updated
 during the second cycle of a two cycle retry or split response to rewind the
 address and allow the transaction to be replayed.
//--------------------------------------------------------------------------*/
  always @(posedge masterhclk_in or posedge reset)
    if (reset)
      masterhaddr_out_r <= 32'b0;
    else if (addr_ack)
      masterhaddr_out_r <= start_address;
    else if (data_bus_owned & masterhready_in & ((masterhresp_in == `H_RETRY) | (masterhresp_in == `H_SPLIT)))
      masterhaddr_out_r[9:0] <= next_masterhaddr_out_r;
    else if (address_bus_owned & masterhready_in
        & ((masterhtrans_out_r == `H_NONSEQ) | (masterhtrans_out_r == `H_SEQ)))
      masterhaddr_out_r[9:0] <= next_masterhaddr_out_r;

/*//--------------------------------------------------------------------------
 Write Data 
 
 If generate_data is negated then initial data is taken from data input. If
 generate_data is asserted then data is generated from the address offset to
 match that expected by the checkers.

 The expected data and the transaction number follow the write data.
 
 At the end of a burst data is set to x so we can ensure nothing is relying on
 invalid data.
//--------------------------------------------------------------------------*/

  reg [31:0] masterhwdata_out_r_pipe;
  reg [31:0] masterhwdata_out_r_retry;

  always @(posedge masterhclk_in)
    if (data_bus_owned & ~masterhready_in & (masterhresp_in==`H_RETRY||masterhresp_in==`H_SPLIT))
    begin
      masterhwdata_out_r_retry <= masterhwdata_out_r;
    end
    else if (addr_ack || data_ack)
      masterhwdata_out_r_pipe <= data;

   
  wire [7:0] addr_offset = {masterhaddr_out_r[7:2], 2'b0};
  
  always @(posedge masterhclk_in or posedge reset)
    if (reset)
      masterhwdata_out_r <= {32{1'b0}};
    else if (~address_bus_owned & masterhready_in)
      masterhwdata_out_r <= {32{1'b0}};
    else if (masterhready_in & ~generate_data)
    begin
      if (address_bus_owned & masterhwrite_out_r & need_retry & ~trans_end)
        masterhwdata_out_r <= masterhwdata_out_r_retry;
      else if (address_bus_owned & masterhwrite_out_r & (masterhtrans_out_r == `H_NONSEQ))
        masterhwdata_out_r <= masterhwdata_out_r_pipe;
      else if ((length == 9'b0))
        masterhwdata_out_r <= {32{1'b0}};
      else if (address_bus_owned & masterhwrite_out_r & (masterhtrans_out_r == `H_SEQ))
        masterhwdata_out_r <= masterhwdata_out_r_pipe; 
      else
        masterhwdata_out_r <= {32{1'b0}};
    end
    else if (masterhready_in & generate_data)
    begin
      if (address_bus_owned & masterhwrite_out_r & (masterhtrans_out_r == `H_NONSEQ))
        masterhwdata_out_r <= {addr_offset, addr_offset, addr_offset, addr_offset};
      else if ((length == 9'b0))
        masterhwdata_out_r <= {32{1'b0}};
      else if (address_bus_owned & masterhwrite_out_r & (masterhtrans_out_r == `H_SEQ))
        masterhwdata_out_r <= {addr_offset, addr_offset, addr_offset, addr_offset};
    end

/*//--------------------------------------------------------------------------
 Transaction Details

 The transactor pipeline consists of four stages

 n_trans - the next transaction from the store
 c_trans - the current control / address stage transaction
 d_trans - the data stage transaction
 rTrans - the completed stage for reporting


 c_trans is updated from n_trans when a new transaction begins or from d_trans in
 the case of split/retry
//--------------------------------------------------------------------------*/
  
  always @(posedge masterhclk_in)
    if (data_bus_owned & ~masterhready_in & (masterhresp_in==`H_RETRY||masterhresp_in==`H_SPLIT))
    begin
//      c_trans<=d_trans;              // RETRY/SPLIT causes transaction to be replayed
        retry_trans<=d_trans;
    end
    else if (addr_ack || data_ack)
    begin
      c_trans<=n_trans;
    end

  always @(posedge masterhclk_in or posedge reset)
    if (address_bus_owned & masterhready_in & ~reset &  (~need_retry|trans_end) )
    begin
      d_trans         <= c_trans;
      d_trans[107:76] <= masterhaddr_out_r;
      d_trans[72]     <= masterhwrite_out_r;
      d_trans[36]     <= masterhlock_out;
      d_trans[29:28]  <= masterhtrans_out_r;
      d_trans[21:20]  <= masterhburst_out_r;
      d_trans[18:16]  <= masterhsize_out;
    end
    else if (address_bus_owned & masterhready_in & ~reset &  need_retry )
    begin
      d_trans         <= retry_trans;
      d_trans[107:76] <= masterhaddr_out_r;
      d_trans[72]     <= masterhwrite_out_r;
      d_trans[36]     <= masterhlock_out;
      d_trans[29:28]  <= masterhtrans_out_r;
      d_trans[21:20]  <= masterhburst_out_r;
      d_trans[18:16]  <= masterhsize_out;
    end
    else if ( ( ~address_bus_owned & masterhready_in) | reset)
      d_trans<= i_trans;


  always @(posedge masterhclk_in)
    if (trans_end & ~need_retry)
    begin
      r_trans[253:252]<=masterhresp_in;
      r_trans[251:220]<=masterhrdata_in; 
      r_trans[219:0]  <=d_trans[219:0];
    end
    else if (trans_end & need_retry)
    begin
      r_trans[253:252]<=masterhresp_in;
      r_trans[251:220]<=masterhrdata_in; 
      r_trans[219:0]  <=retry_trans[219:0];
    end
    else
      r_trans<=i_trans;


/*//--------------------------------------------------------------------------
 masterhlock_out
//--------------------------------------------------------------------------*/
  assign          masterhlock_out = 1'b0;
  
/*//--------------------------------------------------------------------------
//--------------------------------------------------------------------------*/
endmodule    // apex_20ke_upcore

///////////////////////////////////////////////////////////////////////////////
//
// APEX20KE JTAG Atom
//
`timescale 1 ps/1 ps

module  apex20ke_jtagb (tms, tck, tdi, ntrst, tdoutap, tdouser, tdo, tmsutap, tckutap, tdiutap, shiftuser, clkdruser, updateuser, runidleuser, usr1user);

	input    tms, tck, tdi, ntrst, tdoutap, tdouser;
	output   tdo, tmsutap, tckutap, tdiutap, shiftuser, clkdruser;
	output	updateuser, runidleuser, usr1user;

	initial
	begin
	end

	always @(tms or tck or tdi or ntrst or tdoutap or tdouser) 
	begin 
	end

endmodule

