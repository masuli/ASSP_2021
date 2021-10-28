-------------------------------------------------------------------------------
-- Title      : testbench for TTA processor
-- Project    : FlexDSP
-------------------------------------------------------------------------------
-- File       : testbench.vhdl
-- Author     : Jaakko Sertamo  <sertamo@vlad.cs.tut.fi>
-- Company    : TUT/IDCS
-- Created    : 2001-07-13
-- Last update: 2012/03/01
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: Simply resets the processor and triggers execution
-------------------------------------------------------------------------------
-- Copyright (c) 2001 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2001-07-13  1.0      sertamo Created
-- 2012-03-01  2.0      jariy   Modified for Altera gate-level simulation
-------------------------------------------------------------------------------
library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.Std_Logic_arith.all;

entity testbench is
	generic (PERIOD : time := 20 ns); -- 50MHz
end testbench;

architecture testbench of testbench is
	-- Design under test
	-- Name is the quartus design name
	-- See [quartus project dir]/simulation/modelsim/[design name].vho
	-- Modify it from entity to component 
	-- If entity and component doesn't match it causes error: "No default binding for component at 'cpu'."
	-- Only clock and reset needed (see mapping of cpu below)
  component TOP_FILE
    PORT (
			led : OUT std_logic_vector(3 DOWNTO 0);
			clk : IN std_logic;
			reset_n : IN std_logic
		);
	END component;

  component clkgen
    generic (
      PERIOD : time
    );
    port (
      clk : out std_logic;
      en  : in  std_logic := '1'
    );
  end component;
  
  signal clk : std_logic;
  signal rst_x : std_logic;

begin
  -- design_top: the top level design that e.g. goes to the FPGA
  -- power_tb: a wrapper for the top level design just for ModelSim
  -- Change the name of your design here
  power_tb : TOP_FILE
  port map (
    clk => clk,
    reset_n => rst_x
  );
  
  -- CLK
  clock : clkgen
    generic map (
      PERIOD => PERIOD
    )
    port map (
      clk => clk
    );
  
  run_test : process
  begin
    rst_x <= '0';
    wait for PERIOD*3-(PERIOD-2 ns);
    rst_x <= '1';
		while true loop
		  wait for PERIOD;
		end loop;
  wait;
    
  end process;
  
end testbench;
