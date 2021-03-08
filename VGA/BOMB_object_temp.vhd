library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use IEEE.std_logic_unsigned.all;
--use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
-- Alex Grinshpun April 2017

entity BOMB_object_temp is
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
end BOMB_object_temp;

architecture behav of BOMB_object_temp is 

constant object_X_size : integer := 50;
constant object_Y_size : integer := 50;
constant R_high		: integer := 7;
constant R_low		: integer := 5;
constant G_high		: integer := 4;
constant G_low		: integer := 2;
constant B_high		: integer := 1;
constant B_low		: integer := 0;

type ram_array is array(0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic_vector(7 downto 0);  

-- 8 bit - color definition : "RRRGGGBB"  
constant object_colors: ram_array := ( 
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"C0", x"C0", x"C0", x"C0", x"A0", x"60", x"60", x"60", x"60", x"60", x"60", x"A0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"E0", x"C0", x"C0", x"C0", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"C0", x"C0", x"C0", x"C0", x"80", x"00", x"00", x"00", x"00", x"00", x"00", x"80", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"A0", x"00", x"00", x"00", x"00", x"00", x"00", x"60", x"C0", x"C0", x"C0", x"C0", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"C0", x"C0", x"C0", x"C0", x"80", x"00", x"00", x"00", x"00", x"00", x"00", x"80", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"A0", x"00", x"00", x"00", x"00", x"00", x"00", x"60", x"C0", x"C0", x"C0", x"C0", x"00", x"00", x"00", x"00"),
(x"00", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"80", x"00", x"00", x"00", x"00", x"00", x"00", x"80", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"A0", x"40", x"40", x"40", x"40", x"40", x"40", x"80", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"00"),
(x"00", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"A0", x"A0", x"A0", x"D6", x"DA", x"DA", x"49", x"00", x"00", x"60", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"80", x"20", x"20", x"69", x"FA", x"FA", x"F6", x"C4", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"00"),
(x"00", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C4", x"F6", x"FF", x"FF", x"49", x"00", x"00", x"60", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"80", x"00", x"00", x"49", x"FF", x"FF", x"FB", x"C4", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"00"),
(x"00", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C4", x"F6", x"FF", x"FF", x"49", x"00", x"00", x"40", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"80", x"00", x"00", x"49", x"FF", x"FF", x"FB", x"C4", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"00"),
(x"00", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C4", x"F6", x"FF", x"FF", x"49", x"00", x"00", x"00", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"00", x"00", x"49", x"FF", x"FF", x"FB", x"C4", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"00"),
(x"00", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C4", x"F6", x"FF", x"FF", x"49", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"49", x"FF", x"FF", x"FB", x"C4", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"00"),
(x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C4", x"F6", x"FF", x"FF", x"49", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"49", x"FF", x"FF", x"FB", x"C4", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0"),
(x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C4", x"F6", x"FF", x"FF", x"49", x"00", x"00", x"49", x"B2", x"92", x"91", x"84", x"80", x"80", x"80", x"80", x"80", x"89", x"92", x"B2", x"69", x"00", x"00", x"49", x"FF", x"FF", x"FB", x"C4", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0"),
(x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C4", x"F6", x"FF", x"FF", x"49", x"00", x"00", x"6D", x"FF", x"FF", x"FB", x"C4", x"C0", x"C0", x"C0", x"C0", x"C0", x"F2", x"FF", x"FF", x"B2", x"00", x"00", x"49", x"FF", x"FF", x"FB", x"C4", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0"),
(x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C4", x"F6", x"FF", x"FF", x"49", x"00", x"00", x"6D", x"FF", x"FF", x"FB", x"C4", x"C0", x"C0", x"C0", x"C0", x"C0", x"F1", x"FF", x"FF", x"B2", x"00", x"00", x"49", x"FF", x"FF", x"FB", x"C4", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0"),
(x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C4", x"F6", x"FF", x"FF", x"B2", x"6D", x"6D", x"B6", x"FF", x"FF", x"FB", x"C4", x"C0", x"C0", x"C0", x"C0", x"C0", x"F1", x"FF", x"FF", x"DA", x"B2", x"B1", x"D6", x"FF", x"FF", x"FB", x"C4", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0"),
(x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C4", x"F6", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FB", x"C4", x"C0", x"C0", x"C0", x"C0", x"C0", x"F1", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FB", x"C4", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0"),
(x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C4", x"F6", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FB", x"C4", x"C0", x"C0", x"C0", x"C0", x"C0", x"F2", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FB", x"C4", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0"),
(x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C4", x"F2", x"FA", x"FA", x"FA", x"FA", x"FA", x"FA", x"FA", x"FA", x"F6", x"C4", x"C0", x"C0", x"C0", x"C0", x"C0", x"ED", x"F6", x"F6", x"F6", x"F6", x"F6", x"F6", x"F6", x"F6", x"F2", x"C4", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0"),
(x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C4", x"C4", x"C4", x"C4", x"C4", x"C4", x"C4", x"C4", x"C4", x"C4", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0"),
(x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0"),
(x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C4", x"C4", x"C4", x"C4", x"C4", x"C4", x"C4", x"C4", x"C4", x"C4", x"C4", x"C4", x"C4", x"C4", x"C4", x"C4", x"C4", x"C4", x"C4", x"C4", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0"),
(x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C9", x"FB", x"FB", x"FB", x"FB", x"FB", x"FB", x"FB", x"FB", x"FB", x"FB", x"FB", x"FB", x"FB", x"FB", x"FB", x"FB", x"FB", x"FB", x"F2", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0"),
(x"00", x"00", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C9", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"F2", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"00"),
(x"00", x"00", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C4", x"C4", x"C4", x"C4", x"C4", x"C4", x"ED", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"F6", x"C4", x"C4", x"C4", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"00"),
(x"00", x"00", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"F6", x"FA", x"FA", x"FA", x"FA", x"FA", x"FB", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"F2", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FB", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FB", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"6D", x"92", x"92", x"92", x"92", x"92", x"B2", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FB", x"DA", x"DA", x"DA", x"DA", x"DA", x"B6", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"FB", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B6", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"DB", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B6", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"B6", x"DA", x"DA", x"FB", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FB", x"DB", x"92", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"D6", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B2", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"D6", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"92", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"B6", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"92", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"24", x"49", x"48", x"6D", x"FF", x"FF", x"FF", x"FF", x"FF", x"49", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00")
);
type object_form is array (0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic;
constant object : object_form := (
("00000000000000000111111111111111110000000000000000"),
("00000000000000000111111111111111110000000000000000"),
("00000000000001111111111111111111111110000000000000"),
("00000000000001111111111111111111111110000000000000"),
("00000000000001111111111111111111111110000000000000"),
("00000000001111111111111111111111111110000000000000"),
("00000000001111111111111111111111111111110000000000"),
("00000000001111111111111111111111111111110000000000"),
("00000001111111111111111111111111111111110000000000"),
("00000001111111111111111111111111111111111110000000"),
("00000001111111111111111111111111111111111110000000"),
("00001111111111111111111111111111111111111110000000"),
("00001111111111111111111111111111111111111111110000"),
("00001111100000011111111111111111111000000111110000"),
("00001111100000011111111111111111111000000111110000"),
("01111111100000011111111111111111111111111111111110"),
("01111111111111110011111111111111111111111111111110"),
("01111111111111110011111111111111001111111111111110"),
("01111111111111110011111111111111001111111111111110"),
("01111111111111110001111111111111001111111111111110"),
("01111111111111110000000000000000001111111111111110"),
("11111111111111110000000000000000001111111111111111"),
("11111111111111110011111111111111001111111111111111"),
("11111111111111110011111111111111001111111111111111"),
("11111111111111110011111111111111001111111111111111"),
("11111111111111111111111111111111111111111111111111"),
("11111111111111111111111111111111111111111111111111"),
("11111111111111111111111111111111111111111111111111"),
("11111111111111111111111111111111111111111111111111"),
("11111111111111111111111111111111111111111111111111"),
("11111111111111111111111111111111111111111111111111"),
("11111111111111111111111111111111111111111111111111"),
("11111111111111111111111111111111111111111111111111"),
("00111111111111111111111111111111111111111111111110"),
("00111111111111111111111111111111111111111111111110"),
("00111111111111111111111111111111111111111111111110"),
("00000001111111111111111111111111111111110000000000"),
("00000001111111111111111111111111111111000000000000"),
("00000001111111111111111111111111111111000000000000"),
("00000001111111111111111111111111111111000000000000"),
("00000000011111111111111111111111111111000000000000"),
("00000000000000001111111111111111000000000000000000"),
("00000000000000001111111111111111000000000000000000"),
("00000000000000001111111111111111000000000000000000"),
("00000000000000000001111111111000000000000000000000"),
("00000000000000000001111111111000000000000000000000"),
("00000000000000000001111111111000000000000000000000"),
("00000000000000000001111111111000000000000000000000"),
("00000000000000000000000000000000000000000000000000"),
("00000000000000000000000000000000000000000000000000")
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
		