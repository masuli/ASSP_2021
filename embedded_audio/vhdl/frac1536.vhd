--------------------------------------------------------------------------------
-- File         : fracn.vhd (machine generated)
-- Contains     : entity fracn (architecture rtl)
-- Author       : fracn09.pl  (version 0.09)
-- Command Line : fracn09.pl 5e7 1536000
-- Date         : Sun Feb 24 21:58:23 2013
-- Complain to  : fractional_divider@hotmail.com
--
-- This machine generated VHDL file contains a fixed ratio frequency divider.
-- Different styles of dividers can be selected by generics or parameters.
--
--  use_phase_accumulator = TRUE   selects a "classic" phase accumulator
--                                 frequency divider
--
--  use_phase_accumulator = FALSE  selects a frequency divider made up of
--                                 a dual modulus prescaler and a controller
--                                 In this case, the generics "minimum_jitter"
--                                 and "use_recursive_controller"
--                                 control size / jitter tradeoffs in
--                                 the controller.
--
-- The phase accumulator style divider has a regular structure (in the sense
-- that it doesn't change much if the ratio is changed - which is good for
-- floorplanning) and it is quite easy to understand.
-- The output frequency is a rational multiple of the input frequency in
-- the form:
--
--       c
-- --------------- * Fin
-- (2 ** num_bits)
--
-- where c and num_bits are integers.
-- The hardware consists of a constant adder, so it will be simple to
-- make it work at high speed.
-- The output jitter will generally be equal to or just less than one
-- cycle of the input clock.
-- Here is a block diagram:
-- 
-- 'clock'-----------------------+
--                               |
--             +-------+    +----------+
-- Constant--->|       |    |          |
-- 'c'         | Adder |--->| Register |-+-->'phase'
--          +->|       |    |          | |
--          |  +-------+    +----------+ |
--          |                            |
--          +----------------------------+
--
-- The MSB of the 'phase' signal has approximately a 50% duty cycle, and
-- is retimed (in another ff not shown) and used as the 'output_50' output.
-- The carry output of the adder will be high once every output cycle,
-- and is registered (in another ff not shown) and used as the
-- 'output_pulse' output.
--
--
-- The dual modulus prescaler divider is somewhat harder to understand, but
-- it may result in less hardware, and it may enable the exact ratio to
-- be produced.
-- In this case, the output frequency is a rational multiple of the input
-- frequency in the form:
--
--       (a + b)
-- ----------------------- * Fin
-- (a * n) + (b * (n + 1))
--
-- where a, b, and n are integers.
-- The dual modulus prescaler divides the input clock by n or (n+1).
-- The controller causes the prescaler to divide by n for a cycles of the
-- output, and divide by (n+1) for b cycles of the output.
-- Depending on how these a and b cycles are mixed up, the output
-- jitter will vary.
-- There are a number of ways to make the controller.
-- If the generic use_recursive_controller is TRUE, the controller consists
-- of a state machine that produces the best interleaving of the a and b cycles,
-- which gives about the same jitter as the phase accumulator.
-- If use_recursive_controller is FALSE, the controller consists of a counter
-- and a lookup table to interleave the a and b cycles.
-- There are more tradeoffs: if the generic minimum_jitter is FALSE, the lookup
-- table bunches all the a cycles together, and all the b cycles together.
-- This results in simple hardware, but may produce lots of jitter.
-- If the generic minimum_jitter is TRUE, the lookup table produces the best
-- interleaving of the a and b cycles, but it may result in an excessively
-- large case statement.
-- (It will usually be possible to come up with a much better
-- controller design by hand, but the details vary so much with
-- the choice of frequencies that it is hard to generalise this
-- into a simple script.)
-- Here is a block diagram:
--
--             +--------------+
--             | Dual modulus | 'prescaler_out'
-- 'clock'---->|  Prescaler   |------+--------->
--             | /n or /(n+1) |      |
--             +--------------+      |
--                    ^              |
--                    |       +------------+
--                    |       |            |
--                    +-------| Controller |
--          'modulus_control' |            |
--                            +------------+
--
--
-- For a given set of input to output frequency ratio and tolerance,
-- the only way to work out which type of divider is better is
-- to try them!  Generally, the phase accumulator is better for
-- loose tolerances (> 10ppm), and the dual modulus prescaler is
-- better if the ratio must be exact, but this depends on the ratio.
--
-- Frequency Parameters:
-- Input Frequency: 50000000 Hz.
-- Desired Output Frequency: 1536000 Hz.
-- Requested Relative Frequency Error Bounds (+/-) : 1e-07 (0.1 ppm)
--
-- Frequency Results (use_phase_accumulator = FALSE) :
--  Achieved Output Frequency: 1536000 Hz.
--  Achieved Relative Frequency Error: 0 (0 ppm)
--  Achieved Frequency Error: 0 Hz.
--
-- Frequency Results (use_phase_accumulator = TRUE) :
--  Achieved Output Frequency: 1536000.14746189 Hz.
--  Achieved Relative Frequency Error: 9.60038353999456e-08 (0.0960038353999456 ppm)
--  Achieved Frequency Error: 0.147461891174316 Hz.
--
-- Output Jitter Parameters (use_phase_accumulator = FALSE) :
--  The fundamental frequency is 16000 Hz.
--  The amplitude is 4.74791666666669e-07 seconds p-p (minimum_jitter = FALSE).
--  The amplitude is 1.97916666666727e-08 seconds p-p (minimum_jitter = TRUE).
--
-- Output Jitter Parameters (use_phase_accumulator = TRUE) :
--  The fundamental frequency is 0.372529029846191 Hz.
--  The amplitude is 2e-08 seconds p-p (approx).
--
-- Design Parameters (use_phase_accumulator = FALSE) :
--  Approx 16 flip flops (6 in prescaler, 8 in controller and 2 retimes).
--  The recursive controller uses approx 16 flip flops.
--  The Dual-Modulus Prescaler uses ratios /32,/33
--  The Output consists of 43 cycles of 32 input clocks,
--  and 53 cycles of 33 input clocks.
--  There are 96 output clocks for every 3125 input clocks.
--
-- Design Parameters (use_phase_accumulator = TRUE) :
--  Approx 29 flip flops (27 in accumulator and 2 retimes)
--  There are 4123169 output clocks for every 134217728 input clocks.
--
-- Divider summary :
--
-- Approx Approx    Relative  Approx    
--  ff    Virtex    Frequency Jitter    Divider
-- count  Slices    Error     (seconds) (generic parameters)
--
--  29    tbd       9.6e-08   2e-08     use_phase_accumulator
--  32    tbd       9.6e-08   1e-08     use_phase_accumulator improve_duty_cycle
--  24    tbd       0         2e-08     use_recursive_controller
--  25    tbd       0         2e-08     use_recursive_controller improve_duty_cycle
--  16    tbd       0         2e-08     minimum_jitter
--  17    tbd       0         2e-08     minimum_jitter improve_duty_cycle
--  16    tbd       0         4.7e-07   (none)
--  17    tbd       0         4.7e-07   (none) improve_duty_cycle
--
-- Warnings:
--  none
--
-- Do not fix bugs by hand editing this file - fix the Perl source instead!
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity frac1536 is
    generic (
        use_phase_accumulator : boolean := FALSE;
            -- TRUE uses classic NCO design.
            -- FALSE uses prescaler / controller design
        use_recursive_controller  : boolean := TRUE;
        minimum_jitter        : boolean := FALSE;
            -- TRUE may use more hardware, but has lowest jitter
            -- (only applies when use_phase_accumulator is FALSE)
        improve_duty_cycle    : boolean := FALSE
            -- TRUE uses a falling edge ff to make the output duty cycle closer to 50%
    );
    port (
        async_reset       : in  std_logic := '0';   -- active high reset
        clock             : in  std_logic;          -- 50000000 Hz input clock
        clock_enable      : in  std_logic := '1';   -- active high clock enable
        output_50         : out std_logic;  -- 1536000 Hz output - approx 50% duty cycle
        output_pulse      : out std_logic   -- 1536000 Hz output - high for single clock per cycle
    );
end frac1536;

architecture rtl of frac1536 is

    -- definitions for prescaler / controller design
    constant n              : positive := 32;   -- prescaler divides by n or n + 1
    constant a              : positive := 43;   -- this many counts of 32
    constant b              : natural  := 53;   -- this many counts of 33
    signal modulus_control  : std_logic;
    signal prescaler_count  : integer range 0 to n;
    signal controller_count : integer range 0 to a + b - 1;
    signal prescaler_out    : std_logic;
    signal prescaler_out_50 : std_logic;
    signal duty_correction  : std_logic;
    -- definitions for recursive controller design
    constant n1             : natural  := 2;    -- prescaler #1 divides by n1 or n1 + 1
    constant m1             : positive := 2;    -- determines output duty cycle for prescaler #1
    constant n2             : natural  := 4;    -- prescaler #2 divides by n2 or n2 + 1
    constant m2             : positive := 4;    -- determines output duty cycle for prescaler #2
    constant n3             : natural  := 3;    -- prescaler #3 divides by n3 or n3 + 1
    constant m3             : positive := 3;    -- determines output duty cycle for prescaler #3
    constant n4             : natural  := 2;    -- prescaler #4 divides by n4 or n4 + 1
    constant m4             : positive := 2;    -- determines output duty cycle for prescaler #4
    signal stage1_count     : integer range 0 to n1;
    signal stage2_count     : integer range 0 to n2;
    signal stage3_count     : integer range 0 to n3;
    signal stage4_count     : integer range 0 to n4;
    signal stage1_out       : std_logic;
    signal stage2_out       : std_logic;
    signal stage3_out       : std_logic;
    signal stage4_out       : std_logic;
    signal stage1_carry     : std_logic;
    signal stage2_carry     : std_logic;
    signal stage3_carry     : std_logic;

    -- definitions for phase accumulator design
    constant num_bits       : positive := 27;   -- size of phase accumulator
    constant c              : unsigned(num_bits - 1 downto 0) := to_unsigned(4123169, num_bits);
    signal phase            : unsigned(num_bits downto 0);  -- MSB is carry output from adder

    -- definitions for phase accumulator design with improved duty cycle
    signal carry            : std_logic;
    signal d_carry          : std_logic;
    signal late             : std_logic;
    signal msb              : std_logic;
    signal d_msb_1          : std_logic;
    signal d_msb_2_neg      : std_logic;
    signal phase_diff       : unsigned(num_bits downto 0);

begin -- rtl

--------------------------------------------------------------------------------
-- Standard Phase accumulator.
-- Adds c to phase each clock.
-- phase(num_bits) is actually the registered carry output.
--------------------------------------------------------------------------------
gen_phase_accumulator : if use_phase_accumulator and not improve_duty_cycle generate
    phase_accumulator : process (async_reset, clock)
    begin
        if (async_reset = '1') then
            phase <= (others => '0');
            output_50 <= '0';
        elsif (rising_edge(clock)) then
            if (clock_enable = '1') then
                phase <= ('0' & phase(num_bits - 1 downto 0)) + ('0' & c);
                output_50 <= phase(num_bits - 1);
            end if;
        end if;
    end process phase_accumulator;

    output_pulse <= phase(num_bits);

end generate gen_phase_accumulator;

--------------------------------------------------------------------------------
-- Phase accumulator with lower jitter (on output_50) and improved duty cycle.
--------------------------------------------------------------------------------
gen_other_phase_accumulator : if use_phase_accumulator and improve_duty_cycle generate
    phase_accumulator : process (async_reset, clock)
        variable new_phase : unsigned(num_bits - 1 downto 0);
    begin
        if (async_reset = '1') then
            phase <= (others => '0');
            output_pulse <= '0';
            carry <= '0';
            d_carry <= '0';
            late <= '0';
            msb <= '0';
            d_msb_1 <= '0';
        elsif (rising_edge(clock)) then
            if (clock_enable = '1') then
                new_phase := ('0' & phase(num_bits - 2 downto 0)) + c;
                phase(num_bits - 2 downto 0) <= new_phase(num_bits - 2 downto 0);
                carry <= new_phase(num_bits - 1);
                if (carry = '1') then
                    msb <= not msb; -- toggle msb
                end if;
                output_pulse <= msb and carry;
                d_carry <= carry;
                d_msb_1 <= msb and not (d_carry and late);
                if (carry = '1') then
                    late <= phase_diff(num_bits);
                end if;
            end if;
        end if;
    end process phase_accumulator;

    phase_diff <= (phase(num_bits - 2 downto 0) & '0') - ('0' & c);

    output_50 <= d_msb_1 or d_msb_2_neg;

    neg_edge : process (async_reset, clock)
    begin
        if (async_reset = '1') then
            d_msb_2_neg <= '0';
        elsif (falling_edge(clock)) then
            if (clock_enable = '1') then
                d_msb_2_neg <= msb xor (d_carry and not (not late and not msb));
            end if;
        end if;
    end process neg_edge;

    assert c(num_bits - 1) = '0' severity failure; 

end generate gen_other_phase_accumulator;

--------------------------------------------------------------------------------
-- Prescaler.  Divides by either 32 or 33
-- depending on whether the signal "modulus_control" is '0' or '1'.
-- Note: the "terminal count" is fixed, and the load value is
-- varied, to give smaller, faster logic (?)
--------------------------------------------------------------------------------
gen_prescaler : if not use_phase_accumulator generate
    prescaler : process (async_reset, clock)
    begin
        if (async_reset = '1') then
            prescaler_count  <= 0;
            prescaler_out    <= '0';
            prescaler_out_50 <= '0';
        elsif (rising_edge(clock)) then
            if (clock_enable = '1') then
                -- manage counter
                if (prescaler_count < n) then
                    prescaler_count <= prescaler_count + 1;
                else
                    if (modulus_control = '0') then
                        prescaler_count <= 1;
                    else
                        prescaler_count <= 0;
                    end if;
                end if;
                -- decode counter
                if (prescaler_count < n) then
                    prescaler_out <= '0';
                else
                    prescaler_out <= '1';
                end if;
                if (prescaler_count <= n/2) then
                    prescaler_out_50 <= '0';
                else
                    prescaler_out_50 <= '1';
                end if;
            end if;
        end if;
    end process prescaler;

    output_pulse <= prescaler_out;

end generate gen_prescaler;

--------------------------------------------------------------------------------
-- Duty cycle improvement using falling edge flip flop.
--------------------------------------------------------------------------------
duty_cycle_improver : if improve_duty_cycle and not use_phase_accumulator generate
    improver : process (async_reset, clock)
    begin
        if (async_reset = '1') then
            duty_correction <= '0';
        elsif (falling_edge(clock)) then
            if (clock_enable = '1') then
                duty_correction <= prescaler_out_50 and modulus_control;
            end if;
        end if;
    end process improver;

    output_50 <= duty_correction or prescaler_out_50;

end generate duty_cycle_improver;

no_duty_cycle_improver : if not improve_duty_cycle and not use_phase_accumulator generate
    output_50 <= prescaler_out_50;
end generate no_duty_cycle_improver;

--------------------------------------------------------------------------------
-- Controller.
-- Wobbles the signal "modulus_control" to cause the prescaler
-- to divide by the correct ratio (in the long term).
-- Modulus_control must be '0' for 43 counts of prescaler_out,
-- and '1' for 53 counts (out of a total of 96 counts).
-- The simple way to do this is to just have modulus_control '0' for
-- all 43 counts, then '1' for 53 counts, but this may result in severe jitter.
-- The jitter can be reduced (at some hardware cost) by interleaving
-- the '0' and '1' counts.
-- This behaviour can be controlled by the generic parameter "minimum_jitter".
-- Note that there are many hardware / jitter tradeoffs.
-- Best results may require human intervention!
--------------------------------------------------------------------------------
high_jitter_controller : if not minimum_jitter and not use_phase_accumulator and not use_recursive_controller generate
    controller : process (async_reset, clock)
    begin
        if (async_reset = '1') then
            modulus_control <= '0';
            controller_count <= 0;
        elsif (rising_edge(clock)) then
            if (clock_enable = '1') then
                if (prescaler_out = '1') then
                    -- manage counter
                    if (controller_count < a + b - 1) then
                        controller_count <= controller_count + 1;
                    else
                        controller_count <= 0;
                    end if;
                    -- decode counter
                    if (controller_count < a) then
                        modulus_control <= '0';
                    else
                        modulus_control <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process controller;
end generate high_jitter_controller;

low_jitter_controller : if minimum_jitter and not use_phase_accumulator and not use_recursive_controller generate
    controller : process (async_reset, clock)
    begin
        if (async_reset = '1') then
            modulus_control <= '0';
            controller_count <= 0;
        elsif (rising_edge(clock)) then
            if (clock_enable = '1') then
                if (prescaler_out = '1') then
                    -- manage counter
                    if (controller_count < a + b - 1) then
                        controller_count <= controller_count + 1;
                    else
                        controller_count <= 0;
                    end if;
                    -- decode counter
                    if (controller_count <= a + b - 1) then
                        case controller_count is
                            when 1|3|5|7|9|12|14|16 => modulus_control <= '0';
                            when 18|21|23|25|27|30|32|34 => modulus_control <= '0';
                            when 36|38|41|43|45|47|50|52 => modulus_control <= '0';
                            when 54|56|59|61|63|65|67|70 => modulus_control <= '0';
                            when 72|74|76|79|81|83|85|88 => modulus_control <= '0';
                            when 90|92|94 => modulus_control <= '0';
                            when others => modulus_control <= '1';
                        end case;
                    else
                        modulus_control <= '-'; -- allow logic reductions (?)
                    end if;
                end if;
            end if;
        end if;
    end process controller;
end generate low_jitter_controller;

--------------------------------------------------------------------------------
-- recursive controller
-- The modulus control signal for the prescaler can be generated by another
-- fractional-N divider, which in turn can have its modulus control signal
-- generated by yet another fractional-N divider, and so on.
-- We stop when we don't need another fractional-N divider, and can just use
-- a fixed divider.
-- The particular arrangement we use also produces the smallest possible jitter.
-- The stageN_count and stageN_out signals have been initialised to non-zero
-- values to improve the jitter measurements during simulation.  This is not
-- needed for synthesis, and these values should be set to zero if this
-- improves synthesis results.
-- Recursive controller design information (for debugging):
--          n0=32       m0=X        a0=43       b0=53       i0=X
--          n1=2        m1=2        a1=33       b1=10       i1=1
--          n2=4        m2=4        a2=7        b2=3        i2=0
--          n3=3        m3=3        a3=2        b3=1        i3=0
--          n4=2        m4=2        a4=X        b4=X        i4=0
--------------------------------------------------------------------------------
recursive_controller : if not use_phase_accumulator and use_recursive_controller generate
    controller : process (async_reset, clock)
    begin
        if (async_reset = '1') then
            stage1_count <= 2;
            stage2_count <= 4;
            stage3_count <= 3;
            stage4_count <= 2;
            stage1_out <= '1';
            stage2_out <= '0';
            stage3_out <= '0';
            stage4_out <= '0';
            stage1_carry <= '0';
            stage2_carry <= '0';
            stage3_carry <= '0';
        elsif (rising_edge(clock)) then
            if (clock_enable = '1') then
                -- Stage 1  stage1_out is low for 43 cycles, and high for 53 cycles.
                -- n1=2 m1=2 a1=33 b1=10 i1=1
                if (prescaler_out = '1') then
                    if (stage1_count < n1) then
                        stage1_count <= stage1_count + 1;
                        stage1_carry <= '0';
                    else
                        if (stage2_out = '0') then
                            stage1_count <= 1;
                        else
                            stage1_count <= 0;
                        end if;
                        stage1_carry <= '1';
                    end if;
                    if (stage1_count < m1) then
                        stage1_out <= '1';
                    else
                        stage1_out <= '0';
                    end if;
                else
                    stage1_carry <= '0';
                end if;
                -- Stage 2  stage2_out is low for 33 cycles, and high for 10 cycles.
                -- n2=4 m2=4 a2=7 b2=3 i2=0
                if (stage1_carry = '1') then
                    if (stage2_count < n2) then
                        stage2_count <= stage2_count + 1;
                        stage2_carry <= '0';
                    else
                        if (stage3_out = '0') then
                            stage2_count <= 1;
                        else
                            stage2_count <= 0;
                        end if;
                        stage2_carry <= '1';
                    end if;
                    if (stage2_count < m2) then
                        stage2_out <= '0';
                    else
                        stage2_out <= '1';
                    end if;
                else
                    stage2_carry <= '0';
                end if;
                -- Stage 3  stage3_out is low for 7 cycles, and high for 3 cycles.
                -- n3=3 m3=3 a3=2 b3=1 i3=0
                if (stage2_carry = '1') then
                    if (stage3_count < n3) then
                        stage3_count <= stage3_count + 1;
                        stage3_carry <= '0';
                    else
                        if (stage4_out = '0') then
                            stage3_count <= 1;
                        else
                            stage3_count <= 0;
                        end if;
                        stage3_carry <= '1';
                    end if;
                    if (stage3_count < m3) then
                        stage3_out <= '0';
                    else
                        stage3_out <= '1';
                    end if;
                else
                    stage3_carry <= '0';
                end if;
                -- Stage 4  stage4_out is low for 2 cycles, and high for 1 cycles.
                -- n4=2 m4=2 a4=X b4=X i4=0
                if (stage3_carry = '1') then
                    if (stage4_count < n4) then
                        stage4_count <= stage4_count + 1;
                    else
                        stage4_count <= 0;
                    end if;
                    if (stage4_count < m4) then
                        stage4_out <= '0';
                    else
                        stage4_out <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process controller;

    modulus_control <= stage1_out;

end generate recursive_controller;

end rtl;
--------------------------------------------------------------------------------
-- <EOF> fracn.vhd
--------------------------------------------------------------------------------
