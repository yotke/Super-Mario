library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- Alex Grinshpun July 24 2017 


entity running is
port 	(
		--////////////////////	Clock Input	 	////////////////////	
		clk: in std_logic;
		enable_running: in std_logic;
		enable_jump: in std_logic;
		RGB1: in std_logic_vector(7 downto 0);
		draw_1: in std_logic;
		RGB2: in std_logic_vector(7 downto 0);
		draw_2: in std_logic;
		RGB_jump: in std_logic_vector(7 downto 0);
		draw_jump: in std_logic;
		--enable3: in std_logic;
		resetN: in std_logic;
	   
		
		mVGA_RGB: out std_logic_vector (7 downto 0);
		draw_request: out std_logic


	);
end running;

architecture behav of running is 


signal count:integer;
signal RGB_out : std_logic_vector(7 downto 0);
signal draw_out: std_logic;
type state is (idle, first, second);
signal present_state, next_state : state;


begin
process (clk,enable_running)
constant pic_time: integer:=500000;
begin
	if resetN='0' then
		count<= 0;
		RGB_out<=RGB1;
		draw_out<=draw_1;
	elsif clk'event  and clk = '1' then
		if enable_jump='1' then
			RGB_out<=RGB_jump;
			draw_out<=draw_jump;
		else
			case present_state is
				when idle=>
					RGB_out<=RGB1;
					draw_out<=draw_1;
					if enable_running='1' then
						count<=pic_time;
						next_state<=second;
					else
						next_state<=idle;
					end if;
				when first=>
					RGB_out<=RGB1;
					draw_out<=draw_1;
					if enable_running='1' then
						if count>0 then
							count<=count-1;
							next_state<=first;
						else
							count<=pic_time;
							next_state<=second;
						end if;
					else
						next_state<=idle;
					end if;
				when second=>
					RGB_out<=RGB2;
					draw_out<=draw_2;
					if enable_running='1' then
						if count>0 then
							count<=count-1;
							next_state<=second;
						else
							count<=pic_time;
							next_state<=first;
						end if;
					else
						next_state<=idle;
					end if;
			end case;
		end if;
		mVGA_RGB<=RGB_out;
		draw_request<=draw_out;
		present_state<=next_state;
			
	end if;
	
end process;

end behav;		