
//Description:
//            controlled register can be considered as a basic element of large memory block
//            It has a control enable CE Input along with reset preset input
//            when CE is high data is loaded into controlled register and output will be unchanged until the any change in  CE
//            THe Controlled registeris useful when we want to store a data
//            vactor or a scalar data.
// Input   :  D_in, CE clk
// Output  :  q
module controlled_register (
    input      d_in,
    input      ce_in,
    input      clk_in,
    output reg q_out
);

  always @(posedge clk_in) begin
    if (ce_in) begin
      q_out <= d_in;
    end else begin
      q_out <= q_out;
    end
  end
endmodule


module controlled_reg_test ();
  reg  d0;
  reg  ce;
  reg  clk;
  wire q0;
  controlled_register U0 (
      .d_in  (d0),
      .ce_in (ce),
      .clk_in(clk),
      .q_out (q0)
  );
  initial begin
    clk = 1;
  end
  always begin
    #5 clk = ~(clk);
  end
  initial begin
    ce = 0;
    d0 = 0;
    @(negedge clk);
    ce = 1;
    d0 = 0;
    @(negedge clk);
    ce = 1;
    d0 = 1;
    @(negedge clk);
    ce = 0;
    d0 = 0;
    @(negedge clk);
    ce = 0;
    d0 = 1;
    @(negedge clk);
    #50 $stop;
  end
endmodule
