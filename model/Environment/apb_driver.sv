class apb_driver extends uvm_driver#(apb_transaction);

    // Virtual interface
    virtual apb_interface vif;

    // UVM factory registration
    `uvm_component_utils(apb_driver)

    // Constructor
    function new(string name = "apb_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Build phase: get virtual interface
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual apb_interface)::get(this, "", "vif", vif)) begin
            `uvm_fatal("DRV", "Virtual interface not found")
        end
    endfunction

    // Run phase: drive transactions
    virtual task run_phase(uvm_phase phase);
        // Small delay to ensure monitor is ready
        #1ns;

        forever begin
            seq_item_port.get_next_item(req);
            drive_transaction(req);
            seq_item_port.item_done();
        end
    endtask

    // Drive transaction to APB signals
    virtual task drive_transaction(apb_transaction tr);
        // Setup phase
        vif.drv_cb.PSEL <= 1'b1;
        vif.drv_cb.PENABLE <= 1'b0;
        vif.drv_cb.PWRITE <= tr.write;
        vif.drv_cb.PADDR <= tr.addr;
        if (tr.write) begin
            vif.drv_cb.PWDATA <= tr.data;
        end
        @(vif.drv_cb);

        // Access phase
        vif.drv_cb.PENABLE <= 1'b1;
        @(vif.drv_cb);

        // Complete transfer
        vif.drv_cb.PSEL <= 1'b0;
        vif.drv_cb.PENABLE <= 1'b0;

        // Log appropriate message based on operation type
        if (tr.write) begin
            `uvm_info("DRIVER", $sformatf("Driving APB Write: addr=0x%h, data=0x%h",
                tr.addr, tr.data), UVM_MEDIUM)
        end else begin
            `uvm_info("DRIVER", $sformatf("Driving APB Read: addr=0x%h", tr.addr), UVM_MEDIUM)
        end
    endtask

endclass