component {

    public struct function ok(any data = {}) {
        return envelope(200, { "ok": true, "data": data });
    }

    public struct function created(any data = {}) {
        return envelope(201, { "ok": true, "data": data });
    }

    public struct function badRequest(required string message) {
        return envelope(400, { "ok": false, "error": message });
    }

    public struct function unauthorized(string message = "Unauthorized") {
        return envelope(401, { "ok": false, "error": message });
    }

    public struct function forbidden(string message = "Forbidden") {
        return envelope(403, { "ok": false, "error": message });
    }

    public struct function notFound(string message = "Not found") {
        return envelope(404, { "ok": false, "error": message });
    }

    public struct function conflict(required string message) {
        return envelope(409, { "ok": false, "error": message });
    }

    public struct function unprocessable(required array errors) {
        return envelope(422, { "ok": false, "errors": errors });
    }

    public struct function serverError(string message = "Internal server error") {
        return envelope(500, { "ok": false, "error": message });
    }

    private struct function envelope(required numeric status, required struct body) {
        return { "status": status, "body": body };
    }

}
