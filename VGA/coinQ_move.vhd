library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.consts_pck.all;
-- Alex Grinshpun March 24 2017 

entity coinQ_move is
port 	(
		--////////////////////	Clock Input	 	////////////////////	 
		CLK				: in std_logic; --						//	27 MHz
		RESETn			: in std_logic; --			//	50 MHz -- check if space is pressed.
		timer_done		: in std_logic;
		collision		: in std_logic;
		coinC			: 	in std_logic;	-- indicates if mario is under or above a step
		obstcale_hight	: in integer;	-- indicates the hight of the step
		obstcale_location : in integer;
		drawrequest		: out std_logic;
		ObjectStartX	: out integer ;
		ObjectStartY	: out integer
		
	);
end coinQ_move;

architecture behav of coinQ_move is 


   type state is ( idle,up1,up2,up3,down1,stop) ;   -- sample out new extended-rel code
signal wasC : std_logic;
signal counter : integer;
signal present_state , next_state : state;
signal ObjectStartX_t : integer range 0 to 680;
signal ObjectStartY_t : integer range 0 to 512;
constant ground :integer:=450;
constant v :integer:=25;
constant a : integer:=1;
--################
begin

		process ( RESETn,CLK,present_state)
		begin
			if RESETn = '0' then
				present_state <= idle;
				counter <= 5000000;
				next_state <= idle;
				ObjectStartX_t	<= obstcale_location+28;
				ObjectStartY_t	<=  obstcale_hight;
				drawrequest	<= '0';
				wasC <= '0';
			elsif CLK'event  and CLK = '1' then
				if timer_done = '1' then
						present_state <= idle;
					ObjectStartX_t <= obstcale_location+28;
				elsif coinC = '1' then
						counter <= 5000000;
						drawrequest <= '0';
						wasC <= '0';
						ObjectStartY_t <= obstcale_hight;
						next_state <= idle;
				elsif (collision = '1') or wasC = '1'  then
						drawrequest <= '1';
						case present_state is
							when idle =>
								if counter > 0 then 
									next_state <= idle;
									counter <= counter -1;
								else 
									ObjectStartY_t  <= obstcale_hight;
									counter <= 5000000;
									next_state <= up1;
								end if;
							when up1 =>
								if counter > 0 then 
									next_state <= up1;
									counter <= counter -1;
								else
									ObjectStartY_t  <= ObjectStartY_t-20;
									counter <= 5000000;
									next_state <= up2;
								end if;
							when up2 =>
								if counter > 0 then 
									next_state <= up2;
									counter <= counter -1;
								else
									ObjectStartY_t  <= ObjectStartY_t-30;
									counter <= 5000000;
									next_state <= up3;
								end if;
							when up3 =>
								if counter > 0 then 
									next_state <= up3;
									counter <= counter -1;
								else
									ObjectStartY_t  <= ObjectStartY_t-10;
									counter <= 5000000;
									next_state <= down1;
								end if;
							when down1 =>
								if counter > 0 then 
									next_state <= down1;
									counter <= counter -1;
								else
									ObjectStartY_t  <= ObjectStartY_t+10;
									counter <= 5000000;
									next_state <= stop;
								end if;	
							when stop =>
								ObjectStartY_t  <= ObjectStartY_t;
								counter <= 5000000;
								next_state <= stop;		
							when others =>
								ObjectStartY_t  <= ObjectStartY_t;
								counter <= 5000000;
								next_state <= idle;		
							end case;
							wasC <= '1';
					end if;
					if objectStartX_t < 60 then
						if counter > 0 then
						counter <= counter -1;
						else 
							wasC <= '0';
							drawrequest <= '0';
							counter<= 5000000;
							ObjectStartX_t	<= obstcale_location+28;
							ObjectStartY_t	<=  obstcale_hight;
							next_state <= idle;
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