library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity PONG is
	port ( CLOCK_24	: in STD_LOGIC_VECTOR (1 downto 0);	--	24 MHz
		   CLOCK_27	: in STD_LOGIC_VECTOR (1 downto 0);	--	27 MHz
		   CLOCK_50	: in STD_LOGIC;	--	50 MHz
           SW : in std_logic_vector (9 downto 0) ; -- Botão de reset (SW[0])
           red, green, blue : out std_logic_vector(3 downto 0) ;
           hsync, vsync : out std_logic ; 
           PS2_DAT : inout std_logic ;	-- PS2 Data (keyboard)
		   PS2_CLK : inout std_logic );	-- PS2 Clock (keyboard)	
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
	
	type int_array is array(0 to 5) of integer; 
	
	signal data : int array; -- armazena posições (player1_y, player2_y, bola_x, bola_y) e 
							 -- pontuação (player1_p, player2_p) respectivamente.
	
	signal key0 : std_logic_vector(15 downto 0);
	signal key_on : std_logic_vector(2 downto 0);

	signal players : std_logic_vector(3 downto 0);  

begin
	
	-- kbdex_ctrl responsável pelo input de teclado
	kbd_ctrl : kbdex_ctrl generic map(24000) port map(
		PS2_DAT, PS2_CLK, CLOCK_24(0), KEY(1), SW(0), "000",
		key_on, key_code(15 downto 0) => key0 );
	
	-- player_ctrl recebe os botões pressionados e converte para dados dos respectivos players 
	players : player_ctrl port map(
		key0, players
	);
	
	-- game_eng recebe os dados dos players e atualiza as posições e pontuações do jogo
	engine : game_eng port map(
		players, SW(0), key0, data, CLOCK_27
	);
	
	-- display_ctrl recebe as posições dos objetos a serem exibidos e monta as representações
	-- (display_ctrl engloba o output driver!)
	display : display_ctrl port map(	
		data, CLOCK_27, red, green, blue, hsync, vsync 
	);
		
end behaviour;
