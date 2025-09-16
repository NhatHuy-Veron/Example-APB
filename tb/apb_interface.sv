interface apb_interface(input logic PCLK);

    // APB signals
    logic        PRESETn;
    logic        PSEL;
    logic        PENABLE;
    logic        PWRITE;
    logic [7:0]  PADDR;
    logic [31:0] PWDATA;
    logic [31:0] PRDATA;

    // Clocking block for driver (drives signals on posedge PCLK)
    clocking drv_cb @(posedge PCLK);
        output PSEL, PENABLE, PWRITE, PADDR, PWDATA;
        input  PRDATA;
    endclocking

    // Clocking block for monitor (samples signals on posedge PCLK)
    clocking mon_cb @(posedge PCLK);
        input PSEL, PENABLE, PWRITE, PADDR, PWDATA, PRDATA;
    endclocking

    // Modport for driver
    modport DRIVER(clocking drv_cb, output PRESETn);

    // Modport for monitor
    modport MONITOR(clocking mon_cb, input PRESETn);

endinterface