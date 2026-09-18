component displayName="ReviewServiceSpec" extends="testbox.system.BaseSpec" {

    function run() {
        describe("ReviewService.rollup", function () {
            it("returns zero for no reviews", function () {
                var reviews = new services.ReviewService();
                expect(reviews.rollup([])).toBe(0);
            });

            it("averages ratings to two decimal places so matching can filter on them", function () {
                var reviews = new services.ReviewService();
                expect(reviews.rollup([5, 4, 5])).toBe(4.67);
            });
        });
    }

}
