`timescale 1ns / 1ps
`define CLOCK    10
// *********************************************************************************
// Project Name : OSXXXX
// Author       : zhangningning
// Email        : nnzhang1996@foxmail.com
// Website      : 
// Module Name  : sdram_init_tb.v
// Create Time  : 2020-02-09 17:10:08
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

module sdram_init_tb;
reg                         sclk            ;
reg                         rst_n           ;
wire                        sdram_clk       ;
wire                        sdram_cke       ;
wire                        sdram_cs_n      ;
wire                        sdram_cas_n     ;
wire                        sdram_ras_n     ;
wire                        sdram_we_n      ;
wire    [ 1:0]              sdram_bank      ;
wire    [11:0]              sdram_addr      ;
wire    [ 1:0]              sdram_dqm       ;
wire    [15:0]              sdram_dq        ;
reg                         wr_trig         ;
reg                         rd_trig         ;

initial begin
    sclk        =       1'b0;
    rst_n       <=      1'b0;
    wr_trig     <=      1'b0;
    rd_trig     <=      1'b0;
    #(100*`CLOCK);
    rst_n       <=      1'b1;
    #(250_000)

    wr_trig     <=      1'b1;
    #(`CLOCK)
    wr_trig     <=      1'b0;
    #(20_000)
    rd_trig     <=      1'b1;
    #(`CLOCK)
    rd_trig     <=      1'b0;
    #(20_000);

    wr_trig     <=      1'b1;
    #(`CLOCK)
    wr_trig     <=      1'b0;
    #(20_000);
    rd_trig     <=      1'b1;
    #(`CLOCK)
    rd_trig     <=      1'b0;
    #(20_000);
      
    $stop;
end
always  #(`CLOCK/2)     sclk        =       ~sclk;  

sdram_top sdram_top_inst(
    //System Interfaces
    .sclk                   (sclk                   ),
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
    //Others
    .wr_trig                (wr_trig                ),
    .rd_trig                (rd_trig                )
);

defparam        sdram_model_plus_inst.addr_bits =       12;
defparam        sdram_model_plus_inst.data_bits =       16;
defparam        sdram_model_plus_inst.col_bits  =       9;
defparam        sdram_model_plus_inst.mem_sizes =       2*1024*1024;            // 2M

sdram_model_plus sdram_model_plus_inst(
    .Dq                     (sdram_dq               ), 
    .Addr                   (sdram_addr             ), 
    .Ba                     (sdram_bank             ), 
    .Clk                    (sdram_clk              ), 
    .Cke                    (sdram_cke              ), 
    .Cs_n                   (sdram_cs_n             ), 
    .Ras_n                  (sdram_ras_n            ), 
    .Cas_n                  (sdram_cas_n            ), 
    .We_n                   (sdram_we_n             ), 
    .Dqm                    (sdram_dqm              ),
    .Debug                  (1'b1                   )
);

endmodule
