class apb_monitor extends uvm_monitor;

    // Virtual interface
    virtual apb_interface vif;

    // Analysis port
    uvm_analysis_port#(apb_transaction) ap;

    // UVM factory registration
    `uvm_component_utils(apb_monitor)

    // Constructor
    function new(string name = "apb_monitor", uvm_component parent = null);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    // Build phase: get virtual interface
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual apb_interface)::get(this, "", "vif", vif)) begin
            `uvm_fatal("MON", "Virtual interface not found")
        end
    endfunction

    // Run phase: monitor APB interface
    virtual task run_phase(uvm_phase phase);
        apb_transaction tr;
        forever begin
            // Wait for any APB activity - either setup or access phase
            @(vif.mon_cb);

            // Check for valid APB transfer (setup or access phase)
            if (vif.mon_cb.PSEL) begin
                // If this is setup phase (PENABLE=0), wait for access phase
                if (!vif.mon_cb.PENABLE) begin
                    @(vif.mon_cb);
                    // Ensure we're still in transfer and now in access phase
                    if (vif.mon_cb.PSEL && vif.mon_cb.PENABLE) begin
                        capture_transaction();
                    end
                end
                // If already in access phase, capture immediately
                else if (vif.mon_cb.PENABLE) begin
                    capture_transaction();
                end
            end
        end
    endtask

    // Task to capture transaction details
    virtual task capture_transaction();
        apb_transaction tr;
        tr = apb_transaction::type_id::create("tr");
        tr.addr = vif.mon_cb.PADDR;
        tr.write = vif.mon_cb.PWRITE;
        if (tr.write) begin
            tr.data = vif.mon_cb.PWDATA;
            `uvm_info("MONITOR", $sformatf("Detected APB Write: addr=0x%h, data=0x%h",
                tr.addr, tr.data), UVM_MEDIUM)
        end else begin
            tr.data = vif.mon_cb.PRDATA;
            `uvm_info("MONITOR", $sformatf("Detected APB Read: addr=0x%h, data=0x%h",
                tr.addr, tr.data), UVM_MEDIUM)
        end
        ap.write(tr);
    endtask

endclass