
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// DUAL PORT MEMORY ELEMENT ROM :
// Description:
//                Dual port memory have simlified many problems in designing
//                digital system in both  ROM and RAM same address is possible
//                to acess through different loaction
//
// INPUTS      :  addr_ia, clk_ia, ena_ia, addr_ib, clkb_i, enb_i;
// OUTPUT      :  douta_o  doutb_o;
////////////////////////////////////////////////////////////////////////////////////////////////////////////


module dual_port_memory_elements_rom (
    input      [2:0] addr_a_i,
    input            clk_i,
    input            en_a_i,
    input      [2:0] addr_b_i,
    input            en_b_i,
    output reg [7:0] data_a_o,
    output reg [7:0] data_b_o
);
  reg [7:0] temp_rom[8];

  initial begin
    temp_rom[0] <= 2;
    temp_rom[1] <= 4;
    temp_rom[2] <= 8;
    temp_rom[3] <= 16;
    temp_rom[4] <= 32;
    temp_rom[5] <= 64;
    temp_rom[6] <= 6;
    temp_rom[7] <= 9;
  end

  always @(posedge clk_i) begin
    if (en_a_i) begin
      data_a_o <= temp_rom[addr_a_i];
    end else if (en_b_i) begin
      data_b_o <= temp_rom[addr_b_i];
    end else begin
      data_a_o <= data_a_o;
      data_b_o <= data_b_o;
    end
  end
endmodule

module dual_port_rom_test ();
  reg  [2:0] addr_ain;
  reg        clk_in;
  reg        en_a_in;
  reg  [2:0] addr_bin;
  reg        en_b_in;
  wire [7:0] data_a_out;
  wire [7:0] data_b_out;


  dual_port_memory_elements_rom ROM (
      .addr_a_i(addr_ain),
      .clk_i   (clk_in),
      .en_a_i  (en_a_in),
      .addr_b_i(addr_bin),
      .en_b_i  (en_b_in),
      .data_a_o(data_a_out),
      .data_b_o(data_b_out)
  );

  initial begin
    clk_in = 0;
  end
  always begin
    #5 clk_in = (~clk_in);
  end
  initial begin
    //en_a_in = 0;
    repeat (5) begin
      @(negedge clk_in);
      en_a_in  = 1;
      addr_ain = 'd5;
      $display("data received FOR PORT A at address::%d\t data :: %d\t", addr_ain, data_a_out);
      @(negedge clk_in);
      en_a_in  = 0;
      en_b_in  = 1;
      addr_bin = 'd6;
      $display("data received FOR PORT B at address::%d\t data :: %d\t", addr_bin, data_b_out);
      @(negedge clk_in);
      en_a_in  = 0;
      addr_ain = 'd7;
      $display("data received FOR PORT A at address::%d\t data :: %d\t", addr_ain, data_a_out);
      @(negedge clk_in);
      en_b_in  = 1;
      addr_bin = 'd8;
      $display("data received FOR PORT B at address::%d\t data :: %d\t", addr_bin, data_b_out);
      @(posedge clk_in);
      @(posedge clk_in);
      @(posedge clk_in);
    end
    $stop;
  end
endmodule
