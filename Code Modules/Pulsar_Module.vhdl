----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:19:08 05/24/2016 
-- Design Name: 
-- Module Name:    one_second_pulser - Behavioral 
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

entity one_second_pulser is             
    Port ( Reset : in  STD_LOGIC;
           Clock : in  STD_LOGIC;
			  Trigger : in  STD_LOGIC;
			  PulseOut: out STD_LOGIC);
end one_second_pulser;

architecture Behavioral of one_second_pulser is

signal count:std_logic_vector (9 downto 0);
begin
process(Reset,Clock)
begin

if (Reset='1') then-------when the reset button is pressed
	count<="0000000000";--------count will become 0
	PulseOut<='0';----------no pulse will is ouput
	
elsif (rising_edge(Clock)) then

	 if (Trigger='0') then --- if there is to trigger
		   count<="0000000000";--------count remains 0
			PulseOut<='0';-------  pulse wont  occur
			
	 elsif (count="1111101000") then-----in the presence of trigger(counter started counting) and if 1000 counts  occur( (1/1Khz) = 1ms*1000 = 1s ) 
			count<="0000000000";-------count will return to zero
			PulseOut<='1';------- 1 pulse will occur (equivalent to 1 second)
	  else
			count<=count+'1';-----in the presence of trigger(counter started counting) + there is not 1000 count ; 1 will be added to the current count
			PulseOut<='0';-----no pulse will occur
	  end if;
end if;

end process;

end Behavioral;

