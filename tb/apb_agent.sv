class apb_agent extends uvm_agent;

    // Component handles
    apb_driver    drv;
    apb_monitor   mon;
    apb_sequencer seqr;

    // Virtual interface
    virtual apb_interface vif;

    // UVM factory registration
    `uvm_component_utils(apb_agent)

    // Constructor
    function new(string name = "apb_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Build phase: create components
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Get virtual interface from global scope
        if (!uvm_config_db#(virtual apb_interface)::get(uvm_root::get(), "*", "vif", vif)) begin
            `uvm_fatal("AGT", "Virtual interface not found")
        end

        // Create components
        if (is_active == UVM_ACTIVE) begin
            drv = apb_driver::type_id::create("drv", this);
            seqr = apb_sequencer::type_id::create("seqr", this);
        end
        mon = apb_monitor::type_id::create("mon", this);

        // Pass vif to sub-components
        if (is_active == UVM_ACTIVE) begin
            uvm_config_db#(virtual apb_interface)::set(this, "drv", "vif", vif);
        end
        uvm_config_db#(virtual apb_interface)::set(this, "mon", "vif", vif);
    endfunction

    // Connect phase: connect TLM ports
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (is_active == UVM_ACTIVE) begin
            drv.seq_item_port.connect(seqr.seq_item_export);
        end
    endfunction

endclass