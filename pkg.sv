package pkg;
	
	//////////////	SPI	/////////////////////////////////////////////
	typedef enum {IDLE,INIT,STOP,WAIT,READ_DATA,POWER} spi_states;
	
	parameter WRITE_BIT = 1'b0;
	parameter READ_BIT = 1'b1;
	parameter MB_NO = 1'b0;
	parameter MB_YES = 1'b1;
	parameter ADDR_DATA_FORMAT = 6'h31;
	parameter VAL_DATA_FORMAT = 8'b01000000;
	parameter INIT_VAL = {WRITE_BIT,MB_NO,ADDR_DATA_FORMAT,VAL_DATA_FORMAT,1'b1,8'b00000000,8'b00000000,8'b00000000,8'b00000000,8'b00000000};
	
	
	parameter ADDR_Y0 = 6'h32;
	parameter READ_VAL = {READ_BIT,MB_YES,ADDR_Y0,8'b00000000,8'b00000000,8'b00000000,8'b00000000,8'b00000000,8'b00000000,1'b1};
	
	parameter ADDR_POWER = 6'h2d;
	parameter POWER_DATA = 8'b00001000;
	parameter POWER_VAL = {WRITE_BIT,MB_NO,ADDR_POWER,POWER_DATA,1'b1,8'b00000000,8'b00000000,8'b00000000,8'b00000000,8'b00000000};
	
	/////////////	UART	///////////////////////////////////////////
	parameter DATA_BITS = 8;
	parameter STOP_BITS = 1;
	parameter integer CLK_FREQ = 5_000_000;
	parameter integer BAUD_RATE = 19200;
	parameter integer TICK_NBR = CLK_FREQ/BAUD_RATE;
	
	typedef enum {UART_IDLE,UART_START,UART_DATA,UART_STOP} uart_states;
	
endpackage 