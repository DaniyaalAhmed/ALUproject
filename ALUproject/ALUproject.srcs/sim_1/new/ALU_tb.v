`timescale 1ns / 1ps


// Designer: Daniyaal Ahmed, Student ID = 012257337
// test bench for ALU

module ALU_tb();

    reg [15:0]swts;
    wire [13:0]leds;
    wire [6:0]segs;
    ALU dut(.swt(swts),.led(leds),.seg(segs));

initial
begin

    #100 swts[6:0]=7'b1001001; swts[13:7]=7'b0100101; swts[15:14]=2'b00; //A+B
    #100 swts[6:0]=7'b0100101; swts[13:7]=7'b1001001; swts[15:14]=2'b00; //B+A
    #100 swts[6:0]=7'b1001001; swts[13:7]=7'b0100101; swts[15:14]=2'b01; //A-B
    #100 swts[6:0]=7'b0100101; swts[13:7]=7'b1001001; swts[15:14]=2'b01; //B-A
    #100 swts[6:0]=7'b0100101; swts[13:7]=7'b1001001; swts[15:14]=2'b10; //A<B
    #100 swts[6:0]=7'b0000001; swts[13:7]=7'b0000001; swts[15:14]=2'b10; //A=B
    #100 swts[6:0]=7'b1001001; swts[13:7]=7'b0100101; swts[15:14]=2'b10; //A>B
    #100 swts[6:0]=7'b1001001; swts[13:7]=7'b1011011; swts[15:14]=2'b11; //A*B
    #100 swts[6:0]=7'b0100101; swts[13:7]=7'b1001001; swts[15:14]=2'b11; //B*A
    
end

endmodule
