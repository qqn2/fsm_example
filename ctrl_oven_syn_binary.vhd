
-- 
-- Definition of  ctrl_oven
-- 
--      Mon 14 Dec 2020 09:15:21 AM CET
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
   signal full_EXMPLR, half_EXMPLR, start_count_EXMPLR, finished_EXMPLR, 
      CS_0, CS_2, CS_1, nx12, nx30, nx42, nx44, nx56, nx68, nx78, nx92, 
      nx120, nx124, nx144, nx430, nx433, nx436, nx438, nx440, nx444, nx448, 
      nx451, nx453, nx456, nx458, nx462, nx464, nx468, nx471, nx473, nx482, 
      nx485, nx490, nx492, nx495: std_logic ;

begin
   full <= full_EXMPLR ;
   half <= half_EXMPLR ;
   finished <= finished_EXMPLR ;
   start_count <= start_count_EXMPLR ;
   ix53 : NOR21 port map ( Q=>finished_EXMPLR, A=>nx430, B=>nx440);
   ix69 : IMUX21 port map ( Q=>nx68, A=>nx433, B=>door_open, S=>
      finished_EXMPLR);
   ix434 : NOR21 port map ( Q=>nx433, A=>nx56, B=>CS_2);
   ix57 : AOI211 port map ( Q=>nx56, A=>nx436, B=>nx438, C=>nx440);
   ix437 : CLKIN1 port map ( Q=>nx436, A=>door_open);
   ix439 : CLKIN1 port map ( Q=>nx438, A=>time_set);
   ix441 : NAND21 port map ( Q=>nx440, A=>CS_1, B=>CS_0);
   ix125 : NAND31 port map ( Q=>nx124, A=>nx448, B=>nx462, C=>nx464);
   ix449 : AOI211 port map ( Q=>nx448, A=>timeout, B=>start_count_EXMPLR, C
      =>nx120);
   reg_CS_1 : DFC1 port map ( Q=>CS_1, QN=>nx451, C=>clk, D=>nx44, RN=>nx453
   );
   ix454 : CLKIN1 port map ( Q=>nx453, A=>reset);
   ix121 : OAI221 port map ( Q=>nx120, A=>half_power, B=>nx444, C=>nx456, D
      =>nx458);
   ix457 : NOR31 port map ( Q=>nx456, A=>s60, B=>s120, C=>s30);
   ix459 : NAND21 port map ( Q=>nx458, A=>CS_1, B=>nx30);
   ix31 : NOR21 port map ( Q=>nx30, A=>CS_2, B=>CS_0);
   reg_CS_2 : DFC1 port map ( Q=>CS_2, QN=>nx430, C=>clk, D=>nx68, RN=>nx453
   );
   ix463 : AOI221 port map ( Q=>nx462, A=>full_power, B=>nx30, C=>nx436, D=>
      finished_EXMPLR);
   ix465 : AOI311 port map ( Q=>nx464, A=>nx78, B=>door_open, C=>nx468, D=>
      nx92);
   ix79 : OAI211 port map ( Q=>nx78, A=>nx451, B=>half_EXMPLR, C=>nx430);
   ix93 : NOR40 port map ( Q=>nx92, A=>nx451, B=>nx471, C=>time_set, D=>CS_2
   );
   reg_CS_0 : DFC1 port map ( Q=>CS_0, QN=>nx471, C=>clk, D=>nx124, RN=>
      nx453);
   ix474 : NOR40 port map ( Q=>nx473, A=>s60, B=>s120, C=>s30, D=>half_power
   );
   ix13 : OAI221 port map ( Q=>nx12, A=>nx430, B=>nx482, C=>time_set, D=>
      nx440);
   ix483 : AOI211 port map ( Q=>nx482, A=>start, B=>nx471, C=>CS_1);
   ix157 : OAI311 port map ( Q=>in_light, A=>nx471, B=>nx430, C=>CS_1, D=>
      nx485);
   ix486 : NAND31 port map ( Q=>nx485, A=>nx471, B=>CS_2, C=>CS_1);
   ix137 : NOR31 port map ( Q=>full_EXMPLR, A=>nx471, B=>CS_2, C=>CS_1);
   reg_stop_count : DFC1 port map ( Q=>stop_count, QN=>OPEN, C=>clk, D=>
      nx144, RN=>nx453);
   ix145 : NOR40 port map ( Q=>nx144, A=>CS_0, B=>nx430, C=>nx451, D=>nx490
   );
   ix491 : NAND21 port map ( Q=>nx490, A=>nx124, B=>nx492);
   ix493 : AOI211 port map ( Q=>nx492, A=>nx436, B=>nx12, C=>nx42);
   ix43 : OAI221 port map ( Q=>nx42, A=>nx444, B=>nx473, C=>full_power, D=>
      nx495);
   ix496 : OAI211 port map ( Q=>nx495, A=>half_power, B=>CS_1, C=>nx30);
   ix45 : CLKIN1 port map ( Q=>nx44, A=>nx492);
   ix469 : CLKIN1 port map ( Q=>nx468, A=>finished_EXMPLR);
   ix111 : CLKIN1 port map ( Q=>start_count_EXMPLR, A=>nx485);
   ix33 : CLKIN1 port map ( Q=>half_EXMPLR, A=>nx458);
   ix445 : CLKIN1 port map ( Q=>nx444, A=>full_EXMPLR);
end ctrl_oven_arc ;

