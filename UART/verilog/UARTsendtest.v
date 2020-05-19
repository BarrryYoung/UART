module UARTsendtest();

	reg clk16x;
	reg rst_n;
	reg TransEn;
	reg [7:0] DataToTrans;
	wire BufFull;
	wire tx;

	//---Module instantiation---
	UARTsend UARTsend1(
		.clk16x(clk16x),
		.rst_n(rst_n),
		.TransEn(TransEn),
		.DataToTrans(DataToTrans),
		.BufFull(BufFull),
		.tx(tx));

	//----Code starts here: integrated by Robei-----
	initial begin
	clk16x=0;
	rst_n=1;
	TransEn=0;
	DataToTrans=0;
	#2
	rst_n=0;
	#2
	DataToTrans=8'b10110010;
	#2
	rst_n=1;
	#2
	TransEn=1;
	
	
	#1000
	$finish;
	end
	
	
	always begin
	#1
	clk16x=~clk16x;
	end
	
	
	
	
	initial begin
		$dumpfile ("F:/EDAzhang/eda/UART/UARTsendtest.vcd");
		$dumpvars;
	end
endmodule    //UARTsendtest

