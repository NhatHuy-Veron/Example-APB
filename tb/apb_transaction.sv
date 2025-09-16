class apb_transaction extends uvm_sequence_item;

    // Randomizable fields
    rand bit [7:0]  addr;
    rand bit [31:0] data;
    rand bit        write;

    // UVM factory registration
    `uvm_object_utils(apb_transaction)

    // Constructor
    function new(string name = "apb_transaction");
        super.new(name);
    endfunction

    // Optional constraints for realistic ranges
    constraint addr_range { addr inside {[8'h00 : 8'hFF]}; }
    constraint data_range { data inside {[32'h00000000 : 32'hFFFFFFFF]}; }

endclass