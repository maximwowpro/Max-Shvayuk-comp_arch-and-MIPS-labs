# Delete old compilation results
if { [file exists "work"] } {
    vdel -all
}

# Create new modelsim working library
vlib work

# Compile all the Verilog sources in current folder into working library
vlog _mips_control__alu_unit.v _mips_control__main_unit.v alu.v barrel_shifter.v data_memory.v data_tract_v2.v instruction_memory.v mips_control_unit_full.v mips_full_tb.v mux_5_bit.v mux_32_bit.v program_counter.v register_file.v sign_extender.v mips_1_tact_full_processor.v watchdog.v

# Open testbench module for simulation
vsim -novopt work.testbench

# Add all testbench signals to waveform diagram
add wave sim:/testbench/*
add wave sim:/testbench/clk
add wave sim:/testbench/reset
add wave sim:/testbench/mips/data_tract/RESET
add wave sim:/testbench/mips/data_tract/pc_current_instruction_addr
add wave sim:/testbench/mips/data_tract/current_instruction
add wave sim:/testbench/mips/data_tract/is_jump
add wave sim:/testbench/mips/data_tract/pc_control_is_branch
add wave sim:/testbench/mips/data_tract/register_file/matrix
add wave sim:/testbench/mips/data_tract/data_memory/matrix

add wave sim:/testbench/mips/data_tract/alu_result
add wave sim:/testbench/mips/data_tract/watchdog/counter_1
add wave sim:/testbench/mips/data_tract/watchdog/counter_2
add wave sim:/testbench/mips/data_tract/watchdog/i_clrwdt


# Run simulation
run -all
