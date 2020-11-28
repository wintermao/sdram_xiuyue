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
    output  reg             sdram_cs_n      ,
    output  reg             sdram_cas_n     ,
    output  reg             sdram_ras_n     ,
    output  reg             sdram_we_n      ,
    output  reg     [ 1:0]  sdram_bank      ,
    output  reg     [11:0]  sdram_addr      ,
    output  wire    [ 1:0]  sdram_dqm       ,
    inout           [15:0]  sdram_dq        ,
    //User Interfaces
    input                   wfifo_wclk      ,
    input                   wfifo_wr_en     ,
    input           [15:0]  wfifo_wr_data   ,
    input                   rfifo_rclk      ,
    input                   rfifo_rd_en     ,
    output  wire    [15:0]  rfifo_rd_data   ,
    output  wire            rfifo_rd_ready            
);
 
//========================================================================================\
//**************Define Parameter and  Internal Signals**********************************
//========================================================================================/
parameter  RROW_ADDR_END    =   937         ;
parameter  RCOL_MADDR_END   =   256         ;
parameter  WROW_ADDR_END    =   937         ;
parameter  WCOL_MADDR_END   =   256         ;

localparam      NOP     =   4'b0111         ;

localparam      IDLE    =   5'b0_0001       ;
localparam      ARBIT   =   5'b0_0010       ;
localparam      AREF    =   5'b0_0100       ;
localparam      WRITE   =   5'b0_1000       ;
localparam      READ    =   5'b1_0000       ;
//sdram_pll
wire												sclk						;
//sdram_init
wire                [ 3:0]  init_cmd        ;
wire                [11:0]  init_addr       ;
wire                        init_done       ;
//AREF
wire                        aref_req        ;
reg                         aref_en         ;
wire                        aref_end        ;
wire                [ 3:0]  aref_cmd        ;
wire                [11:0]  aref_addr       ;
//WRITE
wire                [ 3:0]  wr_cmd          ;
wire                [11:0]  wr_addr         ;
wire                [ 1:0]  wr_bank_addr    ;
wire                [15:0]  wr_data         ;    
reg                         wr_en           ;
wire                        wr_end          ;
wire                        wr_req          ;
wire                        wr_trig         ;
//READ
wire                [ 3:0]  rd_cmd          ;
wire                [11:0]  rd_addr         ;
wire                [ 1:0]  rd_bank_addr    ;
reg                         rd_en           ;
wire                        rd_end          ;
wire                        rd_req          ;
wire                        rd_trig         ;
//sdram_auto_write_read
wire                        wfifo_rd_en     ;       
wire                [15:0]  wfifo_rd_data   ;
wire                        rfifo_wr_en     ;      
wire                [15:0]  rfifo_wr_data   ;

//ARBIT
reg                 [ 4:0]  state           ;

//Others
reg                 [15:0]  sdram_dq1       ;
reg                         sdram_dq_en     ;
 
//========================================================================================\
//**************     Main      Code        **********************************
//========================================================================================/
assign      sdram_dqm       =       2'b00;
assign      sdram_clk       =       ~sclk;
assign      sdram_cke       =       1'b1;
assign      sdram_dq        =       sdram_dq_en == 1'b1 ? sdram_dq1 : 16'hzzzz;
assign      rfifo_wr_data   =       sdram_dq;

always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        state       <=      IDLE;
    else case(state)
        IDLE    :   if(init_done == 1'b1)
                        state           <=      ARBIT;
                    else 
                        state           <=      state;
        ARBIT   :   if(aref_req == 1'b1)
                        state           <=      AREF;
                    else if(wr_req == 1'b1)
                        state           <=      WRITE;
                    else if(rd_req == 1'b1)
                        state           <=      READ;
                    else
                        state           <=      state;
        AREF    :   if(aref_end == 1'b1)
                        state           <=      ARBIT;
                    else
                        state           <=      state;
        WRITE   :   if(wr_end == 1'b1)
                        state           <=      ARBIT;
                    else 
                        state           <=      state;
        READ    :   if(rd_end == 1'b1)
                        state           <=      ARBIT;
                    else
                        state           <=      state;                        
        default :   state           <=      IDLE;
    endcase

always @(*)
    case(state)
        IDLE    :   begin
                        sdram_addr      =      init_addr;
                        {sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n}      =       init_cmd;
                        sdram_dq_en     =       1'b0;
                    end
        AREF    :   begin
                        sdram_addr      =      aref_addr;
                        {sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n}      =       aref_cmd;
                    end
        WRITE   :   begin
                        sdram_addr      =      wr_addr;
                        {sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n}      =       wr_cmd;
                        sdram_dq1       =      wr_data;
                        sdram_bank      =      wr_bank_addr;
                        sdram_dq_en     =      1'b1;
                    end
        READ    :   begin
                        sdram_addr      =      rd_addr;
                        {sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n}      =       rd_cmd;
                        sdram_bank      =      rd_bank_addr;
                        sdram_dq_en     =      1'b0;  
                    end
        default :   begin
                        sdram_addr      =      12'd0;
                        {sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n}      =       NOP;
                        sdram_dq1       =      16'd0;
                        sdram_bank      =      2'b00;
                        sdram_dq_en     =      1'b0;
                    end
    endcase

always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        aref_en             <=      1'b0;
    else if(state == ARBIT && aref_req == 1'b1) 
        aref_en             <=      1'b1;
    else
        aref_en             <=      1'b0;

always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        wr_en               <=      1'b0;
    else if(state == ARBIT && aref_req == 1'b1) 
        wr_en               <=      1'b0;
    else if(state == ARBIT && wr_req == 1'b1) 
        wr_en               <=      1'b1;
    else
        wr_en               <=      1'b0;
        
always @(posedge sclk or negedge rst_n)
    if(rst_n == 1'b0)
        rd_en               <=      1'b0;
    else if(state == ARBIT && aref_req == 1'b1) 
        rd_en               <=      1'b0;
    else if(state == ARBIT && wr_req == 1'b1)
        rd_en               <=      1'b0;
    else if(state == ARBIT && rd_req == 1'b1)
        rd_en               <=      1'b1;
    else
        rd_en               <=      1'b0;

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

sdram_aref sdram_aref_inst(
    //Sysytem Interfaces
    .sclk                   (sclk                   ),
    .rst_n                  (rst_n                  ),
    //SDRAM Interfaces
    .aref_cmd               (aref_cmd               ),
    .aref_addr              (aref_addr              ),
    //Others
    .aref_req               (aref_req               ),
    .aref_end               (aref_end               ),
    .aref_en                (aref_en                ),
    .init_done              (init_done              )
);

sdram_auto_write_read sdram_auto_write_read_inst(
    // system signals
    .rst_n                  (rst_n                  ),       
    // wfifo
    .wfifo_wclk             (wfifo_wclk             ),
    .wfifo_wr_en            (wfifo_wr_en            ),       
    .wfifo_wr_data          (wfifo_wr_data          ),
    .wfifo_rclk             (sclk                   ),
    .wfifo_rd_en            (wfifo_rd_en            ),       
    .wfifo_rd_data          (wfifo_rd_data          ),
    .wr_trig                (wr_trig                ),
    // rfifo
    .rfifo_wclk             (~sclk                  ),       // 100MHz
    .rfifo_wr_en            (rfifo_wr_en            ),       
    .rfifo_wr_data          (rfifo_wr_data          ),
    .rfifo_rclk             (rfifo_rclk             ),
    .rfifo_rd_en            (rfifo_rd_en            ),       
    .rfifo_rd_data          (rfifo_rd_data          ),
    .rd_trig                (rd_trig                ),
    // user interfaces
    .rfifo_rd_ready         (rfifo_rd_ready         )
);

sdram_write #(
    .WROW_ADDR_END          (WROW_ADDR_END          ),
    .WCOL_MADDR_END         (WCOL_MADDR_END         )
    ) sdram_write_inst(
    //System Interfaces
    .sclk                   (sclk                   ),
    .rst_n                  (rst_n                  ),
    //SDRAM Interfaces
    .wr_cmd                 (wr_cmd                 ),
    .wr_addr                (wr_addr                ),
    .bank_addr              (wr_bank_addr           ),
    .wr_data                (wr_data                ), 
    //Communication Interfaces
    .wr_trig                (wr_trig                ),
    .wr_en                  (wr_en                  ),
    .wr_end                 (wr_end                 ),
    .wr_req                 (wr_req                 ),
    .aref_req               (aref_req               ),
    .wfifo_rd_en            (wfifo_rd_en            ),
    .wfifo_rd_data          (wfifo_rd_data          )    
);

sdram_read #(
    .RROW_ADDR_END          (RROW_ADDR_END          ),
    .RCOL_MADDR_END         (RCOL_MADDR_END         )
    ) sdram_read_inst(
    //System Interfaces
    .sclk                   (sclk                   ),
    .rst_n                  (rst_n                  ),
    //SDRAM Interfaces
    .rd_cmd                 (rd_cmd                 ),
    .rd_addr                (rd_addr                ),
    .bank_addr              (rd_bank_addr           ),    
    //Communication Interfaces
    .rd_trig                (rd_trig                ),
    .rd_en                  (rd_en                  ),
    .rd_end                 (rd_end                 ),
    .rd_req                 (rd_req                 ),
    .aref_req               (aref_req               ),
    .rd_data_en             (rfifo_wr_en            )
);

sdram_pll sdram_pll_inst(
    //osc clock
    .inclk0									(clock									),
    //c0 clock output
		.c0											(sclk										),
		//pll locked status
		.locked									(												)
);
 
endmodule
