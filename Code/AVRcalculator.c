/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 1/15/2019
Author  : 
Company : 
Comments: 


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/

#include <mega32.h>
#include <stdlib.h>
#include <delay.h>
#include <string.h>


// Alphanumeric LCD functions
#include <alcd.h>

char scankp();
void showlcd();
void clear();
float cal();

// Declare your global variables here
float answer = 13.4;
float h_answer = 0; //saved answer from last process
int index = 0;
int state = 0; // 0 for input mode 1 for output mode
int  s = 1,c = 0;
char input ;
char inarray[20] ;
char str[16];
int t = 0;
char keys[4][6]={{'c','7','8','9','*','/'},{'a','4','5','6','-','m'},{'(','1','2','3','+','p'},{')','0','.','=','+','n'}};
// KEYPAD . OUTPUT ROWS AND INPUT COLS. INPUTS ARE PULLD UP INTERNALLY 
#define ROW1 PORTD.2
#define ROW2 PORTD.3
#define ROW3 PORTD.4
#define ROW4 PORTD.5
#define COL1 PINC.0
#define COL2 PINC.1
#define COL3 PINC.2    
#define COL4 PINC.3
#define COL5 PINC.4
#define COL6 PINC.5


#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)
#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)

// USART Receiver buffer
#define RX_BUFFER_SIZE 8
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE <= 256
unsigned char rx_wr_index=0,rx_rd_index=0;
#else
unsigned int rx_wr_index=0,rx_rd_index=0;
#endif

#if RX_BUFFER_SIZE < 256
unsigned char rx_counter=0;
#else
unsigned int rx_counter=0;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer[rx_wr_index++]=data;
#if RX_BUFFER_SIZE == 256
   // special case for receiver buffer size=256
   if (++rx_counter == 0) rx_buffer_overflow=1;
#else
   if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   if (++rx_counter == RX_BUFFER_SIZE)
      {
      rx_counter=0;
      rx_buffer_overflow=1;
      }
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index++];
#if RX_BUFFER_SIZE != 256
if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#endif
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif

// Standard Input/Output functions
#include <stdio.h>

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Place your code here
t++;
if(t>500){
    t=0;
}

}

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=In Bit6=In Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit7=T Bit6=T Bit5=P Bit4=P Bit3=P Bit2=P Bit1=P Bit0=P 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (1<<PORTC3) | (1<<PORTC2) | (1<<PORTC1) | (1<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 125.000 kHz
// Mode: CTC top=OCR0
// OC0 output: Disconnected
// Timer Period: 1 ms
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (1<<WGM01) | (0<<CS02) | (1<<CS01) | (1<<CS00);
TCNT0=0x00;
OCR0=0x7C;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x33;

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTB Bit 0
// RD - PORTB Bit 1
// EN - PORTB Bit 2
// D4 - PORTB Bit 3
// D5 - PORTB Bit 4
// D6 - PORTB Bit 5
// D7 - PORTB Bit 6
// Characters/line: 16
lcd_init(16);

// Global enable interrupts
#asm("sei")

while (1)
      {
      // Place your code here 
        if(state == 0){ // input mode
            input = scankp();
            if((input != '=' && input != 'c' && input <= 58 && input >= 40) || input == 'a'){
                inarray[index] = input; 
                inarray[index+1] = 0;
                if(index < 19){
                    index++;    
                }
                
            } 
             
            if(input == 'c'){
                clear();
            }
             
            if(input == '='){
                state = 1; 
                answer = cal();
                h_answer = answer;
                lcd_clear();
            }
            showlcd();
        }    
        
        if(state == 1){  
           if((input = scankp()) == 'c'){
                clear();
                state = 0;
           }
           showlcd(); 
        }        


      }
}
char scankp(){ //a function that scans the keypad and returns proper input
    int i = 0, j = 0;
if( c == 0){
    if(s == 1){
          ROW1 = 0;
          ROW2 = 1;
          ROW3 = 1;
          ROW4 = 1;
          i = 0;   
          if(COL1 == 0){
            j = 0;      
            c = 1; 
            t = 0;
            return keys[i][j];
          }
          if(COL2 == 0){
            j = 1;
            c = 1;
            t = 0;
            return keys[i][j];
          }
          if(COL3 == 0){
            j = 2; 
            c = 1;
            t = 0;
            return keys[i][j];
          }
          if(COL4 == 0){
            j = 3;   
            c = 1;
            t = 0;
            return keys[i][j];
          }
          if(COL5 == 0){
            j = 4; 
            c = 1;
            t = 0;
            return keys[i][j];
          }
          if(COL6 == 0){
            j = 5;    
            c = 1;
            t = 0;
            return keys[i][j];
          }          
          s = 2;
          return -1;   
    } 
    
    if(s == 2){
          ROW1 = 1;
          ROW2 = 0;
          ROW3 = 1;
          ROW4 = 1;
          i = 1;   
          if(COL1 == 0){
            j = 0;  
            c = 1;
            t = 0;
            return keys[i][j];
          }
          if(COL2 == 0){
            j = 1;
            c = 1;
            t = 0;
            return keys[i][j];
          }
          if(COL3 == 0){
            j = 2;
            c = 1;
            t = 0;
            return keys[i][j];
          }
          if(COL4 == 0){
            j = 3;
            c = 1;
            t = 0;
            return keys[i][j];
          }
          if(COL5 == 0){
            j = 4;
            c = 1;
            t = 0;
            return keys[i][j];
          }
          if(COL6 == 0){
            j = 5; 
            c = 1;
            t = 0;
            return keys[i][j];
          }
          s = 3; 
          return -1; 
          
    }
    
     if(s == 3){
          ROW1 = 1;
          ROW2 = 1;
          ROW3 = 0;
          ROW4 = 1;
          i = 2;   
          if(COL1 == 0){
            j = 0;  
            c = 1;
            t = 0;
            return keys[i][j];
          }
          if(COL2 == 0){
            j = 1;
            c = 1;
            t = 0;
            return keys[i][j];
          }
          if(COL3 == 0){
            j = 2;  
            c = 1;
            t = 0;
            return keys[i][j];
          }
          if(COL4 == 0){
            j = 3;
            c = 1;
            t = 0;
            return keys[i][j];
          }
          if(COL5 == 0){
            j = 4;
            c = 1;
            t = 0;
            return keys[i][j];
          }
          if(COL6 == 0){
            j = 5;
            c = 1;
            t = 0;
            return keys[i][j];
          }
          s = 4; 
          return -1; 
          
    }  
    
     if(s == 4){
          ROW1 = 1;
          ROW2 = 1;
          ROW3 = 1;
          ROW4 = 0;
          i = 3;   
          if(COL1 == 0){
            j = 0;  
            c = 1;
            t = 0;
            return keys[i][j];
          }
          if(COL2 == 0){
            j = 1;
            c = 1;
            t = 0;
            return keys[i][j];
          }
          if(COL3 == 0){
            j = 2; 
            c = 1;
            t = 0;
            return keys[i][j];
          }
          if(COL4 == 0){
            j = 3;
            c = 1;
            t = 0;
            return keys[i][j];
          }
          if(COL5 == 0){
            j = 4;  
            c = 1;
            t = 0;
            return keys[i][j];
          }
          if(COL6 == 0){
            j = 5;
            c = 1;
            t = 0;
            return keys[i][j];
          }            
          s = 1;
          return -1; 
    } 
}
    
if(t > 250){
    c = 0;
}            
    
}
void clear(){
      
    inarray[0] = 0;
    index = 0;
    lcd_clear();
}
void showlcd(){
    //int j = 0;

     if(state == 0){ //input mode 
      lcd_gotoxy(0,0);
    /*  for(j = 0; j <= index; j++){
        if(inarray[j] != 0){
            sprintf(str,"%c",inarray[j]);
            lcd_puts(str);
        }                 
      }   
      */
      lcd_puts(inarray);      
     }    
     
     if(state == 1){
        lcd_gotoxy(0,0);
        lcd_putsf("=");   
        sprintf(str," %6.2f",answer);                         
        lcd_puts(str);
     }
}
float cal(){

    int paran = 1;// if it contains parans 
    int size = 0;
    int muldive = 1; // if it contains mults and divisions
    int subsum = 1; //if it contains subs and sums 
    int err = 0;
    int i = 0;
    int j = 0; 
    int k = 0;
    int iop = 0; //opening paran index
    int icp = 0; //closing paran index
    char tempreschar[10]; //temp result of each part 
    float tempresint; 
    char chars[15][8]; // seperated nums and ops
    char temp[15][8]; // temp char used for parans 
    int tempsize = 0; // size of temp char
    float numbers[10]; // in order to sort ops and numbers in from left to right  
    for(i = 0; i < strlen(inarray); i++){
        if(inarray[i] == '+' || inarray[i] == '-' || inarray[i] == '*' || inarray[i] == '/' || inarray[i] == '(' || inarray[i] == ')'){
           
            chars[j][0] = inarray[i];
            chars[j][1] = 0;
            if(i < strlen(inarray)-1)
            j++; 
          
        }  
        else if((inarray[i] < 58 && inarray[i] > 47) || inarray[i] == '.'){  //agar adad bood
          
            chars[j][k] = inarray[i]; 
            k++;
             if(i+1 < strlen(inarray)){ 
                if(!((inarray[i+1] < 58 && inarray[i+1] > 47) || inarray[i+1] == '.')){   //agar adad nabood
                      
                      chars[j][k] = 0;
                      if(i < strlen(inarray)-1)
                      j++;
                      k = 0;
                }
            }  
          
        }
        else if(inarray[i] == 'a'){
            sprintf(chars[j],"%f",h_answer);
            chars[j][strlen(chars[j])-1] = 0;
            if(i < strlen(inarray)-1)
            j++;
        }
    } 
   
    size = j;  
    chars[size+1][0] = 0;
    
    while(paran == 1){
        paran = 0;
        for(i = 0; i <= size; i++){
            if(chars[i][0] == ')'){
                paran = 1;
                icp = i;
                break;
                
            }
        } 
        for(i = size; i >= 0; i--){
            if(chars[i][0] == '(' && i < icp){
                iop = i; 
                tempsize = icp - iop - 2;
                break;
            }
        } 
        
        for(i = 0; i < icp - iop - 1; i++){    //extracting inside of the paran into temp
            strncpy(temp[i],chars[iop+i+1],8); 
                
        }    
        
        
        if(paran == 1){ 
          //------------------------------------------------------ calculating paran     
             while(muldive == 1){ 
                    muldive = 0;
                    for(i = 0; i <= tempsize; i++){   
                      
                        if(temp[i][0] == '*'){ 

                            muldive = 1;
                            tempresint = atof(temp[i-1])*atof(temp[i+1]); 
                            sprintf(tempreschar,"%1.1f",tempresint); 
                            strncpy(temp[i-1],tempreschar,8);
                            for(j = i + 2 ; j <= tempsize; j++){
                                strncpy(temp[j-2],temp[j],8);
                            }   
                            temp[tempsize-1][0] = 0;
                            tempsize = tempsize - 2; 
                            break;
                        }  
                        
                         if(temp[i][0] == '/'){  
                            muldive = 1;
                            tempresint = atof(temp[i-1])/atof(temp[i+1]); 
                            if(atof(temp[i+1]) == 0){ //taghsim bar sefr
                                err = 1;
                                break;
                            }
                            sprintf(tempreschar,"%1.1f",tempresint);    
                            strncpy(temp[i-1],tempreschar,10);
                            for(j = i + 2 ; j <= tempsize; j++){
                                strncpy(temp[j-2],temp[j],8);
                            }   
                            temp[size-1][0] = 0;
                            tempsize = tempsize - 2; 
                            break;
                        }   
                        if(err == 1){
                            break;
                        }
                     } 
          
             }
                 while(subsum == 1){ 
                    subsum = 0;
                    for(i = 0; i <= tempsize; i++){   
                      
                        if(temp[i][0] == '+'){ 

                            subsum = 1;
                            tempresint = atof(temp[i-1])+atof(temp[i+1]); 
                            sprintf(tempreschar,"%1.1f",tempresint); 
                            strncpy(temp[i-1],tempreschar,10);
                            for(j = i + 2 ; j <= tempsize; j++){
                                strncpy(temp[j-2],temp[j],8);
                            }   
                            temp[tempsize-1][0] = 0;
                            tempsize = tempsize - 2; 
                            break;
                        }  
                        
                         if(temp[i][0] == '-' && temp[i][1] ==0){  
                            subsum = 1;    
                            lcd_putsf("ok");
                            tempresint = atof(temp[i-1])-atof(temp[i+1]);  
                            sprintf(tempreschar,"%1.1f",tempresint);            
                            strncpy(temp[i-1],tempreschar,10);
                            for(j = i + 2 ; j <= tempsize; j++){
                                strncpy(temp[j-2],temp[j],8);
                            }   
                            temp[tempsize-1][0] = 0;
                            tempsize = tempsize - 2; 
                            break;
                        }
                    } 
                      
                }           
                if(err == 1)
                break;
                //-------------------------------------------------- end of calculating paran
                strncpy(chars[iop],temp[0],8); 
                size = size - (icp - iop);           //replacing the paran with its value
                for( i = iop+1 ; i <= size; i++){ 
                    strncpy(chars[i],chars[i + (icp - iop)],8);   
                }
                for(i = size+1; i < 15; i ++){
                    chars[i][0] = 0;
                }                  
                
              
        } 
        
        if(err == 1)
        break;
        muldive = 1;
        subsum = 1;  
    }     
  
   
    
    
    
              
    while(muldive == 1){ 
        muldive = 0;
        for(i = 0; i <= size; i++){   
          
            if(chars[i][0] == '*'){ 

                muldive = 1;
                tempresint = atof(chars[i-1])*atof(chars[i+1]); 
                sprintf(tempreschar,"%f",tempresint); 
                strncpy(chars[i-1],tempreschar,8);
                for(j = i + 2 ; j <= size; j++){
                    strncpy(chars[j-2],chars[j],8);
                }   
                chars[size-1][0] = 0;
                size = size - 2; 
                break;
            }  
            
             if(chars[i][0] == '/'){  
                muldive = 1;
                tempresint = atof(chars[i-1])/atof(chars[i+1]); 
                if(atof(chars[i+1]) == 0){ //taghsim bar sefr
                    err = 1;
                    break;
                }
                sprintf(tempreschar,"%f",tempresint);    
                strncpy(chars[i-1],tempreschar,10);
                for(j = i + 2 ; j <= size; j++){
                    strncpy(chars[j-2],chars[j],8);
                }   
                chars[size-1][0] = 0;
                size = size - 2; 
                break;
            }   
            if(err == 1){
                break;
            }
        } 
          
    }
     while(subsum == 1){ 
        subsum = 0;
        for(i = 0; i <= size; i++){   
          
            if(chars[i][0] == '+'){ 

                subsum = 1;
                tempresint = atof(chars[i-1])+atof(chars[i+1]); 
                sprintf(tempreschar,"%f",tempresint); 
                strncpy(chars[i-1],tempreschar,10);
                for(j = i + 2 ; j <= size; j++){
                    strncpy(chars[j-2],chars[j],8);
                }   
                chars[size-1][0] = 0;
                size = size - 2; 
                break;
            }  
            
             if(chars[i][0] == '-' && chars[i][1] ==0){  
                subsum = 1;
                tempresint = atof(chars[i-1])-atof(chars[i+1]);  
                sprintf(tempreschar,"%f",tempresint);            
                strncpy(chars[i-1],tempreschar,10);
                for(j = i + 2 ; j <= size; j++){
                    strncpy(chars[j-2],chars[j],8);
                }   
                chars[size-1][0] = 0;
                size = size - 2; 
                break;
            }
        } 
          
    }
    numbers[0] = atof(chars[0]);
    if(err == 0){
        return numbers[0];
    } 
    else{
        clear();
        lcd_putsf("ERROR");
        delay_ms(2000);
        clear();
        state = 0;
    }
        
    
}
