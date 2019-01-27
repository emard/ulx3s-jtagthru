module jtagthru
(
  input clk_pin,
  input btn_pin,
  output [7:0] led_pin,

  output ftdi_rxd_pin,
  input jtag_tdo_pin,

  input ftdi_txd_pin, ftdi_nrts_pin, ftdi_ndtr_pin,
  output jtag_tdi_pin, jtag_tms_pin, jtag_clk_pin,

  output gpio0_pin
);
    wire clk;
    wire [7:0] led;
    wire btn;
    wire gpio0;

    (* LOC="G2" *) (* IO_TYPE="LVCMOS33" *)
    TRELLIS_IO #(.DIR("INPUT")) clk_buf (.B(clk_pin), .O(clk));

    (* LOC="R1" *) (* IO_TYPE="LVCMOS33" *)
    TRELLIS_IO #(.DIR("INPUT")) btn_buf (.B(btn_pin), .O(btn));

    (* LOC="B2" *) (* IO_TYPE="LVCMOS33" *)
    TRELLIS_IO #(.DIR("OUTPUT")) led_buf_0 (.B(led_pin[0]), .I(led[0]));
    (* LOC="C2" *) (* IO_TYPE="LVCMOS33" *)
    TRELLIS_IO #(.DIR("OUTPUT")) led_buf_1 (.B(led_pin[1]), .I(led[1]));
    (* LOC="C1" *) (* IO_TYPE="LVCMOS33" *)
    TRELLIS_IO #(.DIR("OUTPUT")) led_buf_2 (.B(led_pin[2]), .I(led[2]));
    (* LOC="D2" *) (* IO_TYPE="LVCMOS33" *)
    TRELLIS_IO #(.DIR("OUTPUT")) led_buf_3 (.B(led_pin[3]), .I(led[3]));

    (* LOC="D1" *) (* IO_TYPE="LVCMOS33" *)
    TRELLIS_IO #(.DIR("OUTPUT")) led_buf_4 (.B(led_pin[4]), .I(led[4]));
    (* LOC="E2" *) (* IO_TYPE="LVCMOS33" *)
    TRELLIS_IO #(.DIR("OUTPUT")) led_buf_5 (.B(led_pin[5]), .I(led[5]));
    (* LOC="E1" *) (* IO_TYPE="LVCMOS33" *)
    TRELLIS_IO #(.DIR("OUTPUT")) led_buf_6 (.B(led_pin[6]), .I(led[6]));
    (* LOC="H3" *) (* IO_TYPE="LVCMOS33" *)
    TRELLIS_IO #(.DIR("OUTPUT")) led_buf_7 (.B(led_pin[7]), .I(led[7]));


    (* LOC="L2" *) (* IO_TYPE="LVCMOS33" *)
    TRELLIS_IO #(.DIR("OUTPUT")) gpio0_buf (.B(gpio0_pin), .I(gpio0));

    wire ftdi_rxd, ftdi_txd, ftdi_nrts, ftdi_ndtr;

    (* LOC="L4" *) (* IO_TYPE="LVCMOS33" *)
    TRELLIS_IO #(.DIR("OUTPUT")) ftdi_rxd_buf (.B(ftdi_rxd_pin), .I(ftdi_rxd));

    (* LOC="M1" *) (* IO_TYPE="LVCMOS33" *)
    TRELLIS_IO #(.DIR("INPUT")) ftdi_txd_buf (.B(ftdi_txd_pin), .O(ftdi_txd));
    (* LOC="M3" *) (* IO_TYPE="LVCMOS33" *)
    TRELLIS_IO #(.DIR("INPUT")) ftdi_nrts_buf (.B(ftdi_nrts_pin), .O(ftdi_nrts));
    (* LOC="N1" *) (* IO_TYPE="LVCMOS33" *)
    TRELLIS_IO #(.DIR("INPUT")) ftdi_ndtr_buf (.B(ftdi_ndtr_pin), .O(ftdi_ndtr));

    wire jtag_tdo, jtag_tdi, jtag_tms, jtag_clk;

    (* LOC="U17" *) (* IO_TYPE="LVCMOS33" *) // gn14
    TRELLIS_IO #(.DIR("INPUT")) jtag_tdo_buf (.B(jtag_tdo_pin), .O(jtag_tdo));

    (* LOC="N17" *) (* IO_TYPE="LVCMOS33" *) // gp15
    TRELLIS_IO #(.DIR("OUTPUT")) jtag_tdi_buf (.B(jtag_tdi_pin), .I(jtag_tdi));
    (* LOC="U18" *) (* IO_TYPE="LVCMOS33" *) // gp14
    TRELLIS_IO #(.DIR("OUTPUT")) jtag_tms_buf (.B(jtag_tms_pin), .I(jtag_tms));
    (* LOC="P16" *) (* IO_TYPE="LVCMOS33" *) // gn15
    TRELLIS_IO #(.DIR("OUTPUT")) jtag_clk_buf (.B(jtag_clk_pin), .I(jtag_clk));


    // Tie GPIO0, keep board from rebooting
    assign gpio0 = 1'b1;

    localparam ctr_width = 28;
    localparam ctr_max = 2**ctr_width - 1;

    reg [ctr_width-1:0] R_blinky = 0;
    always @ (posedge clk)
    begin
      R_blinky <= R_blinky+1;
    end
    
    assign led[4] = btn;
    assign led[7:5] = R_blinky[ctr_width-1:ctr_width-3] & {btn,btn,btn};

    assign led[0] = jtag_tdo;
    assign led[1] = ftdi_txd;
    assign led[2] = ftdi_nrts;
    assign led[3] = ftdi_ndtr;
    
    assign ftdi_rxd = jtag_tdo;
    assign jtag_tdi = ftdi_txd;
    assign jtag_tms = ftdi_nrts;
    assign jtag_clk = ftdi_ndtr;

endmodule
