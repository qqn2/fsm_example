
-- 
-- Definition of  ctrl_oven
-- 
--      Mon 14 Dec 2020 11:25:56 AM CET
--      
--      LeonardoSpectrum Level 3, 2014a.12
-- 

library IEEE;
use IEEE.STD_LOGIC_1164.all;


library c35_CORELIB;
use c35_CORELIB.vcomponents.all;

entity ctrl_oven is
   port (
      clk : IN std_logic ;
      reset : IN std_logic ;
      half_power : IN std_logic ;
      full_power : IN std_logic ;
      start : IN std_logic ;
      s30 : IN std_logic ;
      s60 : IN std_logic ;
      s120 : IN std_logic ;
      time_set : IN std_logic ;
      door_open : IN std_logic ;
      timeout : IN std_logic ;
      full : OUT std_logic ;
      half : OUT std_logic ;
      finished : OUT std_logic ;
      in_light : OUT std_logic ;
      start_count : OUT std_logic ;
      stop_count : OUT std_logic) ;
end ctrl_oven ;

architecture ctrl_oven_arc of ctrl_oven is
   signal in_light_EXMPLR, CS_1, CS_2, CS_0, nx8, nx14, nx428, nx20, nx36, 
      nx46, nx48, nx50, nx72, nx94, nx102, nx114, nx116, nx146, nx438, nx440, 
      nx443, nx446, nx450, nx452, nx454, nx456, nx458, nx461, nx463, nx465, 
      nx467, nx470, nx472, nx475, nx478, nx481, nx485, nx487, nx489, nx497, 
      nx502: std_logic ;

begin
   in_light <= in_light_EXMPLR ;
   ix141 : NOR31 port map ( Q=>finished, A=>CS_0, B=>nx443, C=>CS_1);
   ix51 : CLKIN1 port map ( Q=>nx50, A=>nx438);
   ix439 : AOI2111 port map ( Q=>nx438, A=>nx440, B=>nx20, C=>nx48, D=>nx14
   );
   ix441 : AOI2111 port map ( Q=>nx440, A=>door_open, B=>in_light_EXMPLR, C
      =>nx116, D=>nx94);
   ix57 : NOR21 port map ( Q=>in_light_EXMPLR, A=>nx443, B=>nx461);
   ix73 : OAI2111 port map ( Q=>nx72, A=>door_open, B=>nx443, C=>nx446, D=>
      nx467);
   ix447 : OAI2111 port map ( Q=>nx446, A=>door_open, B=>time_set, C=>CS_1, 
      D=>nx461);
   ix123 : OAI2111 port map ( Q=>nx428, A=>nx450, B=>nx456, C=>nx458, D=>
      nx470);
   ix451 : NAND31 port map ( Q=>nx450, A=>nx452, B=>nx443, C=>CS_0);
   reg_CS_1 : DFC1 port map ( Q=>CS_1, QN=>nx452, C=>clk, D=>nx428, RN=>
      nx454);
   ix455 : CLKIN1 port map ( Q=>nx454, A=>reset);
   ix457 : NOR40 port map ( Q=>nx456, A=>s30, B=>s60, C=>s120, D=>half_power
   );
   ix459 : AOI221 port map ( Q=>nx458, A=>door_open, B=>in_light_EXMPLR, C=>
      CS_1, D=>nx114);
   ix115 : OAI2111 port map ( Q=>nx114, A=>full_power, B=>nx461, C=>nx463, D
      =>nx467);
   reg_CS_0 : DFC1 port map ( Q=>CS_0, QN=>nx461, C=>clk, D=>nx50, RN=>nx454
   );
   ix464 : OAI311 port map ( Q=>nx463, A=>door_open, B=>nx465, C=>nx443, D=>
      nx461);
   ix466 : CLKIN1 port map ( Q=>nx465, A=>start);
   ix468 : NAND21 port map ( Q=>nx467, A=>CS_2, B=>CS_0);
   reg_CS_2 : DFC1 port map ( Q=>CS_2, QN=>nx443, C=>clk, D=>nx72, RN=>nx454
   );
   ix471 : NAND31 port map ( Q=>nx470, A=>nx443, B=>half_power, C=>nx472);
   ix473 : CLKIN1 port map ( Q=>nx472, A=>full_power);
   ix117 : AOI211 port map ( Q=>nx116, A=>nx475, B=>nx467, C=>nx452);
   ix103 : NAND31 port map ( Q=>nx102, A=>nx478, B=>start, C=>CS_2);
   ix479 : CLKIN1 port map ( Q=>nx478, A=>door_open);
   ix95 : OAI221 port map ( Q=>nx94, A=>nx450, B=>nx456, C=>CS_2, D=>nx481);
   ix482 : NAND21 port map ( Q=>nx481, A=>half_power, B=>nx472);
   ix21 : OAI211 port map ( Q=>nx20, A=>nx472, B=>CS_2, C=>nx452);
   ix49 : OAI221 port map ( Q=>nx48, A=>nx440, B=>nx485, C=>timeout, D=>
      nx489);
   ix486 : AOI221 port map ( Q=>nx485, A=>half_power, B=>nx452, C=>door_open, 
      D=>nx487);
   ix488 : NAND21 port map ( Q=>nx487, A=>nx443, B=>CS_0);
   ix490 : NAND21 port map ( Q=>nx489, A=>nx452, B=>in_light_EXMPLR);
   ix15 : NOR40 port map ( Q=>nx14, A=>s120, B=>s60, C=>s30, D=>nx487);
   ix43 : NOR21 port map ( Q=>start_count, A=>CS_1, B=>nx467);
   ix133 : NOR21 port map ( Q=>half, A=>nx452, B=>nx487);
   ix131 : NOR21 port map ( Q=>full, A=>CS_1, B=>nx487);
   reg_stop_count : DFC1 port map ( Q=>stop_count, QN=>OPEN, C=>clk, D=>
      nx146, RN=>nx454);
   ix147 : NOR40 port map ( Q=>nx146, A=>CS_1, B=>nx443, C=>nx461, D=>nx497
   );
   ix498 : OAI311 port map ( Q=>nx497, A=>nx46, B=>nx36, C=>nx14, D=>nx428);
   ix47 : NOR21 port map ( Q=>nx46, A=>timeout, B=>nx489);
   ix37 : OAI221 port map ( Q=>nx36, A=>nx478, B=>nx8, C=>nx502, D=>CS_1);
   ix9 : NOR21 port map ( Q=>nx8, A=>CS_2, B=>nx461);
   ix503 : CLKIN1 port map ( Q=>nx502, A=>half_power);
   ix476 : IMUX21 port map ( Q=>nx475, A=>nx472, B=>nx102, S=>nx461);
end ctrl_oven_arc ;

