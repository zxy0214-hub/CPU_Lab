// instruction memory ROM for simulation
// replaces Vivado IP core, uses $readmemh to load .dat
module imem(
    input  [6:0]  a,
    output [31:0] spo
);

reg [31:0] mem [0:127];

initial begin
    $readmemh("Test_30_Instr.dat", mem, 0, 55);
end

assign spo = mem[a];

endmodule
