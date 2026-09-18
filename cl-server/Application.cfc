component {

    this.name = "CaregiverLocator";
    this.sessionManagement = false;
    this.setClientCookies = false;
    this.scriptProtect = "all";
    this.secureJSON = false;
    this.serialization.preserveCaseForStructKey = true;
    this.mappings["/jwtcfml"] = expandPath("/jwtcfml");
    this.mappings["/testbox"] = expandPath("/testbox");
    this.javaSettings = {
        loadPaths: [expandPath("/lib")],
        loadColdFusionClassPath: true,
        reloadOnChange: false
    };

    variables.bootSettings = new config.Settings();
    this.datasources[variables.bootSettings.datasourceName()] = {
        class: "org.postgresql.Driver",
        connectionString: "jdbc:postgresql://"
            & variables.bootSettings.dbHost()
            & ":"
            & variables.bootSettings.dbPort()
            & "/"
            & variables.bootSettings.dbName(),
        username: variables.bootSettings.dbUser(),
        password: variables.bootSettings.dbPassword()
    };
    this.datasource = variables.bootSettings.datasourceName();

    public void function onApplicationStart() {
        application.settings = new config.Settings();
        application.datasourceName = application.settings.datasourceName();
        if (application.settings.seedDemoData()) {
            new services.SeedService().ensureDemoData();
        }
    }

    public boolean function onRequestStart(required string targetPage) {
        if (!structKeyExists(application, "settings")) {
            onApplicationStart();
        }
        applyCors();
        if (cgi.request_method == "OPTIONS") {
            cfheader(statuscode = 204, statustext = "No Content");
            abort;
        }
        return true;
    }

    public void function onError(required any exception, required string eventName) {
        var settings = structKeyExists(application, "settings") ? application.settings : new config.Settings();
        writeLog(file = "application", text = "Unhandled error: " & exception.message);
        cfheader(statuscode = 500, statustext = "Server Error");
        cfcontent(type = "application/json", reset = true);
        var payload = { "ok": false, "error": "Internal server error" };
        if (settings.isDevelopment()) {
            payload["detail"] = exception.message;
        }
        writeOutput(serializeJSON(payload));
        abort;
    }

    private void function applyCors() {
        var origin = "";
        var headers = getHTTPRequestData(false).headers;
        for (var key in headers) {
            if (lCase(key) == "origin") {
                origin = headers[key];
                break;
            }
        }
        var allowed = application.settings.corsOrigins();
        if (len(origin) && arrayFindNoCase(allowed, origin)) {
            cfheader(name = "Access-Control-Allow-Origin", value = origin);
            cfheader(name = "Vary", value = "Origin");
        }
        cfheader(name = "Access-Control-Allow-Headers", value = "Authorization, Content-Type");
        cfheader(name = "Access-Control-Allow-Methods", value = "GET, POST, PUT, PATCH, DELETE, OPTIONS");
    }

}
