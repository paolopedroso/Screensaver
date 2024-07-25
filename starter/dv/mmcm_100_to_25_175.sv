// Copyright (c) 2024 Ethan Sifferman.
// All rights reserved. Distribution Prohibited.

module mmcm_100_to_25_175 (
    input  logic clk_100,
    output logic clk_25_175
);

    initial $info("Modeling clk_25_175 as clk_100 in simulation.");
    assign clk_25_175 = clk_100;

endmodule
