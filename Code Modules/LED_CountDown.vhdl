----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:53:43 05/24/2016 
-- Design Name: 
-- Module Name:    LED_countdown_module - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LED_countdown_module is
    Port ( Reset : in  STD_LOGIC;
           Clock : in  STD_LOGIC;
           StartCount : in  STD_LOGIC;
			  Countin: in STD_LOGIC_VECTOR (3 downto 0);
           LEDs : out  STD_LOGIC_VECTOR (7 downto 0));
end LED_countdown_module;

architecture Behavioral of LED_countdown_module is


begin

process(Reset,Clock,Countin) ---countin is from the delay module
begin
if (Reset='1') then
	LEDs<="00000000"; -- --LED is onned fully
	
elsif rising_edge(Clock) then
	if StartCount='1' then
		
		case Countin is
		when "0000"=> 
				LEDs<="00000001";-- --value to show "8"
		when "0001"=> 
				LEDs<="00011111";-- --value to show "7"
		when "0010"=> 
				LEDs<="01000001";-- --value to show "6"
		when "0011"=> 
				LEDs<="01001001";	-- --value to show "5"	
		when "0100"=> 
				LEDs<="10011001";-- --value to show "4"
		when "0101"=> 
				LEDs<="00001101";-- --value to show "3"
		when "0110"=> 
				LEDs<="00100101";-- --value to show "2"
		when "0111"=> 
				LEDs<="10011111";-- --value to show "1"
		when "1000"=> 
				LEDs<="00000011";-- --value to show "0"		
		when others=>  
				LEDs<="11111111";-- -- for other values Turn off led
		end case;
		
	else
			LEDs<="11111111"; -- --Turn off led
	end if;
	
end if;

end process;

end Behavioral;

