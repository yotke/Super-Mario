library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.consts_pck.all;

-- Alex Grinshpun July 24 2017 


entity back_ground_draw is
port 	(
		--////////////////////	Clock Input	 	////////////////////	
	   CLK  : in std_logic;
		RESETn	: in std_logic;
		oCoord_X 		: in integer range 0 to 700;
		oCoord_Y 		: in integer range 0 to 700;
		in_x: in integer;
		in_y : in integer;
		mVGA_RGB	      : out std_logic_vector(7 downto 0) --	,   						//	VGA Red[9:0]


	);
end back_ground_draw;

architecture behav of back_ground_draw is 



signal mVGA_R	: std_logic_vector(2 downto 0); --	,	 						//	VGA Red[9:0]
signal mVGA_G	: std_logic_vector(2 downto 0); --	,	 						//	VGA Green[9:0]
signal mVGA_B	:  std_logic_vector(1 downto 0); --	,  						//	VGA Blue[9:0]
constant mario_location: integer := mario_location;
constant mario_size: integer:=mario_hight;
	
begin

mVGA_RGB <=  mVGA_R & mVGA_G &  mVGA_B ;

mVGA_R <= "000" ;--when (oCoord_Y > mario_location+mario_size) else	--sky
			-- "000" ;	
mVGA_G <= "101";-- when (oCoord_X <  356+in_x) else	--sky
 		    --"000" ;	
mVGA_B <= "11" ;--when (oCoord_Y <  mario_location+mario_size) else	--sky
			 --"00";	 




		
end behav;		