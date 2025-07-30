////////////////////////////////////////////////////////////////////////////////////////////////////////////
// DUAL PORT MEMORY ELEMENT RAM :
// Description :
//                    Dual port memory has separate control lines for both data ports
//                    the various mode of dual port memory are shown below
//  Note :
//       Mode 1    :  writing of data is posible through both the
//                    ports but not on same location
//      Mode 2 & 3 :  They are  busy in writing while other in reading
//
//      mode 4     :  Data can be read through both the ports even from same
//                    loaction
// INPUTS          :  addr_a_i, dina_i, clk_a_i, en_a_i, wea_i, addr_b_i, dinab_i, clkb_i,enb_i, web_i;
// OUTPUT          :  douta_o  doutb_o;
//
/////////////////////////////////////////////////////////////////////////
//
//   modes     en_a_i      we_a_i   en_b_i   we_b_i    porta     portb   //
//    1         1          1        1       1      write     write   //
//    2         1          1        1       0      write     read    //
//    3         1          0        1       1      read      write   //
//    4         1          0        1       0      read      read    //
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////


module dual_port_memory (
    input logic [2:0] addr_a_i,
    input logic [7:0] data_a_i,
    input logic       clk_a_i,
    input logic       en_a_i,
    input logic       we_a_i,

    input logic [2:0] addr_b_i,
    input logic [7:0] data_b_i,
    input logic       clk_b_i,
    input logic       en_b_i,
    input logic       we_b_i,

    output logic [7:0] data_a_o,
    output logic [7:0] data_b_o
);

  // Internal memory and mode
  logic [2:0] mode;
  logic [7:0] dual_port_ram[8];

  // Set mode using command-line argument
  initial begin
    if (!$value$plusargs("mode=%d", mode)) begin
      $display("No +mode= passed, defaulting to mode = 0");
      mode = 3'd0;
    end else begin
      $display("Mode selected via plusarg: %0d", mode);
    end
  end

  // Port A operations based on mode
  always_ff @(posedge clk_a_i) begin
    case (mode)
      3'd1, 3'd2: begin
        if (en_a_i && we_a_i) dual_port_ram[addr_a_i] <= data_a_i;
      end
      3'd3, 3'd4: begin
        if (en_a_i && !we_a_i) data_a_o <= dual_port_ram[addr_a_i];
      end

      default: begin
        data_a_o <= 'x;
      end
    endcase
  end
  // Port B operations based on mode
  always_ff @(posedge clk_b_i) begin
    case (mode)
      3'd1, 3'd3: begin
        if (en_b_i && we_b_i) dual_port_ram[addr_b_i] <= data_b_i;
      end

      3'd2, 3'd4: begin
        if (en_b_i && !we_b_i) data_b_o <= dual_port_ram[addr_b_i];
      end

      default: begin
        data_b_o <= 'dx;
      end
    endcase
  end

endmodule

module dual_port_memory_check ();

  reg  [2:0] addr_a;
  reg  [7:0] data_a;
  reg        clk_a;
  reg        en_a;
  reg        we_a;
  reg  [2:0] addr_b;
  reg  [7:0] data_b;
  reg        clk_b;
  reg        en_b;
  reg        we_b;
  wire [7:0] data_aout;
  wire [7:0] data_bout;

  dual_port_memory dut (
      .addr_a_i(addr_a),
      .data_a_i(data_a),
      .clk_a_i (clk_a),
      .en_a_i  (en_a),
      .we_a_i  (we_a),
      .addr_b_i(addr_b),
      .data_b_i(data_b),
      .clk_b_i (clk_b),
      .en_b_i  (en_b),
      .we_b_i  (we_b),
      .data_a_o(data_aout),
      .data_b_o(data_bout)
  );
  initial begin
    clk_a = 0;
    clk_b = 0;
  end
  always begin
    #5 clk_a = (~clk_a);
  end
  always begin
    #5 clk_b = (~clk_b);
  end
  initial begin
    repeat (5) begin
      dut.mode = 1;
      #100;
      dut.mode = 2;
      #100;
      dut.mode = 3;
      #100;
      dut.mode = 4;
      #100;
    end
  end

  initial begin
    repeat (4) begin
      //----------------------Writing-----------------------------//
      en_a   = 1;
      we_a   = 1;
      addr_a = 'd1;
      data_a = 'd05;
      en_b   = 1;
      we_b   = 1;
      addr_b = 'd2;
      data_b = 'd10;
      @(posedge clk_a) @(posedge clk_a) en_a = 1;
      we_a   = 1;
      addr_a = 'd3;
      data_a = 'd15;
      en_b   = 1;
      we_b   = 1;
      addr_b = 'd4;
      data_b = 'd20;
      @(posedge clk_a) @(posedge clk_a) en_a = 1;
      we_a   = 1;
      addr_a = 'd5;
      data_a = 'd25;
      en_b   = 1;
      we_b   = 1;
      addr_b = 'd6;
      data_b = 'd30;
      @(posedge clk_a)
      @(posedge clk_a)
      ///--------------------------- reading--------------------------//

      en_a = 1;
      we_a   = 0;
      addr_a = 3'd1;
      en_b   = 1;
      we_b   = 0;
      addr_b = 3'd2;
      @(posedge clk_a) @(posedge clk_a) en_a = 1;
      we_a   = 0;
      addr_a = 3'd3;
      en_b   = 1;
      we_b   = 0;
      addr_b = 3'd4;
      @(posedge clk_a) @(posedge clk_a) en_a = 1;
      we_a   = 0;
      addr_a = 3'd5;
      en_b   = 1;
      we_b   = 0;
      addr_b = 3'd6;
      @(posedge clk_a) @(posedge clk_a);
    end
    $stop;
  end
endmodule
