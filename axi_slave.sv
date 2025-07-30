////////////////////////////////////////////////////////////////////////////////////////////////////////

// ---------------         Global signal    -------------------------------------------------------------//
// /////////////////////////////////////////////////////////////////////////////////////////////////////////
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
//
//
//
////--------------------------------------------------------------------------------------------------------//
module axi_slave (
    //-----global signal-----------------//
    input             aclk_i,
    input             areset_i,
    //-WRITE ADDRESS CHANNEL-----------//
    input      [ 3:0] awid_i,
    input      [31:0] awaddr_i,
    input      [ 3:0] awlen_i,
    input      [ 2:0] awsize_i,
    input      [ 1:0] awburst_i,
    input             awvalid_i,
    output reg        awready_o,
    //-WRITE DATA CHANNEL--------------//
    input      [ 3:0] wid_i,
    input      [31:0] wdata_i,
    input      [ 3:0] wstrb_i,
    input             wlast_i,
    input             wvalid_i,
    output reg        wready_o,

    // WRITE RESPONSE CHANNEL----------//
    output reg [3:0] bid_o,
    output reg [1:0] bresp_o,
    output reg       bvalid_o,
    input            bready_i,

    ///READ ADDRESS CHANNEL  ----------//
    input      [ 3:0] arid_i,
    input      [31:0] araddr_i,
    input      [ 3:0] arlen_i,
    input      [ 2:0] arsize_i,
    input      [ 1:0] arburst_i,
    input             arvalid_i,
    output reg        arready_o,
    // READ DATA CHANNEL---------------//
    output reg [ 3:0] rid_o,
    output reg [31:0] rdata_o,
    output reg [ 1:0] rresp_o,
    output reg        rlast_o,
    output reg        rvalid_o,
    input             rready_i
);
  //---------------------------------//
  //---------- MEMORY OF RAM-----------//
  //int memory[8];
  reg [31:0][31:0] slave_memory      [4];
  reg [31:0][31:0] address_collection[4];
  reg [31:0][31:0] data_collection   [4];

  //-----------collecting the data into temp data_collection memory----------//
  //-----------collecting the addres into temp address_collection memory----------//
  always @(posedge aclk_i) begin
    if (!areset_i) begin
      awready_o <= 'dx;
      wready_o  <= 'dx;
      bid_o     <= 'dx;
      bresp_o   <= 'dx;
      bvalid_o  <= 'dx;
      arready_o <= 'dx;
      rid_o     <= 'dx;
      rdata_o   <= 'dx;
      rresp_o   <= 'dx;
      rlast_o   <= 'dx;
      rvalid_o  <= 'dx;
    end 
    else if (awvalid_i) begin
      if (awid_i == 0) begin
        id_addr_count0++;
        address_collection[0][id_addr_count0] <= awaddr_i;
      end else if (awid_i == 1) begin
        id_addr_count1++;
        address_collection[1][id_addr_count1] <= awaddr_i;
      end else if (awid_i == 2) begin
        id_addr_count2++;
        address_collection[2][id_addr_count2] <= awaddr_i;
      end else if (awid_i == 3) begin
        id_addr_count3++;
        address_collection[3][id_addr_count3] <= awaddr_i;
      end
    end

    else if (wvalid_i) begin
      if (wid_i == 0) begin
        id_data_count0++;
        data_collection[0][id_data_count0] <= wdata_i;
      end else if (wid_i == 1) begin
        id_data_count1++;
        data_collection[1][id_data_count1] <= wdata_i;
      end else if (wid_i == 2) begin
        id_data_count2++;
        data_collection[2][id_data_count2] <= wdata_i;
      end else if (wid_i == 3) begin
        id_data_count3++;
        data_collection[3][id_data_count3] <= wdata_i;
      end
      if(wvalid_i ) begin
         case (wid_i)

always @(posedge aclk_i) begin
  if (!areset_i) begin
    awready_o <= 'dx;
    wready_o  <= 'dx;
    bid_o     <= 'dx;
    bresp_o   <= 'dx;
    bvalid_o  <= 'dx;
    arready_o <= 'dx;
    rid_o     <= 'dx;
    rdata_o   <= 'dx;
    rresp_o   <= 'dx;
    rlast_o   <= 'dx;
    rvalid_o  <= 'dx;
  end 
  else begin
    if (awvalid_i) begin
      case (awid_i)
        2'd0: begin
          id_addr_count0++;
          address_collection[0][id_addr_count0] <= awaddr_i;
        end
        2'd1: begin
          id_addr_count1++;
          address_collection[1][id_addr_count1] <= awaddr_i;
        end
        2'd2: begin
          id_addr_count2++;
          address_collection[2][id_addr_count2] <= awaddr_i;
        end
        2'd3: begin
          id_addr_count3++;
          address_collection[3][id_addr_count3] <= awaddr_i;
        end
en
      endcase
    end

    if (wvalid_i) begin
      case (wid_i)
        2'd0: begin
          id_data_count0++;
          data_collection[0][id_data_count0] <= wdata_i;
          address = address_collection[0][id_data_count0];
          if (address != ~32'd0) begin
            slave_memory[0][address] <= data_collection[0][id_data_count0];
          end else begin
            $display("Address not yet received for ID 0");
          end
        end
        2'd1: begin
          id_data_count1++;
          data_collection[1][id_data_count1] <= wdata_i;
          address = address_collection[1][id_data_count1];
          if (address != ~32'd0) begin
            slave_memory[1][address] <= data_collection[1][id_data_count1];
          end else begin
            $display("Address not yet received for ID 1");
          end
        end

        2'd2: begin
          id_data_count2++;
          data_collection[2][id_data_count2] <= wdata_i;
          address = address_collection[2][id_data_count2];
          if (address != ~32'd0) begin
            slave_memory[2][address] <= data_collection[2][id_data_count2];
          end else begin
            $display("Address not yet received for ID 2");
          end
        end

        2'd3: begin
          id_data_count3++;
          data_collection[3][id_data_count3] <= wdata_i;
          address = address_collection[3][id_data_count3];
          if (address != ~32'd0) begin
            slave_memory[3][address] <= data_collection[3][id_data_count3];
          end else begin
            $display("Address not yet received for ID 3");
          end
        end
        2'd4: begin
          id_data_count4++;
          data_collection[4][id_data_count4] <= wdata_i;
          address = address_collection[4][id_data_count4];
          if (address != ~32'd0) begin
            slave_memory[4][address] <= data_collection[4][id_data_count4];
          end else begin
            $display("Address not yet received for ID 4");
          end
        end
        2'd5: begin
          id_data_count5++;
          data_collection[5][id_data_count5] <= wdata_i;
          address = address_collection[5][id_data_count5];
          if (address != ~32'd0) begin
            slave_memory[5][address] <= data_collection[5][id_data_count5];
          end else begin
            $display("Address not yet received for ID 3");
          end
        end
       endcase
    end
  end
  end
endmodule
