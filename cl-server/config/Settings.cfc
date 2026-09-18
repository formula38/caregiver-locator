component {

    function env(required string name, string fallback = "") {
        var system = createObject("java", "java.lang.System");
        var fromProps = system.getProperty(name);
        if (!isNull(fromProps) && len(fromProps)) {
            return fromProps;
        }
        var fromEnv = system.getEnv(name);
        if (!isNull(fromEnv) && len(fromEnv)) {
            return fromEnv;
        }
        return fallback;
    }

    function datasourceName() {
        return "caregiver";
    }

    function dbHost() {
        return env("POSTGRES_HOST", "db");
    }

    function dbPort() {
        return env("POSTGRES_PORT", "5432");
    }

    function dbName() {
        return env("POSTGRES_DB", "caregiver_locator");
    }

    function dbUser() {
        return env("POSTGRES_USER", "cfuser");
    }

    function dbPassword() {
        return env("POSTGRES_PASSWORD", "");
    }

    function jwtSecret() {
        var secret = env("JWT_SECRET", "");
        if (!len(secret)) {
            throw(type = "Settings.MissingSecret", message = "JWT_SECRET is not set");
        }
        return secret;
    }

    function jwtIssuer() {
        return env("JWT_ISSUER", "caregiver-locator");
    }

    function jwtTtlSeconds() {
        return val(env("JWT_TTL_SECONDS", "86400"));
    }

    function corsOrigins() {
        return listToArray(env("CORS_ALLOWED_ORIGINS", "http://localhost:4200"));
    }

    function appEnv() {
        return env("APP_ENV", "production");
    }

    function isDevelopment() {
        return appEnv() == "development";
    }

    function seedDemoData() {
        return env("SEED_DEMO_DATA", "false") == "true";
    }

}
