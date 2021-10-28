/*
    Assignment   :  3
    Problem      :  2
    Semester     :  Autumn 2020
    Group        :  G9
    Members      :  Akshat Shukla(18CS10002)
                    Animesh Barua(18CS10003)
*/

// This is a adder where input is a,b and output is sum, cout
module adder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;

    assign cout = (a&b)|(b&cin)|(a&cin);
    assign sum = (a^b^cin);
endmodule

// this is a adder(2 bit)
module adder_2bit(a, b, cin, sum, cout);

    input [1:0] a, b;
    input cin;
    output [1:0] sum;
    output cout;

    wire c_mid;

    adder lsb(a[0], b[0], cin, sum[0], c_mid);
    adder msb(a[1], b[1], c_mid, sum[1], cout);

endmodule

// this is a adder(6 bit)
module adder_6bit(a, b, cin, sum, cout);

    input [5:0] a, b;
    input cin;
    output [5:0] sum;
    output cout;

    wire carry, carry1;

    adder_2bit inst1(a[1:0], b[1:0], cin, sum[1:0], carry);
    adder_2bit inst2(a[3:2], b[3:2], carry, sum[3:2], carry1);
    adder_2bit inst3(a[5:4], b[5:4], carry1, sum[5:4], cout);

endmodule

// this is a adder(12 bit)
module adder_12bit(a, b, cin, sum, cout);

    input [11:0] a, b;
    input cin;
    output [11:0] sum;
    output cout;

    wire c_mid;

    adder_6bit ls(a[5:0], b[5:0], cin, sum[5:0], c_mid);
    adder_6bit ms(a[11:6], b[11:6], c_mid, sum[11:6], cout);

endmodule

// This is the Sequential Unsigned Binary Multiplier (left-shift version) using the above defined modules
module unsigned_seq_mult_LS(clk, rst, load, a, b, product);

    input clk, rst, load;
    input [5:0] a, b;
    output reg [11:0] product;

    integer count = 0;
    wire zero, garbage;
    reg [11:0] _a, _b;
    wire[11:0] present_sum;
    reg [11:0] temp;

    assign zero = 0;
    adder_12bit inst(.a(product), .b(temp), .cin(zero), .sum(present_sum), .cout(garbage));

    always @(load)
    begin
        count = 0;
        _a = a;
        _b = b;
        product = 0;
    end

    always @(rst)
    begin
        count = 0;
        product = 12'b000000000000;
        temp = _b;
    end

    always @(posedge(clk))
    begin
        if(count < 6)
        begin
            if(a[count])
            begin
                product = present_sum;
            end
            temp = (temp<<1);
            count=count+1;
        end
    end

endmodule