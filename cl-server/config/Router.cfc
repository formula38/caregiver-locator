component {

    public any function init() {
        variables.response = new lib.Response();
        variables.auth = new lib.Auth();
        variables.routes = [
            { method: "GET",  pattern: "^/api/health$", handler: "HealthHandler", action: "show", auth: false },
            { method: "POST", pattern: "^/api/users/register$", handler: "UserHandler", action: "register", auth: false },
            { method: "POST", pattern: "^/api/users/login$", handler: "UserHandler", action: "login", auth: false },
            { method: "GET",  pattern: "^/api/users/me$", handler: "UserHandler", action: "me", auth: true },
            { method: "GET",  pattern: "^/api/profiles/me$", handler: "ProfileHandler", action: "showMine", auth: true },
            { method: "PUT",  pattern: "^/api/profiles/me$", handler: "ProfileHandler", action: "updateMine", auth: true },
            { method: "GET",  pattern: "^/api/profiles/([0-9]+)$", handler: "ProfileHandler", action: "show", auth: true, params: ["id"] },
            { method: "GET",  pattern: "^/api/matches/mine$", handler: "MatchHandler", action: "listMine", auth: true },
            { method: "GET",  pattern: "^/api/matches$", handler: "MatchHandler", action: "search", auth: true },
            { method: "POST", pattern: "^/api/matches$", handler: "MatchHandler", action: "save", auth: true },
            { method: "POST", pattern: "^/api/matches/([0-9]+)/accept$", handler: "MatchHandler", action: "accept", auth: true, params: ["id"] },
            { method: "POST", pattern: "^/api/reviews$", handler: "ReviewHandler", action: "create", auth: true },
            { method: "GET",  pattern: "^/api/reviews$", handler: "ReviewHandler", action: "list", auth: true },
            { method: "POST", pattern: "^/api/messages$", handler: "MessageHandler", action: "send", auth: true },
            { method: "GET",  pattern: "^/api/messages/([0-9]+)$", handler: "MessageHandler", action: "thread", auth: true, params: ["userId"] },
            { method: "GET",  pattern: "^/api/messages$", handler: "MessageHandler", action: "threads", auth: true }
        ];
        return this;
    }

    public struct function handle(
        required string method,
        required string path,
        required struct headers,
        required struct body,
        required struct queryString
    ) {
        var route = matchRoute(uCase(method), path);
        if (isNull(route) || !isStruct(route)) {
            return variables.response.notFound("No route for " & method & " " & path);
        }

        var requestContext = {
            method: method,
            path: path,
            headers: headers,
            body: body,
            queryString: queryString,
            params: route.captures,
            user: {}
        };

        if (route.auth) {
            var authResult = variables.auth.requireUser(headers);
            if (!authResult.ok) {
                return variables.response.unauthorized(authResult.message);
            }
            requestContext.user = authResult.user;
        }

        var handler = createObject("component", "handlers." & route.handler).init();
        return invoke(handler, route.action, [requestContext]);
    }

    private any function matchRoute(required string method, required string path) {
        for (var route in variables.routes) {
            if (uCase(route.method) != method) {
                continue;
            }
            var groups = reMatchNoCase(route.pattern, path);
            if (arrayLen(groups) == 0) {
                continue;
            }
            var captures = {};
            if (structKeyExists(route, "params")) {
                var full = reFindNoCase(route.pattern, path, 1, true);
                if (structKeyExists(full, "len") && arrayLen(full.len) > 1) {
                    for (var i = 1; i <= arrayLen(route.params); i++) {
                        var start = full.pos[i + 1];
                        var length = full.len[i + 1];
                        captures[route.params[i]] = mid(path, start, length);
                    }
                }
            }
            return {
                handler: route.handler,
                action: route.action,
                auth: route.auth,
                captures: captures
            };
        }
        return;
    }

}
