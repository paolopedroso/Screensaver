# Copyright (c) 2024 Ethan Sifferman.
# All rights reserved. Distribution Prohibited.

# start_gui

create_project basys3 basys3 -part xc7a35tcpg236-1

add_files -norecurse {
 ../../../37f.memh
 ../../../3f7.memh
 ../../../73f.memh
 ../../../7f3.memh
 ../../../f37.memh
 ../../../f73.memh
}
set_property file_type {Memory File} [get_files -all]

add_files -norecurse {
 ../../../rtl/images.sv
 ../../../rtl/vga_timer.sv
 ../../../rtl/screensaver.sv
 ../basys3.sv
}
add_files -fileset constrs_1 -norecurse {
 ../Basys3_Master.xdc
}

set_property top basys3 [current_fileset]

# Generate Clock
create_ip -name clk_wiz -vendor xilinx.com -library ip -version 6.0 -module_name mmcm_100_to_25_175
set_property -dict [list \
  CONFIG.CLK_OUT1_PORT {clk_25_175} \
  CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {25.175} \
  CONFIG.PRIMARY_PORT {clk_100} \
  CONFIG.USE_LOCKED {false} \
  CONFIG.USE_RESET {false} \
] [get_ips mmcm_100_to_25_175]

# Run Synthesis
set_property STEPS.SYNTH_DESIGN.ARGS.FLATTEN_HIERARCHY none [get_runs synth_1]
launch_runs synth_1 -jobs [exec nproc]
wait_on_run synth_1

# Run PNR
launch_runs impl_1
wait_on_run impl_1

# Create Bitstream
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1

exit
