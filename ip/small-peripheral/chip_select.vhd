library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;

entity chip_select is
	port (
	
		-- Input address
		AB_s				: in STD_LOGIC_VECTOR(2 downto 0);
		
		-- Output enable signals
		cs					: out STD_LOGIC_VECTOR(4 downto 0)
	);
end chip_select;

architecture conc of chip_select is
	begin
		cs <=	"00001" when AB_s = "000" else
				"00010" when AB_s = "001" else
				"00100" when AB_s = "010" else
				"01000" when AB_s = "011" else
				"10000" when AB_s = "100" else
				"00000";
end conc;