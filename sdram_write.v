`timescale 1ns / 1ps
// *********************************************************************************
// Project Name : OSXXXX
// Author       : zhangningning
// Email        : nnzhang1996@foxmail.com
// Website      : 
// Module Name  : sdram_write.v
// Create Time  : 2020-02-10 20:05:26
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

module sdram_write(
    //System Interfaces
    input                   sclk            ,
    input                   rst_n           ,
    //SDRAM Interfaces
    output  reg     [ 3:0]  wr_cmd          ,
    output  reg     [11:0]  wr_addr         ,
    output  wire    [ 1:0]  bank_addr       ,
    output  wire    [15:0]  wr_data         ,     
    //Communication Interfaces
    input                   wr_trig         ,
    input                   wr_en           ,
    output  reg             wr_end          ,
    output  reg             wr_req          ,
    input                   aref_req        ,
    output  reg             wfifo_rd_en     ,
    input           [15:0]  wfifo_rd_data      
);
 
//========================================================================================\
//**************Define Parameter and  Internal Signals**********************************
//========================================================================================/
parameter  WROW_ADDR_END    =   937         ;
parameter  WCOL_MADDR_END   =   256         ;
parameter  WCOL_FADDR_END   =   512         ;
// Define State
localparam  S_IDLE      =   5'b0_0001       ;
localparam  S_REQ       =   5'b0_0010       ;
localparam  S_ACT       =   5'b0_0100       ;
localparam  S_WR        =   5'b0_1000       ;
localparam  S_PRE       =   5'b1_0000       ;
// SDRAM Command
localparam  CMD_NOP     =   4'b0111         ;
localparam  CMD_PRE     =   4'b0010         ;
localparam  CMD_AREF    =   4'b0001         ;
localparam  CMD_ACT     =   4'b0011         ;
localparam  CMD_WR      =   4'b0100         ;

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


//========================================================================================\
//**************     Main      Code        **********************************
//========================================================================================/
assign      bank_addr       =       2'b00;
assign      wr_data         =       wfifo_rd_data;


always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        state           <=      S_IDLE;
    else case(state)
        S_IDLE    :   if(wr_trig == 1'b1)
                        state           <=      S_REQ;
                    else
                        state           <=      state;                        
        S_REQ   :   if(wr_en == 1'b1)
                        state           <=      S_ACT;
                    else
                        state           <=      state;                        
        S_ACT   :   if(flag_act_end == 1'b1)
                        state           <=      S_WR;
                    else
                        state           <=      state;                        
        S_WR    :   if(data_end_r == 1'b1 || row_end_r == 1'b1)
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
    else if(state == S_ACT && wr_cmd == CMD_ACT)
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
    else if(state == S_WR)
        burst_cnt       <=      burst_cnt + 1'b1;
    else
        burst_cnt       <=      2'd0;

always @(posedge sclk)
    burst_cnt_r     <=      burst_cnt;

 always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        data_end    <=      1'b0;     
    else if(state == S_WR && wr_cmd == CMD_WR && col_addr == WCOL_MADDR_END - 4 && row_addr == WROW_ADDR_END)
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
        col_addr        <=      9'd0;
    else if(state == S_WR && wr_cmd == CMD_WR && col_addr == WCOL_MADDR_END - 4 && row_addr == WROW_ADDR_END)
        col_addr        <=      9'd0;
    else if(state == S_WR && wr_cmd == CMD_WR && col_addr == 'd508)
        col_addr        <=      9'd0;   
    else if(state == S_WR && wr_cmd == CMD_WR)
        col_addr        <=      col_addr + 3'd4;
    else
        col_addr        <=      col_addr;

always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        row_addr        <=      12'd0;  
    else if(state == S_WR && wr_cmd == CMD_WR && col_addr == WCOL_MADDR_END - 4 && row_addr == WROW_ADDR_END)
        row_addr        <=      12'd0;
    else if(state == S_WR && wr_cmd == CMD_WR && col_addr == 'd508)
        row_addr        <=      row_addr + 1'b1;
    else
        row_addr        <=      row_addr;
             
          
always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        wr_cmd          <=      CMD_NOP;    
    else case(state)
        S_ACT   :   if(wr_cmd != CMD_ACT && flag_act_end == 1'b0)
                        wr_cmd          <=      CMD_ACT;
                    else
                        wr_cmd          <=      CMD_NOP;
        S_WR    :   if(data_end == 1'b1 || row_end == 1'b1)
                        wr_cmd          <=      CMD_NOP;
                    else if(burst_cnt_r == 2'd2 && aref_req == 1'b1)
                        wr_cmd          <=      CMD_NOP;
                    else if(burst_cnt == 2'd0)
                        wr_cmd          <=      CMD_WR;
                    else
                        wr_cmd          <=      CMD_NOP; 
        S_PRE   :   if(wr_cmd != CMD_PRE)
                        wr_cmd          <=      CMD_PRE;
                    else 
                        wr_cmd          <=      CMD_NOP;
                
        default :   wr_cmd          <=      CMD_NOP;
    endcase

always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        wr_addr         <=      12'd0;    
    else case(state)
        S_ACT   :   if(wr_cmd != CMD_ACT)
                        wr_addr         <=      row_addr;
                    else
                        wr_addr         <=      12'd0;
        S_WR    :   if(data_end == 1'b1 || row_end == 1'b1)
                        wr_addr         <=      12'd0;
                    else if(burst_cnt_r == 2'd2 && aref_req == 1'b1)
                        wr_addr         <=      12'd0;
                    else if(burst_cnt == 2'd0)
                        wr_addr         <=      {3'b000,col_addr};
                    else
                        wr_addr         <=      12'd0; 
        S_PRE   :   wr_addr         <=      12'b0100_0000_0000;
        default :   wr_addr         <=      12'd0;
    endcase

always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        wfifo_rd_en     <=      1'b0;    
    else if(state == S_WR)
        wfifo_rd_en     <=      1'b1;
    else
        wfifo_rd_en     <=      1'b0;    

always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        wr_end          <=      1'b0;   
    else if(flag_data_end == 1'b1)
        wr_end          <=      1'b1;
    else if(state != S_IDLE && flag_aref_req == 1'b1 && wr_end == 1'b0)
        wr_end          <=      1'b1;
    else
        wr_end          <=      1'b0;
          
always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        wr_req          <=      1'b0;  
    else if(wr_en == 1'b1)
        wr_req          <=      1'b0;
    else if(state == S_REQ)
        wr_req          <=      1'b1;
    else
        wr_req          <=      wr_req;
          
endmodule
