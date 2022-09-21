import pkg::*;
module spi_controller(i_clk, i_enb, io_spi_data, o_clk_enb, o_cs_n, r_data, o_uart_enb, i_ready_tx);
	
	input i_clk;
	input i_enb;
	input i_ready_tx;
	inout io_spi_data;
	
	output logic o_clk_enb = 0;
	output logic o_cs_n = 1'b1;
	output logic [56:0] r_data = 0;
	output logic o_uart_enb = 0;
	////////////////////////////
	spi_states state = IDLE;
	spi_states next;
	//logic i_spi_data;
	logic r_spi_data = 0;
	logic w_master_busy;
	logic r_init_done = 0;
	logic [56:0] r_shift_reg = INIT_VAL;
	logic [5:0] r_counter = 0;
	integer i;
	logic r_power_done = 0;
	logic [14:0] r_wait_counter = 0;
	logic [2:0] r_uart_counter = 0;
	logic r_uart_enb = 0;
	////////////////////////////
	
	assign io_spi_data = (w_master_busy) ? r_spi_data : 1'bz;
	
always@(*) begin
		case(state)
			IDLE: begin
				o_cs_n = 1'b1;
				if(i_enb && !r_init_done)
					next = INIT;
				else if(i_enb && r_init_done)
					next = READ_DATA;
				else
					next = IDLE;
			end
			INIT: begin
				o_cs_n = 1'b0;
				if(r_shift_reg == 0)
					next = STOP;
				else
					next = INIT;
			end
			STOP: begin
				o_cs_n = 1'b0;
				next = WAIT;
			end
			WAIT: begin
				o_cs_n = 1'b1;
				if(i_enb && r_power_done && r_wait_counter == 0)
					next = READ_DATA;
				else if(i_enb && !r_power_done)
					next = POWER;
				else if(r_wait_counter == 0)
					next = IDLE;
				else 
					next = WAIT;
			end
			READ_DATA: begin
				o_cs_n = 1'b0;
				if(r_shift_reg == 0)
					next = STOP;
				else
					next = READ_DATA;
			end
			POWER: begin
				o_cs_n = 1'b0;
				if(r_shift_reg == 0)
					next = STOP;
				else
					next = POWER;
			end
		endcase
	end
	
	always@(posedge i_clk)
		state <= next;
		
	always@(negedge i_clk) begin
		case(state)
			IDLE: begin
				r_counter <= 0;
			end
			INIT: begin
				o_clk_enb <= 1'b1;
				r_init_done <= 1'b1;
				r_spi_data <= r_shift_reg[56];
				for(i=1;i<57;i++) begin
					r_shift_reg[i] <= r_shift_reg[i-1];
				end
				r_shift_reg[0] <= 0;
				r_counter <= r_counter + 1'b1;
			end
			STOP: begin
				r_wait_counter <= 1;
				o_clk_enb <= 0;
				if(!r_power_done)
					r_shift_reg <= POWER_VAL;
				else begin
					r_shift_reg <= READ_VAL;
				end
				r_counter <= 0;
				r_uart_counter <= 0;
			end
			WAIT: begin
				r_wait_counter <= r_wait_counter + 1'b1;
				if (i_ready_tx && r_uart_counter <= 6) begin
					o_uart_enb <= 1;
					r_uart_counter <= r_uart_counter + 1'b1;
				end
				else
					o_uart_enb <= 0;
			end
			READ_DATA: begin
				o_clk_enb <= 1'b1;
				r_spi_data <= r_shift_reg[56];
				for(i=1;i<57;i++) begin
					r_shift_reg[i] <= r_shift_reg[i-1];
				end
				r_shift_reg[0] <= 0;
				r_counter <= r_counter + 1'b1;
			end
			POWER: begin
				o_clk_enb <= 1'b1;
				r_power_done <= 1'b1;
				r_spi_data <= r_shift_reg[56];
				for(i=1;i<57;i++) begin
					r_shift_reg[i] <= r_shift_reg[i-1];
				end
				r_shift_reg[0] <= 0;
				r_counter <= r_counter + 1'b1;
			end
		endcase
	end
	
	always@(posedge i_clk) begin
		r_uart_enb <= o_uart_enb;
		if(state == READ_DATA) begin
			case(r_counter)
			9:	r_data[7] <= io_spi_data;
			10:r_data[6] <= io_spi_data;
			11:r_data[5] <= io_spi_data;
			12:r_data[4] <= io_spi_data;
			13:r_data[3] <= io_spi_data;
			14:r_data[2] <= io_spi_data;
			15:r_data[1] <= io_spi_data;
			16:r_data[0] <= io_spi_data;
			
			17:r_data[15] <= io_spi_data;
			18:r_data[14] <= io_spi_data;
			19:r_data[13] <= io_spi_data;
			20:r_data[12] <= io_spi_data;
			21:r_data[11] <= io_spi_data;
			22:r_data[10] <= io_spi_data;
			23:r_data[9] <= io_spi_data;
			24:r_data[8] <= io_spi_data;
			
			25:r_data[23] <= io_spi_data;
			26:r_data[22] <= io_spi_data;
			27:r_data[21] <= io_spi_data;
			28:r_data[20] <= io_spi_data;
			29:r_data[19] <= io_spi_data;
			30:r_data[18] <= io_spi_data;
			31:r_data[17] <= io_spi_data;
			32:r_data[16] <= io_spi_data;
			
			33:r_data[31] <= io_spi_data;
			34:r_data[30] <= io_spi_data;
			35:r_data[29] <= io_spi_data;
			36:r_data[28] <= io_spi_data;
			37:r_data[27] <= io_spi_data;
			38:r_data[26] <= io_spi_data;
			39:r_data[25] <= io_spi_data;
			40:r_data[24] <= io_spi_data;
			
			41:r_data[39] <= io_spi_data;
			42:r_data[38] <= io_spi_data;
			43:r_data[37] <= io_spi_data;
			44:r_data[36] <= io_spi_data;
			45:r_data[35] <= io_spi_data;
			46:r_data[34] <= io_spi_data;
			47:r_data[33] <= io_spi_data;
			48:r_data[32] <= io_spi_data;
			
			49:r_data[47] <= io_spi_data;
			50:r_data[46] <= io_spi_data;
			51:r_data[45] <= io_spi_data;
			52:r_data[44] <= io_spi_data;
			53:r_data[43] <= io_spi_data;
			54:r_data[42] <= io_spi_data;
			55:r_data[41] <= io_spi_data;
			56:r_data[40] <= io_spi_data;
			endcase
		end
		
		if(r_uart_enb)
			r_data <= r_data << 8;
		
		if(state == STOP) begin
			r_data[56:48] <= 8'b11111111;
			if (r_data[7:0] == 255)
				r_data[7:0] <= 254;
			if (r_data[15:8] == 255)
				r_data[15:8] <= 3;
			if (r_data[23:16] == 255)
				r_data[23:16] <= 254;
			if (r_data[31:24] == 255)
				r_data[31:24] <= 3;
			if (r_data[39:32] == 255)
				r_data[39:32] <= 254;
			if (r_data[47:40] == 255)
				r_data[47:40] <= 3;
		end
	end
	
	assign w_master_busy = (state == READ_DATA  && r_counter >= 9) ? 1'b0 : 1'b1;
	
endmodule 