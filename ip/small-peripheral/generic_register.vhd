library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;

entity generic_register is
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

end generic_register;

architecture arch of generic_register is

	signal reg : STD_LOGIC_VECTOR(bit_size - 1 downto 0) := (others => '0');
	
	begin
		process (clk)
		begin
			if rising_edge(clk) then
				if (reset = '1') then
					reg <= (others => '0');
				else 
					if (enable = '1') then
						reg <= Din_s;
					end if;
				end if;
			end if;
		end process;
		Dout_s <= reg;
end arch;
