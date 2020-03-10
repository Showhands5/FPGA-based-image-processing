`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/03 21:09:06
// Design Name: Liukun
// Module Name: disp_VGA
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 		Ŀ�꣺����chooseѡ�����ģʽ��ʾ
//		�����鿴ʱ�򱨸淴����֤��output = �����Ķ��Ƕ�׵ķ�������ɽϴ���ӳ٣�����ʱ��Υ��
//		�����ֻҪ���մ���Ľ���Ļ���û����������
//		�������Ҫ��ÿ������Ĺ��̸��ݰ�ťȫ����ʾ�����Ļ�������Ҫ���µķ��� : ״̬��
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "headfile.v"

module disp_VGA(
	input clk,
	input rxd,
	input rst, // effective when 1
	input [3:0]choose,//choose mode,binary code, 
	output  HSYNC,
	output  VSYNC,
	output [12-1:0] VGA_data,
	output [15:0]led
);
	reg sys_rst;
	

	wire [11:0] hcount;	//����
	wire [11:0] vcount;
	wire clk_40m;
	wire clk_80m;
	wire clk_100m;
	
	wire divide_clken;
	wire [15:0]Uart_data;
	//wire [15:0]Uart_data;//16bit ����ת��
	wire rxd_flag;
	assign led = Uart_data;
	
	
	wire [11:0]post_data;
	wire post_clken;
	wire [18:0]ram_addr;//!!!!!!!!!!!!!!!
	
	//wire [19:0]ram_addr;//!!!!!!!!!!!!!!!
	//wire [7:0]ram_data;
	
	// PLL��Ƶ clk100M --> clk_25m
	clk_VGA U_Clk(
		.clk(clk),
		.clk_40m(clk_40m),
		.clk_80m(clk_80m),
		.clk_100m(clk_100m),
		.rst_n(~rst)
	); 

	always@ (posedge clk_100m or posedge rst) begin
		if(rst)
			sys_rst <= 1;
		else
			sys_rst <= rst;
	
	end
	//!!!!!!!!!!!�����������ӳ�
	
	/*
	//--------------------..........................................
	wire					bps_en_rx,bps_clk_rx;
	wire			[15:0]	rx_data;
	
	
	
	//UART���ղ�����ʱ�ӿ���ģ�� ����
	Baud #
	(
	.BPS_PARA				(16'd10417		)//256000:391
	)
	Baud_rx
	(	
	.clk_in					(clk_100m		),	//ϵͳʱ��
	.rst_n_in				(~sys_rst		),	//ϵͳ��λ������Ч
	.bps_en					(bps_en_rx		),	//����ʱ��ʹ��
	.bps_clk				(bps_clk_rx		)	//����ʱ�����
	);
	 
	//UART��������ģ�� ����
	Uart_Rx Uart_Rx_uut
	(
	.clk_in					(clk_100m		),	//ϵͳʱ��
	.rst_n_in				(~sys_rst		),	//ϵͳ��λ������Ч
	.bps_en					(bps_en_rx		),	//����ʱ��ʹ��
	.bps_clk				(bps_clk_rx		),	//����ʱ������
	.rs232_rx				(rxd			),	//UART��������
	.rx_data				(rx_data		),	//���յ�������
	.ram_addr				(ram_addr		)
	);
	
	assign led = rx_data;
	assign Uart_data = rx_data;
	//---------------------.............................................*/
	
	wire divide_clk;

	clk_divider_precise 
	#(
		
	//	parameter		DEVIDE_CNT = 32'd175921860	//256000bps * 16
	//	parameter		DEVIDE_CNT = 32'd87960930	//128000bps * 16
	//	parameter		DEVIDE_CNT = 32'd79164837	//115200bps * 16
		//.DEVIDE_CNT(32'd6597070)	//9600bps * 16
		.DEVIDE_CNT(32'd175921860)	//256000bps * 16
		//.DEVIDE_CNT(32'd6597070) //9600
	)
	U_clk_divider_precise
	(
		.clk(clk_100m), //!!!!!ԭʼ100MHZ��clk��������
		.rst(sys_rst),
		
		.divide_clk(),//��ֹʹ�÷�Ƶ���ʱ�� �������ҳ�ղؼ�
		.divide_clken(divide_clken) //����ȫ��ʱ��clk 100MHZ��ʱ��ʹ�� 
	);

	wire is_one_pic_done;
	
	Uart_receiver_1byte U_receiver
	(
		.clk(clk_100m),
		.rst_n(~sys_rst),
		.clken_16bps(divide_clken),	//clk_bps * 16 ֻ�е�clkenΪ1ʱ�ſɲ���
		.rxd(rxd),					//uart txd interface
		
		.rxd_data(Uart_data),		//uart data received[15:0]
		.rxd_flag(rxd_flag),		//uart data receive done 
		.ram_addr(ram_addr)
		//.is_one_pic_done(is_one_pic_done)
	);
	
	/*
	Uart_no_sample_receiver U_receiver(
	//gobal clock
		.clk(clk_100m),
		.rst(rst),
		.clken_16bps(divide_clken),	//clk_bps * 16 ֻ�е�clkenΪ1ʱ�ſɲ���
		.rxd(rxd),					//uart txd interface
		
		.rxd_data(Uart_data),		//uart data received[15:0]
		.rxd_flag(rxd_flag),		//uart data receive done 
		.ram_addr(ram_addr)
	);*/
	
	/*
	Uart_receiver_1byte U_receiver_1byte(
	//gobal clock
		.clk(clk_100m),
		.rst_n(~rst),
		.clken_16bps(divide_clken),	//clk_bps * 16 ֻ�е�clkenΪ1ʱ�ſɲ���
		.rxd(rxd),					//uart txd interface
		
		.rxd_data(Uart_data),		//uart data received[15:0]
		.rxd_flag(rxd_flag),			//uart data receive done 
		.ram_addr(ram_addr)
		//.is_one_pic_done(is_one_pic_done)
	);
	*/
	
	//assign VGA_data = {Uart_data[15:12],Uart_data[10:7],Uart_data[4:1]};
	
	//ͼ�����clk �� VGA��clk ��һ��������
	//wire [15:0]pre_data;
	//wire pre_clken;
	//assign pre_data = Uart_data;
	//assign pre_clken = rxd_flag;
	wire [18:0]VGA_data_addr;
	wire pic_ena;
/*
	Uart_VGA_ram U_Uart_VGA_ram (
		.clka(clk_100m),    	// input wire clka  ȫ��ʱ�ӣ�����
		.ena(1'b1),      		// input wire ena  //ֱ��������Ҫ�ӳ�
		.wea(rxd_flag),      	// input wire [0 : 0] wea
		.addra(ram_addr),  		// input wire [18 : 0] addra
		.dina(Uart_data),    	// input wire [15 : 0] dina
		
		
		//.clkb(),    	// input wire clkb	һ��clk������ wea������ֻ���Ƕ�����д
		//.enb(),      	// input wire enb
		//.addrb(),  	// input wire [18 : 0] addrb
		//.doutb()  	// output wire [15 : 0] doutb
		//��ֹ��ͻ��������д�룬�½��ض���������������������
		.clkb(clk_40m),    		// input wire clkb	һ��clk������ wea������ֻ���Ƕ�����д
		.enb(1'b1),      		// input wire enb
		.addrb(VGA_data_addr),  // input wire [18 : 0] addrb
		.doutb(ram_data)  		// output wire [15 : 0] doutb
	);*/
	/*
	reg rxd_flag_r;
	reg [18:0]ram_addr_r;
	reg [15:0]Uart_data_r;
	
	always@(posedge clk_100m or posedge rst)
	begin
		if(rst) begin
			rxd_flag_r <= 0;
			ram_addr_r <= 0;
			Uart_data_r <= 0;
		end
		else begin
			rxd_flag_r <= rxd_flag;
			ram_addr_r <= ram_addr;
			Uart_data_r <= Uart_data;			
		end
			
	end
	*/
	//wire [15:0] ram_data_r;
	wire [15:0]	ram_data;
	
	Uart_VGA_ram U_Uart_VGA_ram(
	//Uart_VGA_ram U_Uart_VGA_ram (
	  .clka(clk_100m),    	// input wire clka
	  .ena(1'b1),      		// input wire ena
	  .wea(rxd_flag),     	 // input wire [0 : 0] wea
	  .addra(ram_addr),  		// input wire [18 : 0] addra
	  .dina(Uart_data),   	 // input wire [15 : 0] dina
	  .douta(),  			// output wire [15 : 0] douta
	  
	  .clkb(clk_40m),  	 	 // input wire clkb
	  .enb(1'b1),     	 	// input wire enb
	  .web(1'b0),     		 // input wire [0 : 0] web
	  .addrb(VGA_data_addr),  // input wire [18 : 0] addrb
	  .dinb(),   				 // input wire [15 : 0] dinb
	  .doutb(ram_data)  		// output wire [15 : 0] doutb
	);
	
	
	/*
	always@(posedge clk_40m or posedge rst) begin
		if(rst) begin
			ram_data <= 0;
		end
		else begin
			ram_data <= ram_data_r;
		end
	end
	asyn_ram  
	#(
		.DWIDTH(5'd16),	//data width				
		.AWIDTH(19'd270000)		//address width 
	)
	my_ram
	(	
		.wr_clk(clk_100m),//input wr_clk,	
		.wr_data(Uart_data),//input [DWIDTH-1:0] wr_data,	
		.wr_en(rxd_flag),//input wr_en,	
		.wr_addr(ram_addr),//input [AWIDTH-1:0] wr_addr,		
		
		.rd_clk(clk_40m),//input  rd_clk,	
		.rd_data(ram_data),//output [DWIDTH-1:0] rd_data,	
		.rd_en(1'b0),//input  rd_en,	
		.rd_addr(VGA_data_addr)//input [AWIDTH-1:0] rd_addr
	); */
	/*
	always@(posedge clk_40m or posedge rst) begin
		if(rst) begin
				VGA_data <= 12'hff0;
		end
		else begin
			if(pic_ena)
				VGA_data <= {ram_data_r[15:12],ram_data_r[10:7],ram_data_r[4:1]};
			else
				VGA_data <= 12'hff0;
		end
	end
	*/
	//assign VGA_data = pic_ena ? {ram_data[15:12],ram_data[10:7],ram_data[4:1]}: 12'hfff;
	
	wire pre_HSYNC;
	wire pre_VSYNC;
		
	// ����ɨ��
	scan U_scan(
		.clk(clk_40m), //VGAʱ�ӣ�������
		.rst(sys_rst),
		
		.HSYNC(pre_HSYNC),
		.VSYNC(pre_VSYNC),
		.hcount(hcount),
		.vcount(vcount),
		.pic_ena(pic_ena),
		.VGA_data_addr(VGA_data_addr)
	);
	
	
	process_pic U_process_pic(
		.clk(clk_40m),
		.rst(sys_rst),
		.pre_clken(pic_ena),
		.pre_data(ram_data),
		.choose(choose),
		
		.pre_HSYNC(pre_HSYNC),
		.pre_VSYNC(pre_VSYNC),
		
		.post_data(VGA_data),
		.post_clken(post_clken),
		.post_HSYNC(HSYNC),//HSYNC),
		.post_VSYNC(VSYNC)//VSYNC)
		//.ram_addr(ram_addr)
	);
	
/*
	VGA_display U_VGA_display(
		.clk(clk_40m),
		.rst(rst),
		.ram_data(ram_data),
		.hcount(hcount),
		.vcount(vcount),
		
		
		.VGA_data(VGA_data),//---> ���
		.VGA_data_addr(VGA_data_addr)
    );
	//assign VGA_data = post_data;
	*/

endmodule





		// ���ַ���ȷ���ܲ��� ���ӳٸ����ϣ�
		/*
	assign HSYNC = pic_ena0 ? 
	(choose == 4'b0001 ? 
		hs0:
	(choose == 4'b0010 ? 
		hs1: // 3{tmp_data_gety[7:4]}������ �ᱨ��
	(choose == 4'b0011 ?  
		hs2:  0 ))): 0;
  
	assign VSYNC = pic_ena0 ? 
	(choose == 4'b0001 ? 
		vs0:
	(choose == 4'b0010 ? 
		vs1: // 3{tmp_data_gety[7:4]}������ �ᱨ��
	(choose == 4'b0011 ?  
		vs2:  0 ))): 0;
*/
	
  
  /*
always@(negedge clk_40m)
	begin
	if(VGA_data_ena && pic_ena)
		VGA_data = {RGB_from_ROM[15:12],RGB_from_ROM[10:7],RGB_from_ROM[4:1]};
	else
		VGA_data = 0;
	end
  
  */
  
/*	
always @ (*)
  begin	
  if	 ((hcount > `HSYNC_B) && (hcount <= `HSYNC_B + 10'd100) && VGA_data_ena)			
  VGA_data = 12'hf00;//{4��b1,4��b0,4��b0};//12'hE0;			//��ɫ	
  else if((hcount > `HSYNC_B + 10'd100) && (hcount <= `HSYNC_B + 10'd200) && VGA_data_ena)			
  VGA_data = 12'h0f0;//{4��b0,4��b1,4��b0};//12'hFC;			//greenɫ	
  else if((hcount > `HSYNC_B + 10'd200) && (hcount <= `HSYNC_B + 10'd300) && VGA_data_ena)			
  VGA_data = 12'h00f;//{4��b0,4��b0,4��b1};//12'h03;			//��ɫ	
  else if((hcount > `HSYNC_B + 10'd300) && (hcount <= `HSYNC_B + 10'd400) && VGA_data_ena)			
  VGA_data = 12'hff0;//{4��b1,4��b1,4��b0};//12'h1C;			//��ɫ	
  else if((hcount > `HSYNC_B + 10'd400) && (hcount <= `HSYNC_B + 10'd500) && VGA_data_ena)			
  VGA_data = 12'h0ff;//{4��b1,4��b1,4��b0};//12'h1C;			//	
  else if((hcount > `HSYNC_B + 10'd500) && (hcount <= `HSYNC_B + 10'd600) && VGA_data_ena)			
  VGA_data = 12'h000;//{4��b1,4��b1,4��b0};//12'h1C;			//	
  else if((hcount > `HSYNC_B + 10'd600) && (hcount <= `HSYNC_B + 10'd700) && VGA_data_ena)			
  VGA_data = 12'h111;//{4��b1,4��b1,4��b0};//12'h1C;			//	
  else		
  VGA_data = 12'hfff;//{4��b0,4��b1,4��b1};12'h00;				//��ɫ	
  end
*/	


  /*  
clk_VGA instance_name
 (
 // Clock in ports
  .clk(clk),      // input clk
  // Clock out ports
  .clk_25m(clk_25m),     // output clk_25m
  // Status and control signals
  .rst(rst));       // input rst
  
  
blk_mem_VGA your_instance_name (
    .clka(clka),    // input wire clka
    .addra(addra),  // input wire [18 : 0] addra
    .douta(douta)  // output wire [7 : 0] douta
  );    */

  /*
  always @(posedge CLK, negedge RST)  //VGA ��ʾ����	
  if(!RST)		begin red<=1'b0; green<=1'b0; blue<=1'b0;end
  else begin 			 
  if((CH>Ha+Hb)&&(CH<=Ha+Hb+7'd80))			 
  begin red<=1'b1; green<=1'b0; blue<=1'b0;
  end			 
  if((CH>Ha+Hb+7'd80)&&(CH<=Ha+Hb+8'd160))			 
  begin red<=1'b0; green<=1'b0; blue<=1'b1;
  end			 
  if((CH>Ha+Hb+8'd160)&&(CH<=Ha+Hb+9'd240))			 
  begin red<=1'b1; green<=1'b1; blue<=1'b0;
  end			 
  if((CH>Ha+Hb+9'd240)&&(CH<=Ha+Hb+9'd320))			 
  begin red<=1'b1; green<=1'b0; blue<=1'b0;
  end			 
  if((CH>Ha+Hb+9'd320)&&(CH<=Ha+Hb+9'd400))			 
  begin red<=1'b0; green<=1'b1; blue<=1'b0;
  end			 
  if((CH>Ha+Hb+9'd400)&&(CH<=Ha+Hb+9'd480))			 
  begin red<=1'b1; green<=1'b1; blue<=1'b0;
  end			 
  if((CH>Ha+Hb+9'd480)&&(CH<=Ha+Hb+10'd600))			
  begin red<=1'b0; green<=1'b1; blue<=1'b0;
  end		 
  end 

  
  always @ (*)
  begin	
  if((hsync_cnt > `HSYNC_B) && (hsync_cnt <= `HSYNC_B + 10'd200) && vga_data_en)			
  VGA_DATA_N = 8'hE0;			//��ɫ	
  else if((hsync_cnt > `HSYNC_B + 10'd200) && (hsync_cnt <= `HSYNC_B + 10'd400) && vga_data_en)			
  VGA_DATA_N = 8'hFC;			//��ɫ	
  else if((hsync_cnt > `HSYNC_B + 10'd400) && (hsync_cnt <= `HSYNC_B + 10'd600) && vga_data_en)			
  VGA_DATA_N = 8'h03;			//��ɫ	
  else if((hsync_cnt > `HSYNC_B + 10'd600) && (hsync_cnt <= `HSYNC_B + 10'd800) && vga_data_en)			
  VGA_DATA_N = 8'h1C;			//��ɫ	
  else		
  VGA_DATA_N = 8'h00;			//��ɫ	
  end
*/