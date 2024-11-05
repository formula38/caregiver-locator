component {
    // Method to fetch reviews for a specific childcare provider
    public array function getReviewsForProvider(numeric providerId) {
        var query = "SELECT * FROM Reviews WHERE providerId = :providerId";
        var result = queryExecute(query, { providerId = providerId });
        return result;
    }
}
