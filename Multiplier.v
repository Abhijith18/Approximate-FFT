
module Multiplier #(parameter N=16)(
	input [N-1:0] y,	
	input [N-1:0] x,	
	
	output [2*N-1:0] result
	);

	reg [((2-(N%2))+N) :0] padded; 
	wire [N+1:0] y_ext;
	assign y_ext = {2'b00 , y};
	
	reg [2*N-1:0] ans;
	integer i;
	always @ (*) begin
		padded = { x , 1'b0 };
		ans = 0;
		for( i=0 ; i <= N ; i = i + 2 ) begin	
			case ({padded[i+2],padded[i+1],padded[i]})
				3'b000 : ans = ans + (y_ext << i);		
				3'b010 : ans = ans + (y_ext << i);		
				3'b011 : ans = ans + (2*y_ext << i);		
				3'b100 : ans = ans + (-2*y_ext<< i);		
				3'b101 : ans = ans + (-1*y_ext<< i);		
				3'b110 : ans = ans + (-1*y_ext<< i);		
			endcase
		end
	end
	
	assign result = ans;
	
endmodule
