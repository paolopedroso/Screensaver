// Copyright (c) 2024 Ethan Sifferman.
// All rights reserved. Distribution Prohibited.

module tb;

logic       clk_i;
logic       rst_ni;
logic [3:0] select_image_i;

initial begin
    clk_i = 0;
    forever begin
        clk_i = !clk_i;
        #1;
    end
end

logic [3:0] image_selects[$] = '{
    4'b0001,
    4'b0000,
    4'b0010,
    4'b0000,
    4'b0100,
    4'b0000,
    4'b1000,
    4'b0000
};
localparam int NUM_FRAMES = 8;

initial begin
    repeat((NUM_FRAMES+1) * 500000) @(posedge clk_i);
    $display("Timed out");
    $fatal;
end

screensaver screensaver (
    .clk_i,
    .rst_ni,
    .select_image_i
);

initial begin : sim
    $dumpfile( "dump.fst" );
    $dumpvars;
    $display( "Begin simulation." );

    rst_ni = 0;
    @(posedge clk_i);
    @(posedge clk_i);
    rst_ni = 1;

    select_image_i = 4'b0001;

    while (current_frame != NUM_FRAMES)
        @(negedge screensaver.vga_vsync_o);

    $display( "End simulation." );
    $finish;
end

function logic [1:0] current_image_func(int frame);
    automatic logic [3:0] image_select = image_selects[frame];
    if ($onehot(image_select))
        return $clog2(image_select);
    else if (frame == 0)
        return 'x;
    return current_image_func(frame-1);
endfunction

int current_frame = 0;

logic [1:0] current_image;
always_comb current_image = current_image_func(current_frame);

wire [11:0] current_pixel = {screensaver.vga_red_o,
                             screensaver.vga_green_o,
                             screensaver.vga_blue_o};

always @(posedge clk_i) if (rst_ni) begin : vsync_low_check
    int num_cycles = 0;
    @(negedge clk_i);
    @(negedge screensaver.vga_vsync_o);
    @(negedge clk_i);
    while (!screensaver.vga_vsync_o) begin
        @(negedge clk_i);
        num_cycles++;
    end
    assert(num_cycles == 1600) else #1 $error("Vsync width incorrect");
end

always @(posedge clk_i) if (rst_ni) begin : vsync_high_check
    int num_cycles = 0;
    @(negedge clk_i);
    @(posedge screensaver.vga_vsync_o);
    @(negedge clk_i);
    while (screensaver.vga_vsync_o) begin
        num_cycles++;
        @(negedge clk_i);
    end
    assert(num_cycles == 418400) else #1 $error("Vsync did not occur at correct time");
end

always @(posedge clk_i) if (rst_ni) begin : hsync_low_check
    int num_cycles = 0;
    @(negedge clk_i);
    @(negedge screensaver.vga_hsync_o);
    @(negedge clk_i);
    while (!screensaver.vga_hsync_o) begin
        num_cycles++;
        @(negedge clk_i);
    end
    assert(num_cycles == 96) else #1 $error("Hsync width incorrect");
end

always @(posedge clk_i) if (rst_ni) begin : hsync_high_check
    int num_cycles = 0;
    @(negedge clk_i);
    @(posedge screensaver.vga_hsync_o);
    @(negedge clk_i);
    while (screensaver.vga_hsync_o) begin
        num_cycles++;
        @(negedge clk_i);
    end
    assert(num_cycles == 704) else #1 $error("Hsync did not occur at correct time after Hsync");
end

always @(posedge clk_i) if (rst_ni) begin : vsync_hsync_check
    int num_cycles = 0;
    @(negedge clk_i);
    @(posedge screensaver.vga_vsync_o);
    @(negedge clk_i);
    while (screensaver.vga_hsync_o) begin
        num_cycles++;
        @(negedge clk_i);
    end
    assert(num_cycles == 656) else #1 $error("Hsync did not occur at correct time after Vsync");
end

always @(posedge clk_i) if (rst_ni) begin : first_row_pixels_check
    int row_index = 0;
    logic [11:0] expected_pixel = 'x;

    @(negedge clk_i);
    @(negedge screensaver.vga_vsync_o);
    select_image_i <= image_selects[current_frame];

    @(posedge screensaver.vga_vsync_o);
    @(negedge clk_i);
    repeat(26400) @(posedge clk_i);
    @(negedge clk_i);

    repeat(640) begin
        case (current_image)
            0: expected_pixel = screensaver.images.IMAGE0[row_index/4];
            1: expected_pixel = screensaver.images.IMAGE1[row_index/4];
            2: expected_pixel = screensaver.images.IMAGE2[row_index/4];
            3: expected_pixel = screensaver.images.IMAGE3[row_index/4];
            default: ;
        endcase
        assert(current_pixel == expected_pixel) else begin
            string error_msg = $sformatf(
                "Expected: %h, recieved: %h. Should be image=%b, row=0, column=%0d.",
                expected_pixel, current_pixel, current_image, row_index);
            #1 $error(error_msg);
        end
        @(negedge clk_i);
        row_index = row_index+1;
    end

    current_frame <= current_frame+1;
    $info("Frame %0d correct", current_frame);
end

endmodule
