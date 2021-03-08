library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.consts_pck.all;

-- Alex Grinshpun Apr 2017

entity objects_mux is
port 	(
		--////////////////////	Clock Input	 	////////////////////	 
		CLK	: in std_logic; --						//	27 MHz
		m_drawing_request : in std_logic;
		m_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	, -- a signal 
		
		b_drawing_request : in std_logic;
		b_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	, -- b signal 
		
		c1_drawing_request : in std_logic;
		c1_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	, -- b signal 
		c2_drawing_request : in std_logic;
		c2_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	, -- b signal 
		c3_drawing_request : in std_logic;
		c3_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	, -- b signal 
		
		cq_drawing_request : in std_logic;
		cq_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	, -- b signal 
		
		o_drawing_request : in std_logic;
		o_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	, -- b signal 
		o_hight		: in integer;
		
		o2_drawing_request : in std_logic;
		o2_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	, -- b signal 
		o2_hight		: in integer;		
				
		oe_drawing_request : in std_logic;
		oe_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	, -- b signal 
		
		o2e_drawing_request : in std_logic;
		o2e_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	, -- b signal 
		
		oq_drawing_request : in std_logic;
		oq_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	, -- b signal 
		
		p_drawing_request : in std_logic;
		p_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	, -- b signal 

		
		y_drawing_request : in std_logic;	
		y_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  -- y signal 
		
		l_drawing_request : in std_logic;	
		l_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  -- y signal 
		l1_drawing_request : in std_logic;	
		l1_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  -- y signal
		l2_drawing_request : in std_logic;	
		l2_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  -- y signal
				
		f_drawing_request : in std_logic;	
		f_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  -- y signal
		
		cl_drawing_request : in std_logic;	
		cl_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  -- y signal
		
		b2_drawing_request: in std_logic;
		b2_mvGA_RGB: in std_logic_vector(7 downto 0);
		b3_drawing_request: in std_logic;
		b3_mvGA_RGB: in std_logic_vector(7 downto 0);
		GO_drawing_request: in std_logic;		--GO=game over
		GO_mVGA_RGB : in std_logic_vector(7 downto 0);
		
				
		getEndCoin	: in std_logic; --added by yotam.
		
		

		m_mVGA_R 	: out std_logic_vector(9 downto 0); --	,  
		m_mVGA_G 	: out std_logic_vector(9 downto 0); --	, 
		m_mVGA_B 	: out std_logic_vector(9 downto 0); --	, 
		bombC		: out std_logic;
		life		: out integer range 0 to 5;
		score_ones	: out integer range 0 to 10;
		score_tens	: out integer range 0 to 10;
		coinC		: out std_logic;
		coin1		: out std_logic;
		coin2		: out std_logic;
		coin3		: out std_logic;
		obstacleC	: out std_logic;
		coinCq		: out std_logic;
		obstacleCq	: out std_logic;
		bomb_sound	:out std_logic;
		coin_sound	: out std_logic;
		bomb2C		: out std_logic;
		bomb3C		: out std_logic;
		pipeC		: out std_logic;
		game_enable	: out std_logic;
		obstacle_hight: out integer;
		
		
		RESETn : in std_logic

	);
end objects_mux;

architecture behav of objects_mux is 
signal m_mVGA_t 	: std_logic_vector(7 downto 0); --	,  
signal counter_s 	: integer ;
signal counter1_s 	: integer ;-- added by yotam.
signal life_s 	: integer range 0 to 5;
signal score_ones_s 	: integer range 0 to 10;
signal score_tens_s 	: integer range 0 to 10;
signal flag 		: std_logic;
signal bombC_s		: std_logic;
signal bomb2C_s		: std_logic;
signal bomb3C_s		: std_logic;
signal coinC_s		: std_logic;
signal coin1_s		: std_logic;
signal coin2_s		: std_logic;
signal coin3_s		: std_logic;
signal coinCq_s		: std_logic;
signal pipeC_s		: std_logic;

--signal VGA_CLK_t : std_logic;
--signal not_RESETn : std_logic;
--signal RESETn_tmp : std_logic;
--signal m_mVGA_R_t 	: std_logic_vector(2 downto 0); --	,  
--signal m_mVGA_G_t 	: std_logic_vector(2 downto 0); --	, 
--signal m_mVGA_B_t 	: std_logic_vector(1 downto 0); --	,
--signal  object1_draw_req : std_logic;
--signal  object2_draw_req : std_logic;
--
--signal b_mVGA_R 	: std_logic_vector(2 downto 0); --	,  
--signal b_mVGA_G 	: std_logic_vector(2 downto 0); --	, 
--signal b_mVGA_B 	: std_logic_vector(1 downto 0); --	,
--
--signal y_mVGA_R 	: std_logic_vector(2 downto 0); --	,  
--signal y_mVGA_G 	: std_logic_vector(2 downto 0); --	, 
--signal y_mVGA_B 	: std_logic_vector(1 downto 0); --	,


begin


-- priority encoder process

process ( RESETn, CLK)
variable bomb_sound_count: integer;
variable coin_sound_count: integer;
begin 
	if RESETn = '0' then
			m_mVGA_t	<=  (others => '0') ; 
			bombC <= '0';
			CoinC <= '0';
			coin1 <= '0';
			coin2 <= '0';
			coin3 <= '0';
			pipeC_s <= '0';
			pipeC <= '0';
			obstacleC <= '0';
			obstacleCq <= '0';
			life <= 0; -- add by yotam
			score_ones_s <= 0;
			score_tens_s <= 0;
			score_ones <= 0;
			score_tens <= 0;
			counter_s <= 0;
			life_s <= 0;
			bomb_sound<='0';
			coin_sound<='0';
			game_enable<='1';
			obstacle_hight<=0;
	elsif CLK'event and CLK='1' then
		if life_s>=3 then			-----
			game_enable<='0';		-----added by yaron
		end if;						-----
		if bomb_sound_count>0 then
			bomb_sound_count:=bomb_sound_count-1;
			bomb_sound<='1';
		else
			bomb_sound<='0';
		end if;
		if coin_sound_count>0 then
			coin_sound_count:=coin_sound_count-1;
			coin_sound<='1';
		else
			coin_sound<='0';
		end if;
		if counter_s > 0 then 
			counter_s <= counter_s -1;
			if counter_s = 1 then
				if bombC_s = '1' or bomb2C_s = '1' or bomb3C_s = '1'then
					life_s <= life_s + 1;
				end if;
				if coinC_s = '1' then 
					if score_ones_s<9 then
						score_ones_s <= score_ones_s + 1;
					else
						score_ones_s<=0;
						score_tens_s<=score_tens_s+1;
					end if;
				end if;
				if coinCq_s = '1' then 
					if score_ones_s<9 then
						score_ones_s <= score_ones_s + 1;
					else
						score_ones_s<=0;
						score_tens_s<=score_tens_s+1;
					end if;
				end if;
			end if;
		else
			bombC <= '0';
			bombC_s <= '0';
			bomb2C <= '0';
			bomb2C_s <= '0';
			bomb3C <= '0';
			bomb3C_s <= '0';
			coinC_s <= '0';
			coinC <= '0';
			coinCq_s <= '0';
			coinCq <= '0';
			pipeC <= '0';
			pipeC_s <= '0';
			life <= life_s;
			score_ones <= score_ones_s;
			score_tens <= score_tens_s;
			if coin1_s = '1' and coin2_s = '1' and  coin3_s = '1' then
				if counter1_s >0 then
					counter1_s <= counter1_s-1;
				else
					coin1 <= '0';
					coin1_s <= '0';
					coin2 <= '0';
					coin2_s <= '0';
					coin3 <= '0';
					coin3_s <= '0';
				end if;
			elsif getEndCoin = '1' then
					coin1 <= '0';
					coin1_s <= '0';
					coin2 <= '0';
					coin2_s <= '0';
					coin3 <= '0';
					coin3_s <= '0';
			end if;
		end if;
		if (m_drawing_request = '1' and b_drawing_request = '1') then --add by yotam
			bombC <= '1';
			bombC_s <= '1';
			counter_s <= 500000;
			bomb_sound_count:= bomb_sound_length;
		end if;
		if (m_drawing_request = '1' and b2_drawing_request = '1') then --add by yotam
			bomb2C <= '1';
			bomb2C_s <= '1';
			counter_s <= 500000;
			bomb_sound_count:= bomb_sound_length;
		end if;
		if (m_drawing_request = '1' and b3_drawing_request = '1') then --add by yotam
			bomb3C <= '1';
			bomb3C_s <= '1';
			counter_s <= 500000;
			bomb_sound_count:= bomb_sound_length;
		end if;
		if ( m_drawing_request = '1' and (c1_drawing_request = '1')) then --rechange by yotam.
			coin1 <= '1';
			coin1_s <= '1';
			coinC <= '1';
			coinC_s <= '1';
			counter_s <= 500000;
			counter1_s <= 500000;
			coin_sound_count:= coin_sound_length;
		end if;
		if ( m_drawing_request = '1' and (c2_drawing_request = '1')) then --rechange by yotam.
			coin2 <= '1';
			coin2_s <= '1';
			coinC <= '1';
			coinC_s <= '1';
			counter_s <= 500000;
			counter1_s <= 500000;
			coin_sound_count:= coin_sound_length;
		end if;
		if ( m_drawing_request = '1' and (c3_drawing_request = '1')) then --rechange by yotam.
			coin3 <= '1';
			coin3_s <= '1';
			coinC <= '1';
			coinC_s <= '1';
			counter_s <= 500000;
			counter1_s <= 500000;
			coin_sound_count:= coin_sound_length;
		end if;
		if ( m_drawing_request = '1' and cq_drawing_request = '1') then
			coinCq <= '1';
			coinCq_s <= '1';
			counter_s <= 500000;
			coin_sound_count:= coin_sound_length;
		end if;
		if (m_drawing_request = '1' and p_drawing_request = '1') then --add by yotam
			pipeC <= '1';
			pipeC_s <= '1';
			counter_s <= 500000;
		end if;
		--if ( m_drawing_request = '1' and  o_drawing_request = '1') then 		-----deleted by yaron
			--obstacleC <= '1';
		--end if;

		
		if GO_drawing_request='1' and life_s>=3 then	-----
			m_mVGA_t <= GO_mVGA_RGB;				-----added by yaron
		elsif (m_drawing_request = '1' ) then  
		--if (m_drawing_request = '1' ) then  
			if life_s<3 then							------
				m_mVGA_t <= m_mVGA_RGB;					------added by yaron
			end if;										------
			--m_mVGA_t <= m_mVGA_RGB;
			if o_drawing_request='1' then					-----
				obstacleC<='1';		-----
				obstacle_hight<=o_hight;
			elsif o2_drawing_request='1' then 
				obstacleC<='1';
				obstacle_hight<=o2_hight;
			--else											-----added by yaron
			--	obstacleC<='0';								-----
			--end if;
			--if o2_drawing_request='1' then					-----
			--	obstacleC<='1';		-----
			--	obstacle_hight<=o2_hight;
			else											-----added by yaron
				obstacleC<='0';								-----
			end if;
			if oq_drawing_request = '1' then-- edded by yotam
					obstacleCq <= '1';
				else
					obstacleCq <= '0';
			end if;		
		elsif (oq_drawing_request = '1' ) then  
			m_mVGA_t <= oq_mVGA_RGB;			
		elsif (oe_drawing_request = '1' ) then  
			m_mVGA_t <= oe_mVGA_RGB;	
		elsif (o2e_drawing_request = '1' ) then  
			m_mVGA_t <= o2e_mVGA_RGB;	
		elsif (p_drawing_request = '1' ) then  
			m_mVGA_t <= p_mVGA_RGB;											-----
		elsif (b_drawing_request = '1' ) then  
			m_mVGA_t <= b_mVGA_RGB;
		elsif b2_drawing_request ='1' then 
			m_mVGA_t<=b2_mvGA_RGB;
		elsif b3_drawing_request ='1' then 
			m_mVGA_t<=b3_mvGA_RGB;
		elsif (c1_drawing_request = '1' ) then  
			m_mVGA_t <= c1_mVGA_RGB;
		elsif (c2_drawing_request = '1' ) then  
			m_mVGA_t <= c2_mVGA_RGB;
		elsif (c3_drawing_request = '1' ) then  
			m_mVGA_t <= c3_mVGA_RGB;
		elsif (cq_drawing_request = '1' ) then  
			m_mVGA_t <= cq_mVGA_RGB;
		elsif (l_drawing_request = '1' ) then  
			m_mVGA_t <= l_mVGA_RGB;
		elsif (l1_drawing_request = '1' ) then  
			m_mVGA_t <= l1_mVGA_RGB;
		elsif (l2_drawing_request = '1' ) then  
			m_mVGA_t <= l2_mVGA_RGB;
		elsif f_drawing_request = '1' then
			m_mVGA_t <= f_mVGA_RGB ;
		
		else
			--if (o_drawing_request = '1' ) then  
				--m_mVGA_t <= o_mVGA_RGB;
			--elsif
			if (cl_drawing_request = '1' ) then  
				m_mVGA_t <= cl_mVGA_RGB;
			else
				m_mVGA_t <= y_mVGA_RGB ;
			end if;
		end if; 

	end if ; 

end process ;

m_mVGA_R	<= m_mVGA_t(7 downto 5)& "0000000"; -- expand to 10 bits 
m_mVGA_G	<= m_mVGA_t(4 downto 2)& "0000000";
m_mVGA_B	<= m_mVGA_t(1 downto 0)& "00000000";


end behav;