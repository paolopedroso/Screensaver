# CSE100 – Screensaver

## Overview
This repository contains the implementation of a VGA interface and a screensaver for the Basys 3 FPGA Board as part of the CSE100 course. The lab demonstrates the use of VGA signals to display images stored in ROM, showcasing a simple screensaver.

## Goals
- Implement a VGA interface with a counter built from adders and flip-flops.
- Display the contents of a ROM over VGA.
- Program the implementation to a Basys 3 FPGA Board.

## Project Structure
- **rtl/screensaver.sv**: Contains the screensaver module that instantiates the VGA timer and displays pixel values from the images module.
- **rtl/vga_timer.sv**: Implements the VGA timer according to the VESA standard for “640 × 480 @ 60 Hz”.
- **synth/basys3/Basys3_Master.xdc**: Basys3 constraints file, completed to match the Basys3 module.
- **rtl/images.sv**: Provided images module that outputs pixel values based on ROM addresses.
- **scripts/generate_image_rom.py**: Script that generates the .memh files for the image ROMs.

## VGA Controller
- Generates control signals Hsync and Vsync, and 12 RGB data signals for each of the screen’s 640 × 480 pixels.
- Synchronizes the monitor to refresh the image at 60Hz.
- Ensures correct timing for the VGA display protocol.

## Screensaver
- Displays images stored in ROM on a VGA monitor.
- Uses button inputs to switch between different images.
- Stretches the 160 × 120 images to fill the 640 × 480 VGA screen.
- Synchronizes Hsync and Vsync pulses with pixel values.

## How to Run
1. **Simulation:**
   - Simulate the design using the provided simulation commands in the `README.md` file.
2. **Synthesis:**
   - Synthesize the design and program it to the Basys 3 FPGA Board using the provided synthesis commands.
3. **Demonstration:**
   - Connect the Basys 3 FPGA Board to a VGA monitor to see the screensaver in action.

## Results
The implementation successfully displays different images as a screensaver on the VGA monitor, demonstrating the use of VGA signals and image ROMs in an FPGA environment.

## Acknowledgements
- **CSE100 Course Instructors:** Ethan Sifferman
- **Digilent for the Basys 3 Board Resources**

---

This repository showcases the successful completion of CSE100 Lab 3, focusing on implementing and demonstrating a VGA interface and screensaver using the Basys 3 FPGA Board. The project includes detailed implementation of the VGA controller and screensaver modules, along with necessary scripts and configuration files.

COPYRIGHT 2024 Paolo Pedroso
