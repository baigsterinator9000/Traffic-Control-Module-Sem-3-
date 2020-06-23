----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:15:51 05/24/2016 
-- Design Name: 
-- Module Name:    Delay_module - Behavioral 
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

entity Delay_module is
    Port ( Countout : out  STD_LOGIC_VECTOR (3 downto 0);
           PulseIn : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
			  Trigger: in STD_LOGIC;
           Clock: in  STD_LOGIC);
end Delay_module;

	architecture Behavioral of Delay_module is
signal Count_i:STD_LOGIC_Vector(3 downto 0);  
signal PulseIn_i: STD_LOGIC; 
begin
	
Countout<=Count_i; 
PulseIn_i<=PulseIn;	
Process(Clock,Reset,PulseIn_i)
begin
if (Reset='1') then -- if reset button is pressed
	Count_i<="0000"; -- count is 0
elsif (rising_edge(Clock)) then --  in the rising edge of the clock
	if (PulseIn_i='1') then -- when the presence of  pulse 
		Count_i<=Count_i+"0001"; -- one count will be added to the current count
	elsif (Trigger = '0') then -- in the falling edge of the clock 
		Count_i<="0000"; -- count  is 0
	end if;
end if;
end process;
end Behavioral;
