<cfscript>
    // Include the OAuth configuration
    config = createObject("component", "components.oauthConfig");

    // Retrieve the authorization code from the query string
    if (!structKeyExists(url, "code")) {
        writeOutput("Authorization code not found");
        abort;
    }
    authorizationCode = url.code;

    // Exchange the authorization code for an access token
    tokenResponse = http(method="post", url=config.tokenEndpoint, charset="utf-8", formFields={
        code = authorizationCode,
        client_id = config.clientId,
        client_secret = config.clientSecret,
        redirect_uri = config.redirectUri,
        grant_type = "authorization_code"
    });

    // Parse the token response
    tokenData = deserializeJson(tokenResponse.filecontent);

    // Retrieve user info from the access token
    userInfoResponse = http(method="get", url=config.userInfoEndpoint, headers={
        "Authorization": "Bearer " & tokenData.access_token
    });

    userInfo = deserializeJson(userInfoResponse.filecontent);

    // Display user info (or handle login)
    writeDump(userInfo);
    session.user = userInfo;
    writeOutput("<p>Welcome, " & userInfo.name & " (" & userInfo.email & ")!</p>");
</cfscript>
