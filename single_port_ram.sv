
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

module single_port_ram (
    input  wire [2:0] addr_i,
    input  wire [7:0] data_i,
    input             clk_pi,
    input             en_i,
    input             we_pi,
    output reg  [7:0] data_o
);

  reg [7:0] temp_rom[8];

  always @(posedge clk_pi) begin
    // writing into ram
    if (en_i & we_pi) begin
      temp_rom[addr_i] = data_i;
      $strobe("WRITE :: ADDRESS :: %d\t DATA :: %d\t ROM :: %p\t", addr_i, data_i, temp_rom);
    end else if (en_i & (!we_pi)) begin
      data_o = temp_rom[addr_i];
      $strobe("READ :: ADDRESS :: %d\t OUT DATA :: %d\t ROM :: %p\t", addr_i, data_o, temp_rom);
    end else begin
      data_o = 0;
      $display("Enable is LOW ");
    end
  end
endmodule
///////////////////////////////////////////////////////////////////////////////////////////////
//TEST BENCH

module test_single_port_ram ();
  reg  [2:0] addr;
  reg  [7:0] din;
  reg        clk;
  reg        en;
  reg        we;
  wire [7:0] dout;

  single_port_ram test (
      .addr_i(addr),
      .data_i(din),
      .clk_pi(clk),
      .en_i  (en),
      .we_pi (we),
      .data_o(dout)
  );
  initial begin
    clk = 0;
  end
  always begin
    #5 clk = (~clk);
  end
  initial begin
    addr = 1;
    din  = 4;
    en   = 1;
    we   = 1;  // writing
    @(negedge clk) addr = 1;
    en   = 0;
    we   = 0;  // reading
    addr = 2;
    din  = 5;
    en   = 1;
    we   = 1;  // writing
    @(negedge clk) addr = 2;
    en = 1;
    we = 0;  // reading
    @(negedge clk) @(negedge clk) addr = 3;
    din = 6;
    en  = 1;
    we  = 1;  // writing
    @(negedge clk) addr = 3;
    en = 1;
    we = 0;  // reading
    @(negedge clk) @(negedge clk) addr = 4;
    din = 7;
    en  = 1;
    we  = 1;  // writing
    @(negedge clk) addr = 4;
    en = 1;
    we = 0;  // reading
    @(negedge clk) @(negedge clk) addr = 5;
    din = 8;
    en  = 1;
    we  = 1;  // writing
    @(negedge clk) addr = 5;
    en = 1;
    we = 0;  // reading
    @(negedge clk);
    @(negedge clk) $stop;


  end
endmodule
