-- Copyright (c) 2002-2010 Tampere University of Technology and contributors.
--
-- This file is part of TTA-Based Codesign Environment (TCE).
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a
-- copy of this software and associated documentation files (the "Software"),
-- to deal in the Software without restriction, including without limitation
-- the rights to use, copy, modify, merge, publish, distribute, sublicense,
-- and/or sell copies of the Software, and to permit persons to whom the
-- Software is furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
-- FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
-- DEALINGS IN THE SOFTWARE.
-------------------------------------------------------------------------------
-- Title      : FIFO output FU for TTA
-- Project    : 
-------------------------------------------------------------------------------
-- File       : fifo_stream_out_1.vhdl
-- Author     : Teemu Nyländen <teemu.nylanden(at)ee.oulu.fi>
-- Company    : 
-- Created    : 2012-04-25
-- Last update:
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: A 1 clock cycle function unit for writing to hardware FIFOs.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author   Description
-- 2012-04-25  1.0      tnylande Initial version.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- FIFO_STREAM_OUT
-------------------------------------------------------------------------------
library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.numeric_std.all;

entity fifo_stream_out_1 is
  
  generic (
    busw : integer := 32;
    dataw : integer := 32;
    statusw : integer := 9);

  port (
    t1data   : in  std_logic_vector(dataw-1 downto 0);
    t1load   : in  std_logic;
    t1opcode : in  std_logic;
    r1data   : out std_logic_vector(busw-1 downto 0);
    clk      : in  std_logic;
    rstx     : in  std_logic;
    glock    : in  std_logic;

    -- external port interface
    ext_data   : out std_logic_vector(dataw-1 downto 0);   -- the actual data to stream out
    ext_status : in  std_logic_vector(statusw-1 downto 0); -- status signal from outside
    ext_dv     : out std_logic                             -- datavalid signal
    );

end fifo_stream_out_1;


architecture rtl of fifo_stream_out_1 is
    signal reg_data : std_logic_vector(dataw-1 downto 0);
    signal reg_dv   : std_logic;

begin
  
    regs : process (clk, rstx)
    begin  -- process regs
    if rstx = '0' then

        reg_data <= (others => '0');
        reg_dv   <= '0';

    elsif clk'event and clk = '1' then

        if glock = '0' then
            reg_dv <= '0';
            if t1load = '1' then
                case t1opcode is
                when '0' =>
                    reg_data <= t1data;
                    reg_dv   <= '1';
                when others => null;
                end case;
            end if;
        end if;

    end if;
    end process regs;

    r1data(statusw-1 downto 0) <= ext_status(statusw-1 downto 0);
    r1data(busw-1 downto statusw) <= (others => '0');
    ext_data <= reg_data;
    ext_dv   <= reg_dv;
  
end rtl;
