module vga_timer (
    input  logic       clk_i,
    input  logic       rst_ni,
    output logic       hsync_o,
    output logic       vsync_o,
    output logic       visible_o,
    output logic [9:0] position_x_o, // Updated bit-width for larger value
    output logic [9:0] position_y_o  // Updated bit-width for larger value
);

integer maxVisX = 640;
integer maxX = 800;
integer maxVisY = 480;
integer maxY = 525;

logic [9:0] v_counter;
logic [9:0] h_counter;

always_ff @(posedge clk_i) begin
    if (!rst_ni) begin
        h_counter <= 0;
    end else if (h_counter == maxX - 1) begin
        h_counter <= 0;
    end else begin
        h_counter <= h_counter + 1;
    end
end

always_ff @(posedge clk_i) begin
    if (!rst_ni) begin
        v_counter <= 0;
    end else if (h_counter == maxX - 1) begin
        if (v_counter == maxY - 1) begin
            v_counter <= 0;
        end else begin
            v_counter <= v_counter + 1;
        end
    end
end

always_ff @(posedge clk_i) begin
    if (!rst_ni) begin
        position_x_o <= 0;
    end else if (h_counter < maxVisX) begin
        position_x_o <= h_counter;
    end
end

always_ff @(posedge clk_i) begin
    if (!rst_ni) begin
        position_y_o <= 0;
    end else if (h_counter == maxX - 1) begin
        if (v_counter < maxVisY) begin
            position_y_o <= v_counter;
        end
    end
end

assign hsync_o = (h_counter >= (maxVisX + 16) && h_counter < (maxVisX + 16 + 96));
assign vsync_o = (v_counter >= (maxVisY + 10) && v_counter < (maxVisY + 10 + 2));
assign visible_o = (h_counter < maxVisX && v_counter < maxVisY);

endmodule
