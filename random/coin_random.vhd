library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- Alex Grinshpun July 24 2017 


entity coin_random is
port 	(
		--////////////////////	Clock Input	 	////////////////////	
		clk: in std_logic;
		enable: in std_logic;
		enable2: in std_logic;
		--enable3: in std_logic;
		resetN: in std_logic;
	   
		
		rand_int : out integer


	);
end coin_random;

architecture behav of coin_random is 


signal count:integer;
signal count_out : integer;


begin
process (clk,enable)
begin
	if resetN='0' then
		count<= 0;
		count_out<=0;
	elsif clk'event  and clk = '1' then
			count<=count+2;
			if count=150 then
				count<=0;
			end if;
			if enable='1' or enable2='1' then
				count_out<=count;
			end if;
	end if;
	
end process;
	rand_int<=count_out;
end behav;		