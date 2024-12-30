<cfscript>
    // Include the OAuth configuration
    config = createObject("component", "components.oauthConfig");

    // Construct the authorization URL
    authorizationUrl = config.authorizationEndpoint & "?" & toQueryString({
        client_id = config.clientId,
        redirect_uri = config.redirectUri,
        response_type = "code",
        scope = "openid email profile"
    });

    // Redirect user to the OAuth provider
    location(authorizationUrl);
</cfscript>
