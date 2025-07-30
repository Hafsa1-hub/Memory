

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
// INPUTS          :  addr_ia, dina_i, clk_ia, en_ia, wea_i, addr_ib, dinab_i, clkb_i,enb_i, web_i;
// OUTPUT          :  douta_o  doutb_o;
//
/////////////////////////////////////////////////////////////////////////
//
//   modes     en_ia      we_ia   en_ib   we_ib    porta     portb   //
//    1         1          1        1       1      write     write   //
//    2         1          1        1       0      write     read    // 
//    3         1          0        1       1      read      write   //
//    4         1          0        1       0      read      read    //
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////
`include "single_port_ram.sv"

parameter int MODE=1;
module dual_port_memory_elements_ram (
  input  [2:0]     addr_ia  ,
  input  [7:0]     data_ina ,
  input            clk_ia   ,
  input            en_ia    ,
  input            we_ia    ,
  input  [2:0]     addr_ib  ,
  input  [7:0]     data_inb ,
  input            clk_ib   ,
  input            en_ib    ,
  input            we_ib    ,
  output reg[7:0]  data_outa,
  output reg [7:0] data_outb 
);

  reg [2:0] mode          ;
  reg [7:0] dual_port_ram[0:7];

//---------------  Port a instance  --------------------------------------------------//
single_port_ram port_a  (
      .addr_i(addr_ia),
      .data_i(data_ina),
      .clk_pi(clk_ia),
      .en_i  (en_ia),
      .we_pi (we_ia),
      .data_o(data_outa)
  );
//----------------- port b instance  -------------------------------------------------//
single_port_ram port_b (
      .addr_i(addr_ib),
      .data_i(data_inb),
      .clk_pi(clk_ib),
      .en_i  (en_ib),
      .we_pi (we_ib),
      .data_o(data_outb)
  );

  // Set mode using plusargs
 /* initial begin
    if (!$value$plusargs("mode=%d", mode)) begin
      $display("No +mode= passed, defaulting to 0");
      mode = 3'd0;
    end else begin
      $display("Using mode: %0d", mode);
    end
  end

  // Port A logic
  always @(posedge clk_ia) begin
    case (mode)
      3'd1, 3'd2: begin
        if(en_ia && we_ia) begin dual_port_ram[addr_ia] <= data_ina;end
      end
      3'd3, 3'd4: begin
        if(en_ia && !we_ia) begin data_outa <= dual_port_ram[addr_ia];end
      end
    endcase
  end

  // Port B logic
  always @(posedge clk_ib) begin
  mode = 3;
    case (mode)
      3'd1, 3'd3: begin
        if (en_ib && we_ib) dual_port_ram[addr_ib] <= data_inb;
      end
      3'd2, 3'd4: begin
        if (en_ib && !we_ib) data_outb <= dual_port_ram[addr_ib];
      end
    endcase
  end

endmodule
   */
   initial begin
   case (mode) 

    'd1   :   if (en_ia & we_ia)       begin  dual_port_ram[addr_ia] <=  data_ina           ;end
             // else                     begin  dual_port_ram          <=  dual_port_ram          ;end  

    'd2   :  if (en_ia & we_ia)        begin  dual_port_ram[addr_ia] <=  data_ina           ;end
              //else                     begin  dual_port_ram          <=  dual_port_ram          ;end  

    'd3   :   if (en_ia & (we_ia==0))  begin  data_outa          <=  dual_port_ram[addr_ia] ;end
              //else                     begin  data_outa          <=  data_outa;          end  

    'd4   :   if (en_ia & (we_ia==0))  begin  data_outa          <=  dual_port_ram[addr_ia] ;end
              //else                     begin  data_outa          <=  data_outa          ;end  

   endcase
end

always@(posedge clk_ib) begin
   case (mode) 
     'd1   :  if (en_ib & we_ib)       begin  dual_port_ram[addr_ib] <=  data_inb           ;end
              //else                //     begin  dual_port_ram          <=  dual_port_ram          ;end  
     'd2   :  if (en_ib & (we_ib==0))  begin  data_outb          <=  dual_port_ram[addr_ib] ;end
             // else                  //   begin  data_outb          <=  data_outb;          end  
     'd3   :  if (en_ib & we_ib)       begin  dual_port_ram[addr_ib] <=  data_inb           ;end
              //else                     begin  dual_port_ram          <=  dual_port_ram          ;end  
     'd4   :  if (en_ib & (we_ib==0))  begin  data_outb          <=  dual_port_ram[addr_ib] ;end
              //else                //     begin  data_outb          <=  data_outb;          end  
  endcase
end

//-------------------------------------------------------------------------------------------//


endmodule
////////////////////////////////////////////////////////////////////////////////////////////////////////////
//            Test bench 


`ifndef MODE
  `define MODE 1
`endif

module dual_port_memory_check #(MODE=1);

  reg [2:0] addr_a  ;
  reg [7:0] data_a  ;        
  reg       clk_a   ;
  reg       en_a    ;
  reg       we_a    ;
  reg [2:0] addr_b  ;
  reg [7:0] data_b  ;
  reg       clk_b   ;
  reg       en_b    ;
  reg       we_b    ;
  wire [7:0]data_aout;
  wire [7:0]data_bout;

reg [2:0] mode ;
dual_port_memory_elements_ram dut (
                                    .addr_ia   (  addr_a   ),
                                    . data_ina (  data_a   ),
                                    . clk_ia   (  clk_a    ),
                                    . en_ia    (  en_a     ),
                                    . we_ia    (  we_a     ),
                                    . addr_ib  (  addr_b   ),
                                    . data_inb (  data_b   ),
                                    . clk_ib   (  clk_b    ),
                                    . en_ib    (  en_b     ),
                                    . we_ib    (  we_b     ),
                                    . data_outa(  data_aout),
                                    . data_outb(  data_bout) 
                               );
  initial begin
   clk_a =0; clk_b = 0;
   //$monitor("PORT  A mode :: %d\t,enable_i :: %d\t,write enable :: %d\t address ::%d\t data :: %d\t if its read then output is %d\n",mode,en_ia,we_ia,addr_ia,data_ina,data_outa);
  // $monitor("PORT  B mode :: %d\t,enable_i :: %d\t,write enable :: %d\t address ::%d\t data :: %d\t if its read then output is %d\n",mode,en_ib,we_ib,addr_ib,data_inb,data_outb);
  end
  always begin 
    #5 clk_a = (~clk_a);
  end
  always begin 
    #5 clk_b = (~clk_b);
  end


  initial begin
    // Example for mode 3: A reads, B writes
    en_a = 1; we_a = 0;
    en_b = 1; we_b = 1;
  // mode = 3;
    addr_b = 3'd2;
    data_b = 8'hAB;
    #10;

    addr_a = 3'd2;
    #10;

    $stop;
  end
/*
  initial begin
  //checking for correct functility
    mode = 1;  // write 
////////////////////////////////////////////////////////////////////////////////////////////
    en_ia = 1; we_ia = 1 ; addr_ia = 'd5; data_ina = 'd10; //writing
    en_ib = 1; we_ib = 1 ; addr_ib = 'd6; data_inb = 'd11; //writing
    @(posedge clk_ia);
    en_ia = 1; we_ia = 1 ; addr_ia = 'd7; data_ina = 'd12; //writing
    en_ib = 1; we_ib = 1 ; addr_ib = 'd8; data_inb = 'd11; //writing
    @(posedge clk_ia);
    en_ia = 1; we_ia = 1 ; addr_ia = 'd9; data_ina = 'd13; //writing
    en_ib = 1; we_ib = 1 ; addr_ib = 'd10; data_inb = 'd14; //writing
////////////////////////////////////////////////////////////////////////////////////////////
    @(posedge clk_ia); @(posedge clk_ia);
    mode  = 2;  // write 
    en_ia = 1; we_ia = 1 ; addr_ia = 'd1; data_ina = 'd3; //writing
    en_ib = 1; we_ib = 0 ; addr_ib = 'd1;                 //Reading
    @(posedge clk_ia);
    en_ia = 1; we_ia = 1 ; addr_ia = 'd3; data_ina = 'd4; //writing
    en_ib = 1; we_ib = 0 ; addr_ib = 'd3;                 //Reading
    @(posedge clk_ia);
    en_ia = 1; we_ia = 1 ; addr_ia = 'd4; data_ina = 'd6; //writing
    en_ib = 1; we_ib = 0 ; addr_ib = 'd4;                 //Reading
    @(posedge clk_ia);

    @(posedge clk_ia);
    mode  = 3;  // write 
    en_ia = 1; we_ia = 0 ; addr_ia = 'd5;                  //Read
    en_ib = 1; we_ib = 1 ; addr_ib = 'd2; data_inb = 'd2; //writing
    @(posedge clk_ia);
     en_ia = 1; we_ia = 0 ; addr_ia = 'd4;                  //Read
     en_ib = 1; we_ib = 1 ; addr_ib = 'd12; data_inb = 'd14; //writing
    @(posedge clk_ia);
    @(posedge clk_ia);
    mode  = 4;  // write 
    en_ia = 1; we_ia = 0 ; addr_ia = 'd7;                  //Read
    en_ib = 1; we_ib = 0 ; addr_ib = 'd8;                 //Reading
    en_ia = 1; we_ia = 0 ; addr_ia = 'd9;                  //Read
    en_ib = 1; we_ib = 0 ; addr_ib = 'd10;                 //Reading
    en_ia = 1; we_ia = 0 ; addr_ia = 'd6;                  //Read
    en_ib = 1; we_ib = 0 ; addr_ib = 'd3;                 //Reading


  end
  initial #500 $stop;*/
endmodule
