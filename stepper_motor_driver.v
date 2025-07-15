/**
 * @brief Stepper motor driver for A4988 (1/16 microstep).
 *
 * @param CLK_FREQ_HZ             System clock frequency (Hz, default 50_000_000).
 * @param STEP_PULSE_WIDTH_CYCLES Number of clk cycles for STEP pulse
 *                                (min 1 µs @ 50 MHz = 50 cycles).
 *
 * Inputs:
 *   clk               System clock.
 *   reset             Asynchronous active-high reset.
 *   dir_switch_in     Direction control (0 = CW, 1 = CCW).
 *   enable_switch_in  Motor enable (1 = ON, 0 = OFF).
 *
 * Outputs:
 *   step_pin          STEP signal to A4988 (pulse on rising edge).
 *   dir_pin           DIR signal (follows dir_switch_in).
 *   ms1_pin, ms2_pin, ms3_pin
 *                     Microstep select (all high for 1/16).
 *   a4988_reset_pin   nRST (held high).
 *   a4988_sleep_pin   nSLEEP (held high).
 *   a4988_enable_pin  nEN (active-low; ~enable_switch_in).
 */
module stepper_motor_driver (
    input  wire        clk,               // 50 MHz system clock
    input  wire        reset,             // Active-high reset
    input  wire        dir_switch_in,     // CW/CCW direction select
    input  wire        enable_switch_in,  // Motor enable

    output reg         step_pin,          // STEP output
    output wire        dir_pin,           // DIR output
    output wire        ms1_pin,           // Microstep MS1
    output wire        ms2_pin,           // Microstep MS2
    output wire        ms3_pin,           // Microstep MS3
    output wire        a4988_reset_pin,   // nRST
    output wire        a4988_sleep_pin,   // nSLEEP
    output wire        a4988_enable_pin   // nEN
);

    // Parameters
    parameter integer CLK_FREQ_HZ              = 50_000_000;
    parameter integer STEP_PULSE_WIDTH_CYCLES  = 50;  // 1 µs @ 50 MHz

    // Internal Signals
    wire        step_trigger_clk;      // From clock_div module
    reg  [5:0]  pulse_width_counter;   // Pulse width counter
    reg         step_active;           // Pulse-active state flag


	// Clock Divider Instance
    // Generates 'step_trigger_clk' at the desired microstep rate.
    // Adjust DIVIDER_VALUE in clock_div to set the step frequency.
    clock_div #(
        .DIVIDER_VALUE(26'd7811)       // e.g., for 60 RPM @ 1/16 microstep
    ) clk_div_inst (
        .clk    (clk),
        .rst    (reset),
        .new_clk(step_trigger_clk)
    );


    // A4988 Control Pin Assignments
    assign ms1_pin           = 1'b1;      // 1/16 microstepping
    assign ms2_pin           = 1'b1;
    assign ms3_pin           = 1'b1;
    assign dir_pin           = dir_switch_in;
    assign a4988_reset_pin   = 1'b1;      // keep translator enabled
    assign a4988_sleep_pin   = 1'b1;      // prevent sleep mode
    assign a4988_enable_pin  = ~enable_switch_in; // active-low

	// STEP Pulse Generation
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pulse_width_counter <= 0;
            step_pin            <= 1'b0;
            step_active         <= 1'b0;
        end else if (step_active) begin
            // During active pulse, hold STEP high
            if (pulse_width_counter < STEP_PULSE_WIDTH_CYCLES - 1) begin
                pulse_width_counter <= pulse_width_counter + 1;
                step_pin            <= 1'b1;
            end else begin
                // End of pulse duration
                pulse_width_counter <= 0;
                step_active         <= 1'b0;
                step_pin            <= 1'b0;
            end
        end else begin
            // Idle: trigger new pulse on rising edge of step_trigger_clk
            if (step_trigger_clk && (pulse_width_counter == 0)) begin
                step_active <= 1'b1;
            end else begin
                step_pin <= 1'b0;
            end
        end
    end

endmodule

endmodule
