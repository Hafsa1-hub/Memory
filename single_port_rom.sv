
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// Single port Random acess memory
// RAM block are used to store data tempraily in digital system .
// in single port RAM , writing and reading ia done in one port only
// when en and we are high data is writtern into RAM
// en is high but we is low reading through RAM can be done
//
// INPUTS : en,we,din,addr,clk
// OUTPUT : dout
/////////////////////////////////////////////////////////////////////////////////////////////////////////

module single_port_rom (
    input  wire [2:0] addr_i,
    input             clk_pi,
    input             en_i,
    output reg  [7:0] data_o
);

  reg [7:0] temp_rom [8];
    // writing into ROM with some initial values
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
  always @(posedge clk_pi) begin
    if (en_i) begin
      data_o  <= temp_rom[addr_i];
      $strobe ("THe data of the data_o is %d\t and address is %d\t",data_o,en_i);
    end
  end
endmodule
///////////////////////////////////////////////////////////////////////////////////////////////
//TEST BENCH

module test_single_port_rom ();
  reg  [2:0] addr;
  reg        clk;
  reg        en;
  wire [7:0] dout;

  single_port_rom test (
      .addr_i(addr),
      .clk_pi(clk),
      .en_i  (en),
      .data_o(dout)
  );
  initial begin
    clk = 0;
  end
  always begin
    #5 clk = (~clk);
  end
  initial begin
    addr = 1; en = 0 ;
    @(negedge clk) addr = 1; en   = 1;
    @(negedge clk) addr = 2; en   = 1;
    @(negedge clk) addr = 3; en   = 1;
    @(negedge clk) addr = 4; en   = 1;
    @(negedge clk) $stop;


  end
endmodule



