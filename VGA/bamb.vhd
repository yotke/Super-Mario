library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- Alex Grinshpun March 24 2017 

entity bomb_move is
port 	(
		--////////////////////	Clock Input	 	////////////////////	 
		CLK				: in std_logic; --						//	27 MHz
		RESETn			: in std_logic; --			//	50 MHz
		jump			: in std_logic; -- check if space is pressed.
		timer_done		: in std_logic;
		ObjectStartX	: out integer ;
		ObjectStartY	: out integer
		
	);
end bomb_move;

architecture behav of bomb_move is 


   type state is ( idle           ,   -- initial state
					stateUp1  ,   -- 
                    stateUp2     ,   -- 
					stateUp3,   -- 
					stateDown1	,   -- 
					stateDown2,   -- 
                    stateDown3) ;   -- sample out new extended-rel code
signal present_state , next_state : state;
signal jumping : std_logic;
signal ObjectStartX_t : integer range 0 to 680;
signal ObjectStartY_t : integer range 0 to 512;
begin





		process ( RESETn,CLK,present_state)
		begin
		  if RESETn = '0' then
				present_state <= idle;
				next_state <= idle;
				ObjectStartX_t	<= 400;
				ObjectStartY_t	<= 350 ;
		elsif CLK'event  and CLK = '1' then
			if timer_done = '1' then
				if ObjectStartX_t <= 100 then
					ObjectStartX_t <= 580;
					ObjectStartY_t <= 385;
				elsif (jump = '1')or(jumping = '1') then
					case present_state is
						when idle =>	
							ObjectStartX_t  <= ObjectStartX_t;
							ObjectStartY_t  <= ObjectStartY_t;
							if jump = '1' then 
								next_state <= stateUp1;
								jumping <= '1';
							else
								next_state <= idle;
							end if;
						when stateUp1 =>
							ObjectStartX_t  <= ObjectStartX_t;
							ObjectStartY_t  <= ObjectStartY_t-40;
							next_state <= stateUp2;
						when stateUp2 =>
							ObjectStartX_t  <= ObjectStartX_t;
							ObjectStartY_t  <= ObjectStartY_t-25;
							next_state <= stateUp3;
						when stateUp3 =>
							ObjectStartX_t  <= ObjectStartX_t;
							ObjectStartY_t  <= ObjectStartY_t-5;
							next_state <= statedown1;
						when stateDown1 =>
							ObjectStartX_t  <= ObjectStartX_t;
							ObjectStartY_t  <= ObjectStartY_t+5;
							next_state <= stateDown2;
						when stateDown2 =>
							ObjectStartX_t  <= ObjectStartX_t;
							ObjectStartY_t  <= ObjectStartY_t+25;
							next_state <= stateDown3;
						when stateDown3 =>
							ObjectStartX_t  <= ObjectStartX_t;
							ObjectStartY_t  <= ObjectStartY_t+40;
							jumping<='0';
							next_state <= idle;
						when others =>
							next_state <= idle;
						end case;
				end if;
			end if;
			present_state <= next_state;
			
		end if;
		end process ;
ObjectStartX	<= ObjectStartX_t;			
ObjectStartY	<= ObjectStartY_t;	

--ObjectStartX	<= 100;			
--ObjectStartY	<= 100;		
end behav;