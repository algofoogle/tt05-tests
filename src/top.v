`default_nettype none

module tt_um_algofoogle_tt05_tests(
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    reg [23:0] ops;

    always @(posedge clk) begin
        ops <= {ops[15:0],ui_in};
    end

    reg [1:0] word;

    always @(posedge clk) begin
        word <= (0==rst_n) ? 0 : word + 2'b1;
    end

    wire [23:0] product = ops[23:16] * ops[15:0];

    assign uo_out =
        (word==0) ? product[7:0]:
        (word==1) ? product[15:8]:
        (word==2) ? product[23:16]:
                    {product[9:7],product[17:15],product[3:2]} + ui_in;

    assign uio_out = ops[23:16] + ops[15:0];

    assign uio_oe = 8'b11111111;

endmodule
