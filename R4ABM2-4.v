`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.03.2022 16:46:06
// Design Name: 
// Module Name: Radix4
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Radix4 #(
    parameter N = 16                // Width = N: multiplicand & multiplier
)(
    input   Rst,                    // Reset
    input   Clk,                    // Clock
    
    input   Ld,                     // Load Registers and Start Multiplier
    input   [(N - 1):0] M,          // Multiplicand
    input   [(N - 1):0] R,          // Multiplier
    output  reg Valid,              // Product Valid
    output  reg [((2*N) - 1):0] P   // Product <= M * R
);


localparam pNumCycles = ((N + 1)/2);    // No. of cycles required for product

///////////////////////////////////////////////////////////////////////////////
//
//  Declarations
//

reg     [4:0] Cntr;         // Operation Counter
reg     [2:0] Booth;        // Booth Recoding Field
reg     Guard;              // Shift Bit for Booth Recoding

reg     [(N + 1):0] A;      // Multiplicand w/ guards
reg     [(N + 1):0] S;      // Adder w/ guards
wire    [(N + 1):0] Hi;     // Upper Half of Product w/ guards

reg     [((2*N) + 1):0] Prod;   // Double Length Product w/ guards

///////////////////////////////////////////////////////////////////////////////
//
//  Implementation
//

always @(posedge Clk)
begin
    if(Rst)
        Cntr <=  0;
    else if(Ld)
        Cntr <=  pNumCycles;
    else if(|Cntr)
        Cntr <=  (Cntr - 1);
end

//  Multiplicand Register
//      includes 2 bits to guard sign of multiplicand in the event the most
//      negative value is provided as the input.

always @(posedge Clk)
begin
    if(Rst)
        A <=  0;
    else if(Ld)
        A <=  {{2{M[(N - 1)]}}, M};
end

//  Compute Upper Partial Product: (N + 2) bits in width

always @(*) Booth <= {Prod[1:0], Guard};    // Booth's Multiplier Recoding fld

assign Hi = Prod[((2*N) + 1):N];    // Upper Half of the Product Register

always @(*)
begin
    case(Booth)
        3'b000  : S <= Hi + {14'b00000000000000,A[3:0]};              // Prod <= (Prod + 0*A) >> 2;
        3'b001  : S <= Hi +  A;         // Prod <= (Prod + 1*A) >> 2;
        3'b010  : S <= Hi +  A;         // Prod <= (Prod + 1*A) >> 2;
        3'b011  : S <= Hi + {A[16:3],A[3:0]};  // Prod <= (Prod + 2*A) >> 2;
        3'b100  : S <= Hi - {A[16:3],A[3:0]};  // Prod <= (Prod - 2*A) >> 2;
        3'b101  : S <= Hi -  A;         // Prod <= (Prod - 1*A) >> 2;
        3'b110  : S <= Hi -  A;         // Prod <= (Prod - 1*A) >> 2;
        3'b111  : S <= Hi + {14'b00000000000000,~A[3:0]};              // Prod <= (Prod - 0*A) >> 2;
    endcase
end

//  Double Length Product Register
//      Multiplier, R, is loaded into the least significant half on load, Ld.
//      Shifted right two places as the product is computed iteratively.

always @(posedge Clk)
begin
    if(Rst)
        Prod <=  0;
    else if(Ld)
        Prod <=  R;
    else if(|Cntr)  // Shift right two bits
        Prod <=  {{2{S[(N + 1)]}}, S, Prod[(N - 1):2]};
end

always @(posedge Clk)
begin
    if(Rst)
        Guard <=  0;
    else if(Ld)
        Guard <=  0;
    else if(|Cntr)
        Guard <=  Prod[1];
end

//  Assign the product less the two guard bits to the output port
//      A double right shift is required since the output product is stored
//      into a synchronous register on the last cycle of the multiply.

always @(posedge Clk)
begin
    if(Rst)
        P <=  0;
    else if(Cntr == 1)
        P <=  {S, Prod[(N - 1):2]};
end

//  Count the number of shifts
//      This implementation does not use any optimizations to perform multiple
//      bit shifts to skip over runs of 1s or 0s.

always @(posedge Clk)
begin
    if(Rst)
        Valid <=  0;
    else
        Valid <=  (Cntr == 1);
end

    
endmodule

