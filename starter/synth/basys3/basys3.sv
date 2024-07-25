// Copyright (c) 2024 Ethan Sifferman.
// All rights reserved. Distribution Prohibited.

module basys3 (
    input  logic        clk_100,

    input  logic        btnC,
    input  logic        btnU,
    input  logic        btnL,
    input  logic        btnR,
    input  logic        btnD,

    output logic  [3:0] vgaRed,
    output logic  [3:0] vgaBlue,
    output logic  [3:0] vgaGreen,
    output logic        Hsync,
    output logic        Vsync
);

logic clk_25_175;
mmcm_100_to_25_175 mmcm_100_to_25_175 (
    .clk_100,
    .clk_25_175
);

wire rst_n = !btnC;

screensaver screensaver (
    .clk_i(clk_25_175),
    .rst_ni(rst_n),

    .select_image_i({btnU,btnL,btnR,btnD}),

    .vga_red_o(vgaRed),
    .vga_blue_o(vgaBlue),
    .vga_green_o(vgaGreen),
    .vga_hsync_o(Hsync),
    .vga_vsync_o(Vsync)
);

endmodule
