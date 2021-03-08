library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.consts_pck.all;
--use IEEE.std_logic_unsigned.all;
--use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
-- Alex Grinshpun April 2017

entity stepQ is
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
end stepQ;

architecture behav of stepQ is 

constant object_X_size : integer := 35;
constant object_Y_size : integer := obstacle_length_y ;
constant R_high		: integer := 7;
constant R_low		: integer := 5;
constant G_high		: integer := 4;
constant G_low		: integer := 2;
constant B_high		: integer := 1;
constant B_low		: integer := 0;

type ram_array is array(0 to object_Y_size - 1 , 0 to object_x_size - 1) of std_logic_vector(7 downto 0);  

-- 8 bit - color definition : "RRRGGGBB"  
constant object_colors: ram_array := ( 

(x"FF", x"FF", x"ED", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"ED", x"FF", x"FF"),
(x"FF", x"FF", x"CD", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CD", x"FB", x"FF"),
(x"EC", x"CC", x"A4", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"60", x"24", x"24"),
(x"C8", x"C8", x"80", x"80", x"80", x"60", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"60", x"80", x"80", x"60", x"00", x"00"),
(x"C8", x"C8", x"80", x"80", x"40", x"00", x"40", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"40", x"00", x"40", x"80", x"60", x"00", x"00"),
(x"C8", x"C8", x"80", x"80", x"20", x"00", x"40", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"40", x"00", x"20", x"80", x"60", x"00", x"00"),
(x"C8", x"C8", x"80", x"80", x"60", x"60", x"60", x"80", x"80", x"80", x"80", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"A4", x"80", x"80", x"80", x"80", x"80", x"80", x"60", x"60", x"60", x"80", x"60", x"00", x"00"),
(x"C8", x"C8", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"60", x"00", x"00"),
(x"C8", x"C8", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"C4", x"C8", x"C8", x"C8", x"64", x"40", x"40", x"40", x"40", x"40", x"64", x"C8", x"C8", x"C8", x"A4", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"60", x"00", x"00"),
(x"C8", x"C8", x"80", x"80", x"80", x"80", x"80", x"80", x"84", x"C8", x"C8", x"C8", x"C8", x"20", x"00", x"00", x"00", x"00", x"00", x"40", x"C8", x"C8", x"C8", x"C8", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"60", x"00", x"00"),
(x"C8", x"C8", x"80", x"80", x"80", x"80", x"80", x"80", x"84", x"C8", x"C8", x"C8", x"C8", x"20", x"00", x"20", x"40", x"40", x"40", x"84", x"C8", x"C8", x"C8", x"C8", x"40", x"20", x"60", x"80", x"80", x"80", x"80", x"80", x"60", x"00", x"00"),
(x"C8", x"C8", x"80", x"80", x"80", x"80", x"80", x"80", x"84", x"C8", x"C8", x"C8", x"C8", x"20", x"00", x"40", x"80", x"80", x"80", x"A4", x"C8", x"C8", x"C8", x"C8", x"20", x"00", x"60", x"80", x"80", x"80", x"80", x"80", x"60", x"00", x"00"),
(x"C8", x"C8", x"80", x"80", x"80", x"80", x"80", x"80", x"84", x"C8", x"C8", x"C8", x"C8", x"20", x"00", x"40", x"80", x"80", x"80", x"A4", x"C8", x"C8", x"C8", x"C8", x"20", x"00", x"60", x"80", x"80", x"80", x"80", x"80", x"60", x"00", x"00"),
(x"C8", x"C8", x"80", x"80", x"80", x"80", x"80", x"80", x"84", x"C8", x"C8", x"E8", x"C8", x"20", x"00", x"40", x"80", x"80", x"80", x"A4", x"C8", x"C8", x"C8", x"C8", x"20", x"00", x"60", x"80", x"80", x"80", x"80", x"80", x"60", x"00", x"00"),
(x"C8", x"C8", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"A4", x"A4", x"64", x"64", x"00", x"00", x"40", x"80", x"84", x"A4", x"C8", x"C8", x"C8", x"C8", x"C8", x"20", x"00", x"60", x"80", x"80", x"80", x"80", x"80", x"60", x"00", x"00"),
(x"C8", x"C8", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"60", x"00", x"00", x"00", x"00", x"40", x"80", x"A4", x"E8", x"C8", x"E8", x"E8", x"E8", x"C8", x"20", x"00", x"60", x"80", x"80", x"80", x"80", x"80", x"60", x"00", x"00"),
(x"C8", x"C8", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"60", x"40", x"40", x"40", x"40", x"84", x"A4", x"C8", x"E8", x"A8", x"64", x"64", x"64", x"64", x"00", x"00", x"60", x"80", x"80", x"80", x"80", x"80", x"60", x"00", x"00"),
(x"C8", x"C8", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"C4", x"E8", x"C8", x"E8", x"84", x"00", x"00", x"00", x"00", x"00", x"00", x"60", x"80", x"80", x"80", x"80", x"80", x"60", x"00", x"00"),
(x"C8", x"C8", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"C4", x"C8", x"C8", x"E8", x"84", x"00", x"00", x"20", x"20", x"20", x"40", x"60", x"80", x"80", x"80", x"80", x"80", x"60", x"00", x"00"),
(x"C8", x"C8", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"C4", x"E8", x"E8", x"E8", x"84", x"00", x"00", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"60", x"00", x"00"),
(x"C8", x"C8", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"A4", x"A4", x"A4", x"84", x"44", x"00", x"00", x"60", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"60", x"00", x"00"),
(x"C8", x"C8", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"40", x"00", x"00", x"00", x"00", x"60", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"60", x"00", x"00"),
(x"C8", x"C8", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"A4", x"64", x"40", x"40", x"20", x"40", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"60", x"00", x"00"),
(x"C8", x"C8", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"C4", x"C8", x"C8", x"C8", x"C4", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"60", x"00", x"00"),
(x"C8", x"C8", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"C4", x"C8", x"C8", x"C8", x"A4", x"60", x"60", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"60", x"00", x"00"),
(x"C8", x"C8", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"C4", x"E8", x"C8", x"E8", x"84", x"00", x"00", x"60", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"60", x"00", x"00"),
(x"C8", x"C8", x"80", x"80", x"60", x"60", x"60", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"A4", x"C8", x"A8", x"A8", x"64", x"00", x"00", x"60", x"80", x"80", x"80", x"80", x"80", x"60", x"60", x"60", x"80", x"60", x"00", x"00"),
(x"C8", x"C8", x"80", x"80", x"20", x"00", x"40", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"40", x"00", x"00", x"00", x"00", x"60", x"80", x"80", x"80", x"80", x"80", x"40", x"00", x"20", x"80", x"60", x"00", x"00"),
(x"C8", x"C8", x"80", x"80", x"40", x"00", x"40", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"40", x"00", x"00", x"00", x"20", x"80", x"80", x"80", x"80", x"80", x"80", x"40", x"00", x"40", x"80", x"60", x"00", x"00"),
(x"C8", x"C8", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"60", x"00", x"00"),
(x"A8", x"A8", x"80", x"60", x"60", x"60", x"60", x"60", x"60", x"60", x"60", x"60", x"60", x"60", x"60", x"60", x"60", x"60", x"60", x"60", x"60", x"60", x"60", x"60", x"60", x"60", x"60", x"60", x"60", x"60", x"60", x"60", x"40", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00")
);

type object_form is array (0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic;
constant object : object_form := (
("11111111111111111111111111111111111"),
("11111111111111111111111111111111111"),
("11111111111111111111111111111111111"),
("11111111111111111111111111111111100"),
("11111011111111111111111111111011100"),
("11111011111111111111111111111011100"),
("11111111111111111111111111111111100"),
("11111111111111111111111111111111100"),
("11111111111111111111111111111111100"),
("11111111111111000001111111111111100"),
("11111111111111011111111111111111100"),
("11111111111111011111111110111111100"),
("11111111111111011111111110111111100"),
("11111111111111011111111110111111100"),
("11111111111110011111111110111111100"),
("11111111111000011111111110111111100"),
("11111111111111111111111100111111100"),
("11111111111111111111000000111111100"),
("11111111111111111111001111111111100"),
("11111111111111111111001111111111100"),
("11111111111111111111001111111111100"),
("11111111111111111100001111111111100"),
("11111111111111111111111111111111100"),
("11111111111111111111111111111111100"),
("11111111111111111111111111111111100"),
("11111111111111111111001111111111100"),
("11111111111111111111001111111111100"),
("11111011111111111100001111111011100"),
("11111011111111111100011111111011100"),
("11111111111111111111111111111111100"),
("11111111111111111111111111111111100"),
("00000000000000000000000000000000000"),
("00000000000000000000000000000000000")
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
-- Calculate object boundaries
objectWestXboundary	<= object_X_size+ObjectStartX+33;
objectSouthboundary	<= object_Y_size+ObjectStartY;

-- Signals drawing_X[Y] are active when obects coordinates are being crossed

	drawing_X	<= '1' when  (oCoord_X  >= ObjectStartX+33) and  (oCoord_X < objectWestXboundary) else '0';
    drawing_Y	<= '1' when  (oCoord_Y  >= ObjectStartY) and  (oCoord_Y < objectSouthboundary) else '0';

	bCoord_X 	<= (oCoord_X - ObjectStartX+33) when ( drawing_X = '1' and  drawing_Y = '1'  ) else 0 ; 
	bCoord_Y 	<= (oCoord_Y - ObjectStartY) when ( drawing_X = '1' and  drawing_Y = '1'  ) else 0 ; 


process ( RESETn, CLK)

  		
   begin
	if RESETn = '0' then
	    mVGA_RGB	<=  (others => '0') ; 	
		drawing_request	<= '0' ;
		ObjectStartX_d <= 0;

		elsif CLK'event and CLK='1' then
			mVGA_RGB	<=  object_colors(bCoord_Y , bCoord_X);	
			drawing_request	<= object(bCoord_Y , bCoord_X) and drawing_X and drawing_Y ;
			ObjectStartX_d <= ObjectStartX+33;
	end if;

  end process;

	keepflag <= '1' when 	ObjectStartX+33 - ObjectStartX_d > 100 else '0';	
		
end behav;		
		
		
