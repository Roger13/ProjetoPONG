library ieee;
library projetopong;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use projetopong.pongPack.all;

entity display_ctrl is
-- data, score, CLOCK_27, red, green, blue, hsync, vsync 
	port
	(
		-- Input ports
		data	: in  int_array ;
		score	: in std_logic_vector(7 downto 0) ;
		CLOCK_27	: in STD_LOGIC_VECTOR (1 downto 0);	--	27 MHz
		
		-- Output ports
		red, green, blue : out std_logic_vector(3 downto 0) ;
        hsync, vsync : out std_logic ;
        HEX0,HEX1,HEX2,HEX3 : out std_logic_vector(6 downto 0)
	);
end display_ctrl;

architecture behavior of display_ctrl is
	signal rstn : std_logic;              -- reset active low para nossos
                                        -- circuitos sequenciais.

	-- Interface com a memória de vídeo do controlador

	signal we : std_logic;                        -- write enable ('1' p/ escrita)
	signal addr : integer range 0 to 12287;       -- endereco mem. vga
	signal pixel : std_logic_vector(2 downto 0);  -- valor de cor do pixel
	signal pixel_bit : std_logic;                 -- um bit do vetor acima
  
	signal corTemp : std_logic_vector(2 downto 0); -- ARMAZENA A COR A SER ATRIBUIDA AO PIXEL!

	-- Sinais dos contadores de linhas e colunas utilizados para percorrer
	-- as posições da memória de vídeo (pixels) no momento de construir um quadro.
  
	signal line : integer range 0 to 95;  -- linha atual
	signal col : integer range 0 to 127;  -- coluna atual

	signal col_rstn : std_logic;          -- reset do contador de colunas
	signal col_enable : std_logic;        -- enable do contador de colunas

	signal line_rstn : std_logic;          -- reset do contador de linhas
	signal line_enable : std_logic;        -- enable do contador de linhas

	signal fim_escrita : std_logic;       -- '1' quando um quadro terminou de ser
                                        -- escrito na memória de vídeo

begin
	
	player1_p : conv_7seg port map (
		score(3 downto 0),  HEX0
	);
	
	player2_p : conv_7seg port map (
		score(7 downto 4),  HEX2
	);
	
	HEX1 <= "1111111";
	HEX3 <= "1111111";
	
	vga_controller: vgacon port map (
		clk27M       => CLOCK_27(0),
		rstn         => '1',
		red          => red,
		green        => green,
		blue         => blue,
		hsync        => hsync,
		vsync        => vsync,
		write_clk    => CLOCK_27(0),
		write_enable => we,
		write_addr   => addr,
		data_in      => pixel);
	
  -- purpose: Este processo conta o número da coluna atual, quando habilitado
  --          pelo sinal "col_enable".
  -- type   : sequential
  -- inputs : clk27M, col_rstn
  -- outputs: col
  conta_coluna: process (CLOCK_27(0), col_rstn)
  begin  -- process conta_coluna
	if col_rstn = '0' then                  -- asynchronous reset (active low)
	  col <= 0;
	elsif CLOCK_27(0)'event and CLOCK_27(0) = '1' then  -- rising clock edge
	  if col_enable = '1' then
		if col = 127 then               -- conta de 0 a 127 (128 colunas)
		  col <= 0;
		else
		  col <= col + 1;  
		end if;
	  end if;
	end if;
  end process conta_coluna;
	
  -- purpose: Este processo conta o número da linha atual, quando habilitado
  --          pelo sinal "line_enable".
  -- type   : sequential
  -- inputs : clk27M, line_rstn
  -- outputs: line
  conta_linha: process (CLOCK_27(0), line_rstn)
  begin  -- process conta_linha
	if line_rstn = '0' then                  -- asynchronous reset (active low)
	  line <= 0;
	elsif CLOCK_27(0)'event and CLOCK_27(0) = '1' then  -- rising clock edge
	  -- o contador de linha só incrementa quando o contador de colunas
	  -- chegou ao fim (valor 127)
	  if line_enable = '1' and col = 127 then
		if line = 95 then               -- conta de 0 a 95 (96 linhas)
		  line <= 0;
		else
		  line <= line + 1;  
		end if;        
	  end if;
	end if;
  end process conta_linha;

  -- Este sinal é útil para informar nossa lógica de controle quando
  -- o quadro terminou de ser escrito na memória de vídeo, para que
  -- possamos avançar para o próximo estado.
  fim_escrita <= '1' when (line = 95) and (col = 127)
				 else '0';

end behavior;
