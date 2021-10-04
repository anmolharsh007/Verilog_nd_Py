`timescale 1ns/1ns

module mux21(i0,i1,s,o);
	
input i1,i0,s;
output o;
assign o = (s&i0)&((~s)&i1) ;


endmodule