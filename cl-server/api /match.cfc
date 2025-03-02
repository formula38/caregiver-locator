component restpath="match" {
    remote function findMatches() httpMethod="GET" restargsource="url" {
        param name="requiredCare" type="string" required=true;
        param name="location" type="string" required=true;
        param name="rating" type="numeric" required=true;

        return createObject("component", "handlers.MatchHandler").findMatches(requiredCare, location, rating);
    }
}
