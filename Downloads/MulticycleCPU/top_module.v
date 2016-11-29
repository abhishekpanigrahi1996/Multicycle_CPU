`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:02:51 10/06/2016 
// Design Name: 
// Module Name:    top_module 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module Main_memory(Din,Ain,address,datain,dataout,rd,wr,MFC,user);
	input rd,wr,user;
	input[15:0] address;
	output MFC;
	input[15:0] Ain, Din;
	input[15:0] datain;
	output[15:0] dataout;	
	reg[15:0] dataout;
	reg[15:0] memory[65535:0];
	reg MFC;
	
	//always @(rd or wr or datain or address)
		//$display("Time=%d Ain=%d Address=%d Data=%d Din=%d %d",$time,Ain,address,datain,Din,memory[address]);
		//$display("Time=%d Data=%d Address=%d Mem[28]=%d",$time,datain,address,memory[28]);
		
	always@(posedge user)
	begin
		memory[Ain] = Din;
	end
		
	always@(posedge rd or posedge wr)
	begin
		if(rd) 
			begin
				//$display("hello");
				dataout = memory[address];
			end
		else if(wr) 
			begin
				//$display("INSIDE 1: ADDRESS: %d Value: %d Change=%d",address,datain,memory[address]);
				memory[address] = datain;
				//$display("INSIDE 2: ADDRESS: %d Value: %d Change=%d",address,datain,memory[address]);
			end
	end
	
	
	
	always@(rd or wr)
	begin
		MFC = 0;
		#30
		MFC = 1;
	end
	
	//always@(rd or address or dataout)
		//$display("rd=%d address=%d dataout=%d result=%d",rd,address,dataout,memory[address]);
endmodule



module top_module(clk,rst,user,Ain,Din
    );
	 wire[15:0] IRout;
	 input clk,rst,user;
	 input[15:0] Ain,Din;
	 wire[1:0] sel1;
	 wire[15:0] address,datain,dataout;
	 CPUcontroller control(
						 clk,rst,ldbuf,ldflags,ldPC,ld2,ldtemp,ldMAR,ldMDR,ldIR,
						 TPC,Tr2,Ttemp,TMAR,TMDR2X,TMDR,
						 add,transx,rdR,wR,rMDRi,rMDRX,sel1,
						 Sout,Vout,Zout,Cout,IRout,
						 rd,wr,MFC
							);
	 CPUdatapath datapath(
						 rst,ldbuf,ldflags,ldPC,ld2,ldtemp,ldMAR,ldMDR,ldIR,
						 TPC,Tr2,Ttemp,TMAR,TMDR2X,TMDR,
						 add,transx,rdR,wR,rMDRi,rMDRX,sel1,
						 Sout,Vout,Zout,Cout,IRout,
						 address,datain,dataout
						 );
	
	Main_memory mem(Din,Ain,address,datain,dataout,rd,wr,MFC,user);
endmodule
