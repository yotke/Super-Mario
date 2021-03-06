
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 
use ieee.std_logic_arith.all;
  
package CONSTS_PCK is
  constant mario_location: integer:=372;
  constant obstacle_length_y : integer := 33;
  constant mario_hight : integer := 63;
  constant jump_sound_length : integer := 2500000;
  constant obst_sound_length : integer := 2000000;
  constant bomb_sound_length : integer := 2000000;
  constant coin_sound_length : integer := 2000000;
  constant middle : integer:=340;
  constant bomb_range :integer :=30;
  constant mario_sky_limit: integer :=50;
  
end CONSTS_PCK;
