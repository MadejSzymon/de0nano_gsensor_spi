import pkg::*;
module top(i_board_clk,i_enb,o_spi_clk, io_spi_data,o_cs_n, o_led, o_data_tx);
	
	input i_board_clk;
	input i_enb;
	
	inout io_spi_data;
	output [7:0] o_led;
	output o_spi_clk;
	output o_cs_n;
	output o_data_tx;
	///////////////////////
	logic w_clk;
	logic w_locked;
	logic w_spi_clk;
	logic w_clk_enb;
	logic w_meas_clk;
	logic w_uart_enb;
	logic w_ready_tx;
	logic [56:0] r_data;
	//////////////////////
	
	assign o_spi_clk = (w_clk_enb) ? w_spi_clk : 1'b1;
	assign o_led = r_data[56:48];
	
	pll	pll_inst (
		.areset ( 1'b0 ),
		.inclk0 ( i_board_clk),
		.c0 ( w_spi_clk ),
		.c1 ( w_clk ),
		.c2 (w_meas_clk),
		.locked ( w_locked )
	);
	
	spi_controller spi_controller(
		.i_clk(w_clk),
		.i_enb(i_enb),
		.io_spi_data(io_spi_data),
		.o_clk_enb(w_clk_enb),
		.o_cs_n(o_cs_n),
		.r_data(r_data),
		.o_uart_enb(w_uart_enb),
		.i_ready_tx(w_ready_tx)
);

	uart_tx uart_tx(
		.i_clk(w_clk),
		.i_data_tx(r_data[56:48]),
		.i_enb_tx(w_uart_enb),
		.o_data_tx(o_data_tx), 
		.o_ready_tx(w_ready_tx)
	);
	
	

	
endmodule 