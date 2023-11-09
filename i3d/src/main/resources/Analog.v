`timescale 1ns/1ps

module AnalogToUInt #(
    parameter WIDTH = 1
) (
    inout [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);
    assign out = in;
endmodule

module UIntToAnalog #(
    parameter WIDTH = 1
) (
    input [WIDTH-1:0] in,
    output [WIDTH-1:0] out,
    input en
);
    assign out = en ? in : {WIDTH{1'bZ}};
endmodule

module AnalogUIntBidir #(
    parameter WIDTH = 1
) (
    inout [WIDTH-1:0] ana,
    input [WIDTH-1:0] in,
    output [WIDTH-1:0] out,
    input in_en,
    input out_en
);
    assign ana = out_en ? in : {WIDTH{1'b0}};
    assign out = in_en ? {WIDTH{1'b0}} : ana;
endmodule