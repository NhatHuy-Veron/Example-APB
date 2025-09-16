class apb_sequence extends uvm_sequence#(apb_transaction);

    // UVM factory registration
    `uvm_object_utils(apb_sequence)

    // Constructor
    function new(string name = "apb_sequence");
        super.new(name);
    endfunction

    // Body task: generate 20 random transactions
    virtual task body();
        apb_transaction tr;
        repeat (20) begin
            tr = apb_transaction::type_id::create("tr");
            start_item(tr);
            if (!tr.randomize()) begin
                `uvm_error("SEQ", "Failed to randomize transaction")
            end
            finish_item(tr);
        end
    endtask

endclass