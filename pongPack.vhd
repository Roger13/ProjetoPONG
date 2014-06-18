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
    
     
end package pongPack;
