component {
    remote function registerUser(email, password, firstName, lastName, role) {
        var hashedPassword = hash(password, "SHA-256");
        var newUser = entityNew("User");
        
        newUser.setEmail(email);
        newUser.setPassword(hashedPassword);
        newUser.setFirstName(firstName);
        newUser.setLastName(lastName);
        newUser.setRole(role);
        
        entitySave(newUser);
        
        return { success: true, message: "User registered successfully!" };
    }

    remote function getUserByEmail(email) {
        return entityLoad("User", { email: email })[1] ?: { error: "User not found" };
    }
}
