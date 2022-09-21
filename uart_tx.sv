import pkg::*;
module uart_tx 
(i_clk, i_data_tx, i_enb_tx, o_data_tx, o_ready_tx);
	
	input i_clk;
	input [DATA_BITS-1:0] i_data_tx;
	input i_enb_tx;
	
	output reg o_data_tx;
	output o_ready_tx;
//-------------------------------------------------------
	reg [$clog2(TICK_NBR)-1:0] ticks_count_tx;
	reg [$clog2(DATA_BITS+2)-1:0] bits_count_tx;
	uart_states state_tx;
	uart_states next_tx;
	reg [DATA_BITS-1:0] tmp_data_tx;
//-------------------------------------------------------	
	
	initial begin
		state_tx <= UART_IDLE;
		ticks_count_tx <= 0;
		bits_count_tx <= 0;
		o_data_tx <= 1;
		tmp_data_tx <= 0;
	end
	
	assign o_ready_tx = (state_tx == UART_IDLE) ? 1'b1 : 1'b0;
	
	always@(*) begin
		case(state_tx)
		UART_IDLE:begin
			if(i_enb_tx)
				next_tx = UART_START;
			else
				next_tx = UART_IDLE;
		end
		UART_START: begin
			if(ticks_count_tx == TICK_NBR-1)
				next_tx = UART_DATA;
			else
				next_tx = UART_START;
		end
		UART_DATA: begin
			if(bits_count_tx == DATA_BITS)
				next_tx = UART_STOP;
			else
				next_tx = UART_DATA;
		end
		UART_STOP: begin
			if(bits_count_tx == DATA_BITS + STOP_BITS)
				next_tx = UART_IDLE;
			else
				next_tx = UART_STOP;
		end
		endcase
	end
	
	always @(posedge i_clk) begin
		state_tx <= next_tx;
	end
	
	always @(posedge i_clk) begin
		case (state_tx)
			UART_IDLE:
			begin
				ticks_count_tx <= 0;
				bits_count_tx <= 0;
				o_data_tx <= 1;
				tmp_data_tx <= i_data_tx;
			end
			
			UART_START:
			begin
				o_data_tx <= 0;
				if (ticks_count_tx == TICK_NBR-1)
					ticks_count_tx <= 0;
				else
					ticks_count_tx <= ticks_count_tx + 1'b1;
			end
			
			UART_DATA:
			begin
				o_data_tx <= tmp_data_tx[0];
				if (ticks_count_tx == TICK_NBR-1) begin
					bits_count_tx <= bits_count_tx + 1'b1;
					if (bits_count_tx != DATA_BITS - 1)
						tmp_data_tx <= tmp_data_tx >> 1;
					ticks_count_tx <= 0;
				end
				else begin
					ticks_count_tx <= ticks_count_tx + 1'b1;
				end
				
				if (bits_count_tx == DATA_BITS)
					o_data_tx <= 1'b1;
				
			end
			
			UART_STOP:
			begin
				if (ticks_count_tx == TICK_NBR-1) begin
					bits_count_tx <= bits_count_tx + 1'b1;
					ticks_count_tx <= 0;
				end
				else begin
					ticks_count_tx <= ticks_count_tx + 1'b1;
				end
				
			end
			
			
		endcase
	end
	
endmodule 