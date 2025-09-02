-----

# FPGA-Based Stepper Motor Controller (GIPEDI Internship, IIT Delhi)

This repository contains the Verilog-based implementation of a **precision FPGA-based stepper motor controller**, developed during the GIPEDI internship at **IIT Delhi (15 May– 15 July 2025)**.
Custom A4988 Carrier PCB KiCad files are also included.
-----

## 🔧 Overview

The project controls a **NEMA17 stepper motor** via an **A4988 microstepping driver**, using Verilog HDL on a **Xilinx Spartan-3 (XC3S200-FT256)** FPGA. It achieves **1/16 microstepping**, delivering **0.1125° per step** resolution with deterministic, real-time control.
Custom A4988 Carrier PCB KiCad files are also included.
-----

## ✨ Features

  - FPGA-based control using **Verilog HDL**
  - **Clock Divider** module for precise STEP signal generation
  - **Motor Driver module** interfacing FPGA with A4988
  - Achieves **1/16 microstepping (0.1125° resolution)**
  - Verified with **testbench simulation, synthesis, and logic analyzer**
  - Designed **PCB schematic & layout** for hardware implementation
  - Deterministic control superior to microcontroller-based solutions

-----

## 🛠️ Tools & Technologies

  - **Hardware**: Xilinx Spartan-3 (XC3S200-FT256), NEMA17 Stepper Motor, A4988 Driver
  - **Software**: Verilog HDL, Xilinx ISE, iVerilog, GTKWave, KiCad
  - **Verification**: Simulation, Synthesis, Testbenching, Logic Analyzer

-----

## 📂 Repository Structure

```
.
├── A4988_V2.zip              # KiCad files for A4988 Carrier PCB
├── clock_div.v               # Clock divider module
├── stepper_motor_driver.v    # Motor driver module
├── stepper_motor_driver_tb.v # Testbench for motor driver
├── stepper_motor_driver.ucf  # FPGA constraints file
└── README.md                 # Project documentation
```

-----

## 🚀 Getting Started

1.  Clone the repository:

    ```bash
    git clone https://github.com/koushikb21/FPGA-Based-Stepper-Motor-Controller-GIPEDI-.git
    ```

2.  Extract the contents of `A4988_V2.zip` (if needed for board/interface files).

3.  Open the project in **Xilinx ISE** (or use iVerilog for simulation).

4.  Run simulation with iVerilog + GTKWave:

    ```bash
    iverilog -o tb.vvp stepper_motor_driver_tb.v clock_div.v stepper_motor_driver.v
    vvp tb.vvp
    gtkwave dump.vcd
    ```

5.  Connect FPGA → A4988 → NEMA17 setup, program the FPGA, and verify stepper motor movement.

-----

## 📊 Results

  * Achieved **0.1125° angular resolution** with 1/16 microstepping.
  * Verified **STEP/DIR signal integrity** via testbench and logic analyzer.
  * Demonstrated **deterministic, real-time motor control** compared to microcontrollers.

-----

## 📌 Future Work

  * Extend to **linear actuator system** with lead screw.
  * Add **custom softcore processor** for user interfacing.
  * Implement **continuous/single-stepping modes**.

-----

## 👨‍💻 Author

**Koushik Bhattacharya**

  * [LinkedIn](https://www.linkedin.com/in/koushik-bhattacharya-64849a167)
  * [GitHub](https://github.com/koushikb21)

-----

## Intellectual Property Notice

This project was developed as part of the **GIPEDI Program at IIT Delhi** (B2-2025-3).  
All intellectual property rights are owned by **IIT Delhi** under the GIPEDI program.

This repository is provided for **academic and demonstration purposes only**.  
Any reproduction, distribution, or use of this work requires prior written permission from **IIT Delhi**.

