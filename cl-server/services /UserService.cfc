component {
    function registerUser(email, password, firstName, lastName, role) {
        var hashedPassword = hash(password, "SHA-256");

        queryExecute("
            INSERT INTO users (email, password, firstName, lastName, role)
            VALUES (:email, :password, :firstName, :lastName, :role)
        ", {
            email: email,
            password: hashedPassword,
            firstName: firstName,
            lastName: lastName,
            role: role
        });
    }
}
