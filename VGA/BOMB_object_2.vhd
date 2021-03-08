library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use IEEE.std_logic_unsigned.all;
--use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
-- Alex Grinshpun April 2017

entity BOMB_object_2 is
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
end BOMB_object_2;

architecture behav of BOMB_object_2 is 

constant object_X_size : integer := 30;
constant object_Y_size : integer := 30;
constant R_high		: integer := 7;
constant R_low		: integer := 5;
constant G_high		: integer := 4;
constant G_low		: integer := 2;
constant B_high		: integer := 1;
constant B_low		: integer := 0;

type ram_array is array(0 to object_X_size - 1 , 0 to object_Y_size - 1) of std_logic_vector(7 downto 0);  

-- 8 bit - color definition : "RRRGGGBB"  
constant object_colors: ram_array := ( 
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"24", x"24", x"00", x"00", x"00", x"24", x"49", x"49", x"49", x"40", x"40", x"40", x"40", x"40", x"40", x"49", x"49", x"49", x"24", x"00", x"00", x"00", x"49", x"24", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"24", x"FF", x"FF", x"FF", x"E9", x"E0", x"E0", x"E0", x"E0", x"E9", x"FF", x"FF", x"FF", x"24", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"6D", x"6D", x"6D", x"92", x"FF", x"FB", x"F2", x"E4", x"E0", x"E0", x"E0", x"E0", x"E4", x"F2", x"FB", x"FF", x"92", x"6D", x"6D", x"6D", x"04", x"24", x"24", x"24", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"B6", x"FF", x"FF", x"FF", x"FF", x"F2", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"F2", x"FF", x"FF", x"FF", x"FF", x"B6", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"60", x"A0", x"C4", x"E9", x"E9", x"E9", x"E9", x"E4", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E4", x"E9", x"E9", x"E9", x"E9", x"C4", x"A0", x"60", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"60", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"60", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"60", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"60", x"00", x"00", x"00"),
(x"00", x"24", x"24", x"80", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E4", x"E4", x"E4", x"E4", x"E4", x"E4", x"E4", x"E4", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"80", x"24", x"24", x"00"),
(x"00", x"49", x"FF", x"ED", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"ED", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"ED", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"ED", x"FF", x"49", x"00"),
(x"00", x"49", x"FF", x"F6", x"ED", x"E0", x"E0", x"E0", x"E0", x"E9", x"F6", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"F6", x"E9", x"E0", x"E0", x"E0", x"E0", x"ED", x"F6", x"FF", x"49", x"00"),
(x"00", x"49", x"FF", x"FF", x"FF", x"E9", x"E0", x"E0", x"E4", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"E4", x"E0", x"E0", x"E9", x"FF", x"FF", x"FF", x"49", x"00"),
(x"00", x"49", x"FF", x"FF", x"FF", x"E9", x"E0", x"E0", x"E4", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"E4", x"E0", x"E0", x"E9", x"FF", x"FF", x"FF", x"49", x"00"),
(x"00", x"49", x"FF", x"FF", x"FF", x"E9", x"E0", x"E0", x"E4", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"E4", x"E0", x"E0", x"E9", x"FF", x"FF", x"FF", x"49", x"00"),
(x"00", x"49", x"FF", x"FF", x"FF", x"E9", x"E0", x"E0", x"E4", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"E4", x"E0", x"E0", x"E9", x"FF", x"FF", x"FF", x"49", x"00"),
(x"00", x"49", x"FF", x"FB", x"FB", x"E4", x"E0", x"E0", x"E4", x"F6", x"FB", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FB", x"F6", x"E4", x"E0", x"E0", x"E4", x"FB", x"FB", x"FF", x"49", x"00"),
(x"00", x"49", x"FF", x"F2", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"ED", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"ED", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"F2", x"FF", x"49", x"00"),
(x"00", x"44", x"F2", x"E9", x"E0", x"E0", x"E0", x"A0", x"80", x"80", x"89", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"89", x"80", x"80", x"A0", x"E0", x"E0", x"E0", x"E9", x"F2", x"44", x"00"),
(x"00", x"40", x"E0", x"E0", x"E0", x"E0", x"C0", x"20", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"C0", x"E0", x"E0", x"E0", x"E0", x"40", x"00"),
(x"00", x"20", x"60", x"60", x"60", x"60", x"60", x"88", x"8C", x"8C", x"44", x"00", x"48", x"8C", x"8C", x"8C", x"8C", x"48", x"00", x"44", x"8C", x"8C", x"88", x"60", x"60", x"60", x"60", x"60", x"20", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"D1", x"F5", x"F5", x"8C", x"00", x"8D", x"F5", x"F5", x"F5", x"F5", x"8D", x"00", x"8C", x"F5", x"F5", x"D1", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"68", x"D1", x"F1", x"F5", x"F5", x"8C", x"00", x"8D", x"F5", x"F5", x"F5", x"F5", x"8D", x"00", x"8C", x"F5", x"F5", x"F1", x"D1", x"68", x"00", x"00", x"00", x"00", x"FF"),
(x"00", x"00", x"00", x"00", x"00", x"AD", x"F5", x"F5", x"F5", x"F5", x"8D", x"20", x"AD", x"F5", x"F5", x"F5", x"F5", x"AD", x"20", x"8D", x"F5", x"F5", x"F5", x"F5", x"AD", x"00", x"00", x"00", x"FF", x"FF"),
(x"00", x"00", x"00", x"00", x"00", x"AD", x"F5", x"F5", x"F5", x"F5", x"F1", x"D1", x"F1", x"F5", x"F5", x"F5", x"F5", x"F1", x"D1", x"F1", x"F5", x"F5", x"F5", x"F5", x"AD", x"00", x"00", x"00", x"FF", x"FF"),
(x"00", x"00", x"00", x"00", x"00", x"68", x"AD", x"F1", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F1", x"AD", x"68", x"00", x"00", x"00", x"FF", x"FF"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"D1", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"D1", x"00", x"00", x"00", x"00", x"00", x"FF", x"FF"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"00", x"00", x"00", x"00", x"00", x"24", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00")
);
type object_form is array (0 to object_X_size - 1 , 0 to object_Y_size - 1) of std_logic;
constant object : object_form := (
("000000000000000000000000000000"),
("000110001111111111111100011000"),
("000000001111111111111100000000"),
("000001111111111111111111111110"),
("000001111111111111111111100000"),
("000111111111111111111111111000"),
("000111111111111111111111111000"),
("000111111111111111111111111000"),
("011111111111111111111111111110"),
("011111111111111111111111111110"),
("011111111111111111111111111110"),
("011111111111111111111111111110"),
("011111111111111111111111111110"),
("011111111111111111111111111110"),
("011111111111111111111111111110"),
("011111111111111111111111111110"),
("011111111111111111111111111110"),
("011111111111111111111111111110"),
("011111110000000000000011111110"),
("011111111110111111011111111110"),
("000000011110111111011110000000"),
("000001111110111111011111100001"),
("000001111111111111111111100011"),
("000001111111111111111111100011"),
("000001111111111111111111100011"),
("000000111111111111111110000011"),
("000000011111111111111110000010"),
("000000000000000000000000000000"),
("000000000000000000000000000000"),
("000000000000000000000000000000")
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
		