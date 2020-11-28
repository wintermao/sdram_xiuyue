`timescale 1ns / 1ps
// *********************************************************************************
// Project Name : OSXXXX
// Author       : zhangningning
// Email        : nnzhang1996@foxmail.com
// Website      : 
// Module Name  : sdram_read.v
// Create Time  : 2020-02-11 20:48:41
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

module sdram_read(
    //System Interfaces
    input                   sclk            ,
    input                   rst_n           ,
    //SDRAM Interfaces
    output  reg     [ 3:0]  rd_cmd          ,
    output  reg     [11:0]  rd_addr         ,
    output  wire    [ 1:0]  bank_addr       ,    
    //Communication Interfaces
    input                   rd_trig         ,
    input                   rd_en           ,
    output  reg             rd_end          ,
    output  reg             rd_req          ,
    input                   aref_req        ,
    output  reg             rd_data_en      
);
 
//========================================================================================\
//**************Define Parameter and  Internal Signals**********************************
//========================================================================================/
parameter  RROW_ADDR_END    =   937         ;
parameter  RCOL_MADDR_END   =   256         ;
// Define State
localparam  S_IDLE      =   5'b0_0001       ;
localparam  S_REQ       =   5'b0_0010       ;
localparam  S_ACT       =   5'b0_0100       ;
localparam  S_RD        =   5'b0_1000       ;
localparam  S_PRE       =   5'b1_0000       ;
// SDRAM Command
localparam  CMD_NOP     =   4'b0111         ;
localparam  CMD_PRE     =   4'b0010         ;
localparam  CMD_AREF    =   4'b0001         ;
localparam  CMD_ACT     =   4'b0011         ;
localparam  CMD_RD      =   4'b0101         ;

reg                 [ 4:0]  state           ;
reg                         flag_act_end    ;
reg                         row_end         ;
reg                 [ 1:0]  burst_cnt       ;
reg                         data_end        ;
reg                         flag_row_end    ;
reg                         flag_data_end   ;
reg                         flag_aref_req   ;
reg                 [ 8:0]  col_addr        ;
reg                 [ 1:0]  burst_cnt_r     ;
reg                 [11:0]  row_addr        ;
reg                         data_end_r      ;
reg                         data_end_r2     ;
reg                         row_end_r       ;
reg                         row_end_r2      ; 
reg                         rfifo_wd_en_r1  ;
reg                         rfifo_wd_en_r2  ;
reg                         rfifo_wd_en_r3  ;



//========================================================================================\
//**************     Main      Code        **********************************
//========================================================================================/
assign      bank_addr       =       2'b00;

always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        state           <=      S_IDLE;
    else case(state)
        S_IDLE    :   if(rd_trig == 1'b1)
                        state           <=      S_REQ;
                    else
                        state           <=      state;                        
        S_REQ   :   if(rd_en == 1'b1)
                        state           <=      S_ACT;
                    else
                        state           <=      state;                        
        S_ACT   :   if(flag_act_end == 1'b1)
                        state           <=      S_RD;
                    else
                        state           <=      state;                        
        S_RD    :   if(data_end_r == 1'b1 || row_end_r == 1'b1)
                        state           <=      S_PRE;
                    else if(burst_cnt_r == 2'd2 && aref_req == 1'b1)
                        state           <=      S_PRE;
                    else
                        state           <=      state;                        
        S_PRE   :   if(flag_data_end == 1'b1)
                        state           <=      S_IDLE;
                    else if(flag_aref_req == 1'b1)
                        state           <=      S_REQ;
                    else if(flag_row_end == 1'b1)
                        state           <=      S_ACT;
                    else 
                        state           <=      state;
        default :   state           <=      S_IDLE;
    endcase
  
always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        flag_aref_req       <=      1'b0;
    else if(state == S_PRE && aref_req == 1'b1)
        flag_aref_req       <=      1'b1;
    else
        flag_aref_req       <=      1'b0; 

always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        flag_act_end    <=      1'b0;    
    else if(state == S_ACT && rd_cmd == CMD_ACT)
        flag_act_end    <=      1'b1;
    else 
        flag_act_end    <=      1'b0; 

always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        row_end         <=      1'b0;
    else if(col_addr == 9'd508 && burst_cnt == 2'd1)
        row_end         <=      1'b1;
    else
        row_end         <=      1'b0;

always @(posedge sclk)begin
    row_end_r   <=      row_end;
    row_end_r2  <=      row_end_r;
end
          
always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        burst_cnt       <=      2'd0;
    else if(state == S_RD)
        burst_cnt       <=      burst_cnt + 1'b1;
    else
        burst_cnt       <=      2'd0;

always @(posedge sclk)
    burst_cnt_r     <=      burst_cnt;

 always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        data_end    <=      1'b0; 
    else if(state == S_RD && rd_cmd == CMD_RD && col_addr == RCOL_MADDR_END - 4 && row_addr == RROW_ADDR_END)
        data_end    <=      1'b1;    
    else if((col_addr == 'd252 || col_addr == 508) && burst_cnt == 2'd1)
        data_end    <=      1'b1;
    else
        data_end    <=      1'b0;
            
always @(posedge sclk)begin
    data_end_r      <=      data_end;
    data_end_r2     <=      data_end_r;  
end  

always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        flag_row_end    <=      1'b0;   
    else if(state == S_PRE && row_end_r2 == 1'b1)
        flag_row_end    <=      1'b1;
    else 
        flag_row_end    <=      1'b0;
         
always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        flag_data_end   <=      1'b0;  
    else if(state == S_PRE && data_end_r2 == 1'b1) 
        flag_data_end   <=      1'b1;
    else
        flag_data_end   <=      1'b0;
        
always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        col_addr        <=      12'd0;
    else if(state == S_RD && rd_cmd == CMD_RD && col_addr == RCOL_MADDR_END - 4 && row_addr == RROW_ADDR_END)
        col_addr        <=      9'd0;
    else if(state == S_RD && rd_cmd == CMD_RD && col_addr == 'd508)
        col_addr        <=      12'd0;   
    else if(state == S_RD && rd_cmd == CMD_RD)
        col_addr        <=      col_addr + 3'd4;
    else
        col_addr        <=      col_addr;

always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        row_addr        <=      12'd0;  
    else if(state == S_RD && rd_cmd == CMD_RD && col_addr == RCOL_MADDR_END - 4 && row_addr == RROW_ADDR_END)
        row_addr        <=      12'd0;
    else if(state == S_RD && rd_cmd == CMD_RD && col_addr == 'd508)
        row_addr        <=      row_addr + 1'b1;
    else
        row_addr        <=      row_addr;
          
    
          
always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        rd_cmd          <=      CMD_NOP;    
    else case(state)
        S_ACT   :   if(rd_cmd != CMD_ACT && flag_act_end == 1'b0)
                        rd_cmd          <=      CMD_ACT;
                    else
                        rd_cmd          <=      CMD_NOP;
        S_RD    :   if(data_end == 1'b1 || row_end == 1'b1)
                        rd_cmd          <=      CMD_NOP;
                    else if(burst_cnt_r == 2'd2 && aref_req == 1'b1)
                        rd_cmd          <=      CMD_NOP;
                    else if(burst_cnt == 2'd0)
                        rd_cmd          <=      CMD_RD;
                    else
                        rd_cmd          <=      CMD_NOP; 
        S_PRE   :   if(rd_cmd != CMD_PRE)
                        rd_cmd          <=      CMD_PRE;
                    else 
                        rd_cmd          <=      CMD_NOP;
                
        default :   rd_cmd          <=      CMD_NOP;
    endcase

always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        rd_addr         <=      12'd0;    
    else case(state)
        S_ACT   :   if(rd_cmd != CMD_ACT)
                        rd_addr         <=      row_addr;
                    else
                        rd_addr         <=      12'd0;
        S_RD    :   if(data_end == 1'b1 || row_end == 1'b1)
                        rd_addr         <=      12'd0;
                    else if(burst_cnt_r == 2'd2 && aref_req == 1'b1)
                        rd_addr         <=      12'd0;
                    else if(burst_cnt == 2'd0)
                        rd_addr         <=      {3'b000,col_addr};
                    else
                        rd_addr         <=      12'd0; 
        S_PRE   :   rd_addr         <=      12'b0100_0000_0000;
        default :   rd_addr         <=      12'd0;
    endcase

always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        rd_end          <=      1'b0;   
    else if(flag_data_end == 1'b1)
        rd_end          <=      1'b1;
    else if(state != S_IDLE && flag_aref_req == 1'b1 && rd_end == 1'b0)
        rd_end          <=      1'b1;
    else
        rd_end          <=      1'b0;
          
always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        rd_req          <=      1'b0;  
    else if(rd_en == 1'b1)
        rd_req          <=      1'b0;
    else if(state == S_REQ)
        rd_req          <=      1'b1;
    else
        rd_req          <=      rd_req;
          
always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        rfifo_wd_en_r1  <=      1'b0;    
    else if(state == S_RD)
        rfifo_wd_en_r1  <=      1'b1;
    else
        rfifo_wd_en_r1  <=      1'b0;  

always @(posedge sclk)begin
    rfifo_wd_en_r2      <=      rfifo_wd_en_r1;
    rfifo_wd_en_r3      <=      rfifo_wd_en_r2;
end

always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        rd_data_en      <=      1'b0;
    else 
        rd_data_en      <=      rfifo_wd_en_r3;


endmodule
