library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

package pongPack is

    type int_array is array(0 to 3) of integer;
     
	COMPONENT conv_7seg	
		PORT (input: IN STD_LOGIC_VECTOR(3 DOWNTO 0) ;
		  output: OUT STD_LOGIC_VECTOR(6 DOWNTO 0) ) ;
	END COMPONENT ;
     
    COMPONENT vgacon
		port (clk27M, rstn              : in  std_logic;
			write_clk, write_enable   : in  std_logic;
			write_addr                : in  integer range 0 to 128 * 96 - 1;
			data_in                   : in  std_logic_vector(2 downto 0);
			vga_clk                   : buffer std_logic;       -- Ideally 25.175 MHz
			red, green, blue          : out std_logic_vector(3 downto 0);
			hsync, vsync              : out std_logic);
	END COMPONENT ;
    
    COMPONENT display_ctrl
		port(data	: in  int_array ;
		score	: in std_logic_vector(7 downto 0) ;
		clk27M	: in STD_LOGIC;	--	27 MHz
		red, green, blue : out std_logic_vector(3 downto 0) ;
        hsync, vsync : out std_logic ;
        HEX0,HEX1,HEX2,HEX3 : out std_logic_vector(6 downto 0));
	END COMPONENT ;
	
	COMPONENT game_eng
		port ( players	: in STD_LOGIC_VECTOR (3 downto 0);	--	teclas precionados (p1 UP, p1 DOWN, p2 UP, p2 DOWN)
		   rstn	: in STD_LOGIC;
		   space : in STD_LOGIC;
   	       data : inout int_array;
           score : std_logic_vector(7 downto 0);
           clk : in STD_LOGIC);
	END COMPONENT ;
	
	COMPONENT player_ctrl
		port ( 
		   key_on : in STD_LOGIC_VECTOR(2 downto 0) ;
		   keys : in STD_LOGIC_VECTOR(47 downto 0) ;
		   players	: out STD_LOGIC_VECTOR (3 downto 0)	;--	teclas precionados (p1 UP, p1 DOWN, p2 UP, p2 DOWN)
		   space : out STD_LOGIC
		   );
	END COMPONENT ;
     
end package pongPack;
