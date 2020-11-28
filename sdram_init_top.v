`timescale 1ns / 1ps
// *********************************************************************************
// Project Name : OSXXXX
// Author       : zhangningning
// Email        : nnzhang1996@foxmail.com
// Website      : 
// Module Name  : sdram_top.v
// Create Time  : 2020-02-09 17:22:24
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

module sdram_top(
    //System Interfaces
    input                   clock           ,
    input                   rst_n           ,
    //SDRAM Interfaces
    output  wire            sdram_clk       ,
    output  wire            sdram_cke       ,
    output  wire            sdram_cs_n      ,
    output  wire            sdram_cas_n     ,
    output  wire            sdram_ras_n     ,
    output  wire            sdram_we_n      ,
    output  wire    [ 1:0]  sdram_bank      ,
    output  wire    [11:0]  sdram_addr      ,
    output  wire    [ 1:0]  sdram_dqm       ,
    output  wire						init_done				,
    output  wire						pll_locked			,
    inout           [15:0]  sdram_dq        
);
 
//========================================================================================\
//**************Define Parameter and  Internal Signals**********************************
//========================================================================================/
//sdram_init
wire                [ 3:0]  init_cmd        ;
wire                [11:0]  init_addr       ;
//wire                        init_done       ;
wire												sclk						;
 
//========================================================================================\
//**************     Main      Code        **********************************
//========================================================================================/
assign      sdram_dqm       =       2'b00;
assign      sdram_clk       =       ~sclk;
assign      {sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n}      =       init_cmd;
assign      sdram_addr      =       init_addr;
assign      sdram_cke       =       1'b1;
assign      sdram_bank      =       2'b00;

sdram_init sdram_init_inst(
    //System Interfaces
    .sclk                   (sclk                   ),
    .rst_n                  (rst_n                  ),
    //SDRAM Interfaces
    .sdram_cmd              (init_cmd               ),
    .sdram_addr             (init_addr              ),
    //Others
    .init_done              (init_done              )
);

sdram_pll sdram_pll_inst(
    //osc clock
    .inclk0									(clock									),
    //c0 clock output
		.c0											(sclk										),
		//pll locked status
		.locked									(pll_locked							)
);

endmodule
