module jtagthru
(
  input clk_25mhz,
  input [6:0] btn,
  output [7:0] led,
  output ftdi_rxd,
  input ftdi_txd, ftdi_nrts, ftdi_ndtr,
  inout [27:0] gp, gn,
  output wifi_gpio0
);
    assign wifi_gpio0 = btn[0];

    wire ftdi_rxd, ftdi_txd, ftdi_nrts, ftdi_ndtr;

    wire jtag_tdo, jtag_tdi, jtag_tms, jtag_clk;

    //(* LOC="U17" *) (* IO_TYPE="LVCMOS33" *) // gn14
    //TRELLIS_IO #(.DIR("INPUT")) jtag_tdo_buf (.B(jtag_tdo_pin), .O(jtag_tdo));
    assign jtag_tdo = gn[14];

    //(* LOC="N17" *) (* IO_TYPE="LVCMOS33" *) // gp15
    //TRELLIS_IO #(.DIR("OUTPUT")) jtag_tdi_buf (.B(jtag_tdi_pin), .I(jtag_tdi));
    assign gp[15] = jtag_tdi;

    //(* LOC="U18" *) (* IO_TYPE="LVCMOS33" *) // gp14
    //TRELLIS_IO #(.DIR("OUTPUT")) jtag_tms_buf (.B(jtag_tms_pin), .I(jtag_tms));
    assign gp[14] = jtag_tms;

    //(* LOC="P16" *) (* IO_TYPE="LVCMOS33" *) // gn15
    //TRELLIS_IO #(.DIR("OUTPUT")) jtag_clk_buf (.B(jtag_clk_pin), .I(jtag_clk));
    assign gn[15] = jtag_clk;

    localparam ctr_width = 28;
    localparam ctr_max = 2**ctr_width - 1;

    reg [ctr_width-1:0] R_blinky = 0;
    always @ (posedge clk_25mhz)
    begin
      R_blinky <= R_blinky+1;
    end
    
    assign led[7:4] = {R_blinky[ctr_width-1:ctr_width-4]};

    assign led[0] = jtag_tdo;
    assign led[1] = ftdi_txd;
    assign led[2] = ftdi_nrts;
    assign led[3] = ftdi_ndtr;
    
    assign ftdi_rxd = jtag_tdo;
    assign jtag_tdi = ftdi_txd;
    assign jtag_tms = ftdi_nrts;
    assign jtag_clk = ftdi_ndtr;

endmodule
