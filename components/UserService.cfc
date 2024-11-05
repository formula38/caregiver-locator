component {
    public boolean function registerUser(string email, string password) {
        var hashPassword = hash(password, "SHA-256");
        var query = "INSERT INTO Users (email, password) VALUES (:email, :password)";
        queryExecute(query, {email = email, password = hashPassword});
        return true;
    }

    public boolean function authenticateUser(string email, string password) {
        var hashPassword = hash(password, "SHA-256");
        var query = "SELECT * FROM Users WHERE email = :email AND password = :password";
        var result = queryExecute(query, {email = email, password = hashPassword});
        return arrayLen(result) > 0;
    }
}
