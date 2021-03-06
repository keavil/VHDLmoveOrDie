library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity sender is
	generic(
		maxLenth: integer := 3
	);
	port(
		clk: in std_logic;
		ESend: in std_logic;
		data: in std_logic_vector(maxLenth-1 downto 0);
		output: out std_logic 
	);
end sender;

architecture ses of sender is
	signal cnt: integer := -2;
	signal check: std_logic;
	signal E: std_logic := '0';
	signal last: std_logic := '1';
begin
	process(ESend)
	begin
		if rising_edge(ESend) then
			E <= not E;
		end if;
	end process;
	process(clk)
	begin
		if rising_edge(clk) then
			if cnt < 0 then
				output <= '1';
				cnt <= cnt +1;
			elsif cnt = 0 then
				if E = last then
					cnt <= 1;
					output <= '0';
					check <= '0';
					last <= not E;
				else
					output <= '1';
				end if;
			elsif cnt <= maxLenth then
				output <= data(cnt-1);
				check <= check xor data(cnt-1);
				cnt <= cnt + 1;
			else
				output <= check;
				cnt <= -5;
			end if;
		end if;
	end process;
end ses;