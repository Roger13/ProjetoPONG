library ieee;
library projetopong;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use projetopong.pongPack.all;

entity PONG is
	port ( CLOCK_24	: in STD_LOGIC_VECTOR (1 downto 0);	--	24 MHz
		   clk27M	: in STD_LOGIC;	--	27 MHz
		   CLOCK_50	: in STD_LOGIC;	--	50 MHz
           KEY : in std_logic_vector (3 downto 0) ; -- Bot�o de reset (KEY(0))
           red, green, blue : out std_logic_vector(3 downto 0) ;
           hsync, vsync : out std_logic ; 
           PS2_DAT : inout std_logic ;	-- PS2 Data (keyboard)
		   PS2_CLK : inout std_logic ;	-- PS2 Clock (keyboard)	
		   HEX0,HEX1,HEX2,HEX3 : out std_logic_vector(6 downto 0));
end PONG;

architecture behaviour of PONG is

	component kbdex_ctrl
		generic(
			clkfreq : integer
		);
		port(
			ps2_data	:	inout	std_logic;
			ps2_clk		:	inout	std_logic;
			clk				:	in 	std_logic;
			en				:	in 	std_logic;
			resetn		:	in 	std_logic;
			lights		: in	std_logic_vector(2 downto 0); -- lights(Caps, Nun, Scroll)		
			key_on		:	out	std_logic_vector(2 downto 0);
			key_code	:	out	std_logic_vector(47 downto 0)
		);
	end component;
		
	signal data : int_array; -- armazena posi��es (player1_y, player2_y, bola_x, bola_y) e 						 
	signal score : std_logic_vector(7 downto 0); -- pontua��o (player1_p, player2_p) respectivamente.
	
	signal keys : std_logic_vector(47 downto 0);
	signal key_on : std_logic_vector(2 downto 0);

	signal players : std_logic_vector(3 downto 0); 
	signal space : std_logic; 

begin
	
	-- kbdex_ctrl respons�vel pelo input de teclado
	kbd_ctrl : kbdex_ctrl generic map(24000) port map(
		PS2_DAT, PS2_CLK, clk27M, '1', '1', "111",
		key_on, key_code(47 downto 0) => keys );
	
	-- player_ctrl recebe os bot�es pressionados e converte para dados dos respectivos players 
	   plys_ctrl : player_ctrl port map(
		key_on, keys, players, space
	  );
	
	-- game_eng recebe os dados dos players e atualiza as posi��es e pontua��es do jogo
	  engine : game_eng port map(
	  	players, KEY(2), space, data, score, clk27M
	  );
	
	-- display_ctrl recebe as posi��es dos objetos a serem exibidos e monta as representa��es
	-- (display_ctrl engloba o output driver!)
	display : display_ctrl port map(	
		data, score, clk27M, red, green, blue, hsync, vsync ,HEX0, HEX1, HEX2, HEX3
	);
		
end behaviour;
