library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use IEEE.std_logic_unsigned.all;
--use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
-- Alex Grinshpun April 2017

entity COINS_object is
port 	(
		--////////////////////	Clock Input	 	////////////////////	
	   	CLK  		: in std_logic;
		RESETn		: in std_logic;
		oCoord_X	: in integer range 0 to 700;
		oCoord_Y	: in integer range 0 to 700;
		ObjectStartX	: in integer;
		ObjectStartY 	: in integer;
		drawing_request	: out std_logic ;
		mVGA_RGB 	: out std_logic_vector(7 downto 0) ;
		keepflag    : out std_logic
	);
end COINS_object;

architecture behav of COINS_object is 

constant object_X_size : integer := 26;
constant object_Y_size : integer := 26;
constant R_high		: integer := 7;
constant R_low		: integer := 5;
constant G_high		: integer := 4;
constant G_low		: integer := 2;
constant B_high		: integer := 1;
constant B_low		: integer := 0;

type ram_array is array(0 to object_X_size - 1 , 0 to object_Y_size - 1) of std_logic_vector(7 downto 0);  

-- 8 bit - color definition : "RRRGGGBB"  
constant object_colors: ram_array := ( 
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"F8", x"D0", x"D4", x"D0", x"D4", x"D8", x"F8", x"F8", x"F8", x"F8", x"F8", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"D0", x"D0", x"D0", x"D0", x"D0", x"D0", x"D4", x"D4", x"F8", x"FD", x"FD", x"FD", x"FD", x"F8", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"D0", x"D0", x"D0", x"D0", x"D0", x"D0", x"D4", x"D4", x"D4", x"D4", x"FD", x"FE", x"FE", x"FE", x"FE", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"D0", x"D0", x"D0", x"D0", x"D4", x"D4", x"D0", x"D4", x"D4", x"D4", x"D8", x"FE", x"FF", x"FE", x"FD", x"FE", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"AC", x"D0", x"D0", x"D0", x"D4", x"D0", x"D0", x"D0", x"D4", x"D4", x"D4", x"D4", x"F9", x"FF", x"FE", x"FE", x"FE", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"D0", x"AC", x"D0", x"D0", x"D0", x"D4", x"D0", x"68", x"8C", x"D4", x"D4", x"D4", x"D8", x"FE", x"FE", x"FD", x"FF", x"F9", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"D0", x"D0", x"D0", x"AC", x"D0", x"F4", x"D0", x"68", x"8C", x"F4", x"F4", x"D4", x"D8", x"F8", x"FD", x"F9", x"F8", x"F8", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"D0", x"D0", x"D0", x"8C", x"D4", x"F4", x"D4", x"68", x"AC", x"F8", x"F8", x"F8", x"F8", x"D4", x"F8", x"F8", x"D4", x"D4", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"D4", x"D4", x"D0", x"8C", x"D4", x"F8", x"D4", x"68", x"AC", x"F8", x"F8", x"F8", x"F8", x"D4", x"D4", x"D4", x"D4", x"D4", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"D4", x"D4", x"D0", x"AC", x"F4", x"F8", x"D4", x"68", x"B0", x"F8", x"F8", x"F8", x"F8", x"D4", x"B0", x"B0", x"B0", x"B0", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"D4", x"D4", x"D4", x"AC", x"F4", x"F8", x"D4", x"68", x"B0", x"F8", x"F8", x"F8", x"F8", x"B0", x"8C", x"8C", x"8C", x"8C", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"D4", x"D4", x"D4", x"B0", x"F8", x"F8", x"D4", x"68", x"B0", x"F8", x"F8", x"F8", x"F8", x"B0", x"68", x"68", x"68", x"68", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"D4", x"D4", x"D8", x"D0", x"F8", x"F8", x"D4", x"68", x"B0", x"F8", x"F8", x"F8", x"F8", x"8C", x"68", x"68", x"48", x"48", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"D4", x"D4", x"F8", x"D4", x"F8", x"F8", x"D4", x"68", x"B0", x"F8", x"F8", x"F8", x"F8", x"6C", x"68", x"48", x"44", x"44", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"D4", x"FD", x"F8", x"F8", x"F8", x"F8", x"D8", x"8C", x"D4", x"F8", x"F8", x"F8", x"D4", x"68", x"68", x"68", x"00", x"44", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"D8", x"D8", x"F8", x"F9", x"F9", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"B0", x"8C", x"8C", x"8C", x"8C", x"24", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"D4", x"88", x"F8", x"F9", x"FD", x"F9", x"F8", x"F8", x"F8", x"F8", x"D4", x"8C", x"8C", x"8C", x"68", x"88", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"D4", x"D4", x"F8", x"F9", x"FD", x"FD", x"F8", x"FC", x"F8", x"B0", x"B0", x"AC", x"8C", x"8C", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"D4", x"B0", x"D4", x"F8", x"F8", x"F8", x"D8", x"B0", x"B0", x"B0", x"B0", x"B0", x"8C", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"8C", x"68", x"B4", x"D4", x"D4", x"B0", x"8C", x"6C", x"6C", x"6C", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00")
);

type object_form is array (0 to object_X_size - 1 , 0 to object_Y_size - 1) of std_logic;
constant object : object_form := (
("00000000000000000000000000"),
("00000000000000000000000000"),
("00000000000000000000000000"),
("00000001111111111100000000"),
("00000011111111111111000000"),
("00000111111111111111000000"),
("00000111111111111111100000"),
("00001111111111111111100000"),
("00001111111111111111110000"),
("00001111111111111111110000"),
("00001111111111111111110000"),
("00001111111111111111110000"),
("00001111111111111111110000"),
("00001111111111111111110000"),
("00001111111111111111110000"),
("00001111111111111111110000"),
("00001111111111111111110000"),
("00001111111111111111010000"),
("00000111111111111111110000"),
("00000111111111111111100000"),
("00000011111111111111000000"),
("00000011111111111111000000"),
("00000000111111111100000000"),
("00000000000000000000000000"),
("00000000000000000000000000"),
("00000000000000000000000000")
);



signal bCoord_X : integer := 0;
signal bCoord_Y : integer := 0;

signal drawing_X : std_logic := '0';
signal drawing_Y : std_logic := '0';

--		
signal objectWestXboundary : integer;
signal objectSouthboundary : integer;
signal objectXboundariesTrue : boolean;
signal objectYboundariesTrue : boolean;
signal ObjectStartX_d : integer;
--signal keepflag : std_logic;
attribute syn_keep: boolean;
attribute syn_keep of keepflag: signal is true;
attribute preserve : boolean;
attribute preserve of keepflag: signal is true;
attribute noprune: boolean;  
attribute noprune of keepflag: signal is true;
begin

-- Calculate object boundaries
objectWestXboundary	<= object_X_size+ObjectStartX;
objectSouthboundary	<= object_Y_size+ObjectStartY;

-- Signals drawing_X[Y] are active when obects coordinates are being crossed

	drawing_X	<= '1' when  (oCoord_X  >= ObjectStartX) and  (oCoord_X < objectWestXboundary) else '0';
    drawing_Y	<= '1' when  (oCoord_Y  >= ObjectStartY) and  (oCoord_Y < objectSouthboundary) else '0';

	bCoord_X 	<= (oCoord_X - ObjectStartX) when ( drawing_X = '1' and  drawing_Y = '1'  ) else 0 ; 
	bCoord_Y 	<= (oCoord_Y - ObjectStartY) when ( drawing_X = '1' and  drawing_Y = '1'  ) else 0 ; 


process ( RESETn, CLK)

  		
   begin
	if RESETn = '0' then
	    mVGA_RGB	<=  (others => '0') ; 	
		drawing_request	<=  '0' ;
		ObjectStartX_d <= 0;

		elsif CLK'event and CLK='1' then
			mVGA_RGB	<=  object_colors(bCoord_Y , bCoord_X);	
			drawing_request	<= object(bCoord_Y , bCoord_X) and drawing_X and drawing_Y ;
			ObjectStartX_d <= ObjectStartX;
	end if;

  end process;

	keepflag <= '1' when 	ObjectStartX - ObjectStartX_d > 100 else '0';	
		
end behav;		
		