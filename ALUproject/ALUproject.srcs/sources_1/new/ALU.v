// ALU PROJECT (Arithmetic Logic Unit for EE118, Digital Design)
// Designer: Daniyaal Ahmed

`timescale 1ns / 1ps


//ALU Top Module
module ALU(swt, led, seg);
//Inputs the 16 switches, A = SWT[6:0] and B = SWT[13:7] throughout the project
    input [15:0]swt;
//mandates output to the LED and Segments of the number led
    output reg [14:0] led;
    output reg [6:0] seg;


    wire [7:0] addNumbers; //assigns wire to output of addNumbers
    wire [7:0] subNumbers; //assigns wire to output of subNumbers
    wire [6:0] compareNumbers; //assigns wires to output of compareNumber
    wire [14:0] multNumbers; //assigns wire outputs to multNumbers

//calls functions from other modules and inserts the input

sevenBitAdder add(.swt(swt), .led(addNumbers)); //adding the two numbers

subtractor sub(.swt(swt), .led(subNumbers)); //subtracting the two numbers

fullComparator comp(.swt(swt), .seg(compareNumbers)); //comparing the two numbers

multiplier mult(.swt(swt), .led(multNumbers)); //multiplying the two numbers

//begins case of outputs depending on opCode, swt[15:14], within the case argument
always @(*)
    begin
    case(swt[15:14]) //opcode, the two numbers that decide the operation
        2'b00: led = addNumbers; // 00 is to add
        2'b01: led = subNumbers; // 01 is to subtract
        2'b10: seg = compareNumbers; // 10 is to compare
        2'b11: led = multNumbers; // 11 is to multiply
    endcase
    end
endmodule


// Designer: Daniyaal Ahmed, Student ID = 012257337
// adds two 7bit numbers using 7 full adders
module sevenBitAdder(swt, led);
    output [6:0]led; //the output of this is the first 7 led's
    input [13:0]swt; // the input is all 14 of the switches, two 7bit numbers
    wire s1, s2, s3, s4, s5, s6;
    
//First Full adder, adds two bits together
    assign led[0] = swt[0]^swt[7];
    assign s1 = ((swt[0]^swt[7])&swt[0])|(swt[0]&swt[7]);
//Second Full adder adds the next two bits together
    assign led[1] = swt[1]^swt[8]^s1;
    assign s2 = ((swt[1]^swt[8])&s1)|(swt[1]&swt[8]);
//Third Full adder
    assign led[2] = swt[2]^swt[9]^s2;
    assign s3 = ((swt[2]^swt[9])&s2)|(swt[2]&swt[9]);
//Fourth Full Adder
    assign led[3] = swt[3]^swt[10]^s3;
    assign s4 = ((swt[3]^swt[10])&s3)|(swt[3]&swt[10]);
//Fifth Full Adder
    assign led[4] = swt[4]^swt[11]^s4;
    assign s5 = ((swt[4]^swt[11])&s4)|(swt[4]&swt[11]);
//Sixth Full Adder
    assign led[5] = swt[5]^swt[12]^s5;
    assign s6 = ((swt[5]^swt[12])&s5)|(swt[5]&swt[12]);
//Seventh Full Adder
    assign led[6] = swt[6]^swt[13]^s6;
    assign led[7] = ((swt[6]^swt[13])&s6)|(swt[6]&swt[13]);
// last two bits are added together
endmodule



//subtracts two 7 bit numbers, uses 7 full adders and twos compliment
module subtractor(swt, led);

    input [13:0] swt;
    output [7:0] led;
    wire c1, c2, c3, c4, c5, c6, c7;
    fulladder1 sub1(swt[0], ~swt[7], 1, led[0], c1);
    fulladder1 sub2(swt[1], ~swt[8], c1, led[1], c2);
    fulladder1 sub3(swt[2], ~swt[9], c2, led[2], c3);
    fulladder1 sub4(swt[3], ~swt[10], c3, led[3], c4);
    fulladder1 sub5(swt[4], ~swt[11], c4, led[4], c5);
    fulladder1 sub6(swt[5], ~swt[12], c5, led[5], c6);
    fulladder1 sub7(swt[6], ~swt[13], c6, led[6], c7);
    fulladder1 sub8(0, 1, c7, led[7]);
    
endmodule




//compares A and B, two 7 bit inputs and displays on the 7 segment led display
module fullComparator(swt, seg);
    input [13:0]swt; //A = SWT[6:0] and B = SWT[13:7]
    wire [2:0]res; //the resulting wire is the output of each gate
    output reg [6:0] seg; //outputs to 7 segment display
    wire gC2, eC2, lC2, gC4, eC4, lC4, gC6, eC6, lC6;
//Using the twoBitComp, compares 2 of the bits, for each set of two bits
    twoBitComp C2(swt[6:5], swt[13:12], gC2, eC2, lC2);
    twoBitComp C4(swt[4:3], swt[11:10], gC4, eC4, lC4);
    twoBitComp C6(swt[2:1], swt[9:8], gC6, eC6, lC6);
//greater than gate, sets the wire to the greater than setting
    assign res[2] = gC2|(eC2&eC4&eC6&swt[0]&!swt[7])|(gC6&eC2&eC4)|(gC4&eC2);
//equal gate, sets the wire to the equal to setting
    assign res[1] = eC2&eC4&eC6&!(swt[0]^swt[7]);
//less than gate, sets the wire to the less than setting
    assign res[0] = lC2|(lC4&eC2)|(eC2&eC4&eC6&!swt[0]&swt[7])|(lC6&eC2&eC4);
//case for segment display, sets output wire RES to the case and changes based on setting

always @(*)
begin
    case(res)
        3'b100: seg = 7'b0000010; //for Greater
        8'b010: seg = 7'b0000110; //for Equal
        8'b001: seg = 7'b1000111; //for Less
endcase
    end
endmodule
// Designer: Daniyaal Ahmed
// compares two 2bit numbers, used in above module for comparator


module twoBitComp(a, b, g, e, l);
    input [1:0] a; //inputs a
    input [1:0] b; //inputs b
    output g, e, l; //outputs g, e or l, greater, equal or less
//greater than output
    assign g = (a[1]&!b[1])|(!(a[1]^b[1])&(a[0]&!b[0]));
//equal to output
    assign e = !(a[1]^b[1])&!(a[0]^b[0]);
//less than output
    assign l = (!a[1]&b[1])|(!(a[1]^b[1])&(!a[0]&b[0]));
endmodule





// Multiplies two 7 bit inputs
module multiplier(swt, led);
    output [14:0]led; //outputs to 15 led lights
    input [13:0]swt; //inputs all switches, A = SWT[6:0] and B = SWT[13:7]
    wire h1, h2, h3, h4, h5, h6, h7;
    wire v1, v2, v3, v4, v5, v6;
//First Row Nodes based on the array multiplier
Node1 c1(h1, led[0], swt[0], swt[7], 0, 0);
Node1 c2(h2, v1, swt[1], swt[7], h1, 0);
Node1 c3(h3, v2, swt[2], swt[7], h2, 0);
Node1 c4(h4, v3, swt[3], swt[7], h3, 0);
Node1 c5(h5, v4, swt[4], swt[7], h4, 0);
Node1 c6(h6, v5, swt[5], swt[7], h5, 0);
Node1 c7(h7, v6, swt[6], swt[7], h6, 0);
wire h8, h9, h10, h11, h12, h13, h14;
wire v7, v8, v9, v10, v11, v12;
//Second row nodes
Node1 c8(h8, led[1], swt[0], swt[8], 0, v1);
Node1 c9(h9, v7, swt[1], swt[8], h8, v2);
Node1 c10(h10, v8, swt[2], swt[8], h9, v3);
Node1 c11(h11, v9, swt[3], swt[8], h10, v4);
Node1 c12(h12, v10, swt[4], swt[8], h11, v5);
Node1 c13(h13, v11, swt[5], swt[8], h12, v6);
Node1 c14(h14, v12, swt[6], swt[8], h13, h7);
wire h15, h16, h17, h18, h19, h20, h21;
wire v13, v14, v15, v16, v17, v18;
//Third Row Nodes
Node1 c15(h15, led[2], swt[0], swt[9], 0, v7);
Node1 c16(h16, v13, swt[1], swt[9], h15, v8);
Node1 c17(h17, v14, swt[2], swt[9], h16, v9);
Node1 c18(h18, v15, swt[3], swt[9], h17, v10);
Node1 c19(h19, v16, swt[4], swt[9], h18, v11);
Node1 c20(h20, v17, swt[5], swt[9], h19, v12);
Node1 c21(h21, v18, swt[6], swt[9], h20, h14);
wire h22, h23, h24, h25, h26, h27, h28;
wire v20, v21, v22, v23, v24, v25;
//Fourth Row Nodes
Node1 c22(h22, led[3], swt[0], swt[10], 0, v13);
Node1 c23(h23, v20, swt[1], swt[10], h22, v14);
Node1 c24(h24, v21, swt[2], swt[10], h23, v15);
Node1 c25(h25, v22, swt[3], swt[10], h24, v16);
Node1 c26(h26, v23, swt[4], swt[10], h25, v17);
Node1 c27(h27, v24, swt[5], swt[10], h26, v18);
Node1 c28(h28, v25, swt[6], swt[10], h27, h21);
wire h29, h30, h31, h32, h33, h34, h35;
wire v26, v27, v28, v29, v30, v31;
//Fifth Row Nodes
Node1 c29(h29, led[4], swt[0], swt[11], 0, v20);
Node1 c30(h30, v26, swt[1], swt[11], h29, v21);
Node1 c31(h31, v27, swt[2], swt[11], h30, v22);
Node1 c32(h32, v28, swt[3], swt[11], h31, v23);
Node1 c33(h33, v29, swt[4], swt[11], h32, v24);
Node1 c34(h34, v30, swt[5], swt[11], h33, v25);
Node1 c35(h35, v31, swt[6], swt[11], h34, h28);
wire h36, h37, h38, h39, h40, h41, h42;
wire v32, v33, v34, v35, v36, v37;
//Sixth Row Nodes
Node1 c36(h36, led[5], swt[0], swt[12], 0, v26);
Node1 c37(h37, v32, swt[1], swt[12], h36, v27);
Node1 c38(h38, v33, swt[2], swt[12], h37, v28);
Node1 c39(h39, v34, swt[3], swt[12], h38, v29);
Node1 c40(h40, v35, swt[4], swt[12], h39, v30);
Node1 c41(h41, v36, swt[5], swt[12], h40, v31);
Node1 c42(h42, v37, swt[6], swt[12], h41, h35);
wire h43, h44, h45, h46, h47, h48;
//Seventh Row Nodes
Node1 c43(h43, led[6], swt[0], swt[13], 0, v32);
Node1 c44(h44, led[7], swt[1], swt[13], h43, v33);
Node1 c45(h45, led[8], swt[2], swt[13], h44, v34);
Node1 c46(h46, led[9], swt[3], swt[13], h45, v35);
Node1 c47(h47, led[10], swt[4], swt[13], h46, v36);
Node1 c48(h48, led[11], swt[5], swt[13], h47, v37);
Node1 c49(led[13], led[12], swt[6], swt[13], h47, h42);
endmodule



// Node that puts oneBitAdder and AND gate together to make one Node Block of Array Multiplier
module Node1(hcout, vcout, a, b, hcin, vcin);
    input a, b, hcin, vcin; //input is the 2 bits, along with the horizontal and vertical carry in
    output hcout, vcout; //output is horizontal and vertical out
    wire s1; //used for and gate
    and(s1, a, b); //and gate combines a and b bit for full adder
//full adder takes the andgate output and other inputs
    oneBitAdder(vcout, hcout, vcin, s1, hcin); 

endmodule


// adds two, 1bit numbers together

module oneBitAdder(sum, cout, a, b, cin);
    input a, b, cin; //inputs 2 bits and carry in
    output sum, cout; //outputs sum and carry out
    assign sum = a^b^cin; // XOR the two bits and Carry in
    assign cout = ((a^b)&cin)|(a&b);

endmodule
