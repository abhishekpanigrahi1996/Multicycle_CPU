`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:43:59 09/27/2016 
// Design Name: 
// Module Name:    CPUdatapath 
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

module Dff(in,out,clk,rst);
	input in,clk,rst;
	output out;
	reg out;
	always@(posedge clk or negedge rst)
		if(!rst) out<=0;
		else 
			out <= in;
endmodule

module reg16(in,out,clk,rst);
	input clk,rst;
	input[15:0] in;
	output[15:0] out;
	
	genvar i;
	generate
		for(i=0;i<16;i=i+1)
		begin
			Dff inter(in[i],out[i],clk,rst);
		end
	endgenerate
endmodule


module demux(in,sel,out);
	input[2:0] sel;
	input in;
	output[7:0] out;
	
	not N1(not0,sel[0]),
		 N2(not1,sel[1]),
		 N3(not2,sel[2]);
	
	and A1(out[0],in,not2,not1,not0),
		 A2(out[1],in,not2,not1,sel[0]),
		 A3(out[2],in,not2,sel[1],not0),
		 A4(out[3],in,not2,sel[1],sel[0]),
		 A5(out[4],in,sel[2],not1,not0),
		 A6(out[5],in,sel[2],not1,sel[0]),
		 A7(out[6],in,sel[2],sel[1],not0),
		 A8(out[7],in,sel[2],sel[1],sel[0]);
		 
		 
endmodule

module tristate(in,out,en);
	input in,en;
	output out;
	reg out;
	
	always@(en,in)
		begin
			if(en) out=in;
			else out=1'bz;
		end
endmodule



module tristate16(in,out,en);
	input[15:0] in;
	output[15:0] out;
	input en;
	reg[15:0] out;
	//always @(out or en)
		//$display("In tr16,time=%d in=%d out=%d en=%b",$time,in,out,en);
	/*genvar i;
	generate
		for(i=0;i<16;i=i+1)
			tristate TRI(in[i],out[i],en);
	endgenerate*/
	always@(in or en)
		begin
			if(en)
				out=in;
			else
				out=16'bz;
		end
endmodule



module regbank(in,RPA,WPA,rdR,wR,out,rst);
	input[15:0] in;
	output[15:0] out;
	input rdR,wR,rst;
	input[2:0] RPA,WPA;
	wire[7:0] clk,en;
	wire[15:0] out0,out1,out2,out3,out4,out5,out6,out7;
	
	
	demux DMux1(wR,WPA,clk),
			DMux2(rdR,RPA,en);
			
	reg16 R0(in,out0,clk[0],rst),
			R1(in,out1,clk[1],rst),
			R2(in,out2,clk[2],rst),
			R3(in,out3,clk[3],rst),
			R4(in,out4,clk[4],rst),
			R5(in,out5,clk[5],rst),
			R6(in,out6,clk[6],rst),
			R7(in,out7,clk[7],rst);
	
	tristate16 T1(out0,out,en[0]),
				  T2(out1,out,en[1]),
				  T3(out2,out,en[2]),
				  T4(out3,out,en[3]),
				  T5(out4,out,en[4]),
				  T6(out5,out,en[5]),
				  T7(out6,out,en[6]),
				  T8(out7,out,en[7]);
	always@(out0 or out1 or out2 or out3 or out4 or out5 or out6 or out7)
		$display("Regbank at time %d:\n R0 : %d\t R1 : %d\t R2 : %d\t R3 : %d\t R4 : %d\t R5 : %d\t R6 : %d\t R7 : %d",$time,out0,out1,out2,out3,out4,out5,out6,out7);
endmodule




module adder(a,b,inp,outcar,sum);
	input a,b,inp;
	output outcar,sum;
	wire w1,w2,w3,w4,w5;

	and A1(w1,a,inp),
		 A2(w2,a,b),
		 A3(w3,b,inp);

	or O1(w4,w1,w2),
	   O2(outcar,w4,w3);


	xor X1(w5,a,b),
		 X2(sum,inp,w5);

endmodule


module adder16(X,Y,inp,out,car,ovflow);
	input[15:0] X,Y;
	input inp;
	output car,ovflow;
	output[15:0] out;
	wire[15:0] carry;
	genvar i;

	generate
		for(i=0;i<16;i=i+1)
		begin
			if(i==0) adder A(X[i],Y[i],inp,carry[0],out[i]);
			else adder B(X[i],Y[i],carry[i-1],carry[i],out[i]);
		end
	endgenerate
	
	buf B1(car,carry[15]);
	xor X1(ovflow,carry[15],carry[14]);
endmodule



module compY(Y,Z);
	input[15:0] Y;
   output[15:0] Z;
      
   genvar i;
   generate
		for(i=0;i<16;i=i+1)
			begin  
				not N1(Z[i],Y[i]);
			end
   endgenerate
endmodule



module andXY(X,Y,Z);
	input[15:0] X,Y;
   output[15:0] Z;
      
   genvar i;
   generate
		for(i=0;i<16;i=i+1)
			begin  
				and A1(Z[i],Y[i],X[i]);
			end
   endgenerate
endmodule


module orXY(X,Y,Z);
	input[15:0] X,Y;
   output[15:0] Z;
      
   genvar i;
   generate
		for(i=0;i<16;i=i+1)
			begin  
				or O1(Z[i],Y[i],X[i]);
			end
   endgenerate
endmodule




module decoder3(x,y,z,out);
	input x,y,z;
	output[7:0] out;
	wire notx,noty,notz;
  
  
	and D1(out[0],notx,noty,notz),
		 D2(out[1],notx,noty,z),
		 D3(out[2],notx,y,notz),
		 D4(out[3],notx,y,z),
		 D5(out[4],x,noty,notz),
		 D6(out[5],x,noty,z),
		 D7(out[6],x,y,notz),
		 D8(out[7],x,y,z);

	not N1(notx,x),
		 N2(noty,y),
		 N3(notz,z);
endmodule





module ALU(X,Y,Z,fnsel,Sin,Zin,Vin,Cin);
	input[15:0] X,Y;
	output[15:0] Z;
	output Sin,Zin,Vin,Cin;
	input[2:0] fnsel;
	wire[7:0] func;
	wire[15:0] outadd,outsub,outcomp1,outcomp,outand,outor,negY;
	
	
	decoder3 Decode(fnsel[2],fnsel[1],fnsel[0],func);
	
	adder16 add(X,Y,1'b0,outadd,car1,ovf1);
	
	compY comp1(Y,negY);
	adder16 sub(X,negY,1'b1,outsub,car2,ovf2);
	
	compY comp2(X,outcomp1);
	adder16 compadd(outcomp1,16'b0000000000000001,1'b0,outcomp,car3,ovf3);
	
	andXY and1(X,Y,outand);
	
	orXY or1(X,Y,outor);
	
	
	or O1(adden,func[0],func[7]),
		O2(suben,func[1],func[4]);
		
	tristate16 T1(outadd,Z,adden),
				  T2(outsub,Z,suben),
				  T3(outand,Z,func[2]),
				  T4(outor,Z,func[3]),
				  T5(X,Z,func[6]),
				  T6(outcomp,Z,func[5]);
	
	buf B1(Sin,Z[15]);
	or A1(notz,Z[0],Z[1],Z[2],Z[3],Z[4],Z[5],Z[6],Z[7],Z[8],Z[9],Z[10],Z[11],Z[12],Z[13],Z[14],Z[15]);
	not N1(Zin,notz);
	
	and A2(temp_car1,car1,adden);
	and A3(temp_car2,car2,suben);
	and A4(temp_car3,car3,func[5]);
	or O3(Cin,temp_car1,temp_car2,temp_car3);
	
	and A5(temp_ovf1,ovf1,adden);
	and A6(temp_ovf2,ovf2,suben);
	and A7(temp_ovf3,ovf3,func[5]);
	or O4(Vin,temp_ovf1,temp_ovf2,temp_ovf3);
	
	//always@(X or Y or Z or Sin or Vin or Zin or Cin)
		//if(fnsel==3'b000)
		//$display("time=%d X=%d Y=%d Z=%d Sin=%d Vin=%d Zin=%d Cin=%d",$time,X,Y,Z,Sin,Vin,Zin,Cin);
	
endmodule

module decoder2(sel1,sel2,out);
	input sel1,sel2;
	output[3:0] out;
	
	not N1(not1,sel1),
		 N2(not2,sel2);
		 
	and A1(out[0],not1,not2),
		 A2(out[1],not1,sel2),
		 A3(out[2],sel1,not2),
		 A4(out[3],sel1,sel2);
endmodule




module MUX2(A,B,D,E,C,sel1,sel2);
	input A,B,D,E;
	input sel1,sel2;
	output C;
	wire[3:0] out;
	
	
	decoder2 D1(sel1,sel2,out);
	and A1(w1,A,out[0]),
	    A2(w2,B,out[1]),
		 A3(w3,D,out[2]),
		 A4(w4,E,out[3]);
	or O1(C,w1,w2,w3,w4);
endmodule



module CPUdatapath(
						 rst,ldbuf,ldflags,ldPC,ld2,ldtemp,ldMAR,ldMDR,ldIR,
						 TPC,Tr2,Ttemp,TMAR,TMDR2X,TMDR,
						 add,transx,rdR,wR,rMDRi,rMDRX,sel1,
						 Sout,Vout,Zout,Cout,IRout,
						 address,datain,dataout
						 );

	input rst,ldbuf,ldflags,ldPC,TPC,ld2,Tr2,add,
			transx,rdR,wR,ldtemp,Ttemp,ldMAR,
			TMAR,ldMDR,rMDRi,rMDRX,TMDR2X,TMDR,ldIR;
			
	input[1:0] sel1;

	wire[15:0] X,bufout,Z,tempPC,temp2,tmp,
				  tempMAR,MDRin,MDRout;
	wire[2:0] fnsel,RPA;
	wire Sin,Zin,Vin,Cin;
	//reg[15:0] memory[65535:0];

	output[15:0] IRout;
	output Sout,Vout,Zout,Cout;
	
	output[15:0] address;
	output[15:0] datain;
	input[15:0] dataout;
	
	
	// ALU
	// {add,transx} : 00 fnsel = IR[opcode]
	// {add,transx} : 01 fnsel = 110 transx
	// {add,transx} : 10 fnsel = 111 add
	// {add,transx} : 11 fnsel = xxx
	MUX2 M1(IRout[14],1'b1,1'b1,1'bx,fnsel[2],add,transx),
		  M2(IRout[13],1'b1,1'b1,1'bx,fnsel[1],add,transx),
		  M3(IRout[12],1'b0,1'b1,1'bx,fnsel[0],add,transx);
		  
	reg16 buffer(X,bufout,ldbuf,rst);
	ALU alu(X,bufout,Z,fnsel,Sin,Zin,Vin,Cin);
	
	// flag DFFs
	Dff sign(Sin,Sout,ldflags,rst),
		 zero(Zin,Zout,ldflags,rst),
		 overflow(Vin,Vout,ldflags,rst),
		 carry(Cin,Cout,ldflags,rst);

	//PC
	reg16 PC(Z,tempPC,ldPC,rst);
	tristate16 tpc(tempPC,X,TPC);
	
	// #1 reg
	reg16 two(16'b0000000000000001,temp2,ld2,rst);
	tristate16 ttwo(temp2,X,Tr2);
	
	// regbank
	// sel1 : 0 RPA - rx
	// sel1 : 1 RPA - rb
	// sel1 : 2 RPA - Rdst
	MUX2 M4(IRout[5],IRout[8],IRout[2],1'bx,RPA[2],sel1[1],sel1[0]),
		  M5(IRout[4],IRout[7],IRout[1],1'bx,RPA[1],sel1[1],sel1[0]),
		  M6(IRout[3],IRout[6],IRout[0],1'bx,RPA[0],sel1[1],sel1[0]);
		  
	regbank registers(Z,RPA,IRout[2:0],rdR,wR,X,rst);
	
	// Temporary register
	reg16 temp(Z,tmp,ldtemp,rst);
	tristate16 ttemp(tmp,X,Ttemp);
	
	// MAR
	reg16 MAR(Z,tempMAR,ldMAR,rst);
	tristate16 tmar(tempMAR,address,TMAR);
	
	// IR(instruction register)
	reg16 IR(dataout,IRout,ldIR,rst);
	
	// MDR
	reg16 MDR(MDRin,MDRout,ldMDR,rst);
	tristate16 T1(Z,MDRin,rMDRi);
   tristate16 T2(dataout,MDRin,rMDRX);
	tristate16 T3(MDRout,X,TMDR2X);
	tristate16 T4(MDRout,datain,TMDR);
	
	
	always@(Sout or Zout or Vout or Cout)
		$display("Load signals at time=%d : Sout=%d Zout=%d Vout=%d Cout=%d",$time,Sout,Zout,Vout,Cout);
	
endmodule
