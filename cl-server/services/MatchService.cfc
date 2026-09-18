component {

    public any function init() {
        variables.db = new lib.Db();
        return this;
    }

    public array function search(required string requiredCare, required string location, required numeric rating) {
        var qry = variables.db.execute("
            SELECT
                u.id,
                u.first_name,
                u.last_name,
                u.email,
                u.role,
                p.care_services,
                p.location,
                p.rating,
                p.bio
            FROM users u
            INNER JOIN profiles p ON p.user_id = u.id
            WHERE u.role = 'provider'
              AND p.location = ?
              AND p.care_services ILIKE ?
              AND p.rating >= ?
            ORDER BY p.rating DESC, u.last_name ASC
        ", [
            variables.db.p(location),
            variables.db.p("%" & requiredCare & "%"),
            variables.db.p(rating, "cf_sql_decimal")
        ]);
        var results = [];
        for (var row in qry) {
            arrayAppend(results, {
                "id": row.id,
                "firstName": row.first_name,
                "lastName": row.last_name,
                "email": row.email,
                "role": row.role,
                "careServices": isNull(row.care_services) ? "" : row.care_services,
                "location": isNull(row.location) ? "" : row.location,
                "rating": isNumeric(row.rating) ? val(row.rating) : 0,
                "bio": isNull(row.bio) ? "" : row.bio
            });
        }
        return results;
    }

    public struct function save(required numeric recipientId, required numeric providerId) {
        var existing = variables.db.execute("
            SELECT id, recipient_id, provider_id, status, created_at
            FROM matches
            WHERE recipient_id = ? AND provider_id = ?
        ", [
            variables.db.p(recipientId, "cf_sql_integer"),
            variables.db.p(providerId, "cf_sql_integer")
        ]);
        var found = variables.db.first(existing);
        if (!isNull(found)) {
            return toPublicMatch(found);
        }
        var inserted = variables.db.execute("
            INSERT INTO matches (recipient_id, provider_id, status)
            VALUES (?, ?, 'pending')
            RETURNING id, recipient_id, provider_id, status, created_at
        ", [
            variables.db.p(recipientId, "cf_sql_integer"),
            variables.db.p(providerId, "cf_sql_integer")
        ]);
        return toPublicMatch(variables.db.first(inserted));
    }

    public array function listForUser(required numeric userId) {
        var qry = variables.db.execute("
            SELECT
                m.id,
                m.recipient_id,
                m.provider_id,
                m.status,
                m.created_at,
                ru.first_name AS recipient_first_name,
                ru.last_name AS recipient_last_name,
                pu.first_name AS provider_first_name,
                pu.last_name AS provider_last_name
            FROM matches m
            INNER JOIN users ru ON ru.id = m.recipient_id
            INNER JOIN users pu ON pu.id = m.provider_id
            WHERE m.recipient_id = ? OR m.provider_id = ?
            ORDER BY m.created_at DESC
        ", [
            variables.db.p(userId, "cf_sql_integer"),
            variables.db.p(userId, "cf_sql_integer")
        ]);
        var results = [];
        for (var row in qry) {
            arrayAppend(results, {
                "id": row.id,
                "recipientId": row.recipient_id,
                "providerId": row.provider_id,
                "status": row.status,
                "createdAt": toString(row.created_at),
                "recipientName": row.recipient_first_name & " " & row.recipient_last_name,
                "providerName": row.provider_first_name & " " & row.provider_last_name
            });
        }
        return results;
    }

    public any function accept(required numeric matchId, required numeric actorId) {
        var qry = variables.db.execute("
            SELECT id, recipient_id, provider_id, status, created_at
            FROM matches
            WHERE id = ?
        ", [variables.db.p(matchId, "cf_sql_integer")]);
        var matchRow = variables.db.first(qry);
        if (isNull(matchRow)) {
            return;
        }
        if (matchRow.provider_id != actorId) {
            throw(type = "MatchService.Forbidden", errorCode = "FORBIDDEN", message = "Only the provider can accept this match");
        }
        var updated = variables.db.execute("
            UPDATE matches
            SET status = 'accepted'
            WHERE id = ?
            RETURNING id, recipient_id, provider_id, status, created_at
        ", [variables.db.p(matchId, "cf_sql_integer")]);
        return toPublicMatch(variables.db.first(updated));
    }

    public numeric function averageRating(required array ratings) {
        if (arrayLen(ratings) == 0) {
            return 0;
        }
        var total = 0;
        for (var rating in ratings) {
            total += val(rating);
        }
        return round((total / arrayLen(ratings)) * 100) / 100;
    }

    public array function filterProviders(required array providers, required string requiredCare, required string location, required numeric rating) {
        var results = [];
        for (var provider in providers) {
            var services = structKeyExists(provider, "careServices") ? provider.careServices : "";
            var loc = structKeyExists(provider, "location") ? provider.location : "";
            var score = structKeyExists(provider, "rating") ? val(provider.rating) : 0;
            if (loc == location && findNoCase(requiredCare, services) && score >= rating) {
                arrayAppend(results, provider);
            }
        }
        return results;
    }

    private struct function toPublicMatch(required struct row) {
        return {
            "id": row.id,
            "recipientId": row.recipient_id,
            "providerId": row.provider_id,
            "status": row.status,
            "createdAt": structKeyExists(row, "created_at") ? toString(row.created_at) : ""
        };
    }

}
