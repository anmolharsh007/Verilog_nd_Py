`timescale 1ns/1ps

module tb3();
reg [5:0]a;
reg [5:0]b;
wire [11:0]p;

unsigned_array_mult m1(a,b,p);
initial begin
a=6'b000000;
b=6'b000000;

$monitor($time," a = %d, b = %d, product = %d",a,b,p);

a=6'b000000;
b=6'b000100;
#10;

a=6'b001101;
b=6'b000001;
#10;

a=6'b001001;
b=6'b000011;
#10;

a=6'b111100;
b=6'b001111;
#10;

a=6'b100100;
b=6'b101010;
#10;

a=6'b111100;
b=6'b110000;
#10;

a=6'b111111;
b=6'b111110;
#10;

a=6'b111111;
b=6'b111111;
#10;

#10; $finish;

end
endmodule
