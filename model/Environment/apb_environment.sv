class apb_environment extends uvm_env;

    // Agent handle
    apb_agent agt;

    // UVM factory registration
    `uvm_component_utils(apb_environment)

    // Constructor
    function new(string name = "apb_environment", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Build phase: create agent
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt = apb_agent::type_id::create("agt", this);
    endfunction

endclass