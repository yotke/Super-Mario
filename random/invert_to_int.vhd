library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- Alex Grinshpun July 24 2017 


entity invert_to_int is
port 	(
		--////////////////////	Clock Input	 	////////////////////	
	   rand_std : in std_logic_vector(7 downto 0);
		
		rand_int : out integer


	);
end invert_to_int;

architecture behav of invert_to_int is 


signal count:integer;


begin
process (rand_std)
begin
	count<=0;
	if rand_std(0)='1' then count<=count+1; end if;
	if rand_std(1)='1' then count<=count+2; end if;
	if rand_std(2)='1' then count<=count+4; end if;
	if rand_std(3)='1' then count<=count+8; end if;
	if rand_std(4)='1' then count<=count+16; end if;
	if rand_std(5)='1' then count<=count+32; end if;
	if rand_std(6)='1' then count<=count+64; end if;
	if rand_std(7)='1' then count<=count+128; end if;
	rand_int<=count;
end process;
	
end behav;		