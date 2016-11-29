`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:19:10 10/08/2016
// Design Name:   CPUdatapath
// Module Name:   C:/Users/ABHISHEK/Desktop/codes/CPUdesign/test-datapath.v
// Project Name:  CPUdesign
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: CPUdatapath
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_datapath;

	// Inputs
	reg rst;
	reg ldbuf;
	reg ldflags;
	reg ldPC;
	reg ld2;
	reg ldtemp;
	reg ldMAR;
	reg ldMDR;
	reg ldIR;
	reg TPC;
	reg Tr2;
	reg Ttemp;
	reg TMAR;
	reg TMDR2X;
	reg TMDR;
	reg add;
	reg transx;
	reg rdR;
	reg wR;
	reg rMDRi;
	reg rMDRX;
	reg [1:0] sel1;
	reg[15:0] datain;

	// Outputs
	wire Sout;
	wire Vout;
	wire Zout;
	wire Cout;
	wire [15:0] IRout;
	wire [15:0] address;
	wire [15:0] dataout;

	// Instantiate the Unit Under Test (UUT)
	CPUdatapath uut (
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
		.address(address), 
		.data(datain),
		.dataout(dataout)
		
	);

	initial begin
		// Initialize Inputs
		rst = 0;
		ldbuf = 0;
		ldflags = 0;
		ldPC = 0;
		ld2 = 0;
		ldtemp = 0;
		ldMAR = 0;
		ldMDR = 0;
		ldIR = 0;
		TPC = 0;
		Tr2 = 0;
		Ttemp = 0;
		TMAR = 0;
		TMDR2X = 0;
		TMDR = 0;
		add = 0;
		transx = 0;
		rdR = 0;
		wR = 0;
		rMDRi = 0;
		rMDRX = 0;
		sel1 = 0;

		// Wait 100 ns for global reset to finish
		#2 
		rst = 1;
		#100;
	   datain=16'b0111000111001010;
	   ldIR=1
	   #40
		ldIR=0;
		datain=16'b0000000000001100;
	   rMDRX=1;
	   ldMDR=1;
	   #40
	     rMDRX=0;
	   ldMDR=0;
	     TMDR2X=1;
	   transx=1;
	   wR=1;
	   
	    /* ldbuf=0;
	   
		ld2 = 1;
		TPC=1;
		#2
		TPC = 0;
		ldbuf=1;
		#20
		ld2 = 0;
		ldbuf = 0;
		Tr2 = 1;
		add = 1;
		#2
		ldPC = 1;
		#20
		Tr2 = 0;
		add = 0;
		TPC = 1;
		transx = 1;
		#2
		ldMAR=1;
		#20
		transx = 0;
		TPC = 0;
		#2
		ldMAR = 0;
		#2
      TMAR = 1;
		//#20
		//$display("%d",address);
		// Add stimulus here
	     */
	end
      
endmodule

