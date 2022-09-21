import pkg::*;
`timescale 1ns/100ps
module tb();
	
	
	logic i_board_clk;
	
	logic o_spi_clk;
	logic o_cs_n;
	wire io_spi_data;
	logic i_enb;
	///////////////////////
	logic w_clk;
	logic w_locked;
	logic w_clk_enb;
	spi_states state;
	spi_states next;
	logic r_spi_data;
	logic w_master_busy;
	logic r_init_done;
	logic [16:0] r_shift_reg;
	logic tx_spi;
	logic [5:0] r_counter;
	//////////////////////
	
	
	
	initial begin
		i_board_clk <= 1'b0;
		i_enb <= 0;
		tx_spi <= 0;
	end
	
	always begin
		#10;
		i_board_clk <= !i_board_clk;
	end
	
	top DUT(
		.*
	);
	
	assign io_spi_data = (!w_master_busy) ? tx_spi : 1'bz;
	
	
	initial begin
		repeat(50) @(posedge i_board_clk);
		i_enb <= 1'b1;
		#10000;
		i_enb <= 1'b0;
		#2000;
		$stop();
	end
	
	
endmodule 