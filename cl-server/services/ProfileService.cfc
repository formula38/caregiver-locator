component {

    public any function init() {
        variables.db = new lib.Db();
        return this;
    }

    public any function findByUserId(required numeric userId) {
        var qry = variables.db.execute("
            SELECT
                p.id,
                p.user_id,
                p.care_services,
                p.location,
                p.rating,
                p.bio,
                u.first_name,
                u.last_name,
                u.email,
                u.role
            FROM profiles p
            INNER JOIN users u ON u.id = p.user_id
            WHERE p.user_id = ?
        ", [variables.db.p(userId, "cf_sql_integer")]);
        var row = variables.db.first(qry);
        if (isNull(row)) {
            return;
        }
        return toPublicProfile(row);
    }

    public struct function updateMine(
        required numeric userId,
        string careServices = "",
        string location = "",
        string bio = ""
    ) {
        variables.db.execute("
            UPDATE profiles
            SET care_services = ?, location = ?, bio = ?
            WHERE user_id = ?
        ", [
            variables.db.p(careServices, "cf_sql_varchar", true),
            variables.db.p(location, "cf_sql_varchar", true),
            variables.db.p(bio, "cf_sql_varchar", true),
            variables.db.p(userId, "cf_sql_integer")
        ]);
        return findByUserId(userId);
    }

    public struct function toPublicProfile(required struct row) {
        return {
            "id": row.id,
            "userId": row.user_id,
            "firstName": row.first_name,
            "lastName": row.last_name,
            "email": row.email,
            "role": row.role,
            "careServices": isNull(row.care_services) ? "" : row.care_services,
            "location": isNull(row.location) ? "" : row.location,
            "rating": isNumeric(row.rating) ? val(row.rating) : 0,
            "bio": isNull(row.bio) ? "" : row.bio
        };
    }

}
