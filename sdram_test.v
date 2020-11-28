`timescale 1ns / 1ps

// *********************************************************************************
// Project Name : OSXXXX
// Author       : winter_mao
// Email        : winter_mao@163.com
// Website      : 
// Module Name  : sdram_test.v
// Create Time  : 2020-11-21 16:36:08
// Editor       : ultraedit, tab size (2)
// CopyRight(c) : All Rights Reserved
//
// *********************************************************************************
// Modification History:
// Date             By              Version                 Change Description
// -----------------------------------------------------------------------
// XXXX       winter_mao          1.0                        Original
//  
// *********************************************************************************

module sdram_test(
		//System Interfaces
		input		            			clock           ,
		input                   	rst_n           ,
		//SDRAM Interfaces		
		output		wire          	sdram_clk       ,
		output		wire          	sdram_cke       ,
		output		wire          	sdram_cs_n      ,
		output		wire          	sdram_cas_n     ,
		output		wire          	sdram_ras_n     ,
		output		wire          	sdram_we_n      ,
		output		wire   	[ 1:0] 	sdram_bank      ,
		output    wire		[11:0]  sdram_addr      ,
		output    wire		[ 1:0]  sdram_dqm       ,
		inout    					[15:0]  sdram_dq        ,
		//User Interfaces
		input		            			rfifo_rd_en     ,
		input		            			wfifo_wr_en     ,
		output		wire    [15:0]  rfifo_rd_data   ,
		output		wire          	rfifo_rd_ready  ,
		output		wire		[ 3:0]	LED
);

reg    [15:0]               wfifo_wr_data   ;
reg    [15:0]               rfifo_test_data ;
reg    [20:0]  							err_cnt         ;

always @(posedge clock or negedge rst_n)
    if(rst_n == 1'b0)
        wfifo_wr_data       <=      16'd0;
    else if(wfifo_wr_en == 1'b0)
        wfifo_wr_data       <=      wfifo_wr_data + 1'b1;
    else
        wfifo_wr_data       <=      wfifo_wr_data;

always @(posedge clock or negedge rst_n)
    if(rst_n == 1'b0)
       rfifo_test_data      <=      16'd0; 
    else if(rfifo_rd_en == 1'b0)
        rfifo_test_data     <=      rfifo_test_data + 1'b1;
    else
        rfifo_test_data     <=      rfifo_test_data;

always @(posedge clock or negedge rst_n)
    if(rst_n == 1'b0)
        err_cnt             <=      21'd0;
    else if(rfifo_rd_en == 1'b0 && rfifo_test_data != rfifo_rd_data) 
        err_cnt             <=      err_cnt + 1'b1;
    else
        err_cnt             <=      err_cnt;         

assign LED		=		~err_cnt[3:0];    

sdram_top sdram_top_inst(
    //System Interfaces
    .clock                  (clock                   ),
    .rst_n                  (rst_n                  ),
    //SDRAM Interfaces
    .sdram_clk              (sdram_clk              ),
    .sdram_cke              (sdram_cke              ),
    .sdram_cs_n             (sdram_cs_n             ),
    .sdram_cas_n            (sdram_cas_n            ),
    .sdram_ras_n            (sdram_ras_n            ),
    .sdram_we_n             (sdram_we_n             ),
    .sdram_bank             (sdram_bank             ),
    .sdram_addr             (sdram_addr             ),
    .sdram_dqm              (sdram_dqm              ),
    .sdram_dq               (sdram_dq               ),
    //User Interfaces
    .wfifo_wclk             (clock	                ),
    .wfifo_wr_en            (wfifo_wr_en            ),
    .wfifo_wr_data          (wfifo_wr_data          ),
    .rfifo_rclk             (clock	                ),
    .rfifo_rd_en            (rfifo_rd_en            ),
    .rfifo_rd_data          (rfifo_rd_data          ),
    .rfifo_rd_ready         (rfifo_rd_ready         )
);

endmodule
