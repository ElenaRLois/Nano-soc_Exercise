library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;

entity io_register is
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

end io_register;

architecture arch of io_register is

	signal reg : STD_LOGIC_VECTOR(bit_size - 1 downto 0) := (others => '0');
	
	begin
		process (clk)
		begin
			if rising_edge(clk) then
				if (reset = '1') then
					reg(bit_size -1 downto 2) <= (others => '0');
				else 
					if (enable = '1') then
						reg(bit_size -1 downto 2) <= Din_s(bit_size -1 downto 2);
					end if;
				end if;
				reg(0) <= SW_0;
				reg(1) <= SW_1;
				LED <= reg(2);
			end if;
		end process;
		Dout_s <= reg;
end arch;
