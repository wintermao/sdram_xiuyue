`timescale 1ns / 1ps
// *********************************************************************************
// Project Name : OSXXXX
// Author       : zhangningning
// Email        : nnzhang1996@foxmail.com
// Website      : 
// Module Name  : sdram_auto_write_read.v
// Create Time  : 2020-02-15 11:26:21
// Editor       : sublime text3, tab size (4)
// CopyRight(c) : All Rights Reserved
//
// *********************************************************************************
// Modification History:
// Date             By              Version                 Change Description
// -----------------------------------------------------------------------
// XXXX       zhangningning          1.0                        Original
//  
// *********************************************************************************

module sdram_auto_write_read(
    // system signals
    input                   rst_n                   ,       
    // wfifo
    input                   wfifo_wclk              ,
    input                   wfifo_wr_en             ,       
    input           [15:0]  wfifo_wr_data           ,
    input                   wfifo_rclk              ,
    input                   wfifo_rd_en             ,       
    output  wire    [15:0]  wfifo_rd_data           ,
    output  reg             wr_trig                 ,
    // rfifo
    input                   rfifo_wclk              ,       // 100MHz
    input                   rfifo_wr_en             ,       
    input           [15:0]  rfifo_wr_data           ,
    input                   rfifo_rclk              ,
    input                   rfifo_rd_en             ,       
    output  wire    [15:0]  rfifo_rd_data           ,
    output  reg             rd_trig                 ,
    // user interfaces
    output  reg             rfifo_rd_ready      
);
 
//========================================================================================\
//**************Define Parameter and  Internal Signals**********************************
//========================================================================================/
parameter   WFIFO_RD_CNT    =       256             ;
parameter   RFIFO_WR_CNT    =       250             ;



wire                [10:0]  wfifo_rd_count          ;
wire                [10:0]  rfifo_wr_count          ;
reg                         flag_rd                 ;   

 
//========================================================================================\
//**************     Main      Code        **********************************
//========================================================================================/
always @(posedge rfifo_wclk or negedge rst_n)
    if(rst_n == 1'b0)
        rfifo_rd_ready      <=      1'b0;
    else if(rfifo_wr_count >= RFIFO_WR_CNT)
        rfifo_rd_ready      <=      1'b1;
    else
        rfifo_rd_ready      <=      rfifo_rd_ready;
          
always @(posedge wfifo_rclk or negedge rst_n)
     if(rst_n == 1'b0)
        flag_rd             <=      1'b0; 
     else if(wfifo_rd_count >= WFIFO_RD_CNT)
        flag_rd             <=      1'b1;
    else
        flag_rd             <=      flag_rd;

always @(posedge rfifo_wclk or negedge rst_n)
    if(rst_n == 1'b0)
        rd_trig             <=      1'b0;
    else if(rfifo_wr_count < RFIFO_WR_CNT && flag_rd == 1'b1)
        rd_trig             <=      1'b1;
    else
        rd_trig             <=      1'b0; 
    
always @(posedge wfifo_rclk or negedge rst_n)
    if(rst_n == 1'b0)
        wr_trig             <=      1'b0;
    else if(wfifo_rd_count >= WFIFO_RD_CNT)
        wr_trig             <=      1'b1;
    else
        wr_trig             <=      1'b0;

//wfifo
fifo_generator_0 wfifo_inst(
  .wrclk                   	(wfifo_wclk                 ),                // input wire wr_clk
  .rdclk                  	(wfifo_rclk                 ),                // input wire rd_clk
  .data                     (wfifo_wr_data              ),                      // input wire [15 : 0] din
  .wrreq                    (wfifo_wr_en                ),                  // input wire wr_en
  .rdreq                    (wfifo_rd_en                ),                  // input wire rd_en
  .q                     		(wfifo_rd_data              ),                    // output wire [15 : 0] dout
  .wrfull                   (                           ),                    // output wire full
  .rdempty                  (                           ),                  // output wire empty
  .rdusedw            			(wfifo_rd_count             ),  // output wire [10 : 0] rd_data_count
  .wrusedw            			(                           )  // output wire [10 : 0] wr_data_count
);
//rfifo
fifo_generator_0 rfifo_inst(
  .wrclk                   	(rfifo_wclk                 ),                // input wire wr_clk
  .rdclk                   	(rfifo_rclk                 ),                // input wire rd_clk
  .data                     (rfifo_wr_data              ),                      // input wire [15 : 0] din
  .wrreq                    (rfifo_wr_en                ),                  // input wire wr_en
  .rdreq                    (rfifo_rd_en                ),                  // input wire rd_en
  .q                     		(rfifo_rd_data              ),                    // output wire [15 : 0] dout
  .wrfull                   (                           ),                    // output wire full
  .rdempty                  (                           ),                  // output wire empty
  .rdusedw            			(                           ),  // output wire [10 : 0] rd_data_count
  .wrusedw            			(rfifo_wr_count             )  // output wire [10 : 0] wr_data_count
);

endmodule