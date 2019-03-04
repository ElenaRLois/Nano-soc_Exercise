-- Copyright (C) 2018  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "02/18/2019 00:13:37"
                                                            
-- Vhdl Test Bench template for design  :  small_peripheral
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY small_peripheral_vhd_tst IS
END small_peripheral_vhd_tst;
ARCHITECTURE small_peripheral_arch OF small_peripheral_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL AB_s : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL clk : STD_LOGIC := '0';
SIGNAL Din_s : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Dout_s : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL LED : STD_LOGIC;
SIGNAL RD_s : STD_LOGIC;
SIGNAL reset : STD_LOGIC;
SIGNAL SW_0 : STD_LOGIC;
SIGNAL SW_1 : STD_LOGIC;
SIGNAL WR_s : STD_LOGIC;
COMPONENT small_peripheral
	PORT (
	AB_s : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
	clk : IN STD_LOGIC;
	Din_s : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	Dout_s : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	LED : OUT STD_LOGIC;
	RD_s : IN STD_LOGIC;
	reset : IN STD_LOGIC;
	SW_0 : IN STD_LOGIC;
	SW_1 : IN STD_LOGIC;
	WR_s : IN STD_LOGIC
	);
END COMPONENT;

----------------    SIMULATION SIGNALS & VARIABLES    -------
	signal sim_clk   				: STD_LOGIC 	:= '0';
	signal sim_reset 				: STD_LOGIC 	:= '0';
	signal sim_trig  				: STD_LOGIC 	:= '0';
	shared variable edge_rise  : integer    	:= -1;
	shared variable edge_fall 	: integer    	:= -1;

BEGIN
	i1 : small_peripheral
	PORT MAP (
-- list connections between master ports and signals
	AB_s => AB_s,
	clk => clk,
	Din_s => Din_s,
	Dout_s => Dout_s,
	LED => LED,
	RD_s => RD_s,
	reset => reset,
	SW_0 => SW_0,
	SW_1 => SW_1,
	WR_s => WR_s
	);
clk 	<= sim_clk;

----------------    CLOCK PROCESS    ------------------------     
	simulation_clock : process
		-- repeat the counters edge_rise & edge_fall
		constant max_cycles    	: integer   := 140;
	begin
		-- set sim_clk signal
		sim_clk <= not(sim_clk);
		-- adjust 
		if (sim_clk = '0') then
			edge_rise := edge_rise + 1;
		else
			edge_fall := edge_fall + 1;
		end if;
		if( edge_fall = max_cycles ) then
			edge_rise := 0;
			edge_fall := 0;
		end if;  
		-- trigger the stimuli process
		wait for 0.05 ns;
		sim_trig <= not(sim_trig);
		-- wait until end of 1/2 period
		wait for 0.45 ns;
	end process simulation_clock;

stimuli : PROCESS(sim_trig)                                                                                 
BEGIN   
	if ( edge_rise = 0 ) then
		SW_0 <= '0';
		SW_1 <= '0';                                                    
		AB_s <= "000";
		Din_s <= "10000000000000000000000000000001";
		RD_s <= '0';
		reset <= '0';
		WR_s <= '1'; 
	end if; 
	
	if ( edge_rise = 1 ) then
		AB_s <= "001";
		Din_s <= "11000000000000000000000000000011"; 
	end if; 
	
	if ( edge_rise = 2 ) then
		AB_s <= "010"; 
		Din_s <= "11100000000000000000000000000111";
	end if; 
	
	if ( edge_rise = 3 ) then
		AB_s <= "011"; 
		Din_s <= "11110000000000000000000000001111";
	end if; 
	
	if ( edge_rise = 4 ) then
		AB_s <= "100"; 
		Din_s <= "11111000000000000000000000011111";
	end if; 
	
	if ( edge_rise = 5 ) then
		AB_s <= "000";
		RD_s <= '1';
		WR_s <= '0';
	end if; 
	
	if ( edge_rise = 6 ) then
		AB_s <= "001"; 
	end if; 
	
	if ( edge_rise = 7 ) then
		AB_s <= "010"; 
	end if; 
	
	if ( edge_rise = 8 ) then
		AB_s <= "011"; 
	end if; 
	
	if ( edge_rise = 9 ) then
		AB_s <= "100"; 
	end if; 
	
	if ( edge_rise = 10 ) then
		SW_0 <= '0';
		SW_1 <= '0'; 
	end if; 
	
	if ( edge_rise = 11 ) then
		SW_0 <= '0';
		SW_1 <= '1';   
	end if;                                                 
END PROCESS stimuli;                                                                          
END small_peripheral_arch;
