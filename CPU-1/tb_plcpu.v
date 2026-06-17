`timescale 1ns/1ps

module tb_plcpu;

    reg clk;
    reg reset;

    wire [31:0] inst_in;
    wire [31:0] PC_out;
    wire [31:0] Addr_out;
    wire [31:0] Data_out;
    wire        mem_w;
    wire        mem_r;
    wire [31:0] dm_dout;

    integer cycle;

    always #5 clk = ~clk;

    PLCPU U_PLCPU (
        .clk(clk), .reset(reset),
        .inst_in(inst_in), .Data_in(dm_dout),
        .PC_out(PC_out), .Addr_out(Addr_out),
        .Data_out(Data_out), .mem_w(mem_w), .mem_r(mem_r)
    );

    imem U_IM (.a(PC_out[8:2]), .spo(inst_in));

    dm U_DM (.clk(clk), .DMWr(mem_w), .addr(Addr_out),
             .din(Data_out), .dout(dm_dout));

    initial begin
        clk   = 1'b0;
        reset = 1'b1;
        cycle = 0;
        $dumpfile("tb_plcpu.vcd");
        $dumpvars(0, tb_plcpu);
        #103 reset = 1'b0;
    end

    always @(posedge clk) begin
        if (~reset) begin
            cycle = cycle + 1;
            $display("C%0d PC=%h IF=%h | ID:op=%d r%0d r%0d r%0d imm=%h RD1=%h RD2=%h | EX:A=%h B=%h alu=%h z=%b fl=%b st=%b fw=%b/%b | MEM:ad=%h d=%h mw=%b mr=%b | WB:r%0d=%h rf=%b",
                cycle, PC_out, inst_in,
                U_PLCPU.Op, U_PLCPU.rs1, U_PLCPU.rs2, U_PLCPU.rd,
                U_PLCPU.immout, U_PLCPU.RD1, U_PLCPU.RD2,
                U_PLCPU.A, U_PLCPU.B, U_PLCPU.aluout, U_PLCPU.Zero,
                U_PLCPU.flush, U_PLCPU.stall,
                U_PLCPU.ForwardA, U_PLCPU.ForwardB,
                U_PLCPU.MEM_aluout, U_PLCPU.MEM_RD2,
                U_PLCPU.MEM_MemWrite, U_PLCPU.MEM_MemRead,
                U_PLCPU.WB_rd, U_PLCPU.WD, U_PLCPU.WB_RegWrite);
        end
    end

    always @(posedge clk) begin
        if (~reset && cycle >= 50) begin
            $display("=== 50 cycles done ===");
            $finish;
        end
    end

endmodule
