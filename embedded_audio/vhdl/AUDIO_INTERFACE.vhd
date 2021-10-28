

-- @module : 		AUDIO_INTERFACE
-- @author: 		Ilkka Hautala (ithauta@ee.oulu.fi)
-- @date created: 	3.2.2012
-- @last updated:	3.2.2012
-- @description: 	AUDIO PROCESSOR AUDIO INTERFACE UNIT
--					The Audio Interface is link between Audio dsp and wm8731 audio codec.
--					Audio Interface buffer audio codec serial ADC data and send it in paraller 16 bit form
--					to Audio DSP. Audio DSP process the data, send it back. Audio interface serialize
--					the data and send it to Audio codec to DAC - transform.


library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity AUDIO_INTERFACE is 
port (
    CLK					: in	std_logic;
    ASYNC_RESET_L 		: in	std_logic;
    SYNC_RESET			: in	std_logic;
    -- AUDIO DSP --
    DSP_READY			: in	std_logic;
    DATA_OUT_L			: in	std_logic_vector(15 downto 0);
    DATA_OUT_R			: in	std_logic_vector(15 downto 0);
    DATA_IN_L			: out	std_logic_vector(15 downto 0);
    DATA_IN_R			: out	std_logic_vector(15 downto 0);
    DATA_IN_EN			: out 	std_logic;
    -- CLOCK GENERATOR --
    ADCLRCLK			: in	std_logic;
    DACLRCLK			: in	std_logic;
    BCLK				: in	std_logic;
    -- WM8731 AUDIO CODEC --
    AUD_ADC_DAT			: in 	std_logic;
    AUD_DAC_DAT			: out	std_logic;
    AUD_ADCLRCLK		: out	std_logic;
    AUD_DACLRCLK		: out	std_logic;
    AUD_BCLK			: out	std_logic
    );
     
end AUDIO_INTERFACE;     

architecture rtl of AUDIO_INTERFACE is

	type channel_t is (left,right);
	signal adc_dat_srg 		: std_logic_vector(15 downto 0);
	signal adc_dat_l_reg 	: std_logic_vector(15 downto 0);
	signal adc_dat_r_reg 	: std_logic_vector(15 downto 0);
	--signal ld_adc_dat_l_reg : std_logic;
	--signal ld_adc_dat_r_reg : std_logic;
	signal adc_bit_ctr		: unsigned(4 downto 0);
	signal bclk_edgeDect	: std_logic;
	signal adclrclk_edgeDect: std_logic;
	
	signal dac_dat_srg		: std_logic_vector(15 downto 0);
	signal daclrclk_edgeDect: std_logic;
	signal dat_to_dac_srg	: std_logic_vector(15 downto 0);
                   
begin  

	adcSRG : process (CLK,ASYNC_RESET_L) begin
	    
	    if ASYNC_RESET_L = '0' then
	        adc_dat_srg <= (others => '0');
	        bclk_edgeDect <= '0';
	    elsif rising_edge(CLK) then
	        if SYNC_RESET = '1' then
	            adc_dat_srg <= (others => '0');
	            bclk_edgeDect <= '0';
	        else
	            --rising edge of bclk
	            --shift and load
				if bclk_edgeDect = '0' and BCLK = '1' then
				    adc_dat_srg(15 downto 1) <= adc_dat_srg(14 downto 0);
				    adc_dat_srg(0) <= AUD_ADC_DAT;
				else
					adc_dat_srg <= adc_dat_srg;
				end if;
				    	            
	            bclk_edgeDect <= BCLK;
	        end if;
	    end if;
	end process adcSRG;
	
	adcLRregs : process (CLK,ASYNC_RESET_L) begin
	    
	    if ASYNC_RESET_L = '0' then
	        adc_dat_l_reg <= (others => '0');
	        adc_dat_r_reg <= (others => '0');
	        adclrclk_edgeDect <= '0';
	        adc_bit_ctr <= (others => '0');
	    elsif rising_edge(CLK) then
	        if SYNC_RESET = '1' then
    	        adc_dat_l_reg <= (others => '0');
    	        adc_dat_r_reg <= (others => '0');
    	        adclrclk_edgeDect <= '0';
    	        adc_bit_ctr <= (others => '0');
	        else
	            if adc_bit_ctr = 16 then
	                adc_bit_ctr <= (others => '0');           
				elsif BCLK = '1' and bclk_edgeDect = '0' then
				    adc_bit_ctr <= adc_bit_ctr + 1;
				else
				    adc_bit_ctr <= adc_bit_ctr;
				end if;
				
				if adc_bit_ctr = 16 and ADCLRCLK = '1' then
					adc_dat_l_reg <= adc_dat_srg;
				end if;
				if adc_bit_ctr = 16 and ADCLRCLK = '0' then
					adc_dat_r_reg <= adc_dat_srg;
--					DATA_IN_EN <= '1';
--				else
--				    DATA_IN_EN <= '0';
				end if;
				
				-- reset counter falling and rising edge of ADCLRCLK;
				if adclrclk_edgeDect /= ADCLRCLK then
					adc_bit_ctr <= (others => '0');
				end if;				
				
	            adclrclk_edgeDect <= ADCLRCLK;
	        end if;
	    end if;
	    		
	end process adcLRregs; 
		
	MUX2_1 : process (DACLRCLK,DATA_OUT_L,DATA_OUT_R) begin
		
		case DACLRCLK is
		when '1' =>
			dat_to_dac_srg <= DATA_OUT_L;
		when '0' =>
			dat_to_dac_srg <= DATA_OUT_R;
		when others =>
			null;
		end case; 
				
	end process MUX2_1;
	
	dacSRG : process (CLK,ASYNC_RESET_L) begin
		if ASYNC_RESET_L = '0' then
			dac_dat_srg <= (others => '0');
			daclrclk_edgeDect <= '0';
		elsif rising_edge(CLK) then
		    if SYNC_RESET = '1' then
		    	dac_dat_srg <= (others => '0');
				daclrclk_edgeDect <= '0';
			else
			    --rising and falling edge of DACLRCLK
			    if daclrclk_edgeDect /= DACLRCLK then
			    	dac_dat_srg <= dat_to_dac_srg;
			    else
			        if bclk_edgeDect = '1' and BCLK = '0' then
			            dac_dat_srg(15 downto 1) <= dac_dat_srg(14 downto 0);
			        else
			            dac_dat_srg <= dac_dat_srg;
			        end if;
			    end if;
				daclrclk_edgeDect <= DACLRCLK;
			end if;
		end if;
		
	end process dacSRG;
			
	
	AUD_ADCLRCLK <= ADCLRCLK;
	AUD_DACLRCLK <= DACLRCLK;
	AUD_BCLK <= BCLK;
	DATA_IN_L <= adc_dat_l_reg;
	DATA_IN_R <= adc_dat_r_reg;
	AUD_DAC_DAT <= dac_dat_srg(15);
	
	DATA_IN_EN <= '1' when adc_bit_ctr = 16 and ADCLRCLK = '0' else '0';
					
					
	
end rtl;

