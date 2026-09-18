<cfscript>
    param name="url.reporter" default="simple";
    if (url.reporter == "json") {
        cfcontent(type = "application/json; charset=utf-8", reset = true);
    }
    testbox = new testbox.system.TestBox(directory = "tests.specs");
    writeOutput(testbox.run(reporter = url.reporter));
</cfscript>
