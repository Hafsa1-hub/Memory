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
// ARREADY,     -> SLAVE is high.                                                                      //
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

//-----------------------------------------------------------------------------------------------------//

//-----------------------------------------------------------------------------------------------------//
class traffic_generator;

  //----------------------------//
  rand reg     [ 3:0] awid_i;
  rand reg     [31:0] awaddr_i;
  rand reg     [ 3:0] awlen_i;
  rand reg     [ 2:0] awsize_i;
  rand reg     [ 1:0] awburst_i;
  rand reg            awvalid_i;

  //----------------------------//
  rand reg     [ 3:0] wid_i;
  rand reg     [31:0] wdata_i;
  rand reg     [ 3:0] wstrb_i;
  rand reg            wlast_i;
  rand reg            wvalid_i;

  //----------------------------//
  rand reg            bready_i;

  //----------------------------//
  rand reg     [ 3:0] arid_i;
  rand reg     [31:0] araddr_i;
  rand reg     [ 3:0] arlen_i;
  rand reg     [ 2:0] arsize_i;
  rand reg     [ 1:0] arburst_i;
  rand reg            arvalid_i;

  //----------------------------//
  rand reg            rready_i;

  //----------------------------//
  rand reg     [ 3:0] rid_o;
  rand reg     [31:0] rdata_o;
  rand reg     [ 1:0] rresp_o;
  rand reg            rlast_o;
  rand reg            rvalid_o;

  //----------------------------//
  int unsigned        data_count;  // used in constraint

  //-------------------------- Write Address Channel --------------------------//
  constraint write_address_channel_c {
    awlen_i inside {[0 : 15]};
    awsize_i inside {3'b001};  // size = 2 bytes
    awvalid_i == 1;
    awburst_i == 2'b01;  //Incr
    awaddr_i inside {32'h2, 32'h4, 32'h8};  // aligned address values
  }

  //-------------------------- Write Data Channel -----------------------------//
  constraint write_data_channel_c {
    wid_i inside {[1 : 3]};
    wvalid_i == 1;
    wlast_i == ((data_count == awlen_i) ? 1 : 0);
    awsize_i inside {3'b000};  // size = 1 byte
    wstrb_i == (1 << (1 << awsize_i)) - 1;
  }

  //-------------------------- Write Response Channel --------------------------//
  constraint write_response_channel_c {bready_i == 1;}

  //-------------------------- Read Address Channel ----------------------------//
  constraint read_address_channel_c {
    araddr_i inside {32'h2, 32'h4, 32'h8};
    arid_i inside {[1 : 3]};
    arlen_i inside {3};
    arsize_i inside {3'b000};
    arburst_i == 2'b01;  // INCR burst
    arvalid_i == 1;
  }

  //-------------------------- Read Data Channel ------------------------------//
  constraint read_data_channel_c {rready_i == 1;}

endclass


//---------------------------------------------------------------------------------------------------------------------//
module axi_master (
    //-----global signal-----------------//
    output reg        aclk_o,
    output reg        areset_o,
    //-WRITE ADDRESS CHANNEL-----------//
    output reg [ 3:0] awid_o,
    output reg [31:0] awaddr_o,
    output reg [ 3:0] awlen_o,
    output reg [ 2:0] awsize_o,
    output reg [ 1:0] awburst_o,
    output reg        awvalid_o,
    input             awready_i,
    //-WRITE DATA CHANNEL--------------//
    output reg [ 3:0] wid_o,
    output reg [31:0] wdata_o,
    output reg [ 3:0] wstrb_o,
    output reg        wlast_o,
    output reg        wvalid_o,
    input             wready_i,

    // WRITE RESPONSE CHANNEL----------//
    input      [3:0] bid_i,
    input      [1:0] bresp_i,
    input            bvalid_i,
    output reg       bready_o,

    ///READ ADDRESS CHANNEL  ----------//
    output reg [ 3:0] arid_o,
    output reg [31:0] araddr_o,
    output reg [ 3:0] arlen_o,
    output reg [ 2:0] arsize_o,
    output reg [ 1:0] arburst_o,
    output reg        arvalid_o,
    input             arready_i,
    // READ DATA CHANNEL---------------//
    input      [ 3:0] rid_i,
    input      [31:0] rdata_i,
    input      [ 1:0] rresp_i,
    input             rlast_i,
    input             rvalid_i,
    output reg        rready_o
);
  //write_data_transfer txn;
  //-----------------Clock Genaration -------------
  int data_count;
  traffic_generator tg;
  
  initial begin
    aclk_o = 0;
    tg = new();
    data_count = 0;
  end

  always begin
    #5 aclk_o = (~aclk_o);
  end
  //-----------------------------------------------
  always @(posedge aclk_o) begin
      if(areset_o==0 ) begin 
         awid_o    <= 'dx;  
         awaddr_o  <= 'dx;
         awlen_o   <= 'dx;
         awsize_o  <= 'dx;
         awburst_o <= 'dx;
         awvalid_o <= 'dx;
         wid_o     <= 'dx;
         wdata_o   <= 'dx;
         wstrb_o   <= 'dx;
         wlast_o   <= 'dx;
         wvalid_o  <= 'dx;
         arid_o    <= 'dx;
         araddr_o  <= 'dx;
         arlen_o   <= 'dx;
         arsize_o  <= 'dx;
         arburst_o <= 'dx;
         arvalid_o <= 'dx;
         bready_o  <= 'dX;
         rready_o  <= 'dx;
      end
      else begin
    //------------------address channel---------------//
      if (tg.randomize()) begin
      $display("Randomizion for 1st ");
      if (awready_i) begin
        $strobe("Slave is ready to accept the address from write address channel");
        awid_o    <=  tg.awid_i   ;
        awaddr_o  <=  tg.awaddr_i ;
        awlen_o   <=  tg.awlen_i  ;
        awsize_o  <=  tg.awsize_i ;
        awburst_o <=  tg.awburst_i;
        awvalid_o <=  tg.awvalid_i;
      end
      if (wready_i) begin
        tg.write_address_channel_c.constraint_mode(0);
        wid_o    <= tg.wid_i;
        wdata_o  <= tg.wdata_i;
        wstrb_o  <= tg.wstrb_i;
        wlast_o  <= tg.wlast_i;
        wvalid_o <= tg.wvalid_i;
       $strobe("Slave is ready to accept the data from write data channel");
       data_count <= 0;
       tg.write_address_channel_c.constraint_mode(0);  // transfer all complete transcati
       for (data_count = 0; data_count <= awlen_o; data_count++) begin
        //   $display("awaddr_i = %d, wvalid_i = %0d, wstrb_i = %b", tg.awaddr_i, tg.wvalid_i,
        //           tg.wstrb_i);
        data_count <= data_count + 1;
        @(posedge aclk_o) data_count <= data_count + 1;
      end
    end
    bready_o <= 1;
    $strobe("The write Data response for the data is\t BID :: %d\t  bresp::%d\t  bavalid_i :: %d\t",
            bid_i, bresp_i, bvalid_i);
  //end
  //--------------READ Data OPERATION--------------------------------------//
    if (arready_i) begin
        arid_o    <= tg.arid_i;
        araddr_o  <= tg.araddr_i;
        arlen_o   <= tg.arlen_i;
        arsize_o  <= tg.arsize_i;
        arburst_o <= tg.arburst_i;
        arvalid_o <= tg.arvalid_i;
    end
    if (rready_o) begin // Read address
$stobe("the received address response for\n::id is%d\t data is %d\t resp ::%d\t lst_i
                  ::%d\t rvalid ::%d\t",rid_i ,rdata_i, rresp_i,rlast_i,rvalid_i);
    end
    else begin
        $strobe("response is not yet received");
    end
  end
end
end
    
   endmodule












