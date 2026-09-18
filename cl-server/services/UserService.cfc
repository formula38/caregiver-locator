component {

    public any function init() {
        variables.db = new lib.Db();
        variables.passwords = new lib.Password();
        return this;
    }

    public struct function register(
        required string email,
        required string password,
        required string firstName,
        required string lastName,
        required string role
    ) {
        if (!isNull(findByEmail(email))) {
            throw(type = "UserService.DuplicateEmail", errorCode = "DUPLICATE_EMAIL", message = "Email already registered");
        }
        var hashed = variables.passwords.hashPassword(password);
        var inserted = variables.db.execute("
            INSERT INTO users (first_name, last_name, email, password_hash, password_salt, role)
            VALUES (?, ?, ?, ?, ?, ?)
            RETURNING id, first_name, last_name, email, role, created_at
        ", [
            variables.db.p(firstName),
            variables.db.p(lastName),
            variables.db.p(lCase(trim(email))),
            variables.db.p(hashed.hash),
            variables.db.p(hashed.salt),
            variables.db.p(role)
        ]);
        var user = toPublicUser(variables.db.first(inserted));
        variables.db.execute("INSERT INTO profiles (user_id) VALUES (?)", [
            variables.db.p(user.id, "cf_sql_integer")
        ]);
        return user;
    }

    public any function authenticate(required string email, required string password) {
        var row = findAuthRow(email);
        if (isNull(row)) {
            return;
        }
        if (!variables.passwords.verify(password, row.password_hash, row.password_salt)) {
            return;
        }
        return toPublicUser(row);
    }

    public any function findById(required numeric id) {
        var qry = variables.db.execute("
            SELECT id, first_name, last_name, email, role, created_at
            FROM users
            WHERE id = ?
        ", [variables.db.p(id, "cf_sql_integer")]);
        var row = variables.db.first(qry);
        if (isNull(row)) {
            return;
        }
        return toPublicUser(row);
    }

    public any function findByEmail(required string email) {
        var qry = variables.db.execute("
            SELECT id, first_name, last_name, email, role, created_at
            FROM users
            WHERE email = ?
        ", [variables.db.p(lCase(trim(email)))]);
        var row = variables.db.first(qry);
        if (isNull(row)) {
            return;
        }
        return toPublicUser(row);
    }

    public struct function toPublicUser(required struct row) {
        return {
            "id": row.id,
            "firstName": row.first_name,
            "lastName": row.last_name,
            "email": row.email,
            "role": row.role
        };
    }

    private any function findAuthRow(required string email) {
        var qry = variables.db.execute("
            SELECT id, first_name, last_name, email, role, password_hash, password_salt, created_at
            FROM users
            WHERE email = ?
        ", [variables.db.p(lCase(trim(email)))]);
        return variables.db.first(qry);
    }

}
