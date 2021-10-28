
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

--I2C Master controller - write only
--Author: Ilkka Hautala (ithauta@ee.oulu.fi)
--Created: 5.12.2011
--Last Changed: 07.02.2012
--Change log
--07.02.2012	Whole design is changed. Simpler and better state machine structure.
--				SCLK AND SDAT timing improvements  
entity I2C_INTERFACE is
 
  --sclk max frequency for Wolfson audio codec  400 KHz
  --4*I2CC_CLOCK_DIV gives cycle length of SCLK,  so if I2CC_CLOCK_DIV = 50 then
  --SCLK frequency is 250 KHz if system clock frequency is 50 Mhz.  
  generic ( I2CC_CLOCK_DIV : natural := 50);

  port (
    CLK, ASYNC_RESET_L, SYNC_RESET : in    std_logic;

    I2CC_DATA_IN : in std_logic_vector(23 downto 0);
    I2CC_DATA_EN : in std_logic;
    I2CC_TX_EN   : in std_logic;
    I2CC_STATUS  : out std_logic;    
    I2CC_TX_DONE : out   std_logic;

    I2C_SCLK     : out   std_logic;
    I2C_SDAT     : inout std_logic
    );

end I2C_INTERFACE;

architecture RTL of I2C_INTERFACE is


  -- Signals used in the three-state output code example below
  constant SCLKLEN: natural := 4*I2CC_CLOCK_DIV;
  constant SCLKRISE: natural := 2*I2CC_CLOCK_DIV;
  constant SCLKHALF: natural := I2CC_CLOCK_DIV;
  
  -- 24 bit PIPO register and 24 bit PISO shift register
  --signal REG24 : std_logic_vector(23 downto 0);
  signal SRG24 : std_logic_vector(23 downto 0);
  signal SRG24SHIFT : std_logic;

  
  signal i2ccStatus_reg 	: std_logic;
  signal set_i2ccStatus_reg : std_logic;
  -- Counter unit for I2C SCLK timing generation
  signal CTRN_r : integer range 1 to SCLKLEN;
  signal HALFCLK : std_logic;
  signal s_sclk : std_logic;	
  
  --Control signals
  type i2c_slave_type is (wait_transmission, start, send_8_bits, check_ack, stop,set_i2cc_status);
  signal current_state : i2c_slave_type;
  signal next_state : i2c_slave_type;
  signal genStartCondition 	: std_logic;
  signal sendBits			: std_logic;
  signal checkAck			: std_logic;
  signal genStopCondition	: std_logic;	
  signal ackCounter_reset	: std_logic;
  
  type outputMux_t is (data,start_end,ack);
  signal sel_Condition		: outputMux_t;
  signal start_end_to_mux   : std_logic;
  signal ackIn				: std_logic;
  
  --STARTCONDIOTION GENERATOR SIGNALS
  signal edge_Detect_half_clk:std_logic;
  signal start_gen_ready	: std_logic;
  signal stop_gen_ready		: std_logic;
  
  --SENDBITS BLOCK 
  signal sendBits_ready		: std_logic;
  signal bitCounter			: natural range 0 to 8;
  
  --CHECK ACK BLOCK
  signal checkAck_ready		: std_logic;
  signal wordCounter		: natural range 0 to 3;
  signal ackCounter			: natural range 0 to 3;
    
begin  -- RTL
    
   
	i2c_slave_fms : process (current_state,I2CC_TX_EN,start_gen_ready,sendBits_ready,
							checkAck_ready,wordCounter,stop_gen_ready)
	begin
	    
	    case current_state is
	    when wait_transmission =>
	    	genStartCondition <= '0';
	    	genStopCondition <= '0';
	    	sendBits <= '0';
	    	checkAck <= '0';
	    	set_i2ccStatus_reg <= '0';
	    	sel_Condition <= ack;
	    	I2CC_TX_DONE <= '0';
	    	if I2CC_TX_EN = '1' then 
	    		next_state <= start;
	    	else
	    	    next_state <= wait_transmission;
	    	end if;
	    
	    when start =>
	    	genStartCondition <= '1';
	    	genStopCondition <= '0';
	    	sendBits <= '0';
	    	checkAck <= '0';
	    	set_i2ccStatus_reg <= '0';
	    	sel_Condition <= start_end;
	    	I2CC_TX_DONE <= '0';
	    	if start_gen_ready = '1' then 
	    		next_state <= send_8_bits;
	    	else
	    	    next_state <= start;
	    	end if;
	    
	    when send_8_bits =>
	    	genStartCondition <= '0';
	    	genStopCondition <= '0';
	    	sendBits <= '1';
	    	checkAck <= '0';
	    	set_i2ccStatus_reg <= '0';
	    	sel_Condition <= data;
	    	I2CC_TX_DONE <= '0';
	    	if sendBits_ready = '1' then 
	    		next_state <= check_ack;
	    	else
	    	    next_state <= send_8_bits;
	    	end if;
	    	
	    when check_ack =>
	    	genStartCondition <= '0';
	    	genStopCondition <= '0';
	    	sendBits <= '0';
	    	checkAck <= '1';
	    	set_i2ccStatus_reg <= '0';
	    	sel_Condition <= ack;
	    	I2CC_TX_DONE <= '0';
	    	if wordCounter = 3 then 
	    		next_state <= stop;
	    	elsif checkAck_ready = '1' then
	    	    next_state <= send_8_bits;
	    	else
	    	    next_state <= check_ack;
	    	end if;
	    
	    when stop =>
	    	genStartCondition <= '0';
	    	genStopCondition <= '1';
	    	sendBits <= '0';
	    	checkAck <= '0';
	    	set_i2ccStatus_reg <= '0';
	    	sel_Condition <= start_end;
	    	I2CC_TX_DONE <= '0';
	    	if stop_gen_ready = '1' then 
	    		 next_state <= set_i2cc_status;
	    	else
	    	    next_state <= stop;
	    	end if;
	    
	    when set_i2cc_status =>
	   		genStartCondition <= '0';
	    	genStopCondition <= '0';
	    	sendBits <= '0';
	    	checkAck <= '0';
	    	set_i2ccStatus_reg <= '1';
	    	sel_Condition <= ack;
	    	I2CC_TX_DONE <= '1';
	    	next_state <= wait_transmission;
	    		    
	    end case;
		
	end process i2c_slave_fms;
		
	nextStateDecoder : process (CLK,ASYNC_RESET_L) is 
    begin
    	if(ASYNC_RESET_L = '0') then
    	    current_state <= wait_transmission;
    	elsif rising_edge(CLK) then
    		if(SYNC_RESET = '1') then
    			current_state <= wait_transmission;
    		else
    	    	current_state <= next_state;
    	    end if;
    	end if;	
    end process nextStateDecoder;

    --REG24 AND SRG24
    load24bitReg_PROC: process(CLK, ASYNC_RESET_L) is
    begin
        if ASYNC_RESET_L = '0' then
            SRG24 <= (others => '0');
            --SRG24OUT <= '0';
        elsif rising_edge(CLK) then
            if(SYNC_RESET = '1') then
                --SRG24OUT <= '0';
                SRG24 <= (others => '0');
            else
                if(I2CC_DATA_EN = '1') then
                    SRG24 <= I2CC_DATA_IN;
                end if;
                if SRG24SHIFT = '1' then
                    SRG24(23 downto 1) <= SRG24( 22 downto 0);
                    --SRG24OUT <= SRG24(23);
                end if;
           end if;

        end if;
    end process;
    
    --I2C SCLK TIMING GENERATOR
    ctr_PROC : process(CLK, ASYNC_RESET_L) is
    begin
        if ASYNC_RESET_L = '0' then 
            CTRN_r <= 1;
        elsif rising_edge(CLK) then
            if SYNC_RESET = '1' then
            	CTRN_r <= 1;
            else
                if CTRN_r = SCLKLEN then
                   CTRN_r <= 1;
                elsif I2CC_TX_EN = '1' then
                	CTRN_r <= CTRN_r + 1 ;
                else
                   CTRN_r <= 1;
                end if;
            end if;
        end if;
    end process;
  
  
  	HALFCLK_PROC : process (CTRN_r) begin
		if (CTRN_r >= SCLKHALF and CTRN_r < 3*SCLKHALF) then
		    HALFCLK <= '0';
		else
		    HALFCLK <= '1';
		end if;
  		
  	end process HALFCLK_PROC;
  	
  	GENSTART_STOP_PROC : process (CLK,ASYNC_RESET_L) begin
  		if (ASYNC_RESET_L = '0') then 
  			edge_Detect_half_clk <= '0';
  		elsif rising_edge(CLK) then
  			if SYNC_RESET ='1' then 
  				edge_Detect_half_clk <= '0';
  			else
  			    edge_Detect_half_clk <= HALFCLK;
  			end if;
  		else
  		end if;
  	end process GENSTART_STOP_PROC;
  	
  	SENDBITS_PROC : process (CLK,ASYNC_RESET_L) begin
  		if (ASYNC_RESET_L = '0') then 
--  			edge_Detect_half_clk <= '0';
  			bitCounter <= 0;
  		elsif rising_edge(CLK) then
  			if SYNC_RESET ='1' then 
--  				edge_Detect_half_clk <= '0';
  				bitCounter <= 0;
  			else
  			    if(sendBits = '1') then
  			    	-- shifts in rising edge halfclock
  			    	if edge_Detect_half_clk = '0' and HALFCLK = '1' then
  			    	    --SRG24SHIFT <= '1';
  			    	    bitCounter <= bitCounter + 1;
  			    	else
  			    	    --SRG24SHIFT <= '0';
  			    	end if;
  			    	if bitCounter = 8 then
  			    		--sendBits_ready <= '1';
  			    		bitCounter <= 0;
					end if;
  			   	else
					--sendBits_ready <= '0';
  			    	bitCounter <= 0;
  			   	    --SRG24SHIFT <= '0';
  			    end if;
  			    
--  			    edge_Detect_half_clk <= HALFCLK;
  			end if;
  		end if;
  	end process SENDBITS_PROC;
  
  	CHECK_ACK_PROC : process (CLK,ASYNC_RESET_L) begin
  		if (ASYNC_RESET_L = '0') then 
  			wordCounter <= 0;
  			ackCounter <= 0;
  			checkAck_ready <= '0';  			
  		elsif rising_edge(CLK) then
  			if SYNC_RESET ='1' then 
 	 			wordCounter <= 0;
  				ackCounter <= 0;
  				checkAck_ready <= '0';   		
  			else
  			    if checkAck = '1' then
  			    	-- read ack in falling edge halfclock
  			    	if edge_Detect_half_clk = '1' and HALFCLK = '0' and ackIn = '0' then
  			    	    ackCounter <= ackCounter + 1;
  			    	end if;
  			    	if wordCounter = 3 then
					   wordCounter <= 0;
					end if;	
  			    	if edge_Detect_half_clk = '0' and HALFCLK = '1' then
  			    		checkAck_ready <= '1';
  			    		wordCounter <= wordCounter + 1;
					end if;

				elsif ackCounter_reset = '1' then
				    ackCounter <= 0;				
  			   	else
					checkAck_ready <= '0';
				   	ackCounter <= ackCounter;
  			    	wordCounter <= wordCounter;
  			    end if;
  			    
  			    
  			end if;
  		else
  		end if;
  	end process CHECK_ACK_PROC;
  		
  	i2ccStatusReg_PROC : process (CLK,ASYNC_RESET_L) begin
  		if (ASYNC_RESET_L = '0') then 
  			i2ccStatus_reg <= '0';			
  		elsif rising_edge(CLK) then
  			if SYNC_RESET ='1' then 
				i2ccStatus_reg <= '0';  		
  			else
  				if set_i2ccStatus_reg = '1' then
  					if ackCounter = 3 then
  						i2ccStatus_reg <= '1';
  					else
  						i2ccStatus_reg <= '0';
  					end if;
  					--ackCounter_reset <= '1'; 
  				else
  					--ackCounter_reset <= '0';
  					i2ccStatus_reg <= i2ccStatus_reg;
  				end if;
  			end if;	
  		end if;
  	end process i2ccStatusReg_PROC;
  		  	
  		
  	outputMUX : process (I2C_SDAT,SRG24(23),sel_Condition,start_end_to_mux) begin
  		case sel_Condition is
  			when data =>
  				I2C_SDAT <= SRG24(23);
  			when start_end =>
  				I2C_SDAT <= start_end_to_mux;
  			when ack =>
  				I2C_SDAT <= 'Z';
  		end case;
  		
  	end process outputMUX;
  			
	
 	s_sclk <= '1' when CTRN_r < SCLKRISE else '0';
 	I2C_SCLK <= s_sclk;
 	ackIn <= I2C_SDAT;
	I2CC_STATUS <= i2ccStatus_reg;

	start_end_to_mux <= '0' when genStartCondition = '1' and  HALFCLK = '0' else '1';
	start_gen_ready <= '1' when genStartCondition = '1' and edge_Detect_half_clk = '0' and HALFCLK = '1' else '0';
  	stop_gen_ready <= '1' when genStopCondition = '1' and edge_Detect_half_clk = '0' and HALFCLK = '1' else '1';
  	
  	SRG24SHIFT <= '1' when sendBits = '1' and edge_Detect_half_clk = '0' and HALFCLK = '1' else '0';
  	sendBits_ready <= '1' when sendBits = '1' and bitCounter = 8 else '0';
  	
  	ackCounter_reset <= '1' when set_i2ccStatus_reg = '1' else '0';  	

end RTL;









