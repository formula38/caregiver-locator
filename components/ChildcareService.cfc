component {
    // Method to search childcare providers based on location, budget and subsidies
    public array function searchProviders(string location, numeric maxPrice, boolean subsidiesAvailable) {
        var query = "
            SELECT * FROM ChildcareProviders
            WHERE location LIKE :location
            AND price <= :maxPrice
            AND (subsidiesAvailable = :subsidiesAvailable OR :subsidiesAvailable IS NULL)
            ";

        var params = {
            location = "%" & location & "%",
            maxPrice = maxPrice,
            subsidiesAvailable = subsidiesAvailable
        };

        var result = queryExecute(query, params);
        return result;
    }
}
