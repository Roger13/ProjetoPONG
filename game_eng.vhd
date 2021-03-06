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
           score : inout std_logic_vector(7 downto 0);
           clk : in STD_LOGIC);
end game_eng;

architecture behaviour of game_eng is

	signal contador : integer range 0 to 270000 - 1;  -- contador
	signal contador2 : integer range 0 to 2700000 - 1;  -- contador
	signal tick, tick2 : std_logic;
	signal reset : std_logic := '0';
	signal moving : std_logic;
	signal ball_dir: std_logic_vector(1 downto 0); -- (1) = '0' baixo, (1) = '1' cima, (0) = '0' direita, (0) = '1' esquerda
	signal temp : integer;     -- sinal auxiliar. Por alguma raz�o, usar o data(2) na condicional fazia o player 2 ficar praticamente travado.
	signal temp2 : std_logic_vector(7 downto 0) ;
begin
  
  reset_process: process (tick)
  begin
	if tick'event and tick = '1' then
		if reset = '0' then
			reset <= '1';
		end if;
		temp2 <= score;
		if rstn = '0' then
			reset <= '0';
		end if;
	end if;
  end process reset_process;
  
  player1: process (tick)
  begin
	if tick'event and tick = '1' then
		if reset = '0' then
			data(0) <= 37;
		end if;
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
		if reset = '0' then
			data(1) <= 37;
		end if;
		if (players(2) = '1' and players(3) = '0' and data(1) > 0 ) then
			data(1) <= data(1) - 1;
		elsif (players(2) = '0' and players(3) = '1' and data(1) < 76) then
			data(1) <= data(1) + 1;
		end if;
	end if;
  end process player2;
  	
  ball_movement: process (tick)
  begin
	if tick'event and tick = '1' then
		if reset = '0' then
			data(2) <= 63;
			data(3) <= 47;
			moving <= '0';
			score <= "00000000";
		end if;
		
		if space = '1' then
			moving <= '1';
		end if;
		
		if moving = '1' then
			if ball_dir(0) = '0' then -- Movimento esquerda
				if data(2) = 127  then   -- ponto p2
					data(2) <= 63;
					data(3) <= 47;
					moving <= '0';
					score(7 downto 4) <= score(7 downto 4) + '1';
				elsif (data(2) = 119 and data(3) >= data(1) and data(3) < data(1) + 20) then
					ball_dir(0) <= '1';
				else
					data(2) <= data(2) + 1;
				end if;
			else					  -- Movimento direita
				if data(2) = 0 then    -- ponto p1
					data(2) <= 63;
					data(3) <= 47;
					moving <= '0';
					score(3 downto 0) <= score(3 downto 0) + '1';
				elsif (data(2) = 9 and data(3) >= data(0) and data(3) < data(0) + 20) then
					ball_dir(0) <= '0';
				else
					data(2) <= data(2) - 1;
				end if;
			end if;
			
			if ball_dir(1) = '0' then -- Movimento baixo
				if data(3) = 95  then
					ball_dir(1) <= '1';
				else
					data(3) <= data(3) + 1;
				end if;
			else					  -- Movimento cima
				if data(3) = 0 then
					ball_dir(1) <= '0';
				else
					data(3) <= data(3) - 1;
				end if;
			end if;
		end if;
	end if;
  end process ball_movement;
  	
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

  p_contador2: process (clk)
  begin  -- process p_contador
    if clk'event and clk = '1' then  -- rising clock edge       
        if contador2 = 2700000 - 1 then
          contador2 <= 0;
          tick2 <= '1';
        else
          contador2 <=  contador2 + 1;        
		  tick2 <= '0';	
        end if;
    end if;
  end process p_contador2;


end behaviour;