set_property IOSTANDARD LVCMOS33 [get_ports clk];
set_property PACKAGE_PIN Y9 [get_ports clk];
create_clock -period 15 [get_ports clk];


set_property PACKAGE_PIN T22 [get_ports {fsm_done}];  # "LD0" fsm_done signal
set_property PACKAGE_PIN T21 [get_ports {out_of_bounds}];  # "LD1" reached impossible state
#set_property PACKAGE_PIN U22 [get_ports {LD2}]
#set_property PACKAGE_PIN U21 [get_ports {LD3}]
set_property PACKAGE_PIN V22 [get_ports {LD4}];  # "LD4" x0 is grabbed
set_property PACKAGE_PIN W22 [get_ports {LD5}];  # "LD5" y0 is grabbed
set_property PACKAGE_PIN U19 [get_ports {LD6}];  # "LD6" xt is grabbed
set_property PACKAGE_PIN U14 [get_ports {LD7}];  # "LD7" yt is grabbed


set_property PACKAGE_PIN U10 [get_ports oled_dc];
set_property PACKAGE_PIN U9 [get_ports oled_res];
set_property PACKAGE_PIN AB12 [get_ports oled_sclk];
set_property PACKAGE_PIN AA12 [get_ports oled_sdin];
set_property PACKAGE_PIN U11 [get_ports oled_vbat];
set_property PACKAGE_PIN U12 [get_ports oled_vdd];


set_property PACKAGE_PIN P16 [get_ports {rst}];  # "BTNC"  reset oled 
set_property PACKAGE_PIN T18 [get_ports {BTNU}];  # "BTNU"  switch_button
set_property PACKAGE_PIN R18 [get_ports {BTNR}];  # "BTNR"  start
set_property PACKAGE_PIN R16 [get_ports {BTND}];  # "BTND"  print to OLED visited path and total steps
set_property PACKAGE_PIN N15 [get_ports {BTNL}];  # "BTNL"  reset FSM


set_property PACKAGE_PIN F22 [get_ports {switches[0]}];  # "SW0"
set_property PACKAGE_PIN G22 [get_ports {switches[1]}];  # "SW1"
set_property PACKAGE_PIN H22 [get_ports {switches[2]}];  # "SW2"
set_property PACKAGE_PIN F21 [get_ports {switches[3]}];  # "SW3"
set_property PACKAGE_PIN H19 [get_ports {switches[4]}];  # "SW4"
set_property PACKAGE_PIN H18 [get_ports {switches[5]}];  # "SW5"
set_property PACKAGE_PIN H17 [get_ports {switches[6]}];  # "SW6"
set_property PACKAGE_PIN M15 [get_ports {switches[7]}];  # "SW7"


# Note that the bank voltage for IO Bank 33 is fixed to 3.3V on ZedBoard. 
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 33]];

# Set the bank voltage for IO Bank 34 to 1.8V by default.
# set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 34]];
# set_property IOSTANDARD LVCMOS25 [get_ports -of_objects [get_iobanks 34]];
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 34]];

# Set the bank voltage for IO Bank 35 to 1.8V by default.
# set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 35]];
# set_property IOSTANDARD LVCMOS25 [get_ports -of_objects [get_iobanks 35]];
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 35]];

# Note that the bank voltage for IO Bank 13 is fixed to 3.3V on ZedBoard. 
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 13]];