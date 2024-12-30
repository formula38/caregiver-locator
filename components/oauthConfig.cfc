component {
    this.oauthProvider = "Google"; // Name of provider
    this.clientId = "your-google-client-id";
    this.clientSecret = "your-google-client-secret";
    this.redirectUri = "http://127.0.0.1:8500/oauth/callback";
    this.authorizationEndpoint = "https://accounts.google.com/o/oauth2/v2/auth";
    this.tokenEndpoint = "https://oauth2.googleapis.com/token";
    this.userInfoEndpoint = "https://openidconnect.googleapis.com/v1/userinfo";
}
