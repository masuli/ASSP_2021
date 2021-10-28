//============================================================================
// Name        : program.c
// Author      : Ilkka Hautala
// Version     : 1.0
// Description : DE2 AUDIO CODEC TTA TEST PROGRAM 
//			   :
//			   :
//			   : 
//============================================================================

#include "tceops.h"

#define WM8731_I2C_ADDRESS      0b00110100 
//                              <--Addr--><---operation-->
#define WM8731_POWER_ON         0b001101000000110000000000
#define WM8731_DATA_FORMAT      0b001101000000111000000001 //MSB-first left-justified; 16-bits; slave-mode
#define WM8731_SAMPLE_RATE      0b001101000001000000000000 //Normal mode; BOSR = 256fs; SR = 48kHz/48kHz, 12.288 Mhz
                                                           //If you want change sample rate see pages 38-39 of WM8731 datasheet
                                                           
#define WM8731_ACTIVATE         0b001101000001001000000001 //Activate interface
#define WM8731_DEACTIVE         0b001101000001001000000000 //Deactivate interface
#define WM8731_LEFT_LINE_IN     0b001101000000000000010111 //Left-line in: Disable simultaneous L+R control;mute;default volume
#define WM8731_RIGHT_LINE_IN    0b001101000000001000010111 //Right-line in: Disable simultaneous L+R control;mute;default volume
#define WM8731_ANALOG_PATH      0b001101000000100000010010 //Line input, DAC, disable boost
#define WM8731_DIGITAL_PATH     0b001101000000101000000110 //Mic input, DAC, enable boost
#define WM8731_HEADPHONES_LEFT  0b001101000000010011111001 //Left hp: Disable simult.; enable zero-cross; medium volume
#define WM8731_HEADPHONES_RIGHT 0b001101000000011011111001 //Right hp: Disable simult.; enable zero-cross; medium volume




//4 BIT FILTER COEFFS
#define A48                     3
#define B0                      5
#define B48                     -5
#define DELAYLINELEN            49


int main(void){

    /*INITIALIZE AUDIO CODEC USING I2C*/
    volatile unsigned char lock = 2;
    
    _TCE_I2C_WRITE(WM8731_DATA_FORMAT);	//Write codec settings using I2C
    while(lock != 1){_TCE_I2C_STATUS(0,lock);} //Wait for that I2C slave send "data transmission ready signal"

    _TCE_I2C_WRITE(WM8731_SAMPLE_RATE);
    _TCE_I2C_STATUS(0,lock);
    while(lock != 1){_TCE_I2C_STATUS(0,lock);}
     
    _TCE_I2C_WRITE(WM8731_LEFT_LINE_IN);
    _TCE_I2C_STATUS(0,lock);
    while(lock != 1){_TCE_I2C_STATUS(0,lock);}
 
    _TCE_I2C_WRITE(WM8731_RIGHT_LINE_IN);
    _TCE_I2C_STATUS(0,lock);
    while(lock != 1){_TCE_I2C_STATUS(0,lock);}
    
    _TCE_I2C_WRITE(WM8731_ANALOG_PATH);
    _TCE_I2C_STATUS(0,lock);
    while(lock != 1){_TCE_I2C_STATUS(0,lock);}
    
    _TCE_I2C_WRITE(WM8731_DIGITAL_PATH);
    _TCE_I2C_STATUS(0,lock);
    while(lock != 1){_TCE_I2C_STATUS(0,lock);}
    
    _TCE_I2C_WRITE(WM8731_HEADPHONES_LEFT);
	_TCE_I2C_STATUS(0,lock);
    while(lock != 1){_TCE_I2C_STATUS(0,lock);}
    
    _TCE_I2C_WRITE(WM8731_HEADPHONES_RIGHT);
	_TCE_I2C_STATUS(0,lock);
    while(lock != 1){_TCE_I2C_STATUS(0,lock);}
    
    _TCE_I2C_WRITE(WM8731_POWER_ON);
	_TCE_I2C_STATUS(0,lock);
    while(lock != 1){_TCE_I2C_STATUS(0,lock);}
    
    _TCE_I2C_WRITE(WM8731_ACTIVATE);
	_TCE_I2C_STATUS(0,lock);
    while(lock != 1){_TCE_I2C_STATUS(0,lock);}
    /*END OF INITIALIZE AUDIO CODEC USING I2C*/ 
     
    volatile short sampleReady = 0; //Sample ready flag, must be volatile. 
    
    int delayLineL[DELAYLINELEN];
    int delayLineR[DELAYLINELEN];
          
    for(int i=0; i<DELAYLINELEN; i++){
       delayLineL[i] = 0;
       delayLineR[i] = 0;
    }
     
    short sampleL;
    short sampleR;
    int xnL;
    int xnR;
    int wnL;
    int wnR;
    int ynL;
    int ynR;
     
     // AUDIO PROCESSING LOOP
     while(1){
        
        for(int i=0 ; i<DELAYLINELEN; i++){  
		    
		    while(sampleReady == 0){_TCE_AUD_STATUS(0,sampleReady);} //Wait new audio samples
		    _TCE_AUD_READ_L(0,sampleL);	 //read left channel sample to sampleL variable
		    _TCE_AUD_READ_R(0,sampleR);	 //read right channel sample to sampleR variable
		    
		    //START DATA PROCESSING
		    xnL = (int) sampleL;
		    wnL = xnL + ((delayLineL[(i+1)%DELAYLINELEN]*A48)>>3);
		    delayLineL[i%DELAYLINELEN] = wnL;
		    ynL = ((wnL*B0)>>3) + ((delayLineL[(i+1)%DELAYLINELEN]*B48)>>3);

		    xnR = (int) sampleR;
		    wnR = xnR + ((delayLineR[(i+1)%DELAYLINELEN]*A48)>>3);
		    delayLineR[i%DELAYLINELEN] = wnR;
		    ynR = ((wnR*B0)>>3) + ((delayLineR[(i+1)%DELAYLINELEN]*B48)>>3);         
		    //END DATA PROCESSING
		                      
		    _TCE_AUD_WRITE_L(ynL>>1); //write processed left channel sample to audio output
		    _TCE_AUD_WRITE_R(ynR>>1); //write processed right channel sample to audio output
		    _TCE_AUD_STATUS(0,sampleReady); //check if new samples is already present
     	}
     }
     


return 0;
}
