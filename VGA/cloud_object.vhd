library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use IEEE.std_logic_unsigned.all;
--use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
-- Alex Grinshpun April 2017

entity cloud_object is
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
end cloud_object;

architecture arch of cloud_object is 
constant object_X_size : integer := 75;
constant object_Y_size : integer :=39;
constant R_high		: integer := 7;
constant R_low		: integer := 5;
constant G_high		: integer := 4;
constant G_low		: integer := 2;
constant B_high		: integer := 1;
constant B_low		: integer := 0;

type ram_array is array(0 to  object_Y_size - 1, 0 to 75 - 1) of std_logic_vector(7 downto 0);  

-- 8 bit - color definition : "RRRGGGBB"  
constant object_colors: ram_array := ( 
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"06", x"05", x"05", x"05", x"05", x"05", x"05", x"0A", x"0A", x"0A", x"0A", x"0A", x"0A", x"05", x"05", x"05", x"05", x"05", x"05", x"06", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"01", x"05", x"05", x"05", x"05", x"0A", x"2A", x"4E", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"4E", x"2A", x"0A", x"05", x"05", x"05", x"05", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"05", x"05", x"05", x"05", x"0A", x"4E", x"72", x"97", x"97", x"97", x"97", x"97", x"97", x"97", x"97", x"97", x"97", x"97", x"97", x"72", x"4E", x"0A", x"05", x"05", x"05", x"05", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"05", x"05", x"05", x"0A", x"4E", x"72", x"97", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"97", x"97", x"97", x"97", x"97", x"72", x"2E", x"0A", x"05", x"05", x"05", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"05", x"06", x"05", x"0A", x"72", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"97", x"4E", x"0A", x"05", x"05", x"05", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"05", x"05", x"2A", x"72", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"B7", x"B7", x"B7", x"B7", x"B7", x"72", x"0A", x"05", x"05", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"05", x"05", x"2A", x"72", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"B7", x"72", x"0A", x"05", x"05", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"01", x"05", x"0A", x"72", x"BB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"72", x"0A", x"05", x"01", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"0A", x"05", x"4E", x"BB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"BB", x"BB", x"BB", x"B7", x"4E", x"05", x"05", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"05", x"05", x"06", x"0A", x"0A", x"06", x"05", x"2A", x"97", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"97", x"0A", x"05", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"05", x"0A", x"01", x"05", x"05", x"05", x"05", x"05", x"4E", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DF", x"DF", x"DF", x"DF", x"DF", x"DF", x"DF", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"BB", x"4E", x"05", x"01", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"05", x"01", x"05", x"2A", x"4E", x"4E", x"4E", x"4E", x"2A", x"97", x"DB", x"DB", x"DB", x"DB", x"DF", x"DF", x"DF", x"DF", x"DF", x"DF", x"DF", x"DF", x"FF", x"DF", x"DF", x"DF", x"DF", x"DF", x"DF", x"DF", x"DF", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"96", x"0A", x"01", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"01", x"05", x"0A", x"4E", x"97", x"BB", x"DB", x"DB", x"DB", x"B7", x"DB", x"DB", x"DF", x"DF", x"DF", x"DF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DF", x"DF", x"DF", x"DF", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"BB", x"2E", x"05", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"05", x"4E", x"BB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DF", x"DF", x"DF", x"DF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DF", x"DF", x"DF", x"DB", x"DB", x"DB", x"DB", x"DB", x"4E", x"05", x"0A", x"05", x"06", x"06", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"06", x"06", x"06", x"05", x"05", x"06", x"05", x"2A", x"B7", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DF", x"DF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DF", x"DF", x"DB", x"DB", x"DB", x"DB", x"72", x"05", x"05", x"05", x"4E", x"06", x"05", x"05", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"06", x"05", x"05", x"0A", x"0A", x"BB", x"00", x"00", x"FF", x"05", x"4E", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DF", x"DF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DF", x"DF", x"DB", x"DB", x"DB", x"B7", x"72", x"4E", x"2A", x"0A", x"05", x"01", x"05", x"05", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"05", x"05", x"05", x"01", x"05", x"05", x"0A", x"0A", x"0A", x"2A", x"0A", x"0A", x"72", x"DB", x"DB", x"DB", x"DB", x"DB", x"DF", x"DF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DF", x"DF", x"DB", x"DB", x"DB", x"DB", x"DB", x"B7", x"72", x"4E", x"0A", x"05", x"0A", x"05", x"00", x"02", x"02", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"05", x"05", x"05", x"05", x"0A", x"2A", x"4E", x"72", x"96", x"97", x"97", x"97", x"92", x"B7", x"DB", x"DB", x"DB", x"DB", x"DF", x"DF", x"DF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DF", x"DF", x"DF", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"BB", x"72", x"2A", x"05", x"2A", x"06", x"06", x"05", x"05", x"05", x"06", x"00", x"00", x"00"),
(x"00", x"05", x"05", x"05", x"0A", x"2E", x"72", x"97", x"B7", x"BB", x"BB", x"BB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DF", x"DF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DF", x"DF", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"BB", x"97", x"2E", x"05", x"05", x"05", x"05", x"05", x"01", x"05", x"05", x"00", x"00"),
(x"01", x"05", x"05", x"0A", x"4E", x"97", x"B7", x"B7", x"B7", x"BB", x"BB", x"BB", x"BB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DF", x"DF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DF", x"DF", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"BB", x"BB", x"97", x"4E", x"4E", x"4E", x"4E", x"2A", x"0A", x"05", x"0A", x"05", x"00"),
(x"05", x"05", x"0A", x"72", x"97", x"97", x"B7", x"B7", x"B7", x"BB", x"BB", x"BB", x"BB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DF", x"DF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DF", x"DF", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"BB", x"BB", x"BB", x"B7", x"B7", x"B7", x"97", x"97", x"72", x"2A", x"05", x"05", x"05"),
(x"05", x"0A", x"4E", x"97", x"97", x"97", x"B7", x"B7", x"B7", x"B7", x"BB", x"BB", x"BB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DF", x"DF", x"DF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DF", x"DF", x"DF", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"BB", x"BB", x"BB", x"BB", x"B7", x"B7", x"B7", x"97", x"97", x"72", x"2A", x"05", x"06"),
(x"05", x"2A", x"92", x"97", x"97", x"97", x"97", x"B7", x"B7", x"B7", x"BB", x"BB", x"BB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DF", x"DF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DF", x"DF", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"BB", x"BB", x"BB", x"B7", x"B7", x"B7", x"97", x"97", x"97", x"97", x"72", x"0A", x"05"),
(x"05", x"4E", x"96", x"97", x"97", x"97", x"97", x"B7", x"B7", x"B7", x"BB", x"BB", x"BB", x"BB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DF", x"DF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DF", x"DF", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"BB", x"BB", x"BB", x"BB", x"B7", x"B7", x"B7", x"97", x"97", x"97", x"97", x"92", x"4E", x"05"),
(x"0A", x"72", x"92", x"96", x"97", x"97", x"97", x"97", x"B7", x"B7", x"B7", x"BB", x"BB", x"BB", x"BB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DF", x"DF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DF", x"DF", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"BB", x"BB", x"BB", x"BB", x"B7", x"B7", x"B7", x"97", x"97", x"97", x"97", x"96", x"92", x"72", x"0A"),
(x"0A", x"72", x"72", x"92", x"97", x"97", x"97", x"97", x"B7", x"B7", x"B7", x"B7", x"BB", x"BB", x"BB", x"BB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DF", x"DF", x"DF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DF", x"DF", x"DF", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"BB", x"BB", x"BB", x"BB", x"B7", x"B7", x"B7", x"B7", x"97", x"97", x"97", x"97", x"92", x"72", x"72", x"0A"),
(x"0A", x"72", x"72", x"92", x"96", x"97", x"97", x"97", x"97", x"B7", x"B7", x"B7", x"B7", x"BB", x"BB", x"BB", x"BB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DF", x"DF", x"DF", x"DF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DF", x"DF", x"DF", x"DF", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"BB", x"BB", x"BB", x"BB", x"B7", x"B7", x"B7", x"B7", x"97", x"97", x"97", x"97", x"92", x"92", x"72", x"72", x"0A"),
(x"05", x"4E", x"72", x"72", x"92", x"96", x"97", x"97", x"97", x"97", x"B7", x"B7", x"B7", x"B7", x"BB", x"BB", x"BB", x"BB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DF", x"DF", x"DF", x"DF", x"DF", x"DF", x"DF", x"DF", x"FF", x"DF", x"DF", x"DF", x"DF", x"DF", x"DF", x"DF", x"DF", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"BB", x"BB", x"BB", x"BB", x"B7", x"B7", x"B7", x"B7", x"97", x"97", x"97", x"97", x"96", x"92", x"72", x"72", x"72", x"0A"),
(x"05", x"2A", x"72", x"72", x"72", x"92", x"96", x"97", x"97", x"97", x"97", x"B7", x"B7", x"B7", x"B7", x"BB", x"BB", x"BB", x"BB", x"BB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DF", x"DF", x"DF", x"DF", x"DF", x"DF", x"DF", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"BB", x"BB", x"BB", x"BB", x"BB", x"B7", x"B7", x"B7", x"B7", x"97", x"97", x"97", x"97", x"96", x"92", x"72", x"72", x"72", x"4E", x"05"),
(x"05", x"05", x"4E", x"72", x"72", x"72", x"92", x"96", x"97", x"97", x"97", x"97", x"97", x"B7", x"B7", x"B7", x"B7", x"BB", x"BB", x"BB", x"BB", x"BB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"BB", x"BB", x"BB", x"BB", x"BB", x"B7", x"B7", x"B7", x"B7", x"97", x"97", x"97", x"97", x"97", x"96", x"92", x"72", x"72", x"72", x"72", x"0A", x"05"),
(x"05", x"05", x"0A", x"4E", x"72", x"72", x"72", x"72", x"92", x"97", x"97", x"97", x"97", x"97", x"B7", x"B7", x"B7", x"B7", x"B7", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"B7", x"B7", x"B7", x"B7", x"B7", x"97", x"97", x"97", x"97", x"97", x"92", x"72", x"72", x"72", x"72", x"72", x"2A", x"05", x"05"),
(x"05", x"05", x"05", x"0A", x"4E", x"72", x"72", x"72", x"72", x"92", x"96", x"97", x"97", x"97", x"97", x"97", x"B7", x"B7", x"B7", x"B7", x"B7", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"B7", x"B7", x"B7", x"B7", x"B7", x"97", x"97", x"97", x"97", x"97", x"96", x"92", x"72", x"72", x"72", x"72", x"4E", x"0A", x"05", x"05", x"05"),
(x"00", x"06", x"05", x"05", x"05", x"2A", x"4E", x"72", x"72", x"72", x"92", x"92", x"97", x"97", x"97", x"97", x"97", x"72", x"4E", x"92", x"B7", x"B7", x"B7", x"B7", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"B7", x"B7", x"B7", x"B7", x"B7", x"97", x"97", x"97", x"97", x"97", x"97", x"96", x"92", x"92", x"72", x"2E", x"2A", x"2A", x"0A", x"05", x"05", x"05", x"05", x"00"),
(x"00", x"00", x"05", x"05", x"05", x"05", x"05", x"0A", x"2A", x"4E", x"4E", x"4E", x"72", x"4E", x"4E", x"4E", x"2A", x"0A", x"05", x"4E", x"97", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"B7", x"BB", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"97", x"97", x"97", x"97", x"97", x"97", x"97", x"96", x"92", x"72", x"72", x"72", x"2A", x"05", x"05", x"05", x"05", x"FF", x"05", x"05", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"05", x"05", x"00", x"05", x"05", x"05", x"05", x"05", x"05", x"05", x"05", x"05", x"05", x"01", x"05", x"0A", x"72", x"97", x"97", x"97", x"97", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"97", x"72", x"4E", x"97", x"B7", x"B7", x"B7", x"97", x"97", x"97", x"97", x"97", x"97", x"97", x"97", x"92", x"92", x"72", x"72", x"72", x"72", x"2E", x"05", x"05", x"05", x"05", x"05", x"05", x"0A", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"06", x"05", x"05", x"05", x"05", x"05", x"4E", x"72", x"0A", x"05", x"05", x"05", x"05", x"05", x"05", x"0A", x"72", x"97", x"97", x"97", x"97", x"97", x"97", x"97", x"97", x"97", x"B7", x"72", x"2E", x"72", x"92", x"97", x"97", x"97", x"97", x"97", x"92", x"72", x"2E", x"0A", x"05", x"2A", x"72", x"97", x"97", x"97", x"97", x"97", x"97", x"97", x"92", x"92", x"72", x"72", x"72", x"72", x"72", x"72", x"2A", x"05", x"05", x"05", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"01", x"06", x"06", x"06", x"06", x"06", x"06", x"00", x"00", x"00", x"05", x"05", x"05", x"0A", x"4E", x"72", x"97", x"97", x"97", x"97", x"97", x"97", x"96", x"4E", x"0A", x"05", x"05", x"0A", x"2A", x"2E", x"2E", x"2E", x"2A", x"0A", x"05", x"05", x"01", x"01", x"05", x"0A", x"4E", x"72", x"96", x"96", x"92", x"92", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"4E", x"0A", x"05", x"05", x"05", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"05", x"05", x"05", x"05", x"2A", x"4E", x"52", x"72", x"72", x"72", x"4E", x"2A", x"05", x"05", x"05", x"0A", x"01", x"05", x"05", x"05", x"05", x"05", x"01", x"0A", x"05", x"05", x"05", x"05", x"05", x"05", x"0A", x"2A", x"4E", x"72", x"72", x"72", x"72", x"72", x"72", x"4E", x"2E", x"0A", x"05", x"05", x"05", x"05", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"06", x"05", x"01", x"05", x"05", x"05", x"0A", x"0A", x"05", x"05", x"05", x"01", x"05", x"05", x"06", x"05", x"05", x"05", x"05", x"05", x"05", x"05", x"06", x"00", x"00", x"00", x"05", x"05", x"09", x"05", x"05", x"05", x"0A", x"0A", x"0A", x"0A", x"0A", x"0A", x"05", x"05", x"05", x"09", x"05", x"05", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00")
);

type object_form is array (0 to object_Y_size - 1 , 0 to 75 - 1) of std_logic;
constant object : object_form := (
("000000000000000000000000000000111111111111111111110000000000000000000000000"),
("000000000000000000000000000011111111111111111111111000000000000000000000000"),
("000000000000000000000000000111111111111111111111111110000000000000000000000"),
("000000000000000000000000001111111111111111111111111111000000000000000000000"),
("000000000000000000000000011111111111111111111111111111100000000000000000000"),
("000000000000000000000000011111111111111111111111111111100000000000000000000"),
("000000000000000000000000111111111111111111111111111111110000000000000000000"),
("000000000000000000000001111111111111111111111111111111111000000000000000000"),
("000000000000000000000001111111111111111111111111111111111000000000000000000"),
("000000000000000001111111111111111111111111111111111111111000000000000000000"),
("000000000000000011111111111111111111111111111111111111111100000000000000000"),
("000000000000000111111111111111111111111111111111111111111100000000000000000"),
("000000000000001111111111111111111111111111111111111111111100000000000000000"),
("000000000000000111111111111111111111111111111111111111111111110000000000000"),
("000000001111111111111111111111111111111111111111111111111111111100000000000"),
("000001111110011111111111111111111111111111111111111111111111111110000000000"),
("000111111111111111111111111111111111111111111111111111111111111111011000000"),
("001111111111111111111111111111111111111111111111111111111111111111111111000"),
("011111111111111111111111111111111111111111111111111111111111111111111111100"),
("111111111111111111111111111111111111111111111111111111111111111111111111110"),
("111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111"),
("011111111111111111111111111111111111111111111111111111111111111111111111110"),
("001111111111111111111111111111111111111111111111111111111111111111111111100"),
("000011011111111111111111111111111111111111111111111111111111111111111111000"),
("000001111111111111111111111111111111111111111111111111111111111111100000000"),
("000000001111111000111111111111111111111111111111111111111111111111000000000"),
("000000000000000000011111111111111111111111111111111111111111111110000000000"),
("000000000000000000001111111111111111111111100011111111111111111100000000000")
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

	drawing_X	<= '1' when  (oCoord_X  >= ObjectStartX) and  (oCoord_X < objectWestXboundary ) else '0';
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
			mVGA_RGB	<=  object_colors(bCoord_Y, bCoord_X );	
			drawing_request	<= object(bCoord_Y , bCoord_X ) and drawing_X and drawing_Y ;
			ObjectStartX_d <= ObjectStartX;
	end if;

  end process;

	keepflag <= '1' when 	ObjectStartX - ObjectStartX_d > 100 else '0';
		
end arch;		


