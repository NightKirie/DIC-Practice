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


// ********** PRIMITIVE DEFINITIONS **********

`timescale 1 ps/1 ps

// ***** DFFE

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

//       1   1   (x1)    1    1      ?      :   1   :   1;  // reducing pessimism
//       1   0   (x1)    1    1      ?      :   0   :   0;
         1   ?   (x1)    1    1      ?      :   ?   :   -;  // spr 80166-ignore
                                                            // x->1 edge
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

endprimitive

module dffe ( Q, CLK, ENA, D, CLRN, PRN );
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
   
   wire   legal;
   reg 	  viol_notifier;
   
   PRIM_DFFE ( Q, ENA_ipd, D_ipd, CLK_ipd, CLRN_ipd, PRN_ipd, viol_notifier );
   
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
endmodule     

// ***** LATCH

module maxii_latch(D, ENA, PRE, CLR, Q);
   
   input D;
   input ENA, PRE, CLR;
   output Q;
   
   reg 	  q_out;
   
   specify
      $setup (D, posedge ENA, 0) ;
      $hold (negedge ENA, D, 0) ;
      
      (D => Q) = (0, 0);
      (posedge ENA => (Q +: q_out)) = (0, 0);
      (negedge PRE => (Q +: q_out)) = (0, 0);
      (negedge CLR => (Q +: q_out)) = (0, 0);
   endspecify
   
   buf (D_in, D);
   buf (ENA_in, ENA);
   buf (PRE_in, PRE);
   buf (CLR_in, CLR);
   
   initial
      begin
	 q_out = 1'b0;
      end
   
   always @(D_in or ENA_in or PRE_in or CLR_in)
      begin
	 if (PRE_in == 1'b0)
	    begin
	       // latch being preset, preset is active low
	       q_out = 1'b1;
	    end
	 else if (CLR_in == 1'b0)
	    begin
	       // latch being cleared, clear is active low
	       q_out = 1'b0;
	    end
	      else if (ENA_in == 1'b1)
		 begin
		    // latch is transparent
		    q_out = D_in;
		 end
      end
   
   and (Q, q_out, 1'b1);
   
endmodule

// ***** MUX21

module maxii_mux21 (MO, A, B, S);
   input A, B, S;
   output MO;
   
   buf(A_in, A);
   buf(B_in, B);
   buf(S_in, S);

   wire   tmp_MO;
   
   specify
      (A => MO) = (0, 0);
      (B => MO) = (0, 0);
      (S => MO) = (0, 0);
   endspecify

   assign tmp_MO = (S_in == 1) ? B_in : A_in;
   
   buf (MO, tmp_MO);
endmodule

// ***** MUX41

module maxii_mux41 (MO, IN0, IN1, IN2, IN3, S);
   input IN0;
   input IN1;
   input IN2;
   input IN3;
   input [1:0] S;
   output MO;
   
   buf(IN0_in, IN0);
   buf(IN1_in, IN1);
   buf(IN2_in, IN2);
   buf(IN3_in, IN3);
   buf(S1_in, S[1]);
   buf(S0_in, S[0]);

   wire   tmp_MO;
   
   specify
      (IN0 => MO) = (0, 0);
      (IN1 => MO) = (0, 0);
      (IN2 => MO) = (0, 0);
      (IN3 => MO) = (0, 0);
      (S[1] => MO) = (0, 0);
      (S[0] => MO) = (0, 0);
   endspecify

   assign tmp_MO = S1_in ? (S0_in ? IN3_in : IN2_in) : (S0_in ? IN1_in : IN0_in);

   buf (MO, tmp_MO);

endmodule

// ***** AND1

module and1 (Y, IN1);
   input IN1;
   output Y;
   
   specify
      (IN1 => Y) = (0, 0);
   endspecify
   
   buf (Y, IN1);
endmodule

// ***** AND16

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

// ***** BMUX21

module maxii_bmux21 (MO, A, B, S);
   input [15:0] A, B;
   input 	S;
   output [15:0] MO; 
   
   assign MO = (S == 1) ? B : A; 
   
endmodule

// ***** B17MUX21

module maxii_b17mux21 (MO, A, B, S);
   input [16:0] A, B;
   input 	S;
   output [16:0] MO; 
   
   assign MO = (S == 1) ? B : A; 
   
endmodule

// ***** NMUX21

module maxii_nmux21 (MO, A, B, S);
   input A, B, S; 
   output MO; 
   
   assign MO = (S == 1) ? ~B : ~A; 
   
endmodule

// ***** B5MUX21

module maxii_b5mux21 (MO, A, B, S);
   input [4:0] A, B;
   input       S;
   output [4:0] MO; 
   
   assign MO = (S == 1) ? B : A; 
   
endmodule

// ********** END PRIMITIVE DEFINITIONS **********


///////////////////////////////////////////////////////////////////////////////
//
//              	MAXII LCELL ATOM 
//  
//  Supports lut_mask, does not support equations. Support normal, arithmetic, 
//  updown counter and iclrable counter mode.  Parameter output_mode is 
//  informational only and has no simulation function.  No checking is done 
//  for validation of parameters passed from top level.  Input default values 
//  are implemented using tri1 and tri0 net. 
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module maxii_asynch_lcell (
                             dataa, 
                             datab, 
                             datac, 
                             datad,
                             cin,
                             cin0,
                             cin1,
                             inverta,
                             qfbkin,
                             regin,
                             combout,
                             cout,
                             cout0,
                             cout1
                            );
   
input dataa;
input datab;
input datac;
input datad ;
input cin;
input cin0;
input cin1;
input inverta;
input qfbkin;

output combout;
output cout;
output cout0;
output cout1;
output regin;

parameter operation_mode = "normal" ;
parameter sum_lutc_input = "datac";
parameter lut_mask = "ffff" ;
parameter cin_used = "false";
parameter cin0_used = "false";
parameter cin1_used = "false";
   
reg icout;
reg icout0;
reg icout1;
reg data;
reg lut_data;
reg inverta_dataa;
reg [15:0] bin_mask;

reg iop_mode;
reg [1:0] isum_lutc_input;
reg icin_used;
reg icin0_used;
reg icin1_used;
   
wire qfbk_mode;

buf (idataa, dataa);
buf (idatab, datab);
buf (idatac, datac);
buf (idatad, datad);
buf (icin, cin);
buf (icin0, cin0);
buf (icin1, cin1);
buf (iinverta, inverta);
   
assign qfbk_mode = (sum_lutc_input == "qfbk") ? 1'b1 : 1'b0;

    specify
      
        (dataa => combout) = (0, 0) ;
        (datab => combout) = (0, 0) ;
        (datac => combout) = (0, 0) ;
        (datad => combout) = (0, 0) ;
        (cin => combout) = (0, 0) ;
        (cin0 => combout) = (0, 0) ;
        (cin1 => combout) = (0, 0) ;
        (inverta => combout) = (0, 0) ;
        if (qfbk_mode == 1'b1)
            (qfbkin => combout) = (0, 0) ;
              
        (dataa => cout) = (0, 0);
        (datab => cout) = (0, 0);
        (cin => cout) = (0, 0) ;
        (cin0 => cout) = (0, 0) ;
        (cin1 => cout) = (0, 0) ;
        (inverta => cout) = (0, 0);
              
        (dataa => cout0) = (0, 0);
        (datab => cout0) = (0, 0);
        (cin0 => cout0) = (0, 0) ;
        (inverta => cout0) = (0, 0);
              
        (dataa => cout1) = (0, 0);
        (datab => cout1) = (0, 0);
        (cin1 => cout1) = (0, 0) ;
        (inverta => cout1) = (0, 0);
              
        (dataa => regin) = (0, 0) ;
        (datab => regin) = (0, 0) ;
        (datac => regin) = (0, 0) ;
        (datad => regin) = (0, 0) ;
        (cin => regin) = (0, 0) ;
        (cin0 => regin) = (0, 0) ;
        (cin1 => regin) = (0, 0) ;
        (inverta => regin) = (0, 0) ;
        if (qfbk_mode == 1'b1)
            (qfbkin => regin) = (0, 0) ;
    endspecify
   
    function [16:1] str_to_bin ;
        input [8*4:1] s;
        reg [8*4:1]   reg_s;
        reg [4:1]     digit [8:1];
        reg [8:1]     tmp;
        integer 	    m , ivalue ;
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
        input [15:0] mask ;
        input dataa, datab, datac, datad ;
        reg prev_lut4;
        reg dataa_new;
        reg datab_new;
        reg datac_new;
        reg datad_new;
        integer h;
        integer i;
        integer j;
        integer k;
        integer hn;
        integer in;
        integer jn;
        integer kn;
        integer exitloop;
        integer check_prev;
           
        begin
            lut4 = mask[{datad, datac, datab, dataa}];
            if (lut4 === 1'bx)
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
                                lut4 = mask[{datad_new, datac_new, datab_new, dataa_new}];
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

    initial
    begin
        bin_mask = str_to_bin(lut_mask);

        if (operation_mode == "normal") 
            iop_mode = 0;	// normal mode
        else if (operation_mode == "arithmetic") 
            iop_mode = 1;	// arithmetic mode
        else
        begin
            $display ("Error: Invalid operation_mode specified\n");
            iop_mode = 2;
        end

	     if (sum_lutc_input == "datac") 
            isum_lutc_input = 0;
	     else if (sum_lutc_input == "cin") 
            isum_lutc_input = 1;
	     else if (sum_lutc_input == "qfbk") 
            isum_lutc_input = 2;
        else
        begin
            $display ("Error: Invalid sum_lutc_input specified\n");
            isum_lutc_input = 3;
        end
        
	     if (cin_used == "true") 
            icin_used = 1;
	     else if (cin_used == "false") 
            icin_used = 0;
        
	     if (cin0_used == "true") 
            icin0_used = 1;
	     else if (cin0_used == "false") 
            icin0_used = 0;
        
	     if (cin1_used == "true") 
            icin1_used = 1;
	     else if (cin1_used == "false") 
            icin1_used = 0;

    end

    always @(idatad or idatac or idatab or idataa or icin or 
             icin0 or icin1 or iinverta or qfbkin)
    begin
	
        if (iinverta === 'b1) //invert dataa
            inverta_dataa = !idataa;
        else
            inverta_dataa = idataa;
    	
        if (iop_mode == 0) // normal mode
        begin
            if (isum_lutc_input == 0) // datac 
            begin
                data = lut4(bin_mask, inverta_dataa, idatab, 
                            idatac, idatad);
            end
            else if (isum_lutc_input == 1) // cin
            begin
                if (icin0_used == 1 || icin1_used == 1)
                begin
                    if (icin_used == 1)
                        data = (icin === 'b0) ? 
                                lut4(bin_mask, 
                                inverta_dataa, 
                                idatab, 
                                icin0, 
                                idatad) : 
                                lut4(bin_mask, 
                                inverta_dataa, 
                                idatab, 
                                icin1, 
                                idatad);
                    else   // if cin is not used then inverta 
                           // should be used in place of cin
                        data = (iinverta === 'b0) ? 
                                lut4(bin_mask, 
                                inverta_dataa, 
                                idatab, 
                                icin0, 
                                idatad) : 
                                lut4(bin_mask, 
                                inverta_dataa, 
                                idatab, 
                                icin1, 
                                idatad);
                    end
                else
                    data = lut4(bin_mask, inverta_dataa, idatab, 
                                icin, idatad);
            end
            else if(isum_lutc_input == 2) // qfbk
            begin
                data = lut4(bin_mask, inverta_dataa, idatab, 
                            qfbkin, idatad);
            end
        end
        else if (iop_mode == 1) // arithmetic mode
        begin
            // sum LUT
            if (isum_lutc_input == 0) // datac 
            begin
                data = lut4(bin_mask, inverta_dataa, idatab, 
                            idatac, 'b1);
            end
            else if (isum_lutc_input == 1) // cin
            begin
                if (icin0_used == 1 || icin1_used == 1)
                begin
                    if (icin_used == 1)
                        data = (icin === 'b0) ? 
                                lut4(bin_mask, 
                                inverta_dataa, 
                                idatab, 
                                icin0, 
                                'b1) : 
                                lut4(bin_mask, 
                                inverta_dataa, 
                                idatab, 
                                icin1, 
                                'b1);
                    else   // if cin is not used then inverta 
                           // should be used in place of cin
                        data = (iinverta === 'b0) ? 
                                lut4(bin_mask, 
                                inverta_dataa, 
                                idatab, 
                                icin0, 
                                'b1) : 
                                lut4(bin_mask, 
                                inverta_dataa, 
                                idatab, 
                                icin1, 
                                'b1);
                end
                else if (icin_used == 1)
                    data = lut4(bin_mask, inverta_dataa, idatab, 
                                icin, 'b1);
                else  // cin is not used, inverta is used as cin
                    data = lut4(bin_mask, inverta_dataa, idatab, 
                                iinverta, 'b1);
            end
            else if(isum_lutc_input == 2) // qfbk
            begin
                data = lut4(bin_mask, inverta_dataa, idatab, 
                            qfbkin, 'b1);
            end
            	 
            // carry LUT
            icout0 = lut4(bin_mask, inverta_dataa, idatab, icin0, 'b0);
            icout1 = lut4(bin_mask, inverta_dataa, idatab, icin1, 'b0);
            	 
            if (icin_used == 1)
            begin
                if (icin0_used == 1 || icin1_used == 1)
                icout = (icin === 'b0) ? icout0 : icout1;
                else
                icout = lut4(bin_mask, inverta_dataa, idatab, 
                             icin, 'b0);
            end
            else  // inverta is used in place of cin
            begin
                if (icin0_used == 1 || icin1_used == 1)
                    icout = (iinverta === 'b0) ? icout0 : icout1; 
                else
                    icout = lut4(bin_mask, inverta_dataa, idatab, 
                                 iinverta, 'b0);
            end
        end
    end

    and (combout, data, 1'b1) ;
    and (cout, icout, 1'b1) ;
    and (cout0, icout0, 1'b1) ;
    and (cout1, icout1, 1'b1) ;
    and (regin, data, 1'b1) ;
   
endmodule

///////////////////////////////////////////////////////////////////////////////
//
//                              MAXII_LCELL_REGISTER
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
  
module maxii_lcell_register (
                               clk, 
                               aclr, 
                               aload, 
                               sclr, 
                               sload, 
                               ena, 
                               datain,
                               datac, 
                               regcascin, 
                               devclrn, 
                               devpor, 
                               regout, 
                               qfbkout
                              );
input clk;
input ena;
input aclr;
input aload;
input sclr;
input sload;
input datain;
input datac;
input regcascin;
input devclrn;
input devpor ;

output regout;
output qfbkout;

parameter synch_mode = "off";
parameter register_cascade_mode = "off";
parameter power_up = "low";
parameter x_on_violation = "on";
   
reg iregout;
wire reset;
wire nosload;
   
reg regcascin_viol;
reg datain_viol, datac_viol;
reg sclr_viol, sload_viol;
reg ena_viol, clk_per_viol;
reg violation;
reg clk_last_value;
   
reg ipower_up;
reg icascade_mode;
reg isynch_mode;
reg ix_on_violation;

buf (clk_in, clk);
buf (iaclr, aclr);
buf (iaload, aload);
buf (isclr, sclr);
buf (isload, sload);
buf (iena, ena);
   
buf (idatac, datac);
buf (iregcascin, regcascin);
buf (idatain, datain);
   
    assign reset = devpor && devclrn && (!iaclr) && (iena);
    assign nosload = reset && (!sload);
   
    specify
        $setuphold (posedge clk &&& reset, regcascin, 0, 0, regcascin_viol) ;
        $setuphold (posedge clk &&& nosload, datain, 0, 0, datain_viol) ;
        $setuphold (posedge clk &&& reset, datac, 0, 0, datac_viol) ;
        $setuphold (posedge clk &&& reset, sclr, 0, 0, sclr_viol) ;
        $setuphold (posedge clk &&& reset, sload, 0, 0, sload_viol) ;
        $setuphold (posedge clk &&& reset, ena, 0, 0, ena_viol) ;
        
        (posedge clk => (regout +: iregout)) = 0 ;
        (posedge aclr => (regout +: 1'b0)) = (0, 0) ;
        (posedge aload => (regout +: iregout)) = (0, 0) ;
        (datac => regout) = (0, 0) ;
        (posedge clk => (qfbkout +: iregout)) = 0 ;
        (posedge aclr => (qfbkout +: 1'b0)) = (0, 0) ;
        (posedge aload => (qfbkout +: iregout)) = (0, 0) ;
        (datac => qfbkout) = (0, 0) ;
    
    endspecify
   
    initial
    begin
        violation = 0;
        clk_last_value = 'b0;
        if (power_up == "low")
        begin
            iregout <= 'b0;
            ipower_up = 0;
        end
        else if (power_up == "high")
        begin
            iregout <= 'b1;
            ipower_up = 1;
        end

        if (register_cascade_mode == "on")
            icascade_mode = 1;
        else
            icascade_mode = 0;

        if (synch_mode == "on" )
            isynch_mode = 1;
        else
            isynch_mode = 0;

        if (x_on_violation == "on")
            ix_on_violation = 1;
        else
            ix_on_violation = 0;
    end
   
    always @ (regcascin_viol or datain_viol or datac_viol or sclr_viol 
              or sload_viol or ena_viol or clk_per_viol)
    begin
        if (ix_on_violation == 1)
        violation = 1;
    end
   
    always @ (clk_in or idatac or iaclr or posedge iaload 
              or negedge devclrn or negedge devpor or posedge violation)
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
                if (ipower_up == 0) // "low"
                    iregout <= 'b0;
                else if (ipower_up == 1) // "high"
                    iregout <= 'b1;
            end
            else if (devclrn == 'b0)
                iregout <= 'b0;
            else if (iaclr === 'b1) 
                iregout <= 'b0 ;
            else if (iaload === 'b1) 
                iregout <= idatac;
            else if (iena === 'b1 && clk_in === 'b1 && 
                     clk_last_value === 'b0)
            begin
                if (isynch_mode == 1)
                begin
                    if (isclr === 'b1)
                        iregout <= 'b0 ;
                    else if (isload === 'b1)
                        iregout <= idatac;
                    else if (icascade_mode == 1)
                        iregout <= iregcascin;
                    else
                        iregout <= idatain;
                end
                else if (icascade_mode == 1)
                    iregout <= iregcascin;
                else 
                    iregout <= idatain;
            end
        end
        clk_last_value = clk_in;
    end
       
    and (regout, iregout, 1'b1);
    and (qfbkout, iregout, 1'b1);
   
endmodule

///////////////////////////////////////////////////////////////////////////////
//
//                                MAXII_LCELL
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module maxii_lcell (
                      clk, 
                      dataa, 
                      datab, 
                      datac, 
                      datad, 
                      aclr, 
                      aload, 
                      sclr,
                      sload,
                      ena,
                      cin,
                      cin0,
                      cin1,
                      inverta,
                      regcascin,
                      devclrn,
                      devpor,
                      combout,
                      regout,
                      cout, 
                      cout0,
                      cout1
                     );

input dataa;
input datab;
input datac;
input datad;
input clk; 
input aclr; 
input aload; 
input sclr; 
input sload; 
input ena; 
input cin;
input cin0;
input cin1;
input inverta;
input regcascin;
input devclrn;
input devpor ;

output combout;
output regout;
output cout;
output cout0;
output cout1;

parameter operation_mode = "normal" ;
parameter synch_mode = "off";
parameter register_cascade_mode = "off";
parameter sum_lutc_input = "datac";
parameter lut_mask = "ffff" ;
parameter power_up = "low";
parameter cin_used = "false";
parameter cin0_used = "false";
parameter cin1_used = "false";
parameter output_mode = "comb_only";
parameter lpm_type = "maxii_lcell";
parameter x_on_violation = "on";
   
wire dffin, qfbkin;
   
maxii_asynch_lcell lecomb (
                             .dataa(dataa),
                             .datab(datab), 
                             .datac(datac),
                             .datad(datad),
                             .cin(cin),
                             .cin0(cin0),
                             .cin1(cin1), 
                             .inverta(inverta),
                             .qfbkin(qfbkin),
                             .regin(dffin),
                             .combout(combout),
                             .cout(cout),
                             .cout0(cout0),
                             .cout1(cout1)
                            );
    defparam lecomb.operation_mode = operation_mode;
    defparam lecomb.sum_lutc_input = sum_lutc_input;
    defparam lecomb.cin_used = cin_used;
    defparam lecomb.cin0_used = cin0_used;
    defparam lecomb.cin1_used = cin1_used;
    defparam lecomb.lut_mask = lut_mask;
   
maxii_lcell_register lereg (
                              .clk(clk),
                              .aclr(aclr),
                              .aload(aload),
                              .sclr(sclr),
                              .sload(sload),
                              .ena(ena), 
                              .datain(dffin), 
                              .datac(datac),
                              .regcascin(regcascin),
                              .devclrn(devclrn),
                              .devpor(devpor), 
                              .regout(regout),
                              .qfbkout(qfbkin)
                             );
    defparam lereg.synch_mode = synch_mode;
    defparam lereg.register_cascade_mode = register_cascade_mode;
    defparam lereg.power_up = power_up;
    defparam lereg.x_on_violation = x_on_violation;
   
endmodule


///////////////////////////////////////////////////////////////////////////////
//
//                  MAXII UFM ATOM
//
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

// MODULE DECLARATION
module maxii_ufm (program, erase, oscena, arclk, arshft, ardin, drclk,
                  drshft, drdin, sbdin, devclrn, devpor, ctrl_bgpbusy, busy,
                  osc, drdout, sbdout, bgpbusy);

// PARAMETER DECLARATION
    parameter address_width = 9;
    parameter init_file = "none";
    parameter lpm_type = "maxii_ufm";
    parameter mem1 = {512{1'b1}};
    parameter mem2 = {512{1'b1}};
    parameter mem3 = {512{1'b1}};
    parameter mem4 = {512{1'b1}};
    parameter mem5 = {512{1'b1}};
    parameter mem6 = {512{1'b1}};
    parameter mem7 = {512{1'b1}};
    parameter mem8 = {512{1'b1}};
    parameter mem9 = {512{1'b1}};
    parameter mem10 = {512{1'b1}};
    parameter mem11 = {512{1'b1}};
    parameter mem12 = {512{1'b1}};
    parameter mem13 = {512{1'b1}};
    parameter mem14 = {512{1'b1}};
    parameter mem15 = {512{1'b1}};
    parameter mem16 = {512{1'b1}};
    parameter osc_sim_setting = 136000; // default osc frequency to 7.35MHz

    //constant
    parameter widthdata = 16; // fixed data width of 16
    parameter widthadd = 9;   // fixed address width of 9
    parameter sector0_range = 1<<(address_width-1);

    // Timing delay pulse
    parameter TOSCMN_PW = (osc_sim_setting != 0 ) ? (osc_sim_setting / 2) : 68000;    // Pulse width of Minimum Oscillator
                                     //  Frequency
    parameter TPPMX  = 75000000;     // Maximum Length of Busy Pulse During a
                                     //  Program, default is 75 us
    parameter TEPMX  = 350000000;   // Maximum Length of Busy Pulse During an
                                     //  Erase, default is 35 ms; current
                                     //  constant is 350 us; need to multiply
                                     //  100 to get correct value of 35 ms.

// INPUT PORT DECLARATION
    input program;
    input erase;
    input oscena;
    input arclk;
    input arshft;
    input ardin;
    input drclk;
    input drshft;
    input drdin;
    input sbdin;
    input devclrn;         // simulation only port; simulate device-level clear
    input devpor;          // simulation only port; simulate power-up-reset
    input ctrl_bgpbusy;    // simulation only port; used to control and emulate
                           //  the output behaviour of bgpbusy

// OUTPUT PORT DECLARATION
    output busy;
    output osc;
    output drdout;
    output sbdout;
    output bgpbusy;

// INTERNAL SIGNAL/REGISTER DECLARATION
    // for memory initialization
    reg [(widthdata * (1 << (widthadd - 1)) - 1):0] ufm_initf_sec0;
    reg [(widthdata * (1 << (widthadd - 1)) - 1):0] ufm_initf_sec1;
    reg [(widthdata-1):0] init_word0; // current init word for sector0
    reg [(widthdata-1):0] init_word1; // current init word for sector1
    // for simulation
    reg [(widthdata-1):0] ufm_storage [0:(1<<address_width)-1]; // ufm sector0
                                                                // and sector1
    reg [address_width-1:0] addr_reg;    // internal address register
    reg [address_width-1:0] address_now; // Latest address value
    reg [(widthdata-1):0]  data_reg;     // internal data register
    reg [(widthdata-1):0] data_now;      // Latest data value in register
    reg [(widthdata-1):0] storage_output; // data output from user flash storage
    reg int_osc;                       // internal oscillator
    reg program_pulse;                 // indicate program cycle is running
    reg erase_pulse;                   // indicate erase cycle is running
    reg first_warning;                 // warn the user once about oscillator range
    reg program_reg;                   // program signal must be registered by rising osc edge
    reg erase_reg;                     // erase signal must be registered by rising osc edge

// INTERNAL WIRE DECLARATION
    wire [address_width-1:0] address_tmp;
    wire [(widthdata-1):0] new_read_data;
    wire [(widthdata-1):0] data_tmp;
    wire sys_busy;
    wire gated_arclk;
    wire gated_drclk;
    wire data_reg_msb;

// INTERNAL TRI DECLARATION
    tri0 erase;
    tri0 program;
    tri0 ctrl_bgpbusy;
    tri0 sbdin;

// Buffer Declaration
    buf (i_program, program);
    buf (i_erase, erase);
    buf (i_oscena, oscena);
    buf (i_arclk, arclk);
    buf (i_arshft, arshft);
    buf (i_ardin, ardin);
    buf (i_drclk, drclk);
    buf (i_drshft, drshft);
    buf (i_drdin, drdin);
    buf (i_sbdin, sbdin);

// LOCAL INTEGER DECLARATION
    integer i, j, k, l;        // looping index
    integer mem_cnt, bit_cnt;  // looping index
    integer numwords;          // number of UFM words

// DELAY SPECIFICATION

    specify
        (sbdin => sbdout) = (0, 0);

        $setup (arshft, posedge arclk, 0);
        $setup (ardin, posedge arclk, 0);
        $setup (drshft, posedge drclk, 0);
        $setup (drdin, posedge drclk, 0);
        $setup (oscena, posedge program, 0);
        $setup (oscena, posedge erase, 0);

        $hold (posedge arclk, arshft, 0);
        $hold (posedge arclk, ardin, 0);
        $hold (posedge drclk, drshft, 0);
        $hold (posedge drclk, drdin, 0);
        $hold (posedge drclk, program, 0);
        $hold (posedge arclk, erase, 0);
        $hold (negedge busy, program, 0);
        $hold (negedge busy, erase, 0);
        $hold (negedge program, oscena, 0);
        $hold (negedge erase, oscena, 0);

        (posedge program => (busy +: 1'b1)) = (0, 0) ;
        (posedge erase => (busy +: 1'b1)) = (0, 0) ;
        (posedge drclk => (drdout +: data_reg_msb)) = 0;
        (posedge oscena => (osc +: 1'b1)) = (0, 0);

    endspecify

// INITIAL CONSTRUCT BLOCK
    initial
    begin

        first_warning <= 1;

        // Check for invalid parameters
        if (address_width != widthadd)
        begin
            $display("Error! address_width parameter must be equal to %d.", widthadd);
        end
        if (widthdata != 16)
        begin
            $display("Error! widthdata parameter must be equal to 16.");
        end

        addr_reg <= 0;
        data_reg <= 0;
        program_pulse <= 0;
        erase_pulse <= 0;
        storage_output <= 0;
        int_osc <= 0;

        // Initialize UFM
        numwords = 1 << address_width;
        if (init_file == "none")
            for (i=0; i<numwords; i=i+1)
                ufm_storage[i] = 16'hFFFF;   // UFM content is initially all 1's
        else
        begin
            // initialize UFM from memory initialization file (*.mif or *.hex)
            // the contents of the memory initialization file are passed in via the
            // mem* parameters
            ufm_initf_sec1 = {mem16, mem15, mem14, mem13, mem12, mem11, mem10, mem9};
            ufm_initf_sec0 = {mem8, mem7, mem6, mem5, mem4, mem3, mem2, mem1};

            for (mem_cnt = 1; mem_cnt <= sector0_range; mem_cnt = mem_cnt + 1)
            begin
                for (bit_cnt = 0; bit_cnt < widthdata; bit_cnt = bit_cnt + 1)
                begin
                    init_word0[bit_cnt] = ufm_initf_sec0[((mem_cnt-1)*widthdata) + bit_cnt];
                    init_word1[bit_cnt] = ufm_initf_sec1[((mem_cnt-1)*widthdata) + bit_cnt];
                end
                //sector 0
                ufm_storage[mem_cnt-1] = init_word0;
                //sector 1
                ufm_storage[(mem_cnt-1)+sector0_range] = init_word1;
            end
        end
    end

// ALWAYS CONSTRUCT BLOCKS

    // Produce oscillation clock to UFM
    always @(int_osc or i_oscena)
    begin
        if (i_oscena === 'b1)
        begin
            if (first_warning == 1)
            begin
                $display("Info : UFM oscillator can operate at any frequency between 4.63MHz to 7.35Mhz.");
                first_warning = 0;
            end

            if (int_osc === 'b0 || int_osc === 'b1)
                int_osc <= #TOSCMN_PW ~int_osc;
            else
                int_osc <= 0;
        end
        else
        begin
            int_osc <= 0;
        end
    end

    // Shift address from LSB to MSB when arshft is '1'; else increment address.
    // (Using block statement to avoid race condition warning; therefore, the
    // order of assignments must be taken care to ensure correct behaviour)
    always @(posedge gated_arclk or negedge devclrn or negedge devpor)
    begin
        if (devpor == 'b0)
            addr_reg = 0;
        else if (devclrn == 'b0)
            addr_reg = 0;
        else if (i_arshft == 'b1)
        begin
            for (i=address_width-1; i >= 1; i=i-1)
            begin
                addr_reg[i] = addr_reg[i-1];
            end
            addr_reg[0] = i_ardin;
        end
        else
            addr_reg = addr_reg + 1;
    end

    // Latest address
    always @(address_tmp)
    begin
        address_now <= address_tmp;
    end

    // Shift data from LSB to MSB when drshft is '1'; else load new data.
    // (Using block statement to avoid race condition warning; therefore, the
    // order of assignments must be taken care to ensure correct behaviour)
    always @(posedge gated_drclk or negedge devclrn or negedge devpor)
    begin
        if (devpor == 'b0)
            data_reg = 0;
        else if (devclrn == 'b0)
            data_reg = 0;
        else if (i_drshft == 'b1)
        begin
            for (j=widthdata-1; j >= 1; j=j-1)
            begin
                data_reg[j] = data_reg[j-1];
            end
            data_reg[0] = i_drdin;
        end
        else
            data_reg = storage_output;
    end

    // Latest data loaded from ufm
    always @(new_read_data)
    begin
        storage_output <= new_read_data;
    end

    // Latest data content in data register
    always @(data_tmp)
    begin
        data_now <= data_tmp;
    end

    always @(posedge int_osc)
    begin
        program_reg <= i_program;
       // PROGRAM has higher precedence than ERASE
        if(i_program !== 'b1)
            erase_reg <= i_erase;
    end

    // Pulse to indicate programing UFM for min of 20ms and max of 40ms
    // (must use blocking statement)
    always @(posedge program_reg)
    begin
        if (program_pulse !== 'b1)
        begin
            program_pulse = 1;
            program_pulse = #(TPPMX) 0;
        end
    end

    // Pulse to indicate erasing UFM for min of 20ms and max of 120ms
    // (must use blocking statement)
    always @(posedge erase_reg)
    begin
        if (erase_pulse !== 'b1)
        begin
            erase_pulse = 1;
            // Create a pulse of TEPMX * 100 ps
            for (l=1; l < 100; l=l+1)
            begin
                erase_pulse = #(TEPMX) 1;
            end
            erase_pulse = #(TEPMX) 0;
        end
    end

    // Start updating UFM
    always @(posedge program_pulse)
    begin
        // The write operation is the logical "AND" in UFM
        ufm_storage[address_now] <= data_now & ufm_storage[address_now];
    end


    // Start erasing UFM
    always @(posedge erase_pulse)
    begin
        if (address_now[address_width-1] == 'b0)
        begin
            for (k=0; k<sector0_range; k=k+1)
            begin
                ufm_storage[k] <= 16'hFFFF;  // Data in UFM is erased to all 1's
            end
        end
        else
        begin
            for (k=sector0_range; k<sector0_range*2; k=k+1)
            begin
                ufm_storage[k] <= 16'hFFFF;  // Data in UFM is erased to all 1's
            end
        end
    end

// CONTINUOUS ASSIGNMENT
    and(busy, sys_busy, 'b1);
    and(osc, int_osc, 'b1);
    and(sbdout, i_sbdin, 'b1);
    and(bgpbusy, ctrl_bgpbusy, 'b1);
    and(drdout, data_reg_msb, 'b1);

    assign data_reg_msb = data_tmp[(widthdata-1)];

    assign address_tmp = addr_reg;

    assign data_tmp = data_reg;

    assign new_read_data = ufm_storage[address_tmp];

    assign sys_busy = program_pulse | erase_pulse;

    assign gated_arclk = i_arclk & !sys_busy;
    assign gated_drclk = i_drclk & !sys_busy;

endmodule // maxii_ufm
///////////////////////////////////////////////////////////////////////////////
//
// MAXII IO Atom
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1 ps/1 ps

module maxii_io (
                   datain, 
                   oe, 
                   padio, 
                   combout
                  );
   
    input datain;
    input oe;
    output combout;
    inout  padio;
   
    parameter operation_mode = "input";
    parameter bus_hold = "false";
    parameter open_drain_output = "false";
    parameter lpm_type = "maxii_io";
   
    reg prev_value;
    reg tmp_padio;
    reg tmp_combout;
    reg buf_control;

    reg iopen_drain; // open_drain: 1--true, 0--false
    reg ibus_hold; // bus_hold: 1--true, 0--false
    reg [1:0] iop_mode; // operation_mode: 1--input, 2--output, 3--bidir
   
    buf(datain_in, datain);
    buf(oe_in, oe);
   
    tri padio_tmp;
   
    specify
        (padio => combout) = (0,0);
        (datain => padio) = (0, 0);
        (posedge oe => (padio +: padio_tmp)) = (0, 0);
        (negedge oe => (padio +: 1'bz)) = (0, 0);
    endspecify
   
    initial
    begin
        prev_value = 'b0;
        tmp_padio = 'bz;

        if (operation_mode == "input")
            iop_mode = 1;
        else if (operation_mode == "output")
            iop_mode = 2;
        else if (operation_mode == "bidir")
            iop_mode = 3;
        else
        begin
            $display ("Error: Invalid operation_mode specified\n");
            iop_mode = 0;
        end

        if (bus_hold == "true" )
            ibus_hold = 1;
        else
            ibus_hold = 0;

        if (open_drain_output == "true" )
            iopen_drain = 1;
        else
            iopen_drain = 0;
    end
   
    always @(datain_in or oe_in or padio)
    begin
        if (ibus_hold == 1)
        begin
            buf_control = 'b1;
            if ( operation_mode == "input")
            begin
                if (padio == 1'bz)
                    tmp_combout = prev_value;
                else
                begin
                    prev_value = padio; 
                    tmp_combout = padio;
                end
                tmp_padio = 1'bz;
            end
            else
            begin
                if (iop_mode == 2 || iop_mode == 3)
                begin
                    if (oe_in == 1)
                    begin
                        if (iopen_drain == 1)
                        begin
                            if (datain_in == 0)
                            begin
                                tmp_padio =  1'b0;
                                prev_value = 1'b0;
                            end
                            else if (datain_in == 1'bx)
                            begin
                                tmp_padio = 1'bx;
                                prev_value = 1'bx;
                            end
                            else   // output of tri is 'Z'
                            begin
                                if (iop_mode == 3)
                                    prev_value = padio;

                                tmp_padio = 1'bz;
                            end
                        end  
                        else  // open_drain_output = false;
                        begin
                            tmp_padio = datain_in;
                            prev_value = datain_in;
                        end
                    end   
                    else if (oe_in == 0)
                    begin
                        if (iop_mode == 3)
                            prev_value = padio;

                        tmp_padio = 1'bz;
                    end
                    else   // oe == 'X' 
                    begin
                        tmp_padio = 1'bx;
                        prev_value = 1'bx;
                    end
                end
			
                if (iop_mode == 2)
                    tmp_combout = 1'bz;
                else
                    tmp_combout = padio;
            end
        end
        else    // bus hold is false
        begin
            buf_control = 'b0;
            if (iop_mode == 1)
            begin
                tmp_combout = padio;
            end
            else if (iop_mode == 2 || iop_mode == 3)
            begin
                if (iop_mode  == 3)
                    tmp_combout = padio;
				
                if (oe_in == 1)
                begin
                    if (iopen_drain == 1)
                    begin
                        if (datain_in == 0)
                            tmp_padio = 1'b0;
                        else if (datain_in == 1'bx)
                            tmp_padio = 1'bx;
                        else
                            tmp_padio = 1'bz;
                    end
                    else
                        tmp_padio = datain_in;
                end
                else if (oe_in == 0)
                    tmp_padio = 1'bz;
                else
                    tmp_padio = 1'bx;
            end
            else
                $display ("Error: Invalid operation_mode specified in MAXII io atom!\n");
            end
        end
   
    bufif1 (weak1, weak0) b(padio_tmp, prev_value, buf_control);  //weak value
    pmos (padio_tmp, tmp_padio, 'b0);
    pmos (combout, tmp_combout, 'b0);
    pmos (padio, padio_tmp, 'b0);

endmodule

