library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;

entity small_peripheral is
	port (
	
		-- Clock and reset.
		clk            : in STD_LOGIC;
		reset        	: in STD_LOGIC;
		  
		-- Communication with hps
		AB_s				: in STD_LOGIC_VECTOR(2 downto 0);
		Din_s				: in STD_LOGIC_VECTOR(31 downto 0);
		Dout_s			: out STD_LOGIC_VECTOR(31 downto 0);
		
		WR_s           : in STD_LOGIC;
		RD_s       		: in STD_LOGIC;
		
		-- External IO
		SW_0           : in STD_LOGIC;
		SW_1      		: in STD_LOGIC;
		LED      		: out STD_LOGIC
	);

end small_peripheral;

architecture arch of small_peripheral is

	-- Declare Chip Select component
	component chip_select
		port (
	
			-- Input address
			AB_s				: in STD_LOGIC_VECTOR(2 downto 0);
		
			-- Output enable signals
			cs					: out STD_LOGIC_VECTOR(4 downto 0)
		);
	end component;
	
	-- Declare Register Component (0-3)
	component generic_register
		generic (
			-- Configuration of the register
			bit_size : integer := 32
		
		);
		
		port (
			-- Clock and reset
			clk            : in STD_LOGIC;
			reset        	: in STD_LOGIC;
			
			-- Data ports
			Din_s				: in STD_LOGIC_VECTOR(bit_size - 1 downto 0);
			Dout_s			: out STD_LOGIC_VECTOR(bit_size - 1 downto 0);
			enable			: in STD_LOGIC
		);
	end component;
	
	-- Declare Register Component (4)
	component io_register
		generic (
			-- Configuration of the register
			bit_size : integer := 32
		
		);
		
		port (
			-- Clock and reset
			clk            : in STD_LOGIC;
			reset        	: in STD_LOGIC;
			
			-- Data ports
			Din_s				: in STD_LOGIC_VECTOR(bit_size - 1 downto 0);
			Dout_s			: out STD_LOGIC_VECTOR(bit_size - 1 downto 0);
			enable			: in STD_LOGIC;
			
			-- IO ports
			SW_0           : in STD_LOGIC;
			SW_1      		: in STD_LOGIC;
			LED      		: out STD_LOGIC
		);
	end component;	
	-- Internal signals
	signal cs 			:	STD_LOGIC_VECTOR(4 downto 0); -- Chip select
	signal cs_wr		:	STD_LOGIC_VECTOR(4 downto 0);	-- Chip select and Write
	signal reg0_out	:	STD_LOGIC_VECTOR(31 downto 0);
	signal reg1_out	:	STD_LOGIC_VECTOR(31 downto 0);
	signal reg2_out	:	STD_LOGIC_VECTOR(31 downto 0);
	signal reg3_out	:	STD_LOGIC_VECTOR(31 downto 0);
	signal reg4_out	:	STD_LOGIC_VECTOR(31 downto 0);
	
	begin
	C_S	:	chip_select 		port map (AB_s => AB_s, cs => cs);
	cs_wr <= (cs(4) and WR_s, cs(3) and WR_s, cs(2) and WR_s, cs(1) and WR_s, cs(0) and WR_s);
	
	-- Registers (0-3)
	reg0 	:	generic_register 	generic map (bit_size => 32) -- Not neccesary
										port map (clk => clk, reset => reset, Din_s => Din_s, 
													Dout_s => reg0_out, enable => cs_wr(0));
	reg1 	:	generic_register 	generic map (bit_size => 32) 
										port map (clk => clk, reset => reset, Din_s => Din_s, 
													Dout_s => reg1_out, enable => cs_wr(1));
	reg2 	:	generic_register 	generic map (bit_size => 32) 
										port map (clk => clk, reset => reset, Din_s => Din_s, 
													Dout_s => reg2_out, enable => cs_wr(2));
	reg3 	:	generic_register 	generic map (bit_size => 32) 
										port map (clk => clk, reset => reset, Din_s => Din_s, 
													Dout_s => reg3_out, enable => cs_wr(3));
													
	-- Register 4
	reg4	:	io_register			generic map (bit_size => 32) 
										port map (clk => clk, reset => reset, Din_s => Din_s, 
													Dout_s => reg4_out, enable => cs_wr(4), SW_0 => SW_0,
													SW_1 => SW_1, LED => LED);
	
	-- Output Multiplexor
	Dout_s <=	reg0_out when ((cs(0) = '1') and (RD_s = '1')) else
					reg1_out when ((cs(1) = '1') and (RD_s = '1')) else
					reg2_out when ((cs(2) = '1') and (RD_s = '1')) else
					reg3_out when ((cs(3) = '1') and (RD_s = '1')) else
					reg4_out when ((cs(4) = '1') and (RD_s = '1')) else
					(others => '0');
				
end arch;