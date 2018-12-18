# Delete old compilation results
if { [file exists "work"] } {
    vdel -all
}

# Create new modelsim working library
vlib work

# Compile all the Verilog sources in current folder into working library
vlog  watchdog.v watchdog_tb.v

# Open testbench module for simulation
vsim -novopt work.watchdog_tb

# Add all testbench signals to waveform diagram
add wave sim:/watchdog_tb/*

# Run simulation
run -all
