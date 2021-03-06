library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- Alex Grinshpun March 24 2017 

entity mux_draw_cloud is
port 	(
		--////////////////////	Clock Input	 	////////////////////	 
		CLK				: in std_logic; --						//	27 MHz
		RESETn			: in std_logic; --			//	50 MHz
		drawR1 			: in std_logic;
		drawR2 			: in std_logic;
		drawR3 			: in std_logic;
		RGB1			: std_logic_vector(7 downto 0);
		RGB2			: std_logic_vector(7 downto 0);
		RGB3			: std_logic_vector(7 downto 0);
		drawR 			: out std_logic;
		RGB				: out std_logic_vector(7 downto 0)
	);
end mux_draw_cloud ;

architecture behav of mux_draw_cloud  is 

begin
		process(CLK)
		begin
		if drawR1 = '1' then
			drawR <= drawR1;
			RGB <= RGB1;
		elsif drawR2 = '1' then
			drawR <= drawR2;
			RGB <= RGB2;
		elsif drawR3 = '1' then
			drawR <= drawR3;
			RGB <= RGB3;
		else
			drawR <= '0';
			RGB <= RGB1;
		end if;
		end process;
end behav;