<cfscript>
    setting showdebugoutput="false";
    cfcontent(type = "application/json; charset=utf-8", reset = true);

    httpRequest = getHTTPRequestData(true);
    body = {};
    rawContent = "";
    if (structKeyExists(httpRequest, "content") && !isNull(httpRequest.content) && len(httpRequest.content)) {
        rawContent = toString(httpRequest.content);
    }
    if (len(trim(rawContent))) {
        try {
            body = deserializeJSON(rawContent);
        } catch (any e) {
            cfheader(statuscode = 400, statustext = "Bad Request");
            writeOutput(serializeJSON({ "ok": false, "error": "Request body must be JSON" }));
            abort;
        }
    }

    result = new config.Router().handle(
        method = cgi.request_method,
        path = requestPath(),
        headers = structKeyExists(httpRequest, "headers") ? httpRequest.headers : {},
        body = isStruct(body) ? body : {},
        queryString = url
    );

    cfheader(statuscode = result.status, statustext = statusText(result.status));
    writeOutput(serializeJSON(result.body));
    abort;

    function requestPath() {
        var uri = "";
        if (structKeyExists(cgi, "path_info") && len(cgi.path_info) && cgi.path_info != "/index.cfm") {
            uri = cgi.path_info;
        } else if (structKeyExists(cgi, "request_uri") && len(cgi.request_uri)) {
            uri = listFirst(cgi.request_uri, "?");
        } else {
            uri = cgi.script_name;
        }
        uri = reReplace(uri, "^/index\.cfm", "");
        if (!len(uri)) {
            uri = "/";
        }
        return uri;
    }

    function statusText(required numeric code) {
        switch (code) {
            case 200: return "OK";
            case 201: return "Created";
            case 204: return "No Content";
            case 400: return "Bad Request";
            case 401: return "Unauthorized";
            case 403: return "Forbidden";
            case 404: return "Not Found";
            case 409: return "Conflict";
            case 422: return "Unprocessable Entity";
            default: return "Error";
        }
    }
</cfscript>
