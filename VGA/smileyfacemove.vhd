library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.consts_pck.all;
-- Alex Grinshpun March 24 2017 

entity smileyfacemove is
port 	(
		--////////////////////	Clock Input	 	////////////////////	 
		CLK				: in std_logic; --						//	27 MHz
		RESETn			: in std_logic; --			//	50 MHz
		jump			: in std_logic; -- check if space is pressed.
		timer_done		: in std_logic;
		obstacle		: in std_logic;	-- indicates if mario is under or above a step
		obstacleQ		: in std_logic;
		obstcale_hight	: in integer;	-- indicates the hight of the step
		obstcale_location : in integer;
		move_right		: in std_logic;
		move_left		:in std_logic;
		jump_sound		:out std_logic;
		ObjectStartX	: out integer range 0 to 700;
		ObjectStartY	: out integer range 0 to 700;
		obst_sound		: out std_logic;
		mario_middle	: out std_logic;
		QMove			:out std_logic; -- added by yotam.
		is_jumping		:out std_logic
		
	);
end smileyfacemove;

architecture behav of smileyfacemove is 


   type state is ( idle           ,   -- initial state
					JumpNoObstacle  ,   -- jumping
					JumpUnder,
					JumpAbove,
					freeFall,
					freeFallUnder,
					stateDown1	   -- doesnot jump until space is free
					) ;   -- sample out new extended-rel code
signal present_state , next_state : state;
signal jumping : std_logic;
signal ObjectStartX_t : integer range 0 to 680;
signal ObjectStartY_t : integer range 0 to 512;
signal count: integer;
signal counter :integer; -- added by yotam.
signal first_location_y: integer;

constant v :integer:=26;
constant a : integer:=1;
--################
begin

		first_location_y<=(obstcale_hight-mario_hight) when obstacle='1' else mario_location;



		process ( RESETn,CLK)
		variable next_location_y: integer range 0 to 700;
		variable jump_start_y : integer range 0 to 700;
		variable jump_sound_count: integer;
		variable obst_sound_count: integer;

		begin
			if RESETn = '0' then
				present_state <= idle;
				next_state <= idle;
				ObjectStartX_t	<= 0;
				ObjectStartY_t	<= first_location_y ;
				count<=0;
				jump_sound<='0';
				obst_sound<='0';
				Qmove <= '0';
				counter <= 5000000;
			elsif CLK'event  and CLK = '1' then
				if jump_sound_count>0 then 
					jump_sound_count:=jump_sound_count-1;
					jump_sound<='1';
				else
					jump_sound<='0';
				end if;
				if obst_sound_count>0 then
					obst_sound_count:=obst_sound_count-1;
					obst_sound<='1';
				else
					obst_sound<='0';
				end if;
				
				if timer_done = '1' then
					if ObjectStartX_t<middle then
						mario_middle<='0';
						if move_left='1' and (ObjectStartX_t>10)  then
							ObjectStartX_t<=ObjectStartX_t-10;
						end if;
						if move_right='1' then
							ObjectStartX_t<=ObjectStartX_t+10;
						end if;
					else
						mario_middle<='1';
						if move_left='1' then
							ObjectStartX_t<=ObjectStartX_t-10;
						end if;
					end if;
					--if ObjectStartX_t <= 800 then
						--ObjectStartX_t <= 320;
						--ObjectStartY_t <= first_location_y;
					--else --if (jump = '1')or(jumping = '1') then
					
						case present_state is
							-------------
							when idle =>	
								count<=0;
								Qmove <= '0';
								--ObjectStartX_t  <= ObjectStartX_t;
								ObjectStartY_t  <= ObjectStartY_t;
								jump_start_y:=ObjectStartY_t;
								if jump = '1' then 
									--ObjectStartX_t<=ObjectStartX_t-1;
									jump_sound_count:=jump_sound_length;
									jumping <= '1';
									if obstacle='1' then
										if ObjectStartY_t>first_location_y then
											next_state <= JumpUnder;
										else
											next_state <= JumpAbove;
										end if;
									else
											next_state <= JumpNoObstacle;
									end if;
								else
									jump_sound_count:=0;
									if ObjectStartY_t<first_location_y and obstacle='0' then
										next_state <=freeFallUnder;
									else
										next_state <= idle;
									end if;
								end if;
								--next_state <=freeFall;
							---------------
							when JumpNoObstacle =>
								count<=count+1;
								next_location_y:=jump_start_y-(v*count)+(a*count*count);
								if (next_location_y)> mario_location then
									ObjectStartY_t<=first_location_y;
									jumping<='0';
									if jump='1' then
										next_state<=stateDown1;
									else
										next_state<=idle;
									end if;
								elsif next_location_Y<mario_sky_limit then
									next_location_Y:=mario_sky_limit;
									jump_start_y:=mario_sky_limit;
									next_state<=freeFall;
								else
									--ObjectStartY_t  <= next_location_y;
									if obstacle='1' then
										if ObjectStartY_t>obstcale_hight then
											next_state <= JumpUnder;
										else
											next_state <= JumpAbove;
										end if;
									else
										ObjectStartY_t  <= next_location_y;
										next_state <= JumpNoObstacle;
									end if;
								end if;
							------------------
							when JumpUnder =>
								count<=count+1;
								next_location_y:=jump_start_y-(v*count)+(a*count*count);
								if (next_location_y)> mario_location then			----finish to jump
									ObjectStartY_t<= mario_location;
									jumping<='0';
									if jump='1' then
										next_state<=stateDown1;
									else
										next_state<=idle;
									end if;
								elsif ((next_location_y)<first_location_y+obstacle_length_y+mario_hight)and obstacle='1' then	---is at the obstacle
								--elsif (next_location_y)<obstcale_hight+obstacle_length_y then	---is at the obstacle
									jump_start_y:=first_location_y+obstacle_length_y+mario_hight;
									ObjectStartY_t  <= first_location_y+obstacle_length_y+mario_hight;
									next_state<=freeFallUnder;
									jump_start_y:=first_location_y+obstacle_length_y+mario_hight;
									if objectStartX_t > obstcale_location +25 then -- added by yotam.
											if objectStartX_t < obstcale_location + 60 then 
												Qmove <= '1';
											end if;
									end if;
									obst_sound_count:=obst_sound_length;
								else													----countinue to jump
									--ObjectStartX_t  <= ObjectStartX_t;
									ObjectStartY_t  <= next_location_y;
									if obstacle='1' then
										if ObjectStartY_t>first_location_y then
											next_state <= JumpUnder;
										else
											next_state <= JumpAbove;
										end if;
									else
										next_state <= JumpNoObstacle;
									end if;
								end if;
							------------------
							when JumpAbove =>
								count<=count+1;
								next_location_y:=jump_start_y-(v*count)+(a*count*count);
								if (next_location_y)> first_location_y then			----finish to jump
									ObjectStartY_t<=first_location_y;
									jumping<='0';
									if jump='1' then
										next_state<=stateDown1;
									else
										next_state<=idle;
									end if;
								elsif next_location_Y<50 then	--reach to sky
									next_location_Y:=50;
									jump_start_y:=50;
									next_state<=freeFall;
								else----countinue to jump
									--ObjectStartX_t  <= ObjectStartX_t;
									ObjectStartY_t  <= next_location_y;
									if obstacle='1' then
										if ObjectStartY_t>first_location_y then
											next_state <= JumpUnder;
										else
											next_state <= JumpAbove;
										end if;
									else
										next_state <= JumpNoObstacle;
									end if;
								end if;
							------------------
							when freeFall =>
								count<=count+1;
								next_location_y:=jump_start_y+(a*count*count);
								if (next_location_y)> first_location_y then
									ObjectStartY_t<=first_location_y;
									jumping<='0';
									if jump='1' then
										next_state<=stateDown1;
									else
										next_state<=idle;
									end if;
								else
									--ObjectStartX_t  <= ObjectStartX_t;
									ObjectStartY_t  <= next_location_y;--jump function
									next_state<=freeFall;
								end if;
							-------------------
							when freeFallUnder =>
								count<=count+1;
								next_location_y:=jump_start_y+(a*count*count);
								if (next_location_y)> mario_location then
									ObjectStartY_t<= mario_location;
									jumping<='0';
									if jump='1' then
										next_state<=stateDown1;
									else
										next_state<=idle;
									end if;
								elsif obstacle='1' and next_location_Y<first_location_y then
									ObjectStartY_t<=first_location_y;
									jumping<='0';
									if jump='1' then
										next_state<=stateDown1;
									else
										next_state<=idle;
									end if;
									--ObjectStartX_t  <= ObjectStartX_t;
								else 	
									ObjectStartY_t  <= next_location_y;--jump function
									next_state<=freeFallUnder;
								end if;
							-------------------
							when stateDown1=>
								if jump='0' then
									next_state<=idle;
								end if;
							------------------
							when others =>
								next_state <= idle;
						end case;
					
				end if;
				if present_state=stateDown1 and jump='0' then
					next_state<=idle;
				end if;
			end if;
			present_state <= next_state;
			is_jumping<=jumping;
		
		end process ;
ObjectStartX	<= ObjectStartX_t;			
ObjectStartY	<= ObjectStartY_t;	

--ObjectStartX	<= 100;			
--ObjectStartY	<= 100;		
end behav;