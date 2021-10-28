-- @module : 		CLOCK_GENERATOR
-- @author: 		Ilkka Hautala (ithauta@ee.oulu.fi)
-- @date created: 3.2.2012
-- @last updated:	25.2.2013
-- @description: 	Clock generator which derive 12.288 MHz, 1.536MHz, 48KHz and 8 KHz clock signals from 50 MHz input clock
-- 					NOTE: include frac8.vhd, frac48.vhd, frac1536.vhd and frac12288.vhd files in to project. 
--	@Version history:	3.2.2012 	- Initial version
-- 						25.2.2013	- Frequency divider made up of a dual modulus prescaler and a controller
--											- 8 Khz output clock added.

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY CLOCK_GENERATOR IS 
	PORT
	(
		reset :  IN  STD_LOGIC;
		CLK_50MHz :  IN  STD_LOGIC;
		enable :  IN  STD_LOGIC;
		CLK_12_288MHz :  OUT  STD_LOGIC;
		CLK_1_536MHz :  OUT  STD_LOGIC;
		CLK_48KHz :  OUT  STD_LOGIC;
		CLK_8KHz :  OUT  STD_LOGIC
	);
END CLOCK_GENERATOR;

ARCHITECTURE bdf_type OF CLOCK_GENERATOR IS 

COMPONENT frac48
GENERIC (improve_duty_cycle : BOOLEAN;
			minimum_jitter : BOOLEAN;
			use_phase_accumulator : BOOLEAN;
			use_recursive_controller : BOOLEAN
			);
	PORT(async_reset : IN STD_LOGIC;
		 clock : IN STD_LOGIC;
		 clock_enable : IN STD_LOGIC;
		 output_50 : OUT STD_LOGIC;
		 output_pulse : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT frac1536
GENERIC (improve_duty_cycle : BOOLEAN;
			minimum_jitter : BOOLEAN;
			use_phase_accumulator : BOOLEAN;
			use_recursive_controller : BOOLEAN
			);
	PORT(async_reset : IN STD_LOGIC;
		 clock : IN STD_LOGIC;
		 clock_enable : IN STD_LOGIC;
		 output_50 : OUT STD_LOGIC;
		 output_pulse : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT frac12288
GENERIC (improve_duty_cycle : BOOLEAN;
			minimum_jitter : BOOLEAN;
			use_phase_accumulator : BOOLEAN;
			use_recursive_controller : BOOLEAN
			);
	PORT(async_reset : IN STD_LOGIC;
		 clock : IN STD_LOGIC;
		 clock_enable : IN STD_LOGIC;
		 output_50 : OUT STD_LOGIC;
		 output_pulse : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT frac8
GENERIC (improve_duty_cycle : BOOLEAN;
			minimum_jitter : BOOLEAN;
			use_phase_accumulator : BOOLEAN;
			use_recursive_controller : BOOLEAN
			);
	PORT(async_reset : IN STD_LOGIC;
		 clock : IN STD_LOGIC;
		 clock_enable : IN STD_LOGIC;
		 output_50 : OUT STD_LOGIC;
		 output_pulse : OUT STD_LOGIC
	);
END COMPONENT;

SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC;


BEGIN 



b2v_inst : frac48
GENERIC MAP(improve_duty_cycle => false,
			minimum_jitter => false,
			use_phase_accumulator => false,
			use_recursive_controller => true
			)
PORT MAP(async_reset => SYNTHESIZED_WIRE_4,
		 clock => CLK_50MHz,
		 clock_enable => enable,
		 output_50 => CLK_48KHz);


b2v_inst1 : frac1536
GENERIC MAP(improve_duty_cycle => false,
			minimum_jitter => false,
			use_phase_accumulator => false,
			use_recursive_controller => true
			)
PORT MAP(async_reset => SYNTHESIZED_WIRE_4,
		 clock => CLK_50MHz,
		 clock_enable => enable,
		 output_50 => CLK_1_536MHz);


SYNTHESIZED_WIRE_4 <= NOT(reset);



b2v_inst2 : frac12288
GENERIC MAP(improve_duty_cycle => false,
			minimum_jitter => false,
			use_phase_accumulator => false,
			use_recursive_controller => true
			)
PORT MAP(async_reset => SYNTHESIZED_WIRE_4,
		 clock => CLK_50MHz,
		 clock_enable => enable,
		 output_50 => CLK_12_288MHz);


b2v_inst3 : frac8
GENERIC MAP(improve_duty_cycle => false,
			minimum_jitter => false,
			use_phase_accumulator => false,
			use_recursive_controller => true
			)
PORT MAP(async_reset => SYNTHESIZED_WIRE_4,
		 clock => CLK_50MHz,
		 clock_enable => enable,
		 output_50 => CLK_8KHz);


END bdf_type;