`timescale 1ns / 1ps
// *********************************************************************************
// Project Name : OSXXXX
// Author       : zhangningning
// Email        : nnzhang1996@foxmail.com
// Website      : 
// Module Name  : sdram_init.v
// Create Time  : 2020-02-09 16:20:31
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

module sdram_init(
    //System Interfaces
    input                   sclk            ,
    input                   rst_n           ,
    //SDRAM Interfaces
    output  reg     [ 3:0]  sdram_cmd       ,
    output  reg     [11:0]  sdram_addr      ,
    //Others
    output  reg             init_done  
);
 
//========================================================================================\
//**************Define Parameter and  Internal Signals**********************************
//========================================================================================/
localparam  DELAY_200US =  20000           ;
//SDRAM Command
localparam  NOP         =  4'b0111          ;
localparam  PRE         =  4'b0010          ;
localparam  AREF        =  4'b0001          ;
localparam  MSET        =  4'b0000          ;

reg                 [14:0]  cnt_200us       ;
reg                         flag_200us      ;
reg                 [ 4:0]  cnt_cmd         ;
 
//========================================================================================\
//**************     Main      Code        **********************************
//========================================================================================/
always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        cnt_200us       <=      11'd0;
    else if(flag_200us == 1'b0)
        cnt_200us       <=      cnt_200us + 1'b1;
    else
        cnt_200us       <=      cnt_200us;

always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        flag_200us      <=      1'b0;
    else if(cnt_200us >= DELAY_200US) 
        flag_200us      <=      1'b1;
    else
        flag_200us      <=      flag_200us;

always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        cnt_cmd         <=      5'd0;
    else if(flag_200us == 1'b1 && cnt_cmd <= 5'd19)
        cnt_cmd         <=      cnt_cmd + 1'b1;
    else 
        cnt_cmd         <=      cnt_cmd;

always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        sdram_cmd       <=      NOP;
    else case(cnt_cmd)
        1       :   sdram_cmd       <=      PRE;
        3       :   sdram_cmd       <=      AREF;
        11      :   sdram_cmd       <=      AREF;
        19      :   sdram_cmd       <=      MSET;
        default :   sdram_cmd       <=      NOP;
    endcase

always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        sdram_addr      <=      12'b0100_0000_0000;
    else if(cnt_cmd == 5'd19) 
        sdram_addr      <=      12'b0000_0011_0010;
    else
        sdram_addr      <=      12'b0100_0000_0000;

always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        init_done       <=      1'b0; 
    else if(cnt_cmd > 5'd19) 
        init_done       <=      1'b1;
    else
        init_done       <=      init_done;
        
endmodule
