component {
    public array function searchProviders(string location, string specialization, boolean availability) {
        var query = "
            SELECT * FROM CareProvider
            WHERE location LIKE :location
            AND specialization LIKE :specialization
            AND availability = :availability
        ";

        var params = {
            location = "%" & location & "%",
            specialization = "%" & specialization & "%",
            availability = availability
        };

        var result = queryExecute(query, params);
        return result;
    }
}

