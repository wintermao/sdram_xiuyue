`timescale 1ns / 1ps
// *********************************************************************************
// Project Name : OSXXXX
// Author       : zhangningning
// Email        : nnzhang1996@foxmail.com
// Website      : 
// Module Name  : sdram_aref.v
// Create Time  : 2020-02-10 13:34:03
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

module sdram_aref(
    //Sysytem Interfaces
    input                   sclk            ,
    input                   rst_n           ,
    //SDRAM Interfaces
    output  reg     [ 3:0]  aref_cmd        ,
    output  wire    [11:0]  aref_addr       ,
    //Others
    input                   init_done       ,
    output  reg             aref_req        ,
    output  reg             aref_end        ,
    input                   aref_en         
);
 
//========================================================================================\
//**************Define Parameter and  Internal Signals**********************************
//========================================================================================/
localparam  NOP         =   4'b0111         ;
localparam  PRE         =   4'b0010         ;
localparam  AREF        =   4'b0001         ;
localparam  DELAY_15US  =   11'd1500        ;

reg                         aref_flag       ;
reg             [ 2:0]      cnt_cmd         ;
reg             [10:0]      cnt_15ms        ;

 
//========================================================================================\
//**************     Main      Code        **********************************
//========================================================================================/
assign  aref_addr           =       12'b0100_0000_0000;

always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        aref_flag           <=      1'b0; 
    else if(cnt_cmd >= 3'd7)
        aref_flag           <=      1'b0;
    else if(aref_en == 1'b1)
        aref_flag           <=      1'b1;
    else
        aref_flag           <=      aref_flag;

always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        cnt_cmd             <=      3'd0;
    else if(cnt_cmd >= 3'd7)
        cnt_cmd             <=      3'd0;
    else if(aref_flag == 1'b1)
        cnt_cmd             <=      cnt_cmd + 1'b1; 
    
always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        aref_cmd            <=      NOP;    
    else case(cnt_cmd)
        1       :   aref_cmd            <=      PRE;
        4       :   aref_cmd            <=      AREF;
        default :   aref_cmd            <=      NOP;
    endcase
   
always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        aref_end            <=      1'b0;
    else if(cnt_cmd >= 3'd7)
        aref_end            <=      1'b1;
    else
        aref_end            <=      1'b0;   
          
always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        cnt_15ms            <=      20'd0;
    else if(cnt_15ms == DELAY_15US)
        cnt_15ms            <=      20'd0;
    else if(init_done == 1'b1) 
        cnt_15ms            <=      cnt_15ms + 1'b1;
    else
        cnt_15ms            <=      20'd0;

always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        aref_req            <=      1'b0; 
    else if(cnt_15ms == DELAY_15US)
        aref_req            <=      1'b1;
    else if(aref_en == 1'b1)
        aref_req            <=      1'b0;
    else
        aref_req            <=      aref_req;
            

endmodule
