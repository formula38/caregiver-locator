component {

    public any function init() {
        variables.matches = new services.MatchService();
        variables.response = new lib.Response();
        variables.validation = new lib.Validation();
        return this;
    }

    public struct function search(required struct requestContext) {
        var qs = requestContext.queryString;
        var errors = variables.validation.requireFields(qs, ["requiredCare", "location"]);
        if (arrayLen(errors)) {
            return variables.response.unprocessable(errors);
        }
        var rating = structKeyExists(qs, "rating") && isNumeric(qs.rating) ? val(qs.rating) : 0;
        var results = variables.matches.search(
            requiredCare = qs.requiredCare,
            location = qs.location,
            rating = rating
        );
        return variables.response.ok({ "matches": results });
    }

    public struct function save(required struct requestContext) {
        if (requestContext.user.role != "recipient") {
            return variables.response.forbidden("Only recipients can save a match");
        }
        var body = requestContext.body;
        var errors = variables.validation.requireFields(body, ["providerId"]);
        if (arrayLen(errors)) {
            return variables.response.unprocessable(errors);
        }
        var saved = variables.matches.save(
            recipientId = requestContext.user.id,
            providerId = val(body.providerId)
        );
        return variables.response.created({ "match": saved });
    }

    public struct function listMine(required struct requestContext) {
        return variables.response.ok({
            "matches": variables.matches.listForUser(requestContext.user.id)
        });
    }

    public struct function accept(required struct requestContext) {
        try {
            var accepted = variables.matches.accept(
                matchId = val(requestContext.params.id),
                actorId = requestContext.user.id
            );
            if (isNull(accepted)) {
                return variables.response.notFound("Match not found");
            }
            return variables.response.ok({ "match": accepted });
        } catch (MatchService.Forbidden e) {
            return variables.response.forbidden(e.message);
        }
    }

}
