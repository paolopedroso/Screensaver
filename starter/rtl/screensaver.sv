// Copyright (c) 2024 Ethan Sifferman.
// All rights reserved. Distribution Prohibited.

module screensaver (
    input  logic       clk_i,
    input  logic       rst_ni,
    input  logic [3:0] select_image_i,
    output logic [3:0] vga_red_o,
    output logic [3:0] vga_blue_o,
    output logic [3:0] vga_green_o,
    output logic       vga_hsync_o,
    output logic       vga_vsync_o
);

localparam int IMAGE_WIDTH = 160;
localparam int IMAGE_HEIGHT = 120;
localparam int IMAGE_ROM_SIZE = (IMAGE_WIDTH * IMAGE_HEIGHT);

logic [9:0] vga_x;
logic [9:0] vga_y;
logic        visible;
logic [11:0] pixel_data;
logic [$clog2(IMAGE_ROM_SIZE)-1:0] rom_addr;

logic [11:0] image0_rdata;
logic [11:0] image1_rdata;
logic [11:0] image2_rdata;
logic [11:0] image3_rdata;

images #(
    .IMAGE_ROM_SIZE(IMAGE_ROM_SIZE)
) images_inst (
    .clk_i(clk_i),
    .rom_addr_i(rom_addr),
    .image0_rdata_o(image0_rdata),
    .image1_rdata_o(image1_rdata),
    .image2_rdata_o(image2_rdata),
    .image3_rdata_o(image3_rdata)
);

vga_timer vga_timer_inst (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .hsync_o(vga_hsync_o),
    .vsync_o(vga_vsync_o),
    .visible_o(visible),
    .position_x_o(vga_x),
    .position_y_o(vga_y)
);

always_comb begin
    case (select_image_i)
        4'b0001: pixel_data = image0_rdata;
        4'b0010: pixel_data = image1_rdata;
        4'b0100: pixel_data = image2_rdata;
        4'b1000: pixel_data = image3_rdata;
    endcase
end


always_ff @(posedge clk_i) begin
    if (!rst_ni) begin
        vga_red_o <= 4'b0;
        vga_blue_o <= 4'b0;
        vga_green_o <= 4'b0;
    end else if (visible) begin
        vga_red_o <= pixel_data[11:8];
        vga_blue_o <= pixel_data[7:4];
        vga_green_o <= pixel_data[3:0];
    end else begin
        vga_red_o <= 4'b0;
        vga_blue_o <= 4'b0;
        vga_green_o <= 4'b0;
    end
end

endmodule
