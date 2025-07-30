//////////////////////////////////////////////////////////////////////////////////////////
// Multi bank memory controller
//The controller should route read and write operations to the appropriaate
//memory bank basedon the address instantiate smaller memory modules with read
//and write port
//It had Adress deocding bank selection and data routing
//
//---------------------------------------------------------------------------
// address ->0 -> BANK_0 -> 0 To 7 independent locations for write and read operation
// address ->1 -> BANK_1 -> 0 To 7 independent locations for write and read operation
// address ->2 -> BANK_2 -> 0 To 7 independent locations for write and read operation
// address ->3 -> BANK_3 -> 0 To 7 independent locations for write and read operation
// --------------------------------------------------------------------------
//
// INPUTS : en,we,din,addr,clk
// OUTPUT : dout
/////////////////////////////////////////////////////////////////////////////////////////////////////////


module multi_bank_memory_controller (
    input  wire [4:0] addr_i,
    input  wire [7:0] data_i,
    input             clk_pi,
    input             en_i,
    input             we_pi,
    output reg  [7:0] data_o
);

  reg [7:0][7:0] temp_rom[4];
  reg [1:0] bank_sel;
  reg [2:0] address_sel;
  always @(posedge clk_pi) begin
    bank_sel    <=addr_i[4:3];
    address_sel <= addr_i[2:0];
    if (en_i & we_pi) begin
      temp_rom[bank_sel][address_sel] <= data_i;
      $strobe("WRITE :: ADDRESS :: %d\t DATA :: %d\t ROM :: %p\t", addr_i, data_i, temp_rom);
    end else if (en_i & (!we_pi)) begin
      data_o <= temp_rom[bank_sel][address_sel];
      $strobe("READ :: ADDRESS :: %d\t OUT DATA :: %d\t ROM :: %p\t", addr_i, data_o, temp_rom);
    end else begin
      data_o <= 0;
      $display("Enable is LOW ");
    end
  end
endmodule


/*




  always @(posedge clk_pi) begin
  bank_sel =addr_i[4:3];
  address_sel = addr_i[2:0];
  temp_rom[bank_sel][address_sel] = data_i;
    case (bank_sel)
    'd0 : // writing into ram
         if (en_i & we_pi) begin
           temp_rom[bank_sel][address_sel] = data_i;
           $strobe("WRITE :: BANK 0 ADDRESS :: %d\t DATA :: %d\t ROM :: %p\t", addr_i[4:2], data_i, temp_rom);
         end else if (en_i & (!we_pi)) begin
           data_o = temp_rom[addr_i];
           $strobe("READ ::BANK 0 ADDRESS :: %d\t OUT DATA :: %d\t ROM :: %p\t", addr_i[4:2], data_o, temp_rom);
         end else begin
           data_o = 0;
           $display("Enable is LOW ");
         end
    'd1 : // writing into ram
         if (en_i & we_pi) begin
           temp_rom[{addr_i[1:0],addr_i[4:2]}] = data_i;
           $strobe("WRITE ::BANK 1 ADDRESS :: %d\t DATA :: %d\t ROM :: %p\t", addr_i[4:2], data_i, temp_rom);
         end else if (en_i & (!we_pi)) begin
           data_o = temp_rom[addr_i];
           $strobe("READ :: BANK 1 ADDRESS :: %d\t OUT DATA :: %d\t ROM :: %p\t", addr_i[4:2], data_o, temp_rom);
         end else begin
           data_o = 0;
           $display("Enable is LOW ");
         end
     'd2 : // writing into ram
         if (en_i & we_pi) begin
           temp_rom[{addr_i[1:0],addr_i[4:2]}] = data_i;
           $strobe("WRITE ::BANK 2 ADDRESS :: %d\t DATA :: %d\t ROM :: %p\t", addr_i[4:2], data_i, temp_rom);
         end else if (en_i & (!we_pi)) begin
           data_o = temp_rom[addr_i];
           $strobe("READ :: BANK 2 ADDRESS :: %d\t OUT DATA :: %d\t ROM :: %p\t", addr_i[4:2], data_o, temp_rom);
         end else begin
           data_o = 0;
           $display("Enable is LOW ");
         end
   'd3 : // writing into ram
         if (en_i & we_pi) begin
           temp_rom[{addr_i[1:0],addr_i[4:2]}] = data_i;
           $strobe("WRITE ::BANK 3    @(negedge clk)
 ADDRESS :: %d\t DATA :: %d\t ROM :: %p\t", addr_i[4:2], data_i, temp_rom);
         end else if (en_i & (!we_pi)) begin
           data_o = temp_rom[addr_i];
           $strobe("READ ::BANK 3 ADDRESS :: %d\t OUT DATA :: %d\t ROM :: %p\t", addr_i[4:2], data_o, temp_rom);
         end else begin
           data_o = 0;
           $display("Enable is LOW ");
         end
   default: begin
        data_o <= 'x;
      end
   endcase
  end

endmodule

*/
module test_multi_bank_ram ();
  reg  [4:0] address;
  reg  [7:0] din;
  reg        clk;
  reg        en;
  reg        we;
  wire [7:0] dout;
  reg  [1:0] bank_sel;
  reg  [2:0] address_sel;

  multi_bank_memory_controller multi_bank (
      .addr_i(address),
      .data_i(din),
      .clk_pi(clk),
      .en_i  (en),
      .we_pi (we),
      .data_o(dout)
  );
  initial begin
    clk = 0;
    bank_sel    <=address[4:3];
    address_sel <= address[2:0];

  end
  always begin
    #5 clk = (~clk);
    address = {bank_sel, address_sel};
  end
  initial begin
    repeat (200) begin
      bank_sel    = 0;  // BANK A
      address_sel = $urandom;
      din         = $urandom;
      en          = 1;
      we          = 1;  // writing
      @(negedge clk) @(negedge clk) bank_sel = 0;  // BANK A
      address_sel = $urandom;
      en          = 1;
      we          = 0;  // reading
      @(negedge clk);
      @(negedge clk) bank_sel = 1;  // BANK B
      address_sel = 2;
      address_sel = $urandom;
      din         = $urandom;
      en          = 1;
      we          = 1;  // writing
      @(negedge clk) @(negedge clk) bank_sel = 1;  // BANK B
      address_sel = $urandom;
      en          = 1;
      we          = 0;
      @(negedge clk);
      @(negedge clk) bank_sel = 2;  // BANK B
      address_sel = $urandom;
      din         = $urandom;
      en          = 1;
      we          = 1;  // writing
      @(negedge clk) @(negedge clk) bank_sel = 2;  // BANK B
      address_sel = $urandom;
      en          = 1;
      we          = 0;
      @(negedge clk);
      @(negedge clk) bank_sel = 3;  // BANK B
      address_sel = $urandom;
      din         = $urandom;
      din         = 4;
      en          = 1;
      we          = 1;  // writing
      @(negedge clk) @(negedge clk) bank_sel = 3;  // BANK B
      address_sel = $urandom;
      en          = 1;
      we          = 0;
      @(negedge clk) @(negedge clk) @(negedge clk) @(negedge clk) @(negedge clk);
    end
    $stop;
  end
endmodule




