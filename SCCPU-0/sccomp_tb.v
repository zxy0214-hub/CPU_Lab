`timescale 1ns/1ns 
module sccomp_tb();
  reg   clk, rstn;
  integer i=0;  //for debug

  // instantiation of plcomp
  sccomp sccomp(clk, rstn);
  
  initial begin
    // input instructions for simulation
    $readmemh("Test_30_Instr.dat", sccomp.U_imem.RAM); //( 21 ins-25cycles )
    clk = 0;
    rstn = 1;
    #50 ;
    rstn = 0;
  end
  
  always begin
    #(5) clk = ~clk;
  end

  always @(posedge clk) begin   //for debug
       i=i+1;
       if (clk) $write("\n cycle=%d, IF_PC=%h, IF_ins=%h, ", i, sccomp.PC, sccomp.instr );
       if (sccomp.U_SCCPU.U_RF.RFWr && sccomp.U_SCCPU.U_RF.A3) $write("x%d = %h  ", sccomp.U_SCCPU.U_RF.A3, sccomp.U_SCCPU.U_RF.WD) ;
  end
      
endmodule
