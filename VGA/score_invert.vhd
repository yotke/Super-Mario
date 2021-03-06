
LIBRARY ieee;
USE ieee.std_logic_1164.all;


--  Entity Declaration

ENTITY score_invert IS
	GENERIC(Div : integer range 0 to 50000000 := 5);
	PORT
	(
		Clk_in : IN STD_LOGIC;
		score_int: integer range 0 to 10;
		Resetn : IN STD_LOGIC;
		score_bin	:out std_logic_vector (3 downto 0)
		
	);
	
END score_invert;


--  Architecture Body

ARCHITECTURE Clk_Divider_architecture OF score_invert IS
	
	

	
BEGIN


	process(Clk_in,Resetn)
		begin
			if (Resetn = '0') then
				score_bin	<=	"0000";
				
			elsif (Clk_in = '1' and Clk_in'event) then
				case score_int is 
					when 0 => score_bin<="0000";
					when 1 => score_bin<="0001";
					when 2 => score_bin<="0010";
					when 3 => score_bin<="0011";
					when 4 => score_bin<="0100";
					when 5 => score_bin<="0101";
					when 6 => score_bin<="0110";
					when 7 => score_bin<="0111";
					when 8 => score_bin<="1000";
					when 9 => score_bin<="1001";
					when others => score_bin<="0000";
				end case;
			end if;
	end process;
	
			

	

END Clk_Divider_architecture;
