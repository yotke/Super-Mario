library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use IEEE.std_logic_unsigned.all;
--use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
-- Alex Grinshpun April 2017

entity life_object1 is
port 	(
		--////////////////////	Clock Input	 	////////////////////	
	   	CLK  		: in std_logic;
		RESETn		: in std_logic;
		oCoord_X	: in integer range 0 to 700;
		oCoord_Y	: in integer range 0 to 700;
		ObjectStartX	: in integer;
		ObjectStartY 	: in integer;
		counter			: in integer range 0 to 5;
		drawing_request	: out std_logic ;
		mVGA_RGB 	: out std_logic_vector(7 downto 0) ;
		keepflag    : out std_logic
	);
end life_object1;

architecture behav of life_object1 is 

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
(x"00", x"00", x"00", x"00", x"24", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"60", x"A0", x"A0", x"A0", x"80", x"20", x"00", x"00", x"00", x"00", x"00", x"80", x"A0", x"A0", x"80", x"60", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"20", x"80", x"E0", x"E4", x"E4", x"E0", x"40", x"20", x"00", x"00", x"20", x"20", x"C0", x"E0", x"E0", x"E0", x"C0", x"20", x"20", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"20", x"C0", x"E4", x"E9", x"F6", x"F2", x"E9", x"E0", x"80", x"00", x"00", x"40", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"40", x"00", x"00", x"00"),
(x"00", x"00", x"60", x"A0", x"E4", x"ED", x"F2", x"E9", x"E4", x"E0", x"E0", x"C0", x"80", x"80", x"A0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"80", x"60", x"00", x"00"),
(x"00", x"00", x"80", x"E0", x"E9", x"F2", x"F2", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"A0", x"00", x"00"),
(x"00", x"00", x"80", x"E4", x"F6", x"ED", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"80", x"00", x"00"),
(x"00", x"00", x"80", x"E0", x"ED", x"E4", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"80", x"00", x"00"),
(x"00", x"00", x"80", x"E0", x"E4", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"80", x"00", x"00"),
(x"00", x"00", x"80", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"A0", x"00", x"00"),
(x"00", x"00", x"40", x"80", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"80", x"40", x"00", x"00"),
(x"00", x"00", x"00", x"20", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"A0", x"40", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"20", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"C0", x"40", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"20", x"80", x"C0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"A0", x"60", x"20", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"60", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"C0", x"80", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"20", x"40", x"C0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"C0", x"40", x"20", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"80", x"C0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"A0", x"60", x"20", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"60", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"C0", x"80", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"40", x"C0", x"E0", x"E0", x"E0", x"C0", x"C0", x"40", x"20", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"80", x"C0", x"E0", x"C0", x"A0", x"80", x"20", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"40", x"C0", x"C0", x"60", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"40", x"40", x"20", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00")
);

type object_form is array (0 to object_X_size - 1 , 0 to object_Y_size - 1) of std_logic;
constant object : object_form := (
("00000000000000000000000000"),
("00000000000000000000000000"),
("00001000000000000000000000"),
("00000111111000001111100000"),
("00001111111100111111111000"),
("00011111111100111111111000"),
("00111111111111111111111100"),
("00111111111111111111111100"),
("00111111111111111111111100"),
("00111111111111111111111100"),
("00111111111111111111111100"),
("00111111111111111111111100"),
("00111111111111111111111100"),
("00011111111111111111111000"),
("00011111111111111111111000"),
("00011111111111111111111000"),
("00000111111111111111100000"),
("00000111111111111111100000"),
("00000001111111111111000000"),
("00000000111111111100000000"),
("00000000111111111100000000"),
("00000000001111111000000000"),
("00000000000111100000000000"),
("00000000000111100000000000"),
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
			if counter > 1 then 
				drawing_request <= '0';
			end if;
			ObjectStartX_d <= ObjectStartX;
	end if;

  end process;

	keepflag <= '1' when 	ObjectStartX - ObjectStartX_d > 100 else '0';	
		
end behav;		
		