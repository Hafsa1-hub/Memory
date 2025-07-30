////////////////////////////////////////////////////////////////////////////////////////////////////////
//                         AXI MASTER 


// ---------------         Global signal    -------------------------------------------------------------//	
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// ACLK         -> Signals are sampled on the rising edge of the global clock.                        //
// ARESETn      -> Reset signal is active LOW                                                         //
// /////////////////////////////////////////////////////////////////////////////////////////////////////

//------------------------ Write address channel signals ----------------------------------------------//

/////////////////////////////////////////////////////////////////////////////////////////////////////////
// AWID[3:0]    -> This signal is the identification tag for the write address group of                //
// AWADDR[31:0] -> The write address bus gives the address of the first transfer in a write burst      //
// AWLEN[3:0]   -> Master Burst length. The burst length gives the exact number of transfers in a burst//
// AWSIZE[2:0]  -> Master Burst size. This signal indicates the size of each transfer                  //
// AWBURST[1:0] -> Master Burst type. => FIXED, INCE, WRAP                                             //
// AWVALID      -> Master Write address valid.                                                         //
// AWREADY      -> ITS SLAVE SIGNAL  .                                                                 //
// //////////////////////////////////////////////////////////////////////////////////////////////////////

//-------------------------Write data channel signals-------------------------------------------//

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// WID[3:0]     -> Master Write ID tag.                                                                //
// WDATA[31:0]  -> Master Write data                                                                   //
// WSTRB[3:0]   -> Master Write strobes.                                                               //
// WLAST        -> Master Write last.                                                                  //
// WVALID       -> Master Write valid.                                                                 //
// WREADY       -> Slave Write ready                                                                   //
// /////////////////////////////////////////////////////////////////////////////////////////////////////
//
//-------------------------Write response channel signals-------------------------------//

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// BID[3:0]     -> Slave Response ID.                                                                  //
// BRESP[1:0]   -> Slave Write response.                                                               //
// BVALID       -> Slave Write response valid.                                                         //
// BREADY       -> Master Response ready.                                                              //
// /////////////////////////////////////////////////////////////////////////////////////////////////////

////---------------------- AXI read address channel signals.------------------------------------------//

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// ARID[3:0]    -> Master Read address ID                                                              // 
// ARADDR[31:0] -> Master Read address. .                                                              //
// ARLEN[3:0]   -> Master Burst length.                                                                //
// ARSIZE[2:0]  -> Master Burst size.                                                                  //
// ARBURST[1:0] -> Master Burst type.                                                                  // 
// ARVALID      -> Master Read address                                                                 //
// ARREADY,     -> SLAVE is high.                                                                            //
// /////////////////////////////////////////////////////////////////////////////////////////////////////

//-------------------------Read data channel signals -------------------------------------------------//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// RID[3:0]     -> Slave Read ID tag.                                                                  //
// RDATA[31:0]  -> Slave Read data.                                                                    //
// RRESP[1:0]   -> Slave Read response.OKAY, EXOKAY, SLVERR, and DECERR.                               //
// RLAST        -> Slave Read last.                                                                    //
// RVALID       -> Slave Read valid.                                                                   //
// RREADY       -> Master is ready                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//--------------------------------------------------------------------------------------------------------//
module axi_slave 
//-----global signal-----------------//
  input aclk_i         ,
  input areset_i       ,
  //-WRITE ADDRESS CHANNEL-----------//
  input awid    [3:0]  ,    
  input awaddr  [31:0] , 
  input awlen   [3:0]  ,
  input awsize  [2:0]  ,
  input awburst [1:0]  ,
  input awvalid        ,
  output reg awready   ,
  
  //-WRITE DATA CHANNEL--------------//
  input wid     [3:0]  ,
  input wdata   [31:0] ,
  input wstrb   [3:0]  ,
  input wlast          ,
  input wvalid         ,
  input wready         ,

  // WRITE RESPONSE CHANNEL----------//
  input bid     [3:0]  ,    
  input bresp   [1:0]  ,
  input bvalid         ,
  input bready         ,
  ///READ ADDRESS CHANNEL  ----------//
  input arid    [3:0 ] ,
  input araddr  [31:0] ,
  input arlen   [3:0 ] ,
  input arsize  [2:0 ] ,
  input arburst [1:0 ] ,
  input arvalid        ,
  input arready        ,
  // READ DATA CHANNEL---------------//
  input rid     [3:0 ] ,
  input rdata   [31:0] ,
  input rresp   [1:0 ] ,
  input rlast          ,
  input rvalid         ,
  input rready         ,
  //---------------------------------//









//--------SLAVE signal----------------//
  output reg       aw_ready_o,
  output reg       wready_o,
  output reg [3:0] bid_o,
  output reg [1:0] bresp,
  output reg       bvalid,
  output reg       arready
  output reg       rid_o,
  output reg [1:0] rresp,
  output reg       rvalid,
  output reg [31:0]rdata_o,
  output reg       rlast,

 AWREADY 
 WREADY
  BID[3:0]  
  BRESP[1:0]
  BVALID
  ARREADY,o/p
   RID[3:0]    
   RDATA[31:0] 
   RRESP[1:0]  
   RLAST       
   RVALID      

