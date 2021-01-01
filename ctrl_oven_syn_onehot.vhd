
-- 
-- Definition of  ctrl_oven
-- 
--      Mon 14 Dec 2020 11:21:23 AM CET
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
   signal finished_EXMPLR, start_count_EXMPLR, half_EXMPLR, full_EXMPLR, nx2, 
      CS_0, CS_4, CS_5, CS_3, nx46, nx50, nx60, nx78, nx94, nx106, nx114, 
      nx122, nx128, nx138, nx144, nx872, nx875, nx878, nx881, nx884, nx887, 
      nx890, nx893, nx897, nx901, nx905, nx908, nx910, nx912, nx913, nx915, 
      nx919, nx921, nx924, nx927: std_logic ;

begin
   full <= full_EXMPLR ;
   half <= half_EXMPLR ;
   finished <= finished_EXMPLR ;
   start_count <= start_count_EXMPLR ;
   ix61 : AOI311 port map ( Q=>nx60, A=>nx875, B=>nx912, C=>nx924, D=>nx927
   );
   ix51 : OAI311 port map ( Q=>nx50, A=>nx875, B=>time_set, C=>door_open, D
      =>nx878);
   ix879 : NAND21 port map ( Q=>nx878, A=>nx2, B=>nx46);
   ix3 : CLKIN1 port map ( Q=>nx2, A=>nx881);
   ix882 : NOR31 port map ( Q=>nx881, A=>s60, B=>s120, C=>s30);
   ix47 : OAI221 port map ( Q=>nx46, A=>full_power, B=>nx884, C=>half_power, 
      D=>nx919);
   ix129 : OAI311 port map ( Q=>nx128, A=>nx2, B=>full_power, C=>nx884, D=>
      nx887);
   ix888 : OAI211 port map ( Q=>nx887, A=>nx122, B=>full_EXMPLR, C=>
      half_power);
   ix123 : NOR21 port map ( Q=>nx122, A=>full_power, B=>nx890);
   reg_CS_0 : DFP1 port map ( Q=>CS_0, QN=>nx890, C=>clk, D=>nx114, SN=>
      nx908);
   ix115 : OAI311 port map ( Q=>nx114, A=>nx890, B=>half_power, C=>
      full_power, D=>nx893);
   ix894 : NAND21 port map ( Q=>nx893, A=>door_open, B=>finished_EXMPLR);
   reg_CS_7 : DFC1 port map ( Q=>finished_EXMPLR, QN=>OPEN, C=>clk, D=>nx106, 
      RN=>nx908);
   ix107 : NOR21 port map ( Q=>nx106, A=>door_open, B=>nx897);
   ix898 : AOI211 port map ( Q=>nx897, A=>timeout, B=>start_count_EXMPLR, C
      =>finished_EXMPLR);
   reg_CS_6 : DFC1 port map ( Q=>start_count_EXMPLR, QN=>nx915, C=>clk, D=>
      nx94, RN=>nx908);
   ix95 : NOR21 port map ( Q=>nx94, A=>door_open, B=>nx901);
   ix902 : AOI221 port map ( Q=>nx901, A=>start, B=>CS_4, C=>nx913, D=>
      start_count_EXMPLR);
   reg_CS_4 : DFC1 port map ( Q=>CS_4, QN=>nx912, C=>clk, D=>nx78, RN=>nx908
   );
   ix79 : AOI211 port map ( Q=>nx78, A=>nx905, B=>nx872, C=>door_open);
   ix906 : AOI221 port map ( Q=>nx905, A=>time_set, B=>CS_3, C=>nx910, D=>
      CS_4);
   reg_CS_3 : DFC1 port map ( Q=>CS_3, QN=>nx875, C=>clk, D=>nx50, RN=>nx908
   );
   ix909 : CLKIN1 port map ( Q=>nx908, A=>reset);
   ix911 : CLKIN1 port map ( Q=>nx910, A=>start);
   ix914 : CLKIN1 port map ( Q=>nx913, A=>timeout);
   ix139 : OAI311 port map ( Q=>nx138, A=>nx2, B=>half_power, C=>nx919, D=>
      nx921);
   reg_CS_1 : DFC1 port map ( Q=>full_EXMPLR, QN=>nx919, C=>clk, D=>nx138, 
      RN=>nx908);
   ix922 : OAI211 port map ( Q=>nx921, A=>CS_0, B=>half_EXMPLR, C=>
      full_power);
   reg_CS_2 : DFC1 port map ( Q=>half_EXMPLR, QN=>nx884, C=>clk, D=>nx128, 
      RN=>nx908);
   ix925 : NOR21 port map ( Q=>nx924, A=>CS_5, B=>start_count_EXMPLR);
   reg_CS_5 : DFC1 port map ( Q=>CS_5, QN=>nx872, C=>clk, D=>nx60, RN=>nx908
   );
   ix928 : CLKIN1 port map ( Q=>nx927, A=>door_open);
   reg_stop_count : DFC1 port map ( Q=>stop_count, QN=>OPEN, C=>clk, D=>
      nx144, RN=>nx908);
   ix145 : NOR21 port map ( Q=>nx144, A=>nx915, B=>nx927);
   ix29 : CLKIN1 port map ( Q=>in_light, A=>nx924);
end ctrl_oven_arc ;

