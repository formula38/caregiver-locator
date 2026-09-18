component {

    public any function init() {
        variables.reviews = new services.ReviewService();
        variables.response = new lib.Response();
        variables.validation = new lib.Validation();
        return this;
    }

    public struct function create(required struct requestContext) {
        var body = requestContext.body;
        var errors = variables.validation.requireFields(body, ["revieweeId", "rating"]);
        if (structKeyExists(body, "rating")) {
            errors = variables.validation.merge(
                errors,
                variables.validation.integerInRange(body.rating, 1, 5, "rating")
            );
        }
        if (arrayLen(errors)) {
            return variables.response.unprocessable(errors);
        }
        try {
            var review = variables.reviews.create(
                reviewerId = requestContext.user.id,
                revieweeId = val(body.revieweeId),
                rating = int(val(body.rating)),
                comment = structKeyExists(body, "comment") ? toString(body.comment) : ""
            );
            return variables.response.created({ "review": review });
        } catch (ReviewService.Invalid e) {
            return variables.response.badRequest(e.message);
        }
    }

    public struct function list(required struct requestContext) {
        var revieweeId = 0;
        if (structKeyExists(requestContext.queryString, "revieweeId") && isNumeric(requestContext.queryString.revieweeId)) {
            revieweeId = val(requestContext.queryString.revieweeId);
        }
        return variables.response.ok({
            "reviews": variables.reviews.list(revieweeId)
        });
    }

}
