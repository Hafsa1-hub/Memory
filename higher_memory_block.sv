//////////////////////////////////////////////////////////////////////////////////////////
//
//Description :
//            Higher capacity memory blocks can be realized by low capacity
//            memory blocks by cascading these RTL has the 32 X 8 ROM by using
//            8X8 Memory block
//Input  : address_i
//Output : data_o
//
//////////////////////////////////////////////////////////////////////////////////////////

module higher_memory_block (
    input      [4:0] address_i,
    output reg [7:0] data_o
);
  // 8x8 ROM
  reg [7:0] rom1_reg[8];
  reg [7:0] rom2_reg[8];
  reg [7:0] rom3_reg[8];
  reg [7:0] rom4_reg[8];


  // Initiliazing the ROM with some random Data
  initial begin
    //////////////////////////////////////////////////////////////////////////////////
    rom1_reg[0] = 0;
    rom2_reg[0] = 0;
    rom3_reg[0] = 0;
    rom4_reg[0] = 0;
    rom1_reg[1] = 1;
    rom2_reg[1] = 1;
    rom3_reg[1] = 1;
    rom4_reg[1] = 1;
    rom1_reg[2] = 2;
    rom2_reg[2] = 2;
    rom3_reg[2] = 2;
    rom4_reg[2] = 2;
    rom1_reg[3] = 3;
    rom2_reg[3] = 3;
    rom3_reg[3] = 3;
    rom4_reg[3] = 3;
    rom1_reg[4] = 4;
    rom2_reg[4] = 4;
    rom3_reg[4] = 4;
    rom4_reg[4] = 4;
    rom1_reg[5] = 5;
    rom2_reg[5] = 5;
    rom3_reg[5] = 5;
    rom4_reg[5] = 5;
    rom1_reg[6] = 6;
    rom2_reg[6] = 6;
    rom3_reg[6] = 6;
    rom4_reg[6] = 6;
    rom1_reg[7] = 7;
    rom2_reg[7] = 7;
    rom3_reg[7] = 7;
    rom4_reg[7] = 7;
  end
  //////////////////////////////////////////////////////////////////////////////////
  always @(address_i) begin
    case (address_i[4:3])
      'd0:     data_o = rom1_reg[address_i[2:0]];
      'd1:     data_o = rom2_reg[address_i[2:0]];
      'd2:     data_o = rom3_reg[address_i[2:0]];
      'd3:     data_o = rom4_reg[address_i[2:0]];
      default: data_o = 'd0;
    endcase
    $display("select of mux is ->%d\t address_i  -> %d\t data_out -> %d\t ", address_i[4:3],
             address_i[2:0], data_o);
  end
endmodule
/////////////////////TEST BENCH ////////////////////////////////////////////////////////////////////
//
module higher_memory_block_test ();
  reg  [4:0] addr_i;
  wire [7:0] data_out;

  higher_memory_block dut_test (
      .address_i(addr_i  ),
      .data_o   (data_out)
  );
  initial begin
    addr_i = 0;
    repeat (32) begin
      addr_i = addr_i;
      #20;
      addr_i = addr_i + 1;
    end
    $stop;
  end
endmodule
