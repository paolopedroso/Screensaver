// Copyright (c) 2024 Ethan Sifferman.
// All rights reserved. Distribution Prohibited.

module images #(
    parameter  int IMAGE_ROM_SIZE = 15,
    localparam int ADDR_WIDTH     = $clog2(IMAGE_ROM_SIZE)
) (
    input  logic                  clk_i,
    input  logic [ADDR_WIDTH-1:0] rom_addr_i,

    output logic           [11:0] image0_rdata_o,
    output logic           [11:0] image1_rdata_o,
    output logic           [11:0] image2_rdata_o,
    output logic           [11:0] image3_rdata_o
);

logic [11:0] IMAGE0 [IMAGE_ROM_SIZE];
logic [11:0] IMAGE1 [IMAGE_ROM_SIZE];
logic [11:0] IMAGE2 [IMAGE_ROM_SIZE];
logic [11:0] IMAGE3 [IMAGE_ROM_SIZE];

initial $readmemh("rubylith.memh", IMAGE0);
initial $readmemh("slug.memh", IMAGE1);
initial $readmemh("vivado.memh", IMAGE2);
initial $readmemh("finch.memh", IMAGE3);

logic [11:0] image0_rdata_q;
logic [11:0] image1_rdata_q;
logic [11:0] image2_rdata_q;
logic [11:0] image3_rdata_q;

always_ff @(posedge clk_i) begin
    image0_rdata_q <= IMAGE0[rom_addr_i];
    image1_rdata_q <= IMAGE1[rom_addr_i];
    image2_rdata_q <= IMAGE2[rom_addr_i];
    image3_rdata_q <= IMAGE3[rom_addr_i];
end

assign image0_rdata_o = image0_rdata_q;
assign image1_rdata_o = image1_rdata_q;
assign image2_rdata_o = image2_rdata_q;
assign image3_rdata_o = image3_rdata_q;

endmodule
