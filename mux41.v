`include "mux21.v"
`timescale 1ns/1ns

module mux41(a,b,c,d,s0,s1,o);
input a,b,c,d,s0,s1;
output o;
wire o1,o2;
mux21 m1(.i0(a), .i1(b), .s(s0), .o(o1));
mux21 m2(.i0(c), .i1(d), .s(s0), .o(o2));

mux21 m3(.i0(o1), .i1(o2), .s(s1), .o(o));

endmodule