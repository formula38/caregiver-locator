component {
    this.name = "ChildcareLocatorApp";
    this.datasource = "childcareDS";
    this.sessionmanagement = true;
    this.sessiontimeout = createTimespan(0, 1, 0, 0);

    // Java Integration
    this.javaSettings = {
        loadPaths = ["/java"],
        watchInterval = 60,
        dynamicLoading = true
    };

    // OnApplicationStart method for initialization
    function onApplicationStart() {
        // Logic for initialization application
        application.voucherService = createObject("java", "VoucherService").init();
    }
}