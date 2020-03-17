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

module stratixii_latch(D, ENA, PRE, CLR, Q);
   
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

module stratixii_mux21 (MO, A, B, S);
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

module stratixii_mux41 (MO, IN0, IN1, IN2, IN3, S);
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

module stratixii_bmux21 (MO, A, B, S);
   input [15:0] A, B;
   input 	S;
   output [15:0] MO; 
   
   assign MO = (S == 1) ? B : A; 
   
endmodule

// ***** B17MUX21

module stratixii_b17mux21 (MO, A, B, S);
   input [16:0] A, B;
   input 	S;
   output [16:0] MO; 
   
   assign MO = (S == 1) ? B : A; 
   
endmodule

// ***** NMUX21

module stratixii_nmux21 (MO, A, B, S);
   input A, B, S; 
   output MO; 
   
   assign MO = (S == 1) ? ~B : ~A; 
   
endmodule

// ***** B5MUX21

module stratixii_b5mux21 (MO, A, B, S);
   input [4:0] A, B;
   input       S;
   output [4:0] MO; 
   
   assign MO = (S == 1) ? B : A; 
   
endmodule

// ********** END PRIMITIVE DEFINITIONS **********



///////////////////////////////////////////////////////////////////////////////
//
//                            STRATIXII_RAM_REGISTER
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
  module stratixii_ram_register 
    (
     data, 
     clk, 
     aclr, 
     ena, 
     stall,
     ifclk, 
     ifaclr, 
     ifena, 
     devclrn, 
     devpor, 
     powerup,
     dataout, 
     aclrout,
     clkout,
     done
     );
   
   parameter data_width = 144;
   parameter sclr = "true";
   parameter preset = "false";
   
   input [143:0] data;
   input 	 clk;
   input 	 aclr;
   input 	 ena;
   input 	 stall;
   input 	 ifclk;
   input 	 ifaclr;
   input 	 ifena;
   input 	 devclrn;
   input 	 devpor;
   input 	 powerup;
   
   output [143:0] dataout;
   output 	  aclrout;
   output 	  clkout;
   output 	  done;
   
   wire [143:0]   data_ipd;
   wire 	  clk_ipd;
   wire 	  aclr_ipd;
   wire 	  ena_ipd;
   wire 	  stall_ipd;
   wire [143:0]   dataout_tmp;
   wire [143:0]   dataout_tbuf;
   wire 	  done_tbuf; 
   reg            aclrout_reg; 		  
   reg 		  done_reg;
   reg 		  clk_dly;
   reg 		  done_delta;
   reg [143:0] 	  dataout_reg;
   reg [143:0] 	  dataout_sreg;
   reg 		  viol_notifier; 
   
   tri1 	  ena;
   tri0 	  stall;
   
   buf data_buf0 (data_ipd[0], data[0]);
   buf data_buf1 (data_ipd[1], data[1]);
   buf data_buf2 (data_ipd[2], data[2]);
   buf data_buf3 (data_ipd[3], data[3]);
   buf data_buf4 (data_ipd[4], data[4]);
   buf data_buf5 (data_ipd[5], data[5]);
   buf data_buf6 (data_ipd[6], data[6]);
   buf data_buf7 (data_ipd[7], data[7]);
   buf data_buf8 (data_ipd[8], data[8]);
   buf data_buf9 (data_ipd[9], data[9]);
   buf data_buf10 (data_ipd[10], data[10]);
   buf data_buf11 (data_ipd[11], data[11]);
   buf data_buf12 (data_ipd[12], data[12]);
   buf data_buf13 (data_ipd[13], data[13]);
   buf data_buf14 (data_ipd[14], data[14]);
   buf data_buf15 (data_ipd[15], data[15]);
   buf data_buf16 (data_ipd[16], data[16]);
   buf data_buf17 (data_ipd[17], data[17]);
   buf data_buf18 (data_ipd[18], data[18]);
   buf data_buf19 (data_ipd[19], data[19]);
   buf data_buf20 (data_ipd[20], data[20]);
   buf data_buf21 (data_ipd[21], data[21]);
   buf data_buf22 (data_ipd[22], data[22]);
   buf data_buf23 (data_ipd[23], data[23]);
   buf data_buf24 (data_ipd[24], data[24]);
   buf data_buf25 (data_ipd[25], data[25]);
   buf data_buf26 (data_ipd[26], data[26]);
   buf data_buf27 (data_ipd[27], data[27]);
   buf data_buf28 (data_ipd[28], data[28]);
   buf data_buf29 (data_ipd[29], data[29]);
   buf data_buf30 (data_ipd[30], data[30]);
   buf data_buf31 (data_ipd[31], data[31]);
   buf data_buf32 (data_ipd[32], data[32]);
   buf data_buf33 (data_ipd[33], data[33]);
   buf data_buf34 (data_ipd[34], data[34]);
   buf data_buf35 (data_ipd[35], data[35]);
   buf data_buf36 (data_ipd[36], data[36]);
   buf data_buf37 (data_ipd[37], data[37]);
   buf data_buf38 (data_ipd[38], data[38]);
   buf data_buf39 (data_ipd[39], data[39]);
   buf data_buf40 (data_ipd[40], data[40]);
   buf data_buf41 (data_ipd[41], data[41]);
   buf data_buf42 (data_ipd[42], data[42]);
   buf data_buf43 (data_ipd[43], data[43]);
   buf data_buf44 (data_ipd[44], data[44]);
   buf data_buf45 (data_ipd[45], data[45]);
   buf data_buf46 (data_ipd[46], data[46]);
   buf data_buf47 (data_ipd[47], data[47]);
   buf data_buf48 (data_ipd[48], data[48]);
   buf data_buf49 (data_ipd[49], data[49]);
   buf data_buf50 (data_ipd[50], data[50]);
   buf data_buf51 (data_ipd[51], data[51]);
   buf data_buf52 (data_ipd[52], data[52]);
   buf data_buf53 (data_ipd[53], data[53]);
   buf data_buf54 (data_ipd[54], data[54]);
   buf data_buf55 (data_ipd[55], data[55]);
   buf data_buf56 (data_ipd[56], data[56]);
   buf data_buf57 (data_ipd[57], data[57]);
   buf data_buf58 (data_ipd[58], data[58]);
   buf data_buf59 (data_ipd[59], data[59]);
   buf data_buf60 (data_ipd[60], data[60]);
   buf data_buf61 (data_ipd[61], data[61]);
   buf data_buf62 (data_ipd[62], data[62]);
   buf data_buf63 (data_ipd[63], data[63]);
   buf data_buf64 (data_ipd[64], data[64]);
   buf data_buf65 (data_ipd[65], data[65]);
   buf data_buf66 (data_ipd[66], data[66]);
   buf data_buf67 (data_ipd[67], data[67]);
   buf data_buf68 (data_ipd[68], data[68]);
   buf data_buf69 (data_ipd[69], data[69]);
   buf data_buf70 (data_ipd[70], data[70]);
   buf data_buf71 (data_ipd[71], data[71]);
   buf data_buf72 (data_ipd[72], data[72]);
   buf data_buf73 (data_ipd[73], data[73]);
   buf data_buf74 (data_ipd[74], data[74]);
   buf data_buf75 (data_ipd[75], data[75]);
   buf data_buf76 (data_ipd[76], data[76]);
   buf data_buf77 (data_ipd[77], data[77]);
   buf data_buf78 (data_ipd[78], data[78]);
   buf data_buf79 (data_ipd[79], data[79]);
   buf data_buf80 (data_ipd[80], data[80]);
   buf data_buf81 (data_ipd[81], data[81]);
   buf data_buf82 (data_ipd[82], data[82]);
   buf data_buf83 (data_ipd[83], data[83]);
   buf data_buf84 (data_ipd[84], data[84]);
   buf data_buf85 (data_ipd[85], data[85]);
   buf data_buf86 (data_ipd[86], data[86]);
   buf data_buf87 (data_ipd[87], data[87]);
   buf data_buf88 (data_ipd[88], data[88]);
   buf data_buf89 (data_ipd[89], data[89]);
   buf data_buf90 (data_ipd[90], data[90]);
   buf data_buf91 (data_ipd[91], data[91]);
   buf data_buf92 (data_ipd[92], data[92]);
   buf data_buf93 (data_ipd[93], data[93]);
   buf data_buf94 (data_ipd[94], data[94]);
   buf data_buf95 (data_ipd[95], data[95]);
   buf data_buf96 (data_ipd[96], data[96]);
   buf data_buf97 (data_ipd[97], data[97]);
   buf data_buf98 (data_ipd[98], data[98]);
   buf data_buf99 (data_ipd[99], data[99]);
   buf data_buf100 (data_ipd[100], data[100]);
   buf data_buf101 (data_ipd[101], data[101]);
   buf data_buf102 (data_ipd[102], data[102]);
   buf data_buf103 (data_ipd[103], data[103]);
   buf data_buf104 (data_ipd[104], data[104]);
   buf data_buf105 (data_ipd[105], data[105]);
   buf data_buf106 (data_ipd[106], data[106]);
   buf data_buf107 (data_ipd[107], data[107]);
   buf data_buf108 (data_ipd[108], data[108]);
   buf data_buf109 (data_ipd[109], data[109]);
   buf data_buf110 (data_ipd[110], data[110]);
   buf data_buf111 (data_ipd[111], data[111]);
   buf data_buf112 (data_ipd[112], data[112]);
   buf data_buf113 (data_ipd[113], data[113]);
   buf data_buf114 (data_ipd[114], data[114]);
   buf data_buf115 (data_ipd[115], data[115]);
   buf data_buf116 (data_ipd[116], data[116]);
   buf data_buf117 (data_ipd[117], data[117]);
   buf data_buf118 (data_ipd[118], data[118]);
   buf data_buf119 (data_ipd[119], data[119]);
   buf data_buf120 (data_ipd[120], data[120]);
   buf data_buf121 (data_ipd[121], data[121]);
   buf data_buf122 (data_ipd[122], data[122]);
   buf data_buf123 (data_ipd[123], data[123]);
   buf data_buf124 (data_ipd[124], data[124]);
   buf data_buf125 (data_ipd[125], data[125]);
   buf data_buf126 (data_ipd[126], data[126]);
   buf data_buf127 (data_ipd[127], data[127]);
   buf data_buf128 (data_ipd[128], data[128]);
   buf data_buf129 (data_ipd[129], data[129]);
   buf data_buf130 (data_ipd[130], data[130]);
   buf data_buf131 (data_ipd[131], data[131]);
   buf data_buf132 (data_ipd[132], data[132]);
   buf data_buf133 (data_ipd[133], data[133]);
   buf data_buf134 (data_ipd[134], data[134]);
   buf data_buf135 (data_ipd[135], data[135]);
   buf data_buf136 (data_ipd[136], data[136]);
   buf data_buf137 (data_ipd[137], data[137]);
   buf data_buf138 (data_ipd[138], data[138]);
   buf data_buf139 (data_ipd[139], data[139]);
   buf data_buf140 (data_ipd[140], data[140]);
   buf data_buf141 (data_ipd[141], data[141]);
   buf data_buf142 (data_ipd[142], data[142]);
   buf data_buf143 (data_ipd[143], data[143]);

   buf dataout_buf0 (dataout[0], dataout_tbuf[0]);
   buf dataout_buf1 (dataout[1], dataout_tbuf[1]);
   buf dataout_buf2 (dataout[2], dataout_tbuf[2]);
   buf dataout_buf3 (dataout[3], dataout_tbuf[3]);
   buf dataout_buf4 (dataout[4], dataout_tbuf[4]);
   buf dataout_buf5 (dataout[5], dataout_tbuf[5]);
   buf dataout_buf6 (dataout[6], dataout_tbuf[6]);
   buf dataout_buf7 (dataout[7], dataout_tbuf[7]);
   buf dataout_buf8 (dataout[8], dataout_tbuf[8]);
   buf dataout_buf9 (dataout[9], dataout_tbuf[9]);
   buf dataout_buf10 (dataout[10], dataout_tbuf[10]);
   buf dataout_buf11 (dataout[11], dataout_tbuf[11]);
   buf dataout_buf12 (dataout[12], dataout_tbuf[12]);
   buf dataout_buf13 (dataout[13], dataout_tbuf[13]);
   buf dataout_buf14 (dataout[14], dataout_tbuf[14]);
   buf dataout_buf15 (dataout[15], dataout_tbuf[15]);
   buf dataout_buf16 (dataout[16], dataout_tbuf[16]);
   buf dataout_buf17 (dataout[17], dataout_tbuf[17]);
   buf dataout_buf18 (dataout[18], dataout_tbuf[18]);
   buf dataout_buf19 (dataout[19], dataout_tbuf[19]);
   buf dataout_buf20 (dataout[20], dataout_tbuf[20]);
   buf dataout_buf21 (dataout[21], dataout_tbuf[21]);
   buf dataout_buf22 (dataout[22], dataout_tbuf[22]);
   buf dataout_buf23 (dataout[23], dataout_tbuf[23]);
   buf dataout_buf24 (dataout[24], dataout_tbuf[24]);
   buf dataout_buf25 (dataout[25], dataout_tbuf[25]);
   buf dataout_buf26 (dataout[26], dataout_tbuf[26]);
   buf dataout_buf27 (dataout[27], dataout_tbuf[27]);
   buf dataout_buf28 (dataout[28], dataout_tbuf[28]);
   buf dataout_buf29 (dataout[29], dataout_tbuf[29]);
   buf dataout_buf30 (dataout[30], dataout_tbuf[30]);
   buf dataout_buf31 (dataout[31], dataout_tbuf[31]);
   buf dataout_buf32 (dataout[32], dataout_tbuf[32]);
   buf dataout_buf33 (dataout[33], dataout_tbuf[33]);
   buf dataout_buf34 (dataout[34], dataout_tbuf[34]);
   buf dataout_buf35 (dataout[35], dataout_tbuf[35]);
   buf dataout_buf36 (dataout[36], dataout_tbuf[36]);
   buf dataout_buf37 (dataout[37], dataout_tbuf[37]);
   buf dataout_buf38 (dataout[38], dataout_tbuf[38]);
   buf dataout_buf39 (dataout[39], dataout_tbuf[39]);
   buf dataout_buf40 (dataout[40], dataout_tbuf[40]);
   buf dataout_buf41 (dataout[41], dataout_tbuf[41]);
   buf dataout_buf42 (dataout[42], dataout_tbuf[42]);
   buf dataout_buf43 (dataout[43], dataout_tbuf[43]);
   buf dataout_buf44 (dataout[44], dataout_tbuf[44]);
   buf dataout_buf45 (dataout[45], dataout_tbuf[45]);
   buf dataout_buf46 (dataout[46], dataout_tbuf[46]);
   buf dataout_buf47 (dataout[47], dataout_tbuf[47]);
   buf dataout_buf48 (dataout[48], dataout_tbuf[48]);
   buf dataout_buf49 (dataout[49], dataout_tbuf[49]);
   buf dataout_buf50 (dataout[50], dataout_tbuf[50]);
   buf dataout_buf51 (dataout[51], dataout_tbuf[51]);
   buf dataout_buf52 (dataout[52], dataout_tbuf[52]);
   buf dataout_buf53 (dataout[53], dataout_tbuf[53]);
   buf dataout_buf54 (dataout[54], dataout_tbuf[54]);
   buf dataout_buf55 (dataout[55], dataout_tbuf[55]);
   buf dataout_buf56 (dataout[56], dataout_tbuf[56]);
   buf dataout_buf57 (dataout[57], dataout_tbuf[57]);
   buf dataout_buf58 (dataout[58], dataout_tbuf[58]);
   buf dataout_buf59 (dataout[59], dataout_tbuf[59]);
   buf dataout_buf60 (dataout[60], dataout_tbuf[60]);
   buf dataout_buf61 (dataout[61], dataout_tbuf[61]);
   buf dataout_buf62 (dataout[62], dataout_tbuf[62]);
   buf dataout_buf63 (dataout[63], dataout_tbuf[63]);
   buf dataout_buf64 (dataout[64], dataout_tbuf[64]);
   buf dataout_buf65 (dataout[65], dataout_tbuf[65]);
   buf dataout_buf66 (dataout[66], dataout_tbuf[66]);
   buf dataout_buf67 (dataout[67], dataout_tbuf[67]);
   buf dataout_buf68 (dataout[68], dataout_tbuf[68]);
   buf dataout_buf69 (dataout[69], dataout_tbuf[69]);
   buf dataout_buf70 (dataout[70], dataout_tbuf[70]);
   buf dataout_buf71 (dataout[71], dataout_tbuf[71]);
   buf dataout_buf72 (dataout[72], dataout_tbuf[72]);
   buf dataout_buf73 (dataout[73], dataout_tbuf[73]);
   buf dataout_buf74 (dataout[74], dataout_tbuf[74]);
   buf dataout_buf75 (dataout[75], dataout_tbuf[75]);
   buf dataout_buf76 (dataout[76], dataout_tbuf[76]);
   buf dataout_buf77 (dataout[77], dataout_tbuf[77]);
   buf dataout_buf78 (dataout[78], dataout_tbuf[78]);
   buf dataout_buf79 (dataout[79], dataout_tbuf[79]);
   buf dataout_buf80 (dataout[80], dataout_tbuf[80]);
   buf dataout_buf81 (dataout[81], dataout_tbuf[81]);
   buf dataout_buf82 (dataout[82], dataout_tbuf[82]);
   buf dataout_buf83 (dataout[83], dataout_tbuf[83]);
   buf dataout_buf84 (dataout[84], dataout_tbuf[84]);
   buf dataout_buf85 (dataout[85], dataout_tbuf[85]);
   buf dataout_buf86 (dataout[86], dataout_tbuf[86]);
   buf dataout_buf87 (dataout[87], dataout_tbuf[87]);
   buf dataout_buf88 (dataout[88], dataout_tbuf[88]);
   buf dataout_buf89 (dataout[89], dataout_tbuf[89]);
   buf dataout_buf90 (dataout[90], dataout_tbuf[90]);
   buf dataout_buf91 (dataout[91], dataout_tbuf[91]);
   buf dataout_buf92 (dataout[92], dataout_tbuf[92]);
   buf dataout_buf93 (dataout[93], dataout_tbuf[93]);
   buf dataout_buf94 (dataout[94], dataout_tbuf[94]);
   buf dataout_buf95 (dataout[95], dataout_tbuf[95]);
   buf dataout_buf96 (dataout[96], dataout_tbuf[96]);
   buf dataout_buf97 (dataout[97], dataout_tbuf[97]);
   buf dataout_buf98 (dataout[98], dataout_tbuf[98]);
   buf dataout_buf99 (dataout[99], dataout_tbuf[99]);
   buf dataout_buf100 (dataout[100], dataout_tbuf[100]);
   buf dataout_buf101 (dataout[101], dataout_tbuf[101]);
   buf dataout_buf102 (dataout[102], dataout_tbuf[102]);
   buf dataout_buf103 (dataout[103], dataout_tbuf[103]);
   buf dataout_buf104 (dataout[104], dataout_tbuf[104]);
   buf dataout_buf105 (dataout[105], dataout_tbuf[105]);
   buf dataout_buf106 (dataout[106], dataout_tbuf[106]);
   buf dataout_buf107 (dataout[107], dataout_tbuf[107]);
   buf dataout_buf108 (dataout[108], dataout_tbuf[108]);
   buf dataout_buf109 (dataout[109], dataout_tbuf[109]);
   buf dataout_buf110 (dataout[110], dataout_tbuf[110]);
   buf dataout_buf111 (dataout[111], dataout_tbuf[111]);
   buf dataout_buf112 (dataout[112], dataout_tbuf[112]);
   buf dataout_buf113 (dataout[113], dataout_tbuf[113]);
   buf dataout_buf114 (dataout[114], dataout_tbuf[114]);
   buf dataout_buf115 (dataout[115], dataout_tbuf[115]);
   buf dataout_buf116 (dataout[116], dataout_tbuf[116]);
   buf dataout_buf117 (dataout[117], dataout_tbuf[117]);
   buf dataout_buf118 (dataout[118], dataout_tbuf[118]);
   buf dataout_buf119 (dataout[119], dataout_tbuf[119]);
   buf dataout_buf120 (dataout[120], dataout_tbuf[120]);
   buf dataout_buf121 (dataout[121], dataout_tbuf[121]);
   buf dataout_buf122 (dataout[122], dataout_tbuf[122]);
   buf dataout_buf123 (dataout[123], dataout_tbuf[123]);
   buf dataout_buf124 (dataout[124], dataout_tbuf[124]);
   buf dataout_buf125 (dataout[125], dataout_tbuf[125]);
   buf dataout_buf126 (dataout[126], dataout_tbuf[126]);
   buf dataout_buf127 (dataout[127], dataout_tbuf[127]);
   buf dataout_buf128 (dataout[128], dataout_tbuf[128]);
   buf dataout_buf129 (dataout[129], dataout_tbuf[129]);
   buf dataout_buf130 (dataout[130], dataout_tbuf[130]);
   buf dataout_buf131 (dataout[131], dataout_tbuf[131]);
   buf dataout_buf132 (dataout[132], dataout_tbuf[132]);
   buf dataout_buf133 (dataout[133], dataout_tbuf[133]);
   buf dataout_buf134 (dataout[134], dataout_tbuf[134]);
   buf dataout_buf135 (dataout[135], dataout_tbuf[135]);
   buf dataout_buf136 (dataout[136], dataout_tbuf[136]);
   buf dataout_buf137 (dataout[137], dataout_tbuf[137]);
   buf dataout_buf138 (dataout[138], dataout_tbuf[138]);
   buf dataout_buf139 (dataout[139], dataout_tbuf[139]);
   buf dataout_buf140 (dataout[140], dataout_tbuf[140]);
   buf dataout_buf141 (dataout[141], dataout_tbuf[141]);
   buf dataout_buf142 (dataout[142], dataout_tbuf[142]);
   buf dataout_buf143 (dataout[143], dataout_tbuf[143]);
   buf done_buf (done, done_tbuf);

   buf (clk_ipd, clk);
   buf (aclr_ipd, aclr);
   buf (ena_ipd, ena);
   buf (stall_ipd, stall);
   
   specify
      
      specparam TSU = 0;        // Set up time 
      specparam TH  = 0;        // Hold time
      specparam TCO = 0;        // Clock to Output time
      specparam TCLR = 0;       // Clear time
      specparam TCLR_MIN_PW = 0;// Minimum pulse width of clear
      specparam TPRE = 0; 	// Preset time
      specparam TPRE_MIN_PW = 0;// Minimum pulse width of preset
      specparam TCLK_MIN_PW = 0;// Minimum pulse width of clock
      specparam TCE_MIN_PW = 0; // Minimum pulse width of clock enable
      specparam TCLKL = 0; 	// Minimum clock low time
      specparam TCLKH = 0; 	// Minimum clock high time
      
      $setup  (data, posedge clk, 0, viol_notifier);
      $setup  (aclr, posedge clk, 0, viol_notifier); 
      $setup  (ena, posedge clk, 0, viol_notifier );
      $setup  (stall, posedge clk, 0, viol_notifier );
      $hold   (posedge clk, data, 0, viol_notifier);
      $hold   (posedge clk, aclr, 0, viol_notifier);
      $hold   (posedge clk, ena, 0, viol_notifier );
      $hold   (posedge clk, stall, 0, viol_notifier );
      
      (posedge aclr => (dataout  +: 'b0))         = (0,0);
      (posedge clk  => (dataout  +: dataout_tmp)) = (0,0); 
      (posedge clk  => (done     +: done_tbuf))   = (0,0);   
      
   endspecify

   always @(powerup)
     begin
	if(powerup == 1'b1)
	  begin
	     dataout_reg = ~(143'b0);
	     dataout_sreg = ~(143'b0);
	  end
	else if(powerup == 1'b0)
	  begin
	     dataout_reg = 'b0;
	     dataout_sreg = 'b0;
	  end
	else 
	  begin
	     dataout_reg = 'bX;
	     dataout_sreg = 'bX;
	  end
     end

   always @ (aclr_ipd)
     begin
	if(aclr_ipd && ena_ipd && ~stall_ipd)
	  aclrout_reg <= 1'b1;
	else
	  aclrout_reg <= 1'b0;
     end
   
   assign aclrout = (ifaclr == 1'b1) ? aclrout_reg : 1'b0;
   
   // SYNCHRONOUS RESET - REGISTER CONFIGURATION
   always @ (posedge clk_ipd or negedge devclrn or negedge devpor)
     begin
	if ((ifaclr && aclr_ipd) || ~devclrn || ~devpor)
	  begin
	     if((preset == "true") && (powerup == 1'b1))
		    dataout_sreg <= ~(143'b0);
		  else
		    dataout_sreg <= 'b0;
	       end
	else if (ifclk && clk_ipd && ifena && ena_ipd && ~stall_ipd)
	  begin
	     dataout_sreg <= data_ipd;
	  end
	else
	  begin
	     dataout_sreg <= dataout_sreg;
	  end
     end 
   
   // ASYNCHRONOUS RESET - REGISTER CONFIGURATION
   always @ (posedge clk_ipd or posedge aclr_ipd or 
	     negedge devclrn or negedge devpor)
      begin
	 if ((ifaclr && aclr_ipd) || ~devclrn || ~devpor)
	  begin
	     if((preset == "true") && (powerup == 1'b1))
		    dataout_reg <= ~(143'b0);
		  else
		    dataout_reg <= 'b0;
	       end
	 else if (ifclk && clk_ipd && ifena && ena_ipd && ~stall_ipd)
	   begin
	      dataout_reg <= data_ipd;
	   end
	 else
	   begin
	      dataout_reg <= dataout_reg;
	   end
      end
   
   // DONE REGISTER
   always @ (clk_ipd)
     begin
	if(clk_ipd && ena_ipd)	  
	  done_reg <= 1'b1;
	else
	  done_reg <= 1'b0;
	if(clk_ipd)
	  clk_dly <= 1'b1;
	else
	  clk_dly <= 1'b0;
     end
   
   assign clkout = clk_dly;
   
   // DONE DELTA TICK
   always @ (done_reg)
     begin
	done_delta <= done_reg;
     end
   
   assign dataout_tmp  = (ifclk ? ((sclr == "true") ? 
				    dataout_sreg : dataout_reg) : data_ipd);
   assign dataout_tbuf = dataout_tmp;
   assign done_tbuf    = done_delta;	  
   
endmodule // stratixii_ram_register

///////////////////////////////////////////////////////////////////////////////
//
//                            STRATIXII_RAM_CLEAR
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
  module stratixii_ram_clear 
    (
     aclr, 
     d, 
     clk,
     ena,
     edg,
     q
     );
   
   input d;
   input aclr;
   input clk;
   input ena;
   input edg;
   output q;
   
   reg 	  q_tmp;
   reg 	  valid;
      
   always @ (clk or ena)
     begin
	if(edg == 1'b0)
	  begin
	     if (~clk && d && ena)
	       valid <= 1'b1;
	     else
	       valid <= 1'b0;
	  end
	else
	  begin
	     if (clk && d)
	       valid <= 1'b1;
	     else
	       valid <= 1'b0;
	  end	
     end
   
   always @ (valid or aclr)
     begin
	if(valid && aclr)
	  q_tmp <= 1'b1;
	else
	  q_tmp <= 1'b0;
     end
   
   assign q = q_tmp;
   
endmodule 

///////////////////////////////////////////////////////////////////////////////
//
//                             STRATIXII_RAM_INTERNAL
//
///////////////////////////////////////////////////////////////////////////////

  module stratixii_ram_internal
    (
     portawriteenable, 
     portbwriteenable,
     cleara,
     clearb,
     portadatain, 
     portbdatain,
     portaaddress, 
     portbaddress,
     portabyteenamask, 
     portbbyteenamask,
     portbreadenable,
     portaclock,
     portbclock,
     sameclock,
     portadataout, 
     portbdataout
     );
   
   parameter operation_mode = "single_port";
   parameter ram_block_type = "M512";
   parameter mixed_port_feed_through_mode = "dont_care";
   parameter port_a_data_width = 16;
   parameter port_b_data_width = 16;
   parameter port_a_address_width = 16;
   parameter port_b_address_width = 16;
   parameter port_a_byte_enable_mask_width = 16;
   parameter port_b_byte_enable_mask_width = 16;
   parameter init_file_layout = "none";
   parameter port_a_first_address = 0;
   parameter port_a_last_address = 4096;
   parameter port_b_first_address = 0;
   parameter port_b_last_address = 4096;
   parameter port_a_address_clear = "none";
   parameter port_b_address_clear = "none";
   parameter power_up_uninitialized = "false";
   parameter mem1 = 512'b0;
   parameter mem2 = 512'b0;
   parameter mem3 = 512'b0;
   parameter mem4 = 512'b0;
   parameter mem5 = 512'b0;
   parameter mem6 = 512'b0;
   parameter mem7 = 512'b0;
   parameter mem8 = 512'b0;
   parameter mem9 = 512'b0;
   
   input     portawriteenable;
   input     portbwriteenable;
   input     cleara;
   input     clearb;
   input [143:0] portadatain;
   input [71:0] portbdatain;
   input [15:0]  portaaddress;
   input [15:0]  portbaddress;
   input [15:0]  portabyteenamask;
   input [15:0]  portbbyteenamask;
   input 	 portbreadenable;
   input 	 portaclock;
   input 	 portbclock;
   input 	 sameclock;
   output [143:0] portadataout;
   output [143:0] portbdataout;
   reg [143:0] 	  portadataout_tmp;
   reg [143:0] 	  portbdataout_tmp;
   reg [4607:0] tmp_mem;
   reg [589823:0] mem;
   reg 		  wr_a;
   reg 		  wr_b;
   wire [143:0]   portadataout_tbuf;
   wire [143:0]   portbdataout_tbuf;
   
   integer 	  i,l,j,k;
   integer 	  depth;
   integer 	  index;
   
   specify
      (portawriteenable *> portadataout) = (0,0);
      (portbwriteenable *> portbdataout) = (0,0);
      (portadatain *> portadataout) = (0,0);
      (portbdatain *> portbdataout) = (0,0); 
      (portaaddress *> portadataout) = (0,0);
      (portbaddress *> portbdataout) = (0,0);
      (portabyteenamask *> portadataout) = (0,0);
      (portbbyteenamask *> portbdataout) = (0,0);
      (portbreadenable *> portbdataout) = (0,0);
   endspecify
   
   buf portadataout_buf0 (portadataout[0], portadataout_tbuf[0]);
   buf portadataout_buf1 (portadataout[1], portadataout_tbuf[1]);
   buf portadataout_buf2 (portadataout[2], portadataout_tbuf[2]);
   buf portadataout_buf3 (portadataout[3], portadataout_tbuf[3]);
   buf portadataout_buf4 (portadataout[4], portadataout_tbuf[4]);
   buf portadataout_buf5 (portadataout[5], portadataout_tbuf[5]);
   buf portadataout_buf6 (portadataout[6], portadataout_tbuf[6]);
   buf portadataout_buf7 (portadataout[7], portadataout_tbuf[7]);
   buf portadataout_buf8 (portadataout[8], portadataout_tbuf[8]);
   buf portadataout_buf9 (portadataout[9], portadataout_tbuf[9]);
   buf portadataout_buf10 (portadataout[10], portadataout_tbuf[10]);
   buf portadataout_buf11 (portadataout[11], portadataout_tbuf[11]);
   buf portadataout_buf12 (portadataout[12], portadataout_tbuf[12]);
   buf portadataout_buf13 (portadataout[13], portadataout_tbuf[13]);
   buf portadataout_buf14 (portadataout[14], portadataout_tbuf[14]);
   buf portadataout_buf15 (portadataout[15], portadataout_tbuf[15]);
   buf portadataout_buf16 (portadataout[16], portadataout_tbuf[16]);
   buf portadataout_buf17 (portadataout[17], portadataout_tbuf[17]);
   buf portadataout_buf18 (portadataout[18], portadataout_tbuf[18]);
   buf portadataout_buf19 (portadataout[19], portadataout_tbuf[19]);
   buf portadataout_buf20 (portadataout[20], portadataout_tbuf[20]);
   buf portadataout_buf21 (portadataout[21], portadataout_tbuf[21]);
   buf portadataout_buf22 (portadataout[22], portadataout_tbuf[22]);
   buf portadataout_buf23 (portadataout[23], portadataout_tbuf[23]);
   buf portadataout_buf24 (portadataout[24], portadataout_tbuf[24]);
   buf portadataout_buf25 (portadataout[25], portadataout_tbuf[25]);
   buf portadataout_buf26 (portadataout[26], portadataout_tbuf[26]);
   buf portadataout_buf27 (portadataout[27], portadataout_tbuf[27]);
   buf portadataout_buf28 (portadataout[28], portadataout_tbuf[28]);
   buf portadataout_buf29 (portadataout[29], portadataout_tbuf[29]);
   buf portadataout_buf30 (portadataout[30], portadataout_tbuf[30]);
   buf portadataout_buf31 (portadataout[31], portadataout_tbuf[31]);
   buf portadataout_buf32 (portadataout[32], portadataout_tbuf[32]);
   buf portadataout_buf33 (portadataout[33], portadataout_tbuf[33]);
   buf portadataout_buf34 (portadataout[34], portadataout_tbuf[34]);
   buf portadataout_buf35 (portadataout[35], portadataout_tbuf[35]);
   buf portadataout_buf36 (portadataout[36], portadataout_tbuf[36]);
   buf portadataout_buf37 (portadataout[37], portadataout_tbuf[37]);
   buf portadataout_buf38 (portadataout[38], portadataout_tbuf[38]);
   buf portadataout_buf39 (portadataout[39], portadataout_tbuf[39]);
   buf portadataout_buf40 (portadataout[40], portadataout_tbuf[40]);
   buf portadataout_buf41 (portadataout[41], portadataout_tbuf[41]);
   buf portadataout_buf42 (portadataout[42], portadataout_tbuf[42]);
   buf portadataout_buf43 (portadataout[43], portadataout_tbuf[43]);
   buf portadataout_buf44 (portadataout[44], portadataout_tbuf[44]);
   buf portadataout_buf45 (portadataout[45], portadataout_tbuf[45]);
   buf portadataout_buf46 (portadataout[46], portadataout_tbuf[46]);
   buf portadataout_buf47 (portadataout[47], portadataout_tbuf[47]);
   buf portadataout_buf48 (portadataout[48], portadataout_tbuf[48]);
   buf portadataout_buf49 (portadataout[49], portadataout_tbuf[49]);
   buf portadataout_buf50 (portadataout[50], portadataout_tbuf[50]);
   buf portadataout_buf51 (portadataout[51], portadataout_tbuf[51]);
   buf portadataout_buf52 (portadataout[52], portadataout_tbuf[52]);
   buf portadataout_buf53 (portadataout[53], portadataout_tbuf[53]);
   buf portadataout_buf54 (portadataout[54], portadataout_tbuf[54]);
   buf portadataout_buf55 (portadataout[55], portadataout_tbuf[55]);
   buf portadataout_buf56 (portadataout[56], portadataout_tbuf[56]);
   buf portadataout_buf57 (portadataout[57], portadataout_tbuf[57]);
   buf portadataout_buf58 (portadataout[58], portadataout_tbuf[58]);
   buf portadataout_buf59 (portadataout[59], portadataout_tbuf[59]);
   buf portadataout_buf60 (portadataout[60], portadataout_tbuf[60]);
   buf portadataout_buf61 (portadataout[61], portadataout_tbuf[61]);
   buf portadataout_buf62 (portadataout[62], portadataout_tbuf[62]);
   buf portadataout_buf63 (portadataout[63], portadataout_tbuf[63]);
   buf portadataout_buf64 (portadataout[64], portadataout_tbuf[64]);
   buf portadataout_buf65 (portadataout[65], portadataout_tbuf[65]);
   buf portadataout_buf66 (portadataout[66], portadataout_tbuf[66]);
   buf portadataout_buf67 (portadataout[67], portadataout_tbuf[67]);
   buf portadataout_buf68 (portadataout[68], portadataout_tbuf[68]);
   buf portadataout_buf69 (portadataout[69], portadataout_tbuf[69]);
   buf portadataout_buf70 (portadataout[70], portadataout_tbuf[70]);
   buf portadataout_buf71 (portadataout[71], portadataout_tbuf[71]);
   buf portadataout_buf72 (portadataout[72], portadataout_tbuf[72]);
   buf portadataout_buf73 (portadataout[73], portadataout_tbuf[73]);
   buf portadataout_buf74 (portadataout[74], portadataout_tbuf[74]);
   buf portadataout_buf75 (portadataout[75], portadataout_tbuf[75]);
   buf portadataout_buf76 (portadataout[76], portadataout_tbuf[76]);
   buf portadataout_buf77 (portadataout[77], portadataout_tbuf[77]);
   buf portadataout_buf78 (portadataout[78], portadataout_tbuf[78]);
   buf portadataout_buf79 (portadataout[79], portadataout_tbuf[79]);
   buf portadataout_buf80 (portadataout[80], portadataout_tbuf[80]);
   buf portadataout_buf81 (portadataout[81], portadataout_tbuf[81]);
   buf portadataout_buf82 (portadataout[82], portadataout_tbuf[82]);
   buf portadataout_buf83 (portadataout[83], portadataout_tbuf[83]);
   buf portadataout_buf84 (portadataout[84], portadataout_tbuf[84]);
   buf portadataout_buf85 (portadataout[85], portadataout_tbuf[85]);
   buf portadataout_buf86 (portadataout[86], portadataout_tbuf[86]);
   buf portadataout_buf87 (portadataout[87], portadataout_tbuf[87]);
   buf portadataout_buf88 (portadataout[88], portadataout_tbuf[88]);
   buf portadataout_buf89 (portadataout[89], portadataout_tbuf[89]);
   buf portadataout_buf90 (portadataout[90], portadataout_tbuf[90]);
   buf portadataout_buf91 (portadataout[91], portadataout_tbuf[91]);
   buf portadataout_buf92 (portadataout[92], portadataout_tbuf[92]);
   buf portadataout_buf93 (portadataout[93], portadataout_tbuf[93]);
   buf portadataout_buf94 (portadataout[94], portadataout_tbuf[94]);
   buf portadataout_buf95 (portadataout[95], portadataout_tbuf[95]);
   buf portadataout_buf96 (portadataout[96], portadataout_tbuf[96]);
   buf portadataout_buf97 (portadataout[97], portadataout_tbuf[97]);
   buf portadataout_buf98 (portadataout[98], portadataout_tbuf[98]);
   buf portadataout_buf99 (portadataout[99], portadataout_tbuf[99]);
   buf portadataout_buf100 (portadataout[100], portadataout_tbuf[100]);
   buf portadataout_buf101 (portadataout[101], portadataout_tbuf[101]);
   buf portadataout_buf102 (portadataout[102], portadataout_tbuf[102]);
   buf portadataout_buf103 (portadataout[103], portadataout_tbuf[103]);
   buf portadataout_buf104 (portadataout[104], portadataout_tbuf[104]);
   buf portadataout_buf105 (portadataout[105], portadataout_tbuf[105]);
   buf portadataout_buf106 (portadataout[106], portadataout_tbuf[106]);
   buf portadataout_buf107 (portadataout[107], portadataout_tbuf[107]);
   buf portadataout_buf108 (portadataout[108], portadataout_tbuf[108]);
   buf portadataout_buf109 (portadataout[109], portadataout_tbuf[109]);
   buf portadataout_buf110 (portadataout[110], portadataout_tbuf[110]);
   buf portadataout_buf111 (portadataout[111], portadataout_tbuf[111]);
   buf portadataout_buf112 (portadataout[112], portadataout_tbuf[112]);
   buf portadataout_buf113 (portadataout[113], portadataout_tbuf[113]);
   buf portadataout_buf114 (portadataout[114], portadataout_tbuf[114]);
   buf portadataout_buf115 (portadataout[115], portadataout_tbuf[115]);
   buf portadataout_buf116 (portadataout[116], portadataout_tbuf[116]);
   buf portadataout_buf117 (portadataout[117], portadataout_tbuf[117]);
   buf portadataout_buf118 (portadataout[118], portadataout_tbuf[118]);
   buf portadataout_buf119 (portadataout[119], portadataout_tbuf[119]);
   buf portadataout_buf120 (portadataout[120], portadataout_tbuf[120]);
   buf portadataout_buf121 (portadataout[121], portadataout_tbuf[121]);
   buf portadataout_buf122 (portadataout[122], portadataout_tbuf[122]);
   buf portadataout_buf123 (portadataout[123], portadataout_tbuf[123]);
   buf portadataout_buf124 (portadataout[124], portadataout_tbuf[124]);
   buf portadataout_buf125 (portadataout[125], portadataout_tbuf[125]);
   buf portadataout_buf126 (portadataout[126], portadataout_tbuf[126]);
   buf portadataout_buf127 (portadataout[127], portadataout_tbuf[127]);
   buf portadataout_buf128 (portadataout[128], portadataout_tbuf[128]);
   buf portadataout_buf129 (portadataout[129], portadataout_tbuf[129]);
   buf portadataout_buf130 (portadataout[130], portadataout_tbuf[130]);
   buf portadataout_buf131 (portadataout[131], portadataout_tbuf[131]);
   buf portadataout_buf132 (portadataout[132], portadataout_tbuf[132]);
   buf portadataout_buf133 (portadataout[133], portadataout_tbuf[133]);
   buf portadataout_buf134 (portadataout[134], portadataout_tbuf[134]);
   buf portadataout_buf135 (portadataout[135], portadataout_tbuf[135]);
   buf portadataout_buf136 (portadataout[136], portadataout_tbuf[136]);
   buf portadataout_buf137 (portadataout[137], portadataout_tbuf[137]);
   buf portadataout_buf138 (portadataout[138], portadataout_tbuf[138]);
   buf portadataout_buf139 (portadataout[139], portadataout_tbuf[139]);
   buf portadataout_buf140 (portadataout[140], portadataout_tbuf[140]);
   buf portadataout_buf141 (portadataout[141], portadataout_tbuf[141]);
   buf portadataout_buf142 (portadataout[142], portadataout_tbuf[142]);
   buf portadataout_buf143 (portadataout[143], portadataout_tbuf[143]);
  
   buf portbdataout_buf0 (portbdataout[0], portbdataout_tbuf[0]);
   buf portbdataout_buf1 (portbdataout[1], portbdataout_tbuf[1]);
   buf portbdataout_buf2 (portbdataout[2], portbdataout_tbuf[2]);
   buf portbdataout_buf3 (portbdataout[3], portbdataout_tbuf[3]);
   buf portbdataout_buf4 (portbdataout[4], portbdataout_tbuf[4]);
   buf portbdataout_buf5 (portbdataout[5], portbdataout_tbuf[5]);
   buf portbdataout_buf6 (portbdataout[6], portbdataout_tbuf[6]);
   buf portbdataout_buf7 (portbdataout[7], portbdataout_tbuf[7]);
   buf portbdataout_buf8 (portbdataout[8], portbdataout_tbuf[8]);
   buf portbdataout_buf9 (portbdataout[9], portbdataout_tbuf[9]);
   buf portbdataout_buf10 (portbdataout[10], portbdataout_tbuf[10]);
   buf portbdataout_buf11 (portbdataout[11], portbdataout_tbuf[11]);
   buf portbdataout_buf12 (portbdataout[12], portbdataout_tbuf[12]);
   buf portbdataout_buf13 (portbdataout[13], portbdataout_tbuf[13]);
   buf portbdataout_buf14 (portbdataout[14], portbdataout_tbuf[14]);
   buf portbdataout_buf15 (portbdataout[15], portbdataout_tbuf[15]);
   buf portbdataout_buf16 (portbdataout[16], portbdataout_tbuf[16]);
   buf portbdataout_buf17 (portbdataout[17], portbdataout_tbuf[17]);
   buf portbdataout_buf18 (portbdataout[18], portbdataout_tbuf[18]);
   buf portbdataout_buf19 (portbdataout[19], portbdataout_tbuf[19]);
   buf portbdataout_buf20 (portbdataout[20], portbdataout_tbuf[20]);
   buf portbdataout_buf21 (portbdataout[21], portbdataout_tbuf[21]);
   buf portbdataout_buf22 (portbdataout[22], portbdataout_tbuf[22]);
   buf portbdataout_buf23 (portbdataout[23], portbdataout_tbuf[23]);
   buf portbdataout_buf24 (portbdataout[24], portbdataout_tbuf[24]);
   buf portbdataout_buf25 (portbdataout[25], portbdataout_tbuf[25]);
   buf portbdataout_buf26 (portbdataout[26], portbdataout_tbuf[26]);
   buf portbdataout_buf27 (portbdataout[27], portbdataout_tbuf[27]);
   buf portbdataout_buf28 (portbdataout[28], portbdataout_tbuf[28]);
   buf portbdataout_buf29 (portbdataout[29], portbdataout_tbuf[29]);
   buf portbdataout_buf30 (portbdataout[30], portbdataout_tbuf[30]);
   buf portbdataout_buf31 (portbdataout[31], portbdataout_tbuf[31]);
   buf portbdataout_buf32 (portbdataout[32], portbdataout_tbuf[32]);
   buf portbdataout_buf33 (portbdataout[33], portbdataout_tbuf[33]);
   buf portbdataout_buf34 (portbdataout[34], portbdataout_tbuf[34]);
   buf portbdataout_buf35 (portbdataout[35], portbdataout_tbuf[35]);
   buf portbdataout_buf36 (portbdataout[36], portbdataout_tbuf[36]);
   buf portbdataout_buf37 (portbdataout[37], portbdataout_tbuf[37]);
   buf portbdataout_buf38 (portbdataout[38], portbdataout_tbuf[38]);
   buf portbdataout_buf39 (portbdataout[39], portbdataout_tbuf[39]);
   buf portbdataout_buf40 (portbdataout[40], portbdataout_tbuf[40]);
   buf portbdataout_buf41 (portbdataout[41], portbdataout_tbuf[41]);
   buf portbdataout_buf42 (portbdataout[42], portbdataout_tbuf[42]);
   buf portbdataout_buf43 (portbdataout[43], portbdataout_tbuf[43]);
   buf portbdataout_buf44 (portbdataout[44], portbdataout_tbuf[44]);
   buf portbdataout_buf45 (portbdataout[45], portbdataout_tbuf[45]);
   buf portbdataout_buf46 (portbdataout[46], portbdataout_tbuf[46]);
   buf portbdataout_buf47 (portbdataout[47], portbdataout_tbuf[47]);
   buf portbdataout_buf48 (portbdataout[48], portbdataout_tbuf[48]);
   buf portbdataout_buf49 (portbdataout[49], portbdataout_tbuf[49]);
   buf portbdataout_buf50 (portbdataout[50], portbdataout_tbuf[50]);
   buf portbdataout_buf51 (portbdataout[51], portbdataout_tbuf[51]);
   buf portbdataout_buf52 (portbdataout[52], portbdataout_tbuf[52]);
   buf portbdataout_buf53 (portbdataout[53], portbdataout_tbuf[53]);
   buf portbdataout_buf54 (portbdataout[54], portbdataout_tbuf[54]);
   buf portbdataout_buf55 (portbdataout[55], portbdataout_tbuf[55]);
   buf portbdataout_buf56 (portbdataout[56], portbdataout_tbuf[56]);
   buf portbdataout_buf57 (portbdataout[57], portbdataout_tbuf[57]);
   buf portbdataout_buf58 (portbdataout[58], portbdataout_tbuf[58]);
   buf portbdataout_buf59 (portbdataout[59], portbdataout_tbuf[59]);
   buf portbdataout_buf60 (portbdataout[60], portbdataout_tbuf[60]);
   buf portbdataout_buf61 (portbdataout[61], portbdataout_tbuf[61]);
   buf portbdataout_buf62 (portbdataout[62], portbdataout_tbuf[62]);
   buf portbdataout_buf63 (portbdataout[63], portbdataout_tbuf[63]);
   buf portbdataout_buf64 (portbdataout[64], portbdataout_tbuf[64]);
   buf portbdataout_buf65 (portbdataout[65], portbdataout_tbuf[65]);
   buf portbdataout_buf66 (portbdataout[66], portbdataout_tbuf[66]);
   buf portbdataout_buf67 (portbdataout[67], portbdataout_tbuf[67]);
   buf portbdataout_buf68 (portbdataout[68], portbdataout_tbuf[68]);
   buf portbdataout_buf69 (portbdataout[69], portbdataout_tbuf[69]);
   buf portbdataout_buf70 (portbdataout[70], portbdataout_tbuf[70]);
   buf portbdataout_buf71 (portbdataout[71], portbdataout_tbuf[71]);
   buf portbdataout_buf72 (portbdataout[72], portbdataout_tbuf[72]);
   buf portbdataout_buf73 (portbdataout[73], portbdataout_tbuf[73]);
   buf portbdataout_buf74 (portbdataout[74], portbdataout_tbuf[74]);
   buf portbdataout_buf75 (portbdataout[75], portbdataout_tbuf[75]);
   buf portbdataout_buf76 (portbdataout[76], portbdataout_tbuf[76]);
   buf portbdataout_buf77 (portbdataout[77], portbdataout_tbuf[77]);
   buf portbdataout_buf78 (portbdataout[78], portbdataout_tbuf[78]);
   buf portbdataout_buf79 (portbdataout[79], portbdataout_tbuf[79]);
   buf portbdataout_buf80 (portbdataout[80], portbdataout_tbuf[80]);
   buf portbdataout_buf81 (portbdataout[81], portbdataout_tbuf[81]);
   buf portbdataout_buf82 (portbdataout[82], portbdataout_tbuf[82]);
   buf portbdataout_buf83 (portbdataout[83], portbdataout_tbuf[83]);
   buf portbdataout_buf84 (portbdataout[84], portbdataout_tbuf[84]);
   buf portbdataout_buf85 (portbdataout[85], portbdataout_tbuf[85]);
   buf portbdataout_buf86 (portbdataout[86], portbdataout_tbuf[86]);
   buf portbdataout_buf87 (portbdataout[87], portbdataout_tbuf[87]);
   buf portbdataout_buf88 (portbdataout[88], portbdataout_tbuf[88]);
   buf portbdataout_buf89 (portbdataout[89], portbdataout_tbuf[89]);
   buf portbdataout_buf90 (portbdataout[90], portbdataout_tbuf[90]);
   buf portbdataout_buf91 (portbdataout[91], portbdataout_tbuf[91]);
   buf portbdataout_buf92 (portbdataout[92], portbdataout_tbuf[92]);
   buf portbdataout_buf93 (portbdataout[93], portbdataout_tbuf[93]);
   buf portbdataout_buf94 (portbdataout[94], portbdataout_tbuf[94]);
   buf portbdataout_buf95 (portbdataout[95], portbdataout_tbuf[95]);
   buf portbdataout_buf96 (portbdataout[96], portbdataout_tbuf[96]);
   buf portbdataout_buf97 (portbdataout[97], portbdataout_tbuf[97]);
   buf portbdataout_buf98 (portbdataout[98], portbdataout_tbuf[98]);
   buf portbdataout_buf99 (portbdataout[99], portbdataout_tbuf[99]);
   buf portbdataout_buf100 (portbdataout[100], portbdataout_tbuf[100]);
   buf portbdataout_buf101 (portbdataout[101], portbdataout_tbuf[101]);
   buf portbdataout_buf102 (portbdataout[102], portbdataout_tbuf[102]);
   buf portbdataout_buf103 (portbdataout[103], portbdataout_tbuf[103]);
   buf portbdataout_buf104 (portbdataout[104], portbdataout_tbuf[104]);
   buf portbdataout_buf105 (portbdataout[105], portbdataout_tbuf[105]);
   buf portbdataout_buf106 (portbdataout[106], portbdataout_tbuf[106]);
   buf portbdataout_buf107 (portbdataout[107], portbdataout_tbuf[107]);
   buf portbdataout_buf108 (portbdataout[108], portbdataout_tbuf[108]);
   buf portbdataout_buf109 (portbdataout[109], portbdataout_tbuf[109]);
   buf portbdataout_buf110 (portbdataout[110], portbdataout_tbuf[110]);
   buf portbdataout_buf111 (portbdataout[111], portbdataout_tbuf[111]);
   buf portbdataout_buf112 (portbdataout[112], portbdataout_tbuf[112]);
   buf portbdataout_buf113 (portbdataout[113], portbdataout_tbuf[113]);
   buf portbdataout_buf114 (portbdataout[114], portbdataout_tbuf[114]);
   buf portbdataout_buf115 (portbdataout[115], portbdataout_tbuf[115]);
   buf portbdataout_buf116 (portbdataout[116], portbdataout_tbuf[116]);
   buf portbdataout_buf117 (portbdataout[117], portbdataout_tbuf[117]);
   buf portbdataout_buf118 (portbdataout[118], portbdataout_tbuf[118]);
   buf portbdataout_buf119 (portbdataout[119], portbdataout_tbuf[119]);
   buf portbdataout_buf120 (portbdataout[120], portbdataout_tbuf[120]);
   buf portbdataout_buf121 (portbdataout[121], portbdataout_tbuf[121]);
   buf portbdataout_buf122 (portbdataout[122], portbdataout_tbuf[122]);
   buf portbdataout_buf123 (portbdataout[123], portbdataout_tbuf[123]);
   buf portbdataout_buf124 (portbdataout[124], portbdataout_tbuf[124]);
   buf portbdataout_buf125 (portbdataout[125], portbdataout_tbuf[125]);
   buf portbdataout_buf126 (portbdataout[126], portbdataout_tbuf[126]);
   buf portbdataout_buf127 (portbdataout[127], portbdataout_tbuf[127]);
   buf portbdataout_buf128 (portbdataout[128], portbdataout_tbuf[128]);
   buf portbdataout_buf129 (portbdataout[129], portbdataout_tbuf[129]);
   buf portbdataout_buf130 (portbdataout[130], portbdataout_tbuf[130]);
   buf portbdataout_buf131 (portbdataout[131], portbdataout_tbuf[131]);
   buf portbdataout_buf132 (portbdataout[132], portbdataout_tbuf[132]);
   buf portbdataout_buf133 (portbdataout[133], portbdataout_tbuf[133]);
   buf portbdataout_buf134 (portbdataout[134], portbdataout_tbuf[134]);
   buf portbdataout_buf135 (portbdataout[135], portbdataout_tbuf[135]);
   buf portbdataout_buf136 (portbdataout[136], portbdataout_tbuf[136]);
   buf portbdataout_buf137 (portbdataout[137], portbdataout_tbuf[137]);
   buf portbdataout_buf138 (portbdataout[138], portbdataout_tbuf[138]);
   buf portbdataout_buf139 (portbdataout[139], portbdataout_tbuf[139]);
   buf portbdataout_buf140 (portbdataout[140], portbdataout_tbuf[140]);
   buf portbdataout_buf141 (portbdataout[141], portbdataout_tbuf[141]);
   buf portbdataout_buf142 (portbdataout[142], portbdataout_tbuf[142]);
   buf portbdataout_buf143 (portbdataout[143], portbdataout_tbuf[143]);

   initial
     begin
	tmp_mem = {mem9, mem8, mem7, mem6, mem5, mem4, mem3, mem2, mem1};

   if (power_up_uninitialized == "true")
   begin
	    mem = 'bX;
	    portadataout_tmp = 'bX;
     	 portbdataout_tmp = 'bX;
   end
	else if(init_file_layout == "none")
	  begin
	      if (ram_block_type == "M-RAM" || ram_block_type == "m-ram" ||
	          ram_block_type == "MegaRAM" ||
	         (mixed_port_feed_through_mode == "dont_care" && 
	          ram_block_type == "auto"))
            begin
	       mem = 'bX;
	            portadataout_tmp = 'bX;
	            portbdataout_tmp = 'bX;
            end
	      else
            begin
	           mem = 'b0;
	           portadataout_tmp = 'b0;
	           portbdataout_tmp = 'b0;
            end
	  end
	else
	  begin
	     mem = 'b0;
	     if(init_file_layout == "port_b")
	       begin
		  l = 0;
		  depth = port_b_last_address - port_b_first_address + 1;
		  for (j = 0; j < depth; j = j + 1)
		    begin
		       for (k = 0; k < port_b_data_width; k = k + 1)
			 begin
			    index = j + (depth * k);
			    mem[l] = tmp_mem[index];
			    l = l + 1;
			 end
		    end 
	       end
	     else if (init_file_layout == "port_a")
	       begin
		  l = 0;
		  depth = port_a_last_address - port_a_first_address + 1;	 
		  for (j = 0; j < depth; j = j + 1)
		    begin
		       for (k = 0; k < port_a_data_width; k = k + 1)
			 begin
			    index = j + (depth * k);
			    mem[l] = tmp_mem[index];
			    l = l + 1;
			 end
		    end 
	       end  
	portadataout_tmp = 'b0;
	portbdataout_tmp = 'b0;
     end
     end
   
   assign portadataout_tbuf = portadataout_tmp;
   assign portbdataout_tbuf = portbdataout_tmp;
   
   // PORT A
   always @ (portaclock)
     begin
	case (operation_mode)
	  "single_port":
	    begin
	       if (portawriteenable) 
		 begin // WRITE: mem[portaaddress] = portadatani
		    if(~portaclock)
		      wr_a <= 1'b1;
		    else if(portaclock)
		      begin
			 wr_a <= 1'b0;
			 for (i = 0; i < port_a_data_width; i = i + 1)
			   if(portabyteenamask[
			   i/(port_a_data_width
				  /port_a_byte_enable_mask_width)] == 1'b0)
			     portadataout_tmp[i] = 1'bX;
			   else
			     portadataout_tmp[i] = portadatain[i];
		      end
		 end 
	       else if(~portawriteenable)
		 begin // READ: portadataout = mem[portaaddress]
		    wr_a <= 1'b0;
		    if(portaclock)
		      begin
			 for (i = 0; i < port_a_data_width; i = i + 1)
			   portadataout_tmp[i] = 
				  mem[portaaddress*port_a_data_width + i];
		      end
		 end 
	    end // case: "single_port"
	  "dual_port":
	    begin
	       if(portawriteenable)
		 // WRITE: mem[portaaddress] =  portadatain;
		 begin
		    if(sameclock == 1'b1 && 
		       (ram_block_type == "MegaRAM" || 
			ram_block_type == "M-RAM" || 
			ram_block_type == "m-ram" ||
			(ram_block_type == "auto" && 
			 mixed_port_feed_through_mode == "dont_care")))
		      begin
			 // WRITE: mem[portaaddress] =  portadatain;
			 if(portaclock)
			   wr_a <= 1'b1;
			 else
			   wr_a <= 1'b0;
		      end
		    else
		      begin
			 // WRITE: mem[portaaddress] =  portadatain;
			 if((ram_block_type != "MegaRAM") && 
			    (ram_block_type != "M-RAM") && 
			    (ram_block_type != "m-ram") &&
			    ((ram_block_type != "auto") || 
			     (mixed_port_feed_through_mode != "dont_care"))) 
			   begin 
			      if(~portaclock)
				wr_a <= 1'b1;
			      else
				wr_a <= 1'b0;
			   end 
			 else
			   begin 
			      if(portaclock)
				wr_a <= 1'b1;
			      else
				wr_a <= 1'b0;
			   end
		      end 
		 end
	       else
		 wr_a <= 1'b0;
	    end // case: "dual_port"
	  "bidir_dual_port":
	    if(~portawriteenable)
	      begin
		 wr_a <= 1'b0;
		 //  READ: portadataout = mem[portaaddress]
		 if(sameclock == 1'b1 && portbwriteenable &&
		    (ram_block_type == "MegaRAM" || 
		     ram_block_type == "M-RAM" || 
		     ram_block_type == "m-ram" || 
		     (ram_block_type == "auto" && 
		      mixed_port_feed_through_mode == "dont_care")))
		   begin
		      if(portaclock)
			begin
			   if(
			      (((portaaddress*port_a_data_width) < 
				(portbaddress*port_b_data_width)) && 
			       (((portaaddress*port_a_data_width) 
				 + port_a_data_width-1) 
				< (portbaddress*port_b_data_width))) ||
			      (((portaaddress*port_a_data_width) > 
				(portbaddress*port_b_data_width)) && 
			       (((portbaddress*port_b_data_width) 
				 + port_b_data_width-1) < 
				(portaaddress*port_a_data_width)))
			      )
			     begin
				for (i = 0; i < port_a_data_width; i = i + 1)
				  begin
				     portadataout_tmp[i] 
				    = mem[portaaddress*port_a_data_width + i];
				  end
			     end
			   else
			     begin
				for (i = 0; i < port_a_data_width; i = i + 1)
				  begin
				     if((portaaddress*port_a_data_width) <= 
					(portbaddress*port_b_data_width))
				       begin
					  if((((portaaddress*port_a_data_width) + i) >= 
					      (portbaddress*port_b_data_width)) && 
					     ((portaaddress*port_a_data_width) + i < 
					      ((portbaddress*port_b_data_width) + 
					       port_b_data_width)))
					    begin
					       portadataout_tmp[i] = 1'bX;
					    end
					  else
					    begin
					       portadataout_tmp[i] 
					      = mem[portaaddress*port_a_data_width + i];
					    end
				       end
				     else
				       begin
					  if(((portaaddress*port_a_data_width) + i) <= 
					     ((portbaddress*port_b_data_width) + 
					      port_b_data_width))
					    begin
					       portadataout_tmp[i] = 1'bX;
					    end
					  else
					    begin
					       portadataout_tmp[i] 
					      = mem[portaaddress*port_a_data_width + i];
					    end
				       end
				  end
			     end 
			end
		   end 
		 else
		   begin // READ: portadataout = mem[portaaddress];
		      if(portaclock)
			begin
			   for (i = 0; i < port_a_data_width; i = i + 1)
			     portadataout_tmp[i] = 
				    mem[portaaddress*port_a_data_width + i];
			end 
		   end 
	      end 
	    else if(portawriteenable)
	      begin // WRITE: mem[portaaddress] = portadatain
		 if(sameclock == 1'b1 && portbwriteenable && 
		    (ram_block_type == "MegaRAM" || 
		     ram_block_type == "M-RAM" || 
		     ram_block_type == "m-ram" || 
		     (ram_block_type == "auto" && 
		      mixed_port_feed_through_mode == "dont_care")))
		   begin
		      if(portaclock)
			begin
			   wr_a = 1'b1;
			   if(
			      (((portaaddress*port_a_data_width) < 
				(portbaddress*port_b_data_width)) && 
			       (((portaaddress*port_a_data_width) 
				 + port_a_data_width-1) 
				< (portbaddress*port_b_data_width))) ||
			      (((portaaddress*port_a_data_width) > 
				(portbaddress*port_b_data_width)) && 
			       (((portbaddress*port_b_data_width) 
				 + port_b_data_width-1) < 
				(portaaddress*port_a_data_width)))
			      )
			     begin
				for (i = 0; i < port_a_data_width; i = i + 1)
				  if(portabyteenamask
				     [i/(port_a_data_width
					 /port_a_byte_enable_mask_width)] == 1'b0)
				    portadataout_tmp[i] = 1'bX;
				  else
				    portadataout_tmp[i] = portadatain[i];
			     end
			   else
			     begin
				for (i = 0; i < port_a_data_width; i = i + 1)
				  begin
				     if((portaaddress*port_a_data_width) <= 
					(portbaddress*port_b_data_width))
				       begin
					  if((((portaaddress*port_a_data_width) + i) >= 
					      (portbaddress*port_b_data_width)) && 
					     ((portaaddress*port_a_data_width) + i < 
					      ((portbaddress*port_b_data_width) + 
					       port_b_data_width)))
					    begin
					       portadataout_tmp[i] = 1'bX;
					    end
					  else
					    begin
					       for (i = 0; i < port_a_data_width; i = i + 1)
						 if(portabyteenamask
						    [i/(port_a_data_width
							/port_a_byte_enable_mask_width)] == 1'b0)
						   portadataout_tmp[i] = 1'bX;
						 else
						   portadataout_tmp[i] = portadatain[i];
					    end
				       end
				     else
				       begin
					  if(((portaaddress*port_a_data_width) + i) <= 
					     ((portbaddress*port_b_data_width) + 
					      port_b_data_width))
					    begin
					       portadataout_tmp[i] = 1'bX;
					    end
					  else
					    begin
					       for (i = 0; i < port_a_data_width; i = i + 1)
						 if(portabyteenamask
						    [i/(port_a_data_width
							/port_a_byte_enable_mask_width)] == 1'b0)
						   portadataout_tmp[i] = 1'bX;
						 else
						   portadataout_tmp[i] = portadatain[i];
					    end 
				       end
				  end
			     end
			end
		      else
			wr_a = 1'b0;
		   end
		 else
		   begin
		      // WRITE: mem[portaaddress] =  portadatain;
		      if((ram_block_type != "MegaRAM") && 
			 (ram_block_type != "M-RAM") && 
			 (ram_block_type != "m-ram") &&
			 ((ram_block_type != "auto") || 
			  (mixed_port_feed_through_mode != "dont_care"))) 
			begin
			   if(portaclock)
			     begin
				wr_a <= 1'b0;
				for (i = 0; i < port_a_data_width; i = i + 1)
				  if(portabyteenamask[
				    i/(port_a_data_width
					 /port_a_byte_enable_mask_width)] 
				     == 1'b0)
				    portadataout_tmp[i] = 1'bX;
				  else
				    portadataout_tmp[i] = portadatain[i];
			     end
			   else
			     wr_a <= 1'b1;
			end
		      else
			begin
			   if(portaclock)
			     begin
				wr_a <= 1'b1;
				for (i = 0; i < port_a_data_width; i = i + 1)
				  if(portabyteenamask[
				    i/(port_a_data_width
					 /port_a_byte_enable_mask_width)] 
				     == 1'b0)
				    portadataout_tmp[i] = 1'bX;
				  else
				    portadataout_tmp[i] = portadatain[i];
			     end
			   else
			     wr_a <= 1'b0;
			end
		   end 
	      end
	  "rom":
	    begin
	       if(portaclock)
		 begin
		    for (i = 0; i < port_a_data_width; i = i + 1)
		      portadataout_tmp[i] = 
			     mem[portaaddress*port_a_data_width + i];
		 end
	    end // case: "rom"
	  default :;
	endcase // case(operation_mode)
     end
   
   // PORT B
   always @ (portbclock)
     begin
	case (operation_mode)
	  "dual_port":
	    begin
	       if(portbreadenable)
		 begin
		    //  READ: portbdataout = mem[portbaddress];
		    if(sameclock == 1'b1 && portawriteenable &&
		       (ram_block_type == "MegaRAM" || 
			ram_block_type == "M-RAM" || 
			ram_block_type == "m-ram" || 
			(ram_block_type == "auto" && 
			 mixed_port_feed_through_mode == "dont_care")))
		      begin
			 // READ: portbdataout = mem[portbaddress];
			 if(portbclock)
			   begin
			      if(
				 (((portbaddress*port_b_data_width) < 
				   (portaaddress*port_a_data_width)) && 
				  (((portbaddress*port_b_data_width) 
				    + port_b_data_width-1) 
				   < (portaaddress*port_a_data_width))) ||
				 (((portbaddress*port_b_data_width) > 
				   (portaaddress*port_a_data_width)) && 
				  (((portaaddress*port_a_data_width) 
				    + port_a_data_width-1) < 
				   (portbaddress*port_b_data_width)))
				 )
				begin
				   for (i = 0; i < port_b_data_width; i = i + 1)
				     begin
					portbdataout_tmp[i] 
				       = mem[portbaddress*port_b_data_width + i];
				     end
				end
			      else
				begin
				   for (i = 0; i < port_b_data_width; i = i + 1)
				     begin
					if((portbaddress*port_b_data_width) <= 
					   (portaaddress*port_a_data_width))
					  begin
					     if((((portbaddress*port_b_data_width) + i) >= 
						 (portaaddress*port_a_data_width)) && 
						((portbaddress*port_b_data_width) + i < 
						 ((portaaddress*port_a_data_width) + 
						  port_a_data_width)))
					       begin
						  portbdataout_tmp[i] = 1'bX;
					       end
					     else
					       begin
						  portbdataout_tmp[i] 
						 = mem[portbaddress*port_b_data_width + i];
					       end
					  end
					else
					  begin
					     if(((portbaddress*port_b_data_width) + i) <= 
						((portaaddress*port_a_data_width) + 
						 port_a_data_width))
					       begin
						  portbdataout_tmp[i] = 1'bX;
					       end
					     else
					       begin
						  portbdataout_tmp[i] 
						 = mem[portaaddress*port_a_data_width + i];
					       end
					  end
				     end
				end 
			   end 
		      end 
		    else
		      begin
			 // READ: portbdataout = mem[portbaddress];
			 if(portbclock)
			   begin
			      for (i = 0; i < port_b_data_width; i = i + 1)
				portbdataout_tmp[i] = 
				       mem[portbaddress*port_b_data_width + i];
			   end 
		      end 
		 end
	    end // case: "dual_port"
	  "bidir_dual_port":
	    if(~portbwriteenable)
	      begin
		 wr_b <= 1'b0;		
		 // READ: portbdataout = mem[portbaddress]
		 if(sameclock == 1'b1 && portawriteenable &&
		    (ram_block_type == "MegaRAM" || 
		     ram_block_type == "M-RAM" ||
		     ram_block_type == "m-ram" || 
		     (ram_block_type == "auto" && 
		      mixed_port_feed_through_mode == "dont_care")))
		   begin			 
		      if(portbclock)
			begin
			   if(
			      (((portbaddress*port_b_data_width) < 
				(portaaddress*port_a_data_width)) && 
			       (((portbaddress*port_b_data_width) 
				 + port_b_data_width-1) 
				< (portaaddress*port_a_data_width))) ||
			      (((portbaddress*port_b_data_width) > 
				(portaaddress*port_a_data_width)) && 
			       (((portaaddress*port_a_data_width) 
				 + port_a_data_width-1) < 
				(portbaddress*port_b_data_width)))
			      )
			     begin
				for (i = 0; i < port_b_data_width; i = i + 1)
				  begin
				     portbdataout_tmp[i] 
				    = mem[portbaddress*port_b_data_width + i];
				  end
			     end
			   else
			     begin
				for (i = 0; i < port_b_data_width; i = i + 1)
				  begin
				     if((portbaddress*port_b_data_width) <= 
					(portaaddress*port_a_data_width))
				       begin
					  if((((portbaddress*port_b_data_width) + i) >= 
					      (portaaddress*port_a_data_width)) && 
					     ((portbaddress*port_b_data_width) + i < 
					      ((portaaddress*port_a_data_width) + 
					       port_a_data_width)))
					    begin
					       portbdataout_tmp[i] = 1'bX;
					    end
					  else
					    begin
					       portbdataout_tmp[i] 
					      = mem[portbaddress*port_b_data_width + i];
					    end
				       end
				     else
				       begin
					  if(((portbaddress*port_b_data_width) + i) <= 
					     ((portaaddress*port_a_data_width) + 
					      port_a_data_width))
					    begin
					       portbdataout_tmp[i] = 1'bX;
					    end
					  else
					    begin
					       portbdataout_tmp[i] 
					      = mem[portbaddress*port_b_data_width + i];
					    end
				       end
				  end 
			     end
			end 
		   end
		 else
		   begin // READ: portbdataout = mem[portbaddress];
		      if(portbclock)
			begin
			   for (i = 0; i < port_b_data_width; i = i + 1)
			     portbdataout_tmp[i] = 
				    mem[portbaddress*port_b_data_width + i];
			end 
		   end
	      end
	    else if(portbwriteenable)
	      begin // WRITE: mem[portbaddress] = portbdatain
		 if(sameclock == 1'b1 && portawriteenable && 
		    (ram_block_type == "MegaRAM" || 
		     ram_block_type == "M-RAM" ||
		     ram_block_type == "m-ram" || 
		     (ram_block_type == "auto" && 
		      mixed_port_feed_through_mode == "dont_care")))
		   begin	 
		      if(portbclock)
			begin
			   wr_b = 1'b1;
			   if(
			      (((portbaddress*port_b_data_width) < 
				(portaaddress*port_a_data_width)) && 
			       (((portbaddress*port_b_data_width) 
				 + port_b_data_width-1) 
				< (portaaddress*port_a_data_width))) ||
			      (((portbaddress*port_b_data_width) > 
				(portaaddress*port_a_data_width)) && 
			       (((portaaddress*port_a_data_width) 
				 + port_a_data_width-1) < 
				(portbaddress*port_b_data_width)))
			      )
			     begin
				for (i = 0; i < port_b_data_width; i = i + 1)
				  if(portbbyteenamask
				     [i/(port_b_data_width
					 /port_b_byte_enable_mask_width)] == 1'b0)
				    portbdataout_tmp[i] = 1'bX;
				  else
				    portbdataout_tmp[i] = portbdatain[i];
			     end
			   else
			     begin
				for (i = 0; i < port_b_data_width; i = i + 1)
				  begin
				     if((portbaddress*port_b_data_width) <= 
					(portaaddress*port_a_data_width))
				       begin
					  if((((portbaddress*port_b_data_width) + i) >= 
					      (portaaddress*port_a_data_width)) && 
					     ((portbaddress*port_b_data_width) + i < 
					      ((portaaddress*port_a_data_width) + 
					       port_a_data_width)))
					    begin
					       portbdataout_tmp[i] = 1'bX;
					    end
					  else
					    begin
					       for (i = 0; i < port_b_data_width; i = i + 1)
						 if(portbbyteenamask
						    [i/(port_b_data_width
							/port_b_byte_enable_mask_width)] == 1'b0)
						   portbdataout_tmp[i] = 1'bX;
						 else
						   portbdataout_tmp[i] = portbdatain[i];
					    end
				       end
				     else
				       begin
					  if(((portbaddress*port_b_data_width) + i) <= 
					     ((portaaddress*port_a_data_width) + 
					      port_a_data_width))
					    begin
					       portbdataout_tmp[i] = 1'bX;
					    end
					  else
					    begin
					       for (i = 0; i < port_b_data_width; i = i + 1)
						 if(portbbyteenamask
						    [i/(port_b_data_width
							/port_b_byte_enable_mask_width)] == 1'b0)
						   portbdataout_tmp[i] = 1'bX;
						 else
						   portbdataout_tmp[i] = portbdatain[i];
					    end
				       end
				  end
			     end
			end 
		      else
			wr_b = 1'b0;
		   end
		 else
		   begin
		      // WRITE: mem[portbaddress] =  portbdatain;
		      if((ram_block_type != "MegaRAM") && 
			 (ram_block_type != "M-RAM") &&
			 (ram_block_type != "m-ram") && 
			 ((ram_block_type != "auto") || 
			  (mixed_port_feed_through_mode != "dont_care"))) 
			begin 
			   if(portbclock)
			     begin
				wr_b <= 1'b0;
				for (i = 0; i < port_b_data_width; i = i + 1)
				  if(portbbyteenamask[
				    i/(port_b_data_width
					 /port_b_byte_enable_mask_width)] 
				     == 1'b0)
				    portbdataout_tmp[i] = 1'bX;
				  else
				    portbdataout_tmp[i] = portbdatain[i];
			     end 
			   else
			     wr_b <= 1'b1;
			end 
		      else
			begin // WRITE ON POSITIVE EDGE OF CLOCK FOR M-RAM
			   if(portbclock)
			     begin
				wr_b <= 1'b1;
				for (i = 0; i < port_b_data_width; i = i + 1)
				  if(portbbyteenamask[
				    i/(port_b_data_width
					 /port_b_byte_enable_mask_width)] 
				     == 1'b0)
				    portbdataout_tmp[i] = 1'bX;
				  else
				    portbdataout_tmp[i] = portbdatain[i];
			     end
			   else
			     wr_b <= 1'b0;
			end 
		   end  
	      end 	       
	  default :;
	endcase // case(operation_mode)
     end 
   
   // WRITE LOGIC BLOCK FOR PORT A
   always @ (posedge wr_a)
     begin
	// WRITE: mem[portaaddress] = portadatain;
	if(wr_a)
	  begin
	     for (i = 0; i < port_a_data_width; i = i + 1)
	       if(portabyteenamask
		  [i/(port_a_data_width
		      /port_a_byte_enable_mask_width)] !== 1'b0)
		 mem[portaaddress*port_a_data_width + i] =  
		      portadatain[i];
	  end
     end
   
   // WRITE LOGIC BLOCK FOR PORT B
   always @ (posedge wr_b)
     begin
	// WRITE: mem[portbaddress] =  portbdatain;
	if(wr_b)
	  begin
	     for (i = 0; i < port_b_data_width; i = i + 1)
	       if(portbbyteenamask
		  [i/(port_b_data_width
		      /port_b_byte_enable_mask_width)] !== 1'b0)
		 mem[portbaddress*port_b_data_width + i] =
		      portbdatain[i];	
	  end
     end
   
   // CLEAR LOGIC BLOCK
   always @ (posedge cleara)
     begin
   	// ACLEAR PORT A
	     if(port_a_address_clear != "none")
	       mem = {(589823){1'bx}};
	     else
	       begin
		  for (i = 0; i < port_a_data_width; i = i + 1)
		    if(portabyteenamask
		       [i/(port_a_data_width/
			   port_a_byte_enable_mask_width)] !== 1'b0)
		      mem[portaaddress*port_a_data_width + i] =  1'bX;
	       end
	  end
	
   always @ (posedge clearb)
     begin
	// ACLEAR PORT B
	if(operation_mode != "dual_port")
	  begin
	     if(port_b_address_clear != "none")
	       mem = {(589823){1'bx}};
	     else
	       begin
		  for (i = 0; i < port_b_data_width; i = i + 1)
		    if(portbbyteenamask
		       [i/(port_b_data_width/
			   port_b_byte_enable_mask_width)] !== 1'b0)
		      mem[portbaddress*port_b_data_width + i] =  1'bX;
	       end
	  end
     end   
   
endmodule 

///////////////////////////////////////////////////////////////////////////////
//
//                               STRATIXII_RAM_BLOCK
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
  module stratixii_ram_block 
    (
     portadatain, 
     portaaddr, 
     portawe, 
     portbdatain, 
     portbaddr, 
     portbrewe, 
     clk0, clk1, 
     ena0, ena1, 
     clr0, clr1,
     portabyteenamasks, 
     portbbyteenamasks,
     portaaddrstall,
     portbaddrstall,
     devclrn,
     devpor,
     portadataout, 
     portbdataout
     );
   
   parameter mem1 = 512'b0;
   parameter mem2 = 512'b0;
   parameter mem3 = 512'b0;
   parameter mem4 = 512'b0;
   parameter mem5 = 512'b0;
   parameter mem6 = 512'b0;
   parameter mem7 = 512'b0;
   parameter mem8 = 512'b0;
   parameter mem9 = 512'b0;
   parameter operation_mode = "single_port";
   parameter mixed_port_feed_through_mode = "dont_care";
   parameter ram_block_type = "auto"; 
   parameter logical_ram_name = "ram_name"; 
   parameter init_file = "init_file.hex"; 
   parameter init_file_layout = "none";
   parameter data_interleave_width_in_bits = 1;
   parameter data_interleave_offset_in_bits = 1;
   parameter port_a_logical_ram_depth = 0;
   parameter port_a_logical_ram_width = 0;
   parameter port_a_data_in_clear = "none";
   parameter port_a_address_clear = "none";
   parameter port_a_write_enable_clear = "none";
   parameter port_a_data_out_clock = "none";
   parameter port_a_data_out_clear = "none";
   parameter port_a_first_address = 0;
   parameter port_a_last_address = 0;
   parameter port_a_first_bit_number = 0;
   parameter port_a_byte_enable_clear = "none";
   parameter port_a_data_in_clock = "clock0"; 
   parameter port_a_address_clock = "clock0"; 
   parameter port_a_write_enable_clock = "clock0";
   parameter port_a_byte_enable_clock = "clock0";
   parameter port_b_logical_ram_depth = 0;
   parameter port_b_logical_ram_width = 0;
   parameter port_b_data_in_clock = "none";
   parameter port_b_data_in_clear = "none";
   parameter port_b_address_clock = "none";
   parameter port_b_address_clear = "none";
   parameter port_b_read_enable_write_enable_clock = "none";
   parameter port_b_read_enable_write_enable_clear = "none";
   parameter port_b_data_out_clock = "none";
   parameter port_b_data_out_clear = "none";
   parameter port_b_first_address = 0;
   parameter port_b_last_address = 0;
   parameter port_b_first_bit_number = 0;
   parameter port_a_data_width = 144;
   parameter port_b_data_width = 144;
   parameter port_a_address_width = 144; 
   parameter port_b_address_width = 144; 
   parameter port_b_byte_enable_clear = "none";
   parameter port_b_byte_enable_clock = "none";
   parameter port_a_byte_enable_mask_width = 144; 
   parameter port_b_byte_enable_mask_width = 144; 
   parameter power_up_uninitialized = "false";
   parameter lpm_type = "stratixii_ram_block";
   parameter connectivity_checking = "off";
   parameter port_a_byte_size = 0;
   parameter port_a_disable_ce_on_input_registers = "off";
   parameter port_a_disable_ce_on_output_registers = "off";
   parameter port_b_byte_size = 0;
   parameter port_b_disable_ce_on_input_registers = "off";
   parameter port_b_disable_ce_on_output_registers = "off";
   
   input     portawe;
   input [15:0] portabyteenamasks; 
   input [15:0] portbbyteenamasks; 
   input 	portbrewe;
   input 	clr0;
   input 	clr1;
   input 	clk0;
   input 	clk1;
   input 	ena0;
   input 	ena1;
   input [143:0] portadatain;
   input [71:0] portbdatain;
   input [15:0]  portaaddr;
   input [15:0]  portbaddr;
   input 	 portaaddrstall;
   input 	 portbaddrstall;
   input 	 devclrn;
   input 	 devpor;
   output [143:0] portadataout;
   output [143:0] portbdataout; 

   tri1 	  ena0;
   tri1 	  ena1;
      
   wire [143:0]   portawe_bus;
   wire [143:0]   portbrewe_bus; 
   wire [143:0]   portadatain_bus;
   wire [143:0]   portbdatain_bus;
   wire [143:0]   portaaddr_bus;
   wire [143:0]   portbaddr_bus;
   wire [143:0]   portamask_bus; 
   wire [143:0]   portbmask_bus;
   wire [143:0]   portadataout_bus;
   wire [143:0]   portbdataout_bus;
   wire [143:0]   portadataout_tmp;
   wire [143:0]   portbdataout_tmp;
   wire [143:0]   portaaddr_tmp;
   wire [143:0]   portbaddr_tmp;
   wire [143:0]   portadatain_tmp;
   wire [143:0]   portbdatain_tmp;
   wire [1:0] 	  clr_bus;
   wire [1:0] 	  clk_bus;
   wire [1:0] 	  ena_bus;
   wire [4:0] 	  done_a;
   wire [4:0] 	  done_b;
   wire [4:0] 	  clkout_a;
   wire [4:0] 	  clkout_b;
   wire [4:0] 	  done_a_tmp;
   wire [4:0] 	  done_b_tmp;
   wire 	  clock_a;
   wire 	  clock_b;
   wire 	  clrdly_a;
   wire 	  clrdly_b;
   wire 	  edg;
   wire [143:0]   portawe_tmp;
   wire [143:0]   portbrewe_tmp;
   wire [143:0]   portabyteenamasks_tmp;
   wire [143:0]   portbbyteenamasks_tmp;
   reg [143:0] 	  portaaddr_delta;
   reg [143:0] 	  portbaddr_delta;
   reg [143:0] 	  portawe_delta;
   reg [143:0] 	  portbrewe_delta;
   reg [143:0] 	  portadatain_delta;
   reg [143:0] 	  portbdatain_delta;
   reg [143:0] 	  portabyteenamasks_delta;
   reg [143:0] 	  portbbyteenamasks_delta;

   // here
   wire 	  adatain_aclr;
   wire 	  adatain_ena;
   wire 	  aaddr_aclr;
   wire 	  aaddr_ena;

   wire 	  bdatain_clk;
   wire 	  bdatain_aclr;
   wire 	  bdatain_ena;
   wire 	  baddr_clk;
   wire 	  baddr_aclr;
   wire 	  baddr_ena;
   wire 	  brewe_clk;
   wire 	  brewe_aclr;
   wire 	  brewe_ena;
   wire 	  abyteenamasks_aclr;
   wire 	  bbyteenamasks_clk;
   wire 	  bbyteenamasks_aclr;
   wire 	  bbyteenamasks_ena;
   wire 	  adataout_clk;
   wire 	  adataout_aclr;
   wire 	  adataout_ena;
   wire 	  bdataout_clk;
   wire 	  bdataout_aclr;
   wire 	  bdataout_ena;
      
   wire 	  portadatain_aclr;
   wire 	  portaaddr_aclr;
   wire           portawe_aclr;
   wire 	  awe_aclr;
   wire 	  awe_ena;
   wire 	  portbdatain_clk;
   wire 	  portbdatain_aclr;
   wire 	  portbaddr_clk;
   wire 	  portbaddr_aclr;
   wire 	  portbrewe_clk;
   wire 	  portbrewe_aclr;
   wire 	  portabyteenamasks_aclr;
   wire 	  portbbyteenamasks_clk;
   wire 	  portbbyteenamasks_aclr;
   wire 	  portadataout_clk;
   wire 	  portadataout_aclr;
   wire 	  portbdataout_clk;
   wire 	  portbdataout_aclr;
   wire [5:0] 	  aclra;
   wire [5:0] 	  aclrb;
   
   stratixii_ram_clear ram_aclra_reg
     (
      .aclr(aclra[2] || ~devclrn),
      .d(portawe_bus[0]),
      .clk(clrdly_a),
      .ena(clock_a),
      .edg(edg),
      .q(aclra[5])
      );
   
   assign 	  edg = ((port_b_address_clock == "clock0") && 
			 (ram_block_type == "MegaRAM" || 
			  ram_block_type == "M-RAM" || 
			  ram_block_type == "m-ram" ||
			  (ram_block_type == "auto" && 
			   mixed_port_feed_through_mode == "dont_care"))) ? 1'b1 : 1'b0;
   
   stratixii_ram_clear ram_aclrb_reg
     (
      .aclr(aclrb[2] || ~devclrn),
      .d(portbrewe_bus[0]),
      .clk(clrdly_b),
      .ena(clock_b),
      .edg(edg),
      .q(aclrb[5])
      );
   
   stratixii_ram_register	ram_portadatain_reg 
     (
      .data (portadatain_delta),
      .clk (clk_bus[0]),
      .aclr(1'b0),
      .ena (adatain_ena),
      .stall(1'b0),
      .ifclk(1'b1),
      .ifaclr((port_a_data_in_clear == "none") ? 1'b0 : 1'b1 ),
      .ifena(1'b1),
      .devclrn(devclrn),
      .devpor(devpor),
      .powerup(1'b0),
      .dataout (portadatain_bus),
      .aclrout(aclra[0]),
      .clkout(clkout_a[0]),
      .done (done_a_tmp[0])
      );
   defparam 	  ram_portadatain_reg.data_width = 144;
   defparam 	  ram_portadatain_reg.sclr = "true";
   defparam 	  ram_portadatain_reg.preset = "false";

   assign 	  adatain_aclr = clr_bus[portadatain_aclr] || ~devclrn;
   assign 	  adatain_ena = ena_bus[0] || port_a_disable_ce_on_input_registers == "on";
      
   assign 	  portadatain_aclr = ((port_a_data_in_clear == "clear0") || 
				      (port_a_data_in_clear == "none")) ? 
				       1'b0 : 1'b1;
   assign 	  done_a[0] = ((done_a_tmp[0] == 1'b1) || 
			       (port_a_data_in_clock == "none")) ? 
				1'b1 : 1'b0;
   
   stratixii_ram_register	ram_portaaddr_reg 
     (
      .data (portaaddr_delta),
      .clk (clk_bus[0]),
      .aclr(1'b0),      
      .ena (aaddr_ena),
      .stall(portaaddrstall),
      .ifclk(1'b1),
      .ifaclr((port_a_address_clear == "none") ? 1'b0 : 1'b1 ),
      .ifena(1'b1),
      .devclrn(devclrn),
      .devpor(devpor),
      .powerup(1'b0),
      .dataout (portaaddr_bus),
      .aclrout(aclra[1]),
      .clkout(clkout_a[1]),
      .done (done_a_tmp[1])
      );
   defparam 	  ram_portaaddr_reg.data_width = 16;
   defparam 	  ram_portaaddr_reg.sclr = "true";
   defparam 	  ram_portaaddr_reg.preset = "false";
   
   assign 	  aaddr_aclr = clr_bus[portaaddr_aclr] || ~devclrn;
   assign 	  aaddr_ena = ena_bus[0] || port_a_disable_ce_on_input_registers == "on";
   
   assign 	  portaaddr_aclr = ((port_a_address_clear == "clear0") || 
				    (port_a_address_clear == "none")) ? 
				     1'b0 : 1'b1; 
   assign 	  done_a[1] = ((done_a_tmp[1] == 1'b1) || 
			       (port_a_address_clock == "none")) ? 
				1'b1 : 1'b0;
   
   stratixii_ram_register	ram_portawe_reg 
     (
      .data (portawe_delta),
      .clk (clk_bus[0]),
      .aclr(1'b0),      
      .ena (awe_ena),
      .stall(1'b0),
      .ifclk(1'b1),
      .ifaclr((port_a_write_enable_clear == "none") ? 1'b0 : 1'b1 ),
      .ifena(1'b1),
      .devclrn(devclrn),
      .devpor(devpor),
      .powerup(1'b0),
      .dataout (portawe_bus),
      .aclrout(aclra[2]),
      .clkout(clkout_a[2]),
      .done (done_a_tmp[2])
      );
   defparam 	  ram_portawe_reg.data_width = 1;
   defparam 	  ram_portawe_reg.sclr = "true";
   defparam 	  ram_portawe_reg.preset = "false";

   assign 	  awe_aclr = clr_bus[portawe_aclr] || ~devclrn;
   assign 	  awe_ena = ena_bus[0] || port_a_disable_ce_on_input_registers == "on";
      
   assign 	  portawe_aclr = ((port_a_write_enable_clear == "clear0") || 
				  (port_a_write_enable_clear == "none")) ? 
				   1'b0 : 1'b1;
   assign 	  done_a[2] = ((done_a_tmp[2] == 1'b1) || 
			       (port_a_write_enable_clock == "none")) ? 
				1'b1 : 1'b0;
   
   stratixii_ram_register	ram_portbdatain_reg 
     (
      .data (portbdatain_delta), 
      .clk (bdatain_clk),
      .aclr(1'b0),      
      .ena (bdatain_ena),
      .stall(1'b0),      
      .ifclk((port_b_data_in_clock == "none") ? 1'b0 : 1'b1 ),
      .ifaclr((port_b_data_in_clear == "none") ? 1'b0 : 1'b1 ),
      .ifena((port_b_data_in_clock == "none") ? 1'b0 : 1'b1 ),
      .devclrn(devclrn),
      .devpor(devpor),
      .powerup(1'b0),
      .dataout (portbdatain_bus),
      .aclrout(aclrb[0]),
      .clkout(clkout_b[0]),
      .done (done_b_tmp[0])
      );
   defparam 	  ram_portbdatain_reg.data_width = 144;
   defparam 	  ram_portbdatain_reg.sclr = "true";
   defparam 	  ram_portbdatain_reg.preset = "false";

   assign 	  bdatain_clk = clk_bus[portbdatain_clk];
   assign 	  bdatain_aclr = clr_bus[portbdatain_aclr] || ~devclrn;
   assign 	  bdatain_ena = ena_bus[portbdatain_clk] || port_b_disable_ce_on_input_registers == "on";
      
   assign 	  portbdatain_clk = ((port_b_data_in_clock == "clock0") || 
				     (port_b_data_in_clock == "none")) ? 
				      1'b0 : 1'b1;
   assign 	  portbdatain_aclr = ((port_b_data_in_clear == "clear0") || 
				      (port_b_data_in_clear == "none")) ? 
				       1'b0 : 1'b1;  
   assign 	  done_b[0] = ((done_b_tmp[0] == 1'b1) || 
			       (port_b_data_in_clock == "none")) ? 
				1'b1 : 1'b0;
   
   stratixii_ram_register	ram_portbaddr_reg 
     (
      .data (portbaddr_delta),
      .clk (baddr_clk),
      .aclr(1'b0),      
      .ena (baddr_ena),
      .stall(portbaddrstall),
      .ifclk((port_b_address_clock == "none") ? 1'b0 : 1'b1 ),
      .ifaclr((port_b_address_clear == "none") ? 1'b0 : 1'b1 ),
      .ifena((port_b_address_clock == "none") ? 1'b0 : 1'b1 ),
      .devclrn(devclrn),
      .devpor(devpor),
      .powerup(1'b0),
      .dataout (portbaddr_bus),
      .aclrout(aclrb[1]),
      .clkout(clkout_b[1]),
      .done (done_b_tmp[1])
      );
   defparam 	  ram_portbaddr_reg.data_width = 16;
   defparam 	  ram_portbaddr_reg.sclr = "true";
   defparam 	  ram_portbaddr_reg.preset = "false";

   assign 	  baddr_clk = clk_bus[portbaddr_clk];
   assign 	  baddr_aclr = clr_bus[portbaddr_aclr] || ~devclrn;
   assign 	  baddr_ena = ena_bus[portbaddr_clk] || port_b_disable_ce_on_input_registers == "on";
      
   assign 	  portbaddr_clk = ((port_b_address_clock == "clock0") || 
				   (port_b_address_clock == "none")) ? 
				    1'b0 : 1'b1; 
   assign 	  portbaddr_aclr = ((port_b_address_clear == "clear0") || 
				    (port_b_address_clear == "none")) ? 
				     1'b0 : 1'b1;
   assign 	  done_b[1] = ((done_b_tmp[1] == 1'b1) || 
			       (port_b_address_clock == "none")) ? 
				1'b1 : 1'b0;
   
   stratixii_ram_register	ram_portbrewe_reg 
     (
      .data (portbrewe_delta),
      .clk (brewe_clk),
      .aclr(1'b0),      
      .ena (brewe_ena),
      .stall(1'b0),
      .ifclk((port_b_read_enable_write_enable_clock == "none") ? 
	      1'b0 : 1'b1 ),
      .ifaclr((port_b_read_enable_write_enable_clear == "none") ? 
	       1'b0 : 1'b1 ),
      .ifena((port_b_read_enable_write_enable_clock == "none") ? 
	      1'b0 : 1'b1 ),
      .devclrn(devclrn),
      .devpor(devpor),
      .powerup((operation_mode != "dual_port") ? 1'b0 : 1'b1),
      .dataout (portbrewe_bus),
      .aclrout(aclrb[2]),
      .clkout(clkout_b[2]),
      .done (done_b_tmp[2])
      );
   defparam 	  ram_portbrewe_reg.data_width = 1;
   defparam 	  ram_portbrewe_reg.sclr = "true";
   defparam 	  ram_portbrewe_reg.preset = "true";

   assign 	  brewe_clk  = clk_bus[portbrewe_clk];
   assign 	  brewe_aclr = clr_bus[portbrewe_aclr] || ~devclrn;
   assign 	  brewe_ena  = ena_bus[portbrewe_clk] || port_b_disable_ce_on_input_registers == "on";
   
   assign 	  portbrewe_clk = ((port_b_read_enable_write_enable_clock == 
				    "clock0") || 
				   (port_b_read_enable_write_enable_clock == 
				    "none")) ? 1'b0 : 1'b1;
   assign 	  portbrewe_aclr = ((port_b_read_enable_write_enable_clear == 
				     "clear0") || 
				    (port_b_read_enable_write_enable_clear == 
				     "none")) ? 1'b0 : 1'b1;
   assign 	  done_b[2] = ((done_b_tmp[2] == 1'b1) || 
			       (port_b_read_enable_write_enable_clock == 
				"none")) ? 1'b1 : 1'b0;
   
   stratixii_ram_register	ram_portabyteenamasks_reg 
     (
      .data (portabyteenamasks_delta),
      .clk (clk_bus[0]), 
      .aclr(1'b0),      
      .ena (ena_bus[0] || port_a_disable_ce_on_input_registers == "on"),
      .stall(1'b0),      
      .ifclk(1'b1),
      .ifaclr((port_a_byte_enable_clear == "none") ? 1'b0 : 1'b1 ),
      .ifena(1'b1),
      .devclrn(devclrn),
      .devpor(devpor),
      .powerup(1'b1),
      .dataout (portamask_bus),
      .aclrout(aclra[3]),
      .clkout(clkout_a[3]),
      .done (done_a_tmp[3])
      );
   defparam 	  ram_portabyteenamasks_reg.data_width = 
		  port_a_byte_enable_mask_width;
   defparam 	  ram_portabyteenamasks_reg.sclr = "true";
   defparam 	  ram_portabyteenamasks_reg.preset = "true";

   assign 	  abyteenamasks_aclr = clr_bus[portabyteenamasks_aclr] || ~devclrn;
      
   assign 	  portabyteenamasks_aclr = ((port_a_byte_enable_clear == 
					     "clear0") || 
					    (port_a_byte_enable_clear == 
					     "none")) ? 1'b0 : 1'b1;
   assign 	  done_a[3] = ((done_a_tmp[3] == 1'b1) || 
			       (port_a_byte_enable_clock == "none")) ? 
				1'b1 : 1'b0;
   
   stratixii_ram_register	ram_portbbyteenamasks_reg 
     (
      .data (portbbyteenamasks_delta),
      .clk (bbyteenamasks_clk),
      .aclr(1'b0),      
      .ena (bbyteenamasks_ena),
      .stall(1'b0),
      .ifclk((port_b_byte_enable_clock == "none") ? 1'b0 : 1'b1 ),
      .ifaclr((port_b_byte_enable_clear == "none") ? 1'b0 : 1'b1 ),
      .ifena((port_b_byte_enable_clock == "none") ? 1'b0 : 1'b1 ),
      .devclrn(devclrn),
      .devpor(devpor),
      .powerup(1'b1),
      .dataout (portbmask_bus),
      .aclrout(aclrb[3]),
      .clkout(clkout_b[3]),
      .done (done_b_tmp[3])
      );
   defparam 	  ram_portbbyteenamasks_reg.data_width = 
		  port_b_byte_enable_mask_width;
   defparam 	  ram_portbbyteenamasks_reg.sclr = "true";
   defparam 	  ram_portbbyteenamasks_reg.preset = "true";

   assign 	  bbyteenamasks_clk = clk_bus[portbbyteenamasks_clk];
   assign 	  bbyteenamasks_aclr = clr_bus[portbbyteenamasks_aclr] || ~devclrn;
   assign 	  bbyteenamasks_ena = ena_bus[portbbyteenamasks_clk] || port_b_disable_ce_on_input_registers == "on";
   
   
   assign 	  portbbyteenamasks_clk = ((port_b_byte_enable_clock == 
					    "clock0") || 
					   (port_b_byte_enable_clock == 
					    "none")) ? 1'b0 : 1'b1; 
   assign 	  portbbyteenamasks_aclr = ((port_b_byte_enable_clear == 
					     "clear0") || 
					    (port_b_byte_enable_clear == 
					     "none")) ? 1'b0 : 1'b1;
   assign 	  done_b[3] = ((done_b_tmp[3] == 1'b1) || 
			       (port_b_byte_enable_clock == "none")) ? 
				1'b1 : 1'b0;
   
   assign 	  clock_a = (port_a_write_enable_clock == port_b_read_enable_write_enable_clock) ? 
			      done_a[0] & done_a[1] & done_a[2] & done_b[2] & done_a[3] : 
		              done_a[0] & done_a[1] & done_a[2] & done_a[3] ;
   assign 	  clock_b = (port_a_write_enable_clock == port_b_read_enable_write_enable_clock) ?
			      done_b[0] & done_b[1] & done_b[2] & done_a[2] & done_b[3] :
		              done_b[0] & done_b[1] & done_b[2] & done_b[3] ;
   assign 	  clrdly_a = (port_a_write_enable_clock == port_b_read_enable_write_enable_clock) ?
			       clkout_a[0] & clkout_a[1] & clkout_a[2] & clkout_b[2] & clkout_a[3] :
		               clkout_a[0] & clkout_a[1] & clkout_a[2] & clkout_a[3];
   assign 	  clrdly_b = (port_a_write_enable_clock == port_b_read_enable_write_enable_clock) ? 
			       clkout_b[0] & clkout_b[1] & clkout_b[2] & clkout_a[2] & clkout_b[3] :
   			       clkout_b[0] & clkout_b[1] & clkout_b[2] & clkout_b[3];
   
   stratixii_ram_internal internal_ram
     (
      .portawriteenable(portawe_bus[0]), 
      .portbwriteenable(portbrewe_bus[0]),
      .cleara(aclra[5]),
      .clearb(aclrb[5]),
      .portadatain(portadatain_bus[143:0]), 
      .portbdatain(portbdatain_bus[71:0]), 
      .portaaddress(portaaddr_bus[15:0]), 
      .portbaddress(portbaddr_bus[15:0]), 
      .portabyteenamask(portamask_bus[15:0]), 
      .portbbyteenamask(portbmask_bus[15:0]), 
      .portbreadenable(portbrewe_bus[0]),
      .portaclock(clock_a),
      .portbclock(clock_b),
      .sameclock(port_b_address_clock == "clock0" ? 1'b1 : 1'b0),
      .portadataout(portadataout_bus),
      .portbdataout(portbdataout_bus)
      );
   defparam 	  internal_ram.operation_mode = operation_mode;
   defparam 	  internal_ram.ram_block_type = ram_block_type;
   defparam 	  internal_ram.mixed_port_feed_through_mode = 
		  mixed_port_feed_through_mode;
   defparam 	  internal_ram.port_a_data_width = port_a_data_width;
   defparam 	  internal_ram.port_b_data_width = port_b_data_width;
   defparam 	  internal_ram.port_a_address_width = port_a_address_width;
   defparam 	  internal_ram.port_b_address_width = port_b_address_width;
   defparam 	  internal_ram.port_a_byte_enable_mask_width = 
		  port_a_byte_enable_mask_width;
   defparam 	  internal_ram.port_b_byte_enable_mask_width = 
		  port_b_byte_enable_mask_width;
   defparam 	  internal_ram.init_file_layout = init_file_layout;
   defparam 	  internal_ram.port_a_first_address = port_a_first_address;
   defparam 	  internal_ram.port_a_last_address = port_a_last_address;
   defparam 	  internal_ram.port_b_first_address = port_b_first_address;
   defparam 	  internal_ram.port_b_last_address = port_b_last_address;
   defparam 	  internal_ram.port_a_address_clear = port_a_address_clear;
   defparam 	  internal_ram.port_b_address_clear = port_b_address_clear;
   defparam 	  internal_ram.power_up_uninitialized = power_up_uninitialized;
   defparam 	  internal_ram.mem1 = mem1;
   defparam 	  internal_ram.mem2 = mem2;
   defparam 	  internal_ram.mem3 = mem3;
   defparam 	  internal_ram.mem4 = mem4;
   defparam 	  internal_ram.mem5 = mem5;
   defparam 	  internal_ram.mem6 = mem6;
   defparam 	  internal_ram.mem7 = mem7;
   defparam 	  internal_ram.mem8 = mem8;
   defparam 	  internal_ram.mem9 = mem9; 
   
   stratixii_ram_register	ram_portadataout_reg 
      (
       .data (portadataout_bus),
       .clk (adataout_clk),
       .aclr (adataout_aclr),
       .ena (adataout_ena),
      .stall(1'b0),       
       .ifclk((port_a_data_out_clock == "none") ? 1'b0 : 1'b1 ),
       .ifaclr((port_a_data_out_clear == "none") ? 1'b0 : 1'b1 ),
       .ifena((port_a_data_out_clock == "none") ? 1'b0 : 1'b1 ),
       .devclrn(devclrn),
       .devpor(devpor),
       .powerup((power_up_uninitialized == "true") ? 1'bX : 1'b0),
       .dataout (portadataout_tmp),
       .aclrout(aclra[4]),
       .clkout(clkout_a[4]),
       .done (done_a[4])
       );
   defparam 	ram_portadataout_reg.data_width = 144;
   defparam 	ram_portadataout_reg.sclr = "false";
   defparam 	ram_portadataout_reg.preset = "false";
   
   assign 	adataout_clk = clk_bus[portadataout_clk];
   assign 	adataout_aclr = clr_bus[portadataout_aclr] || ~devclrn;
   assign       adataout_ena = ena_bus[portadataout_clk] || port_a_disable_ce_on_output_registers == "on";
      
   assign 	portadataout_clk = ((port_a_data_out_clock == "clock0") || 
				    (port_a_data_out_clock == "none")) ? 
				     1'b0 : 1'b1; 
   assign 	portadataout_aclr = ((port_a_data_out_clear == "clear0") || 
				     (port_a_data_out_clear == "none")) ? 
				      1'b0 : 1'b1;
   
   stratixii_ram_register	ram_portbdataout_reg 
     (
      .data (portbdataout_bus),
      .clk (bdataout_clk),
      .aclr(bdataout_aclr),
      .ena (bdataout_ena),
      .stall(1'b0),      
      .ifclk((port_b_data_out_clock == "none") ? 1'b0 : 1'b1 ),
      .ifaclr((port_b_data_out_clear == "none") ? 1'b0 : 1'b1 ),
      .ifena((port_b_data_out_clock == "none") ? 1'b0 : 1'b1 ),
      .devclrn(devclrn),
      .devpor(devpor),
      .powerup((power_up_uninitialized == "true") ? 1'bX : 1'b0),
      .dataout (portbdataout_tmp),
      .aclrout(aclrb[4]),
      .clkout(clkout_b[4]),
      .done (done_b[4])
      );
   defparam 	ram_portbdataout_reg.data_width = 144;
   defparam 	ram_portbdataout_reg.sclr = "false";
   defparam 	ram_portbdataout_reg.preset = "false";

   assign 	bdataout_clk = clk_bus[portbdataout_clk];
   assign 	bdataout_aclr = clr_bus[portbdataout_aclr] || ~devclrn;
   assign 	bdataout_ena = ena_bus[portbdataout_clk] || port_b_disable_ce_on_output_registers == "on";
   
   assign 	portbdataout_clk = ((port_b_data_out_clock == "clock0") || 
				    (port_b_data_out_clock == "none")) ? 
				     1'b0 : 1'b1; 
   assign 	portbdataout_aclr = ((port_b_data_out_clear == "clear0") || 
				     (port_b_data_out_clear == "none")) ? 
				      1'b0 : 1'b1;
   
   assign 	clk_bus               = {clk1, clk0};
   assign 	clr_bus               = {clr1, clr0};
   assign 	ena_bus               = {ena1, ena0};
   assign 	portaaddr_tmp[15:0]   = portaaddr[15:0];
   assign 	portbaddr_tmp[15:0]   = portbaddr[15:0];
   assign 	portawe_tmp[0]        = portawe;
   assign 	portbrewe_tmp[0]      = portbrewe;   
   assign 	portadatain_tmp       = portadatain;
   assign 	portbdatain_tmp       = {72'b0, portbdatain};
   assign 	portabyteenamasks_tmp[15:0] = portabyteenamasks;
   assign 	portbbyteenamasks_tmp[15:0] = portbbyteenamasks;
   
   always @ (portaaddr_tmp or portbaddr_tmp or 
	     portawe_tmp or portbrewe_tmp or
	     portadatain_tmp or portbdatain_tmp or
	     portabyteenamasks_tmp or portbbyteenamasks_tmp)
     begin
	portaaddr_delta[15:0]   <= portaaddr_tmp[15:0];
	portbaddr_delta[15:0]   <= portbaddr_tmp[15:0];
   	portawe_delta[0]        <= portawe_tmp[0];
    	portbrewe_delta[0]      <= portbrewe_tmp[0];   
    	portadatain_delta       <= portadatain_tmp;
    	portbdatain_delta       <= portbdatain_tmp;
   	portabyteenamasks_delta <= portabyteenamasks_tmp;
    	portbbyteenamasks_delta <= portbbyteenamasks_tmp;
     end
   
   assign portadataout = portadataout_tmp; 
   assign portbdataout = portbdataout_tmp; 
   
endmodule // stratixii_ram_block

//--------------------------------------------------------------------
//
// Module Name : stratixii_jtag
//
// Description : StratixII JTAG Verilog Simulation model
//
//--------------------------------------------------------------------

`timescale 1 ps/1 ps
module  stratixii_jtag (tms, tck, tdi, ntrst, tdoutap, tdouser, tdo, tmsutap, tckutap, tdiutap, shiftuser, clkdruser, updateuser, runidleuser, usr1user);

	input    tms, tck, tdi, ntrst, tdoutap, tdouser;

	output   tdo, tmsutap, tckutap, tdiutap, shiftuser, clkdruser;
	output	updateuser, runidleuser, usr1user;

   parameter lpm_type = "stratixii_jtag";

	initial
	begin
	end

	always @(tms or tck or tdi or ntrst or tdoutap or tdouser) 
	begin 
	end

endmodule

//--------------------------------------------------------------------
//
// Module Name : stratixii_crcblock
//
// Description : StratixII CRCBLOCK Verilog Simulation model
//
//--------------------------------------------------------------------

`timescale 1 ps/1 ps
module  stratixii_crcblock 
	(
	clk,
	shiftnld,
	ldsrc,
	crcerror,
	regout
	);

input clk;
input shiftnld;
input ldsrc;

output crcerror;
output regout;

parameter oscillator_divider = 1;
parameter lpm_type = "stratixii_crcblock";

endmodule

//---------------------------------------------------------------------
//
// Module Name : stratixii_asmiblock
//
// Description : StratixIIII ASMIBLOCK Verilog Simulation model
//
//---------------------------------------------------------------------

`timescale 1 ps/1 ps
module  stratixii_asmiblock 
	(
	dclkin,
	scein,
	sdoin,
	data0out,
	oe
	);

input dclkin;
input scein;
input sdoin;
input oe;

output data0out;

parameter lpm_type = "stratixii_asmiblock";

endmodule
//------------------------------------------------------------------
//
// Module Name : stratixii_lcell_ff
//
// Description : StratixII LCELL_FF Verilog simulation model 
//
//------------------------------------------------------------------
`timescale 1 ps/1 ps
  
module stratixii_lcell_ff (
                           datain, 
                           clk, 
                           aclr, 
                           aload, 
                           sclr, 
                           sload, 
                           adatasdata, 
                           ena, 
                           devclrn, 
                           devpor, 
                           regout
                          );
   
parameter x_on_violation = "on";
parameter lpm_type = "stratixii_lcell_ff";

input datain;
input clk;
input aclr;
input aload; 
input sclr; 
input sload; 
input adatasdata; 
input ena; 
input devclrn; 
input devpor; 

output regout;
   
reg regout_tmp;
wire reset;
   
reg datain_viol;
reg sclr_viol;
reg sload_viol;
reg adatasdata_viol;
reg ena_viol; 
reg violation;

reg clk_last_value;
   
reg ix_on_violation;

buf (datain_in, datain);
buf (clk_in, clk);
buf (aclr_in, aclr);
buf (aload_in, aload);
buf (sclr_in, sclr);
buf (sload_in, sload);
buf (adatasdata_in, adatasdata);
buf (ena_in, ena);
   
assign reset = devpor && devclrn && (!aclr_in) && (ena_in);
   
specify

    $setuphold (posedge clk &&& reset, datain, 0, 0, datain_viol) ;
    $setuphold (posedge clk &&& reset, sclr, 0, 0, sclr_viol) ;
    $setuphold (posedge clk &&& reset, sload, 0, 0, sload_viol) ;
    $setuphold (posedge clk &&& reset, adatasdata, 0, 0, adatasdata_viol) ;
    $setuphold (posedge clk &&& reset, ena, 0, 0, ena_viol) ;
      
    (posedge clk => (regout +: regout_tmp)) = 0 ;
    (posedge aclr => (regout +: 1'b0)) = (0, 0) ;
    (posedge aload => (regout +: regout_tmp)) = (0, 0) ;
    (adatasdata => regout) = (0, 0) ;
      
endspecify
   
initial
begin
    violation = 'b0;
    clk_last_value = 'b0;
    regout_tmp = 'b0;

    if (x_on_violation == "on")
        ix_on_violation = 1;
    else
        ix_on_violation = 0;
end
   
always @ (datain_viol or sclr_viol or sload_viol or ena_viol)
begin
    if (ix_on_violation == 1)
        violation = 'b1;
end
   
always @ (adatasdata_in or aclr_in or posedge aload_in or 
          negedge devclrn or negedge devpor)
begin
    if (devpor == 'b0)
        regout_tmp <= 'b0;
    else if (devclrn == 'b0)
        regout_tmp <= 'b0;
    else if (aclr_in == 'b1) 
        regout_tmp <= 'b0;
    else if (aload_in == 'b1) 
        regout_tmp <= adatasdata_in;
end
   
always @ (clk_in or posedge aclr_in or posedge aload_in or 
          negedge devclrn or negedge devpor or posedge violation)
begin
    if (violation == 1'b1)
    begin
        violation = 'b0;
        regout_tmp <= 'bX;
    end
    else
    begin
        if (devpor == 'b0 || devclrn == 'b0 || aclr_in === 'b1)
            regout_tmp <= 'b0;
        else if (aload_in === 'b1) 
            regout_tmp <= adatasdata_in;
        else if (ena_in === 'b1 && clk_in === 'b1 && clk_last_value === 'b0)
        begin
            if (sclr_in === 'b1)
                regout_tmp <= 'b0 ;
            else if (sload_in === 'b1)
                regout_tmp <= adatasdata_in;
            else 
                regout_tmp <= datain_in;
        end
    end

    clk_last_value = clk_in;
end

   
and (regout, regout_tmp, 'b1);
   
endmodule

//------------------------------------------------------------------
//
// Module Name : stratixii_lcell_comb
//
// Description : StratixII LCELL_COMB Verilog simulation model 
//
//------------------------------------------------------------------

`timescale 1 ps/1 ps
  
module stratixii_lcell_comb (
                             dataa, 
                             datab, 
                             datac, 
                             datad, 
                             datae, 
                             dataf, 
                             datag, 
                             cin,
                             sharein, 
                             combout, 
                             sumout,
                             cout, 
                             shareout 
                            );

input dataa;
input datab;
input datac;
input datad;
input datae;
input dataf;
input datag;
input cin;
input sharein;

output combout;
output sumout;
output cout;
output shareout;

parameter lut_mask = 64'hFFFFFFFFFFFFFFFF;
parameter shared_arith = "off";
parameter extended_lut = "off";
parameter lpm_type = "stratixii_lcell_comb";

// sub masks
wire [15:0] f0_mask;
wire [15:0] f1_mask;
wire [15:0] f2_mask;
wire [15:0] f3_mask;

// sub lut outputs
reg f0_out;
reg f1_out;
reg f2_out;
reg f3_out;

// mux output for extended mode
reg g0_out;
reg g1_out;

// either datac or datag
reg f2_input3;

// F2 output using dataf
reg f2_f;

// second input to the adder
reg adder_input2;

// tmp output variables
reg combout_tmp;
reg sumout_tmp;
reg cout_tmp;

// integer representations for string parameters
reg ishared_arith;
reg iextended_lut;

// 4-input LUT function
function lut4;
input [15:0] mask;
input dataa;
input datab;
input datac;
input datad;
      
begin

    lut4 = datad ? ( datac ? ( datab ? ( dataa ? mask[15] : mask[14])
                                     : ( dataa ? mask[13] : mask[12]))
                           : ( datab ? ( dataa ? mask[11] : mask[10]) 
                                     : ( dataa ? mask[ 9] : mask[ 8])))
                 : ( datac ? ( datab ? ( dataa ? mask[ 7] : mask[ 6]) 
                                     : ( dataa ? mask[ 5] : mask[ 4]))
                           : ( datab ? ( dataa ? mask[ 3] : mask[ 2]) 
                                     : ( dataa ? mask[ 1] : mask[ 0])));

end
endfunction

// 5-input LUT function
function lut5;
input [31:0] mask;
input dataa;
input datab;
input datac;
input datad;
input datae;
reg e0_lut;
reg e1_lut;
reg [15:0] e0_mask;
reg [31:16] e1_mask;

      
begin

    e0_mask = mask[15:0];
    e1_mask = mask[31:16];

	 begin
        e0_lut = lut4(e0_mask, dataa, datab, datac, datad);
        e1_lut = lut4(e1_mask, dataa, datab, datac, datad);

        if (datae === 1'bX) // X propogation
        begin
            if (e0_lut == e1_lut)
            begin
                lut5 = e0_lut;
            end
            else
            begin
                lut5 = 1'bX;
            end
        end
        else
        begin
            lut5 = (datae == 1'b1) ? e1_lut : e0_lut;
        end
    end
end
endfunction

// 6-input LUT function
function lut6;
input [63:0] mask;
input dataa;
input datab;
input datac;
input datad;
input datae;
input dataf;
reg f0_lut;
reg f1_lut;
reg [31:0] f0_mask;
reg [63:32] f1_mask ;
      
begin

    f0_mask = mask[31:0];
    f1_mask = mask[63:32];

	 begin

        lut6 = mask[{dataf, datae, datad, datac, datab, dataa}];

        if (lut6 === 1'bX)
        begin
            f0_lut = lut5(f0_mask, dataa, datab, datac, datad, datae);
            f1_lut = lut5(f1_mask, dataa, datab, datac, datad, datae);
    
            if (dataf === 1'bX) // X propogation
            begin
                if (f0_lut == f1_lut)
                begin
                    lut6 = f0_lut;
                end
                else
                begin
                    lut6 = 1'bX;
                end
            end
            else
            begin
                lut6 = (dataf == 1'b1) ? f1_lut : f0_lut;
            end
        end
    end
end
endfunction

buf(dataa_in, dataa);
buf(datab_in, datab);
buf(datac_in, datac);
buf(datad_in, datad);
buf(datae_in, datae);
buf(dataf_in, dataf);
buf(datag_in, datag);
buf(cin_in, cin);
buf(sharein_in, sharein);

specify

    (dataa => combout) = (0, 0);
    (datab => combout) = (0, 0);
    (datac => combout) = (0, 0);
    (datad => combout) = (0, 0);
    (datae => combout) = (0, 0);
    (dataf => combout) = (0, 0);
    (datag => combout) = (0, 0);

    (dataa => sumout) = (0, 0);
    (datab => sumout) = (0, 0);
    (datac => sumout) = (0, 0);
    (datad => sumout) = (0, 0);
    (dataf => sumout) = (0, 0);
    (cin => sumout) = (0, 0);
    (sharein => sumout) = (0, 0);

    (dataa => cout) = (0, 0);
    (datab => cout) = (0, 0);
    (datac => cout) = (0, 0);
    (datad => cout) = (0, 0);
    (dataf => cout) = (0, 0);
    (cin => cout) = (0, 0);
    (sharein => cout) = (0, 0);

    (dataa => shareout) = (0, 0);
    (datab => shareout) = (0, 0);
    (datac => shareout) = (0, 0);
    (datad => shareout) = (0, 0);

endspecify

initial
begin
    if (shared_arith == "on")
        ishared_arith = 1;
    else
        ishared_arith = 0;

    if (extended_lut == "on")
        iextended_lut = 1;
    else
        iextended_lut = 0;

    f0_out = 1'b0;
    f1_out = 1'b0;
    f2_out = 1'b0;
    f3_out = 1'b0;
    g0_out = 1'b0;
    g1_out = 1'b0;
    f2_input3 = 1'b0;
    adder_input2 = 1'b0;
    f2_f = 1'b0;
    combout_tmp = 1'b0;
    sumout_tmp = 1'b0;
    cout_tmp = 1'b0;
end

// sub masks and outputs
assign f0_mask = lut_mask[15:0];
assign f1_mask = lut_mask[31:16];
assign f2_mask = lut_mask[47:32];
assign f3_mask = lut_mask[63:48];

always @(datag_in or dataf_in or datae_in or datad_in or datac_in or 
         datab_in or dataa_in or cin_in or sharein_in)
begin

    // check for extended LUT mode
    if (iextended_lut == 1) 
        f2_input3 = datag_in;
    else
        f2_input3 = datac_in;

    f0_out = lut4(f0_mask, dataa_in, datab_in, datac_in, datad_in);
    f1_out = lut4(f1_mask, dataa_in, datab_in, f2_input3, datad_in);
    f2_out = lut4(f2_mask, dataa_in, datab_in, datac_in, datad_in);
    f3_out = lut4(f3_mask, dataa_in, datab_in, f2_input3, datad_in);

    // combout is the 6-input LUT
    if (iextended_lut == 1)
    begin
        if (datae_in == 1'b0)
        begin
            g0_out = f0_out;
            g1_out = f2_out;
        end
        else if (datae_in == 1'b1)
        begin
            g0_out = f1_out;
            g1_out = f3_out;
        end
        else
        begin
            if (f0_out == f1_out)
                g0_out = f0_out;
            else
                g0_out = 1'bX;

            if (f2_out == f3_out)
                g1_out = f2_out;
            else
                g1_out = 1'bX;
        end
    
        if (dataf_in == 1'b0)
            combout_tmp = g0_out;
        else if ((dataf_in == 1'b1) || (g0_out == g1_out))
            combout_tmp = g1_out;
        else
            combout_tmp = 1'bX;
    end
    else
        combout_tmp = lut6(lut_mask, dataa_in, datab_in, datac_in, 
                           datad_in, datae_in, dataf_in);

    // check for shareed arithmetic mode
    if (ishared_arith == 1) 
        adder_input2 = sharein_in;
    else
    begin
        f2_f = lut4(f2_mask, dataa_in, datab_in, datac_in, dataf_in);
        adder_input2 = !f2_f;
    end

    // sumout & cout
    sumout_tmp = cin_in ^ f0_out ^ adder_input2;
    cout_tmp = (cin_in & f0_out) | (cin_in & adder_input2) | 
               (f0_out & adder_input2);

end

and (combout, combout_tmp, 1'b1);
and (sumout, sumout_tmp, 1'b1);
and (cout, cout_tmp, 1'b1);
and (shareout, f2_out, 1'b1);

endmodule
///////////////////////////////////////////////////////////////////////////////
//
//                              STRATIXII_ASYNCH_IO
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1 ps/1 ps

module stratixii_asynch_io (
                            datain, 
                            oe, 
                            regin, 
                            ddioregin, 
                            padio, 
                            delayctrlin,
                            offsetctrlin,
                            dqsupdateen,
                            dqsbusout,
                            combout, 
                            regout, 
                            ddioregout
                           );
   
   input datain;
   input oe;
   input regin;
   input ddioregin;
   input [5:0] delayctrlin;
   input [5:0] offsetctrlin;
   input       dqsupdateen;
   output      dqsbusout;
   output combout;
   output regout;
   output ddioregout;
   inout  padio;
   
   parameter operation_mode = "input";
   parameter bus_hold = "false";
   parameter open_drain_output = "false";

   parameter dqs_input_frequency = "10000 ps";
   parameter dqs_out_mode = "none";
   parameter dqs_delay_buffer_mode = "low";
   parameter dqs_phase_shift = 0;
   parameter dqs_offsetctrl_enable = "false";
   parameter dqs_ctrl_latches_enable = "false";
   parameter dqs_edge_detect_enable = "false";  
   parameter sim_dqs_intrinsic_delay = 0;
   parameter sim_dqs_delay_increment = 0;
   parameter sim_dqs_offset_increment = 0;
   parameter gated_dqs = "false";
   
   reg buf_control;
   reg prev_value;
   reg tmp_padio;
   tri padio_tmp;
   
   reg tmp_combout;
   reg combout_tmp;
   reg tmp_dqsbusout;
   wire dqsbusout_tmp;

   reg [1:0] iop_mode;
   
   integer dqs_delay;
   integer tmp_delayctrl;
   integer tmp_offsetctrl;
   wire    dqs_ctrl_latches_ena;
   reg     para_dqs_ctrl_latches_enable;
   reg     para_dqs_offsetctrl_enable;
   reg     para_dqs_edge_detect_enable;

   wire [5:0] delayctrlin_in;
   wire [5:0] offsetctrlin_in;

   buf(datain_in, datain);
   buf(oe_in, oe);
   buf(dqsupdateen_in, dqsupdateen);
   buf(delayctrlin_in0, delayctrlin[0]);
   buf(delayctrlin_in1, delayctrlin[1]);
   buf(delayctrlin_in2, delayctrlin[2]);
   buf(delayctrlin_in3, delayctrlin[3]);
   buf(delayctrlin_in4, delayctrlin[4]);
   buf(delayctrlin_in5, delayctrlin[5]);
   buf(offsetctrlin_in0, offsetctrlin[0]);
   buf(offsetctrlin_in1, offsetctrlin[1]);
   buf(offsetctrlin_in2, offsetctrlin[2]);
   buf(offsetctrlin_in3, offsetctrlin[3]);
   buf(offsetctrlin_in4, offsetctrlin[4]);
   buf(offsetctrlin_in5, offsetctrlin[5]);
   assign delayctrlin_in = {delayctrlin_in5, delayctrlin_in4,
                            delayctrlin_in3, delayctrlin_in2,
							delayctrlin_in1, delayctrlin_in0};
   assign offsetctrlin_in = {offsetctrlin_in5, offsetctrlin_in4,
                             offsetctrlin_in3, offsetctrlin_in2,
							 offsetctrlin_in1, offsetctrlin_in0};
   
   // convert string to integer with sign
   function integer str2int; 
      input [8*16:1] s;
      
      reg [8*16:1] reg_s;
      reg [8:1] digit;
      reg [8:1] tmp;
      integer m, magnitude;
      integer sign;
      
      begin
         sign = 1;
         magnitude = 0;
         reg_s = s;
         for (m=1; m<=16; m=m+1)
           begin
              tmp = reg_s[128:121];
              digit = tmp & 8'b00001111;
              reg_s = reg_s << 8;
              // Accumulate ascii digits 0-9 only.
              if ((tmp>=48) && (tmp<=57)) 
                magnitude = (magnitude * 10) + digit;
              if (tmp == 45)
                sign = -1;  // Found a '-' character, i.e. number is negative.
           end
         str2int = sign*magnitude;
      end
   endfunction
   
   specify
      (padio => combout) = (0,0);
      (datain => padio) = (0, 0);
      (posedge oe => (padio +: padio_tmp)) = (0, 0);
      (negedge oe => (padio +: 1'bz)) = (0, 0);
      (ddioregin => ddioregout) = (0, 0);
      (regin => regout) = (0, 0);
	  (padio => dqsbusout) = (0, 0);
	  (regin => dqsbusout) = (0, 0);
   endspecify
   
   initial
   begin
      prev_value = 'b0;
      tmp_padio = 'bz;
      if (operation_mode == "input")
         iop_mode = 0;
      else if (operation_mode == "output")
         iop_mode = 1;
      else if (operation_mode == "bidir")
         iop_mode = 2;
      else
      begin
         $display ("Error: Invalid operation_mode specified\n");
         iop_mode = 3;
      end

      dqs_delay = 0;
      tmp_delayctrl = 0;
      tmp_offsetctrl = 0;
      para_dqs_ctrl_latches_enable = dqs_ctrl_latches_enable == "true" ? 1'b1 : 1'b0;
      para_dqs_offsetctrl_enable = dqs_offsetctrl_enable == "true" ? 1'b1 : 1'b0;
      para_dqs_edge_detect_enable = dqs_edge_detect_enable == "true" ? 1'b1 : 1'b0;
   end

   assign dqs_ctrl_latches_ena = dqs_ctrl_latches_enable == "false" ? 1'b1 : 
                                 dqs_edge_detect_enable == "false" ? dqsupdateen_in :
                                 (~(combout_tmp ^ tmp_dqsbusout) & dqsupdateen_in);

   always @(delayctrlin_in or offsetctrlin_in or dqs_ctrl_latches_ena)
   begin
      tmp_delayctrl  = delayctrlin_in;
      tmp_offsetctrl = (para_dqs_offsetctrl_enable == 1'b1) ? offsetctrlin_in : 0;
      if (dqs_ctrl_latches_ena === 1'b1)
	     dqs_delay = sim_dqs_intrinsic_delay + sim_dqs_delay_increment*tmp_delayctrl + sim_dqs_offset_increment*tmp_offsetctrl;

      if (dqs_delay_buffer_mode == "high" && delayctrlin_in[5] == 1'b1)
      begin
         $display($time, " Warning: DLL instannce %m exceeds a 5-bit delayctrlin range in high-frequency mode.");
         dqs_delay = 0;
      end
   end
 
    always @(datain_in or oe_in or padio)
    begin   
        if (bus_hold == "true" )
        begin
            buf_control = 'b1;
            if (iop_mode == 0)
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
                if (iop_mode == 1 || iop_mode == 2) // output or bidir
                begin
                    if ( oe_in == 1)
                    begin
                        if ( open_drain_output == "true" )
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
                                if (iop_mode == 2) // bidir
                                    prev_value = padio;
                                tmp_padio = 1'bz;
                            end
                        end  
                        else  // open drain_output = false;
                        begin
                            tmp_padio = datain_in;
                            prev_value = datain_in;
                        end
                    end   
                    else if ( oe_in == 0 )
                    begin
                        if (iop_mode == 2) // bidir
                            prev_value = padio;
                        
                        tmp_padio = 1'bz;
                    end
                    else   // oe == 'X' 
                    begin
                       tmp_padio = 1'bx;
                       prev_value = 1'bx;
                    end
                end
			
                if (iop_mode == 1) // output
                    tmp_combout = 1'bz;
                else
                    tmp_combout = padio;
            end
        end
        else    // bus hold is false
        begin
            buf_control = 'b0;
            if (iop_mode == 0) // input
            begin
                tmp_combout = padio;
            end 
            else if (iop_mode == 1 || iop_mode == 2) // output or bidir
            begin
                if (iop_mode  == 2) // bidir
                    tmp_combout = padio;
				
                if ( oe_in == 1 )
                begin
                    if ( open_drain_output == "true" )
                    begin
                        if (datain_in == 0)
                            tmp_padio = 1'b0;
                        else if ( datain_in == 1'bx)
                            tmp_padio = 1'bx;
                        else
                            tmp_padio = 1'bz;
                    end
                    else
                        tmp_padio = datain_in;
                end     
                else if ( oe_in == 0 )
                    tmp_padio = 1'bz;
                else
                    tmp_padio = 1'bx;
            end
            else
                $display ("Error: Invalid operation_mode specified in stratixii io atom!\n");
        end      
        combout_tmp <= tmp_combout;
        tmp_dqsbusout <= #(dqs_delay) tmp_combout;
   end  
   
   assign dqsbusout_tmp = gated_dqs == "true" ? (tmp_dqsbusout & regin) : tmp_dqsbusout;
   
   bufif1 (weak1, weak0) b(padio_tmp, prev_value, buf_control);  //weak value
   pmos (padio_tmp, tmp_padio, 'b0);
   pmos (combout, combout_tmp, 'b0);
   pmos (dqsbusout, dqsbusout_tmp, 'b0);
   pmos (padio, padio_tmp, 'b0);
   and (regout, regin, 1'b1);
   and (ddioregout, ddioregin, 1'b1);

endmodule

///////////////////////////////////////////////////////////////////////////////
//
//                             STRATIXII_IO_REGISTER
//
///////////////////////////////////////////////////////////////////////////////

module  stratixii_io_register (
                               clk, 
                               datain, 
                               ena, 
                               sreset, 
                               areset, 
                               devclrn, 
                               devpor, 
                               regout
                              );
   parameter async_reset = "none";
   parameter sync_reset = "none";
   parameter power_up = "low";
   
   input clk;
   input ena;
   input datain;
   input areset;
   input sreset;
   input devclrn;
   input devpor ;
   output regout;
   
   reg iregout;
   wire clk_in;
   wire reset;
   wire is_areset_clear;
   wire is_areset_preset;
   
   reg datain_viol;
   reg sreset_viol;
   reg ena_viol;
   reg violation;
   
   reg clk_last_value;
   
   buf (clk_in, clk);
   buf (idatain, datain);
   buf (iareset, areset);
   buf (isreset, sreset);
   buf (iena, ena);
   
   assign reset = devpor && devclrn && !(iareset && async_reset != "none") && (iena);
   
   assign is_areset_clear = (async_reset == "clear")?1'b1:1'b0;
   assign is_areset_preset = (async_reset == "preset")?1'b1:1'b0;
   
   specify
      
      $setuphold (posedge clk &&& reset, datain, 0, 0, datain_viol) ;
      $setuphold (posedge clk &&& reset, sreset, 0, 0, sreset_viol) ;
      $setuphold (posedge clk &&& reset, ena, 0, 0, ena_viol) ;
      
      (posedge clk => (regout +: iregout)) = 0 ;
      
      if (is_areset_clear == 1'b1)
         (posedge areset => (regout +: 1'b0)) = (0,0);
      if ( is_areset_preset == 1'b1)
         (posedge areset => (regout +: 1'b1)) = (0,0);
      
   endspecify
   
   initial
   begin
      violation = 0;
      if (power_up == "low")
         iregout = 'b0;
      else if (power_up == "high")
         iregout = 'b1;
      end
   
   always @ (datain_viol or sreset_viol or ena_viol)
   begin
      violation = 1;
   end
   
   always @ (clk_in or posedge iareset or negedge devclrn or negedge devpor or posedge violation)
   begin
      if (violation == 1'b1)
      begin
         violation = 0;
         iregout = 'bx;
      end
      else if (devpor == 'b0)
      begin
         if (power_up == "low")
            iregout = 'b0;
         else if (power_up == "high")
            iregout = 'b1;
      end
      else if (devclrn == 'b0)
         iregout = 'b0;
      else if (async_reset == "clear" && iareset == 'b1) 
         iregout = 'b0 ;
      else if (async_reset == "preset" && iareset == 'b1 )
         iregout = 'b1;
      else if (iena == 'b1 && clk_in == 'b1 && clk_last_value == 'b0)
      begin
          if (sync_reset == "clear" && isreset == 'b1)
              iregout = 'b0 ;
          else if (sync_reset == "preset" && isreset == 'b1)
              iregout = 'b1;
         else
              iregout = idatain ;
      end
      clk_last_value = clk_in;
   end
   and (regout, iregout, 'b1) ;
endmodule

///////////////////////////////////////////////////////////////////////////////
//
//                                STRATIXII_IO
//
///////////////////////////////////////////////////////////////////////////////

module stratixii_io (
                     datain,
                     ddiodatain,
                     oe,
                     outclk,
                     outclkena,
                     inclk,
                     inclkena,
                     areset,
                     sreset,
                     ddioinclk,
                     delayctrlin,
                     offsetctrlin,
                     dqsupdateen,
                     linkin,
                     devclrn,
                     devpor,
                     devoe,
                     padio,
                     combout,
                     regout,
                     ddioregout,
                     dqsbusout,
                     linkout
                    );
   
parameter operation_mode = "input";
parameter ddio_mode = "none";
parameter open_drain_output = "false";
parameter bus_hold = "false";
   
parameter output_register_mode = "none";
parameter output_async_reset = "none";
parameter output_power_up = "low";
parameter output_sync_reset = "none";
parameter tie_off_output_clock_enable = "false";
   
parameter oe_register_mode = "none";
parameter oe_async_reset = "none";
parameter oe_power_up = "low";
parameter oe_sync_reset = "none";
parameter tie_off_oe_clock_enable = "false";
   
parameter input_register_mode = "none";
parameter input_async_reset = "none";
parameter input_power_up = "low";
parameter input_sync_reset = "none";
   
parameter extend_oe_disable = "false";
 
parameter dqs_input_frequency = "10000 ps";
parameter dqs_out_mode = "none";
parameter dqs_delay_buffer_mode = "low";
parameter dqs_phase_shift = 0;
parameter inclk_input = "normal";
parameter ddioinclk_input = "negated_inclk";
parameter dqs_offsetctrl_enable = "false";
parameter dqs_ctrl_latches_enable = "false";
parameter dqs_edge_detect_enable = "false";
parameter gated_dqs = "false";

parameter sim_dqs_intrinsic_delay = 0;
parameter sim_dqs_delay_increment = 0;
parameter sim_dqs_offset_increment = 0;
  
parameter lpm_type = "stratixii_io";
  
input datain;
input ddiodatain;
input oe;
input outclk;
input outclkena;
input inclk;
input inclkena;
input areset;
input sreset;
input ddioinclk;
input [5:0] delayctrlin;
input [5:0] offsetctrlin;
input dqsupdateen;
input linkin;
input devclrn;
input devpor;
input devoe;
  
inout padio;
  
output combout;
output regout;
output ddioregout;
output dqsbusout;
output linkout;
     
wire      oe_reg_out, oe_pulse_reg_out;
wire      in_reg_out, in_ddio0_reg_out, in_ddio1_reg_out;
wire      out_reg_out, out_ddio_reg_out;
   
wire      out_clk_ena, oe_clk_ena;
wire      tmp_datain;
wire      ddio_data;
wire      oe_out;
wire      outclk_delayed;

wire      para_ddioinclk_input;
wire      neg_ireg_clk;
wire      para_gated_dqs;

assign para_ddioinclk_input = ddioinclk_input == "dqsb_bus" ? 1'b1 : 1'b0;
assign neg_ireg_clk = para_ddioinclk_input === 1'b1 ? !ddioinclk : inclk;
assign para_gated_dqs = gated_dqs == "true" ? 1'b1 : 1'b0;
  
assign out_clk_ena = (tie_off_output_clock_enable == "false") ? outclkena : 1'b1;
assign oe_clk_ena = (tie_off_oe_clock_enable == "false") ? outclkena : 1'b1;
   
   //input register
   stratixii_io_register in_reg (
                                 .regout(in_reg_out), 
                                 .clk(inclk), 
                                 .ena(inclkena),
                                 .datain(padio), 
                                 .areset(areset),
                                 .sreset(sreset), 
                                 .devpor(devpor),
                                 .devclrn(devclrn)
                                );
   defparam in_reg.async_reset = input_async_reset;
   defparam in_reg.sync_reset = input_sync_reset;
   defparam in_reg.power_up = input_power_up;
   
   // in_ddio0_reg
   stratixii_io_register in_ddio0_reg (
                                       .regout(in_ddio0_reg_out),
                                       .clk(!neg_ireg_clk), 
                                       .ena (inclkena),
                                       .datain(padio), 
                                       .areset(areset),
                                       .sreset(sreset),
                                       .devpor(devpor),
                                       .devclrn(devclrn)
                                      );
   defparam in_ddio0_reg.async_reset = input_async_reset;
   defparam in_ddio0_reg.sync_reset = input_sync_reset;
   defparam in_ddio0_reg.power_up = input_power_up;
   
   // in_ddio1_reg
   stratixii_io_register in_ddio1_reg (
                                       .regout(in_ddio1_reg_out),
                                       .clk(inclk), 
                                       .ena(inclkena),
                                       .datain(in_ddio0_reg_out),
                                       .areset(areset),
                                       .sreset(1'b0),
                                       .devpor(devpor),
                                       .devclrn(devclrn)
                                      );
   defparam in_ddio1_reg.async_reset = input_async_reset;
   defparam in_ddio1_reg.sync_reset = "none"; // this register has no sync_reset
   defparam in_ddio1_reg.power_up = input_power_up;
   
   // out_reg
   stratixii_io_register out_reg (
                                  .regout(out_reg_out),
                                  .clk(outclk), 
                                  .ena(out_clk_ena),
                                  .datain(datain), 
                                  .areset(areset),
                                  .sreset(sreset),
                                  .devpor(devpor),
                                  .devclrn(devclrn)
                                 );
   defparam out_reg.async_reset = output_async_reset;
   defparam out_reg.sync_reset = output_sync_reset;
   defparam out_reg.power_up = output_power_up;
   
   // out ddio reg
   stratixii_io_register out_ddio_reg (
                                       .regout(out_ddio_reg_out), 
                                       .clk(outclk), 
                                       .ena(out_clk_ena),
                                       .datain(ddiodatain), 
                                       .areset(areset),
                                       .sreset(sreset),
                                       .devpor(devpor),
                                       .devclrn(devclrn)
                                      );
   defparam out_ddio_reg.async_reset = output_async_reset;
   defparam out_ddio_reg.sync_reset = output_sync_reset;
   defparam out_ddio_reg.power_up = output_power_up;
   
   // oe reg
   stratixii_io_register oe_reg (
                                 .regout (oe_reg_out),
                                 .clk(outclk), 
                                 .ena(oe_clk_ena),
                                 .datain(oe), 
                                 .areset(areset),
                                 .sreset(sreset),
                                 .devpor(devpor),
                                 .devclrn(devclrn) 
                                );
   defparam oe_reg.async_reset = oe_async_reset;
   defparam oe_reg.sync_reset = oe_sync_reset;
   defparam oe_reg.power_up = oe_power_up;
   
   // oe_pulse reg
   stratixii_io_register oe_pulse_reg (
                                       .regout(oe_pulse_reg_out),
                                       .clk(!outclk),
                                       .ena(oe_clk_ena),
                                       .datain(oe_reg_out), 
                                       .areset(areset),
                                       .sreset(sreset),
                                       .devpor(devpor),
                                       .devclrn(devclrn)
                                      );
   defparam oe_pulse_reg.async_reset = oe_async_reset;
   defparam oe_pulse_reg.sync_reset = oe_sync_reset;
   defparam oe_pulse_reg.power_up = oe_power_up;
   
   assign oe_out = (oe_register_mode == "register") ? 
		   (extend_oe_disable == "true" ? oe_pulse_reg_out && oe_reg_out : oe_reg_out) : oe;
    
   and1    sel_delaybuf (.Y(outclk_delayed), .IN1(outclk));
   
   stratixii_mux21   ddio_data_mux (
                          .MO (ddio_data),
                          .A (out_ddio_reg_out),
                          .B (out_reg_out),
                          .S (outclk_delayed)
                         );
   
   assign tmp_datain = (ddio_mode == "output" || ddio_mode == "bidir") ? 
                ddio_data : ((operation_mode == "output" || operation_mode == "bidir") ? 
                   ((output_register_mode == "register") ? out_reg_out : datain) : 'b0);
         
   // timing info in case output and/or input are not registered.
   stratixii_asynch_io inst1 (
                              .datain(tmp_datain),
                              .oe(oe_out),
                              .regin(in_reg_out),
                              .ddioregin(in_ddio1_reg_out),
                              .padio(padio),
                              .delayctrlin(delayctrlin),
                              .offsetctrlin(offsetctrlin),
							  .dqsupdateen(dqsupdateen),
							  .dqsbusout(dqsbusout),
                              .combout(combout),
                              .regout(regout),
                              .ddioregout(ddioregout)
                             );
   defparam inst1.operation_mode = operation_mode;
   defparam inst1.bus_hold = bus_hold;
   defparam inst1.open_drain_output = open_drain_output;

   defparam inst1.dqs_input_frequency = dqs_input_frequency;
   defparam inst1.dqs_out_mode = dqs_out_mode;
   defparam inst1.dqs_delay_buffer_mode = dqs_delay_buffer_mode;
   defparam inst1.dqs_phase_shift = dqs_phase_shift;
   defparam inst1.dqs_offsetctrl_enable = dqs_offsetctrl_enable;
   defparam inst1.dqs_ctrl_latches_enable = dqs_ctrl_latches_enable;
   defparam inst1.dqs_edge_detect_enable = dqs_edge_detect_enable;    
   defparam inst1.sim_dqs_intrinsic_delay = sim_dqs_intrinsic_delay;
   defparam inst1.sim_dqs_delay_increment = sim_dqs_delay_increment;
   defparam inst1.sim_dqs_offset_increment = sim_dqs_offset_increment;
   defparam inst1.gated_dqs = gated_dqs;
   
endmodule

//////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixII_dll
//
// Description : Simulation model for StratixII DLL block
//
// Outputs     : delayctrlout - current delay chain settings for DQS pin
//               offsetctrlout - current delay offset setting
//               dqsupdate - update enable signal for delay setting latces
//               upndnout - raw output of the phase comparator
//
// Inputs      : clk - reference clock matching in frequency to DQS clock
//               aload - asychronous load signal for delay setting counter
//                       when asserted, counter is loaded with initial value
//               offset - offset added/subtracted from delayctrlout
//               upndnin - up/down input port for delay setting counter in
//                         use_updndnin mode (user control mode)
//               upndninclkena - clock enable for the delaying setting counter
//               addnsub - dynamically control +/- on offsetctrlout
//
// Formulae    : delay (input_period) = sim_loop_intrinsic_delay + 
//                                      sim_loop_delay_increment * dllcounter;
//
// Latency     : 3 (clk8 cycles) = pc + dc + dr
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module stratixii_dll (clk, aload, offset, upndnin, upndninclkena, addnsub, 
    delayctrlout, offsetctrlout, dqsupdate, upndnout, devclrn, devpor);

// GLOBAL PARAMETERS - total 15
parameter input_frequency    = "10000 ps";
parameter delay_chain_length = 16;
parameter delay_buffer_mode  = "high";   // consistent with dqs
parameter delayctrlout_mode  = "normal";
parameter static_delay_ctrl  = 0;        // for test
parameter offsetctrlout_mode = "static";
parameter static_offset      = "0";
parameter jitter_reduction   = "false";
parameter use_upndnin        = "false";
parameter use_upndninclkena  = "false";
parameter sim_valid_lock     = 1;
parameter sim_loop_intrinsic_delay = 1000;
parameter sim_loop_delay_increment = 100;
parameter sim_valid_lockcount      = 90;  // 10000 = 1000 + 100*dllcounter
parameter lpm_type                 = "stratixii_dll";

// INPUT PORTS
input        clk;
input        aload;
input [5:0]  offset;
input        upndnin;
input        upndninclkena;
input        addnsub;
input        devclrn;
input        devpor;

// OUTPUT PORTS
output [5:0] delayctrlout;
output [5:0] offsetctrlout;
output       dqsupdate;
output       upndnout;


// BUFFERED BUS INPUTS
wire [5:0] offset_in;

// TMP OUTPUTS
wire [5:0] delayctrl_out;
wire [5:0] offsetctrl_out;
wire       dqsupdate_out;
wire       upndn_out;

// FUNCTIONS

// convert string to integer with sign
function integer str2int; 
    input [8*16:1] s;

    reg [8*16:1] reg_s;
    reg [8:1] digit;
    reg [8:1] tmp;
    integer m, magnitude;
    integer sign;

    begin
        sign = 1;
        magnitude = 0;
        reg_s = s;
        for (m=1; m<=16; m=m+1)
        begin
            tmp = reg_s[128:121];
            digit = tmp & 8'b00001111;
            reg_s = reg_s << 8;
            // Accumulate ascii digits 0-9 only.
            if ((tmp>=48) && (tmp<=57)) 
                magnitude = (magnitude * 10) + digit;
            if (tmp == 45)
                sign = -1;  // Found a '-' character, i.e. number is negative.
        end
        str2int = sign*magnitude;
    end
endfunction  // str2int

// Const VARIABLES to represent string parameters
reg [1:0] para_delay_buffer_mode;
reg [1:0] para_delayctrlout_mode;
reg [1:0] para_offsetctrlout_mode;
integer   para_static_offset;
integer   para_static_delay_ctrl;
reg       para_jitter_reduction;
reg       para_use_upndnin;
reg       para_use_upndninclkena;
 

// INTERNAL NETS AND VARIABLES

// for functionality - by modules

// delay and offset control out resolver
wire [5:0] dr_delayctrl_out;
wire [5:0] dr_delayctrl_int;
wire [5:0] dr_offsetctrl_out;
wire [5:0] dr_offsetctrl_int;
wire [5:0] dr_offset_in;
wire [5:0] dr_dllcount_in;
wire       dr_addnsub_in;
wire       dr_clk8_in;
wire       dr_aload_in;

reg  [5:0] dr_reg_offset;
reg  [5:0] dr_reg_dllcount;

// delay chain setting counter
wire [5:0] dc_dllcount_out;
wire       dc_dqsupdate_out;
wire       dc_upndn_in;
wire       dc_aload_in;
wire       dc_upndnclkena_in;
wire       dc_clk8_in;
wire       dc_clk1_in;
wire       dc_dlltolock_in;

reg [5:0]  dc_reg_dllcount;
reg        dc_reg_dlltolock_pulse;

// jitter reduction counter
wire       jc_upndn_out;
wire       jc_upndnclkena_out;
wire       jc_clk8_in;
wire       jc_upndn_in;
wire       jc_aload_in;

integer    jc_count;
reg        jc_reg_upndn;
reg        jc_reg_upndnclkena;

// phase comparator
wire       pc_upndn_out;
wire [5:0] pc_dllcount_in;
wire       pc_clk1_in;
wire       pc_clk8_in;
wire       pc_aload_in;

reg        pc_reg_upndn;
integer    pc_delay; 

// clock generator
wire       cg_clk_in;
wire       cg_aload_in;
wire       cg_clk1_out;
        
wire cg_clk8a_out;
wire cg_clk8b_out;
     
reg cg_reg_1;
reg cg_rega_2;
reg cg_rega_3;
       
reg cg_regb_2;
reg cg_regb_3;

// for violation checks
reg clk_in_last_value;
reg got_first_rising_edge;
reg got_first_falling_edge;

reg per_violation;
reg duty_violation;
reg sent_per_violation;
reg sent_duty_violation;


reg dll_to_lock;  // exported signal  

time clk_in_last_rising_edge;
time clk_in_last_falling_edge;

integer input_period;
integer clk_per_tolerance;
integer duty_cycle;
integer half_cycles_to_lock;
integer clk_in_period;
integer clk_in_duty_cycle;


// Timing hooks

// BUFFER INPUTS
buf (clk_in, clk);
buf (aload_in, aload);
buf (offset_in5, offset[5]);
buf (offset_in4, offset[4]);
buf (offset_in3, offset[3]);
buf (offset_in2, offset[2]);
buf (offset_in1, offset[1]);
buf (offset_in0, offset[0]);
buf (upndn_in, upndnin);
buf (upndninclkena_in, upndninclkena); 
buf (addnsub_in, addnsub);

assign offset_in = {offset_in5, offset_in4, 
                    offset_in3, offset_in2, 
                    offset_in1, offset_in0};

// TCO DELAYS, IO PATH and SETUP-HOLD CHECKS
specify
	(posedge clk => (delayctrlout[0] +: delayctrl_out[0])) = (0, 0);
	(posedge clk => (delayctrlout[1] +: delayctrl_out[1])) = (0, 0);
	(posedge clk => (delayctrlout[2] +: delayctrl_out[2])) = (0, 0);
	(posedge clk => (delayctrlout[3] +: delayctrl_out[3])) = (0, 0);
	(posedge clk => (delayctrlout[4] +: delayctrl_out[4])) = (0, 0);
	(posedge clk => (delayctrlout[5] +: delayctrl_out[5])) = (0, 0);

    (posedge clk  => (upndnout +: upndn_out)) = (0, 0);
    (offset => delayctrlout) = (0, 0);

	$setuphold(posedge clk, offset[0], 0, 0);
	$setuphold(posedge clk, offset[1], 0, 0);
	$setuphold(posedge clk, offset[2], 0, 0);
	$setuphold(posedge clk, offset[3], 0, 0);
	$setuphold(posedge clk, offset[4], 0, 0);
	$setuphold(posedge clk, offset[5], 0, 0);
	$setuphold(posedge clk, upndnin, 0, 0);
	$setuphold(posedge clk, upndninclkena, 0, 0);
	$setuphold(posedge clk, addnsub, 0, 0);
endspecify

// DRIVERs FOR outputs
and (delayctrlout[0], delayctrl_out[0], 1'b1);
and (delayctrlout[1], delayctrl_out[1], 1'b1);
and (delayctrlout[2], delayctrl_out[2], 1'b1);
and (delayctrlout[3], delayctrl_out[3], 1'b1);
and (delayctrlout[4], delayctrl_out[4], 1'b1);
and (delayctrlout[5], delayctrl_out[5], 1'b1);
and (offsetctrlout[0], offsetctrl_out[0], 1'b1);
and (offsetctrlout[1], offsetctrl_out[1], 1'b1);
and (offsetctrlout[2], offsetctrl_out[2], 1'b1);
and (offsetctrlout[3], offsetctrl_out[3], 1'b1);
and (offsetctrlout[4], offsetctrl_out[4], 1'b1);
and (offsetctrlout[5], offsetctrl_out[5], 1'b1);
and (dqsupdate, dqsupdate_out, 1'b1);
and (upndnout, upndn_out, 1'b1);


// INITIAL BLOCK - info messsage and legaity checks
initial
begin
    input_period = str2int(input_frequency);
    $display("Note: DLL instance %m has input frequency %0d ps", input_period);
    $display("      sim_valid_lock %0d", sim_valid_lock);
    $display("      sim_valid_lockcount %0d", sim_valid_lockcount);
    $display("      sim_loop_intrinsic_delay %0d", sim_loop_intrinsic_delay);
    $display("      sim_loop_delay_increment %0d", sim_loop_delay_increment);

    clk_in_last_value = 0;
    clk_in_last_rising_edge = 0;
    clk_in_last_falling_edge = 0;
    got_first_rising_edge = 0;
    got_first_falling_edge = 0;
 
    per_violation = 1'b0;
    duty_violation = 1'b0;
    sent_per_violation = 1'b0;
    sent_duty_violation = 1'b0;
    duty_cycle = input_period/2;
    clk_per_tolerance = 0;  // input_period * 0.1;
    clk_in_period = 0;
    clk_in_duty_cycle = 0;

    dll_to_lock = 0;
    half_cycles_to_lock = 0;

    // Resolve string parameters
    para_delay_buffer_mode = delay_buffer_mode == "auto" ? 2'b00 : 
	                         delay_buffer_mode == "low" ? 2'b01 : 2'b10;
    para_delayctrlout_mode = delayctrlout_mode == "offset_only" ? 2'b01 : 
	                         delayctrlout_mode == "normal_offset" ? 2'b10 : 
                     		 delayctrlout_mode == "static" ? 2'b11 : 2'b00;
    para_offsetctrlout_mode = offsetctrlout_mode == "dynamic_addnsub" ? 2'b11 :
                              offsetctrlout_mode == "dynamic_sub" ? 2'b10 :
	                          offsetctrlout_mode == "dynamic_add" ? 2'b01 : 2'b00;
    para_static_offset = str2int(static_offset);
	para_static_delay_ctrl = static_delay_ctrl;
    para_jitter_reduction = jitter_reduction == "true" ? 1'b1 : 1'b0;
    para_use_upndnin = use_upndnin == "true" ? 1'b1 : 1'b0;
    para_use_upndninclkena = use_upndninclkena == "true" ? 1'b1 : 1'b0;

    $display("      delay_buffer_mode %0s", delay_buffer_mode);
    $display("      delayctrlout_mode %0s", delayctrlout_mode);
    $display("      static_delay_ctrl %0d", para_static_delay_ctrl);
    $display("      offsetctrlout_mode %0s", offsetctrlout_mode);
    $display("      static_offset %0d", para_static_offset);
    $display("      use_jitter_reduction %0s", jitter_reduction);
    $display("      use_upndnin %0s", use_upndnin);
    $display("      use_upndninclkena %0s", use_upndninclkena);
end

// CLOCK PERIOD and DUTY CYCLE VIOLATION CHECKS and DLL_TO_LOCK
// exported signals to outside of this block:
//     - dll_to_lock
always @(clk_in)
begin
    if (clk_in == 1'b1 && clk_in != clk_in_last_value) // rising edge
    begin
        if (got_first_rising_edge == 1'b0)
        begin
            got_first_rising_edge <= 1;
            half_cycles_to_lock = half_cycles_to_lock + 1;
            if (half_cycles_to_lock >= sim_valid_lock)
            begin
                dll_to_lock <= 1;
                $display($time, "  Note : DLL instance %m to lock to incoming clock per sim_valid_lock half clock cycles.");
            end
        end
        else   // subsequent rising edge 
	    begin
            // check for clk_period violation and duty cycle violation
            clk_in_period = $time - clk_in_last_rising_edge; 
            clk_in_duty_cycle = $time - clk_in_last_falling_edge;
            if ( (clk_in_period < (input_period - clk_per_tolerance)) ||
                 (clk_in_period > (input_period + clk_per_tolerance)) )
            begin
                per_violation = 1'b1;
                if (sent_per_violation != 1'b1)
                begin
                    $display($time, "  Warning : Input frequency violation on DLL instance %m. Specified input period is %0d ps but actual is %0d ps", 
				                input_period, clk_in_period);
                    sent_per_violation = 1'b1;
                end
            end
            else if ( (clk_in_duty_cycle < (duty_cycle - clk_per_tolerance/2 - 1)) || 
			          (clk_in_duty_cycle > (duty_cycle + clk_per_tolerance/2 + 1)) )
            begin
                duty_violation = 1'b1;
                if (sent_duty_violation != 1'b1)
                begin
                    $display($time, "  Warning : Duty Cycle violation DLL instance %m. Specified duty cycle is %0d ps but actual is %0d ps",
				                   duty_cycle, clk_in_duty_cycle);
                    sent_duty_violation = 1'b1;
                end
            end
            else
            begin
                if (per_violation === 1'b1)
                begin
                    $display($time, "  Note : Input frequency on DLL instance %m now matches with specified clock frequency.");
                    sent_per_violation = 1'b0;
                end
                per_violation = 1'b0;
                duty_violation = 1'b0;
	        end

            if ((duty_violation == 1'b0) && (per_violation == 1'b0) && (dll_to_lock == 1'b0))
            begin
                // increment lock counter
                half_cycles_to_lock = half_cycles_to_lock + 1;
                if (half_cycles_to_lock >= sim_valid_lock)
                begin
                    dll_to_lock <= 1;
                    $display($time, "  Note : DLL instance %m to lock to incoming clock per sim_valid_lock half clock cycles.");
                end
            end    
        end

        clk_in_last_rising_edge = $time;
    end
    else if (clk_in == 1'b0 && clk_in != clk_in_last_value) // falling edge
    begin
        got_first_falling_edge = 1;
        if (got_first_rising_edge == 1'b1)
        begin
            // check for duty cycle violation
			clk_in_duty_cycle = $time - clk_in_last_rising_edge;
            if ( (clk_in_duty_cycle < (duty_cycle - clk_per_tolerance/2 - 1)) || 
			     (clk_in_duty_cycle > (duty_cycle + clk_per_tolerance/2 + 1)) )
            begin
                duty_violation = 1'b1;
                if (sent_duty_violation != 1'b1)
                begin
                    $display($time, "  Warning : Duty Cycle violation DLL instance %m. Specified duty cycle is %0d ps but actual is %0d ps",
				                   duty_cycle, clk_in_duty_cycle);
                    sent_duty_violation = 1'b1;
                end
            end
            else
                duty_violation = 1'b0;

            if (dll_to_lock == 1'b0 && duty_violation == 1'b0)
            begin
                // increment lock counter
                half_cycles_to_lock = half_cycles_to_lock + 1;
            end
        end
        else
        begin
            // first clk edge is falling edge, do nothing
        end
        clk_in_last_falling_edge = $time;
    end
    else if (got_first_rising_edge == 1'b1 || got_first_falling_edge == 1'b1)     
	begin
	    // 1 or 0 to X transitions - illegal
        // reset lock and unlock counters
        half_cycles_to_lock = 0;
        got_first_rising_edge = 0;
        got_first_falling_edge = 0;

        if (dll_to_lock)
        begin
            dll_to_lock <= 0;
            $display($time, "  Error : clock switches from 0/1 to X. DLL instance %m will lose lock.");
        end
        else
        begin
            $display($time, "  Error : clock switches from 0/1 to X on DLL instance %m");
        end
    end

    clk_in_last_value <= clk_in;
end

// CONNCECTING the DLL outputs ------------------------------------------------
assign delayctrl_out  = dr_delayctrl_out;
assign offsetctrl_out = dr_offsetctrl_out;
assign dqsupdate_out  = cg_clk8a_out;
assign upndn_out      = pc_upndn_out;

// Delay and offset ctrl out resolver -----------------------------------------

    // inputs
    assign dr_clk8_in = ~cg_clk8b_out;       // inverted
    assign dr_offset_in = ((offsetctrlout_mode == "dynamic_addnsub" &&  dr_addnsub_in === 1'b0) || (offsetctrlout_mode == "dynamic_sub"))  ? 
                           (6'b111111 - offset_in + 6'b000001) : offset_in;
    assign dr_dllcount_in = dc_dllcount_out; 
    assign dr_addnsub_in = addnsub_in;
    assign dr_aload_in = aload_in;

    // outputs
    assign dr_delayctrl_out = (delayctrlout_mode == "test") ? {cg_clk1_out,aload,addnsub,dr_reg_dllcount[2:0]} :
                              (delayctrlout_mode == "offset_only")   ?  dr_offset_in  :
                              (delayctrlout_mode == "normal_offset") ?  dr_reg_offset 
							  : dr_reg_dllcount;  // both static and normal

	assign dr_offsetctrl_out = dr_reg_offset; 

    // model

	assign dr_delayctrl_int = (delayctrlout_mode == "static") ? para_static_delay_ctrl : dr_dllcount_in;
    
    assign dr_offsetctrl_int = (offsetctrlout_mode == "static") ? para_static_offset : dr_offset_in;
     
	// por
    initial
    begin
        dr_reg_offset = 6'b000000;
        dr_reg_dllcount = 6'b000000;
    end

    always @(posedge dr_clk8_in or posedge dr_aload_in )
    begin
        if (dr_aload_in === 1'b1)
            dr_reg_dllcount <= 6'b000000;
        else    
            dr_reg_dllcount <= dr_delayctrl_int;
    end

    always @(posedge dr_clk8_in or posedge dr_aload_in)
    begin
        if (dr_aload_in === 1'b1)
        begin
            dr_reg_offset <= 6'b000000;
        end
        else if (offsetctrlout_mode == "dynamic_addnsub")      // addnsub
        begin
            if (dr_addnsub_in === 1'b1)
                if (dr_delayctrl_int < 6'b111111 - dr_offset_in)
                    dr_reg_offset <= dr_delayctrl_int + dr_offset_in;
                else 
				    dr_reg_offset <= 6'b111111;
            else if (dr_addnsub_in === 1'b0)
                if (dr_delayctrl_int > dr_offset_in)
                    dr_reg_offset <= dr_delayctrl_int - dr_offset_in;
                else
                    dr_reg_offset <= 6'b000000;
        end
        else if (offsetctrlout_mode == "dynamic_sub")  // sub
        begin
            if (dr_delayctrl_int > dr_offset_in)
                dr_reg_offset <= dr_delayctrl_int - dr_offset_in;
            else
                dr_reg_offset <= 6'b000000;
        end     
        else if (offsetctrlout_mode == "dynamic_add")  // add
        begin
            if (dr_delayctrl_int < 6'b111111 - dr_offset_in)
                dr_reg_offset <= dr_delayctrl_int + dr_offset_in;
            else 
                dr_reg_offset <= 6'b111111;
        end
        else if (offsetctrlout_mode == "static")       // static
        begin
	        if (para_static_offset >= 0)
                if (para_static_offset < 64 && para_static_offset < 6'b111111 - dr_delayctrl_int)
                    dr_reg_offset <= dr_delayctrl_int + para_static_offset;
				else
				    dr_reg_offset <= 6'b111111;
            else
                if (para_static_offset > -63 && dr_delayctrl_int > (-1)*para_static_offset)
                    dr_reg_offset <= dr_delayctrl_int + para_static_offset;
                else
                    dr_reg_offset <= 6'b000000;
        end
        else
    	    dr_reg_offset <= 6'b001110;  // Error
    end

// Delay Setting Control Counter ----------------------------------------------
            
    //inputs
    assign dc_dlltolock_in = dll_to_lock;
    assign dc_aload_in = aload_in;
    assign dc_clk1_in = cg_clk1_out;
    assign dc_clk8_in = ~cg_clk8b_out;      // inverted
    assign dc_upndnclkena_in = (para_jitter_reduction === 1'b1) ? jc_upndnclkena_out : 
	                           (para_use_upndninclkena === 1'b1) ? upndninclkena : 1'b1;
    assign dc_upndn_in = (para_use_upndnin === 1'b1) ? upndnin :
	                     (para_jitter_reduction === 1'b1) ? jc_upndn_out : pc_upndn_out;

    // outputs
    assign dc_dllcount_out = dc_reg_dllcount;

    // parameters used
    // sim_valid_lockcount - ideal dll count value
    // delay_buffer_mode - 

    // Model
    initial
    begin		
        // low=32=6'b100000 others=16
        dc_reg_dllcount = delay_buffer_mode == "low" ? 6'b100000 : 6'b010000;
		dc_reg_dlltolock_pulse = 1'b0;
    end

	// dll counter logic
    always @(posedge dc_clk8_in or posedge dc_aload_in or posedge dc_dlltolock_in)
    begin
        if (dc_aload_in === 1'b1) 
            dc_reg_dllcount <= delay_buffer_mode == "low" ? 6'b100000 : 6'b010000;
		else if (dc_dlltolock_in === 1'b1 && dc_upndnclkena_in === 1'b1 && 
                 para_use_upndnin === 1'b0 && dc_reg_dlltolock_pulse != 1'b1)
        begin
		    dc_reg_dllcount <= sim_valid_lockcount;
			dc_reg_dlltolock_pulse <= 1'b1;
		end
        else if (dc_upndnclkena_in === 1'b1) // posedge clk
        begin
            if (dc_upndn_in === 1'b1)
            begin
                if ((para_delay_buffer_mode == 2'b01 && dc_reg_dllcount < 6'b111111) ||
                         (para_delay_buffer_mode != 2'b01 && dc_reg_dllcount < 6'b011111))
                    dc_reg_dllcount <= dc_reg_dllcount + 1'b1;
			end
			else if (dc_upndn_in === 1'b0)
			begin
                if (dc_reg_dllcount > 6'b000000)
                    dc_reg_dllcount <= dc_reg_dllcount - 1'b1;
			end
        end
    end
             
// Jitter reduction counter ---------------------------------------------------

    // inputs
    assign jc_clk8_in = ~cg_clk8b_out;         // inverted
    assign jc_upndn_in = pc_upndn_out;
    assign jc_aload_in = aload_in;

    // outputs
    assign jc_upndn_out = jc_reg_upndn;
    assign jc_upndnclkena_out = jc_reg_upndnclkena;

    // Model
    initial
    begin
        jc_count = 8;
        jc_reg_upndnclkena = 1'b0;
		jc_reg_upndn = 1'b0;
    end

    always @(posedge jc_clk8_in or posedge jc_aload_in)
    begin
        if (jc_aload_in === 1'b1)
            jc_count <= 8;
        else if (jc_count == 12)
        begin
            jc_reg_upndn <= 1'b1;
			jc_reg_upndnclkena <= 1'b1;
			jc_count <= 8;
        end
		else if (jc_count == 4)
        begin
            jc_reg_upndn <= 1'b0;
			jc_reg_upndnclkena <= 1'b1;
			jc_count <= 8;
        end
        else  // increment/decrement counter
        begin
		    jc_reg_upndnclkena <= 1'b0;

            if (jc_upndn_in === 1'b1)
                jc_count <= jc_count + 1;
			else if (jc_upndn_in === 1'b0)
                jc_count <= jc_count - 1;
        end
    end
           
// Phase comparator -----------------------------------------------------------
              
	// inputs
	assign pc_clk1_in = cg_clk1_out;
	assign pc_clk8_in = cg_clk8b_out;        // positive edge
    assign pc_dllcount_in = dc_dllcount_out; // for phase loop calculation
    assign pc_aload_in = aload_in;
           
	// outputs
	assign pc_upndn_out = pc_reg_upndn;
           
    // parameter used
	// sim_loop_intrinsic_delay, sim_loop_delay_increment
           
    // Model
    initial
    begin
        pc_reg_upndn = 1'b1;
        pc_delay = 0;
    end
              
    always @(posedge pc_clk8_in or posedge pc_aload_in)
    begin
        if (pc_aload_in === 1'b1)
            pc_reg_upndn <= 1'b1;
        else
            pc_delay = sim_loop_intrinsic_delay + sim_loop_delay_increment * pc_dllcount_in;
            if (pc_delay > input_period)
                pc_reg_upndn <= 1'b0;
            else
            pc_reg_upndn <= 1'b1;
    end
                
// Clock Generator -----------------------------------------------------------
      
	// inputs
    assign cg_clk_in = clk_in;
    assign cg_aload_in = aload_in;
       	
	// outputs
    assign cg_clk8a_out = cg_rega_3;
    assign cg_clk8b_out = cg_regb_3;        
    assign cg_clk1_out = (cg_aload_in === 1'b1) ? 1'b0 : cg_clk_in;
     
	// Model
          
	// por
    initial
    begin
        cg_reg_1 = 1'b0;
          
        cg_rega_2 = 1'b0;
        cg_rega_3 = 1'b0;
        
        cg_regb_2 = 1'b1;
        cg_regb_3 = 1'b0;
    end

     
    always @(posedge cg_clk1_out or posedge cg_aload_in)
    begin
        if (cg_aload_in === 1'b1)
            cg_reg_1 <= 1'b0;
        else
            cg_reg_1 <= ~cg_reg_1;  
    end  
             
    always @(posedge cg_reg_1 or posedge cg_aload_in)
    begin
        if (cg_aload_in === 1'b1)
        begin
            cg_rega_2 <= 1'b0;
            cg_regb_2 <= 1'b1;
		end
        else
        begin
            cg_rega_2 <= ~cg_rega_2;
            cg_regb_2 <= ~cg_regb_2;
        end
    end  
            
    always @(posedge cg_rega_2 or posedge cg_aload_in)
    begin
        if (cg_aload_in === 1'b1)
            cg_rega_3 <= 1'b0;
        else
            cg_rega_3 <= ~cg_rega_3;  
    end  
            
    always @(posedge cg_regb_2 or posedge cg_aload_in)
    begin
        if (cg_aload_in === 1'b1)
            cg_regb_3 <= 1'b0;
        else if ($time != 0)
            cg_regb_3 <= ~cg_regb_3;  
    end  
               
endmodule

//------------------------------------------------------------------
//
// Module Name : ena_reg
//
// Description : Simulation model for a simple DFF.
//               This is used for the gated clock generation.
//               Powers upto 1.
//
//------------------------------------------------------------------

`timescale 1ps / 1ps

module ena_reg (
                clk,
                ena,
                d,
                clrn,
                prn,
                q
               );

// INPUT PORTS
input d;
input clk;
input clrn;
input prn;
input ena;

// OUTPUT PORTS
output q;

// INTERNAL VARIABLES
reg q_tmp;
reg violation;
reg d_viol;

wire reset;

// DEFAULT VALUES THRO' PULLUPs
tri1 prn, clrn, ena;

buf (d_in, d);
buf (clk_in, clk);

assign reset = (!clrn) && (ena);

specify

    $setuphold (posedge clk &&& reset, d, 0, 0, d_viol) ;
      
    (posedge clk => (q +: q_tmp)) = 0 ;
      
endspecify

initial
begin
    q_tmp = 'b1;
    violation = 'b0;
end

    always @ (posedge clk_in or negedge clrn or negedge prn )
    begin
        if (d_viol == 1'b1)
        begin
            violation = 1'b0;
            q_tmp <= 'bX;
        end
        else
        if (prn == 1'b0)
            q_tmp <= 1;
        else if (clrn == 1'b0)
            q_tmp <= 0;
        else if ((clk_in == 1'b1) & (ena == 1'b1))
            q_tmp <= d_in;

    end

and (q, q_tmp, 'b1);

endmodule // ena_reg

//------------------------------------------------------------------
//
// Module Name : stratixii_clkctrl
//
// Description : StratixII CLKCTRL Verilog simulation model 
//
//------------------------------------------------------------------

`timescale 1 ps/1 ps
  
module stratixii_clkctrl (
                        inclk, 
                        clkselect, 
                        ena, 
                        devpor, 
                        devclrn, 
                        outclk
                        );
   
input [3:0] inclk;
input [1:0] clkselect;
input ena; 
input devpor; 
input devclrn; 

output outclk;
   
parameter clock_type = "auto";
parameter lpm_type = "stratixii_clkctrl";

wire clkmux_out; // output of CLK mux
wire cereg_out; // output of ENA register 
   
buf (inclk3_ipd, inclk[3]);
buf (inclk2_ipd, inclk[2]);
buf (inclk1_ipd, inclk[1]);
buf (inclk0_ipd, inclk[0]);
buf (clkselect1_ipd, clkselect[1]);
buf (clkselect0_ipd, clkselect[0]);
buf (ena_ipd, ena);
   
stratixii_mux41 clk_mux (.MO(clkmux_out),
               .IN0(inclk0_ipd),
               .IN1(inclk1_ipd),
               .IN2(inclk2_ipd),
               .IN3(inclk3_ipd),
               .S({clkselect1_ipd, clkselect0_ipd}));

ena_reg extena0_reg(
                    .clk(!clkmux_out),
                    .ena(1'b1),
                    .d(ena_ipd),
                    .clrn(1'b1),
                    .prn(devpor),
                    .q(cereg_out)
                   );
   
and (outclk, cereg_out, clkmux_out);
   
endmodule

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : lvds_tx_reg
//
// Description : Simulation model for a simple DFF.
//               This is used for registering the enable inputs.
//               No timing, powers upto 0.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ps / 1ps
module lvds_tx_reg (q,
                clk,
                ena,
                d,
                clrn,
                prn
               );

    // INPUT PORTS
    input d;
    input clk;
    input clrn;
    input prn;
    input ena;

    // OUTPUT PORTS
    output q;

    // BUFFER INPUTS
    buf (clk_in, clk);
    buf (ena_in, ena);
    buf (d_in, d);

    // INTERNAL VARIABLES
    reg q_tmp;
    wire q_wire;

    // TIMING PATHS
    specify
       $setuphold(posedge clk, d, 0, 0);
       (posedge clk => (q +: q_tmp)) = (0, 0);
       (negedge clrn => (q +: q_tmp)) = (0, 0);
       (negedge prn => (q +: q_tmp)) = (0, 0);
    endspecify

    // DEFAULT VALUES THRO' PULLUPs
    tri1 prn, clrn, ena;

    initial q_tmp = 0;

    always @ (posedge clk_in or negedge clrn or negedge prn )
    begin
        if (prn == 1'b0)
            q_tmp <= 1;
        else if (clrn == 1'b0)
            q_tmp <= 0;
        else if ((clk_in == 1) & (ena_in == 1'b1))
            q_tmp <= d_in;
    end

    assign q_wire = q_tmp;

    and (q, q_wire, 1'b1);

endmodule // lvds_tx_reg

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixii_lvds_tx_parallel_register
//
// Description : Register for the 10 data input channels of the StratixII 
//               LVDS Tx
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixii_lvds_tx_parallel_register (clk,
                                            enable,
                                            datain,
                                            dataout,
                                            devclrn,
                                            devpor
                                           );

    parameter channel_width = 4;

    // INPUT PORTS
    input [9:0] datain;
    input clk;
    input enable;
    input devclrn;
    input devpor;

    // OUTPUT PORTS
    output [9:0] dataout;

    // INTERNAL VARIABLES AND NETS
    reg clk_last_value;
    reg [9:0] dataout_tmp;
    wire [9:0] dataout_wire;

    // BUFFER INPUTS
    buf (clk_in, clk);
    buf (enable_in, enable);
    buf (datain_in0, datain[0]);
    buf (datain_in1, datain[1]);
    buf (datain_in2, datain[2]);
    buf (datain_in3, datain[3]);
    buf (datain_in4, datain[4]);
    buf (datain_in5, datain[5]);
    buf (datain_in6, datain[6]);
    buf (datain_in7, datain[7]);
    buf (datain_in8, datain[8]);
    buf (datain_in9, datain[9]);

    // TIMING PATHS
    specify
        (posedge clk => (dataout[0] +: dataout_tmp[0])) = (0, 0);
        (posedge clk => (dataout[1] +: dataout_tmp[1])) = (0, 0);
        (posedge clk => (dataout[2] +: dataout_tmp[2])) = (0, 0);
        (posedge clk => (dataout[3] +: dataout_tmp[3])) = (0, 0);
        (posedge clk => (dataout[4] +: dataout_tmp[4])) = (0, 0);
        (posedge clk => (dataout[5] +: dataout_tmp[5])) = (0, 0);
        (posedge clk => (dataout[6] +: dataout_tmp[6])) = (0, 0);
        (posedge clk => (dataout[7] +: dataout_tmp[7])) = (0, 0);
        (posedge clk => (dataout[8] +: dataout_tmp[8])) = (0, 0);
        (posedge clk => (dataout[9] +: dataout_tmp[9])) = (0, 0);

        $setuphold(posedge clk, datain[0], 0, 0);
        $setuphold(posedge clk, datain[1], 0, 0);
        $setuphold(posedge clk, datain[2], 0, 0);
        $setuphold(posedge clk, datain[3], 0, 0);
        $setuphold(posedge clk, datain[4], 0, 0);
        $setuphold(posedge clk, datain[5], 0, 0);
        $setuphold(posedge clk, datain[6], 0, 0);
        $setuphold(posedge clk, datain[7], 0, 0);
        $setuphold(posedge clk, datain[8], 0, 0);
        $setuphold(posedge clk, datain[9], 0, 0);

    endspecify

    initial
    begin
        clk_last_value = 0;
        dataout_tmp = 10'b0;
    end

    always @(clk_in or enable_in or devpor or devclrn)
    begin
        if ((devpor === 1'b0) || (devclrn === 1'b0))
        begin
            dataout_tmp <= 10'b0;
        end
        else begin
            if ((clk_in === 1'b1) && (clk_last_value !== clk_in))
            begin
                if (enable_in === 1'b1)
                begin
                    dataout_tmp[0] <= datain_in0;
                    dataout_tmp[1] <= datain_in1;
                    dataout_tmp[2] <= datain_in2;
                    dataout_tmp[3] <= datain_in3;
                    dataout_tmp[4] <= datain_in4;
                    dataout_tmp[5] <= datain_in5;
                    dataout_tmp[6] <= datain_in6;
                    dataout_tmp[7] <= datain_in7;
                    dataout_tmp[8] <= datain_in8;
                    dataout_tmp[9] <= datain_in9;
                end
            end
        end

        clk_last_value <= clk_in;

    end // always

    assign dataout_wire = dataout_tmp;
      
    and (dataout[0], dataout_wire[0], 1'b1);
    and (dataout[1], dataout_wire[1], 1'b1);
    and (dataout[2], dataout_wire[2], 1'b1);
    and (dataout[3], dataout_wire[3], 1'b1);
    and (dataout[4], dataout_wire[4], 1'b1);
    and (dataout[5], dataout_wire[5], 1'b1);
    and (dataout[6], dataout_wire[6], 1'b1);
    and (dataout[7], dataout_wire[7], 1'b1);
    and (dataout[8], dataout_wire[8], 1'b1);
    and (dataout[9], dataout_wire[9], 1'b1);

endmodule //stratixii_lvds_tx_parallel_register

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixii_lvds_tx_out_block
//
// Description : Negative edge triggered register on the Tx output. 
//               Also, optionally generates an identical/inverted output clock
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixii_lvds_tx_out_block (clk,
                                    datain,
                                    dataout,
                                    devclrn,
                                    devpor
                                   );

    parameter bypass_serializer = "false";
    parameter invert_clock = "false";
    parameter use_falling_clock_edge = "false";

    // INPUT PORTS
    input datain;
    input clk;
    input devclrn;
    input devpor;

    // OUTPUT PORTS
    output dataout;

    // INTERNAL VARIABLES AND NETS
    reg dataout_tmp;
    reg clk_last_value;

    wire bypass_mode;
    wire invert_mode;
    wire falling_clk_out;

    // BUFFER INPUTS
    buf (clk_in, clk);
    buf (datain_in, datain);

    // TEST PARAMETER VALUES
    assign falling_clk_out = (use_falling_clock_edge == "true")?1'b1:1'b0;
    assign bypass_mode = (bypass_serializer == "true")?1'b1:1'b0;
    assign invert_mode = (invert_clock == "true")?1'b1:1'b0;

    // TIMING PATHS
    specify
        if (bypass_mode == 1'b1)
            (clk => dataout) = (0, 0);

        if (bypass_mode == 1'b0 && falling_clk_out == 1'b1)
            (negedge clk => (dataout +: dataout_tmp)) = (0, 0);
    endspecify

    initial
    begin
        clk_last_value = 0;
        dataout_tmp = 0;
    end

    always @(clk_in or datain_in or devclrn or devpor)
    begin
        if ((devpor === 1'b0) || (devclrn === 1'b0))
        begin
            dataout_tmp <= 0;
        end
        else begin
            if (bypass_serializer == "false")
            begin
                if (use_falling_clock_edge == "false")
                    dataout_tmp <= datain_in;

                if ((clk_in === 1'b0) && (clk_last_value !== clk_in))
                begin
                    if (use_falling_clock_edge == "true")
                        dataout_tmp <= datain_in;
                end
            end // bypass is off
            else begin
                // generate clk_out 
                if (invert_clock == "false")
                    dataout_tmp <= clk_in;
                else
                    dataout_tmp <= !clk_in;
            end // clk output
        end

        clk_last_value <= clk_in;
    end // always

    and (dataout, dataout_tmp, 1'b1);

endmodule //stratixii_lvds_tx_out_block

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixii_lvds_transmitter
//
// Description : Timing simulation model for the StratixII LVDS Tx WYSIWYG.
//               It instantiates the following sub-modules :
//               1) primitive DFFE
//               2) StratixII_lvds_tx_parallel_register and
//               3) StratixII_lvds_tx_out_block
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixii_lvds_transmitter (clk0,
                                   enable0,
                                   datain,
                                   serialdatain,
                                   postdpaserialdatain,
                                   dataout,
                                   serialfdbkout,
                                   devclrn,
                                   devpor
                                  );

    parameter channel_width                  = 10;
    parameter bypass_serializer              = "false";
    parameter invert_clock                   = "false";
    parameter use_falling_clock_edge         = "false";
    parameter use_serial_data_input          = "false";
    parameter use_post_dpa_serial_data_input = "false";
    parameter preemphasis_setting            = 0;
    parameter vod_setting                    = 0;
    parameter differential_drive             = 0;
    parameter lpm_type                       = "stratixii_lvds_transmitter";

    // INPUT PORTS
    input [9:0] datain;
    input clk0;
    input enable0;
    input serialdatain;
    input postdpaserialdatain;
    input devclrn;
    input devpor;

    // OUTPUT PORTS
    output dataout;
    output serialfdbkout;

    // INTERNAL VARIABLES AND NETS
    integer i;
    wire dataout_tmp;
    wire dataout_wire;
    wire shift_out;
    reg clk0_last_value;
    wire [9:0] input_data;
    reg [9:0] shift_data;
    wire txload0;

    reg [9:0] datain_dly;

    wire bypass_mode;

    wire [9:0] datain_in;
    wire serial_din_mode;
    wire postdpa_serial_din_mode;

    // BUFFER INPUTS
    buf (clk0_in, clk0);
    buf datain_arr[9:0] (datain_in, datain);
    buf (serialdatain_in, serialdatain);
    buf (postdpaserialdatain_in, postdpaserialdatain);

    // TEST PARAMETER VALUES
    assign serial_din_mode = (use_serial_data_input == "true") ? 1'b1 : 1'b0;
    assign postdpa_serial_din_mode = (use_post_dpa_serial_data_input == "true") ? 1'b1 : 1'b0;

    // TIMING PATHS
    specify
        if (serial_din_mode == 1'b1)
            (serialdatain => dataout) = (0, 0);

        if (postdpa_serial_din_mode == 1'b1)
            (postdpaserialdatain => dataout) = (0, 0);
    endspecify

    initial
    begin
        i = 0;
        clk0_last_value = 0;
        for (i = 0; i < channel_width; i = i + 1)
        begin
            shift_data[i] = 0;
        end
    end

    lvds_tx_reg txload0_reg (.d(enable0),
                             .clrn(1'b1),
                             .prn(1'b1),
                             .ena(1'b1),
                             .clk(clk0_in),
                             .q(txload0)
                            );

    stratixii_lvds_tx_out_block output_module (.clk(clk0_in),
                                               .datain(shift_out),
                                               .dataout(dataout_tmp),
                                               .devclrn(devclrn),
                                               .devpor(devpor)
                                              );
    defparam output_module.bypass_serializer      = bypass_serializer;
    defparam output_module.invert_clock           = invert_clock;
    defparam output_module.use_falling_clock_edge = use_falling_clock_edge;

    stratixii_lvds_tx_parallel_register input_reg (.clk(clk0_in),
                                                   .enable(1'b1),
                                                   .datain(datain_dly),
                                                   .dataout(input_data),
                                                   .devclrn(devclrn),
                                                   .devpor(devpor)
                                                  );
    defparam input_reg.channel_width = channel_width;

    always @(datain_in)
    begin
        datain_dly <= #1 datain_in;
    end

    assign shift_out = shift_data[channel_width - 1];

    always @(clk0_in or devclrn or devpor)
    begin
        if ((devpor === 1'b0) || (devclrn === 1'b0))
        begin
            for (i = 0; i < channel_width; i = i + 1)
            begin
                shift_data[i] <= 0;
            end
        end
        else begin
            if (bypass_serializer == "false")
            begin
                if ((clk0_in === 1'b1) && (clk0_last_value !== clk0_in))
                begin
                    if (txload0 === 1'b1)
                    begin
                        for (i = 0; i < channel_width; i = i + 1)
                            shift_data[i] <= input_data[i];
                    end
                    else begin
                        for (i = (channel_width - 1); i > 0; i = i - 1 )
                             shift_data[i] <= shift_data[i-1];
                    end

                end
            end // bypass is off
        end // devpor

        clk0_last_value <= clk0_in;
    end // always

    assign dataout_wire = (use_serial_data_input == "on") ? serialdatain_in : (use_post_dpa_serial_data_input == "on") ? postdpaserialdatain_in : dataout_tmp;

    and (dataout, dataout_wire, 1'b1);
    and (serialfdbkout, dataout_wire, 1'b1);

endmodule // stratixii_lvds_transmitter
///////////////////////////////////////////////////////////////////////////////
//
// Module Name : m_cntr
//
// Description : Timing simulation model for the M counter. This is the
//               loop feedback counter for the StratixII PLL.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module m_cntr (clk,
               reset,
               cout,
               initial_value,
               modulus,
               time_delay
              );

    // INPUT PORTS
    input clk;
    input reset;
    input [31:0] initial_value;
    input [31:0] modulus;
    input [31:0] time_delay;

    // OUTPUT PORTS
    output cout;

    // INTERNAL VARIABLES AND NETS
    integer count;
    reg tmp_cout;
    reg first_rising_edge;
    reg clk_last_value;
    reg cout_tmp;

    initial
    begin
        count = 1;
        first_rising_edge = 1;
        clk_last_value = 0;
    end

    always @(reset or clk)
    begin
        if (reset)
        begin
            count = 1;
            tmp_cout = 0;
            first_rising_edge = 1;
            cout_tmp <= tmp_cout;
        end
        else begin
            if (clk == 1 && clk_last_value !== clk && first_rising_edge)
            begin
                first_rising_edge = 0;
                tmp_cout = clk;
                cout_tmp <= #(time_delay) tmp_cout;
            end
            else if (first_rising_edge == 0)
            begin
                if (count < modulus)
                   count = count + 1;
                else
                begin
                   count = 1;
                   tmp_cout = ~tmp_cout;
                   cout_tmp <= #(time_delay) tmp_cout;
                end
            end
        end
        clk_last_value = clk;

//        cout_tmp <= #(time_delay) tmp_cout;
    end

    and (cout, cout_tmp, 1'b1);

endmodule // m_cntr

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : n_cntr
//
// Description : Timing simulation model for the N counter. This is the
//               input clock divide counter for the StratixII PLL.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module n_cntr (clk,
               reset,
               cout,
               modulus
              );

    // INPUT PORTS
    input clk;
    input reset;
    input [31:0] modulus;

    // OUTPUT PORTS
    output cout;

    // INTERNAL VARIABLES AND NETS
    integer count;
    reg tmp_cout;
    reg first_rising_edge;
    reg clk_last_value;
    reg cout_tmp;

    initial
    begin
        count = 1;
        first_rising_edge = 1;
        clk_last_value = 0;
    end

    always @(reset or clk)
    begin
        if (reset)
        begin
            count = 1;
            tmp_cout = 0;
            first_rising_edge = 1;
        end
        else begin
            if (clk == 1 && clk_last_value !== clk && first_rising_edge)
            begin
                first_rising_edge = 0;
                tmp_cout = clk;
            end
            else if (first_rising_edge == 0)
            begin
                if (count < modulus)
                    count = count + 1;
                else
                begin
                    count = 1;
                    tmp_cout = ~tmp_cout;
                end
            end
        end
        clk_last_value = clk;

    end

    assign cout = tmp_cout;

endmodule // n_cntr

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : scale_cntr
//
// Description : Timing simulation model for the output scale-down counters.
//               This is a common model for the C0, C1, C2, C3, C4 and
//               C5 output counters of the StratixII PLL.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module scale_cntr(clk,
                  reset,
                  cout,
                  high,
                  low,
                  initial_value,
                  mode,
                  ph_tap
                 );

    // INPUT PORTS
    input clk;
    input reset;
    input [31:0] high;
    input [31:0] low;
    input [31:0] initial_value;
    input [8*6:1] mode;
    input [31:0] ph_tap;

    // OUTPUT PORTS
    output cout;

    // INTERNAL VARIABLES AND NETS
    reg tmp_cout;
    reg first_rising_edge;
    reg clk_last_value;
    reg init;
    integer count;
    integer output_shift_count;
    reg cout_tmp;

    initial
    begin
        count = 1;
        first_rising_edge = 0;
        tmp_cout = 0;
        output_shift_count = 1;
    end

    always @(clk or reset)
    begin
        if (init !== 1'b1)
        begin
            clk_last_value = 0;
            init = 1'b1;
        end
        if (reset)
        begin
            count = 1;
            output_shift_count = 1;
            tmp_cout = 0;
            first_rising_edge = 0;
        end
        else if (clk_last_value !== clk)
        begin
            if (mode == "   off")
                tmp_cout = 0;
            else if (mode == "bypass")
            begin
                tmp_cout = clk;
                first_rising_edge = 1;
            end
            else if (first_rising_edge == 0)
            begin
                if (clk == 1)
                begin
                    if (output_shift_count == initial_value)
                    begin
                       tmp_cout = clk;
                       first_rising_edge = 1;
                    end
                    else
                       output_shift_count = output_shift_count + 1;
                end
            end
            else if (output_shift_count < initial_value)
            begin
                if (clk == 1)
                    output_shift_count = output_shift_count + 1;
            end
            else
            begin
                count = count + 1;
                if (mode == "  even" && (count == (high*2) + 1))
                    tmp_cout = 0;
                else if (mode == "   odd" && (count == (high*2)))
                    tmp_cout = 0;
                else if (count == (high + low)*2 + 1)
                begin
                    tmp_cout = 1;
                    count = 1;        // reset count
                end
            end
        end
        clk_last_value = clk;
        cout_tmp <= tmp_cout;
    end

    and (cout, cout_tmp, 1'b1);

endmodule // scale_cntr

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : pll_reg
//
// Description : Simulation model for a simple DFF.
//               This is required for the generation of the bit slip-signals.
//               No timing, powers upto 0.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ps / 1ps
module pll_reg (q,
                clk,
                ena,
                d,
                clrn,
                prn
               );

    // INPUT PORTS
    input d;
    input clk;
    input clrn;
    input prn;
    input ena;

    // OUTPUT PORTS
    output q;

    // INTERNAL VARIABLES
    reg q;

    // DEFAULT VALUES THRO' PULLUPs
    tri1 prn, clrn, ena;

    initial q = 0;

    always @ (posedge clk or negedge clrn or negedge prn )
    begin
        if (prn == 1'b0)
            q <= 1;
        else if (clrn == 1'b0)
            q <= 0;
        else if ((clk == 1) & (ena == 1'b1))
            q <= d;
    end

endmodule // pll_reg

//////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixii_pll
//
// Description : Timing simulation model for the StratixII PLL.
//               In the functional mode, it is also the model for the altpll
//               megafunction.
// 
// Limitations : Does not support Spread Spectrum and Bandwidth.
//
// Outputs     : Up to 6 output clocks, each defined by its own set of
//               parameters. Locked output (active high) indicates when the
//               PLL locks. clkbad, clkloss and activeclock are used for
//               clock switchover to inidicate which input clock has gone
//               bad, when the clock switchover initiates and which input
//               clock is being used as the reference, respectively.
//               scandataout is the data output of the serial scan chain.
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
`define WORD_LENGTH 18

module stratixii_pll (inclk,
                    fbin,
                    ena,
                    clkswitch,
                    areset,
                    pfdena,
                    scanclk,
                    scanread,
                    scanwrite,
                    scandata,
                    testin,
                    clk,
                    clkbad,
                    activeclock,
                    locked,
                    clkloss,
                    scandataout,
                    scandone,
                    enable0,
                    enable1,
                    testupout,
                    testdownout,
                    sclkout
                   );

    parameter operation_mode                       = "normal";
    parameter pll_type                             = "auto";
    parameter compensate_clock                     = "clk0";
    parameter feedback_source                      = "clk0";
    parameter qualify_conf_done                    = "off";

    parameter test_input_comp_delay_chain_bits     = 0;
    parameter test_feedback_comp_delay_chain_bits  = 0;

    parameter inclk0_input_frequency               = 10000;
    parameter inclk1_input_frequency               = 10000;

    parameter gate_lock_signal                     = "no";
    parameter gate_lock_counter                    = 1;
    parameter valid_lock_multiplier                = 1;
    parameter invalid_lock_multiplier              = 5;

    parameter switch_over_type                     = "auto";
    parameter switch_over_on_lossclk               = "off";
    parameter switch_over_on_gated_lock            = "off";
    parameter switch_over_counter                  = 1;
    parameter enable_switch_over_counter           = "on";

    parameter bandwidth                            = 0;
    parameter bandwidth_type                       = "auto";
    parameter down_spread                          = "0.0";
    parameter spread_frequency                     = 0;
    parameter common_rx_tx                         = "off";
    parameter rx_outclock_resource                 = "auto";
    parameter use_dc_coupling                      = "false";

    parameter clk0_output_frequency                = 0;
    parameter clk0_multiply_by                     = 1;
    parameter clk0_divide_by                       = 1;
    parameter clk0_phase_shift                     = "0";
    parameter clk0_duty_cycle                      = 50;

    parameter clk1_output_frequency                = 0;
    parameter clk1_multiply_by                     = 1;
    parameter clk1_divide_by                       = 1;
    parameter clk1_phase_shift                     = "0";
    parameter clk1_duty_cycle                      = 50;

    parameter clk2_output_frequency                = 0;
    parameter clk2_multiply_by                     = 1;
    parameter clk2_divide_by                       = 1;
    parameter clk2_phase_shift                     = "0";
    parameter clk2_duty_cycle                      = 50;

    parameter clk3_output_frequency                = 0;
    parameter clk3_multiply_by                     = 1;
    parameter clk3_divide_by                       = 1;
    parameter clk3_phase_shift                     = "0";
    parameter clk3_duty_cycle                      = 50;

    parameter clk4_output_frequency                = 0;
    parameter clk4_multiply_by                     = 1;
    parameter clk4_divide_by                       = 1;
    parameter clk4_phase_shift                     = "0";
    parameter clk4_duty_cycle                      = 50;

    parameter clk5_output_frequency                = 0;
    parameter clk5_multiply_by                     = 1;
    parameter clk5_divide_by                       = 1;
    parameter clk5_phase_shift                     = "0";
    parameter clk5_duty_cycle                      = 50;

    parameter pfd_min                              = 0;
    parameter pfd_max                              = 0;
    parameter vco_min                              = 0;
    parameter vco_max                              = 0;
    parameter vco_center                           = 0;

    // ADVANCED USE PARAMETERS
    parameter m_initial = 1;
    parameter m = 1;
    parameter n = 1;
    parameter m2 = 1;
    parameter n2 = 1;
    parameter ss = 0;

    parameter c0_high = 1;
    parameter c0_low = 1;
    parameter c0_initial = 1;
    parameter c0_mode = "bypass";
    parameter c0_ph = 0;

    parameter c1_high = 1;
    parameter c1_low = 1;
    parameter c1_initial = 1;
    parameter c1_mode = "bypass";
    parameter c1_ph = 0;

    parameter c2_high = 1;
    parameter c2_low = 1;
    parameter c2_initial = 1;
    parameter c2_mode = "bypass";
    parameter c2_ph = 0;

    parameter c3_high = 1;
    parameter c3_low = 1;
    parameter c3_initial = 1;
    parameter c3_mode = "bypass";
    parameter c3_ph = 0;

    parameter c4_high = 1;
    parameter c4_low = 1;
    parameter c4_initial = 1;
    parameter c4_mode = "bypass";
    parameter c4_ph = 0;

    parameter c5_high = 1;
    parameter c5_low = 1;
    parameter c5_initial = 1;
    parameter c5_mode = "bypass";
    parameter c5_ph = 0;

    parameter m_ph = 0;

    parameter clk0_counter = "c0";
    parameter clk1_counter = "c1";
    parameter clk2_counter = "c2";
    parameter clk3_counter = "c3";
    parameter clk4_counter = "c4";
    parameter clk5_counter = "c5";

    parameter c1_use_casc_in = "off";
    parameter c2_use_casc_in = "off";
    parameter c3_use_casc_in = "off";
    parameter c4_use_casc_in = "off";
    parameter c5_use_casc_in = "off";

    parameter m_test_source = 5;
    parameter c0_test_source = 5;
    parameter c1_test_source = 5;
    parameter c2_test_source = 5;
    parameter c3_test_source = 5;
    parameter c4_test_source = 5;
    parameter c5_test_source = 5;

    // LVDS mode parameters
    parameter enable0_counter = "c0";
    parameter enable1_counter = "c1";
    parameter sclkout0_phase_shift = "0";
    parameter sclkout1_phase_shift = "0";

    parameter vco_multiply_by = 0;
    parameter vco_divide_by = 0;
    parameter vco_post_scale = 1;

    parameter charge_pump_current = 0;
    parameter loop_filter_r = "1.0";
    parameter loop_filter_c = 1;

    parameter pll_compensation_delay = 0;
    parameter simulation_type = "functional";
    parameter lpm_type = "stratixii_pll";

    //parameter for stratixii lvds
    parameter clk0_phase_shift_num = 0;
    parameter clk1_phase_shift_num = 0;
    parameter clk2_phase_shift_num = 0;

    // INPUT PORTS
    input [1:0] inclk;
    input fbin;
    input ena;
    input clkswitch;
    input areset;
    input pfdena;
    input scanclk;
    input scanread;
    input scanwrite;
    input scandata;
    input [3:0] testin;

    // OUTPUT PORTS
    output [5:0] clk;
    output [1:0] clkbad;
    output activeclock;
    output locked;
    output clkloss;
    output scandataout;
    output scandone;
    // lvds specific output ports
    output enable0;
    output enable1;
    output [1:0] sclkout;
    // test ports
    output testupout;
    output testdownout;

    // BUFFER INPUTS
    buf (inclk0_ipd, inclk[0]);
    buf (inclk1_ipd, inclk[1]);
    buf (ena_ipd, ena);
    buf (fbin_ipd, fbin);
    buf (clkswitch_ipd, clkswitch);
    buf (areset_ipd, areset);
    buf (pfdena_ipd, pfdena);
    buf (scanclk_ipd, scanclk);
    buf (scanread_ipd, scanread);
    buf (scanwrite_ipd, scanwrite);
    buf (scandata_ipd, scandata);

    // TIMING CHECKS
    specify
        $setuphold(posedge scanclk, scanread, 0, 0);
        $setuphold(posedge scanclk, scanwrite, 0, 0);
        $setuphold(posedge scanclk, scandata, 0, 0);
    endspecify

    // INTERNAL VARIABLES AND NETS
    integer scan_chain_length;
    integer i;
    integer j;
    integer k;
    integer l_index;
    integer gate_count;
    integer egpp_offset;
    integer sched_time;
    integer delay_chain;
    integer low;
    integer high;
    integer initial_delay;
    integer fbk_phase;
    integer fbk_delay;
    integer phase_shift[0:7];
    integer last_phase_shift[0:7];

    integer m_times_vco_period;
    integer new_m_times_vco_period;
    integer refclk_period;
    integer fbclk_period;
    integer high_time;
    integer low_time;
    integer my_rem;
    integer tmp_rem;
    integer rem;
    integer tmp_vco_per;
    integer vco_per;
    integer offset;
    integer temp_offset;
    integer cycles_to_lock;
    integer cycles_to_unlock;
    integer c0_count;
    integer c1_count;
    integer loop_xplier;
    integer loop_initial;
    integer loop_ph;
    integer cycle_to_adjust;
    integer total_pull_back;
    integer pull_back_M;

    time    fbclk_time;
    time    first_fbclk_time;
    time    refclk_time;

    reg got_first_refclk;
    reg got_second_refclk;
    reg got_first_fbclk;
    reg refclk_last_value;
    reg fbclk_last_value;
    reg inclk_last_value;
    reg pll_is_locked;
    reg pll_about_to_lock;
    reg locked_tmp;
    reg c0_got_first_rising_edge;
    reg c1_got_first_rising_edge;
    reg vco_c0_last_value;
    reg vco_c1_last_value;
    reg areset_ipd_last_value;
    reg ena_ipd_last_value;
    reg pfdena_ipd_last_value;
    reg inclk_out_of_range;
    reg schedule_vco_last_value;

    reg gate_out;
    reg vco_val;

    reg [31:0] m_initial_val;
    reg [31:0] m_val[0:1];
    reg [31:0] n_val[0:1];
    reg [31:0] m_delay;
    reg [8*6:1] m_mode_val[0:1];
    reg [8*6:1] n_mode_val[0:1];

    reg [31:0] c_high_val[0:5];
    reg [31:0] c_low_val[0:5];
    reg [8*6:1] c_mode_val[0:5];
    reg [31:0] c_initial_val[0:5];
    integer c_ph_val[0:5];

    // temporary registers for reprogramming
    integer c_ph_val_tmp[0:5];
    reg [31:0] c_high_val_tmp[0:5];
    reg [31:0] c_low_val_tmp[0:5];
    reg [8*6:1] c_mode_val_tmp[0:5];

    // hold registers for reprogramming
    integer c_ph_val_hold[0:5];
    reg [31:0] c_high_val_hold[0:5];
    reg [31:0] c_low_val_hold[0:5];
    reg [8*6:1] c_mode_val_hold[0:5];

    // old values
    reg [31:0] m_val_old[0:1];
    reg [31:0] m_val_tmp[0:1];
    reg [31:0] n_val_old[0:1];
    reg [8*6:1] m_mode_val_old[0:1];
    reg [8*6:1] n_mode_val_old[0:1];
    reg [31:0] c_high_val_old[0:5];
    reg [31:0] c_low_val_old[0:5];
    reg [8*6:1] c_mode_val_old[0:5];
    integer c_ph_val_old[0:5];
    integer   m_ph_val_old;
    integer   m_ph_val_tmp;

    integer cp_curr_old;
    integer cp_curr_val;
    integer lfc_old;
    integer lfc_val;
    reg [9*8:1] lfr_val;
    reg [9*8:1] lfr_old;

    reg [31:0] m_hi;
    reg [31:0] m_lo;

    // ph tap orig values (POF)
    integer c_ph_val_orig[0:5];
    integer m_ph_val_orig;

    reg schedule_vco;
    reg stop_vco;
    reg inclk_n;

    reg [7:0] vco_out;
    wire inclk_c0;
    wire inclk_c1;
    wire inclk_c2;
    wire inclk_c3;
    wire inclk_c4;
    wire inclk_c5;
    reg  inclk_c0_from_vco;
    reg  inclk_c1_from_vco;
    reg  inclk_c2_from_vco;
    reg  inclk_c3_from_vco;
    reg  inclk_c4_from_vco;
    reg  inclk_c5_from_vco;
    reg  inclk_m_from_vco;
    reg inclk_sclkout0_from_vco;
    reg inclk_sclkout1_from_vco;

    wire inclk_m;
    wire clk0_tmp;
    wire clk1_tmp;
    wire clk2_tmp;
    wire clk3_tmp;
    wire clk4_tmp;
    wire clk5_tmp;
    reg sclkout0_tmp;
    reg sclkout1_tmp;

    reg vco_c0;
    reg vco_c1;

    wire clk0;
    wire clk1;
    wire clk2;
    wire clk3;
    wire clk4;
    wire clk5;
    wire sclkout0;
    wire sclkout1;

    reg first_schedule;

    wire enable0_tmp;
    wire enable1_tmp;
    wire enable_0;
    wire enable_1;
    reg c0_tmp;
    reg c1_tmp;

    reg vco_period_was_phase_adjusted;
    reg phase_adjust_was_scheduled;

    // for external feedback mode

    reg [31:0] ext_fbk_cntr_high;
    reg [31:0] ext_fbk_cntr_low;
    reg [31:0] ext_fbk_cntr_modulus;
    reg [8*2:1] ext_fbk_cntr;
    reg [8*6:1] ext_fbk_cntr_mode;
    integer ext_fbk_cntr_ph;
    integer ext_fbk_cntr_initial;
    integer ext_fbk_cntr_index;

    // variables for clk_switch
    reg clk0_is_bad;
    reg clk1_is_bad;
    reg inclk0_last_value;
    reg inclk1_last_value;
    reg other_clock_value;
    reg other_clock_last_value;
    reg primary_clk_is_bad;
    reg current_clk_is_bad;
    reg external_switch;
    reg [8*6:1] current_clock;
    reg active_clock;
    reg clkloss_tmp;
    reg got_curr_clk_falling_edge_after_clkswitch;

    integer clk0_count;
    integer clk1_count;
    integer switch_over_count;

    wire scandataout_tmp;
    reg scandone_tmp;
    reg scandone_tmp_last_value;
    integer quiet_time;
    reg reconfig_err;
    reg error;
    time    scanclk_last_rising_edge;
    time    scanread_active_edge;
    reg got_first_scanclk;
    reg got_first_gated_scanclk;
    reg gated_scanclk;
    integer scanclk_period;
    reg scanclk_last_value;
    reg scanread_reg;
    reg scanwrite_reg;
    reg scanwrite_enabled;
    reg scanwrite_last_value;
    reg [173:0] scan_data;
    reg [173:0] tmp_scan_data;
    reg c0_rising_edge_transfer_done;
    reg c1_rising_edge_transfer_done;
    reg c2_rising_edge_transfer_done;
    reg c3_rising_edge_transfer_done;
    reg c4_rising_edge_transfer_done;
    reg c5_rising_edge_transfer_done;
    reg scanread_setup_violation;
    integer index;
    integer scanclk_cycles;
    reg d_msg;

    integer num_output_cntrs;

    // INTERNAL PARAMETERS
    parameter GPP_SCAN_CHAIN = 174;
    parameter FAST_SCAN_CHAIN = 75;
    // primary clk is always inclk0
    parameter primary_clock = "inclk0";

    // internal variables for scaling of multiply_by and divide_by values
    integer i_clk0_mult_by;
    integer i_clk0_div_by;
    integer i_clk1_mult_by;
    integer i_clk1_div_by;
    integer i_clk2_mult_by;
    integer i_clk2_div_by;
    integer i_clk3_mult_by;
    integer i_clk3_div_by;
    integer i_clk4_mult_by;
    integer i_clk4_div_by;
    integer i_clk5_mult_by;
    integer i_clk5_div_by;
    integer clk0_gcd;
    integer clk1_gcd;
    integer clk2_gcd;
    integer clk3_gcd;
    integer clk4_gcd;
    integer clk5_gcd;

    // user to advanced internal signals

    integer   i_m_initial;
    integer   i_m;
    integer   i_n;
    integer   i_m2;
    integer   i_n2;
    integer   i_ss;
    integer   i_c_high[0:5];
    integer   i_c_low[0:5];
    integer   i_c_initial[0:5];
    integer   i_c_ph[0:5];
    reg       [8*6:1] i_c_mode[0:5];

    integer   i_vco_min;
    integer   i_vco_max;
    integer   i_vco_center;
    integer   i_pfd_min;
    integer   i_pfd_max;
    integer   i_m_ph;
    integer   m_ph_val;
    reg [8*2:1] i_clk5_counter;
    reg [8*2:1] i_clk4_counter;
    reg [8*2:1] i_clk3_counter;
    reg [8*2:1] i_clk2_counter;
    reg [8*2:1] i_clk1_counter;
    reg [8*2:1] i_clk0_counter;
    integer   i_charge_pump_current;
    integer   i_loop_filter_r;
    integer   max_neg_abs;
    integer   output_count;
    integer   new_divisor;

    integer loop_filter_c_arr[0:3];
    integer fpll_loop_filter_c_arr[0:3];
    integer charge_pump_curr_arr[0:15];
    reg [9*8:1] loop_filter_r_arr[0:39];

    // uppercase to lowercase parameter values
    reg [8*`WORD_LENGTH:1] l_operation_mode;
    reg [8*`WORD_LENGTH:1] l_pll_type;
    reg [8*`WORD_LENGTH:1] l_qualify_conf_done;
    reg [8*`WORD_LENGTH:1] l_compensate_clock;
    reg [8*`WORD_LENGTH:1] l_scan_chain;
    reg [8*`WORD_LENGTH:1] l_primary_clock;
    reg [8*`WORD_LENGTH:1] l_gate_lock_signal;
    reg [8*`WORD_LENGTH:1] l_switch_over_on_lossclk;
    reg [8*`WORD_LENGTH:1] l_switch_over_type;
    reg [8*`WORD_LENGTH:1] l_switch_over_on_gated_lock;
    reg [8*`WORD_LENGTH:1] l_enable_switch_over_counter;
    reg [8*`WORD_LENGTH:1] l_feedback_source;
    reg [8*`WORD_LENGTH:1] l_bandwidth_type;
    reg [8*`WORD_LENGTH:1] l_simulation_type;
    reg [8*`WORD_LENGTH:1] l_enable0_counter;
    reg [8*`WORD_LENGTH:1] l_enable1_counter;

    reg init;

    specify
    endspecify

    function integer abs;
    input value;
    integer value;
    begin
       if (value < 0)
          abs = value * -1;
       else abs = value;
    end
    endfunction

    // find twice the period of the slowest clock
    function integer slowest_clk;
    input C0, C0_mode, C1, C1_mode, C2, C2_mode, C3, C3_mode, C4, C4_mode, C5, C5_mode, refclk, m_mod;
    integer C0, C1, C2, C3, C4, C5;
    reg [8*6:1] C0_mode, C1_mode, C2_mode, C3_mode, C4_mode, C5_mode;
    integer refclk;
    reg [31:0] m_mod;
    integer max_modulus;
    begin
       max_modulus = 1;
       if (C0_mode != "bypass" && C0_mode != "   off")
           max_modulus = C0;
       if (C1 > max_modulus && C1_mode != "bypass" && C1_mode != "   off")
           max_modulus = C1;
       if (C2 > max_modulus && C2_mode != "bypass" && C2_mode != "   off")
           max_modulus = C2;
       if (C3 > max_modulus && C3_mode != "bypass" && C3_mode != "   off")
           max_modulus = C3;
       if (C4 > max_modulus && C4_mode != "bypass" && C4_mode != "   off")
           max_modulus = C4;
       if (C5 > max_modulus && C5_mode != "bypass" && C5_mode != "   off")
           max_modulus = C5;

       slowest_clk = (refclk * max_modulus *2 / m_mod);
    end
    endfunction

    // count the number of digits in the given integer
    function integer count_digit;
    input X;
    integer X;
    integer count, result;
    begin
        count = 0;
        result = X;
        while (result != 0)
        begin
            result = (result / 10);
            count = count + 1;
        end
        
        count_digit = count;
    end
    endfunction

    // reduce the given huge number(X) to Y significant digits
    function integer scale_num;
    input X, Y;
    integer X, Y;
    integer count;
    integer fac_ten, lc;
    begin
        fac_ten = 1;
        count = count_digit(X);
        
        for (lc = 0; lc < (count-Y); lc = lc + 1)
            fac_ten = fac_ten * 10;

        scale_num = (X / fac_ten);
    end
    endfunction     

    // scale down the multiply_by values to a reasonable number (with 2 significant digits at most)
    function integer scale_mult;
    input mult, div;
    integer mult, div;
    integer count_m, count_d, num_bits, result;
    begin
        if ((mult > 100) && (div > 100))
        begin
            count_m = count_digit(mult);
            count_d = count_digit(div);
            
            if (count_m > count_d)
                num_bits = count_m - 2;
            else
                num_bits = count_d - 2;

            result = scale_num(mult, (count_m - num_bits));
        end
        else
            result = mult;
        
        scale_mult = result;
    end
    endfunction

    // scale down the divide_by values to a reasonable number (with 2 significant digits at most)
    function integer scale_div;
    input mult, div;
    integer mult, div;
    integer count_m, count_d, num_bits, result;
    begin
        if ((mult > 100) && (div > 100))
        begin
            count_m = count_digit(mult);
            count_d = count_digit(div);
            
            if (count_m > count_d)
                num_bits = count_m - 2;
            else
                num_bits = count_d - 2;

            result = scale_num(div, count_d - num_bits);
        end
        else
            result = div;
        
        scale_div = result;
    end
    endfunction
    
    // find the greatest common denominator of X and Y
    function integer gcd;
    input X,Y;
    integer X,Y;
    integer L, S, R, G;
    begin
        if (X < Y) // find which is smaller.
        begin
            S = X;
            L = Y;
        end
        else
        begin
            S = Y;
            L = X;
        end

        R = S;
        while ( R > 1)
        begin
            S = L;
            L = R;
            R = S % L; // divide bigger number by smaller.
                       // remainder becomes smaller number.
        end
        if (R == 0)    // if evenly divisible then L is gcd else it is 1.
            G = L;
        else
            G = R;
        gcd = G;
    end
    endfunction

    // find the least common multiple of A1 to A10
    function integer lcm;
    input A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, P;
    integer A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, P;
    integer M1, M2, M3, M4, M5 , M6, M7, M8, M9, R;
    begin
        M1 = (A1 * A2)/gcd(A1, A2);
        M2 = (M1 * A3)/gcd(M1, A3);
        M3 = (M2 * A4)/gcd(M2, A4);
        M4 = (M3 * A5)/gcd(M3, A5);
        M5 = (M4 * A6)/gcd(M4, A6);
        M6 = (M5 * A7)/gcd(M5, A7);
        M7 = (M6 * A8)/gcd(M6, A8);
        M8 = (M7 * A9)/gcd(M7, A9);
        M9 = (M8 * A10)/gcd(M8, A10);
        if (M9 < 3)
            R = 10;
        else if ((M9 < 10) && (M9 >= 3))
            R = 4 * M9;
        else if (M9 > 1000)
            R = scale_num(M9, 3);
        else
            R = M9;
        lcm = R; 
    end
    endfunction

    // find the factor of division of the output clock frequency
    // compared to the VCO
    function integer output_counter_value;
    input clk_divide, clk_mult, M, N;
    integer clk_divide, clk_mult, M, N;
    integer R;
    begin
        R = (clk_divide * M)/(clk_mult * N);
        output_counter_value = R;
    end
    endfunction

    // find the mode of each of the PLL counters - bypass, even or odd
    function [8*6:1] counter_mode;
    input duty_cycle;
    input output_counter_value;
    integer duty_cycle;
    integer output_counter_value;
    integer half_cycle_high;
    reg [8*6:1] R;
    begin
        half_cycle_high = (2*duty_cycle*output_counter_value)/100;
        if (output_counter_value == 1)
            R = "bypass";
        else if ((half_cycle_high % 2) == 0)
            R = "  even";
        else
            R = "   odd";
        counter_mode = R;
    end
    endfunction

    // find the number of VCO clock cycles to hold the output clock high
    function integer counter_high;
    input output_counter_value, duty_cycle;
    integer output_counter_value, duty_cycle;
    integer half_cycle_high;
    integer tmp_counter_high;
    integer mode;
    begin
        half_cycle_high = (2*duty_cycle*output_counter_value)/100;
        mode = ((half_cycle_high % 2) == 0);
        tmp_counter_high = half_cycle_high/2;
        counter_high = tmp_counter_high + !mode;
    end
    endfunction

    // find the number of VCO clock cycles to hold the output clock low
    function integer counter_low;
    input output_counter_value, duty_cycle;
    integer output_counter_value, duty_cycle, counter_h;
    integer half_cycle_high;
    integer mode;
    integer tmp_counter_high;
    begin
        half_cycle_high = (2*duty_cycle*output_counter_value)/100;
        mode = ((half_cycle_high % 2) == 0);
        tmp_counter_high = half_cycle_high/2;
        counter_h = tmp_counter_high + !mode;
        counter_low =  output_counter_value - counter_h;
    end
    endfunction

    // find the smallest time delay amongst t1 to t10
    function integer mintimedelay;
    input t1, t2, t3, t4, t5, t6, t7, t8, t9, t10;
    integer t1, t2, t3, t4, t5, t6, t7, t8, t9, t10;
    integer m1,m2,m3,m4,m5,m6,m7,m8,m9;
    begin
        if (t1 < t2)
            m1 = t1;
        else
            m1 = t2;
        if (m1 < t3)
            m2 = m1;
        else
            m2 = t3;
        if (m2 < t4)
            m3 = m2;
        else
            m3 = t4;
        if (m3 < t5)
            m4 = m3;
        else
            m4 = t5;
        if (m4 < t6)
            m5 = m4;
        else
            m5 = t6;
        if (m5 < t7)
            m6 = m5;
        else
            m6 = t7;
        if (m6 < t8)
            m7 = m6;
        else
            m7 = t8;
        if (m7 < t9)
            m8 = m7;
        else
            m8 = t9;
        if (m8 < t10)
            m9 = m8;
        else
            m9 = t10;
        if (m9 > 0)
            mintimedelay = m9;
        else
            mintimedelay = 0;
    end
    endfunction

    // find the numerically largest negative number, and return its absolute value
    function integer maxnegabs;
    input t1, t2, t3, t4, t5, t6, t7, t8, t9, t10;
    integer t1, t2, t3, t4, t5, t6, t7, t8, t9, t10;
    integer m1,m2,m3,m4,m5,m6,m7,m8,m9;
    begin
        if (t1 < t2) m1 = t1; else m1 = t2;
        if (m1 < t3) m2 = m1; else m2 = t3;
        if (m2 < t4) m3 = m2; else m3 = t4;
        if (m3 < t5) m4 = m3; else m4 = t5;
        if (m4 < t6) m5 = m4; else m5 = t6;
        if (m5 < t7) m6 = m5; else m6 = t7;
        if (m6 < t8) m7 = m6; else m7 = t8;
        if (m7 < t9) m8 = m7; else m8 = t9;
        if (m8 < t10) m9 = m8; else m9 = t10;
        maxnegabs = (m9 < 0) ? 0 - m9 : 0;
    end
    endfunction

    // adjust the given tap_phase by adding the largest negative number (ph_base) 
    function integer ph_adjust;
    input tap_phase, ph_base;
    integer tap_phase, ph_base;
    begin
        ph_adjust = tap_phase + ph_base;
    end
    endfunction

    // find the number of VCO clock cycles to wait initially before the first 
    // rising edge of the output clock
    function integer counter_initial;
    input tap_phase, m, n;
    integer tap_phase, m, n, phase;
    begin
        if (tap_phase < 0) tap_phase = 0 - tap_phase;
        // adding 0.5 for rounding correction (required in order to round
        // to the nearest integer instead of truncating)
        phase = ((tap_phase * m) / (360 * n)) + 0.5;
        counter_initial = phase;
    end
    endfunction

    // find which VCO phase tap to align the rising edge of the output clock to
    function integer counter_ph;
    input tap_phase;
    input m,n;
    integer m,n, phase;
    integer tap_phase;
    begin
    // adding 0.5 for rounding correction
        phase = (tap_phase * m / n) + 0.5;
        counter_ph = (phase % 360)/45;
    end
    endfunction

    // convert the given string to length 6 by padding with spaces
    function [8*6:1] translate_string;
    input [8*6:1] mode;
    reg [8*6:1] new_mode;
    begin
        if (mode == "bypass")
           new_mode = "bypass";
        else if (mode == "even")
            new_mode = "  even";
        else if (mode == "odd")
            new_mode = "   odd";

        translate_string = new_mode;
    end
    endfunction

    // convert string to integer with sign
    function integer str2int; 
    input [8*16:1] s;

    reg [8*16:1] reg_s;
    reg [8:1] digit;
    reg [8:1] tmp;
    integer m, magnitude;
    integer sign;

    begin
        sign = 1;
        magnitude = 0;
        reg_s = s;
        for (m=1; m<=16; m=m+1)
        begin
            tmp = reg_s[128:121];
            digit = tmp & 8'b00001111;
            reg_s = reg_s << 8;
            // Accumulate ascii digits 0-9 only.
            if ((tmp>=48) && (tmp<=57)) 
                magnitude = (magnitude * 10) + digit;
            if (tmp == 45)
                sign = -1;  // Found a '-' character, i.e. number is negative.
        end
        str2int = sign*magnitude;
    end
    endfunction

    // this is for stratixii lvds only
    // convert phase delay to integer
    function integer get_int_phase_shift; 
    input [8*16:1] s;
    input i_phase_shift;
    integer i_phase_shift;

    begin
        if (i_phase_shift != 0)
        begin                   
            get_int_phase_shift = i_phase_shift;
        end       
        else
        begin
            get_int_phase_shift = str2int(s);
        end        
    end
    endfunction

    // calculate the given phase shift (in ps) in terms of degrees
    function integer get_phase_degree; 
    input phase_shift;
    integer phase_shift, result;
    begin
        result = (phase_shift * 360) / inclk0_input_frequency;
        // this is to round up the calculation result
        if ( result > 0 )
            result = result + 1;
        else if ( result < 0 )
            result = result - 1;
        else
            result = 0;

        // assign the rounded up result
        get_phase_degree = result;
    end
    endfunction

    // convert uppercase parameter values to lowercase
    // assumes that the maximum character length of a parameter is 18
    function [8*`WORD_LENGTH:1] alpha_tolower;
    input [8*`WORD_LENGTH:1] given_string;

    reg [8*`WORD_LENGTH:1] return_string;
    reg [8*`WORD_LENGTH:1] reg_string;
    reg [8:1] tmp;
    reg [8:1] conv_char;
    integer byte_count;
    begin
        return_string = "                    "; // initialise strings to spaces
        conv_char = "        ";
        reg_string = given_string;
        for (byte_count = `WORD_LENGTH; byte_count >= 1; byte_count = byte_count - 1)
        begin
            tmp = reg_string[8*`WORD_LENGTH:(8*(`WORD_LENGTH-1)+1)];
            reg_string = reg_string << 8;
            if ((tmp >= 65) && (tmp <= 90)) // ASCII number of 'A' is 65, 'Z' is 90
            begin
                conv_char = tmp + 32; // 32 is the difference in the position of 'A' and 'a' in the ASCII char set
                return_string = {return_string, conv_char};
            end
            else
                return_string = {return_string, tmp};
        end
    
        alpha_tolower = return_string;
    end
    endfunction

    function integer display_msg;
    input [8*2:1] cntr_name;
    input msg_code;
    integer msg_code;
    begin
        if (msg_code == 1)
            $display ("Warning : %s counter switched from BYPASS mode to enabled. PLL may lose lock.", cntr_name);
        else if (msg_code == 2)
            $display ("Warning : Illegal 1 value for %s counter. Instead, the %s counter should be BYPASSED. Reconfiguration may not work.", cntr_name, cntr_name);
        else if (msg_code == 3)
            $display ("Warning : Illegal value for counter %s in BYPASS mode. The LSB of the counter should be set to 0 in order to operate the counter in BYPASS mode. Reconfiguration may not work.", cntr_name);
        else if (msg_code == 4)
            $display ("Warning : %s counter switched from enabled to BYPASS mode. PLL may lose lock.", cntr_name);

        display_msg = 1;
    end
    endfunction

    initial
    begin

        // convert string parameter values from uppercase to lowercase,
        // as expected in this model
        l_operation_mode             = alpha_tolower(operation_mode);
        l_pll_type                   = alpha_tolower(pll_type);
        l_qualify_conf_done          = alpha_tolower(qualify_conf_done);
        l_compensate_clock           = alpha_tolower(compensate_clock);
        l_primary_clock              = alpha_tolower(primary_clock);
        l_gate_lock_signal           = alpha_tolower(gate_lock_signal);
        l_switch_over_on_lossclk     = alpha_tolower(switch_over_on_lossclk);
        l_switch_over_on_gated_lock  = alpha_tolower(switch_over_on_gated_lock);
        l_enable_switch_over_counter = alpha_tolower(enable_switch_over_counter);
        l_switch_over_type           = alpha_tolower(switch_over_type);
        l_feedback_source            = alpha_tolower(feedback_source);
        l_bandwidth_type             = alpha_tolower(bandwidth_type);
        l_simulation_type            = alpha_tolower(simulation_type);
        l_enable0_counter            = alpha_tolower(enable0_counter);
        l_enable1_counter            = alpha_tolower(enable1_counter);

        // initialize charge_pump_current, and loop_filter tables
        loop_filter_c_arr[0] = 57;
        loop_filter_c_arr[1] = 16;
        loop_filter_c_arr[2] = 36;
        loop_filter_c_arr[3] = 5;
        
        fpll_loop_filter_c_arr[0] = 18;
        fpll_loop_filter_c_arr[1] = 13;
        fpll_loop_filter_c_arr[2] = 8;
        fpll_loop_filter_c_arr[3] = 2;
        
        charge_pump_curr_arr[0] = 6;
        charge_pump_curr_arr[1] = 12;
        charge_pump_curr_arr[2] = 30;
        charge_pump_curr_arr[3] = 36;
        charge_pump_curr_arr[4] = 52;
        charge_pump_curr_arr[5] = 57;
        charge_pump_curr_arr[6] = 72;
        charge_pump_curr_arr[7] = 77;
        charge_pump_curr_arr[8] = 92;
        charge_pump_curr_arr[9] = 96;
        charge_pump_curr_arr[10] = 110;
        charge_pump_curr_arr[11] = 114;
        charge_pump_curr_arr[12] = 127;
        charge_pump_curr_arr[13] = 131;
        charge_pump_curr_arr[14] = 144;
        charge_pump_curr_arr[15] = 148;

        loop_filter_r_arr[0] = " 1.000000";
        loop_filter_r_arr[1] = " 1.500000";
        loop_filter_r_arr[2] = " 2.000000";
        loop_filter_r_arr[3] = " 2.500000";
        loop_filter_r_arr[4] = " 3.000000";
        loop_filter_r_arr[5] = " 3.500000";
        loop_filter_r_arr[6] = " 4.000000";
        loop_filter_r_arr[7] = " 4.500000";
        loop_filter_r_arr[8] = " 5.000000";
        loop_filter_r_arr[9] = " 5.500000";
        loop_filter_r_arr[10] = " 6.000000";
        loop_filter_r_arr[11] = " 6.500000";
        loop_filter_r_arr[12] = " 7.000000";
        loop_filter_r_arr[13] = " 7.500000";
        loop_filter_r_arr[14] = " 8.000000";
        loop_filter_r_arr[15] = " 8.500000";
        loop_filter_r_arr[16] = " 9.000000";
        loop_filter_r_arr[17] = " 9.500000";
        loop_filter_r_arr[18] = "10.000000";
        loop_filter_r_arr[19] = "10.500000";
        loop_filter_r_arr[20] = "11.000000";
        loop_filter_r_arr[21] = "11.500000";
        loop_filter_r_arr[22] = "12.000000";
        loop_filter_r_arr[23] = "12.500000";
        loop_filter_r_arr[24] = "13.000000";
        loop_filter_r_arr[25] = "13.500000";
        loop_filter_r_arr[26] = "14.000000";
        loop_filter_r_arr[27] = "14.500000";
        loop_filter_r_arr[28] = "15.000000";
        loop_filter_r_arr[29] = "15.500000";
        loop_filter_r_arr[30] = "16.000000";
        loop_filter_r_arr[31] = "16.500000";
        loop_filter_r_arr[32] = "17.000000";
        loop_filter_r_arr[33] = "17.500000";
        loop_filter_r_arr[34] = "18.000000";
        loop_filter_r_arr[35] = "18.500000";
        loop_filter_r_arr[36] = "19.000000";
        loop_filter_r_arr[37] = "19.500000";
        loop_filter_r_arr[38] = "20.000000";
        loop_filter_r_arr[39] = "20.500000";

        if (m == 0)
        begin
            i_clk5_counter    = "c5" ;
            i_clk4_counter    = "c4" ;
            i_clk3_counter    = "c3" ;
            i_clk2_counter    = "c2" ;
            i_clk1_counter    = "c1" ;
            i_clk0_counter    = "c0" ;
        end
        else begin
            i_clk5_counter    = alpha_tolower(clk5_counter);
            i_clk4_counter    = alpha_tolower(clk4_counter);
            i_clk3_counter    = alpha_tolower(clk3_counter);
            i_clk2_counter    = alpha_tolower(clk2_counter);
            i_clk1_counter    = alpha_tolower(clk1_counter);
            i_clk0_counter    = alpha_tolower(clk0_counter);
        end

        // VCO feedback loop settings for external feedback mode
        // first find which counter is used for feedback
        if (l_operation_mode == "external_feedback")
        begin
           if (l_feedback_source == "clk0")
               ext_fbk_cntr = i_clk0_counter;
           else if (l_feedback_source == "clk1")
               ext_fbk_cntr = i_clk1_counter;
           else if (l_feedback_source == "clk2")
               ext_fbk_cntr = i_clk2_counter;
           else if (l_feedback_source == "clk3")
               ext_fbk_cntr = i_clk3_counter;
           else if (l_feedback_source == "clk4")
               ext_fbk_cntr = i_clk4_counter;
           else if (l_feedback_source == "clk5")
               ext_fbk_cntr = i_clk5_counter;
           else ext_fbk_cntr = "c0";

           if (ext_fbk_cntr == "c0")
               ext_fbk_cntr_index = 0;
           else if (ext_fbk_cntr == "c1")
               ext_fbk_cntr_index = 1;
           else if (ext_fbk_cntr == "c2")
               ext_fbk_cntr_index = 2;
           else if (ext_fbk_cntr == "c3")
               ext_fbk_cntr_index = 3;
           else if (ext_fbk_cntr == "c4")
               ext_fbk_cntr_index = 4;
           else if (ext_fbk_cntr == "c5")
               ext_fbk_cntr_index = 5;
        end

        if (m == 0)
        begin 
            // scale down the multiply_by and divide_by values provided by the design
            // before attempting to use them in the calculations below
            i_clk0_mult_by = scale_mult(clk0_multiply_by, clk0_divide_by);
            i_clk0_div_by = scale_div(clk0_multiply_by, clk0_divide_by);            
            i_clk1_mult_by = scale_mult(clk1_multiply_by, clk1_divide_by);
            i_clk1_div_by = scale_div(clk1_multiply_by, clk1_divide_by);
            i_clk2_mult_by = scale_mult(clk2_multiply_by, clk2_divide_by);
            i_clk2_div_by = scale_div(clk2_multiply_by, clk2_divide_by);
            i_clk3_mult_by = scale_mult(clk3_multiply_by, clk3_divide_by);
            i_clk3_div_by = scale_div(clk3_multiply_by, clk3_divide_by);
            i_clk4_mult_by = scale_mult(clk4_multiply_by, clk4_divide_by);
            i_clk4_div_by = scale_div(clk4_multiply_by, clk4_divide_by);
            i_clk5_mult_by = scale_mult(clk5_multiply_by, clk5_divide_by);
            i_clk5_div_by = scale_div(clk5_multiply_by, clk5_divide_by);

            if (l_pll_type != "lvds")
            begin
                clk0_gcd = gcd(i_clk0_mult_by, i_clk0_div_by);
                i_clk0_mult_by = i_clk0_mult_by / clk0_gcd;
                i_clk0_div_by = i_clk0_div_by / clk0_gcd;
                clk1_gcd = gcd(i_clk1_mult_by, i_clk1_div_by);
                i_clk1_mult_by = i_clk1_mult_by / clk1_gcd;
                i_clk1_div_by = i_clk1_div_by / clk1_gcd;
                clk2_gcd = gcd(i_clk2_mult_by, i_clk2_div_by);
                i_clk2_mult_by = i_clk2_mult_by / clk2_gcd;
                i_clk2_div_by = i_clk2_div_by / clk2_gcd;
                clk3_gcd = gcd(i_clk3_mult_by, i_clk3_div_by);
                i_clk3_mult_by = i_clk3_mult_by / clk3_gcd;
                i_clk3_div_by = i_clk3_div_by / clk3_gcd;
                clk4_gcd = gcd(i_clk4_mult_by, i_clk4_div_by);
                i_clk4_mult_by = i_clk4_mult_by / clk4_gcd;
                i_clk4_div_by = i_clk4_div_by / clk4_gcd;
                clk5_gcd = gcd(i_clk5_mult_by, i_clk5_div_by);
                i_clk5_mult_by = i_clk5_mult_by / clk5_gcd;
                i_clk5_div_by = i_clk5_div_by / clk5_gcd;
            end

            // convert user parameters to advanced
            if (((l_pll_type == "fast") || (l_pll_type == "lvds")) && (vco_multiply_by != 0) && (vco_divide_by != 0))
            begin
                i_n = vco_divide_by;
                i_m = vco_multiply_by;
            end
            else begin
                i_n = 1;
                i_m = lcm (i_clk0_mult_by, i_clk1_mult_by,
                           i_clk2_mult_by, i_clk3_mult_by,
                           i_clk4_mult_by, i_clk5_mult_by,
                           1, 1, 1, 1, inclk0_input_frequency);
            end

            i_c_high[0] = counter_high(output_counter_value(i_clk0_div_by,
                        i_clk0_mult_by, i_m, i_n), clk0_duty_cycle);
            i_c_high[1] = counter_high(output_counter_value(i_clk1_div_by,
                        i_clk1_mult_by, i_m, i_n), clk1_duty_cycle);
            i_c_high[2] = counter_high(output_counter_value(i_clk2_div_by,
                        i_clk2_mult_by, i_m, i_n), clk2_duty_cycle);
            i_c_high[3] = counter_high(output_counter_value(i_clk3_div_by,
                        i_clk3_mult_by, i_m, i_n), clk3_duty_cycle);
            i_c_high[4] = counter_high(output_counter_value(i_clk4_div_by,
                        i_clk4_mult_by,  i_m, i_n), clk4_duty_cycle);
            i_c_high[5] = counter_high(output_counter_value(i_clk5_div_by,
                        i_clk5_mult_by,  i_m, i_n), clk5_duty_cycle);

            i_c_low[0]  = counter_low(output_counter_value(i_clk0_div_by,
                        i_clk0_mult_by,  i_m, i_n), clk0_duty_cycle);
            i_c_low[1]  = counter_low(output_counter_value(i_clk1_div_by,
                        i_clk1_mult_by,  i_m, i_n), clk1_duty_cycle);
            i_c_low[2]  = counter_low(output_counter_value(i_clk2_div_by,
                        i_clk2_mult_by,  i_m, i_n), clk2_duty_cycle);
            i_c_low[3]  = counter_low(output_counter_value(i_clk3_div_by,
                        i_clk3_mult_by,  i_m, i_n), clk3_duty_cycle);
            i_c_low[4]  = counter_low(output_counter_value(i_clk4_div_by,
                        i_clk4_mult_by,  i_m, i_n), clk4_duty_cycle);
            i_c_low[5]  = counter_low(output_counter_value(i_clk5_div_by,
                        i_clk5_mult_by,  i_m, i_n), clk5_duty_cycle);

            max_neg_abs = maxnegabs( get_int_phase_shift(clk0_phase_shift, clk0_phase_shift_num),
                                     get_int_phase_shift(clk1_phase_shift, clk1_phase_shift_num),
                                     get_int_phase_shift(clk2_phase_shift, clk2_phase_shift_num),
                                     str2int(clk3_phase_shift),
                                     str2int(clk4_phase_shift),
                                     str2int(clk5_phase_shift),
                                     0, 0, 0, 0);

            i_c_initial[0] = counter_initial(get_phase_degree(ph_adjust(get_int_phase_shift(clk0_phase_shift, clk0_phase_shift_num), max_neg_abs)), i_m, i_n);
            i_c_initial[1] = counter_initial(get_phase_degree(ph_adjust(get_int_phase_shift(clk1_phase_shift, clk1_phase_shift_num), max_neg_abs)), i_m, i_n);
            i_c_initial[2] = counter_initial(get_phase_degree(ph_adjust(get_int_phase_shift(clk2_phase_shift, clk2_phase_shift_num), max_neg_abs)), i_m, i_n);
            i_c_initial[3] = counter_initial(get_phase_degree(ph_adjust(str2int(clk3_phase_shift), max_neg_abs)), i_m, i_n);
            i_c_initial[4] = counter_initial(get_phase_degree(ph_adjust(str2int(clk4_phase_shift), max_neg_abs)), i_m, i_n);
            i_c_initial[5] = counter_initial(get_phase_degree(ph_adjust(str2int(clk5_phase_shift), max_neg_abs)), i_m, i_n);

            i_c_mode[0] = counter_mode(clk0_duty_cycle, output_counter_value(i_clk0_div_by, i_clk0_mult_by,  i_m, i_n));
            i_c_mode[1] = counter_mode(clk1_duty_cycle,output_counter_value(i_clk1_div_by, i_clk1_mult_by,  i_m, i_n));
            i_c_mode[2] = counter_mode(clk2_duty_cycle,output_counter_value(i_clk2_div_by, i_clk2_mult_by,  i_m, i_n));
            i_c_mode[3] = counter_mode(clk3_duty_cycle,output_counter_value(i_clk3_div_by, i_clk3_mult_by,  i_m, i_n));
            i_c_mode[4] = counter_mode(clk4_duty_cycle,output_counter_value(i_clk4_div_by, i_clk4_mult_by,  i_m, i_n));
            i_c_mode[5] = counter_mode(clk5_duty_cycle,output_counter_value(i_clk5_div_by, i_clk5_mult_by,  i_m, i_n));

            i_m_ph    = counter_ph(get_phase_degree(max_neg_abs), i_m, i_n);
            i_m_initial = counter_initial(get_phase_degree(max_neg_abs), i_m, i_n);
            i_c_ph[0] = counter_ph(get_phase_degree(ph_adjust(get_int_phase_shift(clk0_phase_shift, clk0_phase_shift_num),max_neg_abs)), i_m, i_n);
            i_c_ph[1] = counter_ph(get_phase_degree(ph_adjust(get_int_phase_shift(clk1_phase_shift, clk1_phase_shift_num),max_neg_abs)), i_m, i_n);
            i_c_ph[2] = counter_ph(get_phase_degree(ph_adjust(get_int_phase_shift(clk2_phase_shift, clk2_phase_shift_num),max_neg_abs)), i_m, i_n);
            i_c_ph[3] = counter_ph(get_phase_degree(ph_adjust(str2int(clk3_phase_shift),max_neg_abs)), i_m, i_n);
            i_c_ph[4] = counter_ph(get_phase_degree(ph_adjust(str2int(clk4_phase_shift),max_neg_abs)), i_m, i_n);
            i_c_ph[5] = counter_ph(get_phase_degree(ph_adjust(str2int(clk5_phase_shift),max_neg_abs)), i_m, i_n);

            // in external feedback mode, need to adjust M value to take
            // into consideration the external feedback counter value
            if (l_operation_mode == "external_feedback")
            begin
                // if there is a negative phase shift, m_initial can only be 1
                if (max_neg_abs > 0)
                    i_m_initial = 1;

                if (i_c_mode[ext_fbk_cntr_index] == "bypass")
                    output_count = 1;
                else
                    output_count = i_c_high[ext_fbk_cntr_index] + i_c_low[ext_fbk_cntr_index];

                if (i_m > output_count)
                    i_m = i_m / output_count;
                else
                begin
                    new_divisor = gcd(i_m, output_count);
                    i_m = i_m / new_divisor;
                    i_n = output_count / new_divisor;
                end
            end

        end
        else 
        begin //  m != 0

            i_n = n;
            i_m = m;
            i_c_high[0] = c0_high;
            i_c_high[1] = c1_high;
            i_c_high[2] = c2_high;
            i_c_high[3] = c3_high;
            i_c_high[4] = c4_high;
            i_c_high[5] = c5_high;
            i_c_low[0]  = c0_low;
            i_c_low[1]  = c1_low;
            i_c_low[2]  = c2_low;
            i_c_low[3]  = c3_low;
            i_c_low[4]  = c4_low;
            i_c_low[5]  = c5_low;
            i_c_initial[0] = c0_initial;
            i_c_initial[1] = c1_initial;
            i_c_initial[2] = c2_initial;
            i_c_initial[3] = c3_initial;
            i_c_initial[4] = c4_initial;
            i_c_initial[5] = c5_initial;
            i_c_mode[0] = translate_string(alpha_tolower(c0_mode));
            i_c_mode[1] = translate_string(alpha_tolower(c1_mode));
            i_c_mode[2] = translate_string(alpha_tolower(c2_mode));
            i_c_mode[3] = translate_string(alpha_tolower(c3_mode));
            i_c_mode[4] = translate_string(alpha_tolower(c4_mode));
            i_c_mode[5] = translate_string(alpha_tolower(c5_mode));
            i_c_ph[0]  = c0_ph;
            i_c_ph[1]  = c1_ph;
            i_c_ph[2]  = c2_ph;
            i_c_ph[3]  = c3_ph;
            i_c_ph[4]  = c4_ph;
            i_c_ph[5]  = c5_ph;
            i_m_ph   = m_ph;        // default
            i_m_initial = m_initial;

        end // user to advanced conversion

        refclk_period = inclk0_input_frequency * i_n;

        m_times_vco_period = refclk_period;
        new_m_times_vco_period = refclk_period;

        fbclk_period = 0;
        high_time = 0;
        low_time = 0;
        schedule_vco = 0;
        vco_out[7:0] = 8'b0;
        fbclk_last_value = 0;
        offset = 0;
        temp_offset = 0;
        got_first_refclk = 0;
        got_first_fbclk = 0;
        fbclk_time = 0;
        first_fbclk_time = 0;
        refclk_time = 0;
        first_schedule = 1;
        sched_time = 0;
        vco_val = 0;
        c0_got_first_rising_edge = 0;
        c1_got_first_rising_edge = 0;
        vco_c0_last_value = 0;
        c0_count = 2;
        c1_count = 2;
        c0_tmp = 0;
        c1_tmp = 0;
        gate_count = 0;
        gate_out = 0;
        initial_delay = 0;
        fbk_phase = 0;
        for (i = 0; i <= 7; i = i + 1)
        begin
           phase_shift[i] = 0;
           last_phase_shift[i] = 0;
        end
        fbk_delay = 0;
        inclk_n = 0;
        cycle_to_adjust = 0;
        m_delay = 0;
        vco_c0 = 0;
        vco_c1 = 0;
        total_pull_back = 0;
        pull_back_M = 0;
        vco_period_was_phase_adjusted = 0;
        phase_adjust_was_scheduled = 0;
        ena_ipd_last_value = 0;
        inclk_out_of_range = 0;
        scandone_tmp = 0;
        schedule_vco_last_value = 0;

        // set initial values for counter parameters
        m_initial_val = i_m_initial;
        m_val[0] = i_m;
        n_val[0] = i_n;
        m_ph_val = i_m_ph;
        m_ph_val_orig = i_m_ph;
        m_ph_val_tmp = i_m_ph;
        m_val_tmp[0] = i_m;

        m_val[1] = m2;
        n_val[1] = n2;

        if (m_val[0] == 1)
            m_mode_val[0] = "bypass";
        else m_mode_val[0] = "";
        if (m_val[1] == 1)
            m_mode_val[1] = "bypass";
        if (n_val[0] == 1)
            n_mode_val[0] = "bypass";
        if (n_val[1] == 1)
            n_mode_val[1] = "bypass";

        for (i = 0; i < 6; i=i+1)
        begin
            c_high_val[i] = i_c_high[i];
            c_low_val[i] = i_c_low[i];
            c_initial_val[i] = i_c_initial[i];
            c_mode_val[i] = i_c_mode[i];
            c_ph_val[i] = i_c_ph[i];
            c_high_val_tmp[i] = i_c_high[i];
            c_low_val_tmp[i] = i_c_low[i];
            if (c_mode_val[i] == "bypass")
            begin
                if (l_pll_type == "fast" || l_pll_type == "lvds")
                begin
                    c_high_val[i] = 5'b10000;
                    c_low_val[i] = 5'b10000;
                    c_high_val_tmp[i] = 5'b10000;
                    c_low_val_tmp[i] = 5'b10000;
                end
                else begin
                    c_high_val[i] = 9'b100000000;
                    c_low_val[i] = 9'b100000000;
                    c_high_val_tmp[i] = 9'b100000000;
                    c_low_val_tmp[i] = 9'b100000000;
                end
            end

            c_mode_val_tmp[i] = i_c_mode[i];
            c_ph_val_tmp[i] = i_c_ph[i];

            c_ph_val_orig[i] = i_c_ph[i];
            c_high_val_hold[i] = i_c_high[i];
            c_low_val_hold[i] = i_c_low[i];
            c_mode_val_hold[i] = i_c_mode[i];
        end

        lfc_val = loop_filter_c;
        lfr_val = loop_filter_r;
        cp_curr_val = charge_pump_current;

        i = 0;
        j = 0;
        inclk_last_value = 0;

        ext_fbk_cntr_ph = 0;
        ext_fbk_cntr_initial = 1;

        // initialize clkswitch variables

        clk0_is_bad = 0;
        clk1_is_bad = 0;
        inclk0_last_value = 0;
        inclk1_last_value = 0;
        other_clock_value = 0;
        other_clock_last_value = 0;
        primary_clk_is_bad = 0;
        current_clk_is_bad = 0;
        external_switch = 0;
        current_clock = l_primary_clock;
        active_clock = 0;   // primary_clk is always inclk0
        if (l_switch_over_type == "manual" && clkswitch_ipd === 1'b1)
        begin
            current_clock = "inclk1";
            active_clock = 1;
        end
        clkloss_tmp = 0;
        got_curr_clk_falling_edge_after_clkswitch = 0;
        clk0_count = 0;
        clk1_count = 0;
        switch_over_count = 0;

        // initialize reconfiguration variables
        // quiet_time
        quiet_time = slowest_clk(c_high_val[0]+c_low_val[0], c_mode_val[0],
                                 c_high_val[1]+c_low_val[1], c_mode_val[1],
                                 c_high_val[2]+c_low_val[2], c_mode_val[2],
                                 c_high_val[3]+c_low_val[3], c_mode_val[3],
                                 c_high_val[4]+c_low_val[4], c_mode_val[4],
                                 c_high_val[5]+c_low_val[5], c_mode_val[5],
                                 refclk_period, m_val[0]);
        reconfig_err = 0;
        error = 0;
        scanread_active_edge = 0;
        if ((l_pll_type == "fast") || (l_pll_type == "lvds"))
        begin
            scan_chain_length = FAST_SCAN_CHAIN;
            num_output_cntrs = 4;
        end
        else
        begin
            scan_chain_length = GPP_SCAN_CHAIN;
            num_output_cntrs = 6;
        end
        scanread_reg = 0;
        scanwrite_reg = 0;
        scanwrite_enabled = 0;
        c0_rising_edge_transfer_done = 0;
        c1_rising_edge_transfer_done = 0;
        c2_rising_edge_transfer_done = 0;
        c3_rising_edge_transfer_done = 0;
        c4_rising_edge_transfer_done = 0;
        c5_rising_edge_transfer_done = 0;
        got_first_scanclk = 0;
        got_first_gated_scanclk = 0;
        gated_scanclk = 1;
        scanread_setup_violation = 0;
        index = 0;

        // initialize the scan_chain contents
        // CP/LF  bits
        scan_data[11:0] = 12'b0;
        for (i = 0; i <= 3; i = i + 1)
        begin
            if ((l_pll_type == "fast") || (l_pll_type == "lvds"))
            begin
                if (fpll_loop_filter_c_arr[i] == loop_filter_c)
                    scan_data[11:10] = i;
            end
            else begin
                if (loop_filter_c_arr[i] == loop_filter_c)
                    scan_data[11:10] = i;
            end
        end
        for (i = 0; i <= 15; i = i + 1)
        begin
            if (charge_pump_curr_arr[i] == charge_pump_current)
                scan_data[3:0] = i;
        end
        for (i = 0; i <= 39; i = i + 1)
        begin
            if (loop_filter_r_arr[i] == loop_filter_r)
            begin
                if ((i >= 16) && (i <= 23))
                    scan_data[9:4] = i+8;
                else if ((i >= 24) && (i <= 31))
                    scan_data[9:4] = i+16;
                else if (i >= 32)
                    scan_data[9:4] = i+24;
                else
                    scan_data[9:4] = i;
            end
        end

        if (l_pll_type == "fast" || l_pll_type == "lvds")
        begin
            scan_data[21:12] = 10'b0; // M, C3-C0 ph
            // C0-C3 high
            scan_data[25:22] = c_high_val[0];
            scan_data[35:32] = c_high_val[1];
            scan_data[45:42] = c_high_val[2];
            scan_data[55:52] = c_high_val[3];
            // C0-C3 low
            scan_data[30:27] = c_low_val[0];
            scan_data[40:37] = c_low_val[1];
            scan_data[50:47] = c_low_val[2];
            scan_data[60:57] = c_low_val[3];
            // C0-C3 mode
            for (i = 0; i < 4; i = i + 1)
            begin
                if (c_mode_val[i] == "   off" || c_mode_val[i] == "bypass")
                begin
                    scan_data[26 + (10*i)] = 1;
                    if (c_mode_val[i] == "   off")
                        scan_data[31 + (10*i)] = 1;
                    else
                        scan_data[31 + (10*i)] = 0;
                end
                else begin
                    scan_data[26 + (10*i)] = 0;
                    if (c_mode_val[i] == "   odd")
                        scan_data[31 + (10*i)] = 1;
                    else
                        scan_data[31 + (10*i)] = 0;
                end
            end
            // M
            if (m_mode_val[0] == "bypass")
            begin
                scan_data[66] = 1;
                scan_data[71] = 0;
                scan_data[65:62] = 4'b0;
                scan_data[70:67] = 4'b0;
            end
            else begin
                scan_data[66] = 0;       // set BYPASS bit to 0
                scan_data[70:67] = m_val[0]/2;   // set M low
                if (m_val[0] % 2 == 0)
                begin
                    // M is an even no. : set M high = low,
                    // set odd/even bit to 0
                    scan_data[65:62] = scan_data[70:67];
                    scan_data[71] = 0;
                end
                else begin // M is odd : M high = low + 1
                    scan_data[65:62] = (m_val[0]/2) + 1;
                    scan_data[71] = 1;
                end
            end
            // N
            scan_data[73:72] = n_val[0];
            if (n_mode_val[0] == "bypass")
            begin
                scan_data[74] = 1;
                scan_data[73:72] = 2'b0;
            end
        end
        else begin             // PLL type is enhanced/auto
            scan_data[25:12] = 14'b0;

            // C5-C0 high
            scan_data[33:26] = c_high_val[5];
            scan_data[51:44] = c_high_val[4];
            scan_data[69:62] = c_high_val[3];
            scan_data[87:80] = c_high_val[2];
            scan_data[105:98] = c_high_val[1];
            scan_data[123:116] = c_high_val[0];
            // C5-C0 low
            scan_data[42:35] = c_low_val[5];
            scan_data[60:53] = c_low_val[4];
            scan_data[78:71] = c_low_val[3];
            scan_data[96:89] = c_low_val[2];
            scan_data[114:107] = c_low_val[1];
            scan_data[132:125] = c_low_val[0];

            for (i = 5; i >= 0; i = i - 1)
            begin
                if (c_mode_val[i] == "   off" || c_mode_val[i] == "bypass")
                begin
                    scan_data[124 - (18*i)] = 1;
                    if (c_mode_val[i] == "   off")
                        scan_data[133 - (18*i)] = 1;
                    else
                        scan_data[133 - (18*i)] = 0;
                end
                else begin
                    scan_data[124 - (18*i)] = 0;
                    if (c_mode_val[i] == "   odd")
                        scan_data[133 - (18*i)] = 1;
                    else
                        scan_data[133 - (18*i)] = 0;
                end
            end

            scan_data[142:134] = m_val[0];
            scan_data[143] = 0;
            scan_data[152:144] = m_val[1];
            scan_data[153] = 0;
            if (m_mode_val[0] == "bypass")
            begin
                scan_data[143] = 1;
                scan_data[142:134] = 9'b0;
            end
            if (m_mode_val[1] == "bypass")
            begin
                scan_data[153] = 1;
                scan_data[152:144] = 9'b0;
            end

            scan_data[162:154] = n_val[0];
            scan_data[172:164] = n_val[1];
            if (n_mode_val[0] == "bypass")
            begin
                scan_data[163] = 1;
                scan_data[162:154] = 9'b0;
            end
            if (n_mode_val[1] == "bypass")
            begin
                scan_data[173] = 1;
                scan_data[172:164] = 9'b0;
            end
        end

        // now save this counter's parameters
        ext_fbk_cntr_high = c_high_val[ext_fbk_cntr_index];
        ext_fbk_cntr_low = c_low_val[ext_fbk_cntr_index];
        ext_fbk_cntr_ph = c_ph_val[ext_fbk_cntr_index];
        ext_fbk_cntr_initial = c_initial_val[ext_fbk_cntr_index];
        ext_fbk_cntr_mode = c_mode_val[ext_fbk_cntr_index];

        if (ext_fbk_cntr_mode == "bypass")
            ext_fbk_cntr_modulus = 1;
        else
            ext_fbk_cntr_modulus = ext_fbk_cntr_high + ext_fbk_cntr_low;

        l_index = 1;
        stop_vco = 0;
        cycles_to_lock = 0;
        cycles_to_unlock = 0;
        locked_tmp = 0;
        pll_is_locked = 0;
        pll_about_to_lock = 0;
    end

    always @(clkswitch_ipd)
    begin
       if (clkswitch_ipd === 1'b1 && l_switch_over_type == "auto")
           external_switch = 1;
       else if (l_switch_over_type == "manual")
       begin
           if (clkswitch_ipd === 1'b1)
           begin
              current_clock = "inclk1";
              active_clock = 1;
           end
           else if (clkswitch_ipd === 1'b0)
           begin
              current_clock = "inclk0";
              active_clock = 0;
           end
       end
    end

    always @(inclk0_ipd or inclk1_ipd)
    begin
        // save the inclk event value
        if (inclk0_ipd !== inclk0_last_value)
        begin
            if (current_clock !== "inclk0")
                other_clock_value = inclk0_ipd;
        end
        if (inclk1_ipd !== inclk1_last_value)
        begin
            if (current_clock !== "inclk1")
                other_clock_value = inclk1_ipd;
        end

        // check if either input clk is bad
        if (inclk0_ipd === 1'b1 && inclk0_ipd !== inclk0_last_value)
        begin
            clk0_count = clk0_count + 1;
            clk0_is_bad = 0;
            clk1_count = 0;
            if (clk0_count > 2)
            begin
               // no event on other clk for 2 cycles
               clk1_is_bad = 1;
               if (current_clock == "inclk1")
                  current_clk_is_bad = 1;
            end
        end
        if (inclk1_ipd === 1'b1 && inclk1_ipd !== inclk1_last_value)
        begin
            clk1_count = clk1_count + 1;
            clk1_is_bad = 0;
            clk0_count = 0;
            if (clk1_count > 2)
            begin
               // no event on other clk for 2 cycles
               clk0_is_bad = 1;
               if (current_clock == "inclk0")
                  current_clk_is_bad = 1;
            end
        end

        // check if the bad clk is the primary clock, which is always clk0
        if (clk0_is_bad == 1'b1)
           primary_clk_is_bad = 1;
        else
           primary_clk_is_bad = 0;

        // actual switching -- manual switch
        if ((inclk0_ipd !== inclk0_last_value) && current_clock == "inclk0")
        begin
           if (external_switch == 1'b1)
           begin
              if (!got_curr_clk_falling_edge_after_clkswitch)
              begin
                 if (inclk0_ipd === 1'b0)
                    got_curr_clk_falling_edge_after_clkswitch = 1;
                 inclk_n = inclk0_ipd;
              end
           end
           else inclk_n = inclk0_ipd;
        end
        if ((inclk1_ipd !== inclk1_last_value) && current_clock == "inclk1")
        begin
           if (external_switch == 1'b1)
           begin
              if (!got_curr_clk_falling_edge_after_clkswitch)
              begin
                 if (inclk1_ipd === 1'b0)
                    got_curr_clk_falling_edge_after_clkswitch = 1;
                 inclk_n = inclk1_ipd;
              end
           end
           else inclk_n = inclk1_ipd;
        end

        // actual switching -- automatic switch
        if ((other_clock_value == 1'b1) && (other_clock_value != other_clock_last_value) && (l_switch_over_on_lossclk == "on") && l_enable_switch_over_counter == "on" && primary_clk_is_bad)
            switch_over_count = switch_over_count + 1;

        if ((other_clock_value == 1'b0) && (other_clock_value != other_clock_last_value))
        begin
            if ((external_switch && (got_curr_clk_falling_edge_after_clkswitch || current_clk_is_bad)) || (l_switch_over_on_lossclk == "on" && primary_clk_is_bad && l_pll_type !== "fast" && l_pll_type !== "lvds" && ((l_enable_switch_over_counter == "off" || switch_over_count == switch_over_counter))))
            begin
                got_curr_clk_falling_edge_after_clkswitch = 0;
                if (current_clock == "inclk0")
                   current_clock = "inclk1";
                else
                   current_clock = "inclk0";
                active_clock = ~active_clock;
                switch_over_count = 0;
                external_switch = 0;
                current_clk_is_bad = 0;
            end
        end

        if (l_switch_over_on_lossclk == "on" && (clkswitch_ipd != 1'b1))
        begin
           if (primary_clk_is_bad)
              clkloss_tmp = 1;
           else
              clkloss_tmp = 0;
        end
        else clkloss_tmp = clkswitch_ipd;

        inclk0_last_value = inclk0_ipd;
        inclk1_last_value = inclk1_ipd;
        other_clock_last_value = other_clock_value;

    end

    and (clkbad[0], clk0_is_bad, 1'b1);
    and (clkbad[1], clk1_is_bad, 1'b1);
    and (activeclock, active_clock, 1'b1);
    and (clkloss, clkloss_tmp, 1'b1);

    assign inclk_m = (m_test_source == 0) ? inclk_n : l_operation_mode == "external_feedback" ? (l_feedback_source == "clk0" ? clk0_tmp :
                     l_feedback_source == "clk1" ? clk1_tmp :
                     l_feedback_source == "clk2" ? clk2_tmp :
                     l_feedback_source == "clk3" ? clk3_tmp :
                     l_feedback_source == "clk4" ? clk4_tmp :
                     l_feedback_source == "clk5" ? clk5_tmp : 'b0) :
                     inclk_m_from_vco;

    m_cntr m1 (.clk(inclk_m),
                .reset(areset_ipd || (!ena_ipd) || stop_vco),
                .cout(fbclk),
                .initial_value(m_initial_val),
                .modulus(m_val[0]),
                .time_delay(m_delay));

    n_cntr n1 (.clk(inclk_n),
               .reset(areset_ipd),
               .cout(refclk),
               .modulus(n_val[0])
              );

    always @(negedge vco_out[c_ph_val[0]])
        c_ph_val[0] <= c_ph_val_tmp[0];
    always @(negedge vco_out[c_ph_val[1]])
        c_ph_val[1] <= c_ph_val_tmp[1];
    always @(negedge vco_out[c_ph_val[2]])
        c_ph_val[2] <= c_ph_val_tmp[2];
    always @(negedge vco_out[c_ph_val[3]])
        c_ph_val[3] <= c_ph_val_tmp[3];
    always @(negedge vco_out[c_ph_val[4]])
        c_ph_val[4] <= c_ph_val_tmp[4];
    always @(negedge vco_out[c_ph_val[5]])
        c_ph_val[5] <= c_ph_val_tmp[5];

    always @(negedge vco_out[m_ph_val])
        m_ph_val <= m_ph_val_tmp;

    always @(vco_out)
    begin
        inclk_c0_from_vco <= vco_out[c_ph_val[0]];
        inclk_c1_from_vco <= vco_out[c_ph_val[1]];
        inclk_c2_from_vco <= vco_out[c_ph_val[2]];
        inclk_c3_from_vco <= vco_out[c_ph_val[3]];
        inclk_c4_from_vco <= vco_out[c_ph_val[4]];
        inclk_c5_from_vco <= vco_out[c_ph_val[5]];

        if (enable0_counter == "c0")
            inclk_sclkout0_from_vco <= vco_out[c_ph_val[0]];
        else if (enable0_counter == "c1")
            inclk_sclkout0_from_vco <= vco_out[c_ph_val[1]];

        if (enable1_counter == "c0")
            inclk_sclkout1_from_vco <= vco_out[c_ph_val[0]];
        else if (enable1_counter == "c1")
            inclk_sclkout1_from_vco <= vco_out[c_ph_val[1]];

        inclk_m_from_vco <= vco_out[m_ph_val];
    end

    always @(inclk_sclkout0_from_vco)
    begin
        sclkout0_tmp <= inclk_sclkout0_from_vco;
    end
    always @(inclk_sclkout1_from_vco)
    begin
        sclkout1_tmp <= inclk_sclkout1_from_vco;
    end

    assign inclk_c0 = (c0_test_source == 0) ? inclk_n : (c0_test_source == 1) ? refclk : inclk_c0_from_vco;
    scale_cntr c0 (.clk(inclk_c0),
                   .reset(areset_ipd || (!ena_ipd) || stop_vco),
                   .cout(c0_clk),
                   .high(c_high_val[0]),
                   .low(c_low_val[0]),
                   .initial_value(c_initial_val[0]),
                   .mode(c_mode_val[0]),
                   .ph_tap(c_ph_val[0])
                  );

    always @(posedge c0_clk)
    begin
        if (scanwrite_enabled == 1'b1)
        begin
            c_high_val_hold[0] <= c_high_val_tmp[0];
            c_mode_val_hold[0] <= c_mode_val_tmp[0];
            c_high_val[0] <= c_high_val_hold[0];
            c_mode_val[0] <= c_mode_val_hold[0];
            c0_rising_edge_transfer_done = 1;
        end
    end
    always @(negedge c0_clk)
    begin
        if (c0_rising_edge_transfer_done)
        begin
            c_low_val_hold[0] <= c_low_val_tmp[0];
            c_low_val[0] <= c_low_val_hold[0];
        end
    end

    assign inclk_c1 = (c1_test_source == 0) ? inclk_n : (c1_test_source == 2) ? fbclk : (c1_use_casc_in == "on") ? c0_clk : inclk_c1_from_vco;
    scale_cntr c1 (.clk(inclk_c1),
                   .reset(areset_ipd || (!ena_ipd) || stop_vco),
                   .cout(c1_clk),
                   .high(c_high_val[1]),
                   .low(c_low_val[1]),
                   .initial_value(c_initial_val[1]),
                   .mode(c_mode_val[1]),
                   .ph_tap(c_ph_val[1])
                  );

    always @(posedge c1_clk)
    begin
        if (scanwrite_enabled == 1'b1)
        begin
            c_high_val_hold[1] <= c_high_val_tmp[1];
            c_mode_val_hold[1] <= c_mode_val_tmp[1];
            c_high_val[1] <= c_high_val_hold[1];
            c_mode_val[1] <= c_mode_val_hold[1];
            c1_rising_edge_transfer_done = 1;
        end
    end
    always @(negedge c1_clk)
    begin
        if (c1_rising_edge_transfer_done)
        begin
            c_low_val_hold[1] <= c_low_val_tmp[1];
            c_low_val[1] <= c_low_val_hold[1];
        end
    end

    assign inclk_c2 = (c2_test_source == 0) ? inclk_n : (c2_use_casc_in == "on") ? c1_clk : inclk_c2_from_vco;
    scale_cntr c2 (.clk(inclk_c2),
                   .reset(areset_ipd || (!ena_ipd) || stop_vco),
                   .cout(c2_clk),
                   .high(c_high_val[2]),
                   .low(c_low_val[2]),
                   .initial_value(c_initial_val[2]),
                   .mode(c_mode_val[2]),
                   .ph_tap(c_ph_val[2])
                  );

    always @(posedge c2_clk)
    begin
        if (scanwrite_enabled == 1'b1)
        begin
            c_high_val_hold[2] <= c_high_val_tmp[2];
            c_mode_val_hold[2] <= c_mode_val_tmp[2];
            c_high_val[2] <= c_high_val_hold[2];
            c_mode_val[2] <= c_mode_val_hold[2];
            c2_rising_edge_transfer_done = 1;
        end
    end
    always @(negedge c2_clk)
    begin
        if (c2_rising_edge_transfer_done)
        begin
            c_low_val_hold[2] <= c_low_val_tmp[2];
            c_low_val[2] <= c_low_val_hold[2];
        end
    end

    assign inclk_c3 = (c3_test_source == 0) ? inclk_n : (c3_use_casc_in == "on") ? c2_clk : inclk_c3_from_vco;
    scale_cntr c3 (.clk(inclk_c3),
                   .reset(areset_ipd || (!ena_ipd) || stop_vco),
                   .cout(c3_clk),
                   .high(c_high_val[3]),
                   .low(c_low_val[3]),
                   .initial_value(c_initial_val[3]),
                   .mode(c_mode_val[3]),
                   .ph_tap(c_ph_val[3])
                  );

    always @(posedge c3_clk)
    begin
        if (scanwrite_enabled == 1'b1)
        begin
            c_high_val_hold[3] <= c_high_val_tmp[3];
            c_mode_val_hold[3] <= c_mode_val_tmp[3];
            c_high_val[3] <= c_high_val_hold[3];
            c_mode_val[3] <= c_mode_val_hold[3];
            c3_rising_edge_transfer_done = 1;
        end
    end
    always @(negedge c3_clk)
    begin
        if (c3_rising_edge_transfer_done)
        begin
            c_low_val_hold[3] <= c_low_val_tmp[3];
            c_low_val[3] <= c_low_val_hold[3];
        end
    end

    assign inclk_c4 = (c4_test_source == 0) ? inclk_n : (c4_use_casc_in == "on") ? c3_clk : inclk_c4_from_vco;
    scale_cntr c4 (.clk(inclk_c4),
                   .reset(areset_ipd || (!ena_ipd) || stop_vco),
                   .cout(c4_clk),
                   .high(c_high_val[4]),
                   .low(c_low_val[4]),
                   .initial_value(c_initial_val[4]),
                   .mode(c_mode_val[4]),
                   .ph_tap(c_ph_val[4])
                  );

    always @(posedge c4_clk)
    begin
        if (scanwrite_enabled == 1'b1)
        begin
            c_high_val_hold[4] <= c_high_val_tmp[4];
            c_mode_val_hold[4] <= c_mode_val_tmp[4];
            c_high_val[4] <= c_high_val_hold[4];
            c_mode_val[4] <= c_mode_val_hold[4];
            c4_rising_edge_transfer_done = 1;
        end
    end
    always @(negedge c4_clk)
    begin
        if (c4_rising_edge_transfer_done)
        begin
            c_low_val_hold[4] <= c_low_val_tmp[4];
            c_low_val[4] <= c_low_val_hold[4];
        end
    end

    assign inclk_c5 = (c5_test_source == 0) ? inclk_n : (c5_use_casc_in == "on") ? c4_clk : inclk_c5_from_vco;
    scale_cntr c5 (.clk(inclk_c5),
                   .reset(areset_ipd || (!ena_ipd) || stop_vco),
                   .cout(c5_clk),
                   .high(c_high_val[5]),
                   .low(c_low_val[5]),
                   .initial_value(c_initial_val[5]),
                   .mode(c_mode_val[5]),
                   .ph_tap(c_ph_val[5])
                  );

    always @(posedge c5_clk)
    begin
        if (scanwrite_enabled == 1'b1)
        begin
            c_high_val_hold[5] <= c_high_val_tmp[5];
            c_mode_val_hold[5] <= c_mode_val_tmp[5];
            c_high_val[5] <= c_high_val_hold[5];
            c_mode_val[5] <= c_mode_val_hold[5];
            c5_rising_edge_transfer_done = 1;
        end
    end
    always @(negedge c5_clk)
    begin
        if (c5_rising_edge_transfer_done)
        begin
            c_low_val_hold[5] <= c_low_val_tmp[5];
            c_low_val[5] <= c_low_val_hold[5];
        end
    end

    always @(vco_out[c_ph_val[0]] or posedge areset_ipd or negedge ena_ipd or stop_vco)
    begin
        if (areset_ipd == 1'b1 || ena_ipd == 1'b0 || stop_vco == 1'b1)
        begin
            c0_count = 2;
            c0_got_first_rising_edge = 0;

        end
        else begin
            if (c0_got_first_rising_edge == 1'b0)
            begin
                if (vco_out[c_ph_val[0]] == 1'b1 && vco_out[c_ph_val[0]] != vco_c0_last_value)
                    c0_got_first_rising_edge = 1;
            end
            else if (vco_out[c_ph_val[0]] != vco_c0_last_value)
            begin
                c0_count = c0_count + 1;
                if (c0_count == (c_high_val[0] + c_low_val[0]) * 2)
                    c0_count  = 1;
            end
            if (vco_out[c_ph_val[0]] == 1'b0 && vco_out[c_ph_val[0]] != vco_c0_last_value)
            begin
                if (c0_count == 1)
                begin
                    c0_tmp = 1;
                    c0_got_first_rising_edge = 0;
                end
                else c0_tmp = 0;
            end
        end
        vco_c0_last_value = vco_out[c_ph_val[0]];
    end

    always @(vco_out[c_ph_val[1]] or posedge areset_ipd or negedge ena_ipd or stop_vco)
    begin
        if (areset_ipd == 1'b1 || ena_ipd == 1'b0 || stop_vco == 1'b1)
        begin
            c1_count = 2;
            c1_got_first_rising_edge = 0;
        end
        else begin
            if (c1_got_first_rising_edge == 1'b0)
            begin
                if (vco_out[c_ph_val[1]] == 1'b1 && vco_out[c_ph_val[1]] != vco_c1_last_value)
                    c1_got_first_rising_edge = 1;
            end
            else if (vco_out[c_ph_val[1]] != vco_c1_last_value)
            begin
                c1_count = c1_count + 1;
                if (c1_count == (c_high_val[1] + c_low_val[1]) * 2)
                    c1_count  = 1;
            end
            if (vco_out[c_ph_val[1]] == 1'b0 && vco_out[c_ph_val[1]] != vco_c1_last_value)
            begin
                if (c1_count == 1)
                begin
                    c1_tmp = 1;
                    c1_got_first_rising_edge = 0;
                end
                else c1_tmp = 0;
            end
        end
        vco_c1_last_value = vco_out[c_ph_val[1]];
    end

    assign enable0_tmp = (l_enable0_counter == "c0") ? c0_tmp : c1_tmp;
    assign enable1_tmp = (l_enable1_counter == "c0") ? c0_tmp : c1_tmp;

    always @ (inclk_n or ena_ipd or areset_ipd)
    begin
       if (areset_ipd == 1'b1 || ena_ipd == 1'b0)
       begin
           gate_count = 0;
           gate_out = 0; 
       end
       else if (inclk_n == 'b1 && inclk_last_value != inclk_n)
       begin
           gate_count = gate_count + 1;
           if (gate_count == gate_lock_counter)
               gate_out = 1;
       end
       inclk_last_value = inclk_n;
    end

    assign locked = (l_gate_lock_signal == "yes") ? gate_out && locked_tmp : locked_tmp;

    always @(posedge scanread_ipd)
    begin
        scanread_active_edge = $time;
    end

    always @ (scanclk_ipd)
    begin
        if (scanclk_ipd === 1'b0 && scanclk_last_value === 1'b1)
        begin
            // enable scanwrite on falling edge
            scanwrite_enabled <= scanwrite_reg;
        end
        if (scanread_reg === 1'b1)
            gated_scanclk <= scanclk_ipd && scanread_reg;
        else
            gated_scanclk <= 1'b1;
        if (scanclk_ipd === 1'b1 && scanclk_last_value === 1'b0)
        begin
            // register scanread and scanwrite
            scanread_reg <= scanread_ipd;
            scanwrite_reg <= scanwrite_ipd;

            if (got_first_scanclk)
                scanclk_period = $time - scanclk_last_rising_edge;
            else begin
                got_first_scanclk = 1;
            end
            // reset got_first_scanclk on falling edge of scanread_reg
            if (scanread_ipd == 1'b0 && scanread_reg == 1'b1)
            begin
                 got_first_scanclk = 0;
                 got_first_gated_scanclk = 0;
            end

            scanclk_last_rising_edge = $time;
        end
        scanclk_last_value = scanclk_ipd;
    end

    always @(posedge gated_scanclk)
    begin
        if ($time > 0)
        begin
        if (!got_first_gated_scanclk)
        begin
            got_first_gated_scanclk = 1;
//            if ($time - scanread_active_edge < scanclk_period)
//            begin
//                scanread_setup_violation = 1;
//                $display("Warning : SCANREAD must go high at least one cycle before SCANDATA is read in.");
//                $display ("Time: %0t  Instance: %m", $time);
//            end
        end
        for (j = scan_chain_length-1; j >= 1; j = j - 1)
        begin
            scan_data[j] = scan_data[j - 1];
        end
        scan_data[0] <= scandata_ipd;
        end
    end

    assign scandataout_tmp = (l_pll_type == "fast" || l_pll_type == "lvds") ? scan_data[FAST_SCAN_CHAIN-1] : scan_data[GPP_SCAN_CHAIN-1];

    always @(posedge scandone_tmp)
    begin
            if (reconfig_err == 1'b0)
            begin
                $display("NOTE : PLL Reprogramming completed with the following values (Values in parantheses are original values) : ");
                $display ("Time: %0t  Instance: %m", $time);

                $display("               N modulus =   %0d (%0d) ", n_val[0], n_val_old[0]);
                $display("               M modulus =   %0d (%0d) ", m_val[0], m_val_old[0]);
                $display("               M ph_tap =    %0d (%0d) ", m_ph_val, m_ph_val_old);
                if (ss > 0)
                begin
                    $display(" M2 modulus =   %0d (%0d) ", m_val[1], m_val_old[1]);
                    $display(" N2 modulus =   %0d (%0d) ", n_val[1], n_val_old[1]);
                end

                for (i = 0; i < num_output_cntrs; i=i+1)
                begin
                    $display("              C%0d  high = %0d (%0d),       C%0d  low = %0d (%0d),       C%0d  mode = %s (%s),       C%0d  phase tap = %0d (%0d)", i, c_high_val[i], c_high_val_old[i], i, c_low_val_tmp[i], c_low_val_old[i], i, c_mode_val[i], c_mode_val_old[i], i, c_ph_val[i], c_ph_val_old[i]);
                end

                // display Charge pump and loop filter values
                $display ("               Charge Pump Current (uA) =   %0d (%0d) ", cp_curr_val, cp_curr_old);
                $display ("               Loop Filter Capacitor (pF) =   %0d (%0d) ", lfc_val, lfc_old);
                $display ("               Loop Filter Resistor (Kohm) =   %s (%s) ", lfr_val, lfr_old);
            end
            else begin
                $display("Warning : Errors were encountered during PLL reprogramming. Please refer to error/warning messages above.");
                $display ("Time: %0t  Instance: %m", $time);
            end
    end

    always @(scanwrite_enabled)
    begin
        if (scanwrite_enabled === 1'b0 && scanwrite_last_value === 1'b1)
        begin
            // falling edge : deassert scandone
            scandone_tmp <= #(1.5*scanclk_period) 1'b0;
            // reset counter transfer flags
            c0_rising_edge_transfer_done = 0;
            c1_rising_edge_transfer_done = 0;
            c2_rising_edge_transfer_done = 0;
            c3_rising_edge_transfer_done = 0;
            c4_rising_edge_transfer_done = 0;
            c5_rising_edge_transfer_done = 0;
        end
        if (scanwrite_enabled === 1'b1 && scanwrite_last_value !== scanwrite_enabled)
        begin

            $display ("NOTE : PLL Reprogramming initiated ....");
            $display ("Time: %0t  Instance: %m", $time);
            quiet_time = slowest_clk(c_high_val[0]+c_low_val[0], c_mode_val[0],
                                     c_high_val[1]+c_low_val[1], c_mode_val[1],
                                     c_high_val[2]+c_low_val[2], c_mode_val[2],
                                     c_high_val[3]+c_low_val[3], c_mode_val[3],
                                     c_high_val[4]+c_low_val[4], c_mode_val[4],
                                     c_high_val[5]+c_low_val[5], c_mode_val[5],
                                     refclk_period, m_val[0]);

            // get quiet time in terms of scanclk cycles
            my_rem = quiet_time % scanclk_period;
            scanclk_cycles = quiet_time/scanclk_period;
            if (my_rem != 0)
                scanclk_cycles = scanclk_cycles + 1;

//            scandone_tmp <= #(quiet_time) 1'b1;
            scandone_tmp <= #((scanclk_cycles+0.5) * scanclk_period) 1'b1;
            error = 0;
            reconfig_err = 0;
            scanread_setup_violation = 0;

            // make temp. copy of scan_data for processing
            tmp_scan_data = scan_data;

            // save old values
            cp_curr_old = cp_curr_val;
            lfc_old = lfc_val;
            lfr_old = lfr_val;

            // CP
            // Bits 0-3 : all values are legal
            cp_curr_val = charge_pump_curr_arr[scan_data[3:0]];

            // LF Resistance : bits 4-9
            // values from 010000 - 010111, 100000 - 100111, 
            //             110000- 110111 are illegal
               if (((tmp_scan_data[9:4] >= 6'b010000) && (tmp_scan_data[9:4] <= 6'b010111)) || 
                   ((tmp_scan_data[9:4] >= 6'b100000) && (tmp_scan_data[9:4] <= 6'b100111)) ||
                   ((tmp_scan_data[9:4] >= 6'b110000) && (tmp_scan_data[9:4] <= 6'b110111)))
               begin
                   $display ("Illegal bit settings for Loop Filter Resistance. Legal bit values range from 000000 to 001111, 011000 to 011111, 101000 to 101111 and 111000 to 111111. Reconfiguration may not work.");
                   reconfig_err = 1;
               end
               else begin
                  i = scan_data[9:4];
                  if (i >= 56 )
                      i = i - 24;
                  else if ((i >= 40) && (i <= 47))
                      i = i - 16;
                  else if ((i >= 24) && (i <= 31))
                      i = i - 8;
                  lfr_val = loop_filter_r_arr[i];
               end

            // LF Capacitance : bits 10,11 : all values are legal
            if ((l_pll_type == "fast") || (l_pll_type == "lvds"))
                lfc_val = fpll_loop_filter_c_arr[scan_data[11:10]];
            else
                lfc_val = loop_filter_c_arr[scan_data[11:10]];

            // save old values for display info.
            for (i=0; i<=1; i=i+1)
            begin
                m_val_old[i] = m_val[i];
                n_val_old[i] = n_val[i];
                m_mode_val_old[i] = m_mode_val[i];
                n_mode_val_old[i] = n_mode_val[i];
            end
            m_ph_val_old = m_ph_val;
            for (i=0; i<=5; i=i+1)
            begin
                c_high_val_old[i] = c_high_val[i];
                c_low_val_old[i] = c_low_val[i];
                c_ph_val_old[i] = c_ph_val[i];
                c_mode_val_old[i] = c_mode_val[i];
            end

            // first the M counter phase : bit order same for fast and GPP
            if (scan_data[12] == 1'b0)
            begin
                // do nothing
            end
            else if (scan_data[12] === 1'b1 && scan_data[13] === 1'b1)
            begin
                m_ph_val_tmp = m_ph_val_tmp + 1;
                if (m_ph_val_tmp > 7)
                    m_ph_val_tmp = 0;
            end
            else if (scan_data[12] === 1'b1 && scan_data[13] === 1'b0)
            begin
                m_ph_val_tmp = m_ph_val_tmp - 1;
                if (m_ph_val_tmp < 0)
                    m_ph_val_tmp = 7;
            end
            else begin
                $display ("Warning : Illegal bit settings for M counter phase tap. Reconfiguration may not work.");
                reconfig_err = 1;
            end

            // read the fast PLL bits.
            if (l_pll_type == "fast" || l_pll_type == "lvds")
            begin
                // C3-C0 phase bits
                for (i = 3; i >= 0; i=i-1)
                begin
                    if (tmp_scan_data[14] == 1'b0)
                    begin
                        // do nothing
                    end
                    else if (tmp_scan_data[14] === 1'b1)
                    begin
                        if (tmp_scan_data[15] === 1'b1)
                        begin
                            c_ph_val_tmp[i] = c_ph_val_tmp[i] + 1;
                            if (c_ph_val_tmp[i] > 7)
                                c_ph_val_tmp[i] = 0;
                        end
                        else if (tmp_scan_data[15] === 1'b0)
                        begin
                            c_ph_val_tmp[i] = c_ph_val_tmp[i] - 1;
                            if (c_ph_val_tmp[i] < 0)
                                c_ph_val_tmp[i] = 7;
                        end
                    end
                    tmp_scan_data = tmp_scan_data >> 2;
                end
                // C0-C3 counter moduli
                tmp_scan_data = scan_data;
                for (i = 0; i < 4; i=i+1)
                begin
                    if (tmp_scan_data[26] == 1'b1)
                    begin
                        c_mode_val_tmp[i] = "bypass";
                        if (tmp_scan_data[31] === 1'b1)
                        begin
                            c_mode_val_tmp[i] = "   off";
                            $display("Warning : The specified bit settings will turn OFF the C%0d counter. It cannot be turned on unless the part is re-initialized.", i);
                        end
                    end
                    else if (tmp_scan_data[31] == 1'b1)
                        c_mode_val_tmp[i] = "   odd";
                    else
                        c_mode_val_tmp[i] = "  even";
                    if (tmp_scan_data[25:22] === 4'b0000)
                        c_high_val_tmp[i] = 5'b10000;
                    else
                        c_high_val_tmp[i] = tmp_scan_data[25:22];
                    if (tmp_scan_data[30:27] === 4'b0000)
                        c_low_val_tmp[i] = 5'b10000;
                    else
                        c_low_val_tmp[i] = tmp_scan_data[30:27];

                    tmp_scan_data = tmp_scan_data >> 10;
                end
                // M
                error = 0;
                // some temporary storage
                m_hi = scan_data[65:62];
                m_lo = scan_data[70:67];
                m_val_tmp[0] = m_hi + m_lo;
                if (scan_data[66] === 1'b1)
                begin
                    if (scan_data[71] === 1'b1)
                    begin
                        // this will turn off the M counter : error
                        reconfig_err = 1;
                        error = 1;
                        $display ("The specified bit settings will turn OFF the M counter. This is illegal. Reconfiguration may not work.");
                    end
                    else begin
                        // M counter is being bypassed
                        if (m_mode_val[0] !== "bypass")
                        begin
                            // Mode is switched : give warning
                            d_msg = display_msg(" M", 4);
                        end
                        m_val_tmp[0] = 32'b1;
                        m_mode_val[0] = "bypass";
                    end
                end
                else begin
                    if (m_mode_val[0] === "bypass")
                    begin
                        // Mode is switched : give warning
                        d_msg = display_msg(" M", 1);
                    end
                    m_mode_val[0] = "";
                    if (scan_data[71] === 1'b1)
                    begin
                        // odd : check for duty cycle, if not 50% -- error
                        if (m_hi - m_lo !== 1)
                        begin
                            reconfig_err = 1;
                            $display ("Warning : The M counter of the StratixII Fast PLL should be configured for 50%% duty cycle only. In this case the HIGH and LOW moduli programmed will result in a duty cycle other than 50%%, which is illegal. Reconfiguration may not work");
                        end
                    end
                    else begin // even mode
                        if (m_hi !== m_lo)
                        begin
                            reconfig_err = 1;
                            $display ("Warning : The M counter of the StratixII Fast PLL should be configured for 50%% duty cycle only. In this case the HIGH and LOW moduli programmed will result in a duty cycle other than 50%%, which is illegal. Reconfiguration may not work");
                        end
                    end
                end

                // N
                error = 0;
                n_val[0] = scan_data[73:72];
                if (scan_data[74] !== 1'b1)
                begin
                    if (scan_data[73:72] == 2'b01)
                    begin
                        reconfig_err = 1;
                        error = 1;
                        // Cntr value is illegal : give warning
                        d_msg = display_msg(" N", 2);
                    end
                    else if (scan_data[73:72] == 2'b00)
                        n_val[0] = 3'b100;
                    if (error == 1'b0)
                    begin
                        if (n_mode_val[0] === "bypass")
                        begin
                            // Mode is switched : give warning
                            d_msg = display_msg(" N", 1);
                        end
                        n_mode_val[0] = "";
                    end
                end
                else if (scan_data[74] == 1'b1)     // bypass
                begin
                    if (scan_data[72] !== 1'b0)
                    begin
                        reconfig_err = 1;
                        error = 1;
                        // Cntr value is illegal : give warning
                        d_msg = display_msg(" N", 3);
                    end
                    else begin
                        if (n_mode_val[0] != "bypass")
                        begin
                            // Mode is switched : give warning
                            d_msg = display_msg(" N", 4);
                        end
                        n_val[0] = 2'b01;
                        n_mode_val[0] = "bypass";
                    end
                end
            end
            else begin      // pll type is auto or enhanced
                for (i = 0; i < 6; i=i+1)
                begin
                    if (tmp_scan_data[124] == 1'b1)
                    begin
                        c_mode_val_tmp[i] = "bypass";
                        if (tmp_scan_data[133] === 1'b1)
                        begin
                            c_mode_val_tmp[i] = "   off";
                            $display("Warning : The specified bit settings will turn OFF the C%0d counter. It cannot be turned on unless the part is re-initialized.", i);
                        end
                    end
                    else if (tmp_scan_data[133] == 1'b1)
                        c_mode_val_tmp[i] = "   odd";
                    else
                        c_mode_val_tmp[i] = "  even";
                    if (tmp_scan_data[123:116] === 8'b00000000)
                        c_high_val_tmp[i] = 9'b100000000;
                    else
                        c_high_val_tmp[i] = tmp_scan_data[123:116];
                    if (tmp_scan_data[132:125] === 8'b00000000)
                        c_low_val_tmp[i] = 9'b100000000;
                    else
                        c_low_val_tmp[i] = tmp_scan_data[132:125];

                    tmp_scan_data = tmp_scan_data << 18;
                end

                // the phase_taps
                tmp_scan_data = scan_data;
                for (i = 0; i < 6; i=i+1)
                begin
                    if (tmp_scan_data[14] == 1'b0)
                    begin
                        // do nothing
                    end
                    else if (tmp_scan_data[14] === 1'b1)
                    begin
                        if (tmp_scan_data[15] === 1'b1)
                        begin
                            c_ph_val_tmp[i] = c_ph_val_tmp[i] + 1;
                            if (c_ph_val_tmp[i] > 7)
                                c_ph_val_tmp[i] = 0;
                        end
                        else if (tmp_scan_data[15] === 1'b0)
                        begin
                            c_ph_val_tmp[i] = c_ph_val_tmp[i] - 1;
                            if (c_ph_val_tmp[i] < 0)
                                c_ph_val_tmp[i] = 7;
                        end
                    end
                    tmp_scan_data = tmp_scan_data >> 2;
                end
                ext_fbk_cntr_high = c_high_val[ext_fbk_cntr_index];
                ext_fbk_cntr_low = c_low_val[ext_fbk_cntr_index];
                ext_fbk_cntr_ph = c_ph_val[ext_fbk_cntr_index];
                ext_fbk_cntr_mode = c_mode_val[ext_fbk_cntr_index];

                // cntrs M/M2
                tmp_scan_data = scan_data;
                for (i=0; i<2; i=i+1)
                begin
                    if (i == 0 || (i == 1 && ss > 0))
                    begin
                        error = 0;
                        m_val_tmp[i] = tmp_scan_data[142:134];
                        if (tmp_scan_data[143] !== 1'b1)
                        begin
                            if (tmp_scan_data[142:134] == 9'b000000001)
                            begin
                                reconfig_err = 1;
                                error = 1;
                                // Cntr value is illegal : give warning
                                if (i == 0)
                                    d_msg = display_msg(" M", 2);
                                else
                                    d_msg = display_msg("M2", 2);
                            end
                            else if (tmp_scan_data[142:134] == 9'b000000000)
                                m_val_tmp[i] = 10'b1000000000;
                            if (error == 1'b0)
                            begin
                                if (m_mode_val[i] === "bypass")
                                begin
                                    // Mode is switched : give warning
                                    if (i == 0)
                                        d_msg = display_msg(" M", 1);
                                    else
                                        d_msg = display_msg("M2", 1);
                                end
                                m_mode_val[i] = "";
                            end
                        end
                        else if (tmp_scan_data[143] == 1'b1)
                        begin
                            if (tmp_scan_data[134] !== 1'b0)
                            begin
                                reconfig_err = 1;
                                error = 1;
                                // Cntr value is illegal : give warning
                                if (i == 0)
                                    d_msg = display_msg(" M", 3);
                                else
                                    d_msg = display_msg("M2", 3);
                            end
                            else begin
                                if (m_mode_val[i] !== "bypass")
                                begin
                                    // Mode is switched: give warning
                                    if (i == 0)
                                        d_msg = display_msg(" M", 4);
                                    else
                                        d_msg = display_msg("M2", 4);
                                end
                                m_val_tmp[i] = 10'b0000000001;
                                m_mode_val[i] = "bypass";
                            end
                        end
                    end
                    tmp_scan_data = tmp_scan_data >> 10;
                end
                if (ss > 0)
                begin
                    if (m_mode_val[0] != m_mode_val[1])
                    begin
                        reconfig_err = 1;
                        error = 1;
                        $display ("Warning : Incompatible modes for M/M2 counters. Either both should be BYASSED or both NON-BYPASSED. Reconfiguration may not work.");
                    end
                end

                // cntrs N/N2
                tmp_scan_data = scan_data;
                for (i=0; i<2; i=i+1)
                begin
                    if (i == 0 || (i == 1 && ss > 0))
                    begin
                        error = 0;
                        n_val[i] = tmp_scan_data[162:154];
                        if (tmp_scan_data[163] !== 1'b1)
                        begin
                            if (tmp_scan_data[162:154] == 9'b000000001)
                            begin
                                reconfig_err = 1;
                                error = 1;
                                // Cntr value is illegal : give warning
                                if (i == 0)
                                    d_msg = display_msg(" N", 2);
                                else
                                    d_msg = display_msg("N2", 2);
                            end
                            else if (tmp_scan_data[162:154] == 9'b000000000)
                                n_val[i] = 10'b1000000000;
                            if (error == 1'b0)
                            begin
                                if (n_mode_val[i] === "bypass")
                                begin
                                    // Mode is switched : give warning
                                    if (i == 0)
                                        d_msg = display_msg(" N", 1);
                                    else
                                        d_msg = display_msg("N2", 1);
                                end
                                n_mode_val[i] = "";
                            end
                        end
                        else if (tmp_scan_data[163] == 1'b1)     // bypass
                        begin
                            if (tmp_scan_data[154] !== 1'b0)
                            begin
                                reconfig_err = 1;
                                error = 1;
                                // Cntr value is illegal : give warning
                                if (i == 0)
                                    d_msg = display_msg(" N", 3);
                                else
                                    d_msg = display_msg("N2", 3);
                            end
                            else begin
                                if (n_mode_val[i] != "bypass")
                                begin
                                    // Mode is switched : give warning
                                    if (i == 0)
                                        d_msg = display_msg(" N", 4);
                                    else
                                        d_msg = display_msg("N2", 4);
                                end
                                n_val[i] = 10'b0000000001;
                                n_mode_val[i] = "bypass";
                            end
                        end
                    end
                    tmp_scan_data = tmp_scan_data >> 10;
                end
                if (ss > 0)
                begin
                    if (n_mode_val[0] != n_mode_val[1])
                    begin
                        reconfig_err = 1;
                        error = 1;
                        $display ("Warning : Incompatible modes for N/N2 counters. Either both should be BYASSED or both NON-BYPASSED. Reconfiguration may not work.");
                    end
                end
            end
        end
        scanwrite_last_value = scanwrite_enabled;
    end

    always @(schedule_vco or areset_ipd or ena_ipd)
    begin
        sched_time = 0;
    
        for (i = 0; i <= 7; i=i+1)
            last_phase_shift[i] = phase_shift[i];
     
        cycle_to_adjust = 0;
        l_index = 1;
        m_times_vco_period = new_m_times_vco_period;
    
        // give appropriate messages
        // if areset was asserted
        if (areset_ipd == 1'b1 && areset_ipd_last_value !== areset_ipd)
        begin
            $display (" Note : PLL was reset");
            $display ("Time: %0t  Instance: %m", $time);
        end
    
        // if ena was deasserted
        if (ena_ipd == 1'b0 && ena_ipd_last_value !== ena_ipd)
        begin
            $display (" Note : PLL was disabled");
            $display ("Time: %0t  Instance: %m", $time);
        end
    
        // illegal value on areset_ipd
        if (areset_ipd === 1'bx && (areset_ipd_last_value === 1'b0 || areset_ipd_last_value === 1'b1))
        begin
            $display("Warning : Illegal value 'X' detected on ARESET input");
            $display ("Time: %0t  Instance: %m", $time);
        end
    
       if ((schedule_vco !== schedule_vco_last_value) && (areset_ipd == 1'b1 || ena_ipd == 1'b0 || stop_vco == 1'b1))
       begin
    
          // drop VCO taps to 0
          for (i = 0; i <= 7; i=i+1)
          begin
              for (j = 0; j <= last_phase_shift[i] + 1; j=j+1)
                  vco_out[i] <= #(j) 1'b0;
              phase_shift[i] = 0;
              last_phase_shift[i] = 0;
          end
    
          // reset lock parameters
          locked_tmp = 0;
          pll_is_locked = 0;
          pll_about_to_lock = 0;
          cycles_to_lock = 0;
          cycles_to_unlock = 0;
    
          got_first_refclk = 0;
          got_second_refclk = 0;
          refclk_time = 0;
          got_first_fbclk = 0;
          fbclk_time = 0;
          first_fbclk_time = 0;
          fbclk_period = 0;
    
          first_schedule = 1;
          vco_val = 0;
          vco_period_was_phase_adjusted = 0;
          phase_adjust_was_scheduled = 0;

          // reset all counter phase tap values to POF programmed values
          m_ph_val = m_ph_val_orig;
          for (i=0; i<= 5; i=i+1)
              c_ph_val[i] = c_ph_val_orig[i];
    
       end else if (ena_ipd === 1'b1 && areset_ipd === 1'b0 && stop_vco === 1'b0)
       begin
           // else note areset deassert time
           // note it as refclk_time to prevent false triggering
           // of stop_vco after areset
           if (areset_ipd === 1'b0 && areset_ipd_last_value === 1'b1)
           begin
               refclk_time = $time;
           end
    
          // calculate loop_xplier : this will be different from m_val in ext. fbk mode
          loop_xplier = m_val[0];
          loop_initial = i_m_initial - 1;
          loop_ph = m_ph_val;
    
          if (l_operation_mode == "external_feedback")
          begin
              if (ext_fbk_cntr_mode == "bypass")
                  ext_fbk_cntr_modulus = 1;
              else
                  ext_fbk_cntr_modulus = ext_fbk_cntr_high + ext_fbk_cntr_low;

              loop_xplier = m_val[0] * (ext_fbk_cntr_modulus);
              loop_ph = ext_fbk_cntr_ph;
              loop_initial = ext_fbk_cntr_initial - 1 + ((i_m_initial - 1) * ext_fbk_cntr_modulus);
          end
    
          // convert initial value to delay
          initial_delay = (loop_initial * m_times_vco_period)/loop_xplier;
    
          // convert loop ph_tap to delay
          rem = m_times_vco_period % loop_xplier;
          vco_per = m_times_vco_period/loop_xplier;
          if (rem != 0)
              vco_per = vco_per + 1;
          fbk_phase = (loop_ph * vco_per)/8;
    
          if (l_operation_mode == "external_feedback")
          begin
              pull_back_M = (i_m_initial - 1) * (ext_fbk_cntr_modulus) * (m_times_vco_period/loop_xplier);
    
              while (pull_back_M > refclk_period)
                  pull_back_M = pull_back_M - refclk_period;
          end
          else begin
              pull_back_M = initial_delay + fbk_phase;
          end
    
          total_pull_back = pull_back_M;
          if (l_simulation_type == "timing")
              total_pull_back = total_pull_back + pll_compensation_delay;
    
          while (total_pull_back > refclk_period)
              total_pull_back = total_pull_back - refclk_period;
    
          if (total_pull_back > 0)
              offset = refclk_period - total_pull_back;
          else
              offset = 0;
    
          if (l_operation_mode == "external_feedback")
          begin
              fbk_delay = pull_back_M;
              if (l_simulation_type == "timing")
                  fbk_delay = fbk_delay + pll_compensation_delay;
          end
          else begin
              fbk_delay = total_pull_back - fbk_phase;
              if (fbk_delay < 0)
              begin
                  offset = offset - fbk_phase;
                  fbk_delay = total_pull_back;
              end
          end
    
          // assign m_delay
          m_delay = fbk_delay;
    
          for (i = 1; i <= loop_xplier; i=i+1)
          begin
              // adjust cycles
              tmp_vco_per = m_times_vco_period/loop_xplier;
              if (rem != 0 && l_index <= rem)
              begin
                  tmp_rem = (loop_xplier * l_index) % rem;
                  cycle_to_adjust = (loop_xplier * l_index) / rem;
                  if (tmp_rem != 0)
                      cycle_to_adjust = cycle_to_adjust + 1;
              end
              if (cycle_to_adjust == i)
              begin
                  tmp_vco_per = tmp_vco_per + 1;
                  l_index = l_index + 1;
              end
    
              // calculate high and low periods
              high_time = tmp_vco_per/2;
              if (tmp_vco_per % 2 != 0)
                  high_time = high_time + 1;
              low_time = tmp_vco_per - high_time;
    
              // schedule the rising and falling egdes
              for (j=0; j<=1; j=j+1)
              begin
                  vco_val = ~vco_val;
                  if (vco_val == 1'b0)
                      sched_time = sched_time + high_time;
                  else
                      sched_time = sched_time + low_time;
    
                  // schedule taps with appropriate phase shifts
                  for (k = 0; k <= 7; k=k+1)
                  begin
                      phase_shift[k] = (k*tmp_vco_per)/8;
                      if (first_schedule)
                          vco_out[k] <= #(sched_time + phase_shift[k]) vco_val;
                      else
                          vco_out[k] <= #(sched_time + last_phase_shift[k]) vco_val;
                  end
              end
          end
          if (first_schedule)
          begin
              vco_val = ~vco_val;
              if (vco_val == 1'b0)
                  sched_time = sched_time + high_time;
              else
                  sched_time = sched_time + low_time;
              for (k = 0; k <= 7; k=k+1)
              begin
                  phase_shift[k] = (k*tmp_vco_per)/8;
                  vco_out[k] <= #(sched_time+phase_shift[k]) vco_val;
              end
              first_schedule = 0;
          end

          schedule_vco <= #(sched_time) ~schedule_vco;
          if (vco_period_was_phase_adjusted)
          begin
              m_times_vco_period = refclk_period;
              new_m_times_vco_period = refclk_period;
              vco_period_was_phase_adjusted = 0;
              phase_adjust_was_scheduled = 1;
    
              tmp_vco_per = m_times_vco_period/loop_xplier;
              for (k = 0; k <= 7; k=k+1)
                  phase_shift[k] = (k*tmp_vco_per)/8;
          end
       end
    
       areset_ipd_last_value = areset_ipd;
       ena_ipd_last_value = ena_ipd;
       schedule_vco_last_value = schedule_vco;
    
    end

    always @(pfdena_ipd)
    begin
        if (pfdena_ipd === 1'b0)
        begin
            if (pll_is_locked)
                locked_tmp = 1'bx;
            pll_is_locked = 0;
            cycles_to_lock = 0;
            $display (" Note : PFDENA was deasserted");
            $display ("Time: %0t  Instance: %m", $time);
        end
        else if (pfdena_ipd === 1'b1 && pfdena_ipd_last_value === 1'b0)
        begin
            // PFD was disabled, now enabled again
           got_first_refclk = 0;
           got_second_refclk = 0;
           refclk_time = $time;
        end
        pfdena_ipd_last_value = pfdena_ipd;
    end

    always @(negedge refclk or negedge fbclk)
    begin
        refclk_last_value = refclk;
        fbclk_last_value = fbclk;
    end

    always @(posedge refclk or posedge fbclk)
    begin
        if (refclk == 1'b1 && refclk_last_value !== refclk && areset_ipd === 1'b0)
        begin
           if (! got_first_refclk)
           begin
              got_first_refclk = 1;
           end else
           begin
              got_second_refclk = 1;
              refclk_period = $time - refclk_time;

              // check if incoming freq. will cause VCO range to be
              // exceeded
              if ( (vco_max != 0 && vco_min != 0) && (pfdena_ipd === 1'b1) &&
                   ((refclk_period/loop_xplier > vco_max) ||
                   (refclk_period/loop_xplier < vco_min)) )
              begin
                  if (pll_is_locked == 1'b1)
                  begin
                      $display ("Warning : Input clock freq. is not within VCO range. PLL may lose lock");
                      $display ("Time: %0t  Instance: %m", $time);
                      if (inclk_out_of_range === 1'b1)
                      begin
                          // unlock
                          pll_is_locked = 0;
                          locked_tmp = 0;
                          pll_about_to_lock = 0;
                          cycles_to_lock = 0;
                          $display ("Note : PLL lost lock");
                          $display ("Time: %0t  Instance: %m", $time);
                          vco_period_was_phase_adjusted = 0;
                          phase_adjust_was_scheduled = 0;
                      end
                  end
                  else begin
                      $display ("Warning : Input clock freq. is not within VCO range. PLL may not lock");
                      $display ("Time: %0t  Instance: %m", $time);
                  end
                  inclk_out_of_range = 1;
              end
              else begin
                  inclk_out_of_range = 0;
              end

           end
           if (stop_vco == 1'b1)
           begin
              stop_vco = 0;
              schedule_vco = ~schedule_vco;
           end
           refclk_time = $time;
        end

        if (fbclk == 1'b1 && fbclk_last_value !== fbclk)
        begin
            if (scanwrite_enabled === 1'b1)
            begin
                m_val[0] <= m_val_tmp[0];
                m_val[1] <= m_val_tmp[1];
            end
           if (!got_first_fbclk)
           begin
              got_first_fbclk = 1;
              first_fbclk_time = $time;
           end
           else
              fbclk_period = $time - fbclk_time;

           // need refclk_period here, so initialized to proper value above
           if ( ($time - refclk_time > 1.5 * refclk_period) && pfdena_ipd === 1'b1)
           begin
               stop_vco = 1;
               // reset
               got_first_refclk = 0;
               got_first_fbclk = 0;
               got_second_refclk = 0;
               if (pll_is_locked == 1'b1)
               begin
                  pll_is_locked = 0;
                  locked_tmp = 0;
                  $display ("Note : PLL lost lock due to loss of input clock");
                  $display ("Time: %0t  Instance: %m", $time);
               end
               pll_about_to_lock = 0;
               cycles_to_lock = 0;
               cycles_to_unlock = 0;
               first_schedule = 1;
           end
           fbclk_time = $time;
        end

        if (got_second_refclk && pfdena_ipd === 1'b1 && (!inclk_out_of_range))
        begin
           // now we know actual incoming period
           if (abs(fbclk_time - refclk_time) <= 5 || (got_first_fbclk && abs(refclk_period - abs(fbclk_time - refclk_time)) <= 5))
           begin
                // considered in phase
               if (cycles_to_lock == valid_lock_multiplier - 1)
                  pll_about_to_lock <= 1;
               if (cycles_to_lock == valid_lock_multiplier)
               begin
                  if (pll_is_locked === 1'b0)
                  begin
                      $display (" Note : PLL locked to incoming clock");
                      $display ("Time: %0t  Instance: %m", $time);
                  end
                  pll_is_locked = 1;
                  locked_tmp = 1;
                  cycles_to_unlock = 0;
               end
               // increment lock counter only if the second part of the above
               // time check is not true
               if (!(abs(refclk_period - abs(fbclk_time - refclk_time)) <= 5))
               begin
                   cycles_to_lock = cycles_to_lock + 1;
               end

               // adjust m_times_vco_period
               new_m_times_vco_period = refclk_period;

           end else
           begin
               // if locked, begin unlock
               if (pll_is_locked)
               begin
                   cycles_to_unlock = cycles_to_unlock + 1;
                   if (cycles_to_unlock == invalid_lock_multiplier)
                   begin
                       pll_is_locked = 0;
                       locked_tmp = 0;
                       pll_about_to_lock = 0;
                       cycles_to_lock = 0;
                       $display ("Note : PLL lost lock");
                       $display ("Time: %0t  Instance: %m", $time);
                       vco_period_was_phase_adjusted = 0;
                       phase_adjust_was_scheduled = 0;
                   end
               end
               if (abs(refclk_period - fbclk_period) <= 2)
               begin
                   // frequency is still good
                   if ($time == fbclk_time && (!phase_adjust_was_scheduled))
                   begin
                       if (abs(fbclk_time - refclk_time) > refclk_period/2)
                       begin
                           new_m_times_vco_period = m_times_vco_period + (refclk_period - abs(fbclk_time - refclk_time));
                           vco_period_was_phase_adjusted = 1;
                       end else
                       begin
                           new_m_times_vco_period = m_times_vco_period - abs(fbclk_time - refclk_time);
                           vco_period_was_phase_adjusted = 1;
                       end
                   end
               end else
               begin
                   new_m_times_vco_period = refclk_period;
                   phase_adjust_was_scheduled = 0;
               end
           end
        end

        if (reconfig_err == 1'b1)
        begin
            locked_tmp = 0;
        end

        refclk_last_value = refclk;
        fbclk_last_value = fbclk;
    end

    assign clk0_tmp = i_clk0_counter == "c0" ? c0_clk : i_clk0_counter == "c1" ? c1_clk : i_clk0_counter == "c2" ? c2_clk : i_clk0_counter == "c3" ? c3_clk : i_clk0_counter == "c4" ? c4_clk : i_clk0_counter == "c5" ? c5_clk : 'b0;

    assign clk0 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !reconfig_err) ? clk0_tmp : 'bx;


    assign clk1_tmp = i_clk1_counter == "c0" ? c0_clk : i_clk1_counter == "c1" ? c1_clk : i_clk1_counter == "c2" ? c2_clk : i_clk1_counter == "c3" ? c3_clk : i_clk1_counter == "c4" ? c4_clk : i_clk1_counter == "c5" ? c5_clk : 'b0;

    assign clk1 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !reconfig_err) ? clk1_tmp : 'bx;


    assign clk2_tmp = i_clk2_counter == "c0" ? c0_clk : i_clk2_counter == "c1" ? c1_clk : i_clk2_counter == "c2" ? c2_clk : i_clk2_counter == "c3" ? c3_clk : i_clk2_counter == "c4" ? c4_clk : i_clk2_counter == "c5" ? c5_clk : 'b0;

    assign clk2 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !reconfig_err) ? clk2_tmp : 'bx;


    assign clk3_tmp = i_clk3_counter == "c0" ? c0_clk : i_clk3_counter == "c1" ? c1_clk : i_clk3_counter == "c2" ? c2_clk : i_clk3_counter == "c3" ? c3_clk : i_clk3_counter == "c4" ? c4_clk : i_clk3_counter == "c5" ? c5_clk : 'b0;

    assign clk3 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !reconfig_err) ? clk3_tmp : 'bx;


    assign clk4_tmp = i_clk4_counter == "c0" ? c0_clk : i_clk4_counter == "c1" ? c1_clk : i_clk4_counter == "c2" ? c2_clk : i_clk4_counter == "c3" ? c3_clk : i_clk4_counter == "c4" ? c4_clk : i_clk4_counter == "c5" ? c5_clk : 'b0;

    assign clk4 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !reconfig_err) ? clk4_tmp : 'bx;


    assign clk5_tmp = i_clk5_counter == "c0" ? c0_clk : i_clk5_counter == "c1" ? c1_clk : i_clk5_counter == "c2" ? c2_clk : i_clk5_counter == "c3" ? c3_clk : i_clk5_counter == "c4" ? c4_clk : i_clk5_counter == "c5" ? c5_clk : 'b0;

    assign clk5 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !reconfig_err) ? clk5_tmp : 'bx;

    assign sclkout0 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !reconfig_err) ? sclkout0_tmp : 1'bx;

    assign sclkout1 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !reconfig_err) ? sclkout1_tmp : 1'bx;

    assign enable_0 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || pll_about_to_lock == 1'b1 ? enable0_tmp : 'bx;
    assign enable_1 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || pll_about_to_lock == 1'b1 ? enable1_tmp : 'bx;

    // ACCELERATE OUTPUTS
    and (clk[0], 1'b1, clk0);
    and (clk[1], 1'b1, clk1);
    and (clk[2], 1'b1, clk2);
    and (clk[3], 1'b1, clk3);
    and (clk[4], 1'b1, clk4);
    and (clk[5], 1'b1, clk5);

    and (sclkout[0], 1'b1, sclkout0);
    and (sclkout[1], 1'b1, sclkout1);

    and (enable0, 1'b1, enable_0);
    and (enable1, 1'b1, enable_1);

    and (scandataout, 1'b1, scandataout_tmp);
    and (scandone, 1'b1, scandone_tmp);

endmodule

///////////////////////////////////////////////////////////////////////////////
//
//                              STRATIXII_MAC_SIGN_REGISTER
//
// single bit register
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixii_mac_bit_register 
  (
   data, 
   clk, 
   aclr,
   if_aclr,
   ena, 
   async, 
   dataout
   );
   
   parameter data_width = 1;
   parameter power_up = 1'b0;
      
   input        data;
   input 	clk;
   input 	aclr; 
   input 	ena;
   input 	async;
   input 	if_aclr;
   output       dataout;

   tri0          data;
   tri0 	 clk;
   tri0 	 aclr;
   tri0 	 ena;
   
   wire  	 data_ipd;
   wire 	 clk_ipd;
   wire 	 aclr_ipd;
   wire 	 ena_ipd;
   wire  	 dataout_tbuf;
   wire  	 dataout_tmp;
   reg  	 dataout_reg;
   reg  	 dataout_reg_c;
   reg 		 viol_notifier; 
   
   assign dataout_tbuf = dataout_tmp;
      
   buf data_buf0(data_ipd, data);

   buf dataout_buf0(dataout, dataout_tbuf);

   buf (clk_ipd, clk);
   buf (aclr_ipd, aclr);
   buf (ena_ipd, ena);
   
   initial 
     begin
	if(power_up)
	  begin
	     dataout_reg = ~(1'b0);
	     dataout_reg_c = ~(1'b0);
	  end
	else
	  begin
	     dataout_reg = 'b0;
	     dataout_reg_c = 'b0;
	  end
     end
   
   specify
      
      specparam TSU = 0;        // Set up time 
      specparam TH  = 0;        // Hold time
      specparam TCO = 0;        // Clock to Output time
      specparam TCLR = 0;       // Clear time
      specparam TCLR_MIN_PW = 0;// Minimum pulse width of clear
      specparam TPRE = 0; 	// Preset time
      specparam TPRE_MIN_PW = 0;// Minimum pulse width of preset
      specparam TCLK_MIN_PW = 0;// Minimum pulse width of clock
      specparam TCE_MIN_PW = 0; // Minimum pulse width of clock enable
      specparam TCLKL = 0; 	// Minimum clock low time
      specparam TCLKH = 0; 	// Minimum clock high time
      
      $setup  (data, posedge clk, 0, viol_notifier);
      $hold   (posedge clk, data, 0, viol_notifier);
      $setup  (ena, posedge clk, 0, viol_notifier );
      $hold   (posedge clk, ena, 0, viol_notifier );
      
      (posedge aclr => (dataout  +: 'b0)) = (0,0);
      (posedge clk  => (dataout  +: dataout_tmp)) = (0,0); 
      
   endspecify

   // ACLR
   always @(posedge clk_ipd or posedge aclr_ipd)
     begin
	if (aclr_ipd == 1'b1)
	  dataout_reg_c <= 'b0;
	else if (ena_ipd == 1'b1) 
	  dataout_reg_c <= data_ipd;
	else 
	  dataout_reg_c <= dataout_reg_c;
     end

   // !ACLR
   always @(posedge clk_ipd)
     begin
	if (ena_ipd == 1'b1) 
	  dataout_reg <= data_ipd;
	else 
	  dataout_reg <= dataout_reg;
     end

   assign dataout_tmp = (async ? data_ipd : (if_aclr ? dataout_reg_c : dataout_reg));

endmodule 

///////////////////////////////////////////////////////////////////////////////
//
//                              STRATIXII_MAC_REGISTER
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixii_mac_register 
  (
   data, 
   clk, 
   aclr,
   if_aclr,
   ena, 
   async, 
   dataout
   );
   
   parameter data_width = 18;
   parameter power_up = 1'b0;
      
   input [71:0] data;
   input 	clk;
   input 	aclr; 
   input 	ena;
   input 	async;
   input 	if_aclr;
   output [71:0] dataout;

   tri0[71:0] 	 data;
   tri0 	 clk;
   tri0 	 aclr;
   tri0 	 ena;
   
   wire [71:0] 	 data_ipd;
   wire 	 clk_ipd;
   wire 	 aclr_ipd;
   wire 	 ena_ipd;
   wire [71:0] 	 dataout_tbuf;
   wire [71:0] 	 dataout_tmp;
   reg [71:0] 	 dataout_reg;
   reg [71:0] 	 dataout_reg_c;
   reg 		 viol_notifier; 
   
   assign dataout_tbuf = dataout_tmp;
      
   buf data_buf0(data_ipd[0], data[0]);
   buf data_buf1(data_ipd[1], data[1]);
   buf data_buf2(data_ipd[2], data[2]);
   buf data_buf3(data_ipd[3], data[3]);
   buf data_buf4(data_ipd[4], data[4]);
   buf data_buf5(data_ipd[5], data[5]);
   buf data_buf6(data_ipd[6], data[6]);
   buf data_buf7(data_ipd[7], data[7]);
   buf data_buf8(data_ipd[8], data[8]);
   buf data_buf9(data_ipd[9], data[9]);
   buf data_buf10(data_ipd[10], data[10]);
   buf data_buf11(data_ipd[11], data[11]);
   buf data_buf12(data_ipd[12], data[12]);
   buf data_buf13(data_ipd[13], data[13]);
   buf data_buf14(data_ipd[14], data[14]);
   buf data_buf15(data_ipd[15], data[15]);
   buf data_buf16(data_ipd[16], data[16]);
   buf data_buf17(data_ipd[17], data[17]);
   buf data_buf18(data_ipd[18], data[18]);
   buf data_buf19(data_ipd[19], data[19]);
   buf data_buf20(data_ipd[20], data[20]);
   buf data_buf21(data_ipd[21], data[21]);
   buf data_buf22(data_ipd[22], data[22]);
   buf data_buf23(data_ipd[23], data[23]);
   buf data_buf24(data_ipd[24], data[24]);
   buf data_buf25(data_ipd[25], data[25]);
   buf data_buf26(data_ipd[26], data[26]);
   buf data_buf27(data_ipd[27], data[27]);
   buf data_buf28(data_ipd[28], data[28]);
   buf data_buf29(data_ipd[29], data[29]);
   buf data_buf30(data_ipd[30], data[30]);
   buf data_buf31(data_ipd[31], data[31]);
   buf data_buf32(data_ipd[32], data[32]);
   buf data_buf33(data_ipd[33], data[33]);
   buf data_buf34(data_ipd[34], data[34]);
   buf data_buf35(data_ipd[35], data[35]);
   buf data_buf36(data_ipd[36], data[36]);
   buf data_buf37(data_ipd[37], data[37]);
   buf data_buf38(data_ipd[38], data[38]);
   buf data_buf39(data_ipd[39], data[39]);
   buf data_buf40(data_ipd[40], data[40]);
   buf data_buf41(data_ipd[41], data[41]);
   buf data_buf42(data_ipd[42], data[42]);
   buf data_buf43(data_ipd[43], data[43]);
   buf data_buf44(data_ipd[44], data[44]);
   buf data_buf45(data_ipd[45], data[45]);
   buf data_buf46(data_ipd[46], data[46]);
   buf data_buf47(data_ipd[47], data[47]);
   buf data_buf48(data_ipd[48], data[48]);
   buf data_buf49(data_ipd[49], data[49]);
   buf data_buf50(data_ipd[50], data[50]);
   buf data_buf51(data_ipd[51], data[51]);
   buf data_buf52(data_ipd[52], data[52]);
   buf data_buf53(data_ipd[53], data[53]);
   buf data_buf54(data_ipd[54], data[54]);
   buf data_buf55(data_ipd[55], data[55]);
   buf data_buf56(data_ipd[56], data[56]);
   buf data_buf57(data_ipd[57], data[57]);
   buf data_buf58(data_ipd[58], data[58]);
   buf data_buf59(data_ipd[59], data[59]);
   buf data_buf60(data_ipd[60], data[60]);
   buf data_buf61(data_ipd[61], data[61]);
   buf data_buf62(data_ipd[62], data[62]);
   buf data_buf63(data_ipd[63], data[63]);
   buf data_buf64(data_ipd[64], data[64]);
   buf data_buf65(data_ipd[65], data[65]);
   buf data_buf66(data_ipd[66], data[66]);
   buf data_buf67(data_ipd[67], data[67]);
   buf data_buf68(data_ipd[68], data[68]);
   buf data_buf69(data_ipd[69], data[69]);
   buf data_buf70(data_ipd[70], data[70]);
   buf data_buf71(data_ipd[71], data[71]);

   buf dataout_buf0(dataout[0], dataout_tbuf[0]);
   buf dataout_buf1(dataout[1], dataout_tbuf[1]);
   buf dataout_buf2(dataout[2], dataout_tbuf[2]);
   buf dataout_buf3(dataout[3], dataout_tbuf[3]);
   buf dataout_buf4(dataout[4], dataout_tbuf[4]);
   buf dataout_buf5(dataout[5], dataout_tbuf[5]);
   buf dataout_buf6(dataout[6], dataout_tbuf[6]);
   buf dataout_buf7(dataout[7], dataout_tbuf[7]);
   buf dataout_buf8(dataout[8], dataout_tbuf[8]);
   buf dataout_buf9(dataout[9], dataout_tbuf[9]);
   buf dataout_buf10(dataout[10], dataout_tbuf[10]);
   buf dataout_buf11(dataout[11], dataout_tbuf[11]);
   buf dataout_buf12(dataout[12], dataout_tbuf[12]);
   buf dataout_buf13(dataout[13], dataout_tbuf[13]);
   buf dataout_buf14(dataout[14], dataout_tbuf[14]);
   buf dataout_buf15(dataout[15], dataout_tbuf[15]);
   buf dataout_buf16(dataout[16], dataout_tbuf[16]);
   buf dataout_buf17(dataout[17], dataout_tbuf[17]);
   buf dataout_buf18(dataout[18], dataout_tbuf[18]);
   buf dataout_buf19(dataout[19], dataout_tbuf[19]);
   buf dataout_buf20(dataout[20], dataout_tbuf[20]);
   buf dataout_buf21(dataout[21], dataout_tbuf[21]);
   buf dataout_buf22(dataout[22], dataout_tbuf[22]);
   buf dataout_buf23(dataout[23], dataout_tbuf[23]);
   buf dataout_buf24(dataout[24], dataout_tbuf[24]);
   buf dataout_buf25(dataout[25], dataout_tbuf[25]);
   buf dataout_buf26(dataout[26], dataout_tbuf[26]);
   buf dataout_buf27(dataout[27], dataout_tbuf[27]);
   buf dataout_buf28(dataout[28], dataout_tbuf[28]);
   buf dataout_buf29(dataout[29], dataout_tbuf[29]);
   buf dataout_buf30(dataout[30], dataout_tbuf[30]);
   buf dataout_buf31(dataout[31], dataout_tbuf[31]);
   buf dataout_buf32(dataout[32], dataout_tbuf[32]);
   buf dataout_buf33(dataout[33], dataout_tbuf[33]);
   buf dataout_buf34(dataout[34], dataout_tbuf[34]);
   buf dataout_buf35(dataout[35], dataout_tbuf[35]);
   buf dataout_buf36(dataout[36], dataout_tbuf[36]);
   buf dataout_buf37(dataout[37], dataout_tbuf[37]);
   buf dataout_buf38(dataout[38], dataout_tbuf[38]);
   buf dataout_buf39(dataout[39], dataout_tbuf[39]);
   buf dataout_buf40(dataout[40], dataout_tbuf[40]);
   buf dataout_buf41(dataout[41], dataout_tbuf[41]);
   buf dataout_buf42(dataout[42], dataout_tbuf[42]);
   buf dataout_buf43(dataout[43], dataout_tbuf[43]);
   buf dataout_buf44(dataout[44], dataout_tbuf[44]);
   buf dataout_buf45(dataout[45], dataout_tbuf[45]);
   buf dataout_buf46(dataout[46], dataout_tbuf[46]);
   buf dataout_buf47(dataout[47], dataout_tbuf[47]);
   buf dataout_buf48(dataout[48], dataout_tbuf[48]);
   buf dataout_buf49(dataout[49], dataout_tbuf[49]);
   buf dataout_buf50(dataout[50], dataout_tbuf[50]);
   buf dataout_buf51(dataout[51], dataout_tbuf[51]);
   buf dataout_buf52(dataout[52], dataout_tbuf[52]);
   buf dataout_buf53(dataout[53], dataout_tbuf[53]);
   buf dataout_buf54(dataout[54], dataout_tbuf[54]);
   buf dataout_buf55(dataout[55], dataout_tbuf[55]);
   buf dataout_buf56(dataout[56], dataout_tbuf[56]);
   buf dataout_buf57(dataout[57], dataout_tbuf[57]);
   buf dataout_buf58(dataout[58], dataout_tbuf[58]);
   buf dataout_buf59(dataout[59], dataout_tbuf[59]);
   buf dataout_buf60(dataout[60], dataout_tbuf[60]);
   buf dataout_buf61(dataout[61], dataout_tbuf[61]);
   buf dataout_buf62(dataout[62], dataout_tbuf[62]);
   buf dataout_buf63(dataout[63], dataout_tbuf[63]);
   buf dataout_buf64(dataout[64], dataout_tbuf[64]);
   buf dataout_buf65(dataout[65], dataout_tbuf[65]);
   buf dataout_buf66(dataout[66], dataout_tbuf[66]);
   buf dataout_buf67(dataout[67], dataout_tbuf[67]);
   buf dataout_buf68(dataout[68], dataout_tbuf[68]);
   buf dataout_buf69(dataout[69], dataout_tbuf[69]);
   buf dataout_buf70(dataout[70], dataout_tbuf[70]);
   buf dataout_buf71(dataout[71], dataout_tbuf[71]);

   buf (clk_ipd, clk);
   buf (aclr_ipd, aclr);
   buf (ena_ipd, ena);
   
   initial 
     begin
	if(power_up)
	  begin
	     dataout_reg = ~(71'b0);
	     dataout_reg_c = ~(71'b0);
	  end
	else
	  begin
	     dataout_reg = 'b0;
	     dataout_reg_c = 'b0;
	  end
     end
   
   specify
      
      specparam TSU = 0;        // Set up time 
      specparam TH  = 0;        // Hold time
      specparam TCO = 0;        // Clock to Output time
      specparam TCLR = 0;       // Clear time
      specparam TCLR_MIN_PW = 0;// Minimum pulse width of clear
      specparam TPRE = 0; 	// Preset time
      specparam TPRE_MIN_PW = 0;// Minimum pulse width of preset
      specparam TCLK_MIN_PW = 0;// Minimum pulse width of clock
      specparam TCE_MIN_PW = 0; // Minimum pulse width of clock enable
      specparam TCLKL = 0; 	// Minimum clock low time
      specparam TCLKH = 0; 	// Minimum clock high time
      
      $setup  (data, posedge clk, 0, viol_notifier);
      $hold   (posedge clk, data, 0, viol_notifier);
      $setup  (ena, posedge clk, 0, viol_notifier );
      $hold   (posedge clk, ena, 0, viol_notifier );
      
      (posedge aclr => (dataout  +: 'b0)) = (0,0);
      (posedge clk  => (dataout  +: dataout_tmp)) = (0,0); 
      
   endspecify

   // ACLR
   always @(posedge clk_ipd or posedge aclr_ipd)
     begin
	if (aclr_ipd == 1'b1)
	  dataout_reg_c <= 'b0;
	else if (ena_ipd == 1'b1) 
	  dataout_reg_c <= data_ipd;
	else 
	  dataout_reg_c <= dataout_reg_c;
     end

   // !ACLR
   always @(posedge clk_ipd)
     begin
	if (ena_ipd == 1'b1) 
	  dataout_reg <= data_ipd;
	else 
	  dataout_reg <= dataout_reg;
     end

   assign dataout_tmp = (async ? data_ipd : (if_aclr ? dataout_reg_c : dataout_reg));

endmodule 

///////////////////////////////////////////////////////////////////////////////
//
//                              STRATIXII_MAC_RS_BLOCK
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
  module stratixii_mac_rs_block
    (
     operation,
     round,
     saturate,
     addnsub,
     signa,
     signb,
     signsize,
     roundsize,
     dataoutsize,
     dataa,
     datab,
     datain,
     dataout
     );

   parameter 	 block_type = "mac_mult";
   parameter 	 dataa_width = 18;
   parameter 	 datab_width = 18;
   
   input 	 round;
   input 	 saturate;
   input 	 addnsub;
   input 	 signa;
   input 	 signb;
   input [3:0] 	 operation;
   input [7:0] 	 signsize;
   input [7:0] 	 roundsize;
   input [7:0] 	 dataoutsize;
   input [71:0]  dataa;
   input [71:0]  datab;
   input [71:0]  datain;
      
   output [71:0] dataout;
   
   wire 	 round_ipd;
   wire 	 saturate_ipd;
   wire 	 addnsub_ipd;
   wire 	 signa_ipd;
   wire 	 signb_ipd;
   wire [71:0] 	 dataa_ipd;
   wire [71:0] 	 datab_ipd;
   wire [71:0] 	 datain_ipd;
   wire [71:0] 	 dataout_tbuf;
   wire [71:0] 	 rs_saturate;
   wire [71:0] 	 rs_mac_mult;
   wire [71:0] 	 rs_mac_out;
   reg [71:0] 	 dataout_round;
   reg [71:0] 	 dataout_saturate;
   reg [71:0] 	 dataout_dly;
   reg 		 saturated;
   reg [71:0] 	 min;
   reg [71:0] 	 max;
   reg 		 msb;
   integer 	 i;
      
   buf round_buf(round_ipd, round);
   buf saturate_buf(saturate_ipd, saturate);
   buf addnsub_buf(addnsub_ipd, addnsub);
   buf signa_buf(signa_ipd, signa);
   buf signb_buf(signb_ipd, signb);

   buf dataa_buf0(dataa_ipd[0], dataa[0]);
   buf dataa_buf1(dataa_ipd[1], dataa[1]);
   buf dataa_buf2(dataa_ipd[2], dataa[2]);
   buf dataa_buf3(dataa_ipd[3], dataa[3]);
   buf dataa_buf4(dataa_ipd[4], dataa[4]);
   buf dataa_buf5(dataa_ipd[5], dataa[5]);
   buf dataa_buf6(dataa_ipd[6], dataa[6]);
   buf dataa_buf7(dataa_ipd[7], dataa[7]);
   buf dataa_buf8(dataa_ipd[8], dataa[8]);
   buf dataa_buf9(dataa_ipd[9], dataa[9]);
   buf dataa_buf10(dataa_ipd[10], dataa[10]);
   buf dataa_buf11(dataa_ipd[11], dataa[11]);
   buf dataa_buf12(dataa_ipd[12], dataa[12]);
   buf dataa_buf13(dataa_ipd[13], dataa[13]);
   buf dataa_buf14(dataa_ipd[14], dataa[14]);
   buf dataa_buf15(dataa_ipd[15], dataa[15]);
   buf dataa_buf16(dataa_ipd[16], dataa[16]);
   buf dataa_buf17(dataa_ipd[17], dataa[17]);
   buf dataa_buf18(dataa_ipd[18], dataa[18]);
   buf dataa_buf19(dataa_ipd[19], dataa[19]);
   buf dataa_buf20(dataa_ipd[20], dataa[20]);
   buf dataa_buf21(dataa_ipd[21], dataa[21]);
   buf dataa_buf22(dataa_ipd[22], dataa[22]);
   buf dataa_buf23(dataa_ipd[23], dataa[23]);
   buf dataa_buf24(dataa_ipd[24], dataa[24]);
   buf dataa_buf25(dataa_ipd[25], dataa[25]);
   buf dataa_buf26(dataa_ipd[26], dataa[26]);
   buf dataa_buf27(dataa_ipd[27], dataa[27]);
   buf dataa_buf28(dataa_ipd[28], dataa[28]);
   buf dataa_buf29(dataa_ipd[29], dataa[29]);
   buf dataa_buf30(dataa_ipd[30], dataa[30]);
   buf dataa_buf31(dataa_ipd[31], dataa[31]);
   buf dataa_buf32(dataa_ipd[32], dataa[32]);
   buf dataa_buf33(dataa_ipd[33], dataa[33]);
   buf dataa_buf34(dataa_ipd[34], dataa[34]);
   buf dataa_buf35(dataa_ipd[35], dataa[35]);
   buf dataa_buf36(dataa_ipd[36], dataa[36]);
   buf dataa_buf37(dataa_ipd[37], dataa[37]);
   buf dataa_buf38(dataa_ipd[38], dataa[38]);
   buf dataa_buf39(dataa_ipd[39], dataa[39]);
   buf dataa_buf40(dataa_ipd[40], dataa[40]);
   buf dataa_buf41(dataa_ipd[41], dataa[41]);
   buf dataa_buf42(dataa_ipd[42], dataa[42]);
   buf dataa_buf43(dataa_ipd[43], dataa[43]);
   buf dataa_buf44(dataa_ipd[44], dataa[44]);
   buf dataa_buf45(dataa_ipd[45], dataa[45]);
   buf dataa_buf46(dataa_ipd[46], dataa[46]);
   buf dataa_buf47(dataa_ipd[47], dataa[47]);
   buf dataa_buf48(dataa_ipd[48], dataa[48]);
   buf dataa_buf49(dataa_ipd[49], dataa[49]);
   buf dataa_buf50(dataa_ipd[50], dataa[50]);
   buf dataa_buf51(dataa_ipd[51], dataa[51]);
   buf dataa_buf52(dataa_ipd[52], dataa[52]);
   buf dataa_buf53(dataa_ipd[53], dataa[53]);
   buf dataa_buf54(dataa_ipd[54], dataa[54]);
   buf dataa_buf55(dataa_ipd[55], dataa[55]);
   buf dataa_buf56(dataa_ipd[56], dataa[56]);
   buf dataa_buf57(dataa_ipd[57], dataa[57]);
   buf dataa_buf58(dataa_ipd[58], dataa[58]);
   buf dataa_buf59(dataa_ipd[59], dataa[59]);
   buf dataa_buf60(dataa_ipd[60], dataa[60]);
   buf dataa_buf61(dataa_ipd[61], dataa[61]);
   buf dataa_buf62(dataa_ipd[62], dataa[62]);
   buf dataa_buf63(dataa_ipd[63], dataa[63]);
   buf dataa_buf64(dataa_ipd[64], dataa[64]);
   buf dataa_buf65(dataa_ipd[65], dataa[65]);
   buf dataa_buf66(dataa_ipd[66], dataa[66]);
   buf dataa_buf67(dataa_ipd[67], dataa[67]);
   buf dataa_buf68(dataa_ipd[68], dataa[68]);
   buf dataa_buf69(dataa_ipd[69], dataa[69]);
   buf dataa_buf70(dataa_ipd[70], dataa[70]);
   buf dataa_buf71(dataa_ipd[71], dataa[71]);

   buf datab_buf0(datab_ipd[0], datab[0]);
   buf datab_buf1(datab_ipd[1], datab[1]);
   buf datab_buf2(datab_ipd[2], datab[2]);
   buf datab_buf3(datab_ipd[3], datab[3]);
   buf datab_buf4(datab_ipd[4], datab[4]);
   buf datab_buf5(datab_ipd[5], datab[5]);
   buf datab_buf6(datab_ipd[6], datab[6]);
   buf datab_buf7(datab_ipd[7], datab[7]);
   buf datab_buf8(datab_ipd[8], datab[8]);
   buf datab_buf9(datab_ipd[9], datab[9]);
   buf datab_buf10(datab_ipd[10], datab[10]);
   buf datab_buf11(datab_ipd[11], datab[11]);
   buf datab_buf12(datab_ipd[12], datab[12]);
   buf datab_buf13(datab_ipd[13], datab[13]);
   buf datab_buf14(datab_ipd[14], datab[14]);
   buf datab_buf15(datab_ipd[15], datab[15]);
   buf datab_buf16(datab_ipd[16], datab[16]);
   buf datab_buf17(datab_ipd[17], datab[17]);
   buf datab_buf18(datab_ipd[18], datab[18]);
   buf datab_buf19(datab_ipd[19], datab[19]);
   buf datab_buf20(datab_ipd[20], datab[20]);
   buf datab_buf21(datab_ipd[21], datab[21]);
   buf datab_buf22(datab_ipd[22], datab[22]);
   buf datab_buf23(datab_ipd[23], datab[23]);
   buf datab_buf24(datab_ipd[24], datab[24]);
   buf datab_buf25(datab_ipd[25], datab[25]);
   buf datab_buf26(datab_ipd[26], datab[26]);
   buf datab_buf27(datab_ipd[27], datab[27]);
   buf datab_buf28(datab_ipd[28], datab[28]);
   buf datab_buf29(datab_ipd[29], datab[29]);
   buf datab_buf30(datab_ipd[30], datab[30]);
   buf datab_buf31(datab_ipd[31], datab[31]);
   buf datab_buf32(datab_ipd[32], datab[32]);
   buf datab_buf33(datab_ipd[33], datab[33]);
   buf datab_buf34(datab_ipd[34], datab[34]);
   buf datab_buf35(datab_ipd[35], datab[35]);
   buf datab_buf36(datab_ipd[36], datab[36]);
   buf datab_buf37(datab_ipd[37], datab[37]);
   buf datab_buf38(datab_ipd[38], datab[38]);
   buf datab_buf39(datab_ipd[39], datab[39]);
   buf datab_buf40(datab_ipd[40], datab[40]);
   buf datab_buf41(datab_ipd[41], datab[41]);
   buf datab_buf42(datab_ipd[42], datab[42]);
   buf datab_buf43(datab_ipd[43], datab[43]);
   buf datab_buf44(datab_ipd[44], datab[44]);
   buf datab_buf45(datab_ipd[45], datab[45]);
   buf datab_buf46(datab_ipd[46], datab[46]);
   buf datab_buf47(datab_ipd[47], datab[47]);
   buf datab_buf48(datab_ipd[48], datab[48]);
   buf datab_buf49(datab_ipd[49], datab[49]);
   buf datab_buf50(datab_ipd[50], datab[50]);
   buf datab_buf51(datab_ipd[51], datab[51]);
   buf datab_buf52(datab_ipd[52], datab[52]);
   buf datab_buf53(datab_ipd[53], datab[53]);
   buf datab_buf54(datab_ipd[54], datab[54]);
   buf datab_buf55(datab_ipd[55], datab[55]);
   buf datab_buf56(datab_ipd[56], datab[56]);
   buf datab_buf57(datab_ipd[57], datab[57]);
   buf datab_buf58(datab_ipd[58], datab[58]);
   buf datab_buf59(datab_ipd[59], datab[59]);
   buf datab_buf60(datab_ipd[60], datab[60]);
   buf datab_buf61(datab_ipd[61], datab[61]);
   buf datab_buf62(datab_ipd[62], datab[62]);
   buf datab_buf63(datab_ipd[63], datab[63]);
   buf datab_buf64(datab_ipd[64], datab[64]);
   buf datab_buf65(datab_ipd[65], datab[65]);
   buf datab_buf66(datab_ipd[66], datab[66]);
   buf datab_buf67(datab_ipd[67], datab[67]);
   buf datab_buf68(datab_ipd[68], datab[68]);
   buf datab_buf69(datab_ipd[69], datab[69]);
   buf datab_buf70(datab_ipd[70], datab[70]);
   buf datab_buf71(datab_ipd[71], datab[71]);
   
   buf datain_buf0(datain_ipd[0], datain[0]);
   buf datain_buf1(datain_ipd[1], datain[1]);
   buf datain_buf2(datain_ipd[2], datain[2]);
   buf datain_buf3(datain_ipd[3], datain[3]);
   buf datain_buf4(datain_ipd[4], datain[4]);
   buf datain_buf5(datain_ipd[5], datain[5]);
   buf datain_buf6(datain_ipd[6], datain[6]);
   buf datain_buf7(datain_ipd[7], datain[7]);
   buf datain_buf8(datain_ipd[8], datain[8]);
   buf datain_buf9(datain_ipd[9], datain[9]);
   buf datain_buf10(datain_ipd[10], datain[10]);
   buf datain_buf11(datain_ipd[11], datain[11]);
   buf datain_buf12(datain_ipd[12], datain[12]);
   buf datain_buf13(datain_ipd[13], datain[13]);
   buf datain_buf14(datain_ipd[14], datain[14]);
   buf datain_buf15(datain_ipd[15], datain[15]);
   buf datain_buf16(datain_ipd[16], datain[16]);
   buf datain_buf17(datain_ipd[17], datain[17]);
   buf datain_buf18(datain_ipd[18], datain[18]);
   buf datain_buf19(datain_ipd[19], datain[19]);
   buf datain_buf20(datain_ipd[20], datain[20]);
   buf datain_buf21(datain_ipd[21], datain[21]);
   buf datain_buf22(datain_ipd[22], datain[22]);
   buf datain_buf23(datain_ipd[23], datain[23]);
   buf datain_buf24(datain_ipd[24], datain[24]);
   buf datain_buf25(datain_ipd[25], datain[25]);
   buf datain_buf26(datain_ipd[26], datain[26]);
   buf datain_buf27(datain_ipd[27], datain[27]);
   buf datain_buf28(datain_ipd[28], datain[28]);
   buf datain_buf29(datain_ipd[29], datain[29]);
   buf datain_buf30(datain_ipd[30], datain[30]);
   buf datain_buf31(datain_ipd[31], datain[31]);
   buf datain_buf32(datain_ipd[32], datain[32]);
   buf datain_buf33(datain_ipd[33], datain[33]);
   buf datain_buf34(datain_ipd[34], datain[34]);
   buf datain_buf35(datain_ipd[35], datain[35]);
   buf datain_buf36(datain_ipd[36], datain[36]);
   buf datain_buf37(datain_ipd[37], datain[37]);
   buf datain_buf38(datain_ipd[38], datain[38]);
   buf datain_buf39(datain_ipd[39], datain[39]);
   buf datain_buf40(datain_ipd[40], datain[40]);
   buf datain_buf41(datain_ipd[41], datain[41]);
   buf datain_buf42(datain_ipd[42], datain[42]);
   buf datain_buf43(datain_ipd[43], datain[43]);
   buf datain_buf44(datain_ipd[44], datain[44]);
   buf datain_buf45(datain_ipd[45], datain[45]);
   buf datain_buf46(datain_ipd[46], datain[46]);
   buf datain_buf47(datain_ipd[47], datain[47]);
   buf datain_buf48(datain_ipd[48], datain[48]);
   buf datain_buf49(datain_ipd[49], datain[49]);
   buf datain_buf50(datain_ipd[50], datain[50]);
   buf datain_buf51(datain_ipd[51], datain[51]);
   buf datain_buf52(datain_ipd[52], datain[52]);
   buf datain_buf53(datain_ipd[53], datain[53]);
   buf datain_buf54(datain_ipd[54], datain[54]);
   buf datain_buf55(datain_ipd[55], datain[55]);
   buf datain_buf56(datain_ipd[56], datain[56]);
   buf datain_buf57(datain_ipd[57], datain[57]);
   buf datain_buf58(datain_ipd[58], datain[58]);
   buf datain_buf59(datain_ipd[59], datain[59]);
   buf datain_buf60(datain_ipd[60], datain[60]);
   buf datain_buf61(datain_ipd[61], datain[61]);
   buf datain_buf62(datain_ipd[62], datain[62]);
   buf datain_buf63(datain_ipd[63], datain[63]);
   buf datain_buf64(datain_ipd[64], datain[64]);
   buf datain_buf65(datain_ipd[65], datain[65]);
   buf datain_buf66(datain_ipd[66], datain[66]);
   buf datain_buf67(datain_ipd[67], datain[67]);
   buf datain_buf68(datain_ipd[68], datain[68]);
   buf datain_buf69(datain_ipd[69], datain[69]);
   buf datain_buf70(datain_ipd[70], datain[70]);
   buf datain_buf71(datain_ipd[71], datain[71]);
   
   buf dataout_buf0(dataout[0], dataout_tbuf[0]);
   buf dataout_buf1(dataout[1], dataout_tbuf[1]);
   buf dataout_buf2(dataout[2], dataout_tbuf[2]);
   buf dataout_buf3(dataout[3], dataout_tbuf[3]);
   buf dataout_buf4(dataout[4], dataout_tbuf[4]);
   buf dataout_buf5(dataout[5], dataout_tbuf[5]);
   buf dataout_buf6(dataout[6], dataout_tbuf[6]);
   buf dataout_buf7(dataout[7], dataout_tbuf[7]);
   buf dataout_buf8(dataout[8], dataout_tbuf[8]);
   buf dataout_buf9(dataout[9], dataout_tbuf[9]);
   buf dataout_buf10(dataout[10], dataout_tbuf[10]);
   buf dataout_buf11(dataout[11], dataout_tbuf[11]);
   buf dataout_buf12(dataout[12], dataout_tbuf[12]);
   buf dataout_buf13(dataout[13], dataout_tbuf[13]);
   buf dataout_buf14(dataout[14], dataout_tbuf[14]);
   buf dataout_buf15(dataout[15], dataout_tbuf[15]);
   buf dataout_buf16(dataout[16], dataout_tbuf[16]);
   buf dataout_buf17(dataout[17], dataout_tbuf[17]);
   buf dataout_buf18(dataout[18], dataout_tbuf[18]);
   buf dataout_buf19(dataout[19], dataout_tbuf[19]);
   buf dataout_buf20(dataout[20], dataout_tbuf[20]);
   buf dataout_buf21(dataout[21], dataout_tbuf[21]);
   buf dataout_buf22(dataout[22], dataout_tbuf[22]);
   buf dataout_buf23(dataout[23], dataout_tbuf[23]);
   buf dataout_buf24(dataout[24], dataout_tbuf[24]);
   buf dataout_buf25(dataout[25], dataout_tbuf[25]);
   buf dataout_buf26(dataout[26], dataout_tbuf[26]);
   buf dataout_buf27(dataout[27], dataout_tbuf[27]);
   buf dataout_buf28(dataout[28], dataout_tbuf[28]);
   buf dataout_buf29(dataout[29], dataout_tbuf[29]);
   buf dataout_buf30(dataout[30], dataout_tbuf[30]);
   buf dataout_buf31(dataout[31], dataout_tbuf[31]);
   buf dataout_buf32(dataout[32], dataout_tbuf[32]);
   buf dataout_buf33(dataout[33], dataout_tbuf[33]);
   buf dataout_buf34(dataout[34], dataout_tbuf[34]);
   buf dataout_buf35(dataout[35], dataout_tbuf[35]);
   buf dataout_buf36(dataout[36], dataout_tbuf[36]);
   buf dataout_buf37(dataout[37], dataout_tbuf[37]);
   buf dataout_buf38(dataout[38], dataout_tbuf[38]);
   buf dataout_buf39(dataout[39], dataout_tbuf[39]);
   buf dataout_buf40(dataout[40], dataout_tbuf[40]);
   buf dataout_buf41(dataout[41], dataout_tbuf[41]);
   buf dataout_buf42(dataout[42], dataout_tbuf[42]);
   buf dataout_buf43(dataout[43], dataout_tbuf[43]);
   buf dataout_buf44(dataout[44], dataout_tbuf[44]);
   buf dataout_buf45(dataout[45], dataout_tbuf[45]);
   buf dataout_buf46(dataout[46], dataout_tbuf[46]);
   buf dataout_buf47(dataout[47], dataout_tbuf[47]);
   buf dataout_buf48(dataout[48], dataout_tbuf[48]);
   buf dataout_buf49(dataout[49], dataout_tbuf[49]);
   buf dataout_buf50(dataout[50], dataout_tbuf[50]);
   buf dataout_buf51(dataout[51], dataout_tbuf[51]);
   buf dataout_buf52(dataout[52], dataout_tbuf[52]);
   buf dataout_buf53(dataout[53], dataout_tbuf[53]);
   buf dataout_buf54(dataout[54], dataout_tbuf[54]);
   buf dataout_buf55(dataout[55], dataout_tbuf[55]);
   buf dataout_buf56(dataout[56], dataout_tbuf[56]);
   buf dataout_buf57(dataout[57], dataout_tbuf[57]);
   buf dataout_buf58(dataout[58], dataout_tbuf[58]);
   buf dataout_buf59(dataout[59], dataout_tbuf[59]);
   buf dataout_buf60(dataout[60], dataout_tbuf[60]);
   buf dataout_buf61(dataout[61], dataout_tbuf[61]);
   buf dataout_buf62(dataout[62], dataout_tbuf[62]);
   buf dataout_buf63(dataout[63], dataout_tbuf[63]);
   buf dataout_buf64(dataout[64], dataout_tbuf[64]);
   buf dataout_buf65(dataout[65], dataout_tbuf[65]);
   buf dataout_buf66(dataout[66], dataout_tbuf[66]);
   buf dataout_buf67(dataout[67], dataout_tbuf[67]);
   buf dataout_buf68(dataout[68], dataout_tbuf[68]);
   buf dataout_buf69(dataout[69], dataout_tbuf[69]);
   buf dataout_buf70(dataout[70], dataout_tbuf[70]);
   buf dataout_buf71(dataout[71], dataout_tbuf[71]);
      
   specify
      (round    *> dataout) = (0, 0);
      (saturate *> dataout) = (0, 0);
      (dataa    *> dataout) = (0, 0);
      (datab    *> dataout) = (0, 0);
      (datain   *> dataout) = (0, 0);
   endspecify

   always @ (datain_ipd or 
	     signa_ipd or
	     signb_ipd or
	     addnsub_ipd or
	     round_ipd)
     begin
        if(round_ipd)
          begin
      	     dataout_round 
	       = datain_ipd + 
		 (1 << (dataoutsize - signsize - roundsize -1));
	  end
        else
          dataout_round = datain_ipd;
     end

   always @ (datain_ipd or
	     signa_ipd or
	     signb_ipd or 
	     round_ipd or 
	     saturate_ipd or 
	     addnsub_ipd or
	     dataout_round)
     begin
        if(saturate_ipd)
          begin
	     if (block_type == "mac_mult")
	       begin
		  if (dataout_round[dataa_width+datab_width-1] == 1'b0 && 
		      dataout_round[dataa_width+datab_width-2] == 1'b1)
		    begin
		       dataout_saturate = -72'b1;
		       for (i = dataa_width+datab_width-2; i < 72; i = i + 1)
			 begin
			    dataout_saturate[i] = 1'b0;
			 end
		       min = dataout_saturate;
		       max = dataout_saturate;
		       saturated = 1'b1;
		    end
		  else
		    begin
		       dataout_saturate = dataout_round;
		       saturated = 1'b0;
		    end
	       end
	     else if  ((operation[2] == 1'b1) && ((block_type == "ab") || (block_type == "cd")))
	       begin
		  // DATAA + DATAB (ACCUMULATOR)
		  //       or
		  // DATAC + DATAD (ACCUMULATOR)
		  saturated = 1'b0;
		  for (i = datab_width-2; i < (datab_width + signsize - 2); i = i + 1)
		    begin
		       if(dataout_round[datab_width-2] != dataout_round[i])
			 saturated = 1'b1;
		    end
		  if(saturated)
		    begin
		       min = -72'b1;
		       max = -72'b1;
		       for (i = 0; i < (datab_width - 2); i = i + 1)
			 begin
			    max[i] = 1'b0;
			 end
		       for (i = (datab_width - 2); i < 72; i = i + 1)
			 begin
			    min[i] = 1'b0;
			 end			
		    end // if (saturated)
		  else
		    begin
		       dataout_saturate = dataout_round;
		    end
		  msb = dataout_round[datab_width+15];
	       end
	     // DATAA + DATAB (ONE LEVEL ADDER)
	     //       or
	     // DATAC + DATAD (ONE LEVEL ADDER)
	     else 
	       begin
		  if(signa_ipd || signb_ipd || ~addnsub_ipd)
		    begin
		       min = 1 << dataa_width;
		       max = (1 << dataa_width)-1;
		    end
		  else
		    begin
		       min = 0;
		       max = (1 << (dataa_width + 1))-1;
		    end
		  saturated = 1'b0;
		  for (i = dataa_width-2; i < (dataa_width + signsize - 1); i = i + 1)
		    begin
		       if(dataout_round[dataa_width-2] != dataout_round[i])
			 saturated = 1'b1;
		    end
		  msb = dataout_round[i];
	       end
	     // FINAL min/max EVALUATION
	     if(saturated)
	       begin
		  if(msb)
		    dataout_saturate = max;
		  else
		    dataout_saturate = min;
	       end
	     else
	       dataout_saturate = dataout_round;
	  end
	else
	  begin
	     saturated = 1'b0;
	     dataout_saturate = dataout_round;
	  end 
     end 

   always @ (datain_ipd or
	     signa_ipd or
	     signb_ipd or 
	     round_ipd or 
	     saturate_ipd or 
	     addnsub_ipd or
	     dataout_round or 
	     dataout_saturate)
     begin
        if(round_ipd)
          begin
	     dataout_dly = dataout_saturate;
	     for (i = 0; i < (dataoutsize - signsize - roundsize); i = i + 1)
	       dataout_dly[i] = 1'b0;
	  end
        else
          dataout_dly = dataout_saturate;
     end 
   
   assign dataout_tbuf = (operation == 4'b0000) || (operation == 4'b0111) ? 
			 datain : rs_saturate;
   
   assign rs_saturate = saturate_ipd ? rs_mac_mult : rs_mac_out;

   assign rs_mac_mult = (saturate_ipd && (block_type == "mac_mult") && saturated) ?
			  ({dataout_dly[71:3], 2'b0, saturated}) : rs_mac_out;

   assign rs_mac_out =  (saturate_ipd && (block_type != "mac_mult")) ? 
			  ({dataout_dly[71:3],saturated, datain_ipd[1:0]}) : dataout_dly;
   
endmodule // stratixii_mac_rs_block

///////////////////////////////////////////////////////////////////////////////
//
//                         STRATIXII_MAC_MULT_INTERNAL
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
  
  module stratixii_mac_mult_internal 
    (
     dataa, 
     datab, 
     signa, 
     signb,
     bypass,
     scanouta, 
     scanoutb, 
     dataout
     );
   
   parameter dataa_width = 18;
   parameter datab_width = 18;
   parameter dataout_width = 36;
   parameter dynamic_mode = "no";
      
   input [17:0] dataa;
   input [17:0] datab;
   input 	signa;
   input 	signb;
   input 	bypass;
      
   output [17:0] scanouta;
   output [17:0] scanoutb;
   output [35:0] dataout;
   
   wire [35:0] 	 dataout_s;
   wire 	 neg;
   wire [35:0] 	 dataout_pre_bypass;
   wire [35:0] 	 dataout_tmp;
   wire [dataa_width-1:0] abs_a;
   wire [datab_width-1:0] abs_b;
   wire [17:0] 		  dataa_ipd;
   wire [17:0] 		  datab_ipd;
   wire [17:0] 		  scanouta_tmp;
   wire [17:0] 		  scanoutb_tmp;
   wire [(dataa_width+datab_width)-1:0] abs_output; 
   
   specify
      (dataa *> dataout)     = (0, 0);
      (datab *> dataout)     = (0, 0);
      (bypass *> dataout)    = (0, 0);
      (dataa => scanouta)    = (0, 0);
      (datab => scanoutb)    = (0, 0);
      (signa *> dataout)     = (0, 0);
      (signb *> dataout)     = (0, 0);
   endspecify
   
   buf dataa_buf0 (dataa_ipd[0], dataa[0]);
   buf dataa_buf1 (dataa_ipd[1], dataa[1]);
   buf dataa_buf2 (dataa_ipd[2], dataa[2]);
   buf dataa_buf3 (dataa_ipd[3], dataa[3]);
   buf dataa_buf4 (dataa_ipd[4], dataa[4]);
   buf dataa_buf5 (dataa_ipd[5], dataa[5]);
   buf dataa_buf6 (dataa_ipd[6], dataa[6]);
   buf dataa_buf7 (dataa_ipd[7], dataa[7]);
   buf dataa_buf8 (dataa_ipd[8], dataa[8]);
   buf dataa_buf9 (dataa_ipd[9], dataa[9]);
   buf dataa_buf10 (dataa_ipd[10], dataa[10]);
   buf dataa_buf11 (dataa_ipd[11], dataa[11]);
   buf dataa_buf12 (dataa_ipd[12], dataa[12]);
   buf dataa_buf13 (dataa_ipd[13], dataa[13]);
   buf dataa_buf14 (dataa_ipd[14], dataa[14]);
   buf dataa_buf15 (dataa_ipd[15], dataa[15]);
   buf dataa_buf16 (dataa_ipd[16], dataa[16]);
   buf dataa_buf17 (dataa_ipd[17], dataa[17]);

   buf datab_buf0 (datab_ipd[0], datab[0]);
   buf datab_buf1 (datab_ipd[1], datab[1]);
   buf datab_buf2 (datab_ipd[2], datab[2]);
   buf datab_buf3 (datab_ipd[3], datab[3]);
   buf datab_buf4 (datab_ipd[4], datab[4]);
   buf datab_buf5 (datab_ipd[5], datab[5]);
   buf datab_buf6 (datab_ipd[6], datab[6]);
   buf datab_buf7 (datab_ipd[7], datab[7]);
   buf datab_buf8 (datab_ipd[8], datab[8]);
   buf datab_buf9 (datab_ipd[9], datab[9]);
   buf datab_buf10 (datab_ipd[10], datab[10]);
   buf datab_buf11 (datab_ipd[11], datab[11]);
   buf datab_buf12 (datab_ipd[12], datab[12]);
   buf datab_buf13 (datab_ipd[13], datab[13]);
   buf datab_buf14 (datab_ipd[14], datab[14]);
   buf datab_buf15 (datab_ipd[15], datab[15]);
   buf datab_buf16 (datab_ipd[16], datab[16]);
   buf datab_buf17 (datab_ipd[17], datab[17]);

   assign neg = ((dataa_ipd[dataa_width-1] && signa) ^ 
		 (datab_ipd[datab_width-1] && signb)); 

   assign abs_a = (signa && dataa_ipd[dataa_width-1]) ? 
		    (~dataa_ipd[dataa_width-1:0] + 1) : 
		      dataa_ipd[dataa_width-1:0];
   assign abs_b = (signb && datab_ipd[datab_width-1]) ? 
		    (~datab_ipd[datab_width-1:0] + 1) : 
		      datab_ipd[datab_width-1:0];
   assign scanouta_tmp = dataa_ipd;
   assign scanoutb_tmp = datab_ipd;
   assign abs_output = abs_a * abs_b;
   assign dataout_pre_bypass = neg ? (~abs_output + 1) : abs_output;
   assign dataout_tmp = ((dynamic_mode == "yes") && (bypass == 1'b1)) ? {datab, dataa} : ((bypass == 1'b1) ? {dataa, datab} : dataout_pre_bypass);
      
   buf scanouta_buf0(scanouta[0], scanouta_tmp[0]);
   buf scanouta_buf1(scanouta[1], scanouta_tmp[1]);
   buf scanouta_buf2(scanouta[2], scanouta_tmp[2]);
   buf scanouta_buf3(scanouta[3], scanouta_tmp[3]);
   buf scanouta_buf4(scanouta[4], scanouta_tmp[4]);
   buf scanouta_buf5(scanouta[5], scanouta_tmp[5]);
   buf scanouta_buf6(scanouta[6], scanouta_tmp[6]);
   buf scanouta_buf7(scanouta[7], scanouta_tmp[7]);
   buf scanouta_buf8(scanouta[8], scanouta_tmp[8]);
   buf scanouta_buf9(scanouta[9], scanouta_tmp[9]);
   buf scanouta_buf10(scanouta[10], scanouta_tmp[10]);
   buf scanouta_buf11(scanouta[11], scanouta_tmp[11]);
   buf scanouta_buf12(scanouta[12], scanouta_tmp[12]);
   buf scanouta_buf13(scanouta[13], scanouta_tmp[13]);
   buf scanouta_buf14(scanouta[14], scanouta_tmp[14]);
   buf scanouta_buf15(scanouta[15], scanouta_tmp[15]);
   buf scanouta_buf16(scanouta[16], scanouta_tmp[16]);
   buf scanouta_buf17(scanouta[17], scanouta_tmp[17]);

   buf scanoutb_buf0(scanoutb[0], scanoutb_tmp[0]);
   buf scanoutb_buf1(scanoutb[1], scanoutb_tmp[1]);
   buf scanoutb_buf2(scanoutb[2], scanoutb_tmp[2]);
   buf scanoutb_buf3(scanoutb[3], scanoutb_tmp[3]);
   buf scanoutb_buf4(scanoutb[4], scanoutb_tmp[4]);
   buf scanoutb_buf5(scanoutb[5], scanoutb_tmp[5]);
   buf scanoutb_buf6(scanoutb[6], scanoutb_tmp[6]);
   buf scanoutb_buf7(scanoutb[7], scanoutb_tmp[7]);
   buf scanoutb_buf8(scanoutb[8], scanoutb_tmp[8]);
   buf scanoutb_buf9(scanoutb[9], scanoutb_tmp[9]);
   buf scanoutb_buf10(scanoutb[10], scanoutb_tmp[10]);
   buf scanoutb_buf11(scanoutb[11], scanoutb_tmp[11]);
   buf scanoutb_buf12(scanoutb[12], scanoutb_tmp[12]);
   buf scanoutb_buf13(scanoutb[13], scanoutb_tmp[13]);
   buf scanoutb_buf14(scanoutb[14], scanoutb_tmp[14]);
   buf scanoutb_buf15(scanoutb[15], scanoutb_tmp[15]);
   buf scanoutb_buf16(scanoutb[16], scanoutb_tmp[16]);
   buf scanoutb_buf17(scanoutb[17], scanoutb_tmp[17]);
   
   buf dataout_buf0(dataout[0], dataout_tmp[0]);
   buf dataout_buf1(dataout[1], dataout_tmp[1]);
   buf dataout_buf2(dataout[2], dataout_tmp[2]);
   buf dataout_buf3(dataout[3], dataout_tmp[3]);
   buf dataout_buf4(dataout[4], dataout_tmp[4]);
   buf dataout_buf5(dataout[5], dataout_tmp[5]);
   buf dataout_buf6(dataout[6], dataout_tmp[6]);
   buf dataout_buf7(dataout[7], dataout_tmp[7]);
   buf dataout_buf8(dataout[8], dataout_tmp[8]);
   buf dataout_buf9(dataout[9], dataout_tmp[9]);
   buf dataout_buf10(dataout[10], dataout_tmp[10]);
   buf dataout_buf11(dataout[11], dataout_tmp[11]);
   buf dataout_buf12(dataout[12], dataout_tmp[12]);
   buf dataout_buf13(dataout[13], dataout_tmp[13]);
   buf dataout_buf14(dataout[14], dataout_tmp[14]);
   buf dataout_buf15(dataout[15], dataout_tmp[15]);
   buf dataout_buf16(dataout[16], dataout_tmp[16]);
   buf dataout_buf17(dataout[17], dataout_tmp[17]);
   buf dataout_buf18(dataout[18], dataout_tmp[18]);
   buf dataout_buf19(dataout[19], dataout_tmp[19]);
   buf dataout_buf20(dataout[20], dataout_tmp[20]);
   buf dataout_buf21(dataout[21], dataout_tmp[21]);
   buf dataout_buf22(dataout[22], dataout_tmp[22]);
   buf dataout_buf23(dataout[23], dataout_tmp[23]);
   buf dataout_buf24(dataout[24], dataout_tmp[24]);
   buf dataout_buf25(dataout[25], dataout_tmp[25]);
   buf dataout_buf26(dataout[26], dataout_tmp[26]);
   buf dataout_buf27(dataout[27], dataout_tmp[27]);
   buf dataout_buf28(dataout[28], dataout_tmp[28]);
   buf dataout_buf29(dataout[29], dataout_tmp[29]);
   buf dataout_buf30(dataout[30], dataout_tmp[30]);
   buf dataout_buf31(dataout[31], dataout_tmp[31]);
   buf dataout_buf32(dataout[32], dataout_tmp[32]);
   buf dataout_buf33(dataout[33], dataout_tmp[33]);
   buf dataout_buf34(dataout[34], dataout_tmp[34]);
   buf dataout_buf35(dataout[35], dataout_tmp[35]);
   
endmodule

///////////////////////////////////////////////////////////////////////////////
//
//                              STRATIXII_MAC_MULT
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixii_mac_mult	
  (
   dataa, 
   datab,
   scanina,
   scaninb,
   sourcea,
   sourceb,
   signa, 
   signb,
   round,
   saturate,
   clk, 
   aclr, 
   ena,
   mode,
   zeroacc,
   dataout, 
   scanouta, 
   scanoutb, 
   devclrn, 
   devpor
   );
   
   parameter dataa_width        = 18;
   parameter datab_width        = 18;
   parameter dataa_clock	= "none";
   parameter datab_clock	= "none";
   parameter signa_clock	= "none"; 
   parameter signb_clock	= "none";
   parameter round_clock        = "none";
   parameter saturate_clock     = "none"; 
   parameter output_clock	= "none";
   parameter round_clear        = "none";
   parameter saturate_clear     = "none";
   parameter dataa_clear	= "none";
   parameter datab_clear	= "none";
   parameter signa_clear	= "none"; 
   parameter signb_clear	= "none"; 
   parameter output_clear	= "none";
   parameter bypass_multiplier  = "no";
   parameter mode_clock         = "none";
   parameter zeroacc_clock      = "none";
   parameter mode_clear         = "none";
   parameter zeroacc_clear      = "none";
   parameter signa_internally_grounded = "false"; 
   parameter signb_internally_grounded = "false"; 
   parameter lpm_hint           = "true";         
   parameter lpm_type           = "stratixii_mac_mult";
   parameter dynamic_mode       = "no";
      
   input [17:0] dataa;
   input [17:0] datab;
   input [17:0] scanina;
   input [17:0] scaninb;   
   input 	sourcea;
   input 	sourceb;
   input 	signa;
   input 	signb;
   input 	round;
   input 	saturate;
   input [3:0] 	clk;
   input [3:0] 	aclr;
   input [3:0] 	ena;
   input 	mode;
   input 	zeroacc;
   input 	devclrn;
   input 	devpor;

   output [35:0] dataout;
   output [17:0] scanouta;
   output [17:0] scanoutb;
	
   wire [35:0] 	 mult_output;
   wire [0:0] 	 signa_out; 
   wire [0:0] 	 signb_out;
   wire [0:0] 	 round_out;
   wire [0:0] 	 saturate_out;
   wire [0:0] 	 mode_out;
   wire [0:0] 	 zeroacc_out;
   wire [71:0] 	 dataout_tmp;
   wire [71:0] 	 dataout_reg;
   wire [71:0] 	 dataout_rs;
   wire [71:0] 	 scanouta_tmp;
   wire [71:0] 	 scanoutb_tmp;
   wire [17:0] 	 dataa_src;
   wire [17:0] 	 datab_src;
	
   wire [3:0] dataa_clk;
   wire [3:0] datab_clk;
   wire [3:0] signa_clk;
   wire [3:0] signb_clk;
   wire [3:0] round_clk;
   wire [3:0] saturate_clk;
   wire [3:0] output_clk;
   wire [3:0] round_aclr;
   wire [3:0] saturate_aclr;
   wire [3:0] dataa_aclr;
   wire [3:0] datab_aclr;
   wire [3:0] signa_aclr;
   wire [3:0] signb_aclr;
   wire [3:0] output_aclr;
   wire [3:0] mode_clk;
   wire [3:0] zeroacc_clk;
   wire [3:0] mode_aclr;
   wire [3:0] zeroacc_aclr;

   wire       clk_dataa;
   wire       clear_dataa;
   wire       aclr_dataa;
   wire       ena_dataa;
   wire       async_dataa;   
   wire       clk_datab;
   wire       clear_datab;
   wire       aclr_datab;
   wire       ena_datab;
   wire       async_datab;   
   wire       clk_signa;
   wire       clear_signa;
   wire       aclr_signa;
   wire       ena_signa;
   wire       async_signa;   
   wire       clk_signb;
   wire       clear_signb;
   wire       aclr_signb;
   wire       ena_signb;
   wire       async_signb;   
   wire       clk_round;
   wire       clear_round;
   wire       aclr_round;
   wire       ena_round;
   wire       async_round;   
   wire       clk_saturate;
   wire       clear_saturate;
   wire       aclr_saturate;
   wire       ena_saturate;
   wire       async_saturate;   
   wire       clk_mode;
   wire       clear_mode;
   wire       aclr_mode;
   wire       ena_mode;
   wire       async_mode;   
   wire       clk_zeroacc;
   wire       clear_zeroacc;
   wire       aclr_zeroacc;
   wire       ena_zeroacc;
   wire       async_zeroacc;   
   wire       clk_output;
   wire       clear_output;
   wire       aclr_output;
   wire       ena_output;
   wire       async_output;   
   wire       signa_internal;
   wire       signb_internal;
   wire       bypass;
   wire [7:0] mac_mult_dataoutsize;
      
   assign     dataout = dataout_tmp[35:0];
   assign     dataa_src = (sourcea == 1'b1) ? scanina : dataa;
   assign     datab_src = (sourceb == 1'b1) ? scaninb : datab;
   
   stratixii_mac_register	dataa_mac_reg 
     (
      .data ({{(54){1'b0}},dataa_src}),
      .clk (clk_dataa),
      .aclr (aclr_dataa),
      .if_aclr (clear_dataa),
      .ena (ena_dataa),
      .dataout (scanouta_tmp),
      .async (async_dataa)
      );
   defparam dataa_mac_reg.data_width = dataa_width;
   defparam dataa_mac_reg.power_up = 1'b0;

   assign   async_dataa = (dataa_clock == "none") ? 1'b1 : 1'b0;
   assign   clear_dataa = (dataa_clear != "none") ? 1'b1 : 1'b0;
   assign   clk_dataa  = clk[dataa_clk] ? 1'b1 : 1'b0;
   assign   aclr_dataa = aclr[dataa_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign   ena_dataa  = ena[dataa_clk] ? 1'b1 : 1'b0;
   
   assign   dataa_clk = 
	    ((dataa_clock == "0") || 
	     (dataa_clock == "none")) ? 4'b0000 :
	    (dataa_clock == "1") ? 4'b0001 :
	    (dataa_clock == "2") ? 4'b0010 :
	    (dataa_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign   dataa_aclr = 
	    ((dataa_clear == "0") || 
	     (dataa_clear == "none")) ? 4'b0000 :
	    (dataa_clear == "1") ? 4'b0001 :
	    (dataa_clear == "2") ? 4'b0010 :
	    (dataa_clear == "3") ? 4'b0011 : 4'b0000;
   
   stratixii_mac_register	datab_mac_reg 
     (
      .data ({{(54){1'b0}},datab_src}),
      .clk (clk_datab),
      .aclr (aclr_datab),
      .if_aclr (clear_datab),
      .ena (ena_datab),
      .dataout (scanoutb_tmp),
      .async (async_datab)
      );
   defparam datab_mac_reg.data_width = datab_width;
   defparam datab_mac_reg.power_up = 1'b0;

   assign   async_datab = (datab_clock == "none") ? 1'b1 : 1'b0;
   assign   clear_datab = (datab_clear != "none") ? 1'b1 : 1'b0;
   assign   clk_datab  =  clk[datab_clk] ? 1'b1 : 1'b0;
   assign   aclr_datab = aclr[datab_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign   ena_datab  = ena[datab_clk] ? 1'b1 : 1'b0;
   
   assign    datab_clk = 
	     ((datab_clock == "0") || 
	      (datab_clock == "none")) ? 4'b0000 :
	     (datab_clock == "1") ? 4'b0001 :
	     (datab_clock == "2") ? 4'b0010 :
	     (datab_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign    datab_aclr = 
	     ((datab_clear == "0") || 
	      (datab_clear == "none")) ? 4'b0000 :
	     (datab_clear == "1") ? 4'b0001 :
	     (datab_clear == "2") ? 4'b0010 :
	     (datab_clear == "3") ? 4'b0011 : 4'b0000;
   
   stratixii_mac_bit_register	signa_mac_reg 
     (
      .data (signa),
      .clk (clk_signa),
      .aclr (aclr_signa),
      .if_aclr (clear_signa),
      .ena (ena_signa),
      .dataout (signa_out),
      .async (async_signa)
      );
   defparam  signa_mac_reg.data_width = 1;
   defparam  signa_mac_reg.power_up = 1'b0;

   assign    async_signa = (signa_clock == "none") ? 1'b1 : 1'b0;
   assign    clear_signa = (signa_clear != "none") ? 1'b1 : 1'b0 ;
   assign    clk_signa  = clk[signa_clk] ? 1'b1 : 1'b0;
   assign    aclr_signa = aclr[signa_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign    ena_signa  = ena[signa_clk] ? 1'b1 : 1'b0;
   
   assign    signa_clk = 
	     ((signa_clock == "0") || 
	      (signa_clock == "none")) ? 4'b0000 :
	     (signa_clock == "1") ? 4'b0001 :
	     (signa_clock == "2") ? 4'b0010 :
	     (signa_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign    signa_aclr = 
	     ((signa_clear == "0") || 
	      (signa_clear == "none")) ? 4'b0000 :
	     (signa_clear == "1") ? 4'b0001 :
	     (signa_clear == "2") ? 4'b0010 :
	     (signa_clear == "3") ? 4'b0011 : 4'b0000;

   stratixii_mac_bit_register	signb_mac_reg 
     (
      .data (signb),
      .clk (clk_signb),
      .aclr (aclr_signb),
      .if_aclr (clear_signb),
      .ena (ena_signb),
      .dataout (signb_out),
      .async (async_signb)
      );
   defparam  signb_mac_reg.data_width = 1;
   defparam  signb_mac_reg.power_up = 1'b0;

   assign    async_signb = (signb_clock == "none") ? 1'b1 : 1'b0;
   assign    clear_signb = (signb_clear != "none") ? 1'b1 : 1'b0 ;
   assign    clk_signb  = clk[signb_clk] ? 1'b1 : 1'b0;
   assign    aclr_signb = aclr[signb_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign    ena_signb  = ena[signb_clk] ? 1'b1 : 1'b0;
   
   assign    signb_clk = 
	     ((signb_clock == "0") || 
	      (signb_clock == "none")) ? 4'b0000 :
	     (signb_clock == "1") ? 4'b0001 :
	     (signb_clock == "2") ? 4'b0010 :
	     (signb_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign    signb_aclr = 
	     ((signb_clear == "0") || 
	      (signb_clear == "none")) ? 4'b0000 :
	     (signb_clear == "1") ? 4'b0001 :
	     (signb_clear == "2") ? 4'b0010 :
	     (signb_clear == "3") ? 4'b0011 : 4'b0000;

   stratixii_mac_bit_register	round_mac_reg 
     (
      .data (round),
      .clk (clk_round),
      .aclr (aclr_round),
      .if_aclr (clear_round),
      .ena (ena_round),
      .dataout (round_out),
      .async (async_round)
      );
   defparam  round_mac_reg.data_width = 1;
   defparam  round_mac_reg.power_up = 1'b0;

   assign    async_round = (round_clock == "none") ? 1'b1 : 1'b0;
   assign    clear_round = (round_clear != "none") ? 1'b1 : 1'b0;
   assign    clk_round  = clk[round_clk] ? 1'b1 : 1'b0;
   assign    aclr_round = aclr[round_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign    ena_round  = ena[round_clk] ? 1'b1 : 1'b0;
   
   assign    round_clk = 
	     ((round_clock == "0") || 
	      (round_clock == "none")) ? 4'b0000 :
	     (round_clock == "1") ? 4'b0001 :
	     (round_clock == "2") ? 4'b0010 :
	     (round_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign    round_aclr = 
	     ((round_clear == "0") || 
	      (round_clear == "none")) ? 4'b0000 :
	     (round_clear == "1") ? 4'b0001 :
	     (round_clear == "2") ? 4'b0010 :
	     (round_clear == "3") ? 4'b0011 : 4'b0000;
   
   stratixii_mac_bit_register	saturate_mac_reg 
     (
      .data (saturate),
      .clk (clk_saturate),
      .aclr (aclr_saturate),
      .if_aclr (clear_saturate),
      .ena (ena_saturate),
      .dataout (saturate_out),
      .async (async_saturate)
      );
   defparam  saturate_mac_reg.data_width = 1;
   defparam  saturate_mac_reg.power_up = 1'b0;  

   assign    async_saturate = (saturate_clock == "none") ? 1'b1 : 1'b0;
   assign    clear_saturate = (saturate_clear != "none") ? 1'b1 : 1'b0;
   assign    clk_saturate  = clk[saturate_clk] ? 1'b1 : 1'b0;
   assign    aclr_saturate = aclr[saturate_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign    ena_saturate  = ena[saturate_clk] ? 1'b1 : 1'b0;
   
   assign    saturate_clk = 
	     ((saturate_clock == "0") || 
	      (saturate_clock == "none")) ? 4'b0000 :
	     (saturate_clock == "1") ? 4'b0001 :
	     (saturate_clock == "2") ? 4'b0010 :
	     (saturate_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign    saturate_aclr = 
	     ((saturate_clear == "0") || 
	      (saturate_clear == "none")) ? 4'b0000 :
	     (saturate_clear == "1") ? 4'b0001 :
	     (saturate_clear == "2") ? 4'b0010 :
	     (saturate_clear == "3") ? 4'b0011 : 4'b0000;
   
   stratixii_mac_bit_register	mode_mac_reg 
     (
      .data (mode),
      .clk (clk_mode),
      .aclr (aclr_mode),
      .if_aclr (clear_mode),
      .ena (ena_mode),
      .dataout (mode_out),
      .async (async_mode)
      );
   defparam  mode_mac_reg.data_width = 1;   
   defparam  mode_mac_reg.power_up = 1'b0;   

   assign    async_mode = (mode_clock == "none") ? 1'b1 : 1'b0;
   assign    clear_mode = (mode_clear != "none") ? 1'b1 : 1'b0;
   assign    clk_mode  = clk[mode_clk] ? 1'b1 : 1'b0;
   assign    aclr_mode = aclr[mode_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign    ena_mode  = ena[mode_clk] ? 1'b1 : 1'b0;
   
   assign    mode_clk = 
	     ((mode_clock == "0") || 
	      (mode_clock == "none")) ? 4'b0000 :
	     (mode_clock == "1") ? 4'b0001 :
	     (mode_clock == "2") ? 4'b0010 :
	     (mode_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign    mode_aclr = 
	     ((mode_clear == "0") || 
	      (mode_clear == "none")) ? 4'b0000 :
	     (mode_clear == "1") ? 4'b0001 :
	     (mode_clear == "2") ? 4'b0010 :
	     (mode_clear == "3") ? 4'b0011 : 4'b0000;
   
   stratixii_mac_bit_register	zeroacc_mac_reg 
     (
      .data (zeroacc),
      .clk (clk_zeroacc),
      .aclr (aclr_zeroacc),
      .if_aclr (clear_zeroacc),
      .ena (ena_zeroacc),
      .dataout (zeroacc_out),
      .async (async_zeroacc)
      );
   defparam  zeroacc_mac_reg.data_width = 1;   
   defparam  zeroacc_mac_reg.power_up = 1'b0;   

   assign    async_zeroacc = (zeroacc_clock == "none") ? 1'b1 : 1'b0;
   assign    clear_zeroacc = (zeroacc_clear != "none") ? 1'b1 : 1'b0;
   assign    clk_zeroacc  = clk[zeroacc_clk] ? 1'b1 : 1'b0;
   assign    aclr_zeroacc = aclr[zeroacc_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign    ena_zeroacc  = ena[zeroacc_clk] ? 1'b1 : 1'b0;
   
   assign    zeroacc_clk = 
	     ((zeroacc_clock == "0") || 
	      (zeroacc_clock == "none")) ? 4'b0000 :
	     (zeroacc_clock == "1") ? 4'b0001 :
	     (zeroacc_clock == "2") ? 4'b0010 :
	     (zeroacc_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign    zeroacc_aclr = 
	     ((zeroacc_clear == "0") || 
	      (zeroacc_clear == "none")) ? 4'b0000 :
	     (zeroacc_clear == "1") ? 4'b0001 :
	     (zeroacc_clear == "2") ? 4'b0010 :
	     (zeroacc_clear == "3") ? 4'b0011 : 4'b0000;
   
   stratixii_mac_mult_internal mac_multiply 
     (
      .dataa (scanouta_tmp[17:0]),
      .datab (scanoutb_tmp[17:0]),
      .signa (signa_internal),
      .signb (signb_internal),
      .bypass (bypass),
      .scanouta(scanouta),
      .scanoutb(scanoutb),
      .dataout(mult_output)
      );
   defparam  mac_multiply.dataa_width  = dataa_width;
   defparam  mac_multiply.datab_width  = datab_width;
   defparam  mac_multiply.dataout_width = (dataa_width+datab_width);
   defparam  mac_multiply.dynamic_mode = dynamic_mode;
   
   assign    signa_internal = ((signa_internally_grounded == "true") && (dynamic_mode == "no")) || 
	     ((signa_internally_grounded == "true") && (dynamic_mode == "yes") && 
	      (zeroacc_out[0] == 1'b1) && (mode_out[0] == 1'b0)) ? 1'b0 : signa_out[0];

   assign    signb_internal = ((signb_internally_grounded == "true") && (dynamic_mode == "no")) || 
	     ((signb_internally_grounded == "true") && (dynamic_mode == "yes") && 
	      (zeroacc_out[0] == 1'b1) && (mode_out[0] == 1'b0)) ? 1'b0 : signb_out[0];
   
   assign    bypass = ((bypass_multiplier == "yes") && (dynamic_mode == "no")) || 
	     ((bypass_multiplier == "yes") && (mode_out[0] == 1'b1) && 
	      (dynamic_mode == "yes")) ? 1'b1 : 1'b0;
         
   stratixii_mac_rs_block mac_rs_block
     (
      .operation(4'b1111),
      .round(round_out[0]),
      .saturate(saturate_out[0]),
      .addnsub(1'b0),
      .signa(signa_out[0]),
      .signb(signb_out[0]),
      .signsize(8'd2),
      .roundsize(8'd15),
      .dataoutsize(mac_mult_dataoutsize),
      .dataa({{(54){1'b0}},scanouta_tmp[17:0]}),
      .datab({{(54){1'b0}},scanoutb_tmp[17:0]}),
      .datain({{(36){1'b0}},mult_output[35:0]}),
      .dataout(dataout_rs)
      );
   defparam mac_rs_block.block_type = "mac_mult";
   defparam mac_rs_block.dataa_width = dataa_width;
   defparam mac_rs_block.datab_width = datab_width;   
   
   assign   mac_mult_dataoutsize = dataa_width + datab_width;
   
   assign   dataout_reg = (bypass == 1'b1) ? {{(36){1'b0}},mult_output[35:0]} : dataout_rs;
   
   stratixii_mac_register	dataout_mac_reg 
     (
      .data (dataout_reg),
      .clk (clk_output),
      .aclr (aclr_output),
      .if_aclr (clear_output),
      .ena (ena_output),
      .dataout (dataout_tmp),
      .async (async_output)
      );
   defparam dataout_mac_reg.data_width = (dataa_width+datab_width);
   defparam dataout_mac_reg.power_up = 1'b0;

   assign   async_output = (output_clock == "none") ? 1'b1 : 1'b0;
   assign   clear_output = (output_clear != "none") ? 1'b1 : 1'b0;
   assign   clk_output  = clk[output_clk] ? 1'b1 : 1'b0;
   assign   aclr_output = aclr[output_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign   ena_output  = ena[output_clk] ? 1'b1 : 1'b0;
   
   assign    output_clk = 
	     ((output_clock == "0") || 
	      (output_clock == "none")) ? 4'b0000 :
	     (output_clock == "1") ? 4'b0001 :
	     (output_clock == "2") ? 4'b0010 :
	     (output_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign    output_aclr = 
	     ((output_clear == "0") || 
	      (output_clear == "none")) ? 4'b0000 :
	     (output_clear == "1") ? 4'b0001 :
	     (output_clear == "2") ? 4'b0010 :
	     (output_clear == "3") ? 4'b0011 : 4'b0000;
   
endmodule

//////////////////////////////////////////////////////////////////////////////
//
//                                 STRATIXII_MAC_ADDNSUB
//
//////////////////////////////////////////////////////////////////////////////

module stratixii_mac_addnsub
  (
   dataa,
   datab,
   datac,
   datad,
   signb,
   signa,   
   operation,
   addnsub,
   dataout,
   overflow
   );

   parameter 	 dataa_width = 36;
   parameter 	 datab_width = 36;
   parameter 	 datac_width = 36;
   parameter 	 datad_width = 36;
   parameter     block_type  = "ab";
   
   // INPUTS
   input [71:0]  dataa;
   input [71:0]  datab;
   input [71:0]  datac;
   input [71:0]  datad;
   input 	 signa;   
   input 	 signb;
   input [3:0] 	 operation;
   input 	 addnsub;

   // OUTPUTS
   output [71:0] dataout;
   output 	 overflow;
   
   // REGULAR ADD/SUB
   reg 		 sa;
   reg 		 sb;
   reg [71:0] 	 abs_a;
   reg [71:0] 	 abs_b;
   reg [71:0] 	 dataout_tmp;
   reg  	 overflow_tmp;

   // 36 BIT MULT
   reg [35:0] 	 dataa_u;
   reg [35:0] 	 datab_u;
   reg [71:0] 	 datab_s;
   reg [35:0] 	 datac_u;
   reg [71:0] 	 datac_s;
   reg [35:0] 	 datad_u;
   reg [71:0] 	 datad_s;
   reg [35:0] 	 z36;
   reg [17:0] 	 z18;
   
always @ 
  (
   dataa or
   datab or
   datac or
   datad or
   signa or
   signb or
   operation or
   addnsub
   )

  begin 
     if((operation == 4'b0111) && (block_type != "sum"))
       begin 
	  z36 = 36'b0;
	  z18 = 18'b0;
	  dataa_u = dataa[35:0];
	  datab_u = datab[35:0];
	  datab_s = {{(72-36){datab[35]}}, datab[35:0]};
	  datac_u = datac[35:0];
	  datac_s = {{(72-36){datac[35]}}, datac[35:0]};
	  datad_u = datad[35:0];
	  datad_s = {{(72-36){datad[35]}}, datad[35:0]};
	  if(signa == 1'b0 && signb == 1'b0)
	    begin
	       dataout_tmp = ({datab_u[35:0],z36}) + ({datac_u[35:0],z18}) + 
			     ({datad_u[35:0],z18}) + dataa_u[35:0];
	    end // if (signa == 1'b0 && signb == 1'b0)
	  else if(signa == 1'b0 && signb == 1'b1)
	    begin
	       dataout_tmp = ({datab_s[35:0],z36}) + ({datac_u[35:0],z18}) + 
			     ({datad_s,z18}) + dataa_u[35:0];
	    end // if (signa == 1'b0 && signb == 1'b1)
	  else if(signa == 1'b1 && signb == 1'b0)
	    begin
	       dataout_tmp = ({datab_s[35:0],z36}) + ({datac_s,z18}) + 
			     ({datad_u[35:0],z18}) + dataa_u[35:0];
	    end // if (signa == 1'b1 && signb == 1'b0)
	  else if(signa == 1'b1 && signb == 1'b1)
	    begin
	       dataout_tmp = ({datab_s[35:0],z36}) + ({datac_s,z18}) + 
			     ({datad_s,z18}) + dataa_u[35:0];
	    end // if (signa == 1'b1 && signb == 1'b1)
	  overflow_tmp = 1'b0;
       end 
     // DATAA + DATAB (ACCUMULATOR)
     else if ((operation[2] == 1'b1) && (block_type == "ab")) 
       begin
	  sa    = ( signa && dataa[datab_width+15] );
	  sb    = ( signb && datab[datab_width-1] );
	  abs_a = ( signa && dataa[datab_width+15] ) ? 
		  (~dataa[datab_width+15:0] + 1'b1) : dataa[datab_width+15:0];
	  abs_b = ( signb && datab[datab_width-1] ) ? 
		  (~datab[datab_width-1:0] + 1'b1) : datab[datab_width-1:0];
	  if (addnsub == 1'b0)
	    begin
	       dataout_tmp = (sa ? -abs_a[datab_width+15:0] : abs_a[datab_width+15:0]) - 
			     (sb ? -abs_b[datab_width-1:0] : abs_b[datab_width-1:0]);
	    end
	  else
	    begin
	       dataout_tmp = (sa ? -abs_a[datab_width+15:0] : abs_a[datab_width+15:0]) + 
			     (sb ? -abs_b[datab_width-1:0] : abs_b[datab_width-1:0]);
	    end
	  if(signa || signb)
	    overflow_tmp = dataout_tmp[datab_width+16] ^ dataout_tmp[datab_width+15];
	  else
	    overflow_tmp = dataout_tmp[datab_width+16];
       end 
     // DATAC + DATAD (ACCUMULATOR)
     else if ((operation[2] == 1'b1) && (block_type == "cd")) 
       begin
	  sa    = ( signa && datac[datad_width+15] );
	  sb    = ( signb && datad[datad_width-1] );
	  abs_a = ( signa && datac[datad_width+15] ) ? 
		  (~datac[datad_width+15:0] + 1'b1) : datac[datad_width+15:0];
	  abs_b = ( signb && datad[datad_width-1] ) ? 
		  (~datad[datad_width-1:0] + 1'b1) : datad[datad_width-1:0];
	  if (addnsub == 1'b0)
	    begin
	       dataout_tmp = (sa ? -abs_a[datad_width+15:0] : abs_a[datad_width+15:0]) - 
			     (sb ? -abs_b[datad_width-1:0] : abs_b[datad_width-1:0]);
	    end
	  else
	    begin
	       dataout_tmp = (sa ? -abs_a[datad_width+15:0] : abs_a[datad_width+15:0]) + 
			     (sb ? -abs_b[datad_width-1:0] : abs_b[datad_width-1:0]);
	    end
	  if(signa || signb)
	    overflow_tmp = dataout_tmp[datad_width+16] ^ dataout_tmp[datad_width+15];
	  else
	    overflow_tmp = dataout_tmp[datad_width+16];
       end 
     // (DATAA +/- DATAB) + (DATAC +/- DATAD) (TWO LEVEL ADDER)
     else if(block_type == "sum") 
       begin
	  sa    = ( signa && dataa[dataa_width] );
	  sb    = ( signb && datab[datab_width] );
	  abs_a = ( signa && dataa[dataa_width] ) ? 
		  (~dataa[dataa_width:0] + 1'b1) : dataa[dataa_width:0];
	  abs_b = ( signb && datab[datab_width] ) ? 
		  (~datab[datab_width:0] + 1'b1) : datab[datab_width:0];
	  if (addnsub == 1'b0)
	    begin
	       dataout_tmp = (sa ? -abs_a[dataa_width:0] : abs_a[dataa_width:0]) - 
			     (sb ? -abs_b[datab_width:0] : abs_b[datab_width:0]);
	    end
	  else
	    begin
	       dataout_tmp = (sa ? -abs_a[dataa_width:0] : abs_a[dataa_width:0]) + 
			     (sb ? -abs_b[datab_width:0] : abs_b[datab_width:0]);
	    end
	  overflow_tmp = 1'b0;
       end 
     // DATAC + DATAD (ONE LEVEL ADDER)
     else if(block_type == "cd") 
       begin
	  sa    = ( signa && datac[datac_width-1] );
	  sb    = ( signb && datad[datad_width-1] );
	  abs_a = ( signa && datac[datac_width-1] ) ? 
		  (~datac[datac_width-1:0] + 1'b1) : datac[datac_width-1:0];
	  abs_b = ( signb && datad[datad_width-1] ) ? 
		  (~datad[datad_width-1:0] + 1'b1) : datad[datad_width-1:0];
	  if (addnsub == 1'b0)
	    begin
	       dataout_tmp = (sa ? -abs_a[datac_width-1:0] : abs_a[datac_width-1:0]) - 
			     (sb ? -abs_b[datad_width-1:0] : abs_b[datad_width-1:0]);
	    end
	  else
	    begin
	       dataout_tmp = (sa ? -abs_a[datac_width-1:0] : abs_a[datac_width-1:0]) + 
			     (sb ? -abs_b[datad_width-1:0] : abs_b[datad_width-1:0]);
	    end
	  if(signa || signb)
	    overflow_tmp = dataout_tmp[datac_width+1] ^ dataout_tmp[datac_width];
	  else
	    overflow_tmp = dataout_tmp[datac_width+1];
       end 
     // DATAA + DATAB (ONE LEVEL ADDER) - DEFAULT
     else 
       begin
	  sa    = ( signa && dataa[dataa_width-1] );
	  sb    = ( signb && datab[datab_width-1] );
	  abs_a = ( signa && dataa[dataa_width-1] ) ? 
		  (~dataa[dataa_width-1:0] + 1'b1) : dataa[dataa_width-1:0];
	  abs_b = ( signb && datab[datab_width-1] ) ? 
		  (~datab[datab_width-1:0] + 1'b1) : datab[datab_width-1:0];
	  if (addnsub == 1'b0)
	    begin
	       dataout_tmp = (sa ? -abs_a[dataa_width-1:0] : abs_a[dataa_width-1:0]) - 
			     (sb ? -abs_b[datab_width-1:0] : abs_b[datab_width-1:0]);
	    end
	  else
	    begin
	       dataout_tmp = (sa ? -abs_a[dataa_width-1:0] : abs_a[dataa_width-1:0]) + 
			     (sb ? -abs_b[datab_width-1:0] : abs_b[datab_width-1:0]);
	    end
	  if(signa || signb)
	    overflow_tmp = dataout_tmp[dataa_width+1] ^ dataout_tmp[dataa_width];
	  else
	    overflow_tmp = dataout_tmp[dataa_width+1];
       end 
  end 
   
   assign dataout = dataout_tmp;
   assign overflow = overflow_tmp;
   
endmodule

///////////////////////////////////////////////////////////////////////////////
//
//                            STRATIXII_MAC_DYNAMIC_SRC
//
///////////////////////////////////////////////////////////////////////////////

  module  stratixii_mac_dynamic_src
    (
     accuma,
     accumc,
     dataa,
     datab,
     datac,
     datad,
     multabsaturate,
     multcdsaturate,
     signa,
     signb,
     zeroacc,
     zeroacc1,
     operation,
     outa,
     outb,
     outc,
     outd,
     sata,
     satb,
     satc,
     satd,
     satab,
     satcd
     );

   parameter dataa_width = 36;
   parameter datab_width = 36;
   parameter datac_width = 36;
   parameter datad_width = 36;
      
   // INPUTS
   input [51:0] accuma;
   input [51:0] accumc;
   input [71:0] dataa;
   input [71:0] datab;
   input [71:0] datac;
   input [71:0] datad;
   input 	multabsaturate;
   input 	multcdsaturate;
   input 	signa;
   input 	signb;
   input 	zeroacc;
   input 	zeroacc1;
   input [3:0] 	operation;
   
   // OUTPUTS
   output [71:0] outa;
   output [71:0] outb;
   output [71:0] outc;
   output [71:0] outd;
   output 	 sata;
   output 	 satb;
   output 	 satc;
   output 	 satd;
   output 	 satab;
   output 	 satcd;
         
   reg [71:0] 	 outa_tmp;
   reg [71:0] 	 outb_tmp;
   reg [71:0] 	 outc_tmp;
   reg [71:0] 	 outd_tmp;
   reg 		 sata_tmp;
   reg 		 satb_tmp;
   reg 		 satc_tmp;
   reg 		 satd_tmp;
   reg 		 satab_tmp;
   reg 		 satcd_tmp;   
   integer 	 i;
   integer 	 j;
      
   always @ 
     (
      accuma or
      accumc or
      dataa or
      datab or
      datac or
      datad or
      multabsaturate or
      multcdsaturate or
      signa or
      signb or
      zeroacc or
      zeroacc1 or
      operation
      )
     begin
	case (operation)
	  4'b0000 :
	    begin
	       if(dataa[dataa_width-1] == 1 && signa == 1'b1)
		 outa_tmp = {{(72-dataa_width){1'b1}},dataa[dataa_width-1:0]};
	       else
		 outa_tmp = {{(72-dataa_width){1'b0}},dataa[dataa_width-1:0]};
	       if(datab[datab_width-1] == 1 && signb == 1'b1)
		 outb_tmp = {{(72-datab_width){1'b1}},datab[datab_width-1:0]};
	       else
		 outb_tmp = {{(72-datab_width){1'b0}},datab[datab_width-1:0]};
	       if(datac[datac_width-1] == 1 && signa == 1'b1)
		 outc_tmp = {{(72-datac_width){1'b1}},datac[datac_width-1:0]};
	       else
		 outc_tmp = {{(72-datac_width){1'b0}},datac[datac_width-1:0]};
	       if(datad[datad_width-1] == 1 && signb == 1'b1)
		 outd_tmp = {{(72-datad_width){1'b1}},datad[datad_width-1:0]};
	       else
		 outd_tmp = {{(72-datad_width){1'b0}},datad[datad_width-1:0]};
	    end
	  4'b0100 : // ACCUMULATOR
	    begin
	       if(zeroacc == 1'b1)
		 begin
		    // DATAA PORT
		    outa_tmp = 'b0;
		    if(dataa[dataa_width+15] == 1 && signa == 1'b1)
		       outa_tmp[71:datab_width+16] = {(72-datab_width-16){1'b1}};
		    else
		       outa_tmp[71:datab_width+16] = {(72-datab_width-16){1'b0}};
		    j = 0;
		    if(datab_width+16 > dataa_width)
		      begin
			 for(i = datab_width+16-dataa_width; i < datab_width+16; i = i + 1)
			   begin
			      outa_tmp[i] = dataa[j];
			      j = j + 1;
			   end
		      end
		    else
		      begin
			 for(i = 0; i < datab_width+15; i = i + 1)
			   begin
			      outa_tmp[i] = dataa[j];
			      j = j + 1;
			   end
		      end
		    if(datab[datab_width-1] == 1 && signb == 1'b1)
		      outb_tmp = {{(72-datab_width){1'b1}},datab[datab_width-1:0]};
		    else
		      outb_tmp = {{(72-datab_width){1'b0}},datab[datab_width-1:0]};
		    if(datac[datac_width-1] == 1 && signa == 1'b1)
		      outc_tmp = {{(72-datac_width){1'b1}},datac[datac_width-1:0]};
		    else
		      outc_tmp = {{(72-datac_width){1'b0}},datac[datac_width-1:0]};
		    if(datad[datad_width-1] == 1 && signb == 1'b1)
		      outd_tmp = {{(72-datad_width){1'b1}},datad[datad_width-1:0]};
		    else
		      outd_tmp = {{(72-datad_width){1'b0}},datad[datad_width-1:0]};
		 end
	       else
		 begin
		    if(accuma[datab_width+15] == 1 && signa == 1'b1)
		      outa_tmp = {{(72-datab_width-16){1'b1}},accuma[datab_width+15:0]};
		    else
		      outa_tmp = {{(72-datab_width-16){1'b0}},accuma[datab_width+15:0]};
		    if(datab[datab_width-1] == 1 && signb == 1'b1)
		      outb_tmp = {{(72-datab_width){1'b1}},datab[datab_width-1:0]};
		    else
		      outb_tmp = {{(72-datab_width){1'b0}},datab[datab_width-1:0]};
		    if(datac[datac_width-1] == 1 && signa == 1'b1)
		      outc_tmp = {{(72-datac_width){1'b1}},datac[datac_width-1:0]};
		    else
		      outc_tmp = {{(72-datac_width){1'b0}},datac[datac_width-1:0]};
		    if(datad[datad_width-1] == 1 && signb == 1'b1)
		      outd_tmp = {{(72-datad_width){1'b1}},datad[datad_width-1:0]};
		    else
		      outd_tmp = {{(72-datad_width){1'b0}},datad[datad_width-1:0]};
		 end
	    end
	  4'b1100 : // TWO ACCUMULATORS
	    begin
	       case ({zeroacc1, zeroacc})
		 2'b00:
		   begin
		      if(accuma[datab_width+15] == 1 && signa == 1'b1)
			outa_tmp = {{(72-datab_width-16){1'b1}},accuma[datab_width+15:0]};
		      else
			outa_tmp = {{(72-datab_width-16){1'b0}},accuma[datab_width+15:0]};
		      if(datab[datab_width-1] == 1 && signb == 1'b1)
			outb_tmp = {{(72-datab_width){1'b1}},datab[datab_width-1:0]};
		      else
			outb_tmp = {{(72-datab_width){1'b0}},datab[datab_width-1:0]};
		      if(accumc[datad_width+15] == 1 && signa == 1'b1)
			outc_tmp = {{(72-datad_width-16){1'b1}},accumc[datad_width+15:0]};
		      else
			outc_tmp = {{(72-datad_width-16){1'b0}},accumc[datad_width+15:0]};
		      if(datad[datad_width-1] == 1 && signb == 1'b1)
			outd_tmp = {{(72-datad_width){1'b1}},datad[datad_width-1:0]};
		      else
			outd_tmp = {{(72-datad_width){1'b0}},datad[datad_width-1:0]};
		   end
		 2'b01:
		   begin
		      outa_tmp = 'b0;
		      if(dataa[dataa_width+15] == 1 && signa == 1'b1)
			outa_tmp[71:datab_width+16] = {(72-datab_width-16){1'b1}};
		      else
			outa_tmp[71:datab_width+16] = {(72-datab_width-16){1'b0}};
		      j = 0;
		      if(datab_width+16 > dataa_width)
			begin
			   for(i = datab_width+16-dataa_width; i < datab_width+16; i = i + 1)
			     begin
				outa_tmp[i] = dataa[j];
				j = j + 1;
			     end
			end
		      else
			begin
			   for(i = 0; i < datab_width+15; i = i + 1)
			     begin
				outa_tmp[i] = dataa[j];
				j = j + 1;
			     end
			end
		      
		      // BIT REORDERING FOR DYNMAIC MODE ONLY
		      outa_tmp[51:0] = {dataa[15:0],dataa[35:18],dataa[17:16],16'h0000};

		      if(datab[datab_width-1] == 1 && signb == 1'b1)
			outb_tmp = {{(72-datab_width){1'b1}},datab[datab_width-1:0]};
		      else
			outb_tmp = {{(72-datab_width){1'b0}},datab[datab_width-1:0]};		 
		      if(accumc[datad_width+15] == 1 && signa == 1'b1)
			outc_tmp = {{(72-datad_width-16){1'b1}},accumc[datad_width+15:0]};
		      else
			outc_tmp = {{(72-datad_width-16){1'b0}},accumc[datad_width+15:0]};
		      if(datad[datad_width-1] == 1 && signb == 1'b1)
			outd_tmp = {{(72-datad_width){1'b1}},datad[datad_width-1:0]};
		      else
			outd_tmp = {{(72-datad_width){1'b0}},datad[datad_width-1:0]};
		   end
		 2'b10:
		   begin
		      if(accuma[datab_width+15] == 1 && signa == 1'b1)
			outa_tmp = {{(72-datab_width-16){1'b1}},accuma[datab_width+15:0]};
		      else
			outa_tmp = {{(72-datab_width-16){1'b0}},accuma[datab_width+15:0]};
		      if(datab[datab_width-1] == 1 && signb == 1'b1)
			outb_tmp = {{(72-datab_width){1'b1}},datab[datab_width-1:0]};
		      else
			outb_tmp = {{(72-datab_width){1'b0}},datab[datab_width-1:0]};
		      // DATAC PORT
		      outc_tmp = 'b0;
		      if(datac[datad_width+15] == 1 && signb == 1'b1)
			outc_tmp[71:datad_width+16] = {(72-datad_width-16){1'b1}};
		      else
			outc_tmp[71:datad_width+16] = {(72-datad_width-16){1'b0}};
		      j = 0;
		      if(datad_width+16 > datac_width)
			begin
			   for(i = datad_width+16-datac_width; i < datad_width+16; i = i + 1)
			     begin
				outc_tmp[i] = datac[j];
				j = j + 1;
			     end
			end
		      else
			begin
			   for(i = 0; i < datad_width+15; i = i + 1)
			     begin
				outc_tmp[i] = datac[j];
				j = j + 1;
			     end
			end 
		      		      
		      // BIT REORDERING FOR DYNMAIC MODE ONLY
		      outc_tmp[51:0] = {datac[15:0],datac[35:18],datac[17:16],16'h0000};
		      
		      if(datad[datad_width-1] == 1 && signb == 1'b1)
			outd_tmp = {{(72-datad_width){1'b1}},datad[datad_width-1:0]};
		      else
			outd_tmp = {{(72-datad_width){1'b0}},datad[datad_width-1:0]};
		   end
		 2'b11:
		   begin
		      // DATAA PORT
		      outa_tmp = 'b0;
		      if(dataa[dataa_width+15] == 1 && signa == 1'b1)
			outa_tmp[71:datab_width+16] = {(72-datab_width-16){1'b1}};
		      else
			outa_tmp[71:datab_width+16] = {(72-datab_width-16){1'b0}};
		      j = 0;
		      if(datab_width+16 > dataa_width)
			begin
			   for(i = datab_width+16-dataa_width; i < datab_width+16; i = i + 1)
			     begin
				outa_tmp[i] = dataa[j];
				j = j + 1;
			     end
			end
		      else
			begin
			   for(i = 0; i < datab_width+15; i = i + 1)
			     begin
				outa_tmp[i] = dataa[j];
				j = j + 1;
			     end
			end

		      // BIT REORDERING FOR DYNMAIC MODE ONLY
		      outa_tmp[51:0] = {dataa[15:0],dataa[35:18],dataa[17:16],16'h0000};
		      
		      if(datab[datab_width-1] == 1 && signb == 1'b1)
			outb_tmp = {{(72-datab_width){1'b1}},datab[datab_width-1:0]};
		      else
			outb_tmp = {{(72-datab_width){1'b0}},datab[datab_width-1:0]};
		      // DATAC PORT
		      outc_tmp = 'b0;
		      if(datac[datad_width+15] == 1 && signb == 1'b1)
			outc_tmp[71:datad_width+16] = {(72-datad_width-16){1'b1}};
		      else
			outc_tmp[71:datad_width+16] = {(72-datad_width-16){1'b0}};
		      j = 0;
		      if(datad_width+16 > datac_width)
			begin
			   for(i = datad_width+16-datac_width; i < datad_width+16; i = i + 1)
			     begin
				outc_tmp[i] = datac[j];
				j = j + 1;
			     end
			end
		      else
			begin
			   for(i = 0; i < datad_width+15; i = i + 1)
			     begin
				outc_tmp[i] = datac[j];
				j = j + 1;
			     end
			end
		      
		      // BIT REORDERING FOR DYNMAIC MODE ONLY
		      outc_tmp[51:0] = {datac[15:0],datac[35:18],datac[17:16],16'h0000};
		      
		      if(datad[datad_width-1] == 1 && signb == 1'b1)
			outd_tmp = {{(72-datad_width){1'b1}},datad[datad_width-1:0]};
		      else
			outd_tmp = {{(72-datad_width){1'b0}},datad[datad_width-1:0]};
		   end
		 default :
		   begin
		      if(accuma[datab_width+15] == 1 && signa == 1'b1)
			outa_tmp = {{(72-datab_width-16){1'b1}},accuma[datab_width+15:0]};
		      else
			outa_tmp = {{(72-datab_width-16){1'b0}},accuma[datab_width+15:0]};
		      if(datab[datab_width-1] == 1 && signb == 1'b1)
			outb_tmp = {{(72-datab_width){1'b1}},datab[datab_width-1:0]};
		      else
			outb_tmp = {{(72-datab_width){1'b0}},datab[datab_width-1:0]};
		      if(accumc[datad_width+15] == 1 && signa == 1'b1)
			outc_tmp = {{(72-datad_width-16){1'b1}},accumc[datad_width+15:0]};
		      else
			outc_tmp = {{(72-datad_width-16){1'b0}},accumc[datad_width+15:0]};
		      if(datad[datad_width-1] == 1 && signb == 1'b1)
			outd_tmp = {{(72-datad_width){1'b1}},datad[datad_width-1:0]};
		      else
			outd_tmp = {{(72-datad_width){1'b0}},datad[datad_width-1:0]};
		   end
	       endcase
	    end
	  4'b1101 :
	    begin // OUTPUT_ONLY / ACCUMULATOR
	       if(zeroacc == 1'b1)
		 begin
		    // DATAA PORT
		    outa_tmp = 'b0;
		    if(dataa[dataa_width+15] == 1 && signa == 1'b1)
		      outa_tmp[71:datab_width+16] = {(72-datab_width-16){1'b1}};
		    else
		      outa_tmp[71:datab_width+16] = {(72-datab_width-16){1'b0}};
		    j = 0;
		    if(datab_width+16 > dataa_width)
		      begin
			 for(i = datab_width+16-dataa_width; i < datab_width+16; i = i + 1)
			   begin
			      outa_tmp[i] = dataa[j];
			      j = j + 1;
			   end
		      end
		    else
		      begin
			 for(i = 0; i < datab_width+15; i = i + 1)
			   begin
			      outa_tmp[i] = dataa[j];
			      j = j + 1;
			   end
		      end 

		    // BIT REORDERING FOR DYNMAIC MODE ONLY
		    outa_tmp[51:0] = {dataa[15:0],dataa[35:18],dataa[17:16],16'h0000};
		    
		    if(datab[datab_width-1] == 1 && signb == 1'b1)
		      outb_tmp = {{(72-datab_width){1'b1}},datab[datab_width-1:0]};
		    else
		      outb_tmp = {{(72-datab_width){1'b0}},datab[datab_width-1:0]};
		    if(datac[datac_width-1] == 1 && signa == 1'b1)
		      outc_tmp = {{(72-datac_width){1'b1}},datac[datac_width-1:0]};
		    else
		      outc_tmp = {{(72-datac_width){1'b0}},datac[datac_width-1:0]};
		    if(datad[datad_width-1] == 1 && signb == 1'b1)
		      outd_tmp = {{(72-datad_width){1'b1}},datad[datad_width-1:0]};
		    else
		      outd_tmp = {{(72-datad_width){1'b0}},datad[datad_width-1:0]};
		 end
	       else
		 begin
		    if(accuma[datab_width+15] == 1 && signa == 1'b1)
		      outa_tmp = {{(72-datab_width-16){1'b1}},accuma[datab_width+15:0]};
		    else
		      outa_tmp = {{(72-datab_width-16){1'b0}},accuma[datab_width+15:0]};
		    if(datab[datab_width-1] == 1 && signb == 1'b1)
		      outb_tmp = {{(72-datab_width){1'b1}},datab[datab_width-1:0]};
		    else
		      outb_tmp = {{(72-datab_width){1'b0}},datab[datab_width-1:0]};
		    if(datac[datac_width-1] == 1 && signa == 1'b1)
		      outc_tmp = {{(72-datac_width){1'b1}},datac[datac_width-1:0]};
		    else
		      outc_tmp = {{(72-datac_width){1'b0}},datac[datac_width-1:0]};
		    if(datad[datad_width-1] == 1 && signb == 1'b1)
		      outd_tmp = {{(72-datad_width){1'b1}},datad[datad_width-1:0]};
		    else
		      outd_tmp = {{(72-datad_width){1'b0}},datad[datad_width-1:0]};
		 end
	    end
	  4'b1110 :
	    begin // ACCUMULATOR / OUTPUT_ONLY
	       if(zeroacc1 == 1'b1)
		 begin
		    if(dataa[dataa_width-1] == 1 && signa == 1'b1)
		      outa_tmp = {{(72-dataa_width){1'b1}},dataa[dataa_width-1:0]};
		    else
		      outa_tmp = {{(72-dataa_width){1'b0}},dataa[dataa_width-1:0]};
		    if(datab[datab_width-1] == 1 && signb == 1'b1)
		      outb_tmp = {{(72-datab_width){1'b1}},datab[datab_width-1:0]};
		    else
		      outb_tmp = {{(72-datab_width){1'b0}},datab[datab_width-1:0]};
		    // DATAC PORT
		    outc_tmp = 'b0;
		    if(datac[datad_width+15] == 1 && signb == 1'b1)
		      outc_tmp[71:datad_width+16] = {(72-datad_width-16){1'b1}};
		    else
		      outc_tmp[71:datad_width+16] = {(72-datad_width-16){1'b0}};
		    j = 0;
		    if(datad_width+16 > datac_width)
		      begin
			 for(i = datad_width+16-datac_width; i < datad_width+16; i = i + 1)
			   begin
			      outc_tmp[i] = datac[j];
			      j = j + 1;
			   end
		      end
		    else
		      begin
			 for(i = 0; i < datad_width+15; i = i + 1)
			   begin
			      outc_tmp[i] = datac[j];
			      j = j + 1;
			   end
		      end 
		      
		    // BIT REORDERING FOR DYNMAIC MODE ONLY
		    outc_tmp[51:0] = {datac[15:0],datac[35:18],datac[17:16],16'h0000};
		    
		    if(datad[datad_width-1] == 1 && signb == 1'b1)
		      outd_tmp = {{(72-datad_width){1'b1}},datad[datad_width-1:0]};
		    else
		      outd_tmp = {{(72-datad_width){1'b0}},datad[datad_width-1:0]};
		 end
	       else
		 begin
		    if(dataa[dataa_width-1] == 1 && signa == 1'b1)
		      outa_tmp = {{(72-dataa_width){1'b1}},dataa[dataa_width-1:0]};
		    else
		      outa_tmp = {{(72-dataa_width){1'b0}},dataa[dataa_width-1:0]};
		    if(datab[datab_width-1] == 1 && signb == 1'b1)
		      outb_tmp = {{(72-datab_width){1'b1}},datab[datab_width-1:0]};
		    else
		      outb_tmp = {{(72-datab_width){1'b0}},datab[datab_width-1:0]};		 
		    if(accumc[datad_width+15] == 1 && signa == 1'b1)
		      outc_tmp = {{(72-datad_width-16){1'b1}},accumc[datad_width+15:0]};
		    else
		      outc_tmp = {{(72-datad_width-16){1'b0}},accumc[datad_width+15:0]};
		    if(datad[datad_width-1] == 1 && signb == 1'b1)
		      outd_tmp = {{(72-datad_width){1'b1}},datad[datad_width-1:0]};
		    else
		      outd_tmp = {{(72-datad_width){1'b0}},datad[datad_width-1:0]};
		 end		 
	    end
	  default :
	    begin
	       if(dataa[dataa_width-1] == 1 && signa == 1'b1)
		 outa_tmp = {{(72-dataa_width){1'b1}},dataa[dataa_width-1:0]};
	       else
		 outa_tmp = {{(72-dataa_width){1'b0}},dataa[dataa_width-1:0]};
	       if(datab[datab_width-1] == 1 && signa == 1'b1)
		 outb_tmp = {{(72-datab_width){1'b1}},datab[datab_width-1:0]};
	       else
		 outb_tmp = {{(72-datab_width){1'b0}},datab[datab_width-1:0]};
	       if(datac[datac_width-1] == 1 && signa == 1'b1)
		 outc_tmp = {{(72-datac_width){1'b1}},datac[datac_width-1:0]};
	       else
		 outc_tmp = {{(72-datac_width){1'b0}},datac[datac_width-1:0]};
	       if(datad[datad_width-1] == 1 && signa == 1'b1)
		 outd_tmp = {{(72-datad_width){1'b1}},datad[datad_width-1:0]};
	       else
		 outd_tmp = {{(72-datad_width){1'b0}},datad[datad_width-1:0]};
	    end
	endcase // case(operation)

	// MULTABSATURATE
	if(multabsaturate)
	  begin
	     if(outa_tmp[0] == 1'b1 && ((zeroacc && operation[2]) || ~operation[2]))
	       begin
		  sata_tmp = 1'b1;
		  outa_tmp[0] = 1'b0;
	       end
	     else
	       begin
		  sata_tmp = 1'b0;
	       end
	     if(outb_tmp[0] == 1'b1)
	       begin
		  satb_tmp = 1'b1;
		  outb_tmp[0] = 1'b0;
	       end
	     else
	       begin
		  satb_tmp = 1'b0;
	       end
	  end
	else
	  begin
	     sata_tmp = 1'b0;
	     satb_tmp = 1'b0;
	  end 	
	
	// MULTCDSATURATE
	if(multcdsaturate)
	  begin
	     if(outc_tmp[0] == 1'b1 && ((zeroacc1 && operation[2]) || ~operation[2]))
	       begin
		  satc_tmp = 1'b1;
		  outc_tmp[0] = 1'b0;
	       end
	     else
	       begin
		  satc_tmp = 1'b0;
	       end
	     if(outd_tmp[0] == 1'b1)
	       begin
		  satd_tmp = 1'b1;
		  outd_tmp[0] = 1'b0;
	       end
	     else
	       begin
		  satd_tmp = 1'b0;
	       end
	  end
	else
	  begin
	     satc_tmp = 1'b0;
	     satd_tmp = 1'b0;
	  end

	// SATURATE (A || B)
	if(sata_tmp || satb_tmp)
	  satab_tmp = 1'b1;
	else
	  satab_tmp = 1'b0;

	// SATURATE (C || D)
	if(satc_tmp || satd_tmp)
	  satcd_tmp = 1'b1;
	else
	  satcd_tmp = 1'b0;
	
     end 
   
   assign outa = outa_tmp;
   assign outb = outb_tmp;
   assign outc = outc_tmp;
   assign outd = outd_tmp;
   assign sata = sata_tmp;
   assign satb = satb_tmp;
   assign satc = satc_tmp;
   assign satd = satd_tmp;
   assign satab = satab_tmp;
   assign satcd = satcd_tmp;
   
endmodule

///////////////////////////////////////////////////////////////////////////////
//
//                            STRATIXII_MAC_DYNAMIC_MUX
//
///////////////////////////////////////////////////////////////////////////////

  module   stratixii_mac_dynamic_mux
    (
     ab,
     cd,
     sata,
     satb,
     satc,
     satd,
     multsatab,
     multsatcd,
     outsatab,
     outsatcd,
     multabsaturate,
     multcdsaturate,
     saturateab,
     saturatecd,
     overab,
     overcd,
     sum,
     m36,
     bypass,
     operation,
     dataout,
     accoverflow
     );
   
   // INPUTS
   input [71:0] ab;
   input [71:0] cd;
   input 	sata;
   input 	satb;
   input 	satc;
   input 	satd;
   input 	multsatab;
   input 	multsatcd;
   input 	outsatab;
   input 	outsatcd;
   input 	multabsaturate;
   input 	multcdsaturate;
   input 	saturateab;
   input 	saturatecd;
   input 	overab;
   input 	overcd;
   input [71:0] sum;
   input [71:0] m36;
   input [143:0] bypass;
   input [3:0] 	 operation;

   // OUTPUTS
   output [143:0] dataout;
   output 	  accoverflow;
      
   reg [143:0] 	  dataout_tmp;
   reg 		  accoverflow_tmp;
      
   always @ 
     (
      ab or
      cd or
      sata or
      satb or
      satc or
      satd or
      multsatab or
      multsatcd or
      outsatab or
      outsatcd or
      multabsaturate or
      multcdsaturate or
      saturateab or
      saturatecd or
      overab or
      overcd or
      sum or
      m36 or
      bypass or
      operation
      )
     begin
	case (operation)
	  4'b0000 :
	    begin
	       dataout_tmp = bypass;
	       accoverflow_tmp = 1'b0;
	    end
	  4'b0100 : // ACCUMULATOR
	    begin
	       case ({saturateab, multabsaturate})
		 2'b00 :
		   begin
		      dataout_tmp =  {{bypass[143:72]}, ab[71:53], overab, 
				      ab[51:36], ab[35:0]};
		   end
		 2'b01 :
		   begin
		      dataout_tmp =  {{bypass[143:72]}, ab[71:53], overab, 
				      ab[51:36], ab[35:2], multsatab, ab[0]};
		   end
		 2'b10 :
		   begin
		      dataout_tmp = {{bypass[143:72]}, ab[71:53], overab, 
				     ab[51:36], ab[35:3], outsatab, ab[1:0]};
	    	   end
		 2'b11 :
		   begin
		      dataout_tmp =  {{bypass[143:72]}, ab[71:53], overab, 
				      ab[51:36], ab[35:3], outsatab, multsatab, ab[0]};
		   end
		 default :
		   begin
		      dataout_tmp =  {{bypass[143:72]}, ab[71:53], overab, 
				      ab[51:36], ab[35:0]};
		   end
	       endcase
	       accoverflow_tmp = overab;
	    end
	  4'b0001 : // ONE LEVEL ADDER
	    begin
	       if (multabsaturate)
		 dataout_tmp = {{bypass[143:72]}, ab[71:2], satb, sata};
	       else
		 dataout_tmp = {{bypass[143:72]}, ab[71:0]};
	       accoverflow_tmp = 1'b0;
	    end
	  4'b0010 : // TWO LEVEL ADDER
	    begin
	       case ({multsatcd, multsatab})
		 2'b00 :
		   begin
		      dataout_tmp = {{bypass[143:72]}, sum[71:0]};
		      accoverflow_tmp = 1'b0;
		   end
		 2'b01 :
		   begin
		      dataout_tmp = {{bypass[143:72]}, sum[71:2], satb, sata};
		      accoverflow_tmp = 1'b0;
		   end
		 2'b10 :
		   begin
		      dataout_tmp = {{bypass[143:72]}, sum[71:3], satc, sum[1:0]};
		      accoverflow_tmp = satd;		      
		   end
		 2'b11 :
		   begin
		      dataout_tmp = {{bypass[143:72]}, sum[71:3], satc, satb, sata};
		      accoverflow_tmp = satd;		      
		   end
		 default :
		   begin
		      dataout_tmp = {{bypass[143:72]}, sum[71:0]};
		      accoverflow_tmp = 1'b0;
		   end
	       endcase	       
	    end
	  4'b0111 : // 36-BIT MULTIPLY
	    begin 
	       dataout_tmp = {{bypass[143:72]}, m36};
	       accoverflow_tmp = 1'b0;
	    end 
	  4'b1100 : // TWO ACCUMULATORS
	    begin
	       case ({saturatecd, saturateab, multsatcd, multsatab})
		 4'b0000 :
		   begin
		      dataout_tmp = {cd[71:53], overcd, cd[51:0], 
				     ab[71:53], overab, ab[51:0]};
		   end
		 4'b0001 :
		   begin
		      dataout_tmp = {cd[71:53], overcd, cd[51:0], 
				     ab[71:53], overab, ab[51:2], multsatab, ab[0]};
		   end
		 4'b0010 :
		   begin
		      dataout_tmp = {cd[71:53], overcd, cd[51:2], multsatcd, cd[0],
				     ab[71:53], overab, ab[51:0]};
		   end
		 4'b0011 :
		   begin
		      dataout_tmp = {cd[71:53], overcd, cd[51:2], multsatcd, cd[0],
				     ab[71:53], overab, ab[51:2], multsatab, ab[0]};
		   end
		 4'b0100 :
		   begin
		      dataout_tmp = {cd[71:53], overcd, cd[51:0], 
				     ab[71:53], overab, ab[51:3], outsatab, ab[1:0]};
		   end
		 4'b0101 :
		   begin
		      dataout_tmp = {cd[71:53], overcd, cd[51:0], 
				     ab[71:53], overab, ab[51:3], outsatab, multsatab, ab[0]};
		   end
		 4'b0110 :
		   begin
		      dataout_tmp = {cd[71:53], overcd, cd[51:2], multsatcd, cd[0],
				     ab[71:53], overab, ab[51:3], outsatab, ab[1:0]};
		   end
		 4'b0111 :
		   begin
		      dataout_tmp = {cd[71:53], overcd, cd[51:2], multsatcd, cd[0],
				     ab[71:53], overab, ab[51:3], outsatab, multsatab, ab[0]};
		   end
		 4'b1000 :
		   begin
		      dataout_tmp = {cd[71:53], overcd, cd[51:3], outsatcd, cd[1:0], 
				     ab[71:53], overab, ab[51:0]};
		   end
		 4'b1001 :
		   begin
		      dataout_tmp = {cd[71:53], overcd, cd[51:3], outsatcd, cd[1:0], 
				     ab[71:53], overab, ab[51:2], multsatab, ab[0]};
		   end
		 4'b1010 :
		   begin
		      dataout_tmp = {cd[71:53], overcd, cd[51:3], outsatcd, multsatcd, cd[0],
				     ab[71:53], overab, ab[51:0]};
		   end
		 4'b1011 :
		   begin
		      dataout_tmp = {cd[71:53], overcd, cd[51:3], outsatcd, multsatcd, cd[0],
				     ab[71:53], overab, ab[51:2], multsatab, ab[0]};
		   end
		 4'b1100 :
		   begin
		      dataout_tmp = {cd[71:53], overcd, cd[51:3], outsatcd, cd[1:0], 
				     ab[71:53], overab, ab[51:3], outsatab, ab[1:0]};
		   end
		 4'b1101 :
		   begin
		      dataout_tmp = {cd[71:53], overcd, cd[51:3], outsatcd, cd[1:0], 
				     ab[71:53], overab, ab[51:3], outsatab, multsatab, ab[0]};
		   end
		 4'b1110 :
		   begin
		      dataout_tmp = {cd[71:53], overcd, cd[51:3], outsatcd, multsatcd, cd[0],
				     ab[71:53], overab, ab[51:3], outsatab, ab[1:0]};
		   end
		 4'b1111 :
		   begin
		      dataout_tmp = {cd[71:53], overcd, cd[51:3], outsatcd, multsatcd, cd[0],
				     ab[71:53], overab, ab[51:3], outsatab, multsatab, ab[0]};
		   end
		 default :
		   begin
		      dataout_tmp = {cd[71:53], overcd, cd[51:0],
				     ab[71:53], overab, ab[51:0]};
		   end
	       endcase	       
	       accoverflow_tmp = overab;
	    end
	  4'b1101 :
	    begin // OUTPUT ONLY / ACCUMULATOR
	       case ({saturateab, multabsaturate})
		 2'b00 :
		   begin
		      dataout_tmp =  {{bypass[143:72]}, ab[71:53], overab, 
				      ab[51:36], ab[35:0]};
		   end
		 2'b01 :
		   begin
		      dataout_tmp = {{bypass[143:72]}, 
				     ab[71:53], overab, ab[51:2], multsatab, ab[0]};
		   end
		 2'b10 :
		   begin
		      dataout_tmp = {{bypass[143:72]}, 
				     ab[71:53], overab, ab[51:3], outsatab, ab[1:0]};
		   end
		 2'b11 :
		   begin
		      dataout_tmp = {{bypass[143:72]}, 
				     ab[71:53], overab, ab[51:3], outsatab, multsatab, ab[0]};
		   end
		 default :
		   begin
		      dataout_tmp =  {{bypass[143:72]}, ab[71:53], overab, 
				      ab[51:36], ab[35:0]};
		   end
	       endcase
	       accoverflow_tmp = overab;
	    end
	  4'b1110 :
	    begin // ACCUMULATOR / OUTPUT ONLY
	       case ({saturatecd, multcdsaturate})
		 2'b00 :
		   begin
     	      dataout_tmp = {cd[71:53], overcd, cd[51:0],
				     bypass[71:0]};
		   end
		 2'b01 :
		   begin
		      dataout_tmp = {cd[71:53], overcd, cd[51:2], multsatcd, cd[0],
				     bypass[71:0]};
		   end
		 2'b10 :
		   begin
		      dataout_tmp = {cd[71:53], overcd, cd[51:3], outsatcd, cd[1:0],
				     bypass[71:0]};
		   end
		 2'b11 :
		   begin
		      dataout_tmp = {cd[71:53], overcd, cd[51:3], outsatcd, multsatcd, cd[0],
				     bypass[71:0]};
		   end
		 default :
		   begin
     	      dataout_tmp = {cd[71:53], overcd, cd[51:0],
				     bypass[71:0]};
		   end
	       endcase
	       accoverflow_tmp = overcd;
	    end
	  default : 
	    begin // OUTPUT ONLY
	       dataout_tmp = bypass;
	       accoverflow_tmp = 1'b0;
	    end
	endcase
     end 
   
   assign dataout = dataout_tmp;
   assign accoverflow = accoverflow_tmp;
      
endmodule

///////////////////////////////////////////////////////////////////////////////
//
//                            STRATIXII_MAC_OUT_INTERNAL
//
///////////////////////////////////////////////////////////////////////////////

   `timescale 1 ps/1 ps
  
  module stratixii_mac_out_internal 
    (
     dataa, 
     datab, 
     datac, 
     datad,
     mode0,
     mode1,
     roundab,
     saturateab,
     roundcd,
     saturatecd,
     multabsaturate,
     multcdsaturate,
     signx, 
     signy, 
     addnsub0, 
     addnsub1, 
     zeroacc, 
     zeroacc1,
     dataout_feedback,
     dataout, 
     accoverflow
     );
   
`define ADD 1'b1
`define SUB 1'b0
   
   parameter operation_mode = "output_only";
   parameter dataa_width = 36;
   parameter datab_width = 36;
   parameter datac_width = 36;
   parameter datad_width = 36;
   parameter dataout_width = 72; 
   
   input [35:0] dataa;
   input [35:0] datab;
   input [35:0] datac;
   input [35:0] datad;
   input 	mode0;
   input 	mode1;
   input 	roundab;
   input 	roundcd;
   input 	saturateab;
   input 	saturatecd;
   input 	multabsaturate;
   input 	multcdsaturate;
   input 	signx;
   input 	signy;
   input 	addnsub0;
   input 	addnsub1;
   input 	zeroacc;
   input 	zeroacc1;
   input [143:0] dataout_feedback;
   output [143:0] dataout;
   output 	 accoverflow;
   
   wire [143:0]  dataout_tmp;
   wire 	 accoverflow_tmp;
   wire [71:0] 	 dataa_src;
   wire [71:0] 	 datab_src;
   wire [71:0] 	 datac_src;
   wire [71:0] 	 datad_src;
   wire 	 sata;
   wire 	 satb;
   wire 	 satc;
   wire 	 satd;   
   wire 	 satab;
   wire 	 satcd;
      
   wire [71:0] 	 addnsub_ab_out;
   wire [71:0] 	 addnsub_cd_out;
   wire [71:0] 	 addnsub_sum;
   wire 	 overflow_ab;
   wire 	 overflow_cd;
   wire 	 overflow_sum;   
   
   wire [7:0] 	 rs_block_ab_size;
   wire [7:0] 	 rs_block_cd_size;
   wire [7:0] 	 rs_block_ab_sign_size;
   wire [7:0] 	 rs_block_cd_sign_size;
      
   wire [71:0] 	 dataout_low;
   wire [71:0] 	 dataout_high;
   wire [35:0] 	 dataa_ipd;
   wire [35:0] 	 datab_ipd;
   wire [35:0] 	 datac_ipd;
   wire [35:0] 	 datad_ipd;
   wire 	 saturateab_ipd;
   wire 	 saturatecd_ipd;
   wire 	 multabsaturate_ipd;
   wire 	 multcdsaturate_ipd;
   
   wire [143:0]  dataout_tbuf; 
   wire 	 accoverflow_tbuf;
   wire [3:0] 	 operation;
   wire 	 signx_or_y;
   wire      addnsub_signa_input;
   wire      addnsub_signb_input;
   wire [51:0] 	 feedback_accuma;
   wire [51:0] 	 feedback_accumc;
   wire  	 xory_addnsub0;
   wire  	 xory_addnsub1;
   
   specify
      (dataa    *> dataout) = (0,0);
      (datab    *> dataout) = (0,0);
      (datac    *> dataout) = (0,0);
      (datad    *> dataout) = (0,0);
      (signx    *> dataout) = (0,0);
      (signy    *> dataout) = (0,0);
      (mode0    *> dataout) = (0,0);
      (mode1    *> dataout) = (0,0);
      (addnsub0 *> dataout) = (0,0);
      (addnsub1 *> dataout) = (0,0);
      (zeroacc  *> dataout) = (0,0);
      (zeroacc1 *> dataout) = (0,0);
      (dataa    *> accoverflow) = (0,0);
      (signx    *> accoverflow) = (0,0);
      (signy    *> accoverflow) = (0,0);
      (mode0    *> accoverflow) = (0,0);
      (mode1    *> accoverflow) = (0,0);
      (addnsub0 *> accoverflow) = (0,0);
      (addnsub1 *> accoverflow) = (0,0);
      (zeroacc  *> accoverflow) = (0,0);
      (zeroacc1 *> accoverflow) = (0,0);
   endspecify

   // DATAA 
   buf dataa_buf0(dataa_ipd[0], dataa[0]);
   buf dataa_buf1(dataa_ipd[1], dataa[1]);
   buf dataa_buf2(dataa_ipd[2], dataa[2]);
   buf dataa_buf3(dataa_ipd[3], dataa[3]);
   buf dataa_buf4(dataa_ipd[4], dataa[4]);
   buf dataa_buf5(dataa_ipd[5], dataa[5]);
   buf dataa_buf6(dataa_ipd[6], dataa[6]);
   buf dataa_buf7(dataa_ipd[7], dataa[7]);
   buf dataa_buf8(dataa_ipd[8], dataa[8]);
   buf dataa_buf9(dataa_ipd[9], dataa[9]);
   buf dataa_buf10(dataa_ipd[10], dataa[10]);
   buf dataa_buf11(dataa_ipd[11], dataa[11]);
   buf dataa_buf12(dataa_ipd[12], dataa[12]);
   buf dataa_buf13(dataa_ipd[13], dataa[13]);
   buf dataa_buf14(dataa_ipd[14], dataa[14]);
   buf dataa_buf15(dataa_ipd[15], dataa[15]);
   buf dataa_buf16(dataa_ipd[16], dataa[16]);
   buf dataa_buf17(dataa_ipd[17], dataa[17]);
   buf dataa_buf18(dataa_ipd[18], dataa[18]);
   buf dataa_buf19(dataa_ipd[19], dataa[19]);
   buf dataa_buf20(dataa_ipd[20], dataa[20]);
   buf dataa_buf21(dataa_ipd[21], dataa[21]);
   buf dataa_buf22(dataa_ipd[22], dataa[22]);
   buf dataa_buf23(dataa_ipd[23], dataa[23]);
   buf dataa_buf24(dataa_ipd[24], dataa[24]);
   buf dataa_buf25(dataa_ipd[25], dataa[25]);
   buf dataa_buf26(dataa_ipd[26], dataa[26]);
   buf dataa_buf27(dataa_ipd[27], dataa[27]);
   buf dataa_buf28(dataa_ipd[28], dataa[28]);
   buf dataa_buf29(dataa_ipd[29], dataa[29]);
   buf dataa_buf30(dataa_ipd[30], dataa[30]);
   buf dataa_buf31(dataa_ipd[31], dataa[31]);
   buf dataa_buf32(dataa_ipd[32], dataa[32]);
   buf dataa_buf33(dataa_ipd[33], dataa[33]);
   buf dataa_buf34(dataa_ipd[34], dataa[34]);
   buf dataa_buf35(dataa_ipd[35], dataa[35]);
   // DATAB
   buf datab_buf0(datab_ipd[0], datab[0]);
   buf datab_buf1(datab_ipd[1], datab[1]);
   buf datab_buf2(datab_ipd[2], datab[2]);
   buf datab_buf3(datab_ipd[3], datab[3]);
   buf datab_buf4(datab_ipd[4], datab[4]);
   buf datab_buf5(datab_ipd[5], datab[5]);
   buf datab_buf6(datab_ipd[6], datab[6]);
   buf datab_buf7(datab_ipd[7], datab[7]);
   buf datab_buf8(datab_ipd[8], datab[8]);
   buf datab_buf9(datab_ipd[9], datab[9]);
   buf datab_buf10(datab_ipd[10], datab[10]);
   buf datab_buf11(datab_ipd[11], datab[11]);
   buf datab_buf12(datab_ipd[12], datab[12]);
   buf datab_buf13(datab_ipd[13], datab[13]);
   buf datab_buf14(datab_ipd[14], datab[14]);
   buf datab_buf15(datab_ipd[15], datab[15]);
   buf datab_buf16(datab_ipd[16], datab[16]);
   buf datab_buf17(datab_ipd[17], datab[17]);
   buf datab_buf18(datab_ipd[18], datab[18]);
   buf datab_buf19(datab_ipd[19], datab[19]);
   buf datab_buf20(datab_ipd[20], datab[20]);
   buf datab_buf21(datab_ipd[21], datab[21]);
   buf datab_buf22(datab_ipd[22], datab[22]);
   buf datab_buf23(datab_ipd[23], datab[23]);
   buf datab_buf24(datab_ipd[24], datab[24]);
   buf datab_buf25(datab_ipd[25], datab[25]);
   buf datab_buf26(datab_ipd[26], datab[26]);
   buf datab_buf27(datab_ipd[27], datab[27]);
   buf datab_buf28(datab_ipd[28], datab[28]);
   buf datab_buf29(datab_ipd[29], datab[29]);
   buf datab_buf30(datab_ipd[30], datab[30]);
   buf datab_buf31(datab_ipd[31], datab[31]);
   buf datab_buf32(datab_ipd[32], datab[32]);
   buf datab_buf33(datab_ipd[33], datab[33]);
   buf datab_buf34(datab_ipd[34], datab[34]);
   buf datab_buf35(datab_ipd[35], datab[35]);
   // DATAC
   buf datac_buf0(datac_ipd[0], datac[0]);
   buf datac_buf1(datac_ipd[1], datac[1]);
   buf datac_buf2(datac_ipd[2], datac[2]);
   buf datac_buf3(datac_ipd[3], datac[3]);
   buf datac_buf4(datac_ipd[4], datac[4]);
   buf datac_buf5(datac_ipd[5], datac[5]);
   buf datac_buf6(datac_ipd[6], datac[6]);
   buf datac_buf7(datac_ipd[7], datac[7]);
   buf datac_buf8(datac_ipd[8], datac[8]);
   buf datac_buf9(datac_ipd[9], datac[9]);
   buf datac_buf10(datac_ipd[10], datac[10]);
   buf datac_buf11(datac_ipd[11], datac[11]);
   buf datac_buf12(datac_ipd[12], datac[12]);
   buf datac_buf13(datac_ipd[13], datac[13]);
   buf datac_buf14(datac_ipd[14], datac[14]);
   buf datac_buf15(datac_ipd[15], datac[15]);
   buf datac_buf16(datac_ipd[16], datac[16]);
   buf datac_buf17(datac_ipd[17], datac[17]);
   buf datac_buf18(datac_ipd[18], datac[18]);
   buf datac_buf19(datac_ipd[19], datac[19]);
   buf datac_buf20(datac_ipd[20], datac[20]);
   buf datac_buf21(datac_ipd[21], datac[21]);
   buf datac_buf22(datac_ipd[22], datac[22]);
   buf datac_buf23(datac_ipd[23], datac[23]);
   buf datac_buf24(datac_ipd[24], datac[24]);
   buf datac_buf25(datac_ipd[25], datac[25]);
   buf datac_buf26(datac_ipd[26], datac[26]);
   buf datac_buf27(datac_ipd[27], datac[27]);
   buf datac_buf28(datac_ipd[28], datac[28]);
   buf datac_buf29(datac_ipd[29], datac[29]);
   buf datac_buf30(datac_ipd[30], datac[30]);
   buf datac_buf31(datac_ipd[31], datac[31]);
   buf datac_buf32(datac_ipd[32], datac[32]);
   buf datac_buf33(datac_ipd[33], datac[33]);
   buf datac_buf34(datac_ipd[34], datac[34]);
   buf datac_buf35(datac_ipd[35], datac[35]);
   // DATAD
   buf datad_buf0(datad_ipd[0], datad[0]);
   buf datad_buf1(datad_ipd[1], datad[1]);
   buf datad_buf2(datad_ipd[2], datad[2]);
   buf datad_buf3(datad_ipd[3], datad[3]);
   buf datad_buf4(datad_ipd[4], datad[4]);
   buf datad_buf5(datad_ipd[5], datad[5]);
   buf datad_buf6(datad_ipd[6], datad[6]);
   buf datad_buf7(datad_ipd[7], datad[7]);
   buf datad_buf8(datad_ipd[8], datad[8]);
   buf datad_buf9(datad_ipd[9], datad[9]);
   buf datad_buf10(datad_ipd[10], datad[10]);
   buf datad_buf11(datad_ipd[11], datad[11]);
   buf datad_buf12(datad_ipd[12], datad[12]);
   buf datad_buf13(datad_ipd[13], datad[13]);
   buf datad_buf14(datad_ipd[14], datad[14]);
   buf datad_buf15(datad_ipd[15], datad[15]);
   buf datad_buf16(datad_ipd[16], datad[16]);
   buf datad_buf17(datad_ipd[17], datad[17]);
   buf datad_buf18(datad_ipd[18], datad[18]);
   buf datad_buf19(datad_ipd[19], datad[19]);
   buf datad_buf20(datad_ipd[20], datad[20]);
   buf datad_buf21(datad_ipd[21], datad[21]);
   buf datad_buf22(datad_ipd[22], datad[22]);
   buf datad_buf23(datad_ipd[23], datad[23]);
   buf datad_buf24(datad_ipd[24], datad[24]);
   buf datad_buf25(datad_ipd[25], datad[25]);
   buf datad_buf26(datad_ipd[26], datad[26]);
   buf datad_buf27(datad_ipd[27], datad[27]);
   buf datad_buf28(datad_ipd[28], datad[28]);
   buf datad_buf29(datad_ipd[29], datad[29]);
   buf datad_buf30(datad_ipd[30], datad[30]);
   buf datad_buf31(datad_ipd[31], datad[31]);
   buf datad_buf32(datad_ipd[32], datad[32]);
   buf datad_buf33(datad_ipd[33], datad[33]);
   buf datad_buf34(datad_ipd[34], datad[34]);
   buf datad_buf35(datad_ipd[35], datad[35]);

   // MULT SATURATE
   buf multabsaturate_buf(multabsaturate_ipd, multabsaturate);
   buf multcdsaturate_buf(multcdsaturate_ipd, multcdsaturate);

   // MAC_OUT SATURATE
   buf saturateab_buf(saturateab_ipd, saturateab);
   buf saturatecd_buf(saturatecd_ipd, saturatecd);

   // DATAOUT
   buf dataout_buf0 (dataout[0], dataout_tbuf[0]);
   buf dataout_buf1 (dataout[1], dataout_tbuf[1]);
   buf dataout_buf2 (dataout[2], dataout_tbuf[2]);
   buf dataout_buf3 (dataout[3], dataout_tbuf[3]);
   buf dataout_buf4 (dataout[4], dataout_tbuf[4]);
   buf dataout_buf5 (dataout[5], dataout_tbuf[5]);
   buf dataout_buf6 (dataout[6], dataout_tbuf[6]);
   buf dataout_buf7 (dataout[7], dataout_tbuf[7]);
   buf dataout_buf8 (dataout[8], dataout_tbuf[8]);
   buf dataout_buf9 (dataout[9], dataout_tbuf[9]);
   buf dataout_buf10 (dataout[10], dataout_tbuf[10]);
   buf dataout_buf11 (dataout[11], dataout_tbuf[11]);
   buf dataout_buf12 (dataout[12], dataout_tbuf[12]);
   buf dataout_buf13 (dataout[13], dataout_tbuf[13]);
   buf dataout_buf14 (dataout[14], dataout_tbuf[14]);
   buf dataout_buf15 (dataout[15], dataout_tbuf[15]);
   buf dataout_buf16 (dataout[16], dataout_tbuf[16]);
   buf dataout_buf17 (dataout[17], dataout_tbuf[17]);
   buf dataout_buf18 (dataout[18], dataout_tbuf[18]);
   buf dataout_buf19 (dataout[19], dataout_tbuf[19]);
   buf dataout_buf20 (dataout[20], dataout_tbuf[20]);
   buf dataout_buf21 (dataout[21], dataout_tbuf[21]);
   buf dataout_buf22 (dataout[22], dataout_tbuf[22]);
   buf dataout_buf23 (dataout[23], dataout_tbuf[23]);
   buf dataout_buf24 (dataout[24], dataout_tbuf[24]);
   buf dataout_buf25 (dataout[25], dataout_tbuf[25]);
   buf dataout_buf26 (dataout[26], dataout_tbuf[26]);
   buf dataout_buf27 (dataout[27], dataout_tbuf[27]);
   buf dataout_buf28 (dataout[28], dataout_tbuf[28]);
   buf dataout_buf29 (dataout[29], dataout_tbuf[29]);
   buf dataout_buf30 (dataout[30], dataout_tbuf[30]);
   buf dataout_buf31 (dataout[31], dataout_tbuf[31]);
   buf dataout_buf32 (dataout[32], dataout_tbuf[32]);
   buf dataout_buf33 (dataout[33], dataout_tbuf[33]);
   buf dataout_buf34 (dataout[34], dataout_tbuf[34]);
   buf dataout_buf35 (dataout[35], dataout_tbuf[35]);
   buf dataout_buf36 (dataout[36], dataout_tbuf[36]);
   buf dataout_buf37 (dataout[37], dataout_tbuf[37]);
   buf dataout_buf38 (dataout[38], dataout_tbuf[38]);
   buf dataout_buf39 (dataout[39], dataout_tbuf[39]);
   buf dataout_buf40 (dataout[40], dataout_tbuf[40]);
   buf dataout_buf41 (dataout[41], dataout_tbuf[41]);
   buf dataout_buf42 (dataout[42], dataout_tbuf[42]);
   buf dataout_buf43 (dataout[43], dataout_tbuf[43]);
   buf dataout_buf44 (dataout[44], dataout_tbuf[44]);
   buf dataout_buf45 (dataout[45], dataout_tbuf[45]);
   buf dataout_buf46 (dataout[46], dataout_tbuf[46]);
   buf dataout_buf47 (dataout[47], dataout_tbuf[47]);
   buf dataout_buf48 (dataout[48], dataout_tbuf[48]);
   buf dataout_buf49 (dataout[49], dataout_tbuf[49]);
   buf dataout_buf50 (dataout[50], dataout_tbuf[50]);
   buf dataout_buf51 (dataout[51], dataout_tbuf[51]);
   buf dataout_buf52 (dataout[52], dataout_tbuf[52]);
   buf dataout_buf53 (dataout[53], dataout_tbuf[53]);
   buf dataout_buf54 (dataout[54], dataout_tbuf[54]);
   buf dataout_buf55 (dataout[55], dataout_tbuf[55]);
   buf dataout_buf56 (dataout[56], dataout_tbuf[56]);
   buf dataout_buf57 (dataout[57], dataout_tbuf[57]);
   buf dataout_buf58 (dataout[58], dataout_tbuf[58]);
   buf dataout_buf59 (dataout[59], dataout_tbuf[59]);
   buf dataout_buf60 (dataout[60], dataout_tbuf[60]);
   buf dataout_buf61 (dataout[61], dataout_tbuf[61]);
   buf dataout_buf62 (dataout[62], dataout_tbuf[62]);
   buf dataout_buf63 (dataout[63], dataout_tbuf[63]);
   buf dataout_buf64 (dataout[64], dataout_tbuf[64]);
   buf dataout_buf65 (dataout[65], dataout_tbuf[65]);
   buf dataout_buf66 (dataout[66], dataout_tbuf[66]);
   buf dataout_buf67 (dataout[67], dataout_tbuf[67]);
   buf dataout_buf68 (dataout[68], dataout_tbuf[68]);
   buf dataout_buf69 (dataout[69], dataout_tbuf[69]);
   buf dataout_buf70 (dataout[70], dataout_tbuf[70]);
   buf dataout_buf71 (dataout[71], dataout_tbuf[71]);
   buf dataout_buf72 (dataout[72], dataout_tbuf[72]);
   buf dataout_buf73 (dataout[73], dataout_tbuf[73]);
   buf dataout_buf74 (dataout[74], dataout_tbuf[74]);
   buf dataout_buf75 (dataout[75], dataout_tbuf[75]);
   buf dataout_buf76 (dataout[76], dataout_tbuf[76]);
   buf dataout_buf77 (dataout[77], dataout_tbuf[77]);
   buf dataout_buf78 (dataout[78], dataout_tbuf[78]);
   buf dataout_buf79 (dataout[79], dataout_tbuf[79]);
   buf dataout_buf80 (dataout[80], dataout_tbuf[80]);
   buf dataout_buf81 (dataout[81], dataout_tbuf[81]);
   buf dataout_buf82 (dataout[82], dataout_tbuf[82]);
   buf dataout_buf83 (dataout[83], dataout_tbuf[83]);
   buf dataout_buf84 (dataout[84], dataout_tbuf[84]);
   buf dataout_buf85 (dataout[85], dataout_tbuf[85]);
   buf dataout_buf86 (dataout[86], dataout_tbuf[86]);
   buf dataout_buf87 (dataout[87], dataout_tbuf[87]);
   buf dataout_buf88 (dataout[88], dataout_tbuf[88]);
   buf dataout_buf89 (dataout[89], dataout_tbuf[89]);
   buf dataout_buf90 (dataout[90], dataout_tbuf[90]);
   buf dataout_buf91 (dataout[91], dataout_tbuf[91]);
   buf dataout_buf92 (dataout[92], dataout_tbuf[92]);
   buf dataout_buf93 (dataout[93], dataout_tbuf[93]);
   buf dataout_buf94 (dataout[94], dataout_tbuf[94]);
   buf dataout_buf95 (dataout[95], dataout_tbuf[95]);
   buf dataout_buf96 (dataout[96], dataout_tbuf[96]);
   buf dataout_buf97 (dataout[97], dataout_tbuf[97]);
   buf dataout_buf98 (dataout[98], dataout_tbuf[98]);
   buf dataout_buf99 (dataout[99], dataout_tbuf[99]);
   buf dataout_buf100 (dataout[100], dataout_tbuf[100]);
   buf dataout_buf101 (dataout[101], dataout_tbuf[101]);
   buf dataout_buf102 (dataout[102], dataout_tbuf[102]);
   buf dataout_buf103 (dataout[103], dataout_tbuf[103]);
   buf dataout_buf104 (dataout[104], dataout_tbuf[104]);
   buf dataout_buf105 (dataout[105], dataout_tbuf[105]);
   buf dataout_buf106 (dataout[106], dataout_tbuf[106]);
   buf dataout_buf107 (dataout[107], dataout_tbuf[107]);
   buf dataout_buf108 (dataout[108], dataout_tbuf[108]);
   buf dataout_buf109 (dataout[109], dataout_tbuf[109]);
   buf dataout_buf110 (dataout[110], dataout_tbuf[110]);
   buf dataout_buf111 (dataout[111], dataout_tbuf[111]);
   buf dataout_buf112 (dataout[112], dataout_tbuf[112]);
   buf dataout_buf113 (dataout[113], dataout_tbuf[113]);
   buf dataout_buf114 (dataout[114], dataout_tbuf[114]);
   buf dataout_buf115 (dataout[115], dataout_tbuf[115]);
   buf dataout_buf116 (dataout[116], dataout_tbuf[116]);
   buf dataout_buf117 (dataout[117], dataout_tbuf[117]);
   buf dataout_buf118 (dataout[118], dataout_tbuf[118]);
   buf dataout_buf119 (dataout[119], dataout_tbuf[119]);
   buf dataout_buf120 (dataout[120], dataout_tbuf[120]);
   buf dataout_buf121 (dataout[121], dataout_tbuf[121]);
   buf dataout_buf122 (dataout[122], dataout_tbuf[122]);
   buf dataout_buf123 (dataout[123], dataout_tbuf[123]);
   buf dataout_buf124 (dataout[124], dataout_tbuf[124]);
   buf dataout_buf125 (dataout[125], dataout_tbuf[125]);
   buf dataout_buf126 (dataout[126], dataout_tbuf[126]);
   buf dataout_buf127 (dataout[127], dataout_tbuf[127]);
   buf dataout_buf128 (dataout[128], dataout_tbuf[128]);
   buf dataout_buf129 (dataout[129], dataout_tbuf[129]);
   buf dataout_buf130 (dataout[130], dataout_tbuf[130]);
   buf dataout_buf131 (dataout[131], dataout_tbuf[131]);
   buf dataout_buf132 (dataout[132], dataout_tbuf[132]);
   buf dataout_buf133 (dataout[133], dataout_tbuf[133]);
   buf dataout_buf134 (dataout[134], dataout_tbuf[134]);
   buf dataout_buf135 (dataout[135], dataout_tbuf[135]);
   buf dataout_buf136 (dataout[136], dataout_tbuf[136]);
   buf dataout_buf137 (dataout[137], dataout_tbuf[137]);
   buf dataout_buf138 (dataout[138], dataout_tbuf[138]);
   buf dataout_buf139 (dataout[139], dataout_tbuf[139]);
   buf dataout_buf140 (dataout[140], dataout_tbuf[140]);
   buf dataout_buf141 (dataout[141], dataout_tbuf[141]);
   buf dataout_buf142 (dataout[142], dataout_tbuf[142]);
   buf dataout_buf143 (dataout[143], dataout_tbuf[143]);
   
   buf accoverflow_buf(accoverflow, accoverflow_tbuf);

   assign 	 operation = 
		 (operation_mode == "output_only") ? 4'b0000 : 
		 (operation_mode == "one_level_adder") ? 4'b0001 : 
		 (operation_mode == "two_level_adder") ? 4'b0010 : 
		 (operation_mode == "accumulator") ? 4'b0100 :
		 (operation_mode == "36_bit_multiply") ? 4'b0111 :
		 ((operation_mode == "dynamic") && 
		  (mode0 == 1'b0) && (mode1 == 1'b0) && 
		  (zeroacc == 1'b0) && (zeroacc1 == 1'b0)) ? 4'b0000 :
		 ((operation_mode == "dynamic") &&
		  (mode0 == 1'b1) && (mode1 == 1'b1)) ? 4'b1100 :
		 ((operation_mode == "dynamic") &&
		  (mode0 == 1'b1) && (mode1 == 1'b0)) ? 4'b1101 :
		 ((operation_mode == "dynamic") &&
		  (mode0 == 1'b0) && (mode1 == 1'b1)) ? 4'b1110 :
		 ((operation_mode == "dynamic") &&
		  (mode0 == 1'b0) && (mode0 == 1'b0) && 
		  (zeroacc == 1'b1) && (zeroacc1 == 1'b1)) ? 4'b0111 : 4'b0000;
   
   stratixii_mac_dynamic_src dynamic_src
     (
      .accuma(feedback_accuma),
      .accumc(feedback_accumc),
      .dataa({{(36){1'b0}},dataa_ipd}),
      .datab({{(36){1'b0}},datab_ipd}),
      .datac({{(36){1'b0}},datac_ipd}),
      .datad({{(36){1'b0}},datad_ipd}),
      .multabsaturate(multabsaturate_ipd),
      .multcdsaturate(multcdsaturate_ipd),
      .zeroacc(zeroacc),
      .zeroacc1(zeroacc1),
      .signa(signx),
      .signb(signy),
      .operation(operation),
      .sata(sata), 
      .satb(satb), 
      .satc(satc), 
      .satd(satd), 
      .satab(satab),
      .satcd(satcd),
      .outa(dataa_src),
      .outb(datab_src),
      .outc(datac_src),
      .outd(datad_src)
      );
   defparam dynamic_src.dataa_width = dataa_width;
   defparam dynamic_src.datab_width = datab_width;
   defparam dynamic_src.datac_width = datac_width;
   defparam dynamic_src.datad_width = datad_width;   

   assign signx_or_y = signx || signy;
   assign feedback_accuma = (operation_mode == "dynamic") ? {dataout_feedback[52:37], dataout_feedback[35:0]} : 
	  dataout_feedback[51:0];
   assign feedback_accumc = (operation_mode == "dynamic") ? {dataout_feedback[124:109], dataout_feedback[107:72]} : 
	  dataout_feedback[123:72];

   assign 	 addnsub_signa_input = 
		 (operation_mode == "36_bit_multiply") ? signx :
		 ((operation_mode == "dynamic") &&
		  (mode0 == 1'b0) && (mode0 == 1'b0) && 
		  (zeroacc == 1'b1) && (zeroacc1 == 1'b1)) ? signx : signx_or_y;

   assign 	 addnsub_signb_input = 
		 (operation_mode == "36_bit_multiply") ? signy :
		 ((operation_mode == "dynamic") &&
		  (mode0 == 1'b0) && (mode0 == 1'b0) && 
		  (zeroacc == 1'b1) && (zeroacc1 == 1'b1)) ? signy : signx_or_y;
   
   stratixii_mac_addnsub addnsub_ab
     (
      .dataa(dataa_src),
      .datab(datab_src),
      .datac(datac_src),
      .datad(datad_src),
      .signa(addnsub_signa_input),
      .signb(addnsub_signb_input),
      .operation(operation),
      .addnsub(addnsub0),
      .dataout(addnsub_ab_out),
      .overflow(overflow_ab)
      );
   defparam addnsub_ab.dataa_width   = dataa_width;
   defparam addnsub_ab.datab_width   = datab_width;
   defparam addnsub_ab.datac_width   = datac_width;
   defparam addnsub_ab.datad_width   = datad_width;
   defparam addnsub_ab.block_type    = "ab";  
   
   stratixii_mac_addnsub addnsub_cd
     (
      .dataa(dataa_src),
      .datab(datab_src),
      .datac(datac_src),
      .datad(datad_src),
      .signa(signx_or_y),
      .signb(signx_or_y),
      .operation(operation),
      .addnsub(addnsub1),
      .dataout(addnsub_cd_out),
      .overflow(overflow_cd)
      );
   defparam addnsub_cd.dataa_width   = dataa_width;
   defparam addnsub_cd.datab_width   = datab_width;
   defparam addnsub_cd.datac_width   = datac_width;
   defparam addnsub_cd.datad_width   = datad_width;
   defparam addnsub_cd.block_type    = "cd";

   stratixii_mac_rs_block mac_rs_block_low
     (
      .operation(operation),
      .round(roundab),
      .saturate(saturateab_ipd),
      .addnsub(addnsub0),
      .signa(signx_or_y),
      .signb(signx_or_y),
      .signsize(rs_block_ab_sign_size),
      .roundsize(8'hf),
      .dataoutsize(rs_block_ab_size),
      .dataa(dataa_src),
      .datab(datab_src),
      .datain(addnsub_ab_out),
      .dataout(dataout_low)
      );
   defparam mac_rs_block_low.block_type    = "ab";
   defparam mac_rs_block_low.dataa_width   = dataa_width;
   defparam mac_rs_block_low.datab_width   = datab_width;

   assign   rs_block_ab_size = ((operation[2] == 1'b1) ? (datab_width + 16) :
				(operation == 4'b0001) ? (dataa_width + 1) :
				(operation == 4'b0010) ? (dataa_width + 1) : 36);

   assign   rs_block_ab_sign_size = ((operation[2] == 1'b1) ? 18 :
				     (operation == 4'b0001) || 
				     (operation == 4'b0010) ? 3 : 2);
   
   stratixii_mac_rs_block mac_rs_block_high
     (
      .operation(operation),
      .round(roundcd),
      .saturate(saturatecd_ipd),
      .addnsub(addnsub1),
      .signa(signx_or_y),
      .signb(signx_or_y),
      .signsize(rs_block_cd_sign_size),
      .roundsize(8'hf),
      .dataoutsize(rs_block_cd_size),
      .dataa(datac_src),
      .datab(datad_src),
      .datain(addnsub_cd_out),
      .dataout(dataout_high)
      );
   defparam mac_rs_block_high.block_type    = "cd";
   defparam mac_rs_block_high.dataa_width   = datac_width;
   defparam mac_rs_block_high.datab_width   = datad_width;

   assign   rs_block_cd_size = ((operation[2] == 1'b1) ? (datad_width + 16) :
				(operation == 4'b0001) ? (datac_width + 1) :
				(operation == 4'b0010) ? (datac_width + 1) : 36);

   assign   rs_block_cd_sign_size = ((operation[2] == 1'b1) ? 18 :
				     (operation == 4'b0001) || 
				     (operation == 4'b0010) ? 3 : 2);
   
   stratixii_mac_addnsub addnsub_sum_abcd
     (
      .dataa(dataout_low),
      .datab(dataout_high),
      .datac(datac_src),
      .datad(datad_src),
      .signa(xory_addnsub0),
      .signb(xory_addnsub1),
      .operation(operation),
      .addnsub(1'b1),
      .dataout(addnsub_sum),
      .overflow(overflow_sum)
      );
   defparam addnsub_sum_abcd.dataa_width   = dataa_width;
   defparam addnsub_sum_abcd.datab_width   = dataa_width;
   defparam addnsub_sum_abcd.datac_width   = datac_width;
   defparam addnsub_sum_abcd.datad_width   = datad_width;
   defparam addnsub_sum_abcd.block_type    = "sum";

   assign   xory_addnsub0 = signx_or_y || ~addnsub0;
   assign   xory_addnsub1 = signx_or_y || ~addnsub1;
      
   stratixii_mac_dynamic_mux dynamic_mux
     (
      .ab(dataout_low),
      .cd(dataout_high),
      .sata(sata),
      .satb(satb),
      .satc(satc),
      .satd(satd),
      .multsatab(satab),
      .multsatcd(satcd),
      .outsatab(dataout_low[2]),
      .outsatcd(dataout_high[2]),
      .multabsaturate(multabsaturate_ipd),
      .multcdsaturate(multcdsaturate_ipd),
      .saturateab(saturateab_ipd),
      .saturatecd(saturatecd_ipd),
      .overab(overflow_ab),
      .overcd(overflow_cd),
      .sum(addnsub_sum),
      .m36(addnsub_ab_out),
      .bypass({datad_ipd,datac_ipd,datab_ipd,dataa_ipd}),
      .operation(operation),
      .dataout(dataout_tmp),
      .accoverflow(accoverflow_tmp)
      );

   assign   dataout_tbuf = dataout_tmp;
   assign   accoverflow_tbuf = accoverflow_tmp;
      
endmodule 

///////////////////////////////////////////////////////////////////////////////
//
//                             STRATIXII_MAC_PIN_MAP
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
  
  module   stratixii_mac_pin_map
    (
     datain,
     addnsub,
     operation,
     dataout
     );
   parameter  operation_mode = "output_only";
   parameter  type = "map";
   
   input [143:0] datain;
   input [3:0] 	 operation;
   input  addnsub;
   output [143:0] dataout;
   
   reg [143:0] 	  dataout_tmp;
   wire [3:0] 	  operation;

   buf (addnsub_in, addnsub);
   
   always @ (datain or addnsub_in)
     begin
	if(operation_mode == "dynamic")
	  begin
	     if(type == "map")
	       begin
		  case (operation)
		    4'b1100 : // TWO ACCUMULATORS
		      begin
			 dataout_tmp = {19'bX, datain[123:108], 
					1'bX, datain[107:72],
					19'bX, datain[51:36], 
					1'bX, datain[35:0]};
		      end
		    4'b1101 :
		      begin // OUTPUT ONLY / ACCUMULATOR
			 dataout_tmp = {datain[143:72], 19'bX, datain[51:36], 1'bX, datain[35:0]};
		      end
		    4'b1110 :
		      begin // ACCUMULATOR / OUTPUT ONLY
	       		 dataout_tmp = {19'bX, datain[123:108], 1'bX, datain[107:0]};
		      end
		    4'b0111 :
		      begin // 36 BIT MULTIPLY
			 dataout_tmp[17:0] = (addnsub_in === 1'b1) ? datain[17:0] : 18'bX;
			 dataout_tmp[35:18] = (addnsub_in === 1'b1) ? datain[53:36] : 18'bX;
			 dataout_tmp[53:36] = (addnsub_in === 1'b1) ? datain[35:18] : 18'bX;
			 dataout_tmp[71:54] = (addnsub_in === 1'b1) ? datain[71:54] : 18'bX;
			 dataout_tmp[143:72] = 72'bX;
		      end
		    default :
		      dataout_tmp = datain;
		  endcase // case(operation)
	       end // if (type == "map")
	     else // "unmap"
	       begin
		  case (operation)
		    4'b1100 : // TWO ACCUMULATORS
		      begin
			 dataout_tmp[35:0]    = datain[35:0];
			 dataout_tmp[70:36]   = datain[71:37];
			 dataout_tmp[107:72]  = datain[107:72];
			 dataout_tmp[142:108] = datain[143:109];
 		      end
		    4'b1101 :
		      begin // OUTPUT ONLY / ACCUMULATOR
			 dataout_tmp[35:0]   = datain[35:0];
			 dataout_tmp[70:36]  = datain[71:37];
			 dataout_tmp[143:72] = datain[143:72];
		      end
		    4'b1110 :
		      begin // ACCUMULATOR / OUTPUT ONLY
			 dataout_tmp[107:0]   = datain[107:0];
			 dataout_tmp[107:72]  = datain[107:72];
			 dataout_tmp[142:108] = datain[143:109];
	       	      end
		    4'b0111 :
		      begin // 36 BIT MULTIPLY
			 dataout_tmp[17:0]  = datain[17:0];
			 dataout_tmp[53:36] = datain[35:18];
			 dataout_tmp[35:18] = datain[53:36];
			 dataout_tmp[71:54] = datain[71:54];
			 dataout_tmp[143:72] = 72'bX;
		      end
		    default :
		      dataout_tmp = datain;
		  endcase
	       end
	  end 
	else // DEFAULT
	  dataout_tmp = datain;
     end
   
   assign dataout = dataout_tmp;
      
endmodule

///////////////////////////////////////////////////////////////////////////////
//
//                               STRATIXII_MAC_OUT
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
  
  module stratixii_mac_out	
    (
     dataa, 
     datab, 
     datac, 
     datad, 
     zeroacc, 
     addnsub0, 
     addnsub1,
     round0,
     round1,
     saturate,
     multabsaturate,
     multcdsaturate,
     signa, 
     signb, 
     clk, 
     aclr, 
     ena,
     mode0,
     mode1,
     zeroacc1,
     saturate1,
     dataout, 
     accoverflow,
     devclrn, 
     devpor
     );
   
`define ADD 1'b1
`define SUB 1'b0
   
   parameter operation_mode = "output_only";
   parameter dataa_width = 36;
   parameter datab_width = 36;
   parameter datac_width = 36;
   parameter datad_width = 36;
   parameter dataout_width = 72;
   parameter addnsub0_clock = "none";
   parameter addnsub1_clock = "none";
   parameter zeroacc_clock = "none";
   parameter round0_clock      = "none";
   parameter round1_clock      = "none";
   parameter saturate_clock    = "none";
   parameter multabsaturate_clock = "none";
   parameter multcdsaturate_clock = "none"; 
   parameter signa_clock = "none";
   parameter signb_clock = "none";
   parameter output_clock = "none";
   parameter addnsub0_clear = "none";
   parameter addnsub1_clear = "none";
   parameter zeroacc_clear = "none"; 
   parameter round0_clear = "none";
   parameter round1_clear = "none";
   parameter saturate_clear = "none";
   parameter multabsaturate_clear = "none";
   parameter multcdsaturate_clear = "none";
   parameter signa_clear = "none";
   parameter signb_clear = "none";
   parameter output_clear = "none";
   parameter addnsub0_pipeline_clock = "none";
   parameter addnsub1_pipeline_clock = "none";
   parameter round0_pipeline_clock     = "none";
   parameter round1_pipeline_clock     = "none";
   parameter saturate_pipeline_clock   = "none";
   parameter multabsaturate_pipeline_clock = "none";
   parameter multcdsaturate_pipeline_clock = "none";
   parameter zeroacc_pipeline_clock = "none";
   parameter signa_pipeline_clock = "none";
   parameter signb_pipeline_clock = "none";
   parameter addnsub0_pipeline_clear = "none";
   parameter addnsub1_pipeline_clear = "none";
   parameter round0_pipeline_clear     = "none";
   parameter round1_pipeline_clear     = "none";
   parameter saturate_pipeline_clear   = "none";
   parameter multabsaturate_pipeline_clear = "none";
   parameter multcdsaturate_pipeline_clear = "none";
   parameter zeroacc_pipeline_clear = "none";
   parameter signa_pipeline_clear = "none";
   parameter signb_pipeline_clear = "none";
   parameter mode0_clock       = "none";
   parameter mode1_clock       = "none";
   parameter zeroacc1_clock    = "none";
   parameter saturate1_clock   = "none";
   parameter output1_clock     = "none";
   parameter output2_clock     = "none";
   parameter output3_clock     = "none";
   parameter output4_clock     = "none";
   parameter output5_clock     = "none";
   parameter output6_clock     = "none";
   parameter output7_clock     = "none";
   parameter mode0_clear       = "none";
   parameter mode1_clear       = "none";
   parameter zeroacc1_clear    = "none";
   parameter saturate1_clear   = "none";
   parameter output1_clear     = "none";
   parameter output2_clear     = "none";
   parameter output3_clear     = "none";
   parameter output4_clear     = "none";
   parameter output5_clear     = "none";
   parameter output6_clear     = "none";
   parameter output7_clear     = "none";
   parameter mode0_pipeline_clock     = "none";
   parameter mode1_pipeline_clock     = "none";
   parameter zeroacc1_pipeline_clock  = "none";
   parameter saturate1_pipeline_clock = "none";
   parameter mode0_pipeline_clear     = "none";
   parameter mode1_pipeline_clear     = "none";
   parameter zeroacc1_pipeline_clear  = "none";
   parameter saturate1_pipeline_clear = "none";
   parameter dataa_forced_to_zero      = "no";
   parameter datac_forced_to_zero      = "no";
   parameter lpm_hint           = "true";
   parameter lpm_type           = "stratixii_mac_out";
   
   input [35:0] dataa;
   input [35:0] datab;
   input [35:0] datac;
   input [35:0] datad;
   input 	zeroacc;
   input 	addnsub0;
   input 	addnsub1;
   input 	round0;
   input 	round1;
   input 	saturate;
   input 	saturate1;
   input 	mode0;
   input 	mode1;
   input 	zeroacc1;
   input 	multabsaturate;
   input 	multcdsaturate;
   input 	signa;
   input 	signb;
   input [3:0] 	clk;
   input [3:0] 	aclr;
   input [3:0] 	ena;
   input 	devclrn;
   input 	devpor;
   output [143:0] dataout; 
   output 	 accoverflow;

   tri0 	 saturate;
   tri0 	 saturate1;
      
   wire [35:0] 	 dataa_f;
   wire [35:0] 	 datac_f;
   wire [0:0] 	 signa_pipe;
   wire [0:0] 	 signb_pipe;
   wire [0:0] 	 multabsaturate_pipe;
   wire [0:0] 	 multcdsaturate_pipe;
   wire [0:0] 	 signa_out;
   wire [0:0] 	 signb_out;
   wire [0:0] 	 multabsaturate_out;
   wire [0:0] 	 multcdsaturate_out;
   wire [0:0] 	 addnsub0_pipe;
   wire [0:0] 	 addnsub1_pipe;
   wire [0:0] 	 addnsub0_out;
   wire [0:0] 	 addnsub1_out;
   wire [0:0] 	 zeroacc_pipe;
   wire [0:0] 	 zeroacc1_pipe;
   wire [0:0] 	 zeroacc_out;
   wire [0:0] 	 zeroacc1_out;
   wire [143:0]  dataout_feedback;
   wire [143:0]  dataout_tmp;
   wire [143:0]  dataout_map;
   wire [143:0]  dataout_mapped;
   wire [143:0]  dataout_unmapped; 
   wire [143:0]  dataout_non_dynamic;
   wire [143:0]  dataout_dynamic;
   wire [71:0] 	 dataout_dynamic1;
   wire [71:0] 	 dataout_dynamic2;
   wire [71:0] 	 dataout_dynamic3;
   wire [71:0] 	 dataout_dynamic4;
   wire [71:0] 	 dataout_dynamic5;
   wire [71:0] 	 dataout_dynamic6;
   wire [71:0] 	 dataout_dynamic7;	
   wire [71:0] 	 dataout_tmp_low;
   wire [71:0] 	 dataout_tmp_high;
   wire [143:0]  dataout_to_reg;
   wire 	 accoverflow_reg;
   wire [0:0] 	 accoverflow_tmp;
   wire [3:0] 	 operation;
   wire 	 devclrn, devpor;
   wire [0:0] 	 round0_pipe;
   wire [0:0] 	 round1_pipe;
   wire [0:0] 	 saturate_pipe;
   wire [0:0] 	 saturate1_pipe;
   wire [0:0] 	 mode0_pipe;
   wire [0:0] 	 mode1_pipe;
   wire [0:0] 	 round0_out;
   wire [0:0] 	 round1_out;
   wire [0:0] 	 saturate_out;
   wire [0:0] 	 saturate1_out;
   wire [0:0] 	 mode0_out;
   wire [0:0] 	 mode1_out;

   wire [3:0] 	 addnsub0_clk;
   wire [3:0] 	 addnsub1_clk;
   wire [3:0] 	 zeroacc_clk;
   wire [3:0] 	 round0_clk;
   wire [3:0] 	 round1_clk;
   wire [3:0] 	 saturate_clk;
   wire [3:0] 	 multabsaturate_clk;
   wire [3:0] 	 multcdsaturate_clk;
   wire [3:0] 	 signa_clk;
   wire [3:0] 	 signb_clk;
   wire [3:0] 	 output_clk;
   wire [3:0] 	 addnsub0_aclr;
   wire [3:0] 	 addnsub1_aclr;
   wire [3:0] 	 zeroacc_aclr; 
   wire [3:0] 	 round0_aclr;
   wire [3:0] 	 round1_aclr;
   wire [3:0] 	 saturate_aclr;
   wire [3:0] 	 multabsaturate_aclr;
   wire [3:0] 	 multcdsaturate_aclr;
   wire [3:0] 	 signa_aclr;
   wire [3:0] 	 signb_aclr;
   wire [3:0] 	 output_aclr;
   wire [3:0] 	 addnsub0_pipeline_clk;
   wire [3:0] 	 addnsub1_pipeline_clk;
   wire [3:0] 	 round0_pipeline_clk;
   wire [3:0] 	 round1_pipeline_clk;
   wire [3:0] 	 saturate_pipeline_clk;
   wire [3:0] 	 multabsaturate_pipeline_clk;
   wire [3:0] 	 multcdsaturate_pipeline_clk;
   wire [3:0] 	 zeroacc_pipeline_clk;
   wire [3:0] 	 signa_pipeline_clk;
   wire [3:0] 	 signb_pipeline_clk;
   wire [3:0] 	 addnsub0_pipeline_aclr;
   wire [3:0] 	 addnsub1_pipeline_aclr;
   wire [3:0] 	 round0_pipeline_aclr;
   wire [3:0] 	 round1_pipeline_aclr;
   wire [3:0] 	 saturate_pipeline_aclr;
   wire [3:0] 	 multabsaturate_pipeline_aclr;
   wire [3:0] 	 multcdsaturate_pipeline_aclr;
   wire [3:0] 	 zeroacc_pipeline_aclr;
   wire [3:0] 	 signa_pipeline_aclr;
   wire [3:0] 	 signb_pipeline_aclr;
   wire [3:0] 	 mode0_clk;
   wire [3:0] 	 mode1_clk;
   wire [3:0] 	 zeroacc1_clk;
   wire [3:0] 	 saturate1_clk;
   wire [3:0] 	 output1_clk;
   wire [3:0] 	 output2_clk;
   wire [3:0] 	 output3_clk;
   wire [3:0] 	 output4_clk;
   wire [3:0] 	 output5_clk;
   wire [3:0] 	 output6_clk;
   wire [3:0] 	 output7_clk;
   wire [3:0] 	 mode0_aclr;
   wire [3:0] 	 mode1_aclr;
   wire [3:0] 	 zeroacc1_aclr;
   wire [3:0] 	 saturate1_aclr;
   wire [3:0] 	 output1_aclr;
   wire [3:0] 	 output2_aclr;
   wire [3:0] 	 output3_aclr;
   wire [3:0] 	 output4_aclr;
   wire [3:0] 	 output5_aclr;
   wire [3:0] 	 output6_aclr;
   wire [3:0] 	 output7_aclr;
   wire [3:0] 	 mode0_pipeline_clk;
   wire [3:0] 	 mode1_pipeline_clk;
   wire [3:0] 	 zeroacc1_pipeline_clk;
   wire [3:0] 	 saturate1_pipeline_clk;
   wire [3:0] 	 mode0_pipeline_aclr;
   wire [3:0] 	 mode1_pipeline_aclr;
   wire [3:0] 	 zeroacc1_pipeline_aclr;
   wire [3:0] 	 saturate1_pipeline_aclr;

   wire 	 clk_signa;
   wire 	 clear_signa;
   wire 	 aclr_signa;
   wire 	 ena_signa;
   wire 	 async_signa;   
   wire 	 clk_signb;
   wire 	 clear_signb;
   wire 	 aclr_signb;
   wire 	 ena_signb;
   wire 	 async_signb;   
   wire 	 clk_zeroacc;
   wire 	 clear_zeroacc;
   wire 	 aclr_zeroacc;
   wire 	 ena_zeroacc;
   wire 	 async_zeroacc;   
   wire 	 clk_zeroacc1;
   wire 	 clear_zeroacc1;
   wire 	 aclr_zeroacc1;
   wire 	 ena_zeroacc1;
   wire 	 async_zeroacc1;   
   wire 	 clk_addnsub0;
   wire 	 clear_addnsub0;
   wire 	 aclr_addnsub0;
   wire 	 ena_addnsub0;
   wire 	 async_addnsub0;   
   wire 	 clk_addnsub1;
   wire 	 clear_addnsub1;
   wire 	 aclr_addnsub1;
   wire 	 ena_addnsub1;
   wire 	 async_addnsub1;   
   wire 	 clk_round0;
   wire 	 clear_round0;
   wire 	 aclr_round0;
   wire 	 ena_round0;
   wire 	 async_round0;   
   wire 	 clk_saturate;
   wire 	 clear_saturate;
   wire 	 aclr_saturate;
   wire 	 ena_saturate;
   wire 	 async_saturate;   
   wire 	 clk_mode0;
   wire 	 clear_mode0;
   wire 	 aclr_mode0;
   wire 	 ena_mode0;
   wire 	 async_mode0;   
   wire 	 clk_round1;
   wire 	 clear_round1;
   wire 	 aclr_round1;
   wire 	 ena_round1;
   wire 	 async_round1;   
   wire 	 clk_saturate1;
   wire 	 clear_saturate1;
   wire 	 aclr_saturate1;
   wire 	 ena_saturate1;
   wire 	 async_saturate1;   
   wire 	 clk_mode1;
   wire 	 clear_mode1;
   wire 	 aclr_mode1;
   wire 	 ena_mode1;
   wire 	 async_mode1;   
   wire 	 clk_multabsaturate;
   wire 	 clear_multabsaturate;
   wire 	 aclr_multabsaturate;
   wire 	 ena_multabsaturate;
   wire 	 async_multabsaturate;   
   wire 	 clk_multcdsaturate;
   wire 	 clear_multcdsaturate;
   wire 	 aclr_multcdsaturate;
   wire 	 ena_multcdsaturate;
   wire 	 async_multcdsaturate;   
   wire 	 clk_signa_pipeline;
   wire 	 clear_signa_pipeline;
   wire 	 aclr_signa_pipeline;
   wire 	 ena_signa_pipeline;
   wire 	 async_signa_pipeline;   
   wire 	 clk_signb_pipeline;
   wire 	 clear_signb_pipeline;
   wire 	 aclr_signb_pipeline;
   wire 	 ena_signb_pipeline;
   wire 	 async_signb_pipeline;   
   wire 	 clk_zeroacc_pipeline;
   wire 	 clear_zeroacc_pipeline;
   wire 	 aclr_zeroacc_pipeline;
   wire 	 ena_zeroacc_pipeline;
   wire 	 async_zeroacc_pipeline;   
   wire 	 clk_zeroacc1_pipeline;
   wire 	 clear_zeroacc1_pipeline;
   wire 	 aclr_zeroacc1_pipeline;
   wire 	 ena_zeroacc1_pipeline;
   wire 	 async_zeroacc1_pipeline;   
   wire 	 clk_addnsub0_pipeline;
   wire 	 clear_addnsub0_pipeline;
   wire 	 aclr_addnsub0_pipeline;
   wire 	 ena_addnsub0_pipeline;
   wire 	 async_addnsub0_pipeline;   
   wire 	 clk_addnsub1_pipeline;
   wire 	 clear_addnsub1_pipeline;
   wire 	 aclr_addnsub1_pipeline;
   wire 	 ena_addnsub1_pipeline;
   wire 	 async_addnsub1_pipeline;   
   wire 	 clk_round0_pipeline;
   wire 	 clear_round0_pipeline;
   wire 	 aclr_round0_pipeline;
   wire 	 ena_round0_pipeline;
   wire 	 async_round0_pipeline;   
   wire 	 clk_saturate_pipeline;
   wire 	 clear_saturate_pipeline;
   wire 	 aclr_saturate_pipeline;
   wire 	 ena_saturate_pipeline;
   wire 	 async_saturate_pipeline;   
   wire 	 clk_mode0_pipeline;
   wire 	 clear_mode0_pipeline;
   wire 	 aclr_mode0_pipeline;
   wire 	 ena_mode0_pipeline;
   wire 	 async_mode0_pipeline;   
   wire 	 clk_round1_pipeline;
   wire 	 clear_round1_pipeline;
   wire 	 aclr_round1_pipeline;
   wire 	 ena_round1_pipeline;
   wire 	 async_round1_pipeline;   
   wire 	 clk_saturate1_pipeline;
   wire 	 clear_saturate1_pipeline;
   wire 	 aclr_saturate1_pipeline;
   wire 	 ena_saturate1_pipeline;
   wire 	 async_saturate1_pipeline;   
   wire 	 clk_mode1_pipeline;
   wire 	 clear_mode1_pipeline;
   wire 	 aclr_mode1_pipeline;
   wire 	 ena_mode1_pipeline;
   wire 	 async_mode1_pipeline;   
   wire 	 clk_multabsaturate_pipeline;
   wire 	 clear_multabsaturate_pipeline;
   wire 	 aclr_multabsaturate_pipeline;
   wire 	 ena_multabsaturate_pipeline;
   wire 	 async_multabsaturate_pipeline;   
   wire 	 clk_multcdsaturate_pipeline;
   wire 	 clear_multcdsaturate_pipeline;
   wire 	 aclr_multcdsaturate_pipeline;
   wire 	 ena_multcdsaturate_pipeline;
   wire 	 async_multcdsaturate_pipeline;   
   wire 	 clk_output;
   wire 	 clear_output;
   wire 	 aclr_output;
   wire 	 ena_output;
   wire 	 async_output;   
   wire 	 clk_output1;
   wire 	 clear_output1;
   wire 	 aclr_output1;
   wire 	 ena_output1;
   wire 	 async_output1;   
   wire 	 clk_output2;
   wire 	 clear_output2;
   wire 	 aclr_output2;
   wire 	 ena_output2;
   wire 	 async_output2;   
   wire 	 clk_output3;
   wire 	 clear_output3;
   wire 	 aclr_output3;
   wire 	 ena_output3;
   wire 	 async_output3;   
   wire 	 clk_output4;
   wire 	 clear_output4;
   wire 	 aclr_output4;
   wire 	 ena_output4;
   wire 	 async_output4;   
   wire 	 clk_output5;
   wire 	 clear_output5;
   wire 	 aclr_output5;
   wire 	 ena_output5;
   wire 	 async_output5;   
   wire 	 clk_output6;
   wire 	 clear_output6;
   wire 	 aclr_output6;
   wire 	 ena_output6;
   wire 	 async_output6;   
   wire 	 clk_output7;
   wire 	 clear_output7;
   wire 	 aclr_output7;
   wire 	 ena_output7;
   wire 	 async_output7;   
   
   stratixii_mac_bit_register	signa_mac_reg 
     (
      .data (signa),
      .clk (clk_signa),
      .aclr (aclr_signa),
      .if_aclr (clear_signa),
      .ena (ena_signa),
      .dataout (signa_pipe),
      .async (async_signa)
      );
   defparam 	 signa_mac_reg.data_width = 1;
   defparam 	 signa_mac_reg.power_up = 1'b0;

   assign 	 async_signa = (signa_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_signa = (signa_clear != "none") ? 1'b1 : 1'b0;
   assign 	 clk_signa  = clk[signa_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_signa = aclr[signa_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign 	 ena_signa  = ena[signa_clk] ? 1'b1 : 1'b0;
   
   assign 	 signa_clk = 
		 ((signa_clock == "0") || 
		  (signa_clock == "none")) ? 4'b0000 :
		 (signa_clock == "1") ? 4'b0001 :
		 (signa_clock == "2") ? 4'b0010 :
		 (signa_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 signa_aclr = 
		 ((signa_clear == "0") || 
		  (signa_clear == "none")) ? 4'b0000 :
		 (signa_clear == "1") ? 4'b0001 :
		 (signa_clear == "2") ? 4'b0010 :
		 (signa_clear == "3") ? 4'b0011 : 4'b0000;

   stratixii_mac_bit_register	signb_mac_reg 
     (
      .data (signb),
      .clk (clk_signb),
      .aclr (aclr_signb),
      .if_aclr (clear_signb),
      .ena (ena_signb),
      .dataout (signb_pipe),
      .async (async_signb)
      );
   defparam 	 signb_mac_reg.data_width = 1;
   defparam 	 signb_mac_reg.power_up = 1'b0;

   assign 	 async_signb = (signb_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_signb = (signb_clear != "none") ? 1'b1 : 1'b0;
   assign 	 clk_signb  = clk[signb_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_signb = aclr[signb_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign 	 ena_signb  = ena[signb_clk] ? 1'b1 : 1'b0;
   
   assign 	 signb_clk = 
		 ((signb_clock == "0") || 
		  (signb_clock == "none")) ? 4'b0000 :
		 (signb_clock == "1") ? 4'b0001 :
		 (signb_clock == "2") ? 4'b0010 :
		 (signb_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 signb_aclr = 
		 ((signb_clear == "0") || 
		  (signb_clear == "none")) ? 4'b0000 :
		 (signb_clear == "1") ? 4'b0001 :
		 (signb_clear == "2") ? 4'b0010 :
		 (signb_clear == "3") ? 4'b0011 : 4'b0000;
   
   stratixii_mac_bit_register	zeroacc_mac_reg 
     (
      .data (zeroacc),
      .clk (clk_zeroacc),
      .aclr (aclr_zeroacc),
      .if_aclr (clear_zeroacc),
      .ena (ena_zeroacc),
      .dataout (zeroacc_pipe),
      .async (async_zeroacc)
      );
   defparam 	 zeroacc_mac_reg.data_width = 1;
   defparam 	 zeroacc_mac_reg.power_up = 1'b0;

   assign 	 async_zeroacc = (zeroacc_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_zeroacc = (zeroacc_clear != "none") ? 1'b1 : 1'b0;
   assign 	 clk_zeroacc  = clk[zeroacc_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_zeroacc = aclr[zeroacc_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign 	 ena_zeroacc  = ena[zeroacc_clk] ? 1'b1 : 1'b0;
   
   assign 	 zeroacc_clk = 
		 ((zeroacc_clock == "0") || 
		  (zeroacc_clock == "none")) ? 4'b0000 :
		 (zeroacc_clock == "1") ? 4'b0001 :
		 (zeroacc_clock == "2") ? 4'b0010 :
		 (zeroacc_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 zeroacc_aclr = 
		 ((zeroacc_clear == "0") || 
		  (zeroacc_clear == "none")) ? 4'b0000 :
		 (zeroacc_clear == "1") ? 4'b0001 :
		 (zeroacc_clear == "2") ? 4'b0010 :
		 (zeroacc_clear == "3") ? 4'b0011 : 4'b0000;
   
   stratixii_mac_bit_register	zeroacc1_mac_reg 
     (
      .data (zeroacc1),
      .clk (clk_zeroacc1),
      .aclr (aclr_zeroacc1),
      .if_aclr (clear_zeroacc1),
      .ena (ena_zeroacc1),
      .dataout (zeroacc1_pipe),
      .async (async_zeroacc1)
      );
   defparam 	 zeroacc1_mac_reg.data_width = 1;
   defparam 	 zeroacc1_mac_reg.power_up = 1'b0;

   assign 	 async_zeroacc1 = (zeroacc1_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_zeroacc1 = (zeroacc1_clear != "none") ? 1'b1 : 1'b0;
   assign 	 clk_zeroacc1  = clk[zeroacc1_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_zeroacc1 = aclr[zeroacc1_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign 	 ena_zeroacc1  = ena[zeroacc1_clk] ? 1'b1 : 1'b0;
   
   assign 	 zeroacc1_clk = 
		 ((zeroacc1_clock == "0") || 
		  (zeroacc1_clock == "none")) ? 4'b0000 :
		 (zeroacc1_clock == "1") ? 4'b0001 :
		 (zeroacc1_clock == "2") ? 4'b0010 :
		 (zeroacc1_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 zeroacc1_aclr = 
		 ((zeroacc1_clear == "0") || 
		  (zeroacc1_clear == "none")) ? 4'b0000 :
		 (zeroacc1_clear == "1") ? 4'b0001 :
		 (zeroacc1_clear == "2") ? 4'b0010 :
		 (zeroacc1_clear == "3") ? 4'b0011 : 4'b0000;
   
   stratixii_mac_bit_register	addnsub0_mac_reg 
     (
      .data (addnsub0),
      .clk (clk_addnsub0),
      .aclr (aclr_addnsub0),
      .if_aclr (clear_addnsub0),
      .ena (ena_addnsub0),
      .dataout (addnsub0_pipe),
      .async (async_addnsub0)
      );
   defparam 	 addnsub0_mac_reg.data_width = 1;
   defparam 	 addnsub0_mac_reg.power_up = 1'b0;

   assign 	 async_addnsub0 = (addnsub0_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_addnsub0 = (addnsub0_clear != "none") ? 1'b1 : 1'b0;
   assign 	 clk_addnsub0  = clk[addnsub0_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_addnsub0 = aclr[addnsub0_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign 	 ena_addnsub0  = ena[addnsub0_clk] ? 1'b1 : 1'b0;
   
   assign 	 addnsub0_clk = 
		 ((addnsub0_clock == "0") || 
		  (addnsub0_clock == "none")) ? 4'b0000 :
		 (addnsub0_clock == "1") ? 4'b0001 :
		 (addnsub0_clock == "2") ? 4'b0010 :
		 (addnsub0_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 addnsub0_aclr = 
		 ((addnsub0_clear == "0") || 
		  (addnsub0_clear == "none")) ? 4'b0000 :
		 (addnsub0_clear == "1") ? 4'b0001 :
		 (addnsub0_clear == "2") ? 4'b0010 :
		 (addnsub0_clear == "3") ? 4'b0011 : 4'b0000;

   stratixii_mac_bit_register	addnsub1_mac_reg 
     (
      .data (addnsub1),
      .clk (clk_addnsub1),
      .aclr (aclr_addnsub1),
      .if_aclr (clear_addnsub1),
      .ena (ena_addnsub1),
      .dataout (addnsub1_pipe),
      .async (async_addnsub1)
      );
   defparam 	 addnsub1_mac_reg.data_width = 1;
   defparam 	 addnsub1_mac_reg.power_up = 1'b0;

   assign 	 async_addnsub1 = (addnsub1_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_addnsub1 = (addnsub1_clear != "none") ? 1'b1 : 1'b0;
   assign 	 clk_addnsub1  = clk[addnsub1_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_addnsub1 = aclr[addnsub1_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign 	 ena_addnsub1  = ena[addnsub1_clk] ? 1'b1 : 1'b0;
   
   assign 	 addnsub1_clk = 
		 ((addnsub1_clock == "0") || 
		  (addnsub1_clock == "none")) ? 4'b0000 :
		 (addnsub1_clock == "1") ? 4'b0001 :
		 (addnsub1_clock == "2") ? 4'b0010 :
		 (addnsub1_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 addnsub1_aclr = 
		 ((addnsub1_clear == "0") || 
		  (addnsub1_clear == "none")) ? 4'b0000 :
		 (addnsub1_clear == "1") ? 4'b0001 :
		 (addnsub1_clear == "2") ? 4'b0010 :
		 (addnsub1_clear == "3") ? 4'b0011 : 4'b0000;
   
   stratixii_mac_bit_register	round0_mac_reg 
     (
      .data (round0),
      .clk (clk_round0),
      .aclr (aclr_round0),
      .if_aclr (clear_round0),
      .ena (ena_round0),
      .dataout (round0_pipe),
      .async (async_round0)
      );
   defparam 	 round0_mac_reg.data_width = 1;
   defparam 	 round0_mac_reg.power_up = 1'b0;

   assign 	 async_round0 = (round0_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_round0 = (round0_clear != "none") ? 1'b1 : 1'b0;
   assign 	 clk_round0  = clk[round0_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_round0 = aclr[round0_aclr] || ~devclrn || ~devpor? 1'b1 : 1'b0;
   assign 	 ena_round0  = ena[round0_clk] ? 1'b1 : 1'b0;
   
   assign 	 round0_clk = 
		 ((round0_clock == "0") || 
		  (round0_clock == "none")) ? 4'b0000 :
		 (round0_clock == "1") ? 4'b0001 :
		 (round0_clock == "2") ? 4'b0010 :
		 (round0_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 round0_aclr = 
		 ((round0_clear == "0") || 
		  (round0_clear == "none")) ? 4'b0000 :
		 (round0_clear == "1") ? 4'b0001 :
		 (round0_clear == "2") ? 4'b0010 :
		 (round0_clear == "3") ? 4'b0011 : 4'b0000;
   
   stratixii_mac_bit_register	saturate_mac_reg 
     (
      .data (saturate),
      .clk (clk_saturate),
      .aclr (aclr_saturate),
      .if_aclr (clear_saturate),
      .ena (ena_saturate),
      .dataout (saturate_pipe),
      .async (async_saturate)
      );
   defparam 	 saturate_mac_reg.data_width = 1;
   defparam 	 saturate_mac_reg.power_up = 1'b0;  

   assign 	 async_saturate = (saturate_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_saturate = (saturate_clear != "none") ? 1'b1 : 1'b0;
   assign 	 clk_saturate  = clk[saturate_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_saturate = aclr[saturate_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign 	 ena_saturate  = ena[saturate_clk] ? 1'b1 : 1'b0;
   
   assign 	 saturate_clk = 
		 ((saturate_clock == "0") || 
		  (saturate_clock == "none")) ? 4'b0000 :
		 (saturate_clock == "1") ? 4'b0001 :
		 (saturate_clock == "2") ? 4'b0010 :
		 (saturate_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 saturate_aclr = 
		 ((saturate_clear == "0") || 
		  (saturate_clear == "none")) ? 4'b0000 :
		 (saturate_clear == "1") ? 4'b0001 :
		 (saturate_clear == "2") ? 4'b0010 :
		 (saturate_clear == "3") ? 4'b0011 : 4'b0000;
   
   stratixii_mac_bit_register	mode0_mac_reg 
     (
      .data (mode0),
      .clk (clk_mode0),
      .aclr (aclr_mode0),
      .if_aclr (clear_mode0),
      .ena (ena_mode0),
      .dataout (mode0_pipe),
      .async (async_mode0)
      );
   defparam 	 mode0_mac_reg.data_width = 1;   
   defparam 	 mode0_mac_reg.power_up = 1'b0;   

   assign 	 async_mode0 = (mode0_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_mode0 = (mode0_clear != "none") ? 1'b1 : 1'b0;
   assign 	 clk_mode0  = clk[mode0_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_mode0 = aclr[mode0_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign 	 ena_mode0  = ena[mode0_clk] ? 1'b1 : 1'b0;
   
   assign 	 mode0_clk = 
		 ((mode0_clock == "0") || 
		  (mode0_clock == "none")) ? 4'b0000 :
		 (mode0_clock == "1") ? 4'b0001 :
		 (mode0_clock == "2") ? 4'b0010 :
		 (mode0_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 mode0_aclr = 
		 ((mode0_clear == "0") || 
		  (mode0_clear == "none")) ? 4'b0000 :
		 (mode0_clear == "1") ? 4'b0001 :
		 (mode0_clear == "2") ? 4'b0010 :
		 (mode0_clear == "3") ? 4'b0011 : 4'b0000;
     
   stratixii_mac_bit_register	round1_mac_reg 
     (
      .data (round1),
      .clk (clk_round1),
      .aclr (aclr_round1),
      .if_aclr (clear_round1),
      .ena (ena_round1),
      .dataout (round1_pipe),
      .async (async_round1)
      );
   defparam 	 round1_mac_reg.data_width = 1;
   defparam 	 round1_mac_reg.power_up = 1'b0; 

   assign 	 async_round1 = (round1_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_round1 = (round1_clear != "none") ? 1'b1 : 1'b0;
   assign 	 clk_round1  = clk[round1_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_round1 = aclr[round1_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign 	 ena_round1  = ena[round1_clk] ? 1'b1 : 1'b0;
   
   assign 	 round1_clk = 
		 ((round1_clock == "0") || 
		  (round1_clock == "none")) ? 4'b0000 :
		 (round1_clock == "1") ? 4'b0001 :
		 (round1_clock == "2") ? 4'b0010 :
		 (round1_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 round1_aclr = 
		 ((round1_clear == "0") || 
		  (round1_clear == "none")) ? 4'b0000 :
		 (round1_clear == "1") ? 4'b0001 :
		 (round1_clear == "2") ? 4'b0010 :
		 (round1_clear == "3") ? 4'b0011 : 4'b0000;  

   stratixii_mac_bit_register	saturate1_mac_reg 
     (
      .data (saturate1),
      .clk (clk_saturate1),
      .aclr (aclr_saturate1),
      .if_aclr (clear_saturate1),
      .ena (ena_saturate1),
      .dataout (saturate1_pipe),
      .async (async_saturate1)
      );
   defparam 	 saturate1_mac_reg.data_width = 1;
   defparam 	 saturate1_mac_reg.power_up = 1'b0;   

   assign 	 async_saturate1 = (saturate1_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_saturate1 = (saturate1_clear != "none") ? 1'b1 : 1'b0;
   assign 	 clk_saturate1  = clk[saturate1_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_saturate1 = aclr[saturate1_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign 	 ena_saturate1  = ena[saturate1_clk] ? 1'b1 : 1'b0;
   
   assign 	 saturate1_clk = 
		 ((saturate1_clock == "0") || 
		  (saturate1_clock == "none")) ? 4'b0000 :
		 (saturate1_clock == "1") ? 4'b0001 :
		 (saturate1_clock == "2") ? 4'b0010 :
		 (saturate1_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 saturate1_aclr = 
		 ((saturate1_clear == "0") || 
		  (saturate1_clear == "none")) ? 4'b0000 :
		 (saturate1_clear == "1") ? 4'b0001 :
		 (saturate1_clear == "2") ? 4'b0010 :
		 (saturate1_clear == "3") ? 4'b0011 : 4'b0000;

   stratixii_mac_bit_register	mode1_mac_reg 
     (
      .data (mode1),
      .clk (clk_mode1),
      .aclr (aclr_mode1),
      .if_aclr (clear_mode1),
      .ena (ena_mode1),
      .dataout (mode1_pipe),
      .async (async_mode1)
      );
   defparam 	 mode1_mac_reg.data_width = 1;   
   defparam 	 mode1_mac_reg.power_up = 1'b0;   

   assign 	 async_mode1 = (mode1_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_mode1 = (mode1_clear != "none") ? 1'b1 : 1'b0;
   assign 	 clk_mode1  = clk[mode1_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_mode1 = aclr[mode1_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign 	 ena_mode1  = ena[mode1_clk] ? 1'b1 : 1'b0;
   
   assign 	 mode1_clk = 
		 ((mode1_clock == "0") || 
		  (mode1_clock == "none")) ? 4'b0000 :
		 (mode1_clock == "1") ? 4'b0001 :
		 (mode1_clock == "2") ? 4'b0010 :
		 (mode1_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 mode1_aclr = 
		 ((mode1_clear == "0") || 
		  (mode1_clear == "none")) ? 4'b0000 :
		 (mode1_clear == "1") ? 4'b0001 :
		 (mode1_clear == "2") ? 4'b0010 :
		 (mode1_clear == "3") ? 4'b0011 : 4'b0000;
   
   stratixii_mac_bit_register	multabsaturate_mac_reg 
     (
      .data (multabsaturate),
      .clk (clk_multabsaturate),
      .aclr (aclr_multabsaturate),
      .if_aclr (clear_multabsaturate),
      .ena (ena_multabsaturate),
      .dataout (multabsaturate_pipe),
      .async (async_multabsaturate)
      );
   defparam 	 multabsaturate_mac_reg.data_width = 1;
   defparam 	 multabsaturate_mac_reg.power_up = 1'b0;

   assign 	 async_multabsaturate = (multabsaturate_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_multabsaturate = (multabsaturate_clear != "none") ? 1'b1 : 1'b0;
   assign 	 clk_multabsaturate  = clk[multabsaturate_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_multabsaturate = aclr[multabsaturate_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign 	 ena_multabsaturate  = ena[multabsaturate_clk] ? 1'b1 : 1'b0;
   
   assign 	 multabsaturate_clk = 
		 ((multabsaturate_clock == "0") || 
		  (multabsaturate_clock == "none")) ? 4'b0000 :
		 (multabsaturate_clock == "1") ? 4'b0001 :
		 (multabsaturate_clock == "2") ? 4'b0010 :
		 (multabsaturate_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 multabsaturate_aclr = 
		 ((multabsaturate_clear == "0") || 
		  (multabsaturate_clear == "none")) ? 4'b0000 :
		 (multabsaturate_clear == "1") ? 4'b0001 :
		 (multabsaturate_clear == "2") ? 4'b0010 :
		 (multabsaturate_clear == "3") ? 4'b0011 : 4'b0000;
   
   stratixii_mac_bit_register	multcdsaturate_mac_reg 
     (
      .data (multcdsaturate),
      .clk (clk_multcdsaturate),
      .aclr (aclr_multcdsaturate),
      .if_aclr (clear_multcdsaturate),
      .ena (ena_multcdsaturate),
      .dataout (multcdsaturate_pipe),
      .async (async_multcdsaturate)
      );
   defparam 	 multcdsaturate_mac_reg.data_width = 1;
   defparam 	 multcdsaturate_mac_reg.power_up = 1'b0;

   assign 	 async_multcdsaturate = (multcdsaturate_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_multcdsaturate = (multcdsaturate_clear != "none") ? 1'b1 : 1'b0;
   assign 	 clk_multcdsaturate  = clk[multcdsaturate_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_multcdsaturate = aclr[multcdsaturate_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign 	 ena_multcdsaturate  = ena[multcdsaturate_clk] ? 1'b1 : 1'b0;
   
   assign 	 multcdsaturate_clk = 
		 ((multcdsaturate_clock == "0") || 
		  (multcdsaturate_clock == "none")) ? 4'b0000 :
		 (multcdsaturate_clock == "1") ? 4'b0001 :
		 (multcdsaturate_clock == "2") ? 4'b0010 :
		 (multcdsaturate_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 multcdsaturate_aclr = 
		 ((multcdsaturate_clear == "0") || 
		  (multcdsaturate_clear == "none")) ? 4'b0000 :
		 (multcdsaturate_clear == "1") ? 4'b0001 :
		 (multcdsaturate_clear == "2") ? 4'b0010 :
		 (multcdsaturate_clear == "3") ? 4'b0011 : 4'b0000;
   
   stratixii_mac_bit_register	signa_mac_pipeline_reg 
     (
      .data (signa_pipe),
      .clk (clk_signa_pipeline),
      .aclr (aclr_signa_pipeline),
      .if_aclr (clear_signa_pipeline),
      .ena (ena_signa_pipeline),
      .dataout (signa_out),
      .async (async_signa_pipeline)
      );
   defparam 	 signa_mac_pipeline_reg.data_width = 1;
   defparam 	 signa_mac_pipeline_reg.power_up = 1'b0;

   assign 	 async_signa_pipeline = (signa_pipeline_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_signa_pipeline = (signa_pipeline_clear != "none") ? 1'b1 : 1'b0 ;
   assign 	 clk_signa_pipeline  = clk[signa_pipeline_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_signa_pipeline = aclr[signa_pipeline_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign 	 ena_signa_pipeline  = ena[signa_pipeline_clk] ? 1'b1 : 1'b0;
   
   assign 	 signa_pipeline_clk = 
		 ((signa_pipeline_clock == "0") || 
		  (signa_pipeline_clock == "none")) ? 4'b0000 :
		 (signa_pipeline_clock == "1") ? 4'b0001 :
		 (signa_pipeline_clock == "2") ? 4'b0010 :
		 (signa_pipeline_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 signa_pipeline_aclr = 
		 ((signa_pipeline_clear == "0") || 
		  (signa_pipeline_clear == "none")) ? 4'b0000 :
		 (signa_pipeline_clear == "1") ? 4'b0001 :
		 (signa_pipeline_clear == "2") ? 4'b0010 :
		 (signa_pipeline_clear == "3") ? 4'b0011 : 4'b0000;
   
   stratixii_mac_bit_register	signb_mac_pipeline_reg 
     (
      .data (signb_pipe),
      .clk (clk_signb_pipeline),
      .aclr (aclr_signb_pipeline),
      .if_aclr (clear_signb_pipeline),
      .ena (ena_signb_pipeline),
      .dataout (signb_out),
      .async (async_signb_pipeline)
      );
   defparam 	 signb_mac_pipeline_reg.data_width = 1;
   defparam 	 signb_mac_pipeline_reg.power_up = 1'b0;

   assign 	 async_signb_pipeline = (signb_pipeline_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_signb_pipeline = (signb_pipeline_clear != "none") ? 1'b1 : 1'b0 ;
   assign 	 clk_signb_pipeline  = clk[signb_pipeline_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_signb_pipeline = aclr[signb_pipeline_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign 	 ena_signb_pipeline  = ena[signb_pipeline_clk] ? 1'b1 : 1'b0;
   
   assign 	 signb_pipeline_clk = 
		 ((signb_pipeline_clock == "0") || 
		  (signb_pipeline_clock == "none")) ? 4'b0000 :
		 (signb_pipeline_clock == "1") ? 4'b0001 :
		 (signb_pipeline_clock == "2") ? 4'b0010 :
		 (signb_pipeline_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 signb_pipeline_aclr = 
		 ((signb_pipeline_clear == "0") || 
		  (signb_pipeline_clear == "none")) ? 4'b0000 :
		 (signb_pipeline_clear == "1") ? 4'b0001 :
		 (signb_pipeline_clear == "2") ? 4'b0010 :
		 (signb_pipeline_clear == "3") ? 4'b0011 : 4'b0000;
   
   stratixii_mac_bit_register	zeroacc_mac_pipeline_reg 
     (
      .data (zeroacc_pipe),
      .clk (clk_zeroacc_pipeline),
      .aclr (aclr_zeroacc_pipeline),
      .if_aclr (clear_zeroacc_pipeline),
      .ena (ena_zeroacc_pipeline),
      .dataout (zeroacc_out),
      .async (async_zeroacc_pipeline)
      );
   defparam 	 zeroacc_mac_pipeline_reg.data_width = 1;
   defparam 	 zeroacc_mac_pipeline_reg.power_up = 1'b0;

   assign 	 async_zeroacc_pipeline = (zeroacc_pipeline_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_zeroacc_pipeline = (zeroacc_pipeline_clear != "none") ? 1'b1 : 1'b0 ;
   assign 	 clk_zeroacc_pipeline  = clk[zeroacc_pipeline_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_zeroacc_pipeline = aclr[zeroacc_pipeline_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign 	 ena_zeroacc_pipeline  = ena[zeroacc_pipeline_clk] ? 1'b1 : 1'b0;
   
   assign 	 zeroacc_pipeline_clk = 
		 ((zeroacc_pipeline_clock == "0") || 
		  (zeroacc_pipeline_clock == "none")) ? 4'b0000 :
		 (zeroacc_pipeline_clock == "1") ? 4'b0001 :
		 (zeroacc_pipeline_clock == "2") ? 4'b0010 :
		 (zeroacc_pipeline_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 zeroacc_pipeline_aclr = 
		 ((zeroacc_pipeline_clear == "0") || 
		  (zeroacc_pipeline_clear == "none")) ? 4'b0000 :
		 (zeroacc_pipeline_clear == "1") ? 4'b0001 :
		 (zeroacc_pipeline_clear == "2") ? 4'b0010 :
		 (zeroacc_pipeline_clear == "3") ? 4'b0011 : 4'b0000;
   
   stratixii_mac_bit_register	zeroacc1_mac_pipeline_reg 
     (
      .data (zeroacc1_pipe),
      .clk (clk_zeroacc1_pipeline),
      .aclr (aclr_zeroacc1_pipeline),
      .if_aclr (clear_zeroacc1_pipeline),
      .ena (ena_zeroacc1_pipeline),
      .dataout (zeroacc1_out),
      .async (async_zeroacc1_pipeline)
      );
   defparam 	 zeroacc1_mac_pipeline_reg.data_width = 1;
   defparam 	 zeroacc1_mac_pipeline_reg.power_up = 1'b0;

   assign 	 async_zeroacc1_pipeline = (zeroacc1_pipeline_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_zeroacc1_pipeline = (zeroacc1_pipeline_clear != "none") ? 1'b1 : 1'b0 ;
   assign 	 clk_zeroacc1_pipeline  = clk[zeroacc1_pipeline_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_zeroacc1_pipeline = aclr[zeroacc1_pipeline_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign 	 ena_zeroacc1_pipeline  = ena[zeroacc1_pipeline_clk] ? 1'b1 : 1'b0;
   
   assign 	 zeroacc1_pipeline_clk = 
		 ((zeroacc1_pipeline_clock == "0") || 
		  (zeroacc1_pipeline_clock == "none")) ? 4'b0000 :
		 (zeroacc1_pipeline_clock == "1") ? 4'b0001 :
		 (zeroacc1_pipeline_clock == "2") ? 4'b0010 :
		 (zeroacc1_pipeline_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 zeroacc1_pipeline_aclr = 
		 ((zeroacc1_pipeline_clear == "0") || 
		  (zeroacc1_pipeline_clear == "none")) ? 4'b0000 :
		 (zeroacc1_pipeline_clear == "1") ? 4'b0001 :
		 (zeroacc1_pipeline_clear == "2") ? 4'b0010 :
		 (zeroacc1_pipeline_clear == "3") ? 4'b0011 : 4'b0000;
   
   stratixii_mac_bit_register	addnsub0_mac_pipeline_reg 
     (
      .data (addnsub0_pipe),
      .clk (clk_addnsub0_pipeline),
      .aclr (aclr_addnsub0_pipeline),
      .if_aclr (clear_addnsub0_pipeline),
      .ena (ena_addnsub0_pipeline),
      .dataout (addnsub0_out),
      .async (async_addnsub0_pipeline)
      );
   defparam 	 addnsub0_mac_pipeline_reg.data_width = 1;
   defparam  	 addnsub0_mac_pipeline_reg.power_up = 1'b0;   

   assign 	 async_addnsub0_pipeline = (addnsub0_pipeline_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_addnsub0_pipeline = (addnsub0_pipeline_clear != "none") ? 1'b1 : 1'b0 ;
   assign 	 clk_addnsub0_pipeline  = clk[addnsub0_pipeline_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_addnsub0_pipeline = aclr[addnsub0_pipeline_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign 	 ena_addnsub0_pipeline  = ena[addnsub0_pipeline_clk] ? 1'b1 : 1'b0;
   
   assign 	 addnsub0_pipeline_clk = 
		 ((addnsub0_pipeline_clock == "0") || 
		  (addnsub0_pipeline_clock == "none")) ? 4'b0000 :
		 (addnsub0_pipeline_clock == "1") ? 4'b0001 :
		 (addnsub0_pipeline_clock == "2") ? 4'b0010 :
		 (addnsub0_pipeline_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 addnsub0_pipeline_aclr = 
		 ((addnsub0_pipeline_clear == "0") || 
		  (addnsub0_pipeline_clear == "none")) ? 4'b0000 :
		 (addnsub0_pipeline_clear == "1") ? 4'b0001 :
		 (addnsub0_pipeline_clear == "2") ? 4'b0010 :
		 (addnsub0_pipeline_clear == "3") ? 4'b0011 : 4'b0000;
   
   stratixii_mac_bit_register	addnsub1_mac_pipeline_reg 
     (
      .data (addnsub1_pipe),
      .clk (clk_addnsub1_pipeline),
      .aclr (aclr_addnsub1_pipeline),
      .if_aclr (clear_addnsub1_pipeline),
      .ena (ena_addnsub1_pipeline),
      .dataout (addnsub1_out),
      .async (async_addnsub1_pipeline)
      );
   defparam 	 addnsub1_mac_pipeline_reg.data_width = 1;
   defparam 	 addnsub1_mac_pipeline_reg.power_up = 1'b0;

   assign 	 async_addnsub1_pipeline = (addnsub1_pipeline_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_addnsub1_pipeline = (addnsub1_pipeline_clear != "none") ? 1'b1 : 1'b0 ;
   assign 	 clk_addnsub1_pipeline  = clk[addnsub1_pipeline_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_addnsub1_pipeline = aclr[addnsub1_pipeline_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign 	 ena_addnsub1_pipeline  = ena[addnsub1_pipeline_clk] ? 1'b1 : 1'b0;
   
   assign 	 addnsub1_pipeline_clk = 
		 ((addnsub1_pipeline_clock == "0") || 
		  (addnsub1_pipeline_clock == "none")) ? 4'b0000 :
		 (addnsub1_pipeline_clock == "1") ? 4'b0001 :
		 (addnsub1_pipeline_clock == "2") ? 4'b0010 :
		 (addnsub1_pipeline_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 addnsub1_pipeline_aclr = 
		 ((addnsub1_pipeline_clear == "0") || 
		  (addnsub1_pipeline_clear == "none")) ? 4'b0000 :
		 (addnsub1_pipeline_clear == "1") ? 4'b0001 :
		 (addnsub1_pipeline_clear == "2") ? 4'b0010 :
		 (addnsub1_pipeline_clear == "3") ? 4'b0011 : 4'b0000;
   
   stratixii_mac_bit_register	round0_mac_pipeline_reg 
     (
      .data (round0_pipe),
      .clk (clk_round0_pipeline),
      .aclr (aclr_round0_pipeline),
      .if_aclr (clear_round0_pipeline),
      .ena (ena_round0_pipeline),
      .dataout (round0_out),
      .async (async_round0_pipeline)
      );
   defparam 	 round0_mac_pipeline_reg.data_width = 1;
   defparam 	 round0_mac_pipeline_reg.power_up = 1'b0;

   assign 	 async_round0_pipeline = (round0_pipeline_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_round0_pipeline = (round0_pipeline_clear != "none") ? 1'b1 : 1'b0 ;
   assign 	 clk_round0_pipeline  = clk[round0_pipeline_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_round0_pipeline = aclr[round0_pipeline_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign 	 ena_round0_pipeline  = ena[round0_pipeline_clk] ? 1'b1 : 1'b0;
   
   assign 	 round0_pipeline_clk = 
		 ((round0_pipeline_clock == "0") || 
		  (round0_pipeline_clock == "none")) ? 4'b0000 :
		 (round0_pipeline_clock == "1") ? 4'b0001 :
		 (round0_pipeline_clock == "2") ? 4'b0010 :
		 (round0_pipeline_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 round0_pipeline_aclr = 
		 ((round0_pipeline_clear == "0") || 
		  (round0_pipeline_clear == "none")) ? 4'b0000 :
		 (round0_pipeline_clear == "1") ? 4'b0001 :
		 (round0_pipeline_clear == "2") ? 4'b0010 :
		 (round0_pipeline_clear == "3") ? 4'b0011 : 4'b0000;

   stratixii_mac_bit_register	saturate_mac_pipeline_reg 
     (
      .data (saturate_pipe),
      .clk (clk_saturate_pipeline),
      .aclr (aclr_saturate_pipeline),
      .if_aclr (clear_saturate_pipeline),
      .ena (ena_saturate_pipeline),
      .dataout (saturate_out),
      .async (async_saturate_pipeline)
      );
   defparam 	 saturate_mac_pipeline_reg.data_width = 1;
   defparam 	 saturate_mac_pipeline_reg.power_up = 1'b0;   

   assign 	 async_saturate_pipeline = (saturate_pipeline_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_saturate_pipeline = (saturate_pipeline_clear != "none") ? 1'b1 : 1'b0 ;
   assign 	 clk_saturate_pipeline  = clk[saturate_pipeline_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_saturate_pipeline = aclr[saturate_pipeline_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign 	 ena_saturate_pipeline  = ena[saturate_pipeline_clk] ? 1'b1 : 1'b0;
   
   assign 	 saturate_pipeline_clk = 
		 ((saturate_pipeline_clock == "0") || 
		  (saturate_pipeline_clock == "none")) ? 4'b0000 :
		 (saturate_pipeline_clock == "1") ? 4'b0001 :
		 (saturate_pipeline_clock == "2") ? 4'b0010 :
		 (saturate_pipeline_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 saturate_pipeline_aclr = 
		 ((saturate_pipeline_clear == "0") || 
		  (saturate_pipeline_clear == "none")) ? 4'b0000 :
		 (saturate_pipeline_clear == "1") ? 4'b0001 :
		 (saturate_pipeline_clear == "2") ? 4'b0010 :
		 (saturate_pipeline_clear == "3") ? 4'b0011 : 4'b0000;
   
   stratixii_mac_bit_register	mode0_mac_pipeline_reg 
     (
      .data (mode0_pipe),
      .clk (clk_mode0_pipeline),
      .aclr (aclr_mode0_pipeline),
      .if_aclr (clear_mode0_pipeline),
      .ena (ena_mode0_pipeline),
      .dataout (mode0_out),
      .async (async_mode0_pipeline)
      );
   defparam 	 mode0_mac_pipeline_reg.data_width = 1;   
   defparam 	 mode0_mac_pipeline_reg.power_up = 1'b0;      

   assign 	 async_mode0_pipeline = (mode0_pipeline_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_mode0_pipeline = (mode0_pipeline_clear != "none") ? 1'b1 : 1'b0 ;
   assign 	 clk_mode0_pipeline  = clk[mode0_pipeline_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_mode0_pipeline = aclr[mode0_pipeline_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign 	 ena_mode0_pipeline  = ena[mode0_pipeline_clk] ? 1'b1 : 1'b0;
   
   assign 	 mode0_pipeline_clk = 
		 ((mode0_pipeline_clock == "0") || 
		  (mode0_pipeline_clock == "none")) ? 4'b0000 :
		 (mode0_pipeline_clock == "1") ? 4'b0001 :
		 (mode0_pipeline_clock == "2") ? 4'b0010 :
		 (mode0_pipeline_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 mode0_pipeline_aclr = 
		 ((mode0_pipeline_clear == "0") || 
		  (mode0_pipeline_clear == "none")) ? 4'b0000 :
		 (mode0_pipeline_clear == "1") ? 4'b0001 :
		 (mode0_pipeline_clear == "2") ? 4'b0010 :
		 (mode0_pipeline_clear == "3") ? 4'b0011 : 4'b0000;
   
   stratixii_mac_bit_register	round1_mac_pipeline_reg 
     (
      .data (round1_pipe),
      .clk (clk_round1_pipeline),
      .aclr (aclr_round1_pipeline),
      .if_aclr (clear_round1_pipeline),
      .ena (ena_round1_pipeline),
      .dataout (round1_out),
      .async (async_round1_pipeline)
      );
   defparam 	 round1_mac_pipeline_reg.data_width = 1;
   defparam 	 round1_mac_pipeline_reg.power_up = 1'b0;   

   assign 	 async_round1_pipeline = (round1_pipeline_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_round1_pipeline = (round1_pipeline_clear != "none") ? 1'b1 : 1'b0 ;
   assign 	 clk_round1_pipeline  = clk[round1_pipeline_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_round1_pipeline = aclr[round1_pipeline_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign 	 ena_round1_pipeline  = ena[round1_pipeline_clk] ? 1'b1 : 1'b0;
   
   assign 	 round1_pipeline_clk = 
		 ((round1_pipeline_clock == "0") || 
		  (round1_pipeline_clock == "none")) ? 4'b0000 :
		 (round1_pipeline_clock == "1") ? 4'b0001 :
		 (round1_pipeline_clock == "2") ? 4'b0010 :
		 (round1_pipeline_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 round1_pipeline_aclr = 
		 ((round1_pipeline_clear == "0") || 
		  (round1_pipeline_clear == "none")) ? 4'b0000 :
		 (round1_pipeline_clear == "1") ? 4'b0001 :
		 (round1_pipeline_clear == "2") ? 4'b0010 :
		 (round1_pipeline_clear == "3") ? 4'b0011 : 4'b0000;
   
   stratixii_mac_bit_register	saturate1_mac_pipeline_reg 
     (
      .data (saturate1_pipe),
      .clk (clk_saturate1_pipeline),
      .aclr (aclr_saturate1_pipeline),
      .if_aclr (clear_saturate1_pipeline),
      .ena (ena_saturate1_pipeline),
      .dataout (saturate1_out),
      .async (async_saturate1_pipeline)
      );
   defparam 	 saturate1_mac_pipeline_reg.data_width = 1;
   defparam 	 saturate1_mac_pipeline_reg.power_up = 1'b0;   

   assign 	 async_saturate1_pipeline = (saturate1_pipeline_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_saturate1_pipeline = (saturate1_pipeline_clear != "none") ? 1'b1 : 1'b0 ;
   assign 	 clk_saturate1_pipeline  = clk[saturate1_pipeline_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_saturate1_pipeline = aclr[saturate1_pipeline_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign 	 ena_saturate1_pipeline  = ena[saturate1_pipeline_clk] ? 1'b1 : 1'b0;
   
   assign 	 saturate1_pipeline_clk = 
		 ((saturate1_pipeline_clock == "0") || 
		  (saturate1_pipeline_clock == "none")) ? 4'b0000 :
		 (saturate1_pipeline_clock == "1") ? 4'b0001 :
		 (saturate1_pipeline_clock == "2") ? 4'b0010 :
		 (saturate1_pipeline_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 saturate1_pipeline_aclr = 
		 ((saturate1_pipeline_clear == "0") || 
		  (saturate1_pipeline_clear == "none")) ? 4'b0000 :
		 (saturate1_pipeline_clear == "1") ? 4'b0001 :
		 (saturate1_pipeline_clear == "2") ? 4'b0010 :
		 (saturate1_pipeline_clear == "3") ? 4'b0011 : 4'b0000;
   
   stratixii_mac_bit_register	mode1_mac_pipeline_reg 
     (
      .data (mode1_pipe),
      .clk (clk_mode1_pipeline),
      .aclr (aclr_mode1_pipeline),
      .if_aclr (clear_mode1_pipeline),
      .ena (ena_mode1_pipeline),
      .dataout (mode1_out),
      .async (async_mode1_pipeline)
      );
   defparam 	 mode1_mac_pipeline_reg.data_width = 1;
   defparam 	 mode1_mac_pipeline_reg.power_up = 1'b0;   

   assign 	 async_mode1_pipeline = (mode1_pipeline_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_mode1_pipeline = (mode1_pipeline_clear != "none") ? 1'b1 : 1'b0 ;
   assign 	 clk_mode1_pipeline  = clk[mode1_pipeline_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_mode1_pipeline = aclr[mode1_pipeline_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign 	 ena_mode1_pipeline  = ena[mode1_pipeline_clk] ? 1'b1 : 1'b0;
   
   assign 	 mode1_pipeline_clk = 
		 ((mode1_pipeline_clock == "0") || 
		  (mode1_pipeline_clock == "none")) ? 4'b0000 :
		 (mode1_pipeline_clock == "1") ? 4'b0001 :
		 (mode1_pipeline_clock == "2") ? 4'b0010 :
		 (mode1_pipeline_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 mode1_pipeline_aclr = 
		 ((mode1_pipeline_clear == "0") || 
		  (mode1_pipeline_clear == "none")) ? 4'b0000 :
		 (mode1_pipeline_clear == "1") ? 4'b0001 :
		 (mode1_pipeline_clear == "2") ? 4'b0010 :
		 (mode1_pipeline_clear == "3") ? 4'b0011 : 4'b0000;
   
   stratixii_mac_bit_register	multabsaturate_mac_pipeline_reg 
     (
      .data (multabsaturate_pipe),
      .clk (clk_multabsaturate_pipeline),
      .aclr (aclr_multabsaturate_pipeline),
      .if_aclr (clear_multabsaturate_pipeline),
      .ena (ena_multabsaturate_pipeline),
      .dataout (multabsaturate_out),
      .async (async_multabsaturate_pipeline)
      );
   defparam 	 multabsaturate_mac_pipeline_reg.data_width = 1;
   defparam 	 multabsaturate_mac_pipeline_reg.power_up = 1'b0;

   assign 	 async_multabsaturate_pipeline = (multabsaturate_pipeline_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_multabsaturate_pipeline = (multabsaturate_pipeline_clear != "none") ? 1'b1 : 1'b0 ;
   assign 	 clk_multabsaturate_pipeline  = clk[multabsaturate_pipeline_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_multabsaturate_pipeline = aclr[multabsaturate_pipeline_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign 	 ena_multabsaturate_pipeline  = ena[multabsaturate_pipeline_clk] ? 1'b1 : 1'b0;
   
   assign 	 multabsaturate_pipeline_clk = 
		 ((multabsaturate_pipeline_clock == "0") || 
		  (multabsaturate_pipeline_clock == "none")) ? 4'b0000 :
		 (multabsaturate_pipeline_clock == "1") ? 4'b0001 :
		 (multabsaturate_pipeline_clock == "2") ? 4'b0010 :
		 (multabsaturate_pipeline_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 multabsaturate_pipeline_aclr = 
		 ((multabsaturate_pipeline_clear == "0") || 
		  (multabsaturate_pipeline_clear == "none")) ? 4'b0000 :
		 (multabsaturate_pipeline_clear == "1") ? 4'b0001 :
		 (multabsaturate_pipeline_clear == "2") ? 4'b0010 :
		 (multabsaturate_pipeline_clear == "3") ? 4'b0011 : 4'b0000;
   
   stratixii_mac_bit_register	multcdsaturate_mac_pipeline_reg 
     (
      .data (multcdsaturate_pipe),
      .clk (clk_multcdsaturate_pipeline),
      .aclr (aclr_multcdsaturate_pipeline),
      .if_aclr (clear_multcdsaturate_pipeline),
      .ena (ena_multcdsaturate_pipeline),
      .dataout (multcdsaturate_out),
      .async (async_multcdsaturate_pipeline)
      );
   defparam 	 multcdsaturate_mac_pipeline_reg.data_width = 1;
   defparam 	 multcdsaturate_mac_pipeline_reg.power_up = 1'b0;

   assign 	 async_multcdsaturate_pipeline = (multcdsaturate_pipeline_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_multcdsaturate_pipeline = (multcdsaturate_pipeline_clear != "none") ? 1'b1 : 1'b0 ;
   assign 	 clk_multcdsaturate_pipeline  = clk[multcdsaturate_pipeline_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_multcdsaturate_pipeline = aclr[multcdsaturate_pipeline_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign 	 ena_multcdsaturate_pipeline  = ena[multcdsaturate_pipeline_clk] ? 1'b1 : 1'b0;
   
   assign 	 multcdsaturate_pipeline_clk = 
		 ((multcdsaturate_pipeline_clock == "0") || 
		  (multcdsaturate_pipeline_clock == "none")) ? 4'b0000 :
		 (multcdsaturate_pipeline_clock == "1") ? 4'b0001 :
		 (multcdsaturate_pipeline_clock == "2") ? 4'b0010 :
		 (multcdsaturate_pipeline_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 multcdsaturate_pipeline_aclr = 
		 ((multcdsaturate_pipeline_clear == "0") || 
		  (multcdsaturate_pipeline_clear == "none")) ? 4'b0000 :
		 (multcdsaturate_pipeline_clear == "1") ? 4'b0001 :
		 (multcdsaturate_pipeline_clear == "2") ? 4'b0010 :
		 (multcdsaturate_pipeline_clear == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 dataa_f = (dataa_forced_to_zero == "yes") ? 'b0 : dataa;
   assign 	 datac_f = (datac_forced_to_zero == "yes") ? 'b0 : datac;
   
   stratixii_mac_out_internal mac_adder
     (
      .dataa (dataa_f),
      .datab (datab),
      .datac (datac_f),
      .datad (datad),
      .mode0 (mode0_out[0]),
      .mode1 (mode1_out[0]),
      .zeroacc  (zeroacc_out[0]),
      .zeroacc1 (zeroacc1_out[0]),
      .roundab (round0_out[0]),
      .roundcd (round1_out[0]),
      .saturateab (saturate_out[0]),
      .saturatecd (saturate1_out[0]),
      .multabsaturate (multabsaturate_out[0]),
      .multcdsaturate (multcdsaturate_out[0]),
      .signx (signa_out[0]),
      .signy (signb_out[0]),
      .addnsub0 (addnsub0_out[0]),
      .addnsub1 (addnsub1_out[0]),
      .dataout_feedback (dataout_feedback[143:0]),
      .dataout (dataout_map),
      .accoverflow (accoverflow_reg)
      );   
   defparam 	 mac_adder.dataa_width = dataa_width;
   defparam 	 mac_adder.datab_width = datab_width;
   defparam 	 mac_adder.datac_width = datac_width;
   defparam 	 mac_adder.datad_width = datad_width;
   defparam 	 mac_adder.dataout_width = dataout_width;
   defparam 	 mac_adder.operation_mode = operation_mode;

   stratixii_mac_pin_map mac_pin_map
     (
      .datain(dataout_map),
	  .addnsub(addnsub0_out[0] && addnsub1_out[0]),
      .operation(operation),
      .dataout(dataout_to_reg)
      );
   defparam 	 mac_pin_map.operation_mode = operation_mode;
   defparam 	 mac_pin_map.type = "map";

   stratixii_mac_register output0_reg 
     (
      .data (dataout_to_reg[71:0]),        
      .clk (clk_output),
      .aclr (aclr_output),
      .if_aclr (clear_output),
      .ena (ena_output),
      .dataout (dataout_non_dynamic[71:0]),
      .async (async_output)
      );
   defparam 	 output0_reg.data_width = dataout_width;
   defparam 	 output0_reg.power_up = 1'b0;

   assign 	 async_output = (output_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_output = (output_clear != "none") ? 1'b1 : 1'b0 ;
   assign 	 clk_output  = clk[output_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_output = aclr[output_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign 	 ena_output  = ena[output_clk] ? 1'b1 : 1'b0;
   
   assign 	 output_clk = 
		 ((output_clock == "0") || 
		  (output_clock == "none")) ? 4'b0000 :
		 (output_clock == "1") ? 4'b0001 :
		 (output_clock == "2") ? 4'b0010 :
		 (output_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 output_aclr = 
		 ((output_clear == "0") || 
		  (output_clear == "none")) ? 4'b0000 :
		 (output_clear == "1") ? 4'b0001 :
		 (output_clear == "2") ? 4'b0010 :
		 (output_clear == "3") ? 4'b0011 : 4'b0000;
   
   stratixii_mac_register output1_reg 
     (
      .data ({{(54){1'b0}},dataout_to_reg[35:18]}),
      .clk (clk_output1),
      .aclr (aclr_output1),
      .if_aclr (clear_output1),
      .ena (ena_output1),
      .dataout (dataout_dynamic1),
      .async (async_output1)
      );
   defparam 	 output1_reg.data_width = 18;
   defparam 	 output1_reg.power_up = 1'b0;

   assign 	 async_output1 = (output1_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_output1 = (output1_clear != "none") ? 1'b1 : 1'b0 ;
   assign 	 clk_output1  = clk[output1_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_output1 = aclr[output1_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign 	 ena_output1  = ena[output1_clk] ? 1'b1 : 1'b0;
   
   assign 	 output1_clk = 
		 ((output1_clock == "0") || 
		  (output1_clock == "none")) ? 4'b0000 :
		 (output1_clock == "1") ? 4'b0001 :
		 (output1_clock == "2") ? 4'b0010 :
		 (output1_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 output1_aclr = 
		 ((output1_clear == "0") || 
		  (output1_clear == "none")) ? 4'b0000 :
		 (output1_clear == "1") ? 4'b0001 :
		 (output1_clear == "2") ? 4'b0010 :
		 (output1_clear == "3") ? 4'b0011 : 4'b0000;
   
   stratixii_mac_register output2_reg
     (
      .data ({{(54){1'b0}},dataout_to_reg[53:36]}),        
      .clk (clk_output2),
      .aclr (aclr_output2),
      .if_aclr (clear_output2),
      .ena (ena_output2),
      .dataout (dataout_dynamic2),
      .async (async_output2)
      );
   defparam 	 output2_reg.data_width = 18;
   defparam 	 output2_reg.power_up = 1'b0;

   assign 	 async_output2 = (output2_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_output2 = (output2_clear != "none") ? 1'b1 : 1'b0 ;
   assign 	 clk_output2  = clk[output2_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_output2 = aclr[output2_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign 	 ena_output2  = ena[output2_clk] ? 1'b1 : 1'b0;
   
   assign 	 output2_clk = 
		 ((output2_clock == "0") || 
		  (output2_clock == "none")) ? 4'b0000 :
		 (output2_clock == "1") ? 4'b0001 :
		 (output2_clock == "2") ? 4'b0010 :
		 (output2_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 output2_aclr = 
		 ((output2_clear == "0") || 
		  (output2_clear == "none")) ? 4'b0000 :
		 (output2_clear == "1") ? 4'b0001 :
		 (output2_clear == "2") ? 4'b0010 :
		 (output2_clear == "3") ? 4'b0011 : 4'b0000;
   
   stratixii_mac_register output3_reg 
     (
      .data ({{(54){1'b0}},dataout_to_reg[71:54]}),        
      .clk (clk_output3),
      .aclr (aclr_output3),
      .if_aclr (clear_output3),
      .ena (ena_output3),
      .dataout (dataout_dynamic3),
      .async (async_output3)
      );
   defparam 	 output3_reg.data_width = 18;   
   defparam 	 output3_reg.power_up = 1'b0;

   assign 	 async_output3 = (output3_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_output3 = (output3_clear != "none") ? 1'b1 : 1'b0 ;
   assign 	 clk_output3  = clk[output3_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_output3 = aclr[output3_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign 	 ena_output3  = ena[output3_clk] ? 1'b1 : 1'b0;
   
   assign 	 output3_clk = 
		 ((output3_clock == "0") || 
		  (output3_clock == "none")) ? 4'b0000 :
		 (output3_clock == "1") ? 4'b0001 :
		 (output3_clock == "2") ? 4'b0010 :
		 (output3_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 output3_aclr = 
		 ((output3_clear == "0") || 
		  (output3_clear == "none")) ? 4'b0000 :
		 (output3_clear == "1") ? 4'b0001 :
		 (output3_clear == "2") ? 4'b0010 :
		 (output3_clear == "3") ? 4'b0011 : 4'b0000;
   
   stratixii_mac_register output4_reg 
     (
      .data ({{(54){1'b0}},dataout_to_reg[89:72]}),        
      .clk (clk_output4),
      .aclr (aclr_output4),
      .if_aclr (clear_output4),
      .ena (ena_output4),
      .dataout (dataout_dynamic4),
      .async (async_output4)
      );
   defparam 	 output4_reg.data_width = 18;
   defparam 	 output4_reg.power_up = 1'b0;

   assign 	 async_output4 = (output4_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_output4 = (output4_clear != "none") ? 1'b1 : 1'b0 ;
   assign 	 clk_output4  = clk[output4_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_output4 = aclr[output4_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign 	 ena_output4  = ena[output4_clk] ? 1'b1 : 1'b0;
   
   assign 	 output4_clk = 
		 ((output4_clock == "0") || 
		  (output4_clock == "none")) ? 4'b0000 :
		 (output4_clock == "1") ? 4'b0001 :
		 (output4_clock == "2") ? 4'b0010 :
		 (output4_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 output4_aclr = 
		 ((output4_clear == "0") || 
		  (output4_clear == "none")) ? 4'b0000 :
		 (output4_clear == "1") ? 4'b0001 :
		 (output4_clear == "2") ? 4'b0010 :
		 (output4_clear == "3") ? 4'b0011 : 4'b0000;
   
   stratixii_mac_register output5_reg 
     (
      .data ({{(54){1'b0}},dataout_to_reg[107:90]}),        
      .clk (clk_output5),
      .aclr (aclr_output5),
      .if_aclr (clear_output5),
      .ena (ena_output5),
      .dataout (dataout_dynamic5),
      .async (async_output5)
      );
   defparam 	 output5_reg.data_width = 18;   
   defparam 	 output5_reg.power_up = 1'b0;

   assign 	 async_output5 = (output5_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_output5 = (output5_clear != "none") ? 1'b1 : 1'b0 ;
   assign 	 clk_output5  = clk[output5_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_output5 = aclr[output5_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign 	 ena_output5  = ena[output5_clk] ? 1'b1 : 1'b0;
   
   assign 	 output5_clk = 
		 ((output5_clock == "0") || 
		  (output5_clock == "none")) ? 4'b0000 :
		 (output5_clock == "1") ? 4'b0001 :
		 (output5_clock == "2") ? 4'b0010 :
		 (output5_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 output5_aclr = 
		 ((output5_clear == "0") || 
		  (output5_clear == "none")) ? 4'b0000 :
		 (output5_clear == "1") ? 4'b0001 :
		 (output5_clear == "2") ? 4'b0010 :
		 (output5_clear == "3") ? 4'b0011 : 4'b0000;
   
   stratixii_mac_register output6_reg 
     (
      .data ({{(54){1'b0}},dataout_to_reg[125:108]}),        
      .clk (clk_output6),
      .aclr (aclr_output6),
      .if_aclr (clear_output6),
      .ena (ena_output6),
      .dataout (dataout_dynamic6),
      .async (async_output6)
      );
   defparam 	 output6_reg.data_width = 18;
   defparam 	 output6_reg.power_up = 1'b0;

   assign 	 async_output6 = (output6_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_output6 = (output6_clear != "none") ? 1'b1 : 1'b0 ;
   assign 	 clk_output6  = clk[output6_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_output6 = aclr[output6_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign 	 ena_output6  = ena[output6_clk] ? 1'b1 : 1'b0;
   
   assign 	 output6_clk = 
		 ((output6_clock == "0") || 
		  (output6_clock == "none")) ? 4'b0000 :
		 (output6_clock == "1") ? 4'b0001 :
		 (output6_clock == "2") ? 4'b0010 :
		 (output6_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 output6_aclr = 
		 ((output6_clear == "0") || 
		  (output6_clear == "none")) ? 4'b0000 :
		 (output6_clear == "1") ? 4'b0001 :
		 (output6_clear == "2") ? 4'b0010 :
		 (output6_clear == "3") ? 4'b0011 : 4'b0000;
   
   stratixii_mac_register output7_reg 
     (
      .data ({{(54){1'b0}},dataout_to_reg[143:126]}),        
      .clk (clk_output7),
      .aclr (aclr_output7),
      .if_aclr (clear_output7),
      .ena (ena_output7),
      .dataout (dataout_dynamic7),
      .async (async_output7)
      );
   defparam 	 output7_reg.data_width = 18; 
   defparam 	 output7_reg.power_up = 1'b0;

   assign 	 async_output7 = (output7_clock == "none") ? 1'b1 : 1'b0;
   assign 	 clear_output7 = (output7_clear != "none") ? 1'b1 : 1'b0 ;
   assign 	 clk_output7  = clk[output7_clk] ? 1'b1 : 1'b0;
   assign 	 aclr_output7 = aclr[output7_aclr] || ~devclrn || ~devpor ? 1'b1 : 1'b0;
   assign 	 ena_output7  = ena[output7_clk] ? 1'b1 : 1'b0;
   
   assign 	 output7_clk = 
		 ((output7_clock == "0") || 
		  (output7_clock == "none")) ? 4'b0000 :
		 (output7_clock == "1") ? 4'b0001 :
		 (output7_clock == "2") ? 4'b0010 :
		 (output7_clock == "3") ? 4'b0011 : 4'b0000;
   
   assign 	 output7_aclr = 
		 ((output7_clear == "0") || 
		  (output7_clear == "none")) ? 4'b0000 :
		 (output7_clear == "1") ? 4'b0001 :
		 (output7_clear == "2") ? 4'b0010 :
		 (output7_clear == "3") ? 4'b0011 : 4'b0000;
   
   stratixii_mac_bit_register	accoverflow_out_reg 
     (
      .data (accoverflow_reg),
      .clk (clk_output),
      .aclr (aclr_output),
      .if_aclr ((output_clear != "none") ? 1'b1 : 1'b0 ),
      .ena (ena_output),
      .dataout (accoverflow_tmp),
      .async ((output_clock == "none") ? 1'b1 : 1'b0 )
      );
   defparam 	 accoverflow_out_reg.data_width = 1;
   defparam 	 accoverflow_out_reg.power_up = 1'b0;

   assign 	 dataout_dynamic[143:0] = {dataout_dynamic7[17:0],
					   dataout_dynamic6[17:0], 
					   dataout_dynamic5[17:0],
					   dataout_dynamic4[17:0], 
					   dataout_dynamic3[17:0],
					   dataout_dynamic2[17:0], 
					   dataout_dynamic1[17:0],
					   dataout_non_dynamic[17:0]};

   assign 	 dataout_tmp = (operation_mode == "dynamic") ?
				 dataout_dynamic : dataout_non_dynamic;
   
   assign 	 operation = 
		 (operation_mode == "output_only") ? 4'b0000 : 
		 (operation_mode == "one_level_adder") ? 4'b0001 : 
		 (operation_mode == "two_level_adder") ? 4'b0010 : 
		 (operation_mode == "accumulator") ? 4'b0100 :
		 (operation_mode == "36_bit_multiply") ? 4'b0111 :
		 ((operation_mode == "dynamic") && 
		  (mode0_out[0] == 1'b0) && (mode1_out[0] == 1'b0) && 
		  (zeroacc_out[0] == 1'b0) && (zeroacc1_out[0] == 1'b0)) ? 4'b0000 :
		 ((operation_mode == "dynamic") &&
		  (mode0_out[0] == 1'b1) && (mode1_out[0] == 1'b1)) ? 4'b1100 :
		 ((operation_mode == "dynamic") &&
		  (mode0_out[0] == 1'b1) && (mode1_out[0] == 1'b0)) ? 4'b1101 :
		 ((operation_mode == "dynamic") &&
		  (mode0_out[0] == 1'b0) && (mode1_out[0] == 1'b1)) ? 4'b1110 :
		 ((operation_mode == "dynamic") &&
		  (mode0_out[0] == 1'b0) && (mode0_out[0] == 1'b0) && 
		  (zeroacc_out[0] == 1'b1) && (zeroacc1_out[0] == 1'b1)) ? 4'b0111 :
		 4'b0000;
   
   assign 	 dataout = dataout_tmp;

   assign 	 dataout_feedback = (operation_mode == "dynamic") ?
				      dataout_dynamic : dataout_non_dynamic;
   assign 	 accoverflow = accoverflow_tmp[0];
   
endmodule 

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixii_lvds_rx_fifo_sync_ram
//
// Description :
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixii_lvds_rx_fifo_sync_ram (clk,
                                        datain,
                                        write_reset, 
                                        waddr,
                                        raddr,
                                        we,
                                        dataout
                                       );

//    parameter ram_width = 10;

    // INPUT PORTS
    input clk;
    input write_reset;
    input datain;
    input [2:0]  waddr;
    input [2:0]  raddr;
    input we;

    // OUTPUT PORTS
    output dataout;

    // INTERNAL VARIABLES AND NETS
    reg dataout_tmp;
    reg [0:5] ram_d;
    reg [0:5] ram_q;

    wire [0:5] data_reg;

    integer i;

    initial
    begin
        dataout_tmp = 0;
        for (i=0; i<= 5; i=i+1)
            ram_q[i] <= 1'b0;
    end

    // Write port 

    always @(posedge clk or posedge write_reset) 
    begin
        if(write_reset == 1'b1)
        begin
            for (i=0; i<= 5; i=i+1)
                ram_q[i] <= 1'b0;
        end
        else begin
        for (i=0; i<= 5; i=i+1)
            ram_q[i] <= ram_d[i];
        end
    end

    always @(we or data_reg or ram_q)
    begin
        if(we === 1'b1) 
        begin
            ram_d <= data_reg;
        end
        else begin
            ram_d <= ram_q;
        end
    end

    // Read port 

    assign data_reg[0] = ( waddr == 3'b000 ) ? datain : ram_q[0];
    assign data_reg[1] = ( waddr == 3'b001 ) ? datain : ram_q[1];
    assign data_reg[2] = ( waddr == 3'b010 ) ? datain : ram_q[2];
    assign data_reg[3] = ( waddr == 3'b011 ) ? datain : ram_q[3];
    assign data_reg[4] = ( waddr == 3'b100 ) ? datain : ram_q[4];
    assign data_reg[5] = ( waddr == 3'b101 ) ? datain : ram_q[5];

    always @(ram_q or we or waddr or raddr)
    begin
        case ( raddr )  
            3'b000 : dataout_tmp = ram_q[0];
            3'b001 : dataout_tmp = ram_q[1];
            3'b010 : dataout_tmp = ram_q[2];
            3'b011 : dataout_tmp = ram_q[3];
            3'b100 : dataout_tmp = ram_q[4];
            3'b101 : dataout_tmp = ram_q[5];
            default : dataout_tmp = 0;
        endcase
    end

    // set output
    assign dataout = dataout_tmp;

endmodule


///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixii_lvds_rx_fifo
//
// Description :
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixii_lvds_rx_fifo (wclk, 
                               rclk, 
                               dparst,
                               fiforst, 
                               datain, 
                               dataout
                              );

    parameter channel_width = 10;

    // INPUT PORTS
    input wclk;
    input rclk;
    input dparst;
    input fiforst;
    input datain;

    // OUTPUT PORTS
    output dataout;

    // INTERNAL VARIABLES AND NETS
    reg dataout_tmp;
    wire data_out;

    integer i;
    reg ram_datain;
    wire ram_dataout;

    reg   [2:0]  wrPtr,rdPtr;        // writer pointer, read pointer
    wire  [2:0]  rdAddr;             // read address
    reg ram_we;

    reg wclk_last_value, rclk_last_value;
    reg write_side_sync_reset;
    reg read_side_sync_reset;

    // BUFFER INPUTS
    buf (wclk_in, wclk);
    buf (rclk_in, rclk);
    buf (dparst_in, dparst);
    buf (fiforst_in, fiforst);
    buf (datain_in, datain);
        
    specify
        (posedge rclk => (dataout +: data_out)) = (0, 0);
        (posedge dparst => (dataout +: data_out)) = (0, 0);
    endspecify

    initial
    begin
        dataout_tmp = 0;
        wrPtr = 2'b00;
        rdPtr = 2'b11;
        write_side_sync_reset = 1'b0;
        read_side_sync_reset = 1'b0;
    end

    assign rdAddr = rdPtr;

    stratixii_lvds_rx_fifo_sync_ram  s_fifo_ram (.clk(wclk_in),
                                                 .datain(ram_datain),
                                                 .write_reset(write_side_sync_reset), 
                                                 .waddr(wrPtr),
                                                 .raddr(rdAddr), // rdPtr ??
                                                 .we(ram_we),
                                                 .dataout(ram_dataout)
                                                ); 

    // update pointer and RAM input

    always @(wclk_in or dparst_in)
    begin
        if (dparst_in === 1'b1 || (fiforst_in === 1'b1 && wclk_in === 1'b1 && wclk_last_value === 1'b0)) 
        begin
            write_side_sync_reset <= 1'b1;
            ram_datain <= 1'b0;
            wrPtr <= 0;
            ram_we <= 'b0;
        end
        else if (dparst_in === 1'b0 && (fiforst_in === 1'b0 && wclk_in === 1'b1 && wclk_last_value === 1'b0))
        begin
            write_side_sync_reset <= 1'b0;
        end
        if (wclk_in === 1'b1 && wclk_last_value === 1'b0 && write_side_sync_reset === 1'b0 && fiforst_in === 1'b0 && dparst_in === 1'b0)
        begin
            ram_datain <= datain_in;       // input register
            ram_we <= 'b1;
            wrPtr <= wrPtr + 1;
            if (wrPtr == 5)
                wrPtr <= 0;
        end
        wclk_last_value = wclk_in;
    end

    always @(rclk_in or dparst_in)
    begin
        if (dparst_in === 1'b1 || (fiforst_in === 1'b1 && rclk_in === 1'b1 && rclk_last_value === 1'b0))
        begin
            read_side_sync_reset <= 1'b1;
            rdPtr <= 3;
            dataout_tmp <= 0;
        end
        else if (dparst_in === 1'b0 && (fiforst_in === 1'b0 && rclk_in === 1'b1 && rclk_last_value === 1'b0))
        begin
            read_side_sync_reset <= 0;
        end
        if (rclk_in === 1'b1 && rclk_last_value === 1'b0 && read_side_sync_reset === 1'b0 && fiforst_in === 1'b0 && dparst_in === 1'b0)
        begin
            rdPtr <= rdPtr + 1;
            if (rdPtr == 5)
                rdPtr <= 0;
            dataout_tmp <= ram_dataout;     // output register
        end
        rclk_last_value = rclk_in;
    end

    assign data_out = dataout_tmp;

    buf (dataout, data_out);

endmodule // stratixii_lvds_rx_fifo


///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixii_lvds_rx_bitslip
//
// Description :
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixii_lvds_rx_bitslip (clk0, 
                                  bslipcntl, 
                                  bsliprst, 
                                  datain, 
                                  bslipmax, 
                                  dataout
                                 );

    parameter channel_width = 10;
    parameter bitslip_rollover = 12;
    
    // INPUT PORTS
    input  clk0;
    input  bslipcntl; 
    input  bsliprst; 
    input  datain;
    
    // OUTPUT PORTS
    output bslipmax; 
    output dataout;
   
    // INTERNAL VARIABLES AND NETS 
    integer slip_count;
    integer i, j;
    
    wire dataout_tmp;
    wire dataout_wire;
    wire bslipmax_wire;

    reg clk0_last_value;
    reg bsliprst_last_value;
    reg bslipcntl_last_value;
    reg start_corrupt_bits;
    reg [1:0] num_corrupt_bits;
 
    reg [11:0] bitslip_arr;
    reg bslipmax_tmp;
 
    // BUFFER INPUTS 
    buf (clk0_in, clk0);
    buf (bslipcntl_in, bslipcntl);
    buf (bsliprst_in, bsliprst);
    buf (datain_in, datain);
   
    // TIMING PATHS 
    specify
        (posedge clk0 => (bslipmax +: bslipmax_tmp)) = (0, 0);
        (posedge bsliprst => (bslipmax +: bslipmax_tmp)) = (0, 0);
    endspecify

    initial
    begin
        slip_count = 0;
        bslipmax_tmp = 0;
        bitslip_arr = 12'b0;
        start_corrupt_bits = 0;
        num_corrupt_bits = 0;
    end

    lvds_reg bslipcntlreg (.d(bslipcntl_in),
                           .clk(clk0_in),
                           .ena(1'b1),
                           .clrn(!bsliprst_in),
                           .prn(1'b1),
                           .q(bslipcntl_reg)
                          );

    // 4-bit slip counter
    always @(bslipcntl_reg or bsliprst_in)
    begin
        if (bsliprst_in === 1'b1)
        begin
            slip_count <= 0;
            bslipmax_tmp <= 1'b0;
            if (bsliprst_in === 1'b1 && bsliprst_last_value === 1'b0)
            begin
                $display("Note: Bit Slip Circuit was reset. Serial Data stream will have 0 latency");
                $display("Time: %0t, Instance: %m", $time);
            end
        end
        else if (bslipcntl_reg === 1'b1 && bslipcntl_last_value === 1'b0)
        begin
             start_corrupt_bits <= 1;
             num_corrupt_bits <= 0;
             if (slip_count == bitslip_rollover)
             begin
                 $display("Note: Rollover occurred on Bit Slip circuit. Serial data stream will have 0 latency.");
                 $display("Time: %0t, Instance: %m", $time);
                 slip_count <= 0;
                 bslipmax_tmp <= 1'b0;
             end
             else begin
                 slip_count <= slip_count + 1;
                 if ((slip_count+1) == bitslip_rollover)
                 begin
                     $display("Note: The Bit Slip circuit has reached the maximum Bit Slip limit. Rollover will occur on the next slip.");
                     $display("Time: %0t, Instance: %m", $time);
                     bslipmax_tmp <= 1'b1;
                 end
             end
        end
        else if (bslipcntl_reg === 1'b0 && bslipcntl_last_value === 1'b1)
        begin
            start_corrupt_bits <= 0;
            num_corrupt_bits <= 0;
        end

        bslipcntl_last_value <= bslipcntl_reg;
        bsliprst_last_value <= bsliprst_in;
    end

    // Bit Slip shift register
    always @(clk0_in)
    begin
        if (clk0_in === 1'b1 && clk0_last_value === 1'b0)
        begin
            bitslip_arr[0] <= datain_in;
            for (i = 0; i < bitslip_rollover; i=i+1)
                bitslip_arr[i+1] <= bitslip_arr[i];

            if (start_corrupt_bits == 1'b1)
                num_corrupt_bits <= num_corrupt_bits + 1;
            if (num_corrupt_bits+1 == 3)
                start_corrupt_bits <= 0;
        end

        clk0_last_value <= clk0_in;
    end

    lvds_reg dataoutreg (.d(bitslip_arr[slip_count]),
                         .clk(clk0_in),
                         .ena(1'b1),
                         .clrn(1'b1),
                         .prn(1'b1),
                         .q(dataout_tmp)
                        );

    assign dataout_wire = (start_corrupt_bits == 1'b0) ? dataout_tmp : (num_corrupt_bits < 3) ? 1'bx : dataout_tmp;
    assign bslipmax_wire = bslipmax_tmp;

    and (dataout, dataout_wire, 1'b1);
    and (bslipmax, bslipmax_wire, 1'b1);

endmodule // stratixii_lvds_rx_bitslip

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixii_lvds_rx_deser
//
// Description : Timing simulation model for the STRATIXII LVDS RECEIVER
//               Deserializer. This module receives serial data and outputs
//               parallel data word of width = channel_width
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixii_lvds_rx_deser (clk,
                                datain,
                                devclrn,
                                devpor,
                                dataout
                               );

    parameter channel_width = 10;

    // INPUT PORTS
    input clk;
    input datain;
    input devclrn;
    input devpor;

    // OUTPUT PORTS
    output [9:0] dataout;

    // INTERNAL VARIABLES AND NETS
    reg [9:0] dataout_tmp;
    reg clk_last_value;

    wire [9:0] data_out;
    integer i;

    // BUFFER INPUTS
    buf (clk_in, clk);
    buf (datain_in, datain);

    specify
       (posedge clk => (dataout[0] +: data_out[0])) = (0, 0);
       (posedge clk => (dataout[1] +: data_out[1])) = (0, 0);
       (posedge clk => (dataout[2] +: data_out[2])) = (0, 0);
       (posedge clk => (dataout[3] +: data_out[3])) = (0, 0);
       (posedge clk => (dataout[4] +: data_out[4])) = (0, 0);
       (posedge clk => (dataout[5] +: data_out[5])) = (0, 0);
       (posedge clk => (dataout[6] +: data_out[6])) = (0, 0);
       (posedge clk => (dataout[7] +: data_out[7])) = (0, 0);
       (posedge clk => (dataout[8] +: data_out[8])) = (0, 0);
       (posedge clk => (dataout[9] +: data_out[9])) = (0, 0);
    endspecify

    initial
    begin
        clk_last_value = 0;
        dataout_tmp = 10'b0;
    end

    always @(clk_in or devclrn or devpor)
    begin
        if (devclrn === 1'b0 || devpor === 1'b0)
        begin
            dataout_tmp <= 10'b0;
        end
        else if (clk_in === 1'b1 && clk_last_value === 1'b0)
        begin
            for (i = (channel_width-1); i > 0; i=i-1)
                dataout_tmp[i] <= dataout_tmp[i-1];

            dataout_tmp[0] <= datain_in;
        end

        clk_last_value <= clk_in;
    end

    assign data_out = dataout_tmp;

    // ACCELERATE OUTPUTS
    buf (dataout[0], data_out[0]);
    buf (dataout[1], data_out[1]);
    buf (dataout[2], data_out[2]);
    buf (dataout[3], data_out[3]);
    buf (dataout[4], data_out[4]);
    buf (dataout[5], data_out[5]);
    buf (dataout[6], data_out[6]);
    buf (dataout[7], data_out[7]);
    buf (dataout[8], data_out[8]);
    buf (dataout[9], data_out[9]);

endmodule //stratixii_lvds_rx_deser

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixii_lvds_rx_parallel_reg
//
// Description : Timing simulation model for the STRATIXII LVDS RECEIVER
//               PARALLEL REGISTER. The data width equals max. channel width,
//               which is 10.
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module stratixii_lvds_rx_parallel_reg (clk, 
                                       enable, 
                                       datain, 
                                       dataout, 
//                                       reset,
                                       devclrn, 
                                       devpor
                                      );

    parameter channel_width = 10;

    // INPUT PORTS
    input [9:0] datain;
    input clk;
    input enable;
//    input reset;
    input devclrn;
    input devpor;

    // OUTPUT PORTS
    output [9:0] dataout;

    // INTERNAL VARIABLES AND NETS
    reg clk_last_value;
    reg [9:0] dataout_tmp;
    wire [9:0] dataout_wire;

    // BUFFER INPUTS
    buf (clk_in, clk);
    buf (enable_in, enable);
    buf (datain_in0, datain[0]);
    buf (datain_in1, datain[1]);
    buf (datain_in2, datain[2]);
    buf (datain_in3, datain[3]);
    buf (datain_in4, datain[4]);
    buf (datain_in5, datain[5]);
    buf (datain_in6, datain[6]);
    buf (datain_in7, datain[7]);
    buf (datain_in8, datain[8]);
    buf (datain_in9, datain[9]);

    specify
       (posedge clk => (dataout[0] +: dataout_tmp[0])) = (0, 0);
       (posedge clk => (dataout[1] +: dataout_tmp[1])) = (0, 0);
       (posedge clk => (dataout[2] +: dataout_tmp[2])) = (0, 0);
       (posedge clk => (dataout[3] +: dataout_tmp[3])) = (0, 0);
       (posedge clk => (dataout[4] +: dataout_tmp[4])) = (0, 0);
       (posedge clk => (dataout[5] +: dataout_tmp[5])) = (0, 0);
       (posedge clk => (dataout[6] +: dataout_tmp[6])) = (0, 0);
       (posedge clk => (dataout[7] +: dataout_tmp[7])) = (0, 0);
       (posedge clk => (dataout[8] +: dataout_tmp[8])) = (0, 0);
       (posedge clk => (dataout[9] +: dataout_tmp[9])) = (0, 0);
    endspecify

    initial
    begin
        clk_last_value = 0;
        dataout_tmp = 10'b0;
    end

    always @(clk_in or devpor or devclrn)
    begin
        if ((devpor === 1'b0) || (devclrn === 1'b0))
        begin
            dataout_tmp <= 10'b0;
        end
        else begin
            if ((clk_in === 1) && (clk_last_value !== clk_in))
            begin
//                if (reset === 1)
//                begin
//                    dataout_tmp <= 10'b0;
//                end
//                else if (enable_in === 1)
                if (enable_in === 1)
                begin
                    dataout_tmp[0] <= datain_in0;
                    dataout_tmp[1] <= datain_in1;
                    dataout_tmp[2] <= datain_in2;
                    dataout_tmp[3] <= datain_in3;
                    dataout_tmp[4] <= datain_in4;
                    dataout_tmp[5] <= datain_in5;
                    dataout_tmp[6] <= datain_in6;
                    dataout_tmp[7] <= datain_in7;
                    dataout_tmp[8] <= datain_in8;
                    dataout_tmp[9] <= datain_in9;
                end
            end
        end

        clk_last_value <= clk_in;

    end //always

    assign dataout_wire = dataout_tmp;
      
    and (dataout[0], dataout_wire[0], 1'b1);
    and (dataout[1], dataout_wire[1], 1'b1);
    and (dataout[2], dataout_wire[2], 1'b1);
    and (dataout[3], dataout_wire[3], 1'b1);
    and (dataout[4], dataout_wire[4], 1'b1);
    and (dataout[5], dataout_wire[5], 1'b1);
    and (dataout[6], dataout_wire[6], 1'b1);
    and (dataout[7], dataout_wire[7], 1'b1);
    and (dataout[8], dataout_wire[8], 1'b1);
    and (dataout[9], dataout_wire[9], 1'b1);

endmodule //stratixii_lvds_rx_parallel_reg

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : lvds_reg
//
// Description : Simulation model for a simple DFF.
//               This is used for registering the enable inputs.
//               No timing, powers upto 0.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ps / 1ps
module lvds_reg (q,
                clk,
                ena,
                d,
                clrn,
                prn
               );

    // INPUT PORTS
    input d;
    input clk;
    input clrn;
    input prn;
    input ena;

    // OUTPUT PORTS
    output q;

    // BUFFER INPUTS
    buf (clk_in, clk);
    buf (ena_in, ena);
    buf (d_in, d);

    // INTERNAL VARIABLES
    reg q_tmp;
    wire q_wire;

    // TIMING PATHS
    specify
       $setuphold(posedge clk, d, 0, 0);
       (posedge clk => (q +: q_tmp)) = (0, 0);
       (negedge clrn => (q +: q_tmp)) = (0, 0);
       (negedge prn => (q +: q_tmp)) = (0, 0);
    endspecify

    // DEFAULT VALUES THRO' PULLUPs
    tri1 prn, clrn, ena;

    initial q_tmp = 0;

    always @ (posedge clk_in or negedge clrn or negedge prn )
    begin
        if (prn == 1'b0)
            q_tmp <= 1;
        else if (clrn == 1'b0)
            q_tmp <= 0;
        else if ((clk_in == 1) & (ena_in == 1'b1))
            q_tmp <= d_in;
    end

    assign q_wire = q_tmp;

    and (q, q_wire, 1'b1);

endmodule // lvds_reg

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : STRATIXII_LVDS_RECEIVER
//
// Description : Timing simulation model for the STRATIXII LVDS RECEIVER
//               atom. This module instantiates the following sub-modules :
//               1) stratixii_lvds_rx_fifo
//               2) stratixii_lvds_rx_bitslip
//               3) DFFEs for the LOADEN signals
//               4) stratixii_lvds_rx_deser
//               5) stratixii_lvds_rx_parallel_reg
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module stratixii_lvds_receiver (clk0,
                                datain,
                                enable0,
                                dpareset,
                                dpahold,
                                dpaswitch,
                                fiforeset,
                                bitslip,
                                bitslipreset,
                                serialfbk,
                                dataout,
                                dpalock,
                                bitslipmax,
                                serialdataout,
                                postdpaserialdataout,
                                devclrn,
                                devpor
                               );

    parameter channel_width             = 10;
    parameter data_align_rollover       = 2;
    parameter enable_dpa                = "off";
    parameter lose_lock_on_one_change   = "off";
    parameter reset_fifo_at_first_lock  = "on";
    parameter align_to_rising_edge_only = "on";
    parameter use_serial_feedback_input = "off";
    parameter dpa_debug                 = "off";
    parameter lpm_type                  = "stratixii_lvds_receiver";

    // INPUT PORTS
    input clk0;
    input datain;
    input enable0;
    input dpareset;
    input dpahold;
    input dpaswitch;
    input fiforeset;
    input bitslip;
    input bitslipreset;
    input serialfbk;
    input devclrn;
    input devpor;

    // OUTPUT PORTS
    output [9:0] dataout;
    output dpalock;
    output bitslipmax;
    output serialdataout;
    output postdpaserialdataout;

    // BUFFER INPUTS 
    buf (clk0_in, clk0);
    buf (datain_in, datain);
    buf (enable0_in, enable0);
    buf (dpareset_in, dpareset);
    buf (dpahold_in, dpahold);
    buf (dpaswitch_ipd, dpaswitch);
    buf (fiforeset_in, fiforeset);
    buf (bitslip_in, bitslip);
    buf (bitslipreset_in, bitslipreset);
    buf (serialfbk_in, serialfbk);

    // INTERNAL NETS AND VARIABLES
    wire fifo_wclk;
    wire fifo_rclk;
    wire fifo_datain;
    wire fifo_dataout;
    wire fifo_reset;

    wire slip_datain;
    wire slip_dataout;
    wire bitslip_reset;

    wire [9:0] deser_dataout;
    wire dpareg0_out;
    wire dpareg1_out;
    wire dpa_clk;
    wire dpa_rst;
 
    wire datain_reg;
    reg clk0_last_value;
    reg dpa_is_locked;
    reg dparst_msg;
    reg reset_fifo;
    reg first_dpa_lock;
    reg [3:0] dpa_lock_count;

    wire [9:0] loadreg_datain;

    wire reset_int;
    wire gnd;
    wire serialdataout_tmp;
    wire postdpaserialdataout_tmp;
    wire in_reg_data;
    wire datain_tmp;
    wire dpalock_tmp;

    integer i;

    // INTERNAL PARAMETERS
    parameter DPA_CYCLES_TO_LOCK = 2;


    // TIMING PATHS
    specify
        (posedge clk0 => (dpalock +: dpalock_tmp)) = (0, 0);
    endspecify

    assign gnd = 1'b0;

    // fifo read and write clks
    assign fifo_rclk = (enable_dpa == "on") ? clk0_in : gnd;
    assign fifo_wclk = dpa_clk;

    assign fifo_datain = (enable_dpa == "on") ? dpareg1_out : gnd;

    assign reset_int = (!devpor) || (!devclrn);
    assign fifo_reset = (!devpor) || (!devclrn) || fiforeset_in || reset_fifo;
    assign bitslip_reset = (!devpor) || (!devclrn) || bitslipreset_in;

    assign in_reg_data = (use_serial_feedback_input == "on") ? serialfbk_in : datain_in;

    initial
    begin
        dpa_is_locked = 0;
        dparst_msg = 0;
        first_dpa_lock = 1;
        dpa_lock_count = 0;
        if (reset_fifo_at_first_lock == "on")
            reset_fifo = 1;
        else
            reset_fifo = 0;
    end

    // SUB-MODULE INSTANTIATION

    // input register in non-DPA mode for sampling incoming data
    lvds_reg in_reg (.d(in_reg_data),
                     .clk(clk0_in),
                     .ena(1'b1),
                     .clrn(devclrn || devpor),
                     .prn(1'b1),
                     .q(datain_reg)
                    );

    assign dpa_clk = (enable_dpa == "on") ? clk0_in : 1'b0;
    assign dpa_rst = (enable_dpa == "on") ? dpareset_in : 1'b0;

    always @(posedge dpa_clk or posedge dpa_rst)
    begin
            if (dpa_rst === 1'b1)
            begin
                dpa_is_locked <= 0;
                dpa_lock_count = 0;
                // give message only once
                if (dparst_msg === 1'b0)
                begin
                    $display("DPA was reset");
                    $display("Time: %0t, Instance: %m", $time);
                    dparst_msg = 1;
                end
            end
            else begin
                dparst_msg = 0;
                if (dpa_is_locked === 1'b0)
                begin
                    dpa_lock_count = dpa_lock_count + 1;
                    if (dpa_lock_count > DPA_CYCLES_TO_LOCK)
                    begin
                        dpa_is_locked <= 1;
                        $display("DPA locked");
                        $display("Time: %0t, Instance: %m", $time);
                        reset_fifo <= 0;
                    end
                end
            end
    end

    // ?????????? insert delay to mimic DPLL dataout ?????????

    // DPA registers
    lvds_reg dpareg0 (.d(in_reg_data),
                     .clk(dpa_clk),
                     .clrn(1'b1),
                     .prn(1'b1),
                     .ena(1'b1),
                     .q(dpareg0_out)
                    );

    lvds_reg dpareg1 (.d(dpareg0_out),
                     .clk(dpa_clk),
                     .clrn(1'b1),
                     .prn(1'b1),
                     .ena(1'b1),
                     .q(dpareg1_out)
                    );

    stratixii_lvds_rx_fifo    s_fifo (.wclk(fifo_wclk),
                                      .rclk(fifo_rclk),
                                      .fiforst(fifo_reset),
                                      .dparst(dpa_rst),
                                      .datain(fifo_datain),
                                      .dataout(fifo_dataout)
                                     );
    defparam s_fifo.channel_width = channel_width;

    assign slip_datain = (enable_dpa == "on" && dpaswitch_ipd === 1'b1) ? fifo_dataout : datain_reg;

    stratixii_lvds_rx_bitslip    s_bslip (.clk0(clk0_in),
                                          .bslipcntl(bitslip_in),
                                          .bsliprst(bitslip_reset),
                                          .datain(slip_datain),
                                          .bslipmax(bitslipmax),
                                          .dataout(slip_dataout)
                                         );
    defparam s_bslip.channel_width = channel_width;
    defparam s_bslip.bitslip_rollover = data_align_rollover;


    //********* DESERIALISER *********//

    // only 1 enable signal used for StratixII
    lvds_reg rxload_reg (.d(enable0_in),
                     .clk(clk0_in),
                     .ena(1'b1),
                     .clrn(1'b1),
                     .prn(1'b1),
                     .q(rxload)
                    );

    stratixii_lvds_rx_deser    s_deser (.clk(clk0_in),
                                        .datain(slip_dataout),
                                        .devclrn(devclrn),
                                        .devpor(devpor),
                                        .dataout(deser_dataout)
                                       );
    defparam s_deser.channel_width = channel_width;

    stratixii_lvds_rx_parallel_reg  output_reg  (.clk(clk0_in),
                                               .enable(rxload),
                                               .datain(deser_dataout), 
                                               .devpor(devpor),
                                               .devclrn(devclrn),
                                               .dataout(dataout)
                                              );
    defparam output_reg.channel_width = channel_width;


    // generate outputs
    assign dpalock_tmp = (enable_dpa == "on") ? dpa_is_locked : gnd;

    assign postdpaserialdataout_tmp = dpareg1_out;
    assign datain_tmp = datain_in;

    and (postdpaserialdataout, postdpaserialdataout_tmp, 1'b1);
    and (serialdataout, datain_tmp, 1'b1);
    and (dpalock, dpalock_tmp, 1'b1);

endmodule // stratixii_lvds_receiver
///////////////////////////////////////////////////////////////////////
//
//              	STRATIXII RUBLOCK ATOM 
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module  stratixii_rublock 
	(
	clk, 
	shiftnld, 
	captnupdt, 
	regin, 
	rsttimer, 
	rconfig, 
	regout, 
	pgmout
	);

	parameter operation_mode			= "remote";
	parameter sim_init_config			= "factory";
	parameter sim_init_watchdog_value	= 0;
	parameter sim_init_page_select		= 0;
	parameter sim_init_status			= 0;
	parameter lpm_type					= "stratixii_rublock";

	input clk;
	input shiftnld;
	input captnupdt;
	input regin;
	input rsttimer;
	input rconfig;

	output regout;
	output [2:0] pgmout;

	reg [20:0] update_reg;
	reg [4:0] status_reg;
	reg [25:0] shift_reg;

	reg [2:0] pgmout_update;

	integer i;

	// initialize registers
	initial
	begin
		if (operation_mode == "local")
			// PGM[] output
			pgmout_update = 1;	
		else if (operation_mode == "remote")
			// PGM[] output
			pgmout_update = 0;	
		else
			pgmout_update <= 'bx;			


		// Shift reg
		shift_reg = 0;

		// Status reg
		status_reg = sim_init_status;
		
		// wd_timeout field
		update_reg[20:9] = sim_init_watchdog_value;

		// wd enable field
		if (sim_init_watchdog_value > 0)
			update_reg[8] = 1;
		else
			update_reg[8] = 0;
		
		// PGM[] field
		update_reg[7:1] = sim_init_page_select;

		// AnF bit
		if (sim_init_config == "factory")
			update_reg[0] = 0;
		else
			update_reg[0] = 1;

		$display("Info: Remote Update Block: Initial configuration:");
		$display("        -> Field CRC, POF ID, SW ID Error Caused Reconfiguration is set to %s", status_reg[0] ? "True" : "False");
		$display("        -> Field nSTATUS Caused Reconfiguration is set to %s", status_reg[1] ? "True" : "False");
		$display("        -> Field Core nCONFIG Caused Reconfiguration is set to %s", status_reg[2] ? "True" : "False");
		$display("        -> Field Pin nCONFIG Caused Reconfiguration is set to %s", status_reg[3] ? "True" : "False");
		$display("        -> Field Watchdog Timeout Caused Reconfiguration is set to %s", status_reg[4] ? "True" : "False");
		$display("        -> Field Configuration Mode is set to %s", update_reg[0] ? "Application" : "Factory");
		$display("        -> Field PGM[] Page Select is set to %d", update_reg[7:1]);
		$display("        -> Field User Watchdog is set to %s", update_reg[8] ? "Enabled" : "Disabled");
		$display("        -> Field User Watchdog Timeout Value is set to %d", update_reg[20:9]);

	end

	// regout is inverted output of shift-reg bit 0
	assign regout = !shift_reg[0];

	// pgmout is set when reconfig is asserted
	assign pgmout = pgmout_update;

	always @(clk)
	begin
		if (clk == 1)
		begin
			if (shiftnld == 1)
			begin
				// register shifting
				for (i=0; i<=24; i=i+1)
				begin
					shift_reg[i] <= shift_reg[i+1];
				end

				shift_reg[25] <= regin;
			end
			else if (shiftnld == 0)
			begin
				// register loading
				if (captnupdt == 1)
				begin
					// capture data into shift register
					shift_reg <= {update_reg, status_reg};
				end
				else if (captnupdt == 0)
				begin
					// update data from shift into Update Register

					if ( (operation_mode == "remote" || operation_mode =="active_serial_remote")
							&& sim_init_config == "factory")
					begin
						// every bit in Update Reg gets updated
						update_reg[20:0] <= shift_reg[25:5];

						$display("Info: Remote Update Block: Update Register updated at time %d ps", $time);
						$display("        -> Field Configuration Mode is set to %s", shift_reg[5] ? "Application" : "Factory");
						$display("        -> Field PGM[] Page Select is set to %d", shift_reg[12:6]);
						$display("        -> Field User Watchdog is set to %s", (shift_reg[13] == 1) ? "Enabled" : (shift_reg[13] == 0) ? "Disabled" : "x");
						$display("        -> Field User Watchdog Timeout Value is set to %d", shift_reg[25:14]);
					end
					else
					begin
						// trying to do update in Application mode
						$display("Warning: Remote Update Block: Attempted update of Update Register at time %d ps when Configuration is set to Application", $time);
					end

				end
				else
				begin
					// invalid captnupdt
					// destroys update and shift regs
					shift_reg <= 'bx;
					if (sim_init_config == "factory")
					begin
						update_reg[20:1] <= 'bx;
					end
				end
			end
			else
			begin
				// invalid shiftnld: destroys update and shift regs
				shift_reg <= 'bx;
				if (sim_init_config == "factory")
				begin
					update_reg[20:1] <= 'bx;
				end
			end
		end
		else if (clk != 0)
		begin
			// invalid clk: destroys registers
			shift_reg <= 'bx;
			if (sim_init_config == "factory")
			begin
				update_reg[20:1] <= 'bx;
			end
		end
	end

	always @(rconfig)
	begin
		if (rconfig == 1)
		begin
			// start reconfiguration
			$display("Info: Remote Update Block: Reconfiguration initiated at time %d ps", $time);
			$display("        -> Field Configuration Mode is set to %s", update_reg[0] ? "Application" : "Factory");
			$display("        -> Field PGM[] Page Select is set to %d", update_reg[7:1]);
			$display("        -> Field User Watchdog is set to %s", (update_reg[8] == 1) ? "Enabled" : (update_reg[8] == 0) ? "Disabled" : "x");
			$display("        -> Field User Watchdog Timeout Value is set to %d", update_reg[20:9]);

			if (operation_mode == "remote")
			begin
				// set pgm[] to page as set in Update Register
				pgmout_update <= update_reg[3:1];
			end
			else if (operation_mode == "local")
			begin
				// set pgm[] to page as 001
				pgmout_update <= 'b001;
			end
			else
			begin
				// invalid rconfig: destroys pgmout
				pgmout_update <= 'bx;			
			end
		end
		else if (rconfig != 0)
		begin
			// invalid rconfig: destroys pgmout
			pgmout_update <= 'bx;			
		end
	end


endmodule

