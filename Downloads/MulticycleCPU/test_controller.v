`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:27:41 10/21/2016
// Design Name:   CPUcontroller
// Module Name:   C:/Users/ABHISHEK/Desktop/codes/CPUdesign/test_controller.v
// Project Name:  CPUdesign
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: CPUcontroller
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_controller;

	// Inputs
	reg clk;
	reg rst;
	reg Sout;
	reg Vout;
	reg Zout;
	reg Cout;
	reg [15:0] IRout;
	reg MFC;

	// Outputs
	wire ldbuf;
	wire ldflags;
	wire ldPC;
	wire ld2;
	wire ldtemp;
	wire ldMAR;
	wire ldMDR;
	wire ldIR;
	wire TPC;
	wire Tr2;
	wire Ttemp;
	wire TMAR;
	wire TMDR2X;
	wire TMDR;
	wire add;
	wire transx;
	wire rdR;
	wire wR;
	wire rMDRi;
	wire rMDRX;
	wire [1:0] sel1;
	wire rd;
	wire wr;

	// Instantiate the Unit Under Test (UUT)
	CPUcontroller uut (
		.clk(clk), 
		.rst(rst), 
		.ldbuf(ldbuf), 
		.ldflags(ldflags), 
		.ldPC(ldPC), 
		.ld2(ld2), 
		.ldtemp(ldtemp), 
		.ldMAR(ldMAR), 
		.ldMDR(ldMDR), 
		.ldIR(ldIR), 
		.TPC(TPC), 
		.Tr2(Tr2), 
		.Ttemp(Ttemp), 
		.TMAR(TMAR), 
		.TMDR2X(TMDR2X), 
		.TMDR(TMDR), 
		.add(add), 
		.transx(transx), 
		.rdR(rdR), 
		.wR(wR), 
		.rMDRi(rMDRi), 
		.rMDRX(rMDRX), 
		.sel1(sel1), 
		.Sout(Sout), 
		.Vout(Vout), 
		.Zout(Zout), 
		.Cout(Cout), 
		.IRout(IRout), 
		.rd(rd), 
		.wr(wr), 
		.MFC(MFC)
	);

	always #5
	clk = !clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		Sout = 0;
		Vout = 0;
		Zout = 0;
		Cout = 0;
		IRout = 0;
		MFC = 0;


		// Wait 100 ns for global reset to finish
		#100;
      rst = 1;
		MFC = 1;
		IRout = 16'b0111000111001000;
		
		#50
		rst = 1;
		MFC = 0;
		
		#50
		MFC = 1;
		IRout = 16'b1000000111001001;
		
		#50
		rst = 1;
		MFC = 0;
			
		// Add stimulus here

	end
      
		always@(ldbuf,
		ldflags,
		ldPC,
		ld2,
		ldtemp,
		ldMAR,
		ldMDR,
		ldIR,
		TPC,
		Tr2,
		Ttemp,
		TMAR,
		TMDR2X,
		TMDR,
		add,
		transx,
		rdR,
		wR,
		rMDRi,
		rMDRX,
		sel1,
		rd)
		$display("ldbuf=%b,ldflags=%b,ldPC=%b,ld2=%b,ldtemp=%b,ldMAR=%b,ldMDR=%b,ldIR=%b,TPC=%b,Tr2=%b,Ttemp=%b,TMAR=%b,TMDR2X=%b,TMDR=%b,add=%b,transx=%b,rdR=%b,wR=%b,rMDRi=%b,rMDRX=%b,sel1=%b,rd=%b",ldbuf,
		ldflags,
		ldPC,
		ld2,
		ldtemp,
		ldMAR,
		ldMDR,
		ldIR,
		TPC,
		Tr2,
		Ttemp,
		TMAR,
		TMDR2X,
		TMDR,
		add,
		transx,
		rdR,
		wR,
		rMDRi,
		rMDRX,
		sel1,
		rd);
endmodule

