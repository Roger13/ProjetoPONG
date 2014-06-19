library ieee;
library projetopong;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use projetopong.pongPack.all;

entity game_eng is
	port ( players	: in STD_LOGIC_VECTOR (3 downto 0);	--	teclas precionados (p1 UP, p1 DOWN, p2 UP, p2 DOWN)
		   rstn	: in STD_LOGIC;
		   space : in STD_LOGIC;
           data : inout int_array;
           score : std_logic_vector(7 downto 0);
           clk : in STD_LOGIC);
end game_eng;

architecture behaviour of game_eng is

	signal contador : integer range 0 to 270000 - 1;  -- contador
	signal tick : std_logic;
	
begin
  
  player1: process (tick)
  begin
	if tick'event and tick = '1' then
		if (players(0) = '1' and players(1) = '0' and data(0) > 0 ) then
			data(0) <= data(0) - 1;
		elsif (players(0) = '0' and players(1) = '1' and data(0) < 76) then
			data(0) <= data(0) + 1;
		end if;
	end if;
  end process player1;

  player2: process (tick)
  begin
	if tick'event and tick = '1' then
		if (players(2) = '1' and players(3) = '0' and data(1) > 0 ) then
			data(1) <= data(1) - 1;
		elsif (players(2) = '0' and players(3) = '1' and data(1) < 76) then
			data(1) <= data(1) + 1;
		end if;
	end if;
  end process player2;
  
  
  	
  p_contador: process (clk)
  begin  -- process p_contador
    if clk'event and clk = '1' then  -- rising clock edge       
        if contador = 270000 - 1 then
          contador <= 0;
          tick <= '1';
        else
          contador <=  contador + 1;        
		  tick <= '0';	
        end if;
    end if;
  end process p_contador;



end behaviour;