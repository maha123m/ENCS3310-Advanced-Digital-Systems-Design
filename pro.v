  // Name:Maha Maher Mali  
  // ID:1200746
// mux4x1
  module mux4x1( B,sel0,sel1,F);
	input B,sel0,sel1;
	output	F;
	wire not_sel0,not_sel1;
	wire w[3:0];
	not	#(3ns) G1(not_sel0,sel0); // first invertor
	not #(3ns) G2(not_sel1,sel1);// second  invertor
	and #(7ns) G3(w[0],not_sel0,not_sel1,B);
	and	#(7ns) G4(w[1],sel0,not_sel1,~B);
	and	#(7ns) G5(w[2],not_sel0,sel0,0);
	and	#(7ns) G6(w[3],sel0,sel1,1);
	or	#(7ns) G7(F,w[0],w[1],w[2],w[3]); 
  endmodule  
  
// Name:Maha Maher Mali  
 // ID:1200746
// full-adder
 module FA(A,B,cary_in,sum,cary_out);
input A,B,cary_in;
output sum,cary_out;	 
wire w1,w2,w3;
xor#(11ns) G1(w1,A,B); 
xor #(11ns) G2(sum,w1,cary_in);
and #(7ns) G3(w2,A,B);
and #(7ns) G4(w3,w1,cary_in);
or  #(7ns) G5(cary_out,w2,w3);
endmodule	   	  

 // Name:Maha Maher Mali  
 // ID:1200746
//	 4 bit  binary adder 
module Four_Bit_Adder(A,B,cary_in,sum,cary_out);
input [3:0]A,B;
input cary_in;
output [3:0]sum;
output cary_out;	 
wire [2:0]caray;
FA	Block1	(cary_in,A[0],B[0],sum[0],caray[0]);
FA 	Block2	(caray[0],A[1],B[1],sum[1],caray[1]);
FA	Block3	(caray[1],A[2],B[2],sum[2],caray[2]);
FA	Block4	(caray[2],A[3],B[3],sum[3],cary_out);
endmodule	   

// Name:Maha Maher Mali  
// ID:1200746 
// Arithmtic unit
module Arithmetic_Unit(A,s1,s0,cary_in,d,carray_out);
	input [3:0]A;
	input s1,s0,cary_in;
	output [3:0] d; 
	output carray_out;
	wire [2:0]caray;
	wire [3:0]w;  
	
	mux4x1 m1(s1,s0,,w[0]);
	FA f1(A[0],w[0],cary_in,d[0],caray[0]);
	
	
	mux4x1 m2(s1,s0,,w[1]);
	FA f2(A[1],w[1],caray[0],d[1],caray[1]);
	
	mux4x1 m3(s1,s0,,w[2]);
	FA f3(A[2],w[2],caray[1],d[2],caray[2]);
	
	mux4x1 m4(s1,s0,,w[3]);
	FA f4(A[3],w[3],caray[2],d[2],caray[2]);
	endmodule	
	
	
	
	// Name:Maha Maher Mali  
 // ID:1200746
//	 test genrator 
	module the_test_generator(clk,a,b,select0,select1,carray_in, D);
	input clk;
	
	output reg  [3:0] a,b;
	output  reg select0,select1;
	output reg carray_in;
	output reg D;
	initial @(posedge clk)
				begin
					{a,b,carray_in,select0,select1}=11'b00000000000;
					repeat (31)
					{a,b,carray_in,select0,select1}={a,b,carray_in,select0,select1}+11'b00000000001;	
					end 
		
	always @(posedge clk)
		begin  
			
			
		if(select1==0 & select0==0 &carray_in==0 ) // add  
				D=a+b;
			
		else if (select1==0 & select0==0 & carray_in==1)	// 	add with carry 
				D= a+b+1;
				
		else if (select1==0 & select0==1 & carray_in==0)	// subtract with borrow
				D= a+~b;		
			  
		else if (select1==0 & select0==1 & carray_in==1)	// subtract
				D= a+~b+1;
				
		else if (select1==1 & select0==0 & carray_in==0)	// transfer a
				D= a;
				
				
		else if (select1==1 & select0==0 & carray_in==1)	 //	 incremnt
				D= a+1;
				
		else if (select1==1 & select0==1 & carray_in==0 )	// 	 decremnt
				D= a-1;
				
		else if (select1==1 & select0==1 & carray_in==1 ) 	//  transfer a
				D=a;
						
		end	 
		endmodule	   
		
			 
	 
// Name:Maha Maher Mali  
// ID:1200746 

//  Result Analyze	 

module Result_Analyze(result_sys,correct_result,clock);
		input [3:0]result_sys;	// the result from system 
		input [3:0] correct_result;	 // the correct result 	 
		input clock;
	always @ (posedge clock)  begin
		
		if(result_sys[3:0]==correct_result[3:0])
				begin
					$display("sucsess",$time);	
					$finish	;
				end	
				
		else
			begin 
			 $display ("error",$time);	
			 $finish; 
		end
		end
		endmodule
	///////////////////////////////////////
	//  Stage 2////

// Name:Maha Maher Mali  
// ID:1200746 
//  varification_forsystem	
 
module varification_forsystem_Stage1(c_in,a,b,s0,s1,correct_value,system_value,clk);
	output [3:0]a,b;
	output s0,s1;
	input c_in,clk;
	output correct_value[3:0];
	input system_value[3:0];
	Test_Generator t1(clk,a,b,s0,s1,c_in,correct_value[3:0]);
	Arithmetic_Unit t2(a,b,s0,s1,c_in,system_value[3:0]);
	Result_Analyze t3(system_value[3:0],correct_value[3:0],clk);
endmodule 


	///////////////////////////////	   
	// Name:Maha Maher Mali  
	// ID:1200746 
	//carry look ahead	   

	
   module Carry_Look_Ahead_Adder(a,b,carry_in,carry_out,sum);
	
	input carry_in;
	input[3:0]a,b;
	
	output [3:0]sum;
	output carry_out;
	
	wire [3:0]w,u;
	wire [9:0]e; 
	wire [4:0]q;	
		
xor#(11ns)(w[0],a[0],b[0]);
xor#(11ns)(w[1],a[1],b[1]);
xor#(11ns)(w[2],a[2],b[2]);
xor#(11ns)(w[3],a[3],b[3]);

and#(7ns)(u[0],a[0],b[0]);
and#(7ns)(u[1],a[1],b[1]);
and#(7ns)(u[2],a[2],b[2]);
and#(7ns)(u[3],a[3],b[3]); 

assign q[0]=carry_in;

and #(7ns)(e[0],w[0],carry_in); 
and #(7ns)(e[1],w[1],u[0]);
and #(7ns)(e[2],w[1],w[0],carry_in);
and #(7ns)(e[3],w[2],u[1]);
and #(7ns)(e[4],w[2],w[1],u[0]);
and #(7ns)(e[5],w[1],w[1],w[0],carry_in);
and #(7ns)(e[6],w[3],u[2]);
and #(7ns)(e[7],w[3],w[2],u[1]);
and #(7ns)(e[8],w[3],w[2],w[1],u[0]);
and #(7ns)(e[9],w[3],w[2],w[1],w[0],carry_in);  

or #(7ns)(q[1],u[0],e[0]);
or #(7ns)(q[2],u[1],e[1],e[2]);
or #(7ns)(q[3],u[2],e[3],e[4],e[5]);
or #(7ns)(q[4],u[3],e[6],e[7],e[8],e[9]);

xor #(11ns)(sum[0],w[0],q[0]);
xor #(11ns)(sum[1],w[1],q[1]);
xor #(11ns)(sum[2],w[2],q[2]);
xor #(11ns)(sum[3],w[3],q[3]);

assign carry_out=q[4];	 

endmodule


//Name:Maha Maher Mali
//ID:1200746
//VARIFICATION FOR STAGE 2

 module varification_forsystem_Stage2(c_in,a,b,s0,s1,correct_value,system_value,clk);
	output [3:0]a,b;
	output s0,s1;
	input c_in,clk;
	output correct_value[3:0];
	input system_value[3:0];
	Test_Generator u1(clk,a,b,s0,s1,c_in,correct_value[3:0]);
	Carry_Look_Ahead_Adder u2 (a,b,s0,s1,c_in,system_value[3:0]);
	Result_Analyze u3(system_value[3:0],correct_value[3:0],clk);
endmodule 

