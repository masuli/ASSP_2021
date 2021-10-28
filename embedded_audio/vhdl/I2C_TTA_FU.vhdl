
-------------------------------------------------------------------------------
-- Title      : I2C MASTER WRITE ONLY TTA INTERFACE
-- Project    : 
-------------------------------------------------------------------------------
-- File       : I2C_TTA_FU.vhdl
-- Author     : Ilkka Hautala <ilkka.hautala(at)ee.oulu.fi>
-- Company    : 
-- Created    : 2012-12-09
-- Last update: 2012-12-09
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: I2C MASTER INTERFACE
--              Supports on write I2C operation
--
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author      Description
-- 2010-12-14  1.0      ithauta     Initial version

-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Opcode package
-------------------------------------------------------------------------------
library IEEE;
use IEEE.Std_Logic_1164.all;

package opcodes_i2c_write_i2c_status is

  constant I2C_STATUS       : std_logic_vector(1-1 downto 0) := "0";
  constant I2C_WRITE        : std_logic_vector(1-1 downto 0) := "1";
  
  
end opcodes_i2c_write_i2c_status;

-------------------------------------------------------------------------------
-- I2C MASTER INTERFACE TO TTA
-------------------------------------------------------------------------------
library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.numeric_std.all;
use work.opcodes_i2c_write_i2c_status.all;

entity i2c_write_i2c_status is
  
  generic (
    dataw : integer := 24;
    busw : integer := 8
  );

  port (
    t1data   : in  std_logic_vector(dataw-1 downto 0);
    t1load   : in  std_logic;
    t1opcode : in  std_logic_vector(1-1 downto 0);
    r1data   : out std_logic_vector(busw-1 downto 0);
    clk      : in  std_logic;
    rstx     : in  std_logic;
    glock    : in  std_logic;

    -- external port interface
    i2c_data_out : out std_logic_vector(23 downto 0);
    i2c_data_en  : out std_logic_vector(0 downto 0);
    i2c_tx_en    : out std_logic_vector(0 downto 0);
    
    i2c_tx_done  : in std_logic_vector(0 downto 0);
    i2c_status   : in std_logic_vector(0 downto 0)  --0 failure, 1 success
    );

end i2c_write_i2c_status;


architecture rtl of i2c_write_i2c_status is
  
  signal t1reg  : std_logic_vector(23 downto 0);
  signal r1reg  : std_logic_vector(7 downto 0);
  signal tx_reg : std_logic;
  signal dataen_reg : std_logic;

begin

 
    regs : process (clk, rstx)
    begin  -- process regs
        if rstx = '0' then
            r1reg  <= (others => '0');
            tx_reg <= '0';
            t1reg <= (others => '0');
            dataen_reg <= '0';
        elsif clk'event and clk = '1' then

            if glock = '0' then
              
                if tx_reg = '0' then
                    r1reg(0) <= i2c_status(0);
                    r1reg(7 downto 1) <= (others => '0');
                end if;

                if i2c_tx_done = "1" then
                    tx_reg   <= '0';
                end if;


                if t1load = '1' then
                    case t1opcode is
                        when I2C_WRITE =>
                            t1reg  <= t1data(23 downto 0);
                            r1reg(1 downto 0)  <= "10"; --WAIT signal
                            r1reg(7 downto 2) <= (others => '0');
                            tx_reg <= '1';
                            dataen_reg <= '1';
                       -- when I2C_STATUS =>
                       --     null;    
                        when others => null;
                    end case;
                else
                  dataen_reg <= '0';
                end if;
                
            end if;
            
        end if;
    end process regs;

    r1data <= r1reg;
     
    i2c_data_out <= t1reg;
    i2c_tx_en(0) <= tx_reg;
  
    i2c_data_en(0) <= dataen_reg;
    
end rtl;

