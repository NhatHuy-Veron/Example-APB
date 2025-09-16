class apb_test extends uvm_test;

    // Environment handle
    apb_environment env;

    // UVM factory registration
    `uvm_component_utils(apb_test)

    // Constructor
    function new(string name = "apb_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Build phase: create environment and set config
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = apb_environment::type_id::create("env", this);
        // Virtual interface will be set from testbench
    endfunction

    // Run phase: execute test
    virtual task run_phase(uvm_phase phase);
        apb_sequence seq;
        phase.raise_objection(this);
        seq = apb_sequence::type_id::create("seq");
        seq.start(env.agt.seqr);
        phase.drop_objection(this);
    endtask

endclass