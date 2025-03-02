component {
    function findMatches(requiredCare, location, rating) {
        var matches = queryExecute("
            SELECT * FROM users WHERE role = 'provider'
            AND careServices LIKE :requiredCare
            AND location = :location
            AND rating >= :rating
        ", {
            requiredCare: "%" & requiredCare & "%",
            location: location,
            rating: rating
        });

        return matches;
    }
}
