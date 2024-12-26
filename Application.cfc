component {
    this.name = "CaregiverLocatorApp";
    this.datasource = "caregiverDS";
    this.ormenabled = true;
    this.ormsettings = {
        dbCreate = "create",
        cfclocation = "/components",
        dialect = "PostgreSQLDialect"
    };

    this.sessionmanagement = true;
    this.sessiontimeout = createTimespan(0, 1, 0, 0);

    // Java Integration
    this.javaSettings = {
        loadPaths = [expandPath("./java")],
        watchInterval = 60,
        dynamicLoading = true
    };

    // OnApplicationStart method for initialization
    function onApplicationStart() {
        // Logic for initialization application
        application.voucherService = createObject("java", "VoucherService").init();
    }
}
