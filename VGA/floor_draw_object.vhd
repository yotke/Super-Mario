library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use IEEE.std_logic_unsigned.all;
--use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
-- Alex Grinshpun April 2017

entity floor_draw_object is
port 	(
		--////////////////////	Clock Input	 	////////////////////	
	   	CLK  		: in std_logic;
		RESETn		: in std_logic;
		oCoord_X	: in integer range 0 to 700;
		oCoord_Y	: in integer range 0 to 700;
		drawing_request	: out std_logic ;
		mVGA_RGB 	: out std_logic_vector(7 downto 0) ;
		keepflag    : out std_logic
	);
end floor_draw_object;

architecture arch_FloorDraw of floor_draw_object is 

constant object_X_size : integer := 640;
constant object_Y_size : integer := 52;
constant R_high		: integer := 7;
constant R_low		: integer := 5;
constant G_high		: integer := 4;
constant G_low		: integer := 2;
constant B_high		: integer := 1;
constant B_low		: integer := 0;
constant ObjectStartX	: integer := 0;
constant ObjectStartY 	: integer := 428;

type ram_array is array(0 to object_Y_size - 1 , 0 to 30 - 1) of std_logic_vector(7 downto 0);  

-- 8 bit - color definition : "RRRGGGBB"  
constant object_colors: ram_array := ( 

(x"35", x"54", x"54", x"30", x"30", x"50", x"50", x"30", x"50", x"50", x"70", x"50", x"50", x"70", x"50", x"50", x"54", x"30", x"50", x"50", x"50", x"50", x"50", x"50", x"50", x"50", x"50", x"50", x"30", x"34"),
(x"08", x"4C", x"70", x"70", x"99", x"95", x"95", x"95", x"95", x"B5", x"95", x"70", x"70", x"70", x"70", x"99", x"94", x"95", x"95", x"B5", x"B5", x"95", x"95", x"95", x"95", x"B5", x"94", x"94", x"95", x"71"),
(x"00", x"24", x"8D", x"B5", x"FA", x"FA", x"FA", x"FA", x"F9", x"F9", x"FA", x"8D", x"8D", x"8D", x"8D", x"FA", x"FE", x"F9", x"FA", x"FA", x"FA", x"FA", x"FA", x"FA", x"FA", x"FA", x"F9", x"F9", x"FE", x"B6"),
(x"00", x"68", x"FA", x"D2", x"A8", x"AC", x"AC", x"AC", x"AC", x"AC", x"AD", x"20", x"40", x"F6", x"F6", x"AD", x"88", x"AC", x"AC", x"AC", x"CC", x"AC", x"AC", x"AC", x"AC", x"AC", x"CC", x"AC", x"AD", x"69"),
(x"00", x"44", x"FB", x"D2", x"A8", x"CC", x"CC", x"A8", x"AC", x"8C", x"8D", x"00", x"20", x"FA", x"F6", x"88", x"CC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"A8", x"AC", x"AC", x"AD", x"69"),
(x"00", x"68", x"FA", x"D1", x"A8", x"A8", x"AC", x"CC", x"AC", x"AC", x"8C", x"20", x"20", x"FA", x"F6", x"88", x"CC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"8C", x"68"),
(x"00", x"44", x"FA", x"D1", x"AC", x"CC", x"AC", x"CC", x"A8", x"AC", x"8C", x"20", x"40", x"FA", x"F5", x"A8", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"8C", x"6C"),
(x"00", x"44", x"FF", x"AD", x"64", x"A8", x"A8", x"AC", x"AC", x"AC", x"AC", x"20", x"40", x"FA", x"F5", x"AC", x"AC", x"AC", x"AC", x"CC", x"CC", x"CC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"68"),
(x"00", x"44", x"FF", x"8D", x"20", x"68", x"AD", x"AC", x"AC", x"AC", x"AD", x"20", x"20", x"FA", x"F5", x"AC", x"AC", x"AC", x"CC", x"C8", x"C8", x"CC", x"CC", x"AC", x"CC", x"CC", x"CC", x"AC", x"AC", x"68"),
(x"00", x"24", x"B6", x"48", x"00", x"20", x"20", x"00", x"20", x"20", x"00", x"8D", x"69", x"FA", x"D5", x"8C", x"AC", x"AC", x"AC", x"C8", x"C8", x"CC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"69"),
(x"00", x"24", x"B6", x"69", x"44", x"44", x"24", x"44", x"44", x"44", x"44", x"69", x"69", x"FA", x"D5", x"8C", x"8C", x"AC", x"AC", x"AC", x"CC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"68"),
(x"00", x"48", x"FB", x"FB", x"FB", x"FB", x"FA", x"FE", x"FA", x"FF", x"FA", x"20", x"20", x"FA", x"F5", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"8C", x"68"),
(x"00", x"44", x"FA", x"D6", x"AD", x"AD", x"AC", x"CD", x"AC", x"AD", x"AD", x"20", x"40", x"FA", x"F5", x"AC", x"AC", x"AC", x"AC", x"CC", x"CC", x"CC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"68"),
(x"00", x"44", x"FA", x"D1", x"A8", x"C8", x"CC", x"AC", x"AC", x"AC", x"8D", x"20", x"20", x"FA", x"F5", x"A8", x"CC", x"AC", x"AC", x"CC", x"CC", x"CC", x"AC", x"AC", x"AC", x"CC", x"CC", x"AC", x"AC", x"68"),
(x"00", x"44", x"FA", x"D1", x"A8", x"CC", x"CC", x"CC", x"AC", x"8C", x"8D", x"00", x"00", x"FB", x"D1", x"A8", x"CC", x"AC", x"AC", x"AC", x"CC", x"CC", x"AC", x"AC", x"AC", x"CC", x"CC", x"AC", x"AC", x"68"),
(x"00", x"44", x"FA", x"D1", x"A8", x"CC", x"CC", x"CC", x"AC", x"90", x"6C", x"00", x"00", x"FB", x"F6", x"A8", x"CC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"B1", x"69"),
(x"24", x"68", x"FA", x"B1", x"AC", x"CC", x"CC", x"CC", x"AC", x"8C", x"91", x"00", x"00", x"DA", x"B2", x"8C", x"8C", x"AC", x"AC", x"AC", x"CC", x"CC", x"C8", x"C8", x"CC", x"AC", x"AC", x"8C", x"89", x"69"),
(x"FB", x"D5", x"8C", x"8C", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"8C", x"20", x"00", x"00", x"00", x"00", x"20", x"B1", x"8C", x"B0", x"AC", x"AC", x"CC", x"AC", x"AC", x"AC", x"8C", x"88", x"20", x"44"),
(x"FB", x"F5", x"8C", x"AC", x"AC", x"A8", x"D0", x"AC", x"AC", x"AC", x"8C", x"20", x"20", x"B2", x"92", x"B2", x"8D", x"20", x"44", x"40", x"88", x"8C", x"AC", x"B0", x"AC", x"8C", x"B0", x"8C", x"00", x"44"),
(x"F6", x"D0", x"A8", x"AC", x"CC", x"A8", x"CC", x"CC", x"AC", x"AC", x"8C", x"20", x"20", x"FB", x"FB", x"FF", x"8D", x"20", x"20", x"20", x"69", x"8D", x"8C", x"8C", x"6C", x"6C", x"6C", x"68", x"20", x"68"),
(x"88", x"AC", x"AC", x"A8", x"CC", x"CC", x"C8", x"A8", x"AC", x"AC", x"B1", x"00", x"20", x"FB", x"D6", x"68", x"D5", x"FA", x"FA", x"FF", x"44", x"00", x"00", x"20", x"00", x"00", x"00", x"20", x"FF", x"D6"),
(x"AC", x"AC", x"AC", x"CC", x"CC", x"C8", x"CC", x"CC", x"AC", x"8C", x"8D", x"00", x"20", x"D6", x"F6", x"AC", x"AC", x"D4", x"B0", x"D1", x"B1", x"AD", x"AE", x"89", x"8D", x"8E", x"00", x"20", x"FB", x"D1"),
(x"8C", x"AC", x"AC", x"AC", x"AC", x"CC", x"CC", x"AC", x"AC", x"8C", x"8D", x"00", x"20", x"FF", x"D5", x"AC", x"AC", x"AC", x"AC", x"88", x"F5", x"F9", x"FA", x"FA", x"FA", x"FB", x"00", x"20", x"FB", x"D6"),
(x"AC", x"AC", x"D1", x"AC", x"AC", x"CC", x"AC", x"AC", x"AD", x"40", x"20", x"00", x"20", x"FA", x"F6", x"8C", x"AC", x"AC", x"AC", x"D0", x"AC", x"AC", x"8C", x"90", x"90", x"8C", x"00", x"20", x"FA", x"D6"),
(x"44", x"64", x"64", x"44", x"44", x"44", x"44", x"44", x"44", x"20", x"20", x"64", x"64", x"D5", x"B1", x"44", x"68", x"64", x"64", x"64", x"44", x"44", x"44", x"44", x"44", x"44", x"48", x"68", x"FE", x"B6"),
(x"20", x"20", x"20", x"00", x"20", x"00", x"00", x"00", x"20", x"20", x"20", x"AC", x"AC", x"AC", x"8C", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"6C", x"B5", x"FB", x"91"),
(x"00", x"44", x"8D", x"B1", x"DA", x"DA", x"DA", x"FB", x"FB", x"FA", x"F6", x"AC", x"AC", x"88", x"8D", x"FA", x"FA", x"FB", x"FB", x"FB", x"FB", x"FB", x"FA", x"FA", x"FA", x"F6", x"FA", x"FA", x"FB", x"B2"),
(x"00", x"44", x"D6", x"B5", x"B1", x"D5", x"D1", x"D5", x"B1", x"D5", x"D5", x"64", x"68", x"D5", x"D1", x"F5", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"F1", x"F1", x"D1", x"D1", x"F2", x"AD"),
(x"00", x"48", x"FF", x"B1", x"88", x"AC", x"AC", x"AC", x"AC", x"8C", x"6C", x"20", x"00", x"FA", x"F5", x"88", x"88", x"8C", x"8C", x"AC", x"AC", x"AC", x"AC", x"AC", x"A8", x"A8", x"CC", x"A8", x"A8", x"84"),
(x"00", x"28", x"FF", x"D1", x"A8", x"CC", x"C8", x"CC", x"AC", x"AC", x"8C", x"00", x"20", x"FB", x"F5", x"AC", x"CC", x"AC", x"AC", x"AC", x"AC", x"AC", x"CC", x"CC", x"CC", x"AC", x"CC", x"AC", x"AC", x"88"),
(x"00", x"48", x"FA", x"D1", x"A8", x"CC", x"C8", x"CC", x"CC", x"AC", x"8C", x"20", x"20", x"FB", x"D6", x"AC", x"AC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"AC", x"AC", x"AC", x"AC", x"AC", x"B1", x"68"),
(x"20", x"48", x"FA", x"D1", x"A9", x"C8", x"C8", x"CC", x"AC", x"AC", x"8C", x"20", x"20", x"FB", x"F6", x"AC", x"AC", x"CC", x"CC", x"CC", x"CC", x"CC", x"AC", x"AC", x"AC", x"AC", x"8C", x"8C", x"8D", x"68"),
(x"00", x"25", x"FF", x"8D", x"20", x"88", x"AC", x"AC", x"AC", x"AD", x"8D", x"20", x"20", x"FA", x"F6", x"AC", x"AC", x"CC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"68"),
(x"00", x"24", x"DB", x"69", x"20", x"64", x"68", x"68", x"68", x"68", x"69", x"40", x"44", x"FA", x"F5", x"88", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"68"),
(x"00", x"24", x"91", x"44", x"00", x"00", x"20", x"20", x"00", x"00", x"00", x"8D", x"B1", x"FA", x"F5", x"8C", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AD", x"88"),
(x"00", x"48", x"FA", x"D6", x"D6", x"D6", x"D6", x"D6", x"D6", x"D6", x"B6", x"20", x"20", x"FA", x"F5", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"CC", x"AC", x"AC", x"88"),
(x"00", x"44", x"FA", x"F6", x"F6", x"F6", x"F6", x"F6", x"D6", x"FA", x"D6", x"20", x"20", x"FA", x"D1", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"CC", x"CC", x"CC", x"AC", x"AC", x"88"),
(x"00", x"64", x"FB", x"D1", x"88", x"A8", x"A8", x"A8", x"8C", x"8C", x"68", x"20", x"20", x"FA", x"F6", x"A8", x"CC", x"AC", x"AC", x"AC", x"AC", x"AC", x"CC", x"CC", x"CC", x"CC", x"CC", x"AC", x"AC", x"88"),
(x"20", x"64", x"FB", x"D1", x"A8", x"CC", x"CC", x"CC", x"AC", x"AC", x"AD", x"20", x"40", x"FA", x"F2", x"A8", x"AC", x"AC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"AC", x"A8", x"AC", x"68"),
(x"20", x"64", x"FA", x"D1", x"A8", x"CC", x"AC", x"AC", x"AC", x"AC", x"8C", x"20", x"20", x"F7", x"D6", x"88", x"AC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"AC", x"AC", x"8C", x"AD", x"68"),
(x"20", x"44", x"FA", x"D1", x"AC", x"AC", x"AC", x"AC", x"AC", x"8C", x"8D", x"20", x"20", x"FB", x"FA", x"91", x"8C", x"AC", x"AC", x"CC", x"AC", x"CC", x"AC", x"CC", x"AC", x"AC", x"AC", x"8C", x"B1", x"6D"),
(x"B1", x"91", x"B1", x"B0", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AD", x"00", x"20", x"44", x"24", x"00", x"48", x"B0", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"AC", x"8C", x"8C", x"20", x"44"),
(x"FF", x"D9", x"8C", x"8C", x"AC", x"AC", x"CC", x"CC", x"AC", x"AC", x"8C", x"20", x"00", x"20", x"00", x"24", x"44", x"8C", x"8C", x"88", x"8C", x"8C", x"AC", x"AC", x"AC", x"8C", x"AC", x"88", x"20", x"64"),
(x"FA", x"D5", x"8C", x"AC", x"AC", x"CC", x"CC", x"CC", x"CC", x"AC", x"AC", x"20", x"20", x"FB", x"FB", x"FF", x"AD", x"00", x"20", x"20", x"68", x"AD", x"AD", x"B1", x"AC", x"B1", x"AD", x"8C", x"20", x"44"),
(x"B1", x"AC", x"AC", x"AC", x"A8", x"CC", x"CC", x"CC", x"CC", x"AC", x"AC", x"20", x"20", x"FB", x"D6", x"AD", x"D2", x"B2", x"B2", x"B2", x"65", x"40", x"40", x"20", x"44", x"44", x"20", x"64", x"B1", x"AD"),
(x"8C", x"AC", x"AC", x"AC", x"CC", x"CC", x"A8", x"CC", x"AC", x"AC", x"8C", x"20", x"20", x"FB", x"F6", x"88", x"D1", x"FA", x"FA", x"FB", x"68", x"20", x"40", x"20", x"20", x"20", x"00", x"44", x"FB", x"F6"),
(x"88", x"AC", x"AC", x"AC", x"CC", x"CC", x"AC", x"AC", x"AC", x"8C", x"B1", x"00", x"20", x"FF", x"D1", x"AC", x"AC", x"8C", x"8C", x"88", x"F5", x"FA", x"F6", x"FF", x"FA", x"FB", x"20", x"20", x"FA", x"D5"),
(x"AC", x"AC", x"CC", x"AC", x"AC", x"AC", x"AC", x"8C", x"B1", x"68", x"24", x"00", x"00", x"FA", x"FA", x"8C", x"AC", x"AC", x"AC", x"AC", x"D0", x"D1", x"D1", x"B1", x"B1", x"B2", x"00", x"20", x"FB", x"D5"),
(x"6C", x"8D", x"8D", x"8D", x"8D", x"8D", x"6D", x"8D", x"8D", x"20", x"00", x"20", x"20", x"FA", x"DA", x"68", x"8D", x"8C", x"8C", x"8C", x"8D", x"6D", x"6C", x"8C", x"8C", x"8C", x"20", x"44", x"FA", x"D6"),
(x"00", x"20", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"8D", x"8D", x"B1", x"68", x"00", x"20", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"8D", x"B1", x"FF", x"B6"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"00", x"44", x"44", x"44", x"24", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"68", x"68", x"69", x"48"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00")
);

type object_form is array (0 to object_Y_size - 1 , 0 to 30 - 1) of std_logic;
constant object : object_form := (


("111111111111111111111111111111"),
("111111111111111111111111111111"),
("011111111111111111111111111111"),
("011111111111111111111111111111"),
("011111111110111111111111111111"),
("011111111111111111111111111111"),
("011111111111111111111111111111"),
("011111111111111111111111111111"),
("011111111111111111111111111111"),
("011101101101111111111111111111"),
("011111111111111111111111111111"),
("011111111111111111111111111111"),
("011111111111111111111111111111"),
("011111111111111111111111111111"),
("011111111110011111111111111111"),
("011111111110011111111111111111"),
("111111111110011111111111111111"),
("111111111111000011111111111111"),
("111111111111111111111111111101"),
("111111111111111111111111111111"),
("111111111110111111111001000111"),
("111111111110111111111111110111"),
("111111111110111111111111110111"),
("111111111110111111111111110111"),
("111111111111111111111111111111"),
("111010001111111000000000011111"),
("011111111111111111111111111111"),
("011111111111111111111111111111"),
("011111111111011111111111111111"),
("011111111110111111111111111111"),
("011111111111111111111111111111"),
("111111111111111111111111111111"),
("011111111111111111111111111111"),
("011111111111111111111111111111"),
("011100110001111111111111111111"),
("011111111111111111111111111111"),
("011111111111111111111111111111"),
("011111111111111111111111111111"),
("111111111111111111111111111111"),
("111111111111111111111111111111"),
("111111111111111111111111111111"),
("111111111110111011111111111111"),
("111111111111010111111111111111"),
("111111111111111110111111111111"),
("111111111111111111111111111111"),
("111111111111111111111111110111"),
("111111111110111111111111111111"),
("111111111110011111111111110111"),
("111111111101111111111111111111"),
("010000000011111010000000011111"),
("000000000101111000000000001111"),
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
			mVGA_RGB	<=  object_colors(bCoord_Y mod 52 , bCoord_X mod 30);	
			drawing_request	<= object(bCoord_Y mod 52, bCoord_X mod 30) and drawing_X and drawing_Y ;
			ObjectStartX_d <= ObjectStartX;
	end if;

  end process;

	keepflag <= '1' when 	ObjectStartX - ObjectStartX_d > 100 else '0';	
		
end arch_FloorDraw;		


