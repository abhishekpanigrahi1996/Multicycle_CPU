`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    05:00:58 10/01/2016 
// Design Name: 
// Module Name:    CPUcontroller 
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
module CPUcontroller(
						 clk,rst,ldbuf,ldflags,ldPC,ld2,ldtemp,ldMAR,ldMDR,ldIR,
						 TPC,Tr2,Ttemp,TMAR,TMDR2X,TMDR,
						 add,transx,rdR,wR,rMDRi,rMDRX,sel1,
						 Sout,Vout,Zout,Cout,IRout,
						 rd,wr,MFC
							);
	input rst,clk;
	
	output ldbuf,ldflags,ldPC,ld2,ldtemp,ldMAR,ldMDR,ldIR,
			TPC,Tr2,Ttemp,TMAR,TMDR2X,TMDR,
			add,transx,rdR,wR,rd,wr,rMDRi,rMDRX;
	reg  ld2,
			TPC,Tr2,Ttemp,TMAR,TMDR2X,TMDR,
			add,transx,rdR,rd,wr,rMDRi,rMDRX;		
	output[1:0]	sel1;
	reg[1:0] sel1;

	reg ldbuf_comp,ldflags_comp,ldPC_comp,ldtemp_comp,ldMAR_comp,ldMDR_comp,ldIR_comp,wR_comp;
	input Sout,Vout,Zout,Cout,MFC;
	input[15:0] IRout;
//MFC to be implemented !!

	reg[8:0] state;
	reg[8:0] next_state;
	reg D_cond;
	
	//always @(state or D_cond)
		//$display("time=%d state=%b D_Cond=%b",$time,state,D_cond);
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			state<= start;
		else 
			state <= next_state;
	end


	parameter A01 = 9'b000010001;
	parameter A02 = 9'b000010010;
	parameter A03 = 9'b000010011;
	parameter A04 = 9'b000010100;
	parameter B01 = 9'b000100001;
	parameter B02 = 9'b000100010;
	parameter B03 = 9'b000100011;
	parameter B04 = 9'b000100100;
	parameter B05 = 9'b000100101;
	parameter C01 = 9'b000110001;
	parameter D01 = 9'b001000001;
	parameter D02 = 9'b001000010;
	parameter D03 = 9'b001000011;
	parameter D04 = 9'b001000100;
	parameter D05 = 9'b001000101;
	parameter D06 = 9'b001000110;
	parameter D07 = 9'b001000111;
	parameter D08 = 9'b001001000;
	parameter D09 = 9'b001001001;
	parameter D10 = 9'b001001010;
	parameter D11 = 9'b001001011;
	parameter D12 = 9'b001001100;
	parameter E01 = 9'b001010001;
	parameter E02 = 9'b001010010;
	parameter E03 = 9'b001010011;
	parameter E04 = 9'b001010100;
	parameter E05 = 9'b001010101;
	parameter E06 = 9'b001010110;
	parameter E07 = 9'b001010111;
	parameter E08 = 9'b001011000;
	parameter E09 = 9'b001011001;
	parameter E10 = 9'b001011010;
	parameter E11 = 9'b001011011;
	parameter E12 = 9'b001011100;
	parameter E13 = 9'b001011101;
	parameter E14 = 9'b001011110;
	parameter E15 = 9'b001011111;
	parameter F01 = 9'b001100001;
	parameter F02 = 9'b001100010;
	parameter F03 = 9'b001100011;
	parameter F04 = 9'b001100100;
	parameter F05 = 9'b001100101;
	parameter F06 = 9'b001100110;
	parameter G01 = 9'b001110001;
	parameter G02 = 9'b001110010;
	parameter H01 = 9'b010000001;
	parameter H02 = 9'b010000010;
	parameter H03 = 9'b010000011;
	parameter H04 = 9'b010000100;
	parameter H05 = 9'b010000101;
	parameter H06 = 9'b010000110;
	parameter H07 = 9'b010000111;
	parameter H08 = 9'b010001000;
	parameter H09 = 9'b010001001;
	parameter H10 = 9'b010001010;
	parameter H11 = 9'b010001011;
	parameter H12 = 9'b010001100;
	parameter H13 = 9'b010001101;
	parameter I01 = 9'b010010001;
	parameter I02 = 9'b010010010;
	parameter I03 = 9'b010010011;
	parameter I04 = 9'b010010100;
	parameter I05 = 9'b010010101;
	parameter I06 = 9'b010010110;
	parameter I07 = 9'b010010111;
	parameter I08 = 9'b010011000;
	parameter I09 = 9'b010011001;
	parameter I10 = 9'b010011010;
	parameter I11 = 9'b010011011;
	parameter I12 = 9'b010011100;
	parameter I13 = 9'b010011101;
	parameter I14 = 9'b010011110;
	parameter I15 = 9'b010011111;
	parameter I16 = 9'b010010000;
	parameter J01 = 9'b010100001;
	parameter J02 = 9'b010100010;
	parameter J03 = 9'b010100011;
	parameter J04 = 9'b010100100;
	parameter J05 = 9'b010100101;
	parameter J06 = 9'b010100110;
	parameter K01 = 9'b010110001;
	parameter K02 = 9'b010110010;
	parameter L01 = 9'b011000001;
	parameter L02 = 9'b011000010;
	parameter L03 = 9'b011000011;
	parameter L04 = 9'b011000100;
	parameter L05 = 9'b011000101;
	parameter L06 = 9'b011000110;
	parameter L07 = 9'b011000111;
	parameter L08 = 9'b011001000;
	parameter L09 = 9'b011001001;
	parameter L10 = 9'b011001010;
	parameter L11 = 9'b011001011;
	parameter L12 = 9'b011001100;
	parameter L13 = 9'b011001101;
	parameter M01 = 9'b011010001;
	parameter M02 = 9'b011010010;
	parameter M03 = 9'b011010011;
	parameter M04 = 9'b011010100;
	parameter M05 = 9'b011010101;
	parameter M06 = 9'b011010110;
	parameter M07 = 9'b011010111;
	parameter M08 = 9'b011011000;
	parameter M09 = 9'b011011001;
	parameter M10 = 9'b011011010;
	parameter M11 = 9'b011011011;
	parameter M12 = 9'b011011100;
	parameter M13 = 9'b011011101;
	parameter M14 = 9'b011011110;
	parameter M15 = 9'b011011111;
	parameter M16 = 9'b011010000;
	parameter N01 = 9'b011100001;
	parameter O01 = 9'b011110001;
	parameter O02 = 9'b011110010;
	parameter O03 = 9'b011110011;
	parameter O04 = 9'b011110100;
	parameter O05 = 9'b011110101;
	parameter O06 = 9'b011110110;
	parameter P01 = 9'b100000001;
	parameter P02 = 9'b100000010;
	parameter P03 = 9'b100000011;
	parameter P04 = 9'b100000100;
	parameter P05 = 9'b100000101;
	parameter P06 = 9'b100000110;
	parameter P07 = 9'b100000111;
	parameter Q01 = 9'b100010001;
	parameter R01 = 9'b100100001;
	parameter R02 = 9'b100100010;
	parameter R03 = 9'b100100011;
	parameter R04 = 9'b100100100;
	parameter R05 = 9'b100100101;
	parameter R06 = 9'b100100110;
	parameter R07 = 9'b100100111;
	parameter R08 = 9'b100101000;
	parameter R09 = 9'b100101001;
	parameter R10 = 9'b100101010;
	parameter R11 = 9'b100101011;
	parameter S01 = 9'b100110001;
	parameter S02 = 9'b100110010;
	parameter S03 = 9'b100110011;
	parameter S04 = 9'b100110100;
	parameter S05 = 9'b100110101;
	parameter S06 = 9'b100110110;
	parameter S07 = 9'b100110111;
	parameter S08 = 9'b100111000;
	parameter S09 = 9'b100111001;
	parameter S10 = 9'b100111010;
	parameter S11 = 9'b100111011;
	parameter S12 = 9'b100111100;
	parameter S13 = 9'b100111101;
	parameter S14 = 9'b100111110;
	parameter start=9'b000000000;
	parameter end_state=9'b111111111;   

	
	assign ldbuf = ldbuf_comp & (!clk);
	assign ldflags = ldflags_comp & (!clk);
	assign ldPC = ldPC_comp & (!clk);
	assign ldtemp = ldtemp_comp & (!clk);
	assign ldMAR = ldMAR_comp & (!clk);
	assign ldMDR = ldMDR_comp & (!clk);
	assign ldIR = ldIR_comp & (!clk);
	assign wR = wR_comp & (!clk);

	// D_c0ndition logic
	always@({IRout[13:12],IRout[10:9]})
	begin
		case({IRout[13:12],IRout[10:9]})
			4'b0000:
						D_cond = 1;
			4'b0001:
						D_cond = Zout;
			4'b0010:
						D_cond = !Zout;
			4'b0100:
						D_cond = Cout;
			4'b0101:
						D_cond = !Cout;
			4'b0110:
						D_cond = Vout;
			4'b1000:
						D_cond = !Vout;
			4'b1001:
						D_cond = Sout;
			4'b1010:
						D_cond = !Sout;
			default:
						D_cond = 1'bx;
		endcase
	end
	
	
	
	//next state logic
	always@(state,MFC,D_cond,IRout)
	begin
		case(state)	
			start:
						next_state = A01;
			A01:		next_state = A02;
			A02:		next_state = A03;
			A03:		begin
							if(!MFC) next_state = A03;
							else next_state = A04;
						end
			A04:
						begin
							case(IRout[15:9])
								7'b0111000:
									next_state=B01;
								7'b0111001:
									next_state=C01;
								7'b0111010:
									next_state=D01;
								7'b0111011:			
									next_state=E01;
								7'b1000000:
									next_state=F01;
								7'b1000001:
									next_state=G01;
								7'b1000010:
									next_state=H01;
								7'b1000011:
									next_state=I01;
								7'b1001000:
									next_state=F01;
								7'b1001001:
									next_state=G01;
								7'b1001010:
									next_state=H01;
								7'b1001011:
									next_state=I01;
								7'b1010000:
									next_state=F01;
								7'b1010001:
									next_state=G01;
								7'b1010010:
									next_state=H01;
								7'b1010011:
									next_state=I01;
								7'b1011000:
									next_state=F01;
								7'b1011001:
									next_state=G01;
								7'b1011010:
									next_state=H01;
								7'b1011011:
									next_state=I01;
								7'b1100000:
									next_state=J01;
								7'b1100001:
									next_state=K01;
								7'b1100010:
									next_state=L01;
								7'b1100011:
									next_state=M01;
								7'b1101000:
									next_state=N01;
								7'b1101001:
									next_state=N01;
								7'b1101010:
									next_state=N01;
								7'b1101011:
									next_state=N01;
								7'b1101100:
									next_state=N01;
								7'b1101101:
									next_state=N01;
								7'b1101110:
									next_state=N01;
								7'b1101111:
									next_state=N01;
								7'b0100100:
									next_state=O01;
								7'b0100101:
									next_state=O01;
								7'b0100110:
									next_state=O01;
								7'b0101100:
									next_state=O01;
								7'b0101101:
									next_state=O01;
								7'b0101110:
									next_state=O01;
								7'b0110100:
									next_state=O01;
								7'b0110101:
									next_state=O01;
								7'b0110110:
									next_state=O01;
								7'b0010100:
									next_state=P01;
								7'b0010101:
									next_state=P01;
								7'b0010110:
									next_state=P01;
								7'b0010111:
									next_state=P01;
								7'b0011100:
									next_state=Q01;
								7'b0011101:
									next_state=Q01;
								7'b0011110:
									next_state=Q01;
								7'b0011111:
									next_state=Q01;
								7'b0000000:
									next_state=R01;
								7'b0000001:
									next_state=R01;
								7'b0000010:
									next_state=R01;
								7'b0000011:
									next_state=R01;
								7'b0000100:
									next_state=R01;
								7'b0000101:
									next_state=R01;
								7'b0000110:
									next_state=R01;
								7'b0000111:
									next_state=R01;
								7'b0001000:
									next_state=S01;
								7'b0001001:
									next_state=S01;
								7'b0001010:
									next_state=S01;
								7'b0001011:
									next_state=S01;
								7'b0001100:
									next_state=S01;
								7'b0001101:
									next_state=S01;
								7'b0001110:
									next_state=S01;
								7'b0001111:
									next_state=S01;
						endcase
					end
			B01:	next_state=B02;
			B02:	next_state=B03;
			B03:	
				begin
					if(!MFC) next_state = B03;
					else next_state = B04;
				end
			B04:	next_state=B05;
			B05:	next_state=end_state;
			C01:	next_state=end_state;
			D01:	next_state=D02;
			D02:	next_state=D03;
			D03:	
				begin
					if(!MFC) next_state = D03;
					else next_state = D04;
				end
			D04:	next_state=D05;
			D05:	next_state=D06;
			D06:	next_state=D07;
			D07:	next_state=D08;
			D08:	next_state=D09;
			D09:	next_state=D10;
			D10:	
				begin
					if(!MFC) next_state = D10;
					else next_state = D11;
				end
			D11:	next_state=D12;
			D12:	next_state=end_state;
			E01:	next_state=E02;
			E02:	next_state=E03;
			E03:	
				begin
					if(!MFC) next_state = E03;
					else next_state = E04;
				end
			E04:	next_state=E05;
			E05:	next_state=E06;
			E06:	next_state=E07;
			E07:	next_state=E08;
			E08:	next_state=E09;
			E09:	next_state=E10;
			E10:	
				begin
					if(!MFC) next_state = E10;
					else next_state = E11;
				end
			E11:	next_state=E12;
			E12:	next_state=E13;
			E13:	
				begin
					if(!MFC) next_state = E13;
					else next_state = E14;
				end
			E14:	next_state=E15;
			E15:	next_state=end_state;
			F01:	next_state=F02;
			F02:	next_state=F03;
			F03:	
				begin
					if(!MFC) next_state = F03;
					else next_state = F04;
				end
			F04:	next_state=F05;
			F05:	next_state=F06;
			F06:	next_state=end_state;
			G01:	next_state=G02;
			G02:	next_state=end_state;
			H01:	next_state=H02;
			H02:	next_state=H03;
			H03:	
				begin
					if(!MFC) next_state = H03;
					else next_state = H04;
				end
			H04:	next_state=H05;
			H05:	next_state=H06;
			H06:	next_state=H07;
			H07:	next_state=H08;
			H08:	next_state=H09;
			H09:	next_state=H10;
			H10:	
				begin
					if(!MFC) next_state = H10;
					else next_state = H11;
				end
			H11:	next_state=H12;
			H12:	next_state=H13;
			H13:	next_state=end_state;
			I01:	next_state=I02;
			I02:	next_state=I03;
			I03:	
				begin
					if(!MFC) next_state = I03;
					else next_state = I04;
				end
			I04:	next_state=I05;
			I05:	next_state=I06;
			I06:	next_state=I07;
			I07:	next_state=I08;
			I08:	next_state=I09;
			I09:	next_state=I10;
			I10:	
				begin
					if(!MFC) next_state = I10;
					else next_state = I11;
				end
			I11:	next_state=I12;
			I12:	next_state=I13;
			I13:	
				begin
					if(!MFC) next_state = I13;
					else next_state = I14;
				end
			I14:	next_state=I15;
			I15:	next_state=I16;
			I16:	next_state=end_state;
			J01:	next_state=J02;
			J02:	next_state=J03;
			J03:	
				begin
					if(!MFC) next_state = J03;
					else next_state = J04;
				end
			J04:	next_state=J05;
			J05:	next_state=J06;
			J06:	next_state=end_state;
			K01:	next_state=K02;
			K02:	next_state=end_state;
			L01:	next_state=L02;
			L02:	next_state=L03;
			L03:	
				begin
					if(!MFC) next_state = L03;
					else next_state = L04;
				end
			L04:	next_state=L05;
			L05:	next_state=L06;
			L06:	next_state=L07;
			L07:	next_state=L08;
			L08:	next_state=L09;
			L09:	next_state=L10;
			L10:	
				begin
					if(!MFC) next_state = L10;
					else next_state = L11;
				end
			L11:	next_state=L12;
			L12:	next_state=L13;
			L13:	next_state=end_state;
			M01:	next_state=M02;
			M02:	next_state=M03;
			M03:	
				begin
					if(!MFC) next_state = M03;
					else next_state = M04;
				end
			M04:	next_state=M05;
			M05:	next_state=M06;
			M06:	next_state=M07;
			M07:	next_state=M08;
			M08:	next_state=M09;
			M09:	next_state=M10;
			M10:	
				begin
					if(!MFC) next_state = M10;
					else next_state = M11;
				end
			M11:	next_state=M12;
			M12:	next_state=M13;
			M13:	
				begin
					if(!MFC) next_state = M13;
					else next_state = M14;
				end
			M14:	next_state=M15;
			M15:	next_state=M16;
			M16:	next_state=end_state;
			N01:	next_state=end_state;
			O01:	next_state=O02;
			O02:	next_state=O03;
			O03:	
				begin
					if(!MFC) next_state = O03;
					else next_state = O04;
				end
			O04:	
				begin
					if(!D_cond)	next_state=O04;
					else	next_state=O05;
				end
			O05:	next_state=O06;
			O06:	next_state=end_state;
			P01:	next_state=P02;
			P02:	next_state=P03;
			P03:	
				begin
					if(!MFC) next_state = P03;
					else next_state = P04;
				end
			P04:	next_state=P05;
			P05:	next_state=P06;
			P06:	next_state=P07;
			P07:	next_state=end_state;
			Q01:	next_state=end_state;
			R01:	next_state=R02;
			R02:	next_state=R03;
			R03:	
				begin
					if(!MFC) next_state = R03;
					else next_state = R04;
				end
			R04:	next_state=R05;
			R05:	next_state=R06;
			R06:	next_state=R07;
			R07:	next_state=R08;
			R08:	next_state=R09;
			R09:	next_state=R10;
			R10:	next_state=R11;
			R11:	
				begin
					if(!MFC) next_state = R11;
					else next_state = end_state;
				end
			S01:	next_state=S02;
			S02:	next_state=S03;
			S03:	
				begin
					if(!MFC) next_state = S03;
					else next_state = S04;
				end
			S04:	next_state=S05;
			S05:	next_state=S06;
			S06:	next_state=S07;
			S07:	next_state=S08;
			S08:	next_state=S09;
			S09:	next_state=S10;
			S10:	
				begin
					if(!MFC) next_state = S10;
					else next_state = S11;
				end
			S11:	next_state=S12;
			S12:	next_state=S13;
			S13:	next_state=S14;
			S14:	
				begin
					if(!MFC) next_state = S14;
					else next_state = end_state;
				end
			end_state:
				next_state=start;
		endcase
	end

	
	//assign rd = rd_comp & clk;

	// functions implemented at each state
	always@(state)
	begin
		rdR = 0;
		wR_comp = 0;
		rd = 0;
		wr = 0;
		rMDRi = 0;
		rMDRX = 0;
		TPC = 0;
		Ttemp = 0;
		TMAR = 0;
		TMDR2X = 0;
		TMDR = 0;
		ldIR_comp = 0;
		transx = 0;
		ldMAR_comp = 0;
		ldbuf_comp = 0;
		Tr2 = 0;
		add = 0;
		ldPC_comp = 0;
		ldflags_comp = 0;
		ld2 = 0;
		ldtemp_comp = 0;
		ldMDR_comp = 0;
	
		case(state)
			 
			// for fetch instructions
			A01:
					begin
						ld2 = 1;
						TPC = 1;
						transx = 1;
						ldMAR_comp = 1;
						ldbuf_comp = 1;
					end
	
			A02: 
					begin
						Tr2 = 1;
						add = 1;
						TMAR = 1;
						ldPC_comp = 1;
					end
			A03:
					begin
						TMAR = 1;
						rd = 1;
					end
			A04:
					begin
						ldIR_comp=1;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
					end
					
			// for Load_immediate
			
			B01:
					begin			
						TPC = 1;
						transx = 1;
						ldMAR_comp = 1;
						ldbuf_comp = 1;
					end
			B02: 
					begin
						Tr2 = 1;
						add = 1;
						TMAR = 1;
						ldPC_comp = 1;
					end
			B03:
					begin
						TMAR = 1;
						rd = 1;
					end
			B04:
					begin
						rMDRX = 1;
						ldMDR_comp = 1;
					end
					
			B05:
					begin
						TMDR2X = 1;
						transx = 1;
						wR_comp = 1;
					end
			
			// Load_reg
			C01:
					begin
						sel1 = 2'b01;
						rdR = 1;
						transx = 1;
						wR_comp = 1;
					end

			// Load_BASE_INDEXED
			D01:
					begin
						TPC = 1;
						transx = 1;
						ldMAR_comp = 1;
						ldbuf_comp = 1;
					end
			D02: 
					begin
						Tr2 = 1;
						add = 1;
						TMAR = 1;
						ldPC_comp = 1;
					end
							
			D03:
					begin
						TMAR = 1;
						rd = 1;
					end
			D04:
					begin
						rMDRX = 1;
						ldMDR_comp = 1;
					end
			D05:
					begin
						TMDR2X = 1;
						transx = 1;
						ldtemp_comp = 1;
					end
			D06:
					begin
						sel1 = 2'b01;
						rdR = 1;
						ldbuf_comp = 1;					
					end
			D07:
					begin
						sel1 = 2'b00;
						rdR = 1;
						add = 1;
						rMDRi = 1;
						ldMDR_comp = 1;
					end
			D08:
					begin
						Ttemp = 1;
						ldbuf_comp = 1;
					end
			D09:
					begin
						TMDR2X = 1;
						add = 1;
						TMAR = 1;
						ldMAR_comp = 1;			
					end
			D10:
					begin
						TMAR = 1;
						rd = 1;
					end
					
			D11:
					begin
						rMDRX = 1;
						ldMDR_comp = 1;
					end
			D12:
					begin
						TMDR2X = 1;
						transx = 1;
						wR_comp = 1;
					end
					
			// LOAD_INDIRECT	
			E01:
					begin
						TPC = 1;
						transx = 1;
						ldMAR_comp = 1;
						ldbuf_comp = 1;
					end
			E02: 
					begin
						Tr2 = 1;
						add = 1;
						TMAR = 1;
						ldPC_comp = 1;
					end
							
			E03:
					begin
					   TMAR = 1;
						rd = 1;
					end
			E04:
					begin
						rMDRX = 1;
						ldMDR_comp = 1;
					end
			E05:
					begin
						TMDR2X = 1;
						transx = 1;
						ldtemp_comp = 1;
					end
			E06:
					begin
						sel1 = 2'b01;
						rdR = 1;
						ldbuf_comp = 1;					
					end
			E07:
					begin
						sel1 = 2'b00;
						rdR = 1;
						add = 1;
						rMDRi = 1;
						ldMDR_comp = 1;
					end
			E08:
					begin
						Ttemp = 1;
						ldbuf_comp = 1;
					end
			E09:
					begin
						TMDR2X = 1;
						add = 1;
						ldMAR_comp = 1;			
					end
			E10:
					begin
						TMAR = 1;
						rd = 1;
					end
					
			E11:
					begin
						rMDRX = 1;
						ldMDR_comp = 1;
					end	
			E12:
					begin
						TMDR2X = 1;
						transx = 1;
						TMAR = 1;
						ldMAR_comp = 1;
					end
			E13:
					begin
						TMAR = 1;
						rd = 1;
					end
					
			E14:
					begin
						rMDRX = 1;
						ldMDR_comp = 1;
					end
			E15:
					begin
						TMDR2X = 1;
						transx = 1;
						wR_comp = 1;
					end
			
			// ALU operations !!
			// fnsel_immediate
			F01:
					begin			
						TPC = 1;
						transx = 1;
						ldMAR_comp = 1;
						ldbuf_comp = 1;
					end
			F02: 
					begin
						Tr2 = 1;
						add = 1;
						TMAR = 1;
						ldPC_comp = 1;
					end
			F03:
					begin
						TMAR = 1;
						rd = 1;
					end
			F04:
					begin
						rMDRX = 1;
						ldMDR_comp = 1;
					end
			F05:
					begin
						TMDR2X = 1;
						ldbuf_comp = 1;
					end
			F06:
					begin
						sel1 = 2'b10;
						rdR = 1;
						ldflags_comp = 1;
						wR_comp = 1;
					end
			//fnsel_reg
			G01:
					begin
						sel1 = 2'b01;
						rdR = 1;
						ldbuf_comp = 1;
					end
			G02:
					begin
						sel1 = 2'b10;
						rdR = 1;
						wR_comp = 1;
						ldflags_comp = 1;
					end
			// fnsel_base_indexed
			H01:
					begin			
						TPC = 1;
						transx = 1;
						ldMAR_comp = 1;
						ldbuf_comp = 1;
					end
			H02: 
					begin
						Tr2 = 1;
						add = 1;
						TMAR = 1;
						ldPC_comp = 1;
					end
			H03:
					begin
						TMAR = 1;
						rd = 1;
					end
			H04:
					begin
						rMDRX = 1;
						ldMDR_comp = 1;
					end
			
			H05:
					begin
						TMDR2X = 1;
						transx = 1;
						ldtemp_comp = 1;
					end 
			H06:
					begin
						sel1 = 2'b00;
						rdR = 1;
						ldbuf_comp = 1;
					end
			H07:
					begin
						sel1 = 2'b01;
						rdR = 1;
						add = 1;
						rMDRi = 1;
						ldMDR_comp = 1;
					end
			H08:
					begin
						Ttemp = 1;
						ldbuf_comp = 1;
					end
			H09:
					begin
						TMDR2X = 1;
						add = 1;
						TMAR = 1;
						ldMAR_comp = 1;
					end
					
			H10:
					begin
						TMAR = 1;
						rd = 1;
					end
					
			H11:
					begin
						rMDRX = 1;
						ldMDR_comp = 1;
					end
			H12: 
					begin
						TMDR2X = 1;
						ldbuf_comp = 1;
					end
			H13: 
					begin
						sel1 = 2'b10;
						rdR = 1;
						wR_comp = 1;
						ldflags_comp = 1;
					end
			//fnsel_Indirect
			I01:
					begin			
						TPC = 1;
						transx = 1;
						ldMAR_comp = 1;
						ldbuf_comp = 1;
					end
			I02: 
					begin
						Tr2 = 1;
						add = 1;
						TMAR = 1;
						ldPC_comp = 1;
					end
			I03:
					begin
						TMAR = 1;
						rd = 1;
					end
			I04:
					begin
						rMDRX = 1;
						ldMDR_comp = 1;
					end
			
			I05:
					begin
						TMDR2X = 1;
						transx = 1;
						ldtemp_comp = 1;
					end 
			I06:
					begin
						sel1 = 2'b00;
						rdR = 1;
						ldbuf_comp = 1;
					end
			I07:
					begin
						sel1 = 2'b01;
						rdR = 1;
						add = 1;
						rMDRi = 1;
						ldMDR_comp = 1;
					end
			I08:
					begin
						Ttemp = 1;
						ldbuf_comp = 1;
					end
			I09:
					begin
						TMDR2X = 1;
						add = 1;
						TMAR = 1;
						ldMAR_comp = 1;
					end
					
			I10:
					begin
						TMAR = 1;
						rd = 1;
					end
			I11:
					begin
						rMDRX = 1;
						ldMDR_comp = 1;
					end
			I12:	
					begin
						TMDR2X = 1;
						transx = 1;
						TMAR = 1;
						ldMAR_comp = 1;
					end
			I13:
					begin
						TMAR = 1;
						rd = 1;
					end
			I14:
					begin
						rMDRX = 1;
						ldMDR_comp = 1;
					end
			I15: 
					begin
						TMDR2X = 1;
						ldbuf_comp = 1;
					end
			I16: 
					begin	
						sel1 = 2'b10;
						rdR = 1;
						wR_comp = 1;
						ldflags_comp = 1;
					end
					
			// mns_immediate
			J01:
					begin			
						TPC = 1;
						transx = 1;
						ldMAR_comp = 1;
						ldbuf_comp = 1;
					end
			J02: 
					begin
						Tr2 = 1;
						add = 1;
						TMAR = 1;
						ldPC_comp = 1;
					end
			J03:
					begin
						TMAR = 1;
						rd = 1;
					end
			J04:
					begin
						rMDRX = 1;
						ldMDR_comp = 1;
					end
			J05:
					begin
						TMDR2X = 1;
						ldbuf_comp = 1;
					end
			J06:
					begin
						sel1 = 2'b10;
						rdR = 1;
						ldflags_comp = 1;
			//			wR_comp = 1;
					end


			//mns_reg
			K01:
					begin
						sel1 = 2'b01;
						rdR = 1;
						ldbuf_comp = 1;
					end
			K02:
					begin
						sel1 = 2'b10;
						rdR = 1;
			//			wR_comp = 1;
						ldflags_comp = 1;
					end
			// mns_base_indexed
			L01:
					begin			
						TPC = 1;
						transx = 1;
						ldMAR_comp = 1;
						ldbuf_comp = 1;
					end
			L02: 
					begin
						Tr2 = 1;
						add = 1;
						TMAR = 1;
						ldPC_comp = 1;
					end
			L03:
					begin
						TMAR = 1;
						rd = 1;
					end
			L04:
					begin
						rMDRX = 1;
						ldMDR_comp = 1;
					end
			
			L05:
					begin
						TMDR2X = 1;
						transx = 1;
						ldtemp_comp = 1;
					end 
			L06:
					begin
						sel1 = 2'b00;
						rdR = 1;
						ldbuf_comp = 1;
					end
			L07:
					begin
						sel1 = 2'b01;
						rdR = 1;
						add = 1;
						rMDRi = 1;
						ldMDR_comp = 1;
					end
			L08:
					begin
						Ttemp = 1;
						ldbuf_comp = 1;
					end
			L09:
					begin
						TMDR2X = 1;
						add = 1;
						TMAR = 1;
						ldMAR_comp = 1;
					end
					
			L10:
					begin
						TMAR = 1;
						rd = 1;
					end
					
			L11:
					begin
						rMDRX = 1;
						ldMDR_comp = 1;
					end
			L12: 
					begin
						TMDR2X = 1;
						
						ldbuf_comp = 1;
					end
			L13: 
					begin
						sel1 = 2'b10;
						rdR = 1;
			//			wR_comp = 1;
						ldflags_comp = 1;
					end
			//mns_Indirect
			M01:
					begin			
						TPC = 1;
						transx = 1;
						ldMAR_comp = 1;
						ldbuf_comp = 1;
					end
			M02: 
					begin
						Tr2 = 1;
						add = 1;
						TMAR = 1;
						ldPC_comp = 1;
					end
			M03:
					begin
						TMAR = 1;
						rd = 1;
					end
			M04:
					begin
						rMDRX = 1;
						ldMDR_comp = 1;
					end
			
			M05:
					begin
						TMDR2X = 1;
						transx = 1;
						ldtemp_comp = 1;
					end 
			M06:
					begin
						sel1 = 2'b00;
						rdR = 1;
						ldbuf_comp = 1;
					end
			M07:
					begin
						sel1 = 2'b01;
						rdR = 1;
						add = 1;
						rMDRi = 1;
						ldMDR_comp = 1;
					end
			M08:
					begin
						Ttemp = 1;
						ldbuf_comp = 1;
					end
			M09:
					begin
						TMDR2X = 1;
						add = 1;
						TMAR = 1;
						ldMAR_comp = 1;
					end
					
			M10:
					begin
						TMAR = 1;
						rd = 1;
					end
			M11:
					begin
						rMDRX = 1;
						ldMDR_comp = 1;
					end
			M12:	
					begin
						TMDR2X = 1;
						transx = 1;
						TMAR = 1;
						ldMAR_comp = 1;
					end
			M13:
					begin
						TMAR = 1;
						rd = 1;
					end
			M14:
					begin
						rMDRX = 1;
						ldMDR_comp = 1;
					end
			M15: 
					begin
						TMDR2X = 1;
						ldbuf_comp = 1;
					end
			M16: 
					begin	
						sel1 = 2'b10;
						rdR = 1;
				//		wR_comp = 1;
						ldflags_comp = 1;
					end		

			//2's complement
			N01:
					begin
						sel1 = 2'b10;
						rdR = 1;
						wR_comp=1;
					end
					
			// Jump operations
			O01:
					begin			
						TPC = 1;
						transx = 1;
						ldMAR_comp = 1;
						ldbuf_comp = 1;
					end
			O02: 
					begin
						Tr2 = 1;
						add = 1;
						TMAR = 1;
						ldPC_comp = 1;
					end
			O03:
					begin
						TMAR = 1;
						rd = 1;
					end
			O04:
					begin
						rMDRX = 1;
						ldMDR_comp = 1;
					end
			// id D_condition jump to O05
			O05:
					begin
						TMDR2X = 1;
						ldbuf_comp = 1;
					end
			O06: 
					begin
						TPC = 1;
						add = 1;
						ldPC_comp = 1;
					end
					
			//subroutine_call_and_return
			//Jump_and_link
			P01:
					begin			
						TPC = 1;
						transx = 1;
						ldMAR_comp = 1;
						ldbuf_comp = 1;
					end
			P02: 
					begin
						Tr2 = 1;
						add = 1;
						TMAR = 1;
						ldPC_comp = 1;
					end
			P03:
					begin
						TMAR = 1;
						rd = 1;
					end
			P04:
					begin
						rMDRX = 1;
						ldMDR_comp = 1;
					end
			P05:
					begin
						TPC = 1;
						transx = 1;
						wR_comp = 1;
					end
			P06: 
					begin
						TMDR2X = 1;
						ldbuf_comp = 1;
					end
			P07: 
					begin
						TPC = 1;
						add = 1;
						ldPC_comp = 1;
					end

			//JUMP_REGISTER(JR)

			Q01:
				begin
					sel1 = 2'b10;
					rdR = 1;
					transx = 1;
					ldPC_comp = 1;
				end
				
				
			//5)STORE

			//STORE_BASE_INDEXED
			R01:
					begin			
						TPC = 1;
						transx = 1;
						ldMAR_comp = 1;
						ldbuf_comp = 1;
					end
			R02: 
					begin
						Tr2 = 1;
						add = 1;
						TMAR = 1;
						ldPC_comp = 1;
					end
			R03:
					begin
						TMAR = 1;
						rd = 1;
					end
			R04:
					begin
						rMDRX = 1;
						ldMDR_comp = 1;
					end
			R05: 
					begin
						TMDR2X = 1;
						transx = 1;
						ldtemp_comp = 1;
					end
			R06:
					begin
						sel1 = 2'b01;
						rdR = 1;
						ldbuf_comp = 1;
					end
			R07:
					begin
						sel1 = 2'b00;
						rdR = 1;
						add = 1;
						rMDRi = 1;
						ldMDR_comp = 1;
					end
			R08:
					begin
						Ttemp = 1;
						ldbuf_comp = 1;
					end
			R09:
					begin
						TMDR2X = 1;
						add = 1;
						ldMAR_comp = 1;
					end
			R10:
					begin
						sel1 = 2'b10;
						rdR = 1;
						transx = 1;
						rMDRi = 1;
						TMAR = 1;
						ldMDR_comp = 1;
						TMDR = 1;
					end
			R11:
					begin
						TMAR = 1;
						TMDR = 1;
						wr = 1;
					end
		
		  //Store_indirect
		  S01:
					begin			
						TPC = 1;
						transx = 1;
						ldMAR_comp = 1;
						ldbuf_comp = 1;
					end
			S02: 
					begin
						Tr2 = 1;
						add = 1;
						TMAR = 1;
						ldPC_comp = 1;
					end
			S03:
					begin
						TMAR = 1;
						rd = 1;
					end
			S04:
					begin
						rMDRX = 1;
						ldMDR_comp = 1;
					end
			S05: 
					begin
						TMDR2X = 1;
						transx = 1;
						ldtemp_comp = 1;
					end
			S06:
					begin
						sel1 = 2'b01;
						rdR = 1;
						ldbuf_comp = 1;
					end
			S07:
					begin
						sel1 = 2'b00;
						rdR = 1;
						add = 1;
						rMDRi = 1;
						ldMDR_comp = 1;
					end
			S08:
					begin
						Ttemp = 1;
						ldbuf_comp = 1;
					end
			S09:
					begin
						TMDR2X = 1;
						add = 1;
						TMAR = 1;
						ldMAR_comp = 1;
					end
					
			S10:
					begin
						TMAR = 1;
						rd = 1;
					end
			S11:
					begin
						rMDRX = 1;
						ldMDR_comp = 1;
					end
					
			S12: 
					begin
						TMDR2X = 1;
						transx = 1;
						ldMAR_comp = 1;
					end
			S13: 
					begin
						sel1 = 2'b10;
						rdR = 1;
						transx = 1;
						rMDRi = 1;
						TMAR = 1;
						TMDR = 1;
						ldMDR_comp = 1;
					end

			S14:
					begin
						TMAR = 1;
						TMDR = 1;
						wr = 1;
					end
		endcase
	end

endmodule
