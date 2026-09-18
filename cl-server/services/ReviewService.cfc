component {

    public any function init() {
        variables.db = new lib.Db();
        return this;
    }

    public struct function create(
        required numeric reviewerId,
        required numeric revieweeId,
        required numeric rating,
        string comment = ""
    ) {
        if (reviewerId == revieweeId) {
            throw(type = "ReviewService.Invalid", errorCode = "SELF_REVIEW", message = "You cannot review yourself");
        }
        var inserted = variables.db.execute("
            INSERT INTO reviews (reviewer_id, reviewee_id, rating, comment)
            VALUES (?, ?, ?, ?)
            RETURNING id, reviewer_id, reviewee_id, rating, comment, created_at
        ", [
            variables.db.p(reviewerId, "cf_sql_integer"),
            variables.db.p(revieweeId, "cf_sql_integer"),
            variables.db.p(rating, "cf_sql_integer"),
            variables.db.p(comment, "cf_sql_varchar", true)
        ]);
        recomputeRating(revieweeId);
        return toPublicReview(variables.db.first(inserted));
    }

    public array function list(numeric revieweeId = 0) {
        var sql = "
            SELECT
                r.id,
                r.reviewer_id,
                r.reviewee_id,
                r.rating,
                r.comment,
                r.created_at,
                ru.first_name AS reviewer_first_name,
                ru.last_name AS reviewer_last_name
            FROM reviews r
            INNER JOIN users ru ON ru.id = r.reviewer_id
        ";
        var params = [];
        if (revieweeId > 0) {
            sql &= " WHERE r.reviewee_id = ?";
            arrayAppend(params, variables.db.p(revieweeId, "cf_sql_integer"));
        }
        sql &= " ORDER BY r.created_at DESC";
        var qry = variables.db.execute(sql, params);
        var results = [];
        for (var row in qry) {
            var item = toPublicReview(row);
            item["reviewerName"] = row.reviewer_first_name & " " & row.reviewer_last_name;
            arrayAppend(results, item);
        }
        return results;
    }

    public numeric function recomputeRating(required numeric revieweeId) {
        var stats = variables.db.execute("
            SELECT COALESCE(ROUND(CAST(AVG(rating) AS numeric), 2), 0) AS avg_rating
            FROM reviews
            WHERE reviewee_id = ?
        ", [variables.db.p(revieweeId, "cf_sql_integer")]);
        var avgRating = val(variables.db.first(stats).avg_rating);
        variables.db.execute("
            UPDATE profiles
            SET rating = ?
            WHERE user_id = ?
        ", [
            variables.db.p(avgRating, "cf_sql_decimal"),
            variables.db.p(revieweeId, "cf_sql_integer")
        ]);
        return avgRating;
    }

    public numeric function rollup(required array ratings) {
        if (arrayLen(ratings) == 0) {
            return 0;
        }
        var total = 0;
        for (var rating in ratings) {
            total += val(rating);
        }
        return round((total / arrayLen(ratings)) * 100) / 100;
    }

    private struct function toPublicReview(required struct row) {
        return {
            "id": row.id,
            "reviewerId": row.reviewer_id,
            "revieweeId": row.reviewee_id,
            "rating": row.rating,
            "comment": isNull(row.comment) ? "" : row.comment,
            "createdAt": structKeyExists(row, "created_at") ? toString(row.created_at) : ""
        };
    }

}
