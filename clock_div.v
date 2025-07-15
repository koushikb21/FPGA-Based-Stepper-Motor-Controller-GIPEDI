`timescale 1ns / 1ps
module clock_div(
    input clk,       // 50MHz Spartan-3 clock
    input rst,       // Synchronous reset
    output reg new_clk
);

// Spartan-3 global clock buffer (REQUIRED for clock networks)
wire clk_bufg;

BUFG clk_bufg_inst (
    .I(clk),
    .O(clk_bufg)
);

// A4988 Stepper Driver Configuration: MS1=HIGH, MS2=HIGH, MS3=HIGH
// This enables 1/16 microstepping mode (3200 steps per revolution)
//
// DIVIDER Formula for 1/16 microstepping:
// DIVIDER = (F_clk / (2 * F_out)) - 1
// Where F_out = (RPM * 3200) / 60
//
// Available RPM configurations:
// 30 RPM:  localparam DIVIDER = 26'd15624;  // 1600 Hz output
// 60 RPM:  localparam DIVIDER = 26'd7811;   // 3200 Hz output
// 120 RPM: localparam DIVIDER = 26'd3905;   // 6400 Hz output

// Current configuration: 60 RPM
localparam DIVIDER = 16'd7811;

reg [25:0] count;

always @(posedge clk_bufg) begin
    if (rst) begin
        count <= 0;
        new_clk <= 0;
    end
    else if (count == DIVIDER) begin
        count <= 0;
        new_clk <= ~new_clk;  // Toggle output clock
    end
    else begin
        count <= count + 1;
    end
end

endmodule
