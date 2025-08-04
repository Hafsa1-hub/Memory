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

// Hamming (12,8) Encoder
module hamming_encoder (
  input  logic [7:0] data_i,
  output logic [11:0] code_o
);
  logic p1, p2, p4, p8;

  always_comb begin
    code_o[2]  = data_i[7]; // position 3
    code_o[4]  = data_i[6]; // position 5
    code_o[5]  = data_i[5]; // position 6
    code_o[6]  = data_i[4]; // position 7
    code_o[8]  = data_i[3]; // position 9
    code_o[9]  = data_i[2]; // position 10
    code_o[10] = data_i[1]; // position 11
    code_o[11] = data_i[0]; // position 12

    // parity bits
    p1 = code_o[2] ^ code_o[4] ^ code_o[6] ^ code_o[8] ^ code_o[10];
    p2 = code_o[2] ^ code_o[5] ^ code_o[6] ^ code_o[9] ^ code_o[10];
    p4 = code_o[4] ^ code_o[5] ^ code_o[6] ^ code_o[11];
    p8 = code_o[8] ^ code_o[9] ^ code_o[10] ^ code_o[11];

    code_o[0] = p1; // position 1
    code_o[1] = p2; // position 2
    code_o[3] = p4; // position 4
    code_o[7] = p8; // position 8
  end
endmodule


// Hamming (12,8) Decoder
module hamming_decoder (
  input  logic [11:0] code_i,
  output logic [7:0] data_o,
  output logic       error_detected
);
  logic [3:0] syndrome;
  logic [11:0] corrected;

  always_comb begin
    syndrome[0] = code_i[0] ^ code_i[2] ^ code_i[4] ^ code_i[6] ^ code_i[8] ^ code_i[10];
    syndrome[1] = code_i[1] ^ code_i[2] ^ code_i[5] ^ code_i[6] ^ code_i[9] ^ code_i[10];
    syndrome[2] = code_i[3] ^ code_i[4] ^ code_i[5] ^ code_i[6] ^ code_i[11];
    syndrome[3] = code_i[7] ^ code_i[8] ^ code_i[9] ^ code_i[10] ^ code_i[11];

    corrected = code_i;
    error_detected = (syndrome != 4'd0);

    if (error_detected) begin
      corrected[syndrome - 1] = ~corrected[syndrome - 1];
    end

    data_o = { corrected[2], corrected[4], corrected[5], corrected[6],
               corrected[8], corrected[9], corrected[10], corrected[11] };
  end
endmodule


// Simple Testbench
module tb_hamming;
  logic [7:0] data;
  logic [11:0] encoded, corrupted;
  logic [7:0] decoded;
  logic error;

  hamming_encoder enc(.data_i(data), .code_o(encoded));
  hamming_decoder dec(.code_i(corrupted), .data_o(decoded), .error_detected(error));

  initial begin
    data = 8'b00110011;
    #1;
    $display("Original Data     = %b", data);
    $display("Encoded Hamming   = %b", encoded);

    // Inject 1-bit error at bit 6 (index 5)
    corrupted = encoded;
    corrupted[5] = ~corrupted[5];

    #1;
    $display("Corrupted Code    = %b", corrupted);
    $display("Decoded Data      = %b", decoded);
    $display("Error Detected?   = %b", error);
    $finish;
  end
endmodule



//////////////////////////////////////////////////////////////////////////////////////////////////
module encoder_hamming_code(
    input  [7:0] data_i,
    output reg [7:0] data_o
);

// Internal variables
reg s1, s2, s3;
reg [2:0] error_bit;
integer error_index;

always @(*) begin
    // Compute syndrome bits
    s1 = data_i[0] ^ data_i[2] ^ data_i[4] ^ data_i[6];
    s2 = data_i[1] ^ data_i[2] ^ data_i[5] ^ data_i[6];
    s3 = data_i[3] ^ data_i[4] ^ data_i[5] ^ data_i[6];
    error_bit = {s3, s2, s1};  // Note the order: MSB to LSB
    error_index = error_bit;  // Convert to integer for indexing

    data_o = data_i;

    // Only flip if error index is non-zero and in range
    if (error_index > 0 && error_index < 8) begin
        data_o[error_index] = ~data_i[error_index];
        $display("Error detected at bit %0d", error_index);
    end else begin
        $display("No error detected.");
    end

    $display("Original data: %b", data_i);
    $display("Corrected data: %b", data_o);
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
    #10;
    data_in  = 'b1000110;
    #5;
    data_in   = 'b00110011;
   // da=ia_in  = 'b0110011;
    #5;
    //data_in  = 'b1110001;
    
  end
endmodule
