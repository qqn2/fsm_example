
-- 
-- Definition of  ctrl_oven
-- 
--      Mon 14 Dec 2020 11:14:37 AM CET
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
   signal start_count_EXMPLR, finished_EXMPLR, CS_0, CS_2, CS_1, nx12, nx30, 
      nx42, nx44, nx56, nx68, nx78, nx92, nx120, nx124, nx144, nx430, nx433, 
      nx436, nx440, nx444, nx447, nx450, nx452, nx455, nx457, nx459, nx462, 
      nx465, nx467, nx469, nx471, nx474, nx476, nx478, nx481, nx484, nx490, 
      nx492, nx495: std_logic ;

begin
   finished <= finished_EXMPLR ;
   start_count <= start_count_EXMPLR ;
   ix53 : NOR21 port map ( Q=>finished_EXMPLR, A=>nx430, B=>nx476);
   ix69 : OAI211 port map ( Q=>nx68, A=>door_open, B=>nx433, C=>nx478);
   ix434 : NAND31 port map ( Q=>nx433, A=>CS_2, B=>CS_1, C=>CS_0);
   reg_CS_2 : DFC1 port map ( Q=>CS_2, QN=>nx430, C=>clk, D=>nx68, RN=>nx436
   );
   ix437 : CLKIN1 port map ( Q=>nx436, A=>reset);
   ix45 : OAI2111 port map ( Q=>nx44, A=>nx440, B=>nx465, C=>nx467, D=>nx471
   );
   ix441 : NAND31 port map ( Q=>nx440, A=>CS_0, B=>nx430, C=>nx447);
   ix125 : NAND31 port map ( Q=>nx124, A=>nx444, B=>nx455, C=>nx459);
   ix445 : AOI211 port map ( Q=>nx444, A=>timeout, B=>start_count_EXMPLR, C
      =>nx120);
   ix111 : NOR31 port map ( Q=>start_count_EXMPLR, A=>CS_0, B=>nx430, C=>
      nx447);
   reg_CS_1 : DFC1 port map ( Q=>CS_1, QN=>nx447, C=>clk, D=>nx44, RN=>nx436
   );
   ix121 : OAI221 port map ( Q=>nx120, A=>half_power, B=>nx440, C=>nx450, D
      =>nx452);
   ix451 : NOR31 port map ( Q=>nx450, A=>s60, B=>s120, C=>s30);
   ix453 : NAND21 port map ( Q=>nx452, A=>CS_1, B=>nx30);
   ix31 : NOR21 port map ( Q=>nx30, A=>CS_2, B=>CS_0);
   ix456 : AOI221 port map ( Q=>nx455, A=>full_power, B=>nx30, C=>nx457, D=>
      finished_EXMPLR);
   ix458 : CLKIN1 port map ( Q=>nx457, A=>door_open);
   ix460 : AOI311 port map ( Q=>nx459, A=>nx78, B=>door_open, C=>nx433, D=>
      nx92);
   ix79 : OAI211 port map ( Q=>nx78, A=>nx447, B=>nx462, C=>nx430);
   reg_CS_0 : DFC1 port map ( Q=>CS_0, QN=>nx462, C=>clk, D=>nx124, RN=>
      nx436);
   ix93 : NOR40 port map ( Q=>nx92, A=>nx447, B=>nx462, C=>time_set, D=>CS_2
   );
   ix466 : NOR40 port map ( Q=>nx465, A=>s60, B=>s120, C=>s30, D=>half_power
   );
   ix468 : OAI2111 port map ( Q=>nx467, A=>half_power, B=>CS_1, C=>nx469, D
      =>nx30);
   ix470 : CLKIN1 port map ( Q=>nx469, A=>full_power);
   ix472 : NAND21 port map ( Q=>nx471, A=>nx457, B=>nx12);
   ix13 : OAI221 port map ( Q=>nx12, A=>nx430, B=>nx474, C=>time_set, D=>
      nx476);
   ix475 : AOI211 port map ( Q=>nx474, A=>start, B=>nx462, C=>CS_1);
   ix477 : NAND21 port map ( Q=>nx476, A=>CS_1, B=>CS_0);
   ix479 : OAI211 port map ( Q=>nx478, A=>nx56, B=>CS_2, C=>nx433);
   ix57 : AOI211 port map ( Q=>nx56, A=>nx457, B=>nx481, C=>nx476);
   ix482 : CLKIN1 port map ( Q=>nx481, A=>time_set);
   ix157 : OAI311 port map ( Q=>in_light, A=>nx462, B=>nx430, C=>CS_1, D=>
      nx484);
   ix485 : NAND31 port map ( Q=>nx484, A=>nx462, B=>CS_2, C=>CS_1);
   ix33 : NOR31 port map ( Q=>half, A=>nx447, B=>CS_2, C=>CS_0);
   ix137 : NOR31 port map ( Q=>full, A=>nx462, B=>CS_2, C=>CS_1);
   reg_stop_count : DFC1 port map ( Q=>stop_count, QN=>OPEN, C=>clk, D=>
      nx144, RN=>nx436);
   ix145 : NOR40 port map ( Q=>nx144, A=>CS_0, B=>nx430, C=>nx447, D=>nx490
   );
   ix491 : NAND21 port map ( Q=>nx490, A=>nx124, B=>nx492);
   ix493 : AOI211 port map ( Q=>nx492, A=>nx457, B=>nx12, C=>nx42);
   ix43 : OAI221 port map ( Q=>nx42, A=>nx440, B=>nx465, C=>full_power, D=>
      nx495);
   ix496 : OAI211 port map ( Q=>nx495, A=>half_power, B=>CS_1, C=>nx30);

end ctrl_oven_arc ;

