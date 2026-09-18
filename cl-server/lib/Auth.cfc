component {

    public any function init() {
        variables.settings = new config.Settings();
        variables.jwt = createJwt();
        return this;
    }

    public string function issue(required struct user) {
        var nowUnix = dateDiff("s", createDateTime(1970, 1, 1, 0, 0, 0), now());
        var payload = {
            "sub": toString(user.id),
            "email": user.email,
            "role": user.role,
            "iss": variables.settings.jwtIssuer(),
            "iat": nowUnix,
            "exp": nowUnix + variables.settings.jwtTtlSeconds()
        };
        return variables.jwt.encode(payload, variables.settings.jwtSecret(), "HS256");
    }

    public struct function requireUser(required struct headers) {
        var token = bearerToken(headers);
        if (!len(token)) {
            return { ok: false, message: "Missing bearer token" };
        }
        try {
            var payload = variables.jwt.decode(token, variables.settings.jwtSecret(), "HS256");
            if (!structKeyExists(payload, "sub") || !structKeyExists(payload, "email") || !structKeyExists(payload, "role")) {
                return { ok: false, message: "Token is missing claims" };
            }
            return {
                ok: true,
                user: {
                    id: val(payload.sub),
                    email: payload.email,
                    role: payload.role
                }
            };
        } catch (any e) {
            return { ok: false, message: "Invalid or expired token" };
        }
    }

    public struct function verifyToken(required string token) {
        var payload = variables.jwt.decode(token, variables.settings.jwtSecret(), "HS256");
        return payload;
    }

    private string function bearerToken(required struct headers) {
        var header = "";
        for (var key in headers) {
            if (lCase(key) == "authorization") {
                header = headers[key];
                break;
            }
        }
        if (!len(header)) {
            return "";
        }
        if (left(lCase(header), 7) != "bearer ") {
            return "";
        }
        return trim(mid(header, 8, len(header)));
    }

    private any function createJwt() {
        try {
            return new jwtcfml.models.jwt();
        } catch (any e) {
            throw(
                type = "Auth.JwtMissing",
                message = "jwt-cfml is not installed. Run box install in cl-server. " & e.message
            );
        }
    }

}
