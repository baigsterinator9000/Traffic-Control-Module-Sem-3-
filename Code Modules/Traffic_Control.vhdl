----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:58:46 05/24/2016 
-- Design Name: 
-- Module Name:    Traffic_controller_module - Behavioral 
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

entity Traffic_controller_module is
    Port (
			  CarEW : in  STD_LOGIC;--from the board
           CarNS : in  STD_LOGIC;--from the board
           PedNS_clr : out  STD_LOGIC;--used in the pedestrian_module
           PedEW_clr : out  STD_LOGIC;--used in the pedestrian_module
           PedEW_mem : in  STD_LOGIC;--used in the pedestrian_module
           PedNS_mem : in  STD_LOGIC;--used in the pedestrian_module
           Clock : in  STD_LOGIC;--from the board
           Reset : in  STD_LOGIC;--from the board
			  Countin : in  STD_LOGIC_VECTOR (3 downto 0);-- check in delay
			  Trigger : out  STD_LOGIC; --activate one_second_pulser, delay_module
			  StartCount : out  STD_LOGIC; --start countdown
           LightsEW : out  STD_LOGIC_VECTOR (1 downto 0);--Lights of east-west
           LightsNS : out  STD_LOGIC_VECTOR (1 downto 0));--Lights of north south
end Traffic_controller_module;

	architecture Behavioral of Traffic_controller_module is

--setting constants 
constant Red:std_logic_vector (1 downto 0):="00";
constant Amber:std_logic_vector(1 downto 0):="01";
constant Green:std_logic_vector(1 downto 0):="10";
constant PedGreen:std_logic_vector(1 downto 0):="11";

type Statetype is (CarEW_Green, EWDelay, CarEW_Amber, CarEW_Red, CarNS_Green_min, PedEW_Green,
						 CarNS_Green, NSDelay, CarNS_Amber, CarNS_Red, PedNS_Green, CarEW_Green_min);
						 
signal state, nextstate: Statetype;

begin
SynchronousProcess:
Process(Reset, Clock)--the two inputs

begin
if(Reset='1') then--- when the reset button is pressed
	state<=CarEW_Green;---initial state will be in  East West car
elsif rising_edge(Clock) then---at presence of  the rising edge of the clock
	state<=nextstate;---the current state will move to the next state
end if;
end process SynchronousProcess;

CombinationalProcess: ---Traffic control Logic
process(state, CarEW, CarNS, PedNS_mem, PedEW_mem,Countin)---countin is from the delay module

begin

	--Default values to prevent latches
	
	nextstate<=CarEW_Green;---the state will be in CarEW_Green state initially
	LightsEW<=Green;---East West light will be green initially
	LightsNS<=Red;---North South light will be red initially
	PedNS_clr<='0'; 
	PedEW_clr<='0';
	Trigger<='0'; --- there is no trigger 
	Startcount<='0';---the count is 0 initially
	
case state is	
		when CarEW_Green=>---initial state of the state machine
			LightsEW<=Green;---East West light will be  green 
			LightsNS<=Red;---North South light will be red
			PedNS_clr<='0';
			PedEW_clr<='0';
			Trigger<='0';---there is no trigger 
			Startcount<='0';---the count is 0 
			if(CarNS='1' or PedNS_mem='1'  ) then--NSpedestrian button is pressed/EW_pedestrian  is pressed
				nextstate<=EWDElay;---state will move to the EWDElay state 
				elsif(PedEW_mem='1')then
				nextstate<=PedEW_Green;---state will move onto next state which is PedEW_Green
				else
				nextstate<=CarEW_Green;---if not the state will remain at CarEW_Green
			end if;
			
		When EWDelay=>
			LightsEW<=Green;---East West light will be  green 
			LightsNS<=Red;---North South light will be red
			PedNS_clr<='0';
			PedEW_clr<='0';
			Trigger<='1';---when the presence of the trigger 
			Startcount<='1';---counting begins
			if(Countin ="1000") then---if  count in is 8	  
				Trigger<='0';---trigger will become 0
				Startcount<='0';---counter will be stopped 
				nextstate<= CarEW_Amber;---the state will move to the next state CarEW_Amber
				else
				nextstate<=EWDelay;---if not the state will remain at EWDelay
		end if;
		
		when CarEW_Amber=>---after the EWDelay moves to the next state CarEW_Amber
			LightsEW<=Amber;---East West light is amber 
			LightsNS<=Red;----North South light is red
			PedNS_clr<='0';
			PedEW_clr<='0';
			StartCount<='0';---the count is 0 initially
			Trigger<='1';---when the presence of the trigger 
			if(Countin="0011") then---if it has counted 3
				Trigger<='0';---trigger will become 0
				nextstate<=CarEW_Red;---the state will move to the CarEW_Red state 
			else
				nextstate<=CarEW_Amber;---if not the state will remain at CarEW_Amber
			end if;

 
		when CarEW_Red=>---after the CarEW_Amber. moves to the EWcar red light
			LightsEW<=Red;---East West light is red
			LightsNS<=Red;---North South light is red
			PedNS_clr<='0';
			PedEW_clr<='0';
			StartCount<='0';---the count is 0 initially
			Trigger<='1';---when the presence of the trigger 
			if(Countin="0100" ) then---if it has counted 4	
				Trigger<='0';---trigger will become 0
				if(PedNS_mem='1') then-- if pedNS is detected
					nextstate<=PedNS_Green;---the state will move to the next state PedNS_Green
				else
					Trigger<='0';---trigger will become 0
					nextstate<=CarNS_Green_min;---the state will move to the next state CarNS_Green_min
				end if;
				
			else 
				nextstate<=CarEW_Red;---if not the state will remain at CarEW_Red 
			end if;
			
		when CarNS_Green_min=>---after East West car red light
			LightsEW<=Red;---East West light will be red
			LightsNS<=Green;----North South light will be green
			PedNS_clr<='0';
			PedEW_clr<='0';
			StartCount<='0';---the count is 0 initially
			Trigger<='1';---when the presence of the trigger
			if(Countin="1000") then---if it has counted 8
				Trigger<='0';---trigger will become 0
				nextstate<=CarNS_Green;---the state will move to the next state CarNS_Green
				
			else
				nextstate<=CarNS_Green_min;---if not the state will remain at CarNS_Green_min
			end if;
			
		when PedNS_Green=>---after CarEW_Red moves to PedNS_Green
			LightsNS<=PedGreen;---North South light turns green for the pedestrians + East West light will be green
			LightsEW<=Red;---East West light will be red
			PedNS_clr<='0';
			PedEW_clr<='0';
			StartCount<='0';---the count is 0 initially
			Trigger<='1';---when the presence of the trigger
			if(Countin="1001") then---if it has counted 9
				PedNS_clr<='1';----pedestrian memory is cleared
				Trigger<='0';---trigger will become 0
				nextstate<=CarNS_Green;---the state will move to the next state CarNS_Green
			else
				nextstate<=PedNS_Green;---if not the state will remain at PedNS_Green
			end if;
		
		when CarNS_Green=>----after PedNS_Green state /PedNS_Green_min
			LightsNS<=Green;---North South light will be  green 
			LightsEW<=Red;---East West light will be red
			PedNS_clr<='0';
			PedEW_clr<='0';
			Trigger<='0';---trigger is  0
			Startcount<='0';---the count is 0 
			if(CarEW='1' or PedEW_mem='1'  ) then--EWpedestrian button is pressed/CarEW button is pressed
				nextstate<=NSDElay;---state will move to the NSDElay state 
			elsif(PedNS_mem='1')then
				nextstate<=PedNS_Green;---the state will move to the next state PedNS_Green
			else
				nextstate<=CarNS_Green;--if not the state will remain at CarNS_Green
			end if;
			
		When NSDelay=>----after carNS_Green state 
			LightsEW<=Red;---East West light will be  red 
			LightsNS<=Green;---North South light will be Green
			PedNS_clr<='0';
			PedEW_clr<='0';
			Trigger<='1';---when the presence of the trigger
			Startcount<='1';---count has started 
			if(Countin ="1000") then---if it has counted 8	
				Trigger<='0';---trigger will become 0
				nextstate<= CarNS_Amber;---the state will move to the next state CarNS_Amber
		else
			nextstate<=NSDelay;---if not the state will remain at NSDelay
		end if;
		
		when CarNS_Amber=>---after the NSDelay moves to CarNS_Amber
			LightsNS<=Amber;---North South light will be amber 
			LightsEW<=Red;----East West light will be red
			PedNS_clr<='0';
			PedEW_clr<='0';
			StartCount<='0';---the count is 0 
			Trigger<='1';---when the presence of the trigger
			if(Countin="0011") then---if it has counted 3
				Trigger<='0';---trigger will become 0
				nextstate<=CarNS_Red;---the state will move to the next state CarNS_Red
			else
				nextstate<=CarNS_Amber;---if not the state will remain at CarNS_Amber
			end if;

		when CarNS_Red=>---after CarNS_Amber moves to CarNS_Red
			LightsEW<=Red;---East West light will be red
			LightsNS<=Red;----North South light will be red
			PedNS_clr<='0';
			PedEW_clr<='0';
			StartCount<='0';---the count is 0 
			Trigger<='1';---when the presence of the trigger
			if(Countin="0100" ) then---if it has counted 4
				Trigger<='0';---trigger will become 0
				if(PedEW_mem='1')then --- if PedEW button is pressed
					nextstate<=PedEW_Green;---the state will move to the next state PedEW_Green
				else 
					Trigger<='0';---trigger will become 0
					nextstate<=CarEW_Green_min;---the state will move to the next state CarEW_Green_min
				end if;
			else 
				nextstate<=CarNS_Red;---if not the state will remain at CarNS_Red
			end if;
			
		when CarEW_Green_min=>---after PedNS_Green moves to CarEW_Green_min
				LightsEW<=Green;---East West light is green
				LightsNS<=Red;---North South light is red
				PedNS_clr<='0';
				PedEW_clr<='0';
				StartCount<='0';---the count is 0 
				Trigger<='1';---when the presence of the trigger
				
			if(Countin="1000") then---if it has counted 8
				Trigger<='0';---trigger will become 0
				nextstate<=CarEW_Green;---the state will move to the next state CarEW_Green(initial state)
			else
				nextstate<=CarEW_Green_min;---if not the state will remain at CarEW_Green_min
			end if;	
		
		when PedEW_Green=>---after CarNS_Red  moves to PedNS_Green
			LightsEW<=PedGreen;---North South light + pedestrian light will be  green 
			LightsNS<=Red;---East West light will be red
			PedNS_clr<='0';
			PedEW_clr<='0';
			StartCount<='0';---the count is 0 
			Trigger<='1';---when the presence of the trigger
			if(Countin="1001") then---if it has counted 9
				PedEW_clr<='1';----pedestrianW memory is cleared
				Trigger<='0';---trigger will become 0
				nextstate<=CarEW_Green;---the state will move to the next state CarEW_Green
			else
				nextstate<=PedEW_Green;---if not the state will remain at PedNS_Green
			end if;
			
	end case;
	
end process CombinationalProcess;
			

end Behavioral;


