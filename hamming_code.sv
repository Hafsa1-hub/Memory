// Bit Position | 1  | 2  | 3  | 4  | 5  | 6  | 7  |
// ------------ | -- | -- | -- | -- | -- | -- | -- |
// Bit Type     | P1 | P2 | D1 | P4 | D2 | D3 | D4 |
//P1 covers bits 1,3,5,7 |  P2 covers bits 2,3,6,7 | P4 covers bits 4,5,6,7
//When received, the parity bits are re-checked. 
//If there's a mismatch, you get a binary number that points to 
//the exact bit position with the error, which can then be flipped to correct.
// to find P1,P2,P3 We need to detect even or odd number of 1's we can do that
// by XOR -> odd detector  
//
/////////////////////////////////////////////////////////////////////////////////////////////////////// 
//Encoder of the hamming code
//Decoder of the Hammong code

//Syndrome Calculation
//
//Recalculate parity checks (based on corrupted code):
//
//    S1 = P1 ^ D1 ^ D2 ^ D4 = 0 ^ 1 ^ 0 ^ 1 = 0
//
//    S2 = P2 ^ D1 ^ D3 ^ D4 = 1 ^ 1 ^ 0 ^ 1 = 1
//
//    S4 = P4 ^ D2 ^ D3 ^ D4 = 0 ^ 0 ^ 0 ^ 1 = 1
//    Syndrome = {S4, S2, S1} = 3'b110 = 6

//   Error detected at bit position 6!
//
// Bit Position | 0  | 1  | 2  | 3  | 4  | 5  | 6  |
// ------------ | -- | -- | -- | -- | -- | -- | -- |
// Value        | 0  | 1  | 1  | 0  | 0  | 0  | 1  |
//              | P1 | P2 | D1 | P4 | D2 | D3 | D4 |
// ///////////////////////////////////////////////////////////////////////////////////////////////  

module encoder_hamming_code(
                     input [7:0] data_i,
                     output reg [7:0] data_o
                   );

// SYNDROME BITS
  reg [7:0] flip_bit;
  reg s1;
  reg s2;
  reg s3;
  reg [2:0] error_bit;
//------------------------------------S1 = P1 ^ D1 ^ D2 ^ D4 
  //initial begin
  always @(*) begin
    s1 = data_i[0]^data_i[2]^data_i[4]^data_i[6];
    s2 = data_i[1]^data_i[2]^data_i[5]^data_i[6];
    s3 = data_i[3]^data_i[4]^data_i[5]^data_i[6];
    error_bit = {s1,s2,s3};
    $display ("the syndrome bit a= %d\t we need to flip that number ",error_bit);
    data_o =  data_i ;
    data_o[error_bit] = (~data_i[error_bit]);
    $display ("the actual input data is %b\n the error corrected data after fliping the bit is %b\n",data_i,data_o);
    end
endmodule

module test;
  reg  [7:0] data_in;
  wire [7:0] data_out;

  encoder_hamming_code encoded_test (
                                     .data_i (data_in),
                                     .data_o (data_out)
                                   );
  initial begin
    data_in  = 'b0110001;
    #15;
    data_in  = 'b1000110;
    #5;
    data_in   = 'b00110011;
   // da=ia_in  = 'b0110011;
    #5;
    //data_in  = 'b1110001;
    
  end
endmodule
