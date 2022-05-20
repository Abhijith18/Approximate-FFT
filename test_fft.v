module TB_FFT;

reg signed [31:0] in_data_real;
reg signed [31:0] in_data_im;
reg clk, reset;

wire signed [31:0] bf2_output_0_real, bf2_output_1_real, bf2_output_2_real, bf2_output_3_real;
wire signed [31:0] bf2_output_0_im, bf2_output_1_im, bf2_output_2_im, bf2_output_3_im;

FFT_R4_16p F1(.clk(clk), .reset(reset), 
.in_data_real(in_data_real), .in_data_im(in_data_im),
.bf2_output_0_real(bf2_output_0_real),
.bf2_output_1_real(bf2_output_1_real),
.bf2_output_2_real(bf2_output_2_real),
.bf2_output_3_real(bf2_output_3_real),
.bf2_output_0_im(bf2_output_0_im),
.bf2_output_1_im(bf2_output_1_im),
.bf2_output_2_im(bf2_output_2_im),
.bf2_output_3_im(bf2_output_3_im));

initial begin
    clk <=1;
    forever #50 clk <= ~clk;
end

initial begin
    reset <=1;
    #25 reset <=0;
end

initial begin
    //in_data <= 32'd99;
    #45 in_data_real <= 32'b0;
    #100 in_data_real <= 1;
    #100 in_data_real <= 2;
    #100 in_data_real <= 3;
    #100 in_data_real <= 1;
    #100 in_data_real <= 2;
    #100 in_data_real <= 3;
    #100 in_data_real <= 1;
    #100 in_data_real <= 2;
    #100 in_data_real <= 3;
    #100 in_data_real <= 1;
    #100 in_data_real <= 2;
    #100 in_data_real <= 3;
    #100 in_data_real <= 1;
    #100 in_data_real <= 2;
    #100 in_data_real <= 3;
    
    
end

initial begin
    //in_data <= 32'd99;
    #45 in_data_im <= 32'b0;
    #100 in_data_im <= 1;
    #100 in_data_im <= 2;
    #100 in_data_im <= 3;
    #100 in_data_im <= 1;
    #100 in_data_im <= 2;
    #100 in_data_im <= 3;
    #100 in_data_im <= 1;
    #100 in_data_im <= 2;
    #100 in_data_im <= 3;
    #100 in_data_im <= 1;
    #100 in_data_im <= 2;
    #100 in_data_im <= 3;
    #100 in_data_im <= 1;
    #100 in_data_im <= 2;
    #100 in_data_im <= 3;
end

endmodule
