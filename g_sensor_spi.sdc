create_clock -name i_board_clk -period 20.000 [get_ports {i_board_clk}]
derive_pll_clocks -create_base_clocks
derive_clock_uncertainty
set_false_path -from [get_ports {i_enb}]
set_false_path -to [get_ports {o_cs_n o_spi_clk o_data_tx}]