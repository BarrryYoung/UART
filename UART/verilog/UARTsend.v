module UARTsend(
	clk16x,
	rst_n,
	TransEn,
	DataToTrans,
	BufFull,
	tx);

	//---Ports declearation: generated by Robei---
	input clk16x;
	input rst_n;
	input TransEn;
	input [7:0] DataToTrans;
	output BufFull;
	output tx;

	wire clk16x;
	wire rst_n;
	wire TransEn;
	wire [7:0] DataToTrans;
	reg BufFull;
	reg tx;

	//----Code starts here: integrated by Robei-----
	
	/*    capture the rising edge of TransEn    */
	reg [7:0] cnt; 
	reg TransEn_r;
	wire pos_tri;
	always@(posedge clk16x or negedge rst_n)
	begin
	    if(!rst_n)
	        TransEn_r <= 1'b0;
	    else
	        TransEn_r <= TransEn;
	end
	assign pos_tri = ~TransEn_r & TransEn;
	
	/*
	*    when the rising edge of DataEn comes up, load the Data to buffer
	*/
	reg [7:0] ShiftReg;
	always@(posedge pos_tri or negedge rst_n)
	begin
	    if(!rst_n)
	        ShiftReg <= 8'b0;
	    else
	        ShiftReg <= DataToTrans;
	end
	//----------------------------------------------    
	/*     counter control      */
	reg cnt_en;
	always@(posedge clk16x or negedge rst_n)
	begin
	    if(!rst_n)
	        begin
	            cnt_en  <= 1'b0;
	            BufFull <= 1'b0;
	        end
	    else if(pos_tri==1'b1)
	        begin
	            cnt_en  <=1'b1;
	            BufFull <=1'b1;
	        end
	    else if(cnt==8'd160)
	        begin
	            cnt_en<=1'b0;
	            BufFull <=1'b0;
	        end
	end
	
	//---------------------------------------------
	/*      counter module        */
	
	always@(posedge clk16x or negedge rst_n)
	begin
	    if(!rst_n)
	        cnt<=8'd0;
	    else if(cnt_en)
	        cnt<=cnt+1;
	    else
	        cnt<=8'd0;
	end
	
	//---------------------------------------------
	/*      transmit module        */
	
	always@(posedge clk16x or negedge rst_n)
	begin
	    if(!rst_n)
	        begin
	            tx <= 1'b1;
	        end
	    else if(cnt_en)
	        case(cnt)
	            8'd0   :  tx <= 1'b0;
	            8'd16  :  tx <= ShiftReg[0];
	            8'd32  :  tx <= ShiftReg[1];
	            8'd48  :  tx <= ShiftReg[2];
	            8'd64  :  tx <= ShiftReg[3];
	            8'd80  :  tx <= ShiftReg[4];
	            8'd96  :  tx <= ShiftReg[5];
	            8'd112 :  tx <= ShiftReg[6];
	            8'd128 :  tx <= ShiftReg[7];
	            8'd144 :  tx <= 1'b1;
	        endcase
	    else
	        tx <= 1'b1;
	end
	
	
	
	
	
endmodule    //UARTsend

