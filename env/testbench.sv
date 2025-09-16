`include "uvm_macros.svh"
import uvm_pkg::*;
import apb_pkg::*;

// Timescale directive
`timescale 1ns/1ps

module testbench;

    // Clock and reset signals
    logic PCLK;
    logic PRESETn;

    // APB interface
    apb_interface apb_if(PCLK);

    // DUT instantiation
    apb_slave dut (
        .PCLK(apb_if.PCLK),
        .PRESETn(apb_if.PRESETn),
        .PSEL(apb_if.PSEL),
        .PENABLE(apb_if.PENABLE),
        .PWRITE(apb_if.PWRITE),
        .PADDR(apb_if.PADDR),
        .PWDATA(apb_if.PWDATA),
        .PRDATA(apb_if.PRDATA)
    );

    // Clock generation (10ns period = 100MHz)
    initial begin
        PCLK = 0;
        forever #5ns PCLK = ~PCLK;
    end

    // Reset generation (active low for first 25ns)
    initial begin
        PRESETn = 0;
        #25ns PRESETn = 1;
    end

    // Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars;  // Full dump instead of selective for VCS compatibility
    end

    // UVM test execution
    initial begin
        // Set virtual interface in config_db (global scope)
        uvm_config_db#(virtual apb_interface)::set(uvm_root::get(), "*", "vif", apb_if);

        // Run the test
        run_test("apb_test");
    end

endmodule