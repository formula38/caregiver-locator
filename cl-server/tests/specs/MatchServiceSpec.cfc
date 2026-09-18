component displayName="MatchServiceSpec" extends="testbox.system.BaseSpec" {

    function run() {
        describe("MatchService.filterProviders", function () {
            it("keeps providers that match care, location, and minimum rating", function () {
                var matches = new services.MatchService();
                var providers = [
                    { id: 1, careServices: "personal_care,medication", location: "Oakland", rating: 4.5 },
                    { id: 2, careServices: "companion", location: "Oakland", rating: 5 },
                    { id: 3, careServices: "personal_care", location: "Berkeley", rating: 5 },
                    { id: 4, careServices: "personal_care", location: "Oakland", rating: 2 }
                ];
                var results = matches.filterProviders(providers, "personal_care", "Oakland", 4);
                expect(arrayLen(results)).toBe(1);
                expect(results[1].id).toBe(1);
            });
        });
    }

}
