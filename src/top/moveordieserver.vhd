library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;

entity MoveOrDieServer is
	port(
		clk100M: in std_logic;
		clk25M: in std_logic;
		rst: in std_logic;
		clkControl_1: out std_logic;
		clkControl_2: out std_logic;
		clkControl_3: out std_logic;
		clkControl_4: out std_logic;
		receive_1: in std_logic;
		receive_2: in std_logic;
		receive_3: in std_logic;
		receive_4: in std_logic;
		send_1: out std_logic;
		send_2: out std_logic;
		send_3: out std_logic;
		send_4: out std_logic;
		rst_1: out std_logic;
		rst_2: out std_logic;
		rst_3: out std_logic;
		rst_4: out std_logic;
        -- vga data:
        vga_HSYNC, vga_VSYNC: out std_logic;
        vga_r, vga_g, vga_b: out std_logic_vector(2 downto 0);
        -- view
        Receiveview: out std_logic;
        dataview: out std_logic_vector(6 downto 0);
        clkview: out std_logic
	);
end MoveOrDieServer;

architecture sss of MoveOrDieServer is

component connector is
	generic(
		receiveLenth: integer := 3;
		sendLenth: integer := 3
	);
	port(
		receive: in std_logic;
		clk: in std_logic;
		dataToSend: in std_logic_vector(sendLenth-1 downto 0); -- warning: begin with lower bits!!!
		ESend: in std_logic;
		send: out std_logic;
		dataReceive:out std_logic_vector(receiveLenth-1 downto 0);
		EReceive:out std_logic
	);
end component;


component ClkDivider is
    generic (
        n: integer := 1 -- clkin: f0 -> clkout: f0 / (2^n)
    );
    port (
        clkin: in std_logic;
        clkout: out std_logic
    );
end component;

component VGA640480 is
    port (
        p1X, p1Y: in std_logic_vector(6 downto 0);
        p1Hp: in std_logic_vector(7 downto 0);

        p2X, p2Y: in std_logic_vector(6 downto 0);
        p2Hp: in std_logic_vector(7 downto 0);

        p3X, p3Y: in std_logic_vector(6 downto 0);
        p3Hp: in std_logic_vector(7 downto 0);

        p4X, p4Y: in std_logic_vector(6 downto 0);
        p4Hp: in std_logic_vector(7 downto 0);

        CLK_100MHz: in std_logic;
        HSYNC, VSYNC: out std_logic;
        r, g, b: out std_logic_vector(2 downto 0)
    );
end component;


---------------------------------------------------------------------------

signal data_1: std_logic_vector(21 downto 0) := "0000000000000000000000";
signal data_2: std_logic_vector(21 downto 0) := "0000000000000000000000";
signal data_3: std_logic_vector(21 downto 0) := "0000000000000000000000";
signal data_4: std_logic_vector(21 downto 0) := "0000000000000000000000";
--data_x(21-15),data_y(14-8),life(7-0)

signal dataToSend: std_logic_vector(87 downto 0);
signal send, clkControl: std_logic;
signal swp_CLK_div6, swp_CLK_div18: std_logic;
signal EReceive_1, EReceive_2, EReceive_3, EReceive_4: std_logic;
begin
	rst_1 <= not rst;
	rst_2 <= not rst;
	rst_3 <= not rst;
	rst_4 <= not rst;

	Receiveview <= EReceive_1;
	
    u00: ClkDivider generic map (
        n=> 6)
    port map (
        clkin=> CLK100M,
        clkout=> swp_CLK_div6);
        
    u000: ClkDivider generic map (
        n=> 22)
    port map (
        clkin=> CLK100M,
        clkout=> swp_CLK_div18);
	
	clkControl <= not swp_CLK_div6;
	clkControl_1 <= clkControl;
	clkControl_2 <= clkControl;
	clkControl_3 <= clkControl;
	clkControl_4 <= clkControl;
	clkview <= not swp_CLK_div6;
	
	dataToSend <= data_1 & data_2 & data_3 & data_4;
	
	net_1: connector generic map(
		sendLenth => 88,
		receiveLenth => 22
	)
	port map(
		receive => receive_1,
		clk => swp_CLK_div6,
		dataToSend => dataToSend,
		ESend => swp_CLK_div18,
		send => send_1,
		dataReceive => data_1,
		EReceive => EReceive_1
	);
	net_2: connector generic map(
		sendLenth => 88,
		receiveLenth => 22
	)
	port map(
		receive => receive_2,
		clk => swp_CLK_div6,
		dataToSend => dataToSend,
		ESend => swp_CLK_div18,
		send => send_2,
		dataReceive => data_2,
		EReceive => EReceive_2
	);
	
	net_3: connector generic map(
		sendLenth => 88,
		receiveLenth => 22
	)
	port map(
		receive => receive_3,
		clk => swp_CLK_div6,
		dataToSend => dataToSend,
		ESend => swp_CLK_div18,
		send => send_3,
		dataReceive => data_3,
		EReceive => EReceive_3
	);
	
	net_4: connector generic map(
		sendLenth => 88,
		receiveLenth => 22
	)
	port map(
		receive => receive_4,
		clk => swp_CLK_div6,
		dataToSend => dataToSend,
		ESend => swp_CLK_div18,
		send => send_4,
		dataReceive => data_4,
		EReceive => EReceive_4
	);
	--data_x(21-15),data_y(14-8),life(7-0)
    visual: VGA640480 port map (
            p1X=> data_1(21 downto 15), p1Y=> data_1(14 downto 8), p1Hp=> data_1(7 downto 0),
            p2X=> data_2(21 downto 15), p2Y=> data_2(14 downto 8), p2Hp=> data_2(7 downto 0),
            p3X=> data_3(21 downto 15), p3Y=> data_3(14 downto 8), p3Hp=> data_3(7 downto 0),
            p4X=> data_4(21 downto 15), p4Y=> data_4(14 downto 8), p4Hp=> data_4(7 downto 0),

            CLK_100MHz=> CLK100M,
            HSYNC=>vga_HSYNC,
            VSYNC=>vga_VSYNC,
            r=> vga_r,
            g=> vga_g,
            b=> vga_b);

	dataview <= data_1(21 downto 15);
end sss;