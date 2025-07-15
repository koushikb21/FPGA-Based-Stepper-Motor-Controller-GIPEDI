// stepper_motor_driver_tb.v
// Enhanced testbench for stepper_motor_driver module
// Records only the selected signals to VCD and tests direction & enable functionality.

`timescale 1ns / 1ps

module stepper_motor_driver_tb;

    // --- Testbench Parameters ---
    parameter TB_CLK_PERIOD        = 20;       // 20 ns for 50 MHz clock
    parameter RESET_PULSE_WIDTH    = 100;      // 100 ns reset
    parameter SIM_DURATION         = 5_000_000; // 5 ms simulation
    parameter DIR_CHANGE_INTERVAL  = 1_000_000; // 1 ms between direction changes

    // --- DUT Inputs (driven by TB) ---
    reg clk;
    reg reset;
    reg dir_switch_in;
    reg enable_switch_in;

    // --- DUT Outputs (monitored) ---
    wire step_pin;
    wire dir_pin;
    wire ms1_pin;
    wire ms2_pin;
    wire ms3_pin;
    wire a4988_reset_pin;
    wire a4988_sleep_pin;
    wire a4988_enable_pin;

    // --- Instantiate DUT ---
    stepper_motor_driver DUT (
        .clk(clk),
        .reset(reset),
        .dir_switch_in(dir_switch_in),
        .enable_switch_in(enable_switch_in),
        .step_pin(step_pin),
        .dir_pin(dir_pin),
        .ms1_pin(ms1_pin),
        .ms2_pin(ms2_pin),
        .ms3_pin(ms3_pin),
        .a4988_reset_pin(a4988_reset_pin),
        .a4988_sleep_pin(a4988_sleep_pin),
        .a4988_enable_pin(a4988_enable_pin)
    );

    // --- VCD Dump: only selected signals ---
    initial begin
        $dumpfile("stepper_signals.vcd");
        $dumpvars(0,
            stepper_motor_driver_tb.clk,
            stepper_motor_driver_tb.reset,
            stepper_motor_driver_tb.dir_switch_in,
            stepper_motor_driver_tb.enable_switch_in,
            stepper_motor_driver_tb.step_pin,
            stepper_motor_driver_tb.dir_pin,
            stepper_motor_driver_tb.ms1_pin,
            stepper_motor_driver_tb.ms2_pin,
            stepper_motor_driver_tb.ms3_pin,
            stepper_motor_driver_tb.a4988_reset_pin,
            stepper_motor_driver_tb.a4988_sleep_pin,
            stepper_motor_driver_tb.a4988_enable_pin
        );
    end

    // --- Clock Generation ---
    initial clk = 1'b0;
    always #(TB_CLK_PERIOD/2) clk = ~clk;

    // --- Main Test Sequence ---
    initial begin
        // Initialize
        reset           = 1'b1;
        dir_switch_in   = 1'b0;  // CCW
        enable_switch_in= 1'b0;  // Disabled

        // Display header
        $display("=== Testbench Start === Time=%0t ns ===", $time);

        // Apply reset
        #RESET_PULSE_WIDTH;
        reset = 1'b0;
        $display("Time=%0t ns: Deassert reset", $time);

        // Wait for pins to settle
        #(TB_CLK_PERIOD*2);
        $display("--- Initial Pin States ---");
        $display("MS1=%b MS2=%b MS3=%b DIR=%b EN=%b RST=%b SLP=%b",
                 ms1_pin, ms2_pin, ms3_pin, dir_pin,
                 a4988_enable_pin, a4988_reset_pin, a4988_sleep_pin);

        // Test Case 1: Enable CCW
        $display("\n--- TC1: Enable motor (CCW) ---");
        enable_switch_in = 1'b1;
        #(TB_CLK_PERIOD*2);
        $display("Time=%0t ns: Motor ENABLED (CCW), EN pin=%b", $time, a4988_enable_pin);
        #DIR_CHANGE_INTERVAL;

        // Test Case 2: Change to CW
        $display("\n--- TC2: Change to CW ---");
        dir_switch_in = 1'b1;
        #(TB_CLK_PERIOD*2);
        $display("Time=%0t ns: Direction = CW", $time);
        #DIR_CHANGE_INTERVAL;

        // Test Case 3: Disable motor
        $display("\n--- TC3: Disable motor ---");
        enable_switch_in = 1'b0;
        #(TB_CLK_PERIOD*2);
        $display("Time=%0t ns: Motor DISABLED, EN pin=%b", $time, a4988_enable_pin);
        #DIR_CHANGE_INTERVAL;

        // Test Case 4: Re-enable motor CCW
        $display("\n--- TC4: Re-enable motor (CCW) ---");
        enable_switch_in = 1'b1;
        dir_switch_in   = 1'b0;
        #DIR_CHANGE_INTERVAL;

        // End simulation
        #SIM_DURATION $finish;
        #SIM_DURATION $finish;
    end

    // --- Optional: report every step pulse ---
    always @(posedge step_pin) begin
        if (enable_switch_in)
            $display("Time=%0t ns: STEP_PIN=1 DIR=%b", $time, dir_pin);
    end

endmodule
