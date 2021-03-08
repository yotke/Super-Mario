library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.consts_pck.all;
--use IEEE.std_logic_unsigned.all;
--use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
-- Alex Grinshpun April 2017

entity step2Envelop is
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
end step2Envelop;

architecture behav of step2Envelop is 

constant object_X_size : integer := 100;
constant object_Y_size : integer := obstacle_length_y ;
constant R_high		: integer := 7;
constant R_low		: integer := 5;
constant G_high		: integer := 4;
constant G_low		: integer := 2;
constant B_high		: integer := 1;
constant B_low		: integer := 0;

type ram_array is array(0 to object_Y_size - 1 , 0 to 100 - 1) of std_logic_vector(7 downto 0);  

-- 8 bit - color definition : "RRRGGGBB"  
constant object_colors: ram_array := ( 

(x"B1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D6", x"DA", x"B1", x"AD", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D5", x"DA", x"F8", x"FC", x"FC", x"FC", x"F8", x"F8", x"F8", x"F8", x"F8", x"FC", x"FC", x"F8", x"F8", x"FC", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"FC", x"FC", x"FC", x"FC", x"DA", x"AD", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"DA", x"B6", x"AD", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D6"),
(x"64", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"44", x"44", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"B0", x"D8", x"D4", x"90", x"D4", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"D8", x"B0", x"B4", x"F8", x"B0", x"64", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD"),
(x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"44", x"44", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"B0", x"D4", x"8C", x"48", x"8C", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"B0", x"68", x"68", x"F8", x"B4", x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"8C", x"8D", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD"),
(x"64", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"44", x"44", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"B0", x"D8", x"B4", x"90", x"B4", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"D4", x"90", x"B0", x"F8", x"B0", x"64", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"8D", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD"),
(x"64", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"44", x"44", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"B0", x"D8", x"F8", x"D8", x"F8", x"F8", x"F8", x"F8", x"D8", x"F9", x"F9", x"F9", x"F9", x"F9", x"F9", x"F9", x"F9", x"F9", x"F9", x"F9", x"F9", x"F9", x"F9", x"F9", x"F9", x"F8", x"F8", x"F8", x"F8", x"F8", x"D8", x"D8", x"F8", x"B0", x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"8D", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD"),
(x"64", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"44", x"44", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"B0", x"D8", x"F8", x"F8", x"F8", x"F8", x"F8", x"D8", x"DA", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FA", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"B0", x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"8D", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD"),
(x"64", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"44", x"44", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"B0", x"D8", x"F8", x"F8", x"F8", x"F8", x"F8", x"DA", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FA", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"B0", x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"8D", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD"),
(x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"44", x"44", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"B0", x"D8", x"F8", x"F8", x"F8", x"F8", x"DA", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DA", x"F8", x"F8", x"F8", x"F8", x"F8", x"B0", x"64", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"8D", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD"),
(x"64", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"44", x"44", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"B0", x"D8", x"F8", x"F8", x"F8", x"D8", x"DA", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DA", x"F8", x"F8", x"F8", x"F8", x"F8", x"B0", x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"8C", x"AD", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD"),
(x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"88", x"44", x"44", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"88", x"8C", x"D8", x"F8", x"F8", x"F8", x"D8", x"DA", x"FF", x"FF", x"FF", x"FF", x"FF", x"DB", x"B0", x"B4", x"B0", x"B0", x"B4", x"B0", x"B4", x"B0", x"DB", x"FF", x"FF", x"FF", x"FF", x"FF", x"DA", x"F8", x"F8", x"F8", x"F8", x"F8", x"B0", x"44", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"24", x"44", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"8D"),
(x"B6", x"20", x"24", x"24", x"24", x"24", x"20", x"24", x"24", x"24", x"20", x"24", x"24", x"24", x"24", x"20", x"20", x"24", x"20", x"20", x"24", x"24", x"24", x"24", x"24", x"24", x"24", x"20", x"20", x"20", x"24", x"24", x"00", x"68", x"F8", x"F8", x"F8", x"F8", x"D8", x"DA", x"FF", x"FF", x"FF", x"FF", x"FF", x"DB", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"D8", x"DB", x"FF", x"FF", x"FF", x"FF", x"FF", x"DA", x"F8", x"F8", x"F8", x"F8", x"F8", x"90", x"00", x"24", x"24", x"20", x"24", x"24", x"20", x"24", x"24", x"24", x"24", x"20", x"20", x"24", x"24", x"20", x"20", x"20", x"20", x"20", x"20", x"24", x"24", x"20", x"24", x"24", x"24", x"20", x"20", x"24", x"20", x"20", x"B6"),
(x"B6", x"8D", x"8D", x"8D", x"8D", x"8D", x"8D", x"68", x"20", x"68", x"AD", x"8D", x"8D", x"8D", x"8D", x"8D", x"8D", x"8D", x"8D", x"8D", x"8D", x"8D", x"8D", x"8D", x"24", x"24", x"88", x"8D", x"8D", x"8D", x"8D", x"8D", x"8D", x"6C", x"D8", x"F8", x"F8", x"F8", x"D8", x"DA", x"FF", x"FF", x"FF", x"FF", x"FF", x"DB", x"D8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"D4", x"DB", x"FF", x"FF", x"FF", x"FF", x"FF", x"DA", x"F8", x"F8", x"F8", x"F8", x"F8", x"B0", x"68", x"AD", x"8D", x"8D", x"8D", x"8D", x"8D", x"24", x"24", x"88", x"8D", x"8D", x"8D", x"8D", x"8D", x"8D", x"8D", x"8D", x"8D", x"8D", x"8D", x"8D", x"8D", x"6D", x"24", x"44", x"8D", x"8D", x"8D", x"8D", x"8D", x"8D", x"DA"),
(x"68", x"AD", x"AD", x"AD", x"AD", x"8D", x"AD", x"AD", x"24", x"68", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"8D", x"AD", x"68", x"24", x"88", x"AD", x"AD", x"AD", x"AD", x"8D", x"AD", x"B0", x"D4", x"F8", x"F8", x"F8", x"D8", x"DA", x"FF", x"FF", x"FF", x"FF", x"FF", x"DB", x"D8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"D4", x"DA", x"FF", x"FF", x"FF", x"FF", x"FF", x"DA", x"F8", x"F8", x"F8", x"F8", x"F8", x"B0", x"88", x"AD", x"AD", x"AD", x"AD", x"AC", x"CD", x"68", x"24", x"88", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"D1", x"44", x"44", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"B1"),
(x"64", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"68", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"8D", x"B0", x"D8", x"F8", x"F8", x"F8", x"D8", x"B1", x"92", x"B1", x"B1", x"B1", x"B1", x"B5", x"F8", x"F8", x"F8", x"F8", x"F9", x"F9", x"F9", x"D9", x"FB", x"FF", x"FF", x"FF", x"FF", x"FF", x"DA", x"F8", x"F8", x"F8", x"F8", x"F8", x"B0", x"64", x"88", x"88", x"88", x"88", x"88", x"AD", x"68", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"44", x"44", x"88", x"88", x"88", x"88", x"88", x"88", x"AD"),
(x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"68", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"AD", x"B0", x"D8", x"F8", x"F8", x"F8", x"F8", x"D4", x"D4", x"D4", x"D4", x"D4", x"D4", x"D4", x"F8", x"F8", x"F9", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DA", x"F8", x"F8", x"F8", x"F8", x"F8", x"B0", x"64", x"88", x"88", x"88", x"88", x"88", x"AD", x"68", x"24", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"44", x"44", x"88", x"88", x"88", x"88", x"88", x"88", x"AD"),
(x"64", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"68", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"AD", x"B0", x"D8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F9", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DB", x"D5", x"F8", x"F8", x"F8", x"F8", x"F8", x"B0", x"64", x"88", x"88", x"88", x"88", x"88", x"AD", x"68", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"44", x"44", x"88", x"88", x"88", x"88", x"88", x"88", x"AD"),
(x"64", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"68", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"AD", x"B0", x"D8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"D8", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DB", x"B5", x"D8", x"F8", x"F8", x"F8", x"F8", x"F8", x"B0", x"64", x"88", x"88", x"88", x"88", x"88", x"AD", x"68", x"24", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"44", x"44", x"88", x"88", x"88", x"88", x"88", x"88", x"AD"),
(x"64", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"68", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"AD", x"B0", x"D8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"D5", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DB", x"B6", x"B7", x"DA", x"DB", x"B5", x"D8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"B0", x"64", x"88", x"88", x"88", x"88", x"88", x"AD", x"68", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"44", x"44", x"88", x"88", x"88", x"88", x"88", x"88", x"AD"),
(x"64", x"88", x"88", x"88", x"88", x"88", x"88", x"8D", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"68", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"AD", x"B0", x"D8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"D5", x"DF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B5", x"B0", x"B0", x"B0", x"B0", x"D8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"B0", x"64", x"88", x"88", x"88", x"88", x"88", x"AD", x"68", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"44", x"44", x"88", x"88", x"88", x"88", x"88", x"88", x"AD"),
(x"64", x"88", x"88", x"88", x"88", x"88", x"8C", x"AD", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"68", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"AD", x"B0", x"D4", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"D5", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"D9", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"B0", x"64", x"88", x"88", x"88", x"88", x"88", x"AD", x"68", x"24", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"44", x"44", x"88", x"88", x"88", x"88", x"88", x"88", x"AD"),
(x"44", x"88", x"88", x"88", x"88", x"88", x"88", x"8C", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AC", x"68", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"8C", x"B0", x"D8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"D5", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"D9", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"B0", x"64", x"88", x"88", x"88", x"88", x"88", x"AC", x"68", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"44", x"44", x"88", x"88", x"88", x"88", x"88", x"88", x"AD"),
(x"92", x"24", x"24", x"24", x"24", x"24", x"24", x"24", x"20", x"24", x"24", x"24", x"24", x"24", x"24", x"24", x"44", x"44", x"24", x"24", x"24", x"24", x"24", x"24", x"24", x"20", x"24", x"24", x"24", x"24", x"24", x"24", x"20", x"6C", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"D5", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"D9", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"D8", x"F8", x"90", x"20", x"44", x"24", x"24", x"24", x"24", x"24", x"24", x"20", x"24", x"24", x"24", x"24", x"24", x"24", x"44", x"44", x"44", x"24", x"24", x"24", x"24", x"24", x"24", x"20", x"20", x"24", x"24", x"24", x"24", x"24", x"24", x"B2"),
(x"DA", x"48", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"48", x"24", x"24", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"44", x"6C", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"D4", x"90", x"90", x"90", x"90", x"90", x"90", x"D4", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"D8", x"F8", x"90", x"24", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"24", x"24", x"44", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"DB"),
(x"89", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"B1", x"24", x"44", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"D1", x"B0", x"D8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F9", x"F9", x"F9", x"F9", x"F9", x"F9", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"D8", x"F8", x"B0", x"88", x"D1", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"D1", x"8D", x"20", x"88", x"D1", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"AD", x"D1"),
(x"44", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"68", x"AD", x"44", x"44", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"68", x"AD", x"B0", x"D8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"D9", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"D9", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"B0", x"64", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"68", x"88", x"AD", x"24", x"64", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD"),
(x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"44", x"44", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"B0", x"D8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"D5", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"D9", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"B0", x"64", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"8D", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD"),
(x"64", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"44", x"44", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"B0", x"D8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"D5", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"D9", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"B0", x"64", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"8D", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD"),
(x"64", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"44", x"44", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"B0", x"D8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"D5", x"BB", x"DB", x"DB", x"DB", x"DB", x"D7", x"D5", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"B0", x"64", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"8D", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD"),
(x"64", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"44", x"44", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"B0", x"D8", x"D4", x"B0", x"D8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"D4", x"B0", x"B0", x"B0", x"B0", x"B0", x"B0", x"D8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"D8", x"B0", x"D4", x"F8", x"B0", x"64", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"8D", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD"),
(x"64", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"44", x"44", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"B0", x"D4", x"8C", x"48", x"8C", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"B0", x"68", x"68", x"F8", x"B4", x"64", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"8D", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD"),
(x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"44", x"44", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"B0", x"D4", x"B0", x"90", x"B0", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"D8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"D4", x"90", x"90", x"F8", x"B4", x"64", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD"),
(x"44", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"44", x"44", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD", x"B0", x"D8", x"F8", x"D8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"D8", x"D8", x"F8", x"B0", x"64", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"8C", x"20", x"64", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"AD"),
(x"6D", x"64", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"44", x"8D", x"B6", x"8D", x"44", x"68", x"68", x"64", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"44", x"69", x"B1", x"8C", x"8C", x"8C", x"8C", x"8C", x"8C", x"8C", x"8C", x"8C", x"8C", x"8C", x"8C", x"8C", x"8C", x"8C", x"8C", x"8C", x"8C", x"8C", x"8C", x"8C", x"8C", x"8C", x"8C", x"8C", x"8C", x"8C", x"8C", x"8C", x"8C", x"8C", x"90", x"B5", x"68", x"64", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"64", x"B2", x"B6", x"69", x"64", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"64", x"64", x"68", x"44", x"8D")
);

type object_form is array (0 to object_Y_size - 1 , 0 to 100 - 1) of std_logic;
constant object : object_form := (
("1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111101111111111111111111111111111111111011111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111")
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
		
end behav;		
		