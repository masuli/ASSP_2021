
-------------------------------------------------------------------------------
-- Title      : WOLFSON AUDIO CODEC TTA INTERFACE
-- Project    : 
-------------------------------------------------------------------------------
-- File       : AUD_TTA_FU.vhdl
-- Author     : Ilkka Hautala <ilkka.hautala(at)ee.oulu.fi>
-- Company    : 
-- Created    : 2012-12-09
-- Last update: 2012-12-09
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: WOLFSON AUDIO CODEC TTA INTERFACE
--              
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

package opcodes_AUD_CODEC is

    constant AUD_READ_L       : std_logic_vector(2 downto 0) := "000";
    constant AUD_READ_R       : std_logic_vector(2 downto 0) := "001";
    constant AUD_STATUS       : std_logic_vector(2 downto 0) := "010";
    constant AUD_WRITE_L      : std_logic_vector(2 downto 0) := "011";
    constant AUD_WRITE_R      : std_logic_vector(2 downto 0) := "100";
    
  
end opcodes_AUD_CODEC;

-------------------------------------------------------------------------------
-- AUDIO_CODEC INTERFACE to TTA
-------------------------------------------------------------------------------
library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.numeric_std.all;
use work.opcodes_AUD_CODEC.all;

entity AUD_CODEC is
  
  generic (
    dataw : integer := 16;
    busw : integer := 16
  );

  port (
    t1data   : in  std_logic_vector(dataw-1 downto 0);
    t1load   : in  std_logic;
    t1opcode : in  std_logic_vector(2 downto 0);
    r1data   : out std_logic_vector(busw-1 downto 0);
    clk      : in  std_logic;
    rstx     : in  std_logic;
    glock    : in  std_logic;

    -- external port interface
    aud_data_out_l  : out std_logic_vector(15 downto 0);
    aud_data_out_r  : out std_logic_vector(15 downto 0);
    
    aud_data_in_l   : in std_logic_vector(15 downto 0);
    aud_data_in_r   : in std_logic_vector(15 downto 0);
    aud_data_in_en  : in std_logic_vector(0 downto 0)

    );

end AUD_CODEC;


architecture rtl of AUD_CODEC is
  
  
    signal t1reg        : std_logic_vector(15 downto 0);
    signal r1reg        : std_logic_vector(15 downto 0);
    
    signal out_l_reg    : std_logic_vector(15 downto 0);
    signal out_r_reg    : std_logic_vector(15 downto 0);
    
    signal in_l_reg     : std_logic_vector(15 downto 0);
    signal in_r_reg     : std_logic_vector(15 downto 0);
    signal in_status_reg: std_logic;
  

begin

 
    regs : process (clk, rstx)
    begin  -- process regs
        if rstx = '0' then
            t1reg <= (others => '0');
            r1reg <= (others => '0');
            out_l_reg <= (others => '0');
            out_r_reg <= (others => '0');
            in_l_reg <= (others => '0');
            in_r_reg <= (others => '0');
            in_status_reg <= '0';
            
        elsif clk'event and clk = '1' then

            if glock = '0' then

                if aud_data_in_en = "1" then
                    in_l_reg <= aud_data_in_l;
                    in_r_reg <= aud_data_in_r;
                    in_status_reg <= '1';               
                end if;

                if t1load = '1' then
                    case t1opcode is
                        when AUD_WRITE_L =>
                            out_l_reg <= t1data(15 downto 0);
                        when AUD_WRITE_R =>
                            out_r_reg <= t1data(15 downto 0);
                        when AUD_READ_L =>
                            r1reg <= in_l_reg;
                            in_status_reg <= '0';                        
                        when AUD_READ_R =>
                            r1reg <= in_r_reg;
                            in_status_reg <= '0';
                        when AUD_STATUS =>
                            r1reg(0) <= in_status_reg;
                            r1reg(15 downto 1) <= (others =>'0');                        
                        when others => null;
                    end case;
                end if;
                
            end if;
            
        end if;
    end process regs;
    
    aud_data_out_l <= out_l_reg;
    aud_data_out_r <= out_r_reg;
    r1data(15 downto 0) <= r1reg;
    --r1data(busw downto 16) <= (others => '0');

end rtl;
