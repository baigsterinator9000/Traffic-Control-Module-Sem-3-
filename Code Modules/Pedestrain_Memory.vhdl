----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:36:50 05/24/2016 
-- Design Name: 
-- Module Name:    pedestrian_module - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pedestrian_module is
    Port ( Clock : in  STD_LOGIC;
			  Reset: in STD_LOGIC;
           PedEW : in  STD_LOGIC;
           PedNS : in  STD_LOGIC;
			  PedNS_clr :in STD_LOGIC; --to clear pedestrian NS memory
			  PedEW_clr :in STD_LOGIC;  --to clear pedestrian EW memory
           PedEW_mem : out  STD_LOGIC;-- pedestrian EW  memory
           PedNS_mem : out  STD_LOGIC);-- pedestrian NS memory
end pedestrian_module;

architecture Behavioral of pedestrian_module is

begin

PedButtonHold:Process(Clock,Reset)
begin
if (Reset='1') then -- pedestrian memories are cleared if reset is pressed
	PedEW_mem<='0'; -- pedestrian EW memory is zero
	PedNS_mem<='0'; -- pedestrian NS memory is zero
	
elsif (rising_edge(Clock)) then

		if(PedEW_clr='1') then -- pedestrian EW clear is one
			PedEW_mem<='0';	-- make pedestrian EW memory clear
		elsif (PedEW='1') then -- if EW pedestrian button is pressed
			PedEW_mem<='1';	-- store in pedestrian EW memory 
		end if;
		
		if (PedNS_clr='1') then	-- pedestrian NS clear is one
			PedNS_mem<='0';		-- make pedestrian NS memory clear
		elsif (PedNS='1') then -- if NS pedestrian button is pressed
			PedNS_mem<='1';	-- store in pedestrian NS memory 
		end if;
end if;

end process PedButtonHold;


end Behavioral;
