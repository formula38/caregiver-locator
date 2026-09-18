component {

    variables.algorithm = "PBKDF2WithHmacSHA256";
    variables.iterations = 100000;
    variables.keySize = 256;

    public struct function hashPassword(required string password) {
        var salt = generateSalt();
        return {
            salt: salt,
            hash: derive(password, salt)
        };
    }

    public boolean function verify(required string password, required string hash, required string salt) {
        return derive(password, salt) == hash;
    }

    private string function derive(required string password, required string salt) {
        return generatePBKDFKey(
            variables.algorithm,
            arguments.password,
            arguments.salt,
            variables.iterations,
            variables.keySize
        );
    }

    private string function generateSalt() {
        return lCase(replace(createUUID() & createUUID(), "-", "", "all"));
    }

}
