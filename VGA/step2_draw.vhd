library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.consts_pck.all;

-- Alex Grinshpun July 24 2017 


entity step2_draw is
port 	(
		--////////////////////	Clock Input	 	////////////////////	
	   CLK  : in std_logic;
		RESETn	: in std_logic;
		oCoord_X 		: in integer range 0 to 700;
		oCoord_Y 		: in integer range 0 to 700;
		step_hight		: in integer;
		step_length		:in integer;
		in_x: in integer;
		in_y : in integer;
		drawing_request: out std_logic;
		mVGA_RGB	      : out std_logic_vector(7 downto 0) ;--	,   						//	VGA Red[9:0]
		obstacle_hight	: out integer
		


	);
end step2_draw;

architecture behav of step2_draw is 



signal mVGA_R	: std_logic_vector(2 downto 0); --	,	 						//	VGA Red[9:0]
signal mVGA_G	: std_logic_vector(2 downto 0); --	,	 						//	VGA Green[9:0]
signal mVGA_B	:  std_logic_vector(1 downto 0); --	,  						//	VGA Blue[9:0]
--constant mario_location: integer:=450;
constant mario_size: integer:=26;
	
begin

mVGA_RGB <=  mVGA_R & mVGA_G &  mVGA_B ;
obstacle_hight<=in_y;
process(CLK)
begin
	if (oCoord_X>in_x and oCoord_x<in_x+100) then
	--	if oCoord_y<in_y then 	--sky
		--	mVGA_R<="000";
--			mVGA_G<="001";
	--		mVGA_B<="11";
		--else 
			--if oCoord_y<in_y+20 then
				--mVGA_R<="000";
--				mVGA_G<="001";
	--			mVGA_B<="11";
		--	else
			--	if oCoord_y< 476 then
				--	mVGA_R<="000";
					--mVGA_G<="001";
					--mVGA_B<="11";
--				else
	--				mVGA_R<="000";
		--			mVGA_G<="001";
			--		mVGA_B<="11";
				--end if;
			--end if;
		--end if;
		mVGA_R<="000";
		mVGA_G<="001";
		mVGA_B<="11";
		drawing_request<='1';
	else
		drawing_request<='0';
	end if;
end process;

--mVGA_R <= "111" when 
	--				(oCoord_Y > mario_location+mario_size) 
		--			
			--	else
--			 "000" ;	
--mVGA_G <= "111" when (oCoord_Y >  in_y and oCoord_Y<(in_y+step_hight) and oCoord_X>in_x and oCoord_X<(in_x+step_length)) else
 --		    "000" ;	
--mVGA_B <= "11" when (oCoord_Y <  mario_location+mario_size) else
	--		 "00";	 
--drawing_request <= '1' when (oCoord_Y >  in_y and oCoord_Y<(in_y+step_hight) and oCoord_X>in_x and oCoord_X<(in_x+step_length)) else
	--					'0';



		
end behav;		