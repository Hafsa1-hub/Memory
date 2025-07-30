///////////////////////////////////////////////////////////////////////////////
//dual_port_RAM
// Description :
//               In the simple dual port RAM writing is done thorugh only
//               port1 and reading is done through port1 and port2.
//               In Normal dual port RAM writing and reading can be done
//               though both port1 and port2.
//Input       :  addra,addrb,clk,wea
//Output      :  douta, doutb;
///////////////////////////////////////////////////////////////////////////////

`include "controlled_register.sv"

module simple_dual_port_ram (
    input      [1:0] addr_a_i,
    input            data_i,
    input      [1:0] addr_b_i,
    input            clk_i,
    input            wea_i,
    output reg       data_a_o,
    output reg       data_b_o
);
  reg q0, q1, q2, q3;
  reg d0, d1, d2, d3;
  reg ce0, ce1, ce2, ce3;
  controlled_register dff1 (
      .d_in  (d0),
      .ce_in (ce0),
      .clk_in(clk_i),
      .q_out (q0)
  );


  controlled_register dff2 (
      .d_in  (d1),
      .ce_in (ce1),
      .clk_in(clk_i),
      .q_out (q1)
  );
  controlled_register dff3 (
      .d_in  (d2),
      .ce_in (ce2),
      .clk_in(clk_i),
      .q_out (q2)
  );
  controlled_register dff4 (
      .d_in  (d3),
      .ce_in (ce3),
      .clk_in(clk_i),
      .q_out (q3)
  );
  assign d0 = data_i;
  assign d1 = data_i;
  assign d2 = data_i;
  assign d3 = data_i;
  //Based on address 2 bits  sel line we need to give write enable to temp_wea
  always @(posedge clk_i) begin
    case (addr_a_i[1:0])
      'd0: begin
        ce0 <= wea_i;
        if (wea_i == 0) begin
          data_a_o <= q0;
        end else begin
          data_a_o <= data_a_o;
        end
      end
      'd1: begin
        ce1 <= wea_i;
        if (wea_i == 0) begin
          data_a_o <= q1;
        end else begin
          data_a_o <= data_a_o;
        end
      end
      'd2: begin
        ce2 <= wea_i;
        if (wea_i == 0) begin
          data_a_o <= q2;
        end else begin
          data_a_o <= data_a_o;
        end
      end
      'd3: begin
        ce3 <= wea_i;
        if (wea_i == 0) begin
          data_a_o <= q3;
        end else begin
          data_a_o <= data_a_o;
        end
      end
      default: begin
        data_a_o <= 'd0;
      end
    endcase
    case (addr_b_i[1:0])
      'd0:     data_b_o <= q0;
      'd1:     data_b_o <= q1;
      'd2:     data_b_o <= q2;
      'd3:     data_b_o <= q3;
      default: data_b_o <= 'd0;
    endcase
  end
endmodule
/////////////////////////////////////////////////////////////////////////////////////
//Test bench
module simple_dual_port_ram_test ();
  reg  [1:0] addr_a_in;
  reg        data_in;
  reg  [1:0] addr_b_in;
  reg        clk_in;
  reg        wea_in;
  wire       data_aout;
  wire       data_bout;

  simple_dual_port_ram ram_test (
      .addr_a_i(addr_a_in),
      .data_i  (data_in),
      .addr_b_i(addr_b_in),
      .clk_i   (clk_in),
      .wea_i   (wea_in),
      .data_a_o(data_aout),
      .data_b_o(data_bout)
  );


  initial begin
    clk_in = 0;
  end
  always begin
    #5 clk_in = (~clk_in);
  end
  initial begin
    //repeat(5 ) begin
    @(negedge clk_in);
    @(negedge clk_in);
    wea_in = 1;
    addr_a_in = 1;
    data_in = 1;
    @(negedge clk_in);
    @(negedge clk_in);
     addr_a_in = 2;
    data_in = 1;

    @(negedge clk_in);
    wea_in = 0;
    addr_b_in = 1;
    //end
    #100;
    $stop;
  end
endmodule

